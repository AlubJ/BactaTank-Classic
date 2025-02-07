/*
	CreateAssetPackModal
	-------------------------------------------------------------------------
	Script:			CreateAssetPackModal
	Version:		v1.00
	Created:		11/12/2024 by Alun Jones
	Description:	Create Asset Pack Modal
	-------------------------------------------------------------------------
	History:
	 - Created 11/12/2024 by Alun Jones
	
	To Do:
	 - Open Existing Asset Pack
*/

function CreateAssetPackModal() : Modal() constructor
{
	name = "Create Asset Pack";
	
	width = 560;
	height = 164;
	
	assetPackName = "Asset Pack";
	assetPackAuthor = "";
	assetPackVersion = [1, 0, 0];
	assetPackType = 0;
	assets = [  ];
	assetSelected = -1;
	
	assetTypes = [ "Model", "Animation", "BSA", "Audio" ];
	
	static render = function()
	{
		// Set Modal Position and Size
		ImGui.SetNextWindowPos(floor(WINDOW_SIZE[0] / 2) - 280, floor(WINDOW_SIZE[1] / 2) - 256, ImGuiCond.Always);
		ImGui.SetNextWindowSize(width, 512, ImGuiCond.Once);
		
		// Begin Modal
		if (ImGui.BeginPopupModal(name, true, ImGuiWindowFlags.NoMove | ImGuiWindowFlags.NoResize))
		{
			// Set Modal Open
			modalOpen = true;
			
			// Create Asset Pack Header
			ImGui.Text("Create Asset Pack");
			ImGui.Separator();
			
			// Asset Pack Name / Type
			assetPackName = ImGui.InputTextCustom("Asset Pack Name", assetPackName, "##HiddenAssetPackName", 120, NO_DEFAULT);
			assetPackAuthor = ImGui.InputTextCustom("Asset Pack Author", assetPackAuthor, "##HiddenAssetPackAuthor", 120, NO_DEFAULT);
			ImGui.InputInt3Custom("Asset Pack Version", assetPackVersion, "##HiddenAssetPackVersion", 120, NO_DEFAULT);
			assetPackType = ImGui.ComboBoxCustom("Asset Pack Type", assetPackType, ["The Complete Saga", "Indiana Jones", "Batman"], "##HiddenAssetPackType", 120);
			ImGui.Spacing();
			
			// Header
			ImGui.Text("Assets");
			ImGui.Separator();
			
			// Get Cursor Pos
			var cursorPos = [ImGui.GetCursorPosX(), ImGui.GetCursorPosY()];
			
			// Remove Character Button
			ImGui.SetCursorPos(width - 28, cursorPos[1] - 26);
			if (ImGui.Button("-##HiddenRemoveAsset", 20, 20) && assetSelected != -1)
			{
				array_delete(assets, assetSelected, 1);
				assetSelected = -1;
			}
			
			// Add Character Button
			ImGui.SetCursorPos(width - 50, cursorPos[1] - 26);
			if (ImGui.Button("+##HiddenAddAsset", 20, 20))
			{
				// Open File Dialogue
				var file = get_open_filename(FILTERS.allAssetTypes, "");
				
				if (file != "" && ord(file) != 0)
				{
					var type = verify_file_format(filename_ext(file));
					var asset = {
						file: file,
						filename: filename_name(file),
						type: type,
					}
					array_push(assets, asset);
				}
			}
			
			// Assets List
			ImGui.Selectable("Asset", false, ImGuiSelectableFlags.Disabled);
			ImGui.SameLine(width - 128);
			ImGui.TextDisabled("Type");
			if (ImGui.BeginChild("AssetPackAssetList", 0, -28, ImGuiChildFlags.None, ImGuiWindowFlags.AlwaysVerticalScrollbar))
			{
				for (var i = 0; i < array_length(assets); i++)
				{
					if (ImGui.Selectable(assets[i].filename + "##HiddenAssetListSelectable" + string(i), assetSelected == i)) assetSelected = i;
					ImGui.SameLine(width - 136);
					ImGui.Text(assetTypes[assets[i].type]);
				}
				
				// End Child
				ImGui.EndChild();
			}
			
			// Create Project Button
			ImGui.SetCursorPosX((width / 2) - 58);
			if (ImGui.Button("Create Asset Pack", 116))
			{
				var assetPack = new BactaTankAssetPack(assetPackName, assetPackType, assetPackAuthor, "test.bpack");
				for (var i = 0; i < array_length(assets); i++)
				{
					assetPack.add(assets[i].file);
				}
				assetPack.serialize();
			}
			
			// End Popup
			ImGui.EndPopup();
		}
		else if (array_length(assets) > 0) array_delete(assets, 0, array_length(assets));
		else
		{
			modalOpen = false;
		}
	}
}