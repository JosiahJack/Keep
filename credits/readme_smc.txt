URL:
http://quakeone.com/forum/quake-mod-releases/finished-works/6241-small-mod-compilation
http://quakeone.com/forums/quake-mod-releases/finished-works/6076-small-mod-compilation.html


Hello, 

If you modify or use this "small mod compilation" in other releases, always include this readme.txt unedited in it.

This "small mod compilation" aka SMC is developed and runs best with the DarkPlaces Quake engine.
It can be used for Original Quake and ALL fan-made maps/episodes (which do not bring their own 'progs.dat').
There are also SMC versions for the official Mission Packs 1 and 2 available (please find their download link URL on top of this file).

Be sure to use a recent DarkPlaces build together with this mod. Some features will NOT work with older versions.
I recommend the DarkPlaces build from 2017 or newer, as they have an increased particle effect limit and all cvars are adjusted to it.
Other builds might bring issues.
Please follow this link to download the DarkPlaces engine:
http://icculus.org/twilight/darkplaces/
Go here to get the newest builds directly:
http://icculus.org/twilight/darkplaces/files/?C=M;O=D



Installation:
Simply put the .pk3 file into your ID1 folder. (or in a separate mod folder and use shortcut: -game [mod_folder_name] ).
Remove ALL previous versions (and files) of this mod !
Please use the included  smc_config.cfg  to customize all features to your personal liking (read more below !).


It is recommended that you use powerup models WITHOUT hardcoded (flagged) effects.
This "small mod compilation" uses custom effects by Jakub for all powerups !!
If you use models (Pentagram, Quad, ring, suit) with hardcoded effects, the visual might be different than intended.



!!!!!  ATTENTION  !!!!! :

1.) Version V5.00 (and newer) are no longer compatible with prior cvar settings.
    Please delete your old SMC - "autoexec.cfg" and "smc_config.cfg" file and use the new "smc_config.cfg" as the base for your personal settings.

2.) If you already have a "progs.dat", "effectinfo.txt" or a "particlefont.tga" in your ID1 or mod folder/subfolders or in any pk3 file,
    you must remove them first, because this mod uses custom gamecode and effects which are specially designed for the included "effectinfo.txt" 
    and "particlefont.tga" !!  
    
3.) There are many cvar´s available to adjust this "small mod compilation" according to your personal liking !!
    I included the config file  "smc_config.cfg". This file contains ALL SMC cvars with the default cvar values.  
    You should copy it to the same folder where you put the main SMC .pk3 file to very comfortable modify all features to match your personal likings with it.

4.) Since Darkplaces build 2013-03-01 ALL "gameplayfix"-cvars are disabled by default (!), which will lead to issues. Even in original Quake.
    So I had to enable some of them again... (see "smc_config.cfg" for details)

5.) There are 3 features which need a new key bind to be used:
    - instant melee attack        --> impulse 20
    - flashlight                  --> impulse 30
    - personal player teleporter  --> impulse 40
    Bind any key you want to these impulse commands to be able to use the feature in game. Press the key in game and it will work.
    Example for flashlight: add this line into your config.cfg  (if you want to use "f" as the key to enable/disable it):
    bind f "impulse 30"

6.) Some new features (custom armor + key icons for different map types/models as well as new HUD layouts) need a custom HUD "csprogs.dat" file. 
    The custom HUD is not necessary if you do not enable those features. They are therefore disabled by default.
    If you want to enable them, you have to put the included "csprogs.dat" HUD file into the same folder where you put your SMC mod.
    Find it in the separate "custom HUD" subfolder of this download. You will also find a Readme.txt with ALL details and files there.

7.) To be able to make full use of the Quad-shader-effect, which adds a Quake3-like blue glowing / moving light on your
    weapons, I included a sample weapon-set-pack (which is preconfigured for the Quad effect):
    " Weapon-Pack-Example-for-new-powerup-effect.pk3 "
    Please either use that weapon set (put the .pk3 into your SMC folder and delete all other external weapon models/skins), 
    or read the included readme.txt to learn more details about the preconditions to use your own weapon set together with 
    the Quad powerup effect.  If you do not want the Quad-shader-effect, you do not need to do anything and ignore point no.7  :)
    A detailed tutorial about how to modify other weapons or player models to support this effect can be found here:
    http://quakeone.com/forum/quake-mod-releases/finished-works/6241-small-mod-compilation/page151
    http://quakeone.com/forum/quake-mod-releases/finished-works/6241-small-mod-compilation?p=213852#post213852
    http://quakeone.com/forums/quake-mod-releases/finished-works/6076-small-mod-compilation-227.html#post148351

8.) You need enforcer and soldier (grunt) models with additional animation sequenzes for the run&shoot feature !
    I included them into this update (they are inside the "progs" folder). Be aware that other MD3 replacement models will not work.
    You can make fully use of SMC´s multiskin features with them !  They are based on Nehahra´s models.
    It is highly recommended to use them in combination with the SMC 'Starter Kit' v5.50 (I added some more skins into this Update for variation).
    I made the Quoth-Enforcer models independent to the regular Enforcers, so you can use dedicated skins for them if you like.


Have fun !!

If you have further questions, want to give feedback or request new features, please visit the thread/forum (link on top of this file).


Kind regards,
Seven

