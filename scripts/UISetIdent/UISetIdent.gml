// Feather disable all

///
/// Set the ident that sits in the top right corner
///
function UISetIdent(_name, _version)
{
    static _system = __UISystem();
    
    with (_system)
    {
        __appName = _name;
        __version = _version;
    }
}