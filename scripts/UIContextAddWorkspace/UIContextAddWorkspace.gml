// Feather disable all

///
/// Add a new workspace
///
/// @param {String} name The name of the workspace
/// @param {String} context The name of the context it sits in
function UIContextAddWorkspace(_name, _context)
{
    static _system = __UISystem();
    
    with (_system)
    {
        if (variable_struct_exists(__contexts, _context))
        {
            array_push(__contexts[$ _context].workspaces, {
                name: _name,
                panels: [  ],
                flexWeights: [  ],
            });
        }
    }
}