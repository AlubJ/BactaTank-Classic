/*
	CharacterPropertiesPanel
	-------------------------------------------------------------------------
	Script:			CharacterPropertiesPanel
	Version:		v1.00
	Created:		15/11/2024 by Alun Jones
	Description:	Characters Properties Panel
	-------------------------------------------------------------------------
	History:
	 - Created 15/11/2024 by Alun Jones
	
	To Do:
*/

function CharacterPropertiesPanel() constructor
{
	static render = function()
	{
		// Set Next Window Position and Size
		ImGui.SetNextWindowPos(round(WINDOW_SIZE[0] / 4 * 3) + 2, 26, ImGuiCond.Always);
		ImGui.SetNextWindowSize(round(WINDOW_SIZE[0] / 4) - 6, round(WINDOW_SIZE[1]) - 30, ImGuiCond.Always);
		
		// Begin Window
		if (ImGui.Begin("CharacterPropertiesPanel", undefined, ImGuiWindowFlags.NoTitleBar | ImGuiWindowFlags.NoMove | ImGuiWindowFlags.NoResize))
		{
			// Header
			ImGui.Text("Character Properties");
			ImGui.Separator();
			
			// Check if Character is Selected
			if (ENVIRONMENT.CharacterSelected == -1)
			{
				// Render Text
				ImGui.Text("Please choose a character.");
				
				// End Window
				ImGui.End();
				exit;
			}
			
			// Characters List
			if (ImGui.BeginChild("Character Properties"))
			{
				// Character Properties Here
				
				// Character Properties Tab Bar
				if (ImGui.BeginTabBar("CharacterPropertiesTabBar", ImGuiTabBarFlags.FittingPolicyScroll | ImGuiTabBarFlags.NoTabListScrollingButtons))
				{
					// Tabs
					if (ImGui.BeginTabItem("General"))
					{
						renderGeneralTab();
						ImGui.EndTabItem();
					}
					if (ImGui.BeginTabItem("GFX"))
					{
						// Render Tab
						ImGui.EndTabItem();
					}
					if (ImGui.BeginTabItem("SFX"))
					{
						// Render Tab
						ImGui.EndTabItem();
					}
					if (ImGui.BeginTabItem("Physics"))
					{
						// Render Tab
						renderPhysicsTab();
						ImGui.EndTabItem();
					}
					if (ImGui.BeginTabItem("Locators"))
					{
						for (var i = 0; i < array_length(ctrlRenderer.model.locators); i++)
						{
							array_push(RENDERER.debugRenderQueue, {
								vertexBuffer: PRIMITIVES.locator,
								material: {colour: sel == i ? [0.8, 0.3, 0.3, 1.0] : SETTINGS.viewerSettings.locatorColour},
								textures: {},
								matrix: matrix_multiply(ctrlRenderer.model.locators[i].matrix, ctrlRenderer.model.bones[ctrlRenderer.model.locators[i].parent].matrix),
								shader: "WireframeShader",
								primitive: pr_linelist,
							});
						}
						
						// Render Tab
						ImGui.EndTabItem();
					}
					if (ImGui.BeginTabItem("Animations"))
					{
						// Render Tab
						ImGui.EndTabItem();
					}
					
					// End Tab Bar
					ImGui.EndTabBar();
				}
				
				ImGui.EndChild();
			}
			
			// End Window
			ImGui.End();
		}
	}
	
	static renderGeneralTab = function()
	{
		// Item Width
		var startX = 100;
		var character = CHARACTERS[ENVIRONMENT.CharacterSelected];
		
		// Create Child
		if (ImGui.BeginChild("##HiddenCharacterGeneralTab", -1, -1))
		{
			// Internal Header
			ImGui.Text("Internal Settings");
			ImGui.Separator();
			
			// Internal Name / Type
			character.name = ImGui.InputTextCustom("Name", character.name, "##HiddenCharacterInternalName", startX, "Name");
			ImGui.InputTextCustom("Type", BT_CHARACTER_TYPE[character.type], "##HiddenCharacterInternalType", startX, BT_CHARACTER_TYPE[character.type], ImGuiInputTextFlags.ReadOnly);
			
			// Models Header
			ImGui.Spacing();
			ImGui.Text("Models");
			ImGui.Separator();
			
			// Models
			ImGui.ComboBoxCustom("HR Model", 0, ["None", "LUKE_JEDI", "LUKE_JEDI_LR"], "##HiddenCharacterHRModel", startX);
			ImGui.ComboBoxCustom("LR Model", 0, ["None", "LUKE_JEDI", "LUKE_JEDI_LR"], "##HiddenCharacterLRModel", startX);
			
			// General Header
			ImGui.Spacing();
			ImGui.Text("General Settings");
			ImGui.Separator();
			
			// Internal Name / Type
			character.name_id = real(ImGui.InputTextCustom("Name ID", character.name_id, "##HiddenCharacterNameID", startX, BT_CHARACTER_DEFAULTS.name_id));
			character.icon =	ImGui.InputTextCustom("Icon ID", character.icon, "##HiddenCharacterIconID", startX, BT_CHARACTER_DEFAULTS.icon);
			
			// Attribute Header
			ImGui.Spacing();
			ImGui.Text("Attributes");
			ImGui.Separator();
			
			// Attributes Child
			if (ImGui.BeginChild("##HiddenCharacterAttributes", -1, -1))
			{
				ImGui.EndChild();
			}
			
			// End Child
			ImGui.EndChild();
		}
	}
	
	static renderPhysicsTab = function()
	{
		// Item Width
		var startX = 120;
		var character = CHARACTERS[ENVIRONMENT.CharacterSelected];
		
		// Create Child
		if (ImGui.BeginChild("##HiddenCharacterPhysicsTab", -1, -1))
		{
			// Collider Header
			ImGui.Text("Collider");
			ImGui.Separator();
			
			// Collider
			character.scale =	ImGui.DragFloatCustom("Scale", character.scale, "##HiddenCharacterScale", 0.01, 0, 3, startX, BT_CHARACTER_DEFAULTS.scale);
			character.radius =	ImGui.DragFloatCustom("Radius", character.radius, "##HiddenCharacterRadius", 0.01, 0, 1, startX, BT_CHARACTER_DEFAULTS.radius);
			character.miny =	ImGui.DragFloatCustom("Min Y", character.miny, "##HiddenCharacterMinY", 0.01, 0, 1, startX, BT_CHARACTER_DEFAULTS.miny);
			character.maxy =	ImGui.DragFloatCustom("Max Y", character.maxy, "##HiddenCharacterMaxY", 0.01, 0, 1, startX, BT_CHARACTER_DEFAULTS.maxy);
			
			RENDERER.activate();
			
			// Push Collider To Render Queue
			array_push(RENDERER.debugRenderQueue, {
				vertexBuffer: PRIMITIVES.capsuleBottom,
				material: {colour: SETTINGS.viewerSettings.colliderColour},
				textures: {},
				matrix: matrix_build(0, character.miny + character.radius, 0, 0, 0, 0, character.radius, character.radius, character.radius),
				shader: "WireframeShader",
				primitive: pr_linelist,
			});
			array_push(RENDERER.debugRenderQueue, {
				vertexBuffer: PRIMITIVES.capsuleTop,
				material: {colour: SETTINGS.viewerSettings.colliderColour},
				textures: {},
				matrix: matrix_build(0, character.maxy - character.radius, 0, 0, 0, 0, character.radius, character.radius, character.radius),
				shader: "WireframeShader",
				primitive: pr_linelist,
			});
			array_push(RENDERER.debugRenderQueue, {
				vertexBuffer: PRIMITIVES.capsuleMiddle,
				material: {colour: SETTINGS.viewerSettings.colliderColour},
				textures: {},
				matrix: matrix_build(0, character.miny + character.radius, 0, 0, 0, 0, character.radius, character.maxy - character.miny - (character.radius * 2), character.radius),
				shader: "WireframeShader",
				primitive: pr_linelist,
			});
			
			// General Header
			ImGui.Spacing();
			ImGui.Text("General Physics");
			ImGui.Separator();
			
			// General Physics
			character.acceleration =	ImGui.DragFloatCustom("Acceleration", character.acceleration, "##HiddenCharacterAcceleration", 0.1, 0, 20, startX, BT_CHARACTER_DEFAULTS.acceleration);
			character.move_delay =		ImGui.DragFloatCustom("Move Delay", character.move_delay, "##HiddenCharacterMoveDelay", 0.1, 0, 2, startX, BT_CHARACTER_DEFAULTS.move_delay);
			character.hover_height =	ImGui.DragFloatCustom("Hover Height", character.hover_height, "##HiddenCharacterHoverHeight", 0.01, 0, 1, startX, BT_CHARACTER_DEFAULTS.hover_height);
			character.friction =		ImGui.DragFloatCustom("Friction", character.friction, "##HiddenCharacterFriction", 0.1, 0, 20, startX, BT_CHARACTER_DEFAULTS.friction);
			
			// Gravity Header
			ImGui.Spacing();
			ImGui.Text("Gravity");
			ImGui.Separator();
			
			// Gravity
			character.air_gravity =		ImGui.DragFloatCustom("Air Gravity", character.air_gravity, "##HiddenCharacterAirGravity", 0.1, -20, 0, startX, BT_CHARACTER_DEFAULTS.air_gravity);
			character.water_gravity =	ImGui.DragFloatCustom("Water Gravity", character.water_gravity, "##HiddenCharacterWaterGravity", 0.1, -20, 0, startX, BT_CHARACTER_DEFAULTS.water_gravity);
			character.slam_gravity =	ImGui.DragFloatCustom("Slam Gravity", character.slam_gravity, "##HiddenCharacterSlamGravity", 0.1, -20, 0, startX, BT_CHARACTER_DEFAULTS.slam_gravity);
			
			// Ground Speeds Header
			ImGui.Spacing();
			ImGui.Text("Ground Speeds");
			ImGui.Separator();
			
			// Ground Speeds
			character.tiptoe_speed =	ImGui.DragFloatCustom("Tiptoe Speed", character.tiptoe_speed, "##HiddenCharacterTiptoeSpeed", 0.01, 0, 2, startX, BT_CHARACTER_DEFAULTS.tiptoe_speed);
			character.walk_speed =		ImGui.DragFloatCustom("Walk Speed", character.walk_speed, "##HiddenCharacterWalkSpeed", 0.01, 0, 2, startX, BT_CHARACTER_DEFAULTS.walk_speed);
			character.run_speed =		ImGui.DragFloatCustom("Run Speed", character.run_speed, "##HiddenCharacterRunSpeed", 0.01, 0, 2, startX, BT_CHARACTER_DEFAULTS.run_speed);
			
			// Other Header
			ImGui.Spacing();
			ImGui.Text("Other");
			ImGui.Separator();
			
			// Other
			character.jump_speed =		ImGui.DragFloatCustom("Jump Speed", character.jump_speed, "##HiddenCharacterJumpSpeed", 0.1, 0, 10, startX, BT_CHARACTER_DEFAULTS.jump_speed);
			character.jump_2_speed =	ImGui.DragFloatCustom("Double Jump Speed", character.jump_2_speed, "##HiddenCharacterDoubleJumpSpeed", 0.1, 0, 10, startX, BT_CHARACTER_DEFAULTS.jump_2_speed);
			character.lunge_jumpspeed =	ImGui.DragFloatCustom("Lunge Jump Speed", character.lunge_jumpspeed, "##HiddenCharacterLungeJumpSpeed", 0.1, 0, 10, startX, BT_CHARACTER_DEFAULTS.lunge_jumpspeed);
			character.slam_jumpspeed =	ImGui.DragFloatCustom("Slam Jump Speed", character.slam_jumpspeed, "##HiddenCharacterSlamJumpSpeed", 0.1, 0, 10, startX, BT_CHARACTER_DEFAULTS.slam_jumpspeed);
			
			// End Child
			ImGui.EndChild();
		}
	}
	
	static renderAnimationsTab = function()
	{
		// Item Width
		var startX = 100;
		var character = CHARACTERS[ENVIRONMENT.CharacterSelected];
		
		// Create Child
		if (ImGui.BeginChild("##HiddenCharacterAnimationsTab", -1, -1))
		{
			// Header
			ImGui.Text("Animations and Effects");
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
			
			// End Child
			ImGui.EndChild();
		}
	}
}