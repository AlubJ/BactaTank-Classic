/*
	BactaRenderer (c) Alun Jones
	-------------------------------------------------------------------------
	Script:			BactaRenderer
	Version:		v1.00
	Created:		03/11/2025 by Alun Jones
	Description:	BactaTank Renderer
	-------------------------------------------------------------------------
	History:
	 - Created 03/11/2025 by Alun Jones
	 
	To do:
	
*/

// Render queue type (unsure if this will be used or not)
enum _BACTA_RENDER_QUEUE
{
	STATIC,
	DYNAMIC,
	DEBUG,
}

// Prepare shader interfaces
#macro BACTA_SHADERS		global.__bactaShaders__
BACTA_SHADERS = {
	DebugShader: new BactaDebugShaderInterface(),
};

/// @func BactaRenderer()
/// @desc Create BactaTank renderer.
function BactaRenderer() constructor
{
	// Define render queues
	// We want to minimize the work on the CPU and garbage collector as much as possible, reusing arrays and not clearing them to push identical stuff to them is imperitive.
	__staticRenderQueue		= [ ];
	__dynamicRenderQueue	= [ ];
	__debugRenderQueue		= [ ];
	
	// Lighting data
	__ambientLight = [ 1.0, 1.0, 1.0, 1.0 ];
	__fog = {
		colour: [ 0.0, 0.0, 0.0, 0.0 ],
		strength: 0,
		start: 0,
		finish: 0,
	};
	
	var _lightingDataPrimary	= array_create(BACTA_MAX_LIGHTS * 4, 0);
	var _lightingDataSecondary	= array_create(BACTA_MAX_LIGHTS * 4, 0);
	var _lightingDataTertiary	= array_create(BACTA_MAX_LIGHTS * 4, 0);
	__lightingData = [ _lightingDataPrimary, _lightingDataSecondary, _lightingDataTertiary ];
	__lightCount = 0;
	
	// Camera (We should only ever have one camera and snap it when we want a "cut" to happen)
	__camera = new BactaCamera();
	__activeCamera = __camera;
	
	// Render Surface
	__width = WINDOW_WIDTH;
	__height = WINDOW_HEIGHT;
	__renderSurface = noone;
	
	#region Render Methods
	
	/// @func submit()
	/// @desc Submit all of the render items to the frame buffer.
	static submit = function()
	{
		// Debug Data
		var _staticVertices = 0;
		var _dynamicVertices = 0;
		var _debugVertices = 0;
		var _staticDrawCalls = 0;
		var _dynamicDrawCalls = 0;
		var _debugDrawCalls = 0;
		
		// Set render target
		if (!surface_exists(__renderSurface)) __renderSurface = surface_create(__width, __height);
		if (surface_get_width(__renderSurface) != __width || surface_get_height(__renderSurface) != __height) surface_resize(__renderSurface, __width, __height);
		surface_set_target(__renderSurface);
		
		// Submit the camera
		// __activeCamera.setAspect(__width, __height);
		__activeCamera.submit(false);
		
		// Static timer
		//var _staticTime = get_timer();
		
		// Get static render queue item count
		var _staticRenderQueueSize = array_length(__staticRenderQueue);
		
		// Loop over static render items
		for (var _i = 0; _i < _staticRenderQueueSize; _i++)
		{
			// Get the render item
			var _renderItem = __staticRenderQueue[_i];
			
			// Submit the mesh
			submitRenderItem(_renderItem);
			
			// Debug Data
			//_staticDrawCalls++;
			//_staticVertices += vertex_get_number(_renderItem.vertexBuffer);
		}
		
		// Static timer
		//_staticTime = (get_timer() - _staticTime) / 1000;
		
		// Dynamic timer
		//var _dynamicTime = get_timer();
		
		// Get dynamic render queue item count
		var _dynamicRenderQueueSize = array_length(__dynamicRenderQueue);
		
		// Loop over dynamic render items
		repeat(_dynamicRenderQueueSize)
		{
			// Get the render item
			var _renderItem = array_shift(__dynamicRenderQueue);
			
			// Submit the mesh
			submitRenderItem(_renderItem);
			
			// Debug Data
			//_dynamicDrawCalls++;
			//_dynamicVertices += vertex_get_number(_renderItem.vertexBuffer);
		}
		
		// Dynamic timer
		//_dynamicTime = (get_timer() - _dynamicTime) / 1000;
		
		// Debug timer
		//var _debugTime = get_timer();
		
		// Get debug render queue item count
		var _debugRenderQueueSize = array_length(__debugRenderQueue);
		
		// Loop over dynamic render items
		repeat(_debugRenderQueueSize)
		{
			// Get the render item
			var _renderItem = array_shift(__debugRenderQueue);
			
			// Submit the mesh
			submitRenderItem(_renderItem);
			
			// Debug Data
			//_debugDrawCalls++;
			//_debugVertices += vertex_get_number(_renderItem.vertexBuffer);
		}
		
		// Debug timer
		//var _debugTime = (get_timer() - _debugTime) / 1000;
		
		// Reset matrix
		matrix_set(matrix_world, matrix_build_identity());
		
		// Set GPU settings
		gpu_set_ztestenable(true);
		gpu_set_zwriteenable(true);
		
		// Reset render target
		surface_reset_target();
	}
	
	/// @func submitRenderItem(renderItem)
	/// @desc Submit the current render item to the frame buffer.
	/// @arg  {Struct} renderItem The render item to be submitted.
	static submitRenderItem = function(_renderItem)
	{
		// Set the render items matrix
		matrix_set(matrix_world, _renderItem.matrix);
		
		// Get camera distance
		var _cameraDistance = point_distance_3d(__activeCamera.position[0], __activeCamera.position[1], __activeCamera.position[2], _renderItem.matrix[12], _renderItem.matrix[13], _renderItem.matrix[14]);
		
		// Shader
		switch (_renderItem.shader)
		{
			case "CalicoStandardShader":
				// Set GPU state
				BACTA_SHADERS.StandardShader.setGPUState(_renderItem.material);
				
				// Bind to the shader
				var _texture = BACTA_SHADERS.StandardShader.bind(_renderItem.material, __activeCamera, noone, _renderItem.prevSubmitBones, _renderItem.nextSubmitBones, _renderItem.interpolationTime);
				
				// Submit the mesh
				BACTA_SHADERS.StandardShader.submit(_renderItem.vertexBuffer, pr_trianglelist, _texture);
				
				// Reset GPU state
				BACTA_SHADERS.StandardShader.resetGPUState();
				
				// Break
				break;
			case "CalicoWireframeShader":
				// Set GPU state
				BACTA_SHADERS.WireframeShader.setGPUState(_renderItem.material);
				
				// Bind to the shader
				var _texture = BACTA_SHADERS.WireframeShader.bind(_renderItem.material, __activeCamera, noone, _renderItem.prevSubmitBones, _renderItem.nextSubmitBones, _renderItem.interpolationTime);
				
				// Submit the mesh
				BACTA_SHADERS.WireframeShader.submit(_renderItem.vertexBuffer, pr_linelist, _texture);
				
				// Reset GPU state
				BACTA_SHADERS.WireframeShader.resetGPUState();
				
				// Break
				break;
			case "BactaDebugShader":
				// Set GPU state
				BACTA_SHADERS.DebugShader.setGPUState(_renderItem.material);
				
				// Bind to the shader
				var _texture = BACTA_SHADERS.DebugShader.bind(_renderItem.material, {  }, __activeCamera);
				
				// Submit the mesh
				BACTA_SHADERS.DebugShader.submit(_renderItem.vertexBuffer, pr_trianglelist, _texture);
				
				// Reset GPU state
				BACTA_SHADERS.DebugShader.resetGPUState();
				
				// Break
				break;
		}
	}
	
	/// @func render([width], [height])
	/// @desc Render the surface onto the screen.
	/// @arg  {Real} [width] The width to render to.
	/// @arg  {Real} [height] The height to render to.
	static render = function(_width = WINDOW_WIDTH, _height = WINDOW_WIDTH)
	{
		//if (surface_exists(surface)) ppfx.Draw(surface, 0, 0, width, height, width / 3, height / 3);
		
		// Push the GPU state
		gpu_push_state();
		gpu_set_tex_filter(false);
		
		// Render surface
		//shader_set(shdPPShading);
		//texture_set_stage(shader_get_sampler_index(shdPPShading, "tShading"), sprite_get_texture(shading, 0));
		if (surface_exists(__renderSurface)) draw_surface_stretched(__renderSurface, 0, 0, _width, _height);
		//shader_reset();
		
		//if (surface_exists(shadowProbe.surface)) draw_surface_stretched(shadowProbe.surface, 0, 0, 128, 128);
		//draw_circle(_width / 2, _height / 2, 1, false);
		
		// Reset GPU state
		gpu_pop_state();
		//if (surface_exists(surface)) draw_surface(surface, 0, 0);
		//if (keyboard_check_pressed(vk_space)) surface_save(surface, "what.png"); //DELETE THIS LINE NEXT TIME YOU FUCKING IDIOT!!!
	}
	
	#endregion
	
	#region Render Queue Methods
	
	/// @func flush()
	/// @desc Flush the static render queue.
	static flush = function()
	{
		// Clear the array
		array_delete(__staticRenderQueue, 0, infinity);
	}
	
	#endregion
	
	#region Lighting Data Methods
	
	/// @func pushLight(light)
	/// @desc Push a light to the lighting data array.
	/// @arg  {Struct} light The light data to push.
	static pushLight = function(_light)
	{
		// Check Light Type
		switch(_light.type)
		{
			case "Ambient":
				__ambientLight = [ _light.colour[0], _light.colour[1], _light.colour[2] ];
				break;
			case "Fog":
				__fog.colour = [ _light.colour[0], _light.colour[1], _light.colour[2] ];
				__fog.strength = _light.strength;
				__fog.start = _light.cutoffInner;
				__fog.finish = _light.cutoff;
				break;
			case "Direction":
				__lightingData[0][__lightCount * 4] = _light.vector[0];
				__lightingData[0][__lightCount * 4 + 1] = _light.vector[1];
				__lightingData[0][__lightCount * 4 + 2] = _light.vector[2];
				__lightingData[0][__lightCount * 4 + 3] = _BACTA_LIGHT_TYPE.DIRECTIONAL;
				__lightingData[2][__lightCount * 4] = _light.colour[0];
				__lightingData[2][__lightCount * 4 + 1] = _light.colour[1];
				__lightingData[2][__lightCount * 4 + 2] = _light.colour[2];
				__lightCount++;
				break;
			case "Point":
				__lightingData[0][__lightCount * 4] = _light.vector[0];
				__lightingData[0][__lightCount * 4 + 1] = _light.vector[1];
				__lightingData[0][__lightCount * 4 + 2] = _light.vector[2];
				__lightingData[0][__lightCount * 4 + 3] = _BACTA_LIGHT_TYPE.POINT;
				__lightingData[1][__lightCount * 4 + 2] = _light.innerStrength;
				__lightingData[1][__lightCount * 4 + 3] = _light.outerStrength;
				__lightingData[2][__lightCount * 4] = _light.colour[0];
				__lightingData[2][__lightCount * 4 + 1] = _light.colour[1];
				__lightingData[2][__lightCount * 4 + 2] = _light.colour[2];
				__lightCount++;
				break;
		}
	}
	
	/// @func flushLights()
	/// @desc Flush lighting data
	static flushLights = function()
	{
		// Reset all lighting arrays
		for (var _i = 0; _i < BACTA_MAX_LIGHTS * 4; _i++)
		{
			__lightingData[0][_i] = 0;
			__lightingData[1][_i] = 0;
			__lightingData[2][_i] = 0;
		}
		
		// Reset fog and ambient
		__ambientLight = [ 1.0, 1.0, 1.0 ];
		__fog.colour = [ 0.0, 0.0, 0.0 ];
		__fog.strength = 0;
		__fog.start = 0;
		__fog.finish = 0;
		
		// Light Count
		__lightCount = 0;
	}
	
	#endregion
}

/// @func BactaRenderItem()
/// @desc A render item for BactaTank.
function BactaRenderItem() constructor
{
	// Name for debugging
	name = "";
	
	// Vertex buffer to submit
	vertexBuffer = noone;
	
	// Shader to use
	shader = "BactaDefaultShader";
	
	// The Material to use
	material = noone;
	
	// Textures ref struct
	textures = {};
	
	// The transformation matrix
	matrix = [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1];
}