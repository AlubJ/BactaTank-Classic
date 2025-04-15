# Editing Textures
Locators are used in-game to place thing that are not present inside of the model. This could range from weapons, to attachments even down to particle effects.

## Editing
You can edit the transformation of a locator just by editing a few values.
- `Locator Parent` - The bone index that the locator will be parented to.
- `Locator Translation` - The position of the locator.
- `Locator Rotation` - The rotation of the locator (these values may be subject to gimble lock).
- `Locator Scale` - The scale of the locator.

## Exporting & Replacing Locators
You can export and replace a locator to and from a `*.bloc` file to transfer locator properties. To do this click ![Triple Dot Button](https://i.imgur.com/xhwAmwR.png) and then click the relevant option. `Ctrl+E` will export and `Ctrl+R` will replace. You can also drop a `*.bloc` file onto the program to replace it.