// Feather disable all

///
/// Load the config
/// 
function ReggieLoad()
{
    static _system = __ReggieSystem();
    
    with (_system)
    {
        var _file = __saveDirectory + REGGIE_CONFIG_NAME;
        
        if (__config == undefined)
        {
            __ReggieTrace("Generating the default config");
            
            // TODO: Rather than this I need to add an update function to each config register
            __config = variable_clone(__registers);
        }
        
        if (file_exists(_file))
        {
            var _buffer = buffer_load(_file);
            var _json = json_parse(buffer_read(_buffer, buffer_text));
            
            buffer_delete(_buffer);
            
            __ReggieStructClone(_json, __config);
            
            __ReggieTrace("Successfully loaded config");
        }
        
        ReggieSave();
    }
}