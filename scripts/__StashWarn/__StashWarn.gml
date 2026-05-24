// Feather disable all

function __StashWarn(_string)
{
    if (STASH_RUNNING_FROM_IDE)
    {
        show_error($" \Stash:\n{_string}\n ", true);
    }
    else
    {
        show_debug_message($"Stash: Warning! {_string}");
    }
}