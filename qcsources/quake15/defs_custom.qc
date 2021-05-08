/* Level pack definitons
   Copyright (c)1996 Hipnotic Interactive, Inc.
   All rights reserved.
   Do not distribute.
*/

//float IT_LASER_CANNON = 8388608999;
//float IT_PROXIMITY_GUN = 16;

//Viewmodel emitter floats
float TYPE_SMOKE = 0;
float TYPE_STANDARD = 1;

void(float num, float type, .__variant fld) clientstat = #232;
void(float num, float type, string name) globalstat = #233;

#define EV_STRING 1  //limited to 15 chars using 4 consecutive stats in dp (the additional stats should not be assigned), limited to 1024 chars in fte using a single stat within a different stat space.
#define EV_FLOAT 2  //truncated in dp, full precision in fte.
#define EV_VECTOR 3 //server might support 3 consecutive floats, but the client has no builtin to return 3 consecutive ones.
#define EV_INTEGER 8  //alternatively thought of as 'identity'

const float STAT_SHELLS		= 6;
const float STAT_NAILS		= 7;
const float STAT_ROCKETS	= 8;
const float STAT_CELLS		= 9;



.string		stepc1, stepc2, stepc3, stepc4, stepc5; // Custom feet sounds
float CT_MONFREDDIE = 383;		// Slow moving mechanical ogre mutant


float	STATE_TOP		= 0;
float	STATE_BOTTOM	= 1;
float	STATE_UP		= 2;
float	STATE_DOWN		= 3;
float	STATE_DISABLED	= 4;
float	STATE_ENABLED	= 5;

float CT_ESTATE = 80;			// Entity state modifier
.float		wakeuptrigger;		// Trigger flag to use special wakeup animation

float CT_TRIGMONBREAK = 990;	// Trigger monster/breakable together


.float      spawnsilent;
.float      spawnmulti;
float 	    MIN_ANGLE_DELTA = 10;
float 	    AS_DODGING     = 5;

.float		touchedvoid;		// true/false flag if touched void bmodel

float LARGE_TIMER = 999999;		// Don't run out of time!
float		ext_dpsurf;			// Extra DP query surface information

//weapon
void() BecomeExplosion;

// Entity state system
.float		estate_trigger;		// Entity state to be applied to target
.float		estate;				// Entity state (off,on and disable)
.void()		estate_on;			// Entity state ON  function
.void()		estate_off;			// Entity state OFF function
.void()		estate_disable;		// Entity state DISABLE function
.void()		estate_use;			// Entity state USE function
.void()		estate_fire;		// Entity state USE++ function
.void()		estate_reset;		// Entity state RESET function

// General features
.float		moditems;			// New items flag for new stuff in the mod
.float		customkey;			// Bit flag for custom keys (func_door)
.float		bsporigin;			// All bmodel origins are 0,0,0 check this first
.float		startspawn2;		// player_start2 unique spawn location number
.entity		activate;			// When something is triggered, this is the culprit!
.entity		bmodel_act;			// Trigger bmodel generic touch/kill/use functions
.float		bboxtype;			// Different types of bounding box setups
.vector		bbmins;				// Saved bounding box size (minimum)
.vector		bbmaxs;				// Saved bounding box size (maximum)
.vector		idmins;				// Original ID bounding box (min)
.vector		idmaxs;				// Used for stuck issues in original id maps
.string		message2;			// Additional messages for all entities
.void()		touch2;				// Used by items for final touch function
.float		classtype;			// Class type - used for quick reference
.float		classgroup;			// Class group - used for quick reference
.float		classmove;			// 1=Walk, 2=Fly, 4=Swim
.float		classproj;			// Projectile used by entity class
.float		projeffect;			// Special effects and states active
.float		gibhealth;			// The negative health value for gibbing
.float		gibbed;				// true/false flag on body state
.float		touchedvoid;		// true/false flag if touched void bmodel
.string		headmdl;			// Head model for gib routine
.float		bleedcolour;		// Alternative colour for 'bleeding' objects
.float		locksounds;			// Locked sound for doors etc
.float		skin_override;		// Override skin selection based on world theme
.float		frame_override;		// Override frame number (ammo_boxes)
.float		frame_box;			// Set frame number for model animation (-1=random)
.float		noradiusdmg;		// Block all T_RadiusDamage, stops grenade spam
.float		onladder;			// Update state from ladder entity to client
.entity		entladder;			// Ladder entity for reference (time, sounds etc)
.float		timeladder;			// Amount of time before playing climb sound
.entity		attachment;			// 1st Entity attachment (additional model)
.entity		attachment2;		// 2nd entity attachment (additional model)
.entity		attachment3;		// 3rd entity attachment (additional model)
.entity		sound_emitter;		// Used by various entities for add sound
.float		entno_unique;		// Unique number for linking entities
.string		str_unique;			// Unique string name for testing
.string		ckeyname1, ckeyname2, ckeyname3, ckeyname4;	// Custom key netnames


