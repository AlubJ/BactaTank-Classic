///
/// Initialise the user interface
///
function BactaInitUI()
{
    UISetIdent("BactaTank Classic", BACTA_VERSION);
    
    UIAddModal("Test", new UITestModal(), 640, 520, false, true);
    
    UIBegin();
}