/*
	Macros
	-------------------------------------------------------------------------
	Script:			Macros
	Version:		v1.00
	Created:		15/11/2024 by Alun Jones
	Description:	Globally Used Macros
	-------------------------------------------------------------------------
	History:
	 - Created 15/11/2024 by Alun Jones
	
	To Do:
*/

// Global Version ([Major].[Minor][Patch][Revision][1:A 2:B 3:C, 4:Public])
#macro VERSION 0.3028

// Run From IDE
#macro RUN_FROM_IDE parameter_count() == 3 && string_count("GMS2TEMP", parameter_string(2))

// Debug Output
#macro DBGOUT show_debug_message
#macro DBGMSG ($"{_GMFILE_}.{_GMFUNCTION_} line:{_GMLINE_}    -")
#macro DBGMEM global.__debugMemory__

// File System
#macro TEMP_DIRECTORY			cache_directory
#macro CONFIG_DIRECTORY			game_save_id
#macro ASSET_PACK_DIRECTORY		CONFIG_DIRECTORY + "assetpacks/"
#macro TEMPLATES_DIRECTORY		CONFIG_DIRECTORY + "templates/"
#macro SCRIPT_DIRECTORY			CONFIG_DIRECTORY + "scripts/"
#macro WORKING_DIRECTORY		working_directory
#macro THEMES_DIRECTORY			WORKING_DIRECTORY + "themes/"
#macro LOG_DIRECTORY			game_save_id + "log/"

// Window
#macro WINDOW_SIZE global.__windowSize__
#macro WINDOW_POSITION global.__windowPos__
#macro CURSOR_POSITION global.__cursorPosition__
#macro LAST_WINDOW_SIZE global.__lastWindowSize__
#macro LAST_WINDOW_POSITION global.__lastWindowPosition__

// Renderer
#macro RENDERER				global.__renderer__ // Primary Renderer, used for the main model editor
#macro SECONDARY_RENDERER	global.__secondaryRenderer__ // Secondary renderer used for material previews, layer previews and mesh previews
#macro CANVAS				global.__canvas__ // Primary Canvas
#macro SECONDARY_CANVAS		global.__secondaryCanvas__
#macro CAMERA				global.__renderer__.camera
#macro PRIMITIVES			global.__primitives__
PRIMITIVES = {};

// Original GPU State
#macro GPU_STATE			global.__gpuState__

// Global Vars
#macro SETTINGS		global.__settings__
#macro CONFIG		global.__config__
#macro ASSET_PACKS	global.__assetPacks__
#macro SCRIPTS		global.__scripts__
#macro ABOUT		global.__about__
#macro VERSIONS		global.__versions__
#macro FILTERS		global.__filters__
#macro CONTEXT		global.__context__
#macro TEMPLATES	global.__templates__
#macro SHORTCUTS	global.__shortcuts__

// Themes
#macro THEMES			global.__themes__
#macro THEME_BG			global.__themeBG__
#macro THEME_COLOURS	global.__themeColours__
#macro THEME_STYLES		global.__themeStyles__

// Theme Styles For Lookup
THEME_STYLES = [];
THEME_STYLES[ImGuiStyleVar.WindowBorderSize] = "WindowBorderSize";
THEME_STYLES[ImGuiStyleVar.ChildBorderSize] = "ChildBorderSize";
THEME_STYLES[ImGuiStyleVar.PopupBorderSize] = "PopupBorderSize";
THEME_STYLES[ImGuiStyleVar.FrameBorderSize] = "FrameBorderSize";
THEME_STYLES[ImGuiStyleVar.WindowRounding] = "WindowRounding";
THEME_STYLES[ImGuiStyleVar.ChildRounding] = "ChildRounding";
THEME_STYLES[ImGuiStyleVar.FrameRounding] = "FrameRounding";
THEME_STYLES[ImGuiStyleVar.PopupRounding] = "PopupRounding";
THEME_STYLES[ImGuiStyleVar.ScrollbarRounding] = "ScrollbarRounding";
THEME_STYLES[ImGuiStyleVar.GrabRounding] = "GrabRounding";
THEME_STYLES[ImGuiStyleVar.TabRounding] = "TabRounding";

