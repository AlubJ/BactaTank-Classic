# BactaTank Classic
BactaTank Classic is a character creator and viewer for LEGO Star Wars: The Complete Saga, LEGO Indiana Jones: The Original Adventures and LEGO Batman: The Videogame. This program is designed to preview the models as accurately as possible to the games. If you like this tool, and are able to support me financially, I would greatly appreciate it if you could throw me a few bucks [here](https://ko-fi.com/Y8Y219SKRX).

## Getting Started
### Installation
Installing BactaTank Classic is as simple as extracting the contents of the zip file to it's own folder, and running the executable file.

### Game Extraction
TtGames archive the game files into a proprietary format that uses a propreitary compression scheme. To unpack these game files [QuickBMS](https://aluigi.altervista.org/quickbms.htm) is needed with the [TtGames BMS script](https://aluigi.altervista.org/bms/ttgames.bms).

To unpack the game files, run QuickBMS, select the BMS script, then select all of the `*.DAT` files using multiselect, then extract to a unique location. Once extracted copy original contents of the game (without the `*.DAT` files) to the extracted contents of the game. Using [Steamless](https://github.com/atom0s/Steamless) you can get the original games to run outside of needing Steam. More info about extracting the games can be found [here](https://www.pcgamingwiki.com/wiki/Engine:Nu2#Extracting_game_files).

`NOTE:` Only the PC versions of LEGO Star Wars The Complete Saga, LEGO Indiana Jones The Original Adventures and LEGO Batman The Videogame is supported by BactaTank Classic. It will not work on any other TtGames LEGO Game or console version.

### Recommended Tools
- [Paint.NET](https://getpaint.net/) - an image editor capable of exporting DirectDraw Surface (`*.dds`) textures. (Alternatives are [GIMP](https://www.gimp.org/) and Photoshop with the [nVidia Texture Tools plugin](https://developer.nvidia.com/texture-tools-exporter)).
- [Blender](https://www.blender.org/) - a free and open source model editor. Blender is required when editing meshes since BactaTank Classic has a bespoke plugin made for it.

### Additional Notes
`NOTE:` BactaTank Classic only supports loading `*_PC.GHG` files.<br>
`NOTE:` The supported games will be referred to as their abbreviated forms (TCS, LIJ1 and LB1 respectively).

### Known Un-loadable Model Files
| Known TCS Un-loadable Models | Known LB1 Un-loadable Models |
| ---------------------------- | ---------------------------- |
| `ANAKINSPOD_GREEN_PC.GHG`    | `PHRHINO_PC.GHG`             |
| `ANAKINSPOD_PC.GHG`          | `RC_COPTER_PC.GHG`           |
| `BATTLEDROIDCOMP_PC.GHG`     |
| `GASGANOSPOD_PC.GHG`         |
| `GASGANO_PC.GHG`             |
| `GUNGANBALL_PC.GHG`          |
| `LIGHTSABRE_PC.GHG`          |
| `MINI_DROIDEKA_PC.GHG`       |
| `NEWANAKINSPOD_GREEN_PC.GHG` |
| `NEWANAKINSPOD_PC.GHG`       |
| `ROYALNABOOSTARSHIP_PC.GHG`  |
| `SEBULBASPOD_PC.GHG`         |

`NOTE:` The `*LR_PC.GHG` equivilants have been left out of the table, however they do not load either.