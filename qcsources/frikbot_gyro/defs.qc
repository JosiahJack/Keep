/*  Copyright (C) 1996-1997  Id Software, Inc.

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    See file, 'COPYING', for details.
*/

//qb: from urqc
// 2001-10-20 Extension System by Lord Havoc
//            function declaration and variable definition
// 2001-09-25 New BuiltIn Function: etof() by Maddes
//            function declaration and variable definition
// 2001-09-25 New BuiltIn Function: ftoe() by Maddes
//            function declaration and variable definition
// 2001-09-20 QuakeC string manipulation by FrikaC
//            function declaration and variable definition
// 2001-09-20 QuakeC file access by FrikaC
//            function declaration and variable definition
// 2001-09-18 New BuiltIn Function: cvar_create() by LordHavoc/Maddes
//            function declaration and variable definition
// 2001-09-18 New BuiltIn Function: cvar_free() by Maddes
//            function declaration and variable definition
// 2001-09-16 New BuiltIn Function: cmd_find() by Maddes
//            function declaration and variable definition
// 2001-09-16 New BuiltIn Function: cvar_find() by Maddes
//            function declaration and variable definition
// 2001-09-16 New BuiltIn Function: cvar_string() by Maddes
//            function declaration and variable definition
// 2001-09-14 Enhanced BuiltIn Function System (EBFS) by Maddes
//            function declaration and variable definition
// 2001-09-10 FrikBot support by FrikaC
//            removing function declaration (replaced by FrikBot routines)
// 2001-08-31 Shooting/jumping when respawning fix by Patrick Martin
//            defining new deadflag
// 2000-07-16 Option: Sudden death for fraglimit and timelimit by Maddes
//            variable definition
// 2000-07-15 Restructured fraglimit and timelimit by Maddes
//            function declaration
//            removing old timewarning function declaration
// 2000-07-14 Debug function for client view bug by Maddes
//            variable definition
// 2000-05-02 Network versioning system (NVS) by Maddes
//            function declaration
//            and variable definition
// 1999-10-23 Possibility to test simultaneous shooting of players in the same frame by Maddes
//            variable definition and function declaration
// 1999-10-20 Custom gravity for maps by RocketMan/Maddes
//            variable definition
// 1999-10-17 Delayed powerups on map start by Maddes
//            variable definition
// 1999-10-15 Rearranged use of console variables again by Maddes
//            variable definitions
// 1999-08-08 Centerprint with multiple strings by Dirk Gerrits
//            function declaration
// 1999-06-04 Rearranged use of console variables by Maddes
//            variable definitions
// 1999-06-03 Resume function by Jim Steers/Maddes
//            variable definitions and function declaration
// 1999-05-02 Teleporting objects by Lord Sméagol/Maddes
//            variable definition
// 1999-02-20 Functions to locate map bugs by Maddes
//            variable definitions and function declarations
// 1999-02-19 Enhanced debugging support by Maddes
//            variable definition
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes
//            variable definitions
// 1999-02-04 Option: Drop Quad/Ring by Zoid/Maddes
//            variable definition
// 1999-02-03 Option: Map rotation by Maddes
//            variable definitions
// 1999-02-03 Option: Players can not carry weapons/ammo/armor between levels in deathmatch by Maddes
//            variable definition
// 1999-02-02 Enhanced info system by Maddes
//            variable definitions and function declaration
// 1999-02-02 Option: Toggle for previous optional functions by Maddes
//            variable definition
// 1999-02-01 Removing unnecessary use of "TEMP1" for testing player death scenes by Maddes
//            variable definition
// 1998-12-23 Monster attack player on intermission points fix by Maddes
//            variable definition
// 1998-10-04 Hit outside water by a discharge fix by Maddes
//            function declaration
// 1998-09-18 Transparent water detection by Maddes/Anubis
//            variable definition
// 1998-09-15 Two minute warning by Maddes (inspired by an Inside3D tutorial)
//            function declaration
// 1998-08-08 Complete SVC list by Zhenga
// 1998-08-08 Centerprint with multiple strings by Zhenga
//            function declaration
// 1998-07-23 Better performance in handling of powerups by Maddes
//            variable definition
// 1998-07-17 Series of Message Of The Day (MOTD) by Maddes
//            variable definition and function declaration
// 1998-07-03 hurt_touch fix by Robert Field
//            variable definition
// 1998-01-04 event skin support by Maddes
//            variable definition
// 1997-12-30 skin support by Maddes
//            variable definitions and function declarations
// 1997-12-26 auto-aim toggle by Maddes
//            variable definitions
// 1997-12-24 Message on respawn by Maddes
//            variable definition
// 1997-12-24 Message Of The Day (MOTD) by Maddes
//            variable definition and function declaration

#include "directives.qh"	// 2001-04-22 by Maddes

/*
==============================================================================

			SOURCE FOR GLOBALVARS_T C STRUCTURE

==============================================================================
*/

//
// system globals
//
entity		self;
entity		other;
entity		world;
float		time;
float		frametime;

float		force_retouch;		// force all entities to touch triggers
								// next frame.  this is needed because
								// non-moving things don't normally scan
								// for triggers, and when a trigger is
								// created (like a teleport trigger), it
								// needs to catch everything.
								// decremented each frame, so set to 2
								// to guarantee everything is touched
string		mapname;

float		deathmatch;
float		coop;
float		teamplay;

float		serverflags;		// propagated from level to level, used to
								// keep track of completed episodes

float		total_secrets;
float		total_monsters;

float		found_secrets;		// number of secrets found
float		killed_monsters;	// number of monsters killed


