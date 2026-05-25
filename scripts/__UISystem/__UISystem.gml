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
        __modals = {  };
        
        __currentContext = undefined;
        __currentWorkspace = 0;
        
        __ident = "Test Test Test";
        
        __imGuiContext = new ImGuiContext(0, 0, PaneGetWidth(), PaneGetHeight())
    }
    
    return _system;
}