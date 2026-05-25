// Feather disable all

/// 
/// End a UI frame
///
function UIFrameEnd()
{
    static _system = __UISystem();
    
    with (_system)
    {
        __imGuiContext.FrameEnd();
    }
}