// spawnparms are used to encode information about clients across server
// level changes
float		parm1, parm2, parm3, parm4, parm5, parm6, parm7, parm8, parm9, parm10, parm11, parm12, parm13, parm14, parm15, parm16;

//
// global variables set by built in functions
//	
vector		v_forward, v_up, v_right;	// set by makevectors()
	
// set by traceline / tracebox
float		trace_allsolid;
float		trace_startsolid;
float		trace_fraction;
vector		trace_endpos;
vector		trace_plane_normal;
float		trace_plane_dist;
entity		trace_ent;
float		trace_inopen;
float		trace_inwater;

entity		msg_entity;				// destination of single entity writes

//
// required prog functions
//
void() 		main;						// only for testing

void()		StartFrame;

void() 		PlayerPreThink;
void() 		PlayerPostThink;

void()		ClientKill;
void()		ClientConnect;
void() 		PutClientInServer;		// call after setting the parm1... parms
void()		ClientDisconnect;

void()		SetNewParms;			// called when a client first connects to
									// a server. sets parms so they can be
									// saved off for restarts

void()		SetChangeParms;			// call to set parms for self so they can
									// be saved for a level transition


//================================================
void		end_sys_globals;		// flag for structure dumping
//================================================

/*
==============================================================================

			SOURCE FOR ENTVARS_T C STRUCTURE

==============================================================================
*/

//
// system fields (*** = do not set in prog code, maintained by C code)
//
.float		modelindex;		// *** model index in the precached list
.vector		absmin, absmax;	// *** origin + mins / maxs

.float		ltime;			// local time for entity
.float		movetype;
.float		solid;

.vector		origin;			// ***
.vector		oldorigin;		// ***
.vector		velocity;
.vector		angles;
.vector		avelocity;

.vector		punchangle;		// temp angle adjust from damage or recoil

.string		classname;		// spawn function
.string		model;
.float		frame;
.float		skin;
.float		effects;

.vector		mins, maxs;		// bounding box extents reletive to origin
.vector		size;			// maxs - mins

.void()		touch;
.void()		use;
.void()		think;
.void()		blocked;		// for doors or plats, called when can't push other

.float		nextthink;
.entity		groundentity;

// stats
.float		health;
.float		frags;
.float		weapon;			// one of the IT_SHOTGUN, etc flags
.string		weaponmodel;
.float		weaponframe;
.float		currentammo;
.float		ammo_shells, ammo_nails, ammo_rockets, ammo_cells;

.float		items;			// bit flags

.float		takedamage;
.entity		chain;
.float		deadflag;

.vector		view_ofs;			// add to origin to get eye point


.float		button0;		// fire
.float		button1;		// use
.float		button2;		// jump

.float		impulse;		// weapon changes

.float		fixangle;
.vector		v_angle;		// view / targeting angle for players
.float		idealpitch;		// calculated pitch angle for lookup up slopes


.string		netname;

.entity 	enemy;

.float		flags;

.float		colormap;
.float		team;

.float		max_health;		// players maximum health is stored here

.float		teleport_time;	// don't back up

.float		armortype;		// save this fraction of incoming damage
.float		armorvalue;

.float		waterlevel;		// 0 = not in, 1 = feet, 2 = waist, 3 = eyes
.float		watertype;		// a contents value

.float		ideal_yaw;
.float		yaw_speed;

.entity		aiment;

.entity 	goalentity;		// a movetarget or an enemy

.float		spawnflags;

.string		target;
.string		targetname;

// damage is accumulated through a frame. and sent as one single
// message, so the super shotgun doesn't generate huge messages
.float		dmg_take;
.float		dmg_save;
.entity		dmg_inflictor;

.entity		owner;		// who launched a missile
.vector		movedir;	// mostly for doors, but also used for waterjump

.string		message;		// trigger messages

.float		sounds;		// either a cd track number or sound number

.string		noise, noise1, noise2, noise3;	// contains names of wavs to play

//================================================
void		end_sys_fields;			// flag for structure dumping
//================================================

//qbism frame_interval, etc. from Makaqu
.float		alpha;
.float		scale;
.vector		scalev;
.float		glow_size;
.float		frame_interval;
.float 		modelflags; //qbism from DP

//qbism from DP_EXTENSIONS

//DP_ENT_EXTERIORMODELTOCLIENT
//idea: LordHavoc
//darkplaces implementation: LordHavoc
//fields:
.entity exteriormodeltoclient;
//description:
//the entity is visible to all clients with one exception: if the specified client is using first person view (not using chase_active) the entity will not be shown.  Also if tag attachments are supported any entities attached to the player entity will not be drawn in first person.

//DP_SV_DRAWONLYTOCLIENT
//idea: LordHavoc
//darkplaces implementation: LordHavoc
//field definitions:
.entity drawonlytoclient;
//description:
//the entity is only visible to the specified client.

//DP_SV_NODRAWTOCLIENT
//idea: LordHavoc
//darkplaces implementation: LordHavoc
//field definitions:
.entity nodrawtoclient;
//description:
//the entity is not visible to the specified client.


/*
==============================================================================

				VARS NOT REFERENCED BY C CODE

==============================================================================
*/


//
// constants
//

float	FALSE					= 0;
float 	TRUE					= 1;

// edict.flags
float	FL_FLY					= 1;
float	FL_SWIM					= 2;
float	FL_CLIENT				= 8;	// set for all client edicts
float	FL_INWATER				= 16;	// for enter / leave water splash
float	FL_MONSTER				= 32;
float	FL_GODMODE				= 64;	// player cheat
float	FL_NOTARGET				= 128;	// player cheat
float	FL_ITEM					= 256;	// extra wide size for bonus items
float	FL_ONGROUND				= 512;	// standing on something
float	FL_PARTIALGROUND		= 1024;	// not all corners are valid
float	FL_WATERJUMP			= 2048;	// player jumping out of water
float	FL_JUMPRELEASED			= 4096;	// for jump debouncing

