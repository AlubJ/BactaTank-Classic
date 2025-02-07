// Feather disable all

/// @return Nested struct/array data that represents the contents of the Binary file
/// 
/// @param string  The Binary file to be decoded
/// 
/// @jujuadams 2022-10-30

function SnapFromBinary(_file)
{
    var _buffer = buffer_load(_file);
    var _data = SnapBufferReadBinary(_buffer, 0);
    buffer_delete(_buffer);
    return _data;
}
