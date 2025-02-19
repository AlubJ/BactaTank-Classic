/*
	BactaTankExternFile
	-------------------------------------------------------------------------
	Script:			BactaTankExternFile
	Version:		v1.00
	Created:		10/02/2025 by Alun Jones
	Description:	External file functions for scripting
	-------------------------------------------------------------------------
	History:
	 - Created 10/02/2025 by Alun Jones
	
	To Do:
	 - Add a whole bunch of file functions
*/

function BactaTankExternFile() constructor
{
	// Get Open
	static getOpen = function(filter, fname)
	{
		return get_open_filename(filter, fname);
	}
	
	// Get Save
	static getSave = function(filter, fname)
	{
		return get_save_filename(filter, fname);
	}
	
	// Name
	static name = function(fname) { return filename_name(fname); }
	
	// Extension
	static extension = function(fname) { return filename_ext(fname); }
	
	// Directory
	static directory = function(fname) { return filename_dir(fname); }
	
	// Get Files
	static files = function(mask)
	{
		// Return Array
		var returnArray = [  ];
		
		// Find First File
		var file = file_find_first(mask, fa_none);
		
		while (file != "")
		{
			array_push(returnArray, file);
		    file = file_find_next();
		}
		
		// Close find file
		file_find_close();
		
		// Return
		return returnArray;
	}
	
	// Exists
	static exists = function(filename) { return file_exists(filename); }
}

function BactaTankExternDirectory() constructor
{
	// Create
	static create = function(dir)
	{
		directory_create(dir);
	}
}