///
/// Initialise the window
///
function BactaInitWindow()
{
    PaneSet(
        ReggieGet("window.width"),
        ReggieGet("window.height"),
        ReggieGet("window.x"),
        ReggieGet("window.y"),
        ReggieGet("window.maximised"),
        true,
        true
    );
    
    PaneSetCursor(cr_default);
    
    PaneSetCloseCallback(function () {
        game_end();
    })
}