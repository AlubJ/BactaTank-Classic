/*
	BactaTankSpecialObject
	-------------------------------------------------------------------------
	Script:			BactaTankSpecialObject
	Version:		v1.00
	Created:		06/02/2025 by Alun Jones
	Description:	Special Object Loader and Container
	-------------------------------------------------------------------------
	History:
	 - Created 06/02/2025 by Alun Jones
	
	To Do:
	 - Remove the indexing, use "mesh links" instead, IDing with their command list index.
*/

function BactaTankSpecialObject() constructor
{
	// Variables
	name = "";
	model = 0;
	
	// Other
	offset = 0;
	
	#region Parse / Inject
	
	static parse = function(buffer, _model)
	{
		// Get Offset
		offset = buffer_tell(buffer) - _model.nu20Offset
		
		// Temp Offset
		var tempOffset = buffer_tell(buffer);
		
		// Skip Over Matrix, IABL, and Random Vectors
		buffer_seek(buffer, buffer_seek_relative, 0xb0);
		
		// Mesh Data Pointer
		var meshDataPointer = buffer_read(buffer, buffer_s32);
		
		// Read Special Object Name
		var specialObjectNamePointer = buffer_read(buffer, buffer_s32) - 4;
		name = buffer_peek(buffer, buffer_tell(buffer) + specialObjectNamePointer, buffer_string);
		
		model = getModelIndex((buffer_tell(buffer) + meshDataPointer - 8) - _model.nu20Offset, _model);
		
		// Seek To End Of Special Object
		buffer_seek(buffer, buffer_seek_start, tempOffset + 0xD0);
	}
	
	#endregion
	
	#region Serialize / Deserialize
	
	
	
	#endregion
	
	#region helper
	
	static getModelIndex = function(pointer, _model)
	{	
		// Find Model
		for (var i = 0; i < array_length(_model.models); i++)
		{
			if (_model.models[i].offset == pointer) return i;
		}
		
		// Return -1 just incase
		return -1;
	}
	
	#endregion
}