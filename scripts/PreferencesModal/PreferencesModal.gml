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
			var space = 200;
			
			// Create Preferences Header
			ImGui.Text("Preferences");
			ImGui.Separator();
			
			// Tab Bar
			ImGui.BeginTabBar("PreferencesTabs")
			{
				// General Tab
				if (ImGui.BeginTabItem("General"))
				{
					
					// End Tab
					ImGui.EndTabItem();
				}
				
				// Paths Tab
				if (ImGui.BeginTabItem("Paths"))
				{
					// Begin Child
					if (ImGui.BeginChild("PathsChild"))
					{
						// Default Project Path
						SETTINGS.defaultProjectPath = ImGui.InputFileCustom("Default Project Directory", SETTINGS.defaultProjectPath, "##hiddenDefaultProjectPath", space, NO_DEFAULT, FILTERS.newProj, $"directory", SETTINGS.defaultProjectPath, ImGuiInputFileFlags.Directory);
						
						// TCS Path
						SETTINGS.tcsPath = ImGui.InputFileCustom("TCS Directory", SETTINGS.tcsPath, "##hiddenTCSPath", space, NO_DEFAULT, FILTERS.newProj, $"directory", SETTINGS.tcsPath, ImGuiInputFileFlags.Directory);
						
						// End Child
						ImGui.EndChild();
					}
					
					// End Tab
					ImGui.EndTabItem();
				}
				
				// Project Tab
				if (ImGui.BeginTabItem("Project"))
				{
					
					// End Tab
					ImGui.EndTabItem();
				}
				
				// Viewer Tab
				if (ImGui.BeginTabItem("Viewer"))
				{
					
					// End Tab
					ImGui.EndTabItem();
				}
			}
			
			// End Popup
			ImGui.EndPopup();
		}
		else
		{
			modalOpen = false;
		}
	}
}