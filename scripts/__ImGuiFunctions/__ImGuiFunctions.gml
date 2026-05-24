// Feather disable all

/**
	* @function ImGuiAcceptDragDropPayload
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* accept contents of a given type. If ImGuiDragDropFlags_AcceptBeforeDelivery is set you can peek into the payload before the mouse button is released.
	* @param {String} type
	* @param {Enum.ImGuiDragDropFlags} [flags=ImGuiDragDropFlags.None]
	* @return {Any|Undefined}
	*/
function ImGuiAcceptDragDropPayload(type, flags=ImGuiDragDropFlags.None) {
	return __imgui_accept_drag_drop_payload(type, flags);
}

/**
	* @function ImGuiAddFontDefault
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @return {Pointer|Undefined}
	*/
function ImGuiAddFontDefault() {
	return __imgui_add_font_default();
}

/**
	* @function ImGuiAddFontFromFileTTF
	* @context ImGui
	* @desc ImGui custom wrapper.
	*
	* glyph_ranges is a flat array of unicode start,end and a terminating zero value.
	* e.g. For Arabic: [$0600, $06FF, $0750, $077F, 0]
	* @param {String} file
	* @param {Real} size
	* @param {ImFontConfig} [font_cfg=undefined]
	* @param {Array<Real>} [glyph_ranges=undefined]
	* @return {Pointer|Undefined}
	*/
function ImGuiAddFontFromFileTTF(file, size, font_cfg=undefined, glyph_ranges=undefined) {
	return __imgui_add_font_from_file_TTF(file, size, font_cfg, glyph_ranges, array_length(glyph_ranges));
}

/**
	* @function ImGuiAlignTextToFramePadding
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* vertically align upcoming text baseline to FramePadding.y so that it will align properly to regularly framed items (call if you have text on a line before a framed item)
	* @return {Undefined}
	*/
function ImGuiAlignTextToFramePadding() {
	return __imgui_align_text_to_frame_padding();
}

/**
	* @function ImGuiArrowButton
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* square button with an arrow shape
	* @param {String} str_id
	* @param {Real} _dir
	* @return {Bool}
	*/
function ImGuiArrowButton(str_id, _dir) {
	return __imgui_arrow_button(str_id, _dir);
}

/**
	* @function ImGuiBegin
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {String} name
	* @param {Bool} [open=undefined]
	* @param {Enum.ImGuiWindowFlags} [flags=ImGuiWindowFlags.None]
	* @param {Enum.ImGuiReturnMask} [mask=ImGuiReturnMask.Return]
	* @return {Real}
	*/
function ImGuiBegin(name, open=undefined, flags=ImGuiWindowFlags.None, mask=ImGuiReturnMask.Return) {
	return __imgui_begin(name, open, flags, mask);
}

/**
	* @function ImGuiBeginChild
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {String} str_id
	* @param {Real} [width=0]
	* @param {Real} [height=0]
	* @param {Enum.ImGuiChildFlags} [child_flags=ImGuiChildFlags.None]
	* @param {Enum.ImGuiWindowFlags} [window_flags=ImGuiWindowFlags.None]
	* @return {Bool}
	*/
function ImGuiBeginChild(str_id, width=0, height=0, child_flags=ImGuiChildFlags.None, window_flags=ImGuiWindowFlags.None) {
	return __imgui_begin_child(str_id, width, height, child_flags, window_flags);
}

/**
	* @function ImGuiBeginChildFrame
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Real} _id
	* @param {Real} [width=0]
	* @param {Real} [height=0]
	* @param {Enum.ImGuiWindowFlags} [flags=ImGuiWindowFlags.None]
	* @return {Bool}
	*/
function ImGuiBeginChildFrame(_id, width=0, height=0, flags=ImGuiWindowFlags.None) {
	return __imgui_begin_child_frame(_id, width, height, flags);
}

/**
	* @function ImGuiBeginCombo
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {String} label
	* @param {String} preview
	* @param {Real} flags
	* @return {Bool}
	*/
function ImGuiBeginCombo(label, preview, flags) {
	return __imgui_begin_combo(label, preview, flags);
}

/**
	* @function ImGuiBeginDisabled
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {Bool} [disabled=true]
	* @return {Undefined}
	*/
function ImGuiBeginDisabled(disabled=true) {
	return __imgui_begin_disabled(disabled);
}

/**
	* @function ImGuiBeginDragDropSource
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* call after submitting an item which may be dragged. when this return true, you can call SetDragDropPayload() + EndDragDropSource()
	* @param {Enum.ImGuiDragDropFlags} [flags=ImGuiDragDropFlags.None]
	* @return {Bool}
	*/
function ImGuiBeginDragDropSource(flags=ImGuiDragDropFlags.None) {
	return __imgui_begin_drag_drop_source(flags);
}

/**
	* @function ImGuiBeginDragDropTarget
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* call after submitting an item that may receive a payload. If this returns true, you can call AcceptDragDropPayload() + EndDragDropTarget()
	* @return {Bool}
	*/
function ImGuiBeginDragDropTarget() {
	return __imgui_begin_drag_drop_target();
}

/**
	* @function ImGuiBeginGroup
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* lock horizontal starting position
	* @return {Undefined}
	*/
function ImGuiBeginGroup() {
	return __imgui_begin_group();
}

/**
	* @function ImGuiBeginItemTooltip
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* begin/append a tooltip window if preceding item was hovered.
	* @return {Bool}
	*/
function ImGuiBeginItemTooltip() {
	return __imgui_begin_item_tooltip();
}

/**
	* @function ImGuiBeginListBox
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* open a framed scrolling region
	* @param {String} label
	* @param {Real} [width=0]
	* @param {Real} [height=0]
	* @return {Bool}
	*/
function ImGuiBeginListBox(label, width=0, height=0) {
	return __imgui_begin_list_box(label, width, height);
}

/**
	* @function ImGuiBeginMainMenuBar
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* create and append to a full screen menu-bar.
	* @return {Bool}
	*/
function ImGuiBeginMainMenuBar() {
	return __imgui_begin_main_menu_bar();
}

/**
	* @function ImGuiBeginMenu
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* create a sub-menu entry. only call EndMenu() if this returns true!
	* @param {String} label
	* @param {Bool} [enabled=true]
	* @return {Bool}
	*/
function ImGuiBeginMenu(label, enabled=true) {
	return __imgui_begin_menu(label, enabled);
}

/**
	* @function ImGuiBeginMenuBar
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* append to menu-bar of current window (requires ImGuiWindowFlags_MenuBar flag set on parent window).
	* @return {Bool}
	*/
function ImGuiBeginMenuBar() {
	return __imgui_begin_menu_bar();
}

/**
	* @function ImGuiBeginMultiSelect
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {ImGuiMultiSelectFlags} flags
	* @param {Real} size
	* @param {Real} items_count
	* @return {ImGuiMultiSelectIO}
	*/
function ImGuiBeginMultiSelect(flags, size, items_count) {
	return __imgui_begin_multi_select(flags, size, items_count);
}

/**
	* @function ImGuiBeginPopup
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* return true if the popup is open, and you can start outputting to it.
	* @param {String} str_id
	* @param {Enum.ImGuiWindowFlags} [flags=ImGuiWindowFlags.None]
	* @return {Bool}
	*/
function ImGuiBeginPopup(str_id, flags=ImGuiWindowFlags.None) {
	return __imgui_begin_popup(str_id, flags);
}

/**
	* @function ImGuiBeginPopupContextItem
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* open+begin popup when clicked on last item. Use str_id==NULL to associate the popup to previous item. If you want to use that on a non-interactive item such as Text() you need to pass in an explicit ID here. read comments in .cpp!
	* @param {String} [str_id=undefined]
	* @param {Enum.ImGuiPopupFlags} [flags=ImGuiPopupFlags.MouseButtonRight]
	* @return {Bool}
	*/
function ImGuiBeginPopupContextItem(str_id="undefined", flags=ImGuiPopupFlags.MouseButtonRight) {
	return __imgui_begin_popup_context_item(str_id, flags);
}

/**
	* @function ImGuiBeginPopupContextVoid
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* open+begin popup when clicked in void (where there are no windows).
	* @param {String} [str_id=undefined]
	* @param {Enum.ImGuiPopupFlags} [flags=ImGuiPopupFlags.MouseButtonRight]
	* @return {Bool}
	*/
function ImGuiBeginPopupContextVoid(str_id="undefined", flags=ImGuiPopupFlags.MouseButtonRight) {
	return __imgui_begin_popup_context_void(str_id, flags);
}

/**
	* @function ImGuiBeginPopupContextWindow
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* open+begin popup when clicked on current window.
	* @param {String} [str_id=undefined]
	* @param {Enum.ImGuiPopupFlags} [flags=ImGuiPopupFlags.MouseButtonRight]
	* @return {Bool}
	*/
function ImGuiBeginPopupContextWindow(str_id="undefined", flags=ImGuiPopupFlags.MouseButtonRight) {
	return __imgui_begin_popup_context_window(str_id, flags);
}

/**
	* @function ImGuiBeginPopupModal
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* return true if the modal is open, and you can start outputting to it.
	* @param {String} name
	* @param {Bool} [open=undefined]
	* @param {Enum.ImGuiWindowFlags} [flags=ImGuiWindowFlags.None]
	* @param {Enum.ImGuiReturnMask} [mask=ImGuiReturnMask.Return]
	* @return {Real}
	*/
function ImGuiBeginPopupModal(name, open=undefined, flags=ImGuiWindowFlags.None, mask=ImGuiReturnMask.Return) {
	return __imgui_begin_popup_modal(name, open, flags, mask);
}

/**
	* @function ImGuiBeginTabBar
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* create and append into a TabBar
	* @param {String} str_id
	* @param {Enum.ImGuiTabBarFlags} [flags=ImGuiTabBarFlags.None]
	* @return {Bool}
	*/
function ImGuiBeginTabBar(str_id, flags=ImGuiTabBarFlags.None) {
	return __imgui_begin_tab_bar(str_id, flags);
}

/**
	* @function ImGuiBeginTabItem
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* create a Tab. Returns true if the Tab is selected.
	* @param {String} label
	* @param {Bool} [open=undefined]
	* @param {Enum.ImGuiTabItemFlags} [flags=ImGuiTabItemFlags.None]
	* @param {Enum.ImGuiReturnMask} [mask=ImGuiReturnMask.Return]
	* @return {Real}
	*/
function ImGuiBeginTabItem(label, open=undefined, flags=ImGuiTabItemFlags.None, mask=ImGuiReturnMask.Return) {
	return __imgui_begin_tab_item(label, open, flags, mask);
}

/**
	* @function ImGuiBeginTable
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {String} str_id
	* @param {Real} column
	* @param {Enum.ImGuiTableFlags} [flags=ImGuiTableFlags.None]
	* @param {Real} [outer_width=0]
	* @param {Real} [outer_height=0]
	* @param {Real} [inner_width=0]
	* @return {Bool}
	*/
function ImGuiBeginTable(str_id, column, flags=ImGuiTableFlags.None, outer_width=0, outer_height=0, inner_width=0) {
	return __imgui_begin_table(str_id, column, flags, outer_width, outer_height, inner_width);
}

/**
	* @function ImGuiBeginTooltip
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* begin/append a tooltip window.
	* @return {Undefined}
	*/
function ImGuiBeginTooltip() {
	return __imgui_begin_tooltip();
}

/**
	* @function ImGuiBullet
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* draw a small circle + keep the cursor on the same line. advance cursor x position by GetTreeNodeToLabelSpacing(), same distance that TreeNode() uses
	* @return {Undefined}
	*/
function ImGuiBullet() {
	return __imgui_bullet();
}

/**
	* @function ImGuiBulletText
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {String} val
	* @return {Undefined}
	*/
function ImGuiBulletText(val) {
	return __imgui_bullet_text(val);
}

/**
	* @function ImGuiButton
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* button
	* @param {String} label
	* @param {Real} [width=0]
	* @param {Real} [height=0]
	* @return {Bool}
	*/
function ImGuiButton(label, width=0, height=0) {
	return __imgui_button(label, width, height);
}

/**
	* @function ImGuiCalcItemWidth
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* width of item given pushed settings and current cursor position. NOT necessarily the width of last item unlike most 'Item' functions.
	* @return {Real}
	*/
function ImGuiCalcItemWidth() {
	return __imgui_calc_item_width();
}

/**
	* @function ImGuiCalcTextHeight
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {String} text
	* @param {Bool} [hide_text_after_double_hash=false]
	* @param {Real} [wrap_width=-1]
	* @return {Real}
	*/
function ImGuiCalcTextHeight(text, hide_text_after_double_hash=false, wrap_width=-1) {
	return __imgui_calc_text_height(text, hide_text_after_double_hash, wrap_width);
}

/**
	* @function ImGuiCalcTextWidth
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {String} text
	* @param {Bool} [hide_text_after_double_hash=false]
	* @param {Real} [wrap_width=-1]
	* @return {Real}
	*/
function ImGuiCalcTextWidth(text, hide_text_after_double_hash=false, wrap_width=-1) {
	return __imgui_calc_text_width(text, hide_text_after_double_hash, wrap_width);
}

/**
	* @function ImGuiCheckbox
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {String} label
	* @param {Bool} checked
	* @return {Bool}
	*/
function ImGuiCheckbox(label, checked) {
	return __imgui_checkbox(label, checked);
}

/**
	* @function ImGuiCheckboxFlags
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {String} label
	* @param {Real} flags
	* @param {Real} flags_value
	* @return {Real}
	*/
function ImGuiCheckboxFlags(label, flags, flags_value) {
	return __imgui_checkbox_flags(label, flags, flags_value);
}

/**
	* @function ImGuiClearIniSettings
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @return {Undefined}
	*/
function ImGuiClearIniSettings() {
	return __imgui_clear_ini_settings();
}

/**
	* @function ImGuiCloseCurrentPopup
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* manually close the popup we have begin-ed into.
	* @return {Undefined}
	*/
function ImGuiCloseCurrentPopup() {
	return __imgui_close_current_popup();
}

/**
	* @function ImGuiCollapsingHeader
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* if returning 'true' the header is open. doesn't indent nor push on ID stack. user doesn't have to call TreePop().
	* @param {String} label
	* @param {Bool} [_visible=undefined]
	* @param {Enum.ImGuiTreeNodeFlags} [flags=ImGuiTreeNodeFlags.None]
	* @param {Enum.ImGuiReturnMask} [mask=ImGuiReturnMask.Return]
	* @return {Real}
	*/
function ImGuiCollapsingHeader(label, _visible=undefined, flags=ImGuiTreeNodeFlags.None, mask=ImGuiReturnMask.Return) {
	return __imgui_collapsing_header(label, _visible, flags, mask);
}

/**
	* @function ImGuiColorButton
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* display a color square/button, hover for details, return true when pressed.
	* @param {String} desc_id
	* @param {Real} color
	* @param {Real} [alpha=1]
	* @param {Enum.ImGuiCol} [flags=ImGuiColorEditFlags.None]
	* @param {Real} [width=0]
	* @param {Real} [height=0]
	* @return {Bool}
	*/
function ImGuiColorButton(desc_id, color, alpha=1, flags=ImGuiColorEditFlags.None, width=0, height=0) {
	return __imgui_color_button(desc_id, color, alpha, flags, width, height);
}

/**
	* @function ImGuiColorEdit3
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {String} label
	* @param {Real} col
	* @param {Enum.ImGuiCol} [flags=ImGuiColorEditFlags.None]
	* @return {Real}
	*/
function ImGuiColorEdit3(label, col, flags=ImGuiColorEditFlags.None) {
	return __imgui_color_edit3(label, col, flags);
}

/**
	* @function ImGuiColorEdit4
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {String} label
	* @param {ImColor} col
	* @param {Enum.ImGuiCol} [flags=ImGuiColorEditFlags.None]
	* @return {Bool}
	*/
function ImGuiColorEdit4(label, col, flags=ImGuiColorEditFlags.None) {
	return __imgui_color_edit4(label, col, flags);
}

/**
	* @function ImGuiColorPicker3
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {String} label
	* @param {Real} col
	* @param {Enum.ImGuiCol} [flags=ImGuiColorEditFlags.None]
	* @return {Real}
	*/
function ImGuiColorPicker3(label, col, flags=ImGuiColorEditFlags.None) {
	return __imgui_color_picker3(label, col, flags);
}

/**
	* @function ImGuiColorPicker4
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {String} label
	* @param {ImColor} col
	* @param {Enum.ImGuiCol} [flags=ImGuiColorEditFlags.None]
	* @return {Bool}
	*/
function ImGuiColorPicker4(label, col, flags=ImGuiColorEditFlags.None) {
	return __imgui_color_picker4(label, col, flags);
}

/**
	* @function ImGuiColumns
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {Real} [count=1]
	* @param {String} [_id=]
	* @param {Bool} [border=true]
	* @return {Undefined}
	*/
function ImGuiColumns(count=1, _id="", border=true) {
	return __imgui_columns(count, _id, border);
}

/**
	* @function ImGuiCombo
	* @context ImGui
	* @desc ImGui function wrapper.
	* @return {undefined}
	*/
function ImGuiCombo() {
	return __imgui_combo();
}

/**
	* @function ImGuiConfigFlagsGet
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @return {Real}
	*/
function ImGuiConfigFlagsGet() {
	return __imgui_config_flags_get();
}

/**
	* @function ImGuiConfigFlagsSet
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Real} flags
	* @return {undefined}
	*/
function ImGuiConfigFlagsSet(flags) {
	return __imgui_config_flags_set(flags);
}

/**
	* @function ImGuiConfigFlagToggle
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Real} flag
	* @return {Bool}
	*/
function ImGuiConfigFlagToggle(flag) {
	return __imgui_config_flag_toggle(flag);
}

/**
	* @function ImGuiCreateContext
	* @context ImGui
	* @desc ImGui function wrapper.
	* @return {Pointer}
	*/
function ImGuiCreateContext() {
	return __imgui_create_context();
}

/**
	* @function ImGuiCreateMultiSelectBasicStorage
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Struct} yystruct
	* @return {Pointer}
	*/
function ImGuiCreateMultiSelectBasicStorage(yystruct) {
	return __imgui_create_multi_select_basic_storage(yystruct);
}

/**
	* @function ImGuiDestroyContext
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* NULL = destroy current context
	* @param {Pointer} ctx
	* @return {Undefined}
	*/
function ImGuiDestroyContext(ctx) {
	return __imgui_destroy_context(ctx);
}

/**
	* @function ImGuiDestroyMultiSelectBasicStorage
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Pointer} storage_ptr
	* @return {Undefined}
	*/
