==============================================================================

Title        : AD v1.50P1 - (Arcane Dimensions)
Date         : 18th December 2016
MOD Team     : Simon OCallaghan - Art, Code and Level Design
             : Maik Franz Xaver - Art and Level Design
             : Corey Jones - Animation and Code Support
             : Matthew Breit - Animation, Art, Code Support and Level Design
             : Sean Campbell, Gavin Edgington, Noel Lacaillade - Level Design
             : Henrik Oresten, Andrey Saenko - Level Design
             : Eric Wasylishen - LD Compiler Support and Level Design
             : Andrew Denner - Art, Compiler tools and Code Support
			 
Additional   : Bengt Jardrup for WinQuake support and Code Support
thanks       : John Fitzgibbons for Rubicon2 Art assets and Code functions
             : Kristian Duske for editor/map conversion tools
             : Negke for help with Coop ideas and suggestions
             : Kell McDonald for Quoth Art assets & Madfox for Art assets
             : Romain Barrilliot for help with map testing
             : Louis Manning - Animation, Art and Code Support
             : Renier Banninga - Animation and Art	

Please note  : This is an alternative universe of Quake, many assets and
             : features have changed, even though it may look the same in 
             : places this code base and assets are very much different.
			 
Shotguns     : All of the shotguns have been changed to projectiles instead of
             : hitscan impact. If you don't like this change use impulse 130
             : to switch between either system or edit the quake.rc file.

Mappers      : The editor .def and .fgd files supplied with this MOD require
             : the worldspawn entity to have "no_item_offset" set to 1
			 
Name and QC  : Do not use the AD (Arcane Dimension) name for your own mod
             : All the QC files are included and covered under GPL
			 
Additional   : The majority of the textures are based on existing Quake assets
Compilers &  : BSP/VIS Compilers - by Kevin Shanahan/Eric Wasylishen
Dev tools    : Latest Version - ericwa.github.io/tyrutils-ericw/
             : FP map format - (www.voidspark.net/projects/bjptools_xt/)
             : TexMex 3.4 by Mike Jackman (organize textures)
             : AdQuedit 1.3 by Hicks Goldrush (updating skins)
             : QME 3.1 patch 2 by Rene Post (Change/update models)
             : Quake C FTEQCC Compiler (fte.triptohell.info/)

Engines      : The MOD is designed to work with the QuakeSpasm Engine
               Other engines offer partial support of features

