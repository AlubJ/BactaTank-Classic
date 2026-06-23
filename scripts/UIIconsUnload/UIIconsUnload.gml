// Feather disable all

function UIIconsUnload()
{
    static _system = __UISystem();
    
    with (_system)
    {
        var _iconNames = variable_struct_get_names(__icons);
        
        repeat (array_length(_iconNames))
        {
            var _iconName = array_pop(_iconNames);
            sprite_delete(__icons[$ _iconName]);
        }
    }
}