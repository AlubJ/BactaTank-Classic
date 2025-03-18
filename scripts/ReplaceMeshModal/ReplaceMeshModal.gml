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
	mesh = new BactaTankBMesh();
	
	replaceDynamicBuffers = false;
	vertexAttributes = [];
	
	width = 680;
	height = 512;
	
	static render = function()
	{
		// Set Modal Position and Size
		ImGui.SetNextWindowPos(floor(WINDOW_SIZE[0] / 2) - width / 2, floor(WINDOW_SIZE[1] / 2) - height / 2, ImGuiCond.Always);
		ImGui.SetNextWindowSize(width, height, ImGuiCond.Once);
		
		// Begin Modal
		if (ImGui.BeginPopupModal(name, true, ImGuiWindowFlags.NoMove | ImGuiWindowFlags.NoResize))
		{
			// Set Modal Open
			modalOpen = true;
			
			// Create Replace Mesh
			ImGui.Text("Replace Mesh");
			ImGui.Separator();
			
			// Mesh File
			var lastMeshFile = meshFile;
			meshFile = ImGui.InputFileCustom("Mesh File", meshFile, "##HiddenMeshFile", 120, NO_DEFAULT, FILTERS.mesh, "", SETTINGS.lastMeshPath, ImGuiInputFileFlags.Open);
			if (lastMeshFile != meshFile && meshFile != "" && meshFile != NULL)
			{
				mesh.destroy();
				mesh.import(meshFile, PROJECT.currentModel);
				
				// Fill Vertex Attributes
				vertexAttributes = [];
				for (var i = 0; i < array_length(mesh.attributes); i++)
				{
					array_push(vertexAttributes, [mesh.attributes[i], true]);
				}
			}
			
			ImGui.Spacing();
			
			// Only If A Mesh Is Loaded
			if (mesh.vertexCount != 0)
			{
				// Mesh Properties Child
				ImGui.BeginChild("MeshReplacementProperties", (width / 2 - 16), -28)
				{
					// Text
					ImGui.Text("Mesh Properties");
					ImGui.Separator();
					
					// Spacing
					ImGui.Spacing();
					
					// Text
					ImGui.Text("Replace Attributes");
					ImGui.Separator();
					
					// Replace Attributes
					for (var i = 0; i < array_length(vertexAttributes); i++)
					{
						// Get Cursor Position
						var cursorPos = [ImGui.GetCursorPosX(), ImGui.GetCursorPosY()];
						
						// Selectable
						if (ImGui.Selectable(vertexAttributes[i][0], false)) vertexAttributes[i][1] = !vertexAttributes[i][1];
						
						// Checkmark
						ImGui.SetCursorPos(cursorPos[0] + 200, cursorPos[1] + 2);
						ImGui.Image(graCheck, !vertexAttributes[i][1]);
					}
					
					// End Child
					ImGui.EndChild();
				}
			
				// Same Line
				ImGui.SameLine();
			
				// Mesh Preview Child
				ImGui.BeginChild("MeshReplacementPreview", (width / 2 - 16), -28)
				{
					// Text
					ImGui.Text("Mesh Preview");
					ImGui.Separator();
				
					// End Child
					ImGui.EndChild();
				}
			
				// Create Project Button
				ImGui.SetCursorPosX((width / 2) - 48);
				if (ImGui.Button("Replace Mesh", 96))
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
			}
			else
			{
				ImGui.Text("Please select a mesh file.");
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