function ImGuiDestroyMultiSelectBasicStorage(storage_ptr) {
	return __imgui_destroy_multi_select_basic_storage(storage_ptr);
}

/**
	* @function ImGuiDockBuilderAddNode
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Real} [node_id=0]
	* @param {Enum.ImGuiDockNodeFlags} [flags=ImGuiDockNodeFlags.None]
	* @return {Real}
	*/
function ImGuiDockBuilderAddNode(node_id=0, flags=ImGuiDockNodeFlags.None) {
	return __imgui_dock_builder_add_node(node_id, flags);
}

/**
	* @function ImGuiDockBuilderCopyDockSpace
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Real} src_dockspace_id
	* @param {Real} dst_dockspace_id
	* @param {Any} window_remap_pairs
	* @return {Undefined}
	*/
function ImGuiDockBuilderCopyDockSpace(src_dockspace_id, dst_dockspace_id, window_remap_pairs) {
	return __imgui_dock_builder_copy_dock_space(src_dockspace_id, dst_dockspace_id, window_remap_pairs);
}

/**
	* @function ImGuiDockBuilderCopyNode
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Real} src_node_id
	* @param {Real} dst_node_id
	* @param {Any} node_remap_pairs
	* @return {undefined}
	*/
function ImGuiDockBuilderCopyNode(src_node_id, dst_node_id, node_remap_pairs) {
	return __imgui_dock_builder_copy_node(src_node_id, dst_node_id, node_remap_pairs);
}

/**
	* @function ImGuiDockBuilderCopyWindowSettings
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {String} src_name
	* @param {String} dst_name
	* @return {Undefined}
	*/
function ImGuiDockBuilderCopyWindowSettings(src_name, dst_name) {
	return __imgui_dock_builder_copy_window_settings(src_name, dst_name);
}

/**
	* @function ImGuiDockBuilderDockWindow
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {String} window_name
	* @param {Real} node_id
	* @return {Undefined}
	*/
function ImGuiDockBuilderDockWindow(window_name, node_id) {
	return __imgui_dock_builder_dock_window(window_name, node_id);
}

/**
	* @function ImGuiDockBuilderFinish
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Real} node_id
	* @return {Undefined}
	*/
function ImGuiDockBuilderFinish(node_id) {
	return __imgui_dock_builder_finish(node_id);
}

/**
	* @function ImGuiDockBuilderGetCentralNode
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Real} node_id
	* @return {Pointer}
	*/
function ImGuiDockBuilderGetCentralNode(node_id) {
	return __imgui_dock_builder_get_central_node(node_id);
}

/**
	* @function ImGuiDockBuilderGetNode
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Real} node_id
	* @return {Pointer}
	*/
function ImGuiDockBuilderGetNode(node_id) {
	return __imgui_dock_builder_get_node(node_id);
}

/**
	* @function ImGuiDockBuilderRemoveNode
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Real} node_id
	* @return {Undefined}
	*/
function ImGuiDockBuilderRemoveNode(node_id) {
	return __imgui_dock_builder_remove_node(node_id);
}

/**
	* @function ImGuiDockBuilderRemoveNodeChildNodes
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Real} node_id
	* @return {Undefined}
	*/
function ImGuiDockBuilderRemoveNodeChildNodes(node_id) {
	return __imgui_dock_builder_remove_node_child_nodes(node_id);
}

/**
	* @function ImGuiDockBuilderRemoveNodeDockedWindows
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Real} node_id
	* @param {Bool} [clear_settings_refs=true]
	* @return {Undefined}
	*/
function ImGuiDockBuilderRemoveNodeDockedWindows(node_id, clear_settings_refs=true) {
	return __imgui_dock_builder_remove_node_docked_windows(node_id, clear_settings_refs);
}

/**
	* @function ImGuiDockBuilderSetNodePos
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Real} node_id
	* @param {Real} _x
	* @param {Real} _y
	* @return {Undefined}
	*/
function ImGuiDockBuilderSetNodePos(node_id, _x, _y) {
	return __imgui_dock_builder_set_node_pos(node_id, _x, _y);
}

/**
	* @function ImGuiDockBuilderSetNodeSize
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Real} node_id
	* @param {Real} width
	* @param {Real} height
	* @return {Undefined}
	*/
function ImGuiDockBuilderSetNodeSize(node_id, width, height) {
	return __imgui_dock_builder_set_node_size(node_id, width, height);
}

/**
	* @function ImGuiDockBuilderSplitNode
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Real} node_id
	* @param {Real} split_dir
	* @param {Real} size_ratio_for_node_at_dir
	* @return {Array<ImGuiID>}
	*/
function ImGuiDockBuilderSplitNode(node_id, split_dir, size_ratio_for_node_at_dir) {
	return __imgui_dock_builder_split_node(node_id, split_dir, size_ratio_for_node_at_dir);
}

/**
	* @function ImGuiDockSpace
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {Real} _id
	* @param {Real} [width=0]
	* @param {Real} [height=0]
	* @param {ImGuiDockNodeFlags} [flags=ImGuiDockNodeFlags.None]
	* @param {ImGuiWindowClass} [window_class=undefined]
	* @return {Real}
	*/
function ImGuiDockSpace(_id, width=0, height=0, flags=ImGuiDockNodeFlags.None, window_class=undefined) {
	return __imgui_dock_space(_id, width, height, flags, window_class);
}

/**
	* @function ImGuiDockSpaceOverViewport
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {Any} [dockspace_id=0]
	* @param {Real} [viewport_id=0]
	* @param {Enum.ImGuiDockNodeFlags} [flags=ImGuiDockNodeFlags.None]
	* @param {ImGuiWindowClass} [window_class=undefined]
	* @return {Real}
	*/
function ImGuiDockSpaceOverViewport(dockspace_id=0, viewport_id=0, flags=ImGuiDockNodeFlags.None, window_class=undefined) {
	return __imgui_dock_space_over_viewport(dockspace_id, viewport_id, flags, window_class);
}

/**
	* @function ImGuiDragFloat
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* If v_min >= v_max we have no bound
	* @param {String} label
	* @param {Real} v
	* @param {Real} [v_speed=1]
	* @param {Real} [v_min=0]
	* @param {Real} [v_max=0]
	* @param {String} [format=%.3f]
	* @param {Enum.ImGuiSliderFlags} [flags=ImGuiSliderFlags.None]
	* @return {Real}
	*/
function ImGuiDragFloat(label, v, v_speed=1, v_min=0, v_max=0, format="%.3f", flags=ImGuiSliderFlags.None) {
	return __imgui_drag_float(label, v, v_speed, v_min, v_max, format, flags);
}

/**
	* @function ImGuiDragFloat2
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {String} label
	* @param {Array} v
	* @param {Real} [v_speed=1]
	* @param {Real} [v_min=0]
	* @param {Real} [v_max=0]
	* @param {String} [format=%.3f]
	* @param {Enum.ImGuiSliderFlags} [flags=ImGuiSliderFlags.None]
	* @return {Bool}
	*/
function ImGuiDragFloat2(label, v, v_speed=1, v_min=0, v_max=0, format="%.3f", flags=ImGuiSliderFlags.None) {
	return __imgui_drag_float2(label, v, v_speed, v_min, v_max, format, flags);
}

/**
	* @function ImGuiDragFloat3
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {String} label
	* @param {Array} v
	* @param {Real} [v_speed=1]
	* @param {Real} [v_min=0]
	* @param {Real} [v_max=0]
	* @param {String} [format=%.3f]
	* @param {Enum.ImGuiSliderFlags} [flags=ImGuiSliderFlags.None]
	* @return {Bool}
	*/
function ImGuiDragFloat3(label, v, v_speed=1, v_min=0, v_max=0, format="%.3f", flags=ImGuiSliderFlags.None) {
	return __imgui_drag_float3(label, v, v_speed, v_min, v_max, format, flags);
}

/**
	* @function ImGuiDragFloat4
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {String} label
	* @param {Array} v
	* @param {Real} [v_speed=1]
	* @param {Real} [v_min=0]
	* @param {Real} [v_max=0]
	* @param {String} [format=%.3f]
	* @param {Enum.ImGuiSliderFlags} [flags=ImGuiSliderFlags.None]
	* @return {Bool}
	*/
function ImGuiDragFloat4(label, v, v_speed=1, v_min=0, v_max=0, format="%.3f", flags=ImGuiSliderFlags.None) {
	return __imgui_drag_float4(label, v, v_speed, v_min, v_max, format, flags);
}

/**
	* @function ImGuiDragFloatN
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {String} label
	* @param {Array} v
	* @param {Real} [v_speed=1]
	* @param {Real} [v_min=0]
	* @param {Real} [v_max=0]
	* @param {String} [format=%.3f]
	* @param {Enum.ImGuiSliderFlags} [flags=ImGuiSliderFlags.None]
	* @return {Bool}
	*/
function ImGuiDragFloatN(label, v, v_speed=1, v_min=0, v_max=0, format="%.3f", flags=ImGuiSliderFlags.None) {
	return __imgui_drag_float_n(label, v, v_speed, v_min, v_max, format, flags, array_length(v));
}

/**
	* @function ImGuiDragFloatRange2
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {String} label
	* @param {Array} v
	* @param {Real} [v_speed=1]
	* @param {Real} [v_min=0]
	* @param {Real} [v_max=0]
	* @param {String} [format_min=%.3f]
	* @param {String} [format_max=%.3f]
	* @param {Enum.ImGuiSliderFlags} [flags=ImGuiSliderFlags.None]
	* @return {Bool}
	*/
function ImGuiDragFloatRange2(label, v, v_speed=1, v_min=0, v_max=0, format_min="%.3f", format_max="%.3f", flags=ImGuiSliderFlags.None) {
	return __imgui_drag_float_range2(label, v, v_speed, v_min, v_max, format_min, format_max, flags);
}

/**
	* @function ImGuiDragInt
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* If v_min >= v_max we have no bound
	* @param {String} label
	* @param {Real} v
	* @param {Real} [v_speed=1]
	* @param {Real} [v_min=0]
	* @param {Real} [v_max=0]
	* @param {String} [format=%d]
	* @param {Enum.ImGuiSliderFlags} [flags=ImGuiSliderFlags.None]
	* @return {Real}
	*/
function ImGuiDragInt(label, v, v_speed=1, v_min=0, v_max=0, format="%d", flags=ImGuiSliderFlags.None) {
	return __imgui_drag_int(label, v, v_speed, v_min, v_max, format, flags);
}

/**
	* @function ImGuiDragInt2
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {String} label
	* @param {Array} v
	* @param {Real} [v_speed=1]
	* @param {Real} [v_min=0]
	* @param {Real} [v_max=0]
	* @param {String} [format=%d]
	* @param {Enum.ImGuiSliderFlags} [flags=ImGuiSliderFlags.None]
	* @return {Bool}
	*/
function ImGuiDragInt2(label, v, v_speed=1, v_min=0, v_max=0, format="%d", flags=ImGuiSliderFlags.None) {
	return __imgui_drag_int2(label, v, v_speed, v_min, v_max, format, flags);
}

/**
	* @function ImGuiDragInt3
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {String} label
	* @param {Array} v
	* @param {Real} [v_speed=1]
	* @param {Real} [v_min=0]
	* @param {Real} [v_max=0]
	* @param {String} [format=%d]
	* @param {Enum.ImGuiSliderFlags} [flags=ImGuiSliderFlags.None]
	* @return {Bool}
	*/
function ImGuiDragInt3(label, v, v_speed=1, v_min=0, v_max=0, format="%d", flags=ImGuiSliderFlags.None) {
	return __imgui_drag_int3(label, v, v_speed, v_min, v_max, format, flags);
}

/**
	* @function ImGuiDragInt4
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {String} label
	* @param {Array} v
	* @param {Real} [v_speed=1]
	* @param {Real} [v_min=0]
	* @param {Real} [v_max=0]
	* @param {String} [format=%d]
	* @param {Enum.ImGuiSliderFlags} [flags=ImGuiSliderFlags.None]
	* @return {Bool}
	*/
function ImGuiDragInt4(label, v, v_speed=1, v_min=0, v_max=0, format="%d", flags=ImGuiSliderFlags.None) {
	return __imgui_drag_int4(label, v, v_speed, v_min, v_max, format, flags);
}

/**
	* @function ImGuiDragIntN
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {String} label
	* @param {Array} v
	* @param {Real} [v_speed=1]
	* @param {Real} [v_min=0]
	* @param {Real} [v_max=0]
	* @param {String} [format=%d]
	* @param {Enum.ImGuiSliderFlags} [flags=ImGuiSliderFlags.None]
	* @return {Bool}
	*/
function ImGuiDragIntN(label, v, v_speed=1, v_min=0, v_max=0, format="%d", flags=ImGuiSliderFlags.None) {
	return __imgui_drag_int_n(label, v, v_speed, v_min, v_max, format, flags, array_length(v));
}

/**
	* @function ImGuiDragIntRange2
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {String} label
	* @param {Array} v
	* @param {Real} v_current_max
	* @param {Real} [v_speed=1]
	* @param {Real} [v_min=0]
	* @param {Real} [v_max=0]
	* @param {String} [format_max=%d]
	* @param {Enum.ImGuiSliderFlags} [flags=ImGuiSliderFlags.None]
	* @return {Bool}
	*/
function ImGuiDragIntRange2(label, v, v_current_max, v_speed=1, v_min=0, v_max=0, format_max="%d", flags=ImGuiSliderFlags.None) {
	return __imgui_drag_int_range2(label, v, v_current_max, v_speed, v_min, v_max, format_max, flags);
}

/**
	* @function ImGuiDrawListAddBezierCubic
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Pointer} list
	* @param {Real} x1
	* @param {Real} y1
	* @param {Real} x2
	* @param {Real} y2
	* @param {Real} x3
	* @param {Real} y3
	* @param {Real} x4
	* @param {Real} y4
	* @param {Real} col
	* @param {Real} thickness
	* @param {Real} [num_segments=0]
	* @return {Undefined}
	*/
function ImGuiDrawListAddBezierCubic(list, x1, y1, x2, y2, x3, y3, x4, y4, col, thickness, num_segments=0) {
	return __imgui_drawlist_add_bezier_cubic(list, x1, y1, x2, y2, x3, y3, x4, y4, col, thickness, num_segments);
}

/**
	* @function ImGuiDrawListAddBezierQuadratic
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Pointer} list
	* @param {Real} x1
	* @param {Real} y1
	* @param {Real} x2
	* @param {Real} y2
	* @param {Real} x3
	* @param {Real} y3
	* @param {Real} col
	* @param {Real} thickness
	* @param {Real} [num_segments=0]
	* @return {Undefined}
	*/
function ImGuiDrawListAddBezierQuadratic(list, x1, y1, x2, y2, x3, y3, col, thickness, num_segments=0) {
	return __imgui_drawlist_add_bezier_quadratic(list, x1, y1, x2, y2, x3, y3, col, thickness, num_segments);
}

/**
	* @function ImGuiDrawListAddCircle
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Pointer} list
	* @param {Real} _x
	* @param {Real} _y
	* @param {Real} radius
	* @param {Real} col
	* @param {Real} [num_segments=0]
	* @param {Real} [thickness=1]
	* @return {Undefined}
	*/
function ImGuiDrawListAddCircle(list, _x, _y, radius, col, num_segments=0, thickness=1) {
	return __imgui_drawlist_add_circle(list, _x, _y, radius, col, num_segments, thickness);
}

/**
	* @function ImGuiDrawListAddCircleFilled
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Pointer} list
	* @param {Real} _x
	* @param {Real} _y
	* @param {Real} radius
	* @param {Real} col
	* @param {Real} [num_segments=0]
	* @return {Undefined}
	*/
function ImGuiDrawListAddCircleFilled(list, _x, _y, radius, col, num_segments=0) {
	return __imgui_drawlist_add_circle_filled(list, _x, _y, radius, col, num_segments);
}

/**
	* @function ImGuiDrawListAddConvexPolyFilled
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Pointer} list
	* @param {Array<Real>} positions
	* @param {Real} col
	* @return {Undefined}
	*/
function ImGuiDrawListAddConvexPolyFilled(list, positions, col) {
	return __imgui_drawlist_add_convex_poly_filled(list, positions, col, array_length(positions));
}

/**
	* @function ImGuiDrawListAddImage
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Pointer} list
	* @param {Real} sprite
	* @param {Real} subimg
	* @param {Real} x1
	* @param {Real} y1
	* @param {Real} x2
	* @param {Real} y2
	* @param {Real} [col=c_white]
	* @return {Undefined}
	*/
function ImGuiDrawListAddImage(list, sprite, subimg, x1, y1, x2, y2, col=c_white) {
	return __imgui_drawlist_add_image(list, sprite, subimg, x1, y1, x2, y2, col, sprite_get_uvs(sprite, subimg));
}

/**
	* @function ImGuiDrawListAddImageRounded
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Pointer} list
	* @param {Real} sprite
	* @param {Real} subimg
	* @param {Real} x1
	* @param {Real} y1
	* @param {Real} x2
	* @param {Real} y2
	* @param {Real} col
	* @param {Real} rounding
	* @param {Real} flags
	* @return {Undefined}
	*/
function ImGuiDrawListAddImageRounded(list, sprite, subimg, x1, y1, x2, y2, col, rounding, flags) {
	return __imgui_drawlist_add_image_rounded(list, sprite, subimg, x1, y1, x2, y2, col, rounding, flags, sprite_get_uvs(sprite, subimg));
}

/**
	* @function ImGuiDrawListAddLine
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Pointer} list
	* @param {Real} x1
	* @param {Real} y1
	* @param {Real} x2
	* @param {Real} y2
	* @param {Real} col
	* @param {Real} [thickness=1]
	* @return {Undefined}
	*/
function ImGuiDrawListAddLine(list, x1, y1, x2, y2, col, thickness=1) {
	return __imgui_drawlist_add_line(list, x1, y1, x2, y2, col, thickness);
}

/**
	* @function ImGuiDrawListAddNgon
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Pointer} list
	* @param {Real} _x
	* @param {Real} _y
	* @param {Real} radius
	* @param {Real} col
	* @param {Real} [num_segments=0]
	* @param {Real} [thickness=1]
	* @return {Undefined}
	*/
function ImGuiDrawListAddNgon(list, _x, _y, radius, col, num_segments=0, thickness=1) {
	return __imgui_drawlist_add_ngon(list, _x, _y, radius, col, num_segments, thickness);
}

/**
	* @function ImGuiDrawListAddNgonFilled
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Pointer} list
	* @param {Real} _x
	* @param {Real} _y
	* @param {Real} radius
	* @param {Real} col
	* @param {Real} [num_segments=0]
	* @return {Undefined}
	*/
