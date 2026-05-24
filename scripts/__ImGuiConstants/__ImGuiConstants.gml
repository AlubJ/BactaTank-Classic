// Feather disable all

#macro IMGM_EDIT_VERSION  "0.1.0"
#macro IMGM_EDIT_DATE     "2025-11-25"

#macro IMGM_VERSION  (extension_get_version("__ImGMExtension"))

#macro IMGM_RUNNING_FROM_IDE  (GM_build_type == "run")

/**
 * @enum ImGuiReturnMask
 * @context ImGM
 * @desc You can use this in various GML wrapper functions as an argument to specify the return value type.
 * Or to mask the return value, if you use `ImGuiReturnMask.Both`.
 * Defaults to ImGuiReturnMask.Return
 *
 * @example
 *
 * // Mostly used like this
 * var ret = ImGui.Begin("ImGM Example", is_open, ImGuiWindowFlags.None, ImGuiReturnMask.Both);
 * is_open = ret & ImGuiReturnMask.Pointer;
 * if (ret & ImGuiReturnMask.Return) { inner ImGui code... }
 *
 */
enum ImGuiReturnMask {
    None = 0,            // Should be unused
    Return = 1 << 0,
    Pointer = 1 << 1,
    Both = ImGuiReturnMask.Return | ImGuiReturnMask.Pointer
}

/**
	* @enum ImGuiWindowFlags
	* @desc Flags for ImGui::Begin()
	*
	*/
enum ImGuiWindowFlags {
	None = 0,
	NoTitleBar = 1 << 0,
	NoResize = 1 << 1,
	NoMove = 1 << 2,
	NoScrollbar = 1 << 3,
	NoScrollWithMouse = 1 << 4,
	NoCollapse = 1 << 5,
	AlwaysAutoResize = 1 << 6,
	NoBackground = 1 << 7,
	NoSavedSettings = 1 << 8,
	NoMouseInputs = 1 << 9,
	MenuBar = 1 << 10,
	HorizontalScrollbar = 1 << 11,
	NoFocusOnAppearing = 1 << 12,
	NoBringToFrontOnFocus = 1 << 13,
	AlwaysVerticalScrollbar = 1 << 14,
	AlwaysHorizontalScrollbar = 1 << 15,
	NoNavInputs = 1 << 16,
	NoNavFocus = 1 << 17,
	UnsavedDocument = 1 << 18,
	NoDocking = 1 << 19,
	NoNav = ImGuiWindowFlags.NoNavInputs | ImGuiWindowFlags.NoNavFocus,
	NoDecoration = ImGuiWindowFlags.NoTitleBar | ImGuiWindowFlags.NoResize | ImGuiWindowFlags.NoScrollbar | ImGuiWindowFlags.NoCollapse,
	NoInputs = ImGuiWindowFlags.NoMouseInputs | ImGuiWindowFlags.NoNavInputs | ImGuiWindowFlags.NoNavFocus,
	DockNodeHost = 1 << 23,
	ChildWindow = 1 << 24,
	Tooltip = 1 << 25,
	Popup = 1 << 26,
	Modal = 1 << 27,
	ChildMenu = 1 << 28,
	NavFlattened = 1 << 29,
	AlwaysUseWindowPadding = 1 << 30,
}

/**
	* @enum ImGuiChildFlags
	* @desc Flags for ImGui::BeginChild()
	*
	*/
enum ImGuiChildFlags {
	None = 0,
	Borders = 1 << 0,
	AlwaysUseWindowPadding = 1 << 1,
	ResizeX = 1 << 2,
	ResizeY = 1 << 3,
	AutoResizeX = 1 << 4,
	AutoResizeY = 1 << 5,
	AlwaysAutoResize = 1 << 6,
	FrameStyle = 1 << 7,
	NavFlattened = 1 << 8,
	Border = ImGuiChildFlags.Borders,
}

/**
	* @enum ImGuiItemFlags
	* @desc Flags for ImGui::PushItemFlag()
	*
	*/
enum ImGuiItemFlags {
	None = 0,
	NoTabStop = 1 << 0,
	NoNav = 1 << 1,
	NoNavDefaultFocus = 1 << 2,
	ButtonRepeat = 1 << 3,
	AutoClosePopups = 1 << 4,
	AllowDuplicateId = 1 << 5,
}

/**
	* @enum ImGuiInputTextFlags
	* @desc Flags for ImGui::InputText()
	*
	*/
