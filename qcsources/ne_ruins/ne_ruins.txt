=======================================================================
06.22.11
=======================================================================

Title                   : The Altar of Storms
Filenames               : pak0.pak
			  ne_ruins.txt
			  pak0.pak

Author                  : necros
Email Address           : corey.michel.jones@gmail.com
Website			: http://necros.slipgateconstruct.com
Description             : 2 Large maps set in a frozen world.  Sort of a tribute to TES4:Oblivion:
			  The first map is a pseudo open-world map.
			  The theme for the second map is similar to ayleid ruins and the layout for the second map is based on the 'Miscarcand' (all 3 sections) dungeon.

Other levels by author	: ne_tower	    - "Moldy Tower"		(Q1SP) (Quoth)
			  chapter_necros2   - "Are you Yet Living?"	(Q1SP) (Quoth)
			  ne_doom	    - "Elder World Waystation"	(Q1SP) (Quoth)
			  ne_lend	    - "The Living End"		(Q1SP) (Quoth)
			  ne_deadcity	    - "The Rats in the Walls"	(Q1SP) (Quoth)
			  ne_marb	    - "Crescendo Of Dreams"	(Q1SP) (Quoth)
			   -> ne_marb2	    - "Surmounting Terror"	(Q1SP) (Quoth)
			  nesp16	    - "R_speeds be damned!"	(Q1SP)
			  nesp10	    - "Embers of Cruelty"	(Q1SP)
			  nesp09	    - "Dawn of Eternity" 	(Q1SP)
			   -> ne_os1	    - "Survive This!"		(Q1SP)
			  ne_sp06	    - "Once Upon Atrocity"      (Q1SP)
			  ne_empty/ne_sp04  - "The Emptiness Without"   (Q1SP)
			  n3sp03            - "The Gates of Midian"     (Q1SP)
			  ne1_q2dm          - "Cosin Law"               (Q2DM)
			  n3sp02            - "Castle Necrosis"         (Q1SP)
			  n3_100b.bsp       - "oH gOd!"                 (Q1SP, 100B)

=======================================================================

* Play Information *

Single Player           : Yes
Coop starts		: Yes
Deathmatch              : No
Difficulty Settings     : Yes
			  Easy: You should be able to beat this without dying.
			  Normal: Somewhat challenging.  The average player should be able to beat this while dying maybe 2 or 3 times.
			  Hard: Expect to die when learning some encounters.
Music Track		: Yes!  Put the Quake CD in!  (or have your mp3/ogg rips ready...)
GLQuake Supported	: No
SoftwareQuake Supported : No
Engine Extensions	: REQUIRES Fitzquake085 or Fitzquake085 variant limits: (65k verts, clipnodes, marksurfaces, etc...)
			  (Fitzquake085, Quakespasm085, RMQEngine).
			  
			  Requires coloured lighting.  Technically this is optional, but the map will not look right at all.  It relies heavily on coloured lighting to achieve it's look.
			  Requires per-entity .alpha support. (Pretty much all engines have this).
			  Requires Fog Settings Interpolation.  The parts of the boss fight are UNPLAYABLE without this!
			  MAY (NOT 'Will') run on other advanced engines, but I make NO guarantees.  Performance may be poor or there may be visual glitches.
			  
Excluded Engines	: This map DOES NOT WORK in aguirre's enhanced GLQuake.  Some portions of the map are unplayable in this engine and some sounds will not play.

* Construction *

Base                    : Scratch
Editor(s)               : Sikkpin's QuakeEd 3.1, Photoshop for the textures.
Known Bugs              : None (which usually means there are a bunch...)

Build Time              : 4 Months, off and on.
Textures used           : Predominantly Chicoruins + Rune textures with a few from
			  quake.wad and rogue.wad.
			  The rock and snow textures used in the first map are from Doom3, but photoshop'ed to look snowy.
			  The outdoor bricks + pentagonal door are Unreal 1 textures modified to look whiter.
Compile machine         : intel core2duo e6300
Compile tools:		: Aguire's BSP
			  Willem's modified version of aguirre's vis, (with the patch by Tuna)
			  MH's modified version of aguirre's light (for coloured lighting)

