// Feather disable all

///
/// Get the height of the window
///
function PaneGetHeight()
{
    static _system = __PaneSystem();
    
    with (_system)
    {
        return __windowHeight;
    }
}