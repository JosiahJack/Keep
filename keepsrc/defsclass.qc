//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: All, but originally Arcane Dimensions (AD)
//
//
// Distribution / Copyright / Permissions 
//
// Please do not use any of these assets in ANY COMMERCIAL PROJECT.
// and remember to give credit if you use any of these assets. Please credit
// the appropriate authors of the various content used.  Refer to the credits
// folder.
//				  
// The QC files in this MOD are based on 1.06 source files by ID Software.
// These files are released under the terms of GNU General Public License v2 or
// later. You may use the source files as a base to build your own MODs as long
// as you release them under the same license and make the source available.
// Please also give proper credit. Check http://www.gnu.org for details.
//
// Quake is a registered trademark of id Software, Inc.
//
// All of these resources may be electronically distributed only at 
// NO CHARGE to the recipient.
//
// Stats:
// Entity count: 0
// Function count: 0
//
// Implements: Classgroup and Classtype System
//
// Description:
// Defines the integer value classtype as a unique identifier for an entity
// type.
//
// Defines the integer value classgroup as a unique categorical identifier.
//=============================================================================

.float		classtype;			// Class type - used for quick reference
.float		classgroup;			// Class group - used for quick reference
.float		classmove;			// 1=Walk, 2=Fly, 4=Swim

// Unique Class Groups for quicker searches (mostly items).  Previous system used classname (slow string search).  Monster classgroups are useful for infighting grouping checks
float CG_LIGHTS = 70;			// All light type entities
float CG_HEALTH = 100;			// All health pack types (15/25/+100)
float CG_AMMOITEM = 200;		// All ammo items/packs
float CG_PROJALL = 205;			// All monster projectiles
float CG_PROJSHELLS = 210;		// To help with combining shell damage
float CG_PROJNAILS = 220;		// Testing ammo resistance in t_damage
float CG_PROJLAVANAILS = 221;	// Testing ammo resistance in t_damage
float CG_PROJROCKETS = 230;		// Includes homing missiles
float CG_PROJMULTIROCKETS = 231;// Includes homing missiles
float CG_PROJGRENADES = 235;	// Separated for extra testing
float CG_PROJBOLTS = 236;		// Crossbow bolts
float CG_PROJBOLTSPOISON = 237;	// Poisoned Crossbow bolts
float CG_PROJBLOODCRYSTALS = 238;// Sanguinators
float CG_PROJVOID = 239;		// Void Staff
float CG_PROJCELLS = 240;		// Mainly used for plasma
float CG_PROJPLASMAROGUE = 241;	// Just for the Rogue Plasma lightning ball
float CG_PROJHAZARD = 242;		// Hazard projectiles (flame/plasma)
float CG_PROJMAGIC = 243;		// Elemental Mana attacks and other magic projectiles
float CG_PROJICE = 244;			// Cold stuff like Elemental Tome, Snowman snowballs, Ice Golem rocks
float CG_MINIONEGG = 245;		// Special minion eggs
float CG_PROJFIRE = 246;			// Anything that can catch other things on fire.
float CG_WEAPON = 250;			// All weapon items
float CG_PROGRESSION = 260;		// All progression items
float CG_ARMOR = 275;			// All armor types
float CG_KEY = 300;				// All keys (gold/silver/custom)
float CG_RUNE = 310;			// All runes 1-4
float CG_ARTIFACT = 350;		// All powerups
float CG_TRAPS = 400;			// Endless supply of traps!
float CG_MISCENT = 410;			// All misc entity types
float CG_TEMPENT = 420;			// All temporary types (gibs, smoke, sparks)
float CG_BREAKABLE = 430;		// All breakable types
float CG_TRIGGERS = 440;		// All trigger types (bmodels)
float CG_TARGETS = 445;			// All target types
float CG_FUNCMOVER = 450;		// All FUNC movers
float CG_HIPROTATE = 460;		// All Hipnotic rotation stuff
float CG_MONSTERS = 500;		// Default
float CG_ARMY = 600;			// (4) Shotgun, Rocket Launcher and Plasma
float CG_ENFORCER = 610;		// (5) Standard, Grenade and Flame, Pyro, Centurion
float CG_DEMON = 615;			// (3) Demon, Drole, Minotaur, Boglord, Lichfiend, Hephaestus
float CG_DOG = 620;				// (1) Dog
float CG_FISH = 625;			// (2) Fish
float CG_ROBOT = 630;			// (2) Jim, Laser/Rocket, Seeker, Floyd
float CG_KNIGHT = 635;			// (7) Knight, Death Guard and Crossbow, Bandit, Goblin, Rebel, Archer
float CG_DKNIGHT = 637;			// (2) Hell and Death Knight
float CG_DCAPTAIN = 640;		// (4) Fury, Sergeant Captains, Bane, Brigade Commander
float CG_STONE = 645;			// (4) Boss Eidolon, Statues and Golem
float CG_OGRE = 650;			// (4) Vanilla and Hunter (Chainsaw, Mace, Hammer), Freddie
float CG_SPIDER = 660;			// (4) Shalrath, Vorling, Wraith, Spider, Snakeman
float CG_SHAM = 666;			// (1) Shambler
float CG_SPAWN = 670;			// (2) Blue/Green, Boil
float CG_WIZARD = 680;			// (10) Wizard, Gargoyle, Gaunt, Skull Wizard, Skull, Nour, Necromancer, Acolyte, Warlock, Sorcerer
float CG_ZOMBIE = 685;			// (3) Zombie, Knight, Mummy
float CG_XMAS = 686;			// (4) Elf, Raindeer, Snowman, Santa
float CG_BOSS = 690;			// (3) Cthon, Old one, Anaconda
float CG_DRAGON = 695;			// (9) Rogue Dragon, Drake Dragons (7 variants), Drake Dragon King
float CG_HARMLESS = 777;		// (1) Sheep, Frogs, Ogles, Bees, Ravens

