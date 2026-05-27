// Feather disable all

function __StashBuildFilter(_filterArray)
{
    static _system = __StashSystem();
    
    with (_system)
    {
        var _returnFilter = "";
        var _allExtensions = "";
        
        var _i = 0;
        repeat(array_length(_filterArray))
        {
            var _key = _filterArray[_i];
            
            if (!variable_struct_exists(__filetypes, _key))
            {
                _i++;
                continue;
            }
            
            var _filter = __filetypes[$ _key];
            
            if (_returnFilter != "")
            {
                _returnFilter += "|";
            }
            
            _returnFilter += _filter.description + " (" + _filter.extension + ")"  + "|" + _filter.extension;

            if (_allExtensions != "")
            {
                _allExtensions += ";";
            }

            _allExtensions += _filter.extension;
            
            _i++;
        }
        
        if (array_length(_filterArray) > 1 && _allExtensions != "")
        {
            var _allFilter = "All Supported Files (" + _allExtensions + ")|" + _allExtensions;

            if (_returnFilter != "")
            {
                _returnFilter = _allFilter + "|" + _returnFilter;
            }
            else
            {
                _returnFilter = _allFilter;
            }
        }
        
        return _returnFilter;
    }
}