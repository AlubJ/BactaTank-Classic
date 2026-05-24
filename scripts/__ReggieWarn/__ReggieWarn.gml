// Feather disable all

function __ReggieWarn(_string)
{
    if (REGGIE_RUNNING_FROM_IDE)
    {
        show_error($" \Reggie:\n{_string}\n ", true);
    }
    else
    {
        show_debug_message($"Reggie: Warning! {_string}");
    }
}