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
			var space = 256;
			
			// Create General Header
			ImGui.Text("General");
			ImGui.Separator();
			
			// Get Cursor Pos
			var cursorPos = [ImGui.GetCursorPosX(), ImGui.GetCursorPosY()];
			
			// Reset Button
			ImGui.SetCursorPos(width - 28, cursorPos[1] - 26);
			if (ImGui.ImageButton("##hiddenResetToDefault", graReload, 0, c_white, 1, c_white, 0))
			{
				SETTINGS = newSettings();
			}
			ImGui.ShowTooltip("Reset settings back to default");
			
			// Spacing
			ImGui.Spacing();
			
			// General
			var general = SETTINGS;
			
			// Show Tooltips
			general.showTooltips = ImGui.CheckboxCustom("Show Tooltips", general.showTooltips, "##hiddenShowTooltips", space);
			
			// Enable Scripts
			general.enableScripting = ImGui.CheckboxCustom("Enable Scripts (Requires Restart)", general.enableScripting, "##hiddenEnableScripting", space);
			ImGui.ShowTooltip("Enables external scripts to be ran (requires restart to take effect)");
			
			// Show Tooltips
			general.displayHex = ImGui.CheckboxCustom("Display Values As Hex", general.displayHex, "##hiddenDisplayValsInHex", space);
			ImGui.ShowTooltip("Displays values in hexidecimal instead of decimal");
			
			// Show Vertex Format
			general.showVertexFormat = ImGui.CheckboxCustom("Show Vertex Format", general.showVertexFormat, "##hiddenShowVertexFormat", space);
			ImGui.ShowTooltip("Shows the vertex format assigned to a material in the material edit panel");
			
			// Show Assigned Meshes
			general.showAssignedMeshes = ImGui.CheckboxCustom("Show Assigned Meshes", general.showAssignedMeshes, "##hiddenShowAssignedMeshes", space);
			ImGui.ShowTooltip("Shows the assigned meshes in the material edit panel");
			
			// Enable System Console
			general.consoleEnabled = ImGui.CheckboxCustom("Enable System Console (Requires Restart)", general.consoleEnabled, "##hiddenEnableSystemConsole", space);
			ImGui.ShowTooltip("Enables the system console for debug / general outputting (requires a restart to take effect)");
			
			// Verbose Output
			general.verboseOutput = ImGui.CheckboxCustom("Enable Verbose Console Output", general.verboseOutput, "##hiddenVerboseConsoleOutput", space);
			ImGui.ShowTooltip("Enable verbose output in the console for debugging purposes");
			
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
			
			// End Popup
			ImGui.EndPopup();
		}
		else
		{
			modalOpen = false;
		}
	}
}