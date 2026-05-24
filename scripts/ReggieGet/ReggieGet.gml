// Feather disable all

///
/// Set a config parameter
/// 
/// @param {String} name The name of the config parameter.
function ReggieGet(_name)
{
    static _system = __ReggieSystem();
    
    with (_system)
    {
        var _key = _name;
        
        if (string_pos(_name, "."))
        {
            var _split = string_split(_name, ".");
            
            __config[$ _split[0]] = {  };
            return __config[$ _split[0]][$ _split[1]];
        }
        else
        {
            return __config[$ _name];
        }
    }
}