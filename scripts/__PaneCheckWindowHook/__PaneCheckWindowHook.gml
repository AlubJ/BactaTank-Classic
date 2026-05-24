// Feather disable all

function __PaneCheckWindowHook()
{
    static _system = __PaneSystem();
    
    with (_system)
    {
        try
        {
            window_command_hook(window_command_close);
            __windowCommandsAvailable = true;
        }
        catch (_e)
        {
            __windowCommandsAvailable = false;
        }
        
        __windowCloseCallback = undefined;
        __windowMaximiseCallback = undefined;
        __windowMinimiseCallback = undefined;
        
        if (__windowCommandsAvailable)
        {
            window_command_hook(window_command_close);
            //window_command_hook(window_command_maximize);
            //window_command_hook(window_command_minimize);
        }
    }
}