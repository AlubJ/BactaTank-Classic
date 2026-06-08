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
        
        if (__currentContext != undefined)
        {
            var _workspace = __contexts[$ __currentContext].workspaces[__currentWorkspace];
            
            var _i = 0;
            var _spacing = 4;
            var _totalSpacing = (_spacing * array_length(_workspace.panels)) + _spacing;
            var _menuBarHeight = 24;
            var _height = PaneGetHeight() - _menuBarHeight - _spacing - (_spacing / 2);
            var _x = _spacing;
            var _y = _menuBarHeight + (_spacing / 2);
            
            repeat (array_length(_workspace.panels))
            {
                var _width = (PaneGetWidth() - _totalSpacing) * _workspace.flexWeights[_i];
                
                ImGuiSetNextWindowPos(_x, _y, ImGuiCond.Always);
                ImGuiSetNextWindowSize(_width, _height, ImGuiCond.Always);
                
                if (ImGuiBegin($"{_workspace.name}", true, ImGuiWindowFlags.NoResize | ImGuiWindowFlags.NoMove | ImGuiWindowFlags.NoTitleBar))
                {
                    _workspace.panels[_i].render(_width, _height);
                    ImGuiEnd();
                }
                
                _x += _width + _spacing;
                
                _i++;
            }
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