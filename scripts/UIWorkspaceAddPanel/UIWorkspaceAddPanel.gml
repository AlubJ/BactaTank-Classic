// Feather disable all

///
/// Add a new panel
///
/// @param {String} context The name of the context the panel sits in
/// @param {String} workspace The name of the workspace the panel sits in
/// @param {Struct} panel The constructed panel
/// @param {Real} flexWeight The weight of panel's width
function UIWorkspaceAddPanel(_context, _workspace, _panel, _flexWeight)
{
    static _system = __UISystem();
    
    with (_system)
    {
        if (variable_struct_exists(__contexts, _context))
        {
            var _i = 0;
            repeat (array_length(__contexts[$ _context].workspaces))
            {
                if (__contexts[$ _context].workspaces[_i].name == _workspace)
                {
                    array_push(__contexts[$ _context].workspaces[_i].panels, _panel);
                    array_push(__contexts[$ _context].workspaces[_i].flexWeights, _flexWeight);
                }
                _i++;
            }
        }
    }
}