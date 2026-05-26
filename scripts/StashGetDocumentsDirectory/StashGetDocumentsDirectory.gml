// Feather disable all

/// 
/// Return the path of the documents directory with the trailing "/"
/// 
function StashGetDocumentsDirectory()
{
    static _system = __StashSystem();
    
    with (_system)
    {
        return __documentsDirectory;
    }
}