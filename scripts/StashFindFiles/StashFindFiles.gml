// Feather disable all

///
/// Search a directory and return back an array of directories
///
/// @param {String} directory The directory to search
/// @param {String} mask The mask to search for
/// @param {Id.FileAttribute} _attributes The attributes to search for
/// @param {Real} [depth] The depth to search for
function StashFindFiles(_directory, _mask, _attributes, _depth = infinity)
{
    static _system = __StashSystem();
    
    with (_system)
    {
        var _files = [  ];
        
        if (!directory_exists(_directory))
        {
            __StashError($"Directory `{_directory}` does not exist");
        }
        
        __StashScanDirectory(_directory, _mask, _attributes, _files, 0, _depth);
    }
    
    return _files;
}

function __StashScanDirectory(_directory, _mask, _attributes, _files, _currentDepth, _maxDepth)
{
    if (_maxDepth != infinity && _currentDepth > _maxDepth)
    {
        return;
    }
    
    if (string_char_at(_directory, string_length(_directory)) != "/" && string_char_at(_directory, string_length(_directory)) != "\\")
    {
        _directory += "/";
    }
    
    var _subDirectories = [  ];
    
    var _file = file_find_first(_directory + _mask, _attributes);
    
    while (_file != "")
    {
        if (_file != "." && _file != "..")
        {
            var _fullPath = _directory + _file;
            
            if (directory_exists(_fullPath))
            {
                array_push(_subDirectories, _fullPath);
                if (_attributes & fa_directory)
                {
                    array_push(_files, _fullPath + "/");
                }
            }
            else
            {
                if (_attributes != fa_directory)
                {
                    array_push(_files, _fullPath);
                }
            }
        }
        
        var _file = file_find_next();
    }
    
    file_find_close();
    
    var _i = 0;
    repeat (array_length(_subDirectories))
    {
        __StashScanDirectory(_subDirectories[_i], _mask, _attributes, _files, _currentDepth + 1, _maxDepth);
    }
}