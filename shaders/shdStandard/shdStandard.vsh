/*
	Calico Standard Vertex Shader (c) Alun Jones
	-------------------------------------------------------------------------
	Script:			Calico Standard Vertex Shader
	Version:		v1.00
	Created:		15/07/2023 by Alun Jones
	Description:	BRDF Shader For Calico
	-------------------------------------------------------------------------
	History:
	 - Created 15/07/2023 by Alun Jones
	
	To Do:
	 - Glass Rendering
*/

// Vertex Attributes (In)
attribute vec3 in_Position;					// Position
attribute vec3 in_Normal;					// Normal
attribute vec2 in_TextureCoord0;			// Texture Coords
attribute vec2 in_TextureCoord1;			// Texture Coords
attribute vec4 in_Colour0;					// Colour
attribute vec4 in_Colour1;					// Tangent
attribute vec2 in_TextureCoord2;			// Extra Data

// Varyings
// Local
varying vec3 vPosition;
varying vec3 vNormal;
varying vec2 vTexcoord0;
varying vec2 vTexcoord1;
varying vec4 vColour;
varying float vRim;

// World
varying vec3 vWorldPosition;
varying vec3 vWorldNormal;

// View
varying vec3 vViewPosition;
varying vec3 vViewNormal;
varying float vViewDepth;

// Screen
varying vec3 vScreenPosition;

// TBN
varying mat3 mTBN;

// Dynamic Buffers
uniform vec3 uDynamicBuffer[1000];
uniform bool uUseDynamicBuffer;

void main()
{
	// Set Vertex Position
    vPosition = in_Position;
	
	// Dynamic Buffer
	//if (uUseDynamicBuffer) vPosition += uDynamicBuffer[int(in_TextureCoord1.x)];
	
	// Set Vertex Position
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(in_Position, 1.0);
    
	// Local
    vNormal = in_Normal;
    vColour = clamp(vec4(in_Colour0.b, in_Colour0.g, in_Colour0.r, in_Colour0.a) * 2.0, 0.0, 1.0);
	//vColour = vec4(1.0);
    vTexcoord0 = in_TextureCoord0;
    vTexcoord1 = in_TextureCoord1;
	
	// World
    vWorldPosition = (gm_Matrices[MATRIX_WORLD] * vec4(in_Position, 1.0)).xyz;
    vWorldNormal = (gm_Matrices[MATRIX_WORLD] * vec4(vNormal, 0.0)).xyz;
	
	// View
    vViewPosition = (gm_Matrices[MATRIX_WORLD_VIEW] * vec4(in_Position, 1.0)).xyz;
    vViewNormal = (gm_Matrices[MATRIX_WORLD_VIEW] * vec4(vNormal, 0.0)).xyz;
	
	// Rim
	vRim = normalize((gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(vWorldNormal, 0.0)).xyz).z;
	
	// Screen
	vScreenPosition = (gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(in_Position, 1.0)).xyz;
	
	// TBN (Normal Mapping Calculations)
	vec4 tangentFixed = vec4((in_Colour1.r * 2.) - 1., (in_Colour1.g * 2.) - 1., (in_Colour1.b * 2.) - 1., (in_Colour1.a * 2.) - 1.);
	vec4 tangent = vec4(tangentFixed.xyz, 0.0);
	vec4 bitangent = vec4(cross(vNormal, tangentFixed.xyz) * tangentFixed.w, 0.0);
	mTBN = mat3((gm_Matrices[MATRIX_WORLD] * tangent).xyz, (gm_Matrices[MATRIX_WORLD] * bitangent).xyz, vWorldNormal);
	
	// Depth
	//vViewDepth = gl_Position.z / gl_Position.w;
}
