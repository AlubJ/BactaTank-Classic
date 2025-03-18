/*
	BactaTankArmature
	-------------------------------------------------------------------------
	Script:			BactaTankArmature
	Version:		v1.00
	Created:		04/02/2025 by Alun Jones
	Description:	Armature Loader and Container
	-------------------------------------------------------------------------
	History:
	 - Created 04/02/2025 by Alun Jones
	
	To Do:
*/

function BactaTankArmature() constructor
{
	// Bones
	bones = [  ];
	
	// Other
	offset = 0;
	
	#region Parse / Inject
	
	static parse = function(buffer, _model, boneCount)
	{
		// Bone Names and Identity Matrix
		for (var i = 0; i < boneCount; i++)
		{
			// Bone
			var bone = new BactaTankBone();
			
			// Offset
			bone.offset = buffer_tell(buffer) - _model.nu20Offset;
			
			// Bone Matrix
			bone.identityMatrix = [];
			repeat(16) array_push(bone.identityMatrix, buffer_read(buffer, buffer_f32));
			
			// Bone Name
			buffer_seek(buffer, buffer_seek_relative, 0x0C);
			bone.name = buffer_peek(buffer, buffer_tell(buffer) + buffer_read(buffer, buffer_s32), buffer_string);
			
			// Bone Parent
			bone.parent = buffer_read(buffer, buffer_s8);
			buffer_seek(buffer, buffer_seek_relative, 0x0f);
			
			// Bone Struct
			self.bones[i] = bone;
		}
		
		//show_debug_message(buffer_tell(buffer));
		
		// Bind Pose
		for (var i = 0; i < boneCount; i++)
		{
			// Offset
			var offset = buffer_tell(buffer);
			self.bones[i].bindOffset = buffer_tell(buffer) - _model.nu20Offset;
			
			// Bone Matrix
			self.bones[i].bindMatrix = [];
			repeat(16) array_push(self.bones[i].bindMatrix, buffer_read(buffer, buffer_f32));
			
			//if (i == 0) self.bones[i].bindMatrix[13] += -0.05359427279;
			//if (i == 1) self.bones[i].bindMatrix[13] += 0.02972133196;
			//if (i == 3) self.bones[i].bindMatrix[13] += 0.02013380552;
			//if (i == 7) self.bones[i].bindMatrix[13] += 0.02013380552;
			//if (i == 10) self.bones[i].bindMatrix[13] += -0.02972133196;
			
			// Bone Struct
			self.bones[i].matrix = self.bones[i].bindMatrix;
			if (self.bones[i].parent != -1) self.bones[i].matrix = matrix_multiply(self.bones[i].bindMatrix, self.bones[self.bones[i].parent].matrix);
		}
		
		// Inverse Bind Pose
		for (var i = 0; i < boneCount; i++)
		{
			// Offset
			var offset = buffer_tell(buffer);
			self.bones[i].inverseBindOffset = buffer_tell(buffer) - _model.nu20Offset;
			
			// Bone Matrix
			self.bones[i].inverseBindMatrix = [];
			repeat(16) array_push(self.bones[i].inverseBindMatrix, buffer_read(buffer, buffer_f32));
			
			// Log
			var offset = self.bones[i].offset + _model.nu20Offset;
			ConsoleLog($"Bone {i}", CONSOLE_MODEL_LOADER_DEBUG, offset);
			ConsoleLog($"    Identity Matrix:      {self.bones[i].identityMatrix}", CONSOLE_MODEL_LOADER_DEBUG, offset);
			ConsoleLog($"    Name:                 \"{self.bones[i].name}\"", CONSOLE_MODEL_LOADER_DEBUG, offset + 0x4C);
			ConsoleLog($"    Parent:               {self.bones[i].parent}", CONSOLE_MODEL_LOADER_DEBUG, offset + 0x50);
			var offset = self.bones[i].bindOffset + _model.nu20Offset;
			ConsoleLog($"    Bind Matrix:          {bone.bindMatrix}", CONSOLE_MODEL_LOADER_DEBUG, offset);
			var offset = self.bones[i].inverseBindOffset + _model.nu20Offset;
			ConsoleLog($"    Inverse Bind Matrix:  {bone.inverseBindMatrix}", CONSOLE_MODEL_LOADER_DEBUG, offset);
		}
	}
	
	static inject = function(buffer)
	{
		for (var i = 0; i < array_length(bones); i++)
		{
			var offset = bones[i].bindOffset;
			for (var j = 0; j < 16; j++)
			{
				buffer_poke(buffer, offset, buffer_f32, bones[i].bindMatrix[j]);
				offset += 4;
			}
		}
		
		for (var i = 0; i < array_length(bones); i++)
		{
			var offset = bones[i].inverseBindOffset;
			var inverse = matrix_inverse(bones[i].matrix);
			for (var j = 0; j < 16; j++)
			{
				buffer_poke(buffer, offset, buffer_f32, inverse[j]);
				offset += 4;
			}
		}
	}
	
	#endregion
	
	#region Serialize / Deserialize
	
	static serialize = function(buffer)
	{
		// Write Bones
		buffer_write(buffer, buffer_string, "Bones");
		
		// Bone Count
		buffer_write(buffer, buffer_s32, array_length(bones));
		
		// Write All Bones
		for (var i = 0; i < array_length(bones); i++)
		{
			// Write Bone Name
			buffer_write(buffer, buffer_string, bones[i].name);
			
			// Write Bone Parent
			buffer_write(buffer, buffer_s32, bones[i].parent);
			
			// Write Bone Matrix
			for (var m = 0; m < 16; m++) buffer_write(buffer, buffer_f32, bones[i].matrix[m]);
		}
	}
	
	#endregion
	
	#region Export
	
	static export = function(filepath)
	{
		// Create buffer
		var buffer = buffer_create(1, buffer_grow, 1);
		
		// Header
		buffer_write(buffer, buffer_string, "BactaTankArmature");
		buffer_write(buffer, buffer_string, "PCGHG");
		buffer_write(buffer, buffer_f32, 0.4);
		
		// Serialize
		serialize(buffer);
		
		// Save Buffer
		buffer_save(buffer, filepath);
		
		// Delete Buffer
		buffer_delete(buffer);
	}
	
	#endregion
}

function BactaTankBone() constructor
{
	// Meta
	name = "Bone";
	parent = -1;
	
	// From Model
	identityMatrix = matrix_build_identity();
	bindMatrix = matrix_build_identity();
	inverseBindMatrix = matrix_build_identity();
	
	// Other
	matrix = matrix_build_identity();
	matrixLocal = matrix_build_identity();
	
	// Offsets
	offset = 0;
	bindOffset = 0;
	inverseBindOffset = 0;
}