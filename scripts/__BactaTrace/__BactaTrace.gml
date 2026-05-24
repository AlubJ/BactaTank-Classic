// Feather disable all

function __BactaTrace()
{
    var _string = "BactaTank: ";
    
    var _i = 0;
    repeat(argument_count)
    {
        _string += argument[_i];
        ++_i;
    }
    
    show_debug_message(_string);
    
    return _string;
}