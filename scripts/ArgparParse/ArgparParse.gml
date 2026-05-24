// Feather disable all

///
/// Parses the parameters passed into the game.
///
function ArgparParse()
{
    static _system = __ArgparSystem();
    
    with (_system)
    {
        var _argCount = parameter_count();
        
        var _i = 0;
        repeat(_argCount)
        {
            var _token = parameter_string(_i);
            
            if (!string_starts_with(_token, ARGPAR_PARAMETER_PREFIX))
            {
                var _positional = __ArgparFindParam("default");
                
                if (!is_undefined(_positional))
                {
                    __parsedParameters[$ _positional.name] = _token;
                    
                    _i++;
                    continue;
                }
                
                __ArgparTrace($"Unknown parameter \"{_token}\"");
                _i++;
                continue;
            }
            
            _token = string_delete(_token, 1, string_length(ARGPAR_PARAMETER_PREFIX));
            
            var _param = __ArgparFindParam(_token);
            
            if (is_undefined(_param))
            {
                __ArgparTrace($"Unknown parameter \"{_token}\"");
                _i++;
                continue;
            }
            
            var _values = [];
            
            var _t = 0;
            repeat(_param.parameterCount)
            {
                _i++;
                
                if (_i >= _argCount)
                {
                    __ArgparError($"Missing value for parameter \"{_param.name}\"");
                }
                
                var _raw = parameter_string(_i);
                
                var _type = _param.types[_t];
                
                if (_type == ty_real)
                {
                    _raw = real(_raw);
                }
                
                array_push(_values, _raw);
                
                _t++;
            }
            
            if (array_length(_values) == 0)
            {
                __parsedParameters[$ _param.name] = true;
            }
            else if (array_length(_values) == 1)
            {
                __parsedParameters[$ _param.name] = _values[0];
            }
            else
            {
                __parsedParameters[$ _param.name] = _values;
            }
            
            _i++;
        }
        
        __ArgparApplyDefaults();
    }
}