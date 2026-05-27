// Feather disable all

///
/// Save the recent files
///
function BactaLoadRecentFiles()
{
    static _system = __BactaSystem();
    
    with (_system)
    {
        var _file = StashGetSaveDirectory() + "recents.json";
        
        if (file_exists(_file))
        {
            var _buffer = buffer_load(_file);
            __recentFiles = json_parse(buffer_read(_buffer, buffer_text));
            buffer_delete(_buffer);
        }
    }
}