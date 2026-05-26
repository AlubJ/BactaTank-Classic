// Feather disable all

/// 
/// Return the path of the working directory with the trailing "/"
/// 
function StashGetWorkingDirectory()
{
    static _system = __StashSystem();
    
    with (_system)
    {
        return __workingDirectory;
    }
}