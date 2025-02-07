/*
	StartupModal
	-------------------------------------------------------------------------
	Script:			StartupModal
	Version:		v1.00
	Created:		26/11/2024 by Alun Jones
	Description:	Startup Modal
	-------------------------------------------------------------------------
	History:
	 - Created 26/11/2024 by Alun Jones
	
	To Do:
*/

function StartupModal() : Modal() constructor
{
	name = "Welcome";
	
	width = 560;
	height = 512;
	
	projectName = "New Project";
	projectDirectory = SETTINGS.lastProjectPath;
	projectType = 0;
	
	static render = function()
	{
		// Set Modal Position and Size
		ImGui.SetNextWindowPos(floor(WINDOW_SIZE[0] / 2) - floor(width / 2), floor(WINDOW_SIZE[1] / 2) - floor(height / 2), ImGuiCond.Always);
		ImGui.SetNextWindowSize(width, height, ImGuiCond.Once);
		
		// Begin Modal
		if (ImGui.BeginPopupModal(name, undefined, ImGuiWindowFlags.NoMove | ImGuiWindowFlags.NoResize))
		{
			// Set Modal Open
			modalOpen = true;
			
			// Create New Project Header
			ImGui.Text("New Project");
			ImGui.Separator();
			
			// Project Name / Dir
			projectName = ImGui.InputTextCustom("Project Name", projectName, "##HiddenProjectName", 120, "New Project");
			projectDirectory = ImGui.InputFileCustom("Project Directory", projectDirectory, "##HiddenProjectDirectory", 120, SETTINGS.defaultProjectPath, FILTERS.newProj, $"{projectName}.bproj", SETTINGS.lastProjectPath);
			
			// Project Type
			projectType = ImGui.ComboBoxCustom("Project Type", projectType, ["The Complete Saga", "Indiana Jones", "Batman"], "##HiddenProjectType", 120);
			
			// Create Project Button
			ImGui.SetCursorPosX((width / 2) - 84);
			if (ImGui.Button("Create Project", 96))
			{
				if (PROJECT != noone) PROJECT.destroy();
				PROJECT = new BactaTankProject(projectName, projectType, $"{projectDirectory}{projectName}.bproj");
				PROJECT.save();
				ImGui.CloseCurrentPopup();
			}
			
			// Or Text
			ImGui.SameLine();
			ImGui.Text("or");
			
			// Open Project or Model
			ImGui.SameLine();
			if (ImGui.Button("Open Project or Model", 140))
			{
				ImGui.CloseCurrentPopup();
				if (!openProjectOrModelDialog()) ENVIRONMENT.openModal(name);
			}
			
			// Spacing
			ImGui.Spacing();
			
			// Open Project Button
			ImGui.SetCursorPosX((560 / 2) - 70);
			
			// Spacing
			ImGui.Spacing();
			
			// Open Recent Header
			ImGui.Text("Open Recent Project");
			ImGui.Separator();
			
			// Open Recent Child
			if (ImGui.BeginChild("OpenRecentProjects"))
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