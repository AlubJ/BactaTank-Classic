/*
	CharacterViewerPanel
	-------------------------------------------------------------------------
	Script:			CharacterViewerPanel
	Version:		v1.00
	Created:		20/11/2024 by Alun Jones
	Description:	Character Viewer Panel
	-------------------------------------------------------------------------
	History:
	 - Created 20/11/2024 by Alun Jones
	
	To Do:
*/

function CharacterViewerPanel() constructor
{
	static render = function()
	{
		// Window Size and Pos
		var windowSize = [round(WINDOW_SIZE[0] / 4 * 2) - 4, round(WINDOW_SIZE[1]) - 30];
		var windowPos = [round(WINDOW_SIZE[0] / 4) + 2, 26];
		
		// Set Next Window Position and Size
		ImGui.SetNextWindowPos(windowPos[0], windowPos[1], ImGuiCond.Always);
		ImGui.SetNextWindowSize(windowSize[0], windowSize[1], ImGuiCond.Always);
		
		// Begin Window
		if (ImGui.Begin("CharacterViewerPanel", undefined, ImGuiWindowFlags.NoTitleBar | ImGuiWindowFlags.NoMove | ImGuiWindowFlags.NoResize))
		{
			// Header
			ImGui.Text("Character Viewer");
			ImGui.Separator();
			
			// Characters List
			if (ImGui.BeginChild("Character Viewer"))
			{
				// Step Camera
				if (!ENVIRONMENT.anyModalOpen()) RENDERER.orbitCamera(windowPos[0] + 8, windowPos[1] + 32);
				if (window_updated() || RENDERER.width != windowSize[0] - 16 || RENDERER.height != windowSize[1] - 40) RENDERER.resize(windowSize[0] - 16, windowSize[1] - 40);
				
				// Render The Character Viewer
				if (surface_exists(RENDERER.surface)) ImGui.Surface(RENDERER.surface);
				
				ImGui.EndChild();
			}
			
			// End Window
			ImGui.End();
		}
	}
}