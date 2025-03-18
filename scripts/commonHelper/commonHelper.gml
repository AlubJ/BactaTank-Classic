/*
	commonHelper
	-------------------------------------------------------------------------
	Script:			commonHelper
	Version:		v1.00
	Created:		04/12/2024 by Alun Jones
	Description:	Common Functions
	-------------------------------------------------------------------------
	History:
	 - Created 04/12/2024 by Alun Jones
	
	To Do:
*/

#region Project Stuff

// File Menu
function newProject()
{
	ENVIRONMENT.openConfirmModal("Unsaved Changes", "Are you sure you want to continue?", function() {
		ENVIRONMENT.openModal("New Project");
	});
}

function saveProjectAs(project)
{
	var file = get_save_filename_ext(FILTERS.newProj, project.name, SETTINGS.lastProjectPath, "Save Project As");
	
	if (file != "" && ord(file) != 0)
	{
		project.save(file);
	}
}

function openProjectOrModelDialog()
{
	// Get Open File Name For Mesh Replacement
	var file = get_open_filename_ext(FILTERS.projectOrModel, $"", SETTINGS.lastProjectPath, "Open Project or Model");
	if (file != "" && ord(file) != 0)
	{
		openProjectOrModel(file);
		SETTINGS.lastProjectPath = filename_path(file);
		return true;
	}
	return false;
}

function openProjectOrModel(file)
{
	if (string_lower(filename_ext(file)) != ".proj") // Assume it is a model we are loading
	{
		// User Feedback
		ENVIRONMENT.openInfoModal("Please wait", "Converting GHG model to BactaTankModel");
		window_set_cursor(cr_hourglass);
		
		// Define Function
		var func = function(file, name)
		{
			// Log
			ConsoleLog("Beginning Model Conversion");
			
			// Flush Renderer
			RENDERER.flush();
			
			// Destroy Last Project and Create Dummy Project
			if (is_struct(PROJECT)) PROJECT.destroy();
			PROJECT = new BactaTankProject("DefaultProject");
			
			// Load Model
			var model = new BactaTankModel(file);
			
			// Save Canister Model
			//model.saveCanister(PROJECT.workingDirectory + name + ".bcanister");
			
			// Set Current Model
			PROJECT.currentModel = model;
			model.pushToRenderQueue(array_create(array_length(model.layers), true));
			
			// Test
			exportArmature(model, "test.arm");
			
			// Reset Camera
			RENDERER.camera.lookDistance = 0.6;
			RENDERER.camera.lookPitch = -20;
			RENDERER.camera.lookDirection = -45;
			RENDERER.camera.lookAtPosition.x = model.averagePosition[0];
			RENDERER.camera.lookAtPosition.y = model.averagePosition[1];
			RENDERER.camera.lookAtPosition.z = model.averagePosition[2];
			
			// Activate Renderer
			RENDERER.activate();
			
			// Push To Project Models
			array_push(MODELS, name);
			
			// User Feedback
			ENVIRONMENT.closeInfoModal();
			window_set_cursor(cr_default);
			
			// Set Context
			setContext(BTContext.Model);
		}
		
		// Timesource
		time_source_start(time_source_create(time_source_game, 5, time_source_units_frames, func, [file, string_split(filename_name(file), ".")[0]]));
	}
}

function saveModelDialog()
{
	// Get Save File Name For Mesh Replacement
	var file = get_save_filename_ext(FILTERS.model, $"", SETTINGS.lastModelPath, "Save Model");
	if (file != "" && ord(file) != 0)
	{
		saveModel(file);
		SETTINGS.lastModelPath = filename_path(file);
	}
}

function saveModel(file)
{
	if (string_lower(filename_ext(file)) == ".ghg")
	{
		// User Feedback
		ENVIRONMENT.openInfoModal("Please wait", "Saving Model");
		window_set_cursor(cr_hourglass);
		
		// Define Function
		var func = function(file)
		{
			// Log
			ConsoleLog("Saving Model");
			
			// Save Model
			PROJECT.currentModel.saveGHG(file);
			
			// User Feedback
			ENVIRONMENT.closeInfoModal();
			window_set_cursor(cr_default);
		}
		
		// Timesource
		time_source_start(time_source_create(time_source_game, 5, time_source_units_frames, func, [file]));
	}
}

#endregion

#region Context

