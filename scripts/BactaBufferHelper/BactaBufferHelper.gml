/*
	BactaBufferHelper
	-------------------------------------------------------------------------
	Script:			BactaBufferHelper
	Version:		v1.00
	Created:		04/11/2025 by Alun Jones
	Description:	Various buffer helper functions.
	-------------------------------------------------------------------------
	History:
		Created 04/11/2025 by Alun Jones
	
	To Do:
*/

/// @func buffer_read_pointer(buffer)
/// @desc Read a relative pointer from a buffer and return the absolute offset.
/// @param {Id.Buffer}
/// @returns {Real}
function buffer_read_pointer(_buffer)
{
	// Get current offset
	var _offset = buffer_tell(_buffer);
	
	// Return
	return _offset + buffer_read(_buffer, buffer_s32);
}