// Feather disable all

function __ReggieStructClone(_source, _destination)
{
    if (is_undefined(_source)) return _destination;
    
    if (is_undefined(_destination) || !is_struct(_destination)) {
        _destination = {};
    }
    
    var _keys = variable_struct_get_names(_source);
    var _len = array_length(_keys);
    
    var _i = 0;
    repeat(_len)
    {
        var _key = _keys[_i];
        var _value = variable_struct_get(_source, _key);
        
        if (is_array(_value))
        {
            var _array = [];
            
            var _arrayLen = array_length(_value);
            
            var _j = 0;
            repeat(_arrayLen)
            {
                _array[_j] = __ReggieStructClone(_value[_j], undefined);
                _j++;
            }
            
            _destination[$ _key] = _array;
        }
        else if (is_struct(_value))
        {
            var _sub = {};
            
            __ReggieStructClone(_value, _sub);
            
            _destination[$ _key] = _sub;
        }
        else
        {
            _destination[$ _key] = _value;
        }
        
        _i++;
    }
    
    return _destination;
}