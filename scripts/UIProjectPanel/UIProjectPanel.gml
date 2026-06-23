function UIProjectPanel() constructor
{
    static render = function (_width, _height)
    {
        static _system = __BactaSystem();
        
        UIHeader("Project");
        
        if (ImGuiBeginChild("Characters", 0, 0, ImGuiChildFlags.Border))
        {
            var _flags = ImGuiTreeNodeFlags.DrawLinesFull | ImGuiTreeNodeFlags.SpanFullWidth | ImGuiTreeNodeFlags.FramePadding;
            
            ImGuiPushStyleVar(ImGuiStyleVar.FramePadding, 0.0, 2.0);
            
            if (ImGuiTreeNodeEx($"Characters##hidden", _flags | ImGuiTreeNodeFlags.DefaultOpen | ImGuiTreeNodeFlags.Leaf))
            {
                var _i = 0;
                repeat(10)
                {
                    if (ImGuiTreeNodeEx($"##hiddenCharacter{_i}", _flags))
                    {
                        ImGuiTreePop();
                    }
                    
                    ImGuiSameLine();
                    var _x = ImGuiGetCursorPosX();
                    ImGuiSetCursorPosX(_x - 4);
                    ImGuiImage(UIIconGet("Character"), 0);
                    ImGuiSameLine();
                    ImGuiText($"Character {_i}");
                
                    _i++;
                }
                
                ImGuiTreePop();
            }
            
            if (ImGuiTreeNodeEx($"Models##hidden", _flags | ImGuiTreeNodeFlags.DefaultOpen | ImGuiTreeNodeFlags.Leaf))
            {
                var _i = 0;
                repeat(10)
                {
                    if (ImGuiTreeNodeEx($"##hiddenModel{_i}", _flags))
                    {
                        ImGuiTreePop();
                    }
                    
                    ImGuiSameLine();
                    var _x = ImGuiGetCursorPosX();
                    ImGuiSetCursorPosX(_x - 4);
                    ImGuiImage(UIIconGet("Model"), 0);
                    ImGuiSameLine();
                    ImGuiText($"Model {_i}");
                
                    _i++;
                }
                
                ImGuiTreePop();
            }
            
            ImGuiPopStyleVar();
            
            ImGuiEndChild();
        }
    }
}