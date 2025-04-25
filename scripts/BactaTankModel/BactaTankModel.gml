/*
	BactaTankModel
	-------------------------------------------------------------------------
	Script:			BactaTankModel
	Version:		v1.00
	Created:		03/09/2023 by Alun Jones
	Description:	NU20 Model Loader and Container
	-------------------------------------------------------------------------
	History:
	 - Created 03/09/2023 by Alun Jones
	
	To Do:
	 - Re-Write Model Exporter to support Collada exporting
	 - Write Text File Parser
*/

function BactaTankModel(model = -1) constructor
{
	// Check Model Argument
	if (model == -1) return;
	else
	{
		// Log
		ConsoleLog($"Attempting To Load \"{model}\"", CONSOLE_MODEL_LOADER);
		
		// Try to Load
		if (filename_ext(string_lower(model)) == ".ghg" || filename_ext(string_lower(model)) == ".gsc") loadGHG(model);
		else if (filename_ext(string_lower(model)) == ".bcanister") loadCanister(model);
	}
	
	#region Load and Save GHG
	
	/// @func loadGHG()
	/// @desc Load Model from GHG file
	static loadGHG = function(model)
	{
		// GSC check
		if (!SETTINGS.allowGSC && filename_ext(string_lower(model)) == ".gsc") throw ("GSC Scene loading is not supported, if you want to attempt to load the model, enable it in the preferences");
		
		// Load Model File Into Buffer
		var buffer = buffer_load(model);
		
		// Get And Check Model Version
		var modelVersion = getVersion(buffer);
		if (modelVersion == BTModelVersion.None) return -1;
		self.version = modelVersion;
		self.offsets = {};
		
		// Log
		ConsoleLog($"Version: {BT_MODEL_VERSION[modelVersion]}", CONSOLE_MODEL_LOADER);
		if (self.version == 1 && !SETTINGS.allowVersion1)
		{
			buffer_delete(buffer);
			buffer_delete(self.data);
			throw ("Model file version 1 is not supported, if you want to load this version of the model, enable it in the preferences");
		}
		
		// NU20 Offset
		var nu20Offset = buffer_tell(buffer);
		self.nu20Offset = nu20Offset;
		ConsoleLog($"NU20", CONSOLE_MODEL_LOADER_DEBUG, nu20Offset);
		
		// Copy NU20 into separate buffer (NU20 isn't completely documented meaning we can't recreate it yet)
		var nu20Size = -buffer_peek(buffer, buffer_tell(buffer) + 4, buffer_s32);
		ConsoleLog($"NU20 Size: 0x{string_hex(nu20Size)}", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer) + 4);
		self.data = buffer_create(nu20Size, buffer_fixed, 1);
		buffer_copy(buffer, buffer_tell(buffer), nu20Size, self.data, 0);
		
		///////// Read NU20 \\\\\\\\\
		// Log
		ConsoleLog($"Reading NU20", CONSOLE_MODEL_LOADER);
		
		// Goto GSNH
		buffer_seek(buffer, buffer_seek_relative, 0x1c);
		buffer_seek(buffer, buffer_seek_relative, buffer_read(buffer, buffer_u32)); // In future -4 from the buffer_read return
		ConsoleLog($"GSNH", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer) + 4);
		
		// GSNH Offset
		var gsnhOffset = buffer_tell(buffer);
		
		// Model Type
		if (buffer_peek(buffer, gsnhOffset + 0x18c, buffer_s32) != 0) self.type = BTModelType.model;
		else self.type = BTModelType.scene;
		if (string_pos("icon", string_lower(buffer_peek(buffer, nu20Offset + 0x2C, buffer_string)))) self.type = BTModelType.icon;
		ConsoleLog($"Type: {BT_MODEL_TYPE[self.type]}", CONSOLE_MODEL_LOADER);
		
		// Texture Metadata
		readTextureMetadata(buffer);
		
		// Read Materials
		buffer_seek(buffer, buffer_seek_start, gsnhOffset + 0x08);
		readMaterials(buffer);
		
		// Read Meshes
		buffer_seek(buffer, buffer_seek_start, gsnhOffset + 0x1cc);
		buffer_seek(buffer, buffer_seek_relative, buffer_read(buffer, buffer_s32) + 0xC);
		readMeshes(buffer);
		
		// Model Specific Attributes
		if (self.type == BTModelType.model)
		{
			// Read Bones
			buffer_seek(buffer, buffer_seek_start, gsnhOffset + 0x164);
			readBones(buffer);
			
			// Read Locators
			buffer_seek(buffer, buffer_seek_start, gsnhOffset + 0x17c);
			readLocators(buffer);
			
			// Read Locators
			buffer_seek(buffer, buffer_seek_start, gsnhOffset + 0x184);
			readLocatorOrder(buffer);
			
			// Seek to DISP (Special Object Count)
			//buffer_seek(buffer, buffer_seek_start, gsnhOffset + 0x10C);
			//buffer_seek(buffer, buffer_seek_relative, buffer_read(buffer, buffer_s32) - 4);
			//var dispOffset = buffer_tell(buffer);
			
			// Read Mesh Links
			//buffer_seek(buffer, buffer_seek_start, dispOffset + 0x10);
			//readModels(buffer);
			
			// Read Special Objects
			//buffer_seek(buffer, buffer_seek_start, dispOffset + 0x6c);
			//readSpecialObjects(buffer);
			
			// Read Layers
			buffer_seek(buffer, buffer_seek_start, gsnhOffset + 0x18c);
			readLayers(buffer);
		}
		else
		{
			// Scene Specific Code Here
			// Seek to DISP (Special Object Count)
			buffer_seek(buffer, buffer_seek_start, gsnhOffset + 0x10C);
			buffer_seek(buffer, buffer_seek_relative, buffer_read(buffer, buffer_s32) - 4);
			var dispOffset = buffer_tell(buffer);
			
			// Read Mesh Links
			buffer_seek(buffer, buffer_seek_start, dispOffset + 0x10);
			readModels(buffer);
			
			// Read Special Objects
			buffer_seek(buffer, buffer_seek_start, dispOffset + 0x6c);
			readSpecialObjects(buffer);
		}
		
		// Seek either to the end of the NU20 or the start of the file depending on version
		if (nu20Offset == 0) buffer_seek(buffer, buffer_seek_start, nu20Size + 4);
		else buffer_seek(buffer, buffer_seek_start, 6);
		
		// Read Textures
		readTextures(buffer);
		
		// Read Buffers
		readBuffers(buffer);
		
		// Link Meshes
		linkMeshes(buffer);
		
		// Generate VBOs
		buildVBOs();
		buildAveragePosition();
		
		// Delete Buffer
		buffer_delete(buffer);
		
		// Log
		ConsoleLog($"Successfully Loaded \"{model}\"", CONSOLE_MODEL_LOADER);
	}
	
	/// @func saveGHG()
	/// @desc Save Model to GHG file
	static saveGHG = function(filepath)
	{
		// Log
		ConsoleLog($"Attempting To Save \"{filepath}\"", CONSOLE_MODEL_SAVER);
		
		// Set Model Version If User Changed Settings
		if (SETTINGS.exportNU20Last && self.version >= BTModelVersion.Version3 && nu20Offset == 0)
		{
			ConsoleLog($"Converting Model Version 4 to Version 2", CONSOLE_MODEL_LOADER);
			self.version = BTModelVersion.Version2;
			self.nu20Offset = 1;
		}
		
		// File Version 1 to Version 2
		if (self.version == 1)
		{
			ConsoleLog($"Model Version 1 detected, attempting to convert to Model Version 2", CONSOLE_MODEL_LOADER);
			self.version = BTModelVersion.Version2;
		}
		
		// Log
		ConsoleLog($"Version: {BT_MODEL_VERSION[self.version]}", CONSOLE_MODEL_SAVER);
		ConsoleLog($"Type: {BT_MODEL_TYPE[self.type]}", CONSOLE_MODEL_SAVER);
		
		// Create Buffer
		var buffer = buffer_create(1, buffer_grow, 1);
		
		// Create New Buffers
		var buffers = buildBuffers();
		
		// Edit NU20
		modifyNU20();
		
		// Pre-NU20 Size
		var preNU20Size = buffer_get_size(self.data);
		
		// Write NU20 if NU20 First
		if (self.nu20Offset == 0)
		{
			// Log
			ConsoleLog($"Writing NU20", CONSOLE_MODEL_SAVER);
			
			buffer_copy(self.data, 0, preNU20Size, buffer, 0);
			buffer_seek(buffer, buffer_seek_relative, preNU20Size);
		}
		
		// Pre-NU20 Size
		buffer_write(buffer, buffer_u32, 0); // Pre-NU20 Size
		
		// Log
		ConsoleLog($"Writing {array_length(self.textures)} Textures", CONSOLE_MODEL_SAVER);
		
		// Write Textures
		if (self.nu20Offset != 0) buffer_write(buffer, buffer_u16, array_length(self.textures)); // Texture Count
		
		for (var i = 0; i < array_length(self.textures); i++)
		{
			var texture = self.textures[i];
			if (texture == 0) continue;
			if (self.nu20Offset != 0)
			{
				// Texture Width (Negate if Cubemap)
				if (texture.cubemap) buffer_write(buffer, buffer_s32, -texture.width);
				else buffer_write(buffer, buffer_s32, texture.width);
				
				// Texture Height
				buffer_write(buffer, buffer_u32, texture.height);
				
				// Write this section if cubemap, otherwise just write 0x00s
				if (texture.cubemap)
				{
					buffer_write(buffer, buffer_u32, 0x1);
					buffer_write(buffer, buffer_u32, 0x0);
					buffer_write(buffer, buffer_u32, 0x40);
				}
				else repeat(3) buffer_write(buffer, buffer_u32, 0x0);
				
				// Texture Data Size
				buffer_write(buffer, buffer_u32, texture.size);
			}
		
			buffer_copy(texture.data, 0, texture.size, buffer, buffer_tell(buffer));
			buffer_seek(buffer, buffer_seek_relative, texture.size);
		}
		
		// Log
		ConsoleLog($"Writing {array_length(buffers[0])} Vertex Buffers", CONSOLE_MODEL_SAVER);
		
		// Write Vertex Buffers
		buffer_write(buffer, buffer_u16, array_length(buffers[0]));
	
		for (var i = 0; i < array_length(buffers[0]); i++)
		{
			buffer_write(buffer, buffer_u32, buffer_get_size(buffers[0][i]));
			buffer_copy(buffers[0][i], 0, buffer_get_size(buffers[0][i]), buffer, buffer_tell(buffer));
			buffer_seek(buffer, buffer_seek_relative, buffer_get_size(buffers[0][i]));
		}
		
		// Log
		ConsoleLog($"Writing {array_length(buffers[1])} Index Buffers", CONSOLE_MODEL_SAVER);
		
		// Write Index Buffers
		buffer_write(buffer, buffer_u16, array_length(buffers[1]));
		
		for (var i = 0; i < array_length(buffers[1]); i++)
		{
			buffer_write(buffer, buffer_u32, buffer_get_size(buffers[1][i]));
			buffer_copy(buffers[1][i], 0, buffer_get_size(buffers[1][i]), buffer, buffer_tell(buffer));
			buffer_seek(buffer, buffer_seek_relative, buffer_get_size(buffers[1][i]));
		}
		
		// Watermark
		buffer_write(buffer, buffer_string, "Made With BactaTankClassic v0.3");
		
		// Pre-NU20Size
		if (self.nu20Offset != 0)
		{
			// Log
			ConsoleLog($"Writing NU20", CONSOLE_MODEL_SAVER);
			
			buffer_poke(buffer, 0, buffer_u32, buffer_tell(buffer) - 4);
			self.nu20Offset = buffer_tell(buffer);
			buffer_copy(self.data, 0, preNU20Size, buffer, buffer_tell(buffer));
			buffer_seek(buffer, buffer_seek_relative, preNU20Size);
		}
		else
		{
			buffer_poke(buffer, preNU20Size, buffer_u32, buffer_get_size(buffer) - 4 - preNU20Size);
		}
		
		// Save Buffer
		buffer_save(buffer, filepath);
		
		// Destroy Buffers
		buffer_delete(buffer);
		for (var i = 0; i < array_length(buffers[0]); i++) buffer_delete(buffers[0][i]);
		for (var i = 0; i < array_length(buffers[1]); i++) buffer_delete(buffers[1][i]);
		
		// Log
		ConsoleLog($"Successfully Saved \"{filepath}\"", CONSOLE_MODEL_SAVER);
	}
	
	#region Loader Functions
	
	static readTextureMetadata = function(buffer)
	{
		// Textures
		self.textures = [  ];
		
		// Texture Count
		var textureCount = buffer_read(buffer, buffer_u32);
		
		// Seek to Texture Metadata
		buffer_seek(buffer, buffer_seek_relative, buffer_read(buffer, buffer_u32) - 4);
		
		// Log
		ConsoleLog($"Reading {textureCount} Textures", CONSOLE_MODEL_LOADER);
		
		for (var i = 0; i < textureCount; i++)
		{
			// Seek to texture entry
			var tempOffset = buffer_tell(buffer) + 4;
			buffer_seek(buffer, buffer_seek_relative, buffer_read(buffer, buffer_u32) - 4);
			
			// Create A New Texture
			self.textures[i] = new BactaTankTexture();
			
			// Parse Texture Data
			self.textures[i].parseMetadata(buffer, i, self);
			
			// Increase Current Texture Index
			if (self.textures[i].width == 0)
			{
				self.textures[i] = 0; // Dereference Texture If Part Of Cubemap
				if (self.nu20Offset != 0 && self.textures[i-1] != 0) self.textures[i-1].cubemap = true; // Set Previous Textures Cubemap Value To True
			}
			
			// Seek back to start
			buffer_seek(buffer, buffer_seek_start, tempOffset);
		}
	}
	
	static readMaterials = function(buffer)
	{
		// Material Count
		var materialCount = buffer_peek(buffer, buffer_tell(buffer) + 0x04, buffer_u32);
		
		// Material
		self.materials = [];
		buffer_seek(buffer, buffer_seek_relative, buffer_read(buffer, buffer_u32) - 4);
		var offset = buffer_tell(buffer);
		
		// Log
		ConsoleLog($"Reading {materialCount} Materials", CONSOLE_MODEL_LOADER);
		
		// Materials
		for (var i = 0; i < materialCount; i++)
		{
			// Seek to Material entry
			var tempOffset = buffer_tell(buffer) + 4;
			buffer_seek(buffer, buffer_seek_relative, buffer_read(buffer, buffer_u32) - 4);
			
			// Create New Material
			self.materials[i] = new BactaTankMaterial();
			
			// Parse Material Data
			self.materials[i].parse(buffer, self);
			
			// Seek back to start
			buffer_seek(buffer, buffer_seek_start, tempOffset);
		}
	}
	
	static readMeshes = function(buffer)
	{
		// Mesh List
		self.meshes = [];
		
		// Mesh Block 1
		var meshBlock1StartPointer = buffer_tell(buffer) + buffer_read(buffer, buffer_s32);
		var meshCount = buffer_read(buffer, buffer_u32);
		var meshBlock2StartPointer = buffer_tell(buffer) + buffer_read(buffer, buffer_s32);
		var meshBlock2Count = buffer_read(buffer, buffer_u32);
		
		// Log
		ConsoleLog($"Reading {meshCount + meshBlock2Count} Meshes", CONSOLE_MODEL_LOADER);
		
		// Seek
		buffer_seek(buffer, buffer_seek_start, meshBlock1StartPointer);
		
		// Mesh Block 1 Loop
		for (var i = 0; i < meshCount; i++)
		{
			// Seek to mesh entry
			var tempOffset = buffer_tell(buffer) + 4;
			buffer_seek(buffer, buffer_seek_relative, buffer_read(buffer, buffer_u32) - 4);
			
			// Create New Mesh
			self.meshes[i] = new BactaTankMesh();
			
			// Parse Mesh Data
			self.meshes[i].parse(buffer, i, self);
			
			// Seek back to start
			buffer_seek(buffer, buffer_seek_start, tempOffset);
		}
		
		//// Mesh Block 2 Loop (I have no idea what the fuck this does)
		//for (var i = meshCount; i < meshCount + meshBlock2Count; i++)
		//{
		//	// Seek to mesh entry
		//	var tempOffset = buffer_tell(buffer) + 4;
		//	buffer_seek(buffer, buffer_seek_relative, buffer_read(buffer, buffer_u32) - 4);
			
		//	ConsoleLog(buffer_tell(buffer));
			
		//	// Create New Mesh
		//	self.meshes[i] = new BactaTankMesh();
			
		//	// Parse Mesh Data
		//	self.meshes[i].parse(buffer, self);
			
		//	// Seek back to start
		//	buffer_seek(buffer, buffer_seek_start, tempOffset);
		//}
	}
	
	static readBones = function(buffer)
	{
		// Bone Count
		var boneCount = buffer_read(buffer, buffer_s32);
		
		// Log
		ConsoleLog($"Reading {boneCount} Bones", CONSOLE_MODEL_LOADER);
		
		// Goto Bone Data
		buffer_seek(buffer, buffer_seek_relative, buffer_read(buffer, buffer_s32) - 4);
		
		// Armature
		self.armature = new BactaTankArmature();
		
		// Parse Bones
		self.armature.parse(buffer, self, boneCount);
		
		// Set Bones
		self.bones = self.armature.bones;
	}
	
	static readLocators = function(buffer)
	{
		// Locator Count
		var locatorCount = buffer_read(buffer, buffer_s32);
		
		// Log
		ConsoleLog($"Reading {locatorCount} Locators", CONSOLE_MODEL_LOADER);
		
		// Locator List
		self.locatorData = [];
		
		// Goto Locator Data
		buffer_seek(buffer, buffer_seek_relative, buffer_read(buffer, buffer_s32) - 4);
		
		// Locator Loop
		for (var i = 0; i < locatorCount; i++)
		{
			// Locator
			self.locatorData[i] = new BactaTankLocator();
			
			// Parse Locator
			self.locatorData[i].parse(buffer, self, i);
		}
	}
	
	static readLocatorOrder = function(buffer)
	{
		// Locator Count
		var locatorCount = buffer_read(buffer, buffer_s32);
		
		// Log
		ConsoleLog($"Reordering {locatorCount} Locators", CONSOLE_MODEL_LOADER);
		
		// Locator List
		self.locators = [];
		
		// Goto Locator Data
		buffer_seek(buffer, buffer_seek_relative, buffer_read(buffer, buffer_s32) - 4);
		//ConsoleLog($"Reordering {string_hex(buffer_tell(buffer))}", CONSOLE_MODEL_LOADER);
		
		// Locator Loop
		for (var i = 0; i < locatorCount; i++)
		{
			// Locator Offset
			var locatorIndex = buffer_read(buffer, buffer_s8);
			
			// Locator
			if (locatorIndex != -1) self.locators[i] = self.locatorData[locatorIndex];
			else self.locators[i] = -1;
		}
	}
	
	static readModels = function(buffer)
	{
		// Model Count
		var modelCount = buffer_read(buffer, buffer_s32);
		
		// Log
		ConsoleLog($"Reading {modelCount} Models", CONSOLE_MODEL_LOADER);
		
		// Temp Offset
		var tempOffset = buffer_tell(buffer);
		
		// Seek to Models
		buffer_seek(buffer, buffer_seek_relative, buffer_read(buffer, buffer_u32) - 4);
		
		// Models Loop
		for (var i = 0; i < modelCount; i++)
		{
			// Create New Model
			self.models[i] = new BactaTankGameModel();
			
			// Parse
			self.models[i].parse(buffer, self);
		}
		
		// Seek to Model Mesh Start Indices
		buffer_seek(buffer, buffer_seek_start, tempOffset + 0x08);
		buffer_seek(buffer, buffer_seek_relative, buffer_read(buffer, buffer_u32) - 4);
		
		// Models Loop
		for (var i = 0; i < modelCount; i++)
		{
			// Create New Model
			self.models[i].parseMesh(buffer, self);
		}
		
		//ConsoleLog(json_stringify(self.models, true));
	}
	
	static readLayers = function(buffer)
	{
		// Variables
		var currentMesh = 0;
		self.layers = [];
		
		// Layer Count
		var layerCount = buffer_read(buffer, buffer_s32);
		
		// Log
		ConsoleLog($"Reading {layerCount} Layers", CONSOLE_MODEL_LOADER);
		
		// Seek to layer entry
		buffer_seek(buffer, buffer_seek_relative, buffer_read(buffer, buffer_u32) - 4);
		
		// Current Mesh
		var currentMesh = 0;
		
		// Loop though the layers
		for (var i = 0; i < layerCount; i++)
		{
			// Create Layer
			self.layers[i] = new BactaTankLayer();
			
			// Parse Layer
			self.layers[i].parse(buffer, self, i, currentMesh);
			
			// Increase Current Mesh
			currentMesh += array_length(self.layers[i].meshes);
		}
		
		//ConsoleLog(self.layers);
	}

	static readSpecialObjects = function(buffer)
	{
		// Special Objects
		self.specialObjects = [  ];
		
		// Special Object Count
		var specialObjectCount = buffer_read(buffer, buffer_s32);
		
		// Log
		ConsoleLog($"Reading {specialObjectCount} Special Objects", CONSOLE_MODEL_LOADER);
		
		// Goto Special Objects
		buffer_seek(buffer, buffer_seek_relative, (buffer_read(buffer, buffer_u32) - 4));
		
		// Special Objects Loop
		for (var o = 0; o < specialObjectCount; o++)
		{
			// Read Special Object
			var specialObject = new BactaTankSpecialObject();
			
			// Parse Special Object
			specialObject.parse(buffer, self);
			
			// Push Onto Special Objects Array
			array_push(self.specialObjects, specialObject)
		}
		
		ConsoleLog(self.specialObjects);
	}
	
	static readTextures = function(buffer)
	{
		// Log
		ConsoleLog($"Decoding {array_length(self.textures)} Textures", CONSOLE_MODEL_LOADER);
		
		// Textures Loop
		for (var i = 0; i < array_length(self.textures); i++)
		{
			ConsoleLog($"Texture {i}", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer));
			if (self.textures[i] != 0) self.textures[i].parse(buffer, i, self);
		}
	}
	
	static readBuffers = function(buffer)
	{
		// Vertex Buffer Count
		var bufferCount = buffer_read(buffer, buffer_u16);// Log
		
		// Log
		ConsoleLog($"Reading {bufferCount} Vertex Buffers", CONSOLE_MODEL_LOADER);
		
		// Loop through Buffers
		for (var i = 0; i < bufferCount; i++)
		{
			// Log
			ConsoleLog($"Vertex Buffer {i}", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer));
			
			// Buffer Size
			var bufferSize = buffer_read(buffer, buffer_u32);
			ConsoleLog($"    Size: 0x{bufferSize}", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer) - 4);
			
			// Copy Buffer into new buffer
			self.offsets.vertexBuffer[i] = buffer_tell(buffer);
			buffer_seek(buffer, buffer_seek_relative, bufferSize);
		}
		
		// Index Buffer Count
		bufferCount = buffer_read(buffer, buffer_u16);
		
		// Log
		ConsoleLog($"Reading {bufferCount} Index Buffers", CONSOLE_MODEL_LOADER);
		
		// Loop through Buffers
		for (var i = 0; i < bufferCount; i++)
		{
			// Log
			ConsoleLog($"Index Buffer {i}", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer));
			
			// Buffer Size
			var bufferSize = buffer_read(buffer, buffer_u32);
			ConsoleLog($"    Size: 0x{bufferSize}", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer) - 4);
			
			// Copy Buffer into new buffer
			self.offsets.indexBuffer[i] = buffer_tell(buffer);
			buffer_seek(buffer, buffer_seek_relative, bufferSize);
		}
	}
	
	static linkMeshes = function(buffer)
	{
		// Log
		ConsoleLog($"Linking {array_length(self.meshes)} Meshes", CONSOLE_MODEL_LOADER);
		
		for (var i = 0; i < array_length(self.meshes); i++)
		{
			self.meshes[i].link(buffer, self.offsets.vertexBuffer, self.offsets.indexBuffer, self);
		}
	}
	
	static buildVBOs = function()
	{
		// Log
		ConsoleLog($"Building Vertex Buffers", CONSOLE_MODEL_LOADER);
		
		// Build VBOs
		for (var i = 0; i < array_length(self.meshes); i++)
		{
			// Build Mesh
			self.meshes[i].build(self);
		}
	}
	
	static buildAveragePosition = function()
	{
		// Average Position
		self.averagePosition = [0, 0, 0, 0];
		
		// Count
		var count = 0;
		
		// Model Type
		if (self.type == BTModelType.model)
		{
			// Layers Loop
			for (var l = 0; l < array_length(self.layers); l++)
			{
				// Layer Meshes
				var meshes = self.layers[l].meshes;
			
				// Loop Layer Meshes
				for (var m = 0; m < array_length(meshes); m++)
				{
					// Get Model
					
					// Mesh
					var mesh = self.meshes[meshes[m].mesh];
					var bone = meshes[m].bone;
					
					// Get Matrix
					var matrix = matrix_build_identity();
					if (bone != -1) matrix = self.bones[bone].matrix;
					
					// Get Average Position
					var average = matrix_transform_vertex(matrix, mesh.averagePosition[0], mesh.averagePosition[1], mesh.averagePosition[2]);
					
					// Add To Global Average
					self.averagePosition[0] += average[0];
					self.averagePosition[1] += average[1];
					self.averagePosition[2] += average[2];
					
					// Increase Count
					count++;
				}
			}
			
			// Average The Position
			self.averagePosition[0] /= array_length(self.meshes);
			self.averagePosition[1] /= array_length(self.meshes);
			self.averagePosition[2] /= array_length(self.meshes);
		}
	}
	
	#endregion
	
	#region Saver Functions
	
	/// @func buildBuffers()
	/// @desc Build Vertex and Index Buffers
	static buildBuffers = function()
	{
		// Log
		ConsoleLog($"Building Buffers", CONSOLE_MODEL_SAVER);
		
		// Create New Buffers
		var writeVertexBuffers = [];
		var writeIndexBuffers = [];
		var vbIndex = [];
		var ibIndex = [];
		
		// Alwasy 1 Index Buffer
		writeIndexBuffers[0] = buffer_create(1, buffer_grow, 1);
		
		// Make Vertex Buffers
		for (var i = 0; i < array_length(self.meshes); i++)
		{
			// Skip Over If Buffers Don't Exist
			if (array_length(self.meshes[i].vertices) == 0 || array_length(self.meshes[i].triangles) == 0) continue;
			
			// Get Vertex Buffer
			var vertexBuffer = self.meshes[i].buildVertexBuffer(self);
			
			// Account For Dynamic Buffers
			var vertexStride = self.meshes[i].vertexStride;
			if (array_length(self.meshes[i].dynamicBuffers) > 0)
			{
				vertexStride += 1;
			}
			
			// If the vertex stride isn't in the array, add a new entry. Each vertex stride is treated as a new vertexBuffer.
			if (array_get_index(vbIndex, vertexStride) == -1) {
				array_push(vbIndex, vertexStride);
				writeVertexBuffers[array_get_index(vbIndex, vertexStride)] = buffer_create(1, buffer_grow, 1);
			}
			
			// Set Vertex Buffer Index
			self.meshes[i].vertexBufferID = array_get_index(vbIndex, vertexStride);
			self.meshes[i].vertexOffset = buffer_tell(writeVertexBuffers[array_get_index(vbIndex, vertexStride)]) / self.meshes[i].vertexStride;
			buffer_copy(vertexBuffer, 0, buffer_get_size(vertexBuffer), writeVertexBuffers[array_get_index(vbIndex, vertexStride)], buffer_tell(writeVertexBuffers[array_get_index(vbIndex, vertexStride)]));
			buffer_seek(writeVertexBuffers[array_get_index(vbIndex, vertexStride)], buffer_seek_relative, buffer_get_size(vertexBuffer));
			
			// Delete Vertex Buffer
			buffer_delete(vertexBuffer);
			
			// Build Index Buffer
			var indexBuffer = self.meshes[i].buildIndexBuffer();
			
			self.meshes[i].indexBufferID = 0;
			self.meshes[i].indexOffset = buffer_tell(writeIndexBuffers[0]) / 2;
			buffer_copy(indexBuffer, 0, buffer_get_size(indexBuffer), writeIndexBuffers[0], buffer_tell(writeIndexBuffers[0]));
			buffer_seek(writeIndexBuffers[0], buffer_seek_relative, buffer_get_size(indexBuffer));
			
			// Delete Vertex Buffer
			buffer_delete(indexBuffer);
		}
		
		// Log
		ConsoleLog($"Successfully built {array_length(writeVertexBuffers)} vertex buffers and {array_length(writeIndexBuffers)} index buffers from {array_length(self.meshes)} meshes", CONSOLE_MODEL_SAVER);
		
		// Return Buffers
		return [writeVertexBuffers, writeIndexBuffers];
	}
	
	/// @func modifyNU20()
	/// @desc Modify NU20
	static modifyNU20 = function()
	{
		// Log
		ConsoleLog($"Injecting into NU20", CONSOLE_MODEL_SAVER);
		
		if (self.version >= BTModelVersion.Version3) buffer_poke(self.data, 0x08, buffer_u32, self.version);
		else buffer_poke(self.data, 0x08, buffer_u64, self.version);
		
		// Log
		ConsoleLog($"Injecting {array_length(self.textures)} Textures", CONSOLE_MODEL_SAVER);
		
		// Edit NU20
		for (var i = 0; i < array_length(self.textures); i++)
		{
			// Inject Texture
			if (self.textures[i] != 0) self.textures[i].inject(self.data, self);
		}
		
		// Log
		ConsoleLog($"Injecting {array_length(self.materials)} Materials", CONSOLE_MODEL_SAVER);
		for (var i = 0; i < array_length(self.materials); i++)
		{
			// Inject Material
			self.materials[i].inject(self.data, self);
		}
		
		// Log
		ConsoleLog($"Injecting {array_length(self.meshes)} Meshes", CONSOLE_MODEL_SAVER);
		for (var i = 0; i < array_length(self.meshes); i++)
		{
			// Inject Mesh
			self.meshes[i].inject(self.data);
		}
		
		// Model Specific Things
		if (self.type == BTModelType.model)
		{
			// Log
			ConsoleLog($"Injecting {array_length(self.locatorData)} Locators", CONSOLE_MODEL_SAVER);
			
			// Edit Locators
			for (var i = 0; i < array_length(self.locatorData); i++)
			{
				// Inject Locators
				self.locatorData[i].inject(self.data);
			}
			
			// Log
			ConsoleLog($"Injecting {array_length(self.layers)} Layers", CONSOLE_MODEL_SAVER);
			
			// Loop Through Layers
			for (var l = 0; l < array_length(self.layers); l++)
			{
				// Inject Layer
				self.layers[l].inject(self.data);
			}
			
			//self.armature.inject(self.data);
		}
		else
		{
			// Scene Specific Code Here
		}
	}
	
	#endregion
	
	#endregion
	
	#region Load and Save Canister
	
	/// @func serialize(buffer)
	/// @desc Serialize model
	static serialize = function(buffer)
	{
		// Write Cache Header
		buffer_write(buffer, buffer_string, "BactaTankCanister");
		buffer_write(buffer, buffer_f32, 1.0);
		buffer_write(buffer, buffer_string, global.__modelVersion[self.version]);
		
		// Write NU20
		buffer_write(buffer, buffer_string, "BactaTankNU20");
		buffer_write(buffer, buffer_s32, self.nu20Offset);
		buffer_write(buffer, buffer_s32, buffer_get_size(self.data));
		buffer_copy(self.data, 0, buffer_get_size(self.data), buffer, buffer_tell(buffer));
		buffer_seek(buffer, buffer_seek_relative, buffer_get_size(self.data));
		
		// Write Textures
		buffer_write(buffer, buffer_string, "BactaTankTextures");
		buffer_write(buffer, buffer_s32, array_length(self.textureMetaData));
		buffer_write(buffer, buffer_s32, array_length(self.textures));
		
		for (var i = 0; i < array_length(self.textures); i++)
		{
			// Texture MetaData
			buffer_write(buffer, buffer_u32, self.textureMetaData[self.textures[i].parent].width);
			buffer_write(buffer, buffer_u32, self.textureMetaData[self.textures[i].parent].height);
			buffer_write(buffer, buffer_u32, self.textureMetaData[self.textures[i].parent].compression);
			buffer_write(buffer, buffer_u32, self.textureMetaData[self.textures[i].parent].isCubemap);
			buffer_write(buffer, buffer_u32, self.textureMetaData[self.textures[i].parent].offset);
			buffer_write(buffer, buffer_u32, self.textures[i].parent);
			
			// Texture DDS Data
			buffer_write(buffer, buffer_string, "DDSData");
			buffer_write(buffer, buffer_u32, self.textureMetaData[self.textures[i].parent].size);
			buffer_copy(self.textures[i].data, 0, self.textureMetaData[self.textures[i].parent].size, buffer, buffer_tell(buffer));
			buffer_seek(buffer, buffer_seek_relative, self.textureMetaData[self.textures[i].parent].size);
			
			// Texture Renderer Data
			buffer_write(buffer, buffer_string, "RendererData");
			
			// Create Texture Page
			var textureSurface = surface_create(self.textureMetaData[self.textures[i].parent].width, self.textureMetaData[self.textures[i].parent].height);
			surface_set_target(textureSurface);
			
			// Draw
			draw_clear_alpha(c_black, 0);
			draw_sprite(self.textures[i].sprite, 0, 0, 0);
			
			// Reset Surface
			surface_reset_target();
			
			// Texture Buffer
			var textureBuffer = buffer_create(self.textureMetaData[self.textures[i].parent].width * self.textureMetaData[self.textures[i].parent].height * 4, buffer_fixed, 1);
			buffer_get_surface(textureBuffer, textureSurface, 0);
			var textureBufferCompressed = buffer_compress(textureBuffer, 0, buffer_get_size(textureBuffer));
			
			// Texture Size
			buffer_write(buffer, buffer_s32, buffer_get_size(textureBuffer));
			buffer_write(buffer, buffer_s32, buffer_get_size(textureBufferCompressed));
			
			// Texture Buffer
			buffer_copy(textureBufferCompressed, 0, buffer_get_size(textureBufferCompressed), buffer, buffer_tell(buffer));
			buffer_seek(buffer, buffer_seek_relative, buffer_get_size(textureBufferCompressed));
			
			// Delete Buffers
			surface_free(textureSurface);
			buffer_delete(textureBuffer);
			buffer_delete(textureBufferCompressed);
		}
		
		// Write Materials
		buffer_write(buffer, buffer_string, "BactaTankMaterials");
		buffer_write(buffer, buffer_s32, array_length(self.materials));
		
		for (var i = 0; i < array_length(self.materials); i++)
		{
			// Material Properties
			buffer_write(buffer, buffer_u32, self.materials[i].alphaBlend);
			buffer_write(buffer, buffer_f32, self.materials[i].colour[0]);
			buffer_write(buffer, buffer_f32, self.materials[i].colour[1]);
			buffer_write(buffer, buffer_f32, self.materials[i].colour[2]);
			buffer_write(buffer, buffer_f32, self.materials[i].colour[3]);
			buffer_write(buffer, buffer_s32, self.materials[i].textureID);
			buffer_write(buffer, buffer_u32, self.materials[i].textureFlags);
			buffer_write(buffer, buffer_s32, self.materials[i].specularID);
			buffer_write(buffer, buffer_s32, self.materials[i].normalID);
			buffer_write(buffer, buffer_s32, self.materials[i].cubemapID);
			buffer_write(buffer, buffer_s32, self.materials[i].shineID);
			buffer_write(buffer, buffer_f32, self.materials[i].reflectionPower);
			buffer_write(buffer, buffer_f32, self.materials[i].specularExponent);
			buffer_write(buffer, buffer_f32, self.materials[i].fresnelMuliplier);
			buffer_write(buffer, buffer_f32, self.materials[i].fresnelCoeff);
			buffer_write(buffer, buffer_u32, self.materials[i].vertexFormat);
			buffer_write(buffer, buffer_u32, self.materials[i].inputFlags);
			buffer_write(buffer, buffer_u32, self.materials[i].shaderFlags);
			buffer_write(buffer, buffer_u32, self.materials[i].offset);
		}
		
		// Write Meshes
		buffer_write(buffer, buffer_string, "BactaTankMeshes");
		buffer_write(buffer, buffer_s32, array_length(self.meshes));
		
		for (var i = 0; i < array_length(self.meshes); i++)
		{
			// Mesh Properties
			buffer_write(buffer, buffer_u32, self.meshes[i].type);
			for (var j = 0; j < 8; j++) buffer_write(buffer, buffer_u8, self.meshes[i].bones[j]);
			buffer_write(buffer, buffer_u32, self.meshes[i].flags);
			buffer_write(buffer, buffer_u32, self.meshes[i].vertexStride);
			buffer_write(buffer, buffer_u32, self.meshes[i].vertexOffset);
			buffer_write(buffer, buffer_u32, self.meshes[i].vertexCount);
			buffer_write(buffer, buffer_u32, self.meshes[i].indexOffset);
			buffer_write(buffer, buffer_u32, self.meshes[i].triangleCount);
			buffer_write(buffer, buffer_u32, self.meshes[i].offset);
			
			// Write Dynamic Buffers
			buffer_write(buffer, buffer_u32, array_length(self.meshes[i].dynamicBuffers));
			for (var j = 0; j < array_length(self.meshes[i].dynamicBuffers); j++)
			{
				if (self.meshes[i].dynamicBuffers[j] = -1)
				{
					buffer_write(buffer, buffer_u32, 0);
					continue;
				}
				buffer_write(buffer, buffer_u32, array_length(self.meshes[i].dynamicBuffers[j]));
				for (var k = 0; k < array_length(self.meshes[i].dynamicBuffers[j]); k++) buffer_write(buffer, buffer_f32, self.meshes[i].dynamicBuffers[j][k]);
			}
			
			// Vertex Buffer
			buffer_write(buffer, buffer_string, "BactaTankVertexBuffer");
			buffer_write(buffer, buffer_u32, buffer_get_size(self.meshes[i].vertexBuffer));
			buffer_copy(self.meshes[i].vertexBuffer, 0, buffer_get_size(self.meshes[i].vertexBuffer), buffer, buffer_tell(buffer));
			buffer_seek(buffer, buffer_seek_relative, buffer_get_size(self.meshes[i].vertexBuffer));
			
			// Index Buffer
			buffer_write(buffer, buffer_string, "BactaTankIndexBuffer");
			buffer_write(buffer, buffer_u32, buffer_get_size(self.meshes[i].indexBuffer));
			buffer_copy(self.meshes[i].indexBuffer, 0, buffer_get_size(self.meshes[i].indexBuffer), buffer, buffer_tell(buffer));
			buffer_seek(buffer, buffer_seek_relative, buffer_get_size(self.meshes[i].indexBuffer));
			
			// Renderer Buffer
			if (self.meshes[i].vertexBufferObject != -1)
			{
				var vertexBuffer = buffer_create_from_vertex_buffer(self.meshes[i].vertexBufferObject, buffer_fixed, 1);
				buffer_write(buffer, buffer_string, "BactaTankRendererBuffer");
				buffer_write(buffer, buffer_u32, vertex_get_number(self.meshes[i].vertexBufferObject));
				buffer_write(buffer, buffer_u32, buffer_get_size(vertexBuffer));
				buffer_copy(vertexBuffer, 0, buffer_get_size(vertexBuffer), buffer, buffer_tell(buffer));
				buffer_seek(buffer, buffer_seek_relative, buffer_get_size(vertexBuffer));
				buffer_delete(vertexBuffer);
			}
			else
			{
				buffer_write(buffer, buffer_string, "BactaTankRendererBuffer");
				buffer_write(buffer, buffer_u32, 0);
			}
		}
		
		// Write Bones
		buffer_write(buffer, buffer_string, "BactaTankBones");
		buffer_write(buffer, buffer_s32, array_length(self.bones));
		
		for (var i = 0; i < array_length(self.bones); i++)
		{
			buffer_write(buffer, buffer_string, self.bones[i].name);
			buffer_write(buffer, buffer_s32, self.bones[i].parent);
			buffer_write(buffer, buffer_u32, self.bones[i].offset);
			for (var j = 0; j < 16; j++) buffer_write(buffer, buffer_f32, self.bones[i].matrix[j]);
			for (var j = 0; j < 16; j++) buffer_write(buffer, buffer_f32, self.bones[i].matrixLocal[j]);
		}
		
		// Write Locators
		buffer_write(buffer, buffer_string, "BactaTankLocators");
		buffer_write(buffer, buffer_s32, array_length(self.locators));
		
		for (var i = 0; i < array_length(self.locators); i++)
		{
			buffer_write(buffer, buffer_string, self.locators[i].name);
			buffer_write(buffer, buffer_s32, self.locators[i].parent);
			buffer_write(buffer, buffer_u32, self.locators[i].offset);
			for (var j = 0; j < 16; j++) buffer_write(buffer, buffer_f32, self.locators[i].matrix[j]);
		}
		
		// Write Layers
		buffer_write(buffer, buffer_string, "BactaTankLayers");
		buffer_write(buffer, buffer_s32, array_length(self.layers));
		
		for (var i = 0; i < array_length(self.layers); i++)
		{
			buffer_write(buffer, buffer_string, self.layers[i].name);
			buffer_write(buffer, buffer_u32, self.layers[i].offset);
			buffer_write(buffer, buffer_u32, array_length(self.layers[i].meshes));
			for (var j = 0; j < array_length(self.layers[i].meshes); j++)
			{
				buffer_write(buffer, buffer_u32, self.layers[i].meshes[j].mesh);
				buffer_write(buffer, buffer_u32, self.layers[i].meshes[j].material);
				buffer_write(buffer, buffer_u32, self.layers[i].meshes[j].matOffset);
				buffer_write(buffer, buffer_s32, self.layers[i].meshes[j].bone);
			}
		}
	}
	
	/// @func deserialize(buffer)
	/// @desc Deserialize model
	static deserialize = function(buffer)
	{
		// Read Cache Header
		var cacheSignature = buffer_read(buffer, buffer_string);
		if (cacheSignature != "BactaTankCanister") show_error("Wrong File", true);
		
		var cacheVersion = buffer_read(buffer, buffer_f32);
		if (cacheVersion != 1.0) show_error("Wrong Version", true);
		
//		self.version = buffer_read(buffer, buffer_string) == "PCGHG_NU20_LAST" ? BTModelVersion.pcghgNU20Last : BTModelVersion.pcghgNU20First;
		
		// Read NU20
		var nu20Signature = buffer_read(buffer, buffer_string);
		self.nu20Offset = buffer_read(buffer, buffer_u32);
		var nu20Size = buffer_read(buffer, buffer_u32);
		self.data = buffer_create(nu20Size, buffer_fixed, 1);
		buffer_copy(buffer, buffer_tell(buffer), nu20Size, self.data, 0);
		buffer_seek(buffer, buffer_seek_relative, nu20Size);
		
		// Read Textures
		var texturesSignature = buffer_read(buffer, buffer_string);
		var textureMetaDataCount = buffer_read(buffer, buffer_s32);
		var textureCount = buffer_read(buffer, buffer_s32);
		self.textures = [  ];
		self.textureMetaData = array_length(textureMetaDataCount);
		
		for (var i = 0; i < textureCount; i++)
		{
			// Texture MetaData
			var textureWidth = buffer_read(buffer, buffer_u32);
			var textureHeight = buffer_read(buffer, buffer_u32);
			var textureCompression = buffer_read(buffer, buffer_u32);
			var textureCubemap = buffer_read(buffer, buffer_u32);
			var textureOffset = buffer_read(buffer, buffer_u32);
			var textureParent = buffer_read(buffer, buffer_u32);
			var ddsSignature = buffer_read(buffer, buffer_string);
			var textureSize = buffer_read(buffer, buffer_u32);
			
			// Textures
			self.textures[i] = {data: buffer_create(textureSize, buffer_fixed, 1), sprite: noone, texture: noone, parent: textureParent};
			self.textureMetaData[textureParent] = {width: textureWidth, height: textureHeight, compression: textureCompression, isCubemap: textureCubemap, offset: textureOffset, size: textureSize};
			
			// Texture DDS Data
			buffer_copy(buffer, buffer_tell(buffer), textureSize, self.textures[i].data, 0);
			buffer_seek(buffer, buffer_seek_relative, textureSize);
			
			// Texture Renderer Data
			var rendererSignature = buffer_read(buffer, buffer_string);
			
			// Texture Size
			var textureSizeUncompressed = buffer_read(buffer, buffer_s32);
			var textureSizeCompressed = buffer_read(buffer, buffer_s32);
			
			// Texture Buffer
			var textureBuffer = buffer_create(textureSizeCompressed, buffer_fixed, 1);
			buffer_copy(buffer, buffer_tell(buffer), textureSizeCompressed, textureBuffer, 0);
			buffer_seek(buffer, buffer_seek_relative, textureSizeCompressed);
			
			// Decompress Buffer
			var textureBufferUncompressed = buffer_decompress(textureBuffer);
			
			// Texture Surface
			var textureSurface = surface_create(textureWidth, textureHeight);
			buffer_set_surface(textureBufferUncompressed, textureSurface, 0);
			
			// Sprite
			self.textures[i].sprite = sprite_create_from_surface(textureSurface, 0, 0, textureWidth, textureHeight, false, false, 0, 0);
			self.textures[i].texture = sprite_get_texture(self.textures[i].sprite, 0);
			
			// Cleanup
			surface_free(textureSurface);
			buffer_delete(textureBuffer);
			buffer_delete(textureBufferUncompressed);
		}
		
		// Read Materials
		var materialsSignature = buffer_read(buffer, buffer_string);
		var materialCount = buffer_read(buffer, buffer_s32);
		self.materials = array_create(materialCount);
		
		for (var i = 0; i < materialCount; i++)
		{
			// Material Properties
			var alphaBlend			= buffer_read(buffer, buffer_u32);
			var colour				= [0, 0, 0, 0];
			colour[0]				= buffer_read(buffer, buffer_f32);
			colour[1]				= buffer_read(buffer, buffer_f32);
			colour[2]				= buffer_read(buffer, buffer_f32);
			colour[3]				= buffer_read(buffer, buffer_f32);
			var textureID			= buffer_read(buffer, buffer_s32);
			var textureFlags		= buffer_read(buffer, buffer_u32);
			var specularID			= buffer_read(buffer, buffer_s32);
			var normalID			= buffer_read(buffer, buffer_s32);
			var cubemapID			= buffer_read(buffer, buffer_s32);
			var shineID				= buffer_read(buffer, buffer_s32);
			var reflectionPower		= buffer_read(buffer, buffer_f32);
			var specularExponent	= buffer_read(buffer, buffer_f32);
			var fresnelMuliplier	= buffer_read(buffer, buffer_f32);
			var fresnelCoeff		= buffer_read(buffer, buffer_f32);
			var vertexFormat		= buffer_read(buffer, buffer_u32);
			var inputFlags			= buffer_read(buffer, buffer_u32);
			var shaderFlags			= buffer_read(buffer, buffer_u32);
			var offset				= buffer_read(buffer, buffer_u32);
			
			self.materials[i] = {
				alphaBlend,
				colour,
				textureID,
				textureFlags,
				specularID,
				normalID,
				cubemapID,
				shineID,
				reflectionPower,
				specularExponent,
				fresnelMuliplier,
				fresnelCoeff,
				vertexFormat,
				inputFlags,
				shaderFlags,
				offset,
			}
		}
		
		// Read Meshes
		var meshesSignature = buffer_read(buffer, buffer_string);
		var meshCount = buffer_read(buffer, buffer_s32);
		self.meshes = array_create(meshCount);
		
		for (var i = 0; i < meshCount; i++)
		{
			// Mesh Properties
			var type				= buffer_read(buffer, buffer_u32);
			var bones				= array_create(0);
			repeat (8) array_push(bones, buffer_read(buffer, buffer_u8));
			var flags				= buffer_read(buffer, buffer_u32);
			var vertexStride		= buffer_read(buffer, buffer_u32);
			var vertexOffset		= buffer_read(buffer, buffer_u32);
			var vertexCount			= buffer_read(buffer, buffer_u32);
			var indexOffset			= buffer_read(buffer, buffer_u32);
			var triangleCount		= buffer_read(buffer, buffer_u32);
			var offset				= buffer_read(buffer, buffer_u32);
			
			// Read Dynamic Buffers
			var dynamicBufferCount	= buffer_read(buffer, buffer_u32);
			var dynamicBuffers = array_create(dynamicBufferCount);
			for (var j = 0; j < dynamicBufferCount; j++)
			{
				var dynamicBufferPointsCount = buffer_read(buffer, buffer_u32);
				if (dynamicBufferPointsCount == 0)
				{
					dynamicBuffers[j] = -1;
					continue;
				}
				dynamicBuffers[j] = array_create(dynamicBufferPointsCount);
				repeat (dynamicBufferPointsCount) array_push(dynamicBuffers[j], buffer_read(buffer, buffer_f32));
			}
			
			// Vertex Buffer
			var vertexBufferSignature = buffer_read(buffer, buffer_string);
			var vertexBufferSize = buffer_read(buffer, buffer_u32);
			var vertexBuffer = buffer_create(vertexBufferSize, buffer_fixed, 1);
			buffer_copy(buffer, buffer_tell(buffer), vertexBufferSize, vertexBuffer, 0);
			buffer_seek(buffer, buffer_seek_relative, vertexBufferSize);
			
			// Index Buffer
			var indexBufferSignature = buffer_read(buffer, buffer_string);
			var indexBufferSize = buffer_read(buffer, buffer_u32);
			var indexBuffer = buffer_create(indexBufferSize, buffer_fixed, 1);
			buffer_copy(buffer, buffer_tell(buffer), indexBufferSize, indexBuffer, 0);
			buffer_seek(buffer, buffer_seek_relative, indexBufferSize);
			
			// Renderer Buffer
			var renderBufferSignature = buffer_read(buffer, buffer_string);
			var vboVertexCount = buffer_read(buffer, buffer_u32);
			
			if (vboVertexCount != 0)
			{
				var vboVertexSize = buffer_read(buffer, buffer_u32);
				var vertexBufferObject = vertex_create_buffer_from_buffer_ext(buffer, global.vertexFormat, buffer_tell(buffer), vboVertexCount);
				show_debug_message(vertexBufferObject);
				buffer_seek(buffer, buffer_seek_relative, vboVertexSize);
			}
			else
			{
				vertexBufferObject = -1;
			}
			
			self.meshes[i] = {
				type,
				bones,
				flags,
				vertexStride,
				vertexOffset,
				vertexCount,
				indexOffset,
				triangleCount,
				offset,
				dynamicBuffers,
				vertexBuffer,
				indexBuffer,
				vertexBufferObject,
			}
		}
		
		// Read Bones
		var bonesSignature = buffer_read(buffer, buffer_string);
		var boneCount = buffer_read(buffer, buffer_s32);
		self.bones = array_create(boneCount);
		
		for (var i = 0; i < boneCount; i++)
		{
			var name		= buffer_read(buffer, buffer_string);
			var parent		= buffer_read(buffer, buffer_s32);
			var offset		= buffer_read(buffer, buffer_u32);
			var matrix		= array_create(16);
			var matrixLocal	= array_create(16);
			repeat (16) array_push(matrix, buffer_read(buffer, buffer_f32));
			repeat (16) array_push(matrixLocal, buffer_read(buffer, buffer_f32));
			
			self.bones[i] = {
				name,
				parent,
				offset,
				matrix,
				matrixLocal,
			}
		}
		
		// Read Locators
		var locatorsSignature = buffer_read(buffer, buffer_string);
		var locatorCount = buffer_read(buffer, buffer_s32);
		self.locators = array_create(locatorCount);
		
		for (var i = 0; i < locatorCount; i++)
		{
			var name	= buffer_read(buffer, buffer_string);
			var parent	= buffer_read(buffer, buffer_s32);
			var offset	= buffer_read(buffer, buffer_u32);
			var matrix	= array_create(16);
			repeat (16) array_push(matrix, buffer_read(buffer, buffer_f32));
			
			self.locators[i] = {
				name,
				parent,
				offset,
				matrix,
			}
		}
		
		// Read Layers
		var layersSignature = buffer_read(buffer, buffer_string);
		var layerCount = buffer_read(buffer, buffer_s32);
		self.layers = array_create(layerCount);
		
		for (var i = 0; i < layerCount; i++)
		{
			var name				= buffer_read(buffer, buffer_string);
			var offset				= buffer_read(buffer, buffer_u32);
			var layerMeshCount		= buffer_read(buffer, buffer_u32);
			var meshes				= array_create(layerMeshCount);
			for (var j = 0; j < layerMeshCount; j++)
			{
				var mesh		= buffer_read(buffer, buffer_u32);
				var material	= buffer_read(buffer, buffer_u32);
				var matOffset	= buffer_read(buffer, buffer_u32);
				var bone		= buffer_read(buffer, buffer_s32);
				
				meshes[j] = {
					mesh,
					material,
					matOffset,
					bone,
				}
			}
			
			self.layers[i] = {
				name,
				offset,
				meshes,
			}
		}
	}
	
	/// @func saveCanister(filepath)
	/// @desc Save model to a BactaTankCanister file for faster loading
	static saveCanister = function(filepath)
	{
		// Create Cache Buffer
		var buffer = buffer_create(1, buffer_grow, 1);
		
		// Serialize
		serialize(buffer);
		
		// Save and Delete Buffer
		buffer_save(buffer, filepath);
		buffer_delete(buffer);
	}
	
	/// @func loadCanister(filepath)
	/// @desc Load model from a BactaTankCanister file
	static loadCanister = function(filepath)
	{
		// Load Cache Buffer
		var buffer = buffer_load(filepath);
		
		// Deserialize
		deserialize(buffer);
		
		// Delete Buffer
		buffer_delete(buffer);
	}
	
	#endregion
	
	#region Destroy Function
	
	/// @func destroy()
	/// @desc Destroy the model and free up memory
	static destroy = function()
	{
		// Destroy NU20
		if (buffer_exists(self.data)) buffer_delete(self.data);
		
		// Delete Textures
		for (var i = 0; i < array_length(self.textures); i++)
		{
			if (self.textures[i] == 0 || self.textures[i].data == noone) continue;
			if (buffer_exists(self.textures[i].data)) buffer_delete(self.textures[i].data);
			if (sprite_exists(self.textures[i].sprite)) sprite_delete(self.textures[i].sprite);
		}
		
		// Delete Meshes
		for (var i = 0; i < array_length(self.meshes); i++)
		{
			if (buffer_exists(self.meshes[i].vertexBuffer)) buffer_delete(self.meshes[i].vertexBuffer);
			if (buffer_exists(self.meshes[i].indexBuffer)) buffer_delete(self.meshes[i].indexBuffer);
			if (self.meshes[i].vertexBufferObject != -1) vertex_delete_buffer(self.meshes[i].vertexBufferObject);
			if (self.meshes[i].uvSet1 != -1) vertex_delete_buffer(self.meshes[i].uvSet1);
		}
	}
	
	#endregion
	
	#region Renderer Functions
	
	/// @func pushToRenderQueue()
	/// @desc Pushes model onto the render queue
	static pushToRenderQueue = function(activeLayers, renderer = RENDERER, hideDisabledMeshes = true)
	{
		if (is_array(activeLayers))
		{
			// Layers Loop
			for (var l = 0; l < array_length(self.layers); l++)
			{
				// Skip if layer is not active
				if (!activeLayers[l]) continue;
			
				// Loop Through Layer Meshes
				for (var m = 0; m < array_length(self.layers[l].meshes); m++)
				{
					// Mesh
					var mesh = self.meshes[self.layers[l].meshes[m].mesh];
				
					// Skip if mesh type isn't 6
					if ((hideDisabledMeshes && !mesh.type) || mesh.vertexBufferObject == -1) continue;
				
					// Get Matrix
					var matrix = matrix_build_identity();
					if (self.layers[l].meshes[m].bone != -1) matrix = self.bones[self.layers[l].meshes[m].bone].matrix;
				
					// Create Render Struct
					var renderStruct = {
						vertexBuffer: mesh.vertexBufferObject,
						material: self.materials[self.layers[l].meshes[m].material != -1 ? self.layers[l].meshes[m].material : 0],
						textures: self.textures,
						matrix: matrix,
						shader: "StandardShader",
						primitive: pr_trianglestrip,
						dynamicBuffers: mesh.dynamicBuffers,
					}
				
					// Organise Render Queue Based On Aplha Transparent Objects And Push
					if ((renderStruct.material.alphaBlend >> BT_ALPHA_BLEND_SHIFT & BT_ALPHA_BLEND_BITS) != BTAlphaBlend.None) array_insert(renderer.renderQueue, 0, renderStruct);
					else array_push(renderer.renderQueue, renderStruct);
				}
			}
		}
		else
		{
			// Special Objects Loop
			for (var o = 0; o < array_length(self.specialObjects); o++)
			{
				// Model
				var model = self.specialObjects[o].model;
				
				// Loop Through Layer Meshes
				for (var m = 0; m < array_length(self.models[model].meshes); m++)
				{
					// Mesh ID
					var meshID = self.models[model].meshes[m].mesh;
					
					// Validate Mesh
					if (meshID >= 0)
					{
						// Mesh
						var mesh = self.meshes[meshID];
				
						// Skip if mesh type isn't 6
						if ((hideDisabledMeshes && !mesh.type) || mesh.vertexBufferObject == -1) continue;
				
						// Get Matrix
						var matrix = matrix_build_identity();
				
						// Create Render Struct
						var renderStruct = {
							vertexBuffer: mesh.vertexBufferObject,
							material: self.materials[self.models[model].meshes[m].material != -1 ? self.models[model].meshes[m].material : 0],
							textures: self.textures,
							matrix: matrix,
							shader: "StandardShader",
							primitive: pr_trianglestrip,
							dynamicBuffers: mesh.dynamicBuffers,
						}
				
						// Organise Render Queue Based On Aplha Transparent Objects And Push
						if ((renderStruct.material.alphaBlend >> BT_ALPHA_BLEND_SHIFT & BT_ALPHA_BLEND_BITS) != BTAlphaBlend.None) array_insert(renderer.renderQueue, 0, renderStruct);
						else array_push(renderer.renderQueue, renderStruct);
					}
				}
			}
		}
	}
	
	/// @func pushLayerToRenderQueue()
	/// @desc Pushes layer onto the render queue
	static pushLayerToRenderQueue = function(activeLayer = 0, renderer = RENDERER, hideDisabledMeshes = false)
	{
		// Loop Through Layer Meshes
		for (var m = 0; m < array_length(self.layers[activeLayer].meshes); m++)
		{
			// Mesh
			var mesh = self.meshes[self.layers[activeLayer].meshes[m].mesh];
			
			// Skip if mesh type isn't 6
			if ((hideDisabledMeshes && !mesh.type) || mesh.vertexBufferObject == -1) continue;
			
			// Get Matrix
			var matrix = matrix_build_identity();
			if (self.layers[activeLayer].meshes[m].bone != -1) matrix = self.bones[self.layers[activeLayer].meshes[m].bone].matrix;
			
			// Create Render Struct
			var renderStruct = {
				vertexBuffer: mesh.vertexBufferObject,
				material: self.materials[self.layers[activeLayer].meshes[m].material != -1 ? self.layers[activeLayer].meshes[m].material : 0],
				textures: self.textures,
				matrix: matrix,
				shader: "StandardShader",
				primitive: pr_trianglestrip,
				dynamicBuffers: mesh.dynamicBuffers,
			}
			
			// Organise Render Queue Based On Aplha Transparent Objects And Push
			if ((renderStruct.material.alphaBlend >> BT_ALPHA_BLEND_SHIFT & BT_ALPHA_BLEND_BITS) != BTAlphaBlend.None) array_insert(renderer.debugRenderQueue, 0, renderStruct);
			else array_push(renderer.debugRenderQueue, renderStruct);
		}
	}
	
	/// @func pushMeshToRenderQueue()
	/// @desc Pushes mesh onto the render queue
	static pushMeshToRenderQueue = function(renderer = RENDERER, meshIndex = 0)
	{
		// Mesh
		var mesh = self.meshes[meshIndex];
		
		// Get Matrix
		var matrix = matrix_build_identity();
		
		// Create Render Struct
		var renderStruct = {
			vertexBuffer: mesh.vertexBufferObject,
			material: self.materials[mesh.material != -1 ? mesh.material : 0],
			textures: self.textures,
			matrix: matrix,
			shader: "StandardShader",
			primitive: pr_trianglestrip,
		}
		
		// Organise Render Queue Based On Aplha Transparent Objects And Push
		if (renderStruct.material.alphaBlend >> 20 == 997 || (renderStruct.material.alphaBlend & 1) >= 1) array_insert(renderer.renderQueue, 0, renderStruct);
		else array_push(renderer.renderQueue, renderStruct);
	}
	
	#endregion
	
	#region Helper Functions
	
	/// @func getVersion()
	/// @desc Get Model Version
	static getVersion = function(buffer)
	{
		// Read First int (Could be either 808605006 (NU20) or the offset to the NU20)
		var NU20 = buffer_read(buffer, buffer_u32);
		
		// Check for NU20 first (Batman & Indy models)
		if (NU20 == 808605006)
		{
			// Seek to the version
			buffer_seek(buffer, buffer_seek_relative, 4);
			
			// Version
			var version = buffer_read(buffer, buffer_u32);
			
			// Seek to the start of the nu20
			buffer_seek(buffer, buffer_seek_relative, -12);
			
			// Return Model Version
			return version;
		}
		else
		{
			// Check if seek offset is within the size of the buffer
			if (NU20 + 4 > buffer_get_size(buffer)) return BTModelVersion.None;
			
			// Seek forward value of NU20 and check for NU20 there
			buffer_seek(buffer, buffer_seek_relative, NU20);
			
			// Check for NU20 last (TCS)
			NU20 = buffer_read(buffer, buffer_u32);
			if (NU20 == 808605006)
			{
				// Seek to the version
				buffer_seek(buffer, buffer_seek_relative, 4);
				
				// Version
				var version = buffer_read(buffer, buffer_u32);
				
				// Seek to the start of the nu20
				buffer_seek(buffer, buffer_seek_relative, -12);
				
				// Return Model Version
				return version;
			}
		}
		
		// Return Model Version None regardless
		return BTModelVersion.None;
	}
	
	/// @func getMaterial()
	/// @desc Get meshes material from layer data
	static getMaterial = function(mesh)
	{
		// Model Type
		if (self.type == BTModelType.model)
		{
			// Layers Loop
			for (var l = 0; l < array_length(self.layers); l++)
			{
				// Loop Through Layer Meshes
				for (var m = 0; m < array_length(self.layers[l].meshes); m++)
				{
					if (self.layers[l].meshes[m].mesh == mesh) return self.layers[l].meshes[m].material;
				}
			}
		}
		else
		{
			// Special Objects Loop
			for (var o = 0; o < array_length(self.specialObjects); o++)
			{
				// Get Model
				var model = self.models[self.specialObjects[o].model];
				show_debug_message(model);
				
				// Special Object Meshes Loop
				for (var m = 0; m < array_length(model.meshes); m++)
				{
					if (model.meshes[m].mesh == mesh) return model.meshes[m].material;
				}
			}
		}
		
		// Return -1 just incase
		return -1;
	}
	
	/// @func setMaterial()
	/// @desc Set meshes material from layer data
	static setMaterial = function(mesh, index)
	{
		// Model Type
		if (self.type == BTModelType.model)
		{
			// Layers Loop
			for (var l = 0; l < array_length(self.layers); l++)
			{
				// Loop Through Layer Meshes
				for (var m = 0; m < array_length(self.layers[l].meshes); m++)
				{
					if (self.layers[l].meshes[m].mesh == mesh)
					{
						self.layers[l].meshes[m].material = index;
						self.meshes[mesh].material = index;
					}
				}
			}
		}
		else
		{
			// Special Objects Loop
			for (var o = 0; o < array_length(self.specialObjects); o++)
			{
				// Get Model
				var model = self.models[self.specialObjects[o].model];
				
				// Special Object Meshes Loop
				for (var m = 0; m < array_length(model.meshes); m++)
				{
					if (model.meshes[m].mesh == mesh) model.meshes[m].material = index;
				}
			}
		}
	}
	
	#endregion

	#region Export Model
	
	static export = function(filepath, _layers = [])
	{
		// Create Buffer
		var buffer = buffer_create(1, buffer_grow, 1);
		
		// Write Header
		buffer_write(buffer, buffer_string, "BactaTankModel");
		buffer_write(buffer, buffer_string, "PCGHG");
		buffer_write(buffer, buffer_f32, 0.4);
		
		// Write Armature
		buffer_write(buffer, buffer_string, "BactaTankArmature");
		self.armature.serialize(buffer);
		
		// Write Materials
		buffer_write(buffer, buffer_string, "BactaTankMaterials");
		buffer_write(buffer, buffer_s32, array_length(self.materials));
		for (var i = 0; i < array_length(self.materials); i++)
		{
			buffer_write(buffer, buffer_string, $"Material{i}");
			self.materials[i].serialize(buffer);
			buffer_write(buffer, buffer_string, self.materials[i].textureID != -1 ? $"tex{self.materials[i].textureID}.dds" : "None");
			buffer_write(buffer, buffer_string, self.materials[i].normalID != -1 ? $"tex{self.materials[i].normalID}.dds" : "None");
		}
		
		// Write Meshes
		buffer_write(buffer, buffer_string, "BactaTankMeshes");
		var tempOffset = buffer_tell(buffer);
		buffer_write(buffer, buffer_s32, array_length(self.meshes));
		var meshCount = 0;
		for (var l = 0; l < array_length(self.layers); l++)
		{
			if (array_length(_layers) == array_length(self.layers) && !_layers[l]) continue;
			var lay = self.layers[l];
			for (var i = 0; i < array_length(lay.meshes); i++)
			{
				if (self.meshes[lay.meshes[i].mesh].vertexCount == 0) continue;
				buffer_write(buffer, buffer_string, $"Mesh{lay.meshes[i].mesh}");
				buffer_write(buffer, buffer_s32, lay.meshes[i].material);
				buffer_write(buffer, buffer_s32, lay.meshes[i].bone);
				self.meshes[lay.meshes[i].mesh].serialize(buffer, self);
				meshCount++;
			}
		}
		buffer_poke(buffer, tempOffset, buffer_s32, meshCount);
		
		// Save Buffer
		buffer_save(buffer, filepath);
		buffer_delete(buffer);
		
		// Save Textures
		for (var i = 0; i < array_length(self.textures); i++)
		{
			if (!is_struct(self.textures[i])) continue;
			buffer_save(self.textures[i].data, filename_path(filepath) + $"tex{i}.dds");
		}
	}
	
	#endregion
}

#region More Helper Functions

function loadBactaTankMesh(file)
{
	var cachedMesh = buffer_load(file);
	var mesh = vertex_create_buffer_from_buffer(cachedMesh, BT_MATERIAL_VERTEX_FORMAT);
	buffer_delete(cachedMesh);
	return mesh;
}

#endregion