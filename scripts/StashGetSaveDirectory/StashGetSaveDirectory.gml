// Feather disable all

/// 
/// Return the path of the save directory with the trailing "/"
/// 
function StashGetSaveDirectory()
{
    static _system = __StashSystem();
    
    with (_system)
    {
        return __saveDirectory;
    }
}