// Feather disable all

function __PaneWarn(_string)
{
    if (PANE_RUNNING_FROM_IDE)
    {
        show_error($" \Pane:\n{_string}\n ", true);
    }
    else
    {
        show_debug_message($"Pane: Warning! {_string}");
    }
}