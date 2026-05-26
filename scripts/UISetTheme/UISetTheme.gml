// Feather disable all

///
/// Set a theme to the UI
///
/// @param {String} theme The theme name
function UISetTheme(_name)
{
    static _system = __UISystem();
    
    with (_system)
    {
        //ImGuiPopFont();
        //ImGuiPushFont(__defaultFont);
        ImGuiStyleColorsDark();
        
        if (!variable_struct_exists(__themes, _name))
        {
            __BactaWarn($"Theme `{_name}` does not exist or has not been loaded");
            return;
        }
        
        var _theme = __themes[$ _name];
        var _themeFields = variable_struct_get_names(_theme);
        
        var _i = 0;
        repeat (array_length(_themeFields))
        {
            var _style = array_get_index(__styleVars, _themeFields[_i]);
            
            if (_style != -1)
            {
                ImGuiSetStyleVar(_style, _theme[$ _themeFields[_i]]);
                _i++;
                continue;
            }
            
            var _style = array_get_index(__styleColours, _themeFields[_i]);
            
            if (_style != -1)
            {
                var _colour = make_colour_rgb(_theme[$ _themeFields[_i]][0], _theme[$ _themeFields[_i]][1], _theme[$ _themeFields[_i]][2]);
                ImGuiSetStyleColor(_style, _colour, _theme[$ _themeFields[_i]][3] / 255);
                _i++;
                continue;
            }
            
            _i++;
        }
        
        if (variable_struct_exists(_theme, "font"))
        {
            ImGuiPushFont(_theme[$ "font"]);
        }
    }
}