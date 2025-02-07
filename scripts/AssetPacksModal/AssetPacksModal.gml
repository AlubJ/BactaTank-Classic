/*
	AssetPacksModal
	-------------------------------------------------------------------------
	Script:			AssetPacksModal
	Version:		v1.00
	Created:		12/12/2024 by Alun Jones
	Description:	Asset Packs Modal
	-------------------------------------------------------------------------
	History:
	 - Created 12/12/2024 by Alun Jones
	
	To Do:
	 - Add split view to view all the assets in the asset pack.
*/

function AssetPacksModal() : Modal() constructor
{
	name = "Asset Packs";
	
	width = 560;
	height = 164;
	
	assetPackSelected = -1;
	
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
			
			// Manage Asset Pack Header
			ImGui.Text("Manage Asset Packs");
			ImGui.Separator();
			
			// Get Cursor Pos
			var cursorPos = [ImGui.GetCursorPosX(), ImGui.GetCursorPosY()];
			
			// Remove Character Button
			ImGui.SetCursorPos(width - 28, cursorPos[1] - 26);
			if (ImGui.Button("-##HiddenRemoveAssetPack", 20, 20) && assetPackSelected != -1)
			{
				file_delete(ASSET_PACK_DIRECTORY + ASSET_PACKS[assetPackSelected].source)
				array_delete(ASSET_PACKS, assetPackSelected, 1);
				assetPackSelected = -1;
			}
			
			// Add Character Button
			ImGui.SetCursorPos(width - 50, cursorPos[1] - 26);
			if (ImGui.Button("+##HiddenAddAssetPack", 20, 20))
			{
				// Open File Dialogue
				var file = get_open_filename(FILTERS.assetPack, "");
				
				if (file != "" && ord(file) != 0)
				{
					file_copy(file, ASSET_PACK_DIRECTORY + filename_name(file));
					var assetPack = new BactaTankAssetPack();
					assetPack.deserialize(file);
					array_push(ASSET_PACKS, assetPack);
				}
			}
			
			// Assets List
			ImGui.Selectable("Asset Pack", false, ImGuiSelectableFlags.Disabled);
			ImGui.SameLine(width - 128);
			ImGui.TextDisabled("Author");
			if (ImGui.BeginChild("AssetPackList", 0, 0, ImGuiChildFlags.None, ImGuiWindowFlags.AlwaysVerticalScrollbar))
			{
				for (var i = 0; i < array_length(ASSET_PACKS); i++)
				{
					if (ImGui.Selectable(ASSET_PACKS[i].name + "##HiddenAssetPackSelectable" + string(i), assetPackSelected == i)) assetPackSelected = i;
					ImGui.SameLine(width - 136);
					ImGui.Text(ASSET_PACKS[i].author);
				}
				
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