/// @desc Set Up UI
/*
	ctrlUI.Create
	-------------------------------------------------------------------------
	Script:			ctrlUI.Create
	Version:		v1.00
	Created:		15/11/2024 by Alun Jones
	Description:	Create the UI
	-------------------------------------------------------------------------
	History:
	 - Created 15/11/2024 by Alun Jones
	
	To Do:
*/

// Create Global Environment
ENVIRONMENT = new GlobalEnvironment();

var modal = new StartupModal();
ENVIRONMENT.addModal(modal);
ENVIRONMENT.openModal(modal.name);

ENVIRONMENT.addModal(new NewProjectModal());
ENVIRONMENT.addModal(new AddModelModal());
ENVIRONMENT.addModal(new AboutModal());
ENVIRONMENT.addModal(new PreferencesModal());
ENVIRONMENT.addModal(new ReplaceMeshModal());
ENVIRONMENT.addModal(new UpdateModal());

// Asset Pack Modals
ENVIRONMENT.addModal(new AssetPacksModal());
ENVIRONMENT.addModal(new CreateAssetPackModal());

// Get Command Line Args
var args = get_args();
//args[0] = "batman_new.GHG"
if (array_length(args) > 0 && string_lower(filename_ext(args[0])) == ".ghg")
{
	openProjectOrModel(args[0]);
}

alarm[0] = 60;
alarm[1] = 20;
DBGMEM = debug_event("DumpMemory", true);

// STRESS TESTING
//var tcs = "\"FILE\",\"ERROR\"\n";

//var file = file_find_first(@"D:/Lego Modding/AllChars/LIJ1pt2/*.ghg", fa_none);
//var files = [];

//while (file != "")
//{
//	show_debug_message(file);
//	array_push(files, @"D:/Lego Modding/AllChars/LIJ1pt2/" + file);
//	file = file_find_next();
//}
//file_find_close();

//for (var i = 0; i < array_length(files); i++)
//{
//	show_debug_message(filename_name(files[i]));
//	try
//	{
//		var model = new BactaTankModel(files[i]);
//		model.destroy();
	
//	}
//	catch (e)
//	{
//		tcs += $"\"{filename_name(files[i])}\",\"{e.message}\"\n";
//	}
//}


//var buffer = buffer_create(1, buffer_grow, 1);
//buffer_write(buffer, buffer_text, tcs);
//buffer_save(buffer, "LIJ1pt2.csv")
//buffer_delete(buffer);