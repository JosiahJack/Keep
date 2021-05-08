
				BASTION OF THE UNDERWORLD
				=========================
			     
				     By Ben Wooding

The "Plot"
==========

For the first time, escape from Quake's hellish realm seems to be near, as you find yourself drawing close to the great outer walls of his
Netherworld bastion. As you approach the borders of his domain, your presence once again draws the unwelcome attentions of his daemonic hordes, 
who are beginning to muster and organise in ever greater numbers, as if under the command of an unseen new enemy...


Description
===========

Single player level for Quake, with many custom gameplay additions.

This map was designed to be playable in both the standard Quake engines, WinQuake and GLQuake. 

Coop and Deathmatch are not currently supported.


Installation
============

Unzip pak0.pak and autoexec.cfg to quake\bastion\

Start Quake with the command line:

-heapsize 32000 -game bastion +map bastion


Performance
===========

r_speeds are good all-round, averaging around 500-600 indoors, but peak at around 2000 in the two large outdoor arenas.
In any case, you can remove all risk of "greyflash" by adding:

r_maxedges "10000"	
r_maxsurfs "10000"	

to your usual config file. For your convenience, an autoexec.cfg file is already provided with these commands.

In addition, to this, you must allocate more memory to Quake, eg. add -heapsize 32000 to the command line.
----------------------------------------------------------------------------------------------------------


Gameplay Changes
================


- Ammo-carrying capacity has been increased to 250 for all ammo types.

- Faster axe attack, making it a more useful weapon.

- Weaker monsters in Easy (see below).

- New monsters: Flak Ogres, Sergeants, Shufflers.


Skill Levels
============

Skill levels in this map are not implemented as well as they could be. Because of the new way monsters are spawned, 
it would be difficult to manage monster counts based on skill level. For this reason, monster counts are identical in all skill levels. 

In Easy (skill = 0), larger monsters have reduced health. I know some players may find this objectionable, but I personally find it more fun 
ploughing through hordes of weaker monsters than having less monsters.

Normal and Hard should be identical in terms of gameplay, with no health reduction in effect.

Nightmare is as usual (i.e. monsters going beserk with their attacks).

So in a nutshell, you only get a choice of 3 skill levels as normal/hard are the same.


Impulse Commands
================

"impulse 150" - removes "global ambient" sounds from the level. Use this if you find the atmospheric sounds annoying. 
Localised ambient sounds are not affected.


Please note that there are many other developer-oriented impulse commands which I have not documented, some of which set cvars which are saved
to the config file on exiting Quake. Accidentally activating these impulses can cause the map to crash on restarting - if you encounter this, just type

"saved1 0"

At the console, and restart the level.


Other Notes
===========

It should be noted that this map features a monster and item count in excess of what would would normally be possible in Quake. 
To avoid reaching the max. edict limit, most entities are now spawned mid-game according to player progression.
 - be warned though - noclipping around the map will probably not fire the correct triggers and has been known to cause a crash.

If you play through the level normally, you'll be fine.


Clues to Secrets
================

I'm not going to completely spoil it for you (the secrets are pretty straightforward as it is).


Secret 1:	Grunts and explo-boxes don't mix.
Secret 2:	Can you dodge the Gib Spinner?
Secret 3:	Remember Gloom Keep?
Secret 4:	Sharp-shooting should short-shrift the Shuffler.
Secret 5:	The end may be near, but a Quad is nearer.


Compile Tools Used
==================

TreeQBSP, Light and RVis by Bengt Jardrup.




Credits
=======

Thanks to Bengt Jardrup for his compile utils, and all-round help on this project.


Contact Info
============

email: (bdwooding -at- members -dot- v21.co.uk)


Copyright/Permissions
=====================

You may only distribute this zip file as long as this text file is included in the zip.

You may NOT distribute this level for any commercial purposes.



