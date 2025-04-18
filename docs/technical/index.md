# BactaTank Classic Technical Documentation

## How Does it Work?
Good question. BactaTank Classic is a very complex box of things. It deals with a model format which is not good at all. `*_PC.GHG` files like to do this thing that I call "pointer hopping". The data in the file is not read sequentially, instead it gets read by jumping around the file. This is, in my opinion, a really bad way of making a model format.

BactaTank Classic doesn't read the entire model file, because a lot of the file format is still unknown. Instead it reads the bits that are important and ignores the rest.

The `*_PC.GHG` format has a header and a data section. The data (`Pre/Post NU20`) section is extremely simple to understand and the header (`NU20`) is more complex.

## Data (Pre/Post NU20)
Depending on the game, the data section is stored either before or after the `NU20` section of the file. The `Pre/Post NU20` is where the texture data and the vertex and index buffers are located. Vertex and index buffers being used to construct the mesh data. These are stored what are essentially big lists. The way the data is stored differs between `Pre NU20` and `Post NU20` versions of the file.

## Header (NU20)
The head of the file is where things get complicated. The `NU20` contains all other elements of the model other than the texture data and the vertex and index buffers. Things like the models armature, materials, layers and locators are stored here. The `NU20` is where the file does a whole bunch of pointer hopping. If the game wants to load the first mesh inside of the model, it first needs to read the header of the `NU20` to get the pointer to the `GSNH` (Game Scene Header), to then get the pointer of the first mesh, in which it can read the data associated with it. This is the reason why adding (`NU20` expansion) and removing information is difficult, because the file isn't fully known.

To add on-top of the mess that is pointer hopping, the file also contains an entire block of pointers, that lead to all the pointers inside of the file! Why TtGames... Why?

## What Does BactaTank Classic Do?
BactaTank Classic only reads the data it needs from the `Pre/Post NU20` and the `NU20`. It will discard the entire `Pre/Post NU20` and keep the `NU20` in tact for saving the model. The `Pre/Post NU20` can be rebuilt without any issues.

`NU20` data will be injected back into it when saving, allowing for modification of existing values.

### Why can't more textures be added if they're stored outside of the NU20?
Good question! Although the textures are stored outside of the `NU20`, the texture metadata (even though it is not really used in TCS), *is* stored inside of the `NU20`, with all of that pointer hell included. LIJ1 and LB1 does use this data and does not store any extra metadata outside of the `NU20`.

### Vertex and Index Buffer Rebuilding
A fancy feature in BactaTank Classic, versus previous tools to replace meshes is that it will rebuild the bulk vertex buffers and index buffers. The game doesn't store a single meshes vertex buffer or index buffer by itself, instead it groups all vertex buffers by vertex stride and whether it has dynamic buffers or not into bulk vertex buffers. Previous tools would just add a new vertex buffer and index buffer into the file and leave all of the old ones there. Rebuilding gives the advantage of previous meshes not being stored in the file, which then leads to the file getting bloated with unused information. Dereferencing a mesh will also remove all the data and a dereferenced mesh will not be included inside of the file.

The original version of BactaTank Classic (v0.1) would also rebuild the bulk vertex and index buffers, however when building a meshes individual vertex buffer, BactaTank Classic would slide in the new vertex data along side any old vertex data, following the vertex format of the material that is assigned to it. This method did make things easier than before (as manually replacing a mesh or using an ancient tool called LSWMT would sometimes need a manual fix for the vertex format). BactaTank Classic will now rebuild an entire vertex buffer from a vertex format and the data is already has, using default values if no values are given when replacing a mesh. This has the advantage of never needing to manually edit the vertex format, and it just works. This also has the advantage of adding attributes to a vertex format, for example, adding a second set of UVs. This is currently unsupported as a material that doesn't already have a second set of UVs cannot use them.

### Texture Loading and Decoding
BactaTank Classic is made with GameMaker... Why? Because that was the tool and programming language I am most comfortable with. The main downside of using GameMaker is, it doesn't provide functions to load block compression textures to the GPU. This has forced me to decode the textures on the CPU into raw `RGBA32` textures. Block compression textures are optimised for GPU decoding so decoding on the CPU is very slow. I have requested features to be added into GameMaker to allow for using block compression textures. BactaTank Classic will cache textures so if that same texture is detected, it'll load the cached version instead.