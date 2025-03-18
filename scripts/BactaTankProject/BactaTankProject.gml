/*
	BactaTankProject
	-------------------------------------------------------------------------
	Script:			BactaTankProject
	Version:		v1.00
	Created:		22/11/2024 by Alun Jones
	Description:	BactaTank Project Constructor
	-------------------------------------------------------------------------
	History:
	 - Created 22/11/2024 by Alun Jones
	
	To Do:
	 - Array shifting to put existing projects first when reloading a project.
*/

enum BTProjectType
{
	TCS,
	LIJ1,
	LB1,
}
global.__projectType = ["TCS", "LIJ1", "LB1"];
#macro BT_PROJECT_TYPE global.__projectType

function BactaTankProject(projectName = "BTProj", projectType = BTProjectType.TCS, saveLoc = "") constructor
{
	// General
	name = projectName;
	type = projectType;
	
	// Generate ID
	uniqueID = string_crc32($"BactaTankProject-{date_datetime_string(date_current_datetime())}-{projectName}");
	
	// Working Directory
	workingDirectory = TEMP_DIRECTORY + $"{string_hex(uniqueID)}\\";
	//directory_create(workingDirectory);
	
	// Settings
	settings = {
		sfxEditor: false,
		iconEditor: false,
	};
	
	// Characters and Models
	characters = [  ];
	models = [  ];
	sfx = [  ];
	icons = [  ];
	
	// Current Model
	currentModel = -1;
	
	// Save Location
	saveLocation = saveLoc;
	
	#region Save / Load
	
	static save = function(saveLoc = saveLocation)
	{
		// Change Save Location
		if (saveLoc != saveLocation) saveLocation = saveLoc;
		
		// Add To Recent Projects
		array_insert(SETTINGS.recentProjects, 0, saveLocation);
		if (array_length(SETTINGS.recentProjects) > 10) array_delete(SETTINGS.recentProjects, 10, array_length(SETTINGS.recentProjects) - 10);
		SnapToBinary(SETTINGS, CONFIG_DIRECTORY + "settings.bin");
		
		// Create Buffer
		var buffer = buffer_create(1, buffer_grow, 1);
		
		// Serialize Project
		serialize(buffer);
		
		// Save Buffer
		buffer_save(buffer, saveLocation);
		
		// Delete Buffer
		buffer_delete(buffer);
	}
	
	#endregion
	
	#region Serialize / Deserialize Methods
	
	// Serialize
	static serialize = function(buffer)
	{
		// Write File Header
		buffer_write(buffer, buffer_string, "BactaTankProject");
		buffer_write(buffer, buffer_string, name);
		buffer_write(buffer, buffer_string, BT_PROJECT_TYPE[type]);
		buffer_write(buffer, buffer_u32, uniqueID);
		buffer_write(buffer, buffer_f32, BT_PROJECT_VERSION);
		
		// Write Characters
		buffer_write(buffer, buffer_string, "BactaTankCharacters");
		buffer_write(buffer, buffer_s32, array_length(characters));
		
		// Serialize Characters
		for (var i = 0; i < array_length(characters); i++)
		{
			characters[i].serialize(buffer);
		}
		
		// Write Models
		buffer_write(buffer, buffer_string, "BactaTankModels");
		buffer_write(buffer, buffer_s32, array_length(models));
		
		// Serialize Models
		for (var i = 0; i < array_length(models); i++)
		{
			// Write Model Name
			buffer_write(buffer, buffer_string, models[i]);
			
			// Load Buffer
			ConsoleLog(workingDirectory + models[i] + ".bcanister");
			var modelBuffer = buffer_load(workingDirectory + models[i] + ".bcanister");
			
			// Compress Model
			var modelCompressed = buffer_compress(modelBuffer, 0, buffer_get_size(modelBuffer));
			
			// Write Model Size
			buffer_write(buffer, buffer_u32, buffer_get_size(modelCompressed));
			buffer_copy(modelCompressed, 0, buffer_get_size(modelCompressed), buffer, buffer_tell(buffer));
			buffer_seek(buffer, buffer_seek_relative, buffer_get_size(modelCompressed));
			
			// Delete Buffers
			buffer_delete(modelBuffer);
			buffer_delete(modelCompressed);
		}
	}
	
	#endregion
	
	#region Methods
	
	static loadModel = function(modelIndex)
	{
		if (currentModel != -1) currentModel.destroy();
		currentModel = new BactaTankModel(workingDirectory + models[modelIndex] + ".bcanister");
	}
	
	static destroy = function()
	{
		directory_destroy(workingDirectory);
		if (currentModel != -1) currentModel.destroy();
		return;
	}
	
	#endregion
}