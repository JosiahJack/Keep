//==========================================================================
//  ryu.h -- by Patrick Martin                  Last updated:  5-5-2001
//--------------------------------------------------------------------------
//  This file contains new constants, fields, and function prototypes
//  used in my dragon patch.  The prototypes are listed in the file
//  order in which the files are compiled.
//==========================================================================

//-----------------//
//  NEW CONSTANTS  //
//-----------------//
// Intelligence levels used by Dragons.  (Used to be in 'combat2.qc'.)
float   IQ_LOW          = 1;    // Least intelligence, easily angered.
float   IQ_NORMAL       = 2;    // Normal Quake monster intelligence.
float   IQ_HIGH         = 3;    // Can dodge fairly well and find water.
float   IQ_GENIUS       = 4;    // Can dodge very well; hard to trick.

// dragon spawnflags
float   SPAWN_AMBUSH    = 1;    // Included for completeness.
float   SPAWN_PACIFIST  = 2;    // Wakes up only when injured or triggered.
float   SPAWN_CRANKED   = 4;    // Has double the normal attack power.
float   SPAWN_ARMORED   = 8;    // Starts with armor equal to health.
float   SPAWN_SKILLED   = 16;   // Regenerates and has the best AI.
// Spawnflag 32 was removed.
float   SPAWN_HIDDEN    = 64;   // Hides until triggered.  sf64 complient.

// dragon speeds
float   DRAGON_MINSPEED = 8;    // Minimum speed.  Used for 'walking'.

// dragon sizes
float   SIZE_LARGE      = 0;    // Large dragon.  40%-sized Qtest dragon.
float   SIZE_SMALL      = 1;    // Small dragon.  16%-sized Qtest dragon.

// dragon bite range
float   REACH_LARGE     = 120;
float   REACH_SMALL     = 80;

// dragon radar -- anything within a certain distance of dragon is found.
float   DETECT_RADIUS   = 300;

// dragon shot speed/bolt range
float   SHOT1_SPEED     = 600;
float   SHOT2_SPEED     = 1000;
float   SHOT3_SPEED     = 1200;
float   SHOT4_SPEED     = 1500;

// dragon attack damage
float   DMG_RYU_BLAST13 = 60;
float   DMG_RYU_BLAST4  = 80;
float   DMG_RYU_ICE     = 10;
vector  DMG_RYU_BITE    = '10 5 1';     // 6-15 damage.
vector  DMG_RYU_FIRE    = '0 10 0.1';   // 10 damage; 10% chance of burn.
vector  DMG_RYU_BOLT    = '0 10 1';     // 10 damage.

float   DODGE_TIME  = 1;    // Time in sec that dragon may strafe randomly.

// dragon hull boundaries
vector  VEC_RYU1_MIN    = '-48 -48 -24';
vector  VEC_RYU1_MAX    = '48 48 48';
vector  VEC_RYU2_MIN    = '-16 -16 -24';
vector  VEC_RYU2_MAX    = '16 16 24';       // FIXME:  z-max could be 32...

// dragon types
float   SKIN_RED    = 0;
float   SKIN_WHITE  = 1;
float   SKIN_BLUE   = 2;
float   SKIN_GOLD   = 3;

//--------------------------------------------------------- NOTE -------//
//  1)  In the unmodified 'ai.qc', spawnflag 2 is an ambush flag for    //
//      any monster because of ID's ugly 'fix' for zombie crucified.    //
//                                                                      //
//  2)  Pacifist overrides ambush.  In other words, a pacifist          //
//      dragon does not need the ambush flag.                           //
//----------------------------------------------------------------------//


//--------------------//
//  NEW EDICT FIELDS  //
//--------------------//
.entity watergoal;      // Entity used to lure burning dragons into water.
.float  dodge_back;     // Tells dragon when to stop reverse movement.
.float  slide_away;     // Tells dragon when to stop mandatory strafing.
.float  slide_rand;     // Tells dragon when to stop random strafing.
.float  stalled;        // Time dragon was stalled trying to close in.
                        //  Also used as count per frame player touched pet.
.vector waterspot;      // Memory on where to find water.

//--------------------------------------------------------/ NOTE /------//
//  The following existing Quake edict fields are used by the dragons   //
//  in different ways:                                                  //
//                                                                      //
//  .float   aflag       - Fear flag.  TRUE = stay away from water.     //
//  .float   count       - Starting number of shots in attack frame.    //
//  .float   currentammo - # of shots (r/w) or attack frames (b) left.  //
//  .float   height      - Size of dragon.                              //
//  .float   speed       - Normal flying speed.                         //
//  .float   state       - Intelligence level.                          //
//  .float   style       - Zerstorer sf64 monsters.                     //
//  .float   wait        - Sets amount of hp/sec regenerated.           //
//  .string  deathtype   - Obituaries... and marking gibs as food.      //
//  .vector  dest        - Zerstorer gibs velocity.  Unused.            //
//  .vector  oldorigin   - Target point memory.  Used for aiming.       //
//  .vector  pos1        - Memory on its old spot; used for backtrack.  //
//  .vector  pos2        - Memory on a waypoint toward a goal.          //
//----------------------------------------------------------------------//


//------------------//
//  NEW PROTOTYPES  //
//------------------//

