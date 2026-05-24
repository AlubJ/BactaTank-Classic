// Feather disable all

/// Constructor that creates an ImGui context. You can think of an ImGui context as an ImGui
/// "instance". Generally speaking you'll only ever want one ImGui context in your game. Even if
/// you find yourself in a position where you need multiple contexts, you should generally only
/// have one context actively in use at any one time.
/// 
/// N.B. If you no longer need to use an ImGui context then you must call the `.Destroy()` method
///      for the context to free memory. Not doing so creates a memory leak.
/// 
/// @param xOffset
/// @param yOffset
/// @param width
/// @param height
/// @param [configFlags]
/// @param [configFlagsUnset]
/// 
/// `.GetInitialized()`
///     Returns if the ImGui context was successfully initialized.
/// 
/// `.Destroy()`
///     Frees memory associated with the ImGui context. This also "deinitialized" the context such
///     that `.GetInitialized()` will return `false`.
/// 
/// `.FrameStart(mouseX, mouseY, [setOSCursor=true], [hasFocus=true])`
///     Starts constructing an ImGui frame. Only one frame may be open for construction at a time.
///     If you're using multiple contexts, you'll want to manage the cursor image and focus
///     yourself manually or else the contexts will fight each other.
/// 
/// `.FrameEnd()`
///     Finishes constructing an ImGui frame. You may call `.FrameStart()` for another context
///     after calling this method.
/// 
/// `.Draw()`
///     Draws the internal surface at the context's x/y position. This is a convenience function
///     that calls `.UpdateSurface()` and `.GetSurface()` for you.
/// 
/// `.SetRegion([xOffset], [yOffset], [width], [height])`
///     Sets the active region for the ImGui context. Any parameter that is not provided will be
///     left at its current value.
/// 
/// `.GetRegion()`
///     Returns a statically allocated struct that contains the current context region.
/// 
/// `.GetPointInside(x, y)`
///     Returns if the given point is inside the context's defined region.
/// 
/// `.GetCursor()`
///     Returns the OS cursor type that this context wants to set. Unless you're managed the OS
///     cursor manually (such as if there are multiple contexts) then you don't need to worry about
///     this method.
/// 
/// `.UpdateSurface()`
///     Renders the user interface onto the internal surface for the context. If you're calling
///     `.Draw()` then you don't need to call this method.
/// 
/// `.GetSurface()`
///     Returns the internal surface used to render the user interface. The surface will not
///     necessarily be up-to-date with the current state of the user interface if you haven't
///     called either `.Draw()` or `.UpdateSurface()` since the last frame was constructed. If
///     the ImGui context has been destroyed (or failed to initialize) then this function will
///     return `-1`.

