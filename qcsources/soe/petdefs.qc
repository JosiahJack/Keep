//==========================================================================
//  pet.h -- by Patrick Martin                  Last updated:  5-5-2001
//--------------------------------------------------------------------------
//  This file contains new constants, fields, and function prototypes
//  used in my dragon familiar mod.  This is an extension of the code
//  found in the ryu* files.
//==========================================================================

//-----------------//
//  NEW CONSTANTS  //
//-----------------//
// The following are pet flags carried by its master.
float   PET_SKIN        =     3;  // Skin/type of 1st dragon.  (Bits: 1+2)
float   PET_LEVEL1      =     4;  // Dragon is at level 1.
float   PET_LEVEL2      =     8;  // Dragon is at level 2.
float   PET_LEVELMAX    =     8;  // Max level allowed.  Must be <= ALIVE.
float   PET_ALIVE       =    12;  // Set if player has a dragon.  (Bits: 4+8)
float   PET_READY       =    16;  // Set when dragon successfully appears.
float   PET_STAY        =    32;  // Dragon will stay or move.
float   PET_PATROL      =    64;  // OBSOLETE! -- Dragon flys back and forth.
float   PET_PACIFIST    =   128;  // Dragon will attack or ignore targets.
float   PET_FORCED      =   256;  // Dragon is in force attack mode.
float   PET_SHIVA       =   512;  // Cheat!  Dragon becomes immortal.
float   PET_CONTROL     =  1024;  // Player is using dragon as weapon.
float   PET_CMD1        =  2048;  // Attack command bit #1.
float   PET_CMD2        =  4096;  // Attack command bit #2.
float   PET_CMDALL      =  6144;  // All attack command bits.
//float   PET_ALL         =  8191;  // All petflag bits used (8192 - 1).

// Attack commands
float   ATK_MISSILE     = 0;    // Uses missile attack.
float   ATK_TARGET      = 1;    // Fight target closest to center of FOV.
float   ATK_FIGHT       = 2;    // Toggle Attack/Pacifist.
float   ATK_STAY        = 3;    // Toggle Stay/Follow.

// Max minor familiars allowed on level.  Does NOT include Draco.
float   MAX_FAMILIARS   = 9;

// Dragon familiar sight.  Anything within this distance is seen.
float   SIGHT_RADIUS    = 600;

// Health cost for teleporting.
float   COST_PET_TELEPORT   = 20;   // Used to be 50.

// Default altitude level.
float   OFFSET_LEVEL    = 15;
vector  OFFSET_TELEPORT = '0 0 15';

// Reach for picking up and eating meat.
float   REACH_EAT   = 60;

// Dragon item spawnflags.
float   DRACO_BIG       = 1;
float   DRACO_CYCLE     = 2;
float   DRACO_RESPAWN   = 4;

// Time in sec the dragon item changes its type.
float   CYCLE_TIME  = 2;


//--------------------//
//  NEW EDICT FIELDS  //
//--------------------//
.entity draco;          // Pointer to player's 1st dragon or world if none.
.entity lastwarp;       // Link to most recent teleporter player used.
.entity node;           // Temporary goal point used to follow player.
.float  inway;          // Used to check if dragon is blocking master.
.float  petflags;       // This holds information for a player's Draco.
.float  petofs;         // Ideal height difference between player and pet.
.float  pettouch;       // Used to check if player collides with his pet.

//--------------------------------------------------------/ NOTE /------//
//  See 'ryu.h' for existing Quake edict fields used by the dragons.    //
//----------------------------------------------------------------------//


//-------------------//
//  NEW GLOBAL VARS  //
//-------------------//
float   ryucount;       // Number of minor familiars in the level.


//------------------//
//  NEW PROTOTYPES  //
//------------------//

//
//  petmove.qc
//  Collision detection and movement code for pet.
//
float(float offset, float zgoal) PM_SeekLevel;
float() PM_ChangeOfs;
float(entity pet) PM_PetOutOfSight;

