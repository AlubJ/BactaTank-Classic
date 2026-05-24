// Feather disable all

///
/// Register a config parameter
/// 
/// @param {String} name The name of the config parameter. To add a separate namespace use `namespace.key`.
/// @param {Any} default The default value of the config parameter.
function ReggieRegister(_name, _default = undefined)
{
    static _system = __ReggieSystem();
    
    with (_system)
    {
        var _key = _name;
        
        if (string_pos(_name, "."))
        {
            var _split = string_split(_name, ".");
            
            __registers[$ _split[0]] = {  };
            __registers[$ _split[0]][$ _split[1]] = _default;
        }
        else
        {
            __registers[$ _name] = _default;
        }
    }
}