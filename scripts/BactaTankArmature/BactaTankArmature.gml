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
	bonesLocal = [  ];
	
	// Other
	offset = 0;
	
	#region Parse / Inject
	
	static parse = function(buffer, _model, boneCount)
	{
		// Bone Names
		for (var i = 0; i < boneCount; i++)
		{
			// Bone
			var bone = new BactaTankBone();
			
			// Offset
			bone.offset = buffer_tell(buffer) - _model.nu20Offset;
			
			// Bone Matrix
			bone.matrixLocal = [];
			repeat(16) array_push(bone.matrixLocal, buffer_read(buffer, buffer_f32));
			
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
		
		// Bone Matrices
		for (var i = 0; i < boneCount; i++)
		{
			// Offset
			var offset = buffer_tell(buffer);
			
			// Bone Matrix
			self.bones[i].matrixLocal = [];
			repeat(16) array_push(self.bones[i].matrixLocal, buffer_read(buffer, buffer_f32));
			
			// Bone Struct
			self.bones[i].matrix = self.bones[i].matrixLocal;
			if (self.bones[i].parent != -1) self.bones[i].matrix = matrix_multiply(self.bones[i].matrixLocal, self.bones[self.bones[i].parent].matrix);
			
			// Log
			//ConsoleLog($"Bone {i}", CONSOLE_MODEL_LOADER_DEBUG, offset);
			//ConsoleLog($"	Name:   {self.bones[i].name}", CONSOLE_MODEL_LOADER_DEBUG, offset);
			//ConsoleLog($"	Parent: {self.bones[i].parent}", CONSOLE_MODEL_LOADER_DEBUG, offset);
			//ConsoleLog($"	Matrix: {boneMatrix}", CONSOLE_MODEL_LOADER_DEBUG, offset);
		}
	}
	
	#endregion
	
	#region Serialize / Deserialize
	
	
	
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
		
		// Save Buffer
		buffer_save(buffer, filepath);
		
		// Delete Buffer
		buffer_delete(buffer);
	}
	
	#endregion
}

function BactaTankBone() constructor
{
	name = "Bone";
	parent = -1;
	matrix = matrix_build_identity();
	matrixLocal = matrix_build_identity();
	offset = 0;
}