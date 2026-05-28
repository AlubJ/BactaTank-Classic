// Feather disable all

///
/// Get whether the window is minimised or not
///
function PaneGetMinimised()
{
    static _system = __PaneSystem();
    
    with (_system)
    {
        return __windowMinimised;
    }
}