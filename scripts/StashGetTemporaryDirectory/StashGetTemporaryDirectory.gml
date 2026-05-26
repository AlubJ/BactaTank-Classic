// Feather disable all

/// 
/// Return the path of the temporary directory with the trailing "/"
/// 
function StashGetTemporaryDirectory()
{
    static _system = __StashSystem();
    
    with (_system)
    {
        return __tempDirectory;
    }
}