// Feather disable all

///
/// Open a modal
///
/// @param {String} name The name of the modal
function UIOpenModal(_name)
{
    DoLater(1, __UIOpenModal, _name);
}