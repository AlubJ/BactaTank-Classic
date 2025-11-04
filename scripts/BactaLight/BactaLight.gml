/*
	BactaLight (c) Alun Jones
	-------------------------------------------------------------------------
	Script:			BactaLight
	Version:		v1.00
	Created:		04/11/2025 by Alun Jones
	Description:	Light
	-------------------------------------------------------------------------
	History:
	 - Created 04/11/2025 by Alun Jones
	
	To Do:
	 - Rewrite Lighting System
*/
	
// Lighting Macros
#macro BACTA_LIGHTDATA_SIZE				  12

// Lighting Types
enum _BACTA_LIGHT_TYPE
{
	NONE,
	DIRECTIONAL,
	POINT,
	SPOT,
}

/// @func BactaLight()
/// @desc BactaTank light constructor.
function BactaLight() constructor
{
	// Attributes
	name = "Light";
	type = -1;
	colour = [1.0, 1.0, 1.0];
	strength = 0;
	cutoff = 0;
	cutoffInner = 0;
	vector = [1, 1, -1];
	position = [0, 0, 0];
	outerStrength = 10;
	innerStrength = 0;
}