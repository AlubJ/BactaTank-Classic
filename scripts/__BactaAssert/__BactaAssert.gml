// Feather disable all

function __BactaAssert(_condition, _string = "Condition failed.")
{
	// Check
	if (!_condition) __BactaError(BACTA_LINE_TRACE + _string);
}