// Feather disable all

///
/// Get the bind of the passed in shortcut.
///
/// @param {String} name The name of the shortcut.
/// @param {String} context The context to add this shortcut in.

function CutterGetBind(_name, _context = "global")
{
    static _system = __CutterSystem();
    
    with (_system)
    {
        if (!variable_struct_exists(__shortcutContexts, _context))
        {
            return "";
        }
        
        if (!variable_struct_exists(__shortcutContexts[$ _context], _name))
        {
            return "";
        }
        
        return __shortcutContexts[$ _context][$ _name].bind;
    }
}