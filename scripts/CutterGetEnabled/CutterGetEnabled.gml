// Feather disable all

///
/// Get whether the shortcut detector is enabled or disabled.
///
function CutterGetEnabled()
{
    static _system = undefined;
    
    with (_system)
    {
        return __detectionEnabled;
    }
}