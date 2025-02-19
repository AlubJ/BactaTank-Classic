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
	indexBuffer = -1;
	vertexBuffer = -1;
	
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
	
	static inject = function(buffer)
	{
		// Edit Mesh Data
		buffer_poke(buffer, offset,    buffer_s32, type);
		buffer_poke(buffer, offset+4,  buffer_s32, triangleCount);
		buffer_poke(buffer, offset+8,  buffer_s16, vertexStride);
		buffer_poke(buffer, offset+10, buffer_s8,  bones[0]);
		buffer_poke(buffer, offset+11, buffer_s8,  bones[1]);
		buffer_poke(buffer, offset+12, buffer_s8,  bones[2]);
		buffer_poke(buffer, offset+13, buffer_s8,  bones[3]);
		buffer_poke(buffer, offset+14, buffer_s8,  bones[4]);
		buffer_poke(buffer, offset+15, buffer_s8,  bones[5]);
		buffer_poke(buffer, offset+16, buffer_s8,  bones[6]);
		buffer_poke(buffer, offset+17, buffer_s8,  bones[7]);
		buffer_poke(buffer, offset+20, buffer_s32, vertexOffset);
		buffer_poke(buffer, offset+24, buffer_s32, vertexCount);
		buffer_poke(buffer, offset+28, buffer_s32, indexOffset);
		buffer_poke(buffer, offset+32, buffer_s32, indexBufferID);
		buffer_poke(buffer, offset+36, buffer_s32, vertexBufferID);
		buffer_poke(buffer, offset+40, buffer_s32, array_length(dynamicBuffers));
		
		// Some Offsets
		var dynamicBufferOffset = offset + 56;
		var dynamicBufferStartOffset = dynamicBufferOffset + array_length(dynamicBuffers) * 4;
		var dynamicBufferStartPointer = array_length(dynamicBuffers) * 4;
		ConsoleLog(dynamicBufferStartPointer)
		
		// Calculate Offsets
		for (var i = 0; i < array_length(dynamicBuffers); i++)
		{
			if (array_length(dynamicBuffers[i]) > 0) buffer_poke(buffer, dynamicBufferOffset + i * 4, buffer_s32, i == 0 ? dynamicBufferStartPointer : dynamicBufferStartPointer + ((vertexCount * 12) * i) - (i * 4));
			else buffer_poke(buffer, dynamicBufferOffset + i * 4, buffer_s32, 0);
		}
		
		// Write Dynamic Buffers
		for (var i = 0; i < array_length(dynamicBuffers); i++)
		{
			for (var j = 0; j < array_length(dynamicBuffers[i]); j++)
			{
				buffer_poke(buffer, dynamicBufferStartOffset, buffer_f32, dynamicBuffers[i][j]);
				dynamicBufferStartOffset += 4;
			}
		}
	}
	
	static link = function(buffer, vbOffsets, ibOffsets, _model)
	{
		// Create Buffers, otherwise skip over mesh
		if (triangleCount != 0) indexBuffer = buffer_create((triangleCount + 2) * 2, buffer_fixed, 1);
		else return;
		if (vertexCount != 0 && vertexStride != 0) vertexBuffer = buffer_create(vertexCount * vertexStride, buffer_fixed, 1);
		else return;
		
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
		
		// Vertices Loop
		for (var i = 0; i < vertexCount; i++)
		{
			// Set Vertex
			vertices[i] = {
				position : [0, 0, 0],
				normal: [0, 0, 0],
				tangent: [0, 0, 0, 0],
				bitangent: [0, 0, 0, 0],
				colourSet1: [1, 1, 1, 1],
				colourSet2: [1, 1, 1, 1],
				uvSet1: [0, 0],
				uvSet2: [0, 0],
				uvSet3: [0, 0],
				uvSet4: [0, 0],
				blendIndices: [0, 0, 0, 0],
				blendWeights: [0, 0, 0, 0],
				lightDirection: [],
			};
			
			// Get Vertex Format
			var vertexFormat = _model.materials[material].vertexFormat;
			
			// Loop Through Vertex Format
			for (var k = 0; k < array_length(vertexFormat); k++)
			{
				switch (vertexFormat[k].attribute)
				{
					case BTVertexAttributes.position:
						vertices[i].position = [buffer_peek(vertexBuffer, (vertexStride * i) + vertexFormat[k].position, buffer_f32),
										   buffer_peek(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 4, buffer_f32),
										   buffer_peek(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 8, buffer_f32)];
						break;
					case BTVertexAttributes.normal:
						vertices[i].normal = [((buffer_peek(vertexBuffer, (vertexStride * i) + vertexFormat[k].position, buffer_u8)/255)*2)-1,
										 ((buffer_peek(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 1, buffer_u8)/255)*2)-1,
										 ((buffer_peek(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 2, buffer_u8)/255)*2)-1];
						break;
					case BTVertexAttributes.tangent:
						vertices[i].tangent = [((buffer_peek(vertexBuffer, (vertexStride * i) + vertexFormat[k].position, buffer_u8)/255)*2)-1,
										  ((buffer_peek(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 1, buffer_u8)/255)*2)-1,
										  ((buffer_peek(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 2, buffer_u8)/255)*2)-1,
										  ((buffer_peek(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 3, buffer_u8)/255)*2)-1];
						break;
					case BTVertexAttributes.bitangent:
						vertices[i].bitangent = [((buffer_peek(vertexBuffer, (vertexStride * i) + vertexFormat[k].position, buffer_u8)/255)*2)-1,
										  ((buffer_peek(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 1, buffer_u8)/255)*2)-1,
										  ((buffer_peek(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 2, buffer_u8)/255)*2)-1,
										  ((buffer_peek(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 3, buffer_u8)/255)*2)-1];
						break;
					case BTVertexAttributes.colourSet1:
						vertices[i].colourSet1 = [buffer_peek(vertexBuffer, (vertexStride * i) + vertexFormat[k].position, buffer_u8)/255,
											 buffer_peek(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 1, buffer_u8)/255,
											 buffer_peek(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 2, buffer_u8)/255,
											 buffer_peek(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 3, buffer_u8)/255];
						break;
					case BTVertexAttributes.colourSet2:
						vertices[i].colourSet2 = [buffer_peek(vertexBuffer, (vertexStride * i) + vertexFormat[k].position, buffer_u8)/255,
											 buffer_peek(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 1, buffer_u8)/255,
											 buffer_peek(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 2, buffer_u8)/255,
											 buffer_peek(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 3, buffer_u8)/255];
						break;
					case BTVertexAttributes.uvSet1:
						vertices[i].uvSet1 = [buffer_peek(vertexBuffer, (vertexStride * i) + vertexFormat[k].position, buffer_f32),
										 buffer_peek(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 4, buffer_f32)];
						break;
					case BTVertexAttributes.uvSet2:
						vertices[i].uvSet2 = [buffer_peek(vertexBuffer, (vertexStride * i) + vertexFormat[k].position, buffer_f32),
										 buffer_peek(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 4, buffer_f32)];
						break;
					case BTVertexAttributes.uvSet3:
						vertices[i].uvSet3 = [buffer_peek(vertexBuffer, (vertexStride * i) + vertexFormat[k].position, buffer_f32),
										 buffer_peek(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 4, buffer_f32)];
						break;
					case BTVertexAttributes.uvSet4:
						vertices[i].uvSet4 = [buffer_peek(vertexBuffer, (vertexStride * i) + vertexFormat[k].position, buffer_f32),
										 buffer_peek(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 4, buffer_f32)];
						break;
					case BTVertexAttributes.blendWeights:
						vertices[i].blendWeights = [buffer_peek(vertexBuffer, (vertexStride * i) + vertexFormat[k].position, buffer_u8)/255,
											   buffer_peek(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 1, buffer_u8)/255,
											   buffer_peek(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 2, buffer_u8)/255,
											   buffer_peek(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 3, buffer_u8)/255];
						break;
					case BTVertexAttributes.blendIndices:
						vertices[i].blendIndices = [buffer_peek(vertexBuffer, (vertexStride * i) + vertexFormat[k].position, buffer_s8),
											   buffer_peek(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 1, buffer_s8),
											   buffer_peek(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 2, buffer_s8),
											   buffer_peek(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 3, buffer_s8)];
						break;
				}
			}
		}
		
		// Delete Vertex Buffer
		buffer_delete(vertexBuffer);
		
		// Triangles Loop
		for (var i = 0; i < triangleCount + 2; i++)
		{
			array_push(triangles, buffer_peek(indexBuffer, i * 2, buffer_u16));
		}
		
		// Delete Index Buffer
		buffer_delete(indexBuffer);
	}
	
	static build = function(_model = noone)
	{
		// Get Mesh And Skip If Null Mesh
		if (triangleCount == 0 || vertexCount == 0)
		{
			vertexBufferObject = -1;
			return;
		}
		
		// Delete Old VB
		if (vertexBufferObject != noone && vertexBufferObject != -1) vertex_delete_buffer(vertexBufferObject);
		
		// Vertex Buffer
		var currentVertexBuffer = noone;
		
		// Get Cached Mesh If Possible
		//var name = sha1_string_utf8(buffer_sha1(vertexBuffer, 0, buffer_get_size(vertexBuffer)) + buffer_sha1(indexBuffer, 0, buffer_get_size(indexBuffer))) + ".mesh";
		name = "a.mesh";
		if (file_exists(TEMP_DIRECTORY + @"\_maeshes\" + name))
		{
			var cachedMesh = buffer_load(TEMP_DIRECTORY + @"\_meshes\" + name);
			currentVertexBuffer = vertex_create_buffer_from_buffer(cachedMesh, BT_VERTEX_FORMAT);
			buffer_delete(cachedMesh);
		}
		else
		{
			// Create Vertex Buffer
			currentVertexBuffer = vertex_create_buffer();
			vertex_begin(currentVertexBuffer, BT_VERTEX_FORMAT);
			
			// Build VBO
			for (var i = 0; i < triangleCount + 2; i++)
			{
				// Get Index
				var index = triangles[i];
				
				var position = array_create(3, 0);
				var normal = array_create(3, 0);
				var tangent = [0, 0];
				var uv = array_create(2, 0);
				var colour = #ffffff;
				
				// Attributes
				if (array_length(vertices[index].position) == 3) position = vertices[index].position;
				if (array_length(vertices[index].normal) == 3) normal = vertices[index].normal;
				if (array_length(vertices[index].tangent) == 4) tangent = [make_colour_rgb(vertices[index].tangent[0] / 2 + 1, vertices[index].tangent[1] / 2 + 1, vertices[index].tangent[2] / 2 + 1), vertices[index].tangent[3]];
				if (_model.materials[material].surfaceUVMapIndex == 1)
					if (array_length(vertices[index].uvSet1) == 2) uv = vertices[index].uvSet1;
				else
					if (array_length(vertices[index].uvSet2) == 2) uv = vertices[index].uvSet2;
				if (array_length(vertices[index].colourSet1) == 4) colour = make_colour_rgb(vertices[index].colourSet1[0] * 255, vertices[index].colourSet1[1] * 255, vertices[index].colourSet1[2] * 255);
				
				// Add Vertex Positions
				vertex_position_3d(currentVertexBuffer, position[0], position[1], position[2]);
				vertex_normal(currentVertexBuffer, normal[0], normal[1], normal[2]);
				vertex_texcoord(currentVertexBuffer, uv[0], uv[1]);
				vertex_colour(currentVertexBuffer, colour, 1);
				vertex_colour(currentVertexBuffer, tangent[0], tangent[1]);
				vertex_texcoord(currentVertexBuffer, index, 0);
				
				// Update Average Position
				averagePosition[0] += position[0];
				averagePosition[1] += position[1];
				averagePosition[2] += position[2];
			}
				
			// Average Position
			averagePosition[0] /= triangleCount+2;
			averagePosition[1] /= triangleCount+2;
			averagePosition[2] /= triangleCount+2;
			
			// End Vertex
			vertex_end(currentVertexBuffer);
		}
		
		// Freeze VBO For Better Performance
		vertex_freeze(currentVertexBuffer);
		vertexBufferObject = currentVertexBuffer;
	}
	
	static buildVertexBuffer = function(_model = noone)
	{
		// Create Vertex Buffer
		var vertexBuffer = buffer_create(vertexCount * vertexStride, buffer_fixed, 1);
		
		// Get Vertex Format
		var vertexFormat = _model.materials[material].vertexFormat;
		
		// Build New Vertex Buffer
		for (var i = 0; i < vertexCount; i++)
		{
			// Loop Through Vertex Format
			for (var k = 0; k < array_length(vertexFormat); k++)
			{
				switch (vertexFormat[k].attribute)
				{
					case BTVertexAttributes.position:
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position, buffer_f32, vertices[i].position[0]);
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 4, buffer_f32, vertices[i].position[1]);
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 8, buffer_f32, vertices[i].position[2]);
						break;
					case BTVertexAttributes.normal:
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position, buffer_u8, floor(((vertices[i].normal[0] + 1) / 2) * 255));
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 1, buffer_u8, floor(((vertices[i].normal[1] + 1) / 2) * 255));
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 2, buffer_u8, floor(((vertices[i].normal[2] + 1) / 2) * 255));
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 3, buffer_u8, 0x7f);
						break;
					case BTVertexAttributes.tangent:
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position, buffer_u8, floor(((vertices[i].tangent[0] + 1) / 2) * 255));
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 1, buffer_u8, floor(((vertices[i].tangent[1] + 1) / 2) * 255));
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 2, buffer_u8, floor(((vertices[i].tangent[2] + 1) / 2) * 255));
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 3, buffer_u8, floor(((vertices[i].tangent[3] + 1) / 2) * 255));
						break;
					case BTVertexAttributes.bitangent:
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position, buffer_u8, floor(((vertices[i].bitangent[0] + 1) / 2) * 255));
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 1, buffer_u8, floor(((vertices[i].bitangent[1] + 1) / 2) * 255));
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 2, buffer_u8, floor(((vertices[i].bitangent[2] + 1) / 2) * 255));
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 3, buffer_u8, floor(((vertices[i].bitangent[3] + 1) / 2) * 255));
						break;
					case BTVertexAttributes.colourSet1:
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position, buffer_u8, floor(vertices[i].colourSet1[0] * 255));
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 1, buffer_u8, floor(vertices[i].colourSet1[1] * 255));
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 2, buffer_u8, floor(vertices[i].colourSet1[2] * 255));
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 3, buffer_u8, floor(vertices[i].colourSet1[3] * 255));
						break;
					case BTVertexAttributes.colourSet2:
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position, buffer_u8, floor(vertices[i].colourSet2[0] * 255));
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 1, buffer_u8, floor(vertices[i].colourSet2[1] * 255));
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 2, buffer_u8, floor(vertices[i].colourSet2[2] * 255));
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 3, buffer_u8, floor(vertices[i].colourSet2[3] * 255));
						break;
					case BTVertexAttributes.uvSet1:
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position, buffer_f32, vertices[i].uvSet1[0]);
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 4, buffer_f32, vertices[i].uvSet1[1]);
						break;
					case BTVertexAttributes.uvSet2:
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position, buffer_f32, vertices[i].uvSet2[0]);
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 4, buffer_f32, vertices[i].uvSet2[1]);
						break;
					case BTVertexAttributes.uvSet3:
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position, buffer_f32, vertices[i].uvSet3[0]);
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 4, buffer_f32, vertices[i].uvSet3[1]);
						break;
					case BTVertexAttributes.uvSet4:
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position, buffer_f32, vertices[i].uvSet4[0]);
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 4, buffer_f32, vertices[i].uvSet4[1]);
						break;
					case BTVertexAttributes.blendIndices:
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position, buffer_s8, floor(vertices[i].blendIndices[0]));
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 1, buffer_s8, floor(vertices[i].blendIndices[1]));
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 2, buffer_s8, floor(vertices[i].blendIndices[2]));
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 3, buffer_s8, floor(vertices[i].blendIndices[3]));
						break;
					case BTVertexAttributes.blendWeights:
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position, buffer_u8, floor(vertices[i].blendWeights[0] * 255));
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 1, buffer_u8, floor(vertices[i].blendWeights[1] * 255));
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 2, buffer_u8, floor(vertices[i].blendWeights[2] * 255));
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 3, buffer_u8, floor(vertices[i].blendWeights[3] * 255));
						break;
				}
			}
			
			//if (array_length(vertices[i].position) == 3)
			//{
			//	buffer_write(vertexBuffer, buffer_f32, vertices[i].position[0]);
			//	buffer_write(vertexBuffer, buffer_f32, vertices[i].position[1]);
			//	buffer_write(vertexBuffer, buffer_f32, vertices[i].position[2]);
			//}
			
			//if (array_length(vertices[i].normal) == 3)
			//{
			//	buffer_write(vertexBuffer, buffer_u8, floor((vertices[i].normal[0] + 1) / 2) * 255);
			//	buffer_write(vertexBuffer, buffer_u8, floor((vertices[i].normal[1] + 1) / 2) * 255);
			//	buffer_write(vertexBuffer, buffer_u8, floor((vertices[i].normal[2] + 1) / 2) * 255);
			//	buffer_write(vertexBuffer, buffer_u8, 0x7f);
			//}
			
			//if (array_length(vertices[i].tangent) == 4)
			//{
			//	buffer_write(vertexBuffer, buffer_u8, floor((vertices[i].tangent[0] + 1) / 2) * 255);
			//	buffer_write(vertexBuffer, buffer_u8, floor((vertices[i].tangent[1] + 1) / 2) * 255);
			//	buffer_write(vertexBuffer, buffer_u8, floor((vertices[i].tangent[2] + 1) / 2) * 255);
			//	buffer_write(vertexBuffer, buffer_u8, floor((vertices[i].tangent[3] + 1) / 2) * 255);
			//}
			
			//if (array_length(vertices[i].bitangent) == 4)
			//{
			//	buffer_write(vertexBuffer, buffer_u8, floor((vertices[i].bitangent[0] + 1) / 2) * 255);
			//	buffer_write(vertexBuffer, buffer_u8, floor((vertices[i].bitangent[1] + 1) / 2) * 255);
			//	buffer_write(vertexBuffer, buffer_u8, floor((vertices[i].bitangent[2] + 1) / 2) * 255);
			//	buffer_write(vertexBuffer, buffer_u8, floor((vertices[i].bitangent[3] + 1) / 2) * 255);
			//}
			
			//if (array_length(vertices[i].colourSet1) == 4)
			//{
			//	buffer_write(vertexBuffer, buffer_u8, floor(vertices[i].colourSet1[0] * 255));
			//	buffer_write(vertexBuffer, buffer_u8, floor(vertices[i].colourSet1[1] * 255));
			//	buffer_write(vertexBuffer, buffer_u8, floor(vertices[i].colourSet1[2] * 255));
			//	buffer_write(vertexBuffer, buffer_u8, floor(vertices[i].colourSet1[3] * 255));
			//}
			
			//if (array_length(vertices[i].colourSet2) == 4)
			//{
			//	buffer_write(vertexBuffer, buffer_u8, floor(vertices[i].colourSet2[0] * 255));
			//	buffer_write(vertexBuffer, buffer_u8, floor(vertices[i].colourSet2[1] * 255));
			//	buffer_write(vertexBuffer, buffer_u8, floor(vertices[i].colourSet2[2] * 255));
			//	buffer_write(vertexBuffer, buffer_u8, floor(vertices[i].colourSet2[3] * 255));
			//}
			
			//if (array_length(vertices[i].uvSet1) == 2)
			//{
			//	buffer_write(vertexBuffer, buffer_f32, vertices[i].uvSet1[0]);
			//	buffer_write(vertexBuffer, buffer_f32, vertices[i].uvSet1[1]);
			//}
			
			//if (array_length(vertices[i].blendWeights) == 4)
			//{
			//	buffer_write(vertexBuffer, buffer_u8, floor(vertices[i].blendWeights[0]));
			//	buffer_write(vertexBuffer, buffer_u8, floor(vertices[i].blendWeights[1]));
			//	buffer_write(vertexBuffer, buffer_u8, floor(vertices[i].blendWeights[2]));
			//	buffer_write(vertexBuffer, buffer_u8, floor(vertices[i].blendWeights[3]));
			//}
			
			//if (array_length(vertices[i].blendIndices) == 4)
			//{
			//	buffer_write(vertexBuffer, buffer_s8, floor(vertices[i].blendIndices[0]));
			//	buffer_write(vertexBuffer, buffer_s8, floor(vertices[i].blendIndices[1]));
			//	buffer_write(vertexBuffer, buffer_s8, floor(vertices[i].blendIndices[2]));
			//	buffer_write(vertexBuffer, buffer_s8, floor(vertices[i].blendIndices[3]));
			//}
		}
		
		// Return Buffer
		return vertexBuffer;
	}
	
	static buildIndexBuffer = function()
	{
		// Create Index Buffer
		var indexBuffer = buffer_create((triangleCount + 2) * 2, buffer_fixed, 1);
		
		// Build New Index Buffer
		for (var i = 0; i < (triangleCount + 2); i++)
		{
			buffer_write(indexBuffer, buffer_u16, triangles[i]);
		}
		
		// Return Index Buffer
		return indexBuffer;
	}
	
	#endregion
	
	#region Serialize / Deserialize
	
	
	
	#endregion
	
	#region Export / Replace
	
	/// @func export()
	/// @desc Export v0.4 BactaTankMesh
	static export = function(filepath, _model = noone)
	{
		var bmesh = new BactaTankBMesh();
		bmesh.fromMesh(self, _model);
		bmesh.export(filepath, _model);
	}
	
	/// @func replace()
	/// @desc Replace BactaTankMesh
	static replace = function(filepath, _model = noone)
	{
		var bmesh = new BactaTankBMesh();
		bmesh.import(filepath, _model);
		bmesh.toMesh(self, _model);
		
		// Collect Garbage (Because we've derefereced an older mesh here, I need to use this more!)
		gc_collect();
		
		// Build Mesh
		build(_model);
	}
	
	#endregion
	
	/// @func dereference()
	/// @desc Dereferences a mesh, and removes it from the model
	static dereference = function()
	{
		// Destroy Vertex Buffer
		if (vertexBufferObject != -1) vertex_delete_buffer(vertexBufferObject);
		vertexBufferObject = -1;
		
		// Destroy Buffers
		indexBuffer = -1;
		vertexBuffer = -1;
		
		// Zero out all variables
		type = 0;
		triangleCount = 0;
		vertexStride = 0;
		bones = array_create(8, 0);
		flags = 0;
		vertexOffset = 0;
		vertexCount = 0;
		indexOffset = 0;
		indexBufferID = 0;
		vertexBufferID = 0;
		dynamicBuffers = [  ];
	}

	#region Rendering
	
	static pushToRenderQueue = function(renderQueue = RENDERER.renderQueue)
	{
		
	}
	
	#endregion
}