// Feather disable all

///
/// Rebind a shortcut in the registry
///
/// @param {String} name The name of the shortcut.
/// @param {String} bind The new bind of the shortcut. ("Ctrl+Alt+Del").
/// @param {String} context The context of the shortcut.

function CutterSetBind(_name, _bind, _context = "global")
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
        
        __shortcutContexts[$ _context][$ _name].bind = _bind;
    }
}