enum ImGuiInputTextFlags {
	None = 0,
	CharsDecimal = 1 << 0,
	CharsHexadecimal = 1 << 1,
	CharsScientific = 1 << 2,
	CharsUppercase = 1 << 3,
	CharsNoBlank = 1 << 4,
	AllowTabInput = 1 << 5,
	EnterReturnsTrue = 1 << 6,
	EscapeClearsAll = 1 << 7,
	CtrlEnterForNewLine = 1 << 8,
	ReadOnly = 1 << 9,
	Password = 1 << 10,
	AlwaysOverwrite = 1 << 11,
	AutoSelectAll = 1 << 12,
	ParseEmptyRefVal = 1 << 13,
	DisplayEmptyRefVal = 1 << 14,
	NoHorizontalScroll = 1 << 15,
	NoUndoRedo = 1 << 16,
	ElideLeft = 1 << 17,
	CallbackCompletion = 1 << 18,
	CallbackHistory = 1 << 19,
	CallbackAlways = 1 << 20,
	CallbackCharFilter = 1 << 21,
	CallbackResize = 1 << 22,
	CallbackEdit = 1 << 23,
}

/**
	* @enum ImGuiTreeNodeFlags
	* @desc Flags for ImGui::TreeNodeEx(), ImGui::CollapsingHeader*()
	*
	*/
enum ImGuiTreeNodeFlags {
	None = 0,
	Selected = 1 << 0,
	Framed = 1 << 1,
	AllowOverlap = 1 << 2,
	NoTreePushOnOpen = 1 << 3,
	NoAutoOpenOnLog = 1 << 4,
	DefaultOpen = 1 << 5,
	OpenOnDoubleClick = 1 << 6,
	OpenOnArrow = 1 << 7,
	Leaf = 1 << 8,
	Bullet = 1 << 9,
	FramePadding = 1 << 10,
	SpanAvailWidth = 1 << 11,
	SpanFullWidth = 1 << 12,
	SpanLabelWidth = 1 << 13,
	SpanAllColumns = 1 << 14,
	LabelSpanAllColumns = 1 << 15,
	NavLeftJumpsToParent = 1 << 17,
	CollapsingHeader = ImGuiTreeNodeFlags.Framed | ImGuiTreeNodeFlags.NoTreePushOnOpen | ImGuiTreeNodeFlags.NoAutoOpenOnLog,
	DrawLinesNone = 1 << 18,
	DrawLinesFull = 1 << 19,
	DrawLinesToNodes = 1 << 20,
	NavLeftJumpsBackHere = ImGuiTreeNodeFlags.NavLeftJumpsToParent,
	SpanTextWidth = ImGuiTreeNodeFlags.SpanLabelWidth,
	AllowItemOverlap = ImGuiTreeNodeFlags.AllowOverlap,
}

/**
	* @enum ImGuiPopupFlags
	* @desc Flags for OpenPopup*(), BeginPopupContext*(), IsPopupOpen() functions.
	*
	*/
enum ImGuiPopupFlags {
	None = 0,
	MouseButtonLeft = 0,
	MouseButtonRight = 1,
	MouseButtonMiddle = 2,
	MouseButtonMask_ = 0x1F,
	MouseButtonDefault_ = 1,
	NoReopen = 1 << 5,
	NoOpenOverExistingPopup = 1 << 7,
	NoOpenOverItems = 1 << 8,
	AnyPopupId = 1 << 10,
	AnyPopupLevel = 1 << 11,
	AnyPopup = ImGuiPopupFlags.AnyPopupId | ImGuiPopupFlags.AnyPopupLevel,
}

/**
	* @enum ImGuiSelectableFlags
	* @desc Flags for ImGui::Selectable()
	*
	*/
enum ImGuiSelectableFlags {
	None = 0,
	NoAutoClosePopups = 1 << 0,
	SpanAllColumns = 1 << 1,
	AllowDoubleClick = 1 << 2,
	Disabled = 1 << 3,
	AllowOverlap = 1 << 4,
	Highlight = 1 << 5,
	DontClosePopups = ImGuiSelectableFlags.NoAutoClosePopups,
	AllowItemOverlap = ImGuiSelectableFlags.AllowOverlap,
}

/**
	* @enum ImGuiComboFlags
	* @desc Flags for ImGui::BeginCombo()
	*
	*/
