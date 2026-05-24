// Feather disable all

///
/// Set a config parameter
/// 
/// @param {String} name The name of the config parameter.
/// @param {Any} value The value to set.
function ReggieSet(_name, _value)
{
    static _system = __ReggieSystem();
    
    with (_system)
    {
        var _key = _name;
        
        if (string_pos(_name, "."))
        {
            var _split = string_split(_name, ".");
            
            __config[$ _split[0]] = {  };
            __config[$ _split[0]][$ _split[1]] = _value;
        }
        else
        {
            __config[$ _name] = _value;
        }
    }
}