/// @desc Do the initialisation sequence

switch (initPhase)
{
    // Begin
    case 0:
        array_push(initLog, "Initialising BactaTank-Classic");
        break;
    
    // Register misc stuff
    case 1:
        BactaInitCommandParams();
        BactaInitShortcuts();
        
        BactaInitConfig();
        ReggieLoad();
        
        BactaInitFiletypes();
        BactaInitDirectories();
        
        array_push(initLog, "Loading user config");
        break;
    
    // Load user config
    case 2:
        
        array_push(initLog, "Applying user config");
        break;
    
    // Apply user config
    case 3:
        
        array_push(initLog, "Loading themes");
        break;
    
    // Load themes
    case 4:
        BactaInitThemes();
        array_push(initLog, "Loading templates");
        break;
    
    // Load templates
    case 5:
        
        array_push(initLog, "Loading UI");
        break;
    
    // Load UI
    case 99:
        BactaInitUI();
        UISetTheme("Default Dark");
        break;
    
    // Finish loading
    case 100:
        BactaInitWindow();
        UIOpenModal("Test");
        room_goto(scnMain);
        break;
    
}

initPhase++;