float ENT_STARTOFF = 64;	// Global spawnflags setting
float ESTATE_BLOCK = 6;		// Blocked OFF+DISABLE
float ESTATE_LOWER = 7;		// ON+OFF+DISABLE
float ESTATE_ON = 1;		// Switch ON
float ESTATE_OFF = 2;		// Switch OFF
float ESTATE_DISABLE = 4;	// Disabled (blocks toggle)
float ESTATE_RESET = 8;		// Reset parameters

float CT_FUNCBREAK = 840;		// Func breakable (parent)
float CT_FUNCBREAKMDL = 841;	// Func breakable (model)
float CT_FUNCBREAKSPN = 842;	// Func breakable (spawner)
float CT_FUNCBREAKOBJ = 845;	// Func breakable (rubble))
float CT_FUNCBREAKWALL = 850;	// Bmodel to activate after breakage

// Breakable system
.float		brksound;			// Initial sound type
.float		brkimpsound;		// Impact sound type
.float		brkimpqty;			// Total impact sounds setup
.float		brkobjects;			// Breakable sub object type
.string		brkobj1;			// Breakable object 1 (bsp/mdl)
.string		brkobj2;			// Breakable object 2 (bsp/mdl)
.string		brkobj3;			// Breakable object 3 (bsp/mdl)
.string		brkobj4;			// Breakable object 4 (bsp/mdl)
.float		brkobjqty;			// Total breakable sub objects setup
.vector		brkvelbase;			// Base amount for velocity of broken parts
.vector		brkveladd;			// Random additions for velocity of broken parts
.float		brkavel;			// Amount of breaking object angle velocity
.float		brkfade;			// Fade time before rumble fades away
.vector		brkvol;				// Spawning volume for breakable point entity
.float		brkgravity;			// Change the gravity for rumble, useful for underwater
.float		brkbobdist;			// Bobbing distance to move downwards
.float		brkbobspeed;		// Bobbing speed of movement between two points
.float		brktrigmissile;		// Trigger breakable if hit by - rocket/grenade/shalball
.float		brktrigjump;		// Trigger breakable if hit by jumping monster attack

float CG_TEMPENT = 420;			// All temporary types (gibs, smoke, sparks)
float CG_BREAKABLE = 430;		// All breakable types

float DAMAGEALL = 4;

//explosion defs
void(float sprite_type, vector org, string expl_sound) SpawnExplosion;
float EXPLODE_SMALL = 1;
float EXPLODE_MED = 2;
float EXPLODE_BIG = 3;
float EXPLODE_SMALLP = 5;
float EXPLODE_BIGP = 7;
float EXPLODE_ELEC = 8;
float EXPLODE_PUFF = 10;

float	ATTN_BREAK  = 2;

string SOUND_REXP3 = "weapons/r_exp3b.wav";

string SOUND_EMPTY = "misc/null.wav";			// No sound
string MODEL_EMPTY = "progs/misc_empty.mdl";	// Empty Model (1 point)


//projectiles
float CT_PROJ_GL = 450;			// Grenade projectile

