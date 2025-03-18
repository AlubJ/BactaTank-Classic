function file_dropper_get_files(extensions = []) {
    if (!is_array(extensions)) extensions = [extensions];
	var n = __file_dropper_count();
	var array = [];
    
    var extn = array_length(extensions);
    
	for (var i = 0; i < n; i++) {
	    var filename = string_lower(__file_dropper_get(i));
        if (extn == 0) {
            array_push(array, filename);
            continue;
        }
        for (var j = 0; j < extn; j++) {
            if (string_lower(filename_ext(filename)) == extensions[j]) {
                array_push(array, filename);
                break;
            }
        }
	}
    
    array_sort(array, true);
    
	return array;
}