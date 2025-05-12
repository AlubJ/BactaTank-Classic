/*
	UpdateModal
	-------------------------------------------------------------------------
	Script:			UpdateModal
	Version:		v1.00
	Created:		06/05/2025 by Alun Jones
	Description:	Update Modal
	-------------------------------------------------------------------------
	History:
	 - Created 06/05/2025 by Alun Jones
	
	To Do:
*/

function UpdateModal() : Modal() constructor
{
	name = "Update";
	
	width = 420;
	height = 132;
	
	totalButtonWidth = 80 * 2 + 8 * 2;
	
	static render = function()
	{
		// Set Modal Position and Size
		ImGui.SetNextWindowPos(floor(WINDOW_SIZE[0] / 2) - floor(width / 2), floor(WINDOW_SIZE[1] / 2) - floor(height / 2), ImGuiCond.Always);
		ImGui.SetNextWindowSize(width, height, ImGuiCond.Once);
		
		// Begin Modal
		if (ImGui.BeginPopupModal(name, undefined, ImGuiWindowFlags.NoMove | ImGuiWindowFlags.NoResize))
		{
			// Set Modal Open
			modalOpen = true;
			
			// Update Available Text
			ImGui.Text("Update Available");
			ImGui.Separator();
			ImGui.TextWrapped($"A new update for BactaTank Classic has become available (v{string_replace(VERSION_LATEST, "\n", "")}), would you like to download it?");
			ImGui.Separator();
			
			// Spacing
			ImGui.Spacing();
			
			// Get Cursor Position
			var cursorPos = [ImGui.GetCursorPosX(), ImGui.GetCursorPosY()];
			
			// Center Button
			ImGui.SetCursorPos(width / 2 - totalButtonWidth / 2, cursorPos[1] + 2);
			
			// Open Project or Model
			if (ImGui.Button("Download", 80))
			{
				url_open("https://github.com/AlubJ/BactaTank-Classic/releases/latest");
				ImGui.CloseCurrentPopup();
				ENVIRONMENT.openModal("Welcome");
			}
			
			// Center Button
			ImGui.SetCursorPos(width / 2 - totalButtonWidth / 2 + 88, cursorPos[1] + 2);
			
			// Open Project or Model
			if (ImGui.Button("Ignore", 80))
			{
				SETTINGS.ignoreVersion = VERSION_LATEST;
				ImGui.CloseCurrentPopup();
				ENVIRONMENT.openModal("Welcome");
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