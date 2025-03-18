#macro FILE_DROPPER_VERSION "1.2.1"

file_dropper_init(window_handle());

if (GM_is_sandboxed && os_type == os_windows) {
	show_error (@"The GameMaker sandbox is disabled, so this extension won't work very well.
Go into Game Options > Windows and check the Disabled Filesystem Sandbox box.
", true);
}