// const.qc -- Globals that have a preset value.

// NOTE:  Constants that are used in multiple files should be placed
// in this file.  Those used in only one file should stay in the file
// such constants are used in.

//==========================================================================
//
//  STANDARD
//
//==========================================================================

// VARS NOT REFERENCED BY C CODE /===========================================
// PM's Note:  However, some of these values mirror what is in the q1source.

//
// constants
//
float   FALSE   = 0;
float   TRUE    = 1;
// edict.flags --------------------------------------------------------------
float   FL_FLY              =    1;
float   FL_SWIM             =    2;     // PM:  Don't imply drown immunity!
float   FL_CLIENT           =    8;     // set for all client edicts
float   FL_INWATER          =   16;     // for enter / leave water splash
float   FL_MONSTER          =   32;
float   FL_GODMODE          =   64;     // player cheat -- Invincibility
float   FL_NOTARGET         =  128;     // player cheat -- Invisibility
float   FL_ITEM             =  256;     // extra wide size for bonus items
float   FL_ONGROUND         =  512;     // standing on something
float   FL_PARTIALGROUND    = 1024;     // not all corners are valid
float   FL_WATERJUMP        = 2048;     // player jumping out of water
float   FL_JUMPRELEASED     = 4096;     // for jump debouncing

// flags found in q1source.
//float   FL_IMMUNE_WATER     = 131072;   // can't drown
//float   FL_IMMUNE_SLIME     = 262144;   // won't burn in slime
//float   FL_IMMUNE_LAVA      = 524288;   // won't burn in lava

//float   FLx_MOVE            =    3;     // Fly + Swim
float   FLx_CREATURE        =   40;     // Client + Monster
float   FLx_NOT_MISSILE     =  296;     // Client + Monster + Item
//float   FLx_CHEATS          =  192;     // Godmode + Notarget
float   FLx_NOT_FALLING     =  515;     // Fly + Swim + Onground
float   FLx_JUMP_READY      = 4608;     // Onground + Jumpreleased
// edict.movetype values ----------------------------------------------------
float   MOVETYPE_NONE           =  0;   // never moves
//float   MOVETYPE_ANGLENOCLIP    =  1;
//float   MOVETYPE_ANGLECLIP      =  2;
float   MOVETYPE_WALK           =  3;   // players only
float   MOVETYPE_STEP           =  4;   // discrete, not real time unless fall
float   MOVETYPE_FLY            =  5;
float   MOVETYPE_TOSS           =  6;   // gravity
float   MOVETYPE_PUSH           =  7;   // no clip to world, push and crush
float   MOVETYPE_NOCLIP         =  8;
float   MOVETYPE_FLYMISSILE     =  9;   // fly with extra size against monsters
float   MOVETYPE_BOUNCE         = 10;
//float   MOVETYPE_BOUNCEMISSILE  = 11;   // bounce with extra size
// PM:  Bouncemissile is undefined for Quake1.  In Quake2, it bounces off
//   the wall like Hipnotic's Laser Cannon.  (i.e., rebounding shots.)
// edict.solid values -------------------------------------------------------
float   SOLID_NOT       = 0;    // no interaction with other objects
float   SOLID_TRIGGER   = 1;    // touch on edge, but not blocking
float   SOLID_BBOX      = 2;    // touch on edge, block
float   SOLID_SLIDEBOX  = 3;    // touch on edge, but not an onground
float   SOLID_BSP       = 4;    // bsp clip, touch on edge, block
// range values -------------------------------------------------------------
float   RANGE_MELEE     = 0;
float   RANGE_NEAR      = 1;
float   RANGE_MID       = 2;
float   RANGE_LONG      = 3;    // PM:  New intermediary range.
float   RANGE_FAR       = 4;
// deadflag values ----------------------------------------------------------
float   DEAD_NO             = 0;
float   DEAD_DYING          = 1;
float   DEAD_DEAD           = 2;
float   DEAD_RESPAWNABLE    = 3;
// takedamage values --------------------------------------------------------
float   DAMAGE_NO   = 0;
float   DAMAGE_YES  = 1;
float   DAMAGE_AIM  = 2;
// items --------------------------------------------------------------------
// PM:  Modified from the original!
//float   IT_WEAPON1          =       1;      // Give 2
//float   IT_WEAPON2          =       2;      // Give 3
//float   IT_WEAPON3          =       4;      // Give 4
//float   IT_WEAPON4          =       8;      // Give 5
//float   IT_WEAPON5          =      16;      // Give 6
//float   IT_WEAPON6          =      32;      // Give 7
//float   IT_WEAPON7          =      64;      // Give 8
//float   IT_EXTRA_WEAPON     =     128;      // Give 0 (Not on sbar)
float   IT_SHELLS           =     256;
float   IT_NAILS            =     512;
float   IT_ROCKETS          =    1024;
float   IT_CELLS            =    2048;
//float   IT_AXE              =    4096;      // Not on sbar
float   IT_ARMOR1           =    8192;
float   IT_ARMOR2           =   16384;
float   IT_ARMOR3           =   32768;
float   IT_SUPERHEALTH      =   65536;      // Give 6a - hip (Not on sbar)
float   IT_KEY1             =  131072;      // Blue key
float   IT_KEY2             =  262144;      // Gold key
float   IT_INVISO           =  524288;
float   IT_PROTECT          = 1048576;
float   IT_SUIT             = 2097152;
float   IT_QUAD             = 4194304;
//float   IT_LASER_CANNON     = 8388608;      // Give 9 - hip (Not on sbar)

float   ITx_ALL_AMMO        =    3840;
float   ITx_ALL_WEAPONS     =    4223;      // Classic Quake weapons.
float   ITx_ALL_ARMOR       =   57344;      // 57344 + 65536 = 122880
float   ITx_ALL_KEYS        =  393216;
float   ITx_ALL_POWERUPS    = 7864320;

