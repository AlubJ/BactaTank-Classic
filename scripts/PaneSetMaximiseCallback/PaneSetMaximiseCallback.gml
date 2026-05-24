// Feather disable all

///
/// Set the callback that is used when the maximise button is clicked or if a command to maximise the window is triggered
///
/// @param {Function} callback The callback to trigger
function PaneSetMaximiseCallback(_callback)
{
    static _system = __PaneSystem();
    
    with (_system)
    {
        if (!is_method(_callback))
        {
            __PaneError("The callback must be a function");
        }
        
        __windowMaximiseCallback = _callback;
    }
}