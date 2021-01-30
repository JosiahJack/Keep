======================================================================
    D  R  A  K  E      M  A  N  U  A  L
======================================================================

Author   : Patrick Martin (PM at func_msgboard)
Version  : Beta 1
Date     : 6/24/2011

======================================================================
    Introduction
======================================================================

Drake is a Quake 1 mod designed primarily for Single Player (Q1SP).
It began life as Dragons, then evolved into a compilation mod as
features were added from various sources.  Later, it absorbed the
Soul of Evil codebase and now serves as a base for whatever Tronyn
needs for his maps.  Drake features an assorted variety of content.

Although Drake is not fully completed yet, most of the content has
been finished such that rather than wait an indefinite amount of
time for a fully completed version of Drake some time in the future,
this unfinished version has been released so that you may browse this
mod and the source, and for Tronyn to use with his finished map packs.

More to come in a future version:
* Complete devkit with entity files and a detailed manual.
* More demo maps.

Although it is compatible with standard engines, it is recommended
that an enhanced engine is used to run Drake.

List of recommended engines
-FitzQuake085
 (http://www.celephais.net/fitzquake/)

-QuakeSpasm
 (http://quakespasm.sourceforge.net/)

-aguirRe's GlQuake, WinQuake or NehQuake
 (http://user.tninet.se/~xir870k/)

Drake loads many more files than the standard game.
Use of -heapsize 480000 (or higher) is recommended.

======================================================================
    Installation
======================================================================

* Create a subdirectory called Drake within your Quake directory.

* Extract all files from drakebeta.zip into the Drake subdirectory.

     QUAKE
     |
     +--- ID1
     |
     +--- DRAKE (place contents of drakebeta.zip here)

* In Quake\Drake, you should have the files drakebeta.txt (this file),
  pak0.pak, pak1.pak, progs.dat, and progs_dp.dat.

* IMPORTANT:  IF YOU ARE USING DARKPLACES, RENAME OR REMOVE PROGS.DAT
  AND RENAME PROGS_DP.DAT TO PROGS.DAT!

* Run Quake -game drake

* Demo maps ryu1 and ryu2 are available.  To play them, type (without
  quotes) 'map ryu1' or 'map ryu2' on the console.

-------------
    Extra
-------------
-Frikbots are supported.  To play a game with them, add the option
 -listen x.  For example, quake -game arwop -listen 8 +deathmatch 1.
 Impulse 100 adds a bot to your team, impulse 101 adds to a bot to
 an opposing team, impulse 102 removes a bot from the game.

-Dmsp mode is supported.  To activate dmsp, start a game and set the
 variable "temp1" to "1" in the console(~).  Then restart the game.

-If you experience slowdown, corpse removal may be enabled to remove
 the dead from the level.  Go to the console, type impulse 72, then
 restart the level.  This does not work in games of Hell difficulty
 (see below).

======================================================================
    Gameplay
======================================================================

-------------
  Firepower
-------------
Most Quake weapons have been modified in some way.  In addition,
Drake adds more weaponry to your arsenal.  Some have been imported
from elsewhere, others are new.

AXE:
Stronger and quicker than before, the axe can deliver a finishing
blow that may decapitate weak opponents.  The axe can also hack a
zombie to pieces in three hits.

CHAINSAW:
With 50% more power than the axe, nothing screams carnage better than
a blood-stained chainsaw.  Once taken, the chainsaw replaces the axe.
Chainsaws may be looted from the backpacks of slain ogres.

GRAPPLER:
A useful method of moving around, this version can also hook onto
monsters.  You may switch and use other weapons while the hook is out.

SHOTGUNS:
They fire slower than normal, but more than compensate with sheer
power.  Shotguns can also decapitate enemies with a well-aimed
headshot.  Decapitated zombies are slain and stay down for good.

RUBY WAND:
Fires blasts of magical energy to harm nearby foes.  It can be
charged to fire stronger blasts.  It is also a light in dark places,
when all other lights go out.

BLASTER:
Fires bouncing lasers like the Laser Cannon, at half the speed.
Almost as dangerous to you as it is to the enemy.  They may be looted
from the backpacks of slain enforcers.

SIDEWINDER:
Fires small, weaker homing missiles that fly toward the enemy along
an erratic, winding path.  Range is limited.  This weapon is very
easy to use, just point and shoot.  This replaces proximity guns
in levels that feature them.

PLASMA GUN:
Fires concentrated orbs of charged particles that fry nearby enemies
on contact.  Water and other liquids will cause the orbs to discharge 
prematurely.  Like the thunderbolt, firing the plasma gun while in
the water discharges all cells with deadly results.

THUNDERBOLT:
Modified from the original by firing a bolt of lightning that can
strike all targets in its path.

CHAIN THUNDERBOLT:
Fires a bigger bolt of lightning that arcs from the point of impact
to a maximum of three different targets simultaneously.  This is the
ultimate crowd destroyer, clearing rooms like nothing else.  Once
taken, it replaces the normal Thunderbolt.

MIRV LAUNCHER:
Think the rocket launcher is cool, you have seen nothing yet.
This BFG-like weapon launches a large guided missile that carries
a payload of five smaller homing rockets.  To operate, hold trigger
to launch missile, look to aim and guide it, then release trigger to
unleash the payload.  Any enemy within the gun sights may be a target
for each payload rocket.  Costs five rockets per shot.

MJOLNIR:
The hammer of Thor may be slammed or thrown.  The strength of the
slam depends whether the fire button is pressed at the time of impact.
To throw the hammer, double-click the fire button.  The stronger
powers cost 25 cells per shot.

BURIZA-DO KYANON:
This is a crossbow that fires deadly icy bolts that will shatter
most targets in a single hit.  The bolts are fired with such force
that they will pierce any target short of a solid wall.  Much like
a railgun, it is possible to line up and hit multiple targets with
one well-aimed shot.  Some very powerful enemies cannot be killed
instantly by this weapon.  Even so, enemies that survive a hit from
this weapon are slowed.

Tip: Lightning cast from enemies can hit all targets in its path too!

-------------
    Ammo
-------------
Due to the shotguns' increased power, shell yields from items are
reduced.  For every eight shells the player would get, he gets five
instead.  For example, when the player collects a large shell box,
he gains 25 shells instead of 40.

Ammo capacity has been changed from the standard.  Players can carry
up to a maximum of 100 shells, 200 nails, 50 rockets, and 200 cells.
Note that since cell yield from ammo items and cell cost for
Thunderbolt has doubled, cell capacity is effectively the same
as before.  In addition to the standard four ammo types, a fifth
type has been added: ice bolts.

ICE BOLTS:
For the Buriza-Do Kyanon crossbow.  Ice bolts may be found singly or
in pairs.  The player may carry up to 10 of them.

Tip: Ice bolts don't grow on trees.  Pick your targets wisely.

-------------
    Armor
-------------
In addition to the standard green, yellow, and red armor, several
more exotic flavors may be found.  Some of the exotic armor types
have special powers that can be activated by double pressing the
jump button.

COURAGE ARMOR:
Provides maximum protection and possible missile reflection against
frontal attacks, but offers no defense against attacks from behind.
Originally from Zerstorer.

DRAGONSCALE:
Red scaly armor that lets you morph into a small fire-breathing
dragon.  While in dragon form, you may fly through the air much
like swimming through water.  The morphing power may not work past
the level the armor is found in.

ONYX ARMOR:
Tired of armor that wears out?  You will like this one.  Onyx armor
is black, indestructible, and reduces damage by half.  It has
no usable powers.

POWER ARMOR:
A powerful upgrade to Onyx armor, this high-tech armor has all of the
properties of Onyx armor, and includes a power shield that can reduce
damage by another half, reducing total damage by 75%.  While active,
the power shield consumes cells when damage is absorbed.

DEMONHIDE:
This sinister flesh-colored armor is cursed!  Once taken, the player
cannot replace it with another armor until it is destroyed, but
disposing it is easier said than done, because it is indestructible.
While worn, the player takes 30% *more* damage than normal, but
regenerates health at a rate of two per second.  If the player takes
enough damage to die, the armor will merge with him and transfer its
power.  If the player lives, the armor is destroyed.

SPIRIT SHROUD:
This smoky, translucent armor can absorb up to 25 damage from an
attack.  Although the armor can take damage, it can rebuild itself
out of nothing at a rate of one per second.  If the armor is at full
power, it can be used to provide invisibility for ten seconds.  Using
the invisibility power removes all protection and the armor will not
rebuild itself until invisibility wears off.

CHAOS ARMOR:
Protection from this armor varies.  It also can teleport the player
to the starting point, but using its power destroys the armor
immediately.  Although absorbing damage reduces its durability, the
armor disappears only when replaced or when it teleports the player.

JUMP ARMOR:
This variant green armor lets the player jump higher than normal
and regenerate up to half maximum health at a rate of one per second.

-------------
  Power-ups
-------------
The new powerups you may encounter include the following:

AMULET OF REFLECTION:
Erects a force field that repels all missile fire away from you.
Though a very powerful defense, you can still take damage from other
forms of attack.

BERSERKER HELM:
Increases damage of your melee attacks by 25%, and heals you by
1 health per hit against living enemies.  Lasts until the end of
an episode.

BOOTS OF LEVITATION:
Allows the wearer to defy gravity for a limited time.  Hold jump
to float up, up, and away; then release to fall back down.
Also, falling is slowed enough that damage from landing will
not occur.

CROSS OF DEFLECTION:
Provides immunity to damage caused by explosions, drowning, and
contact with hazardous liquids (i.e., slime or lava), and reduces
damage taken from any other source by half.  Originally from
Chapters/Quoth.

POTIONS:
Health items in another form.  They can boost health beyond the
normal maximum at reduced effect.

REJUVENATOR:
Bestows unto you the power to regenerate at a rate of 1 health per
second.  Lasts until the end of level.

SHOTGUN OPTIMIZER:
Quickens shotguns' rate of fire.  The good news is hasted shotguns
deal out nearly as much damage as heavier weapons.  The bad news is
shells are consumed at a faster rate.  If you see this, you can be
assured that you will need it!  Lasts until the end of an episode.

SUPER PACK:
This super-sized backpack increases ammo capacity and provides a
small amount of each ammo type.  Lasts until the end of an episode.

TOME OF POWER:
Contains magic that modifies weapons to produce more powerful attacks.
Can combine with Quad Damage for devastating results.

TWIN SHOT:
Upgrades nailguns by firing twice per nail.  Nailguns' rate of fire
and damage remain the same.  In effect, this powerup doubles your
nail capacity and yields.  Lasts until the end of an episode.

HEART OF DARKNESS:
Increases maximum health by 25, then heals you to your new maximum.
The increased maximum health lasts until the end of level.

TREASURE:
Found as gold coins or gems.  Coins increase armor while gems
increase health.  The boosts can exceed normal maximums.

------------
  Monsters
------------
Rather than focus on additional monsters not available (yet) except in
Tronyn's map packs, this will reveal some changes to normal monsters.

Most monsters need air and will drown if they stay underwater for too
long.  Similarly, most monsters are harmed by slime or lava.

Ogres are "z-aware".  They can aim grenades up or down at a target.
When killed, an ogre will drop his chainsaw, which the player can
pick up and use.  Like ogres, zombies are z-aware as well.

Enforcers' shots fly faster than normal, making them harder to avoid.
Enforcers' drop their blasters in addition to cells when slain.
The player gains a blaster when an enforcer's backpack is taken.

In higher skill levels, some monsters may randomly attack more quickly
when wounded.  This is to increase difficulty of rhythm tactics such
as shambler dancing.  That is, approach monster, provoke melee attack,
back away from monster to a safe distance, then attack while the
monster is locked in its attack animation.

-------------
   Changes
-------------
Other miscellaneous changes in Drake include the following:

* Armor does not take damage if the player is invulnerable.
* Crucified zombies can be gibbed.
* Damage from drowning bypasses armor.
* Give # does not give weapons.

-------------
  Impulses
-------------
Drake has many impulses.  Most are cheats or developer stuff.

 13 = Gives keys (impulse 9 no longer gives keys)
 17 = Music toggle (for Tronyn's maps)
 18 = Remove selected weapon
 19 = Remove all weapons
 20 = Use armor (substitute for double jump)
 21 = Select axe/chainsaw
 22 = Select shotgun
 23 = Select double shotgun
 24 = Select nailgun
 25 = Select super nailgun
 26 = Select grenade launcher
 27 = Select rocket launcher
 28 = Select (chain) thunderbolt
 31 = Select Mjolnir
 32 = Select ruby wand
 35 = Select blaster/hyperblaster
 36 = Select sidewinder
 37 = Select MIRV launcher
 38 = Select plasma gun
 41 = Select grappler
 48 = Select crossbow
 51 = Command pets in FOV to STAY
 52 = Command pets in FOV to FOLLOW
 53 = Command pets in FOV to WALK
 54 = Command pets in FOV to IGNORE enemies
 55 = Command pets in FOV to FIGHT enemies (undo IGNORE)
 56 = All pets go wild and attack player
 57 = Kill all pets
 70 = Toggle DMSP
 71 = Toggle Cranked difficulty mode
 72 = Toggle corpse removal
 73 = Toggle footsteps (Do *NOT* use!)
 74 = Toggle summon test (Do *NOT* use!)
 75 = Toggle angry monsters (spawns aware of player)
 76 = Toggle respawning monsters (as Doom Nightmare difficulty)
 77 = Toggle Hell difficulty (skill 4)
 78 = Toggle classic shotguns
 79 = Toggle player models (Do *NOT* use!)
 80 = Toggle dragonscale (Do *NOT* use!)
 91 = Give Dragonscale
 92 = Give Courage armor
 93 = Give Power armor
 94 = Give Demonhide
 95 = Give Spirit Shroud
 96 = Give Chaos armor
 97 = Give Jump armor
 98 = Give Ultra armor (Travail's ultra enforcers')
100 = Add FrikBot to your team
101 = Add FrikBot to an opposing team
102 = Remove FrikBot
243 = Toggle Berserker Helm
244 = Toggle (Shotgun) Optimizer
245 = Toggle Twin Shot
246 = Slows player for 10 seconds
247 = Revives and enslaves monsters in player's FOV
248 = Activate Tome of Power for 30 seconds
249 = Teleport player to a secret, enables NOCLIP if necessary
250 = Displays player's origin and angles
252 = Toggle reflector shield
253 = Aggravate all monsters
254 = Kill all monsters

======================================================================
    Credits
======================================================================

Passive Contributions:
id Software - Quake, textures (http://www.idsoftware.com)
Hipnotic - Quake mission pack 1
Rogue - Quake mission pack 2
Raven Software - models, sounds from Hexen2 (http://www.ravensoft.com)
Blizzard Entertainment - sounds, info on Buriza-Do Kyanon
Aardappel and Fat Controller - Dmsp and Soul of Evil codebase
Frika C - Frikbot and compiler
ijed - fleshy vomitus skin
Kell - skyboxes (http://kell.quaddicted.com/skyboxes.html)
Kinn - monster skins from Marcher
Marc Fontaine - cyberdemon model (from cyber.zip)
Marcus Dromowicz - Mexx stuff (Bishop and slasher sounds)
Per - elephant gun sound from PerQuake
Steve Roscoe - skins and textures from Shadow of Innsmouth
Custents Team - flaming orange shockwave
Fantasy Quake Team - medieval soldier models, other sounds
Nehahra Team - various content from Nehahra
Nihlisim Unlimited - various content from Zerstorer
Quoth Team - cross of deflection
Team Evolve - chain lightning gun model, other sounds
Team Reaction - monster skins and sounds from Omen TC
Vengeance and The Lone Gunmen - original dragon patch

Thanks to:
metlslime for func_msgboard and FitzQuake
aguirRe for his great tools and Quake engines
Spirit for Quaddicted and community support
Tronyn for using Drake in his map packs
And all ye lost souls who continue to explore Quake's dark realms...

======================================================================
