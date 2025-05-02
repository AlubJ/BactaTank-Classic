/*
	BactaTankAnimation
	-------------------------------------------------------------------------
	Script:			BactaTankAnimation
	Version:		v1.00
	Created:		01/05/2025 by Alun Jones (Adapted from Clarence Oveur EasyAN3 Python Script)
	Description:	BactaTank Animation Constructor
	-------------------------------------------------------------------------
	History:
	 - Created 01/05/2025 by Alun Jones
	
	To Do:
	
	Info:
	 - Keyframe data is stored as Translation, Rotation and Scale per bone.
*/

function BactaTankAnimation(animation = noone, _armature = noone, nodeCount = 1) constructor
{
	version = animation.version;
	frameCount = animation.frameCount;
	originalFrameCount = animation.originalFrameCount;
	firstFrame = animation.firstFrame;
	metaData = animation.metaData;
	armature = _armature;
	animatedArmature = [];
	for (var i = 0; i < array_length(armature.bones); i++)
	{
		array_push(animatedArmature, variable_clone(armature.bones[i].bindMatrix));
	}
		
	bones = [];
	for (b = 0; b < animation.nodeCount; b++)
	{
		var curves = [];
		for (var c = 0; c < 9; c++)
		{
			var keyType = animation.skeletonMatrix[b*9+c];
				
			var staticValue = noone;
			var keyValues = noone;
			var isStatic = keyType >= 0x10;
				
			if (isStatic)
			{
				staticValue = animation.staticValues[keyType - 0x10] * animation.constantScale + animation.constantBase;
			}
			else
			{
				keyValues = animation.getKeyData_c(animation.getMovingNumber(b, c));
			}
				
			var curve = new BactaTankAnimationCurve(isStatic, staticValue, keyValues);
			array_push(curves, curve);
		}
			
		var bone = new BactaTankAnimationNode(animation.flags[b], curves);
		array_push(bones, bone);
	}
	
	// Animation Stuff
	currentFrame = 0;
	playbackSpeed = 60; // FPS
	
	static play = function()
	{
		// Get Keyframe Count
		var keyframeCount = getKeyframeCount();
		
		// Get Current Frame Data
		for (var b = 0; b < array_length(bones); b++)
		{
			var bone = bones[b];
			var bindMatrix = variable_clone(armature.bones[b].bindMatrix);
			var kfData = [];
			for (var c = 0; c < 9; c++)
			{
				if (bone.curves[c].isStatic) array_push(kfData, bone.curves[c].staticValue);
				else array_push(kfData, bone.curves[c].keyValues[floor(currentFrame)]);
			}
			
			// Fix Rotation and create based rotation matrix
			var rotationFixed = [radtodeg(kfData[3]), radtodeg(kfData[4]), radtodeg(kfData[5])];
			var baseRotationMatrix = matrix_build(0, 0, 0, rotationFixed[0], rotationFixed[1], rotationFixed[2], 1, 1, 1);
			
			// Unknown Flag
			if (bone.flag & BT_KEYFRAME_FLAGS.UNKNOWN)
			{
				baseRotationMatrix = matrix_multiply(baseRotationMatrix, bindMatrix);
			}
			
			// PreScale Matrix
			var preScaledMatrix = matrix_prescale(baseRotationMatrix, [kfData[6], kfData[7], kfData[8]]);
			
			// Translate Matrix
			var translatedMatrix = matrix_translate(preScaledMatrix, [kfData[0], kfData[1], kfData[2]]);
			translatedMatrix[2] = -translatedMatrix[2];
			translatedMatrix[6] = -translatedMatrix[6];
			translatedMatrix[8] = -translatedMatrix[8];
			translatedMatrix[9] = -translatedMatrix[9];
			translatedMatrix[11] = -translatedMatrix[11];
			translatedMatrix[14] = -translatedMatrix[14];
			
			// Create Matrices
			var transformationMatrix = matrix_build(kfData[0], kfData[1], kfData[2], radtodeg(kfData[3]), radtodeg(kfData[4]), radtodeg(kfData[5]), kfData[6], kfData[7], kfData[8]);
			
			animatedArmature[b] = variable_clone(armature.bones[b].bindMatrix);
			animatedArmature[b] = matrix_multiply(animatedArmature[b], translatedMatrix);
			if (armature.bones[b].parent != -1) animatedArmature[b] = matrix_multiply(animatedArmature[b], animatedArmature[armature.bones[b].parent]);
			armature.bones[b].matrix = animatedArmature[b];
			//show_debug_message(armature.bones[b].matrix);
		}
		
		// Increment Current Frame
		currentFrame += 0.1;
		if (currentFrame >= keyframeCount) currentFrame = 0;
	}
	
	static debugData = function(_bone, keyframe)
	{
		// Get Keyframe Count
		var keyframeCount = getKeyframeCount();
		
		// Get Current Frame Data
		var bone = bones[_bone];
		var kfData = [];
		for (var c = 0; c < 9; c++)
		{
			if (bone.curves[c].isStatic) array_push(kfData, bone.curves[c].staticValue);
			else array_push(kfData, bone.curves[c].keyValues[floor(keyframe)]);
		}
		
		show_debug_message(kfData);
	}
	
	static getMovingCount = function()
	{
		var count = 0;
		
		for (var b = 0; b < array_length(bones); b++)
		{
			var bone = bones[b];
			for (var c = 0; c < array_length(bone.curves); c++)
			{
				if (!bone.curves[c].isStatic) count++;
			}
		}
		
		return count;
	}
	
	static getKeyframeCount = function()
	{
		var count = 0;
		
		for (var b = 0; b < array_length(bones); b++)
		{
            var bone = bones[b];
			for (var c = 0; c < array_length(bone.curves); c++)
			{
                var curve = self.bones[b].curves[c];
                if (!curve.isStatic)
				{
                    if(count == 0)
					{
                        count = array_length(curve.keyValues)
					}
				}
			}
		}

        return count;
	}
	
	static toNoesis = function()
	{
		var out = [];
		var keyframeCount = getKeyframeCount();
		
		for (var b = 0; b < array_length(bones); b++)
		{
			var curves = [];
			for (var c = 0; c < array_length(bones[b].curves); c++)
			{
                var curve = self.bones[b].curves[c];
				var frames = [];
                if (curve.isStatic)
				{
                    frames = array_create(keyframeCount, curve.staticValue);
				}
				else
				{
					frames = curve.keyValues;
				}
				array_push(curves, frames);
			}
			array_push(out, curves);
		}
		
		return out;
	}
}