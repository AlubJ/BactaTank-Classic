/*
	ModelEditPanel
	-------------------------------------------------------------------------
	Script:			ModelEditPanel
	Version:		v1.00
	Created:		15/01/2025 by Alun Jones
	Description:	Model Edit Panel
	-------------------------------------------------------------------------
	History:
	 - Created 15/01/2025 by Alun Jones
	
	To Do:
*/

function ModelEditPanel() constructor
{
	// Window Size and Pos
	windowPos = [ round(WINDOW_SIZE[0] / 4 * 3) + 2, 26 ];
	windowSize = [ round(WINDOW_SIZE[0] / 4) - 6, round(WINDOW_SIZE[1]) - 30 ];
	
	ENVIRONMENT.dynamicBufferIndex = -1;
	
	editablesPopup = false;
	
	static render = function()
	{
		// Open Popup
		if (editablesPopup)
		{
			ImGui.OpenPopup("EditablesPopup");
			editablesPopup = false;
		}
		
		// Window Size and Pos
		windowPos = [ round(WINDOW_SIZE[0] / 4 * 3) + 2, 26 ];
		windowSize = [ round(WINDOW_SIZE[0] / 4) - 6, round(WINDOW_SIZE[1]) - 30 ];
		
		// Set Next Window Position and Size
		ImGui.SetNextWindowPos(windowPos[0], windowPos[1], ImGuiCond.Always);
		ImGui.SetNextWindowSize(windowSize[0], windowSize[1], ImGuiCond.Always);
		
		// Begin Window
		if (ImGui.Begin("ModelEditPanel", undefined, ImGuiWindowFlags.NoTitleBar | ImGuiWindowFlags.NoMove | ImGuiWindowFlags.NoResize))
		{
			// Header
			ImGui.Text("Editor");
			ImGui.Separator();
			
			// Get Cursor Pos
			var cursorPos = [ImGui.GetCursorPosX(), ImGui.GetCursorPosY()];
			
			// ... Button
			ImGui.SetCursorPos(windowSize[0] - 28, 6);
			if (ImGui.Button("...##hiddenEditablesMenu", 20, 20)) editablesPopup = true;
			
			// Reset Cursor Position
			ImGui.SetCursorPos(cursorPos[0], cursorPos[1]);
			
			// Check Selected
			if (ENVIRONMENT.attributeSelected == -1)
			{
				ImGui.Text("Please select an attribute.");
				ImGui.End();
				return;
			}
			
			// Characters List
			if (ImGui.BeginChild("Model Properties") && PROJECT.currentModel != -1)
			{
				// If A Texture Is Selected
				if (string_pos("TEX", ENVIRONMENT.attributeSelected))
				{
					renderTextureEditor();
				}
				else if (string_pos("MAT", ENVIRONMENT.attributeSelected))
				{
					renderMaterialEditor();
				}
				else if (string_pos("MESH", ENVIRONMENT.attributeSelected))
				{
					renderMeshEditor();
				}
				else if (string_pos("LAYER", ENVIRONMENT.attributeSelected))
				{
					renderLayerEditor();
				}
				else if (string_pos("LOC", ENVIRONMENT.attributeSelected))
				{
					renderLocatorEditor();
				}
				else if (string_pos("BONE", ENVIRONMENT.attributeSelected))
				{
					renderBoneEditor();
				}
				
				ImGui.EndChild();
			}
			
			// End Window
			ImGui.End();
		}
		
		// Popups
		if (string_pos("TEX", ENVIRONMENT.attributeSelected))
		{
			renderTexturePopup();
		}
		else if (string_pos("MAT", ENVIRONMENT.attributeSelected))
		{
			renderMaterialPopup();
		}
		else if (string_pos("MESH", ENVIRONMENT.attributeSelected))
		{
			renderMeshPopup();
		}
		else if (string_pos("LOC", ENVIRONMENT.attributeSelected))
		{
			renderLocatorPopup();
		}
	}
	
	static renderTextureEditor = function()
	{
		// Model
		var model = PROJECT.currentModel;
		var space = 150;
		
		// Get Sprite
		var index = string_digits(ENVIRONMENT.attributeSelected);
		var texture = model.textures[index];
		var sprite = model.textures[index].sprite;
		
		// Calc New Height
		var width = windowSize[0] - 16;
		var newHeight = floor((sprite_get_height(sprite) / sprite_get_width(sprite)) * width);
		
		// Draw Texture
		SECONDARY_CANVAS.resize(width, newHeight);
		SECONDARY_CANVAS.add(new CalicoTransparencyBackground(width, newHeight));
		SECONDARY_CANVAS.add(new CalicoSprite(sprite, 0, 0, 0, width, newHeight));
		SECONDARY_CANVAS.draw();
		
		// Draw Surface
		ImGui.Surface(SECONDARY_CANVAS.surface);
		
		// Spacing
		ImGui.Spacing();
		
		// Texture Details Text
		ImGui.Text("Texture Details");
		
		// Separator
		ImGui.Separator();
		
		// Texture Width (Change this to a split view)
		var width = model.textures[index].width;
		ImGui.InputTextCustom("Width", SETTINGS.displayHex ? "0x" + string_hex(width, 1) : width, "##hiddenTextureWidth", space, NO_DEFAULT, ImGuiInputTextFlags.ReadOnly);
		
		// Texture Height (Change this to a split view)
		var height = model.textures[index].height;
		ImGui.InputTextCustom("Height", SETTINGS.displayHex ? "0x" + string_hex(height, 1) : height, "##hiddenTextureHeight", space, NO_DEFAULT, ImGuiInputTextFlags.ReadOnly);
		
		// Data Size
		var size = model.textures[index].size;
		ImGui.InputTextCustom("Data Size", SETTINGS.displayHex ? "0x" + string_hex(size, 1) : size, "##hiddenTextureSize", space, NO_DEFAULT, ImGuiInputTextFlags.ReadOnly);
		
		// Compression
		var compression = model.textures[index].compression;
		ImGui.InputTextCustom("Compression Type", BT_DXT_COMPRESSION[compression], "##hiddenTextureCompression", space, NO_DEFAULT, ImGuiInputTextFlags.ReadOnly);
		
		// Offset
		var offset = model.textures[index].offset;
		ImGui.InputTextCustom("Offset", "0x" + string_hex(offset), "##hiddenTextureOffset", space, NO_DEFAULT, ImGuiInputTextFlags.ReadOnly);
	}
	
	static renderTexturePopup = function()
	{
		// Model
		var model = PROJECT.currentModel;
		var index = string_digits(ENVIRONMENT.attributeSelected);
		
		// Texture Editables Popup
		if (ImGui.BeginPopup("EditablesPopup"))
		{
			// Header
			ImGui.Text("Texture Menu");
			ImGui.Separator();
			
			// Menu Items
			if (ImGui.MenuItem("Export Texture",  SETTINGS.shortcuts.exportCurrentSelected)) uiExportTexture(model, index);
			if (ImGui.MenuItem("Replace Texture", SETTINGS.shortcuts.replaceCurrentSelected)) uiReplaceTexture(model, index);
			
			// End Popup
			ImGui.EndPopup();
		}
	}
	
	static renderMaterialEditor = function()
	{
		// Model
		var model = PROJECT.currentModel;
		var space = 120;
		var width = windowSize[0] - 16;
		
		// Get Material
		var index = string_digits(ENVIRONMENT.attributeSelected);
		var material = model.materials[index];
		
		// Renderer
		RENDERER.activate();
		SECONDARY_RENDERER.activate();
		SECONDARY_RENDERER.resize(width, width);
		
		// Step Camera
		//SECONDARY_RENDERER.orbitCamera(windowPos[0] + 8, windowPos[1] + 32);
		SECONDARY_RENDERER.camera.lookDistance = 2.5;
		SECONDARY_RENDERER.camera.lookDirection = -90;
		SECONDARY_RENDERER.camera.lookPitch = 0;
		SECONDARY_RENDERER.camera.lookAtPosition.x = 0;
		SECONDARY_RENDERER.camera.lookAtPosition.y = 0;
		SECONDARY_RENDERER.camera.lookAtPosition.z = 0;
		SECONDARY_RENDERER.camera.stepThird();
		array_push(SECONDARY_RENDERER.debugRenderQueue, {
			vertexBuffer: PRIMITIVES.sphere,
			material: material,
			textures: model.textures,
			matrix: matrix_build(0, 0, 0, 0, current_time / 50, 0, 1, 1, 1),
			shader: "StandardShader",
			primitive: pr_trianglestrip,
		});
		
		// Render Material Preview
		ImGui.Surface(SECONDARY_RENDERER.surface, c_white, 1, SECONDARY_RENDERER.width, SECONDARY_RENDERER.height);
		
		// Material Edit
		if (ImGui.BeginChild("MaterialEdit"))
		{
			// Colour Text
			ImGui.Spacing();
			ImGui.Text("Colour");
			
			// Separator
			ImGui.Separator();
			
			// Diffuse Colour
			var colour = new ImColor(material.colour[0] * 255, material.colour[1] * 255, material.colour[2] * 255, material.colour[3]);
			ImGui.ColourEditCustom("Blend Colour", colour, "##hiddenMaterialColour", space);
			material.colour[0] = colour.r / 255;
			material.colour[1] = colour.g / 255;
			material.colour[2] = colour.b / 255;
			material.colour[3] = colour.a;
			
			// Lock Behind Advanced Settings
			if (SETTINGS.advancedMaterialSettings) 
			{
				// Ambient Tint
				var colour = new ImColor(material.ambientTint[0] * 255, material.ambientTint[1] * 255, material.ambientTint[2] * 255, material.ambientTint[3]);
				ImGui.ColourEditCustom("Ambient Tint", colour, "##hiddenMaterialAmbientTint", space);
				material.ambientTint[0] = colour.r / 255;
				material.ambientTint[1] = colour.g / 255;
				material.ambientTint[2] = colour.b / 255;
				material.ambientTint[3] = colour.a;
				
				// Specular Tint
				var colour = new ImColor(material.specularTint[0] * 255, material.specularTint[1] * 255, material.specularTint[2] * 255, material.specularTint[3]);
				ImGui.ColourEditCustom("Specular Tint", colour, "##hiddenMaterialSpecularTint", space);
				material.specularTint[0] = colour.r / 255;
				material.specularTint[1] = colour.g / 255;
				material.specularTint[2] = colour.b / 255;
				material.specularTint[3] = colour.a;
			}
			
			// Textures Text
			ImGui.Spacing();
			ImGui.Text("Textures");
			
			// Separator
			ImGui.Separator();
			
			// Textures Array
			var textures = [  ];
			for (var i = -1, t = 0; i < array_length(model.textures); i++)
			{
				if (i == -1)
				{
					array_push(textures, $"No Texture (-1)");
					continue;
				}
				if (model.textures[i] == 0) array_push(textures, $"");
				else array_push(textures, $"Texture {i}");
			}
			
			// Texture Index
			material.textureID = ImGui.ComboBoxCustom("Texture Index", material.textureID + 1, textures, "##hiddenMaterialTextureID", space, NO_DEFAULT) - 1;
			
			// Specular Index
			if (SETTINGS.advancedMaterialSettings) material.specularID = ImGui.ComboBoxCustom("Specular Index", material.specularID + 1, textures, "##hiddenMaterialSpecularID", space, NO_DEFAULT) - 1;
			
			// Normal Index
			material.normalID = ImGui.ComboBoxCustom("Normal Index", material.normalID + 1, textures, "##hiddenMaterialNormalID", space, NO_DEFAULT) - 1;
			
			// Shine Index
			material.shineID = ImGui.ComboBoxCustom("Shine Index", material.shineID + 1, textures, "##hiddenMaterialShineID", space, NO_DEFAULT) - 1;
			
			// Cubemap Index
			if (SETTINGS.advancedMaterialSettings) material.cubemapID = ImGui.ComboBoxCustom("Cubemap Index", material.cubemapID + 1, textures, "##hiddenMaterialCubemapID", space, NO_DEFAULT) - 1;
			
			// Specular & Reflection Text
			ImGui.Spacing();
			ImGui.Text("Specular & Reflection");
			
			// Separator
			ImGui.Separator();
			
			// Specular Exponent
			material.specularExponent = ImGui.DragFloatCustom("Specular Exponent", material.specularExponent, "##hiddenMaterialSpecularExponent", 1, 0, 50, space, NO_DEFAULT);
			
			// Reflection Power
			material.reflectionPower = ImGui.DragFloatCustom("Reflection Power", material.reflectionPower, "##hiddenMaterialReflectionPower", 0.01, 0, 5, space, NO_DEFAULT);
			
			// Surface & Lighting Text
			ImGui.Spacing();
			ImGui.Text("Surface & Lighting");
			
			// Separator
			ImGui.Separator();
			
			// Disable Lighting Pass
			ImGui.SetCursorPos(ImGui.GetCursorPosX() + space, ImGui.GetCursorPosY());
			var flags = ImGui.CheckboxCustom("Disable Lighting Pass", material.shaderFlags & BT_NO_LIGHTING, "##hiddenMaterialDisableLightingPass", space);
			if (!flags) material.shaderFlags &= ~BT_NO_LIGHTING;
			else material.shaderFlags |= BT_NO_LIGHTING;
			
			// Use Shine Map
			ImGui.SetCursorPos(ImGui.GetCursorPosX() + space, ImGui.GetCursorPosY());
			var flags = ImGui.CheckboxCustom("Enable Shine Map", material.shaderFlags & BT_USE_SHINEMAP, "##hiddenMaterialEnableShineMap", space);
			if (!flags) material.shaderFlags &= ~BT_USE_SHINEMAP;
			else material.shaderFlags |= BT_USE_SHINEMAP;
			
			// Surface Type
			var flags = ImGui.ComboBoxCustom("Surface Type", (material.shaderFlags >> BT_SURFACE_SHIFT & BT_SURFACE_BITS), BT_SURFACE_TYPE, "##hiddenMaterialSurfaceType", space, NO_DEFAULT, ImGuiInputTextFlags.ReadOnly);
			material.shaderFlags = (material.shaderFlags & ~(BT_SURFACE_BITS << BT_SURFACE_SHIFT)) | flags << BT_SURFACE_SHIFT;
			
			// Lighting Type
			var flags = ImGui.ComboBoxCustom("Lighting", (material.shaderFlags >> BT_LIGHTING_SHIFT & BT_LIGHTING_BITS), BT_LIGHTING, "##hiddenMaterialLighting", space, NO_DEFAULT, ImGuiInputTextFlags.ReadOnly);
			material.shaderFlags = (material.shaderFlags & ~(BT_LIGHTING_BITS << BT_LIGHTING_SHIFT)) | flags << BT_LIGHTING_SHIFT;
			
			// Environment Map Type
			if (SETTINGS.advancedMaterialSettings) 
			{
				var flags = ImGui.ComboBoxCustom("Environment Map", (material.shaderFlags >> BT_ENVMAP_SHIFT & BT_ENVMAP_BITS), BT_ENVMAP_TYPE, "##hiddenMaterialEnvmapType", space, NO_DEFAULT, ImGuiInputTextFlags.ReadOnly);
				material.shaderFlags = (material.shaderFlags & ~(BT_ENVMAP_BITS << BT_ENVMAP_SHIFT)) | flags << BT_ENVMAP_SHIFT;
			}
			
			//show_message($"{material.shaderFlags} {flags} {BT_USE_SHINEMAP_SHIFT}");
			
			if (material.textureScrolls[0].enabled)
			{
				// Texture Scrolling
				ImGui.Spacing();
				ImGui.Text("Texture Scrolling");
				
				// Separator
				ImGui.Separator();
				
				// Scroll Type
				material.textureScrolls[0].type[0] = ImGui.ComboBoxCustom("Scroll Type X", material.textureScrolls[0].type[0], BT_UV_ANIM_TYPE, "##hiddenMaterialScrollTypeX", space, NO_DEFAULT);
				material.textureScrolls[0].type[1] = ImGui.ComboBoxCustom("Scroll Type Y", material.textureScrolls[0].type[1], BT_UV_ANIM_TYPE, "##hiddenMaterialScrollTypeY", space, NO_DEFAULT);
				
				// Scroll Speed
				ImGui.DragFloat2Custom("Scroll Speed", material.textureScrolls[0].speed, 0.01, -10, 10, "##hiddenMaterialScrollSpeed", space, NO_DEFAULT);
				
				// Trig Scale
				ImGui.DragFloat2Custom("Trig Scale", material.textureScrolls[0].trigScale, 0.01, -10, 10, "##hiddenMaterialTrigScale", space, NO_DEFAULT);
			}
			
			
			// Only If Advanced
			if (SETTINGS.advancedMaterialSettings) 
			{
				// Alpha Text
				ImGui.Spacing();
				ImGui.Text("Alpha Blending");
			
				// Separator
				ImGui.Separator();
			
				// Alpha Blend Type
				var flags = ImGui.ComboBoxCustom("Alpha Blend", (material.alphaBlend >> BT_ALPHA_BLEND_SHIFT & BT_ALPHA_BLEND_BITS), BT_ALPHA_BLEND, "##hiddenMaterialAlphaBlend", space, NO_DEFAULT, ImGuiInputTextFlags.ReadOnly);
				material.alphaBlend = (material.alphaBlend & ~(BT_ALPHA_BLEND_BITS << BT_ALPHA_BLEND_SHIFT)) | flags << BT_ALPHA_BLEND_SHIFT;
			
				// Depth Type
				var flags = ImGui.ComboBoxCustom("Depth Test", (material.alphaBlend >> BT_DEPTH_TYPE_SHIFT & BT_DEPTH_TYPE_BITS), BT_DEPTH_TYPE, "##hiddenMaterialDepthTest", space, NO_DEFAULT, ImGuiInputTextFlags.ReadOnly);
				material.alphaBlend = (material.alphaBlend & ~(BT_DEPTH_TYPE_BITS << BT_DEPTH_TYPE_SHIFT)) | flags << BT_DEPTH_TYPE_SHIFT;
			
				// Cullmode
				var flags = ImGui.ComboBoxCustom("Cullmode", (material.alphaBlend >> BT_CULLMODE_SHIFT & BT_CULLMODE_BITS), BT_CULLMODE, "##hiddenMaterialCullmode", space, NO_DEFAULT, ImGuiInputTextFlags.ReadOnly);
				material.alphaBlend = (material.alphaBlend & ~(BT_CULLMODE_BITS << BT_CULLMODE_SHIFT)) | flags << BT_CULLMODE_SHIFT;
			
				// Generate UV Map Layers
				var uvSets = [];
				for (var i = 0; i < array_length(material.vertexFormat); i++)
				{
					if (material.vertexFormat[i].attribute == BTVertexAttributes.uvSet1) array_push(uvSets, "UVSet1");
					else if (material.vertexFormat[i].attribute == BTVertexAttributes.uvSet2) array_push(uvSets, "UVSet2");
				}
			
				//// Check UV Sets First
				//if (array_length(uvSets) > 0)
				//{
				//	// UVSet Text
				//	ImGui.Spacing();
				//	ImGui.Text("UV Sets");
			
				//	// Separator
				//	ImGui.Separator();
					
				//	// Surface UV Set
				//	var uvIndex = ImGui.ComboBoxCustom("Surface UV Set", material.surfaceUVMapIndex - 1, uvSets, "##hiddenMaterialSurfaceUVSet", space, NO_DEFAULT, ImGuiInputTextFlags.ReadOnly) + 1;
				//	material.surfaceUVMapIndex = uvIndex;
					
				//	// Normal UV Set
				//	var uvIndex = ImGui.ComboBoxCustom("Normal UV Set", material.normalUVMapIndex - 1, uvSets, "##hiddenMaterialNormalUVSet", space, NO_DEFAULT, ImGuiInputTextFlags.ReadOnly) + 1;
				//	material.normalUVMapIndex = uvIndex;
					
				//	// Specular UV Set
				//	var uvIndex = ImGui.ComboBoxCustom("Specular UV Set", material.specularUVMapIndex - 1, uvSets, "##hiddenSpecularNormalUVSet", space, NO_DEFAULT, ImGuiInputTextFlags.ReadOnly) + 1;
				//	material.specularUVMapIndex = uvIndex;
				//}
			
				// Vertex Format Text
				ImGui.Spacing();
				ImGui.Text("Vertex Format");
			
				// Separator
				ImGui.Separator();
			
				// Decode Vertex Format
				var vertexFormat = material.vertexFormat
			
				// Vertex Format
				for (var i = 0; i < array_length(vertexFormat); i++)
				{
					// Get Position
					var cursorPos = [ImGui.GetCursorPosX(), ImGui.GetCursorPosY()];
				
					// Get Attribute and Type
					var attribute = BT_VERTEX_ATTRIBUTES[vertexFormat[i].attribute];
					var type = BT_VERTEX_ATTRIBUTE_TYPES[vertexFormat[i].type];
					var position = vertexFormat[i].position;
				
					// Selectable
					ImGui.Selectable($"  {attribute}##hiddenVertexFormatAttribute{i}");
					
					// Type Text
					ImGui.SetCursorPos(128, cursorPos[1]);
					ImGui.Text($"{type}");
					
					// Position Text
					ImGui.SetCursorPos(208, cursorPos[1]);
					ImGui.Text($"{SETTINGS.displayHex ? $"0x{string_hex(position, 2)}" : position}");
				}
			
				// Assigned To Text
				ImGui.Spacing();
				ImGui.Text("Assigned To");
			
				// Separator
				ImGui.Separator();
			
				// Assigned To
				for (var i = 0, m = 0; i < array_length(model.meshes); i++)
				{
					// Get Position
					var cursorPos = [ImGui.GetCursorPosX(), ImGui.GetCursorPosY()];
				
					// Get Material Index
					var meshMaterial = model.meshes[i].material;
				
					// Skip if Material Doesn't Match
					if (meshMaterial != index)
					{
						if (i == array_length(model.meshes) - 1 && m == 0)
						{
							ImGui.Selectable($"##hiddenMaterialAssignedMesh{i}");
							ImGui.SetCursorPos(cursorPos[0] + 20, cursorPos[1]);
							ImGui.Text($"No Meshes");
						}
						continue;
					}
				
					// Selectable
					ImGui.Selectable($"##hiddenMaterialAssignedMesh{i}");
					
					// Eye Icon
					ImGui.SetCursorPos(cursorPos[0] + 2, cursorPos[1] + 1);
					if (model.meshes[i].type == 6) ImGui.Image(graEye, 0);
					else if (model.meshes[i].type == 0 && model.meshes[i].vertexBufferObject == -1) ImGui.Image(graEye, 2);
					else if (model.meshes[i].type == 0) ImGui.Image(graEye, 1);
					
					// Attribute Text
					ImGui.SetCursorPos(cursorPos[0] + 20, cursorPos[1]);
					if (model.meshes[i].type == 6) ImGui.Text($"Mesh {i}");
					else if (model.meshes[i].type == 0 && model.meshes[i].vertexBufferObject == -1) ImGui.TextDisabled($"Mesh {i}");
					else if (model.meshes[i].type == 0) ImGui.TextDisabled($"Mesh {i}");
				
					// Increment M
					m++;
				}
			}
			
			// Vertex Format
			//ImGui.InputTextCustom("Vertex Format", $"0x{string_hex(material.vertexFormat)}", "##hiddenMaterialVertexFormat", space, NO_DEFAULT, ImGuiInputTextFlags.ReadOnly);
			
			// Other Information Text
			ImGui.Spacing();
			ImGui.Text("Other Information");
			
			// Separator
			ImGui.Separator();
			
			// Offset
			ImGui.InputTextCustom("Offset", $"0x{string_hex(model.nu20Offset + material.offset)}", "##hiddenMaterialOffset", space, NO_DEFAULT, ImGuiInputTextFlags.ReadOnly);
			
			// End Child
			ImGui.EndChild();
		}
	}
	
	static renderMaterialPopup = function()
	{
		// Model
		var model = PROJECT.currentModel;
		var index = string_digits(ENVIRONMENT.attributeSelected);
		
		// Materials Editables Popup
		if (ImGui.BeginPopup("EditablesPopup"))
		{
			// Header
			ImGui.Text("Material Menu");
			ImGui.Separator();
			
			// Menu Items
			if (ImGui.MenuItem("Export Material",  SETTINGS.shortcuts.exportCurrentSelected)) uiExportMaterial(model, index);
			if (ImGui.MenuItem("Replace Material", SETTINGS.shortcuts.replaceCurrentSelected)) uiReplaceMaterial(model, index);
			
			//ImGui.Separator();
			
			//if (ImGui.BeginMenu("Add Vertex Attribute"))
			//{
			//	if (ImGui.MenuItem("Add UV Set 2"))
			//	{
			//		model.materials[index].setVertexFormatUV();
			//	}
				
			//	ImGui.EndMenu();
			//}
			
			// Material Scripts
			var names = variable_struct_get_names(MATERIAL_SCRIPTS);
			
			// Validate
			if (array_length(names) > 0)
			{
				ImGui.Separator();
				
				// Material Tools
				for (var i = 0; i < array_length(names); i++)
				{
					if (ImGui.MenuItem(names[i])) catspeak_function_execute(MATERIAL_SCRIPTS[$ names[i]], [ model.materials[index] ]);
				}
			}
			
			// End Popup
			ImGui.EndPopup();
		}
	}
	
	static renderMeshEditor = function()
	{
		// Model
		var model = PROJECT.currentModel;
		var space = 120;
		var width = windowSize[0] - 16;
		
		// Get Material
		var index = string_digits(ENVIRONMENT.attributeSelected);
		var mesh = model.meshes[index];
		
		// Materials Array
		var materials = [  ];
		for (var i = 0; i < array_length(model.materials); i++)
		{
			array_push(materials, $"Material {i}");
		}
		
		// Bones Array
		var bones = [  ];
		if (PROJECT.currentModel.type == BTModelType.model)
		{
			for (var i = -1; i < array_length(model.bones); i++)
			{
				if (i == -1)
				{
					array_push(bones, $"-1 | No Bone");
					continue;
				}
				array_push(bones, $"{i} | {model.bones[i].name}");
			}
		}
		else
		{
			bones = ["-1 | No Bone"];
		}
		
		// Dynamic Buffer Array
		var dynamicBuffers = [  ];
		for (var i = -1; i < array_length(mesh.dynamicBuffers); i++)
		{
			if (i == -1)
			{
				array_push(dynamicBuffers, $"Basis ({i})");
				continue;
			}
			array_push(dynamicBuffers, $"Pose {i}");
		}
		
		// Renderer
		RENDERER.activate();
		SECONDARY_RENDERER.activate();
		if (window_updated() || SECONDARY_RENDERER.width != width || SECONDARY_RENDERER.height != width) SECONDARY_RENDERER.resize(width, width);
		
		// Step Camera
		if (!ENVIRONMENT.anyModalOpen()) SECONDARY_RENDERER.orbitCamera(windowPos[0] + 8, windowPos[1] + 32);
		array_push(SECONDARY_RENDERER.debugRenderQueue, ctrlRenderer.gridRenderStruct);
		if (mesh.vertexBufferObject != -1) array_push(SECONDARY_RENDERER.debugRenderQueue, {
			vertexBuffer: mesh.vertexBufferObject,
			material: model.materials[model.getMaterial(index)],
			textures: model.textures,
			matrix: matrix_build_identity(),
			shader: "StandardShader",
			primitive: pr_trianglestrip,
			dynamicBuffers: mesh.dynamicBuffers,
		});
		
		// Render Material Preview
		ImGui.Surface(SECONDARY_RENDERER.surface, c_white, 1, SECONDARY_RENDERER.width, SECONDARY_RENDERER.height);
		
		// Mesh Properties Child
		if (ImGui.BeginChild("MeshProperties"))
		{
			// Mesh Information Text
			ImGui.Spacing();
			ImGui.Text("Mesh Information");
		
			// Separator
			ImGui.Separator();
			
			// Dereferenced Mesh
			if (mesh.vertexBufferObject == -1)
			{
				ImGui.Text("Dereferenced Mesh");
				ImGui.EndChild();
				return;
			}
		
			// Primitive Type
			var type = ImGui.ComboBoxCustom("Primitive Type", mesh.type, ["None", "", "", "", "", "", "TriangleStrip"], "##hiddenMeshPrimitiveType", space, NO_DEFAULT, ImGuiInputTextFlags.ReadOnly);
			if (mesh.type != type)
			{
				mesh.type = type;
				RENDERER.flush();
				model.pushToRenderQueue(ENVIRONMENT.displayLayers, RENDERER, ENVIRONMENT.hideDisabledMeshes);
			}
			
			// Vertex Stride
			ImGui.InputTextCustom("Vertex Stride", SETTINGS.displayHex ? "0x" + string_hex(mesh.vertexStride, 1) : mesh.vertexStride, "##hiddenMeshVertexStride", space, NO_DEFAULT, ImGuiInputTextFlags.ReadOnly);
			
			// Vertex Count
			ImGui.InputTextCustom("Vertex Count", SETTINGS.displayHex ? "0x" + string_hex(mesh.vertexCount, 1) : mesh.vertexCount, "##hiddenMeshVertexCount", space, NO_DEFAULT, ImGuiInputTextFlags.ReadOnly);
			
			// Triangle Count
			ImGui.InputTextCustom("Triangle Count", SETTINGS.displayHex ? "0x" + string_hex(mesh.triangleCount, 1) : mesh.triangleCount, "##hiddenMeshTriangleCount", space, NO_DEFAULT, ImGuiInputTextFlags.ReadOnly);
			
			// Linked Bones Text
			ImGui.Spacing();
			ImGui.Text("Linked Bones");
			
			// Separator
			ImGui.Separator();
			
			// Linked Bones List
			for (var i = 0; i < 8; i++)
			{
				var bone = ImGui.ComboBoxCustom($"Bone {i}", mesh.bones[i] + 1, bones, $"##hiddenMeshBone{i}", space, NO_DEFAULT, ImGuiInputTextFlags.ReadOnly);
				mesh.bones[i] = bone - 1;
			}
			
			// Dynamic Buffers
			if (array_length(mesh.dynamicBuffers) > 0)
			{
				ImGui.Spacing();
				ImGui.Text("Dynamic Buffers");
				
				// Separator
				ImGui.Separator();
				for (var i = 0; i < array_length(dynamicBuffers); i++)
				{
					ImGui.Selectable($"##hidden{dynamicBuffers[i]}", false);
					ImGui.SameLine(16);
					ImGui.Text(dynamicBuffers[i]);
				}
			}
			
			// Other Information Text
			ImGui.Spacing();
			ImGui.Text("Other Information");
			
			// Separator
			ImGui.Separator();
			
			// Material
			var material = ImGui.ComboBoxCustom($"Material", model.getMaterial(index), materials, $"##hiddenMeshMaterial", space, NO_DEFAULT, ImGuiInputTextFlags.ReadOnly);
			if (material != model.getMaterial(index))
			{
				// TODO: add material method to get vertex stride from the vertex format, change vertex stride.
				model.setMaterial(index, material);
				RENDERER.flush();
				model.pushToRenderQueue(ENVIRONMENT.displayLayers, RENDERER, ENVIRONMENT.hideDisabledMeshes);
			}
			
			// Offset
			ImGui.InputTextCustom("Offset", $"0x{string_hex(model.nu20Offset + mesh.offset)}", "##hiddenMeshOffset", space, NO_DEFAULT, ImGuiInputTextFlags.ReadOnly);
			
			// Spacing
			ImGui.Spacing();
			
			ImGui.EndChild();
		}
	}
	
	static renderMeshPopup = function()
	{
		// Model
		var model = PROJECT.currentModel;
		var index = string_digits(ENVIRONMENT.attributeSelected);
		
		// Mesh Editables Popup
		if (ImGui.BeginPopup("EditablesPopup"))
		{
			// Header
			ImGui.Text("Mesh Menu");
			ImGui.Separator();
			
			// Menu Items
			if (ImGui.MenuItem("Export Mesh",                SETTINGS.shortcuts.exportCurrentSelected)) uiExportMesh(model, index);
			if (ImGui.MenuItem("Replace Mesh##hiddenButton", SETTINGS.shortcuts.replaceCurrentSelected))
			{
				uiReplaceMesh(model, index);
				//ENVIRONMENT.openModal("Replace Mesh");
			}
			ImGui.Separator();
			if (ImGui.MenuItem("Dereference Mesh", SETTINGS.shortcuts.dereferenceMesh))
			{
				ENVIRONMENT.openConfirmModal("Dereference Mesh", "Dereferencing this mesh will delete everything associated with this mesh. Are you sure you want to continue? This cannot be undone.", function(model, index) {
					// Dereference Mesh
					model.meshes[index].dereference();
					
					// Clear Render Queue and Push Model Again
					RENDERER.flush();
					model.pushToRenderQueue(ENVIRONMENT.displayLayers, RENDERER, ENVIRONMENT.hideDisabledMeshes);
					
					// Clear Secondary Renderers Queue
					SECONDARY_RENDERER.flush();
					
					// Enable Renderer
					RENDERER.activate();
					RENDERER.deactivate(2);
				}, [model, index]);
			}
			if (ImGui.MenuItem("Remove Dynamic Buffers"))
			{
				ENVIRONMENT.openConfirmModal("Remove Dynamic Buffers", "Removing dynamic buffers will remove all poses associated with this mesh. Are you sure you want to continue? This cannot be undone.", function(model, index) {
					// Remove Dynamic Buffers
					model.meshes[index].dynamicBuffers = [  ];
				}, [model, index]);
			}
			if (ImGui.MenuItem("Generate Static Skinning"))
			{
				ENVIRONMENT.openConfirmModal("Generate Static Skinning", "This will remove the skinning data from this mesh and skin it to one bone. Are you sure you want to continue? This cannot be undone.", function(model, index) {
					// Remove Dynamic Buffers
					model.meshes[index].generateStaticSkinning();
				}, [model, index]);
			}
			
			// Mesh Scripts
			var names = variable_struct_get_names(MESH_SCRIPTS);
			
			// Validate
			if (array_length(names) > 0)
			{
				ImGui.Separator();
				
				// Material Tools
				for (var i = 0; i < array_length(names); i++)
				{
					if (ImGui.MenuItem(names[i])) catspeak_function_execute(MESH_SCRIPTS[$ names[i]], [ model.meshes[index] ]);
				}
			}
			
			// End Popup
			ImGui.EndPopup();
		}
	}
	
	static renderLayerEditor = function()
	{
		// Model
		var model = PROJECT.currentModel;
		var space = 120;
		var width = windowSize[0] - 16;
		
		// Get Layer
		var index = string_digits(ENVIRONMENT.attributeSelected);
		var lay = model.layers[index];
		
		// Renderer
		RENDERER.activate();
		SECONDARY_RENDERER.activate();
		if (window_updated() || SECONDARY_RENDERER.width != width || SECONDARY_RENDERER.height != width) SECONDARY_RENDERER.resize(width, width);
		
		// Step Camera
		if (!ENVIRONMENT.anyModalOpen()) SECONDARY_RENDERER.orbitCamera(windowPos[0] + 8, windowPos[1] + 32);
		array_push(SECONDARY_RENDERER.debugRenderQueue, ctrlRenderer.gridRenderStruct);
		model.pushLayerToRenderQueue(index, SECONDARY_RENDERER);
		
		// Render Layer Preview
		ImGui.Surface(SECONDARY_RENDERER.surface, c_white, 1, SECONDARY_RENDERER.width, SECONDARY_RENDERER.height);
		
		// Layer Information Text
		ImGui.Spacing();
		ImGui.Text("Layer Information");
		
		// Separator
		ImGui.Separator();
		
		// Layer Name
		ImGui.InputTextCustom("Layer Name", lay.name, "##hiddenLayerName", space, NO_DEFAULT, ImGuiInputTextFlags.ReadOnly);
		
		// Layer Offset
		ImGui.InputTextCustom("Layer Offset", "0x" + string_hex(model.nu20Offset + lay.offset), "##hiddenLayerOffset", space, NO_DEFAULT, ImGuiInputTextFlags.ReadOnly);
		
		// Layer Meshes Child
		if (ImGui.BeginChild("Layer Meshes", 0, -1))
		{
			// Layer Meshes
			for (var m = 0; m < array_length(lay.meshes); m++)
			{
				// Layer Meshes Header
				ImGui.Spacing();
				ImGui.Text($"Layer Mesh {m}");
				
				// Layer Mesh Bone
				var bone = "-1 | None";
				if (lay.meshes[m].bone != -1) bone = $"{lay.meshes[m].bone} | {model.bones[lay.meshes[m].bone].name}";
				ImGui.InputTextCustom("Bone Index", bone, $"##hiddenLayerBone{m}", space, NO_DEFAULT, ImGuiInputTextFlags.ReadOnly);
				
				// Layer Mesh
				ImGui.InputTextCustom("Mesh Index", lay.meshes[m].mesh, $"##hiddenLayerMesh{m}", space, NO_DEFAULT, ImGuiInputTextFlags.ReadOnly);
				
				// Layer Material
				ImGui.InputTextCustom("Material Index", lay.meshes[m].material, $"##hiddenLayerMaterial{m}", space, NO_DEFAULT, ImGuiInputTextFlags.ReadOnly);
			}
			
			// End Child
			ImGui.EndChild();
		}
	}
	
	static renderLocatorEditor = function()
	{
		// Model
		var model = PROJECT.currentModel;
		var space = 120;
		var width = windowSize[0] - 16;
		
		// Get Layer
		var index = string_digits(ENVIRONMENT.attributeSelected);
		var locator = model.locators[index];
		
		// Bones Array
		var bones = [  ];
		for (var i = -1; i < array_length(model.bones); i++)
		{
			if (i == -1)
			{
				array_push(bones, $"-1 | No Bone");
				continue;
			}
			array_push(bones, $"{i} | {model.bones[i].name}");
		}
		
		// Locator Information Text
		ImGui.Spacing();
		ImGui.Text("Locator Information");
		
		// Separator
		ImGui.Separator();
		
		// Locator Name
		ImGui.InputTextCustom("Locator Name", locator.name, "##hiddenLocatorName", space, NO_DEFAULT, ImGuiInputTextFlags.ReadOnly);
		
		// Locator Parent
		var parent = ImGui.ComboBoxCustom($"Locator Parent", locator.parent + 1, bones, $"##hiddenLocatorParent", space, NO_DEFAULT, ImGuiInputTextFlags.ReadOnly);
		locator.parent = parent - 1;
		
		// Locator Transformation Text
		ImGui.Spacing();
		ImGui.Text("Locator Transformation");
		
		// Separator
		ImGui.Separator();
		
		// Locator Translation
		var locatorTranslation = ImGui.DragFloat3Custom("Locator Translation", locator.decomposedMatrix[0], 0.001, -360, 360, "##hiddenLocatorTranslation", space, NO_DEFAULT);
		if (locatorTranslation)
		{
			model.locators[index].matrix = matrix_build(locator.decomposedMatrix[0][0], locator.decomposedMatrix[0][1], locator.decomposedMatrix[0][2],
										  locator.decomposedMatrix[1][0], locator.decomposedMatrix[1][1], locator.decomposedMatrix[1][2],
										  locator.decomposedMatrix[2][0], locator.decomposedMatrix[2][1], locator.decomposedMatrix[2][2]);
		}
		
		// Locator Rotation
		var locatorRotation = ImGui.DragFloat3Custom("Locator Rotation", locator.decomposedMatrix[1], 0.1, -360, 360, "##hiddenLocatorRotation", space, NO_DEFAULT);
		if (locatorRotation)
		{
			model.locators[index].matrix = matrix_build(locator.decomposedMatrix[0][0], locator.decomposedMatrix[0][1], locator.decomposedMatrix[0][2],
										  locator.decomposedMatrix[1][0], locator.decomposedMatrix[1][1], locator.decomposedMatrix[1][2],
										  locator.decomposedMatrix[2][0], locator.decomposedMatrix[2][1], locator.decomposedMatrix[2][2]);
		}
		
		// Locator Scale
		var locatorScale = ImGui.DragFloat3Custom("Locator Scale", locator.decomposedMatrix[2], 0.1, -360, 360, "##hiddenLocatorScale", space, NO_DEFAULT);
		if (locatorScale)
		{
			model.locators[index].matrix = matrix_build(locator.decomposedMatrix[0][0], locator.decomposedMatrix[0][1], locator.decomposedMatrix[0][2],
										  locator.decomposedMatrix[1][0], locator.decomposedMatrix[1][1], locator.decomposedMatrix[1][2],
										  locator.decomposedMatrix[2][0], locator.decomposedMatrix[2][1], locator.decomposedMatrix[2][2]);
		}
		
		// Other Information Text
		ImGui.Spacing();
		ImGui.Text("Other Information");
		
		// Separator
		ImGui.Separator();
		
		// Locator Offset
		ImGui.InputTextCustom("Locator Offset", "0x" + string_hex(model.nu20Offset + locator.offset), "##LocatorLayerOffset", space, NO_DEFAULT, ImGuiInputTextFlags.ReadOnly);
	}
	
	static renderLocatorPopup = function()
	{
		// Model
		var model = PROJECT.currentModel;
		var index = string_digits(ENVIRONMENT.attributeSelected);
		
		// Locator Editables Popup
		if (ImGui.BeginPopup("EditablesPopup"))
		{
			// Header
			ImGui.Text("Locator Menu");
			ImGui.Separator();
			
			// Menu Items
			if (ImGui.MenuItem("Export Locator", SETTINGS.shortcuts.exportCurrentSelected)) uiExportLocator(model, index);
			if (ImGui.MenuItem("Replace Locator", SETTINGS.shortcuts.replaceCurrentSelected)) uiReplaceLocator(model, index);
			
			// End Popup
			ImGui.EndPopup();
		}
	}
	
	static renderBoneEditor = function()
	{
		// Model
		var model = PROJECT.currentModel;
		var space = 120;
		var width = windowSize[0] - 16;
		
		// Get Bone
		var index = string_digits(ENVIRONMENT.attributeSelected);
		var bone = model.armature.bones[index];
		
		// Get Parent Bone
		if (bone.parent != -1) var parent = model.armature.bones[bone.parent].name;
		else var parent = "None";
		
		// Bone Information Text
		ImGui.Spacing();
		ImGui.Text("Bone Information");
		
		// Separator
		ImGui.Separator();
		
		// Bone Name
		ImGui.InputTextCustom("Bone Name", bone.name, "##hiddenBoneName", space, NO_DEFAULT, ImGuiInputTextFlags.ReadOnly);
		
		// Bone Parent
		ImGui.InputTextCustom("Bone Parent", $"{bone.parent} | {parent}", "##hiddenBoneParent", space, NO_DEFAULT, ImGuiInputTextFlags.ReadOnly);
		
		// Bone Information Text
		ImGui.Spacing();
		ImGui.Text("Identity Pose");
		
		// Separator
		ImGui.Separator();
		
		// Bone Identity Matrix
		ImGui.DragMatrixCustom("Matrix", matrix_build_identity(), 0, 0, 9999, "##hiddenBoneIdentityMatrix", space, NO_DEFAULT, ImGuiInputTextFlags.ReadOnly);
		
		// Bone Identity Offset
		ImGui.InputTextCustom("Offset", "0x" + string_hex(model.nu20Offset + bone.offset), "##hiddenBoneIdentityMatrixOffset", space, NO_DEFAULT, ImGuiInputTextFlags.ReadOnly);
		
		// Bone Information Text
		ImGui.Spacing();
		ImGui.Text("Bind Pose");
		
		// Separator
		ImGui.Separator();
		
		// Bone Identity Matrix
		ImGui.DragMatrixCustom("Matrix", bone.bindMatrix, 0, 0, 9999, "##hiddenBoneBindMatrix", space, NO_DEFAULT, ImGuiInputTextFlags.ReadOnly);
		
		// Bone Identity Offset
		ImGui.InputTextCustom("Offset", "0x" + string_hex(model.nu20Offset + bone.bindOffset), "##hiddenBoneBindMatrixOffset", space, NO_DEFAULT, ImGuiInputTextFlags.ReadOnly);
		
		// Bone Information Text
		ImGui.Spacing();
		ImGui.Text("Inverse Bind Pose");
		
		// Separator
		ImGui.Separator();
		
		// Bone Identity Matrix
		ImGui.DragMatrixCustom("Matrix", bone.inverseBindMatrix, 0, 0, 9999, "##hiddenBoneInverseBindMatrix", space, NO_DEFAULT, ImGuiInputTextFlags.ReadOnly);
		
		// Bone Identity Offset
		ImGui.InputTextCustom("Offset", "0x" + string_hex(model.nu20Offset + bone.inverseBindOffset), "##hiddenBoneInverseBindMatrixOffset", space, NO_DEFAULT, ImGuiInputTextFlags.ReadOnly);
	}
}