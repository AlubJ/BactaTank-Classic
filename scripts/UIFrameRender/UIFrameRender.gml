// Feather disable all

/// 
/// Render the UI frame
///
function UIFrameRender()
{
    static _system = __UISystem();
    
    with (_system)
    {
        if (ImGuiBeginMainMenuBar())
        {
            if (__currentContext != undefined)
            {
                __contexts[$ __currentContext].menuBar();
                
                ImGuiText(" | ");
                
                if (ImGuiBeginTabBar("Workspaces"))
                {
                    var _i = 0;
                    repeat(array_length(__contexts[$ __currentContext].workspaces))
                    {
                        if (ImGuiBeginTabItem(" " + __contexts[$ __currentContext].workspaces[_i].name + " "))
                        {
                            if (__currentWorkspace != _i)
                            {
                                __currentWorkspace = _i;
                            }
                            
                            ImGuiEndTabItem();
                        }
                        
                        ImGuiEndTabBar();
                    }
                }
            }
            
            var _ident = "";
            
            if (__appName != "")
            {
                _ident += __appName + " | ";
            }
            
            if (__version != "")
            {
                _ident += __version;
            }
            
            ImGuiSetCursorPos(PaneGetWidth() - ImGuiCalcTextWidth(_ident) - 8, 0);
            ImGuiText(_ident);
            
            ImGuiEndMainMenuBar();
        }
        
        var _modals = variable_struct_get_names(__modals);
        
        var _i = 0;
        repeat (array_length(_modals))
        {
            
            var _modal = __modals[$ _modals[_i]];
            
            if (_modal.open)
            {
                _modal.open = false;
                _modal.closed = true;
                _modal.modal.init();
                ImGuiOpenPopup(_modal.name);
            }
            
            if (_modal.fixedSize)
            {
                var _modalWidth = _modal.width;
                var _modalHeight = _modal.height;
                var _modalX = (PaneGetWidth() * 0.5) - (_modalWidth * 0.5);
                var _modalY = (PaneGetHeight() * 0.5) - (_modalHeight * 0.5);
            }
            else
            {
                var _modalWidth = PaneGetWidth() * _modal.width;
                var _modalHeight = PaneGetHeight() * _modal.height;
                var _modalX = (PaneGetWidth() * 0.5) - (_modalWidth * 0.5);
                var _modalY = (PaneGetHeight() * 0.5) - (_modalHeight * 0.5);
            }
            
            var _flags = ImGuiWindowFlags.NoResize | ImGuiWindowFlags.NoMove;
            
            if (!_modal.allowClose)
            {
                _flags |= ImGuiWindowFlags.NoTitleBar;
            }
            
            ImGuiSetNextWindowSize(_modalWidth, _modalHeight, ImGuiCond.Always);
            ImGuiSetNextWindowPos(_modalX, _modalY, ImGuiCond.Always);
            if (ImGuiBeginPopupModal(_modal.name, true, _flags))
            {
                _modal.modal.render(_modalWidth, _modalHeight);
                ImGuiEndPopup();
            }
            else
            {
                if (_modal.closed)
                {
                    _modal.modal.deinit();
                    _modal.closed = false;
                }
            }
            
            _i++;
        }
    }
}