/// @desc Render Environments
/*
	ctrlUI.Step
	-------------------------------------------------------------------------
	Script:			ctrlUI.Step
	Version:		v1.00
	Created:		15/11/2024 by Alun Jones
	Description:	Render Environments
	-------------------------------------------------------------------------
	History:
	 - Created 15/11/2024 by Alun Jones
	
	To Do:
*/

// Render
if (!window_is_minimised()) ENVIRONMENT.render();

// Quit Check
if (window_command_check(window_command_close)) {
	ENVIRONMENT.openConfirmModal("Unsaved Changes", "Are you sure you want to quit?", function() {
		window_command_run(window_command_close);
	});
}