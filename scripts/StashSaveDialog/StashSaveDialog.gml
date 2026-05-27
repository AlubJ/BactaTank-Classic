// Feather disable all

/// 
/// Save dialog
/// 
function StashSaveDialog(_title, _filterArray, _defaultName = "", _defaultPath = "")
{
    static _system = __StashSystem();
    
    with (_system)
    {
        var _filter = __StashBuildFilter(_filterArray);
        return get_save_filename_ext(_filter, _defaultName, _defaultPath, _title);
    }
}