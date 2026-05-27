// Feather disable all

/// 
/// Open dialog
/// 
function StashOpenDialog(_title, _filterArray, _defaultPath = "")
{
    static _system = __StashSystem();
    
    with (_system)
    {
        var _filter = __StashBuildFilter(_filterArray);
        return get_open_filename_ext(_filter, "", _defaultPath, _title);
    }
}