![BactaTank Classic Backdrop](https://i.imgur.com/ffW2kKR.png)<br>
BactaTank Classic is a character creator and viewer for LEGO Star Wars: The Complete Saga, LEGO Indiana Jones: The Original Adventures and LEGO Batman: The Videogame. This program is designed to preview the models as accurately as possible to the games. If you like this tool, and are able to support me financially, I would greatly appreciate it if you could throw me a few bucks [here](https://ko-fi.com/Y8Y219SKRX).

<!---------------------------------[ Buttons ]---------------------------------->

<div align = center>

[![Badge License]][License]   [![Badge Support]][Support]   [![Badge Wiki]][Wiki]   [![Badge Discussions]][Discussions]

</div>

<!---------------------------------------------------------------------------->

[License]: LICENSE
[Support]: https://ko-fi.com/Y8Y219SKRX
[Wiki]: https://github.com/AlubJ/BactaTank-Classic/wiki
[Discussions]: https://github.com/AlubJ/BactaTank-Classic/discussions


<!---------------------------------[ Badges ]---------------------------------->

[Badge License]: https://img.shields.io/badge/License-MIT-blue
[Badge Support]: https://img.shields.io/badge/Support%20Me-Ko--Fi-red
[Badge Wiki]: https://img.shields.io/badge/Wiki-violet
[Badge Discussions]: https://img.shields.io/badge/Discussions-purple

<!---------------------------------[ Content ]---------------------------------->

## Compatible Games

This table outlines which games are compatable with BactaTank Classic. It includes "classic" era LEGO games developed by TtGames/Traveller's Tales, as well as some of their other games based on similar revisions of the engine.

| Game                                        | Can be loaded | Can be edited |
| ------------------------------------------- | ------------- | ------------- |
| LEGO Star Wars: The Videogame               |      ❌       |      ❌       |
| LEGO Star Wars II: The Original Trilogy     |      ❌       |      ❌       | 
| Bionicle Heroes                             |      ❌       |      ❌       | 
| LEGO Star Wars: The Complete Saga           |      ✅       |      ✅       |               
| LEGO Batman: The Videogame                  |      ✅       |      ✅       | 
| LEGO Indiana Jones: The Original Adventures |      ✅       |      ✅       | 
| Transformers: The Videogame                 |      ⚠️       |      ❌       | 
| The Chronicles of Narnia: Prince Caspian    |      ⚠️       |      ❌       |

> [!WARNING]
> Transformers and Narnia models can be loaded for viewing, however this functionality is extremely experimental and can result in crashing. These are only supported for viewing. (Transformers model versions need to be enabled for loading in the preferences).

## Getting Started
### Installation
Installing BactaTank Classic is as simple as extracting the contents of the zip file to its own folder, and running the executable file.

> [!NOTE]
> Windows Defender may attempt to block BactaTank Classic from running, you can just allow it to run. BactaTank Classic does not do anything malicious, and since it is now open source, you can look through the code yourself and build it if you are worried.

### Game Extraction
TtGames archive the game files into a proprietary format that uses a propreitary compression scheme. To unpack these game files [QuickBMS](https://aluigi.altervista.org/quickbms.htm) is needed with the [TtGames BMS script](https://aluigi.altervista.org/bms/ttgames.bms).

To unpack the game files, run QuickBMS, select the BMS script, then select all of the `*.DAT` files using multiselect, then extract to a unique location. Once extracted copy original contents of the game (without the `*.DAT` files) to the extracted contents of the game. Using [Steamless](https://github.com/atom0s/Steamless) you can get the original games to run outside of needing Steam. More info about extracting the games can be found [here](https://www.pcgamingwiki.com/wiki/Engine:Nu2#Extracting_game_files).

> [!NOTE]
> Only the PC versions of LEGO Star Wars The Complete Saga, LEGO Indiana Jones The Original Adventures and LEGO Batman The Videogame is supported by BactaTank Classic. It will not work on any other TtGames LEGO Game or console version.

### Recommended Tools
- [Paint.NET](https://getpaint.net/) - an image editor capable of exporting DirectDraw Surface (`*.dds`) textures. (Alternatives are [GIMP](https://www.gimp.org/) and Photoshop with the [nVidia Texture Tools plugin](https://developer.nvidia.com/texture-tools-exporter)).
- [Blender](https://www.blender.org/) - a free and open-source model editor. Blender is required when editing meshes since BactaTank Classic has a bespoke plugin made for it. Version 4.0+ is needed.

### Installing The Blender Add-on
Installing the Blender Add-on is required if you want to edit meshes within a model. To install, in Blender go to `Edit >> Preferences >> Add-ons`, hit the `Install` button and select `bactatank-blender-addon-v[version].zip`. After installing you can enable the plugin and the BactaTank features will now be present.

### Useful Resources
- [TtGames Modding Discord Server](https://discord.gg/ttgames-lego-modding-539431629718945793)

### Known Un-Loadable and Un-Editable Model Files
| Known TCS Un-Loadable Models | Known LB1 Un-Loadable Models |
| ---------------------------- | ---------------------------- |
| `ANAKINSPOD_GREEN_PC.GHG`    | `PHRHINO_PC.GHG`             |
| `ANAKINSPOD_PC.GHG`          | `RC_COPTER_PC.GHG`           |
| `BATTLEDROIDCOMP_PC.GHG`     |
| `GASGANOSPOD_PC.GHG`         |
| `GUNGANBALL_PC.GHG`          |
| `LIGHTSABRE_PC.GHG`          |
| `MINI_DROIDEKA_PC.GHG`       |
| `NEWANAKINSPOD_GREEN_PC.GHG` |
| `NEWANAKINSPOD_PC.GHG`       |
| `ROYALNABOOSTARSHIP_PC.GHG`  |
| `SEBULBASPOD_PC.GHG`         |

| Known LB1 Un-Editable Models |
| ---------------------------- |
| `CLAYFACE_PC.GHG`            |

> [!NOTE]
> `CLAYFACE_PC.GHG` loads just fine in BactaTank Classic but does not look right. Saving the model will cause it to break in-game.

> [!NOTE]
> The `*_LR_PC.GHG` equivalent have been left out of the table, however they are not loadable/editable either.

### Additional Notes
> [!NOTE]
> BactaTank Classic only supports loading `*_PC.GHG` files.

> [!NOTE]
> The supported games will be referred to as their abbreviated forms (TCS, LIJ1 and LB1 respectively).

## Contacting
If you have an issue and need to contact me personally, you can either message me on Discord: `@alub` or send me an email at `contact @ alub dot dev`. Any bug reports or feature requests can be filed here as a GitHub Issue.

## Gallery
| | |
|-|-|
| ![Anakin Screenshot](https://i.imgur.com/SChAQht.png) | ![C3PO Screenshot](https://i.imgur.com/Lc30pyi.png) |
| ![Indy Screenshot](https://i.imgur.com/EhfFaB4.png) | ![Batman Screenshot](https://i.imgur.com/iJswwea.png) |

## Legal Disclaimer & Usage Notice
This software is not affiliated, associated, authorized, endorsed by, or in any way officially connected with the LEGO Group, TT Games Studios, Lucasfilm Ltd., WarnerMedia, or any of their subsidiaries or affiliates. All trademarks and copyrights belong to their respective owners.

This tool is provided for educational and entertainment purposes only. It does not include or distribute any official game files. Users must use their own legally obtained copies of the game.

Do not share, upload, or distribute original game files, bulk asset extractions, or modified game packages containing significant portions of the game’s content. Doing so may violate copyright law and the terms of service of the original game publishers.

Use this tool responsibly and at your own risk.
