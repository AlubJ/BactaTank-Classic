function UIWelcomeModal() : UIModal() constructor
{
    __recentProjects = BactaGetRecentFiles();
    __selectedIndex = -1;
    
    static init = function()
    {
        __recentProjects = BactaGetRecentFiles();
        __selectedIndex = -1;
    }
    
    static render = function(_width, _height)
    {
        UIHeader("Welcome to BactaTank Classic", fa_center);
        
        ImGuiText("Recent files");
        ImGuiSpacing();
        
        if (ImGuiBeginChild("RecentFiles", 0, -32, ImGuiChildFlags.Border))
        {
            if (ImGuiBeginTable("Recent Files", 3, ImGuiTableFlags.ScrollY, 0, 0))
            {
                ImGuiTableSetupScrollFreeze(0, 1);
                
                ImGuiTableSetupColumn(" File", ImGuiTableColumnFlags.WidthStretch, 0.3);
                ImGuiTableSetupColumn("Path", ImGuiTableColumnFlags.WidthStretch, 0.55);
                ImGuiTableSetupColumn("Type", ImGuiTableColumnFlags.WidthStretch, 0.15);
                ImGuiTableHeadersRow();
                
                var _i = 0;
                repeat (array_length(__recentProjects))
                {
                    ImGuiTableNextRow();
                    ImGuiTableSetColumnIndex(0);
                    
                    var _selected = (_i == __selectedIndex);
                    
                    if (ImGuiSelectable($" {__recentProjects[_i].name}##{_i}", _selected, ImGuiSelectableFlags.SpanAllColumns | ImGuiSelectableFlags.AllowDoubleClick))
                    {
                        __selectedIndex = _i;
                        
                        if (ImGuiIsMouseDoubleClicked(ImGuiMouseButton.Left))
                        {
                            __BactaTrace("File opened")
                        }
                    }
                    
                    ImGuiTableSetColumnIndex(1);
                    ImGuiText($"{filename_dir(__recentProjects[_i].path)}");
                    
                    ImGuiTableSetColumnIndex(2);
                    ImGuiText($"{__recentProjects[_i].type}");
                    
                    _i++;
                }
                
                ImGuiEndTable();
            }
            
            ImGuiEndChild();
        }
        
        ImGuiSpacing();
        
        var _buttonWidth = 100;
        var _buttonSpacing = 8;
        
        var _buttonCount = 3;
        var _totalWidth = _buttonCount * _buttonWidth + (_buttonCount - 1) * _buttonSpacing;
        
        var _startX = (_width - _totalWidth) * 0.5;
        
        ImGuiSetCursorPosX(_startX);
        
        if (ImGuiButton("New Project", _buttonWidth))
        {
            UICloseModal();
        }
        
        ImGuiSameLine();
        
        if (ImGuiButton("New Model", _buttonWidth))
        {
            UIOpenModal("New Model");
            UICloseModal();
        }
        ImGuiSameLine();
        
        if (ImGuiButton("Open File", _buttonWidth))
        {
            var _file = StashOpenDialog("Open Project or Model", [ "bproj", "ghg" ], "");
            
            if (_file != "")
            {
                UICloseModal();
            }
        }
    }
}