float DAMAGE_MONROCKET = 40;		// Toned down rocket damage

float 	developer;
float CT_DEVMARKER = 25;		// Developer model marker
string MODEL_BROKEN = "progs/misc_broken.mdl";	// Model error
float		engine;				// Type of engine active 0=Fitz, 1=DP, 2=FTE
float ENG_DPEXT = 2;			// Engine with Darkplaces extensions

float CT_TRIGEXPLODE = 945;		// Trigger sprite explosion
.float		exactskin;			// 1-x exact skin number to choose

nosave float configflag;		// Temp cvar used to hold serverflags until live

float SVR_ITEMROTATE = 512;		// Always randomly rotate ammo items
float		ext_dppart;			// Extra DP particle system

//AD particles, should be in part_manage

string DPP_TEPLASMA = "TE_PLASMA";		// New Plasma particle explosion
string DPP_TELRGPLASMA = "TE_LRGPLASMA";// New Plasma larger explosion

//AD Traps

float NOARMOR = 2;
float DAMAGE_MONFLAME = 20;	

float STATE_SETUP = -1;		// Setup state (on/off functions)
float STATE_ON	= 1;		// Stupid idea to have on states as 0
float STATE_OFF	= 2;		// Impossible to test for 0 as 'not setup' is 0


float CT_TEMPGIB = 50;			// Temporary entity (gib)
float CT_TEMPSPARK = 52;		// Temporary entity (spark)
float CT_TEMPSTREAM = 54;		// Temporary entity (stream)

.float		waitmin, waitmin2; /*, waitmax*/

float CT_GASSHOOTER = 658;		// Trap GAS shooter

float CT_TRIGSECRET = 950;		// Secret, volume
float CT_TRIGONCE = 900;		// Once, volume


//Ladder

float CT_TRIGLADDER = 955;		// Ladder, volume
float TRIG_MONSTERS = 32;		// Cane be touched/triggered by monsters

// Added by functions, no map entity interaction
float TRIG_NODAMAGE = 16384;	// Block trigger damage functionality
float TRIG_ALWAYTOUCH = 32768;	// Always allow touch function to exist

//Particle emitters
float CT_PARTICLE = 40;			// A particle
float CT_PARTICLEEMIT = 41;		// A particle emitter
float CT_PARTICLECONT = 42;		// Particle controller (setup particle banks)
float CT_PARTICLETEMP = 45;		// Particle emitter template
float part_debug;				// Particle debug level (visual details)

entity		client_ent;			// Client entity that started server

.float		attack_speed;		// Skill based adjusted projectile speed

.vector		pos3;		// top and bottom positions

float(entity targ, float flat2d) range_distance;

float SVR_PARTICLES = 1024;		// Turn ON particle system (default OFF)
float MON_VIEWOFS = 24;				// Default view ofset for monsters

//----------------------------------------------------------------------
// Required here because of link to particle emitters
float MISCBOOK_GREEN = 1;		// Green Cover
float MISCBOOK_BLUE = 2;		// Blue Cover
float MISCBOOK_RED = 3;			// Red Cover

float ARMOR_BLUE = 2;			// Display a blue armour

float SPNMARK_YELLOW = 0;	// Error something is broken
float SPNMARK_BLUE = 1;		// Delay spawn monster/item
float SPNMARK_GREEN = 2;	// Delay spawn mosnter with no counter
float SPNMARK_RED = 3;		// Nightmare only spawn
float SPNMARK_PURPLE = 4;	// Coop only spawn
float SPNMARK_WHITE = 5;	// Not used atm

float		ext_dpsnow;			// Extra DP particle snow system
float		ext_dprain;			// Extra DP particle rain system
float TIME_MINTICK = 0.01;		// Smallest amount of time to tick functions
.string		targetp2;			// Secondary target field (additional fires)

float CT_MISCSPARK = 672;		// Misc Spark
float CT_MISCSHAKE = 676;		// Misc Shake of screen/player
float CT_MISCDRIP = 680;		// Misc Drip (water)
float CT_BUBBLE = 682;			// Bubbles
float CT_MISCMODEL = 690;		// Misc Model
float CT_MISCSMOKE = 692;		// Misc Smoke