float(entity pet) PM_PetHiding;
float(entity pet) PM_PetInstantCalm;
float(entity pet, vector spot) PM_PetSpotLineBlocked;
float(entity pet, vector spot) PM_PetSpotBlocked;
float(entity pet, vector spot) PM_GoodPetSpot;
vector(entity pet) PM_PetSpot4;
vector(entity pet) PM_PetSpot5;
float(entity pet, float near) PM_PetComeHere;

float() PM_PetAvoidCube;
float() PM_DelayPetReturn;
void() PM_PetReappear;
void(entity pet, float standby) PM_PetDisappear;
float() PM_CheckPetBlock;
void() PM_PetTouch;

float() PM_PetGoneInWall;
void(entity ent) PM_PetAntiTrap;

float(entity ent) PM_IsGrenade;
entity() PM_PetFindBombs;
float(float dist) PM_PetDetectBombs;


//
//  petnode.qc
//  Sets up path that allows pet to follow master... or to eat food.
//
float() PM_PetAutoTeleport;
void(float shift, float offset, float zgoal) PM_PetWander;

float(float shift) PM_PetMoveToGoal;
float(float dist) PM_PetGoalSpeed;

void(entity ent) PM_RemoveNode;
void(vector spot) PM_NewNode;

vector(entity plist) PM_LastWaypoint;
void(entity ent, float backtrack) PM_UpdateNode;
void(entity ent) PM_PetUseTeleport;
void() PM_HitTeleport;
float() PM_BuildPath;
void() PM_TrailNode;
float() PM_PetInNode;
float(vector org) PM_NodeInvisible;
void() PM_GotoNode;

void() PM_CheckSecondTriangle;
void() PM_CheckTriangle;

void() PM_TrackMaster;
void() PM_LookForMaster;
float() PM_GotoMaster;

void(entity food) PM_PetEatFood;
void(entity food) PM_GotoPetFood;
float() PM_PetHungry;
float(entity food, float dist) PM_IsGoodFood;


//
//  petai.qc
//  Dictates pet behavior.
//
float(entity pet) PM_PetGoneBad;
float(entity victim, entity attacker) PM_IsPetAlly;
float(entity victim, entity attacker) PM_PetAllyInLine;
float(entity victim, entity attacker) PM_PetAllyTooClose;
float(entity victim, entity attacker, float cone) PM_PetAllyInCone;
float() PM_PetAllyInWay;

float() pet_level;
float() PM_PetCheckAttack;

float(entity client) PM_InCutscene;
float(entity ent) PM_PetEnemyNasty;
float(entity ent) PM_IgnorableTarget;
float(entity ent) PM_NoThreat;
float(entity ent, entity pet) PM_ValidTarget;
float(entity ent) PM_PetSeeTarget;
entity(entity ignore, float all) PM_PetDetectTarget;
float(entity pet) PM_PetCanFight;
float(float all) PM_PetFindTarget;
void(entity targ) PM_PetFoundTarget;

float(entity pet) PM_ShowAngryMessage;
void(entity pet, entity cube) PM_PetCubeReact;
void(entity pet, entity attacker) PM_PetPainReact;

void() PM_CheckPetPower;
void() pet_status;
void() pet_rotate;
void() pet_melee;
void() pet_missile;
void() pet_panic;
void() pet_stand;
void() pet_patrol;
void(entity food, entity shot, entity clip) pet_follow;
void(entity food, entity shot, entity clip) pet_walkgo;
void() pet_walkfind1;
void() pet_walkfind2;
void() pet_walk;
float() PM_FindTargetOfOp;
float() PM_PetDisengage;
float() PM_PetNotFocused;
void() pet_run;


//
//  petdeath.qc
//  Removes slain dragon familiars.
//
void(entity client) PM_ClearDracoFlags;
void(entity pet) PM_PetDisintegrate;
void(entity pet) PM_PetFallDead;
void(entity pet) PM_PetSeverLink;
void(entity pet) PM_DestroyPet;
void(entity pet, float explode) PM_InstantKillPet;
void(entity client, float explode) PM_KillDraco;
void(entity client, float explode) PM_KillAllMinors;
void(entity client, float explode) PM_KillAllPets;


