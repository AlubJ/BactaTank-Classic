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
		var dOffset = offset + _model.nu20Offset;
		ConsoleLog($"Locator {_index}", CONSOLE_MODEL_LOADER_DEBUG, dOffset);
		ConsoleLog($"    Matrix: {matrix}", CONSOLE_MODEL_LOADER_DEBUG, dOffset);
		ConsoleLog($"    Name:   {name}", CONSOLE_MODEL_LOADER_DEBUG, dOffset + 0x40);
		ConsoleLog($"    Parent: {parent}", CONSOLE_MODEL_LOADER_DEBUG, dOffset + 0x44);
	}
	
	static inject = function(buffer)
	{
		// Edit Locator Matrix
		for (var j = 0; j < 16; j++)
		{
			buffer_poke(buffer, offset + (j * 4), buffer_f32, matrix[j]);
		}
		
		// Edit Locator Parent
		buffer_poke(buffer, offset + 0x44, buffer_s32, parent);
	}
	
	#endregion
	
	#region Serialize / Deserialize
	
	
	
	#endregion
	
	#region Export / Replace Locators
	
	/// @func export()
	/// @desc Export BactaTankLocator
	static export = function(filepath)
	{
		// Create Export Buffer
		var buffer = buffer_create(1, buffer_grow, 1);
		
		// Write Header
		buffer_write(buffer, buffer_string, "BactaTankLocator");
		buffer_write(buffer, buffer_string, "PCGHG");
		buffer_write(buffer, buffer_f32, 0.1);
		
		// Write Parent Index
		buffer_write(buffer, buffer_s32, parent);
		
		// Write Matrix
		for (var i = 0; i < 16; i++) buffer_write(buffer, buffer_f32, matrix[i]);
		
		// Buffer Save
		buffer_save(buffer, filepath);
		buffer_delete(buffer);
	}
	
	/// @func replace()
	/// @desc Replace BactaTankLocator
	static replace = function(filepath, _model = noone)
	{
		// Load Locator Buffer
		var buffer = buffer_load(filepath);
		
		// Read Header
		var magic = buffer_read(buffer, buffer_string); // BactaTankLocator
		var format = buffer_read(buffer, buffer_string); // PCGHG
		var version = buffer_read(buffer, buffer_f32); // 0.1
		
		// Version Check
		if (version != 0.1) return;
		
		// Read Parent
		parent = buffer_read(buffer, buffer_s32);
		if (parent >= array_length(_model.bones)) parent = -1;
		
		// Read Matrix
		matrix = [  ];
		repeat(16) array_push(matrix, buffer_read(buffer, buffer_f32));
		
		// Locator Matrix Decomposed
		decomposedMatrix = matrix_decompose(matrix);
		
		// Delete Buffer
		buffer_delete(buffer);
	}
	
	#endregion
}