//--------------------------------------------------------- NOTE -------//
//  The following .qc files do not have prototypes defined here         //
//  because they were designed as modules to be used in a variety       //
//  of patches.                                                         //
//                                                                      //
//  check.qc    --  Checks if entity is in the various contents.        //
//  combat2.qc  --  Contains extra functions and enhancements needed    //
//                   by the modified 'combat.qc'.                       //
//                                                                      //
//  regen.qc    --  Code for regeneration.  Regain health over time.    //
//  fire*.qc    --  Code for fire damage.  Taken from my Napalm mod.    //
//  zap.qc      --  Code for lightning damage.                          //
//----------------------------------------------------------------------//

//
//      ryushot.qc   --  Attacks for all dragons.
//
void(vector offset, float reach, vector damage) PM_DragonBite;

vector() PM_AimForward;
vector() PM_GetShotSpot;
float(entity ent) PM_IsFalling;
vector(vector start, vector end, float sped) PM_LeadShot;
vector(vector start, vector end) PM_RyuRandomSpread;
vector(vector end) PM_InterAim;
void(float is_pet) PM_SetDragonAim;
void(float shots) PM_SetDragonAmmo;

void(entity fire, float radius, vector hit_damage, vector burn_damage,
    float fade, float no_resist, entity ignore) PM_DragonBurnRadius;
float(entity fire) PM_CheckRyuFireDrop;
void() PM_DragonFireTouch;
void() PM_DragonFireStart;
void(vector offset, float sped, vector hit_dmg, float dec) PM_DragonFire;

void(float color, float density, float full) PM_MakeShotTrail;
float(entity ent) PM_IceResistant;
void(float damage) PM_SpawnTouchIce;
void() PM_DragonIceTouch;
void() PM_DragonIceThink;
void() PM_DragonIceStart;
void(vector offset, float sped, float damage, float dec) PM_DragonIce;

void(vector offset, float reach, vector damage) PM_DragonBolt;

void(entity targ) PM_BlastExplode;
void() PM_BlastTouch;
void() PM_BlastThink;
void(vector offset, float damage, float sped, vector hit_damage)
    PM_DragonBlast;


//
//      ryuwater.qc  --  A variety of dragon stuff that involves water.
//
void() PM_NegateWaterFear;
void(float type) PM_SetWaterFear;
float() PM_Hydrophobic;
float(float dist) PM_FindAir;
float(float dist) PM_LeaveWater;
float(float dist) PM_NearLiquid;

float() PM_WaterUnknown;
void(float dist) PM_WaterDive;
void() PM_RestoreWaterPath;
void() PM_WaterDetour;
float(float dist) PM_CheckWaterPath;
float(vector spot) PM_SightWater;
float() PM_LocateWater;
void() PM_WaterMemory;
void(vector spot) PM_NewWaterGoal;
void() PM_SeekWater;
void(entity ent) PM_ClearWaterMemory;
void(entity ent) PM_RemoveWaterGoal;
void(float dist) PM_DragonWaterStatus;


//
//      ryumove.qc   --  Collision detection, evasion, and movement code.
//
void(float reverse, float dist) PM_Eject;
float() PM_AntiClip;
void(float dist) PM_AntiTrap;
float() PM_AntiZombiePin;

float(float offset) PM_AllClear;
float(float dist) ryu_down;
float(float dist) ryu_up;
float() PM_CheckDragonLevel;
void(float dist, entity ent) PM_VerticalSlide;

void(float newyaw, float dist, entity ent) PM_Dodge;
float(float theta) PM_ChangeCourse;
void(float dist, entity ent) PM_FindBestPath;

float(entity ent) PM_KeepAway;
float(entity ent) PM_IsHostile;
entity() PM_FindThreat;
float(float dist) PM_DetectDanger;


//
//      ryuai.qc     --  Dictates dragon behavior.
//
float() dragon_level;
float(float level) PM_DragonChance;
float(entity ent) PM_DragonNoShot;
float() PM_DragonCheckAttack;

float(entity targ) PM_DragonEnemyFound;
float() PM_DragonFindTarget;

float() PM_DoStrafe;
void() PM_StrafeOption;
void(float dist) ryu_circlestrafe;
float() PM_BackOff;
void() ryu_melee;
void() ryu_missile;
void() ryu_panic;
void() ryu_stand;
void() ryu_walk;
float() PM_BlockDragonSight;
float(entity targ) ryu_visible;
void() ryu_run_attack;
float() PM_Disengage;
float() PM_ForgetEnemy;
float() PM_CanAttackTarget;
void() ryu_run;


//
//      ryumisc.qc   --  Contains general dragon stuff.
//
float(entity ent) PM_DragonLowHealth;
float(entity ent) PM_DragonMaxArmor;
float(entity ent, float points) PM_DragonAddArmor;

void() PM_RyuFlySound;

void(entity targ, entity attacker, string mod) PM_DragonSlayer;


//--------------------------------------------------------/ NOTE /------//
//  The following .qc files do not have prototypes defined here         //
//  because they use code defined in other .qc files that are compiled  //
//  late.  (e.g., the bestiary.)  These files should be placed below    //
//  oldone.qc.                                                          //
//                                                                      //
//  ryu.qc      --  Code for model animation and dragon definition.     //
//----------------------------------------------------------------------//


//===========================/  END OF FILE  /===========================//
