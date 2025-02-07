/*
	CalicoRenderer (c) Alun Jones
	-------------------------------------------------------------------------
	Script:			CalicoRenderer
	Version:		v1.00
	Created:		15/07/2023 by Alun Jones
	Description:	Renderer
	-------------------------------------------------------------------------
	History:
	 - Created 15/07/2023 by Alun Jones
	
	To Do:
*/

function CalicoRenderer() constructor
{
	// Variables
	renderQueue = [  ];
	debugRenderQueue = [  ];
	lightingData = [  ];
	camera = new CalicoCamera();
	camera.renderer = self;
	width = window_get_width();
	height = window_get_height();
	surface = noone;
	returnSurface = noone;
	idle = true;
	timeSource = noone;
	
	// Activate
	static activate = function()
	{
		idle = false;
		if (time_source_exists(timeSource))
		{
			//ConsoleLog("Activated", CONSOLE_RENDERER);
			time_source_destroy(timeSource);
		}
	}
	
	// Update
	static deactivate = function(period = 2)
	{
		timeSource = time_source_create(time_source_global, period, time_source_units_seconds, function () {
			idle = true;
			//ConsoleLog("Deactivated", CONSOLE_RENDERER);
		});
		time_source_start(timeSource);
	}
	
	// Resize
	static resize = function(_width, _height)
	{
		width = _width;
		height = _height;
		activate();
		deactivate();
	}
	
	// Orbit Camera
	static orbitCamera = function(xx, yy)
	{
		camera.moveThird([xx, yy, xx + width, yy + height]);
		camera.stepThird(true);
	}
	
	// Render The Render Queue
	static submitRenderQueue = function()
	{
		// Set Render Target
		if (!surface_exists(surface)) surface = surface_create(width, height);
		else if (surface_get_width(surface) != width || surface_get_height(surface) != height)
		{
			surface_free(surface);
			surface = surface_create(width, height);
		}
		
		// Only Draw If Not Idle
		if (true) //!idle
		{
			surface_set_target(surface);
			
			// Camera Draw
			camera.aspectRatio = -width / height;
			camera.drawClear();
		
			// Get Main Render Queue Item Count
			var renderQueueItemCount = array_length(renderQueue);
		
			// Repeat Main Render Queue Item Count
			for (var i = renderQueueItemCount - 1; i >= 0; i--)
			{
				//if (i != 0) continue;
				// Pop Item From Render Queue
				var renderItem = renderQueue[i];
				
				// Set Matrix
				matrix_set(matrix_world, renderItem.matrix);
				
				// Submit Mesh Here
				submitMesh(renderItem.vertexBuffer, renderItem.primitive, renderItem.material, renderItem.textures, renderItem.shader, renderItem.dynamicBuffers);
			}
		
			// Repeat Debug Render Queue Item Count
			repeat (array_length(debugRenderQueue))
			{
				// Pop Item From Render Queue
				var renderItem = array_pop(debugRenderQueue);
				
				// Set Matrix
				matrix_set(matrix_world, renderItem.matrix);
				
				// Submit Mesh Here
				submitMesh(renderItem.vertexBuffer, renderItem.primitive, renderItem.material, renderItem.textures, renderItem.shader);
			}
			
			// Reset Matrix
			matrix_set(matrix_world, matrix_build_identity());
			
			// Reset Target
			surface_reset_target();
		}
		else
		{
			// Clear Debug Render Queue
			array_delete(debugRenderQueue, 0, array_length(debugRenderQueue));
		}
	}
	
	// Render Queue Clear
	static flush = function()
	{
		array_delete(renderQueue, 0, array_length(renderQueue));
		array_delete(debugRenderQueue, 0, array_length(debugRenderQueue));
	}
	
	// Render Surfaces
	static render = function()
	{
		// Set Render Target
		if (!surface_exists(returnSurface)) returnSurface = surface_create(width, height);
		else if (surface_get_width(returnSurface) != width || surface_get_height(returnSurface) != height)
		{
			surface_free(returnSurface);
			returnSurface = surface_create(width, height);
		}
		
		// Render to Return Surface
		surface_set_target(returnSurface);
		draw_clear_alpha(c_black, 0);
		if (surface_exists(surface)) draw_surface(surface, 0, 0);
		surface_reset_target();
		
		//shader_set(FXAA);
		//var tex = surface_get_texture(surface);
		//shader_set_uniform_f(shader_get_uniform(FXAA, "u_texel"), texture_get_texel_width(tex), texture_get_texel_height(tex));
		//shader_set_uniform_f(shader_get_uniform(FXAA, "u_strength"), 16);
		//draw_surface_ext(surface, width, 0, -1, 1, 0, c_white, 1);
		//shader_reset();
	}
	
	// Submit Mesh
	static submitMesh = function(vertexBuffer, primitive, material, textures, shader, dynamicBuffers = [])
	{
		switch(shader)
		{
			case "WireframeShader":
				// Push GPU State
				gpu_push_state();
				
				// Disable Z Write
				if (variable_struct_exists(material, "disableZWrite") && material.disableZWrite) gpu_set_zwriteenable(false);
				
				// Disable Z Test
				if (variable_struct_exists(material, "disableZTest") && material.disableZTest) gpu_set_ztestenable(false);
				
				// Set Wireframe Shader
				shader_set(shdWireframe);
				
				// Set Colour
				if (variable_struct_exists(material, "colour")) shader_set_uniform_f(shader_get_uniform(shdWireframe, "colour"), material.colour[0], material.colour[1], material.colour[2], material.colour[3]);
				
				// Submit Vertex Buffer
				vertex_submit(vertexBuffer, primitive, -1);
				
				// Reset Shader
				shader_reset();
				
				// Pop GPU State
				gpu_pop_state();
				break;
			case "StandardShader":
				// Push GPU State
				gpu_push_state();
				
				// Set Shader
				shader = shdStandard;
				shader_set(shader);
				
				// Set Texture Flags
				shader_set_uniform_i(shader_get_uniform(shader, "uUseDiffuseMap"),			material.textureID != -1);
				shader_set_uniform_i(shader_get_uniform(shader, "uUseNormalMap"),			(material.shaderFlags >> BT_SURFACE_SHIFT & BT_SURFACE_BITS) == BTSurfaceType.NormalMap && material.normalID != -1);
				shader_set_uniform_i(shader_get_uniform(shader, "uUseCubemap"),				(material.shaderFlags >> BT_ENVMAP_SHIFT & BT_ENVMAP_BITS) == BTEnvMapType.Cube && material.cubemapID != -1);
				shader_set_uniform_i(shader_get_uniform(shader, "uUseShineMap"),			(material.shaderFlags & BT_USE_SHINEMAP) >= 1 && material.shineID != -1);
				
				// Set Shader Flags
				shader_set_uniform_i(shader_get_uniform(shader, "uLightingAffected"),		(material.shaderFlags & BT_NO_LIGHTING) == 0);
				shader_set_uniform_i(shader_get_uniform(shader, "uSpecularHighlighting"),	(material.shaderFlags >> BT_LIGHTING_SHIFT & BT_LIGHTING_BITS) == BTLighting.Phong && (material.shaderFlags & BT_NO_LIGHTING) == 0);
				shader_set_uniform_i(shader_get_uniform(shader, "uMetallic"),				(material.shaderFlags >> BT_LIGHTING_SHIFT & BT_LIGHTING_BITS) == BTLighting.Anisotropic && (material.shaderFlags & BT_NO_LIGHTING) == 0);
				
				// Set Alpha Flags
				shader_set_uniform_i(shader_get_uniform(shader, "uTransparency"),			(material.alphaBlend >> BT_ALPHA_BLEND_SHIFT & BT_ALPHA_BLEND_BITS) != BTAlphaBlend.None);
				
				// Alpha Test
				var alphaTestFormat = (material.alphaBlend >> BT_ALPHA_TEST_SHIFT & BT_ALPHA_TEST_BITS);
	            if (alphaTestFormat == 5)
					shader_set_uniform_f(shader_get_uniform(shader, "uAlphaTest"),				(material.alphaBlend >> BT_ALPHA_TEST_SHIFT & BT_ALPHA_BLEND_BITS));
	            else
					shader_set_uniform_f(shader_get_uniform(shader, "uAlphaTest"),				2/255);
				
				// Set Shader Defines
				shader_set_uniform_f(shader_get_uniform(shader, "uBlendColour"),			material.colour[0], material.colour[1], material.colour[2], material.colour[3]);
				shader_set_uniform_f(shader_get_uniform(shader, "uAmbientTint"),			material.ambientTint[0], material.ambientTint[1], material.ambientTint[2], material.ambientTint[3]);
				shader_set_uniform_f(shader_get_uniform(shader, "uSpecularExponent"),		material.specularExponent);
				shader_set_uniform_f(shader_get_uniform(shader, "uReflectionStrength"),		material.reflectionPower);
				shader_set_uniform_f(shader_get_uniform(shader, "uCameraPosition"),			camera.position.x, camera.position.y, camera.position.z);
				
				// Lighting
				var lightingDataPrimary = array_create(calicoMaxLights * 4, 0);
				var lightingDataSecondary = array_create(calicoMaxLights * 4, 0);
				var lightingDataTertiary = array_create(calicoMaxLights * 4, 0);
				var currentLight = 0;
				for (var i = 0; i < array_length(lightingData); i++)
				{
					// Current Light
					var light = lightingData[i];
					
					// Check Light Type
					switch(light.type)
					{
						case "Ambient":
							shader_set_uniform_f(shader_get_uniform(shader, "uLightAmbientColour"), light.colour[0], light.colour[1], light.colour[2]);
							break;
						case "Fog":
							shader_set_uniform_f(shader_get_uniform(shader, "uFogColour"), light.colour[0], light.colour[1], light.colour[2]);
							shader_set_uniform_f(shader_get_uniform(shader, "uFogStrength"), light.strength);
							shader_set_uniform_f(shader_get_uniform(shader, "uFogStart"), light.cutoffInner);
							shader_set_uniform_f(shader_get_uniform(shader, "uFogEnd"), light.cutoff);
							break;
						case "Direction":
							lightingDataPrimary[currentLight * 4] = light.vector[0];
							lightingDataPrimary[currentLight * 4 + 1] = light.vector[1];
							lightingDataPrimary[currentLight * 4 + 2] = light.vector[2];
							lightingDataPrimary[currentLight * 4 + 3] = calicoLightType.directional;
							lightingDataTertiary[currentLight * 4] = light.colour[0];
							lightingDataTertiary[currentLight * 4 + 1] = light.colour[1];
							lightingDataTertiary[currentLight * 4 + 2] = light.colour[2];
							currentLight++;
							break;
						case "Point":
							lightingDataPrimary[currentLight * 4] = light.vector[0];
							lightingDataPrimary[currentLight * 4 + 1] = light.vector[1];
							lightingDataPrimary[currentLight * 4 + 2] = light.vector[2];
							lightingDataPrimary[currentLight * 4 + 3] = calicoLightType.point;
							lightingDataSecondary[currentLight * 4 + 2] = light.innerStrength;
							lightingDataSecondary[currentLight * 4 + 3] = light.outerStrength;
							lightingDataTertiary[currentLight * 4] = light.colour[0];
							lightingDataTertiary[currentLight * 4 + 1] = light.colour[1];
							lightingDataTertiary[currentLight * 4 + 2] = light.colour[2];
							currentLight++;
							break;
					}
				}
				shader_set_uniform_i(shader_get_uniform(shader, "uLightCount"), array_length(lightingData) - 2);
				shader_set_uniform_f_array(shader_get_uniform(shader, "uLightDataPrimary"), lightingDataPrimary);
				shader_set_uniform_f_array(shader_get_uniform(shader, "uLightDataSecondary"), lightingDataSecondary);
				shader_set_uniform_f_array(shader_get_uniform(shader, "uLightDataTertiary"), lightingDataTertiary);
				shader_set_uniform_matrix_array(shader_get_uniform(shader, "uInvertedViewMatrix"), matrix_inverse(matrix_get(matrix_view)));
				
				//shader_set_uniform_matrix_array(shader_get_uniform(shader, "bones"), ctrlScene.test.armature.bonesAnimated);
				
				// Set GPU Settings
				gpu_set_tex_mip_enable(mip_on);
				gpu_set_tex_mip_filter(tf_anisotropic);
				
				// Set Diffuse Texture
				var texture = -1;
				if (material.textureID != -1)	texture = textures[material.textureID].texture;
				
				// Set Textures
				if (material.normalID != -1)				texture_set_stage(shader_get_sampler_index(shader, "tNormalMap"), textures[material.normalID].texture);
				if (material.cubemapID != -1)				texture_set_stage(shader_get_sampler_index(shader, "tCubemap"), textures[material.cubemapID].texture);
				if (material.shineID != -1)					texture_set_stage(shader_get_sampler_index(shader, "tShineMap"), textures[material.shineID].texture);
				//texture_set_stage(shader_get_sampler_index(shader, "tCubemap"), sprite_get_texture(GoldCubemap, 0));
				
				// Dynamic Buffers
				//if (ENVIRONMENT.dynamicBufferIndex != -1 && array_length(dynamicBuffers) > ENVIRONMENT.dynamicBufferIndex)
				//{
				//	if (dynamicBuffers[ENVIRONMENT.dynamicBufferIndex] != -1)
				//	{
				//		shader_set_uniform_i(shader_get_uniform(shader, "uUseDynamicBuffer"), ENVIRONMENT.dynamicBufferIndex != -1);
				//		shader_set_uniform_f_array(shader_get_uniform(shader, "uDynamicBuffer"), dynamicBuffers[ENVIRONMENT.dynamicBufferIndex]);
				//	}
				//}
				
				// Culling
				if ((material.alphaBlend >> BT_CULLMODE_SHIFT & BT_CULLMODE_BITS) == BTCullmode.CullClockwise) gpu_set_cullmode(cull_clockwise);
				else if ((material.alphaBlend >> BT_CULLMODE_SHIFT & BT_CULLMODE_BITS) == BTCullmode.NoCulling) gpu_set_cullmode(cull_noculling);
				else gpu_set_cullmode(cull_counterclockwise);
				
				// Alpha Blending
				if ((material.alphaBlend >> BT_ALPHA_BLEND_SHIFT & BT_ALPHA_BLEND_BITS) == BTAlphaBlend.Transparent)
				{
					gpu_set_blendenable(true);
					gpu_set_alphatestenable(true);
					gpu_set_blendequation(bm_eq_add);
					gpu_set_blendmode_ext(bm_src_alpha, bm_inv_src_alpha);
				}
				else if ((material.alphaBlend >> BT_ALPHA_BLEND_SHIFT & BT_ALPHA_BLEND_BITS) == BTAlphaBlend.TransparentIgnoreDestination)
				{
					gpu_set_blendenable(true);
					gpu_set_alphatestenable(true);
					gpu_set_blendequation(bm_eq_add);
					gpu_set_blendmode_ext(bm_src_alpha, bm_one);
				}
				else if ((material.alphaBlend >> BT_ALPHA_BLEND_SHIFT & BT_ALPHA_BLEND_BITS) == BTAlphaBlend.ReverseTransparent)
				{
					gpu_set_blendenable(true);
					gpu_set_alphatestenable(true);
					gpu_set_blendequation(bm_eq_reverse_subtract);
					gpu_set_blendmode_ext(bm_zero, bm_inv_src_alpha);
				}
				else if ((material.alphaBlend >> BT_ALPHA_BLEND_SHIFT & BT_ALPHA_BLEND_BITS) == BTAlphaBlend.NoneFixedAlpha)
				{
					gpu_set_blendenable(false);
					gpu_set_alphatestenable(true);
					gpu_set_alphatestref(0);
				}
				else
				{
					gpu_set_alphatestenable(false);
					gpu_set_blendenable(false);
				}
				
				// Depth
				if ((material.alphaBlend >> BT_DEPTH_TYPE_SHIFT & BT_DEPTH_TYPE_BITS) == BTDepthType.Normal)
				{
					gpu_set_ztestenable(true);
					gpu_set_zwriteenable(true);
					gpu_set_zfunc(cmpfunc_lessequal);
				}
				else if ((material.alphaBlend >> BT_DEPTH_TYPE_SHIFT & BT_DEPTH_TYPE_BITS) == BTDepthType.NoWrite)
				{
					gpu_set_ztestenable(true);
					gpu_set_zwriteenable(false);
					gpu_set_zfunc(cmpfunc_lessequal);
				}
				else if ((material.alphaBlend >> BT_DEPTH_TYPE_SHIFT & BT_DEPTH_TYPE_BITS) == BTDepthType.AlwaysPass)
				{
					gpu_set_ztestenable(true);
					gpu_set_zwriteenable(true);
					gpu_set_zfunc(cmpfunc_always);
				}
				else if ((material.alphaBlend >> BT_DEPTH_TYPE_SHIFT & BT_DEPTH_TYPE_BITS) == BTDepthType.IgnoreDepth)
				{
					gpu_set_ztestenable(false);
					gpu_set_zwriteenable(true);
				}
				
				// Submit Vertex Buffer
				vertex_submit(vertexBuffer, primitive, texture);
				
				// Reset GPU State
				gpu_pop_state();
				
				// Reset Shader
				shader_reset();
				break;
		}
	}
}