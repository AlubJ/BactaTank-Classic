function __UISetFont()
{
    static _system = __UISystem();
    
    with (_system)
    {
        if (__currentFontPointer != undefined)
        {
            ImGuiPushFont(__currentFontPointer);
        }
    }
}