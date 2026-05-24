// Feather disable all
__PaneSystem();

function __PaneSystem()
{
    static _system = undefined;
    if (_system != undefined) return _system;
    
    _system = {  };
    with (_system)
    {
        __windowWidth = window_get_width();
        __windowHeight = window_get_height();
        __windowX = window_get_x();
        __windowY = window_get_y();
        
        __windowWidthLast = window_get_width();
        __windowHeightLast = window_get_height();
        __windowXLast = window_get_x();
        __windowYLast = window_get_y();
        
        __windowUpdated = false;
        
        __windowCommandsAvailable = false;
        
        __PaneTrace($"Welcome to Pane by Alun Jones. This is v{PANE_VERSION} {PANE_DATE}");
        
        time_source_start(time_source_create(time_source_game, 1, time_source_units_frames, function () { __PaneTick() }, [  ], -1));
        call_later(1, time_source_units_frames, function()
        {
            __PaneCheckWindowHook();
        }, false);
    }
    
    return _system;
}