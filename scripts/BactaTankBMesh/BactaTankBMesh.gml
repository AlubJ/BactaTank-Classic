/*
	BactaTankBMesh
	-------------------------------------------------------------------------
	Script:			BactaTankBMesh
	Version:		v1.00
	Created:		19/02/2025 by Alun Jones
	Description:	BactaTank BMesh File Format Constructor
	-------------------------------------------------------------------------
	History:
	 - Created 19/02/2025 by Alun Jones
	
	To Do:
	
*/

function BactaTankBMesh() constructor
{
	vertices = [  ];
	triangles = [  ];
	bones = [  ];
	dynamicBuffers = [  ];
	vertexCount = 0;
	triangleCount = 0;
	material = 0;
	vertexFormat = [  ];
	
	#region Some Functions
	
	static fromMesh = function(mesh, _model = noone)
	{
		// Set Values
		vertices = variable_clone(mesh.vertices);
		triangles = variable_clone(mesh.triangles);
		bones = variable_clone(mesh.bones);
		dynamicBuffers = variable_clone(mesh.dynamicBuffers);
		vertexCount = variable_clone(mesh.vertexCount);
		triangleCount = variable_clone(mesh.triangleCount);
		material = variable_clone(mesh.material);
		vertexFormat = variable_clone(_model.materials[material].vertexFormat);
	}
	
	static toMesh = function(mesh, _model = noone)
	{
		// Set Values
		mesh.vertices = vertices;
		mesh.triangles = triangles;
		mesh.bones = bones;
		mesh.dynamicBuffers = dynamicBuffers;
		mesh.vertexCount = vertexCount;
		mesh.triangleCount = triangleCount;
	}
	
	static evaluateVertexAttributes = function()
	{
		var attributes = [  ];
		for (var i = 0; i < array_length(vertexFormat); i++)
		{
			switch(vertexFormat[i].attribute)
			{
				case BTVertexAttributes.position:
					array_push(attributes, "Position");
					break;
				case BTVertexAttributes.normal:
					array_push(attributes, "Normal");
					break;
				case BTVertexAttributes.colourSet1:
					array_push(attributes, "ColourSet1");
					break;
				case BTVertexAttributes.colourSet2:
					array_push(attributes, "ColourSet2");
					break;
				case BTVertexAttributes.uvSet1:
					array_push(attributes, "UVSet1");
					break;
				case BTVertexAttributes.uvSet2:
					array_push(attributes, "UVSet2");
					break;
				case BTVertexAttributes.blendIndices:
					array_push(attributes, "BlendIndices");
					break;
				case BTVertexAttributes.blendWeights:
					array_push(attributes, "BlendWeights");
					break;
			}
		}
		
		return attributes;
	}
	
	#endregion
	
	#region Export BMesh
	
	static export = function(filepath, _model = noone)
	{
		// Create Export Buffer
		var buffer = buffer_create(1, buffer_grow, 1);
		
		// Write Header
		writeHeader(buffer, _model);
		
		// Write Bones
		writeBones(buffer, _model);
		
		// Write Mesh
		writeMesh(buffer, _model);
		
		// Buffer Save
		buffer_save(buffer, filepath);
		buffer_delete(buffer);
	}
	
	static import = function(filepath, _model = noone)
	{
		// Load Mesh File
		var buffer = buffer_load(filepath);
		
		// Read Header
		var version = readHeader(buffer, _model);
		if (version == 0.4) 
		{
			// Read Bones
			buffer_read(buffer, buffer_string) // Bones
			readBones(buffer, _model);
		
			// Read Mesh
			buffer_read(buffer, buffer_string);
			readMesh(buffer, _model);
		}
		else
		{
			// Read 0.3
			readV03(buffer, _model);
		}
		
		// Delete Mesh Buffer
		buffer_delete(buffer);
	}
	
	#endregion
	
	#region Write Functions
	
	static writeHeader = function(buffer)
	{
		// Write Header
		buffer_write(buffer, buffer_string, "BactaTankMesh");
		buffer_write(buffer, buffer_string, "PCGHG");
		buffer_write(buffer, buffer_f32, 0.4);
	}
	
	static writeBones = function(buffer, _model = noone)
	{
		// Bones
		buffer_write(buffer, buffer_string, "Bones");
		
		// If no model is defined, don't write any bones
		if (_model != noone || _model.type == BTModelType.scene)
		{
			// Bone Count
			buffer_write(buffer, buffer_u32, array_length(_model.bones));
			
			// Write Bone Names
			for (var i = 0; i < array_length(_model.bones); i++)
			{
				var bone = _model.bones[i];
				buffer_write(buffer, buffer_string, bone.name);
			}
		}
		else buffer_write(buffer, buffer_s32, 0);
	}
	
	static writeMesh = function(buffer, _model = noone)
	{
		// Evaluate Vertex Attributes
		var attributes = evaluateVertexAttributes();
		
		// Mesh Data
		buffer_write(buffer, buffer_string, "Mesh");
		
		// Write Mesh Data
		buffer_write(buffer, buffer_u32, vertexCount);
		buffer_write(buffer, buffer_u32, triangleCount);
		for (var i = 0; i < 8; i++) buffer_write(buffer, buffer_s8, bones[i]);
		
		// Write Mesh Attributes
		buffer_write(buffer, buffer_string, "MeshAttributes");
		buffer_write(buffer, buffer_u32, array_length(attributes));
		for (var i = 0; i < array_length(attributes); i++) buffer_write(buffer, buffer_string, attributes[i]);
		
		// Write Vertex Buffer
		buffer_write(buffer, buffer_string, "Vertices");
	
		// Write Positions
		if (array_contains(attributes, "Position"))
		{
			buffer_write(buffer, buffer_string, "Position");
			for (var i = 0; i < vertexCount; i++)
			{
				if (array_length(vertices[i].position) == 3)
				{
					buffer_write(buffer, buffer_f32, vertices[i].position[0]);
					buffer_write(buffer, buffer_f32, vertices[i].position[1]);
					buffer_write(buffer, buffer_f32, vertices[i].position[2]);
				}
				else 
				{
					buffer_write(buffer, buffer_f32, 0);
					buffer_write(buffer, buffer_f32, 0);
					buffer_write(buffer, buffer_f32, 0);
				}
			}
		}
		
		// Write Normals
		if (array_contains(attributes, "Normal"))
		{
			buffer_write(buffer, buffer_string, "Normal");
			for (var i = 0; i < vertexCount; i++)
			{
				if (array_length(vertices[i].normal) == 3)
				{
					buffer_write(buffer, buffer_u8, floor(((vertices[i].normal[0] + 1) / 2) * 255));
					buffer_write(buffer, buffer_u8, floor(((vertices[i].normal[1] + 1) / 2) * 255));
					buffer_write(buffer, buffer_u8, floor(((vertices[i].normal[2] + 1) / 2) * 255));
					buffer_write(buffer, buffer_u8, 0x7f);
				}
				else buffer_write(buffer, buffer_s32, -1);
			}
		}
		
		// Write Colour Set 1
		if (array_contains(attributes, "ColourSet1"))
		{
			buffer_write(buffer, buffer_string, "ColourSet1");
			for (var i = 0; i < vertexCount; i++)
			{
				if (array_length(vertices[i].colourSet1) == 4)
				{
					buffer_write(buffer, buffer_u8, floor(vertices[i].colourSet1[0] * 255));
					buffer_write(buffer, buffer_u8, floor(vertices[i].colourSet1[1] * 255));
					buffer_write(buffer, buffer_u8, floor(vertices[i].colourSet1[2] * 255));
					buffer_write(buffer, buffer_u8, floor(vertices[i].colourSet1[3] * 255));
				}
				else buffer_write(buffer, buffer_s32, -1);
			}
		}
		
		// Write Colour Set 2
		if (array_contains(attributes, "ColourSet2"))
		{
			buffer_write(buffer, buffer_string, "ColourSet2");
			for (var i = 0; i < vertexCount; i++)
			{
				if (array_length(vertices[i].colourSet2) == 4)
				{
					buffer_write(buffer, buffer_u8, floor(vertices[i].colourSet2[0] * 255));
					buffer_write(buffer, buffer_u8, floor(vertices[i].colourSet2[1] * 255));
					buffer_write(buffer, buffer_u8, floor(vertices[i].colourSet2[2] * 255));
					buffer_write(buffer, buffer_u8, floor(vertices[i].colourSet2[3] * 255));
				}
				else buffer_write(buffer, buffer_s32, -1);
			}
		}
		
		// Write UVSet1
		if (array_contains(attributes, "UVSet1"))
		{
			buffer_write(buffer, buffer_string, "UVSet1");
			for (var i = 0; i < vertexCount; i++)
			{
				if (array_length(vertices[i].uvSet1) == 2)
				{
					buffer_write(buffer, buffer_f32, vertices[i].uvSet1[0]);
					buffer_write(buffer, buffer_f32, vertices[i].uvSet1[1]);
				}
				else buffer_write(buffer, buffer_u64, 0x00);
			}
		}
		
		// Write UVSet1
		if (array_contains(attributes, "UVSet2"))
		{
			buffer_write(buffer, buffer_string, "UVSet2");
			for (var i = 0; i < vertexCount; i++)
			{
				if (array_length(vertices[i].uvSet2) == 2)
				{
					buffer_write(buffer, buffer_f32, vertices[i].uvSet2[0]);
					buffer_write(buffer, buffer_f32, vertices[i].uvSet2[1]);
				}
				else buffer_write(buffer, buffer_u64, 0x00);
			}
		}
		
		// Write Blend Indices
		if (array_contains(attributes, "BlendIndices"))
		{
			buffer_write(buffer, buffer_string, "BlendIndices");
			for (var i = 0; i < vertexCount; i++)
			{
				if (array_length(vertices[i].blendIndices) == 4)
				{
					buffer_write(buffer, buffer_s8, floor(vertices[i].blendIndices[0]));
					buffer_write(buffer, buffer_s8, floor(vertices[i].blendIndices[1]));
					buffer_write(buffer, buffer_s8, floor(vertices[i].blendIndices[2]));
					buffer_write(buffer, buffer_s8, floor(vertices[i].blendIndices[3]));
				}
				else buffer_write(buffer, buffer_s32, -1);
			}
		}
		
		// Write Blend Weights
		if (array_contains(attributes, "BlendWeights"))
		{
			buffer_write(buffer, buffer_string, "BlendWeights");
			for (var i = 0; i < vertexCount; i++)
			{
				if (array_length(vertices[i].blendWeights) == 4)
				{
					buffer_write(buffer, buffer_u8, floor(vertices[i].blendWeights[0] * 255));
					buffer_write(buffer, buffer_u8, floor(vertices[i].blendWeights[1] * 255));
					buffer_write(buffer, buffer_u8, floor(vertices[i].blendWeights[2] * 255));
					buffer_write(buffer, buffer_u8, floor(vertices[i].blendWeights[3] * 255));
				}
				else buffer_write(buffer, buffer_s32, -1);
			}
		}
		
		// Write Index Buffer Header
		buffer_write(buffer, buffer_string, "Triangles");
		
		// Write Index Buffer
		for (var i = 0; i < array_length(triangles); i++) buffer_write(buffer, buffer_u16, triangles[i]);
		
		// Dynamic Buffers
		buffer_write(buffer, buffer_string, "DynamicBuffers");
		
		// Dynamic Buffer Count
		buffer_write(buffer, buffer_u32, array_length(dynamicBuffers));
		
		// Write Dynamic Buffer
		for (var i = 0; i < array_length(dynamicBuffers); i++)
		{
			if (array_length(dynamicBuffers[i]) > 0)
			{
				for (var j = 0; j < array_length(dynamicBuffers[i]); j++)
				{
					buffer_write(buffer, buffer_f32, dynamicBuffers[i][j])
				}
			}
			else
			{
				for (var j = 0; j < vertexCount * 3; j++)
				{
					buffer_write(buffer, buffer_f32, 0);
				}
			}
		}
	}
	
	#endregion
	
	#region Read Functions
	
	static readHeader = function(buffer, _model)
	{
		// Read Mesh File
		buffer_read(buffer, buffer_string);					// BactaTankMesh
		buffer_read(buffer, buffer_string);					// PCGHG
		
		// Validate Version (If its not 0.4, attempt to load a v0.3 mesh instead)
		var version = buffer_read(buffer, buffer_f32);		// 0.4
		
		// Return The Version Out
		return version;
	}
	
	static readBones = function(buffer, _model)
	{
		// Read Bones
		var boneCount = buffer_read(buffer, buffer_s32);
		repeat (boneCount) buffer_read(buffer, buffer_string); // Read Bone names (and ignore since we only need them for Blender)
	}
	
	static readMesh = function(buffer, _model)
	{
		// Triangle Count and Vertex Count
		vertexCount = buffer_read(buffer, buffer_u32);
		triangleCount = buffer_read(buffer, buffer_u32);
		
		// Bone Links
		bones = [];
		repeat(8) array_push(bones, buffer_read(buffer, buffer_s8));
		
		// Verify The Bones Exist
		for (var i = 0; i < 8; i++)
		{
			if (bones[i] >= array_length(_model.bones)) bones[i] = 0;
		}
		
		// Reset Vertices and Triangles Array
		vertices = [];
		triangles = [];
		
		// Mesh Attributes
		var attributes = [  ];
		buffer_read(buffer, buffer_string);	// Mesh Attributes
		var attributeCount = buffer_read(buffer, buffer_s32);
		repeat (attributeCount) array_push(attributes, buffer_read(buffer, buffer_string)); // Position, Normal, Colour, UV
		
		// Vertices
		buffer_read(buffer, buffer_string);
		
		// Preset Values
		for (var i = 0; i < vertexCount; i++)
		{
			// Set Vertex
			vertices[i] = {
				position : [0, 0, 0],
				normal: [0, 0, 0],
				tangent: [0, 0, 0, 0],
				bitangent: [0, 0, 0, 0],
				colourSet1: [.5, .5, .5, .5],
				colourSet2: [.5, .5, .5, .5],
				uvSet1: [0, 0],
				uvSet2: [0, 0],
				blendIndices: [0, 0, 0, 0],
				blendWeights: [0, 0, 0, 0],
				lightDirection: [],
			};
		}
		
		// Position Attribute
		if (array_contains(attributes, "Position"))
		{
			buffer_read(buffer, buffer_string);
			for (var i = 0; i < vertexCount; i++)
			{
				// Read Vertex Position
				var positionX = buffer_read(buffer, buffer_f32);
				var positionY = buffer_read(buffer, buffer_f32);
				var positionZ = buffer_read(buffer, buffer_f32);
			
				// Set Vertex Position
				vertices[i].position = [positionX, positionY, positionZ];
			}
		}
		
		ConsoleLog(vertices[0].position);
		
		// Normal Attribute
		if (array_contains(attributes, "Normal"))
		{
			buffer_read(buffer, buffer_string);
			for (var i = 0; i < vertexCount; i++)
			{
				// Read Vertex Normals
				var normalX = ((buffer_read(buffer, buffer_u8) / 255) * 2) - 1;
				var normalY = ((buffer_read(buffer, buffer_u8) / 255) * 2) - 1;
				var normalZ = ((buffer_read(buffer, buffer_u8) / 255) * 2) - 1;
				var normalW = buffer_read(buffer, buffer_u8);
			
				// Set Vertex Normal
				vertices[i].normal = [normalX, normalY, normalZ];
			}
		}
		
		// ColourSet1 Attribute
		if (array_contains(attributes, "ColourSet1"))
		{
			buffer_read(buffer, buffer_string);
			for (var i = 0; i < vertexCount; i++)
			{
				// Read Vertex Colour
				var colourR = buffer_read(buffer, buffer_u8) / 255;
				var colourG = buffer_read(buffer, buffer_u8) / 255;
				var colourB = buffer_read(buffer, buffer_u8) / 255;
				var colourA = buffer_read(buffer, buffer_u8) / 255;
			
				// Set Vertex Colour
				vertices[i].colourSet1 = [colourR, colourG, colourB, colourA];
			}
		}
		
		// ColourSet2 Attribute
		if (array_contains(attributes, "ColourSet2"))
		{
			buffer_read(buffer, buffer_string);
			for (var i = 0; i < vertexCount; i++)
			{
				// Read Vertex Colour
				var colourR = buffer_read(buffer, buffer_u8) / 255;
				var colourG = buffer_read(buffer, buffer_u8) / 255;
				var colourB = buffer_read(buffer, buffer_u8) / 255;
				var colourA = buffer_read(buffer, buffer_u8) / 255;
			
				// Set Vertex Colour
				vertices[i].colourSet2 = [colourR, colourG, colourB, colourA];
			}
		}
		
		// UVSet1 Attribute
		if (array_contains(attributes, "UVSet1"))
		{
			buffer_read(buffer, buffer_string);
			for (var i = 0; i < vertexCount; i++)
			{
				// Read Vertex UVs
				var uvX = buffer_read(buffer, buffer_f32);
				var uvY = buffer_read(buffer, buffer_f32);
			
				// Set Vertex UVs
				vertices[i].uvSet1 = [uvX, uvY];
			}
		}
		
		// UVSet2 Attribute
		if (array_contains(attributes, "UVSet2"))
		{
			buffer_read(buffer, buffer_string);
			for (var i = 0; i < vertexCount; i++)
			{
				// Read Vertex UVs
				var uvX = buffer_read(buffer, buffer_f32);
				var uvY = buffer_read(buffer, buffer_f32);
			
				// Set Vertex UVs
				vertices[i].uvSet2 = [uvX, uvY];
			}
		}
		
		// Blend Indices Attribute
		if (array_contains(attributes, "BlendIndices"))
		{
			buffer_read(buffer, buffer_string);
			for (var i = 0; i < vertexCount; i++)
			{
				// Read Blend Indices
				var blendX = buffer_read(buffer, buffer_s8);
				var blendY = buffer_read(buffer, buffer_s8);
				var blendZ = buffer_read(buffer, buffer_s8);
				var blendW = buffer_read(buffer, buffer_s8);
				
				// Set Blend Indices
				vertices[i].blendIndices = [blendX, blendY, blendZ, blendW];
			}
		}
		
		// Blend Weights Attribute
		if (array_contains(attributes, "BlendWeights"))
		{
			buffer_read(buffer, buffer_string);
			for (var i = 0; i < vertexCount; i++)
			{
				// Read Blend Weights
				var blendX = buffer_read(buffer, buffer_u8) / 255;
				var blendY = buffer_read(buffer, buffer_u8) / 255;
				var blendZ = buffer_read(buffer, buffer_u8) / 255;
				var blendW = buffer_read(buffer, buffer_u8) / 255;
				
				// Set Blend Weights
				vertices[i].blendWeights = [blendX, blendY, blendZ, blendW];
			}
		}
		
		// Triangles
		buffer_read(buffer, buffer_string);
		
		// Triangle Loop
		for (var i = 0; i < (triangleCount + 2); i++) triangles[i] = buffer_read(buffer, buffer_u16);
		
		// DynamicBuffers
		buffer_read(buffer, buffer_string);
		
		// Delete Dynamic Buffers (Add extra check here if Dynamic Buffers want to be replaced)
		dynamicBuffers = [];
		
		// Dynamic Buffer Count
		var dynamicBufferCount = buffer_read(buffer, buffer_u32);
		
		// Write Dynamic Buffer
		for (var i = 0; i < dynamicBufferCount; i++)
		{
			// Create Array
			dynamicBuffers[i] = [];
			
			// Read Position Data
			repeat (vertexCount)
			{
				array_push(dynamicBuffers[i], buffer_read(buffer, buffer_f32));
			}
			
			// Value Checker (Sometimes dynamic buffers aren't stored in the GHG so these are just put into the bmesh file as all zeros)
			var dynamicBufferContainsValue = array_any(dynamicBuffers[i], function(_val, _ind) { return _val != 0; });
			
			// Check
			if (!dynamicBufferContainsValue) dynamicBuffers[i] = [];
		}
	}
	
	static readV03 = function(buffer, _model)
	{
		buffer_read(buffer, buffer_string);					// Materials
		buffer_read(buffer, buffer_u32);					// 0
		buffer_read(buffer, buffer_string);					// Bones
		buffer_read(buffer, buffer_u32);					// 0
		buffer_read(buffer, buffer_string);					// Meshes
		buffer_read(buffer, buffer_u32);					// 1
		buffer_read(buffer, buffer_string);					// MeshData
		
		// Mesh Data
		triangleCount = buffer_read(buffer, buffer_u32);
		vertexCount = buffer_read(buffer, buffer_u32);
		bones = [];
		repeat(8) array_push(bones, buffer_read(buffer, buffer_s8));
		
		// Verify The Bones Exist
		for (var i = 0; i < 8; i++)
		{
			if (bones[i] >= array_length(_model.bones)) bones[i] = 0;
		}
		
		// Reset Vertices and Triangles Array
		vertices = [];
		triangles = [];
		
		// Mesh Attributes
		buffer_read(buffer, buffer_string);	// Mesh Attributes
		var attributeCount = buffer_read(buffer, buffer_u32);
		repeat (attributeCount) buffer_read(buffer, buffer_string); // Position, Normal, Colour, UV
		
		// Vertex Buffer
		buffer_read(buffer, buffer_string);
		
		// Position Attribute
		buffer_read(buffer, buffer_string);
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
				blendIndices: [0, 0, 0, 0],
				blendWeights: [0, 0, 0, 0],
				lightDirection: [],
			};
			
			// Read Vertex Position
			var positionX = buffer_read(buffer, buffer_f32);
			var positionY = buffer_read(buffer, buffer_f32);
			var positionZ = buffer_read(buffer, buffer_f32);
			
			// Set Vertex Position
			vertices[i].position = [positionX, positionY, positionZ];
		}
		
		// Normal Attribute
		buffer_read(buffer, buffer_string);
		for (var i = 0; i < vertexCount; i++)
		{
			// Read Vertex Normals
			var normalX = ((buffer_read(buffer, buffer_u8) / 255) * 2) - 1;
			var normalY = ((buffer_read(buffer, buffer_u8) / 255) * 2) - 1;
			var normalZ = ((buffer_read(buffer, buffer_u8) / 255) * 2) - 1;
			var normalW = buffer_read(buffer, buffer_u8);
			
			// Set Vertex Normal
			vertices[i].normal = [normalX, normalY, normalZ];
		}
		
		// Colour Attribute
		buffer_read(buffer, buffer_string);
		for (var i = 0; i < vertexCount; i++)
		{
			// Read Vertex Colour
			var colourR = buffer_read(buffer, buffer_u8) / 255;
			var colourG = buffer_read(buffer, buffer_u8) / 255;
			var colourB = buffer_read(buffer, buffer_u8) / 255;
			var colourA = buffer_read(buffer, buffer_u8) / 255;
			
			// Set Vertex Colour
			vertices[i].colourSet1 = [colourR, colourG, colourB, colourA];
		}
		
		// UV Attribute
		buffer_read(buffer, buffer_string);
		for (var i = 0; i < vertexCount; i++)
		{
			// Read Vertex UVs
			var uvX = buffer_read(buffer, buffer_f32);
			var uvY = buffer_read(buffer, buffer_f32);
			
			// Set Vertex UVs
			vertices[i].uvSet1 = [uvX, uvY];
		}
		
		if (attributeCount > 4)
		{
			// Blend Indices Attribute
			buffer_read(buffer, buffer_string);
			for (var i = 0; i < vertexCount; i++)
			{
				// Read Blend Indices
				var blendX = buffer_read(buffer, buffer_s8);
				var blendY = buffer_read(buffer, buffer_s8);
				var blendZ = buffer_read(buffer, buffer_s8);
				var blendW = buffer_read(buffer, buffer_s8);
				
				// Set Blend Indices
				vertices[i].blendIndices = [blendX, blendY, blendZ, blendW];
			}
			
			// Blend Weights Attribute
			buffer_read(buffer, buffer_string);
			for (var i = 0; i < vertexCount; i++)
			{
				// Read Blend Weights
				var blendX = buffer_read(buffer, buffer_u8) / 255;
				var blendY = buffer_read(buffer, buffer_u8) / 255;
				var blendZ = buffer_read(buffer, buffer_u8) / 255;
				var blendW = buffer_read(buffer, buffer_u8) / 255;
				
				// Set Blend Weights
				vertices[i].blendWeights = [blendX, blendY, blendZ, blendW];
			}
		}
		
		// Index Buffer Header
		buffer_read(buffer, buffer_string);
		var newIndexBufferSize = buffer_read(buffer, buffer_u32);
		
		// Triangle Loop
		for (var i = 0; i < (triangleCount + 2); i++) triangles[i] = buffer_read(buffer, buffer_s16);
	}
	
	#endregion
}