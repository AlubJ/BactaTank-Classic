/*
	BactaTankAssetPack
	-------------------------------------------------------------------------
	Script:			BactaTankAssetPack
	Version:		v1.00
	Created:		22/11/2024 by Alun Jones
	Description:	BactaTank Asset Pack Constructor
	-------------------------------------------------------------------------
	History:
	 - Created 22/11/2024 by Alun Jones
	
	To Do:
	 - Add Previews?
	 - Deserialize
	 - Version (stringify it "1.0.0" or something)
*/

// Asset Pack Version
#macro BT_ASSET_PACK_VERSION	1.0

// Asset Pack Type
enum BTAssetPackType
{
	TCS,
	LIJ1,
	LB1,
}
global.__assetPackType = ["TCS", "LIJ1", "LB1"];
#macro BT_ASSET_PACK_TYPE		global.__assetPackType

// Asset Type
enum BTAssetType
{
	MODEL,
	ANIMATION,
	BSA,
	AUDIO,
}
global.__assetType = ["Model", "Animation", "BSA", "Audio"];
#macro BT_ASSET_TYPE		global.__assetType

function BactaTankAssetPack(assetPackName = "BTAssetPack", assetPackType = BTAssetPackType.TCS, assetPackAuthor = "", saveLoc = "") constructor
{
	// General
	name = assetPackName;
	type = assetPackType;
	author = assetPackAuthor;
	version = [1, 0, 0];
	uuid = "";
	source = "";
	
	// Assets
	assets = [  ]; // Name, Type, Data Offset, 
	assetsPack = [  ]; // Name, Type, Data
	
	// Save Location
	saveLocation = saveLoc;
	
	#region Methods
	
	// Add
	static add = function(assetLocation = "")
	{
		// Get Name
		var assetName = string_upper(string_split(filename_name(assetLocation), ".")[0]);
		
		// Get Type
		var assetType = verify_asset_format(filename_ext(assetLocation));
		
		// Get Asset Data
		var assetData = noone;
		if (string_lower(filename_ext(assetLocation)) == ".ghg")
		{
			var model = new BactaTankModel(assetLocation);
			assetData = buffer_create(1, buffer_grow, 1)
			model.serialize(assetData);
			model.destroy();
		}
		else
		{
			assetData = buffer_load(assetLocation);
		}
		
		// Add To Array
		array_push(assetsPack, {
			name: assetName,
			type: assetType,
			data: assetData,
			dataCompressed: noone,
		});
	}
	
	#endregion
	
	#region Serialize / Deserialize Methods
	
	// Serialize
	static serialize = function()
	{
		// Create Buffer
		var buffer = buffer_create(1, buffer_grow, 1);
		
		// Write File Header
		buffer_write(buffer, buffer_string, "BactaTankAssetPack");
		buffer_write(buffer, buffer_string, name);
		buffer_write(buffer, buffer_string, author);
		buffer_write(buffer, buffer_string, BT_ASSET_PACK_TYPE[type]);
		buffer_write(buffer, buffer_s16, version[0]);
		buffer_write(buffer, buffer_s16, version[1]);
		buffer_write(buffer, buffer_s16, version[2]);
		buffer_write(buffer, buffer_f32, BT_ASSET_PACK_VERSION);
		
		// Write Assets
		buffer_write(buffer, buffer_s32, array_length(assetsPack));
		
		// Work Out Starting Offset
		var assetOffset = buffer_tell(buffer);
		for (var i = 0; i < array_length(assetsPack); i++)
		{
			assetOffset += string_length(assetsPack[i].name) + 1;
			assetOffset += string_length(BT_ASSET_TYPE[assetsPack[i].type]) + 1;
			assetOffset += 16; // Compressed size / Uncompressed size / Checksum / Offset
		}
		
		// Write Asset Table
		for (var i = 0; i < array_length(assetsPack); i++)
		{
			// Compressed Data
			var size = buffer_get_size(assetsPack[i].data);
			var checksum = buffer_crc32(assetsPack[i].data, 0, size);
			assetsPack[i].dataCompressed = buffer_compress(assetsPack[i].data, 0, size);
			var sizeCompressed = buffer_get_size(assetsPack[i].dataCompressed);
			
			// Write Asset
			buffer_write(buffer, buffer_string, assetsPack[i].name);
			buffer_write(buffer, buffer_string, BT_ASSET_TYPE[assetsPack[i].type]);
			buffer_write(buffer, buffer_u32, assetOffset);
			buffer_write(buffer, buffer_u32, sizeCompressed);
			buffer_write(buffer, buffer_u32, size);
			buffer_write(buffer, buffer_u32, checksum);
			
			// Increase Asset Offset
			assetOffset += sizeCompressed;
		}
		
		// Write Assets
		for (var i = 0; i < array_length(assetsPack); i++)
		{
			// Write Asset
			buffer_copy(assetsPack[i].dataCompressed, 0, buffer_get_size(assetsPack[i].dataCompressed), buffer, buffer_tell(buffer));
			
			// Seek Forward
			buffer_seek(buffer, buffer_seek_relative, buffer_get_size(assetsPack[i].dataCompressed));
			
			// Delete Buffers
			buffer_delete(assetsPack[i].dataCompressed);
			buffer_delete(assetsPack[i].data);
		}
		
		// Save Buffer
		buffer_save(buffer, saveLocation);
		
		// Delete Buffer
		buffer_delete(buffer);
	}
	
	// Deserialize
	static deserialize = function(filepath)
	{
		// Source
		source = filename_name(filepath);
		
		// Create Buffer
		var buffer = buffer_load(filepath);
		
		// Read File Header
		var filemagic = buffer_read(buffer, buffer_string);
		name = buffer_read(buffer, buffer_string);
		author = buffer_read(buffer, buffer_string);
		version[0] = buffer_read(buffer, buffer_s16);
		version[1] = buffer_read(buffer, buffer_s16);
		version[2] = buffer_read(buffer, buffer_s16);
		type = array_get_index(BT_ASSET_PACK_TYPE, buffer_read(buffer, buffer_string));
		var fileVersion = buffer_read(buffer, buffer_f32);
		
		// Read Assets
		var assetPackCount = buffer_read(buffer, buffer_s32);
		
		// Read Asset Table
		repeat(assetPackCount)
		{	
			// Read Asset
			var assetName = buffer_read(buffer, buffer_string);
			var assetType = array_get_index(BT_ASSET_TYPE, buffer_read(buffer, buffer_string));
			var assetOffset = buffer_read(buffer, buffer_u32);
			var assetSizeCompressed = buffer_read(buffer, buffer_u32);
			var assetSize = buffer_read(buffer, buffer_u32);
			var assetChecksum = buffer_read(buffer, buffer_u32);
			
			// Asset
			array_push(assets, {
				name: assetName,
				type: assetType,
				offset: assetOffset,
				sizeCompressed: assetSizeCompressed,
				size: assetSize,
				checksum: assetChecksum,
			});
		}
		
		// Delete Buffer
		buffer_delete(buffer);
	}
	
	#endregion
}



function verify_asset_format(ext)
{
	switch (string_lower(ext))
	{
		case ".ghg":
			return BTAssetType.MODEL;
		case ".an3":
			return BTAssetType.ANIMATION;
		case ".bsa":
			return BTAssetType.BSA;
		case ".wav":
			return BTAssetType.AUDIO;
		case ".bcanister":
			return BTAssetType.MODEL;
	}
	return -1;
}