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
	
	// UV Map
	uvSet1 = -1;
	uvSet2 = -1;
	
	// Renderer
	vertexBufferObject = noone;
	dynamicBufferObjects = noone;
	material = -1;
	
	// Other
	offset = 0;
	averagePosition = [0, 0, 0, 0];
	uvSet1AveragePosition = [0, 0];
	lastFilename = "";
	
	#region Parse / Inject
	
	static parse = function(buffer, _index, _model)
	{
		// Get Offset
		offset = buffer_tell(buffer) - _model.nu20Offset;
			
		// Type, Tri Count and Vertex Stride
		type = buffer_read(buffer, buffer_u32);
		triangleCount = buffer_read(buffer, _model.version == BTModelVersion.Version1 ? buffer_u16 : buffer_u32);
		vertexStride = buffer_read(buffer, buffer_u16);
		
		// Bones
		bones = [];
		repeat(8) array_push(bones, buffer_read(buffer, buffer_s8));
		
		// Flags
		if (_model.version != BTModelVersion.Version1) flags = buffer_read(buffer, buffer_u16); // Unused
		
		// Vertex Count, Offset and Index Offset
		vertexOffset = buffer_read(buffer, buffer_u32);
		vertexCount = buffer_read(buffer, buffer_u32);
		indexOffset = buffer_read(buffer, buffer_u32);
		
		// Vertex / Index Buffer IDs
		indexBufferID = buffer_read(buffer, buffer_u32);
		vertexBufferID = buffer_read(buffer, buffer_u32);
		
		// New Vertex Buffer ID (Transformers)
		if (_model.version == BTModelVersion.Version1) vertexBufferID = buffer_read(buffer, buffer_u32);
		
		// Check File Version Here
		if (_model.version != BTModelVersion.Version1)
		{
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
				
				// Add To Dynamic Buffers List
				dynamicBuffers[i] = dynamicBuffer;
				
				// Seek back to temp offset
				buffer_seek(buffer, buffer_seek_start, tempDynOffset);
			}
		}
			
		// Log
		var dOffset = offset + _model.nu20Offset;
		ConsoleLog($"Mesh {_index}", CONSOLE_MODEL_LOADER_DEBUG, dOffset);
		ConsoleLog($"    Primitive Type:       {type}", CONSOLE_MODEL_LOADER_DEBUG, dOffset);
		ConsoleLog($"    Triangle Count:       {triangleCount}", CONSOLE_MODEL_LOADER_DEBUG, dOffset + 4);
		ConsoleLog($"    Vertex Stride:        {vertexStride}", CONSOLE_MODEL_LOADER_DEBUG, dOffset + 8);
		ConsoleLog($"    Bones:                [{bones[0]}, {bones[1]}, {bones[2]}, {bones[3]}, {bones[4]}, {bones[5]}, {bones[6]}, {bones[7]}]", CONSOLE_MODEL_LOADER_DEBUG, dOffset + 10);
		ConsoleLog($"    Vertex Offset:        {vertexOffset}", CONSOLE_MODEL_LOADER_DEBUG, dOffset + 20);
		ConsoleLog($"    Vertex Count:         {vertexCount}", CONSOLE_MODEL_LOADER_DEBUG, dOffset + 24);
		ConsoleLog($"    Index Offset:         {indexOffset}", CONSOLE_MODEL_LOADER_DEBUG, dOffset + 28);
		ConsoleLog($"    Index Buffer ID:      {indexBufferID}", CONSOLE_MODEL_LOADER_DEBUG, dOffset + 32);
		ConsoleLog($"    Vertex Buffer ID:     {vertexBufferID}", CONSOLE_MODEL_LOADER_DEBUG, dOffset + 36);
		if (_model.version != BTModelVersion.Version1) ConsoleLog($"    Dynamic Buffer Count: {dynamicBufferCount}", CONSOLE_MODEL_LOADER_DEBUG, dOffset + 40);
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
		
		// Only do this if enabled
		if (SETTINGS.rebuildDynamicBuffers)
		{
			// Some Offsets
			var dynamicBufferPointerOffset = offset + 56;
			var dynamicBufferStartOffset = dynamicBufferPointerOffset + array_length(dynamicBuffers) * 4;
			
			// Set all pointers to 0
			for (var i = 0; i < array_length(dynamicBuffers); i++)
			{
				if (array_length(dynamicBuffers[i]) > 0)
				{
					// Write the start pointer to the dynamic buffer
					buffer_poke(buffer, dynamicBufferPointerOffset + i * 4, buffer_s32, dynamicBufferStartOffset - (dynamicBufferPointerOffset + (i * 4)));
					
					// Write dynamic buffer
					for (var j = 0; j < array_length(dynamicBuffers[i]); j++)
					{
						buffer_poke(buffer, dynamicBufferStartOffset, buffer_f32, dynamicBuffers[i][j]);
						dynamicBufferStartOffset += 4;
					}
				}
				else
				{
					// Write 0 because no dynamic buffer data exists
					buffer_poke(buffer, dynamicBufferPointerOffset + i * 4, buffer_s32, 0);
				}
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
			var vertexFormat = _model.materials[material != -1 ? material : 0].vertexFormat;
			
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
		
		// Create Vertex Buffer
		currentVertexBuffer = vertex_create_buffer();
		vertex_begin(currentVertexBuffer, BT_VERTEX_FORMAT);
		
		// Build VBO
		for (var i = 0; i < triangleCount + 2; i++)
		{
			// Get Index
			var index = triangles[i];
			
			// Create Default Values (We do this so we can submit a valid vertex buffer to the GPU)
			var position = array_create(3, 0);
			var normal = array_create(3, 0);
			var tangent = [0, 0];
			var uv1 = array_create(2, 0);
			var uv2 = array_create(2, 0);
			var colour = #ffffff;
			
			// Attributes
			// Position
			if (array_length(vertices[index].position) == 3) position = vertices[index].position;
			vertex_position_3d(currentVertexBuffer, position[0], position[1], position[2]);
			
			// Normal
			if (array_length(vertices[index].normal) == 3) normal = vertices[index].normal;
			vertex_normal(currentVertexBuffer, normal[0], normal[1], normal[2]);
			
			// UV Set 1
			if (array_length(vertices[index].uvSet1) == 2) uv1 = vertices[index].uvSet1;
			vertex_texcoord(currentVertexBuffer, uv1[0], uv1[1]);
			
			// UV Set 2
			if (array_length(vertices[index].uvSet2) == 2) uv2 = vertices[index].uvSet2;
			vertex_texcoord(currentVertexBuffer, uv2[0], uv2[1]);
			
			// Colour
			if (array_length(vertices[index].colourSet1) == 4) colour = make_colour_rgb(vertices[index].colourSet1[0] * 255, vertices[index].colourSet1[1] * 255, vertices[index].colourSet1[2] * 255);
			vertex_colour(currentVertexBuffer, colour, 1);
			
			// Tangent
			if (array_length(vertices[index].tangent) == 4) tangent = [make_colour_rgb(vertices[index].tangent[0] / 2 + 1, vertices[index].tangent[1] / 2 + 1, vertices[index].tangent[2] / 2 + 1), vertices[index].tangent[3]];
			vertex_colour(currentVertexBuffer, tangent[0], tangent[1]);
			
			// Add Index
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
		
		// Convert Strips to Lists
		var listTriangles = stripsToTris(triangles);
		
		// UV Set 1
		uvSet1 = vertex_create_buffer();
		vertex_begin(uvSet1, BT_WIREFRAME_VERTEX_FORMAT);
		
		for (var i = 0; i < array_length(listTriangles); i++)
		{
			var vert1 = vertices[listTriangles[i][0]].uvSet1;
			var vert2 = vertices[listTriangles[i][1]].uvSet1;
			var vert3 = vertices[listTriangles[i][2]].uvSet1;
			vertex_position_3d(uvSet1, vert1[0], vert1[1], 0);
			vertex_position_3d(uvSet1, vert2[0], vert2[1], 0);
			vertex_position_3d(uvSet1, vert2[0], vert2[1], 0);
			vertex_position_3d(uvSet1, vert3[0], vert3[1], 0);
			vertex_position_3d(uvSet1, vert3[0], vert3[1], 0);
			vertex_position_3d(uvSet1, vert1[0], vert1[1], 0);
			
			uvSet1AveragePosition[0] += vert1[0] + vert2[0] + vert3[0];
			uvSet1AveragePosition[1] += vert1[1] + vert2[1] + vert3[1];
		}
		
		vertex_end(uvSet1);
		
		// Average Position
		uvSet1AveragePosition[0] /= array_length(listTriangles) * 6;
		uvSet1AveragePosition[1] /= array_length(listTriangles) * 6;
		
		// UV Set 2
		uvSet2 = vertex_create_buffer();
		vertex_begin(uvSet2, BT_WIREFRAME_VERTEX_FORMAT);
		
		for (var i = 0; i < array_length(listTriangles); i++)
		{
			var vert1 = vertices[listTriangles[i][0]].uvSet2;
			var vert2 = vertices[listTriangles[i][1]].uvSet2;
			var vert3 = vertices[listTriangles[i][2]].uvSet2;
			vertex_position_3d(uvSet2, vert1[0], vert1[1], 0);
			vertex_position_3d(uvSet2, vert2[0], vert2[1], 0);
			vertex_position_3d(uvSet2, vert2[0], vert2[1], 0);
			vertex_position_3d(uvSet2, vert3[0], vert3[1], 0);
			vertex_position_3d(uvSet2, vert3[0], vert3[1], 0);
			vertex_position_3d(uvSet2, vert1[0], vert1[1], 0);
			
			uvSet1AveragePosition[0] += vert1[0] + vert2[0] + vert3[0];
			uvSet1AveragePosition[1] += vert1[1] + vert2[1] + vert3[1];
		}
		
		vertex_end(uvSet2);
		
		// Average Position
		uvSet1AveragePosition[0] /= array_length(listTriangles) * 6;
		uvSet1AveragePosition[1] /= array_length(listTriangles) * 6;
		
		// Freeze VBO For Better Performance
		vertex_freeze(uvSet1);
		vertex_freeze(uvSet2);
		vertex_freeze(currentVertexBuffer);
		vertexBufferObject = currentVertexBuffer;
	}
	
	static buildVertexBuffer = function(_model = noone)
	{
		// Get Vertex Format
		var vertexFormat = _model.materials[material != -1 ? material : 0].vertexFormat;
		
		// Evaluate Vertex Stride
		vertexStride = array_last(vertexFormat).position + BT_VERTEX_ATTRIBUTE_SIZES[array_last(vertexFormat).type];
		
		// Create Vertex Buffer
		var vertexBuffer = buffer_create(vertexCount * vertexStride, buffer_fixed, 1);
		
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
						//show_debug_message("Writing Position")
						break;
					case BTVertexAttributes.normal:
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position, buffer_u8, floor(((vertices[i].normal[0] + 1) / 2) * 255));
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 1, buffer_u8, floor(((vertices[i].normal[1] + 1) / 2) * 255));
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 2, buffer_u8, floor(((vertices[i].normal[2] + 1) / 2) * 255));
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 3, buffer_u8, 0x7f);
						//show_debug_message("Writing Normal")
						break;
					case BTVertexAttributes.tangent:
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position, buffer_u8, floor(((vertices[i].tangent[0] + 1) / 2) * 255));
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 1, buffer_u8, floor(((vertices[i].tangent[1] + 1) / 2) * 255));
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 2, buffer_u8, floor(((vertices[i].tangent[2] + 1) / 2) * 255));
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 3, buffer_u8, floor(((vertices[i].tangent[3] + 1) / 2) * 255));
						//show_debug_message("Writing Tangent")
						break;
					case BTVertexAttributes.bitangent:
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position, buffer_u8, floor(((vertices[i].bitangent[0] + 1) / 2) * 255));
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 1, buffer_u8, floor(((vertices[i].bitangent[1] + 1) / 2) * 255));
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 2, buffer_u8, floor(((vertices[i].bitangent[2] + 1) / 2) * 255));
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 3, buffer_u8, floor(((vertices[i].bitangent[3] + 1) / 2) * 255));
						//show_debug_message("Writing BiTangent")
						break;
					case BTVertexAttributes.colourSet1:
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position, buffer_u8, floor(vertices[i].colourSet1[0] * 255));
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 1, buffer_u8, floor(vertices[i].colourSet1[1] * 255));
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 2, buffer_u8, floor(vertices[i].colourSet1[2] * 255));
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 3, buffer_u8, floor(vertices[i].colourSet1[3] * 255));
						//show_debug_message("Writing ColourSet1")
						break;
					case BTVertexAttributes.colourSet2:
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position, buffer_u8, floor(vertices[i].colourSet2[0] * 255));
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 1, buffer_u8, floor(vertices[i].colourSet2[1] * 255));
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 2, buffer_u8, floor(vertices[i].colourSet2[2] * 255));
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 3, buffer_u8, floor(vertices[i].colourSet2[3] * 255));
						//show_debug_message("Writing ColourSet2")
						break;
					case BTVertexAttributes.uvSet1:
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position, buffer_f32, vertices[i].uvSet1[0]);
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 4, buffer_f32, vertices[i].uvSet1[1]);
						//show_debug_message("Writing UVSet1")
						break;
					case BTVertexAttributes.uvSet2:
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position, buffer_f32, vertices[i].uvSet2[0]);
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 4, buffer_f32, vertices[i].uvSet2[1]);
						//show_debug_message("Writing UVSet2")
						break;
					case BTVertexAttributes.uvSet3:
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position, buffer_f32, vertices[i].uvSet3[0]);
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 4, buffer_f32, vertices[i].uvSet3[1]);
						//show_debug_message("Writing UVSet3")
						break;
					case BTVertexAttributes.uvSet4:
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position, buffer_f32, vertices[i].uvSet4[0]);
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 4, buffer_f32, vertices[i].uvSet4[1]);
						//show_debug_message("Writing UVSet4")
						break;
					case BTVertexAttributes.blendIndices:
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position, buffer_s8, floor(vertices[i].blendIndices[0]));
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 1, buffer_s8, floor(vertices[i].blendIndices[1]));
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 2, buffer_s8, floor(vertices[i].blendIndices[2]));
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 3, buffer_s8, floor(vertices[i].blendIndices[3]));
						//show_debug_message("Writing BlendIndices")
						break;
					case BTVertexAttributes.blendWeights:
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position, buffer_u8, floor(vertices[i].blendWeights[0] * 255));
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 1, buffer_u8, floor(vertices[i].blendWeights[1] * 255));
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 2, buffer_u8, floor(vertices[i].blendWeights[2] * 255));
						buffer_poke(vertexBuffer, (vertexStride * i) + vertexFormat[k].position + 3, buffer_u8, floor(vertices[i].blendWeights[3] * 255));
						//show_debug_message("Writing BlendWeights")
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
	
	static serialize = function(buffer, _model)
	{
		var bmesh = new BactaTankBMesh();
		bmesh.fromMesh(self, _model);
		bmesh.serialize(buffer, _model);
	}
	
	#endregion
	
	#region Export / Replace
	
	/// @func export()
	/// @desc Export v0.4 BactaTankMesh
	static export = function(filepath, _model = noone)
	{
		var bmesh = new BactaTankBMesh();
		bmesh.fromMesh(self, _model);
		bmesh.export(filepath, _model);
		
		// Change Last Filename
		lastFilename = filepath;
	}
	
	/// @func replace()
	/// @desc Replace BactaTankMesh
	static replace = function(filepath, _model = noone)
	{
		// Load .bmesh
		var bmesh = new BactaTankBMesh();
		bmesh.import(filepath, _model);
		
		// Validation
		if (array_length(bmesh.dynamicBuffers) != array_length(dynamicBuffers))
		{
			ENVIRONMENT.openConfirmModal("Warning!", "You are trying to replace a mesh that has a mismatch in dynamic buffer count, which may produce unexpected results. Do you want to continue?", function(bmesh, mesh, _model)
			{
				// Set Mesh
				bmesh.toMesh(mesh, _model);
		
				// Collect Garbage (Because we've derefereced an older mesh here, I need to use this more!)
				gc_collect();
		
				// Build Mesh
				mesh.build(_model);	
			}, [bmesh, self, _model]);
		}
		else if (array_length(bmesh.dynamicBuffers) == array_length(dynamicBuffers) && array_length(bmesh.dynamicBuffers) != 0)
		{
			if (array_length(vertices) < array_length(bmesh.vertices))
			{
				ENVIRONMENT.openConfirmModal("Warning!", "You are trying to replace a mesh with dynamic buffers that has more vertices, which may produce unexpected results. Do you want to continue?", function(bmesh, mesh, _model)
				{
					// Set Mesh
					bmesh.toMesh(mesh, _model);
		
					// Collect Garbage (Because we've derefereced an older mesh here, I need to use this more!)
					gc_collect();
		
					// Build Mesh
					mesh.build(_model);	
				}, [bmesh, self, _model]);
			}
			else
			{
				// Set Mesh
				bmesh.toMesh(self, _model);
				
				// Collect Garbage (Because we've derefereced an older mesh here, I need to use this more!)
				gc_collect();
				
				// Build Mesh
				build(_model);
			}
		}
		else
		{
			// Set Mesh
			bmesh.toMesh(self, _model);
		
			// Collect Garbage (Because we've derefereced an older mesh here, I need to use this more!)
			gc_collect();
		
			// Build Mesh
			build(_model);
		}
		
		// Change Last Filename
		lastFilename = filepath;
	}
	
	/// @func reload()
	/// @desc Reloads last texture if the file exists
	static reload = function(_model = noone)
	{
		if (file_exists(lastFilename))
		{
			// User Feedback
			ENVIRONMENT.openInfoModal("Please wait", "Building Mesh");
			window_set_cursor(cr_hourglass);
			
			// Define Function
			var func = function(mesh, file, _model)
			{
				// Replace Mesh
				mesh.replace(file, _model);
				
				// Set Last Mesh Path
				SETTINGS.lastMeshPath = filename_path(file);
				
				// Enable Renderer
				RENDERER.activate();
				RENDERER.deactivate(2);
				
				// User Feedback
				ENVIRONMENT.closeInfoModal();
				window_set_cursor(cr_default);
			}
			
			// Timesource
			time_source_start(time_source_create(time_source_game, 3, time_source_units_frames, func, [self, lastFilename, _model]));
		}
	}
	
	#endregion
	
	/// @func dereference()
	/// @desc Dereferences a mesh, and removes it from the model
	static dereference = function()
	{
		// Destroy Vertex Buffer
		if (vertexBufferObject != -1) vertex_delete_buffer(vertexBufferObject);
		vertexBufferObject = -1;
		if (uvSet1 != -1) vertex_delete_buffer(uvSet1);
		uvSet1 = -1;
		if (uvSet2 != -1) vertex_delete_buffer(uvSet2);
		uvSet2 = -1;
		
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
	
	/// @func generateStaticSkinning()
	/// @desc Generates skinning for one bone
	static generateStaticSkinning = function()
	{
		// Change Bones
		bones = [0, -1, -1, -1, -1, -1, -1, -1];
		
		// Loop Through All Vertices
		for (var i = 0; i < array_length(vertices); i++)
		{
			// Replace With Static Skinning
			vertices[i].blendIndices = [0, -1, -1, -1];
			vertices[i].blendWeights = [1, 1, 1, 1];
		}
	}

	#region Rendering
	
	static pushToRenderQueue = function(renderQueue = RENDERER.renderQueue)
	{
		
	}
	
	#endregion
}