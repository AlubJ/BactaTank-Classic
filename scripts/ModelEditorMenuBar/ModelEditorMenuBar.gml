/*
	ModelEditorMenuBar
	-------------------------------------------------------------------------
	Script:			ModelEditorMenuBar
	Version:		v1.00
	Created:		20/01/2025 by Alun Jones
	Description:	Model Editor Context Menu Bar
	-------------------------------------------------------------------------
	History:
	 - Created 20/01/2025 by Alun Jones
	
	To Do:
*/

function ModelEditorMenuBar() constructor
{
	static render = function()
	{
		// File Menu
		if (ImGui.BeginMenu("File"))
		{
			if (ImGui.MenuItem("New Project", "Ctrl+N")) 
			{
				newProject();
			}
			ImGui.MenuItem("Open Project", "Ctrl+O");
			if (ImGui.BeginMenu("Recent Projects", array_length(SETTINGS.recentProjects) > 0))
			{
				for (var i = 0; i < array_length(SETTINGS.recentProjects); i++)
				{
					ImGui.MenuItem(filename_name(SETTINGS.recentProjects[i]));
				}
				
				// End Menu
				ImGui.EndMenu();
			}
			
			ImGui.Separator();
			
			if (ImGui.MenuItem("Open Model", "Ctrl+Shift+O", undefined))
			{
				ENVIRONMENT.openConfirmModal("Unsaved Changes", "Are you sure you want to continue?", function() {
					openProjectOrModelDialog();
				});
			}
			if (ImGui.MenuItem("Save Model", "Ctrl+Shift+S", undefined))
			{
				saveModelDialog();
			}
			
			ImGui.Separator();
			
			if (ImGui.MenuItem("Preferences", "Ctrl+P"))
			{
				ENVIRONMENT.openModal("Preferences");
			}
			
			ImGui.Separator();
			
			if (ImGui.MenuItem("Exit", "Alt+F4"))
			{
				ENVIRONMENT.openConfirmModal("Unsaved Changes", "Are you sure you want to quit?", function() {
					window_command_run(window_command_close);
				});
			}
			
			// End Menu
			ImGui.EndMenu();
		}
		
		// Help Menu
		if (ImGui.BeginMenu("Help"))
		{
			if (ImGui.MenuItem("Documentation")) url_open("https://alub.dev/archive.html?archive=0");
			ImGui.Separator();
			
			if (ImGui.MenuItem("Submit Bug Report")) url_open("https://github.com/AlubJ/BactaTankClassic/issues");
			if (ImGui.MenuItem("About")) ENVIRONMENT.openModal("About");
			
			ImGui.Separator();
			if (ImGui.MenuItem("Support Me")) url_open("https://ko-fi.com/Y8Y219SKRX");
			
			// End Menu
			ImGui.EndMenu();
		}
	}
}