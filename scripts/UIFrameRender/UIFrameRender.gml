// Feather disable all

/// 
/// Render the UI frame
///
function UIFrameRender()
{
    static _system = __UISystem();
    
    with (_system)
    {
        if (ImGuiBeginMainMenuBar())
        {
            if (__currentContext != undefined)
            {
                __contexts[$ __currentContext].menuBar();
                
                ImGuiText(" | ");
                
                if (ImGuiBeginTabBar("Workspaces"))
                {
                    var _i = 0;
                    repeat(array_length(__contexts[$ __currentContext].workspaces))
                    {
                        if (ImGuiBeginTabItem(" " + __contexts[$ __currentContext].workspaces[_i].name + " "))
                        {
                            if (__currentWorkspace != _i)
                            {
                                __currentWorkspace = _i;
                            }
                            
                            ImGuiEndTabItem();
                        }
                        
                        ImGuiEndTabBar();
                    }
                }
            }
            
            ImGuiSetCursorPos(PaneGetWidth() - ImGuiCalcTextWidth(__ident) - 8, 0);
            ImGuiText(__ident);
            
            ImGuiEndMainMenuBar();
        }
    }
}