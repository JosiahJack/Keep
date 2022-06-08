//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: Drake by Patrick Martin
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
// Implements: Drake entity definitions
//
// Description:
// Definitions for drake entities.
//=============================================================================

float   ALPHA_GHOST     = 0.7;  // Used by wraiths.
float   ALPHA_ICE       = 0.7;  // Used by ice shards.
float   ALPHA_ICEBALL   = 0.9;  // Used by iceballs.
float   AKARROW_SPEED_FLY   = 1000; // Archer and bandit arrow speed
float   ARROW_WOOD  = 0; // arrow model skins
float   ARROW_EBONY = 1;
float   ARROW_ICE   = 2;
float   ARROW_MAGIC = 3; // Orange.  Use skin + 3 to match laser colors.
float   BURN_PER_SECOND     = 4;    // Burning damage constants.  4 is slime dmg, 5 divides evenly with armor %s.
float   MAX_BURN_DAMAGE     = 60;   // Enough to kill standard zombies.
float   SPEED_FIREWALL  = 400;      // Don't change!

// Curses
float   CURSE_DAMAGE        = 1;    // Reverse Resistance
float   CURSE_WEAKEN        = 2;    // Reverse Strength
float   CURSE_SLOW          = 3;    // Reverse Haste
float   CURSE_ARMOR         = 4;    // Reverse Regeneration
float   CURSE_CONFUSE       = 5;

vector  VEC_360     = '360 360 0';
vector  VEC_QUAKE   = '5 4 4';      // Standard earthquake angle tilts.
float   HIT_NORMAL  = 0;    // Default.
float   HIT_METAL   = 1;    // Knights, centroids, and other armored guys.
float   HIT_STONE   = 2;    // Statues, golems.
float   COURAGE_DAMAGE  = 10;   // Damage to armor if it reflects a rocket.
float COST_MJOLNIR = 5;

// Frames for 's_fancy.spr'.
float   X32_PUFF_ORANGE     = 0;
float   X32_PUFF_BLUE       = 5;
float   X32_PUFF_PURPLE     = 10;
float   X32_CLOUD_GREEN     = 15;
float   X32_PLASMA_ORANGE   = 21;
float   X32_PLASMA_RED      = 27;
float   X32_PLASMA_YELLOW   = 33;
float   X32_PLASMA_BLUE     = 39;
float   X32_STAR_ORANGE     = 45;
float   X32_STAR_RED        = 50;
float   X32_STAR_YELLOW     = 55;
float   X32_STAR_BLUE       = 60;
float   X32_SPARK_ORANGE    = 65;
float   X32_SPARK_RED       = 69;
float   X32_SPARK_YELLOW    = 73;
float   X32_SPARK_BLUE      = 77;
float   X32_CUT_ORANGE      = 81;
float   X32_CUT_RED         = 85;
float   X32_CUT_YELLOW      = 89;
float   X32_CUT_BLUE        = 93;
float   X56_PUFF_ORANGE     = 97;
float   X56_PUFF_BLUE       = 103;
float   X56_PUFF_PURPLE     = 109;
float   X56_CLOUD_GREEN     = 115;
float   X56_PLASMA_ORANGE   = 120;
float   X56_PLASMA_RED      = 126;
float   X56_PLASMA_YELLOW   = 132;
float   X56_PLASMA_BLUE     = 138;
float   X56_SPLASH_RED      = 144;
float   X56_SPLASH_GREEN    = 147;
float   X56_SPLASH_PURPLE   = 150;
float   X80_SPARK_ORANGE    = 153;
float   X80_SPARK_RED       = 159;
float   X80_SPARK_YELLOW    = 165;
float   X80_SPARK_BLUE      = 171;

// Frames for 's_wave.spr'.
float   RING_FIRE       = 0;    // Custent's flaming shockwave, modified.
float   RING_BLUE       = 8;    // Drake's airstrike impact.
float   RING_QUAKE      = 14;   // Drake's quake slam.
float   RING_ICE        = 19;   // Iceball shockwave.  Ends at frame 21.

// Select frames in 's_wave2.spr'.  Each color lasts 3 frames.
float   RING2_QUAKE     = 0;
float   RING2_ICE       = 6; // Ends at frame 56.

