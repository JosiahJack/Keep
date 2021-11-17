
				THE MARCHER FORTRESS
				====================
			     
				   By Ben Wooding


Description
===========

Single player level for Quake, with many custom gameplay additions.

Coop and Deathmatch are not supported.

This map was designed primarily for high capacity engines, such as Bengt Jardrup's Win/GLQuake variants, and LordHavoc's DarkPlaces.
However, I have gone to great lengths to ensure that the map is at least playable in FitzQuake, and the original Win/GlQuake,
although packet overflow and sound loss may be abundant in the larger battles, and many ambient sounds throughout the level may not appear.
Other engines are not considered "supported", i.e. I cannot guarantee that the map will appear or function correctly in engines other than those mentioned.

To make things easy, with his permission, I have included Bengt Jardrup's latest Win/GLQuake variants inside the zip file.
These are the recommend engines for playing The Marcher Fortress. The map is guaranteed to run smoothly in these engines with no problems AFAIK.

Updates to Bengt Jardrup's engines can be found here: http://user.tninet.se/~xir870k/


The Story
=========

After narrowly escaping the great Bastion of the Underworld, you find yourself wandering for days in the desolate uplands of the Marcher Vale,
a seemingly endless vista of mountainous rock, and labyrinthine caves. An icy wind from the North carries with it flecks of crumbled mortar,
and the remains of tattered flags. Against all instinct, you find yourself drawn onwards to the the source of this fell wind. As you approach,
the distant shrieks of elder demons warns you that another Bastion looms, one even older and greater than the last.


Installation
============

Unzip pak0.pak and autoexec.cfg to quake\marcher\

Start your Quake engine of choice with the command line:

-heapsize 48000 -game marcher +map marcher +skill x (where x = 0/1/2/3)


The Autoexec File
=================

For your convenience, an autoexec.cfg file is supplied externally to the pak file.
This sets important graphics-related cvars.


Gameplay Changes
================

- Ammo-carrying capacity has been increased to 250 for all ammo types.

- Faster axe attack, making it a more useful weapon.

- New monsters: Flak Ogres, Imps, Spiders, Gaurochs.


Impulse Commands
================

Please note that there are many developer-oriented impulse commands which I have not documented, some of which set cvars which are saved
to the config file on exiting Quake. Accidentally activating these impulses can cause the map to crash on restarting
- if you encounter this, just type:

"saved1 0"

At the console, and restart the level.


Impulse 152:	Toggle Entity Grouping
		======================
		Entity grouping is ON by default; this enables a form of edict compression that allows the map to be playable
		in engines without increased MAX_EDICTS. It should have no visible effect on gameplay. If you turn entity grouping OFF,
		be warned; the map will only be loadable in high-capacity engines, and you will most likely suffer a performance hit.
		Requires a map restart.

Impulse 153:	Corpse Remove All
		=================
		All corpses in the map will be removed after a short delay. 

Impulse 154:	Corpse Remove Custom
		====================
		This is the default (and recommended) corpse removal setting - corpses are removed according to game progression.

Impulse 155:	Corpse Remove None
		==================
		For high capacity engines only. No corpses are removed (except those of Gauroch Spawned monsters).

Note that these settings are saved to the config file after exiting Quake.


Other Notes
===========

This map features a monster and item count in excess of what would would normally be possible in Quake. 
To avoid reaching the max. edict limit, most entities are now spawned mid-game according to player progression.
 - be warned though - noclipping around the map will probably not fire the correct triggers and has been known to cause a crash.

If you play through the level normally, you'll be fine.



Compile Tools Used
==================

TreeQBSP, Light and RVis by Bengt Jardrup.

Known Issues
============

- A number of bad shadows (dark triangles), mostly on the terrain brushes. I have tried really hard to minimise these,
but the ones that remain were *really* stubborn.

- Loss of ambient sounds in engines without increased sound capacity.

- There are a couple of bmodels that seem to straddle vis portals. This causes them to dissapear in certain views.
This issue only manifested itself after the fullvis was completed (which took 140 hours o_O), so I can't really fix it for this release.

- You can't gib spiders, because I felt they looked silly using the standard gibs. I never did get around to making custom spider gibs.
(oh well, you can't gib fish either ^_~)




Credits
=======

Thanks to: 	id Software
		Raven Software
		Epic Megagames

Thanks to Bengt Jardrup (user.tninet.se/~xir870k) for his compile utils, and all-round help on this project.
Thanks to Kell (kell.spawnpoint.org) for encouragement, beta-testing, and awesome textures.
Thanks to necros (www.planetquake.com/necros) for sound support.
Thanks to Vondur (www.vondur.net) for beta-testing.



Contact Info
============

email: (bdwooding -at- gmail -dot- com)


Copyright/Permissions
=====================

You may only distribute this pack in the form of this zip file, with this text file included
	
You may NOT include this pack as part of a larger release without my permission.

You may NOT distribute this pack for any commercial purposes.



