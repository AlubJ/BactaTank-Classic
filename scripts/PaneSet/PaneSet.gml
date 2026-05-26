// Feather disable all

///
/// Set a bunch of stuff in here
///
/// @param {Real} width The width of the window
/// @param {Real} height The height of the window
/// @param {Real} [x] The x of the window
/// @param {Real} [y] The y of the window
/// @param {Bool} [maximised] Whether the window is maximised or not
/// @param {Bool} [border] Whether the window has its border or not
/// @param {Bool} [center] Whether the window has is centered or not
/// @param {Real} [minWidth] The minimum width of the window
/// @param {Real} [minHeight] The minimum height of the window
function PaneSet(_width, _height, _x = undefined, _y = undefined, _maximised = false, _border = true, _center = false, _minWidth = undefined, _minHeight = undefined)
{
    static _system = __PaneSystem();
    
    with (_system)
    {
        if (_width != undefined && _height != undefined)
        {
            window_set_size(_width, _height);
        }
        else
        {
            _width = __windowWidth;
            _height = __windowHeight;
        }
        
        if (_x != undefined && _y != undefined)
        {
            var _displayWidth = display_get_width();
            var _displayHeight = display_get_height();
            
            _x = clamp(_x, 0, _width - _displayWidth);
            _y = clamp(_y, 0, _height - _displayHeight);
            
            window_set_position(_x, _y);
        }
        else
        {
            if (_center)
            {
                window_center();
            }
        }
        
        if (_minWidth != undefined && _minHeight != undefined)
        {
            window_set_min_width(_minWidth);
            window_set_min_height(_minHeight);
        }
        
        window_set_showborder(_border);
    }
}