//- - - - - - - - -
// Rogue DoE item bits.  For reference only.  Do *NOT* use!
//float   IT_SHELLS           =     128;
//float   IT_NAILS            =     256;
//float   IT_ROCKETS          =     512;
//float   IT_CELLS            =    1024;
//float   IT_ALT_WEAPON3      =    4096;
//float   IT_ALT_WEAPON4      =    8192;
//float   IT_ALT_WEAPON5      =   16384;
//float   IT_ALT_WEAPON6      =   32768;
//float   IT_ALT_WEAPON7      =   65536;
//float   IT_GRAPPLE          = 8388608;
//- - - - - - - - -
// point content values -----------------------------------------------------
float   CONTENT_EMPTY   = -1;
float   CONTENT_SOLID   = -2;
float   CONTENT_WATER   = -3;
float   CONTENT_SLIME   = -4;
float   CONTENT_LAVA    = -5;
float   CONTENT_SKY     = -6;
// doors, etc. --------------------------------------------------------------
float   STATE_TOP       = 0;
float   STATE_BOTTOM    = 1;
float   STATE_UP        = 2;
float   STATE_DOWN      = 3;
// hull boundaries ----------------------------------------------------------
vector  VEC_ORIGIN      = '0 0 0';
vector  VEC_HULL_MIN    = '-16 -16 -24';
vector  VEC_HULL_MAX    = '16 16 32';
vector  VEC_HULL2_MIN   = '-32 -32 -24';
vector  VEC_HULL2_MAX   = '32 32 64';
// protocol bytes -----------------------------------------------------------
float   SVC_UPDATESTAT      =  3;   // Hipnotic
float   SVC_SETVIEWPORT     =  5;   // -> Camera <-
float   SVC_SETVIEWANGLES   = 10;   // -> Camera <-
float   STAT_TOTALSECRETS   = 11;   // Hipnotic
float   STAT_TOTALMONSTERS  = 12;   // Hipnotic
float   SVC_TEMPENTITY      = 23;
float   SVC_KILLEDMONSTER   = 27;
float   SVC_FOUNDSECRET     = 28;
float   SVC_INTERMISSION    = 30;
float   SVC_FINALE          = 31;
float   SVC_CDTRACK         = 32;
float   SVC_SELLSCREEN      = 33;
float   SVC_CUTSCENE        = 34;   // Hipnotic
// protocol bytes -----------------------------------------------------------
float   TE_SPIKE        =  0;
float   TE_SUPERSPIKE   =  1;
float   TE_GUNSHOT      =  2;
float   TE_EXPLOSION    =  3;
float   TE_TAREXPLOSION =  4;
float   TE_LIGHTNING1   =  5;
float   TE_LIGHTNING2   =  6;
float   TE_WIZSPIKE     =  7;
float   TE_KNIGHTSPIKE  =  8;
float   TE_LIGHTNING3   =  9;
float   TE_LAVASPLASH   = 10;
float   TE_TELEPORT     = 11;
//float   TE_EXPLOSION2   = 12;   // PM:  Found in Rogue qc and q1source.
//float   TE_BEAM         = 13;   // Ditto.
// sound channels -----------------------------------------------------------
// channel 0 never willingly overrides
// other channels (1-7) allways override a playing sound on that channel
float   CHAN_AUTO   = 0;
float   CHAN_WEAPON = 1;
float   CHAN_VOICE  = 2;
float   CHAN_ITEM   = 3;
float   CHAN_BODY   = 4;
// PM:  Other commonly used channels.
float   CHAN_IDLE   = 5;    // For chainsaw.
float   CHAN_FOOT   = 6;    // Footsteps.  Usually for monsters.
//- - - - - - - - -

float   ATTN_NONE   = 0;
float   ATTN_NORM   = 1;
float   ATTN_IDLE   = 2;
float   ATTN_STATIC = 3;
// update types -------------------------------------------------------------
float   UPDATE_GENERAL  = 0;
float   UPDATE_STATIC   = 1;
float   UPDATE_BINARY   = 2;
float   UPDATE_TEMP     = 3;
// entity effects -----------------------------------------------------------
float   EF_BRIGHTFIELD  = 1;
float   EF_MUZZLEFLASH  = 2;
float   EF_BRIGHTLIGHT  = 4;
float   EF_DIMLIGHT     = 8;
// messages -----------------------------------------------------------------
float   MSG_BROADCAST   = 0;    // unreliable to all
float   MSG_ONE         = 1;    // reliable to one (msg_entity)
float   MSG_ALL         = 2;    // reliable to all
float   MSG_INIT        = 3;    // write to the init string

//================================================

// attack states -----------------------------------------------------------
float   AS_STRAIGHT = 1;
float   AS_SLIDING  = 2;
float   AS_MELEE    = 3;
float   AS_MISSILE  = 4;
// Custom attack states.
float   AS_DODGING  = 5;    // One of Hipnotic's inventions for the scourge.
float   AS_CHASING  = 6;    // Use shortest, direct path to chase target.
float   AS_VERTICAL = 7;    // Like AS_SLIDING, but vertical (up or down).
float   AS_FLANKING = 8;    // AS_SLIDING if close, AS_STRAIGHT otherwise.
float   AS_FLEEING  = 9;    // Reverse of AS_STRAIGHT, used by wraith.
float   AS_REAPER   = 10;   // Sucking in souls, used by wraith.
float   AS_COWARDLY = 11;   // Back off if too close.  Otherwise, as_straight.
//- - - - - - - - -


//==========================================================================
//
//  DRAKE
//
//==========================================================================

// Nehahra stuff.  *DO NOT USE FOR STANDARD ENGINES!*
//float   MOVETYPE_FOLLOW         = 12;

//float   TE_BEAM         = 13;
//float   TE_IMPLOSION    = 14;
//float   TE_RAILTRAIL    = 15;
//float   TE_EXPLOSION3   = 16;
//float   TE_LIGHTNING4   = 17;

// items2 bits --------------------------------------------------------------
// Hipnotic/Quoth
// Note:  Defined only the bits that light up an icon.
// Note#2:  The runes will overwrite the wetsuit/shield icons.
//float   IT2_LASER       = 1;    // *Do NOT use!*  Lights up weapon 9 icon.
float   IT2_WETSUIT     = 2;    // Wetsuit
float   IT2_SHIELDS     = 4;    // Empathy shields
//float   IT2_HORN        = 8;    // Lights up nothing so it's unused.
//float   IT2_04          = 16;   // Unused.
float   IT2_RUNE1       = 32;
float   IT2_RUNE2       = 64;
float   IT2_RUNE3       = 128;
float   IT2_RUNE4       = 256;
// Here for use by possible Drake engine.
//float   IT2_RUNE5       = 512;
//float   IT2_RUNE6       = 1024;
//float   IT2_RUNE7       = 2048;
//float   IT2_RUNE8       = 4096;
// The rest are for powerups that should not persist across levels.
float   IT2_REGEN       = 8192;     // Regeneration.
float   IT2_REGEN2      = 16384;
//float   IT2_15          = 32768;
//float   IT2_16          = 65536;
//float   IT2_17          = 131072;
//float   IT2_18          = 262144;
//float   IT2_19          = 524288;
//float   IT2_20          = 1048576;
//float   IT2_21          = 2097152;
//float   IT2_22          = 4194304;
//float   IT2_23          = 8388608;

// Combo flags
float   IT2x_RUNES12    = 96;   // Runes that occupy wetsuit icon slot.
float   IT2x_RUNES34    = 384;  // Runes that occupy shield icon slot.
float   IT2x_ALL_RUNES  = 480;

