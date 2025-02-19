/*
	BactaTankExternMath
	-------------------------------------------------------------------------
	Script:			BactaTankExternMath
	Version:		v1.00
	Created:		10/02/2025 by Alun Jones
	Description:	External math functions for scripting
	-------------------------------------------------------------------------
	History:
	 - Created 10/02/2025 by Alun Jones
	
	To Do:
	 - Add a whole bunch of math functions
*/

function BactaTankExternMath()
{
	// Create Math Struct
	var math = {  };
	
	// Floor Method
	var floorMethod = function(value)
	{
		return floor(value);
	}
	variable_struct_set(math, "floor", floorMethod);
	
	// Round Method
	var roundMethod = function(value)
	{
		return round(value);
	}
	variable_struct_set(math, "round", roundMethod);
	
	return math;
}