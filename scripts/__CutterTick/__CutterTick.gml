// Feather disable all

function __CutterTick()
{
    static _system = __CutterSystem();
    
    with (_system)
    {
        __lastBind = "";
        
        var _bind = "";
        
        if (CUTTER_ON_MACOS)
        {
            if (keyboard_check(92))
            {
                _bind += "Ctrl+";
            }
        }
        else
        {
            if (keyboard_check(vk_control))
            {
                _bind += "Ctrl+";
            }
        }
        
        if (keyboard_check(vk_alt))
        {
            _bind += "Alt+";
        }
        
        if (keyboard_check(vk_shift))
        {
            _bind += "Shift+";
        }
        
        if (CUTTER_ON_MACOS)
        {
            var _modifierNotPressed = !keyboard_check_pressed(92) && !keyboard_check_pressed(vk_alt) && !keyboard_check_pressed(vk_shift);
        }
        else
        {
            var _modifierNotPressed = !keyboard_check_pressed(vk_control) && !keyboard_check_pressed(vk_alt) && !keyboard_check_pressed(vk_shift);
        }
        
        if (_modifierNotPressed && keyboard_check_pressed(vk_anykey))
        {
            var _mapping = keyboard_lastkey;
            if (_mapping == 0)
            {
                return;
            }
            
            var _key = __CutterStructFindName(__keyboardMappings, _mapping);
            
            if (_key == -1) 
            {
                return;
            }
            
            _bind += _key;
            
            __lastBind = _bind;
        }
        
        if (!__detectionEnabled)
        {
            return;
        }
        
        // Do global shortcut first
        var _shortcut = __CutterStructFindNameFromBind(__shortcutContexts[$ "global"], _bind);
        
        if (_shortcut != -1)
        {
            __CutterTrace($"Global shortcut triggered: {_shortcut}");
            
            __shortcutContexts[$ "global"][$ _shortcut].callback();
        }
        
        // Do current context next
        if (__currentContext != undefined)
        {
            if (!variable_struct_exists(__shortcutContexts, __currentContext))
            {
                return;
            }
            
            var _shortcut = __CutterStructFindNameFromBind(__shortcutContexts[$ __currentContext], _bind);
            
            if (_shortcut == -1)
            {
                return;
            }
            
            __CutterTrace($"Context {__currentContext} shortcut triggered: {_shortcut}");
            
            __shortcutContexts[$ __currentContext][$ _shortcut].callback();
        }
    }
}