// General
function setContext(context = CONTEXT)
{
	// Delete Existing Environments
	array_delete(ENVIRONMENT.environments, 0, array_length(ENVIRONMENT.environments));
	ENVIRONMENT.currentEnvironment = 0;
	
	// Set Project Context
	if (context = BTContext.Project)
	{
		// Create Characters Environment
		var charactersEnvironment = new Environment();
		charactersEnvironment.name = "Characters";
		var charactersPanel = new CharactersPanel();
		charactersEnvironment.add(charactersPanel);
		var characterPropertiesPanel = new CharacterPropertiesPanel();
		charactersEnvironment.add(characterPropertiesPanel);
		var characterViewerPanel = new CharacterViewerPanel();
		charactersEnvironment.add(characterViewerPanel);
		ENVIRONMENT.add(charactersEnvironment);
		
		// Create Model Editor Environment
		var modelEditorEnvironment = new Environment();
		modelEditorEnvironment.name = "Model Editor";
		var modelAttributesPanel = new ModelAttributesPanel();
		modelEditorEnvironment.add(modelAttributesPanel);
		var modelViewerPanel = new ModelViewerPanel();
		modelEditorEnvironment.add(modelViewerPanel);
		var modelEditPanel = new ModelEditPanel();
		modelEditorEnvironment.add(modelEditPanel);
		ENVIRONMENT.add(modelEditorEnvironment);
	}
	
	// Set Model Editor Context
	else if (context = BTContext.Model)
	{
		// Create Model Editor Environment
		var modelEditorEnvironment = new Environment();
		modelEditorEnvironment.name = "Model Editor";
		var modelAttributesPanel = new ModelAttributesPanel();
		modelEditorEnvironment.add(modelAttributesPanel);
		var modelViewerPanel = new ModelViewerPanel();
		modelEditorEnvironment.add(modelViewerPanel);
		var modelEditPanel = new ModelEditPanel();
		modelEditorEnvironment.add(modelEditPanel);
		ENVIRONMENT.add(modelEditorEnvironment);
		
		// Create UV Viewer Environment
		var uvViewerEnvironment = new Environment();
		uvViewerEnvironment.name = "UV Viewer";
		var uvViewerPanel = new UVViewerPanel();
		uvViewerEnvironment.add(uvViewerPanel);
		ENVIRONMENT.add(uvViewerEnvironment);
	}
	
	// Set Scene Editor Context
	else if (context = BTContext.Scene)
	{
		// Create Scene Editor Environment
		var sceneEditorEnvironment = new Environment();
		modelEditorEnvironment.name = "Scene Editor";
		var modelAttributesPanel = new ModelAttributesPanel();
		modelEditorEnvironment.add(modelAttributesPanel);
		var modelViewerPanel = new ModelViewerPanel();
		modelEditorEnvironment.add(modelViewerPanel);
		var modelEditPanel = new ModelEditPanel();
		modelEditorEnvironment.add(modelEditPanel);
		ENVIRONMENT.add(modelEditorEnvironment);
	}
	
	CONTEXT = context;
}

#endregion

#region Settings

function saveSettings()
{
	SnapToBinary(SETTINGS, CONFIG_DIRECTORY + "settings.bin");
}

#endregion

#region Model Textures

function uiExportTexture(model, index)
{
	// Get Save File Name For DDS Export
	var file = get_save_filename_ext(FILTERS.texture, $"texture{index}.dds", SETTINGS.lastTexturePath, "Export Texture");
	if (file != "" && ord(file) != 0)
	{
		// User Feedback
		//ENVIRONMENT.openInfoModal("Please wait", "Converting GHG model to BactaTankModel");
		window_set_cursor(cr_hourglass);
		
		model.textures[index].export(file);
		
		SETTINGS.lastTexturePath = filename_path(file);
		
		window_set_cursor(cr_default);
	}
}

function uiReplaceTexture(model, index)
{
	// Get Save File Name For DDS Export
	var file = get_open_filename_ext(FILTERS.texture, $"texture.dds", SETTINGS.lastTexturePath, "Replace Texture");
	if (file != "" && ord(file) != 0)
	{
		// User Feedback
		ENVIRONMENT.openInfoModal("Please wait", "Decoding DDS Texture");
		window_set_cursor(cr_hourglass);
		
		// Define Function
		var func = function(model, index, file)
		{
			// Replace Texture
			model.textures[index].replace(file);
			
			// Set Last Texture Path
			SETTINGS.lastTexturePath = filename_path(file);
			
			// Enable Renderer
			RENDERER.activate();
			RENDERER.deactivate(2);
			
			// User Feedback
			ENVIRONMENT.closeInfoModal();
			window_set_cursor(cr_default);
		}
						
		// Timesource
		time_source_start(time_source_create(time_source_game, 3, time_source_units_frames, func, [model, index, file]));
	}
}

#endregion

#region Model Materials

