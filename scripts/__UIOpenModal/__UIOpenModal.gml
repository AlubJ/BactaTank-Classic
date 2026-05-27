// Feather disable all

function __UIOpenModal(_name)
{
    static _system = __UISystem();
    
    with (_system)
    {
        if (variable_struct_exists(__modals, _name))
        {
            __modals[$ _name].open = true;
        }
    }
}