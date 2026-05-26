// Feather disable all

///
/// Begin child
///
/// @param {String} id
/// @param {Real} width
/// @param {Real} height
function UIBeginChild(_id, _width = 0, _height = 0)
{
    var _return = ImGuiBeginChild(_id, _width, _height, ImGuiChildFlags.Borders);
    //ImGuiSpacing();
    return _return;
}