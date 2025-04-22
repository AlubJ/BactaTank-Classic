# Frequently Asked Questions

## BactaTank Classic

### Q: How do I make a material transparent? The old version had a toggle checkbox for it but now it's gone.
Firstly, enable `Advanced Material Settings` in the preferences. After that you should see a dropdown called `Alpha Blend` that you can change.

BactaTank Classic v0.3+ respects the games rendering instead of respecting general knowledge of what things are. Everything within BactaTank Classic is labelled how the game engine would label them, which results in options that were originally toggle-ables into dropdowns instead. A lot of render options are not inherently on or off, instead they're a value that gets mapped to a specific operation. For example, with the `Alpha Blend` options, `1` is `Transparent`, `2` is `TransparentIgnoreDest` and so on.

## Blender Add-on

### Q: I want to edit this mesh, but when I replace it with the modified version, the skinning is lost.
For Blender to retain the skinning data for a mesh, the source armature needs to be present for the mesh to bind with the armature. This happens automatically when an armature is present. Import the armature before you import any skinned meshes. When exporting be sure that `Export skinning` is enabled in the Blender export window.