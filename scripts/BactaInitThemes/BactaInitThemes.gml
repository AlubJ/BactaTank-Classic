///
/// Initialise themes
///
function BactaInitThemes()
{
    var _themes = StashFindFiles(StashGetDirectory("themes"), "*", fa_directory, 0);
    
    var _i = 0;
    repeat (array_length(_themes))
    {
        if (file_exists(_themes[_i] + "theme.yml"))
        {
            UIAddTheme(_themes[_i] + "theme.yml");
        }
        _i++;
    }
}