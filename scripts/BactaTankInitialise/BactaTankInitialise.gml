/*
	BactaTankInitialise
	-------------------------------------------------------------------------
	Script:			BactaTankInitialise
	Version:		v1.00
	Created:		15/11/2024 by Alun Jones
	Description:	Initialise BactaTank
	-------------------------------------------------------------------------
	History:
	 - Created 15/11/2024 by Alun Jones
	
	To Do:
	
*/

// Internal Versions
#macro BT_PROJECT_VERSION 1.0
#macro BT_ADDON_VERSION 1.0

// BactaTank Context (Used for UI Loading)
enum BTContext
{
	None,
	Project,
	Model,
	Scene,
	Icon,
	Font,
}
global.__context = ["None", "Project", "Model", "Scene", "Icon", "Font"];
#macro BT_CONTEXT global.__context

// Model Version
enum BTModelVersion
{
	pcghgNU20Last,
	pcghgNU20First,
	none,
}
global.__modelVersion = ["PCGHG_NU20_LAST", "PCGHG_NU20_FIRST"];
#macro BT_MODEL_VERSION global.__modelVersion

// Model Type
enum BTModelType
{
	model,
	scene,
	none,
}
global.__modelType = ["Model", "Scene"];
#macro BT_MODEL_TYPE global.__modelType
	
// Model Vertex Attributes
enum BTVertexAttributes
{
	position,
	normal,
	tangent,
	bitangent,
	colourSet1,
	colourSet2,
	uvSet1,
	uvSet2,
	uvSet3,
	uvSet4,
	blendIndices,
	blendWeights,
	lightDirection,
	lightColour,
}
global.__attributes = ["Position", "Normal", "Tangent", "BiTangent", "ColourSet1", "ColourSet2", "UVSet1", "UVSet2", "UVSet3", "UVSet4", "BlendIndices", "BlendWeights", "LightDirection", "LightColour"];
#macro BT_VERTEX_ATTRIBUTES global.__attributes

// Model Vertex Attributes
enum BTVertexAttributeTypes
{
	float2,
	float3,
	byte4,
	half2,
}
global.__attributeTypes = ["Float 2", "Float 3", "Byte 4", "Half 2"];
#macro BT_VERTEX_ATTRIBUTE_TYPES global.__attributeTypes

// DXT Compressions
global.DXTCompression = ["", "DXT1", "", "", "DXT3", "", "DXT5"];
#macro BT_DXT_COMPRESSION global.DXTCompression

// Shader Settings
//#macro bactatankShaderLightDirection			shader_get_uniform(defaultShading, "lightDirection")
//#macro bactatankShaderLightColour				shader_get_uniform(defaultShading, "lightColour")
//#macro bactatankShaderBlendColour				shader_get_uniform(defaultShading, "colour")
//#macro bactatankShaderInvView					shader_get_uniform(defaultShading, "invView")
//#macro bactatankShaderShiny						shader_get_uniform(defaultShading, "shiny")
//#macro bactatankShaderReflective				shader_get_uniform(defaultShading, "reflective")
//#macro bactatankShaderUseTexture				shader_get_uniform(defaultShading, "useTexture")
//#macro bactatankShaderUseLighting				shader_get_uniform(defaultShading, "useLighting")
//#macro bactatankShaderUseNormalMap				shader_get_uniform(defaultShading, "useNormalMap")
//#macro bactatankShaderTransparency				shader_get_uniform(defaultShading, "useTransparency")
//#macro bactatankShaderNormalMap					shader_get_sampler_index(defaultShading, "normalMap")
//#macro bactatankShaderCubeMap0					shader_get_sampler_index(defaultShading, "cubeMap0")
//#macro bactatankShaderCubeMap1					shader_get_sampler_index(defaultShading, "cubeMap1")
//#macro bactatankShaderAmbientColour				shader_get_uniform(renderShader, "ambientColour")

// Main Vertex Format
vertex_format_begin();
vertex_format_add_custom(vertex_type_float3, vertex_usage_position);
vertex_format_add_custom(vertex_type_float3, vertex_usage_normal);
vertex_format_add_custom(vertex_type_float2, vertex_usage_texcoord);
vertex_format_add_colour();
vertex_format_add_colour();
vertex_format_add_custom(vertex_type_float2, vertex_usage_texcoord);
global.vertexFormat = vertex_format_end();
#macro BT_VERTEX_FORMAT global.vertexFormat

