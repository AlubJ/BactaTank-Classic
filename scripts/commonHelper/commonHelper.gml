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
	var file = get_save_filename_ext(FILTERS.texture, $"texture{model.textureMetaData[index].index}.dds", SETTINGS.lastTexturePath, "Export Texture");
	if (file != "" && ord(file) != 0)
	{
		// User Feedback
		//ENVIRONMENT.openInfoModal("Please wait", "Converting GHG model to BactaTankModel");
		window_set_cursor(cr_hourglass);
		
		model.exportTexture(index, file);
		
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
			model.replaceTexture(index, file);
			
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
		
		model.exportMaterial(index, file);
		
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
		model.replaceMaterial(index, file);
		
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
	var file = get_save_filename_ext(FILTERS.mesh, $"mesh{index}.btank", SETTINGS.lastMeshPath, "Export Mesh");
	if (file != "" && ord(file) != 0)
	{
		window_set_cursor(cr_hourglass);
		
		model.exportMesh(index, file);
		
		SETTINGS.lastMeshPath = filename_path(file);
		
		window_set_cursor(cr_default);
	}
}

function uiReplaceMesh(model, index)
{
	// Get Open File Name For Mesh Replacement
	var file = get_open_filename_ext(FILTERS.mesh, $"mesh.btank", SETTINGS.lastMeshPath, "Replace Mesh");
	if (file != "" && ord(file) != 0)
	{
		// User Feedback
		ENVIRONMENT.openInfoModal("Please wait", "Building Mesh");
		window_set_cursor(cr_hourglass);
		
		// Define Function
		var func = function(model, index, file)
		{
			// Replace Texture
			model.replaceMesh(index, file);
			
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
		
		model.exportLocator(index, file);
		
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
		model.replaceLocator(index, file);
		
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

function exportArmature(model, file)
{
	ConsoleLog("Exporting Armature");
	var buffer = buffer_create(1, buffer_grow, 1);
	buffer_write(buffer, buffer_s32, array_length(model.bones));
	for (var i = 0; i < array_length(model.bones); i++)
	{
		buffer_write(buffer, buffer_string, model.bones[i].name);
		buffer_write(buffer, buffer_s32, model.bones[i].parent);
		for (var m = 0; m < 16; m++) buffer_write(buffer, buffer_f32, model.bones[i].matrix[m]);
	}
	buffer_save(buffer, file);
	buffer_delete(buffer);
}