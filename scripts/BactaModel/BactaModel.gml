/*
	BactaModel
	-------------------------------------------------------------------------
	Script:			BactaModel
	Version:		v1.00
	Created:		04/11/2025 by Alun Jones
	Description:	NU20 Model Loader and Container
	-------------------------------------------------------------------------
	History:
	 - Created 04/11/2025 by Alun Jones
	
	To Do:
*/

// Bacta model version
enum _BACTA_MODEL_VERSION
{
	NONE,
	VERSION1,	// TFTG
	VERSION2,	// TCS
	VERSION3,	// TCS
	VERSION4,	// LB1 / LIJ1 / Prince Caspian
}

/// @func BactaModel()
/// @desc Load a TtGames Classic model and store it in the BactaModel container.
function BactaModel(_modelPath = undefined) constructor
{
	// Check model arguement
	if (_modelPath == undefined) throw ("<BactaModel> Cannot load an undefined model.");
	
	// Validate file
	if (validate_file(_modelPath, [ ".ghg" ]) == _BACTA_FILE_VALIDATION.PASSED)
	{
		// Debug out
		DEBUGGER.print($"Attempting to load \"{_modelPath}\".");
		
		// Load Model
	}
	
	#region Load Model
	
	/// @func loadModel(modelPath)
	/// @desc Load a TtGames model from a model file.
	/// @param {String} modelPath The path of the model.
	static loadModel = function(_modelPath)
	{
		// Load buffer
		var _buffer = buffer_load(_modelPath);
		
		// Validate model version
		self.version = getVersion(_buffer);
		DEBUGGER.assert(self.version > 0, "Unsupported model version detected.");
		
		// Offsets struct (for future reference)
		self.offsets = {  };
		
		// Read NU20
		readNU20(_buffer);
		
		// Read GSNH
		readGSNH(_buffer);
	}
	
	/// @func readNU20(buffer)
	/// @desc Read the NU20 header of the model.
	/// @param {Id.Buffer} buffer Model buffer.
	static readNU20 = function(_buffer)
	{
		// Get NU20 offset
		self.nu20Offset = buffer_tell(_buffer);
		
		// Copy NU20 data to it's own buffer
		var _nu20Size = -buffer_peek(_buffer, buffer_tell(_buffer) + 4, buffer_s32);
		self.data = buffer_create(_nu20Size, buffer_fixed, 1);
		buffer_copy(_buffer, buffer_tell(_buffer), _nu20Size, self.data, 0);
		
		// Seek to HEAD
		buffer_seek(_buffer, buffer_seek_relative, 0x18);
		
		// Read PNTR and GSNH offsets
		self.pntrOffset = buffer_read_pointer(_buffer);
		self.gsnhOffset = buffer_read_pointer(_buffer);
	}
	
	/// @func readGSNH(buffer)
	/// @desc Read the GSNH header of the model.
	/// @param {Id.Buffer} buffer Model buffer.
	static readGSNH = function(_buffer)
	{
		// Seek to the GSNH
		buffer_seek(_buffer, buffer_seek_start, self.gsnhOffset);
		
		// Seek ahead 4 bytes because the first pointer is unknown
		var _unknownPointer = buffer_read_pointer(_buffer);
	}
	
	#endregion
	
	#region Helper Methods
	
	/// @func getVersion()
	/// @desc Get Model Version
	static getVersion = function(_buffer)
	{
		// Read First int (Could be either 808605006 (NU20) or the offset to the NU20)
		var _nu20 = buffer_read(_buffer, buffer_u32);
		
		// Check for NU20 first (Batman & Indy models)
		if (_nu20 == 808605006)
		{
			// Seek to the version
			buffer_seek(_buffer, buffer_seek_relative, 4);
			
			// Version
			var _version = buffer_read(_buffer, buffer_u32);
			
			// Seek to the start of the nu20
			buffer_seek(_buffer, buffer_seek_relative, -12);
			
			// Return Model Version
			return _version;
		}
		else
		{
			// Check if seek offset is within the size of the buffer
			if (_nu20 + 4 > buffer_get_size(_buffer)) return false;
			
			// Seek forward value of NU20 and check for NU20 there
			buffer_seek(_buffer, buffer_seek_relative, _nu20);
			
			// Check for NU20 last (TCS)
			_nu20 = buffer_read(_buffer, buffer_u32);
			if (_nu20 == 808605006)
			{
				// Seek to the version
				buffer_seek(_buffer, buffer_seek_relative, 4);
				
				// Version
				var _version = buffer_read(_buffer, buffer_u32);
				
				// Seek to the start of the nu20
				buffer_seek(_buffer, buffer_seek_relative, -12);
				
				// Return Model Version
				return _version;
			}
		}
		
		// Return Model Version None regardless
		return false;
	}
	
	#endregion
}