// Unique Class Types for quicker entity searches.  Previous system used classname (slow string search)
float CT_WORLD = 1;				// World entity
float CT_SPAWNSP = 10;			// Spawn location - Single Player
float CT_SPAWNCOOP = 11;		// Spawn location - Coop
float CT_SPAWNDM = 12;			// Spawn location - Deathmatch
float CT_CONTROL = 15;			// Controller entity
float CT_CAMERA = 16;			// Camera entity (info_intermission)
float CT_MISCCAM = 18;			// Misc Camera entity
float CT_LIGHT = 20;			// Light entity
float CT_LIGHTSTATIC = 21;		// Static light entity
float CT_SOUNDEMITTER = 22;		// Sound emitter
float CT_DEVMARKER = 24;		// Developer model marker
float CT_PATHCORNER = 26;		// Standard path nodes

float CT_ENEMYTARGET = 30;		// Target enemy for flying enemies
float CT_ATTACHMENT = 32;		// Attachment for entities
float CT_TETHERENT = 33;		// Code generated tether point
float CT_ESTATE = 34;			// Entity state modifier
float CT_MAPVAR = 35;			// Map Variable logic

float CT_PARTICLE = 40;			// A particle
float CT_PARTICLEEMIT = 41;		// A particle emitter
float CT_PARTICLECONT = 42;		// Particle controller (setup particle banks)
float CT_PARTICLETEMP = 45;		// Particle emitter template

float CT_TEMPGIB = 50;			// Temporary entity (gib)
float CT_TEMPPHYS = 51;			// Temporary entity affected by physics triggers
float CT_TEMPSPARK = 52;		// Temporary entity (spark)
float CT_TEMPSTREAM = 53;		// Temporary entity (stream)
float CT_REFLECTLIGHT = 54;		// Reflection entity (Lightning)
float CT_REFLECTPLASMA = 55;	// Reflection entity (Plasma)
float CT_TEMPTRIG = 56;			// Temporary trigger (touch)
float CT_SUMMONLIGHT = 57;		// Summon entity (Lightning)
float CT_STORYBOOK = 58;		// Story book for the player
float CT_STORYCONTROL = 59;	// Controller for story system
float CT_STORYCHAPTER = 60;		// Story chapter for story system

float CT_TARGETDUMMY = 90;		// Misc target dummy
float CT_TARGETNUMBER = 95;		// Misc number drawn ingame
float CT_MONKARASUSPELL = 96;	// Spell targets for Karasu, by Redfield

// Class Types for all monsters 
float CT_MONARMY = 100;			// Army Soldier
float CT_MONARMYAXE = 101;		// Axe Grunt
float CT_MONNEMESANT = 102;		// Zerstorer Nemesant plus Drake additions
float CT_MONARCHER = 103;		// Hexen2 Archer from Drake
float CT_MONVOMITUS = 104;		// Vomitus from Qtest (Drake version)
float CT_MONRYU = 105;			// Red Dragon from Drake
float CT_MONWYRM = 106;			// Green Dragon from Drake
float CT_MONSHADE = 107;		// Nightshade Dragon from Drake
float CT_MONBARON = 108;		// Baron from Drake/SOE
float CT_MONSUPERGRUNT = 109;	// Super Grunt from Kinn
float CT_MONENFORCER = 110;		// Enforcer
float CT_MONSENTINEL = 111;		// Sentinel from Quoth 2
float CT_MONWILLYSPIDER = 112;	// Willy the Spider
float CT_MONSNAKEMAN = 113;		// Snakeman
float CT_MONFLOYD = 114;		// Floyd robot
float CT_MONDEMON = 115;		// 2 clawed fiend
float CT_MONNECRO = 116;		// Necromancer from Drake
float CT_MONACOLYTE = 117;		// Acolyte from Drake
float CT_MONWARLOCK = 118;		// Warlock from Drake
float CT_MONSORCERER = 119;		// Sorcerer from Drake
float CT_MONDOG = 120;			// 4 legged friend
float CT_MONBANDIT = 121;		// Drake bandit
float CT_MONDRAKEGOBLIN = 122;	// Drake goblin
float CT_MONFANGEL = 123;		// Hexen2 Fallen Angel
float CT_MONFANGELLORD = 124;	// Hexen2 Fallen Angel Lord
float CT_MONFISH = 125;			// Fish fish fishy
float CT_MONOCTOPUS = 126;		// Octopussy little cuty (Madfox)
float CT_MONHYDRA = 127;		// Hydra from Hexen 2 - added to extras_r5 by khreathor - using extras_r5 version
float CT_MONDYONG = 128;		// Mini Shub with extra tentacles Four Feathers MOD (Madfox)
float CT_MONFROG = 129;			// Fragy froggy frog (Madfox) - DENIZEN!
float CT_MONHELLK = 130;		// Strong spikey Knights
float CT_MONREBEL = 131;		// Rebel (crossbow bandit from Drake)
float CT_MONSHEEP = 132;		// Sheep from Hexen 2 - DENIZEN!
float CT_MONOGLE = 133;			// Ogle from Heretic 2 - DENIZEN!
float CT_MONRAVEN = 134;		// Raven from Redfield's Ravenkeep - DENIZEN!
float CT_MONBEEZ = 135;			// Beez swarm (Madfox) - DENIZEN!
float CT_MONSABERENFORCER = 136;// Saber Enforcer
float CT_MONSPIRIT = 137;		// Ghostly invisible sword warrior, Redfield's eyes version
float CT_MONKARASU = 138;		// Lord Karasu the Master of Raven Keep! by Redfield
float CT_MONWOLF = 139;			// The Moonlight Guardian! by Redfield
float CT_MONKNIGHT = 140;		// Small metal Knights
float CT_MONCARNIVEAN = 141;	// Carnivean Serpentine Knight
float CT_MONREIVER = 142;		// Reiver from Quake 1.5 mod
float CT_MONHUNTRESS = 143;		// Elena the Blood Huntress! by Redfield
float CT_MONMANTICORE = 144;	// Manticore / Lich Fiend
float CT_MONDLORD = 145;		// Death Lord from Quoth
float CT_MONARCHERLORD = 146;	// Hexen2 Archer Lord from Drake
float CT_MONBEARD = 147;		// Beard from Nehahra
float CT_MONMISTERMAX = 148;	// Mister Maxwell, aka the mister, boss from Nehahra
float CT_MONNEHAHRA = 149;		// Nehahra, boss from Nehahra
float CT_MONOGRE = 150;			// Chainsaw wielding manics
float CT_MONOGREFISH = 155;		// Madfox fishing ogre
float CT_MONSHAL = 160;			// Shalrath / Vore
float CT_MONSHALBOSS = 161;		// Shalrath Mother
float CT_MONSHAM = 165;			// Shambler
float CT_MONBOGLORD = 166;		// Lord of the Bog! (Big shammy)
float CT_MONSHAMVILE = 167;		// Sha'Vile, Drake's shamvile black shambler with archvile powers.
float CT_MONSPAWN = 170;		// Bouncing annoying crudblossom!
float CT_MONWIZARD = 180;		// Wizard / Scrags
float CT_CACHEWIZARD = 181;		// Special entity for precache of assets
float CT_MINIONWIZARD = 182;	// Minion Spawning version for Nour Boss
float CT_MONZOMBIE = 185;		// Rotten flesh
float CT_MONZOMBIEK = 186;		// Undead Knights
float CT_MONCYBERDEMON = 187;	// Doom Cyber Demon
float CT_MONHELLHOUND = 188;	// Hell Hound
float CT_MONANACONDA = 189;		// Anaconda
float CT_MONIDCHTHON = 190;		// ID Software Chthon
float CT_MONXXCHTHON = 191;		// Mapper Custom Chthon
float CT_MONFIRETOP = 192;		// Firetop Mountain Chthon
float CT_MONIDSHUB = 195;		// ID Software Shub-Niggurath
float CT_MONXXSHUB = 196;		// Mapper Custom Shub-Niggurath
float CT_MONNOUR = 197;			// Nour Boss
float CT_MONVIRTUS = 198;		// Virtus worm boss
float CT_MONINQUISITOR = 199;	// Inquisitor boss for Twilight of the Idols
// New (death) Knight series (sock/necros)
float CT_MONDGUARD = 200;		// HD Knight (Guard)
float CT_MONANACONDACOIL = 201;	// Anaconda coils
float CT_MONSPELLMAS = 202;		// Baseboss from madfox's Phantom Pholly map (very similar but not the same as Virtus boss)


