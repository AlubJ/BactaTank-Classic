/*
	IconAttributesPanel
	-------------------------------------------------------------------------
	Script:			IconAttributesPanel
	Version:		v1.00
	Created:		15/01/2025 by Alun Jones
	Description:	Icon Attributes Panel List
	-------------------------------------------------------------------------
	History:
	 - Created 21/03/2025 by Alun Jones
	
	To Do:
*/

function IconAttributesPanel() constructor
{
	attributes = [ "Textures", "Materials", "Meshes", "Special Objects" ];
	attributesOpen = [false, false, false, false, false, false, false, false, false, false, false, false];
	modelSelected = noone;
	iconList = [];
	for (var i = 0; i < array_length(PROJECT.currentModel.specialObjects); i++)
	{
		if (string_pos("icon1", string_lower(PROJECT.currentModel.specialObjects[i].name))) array_push(iconList, "");
		else array_push(iconList, PROJECT.currentModel.specialObjects[i].name)
	}
	ENVIRONMENT.iconSelected = 1;
	
	static render = function()
	{
		// Window Size and Position
		var windowPos = [4, 26];
		var windowSize = [round(WINDOW_SIZE[0] / 4) - 6, round(WINDOW_SIZE[1]) - 30];
		
		// Set Next Window Position and Size		
		ImGui.SetNextWindowPos(windowPos[0], windowPos[1], ImGuiCond.Once);
		ImGui.SetNextWindowSize(windowSize[0], windowSize[1], ImGuiCond.Always);
		
		// Begin Window
		if (ImGui.Begin("IconAttributePanel", undefined, ImGuiWindowFlags.NoTitleBar | ImGuiWindowFlags.NoMove | ImGuiWindowFlags.NoResize))
		{
			// Model
			//if (CONTEXT == BTContext.Project) ImGui.ComboBoxCustom("Model", -1, MODELS, "##HiddenCharacterModel", 100);
			
			// Header
			//if (CONTEXT == BTContext.Project) ImGui.Text("Model Attributes");
			ImGui.Text(MODEL_NAME);
			ImGui.Separator();
			
			// Model Attributes List
			if (ImGui.BeginChild("IconAttributes", -1, -1) && PROJECT.currentModel != -1)
			{
				// Icon Model
				var model = PROJECT.currentModel;
				var space = 100;
				
				// Set Pos
				var pos = [ImGui.GetCursorPosX(), ImGui.GetCursorPosY()];
				ImGui.SetCursorPos(pos[0], pos[1] + 4);
				
				// Icon ComboBox
				ENVIRONMENT.iconSelected = ImGui.ComboBoxCustom("Icon", ENVIRONMENT.iconSelected, iconList, "##hiddenIconList", space, NO_DEFAULT);
				
				// Separator
				ImGui.Separator();
				
				// Get Sprite
				var index = ENVIRONMENT.iconSelected;
				var specialObject = model.specialObjects[index];
				var gameModel = model.models[specialObject.model];
				var textureIndex = model.materials[gameModel.meshes[0].material].textureID;
				var sprite = model.textures[textureIndex].sprite;
		
				// Calc New Height
				var width = windowSize[0] - 16;
				var newHeight = floor((sprite_get_height(sprite) / sprite_get_width(sprite)) * width);
		
				// Draw Texture
				SECONDARY_CANVAS.resize(width, newHeight);
				SECONDARY_CANVAS.add(new CalicoTransparencyBackground(width, newHeight));
				SECONDARY_CANVAS.add(new CalicoSprite(sprite, 0, 0, 0, width, newHeight));
				SECONDARY_CANVAS.draw();
		
				// Draw Surface
				ImGui.Surface(SECONDARY_CANVAS.surface);
		
				// Spacing
				ImGui.Spacing();
		
				// Icon Details Text
				ImGui.Text("Icon Details");
				ImGui.Separator();
				ImGui.Spacing();
				
				// Name
				ImGui.InputTextCustom("Name", specialObject.name, "##hiddenIconName", space, NO_DEFAULT);
				
				// End Child
				ImGui.EndChild();
			}
			
			// End Window
			ImGui.End();
		}
	}
	
	static renderSpecialObjectList = function()
	{
		var model = PROJECT.currentModel;
		for (var i = 0; i < array_length(model.specialObjects); i++)
		{
			// Skip if Icon1 (Locked Icon)
			if (string_pos("icon1", string_lower(model.specialObjects[i].name))) continue;
			
			// Get Position
			var pos = [ImGui.GetCursorPosX(), ImGui.GetCursorPosY()];
			
			// Selectable
			if (ImGui.Selectable($"##hiddenModelSpecialObject{i}", ENVIRONMENT.iconSelected == i, ImGuiSelectableFlags.AllowItemOverlap | ImGuiSelectableFlags.AllowOverlap)) ENVIRONMENT.iconSelected = i;
			
			// Texture Icon
			ImGui.SetCursorPos(pos[0] + 22, pos[1] + 1);
			ImGui.Image(graSpecialObject, 0);
			
			// Attribute Text
			ImGui.SetCursorPos(pos[0] + 40, pos[1]);
			ImGui.Text($"{model.specialObjects[i].name}");
		}
	}
}

