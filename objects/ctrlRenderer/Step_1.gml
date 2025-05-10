/// @desc Update ImGui and Window Mouse
/*
	ctrlRenderer.BeginStep
	-------------------------------------------------------------------------
	Script:			ctrlRenderer.BeginStep
	Version:		v1.00
	Created:		15/11/2024 by Alun Jones
	Description:	Update ImGui and Window Mouse
	-------------------------------------------------------------------------
	History:
	 - Created 15/11/2024 by Alun Jones
	
	To Do:
*/
if (window_get_width() > 0 && window_get_height() > 0) ImGui.__NewFrame();

// Mouse Position
CURSOR_POSITION[0] = window_mouse_get_x();
CURSOR_POSITION[1] = window_mouse_get_y();

// Window Width
LAST_WINDOW_SIZE[0] = WINDOW_SIZE[0];
if (WINDOW_SIZE[0] != window_get_width() && window_get_width() > 0)
{
	// Main Window Width
	WINDOW_SIZE[0] = window_get_width();
	surface_resize(application_surface, WINDOW_SIZE[0], WINDOW_SIZE[1]);
	display_set_gui_size(WINDOW_SIZE[0], WINDOW_SIZE[1]);
	show_debug_message("windowUpdate");
}

// Window Height
LAST_WINDOW_SIZE[1] = WINDOW_SIZE[1];
if (WINDOW_SIZE[1] != window_get_height() && window_get_height() > 0)
{
	// Main Window Height
	WINDOW_SIZE[1] = window_get_height();
	surface_resize(application_surface, WINDOW_SIZE[0], WINDOW_SIZE[1]);
	display_set_gui_size(WINDOW_SIZE[0], WINDOW_SIZE[1]);
	show_debug_message("windowUpdate");
}

// Update Window Position
LAST_WINDOW_POSITION = [WINDOW_POSITION[0], WINDOW_POSITION[1]];
WINDOW_POSITION = [window_get_x(), window_get_y()];

// Update Game Frame
//gameframe_update();