// Rogue -- Here for reference only.  Only first eight bits light up icons.
//float   IT2_ARMOR1      = 1;
//float   IT2_ARMOR2      = 2;
//float   IT2_ARMOR3      = 4;
//float   IT2_ALT_NAILS   = 8;    // Lava Nails
//float   IT2_ALT_CELLS   = 16;   // Plasma
//float   IT2_ALT_ROCKETS = 32;   // Multi-rockets
//float   IT2_SHIELD      = 64;
//float   IT2_GRAVITY     = 128;
//float   IT2_SUPERHEALTH = 256;
//float   IT2_QUAKE       = 512;
//float   IT2_SPHERE      = 1024;

//==========================================================================

// Hull sizes for spiders.
vector  VEC_SPIDER_MIN      = '-16 -16 -16';
vector  VEC_SPIDER_MAX      = '16 16 20';
vector  VEC_SPIDER_MAX2     = '16 16 40';   // Used for ceiling crawler.

// math stuff ---------------------------------------------------------------
float   COS30   = 0.866;
float   COS45   = 0.7071;
float   COS60   = 0.5;
float   SQRT2   = 1.4142;   // The square root of 2.

// Infinity values.
float   INF_SAFE    =  1000000;     // Use this if operations is a possibility
float   INFINITY    = 16777215;     // High as we can go without rollover.

//float   FAT     = 2;    // Traceline with missile clip bonus vs. monsters.

vector  VEC_360     = '360 360 0';
vector  VEC_QUAKE   = '5 4 4';      // Standard earthquake angle tilts.

// thinking values ----------------------------------------------------------
float   THINK_ASAP  = 0.01;     // Think as soon as possible at the next tic.
float   THINK_NOT   = -1;       // Don't think ever.

// serverflags --------------------------------------------------------------
// Note:  First eight bits should be used only by episodes so that
// items can use spawnflags.  Values at 256 or higher can be used
// for other things.
float   SVFL_E1         = 1;    // Rune of Earth Magic
float   SVFL_E2         = 2;    // Rune of Black Magic
float   SVFL_E3         = 4;    // Rune of Hell Magic
float   SVFL_E4         = 8;    // Rune of Elder Magic
//- - - - - - - - -
//float   SVFL_E5         = 16;   // Next four reserved for episode/spawnflags.
//float   SVFL_E6         = 32;
//float   SVFL_E7         = 64;
//float   SVFL_E8         = 128;
//- - - - - - - - -
float   SVFL_FAILED     = 256;  // Episode/level ended in failure.
float   SVFL_HELL       = 512;  // Hell difficulty on.

//float   SVFLx_RUNES     = 15;   // Classic four sigils.
//float   SVFLx_RUNES2    = 241;  // Merger:  four more runes.

// Note:  2^24 - 1 = 16777215.
////////////////////////

// deathmatch values --------------------------------------------------------
float   DM_OLD_SCHOOL   = 2;    // Like Doom, weapons stay, nothing respawns.
                                // Deathmatch 2 is 'the silly old rules'.
//float   DM_DOOM         = 4;    // Use Doom style shotguns -- OBSOLETE!
float   DM_GRAPPLE      = 8;    // Players start with grapple.
float   DM_MONSTERS     = 16;   // SoE:  Monsters stay on the level.
float   DM_REVIVE       = 32;   //       Monsters resurrect after death.

// damage values ------------------------------------------------------------
// FIXME:  Redo damage types.
// acid = 1, cold = 2, fire = 3, lightning = 4, nether = 5.
float   DF_NONE         = 0;    // No flags -- just for readability.
float   DF_TIMED        = 1;    // Damage done slowly over time... usually.
float   DF_NO_ARMOR     = 2;    // Armor cannot absorb this damage.
float   DF_NO_KNOCK     = 4;    // Don't add to velocity.
float   DF_GIB          = 8;    // Attack will gib if it kills the target.
float   DF_LEECH        = 16;   // Attacker heals from target damage.
float   DF_PROXY        = 32;   // Indirect attack, no quad, no thorns.
                                //  Used by doors and the bloodcube.
float   DF_SCAR         = 64;   // Can kill zombies if applied continuously.
float   DF_ACID         = 128;
float   DF_COLD         = 256;
float   DF_FIRE         = 512;
float   DF_LIGHTNING    = 1024;
float   DF_ROCKET       = 2048; // Damage caused by rockets and equivalent.
float   DF_BURN         = 4096; // Target may ignite when damaged.
//float   DF_13           = 8192;
float   DF_MELEE        = 8192; // Melee attack, used to check a powerup.
float   DF_PERCENT      = 16384;    // Remove current hp% instead of hp.
// Radius only
float   DF_SAFE         = 32768;  // Attacker is immune to his attack.
float   DF_WATER_ONLY   = 65536;  // Takes damage only if in water.
// Special
//float   DF_17    = 131072;   // Matching class can't hurt each other.
float   DF_NO_GIB       = 131072;   // Attack cannot gib.
float   DF_ZKILL        = 262144;   // One-hit kill zombies on direct hit.
float   DF_CROSS_BLOCK  = 524288;   // Cross blocks all damage.
float   DF_PUSH_NPC     = 1048576;  // Apply knockback to npcs.
float   DF_NO_SHIELDS   = 2097152;  // Mega-enforcer shields can't stop this.
float   DF_NO_REACT     = 4194304;  // Don't get mad at attacker.
float   DF_BLESSED      = 8388608;  // Don't hit allies.
// FIXME:  Add more flags?  Must replace some of the above flags first.
// DF_HIT_ALL = Hit solid_not.
// DF_CLASSED = Ignore targets with same classname.
// DF_NO_HALF = Attacker takes full damage instead of half.
// DF_NETHER  = Hurts living, not undead.

// Combo values
//float   DFx_TYPES       = 7;
float   DFx_BURNING     = 69;  // Timed + No Knock + Scar
float   DFx_FIREBALL    = 576;  // Fire + Scar
//float   DFx_FIREBALL    = 4672; // Fire + Scar + Burn
//float   DFx_PLASMA      = 3072; // Lightning + Rocket
float   DFx_RESISTS     = 3969; // Acid + Cold + Fire + Lightning + Rocket

// hit type -----------------------------------------------------------------
//.float  hittype;

float   HIT_NORMAL  = 0;    // Default.
float   HIT_METAL   = 1;    // Knights, centroids, and other armored guys.
float   HIT_STONE   = 2;    // Statues, golems.

// mass/weight --------------------------------------------------------------
//.float      mass;

