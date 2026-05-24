// Feather disable all

/// @param string

function __ImGMWarning(_string)
{
    if (IMGM_RUNNING_FROM_IDE)
    {
        show_error($" \nImGM:\n{_string}\n ", true);
    }
    else
    {
        show_debug_message($"ImGM: Warning! {_string}");
    }
}