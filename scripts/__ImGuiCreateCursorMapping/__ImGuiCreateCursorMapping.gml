// Feather disable all

/**
 * @function __imgui_create_cursor_mapping
 * @context ImGM
 * @desc Initialize the mapping array for GM cursors <-> ImGui cursors
 *
 */
function __ImGuiCreateCursorMapping() {
    var arr = array_create(ImGuiMouseCursor.NotAllowed + 1, cr_none);
    arr[@ ImGuiMouseCursor.None + 1] = cr_none;
    arr[@ ImGuiMouseCursor.Arrow + 1] = cr_default;
    arr[@ ImGuiMouseCursor.TextInput + 1] = cr_beam;
    arr[@ ImGuiMouseCursor.ResizeAll + 1] = cr_size_all;
    arr[@ ImGuiMouseCursor.ResizeNS + 1] = cr_size_ns;
    arr[@ ImGuiMouseCursor.ResizeEW + 1] = cr_size_we;
    arr[@ ImGuiMouseCursor.ResizeNESW + 1] = cr_size_nesw;
    arr[@ ImGuiMouseCursor.ResizeNWSE + 1] = cr_size_nwse;
    arr[@ ImGuiMouseCursor.Hand + 1] = cr_handpoint;
    arr[@ ImGuiMouseCursor.NotAllowed + 1] = cr_default;
    return arr;
}