float CT_MONDCROSS = 205;		// HD Knight (Crossbow)
float CT_MONDFURY = 210;		// HD Knight (Fury)
float CT_MONDFURYBOSS = 211;	// Brigade Commander (Quake 1.5)
float CT_MONDBLOOD = 215;		// HD Hell Knight (Blood)
float CT_MONDKNIGHT = 220;		// HD Hell Knight (Death)
float CT_MONDPRINCE = 221;		// HD Hell Knight (Prince)
float CT_MONWARLORD = 222;		// Quake 1.5 Warlord


float CT_MONDSERG = 225;		// HD Hell Knight (Sergeant)
float CT_MONCOMM = 230;			// HD Hell Knight (Commander)





// New (hunter) Ogre series (sock/necros)
float CT_MONHOGRE = 250;		// HD Ogre (Chainsaw)
float CT_MONHOGREMAC = 255;		// HD Ogre (Mace)
float CT_MONHOGREHAM = 260;		// HD Ogre (Hammer)

float CT_MONENF_GUNNER = 268;	// Chaingunner Enforcer
float CT_MONARMYDBSHOTGUN = 269;// Army Soldier Elite Red fires double barrel shotgun, from Drake.
float CT_MONARMYROCKET = 270;	// Army Soldier (Rocket) // New base monster series (Inspired by lunaran/Quoth)
float CT_MONARMYGRENADE = 272;	// Army Soldier (Grenade)
float CT_MONARMYPLASMA = 275;	// Army Soldier (Plasma)
float CT_MONARMYSPIKE = 276;	// Army Soldier (Nail)
float CT_MONARMYCYBORG = 277;	// Army Soldier (Perforator)
float CT_MONBANE = 278;			// Drake Bane boss
float CT_MONDARKLORD = 279;		// Drake Dark Lord boss
float CT_MONDEFENDER = 280;		// Enforcer SSG/GL (Defender)
float CT_MONSUPERENFORCER = 284;// Lieutenant Enforcer, red with perforator from back2forwards by The Lieutenant
float CT_MONELIMATOR = 285;		// Enforcer Plasma (Eliminator)
float CT_MONMEGAFORCE = 286;	// Mega Enforcer (Plasma+Rocket)
float CT_MONDEFLECTOR = 287;	// The Deflector (Plasma+Rocket)
float CT_MONPHOBETOR = 288;		// Final giant cloaked boss
float CT_MONPSYDER = 289;		// Large floating spawner mini boss
float CT_MONMANGLIOCH = 290;	// Strange floating alien creature Nehara MOD (Mindcrime)
float CT_MONJUSTICE = 291;		// Large knight with flat sword



