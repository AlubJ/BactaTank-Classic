///
/// Initialise directories
///
function BactaInitDirectories()
{
    StashAddDirectory("themes", StashGetWorkingDirectory() + "themes/");
    StashAddDirectory("templates", StashGetWorkingDirectory() + "templates/");
    StashAddDirectory("assets", StashGetWorkingDirectory() + "assets/");
}