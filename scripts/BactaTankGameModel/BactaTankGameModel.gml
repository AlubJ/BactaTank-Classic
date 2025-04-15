/*
	BactaTankGameModel
	-------------------------------------------------------------------------
	Script:			BactaTankGameModel
	Version:		v1.00
	Created:		06/02/2025 by Alun Jones
	Description:	Game Model Loader and Container
	-------------------------------------------------------------------------
	History:
	 - Created 06/02/2025 by Alun Jones
	
	To Do:
	 - Remove the indexing, use "mesh links" instead, IDing with their command list index.
*/

function BactaTankGameModel() constructor
{
	// Variables
	meshes = [  ];
	
	// Other
	offset = 0;
	
	#region Parse / Inject
	
	static parse = function(buffer, _model)
	{
		// Get Offset
		offset = buffer_tell(buffer) - _model.nu20Offset;
		
		// Mesh Count
		var meshCount = buffer_read(buffer, buffer_s32);
		
		// Materials are read in reverse order, so start at the meshcount then decrement
		var readMaterial = meshCount;
		
		// Materials Pointer
		var materialOffset = buffer_tell(buffer) + buffer_read(buffer, buffer_s32);
		
		// Mesh ID Pointer
		var meshIDsOffset = buffer_tell(buffer) + buffer_read(buffer, buffer_s32);
		
		// Meshes Loop
		for (var i = 0; i < meshCount; i++)
		{
			// Material Offset
			var meshMaterialOffset = (materialOffset + (readMaterial * 4) - 4) - _model.nu20Offset;
			
			// Material Index
			var meshMaterial = buffer_peek(buffer, materialOffset + (readMaterial * 4) - 4, buffer_s32);
			
			// Mesh ID Offset
			var meshIDOffset = (meshIDsOffset + (readMaterial * 4) - 4) - _model.nu20Offset;
			
			// Material Index
			var meshID = buffer_peek(buffer, meshIDsOffset + (readMaterial * 4) - 4, buffer_s32);
			
			// Mesh
			meshes[i] = {
				mesh: noone,
				material: meshMaterial,
				meshID: meshID,
				materialOffset: meshMaterialOffset,
				idOffset: meshIDOffset,
			}
		}
	}
	
	static parseMesh = function(buffer, _model)
	{
		// Loop Over Existing Meshes
		for (var i = 0; i < array_length(meshes); i++)
		{
			// Mesh Start Index
			var meshStartIndex = buffer_read(buffer, buffer_u16);
			var meshIndex = meshStartIndex + i;
			
			// Check if we have a valid / existing mesh
			if (meshIndex < array_length(_model.meshes))
			{
				// Apply Mesh Start Index + I
				meshes[i].mesh = meshIndex;
				
				// Apply Material
				_model.meshes[meshStartIndex + i].material = meshes[i].material;
			}
		}
	}
	
	#endregion
	
	#region Serialize / Deserialize
	
	
	
	#endregion
}