// Unlike in other games (e.g., Doom, Quake2).  All we need mass for are:
// 1) Who gets pulled when grappled.
// 2) Who gets shaken and damaged by earthquakes.
// For these purposes, a few weight classes are sufficient.
// Do not use them to calculate velocities, such as v = vel * (1 / mass).
// Besides, the velocity effects in Quake look best without varying mass
// mucking up expected flight paths of gibs and the like.
//- - - - - - - - -
float   MASS_LIGHT      = 1;  // Under 0.5x player mass.
float   MASS_MEDIUM     = 2;  // From 0.5x to 1.5x player mass.
float   MASS_HEAVY      = 3;  // From 1.5x to 5x player mass.
float   MASS_SUPER      = 4;  // Over 5x player mass.
//float   MASS_X          = 0;  // Over 10x player mass.
//- - - - - - - - -
// Note:  Zero mass is treated as beyond superheavy.
// Explanation of mass/weight classes.
//- - - - - - - - -
// Light = Target gets pulled toward grappler.
// Medium = Neither target nor grappler are pulled.
// Heavy = Grappler gets pulled toward target.
// Superheavy = As heavy, but target is immune to quakes and resists pushing.
// X = As superheavy, plus immune to forced movement of any kind.
//- - - - - - - - -

// armour values ------------------------------------------------------------
//.vector     armor_stats;    // x = armortype, y = armorvalue, z = item bit

vector  ARMOR_STATS_GREEN   = '0.3 100 8192';
vector  ARMOR_STATS_YELLOW  = '0.6 150 16384';
vector  ARMOR_STATS_RED     = '0.8 200 32768';
// Note:  Dragonscale uses the same stats as red armor.
vector  ARMOR_STATS_COURAGE = '0.95 150 8192';
vector  ARMOR_STATS_ONYX    = '0.5 0 16384';
//vector  ARMOR_STATS_POWER   = '0.5 0 32768';    // Onyx with power shield.
vector  ARMOR_STATS_DEMON   = '0 100 8192';
vector  ARMOR_STATS_SPIRIT  = '1 25 0';
vector  ARMOR_STATS_CHAOS   = '0 200 32768';
vector  ARMOR_STATS_ULTRA   = '1 30 32768';       // Ultra enforcer armor.

float   COURAGE_DAMAGE  = 10;   // Damage to armor if it reflects a rocket.

// morphing stuff -----------------------------------------------------------
//.float      form_active;        // Non-zero if player is in monster form.

// Note to self, don't add centroid morph:
// * Proper view_ofs is too low.  Things look ugly when player sits inside
//  an item he cannot take.  (e.g., ammo or health when at max capacity.)
// * Fat shambler-sized forms are often difficult to navigate with.
//  In fact, I am tempted to replace the dragon morph with something
//  such as an imp.  Dragon stays due to legacy issues (i.e., Soul of Evil).
float   FORM_DRAGON     = 1;

// Values used by dragon form.
float   BAHA_VIEW       = 8;    // view_ofs_z when in dragon form.
float   MAX_BAHA_AMMO   = 40;   // Enough for 4 second spray.

// more monster ai -------------------------------------------------------
float   ALPHA_GHOST     = 0.7;  // Used by wraiths.
float   ALPHA_ICE       = 0.7;  // Used by ice shards.
float   ALPHA_ICEBALL   = 0.9;  // Used by iceballs.

// --> Spawnflags <--
// Note:  sf32, 64, and 128 are the same as in Quoth.
// Note#2:  Zerstorer used sf64 for delay spawn, Quake2 used sf2.
float   SPAWN_AMBUSH    = 1;        // Standard.  Wake up on sight or pain.
//float   SPAWN_BOSS      = 2;        // Upgrades some to boss versions.
float   SPAWN_STATUE    = 4;        // Statue mode for select monsters.
float   SPAWN_WHITE     = 16;       // Monster teams up and helps client.
float   SPAWN_SILENT    = 32;       // Slient sf64.
float   SPAWN_NORMAL    = 64;       // Spawns when triggered; classic sf64.
float   SPAWN_AWARE     = 128;      // Monsters:  Spawn mad at activator.
float   SPAWN_RESPAWN   = 128;      // Items:  Always respawn.
// Next four are used by Quake engine to remove entities during level load.
//float   SPAWN_NOT_EASY  = 256;
//float   SPAWN_NOT_NORM  = 512;
//float   SPAWN_NOT_HARD  = 1024;
//float   SPAWN_NOT_DM    = 2048;
//- - - - - - - - -

float   SPAWNx_DELAY    = 96;       // Delayed spawning.
float   SPAWNx_RESERVED = 240;      // Set for all monsters.
//float   SPAWNx_MASKS    = 3840;     // !easy, !norm, !hard, !dm

//===========================================================================

// Monsters that have a common family do not infight from friendly fire
// alone unless insane.
//.float      family;

// FIXME:  This needs an overhaul soon!
// Note:  Goblin-folk of Mordor tend to infight, so no family for them.
float   FAM_BANE        = 1;    // All knights aligned with Bane.
float   FAM_UNDEAD      = 2;    // Zombies, ghosts, wraths.
float   FAM_DRAGON      = 4;    // Uh... dragons.
float   FAM_NECRO       = 8;    // The Ebon/Disciple family.
float   FAM_ARMY        = 16;   // Grunts, enforcers, and their variants.
float   FAM_WRATH       = 32;   // Wrath and Overlord.
float   FAM_ARCHER      = 64;   // For archer and archer lord (orc/assassin).
float   FAM_IMP         = 128;  // Gremlins and imps.
float   FAM_DROID       = 256;  // Robots.
float   FAM_GOLEM       = 512;  // Animated statues.
float   FAM_BLOB        = 1024; // Tarbaby and vomitus.
float   FAM_SPIDER      = 2048; // Spiders and shalrath.
float   FAM_DOG         = 4096; // Rottweilers, hell hounds, and fiends.

float   FAMx_NONLIVING  = 770;    // Constructs and undead.

//===========================================================================

// NOTE:  Cannot use defined vars.
// TRUE = Use Zerstorer weapons and entities.
// DISABLED:  No Zerstorer mode toggle.
//float   zerstorer   = 0;    // Zerstorer mode. *Do NOT change in progs!*

// 'Saved1' values ----------------------------------------------------------
// PM:  Changed 'saved1' to 'temp1' due to FrikBot.
float   GM_DMSP         = 1;    // DMSP mode.
float   GM_CRANKED      = 2;    // Stronger monsters and deadlier falling.
float   GM_RESPAWN      = 4;    // Monsters respawn after death.
float   GM_DECAY        = 8;    // Corpse removal.
float   GM_FOOTSTEPS    = 16;   // Footstep sounds for players and npcs.
float   GM_SUMMON_ALL   = 32;   // Precache all monsters for summoning.
float   GM_AGGRO        = 64;   // All monsters spawn aware of player.
float   GM_HELL         = 128;  // Force Hell difficulty.
// Below are test values.  Remove them all before final release.
float   GM_BSP_TEST     = 256;  // Test:  Fix Tronyn's bsp item placement.
float   GM_SOUL_EVIL    = 512;  // Test:  Soul of Evil mode.
float   GM_MEDIEVAL     = 1024; // Test:  Convert soldiers to medieval dudes.
float   GM_OUM          = 2048; // Test:  Operation Urth Magic mode.
// FIXME:  ???
float   GM_MUSIC_OFF    = 4096; // Music Toggle.
float   GM_PURIST       = 8192; // Use original weapons and monster behavior.
float   GM_DRAGONSCALE  = 16384;    // Enable dragonscale.
float   GM_PLAYER       = 32768;    // Enable saw and hammer player models.
float   GM_THUNDERSTORM = 65536;    // Mjolnir uses old thunderstorm effect.

