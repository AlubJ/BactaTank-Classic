/*
	renderHelper
	-------------------------------------------------------------------------
	Script:			renderHelper
	Version:		v1.00
	Created:		10/01/2025 by Alun Jones
	Description:	Render Helper Functions
	-------------------------------------------------------------------------
	History:
	 - Created 10/01/2025 by Alun Jones
	
	To Do:
*/

function buildGridVertexBuffer()
{
	var grid = vertex_create_buffer();
	
	vertex_begin(grid, BT_WIREFRAME_VERTEX_FORMAT);
	
	vertex_position_3d(grid, -1, 0, 1);
	vertex_position_3d(grid, 1, 0, 1);
	vertex_position_3d(grid, 1, 0, 1);
	vertex_position_3d(grid, 1, 0, -1);
	
	for (var i = -10; i < 10; i++)
	{
		vertex_position_3d(grid, i/10, 0, -1);
		vertex_position_3d(grid, i/10, 0, 1);
	}
	
	for (var i = -10; i < 10; i++)
	{
		vertex_position_3d(grid, -1, 0, i/10);
		vertex_position_3d(grid, 1, 0, i/10);
	}
	
	vertex_end(grid);
	
	return grid;
}

function buildUVGridVertexBuffer()
{
	var grid = vertex_create_buffer();
	
	vertex_begin(grid, BT_WIREFRAME_VERTEX_FORMAT);
	
	vertex_position_3d(grid, 1, 0, 0);
	vertex_position_3d(grid, 1, 1, 0);
	vertex_position_3d(grid, 0, 1, 0);
	vertex_position_3d(grid, 1, 1, 0);
	
	for (var i = 0; i < 20; i++)
	{
		vertex_position_3d(grid, i/20, 0, 0);
		vertex_position_3d(grid, i/20, 1, 0);
	}
	
	for (var i = 0; i < 20; i++)
	{
		vertex_position_3d(grid, 0, i/20, 0);
		vertex_position_3d(grid, 1, i/20, 0);
	}
	
	vertex_end(grid);
	
	return grid;
}

function buildCapsuleBottomVertexBuffer(radius)
{	
	// Create Vertex Buffer
	var vertexBuffer = vertex_create_buffer();
	
	// Begin Vertex Buffer
	vertex_begin(vertexBuffer, BT_WIREFRAME_VERTEX_FORMAT);
	
	// Create Full Circle
	buildCircleVertexBuffer(vertexBuffer, 0, 0, 0, radius, 2, 1);
	
	// Create Half Circles
	buildCircleVertexBuffer(vertexBuffer, 0, 0, 0, radius, 0, 0.5);
	buildCircleVertexBuffer(vertexBuffer, 0, 0, 0, radius, 1, 0.5, 90);
	
	// End Vertex Buffer
	vertex_end(vertexBuffer);
	
	// Return Vertex Buffer
	return vertexBuffer;
}

function buildCapsuleTopVertexBuffer(radius)
{	
	// Create Vertex Buffer
	var vertexBuffer = vertex_create_buffer();
	
	// Begin Vertex Buffer
	vertex_begin(vertexBuffer, BT_WIREFRAME_VERTEX_FORMAT);
	
	// Create Full Circle
	buildCircleVertexBuffer(vertexBuffer, 0, 0, 0, radius, 2, 1);
	
	// Create Half Circles
	buildCircleVertexBuffer(vertexBuffer, 0, 0, 0, radius, 0, 0.5, 180);
	buildCircleVertexBuffer(vertexBuffer, 0, 0, 0, radius, 1, 0.5, -90);
	
	// End Vertex Buffer
	vertex_end(vertexBuffer);
	
	// Return Vertex Buffer
	return vertexBuffer;
}

function buildCapsuleMiddleVertexBuffer(radius)
{	
	// Create Vertex Buffer
	var vertexBuffer = vertex_create_buffer();
	
	// Begin Vertex Buffer
	vertex_begin(vertexBuffer, BT_WIREFRAME_VERTEX_FORMAT);
	
	// Create Lines
	vertex_position_3d(vertexBuffer, radius, 0, 0);
	vertex_position_3d(vertexBuffer, radius, 1, 0);
	vertex_position_3d(vertexBuffer, -radius, 0, 0);
	vertex_position_3d(vertexBuffer, -radius, 1, 0);
	vertex_position_3d(vertexBuffer, 0, 0, radius);
	vertex_position_3d(vertexBuffer, 0, 1, radius);
	vertex_position_3d(vertexBuffer, 0, 0, -radius);
	vertex_position_3d(vertexBuffer, 0, 1, -radius);
	
	// End Vertex Buffer
	vertex_end(vertexBuffer);
	
	// Return Vertex Buffer
	return vertexBuffer;
}

