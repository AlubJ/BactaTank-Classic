// Feather disable all

function __BactaWarn(_string)
{
    if (BACTA_RUNNING_FROM_IDE)
    {
        show_error($" \nBactaTank:\n{_string}\n ", true);
    }
    else
    {
        show_debug_message($"BactaTank: Warning! {_string}");
    }
}