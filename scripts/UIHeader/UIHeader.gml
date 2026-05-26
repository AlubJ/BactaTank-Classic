// Feather disable all

///
/// Header
///
/// @param {String} text
/// @param {Id.Alignment} alignment
function UIHeader(_text, _alignment = fa_left)
{
    if (_alignment == fa_center)
    {
        var _windowWidth = ImGuiGetWindowWidth() * 0.5;
        var _textWidth = ImGuiCalcTextWidth(_text) * 0.5;
        ImGuiSetCursorPosX(_windowWidth - _textWidth);
    }
    else if (_alignment == fa_right)
    {
        var _windowWidth = ImGuiGetWindowWidth();
        var _textWidth = ImGuiCalcTextWidth(_text);
        ImGuiSetCursorPosX(_windowWidth - _textWidth - 8);
    }
    
    ImGuiText(_text);
    ImGuiSpacing();
    ImGuiSeparator();
    ImGuiSpacing();
}