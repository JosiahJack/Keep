=====================================================================
title:            In The Shadows (version 1.1)
date:             30th December 2012
file:             its_demo_v1_1.zip

author(s):        Simon 'Sock' O'Callaghan
email address:    mememe[at]simonoc[dot]com
my website:       http://www.simonoc.com/
ITS web page:     http://www.simonoc.com/pages/design/sp/its.htm
ModDb page:       http://www.moddb.com/mods/its

description:      An early Demo Build with *most* of the new game play
                  features working and three maps to have some fun with.

copyright:        Please do not use any of the project assets in your
                  personal project without permission. I want to
                  finish this MOD first before turning everything
                  into public domain.

additional        Original (clean) QC code base by preach
credits:          New AI pathfinding and combat QC changes by me
                  Lots of QC scripting help and support by necros
                  Some QC ideas from necros and czg code base
                  Most textures are ID based and modified by me
                  Additional book texture (bookshelf11) by kell
                  New AI Animation and rigging by necros
                  New models and skins by me (based on ID stuff)
                  Footstep sounds originally by MH, modified by me
                  Most other new sounds are from (www.freesound.org)
                  The sounds have been modified by me to suit the engine
                  s1m1 and s1m2 original layout ID and modified by me
                  start map layout and design by me
                  necros, thanks for the coding help and testing
                  negke, thanks for all the stealth balancing and testing
                  'The Nitpicker' - legend has it this was the only mortal 
                  Aramis feared more than death!" :D
                  community forums for loads of extra feedback
									
compilers and     QuakeC Compiler (FTEQCC) Version 1.00
dev tools:        BSP Compilers (txqbsp,vis,light) by Bengt Jardrup
                  Coloured light and LIT support by MH
                  Modified sunlight2 compiler by necros
                  newskip by John Fitzgibbons (awesome feature)
                  TexMex 3.4 by Mike Jackman (organize textures)
                  Noesis 3.866 by Rich Whitehouse (a must have!)
                  Qme 3.0 / 3.1 by Rene Post (mostly for static models)
                  AdQuedit 1.3 by Hicks Goldrush (used for sprites)

engine:           This demo has been designed and tested to *ONLY* work
                  with the following engines:

