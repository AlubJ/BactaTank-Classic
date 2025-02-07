/*
	AddModelModal
	-------------------------------------------------------------------------
	Script:			AddModelModal
	Version:		v1.00
	Created:		14/01/2025 by Alun Jones
	Description:	AddModelModal
	-------------------------------------------------------------------------
	History:
	 - Created 14/01/2025 by Alun Jones
	
	To Do:
*/

function AddModelModal() : Modal() constructor
{
	name = "Add Model";
	
	modelName = "NEW_MODEL";
	modelFile = "";
	
	static render = function()
	{
		// Set Modal Position and Size
		ImGui.SetNextWindowPos(floor(WINDOW_SIZE[0] / 2) - 280, floor(WINDOW_SIZE[1] / 2) - 256, ImGuiCond.Always);
		ImGui.SetNextWindowSize(560, 512, ImGuiCond.Once);
		
		// Begin Modal
		if (ImGui.BeginPopupModal(name, true, ImGuiWindowFlags.NoMove | ImGuiWindowFlags.NoResize))
		{
			// Set Modal Open
			modalOpen = true;
			
			// Create Add Model Header
			ImGui.Text("Add Model");
			ImGui.Separator();
			
			// Model Name / File
			modelName = ImGui.InputTextCustom("Model Name", modelName, "##HiddenModelName", 120, "NEW_MODEL");
			modelFile = ImGui.InputFileCustom("Model File", modelFile, "##HiddenModelFile", 120, NO_DEFAULT, FILTERS.model, "", SETTINGS.lastModelPath, ImGuiInputFileFlags.Open);
			
			// Create Project Button
			ImGui.SetCursorPosX((560 / 2) - 48);
			if (ImGui.Button("Add Model", 96))
			{
				if (file_exists(modelFile))
				{
					// Set Last Model Path
					SETTINGS.lastModelPath = filename_path(modelFile);
					saveSettings();
					
					if (string_lower(filename_ext(modelFile)) == ".ghg")
					{
						// User Feedback
						ImGui.CloseCurrentPopup();
						ENVIRONMENT.openInfoModal("Please wait", "Converting GHG model to BactaTankModel");
						window_set_cursor(cr_hourglass);
						
						// Define Function
						var func = function(file, name)
						{
							// Log
							ConsoleLog("Beginning Model Conversion");
							
							// Load Model
							var model = new BactaTankModel(file);
							
							// Save Canister Model
							model.saveCanister(PROJECT.workingDirectory + name + ".bcanister");
							
							// Destroy Model
							model.destroy();
							
							// Push To Project Models
							array_push(MODELS, name);
							
							// User Feedback
							ENVIRONMENT.closeInfoModal();
							window_set_cursor(cr_default);
						}
						
						// Timesource
						time_source_start(time_source_create(time_source_game, 3, time_source_units_frames, func, [modelFile, modelName]));
					}
				}
			}
			
			// Spacing
			ImGui.Spacing();
			
			// Add From Asset Pack Header
			ImGui.Text("Add From Asset Pack");
			ImGui.Separator();
			
			// Open Recent Child
			if (ImGui.BeginChild("AddFromAssetPack"))
			{
				
				// End Child
				ImGui.EndChild();
			}
			
			// End Popup
			ImGui.EndPopup();
		}
		else
		{
			modalOpen = false;
		}
	}
}