/// @desc Initialise BactaTank
/*
	ctrlInit.Create
	-------------------------------------------------------------------------
	Script:			ctrlInit.Create
	Version:		v1.00
	Created:		15/11/2024 by Alun Jones
	Description:	Initialise BactaTank
	-------------------------------------------------------------------------
	History:
	 - Created 15/11/2024 by Alun Jones
	
	To Do:
*/

// Save Original GPU State
GPU_STATE = gpu_get_state();

// 3D Settings
gpu_set_ztestenable(true);
gpu_set_zwriteenable(true);
gpu_set_alphatestenable(false);
gpu_set_alphatestref(254);
gpu_set_tex_repeat(true);
gpu_set_tex_filter(true);
gpu_set_alphatestenable(true);
gpu_set_tex_mip_enable(mip_off);
gpu_set_tex_min_mip(0);
gpu_set_tex_max_mip(16);
gpu_set_tex_max_aniso(16);
gpu_set_tex_mip_bias(0);
gpu_set_tex_mip_filter(tf_anisotropic);
display_reset(0, true);
draw_set_font(fntMain);

randomize();

//array = [11, 12, 13, 21, 22, 23];
//show_message(transformTo2DArray(array, 3))

//anim = new BactaTankAnimation();
//anim.parse("BLOCK1.AN3");

#region BactaTank Settings

// Default Settings For First Time Launch
SETTINGS = newSettings();

// Load Settings or Save Default Settings
if (file_exists(CONFIG_DIRECTORY + "settings.bin"))
{
	SETTINGS = SnapFromBinary(CONFIG_DIRECTORY + "settings.bin");
	upgradeSettings(SETTINGS);
}
else SnapToBinary(SETTINGS, CONFIG_DIRECTORY + "settings.bin");

// Create Projects Directory
if (!directory_exists(SETTINGS.defaultProjectPath)) directory_create(SETTINGS.defaultProjectPath);
if (SETTINGS.lastProjectPath == "") SETTINGS.lastProjectPath = SETTINGS.defaultProjectPath;

// Initialize Console
if (SETTINGS.consoleEnabled) ConsoleInitialize();
ConsoleLog("Settings Loaded");

// Set MSAA
if (SETTINGS.enableMSAA) display_reset(4, true);

//var buffer = buffer_load("Untitled.dds");
//var size = buffer_get_size(buffer);
//DecodeDDS(buffer_get_address(buffer), size);
//buffer_save(buffer, "rawtex.bin");
//buffer_delete(buffer);
//show_message("AAA")

// About
var buffer = buffer_load("about.txt");
ABOUT = buffer_read(buffer, buffer_text);
buffer_delete(buffer);

// Versions
VERSIONS = {
	indev: false,
	main: "v0.3.0",
	renderer: "v1.2.0",
	backend: "v0.3.0",
	revision: "0",
}

// Set Console Title
ConsoleSetTitle($"{game_display_name} | {VERSIONS.indev ? "dev_": ""}{VERSIONS.main}{VERSIONS.revision != 0 ? "_rev" + VERSIONS.revision : ""}");

// Context
CONTEXT = BTContext.None;
SHORTCUTS = new ShortcutManager();

#endregion

#region BactaTank Asset Packs, Templates and Themes

// Asset Packs Will Be Empty By Default (Potentially Autodetect Asset Packs?)
ASSET_PACKS = [  ];

// Load All Asset Packs
var file = file_find_first(ASSET_PACK_DIRECTORY + "*.bpack", fa_none);

while (file != "")
{
    var assetPack = new BactaTankAssetPack();
	assetPack.deserialize(file);
	array_push(ASSET_PACKS, assetPack);
	ConsoleLog($"Asset Pack {file} Loaded");
    file = file_find_next();
}

file_find_close();

// Create Templates Directory
if (!directory_exists(TEMPLATES_DIRECTORY)) directory_create(TEMPLATES_DIRECTORY);

// Load Templates
loadTemplates();

// Load Themes
loadThemes();

#endregion

#region Scripting

// Initialize Scripting
BactaTankExternInit();

// Scripting Enabled
if (SETTINGS.enableScripting && false)
{
	// Load All Scripts
	var file = file_find_first(SCRIPT_DIRECTORY + "*.bscript", fa_none);
	
	while (file != "")
	{
		var buffer = buffer_load(SCRIPT_DIRECTORY + file);
		catspeak_compile(buffer, true);
		ConsoleLog($"Script {file} Loaded");
	    file = file_find_next();
	}
	
	file_find_close();
}

#endregion

#region Window Settings

// Init Game Frame
//gameframe_init();

// Load Window State
if (SETTINGS.window.size[0] > display_get_width()) SETTINGS.window.size[0] = 1366;
if (SETTINGS.window.size[1] > display_get_height()) SETTINGS.window.size[1] = 768;
window_set_size(SETTINGS.window.size[0], SETTINGS.window.size[1]);
window_center();

// Base Window Variables
WINDOW_SIZE = [window_get_width(), window_get_height()];
LAST_WINDOW_SIZE = [WINDOW_SIZE[0], WINDOW_SIZE[1]];
CURSOR_POSITION = [window_mouse_get_x(), window_mouse_get_y()];
WINDOW_POSITION = [window_get_x(), window_get_y()];
LAST_WINDOW_POSITION = [WINDOW_POSITION[0], WINDOW_POSITION[1]];

// Set Window Size
window_set_min_width(1366);
window_set_min_height(768);

// Resize the surfaces
surface_resize(application_surface, WINDOW_SIZE[0], WINDOW_SIZE[1]);
display_set_gui_size(WINDOW_SIZE[0], WINDOW_SIZE[1]);

// Window Maximise
if (SETTINGS.window.maximised) time_source_start(time_source_create(time_source_game, 2, time_source_units_frames, function() { SetWindowMaximised(window_handle()); }));

// Command Hook
window_command_hook(window_command_close);

// Title Bar
if (os_version >= 655360) SetWindowTitleBarDark(window_handle());

#endregion

#region Goto Next Scene

//room_goto(scnMain);

#endregion

#region Check For Updates

requestID = http_get("https://raw.githubusercontent.com/AlubJ/BactaTank-Classic/refs/heads/main/update.txt");
VERSION_LATEST = noone;

#endregion

#region Create Instances

instance_create_layer(0, 0, layer, ctrlRenderer);
//instance_create_layer(0, 0, layer, ctrlScene);
instance_create_layer(0, 0, layer, ctrlUI);

#endregion