/*
	CalicoCamera (c) Alun Jones
	-------------------------------------------------------------------------
	Script:			CalicoCamera
	Version:		v1.00
	Created:		15/07/2023 by Alun Jones
	Description:	Resource
	-------------------------------------------------------------------------
	History:
	 - Created 15/07/2023 by Alun Jones
	
	To Do:
*/

function CalicoCamera() constructor
{
	// Create Camera
	camera = camera_create();
	camera_set_default(camera);
	
	#region Camera Variables
	
	position = {x:0, y:0, z:0};
	lookAtPosition = {x:0, y:0, z:0};
	positionSmooth = {x:0, y:0, z:0};
	lookAtPositionSmooth = {x:0, y:0, z:0};
	upVector = {x:0, y:-1, z:0};
	
	zNear = 0.01;
	zFar = 50;
	
	aspectRatio = window_get_width() / window_get_height();
	fov = 50;
	
	viewMatrix = matrix_build_lookat(position.x, position.y, position.z, lookAtPosition.x, lookAtPosition.y, lookAtPosition.z, upVector.x, upVector.y, upVector.z);
	projMatrix = matrix_build_projection_perspective_fov(fov, aspectRatio, zNear, zFar);
	
	#endregion
	
	lookDirection = 0;
	lookDirectionSmooth = 0;
	lookPitch = 0;
	lookPitchSmooth = 0;
	
	lookDistance = 0.6;
	lookDistanceSmooth = 0.6;
	sensitivity = 0.3;
	smoothStep = 5;
	
	active = false;
	
	renderer = noone;
	
	static draw = function()
	{
		draw_clear(make_color_rgb(0, 0, 0));
		viewMatrix = matrix_build_lookat(
		position.x, position.y, position.z,
		lookAtPosition.x, lookAtPosition.y, lookAtPosition.z,
		upVector.x, upVector.y, upVector.z);
		projMatrix = matrix_build_projection_perspective_fov(fov, aspectRatio, zNear, zFar);
		camera_set_view_mat(camera, viewMatrix);
		camera_set_proj_mat(camera, projMatrix);
		camera_apply(camera);
	}
	
	static drawClear = function() {
		draw_clear_alpha(c_black, 0);
		viewMatrix = matrix_build_lookat(
		position.x, position.y, position.z,
		lookAtPosition.x, lookAtPosition.y, lookAtPosition.z,
		upVector.x, upVector.y, upVector.z);
		projMatrix = matrix_build_projection_perspective_fov(fov, aspectRatio, zNear, zFar);
		camera_set_view_mat(camera, viewMatrix);
		camera_set_proj_mat(camera, projMatrix);
		camera_apply(camera);
	}
	
	static reset = function()
	{
		position = {x:0, y:0, z:0};
		lookAtPosition = {x:0, y:0, z:0};
		positionSmooth = {x:0, y:0, z:0};
		lookAtPositionSmooth = {x:0, y:0, z:0};
	
		lookDirection = -45;
		lookDirectionSmooth = -45;
		lookPitch = -20;
		lookPitchSmooth = -20;
	
		lookDistance = 0.6;
		lookDistanceSmooth = 0.6;
		
		renderer.activate();
		renderer.deactivate(1);
	}
	
	static moveThird = function(bounds = [0, 0, WINDOW_SIZE[0], WINDOW_SIZE[1]]) {
		if (CURSOR_POSITION[0] > bounds[0] && CURSOR_POSITION[0] < bounds[2] && CURSOR_POSITION[1] > bounds[1] && CURSOR_POSITION[1] < bounds[3])
		{
			if ((device_mouse_check_button_pressed(0, mb_left) || device_mouse_check_button_pressed(0, mb_right)) || device_mouse_check_button(0, mb_middle) && !active)
			{
				renderer.activate();
				active = true;
				window_set_cursor(device_mouse_check_button(0, mb_middle) ? cr_size_ns : cr_size_all);
			}
			
			if (mouse_wheel_up())
			{
				lookDistance -= (lookDistance / 4);
				renderer.activate();
				renderer.deactivate(1);
			}
			
			if (mouse_wheel_down())
			{
				lookDistance += (lookDistance / 3);
				renderer.activate();
				renderer.deactivate(1);
			}
		}
		
		if (device_mouse_check_button(0, mb_left) && !renderer.idle && active)
		{
			lookDirection += window_mouse_get_delta_x() * sensitivity;
			lookPitch -= window_mouse_get_delta_y() * sensitivity;
			lookPitch = clamp(lookPitch, -89.999, 89.999);
		}
		else if (device_mouse_check_button(0, mb_right) && !renderer.idle && active)
		{
			vectorH = [
				dcos(lookDirectionSmooth - 90),
				dsin(lookPitchSmooth + 90),
				dsin(lookDirectionSmooth - 90)];
			//var matrix = matrix_build(0, 0, 0, lookPitch, lookDirection, 0, 1, 1, 1);
			//lookAtPosition.x += matrix[4] * window_mouse_get_delta_x() * 0.001 + matrix[8] * window_mouse_get_delta_y() * 0.001;
			//lookAtPosition.z += matrix[5] * window_mouse_get_delta_x() * 0.001 + matrix[9] * window_mouse_get_delta_y() * 0.001;
			//lookAtPosition.y += matrix[6] * window_mouse_get_delta_x() * 0.001 + matrix[10] * window_mouse_get_delta_y() * 0.001;
			
			lookAtPosition.x += vectorH[0] * window_mouse_get_delta_x() * 0.001;
			lookAtPosition.z -= vectorH[2] * window_mouse_get_delta_x() * 0.001;
			lookAtPosition.y += vectorH[1] * window_mouse_get_delta_y() * 0.001;
			
			//lookAtPosition.x += dsin(lookDirection) * window_mouse_get_delta_x() * 0.001;
			//lookAtPosition.z += dcos(lookDirection) * window_mouse_get_delta_x() * 0.001;
			//lookAtPosition.y += dcos(lookPitch) * window_mouse_get_delta_y() * 0.001;
		}
		else if (device_mouse_check_button(0, mb_middle) && !renderer.idle && active)
		{
			lookDistance += window_mouse_get_delta_y() * 0.005;
		}
		
		if ((device_mouse_check_button_released(0, mb_left) || device_mouse_check_button_released(0, mb_right)) || device_mouse_check_button_released(0, mb_middle) && active)
		{
			renderer.deactivate(1);
			active = false;
			window_set_cursor(cr_default);
		}
		
		lookAtPosition.x = clamp(lookAtPosition.x, -20, 20);
		lookAtPosition.y = clamp(lookAtPosition.y, -20, 20);
		lookAtPosition.z = clamp(lookAtPosition.z, -20, 20);
		
		lookDistance = clamp(lookDistance, 0.05, 10);
		
		//if (active)
		//{
		//	if (CURSOR_POSITION[0] < bounds[0]) window_mouse_set(bounds[2], CURSOR_POSITION[1]);
		//	else if (CURSOR_POSITION[0] > bounds[2]) window_mouse_set(bounds[0], CURSOR_POSITION[1]);
		//	if (CURSOR_POSITION[1] < bounds[1]) window_mouse_set(CURSOR_POSITION[0], bounds[3]);
		//	else if (CURSOR_POSITION[1] > bounds[3]) window_mouse_set(CURSOR_POSITION[0], bounds[1]);
		//}
	}
	
	static step = function(smooth = false)
	{
		if (smooth)
		{
			lookDirectionSmooth += (lookDirection - lookDirectionSmooth) / smoothStep;
			lookPitchSmooth += (lookPitch - lookPitchSmooth) / smoothStep;
		}
		else
		{
			lookDirectionSmooth = lookDirection;
			lookPitchSmooth = lookPitch;
		}
		
		lookAtPosition.x = position.x - dcos(lookDirectionSmooth) * dcos(lookPitchSmooth);
		lookAtPosition.z = position.z + dsin(lookDirectionSmooth) * dcos(lookPitchSmooth);
		lookAtPosition.y = position.y - dsin(lookPitchSmooth);
	}
	
	static stepThird = function(smooth = false)
	{
		if (smooth)
		{
			lookDirectionSmooth += (lookDirection - lookDirectionSmooth) / smoothStep;
			lookPitchSmooth += (lookPitch - lookPitchSmooth) / smoothStep;
			lookDistanceSmooth += (lookDistance - lookDistanceSmooth) / smoothStep;
		}
		else
		{
			lookDirectionSmooth = lookDirection;
			lookPitchSmooth = lookPitch;
			lookDistanceSmooth = lookDistance;
		}
		
		position.x = lookAtPosition.x - lookDistanceSmooth * dcos(lookDirectionSmooth) * dcos(lookPitchSmooth);
		position.z = lookAtPosition.z + lookDistanceSmooth * dsin(lookDirectionSmooth) * dcos(lookPitchSmooth);
		position.y = lookAtPosition.y - lookDistanceSmooth * dsin(lookPitchSmooth);
	}
}