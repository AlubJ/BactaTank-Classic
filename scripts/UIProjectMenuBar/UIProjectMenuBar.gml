function UIProjectMenuBar()
{
    if (ImGuiBeginMenu("File"))
    {
        ImGuiMenuItem("Test");
        ImGuiEndMenu();
    }
}