// Feather disable all

///
/// Set the current context that cutter will detect shortcuts in.
///
/// @param {String} context The context name to detect for. Set as `undefined` to only use the global context.
function CutterSetContext(_context)
{
    static _system = __CutterSystem();
    
    with (_system)
    {
        __currentContext = _context;
    }
}