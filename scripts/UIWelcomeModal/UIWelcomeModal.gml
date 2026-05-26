function UIWelcomeModal() : UIModal() constructor
{
    __recentProjects = [
        "Test1",
        "Test2",
        "Test3",
        "Test4",
        "Test5",
        "Test6",
        "Test7",
        "Test8",
        "Test9",
        "Test10",
        "Test11",
        "Test12",
        "Test13",
        "Test14",
        "Test15",
        "Test16",
        "Test17",
        "Test18",
        "Test19",
        "Test20",
        "Test21",
        "Test22",
        "Test23",
        "Test24",
        "Test25",
        "Test26",
        "Test27",
        "Test28",
        "Test29",
        "Test30",
        ];
    
    static render = function(_width, _height)
    {
        UIHeader("Welcome to BactaTank Classic", fa_center);
        
        UIText("Recent files");
        UISpacing();
        
        if (UIBeginChild("recentFiles", 0, -42))
        {
            var _i = 0;
            repeat (array_length(__recentProjects))
            {
                ImGuiSelectable(__recentProjects[_i], false);
                _i++;
            }
            UIEndChild();
        }
        
        UISpacing();
        UISeparator();
        UISpacing();
        
        ImGuiButton("New Project");
        ImGuiSameLine();
        ImGuiButton("Open Project or Model");
    }
}