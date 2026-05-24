// Feather disable all

function __CutterStructFindName(_struct, _value)
{
    var _names = variable_struct_get_names(_struct);
    
    var _i = 0;
    repeat (array_length(_names))
    {
        if (_struct[$ _names[_i]] == _value) return _names[_i];
        
        _i++;
    }
    
    return -1;
}