// edict.movetype values
float	MOVETYPE_NONE			= 0;	// never moves
//float	MOVETYPE_ANGLENOCLIP	= 1;
//float	MOVETYPE_ANGLECLIP		= 2;
float	MOVETYPE_WALK			= 3;	// players only
float	MOVETYPE_STEP			= 4;	// discrete, not real time unless fall
float	MOVETYPE_FLY			= 5;
float	MOVETYPE_TOSS			= 6;	// gravity
float	MOVETYPE_PUSH			= 7;	// no clip to world, push and crush
float	MOVETYPE_NOCLIP			= 8;
float	MOVETYPE_FLYMISSILE		= 9;	// fly with extra size against monsters
float	MOVETYPE_BOUNCE			= 10;
float	MOVETYPE_BOUNCEMISSILE	= 11;	// bounce with extra size

// edict.solid values
float	SOLID_NOT				= 0;	// no interaction with other objects
float	SOLID_TRIGGER			= 1;	// touch on edge, but not blocking
float	SOLID_BBOX				= 2;	// touch on edge, block
float	SOLID_SLIDEBOX			= 3;	// touch on edge, but not an onground
float	SOLID_BSP				= 4;	// bsp clip, touch on edge, block

// range values
float	RANGE_MELEE				= 0;
float	RANGE_NEAR				= 1;
float	RANGE_MID				= 2;
float	RANGE_FAR				= 3;

// deadflag values

float	DEAD_NO					= 0;
float	DEAD_DYING				= 1;
float	DEAD_DEAD				= 2;
float	DEAD_RESPAWNABLE		= 3;
// 2001-08-31 Shooting/jumping when respawning fix by Patrick Martin  start
float	DEAD_WAITING			= 4;	// New deadflag value.  This is one up from respawnable.
// 2001-08-31 Shooting/jumping when respawning fix by Patrick Martin  end

// takedamage values

float	DAMAGE_NO				= 0;
float	DAMAGE_YES				= 1;
float	DAMAGE_AIM				= 2;

// items
float	IT_AXE					= 4096;
float	IT_SHOTGUN				= 1;
float	IT_SUPER_SHOTGUN		= 2;
float	IT_NAILGUN				= 4;
float	IT_SUPER_NAILGUN		= 8;
float	IT_GRENADE_LAUNCHER		= 16;
float	IT_ROCKET_LAUNCHER		= 32;
float	IT_LIGHTNING			= 64;
float	IT_EXTRA_WEAPON			= 128;

float	IT_SHELLS				= 256;
float	IT_NAILS				= 512;
float	IT_ROCKETS				= 1024;
float	IT_CELLS				= 2048;

float	IT_ARMOR1				= 8192;
float	IT_ARMOR2				= 16384;
float	IT_ARMOR3				= 32768;
float	IT_SUPERHEALTH			= 65536;

float	IT_KEY1					= 131072;
float	IT_KEY2					= 262144;

float	IT_INVISIBILITY			= 524288;
float	IT_INVULNERABILITY		= 1048576;
float	IT_SUIT					= 2097152;
float	IT_QUAD					= 4194304;

// point content values

float	CONTENT_EMPTY			= -1;
float	CONTENT_SOLID			= -2;
float	CONTENT_WATER			= -3;
float	CONTENT_SLIME			= -4;
float	CONTENT_LAVA			= -5;
float	CONTENT_SKY				= -6;

float	STATE_TOP		= 0;
float	STATE_BOTTOM	= 1;
float	STATE_UP		= 2;
float	STATE_DOWN		= 3;

vector	VEC_ORIGIN = '0 0 0';
vector	VEC_HULL_MIN = '-16 -16 -24';
vector	VEC_HULL_MAX = '16 16 32';

vector	VEC_HULL2_MIN = '-32 -32 -24';
vector	VEC_HULL2_MAX = '32 32 64';

// protocol bytes
// 1998-08-08 Complete SVC list by Zhenga  start
float	SVC_BAD			= 0;
float	SVC_NOP			= 1;
float	SVC_DISCONNECT		= 2;
float	SVC_UPDATESTAT		= 3;
float	SVC_VERSION		= 4;
float	SVC_SETVIEW		= 5;
float	SVC_SOUND		= 6;
float	SVC_TIME		= 7;
float	SVC_PRINT		= 8;
float	SVC_STUFFTEXT		= 9;
float	SVC_SETANGLE		= 10;
float	SVC_SERVERINFO		= 11;
float	SVC_LIGHTSTYLE		= 12;
float	SVC_UPDATENAME		= 13;
float	SVC_UPDATEFRAGS		= 14;
float	SVC_CLIENTDATA		= 15;
float	SVC_STOPSOUND		= 16;
float	SVC_UPDATECOLORS	= 17;
float	SVC_PARTICLE		= 18;
float	SVC_DAMAGE		= 19;
float	SVC_SPAWNSTATIC		= 20;
float	SVC_SPAWNBINARY		= 21;
float	SVC_SPAWNBASELINE	= 22;
// 1998-08-08 Complete SVC list by Zhenga  end
float	SVC_TEMPENTITY		= 23;
// 1998-08-08 Complete SVC list by Zhenga  start
float	SVC_SETPAUSE		= 24;
float	SVC_SIGNONNUM		= 25;
float	SVC_CENTERPRINT		= 26;
// 1998-08-08 Complete SVC list by Zhenga  end
float	SVC_KILLEDMONSTER	= 27;
float	SVC_FOUNDSECRET		= 28;
float	SVC_SPAWNSTATICSOUND	= 29;	// 1998-08-08 Complete SVC list by Zhenga
float	SVC_INTERMISSION	= 30;
float	SVC_FINALE			= 31;
float	SVC_CDTRACK			= 32;
float	SVC_SELLSCREEN		= 33;
float	SVC_CUTSCENE		= 34;	// 1998-08-08 Complete SVC list by Zhenga

