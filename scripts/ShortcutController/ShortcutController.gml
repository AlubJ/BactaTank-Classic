function ShortcutController()
{
	if (keyboard_check(vk_control))
	{
		if (keyboard_check_pressed(ord("O")))
		{
			ENVIRONMENT.openConfirmModal("Unsaved Changes", "Are you sure you want to continue?", function() {
				openProjectOrModelDialog();
			});
		}
		else if (keyboard_check_pressed(ord("S")))
		{
			saveModelDialog();
		}
		else if (keyboard_check_pressed(ord("N")))
		{
			ENVIRONMENT.openConfirmModal("Unsaved Changes", "Are you sure you want to continue?", function() {
				ENVIRONMENT.openModal("Welcome");
			});
		}
		else if (keyboard_check_pressed(ord("P")))
		{
			ENVIRONMENT.openModal("Preferences");
		}
	}
	else if (keyboard_check_pressed(vk_f12))
	{
		var file = get_save_filename_ext("Portable Network Graphics (*.png)|*.png", "Render.png", "", "Export Render");
		if (file != "" && ord(file) != 0)
		{
			surface_save(RENDERER.surface, file);
		}
	}
}