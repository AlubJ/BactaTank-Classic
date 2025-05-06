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
	var file = get_open_filename_ext(FILTERS.model, $"", SETTINGS.lastProjectPath, "Open Model");
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
			var model = noone;
			try
			{
				model = new BactaTankModel(file);
			}
			catch (exception)
			{
				throwException(exception, true, true);
			}
			
			// Check Valid Model
			if (model != noone)
			{
				// Save Canister Model
				//model.saveCanister(PROJECT.workingDirectory + name + ".bcanister");
				
				// Set Current Model
				PROJECT.currentModel = model;
				model.pushToRenderQueue(model.type == BTModelType.model ? array_create(array_length(model.layers), true) : -1);
				
				// Reset Camera
				CAMERA.reset();
				CAMERA.lookAtPosition.x = model.averagePosition[0];
				CAMERA.lookAtPosition.y = model.averagePosition[1];
				CAMERA.lookAtPosition.z = model.averagePosition[2];
				CAMERA.stepThird();
				
				// Activate Renderer
				RENDERER.activate();
				
				// Push To Project Models
				array_push(MODELS, name);
				
				// User Feedback
				ENVIRONMENT.closeInfoModal();
				window_set_cursor(cr_default);
				
				// Set Model Name
				MODEL_NAME = filename_name(file);
				window_set_caption($"{MODEL_NAME} - BactaTank Classic");
			
				// Set Context
				setContext(model.type == BTModelType.model ? BTContext.Model : BTContext.Model);
				
				// Apply Font
				ImGui.AddFontFromFile(THEMES_DIRECTORY + "nunito.ttf", 16);
			}
			else
			{
				//model.destroy();
				ENVIRONMENT.closeInfoModal();
				ENVIRONMENT.openInfoModal("Model Load Error", "There was an error whilst loading the model file.", INFO_BUTTONS.OK);
			}
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
		uiSaveModel(file);
		SETTINGS.lastModelPath = filename_path(file);
	}
}

