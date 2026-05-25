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
            if (variable_struct_exists(__contexts[$ _context].workspaces, _workspace))
            {
                array_push(__contexts[$ _context].workspaces[$ _workspace].panels, _panel);
                array_push(__contexts[$ _context].workspaces[$ _workspace].flexWeights, _flexWeight);
            }
        }
    }
}