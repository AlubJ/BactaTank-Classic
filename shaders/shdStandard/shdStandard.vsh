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
attribute vec4 in_Colour2;					// BlendIndices
attribute vec4 in_Colour3;					// BlendWeights
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

// Bones
uniform mat4 uBones[8];
uniform bool uAnimate;
uniform bool uStatic;

void main()
{
	// Set Vertex Position
    vPosition = in_Position;
	
	// Dynamic Buffer
	//if (uUseDynamicBuffer) vPosition += uDynamicBuffer[int(in_TextureCoord1.x)];
	
	// Get Blend Index
	ivec4 blendIndex = ivec4(in_Colour2 * 255.);
	vec4 blendWeights = in_Colour3;
    
	// Local
    vNormal = in_Normal;
    vColour = clamp(vec4(in_Colour0.b, in_Colour0.g, in_Colour0.r, in_Colour0.a) * 2.0, 0.0, 1.0);
	//vColour = vec4(1.0);
	//vColour = blendWeights;
    vTexcoord0 = in_TextureCoord0;
    vTexcoord1 = in_TextureCoord1;
	
	// Animate
	if (uAnimate)
	{
		if (uStatic)
		{
			vPosition = (uBones[0] * vec4(vPosition,1.0)).xyz;
			vNormal = mat3(uBones[0]) * vNormal;
		}
		else
		{
			// Create Total Position and Total Normal Vectors
			vec4 totalPosition = vec4(0.0);
			vec3 totalNormal = vec3(0.0);
		
			// Loop All Possible Bone Influences
		    for (int i = 0 ; i < 3 ; i++)
		    {
				// Skip If No Bone Influence
		        if (blendIndex[i] == 255)
		            continue;
			
				// Skip If Outside Bones
		        if (blendIndex[i] >= 8)
		        {
		            totalPosition = vec4(vPosition,1.0);
					totalNormal = vec3(vNormal);
		            break;
		        }
			
				// Get Full Influence Of Blend
		        vec4 localPosition = uBones[blendIndex[i]] * vec4(vPosition,1.0);
				vec3 localNormal = mat3(uBones[blendIndex[i]]) * vNormal;
			
				// Get Weight
				float weight = blendWeights[i];
			
				// Do This Because Tt Decided To Resolve The Third Weight From The First Two Weights
				if (i == 2)
				{
					weight = 1.0 - blendWeights[0] - blendWeights[1];
				}
			
				// Add To Total Position
		        totalPosition += localPosition * weight;
			
				// Add To Total Normal
				totalNormal += localNormal * weight;
		    }
		
			// Apply Final Values
			vPosition = totalPosition.xyz;
			vNormal = totalNormal;
		}
	}
	
	// Set Vertex Position
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(vPosition, 1.0);
	
	// World
    vWorldPosition = (gm_Matrices[MATRIX_WORLD] * vec4(vPosition, 1.0)).xyz;
    vWorldNormal = (gm_Matrices[MATRIX_WORLD] * vec4(vNormal, 0.0)).xyz;
	
	// View
    vViewPosition = (gm_Matrices[MATRIX_WORLD_VIEW] * vec4(vPosition, 1.0)).xyz;
    vViewNormal = (gm_Matrices[MATRIX_WORLD_VIEW] * vec4(vNormal, 0.0)).xyz;
	
	// Rim
	vRim = normalize((gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(vWorldNormal, 0.0)).xyz).z;
	
	// Screen
	vScreenPosition = (gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(vPosition, 1.0)).xyz;
	
	// TBN (Normal Mapping Calculations)
	vec4 tangentFixed = vec4((in_Colour1.r * 2.) - 1., (in_Colour1.g * 2.) - 1., (in_Colour1.b * 2.) - 1., (in_Colour1.a * 2.) - 1.);
	vec4 tangent = vec4(tangentFixed.xyz, 0.0);
	vec4 bitangent = vec4(cross(vNormal, tangentFixed.xyz) * tangentFixed.w, 0.0);
	mTBN = mat3((gm_Matrices[MATRIX_WORLD] * tangent).xyz, (gm_Matrices[MATRIX_WORLD] * bitangent).xyz, vWorldNormal);
	
	// Depth
	//vViewDepth = gl_Position.z / gl_Position.w;
}
