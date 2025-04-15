/*
	CalicoBRDF Pixel Shader (c) Alun Jones
	-------------------------------------------------------------------------
	Script:			CalicoBRDF Pixel Shader
	Version:		v1.00
	Created:		15/07/2023 by Alun Jones
	Description:	BRDF Shader For Calico
	-------------------------------------------------------------------------
	History:
	 - Created 15/07/2023 by Alun Jones
	
	To Do:
*/

// Lighting Setup
#define MAX_LIGHTS 64
#define LIGHT_DIRECTIONAL 1.0
#define LIGHT_POINT 2.0
#define LIGHT_SPOT 3.0
#define LIGHT_TYPES 16.0
#define PI 3.14159265359
#define PI2 6.28318530718

#define SCROLL_NONE		0
#define SCROLL_LINEAR	2
#define SCROLL_SINE		3
#define SCROLL_COSINE	4

#region Varyings

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

#endregion

#region Uniforms

// General Uniforms
uniform vec3 uCameraPosition;
uniform mat4 uInvertedViewMatrix;
uniform float uSpecularExponent;
uniform float uReflectionStrength;
uniform vec4 uBlendColour;
uniform vec4 uAmbientTint;
uniform vec4 uSpecularTint;
uniform float uEnvironmentProbeBlend;
uniform float uAlphaTest;

// UV Sets
uniform int uSurfaceUVSet;
uniform int uNormalUVSet;
uniform int uSpecularUVSet;

// Texture Scrolling
uniform ivec2 uScrollType;
uniform vec2 uScrollScale;
uniform vec2 uScrollSpeed;
uniform float uCurrentTime;

// Texture Samplers
uniform sampler2D tSpecularMap;
uniform sampler2D tNormalMap;
uniform sampler2D tCubemap;
uniform sampler2D tShineMap;

// Texture Flags
uniform bool uUseDiffuseMap;
uniform bool uUseNormalMap;
uniform bool uUseCubemap;
uniform bool uUseShineMap;

// Shader Flags
uniform bool uLightingAffected;
uniform bool uSpecularHighlighting;
uniform bool uMetallic;
uniform bool uShadowAffected;
uniform bool uTransparency;

// Lighting Uniforms
uniform int uLightCount;
uniform vec3 uLightAmbientColour;
uniform vec4 uLightDataPrimary[MAX_LIGHTS];
uniform vec4 uLightDataSecondary[MAX_LIGHTS];
uniform vec4 uLightDataTertiary[MAX_LIGHTS];
uniform float uFogStrength;
uniform float uFogStart;
uniform float uFogEnd;
uniform vec3 uFogColour;

#endregion

#region Helper Functions

vec2 rotateUV(vec2 uv, float rotation)
{
    float mid = 0.5;
    float cosAngle = cos(rotation);
    float sinAngle = sin(rotation);
    return vec2(
        cosAngle * (uv.x - mid) + sinAngle * (uv.y - mid) + mid,
        cosAngle * (uv.y - mid) - sinAngle * (uv.x - mid) + mid
    );
}

//Function to find largest component of vec3. returns 0 for x, 1 for y, 2 for z
int argmax3 (vec3 v)
{
    return v.y > v.x ? ( v.z > v.y ? 2 : 1 ) : ( v.z > v.x ? 2 : 0 );
}

#endregion

#region Equirectangular Mapping

vec2 xVec3ToEquirectangularUv(vec3 dir)
{
	vec3 n = normalize(dir);
	return vec2((atan(n.x, n.y) / PI2) + 0.5, acos(n.z) / PI);
}

#endregion

#region Cubemap