function uiSaveModel(file)
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
		
		// Clear Shortcuts
		SHORTCUTS.clear();
		
		// Set Shortcuts
		// New Model
		SHORTCUTS.add("NewModel", SETTINGS.shortcuts.newModel, function() {
			ENVIRONMENT.openConfirmModal("Unsaved Changes", "Are you sure you want to continue?", function() {
				ENVIRONMENT.openModal("Welcome");
			});
		});
		
		// Open Model
		SHORTCUTS.add("OpenModel", SETTINGS.shortcuts.openModel, function() {
			ENVIRONMENT.openConfirmModal("Unsaved Changes", "Are you sure you want to continue?", function() {
				openProjectOrModelDialog();
			});
		});
		
		// Save Model
		SHORTCUTS.add("SaveModel", SETTINGS.shortcuts.saveModel, function() {
			saveModelDialog();
		});
		
		// Open Preferences
		SHORTCUTS.add("OpenPreferences", SETTINGS.shortcuts.openPreferences, function() {
			ENVIRONMENT.openModal("Preferences");
		});
		
		// Export Current Selected
		SHORTCUTS.add("ExportCurrentSelected", SETTINGS.shortcuts.exportCurrentSelected, function() {
			if (ENVIRONMENT.attributeSelected != undefined || ENVIRONMENT.attributeSelected != -1)
			{
				var index = string_digits(ENVIRONMENT.attributeSelected);
				if (string_pos("TEX", ENVIRONMENT.attributeSelected)) // Export Texture
				{
					uiExportTexture(PROJECT.currentModel, index);
				}
				else if (string_pos("MAT", ENVIRONMENT.attributeSelected)) // Export Material
				{
					uiExportMaterial(PROJECT.currentModel, index);
				}
				else if (string_pos("MESH", ENVIRONMENT.attributeSelected)) // Export Mesh
				{
					uiExportMesh(PROJECT.currentModel, index);
				}
				else if (string_pos("LOC", ENVIRONMENT.attributeSelected)) // Export Locator
				{
					uiExportLocator(PROJECT.currentModel, index);
				}
			}
		});
		
		// Replace Current Selected
		SHORTCUTS.add("ReplaceCurrentSelected", SETTINGS.shortcuts.replaceCurrentSelected, function() {
			if (ENVIRONMENT.attributeSelected != undefined || ENVIRONMENT.attributeSelected != -1)
			{
				var index = string_digits(ENVIRONMENT.attributeSelected);
				if (string_pos("TEX", ENVIRONMENT.attributeSelected)) // Replace Texture
				{
					uiReplaceTexture(PROJECT.currentModel, index);
				}
				else if (string_pos("MAT", ENVIRONMENT.attributeSelected)) // Replace Material
				{
					uiReplaceMaterial(PROJECT.currentModel, index);
				}
				else if (string_pos("MESH", ENVIRONMENT.attributeSelected)) // Replace Mesh
				{
					uiReplaceMesh(PROJECT.currentModel, index);
				}
				else if (string_pos("LOC", ENVIRONMENT.attributeSelected)) // Replace Locator
				{
					uiReplaceLocator(PROJECT.currentModel, index);
				}
			}
		});
		
		// Dereference Mesh
		SHORTCUTS.add("DereferenceMesh", SETTINGS.shortcuts.dereferenceMesh, function() {
			if (ENVIRONMENT.attributeSelected != undefined || ENVIRONMENT.attributeSelected != -1)
			{
				var index = string_digits(ENVIRONMENT.attributeSelected);
				if (string_pos("MESH", ENVIRONMENT.attributeSelected)) // Dereference Mesh
				{
					ENVIRONMENT.openConfirmModal("Dereference Mesh", "Dereferencing this mesh will delete everything associated with this mesh. Are you sure you want to continue? This cannot be undone.", function(model, index) {
						// Dereference Mesh
						model.meshes[index].dereference();
						
						// Clear Render Queue and Push Model Again
						RENDERER.flush();
						model.pushToRenderQueue(ENVIRONMENT.displayLayers, RENDERER, ENVIRONMENT.hideDisabledMeshes);
						
						// Clear Secondary Renderers Queue
						SECONDARY_RENDERER.flush();
						
						// Enable Renderer
						RENDERER.activate();
						RENDERER.deactivate(2);
					}, [PROJECT.currentModel, index]);
				}
			}
		});
		
		// Toggle Mesh Type
		SHORTCUTS.add("ToggleMeshType", SETTINGS.shortcuts.toggleMeshType, function() {
			if (ENVIRONMENT.attributeSelected != undefined || ENVIRONMENT.attributeSelected != -1)
			{
				var index = string_digits(ENVIRONMENT.attributeSelected);
				if (string_pos("MESH", ENVIRONMENT.attributeSelected) && PROJECT.currentModel.meshes[index].vertexCount != 0) // Toggle Mesh Type
				{
					PROJECT.currentModel.meshes[index].type = PROJECT.currentModel.meshes[index].type == 0 ? 6 : 0;
					
					// Clear Render Queue and Push Model Again
					RENDERER.flush();
					PROJECT.currentModel.pushToRenderQueue(ENVIRONMENT.displayLayers, RENDERER, ENVIRONMENT.hideDisabledMeshes);
					
					// Clear Secondary Renderers Queue
					SECONDARY_RENDERER.flush();
					
					// Enable Renderer
					RENDERER.activate();
					RENDERER.deactivate(2);
				}
			}
		});
		
		// Export Armature
		SHORTCUTS.add("ExportArmature", SETTINGS.shortcuts.exportArmature, function() {
			uiExportArmature(PROJECT.currentModel);
		});
		
		// Export Model
		SHORTCUTS.add("ExportModel", SETTINGS.shortcuts.exportModel, function() {
			uiExportModel(PROJECT.currentModel);
		});
		
		// Export Model From Preview
		SHORTCUTS.add("ExportModelFromPreview", SETTINGS.shortcuts.exportModelFromPreview, function() {
			uiExportModelFromPreview(PROJECT.currentModel, ENVIRONMENT.displayLayers);
		});
		
		// Export Render
		SHORTCUTS.add("ExportRender", SETTINGS.shortcuts.exportRender, function() {
			var file = get_save_filename_ext("Portable Network Graphics (*.png)|*.png", "Render.png", "", "Export Render");
			if (file != "" && ord(file) != 0)
			{
				surface_save(RENDERER.surface, file);
			}
		});
		
		// Toggle Locators
		SHORTCUTS.add("ToggleLocatorDisplay", SETTINGS.shortcuts.toggleLocators, function() {
			ENVIRONMENT.displayLocators++;
			if (ENVIRONMENT.displayLocators > 2) ENVIRONMENT.displayLocators = 0;
		});
		
		// Toggle Locator Names
		SHORTCUTS.add("ToggleLocatorNames", SETTINGS.shortcuts.toggleLocatorNames, function() {
			ENVIRONMENT.displayLocatorNames = !ENVIRONMENT.displayLocatorNames;
		});
		
		// Toggle Bones
		SHORTCUTS.add("ToggleBoneDisplay", SETTINGS.shortcuts.toggleBones, function() {
			ENVIRONMENT.displayBones = !ENVIRONMENT.displayBones;
		});
		
		// Toggle Bone Names
		SHORTCUTS.add("ToggleBonesNames", SETTINGS.shortcuts.toggleBoneNames, function() {
			ENVIRONMENT.displayBoneNames = !ENVIRONMENT.displayBoneNames;
		});
		
		// Toggle Grid
		SHORTCUTS.add("ToggleGridDisplay", SETTINGS.shortcuts.toggleGrid, function() {
			ENVIRONMENT.displayGrid = !ENVIRONMENT.displayGrid;
		});
		
		// Toggle Disabled Meshes
		SHORTCUTS.add("ToggleDisabledMeshes", SETTINGS.shortcuts.toggleHiddenMeshes, function() {
			ENVIRONMENT.hideDisabledMeshes = !ENVIRONMENT.hideDisabledMeshes;
		});
		
		// Reset Camera
		SHORTCUTS.add("ResetCamera", SETTINGS.shortcuts.resetCamera, function() {
			CAMERA.reset();
			CAMERA.lookAtPosition.x = PROJECT.currentModel.averagePosition[0];
			CAMERA.lookAtPosition.y = PROJECT.currentModel.averagePosition[1];
			CAMERA.lookAtPosition.z = PROJECT.currentModel.averagePosition[2];
			CAMERA.stepThird();
		});
	}
	
	// Set Scene Editor Context
	else if (context = BTContext.Scene)
	{
		// Create Scene Editor Environment
		var sceneEditorEnvironment = new Environment();
		sceneEditorEnvironment.name = "Scene Editor";
		var modelAttributesPanel = new ModelAttributesPanel();
		sceneEditorEnvironment.add(modelAttributesPanel);
		var modelViewerPanel = new ModelViewerPanel();
		sceneEditorEnvironment.add(modelViewerPanel);
		var modelEditPanel = new ModelEditPanel();
		sceneEditorEnvironment.add(modelEditPanel);
		ENVIRONMENT.add(sceneEditorEnvironment);
	}
	
	// Set Icon Editor Context
	else if (context = BTContext.Icon)
	{
		// Create Icon Editor Environment
		var iconEditorEnvironment = new Environment();
		iconEditorEnvironment.name = "Icon Editor";
		var iconAttributesPanel = new IconAttributesPanel();
		iconEditorEnvironment.add(iconAttributesPanel);
		ENVIRONMENT.add(iconEditorEnvironment);
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
	var file = get_save_filename_ext(FILTERS.armature, $"armature.barm", SETTINGS.lastArmaturePath, "Export Armature");
	if (file != "" && ord(file) != 0)
	{
		// User Feedback
		window_set_cursor(cr_hourglass);
		
		model.armature.export(file);
		
		SETTINGS.lastArmaturePath = filename_path(file);
		
		window_set_cursor(cr_default);
	}
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

function uiSwizzleNormalMap(flipGreenChannel = false)
{
	var file = get_open_filename(FILTERS.uvLayout, "normalmap.png");
	
	if (file != "" && ord(file) != 0)
	{
		// Get Filename With No Extension
		var filename = filename_change_ext(file, "");
		
		// Load The PNG As A Sprite
		var sprite = sprite_add(file, 0, false, false, 0, 0);
		
		// Create A Surface
		var surface = surface_create(sprite_get_width(sprite), sprite_get_height(sprite));
		
		// Set Surface Target
		surface_set_target(surface);
		draw_clear_alpha(c_black, 0);
		
		// Use Shader
		shader_set(shdSwizzle);
		
		// Flip Green Channel
		shader_set_uniform_i(shader_get_uniform(shdSwizzle, "uFlipGreen"), flipGreenChannel);
		
		// Draw The Sprite
		draw_sprite(sprite, 0, 0, 0);
		
		// Reset Shader
		shader_reset();
		
		// Reset Surface
		surface_reset_target();
		
		// Save Surface
		surface_save(surface, filename + "_swizzled.png");
		
		// Cleanup
		surface_free(surface);
		sprite_delete(sprite);
	}
}

function uiBulkExportTextures(model)
{
	// Get Save File Name For All Textures Export
	var file = get_save_filename_ext(FILTERS.texture, $"textures.dds", SETTINGS.lastTexturePath, "Export All Textures");
	if (file != "" && ord(file) != 0)
	{
		// User Feedback
		window_set_cursor(cr_hourglass);
		
		var path = filename_path(file);
		
		for (var i = 0; i < array_length(model.textures); i++)
		{
			if (model.textures[i] != 0) model.textures[i].export($"{path}texture{i}.dds");
		}
		
		SETTINGS.lastTexturePath = filename_path(file);
		
		window_set_cursor(cr_default);
	}
}

function uiBulkExportMaterials(model)
{
	// Get Save File Name For All Materials Export
	var file = get_save_filename_ext(FILTERS.material, $"material.bmat", SETTINGS.lastMaterialPath, "Export All Materials");
	if (file != "" && ord(file) != 0)
	{
		// User Feedback
		window_set_cursor(cr_hourglass);
		
		var path = filename_path(file);
		
		for (var i = 0; i < array_length(model.materials); i++)
		{
			model.materials[i].export($"{path}material{i}.bmat");
		}
		
		SETTINGS.lastMaterialPath = filename_path(file);
		
		window_set_cursor(cr_default);
	}
}

function uiBulkExportMeshes(model)
{
	// Get Save File Name For All Meshes Export
	var file = get_save_filename_ext(FILTERS.mesh, $"meshes.bmesh", SETTINGS.lastMeshPath, "Export All Meshes");
	if (file != "" && ord(file) != 0)
	{
		// User Feedback
		window_set_cursor(cr_hourglass);
		
		var path = filename_path(file);
		
		for (var i = 0; i < array_length(model.meshes); i++)
		{
			if (model.meshes[i].vertexCount != 0) model.meshes[i].export($"{path}mesh{i}.bmesh", model);
		}
		
		SETTINGS.lastMeshPath = filename_path(file);
		
		window_set_cursor(cr_default);
	}
}

function uiBulkExportLocators(model)
{
	// Get Save File Name For All Locators Export
	var file = get_save_filename_ext(FILTERS.locator, $"locators.bloc", SETTINGS.lastLocatorPath, "Export All Locators");
	if (file != "" && ord(file) != 0)
	{
		// User Feedback
		window_set_cursor(cr_hourglass);
		
		var path = filename_path(file);
		
		for (var i = 0; i < array_length(model.locators); i++)
		{
			if (model.locators[i] != -1) model.locators[i].export($"{path}locator{i}.bloc");
		}
		
		SETTINGS.lastLocatorPath = filename_path(file);
		
		window_set_cursor(cr_default);
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
	
	// Console
	ConsoleLog("Templates Loaded");
}

function loadThemes()
{
	// Themes
	THEMES = {};
	
	// Load All Templates
	var file = file_find_first(THEMES_DIRECTORY + "*.yml", fa_none);
	
	while (file != "")
	{
		// Load File Contents
		var buffer = buffer_load(THEMES_DIRECTORY + file);
		var yaml = buffer_read(buffer, buffer_text);
		buffer_delete(buffer);
		
		// Snap From YAML
		var struct = SnapFromYAML(yaml);
		
		// Add To Themes
		THEMES[$ struct[$ "name"]] = struct;
		
	    file = file_find_next();
	}
	
	file_find_close();
	
	// Console
	ConsoleLog("Themes Loaded");
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
		defaultProjectPath: environment_get_variable("USERPROFILE") + @"\Documents\BactaTank Projects\",
		
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
		
		// Shortcuts
		shortcuts: {
			newModel: "Ctrl+N",
			openModel: "Ctrl+O",
			saveModel: "Ctrl+S",
			openPreferences: "Ctrl+P",
			
			exportArmature: "Ctrl+Shift+A",
			exportModel: "Ctrl+Shift+E",
			exportModelFromPreview: "Ctrl+Alt+E",
			exportRender: "F12",
			
			resetCamera: "R",
			toggleHiddenMeshes: "M",
			toggleGrid: "G",
			toggleLocators: "L",
			toggleLocatorNames: "Ctrl+L",
			toggleBones: "B",
			toggleBoneNames: "Ctrl+B",
			
			exportCurrentSelected: "Ctrl+E",
			replaceCurrentSelected: "Ctrl+R",
			toggleMeshType: "Ctrl+W",
			dereferenceMesh: "Ctrl+D",
		},
		
		// General Settings
		showTooltips: true,					// Shows Tooltips
		displayHex: false,					// Displays Any Decimal Values Hex
		enableScripting: false,				// Enables The Use Of Scripting (Currently Unused)
		exportNU20Last: false,				// Enables forcing NU20 First models (LB1 / LIJ1) to export as NU20 Last
		allowVersion1:	false,				// Allows GHG Version 1 to be loaded (TFTG)
		allowGSC:		false,				// Allows GSC files to be loaded
		cacheTextures:	true,				// Cache textures for faster loading
		
		// Material Viewer
		advancedMaterialSettings: false,	// Shows The Advanced Material Settings (Ambient / Specular Tint / Specular ID / Render Options)
		showVertexFormat: true,				// Shows The Vertex Format In The Material Edit Panel
		showAssignedMeshes: true,			// Shows The Materials Assigned Meshes
		replaceVertexFormat: false,			// Allows Replacing The Vertex Format
		
		// Mesh
		rebuildDynamicBuffers: true,		// Rebuilds dynamic buffers for custom face poses and stuff
		
		// Rendering
		simplifyRendering: false,			// Disabled Fancy Effects
		lowerRenderResolution: false,		// Lowers The Render Resolution
		enableMSAA:	false,					// Enables MSAA for rendering smooth edges
		
		// Debug
		consoleEnabled: false,				// Enables The Console Window
		verboseOutput: false,				// Extra Debug Stuff
		displayViewerDebugInfo: false,		// Display Viewer Debug Information
		
		// Theme
		theme: "Default Dark",
		
		// Ignore Version
		ignoreVersion: "0.0.0",
	}
}

function upgradeSettings(settings)
{
	var defaultSettings = newSettings();
	var defaultNames = variable_struct_get_names(defaultSettings);
	
	for (var i = 0; i < array_length(defaultNames); i++)
	{
		if (!variable_struct_exists(settings, defaultNames[i]) && !is_struct(settings[$ defaultNames[i]])) settings[$ defaultNames[i]] = defaultSettings[$ defaultNames[i]];
		
		// Apply Default Shortcuts
		if (variable_struct_exists(settings, "shortcuts"))
		{
			var shortcutNames = variable_struct_get_names(defaultSettings.shortcuts);
			
			for (var j = 0; j < array_length(shortcutNames); j++)
			{
				if (!variable_struct_exists(settings.shortcuts, shortcutNames[j]) && !is_struct(settings.shortcuts[$ shortcutNames[j]]))
				{
					settings.shortcuts[$ shortcutNames[j]] = defaultSettings.shortcuts[$ shortcutNames[j]];
				}
			}
		}
		else
		{
			settings.shortcuts = defaultSettings.shortcuts;
		}
		
		// Apply Default Viewer Settings
		if (variable_struct_exists(settings, "viewerSettings"))
		{
			var viewerSettingsNames = variable_struct_get_names(defaultSettings.viewerSettings);
			
			for (var j = 0; j < array_length(viewerSettingsNames); j++)
			{
				if (!variable_struct_exists(settings.viewerSettings, viewerSettingsNames[j]) && !is_struct(settings.viewerSettings[$ viewerSettingsNames[j]]))
				{
					settings.viewerSettings[$ viewerSettingsNames[j]] = defaultSettings.viewerSettings[$ viewerSettingsNames[j]];
				}
			}
		}
		else
		{
			settings.viewerSettings = defaultSettings.viewerSettings;
		}
	}
}