enum ImGuiComboFlags {
	None = 0,
	PopupAlignLeft = 1 << 0,
	HeightSmall = 1 << 1,
	HeightRegular = 1 << 2,
	HeightLarge = 1 << 3,
	HeightLargest = 1 << 4,
	NoArrowButton = 1 << 5,
	NoPreview = 1 << 6,
	WidthFitPreview = 1 << 7,
	HeightMask_ = ImGuiComboFlags.HeightSmall | ImGuiComboFlags.HeightRegular | ImGuiComboFlags.HeightLarge | ImGuiComboFlags.HeightLargest,
}

/**
	* @enum ImGuiTabBarFlags
	* @desc Flags for ImGui::BeginTabBar()
	*
	*/
enum ImGuiTabBarFlags {
	None = 0,
	Reorderable = 1 << 0,
	AutoSelectNewTabs = 1 << 1,
	TabListPopupButton = 1 << 2,
	NoCloseWithMiddleMouseButton = 1 << 3,
	NoTabListScrollingButtons = 1 << 4,
	NoTooltip = 1 << 5,
	DrawSelectedOverline = 1 << 6,
	FittingPolicyMixed = 1 << 7,
	FittingPolicyShrink = 1 << 8,
	FittingPolicyScroll = 1 << 9,
	FittingPolicyMask_ = ImGuiTabBarFlags.FittingPolicyMixed | ImGuiTabBarFlags.FittingPolicyShrink | ImGuiTabBarFlags.FittingPolicyScroll,
	FittingPolicyDefault_ = ImGuiTabBarFlags.FittingPolicyMixed,
	FittingPolicyResizeDown = ImGuiTabBarFlags.FittingPolicyShrink,
}

/**
	* @enum ImGuiTabItemFlags
	* @desc Flags for ImGui::BeginTabItem()
	*
	*/
enum ImGuiTabItemFlags {
	None = 0,
	UnsavedDocument = 1 << 0,
	SetSelected = 1 << 1,
	NoCloseWithMiddleMouseButton = 1 << 2,
	NoPushId = 1 << 3,
	NoTooltip = 1 << 4,
	NoReorder = 1 << 5,
	Leading = 1 << 6,
	Trailing = 1 << 7,
	NoAssumedClosure = 1 << 8,
}

/**
	* @enum ImGuiFocusedFlags
	* @desc Flags for ImGui::IsWindowFocused()
	*
	*/
enum ImGuiFocusedFlags {
	None = 0,
	ChildWindows = 1 << 0,
	RootWindow = 1 << 1,
	AnyWindow = 1 << 2,
	NoPopupHierarchy = 1 << 3,
	DockHierarchy = 1 << 4,
	RootAndChildWindows = ImGuiFocusedFlags.RootWindow | ImGuiFocusedFlags.ChildWindows,
}

/**
	* @enum ImGuiHoveredFlags
	* @desc Flags for ImGui::IsItemHovered(), ImGui::IsWindowHovered()
	*
	*/
enum ImGuiHoveredFlags {
	None = 0,
	ChildWindows = 1 << 0,
	RootWindow = 1 << 1,
	AnyWindow = 1 << 2,
	NoPopupHierarchy = 1 << 3,
	DockHierarchy = 1 << 4,
	AllowWhenBlockedByPopup = 1 << 5,
	AllowWhenBlockedByActiveItem = 1 << 7,
	AllowWhenOverlappedByItem = 1 << 8,
	AllowWhenOverlappedByWindow = 1 << 9,
	AllowWhenDisabled = 1 << 10,
	NoNavOverride = 1 << 11,
	AllowWhenOverlapped = ImGuiHoveredFlags.AllowWhenOverlappedByItem | ImGuiHoveredFlags.AllowWhenOverlappedByWindow,
	RectOnly = ImGuiHoveredFlags.AllowWhenBlockedByPopup | ImGuiHoveredFlags.AllowWhenBlockedByActiveItem | ImGuiHoveredFlags.AllowWhenOverlapped,
	RootAndChildWindows = ImGuiHoveredFlags.RootWindow | ImGuiHoveredFlags.ChildWindows,
	ForTooltip = 1 << 12,
	Stationary = 1 << 13,
	DelayNone = 1 << 14,
	DelayShort = 1 << 15,
	DelayNormal = 1 << 16,
	NoSharedDelay = 1 << 17,
}

