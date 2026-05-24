// Feather disable all

///
/// Set the callback that is used when the close button is clicked or if a command to close the window is triggered
///
/// @param {Function} callback The callback to trigger
function PaneSetCloseCallback(_callback)
{
    static _system = __PaneSystem();
    
    with (_system)
    {
        if (!is_method(_callback))
        {
            __PaneError("The callback must be a function");
        }
        
        __windowCloseCallback = _callback;
    }
}