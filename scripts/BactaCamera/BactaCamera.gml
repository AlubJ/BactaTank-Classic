/*
	BactaCamera (c) Alun Jones
	-------------------------------------------------------------------------
	Script:			BactaCamera
	Version:		v1.00
	Created:		04/11/2025 by Alun Jones
	Description:	BactaTank Camera
	-------------------------------------------------------------------------
	History:
	 - Created 04/11/2025 by Alun Jones
	
	To Do:
		Make the camera control much better, allow for panning across the view plane properly.
		Allow free cam.
		
	
	Information:
		Initialise a new camera, includes a bunch of helper functions to do camera stuff.
		
		The camera axis is set up like so:
		##########################################
		####                                  ####
		####  y-axis                          ####
		####    ^                             ####
		####    |                             ####
		####    |   -z-axis                   ####
		####    |  /                          ####
		####    | /                           ####
		####    |/                            ####
		####    +---------------->   x-axis   ####
		####							      ####
		##########################################
		
		The  y-axis is the up axis.
		The -z-axis is the depth axis.
		The  x-axis is the left-right axis.
		
		TtGames uses a DirectX native coordinate system.
*/

/// @func BactaCamera()
/// @desc Create a new BactaTank Camera.
function BactaCamera() constructor
{
	// Create Camera
	__camera = camera_create();
	camera_set_default(__camera);
	
	// Raw Position Variables
	position			= [0, 0, 0];
	lookAtPosition		= [0, 0, 0];
	
	// Smooth Position Variables
	__smoothPosition		= [0, 0, 0];
	__smoothLookAtPosition	= [0, 0, 0];
	
	// Raw Look Directions
	yaw = 0;
	pitch = 0;
	roll = 0;
	distance = 8;
	
	// Smooth Look Directions
	__smoothYaw = 0;
	__smoothPitch = 0;
	__smoothRoll = 0;
	__smoothCameraDistance = 8;
	
	// Up Vector (It's -1 to compensate drawing to the screen, increasing the z position will go up)
	__upVector = [0, -1, 0];
	
	// Clip Planes
	__zNear = 0.01;
	__zFar = 50;
	
	// Aspect and FOV
	__aspectRatio = -WINDOW_WIDTH / WINDOW_HEIGHT;
	__fov = 50;
	
	// Matrices
	__viewMatrix = matrix_build_lookat(position[0], position[1], position[2], lookAtPosition[0], lookAtPosition[1], lookAtPosition[2], __upVector[0], __upVector[1], __upVector[2]);
	__projMatrix = matrix_build_projection_perspective_fov(__fov, __aspectRatio, __zNear, __zFar);
	
	// Camera Pitch Lock
	__pitchLock = 60;
	
	// Editor
	__active = false;
	
	// Sensitivity (Move this to preferences prolly)
	__sensitivity = 0.3;
	
	/// @func submit([clear])
	/// @desc Submit the camera.
	static submit = function(_clear = false)
	{
		// Draw Clear Alpha
		draw_clear_alpha(c_black, _clear ? 0 : 1);
		
		// Build View and Projection Matrices
		__viewMatrix = matrix_build_lookat(position[0], position[1], position[2], lookAtPosition[0], lookAtPosition[1], lookAtPosition[2], __upVector[0], __upVector[1], __upVector[2]);
		__projMatrix = matrix_build_projection_perspective_fov(__fov, __aspectRatio, __zNear, __zFar);
		
		// Set Camera Matrices
		camera_set_view_mat(__camera, __viewMatrix);
		camera_set_proj_mat(__camera, __projMatrix);
		
		// Apply Camera
		camera_apply(__camera);
	}
	
	/// @func stepFirstPersonDebug
	static stepFirstPersonDebug = function()
	{
		window_mouse_set_locked(true);
		if (keyboard_check(ord("A")))
		{
			position[0] += dsin(yaw - 90) * .2 * DELTA_MULTIPLIER;
			position[1] += dcos(yaw - 90) * .2 * DELTA_MULTIPLIER;
		}
		
		if (keyboard_check(ord("D")))
		{
			position[0] -= dsin(yaw - 90) * .2 * DELTA_MULTIPLIER;
			position[1] -= dcos(yaw - 90) * .2 * DELTA_MULTIPLIER;
		}
		
		if (keyboard_check(ord("W")))
		{
			position[0] += dcos(yaw - 90) * .2 * DELTA_MULTIPLIER;
			position[1] -= dsin(yaw - 90) * .2 * DELTA_MULTIPLIER;
		}
		
		if (keyboard_check(ord("S")))
		{
			position[0] -= dcos(yaw - 90) * .2 * DELTA_MULTIPLIER;
			position[1] += dsin(yaw - 90) * .2 * DELTA_MULTIPLIER;
		}
			
		if (keyboard_check(vk_space)) position[2] += .1 * DELTA_MULTIPLIER;
		if (keyboard_check(vk_lshift)) position[2] -= .1 * DELTA_MULTIPLIER;
			
		yaw += window_mouse_get_delta_x() * 0.25;
		pitch += window_mouse_get_delta_y() * 0.25;
		yaw = wrap_value(yaw, 0, 359);
		pitch = clamp(pitch, -89.9, 89.9);
		
		lookAtPosition[0] = position[0] + dcos(yaw - 90) * dcos(pitch);
		lookAtPosition[1] = position[1] - dsin(yaw - 90) * dcos(pitch);
		lookAtPosition[2] = position[2] - dsin(pitch);
	}
	
	/// @func stepFirst()
	/// @desc Step the camera in first person.
	static stepFirst = function()
	{
		// Apply Positions
		lookAtPosition[0] = position[0] + dcos(yaw) * dcos(pitch);
		lookAtPosition[1] = position[1] - dsin(yaw) * dcos(pitch);
		lookAtPosition[2] = position[2] - dsin(pitch);
	}
	
	/// @func stepThird()
	/// @desc Step the camera in third person.
	static stepThird = function()
	{
		position[0] = lookAtPosition[0] + distance * dcos(yaw) * dcos(pitch);
		position[2] = lookAtPosition[2] - distance * dsin(yaw) * dcos(pitch);
		position[1] = lookAtPosition[1] - distance * dsin(pitch);
	}
	
	/// @func moveThird(bounds)
	/// @desc Move the camera in third person
	static moveThird = function(bounds = [0, 0, WINDOW_WIDTH, WINDOW_HEIGHT]) {
		if (window_mouse_get_x() > bounds[0] && window_mouse_get_x() < bounds[2] && window_mouse_get_y() > bounds[1] && window_mouse_get_y() < bounds[3])
		{
			if ((device_mouse_check_button_pressed(0, mb_left) || device_mouse_check_button_pressed(0, mb_right)) || device_mouse_check_button(0, mb_middle) && !__active)
			{
				__active = true;
				window_set_cursor(device_mouse_check_button(0, mb_middle) ? cr_size_ns : cr_size_all);
			}
			
			if (mouse_wheel_up())
			{
				distance -= (distance / 4);
			}
			
			if (mouse_wheel_down())
			{
				distance += (distance / 3);
			}
		}
		
		if (device_mouse_check_button(0, mb_left) && __active)
		{
			yaw += window_mouse_get_delta_x() * __sensitivity;
			pitch -= window_mouse_get_delta_y() * __sensitivity;
			pitch = clamp(pitch, -89.999, 89.999);
		}
		else if (device_mouse_check_button(0, mb_right) && __active)
		{
			vectorH = [
				dcos(yaw - 90),
				dsin(pitch + 90),
				dsin(yaw - 90)];
			
			vectorV = [
				dcos(yaw),
				dsin(pitch - 90),
				dsin(yaw)];
			//var matrix = matrix_build(0, 0, 0, lookPitch, lookDirection, 0, 1, 1, 1);
			//lookAtPosition.x += matrix[4] * window_mouse_get_delta_x() * 0.001 + matrix[8] * window_mouse_get_delta_y() * 0.001;
			//lookAtPosition.z += matrix[5] * window_mouse_get_delta_x() * 0.001 + matrix[9] * window_mouse_get_delta_y() * 0.001;
			//lookAtPosition.y += matrix[6] * window_mouse_get_delta_x() * 0.001 + matrix[10] * window_mouse_get_delta_y() * 0.001;
			
			lookAtPosition[0] += vectorH[0] * window_mouse_get_delta_x() * 0.001;
			lookAtPosition[1] -= vectorH[2] * window_mouse_get_delta_x() * 0.001;
			lookAtPosition[2] += vectorH[1] * window_mouse_get_delta_y() * 0.001;
			
			//lookAtPosition.x += dsin(lookDirection) * window_mouse_get_delta_x() * 0.001;
			//lookAtPosition.z += dcos(lookDirection) * window_mouse_get_delta_x() * 0.001;
			//lookAtPosition.y += dcos(lookPitch) * window_mouse_get_delta_y() * 0.001;
		}
		else if (device_mouse_check_button(0, mb_middle) && __active)
		{
			distance += window_mouse_get_delta_y() * 0.005;
		}
		
		if ((device_mouse_check_button_released(0, mb_left) || device_mouse_check_button_released(0, mb_right)) || device_mouse_check_button_released(0, mb_middle) && __active)
		{
			__active = false;
			window_set_cursor(cr_default);
		}
		
		lookAtPosition[0] = clamp(lookAtPosition[0], -20, 20);
		lookAtPosition[1] = clamp(lookAtPosition[1], -20, 20);
		lookAtPosition[2] = clamp(lookAtPosition[2], -20, 20);
		
		distance = clamp(distance, 0.05, 10);
		
		//if (active)
		//{
		//	if (CURSOR_POSITION[0] < bounds[0]) window_mouse_set(bounds[2], CURSOR_POSITION[1]);
		//	else if (CURSOR_POSITION[0] > bounds[2]) window_mouse_set(bounds[0], CURSOR_POSITION[1]);
		//	if (CURSOR_POSITION[1] < bounds[1]) window_mouse_set(CURSOR_POSITION[0], bounds[3]);
		//	else if (CURSOR_POSITION[1] > bounds[3]) window_mouse_set(CURSOR_POSITION[0], bounds[1]);
		//}
	}
	
	#region Editor
	
	/// @func stepEditorThird(bounds)
	/// @desc Step the editors third person camera in defined bounds.
	/// @arg {Array} bounds The bounds.
	static stepEditorThird = function(_bounds)
	{
		var _cursorX = window_mouse_get_x();
		var _cursorY = window_mouse_get_y();
		if (_cursorX > _bounds[0] && _cursorX < _bounds[2] && _cursorY > _bounds[1] && _cursorY < _bounds[3])
		{
			if ((device_mouse_check_button_pressed(0, mb_left) || device_mouse_check_button_pressed(0, mb_right)) || device_mouse_check_button(0, mb_middle) && !__active)
			{
				__active = true;
				window_set_cursor(cr_size_all);
			}
			
			if (mouse_wheel_up())
			{
				distance -= (distance / 4);
			}
			
			if (mouse_wheel_down())
			{
				distance += (distance / 3);
			}
		}
		
		if (device_mouse_check_button(0, mb_left) && __active)
		{
			yaw += window_mouse_get_delta_x() * 0.25;
			pitch -= window_mouse_get_delta_y() * 0.25;
			pitch = clamp(pitch, -89.999, 89.999);
			
			if (keyboard_check(ord("A")))
			{
				lookAtPosition[0] -= dsin(yaw) * .2;
				lookAtPosition[1] -= dcos(yaw) * .2;
			}
			
			if (keyboard_check(ord("D")))
			{
				lookAtPosition[0] += dsin(yaw) * .2;
				lookAtPosition[1] += dcos(yaw) * .2;
			}
			
			if (keyboard_check(ord("W")))
			{
				lookAtPosition[0] -= dcos(yaw) * .2;
				lookAtPosition[1] += dsin(yaw) * .2;
			}
			
			if (keyboard_check(ord("S")))
			{
				lookAtPosition[0] += dcos(yaw) * .2;
				lookAtPosition[1] -= dsin(yaw) * .2;
			}
			
			if (keyboard_check(vk_space)) lookAtPosition[2] += .1;
			if (keyboard_check(vk_lshift)) lookAtPosition[2] -= .1;
		}
		
		if ((device_mouse_check_button_released(0, mb_left) || device_mouse_check_button_released(0, mb_right)) || device_mouse_check_button_released(0, mb_middle) && __active)
		{
			__active = false;
			window_set_cursor(cr_default);
		}
		
		distance = clamp(distance, 1, 20);
		
		stepThird();
	}
	
	#endregion
	
	#region Getters and Setters
	
	/// @func getCamera()
	/// @desc Return the raw camera.
	static getCamera = function()
	{
		return __camera;
	}
	
	/// @func getPosition()
	/// @desc Return the raw position.
	static getPosition = function()
	{
		return position;
	}
	
	/// @func setPosition(x, y, z)
	/// @desc Set the raw position.
	static setPosition = function(_x, _y, _z)
	{
		position[0] = _x;
		position[1] = _y;
		position[2] = _z;
	}
	
	/// @func addPosition(x, y, z)
	/// @desc Add the raw position.
	static setPosition = function(_x, _y, _z)
	{
		position[0] += _x;
		position[1] += _y;
		position[2] += _z;
	}
	
	/// @func getLookPosition()
	/// @desc Return the look position.
	static getLookPosition = function()
	{
		return lookAtPosition;
	}
	
	/// @func setLookPosition(x, y, z)
	/// @desc Set the look position.
	static setLookPosition = function(_x, _y, _z)
	{
		lookAtPosition[0] = _x;
		lookAtPosition[1] = _y;
		lookAtPosition[2] = _z;
	}
	
	/// @func addLookPosition(x, y, z)
	/// @desc Add the look position.
	static addLookPosition = function(_x, _y, _z)
	{
		lookAtPosition[0] += _x;
		lookAtPosition[1] += _y;
		lookAtPosition[2] += _z;
	}
	
	/// @func setYaw(yaw)
	/// @desc Set the yaw of the camera.
	/// @arg {Real} yaw
	static setYaw = function(_yaw)
	{
		yaw = _yaw;
		__smoothYaw = _yaw;
	}
	
	/// @func setPitch(pitch)
	/// @desc Set the pitch of the camera.
	/// @arg {Real} pitch
	static setPitch = function(_pitch)
	{
		pitch = clamp(_pitch, -__pitchLock, __pitchLock);
	}
	
	/// @func addYaw(yaw)
	/// @desc Add the yaw of the camera.
	/// @arg {Real} yaw
	static addYaw = function(_yaw, _smooth = 0)
	{
		// Update raw yaw value
		_yaw = clamp(_yaw, -18, 18);
		__smoothYaw = wrap_value(__smoothYaw + _yaw, 0, 359);
		
		// Smooth it
		if (_smooth > 0)
		{
			yaw = lerp_angle(yaw, __smoothYaw, _smooth);
		}
		else
		{
			yaw = __smoothYaw;
		}
		
		// Wrap again
		yaw = normalize_angle(yaw);
	}
	
	/// @func addPitch(pitch)
	/// @desc Add the pitch of the camera.
	/// @arg {Real} pitch
	static addPitch = function(_pitch, _smooth = 0)
	{
		// Update raw yaw value
		_pitch = clamp(_pitch, -18, 18);
		__smoothPitch = clamp(__smoothPitch + _pitch, -__pitchLock, __pitchLock);
		
		// Smooth it
		if (_smooth > 0)
		{
			pitch = lerp_angle(pitch, __smoothPitch, _smooth);
		}
		else
		{
			pitch = __smoothPitch;
		}
	}
	
	#endregion
}