function ImGuiDrawListAddNgonFilled(list, _x, _y, radius, col, num_segments=0) {
	return __imgui_drawlist_add_ngon_filled(list, _x, _y, radius, col, num_segments);
}

/**
	* @function ImGuiDrawListAddPolyline
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Pointer} list
	* @param {Array<Real>} positions
	* @param {Real} col
	* @param {Enum.ImDrawFlags} flags
	* @param {Real} thickness
	* @return {Undefined}
	*/
function ImGuiDrawListAddPolyline(list, positions, col, flags, thickness) {
	return __imgui_drawlist_add_polyline(list, positions, col, flags, thickness, array_length(positions));
}

/**
	* @function ImGuiDrawListAddQuad
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Pointer} list
	* @param {Real} x1
	* @param {Real} y1
	* @param {Real} x2
	* @param {Real} y2
	* @param {Real} x3
	* @param {Real} y3
	* @param {Real} x4
	* @param {Real} y4
	* @param {Real} col
	* @param {Real} [thickness=1]
	* @return {Undefined}
	*/
function ImGuiDrawListAddQuad(list, x1, y1, x2, y2, x3, y3, x4, y4, col, thickness=1) {
	return __imgui_drawlist_add_quad(list, x1, y1, x2, y2, x3, y3, x4, y4, col, thickness);
}

/**
	* @function ImGuiDrawListAddQuadFilled
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Pointer} list
	* @param {Real} x1
	* @param {Real} y1
	* @param {Real} x2
	* @param {Real} y2
	* @param {Real} x3
	* @param {Real} y3
	* @param {Real} x4
	* @param {Real} y4
	* @param {Real} col
	* @return {Undefined}
	*/
function ImGuiDrawListAddQuadFilled(list, x1, y1, x2, y2, x3, y3, x4, y4, col) {
	return __imgui_drawlist_add_quad_filled(list, x1, y1, x2, y2, x3, y3, x4, y4, col);
}

/**
	* @function ImGuiDrawListAddRect
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Pointer} list
	* @param {Real} x1
	* @param {Real} y1
	* @param {Real} x2
	* @param {Real} y2
	* @param {Real} col
	* @param {Real} [rounding=0]
	* @param {Enum.ImDrawFlags} [flags=ImDrawFlags.None]
	* @param {Real} [thickness=1]
	* @return {Undefined}
	*/
function ImGuiDrawListAddRect(list, x1, y1, x2, y2, col, rounding=0, flags=ImDrawFlags.None, thickness=1) {
	return __imgui_drawlist_add_rect(list, x1, y1, x2, y2, col, rounding, flags, thickness);
}

/**
	* @function ImGuiDrawListAddRectFilled
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Pointer} list
	* @param {Real} x1
	* @param {Real} y1
	* @param {Real} x2
	* @param {Real} y2
	* @param {Real} col
	* @param {Real} [rounding=0]
	* @param {Enum.ImDrawFlags} [flags=ImDrawFlags.None]
	* @return {Undefined}
	*/
function ImGuiDrawListAddRectFilled(list, x1, y1, x2, y2, col, rounding=0, flags=ImDrawFlags.None) {
	return __imgui_drawlist_add_rect_filled(list, x1, y1, x2, y2, col, rounding, flags);
}

/**
	* @function ImGuiDrawListAddRectFilledMultiColor
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Pointer} list
	* @param {Real} x1
	* @param {Real} y1
	* @param {Real} x2
	* @param {Real} y2
	* @param {Real} col1
	* @param {Real} col2
	* @param {Real} col3
	* @param {Real} col4
	* @return {Undefined}
	*/
function ImGuiDrawListAddRectFilledMultiColor(list, x1, y1, x2, y2, col1, col2, col3, col4) {
	return __imgui_drawlist_add_rect_filled_multicolor(list, x1, y1, x2, y2, col1, col2, col3, col4);
}

/**
	* @function ImGuiDrawListAddText
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Pointer} list
	* @param {Real} _x
	* @param {Real} _y
	* @param {String} text
	* @param {Real} col
	* @return {Undefined}
	*/
function ImGuiDrawListAddText(list, _x, _y, text, col) {
	return __imgui_drawlist_add_text(list, _x, _y, text, col);
}

/**
	* @function ImGuiDrawListAddTextFont
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Pointer} list
	* @param {Real} _x
	* @param {Real} _y
	* @param {String} text
	* @param {Real} col
	* @param {Pointer} font
	* @param {Real} font_size
	* @param {Real} [wrap_width=0]
	* @return {Undefined}
	*/
function ImGuiDrawListAddTextFont(list, _x, _y, text, col, font, font_size, wrap_width=0) {
	return __imgui_drawlist_add_text_font(list, _x, _y, text, col, font, font_size, wrap_width);
}

/**
	* @function ImGuiDrawListAddTriangle
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Pointer} list
	* @param {Real} x1
	* @param {Real} y1
	* @param {Real} x2
	* @param {Real} y2
	* @param {Real} x3
	* @param {Real} y3
	* @param {Real} col
	* @param {Real} [thickness=1]
	* @return {Undefined}
	*/
function ImGuiDrawListAddTriangle(list, x1, y1, x2, y2, x3, y3, col, thickness=1) {
	return __imgui_drawlist_add_triangle(list, x1, y1, x2, y2, x3, y3, col, thickness);
}

/**
	* @function ImGuiDrawListAddTriangleFilled
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Pointer} list
	* @param {Real} x1
	* @param {Real} y1
	* @param {Real} x2
	* @param {Real} y2
	* @param {Real} x3
	* @param {Real} y3
	* @param {Real} col
	* @return {Undefined}
	*/
function ImGuiDrawListAddTriangleFilled(list, x1, y1, x2, y2, x3, y3, col) {
	return __imgui_drawlist_add_triangle_filled(list, x1, y1, x2, y2, x3, y3, col);
}

/**
	* @function ImGuiDrawListFlagsGet
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Pointer} list
	* @return {Real}
	*/
function ImGuiDrawListFlagsGet(list) {
	return __imgui_drawlist_flags_get(list);
}

/**
	* @function ImGuiDrawListFlagsSet
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Pointer} list
	* @param {Real} flags
	* @return {Undefined}
	*/
function ImGuiDrawListFlagsSet(list, flags) {
	return __imgui_drawlist_flags_set(list, flags);
}

/**
	* @function ImGuiDrawListFlagToggle
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Pointer} list
	* @param {Real} flag
	* @return {Bool}
	*/
function ImGuiDrawListFlagToggle(list, flag) {
	return __imgui_drawlist_flag_toggle(list, flag);
}

/**
	* @function ImGuiDrawListPathArcTo
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Pointer} list
	* @param {Real} _x
	* @param {Real} _y
	* @param {Real} radius
	* @param {Real} a_min
	* @param {Real} a_max
	* @param {Real} [num_segments=0]
	* @return {Undefined}
	*/
function ImGuiDrawListPathArcTo(list, _x, _y, radius, a_min, a_max, num_segments=0) {
	return __imgui_drawlist_path_arc_to(list, _x, _y, radius, a_min, a_max, num_segments);
}

/**
	* @function ImGuiDrawListPathArcToFast
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Pointer} list
	* @param {Real} _x
	* @param {Real} _y
	* @param {Real} radius
	* @param {Real} a_min_of_12
	* @param {Real} a_max_of_12
	* @return {Undefined}
	*/
function ImGuiDrawListPathArcToFast(list, _x, _y, radius, a_min_of_12, a_max_of_12) {
	return __imgui_drawlist_path_arc_to_fast(list, _x, _y, radius, a_min_of_12, a_max_of_12);
}

/**
	* @function ImGuiDrawListPathBezierCubicCurveTo
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Pointer} list
	* @param {Real} x2
	* @param {Real} y2
	* @param {Real} x3
	* @param {Real} y3
	* @param {Real} x4
	* @param {Real} y4
	* @param {Real} [num_segments=0]
	* @return {Undefined}
	*/
function ImGuiDrawListPathBezierCubicCurveTo(list, x2, y2, x3, y3, x4, y4, num_segments=0) {
	return __imgui_drawlist_path_bezier_cubic_curve_to(list, x2, y2, x3, y3, x4, y4, num_segments);
}

/**
	* @function ImGuiDrawListPathBezierQuadraticCurveTo
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Pointer} list
	* @param {Real} x2
	* @param {Real} y2
	* @param {Real} x3
	* @param {Real} y3
	* @param {Real} [num_segments=0]
	* @return {Undefined}
	*/
function ImGuiDrawListPathBezierQuadraticCurveTo(list, x2, y2, x3, y3, num_segments=0) {
	return __imgui_drawlist_path_bezier_quadratic_curve_to(list, x2, y2, x3, y3, num_segments);
}

/**
	* @function ImGuiDrawListPathClear
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Pointer} list
	* @return {Undefined}
	*/
function ImGuiDrawListPathClear(list) {
	return __imgui_drawlist_path_clear(list);
}

/**
	* @function ImGuiDrawListPathFillConvex
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Pointer} list
	* @param {Real} col
	* @return {Undefined}
	*/
function ImGuiDrawListPathFillConvex(list, col) {
	return __imgui_drawlist_path_fill_convex(list, col);
}

/**
	* @function ImGuiDrawListPathLineTo
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Pointer} list
	* @param {Real} _x
	* @param {Real} _y
	* @return {Undefined}
	*/
function ImGuiDrawListPathLineTo(list, _x, _y) {
	return __imgui_drawlist_path_line_to(list, _x, _y);
}

/**
	* @function ImGuiDrawListPathLineToMergeDuplicate
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Pointer} list
	* @param {Real} _x
	* @param {Real} _y
	* @return {Undefined}
	*/
function ImGuiDrawListPathLineToMergeDuplicate(list, _x, _y) {
	return __imgui_drawlist_path_line_to_merge_duplicate(list, _x, _y);
}

/**
	* @function ImGuiDrawListPathRect
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Pointer} list
	* @param {Real} x1
	* @param {Real} y1
	* @param {Real} x2
	* @param {Real} y2
	* @param {Real} [rounding=0]
	* @param {Enum.ImDrawFlags} [flags=ImDrawFlags.None]
	* @return {Undefined}
	*/
function ImGuiDrawListPathRect(list, x1, y1, x2, y2, rounding=0, flags=ImDrawFlags.None) {
	return __imgui_drawlist_path_rect(list, x1, y1, x2, y2, rounding, flags);
}

/**
	* @function ImGuiDrawListPathStroke
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Pointer} list
	* @param {Real} col
	* @param {Enum.ImDrawFlags} [flags=ImDrawFlags.None]
	* @param {Real} [thickness=1]
	* @return {Undefined}
	*/
function ImGuiDrawListPathStroke(list, col, flags=ImDrawFlags.None, thickness=1) {
	return __imgui_drawlist_path_stroke(list, col, flags, thickness);
}

/**
	* @function ImGuiDrawListPopClipRect
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Pointer} list
	* @return {Undefined}
	*/
function ImGuiDrawListPopClipRect(list) {
	return __imgui_drawlist_pop_clip_rect(list);
}

/**
	* @function ImGuiDrawListPopTextureID
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Pointer} list
	* @return {Undefined}
	*/
function ImGuiDrawListPopTextureID(list) {
	return __imgui_drawlist_pop_textureid(list);
}

/**
	* @function ImGuiDrawListPushClipRect
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Pointer} list
	* @param {Real} clip_min_x
	* @param {Real} clip_min_y
	* @param {Real} clip_max_x
	* @param {Real} clip_max_y
	* @param {Bool} intersect_with_current_clip_rect
	* @return {Undefined}
	*/
function ImGuiDrawListPushClipRect(list, clip_min_x, clip_min_y, clip_max_x, clip_max_y, intersect_with_current_clip_rect) {
	return __imgui_drawlist_push_clip_rect(list, clip_min_x, clip_min_y, clip_max_x, clip_max_y, intersect_with_current_clip_rect);
}

/**
	* @function ImGuiDrawlistPushClipRectFullscreen
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Pointer} list
	* @return {Undefined}
	*/
function ImGuiDrawlistPushClipRectFullscreen(list) {
	return __imgui_drawlist_push_clip_rect_fullscreen(list);
}

/**
	* @function ImGuiDrawListPushTextureID
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Pointer} list
	* @param {Real} sprite
	* @param {Real} subimg
	* @return {Undefined}
	*/
function ImGuiDrawListPushTextureID(list, sprite, subimg) {
	return __imgui_drawlist_push_textureid(list, sprite, subimg);
}

/**
	* @function ImGuiDummy
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* add a dummy item of given size. unlike InvisibleButton(), Dummy() won't take the mouse click or be navigable into.
	* @param {Real} width
	* @param {Real} height
	* @return {Undefined}
	*/
function ImGuiDummy(width, height) {
	return __imgui_dummy(width, height);
}

/**
	* @function ImGuiEnd
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* Child Windows
	* @return {Undefined}
	*/
function ImGuiEnd() {
	return __imgui_end();
}

/**
	* @function ImGuiEndChild
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* Windows Utilities
	* @return {Undefined}
	*/
function ImGuiEndChild() {
	return __imgui_end_child();
}

/**
	* @function ImGuiEndChildFrame
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @return {Undefined}
	*/
function ImGuiEndChildFrame() {
	return __imgui_end_child_frame();
}

/**
	* @function ImGuiEndCombo
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* only call EndCombo() if BeginCombo() returns true!
	* @return {Undefined}
	*/
function ImGuiEndCombo() {
	return __imgui_end_combo();
}

/**
	* @function ImGuiEndDisabled
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* Clipping
	* @return {Undefined}
	*/
function ImGuiEndDisabled() {
	return __imgui_end_disabled();
}

/**
	* @function ImGuiEndDragDropSource
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* only call EndDragDropSource() if BeginDragDropSource() returns true!
	* @return {Undefined}
	*/
function ImGuiEndDragDropSource() {
	return __imgui_end_drag_drop_source();
}

/**
	* @function ImGuiEndDragDropTarget
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* only call EndDragDropTarget() if BeginDragDropTarget() returns true!
	* @return {Undefined}
	*/
function ImGuiEndDragDropTarget() {
	return __imgui_end_drag_drop_target();
}

/**
	* @function ImGuiEndGroup
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* unlock horizontal starting position + capture the whole group bounding box into one "item" (so you can use IsItemHovered() or layout primitives such as SameLine() on whole group, etc.)
	* @return {Undefined}
	*/
function ImGuiEndGroup() {
	return __imgui_end_group();
}

/**
	* @function ImGuiEndListBox
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* only call EndListBox() if BeginListBox() returned true!
	* @return {Undefined}
	*/
function ImGuiEndListBox() {
	return __imgui_end_list_box();
}

/**
	* @function ImGuiEndMainMenuBar
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* only call EndMainMenuBar() if BeginMainMenuBar() returns true!
	* @return {Undefined}
	*/
function ImGuiEndMainMenuBar() {
	return __imgui_end_main_menu_bar();
}

/**
	* @function ImGuiEndMenu
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* only call EndMenu() if BeginMenu() returns true!
	* @return {Undefined}
	*/
function ImGuiEndMenu() {
	return __imgui_end_menu();
}

/**
	* @function ImGuiEndMenuBar
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* only call EndMenuBar() if BeginMenuBar() returns true!
	* @return {Undefined}
	*/
function ImGuiEndMenuBar() {
	return __imgui_end_menu_bar();
}

/**
	* @function ImGuiEndMultiSelect
	* @context ImGui
	* @desc ImGui function wrapper.
	* @return {ImGuiMultiSelectIO}
	*/
function ImGuiEndMultiSelect() {
	return __imgui_end_multi_select();
}

/**
	* @function ImGuiEndPopup
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* only call EndPopup() if BeginPopupXXX() returns true!
	* @return {Undefined}
	*/
function ImGuiEndPopup() {
	return __imgui_end_popup();
}

/**
	* @function ImGuiEndTabBar
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* only call EndTabBar() if BeginTabBar() returns true!
	* @return {Undefined}
	*/
function ImGuiEndTabBar() {
	return __imgui_end_tab_bar();
}

/**
	* @function ImGuiEndTabItem
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* only call EndTabItem() if BeginTabItem() returns true!
	* @return {Undefined}
	*/
function ImGuiEndTabItem() {
	return __imgui_end_tab_item();
}

/**
	* @function ImGuiEndTable
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* only call EndTable() if BeginTable() returns true!
	* @return {Undefined}
	*/
function ImGuiEndTable() {
	return __imgui_end_table();
}

/**
	* @function ImGuiEndTooltip
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* only call EndTooltip() if BeginTooltip()/BeginItemTooltip() returns true!
	* @return {Undefined}
	*/
function ImGuiEndTooltip() {
	return __imgui_end_tooltip();
}

/**
	* @function ImGuiFindViewportByID
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Real} _id
	* @return {ImGuiViewport}
	*/
function ImGuiFindViewportByID(_id) {
	return __imgui_find_viewport_by_id(_id);
}

/**
	* @function ImGuiFindViewportByPlatformHandle
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* this is a helper for backends. the type platform_handle is decided by the backend (e.g. HWND, MyWindow*, GLFWwindow* etc.)
	* @param {HWND} platform_handle
	* @return {ImGuiViewport}
	*/
function ImGuiFindViewportByPlatformHandle(platform_handle) {
	return __imgui_find_viewport_by_platform_handle(platform_handle);
}

/**
	* @function ImGuiGetBackgroundDrawList
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* get background draw list for the given viewport or viewport associated to the current window. this draw list will be the first rendering one. Useful to quickly draw shapes/text behind dear imgui contents.
	* @param {Pointer} [viewport=undefined]
	* @return {Pointer}
	*/
function ImGuiGetBackgroundDrawList(viewport=undefined) {
	return __imgui_get_background_draw_list(viewport);
}

/**
	* @function ImGuiGetColumnIndex
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* get current column index
	* @return {Real}
	*/
function ImGuiGetColumnIndex() {
	return __imgui_get_column_index();
}

/**
	* @function ImGuiGetColumnOffset
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* get position of column line (in pixels, from the left side of the contents region). pass -1 to use current column, otherwise 0..GetColumnsCount() inclusive. column 0 is typically 0.0f
	* @param {Real} [column_index=-1]
	* @return {Real}
	*/
function ImGuiGetColumnOffset(column_index=-1) {
	return __imgui_get_column_offset(column_index);
}

/**
	* @function ImGuiGetColumnsCount
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* Tab Bars, Tabs
	* @return {Real}
	*/
function ImGuiGetColumnsCount() {
	return __imgui_get_columns_count();
}

