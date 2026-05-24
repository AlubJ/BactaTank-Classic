// Feather disable all
__ReggieSystem();

function __ReggieSystem()
{
    static _system = undefined;
    if (_system != undefined) return _system;
    
    _system = {  };
    with (_system)
    {
        __saveDirectory = game_save_id;
        __config = undefined;
        __registers = {  };
        
        __ReggieTrace($"Welcome to Reggie by Alun Jones. This is v{REGGIE_VERSION} {REGGIE_DATE}");
        
        __ReggieEnsureInstance();
        time_source_start(time_source_create(time_source_game, 1, time_source_units_frames, function () { __ReggieEnsureInstance() }, [  ], -1));
    }
    
    return _system;
}