// If you want an object that does not spray gore when hit by the likes of a chainsaw, add +1 to one of the non-zero defined bloodtypes.
// For example, (ent.bloodtype = BLOOD_RED + 1;).  The 'particle' function uses all colors within a range from (x*8) to (x*8)+7, where x ranges from 0 to 31.
float   BLOOD_NONE      = 0;
float   BLOOD_DARK      = 33;       // Black-and-blue for shadow creatures.
float   BLOOD_GREEN     = 57;       // For acid-blooded ala Alien Quake.
float   BLOOD_RED       = 73;       // Standard blood red color.
float   BLOOD_SPARKS    = 105;      // For machines like drones or robots.
float   BLOOD_PURPLE    = 145;      // For tarbaby.
float   BLOOD_BLUE      = 209;      // For cacodemons.
float   BLOOD_SHAFT     = 225;      // Alternate blood red color.
float   BLOOD_FIRE      = 233;      // For lava monsters like Chthon.
float   CHUNKS_ICE      = 41;      // For ice chunks.
float   FLx_CREATURE        =   40;     // Client + Monster
float   FLx_NOT_FALLING     =  515;     // Fly + Swim + Onground
float   GIB_EAT         = 2;    // Gib can be eaten for health.
float   GIB_DMV         = 4;    // Add damage velocity to gib velocity.
float   GIB_BODY_HALF   = 8;    // Spawn within the lower half of body.
float   GIB_BODY_FULL   = 16;   // Spawn anywhere from e.absmin to e.absmax.
float   GIB_SKIN_MATCH  = 32;   // Set gib.skin equal to self.skin, not 0.
float   GIB_BURN        = 64;   // Gib burns away.  Used for books.
float   GIBx_STATUE     = 12;   // Properties for statue gibs.  Dmv+Half.
float   GIBx_GIB        = 14;   // Normal properties for gibs.  Eat+Dmv+Half.
float   GIBx_RUBBLE     = 20;   // Properties for rubble.  Dmv+Full.
float   HOOK_NEAR   = 50;
float   INF_SAFE    =  1000000;     // Use this if operations is a possibility
float   INFINITY    = 16777215;     // High as we can go without rollover.

// Unlike in other games (e.g., Doom, Quake2).  All we need mass for are:
// 1) Who gets pulled when grappled.
// 2) Who gets shaken and damaged by earthquakes.
// For these purposes, a few weight classes are sufficient.
// Do not use them to calculate velocities, such as v = vel * (1 / mass).
// Besides, the velocity effects in Quake look best without varying mass mucking up expected flight paths of gibs and the like.
float   MASS_LIGHT      = 1;  // Under 0.5x player mass.  Target gets pulled toward grappler.
float   MASS_MEDIUM     = 2;  // From 0.5x to 1.5x player mass.  Neither target nor grappler are pulled.
float   MASS_HEAVY      = 3;  // From 1.5x to 5x player mass. Grappler gets pulled toward target.
float   MASS_SUPER      = 4;  // Over 5x player mass.  As heavy, but target is immune to quakes and resists pushing.
// Note:  Zero mass is treated as beyond superheavy.  As super, plus immune to forced movement of any kind.

// Dragon flags (NOTE:  Also used for other monsters...)
float   RYU_ELEMENTS    = 3;
float   RYU_USE_FIRE    = 0;
float   RYU_USE_ACID    = 1;
float   RYU_USE_LITE    = 2;
float   RYU_USE_ICE     = 3;
float   RYU_BOMB        = 4;
float   RYU_ALERT       = 64;       // Has better awareness and reflexes.
// float   RYU_CRANKED     = 128;      // Stronger, and may use special attacks.
float   RYU_NO_WATER    = 256;      // Hates and avoids water.
float   RYU_STAY        = 512;      // Stay if on, move if off.
float   RYU_CALM        = 1024;     // Ignore targets if on.
float   RYU_PATROL      = 2048;     // Glide back-and-forth.
float   RYU_FORCED      = 4096;     // Commanded by player to shoot.
float   RYU_BERSERK     = 65536;    // For drole.
float   RYU_JUSTHIT     = 131072;   // Cyberdemon: shoot back after pain.
float   RYU_ANGRY       = 262144;   // Infight even if alert.  Fix for Hell.
float   RYU_INSANE      = 524288;   // Attack ally if hurt by it.
float   RYU_PATH        = 1048576;  // DoE:  Stay on path, for DoE dragon.
float   RYU_DOOM        = 2097152;  // Use Doom AI.
float   RYU_REBEL       = 4194304;  // SoE:  For rebel archers in nsoe2.
float   RYU_REAPER      = 8388608;  // Soul collector.

