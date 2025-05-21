/// @desc Submit Render Queue
/*
	ctrlRenderer.Draw
	-------------------------------------------------------------------------
	Script:			ctrlRenderer.Draw
	Version:		v1.00
	Created:		10/01/2024 by Alun Jones
	Description:	Submit Render Queue
	-------------------------------------------------------------------------
	History:
	 - Created 10/01/2024 by Alun Jones
	
	To Do:
*/

//ImGui.__Render();

RENDERER.submitRenderQueue();

//array_push(RENDERER.debugRenderQueue, {
//	vertexBuffer: PRIMITIVES.sphere,
//	material: model.materials[0],
//	textures: model.textures,
//	matrix: matrix_build_identity(),
//	shader: "StandardShader",
//	primitive: pr_trianglestrip,
//});
SECONDARY_RENDERER.submitRenderQueue();