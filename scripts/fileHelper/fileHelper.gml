/*
	fileHelper
	-------------------------------------------------------------------------
	Script:			fileHelper
	Version:		v1.00
	Created:		22/11/2024 by Alun Jones
	Description:	File Helper Functions
	-------------------------------------------------------------------------
	History:
	 - Created 22/11/2024 by Alun Jones
	
	To Do:
	 - Create File Open Safe Function
*/

function file_read_lines(file)
{
	var buffer = buffer_load(file);
	var text = buffer_read(buffer, buffer_text);
	buffer_delete(buffer);
	
	return string_split_ext(text, ["\n", "\r\n"], true);
}

function file_text_write(file, str)
{
	var buffer = buffer_create(1, buffer_grow, 1);
	buffer_write(buffer, buffer_text, str);
	buffer_save(buffer, file);
	buffer_delete(buffer);
}

function verify_file_format(ext)
{
	switch (string_lower(ext))
	{
		case ".ghg":
			return 0;
		case ".an3":
			return 1;
		case ".bsa":
			return 2;
		case ".wav":
			return 3;
		case ".bcanister":
			return 0;
	}
	return -1;
}