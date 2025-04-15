/*
	ModelAttributesPanel
	-------------------------------------------------------------------------
	Script:			ModelAttributesPanel
	Version:		v1.00
	Created:		15/01/2025 by Alun Jones
	Description:	Model Attributes Panel List
	-------------------------------------------------------------------------
	History:
	 - Created 15/01/2025 by Alun Jones
	
	To Do:
*/

function ModelAttributesPanel() constructor
{
	
	attributes = PROJECT.currentModel.type == BTModelType.model ? [ "Textures", "Materials", "Meshes", "Bones", "Layers", "Locators" ] : [ "Textures", "Materials", "Meshes", "Special Objects" ];
	attributesOpen = [false, false, false, false, false, false, false, false, false, false, false, false];
	modelSelected = noone;
	ENVIRONMENT.attributeSelected = -1;
	
	static render = function()
	{
		// Window Size and Position
		var windowPos = [4, 26];
		var windowSize = [round(WINDOW_SIZE[0] / 4) - 6, round(WINDOW_SIZE[1]) - 30];
		
		// Set Next Window Position and Size		
		ImGui.SetNextWindowPos(windowPos[0], windowPos[1], ImGuiCond.Once);
		ImGui.SetNextWindowSize(windowSize[0], windowSize[1], ImGuiCond.Always);
		
		// Begin Window
		if (ImGui.Begin("ModelAttributePanel", undefined, ImGuiWindowFlags.NoTitleBar | ImGuiWindowFlags.NoMove | ImGuiWindowFlags.NoResize))
		{
			// Model
			if (CONTEXT == BTContext.Project) ImGui.ComboBoxCustom("Model", -1, MODELS, "##HiddenCharacterModel", 100);
			
			// Header
			if (CONTEXT == BTContext.Project) ImGui.Text("Model Attributes");
			else ImGui.Text(MODEL_NAME);
			
			ImGui.Separator();
			
			// Model Attributes List
			if (ImGui.BeginChild("ModelAttributes", -1, -1) && PROJECT.currentModel != -1)
			{
				// Set Pos
				var pos = [ImGui.GetCursorPosX(), ImGui.GetCursorPosY()];
				ImGui.SetCursorPos(pos[0], pos[1] + 4);
				
				// Attributes Dropdowns
				for (var i = 0; i < array_length(attributes); i++)
				{
					// Get Position
					var pos = [ImGui.GetCursorPosX(), ImGui.GetCursorPosY()];
					
					// Selectable
					//ImGui.Selectable($"##hiddenModelAttribute{i}", false, ImGuiSelectableFlags.AllowItemOverlap | ImGuiSelectableFlags.AllowOverlap);
					
					// Collapse Arrow
					ImGui.SetCursorPos(pos[0] + 2, pos[1] + 2);
					ImGui.Image(graCollapseArrow, attributesOpen[i]);
					if (ImGui.IsItemClicked()) attributesOpen[i] = !attributesOpen[i];
					
					// Attribute Text
					ImGui.SetCursorPos(pos[0] + 20, pos[1]);
					ImGui.Text(attributes[i]);
					
					// Attribute Open
					if (attributesOpen[i])
					{
						switch(attributes[i])
						{
							case "Textures":
								renderTextureList();
								break;
							case "Materials":
								renderMaterialList();
								break;
							case "Meshes":
								renderMeshList();
								break;
							case "Bones":
								renderBoneList();
								break;
							case "Layers":
								renderLayerList();
								break;
							case "Locators":
								renderLocatorList();
								break;
						}
					}
				}
				
				ImGui.EndChild();
			}
			
			// End Window
			ImGui.End();
		}
	}
	
	static renderTextureList = function()
	{
		var model = PROJECT.currentModel;
		for (var i = 0; i < array_length(model.textures); i++)
		{
			// Skip if empty texture
			if (model.textures[i] == 0) continue;
			
			// Get Position
			var pos = [ImGui.GetCursorPosX(), ImGui.GetCursorPosY()];
			
			// Selectable
			if (ImGui.Selectable($"##hiddenModelTexture{i}", ENVIRONMENT.attributeSelected == $"TEX{i}", ImGuiSelectableFlags.AllowItemOverlap | ImGuiSelectableFlags.AllowOverlap)) ENVIRONMENT.attributeSelected = $"TEX{i}";
			
			// Texture Icon
			ImGui.SetCursorPos(pos[0] + 22, pos[1] + 1);
			ImGui.Image(graImage, 0);
			
			// Attribute Text
			ImGui.SetCursorPos(pos[0] + 40, pos[1]);
			ImGui.Text($"Texture {i}");
		}
	}
	
	static renderMaterialList = function()
	{
		var model = PROJECT.currentModel;
		for (var i = 0; i < array_length(model.materials); i++)
		{
			// Get Position
			var pos = [ImGui.GetCursorPosX(), ImGui.GetCursorPosY()];
			
			// Selectable
			if (ImGui.Selectable($"##hiddenModelMaterial{i}", ENVIRONMENT.attributeSelected == $"MAT{i}", ImGuiSelectableFlags.AllowItemOverlap | ImGuiSelectableFlags.AllowOverlap)) ENVIRONMENT.attributeSelected = $"MAT{i}";
			
			// Decode Vertex Format
			var vertexFormat = model.materials[i].vertexFormat;
			var hasSkinning = false;
			
			// Vertex Format
			for (var j = 0; j < array_length(vertexFormat); j++)
			{
				// Get Position
				if (vertexFormat[j].attribute == BTVertexAttributes.blendIndices || vertexFormat[j].attribute == BTVertexAttributes.blendWeights) hasSkinning = true;
			}
			
			// Skinned Icon
			ImGui.SetCursorPos(pos[0] + 22, pos[1] + 1);
			if (hasSkinning) ImGui.Image(graSkinned, 1);
			else ImGui.Image(graSkinned, 0);
			
			// Attribute Text
			ImGui.SetCursorPos(pos[0] + 40, pos[1]);
			ImGui.Text($"Material {i}");
		}
	}
	
	static renderMeshList = function()
	{
		var model = PROJECT.currentModel;
		for (var i = 0; i < array_length(model.meshes); i++)
		{
			// Get Position
			var pos = [ImGui.GetCursorPosX(), ImGui.GetCursorPosY()];
			
			// Selectable
			if (ImGui.Selectable($"##hiddenModelMesh{i}", ENVIRONMENT.attributeSelected == $"MESH{i}", ImGuiSelectableFlags.AllowItemOverlap | ImGuiSelectableFlags.AllowOverlap))
			{
				if (ENVIRONMENT.attributeSelected != $"MESH{i}")
				{
					// Reset Secondary Camera
					SECONDARY_RENDERER.camera.lookDistance = 0.6;
					SECONDARY_RENDERER.camera.lookPitch = -20;
					SECONDARY_RENDERER.camera.lookDirection = -45;
					SECONDARY_RENDERER.camera.lookAtPosition.x = model.meshes[i].averagePosition[0];
					SECONDARY_RENDERER.camera.lookAtPosition.y = model.meshes[i].averagePosition[1];
					SECONDARY_RENDERER.camera.lookAtPosition.z = model.meshes[i].averagePosition[2];
				}
				ENVIRONMENT.attributeSelected = $"MESH{i}";
			}
			
			// Eye Icon
			ImGui.SetCursorPos(pos[0] + 22, pos[1] + 1);
			if (model.meshes[i].type == 6) ImGui.Image(graEye, 0);
			else if (model.meshes[i].type == 0 && model.meshes[i].vertexBufferObject == -1) ImGui.Image(graEye, 2);
			else if (model.meshes[i].type == 0) ImGui.Image(graEye, 1);
			
			// Attribute Text
			ImGui.SetCursorPos(pos[0] + 40, pos[1]);
			if (model.meshes[i].type == 6) ImGui.Text($"Mesh {i}");
			else if (model.meshes[i].type == 0 && model.meshes[i].vertexBufferObject == -1) ImGui.TextDisabled($"Mesh {i}");
			else if (model.meshes[i].type == 0) ImGui.TextDisabled($"Mesh {i}");
		}
	}
	
	static renderBoneList = function()
	{
		var model = PROJECT.currentModel;
		for (var i = 0; i < array_length(model.bones); i++)
		{
			// Get Position
			var pos = [ImGui.GetCursorPosX(), ImGui.GetCursorPosY()];
			
			// Selectable
			if (ImGui.Selectable($"##hiddenModelBone{i}", ENVIRONMENT.attributeSelected == $"BONE{i}", ImGuiSelectableFlags.AllowItemOverlap | ImGuiSelectableFlags.AllowOverlap)) ENVIRONMENT.attributeSelected = $"BONE{i}";
			
			// Bone Icon
			ImGui.SetCursorPos(pos[0] + 22, pos[1] + 1);
			ImGui.Image(graBone, 0);
			
			// Attribute Text
			ImGui.SetCursorPos(pos[0] + 40, pos[1]);
			ImGui.Text($"Bone {i} | {model.bones[i].name}");
		}
	}
	
	static renderLayerList = function()
	{
		var model = PROJECT.currentModel;
		for (var i = 0; i < array_length(model.layers); i++)
		{
			// Get Position
			var pos = [ImGui.GetCursorPosX(), ImGui.GetCursorPosY()];
			
			// Selectable
			if (ImGui.Selectable($"##hiddenModelLayer{i}", ENVIRONMENT.attributeSelected == $"LAYER{i}", ImGuiSelectableFlags.AllowItemOverlap | ImGuiSelectableFlags.AllowOverlap))
			{
				if (ENVIRONMENT.attributeSelected != $"LAYER{i}")
				{
					// Reset Secondary Camera
					SECONDARY_RENDERER.camera.lookDistance = 0.6;
					SECONDARY_RENDERER.camera.lookPitch = -20;
					SECONDARY_RENDERER.camera.lookDirection = -45;
					SECONDARY_RENDERER.camera.lookAtPosition.x = 0;
					SECONDARY_RENDERER.camera.lookAtPosition.y = model.averagePosition[1];
					SECONDARY_RENDERER.camera.lookAtPosition.z = 0;
				}
				ENVIRONMENT.attributeSelected = $"LAYER{i}";
			}
			
			// Layer Icon
			ImGui.SetCursorPos(pos[0] + 22, pos[1] + 1);
			ImGui.Image(graLayers, 0);
			
			// Attribute Text
			ImGui.SetCursorPos(pos[0] + 40, pos[1]);
			ImGui.Text($"Layer {i} | {model.layers[i].name}");
		}
	}
	
	static renderLocatorList = function()
	{
		var model = PROJECT.currentModel;
		for (var i = 0; i < array_length(model.locators); i++)
		{
			// Check Locator Isn't -1
			if (model.locators[i] == -1) continue;
			
			// Get Position
			var pos = [ImGui.GetCursorPosX(), ImGui.GetCursorPosY()];
			
			// Selectable
			if (ImGui.Selectable($"##hiddenModelLocators{i}", ENVIRONMENT.attributeSelected == $"LOC{i}", ImGuiSelectableFlags.AllowItemOverlap | ImGuiSelectableFlags.AllowOverlap)) ENVIRONMENT.attributeSelected = $"LOC{i}";
			
			// Locator Icon
			ImGui.SetCursorPos(pos[0] + 22, pos[1] + 1);
			ImGui.Image(graLocator, 2);
			
			// Attribute Text
			ImGui.SetCursorPos(pos[0] + 40, pos[1]);
			ImGui.Text($"Locator {i} | {model.locators[i].name}");
		}
	}
}