vec4 getCubeMapColor(vec3 normal)
{
	// Moved into function
    vec3 d = vViewPosition.xyz;
    vec3 view_r = d - 2.0 * dot(d, normal) * normal;
    vec3 dir = (uInvertedViewMatrix * vec4(view_r.xyz, 0.0)).xyz;
	
    vec3 absDir = abs(dir);
    vec3 dirOnCube; //Scaled version of dir to land on unit cube.
    vec2 uv; //Texture coordinates on the corresponding surface
    
    int samplerIndex; //What surface to sample, i.e. which face of the cube do we land on?
    
    /* Therefor we simply check which entry of dir is the largest.
        This corresponds to the axis of (i.e. perpendicular to) the cube face the vector will land on.
    */
    int maxInd = argmax3(absDir); 
    if (maxInd == 0){ //x
        //Rescale dir to land on unit cube
        dirOnCube = dir / dir.x;
        
        //Calculate location on the face from remaining vector components and rescale them to fit surface orientation.
        uv = vec2(dirOnCube.y, -sign(dir.x) * dirOnCube.z);
        
        //Select cube map surface sampler from max component's sign (i.e. do we hit the face in fron or behind?)
        samplerIndex = dir.x < 0.0 ? 1 : 0;
    }else if (maxInd == 1){ //y
        //Rescale dir to land on unit cube
        dirOnCube = dir / dir.y;
		
        //Calculate location on the face from remaining vector components and rescale them to fit surface orientation.
        uv = vec2(sign(dir.y) * dirOnCube.x, -sign(dir.y) * dirOnCube.z);
        
        //Select cube map surface sampler from max component's sign (i.e. do we hit the face in fron or behind?)
        samplerIndex = dir.y < 0.0 ? 3 : 2;
    }else{ //z
        //Rescale dir to land on unit cube
        dirOnCube = dir / dir.z;
        
        //Calculate location on the face from remaining vector components and rescale them to fit surface orientation.
        uv = vec2(-dirOnCube.x, sign(dir.z) * dirOnCube.y);
        
        //Select cube map surface sampler from max component's sign (i.e. do we hit the face in fron or behind?)
        samplerIndex = dir.z < 0.0 ? 5 : 4;
    }
	
    
    //Rescale surface coords from [-1,1] to [0,1]
    uv = (uv + vec2(1.0)) * 0.5;
    vec2 uvR = rotateUV(uv, 3.14159);
	
	// Convert the [0, 1] UV coords to the cubemap faces
	vec2 uv0 = vec2((uv.x/4.)+(1./4.)*2.,      (uv.y/3.)+(1./3.));
	vec2 uv1 = vec2((uv.x/4.),                 (uv.y/3.)+(1./3.));
	vec2 uv2 = vec2(((1.-uv.x)/4.)+(1./4.)*3., (uv.y/3.)+(1./3.));
	vec2 uv3 = vec2((uv.x/4.)+(1./4.),         (uv.y/3.)+(1./3.));
	vec2 uv4 = vec2((uvR.x/4.)+(1./4.),        (uvR.y/3.));
	vec2 uv5 = vec2((uv.x/4.)+(1./4.),         (uv.y/3.)+(1./3.)*2.);
	
    
    //Read color value from corresponding surface
    if (samplerIndex == 3){
        return texture2D(tCubemap, uv0);
    }else if (samplerIndex == 4){
        return texture2D(tCubemap, uv1);
    }else if (samplerIndex == 5){
        return texture2D(tCubemap, uv2);
    }else if (samplerIndex == 0){
        return texture2D(tCubemap, uv3);
    }else if (samplerIndex == 1){
        return texture2D(tCubemap, uv4);
    }else {
        return texture2D(tCubemap, uv5);
    }
}

#endregion

#region Diffuse Lighting