float CT_MONTURRETB = 295;		// Large ball surface turret // Bal MOD (Bal)
float CT_MONSWEEPER = 296;		// Knight size floating mine layer
float CT_MONMAMMOTH = 297;		// Large two stage mini "the fridge" boss
float CT_MONTHUMPER = 298;		// Regular version of mammoth boss
float CT_MONJUDGE = 299;		// Large BOSS with glowing sword
float CT_MONSPIDER = 300;		// Spiders (brown/green versions) Hexen 2 series (Raven Software)
float CT_MONSTEELCLAW = 301;	// Steel Claw (bleed attack spider)
float CT_CACHESPIDER = 302;		// Special entity for precache of assets
float CT_CACHENECRO = 303;		// Special entity for precache of assets
float CT_MINIONSPIDER = 304;	// Minion Spawning version from wraith
float CT_CACHEGOLEM = 305;		// Special entity for precache of assets
float CT_MONSCORPION = 310;		// Deadly Scorpion (HL Black Crab!)
float CT_CACHESCORPION = 312;	// Special entity for precache of assets
float CT_MINIONSCORPION = 314;	// Minion Spawning version from wraith
float CT_MONLOSTSOUL = 315;		// The Original Doom flying lost soul
float CT_SOUL = 316;			// Floating Soul collectable for Nehahra wraiths.
float CT_CACHELOSTSOUL = 317;	// Special entity for precache of assets
float CT_MINIONLOSTSOUL = 319;	// Minion Spawning version from skullwizard
float CT_MONSKULLW = 320;		// Creepy Skull Wizard (Teleport)
float CT_MONGARGOYLE = 325;		// Flying Gargoyle (Flying fireball)
float CT_MONGARGOYLE_MINI = 326;// Flying Impling
float CT_CACHEGARGOYLE = 327;	// Special entity for precache of assets
float CT_MONGARGOYLE_MEGA = 328;// Flying Imp Lord
float CT_MINIONGARGOYLE = 329;	// Minion Spawning version from minotaur
float CT_MONGOLEM = 330;		// Giant stone Golem (ground slam)
float CT_MINIONGOLEM = 331;		// Minion Spawning version for golem
float CT_MONICEGOLEM = 335;		// Giant Ice Golem (shards+ground slam)
float CT_MONICEGOLEMWAVE = 337;	// Wave targets for boss Ice Golem
float CT_MONMINOTAUR = 340;		// Large tank like bull (magic/charge)
float CT_MONWRATH = 341;		// Rogue Wrath
float CT_MONWRATHOVERLORD = 342;// Rogue Overlord
float CT_MONDREADWRAITH = 343;	// Drake Dread Lord


float CT_MONEIDOLON = 345;		// Large demon boss Eidolon
float CT_MONFLYTRAPGROUND = 346;// Flytrap on the ground with button and tech base -madfox
float CT_MONEIDOLONWAVE = 347;	// Wave targets for boss Eidolon
float CT_MONFLYTRAP = 348;		// Flytrap standing up, just normal plant -madfox
float CT_MONWRAITHNEHAHRA = 349;
float CT_MONWRAITH = 350;		// Undead wraith (Burning debuff)
float CT_MONELF = 351;			// Little melee (knight) from Twisted Xmas MOD (Twisted Matrix)
float CT_MONRAINDEER = 352;		// Rocket wielding stag (ogre) from Twisted Xmas MOD (Twisted Matrix)
float CT_MONSNOWMAN = 353;		// Quick firing turret from Twisted Xmas MOD (Twisted Matrix)
float CT_MONSANTA = 354;		// Good/bad santa (boss) from Twisted Xmas MOD (Twisted Matrix)
float CT_MONMUMMY = 355;		// Undead mummy (Poison debuff)
float CT_MONMORPH = 356;		// Guardian
float CT_MONBOIL = 360;			// Slow moving zombie bomb
float CT_MONLAVAMAN = 361;		// Hephaestus from Rogue
float CT_MONLICHFIEND = 362;	// Headless fiend spawning boss
float CT_MONSEEKER = 364;		// Robot replacement for Shambler
float CT_MONEEL = 365;			// Sparky eel (electric projectile) from Rogue plus AD plasma shot
float CT_MONINVISSWORD = 366;	// Invisible swordsman from Rogue
float CT_MONGREMLIN = 367;		// Gremlin from Hipnotic


float CT_MONVORELING = 370;		// Little baby vorelings! ahh so cute! from Quoth MOD (Kell/Necros/Preach)
float CT_CACHEVORELING = 372;	// Special entity for precache of assets
float CT_MINIONVORELING = 374;	// Minion Spawning version from shalrath
float CT_MONSWAMPLING = 375;	// Tiny swamplings! ahh so cute!
float CT_MONDROLE = 380;		// Fast moving tentacle tank with rockets from Quoth MOD (Kell/Necros/Preach)
float CT_MONFREDDIE = 381;		// Slow moving mechanical ogre mutant from Quoth MOD (Kell/Necros/Preach)
float CT_MONGAUNT = 382;		// Flying harpy thing with plasma bolts! from Quoth MOD (Kell/Necros/Preach)
float CT_CACHEGAUNT = 383;		// Cache for minion gaunts
float CT_MINIONGAUNT = 384;		// Minion gaunts
float CT_MONJIM = 385;			// Jim the flying robot of doom! from Quoth MOD (Kell/Necros/Preach)
float CT_MONJIMROCKET = 386;	// Jim has a rocket launcher!
float CT_MONGUG = 387;			// Gug! from Quoth MOD (Kell/Necros/Preach)
float CT_MONPOLYP = 388;		// Flying Polyp from Quoth MOD (Kell/Necros/Preach)
float CT_MONVERMIS = 389;		// Vermis from Quoth MOD (Kell/Necros/Preach)
float CT_MONPYRO = 390;			// Enforcer Flame (Pyro) from Quoth MOD (Kell/Necros/Preach)
float CT_MONENF_ULTRA = 391;	// Ultra Enforcer
float CT_MONFUMIGATOR = 392;	// Poison version of the Pyro
float CT_MONENF_MEGA = 393;		// Mega Enforcer
float CT_MONDRONE = 394;		// Drone robot from Drake
float CT_MONCENTURION = 395;	// Enforcer hoverboard (Plasma)
float CT_PROJ_FABLADE = 396;	// Fallen Angel ninja blade attack
float CT_PROJ_FASPELL = 397;	// Fallen Angel green shard attack
float CT_ELENABLAST = 398;		// Targets for Elena fireblast trigger
float CT_PROJ_FIREWORK = 399;	// Fireworks

