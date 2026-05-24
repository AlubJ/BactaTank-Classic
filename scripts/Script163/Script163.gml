function tester(_x, _y, _z, _matrix)
{
	var _newMat = matrix_build(_x, _y, _z, 0, 0, 0, 1, 1, 1);
	matrix_multiply(_matrix, _newMat, _newMat);
	return _newMat;
}