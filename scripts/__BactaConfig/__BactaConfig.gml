/*
	__BACTA_CONFIG (c) Alun Jones
	-------------------------------------------------------------------------
	Script:			__BACTA_CONFIG
	Version:		v1.00
	Created:		03/11/2025 by Alun Jones
	Description:	BactaTank Configuration
	-------------------------------------------------------------------------
	History:
	 - Created 03/11/2025 by Alun Jones
	 
	To do:
	
*/

#region Version

// Main version
#macro VERSION	0.4

#endregion

#region Renderer

// Max lights
#macro BACTA_MAX_LIGHTS			((os_type == os_windows) ? 64 : 16)

// Target frame rate
#macro BACTA_TARGET_FRAMERATE	60

#endregion