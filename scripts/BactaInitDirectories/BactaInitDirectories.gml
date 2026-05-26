///
/// Initialise directories
///
function BactaInitDirectories()
{
    // Working directory items
    StashAddDirectory("themes", StashGetWorkingDirectory() + "themes/");
    StashAddDirectory("templates", StashGetWorkingDirectory() + "templates/");
    StashAddDirectory("assets", StashGetWorkingDirectory() + "assets/");
    
    StashAddDirectory("projects", ReggieGet("directories.projects"));
}