float	TE_SPIKE		= 0;
float	TE_SUPERSPIKE	= 1;
float	TE_GUNSHOT		= 2;
float	TE_EXPLOSION	= 3;
float	TE_TAREXPLOSION	= 4;
float	TE_LIGHTNING1	= 5;
float	TE_LIGHTNING2	= 6;
float	TE_WIZSPIKE		= 7;
float	TE_KNIGHTSPIKE	= 8;
float	TE_LIGHTNING3	= 9;
float	TE_LAVASPLASH	= 10;
float	TE_TELEPORT		= 11;

// sound channels
// channel 0 never willingly overrides
// other channels (1-7) always override a playing sound on that channel
float	CHAN_AUTO		= 0;
float	CHAN_WEAPON		= 1;
float	CHAN_VOICE		= 2;
float	CHAN_ITEM		= 3;
float	CHAN_BODY		= 4;

float	ATTN_NONE		= 0;
float	ATTN_NORM		= 1;
float	ATTN_IDLE		= 2;
float	ATTN_STATIC		= 3;

// update types

float	UPDATE_GENERAL	= 0;
float	UPDATE_STATIC	= 1;
float	UPDATE_BINARY	= 2;
float	UPDATE_TEMP		= 3;

// entity effects

float	EF_BRIGHTFIELD	= 1;
float	EF_MUZZLEFLASH 	= 2;
float	EF_BRIGHTLIGHT 	= 4;
float	EF_DIMLIGHT 	= 8;


// messages
float	MSG_BROADCAST	= 0;		// unreliable to all
float	MSG_ONE			= 1;		// reliable to one (msg_entity)
float	MSG_ALL			= 2;		// reliable to all
float	MSG_INIT		= 3;		// write to the init string

//================================================

//
// globals
//
float	movedist;
float	gameover;		// set when a rule exits

string	string_null;	// null string, nothing should be held here

entity	newmis;			// launch_spike sets this after spawning it

entity	activator;		// the entity that activated a trigger or brush

entity	damage_attacker;	// set by T_Damage
float	framecount;

float		skill;

//================================================

//
// world fields (FIXME: make globals)
//
.string		wad;
.string 	map;
.float		worldtype;	// 0=medieval 1=metal 2=base

//================================================

.string		killtarget;

//
// quakeed fields
//
.float		light_lev;		// not used by game, but parsed by light util
.float		style;


//
// monster ai
//
.void()		th_stand;
.void()		th_walk;
.void()		th_run;
.void()		th_missile;
.void()		th_melee;
.void(entity attacker, float damage)		th_pain;
.void()		th_die;

.entity		oldenemy;		// mad at this player before taking damage

.float		speed;

.float	lefty;

.float	search_time;
.float	attack_state;

float	AS_STRAIGHT		= 1;
float	AS_SLIDING		= 2;
float	AS_MELEE		= 3;
float	AS_MISSILE		= 4;

//
// player only fields
//
.float		walkframe;

.float 		attack_finished;
.float		pain_finished;

.float		invincible_finished;
.float		invisible_finished;
.float		super_damage_finished;
.float		radsuit_finished;

.float		invincible_time, invincible_sound;
.float		invisible_time, invisible_sound;
.float		super_time, super_sound;
.float		rad_time;
.float		fly_sound;

.float		axhitme;

.float		show_hostile;	// set to time+0.2 whenever a client fires a
							// weapon or takes damage.  Used to alert
							// monsters that otherwise would let the player go
.float		jump_flag;		// player jump flag
.float		swim_flag;		// player swimming sound flag
.float		air_finished;	// when time > air_finished, start drowning
.float		bubble_count;	// keeps track of the number of bubbles
.string		deathtype;		// keeps track of how the player died

//
// object stuff
//
.string		mdl;
.vector		mangle;			// angle at start

.vector		oldorigin;		// only used by secret door

.float		t_length, t_width;


//
// doors, etc
//
.vector		dest, dest1, dest2;
.float		wait;			// time from firing to restarting
.float		delay;			// time from activation to firing
.entity		trigger_field;	// door's trigger entity
.string		noise4;

//
// monsters
//
.float 		pausetime;
.entity 	movetarget;


//
// doors
//
.float		aflag;
.float		dmg;			// damage done by door when hit
	
//
// misc
//
.float		cnt; 			// misc flag
	
//
// subs
//
.void()		think1;
.vector		finaldest, finalangle;

//
// triggers
//
.float		count;			// for counting triggers


//
// plats / doors / buttons
//
.float		lip;
.float		state;
.vector		pos1, pos2;		// top and bottom positions
.float		height;

//
// sounds
//
.float		waitmin, waitmax;
.float		distance;
.float		volume;


//additions. --gnounc
.string		killstring;		//the message a monster or item leaves when it kills you "was mauled by a rottweiler" etc. //gnounc


//===========================================================================
	

//
// builtin functions
//

void(vector ang)	makevectors		= #1;		// sets v_forward, etc globals
void(entity e, vector o) setorigin	= #2;
void(entity e, string m) setmodel	= #3;		// set movetype and solid first
void(entity e, vector min, vector max) setsize = #4;
// #5 was removed
void() break						= #6;
float() random						= #7;		// returns 0 - 1
//void(entity e, float chan, string samp, float vol, float atten) sound = #8;	// 2001-09-10 FrikBot support by FrikaC
vector(vector v) normalize			= #9;
void(string e) error				= #10;
void(string e) objerror				= #11;
float(vector v) vlen				= #12;
float(vector v) vectoyaw			= #13;
entity() spawn						= #14;
//qbism:  replaced in gyro	void(entity e) remove				= #15;

