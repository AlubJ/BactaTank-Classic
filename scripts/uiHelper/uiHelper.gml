/*
	uiHelper
	-------------------------------------------------------------------------
	Script:			uiHelper
	Version:		v1.00
	Created:		15/01/2025 by Alun Jones
	Description:	UI Functions
	-------------------------------------------------------------------------
	History:
	 - Created 15/01/2025 by Alun Jones
	
	To Do:
*/

function itemClicked(xpos, ypos, width, height)
{
	return (point_in_rectangle(window_mouse_get_x(), window_mouse_get_y(), xpos, ypos, xpos + width, ypos + height) && mouse_check_button_pressed(mb_left));
}