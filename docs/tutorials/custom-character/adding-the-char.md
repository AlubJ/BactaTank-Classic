## Adding the Character In Game
Now it's time to make the character show up in game.

### Giving Them a Unique Name
Open `~/STUFF/TEXT/<LANG>.TXT`. This file contains most of the text handled in the game, including character names, prologue text, level titles, etc.

![image](https://github.com/user-attachments/assets/de09a48b-46d3-4317-b1fb-33c836053caf)

When you open it, it should look something like this, varying depending on the game. Each row has a number next to the text. This is the text ID, which is how the game is able to find text entries. Find a number (below 1000) that isn't used. Type the number and then your characters name, like this:

![image](https://github.com/user-attachments/assets/90890b25-a15c-4070-b901-0e5f015dbc2c)

Make sure to include quotes or the character name will not work.

Open your characters `*.TXT` file. Change the number next to `name_id=` to your new entry's id.

![image](https://github.com/user-attachments/assets/aeff8abd-b76f-4ed3-a7e4-7df25f37fd2d)

Open `~/CHARS/CHARS.TXT`. This file handles what characters are loaded into the game.

![image](https://github.com/user-attachments/assets/2fa9044b-d11d-4f91-8d79-af3de494f5d3)

Scroll to the bottom of the file and add your character to the file like this:

![image](https://github.com/user-attachments/assets/c7fc5af7-b10f-4e92-9c54-49ee31756d7e)

Now your character will be loaded in game, but still needs to be added to the character roster.

Open `~/CHARS/COLLECTION.TXT`. This file handles what characters are added to the in game roster.

![image](https://github.com/user-attachments/assets/448cbf47-9a80-4cbc-91bf-06d7ec2c57ca)

Scroll to the bottom and add your character to the file like this:

![image](https://github.com/user-attachments/assets/5819e7ac-2f9a-40ce-b91d-6a0fb5965218)

> [!NOTE]
> The order of `COLLECTION.TXT` determines the order of the character roster. You can move your character's collection entry to change its position in the roster.

Your character should now show up in game and be playable! Nice!

![20250426125755_1](https://github.com/user-attachments/assets/1360c34c-7626-4266-a3bc-dc42d6804cd6)

> [!NOTE]
> If your character shows up as a blank slot with a "?" as the name, you may have a file called `CHARSTXT.FPK` that you need to delete. You can find and delete it in `~/CHARS`.

## Conclusion
In this tutorial, you learned the basics of how to create and add a character to a classic LEGO game with BactaTank Classic. You learned how to find bases, edit textures, models, text files, and more. With this knowledge, you can create almost any character you can imagine.
