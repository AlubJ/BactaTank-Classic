// Feather disable all

///
/// Whether to enable or disable the shortcut detector.
///
/// @param {Bool} enabled Whether enabled or disabled.
function CutterSetEnabled(_enabled)
{
    static _system = undefined;
    
    with (_system)
    {
        __detectionEnabled = _enabled;
    }
}