/*
	NewProjectModal
	-------------------------------------------------------------------------
	Script:			NewProjectModal
	Version:		v1.00
	Created:		03/12/2024 by Alun Jones
	Description:	New Project Modal
	-------------------------------------------------------------------------
	History:
	 - Created 03/12/2024 by Alun Jones
	
	To Do:
*/

function NewProjectModal() : Modal() constructor
{
	name = "New Project";
	
	width = 560;
	height = 164;
	
	projectName = "New Project";
	projectDirectory = SETTINGS.lastProjectPath;
	projectType = 0;
	
	static render = function()
	{
		// Set Modal Position and Size
		ImGui.SetNextWindowPos(floor(WINDOW_SIZE[0] / 2) - floor(width / 2), floor(WINDOW_SIZE[1] / 2) - floor(height / 2), ImGuiCond.Always);
		ImGui.SetNextWindowSize(width, height, ImGuiCond.Once);
		
		// Begin Modal
		if (ImGui.BeginPopupModal(name, true, ImGuiWindowFlags.NoMove | ImGuiWindowFlags.NoResize))
		{
			// Set Modal Open
			modalOpen = true;
			
			// Create New Project Header
			ImGui.Text("New Project");
			ImGui.Separator();
			
			// Project Name / Dir
			projectName = ImGui.InputTextCustom("Project Name", projectName, "##HiddenProjectName", 120, NO_DEFAULT);
			projectDirectory = ImGui.InputFileCustom("Project Directory", projectDirectory, "##HiddenProjectDirectory", 120, SETTINGS.defaultProjectPath, FILTERS.newProj, $"{projectName}.bproj");
			
			// Project Type
			projectType = ImGui.ComboBoxCustom("Project Type", projectType, ["The Complete Saga", "Indiana Jones", "Batman"], "##HiddenProjectType", 120);
			
			// Create Project Button
			ImGui.SetCursorPosX((width / 2) - 48);
			if (ImGui.Button("Create Project", 96))
			{
				if (PROJECT != noone) PROJECT.destroy();
				PROJECT = new BactaTankProject(projectName, projectType, $"{projectDirectory}{projectName}.bproj");
				PROJECT.save();
				ImGui.CloseCurrentPopup();
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