//float   gamemode;       // Based on the value of 'saved1'.

//===========================================================================
//  Weapons

float   ATTN_DAMAGE = 0.5;      // Default attenuation for radius damage.

//float   RATE_BLASTER    = 0.133333;     // 4/30 fps.
//float   RATE_CHAINGUN1  = 0.128571;     // 9/70 fps.
//float   RATE_CHAINGUN1  = 0.1142857;    // 4/35 fps.
//float   RATE_CHAINGUN2  = 0.142857;     // 5/35 fps.

float   HOOK_NEAR   = 50;

// Power armor damage absorption.
float   DAMAGE_PER_CELL   = 2;

// Speed for various missiles.
float   SPEED_HOOK      = 500;      // Was 500 in Roman, 1000 in original.
float   SPEED_BURIZA    = 2000;     // Was 1000.

// Ruby wand stats.  Normal mode.
// Use 0.3 delay for Heretic wand speed, or 0.4 delay for Doom pistol speed.
float   WAND_CHARGE     = 0.4;      // Delay between charges.
float   WAND_DELAY      = 0.35;     // Reload time and delay between charges.
float   WAND_FULL       = 3;        // Maximum shots.  Super shot is max+1.
float   WAND_DAMAGE     = 16;       // Damage per charge.
float   WAND_RANGE      = 600;

// Ammo costs for various weapons.
float   COST_MJOLNIR    = 25;   // Was 30, too much.
float   COST_MIRV       = 5;
float   COST_BAHA_BOMB  = 8;    // Dragon form's meteor attack.

// Burning damage constants.
float   BURN_PER_SECOND     = 4;    // 4 is slime dmg, 5 divides evenly with armor %s.
float   MAX_BURN_DAMAGE     = 60;   // Enough to kill standard zombies.
                                    // FIXME: No it isn't with regeneration!

// Ammo limits.
// Note:  Never set higher than 255 because of 8-bit hud.
// Also, don't be silly by setting numbers to a non-integer, or less than 1.
float   AMAX_SHELLS     = 100;
float   AMAX_NAILS      = 200;
float   AMAX_ROCKETS    =  50;      // Half capacity.
float   AMAX_CELLS      = 200;
float   AMAX_SUPER      =  10;      // HUD currentammo is red at 10 or less.

// Expanded limits for those with the bulk pack.
float   AMAX2_SHELLS    = 120;      //125
float   AMAX2_NAILS     = 250;
float   AMAX2_ROCKETS   =  60;
float   AMAX2_CELLS     = 250;
// Ammo must be 10 or less to display red numbers, so no extra ice bolts.

// Standard ammo amounts.
// Note:  Shells value below convert automatically for modified shotguns.
//  See ShellGame function elsewhere for details.
float   SMALL_SHELLS    =  20;
float   SMALL_NAILS     =  25;
float   SMALL_ROCKETS   =   5;
float   SMALL_CELLS     =  12;      //6
float   SMALL_SUPER     =   1;

float   LARGE_SHELLS    =  40;
float   LARGE_NAILS     =  50;
float   LARGE_ROCKETS   =  10;
float   LARGE_CELLS     =  25;      //12
float   LARGE_SUPER     =   2;

float   SHELLS_START    =  25;      // Starting ammo.

// Note to self, don't add IKguns:
// * Models are off to the side, while Quake weapons are centered.
// * Plasma gun Doom/IK style is redundant with super nailgun, lasers,
//  and lightning guns.  (Quoth style plasma on the other hand...)
// * Asha is not necessary now that Tome of Power modifies shotguns to
//  fire similar effects.
// There, I said it!  Here so I don't think about adding the asha back.

// Note 1/31/2010:  Plasma can kill zombies, but lasers can't, so plasma
// may need to be added back in case Quoth compatibility is needed.
// Also, chainsaw could be added back.  Just use standard model and
// lightning gun frames.  Worked for Doom.

// Note 3/31/2010:  Added Quoth's plasma gun.  Why? Two reasons.
// One, ToP induced BFG10K mode is better suited for plasma weaponry
// instead of chain lightning.  Two, it's the perfect weapon for a
// high-level soldier NPC.  (Quoth eliminator, DoomRL former commando.)

//- - - - - - - - -
// Bits are sorted for 'RankForWeapon'.  Higher ranking weapons use high
// bits, and lower ranking weapons use low bits.  I use the "bigger is
// better" paradigm because it is possible for a player to have
// NO weapons, and the weapon value for an unarmed player is zero.
// Unarmed players cannot attack -- at all.  Having even a crappy
// low-bit weapon is still better than having no weapon.
//- - - - - - - - -
// Note:  Axe and sword are interchangable.
//
// Update:  Moved Mjolnir to the high end, since it was powered-up.
// An upgrade item will be required in Drake, but not in Tronyn's mods.
//- - - - - - - - -
// Update 4/20/2011:  Forget Mjolnir upgrade, leave it powered up.
//- - - - - - - - -
// Update 5/26/2011:  I'll level with you.  Any plans I had for building
// maps have been scrapped.  Tronyn is wrapping up his maps.  No point in
// entertaining feature creep if they won't be used.  What this means is
// the removal of some weapons.  Gone are the following:  Monster tamer,
// auto shotgun, and railgun.  Monster tamer, I really wanted, as the
// replacement for the Draco bot, but building a good model is too much
// work for me, and implementation without interfering with other stuff
// is a problem.  Auto shotgun, the one from Nehahra is somewhat crude
// and not very Quakey.  Railgun, standard Quake does not handle such
// effects very well, both engine and level/AI design.  I also need to
// build a good model, or reskin the grapple -- I'm not doing that.
// Pity, railgun is a classic weapon.
//
// Note 6/17/2011:  Railgun effect may return as a crossbow upgrade item.
//- - - - - - - - -
float   WAR_GRAPPLE          =       1;     // Built as a tool, not a weapon.
float   WAR_AXE              =       2;     // Knives aren't as good as guns.
float   WAR_CHAINSAW         =       4;     // 50% stronger than axe.
float   WAR_SHOTGUN          =       8;
float   WAR_ZAPPER           =      16;     // Low base damage, but chargable.
float   WAR_NAILGUN          =      32;
float   WAR_SUPER_SHOTGUN    =      64;     // Buffed to riotgun/Q3 strength.
float   WAR_BLASTER          =     128;
float   WAR_GRENADE_LAUNCHER =     256;
float   WAR_SUPER_NAILGUN    =     512;
float   WAR_SIDEWINDER       =    1024;     // Proximity gun replacement.
float   WAR_ROCKET_LAUNCHER  =    2048;
float   WAR_LASER_CANNON     =    4096;
float   WAR_PLASMA_GUN       =    8192;     // Quoth's, with less damage.
float   WAR_THUNDERBOLT      =   16384;
float   WAR_CHAIN_LIGHTNING  =   32768;
float   WAR_CRUISE_MISSILE   =   65536;     // Most destructive gun.
float   WAR_MJOLNIR          =  131072;     // Modified to BFG-like power.
float   WAR_BURIZA           =  262144;     // Insta-kill crossbow.
//float   WAR_19               =  524288;
//float   WAR_20               = 1048576;
//float   WAR_21               = 2097152;
//float   WAR_22               = 4194304;
//float   WAR_23               = 8388608;     // Highest bit, and best weapon.
// All 24 bits on equals 16777215.

