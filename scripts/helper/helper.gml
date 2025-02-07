function get_args()
{
	var p_num = parameter_count();
	var p_string = [  ];
	if p_num > 0
	{
	    for (var i = 0; i < p_num; i += 1)
	    {
	        p_string[i] = parameter_string(i + 1);
	    }
	}
	return p_string;
}

function loadCharacter(file, reloadLayers = true)
{
	// Start Loading Icon
	window_set_cursor(cr_appstart);
	
	// Destroy Old Character
	if (ctrlScene.character != noone) ctrlScene.character.destroy();
	
	// Load New Character
	ctrlScene.character = new BactaTankModel(file);
	if (reloadLayers) ctrlScene.renderLayers = array_create(array_length(ctrlScene.character.layers), 1);
	
	// Set Average Position
	global.renderers.viewer.camera.lookAtPosition.x = ctrlScene.character.averagePosition[0];
	global.renderers.viewer.camera.lookAtPosition.y = ctrlScene.character.averagePosition[1];
	global.renderers.viewer.camera.lookAtPosition.z = ctrlScene.character.averagePosition[2];
	global.renderers.viewer.camera.stepThird();
	
	// Reset Renderer
	global.renderers.viewer.activate();
	global.renderers.viewer.deactivate(1);
	
	// Flush Render Queue
	global.renderers.viewer.flush();
	
	// Push Grid To Render Queue
	if (global.settings.showGrid) array_push(global.renderers.viewer.renderQueue, ctrlScene.gridRenderStruct);
	
	// Push Character To Render Queue
	ctrlScene.character.pushToRenderQueue(ctrlScene.renderLayers);
	
	// Start Loading Icon
	window_set_cursor(cr_default);
}