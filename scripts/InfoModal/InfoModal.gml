/*
	InfoModal
	-------------------------------------------------------------------------
	Script:			InfoModal
	Version:		v1.00
	Created:		14/01/2025 by Alun Jones
	Description:	Info Modal
	-------------------------------------------------------------------------
	History:
	 - Created 14/01/2025 by Alun Jones
	
	To Do:
*/

enum INFO_BUTTONS
{
	NONE,
	OK,
}

function InfoModal() : Modal() constructor
{
	name = "Info";
	
	width = 380;
	height = 84;
	
	header = "Please Wait";
	text = "Something is happening";
	
	buttons = INFO_BUTTONS.NONE;
	
	close = false;
	
	static render = function()
	{
		// Set Modal Position and Size
		ImGui.SetNextWindowPos(floor(WINDOW_SIZE[0] / 2) - floor(width / 2), floor(WINDOW_SIZE[1] / 2) - floor(height / 2), ImGuiCond.Always);
		ImGui.SetNextWindowSize(width, height, ImGuiCond.Once);
		
		// Begin Modal
		if (ImGui.BeginPopupModal(name, buttons = INFO_BUTTONS.OK ? true : undefined, ImGuiWindowFlags.NoMove | ImGuiWindowFlags.NoResize))
		{
			// Set Modal Open
			modalOpen = true;
			
			// Create Confirm Header
			ImGui.Text(header);
			ImGui.Separator();
			
			// Main Text
			ImGui.Spacing();
			ImGui.Text(text);
			
			// Close
			if (close)
			{
				ImGui.CloseCurrentPopup();
				close = false;
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