function uiExportMaterial(model, index)
{
	// Get Save File Name For Material Export
	var file = get_save_filename_ext(FILTERS.material, $"material{index}.bmat", SETTINGS.lastMaterialPath, "Export Material");
	if (file != "" && ord(file) != 0)
	{
		// User Feedback
		window_set_cursor(cr_hourglass);
		
		model.materials[index].export(file);
		
		SETTINGS.lastMaterialPath = filename_path(file);
		
		window_set_cursor(cr_default);
	}
}

function uiReplaceMaterial(model, index)
{
	// Get Save File Name For Material Replacement
	var file = get_open_filename_ext(FILTERS.material, $"material.bmat", SETTINGS.lastMaterialPath, "Replace Material");
	if (file != "" && ord(file) != 0)
	{
		// User Feedback
		window_set_cursor(cr_hourglass);
		
		// Replace Material
		model.materials[index].replace(file);
		
		// Set Last Material Path
		SETTINGS.lastMaterialPath = filename_path(file);
		
		// Enable Renderer
		RENDERER.activate();
		RENDERER.deactivate(2);
		
		// User Feedback
		window_set_cursor(cr_default);
	}
}

#endregion

#region Model Meshes

function uiExportMesh(model, index)
{
	// Get Save File Name For Mesh Export
	var file = get_save_filename_ext(FILTERS.mesh, $"mesh{index}.bmesh", SETTINGS.lastMeshPath, "Export Mesh");
	if (file != "" && ord(file) != 0)
	{
		window_set_cursor(cr_hourglass);
		
		model.meshes[index].export(file, model);
		
		SETTINGS.lastMeshPath = filename_path(file);
		
		window_set_cursor(cr_default);
	}
}

function uiReplaceMesh(model, index)
{
	// Get Open File Name For Mesh Replacement
	var file = get_open_filename_ext(FILTERS.mesh, $"mesh.bmesh", SETTINGS.lastMeshPath, "Replace Mesh");
	if (file != "" && ord(file) != 0)
	{
		// User Feedback
		ENVIRONMENT.openInfoModal("Please wait", "Building Mesh");
		window_set_cursor(cr_hourglass);
		
		// Define Function
		var func = function(model, index, file)
		{
			// Replace Texture
			model.meshes[index].replace(file, model);
			
			// Set Last Texture Path
			SETTINGS.lastMeshPath = filename_path(file);
			
			// Clear Render Queue and Push Model Again
			RENDERER.flush();
			model.pushToRenderQueue(ENVIRONMENT.displayLayers, RENDERER, ENVIRONMENT.hideDisabledMeshes);
			
			// Enable Renderer
			RENDERER.activate();
			RENDERER.deactivate(2);
			
			// User Feedback
			ENVIRONMENT.closeInfoModal();
			window_set_cursor(cr_default);
		}
						
		// Timesource
		time_source_start(time_source_create(time_source_game, 3, time_source_units_frames, func, [model, index, file]));
	}
}

#endregion

#region Model Locators

function uiExportLocator(model, index)
{
	// Get Save File Name For Locator Export
	var file = get_save_filename_ext(FILTERS.locator, $"locator{index}.bloc", SETTINGS.lastLocatorPath, "Export Locator");
	if (file != "" && ord(file) != 0)
	{
		// User Feedback
		window_set_cursor(cr_hourglass);
		
		model.locators[index].export(file);
		
		SETTINGS.lastLocatorPath = filename_path(file);
		
		window_set_cursor(cr_default);
	}
}

function uiReplaceLocator(model, index)
{
	// Get Save File Name For Locator Replacement
	var file = get_open_filename_ext(FILTERS.locator, $"locator.bloc", SETTINGS.lastLocatorPath, "Replace Locator");
	if (file != "" && ord(file) != 0)
	{
		// User Feedback
		window_set_cursor(cr_hourglass);
		
		// Replace Locator
		model.locators[index].replace(file, model);
		
		// Set Last Locator Path
		SETTINGS.lastLocatorPath = filename_path(file);
		
		// Enable Renderer
		RENDERER.activate();
		RENDERER.deactivate(2);
		
		// User Feedback
		window_set_cursor(cr_default);
	}
}

#endregion

function uiExportArmature(model)
{
	// Get Save File Name For Armature
	var file = get_save_filename_ext(FILTERS.armature, $"armature.barm", SETTINGS.lastArmaturePath, "Export Locator");
	if (file != "" && ord(file) != 0)
	{
		// User Feedback
		window_set_cursor(cr_hourglass);
		
		model.armature.export(file);
		
		SETTINGS.lastArmaturePath = filename_path(file);
		
		window_set_cursor(cr_default);
	}
}

function exportArmature(model, file)
{
	ConsoleLog("Exporting Armature");
	model.armature.export(file);
}

