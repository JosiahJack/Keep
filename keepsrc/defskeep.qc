//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: All, see credits folder
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
// Implements: Compile order and what files are included
//
// Description:
// Definitions for Keep mod's specific functions or random one variable
// definitions from tiny mods that didn't justify having a separate
// file.
//
// And now for some sayings:
//
// You keep what you kill (and kill with).
// -Qmaster
//
// One mod to rule them all
// One mod to find them
// One mod to Keep them all
// and in Quake bind them
// -ijed
//=============================================================================

string MOD_VERSION		= "\b[INFO]\b Keep Mod, version 0.92\n";
.float mapversion;
.string target3, target4;
float total_denizens; // Used to track total harmless denizens
float killed_denizens; // Used to track harmless creature kills

// float IT_NOWEAPON			= 0;		// No extra mod weapon (blank)
//=======================================SELF.ITEMS1======================================================
float IT_SHOTGUN    		= 1.000;		//0  Correct for standard HUD & HIP & DOE			W
float IT_SUPER_SHOTGUN   	= 2.000;		//1  Correct for standard HUD & HIP & DOE			W
float IT_NAILGUN    		= 4.000;		//2  Correct for standard HUD & HIP & DOE			W
float IT_SUPER_NAILGUN    	= 8.000;		//3  Correct for standard HUD & HIP & DOE			W
float IT_GRENADE_LAUNCHER   = 16.000;		//4  Correct for standard HUD & HIP & DOE			W
float IT_ROCKET_LAUNCHER    = 32.000;		//5  Correct for standard HUD & HIP & DOE			W
float IT_LIGHTNING    		= 64.000;		//6  Correct for standard HUD & HIP & DOE			W
float IT_SHELLS    			= 128.000;		//7  Correct for DOE HUD					I
float IT_NAILS    			= 256.000;		//8  Correct for DOE HUD					I
float IT_ROCKETS    		= 512.000;		//9 Correct for DOE HUD					I
float IT_CELLS    			= 1024.000;		//10 Correct for DOE HUD					I
float IT_AXE    			= 2048.000;		//11 Correct for DOE HUD					W
float IT_LAVA_NAILGUN    	= 4096.000;		//12 Correct for DOE HUD (okay for standard and HIP)	W
float IT_LAVA_SUPER_NAILGUN = 8192.000;		//13 Correct for DOE HUD (okay for standard and HIP)	W
float IT_MULTI_GRENADE    	= 16384.000;	//14 Correct for DOE HUD (okay for standard and HIP)	W
float IT_MULTI_ROCKET    	= 32768.000;	//15 Correct for DOE HUD (okay for standard and HIP)	W
float IT_PLASMA_GUN   	 	= 65536.000;	//16 Correct for DOE HUD					W
float IT_KEY1    			= 131072.000;	//17 Correct for standard HUD & HIP & DOE			I
float IT_KEY2    			= 262144.000;	//18 Correct for standard HUD & HIP & DOE			I
float IT_INVISIBILITY    	= 524288.000;	//19 Correct for standard HUD & HIP & DOE			I
float IT_INVULNERABILITY    = 1048576.000;	//20 Correct for standard HUD & HIP & DOE			I
float IT_SUIT    			= 2097152.000;	//21 Correct for standard HUD & HIP & DOE			I
float IT_QUAD    			= 4194304.000;	//22 Correct for standard HUD & HIP & DOE			I
float IT_EXTRA_WEAPON  		= 8388608.000;	//23 Correct for DOE HUD					W

