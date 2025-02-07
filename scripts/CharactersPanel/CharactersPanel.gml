/*
	CharactersPanel
	-------------------------------------------------------------------------
	Script:			CharactersPanel
	Version:		v1.00
	Created:		15/11/2024 by Alun Jones
	Description:	Characters Panel List
	-------------------------------------------------------------------------
	History:
	 - Created 15/11/2024 by Alun Jones
	
	To Do:
*/

function CharactersPanel() constructor
{
	// Character Selected
	ENVIRONMENT.CharacterSelected = -1;
	ENVIRONMENT.ModelSelected = -1;
	
	// Popup
	AddCharacterPopup = false;
	
	static render = function()
	{
		// Popup
		if (AddCharacterPopup)
		{
			ImGui.OpenPopup("AddCharacterPopup");
			AddCharacterPopup = false;
		}
		
		// Window Size and Position
		var windowPos = [4, 26];
		var windowSize = [round(WINDOW_SIZE[0] / 4) - 6, round(WINDOW_SIZE[1]) - 30];
		
		// Set Next Window Position and Size		
		ImGui.SetNextWindowPos(windowPos[0], windowPos[1], ImGuiCond.Once);
		ImGui.SetNextWindowSize(windowSize[0], windowSize[1], ImGuiCond.Always);
		
		// Begin Window
		if (ImGui.Begin("CharactersPanel", undefined, ImGuiWindowFlags.NoTitleBar | ImGuiWindowFlags.NoMove | ImGuiWindowFlags.NoResize))
		{
			// Header
			ImGui.Text("Characters");
			ImGui.Separator();
			
			// Get Cursor Pos
			var cursorPos = [ImGui.GetCursorPosX(), ImGui.GetCursorPosY()];
			
			// Remove Character Button
			ImGui.SetCursorPos(windowSize[0] - 28, 6);
			if (ImGui.Button("-##HiddenRemoveCharacter", 20, 20))
			{
				array_delete(CHARACTERS, ENVIRONMENT.CharacterSelected, 1);
				ENVIRONMENT.CharacterSelected = -1;
			}
			
			// Add Character Button
			ImGui.SetCursorPos(windowSize[0] - 50, 6);
			if (ImGui.Button("+##HiddenAddCharacter", 20, 20)) AddCharacterPopup = true;
			ImGui.ShowTooltip("Add A Character");
			
			// Reset Cursor Position
			ImGui.SetCursorPos(cursorPos[0], cursorPos[1]);
			
			// Characters List
			if (ImGui.BeginChild("Characters", -1, round(windowSize[1] / 2) - 36))
			{
				var pos = [ImGui.GetCursorPosX(), ImGui.GetCursorPosY()];
				ImGui.SetCursorPos(pos[0], pos[1] + 4);
				for (var i = 0; i < array_length(CHARACTERS); i++)
				{
					var pos = [ImGui.GetCursorPosX(), ImGui.GetCursorPosY()];
					if (ImGui.Selectable("##HiddenCharacterItem" + string(i), i == ENVIRONMENT.CharacterSelected, ImGuiSelectableFlags.AllowOverlap, 0, 32)) ENVIRONMENT.CharacterSelected = i;
					ImGui.SetCursorPos(pos[0] + 4, pos[1]);
					ImGui.Image(graCharacterIconFrame, i != ENVIRONMENT.CharacterSelected, c_white, 1, 32, 32);
					ImGui.SetCursorPos(pos[0] + 4, pos[1]);
					ImGui.Image(graCharacterQuestionMark, 0, c_white, 1, 32, 32);
					ImGui.SetCursorPos(pos[0] + 40, pos[1] + 8);
					ImGui.Text(CHARACTERS[i].name);
					ImGui.SetCursorPos(pos[0], pos[1] + 36);
				}
				
				ImGui.EndChild();
			}
			
			// Models Header
			ImGui.Text("Models");
			ImGui.Separator();
			
			// Get Cursor Pos
			var cursorPos = [ImGui.GetCursorPosX(), ImGui.GetCursorPosY()];
			
			// Remove Character Button
			ImGui.SetCursorPos(windowSize[0] - 28, cursorPos[1] - 26);
			if (ImGui.Button("-##HiddenRemoveModel", 20, 20)) show_message("Create Popup Model or Popup Context Menu");
			
			// Add Character Button
			ImGui.SetCursorPos(windowSize[0] - 50, cursorPos[1] - 26);
			if (ImGui.Button("+##HiddenAddModel", 20, 20)) ENVIRONMENT.openModal("Add Model");
			ImGui.ShowTooltip("Add A Character");
			
			// Reset Cursor Position
			ImGui.SetCursorPos(cursorPos[0], cursorPos[1]);
			
			// Models List
			if (ImGui.BeginChild("Models", -1, round(windowSize[1] / 2) - 36))
			{
				var pos = [ImGui.GetCursorPosX(), ImGui.GetCursorPosY()];
				ImGui.SetCursorPos(pos[0], pos[1] + 4);
				for (var i = 0; i < array_length(MODELS); i++)
				{
					var pos = [ImGui.GetCursorPosX(), ImGui.GetCursorPosY()];
					if (ImGui.Selectable("##HiddenModelItem" + string(i), i == ENVIRONMENT.ModelSelected, ImGuiSelectableFlags.AllowOverlap, 0, 32)) ENVIRONMENT.ModelSelected = i;
					ImGui.SetCursorPos(pos[0] + 4, pos[1] + 8);
					ImGui.Text(MODELS[i]);
					ImGui.SetCursorPos(pos[0], pos[1] + 36);
				}
				
				ImGui.EndChild();
			}
			
			// End Window
			ImGui.End();
		}
		
		// Add Character Popup
		// Begin Popup
		if (ImGui.BeginPopup("AddCharacterPopup"))
		{
			// Header
			ImGui.Text("Add Character");
			ImGui.Separator();
					
			// Menu Items
			if (ImGui.MenuItem("New Character")) array_push(CHARACTERS, new BactaTankCharacter());
			ImGui.MenuItem("Import Existing Character");
			ImGui.MenuItem("Duplicate Selected Character");
					
			// End Popup
			ImGui.EndPopup();
		}
	}
}