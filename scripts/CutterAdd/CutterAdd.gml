// Feather disable all

///
/// Add a new shortcut to the shortcuts registry
///
/// @param {String} name The name of the shortcut.
/// @param {String} bind The bind of the shortcut. ("Ctrl+Alt+Del").
/// @param {Function} callback The callback of the shortcut.
/// @param {String} context The context to add this shortcut in.

function CutterAdd(_name, _bind, _callback, _context = "global")
{
    static _system = __CutterSystem();
    
    with (_system)
    {
        if (!variable_struct_exists(__shortcutContexts, _context))
        {
            __shortcutContexts[$ _context] = {};
        }
        
        __shortcutContexts[$ _context][$ _name] = {
            name: _name,
            bind: _bind,
            callback: _callback,
            context: _context,
        };
    }
}