// sets trace_* globals
// nomonsters can be:
// An entity will also be ignored for testing if forent == test,
// forent->owner == test, or test->owner == forent
// a forent of world is ignored
void(vector v1, vector v2, float nomonsters, entity forent) traceline = #16;	

entity() checkclient				= #17;	// returns a client to look for
entity(entity start, .string fld, string match) find = #18;
string(string s) precache_sound		= #19;
string(string s) precache_model		= #20;
//void(entity client, string s)stuffcmd		= #21;	// 2001-09-10 FrikBot support by FrikaC
entity(vector org, float rad) findradius = #22;
void(string s) bprint				= #23;
//void(entity client, string s) sprint		= #24;	// 2001-09-10 FrikBot support by FrikaC
void(string s) dprint				= #25;
string(float f) ftos				= #26;
string(vector v) vtos				= #27;
void() coredump						= #28;		// prints all edicts
void() traceon						= #29;		// turns statment trace on
void() traceoff						= #30;
void(entity e) eprint				= #31;		// prints an entire edict
float(float yaw, float dist) walkmove	= #32;	// returns TRUE or FALSE
// #33 was removed
float(float yaw, float dist) droptofloor	= #34;		// TRUE if landed on floor
void(float style, string value) lightstyle = #35;
float(float v) rint					= #36;		// round to nearest int
float(float v) floor				= #37;		// largest integer <= v
float(float v) ceil					= #38;		// smallest integer >= v
// #39 was removed
float(entity e) checkbottom			= #40;		// true if self is on ground
float(vector v) pointcontents		= #41;		// returns a CONTENT_*
// #42 was removed
float(float f) fabs = #43;
//vector(entity e, float speed) aim		= #44;		// returns the shooting vector	// 2001-09-10 FrikBot support by FrikaC
float(string s) cvar = #45;						// return cvar.value
void(string s) localcmd = #46;					// put string into local que
entity(entity e) nextent = #47;					// for looping through all ents
void(vector o, vector d, float color, float count) particle = #48;// start a particle effect
void() ChangeYaw = #49;						// turn towards self.ideal_yaw
											// at self.yaw_speed
// #50 was removed
vector(vector v) vectoangles			= #51;

//
// direct client message generation
//
// 2001-09-10 FrikBot support by FrikaC  start
/*
void(float to, float f) WriteByte		= #52;
void(float to, float f) WriteChar		= #53;
void(float to, float f) WriteShort		= #54;
void(float to, float f) WriteLong		= #55;
void(float to, float f) WriteCoord		= #56;
void(float to, float f) WriteAngle		= #57;
void(float to, string s) WriteString	= #58;
void(float to, entity s) WriteEntity	= #59;
*/
// 2001-09-10 FrikBot support by FrikaC  end

//
// broadcast client message generation
//

// void(float f) bWriteByte		= #59;
// void(float f) bWriteChar		= #60;
// void(float f) bWriteShort		= #61;
// void(float f) bWriteLong		= #62;
// void(float f) bWriteCoord		= #63;
// void(float f) bWriteAngle		= #64;
// void(string s) bWriteString	= #65;
// void(entity e) bWriteEntity = #66;

void(float step) movetogoal				= #67;

string(string s) precache_file		= #68;	// no effect except for -copy
void(entity e) makestatic		= #69;
void(string s) changelevel = #70;

//#71 was removed

void(string var, string val) cvar_set = #72;	// sets cvar.value

// 2001-09-10 FrikBot support by FrikaC  start
/*
void(entity client, string s) centerprint = #73;	// sprint, but in middle
//void(...) centerprint 	= #73;	// 1999-08-08 Centerprint with multiple strings by Dirk Gerrits
// 1998-08-08 Centerprint with multiple strings by Zhenga  start
void(entity client, string s, string s) centerprint2 = #73;
void(entity client, string s, string s, string s) centerprint3 = #73;
void(entity client, string s, string s, string s, string s) centerprint4 = #73;
void(entity client, string s, string s, string s, string s, string s) centerprint5 = #73;
void(entity client, string s, string s, string s, string s, string s, string s) centerprint6 = #73;
void(entity client, string s, string s, string s, string s, string s, string s, string s) centerprint7 = #73;
*/
// 1998-08-08 Centerprint with multiple strings by Zhenga  end
// 2001-09-10 FrikBot support by FrikaC  end
void(vector pos, string samp, float vol, float atten) ambientsound = #74;

string(string s) precache_model2	= #75;		// registered version only
string(string s) precache_sound2	= #76;		// registered version only
string(string s) precache_file2		= #77;		// registered version only

//void(entity e) setspawnparms			= #78;	// set parm1... to the	// 2001-09-10 FrikBot support by FrikaC
												// values at level start
												// for coop respawn

float(string s) stof = #81;	// 2001-09-20 QuakeC string manipulation by FrikaC
							// taken from QuakeWorld

void(string s, string initvalue, float flags) cvar_create = #93;	// 2001-09-18 New BuiltIn Function: cvar_create() by LordHavoc/Maddes

float(string s) extension_find = #99;	// 2001-10-20 Extension System by Lord Havoc

float(string s) builtin_find = #100;	// 2001-09-14 Enhanced BuiltIn Function System (EBFS) by Maddes

float(string s) cmd_find = #101;	// 2001-09-16 New BuiltIn Function: cmd_find() by Maddes