function buildLocatorVertexBuffer()
{	
	// Create Vertex Buffer
	var vertexBuffer = vertex_create_buffer();
	
	// Begin Vertex Buffer
	vertex_begin(vertexBuffer, BT_WIREFRAME_VERTEX_FORMAT);
	
	// Create Lines
	vertex_position_3d(vertexBuffer, .05, 0, 0);
	vertex_position_3d(vertexBuffer, -.05, 0, 0);
	vertex_position_3d(vertexBuffer, 0, .05, 0);
	vertex_position_3d(vertexBuffer, 0, -.05, 0);
	vertex_position_3d(vertexBuffer, 0, 0, .05);
	vertex_position_3d(vertexBuffer, 0, 0, -.05);
	
	// End Vertex Buffer
	vertex_end(vertexBuffer);
	
	// Return Vertex Buffer
	return vertexBuffer;
}

function buildCircleVertexBuffer(vertexBuffer, xx, yy, zz, radius, axis = 0, segment = 1, rotation = 0, precision = 32)
{
	// Variables
	var segmentSize = 360/precision;
	var percentage = segment * precision;
	var lastVertex = [0, 0];
	
	// Circle Loop
	for(var i = 0; i <= percentage; i++) {
		// Last Vertex
		if (i > 1)
		{
			if (axis == 0) vertex_position_3d(vertexBuffer, xx + lastVertex[0], yy + lastVertex[1], zz); // ZUP
			else if (axis == 1) vertex_position_3d(vertexBuffer, xx, yy + lastVertex[0], zz + lastVertex[1]); // XUP
			else if (axis == 2) vertex_position_3d(vertexBuffer, xx + lastVertex[1], yy, zz + lastVertex[0]); // YUP
		}
		
		// Get Length of Segment
		var len = (i * segmentSize) + rotation;
		
		// Get Vertex Position
		var tx = lengthdir_x(radius, len);
		var ty = lengthdir_y(radius, len);
		
		// Mark Last Vertex
		lastVertex = [tx, ty];
		
		// Current Vertex
		if (axis == 0) vertex_position_3d(vertexBuffer, xx + tx, yy + ty, zz); // ZUP
		else if (axis == 1) vertex_position_3d(vertexBuffer, xx, yy + tx, zz + ty); // XUP
		else if (axis == 2) vertex_position_3d(vertexBuffer, xx + ty, yy, zz + tx); // YUP
	}
}

/// draw_pie(x, y, value, max, colour, radius, transparency)
function circle(xx, yy, r)
{
	var numberofsections = 16 * 2;
	var sizeofsection = 360/numberofsections;
    
	var val = 0.5 * numberofsections
    
	if (val > 1) {
		
		var lastVertex = [-4, -4];
		
	    draw_set_colour(c_white);
	    draw_set_alpha(1);
        
	    draw_primitive_begin(pr_linelist);
        
	    for(var i = 0; i <= val; i++) {
			if (i > 1) draw_vertex(lastVertex[0], lastVertex[1]);
			
	        var len = (i * sizeofsection); // the 90 here is the starting angle
			
	        var tx = lengthdir_x(r, len);
	        var ty = lengthdir_y(r, len);
			
			lastVertex = [xx+tx, yy+ty];
			
	        draw_vertex(xx+tx, yy+ty);
	    }
	    draw_primitive_end();
        
	}
	draw_set_alpha(1);
}