// IT_INVISIBILITY + IT_INVULNERABILITY + IT_SUIT + IT_QUAD
// 524288 + 1048576 + 2097152 + 4194304
float ALL_ITEMSARTIFACTS = 7864320; // All items that affect screen overlay cshift
//=======================================SELF.ITEMS2======================================================
float IT2_ARMOR1    		= 1.000;		//0  Correct for DOE HUD					I
float IT2_ARMOR2    		= 2.000;		//1  Correct for DOE HUD					I
float IT2_ARMOR3    		= 4.000;		//2  Correct for DOE HUD					I
float IT2_LAVA_NAILS    	= 8.000;		//3  Correct for DOE HUD					I
float IT2_PLASMA_AMMO   	= 16.000;		//4  Correct for DOE HUD					I
float IT2_MULTI_ROCKETS    	= 32.000;		//5  Correct for DOE HUD					I
float IT2_SHIELD    		= 64.000;		//6  Correct for DOE HUD					I
float IT2_CHAINLIGHTNING	= 128.000;		//7  Zerstorer chain lightning				W	(I Antigrav for DOE HUD)
float IT2_SUPERHEALTH    	= 256.000;		//8  Correct for DOE HUD					I
float IT2_EARTHQUAKE    	= 512.000;		//9  Correct for DOE HUD					I
float IT2_V_SPHERE    		= 1024.000;		//10 Correct for DOE HUD					I
float IT2_BOLTS		    	= 2048.000;		//11 Keep specific						I
float IT2_POISON    		= 4096.000;		//12 Keep specific						I
float HIP_IT2_WETSUIT    	= 8192.000;		//13 Keep specific (modified from HIP)			I
float HIP_IT2_EMPATHY_SHIELDS= 16384.000;	//14 Keep specific (modified from HIP)			I
float HIP_IT2_HORN_OF_CONJURING= 32768.000;	//15 Keep specific (modified from HIP)			I
//float UNUSED				= 65536.000;	//16 Unused item slot
float IT2_PROXIMITY_GUN    	= 131072.000;	//17 Keep specific.Unique number for self.weapon calls 	W
float IT2_MJOLNIR 			= 262144.000;	//18 Keep specific	""					W
float IT2_LASER_CANNON    	= 524288.000;	//19 Keep specific	""					W
float IT2_GRAPPLE			= 1048576.000;	//20 Keep specific "" W Rogue grapple
float IT2_TRINITY			= 2097152.000;	//20 Quoth
float IT2_CROSS				= 4194304.000;	//21 Quoth							I && W2 (used by Wand)
float IT2_WAND				= 8388608.000; 	//22 Drake magic wand					W2 (special check to prevent IT_EXTRA_WEAPON conflict

float IT2_ALLARMOR			= 7.000;// Test for player grn/yel/red armour. Helper combo bit of 1 + 2 + 4
float ALL_ITEMS2ARTIFACTS = 6291456; // All items that affect screen overlay cshift
//=======================================SELF.MODITEMS======================================================
//float UNUSED   			= 1;			//0  I
float IT_UPGRADE_SSG		= 2;			//1  AoA		W\
	float IT_ICE    		= 4;			//2  AoA		W2  HACKBANK!
	float IT_MACE   		= 8;			//3  AoA		W2  HACKBANK!
	float IT_VOID_STAFF		= 16;			//4  AoA		W2  HACKBANK!
	float IT_FLAK   		= 32;			//5  AoA		W2  HACKBANK!
float IT_UPGRADE_LG			= 64;			//6  Plasma Gun, direct + splashdamage
	float IT_GUNGNIR   		= 128;			//7  AoA		W2  HACKBANK!
