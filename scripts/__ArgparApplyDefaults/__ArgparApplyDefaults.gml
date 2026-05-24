// Feather disable all

function __ArgparApplyDefaults()
{
    static _system = __ArgparSystem();
    
    with (_system)
    {
        var _keys = variable_struct_get_names(__parameters);
        
        var _i = 0;
        repeat (array_length(_keys))
        {
            var _param = __parameters[$ _keys[_i]];
            
            var _name = _param.name;
            
            if (variable_struct_exists(__parsedParameters, _name))
            {
                continue;
            }
            
            var _defaults = _param.defaults;
            
            if (!is_array(_defaults) || array_length(_defaults) == 0)
            {
                continue;
            }
            
            if (array_length(_param.types) == 0)
            {
                __parsedParameters[$ _name] = _defaults[0];
                continue;
            }
            
            if (array_length(defaults) == 1)
            {
                __parsedParameters[$ _name] = _defaults[0];
            }
            else
            {
                __parsedParameters[$ _name] = _defaults;
            }
            
            _i++
        }
    }
}