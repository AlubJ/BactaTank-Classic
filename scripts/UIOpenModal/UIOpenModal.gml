// Feather disable all

///
/// Open a modal
///
/// @param {String} name The name of the modal
function UIOpenModal(_name)
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