/**
	* @enum ImGuiDockNodeFlags
	* @desc Flags for ImGui::DockSpace(), shared/inherited by child nodes.
	*
	*/
enum ImGuiDockNodeFlags {
	None = 0,
	KeepAliveOnly = 1 << 0,
	NoDockingOverCentralNode = 1 << 2,
	PassthruCentralNode = 1 << 3,
	NoDockingSplit = 1 << 4,
	NoResize = 1 << 5,
	AutoHideTabBar = 1 << 6,
	NoUndocking = 1 << 7,
	NoSplit = ImGuiDockNodeFlags.NoDockingSplit,
	NoDockingInCentralNode = ImGuiDockNodeFlags.NoDockingOverCentralNode,
}

/**
	* @enum ImGuiDragDropFlags
	* @desc Flags for ImGui::BeginDragDropSource(), ImGui::AcceptDragDropPayload()
	*
	*/
enum ImGuiDragDropFlags {
	None = 0,
	SourceNoPreviewTooltip = 1 << 0,
	SourceNoDisableHover = 1 << 1,
	SourceNoHoldToOpenOthers = 1 << 2,
	SourceAllowNullID = 1 << 3,
	SourceExtern = 1 << 4,
	PayloadAutoExpire = 1 << 5,
	PayloadNoCrossContext = 1 << 6,
	PayloadNoCrossProcess = 1 << 7,
	AcceptBeforeDelivery = 1 << 10,
	AcceptNoDrawDefaultRect = 1 << 11,
	AcceptNoPreviewTooltip = 1 << 12,
	AcceptPeekOnly = ImGuiDragDropFlags.AcceptBeforeDelivery | ImGuiDragDropFlags.AcceptNoDrawDefaultRect,
	SourceAutoExpirePayload = ImGuiDragDropFlags.PayloadAutoExpire,
}

/**
	* @enum ImGuiDataType
	* @desc float[4]: Standard type for colors. User code may use this type.
	*
	*/
enum ImGuiDataType {
	S8,
	U8,
	S16,
	U16,
	S32,
	U32,
	S64,
	U64,
	Float,
	Double,
	Bool,
	String,
}

/**
	* @enum ImGuiDir
	* @desc A cardinal direction
	*
	*/
enum ImGuiDir {
	None = - 1,
	Left = 0,
	Right = 1,
	Up = 2,
	Down = 3,
}

/**
	* @enum ImGuiSortDirection
	* @desc A sorting direction
	*
	*/
enum ImGuiSortDirection {
	None = 0,
	Ascending = 1,
	Descending = 2,
}

/**
	* @enum ImGuiInputFlags
	* @desc Flags for Shortcut(), SetNextItemShortcut(),
	*
	*/
enum ImGuiInputFlags {
	None = 0,
	Repeat = 1 << 0,
	RouteActive = 1 << 10,
	RouteFocused = 1 << 11,
	RouteGlobal = 1 << 12,
	RouteAlways = 1 << 13,
	RouteOverFocused = 1 << 14,
	RouteOverActive = 1 << 15,
	RouteUnlessBgFocused = 1 << 16,
	RouteFromRootWindow = 1 << 17,
	Tooltip = 1 << 18,
}

/**
	* @enum ImGuiConfigFlags
	* @desc Configuration flags stored in io.ConfigFlags. Set by user/application.
	*
	*/
enum ImGuiConfigFlags {
	None = 0,
	NavEnableKeyboard = 1 << 0,
	NavEnableGamepad = 1 << 1,
	NoMouse = 1 << 4,
	NoMouseCursorChange = 1 << 5,
	NoKeyboard = 1 << 6,
	DockingEnable = 1 << 7,
	//ViewportsEnable = 1 << 10, //Unsupported
	IsSRGB = 1 << 20,
	IsTouchScreen = 1 << 21,
	NavEnableSetMousePos = 1 << 2,
	NavNoCaptureKeyboard = 1 << 3,
	DpiEnableScaleFonts = 1 << 14,
	DpiEnableScaleViewports = 1 << 15,
}

/**
	* @enum ImGuiBackendFlags
	* @desc Backend capabilities flags stored in io.BackendFlags. Set by imgui_impl_xxx or custom backend.
	*
	*/
enum ImGuiBackendFlags {
	None = 0,
	HasGamepad = 1 << 0,
	HasMouseCursors = 1 << 1,
	HasSetMousePos = 1 << 2,
	RendererHasVtxOffset = 1 << 3,
	RendererHasTextures = 1 << 4,
	PlatformHasViewports = 1 << 10,
	HasMouseHoveredViewport = 1 << 11,
	RendererHasViewports = 1 << 12,
}

