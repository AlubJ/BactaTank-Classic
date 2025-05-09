/*
	ConfirmModal
	-------------------------------------------------------------------------
	Script:			ConfirmModal
	Version:		v1.00
	Created:		03/12/2024 by Alun Jones
	Description:	Confirm Modal
	-------------------------------------------------------------------------
	History:
	 - Created 03/12/2024 by Alun Jones
	
	To Do:
*/

function ConfirmModal() : Modal() constructor
{
	name = "Confirm";
	
	width = 420;
	//height = 128;
	
	header = "Unsaved Changes";
	text = "Are you sure you want to continue?";
	callback = function() {}
	args = [];
	
	static render = function()
	{
		// Calculate Height
		height = 96 + ImGui.CalcTextHeight(text, false, width - 16);
		
		// Set Modal Position and Size
		ImGui.SetNextWindowPos(floor(WINDOW_SIZE[0] / 2) - floor(width / 2), floor(WINDOW_SIZE[1] / 2) - floor(height / 2), ImGuiCond.Always);
		ImGui.SetNextWindowSize(width, height, ImGuiCond.Always);
		
		// Begin Modal
		if (ImGui.BeginPopupModal(name, undefined, ImGuiWindowFlags.NoMove | ImGuiWindowFlags.NoResize))
		{
			// Set Modal Open
			modalOpen = true;
			
			// Create Confirm Header
			ImGui.Text(header);
			ImGui.Separator();
			
			// Main Text
			ImGui.Spacing();
	        ImGui.PushTextWrapPos(width - 16);
			ImGui.TextWrapped(text);
			
			// Create Project Button
			ImGui.Spacing();
			ImGui.SetCursorPosX((width / 2) - 52);
			if (ImGui.Button("Yes", 48) || keyboard_check_pressed(vk_enter))
			{
				ImGui.CloseCurrentPopup();
				method_call(callback, args);
			}
			ImGui.SameLine();
			if (ImGui.Button("No", 48) || keyboard_check_pressed(vk_escape)) ImGui.CloseCurrentPopup();
			
			// End Popup
			ImGui.EndPopup();
		}
		else
		{
			modalOpen = false;
		}
	}
}