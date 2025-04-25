# UV Viewer
BactaTank Classic now offers a UV viewer. It lets you view a models UVs. This is extremely helpful for aligning textures when making a custom character.

## Panning and Zooming
To pan the UV viewer around, use `Right Mouse`, and to zoom in and out, use `Middle Mouse Scroll`. You can also use `Middle Mouse` to control the zooming.

## General Options
- ![Reload Button](https://i.imgur.com/pIoKp7B.png) - This will reset the pan and zoom, incase you lose the UVs.
- ![Save Button](https://i.imgur.com/4unEPH8.png) - This lets you export the UV map to a `*.png` file, which you can then use in your image editor.
- ![Grid Button](https://i.imgur.com/zd2WKVX.png) - This button will toggle viewing the grid (the grid is not exported when saving the UV map).

## UV Offset
A lot of the time, default game models have their UVs offset upwards. BactaTank Classic will, by default, offset all UVs downwards by one unit. You can change the offset where necessary. Only UVs that are in the grid can be exported to a `*.png` so you will need to make sure that the UVs are aligned correctly. Try and only offset the UVs by one unit if you need to offset them.

## Export and Preview Size
This value will define the export and preview size of the UV map. UVs are normalized in UV space (0 - 1) and not texture space. If a texture map is not 1:1 then the UVs will look stretched or squashed. Changing the texture preview will automatically resize the export and preview size.

## UV Map
You can select which UV map / set is used when viewing UVs. The game can use multiple UV maps and does for certain characters.

## Preview Mode
You can select what UV mode you want to preview.

### Meshes
Viewing by meshes lets you select which meshes you want to be visible in the UV viewer. All are enabled by default.

### Texture
Viewing by texture will show all meshes that have that texture assigned to them. Changing texture will also change the preview texture.

### Material
Viewing by material will show all meshes that have that material assigned to them.

### Layer
Viewing by layer will let you see all the meshes that are assigned to that layer.

### Next
- [Preferences Overview](preferences.md)