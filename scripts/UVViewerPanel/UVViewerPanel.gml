/*
	UVViewerPanel
	-------------------------------------------------------------------------
	Script:			UVViewerPanel
	Version:		v1.00
	Created:		15/03/2025 by Alun Jones
	Description:	UV Viewer Panel
	-------------------------------------------------------------------------
	History:
	 - Created 15/03/2025 by Alun Jones
	
	To Do:
*/

function UVViewerPanel() constructor
{
	// Variables
	meshesSelected = array_create(array_length(PROJECT.currentModel.meshes), true);
	layerSelected = 0;
	materialSelected = 0;
	textureSelected = 0;
	viewType = 0; // By Mesh, By Texture, By Material, By Layer
	viewTypeNames = ["Mesh", "Texture", "Material", "Layer"];
	viewLayer = 0;
	viewLayerNames = ["UVSet1", "UVSet2"];
	viewUVOffset = [0, 1];
	viewUVExportSize = [512, 512];
	viewPreviewTexture = array_length(PROJECT.currentModel.textures) > 0 ? 0 : -1;
	viewPreviewTextures = [  ];
	for (var i = -1; i < array_length(PROJECT.currentModel.textures); i++)
	{
		if (i == -1) array_push(viewPreviewTextures, "No Preview Texture");
		else
		{
			if (PROJECT.currentModel.textures[i] == 0) array_push(viewPreviewTextures, $"");
			else array_push(viewPreviewTextures, $"Preview Texture {i}");
		}
	}
	viewGrid = true;
	
	viewTypePopup = false;
	
	static render = function()
	{
		
		// Open View Type Popup
		if (viewTypePopup)
		{
			ImGui.OpenPopup("ViewType");
			viewTypePopup = false;
		}
		
		// Window Size and Pos
		var windowSize = [WINDOW_SIZE[0] - 8, WINDOW_SIZE[1] - 30];
		var windowPos = [4, 26];
		
		// Set Next Window Position and Size
		ImGui.SetNextWindowPos(windowPos[0], windowPos[1], ImGuiCond.Always);
		ImGui.SetNextWindowSize(windowSize[0], windowSize[1], ImGuiCond.Always);
		
		// Begin Window
		if (ImGui.Begin("UVViewerPanel", undefined, ImGuiWindowFlags.NoTitleBar | ImGuiWindowFlags.NoMove | ImGuiWindowFlags.NoResize))
		{
			// Header
			ImGui.Text("UV Viewer");
			ImGui.Separator();
			
			// Get Cursor Pos
			var cursorPos = [ImGui.GetCursorPosX(), ImGui.GetCursorPosY()];
			
			// View Type Button
			ImGui.SetCursorPos(windowSize[0] - 108, 4);
			viewType = ImGui.ComboBox(viewType, viewTypeNames, "##hiddenViewType", 100, graEye, ImGuiComboFlags.NoArrowButton);
			ImGui.ShowTooltip("UV View Type");
			
			//// View UV Map Button
			ImGui.SetCursorPos(windowSize[0] - 212, 4);
			viewLayer = ImGui.ComboBox(viewLayer, viewLayerNames, "##hiddenUVMap", 100, graUVMap, ImGuiComboFlags.NoArrowButton);
			ImGui.ShowTooltip("UV Set");
			
			// View Selection
			ImGui.SetCursorPos(windowSize[0] - 472, 4);
			if (viewType == 0)
			{
				var meshList = [  ];
				for (var i = 0; i < array_length(PROJECT.currentModel.meshes); i++) array_push(meshList, $"Mesh {i}");
				ImGui.ComboBoxMultiple("Meshes", meshesSelected, meshList, "##hiddenMeshes", 256, graMesh, ImGuiComboFlags.NoArrowButton);
				ImGui.ShowTooltip("UV Mesh");
			}
			else if (viewType == 1)
			{
				var textureList = [  ];
				for (var i = 0; i < array_length(PROJECT.currentModel.textures); i++)
				{
					if (PROJECT.currentModel.textures[i] == 0) array_push(textureList, $"");
					else array_push(textureList, $"Texture {i}");
				}
				var newTex = ImGui.ComboBox(textureSelected, textureList, "##hiddenTextures", 256, graImage, ImGuiComboFlags.NoArrowButton);
				ImGui.ShowTooltip("UV Texture");
				if (textureSelected != newTex)
				{
					textureSelected = newTex;
					viewUVExportSize = [PROJECT.currentModel.textures[newTex].width, PROJECT.currentModel.textures[newTex].height];
					viewPreviewTexture = newTex;
				}
			}
			else if (viewType == 2)
			{
				var materialList = [  ];
				for (var i = 0; i < array_length(PROJECT.currentModel.materials); i++) array_push(materialList, $"Material {i}");
				materialSelected = ImGui.ComboBox(materialSelected, materialList, "##hiddenMaterials", 256, graSkinned, ImGuiComboFlags.NoArrowButton);
				ImGui.ShowTooltip("UV Material");
			}
			else if (viewType == 3)
			{
				var layerList = [  ];
				for (var i = 0; i < array_length(PROJECT.currentModel.layers); i++) array_push(layerList, $"Layer {i} | {PROJECT.currentModel.layers[i].name}");
				layerSelected = ImGui.ComboBox(layerSelected, layerList, "##hiddenLayers", 256, graLayers, ImGuiComboFlags.NoArrowButton);
				ImGui.ShowTooltip("UV Layer");
			}
			
			// Separator
			ImGui.SetCursorPos(windowSize[0] - 480, 6);
			ImGui.Text("|");
			
			// Preview Texture
			ImGui.SetCursorPos(windowSize[0] - 635, 4);
			var newTex = ImGui.ComboBox(viewPreviewTexture + 1, viewPreviewTextures, "##hiddenPreviewTextures", 150, graImage, ImGuiComboFlags.NoArrowButton) - 1;
			if (viewPreviewTexture != newTex)
			{
				viewPreviewTexture = newTex;
				if (newTex != -1) viewUVExportSize = [PROJECT.currentModel.textures[newTex].width, PROJECT.currentModel.textures[newTex].height];
			}
			ImGui.ShowTooltip("UV Preview Texture");
			
			// Separator
			ImGui.SetCursorPos(windowSize[0] - 643, 6);
			ImGui.Text("|");
			
			// Export Size
			ImGui.SetCursorPos(windowSize[0] - 748, 4);
			ImGui.SetNextItemWidth(100);
			ImGui.DragInt2("##hiddenUVExportSize", viewUVExportSize, 1, 128, 2048);
			ImGui.ShowTooltip("UV Set Export Texture Size (Width / Height)");
			viewUVExportSize[0] = clamp(viewUVExportSize[0], 128, 4096);
			viewUVExportSize[1] = clamp(viewUVExportSize[1], 128, 4096);
			CANVAS.canvasWidth = clamp(viewUVExportSize[0], 128, 4096);
			CANVAS.canvasHeight = clamp(viewUVExportSize[1], 128, 4096);
			
			// Separator
			ImGui.SetCursorPos(windowSize[0] - 756, 6);
			ImGui.Text("|");
			
			// View Offset
			ImGui.SetCursorPos(windowSize[0] - 861, 4);
			ImGui.SetNextItemWidth(100);
			ImGui.DragFloat2("##hiddenUVViewOffset", viewUVOffset, 0.01, -1, 1);
			ImGui.ShowTooltip("UV View Offset (X Offset / Y Offset)");
			
			// Separator
			ImGui.SetCursorPos(windowSize[0] - 869, 6);
			ImGui.Text("|");
			
			// Reset
			ImGui.SetCursorPos(windowSize[0] - 896, 4);
			if (ImGui.ImageButton("##hiddenReset", graReloadB, 0, c_white, 1, c_white, 0, 14, 16))
			{
				CANVAS.positionX = CANVAS.width / 2;
				CANVAS.positionY = CANVAS.height / 2;
				CANVAS.zoom = 1;
			}
			ImGui.ShowTooltip("Reset View");
			
			// Grid Toggle
			ImGui.SetCursorPos(windowSize[0] - 920, 4);
			if (ImGui.ImageButton("##hiddenViewGrid", graGridB, !viewGrid, c_white, 1, c_white, 0, 14, 16)) viewGrid = !viewGrid;
			ImGui.ShowTooltip("Toggle Grid");
			
			// Separator
			ImGui.SetCursorPos(windowSize[0] - 928, 6);
			ImGui.Text("|");
			
			// Set UV Set
			var uvSet = array_create(array_length(PROJECT.currentModel.meshes), -1);
			for (var i = 0; i < array_length(PROJECT.currentModel.meshes); i++)
			{
				if (PROJECT.currentModel.meshes[i].uvSet1 != -1 && viewLayer == 0) uvSet[i] = PROJECT.currentModel.meshes[i].uvSet1;
				else if (PROJECT.currentModel.meshes[i].uvSet2 != -1 && viewLayer == 1) uvSet[i] = PROJECT.currentModel.meshes[i].uvSet2;
			}
			
			// Save
			ImGui.SetCursorPos(windowSize[0] - 955, 4);
			if (ImGui.ImageButton("##hiddenSaveMap", graSave, 0, c_white, 1, c_white, 0, 14, 16))
			{
				// Resize Canvas
				CANVAS.resize(viewUVExportSize[0], viewUVExportSize[1]);
				CANVAS.zoom = 1;
				CANVAS.positionX = CANVAS.width / 2;
				CANVAS.positionY = CANVAS.height / 2;
				
				// Submit UV Maps
				if (viewType == 0)
				{
					for (var i = 0; i < array_length(meshesSelected); i++)
					{
						if (meshesSelected[i] && uvSet[i] != -1) CANVAS.add(new CalicoUVMap(uvSet[i], viewUVOffset));
					}
				}
				else if (viewType == 1)
				{
					for (var i = 0; i < array_length(meshesSelected); i++)
					{
						var mesh = PROJECT.currentModel.meshes[i];
						var material = PROJECT.currentModel.materials[mesh.material];
						if (textureSelected == material.textureID && uvSet[i] != -1) CANVAS.add(new CalicoUVMap(uvSet[i], viewUVOffset));
					}
				}
				else if (viewType == 2)
				{
					for (var i = 0; i < array_length(meshesSelected); i++)
					{
						var mesh = PROJECT.currentModel.meshes[i];
						var material = PROJECT.currentModel.materials[mesh.material];
						if (materialSelected == mesh.material && uvSet[i] != -1) CANVAS.add(new CalicoUVMap(uvSet[i], viewUVOffset));
					}
				}
				else if (viewType == 3)
				{
					for (var i = 0; i < array_length(PROJECT.currentModel.layers); i++)
					{
						if (i != layerSelected) continue;
						var lay = PROJECT.currentModel.layers[i];
						
						for (var j = 0; j < array_length(lay.meshes); j++)
						{
							if (uvSet[lay.meshes[j].mesh] != -1) CANVAS.add(new CalicoUVMap(uvSet[lay.meshes[j].mesh], viewUVOffset));
						}
					}
				}
				
				// Draw Canvas
				CANVAS.draw();
				
				// Save Surface
				uiExportUVLayout(CANVAS.surface);
			}
			ImGui.ShowTooltip("Export UV Layout");
			
			// Reset Cursor Position
			ImGui.SetCursorPos(cursorPos[0], cursorPos[1]);
			
			// Characters List
			if (ImGui.BeginChild("UVViewer"))
			{
				// Step Canvas
				if (!ENVIRONMENT.anyModalOpen()) CANVAS.pan(windowPos[0] + 8, windowPos[1] + 32);
				if (window_updated() || CANVAS.width != windowSize[0] - 16 || CANVAS.height != windowSize[1] - 40)
				{
					ConsoleLog("Window Updated");
					CANVAS.resize(windowSize[0] - 16, windowSize[1] - 40);
					CANVAS.positionX = CANVAS.width / 2;
					CANVAS.positionY = CANVAS.height / 2;
				}
				
				// Texture
				if (viewPreviewTexture != -1) CANVAS.add(new CalicoSprite(PROJECT.currentModel.textures[viewPreviewTexture].sprite, 0, CANVAS.positionX - CANVAS.zoom * CANVAS.canvasWidth / 2, CANVAS.positionY - CANVAS.zoom * CANVAS.canvasHeight / 2, CANVAS.canvasWidth * CANVAS.zoom, CANVAS.canvasHeight * CANVAS.zoom));
				
				// Grid
				if (viewGrid) CANVAS.add(new CalicoGrid());
				
				// Submit UV Maps
				if (viewType == 0)
				{
					for (var i = 0; i < array_length(meshesSelected); i++)
					{
						if (meshesSelected[i] && uvSet[i] != -1) CANVAS.add(new CalicoUVMap(uvSet[i], viewUVOffset));
					}
				}
				else if (viewType == 1)
				{
					for (var i = 0; i < array_length(meshesSelected); i++)
					{
						var mesh = PROJECT.currentModel.meshes[i];
						var material = PROJECT.currentModel.materials[mesh.material];
						if (textureSelected == material.textureID && uvSet[i] != -1) CANVAS.add(new CalicoUVMap(uvSet[i], viewUVOffset));
					}
				}
				else if (viewType == 2)
				{
					for (var i = 0; i < array_length(meshesSelected); i++)
					{
						var mesh = PROJECT.currentModel.meshes[i];
						var material = PROJECT.currentModel.materials[mesh.material];
						if (materialSelected == mesh.material && uvSet[i] != -1) CANVAS.add(new CalicoUVMap(uvSet[i], viewUVOffset));
					}
				}
				else if (viewType == 3)
				{
					for (var i = 0; i < array_length(PROJECT.currentModel.layers); i++)
					{
						if (i != layerSelected) continue;
						var lay = PROJECT.currentModel.layers[i];
						
						for (var j = 0; j < array_length(lay.meshes); j++)
						{
							if (uvSet[lay.meshes[j].mesh] != -1) CANVAS.add(new CalicoUVMap(uvSet[lay.meshes[j].mesh], viewUVOffset));
						}
					}
				}
				
				// Draw Canvas
				CANVAS.draw();
				
				// Get Cursor Position
				var cursorPos = [ImGui.GetCursorPosX(), ImGui.GetCursorPosY()];
				
				// Draw Canvas Surface
				if (surface_exists(CANVAS.surface)) ImGui.Surface(CANVAS.surface);
				
				ImGui.EndChild();
			}
			
			// End Window
			ImGui.End();
		}
		
		// Display Layers Popup
		if (ImGui.BeginPopup("DisplayLayersPopup", ImGuiWindowFlags.Popup))
		{
			// Header
			ImGui.Text("Viewer Layers");
			ImGui.Separator();
			
			// Menu Items
			for (var i = 0; i < array_length(PROJECT.currentModel.layers); i++)
			{
				// Get Cursor Position
				var cursorPos = [ImGui.GetCursorPosX(), ImGui.GetCursorPosY()];
				
				// Selectable
				if (ImGui.Selectable(PROJECT.currentModel.layers[i].name, false, ImGuiSelectableFlags.DontClosePopups))
				{
					ENVIRONMENT.displayLayers[i] = !ENVIRONMENT.displayLayers[i];
					RENDERER.flush();
					PROJECT.currentModel.pushToRenderQueue(ENVIRONMENT.displayLayers, RENDERER, ENVIRONMENT.hideDisabledMeshes);
				}
				
				// Checkmark
				ImGui.SetCursorPos(cursorPos[0] + 200, cursorPos[1] + 2);
				ImGui.Image(graCheck, !ENVIRONMENT.displayLayers[i]);
			}
			
			// End Popup
			ImGui.EndPopup();
		}
		
		// Display Bones Popup
		if (ImGui.BeginPopup("DisplayBonesPopup", ImGuiWindowFlags.Popup))
		{
			// Header
			ImGui.Text("Viewer Armature");
			ImGui.Separator();
			
			// Get Cursor Position
			var cursorPos = [ImGui.GetCursorPosX(), ImGui.GetCursorPosY()];
			
			// View Bones Checkbox
			if (ImGui.Selectable("View Bones##hiddenViewBones", false, ImGuiSelectableFlags.DontClosePopups)) displayBones = !displayBones;
			ImGui.SetCursorPos(cursorPos[0] + 200, cursorPos[1] + 2);
			ImGui.Image(graCheck, !displayBones);
			
			// Get Cursor Position
			var cursorPos = [ImGui.GetCursorPosX(), ImGui.GetCursorPosY()];
			
			// View Bones Checkbox
			if (ImGui.Selectable("View Bone Names##hiddenViewBoneNames", false, ImGuiSelectableFlags.DontClosePopups)) displayBoneNames = !displayBoneNames;
			ImGui.SetCursorPos(cursorPos[0] + 200, cursorPos[1] + 2);
			ImGui.Image(graCheck, !displayBoneNames);
			
			// End Popup
			ImGui.EndPopup();
		}
		
		// View Type
		if (ImGui.BeginPopup("ViewType", ImGuiWindowFlags.Popup))
		{
			// Header
			ImGui.Text("View Type");
			ImGui.Separator();
			
			// Get Cursor Position
			var cursorPos = [ImGui.GetCursorPosX(), ImGui.GetCursorPosY()];
			
			// Menu Items
			for (var i = 0; i < array_length(viewTypeNames); i++)
			{
				// Get Cursor Position
				var cursorPos = [ImGui.GetCursorPosX(), ImGui.GetCursorPosY()];
				
				// Selectable
				if (ImGui.Selectable(viewTypeNames[i], false, ImGuiSelectableFlags.DontClosePopups)) viewType = i;
				
				// Checkmark
				ImGui.SetCursorPos(cursorPos[0] + 100, cursorPos[1] + 2);
				ImGui.Image(graCheck, viewType == i ? 0 : 1);
			}
			
			// End Popup
			ImGui.EndPopup();
		}
	}
}