/**
	* @enum ImGuiCol
	* @desc Enumeration for PushStyleColor() / PopStyleColor()
	*
	*/
enum ImGuiCol {
	Text,
	TextDisabled,
	WindowBg,
	ChildBg,
	PopupBg,
	Border,
	BorderShadow,
	FrameBg,
	FrameBgHovered,
	FrameBgActive,
	TitleBg,
	TitleBgActive,
	TitleBgCollapsed,
	MenuBarBg,
	ScrollbarBg,
	ScrollbarGrab,
	ScrollbarGrabHovered,
	ScrollbarGrabActive,
	CheckMark,
	SliderGrab,
	SliderGrabActive,
	Button,
	ButtonHovered,
	ButtonActive,
	Header,
	HeaderHovered,
	HeaderActive,
	Separator,
	SeparatorHovered,
	SeparatorActive,
	ResizeGrip,
	ResizeGripHovered,
	ResizeGripActive,
	InputTextCursor,
	TabHovered,
	Tab,
	TabSelected,
	TabSelectedOverline,
	TabDimmed,
	TabDimmedSelected,
	TabDimmedSelectedOverline,
	DockingPreview,
	DockingEmptyBg,
	PlotLines,
	PlotLinesHovered,
	PlotHistogram,
	PlotHistogramHovered,
	TableHeaderBg,
	TableBorderStrong,
	TableBorderLight,
	TableRowBg,
	TableRowBgAlt,
	TextLink,
	TextSelectedBg,
	TreeLines,
	DragDropTarget,
	NavCursor,
	NavWindowingHighlight,
	NavWindowingDimBg,
	ModalWindowDimBg,
	COUNT,
	TabActive = ImGuiCol.TabSelected,
	TabUnfocused = ImGuiCol.TabDimmed,
	TabUnfocusedActive = ImGuiCol.TabDimmedSelected,
	NavHighlight = ImGuiCol.NavCursor,
}

/**
	* @enum ImGuiStyleVar
	* @desc Enumeration for PushStyleVar() / PopStyleVar() to temporarily modify the ImGuiStyle structure.
	*
	*/
enum ImGuiStyleVar {
	Alpha,
	DisabledAlpha,
	WindowPadding,
	WindowRounding,
	WindowBorderSize,
	WindowMinSize,
	WindowTitleAlign,
	ChildRounding,
	ChildBorderSize,
	PopupRounding,
	PopupBorderSize,
	FramePadding,
	FrameRounding,
	FrameBorderSize,
	ItemSpacing,
	ItemInnerSpacing,
	IndentSpacing,
	CellPadding,
	ScrollbarSize,
	ScrollbarRounding,
	GrabMinSize,
	GrabRounding,
	ImageBorderSize,
	TabRounding,
	TabBorderSize,
	TabMinWidthBase,
	TabMinWidthShrink,
	TabBarBorderSize,
	TabBarOverlineSize,
	TableAngledHeadersAngle,
	TableAngledHeadersTextAlign,
	TreeLinesSize,
	TreeLinesRounding,
	ButtonTextAlign,
	SelectableTextAlign,
	SeparatorTextBorderSize,
	SeparatorTextAlign,
	SeparatorTextPadding,
	DockingSeparatorSize,
}

/**
	* @enum ImGuiButtonFlags
	* @desc Flags for InvisibleButton() [extended in imgui_internal.h]
	*
	*/
enum ImGuiButtonFlags {
	None = 0,
	MouseButtonLeft = 1 << 0,
	MouseButtonRight = 1 << 1,
	MouseButtonMiddle = 1 << 2,
	MouseButtonMask_ = ImGuiButtonFlags.MouseButtonLeft | ImGuiButtonFlags.MouseButtonRight | ImGuiButtonFlags.MouseButtonMiddle,
	EnableNav = 1 << 3,
}

/**
	* @enum ImGuiColorEditFlags
	* @desc Flags for ColorEdit3() / ColorEdit4() / ColorPicker3() / ColorPicker4() / ColorButton()
	*
	*/
