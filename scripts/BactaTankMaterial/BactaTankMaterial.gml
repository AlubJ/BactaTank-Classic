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
	 - Write Vertex Format Encoder
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
	uvSetCoords			= 0;
	
	// UV Sets
	surfaceUVMapIndex	= 0;
	specularUVMapIndex	= 0;
	normalUVMapIndex	= 0;
	
	// Other
	offset				= 0;
	vertexFormat		= [  ];
	
	#region Parse / Inject
	
	static parse = function(buffer, _model)
	{
		// Get Offset
		offset = buffer_tell(buffer) - _model.nu20Offset;
		
		// Read Material Things
		var materialIndex	= buffer_peek(buffer, buffer_tell(buffer) + 0x38, buffer_u32);
		
		// Log
		ConsoleLog($"Material {materialIndex}", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer));
		
		// Alpha Blend
		alphaBlend			= buffer_peek(buffer, buffer_tell(buffer) + 0x40, buffer_u32);
		ConsoleLog($"    Alpha Blend:          {alphaBlend}", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer) + 0x40);
		
		// Blend Colour
		colour[0]			= buffer_peek(buffer, buffer_tell(buffer) + 0x54, buffer_f32);
		colour[1]			= buffer_peek(buffer, buffer_tell(buffer) + 0x58, buffer_f32);
		colour[2]			= buffer_peek(buffer, buffer_tell(buffer) + 0x5C, buffer_f32);
		colour[3]			= buffer_peek(buffer, buffer_tell(buffer) + 0x60, buffer_f32);
		ConsoleLog($"    Blend Colour:          {colour}", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer) + 0x54);
		
		// Texture ID
		textureID			= buffer_peek(buffer, buffer_tell(buffer) + 0x74, buffer_s16);
		ConsoleLog($"    Texture Index:         {textureID}", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer) + 0x74);
		
		// Texture Flags
		textureFlags		= buffer_peek(buffer, buffer_tell(buffer) + 0xB4, buffer_u32);
		ConsoleLog($"    Texture Flags:         {textureFlags}", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer) + 0xB4);
		
		// Textures
		specularID			= buffer_peek(buffer, buffer_tell(buffer) + 0xB4 + 0x48, buffer_s32);
		ConsoleLog($"    Specular Index:        {specularID}", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer) + 0xB4 + 0x48);
		normalID			= buffer_peek(buffer, buffer_tell(buffer) + 0xB4 + 0x4C, buffer_s32);
		ConsoleLog($"    Normal Index:          {normalID}", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer) + 0xB4 + 0x4C);
		cubemapID			= buffer_peek(buffer, buffer_tell(buffer) + 0xB4 + 0x50, buffer_s32);
		ConsoleLog($"    Cubemap Index:         {cubemapID}", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer) + 0xB4 + 0x50);
		shineID				= buffer_peek(buffer, buffer_tell(buffer) + 0xB4 + 0x54, buffer_s32);
		ConsoleLog($"    Shine Index:           {shineID}", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer) + 0xB4 + 0x54);
		
		// Ambient Tint
		ambientTint[0]		= buffer_peek(buffer, buffer_tell(buffer) + 0xB4 + 0x6C, buffer_u8) / 255;
		ambientTint[1]		= buffer_peek(buffer, buffer_tell(buffer) + 0xB4 + 0x6D, buffer_u8) / 255;
		ambientTint[2]		= buffer_peek(buffer, buffer_tell(buffer) + 0xB4 + 0x6E, buffer_u8) / 255;
		ambientTint[3]		= buffer_peek(buffer, buffer_tell(buffer) + 0xB4 + 0x6F, buffer_u8) / 255;
		ConsoleLog($"    Ambient Tint:          {ambientTint}", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer) + 0xB4 + 0x6C);
		
		// Reflection / Specular
		reflectionPower		= buffer_peek(buffer, buffer_tell(buffer) + 0xB4 + 0x78, buffer_f32);
		ConsoleLog($"    Reflection Power:      {reflectionPower}", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer) + 0xB4 + 0x78);
		specularExponent	= buffer_peek(buffer, buffer_tell(buffer) + 0xB4 + 0x7C, buffer_f32);
		ConsoleLog($"    Specular Exponent:     {specularExponent}", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer) + 0xB4 + 0x7C);
		
		// Fresnel
		fresnelMultiplier	= buffer_peek(buffer, buffer_tell(buffer) + 0xB4 + 0x90, buffer_f32);
		ConsoleLog($"    Fresnel Multiplier:    {fresnelMultiplier}", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer) + 0xB4 + 0x90);
		fresnelCoeff		= buffer_peek(buffer, buffer_tell(buffer) + 0xB4 + 0x94, buffer_f32);
		ConsoleLog($"    Fresnel Coeff:         {fresnelCoeff}", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer) + 0xB4 + 0x94);
		
		// Define UV Sets
		surfaceUVMapIndex	= buffer_peek(buffer, buffer_tell(buffer) + 0xB4 + 0xA9, buffer_u8);
		ConsoleLog($"    Surface UV Index:      {surfaceUVMapIndex}", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer) + 0xB4 + 0xA9);
		specularUVMapIndex	= buffer_peek(buffer, buffer_tell(buffer) + 0xB4 + 0xAA, buffer_u8);
		ConsoleLog($"    Specular UV Index:     {specularUVMapIndex}", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer) + 0xB4 + 0xAA);
		normalUVMapIndex	= buffer_peek(buffer, buffer_tell(buffer) + 0xB4 + 0xAB, buffer_u8);
		ConsoleLog($"    Normal UV Index:       {normalUVMapIndex}", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer) + 0xB4 + 0xAB);
		
		// Other Bitfields
		vertexFormatFlags	= buffer_peek(buffer, buffer_tell(buffer) + 0xB4 + 0x13C, buffer_u32);
		ConsoleLog($"    Vertex Format:         {vertexFormatFlags}", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer) + 0xB4 + 0x13C);
		inputFlags			= buffer_peek(buffer, buffer_tell(buffer) + 0xB4 + 0x1B4, buffer_u32);
		ConsoleLog($"    Input Flags:           {inputFlags}", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer) + 0xB4 + 0x1B4);
		shaderFlags			= buffer_peek(buffer, buffer_tell(buffer) + 0xB4 + 0x1B8, buffer_u32);
		ConsoleLog($"    Shader Flags:          {shaderFlags}", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer) + 0xB4 + 0x1B8);
		uvSetCoords			= buffer_peek(buffer, buffer_tell(buffer) + 0xB4 + 0x1BC, buffer_u32);
		ConsoleLog($"    UV Set Coords:         {uvSetCoords}", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer) + 0xB4 + 0x1BC);
		
		// Generate Vertex Format
		vertexFormat = decodeVertexFormat(vertexFormatFlags);
		ConsoleLog($"    Decoded Vertex Format: {vertexFormat}", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer) + 0xB4 + 0x13C);
		
		// NU20 Last Colour Values
		if (_model.version == BTModelVersion.pcghgNU20First)
		{
			colour[0]		= buffer_peek(buffer, buffer_tell(buffer) + 0xC8, buffer_u8) / 255;
			colour[1]		= buffer_peek(buffer, buffer_tell(buffer) + 0xC9, buffer_u8) / 255;
			colour[2]		= buffer_peek(buffer, buffer_tell(buffer) + 0xCA, buffer_u8) / 255;
			colour[3]		= buffer_peek(buffer, buffer_tell(buffer) + 0xCB, buffer_u8) / 255;
			ConsoleLog($"    Alternate Colour:       {colour}", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer) + 0xB4 + 0xC8);
		}
	}
	
	static inject = function(buffer, _model)
	{
		// Inject Alpha Blend
		buffer_poke(buffer, offset + 0x40,    buffer_u32, alphaBlend);
		
		// Inject Colour
		buffer_poke(buffer, offset + 0x54,    buffer_f32, colour[0]);
		buffer_poke(buffer, offset + 0x58,    buffer_f32, colour[1]);
		buffer_poke(buffer, offset + 0x5c,    buffer_f32, colour[2]);
		buffer_poke(buffer, offset + 0x60,    buffer_f32, colour[3]);
		
		// Inject Texture IDs
		buffer_poke(buffer, offset + 0x74,    buffer_s16, textureID);
		buffer_poke(buffer, offset + 0xb4 + 0x04,    buffer_s32, textureID);
		buffer_poke(buffer, offset + 0xb4 + 0x4c,    buffer_s32, normalID);
		buffer_poke(buffer, offset + 0xb4 + 0x54,    buffer_s32, shineID);
		
		// Inject Ambient Tint
		buffer_poke(buffer, offset + 0xB4 + 0x6C,    buffer_u8,  floor(ambientTint[0] * 255));
		buffer_poke(buffer, offset + 0xB4 + 0x6D,    buffer_u8,  floor(ambientTint[1] * 255));
		buffer_poke(buffer, offset + 0xB4 + 0x6E,    buffer_u8,  floor(ambientTint[2] * 255));
		buffer_poke(buffer, offset + 0xB4 + 0x6F,    buffer_u8,  floor(ambientTint[3] * 255));
		
		// Inject UV Sets
		buffer_poke(buffer, offset + 0xB4 + 0xA9, surfaceUVMapIndex, buffer_u8);
		buffer_poke(buffer, offset + 0xB4 + 0xAA, specularUVMapIndex, buffer_u8);
		buffer_poke(buffer, offset + 0xB4 + 0xAB, normalUVMapIndex, buffer_u8);
		
		// Inject Shader Flags
		buffer_poke(buffer, offset + 0xb4 + 0x1b8,   buffer_u32, shaderFlags);
		
		// Inject LB1 and LIJ1 Colours
		if (_model.version == BTModelVersion.pcghgNU20First)
		{
			buffer_poke(buffer, offset + 0xc8,    buffer_u8, floor(colour[0] * 255));
			buffer_poke(buffer, offset + 0xc9,    buffer_u8, floor(colour[1] * 255));
			buffer_poke(buffer, offset + 0xca,    buffer_u8, floor(colour[2] * 255));
			buffer_poke(buffer, offset + 0xcb,    buffer_u8, floor(colour[3] * 255));
		}
	}
	
	#endregion
	
	#region Serialize / Deserialize
	
	/// @func serialize(buffer)
	/// @desc Serialize
	static serialize = function(buffer)
	{
		// Write Blend Colour
		buffer_write(buffer, buffer_f32, colour[0]);
		buffer_write(buffer, buffer_f32, colour[1]);
		buffer_write(buffer, buffer_f32, colour[2]);
		buffer_write(buffer, buffer_f32, colour[3]);
		
		// Write Ambient Tint
		buffer_write(buffer, buffer_f32, ambientTint[0]);
		buffer_write(buffer, buffer_f32, ambientTint[1]);
		buffer_write(buffer, buffer_f32, ambientTint[2]);
		buffer_write(buffer, buffer_f32, ambientTint[3]);
		
		// Write Specular Exponent and Reflection Power
		buffer_write(buffer, buffer_f32, specularExponent);
		buffer_write(buffer, buffer_f32, reflectionPower);
		
		// Write Other Attributes
		buffer_write(buffer, buffer_u32, 0x00); //vertexFormat);
		buffer_write(buffer, buffer_u32, alphaBlend);
		buffer_write(buffer, buffer_u32, shaderFlags);
	}
	
	#endregion
	
	#region Export / Replace Material
	
	/// @func export()
	/// @desc Export BactaTankMaterial
	static export = function(filepath)
	{
		// Create Export Buffer
		var buffer = buffer_create(1, buffer_grow, 1);
		
		// Write Header
		buffer_write(buffer, buffer_string, "BactaTankMaterial");
		buffer_write(buffer, buffer_string, "PCGHG");
		buffer_write(buffer, buffer_f32, 0.1);
		
		// Serialize
		serialize(buffer);
		
		// Buffer Save
		buffer_save(buffer, filepath);
		buffer_delete(buffer);
	}
	
	/// @func replace()
	/// @desc Replace BactaTankMaterial
	static replace = function(filepath, replaceVertexFormat = false)
	{
		// Load Material Buffer
		var buffer = buffer_load(filepath);
		
		// Read Header
		var magic = buffer_read(buffer, buffer_string); // BactaTankMaterial
		var format = buffer_read(buffer, buffer_string); // PCGHG
		var version = buffer_read(buffer, buffer_f32); // 0.1
		
		// Version Check
		if (version != 0.1) return;
		
		// Read Blend Colour
		colour[0] = buffer_read(buffer, buffer_f32);
		colour[1] = buffer_read(buffer, buffer_f32);
		colour[2] = buffer_read(buffer, buffer_f32);
		colour[3] = buffer_read(buffer, buffer_f32);
		
		// Read Ambient Tint
		ambientTint[0] = buffer_read(buffer, buffer_f32);
		ambientTint[1] = buffer_read(buffer, buffer_f32);
		ambientTint[2] = buffer_read(buffer, buffer_f32);
		ambientTint[3] = buffer_read(buffer, buffer_f32);
		
		// Read Specular Exponent and Reflection Power
		specularExponent = buffer_read(buffer, buffer_f32);
		reflectionPower = buffer_read(buffer, buffer_f32);
		
		// Read Other Attributes
		if (replaceVertexFormat) vertexFormat = buffer_read(buffer, buffer_u32);
		else buffer_read(buffer, buffer_u32);
		alphaBlend = buffer_read(buffer, buffer_u32);
		shaderFlags = buffer_read(buffer, buffer_u32);
		
		// Delete Buffer
		buffer_delete(buffer);
	}
	
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
			array_push(arrayFormat, {attribute: BTVertexAttributes.colourSet1, type: BTVertexAttributeTypes.byte4, position: offset});
			offset += 0x04;
		}
		
		// Colour Set 2
		if (colourSet2 != 0)
		{
			array_push(arrayFormat, {attribute: BTVertexAttributes.colourSet2, type: BTVertexAttributeTypes.byte4, position: offset});
			offset += 0x04;
		}
		
		// UV Sets
		if(uvSetCount != 0)
		{
		    for(var i = 0; i < uvSetCount; i++)
			{
				array_push(arrayFormat, {attribute: BTVertexAttributes.uvSet1 + i, type: BTVertexAttributeTypes.float2, position: offset});
				offset += 0x08;
		    }
		}
		else
		{
		    for(var i = 0; i < halfFloatUVType; i++)
			{
				array_push(arrayFormat, {attribute: BTVertexAttributes.uvSet1 + i, type: BTVertexAttributeTypes.half2, position: offset});
				offset += 0x04;
		    }
		}
		
		// Blend Indices
		if (blendIndicesType == 1)
		{
			array_push(arrayFormat, {attribute: BTVertexAttributes.blendWeights, type: BTVertexAttributeTypes.float2, position: offset});
			offset += 0x08;
		}
		else if (blendIndicesType == 2)
		{
			array_push(arrayFormat, {attribute: BTVertexAttributes.blendWeights, type: BTVertexAttributeTypes.byte4, position: offset});
			offset += 0x04;
		}
		
		// Blend Weights
		if (blendWeightsType == 1)
		{
			array_push(arrayFormat, {attribute: BTVertexAttributes.blendIndices, type: BTVertexAttributeTypes.float3, position: offset});
			offset += 0x0c;
		}
		else if (blendWeightsType == 2)
		{
			array_push(arrayFormat, {attribute: BTVertexAttributes.blendIndices, type: BTVertexAttributeTypes.byte4, position: offset});
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
	
	/// @func decodeVertexFormat()
	/// @desc Decode Vertex Format
	static encodeVertexFormat = function()
	{
		// New Vertex Format
		var _vertexFormat = 0;
		
		// Vertex Format Loop
		for (var i = 0; i < array_length(vertexFormat); i++)
		{
			// Attribute
			var attribute = vertexFormat[i];
			
			// Attribute Switch
			switch (attribute.attribute)
			{
				case BTVertexAttributes.position:
					// Do nothing here as position is there by default
					break;
				case BTVertexAttributes.normal:
					break;
					
			}
		}
		
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
			array_push(arrayFormat, {attribute: BTVertexAttributes.colourSet1, type: BTVertexAttributeTypes.byte4, position: offset});
			offset += 0x04;
		}
		
		// Colour Set 2
		if (colourSet2 != 0)
		{
			array_push(arrayFormat, {attribute: BTVertexAttributes.colourSet2, type: BTVertexAttributeTypes.byte4, position: offset});
			offset += 0x04;
		}
		
		// UV Sets
		if(uvSetCount != 0)
		{
		    for(var i = 0; i < uvSetCount; i++)
			{
				array_push(arrayFormat, {attribute: BTVertexAttributes.uvSet1, type: BTVertexAttributeTypes.float2, position: offset});
				offset += 0x08;
		    }
		}
		else
		{
		    for(var i = 0; i < halfFloatUVType; i++)
			{
				array_push(arrayFormat, {attribute: BTVertexAttributes.uvSet2, type: BTVertexAttributeTypes.half2, position: offset});
				offset += 0x08;
		    }
		}
		
		// Blend Indices
		if (blendIndicesType == 1)
		{
			array_push(arrayFormat, {attribute: BTVertexAttributes.blendWeights, type: BTVertexAttributeTypes.float2, position: offset});
			offset += 0x08;
		}
		else if (blendIndicesType == 2)
		{
			array_push(arrayFormat, {attribute: BTVertexAttributes.blendWeights, type: BTVertexAttributeTypes.byte4, position: offset});
			offset += 0x04;
		}
		
		// Blend Weights
		if (blendWeightsType == 1)
		{
			array_push(arrayFormat, {attribute: BTVertexAttributes.blendIndices, type: BTVertexAttributeTypes.float3, position: offset});
			offset += 0x0c;
		}
		else if (blendWeightsType == 2)
		{
			array_push(arrayFormat, {attribute: BTVertexAttributes.blendIndices, type: BTVertexAttributeTypes.byte4, position: offset});
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