float IT_SANGUINATORS		= 256;			//8  AoA		W
float IT_SCIMITAR			= 512;			//9  AoA		W
float IT_RAPIER 			= 1024;			//10 AoA		W
float IT_UPGRADE_AXE   		= 2048;			//11 Shadow Axe, +75% dmg, +gib bodies
//float UNUSED				= 4096;			//12
float IT_CKEY1				= 8192;			//13 Custom Key 1
float IT_CKEY2				= 16384;		//14 Custom Key 2
float IT_CKEY3				= 32768;		//15 Custom Key 3
float IT_CKEY4				= 65536;		//16 Custom Key 4
float IT_ARTLAVASHIELD 		= 131072;		//17 No health or armor damage in lava
float IT_ARTWETSUIT			= 262144;		//18 No running out of oxygen under water
float IT_ARTBLASTBELT		= 524288;		//19 Immunity to all splashdamage
float IT_ARTJUMPBOOTS		= 1048576;		//20 JCR Jump Boots (1-4 power levels)
float IT_ARTSHARP			= 2097152;		//21 Reduce SG/SSG/RG spread pattern
float IT_ARTPIERCE			= 4194304;		//22 NG/SNG Nails travel through enemy bodies
float IT_ARTTOME			= 8388608;		//23 Tome of Power (event trigger)
float ALL_MODITEMSARTIFACTS = 16646144; // All items that affect screen overlay cshift
.float serverflagstemp;
.float selfweaponismoditems; 	// HACK FOR HACKBANK! Used to carry more than 24 weapons which is all we can fit in the float's bits
float IT_CKEYALL			= 122880;	//17 All Custom keys
//==========================================================================================================
// More powerups -----------------------------------------------------------
// Bits 00-07 (values 1-128) are reserved for health.
// Bits 08-11 (values 256-2048) are reserved for armor.
// float   POW_ARMOR1      	= 256;      	// Divide this into perms for suit value.
// float   POW_POWER_ARMOR 	= 4096;     	// Power shield toggle.
//=======================================SELF.PERMS======================================================
float 	POW_ARMORCOURAGE	= 1;			//0
float 	POW_ARMORDRAGON		= 2;			//1
float	POW_ARMORONYX		= 4;			//2
float	POW_ARMORONYXPOWER	= 8;			//3
float 	POW_ARMORBERSERKER	= 16;			//4
float 	POW_ARMORSPIRIT		= 32;			//5
float 	POW_ARMORCHAOS		= 64;			//6
float 	POW_ARMORNINJA		= 128;			//7
float 	POW_REGEN			= 256;			//8
float	POW_REGENLESSER		= 512;			//9
//float UNUSED				= 1024;			//10
//float UNUSED				= 2048;			//11
//float UNUSED				= 4096;			//12
float   POW_RESIST      	= 8192;     	//13 Half damage.
float   POW_VITALITY       	= 16384;    	//14 Regeneration.
//float UNUSED				= 32768;		//15
float   POW_DOUBLE      	= 65536;    	//16 Twin shot -- nailgun buff.
float   POW_SHOTTYMAN		= 131072;   	//17 Shotgun buff.
float   POW_VAMPIRE     	= 262144;   	//18 Melee buff.
float   POW_PACK        	= 524288;   	//19 Extra ammo capacity.
float	IT_BLASTER 			= 1048576; 		//20 Drake laser blaster 					W  stored in self.perms.  was POW_20 in Drake, unused
float	IT_CHAINSAW 		= 2097152;		//21 Drake chainsaw						W stored in self.pems.  was POW_21 in Drake, unused.  Chainsaw is modified version of Zerstorer
float   POW_HINT_ARMOR  	= 4194304;		//22 Armor instructions.
float   POW_HINT_FALL   	= 8388608;		//23 nsoe4:  slow falling message.

// float   POWx_HEALTH     = 255;      // Extra max health.  First 8 bits.
// float   POWx_ARMOR      = 3840;     // Mutually exclustive exotic armor.