float CG_MISCENT = 410;			// All misc entity types

float MISC_SMOKENODPMDL = 2;	// Do not draw smoke model
float MISC_SMOKENODPFX = 4;		// Do not produce any DP smoke effects

float MISC_SPARKBLUE = 2;		// misc_spark produces Blue sparks
float MISC_SPARKPALE = 4;		// misc_spark produces Pale Yellow sparks
float MISC_SPARKRED = 8;		// misc_spark produces Red sparks
float MISC_COLLISION = 2;		// misc_model has collision enabled
float MISC_SHAKEVIEWONLY = 2;	// No velocity movement

float MISC_DRIPSILENT = 2;		// misc_drip has no sound on splash
float MISC_RAIN = 4;		// blood red drips
float MISC_DRIPBLOOD = 16;		// blood red drips
float MISC_DRIPSLIME = 32;		// slime green drips

.string		bodyonflr;			// String used for find function
.string		bodyonflrtrig;		// Trigger to fire when body is axed!

string MON_ONFLR = "TRUE";			// Search string for bodies on the floor
.float		blockudeath;		// ID udeath.wav sounds human, block it for non-humanoids

//Boss

.float		bosswave;			// Current wave of the boss (backwards)
.float		bosswavetotal;		// Total amount of boss waves
.float		bosswaveqty;		// Total HP for each boss wave
.float		bosswavetrig;		// Current HP trigger for wave

float		map_gravity;		// Current map gravity setting

string SWATER_DRIP = "progs/s_dripblue.spr";		// From RRP/RMQ
string SWATER_SPLASH = "progs/s_dripsplblue.spr";	// From RRP/RMQ
string SBLOOD_DRIP = "progs/s_dripred.spr";			// Re-painted
string SBLOOD_SPLASH = "progs/s_dripsplred.spr";
string SSLIME_DRIP = "progs/s_dripgreen.spr";		// Re-painted
string SSLIME_SPLASH = "progs/s_dripsplgreen.spr";

//sound player

float CT_SOUNDEMITTER = 22;		// Sound emitter
float	ATTN_QUIET	= 3.99;
string SOUND_TALK = "misc/talk.wav";

float		liquid_alpha;		// Stores water alpha, used for monster sight checks
float(entity targ, vector s_offset, vector t_offset, float nomonsters) visxray;	

//Monsters test

float CT_MONDFURY = 210;		// HD Knight (Fury)
float MON_MOVEWALK = 1;				// Walking Monster


.float		pain_flinch;		// Random chance to ignore this much damage
.float		pain_longanim;		// Force monster into long pain animations
.float		pain_finstate;		// Store the current pain finished state
.float		pain_check;			// Pain condition results
.float		pain_timeout;		// Time block to pain function
.float		pain_ignore;		// Ignore pain when hit by other monsters
.string		pain_sound;			// Pain sound wav file
.string		pain_sound2;		// Alternative Pain sound wav file
.string		death_sound;		// Death sound wav file
.float		death_dmg;			// Used by tarbaby for explosive damage on death

.float		idlebusy;			// Busy with an alternative idle animation
.float		idlereverse;		// Reverse direction for idle animation
.float		idletimer;			// Idle sound timer (next time to check)
.float		idlemoreoften;		// Chance of more idle sound (def=random)
.string		idle_sound;			// Idle sound wav file
.string		idle_sound2;		// Alternative Idle sound wav file
.string		idle_soundcom;		// Combat Idle sound wav file
.string		idle_soundcom2;		// Alternative Combat Idle sound wav file
.float		sight_timeout;		// Time block for sight sound
.string		sight_sound;		// Sight sound wav file

.float		enemydist;			// Distance the enemy is from the monster
.entity		lostenemy;			// Lost soul enemy before losing sight
.float		losttimer;			// Lost soul idle timer after losing sight
.float		lostsearch;			// Lost soul searching for previous enemy

