// Feather disable all

///
/// Close the current modal
///
function UICloseModal()
{
    static _system = __UISystem();
    
    with (_system)
    {
        ImGuiCloseCurrentPopup();
    }
}