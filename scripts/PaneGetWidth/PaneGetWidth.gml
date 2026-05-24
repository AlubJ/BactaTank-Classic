// Feather disable all

///
/// Get the width of the window
///
function PaneGetWidth()
{
    static _system = __PaneSystem();
    
    with (_system)
    {
        return __windowWidth;
    }
}