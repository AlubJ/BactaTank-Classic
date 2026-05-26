// Feather disable all

///
/// Add a new asset
///
/// @param {String} file The file of the asset
function BactaAddAsset(_name)
{
    static _system = __BactaSystem();
    
    with (_system)
    {
        if (!file_exists(_name))
        {
            __BactaError($"Asset `{_name}` does not exist");
        }
        
        var _fileExtension = filename_ext(_name);
        var _filename = string_split(filename_name(_name), ".")[0];
        
        switch (_fileExtension)
        {
            case "*.png":
                __assets[$ _filename] = sprite_add(_filename, 1, false, false, 0, 0);
                break;
        }
    }
}