## Editing the Text File
Now it's time to edit the character's text file. The text file contains specific traits of the character, like what abilities it has, animations it uses, character display name, icon, weapons, and more.

> [!NOTE]
> Certain keywords/tags typed into the character text file may not function between games. For example, lightsabers will NOT work in LB1.

Open your character's `*.TXT` file in any text editing app (I'll be using notepad++ for this).

![image](https://github.com/user-attachments/assets/b32463a1-d658-44df-8b9a-fe123568cca7)

### Tag overview
This will go over a few important tags in the character's text file.
- `icon="icon_*"` - Used to decide what icon the character will have in the roster. Icon files can be found in `~/STUFF/ICONS`.
- `name_id=*` - Used to determine what name is displayed for the character in-game. Name IDs can be found in `~/STUFF/TEXT/<LANG>.txt`, with `<LANG>` being the language name you want to edit.
- `layers_*=*` - Used to determine what layers of the character are shown at certain distances/criteria. Layer numbers can be found by viewing the character with BactaTank Classic.
  - `layers_special` - Always drawn.
  - `layers_high` - Drawn when the camera is close to the character.
  - `layers_medium` - Drawn when the camera is a medium distance from the character.
  - `layers_low` - Drawn when the camera is far from the player.
  - `layers_dead` - Drawn when the character "explodes" or dies.
