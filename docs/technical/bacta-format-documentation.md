# BactaTank Classic Formats Specification
BactaTank Classic uses its own formats for performing operations like mesh replacements. These files are binary to reduce the file size on disk versus another markup or data format like YAML or JSON.

## BactaTank Classic Mesh (*.bmesh)
BactaTank Classic uses a bespoke mesh format for ease of use over other regular file formats, and for an easier time programming. It allows for extra features that are not present in regular file formats.

### Header
**Name**|**Description**|**Type**|**Example Value**
-----|-----|-----|-----
File Magic|The file magic of the file for validation|String|BactaTankMesh
Format|The game format|String|PCGHG
Version|The version of the file format|Float|0.4

### Bone Table
The bone table is used to match up the weights inside of the mesh itself to the name of the bone when importing into Blender.
**Name**|**Description**|**Type**|**Example Value**
-----|-----|-----|-----
Bones|The header of the section|String|Bones
Bone Count|The number of bones|Integer|24
Names[Bone Count]|An array of bone names|String[]|[Bone1, Bone2]

### Mesh
