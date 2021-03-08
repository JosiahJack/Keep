
Enhanced Nehahra Engine
=======================

BACKGROUND

This Nehahra engine is a bug-fixed version of the released 2.54 source with many features added.
It has also most of the numerous fixes/features of the Enhanced GLQuake version
(http://user.tninet.se/~xir870k), please see its readme for details. The engine can be used for
both watching the "Seal of Nehahra" movie and for playing the actual game. It can also be used
for playing most other Q1 mods.

For all Nehahra material and more info, please visit http://www.planetquake.com/nehahra.

==================================================================================================
FEATURES

* Very large capacity and robustness; all known bsps are loadable and playable.
* Very high limits (e.g. edicts) and almost no engine choking (e.g. packet overflow).
* Fast loading of bsps.
* Low memory requirements, especially when loading many bsps in sequence.
* Low system requirements; most systems should be able to use the engine.
* Low CPU load.
* Enhanced brightness (gamma) handling.
* Enhanced texture quality.
* Enhanced sound quality; almost eliminated sound drop out or stuttering.
* Standard skybox and fog support.
* Support for external bsp/mdl/spr textures in three commonly used engine styles.
* Smooth model interpolation.
* Enhanced shadows.
* Enhanced console handling and warning/error messages.
* Many movie and gameplay issues fixed.
* Enhanced non-Nehahra support.
* Enhanced QC (progs) validation.
* Enhanced log file handling.
* DZipped demo support outside or inside pak file. 

==================================================================================================
NOTES

There is a difference in the gamma (brightness) handling in the older Nehahra 2.54/2.67 versions
and this version. If your graphics card supports hardware gamma handling, you can change gamma via
cvar gamma (or slider in options menu) in-game. This is the recommended mode.

If hardware gamma is unsupported or undesired, add the option "-gamma #" to the command line,
where # could be e.g. 1.1 or some other float value that looks good. Note that in this mode, the
engine only sets the gamma at startup so it doesn't help to change it in-game.

If you get an error message regarding fmod.dll when starting, make sure to use the file from the
Nehahra pack. Later versions are for unknown reasons not backwards compatible. 

Some extensions have broken compatibility. The engine is using a custom network protocol that is
different from the standard protocol 15 and this affects both multiplay and demos. This means that
when using the engine as a server, you must normally have the same engine as a client. However,
the engine can act as a client to any standard server. See also cvar sv_protocol below.

Demos recorded with this engine can't be played back directly in a standard engine, but using the
ConvDem utility, you can convert them to standard format. Any standard demo can of course be
played back using this engine.

==================================================================================================
TIP

Adding option "-condebug +developer 1" to the engine command line is recommended to see and log to
file extra warning messages from the engine that might indicate problems in the map, e.g. missing
model skins. The log is written to qconsole.log in the game directory and is overwritten each time
the engine is started.

==================================================================================================
CHANGES (see also readme for Enhanced GLQuake)

The changes are as follows :

Nehahra 3.08 (Aug 7 2007)

1. Fixed bug that prevented underwater polys to be rendered when using "-nomtex" option.
2. Improved visibility of entity particles when seen from a distance (Ghoro or Quoth DLord).
3. Fixed bug that in rare cases could cause an invalid decompression of a dz (e4m8_recam).
4. Added feature to play back first demo from a dz if a demo with the same name as the dz cannot
   be found.
5. Changed so options "-hipnotic", "-rogue" or "-quoth" will automatically enable "-id1".
6. Fixed bug and added proper handling of the colourmapped TE_EXPLOSION2 effect that before
   just had a red dynamic light.
7. Restored behaviour for the demos/map/startdemos commands to the same as in original GLQuake if
   "-id1" is enabled.
8. Restored colour of console say/say_team messages to the same as in original GLQuake.
9. Optimized lightmap handling and reduced its memory usage typically by 25%.


Nehahra 3.07 (Jan 12 2007)

1. Restored r_shadows functionality and improved rendering.
2. Moved gl_glows handling to transparent entities to avoid depth-buffer anomalies.
3. Significantly improved rendering speed of transparent entities.
4. Fixed bug that made wraiths opaque when animation interpolation was disabled.
5. Added option "-id1" that puts id1 directory before nehahra in search order and restores the
   original cheat codes. This will help running non-Nehahra mods.
6. Added cvar r_nowaterripple to permanently disable waterripple.
7. Fixed bug when playing back demos that are dzipped together with other files.
8. Fixed bug that caused gl_glows halos to shrink with distance if both gl_fogenable/gl_fogdisable
   were 1.


Nehahra 3.06 (May 25 2006)

1. Fixed playing back demos that are dzipped together with other files (e.g. txt files). Now only
   the file with the same name as the .dz but with extension .dem will be unpacked and played.
2. Fixed minor screen flicker when loading maps with excessive lightmaps.
3. Removed option "-noalpha" and replaced by existing cvar gl_notrans logic (still unclear what
   -noalpha was supposed to be doing).


Nehahra 3.05 (Jan 21 2006)

1. Increased MAX_MODELS/MAX_SOUNDS from 256 to 1k and added warnings when exceeding normal limits.
   This breaks protocol/demo compatibility, new server protocol number is 10002. Client can still
   connect to or playback std protocol 15 (with or without Nehahra extensions).
2. Increased clipnode capacity from 32k to almost 64k.
3. Improved gl_glows handling in fog, now the halos shrink with increasing distance and fog
   density.
4. Added persistent cvar r_interpolate_model_weapon that only affects weapon interpolation
   (default enabled).
5. Improved handling when running movie only (no Nehahra game contents installed).
6. Restored original Q1 menu and help system when not loading the Nehahra custom menu.
7. Restored option "-particles" to control amount of particles and changed default from 1024 to
   2048. This also restores functionality and looks of leak line (pointfile) to be the same as in
   GLQuake.
8. Added fog support from worldspawn. Use key "fog [density] [red] [green] [blue]" (similar to
   FitzQuake). When using the Nehahra progs, its fog control will still override.
9. Fixed rare crash bug in frame interpolation code, probably caused by entity model morphing,
   e.g. a monster changing into a gibbed head.
10.Added cvar host_maxfps (default 72, usable range 10-1000). Set to 100 to mimic older versions.
11.Added control of the cutscene cvar via the video options menu and made it persistent.
12.Fixed a bug in the waterripple slider in the video options menu.
13.Disabled engine abort for some errors, e.g. touching a teleporter that has no destination.
14.Changed so missing sprites/smoke2.tga file at startup doesn't cause an abort.
15.Changed error message at startup when not finding any Nehahra contents.


Nehahra 3.04 (Sep 7 2005)

1. Added compensation for invalidly rotated skybox in Invein.
2. Changed so fog also affects transparent entities.
3. Added cvar gl_skyfix (default 1) to control transparent skybox fix (multitexture is still
   required for fix to work). Disable for special effects only.


Nehahra 3.03 (Jun 6 2005)

1. Fixed abort bug when playing some dzipped demos.
2. Decreased default zone size from 512k to 256k.


Nehahra 3.02 (Apr 9 2005)

1. Reduced rendering load by restoring gl_finish logic, i.e. glFinish will only be called when
   gl_finish is enabled.
2. Fixed playmod bug that caused slowdown and sound distortion in neh1m2 (near SK) and neh1m3
   (water tunnel exit).
3. Decreased max fps from 100 to 72 to reduce CPU load in low-stress situations. To disable this,
   set new cvar host_sleep to 0 (this will also increase CPU load).


Nehahra 3.01 (Feb 18 2005)

1. Fixed bug that caused skyboxes to be hidden in fog (e.g. neh1m3).
2. Improved precision in ftos QC function which e.g. enables better fog control.
3. Added hack for more fullbright flame/candle/lantern models and optimized gl_glows handling.
4. Fixed bug in options menu that prevented "Use Mouse" from working.
5. Changed default value for the gl_glows cvar to 1 and made it persistent.
6. Changed glow colour for quad damage to green/yellow (same as 2.67).
7. Fixed repaint of skins when r_fullbright is toggled and smooth animations is enabled.
8. Improved workaround for missing skybox (nehahra) when using "-nomtex".
9. Added workaround for initial distortion in skybox top face.
10.Added cvar gl_skyclip (default 4608) to control far clip for sky in fog.
11.Added skybox support also in pcx format.
12.Fixed minor bug in skybox handling for images not exactly 256x256.
13.Added command "fog" to ease fog control.
14.Restored cvar r_particles to disable particles.
15.Fixed bug that caused sprites to partially or completely disappear near water.
16.Fixed status bar updating when using "gimme" command.
17.Disabled logging of # SFX in developer mode.
18.Fixed bug in movie selection for low resolutions.
19.Added Nehahra icon to exe.
20.Changed title bar to Nehahra.
21.Restored printout of OpenGL vendor and version.
22.Improved MOVETYPE_FOLLOW handling.


Nehahra 3.00 (Nov 21 2004)

1. Fixed crash bug when disabling sounds with "-nosound".
2. Fixed crash bug when not having "-no8bit" enabled.
3. Fixed pausedemo while recording.
4. Fixed issues when playing the movie (e.g. invalid skies and premature aborts).
5. Added workaround so the "Loading" plaque is displayed between chained demos.
6. Fixed support for cvar r_waterripple (name mixup with gl_waterripple).
7. Fixed a lot of issues in multiplayer and dedicated modes.
8. Added workaround for transparent skyboxes in multitexture mode.
9. Added warning and workaround for missing skybox (nehstart, neh3m4) when using "-nomtex".
10.Changed to alternate trail handling for e.g. thicker rocket trails. Trails can now also be
   disabled in menu.
11.Fixed playback of dz demos outside or inside pakfiles (321 MB pak0.pak -> 35 MB).
12.Fixed bug when exceeding max # textures by adding protection and increasing MAX_GLTEXTURES
   from 1k to 2k.
13.Added cvar modvolume (0.0-1.0, default 0.5) that controls mod (music) volume.
14.Fixed so also mod (music) follows "-nosound" option.
15.Fixed bug in precached sounds (nailgun sound in menu).
16.Fixed some weird behaviour with 32-bit sprites (cache pollution etc).
17.Added texture name to cache mismatch warning.
18.Simplified multitexture handling and added "-nomtexarb" option for disabling ARB multitexture.
19.Fixed engine always going to menu after start.
20.Added cvar gl_fogdisable to permanently disable fog.
21.Added skybox support for tgas not exactly 256x256.
22.Added automatic loading of skybox if "sky" key present in worldspawn.
23.Added command "sky" with same functionality as "loadsky".
24.Added workaround for QC bug (neh1m8) that floods the console with empty newlines in developer
   mode.
25.Disabled logging of sounds to sounds.txt in developer mode.

==================================================================================================
NEW OR CHANGED COMMAND LINE OPTIONS (see also readme for Enhanced GLQuake)

-id1            Put id1 directory before nehahra in search order and restore the original cheat
                codes. This will help running non-Nehahra mods. This is automatically enabled when
                using "-hipnotic", "-rogue" or "-quoth".

-noalpha        Removed.

-nosound        Disable also mod (music) as well as sounds.

-particles x    Set amount of particles (default 2048).

==================================================================================================
NEW OR CHANGED CVARS AND COMMANDS (see also readme for Enhanced GLQuake)

Graphics, skybox/fog
--------------------

  gl_skyfix 0/1         Enable transparent skybox fix (default 1). Multitexture is still required
                        for fix to work. Disable for special effects only.


Graphics, misc
--------------

  gl_glows 0/1          Enable glow for selected models, e.g. torches (default 1).
  
  r_nowaterripple 0/1   Disable waterripple effect. This overrides r_waterripple and can be used
                        to disable waterripple independently of QC setting.

  r_waterripple 0/1     Enable waterripple effect. This can be overridden with r_nowaterripple.


Sounds
------
  
  modvolume 0-1         Set mod (music) volume (default 0.5).

==================================================================================================

Original GLQuake source code by John Carmack,            http://www.idsoftware.com
Nehahra 2.54 source code by Ender/LordHavoc              http://www.planetquake.com/nehahra
Many modifications inspired by Metlslime's FitzQuake,    http://www.celephais.net/fitzquake
Tyrann's TyrQuake,                                       http://disenchant.net
QIP Quake,                                               http://www.inside3d.com/qip
LordHavoc's DarkPlaces,                                  http://icculus.org/twilight/darkplaces
ProQuake,                                                http://www.planetquake.com/proquake
JoeQuake                                                 http://joequake.quake1.net