// Theme Colours For Lookup
THEME_COLOURS = [];
THEME_COLOURS[ImGuiCol.WindowBg] = "WindowBg";
THEME_COLOURS[ImGuiCol.TitleBg] = "TitleBg";
THEME_COLOURS[ImGuiCol.TitleBgActive] = "TitleBgActive";
THEME_COLOURS[ImGuiCol.MenuBarBg] = "MenuBarBg";
THEME_COLOURS[ImGuiCol.ChildBg] = "ChildBg";
THEME_COLOURS[ImGuiCol.PopupBg] = "PopupBg";
THEME_COLOURS[ImGuiCol.Button] = "Button";
THEME_COLOURS[ImGuiCol.ButtonHovered] = "ButtonHovered";
THEME_COLOURS[ImGuiCol.ButtonActive] = "ButtonActive";
THEME_COLOURS[ImGuiCol.Header] = "Header";
THEME_COLOURS[ImGuiCol.HeaderHovered] = "HeaderHovered";
THEME_COLOURS[ImGuiCol.HeaderActive] = "HeaderActive";
THEME_COLOURS[ImGuiCol.FrameBg] = "FrameBg";
THEME_COLOURS[ImGuiCol.FrameBgHovered] = "FrameBgHovered";
THEME_COLOURS[ImGuiCol.FrameBgActive] = "FrameBgActive";
THEME_COLOURS[ImGuiCol.CheckMark] = "CheckMark";
THEME_COLOURS[ImGuiCol.SliderGrab] = "SliderGrab";
THEME_COLOURS[ImGuiCol.SliderGrabActive] = "SliderGrabActive";
THEME_COLOURS[ImGuiCol.Tab] = "Tab";
THEME_COLOURS[ImGuiCol.TabActive] = "TabActive";
THEME_COLOURS[ImGuiCol.TabHovered] = "TabHovered";
THEME_COLOURS[ImGuiCol.Text] = "Text";
THEME_COLOURS[ImGuiCol.TextDisabled] = "TextDisabled";
THEME_COLOURS[ImGuiCol.ModalWindowDimBg] = "ModalWindowDimBg";

// Theme BG
THEME_BG = #080808;

// Scripting
#macro TOOL_SCRIPTS		global.__toolScripts__
TOOL_SCRIPTS = {  };
#macro MATERIAL_SCRIPTS	global.__materialScripts__
MATERIAL_SCRIPTS = {  };
#macro MESH_SCRIPTS		global.__meshScripts__
MESH_SCRIPTS = {  };

// Scripting Helper
#macro SCRIPT_BUFFERS	global.__scriptBuffers__
SCRIPT_BUFFERS = [  ];

// Filters
FILTERS = {
	newProj:		"BactaTank Project (*.bproj)|*.bproj",
	
	projectOrModel: "BactaTank Project or Model (*.proj;*.ghg;*.bcanister)|*.proj;*.ghg;*.bcanister|BactaTank Project (*.bproj)|*.bproj|TtGames Model (*.ghg)|*.ghg|BactaTank Canister (*.bcanister)|*.bcanister",
	
	allAssetTypes:	"BactaTank Compatible Assets (*.ghg;*.an3;*.bsa;*.wav;*.bcanister)|*.ghg;*.an3;*.bsa;*.wav;*.bcanister|TtGames Model (*.ghg)|*.ghg|TtGames Animation (*.an3)|*.an3|TtGames BSA (*.bsa)|*.bsa|Wave Audio (*.wav)|*.wav|BactaTank Canister (*.bcanister)|*.bcanister",
	assetPack:		"BactaTank Asset Pack (*.bpack)|*.bpack",
	
	model: "BactaTank Compatible Models (*.ghg;*.bcanister)|*.ghg;*.bcanister|TtGames Model (*.ghg)|*.ghg|BactaTank Canister (*.bcanister)|*.bcanister",
	
	exportModel: "BactaTank Model (*.bmodel)|*.bmodel",
	
	// Induvidual Model Attributes
	texture: "DirectDraw Surface (*.dds)|*.dds",
	material: "BactaTank Material (*.bmat)|*.bmat",
	mesh: "BactaTank Mesh (*.bmesh;*.btank)|*.bmesh;*.btank|BactaTank Mesh (*.bmesh)|*.bmesh|BactaTank Legacy Mesh (*.btank)|*.btank",
	locator: "BactaTank Locator (*.bloc)|*.bloc",
	armature: "BactaTank Armature (*.barm)|*.barm",
	
	uvLayout: "Portable Graphics Network (*.png)|*.png",
};

// Viewer
#macro VIEWER_SETTINGS			global.__viewerSettings__

// Projects
#macro PROJECT					global.__project__
#macro PROJECT_SAVE_LOCATION	global.__project__.saveLocation
#macro CHARACTERS				global.__project__.characters
#macro MODELS					global.__project__.models
#macro MODEL_NAME				global.__modelName__
#macro DEFAULT_MATERIAL			global.__defaultMaterial__

// Default
PROJECT = -1;

// Environment
#macro FONT global.__font__
#macro ENVIRONMENT global.__environment__

// Other
#macro NULL 0xB00B1E50
#macro NO_DEFAULT 0xBAC7A012