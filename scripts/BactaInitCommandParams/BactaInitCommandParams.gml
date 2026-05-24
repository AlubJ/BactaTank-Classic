///
/// Initialise the command line parameters
///
function BactaInitCommandParams()
{
    // File getter
    ArgparRegister("default", [  ], [ ty_string ], [ "" ]);
    
    // Debug log
    ArgparRegister("debug", [ "d" ], [  ], [ false ]);
    
    // Parse
    ArgparParse();
}