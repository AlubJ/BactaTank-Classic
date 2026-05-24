// Feather disable all

/**
 * @function __imgui_create_input_mapping
 * @context ImGM
 * @desc Initialize the mapping array for GM virtual keys <-> ImGui keys
 *
 */
function __ImGuiCreateKeyboardMapping()
{
    var arr = array_create(ImGuiKey.KeysData_SIZE, -1);
    arr[@ ImGuiKey.None] = vk_nokey;
    arr[@ ImGuiKey.Enter] = vk_enter;
    arr[@ ImGuiKey.Escape] = vk_escape;
    arr[@ ImGuiKey.Space] = vk_space;
    arr[@ ImGuiKey.Backspace] = vk_backspace;
    arr[@ ImGuiKey.Tab] = vk_tab;
    arr[@ ImGuiKey.Pause] = vk_pause;
    arr[@ ImGuiKey.LeftArrow] = vk_left;
    arr[@ ImGuiKey.RightArrow] = vk_right;
    arr[@ ImGuiKey.UpArrow] = vk_up;
    arr[@ ImGuiKey.DownArrow] = vk_down;
    arr[@ ImGuiKey.Home] = vk_home;
    arr[@ ImGuiKey.End] = vk_end;
    arr[@ ImGuiKey.Delete] = vk_delete;
    arr[@ ImGuiKey.Insert] = vk_insert;
    arr[@ ImGuiKey.PageUp] = vk_pageup;
    arr[@ ImGuiKey.PageDown] = vk_pagedown;
    arr[@ ImGuiKey.F1] = vk_f1;
    arr[@ ImGuiKey.F2] = vk_f2;
    arr[@ ImGuiKey.F3] = vk_f3;
    arr[@ ImGuiKey.F4] = vk_f4;
    arr[@ ImGuiKey.F5] = vk_f5;
    arr[@ ImGuiKey.F6] = vk_f6;
    arr[@ ImGuiKey.F7] = vk_f7;
    arr[@ ImGuiKey.F8] = vk_f8;
    arr[@ ImGuiKey.F9] = vk_f9;
    arr[@ ImGuiKey.F10] = vk_f10;
    arr[@ ImGuiKey.F11] = vk_f11;
    arr[@ ImGuiKey.F12] = vk_f12;
    arr[@ ImGuiKey.Keypad0] = vk_numpad0;
    arr[@ ImGuiKey.Keypad1] = vk_numpad1;
    arr[@ ImGuiKey.Keypad2] = vk_numpad2;
    arr[@ ImGuiKey.Keypad3] = vk_numpad3;
    arr[@ ImGuiKey.Keypad4] = vk_numpad4;
    arr[@ ImGuiKey.Keypad5] = vk_numpad5;
    arr[@ ImGuiKey.Keypad6] = vk_numpad6;
    arr[@ ImGuiKey.Keypad7] = vk_numpad7;
    arr[@ ImGuiKey.Keypad8] = vk_numpad8;
    arr[@ ImGuiKey.Keypad9] = vk_numpad9;
    arr[@ ImGuiKey.KeypadDivide] = vk_divide;
    arr[@ ImGuiKey.KeypadMultiply] = vk_multiply;
    arr[@ ImGuiKey.KeypadSubtract] = vk_subtract;
    arr[@ ImGuiKey.KeypadAdd] = vk_add;
    arr[@ ImGuiKey.KeypadDecimal] = vk_decimal;
    arr[@ ImGuiKey.LeftShift] = vk_lshift;
    arr[@ ImGuiKey.LeftCtrl] = vk_lcontrol;
    arr[@ ImGuiKey.LeftAlt] = vk_lalt;
    arr[@ ImGuiKey.RightShift] = vk_rshift;
    arr[@ ImGuiKey.RightCtrl] = vk_rcontrol;
    arr[@ ImGuiKey.RightAlt] = vk_ralt;
    arr[@ ImGuiKey.ImGuiKey_1] = ord("1");
    arr[@ ImGuiKey.ImGuiKey_2] = ord("2");
    arr[@ ImGuiKey.ImGuiKey_3] = ord("3");
    arr[@ ImGuiKey.ImGuiKey_4] = ord("4");
    arr[@ ImGuiKey.ImGuiKey_5] = ord("5");
    arr[@ ImGuiKey.ImGuiKey_6] = ord("6");
    arr[@ ImGuiKey.ImGuiKey_7] = ord("7");
    arr[@ ImGuiKey.ImGuiKey_8] = ord("8");
    arr[@ ImGuiKey.ImGuiKey_9] = ord("9");
    arr[@ ImGuiKey.ImGuiKey_0] = ord("10");
    arr[@ ImGuiKey.A] = ord("A");
    arr[@ ImGuiKey.B] = ord("B");
    arr[@ ImGuiKey.C] = ord("C");
    arr[@ ImGuiKey.D] = ord("D");
    arr[@ ImGuiKey.E] = ord("E");
    arr[@ ImGuiKey.F] = ord("F");
    arr[@ ImGuiKey.G] = ord("G");
    arr[@ ImGuiKey.H] = ord("H");
    arr[@ ImGuiKey.I] = ord("I");
    arr[@ ImGuiKey.J] = ord("J");
    arr[@ ImGuiKey.K] = ord("K");
    arr[@ ImGuiKey.L] = ord("L");
    arr[@ ImGuiKey.M] = ord("M");
    arr[@ ImGuiKey.N] = ord("N");
    arr[@ ImGuiKey.O] = ord("O");
    arr[@ ImGuiKey.P] = ord("P");
    arr[@ ImGuiKey.Q] = ord("Q");
    arr[@ ImGuiKey.R] = ord("R");
    arr[@ ImGuiKey.S] = ord("S");
    arr[@ ImGuiKey.T] = ord("T");
    arr[@ ImGuiKey.U] = ord("U");
    arr[@ ImGuiKey.V] = ord("V");
    arr[@ ImGuiKey.W] = ord("W");
    arr[@ ImGuiKey.X] = ord("X");
    arr[@ ImGuiKey.Y] = ord("Y");
    arr[@ ImGuiKey.Z] = ord("Z");
    arr[@ ImGuiKey.GraveAccent] = 192;
    return arr;
}