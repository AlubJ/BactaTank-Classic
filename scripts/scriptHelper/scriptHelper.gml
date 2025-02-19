/*
	scriptHelper
	-------------------------------------------------------------------------
	Script:			scriptHelper
	Version:		v1.00
	Created:		10/02/2025 by Alun Jones
	Description:	Script Helper Functions
	-------------------------------------------------------------------------
	History:
	 - Created 10/02/2025 by Alun Jones
	
	To Do:
*/

// Catspeak Compile
function catspeak_compile(buffer, consume)
{
	// Parse And Create The Compiler
	var asg = Catspeak.parse(buffer);
	var compiler = new CatspeakGMLCompiler(asg, Catspeak.interface);
	
	// Compile The Buffer
    var gmlMain;
    do {
        gmlMain = compiler.update();
    } until (gmlMain != undefined);
	
	// Run All Code Outside Of Any Function Calls
	gmlMain();
	
	// After Compilation Search For Functions
	//var globals = compiler.sharedData.globals;

	// Delete Buffer
	if (consume) buffer_delete(buffer);
}

function catspeak_compile_extern(buffer, consume)
{
	// Parse And Create The Compiler
	var asg = Catspeak.parse(buffer);
	var compiler = new CatspeakGMLCompiler(asg, Catspeak.interface);
	
	// Compile The Buffer
    var gmlMain;
    do {
        gmlMain = compiler.update();
    } until (gmlMain != undefined);
	
	// Run All Code Outside Of Any Function Calls
	gmlMain();
	
	// After Compilation Search For Functions
	var globals = compiler.sharedData.globals;
	var globalNames = variable_struct_get_names(globals);
	
	for (var i = 0; i < array_length(globalNames); i++)
	{
		Catspeak.addFunction(globalNames[i], variable_struct_get(globals, globalNames[i]));
	}

	// Delete Buffer
	if (consume) buffer_delete(buffer);
}

function catspeak_compile_extern_old(buffer, consume)
{
	// Create Lexer, Intermediate Representation, Compiler and Virtual Machine
	var lexer = new CatspeakLexer(buffer);
	var ir = new CatspeakFunction();
	var compiler = new CatspeakCompiler(lexer, ir);
	var vm = new CatspeakVM();
	
	// Compile Intermediate Representation
	while(compiler.inProgress()) compiler.emitProgram(5);
	
	// Run Compile Program to Grab Inner Functions
    vm.pushCallFrame(self, ir, [], 0, 0);
    while(vm.inProgress()) vm.runProgram(5);
	
	// After Compilation Search For Functions
	var globalNames = variable_struct_get_names(ir.globalRegisterTable);
	
	for (var i = 0; i < array_length(globalNames); i++)
	{
		var globalRegister = ir.globalRegisters[variable_struct_get(ir.globalRegisterTable, globalNames[i])];
		if (is_struct(globalRegister) && variable_struct_exists(globalRegister, "isFunction"))
		{
			catspeak_add_function(globalNames[i], catspeak_into_gml_function(globalRegister));
		}
	}
	
	// Delete Buffer
	if (consume) buffer_delete(buffer);
}

function catspeak_function_execute(func, args = [  ])
{
	// Run Function
	method_call(func, args);
	
	// Clean Up Buffers
	repeat (array_length(SCRIPT_BUFFERS))
	{
		// Get Script Buffer
		var scriptBuffer = array_pop(SCRIPT_BUFFERS);
		
		// Clean Up
		if (buffer_exists(scriptBuffer._buffer)) buffer_delete(scriptBuffer._buffer);
	}
}