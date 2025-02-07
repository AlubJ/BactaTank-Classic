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
	
	// Dynamic Buffers
	dynamicBuffers = [  ];
	
	// Renderer
	vertexBufferObject = noone;
	dynamicBufferObjects = noone;
	
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
	
	#endregion
	
	#region Serialize / Deserialize
	
	
	
	#endregion
}