/**
	* @function ImGuiGetColumnWidth
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* get column width (in pixels). pass -1 to use current column
	* @param {Real} [column_index=-1]
	* @return {Real}
	*/
function ImGuiGetColumnWidth(column_index=-1) {
	return __imgui_get_column_width(column_index);
}

/**
	* @function ImGuiGetContentRegionAvailX
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @return {Real}
	*/
function ImGuiGetContentRegionAvailX() {
	return __imgui_get_content_region_avail_x();
}

/**
	* @function ImGuiGetContentRegionAvailY
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @return {Real}
	*/
function ImGuiGetContentRegionAvailY() {
	return __imgui_get_content_region_avail_y();
}

/**
	* @function ImGuiGetContentRegionMaxX
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @return {Real}
	*/
function ImGuiGetContentRegionMaxX() {
	return __imgui_get_content_region_max_x();
}

/**
	* @function ImGuiGetContentRegionMaxY
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @return {Real}
	*/
function ImGuiGetContentRegionMaxY() {
	return __imgui_get_content_region_max_y();
}

/**
	* @function ImGuiGetCurrentContext
	* @context ImGui
	* @desc ImGui function wrapper.
	* @return {Pointer}
	*/
function ImGuiGetCurrentContext() {
	return __imgui_get_current_context();
}

/**
	* @function ImGuiGetCursorPosX
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* [window-local] "
	* @return {Real}
	*/
function ImGuiGetCursorPosX() {
	return __imgui_get_cursor_pos_x();
}

/**
	* @function ImGuiGetCursorPosY
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* [window-local] "
	* @return {Real}
	*/
function ImGuiGetCursorPosY() {
	return __imgui_get_cursor_pos_y();
}

/**
	* @function ImGuiGetCursorScreenPosX
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @return {Real}
	*/
function ImGuiGetCursorScreenPosX() {
	return __imgui_get_cursor_screen_pos_x();
}

/**
	* @function ImGuiGetCursorScreenPosY
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @return {Real}
	*/
function ImGuiGetCursorScreenPosY() {
	return __imgui_get_cursor_screen_pos_y();
}

/**
	* @function ImGuiGetCursorStartPosX
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @return {Real}
	*/
function ImGuiGetCursorStartPosX() {
	return __imgui_get_cursor_start_pos_x();
}

/**
	* @function ImGuiGetCursorStartPosY
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @return {Real}
	*/
function ImGuiGetCursorStartPosY() {
	return __imgui_get_cursor_start_pos_y();
}

/**
	* @function ImGuiGetDragDropPayload
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* peek directly into the current payload from anywhere. returns NULL when drag and drop is finished or inactive. use ImGuiPayload::IsDataType() to test for the payload type.
	* @return {Any|Undefined}
	*/
function ImGuiGetDragDropPayload() {
	return __imgui_get_drag_drop_payload();
}

/**
	* @function ImGuiGetDragDropPayloadType
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @return {String|Undefined}
	*/
function ImGuiGetDragDropPayloadType() {
	return __imgui_get_payload_type();
}

/**
	* @function ImGuiGetFont
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* get current font
	* @return {Pointer}
	*/
function ImGuiGetFont() {
	return __imgui_get_font();
}

/**
	* @function ImGuiGetFontSize
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* get current scaled font size (= height in pixels). AFTER global scale factors applied. *IMPORTANT* DO NOT PASS THIS VALUE TO PushFont()! Use ImGui::GetStyle().FontSizeBase to get value before global scale factors.
	* @return {Real}
	*/
function ImGuiGetFontSize() {
	return __imgui_get_font_size();
}

/**
	* @function ImGuiGetForegroundDrawList
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* get foreground draw list for the given viewport or viewport associated to the current window. this draw list will be the top-most rendered one. Useful to quickly draw shapes/text over dear imgui contents.
	* @param {Pointer} [viewport=undefined]
	* @return {Pointer}
	*/
function ImGuiGetForegroundDrawList(viewport=undefined) {
	return __imgui_get_foreground_draw_list(viewport);
}

/**
	* @function ImGuiGetFrameCount
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* get global imgui frame count. incremented by 1 every frame.
	* @return {Real}
	*/
function ImGuiGetFrameCount() {
	return __imgui_get_frame_count();
}

/**
	* @function ImGuiGetFrameHeight
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* ~ FontSize + style.FramePadding.y * 2
	* @return {Real}
	*/
function ImGuiGetFrameHeight() {
	return __imgui_get_frame_height();
}

/**
	* @function ImGuiGetFrameHeightWithSpacing
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* ~ FontSize + style.FramePadding.y * 2 + style.ItemSpacing.y (distance in pixels between 2 consecutive lines of framed widgets)
	* @return {Real}
	*/
function ImGuiGetFrameHeightWithSpacing() {
	return __imgui_get_frame_height_with_spacing();
}

/**
	* @function ImGuiGetID
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {String} str_id
	* @return {Real}
	*/
function ImGuiGetID(str_id) {
	return __imgui_get_id(str_id);
}

/**
	* @function ImGuiGetItemID
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @return {Real}
	*/
function ImGuiGetItemID() {
	return __imgui_get_item_id();
}

/**
	* @function ImGuiGetItemRectMaxX
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @return {Real}
	*/
function ImGuiGetItemRectMaxX() {
	return __imgui_get_item_rect_max_x();
}

/**
	* @function ImGuiGetItemRectMaxY
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @return {Real}
	*/
function ImGuiGetItemRectMaxY() {
	return __imgui_get_item_rect_max_y();
}

/**
	* @function ImGuiGetItemRectMinX
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @return {Real}
	*/
function ImGuiGetItemRectMinX() {
	return __imgui_get_item_rect_min_x();
}

/**
	* @function ImGuiGetItemRectMinY
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @return {Real}
	*/
function ImGuiGetItemRectMinY() {
	return __imgui_get_item_rect_min_y();
}

/**
	* @function ImGuiGetItemRectSizeHeight
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @return {Real}
	*/
function ImGuiGetItemRectSizeHeight() {
	return __imgui_get_item_rect_size_height();
}

/**
	* @function ImGuiGetItemRectSizeWidth
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @return {Real}
	*/
function ImGuiGetItemRectSizeWidth() {
	return __imgui_get_item_rect_size_width();
}

/**
	* @function ImGuiGetKeyChordName
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {ImGuiKeyChord} key_chord
	* @return {String}
	*/
function ImGuiGetKeyChordName(key_chord) {
	return __imgui_get_key_chord_name(key_chord);
}

/**
	* @function ImGuiGetKeyName
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* [DEBUG] returns English name of the key. Those names are provided for debugging purpose and are not meant to be saved persistently nor compared.
	* @param {ImGuiKey} key
	* @return {String}
	*/
function ImGuiGetKeyName(key) {
	return __imgui_get_key_name(key);
}

/**
	* @function ImGuiGetKeyPressedAmount
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* uses provided repeat rate/delay. return a count, most often 0 or 1 but might be >1 if RepeatRate is small enough that DeltaTime > RepeatRate
	* @param {ImGuiKey} key
	* @param {Float} repeat_delay
	* @param {Float} rate
	* @return {Real}
	*/
function ImGuiGetKeyPressedAmount(key, repeat_delay, rate) {
	return __imgui_get_key_pressed_amount(key, repeat_delay, rate);
}

/**
	* @function ImGuiGetMainViewport
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* return primary/default viewport. This can never be NULL.
	* @return {Pointer}
	*/
function ImGuiGetMainViewport() {
	return __imgui_get_main_viewport();
}

/**
	* @function ImGuiGetMouseClickedCount
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* return the number of successive mouse-clicks at the time where a click happen (otherwise 0).
	* @param {ImGuiMouseButton} button
	* @return {Real}
	*/
function ImGuiGetMouseClickedCount(button) {
	return __imgui_get_mouse_clicked_count(button);
}

/**
	* @function ImGuiGetMouseDragDeltaX
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {ImGuiMouseButton} button
	* @param {Float} [lock_threshold=-1]
	* @return {Real}
	*/
function ImGuiGetMouseDragDeltaX(button, lock_threshold=-1) {
	return __imgui_get_mouse_drag_delta_x(button, lock_threshold);
}

/**
	* @function ImGuiGetMouseDragDeltaY
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {ImGuiMouseButton} button
	* @param {Float} [lock_threshold=-1]
	* @return {Real}
	*/
function ImGuiGetMouseDragDeltaY(button, lock_threshold=-1) {
	return __imgui_get_mouse_drag_delta_y(button, lock_threshold);
}

/**
	* @function ImGuiGetMousePosOnOpeningCurrentPopupX
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @return {Real}
	*/
function ImGuiGetMousePosOnOpeningCurrentPopupX() {
	return __imgui_get_mouse_pos_on_opening_current_popup_x();
}

/**
	* @function ImGuiGetMousePosOnOpeningCurrentPopupY
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @return {Real}
	*/
function ImGuiGetMousePosOnOpeningCurrentPopupY() {
	return __imgui_get_mouse_pos_on_opening_current_popup_y();
}

/**
	* @function ImGuiGetMousePosX
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @return {Real}
	*/
function ImGuiGetMousePosX() {
	return __imgui_get_mouse_pos_x();
}

/**
	* @function ImGuiGetMousePosY
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @return {Real}
	*/
function ImGuiGetMousePosY() {
	return __imgui_get_mouse_pos_y();
}

/**
	* @function ImGuiGetScrollMaxX
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* get maximum scrolling amount ~~ ContentSize.x - WindowSize.x - DecorationsSize.x
	* @return {Real}
	*/
function ImGuiGetScrollMaxX() {
	return __imgui_get_scroll_max_x();
}

/**
	* @function ImGuiGetScrollMaxY
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* get maximum scrolling amount ~~ ContentSize.y - WindowSize.y - DecorationsSize.y
	* @return {Real}
	*/
function ImGuiGetScrollMaxY() {
	return __imgui_get_scroll_max_y();
}

/**
	* @function ImGuiGetScrollX
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* get scrolling amount [0 .. GetScrollMaxX()]
	* @return {Real}
	*/
function ImGuiGetScrollX() {
	return __imgui_get_scroll_x();
}

/**
	* @function ImGuiGetScrollY
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* get scrolling amount [0 .. GetScrollMaxY()]
	* @return {Real}
	*/
function ImGuiGetScrollY() {
	return __imgui_get_scroll_y();
}

/**
	* @function ImGuiGetStyleColor
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Real} idx
	* @return {Real}
	*/
function ImGuiGetStyleColor(idx) {
	return __imgui_get_style_color(idx);
}

/**
	* @function ImGuiGetStyleColorName
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* get a string corresponding to the enum value (for display, saving, etc.).
	* @param {Real} idx
	* @return {String}
	*/
function ImGuiGetStyleColorName(idx) {
	return __imgui_get_style_color_name(idx);
}

/**
	* @function ImGuiGetTextLineHeight
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* ~ FontSize
	* @return {Real}
	*/
function ImGuiGetTextLineHeight() {
	return __imgui_get_text_line_height();
}

/**
	* @function ImGuiGetTextLineHeightWithSpacing
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* ~ FontSize + style.ItemSpacing.y (distance in pixels between 2 consecutive lines of text)
	* @return {Real}
	*/
function ImGuiGetTextLineHeightWithSpacing() {
	return __imgui_get_text_line_height_with_spacing();
}

/**
	* @function ImGuiGetTime
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* get global imgui time. incremented by io.DeltaTime every frame.
	* @return {Real}
	*/
function ImGuiGetTime() {
	return __imgui_get_time();
}

/**
	* @function ImGuiGetTreeNodeToLabelSpacing
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* horizontal distance preceding label when using TreeNode*() or Bullet() == (g.FontSize + style.FramePadding.x*2) for a regular unframed TreeNode
	* @return {Real}
	*/
function ImGuiGetTreeNodeToLabelSpacing() {
	return __imgui_get_tree_node_to_label_spacing();
}

/**
	* @function ImGuiGetVersion
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* get the compiled version string e.g. "1.80 WIP" (essentially the value for IMGUI_VERSION from the compiled version of imgui.cpp)
	* @return {String}
	*/
function ImGuiGetVersion() {
	return __imgui_get_version();
}

/**
	* @function ImGuiGetViewportID
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {ImGuiViewport} vp
	* @return {ImGuiID}
	*/
function ImGuiGetViewportID(vp) {
	return __imgui_get_viewport_id(vp);
}

/**
	* @function ImGuiGetWindowContentRegionMaxX
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @return {Real}
	*/
function ImGuiGetWindowContentRegionMaxX() {
	return __imgui_get_window_content_region_max_x();
}

/**
	* @function ImGuiGetWindowContentRegionMaxY
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @return {Real}
	*/
function ImGuiGetWindowContentRegionMaxY() {
	return __imgui_get_window_content_region_max_y();
}

/**
	* @function ImGuiGetWindowContentRegionMinX
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @return {Real}
	*/
function ImGuiGetWindowContentRegionMinX() {
	return __imgui_get_window_content_region_min_x();
}

/**
	* @function ImGuiGetWindowContentRegionMinY
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @return {Real}
	*/
function ImGuiGetWindowContentRegionMinY() {
	return __imgui_get_window_content_region_min_y();
}

/**
	* @function ImGuiGetWindowDockID
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @return {Real}
	*/
function ImGuiGetWindowDockID() {
	return __imgui_get_window_dock_id();
}

/**
	* @function ImGuiGetWindowDpiScale
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* get DPI scale currently associated to the current window's viewport.
	* @return {Real}
	*/
function ImGuiGetWindowDpiScale() {
	return __imgui_get_window_dpi_scale();
}

/**
	* @function ImGuiGetWindowDrawList
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* get draw list associated to the current window, to append your own drawing primitives
	* @return {Pointer}
	*/
function ImGuiGetWindowDrawList() {
	return __imgui_get_window_draw_list();
}

/**
	* @function ImGuiGetWindowHeight
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* get current window height (IT IS UNLIKELY YOU EVER NEED TO USE THIS). Shortcut for GetWindowSize().y.
	* @return {Real}
	*/
function ImGuiGetWindowHeight() {
	return __imgui_get_window_height();
}

/**
	* @function ImGuiGetWindowPosX
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @return {Real}
	*/
function ImGuiGetWindowPosX() {
	return __imgui_get_window_x();
}

/**
	* @function ImGuiGetWindowPosY
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @return {Real}
	*/
function ImGuiGetWindowPosY() {
	return __imgui_get_window_y();
}

/**
	* @function ImGuiGetWindowViewport
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* get viewport currently associated to the current window.
	* @return {Pointer}
	*/
function ImGuiGetWindowViewport() {
	return __imgui_get_window_viewport();
}

/**
	* @function ImGuiGetWindowWidth
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* get current window width (IT IS UNLIKELY YOU EVER NEED TO USE THIS). Shortcut for GetWindowSize().x.
	* @return {Real}
	*/
function ImGuiGetWindowWidth() {
	return __imgui_get_window_width();
}

/**
	* @function ImGuiImage
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {Real} sprite
	* @param {Real} subimg
	* @param {Real} [color=c_white]
	* @param {Real} [alpha=1]
	* @param {Real} [width=sprite_get_width⌊sprite⌉]
	* @param {Real} [height=sprite_get_height⌊sprite⌉]
	* @return {Undefined}
	*/
function ImGuiImage(sprite, subimg, color=c_white, alpha=1, width=sprite_get_width(sprite), height=sprite_get_height(sprite)) {
	return __imgui_image(sprite, subimg, color, alpha, width, height, sprite_get_uvs(sprite, subimg));
}

/**
	* @function ImGuiImageButton
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* Widgets: Combo Box (Dropdown)
	* @param {String} str_id
	* @param {Real} sprite
	* @param {Real} subimg
	* @param {Real} color
	* @param {Real} alpha
	* @param {Real} bg_color
	* @param {Real} bg_alpha
	* @param {Real} [width=sprite_get_width⌊sprite⌉]
	* @param {Real} [height=sprite_get_height⌊sprite⌉]
	* @return {Bool}
	*/
function ImGuiImageButton(str_id, sprite, subimg, color, alpha, bg_color, bg_alpha, width=sprite_get_width(sprite), height=sprite_get_height(sprite)) {
	return __imgui_image_button(str_id, sprite, subimg, color, alpha, bg_color, bg_alpha, width, height, sprite_get_uvs(sprite, subimg));
}

/**
	* @function ImGuiIndent
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* move content position toward the right, by indent_w, or style.IndentSpacing if indent_w <= 0
	* @param {Real} [indent_w=0]
	* @return {Undefined}
	*/
function ImGuiIndent(indent_w=0) {
	return __imgui_indent(indent_w);
}

/**
	* @function ImGuiIniFilename
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {String} [val=undefined]
	* @return {String}
	*/
function ImGuiIniFilename(val="undefined") {
	return __imgui_ini_filename(val);
}

/**
	* @function ImGuiInputDouble
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {String} label
	* @param {Real} v
	* @param {Real} [step=1]
	* @param {Real} [step_fast=5]
	* @param {String} [format=%.6f]
	* @param {Enum.ImGuiInputTextFlags} [flags=ImGuiInputTextFlags.None]
	* @return {Real}
	*/
function ImGuiInputDouble(label, v, step=1, step_fast=5, format="%.6f", flags=ImGuiInputTextFlags.None) {
	return __imgui_input_double(label, v, step, step_fast, format, flags);
}

/**
	* @function ImGuiInputFloat
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {String} label
	* @param {Real} v
	* @param {Real} [step=0.1]
	* @param {Real} [step_fast=0.25]
	* @param {String} [format=%.3f]
	* @param {Enum.ImGuiInputTextFlags} [flags=ImGuiInputTextFlags.None]
	* @return {Real}
	*/
function ImGuiInputFloat(label, v, step=0.1, step_fast=0.25, format="%.3f", flags=ImGuiInputTextFlags.None) {
	return __imgui_input_float(label, v, step, step_fast, format, flags);
}

/**
	* @function ImGuiInputFloat2
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {String} label
	* @param {Array} v
	* @param {Real} [step=0.1]
	* @param {Real} [step_fast=0.25]
	* @param {String} [format=%.3f]
	* @param {Enum.ImGuiInputTextFlags} [flags=ImGuiInputTextFlags.None]
	* @return {Bool}
	*/
function ImGuiInputFloat2(label, v, step=0.1, step_fast=0.25, format="%.3f", flags=ImGuiInputTextFlags.None) {
	return __imgui_input_float2(label, v, step, step_fast, format, flags);
}