.string		angrytarget;		// Alternative target to attack upon spawn
.string		deathtarget;		// Alternative target to fire when dying
.string		sighttarget;		// Will always attack this target if sighted
.entity		switchattacker;		// Last entity to attack and cause damage
.float		switchtimer;		// Cooldown before switching targets (infighting)
.float		infightextra;		// Damage multiplier for infighting damage
.float		noinfighting;		// Will ignore/start any infighting
.float		nomonstercount;		// excluded from map monster count
.entity		jumptouch;			// Last entity a jumping monster touched

// Generic options
float MON_AMBUSH = 1;				// Ambush (will only wakeup if see the player)
float MON_SPAWN_NOSIGHT = 8;		// No wakeup sight sound
float MON_SPAWN_NOIDLE = 16;		// no idle sounds (cupboard monster)
float MON_SPAWN_NOGFX = 32;			// no spawn effect or sound
float MON_SPAWN_DELAY = 64;			// Trigger spawn DELAY
float MON_SPAWN_ANGRY = 128;		// Trigger spawn ANGRY
float MON_GHOST_ONLY = 4096;		// Design for the ghost knights
float MON_POINT_KNIGHT = 8192;		// Pointy Electricity Knight

float MON_IDLE_SOUND = 0.2;			// random chance of idle sound
float MON_IDLE_ANIMATION = 0.2;		// random chance of idle animation

float CT_ENEMYTARGET = 30;		// Target enemy for flying enemies
float CT_ATTACHMENT = 32;		// Attachment for entities
float CG_MONSTERS = 500;		// Default

.float		plasma_burn;		// Timer to stop constant plasma explosions
.float		weaponstate;		// State of the weapon (up/down etc)
.float		weaponswitch;		// Switch timer for different weapons
.string		weaponglow;			// Special glowing model for magic attacks
.float		bodyphased;			// Used for teleporter monsters
.float		bodystatic;			// Used to prevent teleporting monsters
.float		spawnstatue;		// Start/spawn as a statue (cannot be move)
.float		nospawndamage;		// Will not do any telefrag damage on spawn
.float		wakeuptrigger;		// Trigger flag to use special wakeup animation
.entity		turretactive;		// Set when a monster touches a triggerturret
.float		turrettimer;		// Timer used to prevent constant spamming
.float		turrethealth;		// % HP at which a turret monster is released
.string		turrettarget;		// Target to fire when turret % HP is released

.float		meleeattack;		// Which type of melee attack is happening
.float		meleerange;			// Distance used for checking melee contact
.float		meleetimer;			// Blood and gore sound/effect timer
.string		meleehitsound;		// Sound to play when melee impacts on enemy
.float		meleecontact;		// Flag set if monster has melee contact sound
.vector		meleeoffset;		// Offset for melee contact (spawning blood)

/*float(float attackdist) ai_checkmelee;
float(entity source, entity targ, float ignorenoshoot) ai_foundbreakable;*/

.float		brkmondmg;			// Damage multipler for monster attacks

// Generic melee/jump attack distances
float MONAI_MELEEFRONT = 70;		// Front attacks reach further (original = 60)
float MONAI_MELEESIDE = 60;			// Side attacks less distance
float MONAI_MELEEZAXIS = 48;		// Z axis range for melee attack
float MONAI_CHARGEZAXIS = 20;		// Maximum height for knight charge attack
float MONAI_RANGESUMMON = 128;		// High close to block summoning minion
.float		attack_chance;		// The percentage chance the monster will attack


.void()		th_jump;			// Special jump animation for jumpers!
.void()		th_jumpexit;		// Exit animation to stop flying (stuck)
.void()		th_checkattack;		// Which check attack function to use
.void()		th_slide;			// Mainly used by wizard monster
.void()		th_charge;	

// Fury Knight
float MONAI_JUMPFURYTIME = 2;		// Time before next jump attack
float MONAI_JUMPFURYNEAR = 150;		// FURY jump attack distance
float MONAI_JUMPFURYFAR = 350;

