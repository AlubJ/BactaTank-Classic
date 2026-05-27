function UINewModelModal() : UIModal() constructor
{
    __templates = BactaGetTemplates();
    __selectedIndex = -1;
    
    static deinit = function()
    {
        if (!BactaProjectOpen())
        {
            UIOpenModal("Welcome");
        }
    }
    
    static render = function(_width, _height)
    {
        UIHeader("Create a new model from template", fa_center);
        
        if (ImGuiBeginChild("Templates", 0, 0, ImGuiChildFlags.Border))
        {
            if (ImGuiBeginTable("Templates", 1, ImGuiTableFlags.ScrollY, 0, 0))
            {
                ImGuiTableSetupScrollFreeze(0, 1);
                
                ImGuiTableSetupColumn(" Template");
                ImGuiTableHeadersRow();
                
                var _i = 0;
                repeat (array_length(__templates))
                {
                    ImGuiTableNextRow();
                    ImGuiTableSetColumnIndex(0);
                    
                    var _selected = (_i == __selectedIndex);
                    
                    if (ImGuiSelectable($" {filename_name(__templates[_i])}##{_i}", _selected, ImGuiSelectableFlags.SpanAllColumns | ImGuiSelectableFlags.AllowDoubleClick))
                    {
                        __selectedIndex = _i;
                        
                        if (ImGuiIsMouseDoubleClicked(ImGuiMouseButton.Left))
                        {
                            __BactaTrace("Template opened")
                        }
                    }
                    
                    _i++;
                }
                
                ImGuiEndTable();
            }
            
            ImGuiEndChild();
        }
    }
}