function uiExportUVLayout(surface)
{
	// Get Save File Name For Mesh Replacement
	var file = get_save_filename_ext(FILTERS.uvLayout, $"UVLayout", SETTINGS.lastUVPath, "Save UV Layout");
	if (file != "" && ord(file) != 0)
	{
		// User Feedback
		ENVIRONMENT.openInfoModal("Please wait", "Exporting UV Layout");
		window_set_cursor(cr_hourglass);
		
		// Save UV Layout
		surface_save(surface, file);
		
		// Set Last UV Path
		SETTINGS.lastUVPath = filename_path(file);
		
		// User Feedback
		ENVIRONMENT.closeInfoModal();
		window_set_cursor(cr_default);
	}
}

function uiExportModel(model)
{
	// Get Save File Name For Mesh Replacement
	var file = get_save_filename_ext(FILTERS.exportModel, $"Model", SETTINGS.lastModelPath, "Save Model");
	if (file != "" && ord(file) != 0)
	{
		// User Feedback
		ENVIRONMENT.openInfoModal("Please wait", "Exporting Model");
		window_set_cursor(cr_hourglass);
		
		// Define Function
		var func = function(model, file)
		{
			// Export Model
			model.export(file);
			
			// Set Last UV Path
			SETTINGS.lastModelPath = filename_path(file);
			
			// User Feedback
			ENVIRONMENT.closeInfoModal();
			window_set_cursor(cr_default);
		}
						
		// Timesource
		time_source_start(time_source_create(time_source_game, 3, time_source_units_frames, func, [model, file]));
	}
}

function uiExportModelFromPreview(model, layers)
{
	// Get Save File Name For Mesh Replacement
	var file = get_save_filename_ext(FILTERS.exportModel, $"Model", SETTINGS.lastModelPath, "Save Model");
	if (file != "" && ord(file) != 0)
	{
		// User Feedback
		ENVIRONMENT.openInfoModal("Please wait", "Exporting Model");
		window_set_cursor(cr_hourglass);
		
		// Define Function
		var func = function(model, file, layers)
		{
			// Export Model
			model.export(file, layers);
			
			// Set Last UV Path
			SETTINGS.lastModelPath = filename_path(file);
			
			// User Feedback
			ENVIRONMENT.closeInfoModal();
			window_set_cursor(cr_default);
		}
						
		// Timesource
		time_source_start(time_source_create(time_source_game, 3, time_source_units_frames, func, [model, file, layers]));
	}
}

function loadTemplates()
{
	// Templates (Are here temporarily)
	TEMPLATES = [  ];
	
	// Load All Templates
	var file = file_find_first(TEMPLATES_DIRECTORY + "*.ghg", fa_none);
	
	while (file != "")
	{
		array_push(TEMPLATES, TEMPLATES_DIRECTORY + file);
	    file = file_find_next();
	}
	
	file_find_close();
}

function newSettings()
{
	return {
		// Version
		version: VERSION,
		
		// Window Settings
		window: {
			maximised: false,
			size: [1366, 768],
			position: [0, 0],
		},
		
		// Default Project Settings
		defaultProjectSettings: {
		
		},
		
		// Recent Projects
		recentProjects: [  ],
		
		// Filepath Settings
		lastProjectPath: "",
		lastCharacterPath: "",
		lastModelPath: "",
		
		// Attribute Specific Paths
		lastMeshPath: "",
		lastTexturePath: "",
		lastMaterialPath: "",
		lastLocatorPath: "",
		lastArmaturePath: "",
		lastUVPath: "",
		
		// Default Paths
		defaultProjectPath: environment_get_variable("USERPROFILE") + @"\Documents\BactaTank Projects",
		
		// Game Path Settings
		tcsPath: "",
		
		// Viewer Settings
		viewerSettings: {
			gridColour: [0.3, 0.3, 0.3, 1.0],
			colliderColour: [0.8, 0.3, 0.3, 1.0],
			locatorColour: [0.3, 0.3, 0.8, 1.0],
			locatorSelectedColour: [0.8, 0.5, 0.1, 1.0],
			boneColour: [1.0, 0.0, 0.0, 1.0],
			selectedBoneColour: [0.0, 1.0, 0.0, 1.0],
			uvMapColour: [1.0, 0.0, 0.0, 1.0],
			randomiseUVMapColours: true,
		},
		
		// General Settings
		showTooltips: true,
		displayHex: false,
		enableScripting: false,
		
		// Material Viewer
		showVertexFormat: true,
		showAssignedMeshes: true,
		
		// Console
		consoleEnabled: true,
		verboseOutput: false,
	}
}