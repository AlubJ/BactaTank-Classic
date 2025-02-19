/*
	BactaTankExternBuffer
	-------------------------------------------------------------------------
	Script:			BactaTankExternBuffer
	Version:		v1.00
	Created:		10/02/2025 by Alun Jones
	Description:	External buffer functions for scripting
	-------------------------------------------------------------------------
	History:
	 - Created 10/02/2025 by Alun Jones
	
	To Do:
	 - Add a whole bunch of buffer functions
*/

enum ENDIANESS
{
	BIG,
	LITTLE,
}

function BactaTankExternBuffer() constructor
{
	// Buffer Details
	_buffer = noone;
	_reference = -1;
	endianess = ENDIANESS.LITTLE;
	size = -1;
	
	// To String
	toString = function()
	{
		return "BactaTankBuffer";
	}
	
	// Create Buffer
	create = function(_size)
	{
		if (!buffer_exists(_buffer))
		{
			_buffer = buffer_create(_size, buffer_grow, 1);
			size = _size;
			_reference = array_length(SCRIPT_BUFFERS);
			SCRIPT_BUFFERS[_reference] = {
				_buffer: _buffer,
				_exists: true,
			}
		}
	}
	
	// Load Buffer
	load = function(file)
	{
		if (!buffer_exists(_buffer))
		{
			_buffer = buffer_load(file);
			size = buffer_get_size(_buffer);
			_reference = array_length(SCRIPT_BUFFERS);
			SCRIPT_BUFFERS[_reference] = {
				_buffer: _buffer,
				_exists: true,
			}
		}
	}
	
	// Destroy Buffer
	destroy = function()
	{
		if (buffer_exists(_buffer))
		{
			buffer_delete(_buffer);
			size = -1;
			_buffer = noone;
			SCRIPT_BUFFERS[_reference] = {
				_buffer: noone,
				_exists: false,
			}
			_reference = -1;
		}
	}
	
	// Seek
	seek = function(base, offset) { buffer_seek(_buffer, base, offset); }
	
	// Tell
	tell = function() { return buffer_tell(_buffer); }
	
	// Buffer Read
	read = function(type)
	{
		// Read Little Endian First
		if (endianess == ENDIANESS.LITTLE)
		{
			if (type == 0xff)
			{
				// Create Matrix
				var matrix = [  ];
				
				// Read Matrix
				repeat (16) array_push(matrix, self.read(buffer_f32));
				
				// Return Matrix
				return matrix;
			}
			else
			{
				return buffer_read(_buffer, type);
			}
		}
		
		// Read Big Endian
		switch (type)
		{
			case buffer_u16:
			case buffer_s16:
			case buffer_f16:
				var tempBuff = buffer_create(2, buffer_fixed, 1);
			
				buffer_poke(tempBuff, 1, buffer_u8, buffer_read(_buffer, buffer_u8));
				buffer_poke(tempBuff, 0, buffer_u8, buffer_read(_buffer, buffer_u8));

				var returnVal = buffer_peek(tempBuff, 0, type);
			
				buffer_delete(tempBuff);
			
				return returnVal;
				break;
			case buffer_u32:
			case buffer_s32:
			case buffer_f32:
				var tempBuff = buffer_create(4, buffer_fixed, 1);
			
				buffer_poke(tempBuff, 3, buffer_u8, buffer_read(_buffer, buffer_u8));
				buffer_poke(tempBuff, 2, buffer_u8, buffer_read(_buffer, buffer_u8));
				buffer_poke(tempBuff, 1, buffer_u8, buffer_read(_buffer, buffer_u8));
				buffer_poke(tempBuff, 0, buffer_u8, buffer_read(_buffer, buffer_u8));

				var returnVal = buffer_peek(tempBuff, 0, type);
			
				buffer_delete(tempBuff);
			
				return returnVal;
				break;
			case buffer_u64:
			case buffer_f64:
				var tempBuff = buffer_create(8, buffer_fixed, 1);
			
				buffer_poke(tempBuff, 7, buffer_u8, buffer_read(_buffer, buffer_u8));
				buffer_poke(tempBuff, 6, buffer_u8, buffer_read(_buffer, buffer_u8));
				buffer_poke(tempBuff, 5, buffer_u8, buffer_read(_buffer, buffer_u8));
				buffer_poke(tempBuff, 4, buffer_u8, buffer_read(_buffer, buffer_u8));
				buffer_poke(tempBuff, 3, buffer_u8, buffer_read(_buffer, buffer_u8));
				buffer_poke(tempBuff, 2, buffer_u8, buffer_read(_buffer, buffer_u8));
				buffer_poke(tempBuff, 1, buffer_u8, buffer_read(_buffer, buffer_u8));
				buffer_poke(tempBuff, 0, buffer_u8, buffer_read(_buffer, buffer_u8));

				var returnVal = buffer_peek(tempBuff, 0, type);
			
				buffer_delete(tempBuff);
			
				return returnVal;
				break;
			default:
				return buffer_read(_buffer, type);
				break;
		}
	}
	
	// Buffer Peek
	peek = function(type, offset)
	{
		// Read Little Endian First
		if (endianess == ENDIANESS.LITTLE)
		{
			if (type == 0xff)
			{
				// Create Matrix
				var matrix = [  ];
				
				// Read Matrix
				repeat (16) 
				{
					array_push(matrix, self.peek(buffer_f32, offset));
					offset += 4;
				}
				
				// Return Matrix
				return matrix;
			}
			else
			{
				return buffer_peek(_buffer, offset, type);
			}
		}
		
		// Read Big Endian
		switch (type)
		{
			case buffer_u16:
			case buffer_s16:
			case buffer_f16:
				var tempBuff = buffer_create(2, buffer_fixed, 1);
			
				buffer_poke(tempBuff, 1, buffer_u8, buffer_peek(_buffer, offset, buffer_u8));
				buffer_poke(tempBuff, 0, buffer_u8, buffer_peek(_buffer, offset + 1, buffer_u8));

				var returnVal = buffer_peek(tempBuff, 0, type);
			
				buffer_delete(tempBuff);
			
				return returnVal;
				break;
			case buffer_u32:
			case buffer_s32:
			case buffer_f32:
				var tempBuff = buffer_create(4, buffer_fixed, 1);
			
				buffer_poke(tempBuff, 3, buffer_u8, buffer_peek(_buffer, offset, buffer_u8));
				buffer_poke(tempBuff, 2, buffer_u8, buffer_peek(_buffer, offset + 1, buffer_u8));
				buffer_poke(tempBuff, 1, buffer_u8, buffer_peek(_buffer, offset + 2, buffer_u8));
				buffer_poke(tempBuff, 0, buffer_u8, buffer_peek(_buffer, offset + 3, buffer_u8));

				var returnVal = buffer_peek(tempBuff, 0, type);
			
				buffer_delete(tempBuff);
			
				return returnVal;
				break;
			case buffer_u64:
			case buffer_f64:
				var tempBuff = buffer_create(8, buffer_fixed, 1);
			
				buffer_poke(tempBuff, 7, buffer_u8, buffer_peek(_buffer, offset, buffer_u8));
				buffer_poke(tempBuff, 6, buffer_u8, buffer_peek(_buffer, offset + 1, buffer_u8));
				buffer_poke(tempBuff, 5, buffer_u8, buffer_peek(_buffer, offset + 2, buffer_u8));
				buffer_poke(tempBuff, 4, buffer_u8, buffer_peek(_buffer, offset + 3, buffer_u8));
				buffer_poke(tempBuff, 3, buffer_u8, buffer_peek(_buffer, offset + 4, buffer_u8));
				buffer_poke(tempBuff, 2, buffer_u8, buffer_peek(_buffer, offset + 5, buffer_u8));
				buffer_poke(tempBuff, 1, buffer_u8, buffer_peek(_buffer, offset + 6, buffer_u8));
				buffer_poke(tempBuff, 0, buffer_u8, buffer_peek(_buffer, offset + 7, buffer_u8));

				var returnVal = buffer_peek(tempBuff, 0, type);
			
				buffer_delete(tempBuff);
			
				return returnVal;
				break;
			default:
				buffer_poke(_buffer, offset, type, data);
				break;
		}
	}
	
	// Buffer Write
	write = function(type, data)
	{
		// Write Little Endian First
		if (endianess == ENDIANESS.LITTLE)
		{
			buffer_write(_buffer, type, data);
			
			// Re-get size
			size = buffer_get_size(_buffer);
			
			// Return Out
			return;
		}
		
		// Write Big Endian
		switch (type)
		{
			case buffer_u16:
			case buffer_s16:
			case buffer_f16:
				var tempBuff = buffer_create(2, buffer_fixed, 1);

				buffer_write(tempBuff, type, data);
				
				buffer_write(_buffer, buffer_u8, buffer_peek(tempBuff, 1, buffer_u8));
				buffer_write(_buffer, buffer_u8, buffer_peek(tempBuff, 0, buffer_u8));
			
				buffer_delete(tempBuff);
				break;
			case buffer_u32:
			case buffer_s32:
			case buffer_f32:
				var tempBuff = buffer_create(4, buffer_fixed, 1);

				buffer_write(tempBuff, type, data);
				
				buffer_write(_buffer, buffer_u8, buffer_peek(tempBuff, 3, buffer_u8));
				buffer_write(_buffer, buffer_u8, buffer_peek(tempBuff, 2, buffer_u8));
				buffer_write(_buffer, buffer_u8, buffer_peek(tempBuff, 1, buffer_u8));
				buffer_write(_buffer, buffer_u8, buffer_peek(tempBuff, 0, buffer_u8));
			
				buffer_delete(tempBuff);
				break;
			case buffer_u64:
			case buffer_f64:
				var tempBuff = buffer_create(8, buffer_fixed, 1);

				buffer_write(tempBuff, type, data);
				
				buffer_write(_buffer, buffer_u8, buffer_peek(tempBuff, 7, buffer_u8));
				buffer_write(_buffer, buffer_u8, buffer_peek(tempBuff, 6, buffer_u8));
				buffer_write(_buffer, buffer_u8, buffer_peek(tempBuff, 5, buffer_u8));
				buffer_write(_buffer, buffer_u8, buffer_peek(tempBuff, 4, buffer_u8));
				buffer_write(_buffer, buffer_u8, buffer_peek(tempBuff, 3, buffer_u8));
				buffer_write(_buffer, buffer_u8, buffer_peek(tempBuff, 2, buffer_u8));
				buffer_write(_buffer, buffer_u8, buffer_peek(tempBuff, 1, buffer_u8));
				buffer_write(_buffer, buffer_u8, buffer_peek(tempBuff, 0, buffer_u8));
			
				buffer_delete(tempBuff);
				break;
			default:
				buffer_write(_buffer, type, data);
				break;
		}
		
		// Re-get size
		size = buffer_get_size(_buffer);
	}
	
	// Buffer Poke
	poke = function(type, offset, data)
	{
		// Poke Little Endian First
		if (endianess == ENDIANESS.LITTLE)
		{
			// Poke Buffer
			buffer_poke(_buffer, offset, type, data);
			
			// Return Out
			return;
		}
		
		// Poke Big Endian
		switch (type)
		{
			case buffer_u16:
			case buffer_s16:
			case buffer_f16:
				var tempBuff = buffer_create(2, buffer_fixed, 1);

				buffer_write(tempBuff, type, data);
				
				buffer_poke(_buffer, offset, buffer_u8, buffer_peek(tempBuff, 1, buffer_u8));
				buffer_poke(_buffer, offset + 1, buffer_u8, buffer_peek(tempBuff, 0, buffer_u8));
			
				buffer_delete(tempBuff);
				break;
			case buffer_u32:
			case buffer_s32:
			case buffer_f32:
				var tempBuff = buffer_create(4, buffer_fixed, 1);

				buffer_write(tempBuff, type, data);
				
				buffer_poke(_buffer, offset, buffer_u8, buffer_peek(tempBuff, 3, buffer_u8));
				buffer_poke(_buffer, offset + 1, buffer_u8, buffer_peek(tempBuff, 2, buffer_u8));
				buffer_poke(_buffer, offset + 2, buffer_u8, buffer_peek(tempBuff, 1, buffer_u8));
				buffer_poke(_buffer, offset + 3, buffer_u8, buffer_peek(tempBuff, 0, buffer_u8));
			
				buffer_delete(tempBuff);
				break;
			case buffer_u64:
			case buffer_f64:
				var tempBuff = buffer_create(8, buffer_fixed, 1);

				buffer_write(tempBuff, type, data);
				
				buffer_poke(_buffer, offset, buffer_u8, buffer_peek(tempBuff, 7, buffer_u8));
				buffer_poke(_buffer, offset + 1, buffer_u8, buffer_peek(tempBuff, 6, buffer_u8));
				buffer_poke(_buffer, offset + 2, buffer_u8, buffer_peek(tempBuff, 5, buffer_u8));
				buffer_poke(_buffer, offset + 3, buffer_u8, buffer_peek(tempBuff, 4, buffer_u8));
				buffer_poke(_buffer, offset + 4, buffer_u8, buffer_peek(tempBuff, 3, buffer_u8));
				buffer_poke(_buffer, offset + 5, buffer_u8, buffer_peek(tempBuff, 2, buffer_u8));
				buffer_poke(_buffer, offset + 6, buffer_u8, buffer_peek(tempBuff, 1, buffer_u8));
				buffer_poke(_buffer, offset + 7, buffer_u8, buffer_peek(tempBuff, 0, buffer_u8));
			
				buffer_delete(tempBuff);
				break;
			default:
				return buffer_read(_buffer, type);
				break;
		}
	}
	
	// Save Buffer
	save = function(filepath)
	{
		buffer_save(_buffer, filepath);
	}
}

function newBactaTankExternBuffer() { return new BactaTankExternBuffer(); }