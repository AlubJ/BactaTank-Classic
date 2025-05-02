/*
	BactaTankAnimationFile
	-------------------------------------------------------------------------
	Script:			BactaTankAnimationFile
	Version:		v1.00
	Created:		20/02/2025 by Alun Jones (Adapted from Clarence Oveur EasyAN3 Python Script)
	Description:	BactaTank Animation File Constructor
	-------------------------------------------------------------------------
	History:
	 - Created 20/02/2025 by Alun Jones
	
	To Do:
*/

enum BT_KEYFRAME_FLAGS
{
	APPLY_ROTATION			= 1 << 0,	// 0x01
	APPLY_TRANSLATION		= 1 << 1,	// 0x02
	APPLY_SCALE				= 1 << 3,	// 0x08
	APPLY_INV_SCALE			= 1 << 4,	// 0x10
	UNKNOWN					= 1 << 5,	// 0x20
	BASE_JOINT_SCALE_1		= 1 << 6,	// 0x30
}

function BactaTankAnimationFile() constructor
{
	// Variables
	version = 0;
	nodeCount = 0;
	frameCount = 0;
	curveGroupSize = 0;
	originalFrameCount = 0;
	curveCount = 0;
	firstFrame = 0;
	endFrames = 0;
	shortIntegerCount = 0;
	fixedUp = 0;
	frameIndexListPointer = 0;
	constantBase = 0.0;
	constantScale = 0.0;
	curveScalesMinsPointer = 0;
	constantsPointer = 0;
	keyTypesPointer = 0;
	keysPointer = 0;
	endDataPointer = 0;
	curveSetFlagsPointer = 0;
	tangentKeysPointer = 0;
	
	metaData = [];
	
	numMoving = 0;
	movingCount = 0;
	staticCount = 0;
	
	skeletonMatrix = [];
	staticValues = [];
	movementParameters = [];
	movingData = [];
	movingDataReconstructed = [];
	flags = [];
	
	allStaticValues = [];
	
	// Read Method
	static parse = function(filepath)
	{
		// Load Buffer
		var buffer = buffer_load(filepath);
		
		// Read Header
		version = buffer_read(buffer, buffer_u32);
		nodeCount = buffer_read(buffer, buffer_u16);
		frameCount = buffer_read(buffer, buffer_u16);
		curveGroupSize = buffer_read(buffer, buffer_u16);
		originalFrameCount = buffer_read(buffer, buffer_u16);
		curveCount = buffer_read(buffer, buffer_u16);
		firstFrame = buffer_read(buffer, buffer_u16);
		endFrames = buffer_read(buffer, buffer_u8);
		shortIntegerCount = buffer_read(buffer, buffer_u8);
		fixedUp = buffer_read(buffer, buffer_u8);
		buffer_seek(buffer, buffer_seek_relative, 5);
		frameIndexListPointer = buffer_read(buffer, buffer_u32);
		constantBase = buffer_read(buffer, buffer_f32);
		constantScale = buffer_read(buffer, buffer_f32);
		curveScalesMinsPointer = buffer_read(buffer, buffer_u32);
		constantsPointer = buffer_read(buffer, buffer_u32);
		keyTypesPointer = buffer_read(buffer, buffer_u32);
		keysPointer = buffer_read(buffer, buffer_u32);
		curveSetFlagsPointer = buffer_read(buffer, buffer_u32);
		tangentKeysPointer = buffer_read(buffer, buffer_u32);
		
		numMoving = round(curveGroupSize / 4);
		
		// Read KeyTypes
		buffer_seek(buffer, buffer_seek_start, keyTypesPointer);
		
		for (var i = 0; i < nodeCount * 9; i++)
		{
			array_push(skeletonMatrix, buffer_read(buffer, buffer_u16));
		}
		
		for (var i = 0; i < array_length(skeletonMatrix); i++)
		{
			if (skeletonMatrix[i] < 0x10)
			{
				// Moving Joint
				if (skeletonMatrix[i] == 0x06)
				{
					movingCount++;
				}
				else
				{
					throw $"Unknown moving value 0x{string_hex(skeletonMatrix[i], 2)}";
				}
			}
			else
			{
				// Static Joint
				array_push(allStaticValues, skeletonMatrix[i]);
			}
		}
		
		staticValues = [];
		
		// Read Static Values
		buffer_seek(buffer, buffer_seek_start, constantsPointer);
		
		for (var i = 0; i < 2 * array_length(allStaticValues); i++)
		{
			array_push(staticValues, buffer_read(buffer, buffer_u16));
		}
		
		if (numMoving != 0)
		{
			movementParameters = [];
			buffer_seek(buffer, buffer_seek_start, curveScalesMinsPointer);
			
			for (var i = 0; i < numMoving; i++)
			{
				var moveParam = [];
				array_push(moveParam, buffer_read(buffer, buffer_f32));
				array_push(moveParam, buffer_read(buffer, buffer_f32));
				array_push(movementParameters, moveParam);
			}
			
			buffer_seek(buffer, buffer_seek_start, keysPointer);
			
			movingDataRaw = [];
			for (var i = 0; i < (curveSetFlagsPointer - keysPointer) / 4; i++)
			{
				array_push(movingDataRaw, buffer_read(buffer, buffer_u32));
			}
			
			movingData = transform_to_2d_array(movingDataRaw, numMoving);
			//show_debug_message(movingData);
			
			movingDataReconstructedRaw = [];
			for (var i = 0; i < array_length(movingData); i++)
			{
				for (var j = 0; j < array_length(movingData[i]); j++)
				{
					if (i == 0) show_debug_message(j);
					var scalingRawBytes = movingData[i][j] >> 8;
					var scaling = [scalingRawBytes & 0x3f, (scalingRawBytes >> 6) & 0x3f, (scalingRawBytes >> 12) & 0x3f, (scalingRawBytes >> 18) & 0x3f];
					var v = [movingData[i][j] & 0xFF, scaling];
					array_push(movingDataReconstructedRaw, v);
				}
			}
			
			//show_debug_message(movingDataReconstructedRaw);
			
			for (var i = 0; i < array_length(movingDataReconstructedRaw); i += array_length(movingData[0]))
			{
				// Determine the width of each row in the desired 2D list
				var rowLength = array_length(movingData[0]);

				// Initialize an empty list to hold the restructured data
				movingDataRestructured = [];

				// Loop over the raw data in chunks of 'row_length'
				for (var j = 0; j < array_length(movingDataReconstructedRaw); j += rowLength)
				{
				    // Slice a chunk from the raw list
					row = [];
				    array_copy(row, 0, movingDataReconstructedRaw, i, i + rowLength);
    
				    // Append the chunk as a new row in the restructured list
				    array_push(movingDataRestructured, row);
				}
			}
			
			//show_debug_message(movingDataRestructured);
		}
		else
		{
			movementParameters = [];
			movingDataRestructured = [];
		}
		
		// Jump To Flags
		buffer_seek(buffer, buffer_seek_start, curveSetFlagsPointer);
		
		// Do Flags
		flags = [];
		for (var i = 0; i < nodeCount; i++)
		{
			array_push(flags, buffer_read(buffer, buffer_u8));
		}
		
		//show_debug_message(flags);
	}
	
	// Check If Node Is Static
	static isStatic = function(ch, idx)
	{
		if (skeletonMatrix[9*ch+idx] < 0x10)
		{
			return false;
		}
		else
		{
			return true;
		}
	}
	
	// Get Moving Number
	static getMovingNumber = function(ch, idx)
	{
		count = 0;
		if (isStatic(ch, idx)) throw "Attempted to get moving number from static channel";
		else
		{
			for (var i = 0; i < (ch*9) + idx; i++)
			{
				if (skeletonMatrix[i] < 0x10)
				{
					if (skeletonMatrix[i] == 0x06)
					{
						count++;
					}
					else
					{
						ConsoleLog($"Unknown moving value 0x{string_hex(skeletonMatrix[i], 2)}");
					}
				}
			}
		}
		
		return count;
	}
	
	// Get Normalized Key Data
	static getNormalizedKeyData = function(movingNumber, keyframe, section, sectionProgress)
	{
		var value = 0.0;
		
		// Get current and next keyframe data
		var currentPair = movingDataRestructured[movingNumber][keyframe];
		var nextPair = movingDataRestructured[movingNumber][keyframe + 1];
		
		var currentValue  = currentPair[0];
		var currentScaling = currentPair[1]; // assumed to be an array
		var nextValue     = nextPair[0];
		var nextScaling   = nextPair[1];     // assumed to be an array
		
		if (section < 3) {
		    var s0 = currentScaling[section] / 63.0;
		    var s1 = currentScaling[section + 1] / 63.0;
		    var sectionProgressScaled = (s1 - s0) * sectionProgress + s0;
		    value = sectionProgressScaled * (nextValue - currentValue) + currentValue;
		}
		else
		{
		    // Get future keyframe (2 steps ahead)
			show_debug_message(keyframe + 2);
		    var futurePair = movingDataRestructured[movingNumber][keyframe + 2];
		    var futureValue = futurePair[0];
		    var futureScaling = futurePair[1]; // not used, but available if needed

		    var c = (nextValue - currentValue) * (currentScaling[section] / 63.0) + currentValue;
		    value = (((nextScaling[0] / 63.0) * (futureValue - nextValue) + nextValue) - c) * sectionProgress + c;
		}
		
		return value;
	}
	
	// Get Key Data F
	static getKeyData_f = function(movingNumber, keyframe, section, sectionProgress)
	{
		return getNormalizedKeyData(movingNumber, keyframe, section, sectionProgress) * movementParameters[movingNumber][0] + movementParameters[movingNumber][1];
	}
	
	// Get Key Data C
	static getKeyData_c = function(movingNumber)
	{
		var keyframeData = [];
		for (k = 0; k < array_length(movingDataRestructured[movingNumber]) - 2; k++)
		{
			for (s = 0; s < 4; s++)
			{
				var value = getKeyData_f(movingNumber, k, s, 0.0);
				array_push(keyframeData, value);
			}
		}
		
		return keyframeData;
	}
	
	// Get Key Data
	static getKeyData = function()
	{
		var keys = [];
		
		for (var k = 0; k < array_length(movingDataRestructured); k++)
		{
			array_push(keys, getKeyData_c(k));
		}
		
		return keys;
	}
	
	// Get Integer From Restruct Key
	static getIntFromRestructKey = function(key)
	{
		var out = 0x00000000;
		var val = key[0];
		var sec = key[1];
		var a = val & 0xFF;
        var b = ((sec[0]&0x3F)<< 0)<<8;
        var c = ((sec[1]&0x3F)<< 6)<<8;
        var d = ((sec[2]&0x3F)<<12)<<8;
        var e = ((sec[3]&0x3F)<<18)<<8;

        out = a|b|c|d|e;
        return out;
	}
	
	// Update Moving Data
	static updateMovingData = function()
	{
		var newMoving = [];
		for (var i = 0; i < array_length(movingDataRestructured); i++)
		{
			var moving = movingDataRestructured[i];
			var keys = [];
			for (var k = 0; k < array_length(moving); k++)
			{
				var key = moving[k];
				array_push(keys, getIntFromRestructKey(key));
			}
			array_push(newMoving, keys);
		}
		movingData = newMoving;
	}
}

function transform_to_2d_array(byte_array, numFinalRows) {
    var reshaped_array = [];
    var numCols = array_length(byte_array) div numFinalRows;

    // Step 1: Reshape to 2D array (by columns)
    for (var i = 0; i < numCols; i++) {
        var column = [];
        for (var j = 0; j < numFinalRows; j++) {
            array_push(column, byte_array[i * numFinalRows + j]);
        }
        array_push(reshaped_array, column);
    }

    // Step 2: Transpose the 2D array
    var transposed_array = [];
    for (var row = 0; row < numFinalRows; row++) {
        var new_row = [];
        for (var col = 0; col < numCols; col++) {
            array_push(new_row, reshaped_array[col][row]);
        }
        array_push(transposed_array, new_row);
    }

    return transposed_array;
}