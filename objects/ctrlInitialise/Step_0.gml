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
        BactaInitFiletypes();
        BactaInitConfig();
        BactaInitDirectories();
        
        array_push(initLog, "Loading user config");
        break;
    
    // Load user config
    case 2:
        ReggieLoad();
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
    case 6:
        BactaInitUI();
        UISetTheme("Default Dark");
        array_push(initLog, "Loading UI");
        break;
    
    // Default
    default:
        BactaInitWindow();
        room_goto(scnMain);
        break;
    
}

initPhase++;