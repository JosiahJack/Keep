//=============================================================================
// 
// MOD    : Quake 1.5
// Author : BloodShot
// Website: https://www.moddb.com/mods/quake-15
// Info   : Quake 1.5 Public Beta 1 (Darkplaces only), based on SMC 5.30
//
//=============================================================================

Info:

//=============================================================================

Quake 1.5 is firstly a weapons overhaul, the original weapon pack's goal was to redo 
the quake 1 weapons to give them more feedback. Changes in the mod version include things 
like shell ejection, seeing rockets slide into the tube, additional frames for nailguns and 
a spin up/down on the SNG like Q2's chaingun.

The mod is a gameplay mod and is forked from SMC 5.30 and includes it's own additions:

- new gore system

- revamped particles

- additional weapons and items (hipnotic proximity grenades, ogre chainsaw)

- AD and SMC monsters (SMC monsters have been updated to fit the classic Quake look)

- new models from arcane dimensions and my own creations

- level changes and extensions, new secret levels featuring breakables, ladders, and other features from AD

- brand new/revamped bossfights

- bot support based on frikbot X


This beta is for the single player portion of the game. It comes with support for Coop, DM and CTF but these are 
unfinished and are provided AS-IS. Several of the mod features have to be changed to properly support online play
as it is now you can most likely play them but anybody who does not have low ping connection to the host or who suffers
from a lot of packet loss will likely suffer from randomly dropping from online games.

//=============================================================================

Installation:

//=============================================================================

Darkplaces:

https://icculus.org/twilight/darkplaces/files/

The recommended DarkPlaces build is the August 2018 build - it works on other DP builds but it is most stable and tested on this one

If you do not have DP, extract the build from the folder within this archive to the root Quake folder



Mod:

To install Quake 1.5 simply extract the archive directly into your Quake folder, then run the "Run Quake 1.5.bat" from the Quake directory

To manually load the mod, make a shortcut to Darkplaces.exe and in the target add " -game quake15"

Alternatively you can grab Simple Quake Launcher:

https://github.com/m-x-d/Simple-Quake-Launcher-2/releases

And just select quake15 from the mod list.

//=============================================================================

Tweaking:

//=============================================================================

Quake 1.5 is forked off of SMC so as a result a lot of things are stored in configs you can tweak

The most straightforward is the mod menu ingame - to access it simply press the 'HOME' key


You can do more editing of anything that isn't listen in the menu as well, open the q15_config.cfg

and you can change health and damage values, turn certain features on or off - please note not all

of SMC's features are fully in tact so enabling some of them might produce strange issues

//=============================================================================

Lowspec configuration:

//=============================================================================

For lower end machines if you are having trouble running darkplaces with all the effects or just in general
in addition to the custom menu accessed with the 'HOME' key ingame, you can check out the config presets 
folder inside the mod directory and overwrite the files in the quake15 folder.

Please note these are in no way perfect lowspec (Darkplaces is much more resource intensive than traditional 
quake ports)and the lower end settings are untested and may break certain shader effects

//=============================================================================

Contact:

//=============================================================================

For now the best method of contact is Moddb. You can leave feedback on the mod page or PM me with suggestions

//=============================================================================

Special Thanks:

//=============================================================================

Sock - AD features, higher quality AD monster models and miscellaneous

Spike - QuakeC programming help

Capnbubs - Player, Soldier and Dog models

Terrafusion Discord - mapping help

Facepunch Retro thread - feedback and ideas

Papasmurf, Xubs, Lyokanthrope, Doommarine, Danzadan, Shadesmaster - ideas, feedback, testing

Mynameislol and MacD11 - ideas, feedback, testing, sounds


If i missed you and you helped me out in some way or I used some of your work, let me know and I will add you