//--------------------------------------------------------/ NOTE /------//
//  'pet.qc' has too many functions to define here.  It must            //
//  be placed after 'petdeath.qc' and before 'petitem.qc'.              //
//----------------------------------------------------------------------//


//
//  petitem.qc
//  Properties of dragon powerup.
//
void(vector org) PM_PetGo;
void() PM_CreatePet;
float(float type) PM_CheckPetType;
void(entity client, entity pet, float type) PM_SetPetSkin;
float(entity client) PM_MaxPets;
float(entity client, float prime, float type) PM_SpawnPet;
void(entity client, float type) PM_RechargeDraco;
void(entity client, float power) PM_LevelUpDraco;
void(entity client, float type, float power) PM_PowerupDraco;

void(entity pet) PM_PowWarpGo;
void(entity client) PM_PowWarpAll;
float(entity pet) PM_PowWarpCheck;

void() PM_PrecacheDraco;
void() draco_change;
void() draco_regen;
void() draco_touch;
void() PM_PlaceDraco;
void() PM_StartDraco;
void() draco_spawn;
void() draco_start;
void() draco_define;
void() item_dragon;

float(entity client) PM_HasPermanentDragon;
float(entity pet) PM_TruePetLevel;
float(entity pet) PM_ImmortalDragon;
float(entity client) PM_DelayCarry;
void() PM_RespawnPet;
void() PM_CarryPetDragon;

void(entity pet) PM_PetExit;
void() PM_ExitAllPets;
void() PM_AutoPromote;

void(entity client) PM_PetQuad;
void(entity client) PM_PetPent;


//
//  petimp.qc
//  Impulse commands for pet.
//
void(entity client) PM_ShowPetName;
float(entity client) PM_GetPetHealth;
float(float select) PM_SelectPet;

float(entity pet) PM_NoPetTalk;
void(entity pet, string text) PM_DracoTalk;
float(float order) PM_PetReady;
void(entity pet) PM_PetStatus;

float(entity pet) PM_PetNeedWater;
void(entity pet) PM_PetCmdStay;
void(entity pet) PM_PetCmdMove;
float() PM_AttackMove;

float(entity pet) PM_PetCeaseFire;
void(entity pet) PM_PetCmdFight;
float() PM_AttackCalm;

void(entity targ) PM_TargetName;
float(entity targ) PM_IsBoss;
float(entity targ) PM_CanBeFought;
float(entity targ, entity pet) PM_TargetIsEnemy;
float(entity targ, entity pet) PM_AttackPetTarget;
entity(entity pet) PM_PetSearchAll;
entity(entity pet) PM_AimSearch;
void(entity pet) PM_AttackThing;
float() PM_AttackTarget;

float(entity pet) PM_PetNoShot;
float(entity pet) PM_PetAttacking;
float(entity pet) PM_PetClearShot;
float(entity pet) PM_ForceShoot;
float() PM_AttackShoot;

float(entity pet) PM_PetCmdWarp;

void(float add) PM_ChangeOption;

void() PM_PetCmdSpawn;

void(entity pet) PM_PetCmdSkinChange;

void(entity pet) PM_PetCmdShiva;

float(entity pet) PM_PetTurn;
void() PM_TurnAllFamiliars;

float() PM_PetCountSelf;
float() PM_PetCountAll;

void() PM_DragonImpulse;

void(entity client, float nofire) PM_StopRapidFire;
float(entity client) PM_UseRapidFire;

float() PM_AttackOption;
float() PM_CheckPetAttack;


//
//  weapons.qc
//
void() W_SetCurrentAmmo;
float() W_BestWeapon;


//
//  client.qc
//
float() PM_Intermission;


//
//  triggers.qc
//
void(vector org) spawn_tfog;


//===========================/  END OF FILE  /===========================//
