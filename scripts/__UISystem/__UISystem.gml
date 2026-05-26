// Feather disable all
__UISystem();

function __UISystem()
{
    static _system = undefined;
    if (_system != undefined) return _system;
    
    _system = {  };
    with (_system)
    {
        __themes = {  };
        __contexts = {  };
        __modals = {  };
        
        //__defaultFont = ImGuiGetFont();
        __currentFont = undefined;
        
        __currentContext = undefined;
        __currentWorkspace = 0;
        
        __appName = "";
        __version = "";
        
        __styleVars = [  ]
        __styleVars[ImGuiStyleVar.WindowBorderSize] = "WindowBorderSize";
        __styleVars[ImGuiStyleVar.ChildBorderSize] = "ChildBorderSize";
        __styleVars[ImGuiStyleVar.PopupBorderSize] = "PopupBorderSize";
        __styleVars[ImGuiStyleVar.FrameBorderSize] = "FrameBorderSize";
        __styleVars[ImGuiStyleVar.WindowRounding] = "WindowRounding";
        __styleVars[ImGuiStyleVar.ChildRounding] = "ChildRounding";
        __styleVars[ImGuiStyleVar.FrameRounding] = "FrameRounding";
        __styleVars[ImGuiStyleVar.PopupRounding] = "PopupRounding";
        __styleVars[ImGuiStyleVar.ScrollbarRounding] = "ScrollbarRounding";
        __styleVars[ImGuiStyleVar.GrabRounding] = "GrabRounding";
        __styleVars[ImGuiStyleVar.TabRounding] = "TabRounding";
        
        __styleColours = [];
        __styleColours[ImGuiCol.WindowBg] = "WindowBg";
        __styleColours[ImGuiCol.TitleBg] = "TitleBg";
        __styleColours[ImGuiCol.TitleBgActive] = "TitleBgActive";
        __styleColours[ImGuiCol.MenuBarBg] = "MenuBarBg";
        __styleColours[ImGuiCol.ChildBg] = "ChildBg";
        __styleColours[ImGuiCol.PopupBg] = "PopupBg";
        __styleColours[ImGuiCol.Button] = "Button";
        __styleColours[ImGuiCol.ButtonHovered] = "ButtonHovered";
        __styleColours[ImGuiCol.ButtonActive] = "ButtonActive";
        __styleColours[ImGuiCol.Header] = "Header";
        __styleColours[ImGuiCol.HeaderHovered] = "HeaderHovered";
        __styleColours[ImGuiCol.HeaderActive] = "HeaderActive";
        __styleColours[ImGuiCol.FrameBg] = "FrameBg";
        __styleColours[ImGuiCol.FrameBgHovered] = "FrameBgHovered";
        __styleColours[ImGuiCol.FrameBgActive] = "FrameBgActive";
        __styleColours[ImGuiCol.CheckMark] = "CheckMark";
        __styleColours[ImGuiCol.SliderGrab] = "SliderGrab";
        __styleColours[ImGuiCol.SliderGrabActive] = "SliderGrabActive";
        __styleColours[ImGuiCol.Tab] = "Tab";
        __styleColours[ImGuiCol.TabActive] = "TabActive";
        __styleColours[ImGuiCol.TabHovered] = "TabHovered";
        __styleColours[ImGuiCol.Text] = "Text";
        __styleColours[ImGuiCol.TextDisabled] = "TextDisabled";
        __styleColours[ImGuiCol.ModalWindowDimBg] = "ModalWindowDimBg";
        
        __imGuiContext = new ImGuiContext(0, 0, PaneGetWidth(), PaneGetHeight())
    }
    
    return _system;
}