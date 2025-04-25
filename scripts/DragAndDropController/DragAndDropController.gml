function DragAndDropController()
{
	// Get Files
	var files = file_dropper_get_files([".ghg", /*".gsc",*/ ".btank", ".bmesh", ".bloc", ".bmat", ".dds"]);
	file_dropper_flush();
	
	// Check Context
	if (array_length(files) > 0)
	{
		if (CONTEXT == BTContext.None)
		{
			// We only check for .GHG here.
			if (filename_ext(files[0]) == ".ghg" || filename_ext(files[0]) == ".gsc")
			{
				if (file_exists(files[0]))
				{
					SetWindowActive(window_handle());
					openProjectOrModel(files[0]);
					ImGui.CloseCurrentPopup();
				}
			}
		}
		else if (CONTEXT == BTContext.Model && ENVIRONMENT.currentEnvironment == 1)
		{
			// We only check for .GHG here, since there isn't anything to replace
			if (filename_ext(files[0]) == ".ghg" || filename_ext(files[0]) == ".gsc")
			{
				if (file_exists(files[0]))
				{
					SetWindowActive(window_handle());
					ENVIRONMENT.openConfirmModal("Unsaved Changes", "Are you sure you want to continue?", function(file) {
						openProjectOrModel(file);
					}, [files[0]]);
				}
			}
		}
		else if (CONTEXT == BTContext.Model)
		{
			// We only check for .GHG here, since there isn't anything to replace
			if ((filename_ext(files[0]) == ".ghg" || filename_ext(files[0]) == ".gsc"))
			{
				if (file_exists(files[0]))
				{
					SetWindowActive(window_handle());
					ENVIRONMENT.openConfirmModal("Unsaved Changes", "Are you sure you want to continue?", function(file) {
						openProjectOrModel(file);
					}, [files[0]]);
				}
			}
			else if (string_pos("TEX", ENVIRONMENT.attributeSelected))
			{
				// Index
				var index = string_digits(ENVIRONMENT.attributeSelected);
				
				if (filename_ext(files[0]) == ".dds")
				{
					if (file_exists(files[0]))
					{
						// Set Active Window
						SetWindowActive(window_handle());
						
						// User Feedback
						ENVIRONMENT.openInfoModal("Please wait", "Decoding DDS Texture");
						window_set_cursor(cr_hourglass);
						
						// Define Function
						var func = function(model, index, file)
						{
							// Replace Texture
							model.textures[index].replace(file);
							
							// Enable Renderer
							RENDERER.activate();
							RENDERER.deactivate(2);
							
							// User Feedback
							ENVIRONMENT.closeInfoModal();
							window_set_cursor(cr_default);
						}
						
						// Timesource
						time_source_start(time_source_create(time_source_game, 3, time_source_units_frames, func, [PROJECT.currentModel, index, files[0]]));
					}
				}
			}
			else if (string_pos("MAT", ENVIRONMENT.attributeSelected))
			{
				// Index
				var index = string_digits(ENVIRONMENT.attributeSelected);
				
				if (filename_ext(files[0]) == ".bmat")
				{
					if (file_exists(files[0]))
					{
						// Set Active Window
						SetWindowActive(window_handle());
						
						// User Feedback
						window_set_cursor(cr_hourglass);
						
						// Replace Material
						PROJECT.currentModel.materials[index].replace(files[0]);
						
						// Enable Renderer
						RENDERER.activate();
						RENDERER.deactivate(2);
						
						// User Feedback
						window_set_cursor(cr_default);
					}
				}
			}
			else if (string_pos("MESH", ENVIRONMENT.attributeSelected))
			{
				// Index
				var index = string_digits(ENVIRONMENT.attributeSelected);
				
				if (filename_ext(files[0]) == ".bmesh" || filename_ext(files[0]) == ".btank")
				{
					if (file_exists(files[0]))
					{
						// Set Active Window
						SetWindowActive(window_handle());
						
						// User Feedback
						ENVIRONMENT.openInfoModal("Please wait", "Building Mesh");
						window_set_cursor(cr_hourglass);
						
						// Define Function
						var func = function(model, index, file)
						{
							// Replace Texture
							model.meshes[index].replace(file, model);
							
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
						time_source_start(time_source_create(time_source_game, 3, time_source_units_frames, func, [PROJECT.currentModel, index, files[0]]));
					}
				}
			}
			else if (string_pos("LOC", ENVIRONMENT.attributeSelected))
			{
				// Index
				var index = string_digits(ENVIRONMENT.attributeSelected);
				
				if (filename_ext(files[0]) == ".bloc")
				{
					if (file_exists(files[0]))
					{
						// Set Active Window
						SetWindowActive(window_handle());
						
						// User Feedback
						window_set_cursor(cr_hourglass);
						
						// Replace Locator
						PROJECT.currentModel.locators[index].replace(files[0], PROJECT.currentModel);
						
						// Enable Renderer
						RENDERER.activate();
						RENDERER.deactivate(2);
						
						// User Feedback
						window_set_cursor(cr_default);
					}
				}
			}
		}
	}
}