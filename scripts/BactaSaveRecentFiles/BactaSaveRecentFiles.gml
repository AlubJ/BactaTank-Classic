// Feather disable all

///
/// Save the recent files
///
function BactaSaveRecentFiles()
{
    static _system = __BactaSystem();
    
    with (_system)
    {
        var _buffer = buffer_create(1, buffer_grow, 1);
        buffer_write(_buffer, buffer_text, json_stringify(__recentFiles));
        buffer_save(_buffer, StashGetSaveDirectory() + "recents.json");
        buffer_delete(_buffer);
    }
}