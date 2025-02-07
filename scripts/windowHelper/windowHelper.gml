/*
	windowHelper
	-------------------------------------------------------------------------
	Script:			windowHelper
	Version:		v1.00
	Created:		10/01/2025 by Alun Jones
	Description:	Window Helper Functions
	-------------------------------------------------------------------------
	History:
	 - Created 10/01/2025 by Alun Jones
	
	To Do:
*/

function window_is_minimised()
{
	return (window_get_width() <= 0 || window_get_height() <= 0);
}

function window_updated()
{
	return LAST_WINDOW_SIZE[0] != WINDOW_SIZE[0] || LAST_WINDOW_SIZE[1] != WINDOW_SIZE[1] || LAST_WINDOW_POSITION[0] != WINDOW_POSITION[0] || LAST_WINDOW_POSITION[1] != WINDOW_POSITION[1];
}