float(string s) cvar_find = #102;	// 2001-09-16 New BuiltIn Function: cvar_find() by Maddes

string(string s) cvar_string = #103;	// 2001-09-16 New BuiltIn Function: cvar_string() by Maddes

void(string s) cvar_free = #105;	// 2001-09-18 New BuiltIn Function: cvar_free() by Maddes

// 2000-05-02 Network versioning system (NVS) by Maddes  start
#ifdef EXAMPLE_NVS
void(float to, float svc_message, float sub_message, entity e) NVS_InitSVCMsg = #106;
#endif

void(float to, float f) WriteFloat = #107;
// 2000-05-02 Network versioning system (NVS) by Maddes  end

float(entity e) etof = #108;	// 2001-09-25 New BuiltIn Function: etof() by Maddes

entity(float f) ftoe = #109;	// 2001-09-25 New BuiltIn Function: ftoe() by Maddes

// 2001-09-20 QuakeC file access by FrikaC  start
float(string filename, float mode) open = #110;
void(float fhandle) close = #111;
string(float fhandle) gets = #112;
void(float fhandle, string s) write = #113;
// 2001-09-20 QuakeC file access by FrikaC  end

// 2001-09-20 QuakeC string manipulation by FrikaC  start
float(string s) strlen = #114;
string(string s1, string s2) strcat = #115;
string(string s, float start, float length) substring = #116;
vector(string s) stov = #117;
string(string s) zone = #118;
string(string s) unzone = #119;
// 2001-09-20 QuakeC string manipulation by FrikaC  end

//============================================================================

//
// subs.qc
//
void(vector tdest, float tspeed, void() func) SUB_CalcMove;
void(entity ent, vector tdest, float tspeed, void() func) SUB_CalcMoveEnt;
void(vector destangle, float tspeed, void() func) SUB_CalcAngleMove;
void()  SUB_CalcMoveDone;
void() SUB_CalcAngleMoveDone;
void() SUB_Null;
void() SUB_UseTargets;
void() SUB_Remove;

//
//	combat.qc
//
void(entity targ, entity inflictor, entity attacker, float damage) T_Damage;


float (entity e, float healamount, float ignore) T_Heal; // health function

float(entity targ, entity inflictor) CanDamage;
//float(entity targ, entity inflictor, string dtype) CanDamage;	// 1998-10-04 Hit outside water by a discharge fix by Maddes

// ROTATE

.float continue_movesound;	// you can ignore this if you just want the rotating stuff, gb

.string linkname;	// linking rotating doors

.float reverse_rotate;	// for reverse-rotating doors, gb

//============================================================================
// 1997-12-24 Message on respawn by Maddes  start
//
// client.qc
//
.float spawn_info;				// add timeflag for displaying respawn info to entities
// 1997-12-24 Message on respawn by Maddes  end

//============================================================================
// 1997-12-25 ftos() workaround by Maddes  start
//
// world.qc
//
float correct_ftos;				// flag, if the quake.exe can correctly transfer floats to strings
// 1997-12-25 ftos() workaround by Maddes  end

//============================================================================
// 1997-12-25 cvar_set() workaround by Maddes  start
//
// world.qc
//
float correct_cvars;				// flag, if the quake.exe can save and restore cvars correctly
						// otherwise they'll have to be set to id's standard
// 1997-12-25 cvar_set() workaround by Maddes  end

//============================================================================
// 1997-12-26 auto-aim toggle by Maddes  start
//
// weapons.qc / client.qc
//
float IMPULSE_TOGGLE_AIM = 210;			// setting impulse for toggle

.float autoaim_off;				// add flag for auto-aim to entities
// 1997-12-26 auto-aim toggle by Maddes  end

//============================================================================
// 1997-12-30 skin support by Maddes  start
//
// weapons.qc / client.qc / oldone.qc / skins.qc / weapons.qc
//
float	SAVEDGAMECFG_SKIN_NUMBERS_BIT1 = 1;			// first bit of player skin numbers
float	SAVEDGAMECFG_SKIN_NUMBERS_BITS = 31;			// all bits of player skin numbers
							// 1+2+4+8+16 = max 31
//	absolute maximum: SAVEDGAMECFG_SKIN_NUMBERS_BITS / SAVEDGAMECFG_SKIN_NUMBERS_BIT1
float	SAVEDGAMECFG_SKIN_NUMBERS_MAX = 31;			// max number of player skins minus 1

float	IMPULSE_SKIN_NEXT = 200;
float	IMPULSE_SKIN_PREV = 201;
float	IMPULSE_SKINS_MORE = 203;
float	IMPULSE_SKINS_LESS = 204;

.float	skin_selected;				// extra variable for choosen skin to enable event skins (biosuit, pent, etc.)

entity	ShubKiller;				// player who killed Shub for displaying right colors and skin on finale intermission

void(entity ent, float prev_or_next) ChangeSkin;
void(entity ent) SetSkin;
string(entity ent) GetSkinName;
void(entity ent) DisplaySkinName;
// 1997-12-30 skin support by Maddes  end

//============================================================================
// 1998-01-04 event skin support by Maddes  start
//
// skins.qc / weapons.qc
//
float	SAVEDGAMECFG_EVENT_SKINS = 32;
float	IMPULSE_EVENT_SKINS = 202;

float	SKINS_BIOSUIT = 21;			// index of biosuit skin (number - 1)
// 1998-01-04 event skin support by Maddes  end

//============================================================================
// 1998-07-03 hurt_touch fix by Robert Field  start
//
// triggers.qc
//
.float hurt_together_time;
.float hurt_nextthink;
// 1998-07-03 hurt_touch fix by Robert Field  end

