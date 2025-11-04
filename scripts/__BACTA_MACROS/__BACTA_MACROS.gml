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