//AD Speeds
float SPEED_DFURYSPIKE = 400;		// Base speed of Fury attack A/B
float SPEED_DFURYSKILL = 225;		// 400=easy, 625=normal, 850=hard, 1075=nm

float SPEED_JIMPROJ = 575;			// Crazy flying jim robot laz0r/rockets!?
float SPEED_JIMPROJSKILL = 75;		// 575=easy, 650=normal, 725=hard, nm=800


//Projectiles

float CG_PROJROCKETS = 230;
float CT_PROJ_FURY1 = 480;		// Fury Knight spike ball +rocket trail


float CT_PLAYER = 7;			// Player (007)

float SVR_AUTOAIM = 65536;		// Turn ON Player Auto Aim


vector DAMAGE_RLFURY = '20 0 20';		// Fury rockets - Equal Direct/Radius


float LIFE_ROCKET = 5;				// Disappear in a puff of smoke!
.float movespeed;		// Movement speed (linked to skill)


string MODEL_PROJ_FURY1 = "progs/proj_fury1.mdl";
string MODEL_PROJ_FURY2 = "progs/proj_fury2.mdl";
float CT_PROJ_FURY2 = 429;		// Fury Spit with grenade trail

string GIB_SOUND_METALA = "gibs/gibmetala.wav";
string GIB_SOUND_METALB = "gibs/gibmetalb.wav";

.vector		attack_offset;		// Vector where AI fires projectiles from
//float(entity targ) visblocked;/

.float		savedeffects;		// Saved effects to apply after spawn

void() item_artifact_timerune;
void() weapon_nailgun;
void() weapon_proximity_gun;
void() weapon_laser_gun;
void() weapon_lightning;

void TimeRuneCheat() =
{
	entity dropitem;
	dropitem = spawn();
	dropitem.origin = self.origin;
	dropitem.dmg = 1;
	dropitem.health = 1;
	dropitem.think = item_artifact_timerune;
	dropitem.nextthink = time + 0.1;
};

void saw_spawn() =
{
	entity dropitem;
	dropitem = spawn();
	dropitem.origin = self.origin;
	dropitem.dmg = 1;
	dropitem.health = 1;
	dropitem.think = weapon_nailgun;
	dropitem.nextthink = time + 0.1;
};

void hiplas_spawn() =
{
	entity dropitem;
	dropitem = spawn();
	dropitem.origin = self.origin;
	dropitem.dmg = 1;
	dropitem.health = 1;
	dropitem.think = weapon_lightning;
	dropitem.nextthink = time + 0.1;
};

void prox_spawn() =
{
	entity dropitem;
	dropitem = spawn();
	dropitem.origin = self.origin;
	dropitem.dmg = 1;
	dropitem.health = 5;
	dropitem.think = weapon_proximity_gun;
	dropitem.nextthink = time + 0.1;
};

.float spindown;
.float spintimer;

.float weapontimer;

.float musicstart;
float mapstart; //check if map has started

var float autocvar_deathmatch_music = 1;
var float autocvar_effects_sparkballs = 1;
var float autocvar_effects_classic_explosion = 1;
var float autocvar_effects_explosion_shake = 0
var float autocvar_z_coopconfig = 0;
var float autocvar_teleport_everything = 0;
var float autocvar_teleport_everything_dm = 0;
var float autocvar_slowmo_pitch = 1;

.string vwep; //model of selected weapon in 3rd person

.float grenade_ammo; //Offhand proximity grenades
.float throwing; //Offhand throw

//Hipnotic fields

// laser cannon
.vector     old_velocity;

//prox launcher
.entity     spawnmaster;

.entity     lastvictim;

.float wetsuit_finished;
.float wetsuit_time;

float (vector from, vector to) Dot =
{
	return from_x * to_x + from_y * to_y + from_z * to_z;
};

float ssgpower;
.float PLR_SNDSPD;
.string partname;

.float 		attack_timer;
.vector		attack_track;		// Iternative tracking for range attacks
.float		attack_chance;	
.float		has_fired; 		//check if monster has fired