/**
	* @function ImGuiInputFloat3
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {String} label
	* @param {Array} v
	* @param {Real} [step=0.1]
	* @param {Real} [step_fast=0.25]
	* @param {String} [format=%.3f]
	* @param {Enum.ImGuiInputTextFlags} [flags=ImGuiInputTextFlags.None]
	* @return {Bool}
	*/
function ImGuiInputFloat3(label, v, step=0.1, step_fast=0.25, format="%.3f", flags=ImGuiInputTextFlags.None) {
	return __imgui_input_float3(label, v, step, step_fast, format, flags);
}

/**
	* @function ImGuiInputFloat4
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {String} label
	* @param {Array} v
	* @param {Real} [step=0.1]
	* @param {Real} [step_fast=0.25]
	* @param {String} [format=%.3f]
	* @param {Enum.ImGuiInputTextFlags} [flags=ImGuiInputTextFlags.None]
	* @return {Bool}
	*/
function ImGuiInputFloat4(label, v, step=0.1, step_fast=0.25, format="%.3f", flags=ImGuiInputTextFlags.None) {
	return __imgui_input_float4(label, v, step, step_fast, format, flags);
}

/**
	* @function ImGuiInputFloatN
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {String} label
	* @param {Array} v
	* @param {Real} len
	* @param {Real} [step=0.1]
	* @param {Real} [step_fast=0.25]
	* @param {String} [format=%.3f]
	* @return {Bool}
	*/
function ImGuiInputFloatN(label, v, len, step=0.1, step_fast=0.25, format="%.3f") {
	return __imgui_input_float_n(label, v, len, step, step_fast, format, array_length(v));
}

/**
	* @function ImGuiInputInt
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {String} label
	* @param {Real} v
	* @param {Real} [step=1]
	* @param {Real} [step_fast=5]
	* @param {Enum.ImGuiInputTextFlags} [flags=ImGuiInputTextFlags.None]
	* @return {Real}
	*/
function ImGuiInputInt(label, v, step=1, step_fast=5, flags=ImGuiInputTextFlags.None) {
	return __imgui_input_int(label, v, step, step_fast, flags);
}

/**
	* @function ImGuiInputInt2
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {String} label
	* @param {Array} v
	* @param {Enum.ImGuiInputTextFlags} [flags=ImGuiInputTextFlags.None]
	* @return {Bool}
	*/
function ImGuiInputInt2(label, v, flags=ImGuiInputTextFlags.None) {
	return __imgui_input_int2(label, v, flags);
}

/**
	* @function ImGuiInputInt3
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {String} label
	* @param {Array} v
	* @param {Enum.ImGuiInputTextFlags} [flags=ImGuiInputTextFlags.None]
	* @return {Bool}
	*/
function ImGuiInputInt3(label, v, flags=ImGuiInputTextFlags.None) {
	return __imgui_input_int3(label, v, flags);
}

/**
	* @function ImGuiInputInt4
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {String} label
	* @param {Array} v
	* @param {Enum.ImGuiInputTextFlags} [flags=ImGuiInputTextFlags.None]
	* @return {Bool}
	*/
function ImGuiInputInt4(label, v, flags=ImGuiInputTextFlags.None) {
	return __imgui_input_int4(label, v, flags);
}

/**
	* @function ImGuiInputIntN
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {String} label
	* @param {Array} v
	* @param {Enum.ImGuiInputTextFlags} [flags=ImGuiInputTextFlags.None]
	* @return {Bool}
	*/
function ImGuiInputIntN(label, v, flags=ImGuiInputTextFlags.None) {
	return __imgui_input_int_n(label, v, flags, array_length(v));
}

/**
	* @function ImGuiInputText
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {String} label
	* @param {String} val
	* @param {Enum.ImGuiInputTextFlags} [flags=ImGuiInputTextFlags.None]
	* @return {String}
	*/
function ImGuiInputText(label, val, flags=ImGuiInputTextFlags.None) {
	return __imgui_input_text(label, val, flags);
}

/**
	* @function ImGuiInputTextMultiline
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {String} label
	* @param {String} val
	* @param {Real} [width=0]
	* @param {Real} [height=0]
	* @param {Enum.ImGuiInputTextFlags} [flags=ImGuiInputTextFlags.None]
	* @return {String}
	*/
function ImGuiInputTextMultiline(label, val, width=0, height=0, flags=ImGuiInputTextFlags.None) {
	return __imgui_input_text_multiline(label, val, width, height, flags);
}

/**
	* @function ImGuiInputTextWithHint
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {String} label
	* @param {String} hint
	* @param {String} val
	* @param {Enum.ImGuiInputTextFlags} [flags=ImGuiInputTextFlags.None]
	* @return {String}
	*/
function ImGuiInputTextWithHint(label, hint, val, flags=ImGuiInputTextFlags.None) {
	return __imgui_input_text_with_hint(label, hint, val, flags);
}

/**
	* @function ImGuiInvisibleButton
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* flexible button behavior without the visuals, frequently useful to build custom behaviors using the public api (along with IsItemActive, IsItemHovered, etc.)
	* @param {String} _id
	* @param {Real} [width=0]
	* @param {Real} [height=0]
	* @param {Enum.ImGuiButtonFlags} [flags=ImGuiButtonFlags.None]
	* @return {Bool}
	*/
function ImGuiInvisibleButton(_id, width=0, height=0, flags=ImGuiButtonFlags.None) {
	return __imgui_invisible_button(_id, width, height, flags);
}

/**
	* @function ImGuiIsAnyItemActive
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* is any item active?
	* @return {Bool}
	*/
function ImGuiIsAnyItemActive() {
	return __imgui_is_any_item_active();
}

/**
	* @function ImGuiIsAnyItemFocused
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* is any item focused?
	* @return {Bool}
	*/
function ImGuiIsAnyItemFocused() {
	return __imgui_is_any_item_focused();
}

/**
	* @function ImGuiIsAnyItemHovered
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* is any item hovered?
	* @return {Bool}
	*/
function ImGuiIsAnyItemHovered() {
	return __imgui_is_any_item_hovered();
}

/**
	* @function ImGuiIsAnyMouseDown
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* [WILL OBSOLETE] is any mouse button held? This was designed for backends, but prefer having backend maintain a mask of held mouse buttons, because upcoming input queue system will make this invalid.
	* @return {Bool}
	*/
function ImGuiIsAnyMouseDown() {
	return __imgui_is_any_mouse_down();
}

/**
	* @function ImGuiIsItemActivated
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* was the last item just made active (item was previously inactive).
	* @return {Bool}
	*/
function ImGuiIsItemActivated() {
	return __imgui_is_item_activated();
}

/**
	* @function ImGuiIsItemActive
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* is the last item active? (e.g. button being held, text field being edited. This will continuously return true while holding mouse button on an item. Items that don't interact will always return false)
	* @return {Bool}
	*/
function ImGuiIsItemActive() {
	return __imgui_is_item_active();
}

/**
	* @function ImGuiIsItemClicked
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* is the last item hovered and mouse clicked on? (**)  == IsMouseClicked(mouse_button) && IsItemHovered()Important. (**) this is NOT equivalent to the behavior of e.g. Button(). Read comments in function definition.
	* @param {Enum.ImGuiMouseButton} [mouse_button=ImGuiMouseButton.Left]
	* @return {Bool}
	*/
function ImGuiIsItemClicked(mouse_button=ImGuiMouseButton.Left) {
	return __imgui_is_item_clicked(mouse_button);
}

/**
	* @function ImGuiIsItemDeactivated
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* was the last item just made inactive (item was previously active). Useful for Undo/Redo patterns with widgets that require continuous editing.
	* @return {Bool}
	*/
function ImGuiIsItemDeactivated() {
	return __imgui_is_item_deactivated();
}

/**
	* @function ImGuiIsItemDeactivatedAfterEdit
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* was the last item just made inactive and made a value change when it was active? (e.g. Slider/Drag moved). Useful for Undo/Redo patterns with widgets that require continuous editing. Note that you may get false positives (some widgets such as Combo()/ListBox()/Selectable() will return true even when clicking an already selected item).
	* @return {Bool}
	*/
function ImGuiIsItemDeactivatedAfterEdit() {
	return __imgui_is_item_deactivated_after_edit();
}

/**
	* @function ImGuiIsItemEdited
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* did the last item modify its underlying value this frame? or was pressed? This is generally the same as the "bool" return value of many widgets.
	* @return {Bool}
	*/
function ImGuiIsItemEdited() {
	return __imgui_is_item_edited();
}

/**
	* @function ImGuiIsItemFocused
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* is the last item focused for keyboard/gamepad navigation?
	* @return {Bool}
	*/
function ImGuiIsItemFocused() {
	return __imgui_is_item_focused();
}

/**
	* @function ImGuiIsItemHovered
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* is the last item hovered? (and usable, aka not blocked by a popup, etc.). See ImGuiHoveredFlags for more options.
	* @param {Enum.ImGuiHoveredFlags} [flags=ImGuiHoveredFlags.None]
	* @return {Bool}
	*/
function ImGuiIsItemHovered(flags=ImGuiHoveredFlags.None) {
	return __imgui_is_item_hovered(flags);
}

/**
	* @function ImGuiIsItemToggledOpen
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* was the last item open state toggled? set by TreeNode().
	* @return {Bool}
	*/
function ImGuiIsItemToggledOpen() {
	return __imgui_is_item_toggled_open();
}

/**
	* @function ImGuiIsItemToggledSelection
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* Was the last item selection state toggled? Useful if you need the per-item information _before_ reaching EndMultiSelect(). We only returns toggle _event_ in order to handle clipping correctly.
	* @return {Bool}
	*/
function ImGuiIsItemToggledSelection() {
	return __imgui_is_item_toggled_selection();
}

/**
	* @function ImGuiIsItemVisible
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* is the last item visible? (items may be out of sight because of clipping/scrolling)
	* @return {Bool}
	*/
function ImGuiIsItemVisible() {
	return __imgui_is_item_visible();
}

/**
	* @function ImGuiIsKeyChordPressed
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* was key chord (mods + key) pressed, e.g. you can pass 'ImGuiMod_Ctrl | ImGuiKey_S' as a key-chord. This doesn't do any routing or focus check, please consider using Shortcut() function instead.
	* @param {ImGuiKeyChord} key_chord
	* @param {ImGuiInputFlags} [flags=undefined]
	* @param {ImGuiID} [owner_id=undefined]
	* @return {Bool}
	*/
function ImGuiIsKeyChordPressed(key_chord, flags=undefined, owner_id=undefined) {
	return __imgui_is_key_chord_pressed(key_chord, flags, owner_id);
}

/**
	* @function ImGuiIsKeyDown
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* is key being held.
	* @param {ImGuiKey} key
	* @param {ImGuiID} [owner_id=undefined]
	* @return {Bool}
	*/
function ImGuiIsKeyDown(key, owner_id=undefined) {
	return __imgui_is_key_down(key, owner_id);
}

/**
	* @function ImGuiIsKeyPressed
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* was key pressed (went from !Down to Down)? if repeat=true, uses io.KeyRepeatDelay / KeyRepeatRate
	* @param {ImGuiKey} key
	* @param {Bool} [_repeat=undefined]
	* @return {Bool}
	*/
function ImGuiIsKeyPressed(key, _repeat=undefined) {
	return __imgui_is_key_pressed(key, _repeat);
}

/**
	* @function ImGuiIsKeyReleased
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* was key released (went from Down to !Down)?
	* @param {ImGuiKey} key
	* @param {ImGuiID} [owner_id=undefined]
	* @return {Bool}
	*/
function ImGuiIsKeyReleased(key, owner_id=undefined) {
	return __imgui_is_key_released(key, owner_id);
}

/**
	* @function ImGuiIsMouseClicked
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* did mouse button clicked? (went from !Down to Down). Same as GetMouseClickedCount() == 1.
	* @param {ImGuiMouseButton} button
	* @param {Bool|ImGuiInputFlags} [repeat_or_flags=undefined]
	* @param {ImGuiID} [owner_id=undefined]
	* @return {Bool}
	*/
function ImGuiIsMouseClicked(button, repeat_or_flags=undefined, owner_id=undefined) {
	return __imgui_is_mouse_clicked(button, repeat_or_flags, owner_id);
}

/**
	* @function ImGuiIsMouseDoubleClicked
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* did mouse button double-clicked? Same as GetMouseClickedCount() == 2. (note that a double-click will also report IsMouseClicked() == true)
	* @param {ImGuiMouseButton} button
	* @param {ImGuiID} [owner_id=undefined]
	* @return {Bool}
	*/
function ImGuiIsMouseDoubleClicked(button, owner_id=undefined) {
	return __imgui_is_mouse_double_clicked(button, owner_id);
}

/**
	* @function ImGuiIsMouseDown
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* is mouse button held?
	* @param {ImGuiMouseButton} button
	* @param {ImGuiID} [owner_id=undefined]
	* @return {Bool}
	*/
function ImGuiIsMouseDown(button, owner_id=undefined) {
	return __imgui_is_mouse_down(button, owner_id);
}

/**
	* @function ImGuiIsMouseDragging
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* is mouse dragging? (uses io.MouseDraggingThreshold if lock_threshold < 0.0f)
	* @param {ImGuiMouseButton} button
	* @param {Float} [lock_threshold=-1]
	* @return {Bool}
	*/
function ImGuiIsMouseDragging(button, lock_threshold=-1) {
	return __imgui_is_mouse_dragging(button, lock_threshold);
}

/**
	* @function ImGuiIsMouseHoveringRect
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* is mouse hovering given bounding rect (in screen space). clipped by current clipping settings, but disregarding of other consideration of focus/window ordering/popup-block.
	* @param {Real} min_x
	* @param {Real} min_y
	* @param {Real} max_x
	* @param {Real} max_y
	* @param {Bool} [clip=true]
	* @return {Bool}
	*/
function ImGuiIsMouseHoveringRect(min_x, min_y, max_x, max_y, clip=true) {
	return __imgui_is_mouse_hovering_rect(min_x, min_y, max_x, max_y, clip);
}

/**
	* @function ImGuiIsMousePosValid
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* by convention we use (-FLT_MAX,-FLT_MAX) to denote that there is no mouse available
	* @param {Real} mouse_x
	* @param {Real} mouse_y
	* @return {Bool}
	*/
function ImGuiIsMousePosValid(mouse_x, mouse_y) {
	return __imgui_is_mouse_pos_valid(mouse_x, mouse_y);
}

/**
	* @function ImGuiIsMouseReleased
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* did mouse button released? (went from Down to !Down)
	* @param {ImGuiMouseButton} button
	* @param {ImGuiID} [owner_id=undefined]
	* @return {Bool}
	*/
function ImGuiIsMouseReleased(button, owner_id=undefined) {
	return __imgui_is_mouse_released(button, owner_id);
}

/**
	* @function ImGuiIsPopupOpen
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* return true if the popup is open.
	* @param {String} str_id
	* @param {Enum.ImGuiPopupFlags} [flags=ImGuiPopupFlags.None]
	* @return {Bool}
	*/
function ImGuiIsPopupOpen(str_id, flags=ImGuiPopupFlags.None) {
	return __imgui_is_popup_open(str_id, flags);
}

/**
	* @function ImGuiIsRectVisible
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* test if rectangle (of given size, starting from cursor position) is visible / not clipped.
	* @param {Real} x1
	* @param {Real} y1
	* @param {Real} x2
	* @param {Real} y2
	* @return {Bool}
	*/
function ImGuiIsRectVisible(x1, y1, x2, y2) {
	return __imgui_is_rect_visible(x1, y1, x2, y2);
}

/**
	* @function ImGuiIsWindowAppearing
	* @context ImGui
	* @desc ImGui function wrapper.
	* @return {Bool}
	*/
function ImGuiIsWindowAppearing() {
	return __imgui_is_window_appearing();
}

/**
	* @function ImGuiIsWindowCollapsed
	* @context ImGui
	* @desc ImGui function wrapper.
	* @return {Bool}
	*/
function ImGuiIsWindowCollapsed() {
	return __imgui_is_window_collapsed();
}

/**
	* @function ImGuiIsWindowDocked
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* is current window docked into another window?
	* @return {Bool}
	*/
function ImGuiIsWindowDocked() {
	return __imgui_is_window_docked();
}

/**
	* @function ImGuiIsWindowFocused
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* is current window focused? or its root/child, depending on flags. see flags for options.
	* @param {Enum.ImGuiFocusedFlags} [flags=ImGuiFocusedFlags.None]
	* @return {Bool}
	*/
function ImGuiIsWindowFocused(flags=ImGuiFocusedFlags.None) {
	return __imgui_is_window_focused(flags);
}

/**
	* @function ImGuiIsWindowHovered
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* is current window hovered and hoverable (e.g. not blocked by a popup/modal)? See ImGuiHoveredFlags_ for options. IMPORTANT: If you are trying to check whether your mouse should be dispatched to Dear ImGui or to your underlying app, you should not use this function! Use the 'io.WantCaptureMouse' boolean for that! Refer to FAQ entry "How can I tell whether to dispatch mouse/keyboard to Dear ImGui or my application?" for details.
	* @param {Enum.ImGuiHoveredFlags} [flags=ImGuiHoveredFlags.None]
	* @return {Bool}
	*/
function ImGuiIsWindowHovered(flags=ImGuiHoveredFlags.None) {
	return __imgui_is_window_hovered(flags);
}

/**
	* @function ImGuiLabelText
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {String} label
	* @param {String} val
	* @return {Undefined}
	*/
function ImGuiLabelText(label, val) {
	return __imgui_label_text(label, val);
}

/**
	* @function ImGuiListBox
	* @context ImGui
	* @desc ImGui function wrapper.
	* @return {undefined}
	*/
function ImGuiListBox() {
	return __imgui_list_box();
}

/**
	* @function ImGuiLoadIniSettingsFromDisk
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* call after CreateContext() and before the first call to NewFrame(). NewFrame() automatically calls LoadIniSettingsFromDisk(io.IniFilename).
	* @param {String} [ini_filename=undefined]
	* @return {Undefined}
	*/
function ImGuiLoadIniSettingsFromDisk(ini_filename="undefined") {
	return __imgui_load_ini_settings_from_disk(ini_filename);
}

/**
	* @function ImGuiLoadIniSettingsFromMemory
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* call after CreateContext() and before the first call to NewFrame() to provide .ini data from your own data source.
	* @param {String} [ini_data=undefined]
	* @return {Undefined}
	*/
function ImGuiLoadIniSettingsFromMemory(ini_data="undefined") {
	return __imgui_load_ini_settings_from_memory(ini_data);
}

/**
	* @function ImGuiLogButtons
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* helper to display buttons for logging to tty/file/clipboard
	* @return {Undefined}
	*/
function ImGuiLogButtons() {
	return __imgui_log_buttons();
}

