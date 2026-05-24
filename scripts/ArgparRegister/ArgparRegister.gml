// Feather disable all

///
/// Register a parameter in the argument parser.
///
/// @param {String} name The name identifier for the parameter. Leave blank to return the first instance without a paramenter string.
/// @param {Array.String} [aliases] The aliases to use for the parameter.
/// @param {Array.Id.Types} [types] The types to use for the parameter. (`ty_string`, `ty_real`, `undefined`)
/// @param {Array.Any} [default] An array of default values that is used when the parameter is not set.
function ArgparRegister(_name, _aliases = [  ], _types = [  ], _default = [  ])
{
    if (!is_string(_name))
    {
        __ArgparError("`name` parameter must be a string.");
    }
    
    array_push(_aliases, _name);
    if (is_array(_aliases))
    {
        if (array_length(_aliases) > 0)
        {
            if (array_any(_aliases, function (_value, _index) {
                return !is_string(_value);
            }))
            {
                __ArgparError("`aliases` parameter can only contain strings.");
            }
        }
        else
        {
            __ArgparError("`aliases` parameter cannot be empty.");
        }
    }
    else
    {
        __ArgparError("`aliases` parameter must be an array.");
    }
    
    if (is_array(_types))
    {
        if (array_length(_types) > 0)
        {
            if (array_any(_types, function (_value, _index) {
                return (_value != ty_real && _value != ty_string && _value != undefined);
            }))
            {
                __ArgparError("`types` parameter can only contain `ty_string`, `ty_real`, `undefined`.");
            }
        }
    }
    else
    {
        __ArgparError("`types` parameter must be an array.");
    }
    
    if (is_array(_default))
    {
        if (array_length(_types) == 0 && array_length(_default) == 0)
        {
            __ArgparError("`default` parameter must have one default if parameter is a flag.");
        }
        else if (array_length(_types) > 0)
        {
            if (array_length(_types) != array_length(_default))
            {
                __ArgparError("`default` parameter must have the same number of entries as `types`.");
            }
        }
    }
    else
    {
        __ArgparError("`default` parameter must be an array.");
    }
    
    static _system = __ArgparSystem();
    
    with (_system)
    {
        __parameters[$ _name] = {
            name: _name,
            aliases: _aliases,
            types: _types,
            parameterCount: array_length(_types),
            defaults: _default,
        }
    }
}