// ===WEAPON ORDERING==================================================================================
/*
WEAPON KEYBOARD ORDER
1 - Axe + Shadow Axe + Chainsaw, Grapple, Mace (3)
2 - Shotgun + Laser Blaster, Elemental Tome (2)
3 - Doublebarrel Shotgun + Widowmaker + Shotcycler + Quad Shotgun, Scimitar (2)
4 - Nailgun, Lava Nailgun, Rapier (3)
5 - Perforator, Lava Super Nailgun, Void Staff (3)
6 - Grenade Launcher, Proximity Grenade Launcher, Multi-Grenade Launcher (3)
7 - Rocket Launcher, Multi-Rocket Launcher, Sanguinators(3)
8 - Thunderbolt + Plasmagun(AD), Plasmagun(rogue), Flak Cannon (3)
9 - Crossbow, Laser Cannon, Chain Lightning Gun (3)
0 - Wand, Mjolnir, Gungnir (3)

WEAPON CYCLING ORDER										NORMAL e.g.
UniqueID Wepname												HACKBANK e.g. (indented)
1  Grapple													IT2_GRAPPLE
2  Axe/Shadowaxe/Chainsaw									IT_AXE
3  Mace															IT_MACE
4  Shotgun/Blaster											IT_SHOTGUN
5  Ice Tome														IT_ICE
6  Doublebarrel Shotgun/Widowmaker/Shotcycler/QuadShotgun	IT_SUPER_SHOTGUN
7  Scimitar													IT_SCIMITAR
8  Nailgun													IT_NAILGUN
9  Lava Nailgun												IT_LAVA_NAILGUN
10 Rapier													IT_RAPIER
11 Perforator												IT_SUPER_NAILGUN
12 Lava Super Nailgun										IT_LAVA_SUPER_NAILGUN
13 Void Staff													IT_VOID_STAFF
14 Grenade Launcher											IT_GRENADE_LAUNCHER
15 Proximity Grenade Launcher								IT2_PROXIMITY_GUN
16 Multi-Grenade Launcher									IT_MULTI_GRENADE
17 Rocket Launcher											IT_ROCKET_LAUNCHER
18 Multi-Rocket Launcher									IT_MULTI_ROCKET
19 Sanguinators												IT_SANGUINATORS
20 Thunderbolt/Plasmagun									IT_LIGHTNING
21 Plasma Gun(rogue)										IT_PLASMA_GUN
22 Flak Cannon													IT_FLAK
23 Crossbow													IT_EXTRA_WEAPON
24 Laser Cannon												IT2_LASER_CANNON
25 Chain Lightning Gun										IT2_CHAINLIGHTNING
26 Wand														IT2_CROSS
27 Mjolnir													IT2_MJOLNIR
28 Gungir														IT_GUNGNIR
*/
// Unique ID's for weapon cycling list.
float ID_GRAPPLE = 1;
float ID_AXE_SHADAXE_CHAINSAW = 2;
float ID_MACE = 3;
float ID_SHOTGUN_BLASTER = 4;
float ID_ICE = 5;
float ID_SUPER_SHOTGUN_WIDOWMAKER_SHOTCYCLER_QUADSHOTTY = 6;
float ID_SCIMITAR = 7;
float ID_NAILGUN = 8;
float ID_LAVANAILGUN = 9;
float ID_RAPIER = 10;
float ID_PERFORATOR = 11;
float ID_LAVASUPERNAILGUN = 12;
float ID_VOIDSTAFF = 13;
float ID_GRENADE_LAUNCHER = 14;
float ID_PROXIMITY_GRENADE = 15;
float ID_MULTI_GRENADE = 16;
float ID_ROCKETLAUNCHER = 17;
float ID_MULTIROCKETLAUNCHER = 18;
float ID_SANGUINATORS = 19;
float ID_THUNDERBOLT_AD_PLASMAGUN = 20;
float ID_PLASMAGUN_ROGUE = 21;
float ID_FLAK = 22;
float ID_CROSSBOW = 23;
float ID_LASER_CANNON = 24;
float ID_CHAINLIGHTNING = 25;
float ID_WANDCROSS2 = 26;
float ID_MJOLNIR = 27;
float ID_GUNGNIR = 28;

float BBOX_ARMAGON = 23;	// -48 -48 -24, 48 48 84
float BBOX_VERMIS = 24;		// -64 -64 -512, 64 64 256
float ARMOR_BLUE = 2;			// Display a blue armour

// Normal max ammo counts:
float AMMO_MAXSHELLS = 200;		// Maximum ammo the player can carry
float AMMO_MAXNAILS = 200;		// Shells use to be 100
float AMMO_MAXROCKETS = 100;
float AMMO_MAXCELLS = 100;
float AMMO_MAXLAVANAILS = 200;
float AMMO_MAXMULTIROCKETS = 100;
float AMMO_MAXPLASMA = 100;
float AMMO_MAXPOISON = 50;
float AMMO_MAXBOLTS = 100;
float AMMO_MAXBLOOD = 100;
float AMMO_MAXVOID = 100;
float AMMO_MAXMANA = 100;