// Class Types for all projectiles in game (there is a lot!)
float CT_PROJ_TRACE = 400;		// Tracer shot (true aim)
float CT_PROJ_SMARTBALL = 401;	// Nemesant bouncing fire ball
float CT_PROJ_TRACEPART = 402;	// Tracer shot (extra particles)
float CT_PROJ_ZRING = 403;		// Zena ring
float CT_FIREWORKSHOOTER = 404;	// Fireworks
float CT_PROJ_SHELLC = 405;		// Shellcase projectile
float CT_PROJ_WILLY = 406;		// Willy the Spider projectile
float CT_PROJ_CYBER = 407;		// Cyber Demon rocket
float CT_MISCBELL = 408;		// Misc Bell
float CT_HEALGEM = 409;			// New Lifegem for Ravenkeep
float CT_PROJ_SG = 410;			// SG projectile
float CT_PROJ_MCOR1 = 411;		// Manticore yellow large spit spike
float CT_PROJ_SSG = 412;		// SSG projectile
float CT_HEALBEER = 413;		// New Q Brew for Ravenkeep
float CT_SPIRITTELEPORT = 414;	// info_skullwiz_destination
float CT_PROJ_NG = 415;			// NG projectile
float CT_PROJ_SNG = 416;		// SNG projectile
float CT_PROJ_MONNG = 417;		// Lava nailgun monster projectile (glowing red)
float CT_PROJ_REFNG = 418;		// Reflected (glowing red)
float CT_PROJ_HKN = 419;		// Hell Knight Spike
float CT_PROJ_WBONE = 420;		// Wraith Bone Bolt (nail)
float CT_PROJ_GROCK = 421;		// Golem rock debris (pebble)
float CT_PROJ_SCORP = 422;		// Scorpion Tail (nail)
float CT_PROJ_HKN2 = 423;		// Warlord Spike
float CT_PROJ_SANTA = 424;		// Santa Snowball shotgun!
float CT_PROJ_WIZ = 425;		// Wizard Spit
float CT_PROJ_NOUR1 = 426;		// Nour Spit 
float CT_PROJ_MPOISON = 427;	// Minotaur Poison Bolt (nail)
float CT_PROJ_MBLOOD = 428;		// Alternative Minotaur Bolt (nail)
float CT_PROJ_WPOISON = 429;	// Wraith Poison Bolt (nail)
float CT_PROJ_FURY2 = 430;		// Fury Spit with grenade trail
float CT_PROJ_REFLNG = 431;		// Reflected (glowing red)
float CT_PROJ_HKN_BLUE = 432;	// Blue Hell Knight Spike, used by Void Knight(NewHouse) and Saber Enforcer(back2forwards by The Lieutenant)
float CT_PROJ_GLMULTI = 433;	// Rogue Multi-Grenade projectile
float CT_PROJ_DARTARROW = 434;	// Trap_spikeshooter dart
float CT_PROJ_BOLT1 = 435;		// Crossbow Knight Bolt +hknight trail
float CT_PROJ_BOLT2 = 436;		// Poison
float CT_PROJ_MCOR2 = 437;		// Manticore small barrage spike
float CT_PROJ_ENFHKN = 438;		// Ultra Enforcer knight spike
float CT_PROJ_LAVANG = 439;		// Lava nailgun
float CT_PROJ_LASER = 440;		// Enforcer/Traps/Bob Laser
float CT_PROJ_PLASMA = 441;		// Generic Plasma (blue laser version)
float CT_PROJ_FLAME = 442;		// Burning (sprite based) flame
float CT_PROJ_LAVASNG = 443;	// Lava super nailgun
float CT_PROJ_GAUNT = 444;		// Gaunt Plasma bolt
float CT_PROJ_MINO = 445;		// Minotaur Plasma bolt
float CT_PROJ_WBOLT = 446;		// Wraith Hitscan Bolt 
float CT_PROJ_BLBOLT = 447;		// Boglord fast bolt
float CT_PROJ_LAVASPIK = 448;	// Lava nail
float CT_PROJ_BLBOLT2 = 449;	// Boglord fast bolt (red)
float CT_PROJ_GL = 450;			// Grenade projectile
float CT_PROJ_RICLASER = 451;	// Ricochet ( attack_ricochet = bounce qty )
float CT_PROJ_GLMON = 452;		// Monster grenades
float CT_PROJ_GLMONMULTI = 453;	// Monster multi-grenades
float CT_PROJ_GLMONPROX = 454;	// Monster grenades
float CT_PROJ_MEGG = 455;		// Minion Egg (grenade arc+bounce)
float CT_PROJ_SWEEPER2 = 456;	// Sweeper (blue/red+grenade arc)		Hazard / Grenade projectiles
float CT_PROJ_DPRINCE2 = 457;	// Dark prince (blue/red+grenade arc)
float CT_PROJ_DEFLECT1 = 458;	// The Deflector (rocket)
float CT_PROJ_SWEEP1 = 459;		// Sweeper mine/rocket
float CT_PROJ_FLESH = 460;		// Zombie Flesh (grenade arc)
float CT_PROJ_DPRINCE1 = 461;	// Dark Prince (spike ball)
float CT_PROJ_FLESHP = 462;		// Zombie Poison Flesh (grenade arc)
float CT_PROJ_SWAMP = 463;		// Swampling Spit (grenade arc)
float CT_PROJ_ELF = 464;		// Elf snowball (grenade arc)
float CT_PROJ_SPID = 465;		// Spider Spit (grenade arc)
float CT_PROJ_VORE = 466;		// Voreling Spit (grenade arc)
float CT_PROJ_NOUR2 = 467;		// Nour Spit bomb! (grenade arc+bounce)
float CT_PROJ_CHTHON2 = 468;	// Chthon Frenzy (grenade arc)
float CT_PROJ_SHUB2 = 469;		// Shub Frenzy (grenade arc)
float CT_PROJ_ROCKET = 470;		// Rocket projectile
float CT_PROJ_LAVA = 471;		// Chthon Lavaball
float CT_PROJ_FIRETOP = 472;	// Chthon Lavaball (less splash dmg)
float CT_PROJ_CHTHON = 473;		// Custom Chthon Lava/Slime ball
float CT_PROJ_GARG = 475;		// Gargoyle fireball
float CT_PROG_RLMEGAF = 476;	// Mega Enforcer (rocket)
float CT_PROJ_SKULLW = 477;		// Skull Wizard Skull (rocket)
float CT_PROJ_SKULLWP = 478;	// Skull Wizard Skull (poison rocket)
float CT_PROJ_BARON = 479;		// The Baron spike ball
float CT_PROJ_FURY1 = 480;		// Fury Knight spike ball +rocket trail
float CT_PROJ_JUDGER = 481;		// RED judicator arrows
float CT_PROJ_ARMY = 482;		// Army rocket
float CT_PROJ_JIM2 = 483;		// Jim robot rocket
float CT_PROJ_SEEKER = 484;		// Seeker robot rocket
float CT_PROJ_DROLE = 485;		// Drole fireball
float CT_PROJ_JUDGEB = 486;		// BLUE judicator arrows
float CT_PROJ_BLORD = 487;		// Bog Lord Slime bomb
float CT_PROJ_BLORD2 = 488;		// Bog Lord Red Slime bomb
float CT_PROJ_JUSTICER = 489;	// RED justice arrows
float CT_PROJ_EIDO1 = 490;		// Eidolon boulder
float CT_PROJ_MAMMOTH = 491;	// Mammoth rocket
float CT_PROJ_ICEG1 = 492;		// Ice Golem ice shard
float CT_WANDSPARK = 493;		// Magic wand normal spark
float CT_WANDBIGSPARK = 494;	// Magic wand large burst
float CT_PROJ_SHAL = 495;		// Shalrath spike ball +purple trail
float CT_PROJ_SERG = 496;		// Death Sergeant spike ball +hknight trail
float CT_PROJ_SHUB1 = 497;		// Custom Shub homing spike attack
float CT_PROJ_RAINDEER = 498;	// Raindeer rocket
float CT_PROJ_KSPHERE = 499;	// Lord Karasu energy sphere
float CT_UPGRADE_AXE = 500;		// Shadow Axe
float CT_AXE = 501;				// Axe
float CT_RAPIER = 502;			// Ghost Rapier
float CT_MACE = 503;			// Vampiric Mace
float CT_ICE = 504;				// Elemental Tome
float CT_SHOTGUN = 505;			// Shotgun
float CT_SCIMITAR = 506;		// Fire Scimitar
float CT_VOID_STAFF = 507;		// Void Staff
float CT_GUNGNIR = 508;			// Gungnir
float CT_SANGUINATORS = 509;	// Sanguinators
float CT_SUPER_SHOTGUN = 510;	// Super Shotgun
float CT_FLAK = 511;			// Flak Cannon
float CT_PROJ_KLIGHT = 512;		// Lord Karasu lightning
float CT_PROJ_KSPELL = 513;		// Lord Karasu spell runes
float CT_PROJ_MOONSWORD = 514;	// Moonlight Guardian sword
float CT_UPGRADE_SSG = 515;		// The Widowmaker Shotgun
float CT_PROJ_EVEBULLET = 516;	// Evelyn pistol bullet
float CT_PROJ_BLDSPEAR = 517;	// Huntress blood spears
float CT_PROJ_ELENAFIRE = 518;	// Huntress fireball
float CT_MIRV = 519;			// MIRV Launcher
float CT_NAILGUN = 520;			// Nailgun
float CT_LAVANG = 521;			// Lava nailgun
float CT_AIRGUN = 522;			// Airfist
float CT_PROJ_GLSUPER = 523;	// Tome powered Super Grenade projectile
float CT_PROJ_ROCKETSUPER = 524;// Tome powered Rocket projectile
float CT_SUPER_NAILGUN = 525;	// Super Nailgun
float CT_LAVASNG = 526;			// Lava nailgun
float CT_WAND = 527;			// Magic Wand (Drake)
float CT_GRAPPLE = 528;			// Grapple (Rogue with Drake upgrades)
float CT_CHAINLIGHTGUN = 529;	// Chain Lightning Gun
float CT_GRENADE_LAUNCHER = 530;// Grenade Launcher
float CT_PROXIMITY_GUN = 531;	// Grenade Launcher
float CT_MULTI_GRENADE = 532;	// Multi Grenade Launcher
float CT_MULTI_ROCKET = 533;	// Multi Rocket Launcher
float CT_BLASTERWEP = 534;		// Drake Laser Blaster
float CT_ROCKET_LAUNCHER = 535;	// Rocket Launcher
float CT_PROJ_SIDEWINDER = 536;	// Sidewinder Rocket
float CT_SIDEWINDER = 537;		// Sidewinder weapon pickup
float CT_FROSTBOW = 538;		// Asgard Arbalest (ice crossbow) from Drake (Formerly called the Buriza-Do Kyanon in Drake)
float CT_FROSTSHARD = 539;		// Asgard Arbalest frostshard projectile
float CT_LIGHTNING = 540;		// Lightning Gun
float CT_UPGRADE_LG = 545;		// Plasma Gun
float CT_PLASMAGUN = 546;		// Rogue Plasma Gun
float CT_MJOLNIR = 547;			// Mjolnir's Hammer
float CT_EXTRA_WEAPON = 548;	// Extra Weapon (Crossbow)
float CT_LASER_CANNON = 549;	// Laser Cannon
float CT_ARTSUIT = 550;			// Environment suit
float CT_CIRCUIT = 551;			// Circuit Board collectible (17mm Fromitz board from Rubicon2)
float CT_CHAINSAW = 552;		// Chainsaw (Zerstorer with Drake upgrades)