/**
	* @function ImGuiLogFinish
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* stop logging (close file, etc.)
	* @return {Undefined}
	*/
function ImGuiLogFinish() {
	return __imgui_log_finish();
}

/**
	* @function ImGuiLogText
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {String} text
	* @return {Undefined}
	*/
function ImGuiLogText(text) {
	return __imgui_log_text(text);
}

/**
	* @function ImGuiLogToClipboard
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* start logging to OS clipboard
	* @param {Real} [auto_open_depth=-1]
	* @return {Undefined}
	*/
function ImGuiLogToClipboard(auto_open_depth=-1) {
	return __imgui_log_to_clipboard(auto_open_depth);
}

/**
	* @function ImGuiLogToFile
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* start logging to file
	* @param {Real} [auto_open_depth=-1]
	* @param {Any} [filename=undefined]
	* @return {Undefined}
	*/
function ImGuiLogToFile(auto_open_depth=-1, filename=undefined) {
	return __imgui_log_to_file(auto_open_depth, filename);
}

/**
	* @function ImGuiLogToTTY
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Real} [auto_open_depth=-1]
	* @return {Undefined}
	*/
function ImGuiLogToTTY(auto_open_depth=-1) {
	return __imgui_log_to_tty(auto_open_depth);
}

/**
	* @function ImGuiMemoryEditorDrawContents
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Real} buffer
	* @param {Real} [offset=0]
	* @param {Real} [size=buffer_get_size⌊buffer⌉]
	* @return {Undefined}
	*/
function ImGuiMemoryEditorDrawContents(buffer, offset=0, size=buffer_get_size(buffer)) {
	return __imgui_memory_editor_contents(buffer, offset, size);
}

/**
	* @function ImGuiMemoryEditorShowWindow
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {String} title
	* @param {Real} buffer
	* @param {Real} [offset=0]
	* @param {Real} [size=buffer_get_size⌊buffer⌉]
	* @return {Undefined}
	*/
function ImGuiMemoryEditorShowWindow(title, buffer, offset=0, size=buffer_get_size(buffer)) {
	return __imgui_memory_editor_window(title, buffer, offset, size);
}

/**
	* @function ImGuiMenuItem
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* return true when activated.
	* @param {String} label
	* @param {String} [shortcut=]
	* @param {Bool} [selected=undefined]
	* @param {Bool} [enabled=true]
	* @param {Enum.ImGuiReturnMask} [mask=ImGuiReturnMask.Return]
	* @return {Real}
	*/
function ImGuiMenuItem(label, shortcut="", selected=undefined, enabled=true, mask=ImGuiReturnMask.Return) {
	return __imgui_menu_item(label, shortcut, selected, enabled, mask);
}

/**
	* @function ImGuiNewLine
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* undo a SameLine() or force a new line when in a horizontal-layout context.
	* @return {Undefined}
	*/
function ImGuiNewLine() {
	return __imgui_new_line();
}

/**
	* @function ImGuiNextColumn
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* next column, defaults to current row or next row if the current row is finished
	* @return {Undefined}
	*/
function ImGuiNextColumn() {
	return __imgui_next_column();
}

/**
	* @function ImGuiOpenPopup
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* call to mark popup as open (don't call every frame!).
	* @param {String} str_id
	* @param {Enum.ImGuiPopupFlags} [flags=ImGuiPopupFlags.None]
	* @return {Undefined}
	*/
function ImGuiOpenPopup(str_id, flags=ImGuiPopupFlags.None) {
	return __imgui_open_popup(str_id, flags);
}

/**
	* @function ImGuiOpenPopupOnItemClick
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* helper to open popup when clicked on last item. Default to ImGuiPopupFlags_MouseButtonRight == 1. (note: actually triggers on the mouse _released_ event to be consistent with popup behaviors)
	* @param {String} [str_id=undefined]
	* @param {Enum.ImGuiPopupFlags} [flags=ImGuiPopupFlags.MouseButtonRight]
	* @return {Undefined}
	*/
function ImGuiOpenPopupOnItemClick(str_id="undefined", flags=ImGuiPopupFlags.MouseButtonRight) {
	return __imgui_open_popup_on_item_click(str_id, flags);
}

/**
	* @function ImGuiPlotHistogram
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {String} label
	* @param {Array} values
	* @param {Real} [values_offset=0]
	* @param {String} [overlay_text=]
	* @param {Real} [scale_min=0]
	* @param {Real} [scale_max=0]
	* @param {Real} [graph_width=0]
	* @param {Real} [graph_height=0]
	* @return {Undefined}
	*/
function ImGuiPlotHistogram(label, values, values_offset=0, overlay_text="", scale_min=0, scale_max=0, graph_width=0, graph_height=0) {
	return __imgui_plot_histogram(label, values, values_offset, overlay_text, scale_min, scale_max, graph_width, graph_height, array_length(values));
}

/**
	* @function ImGuiPlotLines
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {String} label
	* @param {Array} values
	* @param {Real} [values_offset=0]
	* @param {String} [overlay_text=]
	* @param {Real} [scale_min=0]
	* @param {Real} [scale_max=0]
	* @param {Real} [graph_width=0]
	* @param {Real} [graph_height=0]
	* @return {Undefined}
	*/
function ImGuiPlotLines(label, values, values_offset=0, overlay_text="", scale_min=0, scale_max=0, graph_width=0, graph_height=0) {
	return __imgui_plot_lines(label, values, values_offset, overlay_text, scale_min, scale_max, graph_width, graph_height, array_length(values));
}

/**
	* @function ImGuiPopAllowKeyboardFocus
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @return {Undefined}
	*/
function ImGuiPopAllowKeyboardFocus() {
	return __imgui_pop_allow_keyboard_focus();
}

/**
	* @function ImGuiPopButtonRepeat
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @return {Undefined}
	*/
function ImGuiPopButtonRepeat() {
	return __imgui_pop_button_repeat();
}

/**
	* @function ImGuiPopClipRect
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* Focus, Activation
	* @return {Undefined}
	*/
function ImGuiPopClipRect() {
	return __imgui_pop_clip_rect();
}

/**
	* @function ImGuiPopFont
	* @context ImGui
	* @desc ImGui function wrapper.
	* @return {Undefined}
	*/
function ImGuiPopFont() {
	return __imgui_pop_font();
}

/**
	* @function ImGuiPopID
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @return {Undefined}
	*/
function ImGuiPopID() {
	return __imgui_pop_id();
}

/**
	* @function ImGuiPopItemFlag
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* Parameters stacks (current window)
	* @return {Undefined}
	*/
function ImGuiPopItemFlag() {
	return __imgui_pop_item_flag();
}

/**
	* @function ImGuiPopItemWidth
	* @context ImGui
	* @desc ImGui function wrapper.
	* @return {Undefined}
	*/
function ImGuiPopItemWidth() {
	return __imgui_pop_item_width();
}

/**
	* @function ImGuiPopStyleColor
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {Real} [count=1]
	* @return {Undefined}
	*/
function ImGuiPopStyleColor(count=1) {
	return __imgui_pop_style_color(count);
}

/**
	* @function ImGuiPopStyleVar
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {Real} [count=1]
	* @return {Undefined}
	*/
function ImGuiPopStyleVar(count=1) {
	return __imgui_pop_style_var(count);
}

/**
	* @function ImGuiPopTextWrapPos
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* Style read access
	* @return {Undefined}
	*/
function ImGuiPopTextWrapPos() {
	return __imgui_pop_text_wrap_pos();
}

/**
	* @function ImGuiProgressBar
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {Real} _frac
	* @param {Real} [width=0]
	* @param {Real} [height=0]
	* @param {String} [overlay=]
	* @return {Undefined}
	*/
function ImGuiProgressBar(_frac, width=0, height=0, overlay="") {
	return __imgui_progress_bar(_frac, width, height, overlay);
}

/**
	* @function ImGuiPushAllowKeyboardFocus
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Bool} allow_keyboard_focus
	* @return {Undefined}
	*/
function ImGuiPushAllowKeyboardFocus(allow_keyboard_focus) {
	return __imgui_push_allow_keyboard_focus(allow_keyboard_focus);
}

/**
	* @function ImGuiPushButtonRepeat
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Bool} _repeat
	* @return {Undefined}
	*/
function ImGuiPushButtonRepeat(_repeat) {
	return __imgui_push_button_repeat(_repeat);
}

/**
	* @function ImGuiPushClipRect
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {Real} clip_min_x
	* @param {Real} clip_min_y
	* @param {Real} clip_max_x
	* @param {Real} clip_max_y
	* @param {Bool} intersect_with_current_clip_rect
	* @return {Undefined}
	*/
function ImGuiPushClipRect(clip_min_x, clip_min_y, clip_max_x, clip_max_y, intersect_with_current_clip_rect) {
	return __imgui_push_clip_rect(clip_min_x, clip_min_y, clip_max_x, clip_max_y, intersect_with_current_clip_rect);
}

/**
	* @function ImGuiPushFont
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* Use NULL as a shortcut to keep current font. Use 0.0f to keep current size.
	* @param {Any} [_ptr=undefined]
	* @return {Undefined}
	*/
function ImGuiPushFont(_ptr=undefined) {
	return __imgui_push_font(_ptr);
}

/**
	* @function ImGuiPushID
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {String|Real} _id
	* @return {Undefined}
	*/
function ImGuiPushID(_id) {
	return __imgui_push_id(_id);
}

/**
	* @function ImGuiPushItemFlag
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* modify specified shared item flag, e.g. PushItemFlag(ImGuiItemFlags_NoTabStop, true)
	* @param {ImGuiItemFlags} item_flag
	* @param {Bool} enabled
	* @return {Undefined}
	*/
function ImGuiPushItemFlag(item_flag, enabled) {
	return __imgui_push_item_flag(item_flag, enabled);
}

/**
	* @function ImGuiPushItemWidth
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* push width of items for common large "item+label" widgets. >0.0f: width in pixels, <0.0f align xx pixels to the right of window (so -FLT_MIN always align width to the right side).
	* @param {Real} item_width
	* @return {Undefined}
	*/
function ImGuiPushItemWidth(item_width) {
	return __imgui_push_item_width(item_width);
}

/**
	* @function ImGuiPushStyleColor
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* modify a style color. always use this if you modify the style after NewFrame().
	* @param {Real} idx
	* @param {Real} col
	* @param {Real} alpha
	* @return {Undefined}
	*/
function ImGuiPushStyleColor(idx, col, alpha) {
	return __imgui_push_style_color(idx, col, alpha);
}

/**
	* @function ImGuiPushStyleVar
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* modify a style float variable. always use this if you modify the style after NewFrame()!
	* @param {Real} idx
	* @param {Real} val
	* @param {Any} [val2=undefined]
	* @return {Undefined}
	*/
function ImGuiPushStyleVar(idx, val, val2=undefined) {
	return __imgui_push_style_var(idx, val, val2);
}

/**
	* @function ImGuiPushStyleVarX
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* modify X component of a style ImVec2 variable. "
	* @param {Real} idx
	* @param {Real} val_x
	* @return {Undefined}
	*/
function ImGuiPushStyleVarX(idx, val_x) {
	return __imgui_push_style_var_x(idx, val_x);
}

/**
	* @function ImGuiPushStyleVarY
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* modify Y component of a style ImVec2 variable. "
	* @param {Real} idx
	* @param {Real} val_y
	* @return {Undefined}
	*/
function ImGuiPushStyleVarY(idx, val_y) {
	return __imgui_push_style_var_y(idx, val_y);
}

/**
	* @function ImGuiPushTextWrapPos
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* push word-wrapping position for Text*() commands. < 0.0f: no wrapping; 0.0f: wrap to end of window (or column); > 0.0f: wrap at 'wrap_pos_x' position in window local space
	* @param {Real} [wrap_local_pos_x=0]
	* @return {Undefined}
	*/
function ImGuiPushTextWrapPos(wrap_local_pos_x=0) {
	return __imgui_push_text_wrap_pos(wrap_local_pos_x);
}

/**
	* @function ImGuiRadioButton
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* use with e.g. if (RadioButton("one", my_value==1)) { my_value = 1; }
	* @param {String} label
	* @param {Bool} active
	* @return {Bool}
	*/
function ImGuiRadioButton(label, active) {
	return __imgui_radio_button(label, active);
}

/**
	* @function ImGuiResetMouseDragDelta
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {ImGuiMouseButton} button
	* @return {Undefined}
	*/
function ImGuiResetMouseDragDelta(button) {
	return __imgui_reset_mouse_drag_delta(button);
}

/**
	* @function ImGuiSameLine
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* call between widgets or groups to layout them horizontally. X position given in window coordinates.
	* @param {Real} [offset_from_start_x=0]
	* @param {Real} [spacing=-1]
	* @return {Undefined}
	*/
function ImGuiSameLine(offset_from_start_x=0, spacing=-1) {
	return __imgui_same_line(offset_from_start_x, spacing);
}

/**
	* @function ImGuiSaveIniSettingsToDisk
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* this is automatically called (if io.IniFilename is not empty) a few seconds after any modification that should be reflected in the .ini file (and also by DestroyContext).
	* @param {String} [ini_filename=undefined]
	* @return {Undefined}
	*/
function ImGuiSaveIniSettingsToDisk(ini_filename="undefined") {
	return __imgui_save_ini_settings_to_disk(ini_filename);
}

/**
	* @function ImGuiSaveIniSettingsToMemory
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* return a zero-terminated string with the .ini data which you can save by your own mean. call when io.WantSaveIniSettings is set, then save data by your own mean and clear io.WantSaveIniSettings.
	* @return {String}
	*/
function ImGuiSaveIniSettingsToMemory() {
	return __imgui_save_ini_settings_to_memory();
}

/**
	* @function ImGuiSelectable
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* "bool selected" carry the selection state (read-only). Selectable() is clicked is returns true so you can modify your selection state. size.x==0.0: use remaining width, size.x>0.0: specify width. size.y==0.0: use label height, size.y>0.0: specify height
	* @param {String} label
	* @param {Bool} [selected=false]
	* @param {Enum.ImGuiSelectableFlags} [flags=ImGuiSelectableFlags.None]
	* @param {Real} [width=0]
	* @param {Real} [height=0]
	* @return {Bool}
	*/
function ImGuiSelectable(label, selected=false, flags=ImGuiSelectableFlags.None, width=0, height=0) {
	return __imgui_selectable(label, selected, flags, width, height);
}

/**
	* @function ImGuiSelectionStorageApplyRequests
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {ImGuiSelectionBasicStorage} selection
	* @param {ImGuiMultiSelectIO} ms_io
	* @return {Undefined}
	*/
function ImGuiSelectionStorageApplyRequests(selection, ms_io) {
	return __imgui_selection_storage_apply_requests(selection, ms_io);
}

/**
	* @function ImGuiSelectionStorageContains
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {ImGuiSelectionBasicStorage} selection
	* @param {Real} idx
	* @return {Bool}
	*/
function ImGuiSelectionStorageContains(selection, idx) {
	return __imgui_selection_storage_contains(selection, idx);
}

/**
	* @function ImGuiSelectionStorageSize
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {ImGuiSelectionBasicStorage} selection
	* @param {Any} [value=undefined]
	* @return {Real}
	*/
function ImGuiSelectionStorageSize(selection, value=undefined) {
	return __imgui_selection_storage_size(selection, value);
}

/**
	* @function ImGuiSeparator
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* separator, generally horizontal. inside a menu bar or in horizontal layout mode, this becomes a vertical separator.
	* @return {Undefined}
	*/
function ImGuiSeparator() {
	return __imgui_separator();
}

/**
	* @function ImGuiSeparatorText
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* currently: formatted text with a horizontal line
	* @param {String} label
	* @return {Undefined}
	*/
function ImGuiSeparatorText(label) {
	return __imgui_separator_text(label);
}

/**
	* @function ImGuiSetColorEditOptions
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* initialize current options (generally on application startup) if you want to select a default format, picker type, etc. User will be able to change many settings, unless you pass the _NoOptions flag to your calls.
	* @param {Enum.ImGuiCol} [flags=ImGuiColorEditFlags.None]
	* @return {Undefined}
	*/
function ImGuiSetColorEditOptions(flags=ImGuiColorEditFlags.None) {
	return __imgui_set_color_edit_options(flags);
}

/**
	* @function ImGuiSetColumnOffset
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* set position of column line (in pixels, from the left side of the contents region). pass -1 to use current column
	* @param {Real} column_index
	* @param {Real} offset_x
	* @return {Undefined}
	*/
function ImGuiSetColumnOffset(column_index, offset_x) {
	return __imgui_set_column_offset(column_index, offset_x);
}

/**
	* @function ImGuiSetColumnWidth
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* set column width (in pixels). pass -1 to use current column
	* @param {Real} column_index
	* @param {Real} width
	* @return {Undefined}
	*/
function ImGuiSetColumnWidth(column_index, width) {
	return __imgui_set_column_width(column_index, width);
}

/**
	* @function ImGuiSetCurrentContext
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* Main
	* @param {Pointer} ctx
	* @return {Undefined}
	*/
function ImGuiSetCurrentContext(ctx) {
	return __imgui_set_current_context(ctx);
}

/**
	* @function ImGuiSetCursorPos
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* [window-local] "
	* @param {Real} local_x
	* @param {Real} local_y
	* @return {Undefined}
	*/
function ImGuiSetCursorPos(local_x, local_y) {
	return __imgui_set_cursor_pos(local_x, local_y);
}

/**
	* @function ImGuiSetCursorPosX
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* [window-local] "
	* @param {Real} local_x
	* @return {Undefined}
	*/
function ImGuiSetCursorPosX(local_x) {
	return __imgui_set_cursor_pos_x(local_x);
}

/**
	* @function ImGuiSetCursorPosY
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* [window-local] "
	* @param {Real} local_y
	* @return {Undefined}
	*/
function ImGuiSetCursorPosY(local_y) {
	return __imgui_set_cursor_pos_y(local_y);
}

/**
	* @function ImGuiSetCursorScreenPos
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* cursor position, absolute coordinates. THIS IS YOUR BEST FRIEND.
	* @param {Real} _x
	* @param {Real} _y
	* @return {Undefined}
	*/
function ImGuiSetCursorScreenPos(_x, _y) {
	return __imgui_set_cursor_screen_pos(_x, _y);
}

/**
	* @function ImGuiSetDragDropPayload
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* type is a user defined string of maximum 32 characters. Strings starting with '_' are reserved for dear imgui internal types. Data is copied and held by imgui. Return true when payload has been accepted.
	* @param {String} type
	* @param {Any} data
	* @param {Enum.ImGuiCond} [cond=ImGuiCond.None]
	* @return {Bool}
	*/
