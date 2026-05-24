// Feather disable all

function __PaneTick()
{
    static _system = __PaneSystem();
    
    with (_system)
    {
        __windowUpdated = false;
        
        __windowWidth = window_get_width();
        __windowHeight = window_get_height();
        __windowX = window_get_x();
        __windowY = window_get_y();
        
        if (__windowWidth != __windowWidthLast)
        {
            __windowUpdated = true;
        }
        
        if (__windowHeight != __windowHeightLast)
        {
            __windowUpdated = true;
        }
        if (__windowX != __windowXLast)
        {
            __windowUpdated = true;
        }
        
        if (__windowY != __windowYLast)
        {
            __windowUpdated = true;
        }
        
        __windowWidthLast = __windowWidth;
        __windowHeightLast = __windowHeight;
        __windowXLast = __windowX;
        __windowYLast = __windowY;
        
        if (__windowUpdated && __windowWidth > 0 && __windowHeight > 0)
        {
            display_set_gui_size(__windowWidth, __windowHeight);
            surface_resize(application_surface, __windowWidth, __windowHeight);
            __PaneTrace("Window updated");
        }
        
        if (__windowCommandsAvailable)
        {
            if (window_command_check(window_command_close))
            {
                if (is_method(__windowCloseCallback))
                {
                    __windowCloseCallback();
                }
                else
                {
                    window_command_run(window_command_close);
                }
            }
            
            if (window_command_check(window_command_minimize))
            {
                if (is_method(__windowMinimiseCallback))
                {
                    __windowMinimiseCallback();
                }
                else
                {
                    window_command_run(window_command_minimize);
                }
            }
            
            if (window_command_check(window_command_maximize))
            {
                if (is_method(__windowMaximiseCallback))
                {
                    __windowMaximiseCallback();
                }
                else
                {
                    window_command_run(window_command_maximize);
                }
            }
        }
    }
}