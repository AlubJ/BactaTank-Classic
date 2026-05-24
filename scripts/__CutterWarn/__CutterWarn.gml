// Feather disable all

function __CutterWarn(_string)
{
    if (CUTTER_RUNNING_FROM_IDE)
    {
        show_error($" \Cutter:\n{_string}\n ", true);
    }
    else
    {
        show_debug_message($"Cutter: Warning! {_string}");
    }
}