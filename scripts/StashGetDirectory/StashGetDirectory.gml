// Feather disable all

/// 
/// Get a tracked directory to stash
/// 
/// @param {String} _name The name of the directory
function StashGetDirectory(_name)
{
    static _system = __StashSystem();
    
    with (_system)
    {
        return __stashDirectories[$ _name];
    }
}