function ImGuiSetDragDropPayload(type, data, cond=ImGuiCond.None) {
	return __imgui_set_drag_drop_payload(type, data, cond);
}

/**
	* @function ImGuiSetItemDefaultFocus
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* make last item the default focused item of a newly appearing window.
	* @return {Undefined}
	*/
function ImGuiSetItemDefaultFocus() {
	return __imgui_set_item_default_focus();
}

/**
	* @function ImGuiSetItemKeyOwner
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* Set key owner to last item ID if it is hovered or active. Equivalent to 'if (IsItemHovered() || IsItemActive()) { SetKeyOwner(key, GetItemID());'.
	* @param {ImGuiKey} key
	* @param {ImGuiInputFlags} [flags=undefined]
	* @return {Undefined}
	*/
function ImGuiSetItemKeyOwner(key, flags=undefined) {
	return __imgui_set_item_key_owner(key, flags);
}

/**
	* @function ImGuiSetItemTooltip
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {String} text
	* @return {Undefined}
	*/
function ImGuiSetItemTooltip(text) {
	return __imgui_set_item_tooltip(text);
}

/**
	* @function ImGuiSetKeyboardFocusHere
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* focus keyboard on the next widget. Use positive 'offset' to access sub components of a multiple component widget. Use -1 to access previous widget.
	* @param {Real} [offset=0]
	* @return {Undefined}
	*/
function ImGuiSetKeyboardFocusHere(offset=0) {
	return __imgui_set_keyboard_focus_here(offset);
}

/**
	* @function ImGuiSetNextFrameWantCaptureKeyboard
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* Override io.WantCaptureKeyboard flag next frame (said flag is left for your application to handle, typically when true it instructs your app to ignore inputs). e.g. force capture keyboard when your widget is being hovered. This is equivalent to setting "io.WantCaptureKeyboard = want_capture_keyboard"; after the next NewFrame() call.
	* @param {Bool} [val=undefined]
	* @return {Undefined}
	*/
function ImGuiSetNextFrameWantCaptureKeyboard(val=undefined) {
	return __imgui_set_next_frame_want_capture_keyboard(val);
}

/**
	* @function ImGuiSetNextFrameWantCaptureMouse
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* Override io.WantCaptureMouse flag next frame (said flag is left for your application to handle, typical when true it instructs your app to ignore inputs). This is equivalent to setting "io.WantCaptureMouse = want_capture_mouse;" after the next NewFrame() call.
	* @param {Bool} [val=undefined]
	* @return {Undefined}
	*/
function ImGuiSetNextFrameWantCaptureMouse(val=undefined) {
	return __imgui_set_next_frame_want_capture_mouse(val);
}

/**
	* @function ImGuiSetNextItemAllowOverlap
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* allow next item to be overlapped by a subsequent item. Useful with invisible buttons, selectable, treenode covering an area where subsequent items may need to be added. Note that both Selectable() and TreeNode() have dedicated flags doing this.
	* @return {Undefined}
	*/
function ImGuiSetNextItemAllowOverlap() {
	return __imgui_set_next_item_allow_overlap();
}

/**
	* @function ImGuiSetNextItemOpen
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* set next TreeNode/CollapsingHeader open state.
	* @param {Bool} is_open
	* @param {Enum.ImGuiCond} [cond=ImGuiCond.None]
	* @return {Undefined}
	*/
function ImGuiSetNextItemOpen(is_open, cond=ImGuiCond.None) {
	return __imgui_set_next_item_open(is_open, cond);
}

/**
	* @function ImGuiSetNextItemSelectionUserData
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {Real} idx
	* @return {undefined}
	*/
function ImGuiSetNextItemSelectionUserData(idx) {
	return __imgui_set_next_item_selection_user_data(idx);
}

/**
	* @function ImGuiSetNextItemShortcut
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* Inputs Utilities: Key/Input Ownership [BETA]
	* @param {ImGuiKeyChord} key_chord
	* @param {ImGuiInputFlags} flags
	* @return {Undefined}
	*/
function ImGuiSetNextItemShortcut(key_chord, flags) {
	return __imgui_set_next_item_shortcut(key_chord, flags);
}

/**
	* @function ImGuiSetNextItemWidth
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* set width of the _next_ common large "item+label" widget. >0.0f: width in pixels, <0.0f align xx pixels to the right of window (so -FLT_MIN always align width to the right side)
	* @param {Real} item_width
	* @return {Undefined}
	*/
function ImGuiSetNextItemWidth(item_width) {
	return __imgui_set_next_item_width(item_width);
}

/**
	* @function ImGuiSetNextWindowBgAlpha
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* set next window background color alpha. helper to easily override the Alpha component of ImGuiCol_WindowBg/ChildBg/PopupBg. you may also use ImGuiWindowFlags_NoBackground.
	* @param {Real} alpha
	* @return {Undefined}
	*/
function ImGuiSetNextWindowBgAlpha(alpha) {
	return __imgui_set_next_window_bg_alpha(alpha);
}

/**
	* @function ImGuiSetNextWindowClass
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* set next window class (control docking compatibility + provide hints to platform backend via custom viewport flags and platform parent/child relationship)
	* @param {ImGuiWindowClass} window_class
	* @return {Undefined}
	*/
function ImGuiSetNextWindowClass(window_class) {
	return __imgui_set_next_window_class(window_class);
}

/**
	* @function ImGuiSetNextWindowCollapsed
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* set next window collapsed state. call before Begin()
	* @param {Bool} collapsed
	* @param {Enum.ImGuiCond} [cond=ImGuiCond.None]
	* @return {Undefined}
	*/
function ImGuiSetNextWindowCollapsed(collapsed, cond=ImGuiCond.None) {
	return __imgui_set_next_window_collapsed(collapsed, cond);
}

/**
	* @function ImGuiSetNextWindowContentSize
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* set next window content size (~ scrollable client area, which enforce the range of scrollbars). Not including window decorations (title bar, menu bar, etc.) nor WindowPadding. set an axis to 0.0f to leave it automatic. call before Begin()
	* @param {Real} width
	* @param {Real} height
	* @return {Undefined}
	*/
function ImGuiSetNextWindowContentSize(width, height) {
	return __imgui_set_next_window_content_size(width, height);
}

/**
	* @function ImGuiSetNextWindowDockID
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Real} dock_id
	* @param {Enum.ImGuiCond} [cond=ImGuiCond.None]
	* @return {Undefined}
	*/
function ImGuiSetNextWindowDockID(dock_id, cond=ImGuiCond.None) {
	return __imgui_set_next_window_dock_id(dock_id, cond);
}

/**
	* @function ImGuiSetNextWindowFocus
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* set next window to be focused / top-most. call before Begin()
	* @return {Undefined}
	*/
function ImGuiSetNextWindowFocus() {
	return __imgui_set_next_window_focus();
}

/**
	* @function ImGuiSetNextWindowPos
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* set next window position. call before Begin(). use pivot=(0.5f,0.5f) to center on given point, etc.
	* @param {Real} _x
	* @param {Real} _y
	* @param {Enum.ImGuiCond} [cond=ImGuiCond.None]
	* @param {Real} [pivot_x=0]
	* @param {Real} [pivot_y=0]
	* @return {Undefined}
	*/
function ImGuiSetNextWindowPos(_x, _y, cond=ImGuiCond.None, pivot_x=0, pivot_y=0) {
	return __imgui_set_next_window_pos(_x, _y, cond, pivot_x, pivot_y);
}

/**
	* @function ImGuiSetNextWindowScroll
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* set next window scrolling value (use < 0.0f to not affect a given axis).
	* @param {Real} scroll_x
	* @param {Real} scroll_y
	* @return {Undefined}
	*/
function ImGuiSetNextWindowScroll(scroll_x, scroll_y) {
	return __imgui_set_next_window_scroll(scroll_x, scroll_y);
}

/**
	* @function ImGuiSetNextWindowSize
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* set next window size. set axis to 0.0f to force an auto-fit on this axis. call before Begin()
	* @param {Real} width
	* @param {Real} height
	* @param {Enum.ImGuiCond} [cond=ImGuiCond.None]
	* @return {Undefined}
	*/
function ImGuiSetNextWindowSize(width, height, cond=ImGuiCond.None) {
	return __imgui_set_next_window_size(width, height, cond);
}

/**
	* @function ImGuiSetNextWindowSizeConstraints
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* set next window size limits. use 0.0f or FLT_MAX if you don't want limits. Use -1 for both min and max of same axis to preserve current size (which itself is a constraint). Use callback to apply non-trivial programmatic constraints.
	* @param {Real} min_width
	* @param {Real} min_height
	* @param {Real} max_width
	* @param {Real} max_height
	* @return {Undefined}
	*/
function ImGuiSetNextWindowSizeConstraints(min_width, min_height, max_width, max_height) {
	return __imgui_set_next_window_size_constraints(min_width, min_height, max_width, max_height);
}

/**
	* @function ImGuiSetNextWindowViewport
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* set next window viewport
	* @param {Real} _id
	* @return {Undefined}
	*/
function ImGuiSetNextWindowViewport(_id) {
	return __imgui_set_next_window_viewport(_id);
}

/**
	* @function ImGuiSetScrollFromPosX
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* adjust scrolling amount to make given position visible. Generally GetCursorStartPos() + offset to compute a valid position.
	* @param {Real} local_x
	* @param {Real} [center_x_ratio=0.5]
	* @return {Undefined}
	*/
function ImGuiSetScrollFromPosX(local_x, center_x_ratio=0.5) {
	return __imgui_set_scroll_from_pos_x(local_x, center_x_ratio);
}

/**
	* @function ImGuiSetScrollFromPosY
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* adjust scrolling amount to make given position visible. Generally GetCursorStartPos() + offset to compute a valid position.
	* @param {Real} local_y
	* @param {Real} [center_y_ratio=0.5]
	* @return {Undefined}
	*/
function ImGuiSetScrollFromPosY(local_y, center_y_ratio=0.5) {
	return __imgui_set_scroll_from_pos_y(local_y, center_y_ratio);
}

/**
	* @function ImGuiSetScrollHereX
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* adjust scrolling amount to make current cursor position visible. center_x_ratio=0.0: left, 0.5: center, 1.0: right. When using to make a "default/current item" visible, consider using SetItemDefaultFocus() instead.
	* @param {Real} [center_x_ratio=0.5]
	* @return {Undefined}
	*/
function ImGuiSetScrollHereX(center_x_ratio=0.5) {
	return __imgui_set_scroll_here_x(center_x_ratio);
}

/**
	* @function ImGuiSetScrollHereY
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* adjust scrolling amount to make current cursor position visible. center_y_ratio=0.0: top, 0.5: center, 1.0: bottom. When using to make a "default/current item" visible, consider using SetItemDefaultFocus() instead.
	* @param {Real} [center_y_ratio=0.5]
	* @return {Undefined}
	*/
function ImGuiSetScrollHereY(center_y_ratio=0.5) {
	return __imgui_set_scroll_here_y(center_y_ratio);
}

/**
	* @function ImGuiSetScrollX
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* set scrolling amount [0 .. GetScrollMaxX()]
	* @param {Real} scroll_x
	* @return {Undefined}
	*/
function ImGuiSetScrollX(scroll_x) {
	return __imgui_set_scroll_x(scroll_x);
}

/**
	* @function ImGuiSetScrollY
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* set scrolling amount [0 .. GetScrollMaxY()]
	* @param {Real} scroll_y
	* @return {Undefined}
	*/
function ImGuiSetScrollY(scroll_y) {
	return __imgui_set_scroll_y(scroll_y);
}

/**
	* @function ImGuiSetStyleColor
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Real} idx
	* @param {Real} col
	* @param {Real} alpha
	* @return {Undefined}
	*/
function ImGuiSetStyleColor(idx, col, alpha) {
	return __imgui_set_style_color(idx, col, alpha);
}

/**
	* @function ImGuiSetStyleVar
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Real} idx
	* @param {Any} val
	* @param {Any} [val2=undefined]
	* @return {Undefined}
	*/
function ImGuiSetStyleVar(idx, val, val2=undefined) {
	return __imgui_set_style_var(idx, val, val2);
}

/**
	* @function ImGuiSetTabItemClosed
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* notify TabBar or Docking system of a closed tab/window ahead (useful to reduce visual flicker on reorderable tab bars). For tab-bar: call after BeginTabBar() and before Tab submissions. Otherwise call with a window name.
	* @param {String} tab_or_docked_window_label
	* @return {Undefined}
	*/
function ImGuiSetTabItemClosed(tab_or_docked_window_label) {
	return __imgui_set_tab_item_closed(tab_or_docked_window_label);
}

/**
	* @function ImGuiSetTooltip
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {String} val
	* @return {Undefined}
	*/
function ImGuiSetTooltip(val) {
	return __imgui_set_tooltip(val);
}

/**
	* @function ImGuiSetWindowCollapsed
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* (not recommended) set current window collapsed state. prefer using SetNextWindowCollapsed().
	* @param {String} [name=]
	* @param {Bool} collapsed
	* @param {Enum.ImGuiCond} [cond=ImGuiCond.None]
	* @return {Undefined}
	*/
function ImGuiSetWindowCollapsed(name="", collapsed, cond=ImGuiCond.None) {
	return __imgui_set_window_collapsed(name, collapsed, cond);
}

/**
	* @function ImGuiSetWindowFocus
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* (not recommended) set current window to be focused / top-most. prefer using SetNextWindowFocus().
	* @param {String} [name=]
	* @return {Undefined}
	*/
function ImGuiSetWindowFocus(name="") {
	return __imgui_set_window_focus(name);
}

/**
	* @function ImGuiSetWindowFontScale
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* Set font scale factor for current window. Prefer using PushFont(NULL, style.FontSizeBase * factor) or use style.FontScaleMain to scale all windows.
	* @param {Real} scale
	* @return {Undefined}
	*/
function ImGuiSetWindowFontScale(scale) {
	return __imgui_set_window_font_scale(scale);
}

/**
	* @function ImGuiSetWindowPos
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* (not recommended) set current window position - call within Begin()/End(). prefer using SetNextWindowPos(), as this may incur tearing and side-effects.
	* @param {String} [name=]
	* @param {Real} _x
	* @param {Real} _y
	* @param {Enum.ImGuiCond} [cond=ImGuiCond.None]
	* @return {Undefined}
	*/
function ImGuiSetWindowPos(name="", _x, _y, cond=ImGuiCond.None) {
	return __imgui_set_window_pos(name, _x, _y, cond);
}

/**
	* @function ImGuiSetWindowSize
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* (not recommended) set current window size - call within Begin()/End(). set to ImVec2(0, 0) to force an auto-fit. prefer using SetNextWindowSize(), as this may incur tearing and minor side-effects.
	* @param {String} [name=]
	* @param {Real} width
	* @param {Real} height
	* @param {Enum.ImGuiCond} [cond=ImGuiCond.None]
	* @return {Undefined}
	*/
function ImGuiSetWindowSize(name="", width, height, cond=ImGuiCond.None) {
	return __imgui_set_window_size(name, width, height, cond);
}

/**
	* @function ImGuiShortcut
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {ImGuiKeyChord} key_chord
	* @param {ImGuiInputFlags} flags
	* @param {ImGuiID} [owner_id=undefined]
	* @return {Bool}
	*/
function ImGuiShortcut(key_chord, flags, owner_id=undefined) {
	return __imgui_shortcut(key_chord, flags, owner_id);
}

/**
	* @function ImGuiShowAboutWindow
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* create About window. display Dear ImGui version, credits and build/system information.
	* @param {Bool} [open=undefined]
	* @return {Bool}
	*/
function ImGuiShowAboutWindow(open=undefined) {
	return __imgui_show_about_window(open);
}

/**
	* @function ImGuiShowDebugLogWindow
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* create Debug Log window. display a simplified log of important dear imgui events.
	* @param {Bool} [open=undefined]
	* @return {Bool}
	*/
function ImGuiShowDebugLogWindow(open=undefined) {
	return __imgui_show_debug_log_window(open);
}

/**
	* @function ImGuiShowDemoWindow
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* create Demo window. demonstrate most ImGui features. call this to learn about the library! try to make it always available in your application!
	* @param {Bool} [open=undefined]
	* @return {Bool}
	*/
function ImGuiShowDemoWindow(open=undefined) {
	return __imgui_show_demo_window(open);
}

/**
	* @function ImGuiShowFontSelector
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* add font selector block (not a window), essentially a combo listing the loaded fonts.
	* @param {String} label
	* @return {Undefined}
	*/
function ImGuiShowFontSelector(label) {
	return __imgui_show_font_selector(label);
}

/**
	* @function ImGuiShowIDStackToolWindow
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Bool} [open=undefined]
	* @return {Bool}
	*/
function ImGuiShowIDStackToolWindow(open=undefined) {
	return __imgui_show_stack_tool_window(open);
}

/**
	* @function ImGuiShowMetricsWindow
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* create Metrics/Debugger window. display Dear ImGui internals: windows, draw commands, various internal state, etc.
	* @param {Bool} [open=undefined]
	* @return {Bool}
	*/
function ImGuiShowMetricsWindow(open=undefined) {
	return __imgui_show_metrics_window(open);
}

/**
	* @function ImGuiShowStyleEditor
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* add style editor block (not a window). you can pass in a reference ImGuiStyle structure to compare to, revert to and save to (else it uses the default style)
	* @return {Undefined}
	*/
function ImGuiShowStyleEditor() {
	return __imgui_show_style_editor();
}

/**
	* @function ImGuiShowStyleSelector
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* add style selector block (not a window), essentially a combo listing the default styles.
	* @param {String} label
	* @return {Bool}
	*/
function ImGuiShowStyleSelector(label) {
	return __imgui_show_style_selector(label);
}

/**
	* @function ImGuiShowUserGuide
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* add basic help/info block (not a window): how to manipulate ImGui as an end-user (mouse/keyboard controls).
	* @return {Undefined}
	*/
function ImGuiShowUserGuide() {
	return __imgui_show_user_guide();
}

/**
	* @function ImGuiSliderAngle
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {String} label
	* @param {Real} v_rad
	* @param {Real} [v_degrees_min=0]
	* @param {Real} v_degrees_max
	* @param {String} [format=%d]
	* @param {Enum.ImGuiSliderFlags} [flags=ImGuiSliderFlags.None]
	* @return {Real}
	*/
function ImGuiSliderAngle(label, v_rad, v_degrees_min=0, v_degrees_max, format="%d", flags=ImGuiSliderFlags.None) {
	return __imgui_slider_angle(label, v_rad, v_degrees_min, v_degrees_max, format, flags);
}

