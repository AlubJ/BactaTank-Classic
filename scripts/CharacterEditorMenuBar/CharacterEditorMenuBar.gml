/*
	CharacterEditorMenuBar
	-------------------------------------------------------------------------
	Script:			CharacterEditorMenuBar
	Version:		v1.00
	Created:		23/11/2024 by Alun Jones
	Description:	Character Editor Context Menu Bar
	-------------------------------------------------------------------------
	History:
	 - Created 23/11/2024 by Alun Jones
	
	To Do:
*/

function CharacterEditorMenuBar() constructor
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
			
			ImGui.MenuItem("Save Project", "Ctrl+S", undefined, PROJECT != noone);
			
			if (ImGui.MenuItem("Save Project As", "Ctrl+Shift+S", undefined, PROJECT != noone))
			{
				saveProjectAs(PROJECT);
			}
			
			ImGui.MenuItem("Export Modpack", "Ctrl+E", undefined, PROJECT != noone);
			
			ImGui.Separator();
			
			ImGui.MenuItem("Preferences", "Ctrl+P");
			
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
		
		// Edit Menu
		if (ImGui.BeginMenu("Edit"))
		{
			ImGui.MenuItem("Project Settings", "Ctrl+Shift+P");
			if (ImGui.MenuItem("Manage Asset Packs")) ENVIRONMENT.openModal("Asset Packs");
			
			ImGui.Separator();
			
			ImGui.MenuItem("New Character", "Ctrl+C");
			ImGui.MenuItem("Import Character", "Ctrl+Shift+C");
			ImGui.MenuItem("Export Character", "Ctrl+Alt+C");
			
			ImGui.Separator();
			
			ImGui.MenuItem("New Model", "Ctrl+M");
			ImGui.MenuItem("Import Model", "Ctrl+Shift+M");
			ImGui.MenuItem("Export Model", "Ctrl+Alt+M");
			
			ImGui.Separator();
			
			ImGui.MenuItem("New Icon", "Ctrl+I");
			ImGui.MenuItem("Import Icon", "Ctrl+Shift+I");
			ImGui.MenuItem("Export Icon", "Ctrl+Alt+I");
			
			ImGui.Separator();
			
			ImGui.MenuItem("New Sound", "Ctrl+A");
			ImGui.MenuItem("Import Sound", "Ctrl+Shift+A");
			ImGui.MenuItem("Export Sound", "Ctrl+Alt+A");
			
			// End Menu
			ImGui.EndMenu();
		}
		
		// Tools Menu
		if (ImGui.BeginMenu("Tools"))
		{
			// Asset Pack
			if (ImGui.MenuItem("Create Asset Pack")) ENVIRONMENT.openModal("Create Asset Pack");
			
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
			if (ImGui.MenuItem("Support Me!")) url_open("https://ko-fi.com/Y8Y219SKRX");
			
			// End Menu
			ImGui.EndMenu();
		}
	}
}