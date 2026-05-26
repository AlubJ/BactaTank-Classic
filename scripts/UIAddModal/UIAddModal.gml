// Feather disable all

///
/// Add a new modal
///
/// @param {String} name The name of the modal
/// @param {Struct} modal The modal
/// @param {Real} width The percentage width of the modal
/// @param {Real} height The percentage height of the modal
/// @param {Bool} [allowClose] Whether the modal is allowed to be closed
/// @param {Bool} [fixedSize] Whether the modal has a fixed size or not
function UIAddModal(_name, _modal, _width, _height, _allowClose = false, _fixedSize = false)
{
    static _system = __UISystem();
    
    with (_system)
    {
        if (!variable_struct_exists(__modals, _name))
        {
            __modals[$ _name] = {
                name: _name,
                open: false,
                closed: false,
                modal: _modal,
                width: _width,
                height: _height,
                allowClose: _allowClose,
                fixedSize: _fixedSize,
            };
        }
    }
}