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
	lastFilename = "";
	
	// Texture
	sprite = noone;
	texture = noone;
	data = noone;
	
	// Other
	file = "";
	offset = 0;
	
	#region Parse / Inject
	
	static parseMetadata = function(buffer, _index, _model)
	{
		// Texture Metadata
		offset = buffer_tell(buffer) - _model.nu20Offset;
		
		// Log
		ConsoleLog($"Texture {_index}", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer));
		
		// Texture Dimensions
		width = buffer_read(buffer, buffer_u32);
		ConsoleLog($"    Width:        {width}", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer) - 4);
		height = buffer_read(buffer, buffer_u32);
		ConsoleLog($"    Height:       {height}", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer) - 4);
			
		// NU20 Last MetaData
		if (_model.nu20Offset == 0)
		{
			// Seek to cubemap
			buffer_seek(buffer, buffer_seek_relative, 0x2c);
			cubemap = buffer_read(buffer, buffer_u32);
			ConsoleLog($"    Is Cubemap:    {cubemap > 0 ? "True" : "False"}", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer) - 4);
			
			// Read DXT Compression
			//compression = buffer_read(buffer, buffer_u32);
			//ConsoleLog($"    Compression:   {BT_DXT_COMPRESSION[compression]}", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer) - 4);
				
			// Seek to size
			buffer_seek(buffer, buffer_seek_relative, 0x0c);
			size = buffer_read(buffer, buffer_u32);
			ConsoleLog($"    Size:          {size}", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer) - 4);
		}
	}
	
	static parse = function(buffer, _index, _model)
	{
		// PCGHG Last
		if (_model.nu20Offset != 0)
		{
			// Texture Meta Data
			width = buffer_read(buffer, buffer_s32);
			height = buffer_read(buffer, buffer_s32);
			mipmapCount = buffer_read(buffer, buffer_s32);
			ConsoleLog($"    Mipmaps:       {mipmapCount}", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer) - 4);
			var unknown = buffer_read(buffer, buffer_s32);
			var unknown = buffer_read(buffer, buffer_s32);
			size = buffer_read(buffer, buffer_u32);
			ConsoleLog($"    Size:          {size}", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer) - 4);
			if (width < 0) width = -width;
		}
		
		// Compression
		//compression = array_get_index(BT_DXT_COMPRESSION, buffer_peek(buffer, buffer_tell(buffer) + 0x54, buffer_string));
		//ConsoleLog($"    Compression:   {BT_DXT_COMPRESSION[compression]}", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer) + 0x54);
		
		// Texture Buffer
		data = buffer_create(size, buffer_fixed, 1);
		buffer_copy(buffer, buffer_tell(buffer), size, data, 0);
		//ConsoleLog($"	Data: 0x{self.textureMetaData[i].size}", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer));
		
		// Get Textures File Name For Saving
		var name = buffer_sha1(data, 0, size);
		file = TEMP_DIRECTORY + name;
		
		// Convert DDS to PNG
		if (file_exists(TEMP_DIRECTORY + @"_textures\" + name + ".png") && SETTINGS.cacheTextures)
		{
			ConsoleLog($"    Loading Cached Texture \"{TEMP_DIRECTORY + @"_textures\" + name + ".png"}\"", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer));
			sprite = sprite_add(TEMP_DIRECTORY + @"_textures\" + name + ".png", 1, false, false, 0, 0);
		}
		else
		{
			ConsoleLog($"    Decoding DDS Texture", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer));
			sprite = ddsLoad(data);
			if (SETTINGS.cacheTextures) sprite_save(sprite, 0, TEMP_DIRECTORY + @"_textures\" + name + ".png");
		}
		
		// Set Texture
		texture = sprite_get_texture(sprite, 0);
		
		// Seek Forward Past Texture
		buffer_seek(buffer, buffer_seek_relative, size);
	}
	
	static inject = function(buffer, _model)
	{
		buffer_poke(buffer, offset, buffer_u32, width);
		buffer_poke(buffer, offset + 0x04, buffer_u32, height);
		if (_model.version == BTModelVersion.Version4)
		{
			buffer_poke(buffer, offset + 0x38, buffer_u32, compression);
			buffer_poke(buffer, offset + 0x44, buffer_u32, size);
		}
	}
	
	#endregion
	
	#region Serialize / Deserialize
	
	
	
	#endregion
	
	#region Export / Replace Textures
	
	/// @func export()
	/// @desc Export DDS Texture
	static export = function(filepath)
	{
		// Save Texture
		buffer_save(data, filepath);
		
		// Set Last Filepath
		lastFilename = filepath;
	}
	
	/// @func replace()
	/// @desc Replace DDS Texture
	static replace = function(filepath)
	{
		// Delete Old Stuff
		buffer_delete(data);
		sprite_delete(sprite);
		
		// Load New Texture Buffer
		data = buffer_load(filepath);
		
		// Get Metadata
		width = buffer_peek(data, 0x10, buffer_u32);
		height = buffer_peek(data, 0x0c, buffer_u32);
		size = buffer_get_size(data);
		compression = array_get_index(BT_DXT_COMPRESSION, buffer_peek(data, 0x54, buffer_string));
		
		// Get Textures File Name For Saving
		var name = buffer_sha1(data, 0, size);
		file = TEMP_DIRECTORY + @"\" + name;
		
		// Convert DDS to PNG
		sprite = ddsLoad(data);
		sprite_save(sprite, 0, TEMP_DIRECTORY + @"\_textures\" + name + ".png");
		texture = sprite_get_texture(sprite, 0);
		
		// Set Last Filepath
		lastFilename = filepath;
	}
	
	/// @func reload()
	/// @desc Reloads last texture if the file exists
	static reload = function()
	{
		if (file_exists(lastFilename))
		{
			// User Feedback
			ENVIRONMENT.openInfoModal("Please wait", "Decoding DDS Texture");
			window_set_cursor(cr_hourglass);
			
			// Define Function
			var func = function(texture, file)
			{
				// Replace Texture
				texture.replace(file);
				
				// Set Last Texture Path
				SETTINGS.lastTexturePath = filename_path(file);
				
				// Enable Renderer
				RENDERER.activate();
				RENDERER.deactivate(2);
				
				// User Feedback
				ENVIRONMENT.closeInfoModal();
				window_set_cursor(cr_default);
			}
			
			// Timesource
			time_source_start(time_source_create(time_source_game, 3, time_source_units_frames, func, [self, lastFilename]));
		}
	}
	
	/// @func addTexture()
	/// @desc Add DDS Texture
	static addTexture = function(filepath)
	{
		
	}
	
	#endregion
}