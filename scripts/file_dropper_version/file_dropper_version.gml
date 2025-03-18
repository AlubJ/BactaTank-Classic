function file_dropper_version() {
    show_debug_message("File dropper GML version: " + FILE_DROPPER_VERSION);
    show_debug_message("File dropper DLL version: " + __file_dropper_version());
}

file_dropper_version();