=======================================================================

* Information/Notes *

THIS IS NOT A QUOTH MAP!  DO NOT USE QUOTH!

This mod includes an autosave feature.  Every once in a while, you will see the message 'Saved to ne_autosave.sav'
You can press 'F8' to reload to that point and pressing attack or jump when dead will automatically load the autosave instead of restarting the map.
HOWEVER, if you quit the game and wish to load your autosaved game later, you will need to type 'load ne_autosave' into the console instead of pressing F8.  F8 will function correctly AFTER the map has been loaded from the console.

This map requires a Fitzquake variant for full compatibility.  These maps are very large and a fast renderer is a plus here but more importantly, these map requires an engine with fog interpolation.
Also, some sections are completely unplayable without these Fitzquake features.
If you really don't want to use a Fitzquake variant, at the very least use one that supports per-entity .alpha settings and expect some fairly serious bugs.

=======================================================================

* Installation *

unzip these maps into a directory of your choosing, eg: /quake/ne_ruins

run quake with: -zone 2048 -heapsize 192000 -game ne_ruins

Make sure 'max_edicts' (in the console) is set to AT LEAST 4096.  8192 to be safe.  Failure to set this may result in the map crashing the engine.  The pak0.pak contains a config file 'ne_setup.cfg' which should take care of this however.

When using a fitzquake variant, make sure sv_protocol is set to 666 (or whatever your variant requires, 999 for RMQ I believe), otherwise you'll probably get invisible items or other oddities.
I could not include a default protocol setting in config files because each engine has it's own protocol number.

A bit about -zone:
(Skip this if you don't care about technical stuff)
-zone is the command switch that controls how much memory is used for storing certain things used by the engine.  it is a seperate bit of memory from -heapsize.  in fact, it is not needed if you use Fitzquake, but Quakespasm stores extra things in the -zone memory, necessitating extra allocation.

* PLAYING * (this is the fun part...)

Once the engine starts, select your skill level in the console (skill 0, 1, 2, 3) for easy, normal, hard, nightmare.
Select 'New Game' from the menu.

=======================================================================

start:

QBSP                   : 0h:2m:06s
Vis (quick)            : 0h:2m:??s (it is not worth full vising this map as it is almost entirely outdoors in one giant room.
Light (extra4)	       : 0h:22m:30s
Brushes                : 6758
Entities               : Changes during play, but ~1500? at peak and 601 at minimum. (i found that amusing)

ne_ruins:

QBSP                   : 0h:2m:38s
Vis (level 4)          : 3h:1m:??s
Light (extra4)	       : 0h:29m:47s
Brushes                : 23408
Entities               : Changes during play, but ~3000 at peak and ~1600 at minimum.

=======================================================================

* Story *

Stuck atop frozen mountain peaks known as the Fingers of the Gods, your only way out lies in using
the Altar of Storms to open a gateway and escape.
You will need an ancient Rune to activate the Altar, conveniently held deep below ground in a buried city...

=======================================================================

* Credits *

‡ id for obvious reasons
‡ sikkpin for doing QuakeEd 3.1
‡ Preach for answering tons and tons of questions regarding the quake engine and QuakeC's interaction with it.  A lot of the code in here wouldn't have been possible without his help.
‡ Bengt Jardrup (AKA aguiRe) for the Modified QBSP, LIGHT and VIS programs.
‡ MH for multi-threaded LIGHT modifications AND coloured light support. (Without which this map couldn't exist).
‡ Warren Marshall for multi-threaded VIS modifications and Tuna for fixing a bug with this VIS.
‡ Testers: Negke (a LOT), Tronyn,

=======================================================================

* Copyright / Permissions *

Commercial distribution of this material, in whole or in part, requires
prior agreement with the author.  Commercial distribution includes any
means by which the user has to pay either for the support (e.g. CD-ROM,
or magazine CD-ROM)or for the material itself.  Unauthorized commercial
distribution is prohibited.
You may distribute this map for free provided this text file is included.

© 2011 necros

QUAKE® is a registered trademark of Idsoftware, Inc.
All other names are trademark of their respective owners...

=======================================================================