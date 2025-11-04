/*
	BactaDebugShaderInterface (c) Alun Jones
	-------------------------------------------------------------------------
	Script:			BactaDebugShaderInterface
	Version:		v1.00
	Created:		04/11/2025 by Alun Jones
	Description:	Debug Shader Interface
	-------------------------------------------------------------------------
	History:
	 - Created 04/11/2025 by Alun Jones
	
	To Do:
	
	Info:
*/

function BactaDebugShaderInterface() constructor
{
	// Shader
	__shader = BactaDebugShader;
	
	// Uniforms
	__uniforms = {
		uColour:	shader_get_uniform(__shader, "uColour"),
	}
	
	#region Methods
	
	// Set GPU State
	static setGPUState = function(_material)
	{
		// Push GPU State
		gpu_push_state();
		
		// Set Render Flags
		gpu_set_ztestenable(true);
		gpu_set_zwriteenable(true);
	}
	
	// Reset GPU State
	static resetGPUState = function()
	{
		// Reset GPU State
		gpu_pop_state();
		
		// Reset Shader
		shader_reset();
	}
	
	// Bind
	static bind = function(_material, _textures, _camera)
	{
		// Set Shader
		shader_set(__shader);
		
		// Set Colour
		var _colour = _material.colour;
		shader_set_uniform_f(__uniforms.uColour, colour_get_red(_colour) / 255, colour_get_blue(_colour) / 255, colour_get_green(_colour) / 255, 1.0);
		
		// Return Texture
		return -1;
	}
	
	// Push Vertex Buffer
	static submit = function(vertexBuffer, primitive, texture)
	{
		// Submit Vertex Buffer
		vertex_submit(vertexBuffer, primitive, texture);
	}
	
	#endregion
}