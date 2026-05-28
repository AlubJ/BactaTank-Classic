// Feather disable all

///
/// Set a context
///
/// @param {String} name The name of the context
function UISetContext(_name)
{
    static _system = __UISystem();
    
    with (_system)
    {
        if (variable_struct_exists(__contexts, _name))
        {
            __currentContext = _name;
        }
    }
}