// Speed for various missiles.
float   SPEED_HOOK      = 500;      // Was 500 in Roman, 1000 in original.
float   SPEED_BURIZA    = 2000;     // Was 1000.

float   XFL_HUNGRY      = 1;    // Eats items.  (Was Draco before removal.)
float   XFL_GHOUL       = 4;    // Allowed to eat gibs.  "Brains!"
float   XFL_USE_AMMO    = 64;     // Monster needs ammo to shoot guns.
float   XFL_NO_AIR      = 128;    // Doesn't need to breathe.
float   XFL_INEDIBLE    = 1024;   // Gremlin can't eat this corpse.
float   XFL_ZOMBIE      = 2048;   // Hurt only by 1-hit kill or scar damage.
float   XFL_NO_SCAN     = 4096;   // Ignore this monster during a worldscan.
float   XFL_ADD_TO_KILL = 65536;    // Add one to kills when killed.
float   XFL_PET         = 524288;   // Use to decrement pet counter.
float   XFL_IGNORE      = 2097152;  // Don't infight this entity.
float   XFL_SLIMER      = 4194304;  // Not harmed by slime.
float   XFL_FLUX        = 8388608;  // Made solid by ghost touch code.
float cutscene;       		// Set to TRUE during a cutscene.
float doomed;				// TRUE = Monsters respawn after death.
float respawning; 			// Toggle used when respawning monsters.
float super_active;
.float powershield_active;
.float      hittype;
vector      damage_velocity;// Set by 'T_Damage' for gib velocity.
.float      bloodtype;      // For blood other than red, like in Alien Quake.
.float      ryuflags;   	// AI flags for monsters.
.float      mass;
.float      perms;  		// Permanent powerups.
.vector     purse;      	// Used by monsters to drop money when killed.  x=coins, y=gems, z=random data.  z1=max items, z2=spawn chance, z3=gem chance.
.float      spawned;    	// TRUE if created/summoned after a level load.
.float 		spawnskin;
.void()     th_revive;  	// Resurrection scene.
.void()     th_spawn;   	// Respawn function.
.string 	hello_sound;
.float      waitmin, waitmax;
.float      xfl, xf2;   	// Extra flags without C code connections.
.float      xsf;        	// Extra spawnflags used by func_spawn and sf64.
.float      tracer_time;    // Used by rapid-fire energy weapons.
.float      zapper_time;    // Time to recharge flare gun/wand.
.float      arsenal;        // Up to 24 weapons can be stored here.
.float      war;            // Short for 'Weapon ARmed'.  Current weapon.
.float      drama1;         // DRAke Monster Arsenal.  For release 1.
.float      ammo_super;     // Super shots for crossbow.
.float      shots_max;      // Maximum shots in an attack.
.float      shots_left;     // Like currentammo.
.float      hit_points;     // True health, used to stop 'give h <#>'.
.float      curse_finished, curse_type, curse_ping;     // Necromancer debuffs.
.float      curse_slow;     // Delay nextthink to time here.
.entity     master;     	// Like owner, without the C code bondage.  HEAVILY USED by monster summoning code!  Update:  Used by all missiles for reflection.
.entity     mist;           // Link to monster capturing entity.
.entity     chain2;
.entity     mirv1;          // Link to most recently launched MIRV.
.entity     hook;           // Link to most recently launched grappling hook.

// persistent attacks
.entity     burner;         // Flame that is burning on the entity.
.vector     burn_ofs;       // Where flame burns relative to target origin.  x = v_forward, y = v_right, z = v_up.

// More powerups
.float      wing_finished, wing_time, wing_sound;       // Dark-Angel Wings *
.float      mirror_finished, mirror_time, mirror_sound, mirror_ping;  // Reflection
.float      slow_finished, slow_time, slow_ping;    // For those hit by ice arrow.
.float      tome_finished;  // Tome of Power.
.float		tome_time; // Used for wearing off sound
.float      fighting;   	// Checks if monster is really fighting while running.  Monsters can run to follow friends.
.void()     th_win;     	// Monsters:  sound when killing a player.  Missiles:  code prior to origin shift.  Items:  additional code after spawning
.float		mindex2;		// used for storing modelindex when phasing in/out
.float		level; 			// Used for monster_baron to set it as a boss of different types
.entity     divine_attacker;// Who gets credit when lightning strikes.
.float      divine_finished;// If non-zero, when an entity gets zapped.
.float      divine_hits;    // How many zaps an attacker is allowed.
.float		movecount;

