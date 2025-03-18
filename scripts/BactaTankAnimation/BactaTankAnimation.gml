/*
	BactaTankAnimation
	-------------------------------------------------------------------------
	Script:			BactaTankAnimation
	Version:		v1.00
	Created:		20/02/2025 by Alun Jones (Adapted from Clarence Oveur EasyAN3 Python Script)
	Description:	BactaTank Animation Constructor
	-------------------------------------------------------------------------
	History:
	 - Created 20/02/2025 by Alun Jones
	
	To Do:
*/

enum BT_KEYFRAME_FLAGS
{
	APPLY_ROTATION			= 1 << 0,
	APPLY_TRANSLATION		= 1 << 1,
	APPLY_SCALE				= 1 << 3,
	APPLY_INV_SCALE			= 1 << 4,
	UNKNOWN					= 1 << 5,
	BASE_JOINT_SCALE_1		= 1 << 6,
}

function BactaTankAnimation() constructor
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
			
			movingData = transformTo2DArray(movingDataRaw, numMoving);
			
			movingDataReconstructedRaw = [];
			for (var i = 0; i < array_length(movingData); i++)
			{
				for (var j = 0; j < array_length(movingData[i]); j++)
				{
					var scalingRawBytes = movingData[i][j] >> 8;
					var scaling = [scalingRawBytes & 0x3f, (scalingRawBytes >> 6) & 0x3f, (scalingRawBytes >> 12) & 0x3f, (scalingRawBytes >> 18) & 0x3f];
					var v = [movingData[i][j] & 0xFF, scaling];
					array_push(movingDataReconstructedRaw, v);
				}
			}
			
			for (var i = 0; i < array_length(movingDataReconstructedRaw); i += array_length(movingData[i]))
			{
				//array_copy(movingDataReconstructed, i, );
			}
		}
	}
}

function transformTo2DArray(data, rowCount)
{
	var newArray = [];
	var columnCount = array_length(data) / rowCount;
	for (var i = 0; i < rowCount; i++)
	{
		var newRow = [];
		for (var j = 0; j < columnCount; j++)
		{
			array_push(newRow, data[i + (rowCount * j)]);
		}
		array_push(newArray, newRow);
	}
	return newArray;
}