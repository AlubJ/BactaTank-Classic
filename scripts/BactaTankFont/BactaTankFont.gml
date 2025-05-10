/*
	BactaTankFont
	-------------------------------------------------------------------------
	Script:			BactaTankFont
	Version:		v1.00
	Created:		29/11/2023 by Alun Jones
	Description:	NU20 Font Loader and Container
	-------------------------------------------------------------------------
	History:
	 - Created 29/11/2023 by Alun Jones
	
	To Do:
*/

function BactaTankFont(font = -1) constructor
{
	// Character Array
	glyphs = {  };
	characters = [  ];
	characterCount = 0;
	characterHeight = 0;
	whiteSpaceWidth = 0;
	texture = noone;
	
	// Check Model Argument
	if (font == -1) return;
	else
	{
		if (filename_ext(string_lower(font)) == ".fnt") load(font);
	}
	
	// Load Function
	static load = function(font)
	{
		// Load Buffer
		var buffer = buffer_load(font);
		
		// Read Header
		var unknownBlockPointer			= buffer_read(buffer, buffer_u32);
		var unknown1					= buffer_read(buffer, buffer_u32);
		var textureOffset				= buffer_read(buffer, buffer_u32) + buffer_tell(buffer) - 4;
		var unknown2					= buffer_read(buffer, buffer_u32);
		var unknown3					= buffer_read(buffer, buffer_u32);
		var mipMapCount					= buffer_read(buffer, buffer_u32);
		var characterDataBlockSize		= buffer_read(buffer, buffer_u32);
		characterCount					= buffer_read(buffer, buffer_u32);
		var characterCount2				= buffer_read(buffer, buffer_u32);
		characterHeight					= buffer_read(buffer, buffer_f32);
		var unknown4					= buffer_read(buffer, buffer_u32);
		whiteSpaceWidth					= buffer_read(buffer, buffer_f32);
		buffer_seek(buffer, buffer_seek_relative, 0x14);
		var characterDataOffset			= buffer_read(buffer, buffer_u32) + buffer_tell(buffer) - 4;
		var glyphDataOffset				= buffer_read(buffer, buffer_u32) + buffer_tell(buffer) - 4;
		var textureSize					= unknownBlockPointer - textureOffset;
		
		// Read Character Data
		buffer_seek(buffer, buffer_seek_start, characterDataOffset);
		for (var i = 0; i < characterCount; i++)
		{
			var charPosX = buffer_read(buffer, buffer_f32);
			var charPosY = buffer_read(buffer, buffer_f32);
			var charWidth = buffer_read(buffer, buffer_f32);
			
			characters[i] = {
				x: charPosX,
				y: charPosY,
				width: charWidth,
				height: characterHeight,
				sprite: noone,
			}
		}
		
		// Read Glyph Data
		buffer_seek(buffer, buffer_seek_start, glyphDataOffset);
		for (var i = 0; i < characterCount; i++)
		{
			var characterIndex = buffer_read(buffer, buffer_s16);
			var glyphIndex = buffer_read(buffer, buffer_s16);
			
			variable_struct_set(glyphs, chr(characterIndex), characters[glyphIndex]);
		}
		
		// Read Texture Data
		buffer_seek(buffer, buffer_seek_start, textureOffset);
		var textureBuffer = buffer_create(textureSize, buffer_fixed, 1);
		buffer_copy(buffer, textureOffset, textureSize, textureBuffer, 0);
		var surface = ddsLoadSurface(textureBuffer);
		buffer_delete(textureBuffer);
		
		// Create Sprite
		texture = sprite_create_from_surface(surface, 0, 0, surface_get_width(surface), surface_get_height(surface), false, false, 0, 0);
		
		for (var i = 0; i < characterCount; i++)
		{
			characters[i].sprite = sprite_create_from_surface(surface, characters[i].x, characters[i].y, characters[i].width, characters[i].height, false, false, 0, 0);
		}
		
		// Delete Buffer
		surface_free(surface);
		buffer_delete(buffer);
	}
}