float CT_ARTPENT = 555;			// Pentagram - Invulnerability
float CT_ARTINVS = 560;			// Ring of Shadows
float CT_ARTQUAD = 565;			// Quad Damage
float CT_ARTSHARP = 570;		// Sharp Shooter
float CT_ARTPIERCE = 575;		// Nail Piercer
float CT_ARTLAVASHIELD = 576;	// Lava Shield
float CT_ARTBLASTBELT = 577;	// Blast Belt
float CT_ARTJUMPBOOTS = 578;	// Jump Boots
float CT_ARTREGEN = 579;		// Regeneration Powerup
float CT_ARTVITALITY = 580;		// Vitality +25 Max Health
float CT_ARTSPHERE = 581;		// Vengeance Sphere

float CT_PROGSPAWN = 589;		// Progression spawn
float CT_ARTTOME = 590;			// Tome of Power
float CT_ARTPSHIELD = 591;		// Power Shield
float CT_ARTGRAVBELT = 592;		// Anti-Gravity Belt
float CT_ARTWETSUIT = 593;		// Wetsuit
float CT_ARTEMPATHY = 594;		// Empathy Shield
float CT_ARTHORNCONJ = 595;		// Horn of Conjuring
float CT_ARTTHERMSUIT = 596;	// Thermal Protection Suit
float CT_ARTTRINITY = 597;		// Trinity
float CT_ARTCROSS = 598;		// Cross of Deflection
float CT_ARTHORN = 599;			// Horn of Conjuring
float CT_SILVERKEY = 600;		// Silver key
float CT_ARTHASTE = 601;		// Haste
float CT_GOLDKEY = 605;			// Gold key
float CT_SKELETONKEY = 606;		// Skeleton key by Qmaster, can open any door with a key requirement.  Used once.
float CT_CUSTOMKEY = 610;		// Custom key
float CT_CUSTOMITEM = 615;		// Custom pickup item
float CT_RUNEKEY = 620;			// End of Level rune keys 1-4
float CT_ARTBERSERK = 621;		// Berserker Helm, Drake
float CT_ARTEQUALIZER = 622;	// Equalizer Twin Shot, Drake
float CT_ARTLEVITATION = 623;	// Boots of Levitation, Drake
float CT_ARTOPTIMIZER = 624;	// Shotgun Optimizer, Drake
float CT_SIGILBANE = 625;		// Seal of Bane, Drake

