/*
	CalicoCanvas (c) Alun Jones
	-------------------------------------------------------------------------
	Script:			CalicoCanvas
	Version:		v1.00
	Created:		29/11/2023 by Alun Jones
	Description:	2D Canvas
	-------------------------------------------------------------------------
	History:
	 - Created 29/11/2023 by Alun Jones
	
	To Do:
*/

enum CALICO_DRAW_LIST_TYPE
{
	LINE_LIST,
	SPRITE,
	TRANSPARENT,
	ARMATURE,
	UV_MAP,
	LOCATORS,
	GRID,
}

function CalicoCanvas() constructor
{
	// Variables
	width = 512;
	height = 512;
	
	// Canvas Stuff
	canvasWidth = 512;
	canvasHeight = 512;
	
	drawList = [];
	
	surface = noone;
	
	zoom = 1;
	positionX = 0;
	positionY = 0;
	active = false;
	
	// Methods
	static add = function(struct)
	{
		array_push(drawList, struct);
	}
	
	// Resize
	static resize = function(_width, _height)
	{
		width = _width;
		height = _height;
		if (surface_exists(surface)) surface_resize(surface, width, height);
	}
	
	static pan = function(xx, yy)
	{
		var bounds = [xx, yy, xx + width, yy + height];
		if (CURSOR_POSITION[0] > bounds[0] && CURSOR_POSITION[0] < bounds[2] && CURSOR_POSITION[1] > bounds[1] && CURSOR_POSITION[1] < bounds[3])
		{
			if ((device_mouse_check_button_pressed(0, mb_left) || device_mouse_check_button_pressed(0, mb_right)) || device_mouse_check_button(0, mb_middle) && !active)
			{
				active = true;
			}
			
			if (mouse_wheel_up())
			{
				zoom += (zoom / 3);
			}
			
			if (mouse_wheel_down())
			{
				zoom -= (zoom / 4);
			}
		}
		
		if (device_mouse_check_button(0, mb_right) && active)
		{
			positionX += window_mouse_get_delta_x();
			positionY += window_mouse_get_delta_y();
		}
		if (device_mouse_check_button(0, mb_middle) && active)
		{
			zoom -= window_mouse_get_delta_y() * 0.005;
		}
		
		if ((device_mouse_check_button_released(0, mb_left) || device_mouse_check_button_released(0, mb_right)) || device_mouse_check_button_released(0, mb_middle) && active)
		{
			active = false;
		}
		
		zoom = clamp(zoom, 0.25, 10);
	}
	
	static draw = function()
	{
		// Check Surface
		if (!surface_exists(surface)) surface = surface_create(width, height);
		surface_set_target(surface);
		draw_clear_alpha(c_black, 0);
		
		gpu_push_state();
		gpu_set_state(GPU_STATE);
		
		for (var i = 0; i < array_length(drawList); i++)
		{
			switch (drawList[i].type)
			{
				case CALICO_DRAW_LIST_TYPE.UV_MAP:
					var seed = random_get_seed();
					random_set_seed(real(drawList[i].vertexBuffer) * vertex_get_number(drawList[i].vertexBuffer));
					matrix_set(matrix_world, matrix_build(positionX - zoom * canvasWidth / 2 + drawList[i].offset[0] * zoom * canvasWidth, positionY - zoom * canvasHeight / 2 + drawList[i].offset[1] * zoom * canvasHeight, 0, 0, 0, 0, zoom * canvasWidth, zoom * canvasHeight, 1));
					shader_set(shdWireframe);
					if (SETTINGS.viewerSettings.randomiseUVMapColours)
					{
						shader_set_uniform_f(shader_get_uniform(shdWireframe, "colour"), random_range(0.5, 1), random_range(0.5, 1), random_range(0.5, 1), 1);
					}
					else
					{
						shader_set_uniform_f(shader_get_uniform(shdWireframe, "colour"), SETTINGS.viewerSettings.uvMapColour[0], SETTINGS.viewerSettings.uvMapColour[1], SETTINGS.viewerSettings.uvMapColour[2], SETTINGS.viewerSettings.uvMapColour[3]);
					}
					vertex_submit(drawList[i].vertexBuffer, pr_linelist, -1);
					shader_reset();
					matrix_set(matrix_world, matrix_build_identity());
					random_set_seed(seed);
					//for (var j = 0; j < array_length(drawList[i].triangles); j++)
					//{
					//	var tri = drawList[i].triangles[j];
					//	var point1 = drawList[i].vertices[tri[0]].uvSet1;
					//	var point2 = drawList[i].vertices[tri[1]].uvSet1;
					//	var point3 = drawList[i].vertices[tri[2]].uvSet1;
					//	draw_line(positionX + point1[0] * canvasWidth * zoom, positionY + (point1[1]) * canvasHeight * zoom, positionX + point2[0] * canvasWidth * zoom, positionY + (point2[1]) * canvasHeight * zoom);
					//	draw_line(positionX + point2[0] * canvasWidth * zoom, positionY + (point2[1]) * canvasHeight * zoom, positionX + point3[0] * canvasWidth * zoom, positionY + (point3[1]) * canvasHeight * zoom);
					//	draw_line(positionX + point3[0] * canvasWidth * zoom, positionY + (point3[1]) * canvasHeight * zoom, positionX + point1[0] * canvasWidth * zoom, positionY + (point1[1]) * canvasHeight * zoom);
					//}
					break;
				case CALICO_DRAW_LIST_TYPE.GRID:
					matrix_set(matrix_world, matrix_build(positionX - zoom * canvasWidth / 2, positionY - zoom * canvasHeight / 2, 0, 0, 0, 0, zoom * canvasWidth, zoom * canvasHeight, 1));
					shader_set(shdWireframe);
					shader_set_uniform_f(shader_get_uniform(shdWireframe, "colour"), SETTINGS.viewerSettings.gridColour[0], SETTINGS.viewerSettings.gridColour[1], SETTINGS.viewerSettings.gridColour[2], SETTINGS.viewerSettings.gridColour[3]);
					vertex_submit(PRIMITIVES.uvGrid, pr_linelist, -1);
					shader_reset();
					matrix_set(matrix_world, matrix_build_identity());
					break;
				case CALICO_DRAW_LIST_TYPE.SPRITE:
					draw_sprite_stretched(drawList[i].sprite, drawList[i].index, drawList[i].x, drawList[i].y, drawList[i].width, drawList[i].height);
					break;
				case CALICO_DRAW_LIST_TYPE.TRANSPARENT:
					// Block Count
					var blockXCount = ceil(drawList[i].width / 8);
					var blockYCount = ceil(drawList[i].height / 8);
					
					// Make X Block Count Odd
					if (blockXCount % 2 == 0) blockXCount++;
					
					// Colour
					var col = #BFBFBF;
					
					// Vertical Loop
					for (var yy = 0; yy < blockYCount; yy++)
					{
						// Horizontal Loop
						for (var xx = 0; xx < blockXCount; xx++)
						{
							// Set Colour
							draw_set_colour(col);
							
							// Draw Rectangle
							draw_rectangle(xx * 8, yy * 8, xx * 8 + 8, yy * 8 + 8, false);
							
							// Alternate Colour
							if (col = #BFBFBF) col = c_white;
							else col = #BFBFBF;
						}
					}
					break;
				case CALICO_DRAW_LIST_TYPE.ARMATURE:
					// Bones
					var bones = drawList[i].armature;
					
					// Bone Connections Loop
					for (var b = 0; b < array_length(bones); b++)
					{
						// Get Bone
						var bone = bones[b];
						
						// If No Parent, Skip
						if (bone.parent = -1) continue;
						
						// Bone Pareent
						var parent = bones[bone.parent];
						
						// Bone Matrices
						var boneMatrix = bone.matrix;
						var parentMatrix = parent.matrix;
						
						// Get Positions
						var canvasBonePosition = world_to_screen(boneMatrix[12], boneMatrix[13], boneMatrix[14], drawList[i].viewMatrix, drawList[i].projMatrix, width, height);
						var canvasParentPosition = world_to_screen(parentMatrix[12], parentMatrix[13], parentMatrix[14], drawList[i].viewMatrix, drawList[i].projMatrix, width, height);
						
						// Skip if Outside View Bounds
						if (canvasBonePosition[0] == -1 || canvasBonePosition[1] == -1 || canvasParentPosition[0] == -1 || canvasParentPosition[1] == -1) continue;
						
						// Draw Bone Colour
						if (drawList[i].selectedBone == b) draw_set_colour(make_color_rgb(SETTINGS.viewerSettings.selectedBoneColour[0] * 255, SETTINGS.viewerSettings.selectedBoneColour[1] * 255, SETTINGS.viewerSettings.selectedBoneColour[2] * 255));
						else draw_set_colour(make_color_rgb(SETTINGS.viewerSettings.boneColour[0] * 255, SETTINGS.viewerSettings.boneColour[1] * 255, SETTINGS.viewerSettings.boneColour[2] * 255));
						
						// Draw Line
						draw_line_width(canvasBonePosition[0], canvasBonePosition[1], canvasParentPosition[0], canvasParentPosition[1], 2);
						
						// Reset Colour
						draw_set_colour(c_white);
					}
					
					// Bone Nodes
					for (var b = 0; b < array_length(bones); b++)
					{
						// Get Bone and Bone Matrix
						var bone = bones[b];
						var boneMatrix = bone.matrix;
						
						// Get Canvas Positions
						var canvasBonePosition = world_to_screen(boneMatrix[12], boneMatrix[13], boneMatrix[14], drawList[i].viewMatrix, drawList[i].projMatrix, width, height);
						
						// Skip if Outside View Bounds
						if (canvasBonePosition[0] == -1 || canvasBonePosition[1] == -1) continue;
						
						// Draw Node
						draw_set_colour(c_white);
						if (drawList[i].selectedBone == b) draw_set_colour(make_color_rgb(SETTINGS.viewerSettings.selectedBoneColour[0] * 255, SETTINGS.viewerSettings.selectedBoneColour[1] * 255, SETTINGS.viewerSettings.selectedBoneColour[2] * 255));
						draw_rectangle(canvasBonePosition[0] - 2, canvasBonePosition[1] - 2, canvasBonePosition[0] + 2, canvasBonePosition[1] + 2, false);
						
						// Draw Bone Name
						if (drawList[i].boneNames)
						{
							draw_set_colour(c_white);
							draw_set_halign(fa_center);
							draw_text(canvasBonePosition[0], canvasBonePosition[1], bone.name);
						}
						
						// Reset Colour
						draw_set_halign(fa_left);
						draw_set_colour(c_white);
						//draw_text(pos[0] - floor(string_width(bone.name) / 2), pos[1] - floor(string_height(bone.name) / 2), bone.name);
					}
					break;
				case CALICO_DRAW_LIST_TYPE.LOCATORS:
					// Locators
					var locators = drawList[i].locators;
					var bones = drawList[i].armature;
					
					// Locator Names
					for (var l = 0; l < array_length(locators); l++)
					{
						// Get Locator and Locator Matrix
						var locator = locators[l];
						var locatorMatrix = locator.matrix;
						if (locator.parent != -1) locatorMatrix = matrix_multiply(locatorMatrix, bones[locator.parent].matrix);
						
						// Get Canvas Positions
						var canvasLocatorPosition = world_to_screen(locatorMatrix[12], locatorMatrix[13], locatorMatrix[14], drawList[i].viewMatrix, drawList[i].projMatrix, width, height);
						
						// Skip if Outside View Bounds
						if (canvasLocatorPosition[0] == -1 || canvasLocatorPosition[1] == -1) continue;
						
						// Draw Locator Name
						draw_set_halign(fa_center);
						draw_text(canvasLocatorPosition[0], canvasLocatorPosition[1], locator.name);
						
						// Reset Colour
						draw_set_halign(fa_left);
						draw_set_colour(c_white);
					}
					break;
			}
		}
		
		gpu_pop_state();
		
		surface_reset_target();
		
		array_delete(drawList, 0, array_length(drawList));
	}
}

function CalicoLineList() constructor
{
	// Variables
	points = [];
	closed = false;
	type = CALICO_DRAW_LIST_TYPE.LINE_LIST;
	
	// Methods
	static add = function(xx, yy)
	{
		array_push(points, [xx, yy]);
	}
}

function CalicoUVMap(_vertexBuffer, _offset = [0, 0]) constructor
{
	vertexBuffer = _vertexBuffer;
	offset = _offset;
	type = CALICO_DRAW_LIST_TYPE.UV_MAP;
}

function CalicoSprite(_sprite, _index, _x = 0, _y = 0, _width = sprite_get_width(_sprite), _height = sprite_get_width(_sprite)) constructor
{
	sprite = _sprite;
	index = _index;
	x = _x;
	y = _y;
	width = _width;
	height = _height;
	type = CALICO_DRAW_LIST_TYPE.SPRITE;
}

function CalicoTransparencyBackground(_width, _height, _col1 = $FFFFFF, _col2 = $BFBFBF) constructor
{
	width = _width;
	height = _height;
	colour1 = _col1;
	colour2 = _col2;
	type = CALICO_DRAW_LIST_TYPE.TRANSPARENT;
}

function CalicoArmature(_armature, _viewMatrix, _projMatrix, _displayBoneNames = false, _selectedBone = -1) constructor
{
	armature = _armature;
	viewMatrix = _viewMatrix;
	projMatrix = _projMatrix;
	boneNames = _displayBoneNames;
	selectedBone = _selectedBone;
	type = CALICO_DRAW_LIST_TYPE.ARMATURE;
}

function CalicoLocatorNames(_locators, _armature, _viewMatrix, _projMatrix) constructor
{
	locators = _locators;
	armature = _armature;
	viewMatrix = _viewMatrix;
	projMatrix = _projMatrix;
	type = CALICO_DRAW_LIST_TYPE.LOCATORS;
}

function CalicoGrid() constructor
{
	type = CALICO_DRAW_LIST_TYPE.GRID;
}