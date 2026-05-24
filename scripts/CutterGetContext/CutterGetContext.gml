// Feather disable all

///
/// Get the current context that cutter will detect shortcuts in.
///
function CutterGetContext()
{
    static _system = __CutterSystem();
    
    with (_system)
    {
        return __currentContext;
    }
}