float CT_SPIKESHOOTER = 650;		// Trap SPIKE shooter
float CT_GRENADESHOOTER = 652;		// Trap GRENADE shooter
float CT_ROCKETSHOOTER = 654;		// Trap ROCKET shooter
float CT_LIGHTSHOOTER = 656;		// Trap LIGHTNING shooter
float CT_GASSHOOTER = 658;		// Trap GAS shooter
float CT_EXPLO_BOX = 660;		// Exploding box
float CT_PENDULUM = 662;		// Swing Pendulum
float CT_SAWBLADE = 666;		// Saw Blade

float CT_FIREBALL = 670;		// Misc Fireball
float CT_MISCSPARK = 672;		// Misc Spark
float CT_MISCSHAKE = 676;		// Misc Shake of screen/player

float CT_MISCMARSH = 678;		// Misc Marsh lights (Quoth)
float CT_MISCVASE = 679;		// Redfields breakable vase with lick of flame on top
float CT_MISCDRIP = 680;		// Misc Drip (water)

float CT_BUBBLE = 682;			// Bubbles

float CT_MISCMODEL = 690;		// Misc Model

float CT_MISCSMOKE = 692;		// Misc Smoke
float CT_SHROOM = 693;			// Mario Mushroom that makes player bigger for a little while
float CT_MISCGIBF = 694;		// Misc Gib fountain

float CT_AMMOPACK = 700;		// Ammo Backpacks
float CT_AMMODROPPACK = 701;	// Dropped Ammo Backpacks from monsters
float CT_AMMORANDOM = 702;		// Random Ammo Backpack
float CT_AMMOITEMPACK = 703;	// Ammo Backpack for players
float CT_AMMOSHELLS = 710;		// Different ammo types
float CT_AMMONAILS = 720;
float CT_AMMOROCKETS = 730;
float CT_AMMOCELLS = 740;
float CT_AMMOPOISON = 741;
float CT_AMMOBOLTS = 742;
float CT_AMMOLAVANAILS = 743;
float CT_AMMOMULTIROCKETS = 744;
float CT_AMMOPLASMA = 745;
float CT_AMMOBLOODCRYSTALS = 746;
float CT_AMMOVOIDSHARDS = 747;
float CT_AMMOELEMENTAL = 748;
float CT_HEALVIAL = 749;		//  5 health pack
float CT_HEALROT = 750;			// Different Health packs
float CT_HEALNORM = 751;		// 25 health pack
float CT_HEALMEGA = 752;		// 100 Mega health

float BACKARMGRN = 15;			// Green shards
float BACKARMYEL = 30;			// Yellow shards
float BACKARMRED = 45;			// Red shards 

float CT_ARMOR1 = 770;			// Green armour
float CT_ARMOR2 = 775;			// Yellow armour
float CT_ARMORINV = 790;		// Red armour
float CT_ARMORITEMPACK = 791;	// Armour shard system
float CT_ARMORCOURAGE = 792;	// Courage
float CT_ARMORDRAGON = 793;		// Dragonscale
float CT_ARMORONYX = 794;		// Onyx
float CT_ARMORONYXPOWER = 795;	// Power
float CT_ARMORBERSERKER = 796;  // Demonhide
float CT_ARMORSPIRIT = 797;		// Spirit
float CT_ARMORCHAOS = 798;		// Chaos
float CT_ARMORNINJA = 799;		// Ninja
float CT_FUNCDOOR = 800;		// Func door
float CT_FUNCDOORTRIG = 801;	// Generated touch trigger around door
float CT_FUNCSECDOOR = 805;		// Func SECRET door
float CT_FUNCBUTTON = 810;		// Func button

