// Feather disable all

///
/// Add a template
///
function BactaAddTemplate(_template)
{
    static _system = __BactaSystem();
    
    with (_system)
    {
        array_push(__templates, _template);
    }
}