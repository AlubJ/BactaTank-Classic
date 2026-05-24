// Feather disable all

///
/// Set the callback that is used when the minimise button is clicked or if a command to minimise the window is triggered
///
/// @param {Function} callback The callback to trigger
function PaneSetMinimiseCallback(_callback)
{
    static _system = __PaneSystem();
    
    with (_system)
    {
        if (!is_method(_callback))
        {
            __PaneError("The callback must be a function");
        }
        
        __windowMinimiseCallback = _callback;
    }
}