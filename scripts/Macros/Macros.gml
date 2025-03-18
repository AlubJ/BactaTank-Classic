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

// Global Version ([Major].[Minor][Patch][Revision])
#macro VERSION 0.3021

// Run From IDE
#macro RUN_FROM_IDE parameter_count() == 3 && string_count("GMS2TEMP", parameter_string(2))

// Debug Output
#macro DBGOUT show_debug_message
#macro DBGMSG ($"{_GMFILE_}.{_GMFUNCTION_} line:{_GMLINE_}    -")

// File System
#macro TEMP_DIRECTORY			cache_directory
#macro CONFIG_DIRECTORY			game_save_id
#macro ASSET_PACK_DIRECTORY		CONFIG_DIRECTORY + "assetpacks/"
#macro TEMPLATES_DIRECTORY		CONFIG_DIRECTORY + "templates/"
#macro SCRIPT_DIRECTORY			CONFIG_DIRECTORY + "scripts/"
#macro WORKING_DIRECTORY		working_directory
#macro LOG_DIRECTORY			game_save_id + "log/"

// Window
#macro WINDOW_SIZE global.windowSize
#macro WINDOW_POSITION global.windowPos
#macro CURSOR_POSITION global.cursorPosition
#macro LAST_WINDOW_SIZE global.lastWindowSize
#macro LAST_WINDOW_POSITION global.lastWindowPosition

// Renderer
#macro RENDERER				global.renderer // Primary Renderer, used for the main model editor
#macro SECONDARY_RENDERER	global.secondaryRenderer // Secondary renderer used for material previews, layer previews and mesh previews
#macro CANVAS				global.canvas // Primary Canvas
#macro SECONDARY_CANVAS		global.secondaryCanvas
#macro CAMERA				global.renderer.camera
#macro PRIMITIVES			global.primitives
PRIMITIVES = {};

// Original GPU State
#macro GPU_STATE			global.gpuState

// Global Vars
#macro SETTINGS		global.settings
#macro CONFIG		global.config
#macro ASSET_PACKS	global.assetPacks
#macro SCRIPTS		global.scripts
#macro ABOUT		global.about
#macro VERSIONS		global.versions
#macro FILTERS		global.filters
#macro CONTEXT		global.context
#macro TEMPLATES	global.templates

// Scripting
#macro TOOL_SCRIPTS		global.toolScripts
TOOL_SCRIPTS = {  };
#macro MATERIAL_SCRIPTS	global.materialScripts
MATERIAL_SCRIPTS = {  };
#macro MESH_SCRIPTS		global.meshScripts
MESH_SCRIPTS = {  };

// Scripting Helper
#macro SCRIPT_BUFFERS	global.__scriptBuffers
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
#macro VIEWER_SETTINGS			global.viewerSettings

// Projects
#macro PROJECT					global.project
#macro PROJECT_SAVE_LOCATION	global.project.saveLocation
#macro CHARACTERS				global.project.characters
#macro MODELS					global.project.models

// Default
PROJECT = -1;

// Environment
#macro FONT global.font
#macro ENVIRONMENT global.environment

// Other
#macro NULL 0xB00B1E50
#macro NO_DEFAULT 0xBAC7A012