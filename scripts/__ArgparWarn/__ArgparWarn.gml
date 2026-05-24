// Feather disable all

function __ArgparWarn(_string)
{
    if (ARGPAR_RUNNING_FROM_IDE)
    {
        show_error($" \Argpar:\n{_string}\n ", true);
    }
    else
    {
        show_debug_message($"Argpar: Warning! {_string}");
    }
}