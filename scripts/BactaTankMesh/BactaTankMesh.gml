/*
	BactaTankMesh
	-------------------------------------------------------------------------
	Script:			BactaTankMesh
	Version:		v1.00
	Created:		04/02/2025 by Alun Jones
	Description:	Mesh Loader and Container
	-------------------------------------------------------------------------
	History:
	 - Created 04/02/2025 by Alun Jones
	
	To Do:
*/

function BactaTankMesh() constructor
{
	// Mesh Primitive Type
	type = 6;
	
	// Linked Bones
	bones = [-1, -1, -1, -1, -1, -1, -1, -1];
	
	// Flags (Unused)
	flags =	0;
	
	// Vertex / Triangle Information
	vertexStride = 0;
	vertexOffset = 0;
	vertexCount = 0;
	triangleCount = 0;
	indexOffset = 0;
	
	// Vertex Buffer
	indexBufferID = 0;
	vertexBufferID = 0;
	indexBuffer = 0;
	vertexBuffer = 0;
	
	// Vertices and Indices
	vertices = [  ];
	triangles = [  ];
	
	// Dynamic Buffers
	dynamicBuffers = [  ];
	
	// Renderer
	vertexBufferObject = noone;
	dynamicBufferObjects = noone;
	material = -1;
	
	// Other
	offset = 0;
	averagePosition = [0, 0, 0, 0];
	
	#region Parse / Inject
	
	static parse = function(buffer, _model)
	{
		// Get Offset
		offset = buffer_tell(buffer) - _model.nu20Offset;
			
		// Type, Tri Count and Vertex Stride
		type = buffer_read(buffer, buffer_u32);
		triangleCount = buffer_read(buffer, buffer_u32);
		vertexStride = buffer_read(buffer, buffer_u16);
		
		// Bones
		bones = [];
		repeat(8) array_push(bones, buffer_read(buffer, buffer_s8));
		
		// Flags
		flags = buffer_read(buffer, buffer_u16); // Unused
		
		// Vertex Count, Offset and Index Offset
		vertexOffset = buffer_read(buffer, buffer_u32);
		vertexCount = buffer_read(buffer, buffer_u32);
		indexOffset = buffer_read(buffer, buffer_u32);
		
		// Vertex / Index Buffer IDs
		indexBufferID = buffer_read(buffer, buffer_u32);
		vertexBufferID = buffer_read(buffer, buffer_u32);
		
		// Dynamic Buffer Count
		var dynamicBufferCount = buffer_read(buffer, buffer_u32);
		buffer_seek(buffer, buffer_seek_relative, buffer_read(buffer, buffer_u32) - 4);
			
		// Dynamic Buffers
		dynamicBuffers = [];
		for (var i = 0; i < dynamicBufferCount; i++)
		{
			// Dynamic Buffer
			var dynamicBuffer = []; // VertexCount * 3
				
			// Seek to Dynamic Buffer
			var tempDynOffset = buffer_tell(buffer) + 4;
			var dynamicBufferOffset = buffer_read(buffer, buffer_u32);
			buffer_seek(buffer, buffer_seek_relative, dynamicBufferOffset - 4);
				
			// Add points to dynamic buffer
			if (dynamicBufferOffset != 0) repeat(vertexCount * 3) array_push(dynamicBuffer, buffer_read(buffer, buffer_f32));
			else dynamicBuffer = -1;
				
			// Add To Dynamic Buffers List
			dynamicBuffers[i] = dynamicBuffer;
				
			// Seek back to temp offset
			buffer_seek(buffer, buffer_seek_start, tempDynOffset);
		}
		
		// Create Buffers
		if (triangleCount != 0) indexBuffer = buffer_create((triangleCount + 2) * 2, buffer_fixed, 1);
		if (vertexCount != 0 && vertexStride != 0) vertexBuffer = buffer_create(vertexCount * vertexStride, buffer_fixed, 1);
			
		// Log
		//var offset = meshOffset + self.nu20Offset;
		//ConsoleLog($"Mesh {i}", CONSOLE_MODEL_LOADER_DEBUG, offset);
		//ConsoleLog($"	Primitive Type: {meshType}", CONSOLE_MODEL_LOADER_DEBUG, offset);
		//ConsoleLog($"	Triangle Count:       {meshTriangleCount}", CONSOLE_MODEL_LOADER_DEBUG, offset + 4);
		//ConsoleLog($"	Vertex Stride:        {meshVertexStride}", CONSOLE_MODEL_LOADER_DEBUG, offset + 8);
		//ConsoleLog($"	Bones:                [{meshBones[0]}, {meshBones[1]}, {meshBones[2]}, {meshBones[3]}, {meshBones[4]}, {meshBones[5]}, {meshBones[6]}, {meshBones[7]}]", CONSOLE_MODEL_LOADER_DEBUG, offset + 10);
		//ConsoleLog($"	Vertex Offset:        {meshVertexOffset}", CONSOLE_MODEL_LOADER_DEBUG, offset + 20);
		//ConsoleLog($"	Vertex Count:         {meshVertexCount}", CONSOLE_MODEL_LOADER_DEBUG, offset + 24);
		//ConsoleLog($"	Index Offset:         {meshIndexOffset}", CONSOLE_MODEL_LOADER_DEBUG, offset + 28);
		//ConsoleLog($"	Index Buffer ID:      {meshIndexBufferID}", CONSOLE_MODEL_LOADER_DEBUG, offset + 32);
		//ConsoleLog($"	Vertex Buffer ID:     {meshVertexBufferID}", CONSOLE_MODEL_LOADER_DEBUG, offset + 36);
		//ConsoleLog($"	Dynamic Buffer Count: {meshDynamicBufferCount}", CONSOLE_MODEL_LOADER_DEBUG, offset + 40);
	}
	
	static link = function(buffer, vbOffsets, ibOffsets, _model)
	{
		// Copy Buffers
		buffer_copy(buffer,
						vbOffsets[vertexBufferID] + vertexOffset * vertexStride,
						vertexCount * vertexStride,
						vertexBuffer,
						0);
		buffer_copy(buffer,
					ibOffsets[indexBufferID] + indexOffset * 2,
					(triangleCount + 2) * 2,
					indexBuffer,
					0);
		
		//// Vertices Loop
		//repeat(vertexCount)
		//{
		//	// Get Vertex Format
		//	var vertexFormat = _model.materials[material].vertexFormat;
			
		//	// Loop Through Vertex Format
		//	for (var k = 0; k < array_length(vertexFormat); k++)
		//	{
		//		switch (vertexFormat[k].attribute)
		//		{
		//			case BTVertexAttributes.position:
		//				array_push(vertices, [buffer_peek(vertexBuffer, vertexStride + vertexFormat[k].position, buffer_f32),
		//									  buffer_peek(vertexBuffer, vertexStride + vertexFormat[k].position + 4, buffer_f32),
		//									  buffer_peek(vertexBuffer, vertexStride + vertexFormat[k].position + 8, buffer_f32)]);
		//				break;
		//			case BTVertexAttributes.normal:
		//				array_push(vertices, [((buffer_peek(vertexBuffer, vertexStride + vertexFormat[k].position, buffer_u8)/255)*2)-1,
		//									  ((buffer_peek(vertexBuffer, vertexStride + vertexFormat[k].position + 1, buffer_u8)/255)*2)-1,
		//									  ((buffer_peek(vertexBuffer, vertexStride + vertexFormat[k].position + 2, buffer_u8)/255)*2)-1]);
		//				break;
		//			case BTVertexAttributes.tangent:
		//				tangent = [make_colour_rgb(buffer_peek(mesh.vertexBuffer, (mesh.vertexStride * index) + vertexFormat[k].position, buffer_u8),
		//							buffer_peek(mesh.vertexBuffer, (mesh.vertexStride * index) + vertexFormat[k].position + 1, buffer_u8),
		//							buffer_peek(mesh.vertexBuffer, (mesh.vertexStride * index) + vertexFormat[k].position + 2, buffer_u8)),
		//							buffer_peek(mesh.vertexBuffer, (mesh.vertexStride * index) + vertexFormat[k].position + 3, buffer_u8) / 255];
		//				break;
		//			case BTVertexAttributes.uv:
		//				tex = [buffer_peek(mesh.vertexBuffer, (mesh.vertexStride * index) + vertexFormat[k].position, buffer_f32),
		//						buffer_peek(mesh.vertexBuffer, (mesh.vertexStride * index) + vertexFormat[k].position + 4, buffer_f32)];
		//				break;
		//			case BTVertexAttributes.colour:
		//				col = make_colour_rgb(
		//						buffer_peek(mesh.vertexBuffer, (mesh.vertexStride * index) + vertexFormat[k].position, buffer_u8),
		//						buffer_peek(mesh.vertexBuffer, (mesh.vertexStride * index) + vertexFormat[k].position + 1, buffer_u8),
		//						buffer_peek(mesh.vertexBuffer, (mesh.vertexStride * index) + vertexFormat[k].position + 2, buffer_u8));
		//				break;
		//		}
		//	}
		//}
	}
	
	#endregion
	
	#region Serialize / Deserialize
	
	
	
	#endregion
	
	#region Export / Replace Mesh
	
	/// @func exportMesh()
	/// @desc Export BactaTankMesh
	static exportMesh = function(meshIndex, filepath)
	{
		// Create Export Buffer
		var buffer = buffer_create(1, buffer_grow, 1);
		
		// Mesh
		var mesh = self.meshes[meshIndex];
		var material = getMaterial(meshIndex);
		var bones = self.bones;
		
		// VF value
		var vfValue = 0;
		if (mesh.vertexStride == 28) vfValue = 2313;
		if (mesh.vertexStride == 36) vfValue = 33556745;
		
		// Get Vertex Format
		var vertexFormat = self.materials[material].vertexFormat;
		
		// Write Header
		buffer_write(buffer, buffer_string, "BactaTank");
		buffer_write(buffer, buffer_string, "PCGHG");
		buffer_write(buffer, buffer_f32, 0.3);
		buffer_write(buffer, buffer_string, "Materials");
		buffer_write(buffer, buffer_u32, 0);
		
		// Bones
		buffer_write(buffer, buffer_string, "Bones");
		//buffer_write(buffer, buffer_u32, array_length(bones));
		buffer_write(buffer, buffer_u32, 0);
		
		//for (var i = 0; i < array_length(bones); i++)
		//{
		//	var bone = bones[i];
		//	buffer_write(buffer, buffer_string, bone.name);
		//	buffer_write(buffer, buffer_s32, bone.parent);
		//	for (var j = 0; j < 16; j++) buffer_write(buffer, buffer_f32, bone.matrix[j]);
		//}
		
		buffer_write(buffer, buffer_string, "Meshes");
		buffer_write(buffer, buffer_u32, 1);
		buffer_write(buffer, buffer_string, "MeshData");
		
		// Write Mesh Data
		buffer_write(buffer, buffer_u32, mesh.triangleCount);
		buffer_write(buffer, buffer_u32, mesh.vertexCount);
		for (var i = 0; i < 8; i++) buffer_write(buffer, buffer_s8, mesh.bones[i]);
		
		// Write Mesh Attributes
		buffer_write(buffer, buffer_string, "MeshAttributes");
		buffer_write(buffer, buffer_u32, 6);
		buffer_write(buffer, buffer_string, "Position");
		buffer_write(buffer, buffer_string, "Normal");
		buffer_write(buffer, buffer_string, "Colour");
		buffer_write(buffer, buffer_string, "UV");
		buffer_write(buffer, buffer_string, "BlendIndices");
		buffer_write(buffer, buffer_string, "BlendWeights");
		
		// Write Vertex Buffer
		buffer_write(buffer, buffer_string, "VertexBuffer");
	
		// Write Positions
		buffer_write(buffer, buffer_string, "Position");
		for (var i = 0; i < mesh.vertexCount; i++)
		{
			for (var j = 0; j < array_length(vertexFormat); j++)
			{
				if (vertexFormat[j].attribute == BTVertexAttributes.position)
				{
					buffer_write(buffer, buffer_f32, buffer_peek(mesh.vertexBuffer, (i*mesh.vertexStride) + vertexFormat[j].position, buffer_f32));
					buffer_write(buffer, buffer_f32, buffer_peek(mesh.vertexBuffer, (i*mesh.vertexStride) + vertexFormat[j].position + 4, buffer_f32));
					buffer_write(buffer, buffer_f32, buffer_peek(mesh.vertexBuffer, (i*mesh.vertexStride) + vertexFormat[j].position + 8, buffer_f32));
				}
			}
		}
		
		// Write Normals
		buffer_write(buffer, buffer_string, "Normal");
		for (var i = 0; i < mesh.vertexCount; i++)
		{
			for (var j = 0; j < array_length(vertexFormat); j++)
			{
				if (vertexFormat[j].attribute == BTVertexAttributes.normal)
				{
					buffer_write(buffer, buffer_u32, buffer_peek(mesh.vertexBuffer, (i*mesh.vertexStride) + vertexFormat[j].position, buffer_u32));
				}
			}
		}
		
		// Write Colour
		buffer_write(buffer, buffer_string, "Colour");
		for (var i = 0; i < mesh.vertexCount; i++)
		{
			for (var j = 0; j < array_length(vertexFormat); j++)
			{
				if (vertexFormat[j].attribute == BTVertexAttributes.colour)
				{
					buffer_write(buffer, buffer_u32, buffer_peek(mesh.vertexBuffer, (i*mesh.vertexStride) + vertexFormat[j].position, buffer_u32));
				}
			}
		}
		
		// Write UVs
		buffer_write(buffer, buffer_string, "UV");
		for (var i = 0; i < mesh.vertexCount; i++)
		{
			for (var j = 0; j < array_length(vertexFormat); j++)
			{
				if (vertexFormat[j].attribute == BTVertexAttributes.uv)
				{
					buffer_write(buffer, buffer_f32, buffer_peek(mesh.vertexBuffer, (i*mesh.vertexStride) + vertexFormat[j].position, buffer_f32));
					buffer_write(buffer, buffer_f32, buffer_peek(mesh.vertexBuffer, (i*mesh.vertexStride) + vertexFormat[j].position + 4, buffer_f32));
				}
			}
		}
		
		// Write Blend Indices
		buffer_write(buffer, buffer_string, "BlendIndices");
		for (var i = 0; i < mesh.vertexCount; i++)
		{
			var write = false;
			for (var j = 0; j < array_length(vertexFormat); j++)
			{
				if (vertexFormat[j].attribute == BTVertexAttributes.blendWeights)
				{
					buffer_write(buffer, buffer_u32, buffer_peek(mesh.vertexBuffer, (i*mesh.vertexStride) + vertexFormat[j].position, buffer_u32));
					write = true;
				}
			}
			if (!write) buffer_write(buffer, buffer_s32, -1);
		}
		
		// Write Blend Weights
		buffer_write(buffer, buffer_string, "BlendWeights");
		for (var i = 0; i < mesh.vertexCount; i++)
		{
			var write = false;
			for (var j = 0; j < array_length(vertexFormat); j++)
			{
				if (vertexFormat[j].attribute == BTVertexAttributes.blendIndices)
				{
					buffer_write(buffer, buffer_u32, buffer_peek(mesh.vertexBuffer, (i*mesh.vertexStride) + vertexFormat[j].position, buffer_u32));
					write = true;
				}
			}
			if (!write) buffer_write(buffer, buffer_s32, -1);
		}
		
		// Write Index Buffer
		buffer_write(buffer, buffer_string, "IndexBuffer");
		buffer_write(buffer, buffer_u32, buffer_get_size(mesh.indexBuffer));
		buffer_copy(mesh.indexBuffer, 0, buffer_get_size(mesh.indexBuffer), buffer, buffer_tell(buffer));
		buffer_seek(buffer, buffer_seek_relative, buffer_get_size(mesh.indexBuffer));
		
		// Buffer Save
		buffer_save(buffer, filepath);
		buffer_delete(buffer);
	}
	
	/// @func replaceMesh()
	/// @desc Replace BactaTankMesh
	static replaceMesh = function(meshIndex, filepath)
	{
		// Load Mesh File
		var buffer = buffer_load(filepath);
		
		// Current Mesh
		var mesh = self.meshes[meshIndex];
		var material = getMaterial(meshIndex);
		
		// VF value
		var vfValue = 0;
		if (mesh.vertexStride == 28) vfValue = 2313;
		if (mesh.vertexStride == 36) vfValue = 33556745;
		
		// Get Vertex Format
		var vertexFormat = self.materials[material].vertexFormat;
		
		// Read Mesh File
		buffer_read(buffer, buffer_string);					// BactaTank
		buffer_read(buffer, buffer_string);					// PCGHG
		var version = buffer_read(buffer, buffer_f32);		// 0.3
		if (version != 0.3) return;
		buffer_read(buffer, buffer_string);					// Materials
		buffer_read(buffer, buffer_u32);					// 0
		buffer_read(buffer, buffer_string);					// Bones
		buffer_read(buffer, buffer_u32);					// 0
		buffer_read(buffer, buffer_string);					// Meshes
		buffer_read(buffer, buffer_u32);					// 1
		buffer_read(buffer, buffer_string);					// MeshData
		
		// Mesh Data
		var newTriangleCount = buffer_read(buffer, buffer_u32);
		var newVertexCount = buffer_read(buffer, buffer_u32);
		var newBoneLinks = [];
		repeat(8) array_push(newBoneLinks, buffer_read(buffer, buffer_s8));
		
		// Mesh Attributes
		buffer_read(buffer, buffer_string);	// Mesh Attributes
		var attributeCount = buffer_read(buffer, buffer_u32);
		repeat (attributeCount) buffer_read(buffer, buffer_string); // Position, Normal, Colour, UV
		
		// Vertex Buffer
		buffer_read(buffer, buffer_string);
		
		// Position Attribute
		buffer_read(buffer, buffer_string);
		var position = [];
		
		for (var i = 0; i < newVertexCount; i++)
		{
			var positionX = buffer_read(buffer, buffer_f32);
			var positionY = buffer_read(buffer, buffer_f32);
			var positionZ = buffer_read(buffer, buffer_f32);
			array_push(position, [positionX, positionY, positionZ])
		}
		
		// Normal Attribute
		buffer_read(buffer, buffer_string);
		var normal = [];
		
		for (var i = 0; i < newVertexCount; i++)
		{
			array_push(normal, buffer_read(buffer, buffer_u32));
		}
		
		// Colour Attribute
		buffer_read(buffer, buffer_string);
		var colour = [];
		
		for (var i = 0; i < newVertexCount; i++)
		{
			array_push(colour, buffer_read(buffer, buffer_u32));
		}
		
		// UV Attribute
		buffer_read(buffer, buffer_string);
		var uv = [];
		
		for (var i = 0; i < newVertexCount; i++)
		{
			var uvX = buffer_read(buffer, buffer_f32);
			var uvY = buffer_read(buffer, buffer_f32);
			array_push(uv, [uvX, uvY]);
		}
		
		if (attributeCount > 4)
		{
			// Bone Indices Attribute
			buffer_read(buffer, buffer_string);
			var boneIndices = [];
			
			for (var i = 0; i < newVertexCount; i++)
			{
				boneIndices[i] = buffer_read(buffer, buffer_u32);
			}
			
			// Bone Indices Attribute
			buffer_read(buffer, buffer_string);
			var boneWeights = [];
			
			for (var i = 0; i < newVertexCount; i++)
			{
				boneWeights[i] = buffer_read(buffer, buffer_u32);
			}
		}
		
		// Check if mesh Vertex Stride is More then 0
		var size = 0;
		for (var i = 0; i < array_length(vertexFormat); i++)
		{
			switch (vertexFormat[i].attribute)
			{
				case BTVertexAttributes.position:
					size += 12;
					break;
				case BTVertexAttributes.uv:
					size += 8;
					break;
				case BTVertexAttributes.normal:
				case BTVertexAttributes.colour:
				case BTVertexAttributes.tangent:
				case BTVertexAttributes.bitangent:
				case BTVertexAttributes.blendIndices:
				case BTVertexAttributes.blendWeights:
					size += 4;
					break;
			}
		}
		mesh.vertexStride = size;
		
		// Delete Old Vertex Buffer
		if (buffer_exists(mesh.vertexBuffer)) buffer_delete(mesh.vertexBuffer);
		
		// Build New Vertex Buffer
		mesh.vertexBuffer = buffer_create(newVertexCount * mesh.vertexStride, buffer_fixed, 1);
		
		for (var i = 0; i < newVertexCount; i++)
		{
			//show_debug_message(position[i][1]);
			for (var j = 0; j < array_length(vertexFormat); j++)
			{
				switch (vertexFormat[j].attribute)
				{
					case BTVertexAttributes.position:
						buffer_write(mesh.vertexBuffer, buffer_f32, position[i][0]);
						buffer_write(mesh.vertexBuffer, buffer_f32, position[i][1]);
						buffer_write(mesh.vertexBuffer, buffer_f32, position[i][2]);
						break;
					case BTVertexAttributes.normal:
						buffer_write(mesh.vertexBuffer, buffer_u32, normal[i]);
						break;
					case BTVertexAttributes.colour:
						buffer_write(mesh.vertexBuffer, buffer_u32, colour[i]);
						break;
					case BTVertexAttributes.uv:
						buffer_write(mesh.vertexBuffer, buffer_f32, uv[i][0]);
						buffer_write(mesh.vertexBuffer, buffer_f32, uv[i][1]);
						break;
					case BTVertexAttributes.tangent:
						buffer_write(mesh.vertexBuffer, buffer_u32, 0);
						break;
					case BTVertexAttributes.bitangent:
						buffer_write(mesh.vertexBuffer, buffer_u32, 0);
						break;
					case BTVertexAttributes.blendIndices:
						buffer_write(mesh.vertexBuffer, buffer_u32, boneWeights[i]);
						break;
					case BTVertexAttributes.blendWeights:
						buffer_write(mesh.vertexBuffer, buffer_u32, boneIndices[i]);
						break;
				}
			}
		}
		
		// Index Buffer
		buffer_read(buffer, buffer_string); // IndexBuffer
		var newIndexBufferSize = buffer_read(buffer, buffer_u32);
		if (buffer_exists(mesh.indexBuffer)) buffer_delete(mesh.indexBuffer);
		mesh.indexBuffer = buffer_create(newIndexBufferSize, buffer_fixed, 1);
		buffer_copy(buffer, buffer_tell(buffer), newIndexBufferSize, mesh.indexBuffer, 0);
		buffer_seek(buffer, buffer_seek_relative, newIndexBufferSize);
		
		// Delete Mesh Buffer
		buffer_delete(buffer);
		if (mesh.vertexBufferObject != -1) vertex_delete_buffer(mesh.vertexBufferObject);
		
		// Set New Variables
		mesh.type = 6;
		mesh.triangleCount = newTriangleCount;
		mesh.vertexCount = newVertexCount;
		mesh.bones = newBoneLinks;
		
		// Build New VBO
		if (mesh.triangleCount == 0 || mesh.vertexCount == 0)
		{
			mesh.vertexBufferObject = -1;
			return;
		}
		
		// Create New Vertex Buffer
		var currentVertexBuffer = vertex_create_buffer();
		vertex_begin(currentVertexBuffer, BT_VERTEX_FORMAT);
		
		// Build VBO
		for (var i = 0; i < mesh.triangleCount+2; i++)
		{
			var index = buffer_peek(mesh.indexBuffer, i*2, buffer_u16);
			var pos = array_create(3, 0);
			var norm = array_create(3, 0);
			var tangent = [0, 0];
			var tex = array_create(2, 0);
			var col = 0;
			for (var j = 0; j < array_length(vertexFormat); j++)
			{
				switch (vertexFormat[j].attribute)
				{
					case BTVertexAttributes.position:
						pos = [buffer_peek(mesh.vertexBuffer, (mesh.vertexStride * index) + vertexFormat[j].position, buffer_f32),
								buffer_peek(mesh.vertexBuffer, (mesh.vertexStride * index) + vertexFormat[j].position + 4, buffer_f32),
								buffer_peek(mesh.vertexBuffer, (mesh.vertexStride * index) + vertexFormat[j].position + 8, buffer_f32)];
						break;
					case BTVertexAttributes.normal:
						norm = [((buffer_peek(mesh.vertexBuffer, (mesh.vertexStride * index) + vertexFormat[j].position, buffer_u8)/255)*2)-1,
								((buffer_peek(mesh.vertexBuffer, (mesh.vertexStride * index) + vertexFormat[j].position + 1, buffer_u8)/255)*2)-1,
								((buffer_peek(mesh.vertexBuffer, (mesh.vertexStride * index) + vertexFormat[j].position + 2, buffer_u8)/255)*2)-1];
					case BTVertexAttributes.tangent:
						tangent = [make_colour_rgb(buffer_peek(mesh.vertexBuffer, (mesh.vertexStride * index) + vertexFormat[j].position, buffer_u8),
									buffer_peek(mesh.vertexBuffer, (mesh.vertexStride * index) + vertexFormat[j].position + 1, buffer_u8),
									buffer_peek(mesh.vertexBuffer, (mesh.vertexStride * index) + vertexFormat[j].position + 2, buffer_u8)),
									buffer_peek(mesh.vertexBuffer, (mesh.vertexStride * index) + vertexFormat[j].position + 3, buffer_u8) / 255];
						break;
					case BTVertexAttributes.uv:
						tex = [buffer_peek(mesh.vertexBuffer, (mesh.vertexStride * index) + vertexFormat[j].position, buffer_f32),
								buffer_peek(mesh.vertexBuffer, (mesh.vertexStride * index) + vertexFormat[j].position + 4, buffer_f32)];
						break;
					case BTVertexAttributes.colour:
						col = make_colour_rgb(
								buffer_peek(mesh.vertexBuffer, (mesh.vertexStride * index) + vertexFormat[j].position, buffer_u8),
								buffer_peek(mesh.vertexBuffer, (mesh.vertexStride * index) + vertexFormat[j].position + 1, buffer_u8),
								buffer_peek(mesh.vertexBuffer, (mesh.vertexStride * index) + vertexFormat[j].position + 2, buffer_u8));
						break;
				}
			}
			
			// Add Vertex Positions
			vertex_position_3d(currentVertexBuffer, pos[0], pos[1], pos[2]);
			vertex_normal(currentVertexBuffer, norm[0], norm[1], norm[2]);
			vertex_texcoord(currentVertexBuffer, tex[0], tex[1]);
			vertex_colour(currentVertexBuffer, #ffffff, 1);
			vertex_colour(currentVertexBuffer, tangent[0], tangent[1]);
			vertex_texcoord(currentVertexBuffer, index, 0);
		}
		
		// End Vertex Buffer
		vertex_end(currentVertexBuffer);
		
		// Freeze Vertex Buffer
		vertex_freeze(currentVertexBuffer);
		
		// Set VBO
		mesh.vertexBufferObject = currentVertexBuffer;
		
		// Set Mesh
		self.meshes[meshIndex] = mesh;
	}
	
	/// @func dereferenceMesh()
	/// @desc Dereferences a mesh, and removes it from the model
	static dereferenceMesh = function(meshIndex)
	{
		// Mesh
		var mesh = self.meshes[meshIndex];
		
		// Destroy Vertex Buffer
		if (mesh.vertexBufferObject != -1) vertex_delete_buffer(mesh.vertexBufferObject);
		mesh.vertexBufferObject = -1;
		
		// Destroy Buffers
		if (mesh.indexBuffer != -1) buffer_delete(mesh.indexBuffer);
		if (mesh.vertexBuffer != -1) buffer_delete(mesh.vertexBuffer);
		mesh.indexBuffer = -1;
		mesh.vertexBuffer = -1;
		
		// Zero out all variables
		mesh.type = 0;
		mesh.triangleCount = 0;
		mesh.vertexStride = 0;
		mesh.bones = array_create(8, 0);
		mesh.flags = 0;
		mesh.vertexOffset = 0;
		mesh.vertexCount = 0;
		mesh.indexOffset = 0;
		mesh.indexBufferID = 0;
		mesh.vertexBufferID = 0;
		mesh.dynamicBuffers = [  ];
		
		// Set Mesh
		self.meshes[meshIndex] = mesh;
	}
	
	#endregion

	#region Rendering
	
	static pushToRenderQueue = function(renderQueue = RENDERER.renderQueue)
	{
		
	}
	
	#endregion
}