enum ImGuiColorEditFlags {
	None = 0,
	NoAlpha = 1 << 1,
	NoPicker = 1 << 2,
	NoOptions = 1 << 3,
	NoSmallPreview = 1 << 4,
	NoInputs = 1 << 5,
	NoTooltip = 1 << 6,
	NoLabel = 1 << 7,
	NoSidePreview = 1 << 8,
	NoDragDrop = 1 << 9,
	NoBorder = 1 << 10,
	AlphaOpaque = 1 << 11,
	AlphaNoBg = 1 << 12,
	AlphaPreviewHalf = 1 << 13,
	AlphaBar = 1 << 16,
	HDR = 1 << 19,
	DisplayRGB = 1 << 20,
	DisplayHSV = 1 << 21,
	DisplayHex = 1 << 22,
	Uint8 = 1 << 23,
	Float = 1 << 24,
	PickerHueBar = 1 << 25,
	PickerHueWheel = 1 << 26,
	InputRGB = 1 << 27,
	InputHSV = 1 << 28,
	DefaultOptions_ = ImGuiColorEditFlags.Uint8 | ImGuiColorEditFlags.DisplayRGB | ImGuiColorEditFlags.InputRGB | ImGuiColorEditFlags.PickerHueBar,
	AlphaMask_ = ImGuiColorEditFlags.NoAlpha | ImGuiColorEditFlags.AlphaOpaque | ImGuiColorEditFlags.AlphaNoBg | ImGuiColorEditFlags.AlphaPreviewHalf,
	DisplayMask_ = ImGuiColorEditFlags.DisplayRGB | ImGuiColorEditFlags.DisplayHSV | ImGuiColorEditFlags.DisplayHex,
	DataTypeMask_ = ImGuiColorEditFlags.Uint8 | ImGuiColorEditFlags.Float,
	PickerMask_ = ImGuiColorEditFlags.PickerHueWheel | ImGuiColorEditFlags.PickerHueBar,
	InputMask_ = ImGuiColorEditFlags.InputRGB | ImGuiColorEditFlags.InputHSV,
	AlphaPreview = 0,
}

/**
	* @enum ImGuiSliderFlags
	* @desc Flags for DragFloat(), DragInt(), SliderFloat(), SliderInt() etc.
	*
	*/
enum ImGuiSliderFlags {
	None = 0,
	Logarithmic = 1 << 5,
	NoRoundToFormat = 1 << 6,
	NoInput = 1 << 7,
	WrapAround = 1 << 8,
	ClampOnInput = 1 << 9,
	ClampZeroRange = 1 << 10,
	NoSpeedTweaks = 1 << 11,
	AlwaysClamp = ImGuiSliderFlags.ClampOnInput | ImGuiSliderFlags.ClampZeroRange,
	InvalidMask_ = 0x7000000F,
}

/**
	* @enum ImGuiMouseButton
	* @desc Identify a mouse button.
	*
	*/
enum ImGuiMouseButton {
	Left = 0,
	Right = 1,
	Middle = 2,
	COUNT = 5,
}

/**
	* @enum ImGuiMouseCursor
	* @desc Enumeration for GetMouseCursor()
	*
	*/
enum ImGuiMouseCursor {
	None = - 1,
	Arrow = 0,
	TextInput,
	ResizeAll,
	ResizeNS,
	ResizeEW,
	ResizeNESW,
	ResizeNWSE,
	Hand,
	Wait,
	Progress,
	NotAllowed,
}

/**
	* @enum ImGuiMouseSource
	* @desc Enumeration for AddMouseSourceEvent() actual source of Mouse Input data.
	*
	*/
enum ImGuiMouseSource {
	Mouse = 0,
	TouchScreen,
	Pen,
}

/**
	* @enum ImGuiCond
	* @desc Enumeration for ImGui::SetNextWindow***(), SetWindow***(), SetNextItem***() functions
	*
	*/
enum ImGuiCond {
	None = 0,
	Always = 1 << 0,
	Once = 1 << 1,
	FirstUseEver = 1 << 2,
	Appearing = 1 << 3,
}

/**
	* @enum ImGuiTableFlags
	* @desc Flags for ImGui::BeginTable()
	*
	*/