* QuakeSpasm : Version 0.91.0 (Must use the latest version)
    - Download (http://quakespasm.sourceforge.net/download.htm)
	
* Darkplaces : Version 13 May 2014 (No longer in development)
    - Download (https://icculus.org/twilight/darkplaces/download.html)
	
* MarkV WinQ : Version 0.99 May 8 2015 (based on MarkV with retro settings)
    - Download (http://www.quakeone.com/proquake/interims/mark_v_20150508_windows.zip)


==============================================================================
MOD Contents
------------

Installation                 : How to install the MOD and maps details
MOD settings                 : How to change the way the MOD works
New / Updated Entities       : Detail list of misc, func and trigger changes
Entity State System          : New ability to switch any entity on/off/disable
Starting Point               : Ways to enahance start/hub map layouts
Trains, Chains and Corners   : New train system and path corners
Traps, Tricks and Tips       : New traps and tricks to include in maps
Breakable System             : How to enhance/change a map environment
Particle System              : How to create/use pixel particles in maps
New/Updated Monsters         : Detailed look at all new monters and abilities
Minion System                : New minion spawning system for certain monsters
Bounding Boxes               : Large table showing all monster bounding boxes
New Weapons                  : Detailed look at new weapons and how they work
Weapon Upgrade Parameters    : How weapon upgrades are given/taken from players
Ammo Resistance              : Details on how and what is affected by resistance
MOD Features                 : Long bullet point list of all new features
MOD Resource Credits         : Detailed list of where all the assets came from


==============================================================================
Installation
------------

* Create a new folder called "ad" in your Quake folder
* Copy the Zip file into the new folder
* Extract the contents of the zip file
* Create a shortcut to your preferred Quake engine
* Add the following to the command line

 -heapsize 256000 -zone 4096 -game ad

* The above command line is only needed if engine runs really slow 
* Run the shortcut (click icon) and make sure the engine loads
* After the start map has loaded pick your skill level

MOD Maps
--------
* start        - Hodgepodge of themes and portals (Simon OCallaghan)
* ad_cruical   - Lava caves and industrial complex (Maik Franz Xaver)
* ad_dm1       - Place of Many Deaths (Gavin Edgington)
* ad_lavatomb  - Stone city gradually sinking into lava (Noel Lacaillade)
* ad_mountain  - Dark stone mountain prison (Simon OCallaghan)
* ad_necrokeep - The Necromancer Keep! (Sean Campbell/Matthew Breit)
* ad_obd       - A giant pile of neatly stacked bricks (Simon OCallaghan)
* ad_swampy    - Gigantic interconnected medieval town (Maik Franz Xaver)
* ad_end       - Final destination for AD travellers (Maik Franz Xaver)

1.5 Maps
--------
* ad_chapters  - More themes and portals (Simon OCallaghan)
* ad_azad      - The Realm of Enceladus (Maik Franz Xaver)
* ad_tfuma     - Terror Fuma (Gavin Edgington/Eric Wasylishen)
* ad_magna     - Leptis Magna (Noel Lacaillade/Andrey Saenko)
* ad_metmon    - Arcane Monstrosity (Simon OCallaghan)
* ad_zendar    - The Horde of Zendar (Simon OCallaghan)
* ad_sepulcher - *Not Available* (Henrik Oresten/Simon OCallaghan)

Remix Maps
----------
* ad_dm5     - The Mire (Noel Lacaillade)
* ad_e1m1    - Hanger 16 (Sean Campbell)
* ad_e2m2    - Ogre Bastille (Simon OCallaghan)
* ad_e2m7    - The Underearth (Eric Wasylishen)

Test Maps
---------
* start_test - Round brick hub map with portals in all directions (SimonOC)
* ad_test1   - Breakables, new ambush surprises and monster reactions (SimonOC)
* ad_test2   - Egyptain blast from the past hanuted by Wraiths (SimonOC)
* ad_test3   - Hipnotic rotation; cogs, wheels and medieval fans! (MFX)
* ad_test4   - Small medieval courtyard with statues and Golems (SimonOC)
* ad_test5   - Large village square guarded by Minotaurs (SimonOC)
* ad_test6   - Tall medieval courtyard full of knights and ogres (SimonOC)
* ad_test7   - Multi level library full of teleporting skull wizards (SimonOC)
* ad_test8   - Giant runic room occupied by gaunts and droles (EricW)
* ad_test9   - Dark medieval chamber guarded by hammer ogres (EricW)
* ad_test10  - Plasma gun carnage in a giant brushwork box! (SimonOC)
* ad_test11  - Shooting range to test all projectile weapons (SimonOC)
* ad_test12  - Does not exist!!!

==============================================================================
MOD settings
------------

There are several different places (RC/Map/Console) where the MOD settings can
be changed and some locations have precedent over others. The MOD will initially
look to the quake.rc file first, worldspawn second and finally the console
commands third. The higher levels will always override lower levels.

------------------------------------------------------------------------------
Level 1 - quake.rc
The first place where settings can be changed is the Quake.RC file which is
located in the root directory of the MOD. The file contains full details of
what settings can be changed and what values to use.

------------------------------------------------------------------------------
Level 2 - World/Map
When a map is loaded the worldspawn entity can have the following settings
which will override any quake.rc settings. These options below will affect
all clients (SP / Coop / DM ) and can even give / take items.

float gravity;                  // gravity of map (default = 800)
string fog;                     // console command (Den/R/G/B - '0.05 0.3 0.3 0.3')
float fog_density;              // Global fog density (works with trigger_fog)
vector fog_colour;              // Global fog colour (XYZ = RGB)
string fog_dpextra;             // extra DP fog parameters, default - '1 0 8192 1024 32'
string water_alpha;             // Water Alpha, default - 1.00
float particlemax;              // Amount of ACTIVE particles per map

float no_item_offset;           // All ammo/heal items use central point rotation
float no_item_rotate;           // No random rotated for all items (ammo/heal/misc)
float no_zaware;                // Switch OFF zaware monster attacks
float no_liquiddmg;             // Switch OFF liquid (slime/lava) monster damage
float knight_defskin;           // Default skin for new red shoulder knight model
float bodyflrcheck;             // Stationary and Dead monsters do floor checks
float bodyfadeaway;             // Dead monster bodies fade away (secs)

float upgrade_axe;              // Upgrade Axe -1=disable, 1=enable
float upgrade_ssg;              // Upgrade Super Shotgun -1=disable, 1=enable
float upgrade_lg;               // Upgrade Lightning Gun -1=disable, 1=enable

float give_weapons;             // Bit flag for which weapons to give to the player
float take_weapons;             // 1=SG, 2=SSG, 4=NG, 8=SNG, 16=GL, 32=RL, 64=LG (excludes Axe)
float max_health;               // Update player health if below this value
float reset_health;             // Reset player health to this value (1-100)
float currentammo;              // =1 reset inventory, =0 minimum values
float ammo_shells, ammo_nails;  // Player ammo quantities for the map (reset/minimum)
float ammo_rockets, ammo_cells; // currentammo flag specifies how these values are used
float armortype;                // Armour type to start with 1=Green, 2=Yellow, 3=Red
float armorvalue;               // Quantity of armour to reset player (100/150/200)

------------------------------------------------------------------------------
Level 3 - Console Commands
Once a map is loaded certain impulse commands can be used to fine tune
settings or override current map defaults

autoaim     // Toggle player weapon Auto Aim (default = OFF)
zaware      // Toggle Z Aware monsters (default = ON)
feet        // Toggle monster / player footstep sounds (default = ON)
liqdmg      // Toggle monster liquid damage (default = ON)
upgproj     // Toggle Shotgun Projectiles/Casing (default = ON)
pixels      // Toggle texture pixel mode (linear = blurry, nearest = crispy)
coopart     // Toggle COOP players can drop artifacts
coopammo    // Toggle COOP ammo boxes to respawn

==============================================================================
IMPULSE COMMANDS
----------------

This is a full list of new impulse commands added to the AD MOD. Impulse
commands will only work when a map is loaded because they are functions
defined in QC. Some of these will only work when developer 1 is set. 

This information was originally in the quake.rc file.

Impulse 100 - Toggle auto aim
Impulse 110 - Toggle Z aware monsters
Impulse 115 - Toggle texture mode (linear/nearest)
Impulse 120 - Toggle footstep sound
Impulse 125 - Toggle Monster Liquid Damage
Impulse 130 - Toggle Shotgun Projectiles
Impulse 135 - Toggle Shotgun Casing
Impulse 140 - Display MOD information
Impulse 145 - Cycle through Intermission Camera(s)

-----------------------------------------------------------
COOP ONLY
-----------------------------------------------------------
Impulse 150 - Toggle COOP players can drop artifacts
Impulse 155 - Toggle COOP ammo boxes to respawn

-----------------------------------------------------------
DEVELOPER ONLY (need to set developer to "1")
-----------------------------------------------------------
Impulse 200 - Upgrade Axe
Impulse 205 - Upgrade SSG
Impulse 210 - Upgrade LG
Impulse 220 - Display Configflag
Impulse 225 - Display Player information
Impulse 230 - Toggle AI path extra info
Impulse 235 - Cycle Particle debug commands

Impulse 240 - Give ALL rune sigils
Impulse 241 - Give rune sigil 1
Impulse 242 - Give rune sigil 2
Impulse 243 - Give rune sigil 3
Impulse 244 - Give rune sigil 4
Impulse 245 - Give SILVER+GOLD key

Impulse 250 - Sharp Shooter
Impulse 251 - Nail Piercer
Impulse 252 - Environment Suit
Impulse 253 - Pentagram of Protection
Impulse 254 - Ring of Shadows
Impulse 255 - Quad Damage


==============================================================================
Mapping Documentation
---------------------

Entity keys for All entities
------------------------------------------------------------------------------
  spawnflags STARTOFF = 64;     // Starts off and waits for trigger
                                // Exceptions; lights, breakables
  string targetname;            // toggle state (use trigger ent for exact state)
  float noradiusdmg;            // Block all T_RadiusDamage, stops splashdamage
                                // can enable triggers to be direct damage only

New / Updated MISC entities
------------------------------------------------------------------------------
misc_fireball                   // Lava Balls, can toggle on/off with multiple triggers
  float dmg;                    // impact damage (default 5)
  float delay;                  // base time between spawning fireballs (default 3)
  float wait;                   // random time default 5 (= time + self.delay + (random() * self.wait) ) 
misc_drip                       // Single, continuous drip. Can be toggled on/off
  spawnflags SILENT = 2;        // Don't make any drip sound (good for multiple drips)
  spawnflags BLOOD = 16;        // Blood red drips instead of default
  spawnflags SLIME = 32;        // Slime green dripd instead of default
  float wait = 1;               // time between drips
misc_explobox                   // 32 x 64 unit exploding box with multiple styles
  spawnflag FLOATING = 32;      // Spawns floating, trigger entity to drop it
  string target;                // trigger events when box explodes
  float skin_override;          // 0=original, 1=rubicon2, 3=plasma, 4=toxic
  string noise;                 // Explosion sound (def=weapons/r_exp3.wav)
  float health;                 // Amount of damage required before exploding
  float dmg;                    // Override radius damage (def=160)
misc_explobox2                  // 32 square exploding box with multiple styles
  spawnflag FLOATING = 32;      // Spawns floating, trigger entity to drop it
  string target;                // trigger events when box explodes
  float skin_override;          // 0=original, 1=rubicon2, 3=plasma, 4=toxic
  string noise;                 // Explosion sound (def=weapons/r_exp3.wav)
  float health;                 // Amount of damage required before exploding
  float dmg;                    // Override radius damage (def=160)
misc_bob                        // model that gently moves back and forth
  string mdl;                   // Name of model (progs/candle.mdl)
  float angle;                  // direction movement, use "360" for angle 0
  float height;                 // direction intensity (def=4)
  float count;                  // direction cycle timer (def=2s, minimum=1s)
  float waitmin;                // Speed up scale (def=1) 1+=non linear
  float waitmin2;               // Slow down scale (def=0.75)
  float delay;                  // Starting time delay (def=0, -1=random)
misc_model / gtk_model          // Display Static Mesh Models
  spawnflags MISC_COLLISION = 2;// Bounding box collision enabled (square and no rotation)
  string mdl;                   // Specify model to load, full path "progs/candle.mdl"
  vector angles;                // 'pitch roll yaw' up/down, angle, tilt left/right 
  float ideal_yaw;              // Setup model with random Y axis rotation
  vector pos1;                  // used for selection of frame(s) has several setups
                                   X=0, Y=0, Z=exact frame number
                                   X->Y, Z=0 : will randomly pick a frame from the X,Y range
                                   X->Y, Z=-1 : will animate between the X,Y range, forward or backward setup
  vector pos2;                  // used for the selection of skin(s) has several setups
                                   X=0, Y=0, Z=exact skin number
                                   X->Y, Z=0 : will randomly pick a skin from the X,Y range
misc_shake                      // Shakes players inside of entity radius
  spawnflags VIEWONLY = 1;      // Shakes the view, not the player movement
  float count;                  // Radius of shake (def = 200)
  float wait;                   // Duration of shake (def = 2s)
  float dmg;                    // strength at center (def = 200)
  float sounds;                 // 1=long rubble (There is no default)
  string noise1;                // Starting sound (def = empty sound)
  string noise2;                // Finishing sound (def = empty sound)
misc_spark                      // Produces a burst of sparks at random intervals
  spawnflags BLUE = 2;          // sparks are blue in colour (def=yellow)
  spawnflags PALE = 4;          // sparks are pale yellow in colour (def=yellow)
  spawnflags RED = 8;           // sparks are red in colour (def=yellow)
  string target;                // Used to switch a light on/off in sync
                                // The light must start switched off (lights spawnflag=1)
  float wait;                   // time delay between bursts Def=2, spark once=-1
  float cnt;                    // number of sparks in burst (0.5 + random() x 0.5) Def=16
  float angle;                  // direction of sparks to follow, use "360" for 0
  float fixangle;               // 1 = Random Y axis direction of sparks
  float speed;                  // velocity speed of sparks (def=40)
  float height;                 // random velocity modifier (def=+/-20)
  float sounds;                 // 1=sparks, 4=silent, 5=custom
  string noise;                 // custom sound for sparks
misc_targetdummy                // Target practice dummy
  spawnflags KNIGHT = 1;        // Small Knight (small bounding box)
  spawnflags WIZARD = 2;        // Flying Wizard (tall bounding box)
  spawnflags OGRE = 4;          // Large ID ogre (wide bounding box)
  spawnflags HELL_KNIGHT = 8;   // Metallic Hell Knight (tall bounding box)
  spawnflags ZOMBIE = 16;       // Slow Zombie (small bounding box)
  spawnflags DEMON = 32;        // Jumpinh Demon (wide bounding box)
  spawnflags SHALRATH = 64;     // Spider like Shalrath (wide bounding box)
  spawnflags SHAMBLER = 128;    // Furry Shambler (Massive bounding box)
  string noise1;                // Targetnumber tracking weapon used
  string noise2;                // Targetnumber tracking enemy distance
  string noise3;                // Targetnumber tracking damage
  string noise4;                // Targetnumber tracking % efficency
  float wait;                   // Impact marker removal time (def=2)
misc_targetnumber               // Target number to display ingame
  float pos1;                   // X=top, Y=bottom digit quantity
misc_textbook                   // Custom text books for the player to read
  spawnflags NOMODEL = 1;       // Will not use book model + particles
  spawnflags PLINTH1 = 2;       // Setup book on top of plinth1 model
  spawnflags PLINTH2 = 4;       // Setup book on top of plinth2 model
  spawnflags STORY = 8;         // Book is part of a story (use target2)
  spawnflags COLLISION = 16;    // Use bounding box collision for plinth
  spawnflags ANGLEONLY = 32;    // Will only work when standing infront of entity (angle key)
  spawnflags NOEFFECTS = 128;   // No particle or effects active
  string target;                // trigger event when book is opened (only works once)
  string target2;               // name of story controller (only works with spawnflag)
  float angle;                  // facing angle for model or direction player must be standing
  vector v_angle;               // The viewing angle the book is active (def=30,60,0)
  float exactskin;              // skin number for book (1-8, Brown1/2,Green1/2,Blue1/2,Red1/2)
  vector pos1;                  // Touch trigger minimin size (def=-48 -48 -32)
  vector pos2;                  // Touch trigger maximum size (def=48 48 32)
  string message;               // header message
  string message2;              // Body Text 1 (need to add linefeeds)
  string message3;              // Body Text 2 (displayed after message2)
  string message4;              // Body Text 3 (displayed after message3)
misc_textstory                  // Custom text book story chapters
  string targetname;            // Name of current chapter
  string target;                // Name of next chapter
  string message;               // header message
  string message2;              // Body Text 1 (need to add linefeeds)
  string message3;              // Body Text 2 (displayed after message2)
  string message4;              // Body Text 3 (displayed after message3)
misc_textstoryctrl              // Custom text book story controller
  string targetname;            // Name of controller for book story
  string target;                // Name of first chapter

  
New / Updated FUNC entities
------------------------------------------------------------------------------
func_button                     // button bmodel with touch/shoot functions
  spawnflags STARTDIS = 32;     // button starts in disabled entity state
  float sounds;                 // 0=steam metal, 1=wooden, 2=metallic, 3=in-out, 4=Silent, 5=Custom
  string noise;                 // custom sound - open/close
func_door                       // Classic func door
  spawnflags STARTOPEN = 1;     // door opens in reverse state (moved to dest at spawn)
  spawnflags SPAWNTRIG = 2;     // Will spawn trigger around door even if targetname SETUP
  spawnflags DONTLINK = 4;      // Touching doors will not link into a single entity
  spawnflags GOLD = 8;          // Requires gold key to open
  spawnflags SILVER = 16;       // Requires silver key to open
  spawnflags TOGGLE = 32;       // Door waits in start and end states for a trigger
  float speed;                  // Movement speed (default = 100)
  float yaw_speed;              // Alternative closing speed (def speed)
  float wait;                   // Wait before returning (def=3,-1=never)
  float lip;                    // the map units remaining at the end of a move (def=8)
  float health;                 // Can be damaged instead of touched
  float dmg;                    // damage to inflict when blocked (def=2)
  string message;               // centerprint message when touched (removed once opened)
  float sounds;                 // 0=Silent, 1=Stone, 2=Base, 3=Chain, 4=Metal 5=Custom sounds
  float locksounds;             // 0=talktalk, 1=fast rattle, 2=slow rattle, 3=long rattle
  string noise;                 // custom sound - door locked sound (targetname+message)
  string noise1;                // custom sound - Moving/Open door (looping)
  string noise2;                // custom sound - Stop/Close door 
  string noise3;                // custom sound - Silver/Gold key try lock
  string noise4;                // custom sound - Silver/Gold key OPEN 
  float customkey;              // custom key required to open door (1-4 supported values)
  string message2;              // custom key message (You need the custom key) 
func_door_secret                // Two stage movement func_door clone
  spawnflags ONCE_ONLY = 1;     // Stays open (basically wait = -1)
  spawnflags 1ST_LEFT = 2;      // 1st movement is left of movement direction
  spawnflags 1ST_DOWN = 4;      // 1st movement is down
  spawnflags NO_SHOOT = 8;      // Cannot shoot the door to open it
  spawnflags ALWAYS_SHOOT = 16; // Will override any other shoot setting!
  string angles;                // Allow for custom movement angles (Pitch Yaw Roll)
  float speed;                  // Override speed (def 50)
  float yaw_speed;              // 2nd movement speed (default = speed)
  float t_width;                // 1st movement distance to travel
  float t_length;               // 2nd movement distance to travel
  float wait;                   // Override pausing before closing (def 5s)
  float dmg;                    // damage to inflict when blocked (def=2)
  string message;               // centerprint message when touched (removed once opened)
  float sounds;                 // 1=Medieval, 2=Air base, 3=Ind base (def), 4=Silent, 5=Custom
  float locksounds;             // 0=talktalk, 1=fast rattle, 2=slow rattle, 3=long rattle
  string noise;                 // custom sound - door locked sound (targetname+message)
  string noise1;                // custom sound - Open
  string noise2;                // custom sound - Opening (looping)
  string noise3;                // custom sound - Closing
func_bob                        // bmodel that gently moves back and forth
  spawnflags NONSOLID = 4;      // Bmodel is non solid (only func_bob)
  float angle;                  // direction movement, use "360" for angle 0
  float height;                 // direction intensity (def=4)
  float count;                  // direction cycle timer (def=2s, minimum=1s)
  float waitmin;                // Speed up scale (def=1) 1+=non linear
  float waitmin2;               // Slow down scale (def=0.75)
  float delay;                  // Starting time delay (def=0, -1=random)
func_bossgate                   // A NON SOLID bmodel when player has ALL runes
func_episodegate                // SOLID bmodel when player has SELECTED rune(s)
func_illusionary                // A NON SOLID bmodel with texture toggle
  spawnflags AFRAME = 2;        // Start with the A frame animated texture
func_laser                      // A togglable laser, hurts to touch and can block
  spawnflags SOLID = 2;         // will block everything (players/monsters/projectiles)
  spawnflags NODMG = 4;         // touch function does no damage
  string message;               // message to display when activated
  string message2;              // message to display when deactivated
  float waitmin = -1;           // Will display the messages only once
  float sounds;                 // 1=standard laser (def), 4=silent, 5=custom
  string noise1;                // Trigger on sound (everytime turned on)
  string noise2;                // Trigger off sound (everytime turned off)
  float dmg;                    // damage to do on touch. default 1
  float alpha;                  // alpha value will vary +/- 20% (def=0.5)
  float spr_frame;              // 1=Yellow, 2=Green, 4=Red, 8=Blue, 16=Purple, 32=Fire, 64=White
  float angle;                  // Direction of particles to move (def=-2 down)
  float part_limit;             // Maximum active quantity of particles (def=25)
  float part_life;              // Lifetime of particle (def=2s)
  vector part_velrand;          // Random movement of particles (def='4 4 4')
  vector part_vol;              // Size of area to spawn particles in (def=bmodel)
  float wakeup_dist;            // Distance to wakeup particle emitter (def=768)
  float spawn_base;             // Minimum time frame to spawn particles (def=0.1s)
  float spawn_rand;             // Random time amount to add to spawning times (def=0.1s)
func_plat                       // platform that starts low and travels upwards
  spawnflags MIN_TRIGGER = 4;   // Uses the min bounding box (instead of max) to calculate trigger
  spawnflags START_LOWER = 8;   // Will start the platform lower regardless of targetname
  spawnflags START_OPEN = 16;   // Used for lighting issues, place at bottom position
  spawnflags STARTDIS = 32;     // platform starts in disabled entity state
  float sounds;                 // 1=Base, 2=Medieval (def), 4=Silent, 5=Custom sounds
  string noise;                 // custom sound - moving (looping)
  string noise1;                // custom sound - Stopped
func_skill                      // Bmodel that changes based on current skill level
  spawnflags STARTOPEN = 1;     // Start in pos2 and await trigger (like func_door)
  float style;                  // 0 = easy, 1 = normal, 2 = hard, 3 = nightmare
  string message2;              // Override message when bmodel is touched/damaged
  string target;                // Particle emitters to switch on/off
  string target2;               // target(s) to fire when touched/damaged
  float health = 1;             // Can be damaged instead of touched
  float angle;                  // movement direction for trigger event
  float speed;                  // movement speed (100 default)
  float lip;                    // lip remaining at end of move (8 default)
  string noise1;                // Custom sound - Stop moving (doors/drclos4.wav)
  string noise2;                // Custom sound - Start/Loop moving (doors/stndr1.wav)
  string noise3;                // Custom sound - Touching (plats/medplat2.wav)
func_wall                       // A SOLID bmodel with toggled animated texture
  spawnflags AFRAME = 2;        // Start with the A frame animated texture
  spawnflags MODCHECK = 16;     // Will remove this entity if THIS mod is active


New / Updated TRIGGER entities
------------------------------------------------------------------------------
trigger_count                   // A counter which triggers target(s) when complete
  string message2;              // message to display when complete (ignores NOMESSAGE spawnflag)
  float delay;                  // time delay to fire final trigger event
  float sounds;                 // 0=silent,1=Secret,2=talk,3=switch,5=custom,6=secret2
  string noise;                 // custom sound to play when complete
trigger_explode                 // Triggered once entity producing damage + sprite explosion
  float dmg;                    // explosive radius damage (def=40, -1=no damage)
  float delay;                  // time delay to explosion
trigger_fog                     // Change global fog to new value over time
  float speed;                  // time (secs) to fade from current to new (-1 = instant)
  float wait;                   // re-trigger time (-1 = trigger once)
  float fog_density;            // new fog density (def=0.5, -1=debug mode)
  float fog_colour;             // new fog colours (def=0.1 0.1 0.1)
trigger_heal                    // Healing pool/trigger function
  spawnflags BUBBLES = 2;       // Spawn bubbles within trigger volume when active
  string target;                // trigger once when players stands in trigger (start cycle)
  string target2;               // trigger once when healing expires (finish cycle)
  float wait;                   // Time between healing (default 1s)
  float healamount;             // Quantity to heal each time touched (default 10)
  float max_health;             // Total amount to heal (default 50, -1=no limit)
  float sounds;                 // 1=heal_15, 2=heal_25, 3=heal_100, 4=respawn, 5=custom (default 1)
  string noise;                 // custom sound override
  string message;               // centerprints to show when touching trigger
  float lip;                    // All messages are silent to the player (heal/expire) 1=block heal 2=block all
  string message;               // centerprints when players stands in trigger
  string message2;              // centerprints when healing function has expired
  float count;                  // total amount of active bubbles (default 5)
  float height;                 // Maximum travel distance for bubbles (default trigger size)
  float style;                  // 1-15 (grey, brown1, blue1=default, green1, red1, brown2, pinkyel, brown3, purp1, purp2, brown4, green2, yellow, blue2, red2)
  float yaw_speed;              // spawning rate (def=0.5) for bubbles (speed + random() x speed)
trigger_hurt                    // Will hurt any touching entity
  spawnflags BUBBLES = 2;       // Spawn bubbles within trigger volume when active
  spawnflags MONSTER_ONLY = 4;  // Will only affect monsters
  spawnflags MODCHECK = 16;     // Will remove this entity if THIS mod is active
  float dmg;                    // damage from contact with trigger (def=5)
  float wait;                   // time between pain contact (def=1s)
  float angle;                  // Facing Direction for trigger to work, use "360" for angle 0
  float count;                  // total amount of active bubbles (default 5)
  float height;                 // Maximum travel distance for bubbles (default trigger size)
  float style;                  // 1-15 (grey, brown1, blue1=default, green1, red1, brown2, pinkyel, brown3, purp1, purp2, brown4, green2, yellow, blue2, red2)
  float yaw_speed;              // spawning rate (def=0.5) for bubbles (speed + random() x speed)
trigger_clientmsg               // Centerprints a message to all clients
  float sounds;                 // 1=Secret,2=talk,3=switch,4=silent(def),5=custom,6=secret2
  string noise;                 // Custom sound to play when triggered
  string message;               // Message to display when triggered
trigger_itemrespawnupd          // Change the state of respawn flag on items
  spawnflags RESPAWN = 16;      // Value of respawn flag to copy to item
trigger_ladder                  // Brush based ladder (jump key to climb)
  float angle;                  // facing direction to use ladder (def = 360)
  float waitmin;                // time between climb sounds (def=material)
  float speed;                  // velocity speed to climb ladder (def=160)
  float sounds;                 // 1=metal, 2=wood, 3=rope, 4=silent, 5=custom (def=wood)
  string noise1-4;              // custom sounds to play when climbing
trigger_monsterattack           // Force a monster to attack another monster
  string target;                // Name of monster to affect
  string target2;               // Name of entity to attack
trigger_monsterjump             // Push monsters in a certain direction
  spawnflags FLYING = 2;        // Will affect flying monsters
  spawnflags SWIMMING = 4;      // Will affect swimming monsters
  string target;                // targeting entity used for custom direction
  float wait = -1;              // Only trigger a monster jump once
  float angle;                  // direction of push (-2 is down, -1 up)
  float speed;                  // the speed thrown forward (def 200)
  float height;                 // the speed thrown upwards (def 200)
  string noise1;                // Only works with this type of monster (monster_ogre)
trigger_drolejump               // Special jump trigger for enraged droles
  float wait = -1;              // Switch off trigger after being used once
  string target;                // Trigger additional targets (trigger once)
trigger_nomonjump               // Stop monsters from using jump attack
  float wait = -1;              // Switch off trigger after being used once
  float delay = 0.5s;           // Amount of time to delay jump attack by
  float waitmin = 0.1s;         // Re-trigger timer to stop touch flooding
  string target;                // Trigger additional targets (trigger once)
  string noise1;                // Only works with this type of monster (monster_ogre)
trigger_monsterkill             // Will safely kill/remove monsters from maps
  spawnflags DEATH = 16;        // Use monster death function instead of removing
  string target;                // Pointing to single/group of monsters
trigger_monsterturret           // Temporarily turn a monster into a turret
  string target;                // When used, trigger additional events, only trigger once
  float wait = -1;              // trigger only works once
  float count;                  // Random chance to pause; constant = -1, def = 0.25, range = 0 - 1
  string noise1;                // Only works with this type of monster (monster_ogre)
trigger_monstermovespeed        // Change the movement speed of monsters
  string target;                // Points to the monster(s) to change
  float state;                  // -1=No movement, 0=Toggle, 1=Free movement
  float wait = -1;              // trigger only works once
trigger_multiple                // Variable sized bmodel used once
  spawnflags NOTOUCH = 1;       // can only be triggered via other entities
  spawnflags MODCHECK = 16;     // Will remove this entity if THIS mod is active
  spawnflags MONSTERS = 32;     // Can be touched/triggered by monsters
  float upgrade_axe = 1;        // Only trigger if player has got upgrade Axe
  float upgrade_ssg = 1;        // Only trigger if player has got upgrade Shotgun
  float upgrade_lg = 1;         // Only trigger if player has got upgrade Lightning Gun
  float health;                 // Can be damaged instead of touched
  float wait;                   // time between re-triggering
  float angle;                  // Facing Direction for trigger to work, use "360" for angle 0
  float sounds;                 // 1=Secret,2=talk(def),3=switch,4=silent,5=custom,6=secret2
  string noise;                 // Custom sound to play when triggered
  string message;               // Message to display when triggered
trigger_once                    // Variable sized bmodel used multiple times
  spawnflags NOTOUCH = 1;       // can only be triggered via other entities
  spawnflags TRIG_INVIEW = 8;   // player has to see trigger (only works on _once)
  spawnflags MODCHECK = 16;     // Will remove this entity if THIS mod is active
  spawnflags MONSTERS = 32;     // Can be touched/triggered by monsters
  float upgrade_axe = 1;        // Only trigger if player has got upgrade Axe
  float upgrade_ssg = 1;        // Only trigger if player has got upgrade Shotgun
  float upgrade_lg = 1;         // Only trigger if player has got upgrade Lightning Gun
  float health;                 // Can be damaged instead of touched
  float angle;                  // Facing Direction for trigger to work, use "360" for angle 0
  float wait;                   // Always set to -1, its trigger_once!
  float sounds;                 // 1=Secret,2=talk(def),3=switch,4=silent,5=custom,6=secret2
  string noise;                 // Custom sound to play when triggered
  string message;               // Message to display when triggered
  float t_length;               // Activation radius for inview triggers
trigger_push                    // Pushes the player and Grenades!
  spawnflags PUSH_ONCE = 1;     // Removes itself after firing once
  spawnflags SILENT = 2;        // No wind sound for player
  spawnflags NOMONSTERS = 4;    // Monsters cannot be pushed by this trigger
  string target;                // targetting entity used for custom direction
  float angle;                  // direction of push (-2 is down, -1 up)
  float angles;                 // Pitch Yaw Roll (up/down, angle, tilt left/right)
  float speed;                  // Speed of push direction (def=1000)
trigger_relay                   // Triggers target(s) with custom sounds and messages
  spawnflags RANDOM = 2;        // Will randomly select between target/target2
  float cnt;                    // Random amount of time to add to delay
  float wait = -1;              // Will only fire targets once
  float waitmin = 0.0-1.0;      // % random chance between target/target2
  float sounds;                 // 1=Secret,2=talk(def),3=switch,4=silent,5=custom,6=secret2
  string noise;                 // custom sound to play when triggered
  string message;               // message to display when triggered
trigger_secret                  // Updates map secrets found counter
  spawnflags NOTOUCH = 1;       // can only be triggered via other entities
  spawnflags NOMSG = 2;         // Remove/Block any trigger secret message
  float health;                 // Can be damaged instead of touched
  float angle;                  // Facing Direction for trigger to work, use "360" for angle 0
  float sounds;                 // 1=Secret(def),2=talk,3=switch,4=silent,5=custom,6=secret2
  string noise;                 // custom sound to play when triggered
  string message;               // message to display when triggered
trigger_setskill                // Sets player skill level (via console)
  spawnflags NOTOUCH = 1;       // can only be triggered via other entities
  float health;                 // Can be damaged instead of touched
  float wait = -1;              // Switch off trigger after being touched once
  float angle;                  // Facing Direction for trigger to work, use "360" for angle 0
  string message;               // Skill Level - 0=easy, 1=normal, 2=hard, 3=nightmare
trigger_touchsound              // Plays sounds when touched by the player
  spawnflags WORLDGEO = 8;      // Will draw bmodel (not just a trigger)
  spawnflags DRAIN = 16;        // Drain effect when trigger_disabled
  float sounds;                 // 1=Water (def) 2=Slime 3=Lava 4=silent 5=custom
  string noise;                 // Custom sound for touch/enter trigger
  string noise1;                // Custom sound for leave/exit of trigger
  string noise2;                // Custom sound for draining of liquid
  float speed;                  // Time taken to drain liquid (def=1.5)
  float yaw_speed;              // Vertical drain speed (def=0.05)
  float super_time;             // Time delay playing drain sound (def=0.1s)
  float water_alpha;            // alpha value for liquid (override worldspawn)
trigger_teleport                // Teleport player/monsters to target location
  spawnflags PLAYER_ONLY = 1;   // Can only be used by players (nothing else)
  spawnflags SILENT = 2;        // No teleporter hum sound regardless of state
  spawnflags STARTON = 4;       // Will start active regardless of targetname setting
  string target;                // Points to info_teleport_destination entity
  float wait = -1;              // Switch off trigger after being touched once
  float speed;                  // forward momentum speed after teleporting (def=300)
  float volume;                 // teleporter hum sound volume (def=0.5)
  string noise;                 // custom sound to play when active (must be looped, def=hum1.wav)
  float waitmin;                // length of the custom sound (def=3.622 for hum1.wav)
trigger_void                    // Garbage collector for bottom of skyboxes
  spawnflags NO_CLIENT = 1;     // Ignore clients (anything flagged as a client)
  spawnflags NO_MONSTER = 2;    // Ignore monsters (anything flagged as a monster)
  spawnflags NO_AMMO = 4;       // Ignore ammo types (all ammo projectile types)
  spawnflags NO_EGG = 8;        // Ignore minion eggs (affects shalrath, wraiths)
  spawnflags NO_TEMP = 16;      // Ignore temporary ents (gibs, sparks, smoke)
  spawnflags NO_ITEM = 32;      // Ignore items (weapons,armor,keys,runes,powerups)
 
 
 Switchable light entities (state can be toggled via triggers)
 + Need new compiler for the style key to be linked to the light model entity
------------------------------------------------------------------------------
spawnflags LIGHTOFF = 1;        // Starts off and waits for trigger
spawnflags NO_SOUND = 2;        // No ambient sound
spawnflags NO_STATIC = 4;       // Will not turn into static entity
spawnflags NO_EFFECTS = 128;    // Will not spawn any particle effects
light_candle                    // Variable size, width candle, place 16 units off ground
  spawnflags SHADOW = 8;        // Turn ON shadows in DP engine
  float angle = 0, 1-360;       // 0=random angle, 1-360=specific
  float height;                 // Height : 1=short, 2=medium, 3=regular, -1=random
  float t_width;                // Width : 1=regular, 2=fat, 3=thin, -1=random
  float lip;                    // Moves model down to ground plane (default = 16)
light                           // Non-displayed light
light_fluoro                    // Makes steady fluorescent humming sound
light_fluorospark               // Makes sparking, broken fluorescent sound
light_globe                     // Sphere globe light (sprite)
light_postlight                 // Light post from Quoth MOD (multiple frames)
light_tubelight                 // Tube light from Quoth MOD
light_fixture1                  // Wall light from Rubicon2 MOD
light_torch_small_walltorch     // Short wall torch
light_flame_small_yellow        // Small yellow flame
light_flame_large_yellow        // Large yellow flame


All items (health, armor, weapons, ammo, keys, sigils, artifacts)
------------------------------------------------------------------------------
spawnflags RESPAWN = 16;        // Can respawn after being picked up
spawnflag FLOATING = 32;        // Spawns floating, trigger entity to drop it
spawnflags STARTOFF = 64;       // Starts off and waits for trigger to spawn
spawnflags NOEFFECTS = 128;     // No particle or effects active on this entity
float upgrade_axe = 1;          // Only spawn if player has got upgrade Axe
float upgrade_ssg = 1;          // Only spawn if player has got upgrade Shotgun
float upgrade_lg = 1;           // Only spawn if player has got upgrade Lightning Gun
float respawn_effect = 1;       // Show particle effect while respawning
float respawn_time;             // Time to wait respawning (=-1 instant spawn)
float respawn_count;            // Total amount of times to respawn an item
float respawn_trig = 1;         // Wait for a trigger event before respawning
float item_flrcheck = 1;        // Check floor below and simulate gravity


Artifacts
------------------------------------------------------------------------------
item_artifact_tomeofpower       // Tome of Power, custom event trigger
  string target;                // Trigger targets to fire when item touched
  string message;               // Centerprint message when item is picked up
  string noise;                 // Custom pickup sound (def=misc/medkey.wav)
item_artifact_nail_piercer      // All nail attacks will travel through monsters
  float cnt;                    // Duration override of artifact (def=30s)
item_artifact_sharp_shooter     // Reduces the bullet spread of all Shotguns
  float cnt;                    // Duration override of artifact (def=30s)
item_artifact_wetsuit           // Can breath underwater for 5mins/300secs
  float exactskin;              // 0=Orginal,1=Green,2=Brown,3=Aqua,4=Blue
  float cnt;                    // Duration override of artifact (def=300s)
item_artifact_envirosuit        // No damage from water or slime for 30 seconds
  float exactskin;              // 0=Orginal,1=Green,2=Brown,3=Aqua,4=Blue
  float cnt;                    // Duration override of artifact (def=30s)
item_artifact_invulnerability   // invulnerable to all damage for 30 seconds
  float cnt;                    // Duration override of artifact (def=30s)
item_artifact_invisibility      // invisible to monsters for 30 seconds
  float cnt;                    // Duration override of artifact (def=30s)
item_artifact_super_damage      // Player does 4x damage with all weapons
  float cnt;                    // Duration override of artifact (def=30s)

  
Ammo Packs
------------------------------------------------------------------------------
spawnflag A_LARGE = 1;          // Double ammo boxes quantity (different model)
spawnflag A_LID = 2;            // Shells and Spikes have lids (matching rotation)
float angle = 0 or -1;          // Random rotation everytime spawned
float angle = 1-359;            // Specific rotation (lid/frame always match)
float skin_override = 1-2;      // Override world type 1=Base Green, 2=Medieval Wood
float frame_box = 1-7;          // Special frames for rockets, plasma boxes and lids


New Weapons & Items
------------------------------------------------------------------------------
weapon_upgrade_axe              // Give the player the new Shadow Axe
weapon_upgrade_ssg              // Give the player the new Widowmaker Shotgun
weapon_upgrade_lg               // Give the player the new Plasma Gun
weapon_shotgun                  // Give the player the single barrel Shotgun
item_backpack                   // Backpack with random/exact amount of ammo
  spawnflags SHELLS;            // ammo for SG / SSG / RG
  spawnflags NAILS;             // ammo for NG / SNG
  spawnflags ROCKETS;           // ammo for GL / RL
  spawnflags CELLS;             // ammo for LG
  float count;                  // random amount of ammo to give (works with spawnflags)
  float ammo_shells;            // exact amount of shells
  float ammo_nails;             // exact amount of spikes
  float ammo_rockets;           // exact amount of rockets
  float ammo_cells;             // exact amount of cells
  float armorvalue;             // armor shards (gives green armor if none present)
  float armortype = 1;          // random amount of armor shards (uses count)
  float exactskin;              // 0=Original, 1=green, 2=blue, 3=red, 4=yellow, 5=swamp, 6=white, 7=pale
item_keyx                       // Custom key for opening func_door bmodels
  spawnflags CKEY1 = 1;         // Key type 1, each key can only be one type
  spawnflags CKEY1 = 2;         // Key type 2, this can be any model, not just keys
  spawnflags CKEY1 = 4;         // Key type 3
  spawnflags CKEY1 = 8;         // Key type 4
  string mdl;                   // model name to load/display (progs/model.mdl)
  float skin;                   // Skin number for custom model
  string netname;               // XXX Part of pickup string (You got the XXX)
  string message2;              // Particle colours (KEYSILVER, KEYGOLD, KEYRED, KEYGREEN, KEYPURPLE, KEYWHITE)
item_custom                     // Custom Pickup Item
  string mdl;                   // model name to load/display (progs/model.mdl)
  float skin;                   // Skin number for custom model
  string netname;               // XXX Part of pickup string (You got the XXX)
  string noise;                 // Pickup sound (def=weapons/lock4.wav)
  string pos1;                  // Pickup bounding box minimum (def=-16 -16 -24)
  string pos2;                  // Pickup bounding box maximum (def=16 16 32)
  float bodyfadeaway;           // Model will fade away on pickup
  float part_active;            // = 1 Enable particle burst on pickup
  string part_ofs;              // Particle Origin Offset (def='0 0 0')
  float part_tcount;            // Particle Quantity (def=20)
  float part_life;              // Particle Life Time (def=2s)
  float part_style;             // 1=yellow, 2=green, 3=red, 4=blue, 5=purple, 6=fire, 7=white
  float part_movetype;          // 2=center, 3=up, 4=shockwave, 5=skull, 6=lost, 7=minotaur


New Ambient Sound entities
------------------------------------------------------------------------------
ambient_custom_sound            // Play a sound on a periodic basis
  spawnflags PLAYONCE = 2;      // When triggered plays once
  float volume;                 // volume of sound (default 1, capped at 1)
  string target;                // Sound Triggers (fires everytime sound played)
  string noise;                 // Sound Primary (ambience/windgust1a.wav)
  string noise1;                // Sound Stop (ambience/switch6_off.wav)
  string noise2;                // Sound Random (ambience/windgust1b.wav)
  float wait;                   // random time between sounds (default 20; =-1 no random element)
  float delay;                  // minimum time between sounds (default 2)
  float waitmin;                // Starting time (waitmin + random() x waitmin; =-1 no delay)
  float waitmin2;               // Will not silence any playing sound if switching off
  float impulse;                // channel on which to play sound (0-7) (0 automatic is default)
  float speed;                  // attenuation -1=no attenuation, 1=normal (default), 2=idle, 3=static, 4=quiet
ambient_custom_loop             // Custom ambient (must be looped) sound
  float volume;                 // volume of sound (default 1, capped at 1)
  string noise;                 // custom sound to play (looped)


Ritual / Hipnotic Rotation entities (as is, no changes)
------------------------------------------------------------------------------
rotate_object                   // Defines a bmodel object to be rotated
info_rotate                     // center point for rotatable objects
func_rotate_entity              // Basic rotating object
  spawnflags TOGGLE = 1;        // allows the rotation to be toggled on/off
  spawnflags STARTON = 2;       // whether the entity is spinning when spawned
  string target;                // points to center of rotation entity
  float rotate;                 // The rate of rotation in degrees
  float speed;                  // time taken to go from zero to full speed and vice-versa.
path_rotate                     // Corner Path for rotate_train
  spawnflags ROTATION = 1;      // Rotate train at rate specified by 'rotate'
  spawnflags ANGLES = 2;        // Rotate to the angles specified by 'angles'
  spawnflags STOP = 4;          // stop train and wait to be retriggered
  spawnflags NO_ROTATE = 8;     // stop train rotating when waiting to be triggered
  spawnflag DAMAGE = 16;        // Cause damage based on 'dmg'
  spawnflags MOVETIME = 32;     // Interpret 'speed' as the length of time to take moving
  spawnflags SET_DAMAGE = 64;   // Set all targets damage to 'dmg'
  string event;                 // trigger when train arrives at path_rotate      
  string noise;                 // sound to play when train stops
  string noise1;                // sound to play when train moves
  float speed;                  // new speed of the train after it reaches corner
func_rotate_train               // moving platforms that players can ride
  string path;                  // Starts at'path_rotate' position
  float speed;                  // travel speed (def=100)
  float dmg;                    // blocking damage (def=0)
  float sounds;                 // 0=Silent 1=ratchet metal
  string noise;                 // sound to play when train stops
  string noise1;                // sound to play when train moves
func_movewall                   // Emulate collision on rotating objects
  spawnflags VISIBLE = 1;       // Causes brush to be displayed
  spawnflags TOUCH = 2;         // Cause damage when touched by player
  spawnflags NONBLOCKING = 4;   // makes the brush non-solid,  This is useless if VISIBLE is set
  float dmg;                    // damage to cause when touched or blocked
func_rotate_door                // Rotating door moving around a point of rotation
  string target;                // Points to the rotate_object bmodel entity
  string target2;               // Move on spawn to this entity (info_rotate) location
  spawnflags STAYOPEN = 1;      // Reopen after closing, stops a once only door from closing if blocked
  float dmg;                    // Damage caused when blocked (def=2)
  float speed;                  // Time taken to rotate open/close
  float sounds;                 // 1=medieval 2=metal 3=base 4=Silent (def=1)


==============================================================================
Entity State System
-------------------

When Quake first came out there were strict limitations on how many entities
could exist and be active at the same time. The quick fix solution to this
problem was to use the killtarget key so that entities could be removed. 
This was a very powerful feature with very few restrictions on what it 
could affect or destroy at the same time.

The idea of the entity state system is to create a way to safely switch
entities on, off or have then temporarily disabled. This will help prevent
situations where entity chains are broken or strange errors occur because
the touch function does not have an entity anymore.

There are two ways to change the state of any entity as follows:

Method 1
--------
Add an extra key on triggering entities (_once, _multi, _relay etc) 

------------------------------------------------------------------------------
float estate_trigger;           // new entity key command
  = 1;                          // Switch ON  -Added to world
  = 2;                          // Switch OFF -Removed from world
  = 4;                          // Disabled   -blocks entity functionality
  = 8;                          // Reset      -reset back to spawn state
  = 16;                         // Aframe     -change aframe state

The ON state (default) will allow the entity to work as designed, be
toggled and physically exist as per its setup.

The OFF state will block all of the designed functionality and hide 
the entity from interaction with the world/player.

The DISABLE state blocks any toggle ability or entity functionality
and turns off any visual aids like animated textures.

The RESET state will revert the entity back to the state it was in when
starting the map. There are exceptions, it does not work on every entity.
  
The AFRAME state will allow certain entities to change to exact frame
states. This is only supported on a few entity types at the moment.
  
Method 2
--------
Use one of the new triggering entities listed below:
  
------------------------------------------------------------------------------
trigger_entitystate_on          // Switch the target(s) ON
trigger_entitystate_off         // Switch the target(s) OFF
trigger_entitystate_disable     // DISABLE the target(s)
trigger_entitystate_reset       // RESET the target(s)
trigger_entitystate_aframe      // Change AFRAME of target(s)

These new entities will affect multiple targets and are designed to show
(visually) what is happening in the editor by using target lines. They
work/setup very much like a trigger_relay in the editor.


==============================================================================
Starting Point, do you remember me!?!
-------------------------------------

Quake starts in a hub style map with various skill selection portals
and several episodes gates which the player can complete in any order.
Once all of the episodes are completed a final area is unlocked and the
player can beat the final boss and complete the game.

When the player starts the game they begin at the 'info_player_start'
spawn location and once the player has some rune(s) they return to the 
start map using the 'info_player_start2' entity instead.

The start2 system always returns the 'trigger_changelevel' portals to the
same location in the start map. To allow the creation of more detailed
start map layouts there can now be up to seven 'info_player_start2'
locations in the start map which are all linked to different returning
changelevel triggers.

By adding the new key 'startspawn2' to a 'trigger_changelevel' entity
with a unique number (1-7) and then adding the same key and number to an
'info_player_start2' entity in the returning map, the player will start
at the new location instead of the default one.

When the new key 'startspawn2' is used there is no rune check done
anymore and the player will spawn in the next or returning map at a
'info_player_start2' location, the default number is one.

With the ability to create hub maps with multiple returning points there
is now a new 'trigger_rune' entity which can be used to test the players
inventory for runes and trigger different events. This is a touch
trigger unlike the func_episode/boss triggers which only happen at the
beginning when the map is loaded.

All player spawn entities will fire any 'target' triggers when used as a
starting location, this can help fine tune locations ready for the player.

When the end intermission screen is active showing map totals for monsters
killed and secrets found, the intermission camera can cycled around multiple
'info_intermission' locations. When the player looks through these extra
cameras any target keys found are triggered.

------------------------------------------------------------------------------
info_player_start               // Starting point for players without runes
  string target;                // triggered target(s) when used as a client destination
info_player_start2              // Starting point for players with runes or startspawn2 system
  string target;                // triggered target(s) when used as a client destination
  float startspawn2;            // Unique spawn location number matching a trigger_changelevel

info_player_coop2               // Starting position for coop games
  string target;                // triggered target(s) when used as a client destination
  float startspawn2;            // Unique spawn location number matching a trigger_changelevel
info_player_deathmatch          // Starting position for deathmatch games
  string target;                // triggered target(s) when used as a client destination
info_stuffcmd                   // Puts specified message into the console
  string message;               // Command eg "r_wateralpha 0.3"
info_teleport_destination       // Destination for trigger_teleport bmodels
  string targetname;            // triggered target(s) when used as a client destination
  string target;                // fires when the entities is used as a destination
info_intermission               // camera point for the intermission
  string target;                // triggered target(s) when used as a viewing camera
  float fog_density;            // Fog density (Must be >0 to activate feature)
  string fog_colour;            // Fog colours (def=0.1 0.1 0.1)
  float speed;                  // Fog time to change (def=2s)

trigger_changelevel             // End of level trigger to change/reload map
  spawnflags NO_INTERMIS = 1;   // No Intermission screen, load next map without pause
  spawnflags RESETINV = 2;      // Reset player inventory to default (Shotgun+Shells)
  string target;                // name of target(s) to trigger before intermission
  string map;                   // The name of next map (e.g. e1m1) "" == same map
  float startspawn2;            // Special unique number (1-7) which must match info_player_start2
trigger_rune                    // Triggers when the player has certain runes
  spawnflags E1 = 1;            // Player has Rune 1
  spawnflags E2 = 2;            // Player has Rune 2
  spawnflags E3 = 4;            // Player has Rune 3
  spawnflags E4 = 8;            // Player has Rune 4
  float health;                 // Can be damaged instead of touched
  float angle;                  // Facing Direction for trigger to work
  string target;                // trigger to fire if player has SOME runes
  string noise1;                // trigger to fire if player has Rune 1
  string noise2;                // trigger to fire if player has Rune 2
  string noise3;                // trigger to fire if player has Rune 3
  string noise4;                // trigger to fire if player has Rune 4


==============================================================================
Trains, Chains and Corners
--------------------------

There are many good examples of trains in the original ID maps with some
notable ones being the opening sequence of the Demon door in E1M2 and the
long wandering platforms in E3M4. These are classics because they show the
player that the environment can be more than just doors or buttons and with
a clever use of path corners, things can flow in multiple directions.

The original func_train entity has limited options (start on/off), it was
designed to follow a chain of path corners in loops or pause and stop at
various corners via different wait states.

This MOD has changed the func_train entity so that it can switch paths, 
speed up or slow down, pause at corners, go backwards or forward and
even be invisible! All these extra options are split across both train 
and corner entities with some being used by monsters.

A func_train entity starts as a collection of brushes in the editor which
eventually become a bmodel located at position 0,0,0 and its origin is an
offset of what movement has happened since spawning. Bmodels have collision
on the edges of their bounding boxes and are often used as crushers because
they have no roll back condition.

The new func_trains can be setup with no collision or even have the bmodel
replaced with a model instead! Once the spawnflag MODEL is enabled the train
will default to an empty model (invisible) unless the 'mdl' key is defined. 
This can be useful for the new trap shooters entities because they can now
track moving targets like trains.

The original train entity had restrictions (start on/off) based on the
setting of the 'targetname' key and this has been removed with a new 
spawnflag. The final addition is a new spawnflag to make trains start 
backwards through their entity chains instead of forward.

------------------------------------------------------------------------------
func_train                      // Moving bmodels, always start on 2nd frame
  spawnflags STARTON = 1;       // Start moving straight away if targetname is used
  spawnflags NONSOLID = 2;      // No collision or blocking functionality (uses bmodel)
  spawnflags MODEL = 4;         // Model with no collision (use mdl key, def=empty model)
  spawnflags TOUCH = 8;         // Nonsolid or model trains have touch damage (dmg)
  spawnflags REVERSE = 32;      // Start going backward through path_corner chain
  string target;                // Name of first path_corner to start at (instant move)
  string mdl;                   // Specify a model for MODEL mode only (progs/object.mdl)
  float speed;                  // moving speed (def=100)
  float dmg;                    // block damage (def=2)
  float sounds;                 // 0=Silent, 1=Train, 5=Custom sounds
  string noise;                 // custom sound - stopped
  string noise1;                // custom sound - moving (looping)

The real power behind the new func_train entity comes from the new options
available on the path corners and dynamically via triggering entities.
Essentially trains have options for appearance and movement, while the path
corners have options for routes, speed and direction.

* The new functionality of path_corners is designed to work with func_train
entities and most of the new feaures will not work with monsters.

Path corners are usually setup with a 'targetname' and 'target' key which are
linked together with other corners into a large single loop. To create route
variety an alternative route key 'target2' has been added and depending on
which route logic mode is active can be picked randomly or exactly.

As a general rule if a path corner DOES NOT have a second alternative 
'target2' key route defined then there is NO ROUTING LOGIC active. The path
corner is just forward or backward routes dictated by direction flow.

The default route logic mode is RANDOM and when a second route is defined
the train or monster will randomly pick between 'target' and 'target2' keys.
When the train is moving backwards the RANDOM logic mode excludes the current
path direction first and then randomly picks from the remaining two. 

The second route logic mode is EXACT and initially setup via a spawnflag
option. When a train or monster arrives at an EXACT route path corner
they are sent (no choice) in the currently selected route. This mode will
even send a train back the way it came if selected and always change the
direction flow to suit the route taken.

All links backward are automatically generated when the path corners are
spawned. If this process has picking the wrong target (check dev arrows) then
the backward link can be overridden with the 'targetback' key.

The downside to path corner networks is that they do not change, they
are static and cannot be affected by the players actions. Several new keys
have been added that when setup on firing triggers that target path corners
will change internal settings.

The key 'corner_route' will change the path corner to either RANDOM or EXACT
routing logic or a specific route number, as long as the route exists.

The route number on a path corner can either be changed with the new 
'corner_route' key or when the EXACT mode is active and a trigger is fired
at the corner, it will cycle around between the routes. 

The key 'corner_switch' will change the direction of a path corner to
forward or backward routing or toggle the current value. This will affect
any train using this corner and reverse its direction.

The key 'corner_pause' will change the NOPAUSE spawnflag and 'wait' key
to instruct any train to either stop or continue on. The new key supports 
exact values (on/off) or toggles the current state.

The key 'corner_speed' will change the speed on the target path_corner
so that trains can be made to move slower or faster when leaving the
path_corner. Speed value must be greater than 0, default = 100.

The key 'corner_event' is only active on the path corner and acts like
a typical 'target' key on any entity which will trigger target(s) when
any func_train entity is at the path corner.

The 'state' key only works when EXACT logic routing is active and will
setup an initial value for which route is selected.

------------------------------------------------------------------------------
path_corner                     // Node based path routing system
  spawnflags EXACT = 1;         // Exact route logic (def=random route choices)
  spawnflags INSTANT = 2;       // Move instantly to this corner if next destination
  spawnflags REVERSE = 4;       // Train direction is reversed for next corner
  spawnflags NOPAUSE = 8;       // Train does not pause on this path corner
  string corner_event;          // Name of target(s) to trigger when used/touched
  float corner_route;           // Change path_corner route (1-3 routes, 4=exact, 5=random)
  float corner_switch;          // Change spawnflags REVERSE (-1=NO, 1=YES, 2=Toggle)
  float corner_pause;           // Change spawnflags NOPAUSE (-1=NO, 1=YES, 2=Toggle)
  float corner_speed;           // Change the speed on the path_corner for trains
  float state;                  // Starting route (1=forward, 2=alt forward, 3=backward)
  string target;                // Targetname of FORWARD route
  string target2;               // Alternative FORWARD route
  string targetback;            // Override default BACKWARD route
  float wait;                   // fixed amount of time to pause at corner (=-1 stop)
  float delay;                  // random amount of time to pause at corner
  float alpha;                  // Override default for visual arrows (def=0.35)
  float speed;                  // Override default speed of func_train (def=100)

With all the new options, extra routes and dynamically changing parameters it
is difficult to see what is going on with a path corner network. To help with
this problem when path corners are spawned and developer mode is active, a set
of coloured arrows will be drawn showing status, routes and any errors.

All forward and backward routes will be displayed in yellow, any secondary 
routes 'target2' will be shown in green and currently selected exact logic
routes are displayed in white. All errors are shown in red.

A path corner with a missing 'target' key or a broken back link will be shown
with a red arrow pointing upwards. These path corners are labelled as DEADENDS
and anything arriving at them will be turned around automatically.

The helper arrows on path corners is only displayed when developer mode is
active and can be switched on/off with an impulse command. Check the quake.rc
file for full details of mod commands.

  
==============================================================================
Traps, Tricks and Tips
----------------------

It is hard to image Quake without some kind of trap, whether it be a spike
shooter hidden on the ceiling or a large pit of lava waiting for one wrong step!
There should be something lurking around a corner, high above the player or
just below waiting to kill the unobservant player.

Here is a list of all trap related entities added/updated to the MOD
------------------------------------------------------------------------------
trap_grenadeshooter             // fires a GRENADE in the direction determined by angle
  spawnflags LARGE = 1;         // shoots high damage grenade (Player damage, def=ogre)
  spawnflags TOGGLE = 32;       // Trigger will toggle the shooter on/off instead
  spawnflags TRACK = 128;       // Will update target entity origin before firing
  string targetname;            // toggle state (use trigger ent for exact state)
  string target;                // targeting entity used for custom direction
  float angle;                  // direction for projectile to follow
  float wait;                   // time between projectiles (def=1s)
  float delay;                  // random time between projectile (def=0s)
  float speed;                  // speed (def/sng=500, laser=600, wiz=500, hell=300)
trap_lightningshooter           // fires a LIGHTNING in the direction determined by angle
  spawnflags LARGE = 1;         // Cthton Boss Lightning (double damage)
  spawnflags TOGGLE = 32;       // Trigger will toggle the shooter on/off instead
  spawnflags TRACK = 128;       // Will update target entity origin before firing
  string targetname;            // toggle state (use trigger ent for exact state)
  string target;                // targeting entity used for custom direction
  float wait;                   // time between projectiles (def=1s)
  float delay;                  // random time between projectile (def=0s)
  float dmg;                    // Damage from lightning strike (def=15, large=30)
  vector pos1;                  // Random XYZ wobble to source position
  vector pos2;                  // Random XYZ wobble to target position
trap_rocketshooter              // fires a ROCKET in the direction determined by angle
  spawnflags LAVABALL = 1;      // shoots Chthon lava ball (Player damage)
  spawnflags FIREBALL = 2;      // shoots Gargoyle fire ball (low damage)
  spawnflags JIM = 4;           // shoots Jim flyer rocket (low damage)
  spawnflags TOGGLE = 32;       // Trigger will toggle the shooter on/off instead
  spawnflags TRACK = 128;       // Will update target entity origin before firing
  string targetname;            // toggle state (use trigger ent for exact state)
  string target;                // targeting entity used for custom direction
  float angle;                  // direction for projectile to follow
  float wait;                   // time between projectiles (def=1s)
  float delay;                  // random time between projectile (def=0s)
  float speed;                  // speed (def/sng=500, laser=600, wiz=500, hell=300)
trap_spikeshooter               // fires a SPIKE in the direction determined by angle
  spawnflags SNG = 1;           // shoots large spike (SNG damage)
  spawnflags LASER = 2;         // shoots laser (Enforcer damage)
  spawnflags WIZARD = 4;        // shoots acid spike (Wizard damage)
  spawnflags HELLK = 8;         // shoots fire spike (Hell Knight damage)
  spawnflags TOGGLE = 32;       // Trigger will toggle the shooter on/off instead
  spawnflags TRACK = 128;       // Will update target entity origin before firing
  string target;                // targeting entity used for custom direction
  float angle;                  // direction for projectile to follow
  float wait;                   // time between projectiles (def=1s)
  float delay;                  // random time between projectile (def=0s)
  float speed;                  // speed (def/sng=500, laser=600, wiz=500, hell=300)
trap_gasshooter                 // Fires a stream of dangerous particles
  spawnflags STEAM = 1;         // White hot clouds of steam (default)
  spawnflags FIRE = 2;          // Will add burning debuff to player
  spawnflags POISON = 4;        // Will add poison debuff to player
  spawnflags SILENT = 16;       // Stream is silent, no loop/off sounds
  spawnflags TOGGLE = 32;       // Trigger will toggle the shooter on/off instead
  spawnflags TRACK = 128;       // Will update target entity origin before firing
  string target;                // targeting entity used for custom direction
  float angle;                  // direction of streaming particles
  float wait;                   // time between particles (def=0.05s)
  float waitmin;                // auto switch off timer (def=0.5s)
  float speed;                  // velocity speed (def=200)
  float dmg;                    // damage from contact with particles (def=1)
trap_pendlong                   // Long (192 units) Pendulum
  spawnflags REVERSE = 1;       // Starts at frame 12 instead 0
  spawnflags ONESWING = 2;      // Will do a single swing (back + forth)
  float dmg;                    // Damage to do for each contact, def=5
  float waitmin;                // Damage throttle to touch function, def=0.5s
  float wait;                   // amount of time (seconds) before starting swinging
trap_pendlongx                  // Long (192 units) Pendulum working on X axis only
  spawnflags REVERSE = 1;       // Starts at frame 12 instead 0
  spawnflags ONESWING = 2;      // Will do a single swing (back + forth)
  float dmg;                    // Damage to do for each contact, def=5
  float waitmin;                // Damage throttle to touch function, def=0.5s
  float wait;                   // amount of time (seconds) before starting swinging
trap_pendshort                  // Short (128 units) Pendulum
  spawnflags REVERSE = 1;       // Starts at frame 12 instead 0
  spawnflags ONESWING = 2;      // Will do a single swing (back + forth)
  float dmg;                    // Damage to do for each contact, def=5
  float waitmin;                // Damage throttle to touch function, def=0.5s
  float wait;                   // amount of time (seconds) before starting swinging
trap_pendlongx                  // Short (128 units) Pendulum working on X axis only
  spawnflags REVERSE = 1;       // Starts at frame 12 instead 0
  spawnflags ONESWING = 2;      // Will do a single swing (back + forth)
  float dmg;                    // Damage to do for each contact, def=5
  float waitmin;                // Damage throttle to touch function, def=0.5s
  float wait;                   // amount of time (seconds) before starting swinging
trap_sawbladex                  // Rotating Saw Blade X Axis only
  string target;                // Name of first path_corner to start at (instant move)
  float speed;                  // Speed to follow path, def=10
  float yaw_speed;              // Rotation speed for Saw Blade (def=180)
  float dmg;                    // Damage to do for each contact, def=4
  float waitmin;                // Damage throttle for ON touch function, def=0.1s
  float height;                 // Damage throttle for OFF touch function, def=1s
  float lip;                    // Deceleration time; def=2s, =-1 instant stop
  float sounds;                 // 0=Silent, 1=Woodmill, 5=Custom sounds
  string noise;                 // Custom sound - stopping, should be short
  string noise1;                // Custom sound - moving (looping)
trap_sawbladey                  // Rotating Saw Blade Y Axis only
  string target;                // Name of first path_corner to start at (instant move)
  float speed;                  // Speed to follow path, def=10
  float yaw_speed;              // Rotation speed for Saw Blade (def=180)
  float dmg;                    // Damage to do for each contact, def=4
  float waitmin;                // Damage throttle for ON touch function, def=0.1s
  float height;                 // Damage throttle for OFF touch function, def=1s
  float lip;                    // Deceleration time; def=2s, =-1 instant stop
  float sounds;                 // 0=Silent, 1=Woodmill, 5=Custom sounds
  string noise;                 // Custom sound - stopping, should be short
  string noise1;                // Custom sound - moving (looping)


==============================================================================
Breakable System
----------------

The breakables system is a way to create interactive environments by opening up
alternative routes, having sudden destructible monster ambushes and encouraging
plenty of rewarding player exploration moments.

func_breakable - is the primary entity of the breakable system
func_breakable_spawner - is a point entity clone of func_breakable
func_breakable_wall - used to fill in the gaps or reveal the details
trigger_monsterbreak - will trigger a breakable and monster together

The breakable system starts with the style key which defines all the defaults
based on material types. Each style has default rubble bmodels, unique 
break/impact sounds, particle effects and different rubble velocity values.

If a different style of breakable is required there are plenty of extra types which
can be specified by the brkobjects key (10-12=rocks, 20-22=woods, 30-32=glass, 
40-42=metals, 50-54=brick) and more will be added over time.

To create your own custom rubble the new bmodels should be setup in sets of 4 
(roughly 8/16/24/32 units in size) and specified with the brkobj1-4 keys.
There are plenty of example map files under the 'maps/brk' directory which
can be re-painted to suit your needs. Always create any custom bmodels in
the map directory so that they can be grouped together with the map files.

It is recommended that all new bmodels be compiled with minimum lighting
using the following command line (tycompiler\light -light 150 %1) The light
value (150) should be changed to suit the location of the breakable.

The breakable system will randomly pick a rubble bmodel from the defined set
and if something is required to be picked more frequently then duplicate the
required bmodel across several of the brkobj keys.

When a breakable is triggered or the health reaches zero the initial bmodel is
removed and any targets are fired. This is to make sure that any broken detail
is present before any rubble is generated. The system will then try 
(up to 4 times) to spawn rubble inside of the original bmodel volume.

When a monster is pursuing the player and finds a breakable in the way they
will try to destroy it using either melee or range attacks. If the breakable
is for scripted events only then add the extra spawnflags noshoot and nomonster
to prevent any unscripted interactions.

When a breakable is damaged and not destroyed the system shows feedback to the 
player with specially coloured particles instead of the default white ones
used for world geometry. All of the default material styles have particle
colours setup and this can be fine tuned with the entity key pos1.

Breakables inside of liquids (underwater) will break apart at the same velocity
as anywhere else in the map and can be fine tuned either by changing the 
velocity keys (brkvelbase, brkveladd) or by changing the gravity (brkgravity)
of rubble so that it falls slower.

The default velocity for the rubble is a directional force and this is based on
the angle of impact or the triggering entity. The angle of velocity can be
changed by moving around the trigger so that the rubble can fall in more visually
impressive ways. The system also supports the angle key on the original bmodel and
this will override any directional force. The angle key set to 1-360 will produce
a flat (XY) velocity, an up direction is like a fountain from the center and a 
downward angle is without any XY movement. Depending on where the player is in 
relation to the breakble when it falls apart, a special angle key setup might 
produce better visual results.

There are plenty of monsters that have jumping abilities and their collision
detection does not always produce perfect results. It is possible to setup
breakables with an extra touch function that will detect jumping monsters and
break apart if a flying monster hits them and the (brktrigjump) key active.

Breakable entity details
------------------------------------------------------------------------------
func_breakable                  // Spawn breakable objects from a volume
  spawnflag START_OFF = 1;      // Will wait for trigger to spawn
  spawnflag NOSHOOT = 2;        // Cannot be damaged or shot, trigger only
  spawnflag EXPLOSION = 4;      // trigger sprite/particle explosion
  spawnflag SILENT = 8;         // No initial breakage sound
  spawnflag DAMAGE = 16;        // Spawning rubble can damage (def = 2, use dmg key for touch damage)
  spawnflag NOMONSTER = 32;     // monsters cannot damage this breakable and/or spawning rubble will not damage monsters
  spawnflag TRIGGERONLY = 64;   // Can only be triggered, no direct damage
  spawnflag NOROTATE = 128;     // Spawning rubble has No Y rotation
  string target, target2;       // Additional targets to fire when breakable is dead/used (only used once)
  float style;                  // pre-defined sound/model types - 1=rock, 2=wood, 3=glass, 4=metal, 5=brick, 6=ceramic, 10=custom
  float brksound;               // Initial breaking sound type (override style default)
  float brkimpsound;            // Impact sound type (override style default)
  float brkobjects;             // Breakable object model type (10-15=rocks, 20-22=woods, 30-32=glass, 40-43=metals, 50-54=brick, 60=ceramic)
  string noise;                 // Initial breaking sound (unique sound file)
  string noise1 - noise4;       // Impact sounds (unique sound files, must have 1 defined)
  string brkobj1 - brkobj4;     // Breakable objects (unique models, must have 1 defined)
  float health;                 // amount of damage to take before breaking (def 1)
  float count;                  // minimum quantity to spawn (def 4)
  float cnt;                    // random quantity to spawn (def 4) =-1 no random qty
  float dmg;                    // explosive radius damage (emits from center of func object)
  vector pos1;                  // x=start particle colour, y=random range, z=quantity
  vector brkvelbase;            // Base amount for velocity of broken parts (def based on style)
  vector brkveladd;             // Random additions for velocity of broken parts (def based on style)
  vector brkavel;               // Amount of breaking object angle velocity (def 200)
  float brkfade;                // Fade time before rubble fades away (def 4+random()*4)
  float brkmondmg;              // Damage multiplier for monster damage against breakable
  float brktrigjump;            // Trigger if damaged by jumping monster attack
  float brktrigmissile;         // Trigger if damaged by - rocket/grenade/shalball
  float brkgravity;             // Change the gravity for rubble, useful for underwater (Value = 0-1)
func_breakable_spawner          // Spawn breakable objects from a single point
  vector brkvol;                // Spawning volume vector for breakable point entity                      
                                // Always starts off, has all the same parameters as func_breakable, can fire multiple times
func_breakable_wall             // Switchable bmodel for breakable setups with optional collision
  spawnflag START_ON = 1;       // Will spawn visible and wait for trigger
  spawnflag SOLID = 2;          // Will block player/monster movement
  spawnflags FADEOUT = 4;       // Will fade out after a certain amount of time if visible!
  string targetname;            // must be defined otherwise will be removed
  float wait = -1;              // trigger once only, cannot toggle state
  float waitmin;                // random time to wait before fading out
trigger_monsterbreak            // Trigger breakable and monster together
  spawnflag NODELAY = 1;        // No delay between monster and breakable trigger
  spawnflag WAKEANIM = 2;       // Will do special wakeup animation when triggered
  string targetname;            // activating trigger points to this
  string target;                // points to func_breakable (single target)
  string target2;               // points to a monster (single target)
  float wait;                   // time before breakable is triggered (def 0.2)


==============================================================================
Particle System
---------------

The particle system is OFF by default because it can easily bring a Quake
engine to its knees with over use. When the system is active it will create
a large bank (1000) of particles to minimize entity thrashing. All requests
for a particle goes through a single system that does all the work fetching,
re-using and configuring all particles ready for use.

The system comes in two different flavours (pixel sprites and alpha textures)
which are automatically switched between when the correct engine is detected.
This allows for one map to work with multiple clients and minimize the
effort involved in getting a map looking good with multiple engines.

There are several predefined particle setups which can be triggered via a 
'misc_particle' entity or if they are not right a new particle can be setup
with the template system that copies all of its settings to any particle
entity that targets it when the map starts.

Quake does come with a small set of builtin particle effects that are used
throughout the game by monsters or map specific events. Using the new entity
'misc_builtineffects' the ID effects can easily be triggered.

The Darkplaces engine uses alpha texture particles which allows for one of
the best kind of particles, smoke! The new entity 'misc_smoke' is designed
to take advantage of that with multiple colours, different spread patterns
and velocity directions.

Particle entity details
------------------------------------------------------------------------------
misc_particle                   // Spawn a particle emitter
  string target;                // destination of effect (self -> target)
  string target2;               // name of a particle template
  string message;               // Particle style string (upper case) leave blank for custom
                                   ARMOR1, ARMOR2, ARMOR3, BOOK, ELECTRIC, FCIRCLE, 
			                       FLAMES, FLAMEL, KEYGOLD, KEYSILVER, MEGAH, PENT,
			                       PORTAL, QUAD, SIGIL, SKILL, SRING, SUIT
misc_particletemplate           // A particle emitter template
  string targetname;            // target name reference for misc_particle entities
  string spr_name1;             // sprite name (def=progs/s_bubble_blue1.spr)
  string spr_name2;             // sprite name (def=progs/s_bubble_wht.spr)
  string spr_name3;             // sprite name (def=progs/s_dotmed_grey.spr)
  float part_movetype;          // Movetype of particle (def=8, check defs.qc)
  float part_limit;             // Maximum amount of particles to emit at once (def=25)
  float part_life;              // Life time (seconds) particle is active (def=1)
  vector part_ofs;              // Offset from emitter (def='0 0 0' XYZ vector)
  float part_veltype;           // Velocity type 1=random, 2=circular 3=center (def=3)
  vector part_vel;              // Velocity direction (def='8 8 8' XYZ vector)
  vector part_velrand;          // Extra random velocity (requires part_veltype=1)
  float part_velrot;            // Velocity rotation (Y axis only)
  vector part_vol;              // Spawning volume around emitter (XYZ vector)
  float wakeup_dist;            // Wake up distance for particle emitter (def=1024)
  float wakeup_timer;           // How often to check distance time (def=1)
  float spawn_base;             // Spawn rate time - base value (def=0.1)
  float spawn_rand;             // Spawn rate time - random adjustment (def=0)
  float dpp_name;               // DP particle effect name in effectinfo.txt file (def="")
  float dpp_wait;               // DP particle re-trigger timer (def=0.1)
  float dpp_rnd;                // DP particle random multiplier for time (def=0)
  float dpp_vel;                // Direction of DP particles to move towards (XYZ)
misc_particle_burst;            // A particle emitter that fires a burst
  string part_ofs;              // Particle Origin Offset (def='0 0 0')
  float part_tcount;            // Particle Quantity (def=20)
  float part_life;              // Particle Life Time (def=2s)
  float part_style;             // 1=yellow, 2=green, 3=red, 4=blue, 5=purple, 6=fire, 7=white
  float part_movetype;          // 2=center, 3=up, 4=shockwave, 5=skull, 6=lost, 7=minotaur
misc_builtineffects             // Spawn a builtin particle effect
  string target;                // destination of effect (self -> target)
  float wait;                   // time between firing of effect (def=0)
  float delay;                  // random time between firing of effect (def=0s)
  float count;                  // type of effect to fire
                                   0=TE_SPIKE (def), 1=TE_SUPERSPIKE, 2=TE_GUNSHOT, 
		                           3=TE_EXPLOSION (sprites), 4=TE_TAREXPLOSION (purple ver)
		                           5=TE_LIGHTNING1 (Shambler ver), 6=TE_LIGHTNING2 (Player ver)
		                           7=TE_WIZSPIKE, 8=TE_KNIGHTSPIKE, 9=TE_LIGHTNING3 (boss ver)
		                           10=TE_LAVASPLASH (boss wakeup), 11=TE_TELEPORT (sparkles)
misc_smoke                      // special smoke model with multiple skins
  spawnflags NODPMDL = 2;       // Do not draw smoke model in DP engine
  spawnflags NODPFX = 4;        // Do not draw any DP particle effects
  string target;                // targeting entity used for custom direction
  float exactskin;              // 0=Gunsmoke, 1=Soot, 2=Steam, 3=Toxin, 4=Plague, 5=Incense, 6=Lithium, 7=Flames
  vector angles;                // 'pitch roll yaw' up/down, angle, tilt left/right 
  float alpha;                  // Smoke is generally transparent (def=0.65)
  float wait;                   // time between generation of smoke particles (def=0.1, min=0.01)
  float delay;                  // random amount of time delay ( time = wait + delay x random() )
  float height;                 // Percentage of velocity distance travelled (def=1, range=0-1+)


==============================================================================
New/Updated Monsters
--------------------

New keys for All monster
------------------------------------------------------------------------------
spawnflag AMBUSH = 1;           // Ambush (will only wakeup if see the player)
spawnflag SILENT_WAKEUP = 8;    // No wakeup sight sound
spawnflag SPAWN_NOIDLE = 16;    // no idle sounds (cupboard monster)
spawnflag SPAWN_NOGFX = 32;     // No spawn effect or sound
spawnflag SPAWN_DELAY = 64;     // Will wait for trigger before spawning
spawnflag SPAWN_ANGRY = 128;    // When spawning will be angry at the player 
string target;                  // Primary target field for trigger events
string target2;                 // Secondary target field (additional fires)
string angrytarget;             // target name to get angry at when spawning
string deathtarget;             // Alternative target to fire when dying
float health = 1-x;             // Override default health defined in QC
float exactskin = 0-x;          // Override default skin (no range check)
float upgrade_axe = 1;          // Only spawn if player has got upgrade Axe
float upgrade_ssg = 1;          // Only spawn if player has got upgrade Shotgun
float upgrade_lg = 1;           // Only spawn if player has got upgrade Lightning Gun
float nomonstercount = 1;       // Will not count towards map monster total
float infightextra = 1-x;       // Damage multiplier when infighting
float pain_ignore = 1;          // Will ignore pain frame when infighting
float noinfighting = 1;         // Will ignore all requests to infight
float no_liquiddmg = 1;         // Blocks all liquid (slime/lava) damage checks
float no_zaware = 1;            // Z Aware projectiles will be disabled
float bboxtype = 1-10;          // 1=Tiny,4=Short,5=Tall,7=Wide,8=Giant,10=Massive 
float gibondeath = 1;           // Will always explode into gibs on death
float bodyfadeaway = 1-x;       // Time in seconds before body/head fades away
float movespeed = -1/0/1;       // =-1 no movement(turret), =0/1 free movement
float turrethealth = 0-1;       // % of HP when monster turret is released 
string turrettarget;            // Target(s) to fire when turret % HP is released
float nospawndamage = 1;		// Does not kill anything inside spawn area

Zombies (regular + knight)
------------------------------------------------------------------------------
spawnflag CRUCIFIED = 1;        // Zombies - start in crucified position (regular only)
spawnflag AMBUSH = 2;           // Ambush (will only wakeup if see the player)
spawnflag ONFLOOR = 4;          // Zombies - spawn lying on the floor
float angle = 0, 1-360;         // 0=random lying down angle, 1-360=specific

Skull Wizards
------------------------------------------------------------------------------
float bodyphased;               // Starting body state; 0=solid, 1=invisible
float bodystatic;               // Prevents skull wizard from teleporting 
float height;                   // Maximum teleport destination height (def=96)
float distmin;                  // Minimum amount for teleport distance (def=256)
float distmax;                  // Random amount to add to teleport distance (def=512)

Stone Statues (Knights/Hell Knights)
------------------------------------------------------------------------------
spawnflag MON_STATUE = 2;       // Convert monster to a stone statue (frozen)
spawnflags MON_NOTFROZEN = 4;   // Will start not frozen (works with statue)
string targetname;              // Will not spawn if targetname is missing
float frame = x;                // Statue pose (default knight=44, hellknight=73)
vector pos1;                    // X->Y, Z=0 ; Idle animation range to pick from

Mummy, Green Spider and Minotaur
------------------------------------------------------------------------------
float poisonous = -1;           // Will no longer apply poison debuff to projectiles

New Keys for SPECIFIC monster
------------------------------------------------------------------------------
spawnflag HOGREMETAL = 4;       // Hunter Ogre - upgraded metal skin and +HP
spawnflag OGREGREEN = 4;        // Green Ogre - upgraded skin and +HP
spawnflag FREDLASER = 2;        // Freddie Ogre - Upgrade SNG to Lasergun
spawnflag SPIDERLARGE = 2;      // Spider - Green range variety, greater HP
spawnflag SPIDERCEILING = 4;    // Spider - Will start on the ceiling
spawnflag VORELINGLARGE = 2;    // Voreling - Purple range variety, greater HP
spawnflag VORELINGCEILING = 4;  // Voreling - Will start on the ceiling
spawnflag GARGOYLESTATUE = 2;   // Gargoyle - A stone version of perch abilty
spawnflag GARGOYLEPERCH = 4;	// Gargoyle - Will start in a perch position
spawnflag GAUNTPERCH = 4;       // Gaunt - Will start in a perch position
spawnflag BOILHANGING = 2;      // Boil - On wall upside down by spikes
spawnflag BOILHOBBLED = 4;      // Boil - On floor fixed down by spikes
spawnflag SEEKERSHIELD = 4;     // Seeker - Start with blue shield on

spawnflag MINOTAURMINIONS = 4;	// Minotaur - Spawn brown gargoyles
spawnflag SHALRATHMINIONS = 4;	// Shalrath - Spawn little vorelings
spawnflag SKULLWIZGUARDIAN = 2; // Skull Wizard - special rune setup
spawnflag SKULLWIZMINIONS = 4;  // Skull Wizard - Spawn lost souls
spawnflag WRAITHSCORPIONS = 2;	// Wraith - Will Spawn brown/green scorpions
spawnflag WRAITHSPIDERS = 4;	// Wraith - Will Spawn brown/green spiders

spawnflag DCROSSTRACK = 4;      // Crossbow knights will velocity track enemies
spawnflag JIMROCKET = 4;        // Robot Jim - fires rockets and has lower health
spawnflag BLACKSTINGER = 4;     // Scorpion - Deadly poison debuff sting attack
spawnflag TARBYLESSJUMP = 4;    // Tarbaby - Will not constantly jump around
spawnflag ALWAYSABOVE = 4;      // Wizard - Will always maintain height above enemies
spawnflag GOLEMSTATUE = 2;      // Golem - Will start as a statue, wait for trigger

NEW monsters
------------------------------------------------------------------------------
monster_spider (30/75HP)        // Erratic arachnids in brown/green variety
monster_voreling (30HP)         // Ankle biting, crazy jumping, mini shalraths
monster_lostsoul (30HP)         // Floating skull with a ram/bite attack
monster_dguard (35HP)           // Medieval style soldier replacement (melee only)
monster_zombiek (60HP)          // Sword wielding zombie, fast movement (melee only)
monster_eel (50HP)              // Fast moving sneaky fish firing plasma (range only)
monster_boil (75HP)             // Proximity mine with tarbaby like explosive damage
monster_dcrossbow (75HP)        // Chainmail knight with crossbow (sniper ability)
monster_gargoyle (120HP)        // Large flying fireball throwing imp (range only)
monster_gaunt (120HP)           // Flying plasma wielding harpy creature (range only)
monster_scorpion (80/120HP)     // Brown/green range stinger and black jumping surprise
monster_skullwiz (120HP)        // Tall wizard with fast skull missiles and teleportation
monster_hogre (200HP)           // Ogre Hunter model replacement (extra melee)
monster_hogremac (200HP)        // Alternative ogre model with mace weapon
monster_hogreham (300HP)        // Heavy metal ogre model with hammer attack
monster_dknight (250HP)         // Hell Knight model replacement (classic silver)
monster_wraith (300HP)          // Semi-transparent wraith with debuff attacks
monster_dfury (400HP)           // Fast sword wielding knight with magic attacks
monster_dsergeant (400HP)       // Blue Flail knight with homing missiles
monster_drole (500HP)           // Large tentacle tank with rocket/melee attacks
monster_minotaur (500HP)        // Giant hulk with fast plasma/poison attacks
monster_golem (500HP)           // Massive mountain of rock with large fists and feet

monster_army_rocket (45HP)      // Red armour heat seeking rocket soldiers 
monster_army_grenade (60HP)     // Green armour Z aware grenade firing soldiers
monster_army_plasma (75HP)      // Blue armour high damage plasma gun soldiers
monster_pyro (100HP)            // Yellow armour flamethrowing enforcer (burn defuff)
monster_fumigator (100HP)       // Green armour Posion Spewing enforcer (poison debuff)
monster_jim (50/100HP)          // Fast moving flying laser/rocket robot 
monster_defender (100HP)        // Dual wielding SSG (melee range) and GL (mid range)
monster_eliminator (120HP)      // Blue armour double firing plasma gun enforcers
monster_centurion (120HP)       // Flying hover board plasma gun enforcers
monster_freddie (500HP)         // Slow moving weapons platform with ogre on top
monster_seeker (500HP)          // Large industrial mech with heavy range weapons

monster_boglord (1200HP)        // Special shambler with projectile attacks only
monster_eidolon (2500HP)        // Giant rock demon with summon/projectile attacks
monster_firetopboss (---)       // Custom Chthon encounter with infighting ability
monster_lichfiend (2500HP)      // Tall lich demon with summon/projectile attacks
monster_nour (2000HP)           // Large white wizard with summon/projectile attacks

Monster Infighting Groups (Can only be change in QC)
------------------------------------------------------------------------------
Soldiers            (4) monster_army, _army_rocket, _army_grenade, _army_plasma
Enforcers           (5) monster_enforcer, _defender, _pyro, _eliminator, _centurion
Demons              (3) monster_demon1, _drole, _minotaur, _boglord, _lichfiend
Dog                 (1) monster_dog
Fish                (1) monster_fish
Robots              (1) monster_jim, _seeker 
Knights             (3) monster_knight, _dguard, _dcrossbow
Hell Knights        (2) monster_hell_knight, monster_dknight
Knight Captains     (2) monster_dfury, monster_dserg
Stone               (3) monster_hell_knight (statue), _knight (statue), _golem, _eidolon
Ogre                (4) monster_ogre, _hogre, _hogremac, _hogreham, _freddie
Arachnids           (4) monster_shalrath, _vorling, _wraith, _spider, _scorpion
Shambler            (1) monster_shambler
Tarbaby             (1) monster_tarbaby, monster_boil
Wizard              (4) monster_wizard, _gargoyle, _gaunt, _skullwiz, _lostsoul, _nour
Zombie              (3) monster_zombie, _zombiek, _mummy
Boss                (1) monster_boss, _oldone

monster_army (_rocket, _grenade, _plasma)
------------------------------------------------------------------------------
Low health cannon fodder with various weapon upgrades and different coloured
armour to fill up early base levels with. The rocket version has a small amount
of target seeking, the grenades are Z aware and the plasma is high damage!

monster_enforcer (_defender, _pyro, _eliminator, _centurion)
------------------------------------------------------------------------------
A large battalion of dual shock defenders, high burst plasma eliminators, floating
high centurions and firey flamethrowing enforcers. With a gradually inclining range
of HP bars and jigsaw like large pack encounter designs, this is a formidable 
front line defence force!

monster_jim
------------------------------------------------------------------------------
A fast moving flying robot that can easily avoid players projectile attacks
with a special upward move and still keep firing lasers or rockets. The speed
of the projectiles and movement are linked to skill levels which can be a
challenge when encountered in large packs.

monster_zombiek
------------------------------------------------------------------------------
A slow moving zombie with a knight sword in one hand and counter balance club foot.
Has a small leap forward when close to the player and requires large hit damage to die.
Designed to be lurking in the shadows or part of a pack of monsters as it is good
at applying pressure to an already active combat situation. Can start/spawn
lying down and then be triggered later.

monster_spider
------------------------------------------------------------------------------
The brown (default) spider is melee only and will erratically move towards
the player with a tame jump attack for close encounters. The green (large)
spider prefers to stay at range and spit at the player with 3 blobs of acid.
The spit function will track the player and is ZAware.

The spider bite is low damage 1-3 per 5 frames with a special frenzy attack. This
can be lethal in large groups as the spider also pushes forward at the same time.
The jump attack is 5-10 damage, half that of a dog. Can be setup to spawn on
the ceiling and triggered to drop on unobservant players.

monster_scorpion
------------------------------------------------------------------------------
The brown/green (default) scorpion is very slow moving and prefers to throw
acid coloured spikes at the player. A low health enemy with an easily dodged
range attack, but a lethal claw melee attack.

The black version is much tougher on health and will jump extremely quickly
at the player with a deadly poison tail sting. The players health will be
reduced by 50% each sting and gradually restore back 5HP per second afterwards.
Best setup in very dark corners ready for any unsuspecting players, produces a
very distinct idle sound designed to induce fear of attack.

monster_voreling
------------------------------------------------------------------------------
Mini three legged ankle biting vorelings are fast moving with a small sized
jump and frenzy bite attack for snacking. They speed up and slow down while
they run and will often pause if at distance from the player. They have very
low health and are designed to be encountered in packs. Can be setup to spawn
on the ceiling and triggered to drop on unobservant players.

monster_dguard
------------------------------------------------------------------------------
A medieval version of the 'monster_army' unit with low health and knight like
melee damage. Good for starting areas and general filler to existing groups.
Designed to be an easy introduction to the Death Brigade with knight movement. 

monster_dcrossbow
------------------------------------------------------------------------------
A cautious range unit with high damage bolts and a strong melee attack. The
bolts are variable speed based on skill level and are designed to force the player
to strafe or seek cover. The health bar can easily be taken down with NG+ weapons, 
but SG\SSG will struggle because of reload times.

When the player is within melee range the unit will use the crossbow as a club
and as soon outside of range straight away fire a bolt for a quick hipshot.
Unlike most monsters in Quake the crossbow knight will not immediately follow
the player but rather wait and keep distance.

It is recommended to place these units around sharp corners (90 degree)
or up on ledges overlooking areas. The crossbow knight does not follow the
same way as other quake units and needs to be in position first.

monster_gargoyle
------------------------------------------------------------------------------
A tough flying unit with a single range attack (fireball) that prefers to keep
its distance from ground enemies. The fireball does 25% damage compared to a
player rocket with direct and splashdamage to encourage infighting.

The gargoyle will always try to maintain height above its enemies to reduce
melee damage and works best when in areas with high ceilings. If the enemy
is within close range, will fire rapid shots instead.

monster_gaunt
------------------------------------------------------------------------------
A large Cthulhu like Pterodactyl with an creepy calling sound and the ability
to transmute electricity into fast moving bolts of plasma. Will always hover
above the player and can be setup in a perch state for surprise attacks.

monster_freddie
------------------------------------------------------------------------------
A Large ogre fused to a rusty industrial exoskeleton, with various weapons
grafted to both arms forcing it to open cans of food with its teeth! Either
has a Super Nail gun or a Laser Chain gun as a primary weapon.


monster_hogre
------------------------------------------------------------------------------
A new model with greater detail and some armour pieces similar to the Hell
Knight. There are three different types; chainsaw, mace and hammer. Each
ogre can be upgraded (skin) with a new spawnflag that gives an extra HP boast.

The chainsaw version has an extra thrust attack which does +150% damage. The
mace ogre does high single strike attacks and the hammer version has a special
shockwave attack which lifts everything nearby off the ground.

monster_dknight
------------------------------------------------------------------------------
Model upgrade with more poly detail and standard attacks.

monster_dfury
------------------------------------------------------------------------------
A mid level monster with shalrath/demon like health bar that has five melee
attacks and two very quick firing magic attacks. Designed to jump close to
the player and use multiple quick sword swings for high damage. Will use
two types of magic attacks at mid to long range that have slow build up
animations that fire variable speed projectiles dependant on skill level.

The fury knight will easily work its way through a crowded room doing extra
damage against other monsters and using its over head smash attack for
visual affect. It has a high pain threshold for small impact damage, but
can be dealt with easily with SNG/GL/RL heavy attacks.

monster_dsergeant
------------------------------------------------------------------------------
A fast moving Blue Flail knight with shalrath homing missiles and heavy
single strike melee attacks. This unit will constantly charge the player if the
Z height is similar and if different keep send deadly homing missiles instead.
This is a mid level monster that is highly mobile, crushing up close and
will easily tear a path through any crowd to get its target.

The homing missiles have the same speed regardless of skill level. Originally
these were setup identical to the Shalrath with easy/normal/hard being different
to the nightmare skill level. During testing it felt like the missiles were
going faster than usual because the blue knight moves around so quick, this
is the reason the missiles use only one speed.

monster_wraith
------------------------------------------------------------------------------
A semi-transparent flying apparition with multiple range attacks that will
try to stay out of melee range and high above the player as much as possible.
The primary attack is a hitscan burning debuff that does direct fire damage
and then sets fire to the player with damage over time afterward.

The burning debuff will ignores all armour and is deflected by the Pentagram
of Protection and Environment Suit. The screen will flash orange every second
and a loud heartbeat sound can be heard in background while the health is
being drained. The player can use health packs to instantly stop the burning.

Once the debuff has been applied to the player the wraith will start attacking
with a burst of bones (nails) to keep the player pre-occupied with dodging.

The wraith is designed to be a support class monster that lurks in the
background helping an existing encounter by disorientating the player with
large fire attacks and slow burning damage.

monster_drole
------------------------------------------------------------------------------
A large hulking tank of tentacles with a tendency to get angry at the player
with sometimes deadly results. This monster has two phases, the first is to
keep mid range distance and fire rapidly increasing fireballs. There is no
strafe mode but instead the monster will physically turn and walk around
to the side waiting for the cooldown on range attacks.

The second phase is the enrage at 70% health the drole will switch to a
very fast run attack (demon/fiend speed) and constantly try to pummel the
player with a wall of tentacles. The second phase is really to apply the
pressure to the player and make them panic.

monster_minotaur
------------------------------------------------------------------------------
An extremely tall demonic beast with a powerful melee attack and very fast
plasma/poison attack. This monster has two phases likes the drole and will
eventually switch to a very fast charge/melee attack when enraged.

monster_golem
------------------------------------------------------------------------------
A slow moving mountain of rock with giant fists and large feet that can easily
destroy any enemies that get too close. The Golem has several strong melee
attacks, one large radius ground shockwave attack and the ability to throw a
large volley of bone breaking rock debris.

monster_shambler (by Renier "Skiffy" Banninga)
------------------------------------------------------------------------------
This set of files are designed as a new HD replacement for the default Quake
Shambler.MLD which I've always found to be one of the weakest models in the game.
made monster models in the game. This model was created with the purpose of
finally giving the shambler its visual fidelity deserving of such a large
and terrifying brute while still staying within the limits of Vanilla quake.

The original Shambler has 284 triangles which is less than half the amount used
on the dog model. The new Shambler uses 992 triangles which is a little less than 
double the amount used on the beloved dog. He uses a 256 x 256 texture which conforms
to GL texture size standards unlike the 308 x 115 texture size of the original.
Considering his overall size and rarity in the game these upgrades specs would
work just fine in the original game. It is still within the limits of stock Quake.

Animation has been completely redone and was made in such a way to work with the
originals size and AI motions. Some fixes have been done for the movement and
attack animations. He no longer hits high up in the air for the walking slash
attacks and should have most if not all sliding feet issues removed or reduced.
His overhead smash has also been shifted one frame to sync up more with the damage
trigger and features a less floaty death animation. Overall it should read a bit 
more solid.

h_shams.mdl has also received a visual makeover to be consistent with the updated
shambler model. I tried to make it look a little more mauled to help convey that
a serious amount of damage was required to gib the Shambler. There also supports 
Arcane Dimensions custom gib models adding 2 feet and claw gore meshes when
gibbing the shambler.

The Boglord (larger shambler) and re-colouring of skins for monster+gibs
was done by me (simonoc) after receiving the final models from Renier.

==============================================================================
Minion System
-------------

This system is designed to work with specific monsters and spawn certain 
monsters, this is not a global function for all monsters. The idea is to create 
a support class, a strong HP monster that stays at mid range and keep spawning 
low health monsters that will create more chaotic encounter groups.

Minion spawning monsters on their own are easy to deal with, their spawning is
slow and they rarely use any kind of direct damage attack.  It is essential that
these monsters are placed at the edge of encounters so that any monsters they
do spawn can join the encounter easily.

The primary concern with the minion spawning mechanic is that the player can
eventually run out of ammo and the endless spawning can eventually crash the
engine. This is solved by two mechanics, a limit to how many minions are
active at once and trigger events based on quantity spawned so far.

The defaults can be changed by adding the following keys to the monster:
------------------------------------------------------------------------------
float minion_maxcount;          // Maximum amount of active minions (def=5)
float minion_maxtrigger;        // Spawn total for trigger event (def=5)
string miniontarget;            // targetname string for trigger event

Once the monster reaches the maximum active amount of minions it will go into
wandering phase of maintaining distance from the enemy and occasional (10%) use
a range attack so that it looks like it is doing something. The spawning monster
will not spawn any minions unless it can see the player.

The default throw parameters are quiet low (100-150 speed) and this can be
problem if the minion spawner is on a high ledge. The following parameters will
change the default throw distance and fix any stuck problems. 

How to change the throw speed of the ball/egg
------------------------------------------------------------------------------
float minion_throwspeed;        // Forward speed of ball to be thrown (def=100)
float minion_throwextra;        // Random forward momentum (def=50)
float minion_throwside;         // Random +/- sideways momentum (def=50)

If the player reaches gets within melee range there is a chance that the
minion spawner will revert to the monsters original base attack. This can be 
blocked with the following parameter, otherwise it is on by default.

------------------------------------------------------------------------------
float minion_baseattack = -1;   // Block base attack within melee range

Every minion spawning monster requires a special entity that must be added to
the map so that all the correct precache files are loaded. If the entity is not
present when the monster tries to spawn a minion, a dev console message will be
displayed and the monster will not spawn anything!

Here is a list of the new entities (named after spawning monster)

------------------------------------------------------------------------------
monster_minotaurminion          // Gargoyle precache for the Minotaur
monster_shalrathminion          // Vorling precache for the shalrath
monster_skullwizminion          // Lost Soul precache for the Skull Wizard
monster_wraithminion            // Spider precache for the wraith
monster_wraithminion2           // Scorpion precache for the wraith

The spawning minion function only works against the player, if the monster is
caught infighting it will revert to its typical range attacks until the
fight is over. Then it will switch back to the player and resume spawning.

Here is a list of available minion spawning monsters:

monster_minotaur
------------------------------------------------------------------------------
A large hulking demonic beast with strong melee attacks, large feet and the
chance to throw very fast plasma or poison bolts at the player. The dark brown
version loves to summon gargoyles out of thin air!

monster_shalrath
------------------------------------------------------------------------------
A classic ID monster with three legs, a rough voice and a tendency to throw
homing missiles that love to chase players around tiny pillars. The darker
skinned version loves to throw baby voreling eggs at the player!

monster_skullwizard
------------------------------------------------------------------------------
A turret like dead wizard that fires powerful skull rockets and when 
the player is too close will teleport away to another location. The black
robe version loves to summon lost souls out of thin air!

monster_wraith
------------------------------------------------------------------------------
A semi-transparent flying apparition with multiple range attacks that will
try to stay out of melee range and high above the player. The dark skinned
version loves to throw baby scorpion/spider eggs at the player!


==============================================================================
Bounding Boxes
--------------

The quickest way to make the game harder is to change the size of bounding
boxes! All projectiles are tested against a monsters bounding box, which cannot
be rotated, is always centered on the model and XY square in dimensions because
of the rotation problem.

To view ingame bounding boxes use the console command 'r_showbboxes'

All of the bounding boxes have been tweaked to fit the models better, this
will affect how monsters move around (collision) and especially weapons that
have large projectile spread patterns (ie shotguns)

The monsters break down into several categories based on model sizes and
location (ground/air/water). Flying monsters usually have taller bounding
boxes so they can be hit easier from the ground.

Name                Category (   Min   ) (  Max  )  (  IDmin  ) ( IDMax ) Diff
------------------------------------------------------------------------------
Lost Soul           Tiny     -16 -16 -24  16 16 16  --- --- ---  -- -- --
Scorpion            Tiny     -16 -16 -24  16 16 16  --- --- ---  -- -- --
Spider (Br/Gr)      Tiny     -16 -16 -24  16 16 16  --- --- ---  -- -- --
Voreling            Tiny     -16 -16 -24  16 16 16  --- --- ---  -- -- --

Dog                 Dog      -20 -20 -24  20 20 16  -32 -32 -24  32 32 40  **
Fish                Fish     -16 -16 -24  16 16 24  -16 -16 -24  16 16 24

Player              Short    -16 -16 -24  16 16 32  -16 -16 -24  16 16 32
Knights             Short    -16 -16 -24  16 16 32  -16 -16 -24  16 16 40  **
Army (SG/GL/RL/PG)  Short    -16 -16 -24  16 16 32  -16 -16 -24  16 16 40  **
Death Guard         Short    -16 -16 -24  16 16 32  --- --- ---  -- -- --
Crossbow Knight     Short    -16 -16 -24  16 16 32  --- --- ---  -- -- --
Jim (Robot)         Short    -16 -16 -24  16 16 32  --- --- ---  -- -- --
Zombie              Short    -16 -16 -24  16 16 32  -16 -16 -24  16 16 40  **
Zombie Poisoned     Short    -16 -16 -24  16 16 32  --- --- ---  -- -- --
Zombie Knight       Short    -16 -16 -24  16 16 32  --- --- ---  -- -- --
Boil                Short    -16 -16 -24  16 16 32  --- --- ---  -- -- --

Enforcer (LZ/GL/PG) Tall     -16 -16 -24  16 16 40  -16 -16 -24  16 16 40
Pyro                Tall     -16 -16 -24  16 16 40  --- --- ---  -- -- --
Fumigator           Tall     -16 -16 -24  16 16 40  --- --- ---  -- -- --
Centurion           Tall     -16 -16 -24  16 16 40  --- --- ---  -- -- --
Hell Knight         Tall     -16 -16 -24  16 16 40  -16 -16 -24  16 16 40
Death Knight        Tall     -16 -16 -24  16 16 40  --- --- ---  -- -- --
Fury Knight         Tall     -16 -16 -24  16 16 40  --- --- ---  -- -- --
Sergeant Knight     Tall     -16 -16 -24  16 16 40  --- --- ---  -- -- --
Gargoyles           Tall     -16 -16 -24  16 16 40  --- --- ---  -- -- --
Gaunt               Tall     -16 -16 -24  16 16 40  --- --- ---  -- -- --
Skull Wizard        Tall     -16 -16 -24  16 16 40  --- --- ---  -- -- --
Tarbaby             Tall     -16 -16 -24  16 16 40  -16 -16 -24  16 16 40
Wizard (Scrag)      Tall     -16 -16 -24  16 16 40  -16 -16 -24  16 16 40

* All monsters below this point have HULL2 bounding boxes against the world

Name                Category (   Min   ) (  Max  )  (  IDmin  ) ( IDMax ) Diff
------------------------------------------------------------------------------
Demon               Wide     -24 -24 -24  24 24 40  -32 -32 -24  32 32 64  **
Ogre                Wide     -24 -24 -24  24 24 40  -32 -32 -24  32 32 64  **
Hunter Ogre         Wide     -24 -24 -24  24 24 40  --- --- ---  -- -- --
Mace Ogre           Wide     -24 -24 -24  24 24 40  --- --- ---  -- -- --
Hammer Ogre         Wide     -24 -24 -24  24 24 40  --- --- ---  -- -- --
Shalrath            Wide     -24 -24 -24  24 24 40  -32 -32 -24  32 32 64  **
Wraith              Wide     -24 -24 -24  24 24 40  -16 -16 -24  16 16 32  **

Drole               Giant    -24 -24 -24  24 24 64  --- --- ---  -- -- --
Freddie             Giant    -24 -24 -24  24 24 64  --- --- ---  -- -- --
Minotaur            Giant    -24 -24 -24  24 24 64  --- --- ---  -- -- --
Seeker              Giant    -24 -24 -24  24 24 64  --- --- ---  -- -- --
Golem               Golem    -24 -24 -24  24 24 72  --- --- ---  -- -- --
Shambler            Massive  -32 -32 -24  32 32 64  -32 -32 -24  32 32 64

BogLord             Boss    -32  -32  24   32  32  80
Boss (Chthon)       Boss   -128 -128 -24  128 128 256 
Eidolon             Boss    -32  -32 -24   32  32 128 
Lich Fiend          Boss      0    0   0    0   0   0
Nour                Boss    -24  -24 -24   24  24  40   
Oldone              Boss   -160 -128 -24  160 128 256

Quake maintains two types of collision, projectiles and world (geometry).
The QC can set the projectile collision (see above) but the world collision
is done via the engine. There are currently 3 types of world collision
called Hull 0, 1 and 2. 

Any monster that is wider than 32 units will have a Hull 2 collision which 
is the size of a shambler. This is why ogres, demons and shalraths often 
cannot fit through small doorways even though it looks like they can!


==============================================================================
New Weapons
-----------

Shadow Axe (SA)
------------------------------------------------------------------------------
The new axe is a visual upgrade (blood soaked model) which does +75% more 
damage, kills zombies and deals with low level monsters easily. To some
the axe has always been a novelty weapon, but there are plenty of Quake
players who love to dance around monsters cutting them down to size!

Weapon Dmg  2+  3+  4+  5+  6+  7+  8+  9+  10+ 11+ 12+ 13+ 14+ 15+
Axe     20  40  60  80  100 120 140 160 180 200 220 240 260 280 300
New Axe 35  70  105 140 175 210 245 280 315 350 385 420 455 490 525

Monster Health Axe Hits Time  NAxe Hits Time   Diff
----------------------------------------------------
Dog       25    40  +2  1.0s    35  +1  0.5s   +0.5s
Army      35    40  +2  1.0s    35  +1  0.5s   +0.5s
Knight    75    80  +4  2.0s   105  +3  1.5s   +0.5s
Wizard    85   100  +5  2.5s   105  +3  1.5s   +1.0s
Ogre     200   200 +10  5.0s   210  +6  3.0s   +2.0s
----------------------------------------------------
HKnight  250   260 +13  6.5s   280  +8  4.0s   +2.5s
Demon    300   300 +15  7.5s   315  +9  4.5s   +3.0s
Shalrath 400   400 +20 10.0s   420 +12  6.0s   +4.0s
Shambler 600   600 +30 15.0s   630 +18  9.0s   +6.0s

With the increased damage, many of the low level monsters are now one hit
wonders and several of them will now play long pain animations when attacked
with the new axe to allow the player time to get in extra 2nd/3rd fatal hit.
(dcrossbow, enforcer, hogre, knight, ogre, wizard do long pain animations)

The primary benefit of the new axe is against zombies, one hit will often
knock them down to the ground and another will deal with them on the ground.
This also applies to all bodies lying on the floor, so observant players can
preempt traps by dealing with bodies on the floor first.

The Widowmaker (WM)
------------------------------------------------------------------------------
This is an upgrade to the Super Shotgun (SSG) and does +50% more damage, but
uses +50% more shells (3 per shot). The WM spread pattern is identical to the
SSG and there are now 21 pellets instead of 14 fire every 7 frames.

Weapon Pellets Dmg Total  2+  3+  4+  5+  6+  7+  8+  9+ 10+ 11+
SG        6     4   24    48  72  96 120 144 168 192 216 240 264
SSG      14     4   56   112 168 224 280 336 392 448 504 560 616
WM       21     4   84   168 252 336 420 504 588 672

Monster Health SSG Shots Ammo Time    WM Shots Ammo Time   Diff
---------------------------------------------------------------
Army      35    56  +1    2   0.7s    84  +1    3   0.7s   -.-s
Zombie    60    56  --    -   -.-s    84  +1    3   0.7s  +0.7s
Knight    75   112  +2    4   1.4s    84  +1    3   0.7s  +0.7s
Wizard    80   112  +2    4   1.4s    84  +1    3   0.7s  +0.7s
Gargoye  120   168  +3    6   1.4s   168  +2    6   1.4s  +0.7s
Ogre     200   224  +4    8   2.8s   252  +3    9   2.1s  +0.7s
HKnight  250   280  +5   10   3.5s   252  +3    9   2.1s  +1.4s
---------------------------------------------------------------
Demon    300   336  +6   12   4.2s   336  +4   12   2.8s  +1.4s
Shalrath 400   448  +8   16   5.6s   420  +5   15   3.5s  +2.1s
Shambler 600   616  +11  22   7.7s   672  +8   24   5.6s  +2.1s

The WM is designed to be effective against mid range monsters (demon/shalrath)
and less effective against single low level monsters (knight/wizard). This gives
the player more high damage weapon/ammo choices (shells/nails) and extra time to
deal with more powerful enemies quickly. With the same spread pattern as the SSG
and higher damage output the RG can easily deal with multiple small monsters.

One side effect of the higher damage (84) is that the weapon can effectively
kill zombies with one hit and is an ideal early weapon alternative to the GL/RL.

The greatest concern with the WM is the ammo consumption, especially if the 
player is missing many shots or catching the sides of bounding boxes. Extra 
boxes of shell ammo should be setup to delay spawn (via extra keys) if the 
player has the item in their inventory.

Plasma Gun (PG)
------------------------------------------------------------------------------
This is an upgrade to the Lightning Gun with extra (splash) damage, the
ability to plasma climb walls and no instant death if fired in water.

Weapon    Direct  Splash  Speed  Refire   Damage
---------------------------------------------------
Lightning   30       0      -      0.10     300
AD Plasma   45      20     900     0.20     325
---------------------------------------------------
Doom        5-40     0     875     0.086   58-465
Doom3       16       0     700     0.125    128 
Quoth        0      50    1000     0.20     250


==============================================================================
Weapon Upgrade Parameters
-------------------------

This MOD contains several ways to give or take weapon upgrades from the
player during the various stages of the map loading process. 

Stage 1 - TEMP1 in Quake.rc
---------------------------

The temp1 variable in quake.rc has the following parameters:

8192    Turn ON Axe Upgrade, +75% dmg, gib zombies
16384   Turn ON SSG Upgrade, +50% dmg, uses 3 shells
32768   Turn ON LG Upgrade, Plasma projectiles + Splash Damage

Enabling these parameters DOES NOT give the player the upgrade weapon,
it will upgrade the original weapons in any map. For example, if the player
finds the Super Shotgun in a map it will automatically be upgraded to the 
Widowmaker Shotgun instead.

These options are designed for players who want to enjoy maps which don't
have the weapon upgrades entities present, like for example ID maps.

Stage 2 - Worldspawn
--------------------

The worldspawn entity of a map has the following parameters:

upgrade_axe  Upgrade Axe -1=remove, 1=enable
upgrade_ssg  Upgrade Super Shotgun -1=remove, 1=enable
upgrade_lg   Upgrade Lightning Gun -1=remove, 1=enable

Not every map is designed for the upgraded weapons and by using the
worldspawn entity, mappers can decide if the upgraded weapons are given
or taken away when the map is started.

These worldspawn parameters will OVERRIDE the temp1 key and any
existing inventory if the player has come from another map. These
parameters will also change the server flags for original weapons
to be upgraded and triggers for special spawn conditions.

Stage 3 - Worldspawn II
-----------------------

The worldspawn entity also has the following parameters:

give_weapons  Bit flag for which weapons to give to the player
take_weapons  1=SG, 2=SSG, 4=NG, 8=SNG, 16=GL, 32=RL, 64=LG (excludes Axe)

These worldspawn parameters are designed to give exact weapon loadouts
to a new player starting a map. There are also parameters for ammo, health
and armour to customize the player inventory further.

The take weapon command will remove upgraded weapons if the base weapon is
removed by these parameters. For example, if the map removes the SSG, then
the Widowmaker upgrade will be removed at the same time.

Stage 4 - Impulse Commands
--------------------------

These impulse commands are available when developer mode is enabled:

Impulse 200   Upgrade Axe (alias = "upgaxe")
Impulse 205   Upgrade SSG (alias = "upgssg")
Impulse 210   Upgrade LG  (alias = "upglg")

These impulse commands are toggles that will add/remove the relevant
weapon upgrade. These weapons are not part of impulse 9 which is the
general cheat function used for testing.


==============================================================================
Ammo Resistance
---------------

I always thought it was odd that the Shambler had 50% resistance to all
rockets. This was never visually shown or hinted at in the game besides the
manual warning about it! I am sure there were plenty of players who never
realized this 'feature' existed.

I am sure some people will scream that a RPG style resistance system has
no place in Quake and maybe they are right, but unfortunately there is 
an exception to the rule, the Shambler!

In an effort to resolve this visual problem a few monsters (high tier)
now have ammo resistance to encourage the player to use different weapons
and manage / collect more ammo types. This is also something a designer
needs to be aware of when balancing a map involving these monsters.

The Shell and Nail visual resistance is shown with a mixture of red and
grey impact particles, a ricochet sound, various smoke chunks flying off
in random directions and the monster screaming in pain.

The Rocket and Cell visual resistance is shown with a small puff of smoke,
a different rocket sound, small gibs of flesh (blood particles look odd),
various smoke chunks flying off in random directions and a monster scream.

When a monster is hit with a projectile and they have ammo resistance they
will ALWAYS ignore pain and not go into any pain animations.

Name                Shells  Nails  Rockets  Cells   HP  Effective
------------------------------------------------------------------
Golem                 ---    50%     ---     ---    500   1000
Minotaur              ---    ---     ---     50%    500   1000
Seeker                ---    ---     50%     ---    500   1000
Shambler              ---    ---     50%     ---    600   1200

Stone Knight          ---    50%     ---     ---     75    150
Stone Hell Knight     ---    50%     ---     ---    250    500

Defender              ---    ---     50%     ---    100    200
Eliminator            ---    ---     ---     50%    120    240
Pyro                  ---    50%     ---     ---    100    200
Fumigator             ---    50%     ---     ---    100    200

Boglord               ---    ---     75%     75%    1500   ---
Eidolon               ---    75%     75%     ---    2500   ---
IceGolem              ---    75%     75%     ---    2500   ---
LichFiend             ---    75%     75%     ---    2500   ---
Nour                  ---    ---     ---    100%    2000   ---

Chthon                ---    ---     ---     ---    2500   ---
Shub-Niggurath        ---    ---     ---     ---    2500   ---

==============================================================================
MOD Features
------------

* New breakable system with 4 different material styles (model+sounds)
* New sprite based particle system added to most items/monsters/models
* New player debuff system with DoT/Poison/Burning effects over time
* New minion spawning system to allow for more dynamic encounter design
* New gib system with unique body parts for most monsters (blood/poison/stone)
* All monster projectiles are variable speed based on player skill level
* Z-aware projectile ability added to some existing/new monsters (low grav aware)
* Two new powerups Sharpshooter and Nail Piercer to work with existing powerups
* MOD settings are maintained between map loads and remembered by savegame
* New HUB/Start map spawning system, can return to 7 unique spawn locations
* New re-spawning system for any item with particle effects and extra options
* Entity state system for switching entities to exact states (on/off/disable)
* Extensive updates to coop item behaviour and new player backpack system 

* The following changes affect ALL monsters:
  + can be setup to spawn when triggered and angry at unique target
  + are affected by liquid damage (slime/lava) check done at feet of model
  + have unique idle and sight sounds setup including during combat
  + sightchecks can changed based on water alpha values (water=1;solid)
  + will check the first 3 death frames for additional damage (LG/SNG)
  + have access to better infighting parameters (focus, pain, damage)
  + all melee attacks check z axis (+/- 64) as well as XY axis distance
  + the speed of range attacks are based on skill level (org base value=hard)
  + will detect and destroy breakable entities in the way (if spawnflags allow)
  + Delayed monster/items can check inventory for new Shotgun/Axe/PlasmaGun
  + new footstep sound system which supports two different feet sounds
  + can be turn into a turret (no movement) with % HP release condition

* monster_dguard, _dcross, _ dfury, _sergeant; new death series of knights
* monster_hogre, _hammer, _mace; new hunter series of ogres (more armour)
* monster_knight/hell_knight stone statue option, need trigger to come alive
* monster_zombiek with slow melee attacks and small leaps, can start lying down
* monster_zombie with extra skins for variety and can start lying down
* monster_boil a slow moving player proximity bomb (can be nailed to floor/walls)
* monster_demon has extra claw and jump checks (height/blocked)
* monster_dog, monster_knight, player, monster_solider new higher detail models
* monster_fish solid state and death counter fixed
* monster_wizard has option to maintain extra height above the player
* monster_gargoyle has independent height target and enemy target
* monster_gaunt is a large pterodactyl creature which fires plasma bolts
* monster_spider with low health and two variants (brown=melee and green=range)
* monster_wraith with health debuff/nail attack, optional minion spawning
* monster_shalrath with extra skins, new effects and optional minion spawning 
* monster_voreling with low health, small jump and bite/frenzy melee attacks
* monster_drole is a high health tentacle tank with dangerous range/melee attacks
* monster_freddie is a high health mutant ogre with burst fire nail/laser attacks
* monster_minotaur is a high health stalking giant with lethal range/melee attacks
* monster_golem is a high health mountain of rock with deadly melee attacks
* monster_army is a low health soldier with many new types of projectiles
* monster_enforcer is mid range soldiers with new skins and more weapons
* monster_defender is a tough enforcer with Super Shotgun and Grenade Launcher
* monster_pyro is a flame obsessed enforcer with large gas tanks
* monster_fumigator is a poison loving enforcer with large gas tanks
* monster_centurion is flying on a hover board and fires plasma bolts
* monster_seeker is a relentless tough robot with rockets, lasers & plasma bolts
* monster_boglord is a special shambler with projectile attacks only
* monster_eidolon is a giant rock demon with summon/projectile attacks
* monster_firetopboss is a custom Chthon encounter with infighting ability
* monster_lichfiend is a tall lich demon with summon/projectile attacks
* monster_nour is a large white wizard with summon/projectile attacks

* func_door has new custom keys and alternative textures on open/close states
* func_train can be nonsolid / models and forward / backward with path_corners
* func_bob bmodel with gently bobbing motion based on angle and new parameters
* func_laser bmodel with damage/block abilities, has on/off/toggle states and sounds
* func_skill bmodel with touch/move functionality, keeps checking skill level
* misc_drip spawns water drip, can be delayed and has special water impact checks
* misc_fireball can be delayed, has variable waits and liquid impact sounds
* misc_model can be added to maps for extra detail (frame/skin/delay/collision)
* misc_shake affects the player/screen, added on/off/toggle states and sounds
* misc_smoke unique model with multiple skins, alpha and ON/OFF states
* misc_spark spawns shower of sparks, has on/off/toggle states and sounds
* misc_explobox/box2 exploding models, added delay/float/dmg/health options
* Multi, Once and secret trigs can check inventory for new Shotgun/Axe/PlasmaGun
* Added all predefined trigger sounds to trigger_once, multi and secret
* trigger_changelevel can be linked to 7 different spawn locations in next map
* trigger_fog changes global fog parameters (density/red/green/blue) over time
* trigger_heal function for creating healing pools or generic healing functions
* trigger_hurt can be delayed and setup to only affect monsters instead
* trigger_ladder can be climbed vertically, has on/off/toggle states and sounds
* trigger_monsterjump can be delayed and only work with certain monster types
* trigger_monsterturret will temporarily turn a range monster into a turret
* trigger_rune can test and fire multiple triggers based on runes collected 
* trigger_setskill can be delayed or triggered to change console skill level
* trigger_teleport can start off and have active sound linked to status (on/off)
* trigger_void can safely remove all/or specific entities upon contact
* Trap shooters upgraded to fire spikes, grenades, rockets, lightning and gas
* Trap shooters require constant trigger to work, have toggle on/off mode as well
* Trap shooters can also track moving targets (func_trains) while firing
* Trap buzzsaw/pendulum models (originally Rogue software) more setup options
* Path_corner system upgrade to support wait/delay and multiple routes
* Extra information (arrow models) for path_corners in developer mode
* QS has changed the SV_AIM default, console variable overrides mod settings
* Can cycle through all info_intermission camera(s) on final screen
* Will trigger events when info_intermission cameras are viewed through
* Will trigger events on most info_player spawn locations when used

* New health models (15/25/100) flasks for medieval/metal and boxes for base worlds
* New ammo box pickup models, multiple skins for world type (medieval/base)
* Shells/Spikes ammo boxes have special lid model while rocket/cells have alt frames
* New alternative ammo box item_plasma, give cells, has multiple frames for diff look
* Cannot pick up any items when notarget is active (testing purposes)
* All keys (base/medieval/runic) and artifacts replaced with better skin/uv versions
* Custom key models (circuit board/base/medieval/runic) available with multiple skins
* All monster/player projectiles updated with better skin/uv setups
* Plenty of extra gib models dropped from monsters (swords, chainsaw, GL)
* Armour model (green/yellow/red skins) has been upgraded with more details
* New misc models added (candle, flame, drips, keys, sparks, smoke)
* New random rotation feature to ammo, health items, flames and candles
* Change the defaults of the MOD with new worldspawn keys:
  + can change item offset and use central rotation point
  + can add/remove player inventory items: weapons, ammo, health and armour
  + can add/remove new shotgun/axe/plasmagun upgrades from inventory 
  + can change Z-aware range parameter for monsters (ogres/zombies)
  + can change the wateralpha (will remain active after finished map)

* Added upgrade to Axe (Based on new axe by MatthewB, new models/sound)
* Added upgrade to Super Shotgun (The Widowmaker by slapmap, new models/sound)
* Added upgrade to Lightning Gun (The PlasmaGun by slapmap, new models/sound)
* The Axe/Shotgun/LightningGun upgrades can knockdown down or kill zombies
* Added option to toggle Shotguns between hitscan and projectile bullets
* When projectile shells or Shotgun upgrade active, Shotgun sounds are replaced
* Added shell casings and particle effects for projectile pellets
* Shotgun/Nailguns have separate muzzle flashes to stop interpolation errors
* Plasma Gun will not discharge when underwater like LG, will not fire instead
* Plasma Gun has 10% chance on a fatal hit (HP<0) to blow up target

==============================================================================
MOD Resource Credits
--------------------

CODE
* QC codebase by Simon OCallaghan (highlighted in QC files if otherwise)
* Started with a Clean QC template based on 1.06 (Cleaned up by AndrewD)
* Additional QC support and loads of helpful advice by CoreyJ
* effectinfo.txt created by SimonOC, with advice and support from Seven
* particlefont.tga created by SimonOC, with support from LordHavoc
* trigger_fog inspired by Honey and misc_stream inspired by Rubicon2
* Inspiration for the new gib system, Marchers Fortress by BenW
* All new GIB models, keys, powerups, projectiles and ammo boxes by SimonOC
* Z aware functionality for ogres/zombies based on code by AndrewD
* misc_shake, misc_drip from RRP, trigger_ladder, func_laser from Rubicon2

MONSTERS
* mon_hogre.mdl, h_hogre.mdl by SimonOC/CoreyJ (hell knight style armour)
* mon_hogremac.mdl, mon_hogreham.mdl by SimonOC/CoreyJ (extra variety)
* mon_knight.mdl, h_knight.mdl by MatthewB (stone skin by Rogue Software)
* mon_dguard.mdl, h_dguard.mdl, mon_dknight.mdl, h_dknight.mdl by SimonOC/CoreyJ
* mon_hknight.mdl, h_hellkn.mdl by ID Software (stone skin by Rogue Software)
* mon_ogre.mdl, h_ogre.mdl by ID Software (Green skin by Rogue Software)
* mon_dfury.mdl, h_dfury.mdl and mon_dfury_glow.mdl by SimonOC/CoreyJ
* mon_dsergeant.mdl and w_blueflail.mdl by SimonOC/CoreyJ
* mon_dog.mdl, h_dog.mdl and player.mdl by Capnbubs
* mon_soldier.mdl by Capnbubs, h_soldier.mdl, +skins by SimonOC
* mon_enforcer.mdl by ID Software, +skins by SimonOC
* mon_centurion.mdl, h_centurion.mdl from rubicon2 MOD, +skins by SimonOC
* mon_pyro.mdl, h_pyro.mdl from rubicon2 MOD, +skins by SimonOC
* mon_boss.mdl by ID Software, Red skin by MatthewB, Green skin by SimonOC
* mon_shalrath by ID Software, green/purple skin by SimonOC
* mon_zombie by ID Software +skins based on ID/Rogue Software work
* mon_zombiek.mdl, h_zombiek.mdl and mon_bossnour.mdl by MatthewB
* mon_boil.mdl model, animation & texture by LManning, sounds from ID zombies
* mon_voreling.mdl and gib model from Quoth MOD (KellMcD/CoreyJ/AndrewD)
* mon_drole.mdl, h_drole.mdl from Quoth MOD with extra gibs by SimonOC
* mon_gaunt.mdl, h_gaunt.mdl from Quoth MOD (KellMcD/CoreyJ/AndrewD)
* mon_spider.mdl by Raven Software, updated animation/green skin by SimonOC
* mon_scorpion.mdl by Raven Software, extra gib models/skins by SimonOC
* mon_gargoyle.mdl by Raven Software, additional gibs cut from main model
* mon_wraith.mdl, gib_wraith1-3.mdl by Rogue Software +skins SimonOC
* mon_jim.mdl,mon_jimrock.mdl based on bob from Quoth; skin/animations by SimonOC
* mon_lostsoul.mdl; model based on skull by id software, skin/animation by SimonOC
* mon_minotaur.mdl by Raven Software, additional gibs/head models by SimonOC
* mon_golem.mdl by Raven Software, skin and additional gibs models by SimonOC
* mon_freddie.mdl, gib_fredjunk.mdl from Quoth MOD (KellMcD/CoreyJ/AndrewD)
* mon_skullwiz.mdl, h_skullwiz.mdl, w_skullbook.mdl by Raven Software
* mon_ogrefish.mdl by Madfox with skin updates by SimonOC
* mon_shambler.mdl, h_shambler.mdl, +4 gib models/skins by RBanninga
* mon_boglord.mdl, h_boglord.mdl, +4 gib models by RBanninga, skins by SimonOC
* mon_bosseidolon.mdl original from Hexen2 by Raven Software, was in ne_ruins MOD
* mon_bosslichfiend.mdl model & skin from RMQ MOD (LManning)
* mon_seeker.mdl, h_seeker.mdl from RRP/Malice (by Quantum Access) Skin by LManning

MISC MODELS
* All breakable bmodels by SimonOC (source map files included)
* b_health_15, b_health_25, b_health_100.mdl by SimonOC, based on BSPs by LManning
* g_nail.mdl, v_nail2.mdl, g_rock.mdl, g_rock2.mdl remade by SimonOC
* g_shot2.mdl, v_nail.mdl, g_nail2.mdl, v_rock2.mdl, g_light.mdl, v_light.mdl models by Stas "dwere" Kuznetsov
* g_shot3.mdl, v_shot3.mdl, g_plasma.mdl, v_plasma.mdl (slapmap.wordpress.com)
* g_zershot.mdl, v_zershot.mdl, riotshot.wav from Zerstorer MOD (not used anymore)
* v_shadowaxe.mdl based on axe from lunsp2 by MatthewB, +skins by SimonOC
* key_base.mdl, key_medieval.mdl, key_runic.mdl rebuilt by SimonOC, originally ID
* g_shot.mdl, misc_spark.mdl, s_spark.spr, key_circuit.mdl from Rubicon2 by JohnFitz
* s_steam.spr, s_flame.spr, steamloop.wav, steamoff.wav from Rubicon2 by JohnFitz
* misc_cable.mdl, misc_dpull_s.mdl, misc_levels.mdl, misc_mooring.mdl, by AndrewD
* misc_oscill.mdl, misc_qwindow.mdl, misc_smoke.mdl, misc_starfield.mdl by AndrewD
* misc_heart.mdl, misc_mushroom.mdl, misc_tape.mdl, by AndrewD (tomeofpreach.wordpress.com)
* s_exp_med.spr, s_exp_big.spr and s_electric.spr from Quoth MOD
* s_exp_plasma_small.spr, s_exp_plasma_big.spr from Marcher MOD by BWooding
* s_exp_poison_small.spr, s_exp_poison_med.spr re-coloured vers from Marcher/Quoth MOD
* misc_chain.mdl, s_dripblue.spr and s_dripsplblue.spr from RRP/RMQ mod by LManning
* s_dripred.spr, s_dripsplred.spr, s_dripgreen.spr, s_dripsplgreen.spr recolored by SimoOC
* all bubble/dot sprite particles by SimonOC (bubbles Originally ID)
* armour.mdl, flame.mdl remade by SimonOC, originally ID
* misc_radar64.mdl, _radar96.mdl and _radar128.mdl model+skin by SimonOC
* misc_candle1-3.mdl based on original model by Rogue Software, remade by SimonOC
* trap_pendlong.mdl, trap_pendshort.mdl, trap_buzzsaw.mdl by Rogue Software
* misc_bonepile.mdl, _skull.mdl, _stickskull1/2.mdl by Raven Software, +skins by SimonOC
* misc_flag.mdl, misc_lantern.mdl, misc_seaweed.mdl by Raven Software, +skins by SimonOC
* misc_tutstatue.mdl, misc_tree.mdl by Raven Software, +skins by SimonOC
* misc_lightpost.mdl, misc_lighttube.mdl from Quoth, misc_fixture1.mdl from Rubicon2
* explode_box1.mdl & _box2.mdl based on model by id, with skins by rubicon2 / Quoth MOD
* misc_madfish.mdl based on the original fish model by MadFox (single loop)
* artifact_piercer.mdl, artifact_sharp.mdl model by SimonOC, +skins by MatthewB
* artifact_envsuit.mdl, model by id Software, +skins by SimonOC
* artifact_wetsuit.mdl, model by Ritual Software, +skins by SimonOC
* misc_tree2.mdl model+skin by MatthewB
* misc_doomhelm.mdl model+skin by RenierB

SOUNDS
* Spider, Gargoyle, Golem & Minotaur sounds by Raven Software, cleaned up by SimonOC
* Scorpion sound effects by Valve Software, renamed and mixed to suit Quake
* Bob, Drole, Freddie, Gaunt, Voreling and few enforcer sound effects from Quoth MOD
* nofire, secret3 and demonwind sounds from Marchers Fortress by BenW
* All ladder sounds (metal/wood/rope) from (www.freesound.org) mixed by SimonOC
* New gib sounds are originally from UT (except stone stuff)
* New SG/SSG and Lost soul sound effects from Doom by Id Software
* generator_gas, lowboom, machine_loop1, machine_loop2 from RRP mod
* new ambience sound directory from many different sources
  + some from (www.freesound.org) mixed by me with Goldwave
  + All windgust, thunder and rubble sounds made by Marauder
  + All liquid sounds from Quake3 by Id software, I know, they are so good!
* All breakable initial/impact sounds from Quoth MOD (KellMcD/CoreyJ/AndrewD)
* Wraith and misc_shake sounds by Rogue Software, mixed by SimonOC using Goldwave
* Seeker sound effects made from samples at freesound.org by Hybrid_V
* Eidolon sounds mostly from ne_ruins mod, a couple from freesound.org
* Wetsuit sounds by Ritual Software, remixed by SimonOC using Goldwave
* spaceship_fadein.wav, spaceship_fadeout.wav (www.sonniss.com) GDC 2016 Audio Bundle

ARTWORK
* Moonrise skybox made with Terragen 3.x by SimonOC
* Interstellar, Swampn and Violent skybox made by Hipshot
* Snowmoon from Kothic Skybox Compilation made by KellMcD
* Daikatana (DK3) stone textures (ad_test4, start) by Ion Storm
* Egyptian stone textures (ad_test6) by Rogue Software, +extra added
* Hexen2 stone/trim textures (ad_magna) by Raven Software, +extra added
* Knave brick/library texures (ad_test7) by KellMcD, +extra added
* SpeedBaze base texture (start, ad_crucial) by Speedy, +extra added
* Various base textures (ad_crucial) by Impel Development Team
* New GFX menu artwork created by SimonOC tweaked by Sven Ruthner

==============================================================================
Record of changes to MOD (version number included)

v1.50 Patch 1 Notes
-------------------
* Changed all monsters to use same sound channel for pain/death sounds
* Added spawnflags option to monster_golem for melee/stomp version only
* Added special gib sound for stone enemies (just a pile of rubble)
* Changed infighting formula (ai_combat.qc) to be closer to id setup
* Changed icegolem boss to ignore damage before trigger wakeup
* Fixed compiler error in mon_bossicegolem.qc function iceg_tranB13
* Fixed monster_shalrath not removing voreball attachment when in pain

v1.50 Notes
-----------
* Added corner_speed override for updates to path_corner entities
* Added func_button spawnflag option to start in disabled entity state
* Added separate impulse/server command for projectile shotgun casing
* Added trigger_clientmsg to display messages regardless of trigger source
* Added bouncegrenade entity key allow bounce grenades off monster bodies
* Changed rocket/cell resistance visual language to no blood for 100% resist
* Added monster_seeker a base version of the shambler with laser/rocket attacks
* Added wood/glass/metal gib impact sounds, updated gib touch impact system
* Added extra text body strings to misc_textbook to fix Quark editor issues
* Added misc_dknight for dead death knight posing and shadow axing
* Added monster_ogre_fishing a passive monster that likes to fish a lot!
* Random lying down rotation for zombie+knights with angle key=0 or <1
* Added new poisonous setup to demon/shambler with debuff and different skins
* Added new animated lightning projectile to shambler (designed for new model)
* Added trigger event (target2) to monster_seeker shield turning off
* Added optional falling damage to trigger_hurt (velocity speed def=300)
* Updated g_rock.mdl and g_rock2.mdl weapon G model pickups to HD version
* Changed all monster_seeker gibs to models (was using metal breakables)
* Changed coop monster combat & classic infighting to prevent target deadlock
* Changed coop dropped backpacks to never despawn (default was 120s)
* Changed coop player backpacks to drop all weapons, ammo, keys, armour
* Changed coop centerprint messages from triggers to display on all clients
* Changed coop weapon pickups to respawn after 5s and give weapon ammo pickup qty
* Changed coop weapon pickups to only give extra ammo if < 50% of max ammo type
* Changed coop weapons/keys to never respawn if entity key respawn_time < 0
* Changed coop weapons to always fire any triggers on them once
* Changed coop spawn points to work with entity state system, can be switched on/off
* Changed coop spawn points to always trigger target(s) once when used
* Changed coop spawn points not to include player start if coop points exist
* Added Impulse 150, Coop players can drop artifacts in backpacks (def=off)
* Added Impulse 155, all ammo boxes will respawn in coop mode (def=off)
* Added coop colour (purple) to debug diamond system to show cooponly entities
* Added coop console warning message for items with unreliable triggers
* Added cooponly/nightmare entity key to items, monsters, triggers & func entities
* Updated cooponly entity key, -1 = will not spawn in coop mode (all items)
* Added monster_freddie a mutant ogre with blade and nail/laser gun
* Added wakeup trigger to monster_ogre_fishing for special events
* Added trigger_nomonjump to stop/delay jumping monsters from jumpin!
* Added damage multiplier option to func_breakable for monster damage
* Added new entity key 'bodystatic' to stop skull wizards from teleporting 
* Added monster tether system to allowing guarding of map areas
* Added target2 to func_rotate_door to solve lighting issues
* Added silent sound option to func_rotate_door to reduce sound distortions
* Added storybook controller and text book chapter system 
* Added support for QuakeSpasm-Spike engine and weather effects
* Updated misc_smoke DP particle effects to use custom velocity
* Added support for spawning volumes to the DP forcefield particles
* Updated misc_fireball with slime green option for slimey pits
* Changed monster_drole to no longer have shell/shotgun resistance
* Changed stone knight/hellk from 80% to 50% nail resistance
* Changed Hammer Ogre to be more aggressive with attacks and resist pain
* Changed Shamblers to be lightning turrets on Nightmare (ID behaviour)
* Added monster_chthon, _shub and _shubupsd customizable ID bosses
* Added trigger_touchsound for fake water touch sounds and movement
* Added yaw_speed variable to trigger_heal/_hurt to change bubble speed
* Fixed mouse scroll wheel affecting footstep sounds for player
* Fixed telefrag problem, all bosses are immune, except shub!
* Changed player footstep sound to be quieter and more random
* Added red spark colour option (spawnflag) to misc_spark entity
* Fixed effects flag on monster/items is saved and restored when active
* Fixed hammer/golem impact attack to be limited +/- 128 units vertically
* Added trigger_fog functionality to info intermission camera system
* Added start disable function to func_plat (spawnflags=32)
* Added new entity state AFRAME for animated textures (func_wall only)

v1.49 Notes
-----------
* Changed projectile meat to use same parameter format as projectile smoke
* Lowered monster_boil radius damage from 100 to 60 (more forgiving)
* Added particle effects to gibs, only works with special type 1
* Added entity boss flag and fixed missing client death messages
* Fixed monster targets after combat, stop them wandering towards 0,0,0
* Added missing attack offset vector for centurion, gargoyle, gaunt and jim
* Changed many monsters to use facing vector instead of center for sight checks
* Changed monster_dsergeant to fire homing missiles more and be aggressive
* Changed homing missiles to allow impact on owner (no owner dmg, just splash)
* Added monster_boglord a special event in the dungeon for ad_sepulcher
* Fixed trigger_monsterjump only working for specific monster types
* Added blood and slime to misc_drips, selected by different spawnflags
* Added debug diamonds; blue=delay spawn, green=no monster count, red=nightmare
* Changed monster_voreling to jump further at the player (400 -> 500)
* Added poison debuff attack to poisonous spider (Green large one)
* Added poisonous gibs, blood and explosive attack damage to monster_boil
* Changed poisonous monsters to bleed green blood particles instead of red
* Fixed problem with misc_model not randomly selecting from a range correctly
* Added projectile dust models to trigger_explode (directional velocity)
* Added custom particle emitter colours for custom keys using message2
* Added second (randomly picked) sound option to ambient_custom_sound
* Added triggered targets to ambient_custom_sound each time sound is played
* Added option to ambient_custom_sound to not silence sound if switching off
* Changed many monsters to be locked in pain animations if using shadow axe

v1.48 Notes
-----------
* Fixed func_secretdoor def angles being changed from '0 0 0' to '0 90 0'
* Updated mon_shalrath skins (1=regular,2=green,3=purple) to be more unique
* Added new skin (1=blue, 2=yellow) to misc_fixture for fifth map
* Updated documentation about monster bodyflrcheck and bodyfadeaway keys
* worldspawn replace_hknight and replace_ogre keys no longer valid
* Added monster_hell_pointknight special event for noel/andrey map
* Replaced Shambler head and gib models with new versions (+blood trails)
* Fixed misc_particle being able to switch state before setup finished
* Fixed trap_lightningshooter to play hit sound every 0.6s instead of 0.1s
* Added random XYZ wobble to trap_lightningshooter source and target
* Changed trap_lightningshooter to not spawn if target is missing (required)
* Added blue particle effect to trap_lightningshooter on impact (spawnflag)
* Added dust/smoke velocity impact to trap_lightningshooter (spawnflag)
* Added error message to monsters, cannot delay spawn without targetname!
* Added new entity key nospawndamage for monsters to prevent telefrag damage
* Added telefrag death checks for breakables exclusions (noshoot, nomonster)
* Added frame_override key to func_door for alternative texture switching
* Added jim rocket type to trap_rocketshooter (lower damage player rocket)
* Fixed sprite explosion sound being played on previous temp sprite intead
* Added spark once (automatic switch off) to misc_spark (wait=-1)
* Added random rotation of spark burst on Y axis to misc_spark (angle=-1)
* Fixed gargoyle not using spawnangry, angrytarget or pathing when waking up
* Changed all lightning damage (except player) checks to new function
* Changed trigger_fog wait (re-trigger) cannot be less than speed (fade time)
* Added custom sound (noise key) option to trigger_push entity
* Added new gib projectile move style MON_GIBEXPLOSION for more impact
* Changed gib spawn origin formula to cope with larger bounding boxes
* Boss fights Nour/Eidolon reset health each wave to prevent excessive dmg
* Added Eidolon boss fight with multiple waves and minion support (ad_stone)
* Added brktrignoplayer to func_breakable, prevents damage from players
* Added spawnflags = 16 to trigger_monsterkill to use death function instead
* Added check for death function to trigger_monsterkill before using it
* Changed all stone statues to check health before using waking up trigger
* Added th_die functionality to all stone statues for trigger_monsterkill
* Added 10 extra scale frames to misc_heart.mdl and misc_skull.mdl
* Added misc_doomhelm.mdl for super secret locations (3 poses & 3 skins)
* Added mon_fish.mdl from rmq/rrp with squashed head fix and smaller version
* Added mon_boil monster, proximity mine with tarbaby like explosive damage

v1.47 Notes
-----------
* Fixed old ID particle explosion for rockets (was broken based on type)
* Changed func_buttons are moved to their finished position when disabled
* Updated Super Shotgun G model with new version by Dwere (kept ID V model)
* Added new particle effect Implosion for monsters and items (code function)
* Finished Nour boss fight with multiple waves and minion support (ad_azad)
* Added trigger event on dead bodies which are gibbed via the shadow axe
* Fixed range attack for green spider with proper elevation tracking
* Added large purple voreling with range attack (same as green spider)
* Fixed path_corner targetback override key (was searching wrong field)
* Added delay to radius explosion on breakables to prevent endless loops
* Skull Wizards have gib state (-40 HP) they will explode into dust!

v1.46 Notes
-----------

* Fixed Shambler lightning bolt will damage breakables if LOS blocked
* Fixed enemy target problems with Firetop Mountain Chthon
* Added particle effect to base of Firetop Chthon body
* Changed particle_debuff to allow for custom volume range
* Added trigger_monsterattack entity to create infighting sequences
* Added missing trigger point entities to ad_quake.fgd
* Added Cameramode and solid options to info_intermission entity
* Fixed wetsuit artifact not being reset when intermission active
* Fixed func_plat/func_door entity state off not stopping movement sounds
* Changed zombie knight sight sound from zombie idle to red knight instead
* Changed all sprite explosion files and setup equivalent DP versions
* Added DP poison and stone blood decals, re-arranged particlefont.tga file
* Added more DP specific particle effects especially for poison attacks
* Fixed DP blood trails only affecting blood gib types (not stone/poison)
* Added damage ability to gib model touch function (new code parameters)
* Changed trigger_explode to cope with more types (fire/plasma/poison)
* Changed Lost Souls to have variable (small/med/large) sized explosion death
* Changed Tarbaby explosive death damage can be changed with death_dmg key
* Added Tarbaby with poison attack instead of direct damage, has 8 new skins
* Added new monster_fumigator, which is a poisonous pyro who loves slime!
* Added respawn particle effect to items which start off (reqs respawn flag)
* Fixed instant respawn items (respawn_time=-1) to check respawn counters
* Updated the MOD GFX directory with replacement LMP files (esp help)
* Added misc_player for dead marine posing and axing, extra 8 skins + blood

v1.45 Notes
-----------

* Added entity state spawn value to func_buttons (on/off/reset) 
* func_doorsecret can move up/down for second phase (angle=-1/-2)
* Moved external bmodels from maps to subdirectory (bmodels)

v1.44 Notes
-----------

* Added global/individual bodyfadeaway function for all monsters
* Created global floor check function for monsters, gibs and breakables
* Added floor check for all items with new entity key (simulate gravity)
* Added global variable for monsters using floor check function
* Changed gibs/head, breakable models to always use the floor check function
* Changed gibs to keep touch function alive for additional sound triggers
* Added new artifact wetsuit, player can breath underwater for 5mins/300secs
* Fixed wetsuit giving env suit screen tint and not resetting afterward
* Fixed frame_box entity key for rockets/plasma -1=random, 0-7=exact
* Placeholder menu graphic images (will change over coming weeks)
* Added new impulse command, 145 cycles through intermission cameras

v1.43 Notes
-----------

* Fixed gravity variable on worldspawn to be set correctly
* Fixed nightmare skill allowing zombies to be gibbed
* Updated shambler to new HD shambler model + head gib
* Added forcefield particle effect to func_laser (new variables)
* Added bmodel source detection for particle emitters
* Added worldtype override to keys and doors messages
* Added timed switch off mode to all trap_shooter entities
* Added timed switch off mode to misc_particle_burst entity
* Fixed func_laser to create a sound emitter for on/off sounds
* Changed Gaunt to fall properly after death (like wizard body)
* Changed standing monsters to fall if floor surface is changed
* Monster dead bodies, heads and gibs can fall if floor surface is changed
* Falling dead monster bodies interact with _void,_hurt,_push and sawblade
* Backpack items (temporary and placed) can fall if floor changes
* Fixed pendulum default damage to 5, use -1 for no damage option
* Fixed voidsmoke_dn.tga dimensions from 1022x1024 to 1024x1024

V1.42 Patch 2 Notes
-------------------

* Added two new remix maps (ad_e1m1 and ad_e2m2) to the start map
* Fixed sprite particle system reaching limit and not going back down
* Added new quake.rc option to stop all global fog command/functions working
* Updated various models in progs directory to work with winQuake clients
* Added think/nextthink reset to monster_death_precheck to stop animation errors
* Added think/nextthink reset to entity_hide to stop animation when hidden
* Fixed remove(self) code problems with _once, _multi, _hurt and misc_bubble
* Added variable (cnt) override for all item_artifacts expiration timers
* Client debuff pain sounds can be blocked by god/pentagram mode
* Moved lost souls death radius explosion to second death frame
* Added more enemy/health checks to crossbow knight attack functions
* Fixed ceiling spider/Voreling for QuakeSpasm and Darkplaces engines
* Spider and Voreling melee range changed from 50 to 60 (diagonal bbox problem)
* Pyro flame sprite movetype changed to fat missile type for monsters
* Pyro correctly aims flames at smaller targets and resets ricochet effect
* Changed zombies to die after 30s if blocked trying to get up off the floor
* Can now switch weapons (via keys 1-8) while firing (was locked before)
* Fury Knight triple rocket attack changed to 20 direct and 20 splash
* Soldier shotgun/rocket/plasma can now drop exact amounts of ammo
* Fixed zombie/knights idle sound not being blocked via spawnflag
* Fixed nomonstercount not being read properly when monster dies
* misc_builtineffects now plays any associated sounds on self or target
* Fixed misc_particle_burst particle count being reset after trigger
* item pickup triggers for weapons now fires once when playing co-op

V1.42 Patch 1 Notes
-------------------

* Added transparent texture support for DP
* Updated breakables for ad_crucial, ad_swampy, ad_test3
* Fixed ad_crucial so that the rune room does not lock
* Fixing bounding boxes for misc/func exploding boxes
* Removed FTE engine detection (simplified to DP/Fitz)
* Changed pixels command to understand default=blurry
* Added DP laser particle effect (TR_LASER)
* Removed EF_DIMLIGHT from plasma/laser for DP
* Added plasma burn explosion for DP (large cloud effect)
* Added altar (red/grey) DP (floating upward dots/smoke)
* Fixed skill pillar directional particles for DP
* changed misc_drip movetype to prevent engine splash sound
* Fixed extra global fog parameters for ad_end in DP
* Changed trigger_heal/hurt bubbles to be noclip instead of fly
* Fixed spiders/voreling dropping from ceiling properly in DP
* Gaunt projectile speed - old (600/600/600/600) new (500/650/800/950)
* Gargoyle projectile speed - old (500/550/600/650) new (500/650/800/950)
* Minotaur projectile speed - old (500/600/700/800) new (500/650/800/950)
* Ceiling spiders are broken with patch 1 for QuakeSpasm Engine

==============================================================================
copyright:        Please do not use any of these assets in ANY COMMERCIAL PROJECT.
                  Remember to give credit if you use any of these assets.

engine:           Designed and tested to work with the following engines:

QuakeSpasm http://celephais.net/board/view_thread.php?id=60452
DarkPlaces https://icculus.org/twilight/darkplaces/

==============================================================================
Distribution / Copyright / Permissions 

The QC files in this MOD are based on 1.06 source files by ID Software.
These files are released under the terms of GNU General Public License v2 or
later. You may use the source files as a base to build your own MODs as long
as you release them under the same license and make the source available.
Please also give proper credit. Check http://www.gnu.org for details.

Quake I is a registered trademark of id Software, Inc.

All of these resources may be electronically distributed only at 
NO CHARGE to the recipient in its current state and MUST include this 
readme.txt file.

===========================================================================
