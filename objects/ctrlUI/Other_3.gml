/// @desc Save Window State

SETTINGS.window.maximised = IsWindowMaximised(window_handle());
if (SETTINGS.window.maximised) SETTINGS.window.size = [1366, 768];
else SETTINGS.window.size = WINDOW_SIZE;
saveSettings();