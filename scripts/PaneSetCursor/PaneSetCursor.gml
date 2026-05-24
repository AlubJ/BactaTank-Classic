// Feather disable all

///
/// Set the window cursor
///
/// @param {Id.Cursor} cursor The cursor type to use.
function PaneSetCursor(_cursor)
{
    static _system = __PaneSystem();
    
    with (_system)
    {
        window_set_cursor(_cursor);
    }
}