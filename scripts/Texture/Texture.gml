/*
	Core
	-------------------------------------------------------------------------
	File:			Texture.gml
	Version:		v1.00
	Created:		13/09/2025 by Alun Jones
	Description:	Texture Constructor
	-------------------------------------------------------------------------
	History:
	 - Created 13/09/2025 by Alun Jones

	To Do:
*/

enum _COMPRESSION_TYPE
{
	BC1,			// DXT1 Compression
	BC2,			// DXT3 Compression
	BC3,			// DXT5 Compression
	RGBA_UNORM,		// No Compression
}

function Texture(_source, _width = 0, _height = 0, _compressionType = _COMPRESSION_TYPE.RGBA_UNORM, _generateMipmaps = false, _errorDiffuseDither = false) constructor
{
	// Default Variables
	texturePointer = pointer_null;
	width = _width;
	height = _height;
	compressionType = _compressionType;
	
	// Let's Decode
	if (buffer_exists(_source))
	{
		if (compressionType == _COMPRESSION_TYPE.RGBA_UNORM)
		{
			// Load DDS
			texturePointer = ptr(DDSLoad(buffer_get_address(_source), buffer_get_size(_source)));
			
			// Srote Width and Height
			width = DDSWidth(texturePointer);
			height = DDSHeight(texturePointer);
		}
		else
		{
			// Create Texture
			texturePointer = ptr(DDSCreate(width, height, compressionType, _generateMipmaps, _errorDiffuseDither));
			
			// Compress Buffer
			var hr = DDSCompress(texturePointer, buffer_get_address(_source));
			
			// Srote Width and Height
			width = DDSWidth(texturePointer);
			height = DDSHeight(texturePointer);
		}
	}
	else if (sprite_exists(_source))
	{
		if (compressionType == _COMPRESSION_TYPE.RGBA_UNORM)
		{
			throw ("Cannot convert a sprite to RGBA_UNORM");
		}
		else
		{
			// Get Width and Height
			width = sprite_get_width(_source);
			height = sprite_get_height(_source);
			
			// Create Surface from Sprite
			var _surface = surface_create(width, height);
			surface_set_target(_surface);
			draw_clear_alpha(c_black, 0);
			draw_sprite(_source, 0, 0, 0);
			surface_reset_target();
			
			// Create Buffer
			var _buffer = buffer_create(width * height * 4, buffer_fixed, 1);
			buffer_get_surface(_buffer, _surface, 0);
			
			// Free Surface
			surface_free(_surface);
			
			// Create Texture
			texturePointer = ptr(DDSCreate(width, height, compressionType, _generateMipmaps, _errorDiffuseDither));
			
			// Compress Buffer
			var hr = DDSCompress(texturePointer, buffer_get_address(_buffer));
			
			// Srote Width and Height
			width = DDSWidth(texturePointer);
			height = DDSHeight(texturePointer);
			
			// Free Buffer
			buffer_delete(_buffer);
		}
	}
	
	#region Methods
	
	/// @func toSprite()
	static toSprite = function()
	{
		// Validate Compression Type
		if (compressionType != _COMPRESSION_TYPE.RGBA_UNORM || texturePointer == pointer_null) return -1;
		
		// Create Buffer
		var _textureBuffer = toBuffer();
		
		// Convert To Surface
		var _surface = surface_create(width, height);
		buffer_set_surface(_textureBuffer, _surface, 0);
		
		// Convert To Sprite
		var _sprite = sprite_create_from_surface(_surface, 0, 0, width, height, false, false, 0, 0);
		
		// Clean-Up
		buffer_delete(_textureBuffer);
		surface_free(_surface);
		
		// Return Sprite
		return _sprite;
	}
	
	/// @func toBuffer()
	static toBuffer = function()
	{
		// Validate Texture
		if (texturePointer = pointer_null) return -1;
		
		// Create Buffer
		var _textureBuffer = buffer_create(DDSSize(texturePointer), buffer_fixed, 1);
		buffer_set_used_size(_textureBuffer, DDSSize(texturePointer));
		
		// Copy Raw Texture Data
		var _done = DDSCopy(texturePointer, buffer_get_address(_textureBuffer));
		
		// Return Buffer
		return _textureBuffer;
	}
	
	/// @func toFile(filepath)
	static toFile = function(_filepath)
	{
		// Validate Compression Type
		if (texturePointer == pointer_null) return -1;
		
		// Get Extension
		var _extension = string_lower(filename_ext(_filepath));
		
		if (_extension == ".png" && compressionType == _COMPRESSION_TYPE.RGBA_UNORM)
		{
			// Get Sprite
			var _sprite = toSprite();
			
			// Save Sprite
			sprite_save(_sprite, 0, _filepath);
			
			// Delete Sprite
			sprite_delete(_sprite);
		}
		else
		{
			// Get Buffer
			var _textureBuffer = toBuffer();
			
			// Save Buffer
			buffer_save(_textureBuffer, _filepath);
			
			// Delete Buffer
			buffer_delete(_textureBuffer);
		}
	}
	
	/// @func destroy()
	static destroy = function()
	{
		// Validate Texture
		if (texturePointer == pointer_null) return -1;
		
		// Delete DDS
		DDSDestroy(texturePointer);
	}
	
	#endregion
}