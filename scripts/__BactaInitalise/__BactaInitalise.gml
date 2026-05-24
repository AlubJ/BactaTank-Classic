/*
	__BACTA_INITIALISE (c) Alun Jones
	-------------------------------------------------------------------------
	Script:			__BACTA_INITIALISE
	Version:		v1.00
	Created:		04/11/2025 by Alun Jones
	Description:	BactaTank Initialisation File
	-------------------------------------------------------------------------
	History:
	 - Created 04/11/2025 by Alun Jones
	
	To Do:
	
	Information:
		Initialises the entire BactaTank systems and infrastructure.
*/

#region Initialize Display Settings

// Define macros
#macro WINDOW_WIDTH			global.__windowWidth__
#macro WINDOW_HEIGHT		global.__windowHeight__
#macro WINDOW_POSX			global.__windowPosX__
#macro WINDOW_POSY			global.__windowPosY__
#macro LAST_WINDOW_WIDTH	global.__lastWindowWidth__
#macro LAST_WINDOW_HEIGHT	global.__lastWindowHeight__
#macro LAST_WINDOW_POSX		global.__lastWindowPosX__
#macro LAST_WINDOW_POSY		global.__lastWindowPosY__
#macro CURSOR_POSX			global.__cursorPosX__
#macro CURSOR_POSY			global.__cursorPosY__

// Set macros
WINDOW_WIDTH				= window_get_width();
WINDOW_HEIGHT				= window_get_height();
LAST_WINDOW_WIDTH			= window_get_width();
LAST_WINDOW_HEIGHT			= window_get_height();
WINDOW_POSX					= window_get_x();
WINDOW_POSY					= window_get_y();
LAST_WINDOW_POSX			= window_get_x();
LAST_WINDOW_POSY			= window_get_y();
CURSOR_POSX					= window_mouse_get_x();
CURSOR_POSY					= window_mouse_get_y();

#endregion

#region File system

// File system
#macro TEMP_DIRECTORY			cache_directory
#macro CONFIG_DIRECTORY			game_save_id
#macro ASSET_PACK_DIRECTORY		CONFIG_DIRECTORY + "assetpacks/"
#macro TEMPLATES_DIRECTORY		CONFIG_DIRECTORY + "templates/"
#macro SCRIPT_DIRECTORY			CONFIG_DIRECTORY + "scripts/"
#macro WORKING_DIRECTORY		working_directory
#macro THEMES_DIRECTORY			WORKING_DIRECTORY + "themes/"
#macro LOG_DIRECTORY			game_save_id + "log/"

#endregion