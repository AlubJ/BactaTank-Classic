/*
	Environment
	-------------------------------------------------------------------------
	Script:			Environment
	Version:		v1.00
	Created:		15/11/2024 by Alun Jones
	Description:	UI Environment
	-------------------------------------------------------------------------
	History:
	 - Created 15/11/2024 by Alun Jones
	
	To Do:
*/

function Environment() constructor
{
	name = "";
	panels = [  ];
	
	static add = function(panel)
	{
		array_push(panels, panel);
	}
	
	static render = function()
	{
		for (var i = 0; i < array_length(panels); i++)
		{
			panels[i].render();
		}
	}
}

function GlobalEnvironment() constructor
{
	
	// ImGui Setup
	ImGui.__Initialize();
	ImGui.AddFontFromFile(THEMES_DIRECTORY + "nunito.ttf", 16);
	
	//ImGui.ConfigFlagToggle(ImGuiConfigFlags.DockingEnable);
	//time_source_start(time_source_create(time_source_game, 2, time_source_units_frames, function() { ImGui.AddFontFromFile(THEMES_DIRECTORY + "nunito.ttf", 16) }));
	//ImGui.PushStyleColor(ImGuiCol.WindowBg, #111111, 1);
	//ImGui.PushStyleColor(ImGuiCol.TitleBg, #282828, 1);
	//ImGui.PushStyleColor(ImGuiCol.TitleBgActive, #2d2d2d, 1);
	//ImGui.PushStyleColor(ImGuiCol.MenuBarBg, #212121, 1);
	//ImGui.PushStyleColor(ImGuiCol.ChildBg, #000000, 0);
	//ImGui.PushStyleColor(ImGuiCol.PopupBg, #171717, 1);
	//ImGui.PushStyleColor(ImGuiCol.Button, #1f1f1f, 1);
	//ImGui.PushStyleColor(ImGuiCol.ButtonHovered, #262626, 1);
	//ImGui.PushStyleColor(ImGuiCol.ButtonActive, #2a2a2a, 1);
	//ImGui.PushStyleColor(ImGuiCol.Header, #262626, 1);
	//ImGui.PushStyleColor(ImGuiCol.HeaderHovered, #2b2b2b, 1);
	//ImGui.PushStyleColor(ImGuiCol.HeaderActive, #282828, 1);
	//ImGui.PushStyleColor(ImGuiCol.FrameBg, #1f1f1f, 1);
	//ImGui.PushStyleColor(ImGuiCol.FrameBgHovered, #333333, 1);
	//ImGui.PushStyleColor(ImGuiCol.FrameBgActive, #333333, 1);
	//ImGui.PushStyleColor(ImGuiCol.CheckMark, #7f7f7f, 1);
	//ImGui.PushStyleColor(ImGuiCol.SliderGrab, #636363, 1);
	//ImGui.PushStyleColor(ImGuiCol.SliderGrabActive, #6d6d6d, 1);
	//ImGui.PushStyleColor(ImGuiCol.Tab, #ffffff, 0);
	//ImGui.PushStyleColor(ImGuiCol.TabActive, #ffffff, 0.13);
	//ImGui.PushStyleColor(ImGuiCol.TabHovered, #ffffff, 0.20);
	//ImGui.PushStyleColor(ImGuiCol.TextDisabled, #ffffff, 0.5);
	//ImGui.PushStyleColor(ImGuiCol.ModalWindowDimBg, #000000, 0.5);
	
	////  Other  \\
	//ImGui.PushStyleVar(ImGuiStyleVar.WindowBorderSize, 0);
	//ImGui.PushStyleVar(ImGuiStyleVar.ChildBorderSize, 0);
	//ImGui.PushStyleVar(ImGuiStyleVar.PopupBorderSize, 0);
	//ImGui.PushStyleVar(ImGuiStyleVar.FrameBorderSize, 0);
	//ImGui.PushStyleVar(ImGuiStyleVar.WindowRounding, 10);
	//ImGui.PushStyleVar(ImGuiStyleVar.ChildRounding, 3);
	//ImGui.PushStyleVar(ImGuiStyleVar.FrameRounding, 3);
	//ImGui.PushStyleVar(ImGuiStyleVar.PopupRounding, 3);
	//ImGui.PushStyleVar(ImGuiStyleVar.ScrollbarRounding, 3);
	//ImGui.PushStyleVar(ImGuiStyleVar.GrabRounding, 3);
	//ImGui.PushStyleVar(ImGuiStyleVar.TabRounding, 3);
	applyTheme(SETTINGS.theme);
	
	// Environments
	environments = [  ];
	modals = [  ];
	currentEnvironment = 0;
	
	// Menu Bars
	projectMenuBar = new CharacterEditorMenuBar();
	modelEditorMenuBar = new ModelEditorMenuBar();
	
	confirmModal = new ConfirmModal();
	infoModal = new InfoModal();
	
	static add = function(environment)
	{
		array_push(environments, environment);
	}
	
	static addModal = function(modal)
	{
		array_push(modals, modal);
	}
	
	static openModal = function(name)
	{
		for (var i = 0; i < array_length(modals); i++)
		{
			if (modals[i].name == name)
			{
				modals[i].open = true;
			}
		}
	}
	
	static openConfirmModal = function(header = "Unsaved Changes", text = "Are you sure you want to continue?", callback = function() {}, args = [])
	{
		confirmModal.header = header;
		confirmModal.text = text;
		confirmModal.callback = callback;
		confirmModal.args = args;
		confirmModal.open = true;
	}
	
	static openInfoModal = function(header = "Please wait", text = "Something is happening")
	{
		infoModal.header = header;
		infoModal.text = text;
		infoModal.open = true;
	}
	
	static closeInfoModal = function()
	{
		infoModal.close = true;
	}
	
	static anyModalOpen = function(exclude = noone)
	{
		for (var i = 0; i < array_length(modals); i++)
		{
			if (modals[i].modalOpen && modals[i].name != exclude) return true;
		}
		if (infoModal.modalOpen) return true;
		if (confirmModal.modalOpen) return true;
		return false;
	}
	
	static render = function()
	{
		#region Modal Controls
		
		for (var i = 0; i < array_length(modals); i++)
		{
			if (modals[i].open)
			{
				modals[i].open = false;
				ImGui.OpenPopup(modals[i].name);
			}
		}
		
		if (confirmModal.open)
		{
			confirmModal.open = false;
			ImGui.OpenPopup(confirmModal.name);
		}
		
		if (infoModal.open)
		{
			infoModal.open = false;
			ImGui.OpenPopup(infoModal.name);
		}
		
		#endregion
		
		#region Menu Bar
		
		// Menu Bar
		if (ImGui.BeginMainMenuBar())
		{
			// Render Menu Bar
			if (CONTEXT == BTContext.Project) projectMenuBar.render();
			else if (CONTEXT == BTContext.Model) modelEditorMenuBar.render();
			
			// Separated
			ImGui.Text(" | ");
			
			// Begin Tab Bar
			if (ImGui.BeginTabBar("TabBar"))
			{
				// Environments Tabs
				for (var i = 0; i < array_length(environments); i++)
				{
					if (ImGui.BeginTabItem(" " + environments[i].name + " "))
					{
						if (currentEnvironment != i) currentEnvironment = i;
						ImGui.EndTabItem();
					}
				}
				ImGui.EndTabBar();
			}
			
			// Version Tag
			var tag = "";
			tag = $"{game_display_name} | {VERSIONS.indev ? "dev_": ""}{VERSIONS.main}{VERSIONS.revision != 0 ? "_rev" + VERSIONS.revision : ""}";
			
			ImGui.SetCursorPos(window_get_width() - ImGui.CalcTextWidth(tag) - 8, 0);
			ImGui.Text(tag);
			
			// End Menu Bar
			ImGui.EndMainMenuBar();
		}
		
		#endregion
		
		// Render Local Environments
		if (array_length(environments) != 0) environments[currentEnvironment].render();
		
		// Render Modals
		for (var i = 0; i < array_length(modals); i++)
		{
			modals[i].render();
		}
		
		// Render Other Modals
		confirmModal.render();
		infoModal.render();
		
		// Shortcut Controller
		if (!anyModalOpen())
		{
			SHORTCUTS.step();
			ShortcutController();
		}
		if (!anyModalOpen("Welcome")) DragAndDropController();
	}
	
	static applyTheme = function(themeName = "Default Dark")
	{
		// Check Theme Exists
		if (variable_struct_exists(THEMES, themeName))
		{
			// Get Theme Names
			var names = variable_struct_get_names(THEMES[$ themeName]);
			
			// Loop Names
			for (var i = 0; i < array_length(names); i++)
			{
				// Check Style First
				var style = array_get_index(THEME_STYLES, names[i]);
				
				// Style
				if (style != -1)
				{
					// Push Style
					ImGui.PushStyleVar(style, THEMES[$ themeName][$ names[i]]);
					continue;
				}
				
				// Check Colour
				var colour = array_get_index(THEME_COLOURS, names[i]);
				
				// Colour
				if (colour != -1)
				{
					// Push Colour
					var col = make_color_rgb(THEMES[$ themeName][$ names[i]][0], THEMES[$ themeName][$ names[i]][1], THEMES[$ themeName][$ names[i]][2]);
					ImGui.PushStyleColor(colour, col, THEMES[$ themeName][$ names[i]][3] / 255);
					continue;
				}
				
				// Theme BG
				if (names[i] == "mainBg") THEME_BG = make_color_rgb(THEMES[$ themeName][$ names[i]][0], THEMES[$ themeName][$ names[i]][1], THEMES[$ themeName][$ names[i]][2]);
				
				// Title Bar
				if (names[i] == "titleBar")
				{
					if (THEMES[$ themeName][$ names[i]] == "Dark") SetWindowTitleBarDark(window_handle());
					else if (THEMES[$ themeName][$ names[i]] == "Light") SetWindowTitleBarLight(window_handle());
				}
			}
		}
	}
}