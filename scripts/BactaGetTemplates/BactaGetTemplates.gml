// Feather disable all

///
/// Get loaded templates
///
function BactaGetTemplates()
{
    static _system = __BactaSystem();
    
    with (_system)
    {
        return __templates;
    }
}