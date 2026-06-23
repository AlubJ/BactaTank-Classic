// Feather disable all

function UIIconGet(_iconName)
{
    static _system = __UISystem();
    
    with (_system)
    {
        if (variable_struct_exists(__icons, _iconName))
        {
            return __icons[$ _iconName];
        }
        else
        {
            return graMissingIcon;
        }
    }
}