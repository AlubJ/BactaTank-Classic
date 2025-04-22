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
			ImGui.SetCursorPos(280 - 214, 26);
			ImGui.Image(graBactaTankLogoRelease, 0);
			ImGui.SameLine();
			ImGui.SetCursorPos((280 - 216) + 128, 54);
			ImGui.Image(graBactaTankText, 0);
			ImGui.SameLine();
			var tag = $"{VERSIONS.indev ? "dev_": ""}{VERSIONS.main}{VERSIONS.revision != 0 ? "_rev" + VERSIONS.revision : ""} | Renderer {VERSIONS.renderer} | Backend {VERSIONS.backend}";
			ImGui.SetCursorPos(((280 - 216) + 278) - floor(ImGui.CalcTextWidth(tag) / 2), 54 + 80);
			ImGui.Text(tag);
			
			// About (about.txt)
			ImGui.Spacing();
			ImGui.Separator();
			if (ImGui.BeginChild("##About"))
			{
				ImGui.TextWrapped(ABOUT);
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