// Feather disable all

///
/// Add a recent file to the top of the recent files and remove the old entry
///
function BactaGetRecentFiles()
{
    static _system = __BactaSystem();
    
    with (_system)
    {
        return __recentFiles;
    }
}