// Feather disable all

///
/// Save the config
/// 
function ReggieSave()
{
    static _system = __ReggieSystem();
    
    with (_system)
    {
        if (__config == undefined)
        {
            __ReggieError("Config is undefined, please attempt to load the config file first to generate the default config");
        }
        
        var _json = json_stringify(__config);
        var _buffer = buffer_create(1, buffer_grow, 1);
        
        buffer_write(_buffer, buffer_text, _json);
        buffer_save(_buffer, __saveDirectory + REGGIE_CONFIG_NAME);
        
        buffer_delete(_buffer);
        
        __ReggieTrace("Config file saved");
    }
}