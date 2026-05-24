// Feather disable all

///
/// Import binds from a struct into the registered shortcuts.
///
/// @param {Struct} bindStruct The bind struct that was exported using `CutterExportBinds`.
function CutterImportBinds(_bindStruct)
{
    static _system = __CutterSystem();
    
    with (_system)
    {
        var _struct = {  };
        
        var _contexts = variable_struct_get_names(_bindStruct);
        
        var _i = 0;
        repeat (array_length(_contexts))
        {
            if (!variable_struct_exists(__shortcutContexts, _contexts[_i]))
            {
                _i++;
                continue;
            }
            
            var _binds = variable_struct_get_names(_bindStruct[$ _contexts[_i]]);
            
            var _j = 0;
            repeat (array_length(_binds))
            {
                if (!variable_struct_exists(_bindStruct[$ _contexts[_i]], _binds[_i]))
                {
                    _j++;
                    continue;
                }
                
                __shortcutContexts[$ _contexts[_i]][$ _binds[_j]].bind = _bindStruct[$ _contexts[_i]][$ _binds[_j]];
                _j++;
            }
            
            _i++;
        }
    }
}