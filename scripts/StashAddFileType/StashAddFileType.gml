// Feather disable all

/// 
/// Add a filetype
/// 
function StashAddFileType(_name, _description, _extension)
{
    static _system = __StashSystem();
    
    with (_system)
    {
        __filetypes[$ _name] = {
            name: _name,
            description: _description,
            extension: _extension,
        };
    }
}