function ShortcutController()
{
	if (keyboard_check(vk_control))
	{
		if (ENVIRONMENT.currentEnvironment == 0)
		{
			for (var i = 0; i < array_length(PROJECT.currentModel.layers); i++)
			{
				if (keyboard_check(vk_shift))
				{
					if (i < 18 && keyboard_check_pressed(ord(string(i - 8))))
					{
						if (keyboard_check(vk_alt))
						{
							ENVIRONMENT.displayLayers = array_create(array_length(PROJECT.currentModel.layers), false);
							ENVIRONMENT.displayLayers[i] = true;
						}
						else
						{
							ENVIRONMENT.displayLayers[i] = !ENVIRONMENT.displayLayers[i];
						}
						RENDERER.flush();
						PROJECT.currentModel.pushToRenderQueue(ENVIRONMENT.displayLayers, RENDERER, ENVIRONMENT.hideDisabledMeshes);
						break;
					}
				}
				else
				{
					if (i < 9 && keyboard_check_pressed(ord(string(i + 1))))
					{
						if (keyboard_check(vk_alt))
						{
							ENVIRONMENT.displayLayers = array_create(array_length(PROJECT.currentModel.layers), false);
							ENVIRONMENT.displayLayers[i] = true;
						}
						else
						{
							ENVIRONMENT.displayLayers[i] = !ENVIRONMENT.displayLayers[i];
						}
						RENDERER.flush();
						PROJECT.currentModel.pushToRenderQueue(ENVIRONMENT.displayLayers, RENDERER, ENVIRONMENT.hideDisabledMeshes);
						break;
					}
				}
			}
		}
	}
}

#macro MAPPINGS global.__mappings__
MAPPINGS = {
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
variable_struct_set(MAPPINGS, string("0"), ord("0"));
variable_struct_set(MAPPINGS, string("1"), ord("1"));
variable_struct_set(MAPPINGS, string("2"), ord("2"));
variable_struct_set(MAPPINGS, string("3"), ord("3"));
variable_struct_set(MAPPINGS, string("4"), ord("4"));
variable_struct_set(MAPPINGS, string("5"), ord("5"));
variable_struct_set(MAPPINGS, string("6"), ord("6"));
variable_struct_set(MAPPINGS, string("7"), ord("7"));
variable_struct_set(MAPPINGS, string("8"), ord("8"));
variable_struct_set(MAPPINGS, string("9"), ord("9"));

function ShortcutManager() constructor
{
	shortcuts = {  };
	
	static add = function(name, bind, func)
	{
		struct = {
			name,
			bind,
			func,
		};
		
		variable_struct_set(shortcuts, name, struct);
	}
	
	static rebind = function(name, bind)
	{
		if (variable_struct_exists(shortcuts, name)) shortcuts[$ name].bind = bind;
	}
	
	static clear = function()
	{
		shortcuts = {  };
	}
	
	static step = function()
	{
		// Empty Bind String
		var bind = "";
		
		// Add Control
		if (keyboard_check(vk_control)) bind += "Ctrl+";
		
		// Add Alt
		if (keyboard_check(vk_alt)) bind += "Alt+";
		
		// Add Shift
		if (keyboard_check(vk_shift)) bind += "Shift+";
		
		// Check For Function Key
		if (!keyboard_check_pressed(vk_control) && !keyboard_check_pressed(vk_alt) && !keyboard_check_pressed(vk_shift) && keyboard_check_pressed(vk_anykey))
		{
			// Get The Key
			var key = variable_struct_find_name(MAPPINGS, keyboard_key);
			
			// If the key is null we return null
			if (key == -1) return -1;
			
			// Add to Bind
			bind += key;
			
			// Find shortcut
			var shortcut = variable_struct_find_name_from_bind(shortcuts, bind);
			
			// Error Check
			if (shortcut == -1) return -1;
			
			// Trigger the bind
			if (variable_struct_exists(shortcuts, shortcut))
			{
				// Debug Output
				show_debug_message($"Shortcut triggered: {shortcut}");
				
				// Trigger Function
				shortcuts[$ shortcut].func();
			}
		}
	}
	
	static getBind = function()
	{
		// Empty Bind String
		var bind = "";
		
		// Add Control
		if (keyboard_check(vk_control)) bind += "Ctrl+";
		
		// Add Alt
		if (keyboard_check(vk_alt)) bind += "Alt+";
		
		// Add Shift
		if (keyboard_check(vk_shift)) bind += "Shift+";
		
		// Check For Function Key
		if (!keyboard_check_pressed(vk_control) && !keyboard_check_pressed(vk_alt) && !keyboard_check_pressed(vk_shift) && keyboard_check_pressed(vk_anykey))
		{
			// Get The Key
			var key = variable_struct_find_name(MAPPINGS, keyboard_key);
			
			// If the key is null we return null
			if (key == -1) return -1;
			
			// Add to Bind
			bind += key;
			
			// Return The New Bind
			return bind;
		}
		
		// Return -1 Otherwise
		return -1;
	}
}

function variable_struct_find_name(struct, value)
{
	var names = variable_struct_get_names(struct);
	
	for (var i = 0; i < array_length(names); i++)
	{
	   if (struct[$ names[i]] == value) return names[i];
	}
	
	return -1;
}

function variable_struct_find_name_from_bind(struct, bind)
{
	var names = variable_struct_get_names(struct);
	
	for (var i = 0; i < array_length(names); i++)
	{
	   if (struct[$ names[i]].bind == bind) return names[i];
	}
	
	return -1;
}