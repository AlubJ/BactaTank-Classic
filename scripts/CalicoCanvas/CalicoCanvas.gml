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
}

function CalicoCanvas() constructor
{
	// Variables
	width = 512;
	height = 512;
	
	drawList = [];
	
	surface = noone;
	
	zoom = 500;
	
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
				case CALICO_DRAW_LIST_TYPE.LINE_LIST:
					matrix_set(matrix_world, matrix_build(0, 0, 0, 0, 0, 0, zoom, zoom, zoom));
					shader_set(shdUV);
					vertex_submit(drawList[i], pr_linestrip, -1);
					shader_reset();
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
						draw_set_colour(make_color_rgb(SETTINGS.viewerSettings.boneColour[0] * 255, SETTINGS.viewerSettings.boneColour[1] * 255, SETTINGS.viewerSettings.boneColour[2] * 255));
						
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
						draw_rectangle(canvasBonePosition[0] - 2, canvasBonePosition[1] - 2, canvasBonePosition[0] + 2, canvasBonePosition[1] + 2, false);
						
						// Reset Colour
						draw_set_colour(c_white);
						//draw_text(pos[0] - floor(string_width(bone.name) / 2), pos[1] - floor(string_height(bone.name) / 2), bone.name);
					}
					break;
			}
			//show_debug_message(drawList[i]);
			//for (var j = 0; j < array_length(drawList[i].points); j++)
			//{
			//	if (j != 0)
			//	{
			//		draw_line(drawList[i].points[j - 1][0] * zoom, drawList[i].points[j - 1][1] * zoom, drawList[i].points[j][0] * zoom, drawList[i].points[j][1] * zoom);
			//	}
			//}
		}
		
		//if (array_length(drawList) != 0)
		//{
		//	matrix_set(matrix_world, matrix_build(mouse_x, mouse_y, 0, 0, 0, 0, zoom, zoom, zoom));
		//	shader_set(shdUV);
		//	vertex_submit(drawList[0], pr_linestrip, -1);
		//	shader_reset();
		//	matrix_set(matrix_world, matrix_build_identity());
		//}
		
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

function CalicoArmature(_armature, _viewMatrix, _projMatrix) constructor
{
	armature = _armature;
	viewMatrix = _viewMatrix;
	projMatrix = _projMatrix;
	type = CALICO_DRAW_LIST_TYPE.ARMATURE;
}