vec3 getLighting(vec4 baseColour, vec3 normal)
{
	// Final Colour
    vec3 finalColour = uLightAmbientColour + uAmbientTint.rgb;
    
	// Loop Over Lights
    for (int i = 0; i < uLightCount; i++) {
		// Get Light Position Vector (Could Also Be Directional
        vec3 lightPosition = uLightDataPrimary[i].xyz;
		
		// Get Light Type
        float type = mod(uLightDataPrimary[i].w, LIGHT_TYPES);
		
		// Light Data
        vec4 lightExt = uLightDataSecondary[i];
        vec4 lightColour = uLightDataTertiary[i];
        
		// Light Types
        if (type == LIGHT_DIRECTIONAL)
		{
            // directional light: [dx, dy, dz, type], [0, 0, 0, 0], [r, g, b, 0]
            float NdotL = max(dot(normal, lightPosition), 0.0);
            finalColour += lightColour.rgb * NdotL;
        }
		else if (type == LIGHT_POINT)
		{
            // point light: [x, y, z, type], [0, 0, range_inner, range_outer], [r, g, b, 0]
            float rangeInner = lightExt.z;
            float rangeOuter = lightExt.w;
            vec3 lightIncoming = vWorldPosition - lightPosition;
            float dist = length(lightIncoming);
            lightIncoming = normalize(-lightIncoming);
            float att = (rangeOuter - dist) / max(rangeOuter - rangeInner, 0.000001);
            
            float NdotL = max(dot(normal, lightIncoming), 0.0);
            
            finalColour += clamp(att * lightColour.rgb * NdotL, 0.0, 1.0);
        }
		else if (type == LIGHT_SPOT)
		{
            // spot light: [x, y, z, type | cutoff_inner], [dx, dy, dz, range], [r, g, b, cutoff_outer]
            vec3 sourceDir = lightExt.xyz;
            float range = lightExt.w;
            float cutoff = lightColour.w;
            float innerCutoff = ((uLightDataPrimary[i].w - type) / LIGHT_TYPES) / 128.0;
            
            vec3 lightIncoming = vWorldPosition - lightPosition;
            float dist = length(lightIncoming);
            lightIncoming = -normalize(lightIncoming);
            float NdotL = max(dot(normal, lightIncoming), 0.0);
            float lightAngleDifference = max(dot(lightIncoming, sourceDir), 0.0);
            
            float f = clamp((lightAngleDifference - cutoff) / max(innerCutoff - cutoff, 0.000001), 0.0, 1.0);
            float att = f * max((range - dist) / range, 0.0);
            
            finalColour += clamp(att * lightColour.rgb * NdotL, 0.0, 1.0);
        }
    }
    
    baseColour.rgb *= clamp(finalColour, vec3(0), vec3(1));
    
    float dist = length(vScreenPosition);
    float f = clamp((dist - uFogStart) / (uFogEnd - uFogStart), 0., 1.);
    baseColour.rgb = mix(baseColour.rgb, uFogColour, f * uFogStrength);
	
	//baseColour.rgb += .1 * vec3(pow(1. + vRim, 2.));
	
	return baseColour.rgb;
}

#endregion

#region Anisotropic Lighting

float wardSpecular(
	vec3 lightDirection,
	vec3 viewDirection,
	vec3 surfaceNormal,
	vec3 fiberParallel,
	vec3 fiberPerpendicular,
	float shinyParallel,
	float shinyPerpendicular) {

	float NdotL = dot(surfaceNormal, lightDirection);
	float NdotR = dot(surfaceNormal, viewDirection);

	if(NdotL < 0.0 || NdotR < 0.0) {
		return 0.0;
	}

	vec3 H = normalize(lightDirection + viewDirection);

	float NdotH = dot(surfaceNormal, H);
	float XdotH = dot(fiberParallel, H);
	float YdotH = dot(fiberPerpendicular, H);

	float coeff = sqrt(NdotL/NdotR) / (4.0 * PI * shinyParallel * shinyPerpendicular); 
	float theta = (pow(XdotH/shinyParallel, 2.0) + pow(YdotH/shinyPerpendicular, 2.0)) / (1.0 + NdotH);

	return coeff * exp(-2.0 * theta);
}

#endregion

#region Specular Lighting

