// Feather disable all

///
/// Returns if a project is currently open
///
function BactaProjectOpen()
{
    static _system = __BactaSystem();
    
    with (_system)
    {
        return __project != undefined;
    }
}