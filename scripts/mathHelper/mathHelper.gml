/*
	mathHelper
	-------------------------------------------------------------------------
	Script:			mathHelper
	Version:		v1.00
	Created:		26/01/2025 by Alun Jones
	Description:	Math Functions
	-------------------------------------------------------------------------
	History:
	 - Created 26/01/2025 by Alun Jones
	
	To Do:
*/

function matrix_decompose(matrix)
{
	// Translation
	var translation = [ matrix[12], matrix[13], matrix[14] ];
	
	// Pre Scale
	var xs = (sin(matrix[0] * matrix[1] * matrix[2] * matrix[3]) < 0) ? -1 : 1;
	var ys = (sin(matrix[4] * matrix[5] * matrix[6] * matrix[7]) < 0) ? -1 : 1;
	var zs = (sin(matrix[8] * matrix[9] * matrix[10] * matrix[11]) < 0) ? -1 : 1;
	
	// Scale
	var scale = [];
    scale[0] = xs * sqrt(matrix[0] * matrix[0] + matrix[1] * matrix[1] + matrix[2] * matrix[2]);
    scale[1] = ys * sqrt(matrix[4] * matrix[4] + matrix[5] * matrix[5] + matrix[6] * matrix[6]);
    scale[2] = zs * sqrt(matrix[8] * matrix[8] + matrix[9] * matrix[9] + matrix[10] * matrix[10]);
	
	// Check Scale
    if (scale[0] == 0.0 || scale[0] == 0.0 || scale[0] == 0.0)
    {
        var rotation = [0, 0, 0];
        return [translation, rotation, scale];
    }

    var rotationMatrix = [matrix[0] / scale[0], matrix[1] / scale[0], matrix[2] / scale[0], 0,
                          matrix[4] / scale[1], matrix[5] / scale[1], matrix[6] / scale[1], 0,
                          matrix[8] / scale[2], matrix[9] / scale[2], matrix[10] / scale[2], 0,
                          0, 0, 0, 1];

    var quaternion = quaternion_from_matrix(rotationMatrix);
	var euler = euler_from_quaternion(quaternion);
	
    return [translation, [ -radtodeg(euler[0]), -radtodeg(euler[1]), -radtodeg(euler[2]) ], scale];
}

function quaternion_from_matrix(matrix)
{
	var quaternion;
    var _sqrt;
    var half;
    var scale = matrix[0] + matrix[5] + matrix[10];

	if (scale > 0.0)
	{
        _sqrt = sqrt(scale + 1.0);
		quaternion[3] = _sqrt * 0.5;
        _sqrt = 0.5 / _sqrt;

		quaternion[0] = (matrix[6] - matrix[9]) * _sqrt;
		quaternion[1] = (matrix[8] - matrix[2]) * _sqrt;
		quaternion[2] = (matrix[1] - matrix[4]) * _sqrt;

		return quaternion;
	}
	if ((matrix[0] >= matrix[5]) && (matrix[0] >= matrix[10]))
	{
        _sqrt = sqrt(1.0 + matrix[0] - matrix[5] - matrix[10]);
        half = 0.5 / _sqrt;

		quaternion[0] = 0.5 * _sqrt;
		quaternion[1] = (matrix[1] + matrix[4]) * half;
		quaternion[2] = (matrix[2] + matrix[8]) * half;
		quaternion[3] = (matrix[6] - matrix[9]) * half;

		return quaternion;
	}
	if (matrix[5] > matrix[10])
	{
        _sqrt = sqrt(1.0 + matrix[5] - matrix[0] - matrix[10]);
        half = 0.5 / _sqrt;

		quaternion[0] = (matrix[4] + matrix[1]) * half;
		quaternion[1] = 0.5 * _sqrt;
		quaternion[2] = (matrix[6] + matrix[9]) * half;
		quaternion[3] = (matrix[2] - matrix[8]) * half;

		return quaternion;
	}
    _sqrt = sqrt(1.0 + matrix[10] - matrix[0] - matrix[5]);
	half = 0.5 / _sqrt;

	quaternion[0] = (matrix[2] + matrix[8]) * half;
	quaternion[1] = (matrix[6] + matrix[9]) * half;
	quaternion[2] = 0.5 * _sqrt;
	quaternion[3] = (matrix[4] - matrix[1]) * half;

	return quaternion;
}

function euler_from_quaternion(quaternion)
{
	// Euler
	var euler = [  ];

    // roll (x-axis rotation)
    var sinr_cosp = 2 * (quaternion[3] * quaternion[0] + quaternion[1] * quaternion[2]);
    var cosr_cosp = 1 - 2 * (quaternion[0] * quaternion[0] + quaternion[1] * quaternion[1]);
    euler[0] = arctan2(sinr_cosp, cosr_cosp);

    // pitch (y-axis rotation)
    var sinp = 2 * (quaternion[3] * quaternion[1] - quaternion[2] * quaternion[0]);
    if (abs(sinp) >= 1)
    {
        euler[1] = copysign(pi / 2, sinp);
    }
    else
    {
        euler[1] = arcsin(sinp);
    }

    // yaw (z-axis rotation)
    var siny_cosp = 2 * (quaternion[3] * quaternion[2] + quaternion[0] * quaternion[1]);
    var cosy_cosp = 1 - 2 * (quaternion[1] * quaternion[1] + quaternion[2] * quaternion[2]);
    euler[2] = arctan2(siny_cosp, cosy_cosp);

    return euler;
}

function copysign(x,y) {				//Returns x with magnitude of y
	if(y<0 and x>0)or(y>0 and x<0){return(x*-1)}else{return(x)}
}

/// NuMtxPreScaleVU0(matrix, scaling_factors)
/// matrix: The flat 1D array representing a 4x4 transformation matrix
/// scaling_factors: An array with scaling factors for X, Y, and Z

function matrix_prescale(matrix, scaling_factors)
{
    // Extract scaling factors for easier reference
    var scaleX = scaling_factors[0];
    var scaleY = scaling_factors[1];
    var scaleZ = scaling_factors[2];
    
    // Pre-scale the matrix rows (this multiplies each row by the corresponding scale factor)
    
    // Scale the first row (matrix[0] to matrix[3]) - These are the elements matrix[0..3]
    matrix[0] *= scaleX;   // matrix[0, 0]
    matrix[1] *= scaleY;   // matrix[0, 1]
    matrix[2] *= scaleZ;   // matrix[0, 2]
    
    // Scale the second row (matrix[4] to matrix[7]) - These are the elements matrix[4..7]
    matrix[4] *= scaleX;   // matrix[1, 0]
    matrix[5] *= scaleY;   // matrix[1, 1]
    matrix[6] *= scaleZ;   // matrix[1, 2]
    
    // Scale the third row (matrix[8] to matrix[11]) - These are the elements matrix[8..11]
    matrix[8] *= scaleX;   // matrix[2, 0]
    matrix[9] *= scaleY;   // matrix[2, 1]
    matrix[10] *= scaleZ;  // matrix[2, 2]
    
    // The fourth row (matrix[12] to matrix[15]) typically contains translation values
    // These should *not* be scaled in most cases, but you can scale them if needed
    // matrix[12] *= scaleX; // Uncomment if you want to scale the translation as well
    // matrix[13] *= scaleY; // Uncomment if you want to scale the translation as well
    // matrix[14] *= scaleZ; // Uncomment if you want to scale the translation as well
    
    return matrix;
}

function matrix_translate(matrix, translation)
{
	matrix[12] += translation[0];
	matrix[13] += translation[1];
	matrix[14] += translation[2];
	
	return matrix;
}