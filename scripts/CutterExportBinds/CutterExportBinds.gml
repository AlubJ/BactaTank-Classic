// Feather disable all

///
/// Export all binds used in all contexts to a struct that can be saved to a config file.
///
function CutterExportBinds()
{
    static _system = __CutterSystem();
    
    with (_system)
    {
        var _struct = {  };
        
        var _contexts = variable_struct_get_names(__shortcutContexts);
        
        var _i = 0;
        repeat (array_length(_contexts))
        {
            _struct[$ _contexts[_i]] = { };
            
            var _binds = variable_struct_get_names(__shortcutContexts[$ _contexts[_i]]);
            
            var _j = 0;
            repeat (array_length(_binds))
            {
                _struct[$ _contexts[_i]][$ _binds[_j]] = __shortcutContexts[$ _contexts[_i]][$ _binds[_j]].bind;
                _j++;
            }
            
            _i++;
        }
        
        return _struct;
    }
}