.float maxshells;		// Maximum ammo the player can carry
.float maxnails;
.float maxrockets;
.float maxcells;
.float maxlavanails;
.float maxmultirockets;
.float maxplasma;
.float maxpoison;
.float maxbolts;
.float maxblood;
.float maxvoid;
.float maxmana;

float AMMO_POISON_LGR = 10;
float AMMO_POISON_SML = 5;
float AMMO_BOLTS_LGR = 16;
float AMMO_BOLTS_SML = 8;
float AMMO_BLOOD_SML = 25;
float AMMO_BLOOD_LGR = 50;
float AMMO_VOID_SML = 10;
float AMMO_VOID_LGR = 20;
float AMMO_MANA_SML = 20;
float AMMO_MANA_LGR = 40;
float GREMLIN_AMMO_TAKE = 30;
float OGRE_MULTI = 2;
string MODEL_GWEAP_LNG = "progs/g_lava.mdl";
string MODEL_GWEAP_LSNG = "progs/g_lava2.mdl";
string MODEL_GWEAP_PROX = "progs/hipnotic/g_prox.mdl";
string MODEL_GWEAP_LASER = "progs/hipnotic/g_laserg.mdl";
string MODEL_GWEAP_MJOL = "progs/hipnotic/g_hammer.mdl";
string MODEL_GWEAP_WAND= "progs/drake/g_wand.mdl";
string MODEL_VWEAP_LAVANG = "progs/v_lava.mdl";			// Lava nailgun
string MODEL_VWEAP_LAVASNG = "progs/v_lava2.mdl";		// Lava Super Nailgun
string MODEL_VWEAP_MULTG = "progs/v_multi.mdl";			// Multi-Grenade Launcher
string MODEL_VWEAP_MULTR = "progs/v_multi2.mdl";		// Multi-Rocket Launcher
string MODEL_VWEAP_PLASM = "progs/v_plasma2.mdl";		// Plasma Gun
string MODEL_VWEAP_PROX = "progs/hipnotic/v_prox.mdl";			// Proximity Gun
string MODEL_VWEAP_MJOL = "progs/hipnotic/v_hammer.mdl";			// Mjolnir
string MODEL_VWEAP_LCAN = "progs/hipnotic/v_laserg.mdl";			// Laser Cannon
string MODEL_PROJ_GRENADEMULTI = "progs/rogue/mervup.mdl";			// Multi-Grenade for Monsters
string SOUND_ARTPSHIELD1 = "rogue/shield/pickup.wav";			// Pickup
string SOUND_ARTPSHIELD2 = "rogue/shield/hit.wav";			// Active
string SOUND_ARTPSHIELD3 = "rogue/shield/fadeout.wav";		// Fading
string SOUND_ARTCROSS2 = "quoth/items2/crosuse.wav";			// Active
string SOUND_ARTEMPATH2 = "hipnotic/items/empathy2.wav";		// Active

