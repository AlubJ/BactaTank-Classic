# Editing Materials
Materials are what controls how the meshes should look. These can be used to make the meshes look the way you want them to. The material editor also provides a preview of the material.

## Basic Editing
We will go over the basic editing of the material and all the options.

### Colour
- `Blend Colour` - This is the colour of the material if there is no texture set.

### Textures
- `Texture Index` - This is the index of the main texture that is applied to the material.
- `Normal Index` - This is the index of the normal map texture that is used for extra detailing.
- `Shine Index` - This is the index of the shine texture, which is used to give a fake shine for extra detail in-game.

### Specular & Reflection
- `Specular Exponent` - This defines how much specular light should be reflected off the mesh. The lower the value the more matte it looks and vice versa.
- `Reflection Power` - This defines how reflective a surface is. This is used in conjunction with a cubemap.

### Surface & Lighting
- `Disable Lighting Pass` - This disables lighting on the material.
- `Enable Shine Map` - This enables the shine map to be used.
- `Surface Type` - This sets the surface type to be used.
  - `Smooth` - This just uses the normals from the base mesh.
  - `NormalMap` - This applies a normal map to the normals to add extra detail.
- `Lighting` - This sets the lighting type to be used.
  - `Lambert` - The Lambert shading model is just lighting with no specular applied. This will make the material look matte.
  - `Phong` - The Phong shading model is basic specular lighting, this will make the material look more shiny.
  - `Anisotropic` - The Anisotropic shading model mimics how light reflects off a brushed metallic surface or hair.

## Advanced Editing
> [!NOTE]
> Advanced material editing needs to be enabled in the preferences before they can be accessed. This is recommended to advanced users only.

### Colour
- `Ambient Tint` - This will tint the ambient light (the darkest a material can be).
- `Specular Tint` - This will tint the specular highlighting.

### Textures
- `Specular Index` - This is the index of the specular texture, and is used to modify the specular exponent of the material.
- `Cubemap Index` - This is the index of the cubemap texture, and is used for reflections.

### Surface & Lighting
- `Environment Map` - This either enables or disables the cubemap from being used.

### Alpha Blending
- `Alpha Blend` - This sets the blend mode of the material.
  - `None` - No alpha blending is applied.
  - `Transparent` - This will blend the textures alpha to the rest of the model.
  - `TransparentIgnoreDest` - Additive blending.
  - `ReverseTransparent` - I actually don't know, but it's there.
  - `NoneFixedAlpha` - Same as `Transparent` but with a lower alpha test value.
- `Depth Test` - The depth testing that is used on the material.
  - `Normal` - Writes to the depth buffer.
  - `NoWrite` - Does not write to the depth buffer.
  - `AlwaysPass` - Writes to the top of the depth buffer.
  - `IgnoreDepth` - Ignore the depth buffer entirely.
- `Cullmode` - This will set the cullmode of the material.
  - `NoCulling` - No culling is applied.
  - `CullCounterClockwise` - Backface Culling.
  - `CullClockwise` - Frontface Culling.

### Texture Scrolling
- `Scroll Type` - The scroll type of the texture scrolling.
  - `None` - No texture scrolling.
  - `Linear` - Linear texture scrolling.
  - `Sine` - A sine wave texture scrolling (oscillating).
  - `Cosine` - A cosine wave texture scrolling (oscillating).
- `Scroll Speed` - The speed of the scrolling.
- `Trig Scale` - A multiplier applied to the sine and cosine waves.

> [!NOTE]
> Texture scrolling is only visible on materials that already have texture scrolling enabled.

### Vertex Format
The vertex format shows you which attributes are included in the vertices of the mesh. Knowing this information may be useful in certain scenarios like needing to know what meshes have Blend Indices and Weights.

- `Position` - The position of the vertex in 3D space.
- `Normal` - The normal vector of the vertex.
- `Tangent` - The tangent vector, used for normal mapping.
- `BiTangent` - The bitangent vector, used for normal mapping.
- `ColourSetx` - The colour of a vertex.
- `UVSetx` - The UVs/Texture Coordinates of a vertex.
- `BlendIndices` - The index of the node in the armature, used for skinning.
- `BlendWeights` - The weight/influence of the node for deformation, used for skinning.

### Assigned Meshes
Shows which meshes have this material assigned to them. Useful in certain scenarios.

## Exporting & Replacing Materials
You can export and replace a material to and from a `*.bmat` file to transfer material properties. To do this click ![Triple Dot Button](https://i.imgur.com/xhwAmwR.png) and then click the relevant option. `Ctrl+E` will export and `Ctrl+R` will replace. You can also drop a `*.bmat` file onto the program to replace it.

> [!NOTE]
> Texture Indices are not transferred over and will need to be set manually.

> [!NOTE]
> If you want a vertex format to be carried over, you will need to enable `Replace Vertex Format` in the properties.