// Weapon combo values
float   WARx_QUAKE_WEAPONS  =    19306;     // Original Quake weapons
float   WARx_AXE_FRAMES     =   131074;     // Use axe frames on this weapon.
float   WARx_WEAPON_FREE    =   131095;     // These don't need ammo to use.
float   WARx_NO_STEALING    =   131103;     // Monsters can't steal these.
float   WARx_LASERS         =     4224;     // Blaster/Laser Cannon guns.
float   WARx_SHAFT          =    49152;     // Chain/Thunderbolt guns.
float   WARx_DISCHARGE      =   188416;     // Discharge when used underwater.
// WARx_AI* are used by monster code only.
float   WARx_AI_RAPID_FIRE  =    53792;     // Nails, LC, Shafts.
float   WARx_AI_GUNS        =   131048;     // Guns used by monster_army npcs.

float   WARx_USES_SHELLS    =       72;
float   WARx_USES_NAILS     =      544;
float   WARx_USES_ROCKETS   =    68864;
float   WARx_USES_CELLS     =   192640;

// IMPORTANT!!!  This next one determines what weapons are usable and
// available in the game.  Not even the 'legalized' field can override it.
float   WARx_ALL_WEAPONS    =   524287;     // All usable weapon bits on!

// This links weapons to icons on the sbar.
float   WARx_WEAPON1    =      24;  // items/weapon ==   1 (Shotgun)
float   WARx_WEAPON2    =      64;  // items/weapon ==   2 (Super Shotgun)
float   WARx_WEAPON3    =      32;  // items/weapon ==   4 (Nailgun)
float   WARx_WEAPON4    =    4736;  // items/weapon ==   8 (Super Nailgun)
float   WARx_WEAPON5    =    1280;  // items/weapon ==  16 (Grenades)
float   WARx_WEAPON6    =   67584;  // items/weapon ==  32 (Rockets)
float   WARx_WEAPON7    =  319488;  // items/weapon ==  64 (Thunderbolt)
//float   WARx_WEAPON7    =   57344;  // items/weapon ==  64 (Thunderbolt)
//float   WARx_WEAPON8    =  262144;  // items/weapon == b23 (Laser Cannon)
float   WARx_WEAPON8    =       0;  // items/weapon == 128 (Mjolnir)
float   WARx_WEAPON9    =       0;  // items/weapon == 128 (Mjolnir)

// Impulses ----------------------------------------------------------------

// REMOVED

// laser flags --------------------------------------------------------------
// Note:  Laser colors... don't use blue for laser.mdl because of Qrack.
float   LF_RED      = 1;
float   LF_YELLOW   = 2;
float   LF_BOUNCE   = 4;        // Rebounds off the wall.
float   LF_GLOW     = 8;
float   LF_SPARKS   = 16;       // Emits faint sparking trail.
float   LF_SAFE     = 32;       // Attacker is immune.

float   LFx_BLUE    = 3;        // Both colors on gives blue.
float   LFx_HIP     = 5;        // Hipnotic laser properties.

// arrows -------------------------------------------------------------------
float   AKARROW_SPEED_FLY   = 1000;
//float   AKARROW_SPEED_TOSS  = 1200;
float   ARROW_FLY   = 2;    // Use 0=FALSE(toss) or 2=TRUE(flymissile).

// arrow model skins
float   ARROW_WOOD  = 0;
float   ARROW_EBONY = 1;
float   ARROW_ICE   = 2;
float   ARROW_MAGIC = 3;    // Orange.  Use skin + 3 to match laser colors.

// rocket damage types ------------------------------------------------------
float   MDAM_RANDOM     = 0;    // damage = damage * (5+random()) / 6
float   MDAM_GRENADE    = 1;    // Use radius damage, with minimum of 10% max.
float   MDAM_FULL       = 2;    // Full damage on contact.
float   MDAM_TWENTY     = 3;    // Damage ranges from dmg-20 to dmg.

// extra flags --------------------------------------------------------------
//.float      xfl;        // Extra flags without C code connections.

float   XFL_HUNGRY      = 1;    // Eats items.  (Was Draco before removal.)
float   XFL_ITEMS       = 2;    // Can pickup items.
float   XFL_GHOUL       = 4;    // Allowed to eat gibs.  "Brains!"
float   XFL_IMMUNITY    = 8;    // Entity is immune to poison.
//float   XFL_TELEPORT    = 16;   // Teleporters can transport this entity.
float   XFL_WIND        = 32;     // Wind tunnels can push this entity.
float   XFL_USE_AMMO    = 64;     // Monster needs ammo to shoot guns.
float   XFL_NO_AIR      = 128;    // Doesn't need to breathe.
//float   XFL_WATER       = 256;    // Breathes in water instead of air.
// FIXME:  Add rank.
float   XFL_BOSS        = 512;    // Boss -- Don't infight if coaligned.
float   XFL_INEDIBLE    = 1024;   // Gremlin can't eat this corpse.
float   XFL_ZOMBIE      = 2048;   // Hurt only by 1-hit kill or scar damage.
float   XFL_NO_SCAN     = 4096;   // Ignore this monster during a worldscan.
float   XFL_SHIELDS     = 8192;   // Has DAMAGE_NO because of shields.
float   XFL_ARMORED     = 16384;  // Magic-resistant/immune to knightspike.
float   XFL_GHOST_BANE  = 32768;  // Able to hurt ghosts.
float   XFL_ADD_TO_KILL = 65536;    // Add one to kills when killed.
float   XFL_FIREANGEL   = 131072;   // Immune to splash damage (cyberdemon).
//float   XFL_GRENADE     = 262144;   // Use different damage algorithm.
float   XFL_PET         = 524288;   // Use to decrement pet counter.
float   XFL_NO_BURN     = 1048576;  // Cannot ignite.
float   XFL_IGNORE      = 2097152;  // Don't infight this entity.
float   XFL_SLIMER      = 4194304;  // Not harmed by slime.
float   XFL_FLUX        = 8388608;  // Made solid by ghost touch code.

