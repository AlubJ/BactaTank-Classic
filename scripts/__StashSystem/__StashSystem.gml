// Feather disable all
__StashSystem();

function __StashSystem()
{
    static _system = undefined;
    if (_system != undefined) return _system;
    
    _system = {  };
    with (_system)
    {
        __workingDirectory = working_directory;
        __saveDirectory = game_save_id;
        __tempDirectory = temp_directory;
        __projectDirectory = filename_dir(GM_project_filename);
        __documentsDirectory = environment_get_variable("USERPROFILE") + "/Documents/";
        
        __stashDirectories = {  };
        
        __StashTrace($"Welcome to Stash by Alun Jones. This is v{STASH_VERSION} {STASH_DATE}");
    }
    
    return _system;
}