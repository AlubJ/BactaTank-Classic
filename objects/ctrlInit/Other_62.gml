/// @desc Get Latest Update Version
/*
	ctrlInit.AsyncHTTP
	-------------------------------------------------------------------------
	Script:			ctrlInit.AsyncHTTP
	Version:		v1.00
	Created:		06/05/2025 by Alun Jones
	Description:	Get Latest Update Version
	-------------------------------------------------------------------------
	History:
	 - Created 06/05/2025 by Alun Jones
	
	To Do:
*/

if (async_load[? "id"] == requestID)
{
    var _status = async_load[? "status"];
    VERSION_LATEST = (_status == 0) ? async_load[? "result"] : noone;
}