enum ImGuiTableFlags {
	None = 0,
	Resizable = 1 << 0,
	Reorderable = 1 << 1,
	Hideable = 1 << 2,
	Sortable = 1 << 3,
	NoSavedSettings = 1 << 4,
	ContextMenuInBody = 1 << 5,
	RowBg = 1 << 6,
	BordersInnerH = 1 << 7,
	BordersOuterH = 1 << 8,
	BordersInnerV = 1 << 9,
	BordersOuterV = 1 << 10,
	BordersH = ImGuiTableFlags.BordersInnerH | ImGuiTableFlags.BordersOuterH,
	BordersV = ImGuiTableFlags.BordersInnerV | ImGuiTableFlags.BordersOuterV,
	BordersInner = ImGuiTableFlags.BordersInnerV | ImGuiTableFlags.BordersInnerH,
	BordersOuter = ImGuiTableFlags.BordersOuterV | ImGuiTableFlags.BordersOuterH,
	Borders = ImGuiTableFlags.BordersInner | ImGuiTableFlags.BordersOuter,
	NoBordersInBody = 1 << 11,
	NoBordersInBodyUntilResize = 1 << 12,
	SizingFixedFit = 1 << 13,
	SizingFixedSame = 2 << 13,
	SizingStretchProp = 3 << 13,
	SizingStretchSame = 4 << 13,
	NoHostExtendX = 1 << 16,
	NoHostExtendY = 1 << 17,
	NoKeepColumnsVisible = 1 << 18,
	PreciseWidths = 1 << 19,
	NoClip = 1 << 20,
	PadOuterX = 1 << 21,
	NoPadOuterX = 1 << 22,
	NoPadInnerX = 1 << 23,
	ScrollX = 1 << 24,
	ScrollY = 1 << 25,
	SortMulti = 1 << 26,
	SortTristate = 1 << 27,
	HighlightHoveredColumn = 1 << 28,
	SizingMask_ = ImGuiTableFlags.SizingFixedFit | ImGuiTableFlags.SizingFixedSame | ImGuiTableFlags.SizingStretchProp | ImGuiTableFlags.SizingStretchSame,
}

/**
	* @enum ImGuiTableColumnFlags
	* @desc Flags for ImGui::TableSetupColumn()
	*
	*/
enum ImGuiTableColumnFlags {
	None = 0,
	Disabled = 1 << 0,
	DefaultHide = 1 << 1,
	DefaultSort = 1 << 2,
	WidthStretch = 1 << 3,
	WidthFixed = 1 << 4,
	NoResize = 1 << 5,
	NoReorder = 1 << 6,
	NoHide = 1 << 7,
	NoClip = 1 << 8,
	NoSort = 1 << 9,
	NoSortAscending = 1 << 10,
	NoSortDescending = 1 << 11,
	NoHeaderLabel = 1 << 12,
	NoHeaderWidth = 1 << 13,
	PreferSortAscending = 1 << 14,
	PreferSortDescending = 1 << 15,
	IndentEnable = 1 << 16,
	IndentDisable = 1 << 17,
	AngledHeader = 1 << 18,
	IsEnabled = 1 << 24,
	IsVisible = 1 << 25,
	IsSorted = 1 << 26,
	IsHovered = 1 << 27,
	WidthMask_ = ImGuiTableColumnFlags.WidthStretch | ImGuiTableColumnFlags.WidthFixed,
	IndentMask_ = ImGuiTableColumnFlags.IndentEnable | ImGuiTableColumnFlags.IndentDisable,
	StatusMask_ = ImGuiTableColumnFlags.IsEnabled | ImGuiTableColumnFlags.IsVisible | ImGuiTableColumnFlags.IsSorted | ImGuiTableColumnFlags.IsHovered,
	NoDirectResize_ = 1 << 30,
}

/**
	* @enum ImGuiTableRowFlags
	* @desc Flags for ImGui::TableNextRow()
	*
	*/
enum ImGuiTableRowFlags {
	None = 0,
	Headers = 1 << 0,
}

/**
	* @enum ImGuiTableBgTarget
	* @desc Enum for ImGui::TableSetBgColor()
	*
	*/
enum ImGuiTableBgTarget {
	None = 0,
	RowBg0 = 1,
	RowBg1 = 2,
	CellBg = 3,
}

/**
	* @enum ImGuiMultiSelectFlags
	* @desc Multi-selection system
	*
	*/
