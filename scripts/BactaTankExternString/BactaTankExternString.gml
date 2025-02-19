/*
	BactaTankExternString
	-------------------------------------------------------------------------
	Script:			BactaTankExternString
	Version:		v1.00
	Created:		10/02/2025 by Alun Jones
	Description:	External string functions for scripting
	-------------------------------------------------------------------------
	History:
	 - Created 10/02/2025 by Alun Jones
	
	To Do:
	 - Add a whole bunch of string functions
*/

function BactaTankExternString() constructor
{
	empty = function(str)
	{
		return (str == "" or ord(str) == 0);
	}
	
	split = function(str, delimeter)
	{
		return string_split(str, delimeter, true);
	}
	
	letters = function(str)
	{
		return string_letters(str);
	}
	
	variable_struct_set(self, "string", function(str) { return string(str); });
}