//var float autocvar_coop_revive_sys = 1; //custom respawn system	
var float autocvar_enforcer_defender = 1; //Add defender-type enemy from Quoth/AD with up close SSG and SoA laser
var float autocvar_enforcer_defender_prox = 1; //give defender a GL that launches prox mines, occasionally used

var float autocvar_soldier_nailgrunt = 1; //Turn the glowing eyes grunt skin into a nailgun soldier

var float autocvar_shalrath_mother = 1;	//gives a small chance for the vore to be able to spawn vorelings

var float autocvar_bullet_projectiles = 0; //turn on projectile-based bullet weapons instead of hitscan

float MON_JIM_ROCKET = 4;

float storegravity;
//float mathlib_accuracy; //accuracy of sqrt & pow

.entity     next_ent;
.float	    gibtimer;

float SNDSPD; //global sound speed modifier

.float gravity; //from quake expansions


//coop lives
.float lives; //player property, how many lives do you have left

float lives_global; // amount of players that still have lives left
float LIFE_BONUS; //give extra life on powerup (megahealth) pickup

var float autocvar_coop_life_pool = 0;//turn on life pool for coop
var float autocvar_coop_lives = 3; //amount of lives customizable by host
var float autocvar_coop_revive = 1;//respawn where you died in coop

var float autocvar_slowmo_powerup = 0;//console command to replace artifact with slowmo rune

.float bulletspeed;	//bullet speed factor for bullet time
float IN_SLOWMO;	//server flag for slowmo powerup

float PLR_CNT; //how many clients are connected

.float hasSuit;//check for biosuit playermodel

.float shocked;

float   ENT_PARTICLE_EMITTER   =   4;
float   ENT_CASING   =   5;
float   ENT_SPRITE_EMITTER   =   6;

.float effecttype //type of sprite effect to send

float EFF_SMOKE = 1;
float EFF_DRIP = 2;

.float   enttype;

.float casetype;

float CASING_SHELL = 1;
float CASING_NAIL = 2;
float CASING_ROCKET = 3;

.float  Version;

void pitch_roll_for_slope (vector slope)
{
vector new_angles,new_angles2,old_forward,old_right;
float dot,mod;
local vector oldang;
	makevectors(self.angles);
	oldang = self.angles;
	old_forward=v_forward;
	old_right=v_right;

	if(slope=='0 0 0')
	{
		traceline(self.origin,self.origin-'0 0 300',TRUE,self);
		if(trace_fraction>0.05&&self.movetype==MOVETYPE_STEP)
			self.flags(-)FL_ONGROUND;
		if(trace_fraction==1)
			return;
		slope=trace_plane_normal;
	}
	new_angles=vectoangles(slope);
	new_angles_x=(90-new_angles_x)*-1;//Gets actual slope
	new_angles2='0 0 0';
	new_angles2_y=new_angles_y;

	makevectors(new_angles2);

	mod=v_forward*old_right;
	if(mod<0)
		mod=1;
	else
		mod=-1;

	dot=v_forward*old_forward;
	self.angles_x=dot*new_angles_x;
	if(self.netname == "blood" && (self.angles_x != oldang_x))
		remove(self);
	self.angles_z=(1-fabs(dot))*new_angles_x*mod;
}

.vector fangle, rangle, uangle; //store v_forward and v_right in .fields

.float sticky; //flag for prox nades

.string partspawn;

void() exp_check_collision =
{
	if (pointcontents(self.origin+ '0 0 15') == CONTENT_SOLID)
	{
		setorigin(self, self.origin - '0 0 17');
		self.velocity = '0 0 -40';
	}
	if (pointcontents(self.origin+ '15 0 0') == CONTENT_SOLID)
		setorigin(self, self.origin - '20 0 0');
	if (pointcontents(self.origin+ '0 15 0') == CONTENT_SOLID)
		setorigin(self, self.origin - '0 20 0');
	if (pointcontents(self.origin+ '-15 0 0') == CONTENT_SOLID)
		setorigin(self, self.origin - '-20 0 0');
	if (pointcontents(self.origin+ '0 -15 0') == CONTENT_SOLID)
		setorigin(self, self.origin - '0 -20 0');
	
	if (pointcontents(self.origin) == CONTENT_WATER)
		self.velocity = '0 0 10';
}

