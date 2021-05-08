/*###########################################################
Custents 6.0 by General WarT' (aka. Carl Glave)
This file contains the new variable and constant definitions
used by Custents. For furthur code details see custents.qc.
###########################################################*/

// Constants for ambient_bgm
float BGM_START_ON	= 1;

// Constants for trains
float TRAIN_SMOOTH	= 1;
float TRAIN_BLOCKABLE	= 2;

// Constants for train syncronizer
float SYNCER_START_ON		= 1;
float SYNCER_START_TOGETHER	= 2;
float SYNCER_RETRACTABLE	= 4;
float SYNCER_BLOCKABLE		= 8;
float SYNCER_SYNC_BLOCK		= 16;

// constants for moving lights
float LIGHT_START_OFF	= 1;
float LIGHT_BRIGHT	= 2;
float LIGHT_FLASH		= 3;
float LIGHT_FIELD		= 4;

// constants for light path corners;
float LP_OFF		= 1;
float LP_DIM		= 2;
float LP_BRIGHT		= 4;
float LP_FLASH		= 8;
float LP_FIELD		= 16;
float LP_SET_MODEL	= 32;

// Constants for the healing trigger
float HEAL_START_ON	= 1;
float HEAL_OBEY_MAX	= 2;
float HEAL_PLAYER_ONLY	= 4;
float HEAL_MONSTER_ONLY	= 8;

// These are required by the Hipnotic code
//added update stat message
float SVC_UPDATESTAT = 3;
float SVC_CUTSCENE   = 34;
//added total monster message
float STAT_TOTALMONSTERS = 12;
float STAT_TOTALSECRETS = 11;
// added spawn flags
float SPAWNFLAG_SUPERSPIKE	= 1;
float SPAWNFLAG_LASER = 2;
float SPAWNFLAG_LAVABALL = 4;
float SPAWNFLAG_ROCKET = 8;
float SPAWNFLAG_GRENADE = 16;
float SPAWNFLAG_ARROW = 32;
float SPAWNFLAG_SILENT = 64;
float SPAWNFLAG_PPC = 128;

.float	rotate_type;
.vector	neworigin;
.vector	rotate;
.float	endtime;
.float	rotate_type;
.string	path;
.string	group;
.float gorging;
.string	event;
.float	duration;
.void()	th_turn;
.float	color;
.float	gravity;
.entity     next_ent;
.entity     lastvictim;
.float      huntingcharmer;
.void()     spawnfunction;
.string     spawnclassname;
.float      spawnsolidtype;
.string     spawnmodel;
.void()     spawnthink;
.entity     spawnmaster;
.vector     spawnmins;
.vector     spawnmaxs;
.float      spawnsilent;
.float      spawnmulti;

// variable for healing trigger
.float	heal_timer;

// rogue globals
float Rearthquake_active;
float Rearthquake_intensity;

// function prototypes
void() earthquake_postthink;

/*###########################################################
The stuff below this point is stuff used by the Apocalypse
code. I kept the Apoc code seperated from the plain Custents
code as best as I could for those of you who are selective
code adders. ;)
###########################################################*/

// variables for enhanced triggering
.string target2;		// second target's name
.string target3;		// third target's name
.string target4;		// fourth target's name
.string targetname2;	// second name
.string targetname3;	// third name
.string targetname4;	// fourth name
.string killtarget2;	// second target to kill
string lastnameused;	// the targetname that was last used to trigger somthing

.entity cament;		// entity for external camera
.vector camofs;		// offset for the external camera

//This is the item constant for the beam weapon
float IT_PPC = 128;
// this is the impulse # used to select the PPC weapon
float PPC_IMPULSE = 199; // picked something not likely to be used

// this is the impulse # used to toggle the Apoc cam
float APOCCAM_IMPULSE = 40;

// Constants for movable actor
float ACTOR_STARTON		= 1;
float ACTOR_RUN			= 2;
float ACTOR_ACTPAUSE	= 4;
float ACTOR_MOVEBREAK	= 8;
float ACTOR_DONTFACE	= 16;
float ACTOR_FLYFACE		= 32;
// Constants for actor path entity
float AP_ACT1		= 1;
float AP_ACT2		= 2;
float AP_DIE		= 4;
float AP_WALK		= 8;
float AP_RUN		= 16;
float AP_SETANGLE	= 32;
float AP_NOFACE		= 64;
float AP_SETMODEL	= 128;
float AP_SETVARS	= 256;
// movement states for actor entities
float ACTORMST_NOMOVE	= 128;
float ACTORMST_MOVE		= 256;
float ACTORMST_WAIT		= 512;
// action states for actor entities
float ACTORST_STAND	= 2;
float ACTORST_WALK	= 4;
float ACTORST_RUN	= 8;
float ACTORST_ACT1	= 16;
float ACTORST_ACT2	= 32;
float ACTORST_DIE	= 64;

