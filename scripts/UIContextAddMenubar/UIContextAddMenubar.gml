// Feather disable all

///
/// Add a new menubar
///
/// @param {Function} menubar The menubar function to use
/// @param {String} context The name of the context it sits in
function UIContextAddMenubar(_menubar, _context)
{
    static _system = __UISystem();
    
    with (_system)
    {
        if (variable_struct_exists(__contexts, _context))
        {
            if (__contexts[$ _context].menuBar == undefined)
            {
                __contexts[$ _context].menuBar = _menubar;
            }
        }
    }
}