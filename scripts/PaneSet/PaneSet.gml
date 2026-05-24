// Feather disable all

///
/// Set a bunch of stuff in here
///
/// @param {Real} width The width of the window.
/// @param {Real} height The height of the window.
/// @param {Bool} maximised Whether the window is maximised or not.
/// @param {Bool} border Whether the window has its border or not.
/// @param {Bool} center Whether the window has is centered or not.
function PaneSet(_width, _height, _maximised = false, _border = true, _center = false)
{
    static _system = __PaneSystem();
    
    with (_system)
    {
        if (_width != undefined || _height != undefined)
        {
            window_set_size(_width, _height);
        }
        
        window_set_showborder(_border);
        
        if (_center)
        {
            window_center();
        }
    }
}