# Editing Textures
Textures are an essential part of 3D rendering. These allow you to apply images to the meshes. You can export and replace textures extremely easily within BactaTank Classic. Editing is done in an external program.

> [!NOTE]
> TtGames' LEGO games only support DirectDraw Surface (`*.DDS`) textures (also known as block compression textures). These are decompressed on the GPU.

## Exporting a Texture
You can export a texture by clicking ![Triple Dot Button](https://i.imgur.com/xhwAmwR.png) and then clicking `Export Texture` and export it to a desired location. You can now edit this texture in your editor of choice. You can also use `Ctrl+E`.

## Saving a Texture From an Image Editor
When saving a texture from an image editor, the settings need to be set correctly.

![Export DDS PS and PDN](https://i.imgur.com/ZOEffIj.png)<br>

### Paint.NET
To save as a DirectDraw Surface (`*.DDS`) in Paint.NET, `File >> Save As...` and change the save type to `DirectDraw Surface (DDS) (*.dds)`. When saving you will see an extra dialog pop up, this lets you set the DDS settings. The options that are useful to us are `Compression Method` (this is a dropdown), `Cube Map from crossed image` and `Generate Mip Maps`.

- `Compression Method` - The three known compression methods supported are `DXT1`/`BC1`, `DXT3`/`BC2` and `DXT5`/`BC3`.
  - `DXT1`/`BC1` - One bit of transparency, either fully transparent or fully opaque, useful for textures with no transparency, such as the main model texture. Opaque texels are always fully black.
  - `DXT3`/`BC2` - Four bits of transparency, not used in any default models. You may come across this if dealing with textures from Lego Star Wars I+II, but it should otherwise be avoided due to being the same size as the much higher-quality DXT5.
  - `DXT5`/`BC3` - Eight bits of transparency, this is useful for any textures that require transparency, such as face textures.
- `Cube Map from crossed image` - This will generate a cubemap from a crossed image. Cubemaps are used for reflections in-game. We will go over this later.
- `Generate Mip Maps` - This will generate lower resolution textures for use when the mesh is further away.

### Photoshop with nVidia Texture Tools
To save as a DirectDraw Surface (`*.DDS`) in Photoshop, `File >> Save As...` and change the save type to `DDS - NVIDIA Texture Tools Exporter (*.DDS;*.DDS)`. When saving you will see an extra dialog pop up, this lets you set the DDS settings. Like Paint.NET, the options that are useful to us are `Format` (this is a dropdown) and `Generate Mipmaps`.

- `Format` - The three known compression methods supported are `DXT1`/`BC1a`, `DXT3`/`BC2` and `DXT5`/`BC3`. (`DXTx` is not used in the Texture Tools, so look for the `BCx` instead).
  - `DXT1`/`BC1a` - One bit of transparency, either fully transparent or fully opaque, useful for textures with no transparency, such as the main model texture. Opaque texels are always fully black.
  - `DXT3`/`BC2` - Four bits of transparency, not used in any default models. You may come across this if dealing with textures from Lego Star Wars I+II, but it should otherwise be avoided due to being the same size as the much higher-quality DXT5.
  - `DXT5`/`BC3` - Eight bits of transparency, this is useful for any textures that require transparency, such as face textures.
- `Generate Mip Maps` - This will generate lower resolution textures for use when the mesh is further away.

### GIMP
To save as a DirectDraw Surface (`*.DDS`) in GIMP, `File >> Export As...` and replace the file extension with `.dds`. Then save the texture with the following settings:
- `Compression` - Different compression methods for DirectDraw Surface files include `BC1/DXT1`, `BC2/DXT3`, and `BC3/DXT5`.
  - `BC1/DXT1` - One bit of transparency, either fully transparent or fully opaque, useful for textures with no transparency, such as the main model texture. Opaque texels are always fully black.
  - `BC2/DXT3` - Four bits of transparency, not used in any default models. You may come across this if dealing with textures from Lego Star Wars I+II, but it should otherwise be avoided due to being the same size as the much higher-quality DXT5.
  - `BC3/DXT5` - Eight bits of transparency, this is useful for any textures that require transparency, such as face textures.
- `Save type` - Determines what part or how the texture is saved. Save types to know about are:
  - `Selected layer` - Exports the image, only showing the layer that is currently selected.
  - `All visible layers` - Exports the image, showing all layers of the image.
  - `As cube map` - Exports the image for use with cubemapped materials.
- `Mipmaps` - This will generate lower resolution textures for use when the mesh is further away if set to `Generate mipmaps`.

## Replacing a Texture
You can replace a texture by clicking ![Triple Dot Button](https://i.imgur.com/xhwAmwR.png) and then clicking `Replace Texture` and select the texture you want to use. You can also use `Ctrl+R` or drop the texture file onto the program.

## Normal Maps
Normal maps are used in-game to add extra detail to the meshes. The games swizzle the texture information around so typical normal maps won't work properly. You will need to swizzle the channels around to get the in-game corrected normal maps. To do this you can use GIMP or Photoshop to swap the original normal map `RGBA` to the in-game one `AGBR`. You can also use [this tool](https://cdn.discordapp.com/attachments/540477596123660288/1333300302442532986/GLtoTCSNM.zip?ex=67fe906b&is=67fd3eeb&hm=f313c02e5b3ac8f22cad908042f947fc807e38ad11b608388c5028c7b1a85457&) (TODO - non-Discord link) to swizzle and un-swizzle the maps as well. 

Why did TtGames do this? It's due to how DXT5 compresses images: without going into too much detail, the green and alpha channels of DXT5 are the highest quality, so swizzling the red into the alpha allows the normal map to much more accurately represent intended normals once compressed. (The blue channel, by comparision, is much less important.)

Additionally, the game uses OpenGL normal maps, even though it runs on DirectX. OpenGL maps have the green channel flipped compared to DirectX maps.

BactaTank Classic will detect if a normal map is DirectX or swizzled, so if you are creating a new normal map you can quickly replace it and see how it will look, before swizzling the channels.

## Limitations
### Texture Sizes
Textures must be a power of two, this is due to a limitation in render technology. A valid texture size would be `512x256` and an invalid texture size would be `135x423`. BactaTank Classic or the game may crash when not using a power of two textures.

The games also have a limit on how big a texture can be. `4096x4096` is the hard limit in both BactaTank Classic and the games. It is recommended you don't use a texture this large unless you need to, since this will impact loading times. You will realistically only need a texture as big as `1024x1024`.

### Cubemap Textures
Cubemaps are a special case in the `*_PC.GHG` model files. A single cubemap counts as 6 individual textures, as each face of a cubemap count as their own texture. At the moment, you cannot replace a none-cubemap texture with a cubemap. You can replace a cubemap texture with a new one though.

## Example Textures
Here are some examples of textures. Normal maps should always be exported with `DXT5`/`BC3` because the red and alpha channel are swapped around.
![Triple Dot Button](https://i.imgur.com/cBbqqsj.png)<br>