var float autocvar_oldprojectiles = 0;

.float hitbox_pos;

float HEAD_SHOT = 1;
float LEG_SHOT = 2;

.float noclip;	//new noclip

var float autocvar_bot_count;

float(entity ent) checkUPS_forward =
{
	makevectors(ent.angles);
	local float DotComp = Dot(v_forward, ent.velocity);
	return DotComp;
}

float(entity ent) checkUPS_right =
{
	makevectors(ent.angles);
	local float DotComp = Dot(v_right, ent.velocity);
	return DotComp;
}

//Checkspeed is a combo of the above to check UPS in all directions
float(entity ent, float speed) checkSpeed =
{
	local float DotCompFwd, DotCompBck, DotCompRight, DotCompLeft;
	makevectors(ent.angles);
	
	DotCompFwd = Dot(v_forward, ent.velocity);
	if (DotCompFwd < speed)
		DotCompFwd = 0;
		
	DotCompBck = Dot(v_forward, ent.velocity);
	if (DotCompBck > -speed)
		DotCompBck = 0;
		
	DotCompLeft = Dot(v_right, ent.velocity);
	if (DotCompLeft > -speed)
		DotCompLeft = 0;
		
	DotCompRight = Dot(v_right, ent.velocity);
	if (DotCompRight < speed)
		DotCompRight = 0;
		
		
	if (!DotCompFwd && !DotCompBck && !DotCompLeft && !DotCompRight)
		return FALSE;
	else
		return TRUE;
}


.float swing;

var float autocvar_bright_skins = 0;
var float autocvar_shotgun_cycle_fix = 1;//tweaks firing rate of shotguns to fix pump animation

var float autocvar_centered_weapons = 1;
var float autocvar_qc_ssg = 1; //QC inspired super shotgun model

var float autocvar_auto_save = 1;

.float dmenu;

float GROUND = 1;
float METAL = 2;
float MEAT = 3;
float VOID = 4;
float ROCK = 5;
float WOOD = 6;

float SAVE_TIMER;


float(string s) returnsurface =
{
	if ((s == "wizwood1_2") || (s == "wizwood1_3") || (s == "wizwood1_4") || (s == "wizwood1_5") || (s == "wizwood1_6") || (s == "wizwood1_7") || (s == "wizwood1_8") || (s == "wood1_1"))
		return GROUND;
	else if (s == "ground1_1" || s == "ground1_2" || s == "ground1_5" || s == "ground1_5" || s == "ground1_5b" || s == "ground1_6"
					|| s == "ground1_6b" || s == "ground1_7" || s == "ground_1" || s == "wgrnd1_6" || s == "wgrnd1_5" || s == "wgrnd1_8"
					|| s == "wgrass1_1" || s == "grave01_1" || s == "grave01_3" || s == "grave03_1" || s == "grave03_2" || s == "grave03_3" 
					|| s == "grave03_3" || s == "grave03_4" || s == "grave03_5" )
		return GROUND;	
	else if (s == "rock1_2" || s == "rock3_2" || s == "rock3_7" || s == "rock3_8" || s == "rock4_1" || s == "rock4_2" || s == "rock5_2" || s == "rock2")
		return ROCK;
	else if (s == "ecop1_6" || s == "plat_top1" || s == "plat_side1" || s == "wmet1_1" || s == "metal2_5" || s == "metal2_6" || s == "metal2_4" || s == "metal1_3" || s == "met5_1" || s == "ecop1_2" || s == "wizmet1_2" || s == "grate01" || s == "plat_top2" || s == "wmet2_1" || s == "{speedbz_grid1" || s == "{grate01" || s == "{ladder5th")
		return METAL;
	else if (s == "meat1_5" || s == "meat1_4" || s == "meat1_2")
		return MEAT;
	else if (s == "black")
		return VOID;
}




