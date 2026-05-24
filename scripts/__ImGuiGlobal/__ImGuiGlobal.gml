__ImGuiGlobal();
function __ImGuiGlobal()
{
    static _global = undefined;
    if (_global != undefined) return _global;
    
    _global = {};
    with(_global)
    {
        __ImGMTrace($"Welcome to ImGM by Kenan Masri! This modified version is based on v{IMGM_VERSION}.");
        __ImGMTrace("ImGM is an implementation of ImGui by Omar Cornut for GameMaker. It is also based on prior work by Nommiin.");
        __ImGMTrace($"This particular version is heavily modified by Juju Adams (v{IMGM_EDIT_VERSION}, {IMGM_EDIT_DATE}).");
        
        __currentFrameContext = undefined;
        
        vertex_format_begin();
        vertex_format_add_position();
        vertex_format_add_texcoord();
        vertex_format_add_color();
        __vtxFormat = vertex_format_end();
        
        __vtxFormatStride = vertex_format_get_info(__vtxFormat).stride;
        
        __vtxBuffer = vertex_create_buffer();
        vertex_begin(__vtxBuffer, __vtxFormat);
        vertex_end(__vtxBuffer);
        
        __inputMapping  = __ImGuiCreateKeyboardMapping();
        __cursorMapping = __ImGuiCreateCursorMapping();
        
        __inputRequested = false;
        __inputStore     = undefined;
        
        time_source_start(time_source_create(time_source_global, 1, time_source_units_frames, function()
        {
            if (not instance_exists(__objImGMManager))
            {
                instance_activate_object(__objImGMManager);
                if (instance_exists(__objImGMManager))
                {
                    __ImGMWarning("`__objImGMManager` was deactivated.\nPlease ensure this object instance is never deactivated.");
                }
                else
                {
                    instance_create_depth(0, 0, 0, __objImGMManager);
                }
            }
        },
        [], -1));
    }
    
    return _global;
}