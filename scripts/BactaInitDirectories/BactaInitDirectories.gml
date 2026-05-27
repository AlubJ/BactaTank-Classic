///
/// Initialise directories
///
function BactaInitDirectories()
{
    // Working directory items
    StashAddDirectory("themes", StashGetWorkingDirectory() + "themes/");
    StashAddDirectory("assets", StashGetWorkingDirectory() + "assets/");
    
    // Save directory
    StashAddDirectory("templates", StashGetSaveDirectory() + "templates/");
    
    StashAddDirectory("projects", ReggieGet("directories.projects"));
}