// global for trigger_impulse
float impulse_triggers;

// used to know when a player is touching a trigger_touch_impulse
.float imp_touch; 

// trigger_interupt constants
float INT_ENTIN			= 1;
float INT_PLAYERONLY	= 2;
float INT_MONSTONLY		= 4;
float INT_SETACTIVATOR	= 8;

.float apocflags; // flags added for Apocalypse stuff
float ARROW_HIT = 1;			// last hit was from an arrow
float VIEW_RCAM = 2;			// using a remote camera view
								// (not necessarily a func_remote_camera though)
float NEXT_RCAM = 4;			// indicated that player wants to go to next camera in a loop
float VIEW_SETVIEWANGLE = 8;	// remote camera sets player's view angle
float FREEZE_MOVEMENT = 16;		// player's movement is frozen
float FREEZE_VIEWANGLE = 32;	// player's view angle is frozen
float FL_FREEZING = 64;			// still be frozen from a freeze gun
float FL_FROZEN = 128;			// frozen from a freeze gun

// remote camera constants
float RCAM_FREEZE	= 1;
float RCAM_ALL		= 2;
float RCAM_TRACKING	= 4;
float RCAM_SMOOTH	= 8;
float RCAM_ALOWIMP	= 16;
float RCAM_MOVING	= 32;
float RCAM_EXITABLE	= 64;
float RCAM_NODMG	= 128;

// sequence trigger constants
float SEQ_FAILRESET	= 1;
float SEQ_MULTIPLE	= 2;

// glass spawnflag constants
float GLASS_SMOOTH		= 1;
float GLASS_BLOCKABLE	= 2;
float GLASS_STARTOFF	= 4;
float GLASS_ONEHIT		= 8;

// turret spawnflag constants
float TUR_STARTOFF	= 1;
float TUR_RETRACT	= 2;
float TUR_OFFRET	= 4;
float TUR_LASERS	= 8;
float TUR_ROCKETS	= 16;
float TUR_PPC		= 32;

.entity rcam;	// the remote camera the player is using
// message protocol defines
float SVC_SETVIEWPORT	= 5;
float SVC_SETVIEWANGLES	= 10;

// bit flags for parm# packing
float BIT_1 = 1;
float BIT_2 = 2;
float BIT_3	= 4;
float BIT_4 = 8;
float BIT_5 = 16;
float BIT_6 = 32;
float BIT_7 = 64;
float BIT_8 = 128;
float BIT_9 = 256;
float BIT_10 = 512;
float BIT_11 = 1024;
float BIT_12 = 2048;
float BIT_13 = 4096;
float BIT_14 = 8192;
float BIT_15 = 16384;
float BIT_16 = 32768;
float BIT_17 = 65536;
float BIT_18 = 131072;
float BIT_19 = 262144;
float BIT_20 = 524288;
float BIT_21 = 1048576;
float BIT_22 = 2097152;
float BIT_23 = 4194304;
float BIT_24 = 8388608;

// servomech stuff
entity checkmech;
float() FindMechTarget;

// prototype for footsteps function
void(string stepsound, float chancea, float vola, float volb) FootFall;

// other Apoc prototypes
entity(string mismodel, vector misorigin, vector misvelocity) launch_missile;
void(entity missile, float basedamage, float randdamage) setdmg_missile;
void(entity missile, float misnextthink, void() misthink,
	void() mistouch, float basedamage, float randdamage) setup_missile;
void(entity missile, vector mistarget, float targeting) target_missile;

void(vector vecin) camanglesmod;
void() rcam_use;
void() rcam_impulse_controls;

float (vector from, vector onto) SUB_Dot;
float(float a, float b) mod;
vector(vector invec, vector refnorm) SUB_ReflectVector;
float(float parmvala, float parmvalb, float parmvalc) SUB_PackParm;
float(float parmin, float valnum) SUB_UnpackParm;
void() TimeMake;

void() Cam_toggle;
void() Cam_position;

void() cservo_apply_controlls;

void(float burstcharge) beam_water_burst;
void() beam_generate;
void() W_FireBeam;
