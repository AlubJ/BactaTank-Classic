// Feather disable all

///
/// Add a theme to the UI
///
/// @param {String} theme The theme file to load
function UIAddTheme(_file)
{
    static _system = __UISystem();
    
    with (_system)
    {
        if (!file_exists(_file))
        {
            __BactaError($"Theme file `{_file}` does not exist");
        }
        
        var _buffer = buffer_load(_file);
        var _theme = SnapBufferReadYAML(_buffer, 0);
        buffer_delete(_buffer);
        
        if (variable_struct_exists(_theme, "Font"))
        {
            var _fontFile = filename_dir(_file) + "/" + _theme[$ "Font"];
            if (file_exists(_fontFile))
            {
                var _fontWeight = 16;
                if (variable_struct_exists(_theme, "FontSize"))
                {
                    _fontWeight = _theme[$ "FontSize"];
                }
                
                var _font = ImGuiAddFontFromFileTTF(_fontFile, _fontWeight, undefined, [ $0000, $024F, 0 ]);
                
                _theme[$ "font"] = _font;
            }
        }
        
        _theme[$ "directory"] = filename_dir(_file) + "/";
        
        __themes[$ _theme[$ "Name"]] = _theme;
    }
}