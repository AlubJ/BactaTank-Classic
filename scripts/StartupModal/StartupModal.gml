/*
	StartupModal
	-------------------------------------------------------------------------
	Script:			StartupModal
	Version:		v1.00
	Created:		26/11/2024 by Alun Jones
	Description:	Startup Modal
	-------------------------------------------------------------------------
	History:
	 - Created 26/11/2024 by Alun Jones
	
	To Do:
*/

function StartupModal() : Modal() constructor
{
	name = "Welcome";
	
	width = 560;
	height = 512;
	
	projectName = "New Project";
	projectDirectory = SETTINGS.lastProjectPath;
	projectType = 0;
	
	closeButton = undefined;
	
	static render = function()
	{
		// Set Modal Position and Size
		ImGui.SetNextWindowPos(floor(WINDOW_SIZE[0] / 2) - floor(width / 2), floor(WINDOW_SIZE[1] / 2) - floor(height / 2), ImGuiCond.Always);
		ImGui.SetNextWindowSize(width, height, ImGuiCond.Once);
		
		// Begin Modal
		if (ImGui.BeginPopupModal(name, closeButton, ImGuiWindowFlags.NoMove | ImGuiWindowFlags.NoResize))
		{
			// Set Modal Open
			modalOpen = true;
			
			// Templates Text
			ImGui.Text("Open Template");
			ImGui.Separator();
			
			// Get Cursor Pos
			var cursorPos = [ImGui.GetCursorPosX(), ImGui.GetCursorPosY()];
			
			// Reload Templates Button
			ImGui.SetCursorPos(width - 28, cursorPos[1] - 26);
			if (ImGui.ImageButton("##hiddenReloadTemplates", graReload, 0, c_white, 1, c_white, 0))
			{
				loadTemplates();
			}
			ImGui.ShowTooltip("Reload Templates");
			
			// Open Templates Directory Button
			ImGui.SetCursorPos(width - 50, cursorPos[1] - 26);
			if (ImGui.ImageButton("##hiddenOpenTemplatesDirectory", graFolder, 0, c_white, 1, c_white, 0))
			{
				OpenDirectory(TEMPLATES_DIRECTORY);
			}
			ImGui.ShowTooltip("Open Templates Directory");
			
			// Spacing
			ImGui.Spacing();
			
			// Open Templates Child
			if (ImGui.BeginChild("OpenTemplatesChild", 0, height - 120))
			{
				// Spacing
				ImGui.Spacing();
				
				// Templates List
				for (var i = 0; i < array_length(TEMPLATES); i++)
				{
					if (ImGui.Selectable($"##hidden{filename_name(TEMPLATES[i])}"))
					{
						if (file_exists(TEMPLATES[i]))
						{
							openProjectOrModel(TEMPLATES[i]);
							ImGui.CloseCurrentPopup();
						}
						else loadTemplates();
					}
					ImGui.SameLine(8);
					ImGui.Text(filename_name(TEMPLATES[i]));
				}
				
				// No Templates Thing
				if (array_length(TEMPLATES) == 0)
				{
					ImGui.Selectable($"##hiddenNoTemplate")
					ImGui.SameLine(8);
					ImGui.Text("No Templates Found");
				}
			
				// Spacing
				ImGui.Spacing();
				
				// End Child
				ImGui.EndChild();
			}
			
			// Open Model
			ImGui.Text("Or Open Model Instead");
			ImGui.Separator();
			
			// Spacing
			ImGui.Spacing();
			
			// Get Cursor Position
			var cursorPos = [ImGui.GetCursorPosX(), ImGui.GetCursorPosY()];
			
			// Center Button
			ImGui.SetCursorPos(cursorPos[0] + width / 2 - 70, cursorPos[1] + 2);
			
			// Open Project or Model
			if (ImGui.Button("Open Model", 140))
			{
				if (openProjectOrModelDialog()) ImGui.CloseCurrentPopup();
			}
			
			// End Popup
			ImGui.EndPopup();
		}
		else
		{
			modalOpen = false;
			closeButton = true;
		}
	}
}