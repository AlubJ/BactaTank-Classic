/// @desc Save Window State

SETTINGS.window.maximised = window_is_maximization();
if (SETTINGS.window.maximised) SETTINGS.window.size = [1366, 768];
else SETTINGS.window.size = WINDOW_SIZE;
saveSettings();