// Ruby wand stats.  Normal mode.  Use 0.3 delay for Heretic wand speed, or 0.4 delay for Doom pistol speed.
float   WAND_CHARGE     = 0.4;      // Delay between charges.
float   WAND_DELAY      = 0.35;     // Reload time and delay between charges.
float   WAND_FULL       = 3;        // Maximum shots.  Super shot is max+1.
float   WAND_DAMAGE     = 16;       // Damage per charge.
float   WAND_RANGE      = 600;		// Can only shoot as far as vanilla lightning gun

// Note:  Until dragonscale armor was settled on, the dragon morph was triggered by an artifact weapon named "Eye/Mark of Bahamut".  Thus, some names are legacy code written prior to morphing armors.
.float      baha_ammo;          // Renewable energy for dragon form.
.float      baha_time;          // Time it takes for ammo to recharge.
.float      baha_click;         // Helps check for double-clicking.
.float      b0_click;       // Button0 (attack) press counter.
.float      b2_click;       // Button2 (jump) press counter.
.float      b2_time;        // Time to wait for jump double press.
.float      b2_done;        // Ignore jump if > time.  Stops spam grief.

float modelindex_saw;     // Player with chainsaw.
float modelindex_hamout;
float PUSH_ONCE = 1;
float PUSH_CURRENT = 2;     // Zerstorer -- "Silent" PUSH for water currents.
float PUSH_JUMP_ONLY = 4;   // Drake -- Push only when jump is pressed.
.float jump_time;		// Used by custom trigger_jump Q3 style jump pad
.entity fallen; // used for ressurection by Necromancer, Bane, HLord
.string spawnclassname;
.string summontarget;
.vector spawnmins;
.void() spawnfunction;
.float repairtime;
.float hammer_finished; // When Mjolnir returns to player.

// Cutscenes -- Borrowed from Zerstorer.
.string     script;         //dhm - denotes which script to read.
.string     next_script;    //dhm - denotes the current script.
.string     script_num;     //dhm - number for info_scripts.
.string     focal_point;    //dhm - focus point for camera.
.float      script_delay;   //dhm - time until next script.
.float      script_time;    //dhm - used for script timing.
.float      script_count;   //dhm - ditto.

// Elements.  PM:  Kept due to legacy.  Ordered by Horoscopes?  e.g., Ares=Fire, Taurus=Earth, Gemini=Air, Cancer=Water.
float   BARON_FIRE  = 1;
float   BARON_EARTH = 2;
float   BARON_AIR   = 3;
float   BARON_WATER = 4;

float   COST_MIRV = 5;
void(float immediate) Mirv_Use;
.float rate2; // mirv.qc (Update: ...and hydra.qc)
entity shot_head; // Used for explosive shell chain list.
entity lightning; // This is an edict set aside for the sole purpose of referencing reflected lightning bolts.
.float frozen; // Whether this has been frozen into ice, used by enemies hit by the buriza / Asgard Arbalest

float   lightzero_finished;
float   lightzero_level;
float   lightzero_rate;

float   LIGHT_ZERO          = 0;    // Lightstyle 0.
float   LIGHTZERO_NORMAL    = 12;   // Use for light "m".
float   LIGHTZERO_MIN       = 4;    // Minimum light when storming.
float   LIGHTZERO_MAX       = 25;   // Maximum light allowed.

.float  dmg_stack;

// New constants for Stinger / MIRV.
float   LOCK_DOT_PITCH  = 0.9848; // cos(10).
float   LOCK_DOT_YAW    = 0.9397; // cos(20).
float   LOCK_RANGE      = 16384; // 1000 is about 30 metres.
                                 // 4096 isn't long enough for Masque.   The fact that I'm updating this file for Masque of the Red Death here in 2021 when this was written ~2011 is kind of insane. -Qmaster
						         // 8192 wasn't long enough for Quake: Mjolnir -Qmaster
float   AREABLASTER_DAMAGE  = 15; // Was 18, but that was too much.

float SPIKEY_RANGE = 8192; // Quake2 railgun range.
float SPIKEY_DAMAGE = 9;	
float THOR_SPEED = 600;	

// Average rocket damage is 100-120.  Scaling maximum damage down to 35, the new range is from 29.17 to 35, with the average at 32.08.
// 32*3 = 96, which is double of an equalized shotgun's 6*8 (or 12*4) = 48.  Super shotgun's damage rate is doubled similarly by the Tome.
// Damage based on unmodified shotguns (or those in nsoe).  Recent decision was made to buff shotguns for Drake.
float EXSHELL_DAMAGE = 35;