/**
	* @function ImGuiSliderFloat
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* adjust format to decorate the value with a prefix or a suffix for in-slider labels or unit display.
	* @param {String} label
	* @param {Real} v
	* @param {Real} [v_min=0]
	* @param {Real} [v_max=0]
	* @param {String} [format=%.3f]
	* @param {Enum.ImGuiSliderFlags} [flags=ImGuiSliderFlags.None]
	* @return {Real}
	*/
function ImGuiSliderFloat(label, v, v_min=0, v_max=0, format="%.3f", flags=ImGuiSliderFlags.None) {
	return __imgui_slider_float(label, v, v_min, v_max, format, flags);
}

/**
	* @function ImGuiSliderFloat2
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {String} label
	* @param {Array} v
	* @param {Real} [v_min=0]
	* @param {Real} [v_max=0]
	* @param {String} [format=%.3f]
	* @param {Enum.ImGuiSliderFlags} [flags=ImGuiSliderFlags.None]
	* @return {Bool}
	*/
function ImGuiSliderFloat2(label, v, v_min=0, v_max=0, format="%.3f", flags=ImGuiSliderFlags.None) {
	return __imgui_slider_float2(label, v, v_min, v_max, format, flags);
}

/**
	* @function ImGuiSliderFloat3
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {String} label
	* @param {Array} v
	* @param {Real} [v_min=0]
	* @param {Real} [v_max=0]
	* @param {String} [format=%.3f]
	* @param {Enum.ImGuiSliderFlags} [flags=ImGuiSliderFlags.None]
	* @return {Bool}
	*/
function ImGuiSliderFloat3(label, v, v_min=0, v_max=0, format="%.3f", flags=ImGuiSliderFlags.None) {
	return __imgui_slider_float3(label, v, v_min, v_max, format, flags);
}

/**
	* @function ImGuiSliderFloat4
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {String} label
	* @param {Array} v
	* @param {Real} [v_min=0]
	* @param {Real} [v_max=0]
	* @param {String} [format=%.3f]
	* @param {Enum.ImGuiSliderFlags} [flags=ImGuiSliderFlags.None]
	* @return {Bool}
	*/
function ImGuiSliderFloat4(label, v, v_min=0, v_max=0, format="%.3f", flags=ImGuiSliderFlags.None) {
	return __imgui_slider_float4(label, v, v_min, v_max, format, flags);
}

/**
	* @function ImGuiSliderFloatN
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {String} label
	* @param {Array} v
	* @param {Real} [v_speed=1]
	* @param {Real} [v_min=0]
	* @param {Real} [v_max=0]
	* @param {String} [format=%.3f]
	* @param {Enum.ImGuiSliderFlags} [flags=ImGuiSliderFlags.None]
	* @return {Bool}
	*/
function ImGuiSliderFloatN(label, v, v_speed=1, v_min=0, v_max=0, format="%.3f", flags=ImGuiSliderFlags.None) {
	return __imgui_slider_float_n(label, v, v_speed, v_min, v_max, format, flags, array_length(v));
}

/**
	* @function ImGuiSliderInt
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {String} label
	* @param {Real} v
	* @param {Real} [v_min=0]
	* @param {Real} [v_max=0]
	* @param {String} [format=%d]
	* @param {Enum.ImGuiSliderFlags} [flags=ImGuiSliderFlags.None]
	* @return {Real}
	*/
function ImGuiSliderInt(label, v, v_min=0, v_max=0, format="%d", flags=ImGuiSliderFlags.None) {
	return __imgui_slider_int(label, v, v_min, v_max, format, flags);
}

/**
	* @function ImGuiSliderInt2
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {String} label
	* @param {Array} v
	* @param {Real} [v_min=0]
	* @param {Real} [v_max=0]
	* @param {String} [format=%d]
	* @param {Enum.ImGuiSliderFlags} [flags=ImGuiSliderFlags.None]
	* @return {Bool}
	*/
function ImGuiSliderInt2(label, v, v_min=0, v_max=0, format="%d", flags=ImGuiSliderFlags.None) {
	return __imgui_slider_int2(label, v, v_min, v_max, format, flags);
}

/**
	* @function ImGuiSliderInt3
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {String} label
	* @param {Array} v
	* @param {Real} [v_min=0]
	* @param {Real} [v_max=0]
	* @param {String} [format=%d]
	* @param {Enum.ImGuiSliderFlags} [flags=ImGuiSliderFlags.None]
	* @return {Bool}
	*/
function ImGuiSliderInt3(label, v, v_min=0, v_max=0, format="%d", flags=ImGuiSliderFlags.None) {
	return __imgui_slider_int3(label, v, v_min, v_max, format, flags);
}

/**
	* @function ImGuiSliderInt4
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {String} label
	* @param {Array} v
	* @param {Real} [v_min=0]
	* @param {Real} [v_max=0]
	* @param {String} [format=%d]
	* @param {Enum.ImGuiSliderFlags} [flags=ImGuiSliderFlags.None]
	* @return {Bool}
	*/
function ImGuiSliderInt4(label, v, v_min=0, v_max=0, format="%d", flags=ImGuiSliderFlags.None) {
	return __imgui_slider_int4(label, v, v_min, v_max, format, flags);
}

/**
	* @function ImGuiSliderIntN
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {String} label
	* @param {Array} v
	* @param {Real} [v_min=0]
	* @param {Real} [v_max=0]
	* @param {String} [format=%d]
	* @param {Enum.ImGuiSliderFlags} [flags=ImGuiSliderFlags.None]
	* @return {Bool}
	*/
function ImGuiSliderIntN(label, v, v_min=0, v_max=0, format="%d", flags=ImGuiSliderFlags.None) {
	return __imgui_slider_int_n(label, v, v_min, v_max, format, flags, array_length(v));
}

/**
	* @function ImGuiSmallButton
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* button with (FramePadding.y == 0) to easily embed within text
	* @param {String} label
	* @return {Bool}
	*/
function ImGuiSmallButton(label) {
	return __imgui_small_button(label);
}

/**
	* @function ImGuiSpacing
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* add vertical spacing.
	* @return {Undefined}
	*/
function ImGuiSpacing() {
	return __imgui_spacing();
}

/**
	* @function ImGuiStyleColorsClassic
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* classic imgui style
	* @return {Undefined}
	*/
function ImGuiStyleColorsClassic() {
	return __imgui_style_colors_classic();
}

/**
	* @function ImGuiStyleColorsDark
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* new, recommended style (default)
	* @return {Undefined}
	*/
function ImGuiStyleColorsDark() {
	return __imgui_style_colors_dark();
}

/**
	* @function ImGuiStyleColorsLight
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* best used with borders and a custom, thicker font
	* @return {Undefined}
	*/
function ImGuiStyleColorsLight() {
	return __imgui_style_colors_light();
}

/**
	* @function ImGuiSurface
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Real} surface
	* @param {Real} [color=c_white]
	* @param {Real} [alpha=1]
	* @param {Real} [width=surface_get_width⌊surface⌉]
	* @param {Real} [height=surface_get_height⌊surface⌉]
	* @return {Undefined}
	*/
function ImGuiSurface(surface, color=c_white, alpha=1, width=surface_get_width(surface), height=surface_get_height(surface)) {
	var _tex = surface_get_texture(surface);
	return __imgui_surface(surface, color, alpha, width, height, texture_get_uvs(_tex));
}

/**
	* @function ImGuiTabItemButton
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* create a Tab behaving like a button. return true when clicked. cannot be selected in the tab bar.
	* @param {String} label
	* @param {Enum.ImGuiTabItemFlags} [flags=ImGuiTabItemFlags.None]
	* @return {Bool}
	*/
function ImGuiTabItemButton(label, flags=ImGuiTabItemFlags.None) {
	return __imgui_tab_item_button(label, flags);
}

/**
	* @function ImGuiTableAngledHeadersRow
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* submit a row with angled headers for every column with the ImGuiTableColumnFlags_AngledHeader flag. MUST BE FIRST ROW.
	* @return {Undefined}
	*/
function ImGuiTableAngledHeadersRow() {
	return __imgui_table_angled_headers_row();
}

/**
	* @function ImGuiTableGetColumnCount
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* return number of columns (value passed to BeginTable)
	* @return {Real}
	*/
function ImGuiTableGetColumnCount() {
	return __imgui_table_get_column_count();
}

/**
	* @function ImGuiTableGetColumnFlags
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* return column flags so you can query their Enabled/Visible/Sorted/Hovered status flags. Pass -1 to use current column.
	* @param {Real} [column_n=-1]
	* @return {Real}
	*/
function ImGuiTableGetColumnFlags(column_n=-1) {
	return __imgui_table_get_column_flags(column_n);
}

/**
	* @function ImGuiTableGetColumnIndex
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* return current column index.
	* @return {Real}
	*/
function ImGuiTableGetColumnIndex() {
	return __imgui_table_get_column_index();
}

/**
	* @function ImGuiTableGetColumnName
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* return "" if column didn't have a name declared by TableSetupColumn(). Pass -1 to use current column.
	* @param {Real} [column_n=-1]
	* @return {String}
	*/
function ImGuiTableGetColumnName(column_n=-1) {
	return __imgui_table_get_column_name(column_n);
}

/**
	* @function ImGuiTableGetHoveredColumn
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* return hovered column. return -1 when table is not hovered. return columns_count if the unused space at the right of visible columns is hovered. Can also use (TableGetColumnFlags() & ImGuiTableColumnFlags_IsHovered) instead.
	* @return {Real}
	*/
function ImGuiTableGetHoveredColumn() {
	return __imgui_table_get_hovered_column();
}

/**
	* @function ImGuiTableGetRowIndex
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* return current row index (header rows are accounted for)
	* @return {Real}
	*/
function ImGuiTableGetRowIndex() {
	return __imgui_table_get_row_index();
}

/**
	* @function ImGuiTableHeader
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* submit one header cell manually (rarely used)
	* @param {String} label
	* @return {Undefined}
	*/
function ImGuiTableHeader(label) {
	return __imgui_table_header(label);
}

/**
	* @function ImGuiTableHeadersRow
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* submit a row with headers cells based on data provided to TableSetupColumn() + submit context menu
	* @return {Undefined}
	*/
function ImGuiTableHeadersRow() {
	return __imgui_table_headers_row();
}

/**
	* @function ImGuiTableNextColumn
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* append into the next column (or first column of next row if currently in last column). Return true when column is visible.
	* @return {Bool}
	*/
function ImGuiTableNextColumn() {
	return __imgui_table_next_column();
}

/**
	* @function ImGuiTableNextRow
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* append into the first cell of a new row.
	* @param {Enum.ImGuiTableRowFlags} [row_flags=ImGuiTableRowFlags.None]
	* @param {Real} [min_row_height=0]
	* @return {Undefined}
	*/
function ImGuiTableNextRow(row_flags=ImGuiTableRowFlags.None, min_row_height=0) {
	return __imgui_table_next_row(row_flags, min_row_height);
}

/**
	* @function ImGuiTableSetBgColor
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* change the color of a cell, row, or column. See ImGuiTableBgTarget_ flags for details.
	* @param {Real} target
	* @param {Real} col
	* @param {Real} [column_n=-1]
	* @return {Undefined}
	*/
function ImGuiTableSetBgColor(target, col, column_n=-1) {
	return __imgui_table_set_bg_color(target, col, column_n);
}

/**
	* @function ImGuiTableSetColumnEnabled
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* change user accessible enabled/disabled state of a column. Set to false to hide the column. User can use the context menu to change this themselves (right-click in headers, or right-click in columns body with ImGuiTableFlags_ContextMenuInBody)
	* @param {Real} column_n
	* @param {Bool} v
	* @return {Undefined}
	*/
function ImGuiTableSetColumnEnabled(column_n, v) {
	return __imgui_table_set_column_enabled(column_n, v);
}

/**
	* @function ImGuiTableSetColumnIndex
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* append into the specified column. Return true when column is visible.
	* @param {Real} column_n
	* @return {Bool}
	*/
function ImGuiTableSetColumnIndex(column_n) {
	return __imgui_table_set_column_index(column_n);
}

/**
	* @function ImGuiTableSetupColumn
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {String} label
	* @param {Enum.ImGuiTableColumnFlags} [flags=ImGuiTableColumnFlags.None]
	* @param {Real} [user_id=0]
	* @return {Undefined}
	*/
function ImGuiTableSetupColumn(label, flags=ImGuiTableColumnFlags.None, user_id=0) {
	return __imgui_table_setup_column(label, flags, user_id);
}

/**
	* @function ImGuiTableSetupScrollFreeze
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* lock columns/rows so they stay visible when scrolled.
	* @param {Real} cols
	* @param {Real} rows
	* @return {Undefined}
	*/
function ImGuiTableSetupScrollFreeze(cols, rows) {
	return __imgui_table_setup_scroll_freeze(cols, rows);
}

/**
	* @function ImGuiText
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {String} val
	* @return {Undefined}
	*/
function ImGuiText(val) {
	return __imgui_text(val);
}

/**
	* @function ImGuiTextColored
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {String} val
	* @param {Real} color
	* @param {Real} [alpha=1]
	* @return {Undefined}
	*/
function ImGuiTextColored(val, color, alpha=1) {
	return __imgui_text_colored(val, color, alpha);
}

/**
	* @function ImGuiTextDisabled
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {String} val
	* @return {Undefined}
	*/
function ImGuiTextDisabled(val) {
	return __imgui_text_disabled(val);
}

/**
	* @function ImGuiTextLink
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* hyperlink text button, return true when clicked
	* @param {String} label
	* @return {Undefined}
	*/
function ImGuiTextLink(label) {
	return __imgui_text_link(label);
}

/**
	* @function ImGuiTextLinkOpenURL
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {String} label
	* @param {String} url
	* @return {Undefined}
	*/
function ImGuiTextLinkOpenURL(label, url) {
	return __imgui_text_link_open_url(label, url);
}

/**
	* @function ImGuiTextUnformatted
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* raw text without formatting. Roughly equivalent to Text("%s", text) but: A) doesn't require null terminated string if 'text_end' is specified, B) it's faster, no memory copy is done, no buffer size limits, recommended for long chunks of text.
	* @param {String} text
	* @return {Undefined}
	*/
function ImGuiTextUnformatted(text) {
	return __imgui_text_unformatted(text);
}

/**
	* @function ImGuiTextWrapped
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {String} val
	* @return {Undefined}
	*/
function ImGuiTextWrapped(val) {
	return __imgui_text_wrapped(val);
}

/**
	* @function ImGuiTreeNode
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {String} label
	* @return {Bool}
	*/
function ImGuiTreeNode(label) {
	return __imgui_tree_node(label);
}

/**
	* @function ImGuiTreeNodeEx
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {String} label
	* @param {Enum.ImGuiTreeNodeFlags} [flags=ImGuiTreeNodeFlags.None]
	* @return {Bool}
	*/
function ImGuiTreeNodeEx(label, flags=ImGuiTreeNodeFlags.None) {
	return __imgui_tree_node_ex(label, flags);
}

/**
	* @function ImGuiTreePop
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* ~ Unindent()+PopID()
	* @return {Undefined}
	*/
function ImGuiTreePop() {
	return __imgui_tree_pop();
}

/**
	* @function ImGuiTreePush
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* ~ Indent()+PushID(). Already called by TreeNode() when returning true, but you can call TreePush/TreePop yourself if desired.
	* @param {String} str_id
	* @return {Undefined}
	*/
function ImGuiTreePush(str_id) {
	return __imgui_tree_push(str_id);
}

/**
	* @function ImGuiUnindent
	* @context ImGui
	* @desc ImGui function wrapper.
	*
	* move content position back to the left, by indent_w, or style.IndentSpacing if indent_w <= 0
	* @param {Real} [indent_w=0]
	* @return {Undefined}
	*/
function ImGuiUnindent(indent_w=0) {
	return __imgui_unindent(indent_w);
}

/**
	* @function ImGuiValue
	* @context ImGui
	* @desc ImGui function wrapper.
	* @return {undefined}
	*/
function ImGuiValue() {
	return __imgui_value();
}

/**
	* @function ImGuiVSliderFloat
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {String} label
	* @param {Real} width
	* @param {Real} height
	* @param {Real} v
	* @param {Real} [v_min=0]
	* @param {Real} [v_max=0]
	* @param {String} [format=%.3f]
	* @param {Enum.ImGuiSliderFlags} [flags=ImGuiSliderFlags.None]
	* @return {Real}
	*/
function ImGuiVSliderFloat(label, width, height, v, v_min=0, v_max=0, format="%.3f", flags=ImGuiSliderFlags.None) {
	return __imgui_v_slider_float(label, width, height, v, v_min, v_max, format, flags);
}

/**
	* @function ImGuiVSliderInt
	* @context ImGui
	* @desc ImGui function wrapper.
	* @param {String} label
	* @param {Real} width
	* @param {Real} height
	* @param {Real} v
	* @param {Real} [v_min=0]
	* @param {Real} [v_max=0]
	* @param {String} [format=%d]
	* @param {Enum.ImGuiSliderFlags} [flags=ImGuiSliderFlags.None]
	* @return {Real}
	*/
function ImGuiVSliderInt(label, width, height, v, v_min=0, v_max=0, format="%d", flags=ImGuiSliderFlags.None) {
	return __imgui_v_slider_int(label, width, height, v, v_min, v_max, format, flags);
}

/**
	* @function ImGuiWantKeyboardCapture
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Bool} [val=undefined]
	* @return {Bool}
	*/
function ImGuiWantKeyboardCapture(val=undefined) {
	return __imgui_want_keyboard_capture(val);
}

/**
	* @function ImGuiWantMouseCapture
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Bool} [val=undefined]
	* @return {Bool}
	*/
function ImGuiWantMouseCapture(val=undefined) {
	return __imgui_want_mouse_capture(val);
}
    
/**
	* @function ImGuiWantMouseCaptureUnlessPopupClose
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Bool} [val=undefined]
	* @return {Bool}
	*/
function ImGuiWantMouseCaptureUnlessPopupClose(val=undefined) {
	return __imgui_want_mouse_unless_popup_close(val);
}

/**
	* @function ImGuiWantSaveIniSettings
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Bool} [val=undefined]
	* @return {Bool}
	*/
function ImGuiWantSaveIniSettings(val=undefined) {
	return __imgui_want_save_ini_settings(val);
}

/**
	* @function ImGuiWantTextInput
	* @context ImGui
	* @desc ImGui custom wrapper.
	* @param {Bool} [val=undefined]
	* @return {Bool}
	*/
function ImGuiWantTextInput(val=undefined) {
	return __imgui_want_text_input(val);
}