# Creating a Custom Character
After [installing BactaTank Classic](../index.md#installation), the obvious next step is to create a character.

> [!NOTE]
> Character editing and creation varies in difficulty, depending on your goal. This tutorial will cover the most basic of character creation, more complex characters may require looking into some of the other docs, unless already given a tutorial.

## Compatible Games
| Game                                        |     Status    |
| ------------------------------------------- | ------------- |
| LEGO Star Wars: The Complete Saga           |      ✅      |
| LEGO Batman: The Videogame                  |      ✅      |
| LEGO Indiana Jones: The Original Adventures |      ✅      |
| Transformers: The Videogame                 |      ❌      |
| The Chronicals of Narnia: Prince Caspian    |      ❌      |
> [!NOTE]
> BactaTank Classic can load Transformers and Narnia models, but they cannot be edited.

## Setting Up The Character Folder

> [!NOTE]
> This step can be skipped if you want your character to be in another character's folder (mainly used for characters sharing animations).

To start creating a character, you need to create your character's folder. The character's folder holds most of the character's files and data. To start, locate the `CHARS` folder in your game's root directory (the directory that shows up when clicking the game folder).

![image](https://github.com/user-attachments/assets/40abdce6-8fe0-4446-a6a5-a1fd638c57ef)

Then create a folder, naming it whatever you'd like (Preferrably the character's name in all caps, but you can also just make it something you can remember). This is where all the character's files will be.

![image](https://github.com/user-attachments/assets/fe7e2a4e-1b66-44b7-ad2e-a0a642d7287c)


## Finding a Base

Once the character's folder is setup, you'll need to find a character to copy as a starting point, or a base. Questions to consider when finding a base for a character are:
- Are there enough texture/mesh slots?
- Do they work with the animations I want?
- Do they have a face similar to that of the character I want?
- Do they have similar abilities to the character I want? (doesn't matter, makes txt setup easier though)

> [!NOTE]
> You may not always be able to find a good base easily, and that's okay. Some of the questions to consider can be a bit confusing for beginners. You can always ask the [TTGames Modding Discord Server](https://discord.gg/ttgames-lego-modding-539431629718945793).

Once you find a good character as a base, copy their `*_PC.GHG` and `*.TXT` files over (optionally copy `*_LR_PC.GHG` if you want to make a lo-res model). You can find character's files in their character folder. In this tutorial, I will be using "Riddler Goon" from LEGO Batman: The Videogame as a base, to make a new goon variant, Generic Goon (How creative).

![image](https://github.com/user-attachments/assets/4892cd91-b917-4104-a8d7-9cafcfc90590)

Next, paste their files in your character's folder and rename them to your character's name.

![image](https://github.com/user-attachments/assets/c7707e98-9053-4068-9069-d630edb467e2)

> [!NOTE]
> When renaming the `*_PC.GHG` or `*_LR_PC.GHG` file, keep the `_PC` or `_LR_PC` accordingly.

Once renamed, open the character's `*_PC.GHG` file in BactaTank Classic by using `CTRL+O` in BactaTank Classic, dragging and dropping onto the window, or using `Open With...` when right-clicking the file. Continue to the next section.

## Editing Textures
Once the character is open in BactaTank Classic, it should looks something like this (the will vary depending on the model used).

![image](https://github.com/user-attachments/assets/b213e9b5-9b60-4564-bf67-db0c615b0bd8)

On the left side of the window, there are multiple dropdown buttons labeled `Textures`, `Materials`, etc. Click `Textures`. It should look something like this (amount of textures vary from character to character).

![image](https://github.com/user-attachments/assets/aa3d2088-3a1b-4243-ae95-802953a3603e)

Click on one of the textures and find the one you want to edit. Clicking on a texture shows a preview on the right-hand side.

![image](https://github.com/user-attachments/assets/ff037065-1431-4522-976e-79df9816b893)

Export the texture using `CTRL+E` or by clicking ![Triple Dot Button](https://i.imgur.com/xhwAmwR.png) in the upper-right hand corner and clicking `Export Texture`. Save the texture in any place you'll remember later. Refer to [Editing Textures](../editing/textures.md) for opening and exporting textures.

Once the texture file is saved, you can reimport it using `CTRL+R` or by clicking ![Triple Dot Button](https://i.imgur.com/xhwAmwR.png) in the upper-right hand corner and clicking `Replace Texture`. Then select the new texture file. You should see the new texture in place of the old one.

![image](https://github.com/user-attachments/assets/dc3fcf59-b58d-422c-857f-a19acf50c41e)

Save the model using `CTRL+S` or clicking `File >> Save Model`. You should save it over the model in your character's folder. If you make drastic changes, be sure to keep a backup incase anything goes wrong.

> [!TODO]
> Move all images over to imgur or to be hosted at alub.dev