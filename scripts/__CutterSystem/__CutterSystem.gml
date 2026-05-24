// Feather disable all

function __CutterSystem()
{
    static _system = undefined;
    if (_system != undefined) return _system;
    
    _system = {  };
    with (_system)
    {
        __keyboardMappings = {
            "A": ord("A"),
            "B": ord("B"),
            "C": ord("C"),
            "D": ord("D"),
            "E": ord("E"),
            "F": ord("F"),
            "G": ord("G"),
            "H": ord("H"),
            "I": ord("I"),
            "J": ord("J"),
            "K": ord("K"),
            "L": ord("L"),
            "M": ord("M"),
            "N": ord("N"),
            "O": ord("O"),
            "P": ord("P"),
            "Q": ord("Q"),
            "R": ord("R"),
            "S": ord("S"),
            "T": ord("T"),
            "U": ord("U"),
            "V": ord("V"),
            "W": ord("W"),
            "X": ord("X"),
            "Y": ord("Y"),
            "Z": ord("Z"),
            
            "Space": vk_space,
            "Enter": vk_enter,
            "Escape": vk_escape,
            "Tab": vk_tab,
            "Backspace": vk_backspace,
            
            "Left": vk_left,
            "Right": vk_right,
            "Up": vk_up,
            "Down": vk_down,
            
            "F1": vk_f1,
            "F2": vk_f2,
            "F3": vk_f3,
            "F4": vk_f4,
            "F5": vk_f5,
            "F6": vk_f6,
            "F7": vk_f7,
            "F8": vk_f8,
            "F9": vk_f9,
            "F10": vk_f10,
            "F11": vk_f11,
            "F12": vk_f12,
            
            "Num0": vk_numpad0,
            "Num1": vk_numpad1,
            "Num2": vk_numpad2,
            "Num3": vk_numpad3,
            "Num4": vk_numpad4,
            "Num5": vk_numpad5,
            "Num6": vk_numpad6,
            "Num7": vk_numpad7,
            "Num8": vk_numpad8,
            "Num9": vk_numpad9,
            
            "PageUp": vk_pageup,
            "PageDown": vk_pagedown,
            "Home": vk_home,
            "End": vk_end,
            "Insert": vk_insert,
            "Delete": vk_delete,
        };
        
        __keyboardMappings[$ string("0")] = ord("0");
        __keyboardMappings[$ string("1")] = ord("1");
        __keyboardMappings[$ string("2")] = ord("2");
        __keyboardMappings[$ string("3")] = ord("3");
        __keyboardMappings[$ string("4")] = ord("4");
        __keyboardMappings[$ string("5")] = ord("5");
        __keyboardMappings[$ string("6")] = ord("6");
        __keyboardMappings[$ string("7")] = ord("7");
        __keyboardMappings[$ string("8")] = ord("8");
        __keyboardMappings[$ string("9")] = ord("9");
        
        if (CUTTER_ON_MACOS)
        {
            __keyboardMappings[$ "Ctrl"] = 92; // Swap control key for command key
        }
        
        __shortcutContexts = {
            "global": {},
        };
        
        __currentContext = undefined;
        
        __detectionEnabled = true;
        
        __lastBind = "";
        
        __CutterTrace($"Welcome to Cutter by Alun Jones. This is v{CUTTER_VERSION} {CUTTER_DATE}");
        
        time_source_start(time_source_create(time_source_game, 1, time_source_units_frames, function() {
            __CutterTick();
        }, [  ], -1));
    }
    
    return _system;
}