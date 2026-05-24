// Feather disable all

function __ArgparSystem()
{
    static _system = undefined;
    if (_system != undefined) return _system;
    
    _system = {  };
    with (_system)
    {
        __parameters = {  };
        __parsedParameters = {  };
        
        __ArgparTrace($"Welcome to Argpar by Alun Jones. This is v{ARGPAR_VERSION} {ARGPAR_DATE}");
    }
    
    return _system;
}