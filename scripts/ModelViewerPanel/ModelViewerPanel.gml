/*
	ModelViewerPanel
	-------------------------------------------------------------------------
	Script:			ModelViewerPanel
	Version:		v1.00
	Created:		15/01/2025 by Alun Jones
	Description:	Model Viewer Panel
	-------------------------------------------------------------------------
	History:
	 - Created 15/01/2025 by Alun Jones
	
	To Do:
*/

function ModelViewerPanel() constructor
{
	ENVIRONMENT.displayLocators = 1;		 // 0 = None, 1 = On Top, 2 = Regular (L)
	ENVIRONMENT.displayLocatorNames = false; // (Ctrl+L)
	ENVIRONMENT.displayBones = true;		 // (B)
	ENVIRONMENT.displayBoneNames = false;	 // (Ctrl+B)
	ENVIRONMENT.displayGrid = true;			 // (G)
	displayLocatorHelper = 1;
	locatorHelper = [-1, PRIMITIVES.sabre, PRIMITIVES.blaster, PRIMITIVES.pistol, PRIMITIVES.hat];
	locatorHelperNames = ["None", "Sabre", "Blaster", "Pistol", "Hat"];
	locatorHelperPin = PROJECT.currentModel.type == BTModelType.model ? array_create(array_length(PROJECT.currentModel.locators), false) : [  ];
	ENVIRONMENT.hideDisabledMeshes = true; 	 // (M)
	ENVIRONMENT.displayLayers = PROJECT.currentModel.type == BTModelType.model ? array_create(array_length(PROJECT.currentModel.layers), true) : [];
	displayLayersPopup = false;
	displayBonesPopup = false;
	displayLocatorsPopup = false;
	
	static render = function()
	{
		// Open Layers Popup
		if (displayLayersPopup)
		{
			ImGui.OpenPopup("DisplayLayersPopup");
			displayLayersPopup = false;
		}
		
		// Open Bones Popup
		if (displayBonesPopup)
		{
			ImGui.OpenPopup("DisplayBonesPopup");
			displayBonesPopup = false;
		}
		
		// Open Locators Popup
		if (displayLocatorsPopup)
		{
			ImGui.OpenPopup("DisplayLocatorsPopup");
			displayLocatorsPopup = false;
		}
		
		// Window Size and Pos
		var windowSize = [round(WINDOW_SIZE[0] / 4 * 2) - 4, round(WINDOW_SIZE[1]) - 30];
		var windowPos = [round(WINDOW_SIZE[0] / 4) + 2, 26];
		
		// Set Next Window Position and Size
		ImGui.SetNextWindowPos(windowPos[0], windowPos[1], ImGuiCond.Always);
		ImGui.SetNextWindowSize(windowSize[0], windowSize[1], ImGuiCond.Always);
		
		// Begin Window
		if (ImGui.Begin("ModelViewerPanel", undefined, ImGuiWindowFlags.NoTitleBar | ImGuiWindowFlags.NoMove | ImGuiWindowFlags.NoResize))
		{
			// Header
			ImGui.Text("Model Viewer");
			ImGui.Separator();
			
			// Get Cursor Pos
			var cursorPos = [ImGui.GetCursorPosX(), ImGui.GetCursorPosY()];
			
			// View Layers Button
			ImGui.SetCursorPos(windowSize[0] - 28, 6);
			if (ImGui.ImageButton("##hiddenDisplayLayerMenu", graLayers, 0, c_white, 1, c_white, 0)) displayLayersPopup = true;
			ImGui.ShowTooltip("Viewer Layers");
			
			// View Bones Button
			ImGui.SetCursorPos(windowSize[0] - 50, cursorPos[1] - 26);
			if (ImGui.ImageButton("##hiddenDisplayBones", graBone, !ENVIRONMENT.displayBones, c_white, 1, c_white, 0)) ENVIRONMENT.displayBones = !ENVIRONMENT.displayBones;
			if (ImGui.IsItemHovered() && device_mouse_check_button(0, mb_right)) displayBonesPopup = true;
			ImGui.ShowTooltip("Toggle Bones");
			
			// View Locators Button
			ImGui.SetCursorPos(windowSize[0] - 72, cursorPos[1] - 26);
			if (ImGui.ImageButton("##hiddenDisplayLocators", graLocator, ENVIRONMENT.displayLocators, c_white, 1, c_white, 0))
			{
				ENVIRONMENT.displayLocators++;
				if (ENVIRONMENT.displayLocators > 2) ENVIRONMENT.displayLocators = 0;
			}
			if (ImGui.IsItemHovered() && device_mouse_check_button(0, mb_right)) displayLocatorsPopup = true;
			ImGui.ShowTooltip("Toggle Locators");
			
			// View Bones Button
			ImGui.SetCursorPos(windowSize[0] - 94, cursorPos[1] - 26);
			if (ImGui.ImageButton("##hiddenDisplayGrid", graGrid, !ENVIRONMENT.displayGrid, c_white, 1, c_white, 0)) ENVIRONMENT.displayGrid = !ENVIRONMENT.displayGrid;
			ImGui.ShowTooltip("Toggle Grid");
			
			// Hide Disabled Meshes Button
			ImGui.SetCursorPos(windowSize[0] - 116, cursorPos[1] - 26);
			if (ImGui.ImageButton("##hiddenHideDisabledMeshes", graMesh, ENVIRONMENT.hideDisabledMeshes, c_white, 1, c_white, 0))
			{
				ENVIRONMENT.hideDisabledMeshes = !ENVIRONMENT.hideDisabledMeshes;
				RENDERER.flush();
				PROJECT.currentModel.pushToRenderQueue(ENVIRONMENT.displayLayers, RENDERER, ENVIRONMENT.hideDisabledMeshes);
			}
			ImGui.ShowTooltip("Toggle Disabled Meshes");
			
			// Reset Camera
			ImGui.SetCursorPos(windowSize[0] - 138, cursorPos[1] - 26);
			if (ImGui.ImageButton("##hiddenResetCamera", graReload, 0, c_white, 1, c_white, 0))
			{
				CAMERA.reset();
				CAMERA.lookAtPosition.x = PROJECT.currentModel.averagePosition[0];
				CAMERA.lookAtPosition.y = PROJECT.currentModel.averagePosition[1];
				CAMERA.lookAtPosition.z = PROJECT.currentModel.averagePosition[2];
			}
			ImGui.ShowTooltip("Reset Camera");
			
			// Reset Cursor Position
			ImGui.SetCursorPos(cursorPos[0], cursorPos[1]);
			
			// Characters List
			if (ImGui.BeginChild("ModelViewer"))
			{
				// Step Camera
				if (!ENVIRONMENT.anyModalOpen()) RENDERER.orbitCamera(windowPos[0] + 8, windowPos[1] + 32);
				if (window_updated() || RENDERER.width != windowSize[0] - 16 || RENDERER.height != windowSize[1] - 40) RENDERER.resize(windowSize[0] - 16, windowSize[1] - 40);
				
				// Render Locators
				if (ENVIRONMENT.displayLocators > 0 && PROJECT.currentModel.type == BTModelType.model)
				{
					for (var i = 0; i < array_length(PROJECT.currentModel.locators); i++)
					{
						// Check Locator Isn't -1
						if (PROJECT.currentModel.locators[i] == -1) continue;
						
						// Locator Selected
						var locatorSelected = -1;
						if (string_pos("LOC", ENVIRONMENT.attributeSelected)) locatorSelected = string_digits(ENVIRONMENT.attributeSelected);
						
						// Locator Matrix
						if (PROJECT.currentModel.locators[i].parent != -1 && PROJECT.currentModel.locators[i].parent < array_length(PROJECT.currentModel.bones)) var matrix = matrix_multiply(PROJECT.currentModel.locators[i].matrix, PROJECT.currentModel.bones[PROJECT.currentModel.locators[i].parent].matrix);
						else var matrix = PROJECT.currentModel.locators[i].matrix;
						
						// Push To Debug Render Queue
						array_push(RENDERER.debugRenderQueue, {
							vertexBuffer: PRIMITIVES.locator,
							material: {colour: locatorSelected == i ? SETTINGS.viewerSettings.locatorSelectedColour : SETTINGS.viewerSettings.locatorColour, disableZWrite: ENVIRONMENT.displayLocators == 1, disableZTest: ENVIRONMENT.displayLocators == 1},
							textures: {},
							matrix: matrix,
							shader: "WireframeShader",
							primitive: pr_linelist,
						});
						
						// Display Locator Helper Pin
						if (displayLocatorHelper && locatorHelperPin[i])
						{
							array_push(RENDERER.debugRenderQueue, {
								vertexBuffer: locatorHelper[displayLocatorHelper],
								material: DEFAULT_MATERIAL,
								textures: {},
								matrix: matrix,
								shader: "StandardShader",
								primitive: pr_trianglestrip,
							});
						}
					}
				}
				
				// Render Grid
				if (ENVIRONMENT.displayGrid) array_push(RENDERER.debugRenderQueue, ctrlRenderer.gridRenderStruct);
				
				// Locator Selected
				var locatorSelected = -1;
				if (string_pos("LOC", ENVIRONMENT.attributeSelected)) locatorSelected = string_digits(ENVIRONMENT.attributeSelected);
				if (displayLocatorHelper && locatorSelected != -1 && PROJECT.currentModel.type == BTModelType.model)
				{
					// Locator Matrix
					if (PROJECT.currentModel.locators[locatorSelected].parent != -1 && PROJECT.currentModel.locators[locatorSelected].parent < array_length(PROJECT.currentModel.bones)) var matrix = matrix_multiply(PROJECT.currentModel.locators[locatorSelected].matrix, PROJECT.currentModel.bones[PROJECT.currentModel.locators[locatorSelected].parent].matrix);
					else var matrix = PROJECT.currentModel.locators[locatorSelected].matrix;
					array_push(RENDERER.debugRenderQueue, {
						vertexBuffer: locatorHelper[displayLocatorHelper],
						material: DEFAULT_MATERIAL,
						textures: {},
						matrix: matrix,
						shader: "StandardShader",
						primitive: pr_trianglestrip,
					});
				}
				
				// Resize Canvas
				if (window_updated() || CANVAS.width != windowSize[0] - 16 || CANVAS.height != windowSize[1] - 40) CANVAS.resize(windowSize[0] - 16, windowSize[1] - 40);
				
				// Render Bones
				if (ENVIRONMENT.displayBones && PROJECT.currentModel.type == BTModelType.model)
				{
					// Add Armature
					var selectedBone = -1;
					if (string_pos("BONE", ENVIRONMENT.attributeSelected)) selectedBone = string_digits(ENVIRONMENT.attributeSelected);
					CANVAS.add(new CalicoArmature(PROJECT.currentModel.bones, RENDERER.camera.viewMatrix, RENDERER.camera.projMatrix, ENVIRONMENT.displayBoneNames, selectedBone));
				}
				
				// Render Locator Names
				if (ENVIRONMENT.displayLocators != 0 && ENVIRONMENT.displayLocatorNames && PROJECT.currentModel.type == BTModelType.model)
				{
					// Locator Names
					CANVAS.add(new CalicoLocatorNames(PROJECT.currentModel.locators, PROJECT.currentModel.bones, RENDERER.camera.viewMatrix, RENDERER.camera.projMatrix));
				}
				
				// Render Debug
				if (SETTINGS.displayViewerDebugInfo)
				{
					CANVAS.add(new CalicoDebugInformation());
				}
				
				CANVAS.draw();
				
				// Get Cursor Position
				var cursorPos = [ImGui.GetCursorPosX(), ImGui.GetCursorPosY()];
				
				// Render The Character Viewer
				if (surface_exists(RENDERER.surface)) ImGui.Surface(RENDERER.surface, c_white, 1, RENDERER.width, RENDERER.height);
				
				// Set Cursor Position
				ImGui.SetCursorPos(cursorPos[0], cursorPos[1]);
				
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
					if (keyboard_check(vk_lcontrol))
					{
						ENVIRONMENT.displayLayers = array_create(array_length(PROJECT.currentModel.layers), false);
						ENVIRONMENT.displayLayers[i] = true;
						RENDERER.flush();
						PROJECT.currentModel.pushToRenderQueue(ENVIRONMENT.displayLayers, RENDERER, ENVIRONMENT.hideDisabledMeshes);
					}
					else
					{
						ENVIRONMENT.displayLayers[i] = !ENVIRONMENT.displayLayers[i];
						RENDERER.flush();
						PROJECT.currentModel.pushToRenderQueue(ENVIRONMENT.displayLayers, RENDERER, ENVIRONMENT.hideDisabledMeshes);
					}
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
			if (ImGui.Selectable("View Bones##hiddenViewBones", false, ImGuiSelectableFlags.DontClosePopups)) ENVIRONMENT.displayBones = !ENVIRONMENT.displayBones;
			ImGui.SetCursorPos(cursorPos[0] + 200, cursorPos[1] + 2);
			ImGui.Image(graCheck, !ENVIRONMENT.displayBones);
			
			// Get Cursor Position
			var cursorPos = [ImGui.GetCursorPosX(), ImGui.GetCursorPosY()];
			
			// View Bones Checkbox
			if (ImGui.Selectable("View Bone Names##hiddenViewBoneNames", false, ImGuiSelectableFlags.DontClosePopups)) ENVIRONMENT.displayBoneNames = !ENVIRONMENT.displayBoneNames;
			ImGui.SetCursorPos(cursorPos[0] + 200, cursorPos[1] + 2);
			ImGui.Image(graCheck, !ENVIRONMENT.displayBoneNames);
			
			// End Popup
			ImGui.EndPopup();
		}
		
		// Display Locators Popup
		if (ImGui.BeginPopup("DisplayLocatorsPopup", ImGuiWindowFlags.Popup))
		{
			// Header
			ImGui.Text("Viewer Locators");
			ImGui.Separator();
			
			// Get Cursor Position
			var cursorPos = [ImGui.GetCursorPosX(), ImGui.GetCursorPosY()];
			
			// View Locators Checkbox
			if (ImGui.Selectable("View Locators##hiddenViewLocators", false, ImGuiSelectableFlags.DontClosePopups))
			{
				if (ENVIRONMENT.displayLocators != 0) ENVIRONMENT.displayLocators = 0;
				else ENVIRONMENT.displayLocators = 2;
			}
			ImGui.SetCursorPos(cursorPos[0] + 200, cursorPos[1] + 2);
			ImGui.Image(graCheck, ENVIRONMENT.displayLocators > 0 ? 0 : 1);
			
			// Get Cursor Position
			var cursorPos = [ImGui.GetCursorPosX(), ImGui.GetCursorPosY()];
			
			// View Locators On Top Checkbox
			if (ImGui.Selectable("Display On Top##hiddenViewLocatorsOnTop", false, ImGuiSelectableFlags.DontClosePopups))
			{
				if (ENVIRONMENT.displayLocators != 1) ENVIRONMENT.displayLocators = 1;
				else ENVIRONMENT.displayLocators = 2;
			}
			ImGui.SetCursorPos(cursorPos[0] + 200, cursorPos[1] + 2);
			ImGui.Image(graCheck, ENVIRONMENT.displayLocators == 1 ? 0 : 1);
			
			// Get Cursor Position
			var cursorPos = [ImGui.GetCursorPosX(), ImGui.GetCursorPosY()];
			
			// View Locators Names
			if (ImGui.Selectable("View Locator Names##hiddenViewLocatorsNames", false, ImGuiSelectableFlags.DontClosePopups)) ENVIRONMENT.displayLocatorNames = !ENVIRONMENT.displayLocatorNames;
			ImGui.SetCursorPos(cursorPos[0] + 200, cursorPos[1] + 2);
			ImGui.Image(graCheck, !ENVIRONMENT.displayLocatorNames);
			
			// View Locator Helpers
			ImGui.Spacing();
			ImGui.Text("Locator Helper");
			ImGui.Separator();
			
			// Menu Items
			for (var i = 0; i < array_length(locatorHelperNames); i++)
			{
				// Get Cursor Position
				var cursorPos = [ImGui.GetCursorPosX(), ImGui.GetCursorPosY()];
				
				// Selectable
				if (ImGui.Selectable(locatorHelperNames[i], false, ImGuiSelectableFlags.DontClosePopups)) displayLocatorHelper = i;
				
				// Checkmark
				ImGui.SetCursorPos(cursorPos[0] + 200, cursorPos[1] + 2);
				ImGui.Image(graCheck, displayLocatorHelper == i ? 0 : 1);
			}
			
			// Pin Locator Helpers
			ImGui.Spacing();
			ImGui.Text("Pin Locator Helper");
			ImGui.Separator();
			
			// Menu Items
			for (var i = 0; i < array_length(PROJECT.currentModel.locators); i++)
			{
				// If locator doesn't exist, skip past it brotha!
				if (PROJECT.currentModel.locators[i] == -1) continue;
				
				// Get Cursor Position
				var cursorPos = [ImGui.GetCursorPosX(), ImGui.GetCursorPosY()];
				
				// Selectable
				if (ImGui.Selectable(PROJECT.currentModel.locators[i].name, false, ImGuiSelectableFlags.DontClosePopups)) locatorHelperPin[i] = !locatorHelperPin[i];
				
				// Checkmark
				ImGui.SetCursorPos(cursorPos[0] + 200, cursorPos[1] + 2);
				ImGui.Image(graCheck, locatorHelperPin[i] == true ? 0 : 1);
			}
			
			// End Popup
			ImGui.EndPopup();
		}
	}
}