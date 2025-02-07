/*
	exceptionHelper
	-------------------------------------------------------------------------
	Script:			exceptionHelper
	Version:		v1.00
	Created:		13/01/2025 by Alun Jones
	Description:	Exception Functions
	-------------------------------------------------------------------------
	History:
	 - Created 13/01/2025 by Alun Jones
	
	To Do:
*/

function throwException(exception, log = false, crash = RUN_FROM_IDE)
{
	if (crash)
	{
		throw exception;
	}
	else
	{
		ConsoleLog(exception, CONSOLE_ERROR);
	}
}