FitzQuake 0.85 (http://www.celephais.net/fitzquake/)
Mark V (http://www.celephais.net/board/view_thread.php?id=60831)

Communities
func_msgboard     http://www.celephais.net/board/forum.php
inside3d          http://forums.inside3d.com/index.php
quakeone          http://quakeone.com/forums/

=====================================================================

Installation
------------

* Create a folder in your quake directory called 'SHADOWS'
* Place this zip file in that directory
* Unzip contents to the directory that you just created
* Create a shortcut to the quake engine (see above)
* Add the following options to the shortcut command line:

-heapsize 64000 
-game shadows
+map start

Whats new in Version 1.1
------------------------
* Stealth eye shows monsters that cannot be backstabbed (skull symbol)
* Stealth eye sprite updated with new graphics (black = normal / white = training)
* New improved training area with loads of extra help messages
* Training monsters no longer do high damage to the player in stealth mode
* Skill level easy and normal have extra stealth training messages
* Poison bolt infighting tutorial and respawning poison bottles
* Books updated with more skins (green/yellow=general, blue=story, red=stealth)
* Main story increased in size and most text has been updated
* Five shadow hint books added, scattered through bonus maps
* All books stay open when touch by the player and particle effect is updated when read
* Skill runes changed to easily show which is active, new particle effect
* Nightmare mode removed from rune pillars, console only at the moment
* Stealth Alcoves no longer work if stealth mode is disabled (setup wrong)
* All slime areas have acid burning ambience to better hint at danger
* Added footsteps to all monsters/players (off by default)
* Added option to change texture filter mode (pixel mode on by default)
* Added more AI route notes to bonus maps and fixed a couple of errors
* Spike and Electric traps do 4x damage to monsters only
* Backpacks are properly removed by the amulet if they drop
* Wizard can be setup properly as a turret (no longer moves around)
* Range enemies will always fire at range targets first before getting close
* All stealth alcoves are properly marked with a new texture
* level end stealth stats are displayed correctly to the console
* All stealth related sounds setup as new sounds (can be updated easier)
* Player no longer auto-switches to poison bolts (only in training)
* Floor circle particles updated with explosion effect when switched on/off
* Starting player spawn points can now trigger other entities
* First hit of poison bolt always trigger a pain animation (was broken)
* Start map - console command 'training' to teleport to training area
* Start map - layout updated with new routes and extra areas
* Start map - demon cage changed to be less confusing (one button)
* Start map - demon cages have been changed so player can always get out of both
* Start map - fixed location of button to open vault (no longer hidden)
* S1M2 map - spike traps can be switched on/off (can kill monsters with them)
* S1M2 map - quad area has extra alcove for stealth play through

Stealth Mode Tips
-----------------
* Learn to use the walk ability of quake (+run to toggle the feature)
* Complete the tutorial section of the start map, it was designed to help
* Use the axe (from behind only) to strike the killing blow
* Remember to use the eye above all enemies to judge wakeup distance
* The eye works as follows; green = go, yellow = caution, red = danger!
* Do not stay close to the AI when the stealth eye turns red (timer)
* The floor of the tutorial section shows how the range of enemies works
* To regain the power of the amulet hide from enemy sight for five seconds
* A red pentagram with skulls floating up is a dangerous place, keep moving
* All enemies keep hunting even after the amulet has taken affect
* Eventually enemies will give up and go back to what they were doing before
* Some enemies will stop and stand guard for a while before returning back
* Learn to creep around and not get too close to the front/side of enemies
* The maps are littered with stealth alcoves, learn their locations
* Stealth alcoves will fade and often provide a sound clue when closeby
* Standing in the entrance of a stealth alcove prevents being discovered
* Enemies will hunt in stealth alcoves if the amulet is not working
* Enemies will turn around if you stand behind them for too long (timer)
* There is an endless supply of distraction bolts, use them!
* Try to avoid direct fights with enemies, they do huge amounts of damage
* Hitting enemies with distraction bolts only does 1 point of damage
* Hitting enemies with the axe still does 20 points of damage
* Enemies can only be distracted if stationary, patrols are not affected
* Use distraction bolts to turn enemies around (they will turn back - timer)
* Hit enemies from behind with distraction bolts to make them investigate
* Duck behind cover if firing a bolt in the face of an enemy
* Be careful attacking enemies if another enemy can see what you are doing
* The stealth axe only does a maximum of 350 damage to enemies health
* Enemies with large amount of health need to be poisoned first
* Weaken enemies with poison and then attack with the axe to kill them
* Poison bolts are a limited supply, use them wisely and look for more
* Enemies will go crazy and attack each other if poisoned
* Zombies/Undead are immune to poison, they will fall down instead
* Check stealth stats (impulse 225) to find out how you are doing
* Training monsters do not register as kills or stealth stats
* Enabling stealth mode for the first time removes most inventory items

Hub Map - Temple of Swords (start.bsp)
--------------------------------------

* To start the map from the console type 'map start'
* To automatically load on startup add '+map start' to the command line
* To start from the main menu, create a new game
* Easy/Normal/Hard skill levels are fully supported (unique setup)
* To change skill level touch the rune pillars at the beginning
* All encounters in the map are dynamically created based on skill level
* The skill level can be changed at anytime from the console by typing 'skill'
* Nightmare skill level is only available via the console for the moment
* Monster counts will vary because of the dynamic skill system
* Secret count does not vary, too confusing otherwise
* Contains a tutorial section for stealth training (underneath sword room)
* It is highly recommended to do the tutorial first before trying stealth mode
* Assassination, Avoidance and Chaos modes of stealth are supported
* The map is designed to be replayed several times (has unique routes)
* The map will change and adapt depending on what route is taken
* If lost or confused, follow the glowing arrows on the walls
* The map has several portals linked to all of the other maps
* A couple of secret areas exist, but mostly for fun and exploration
* Contains a special encounter called 'The Well of Bones' (optional)
* The story of Lord Aramis is told via books scattered throughout the map
* To interact with the books, move closer and look towards the pages
* To change the layout of the map (second playthrough), collect the runes
* Most of the books will show different text when you have the amulet

Bonus Maps - Shadow Gate (s1m1), Castle of Shadows (s1m2)
---------------------------------------------------------------

* To start the map from the console type 'map s1m1' or 'map s1m2'
* Easy/Normal/Hard Skill levels are fully supported (unique setup)
* To change skill level touch the rune pillars at the beginning of the map
* Nightmare skill level is only available via the console for the moment
* All encounters in the map are dynamically created based on skill level
* The skill level can be changed at anytime from the console by typing 'skill'
* Monster counts will vary because of the dynamic skill system
* The map is remake of the classic ID maps in the original game
* To understand stealth mode do the tutorial in the start map
* To start stealth mode, pick up the amulet at the beginning (start area)
* Assassination, Avoidance and Chaos modes of stealth are supported
* Enhanced AI path finding is supported throughout the map
* Extra routes have been added, highly recommend exploration
* All original secrets are intact, plus a couple of extra one's have been added
* No secret is necessary to complete the map in vanilla mode (run/shoot)

Impulse commands (testing mostly)
---------------------------------

General Testing
Impulse   9 - Give all weapon
Impulse 210 - Give Silver key
Impulse 211 - Give Gold key
Impulse 215 - reload map and reset inv/runes
Impulse 216 - reload map with runes
Impulse 221 - Teleport to stealth training
Impulse 225 - Print Stealth stats to console
Impulse 230 - Cycle through intermission cameras
Impulse 245 - Toggle global fog on/off
Impulse 246 - Toggle auto aim on/off
Impulse 247 - Toggle texture filtering on/off
Impulse 249 - Toggle footsteps on/off

AI Testing (dev mode only)
Impulse 200 - drops a ghost marker
Impulse 201 - drops a volume marker
Impulse 205 - Find nearest node to ghostmarker
Impulse 206 - Find next route to ghostmarker
Impulse 207 - Test AI volume conditions
Impulse 220 - Enable stealth mode

**** IMPORTANT ****
-------------------

Please record a demo of all play throughs as these are extremely
important to me because they show how you understood the map. 
Where you went, if you got lost and how you deal with
certain encounters. Thankyou.

=====================================================================
Distribution / Copyright / Permissions 

Copyright (c) 2012 sock, mememe[at]simonoc[dot]com
All rights reserved.

Quake I is a registered trademark of id Software, Inc.

This level may be electronically distributed only at 
NO CHARGE to the recipient in its current state, MUST 
include this .txt file, and may NOT be modified IN 
ANY WAY. UNDER NO CIRCUMSTANCES IS THIS LEVEL TO BE 
DISTRIBUTED ON CD-ROM WITHOUT PRIOR WRITTEN PERMISSION.

=====================================================================
