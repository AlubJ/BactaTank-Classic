/*
	BactaTankExtern
	-------------------------------------------------------------------------
	Script:			BactaTankExtern
	Version:		v1.00
	Created:		10/02/2025 by Alun Jones
	Description:	BactaTank External Functions
	-------------------------------------------------------------------------
	History:
	 - Created 10/02/2025 by Alun Jones
	
	To Do:
*/

enum BactaTankScript
{
	Tool,
	Material,
	Mesh,
}

function BactaTankExtern() constructor
{
	// Register Function
	register = function(target, name, func)
	{
		switch(target)
		{
			case BactaTankScript.Tool:
				variable_struct_set(TOOL_SCRIPTS, name, func);
				break;
			case BactaTankScript.Material:
				variable_struct_set(MATERIAL_SCRIPTS, name, func);
				break;
			case BactaTankScript.Mesh:
				variable_struct_set(MESH_SCRIPTS, name, func);
				break;
		}
	}
	
	// Log Function
	log = function(str)
	{
		ConsoleLog(str, CONSOLE_SCRIPT);
	}
}