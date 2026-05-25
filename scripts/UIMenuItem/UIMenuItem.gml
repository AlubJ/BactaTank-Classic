// Feather disable all

///
/// Menu item
///
/// @param {String} label
/// @param {String} enabled
function UIMenuItem(_label, _shortcut = "", selected = "", _enabled = true)
{
    return ImGuiMenuItem(_label, _shortcut, selected, _enabled);
}