//============================================================================
// 1998-07-23 Better performance in handling of powerups by Maddes  start
//
// client.qc / items.qc / player.qc
//
float modelindex_eyes, modelindex_player;
// 1998-07-23 Better performance in handling of powerups by Maddes  end

//============================================================================
/*	// 2000-07-15 Restructured fraglimit and timelimit by Maddes
// 1998-09-15 Two minute warning by Maddes  start
//
// world.qc
//
void() TimeWarning;
// 1998-09-15 Two minute warning by Maddes  end
*/	// 2000-07-15 Restructured fraglimit and timelimit by Maddes

//============================================================================
// 1998-12-23 Monster attack player on intermission points fix by Maddes  start
//
// client.qc / ai.qc
//
float	intermission_running;	// normally in client.qc
// 1998-12-23 Monster attack player on intermission points fix by Maddes  end


//============================================================================
// 1999-02-02 Option: Toggle for previous optional functions by Maddes  start
//
// client.qc / combat.qc / monsters.qc / weapons.qc
//

float	SAVEDGAMECFG_NO_DROWNING_ARMOR = 64;
float	IMPULSE_NO_DROWNING_ARMOR = 212;

float	SAVEDGAMECFG_MONSTER_RANDOM_SKINS = 2097152;
float	SAVEDGAMECFG_MONSTER_SKIN_NUMBERS_BIT1 = 4194304;		// first bit of monster skin numbers
float	SAVEDGAMECFG_MONSTER_SKIN_NUMBERS_BITS = 12582912;		// all bits of monster skin numbers
								// 4194304 + 8388608 = 12582912 / 1 + 2 = max 3
//	absolute maximum: SAVEDGAMECFG_MONSTER_SKIN_NUMBERS_BITS / SAVEDGAMECFG_MONSTER_SKIN_NUMBERS_BIT1
float	SAVEDGAMECFG_MONSTER_SKIN_NUMBERS_MAX = 3;			// max number of monster skins minus 1
float	IMPULSE_MONSTER_SKINS_MORE = 213;
float	IMPULSE_MONSTER_SKINS_LESS = 214;
float	IMPULSE_MONSTER_SKINS_RANDOM = 215;
// 1999-02-02 Option: Toggle for previous optional functions by Maddes  end

//============================================================================
// 1999-02-02 Enhanced info system by Maddes  start
//
// client.qc / info.qc / weapons.qc
//
float	IMPULSE_CLIENT_INFO = 253;
float	IMPULSE_SERVER_INFO = 254;

void() ClientInfo;
void() AutoAimInfo;

void() ServerInfo;
//void() ItemCarryInfo;
//void() MapRotationInfo;
void() MonsterSkinInfo;
void() PlayerSkinInfo;
// 1999-02-02 Enhanced info system by Maddes  end

//============================================================================
// 1999-02-03 Option: Players can not carry weapons/ammo/armor between levels in deathmatch by Maddes  start
//
// client.qc / info.qc
//
float	SAVEDGAMECFG_RESPAWN_NAKED_ON_NEW_MAP = 128;
// 1999-02-03 Option: Players can not carry weapons/ammo/armor between levels in deathmatch by Maddes  end

//============================================================================
// 1999-02-03 Option: Map rotation by Maddes  start
//
// client.qc / info.qc / world.qc
//
float	samelevel;
// 1999-02-03 Option: Map rotation by Maddes  end

//============================================================================
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  start
//
// client.qc / info.qc / world.qc
//
float	SAVEDGAMECFG_DM4_AXEONLY = 2048;
float	axeonly;
// 1999-02-04 Deathmatch mode 3, 4 and 5 by Zoid/Maddes  end

//============================================================================
// 1999-02-19 Enhanced debugging support by Maddes  start
//
// world.qc
//
float	developer;
// 1999-02-19 Enhanced debugging support by Maddes  end

//============================================================================
// 1999-02-20 Functions to locate map bugs by Maddes  start
//
// weapons.qc
//
#ifdef DEBUG_MAPS
float	IMPULSE_PLAYER_POSITION = 199;
float	IMPULSE_LIVING_MONSTERS = 198;
float	IMPULSE_TRIGGER_VISIBILITY = 197;

void() PrintPosition;
void() PrintNearMonsters;
void() ToggleTriggerVisibility;
#endif
// 1999-02-20 Functions to locate map bugs by Maddes  end

//============================================================================
// 1999-05-02 Teleporting objects by Lord Sméagol/Maddes  start
//
// info.qc / triggers.qc
//
float	GAMECFG_TELEPORT_OBJECTS = 1;
// 1999-05-02 Teleporting objects by Lord Sméagol/Maddes  end

//============================================================================
// 1999-06-03 Resume function by Jim Steers/Maddes  start
//
// client.qc / resume.qc / world.qc
//
float	SAVEDGAMECFG_RESUME = 4096;
float	resume;

void() CreateResume;
float() CheckResume;
void() UpdateResume;
// 1999-06-03 Resume function by Jim Steers/Maddes  end

//============================================================================
// 1999-06-04 Rearranged use of console variables by Maddes  start
// 1999-10-15 Rearranged use of console variables again by Maddes  start
float	savedgamecfg;
float	scratch1;
float	scratch2;
float	scratch3;
float	scratch4;
// 1999-10-15 Rearranged use of console variables again by Maddes  end
float	saved1;
float	saved2;
float	saved3;
float	saved4;
// 1999-06-04 Rearranged use of console variables by Maddes  end

//============================================================================
// 1999-10-17 Delayed powerups on map start by Maddes  start
float	SAVEDGAMECFG_DELAYED_POWERUPS = 8192;	// Delayed powerup spawning on map start
// 1999-10-17 Delayed powerups on map start by Maddes  end

