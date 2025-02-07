/*
	AboutModal
	-------------------------------------------------------------------------
	Script:			AboutModal
	Version:		v1.00
	Created:		03/12/2024 by Alun Jones
	Description:	Startup Modal
	-------------------------------------------------------------------------
	History:
	 - Created 03/12/2024 by Alun Jones
	
	To Do:
*/

function AboutModal() : Modal() constructor
{
	name = "About";
	
	static render = function()
	{
		// Set Modal Position and Size
		ImGui.SetNextWindowPos(floor(WINDOW_SIZE[0] / 2) - 280, floor(WINDOW_SIZE[1] / 2) - 256, ImGuiCond.Always);
		ImGui.SetNextWindowSize(560, 512, ImGuiCond.Once);
		
		// Begin Modal
		if (ImGui.BeginPopupModal(name, true, ImGuiWindowFlags.NoMove | ImGuiWindowFlags.NoResize))
		{
			// Set Modal Open
			modalOpen = true;
			
			// BactaTank Banner
			ImGui.SetCursorPos(280 - 252, 26);
			ImGui.Image(graBactaTankLogoRelease, 0);
			ImGui.SameLine();
			ImGui.SetCursorPos((280 - 254) + 128, 54);
			ImGui.Image(graBactaTankText, 0);
			ImGui.SameLine();
			var tag = $"{global.versions.indev ? "dev_": ""}{global.versions.main}{global.versions.revision != 0 ? "_rev" + global.versions.revision : ""} | Renderer {global.versions.renderer} | Backend {global.versions.backend}";
			ImGui.SetCursorPos(((280 - 254) + 318) - floor(ImGui.CalcTextWidth(tag) / 2), 54 + 70);
			ImGui.Text(tag);
			
			// About (about.txt)
			ImGui.Spacing();
			ImGui.Separator();
			if (ImGui.BeginChild("##About"))
			{
				ImGui.TextWrapped(global.about);
				ImGui.EndChild();
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