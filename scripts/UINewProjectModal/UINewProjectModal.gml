function UINewProjectModal() : UIModal() constructor
{
    __projectName = "New Project";
    __projectFile = StashGetDirectory("projects");
    __projectGame = "TCS";
    
    static deinit = function()
    {
        if (!BactaProjectOpen())
        {
            UIOpenModal("Welcome");
        }
    }
    
    static render = function(_width, _height)
    {
        UIHeader("Create a new project", fa_center);
        
        if (ImGuiBeginChild("New Project", 0, -32, ImGuiChildFlags.Border))
        {
            var _spacing = 120;
            
            ImGuiText("Project Name");
            ImGuiSameLine(_spacing);
            ImGuiSetNextItemWidth(-1);
            __projectName = ImGuiInputText("##projectName", __projectName);
            
            ImGuiText("Project File");
            ImGuiSameLine(_spacing);
            ImGuiSetNextItemWidth(-29);
            __projectFile = ImGuiInputText("##projectFile", __projectFile, ImGuiInputTextFlags.ReadOnly);
            ImGuiSameLine(0, 4);
            if (ImGuiButton("...", 24))
            {
                var _file = StashSaveDialog("New Project", [ "bproj" ], __projectName, "");
                
                if (_file != "")
                {
                    __projectFile = _file;
                }
            }
            
            ImGuiText("Project Game");
            ImGuiSameLine(_spacing);
            ImGuiSetNextItemWidth(-1);
            __projectGame = ImGuiInputText("##projectGame", __projectGame);
            
            ImGuiEndChild();
        }
        
        ImGuiSpacing();
        
        var _buttonWidth = 100;
        var _buttonSpacing = 8;
        
        var _buttonCount = 1;
        var _totalWidth = _buttonCount * _buttonWidth + (_buttonCount - 1) * _buttonSpacing;
        
        var _startX = (_width - _totalWidth) * 0.5;
        
        ImGuiSetCursorPosX(_startX)
        
        ImGuiBeginDisabled(__projectName == "" && __projectFile == "");;
        
        if (ImGuiButton("Create Project", _buttonWidth))
        {
            BactaCreateProject(__projectName, __projectFile, __projectGame, BACTA_PROJECT_DEFAULT);
            UISetContext("Project");
            UICloseModal();
        }
        
        ImGuiEndDisabled();
    }
}