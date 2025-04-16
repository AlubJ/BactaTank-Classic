# Preferences
BactaTank Classic offers a whole bunch of preferences that can be changed. Some preferences need to be changed to offer extended functionality but are only recommended to advanced users. This page will walk through each of the preferences.

## General Settings
### Show Tooltips
This will show tooltips on most elements when hovering over them. Useful for the first time you use BactaTank Classic.

### Display Values as Hex
This will display any numerical value in hexidecimal. Useful for editing the model inside of a hex editor.

### Advanced Material Settings
This will enable in the material editor panel. You can read about advanced material settings here.

### Replace Vertex Format
Enabling this will enable the replacment of a vertex format when replacing a material from a `*.bmat` file. You can read more about the vertex format here.

### Enable System Console
Enabling this will open a system console on the next launch. Most operations that BactaTank Classic performs will be outputted to the console. This is useful for advanced modders.

### Verbose Console Output
This enables a verbose console output. BactaTank Classic will output every value it reads with it's hexidecimal offset in the file to the console. Extremely useful for advanced modders.

### Always Export Model Version 2
Enabling this will export the model to version 2 of the `*_PC.GHG` format. This will convert characters that were made for LIJ1 and LB1 to TCS. Enabling this may also increase load times in LIJ1 and LB1.

### Allow Version 1 Model Loading
Model version 1 is the primary model version used in Transformers: The Game. Enabling this will allow you to load models from that game. This is extremely unstable but here because some models load. Saving a version 1 model will automatically convert it to a version 2 model, resulting in the model no longer working in Transformers: The Game.

### Lower Render Resolution
This will half the rendering resolution within the model viewer and editor panels. This may enhance performance on slower machines.

### Simplify Rendering
Enabling this will disable certain rendering effects in the shaders. This may enhance performance on slower machines.

### Enable MSAA
This will enable Multi-Sample Anti-Aliasing to smooth out the edges on models in the model viewer. This is a visual enhancement.

### Cache Textures
Enabling this will cache the textures to a temporary directory, making the texture faster to load the next time it is loaded from a model. You can find more information in the technical documentation.

### Display Viewer Debug Info
This will enable debug information at the bottom of the model viewer panel. Useful for only me really.

### Rebuild Dynamic Buffers
Face and hand animations are done using dynamic buffers (also referred to as shape keys or blend shapes). BactaTank Classic will, by default, not rebuild them. When editing/replacing any meshes with dynamic buffers, this needs to be enabled.

## Viewer Settings
### ____ Colour
You can modify the colours of certain things that are shown in the viewer panel. Have a play around.

### Randomise UV Map Colours
Enabling this will enable the colours used for each mesh to be randomised in the UV viewer. This is useful to differenciate each mesh shown in the UV viewer.

## Themes
BactaTank Classic comes with a bunch of default themes. Have a play around.

### Creating Your Own Theme
You can create your own theme if you would like to. Just click ![Directory Button](https://i.imgur.com/ETQntZM.png) to open the themes directory, and have a play around with each setting. BactaTank Classic uses ImGui for its UI, all keywords match ImGui style options.