vec3 getSpecular(vec3 normal, float specularStrength, vec2 uv, bool anisotropic)
{
	// Final Colour
    vec3 finalColour = vec3(0.);
    
	// Loop Over Lights
    for (int i = 0; i < uLightCount; i++) {
		// Get Light Position Vector (Could Also Be Directional
        vec3 lightPosition = uLightDataPrimary[i].xyz;
		
		// Get Light Type
        float type = mod(uLightDataPrimary[i].w, LIGHT_TYPES);
		
		// Light Data
        vec4 lightExt = uLightDataSecondary[i];
        vec4 lightColour = uLightDataTertiary[i];
        
		// Light Attenuation
		float att = 0.000001;
        
		float NdotL = 0.0;
		
		// Light Types
		if (type == LIGHT_DIRECTIONAL)
		{
            NdotL = clamp(dot(normal, lightPosition), 0.0, 1.0);
		}
        else if (type == LIGHT_POINT)
		{
            // point light: [x, y, z, type], [0, 0, range_inner, range_outer], [r, g, b, 0]
			// Get Light Direction
            vec3 lightIncoming = vWorldPosition - lightPosition;
            float dist = length(lightIncoming);
            lightPosition = normalize(-lightIncoming);
            float rangeInner = lightExt.z;
            float rangeOuter = lightExt.w;
			
            NdotL = clamp(dot(normal, lightIncoming), 0.0, 1.0);
			
            att = (rangeOuter - dist) / max(rangeOuter - rangeInner, 0.000001);
			att = clamp(att, 0., .25);
        }
		else if (type == LIGHT_SPOT)
		{
            // spot light: [x, y, z, type | cutoff_inner], [dx, dy, dz, range], [r, g, b, cutoff_outer]
            vec3 lightIncoming = vWorldPosition - lightPosition;
            float dist = length(lightIncoming);
            lightPosition = -normalize(lightIncoming);
        }
		
		// Get View Direction and Reflection Direction
		vec3 viewDirection = normalize(uCameraPosition - vWorldPosition);
		vec3 reflectionDirection = reflect(-lightPosition, normal);
		
		//vec3 tplane = cross(normal, vec3(0.0, 0.0, 1.0));
		//viewDirection = normalize(viewDirection - dot(viewDirection, tplane) * tplane); // project eye to texture plane
		
		//.25 * pow(max(dot(normalize(reflect(v_eyeVec, v_vNormal)), normalize(vec3(1., 1., -1.))), 0.), 15.);
		
		// Specular Calulation
		float specularAmount = 0.0;
		if (!anisotropic)
		{
			//half3 R0 = reflect(-fs_lightDir0.xyz, fs_normal);
			//specularPhong = lightColor0.rgb * pow(max(0, dot(fs_incident, R0)), specular_params.r) * lightColor0.a;
			specularAmount = pow(max(0.0, dot(viewDirection, reflectionDirection)), specularStrength) * att;
		}
		else
		{
			vec3 fiber = normalize(vec3(uv,0) - dot(vec3(uv,0), normal)*normal);
			vec3 perp = normalize(cross(fiber, normal));
			specularAmount = wardSpecular(lightPosition, viewDirection, normal, fiber, perp, clamp(1.0 - specularStrength / 27., 0.0, 0.9), clamp(specularStrength / 27., 0.0, 0.9)) * 0.5;
		}
		
		// Final Colour
		finalColour += specularAmount;
    }
	
	// Return Final Colour
	return finalColour;
}

#endregion

#region Texture Scrolling

