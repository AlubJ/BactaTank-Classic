/*
	ctrlRenderer.Create (c) Alun Jones
	-------------------------------------------------------------------------
	Script:			ctrlRenderer.Create
	Version:		v1.00
	Created:		03/11/2025 by Alun Jones
	Description:	Renderer create event
	-------------------------------------------------------------------------
	History:
	 - Created 03/11/2025 by Alun Jones
	 
	To do:
	
*/


// Debug
vertex_format_begin();
vertex_format_add_position_3d();
vertexFormat = vertex_format_end();

var buffer = buffer_load("test.vbx");
vertexBuffer = vertex_create_buffer_from_buffer(buffer, vertexFormat);
buffer_delete(buffer);

var renderItem = new BactaRenderItem();
renderItem.material = {
	colour: c_red,	
};
renderItem.vertexBuffer = vertexBuffer;
renderItem.shader = "BactaDebugShader";

array_push(PRIMARY_RENDERER.__staticRenderQueue, renderItem);