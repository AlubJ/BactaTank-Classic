/*
	BactaTankMaterial
	-------------------------------------------------------------------------
	Script:			BactaTankMaterial
	Version:		v1.00
	Created:		04/02/2025 by Alun Jones
	Description:	Material Loader and Container
	-------------------------------------------------------------------------
	History:
	 - Created 04/02/2025 by Alun Jones
	
	To Do:
*/

function BactaTankMaterial() constructor
{
	// Colour
	colour				= [1, 1, 1, 1];
	ambientTint			= [0, 0, 0, 0];
	
	// Textures
	textureID			= -1;
	specularID			= -1;
	normalID			= -1;
	cubemapID			= -1;
	shineID				= -1;
	
	// Renderer Variables
	reflectionPower		= 0.5;
	specularExponent	= 25;
	fresnelMuliplier	= 0;
	fresnelCoeff		= 0;
	
	// Bit Fields
	vertexFormatFlags	= 0;
	textureFlags		= 0;
	shaderFlags			= 0;
	inputFlags			= 0;
	alphaBlend			= 0;
	
	// Other
	offset				= 0;
	vertexFormat		= [  ];
	
	#region Parse / Inject
	
	static parse = function(buffer, _model)
	{
		// Get Offset
		offset = buffer_tell(buffer) - _model.nu20Offset;
		
		// Read Material Things
		// var materialIndex	= buffer_peek(buffer, buffer_tell(buffer) + 0x38, buffer_u32);
		
		// Alpha Blend
		alphaBlend			= buffer_peek(buffer, buffer_tell(buffer) + 0x40, buffer_u32);
		
		// Blend Colour
		colour[0]			= buffer_peek(buffer, buffer_tell(buffer) + 0x54, buffer_f32);
		colour[1]			= buffer_peek(buffer, buffer_tell(buffer) + 0x58, buffer_f32);
		colour[2]			= buffer_peek(buffer, buffer_tell(buffer) + 0x5C, buffer_f32);
		colour[3]			= buffer_peek(buffer, buffer_tell(buffer) + 0x60, buffer_f32);
		
		// Texture ID
		textureID			= buffer_peek(buffer, buffer_tell(buffer) + 0x74, buffer_s16);
		
		// Texture Flags
		textureFlags		= buffer_peek(buffer, buffer_tell(buffer) + 0xB4, buffer_u32);
		
		// Textures
		specularID			= buffer_peek(buffer, buffer_tell(buffer) + 0xB4 + 0x48, buffer_s32);
		normalID			= buffer_peek(buffer, buffer_tell(buffer) + 0xB4 + 0x4C, buffer_s32);
		cubemapID			= buffer_peek(buffer, buffer_tell(buffer) + 0xB4 + 0x50, buffer_s32);
		shineID				= buffer_peek(buffer, buffer_tell(buffer) + 0xB4 + 0x54, buffer_s32);
		
		// Ambient Tint
		ambientTint[0]		= buffer_peek(buffer, buffer_tell(buffer) + 0xB4 + 0x6C, buffer_u8) / 255;
		ambientTint[1]		= buffer_peek(buffer, buffer_tell(buffer) + 0xB4 + 0x6D, buffer_u8) / 255;
		ambientTint[2]		= buffer_peek(buffer, buffer_tell(buffer) + 0xB4 + 0x6E, buffer_u8) / 255;
		ambientTint[3]		= buffer_peek(buffer, buffer_tell(buffer) + 0xB4 + 0x6F, buffer_u8) / 255;
		
		// Reflection / Specular
		reflectionPower		= buffer_peek(buffer, buffer_tell(buffer) + 0xB4 + 0x78, buffer_f32);
		specularExponent	= buffer_peek(buffer, buffer_tell(buffer) + 0xB4 + 0x7C, buffer_f32);
		
		// Fresnel
		fresnelMultiplier	= buffer_peek(buffer, buffer_tell(buffer) + 0xB4 + 0x90, buffer_f32);
		fresnelCoeff		= buffer_peek(buffer, buffer_tell(buffer) + 0xB4 + 0x94, buffer_f32);
		
		// Other Bitfields
		vertexFormatFlags	= buffer_peek(buffer, buffer_tell(buffer) + 0xB4 + 0x13C, buffer_u32);
		inputFlags			= buffer_peek(buffer, buffer_tell(buffer) + 0xB4 + 0x1B4, buffer_u32);
		shaderFlags			= buffer_peek(buffer, buffer_tell(buffer) + 0xB4 + 0x1B8, buffer_u32);
		
		// Generate Vertex Format
		vertexFormat = decodeVertexFormat(vertexFormatFlags);
		
		// NU20 Last Colour Values
		if (_model.version == BTModelVersion.pcghgNU20First)
		{
			colour[0]		= buffer_peek(buffer, buffer_tell(buffer) + 0xC8, buffer_u8) / 255;
			colour[1]		= buffer_peek(buffer, buffer_tell(buffer) + 0xC9, buffer_u8) / 255;
			colour[2]		= buffer_peek(buffer, buffer_tell(buffer) + 0xCA, buffer_u8) / 255;
			colour[3]		= buffer_peek(buffer, buffer_tell(buffer) + 0xCB, buffer_u8) / 255;
		}
		
		// Log
		//ConsoleLog($"Material {i}", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer));
		//ConsoleLog($"	Alpha Blend:   {materialAlphaBlend}", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer) + 0x40);
		//ConsoleLog($"	Colour[f32*4]: [{materialColourRed}, {materialColourGreen}, {materialColourBlue}, {materialColourAlpha}]", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer) + 0x54);
		//if (self.version == BTModelVersion.pcghgNU20First)
		//	ConsoleLog($"	Colour[u8*4]:  [{round(materialColourRed * 255)}, {round(materialColourGreen * 255)}, {round(materialColourBlue * 255)}, {round(materialColourAlpha * 255)}]", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer) + 0xC8);
		//ConsoleLog($"	Texture ID:    {materialTextureID}", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer) + 0x74);
		//ConsoleLog($"	Specular ID:   {materialSpecularID}", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer) + 0xB4 + 0x48);
		//ConsoleLog($"	Normal ID:     {materialNormalID}", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer) + 0xB4 + 0x4C);
		//ConsoleLog($"	Cubemap ID:    {materialCubemapID}", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer) + 0xB4 + 0x50);
		//ConsoleLog($"	Shine ID:      {materialShineID}", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer) + 0xB4 + 0x54);
		//ConsoleLog($"	Vertex Format: {materialVertexFormat}", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer) + 0xB4 + 0x13C);
		//ConsoleLog($"	Shader Flags:  {materialShaderFlags}", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer) + 0xB4 + 0x1B8);
	}
	
	#endregion
	
	#region Serialize / Deserialize
	
	
	
	#endregion
	
	#region Helper
	
	/// @func decodeVertexFormat()
	/// @desc Decode Vertex Format
	static decodeVertexFormat = function(_vertexFormat)
	{
		var normalType;
		var uvSetCount;
		var bitangentType;
		var tangentType;
		var blendIndicesType;
		var blendWeightsType;
		var halfFloatUVType;
		var colourSet1;
		var colourSet2;
		var local_c;
		var arrayFormat = [];
		
		// Get Normal Type (Float3 / Byte4)
		if (((_vertexFormat & 8) == 0) && ((_vertexFormat & 0x880000) == 0))
		{
		    normalType = _vertexFormat >> 2 & 1;
		}
		else
		{
		    normalType = 2;
		}
		
		// Get Tangent Type (Float3 / Byte4)
		if (((_vertexFormat & 0x20) == 0) && ((_vertexFormat & 0x1000000) == 0))
		{
		    tangentType = _vertexFormat >> 4 & 1;
		}
		else
		{
		    tangentType = 2;
		}
		
		// Get Bitangent Type (Float3 / Byte4)
		if ((_vertexFormat < 0) || ((_vertexFormat & 0x2000000) != 0))
		{
		    bitangentType = 2;
		}
		else
		{
		    bitangentType = _vertexFormat >> 6 & 1;
		}
		
		// Colour Flag
		colourSet1 = _vertexFormat >> 8 & 1;
		colourSet2 = _vertexFormat & 0x600;
		
		// Get UV Set Count
		if ((_vertexFormat >> 0x1b & 1) == 0)
		{
		    uvSetCount = _vertexFormat >> 0xb & 7;
		    halfFloatUVType = 0;
		}
		else
		{
		    uvSetCount = 0;
		    halfFloatUVType = _vertexFormat >> 0xb & 7;
		}
		
		// Get Blend Indices Type
		if ((_vertexFormat & 0x8000) == 0)
		{
		    blendIndicesType = _vertexFormat >> 0xe & 1;
		}
		else
		{
		    blendIndicesType = 2;
		}
		
		// Blend Weights Type
		if ((_vertexFormat & 0x20000) == 0)
		{
		    blendWeightsType = _vertexFormat >> 0x10 & 1;
		}
		else
		{
		    blendWeightsType = 2;
		}
		
		// Other Stuff
		local_c = _vertexFormat >> 0x1a & 1;
		//var local_4 = _vertexFormat >> 0x16 & 1;
		
		// Always Has Position
		array_push(arrayFormat, {attribute: BTVertexAttributes.position, type: BTVertexAttributeTypes.float3, position: 0x00});
		
		// Begin Offset
		var offset = 0x0c;
		
		// Normals
		if (normalType == 1)
		{
			array_push(arrayFormat, {attribute: BTVertexAttributes.normal, type: BTVertexAttributeTypes.float3, position: offset});
			offset += 0x0c;
		}
		else if (normalType == 2)
		{
			array_push(arrayFormat, {attribute: BTVertexAttributes.normal, type: BTVertexAttributeTypes.byte4, position: offset});
			offset += 0x04;
		}
		
		// Tangents
		if (tangentType == 1)
		{
			array_push(arrayFormat, {attribute: BTVertexAttributes.tangent, type: BTVertexAttributeTypes.float3, position: offset});
			offset += 0x0c;
		}
		else if (tangentType == 2)
		{
			array_push(arrayFormat, {attribute: BTVertexAttributes.tangent, type: BTVertexAttributeTypes.byte4, position: offset});
			offset += 0x04;
		}
		
		// Bitangents
		if (bitangentType == 1)
		{
			array_push(arrayFormat, {attribute: BTVertexAttributes.bitangent, type: BTVertexAttributeTypes.float3, position: offset});
			offset += 0x0c;
		}
		else if (bitangentType == 2)
		{
			array_push(arrayFormat, {attribute: BTVertexAttributes.bitangent, type: BTVertexAttributeTypes.byte4, position: offset});
			offset += 0x04;
		}
		
		// Colour Set 1
		if (colourSet1 != 0)
		{
			array_push(arrayFormat, {attribute: BTVertexAttributes.colour, type: BTVertexAttributeTypes.byte4, position: offset});
			offset += 0x04;
		}
		
		// Colour Set 2
		if (colourSet2 != 0)
		{
			array_push(arrayFormat, {attribute: BTVertexAttributes.colour2, type: BTVertexAttributeTypes.byte4, position: offset});
			offset += 0x04;
		}
		
		// UV Sets
		if(uvSetCount != 0)
		{
		    for(var i = 0; i < uvSetCount; i++)
			{
				array_push(arrayFormat, {attribute: BTVertexAttributes.uv, type: BTVertexAttributeTypes.float2, position: offset});
				offset += 0x08;
		    }
		}
		else
		{
		    for(var i = 0; i < halfFloatUVType; i++)
			{
				array_push(arrayFormat, {attribute: BTVertexAttributes.uv, type: BTVertexAttributeTypes.half2, position: offset});
				offset += 0x08;
		    }
		}
		
		// Blend Indices
		if (blendIndicesType == 1)
		{
			array_push(arrayFormat, {attribute: BTVertexAttributes.blendIndices, type: BTVertexAttributeTypes.float2, position: offset});
			offset += 0x08;
		}
		else if (blendIndicesType == 2)
		{
			array_push(arrayFormat, {attribute: BTVertexAttributes.blendIndices, type: BTVertexAttributeTypes.byte4, position: offset});
			offset += 0x04;
		}
		
		// Blend Weights
		if (blendWeightsType == 1)
		{
			array_push(arrayFormat, {attribute: BTVertexAttributes.blendWeights, type: BTVertexAttributeTypes.float3, position: offset});
			offset += 0x0c;
		}
		else if (blendWeightsType == 2)
		{
			array_push(arrayFormat, {attribute: BTVertexAttributes.blendWeights, type: BTVertexAttributeTypes.byte4, position: offset});
			offset += 0x08;
		}
		
		// Other
		if (local_c != 0)
		{
			array_push(arrayFormat, {attribute: BTVertexAttributes.lightDirection, type: BTVertexAttributeTypes.byte4, position: offset});
			array_push(arrayFormat, {attribute: BTVertexAttributes.bitangent, type: BTVertexAttributeTypes.byte4, position: offset});
			offset += 0x08;
		}
		
		return arrayFormat;
	}
	
	#endregion
}