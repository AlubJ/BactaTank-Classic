/// @desc
if (VERSION_LATEST != noone && VERSION_LATEST != SETTINGS.ignoreVersion)
{
	var version = string_split(VERSION_LATEST, ".");
	if (version[0] > VERSION_MAJOR || version[1] > VERSION_MINOR || version[2] > VERSION_PATCH)
	{
		ENVIRONMENT.openModal("Update");
	}
}