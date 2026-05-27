///
/// Initialise the user interface
///
function BactaInitUI()
{
    UISetIdent("BactaTank Classic", BACTA_VERSION);
    
    UIAddModal("Welcome", new UIWelcomeModal(), 640, 520, false, true);
    UIAddModal("New Model", new UINewModelModal(), 640, 520, true, true);
    UIAddModal("New Project", new UINewProjectModal(), 500, 192, true, true);
    
    UIBegin();
}