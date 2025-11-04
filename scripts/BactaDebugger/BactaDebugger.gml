/*
	BactaDebugger
	-------------------------------------------------------------------------
	Script:			BactaDebugger
	Version:		v1.00
	Created:		04/11/2025 by Alun Jones
	Description:	BactaTank Debugging helper
	-------------------------------------------------------------------------
	History:
		Created 04/11/2025 by Alun Jones
	
	To Do:
		Use this to interface with the console window and the GameMaker console too.
*/

// Macro to store debugger in
#macro DEBUGGER			global.__debugger__
DEBUGGER = new BactaDebugger();

/// @func BactaDebugger()
/// @desc Debugger for BactaTank.
function BactaDebugger() constructor
{
	/// @func print(string)
	/// @desc Print out to the debug log and console if open.
	/// @param {String} string The string to print out.
	static print = function(_string)
	{
		if (RUN_FROM_IDE) show_debug_message("<BactaTank> " + _string);
	}
	
	/// @func assert(condition, [string])
	/// @desc Assert a condition is true and throw an error if that occurs.
	/// @param {Bool} condition The condition to check.
	/// @param {String} string The message to throw.
	static assert = function(_condition, _string = "Condition failed.")
	{
		// Check
		if (!_condition) throw (TRACE + _string);
	}
}