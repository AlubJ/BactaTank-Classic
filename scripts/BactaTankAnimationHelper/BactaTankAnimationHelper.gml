/*
	BactaTankAnimationHelper
	-------------------------------------------------------------------------
	Script:			BactaTankAnimationHelper
	Version:		v1.00
	Created:		01/05/2025 by Alun Jones (Adapted from Clarence Oveur EasyAN3 Python Script)
	Description:	BactaTank Animation Helper Constructors
	-------------------------------------------------------------------------
	History:
	 - Created 01/05/2025 by Alun Jones
	
	To Do:
*/

function BactaTankAnimationKeyFrameBlock(_value = 0) constructor
{
	value = _value;
	sec0 = 0;
	sec1 = 0;
	sec2 = 0;
	sec3 = 0;
	
	static getArray = function()
	{
		return [value, [sec0, sec1, sec2, sec3]];
	}
	
	static calcSections = function(nextVal, _sec0, _sec1, _sec2, _sec3)
	{
		var delta = nextVal - value;
		if (delta == 0)
		{
			sec0 = 0;
			sec1 = 0;
			sec2 = 0;
			sec3 = 0;
		}
		else
		{
			sec0 = (63*((_sec0-value)/delta));
			sec1 = (63*((_sec1-value)/delta));
			sec2 = (63*((_sec2-value)/delta));
			sec3 = (63*((_sec3-value)/delta));
		}
	}
}

function BactaTankAnimationCurve(_isStatic = true, _staticValue = 0, _keyValues = noone) constructor
{
	isStatic = _isStatic;
	staticValue = _staticValue;
	keyValues = _keyValues;
	
	static setStatic = function(value)
	{
		isStatic = true;
		staticValue = value;
		keyValues = noone;
	}
	
	static setMoving = function(_keyValues)
	{
		isStatic = false;
		staticValue = noone;
		keyValues = _keyValues;
	}
}

function BactaTankAnimationNode(_flag = 0, _curves = array_create(9, new BactaTankAnimationCurve())) constructor
{
	flag = _flag;
	curves = _curves;
	
	static getFlag = function(_flag)
	{
		return (flag & _flag != 0);
	}
	
	static setFlag = function(_flag, _value)
	{
		if (_value) flag |= _flag;
		else flag = flag & (~_flag);
	}
	
	static applyTransRot = function()
	{
		setFlag(BT_KEYFRAME_FLAGS.APPLY_ROTATION, true);
		setFlag(BT_KEYFRAME_FLAGS.APPLY_TRANSLATION, true);
	}
}