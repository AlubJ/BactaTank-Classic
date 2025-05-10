/// @desc Render ImGui
/*
	ctrlRenderer.DrawGUI
	-------------------------------------------------------------------------
	Script:			ctrlRenderer.DrawGUI
	Version:		v1.00
	Created:		15/11/2024 by Alun Jones
	Description:	Draw The GUI
	-------------------------------------------------------------------------
	History:
	 - Created 15/11/2024 by Alun Jones
	
	To Do:
*/
gpu_set_tex_filter(false);
gpu_set_tex_mip_filter(tf_point);
gpu_set_alphatestref(0);
draw_clear(THEME_BG);
if (window_get_width() > 0 && window_get_height() > 0) ImGui.__Draw();
//if (surface_exists(RENDERER.surface)) draw_surface(RENDERER.surface, 0, 0);
gpu_set_tex_mip_filter(tf_anisotropic);
gpu_set_alphatestref(254);
gpu_set_tex_filter(true);

// Draw Game Frame
//gameframe_draw();

//if (keyboard_check_pressed(vk_space))
//{
//	//model.saveGHG("QUIGONJINN_PC.GHG");
	
//	var cachedMesh = buffer_create_from_vertex_buffer(PROJECT.currentModel.meshes[2].vertexBufferObject, buffer_fixed, 1);
//	buffer_save(cachedMesh, "saber.mesh");
//	buffer_delete(cachedMesh);
	
//	surface_save(RENDERER.surface, "aaaaa.png");
//}