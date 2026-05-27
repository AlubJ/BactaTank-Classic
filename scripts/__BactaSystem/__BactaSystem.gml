// Feather disable all
__BactaSystem();

function __BactaSystem()
{
    static _system = undefined;
    if (_system != undefined) return _system;
    
    _system = {  };
    with (_system)
    {
        __assets = {  };
        
        __project = undefined;
        
        __recentFiles = [  ];
        __templates = [  ];
        
        __BactaTrace($"Welcome to BactaTank Classic by Alun Jones. Version {BACTA_VERSION} {BACTA_DATE}");
    }
    
    return _system;
}