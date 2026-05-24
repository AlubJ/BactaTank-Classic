// Feather disable all

///
/// Remove a new shortcut from the shortcuts registry
///
/// @param {String} name The name of the shortcut.
/// @param {String} context The context of the shortcut.

function CutterRemove(_name, _context = "global")
{
    static _system = __CutterSystem();
    
    with (_system)
    {
        if (!variable_struct_exists(__shortcutContexts, _context))
        {
            __CutterError($"Context \"{_context}\" does not exist.");
        }
        
        if (!variable_struct_exists(__shortcutContexts[$ _context], _name))
        {
            __CutterError($"Shortcut \"{_name}\" in context \"{_context}\" does not exist.");
        }
        
        variable_struct_remove(__shortcutContexts[$ _context], _name);
    }
}