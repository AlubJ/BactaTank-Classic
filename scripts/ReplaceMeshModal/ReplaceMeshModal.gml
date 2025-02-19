/*
	ReplaceMeshModal
	-------------------------------------------------------------------------
	Script:			ReplaceMeshModal
	Version:		v1.00
	Created:		13/02/2025 by Alun Jones
	Description:	Modal for Replacing Meshes
	-------------------------------------------------------------------------
	History:
	 - Created 13/02/2025 by Alun Jones
	
	To Do:
*/

function ReplaceMeshModal() : Modal() constructor
{
	name = "Replace Mesh";
	
	meshFile = "";
	
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
			
			// Create Replace Mesh
			ImGui.Text("Replace Mesh");
			ImGui.Separator();
			
			// Mesh File
			meshFile = ImGui.InputFileCustom("Mesh File", meshFile, "##HiddenMeshFile", 120, NO_DEFAULT, FILTERS.mesh, "", SETTINGS.lastMeshPath, ImGuiInputFileFlags.Open);
			
			// Create Project Button
			ImGui.SetCursorPosX((560 / 2) - 48);
			if (ImGui.Button("Add Model", 96))
			{
				if (file_exists(meshFile))
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
			
			// End Popup
			ImGui.EndPopup();
		}
		else
		{
			modalOpen = false;
		}
	}
}