vec2 getScroll()
{
	vec2 scrollOffset = vec2(0.0);
	
	if (uScrollType.x == SCROLL_LINEAR)
	{
		scrollOffset.x = uCurrentTime * uScrollSpeed.x;
	}
	else if (uScrollType.x == SCROLL_SINE)
	{
		scrollOffset.x = sin(uCurrentTime * 2.0 * PI * uScrollSpeed.x) * uScrollScale.x;
	}
	else if (uScrollType.x == SCROLL_COSINE)
	{
		scrollOffset.x = cos(uCurrentTime * 2.0 * PI * uScrollSpeed.x) * uScrollScale.x;
	}
	
	if (uScrollType.y == SCROLL_LINEAR)
	{
		scrollOffset.y = uCurrentTime * uScrollSpeed.y;
	}
	else if (uScrollType.y == SCROLL_SINE)
	{
		scrollOffset.y = sin(uCurrentTime * 2.0 * PI * uScrollSpeed.y) * uScrollScale.y;
	}
	else if (uScrollType.y == SCROLL_COSINE)
	{
		scrollOffset.y = cos(uCurrentTime * 2.0 * PI * uScrollSpeed.y) * uScrollScale.y;
	}
	
	return scrollOffset;
}

#endregion

// Main
void main()
{
	// Variables
	float specularStrength = 21.0 + ((uSpecularExponent / 50.0) * 5.0); // Get From Material
	float reflectionStrength = uReflectionStrength;
	
	// Get UV Sets
	vec2 surfaceUVs, normalUVs, specularUVs;
	
	if (uSurfaceUVSet == 1) surfaceUVs = vTexcoord0;
	else surfaceUVs = vTexcoord1;
	if (uNormalUVSet == 1) normalUVs = vTexcoord0;
	else normalUVs = vTexcoord1;
	if (uSpecularUVSet == 1) specularUVs = vTexcoord0;
	else specularUVs = vTexcoord1;
	
	// Get Scroll Offset
	vec2 scrollOffset = getScroll();
	
	// Base Colour
	vec4 baseColour = vColour;
	if (uUseDiffuseMap) baseColour = texture2D(gm_BaseTexture, surfaceUVs + scrollOffset) * vColour;
	else baseColour = uBlendColour * vColour;
	
	// Normal Map
	vec3 normal;
	if (uUseNormalMap)
	{
		vec4 normalMap = texture2D(tNormalMap, normalUVs) * 2.0 - 1.0;
		vec3 normalMapFixed;
		if (normalMap.a == 1.0)
		{
			normalMapFixed = normalMap.rgb;
		}
		else
		{
			normalMapFixed = vec3(normalMap.a, normalMap.g, normalMap.b);
		}
		normal = normalize(mTBN * normalMapFixed);
		//normal = normalize(vWorldNormal);
	}
	else
	{
		normal = normalize(vWorldNormal);
	}
	
	// Transparency
	if (!uTransparency) baseColour.a = 1.;
	if (baseColour.a < uAlphaTest) discard;
	
	// Lighting Calculations
	vec3 diffuse;
	if (uLightingAffected) diffuse = getLighting(baseColour, normal);
	else diffuse = baseColour.rgb;
	
	// Specular / Metallic Calulations
	vec3 specular;
	if (uSpecularHighlighting) specular = getSpecular(normal, specularStrength, surfaceUVs, false);
	else if (uMetallic) specular = getSpecular(normal, specularStrength, surfaceUVs, true);
	else specular = vec3(0.0);
	
    // Cubemap
	vec3 cubemap;
	if (uUseCubemap) cubemap = getCubeMapColor(normal).rgb;
	else cubemap = vec3(0.0);
	
    // ShineMap
	vec3 shineMap;
	if (uUseShineMap) shineMap = texture2D(tShineMap, xVec3ToEquirectangularUv(reflect(uCameraPosition, normal))).rgb * 0.35 * diffuse;
	else shineMap = vec3(0.0);
	
	// Specular Map
	float specularMap = texture2D(tSpecularMap, specularUVs).r;
	
	// Starting Fragment Colour
	vec4 fragColour = vec4((diffuse + (specular * uSpecularTint.rgb * specularMap)) + (cubemap * reflectionStrength), baseColour.a);
	//fragColour = getCubeMapColor(normal);
	
	// Frag Colour (Move to frag data)
    gl_FragColor = fragColour;
}
