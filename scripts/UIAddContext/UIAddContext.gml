// Feather disable all

///
/// Add a new context
///
/// @param {String} name The name of the context
function UIAddContext(_name)
{
    static _system = __UISystem();
    
    with (_system)
    {
        if (!variable_struct_exists(__contexts, _name))
        {
            __contexts[$ _name] = {
                workspaces: [  ],
                menuBar: undefined,
            };
        }
    }
}