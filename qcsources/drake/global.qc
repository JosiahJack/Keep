// global.qc -- Contains global variables used in Quake.

// NOTE:  All global variables used in Drake should be placed in this file.

//==========================================================================
//
//  STANDARD
//
//==========================================================================

//----------------------------------
// PM's note... about 'string_null'.
//----------------------------------
// Unless every string field checks for "", we need string_null.
// For example, some secret doors, which checks for (self.message) and
// not (self.message != "") will beep when touched.  I don't know if
// parts of the source itself, which cannot be modified by QuakeC, has
// similarily booby-trapped string comparisons.
//
// Currently used in func.qc (originally doors.qc) and items.qc.
// Also in some Hipnotic code.
//
// Update:  Avoid use of string null if possible.  This is because, in
// some engines, string_null is NOT a null string after a saved game load.
//
// Update 6/7/09:  Removed 'string_null' because Quake assigns "" to it
// when writing to a savegame file, and upon reload, string_null is not
// null anymore.  To get around this, Drake uses an unused string field
// from the worldspawn entity.
//----------------------------------

//
// globals
//
//float       movedist;
float       gameover;       // set when a rule exits
//string      string_null;    // null string, nothing should be held here
//float       empty_float;    // Not used in standard v1.06 QC progs.
entity      newmis;         // launch_spike sets this after spawning it
entity      activator;      // the entity that activated a trigger or brush
entity      damage_attacker;    // set by T_Damage
float       framecount;     // Now used by Drake for worldscans.
float       skill;
//================================================

// ai.qc (originally in fight.qc)
float       enemy_vis, /*enemy_infront,*/ enemy_range, enemy_yaw;
//float       current_yaw;
//
// when a monster becomes angry at a player, that monster will be used
// as the sight target the next frame so that monsters near that one
// will wake up even if they wouldn't have noticed the player
//
entity      sight_entity;
float       sight_entity_time;

// triggers.qc (formerly in client.qc)
float       intermission_running;       // FIXME:  Use 'gameover' for this.
float       intermission_exittime;
string      nextmap;

// weapons.qc
entity      multi_ent;
float       multi_damage;

// hknight.qc
float       hknight_type;


//==========================================================================
//
//  MISSION PACKS
//
//==========================================================================

// DISABLED -- Proximity bombs replaced by sprocket inspired drill bombs.
// proxy.qc
//float       NumProximityGrenades;
//float       NumSpikeTraps;      // PM:  Tome of Power proxy bombs.

// spawn.qc
// horn stuff
// PM:  Removed horn_active because horn_charmer can serve the same purpose.
entity      horn_charmer;   // We can't use 'other' directly because it
                            // changes during SUB_UseTargets.


//==========================================================================
//
//  DRAKE
//
//==========================================================================

float       albatross;  // TRUE = Reset items and health when entering level.
float       angry_monsters; // TRUE = Monsters spawn aware of player.
float       bsp_shift;  // TRUE = Fix bsp items by '-16 -16 0'.
float       cash_drop;  // TRUE = Monsters may drop money.
float       corpse_removal; // TRUE = Monsters disappear soon after death.
float       cranked;    // TRUE = Stronger monsters and brutal falling rules.
float       cutscene;       // Set to TRUE during a cutscene.
float       doomed;     // TRUE = Monsters respawn after death.
//float       engine;     // Set to TRUE in my custom engine.
float       footsteps;  // TRUE = Footsteps by player and human NPCs.
float       gamemode;   // Based on the value of 'saved1'.
float       ghosttouch; // TRUE = Use ghost code.
float       gloat;      // GLObal fLOAT -- like hknight_type.
float       legalized;  // Weapons allowed in the game.
float       map_ammo1;  // Default armor and shells.
float       map_ammo2;  // Default nails, rockets, and cells.
float       map_armor;  // Default armor.
float       map_guns;   // Default weapons given by a map.
float       map_woc;    // Default weapon of choice.
float       medieval;   // TRUE = Replace grunts with goblins.
float       multi_headinjury;   // If >=25, blow off his head!
float       noenemies;  // TRUE = Don't spawn monsters during level load.
float       oum;        // TRUE = OUM mode.
float       pco;        // Content value at world origin.  Set at worldspawn.
                        //  Used by monster removal to prevent false splash.
float       powcache;       // Artifact sounds known to be precached.
float       q1shot;     // TRUE = Use weak, original shotgun attacks.
//float       qrack;      // TRUE = Use different flame models for Qrack.
float       respawning; // Toggle used when respawning monsters.
float       soul_evil;  // TRUE = Soul of Evil mode.  Merger code.
//float       started;    // Set to TRUE by info_player_start.
float       super_active;   // Set by one-at-a-time fx heavy attacks.
float       sys_ticrate;    // Use instead of blindly adding 0.1 for next tic.
float       visible_distance;   // Hipnotic: Used by gremlin AI.
//float       vision;         // TRUE = Use vision cutscenes.  FALSE = Zer's.
//float       zerstorer;      // Zerstorer mode.
//float       zfall;          // Non-zero means anything below this falls slower.

// Counters

// Map rules

// Weapons
float       radar_time;     // Time to ping.  Used by melee in dmsp.
vector      damage_velocity;    // Set by 'T_Damage' for gib velocity.
entity      shot_head;      // Weapons code:  head target of a linked list.
                            //  Used by railgun and explosive shotgun.

// Model indecies
float       mindex_inviso;  // Invisible (null sprite, originally eyes.mdl)
float       mindex_player;  // Player (standard)
float       mindex_dragon;  // Player in dragon form (shambler-size)
float       mindex_hammer;  // Player holding Mjolnir.
float       mindex_hamout;  // Unarmed player waiting for Mjolnir's return.
float       mindex_saw;     // Player with chainsaw.

// Savescum detection.
float       reload_count;   // Speaks for itself.
string      reloaded;       // Used to detect a game reload.

// Alignment globals used in 'align.qc'.
// Note:  Global string fields cannot be defined as constants,
//  so they must be set elsewhere, such as in worldspawn.
entity      blacky;         // Current evil entity to be checked.
entity      whitey;         // Ditto, except for the good guys.
string      GOOD;       // PCs and friends.
string      EVIL;       // Normal bad guys.

// DMSP
entity      fight_me;   // Used by dmsp spawned monsters to find a target.
entity      lastmspawn;
entity      dmsp_ent;       // 8/14/10:  Next func_spawn to copy from.
float       dmsp;
float       lasttime;
//float       nspawned;
float       totalmonsterspawn;
float       boss_count;     // Special boss spawns in the game.

// blood.qc
float       bloodbank;      // Non-red blood types known to be precached.

// triggers.qc
float       randomspots;    // Zerstorer feature.


//===========================/  END OF FILE  /===========================//
