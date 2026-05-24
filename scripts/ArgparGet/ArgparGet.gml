// Feather disable all

///
/// Returns back the parsed parameter.
///
/// @param {String} name The name of the parameter.
function ArgparGet(_name = "")
{
    static _system = __ArgparSystem();
    
    with (_system)
    {
        return __parsedParameters[$ _name];
    }
}