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
	if (_modelPath == undefined) __BactaError("Cannot load an undefined model.");
	
	// Validate file
	if (validate_file(_modelPath, [ ".ghg" ]) == _BACTA_FILE_VALIDATION.PASSED)
	{
		// Debug out
		__BactaTrace($"Attempting to load \"{_modelPath}\".");
		
		// Load Model
		loadModel(_modelPath);
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
		__BactaAssert(self.version > 0, "Unsupported model version detected.");
		
		// Offsets struct (for future reference)
		self.offsets = {  };
		
		// Read NU20
		readNU20(_buffer);
        
        // Read all blocks
        readBlocks(_buffer);
        
        // Read PNTR
        readPNTR(_buffer);
        
        var _buffer1 = buffer_create(1, buffer_grow, 1);
        buffer_write(_buffer1, buffer_text, json_stringify(self.referenceTable, true));
        buffer_save(_buffer1, "/Users/alun/Documents/test.txt");
        buffer_delete(_buffer1);
		
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
		buffer_hop(_buffer, 0x18);
		
		// Read PNTR and GSNH offsets
		self.pntrOffset = buffer_read_pointer(_buffer);
		self.gsnhOffset = buffer_read_pointer(_buffer);
	}
    
    /// @func readBlocks(buffer)
    /// @desc Read all the blocks and add the information to the blocks struct.
	/// @param {Id.Buffer} buffer Model buffer.
    static readBlocks = function(_buffer)
    {
        // Create the structure to hold the block information
        self.blocks = {  };
        self.blockOrder = [  ];
        
        // Jump back 0x10 bytes to allow the HEAD block to be read
        buffer_hop(_buffer, -0x10);
        
        // While loop
        while (true)
        {
            // Get buffer information
            var _blockStartOffset = buffer_tell(_buffer);
            var _blockMagic = buffer_read_chars(_buffer, 4);
            var _blockSize = buffer_read(_buffer, buffer_s32);
            var _blockEndOffset = _blockStartOffset + _blockSize;
            
            // Extend the VBIB block ahead by 0x20 bytes to include this weird bit
            if (_blockMagic == "VBIB")
            {
                _blockSize += 0x20;
                _blockEndOffset = _blockStartOffset + _blockSize;
            }
            
            // Seek ahead
            buffer_hop(_buffer, _blockSize - 8);
            
            // Set block
            self.blocks[$ _blockMagic] = {
                magic: _blockMagic,
                startOffset: _blockStartOffset,
                size: _blockSize,
                endOffset: _blockEndOffset,
                
                symbols: {  },  // Stores symbols for things that pointers point to
                pointers: {  }, // Stores pointers to symbols
            };
            
            array_push(self.blockOrder, _blockMagic);
            
            // Trace
            __BactaTrace("Read block: ", _blockMagic);
            
            // Break after PNTR is read
            if (_blockMagic == "PNTR")
            {
                break;
            }
        }
    }
    
    /// @func readPNTR(buffer)
    /// @desc Read the PNTR section and map out all pointers.
	/// @param {Id.Buffer} buffer Model buffer.
    static readPNTR = function(_buffer)
    {
        // Create reference table
        self.referenceTable = {  };
        
        // Jump to PNTR
        buffer_jump(_buffer, self.pntrOffset);
        
        // Get pointer count
        var _pointerCount = buffer_read(_buffer, buffer_s32);
        
        // Repeat
        repeat (_pointerCount)
        {
            // Source
            var _sourceOffsetAbsolute = buffer_read_pointer(_buffer);
            
            // Source data
            var _block = self.findBlockByOffset(_sourceOffsetAbsolute);
            if (_block != undefined)
            {
                var _sourceBlock = _block.magic;
                var _sourceOffset = _sourceOffsetAbsolute - _block.startOffset;
            }
            else
            {
                var _sourceBlock = "NONE";
                var _sourceOffset = 0;
            }
            
            // Target
            var _targetOffsetAbsolute = buffer_peek_pointer(_buffer, _sourceOffsetAbsolute);
            
            // Target data
            var _block = self.findBlockByOffset(_targetOffsetAbsolute);
            if (_block != undefined)
            {
                var _targetBlock = _block.magic;
                var _targetOffset = _targetOffsetAbsolute - _block.startOffset;
            }
            else
            {
                var _targetBlock = "NONE";
                var _targetOffset = 0;
            }
            
            // Add to struct
            self.referenceTable[$ ($"{_sourceBlock}:{_sourceOffset}")] = {
                sourceBlock: _sourceBlock,
                sourceOffset: _sourceOffset,
                sourceOffsetAbsolute: _sourceOffsetAbsolute,
                targetBlock: _targetBlock,
                targetOffset: _targetOffset,
                targetOffsetAbsolute: _targetOffsetAbsolute,
            }
            
            if (_targetBlock == "NONE")
            {
                
            }
        }
    }
	
	/// @func readGSNH(buffer)
	/// @desc Read the GSNH header of the model.
	/// @param {Id.Buffer} buffer Model buffer.
	static readGSNH = function(_buffer)
	{
		// Seek to the GSNH
		buffer_jump(_buffer, self.gsnhOffset);
		
		// Seek ahead 4 bytes because the first pointer is unknown
		var _unknownPointer = buffer_read_pointer(_buffer);
		
		// Texture data
		var _textureCount = buffer_read(_buffer, buffer_u32);
		var _texturePointersPointer = buffer_read_pointer(_buffer);
		
		// Material data
		var _materialPointersPointer = buffer_read_pointer(_buffer);
		var _materialCount = buffer_read(_buffer, buffer_u32);
		
		// Jump ahead
		buffer_hop(_buffer, 0x20);
		
		// Mesh data
		var _meshDataPointer = buffer_read_pointer(_buffer);
		
		// Nametable pointer
		var _nametablePointer = buffer_read_pointer(_buffer);
		
		// Jump ahead
		buffer_hop(_buffer, 0x20);
		
		// FDNS pointer
		var _fdnsPointer = buffer_read_pointer(_buffer);
		
		// Jump ahead
		buffer_hop(_buffer, 0x90);
		
		// BNDS data
		var _bndsCount = buffer_read(_buffer, buffer_u32);
		buffer_hop(_buffer, 0x08);							// Duplicate data?
		var _bndsPointer = buffer_read_pointer(_buffer);
		
		// Jump ahead
		buffer_hop(_buffer, 0x10);
		
		// Display pointer
		var _dispPointer = buffer_read_pointer(_buffer);
		
		// Jump ahead
		buffer_hop(_buffer, 0x3C);
		
		// DYNO pointer
		var _dynoPointer = buffer_read_pointer(_buffer);
		
		// Jump ahead
		buffer_hop(_buffer, 0x14);
		
		// Bone data
		var _boneCount = buffer_read(_buffer, buffer_u32);
		var _boneIdentityPointer = buffer_read_pointer(_buffer);
		var _boneBindPointer = buffer_read_pointer(_buffer);
		var _boneInverseBindPointer = buffer_read_pointer(_buffer);
		
		// Unknown
		var _unknownCount = buffer_read(_buffer, buffer_u32);
		var _unknownPointer = buffer_read_pointer(_buffer);
		
		// Locator order data
		var _locatorOrderCount = buffer_read(_buffer, buffer_u32);
		var _locatorOrderPointer = buffer_read_pointer(_buffer);
		
		// Locator data
		var _locatorCount = buffer_read(_buffer, buffer_u32);
		var _locatorPointer = buffer_read_pointer(_buffer);
		
		// Layer data
		var _layerCount = buffer_read(_buffer, buffer_u32);
		var _layerPointer = buffer_read_pointer(_buffer);
		
		// Jump to mesh data
		buffer_jump(_buffer, _meshDataPointer);
		
		// Vertex buffers (This is just the header part of the vertex buffers, not used in practice)
		var _vertexBufferCount = buffer_read(_buffer, buffer_u32);
		var _vertexBufferPointer = buffer_read_pointer(_buffer);
		
		// Index buffers (This is just the header part of the index buffers, not used in practice)
		var _indexBufferCount = buffer_read(_buffer, buffer_u32);
		var _indexBufferPointer = buffer_read_pointer(_buffer);
		
		// Mesh list
		var _meshListPointer = buffer_read_pointer(_buffer);
		var _meshCount = buffer_read(_buffer, buffer_u32);
	}
	
	#region Model attribute readers
	
	/// @func readTexture
	
	#endregion
	
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
			buffer_hop(_buffer, 4);
			
			// Version
			var _version = buffer_read(_buffer, buffer_u32);
			
			// Seek to the start of the nu20
			buffer_hop(_buffer, -12);
			
			// Return Model Version
			return _version;
		}
		else
		{
			// Check if seek offset is within the size of the buffer
			if (_nu20 + 4 > buffer_get_size(_buffer)) return false;
			
			// Seek forward value of NU20 and check for NU20 there
			buffer_hop(_buffer, _nu20);
			
			// Check for NU20 last (TCS)
			_nu20 = buffer_read(_buffer, buffer_u32);
			if (_nu20 == 808605006)
			{
				// Seek to the version
				buffer_hop(_buffer, 4);
				
				// Version
				var _version = buffer_read(_buffer, buffer_u32);
				
				// Seek to the start of the nu20
				buffer_hop(_buffer, -12);
				
				// Return Model Version
				return _version;
			}
		}
		
		// Return Model Version None regardless
		return false;
	}
    
    /// @func findBlockByOffset(offset)
    /// @desc Find a block by a specific offset.
    /// @param {Real} offset
    static findBlockByOffset = function(_offset)
    {
        // Get struct properties
        var _blockCount = array_length(self.blockOrder);
        
        // Loop over it
        var _i = 0;
        repeat(_blockCount)
        {
            var _block = self.blocks[$ self.blockOrder[_i]];
            if (_offset >= _block.startOffset && _offset < _block.endOffset)
            {
                return _block;
            }
            _i++;
        }
        
        return undefined;
    }
	
	#endregion
}