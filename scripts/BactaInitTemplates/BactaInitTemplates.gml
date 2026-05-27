///
/// Initialise templates
///
function BactaInitTemplates()
{
    var _templates = StashFindFiles(StashGetDirectory("templates"), "*.ghg", fa_none, 0);
    
    var _i = 0;
    repeat (array_length(_templates))
    {
        BactaAddTemplate(_templates[_i]);
        _i++;
    }
}