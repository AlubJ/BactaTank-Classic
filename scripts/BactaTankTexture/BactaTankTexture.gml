/*
	BactaTankTexture
	-------------------------------------------------------------------------
	Script:			BactaTankTexture
	Version:		v1.00
	Created:		05/02/2025 by Alun Jones
	Description:	Texture Loader and Container
	-------------------------------------------------------------------------
	History:
	 - Created 04/02/2025 by Alun Jones
	
	To Do:
*/

function BactaTankTexture() constructor
{
	// Texture Properties
	width = 0;
	height = 0;
	mipmapCount = 0;
	compression = 0;
	size = 0;
	cubemap = false;
	
	// Texture
	sprite = noone;
	texture = noone;
	data = noone;
	
	// Other
	file = "";
	offset = 0;
	
	#region Parse / Inject
	
	static parseMetadata = function(buffer, _model)
	{
		// Texture Metadata
		offset = buffer_tell(buffer) - _model.nu20Offset;
		
		// Texture Dimensions
		width = buffer_read(buffer, buffer_u32);
		height = buffer_read(buffer, buffer_u32);
			
		// NU20 Last MetaData
		if (_model.version == BTModelVersion.pcghgNU20First)
		{
			// Seek to cubemap
			buffer_seek(buffer, buffer_seek_relative, 0x2c);
			cubemap = buffer_read(buffer, buffer_u32);
			
			// Read DXT Compression
			compression = buffer_read(buffer, buffer_u32);
				
			// Seek to size
			buffer_seek(buffer, buffer_seek_relative, 0x08);
			size = buffer_read(buffer, buffer_u32);
		}
		
		// Log
		//ConsoleLog($"Texture {i} Meta Data: Width: {textureWidth}  Height: {textureHeight}  Size: {textureSize}", CONSOLE_MODEL_LOADER_DEBUG, textureOffset + self.nu20Offset);
	}
	
	static parse = function(buffer, _model)
	{
		// PCGHG Last
		if (_model.version == BTModelVersion.pcghgNU20Last)
		{
			// Texture Meta Data
			width = buffer_read(buffer, buffer_s32);
			height = buffer_read(buffer, buffer_s32);
			compression = buffer_read(buffer, buffer_s32);
			mipmapCount = buffer_read(buffer, buffer_s32);
			var unknown = buffer_read(buffer, buffer_s32);
			size = buffer_read(buffer, buffer_u32);
			if (width < 0) width = -width;
		}
		
		// Texture Buffer
		data = buffer_create(size, buffer_fixed, 1);
		buffer_copy(buffer, buffer_tell(buffer), size, data, 0);
		//ConsoleLog($"	Data: 0x{self.textureMetaData[i].size}", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer));
		
		// Get Textures File Name For Saving
		var name = buffer_sha1(data, 0, size);
		file = TEMP_DIRECTORY + name;
		
		// Convert DDS to PNG
		if (!file_exists(TEMP_DIRECTORY + @"\_textures\" + name + ".png"))
		{
			sprite = ddsLoad(data);
			sprite_save(sprite, 0, TEMP_DIRECTORY + @"\_textures\" + name + ".png");
		}
		else
		{
			sprite = sprite_add(TEMP_DIRECTORY + @"\_textures\" + name + ".png", 1, false, false, 0, 0);
		}
		
		// Set Texture
		texture = sprite_get_texture(sprite, 0);
		
		// Seek Forward Past Texture
		buffer_seek(buffer, buffer_seek_relative, size);
	}
	
	#endregion
	
	#region Serialize / Deserialize
	
	
	
	#endregion
	
	#region Export / Replace Textures
	
	/// @func exportTexture()
	/// @desc Export DDS Texture
	static exportTexture = function(textureIndex, filepath)
	{
		// Log
		ConsoleLog($"Exporting Texture {textureIndex} to \"{filepath}\"", CONSOLE_MODEL_LOADER);
		
		// Save Texture
		buffer_save(self.textures[self.textureMetaData[textureIndex].index].data, filepath);
	}
	
	/// @func replaceTexture()
	/// @desc Replace DDS Texture
	static replaceTexture = function(textureIndex, filepath)
	{
		// Log
		ConsoleLog($"Replacing Texture {textureIndex} from \"{filepath}\"", CONSOLE_MODEL_LOADER);
		
		// Load New Texture Buffer
		var buffer = buffer_load(filepath);
		
		// Get Metadata
		var newWidth = buffer_peek(buffer, 0x10, buffer_u32);
		var newHeight = buffer_peek(buffer, 0x0c, buffer_u32);
		var newSize = buffer_get_size(buffer);
		
		// Get Textures File Name For Saving
		var name = buffer_sha1(buffer, 0, newSize);
		self.textureMetaData[textureIndex].file = TEMP_DIRECTORY + @"\" + name;
		
		// Convert DDS to PNG
		var sprite = ddsLoad(buffer);
		sprite_save(sprite, 0, TEMP_DIRECTORY + @"\_textures\" + name + ".png")
					
		// Free Memory
		var oldSpriteIndex = self.textures[self.textureMetaData[textureIndex].index].sprite;
		buffer_delete(self.textures[self.textureMetaData[textureIndex].index].data);
		
		// Set Buffer
		self.textures[self.textureMetaData[textureIndex].index].data = buffer;
		self.textureMetaData[textureIndex].width = newWidth;
		self.textureMetaData[textureIndex].height = newHeight;
		self.textureMetaData[textureIndex].size = newSize;
		self.textureMetaData[textureIndex].compression = array_get_index(BT_DXT_COMPRESSION, buffer_peek(buffer, 0x54, buffer_string));
		
		// Add Sprite
		self.textures[self.textureMetaData[textureIndex].index].sprite = sprite;
		self.textures[self.textureMetaData[textureIndex].index].texture = sprite_get_texture(sprite, 0);
		sprite_delete(oldSpriteIndex);
	}
	
	/// @func addTexture()
	/// @desc Add DDS Texture
	static addTexture = function(filepath)
	{
		
	}
	
	#endregion
}