enum ImGuiMultiSelectFlags {
	None = 0,
	SingleSelect = 1 << 0,
	NoSelectAll = 1 << 1,
	NoRangeSelect = 1 << 2,
	NoAutoSelect = 1 << 3,
	NoAutoClear = 1 << 4,
	NoAutoClearOnReselect = 1 << 5,
	BoxSelect1d = 1 << 6,
	BoxSelect2d = 1 << 7,
	BoxSelectNoScroll = 1 << 8,
	ClearOnEscape = 1 << 9,
	ClearOnClickVoid = 1 << 10,
	ScopeWindow = 1 << 11,
	ScopeRect = 1 << 12,
	SelectOnClick = 1 << 13,
	SelectOnClickRelease = 1 << 14,
	NavWrapX = 1 << 16,
}

/**
	* @enum ImGuiSelectionRequestType
	* @desc Selection request type
	*
	*/
enum ImGuiSelectionRequestType {
	None = 0,
	SetAll,
	SetRange,
}

/**
	* @enum ImDrawFlags
	* @desc Flags for ImDrawList functions
	*
	*/
enum ImDrawFlags {
	None = 0,
	Closed = 1 << 0,
	RoundCornersTopLeft = 1 << 4,
	RoundCornersTopRight = 1 << 5,
	RoundCornersBottomLeft = 1 << 6,
	RoundCornersBottomRight = 1 << 7,
	RoundCornersNone = 1 << 8,
	RoundCornersTop = ImDrawFlags.RoundCornersTopLeft | ImDrawFlags.RoundCornersTopRight,
	RoundCornersBottom = ImDrawFlags.RoundCornersBottomLeft | ImDrawFlags.RoundCornersBottomRight,
	RoundCornersLeft = ImDrawFlags.RoundCornersBottomLeft | ImDrawFlags.RoundCornersTopLeft,
	RoundCornersRight = ImDrawFlags.RoundCornersBottomRight | ImDrawFlags.RoundCornersTopRight,
	RoundCornersAll = ImDrawFlags.RoundCornersTopLeft | ImDrawFlags.RoundCornersTopRight | ImDrawFlags.RoundCornersBottomLeft | ImDrawFlags.RoundCornersBottomRight,
	RoundCornersDefault_ = ImDrawFlags.RoundCornersAll,
	RoundCornersMask_ = ImDrawFlags.RoundCornersAll | ImDrawFlags.RoundCornersNone,
}

/**
	* @enum ImDrawListFlags
	* @desc Flags for ImDrawList instance. Those are set automatically by ImGui:: functions from ImGuiIO settings, and generally not manipulated directly.
	*
	*/
enum ImDrawListFlags {
	None = 0,
	AntiAliasedLines = 1 << 0,
	AntiAliasedLinesUseTex = 1 << 1,
	AntiAliasedFill = 1 << 2,
	AllowVtxOffset = 1 << 3,
}

/**
	* @enum ImTextureFormat
	* @desc X11 headers are leaking this.
	*
	*/
enum ImTextureFormat {
	RGBA32,
	Alpha8,
}

/**
	* @enum ImTextureStatus
	* @desc Status of a texture to communicate with Renderer Backend.
	*
	*/
enum ImTextureStatus {
	OK,
	Destroyed,
	WantCreate,
	WantUpdates,
	WantDestroy,
}

/**
	* @enum ImFontAtlasFlags
	* @desc Flags for ImFontAtlas build
	*
	*/
enum ImFontAtlasFlags {
	None = 0,
	NoPowerOfTwoHeight = 1 << 0,
	NoMouseCursors = 1 << 1,
	NoBakedLines = 1 << 2,
}

/**
	* @enum ImFontFlags
	* @desc Font flags
	*
	*/
enum ImFontFlags {
	None = 0,
	NoLoadError = 1 << 1,
	NoLoadGlyphs = 1 << 2,
	LockBakedSizes = 1 << 3,
}

/**
	* @enum ImGuiViewportFlags
	* @desc Flags stored in ImGuiViewport::Flags, giving indications to the platform backends.
	*
	*/
enum ImGuiViewportFlags {
	None = 0,
	IsPlatformWindow = 1 << 0,
	IsPlatformMonitor = 1 << 1,
	OwnedByApp = 1 << 2,
	NoDecoration = 1 << 3,
	NoTaskBarIcon = 1 << 4,
	NoFocusOnAppearing = 1 << 5,
	NoFocusOnClick = 1 << 6,
	NoInputs = 1 << 7,
	NoRendererClear = 1 << 8,
	NoAutoMerge = 1 << 9,
	TopMost = 1 << 10,
	CanHostOtherWindows = 1 << 11,
	IsMinimized = 1 << 12,
	IsFocused = 1 << 13,
}