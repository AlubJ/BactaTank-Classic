// Feather disable all
/// @return N/A
/// 
/// @param struct/array          The data to be encoded. Can contain structs, arrays, strings, and numbers.   N.B. Will not encode ds_list, ds_map etc.
/// @param struct/array          The filepath for the final file to be saved to.
/// @param [alphabetizeStructs]  (bool) Sorts struct variable names is ascending alphabetical order as per array_sort(). Defaults to <false>
/// 
/// @jujuadams 2022-10-30

function SnapToBinary(_ds, _filepath, _alphabetise = false)
{
    var _buffer = buffer_create(1, buffer_grow, 1);
    SnapBufferWriteBinary(_buffer, _ds, _alphabetise);
    buffer_save(_buffer, _filepath);
    buffer_delete(_buffer);
}
