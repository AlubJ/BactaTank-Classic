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
/// @param {Id.Buffer} buffer
/// @returns {Real}
function buffer_read_pointer(_buffer)
{
	// Get current offset
	var _offset = buffer_tell(_buffer);
	
	// Return
	return _offset + buffer_read(_buffer, buffer_s32);
}

/// @func buffer_peek_pointer(buffer, offset)
/// @desc Peek a relative pointer from a buffer and return the absolute offset.
/// @param {Id.Buffer} buffer
/// @param {Real} offset
/// @returns {Real}
function buffer_peek_pointer(_buffer, _offset)
{
	// Return
	return _offset + buffer_peek(_buffer, _offset, buffer_s32);
}

/// @func buffer_jump(buffer, offset)
/// @desc Jump to an absolute position in a buffer.
/// @param {Id.Buffer} buffer
/// @param {Real} offset
function buffer_jump(_buffer, _offset)
{
	return buffer_seek(_buffer, buffer_seek_start, _offset);
}

/// @func buffer_hop(buffer, offset)
/// @desc Jump to a relative position in a buffer.
/// @param {Id.Buffer} buffer
/// @param {Real} offset
function buffer_hop(_buffer, _offset)
{
	return buffer_seek(_buffer, buffer_seek_relative, _offset);
}

/// @func buffer_read_chars(buffer, charCount)
/// @desc Read a string with a specific number of characters.
/// @param {Id.Buffer} buffer
/// @param {Real} charCount
function buffer_read_chars(_buffer, _charCount)
{
	var _string = "";
    
    repeat (_charCount)
    {
        _string += chr(buffer_read(_buffer, buffer_s8));
    }
    
    return _string;
}