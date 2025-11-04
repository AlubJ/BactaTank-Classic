/// @func normalize_angle(angle)
/// @desc Normalize an angle between 0-360.
/// @arg {Real} angle Angle
/// @returns {Real}
function normalize_angle(_angle)
{
    return ((_angle % 360) + 360) % 360; 
}

/// @func lerp_angle(angle1, angle2, time)
/// @desc Interpolate two angles, find the shortest possible path.
/// @arg {Real} angle1 Angle 1
/// @arg {Real} angle2 Angle 2
/// @arg {Real} time time
/// @returns {Real}
function lerp_angle(_angle1, _angle2, _t)
{
    _angle1 = normalize_angle(_angle1);
    _angle2 = normalize_angle(_angle2);

    var _delta = _angle2 - _angle1;

    if (_delta > 180)
	{
        _delta -= 360;
    }
	else if (_delta <= -180)
	{
        _delta += 360;
    }

    var _interpolated = _angle1 + (_delta * _t);

    return normalize_angle(_interpolated);
}