// Feather disable all

/// 
/// Draw a UI frame
///
function UIFrameDraw()
{
    static _system = __UISystem();
    
    with (_system)
    {
        draw_clear(__currentBackgroundColour);
        __imGuiContext.Draw();
    }
}