//============================================================================
// 1999-10-20 Custom gravity for maps by RocketMan/Maddes  start
.float	gravity;
// 1999-10-20 Custom gravity for maps by RocketMan/Maddes  end

//============================================================================
// 1999-10-23 Possibility to test simultaneous shooting of players in the same frame by Maddes start
#ifdef DEBUG_SHOTS
float	IMPULSE_DEBUG_SHOTS = 150;

void() DebugShowCounter;
#endif
// 1999-10-23 Possibility to test simultaneous shooting of players in the same frame by Maddes  end

//============================================================================
// 2000-07-14 Debug function for client view bug by Maddes  start
//
// client.qc
//
#ifdef DEBUG_CLIENTVIEW
float	IMPULSE_DEBUG_CLIENTVIEW = 151;
#endif
// 2000-07-14 Debug function for client view bug by Maddes  end

//============================================================================
// 2000-07-15 Restructured fraglimit and timelimit by Maddes  start
//
// rules.qc
//
void() CheckRules;
// 2000-07-15 Restructured fraglimit and timelimit by Maddes  end

//============================================================================
// 2000-07-16 Option: Sudden death for fraglimit and timelimit by Maddes  start
//
// rules.qc
//
float	SAVEDGAMECFG_SUDDEN_DEATH = 16384;
// 2000-07-16 Option: Sudden death for fraglimit and timelimit by Maddes  end

//============================================================================
// 2001-04-22 Option: Random map rotation by Maddes  start
//
// client.qc / world.qc
//
float	current_map;
// 2001-04-22 Option: Random map rotation by Maddes  end

//============================================================================
// 2001-09-14 Enhanced BuiltIn Function System (EBFS) by Maddes  start
//
// world.qc
//
float	qc_builtin_find;	// flag if builtin_find() can be used
// 2001-09-14 Enhanced BuiltIn Function System (EBFS) by Maddes  end

//============================================================================
// 2001-09-16 New BuiltIn Function: cmd_find() by Maddes  start
//
// world.qc
//
float	qc_cmd_find;		// flag if cmd_find() can be used
// 2001-09-16 New BuiltIn Function: cmd_find() by Maddes  end

//============================================================================
// 2001-09-16 New BuiltIn Function: cvar_find() by Maddes  start
//
// world.qc
//
float	qc_cvar_find;		// flag if cvar_find() can be used
// 2001-09-16 New BuiltIn Function: cvar_find() by Maddes  end

//============================================================================
// 2001-09-16 New BuiltIn Function: cvar_string() by Maddes  start
//
// world.qc
//
float	qc_cvar_string;		// flag if cvar_string() can be used
// 2001-09-16 New BuiltIn Function: cvar_string() by Maddes  end

//============================================================================
// 2001-09-18 New BuiltIn Function: cvar_create() by LordHavoc/Maddes  start
//
// world.qc
//
float	CVAR_QC_NONE = 0;		//cvar has no flags
float	CVAR_QC_ARCHIVE = 1;	//cvar will be stored in config.cfg
float	CVAR_QC_ROM = 2;		//cvar is readonly to user
float	CVAR_QC_NOTIFY = 4;		//cvar changes will be broadcasted to all players
float	CVAR_QC_SERVERINFO = 8;	//cvar will be send to clients (net_dgrm.c)
float	CVAR_QC_USERINFO = 16;	//cvar will be send to server (QW-like)

float	qc_cvar_create;		// flag if cvar_create() can be used
// 2001-09-18 New BuiltIn Function: cvar_create() by LordHavoc/Maddes  end

//============================================================================
// 2001-09-18 New BuiltIn Function: cvar_free() by Maddes  start
//
// world.qc
//
float	qc_cvar_free;		// flag if cvar_free() can be used
// 2001-09-18 New BuiltIn Function: cvar_free() by Maddes  end

//============================================================================
// 2001-09-20 QuakeC string manipulation by FrikaC  start
//
// world.qc
//
float	qc_stof;		// flag if stof() can be used

float	qc_strlen;		// flag if strlen() can be used
float	qc_strcat;		// flag if strcat() can be used
float	qc_substring;	// flag if substring() can be used
float	qc_stov;		// flag if stov() can be used
float	qc_zone;		// flag if zone() can be used
float	qc_unzone;		// flag if unzone() can be used
// 2001-09-20 QuakeC string manipulation by FrikaC  end

//============================================================================
// 2001-09-20 QuakeC file access by FrikaC  start
//
// world.qc
//
float	qc_file_open;	// flag if file_open() can be used
float	qc_file_close;	// flag if file_close() can be used
float	qc_file_read;	// flag if file_read() can be used
float	qc_file_write;	// flag if file_write() can be used

// file_open constants
float FILE_READ = 0;
float FILE_APPEND = 1;
float FILE_WRITE = 2;
// 2001-09-20 QuakeC file access by FrikaC  end

//============================================================================
// 2001-09-25 New BuiltIn Function: etof() by Maddes  start
//
// world.qc
//
float	qc_etof;	// flag if etof() can be used
// 2001-09-25 New BuiltIn Function: etof() by Maddes  end

//============================================================================
// 2001-09-25 New BuiltIn Function: ftoe() by Maddes  start
//
// world.qc
//
float	qc_ftoe;	// flag if ftoe() can be used
// 2001-09-25 New BuiltIn Function: ftoe() by Maddes  end

//============================================================================
// 2001-10-20 Extension System by Lord Havoc  start
//
// world.qc
//
float	qc_extension_find;	// flag if extension_find() can be used
// 2001-10-20 Extension System by Lord Havoc  end
