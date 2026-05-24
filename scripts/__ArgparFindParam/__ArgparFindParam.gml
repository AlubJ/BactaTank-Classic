// Feather disable all

function __ArgparFindParam(_token)
{
    static _system = __ArgparSystem();
    
    with (_system)
    {
        var _names = variable_struct_get_names(__parameters);
        
        var _i = 0;
        repeat(array_length(_names))
        {
            var _param = __parameters[$ _names[_i]];
            
            if (array_contains(_param.aliases, _token))
            {
                return _param;
            }
            
            _i++;
        }
    }
    
    return undefined;
}