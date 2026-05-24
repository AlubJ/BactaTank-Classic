// Feather disable all

///
/// Helper function to get the current bind that is pressed down. Disable shortcut detection using `CutterSetEnabled` before using this function.
///
function CutterGetLastBind()
{
    static _system = __CutterSystem();
    
    with (_system)
    {
        return __lastBind;
    }
}