float CT_FUNCPSWITCH = 812;		// Func Pressure Switch
float CT_FUNCINSVOLUME = 813;	// Func to detect inside volume

float CT_FUNCBOB = 815;			// Func bobbing bmodels
float CT_FUNCSHADOW = 816;		// Func shadows

float CT_FUNCTRAIN = 820;		// Func train

float CT_FUNCWALL = 830;		// Func wall
float CT_FUNCTOGWALL = 831;		// Func wall (toggle)
float CT_FUNCILLUSIONARY = 832;	// Func illusionary
float CT_FUNCLASER = 834;		// Func laser
float CT_FUNCSKILL = 836;		// Func_skill pillars
float CT_FUNCCHAOS = 837;		// Func_chaos pillar
float CT_FUNCHOOK = 838;		// Func Grapple Hook point

float CT_FUNCBREAK = 840;		// Func breakable (parent)
float CT_FUNCBREAKWALL = 841;	// Bmodel to activate after breakage
float CT_FUNCBREAKMDL = 845;	// Func breakable (model)
float CT_FUNCBREAKSPN = 846;	// Func breakable (spawner)
float CT_FUNCBREAKOBJ = 847;	// Func breakable (rubble))
float CT_FUNCPUSHABLE = 850;	// Func pushable
float CT_ROTATEORG = 851;		// Origin point for rotation
float CT_ROTATEPATH = 852;		// Rotating entity path_corner
float CT_ROTATEOBJ = 853;		// Rotating bmodel
float CT_ROTATEENT = 854;		// Rotating entity (continous)
float CT_ROTATEMOVE = 855;		// Rotating clip brushes!
float CT_ROTATETRAIN = 856;	// Rotating func_train (path corners)
float CT_ROTATEDOOR = 857;		// Rotating func_door (dual-state)

float CT_FUNCEPISODEGATE = 875;	// Episode gates (not used anymore)
float CT_FUNCBOSSGATE = 880;	// Final boss gate (not used anymore)
float CT_FUNCPLAT = 890;		// Old platform system
float CT_FUNCLIFT = 895;		// New platform system

float CT_TRIGONCE = 900;		// Once, volume

float CT_TRIGMULTI = 905;		// Multiple, volume

float CT_TRIGRELAY = 910;		// Relay, point entity no touch

float CT_TRIGDOORSTATE = 914;	// Set func_door to specific state
float CT_TRIGRELAYDELAY = 915;	// Relay, point entity no touch
float CT_TRIGTIMER = 916;		// Timer, point entity no touch

float CT_TRIGCOUNT = 920;		// Count, point entity no touch

float CR_TRIGENG = 922;			// Engine, point entity no touch
float CT_TRIGPLAYPART = 923;	// Player particles, point entity no touch

float CT_TRIGRUNES = 925;		// Rune, volume
float CT_TRIGSKILLS = 927;		// Skill, volume
float CT_TRIGTELEPORT = 930;	// Trigger teleport

float CT_MISCTELEPORT = 932;	// info_teleport_destination
float CT_MISCTELCAMERA = 934;	// info_camera_destination
float CT_MISCTELINSTANT = 936;	// info_teleportinstant_dest (volume)
float CT_SKULLTELEPORT = 938;	// info_skullwiz_destination
float CT_TRIGEXPLODE = 945;		// Trigger sprite explosion

float CT_TRIGSECRET = 950;		// Secret, volume
float CT_TRIGLIGHTSTYLE = 954;	// Lightstyle, volume
float CT_TRIGLADDER = 955;		// Ladder, volume
float CT_TRIGFOG = 956;			// Fog, volume
float CT_TRIGSKYFOG = 957;		// Sky Fog, volume
float CT_TRIGGRAVITY = 958;		// Gravity, volume
float CR_TRIGFALLSPEED = 959;	// Player fall speed, volume
float CR_TRIGMAXHP = 960;		// Player max HP, volume
float CT_TRIGHURT = 961;		// Hurt, volume
float CT_TRIGHEAL = 962;		// Heal, volume
float CT_TRIGGIVEITEM = 963;	// Give items, volume
float CT_TRIGTAKEART = 964;	// Take artifacts, volume
float CT_TRIGTSOUND = 968;		// Touch sounds, volume
float CT_TRIGPUSH = 970;		// Push, volume

float CT_TRIGVELOCITY = 972;	// Velocity, volume
float CT_TRIGCONVEYOR = 974;	// Conveyor, volume
float CT_TRIGLEVEL = 975;		// Change level
float CT_TRIGSKYBOX = 976;		// Change/Load Skybox console command
float CT_TRIGITEMFLAG = 977;	// Change item spawnflags
float CT_TRIGCLMSG = 978;		// Message to all clients
float CT_TRIGCDTRACK = 979;		// Change CD track
float CT_TRIGMONJUMP = 980;		// Triger monster to jump forward
float CT_TRIGNOJUMP = 981;		// Trigger monster to NOT jump!
float CT_TRIGMONDROP = 982;		// Trigger monster to fall naturally
float CT_TRIGMONTURRET = 983;	// Trigger monster to turn into turret
float CT_TRIGMONMOVE = 984;		// Trigger monster movement state
float CT_TRIGMONBREAK = 985;	// Trigger monster/breakable together
float CT_TRIGMONKILL = 986;		// Trigger monster to be killed
float CT_TRIGMONATT = 987;		// Trigger monster to attack something
float CT_TRIGMONATTACK = 988;	// Trigger monster to attack something

float CT_TRIGVOID = 999;		// Skybox garbage collector!