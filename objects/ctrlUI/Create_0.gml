/// @desc Set Up UI
/*
	ctrlUI.Create
	-------------------------------------------------------------------------
	Script:			ctrlUI.Create
	Version:		v1.00
	Created:		15/11/2024 by Alun Jones
	Description:	Create the UI
	-------------------------------------------------------------------------
	History:
	 - Created 15/11/2024 by Alun Jones
	
	To Do:
*/

// Create Global Environment
ENVIRONMENT = new GlobalEnvironment();

var modal = new StartupModal();
ENVIRONMENT.addModal(modal);
ENVIRONMENT.openModal(modal.name);

ENVIRONMENT.addModal(new NewProjectModal());
ENVIRONMENT.addModal(new AddModelModal());
ENVIRONMENT.addModal(new AboutModal());
ENVIRONMENT.addModal(new PreferencesModal());

// Asset Pack Modals
ENVIRONMENT.addModal(new AssetPacksModal());
ENVIRONMENT.addModal(new CreateAssetPackModal());

// Get Command Line Args
//var args = get_args();
//args[0] = "batman_new.GHG"
//if (array_length(args) > 0 && string_lower(filename_ext(args[0])) == ".ghg" || string_lower(filename_ext(args[0])) == ".bcanister" && file_exists(args[0]))
//{
//	ENVIRONMENT.openInfoModal("Please wait", "Converting GHG model to BactaTankModel");
//	window_set_cursor(cr_hourglass);
	
//	// Define Function
//	var func = function(file, name)
//	{
//		// Log
//		ConsoleLog("Beginning Model Conversion");
		
//		// Load Model
//		var model = new BactaTankModel(file);
		
//		// Save Canister Model
//		model.saveCanister(PROJECT.workingDirectory + name + ".bcanister");
		
//		// Set Current Model
//		PROJECT.currentModel = model;
//		model.pushToRenderQueue(array_create(array_length(model.layers), true));
		
//		// Reset Camera
//		RENDERER.camera.lookDistance = 0.6;
//		RENDERER.camera.lookPitch = -20;
//		RENDERER.camera.lookDirection = -45;
//		RENDERER.camera.lookAtPosition.x = model.averagePosition[0];
//		RENDERER.camera.lookAtPosition.y = model.averagePosition[1];
//		RENDERER.camera.lookAtPosition.z = model.averagePosition[2];
		
//		// Activate Renderer
//		RENDERER.activate();
		
//		// Push To Project Models
//		array_push(MODELS, name);
		
//		// User Feedback
//		ENVIRONMENT.closeInfoModal();
//		window_set_cursor(cr_default);

//		setContext(BTContext.Model);
//	}
						
//	// Timesource
//	time_source_start(time_source_create(time_source_game, 5, time_source_units_frames, func, [args[0], string_split(filename_name(args[0]), ".")[0]]));
	
//	// Activate Renderer
//	RENDERER.activate();
//}