// Wireframe Vertex Format
vertex_format_begin();
vertex_format_add_position_3d();
global.wireframeVertexFormat = vertex_format_end();
#macro BT_WIREFRAME_VERTEX_FORMAT global.wireframeVertexFormat

// UV Vertex Format
vertex_format_begin();
vertex_format_add_texcoord();
global.uvVertexFormat = vertex_format_end();
#macro BT_UV_VERTEX_FORMAT global.uvVertexFormat

// Alpha Blend Bits
#macro BT_ALPHA_BLEND_BITS 0x0f
#macro BT_ALPHA_BLEND_SHIFT 0x00

// Alpha Blend
enum BTAlphaBlend {
	None,
	Transparent,
	TransparentIgnoreDestination,
	ReverseTransparent,
	NoneFixedAlpha = 10,
}
#macro BT_ALPHA_BLEND global.alphaBlend
BT_ALPHA_BLEND = ["None", "Transparent", "TransparentIgnoreDestination", "ReverseTransparent", "", "", "", "", "", "", "NoneFixedAlpha"];

// Cullmode Bits
#macro BT_CULLMODE_BITS 0x03
#macro BT_CULLMODE_SHIFT 0x0C

// Cullmode
enum BTCullmode {
	CullCounterClockwise,
	CullClockwise,
	NoCulling,
}
#macro BT_CULLMODE global.cullmode
BT_CULLMODE = ["CullCounterClockwise", "CullClockwise", "NoCulling"];

// Depth Type Bits
#macro BT_DEPTH_TYPE_BITS 0x03
#macro BT_DEPTH_TYPE_SHIFT 0x0E

// Depth Type
enum BTDepthType
{
	Normal,
	NoWrite,
	AlwaysPass,
	IgnoreDepth,
}
#macro BT_DEPTH_TYPE global.depthType
BT_DEPTH_TYPE = ["Normal", "NoWrite", "AlwaysPass", "IgnoreDepth"];

// Alpha Test Value
#macro BT_ALPHA_TEST_BITS 0xff
#macro BT_ALPHA_TEST_SHIFT 0x17

// Alpha Format Value
#macro BT_ALPHA_FORMAT_BITS 0xff
#macro BT_ALPHA_FORMAT_SHIFT 0x14

// Surface Bits
#macro BT_SURFACE_BITS 0x03
#macro BT_SURFACE_SHIFT 0x00

// Surface Type
enum BTSurfaceType {
	Smooth,
	NormalMap,
	ParallaxMap,
	TangentMap,
}
#macro BT_SURFACE_TYPE global.surfaceType
BT_SURFACE_TYPE = ["Smooth", "NormalMap", "ParallaxMap", "TangentMap"];

// EnvMap Bits
#macro BT_ENVMAP_BITS 0x03
#macro BT_ENVMAP_SHIFT 0x06

// EnvMap Type
enum BTEnvMapType {
	None,
	Cube,
	Sphere,
	PS2,
}
#macro BT_ENVMAP_TYPE global.envmapType
BT_ENVMAP_TYPE = ["None", "Cube", "Sphere", "PS2"];

// Shine Map
#macro BT_USE_SHINEMAP 0x8000
#macro BT_USE_SHINEMAP_SHIFT 0x0f

// No Lighting Check
#macro BT_NO_LIGHTING 0x1000
#macro BT_NO_LIGHTING_SHIFT 0x0c

// Lighting Bits
#macro BT_LIGHTING_BITS 0x03
#macro BT_LIGHTING_SHIFT 0x03

// Lighting Stage
enum BTLighting
{
	Lambert,
	Phong,
	Anisotropic,
}
#macro BT_LIGHTING global.lighting
BT_LIGHTING = ["Lambert", "Phong", "Anisotropic"];

// Anisotropic Flip
#macro BT_ANISO_FLIP 0x2000000

// Shader Enum
enum BTShader
{
	vertex,
	fragment,
}

global.debug = "";
global.debugInfo = [];

// DBGOUT
DBGOUT("BactaTank Classic: Initialised");