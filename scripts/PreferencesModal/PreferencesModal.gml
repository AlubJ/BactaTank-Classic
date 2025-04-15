/*
	PreferencesModal
	-------------------------------------------------------------------------
	Script:			PreferencesModal
	Version:		v1.00
	Created:		27/01/2025 by Alun Jones
	Description:	Startup Modal
	-------------------------------------------------------------------------
	History:
	 - Created 27/01/2025 by Alun Jones
	
	To Do:
*/

function PreferencesModal() : Modal() constructor
{
	name = "Preferences";
	
	width = 560;
	height = 512;
	inKeybindMode = "";
	
	static render = function()
	{
		// Set Modal Position and Size
		ImGui.SetNextWindowPos(floor(WINDOW_SIZE[0] / 2) - floor(width / 2), floor(WINDOW_SIZE[1] / 2) - floor(height / 2), ImGuiCond.Always);
		ImGui.SetNextWindowSize(width, height, ImGuiCond.Once);
		
		// Begin Modal
		if (ImGui.BeginPopupModal(name, true, ImGuiWindowFlags.NoMove | ImGuiWindowFlags.NoResize))
		{
			// Set Modal Open
			modalOpen = true;
			
			// Space
			var space = 240;
			
			// Begin Tab Bar
			if (ImGui.BeginTabBar("PreferencesTabs"))
			{
				// General Tab
				if (ImGui.BeginTabItem("General"))
				{
					// Reset Back To False
					inKeybindMode =  false;
					
					// Spacing
					ImGui.Spacing();
					
					// General
					ImGui.Text("General");
					ImGui.Separator();
					
					// Get Cursor Pos
					var cursorPos = [ImGui.GetCursorPosX(), ImGui.GetCursorPosY()];
					
					// Reset Button
					ImGui.SetCursorPos(width - 28, cursorPos[1] - 26);
					if (ImGui.ImageButton("##hiddenResetToDefault", graReload, 0, c_white, 1, c_white, 0))
					{
						SETTINGS = newSettings();
						ENVIRONMENT.applyTheme(SETTINGS.theme);
					}
					ImGui.ShowTooltip("Reset settings back to default");
					
					// Spacing
					ImGui.Spacing();
					
					// General
					var general = SETTINGS;
					
					// Cursor Pos
					var cursorPos = [ImGui.GetCursorPosX(), ImGui.GetCursorPosY()];
					
					// Show Tooltips
					general.showTooltips = ImGui.CheckboxCustom("Show Tooltips", general.showTooltips, "##hiddenShowTooltips", space);
					
					// Lower Render Resolution
					ImGui.SetCursorPos(width / 2 + 10, cursorPos[1]);
					general.lowerRenderResolution = ImGui.CheckboxCustom2("Lower Render Resolution", general.lowerRenderResolution, "##hiddenLowerRenderResolution", space);
					ImGui.ShowTooltip("Lowers the render resolution in the main viewport and secondary viewport for slower machines");
					
					// Enable Scripts
					//general.enableScripting = ImGui.CheckboxCustom("Enable Scripts (Requires Restart)", general.enableScripting, "##hiddenEnableScripting", space);
					//ImGui.ShowTooltip("Enables external scripts to be ran (requires restart to take effect)");
					
					// Cursor Pos
					var cursorPos = [ImGui.GetCursorPosX(), ImGui.GetCursorPosY()];
					
					// Show Tooltips
					general.displayHex = ImGui.CheckboxCustom("Display Values As Hex", general.displayHex, "##hiddenDisplayValsInHex", space);
					ImGui.ShowTooltip("Displays values in hexidecimal instead of decimal");
					
					// Disable Fancy Graphics
					ImGui.SetCursorPos(width / 2 + 10, cursorPos[1]);
					general.simplifyRendering = ImGui.CheckboxCustom2("Simplify Rendering", general.simplifyRendering, "##hiddenSimplifyRendering", space);
					ImGui.ShowTooltip("Disables some of the fancy rendering features for slower machines (this will make the models look less accurate in the renderer)");
					
					// Cursor Pos
					var cursorPos = [ImGui.GetCursorPosX(), ImGui.GetCursorPosY()];
					
					// Show Advanced Material Settings
					general.advancedMaterialSettings = ImGui.CheckboxCustom("Advanced Material Settings", general.advancedMaterialSettings, "##hiddenAdvancedMaterialSettings", space);
					ImGui.ShowTooltip("Enables advanced material settings (vertex format, assigned meshes, and extra material settings)");
					
					// Enable MSAA
					ImGui.SetCursorPos(width / 2 + 10, cursorPos[1]);
					var value = ImGui.CheckboxCustom2("Enable MSAA", general.enableMSAA, "##hiddenEnableMSAA", space);
					ImGui.ShowTooltip("Enables multi-sample anti-aliasing for the viewport");
					if (value != general.enableMSAA)
					{
						general.enableMSAA = value;
						display_reset(general.enableMSAA ? 4 : 0, true);
					}
					
					// Cursor Pos
					var cursorPos = [ImGui.GetCursorPosX(), ImGui.GetCursorPosY()];
					
					// Replace Vertex Format
					general.replaceVertexFormat = ImGui.CheckboxCustom("Replace Vertex Format", general.replaceVertexFormat, "##hiddenReplaceVertexFormat", space);
					ImGui.ShowTooltip("Enables replacing the vertex format when replacing a material");
					
					// Allow GSC
					ImGui.SetCursorPos(width / 2 + 10, cursorPos[1]);
					general.allowGSC = ImGui.CheckboxCustom2("Allow Scene Loading", general.allowGSC, "##hiddenAllowGSC", space);
					ImGui.ShowTooltip("Allow .GSC scene files to be loaded (very unstable)");
					
					// Cursor Pos
					var cursorPos = [ImGui.GetCursorPosX(), ImGui.GetCursorPosY()];
					
					// Enable System Console
					general.consoleEnabled = ImGui.CheckboxCustom("Enable System Console (Requires Restart)", general.consoleEnabled, "##hiddenEnableSystemConsole", space);
					ImGui.ShowTooltip("Enables the system console for debug / general outputting (requires a restart to take effect)");
					
					// Enable Texture Caching
					ImGui.SetCursorPos(width / 2 + 10, cursorPos[1]);
					general.cacheTextures = ImGui.CheckboxCustom2("Cache Textures", general.cacheTextures, "##hiddenCacheTextures", space);
					ImGui.ShowTooltip("Cache textures for faster reloading of models");
					
					// Cursor Pos
					var cursorPos = [ImGui.GetCursorPosX(), ImGui.GetCursorPosY()];
					
					// Verbose Output
					general.verboseOutput = ImGui.CheckboxCustom("Enable Verbose Console Output", general.verboseOutput, "##hiddenVerboseConsoleOutput", space);
					ImGui.ShowTooltip("Enable verbose output in the console for debugging purposes");
					
					// Show Viewer Debug Information
					ImGui.SetCursorPos(width / 2 + 10, cursorPos[1]);
					general.displayViewerDebugInfo = ImGui.CheckboxCustom2("Display Viewer Debug Info", general.displayViewerDebugInfo, "##hiddenDisplayDebugInfo", space);
					ImGui.ShowTooltip("Displays debug information in the primary viewer for the primary renderer");
					
					// Cursor Pos
					var cursorPos = [ImGui.GetCursorPosX(), ImGui.GetCursorPosY()];
					
					// Export NU20 Last
					general.exportNU20Last = ImGui.CheckboxCustom("Always Export Model Version 2", general.exportNU20Last, "##hiddenExportNU20Last", space);
					ImGui.ShowTooltip("Export the model as version 2 (TCS version), this will decrease LB1/LIJ1 load times");
					
					// Rebuild Dynamic Buffers
					ImGui.SetCursorPos(width / 2 + 10, cursorPos[1]);
					general.rebuildDynamicBuffers = ImGui.CheckboxCustom2("Rebuild Dynamic Buffers", general.rebuildDynamicBuffers, "##hiddenRebuildDynamicBuffers", space);
					ImGui.ShowTooltip("This will rebuild the dynamic buffers of a mesh (this is required for custom dynamic buffers / editing of dynamic buffer meshes)");
					
					// Allow Version 1 GHGs
					general.allowVersion1 = ImGui.CheckboxCustom("Allow Version 1 Model Loading", general.allowVersion1, "##hiddenAllowVersion1", space);
					ImGui.ShowTooltip("Allows version 1 models to load (very unstable)");
					
					// Spacing
					ImGui.Spacing();
					
					// Create Viewer Colours Header
					ImGui.Text("Viewer Colours");
					ImGui.Separator();
					
					// Spacing
					ImGui.Spacing();
					
					// Colours
					var viewer = SETTINGS.viewerSettings;
					
					// Grid Colour
					var colour = new ImColor(viewer.gridColour[0] * 255, viewer.gridColour[1] * 255, viewer.gridColour[2] * 255, viewer.gridColour[3]);
					ImGui.ColourEditCustom("Grid Colour", colour, "##hiddenGridColour", space);
					viewer.gridColour[0] = colour.r / 255;
					viewer.gridColour[1] = colour.g / 255;
					viewer.gridColour[2] = colour.b / 255;
					viewer.gridColour[3] = colour.a;
					
					// Locator Colour
					var colour = new ImColor(viewer.locatorColour[0] * 255, viewer.locatorColour[1] * 255, viewer.locatorColour[2] * 255, viewer.locatorColour[3]);
					ImGui.ColourEditCustom("Locator Colour", colour, "##hiddenLocatorColour", space);
					viewer.locatorColour[0] = colour.r / 255;
					viewer.locatorColour[1] = colour.g / 255;
					viewer.locatorColour[2] = colour.b / 255;
					viewer.locatorColour[3] = colour.a;
					
					// Locator Selected Colour
					var colour = new ImColor(viewer.locatorSelectedColour[0] * 255, viewer.locatorSelectedColour[1] * 255, viewer.locatorSelectedColour[2] * 255, viewer.locatorSelectedColour[3]);
					ImGui.ColourEditCustom("Selected Locator Colour", colour, "##hiddenSelectedLocatorColour", space);
					viewer.locatorSelectedColour[0] = colour.r / 255;
					viewer.locatorSelectedColour[1] = colour.g / 255;
					viewer.locatorSelectedColour[2] = colour.b / 255;
					viewer.locatorSelectedColour[3] = colour.a;
					
					// Bone Colour
					var colour = new ImColor(viewer.boneColour[0] * 255, viewer.boneColour[1] * 255, viewer.boneColour[2] * 255, viewer.boneColour[3]);
					ImGui.ColourEditCustom("Bone Colour", colour, "##hiddenBoneColour", space);
					viewer.boneColour[0] = colour.r / 255;
					viewer.boneColour[1] = colour.g / 255;
					viewer.boneColour[2] = colour.b / 255;
					viewer.boneColour[3] = colour.a;
					
					// Bone Selected Colour
					var colour = new ImColor(viewer.selectedBoneColour[0] * 255, viewer.selectedBoneColour[1] * 255, viewer.selectedBoneColour[2] * 255, viewer.selectedBoneColour[3]);
					ImGui.ColourEditCustom("Selected Bone Colour", colour, "##hiddenSelectedBoneColour", space);
					viewer.selectedBoneColour[0] = colour.r / 255;
					viewer.selectedBoneColour[1] = colour.g / 255;
					viewer.selectedBoneColour[2] = colour.b / 255;
					viewer.selectedBoneColour[3] = colour.a;
					
					// UV Colour
					var colour = new ImColor(viewer.uvMapColour[0] * 255, viewer.uvMapColour[1] * 255, viewer.uvMapColour[2] * 255, viewer.uvMapColour[3]);
					ImGui.ColourEditCustom("UV Map Colour", colour, "##hiddenUVMapColour", space);
					viewer.uvMapColour[0] = colour.r / 255;
					viewer.uvMapColour[1] = colour.g / 255;
					viewer.uvMapColour[2] = colour.b / 255;
					viewer.uvMapColour[3] = colour.a;
					
					// Randomise UV Colours
					viewer.randomiseUVMapColours = ImGui.CheckboxCustom("Randomise UV Map Colours", viewer.randomiseUVMapColours, "##hiddenRandomiseUVMapColours", space);
					ImGui.ShowTooltip("Randomises the colour of the UV map per mesh");
					
					// End Tab Item
					ImGui.EndTabItem();
				}
				
				//// Keybind Tab
				//if (ImGui.BeginTabItem("Keybinds"))
				//{
				//	// Space
				//	var space = 200;
					
				//	// General Binds Title
				//	ImGui.Text("General");
					
				//	// New Model Keybind
				//	var newModelBind = ImGui.InputKeybindCustom("New Model", SETTINGS.shortcuts.newModel, inKeybindMode == "New Model", "##hiddenBindNewModel", space, "Ctrl+N");
				//	if (newModelBind[1]) inKeybindMode = "New Model";
				//	if (SETTINGS.shortcuts.newModel != newModelBind[0] && newModelBind[0] != "Press a key")
				//	{
				//		SETTINGS.shortcuts.newModel = newModelBind[0];
				//		SHORTCUTS.rebind("NewModel", newModelBind[0]);
				//	}
					
				//	// Open Model Keybind
				//	var openModelBind = ImGui.InputKeybindCustom("Open Model", SETTINGS.shortcuts.openModel, inKeybindMode == "Open Model", "##hiddenBindOpenModel", space, "Ctrl+O");
				//	if (openModelBind[1]) inKeybindMode = "Open Model";
				//	if (SETTINGS.shortcuts.openModel != openModelBind[0] && openModelBind[0] != "Press a key")
				//	{
				//		SETTINGS.shortcuts.openModel = openModelBind[0];
				//		SHORTCUTS.rebind("OpenModel", openModelBind[0]);
				//	}
					
				//	// End Tab
				//	ImGui.EndTabItem();
				//}
				
				// Themes Tab
				if (ImGui.BeginTabItem("Themes"))
				{
					// Reset Back To False
					inKeybindMode =  false;
					
					// Spacing
					ImGui.Spacing();
					
					// Themes
					ImGui.Text("Themes");
					ImGui.Separator();
					
					// Get Cursor Pos
					var cursorPos = [ImGui.GetCursorPosX(), ImGui.GetCursorPosY()];
					
					// Reload Themes Button
					ImGui.SetCursorPos(width - 28, cursorPos[1] - 26);
					if (ImGui.ImageButton("##hiddenReloadThemes", graReload, 0, c_white, 1, c_white, 0))
					{
						loadThemes();
					}
					ImGui.ShowTooltip("Reload Themes");
					
					// Open Themes Directory Button
					ImGui.SetCursorPos(width - 50, cursorPos[1] - 26);
					if (ImGui.ImageButton("##hiddenOpenThemesDirectory", graFolder, 0, c_white, 1, c_white, 0))
					{
						OpenDirectory(THEMES_DIRECTORY);
					}
					ImGui.ShowTooltip("Open Themes Directory");
					
					// Spacing
					ImGui.Spacing();
					
					// Themes Header
					ImGui.Selectable("##hiddenNameAuthor", false, ImGuiSelectableFlags.Disabled);
					ImGui.SameLine(14);
					ImGui.TextDisabled("Theme");
					ImGui.SameLine((width / 3) * 2 + 7);
					ImGui.TextDisabled("Author");
					
					// Choose Themes Child
					if (ImGui.BeginChild("ChooseThemeChild", 0))
					{
						// Names
						var names = variable_struct_get_names(THEMES);
						
						// Templates List
						for (var i = 0; i < array_length(names); i++)
						{
							if (ImGui.Selectable($"##hidden{names[i]}", SETTINGS.theme == names[i]))
							{
								if (names[i] != SETTINGS.theme)
								{
									SETTINGS.theme = names[i];
									ENVIRONMENT.applyTheme(names[i]);
								}
							}
							ImGui.SameLine(8);
							ImGui.Text(filename_name(names[i]));
							ImGui.SameLine((width / 3) * 2);
							ImGui.Text(THEMES[$ names[i]][$ "author"]);
						}
						
						// Spacing
						ImGui.Spacing();
						
						// End Child
						ImGui.EndChild();
					}
				}
				
				// End Tab Bar
				ImGui.EndTabBar();
			}
			
			// End Popup
			ImGui.EndPopup();
		}
		else
		{
			// Reset Back To False
			inKeybindMode =  false;
			
			modalOpen = false;
		}
	}
}