.float slimealpha;
.float lavaalpha;
.float versustype;
.float therm_finished;
.float therm_time;
.float ammo_bolts;
.float ammo_poison;
.float devdata;
.entity deventity;
.float enemyhealth;
float wavenumber;
float DEV_AMMO_N_HEALTH = 1;
.float funcwaterdmg_finished;
float COOP_VERSUS = 3;
float VT_SURVIVOR = 2;
float VT_GAMEMASTER = 4;
float GLOBALSTATE_1 	= 1.000;
float GLOBALSTATE_2  	= 2.000;
float GLOBALSTATE_3    	= 4.000;
float GLOBALSTATE_4	= 8.000;
float GLOBALSTATE_5    	= 16.000;
float GLOBALSTATE_6    	= 32.000;
float GLOBALSTATE_7    	= 64.000;
float GLOBALSTATE_8    	= 128.000;
float GLOBALSTATE_9    	= 256.000;
float GLOBALSTATE_10    = 512.000;
float GLOBALSTATE_11    = 1024.000;
float GLOBALSTATE_12    = 2048.000;
float GLOBALSTATE_13    = 4096.000;
float GLOBALSTATE_14   	= 8192.000;
float GLOBALSTATE_15    = 16384.000;
float GLOBALSTATE_16    = 32768.000;
float GLOBALSTATE_17   	 = 65536.000;
float GLOBALSTATE_18    = 131072.000;
float GLOBALSTATE_19    = 262144.000;
float GLOBALSTATE_20    = 524288.000;
float GLOBALSTATE_21    = 1048576.000;
float GLOBALSTATE_22    = 2097152.000;
float GLOBALSTATE_23    = 4194304.000;
float GLOBALSTATE_24  	= 8388608.000;
float globalstate;
.float stateflags;
.string statetarget1;
.string statetarget2;
.string statetarget3;
.string statetarget4;
.string statetarget5;
.string statetarget6;
.string statetarget7;
.string statetarget8;
.string statetarget9;
.string statetarget10;
.string statetarget11;
.string statetarget12;
.string statetarget13;
.string statetarget14;
.string statetarget15;
.string statetarget16;
.string statetarget17;
.string statetarget18;
.string statetarget19;
.string statetarget20;
.string statetarget21;
.string statetarget22;
.string statetarget23;
.string statetarget24;
.float usingfinished;
float numsurvivors;
float numgamemasters;
.float cost;
.float spritestarted;
.float useold_axe;
.float take_perms;
.float nailcosthalf; // bool for checking if it is time to subtract a nail from ammo
float coins;  // Currency for survival player(s)
float bones;  // Currency for gamemaster player(s) (called gibs in-game)
string g_axemodel;
string v_axemodel;
.vector dest;	// Could not find this in the source, added
.entity gravtrigent; //the trigger_setgravity we are in
.float gravtrig; //bit to say whether or not we are in a gravity trigger

// From Copper by Lunaran
.float notrace; // Used to help with Invisibility confusion
.float jumplandfinished; // used to prevent spamming jump land noise when running down the side of a pyramid

// Ammo resistance system
float AM_NONE = -1;
float AM_SHELLS = 0;
float AM_NAILS = 1;
float AM_ROCKETS = 2;
float AM_CELLS = 3;
float AM_LAVANAILS = 4;
float AM_MULTI_ROCKETS = 5;
float AM_PLASMA = 6;
float AM_BOLTS = 7;
float AM_POISON = 8;
float AM_BLOODCRYSTALS = 9;
float AM_VOIDSHARDS = 10;
float AM_ELEMENTAL = 11;
float AM_ACID = 12;
float AM_FIRE = 13;
float AM_COLD = 14;

.float lightning_timer;	// Cool down for LG resist effect

// Projectile resistance (% protection) for monsters
.float resist_shells;
.float resist_nails;
.float resist_rockets;
.float resist_cells;
.float resist_lava_nails;
.float resist_multi_rockets;
.float resist_plasma;
.float resist_bolts;
.float resist_poison;
.float resist_bloodcrystals;
.float resist_voidshards;
.float resist_elemental;

// elemental resistance ---------------Drake------------------------------------------
.float      resist_acid;    // slime, acid.
// .float      resist_rocket;  // damage caused by rocket or railgun. duplicate of resist_rockets
.float      resist_fire;    // lava, flames.
// .float      resist_light;   // electrical attacks such as lightning bolts. duplicate of resist_cells
.float      resist_cold;    // ice.

.float save_shells;
.float save_nails;
.float save_rockets;
.float save_cells;
.float save_lava_nails;
.float save_multi_rockets;
.float save_plasma;
.float save_bolts;
.float save_poison;
.float save_bloodcrystals;
.float save_voidshards;
.float save_elemental;
.float save_acid;
.float save_fire;
.float save_cold;
.float aura_finished;
.float aura_type;
.float water_blessed;

