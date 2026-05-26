// Feather disable all

/// 
/// Add a tracked directory to stash
/// 
/// @param {String} _name The name of the directory
/// @param {String} _directory The directory to add
function StashAddDirectory(_name, _directory)
{
    static _system = __StashSystem();
    
    with (_system)
    {
        __stashDirectories[$ _name] = _directory;
        
        if (!directory_exists(_directory))
        {
            directory_create(_directory);
        }
    }
}