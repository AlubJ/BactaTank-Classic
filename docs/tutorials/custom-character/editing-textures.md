## Editing Textures
Once the character is open in BactaTank Classic, it should looks something like this (what you see will vary depending on the model used).

![image](https://github.com/user-attachments/assets/b213e9b5-9b60-4564-bf67-db0c615b0bd8)

On the left side of the window, there are multiple dropdown buttons labeled `Textures`, `Materials`, etc. Click `Textures`. It should look something like this (amount of textures vary from character to character).

![image](https://github.com/user-attachments/assets/aa3d2088-3a1b-4243-ae95-802953a3603e)

Click on one of the textures and find the one you want to edit. Clicking on a texture shows a preview on the right-hand side.

![image](https://github.com/user-attachments/assets/ff037065-1431-4522-976e-79df9816b893)

Export the texture using `CTRL+E` or by clicking ![Triple Dot Button](https://i.imgur.com/xhwAmwR.png) in the upper-right hand corner and clicking `Export Texture`. Save the texture in any place you'll remember later. Refer to [Editing Textures](../../editing/textures.md) for opening and exporting textures.

![image](https://github.com/user-attachments/assets/dc3fcf59-b58d-422c-857f-a19acf50c41e)

### Exporting UVs
By clicking the tab at the top that says "UV Viewer," you can view how your character's texture(s) is projected across a surface. You can save the current UV map as an image for reference by clicking ![Save Button](https://i.imgur.com/4unEPH8.png) and saving the file where you can remember.

![image](https://github.com/user-attachments/assets/6ebb0d16-b059-44f6-9e3f-ef3451f2dac1)

Once the texture file is saved, you can reimport it using `CTRL+R` or by clicking ![Triple Dot Button](https://i.imgur.com/xhwAmwR.png) in the upper-right hand corner and clicking `Replace Texture`. Then select the new texture file. You should see the new texture in place of the old one.

> [!NOTE]
> Some UVs may be shown below the actual texture. This is due to a way TCS UV maps were programmed. You can fix this by changing the `1.000`, or the Y offset, to `0` at the top of the UV viewer.

Save the model using `CTRL+S` or clicking `File >> Save Model`. You should save it over the model in your character's folder. If you make drastic changes, be sure to keep a backup incase anything goes wrong.

[Next | Editing Meshes](editing-meshes.md)
