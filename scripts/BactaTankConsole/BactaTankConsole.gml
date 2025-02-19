/*
	BactaTankConsole (c) Alun Jones
	-------------------------------------------------------------------------
	Script:			BactaTank Console
	Version:		v1.00
	Created:		11/01/2025 by Alun Jones
	Description:	BactaTank Console
	-------------------------------------------------------------------------
	History:
	 - Created 11/01/2025 by Alun Jones
	
	To Do:
*/

#macro CONSOLE_DEFAULT					"BactaTank"
#macro CONSOLE_SCRIPT					"BactaTankScript"
#macro CONSOLE_MODEL_LOADER				"BactaTankModel"
#macro CONSOLE_MODEL_LOADER_DEBUG		"BactaTankModelDebug"
#macro CONSOLE_RENDERER					"CalicoRenderer"
#macro CONSOLE_ERROR					"BactaTankError"

// Log
function ConsoleLog(str, type = CONSOLE_DEFAULT, offset = 0)
{
	// Final String
	var finalString = $"<{type}";
	
	switch(type)
	{
		case CONSOLE_MODEL_LOADER_DEBUG:
			finalString += $"[0x{string_hex(offset)}]> {str}";
			if (SETTINGS.verboseOutput)
			{
				ConsolePrint(finalString + "\n");
				show_debug_message(finalString);
			}
			break;
		default:
			finalString += $"> {str}";
			ConsolePrint(finalString + "\n");
			show_debug_message(finalString);
			break;
	}
}