function world_to_screen(xx, yy, zz, view_mat, proj_mat, sizex = WINDOW_SIZE[0], sizey = WINDOW_SIZE[1])
{
	/// @param xx
	/// @param yy
	/// @param zz
	/// @param view_mat
	/// @param proj_mat
	/*
	    Transforms a 3D world-space coordinate to a 2D window-space coordinate. Returns an array of the following format:
	    [xx, yy]
	    Returns [-1, -1] if the 3D point is not in view
   
	    Script created by TheSnidr
	    www.thesnidr.com
	*/

	if (proj_mat[15] == 0) {   //This is a perspective projection
	    var w = view_mat[2] * xx + view_mat[6] * yy + view_mat[10] * zz + view_mat[14];
	    // If you try to convert the camera's "from" position to screen space, you will
	    // end up dividing by zero (please don't do that)
	    if (w <= 0) return [-1, -1];
	    if (w == 0) return [-1, -1];
	    var cx = proj_mat[8] + proj_mat[0] * (view_mat[0] * xx + view_mat[4] * yy + view_mat[8] * zz + view_mat[12]) / w;
	    var cy = proj_mat[9] + proj_mat[5] * (view_mat[1] * xx + view_mat[5] * yy + view_mat[9] * zz + view_mat[13]) / w;
	} else {    //This is an ortho projection
	    var cx = proj_mat[12] + proj_mat[0] * (view_mat[0] * xx + view_mat[4] * yy + view_mat[8]  * zz + view_mat[12]);
	    var cy = proj_mat[13] + proj_mat[5] * (view_mat[1] * xx + view_mat[5] * yy + view_mat[9]  * zz + view_mat[13]);
	}

	return [(0.5 + 0.5 * cx) * sizex, (0.5 + 0.5 * cy) * sizey];	
}

function stripsToTris(strip)
{
	// Create Triangle Array
	var triangles = [  ];
	
	// Winding Order Stuff
    var flip = false;
	
	// Get Next Indices
	var t0 = -1;
    var t1 = strip[0];
    var t2 = strip[1];
    for (var k = 2; k < array_length(strip); k++)
	{
        flip = !flip;
        t0 = t1;
		t1 = t2;
		t2 = strip[k];
        if (t0 == t1 || t1 == t2 || t2 == t0) continue;
        array_push(triangles, flip ? [t0, t1, t2] : [t0, t2, t1]);
	}
	
	return triangles;
}

function strip_to_triangles(triangle_strip)
{
    var triangle_list = [];
    var strip_length = array_length(triangle_strip);
    if (strip_length < 3) return triangle_list;
    
    for (var i = 0; i < strip_length - 2; i++)
	{
        if (i % 2 == 0)
		{
            array_push(triangle_list, triangle_strip[i], triangle_strip[i+1], triangle_strip[i+2]);
        }
		else
		{
            array_push(triangle_list, triangle_strip[i], triangle_strip[i+2], triangle_strip[i+1]);
        }
    }
    
    return triangle_list;
}

function triangles_to_strip(indices)
{
    var strip = []; // Output triangle strip
    var index_count = array_length(indices);
    if (index_count < 3) return strip; // Need at least one triangle
    
    var last_triangle = [indices[0], indices[1], indices[2]];
    array_push(strip, last_triangle[0], last_triangle[1], last_triangle[2]);
    
    for (var i = 3; i < index_count; i += 3)
	{
        var next_triangle = [indices[i], indices[i+1], indices[i+2]];
        
        // Check if we need to insert a degenerate triangle
        if (last_triangle[2] != next_triangle[0])
		{
            array_push(strip, last_triangle[2]); // Duplicate last vertex
            array_push(strip, next_triangle[0]); // Duplicate next triangle's first vertex
        }
        
        // Add the next triangle's vertices
        array_push(strip, next_triangle[0], next_triangle[1], next_triangle[2]);
        last_triangle = next_triangle;
    }
    
    return strip;
}

function strip_to_lines(triangle_strip)
{
    var line_strip = [];
    var strip_length = array_length(triangle_strip);
    if (strip_length < 2) return line_strip;
    
    for (var i = 0; i < strip_length - 1; i++)
	{
        array_push(line_strip, triangle_strip[i], triangle_strip[i+1]);
    }
    
    return line_strip;
}

function triangles_to_lines(triangle_list)
{
    var line_list = [];
    var triangle_count = array_length(triangle_list);
    if (triangle_count < 3) return line_list;
    
    for (var i = 0; i < triangle_count; i += 3)
	{
        array_push(line_list, triangle_list[i], triangle_list[i+1]); // Edge 1
        array_push(line_list, triangle_list[i+1], triangle_list[i+2]); // Edge 2
        array_push(line_list, triangle_list[i+2], triangle_list[i]); // Edge 3
    }
    
    return line_list;
}
