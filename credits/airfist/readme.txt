Title    : AirFist
Filename : AirFist1.zip
Version  : 1.0
Date     : 1/22/97
Authors  : The Evolve team 

Christopher Bolin: Concept and Artwork
Stephen F. Karl: Model
Shane W. Powell: QuakeC
Matt Houser: QuakeC
Mark Lewis: Sounds

Build time: 2+ weeks development and testing

Credits
-------
Jon Skinner 
Travis Prebble (web help)
Stephen Heaslip (Blue)
Dan Martin, David Karl, Chris McGowen and Kirk Cooper for 
"extensive" testing and included demos.


Type of Mod
-----------
Quake C  : yes
Sound    : yes
MDL      : yes 


Format of QuakeC
----------------
unified diff  : no
context diff  : no
.qc files     : yes
progs.dat     : yes


Description of the Modification
-------------------------------
The experimental AirFist has become a formidable defensive weapon 
in the fight against Quake.  A compressed air weapon that sends almost 
anything it is aimed at flying.  This weapon is also used to send 
incoming ordinance other than where it was originally intended.  
Although unofficial use, some in the field have become adept at using 
a blast aimed at the ground to overcome both hostile and unattainable 
ground.  Be warned, the self-recharging compressor requires time after 
a series of rapid bursts.

Why, How, What
--------------
I approached several teams to build the AirFist.  I knew it would 
require more than one person, and I had pretty lofty goals for the 
weapon.  Enter the Evolve team. These guys are possibly the most 
talented TC team anywhere.

The AirFist had four goals.  

First, to be a "new" kind of weapon.  There are plenty of projectile 
weapons in first person 3D games that all amount to the same thing in 
gameplay. There really isn't much difference between a laser and a 
nailgun in deathmatch.  Add a rocket launcher, grenade launcher, axe 
and grappling hook and the rest we have seen are all derivatives. 

Second, to be a defensive weapon.  There are no good defensive weapons 
for Quake out there IMO. We wanted the AirFist to maintain the 
twitch-reaction timing that Quake demands, and still offer good 
protection during a fire-fight.  This required some kind of fast, 
deadly, cool protection against even the most deadly weaponry. 
(read rocket launcher)

Third, to affect/change gameplay.  The AirFist can be used to alter 
the layout of objects that respawn.  For example, try blasting the 
Quad damage to a new location and then pick it up.  This is an 
excellent method of confusing those types that like to lurk around 
powerups.  Or try hiding megahealth.  Finally, you can also aim down 
and blast your way over lava pits, up to inaccessible areas, or away 
from an attacker.

Finally, the end result had to be a weapon like any other.  It had to 
have limitations as well as strengths  We wanted the behavior to model real
physics as much as possible, without effecting good gameplay.  The AirFist 
will hurt a foe based on the target's distance from the shooter, but even 
so it is not intended to be a replacement for the rocket launcher.  It will 
get you out of tough situations (like a barrage of rocket fire), but if 
you fire it continually it will need to recharge.  We took great pains to ensure 
this weapon was "balanced"


Commands include:
KEY 
2    	IMPULSE 2 - Will first select the shotgun, then the AirFist
	IMPULSE 47 - Automatically switch to the AirFist.
	IMPULSE 48 - Previous weapon

Tip: Here is a way to fire a quick blast with the airfist and then switch back to
a weapon that will deal some death:

bind e "impulse 47;+attack;wait;-attack;impulse 48"

How to Install the Modification
-------------------------------

Create a directory called AirFist in your Quake directory. Now unzip 
the contents of AIRFIST01.ZIP into this new directory.  

To play, type QUAKE -GAME AIRFIST from the Quake directory.  This 
modification only works with the registered version of Quake.


Technical Details
-----------------
Commented QuakeC source is included in this distribution file as SRC.ZIP.  
We want this mod to be used in the best compilations on the net.  Please credit
all of the developers on the AirFist team. (and a link on your page to our TC page 
would be great!)


Author Information
------------------
If you think this mod rocks, wait until DarkMare! Darkmare:of wolf and man 

Evolve is made up of 3 awesome QuakeC guys, a professional sound guy, a guy who cranks
out models like there is no tomorrow, and some skins guy.

Check out the webpage: http://www.voyager.co.nz/~darkmare/index.html


Cool Stuff
----------
Firing the gun underwater behaves differently. (try it)
In teamplay, try passing health packs to injured teammates.
With a little practice, you can blast and jump amazing distances.
You can also blast up and into entryways high above.
In deathmatch, try hiding Quads, healths, or whatever.
In deathmatch, blow the same objects into lava.
In deathmatch, blow opponents into lava.
Be creative...

There are 6 demos included with the AirFist.  3 single player, and 3 deathmatch
games.  We couldn't decide on just 3 because each had something we wanted to 
show about the AirFist.  Take a look!

I can't wait to see this mod in CTF!  Imagine defending a base
with the AirFist.  Deflecting oncoming attackers and their rockets while 
calling for help... ho boy...

Let us know if you have a unique use for the gun!

Known Bugs/Issues
-----------------
Occasionally a monster/player can get stuck in a wall after sucking 
the AirFist.

Copyright and Distribution Permissions
--------------------------------------

The modifications included in this archive are Copyright 1997, the Darkmare team.
 AirFist source modification is Copyright 1997, the Evolve team
 The original QuakeC source is Copyright 1996, id software.

Authors MAY NOT use these modifications as a basis for commercially available work.

You may distribute this Quake modification in any electronic format as long as
 all the files in this archive remain intact and unmodified and are distributed
 together.

QuakeC, Model and artwork can be reused, but credit for the individual developers on
 the AirFist team is required.


Availability
------------

This modification is available from the following places:

Darkmare Homepage: http://www.voyager.co.nz/~darkmare/index.html
Book of Skins: http://home.goldmanins.com/bolin/
 