// Monster attachments (like carts for ogles, or pushables, and other misc_model's)
.vector attachment_offset;
.string hasobject;

// Mass values for gyro physics
float MASS_GRENADE = 1;
float BOUY_GRENADE = 1.2;
float RESIST_GRENADE = 0.4;
float TURB_GRENADE = 0.24;
float AERO_GRENADE = 0.8;
float MASS_MINIGRENADE = 0.2;
float BOUY_MINIGRENADE = 0.3;
float RESIST_MINIGRENADE = 3;
float MASS_GIB = 1.5;
float BOUY_GIB = 2.2;
float RESIST_GIB = 1.8;

.float ubs_deflapped;

// Enhance the gyro physics for  setting multiple physics effects at once, if desired
.float physicsflags;
float PHYS_GYRO_BOUYANT		 = 1;
float PHYS_GYRO_MOTIONRESIST = 2;
float PHYS_GYRO_TURBULENCE	 = 4;
float PHYS_GYRO_HOVER		 = 8;
float PHYS_GYRO_THRUST		 = 16;
float PHYS_GYRO_AERODYNAMIC	 = 32;
float PHYS_GYRO_ANGTURBULENCE= 64;

.float m_iRoomType;
.float m_iRadius;
.float fov;

// Copper has a lot of nice changes.  Some people don't like them.  Sometimes you don't want all of them.  Well, take your pick.  Enable however many of them you want.
.float copperoptions;
float COPPER_SHOTGUN_PIERCE 		= 1;
float COPPER_IMPRECISE_VOREBALLS 	= 2;
float COPPER_SEMI_Z_AWARE_OGRES 	= 4;
float COPPER_ONE_HIT_AXE_ZOMBIES 	= 8;
float COPPER_DOWNED_ZOMBIE_GIB 		= 16;
float COPPER_TURRET_ENFORCERS		= 32;
float COPPER_TARBABY_JUMP_CALMING	= 64;
float COPPER_CHTHON_SPD_PROGRESSION = 128;
float COPPER_FORGETFUL_INFIGHTERS	= 256;
float COPPER_COOP_PARTY_ITEMSHARE	= 512;
float COPPER_COOP_BACKPACK_PROTECT	= 1024;
float COPPER_COOP_MEGAH_PARTY_HEAL	= 2048;
float COPPER_FAST_NAILGUN_NAILS		= 4096;
float COPPER_TWOSHOT_PERFORATOR		= 8192;
.float doomoptions;
float DOOM_SHOTGUNS_KNOCKBACK		= 1;
float DOOM_PLASMAGUN				= 2;
.float spirit_blessed;
.float air_blessed;
float SPAWNFLAG_LASER = 2;
.float shroom_finished;
float SHROOM_JUMP_BOOST = 200;
.entity legsattachment;
.float flight_finished;
float SPARKS_BLUE = 2;
float SPARKS_PALE = 4;
.vector movedir2;
float FL_NOSELECT = 8192;	// Ignored by entity selector
float MONSTER_FLAK_OGRE	= 4;
.float spikecount;
.float idleweaponframe;	// this is set to be the stationary idle weapon frame used when the player is not firing.  It is different for each weapon and must therefore be set on each weapon change
.float monsterflags;
float MF_COMMANDER	= 1;		// beefier version
float HX_FRAME_TIME   =  0.05000;
float AF_NORMAL   =  0.00000;
float AF_BEGINNING   =  1.00000;
float AF_END   =  2.00000;
.float ring_regen_time;
.float ring_flight_time;
.float ring_water_time;
.float monster_stage;
.float monster_duration;
.float monster_awake;
.float camera_time;
.float spell_angle;
.float lifetime;
.float safe_time;
.float splash_time;
.entity movechain;
.string partname;
.float dodge_finished;
.float dodging;
.entity owner2;
.float projectile_type;
float num_beams;

float MAX_BEAMS = 128; // Engine side is only 24!!!! What the heck???