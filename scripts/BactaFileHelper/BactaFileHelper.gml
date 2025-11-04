/*
	BactaFileHelper
	-------------------------------------------------------------------------
	Script:			BactaFileHelper
	Version:		v1.00
	Created:		04/11/2025 by Alun Jones
	Description:	Various file helper functions.
	-------------------------------------------------------------------------
	History:
		Created 04/11/2025 by Alun Jones
	
	To Do:
*/

enum _BACTA_FILE_VALIDATION
{
	PASSED,
	NOT_FOUND,
	WRONG_EXTENSION,
}

/// @func validate_file(filepath, [extensions])
/// @desc Validate a filepath by checking that the file exists and the extension matches.
/// @param {String} filepath The filepath of the file.
/// @param {Array.String} extensions The extensions of the filepath to check for (in lowercase, optional).
/// @returns {Enum._BACTA_FILE_VALIDATION}
function validate_file(_filepath, _extensions = undefined)
{
	// Filepath exists
	if (!file_exists(_filepath)) return _BACTA_FILE_VALIDATION.NOT_FOUND;
	
	// Extensions
	if (_extensions != undefined)
	{
		// Re-type extensions to array
		if (!is_array(_extensions)) _extensions = [ _extensions ];
		
		// Get filepath extension
		var _ext = string_lower(filename_ext(_filepath));
		
		// Check for wrong extensions
		if (!array_contains(_extensions, _ext)) return _BACTA_FILE_VALIDATION.WRONG_EXTENSION;
	}
	
	// Return passed
	return _BACTA_FILE_VALIDATION.PASSED;
}