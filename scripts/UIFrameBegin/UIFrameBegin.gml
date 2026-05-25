// Feather disable all

/// 
/// Begin a UI frame
///
function UIFrameBegin()
{
    static _system = __UISystem();
    
    with (_system)
    {
        __imGuiContext.SetRegion(0, 0, PaneGetWidth(), PaneGetHeight());
        __imGuiContext.FrameStart(window_mouse_get_x(), window_mouse_get_y());
    }
}