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
	displayLocators = 1; // 0 = None, 1 = On Top, 2 = Regular
	displayBones = true;
	displayGrid = true;
	displayLocatorHelper = 1; 
	locatorHelper = [-1, PRIMITIVES.sabre, PRIMITIVES.blaster, PRIMITIVES.pistol, PRIMITIVES.hat];
	ENVIRONMENT.hideDisabledMeshes = true;
	ENVIRONMENT.displayLayers = array_create(array_length(PROJECT.currentModel.layers), true);
	displayLayersPopup = false;
	
	static render = function()
	{
		// Open Popup
		if (displayLayersPopup)
		{
			ImGui.OpenPopup("DisplayLayersPopup");
			displayLayersPopup = false;
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
			if (ImGui.ImageButton("##hiddenDisplayBones", graBone, !displayBones, c_white, 1, c_white, 0)) displayBones = !displayBones;
			ImGui.ShowTooltip("Display Bones");
			
			// View Locators Button
			ImGui.SetCursorPos(windowSize[0] - 72, cursorPos[1] - 26);
			if (ImGui.ImageButton("##hiddenDisplayLocators", graLocator, displayLocators, c_white, 1, c_white, 0))
			{
				displayLocators++;
				if (displayLocators > 2) displayLocators = 0;
			}
			ImGui.ShowTooltip("Display Locators");
			
			// View Bones Button
			ImGui.SetCursorPos(windowSize[0] - 94, cursorPos[1] - 26);
			if (ImGui.ImageButton("##hiddenDisplayGrid", graGrid, !displayGrid, c_white, 1, c_white, 0)) displayGrid = !displayGrid;
			ImGui.ShowTooltip("Display Grid");
			
			// Hide Disabled Meshes Button
			ImGui.SetCursorPos(windowSize[0] - 116, cursorPos[1] - 26);
			if (ImGui.ImageButton("##hiddenHideDisabledMeshes", graMesh, ENVIRONMENT.hideDisabledMeshes, c_white, 1, c_white, 0))
			{
				ENVIRONMENT.hideDisabledMeshes = !ENVIRONMENT.hideDisabledMeshes;
				RENDERER.flush();
				PROJECT.currentModel.pushToRenderQueue(ENVIRONMENT.displayLayers, RENDERER, ENVIRONMENT.hideDisabledMeshes);
			}
			ImGui.ShowTooltip("Hide Disabled Meshes");
			
			// Display Locator Helper Button
			ImGui.SetCursorPos(windowSize[0] - 138, cursorPos[1] - 26);
			if (ImGui.ImageButton("##hiddenDisplayLocatorHelper", graLocatorHelper, displayLocatorHelper, c_white, 1, c_white, 0))
			{
				displayLocatorHelper++;
				if (displayLocatorHelper > array_length(locatorHelper) - 1) displayLocatorHelper = 0;
			}
			ImGui.ShowTooltip("Display Locator Helper");
			
			// Reset Cursor Position
			ImGui.SetCursorPos(cursorPos[0], cursorPos[1]);
			
			// Characters List
			if (ImGui.BeginChild("ModelViewer"))
			{
				// Step Camera
				if (!ENVIRONMENT.anyModalOpen()) RENDERER.orbitCamera(windowPos[0] + 8, windowPos[1] + 32);
				if (window_updated() || RENDERER.width != windowSize[0] - 16 || RENDERER.height != windowSize[1] - 40) RENDERER.resize(windowSize[0] - 16, windowSize[1] - 40);
				
				// Render Locators
				if (displayLocators > 0)
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
							material: {colour: locatorSelected == i ? SETTINGS.viewerSettings.locatorSelectedColour : SETTINGS.viewerSettings.locatorColour, disableZWrite: displayLocators == 1, disableZTest: displayLocators == 1},
							textures: {},
							matrix: matrix,
							shader: "WireframeShader",
							primitive: pr_linelist,
						});
					}
				}
				
				// Render Grid
				if (displayGrid) array_push(RENDERER.debugRenderQueue, ctrlRenderer.gridRenderStruct);
				
				// Locator Selected
				var locatorSelected = -1;
				if (string_pos("LOC", ENVIRONMENT.attributeSelected)) locatorSelected = string_digits(ENVIRONMENT.attributeSelected);
				if (displayLocatorHelper && locatorSelected != -1)
				{
					// Locator Matrix
					if (PROJECT.currentModel.locators[locatorSelected].parent != -1 && PROJECT.currentModel.locators[locatorSelected].parent < array_length(PROJECT.currentModel.bones)) var matrix = matrix_multiply(PROJECT.currentModel.locators[locatorSelected].matrix, PROJECT.currentModel.bones[PROJECT.currentModel.locators[locatorSelected].parent].matrix);
					else var matrix = PROJECT.currentModel.locators[locatorSelected].matrix;
					array_push(RENDERER.debugRenderQueue, {
						vertexBuffer: locatorHelper[displayLocatorHelper],
						material: {
							colour:						[0.75, 0.75, 0.75, 1.0],
							ambientTint:				[0, 0, 0, 1],
							textureID:					-1,
							specularID:					-1,
							normalID:					-1,
							cubemapID:					-1,
							shineID:					-1,
							reflectionPower:			.5,
							specularExponent:			25,
							fresnelMuliplier:			0,
							fresnelCoeff:				0,
							vertexFormat:				0,
							textureFlags:				0,
							shaderFlags:				0x08,
							inputFlags:					0,
							alphaBlend:					0,
							offset:						0,
						},
						textures: {},
						matrix: matrix,
						shader: "StandardShader",
						primitive: pr_trianglestrip,
					});
				}
				
				// Render Bones
				if (displayBones)
				{
					// Resize Canvas
					if (window_updated() || CANVAS.width != windowSize[0] - 16 || CANVAS.height != windowSize[1] - 40) CANVAS.resize(windowSize[0] - 16, windowSize[1] - 40);
					
					// Add Armature
					CANVAS.add(new CalicoArmature(PROJECT.currentModel.bones, RENDERER.camera.viewMatrix, RENDERER.camera.projMatrix));
					CANVAS.draw();
				}
				
				// Get Cursor Position
				var cursorPos = [ImGui.GetCursorPosX(), ImGui.GetCursorPosY()];
				
				// Render The Character Viewer
				if (surface_exists(RENDERER.surface)) ImGui.Surface(RENDERER.surface);
				
				// Set Cursor Position
				ImGui.SetCursorPos(cursorPos[0], cursorPos[1]);
				
				// Draw Canvas Surface
				if (surface_exists(CANVAS.surface) && displayBones) ImGui.Surface(CANVAS.surface);
				
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
				if (ENVIRONMENT.displayLayers[i])
				{
					ImGui.SetCursorPos(cursorPos[0] + 200, cursorPos[1] + 2);
					ImGui.Image(graCheck, 0);
				}
			}
			
			// End Popup
			ImGui.EndPopup();
		}
	}
}