//.float      xf2;

float   XF2_QUAKE       = 1;    // Safe for quake to shake.
float   XF2_HORN        = 2;    // Enemy may be charmed by horn.
//float   XF2_ETHEREAL    = 4;    // Enemy has fazed out.
float   XF2_BOOMERANG   = 8;    // Missile that can return to owner.
float   XF2_CLONE       = 16;   // For Rogue Guardian.

//.float      xsf;        // Extra spawnflags used by func_spawn and sf64.

float   XSF_MOVETYPE    = 15;   // Monster's old movetype.  *Do NOT change!*
float   XSF_FUNC_SPAWN  = 16;   // Spawned by func_spawn.
float   XSF_SPAWNSILENT = 32;   // No fog effects when spawned.
float   XSF_SPAWNAWARE  = 64;   // Mad at activator when spawned.
float   XSF_NO_FALL     = 128;  // Temp add fly flag to stop prethink fall.
float   XSF_STATUE      = 256;  // Spawned as statue.
float   XSF_DMSP        = 512;  // Spawned by dmsp monster spawner.
float   XSF_GO          = 1024; // Player:  TRUE = Repeat spawn.
float   XSF_CHEST_HACK  = 2048;
float   XSF_BODY_DOUBLE = 4096; // Spawned decapitated body double.
float   XSF_CUBE_SPAWN  = 8192; // Spawned by cube, used in telefrag check.
float   XSF_GHOST_HACK  = 16384;    // nsoe1:  Ghost can be hit by any melee.

// Bits for edict.style.  (PM:  Under construction.)
// Note:  The first two are already used in other mods.
// FIXME:  Remove if not in zer mode.
float   STYLE_SPAWN_FX      = 1;    // sf64, teleport effects.
float   STYLE_SPAWNAWARE    = 2;    // sf64, spawn mad at activator.
float   STYLE_CALM          = 4;    // Wake up only if damaged or targeted.
//float   STYLE_GUARD         = 8;    // Monsters stand ground.

// More powerups -----------------------------------------------------------
// Bits 00-07 (values 1-128) are reserved for health.
// Bits 08-11 (values 256-2048) are reserved for armor.
float   POW_ARMOR1      = 256;      // Divide this into perms for suit value.
float   POW_POWER_ARMOR = 4096;     // Power shield toggle.
// Note:  Do NOT use the next three for exotic armor!
//  That is because item flags use those values for basic armor,
//float   POW_RESIST      = 8192;     // Half damage.
//float   POW_REGEN       = 16384;    // Regeneration.
//- - - - - - - - -
float   POW_DOUBLE      = 65536;    // Twin shot -- nailgun buff.
float   POW_SHOTTYMAN   = 131072;   // Shotgun buff.
float   POW_VAMPIRE     = 262144;   // Melee buff.
float   POW_PACK        = 524288;   // Extra ammo capacity.
//float   POW_20          = 1048576;
//float   POW_21          = 2097152;
float   POW_HINT_ARMOR  = 4194304;  // Armor instructions.
float   POW_HINT_FALL   = 8388608;  // nsoe4:  slow falling message.

float   POWx_HEALTH     = 255;      // Extra max health.  First 8 bits.
float   POWx_ARMOR      = 3840;     // Mutually exclustive exotic armor.

// List of exotic armor.  Player can wear only one at a time.  Duh!
float   SUIT_COURAGE    = 1;    // Reflective half-armor.  From Zerstorer.
float   SUIT_DRAGON     = 2;    // Dragonscale and morph.
float   SUIT_ONYX       = 3;    // Indestructible.
float   SUIT_ONYX_POWER = 4;    // As Onyx, plus built-in power shield.
float   SUIT_BERSERKER  = 5;    // Demonhide - regeneration and life-saving.
float   SUIT_SPIRIT     = 6;    // Spirit shroud, like hyper enforcer shield.
float   SUIT_CHAOS      = 7;    // Variable protection, teleportation.
float   SUIT_NINJA      = 8;    // Jumpsuit with special powers.
float   SUIT_ULTRA      = 9;    // Ultra enforcer particle shield.  NPC only.

float   SUITx_ALL       = 15;   // Value must be a power of 2 minus 1.
                                // This means 3, 7, or 15.  No higher.

// SCC_ ?
float   PCH_INVISO_USE      = 1;    // Mumbling jibba-jabba.
float   PCH_PROTECT_END     = 2;
float   PCH_SUIT_END        = 4;    // Also used by thorns and scuba.
float   PCH_QUAD_END        = 8;
float   PCH_THORNS_USE      = 16;
float   PCH_SCUBA_USE       = 32;   // Bubbles
float   PCH_WING_END        = 64;
float   PCH_WING_USE        = 128;
float   PCH_MIRROR_END      = 256;
float   PCH_MIRROR_USE      = 512;
float   PCH_TOME_END        = 1024;
float   PCH_CROSS_END       = 2048;
float   PCH_CROSS_USE       = 4096;
float   PCH_EAT_GIB         = 4194304;
//float   PCH_BOSS_FOG        = 8388608;

float   CURSE_DAMAGE        = 1;    // Reverse Resistance
float   CURSE_WEAKEN        = 2;    // Reverse Strength
float   CURSE_SLOW          = 3;    // Reverse Haste
float   CURSE_ARMOR         = 4;    // Reverse Regeneration
float   CURSE_CONFUSE       = 5;
//float   CURSE_LIFETAP       = 6;

// FIXME:  Traits are obsolete.  Keep but change to CTF Runes.
// Players can have only one rune.
float   TECH_ARMOR      = 1;    // Takes only half damage.
//float   TECH_POWER      = 2;    // Double damage.
float   TECH_HASTE      = 2;    // Double speed.
float   TECH_REGEN      = 3;    // Regenerates damage.


//==========================================================================
//  DRAGONS

//.float      ryuflags;   // AI flags for monsters.

// Dragon flags (NOTE:  Also used for other monsters...)
float   RYU_ELEMENTS    = 3;
    float   RYU_USE_FIRE    = 0;
    float   RYU_USE_ACID    = 1;
    float   RYU_USE_LITE    = 2;
    float   RYU_USE_ICE     = 3;
