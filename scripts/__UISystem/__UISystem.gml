// Feather disable all
__UISystem();

function __UISystem()
{
    static _system = undefined;
    if (_system != undefined) return _system;
    
    _system = {  };
    with (_system)
    {
        __themes = {  };
        __contexts = {  };
        
    }
    
    return _system;
}