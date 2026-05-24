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
            surface_resize(application_surface, __windowWidth, __windowHeight);
            display_set_gui_size(__windowWidth, __windowHeight);
            __PaneTrace("Window updated");
        }
    }
}