/*
	BactaTankLocator
	-------------------------------------------------------------------------
	Script:			BactaTankLocator
	Version:		v1.00
	Created:		04/02/2025 by Alun Jones
	Description:	Locator Loader and Container
	-------------------------------------------------------------------------
	History:
	 - Created 04/02/2025 by Alun Jones
	
	To Do:
*/

function BactaTankLocator() constructor
{
	// Locator Data
	name = "";
	parent = -1;
	matrix = matrix_build_identity();
	decomposedMatrix = [[0, 0, 0], [0, 0, 0], [1, 1, 1]];
	index = 0;
	
	// Other
	offset = 0;
	
	#region Parse / Inject
	
	static parse = function(buffer, _model, _index)
	{
		// Locator Offset
		offset = buffer_tell(buffer) - _model.nu20Offset;
		
		// Read Locator Matrix
		matrix = [];
		repeat(16) array_push(matrix, buffer_read(buffer, buffer_f32));
		
		// Locator Name
		name = buffer_peek(buffer, (buffer_tell(buffer) + buffer_read(buffer, buffer_s16)) + 0x2c, buffer_string);
		
		// Locator Bone Parent
		buffer_seek(buffer, buffer_seek_relative, 0x02);
		parent = buffer_read(buffer, buffer_s32);
		
		// Locator Matrix Decomposed
		decomposedMatrix = matrix_decompose(matrix);
		
		// Index
		index = _index;
		
		// Seek 8 Bytes
		buffer_seek(buffer, buffer_seek_relative, 0x08);
		
		// Log
		//var offset = locatorOffset + self.nu20Offset;
		//ConsoleLog($"Locator {i}", CONSOLE_MODEL_LOADER_DEBUG, offset);
		//ConsoleLog($"	Matrix: {locatorMatrix}", CONSOLE_MODEL_LOADER_DEBUG, offset);
		//ConsoleLog($"	Name:   {locatorName}", CONSOLE_MODEL_LOADER_DEBUG, offset + 0x40);
		//ConsoleLog($"	Parent: {locatorParent}", CONSOLE_MODEL_LOADER_DEBUG, offset + 0x44);
	}
	
	#endregion
	
	#region Serialize / Deserialize
	
	
	
	#endregion
}