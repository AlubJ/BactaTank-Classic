/// @desc Create Renderer
/*
	ctrlRenderer.Create
	-------------------------------------------------------------------------
	Script:			ctrlRenderer.Create
	Version:		v1.00
	Created:		10/01/2024 by Alun Jones
	Description:	Create Renderer
	-------------------------------------------------------------------------
	History:
	 - Created 10/01/2024 by Alun Jones
	
	To Do:
*/

// Create Renderer
RENDERER = new CalicoRenderer();
SECONDARY_RENDERER = new CalicoRenderer();

// Create Canvas
CANVAS = new CalicoCanvas();
SECONDARY_CANVAS = new CalicoCanvas();

// GSC Texture Replacements Work Fine
//model = new BactaTankModel("THINGS_PC.GSC");
//model.destroy();

//model.replaceMesh(9, @"C:\Users\Alun\Desktop\sphere.btank");
//var cachedMesh = buffer_create_from_vertex_buffer(model.meshes[9].vertexBufferObject, buffer_fixed, 1);
//buffer_save(cachedMesh, "sphere.mesh");
//buffer_delete(cachedMesh);


//model.pushToRenderQueue([1, 1, 0, 1, 0, 0, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]);

// Reset Camera
//RENDERER.camera.lookDistance = 0.6;
//RENDERER.camera.lookPitch = -20;
//RENDERER.camera.lookDirection = -45;
//RENDERER.camera.lookAtPosition.x = model.averagePosition[0];
//RENDERER.camera.lookAtPosition.y = model.averagePosition[1];
//RENDERER.camera.lookAtPosition.z = model.averagePosition[2];

// Create Primitives
PRIMITIVES.grid = buildGridVertexBuffer();
PRIMITIVES.capsuleBottom = buildCapsuleBottomVertexBuffer(1);
PRIMITIVES.capsuleTop = buildCapsuleTopVertexBuffer(1);
PRIMITIVES.capsuleMiddle = buildCapsuleMiddleVertexBuffer(1);
PRIMITIVES.locator = buildLocatorVertexBuffer();
PRIMITIVES.sphere = loadBactaTankMesh("resources/sphere.mesh");
PRIMITIVES.sabre = loadBactaTankMesh("resources/sabre.mesh");
PRIMITIVES.blaster = loadBactaTankMesh("resources/blaster.mesh");
PRIMITIVES.pistol = loadBactaTankMesh("resources/pistol.mesh");
PRIMITIVES.hat = loadBactaTankMesh("resources/hat.mesh");
PRIMITIVES.uvGrid = buildUVGridVertexBuffer();

// Create Grid Render Struct
gridRenderStruct = {
	vertexBuffer: PRIMITIVES.grid,
	material: {colour: SETTINGS.viewerSettings.gridColour},
	textures: {},
	matrix: matrix_build_identity(),
	shader: "WireframeShader",
	primitive: pr_linelist,
}

// Default Material
DEFAULT_MATERIAL = new BactaTankMaterial();
DEFAULT_MATERIAL.colour = [0.8, 0.8, 0.8, 0.8];
DEFAULT_MATERIAL.shaderFlags = 0x08;

// Ambient Lighting
ambient = new CalicoLight();
ambient.type = "Ambient";
ambient.colour = [0.15, 0.15, 0.15];

// Fog
fog = new CalicoLight();
fog.type = "Fog";
fog.strength = 0;

// Main Directional Light
light = new CalicoLight();
light.type = "Direction";
light.vector = [-1, 1, 1];
light.colour = [0.3, 0.3, 0.3];

// Accent Directional Light
accentLight = new CalicoLight();
accentLight.type = "Direction";
accentLight.vector = [1, 1, -1];
accentLight.colour = [0.6, 0.6, 0.6];

// Push Lighting Data
array_push(RENDERER.lightingData, ambient, fog, accentLight, light);
array_push(SECONDARY_RENDERER.lightingData, ambient, fog, accentLight, light);

//circleRenderStruct1 = {
//	vertexBuffer: buildCircleVertexBuffer(0, 0, 0, 2, 0, 0.5),
//	material: {colour: [0.8, 0.0, 0.0, 1.0]},
//	textures: {},
//	matrix: matrix_build_identity(),
//	shader: "WireframeShader",
//	primitive: pr_linelist,
//}

//circleRenderStruct2 = {
//	vertexBuffer: buildCircleVertexBuffer(0, 0, 0, 2, 1, 0.5, 90),
//	material: {colour: [0.0, 0.8, 0.0, 1.0]},
//	textures: {},
//	matrix: matrix_build_identity(),
//	shader: "WireframeShader",
//	primitive: pr_linelist,
//}

//circleRenderStruct3 = {
//	vertexBuffer: buildCircleVertexBuffer(0, 0, 0, 2, 2),
//	material: {colour: [0.0, 0.0, 0.8, 1.0]},
//	textures: {},
//	matrix: matrix_build_identity(),
//	shader: "WireframeShader",
//	primitive: pr_linelist,
//}

radius = 0.1;
miny = 0;
maxy = 0.42;

value = 50;
vMax = 100;
colour = c_white;

///// draw_pie(x ,y ,value, max, colour, radius, transparency)

//if (value > 0) { // no point even running if there is nothing to display (also stops /0
//    var i, len, tx, ty, val;
    
//    var numberofsections = 60 // there is no draw_get_circle_precision() else I would use that here
//    var sizeofsection = 360/numberofsections;
    
//    val = 0.5 * numberofsections
    
//    if (val > 1) { // HTML5 version doesnt like triangle with only 2 sides
    
//        draw_primitive_begin(pr_linelist);
        
//        for(i=0; i<=val; i++) {
//            len = (i*sizeofsection)+90; // the 90 here is the starting angle
//            tx = lengthdir_x(argument5, len);
//            ty = lengthdir_y(argument5, len);
//            draw_vertex(argument0+tx, argument1+ty);
//        }
//        draw_primitive_end();
        
//    }
//    draw_set_alpha(1);
//}