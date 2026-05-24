/*
	__BACTA_MACROS (c) Alun Jones
	-------------------------------------------------------------------------
	Script:			__BACTA_MACROS
	Version:		v1.00
	Created:		03/11/2025 by Alun Jones
	Description:	General BactaTank macros
	-------------------------------------------------------------------------
	History:
	 - Created 03/11/2025 by Alun Jones
	 
	To do:
	
*/

#region Renderer

// Create renderers macros
#macro PRIMARY_RENDERER			global.__primaryRenderer__
#macro SECONDARY_RENDERER		global.__secondaryRenderer__

// Create renderers
PRIMARY_RENDERER = new BactaRenderer();

#endregion

#region Debugging

// Run from IDE
#macro RUN_FROM_IDE				global.__runFromIDE__
RUN_FROM_IDE					= (parameter_count() == 3 && string_count("GMS2TEMP", parameter_string(2)));

#endregion