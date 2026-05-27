// Feather disable all

///
/// Add a recent file to the top of the recent files and remove the old entry
///
function BactaAddRecentFile(_name, _path, _type)
{
    static _system = __BactaSystem();
    
    with (_system)
    {
        if (_type == BACTA_PROJECT_DEFAULT)
        {
            _type = "Project";
        }
        else
        {
            _type = "Model";
        }
        
        var _entry = {
            name: _name,
            path: _path,
            type: _type,
        };
        
        var _i = 0;
        repeat (array_length(__recentFiles))
        {
            if (__recentFiles[_i].path == _path)
            {
                array_delete(__recentFiles, _i, 1);
            }
        }
        
        array_insert(__recentFiles, 0, _entry);
        
        while (array_length(__recentFiles) > BACTA_RECENT_FILES_MAX)
        {
            array_resize(__recentFiles, array_length(__recentFiles) - 1);
        }
    }
}