float   RYU_BOMB        = 4;
//float   RYU_03          = 8;
//float   RYU_04          = 16;
//float   RYU_05          = 32;
float   RYU_ALERT       = 64;       // Has better awareness and reflexes.
float   RYU_CRANKED     = 128;      // Stronger, and may use special attacks.
float   RYU_NO_WATER    = 256;      // Hates and avoids water.
float   RYU_STAY        = 512;      // Stay if on, move if off.
float   RYU_CALM        = 1024;     // Ignore targets if on.
float   RYU_PATROL      = 2048;     // Glide back-and-forth.
float   RYU_FORCED      = 4096;     // Commanded by player to shoot.
//float   RYU_GREEDY      = 8192;     // PET:  Take every item with loot rank.
//float   RYU_LOADED      = 16384;    // PET:  Currently holds loot.
//float   RYU_RUNAWAY     = 32768;    // PET:  Ignore items.
//float   RYU_DRACO       = 65536;    // PLAYER:  Draco is alive!
//float   RYU_TELEPORT    = 131072;   // PET:  Draco was told to teleport.
float   RYU_BERSERK     = 65536;    // For drole.
// FIXME:  Next three bits could be moved to somewhere else?
float   RYU_JUSTHIT     = 131072;   // Cyberdemon: shoot back after pain.
//float   RYU_SLOW        = 262144;   // PET:  Move slowly for one frame.
float   RYU_ANGRY       = 262144;   // Infight even if alert.  Fix for Hell.
float   RYU_INSANE      = 524288;   // Attack ally if hurt by it.
float   RYU_PATH        = 1048576;  // DoE:  Stay on path, for DoE dragon.
//float   RYU_FLANKER     = 2097152;  // Move like Quoth enforcers.
float   RYU_DOOM        = 2097152;  // Use Doom AI.
float   RYU_REBEL       = 4194304;  // SoE:  For rebel archers in nsoe2.
float   RYU_REAPER      = 8388608;  // Soul collector.
//float   RYU_NO_SIGHT    = ???       // No Line of sight needed for attacks.


//===========================================================================
//  DMSP

// FIXME:  ???
float   DMSP_ON         = 1;    // DMSP is active; use only if no other rules.
float   DMSP_START      = 2;    // Player starts at sp/coop points.
float   DMSP_NOCOUNT    = 4;    // 100% kills does not clear the map.
//float   DMSP_NOLIMIT    = 8;    // Infinite monster spawn until player dies.


//===========================================================================
//  TRONYN
//  (FIXME:  For Tronyn only -- remove for Drake.)

//.float      tronyn;     // Flags that do special things in his maps.

float   DJG_STRIP       = 1;    // Strips all items.
float   DJG_BSP_SHIFT   = 2;    // Move ammo/health boxes by '-16 -16 z'.
//
float   DJG_SNOW        = 4;    // unf2: Use snow skins on select monsters.
float   DJG_MEDIEVAL    = 8;    // Replace base soldiers with medieval.
float   DJG_SOUL_EVIL   = 16;   // Soul of Evil, extra cash and variant obits.
float   DJG_OUM         = 32;   // OUM mode.  For Tronyn's toum map.
//float   DJG_NSOE4       = 4;    // Wind and flame hacks for nsoe4.
float   DJG_GROUND64    = 64;   // Force delayed spawn walkmonsters onground.
float   DJG_NO_DROWN    = 128;  // Monsters cannot drown in this level.
float   DJG_VOID        = 256;  // Convert trigger_hurt to trigger_void.
float   DJG_WIND        = 512;  // Adds wind hack to nsoe4.
float   DJG_ARENA       = 1024; // automatic dmsp in single-player.

//float   DMSP_ON         = 1;    // DMSP is active; use only if no other rules.
//float   DMSP_START      = 2;    // Player starts at sp/coop points.
//float   DMSP_NOCOUNT    = 4;    // 100% kills does not clear the map.
////float   DMSP_NOLIMIT    = 8;    // Infinite monster spawn until player dies.
//float   DMSP_NOMOCK     = 16;   // Prevents Bishop from mocking the player.

//float   DJG_03          = 8;
//float   DJG_04          = 16;
//float   DJG_05          = 32;
//float   DJG_06          = 64;
//float   DJG_07          = 128;


//===========================================================================
//  Stuff from other files in the previous code base.

// blood.qc
//============
// If you want an object that does not spray gore when hit by the likes of
// a chainsaw, add +1 to one of the non-zero defined bloodtypes.
// For example, (ent.bloodtype = BLOOD_RED + 1;).
//
// The 'particle' function uses all colors within a range
// from (x*8) to (x*8)+7, where x ranges from 0 to 31.
//============
float   BLOOD_NONE      = 0;
float   BLOOD_DARK      = 33;       // Black-and-blue for shadow creatures.
float   BLOOD_GREEN     = 57;       // For acid-blooded ala Alien Quake.
float   BLOOD_RED       = 73;       // Standard blood red color.
float   BLOOD_SPARKS    = 105;      // For machines like drones or robots.
float   BLOOD_PURPLE    = 145;      // For tarbaby.
//float   BLOOD_BLUE      = 209;      // For cacodemons.
//float   BLOOD_SHAFT     = 225;      // Alternate blood red color.
float   BLOOD_FIRE      = 233;      // For lava monsters like Chthon.
float   CHUNKS_ICE      = -41;      // For ice chunks.

// Blood bits for bloodbank
float   BB_GREEN    = 1;
float   BB_PURPLE   = 2;
float   BB_FIRE     = 4;

// hp.qc
// Rate of regeneration granted by one rejuvenator powerup.
// Update:  Sped up to 1 hp per second.
// Was 1.2, which was 0.833 hp/sec, or 50 hp/min.
float   REGEN_RATE1 = 1;        // 1 hp/sec, or 60 hp/min.

// gibs.qc
// Gibflag constants.
float   GIB_HEAD        = 1;    // Head gib.
float   GIB_EAT         = 2;    // Gib can be eaten for health.
float   GIB_DMV         = 4;    // Add damage velocity to gib velocity.
float   GIB_BODY_HALF   = 8;    // Spawn within the lower half of body.
float   GIB_BODY_FULL   = 16;   // Spawn anywhere from e.absmin to e.absmax.
float   GIB_SKIN_MATCH  = 32;   // Set gib.skin equal to self.skin, not 0.
float   GIB_BURN        = 64;   // Gib burns away.  Used for books.
// Combo gibflags.
float   GIBx_STATUE     = 12;   // Properties for statue gibs.  Dmv+Half.
float   GIBx_GIB        = 14;   // Normal properties for gibs.  Eat+Dmv+Half.
float   GIBx_RUBBLE     = 20;   // Properties for rubble.  Dmv+Full.

// items.qc
float   CURE_HEALTH         = 25;   // Minimum health needed for antidote.
float   MAX_EXTRA_LIFE      = 100;  // Max health allowed to be saved in pack.
//float   MAX_ANTIDOTE        = 4;    // 'ceil(MAX_EXTRA_LIFE / CURE_HEALTH)'.

// soul.qc
float   WRAITH_HP_AETHER    = 50;   // Must be lower than critical.
float   WRAITH_HP_CRITICAL  = 60;   // Flee when health falls below this.


//===========================/  END OF FILE  /===========================//