function ImGuiContext(_xOffset, _yOffset, _width, _height, _configFlagsSet = ImGuiConfigFlags.None, _configFlagsUnset = ImGuiConfigFlags.None) constructor
{
    static _global = __ImGuiGlobal();
    
    ///////
    // State variables passed to ImGui
    ///////
    
    Display = {
        Width: _width,
        Height: _height,
        Scale: 1,
        Font: -1,
    };
    
    Input = {
        Mouse: {
            X: 0,
            Y: 0
        }
    };
    
    Engine = {
        Context: ImGuiCreateContext(),
        Time: 0,
        Framerate: game_get_speed(gamespeed_fps),
    };
    
    Renderer = {
        CmdBuffer: buffer_create(__IMGM_BUFFER_SIZE, buffer_grow, 1),
        FontBuffer: buffer_create(__IMGM_BUFFER_SIZE, buffer_grow, 1),
        Surface: -1,
        UpdateFont: true,
    };
    
    ///////
    // State variables not passed to ImGui
    ///////
    
    __xOffset = _xOffset;
    __yOffset = _yOffset;
    
    __initialized = false;
    __cursor = cr_default;
    __surfaceDirty = true;
    
    
    
    var _initializeResult =  __imgui_initialize(window_handle(),
                                                Engine.Context,
                                                {
                                                    ConfigFlagsOverrideSet: _configFlagsSet,
                                                    ConfigFlagsOverrideClear: _configFlagsUnset,
                                                    
                                                    //Force GameMaker native rendering. Magic number derived from old enum
                                                    GFlags: 3,
                                                    
                                                    //Unused because we're forcing native rendering
                                                    D3DDevice: pointer_null,
                                                    D3DDeviceContext: pointer_null,
                                                });
    
    if ((_initializeResult == pointer_null) || (_initializeResult == undefined))
    {
        Destroy();
    }
    else
    {
        __initialized = true;
    }
    
    
    
    static GetInitialized = function()
    {
        return __initialized;
    }
    
    static SetRegion = function(_xOffset = __xOffset, _yOffset = __yOffset, _width = Display.Width, _height = Display.Height)
    {
        __xOffset = _xOffset;
        __yOffset = _yOffset;
        
        Display.Width  = _width;
        Display.Height = _height;
    }
    
    static GetRegion = function()
    {
        static _result = {};
        
        with(_result)
        {
            xOffset = __xOffset;
            yOffset = __yOffset;
            width   = Display.Width;
            height  = Display.Height;
        }
        
        return _result;
    }
    
    static GetPointInside = function(_x, _y)
    {
        return point_in_rectangle(_x, _y, __xOffset, __yOffset, __xOffset + Display.Width - 1, __yOffset + Display.Height - 1);
    }
    
    static FrameStart = function(_mouseX, _mouseY, _setOSCursor = true, _hasFocus = true)
    {
        if (not __initialized) return;
        
        if (_global.__currentFrameContext != undefined)
        {
            __ImGMError("Cannot start a new frame, the previous frame has not been ended");
        }
        
        _global.__currentFrameContext = self;
        ImGuiSetCurrentContext(Engine.Context);
        
        __surfaceDirty = true;
        
        Engine.Time = delta_time / 1_000_000;
        Engine.Framerate = game_get_speed(gamespeed_fps);

        if ((Display.Width > 0) && (Display.Height > 0))
        {
            var _keyboardFunc = keyboard_check; //TODO - Maybe one day expose this
            
            //TODO - Should keyboard collection be inside a focus check?
            var _inputMappingArray = _global.__inputMapping;
            for(var i = ImGuiKey.NamedKey_BEGIN; i < ImGuiKey.NamedKey_END; i++)
            {
                var key = _inputMappingArray[i];
                if (key > -1) __imgui_key(i, _keyboardFunc(key));
            }
            
            __imgui_key(ImGuiKey.ImGuiMod_Ctrl,  _keyboardFunc(vk_lcontrol));
            __imgui_key(ImGuiKey.ImGuiMod_Shift, _keyboardFunc(vk_lshift));
            __imgui_key(ImGuiKey.ImGuiMod_Alt,   _keyboardFunc(vk_lalt) || _keyboardFunc(vk_ralt));
            
            if (_hasFocus && window_has_focus())
            {
                var _mouseFunc = mouse_check_button; //TODO - Maybe one day expose this
                
                //FIXME - Almost certainly breaks with multiple contexts
                if (__imgui_want_text_input(undefined))
                {
                    if (not _global.__inputRequested)
                    {
                        _global.__inputRequested = true;
                        _global.__inputStore = keyboard_string;
                        keyboard_string = "";
                    }
                    
                    if (__imgui_input(keyboard_string))
                    {
                        keyboard_string = "";
                    }
                }
                else
                {
                    if (_global.__inputRequested)
                    {
                        keyboard_string = _global.__inputStore;
                        _global.__inputRequested = false;
                    }
                }
                
                Input.Mouse.X = _mouseX - __xOffset;
                Input.Mouse.Y = _mouseY - __yOffset;
                
                __imgui_mouse(0, _mouseFunc(mb_left));
                __imgui_mouse(1, _mouseFunc(mb_right));
                __imgui_mouse(2, _mouseFunc(mb_middle));
                
                __imgui_mouse_wheel(0, mouse_wheel_up() - mouse_wheel_down());
                
                __cursor = _global.__cursorMapping[__imgui_mouse_cursor() + 1];
                
                if (_setOSCursor && point_in_rectangle(display_mouse_get_x(), display_mouse_get_y(),
                                                       window_get_x() + __IMGM_WINDOW_EDGE,
                                                       window_get_y() + __IMGM_WINDOW_EDGE,
                                                       window_get_x() + window_get_width() - __IMGM_WINDOW_EDGE,
                                                       window_get_y() + window_get_height() - __IMGM_WINDOW_EDGE))
                {
                    window_set_cursor(__cursor);
                }
            }
        }
        
        __imgui_new_frame(self);

        if (buffer_peek(Renderer.FontBuffer, 0, buffer_bool))
        {
            if (sprite_exists(Display.Font)) sprite_delete(Display.Font);
            var font = surface_create(buffer_peek(Renderer.FontBuffer, 1, buffer_u32), buffer_peek(Renderer.FontBuffer, 5, buffer_u32));
            buffer_set_surface(Renderer.FontBuffer, font, 9);
            Display.Font = sprite_create_from_surface(font, 0, 0, surface_get_width(font), surface_get_height(font), false, false, 0, 0);
            surface_free(font);
            Renderer.UpdateFont = false;
        }
    }
    
    static FrameEnd = function()
    {
        if (not __initialized) return;
        
        if (_global.__currentFrameContext != self)
        {
            __ImGMError("Cannot end this context's frame, it has not been started");
        }
        
        _global.__currentFrameContext = undefined;
        
        __imgui_end_frame();
    }
    
    static Draw = function()
    {
        if (not __initialized) return;
        
        if (__surfaceDirty)
        {
            UpdateSurface();
        }
        
        gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_one, bm_inv_src_alpha); //Pre-multiplied alpha blend mode
        draw_surface(GetSurface(), __xOffset, __yOffset);
        gpu_set_blendmode(bm_normal);
    }
    
    static GetCursor = function()
    {
        return __cursor;
    }
    
    static UpdateSurface = function()
    {
        if (not __initialized) return;
        
        __surfaceDirty = false;
        
        ImGuiSetCurrentContext(Engine.Context);
        __imgui_render();
        __imgui_draw(self);
        
        var _cmdBuffer = Renderer.CmdBuffer;
        buffer_seek(_cmdBuffer, buffer_seek_start, 0);
        
        if (buffer_read(_cmdBuffer, buffer_bool))
        {
            //Cache values for better performance inside the loop
            var _vertexBuffer = _global.__vtxBuffer;
            var _vertexStride = _global.__vtxFormatStride;
            var _fontTerxture = Display.Font;
            
            //Keep a copy of the current scissor state for later reset
            var _oldScissor = gpu_get_scissor();
            
            surface_set_target(GetSurface());
            draw_clear_alpha(c_black, 0);
            
            //FIXME - Sanitize render state
            
            gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_one, bm_inv_src_alpha); //Pre-multiplied alpha blend mode
            
            repeat(buffer_read(_cmdBuffer, buffer_u32)) //Lists
            {
                repeat(buffer_read(_cmdBuffer, buffer_u32)) //Commands
                {
                    if (not buffer_read(_cmdBuffer, buffer_bool))
                    {
                        var _textureData = buffer_read(_cmdBuffer, buffer_u32);
                        switch (_textureData & 0xF)
                        {
                            case ImGuiTextureType.Surface:
                                var _texturePointer = surface_get_texture(_textureData >> 16);
                            break;

                            case ImGuiTextureType.Font:
                                var _texturePointer = sprite_get_texture(_fontTerxture, 0);
                            break;

                            case ImGuiTextureType.Sprite:
                                var _texturePointer = sprite_get_texture(_textureData >> 16, (_textureData >> 4) & 0xFFF);
                            break;
                            
                            default:
                                var _texturePointer = -1;
                            break;
                        }

                        var _x1 = buffer_read(_cmdBuffer, buffer_f32);
                        var _y1 = buffer_read(_cmdBuffer, buffer_f32);
                        var _x2 = buffer_read(_cmdBuffer, buffer_f32);
                        var _y2 = buffer_read(_cmdBuffer, buffer_f32);
                        gpu_set_scissor(_x1, _y1, _x2 - _x1, _y2 - _y1);
                            
                        var _vertexCount = buffer_read(_cmdBuffer, buffer_u32);
                        vertex_update_buffer_from_buffer(_vertexBuffer, 0, _cmdBuffer, buffer_tell(_cmdBuffer), _vertexStride*_vertexCount);
                        vertex_submit_ext(_vertexBuffer, pr_trianglelist, _texturePointer, 0, _vertexCount)
                            
                        buffer_seek(_cmdBuffer, buffer_seek_relative, _vertexStride*_vertexCount);
                    }
                }
            }
            
            surface_reset_target();
            gpu_set_blendmode(bm_normal);
            gpu_set_scissor(_oldScissor);
        }
    }
    
    static GetSurface = function()
    {
        if (not __initialized) return -1;
        
        var _displayWidth  = Display.Width;
        var _displayHeight = Display.Height;
        
        var _surface = Renderer.Surface;
        if (surface_exists(_surface) && ((surface_get_width(_surface) != _displayWidth) || (surface_get_height(_surface) != _displayHeight)))
        {
            surface_free(_surface);
        }
        
        if (not surface_exists(_surface))
        {
            _surface = surface_create(max(1, _displayWidth), max(1, _displayHeight));
            
            surface_set_target(_surface);
            draw_clear_alpha(c_black, 0);
            surface_reset_target();
            
            Renderer.Surface = _surface;
        }
        
        return _surface;
    }
    
    static Destroy = function()
    {
        if (is_ptr(Engine.Context))
        {
            if (__initialized)
            {
                __imgui_shutdown(__state.Engine.Context);
            }
            
            ImGuiDestroyContext(Engine.Context);
        }
        
        Engine.Context = pointer_null;
        
        if (buffer_exists(Renderer.CmdBuffer)) buffer_delete(Renderer.CmdBuffer);
        Renderer.CmdBuffer = -1;
        
        if (buffer_exists(Renderer.FontBuffer)) buffer_delete(Renderer.FontBuffer);
        Renderer.FontBuffer = -1;
        
        if (surface_exists(Renderer.Surface)) surface_free(Renderer.Surface);
        Renderer.Surface = -1;
        
        __initialized = false;
        __cursor = cr_default;
    }
}