# Mesh Editing
Mesh editing allows for a lot of freedom when creating custom characters. You are able to do a huge amount of things from changing the hair mesh or even creating Mario from Mario 64.

## General Options & Information
- `Primitive Type` - You can set this to `None` to disable the rendering of the mesh or to `TriangleStrip` to enable the rendering. You can also use `Ctrl+W` to toggle it.
- `Vertex Stride` - How big each vertex is in bytes.
- `Vertex Count` - The number of vertices in the mesh.
- `Triangle Count` - The number of triangles in a mesh.
- `Material` - Changes the material a mesh uses by clicking the dropdown and selecting a new material.

> [!NOTE]
> Putting a skinned mesh on a none-skinned material or vice versa may produce erroneous results so take care when selecting a material.

## Exporting a Mesh
You can export a mesh by clicking ![Triple Dot Button](https://i.imgur.com/xhwAmwR.png) and then clicking `Export Mesh` and export it to a desired location. You can also use `Ctrl+E`.

## Exporting an Armature
When editing skinned meshes, you will need to export the armature of the model which is then imported into Blender. To do this use `Model >> Export Armature` or do `Ctrl+Shift+A` and export the `*.barm` out.

## Using Blender
I will not go over the basics of Blender in these docs, there are many other great resources out there. Before jumping into mesh editing ***PLEASE*** learn about the basics of Blender.

> [!NOTE]
> I will not be teaching you how to use Blender.

### Importing an Armature into Blender
To import a `*.barm` armature into Blender, go to `File >> Import >> BactaTank Classic v0.3 >> Armature (*.barm)`. This is required when editing meshes with skinning data.

### Importing a Mesh into Blender
To import a `*.bmesh` mesh into Blender, go to `File >> Import >> BactaTank Classic v0.3 >> Mesh (*.bmesh)`. If your mesh has skinning, you will need to import the armature before you import a mesh.

### Fixing Potential Normal Issues
Because of the discrepancies on how mesh data is stored for video games versus Blender, importing a mesh may have their normals look off. They will normally look off and be split based off their UV maps. You will have to fix this yourself using modifiers or manually selecting vertices and merging them together. This is an unfortunate side effect of video game modding.

### Static Mesh Editing and Replacements
For static meshes, the armature is not needed, and you can import the `*.bmesh` directly into Blender. You can either edit this mesh or replace it entirely. You just need to position the mesh accordingly.

### Skinned Mesh Editing and Replacements
For skinned meshes, the armature is required, as the mesh will automatically be parented to the armature when imported. When editing the skinning of a mesh, you can only have a max of seven vertex groups due to a limitation within TtGames' game engine at the time. There is also a limitation on three bone influences / weights per vertex, this means you need to take extra care when skinning new meshes or editing the skinning on existing meshes. The BactaTank Add-on will try its best to use the three most influential weights but often get it wrong and it produces erroneous results.

### Shape Key Editing
Shape Keys (also referred to as blend shapes or dynamic buffers) are what the game uses to do facial animations. The BactaTank Add-on supports these and can import and export them from Blender. This functionality allows you to edit existing face poses or create entirely new ones.

> [!NOTE]
> Due to the way the `*_PC.GHG` files work, it is not possible yet for BactaTank Classic to add new data into the header of the file, making extended face pose data not possible. Editing existing face poses will work just fine, but adding new ones or editing blank face poses may produce erroneous results. Adding vertices to existing faces may also lead to erroneous results as the vertex count will need to be either the same or lower as the original mesh.

### Exporting a Mesh
To export a mesh from Blender to be imported into BactaTank Classic, use `File >> Export >> BactaTank Classic v0.3 Mesh (*.bmesh)`. If the mesh is skinned, enable `Export Skinning` to export the skinning data. If the mesh has shape keys, enable `Export Shape Keys` to export the shape key data.

## Replacing a Mesh
To replace a mesh in BactaTank Classic, click ![Triple Dot Button](https://i.imgur.com/xhwAmwR.png) and then click `Replace Mesh` or use `Ctrl+R` and select the new mesh file. If all goes well your new mesh should be there! Any skinning data and shape key data exported from Blender should be present in the mesh now. You can also drop the `*.bmesh` file onto the program to replace.

> [!NOTE]
> `Rebuild Dynamic Buffers` needs to be enabled in the preferences to import the new shape keys.

## Mesh Swapping
It is possible to swap meshes from one model to another. This will transfer all data of a mesh from one model to another. As some models have a different number of bones, the linked bones may default to zero and you will need to manually set them.

## Bone Links
Each possible bone link, for a maximum of eight (technically seven due to issues), is editable, this is only here for correcting mistakes made when swapping meshes.

## Dereferencing a Mesh
If a mesh is not needed in your model, you can completely dereference the mesh to remove all the data associated with it. This is useful to cut down on file sizes. To do this click ![Triple Dot Button](https://i.imgur.com/xhwAmwR.png) and then click `Dereference Mesh` or use `Ctrl+D`. A dialog will open asking you to confirm as undoing this is not possible. However, you can then replace that mesh with a new mesh to bring it back to life.

## Removing Dynamic Buffers
If you don't need shape keys for a mesh, you can remove them entirely by clicking ![Triple Dot Button](https://i.imgur.com/xhwAmwR.png) and then clicking `Remove Dynamic Buffers`.

## Limitations
### Linked Bones / Vertex Groups
TtGames implemented an optimisation where they only send a maximum of 8 bone transformations into the shader at any given time, meaning that when a mesh is submitted, it can only be affected by 8 bones simultaneously. This is usually capped at 7 bones for all vanilla models.

Due to what I can only assume to be an oversight, a given vertex can only be influenced by 3 bones maximum, as opposed to 4 in most other games of the era. One byte of the Blend Indices and Blend Weights is unused. This presents an issue when skinning, where having too many bones influencing a single vertex will produce erroneous results.

### Vertex Count
The index buffer is defined with an array unsigned 16-bit integers, which reference vertices in the vertex buffer. Due to this value being an unsigned 16-bit integer, the maximum number of vertices a mesh can have is 65,565. It is impractical to have this many vertices in a mesh though. Just remember that this mesh is for a video game that came out in 2007, so try and optimise your meshes for a game of that era.