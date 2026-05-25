// Feather disable all

///
/// Begin a menu
///
/// @param {String} label
/// @param {String} [enabled]
function UIBeginMenu(_label, _enabled = true)
{
    return ImGuiBeginMenu(_label, _enabled);
}