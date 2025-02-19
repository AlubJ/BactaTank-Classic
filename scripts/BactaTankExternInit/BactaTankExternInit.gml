/*
	BactaTankExternInit
	-------------------------------------------------------------------------
	Script:			BactaTankExternInit
	Version:		v1.00
	Created:		10/02/2025 by Alun Jones
	Description:	External functions init
	-------------------------------------------------------------------------
	History:
	 - Created 10/02/2025 by Alun Jones
	
	To Do:
*/

function BactaTankExternInit()
{
	// Add Function Libraries
	Catspeak.addConstant("BactaTank", new BactaTankExtern());
	Catspeak.addConstant("Random", new BactaTankExternRandom());
	Catspeak.addConstant("Array", new BactaTankExternArray());
	Catspeak.addConstant("File", new BactaTankExternFile());
	Catspeak.addConstant("Directory", new BactaTankExternDirectory());
	Catspeak.addConstant("Math", BactaTankExternMath());
	Catspeak.addConstant("String", new BactaTankExternString());
	
	// Buffer Lib
	Catspeak.addFunction("Buffer", newBactaTankExternBuffer);
	
	Catspeak.addConstant(
		// Data Types
		"bufferUByte", buffer_u8,
		"bufferSByte", buffer_s8,
		"bufferInt16", buffer_s16,
		"bufferInt32", buffer_s32,
		"bufferUInt16", buffer_u16,
		"bufferUInt32", buffer_u32,
		"bufferUInt64", buffer_u64,
		"bufferHalf", buffer_f16,
		"bufferSingle", buffer_f32,
		"bufferDouble", buffer_f64,
		"bufferMatrix", 0xff,
		"bufferBool", buffer_bool,
		"bufferString", buffer_text,
		"bufferText", buffer_text,
		
		// Seek
		"bufferSeekStart", buffer_seek_start,
		"bufferSeekRelative", buffer_seek_relative,
		"bufferSeekEnd", buffer_seek_end,
		
		// Endianess
		"bufferLittle", ENDIANESS.LITTLE,
		"bufferBig", ENDIANESS.BIG,
	);
	
	// Add Script Types
	Catspeak.addConstant("TOOL_SCRIPT", BactaTankScript.Tool);
	Catspeak.addConstant("MATERIAL_SCRIPT", BactaTankScript.Material);
	Catspeak.addConstant("MESH_SCRIPT", BactaTankScript.Mesh);
	
	// Create Scripting Global
	global.__catspeakGlobals = {  };
	
	// Set Catspeak Presets
	Catspeak.renameKeyword(
		"fun", "function",
		"let", "var");
}