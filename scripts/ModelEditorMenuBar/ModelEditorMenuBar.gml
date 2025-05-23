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
			//if (ImGui.MenuItem("New Project", "Ctrl+N")) 
			//{
			//	newProject();
			//}
			//ImGui.MenuItem("Open Project", "Ctrl+O");
			//if (ImGui.BeginMenu("Recent Projects", array_length(SETTINGS.recentProjects) > 0))
			//{
			//	for (var i = 0; i < array_length(SETTINGS.recentProjects); i++)
			//	{
			//		ImGui.MenuItem(filename_name(SETTINGS.recentProjects[i]));
			//	}
				
			//	// End Menu
			//	ImGui.EndMenu();
			//}
			
			//ImGui.Separator();
			
			if (ImGui.MenuItem("New Model", SETTINGS.shortcuts.newModel, undefined))
			{
				ENVIRONMENT.openConfirmModal("Unsaved Changes", "Are you sure you want to continue?", function() {
					ENVIRONMENT.openModal("Welcome");
				});
			}
			if (ImGui.MenuItem("Open Model", SETTINGS.shortcuts.openModel, undefined))
			{
				ENVIRONMENT.openConfirmModal("Unsaved Changes", "Are you sure you want to continue?", function() {
					openProjectOrModelDialog();
				});
			}
			if (ImGui.MenuItem("Save Model", SETTINGS.shortcuts.saveModel, undefined))
			{
				saveModelDialog();
			}
			
			ImGui.Separator();
			
			if (ImGui.MenuItem("Preferences", SETTINGS.shortcuts.openPreferences))
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
		
		// Model Menu
		if (ImGui.BeginMenu("Model"))
		{
			// Export Armature Tool
			if (ImGui.MenuItem("Export Armature", SETTINGS.shortcuts.exportArmature)) uiExportArmature(PROJECT.currentModel);
			
			ImGui.Separator();
			
			// Export Model
			if (ImGui.MenuItem("Export Model", SETTINGS.shortcuts.exportModel)) uiExportModel(PROJECT.currentModel);
			
			// Export Model From Preview
			if (ImGui.MenuItem("Export Model From Preview", SETTINGS.shortcuts.exportModelFromPreview)) uiExportModelFromPreview(PROJECT.currentModel, ENVIRONMENT.displayLayers);
			
			ImGui.Separator();
			
			//// Export All
			//if (ImGui.BeginMenu("Export All"))
			//{
			//	if (ImGui.MenuItem("Textures")) uiBulkExportTextures(PROJECT.currentModel);
			//	if (ImGui.MenuItem("Materials")) uiBulkExportMaterials(PROJECT.currentModel);
			//	if (ImGui.MenuItem("Meshes")) uiBulkExportMeshes(PROJECT.currentModel);
			//	if (ImGui.MenuItem("Locators")) uiBulkExportLocators(PROJECT.currentModel);
				
			//	// End Menu
			//	ImGui.EndMenu();
			//}
			
			//// Replace All
			//if (ImGui.BeginMenu("Replace All"))
			//{
			//	ImGui.MenuItem("Textures");
			//	ImGui.MenuItem("Materials");
			//	ImGui.MenuItem("Meshes");
			//	ImGui.MenuItem("Locators");
				
			//	// End Menu
			//	ImGui.EndMenu();
			//}
			
			//ImGui.Separator();
			
			// Export Render
			if (ImGui.MenuItem("Export Render", SETTINGS.shortcuts.exportRender))
			{
				var file = get_save_filename_ext("Portable Network Graphics (*.png)|*.png", "Render.png", "", "Export Render");
				if (file != "" && ord(file) != 0)
				{
					surface_save(RENDERER.surface, file);
				}
			}
			
			// End Menu
			ImGui.EndMenu();
		}
		
		// Tools Menu
		if (ImGui.BeginMenu("Tools"))
		{
			//// Loop Tools
			//var names = variable_struct_get_names(TOOL_SCRIPTS);
				
			//for (var i = 0; i < array_length(names); i++)
			//{
			//	if (ImGui.MenuItem(names[i])) catspeak_function_execute(TOOL_SCRIPTS[$ names[i]], [ PROJECT ]);
			//}
			if (ImGui.MenuItem("Swizzle Normal Map")) uiSwizzleNormalMap(false);
				
			// End Menu
			ImGui.EndMenu();
		}
		
		// Help Menu
		if (ImGui.BeginMenu("Help"))
		{
			if (ImGui.MenuItem("Documentation")) url_open("https://github.com/AlubJ/BactaTank-Classic/wiki");
			ImGui.Separator();
			
			if (ImGui.MenuItem("Submit Bug Report")) url_open("https://github.com/AlubJ/BactaTank-Classic/issues");
			if (ImGui.MenuItem("About")) ENVIRONMENT.openModal("About");
			
			ImGui.Separator();
			if (ImGui.MenuItem("Support Me")) url_open("https://ko-fi.com/Y8Y219SKRX");
			
			if (VERSION_LATEST != noone)
			{
				var version = string_split(VERSION_LATEST, ".");
				if (version[0] > VERSION_MAJOR || version[1] > VERSION_MINOR || version[2] > VERSION_PATCH)
				{
					ImGui.Separator();
					if (ImGui.MenuItem("Download Latest Update")) url_open("https://github.com/AlubJ/BactaTank-Classic/releases/latest/");
				}
			}
			
			// End Menu
			ImGui.EndMenu();
		}
	}
}