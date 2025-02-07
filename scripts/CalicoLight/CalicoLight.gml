/*
	CalicoLight (c) Alun Jones
	-------------------------------------------------------------------------
	Script:			CalicoLight
	Version:		v1.00
	Created:		15/07/2023 by Alun Jones
	Description:	Resource
	-------------------------------------------------------------------------
	History:
	 - Created 15/07/2023 by Alun Jones
	
	To Do:
*/

#macro calicoMaxLights 64

enum calicoLightType {
	none,
	directional,
	point,
	spot,
}

function CalicoLight() constructor
{
	// Attributes
	name = "Light";
	type = "";
	colour = [1.0, 1.0, 1.0];
	strength = 0;
	cutoff = 0;
	cutoffInner = 0;
	vector = [1, 1, -1];
	position = [0, 0, 0];
	outerStrength = 10;
	innerStrength = 0;
}