/*
	BactaTankLayer
	-------------------------------------------------------------------------
	Script:			BactaTankLayer
	Version:		v1.00
	Created:		06/02/2025 by Alun Jones
	Description:	Layer Loader and Container
	-------------------------------------------------------------------------
	History:
	 - Created 06/02/2025 by Alun Jones
	
	To Do:
*/

function BactaTankLayer() constructor
{
	// Variables
	name = "";
	specialObjects = [  ];
	meshes = [  ];
	
	// Other
	offset = 0;
	
	#region Parse / Inject
	
	static parse = function(buffer, _model, _index, _currentMesh)
	{
		// Temp Offset
		var tempOffset = buffer_tell(buffer);
		offset = tempOffset - _model.nu20Offset
		
		// Log
		ConsoleLog($"Layer {_index}", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer));
			
		// Goto layer name
		buffer_seek(buffer, buffer_seek_relative, buffer_read(buffer, buffer_s32)-4);
		
		// Read Layer Name
		name = buffer_read(buffer, buffer_string);
		
		// If No Layer Name, Default To "TT[i]_None"
		if (name == "") name = "TT" + string(_index) + "_None";
			
		ConsoleLog($" Name: {name}", CONSOLE_MODEL_LOADER_DEBUG, offset);
		
		// Mesh Index
		var mesh = 0;
		
		// Static Special Object Section 1
		buffer_seek(buffer, buffer_seek_start, tempOffset + 4);
		var layerStatic1 = buffer_read(buffer, buffer_s32);
		if (layerStatic1 != 0)
		{
			// Goto Static Special Object Section 1
			buffer_seek(buffer, buffer_seek_relative, layerStatic1 - 4);
			
			// Debug
			ConsoleLog($"    Layer Static:", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer));
			
			// Bones
			for (var j = 0; j < array_length(_model.bones); j++)
			{
				// Get Special Object Pointer
				var specialObjectPointer = buffer_read(buffer, buffer_s32);
				if (specialObjectPointer != 0)
				{
					// Temp Bone Offset
					var tempBoneOffset = buffer_tell(buffer);
					
					// Goto Special Object Thing
					buffer_seek(buffer, buffer_seek_relative, specialObjectPointer - 4);
					
					// Special Object Offset
					var specialObjectOffset = buffer_tell(buffer) - _model.nu20Offset;
					
					// Skip Over Useless Information
					var gsnhPointer = buffer_read(buffer, buffer_s32);
					var unknown = buffer_read(buffer, buffer_s32);
					
					// Get Special Object Pointer
					var specialObjectPointer = buffer_read(buffer, buffer_s32) - 4;
					buffer_seek(buffer, buffer_seek_relative, specialObjectPointer);
					
					// Skip Over Redudant Data
					buffer_seek(buffer, buffer_seek_relative, 0xb0);
					
					// Goto Mesh Links
					buffer_seek(buffer, buffer_seek_relative, buffer_read(buffer, buffer_s32)-4); // layerMeshCount
					
					// Mesh Link Count
					var layerMeshCount = buffer_read(buffer, buffer_s32);
					
					// Mesh Materials
					buffer_seek(buffer, buffer_seek_relative, buffer_read(buffer, buffer_s32)-4); // materials
					
					var readMat = layerMeshCount;
					var readMatOffset = buffer_tell(buffer);
					for (var m = 0; m < layerMeshCount; m++)
					{
						var layerMaterialOffset = (readMatOffset + (readMat * 4) - 4) - _model.nu20Offset;
						var layerMaterial = buffer_peek(buffer, readMatOffset + (readMat * 4) - 4, buffer_s32);
						layerMaterial = layerMaterial != -1 ? layerMaterial : 0;
						
						// Apply Material to Mesh Directly
						if (_currentMesh < array_length(_model.meshes)) _model.meshes[_currentMesh].material = layerMaterial;
						
						readMat--;
						
						meshes[mesh] = {
							mesh: _currentMesh < array_length(_model.meshes) ? _currentMesh++ : noone,
							material: layerMaterial,
							matOffset: layerMaterialOffset,
							bone: j,
						}
						
						// Increase Mesh
						mesh++;
					}
					
					// Back To Bones
					buffer_seek(buffer, buffer_seek_start, tempBoneOffset);
				}
			}
		}
		
		// Skinned Special Object Section 1
		buffer_seek(buffer, buffer_seek_start, tempOffset + 8);
		var specialObjectPointer = buffer_read(buffer, buffer_s32);
		if (specialObjectPointer != 0)
		{
			// Goto Skinned Special Objects
			buffer_seek(buffer, buffer_seek_relative, specialObjectPointer-4);
			
			// Debug Output
			ConsoleLog($"    Layer Skinned:", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer));
			
			// Special Object Offset
			var specialObjectOffset = buffer_tell(buffer) - _model.nu20Offset;
			
			// Skip Over Useless Information
			var gsnhPointer = buffer_read(buffer, buffer_s32);
			var unknown = buffer_read(buffer, buffer_s32);
			
			// Get Special Object Pointer
			var specialObjectPointer = buffer_read(buffer, buffer_s32) - 4;
			buffer_seek(buffer, buffer_seek_relative, specialObjectPointer);
			
			// Skip Over Redudant Data
			buffer_seek(buffer, buffer_seek_relative, 0xb0);
			
			// Goto Mesh Links
			buffer_seek(buffer, buffer_seek_relative, buffer_read(buffer, buffer_s32)-4); // layerMeshCount
			
			// Mesh Link Count
			var layerMeshCount = buffer_read(buffer, buffer_s32);
			
			// Mesh Materials
			buffer_seek(buffer, buffer_seek_relative, buffer_read(buffer, buffer_s32)-4); // materials
			
			var readMat = layerMeshCount;
			var readMatOffset = buffer_tell(buffer);
			for (var m = 0; m < layerMeshCount; m++)
			{
				var layerMaterialOffset = (readMatOffset + (readMat * 4) - 4) - _model.nu20Offset;
				var layerMaterial = buffer_peek(buffer, readMatOffset + (readMat * 4) - 4, buffer_s32);
				layerMaterial = layerMaterial != -1 ? layerMaterial : 0;
				
				// Apply Material to Mesh Directly
				if (_currentMesh < array_length(_model.meshes)) _model.meshes[_currentMesh].material = layerMaterial;
				
				readMat--;
				
				meshes[mesh] = {
					mesh: _currentMesh < array_length(_model.meshes) ? _currentMesh++ : noone,
					material: layerMaterial,
					matOffset: layerMaterialOffset,
					bone: -1,
				}
				
				// Increase Mesh
				mesh++;
			}
		}
		
		// Static Special Object Section 2
		buffer_seek(buffer, buffer_seek_start, tempOffset + 12);
		var layerStatic2 = buffer_read(buffer, buffer_s32);
		if (layerStatic2 != 0)
		{
			// Goto Static Special Object Section 2
			buffer_seek(buffer, buffer_seek_relative, layerStatic2-4);
			
			// Debug
			ConsoleLog($"    Layer Static:", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer));
			
			// Bones
			for (var j = 0; j < array_length(_model.bones); j++)
			{
				// Get Special Object Pointer
				var specialObjectPointer = buffer_read(buffer, buffer_s32);
				if (specialObjectPointer != 0)
				{
					// Temp Bone Offset
					var tempBoneOffset = buffer_tell(buffer);
					
					// Goto Special Object Thing
					buffer_seek(buffer, buffer_seek_relative, specialObjectPointer - 4);
					
					// Special Object Offset
					var specialObjectOffset = buffer_tell(buffer) - _model.nu20Offset;
					
					// Skip Over Useless Information
					var gsnhPointer = buffer_read(buffer, buffer_s32);
					var unknown = buffer_read(buffer, buffer_s32);
					
					// Get Special Object Pointer
					var specialObjectPointer = buffer_read(buffer, buffer_s32) - 4;
					buffer_seek(buffer, buffer_seek_relative, specialObjectPointer);
					
					// Skip Over Redudant Data
					buffer_seek(buffer, buffer_seek_relative, 0xb0);
					
					// Goto Mesh Links
					buffer_seek(buffer, buffer_seek_relative, buffer_read(buffer, buffer_s32)-4); // layerMeshCount
					
					// Mesh Link Count
					var layerMeshCount = buffer_read(buffer, buffer_s32);
					
					// Mesh Materials
					buffer_seek(buffer, buffer_seek_relative, buffer_read(buffer, buffer_s32)-4); // materials
					
					var readMat = layerMeshCount;
					var readMatOffset = buffer_tell(buffer);
					for (var m = 0; m < layerMeshCount; m++)
					{
						var layerMaterialOffset = (readMatOffset + (readMat * 4) - 4) - _model.nu20Offset;
						var layerMaterial = buffer_peek(buffer, readMatOffset + (readMat * 4) - 4, buffer_s32);
						layerMaterial = layerMaterial != -1 ? layerMaterial : 0;
						
						// Apply Material to Mesh Directly
						if (_currentMesh < array_length(_model.meshes)) _model.meshes[_currentMesh].material = layerMaterial;
						
						readMat--;
						
						meshes[mesh] = {
							mesh: _currentMesh < array_length(_model.meshes) ? _currentMesh++ : noone,
							material: layerMaterial,
							matOffset: layerMaterialOffset,
							bone: j,
						}
						
						// Increase Mesh
						mesh++;
					}
					
					// Back To Bones
					buffer_seek(buffer, buffer_seek_start, tempBoneOffset);
				}
			}
		}
			
		// Skinned Special Object Section 2
		buffer_seek(buffer, buffer_seek_start, tempOffset + 16);
		var specialObjectPointer = buffer_read(buffer, buffer_s32);
		if (specialObjectPointer != 0)
		{
			// Goto Skinned Special Objects
			buffer_seek(buffer, buffer_seek_relative, specialObjectPointer - 4);
			
			// Debug Output
			ConsoleLog($"    Layer Skinned:", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer));
			
			// Special Object Offset
			var specialObjectOffset = buffer_tell(buffer) - _model.nu20Offset;
			
			// Skip Over Useless Information
			var gsnhPointer = buffer_read(buffer, buffer_s32);
			var unknown = buffer_read(buffer, buffer_s32);
			
			// Get Special Object Pointer
			var specialObjectPointer = buffer_read(buffer, buffer_s32) - 4;
			buffer_seek(buffer, buffer_seek_relative, specialObjectPointer);
			
			// Skip Over Redudant Data
			buffer_seek(buffer, buffer_seek_relative, 0xb0);
			
			// Goto Mesh Links
			buffer_seek(buffer, buffer_seek_relative, buffer_read(buffer, buffer_s32)-4); // layerMeshCount
			
			// Mesh Link Count
			var layerMeshCount = buffer_read(buffer, buffer_s32);
			
			// Mesh Materials
			buffer_seek(buffer, buffer_seek_relative, buffer_read(buffer, buffer_s32)-4); // materials
			
			var readMat = layerMeshCount;
			var readMatOffset = buffer_tell(buffer);
			for (var m = 0; m < layerMeshCount; m++)
			{
				var layerMaterialOffset = (readMatOffset + (readMat * 4) - 4) - _model.nu20Offset;
				var layerMaterial = buffer_peek(buffer, readMatOffset + (readMat * 4) - 4, buffer_s32);
				layerMaterial = layerMaterial != -1 ? layerMaterial : 0;
				
				// Apply Material to Mesh Directly
				if (_currentMesh < array_length(_model.meshes)) _model.meshes[_currentMesh].material = layerMaterial;
				
				readMat--;
				
				meshes[mesh] = {
					mesh: _currentMesh < array_length(_model.meshes) ? _currentMesh++ : noone,
					material: layerMaterial,
					matOffset: layerMaterialOffset,
					bone: -1,
				}
				
				// Increase Mesh
				mesh++;
			}
		}
		
		// Seek Forward To Next Layer
		buffer_seek(buffer, buffer_seek_start, tempOffset + 20);
	}
	
	static inject = function(buffer)
	{
		// Loop Through Layer Meshes
		for (var m = 0; m < array_length(meshes); m++)
		{
			buffer_poke(buffer, meshes[m].matOffset, buffer_s32, meshes[m].material);
		}
	}
	
	static parseOld = function(buffer, _model, _index)
	{
		// Temp Offset
		var tempOffset = buffer_tell(buffer);
		offset = tempOffset - _model.nu20Offset
		
		// Log
		//ConsoleLog($"Layer {i}", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer));
			
		// Goto layer name
		buffer_seek(buffer, buffer_seek_relative, buffer_read(buffer, buffer_s32)-4);
		
		// Read Layer Name
		name = buffer_read(buffer, buffer_string);
		
		// If No Layer Name, Default To "TT[i]_None"
		if (name == "") name = "TT" + string(_index) + "_None";
			
		//ConsoleLog($"	Name: {layerName}", CONSOLE_MODEL_LOADER_DEBUG, offset);
		
		// Static Special Object Section 1
		buffer_seek(buffer, buffer_seek_start, tempOffset + 4);
		var layerStatic1 = buffer_read(buffer, buffer_s32);
		if (layerStatic1 != 0)
		{
			// Goto Static Special Object Section 1
			buffer_seek(buffer, buffer_seek_relative, layerStatic1-4);
			
			// Debug
			//ConsoleLog($"		Layer Static:", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer));
			
			// Bones
			for (var j = 0; j < array_length(_model.bones); j++)
			{
				// Get Special Object Pointer
				var specialObjectPointer = buffer_read(buffer, buffer_s32);
				if (specialObjectPointer != 0)
				{
					// Temp Bone Offset
					var tempBoneOffset = buffer_tell(buffer);
					
					// Goto Special Object Thing
					buffer_seek(buffer, buffer_seek_relative, specialObjectPointer - 4);
					
					// Special Object Offset
					var specialObjectOffset = buffer_tell(buffer) - _model.nu20Offset;
					
					// Skip Over Useless Information
					var gsnhPointer = buffer_read(buffer, buffer_s32);
					var unknown = buffer_read(buffer, buffer_s32);
					
					// Get Special Object Pointer
					var specialObjectPointer = buffer_read(buffer, buffer_s32) - 4;
					
					// Get Special Object Index
					var specialObject = getSpecialObjectIndex((buffer_tell(buffer) + specialObjectPointer) - _model.nu20Offset, _model);
					
					// Set Special Object Things
					_model.specialObjects[specialObject].bone = j;
					
					// Add To Special Objects
					array_push(specialObjects, specialObject);
					
					// Back To Bones
					buffer_seek(buffer, buffer_seek_start, tempBoneOffset);
				}
			}
		}
		
		// Skinned Special Object Section 1
		buffer_seek(buffer, buffer_seek_start, tempOffset + 8);
		var specialObjectPointer = buffer_read(buffer, buffer_s32);
		if (specialObjectPointer != 0)
		{
			// Goto Skinned Special Objects
			buffer_seek(buffer, buffer_seek_relative, specialObjectPointer-4);
			
			// Debug Output
			//ConsoleLog($"		Layer Skinned:", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer));
			
			// Special Object Offset
			var specialObjectOffset = buffer_tell(buffer) - _model.nu20Offset;
			
			// Skip Over Useless Information
			var gsnhPointer = buffer_read(buffer, buffer_s32);
			var unknown = buffer_read(buffer, buffer_s32);
			
			// Get Special Object Pointer
			var specialObjectPointer = buffer_read(buffer, buffer_s32) - 4;
			
			// Get Special Object Index
			var specialObject = getSpecialObjectIndex((buffer_tell(buffer) + specialObjectPointer) - _model.nu20Offset, _model);
			
			// Set Special Object Things
			_model.specialObjects[specialObject].bone = -1;
			
			// Add To Special Objects
			array_push(specialObjects, specialObject);
		}
		
		// Static Special Object Section 2
		buffer_seek(buffer, buffer_seek_start, tempOffset + 12);
		var layerStatic2 = buffer_read(buffer, buffer_s32);
		if (layerStatic2 != 0)
		{
			// Goto Static Special Object Section 2
			buffer_seek(buffer, buffer_seek_relative, layerStatic2-4);
			
			// Debug
			//ConsoleLog($"		Layer Static:", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer));
			
			// Bones
			for (var j = 0; j < array_length(_model.bones); j++)
			{
				// Get Special Object Pointer
				var specialObjectPointer = buffer_read(buffer, buffer_s32);
				if (specialObjectPointer != 0)
				{
					// Temp Bone Offset
					var tempBoneOffset = buffer_tell(buffer);
					
					// Goto Special Object Thing
					buffer_seek(buffer, buffer_seek_relative, specialObjectPointer - 4);
					
					// Special Object Offset
					var specialObjectOffset = buffer_tell(buffer) - _model.nu20Offset;
					
					// Skip Over Useless Information
					var gsnhPointer = buffer_read(buffer, buffer_s32);
					var unknown = buffer_read(buffer, buffer_s32);
					
					// Get Special Object Pointer
					var specialObjectPointer = buffer_read(buffer, buffer_s32) - 4;
					
					// Get Special Object Index
					var specialObject = getSpecialObjectIndex((buffer_tell(buffer) + specialObjectPointer) - _model.nu20Offset, _model);
					
					// Set Special Object Things
					_model.specialObjects[specialObject].bone = j;
					
					// Add To Special Objects
					array_push(specialObjects, specialObject);
					
					// Back To Bones
					buffer_seek(buffer, buffer_seek_start, tempBoneOffset);
				}
			}
		}
			
		// Skinned Special Object Section 2
		buffer_seek(buffer, buffer_seek_start, tempOffset + 16);
		var specialObjectPointer = buffer_read(buffer, buffer_s32);
		if (specialObjectPointer != 0)
		{
			// Goto Skinned Special Objects
			buffer_seek(buffer, buffer_seek_relative, specialObjectPointer - 4);
			
			// Debug Output
			//ConsoleLog($"		Layer Skinned:", CONSOLE_MODEL_LOADER_DEBUG, buffer_tell(buffer));
			
			// Special Object Offset
			var specialObjectOffset = buffer_tell(buffer) - _model.nu20Offset;
			
			// Skip Over Useless Information
			var gsnhPointer = buffer_read(buffer, buffer_s32);
			var unknown = buffer_read(buffer, buffer_s32);
			
			// Get Special Object Pointer
			var specialObjectPointer = buffer_read(buffer, buffer_s32) - 4;
			
			// Get Special Object Index
			var specialObject = getSpecialObjectIndex((buffer_tell(buffer) + specialObjectPointer) - _model.nu20Offset, _model);
			
			// Set Special Object Things
			_model.specialObjects[specialObject].bone = -1;
			
			// Add To Special Objects
			array_push(specialObjects, specialObject);
		}
		
		// Seek Forward To Next Layer
		buffer_seek(buffer, buffer_seek_start, tempOffset + 20);
	}
	
	#endregion
	
	#region Helper
	
	static getSpecialObjectIndex = function(pointer, _model)
	{	
		// Find Model
		for (var i = 0; i < array_length(_model.specialObjects); i++)
		{
			if (_model.specialObjects[i].offset == pointer) return i;
		}
		
		// Return -1 just incase
		return -1;
	}
	
	#endregion
}