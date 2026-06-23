// Feather disable all

///
/// Create a new bacta project
///
/// @param {String} projectName The name of the project
/// @param {String} projectFile The file of the project
/// @param {Real} projectGame The game of the project
/// @param {Real} projectType The type of the project
function BactaCreateProject(_projectName, _projectFile, _projectGame, _projectType)
{
    static _system = __BactaSystem();
    
    with (_system)
    {
        if (__project != undefined)
        {
            __BactaError("Please unload the project before creating a new one");
        }
        
        __project = {  };
        
        with (__project)
        {
            name = _projectName;
            file = _projectFile;
            game = _projectGame;
            type = _projectType;
            version = BACTA_VERSION;
            
            characters = [ 
                {
                    name: "Character",
                    
                    animations: [  ],
                    abilities: [  ],
                    attributes: [  ],
                    
                    hrModel: undefined,
                    lrModel: undefined,
                }
            ];
            models = [  ];
            
            loadedModel = undefined;
            loadedCharacter = undefined;
            
            cacheDirectory = StashGetTemporaryDirectory() + md5_string_utf8(_projectName + _projectFile) + "/";
            
            StashAddDirectory("projectCache", cacheDirectory);
        }
    }
}