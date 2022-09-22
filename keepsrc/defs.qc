//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: All, primarily ID
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
// Function count: 2
// Builtin Function count: 66
//
// Implements: Definitions for main entity fields and global variables
//
// Description:
// Defines all of the main entity, string, float, vector variables used.
// Mod specific variables are defined in their own defs files.
//=============================================================================

//------------------ SOURCE FOR GLOBALVARS_T C STRUCTURE ----------------------
entity		self;				// Autopopulated entity when thinking.  Overrideable before calling other functions that rely on proper entity to be self.
entity		other;				// Autopopulated entity when a touch is registered.  This is what touched self.  Overrideable before calling other functions that rely on proper entity to be other.
entity		world;				// The entity that displays the level and has all of the worldspawn options.  Also used generally to represent a null entity.
float		time;				// Global time.  Starts at 0 when level is started and increases by 1 every 1 second.
float		frametime;			// The time taken to calculate and update this frame.
float		force_retouch;		// Force all entities to touch triggers next frame.  This is needed because non-moving things don't normally scan for triggers, and when a trigger is created (like a teleport trigger), it needs to catch everything.  Decremented each frame, so set to 2 to guarantee everything is touched.
string		mapname;			// Name of the current level.
float		deathmatch;			// Playing with just players when greater than 0.
float		coop;				// Playing with players and monsters when greater than 0.
float		teamplay;			// Whether playing with teams or not.  Typically only for multiplayer to signify no damage between players with same pants color (friendly fire).
float		serverflags;		// Propagated from level to level, used to keep track of completed episodes and runes
float		total_secrets;		// Total secrets on this map
float		total_monsters;		// Total mosnters on this map
float		found_secrets;		// number of secrets found
float		killed_monsters;	// number of monsters killed
float		parm1, parm2, parm3, parm4, parm5, parm6, parm7, parm8, parm9, parm10, parm11, parm12, parm13, parm14, parm15, parm16; // These parms are used to encode information about clients across server level changes.  This is where all save data is stored.
vector		v_forward, v_up, v_right; // Global direction vectors set by makevectors().  Useful for placing things relative to an entities viewpoint.
float		trace_allsolid;		// Both start and end vectors were in a solid (in the void)
float		trace_startsolid;	// the start point was in a solid
float		trace_fraction;		// how much of the vector (% from 0 to 1) was traced before it hit something
vector		trace_endpos;		// the final position (if it didn't hit anything, then this is the same as vec2, otherwise it's the impact point
vector		trace_plane_normal;	// the normal of the surface it hit
float		trace_plane_dist;	// used for angled surfaces
entity		trace_ent;			// the entity it hit (or world if it hit nothing)
float		trace_inopen;		// if some portion of the trace is in the air
float		trace_inwater;		// if some portion of the trace is in water (if it's in both air and water, both are set)
entity		msg_entity;			// Destination of single entity writes for WriteByte
void() 		main;				// only for testing
void()		StartFrame;			// Initial function called at beginning of every frame before all entities are updated.
void() 		PlayerPreThink;		// Main player think function for start of frame.
void() 		PlayerPostThink;	// Main player think function for end of frame.
void()		ClientKill;			// Called when a client is killed.
void()		ClientConnect;		// Called when a client connects to a server
void() 		PutClientInServer;	// Call after setting the parms
void()		ClientDisconnect;	// Called when a client disconnects from a server, such as when calling `disconnect` from the console or quitting.
void()		SetNewParms;		// Called when a client first connects to a server. sets parms so they can be saved off for restarts
void()		SetChangeParms;		// Call to set parms for self so they can be saved for a level transition
void		end_sys_globals;	// Flag for structure dumping of global variables. Indicates to the engine that this is the end of the primary global definitions.  Engine checks if the defs above are typical for normal Quake or some other game.

//------------------ SOURCE FOR ENTVARS_T C STRUCTURE -------------------------
.float		modelindex;			// Model index in the precached list of models.
.vector		absmin, absmax;		// Origin + mins, + maxs
.float		ltime;				// Local time for entity  typically used for brush physics
.float		movetype;			// Movement type for engine to perform physics.
.float		solid;				// Solidity for physics checks done by engine.
.vector		origin;				// Center point of an entity located in world space.
.vector		oldorigin;			// Useful vector for remembering position
.vector		velocity;			// Positional speed
.vector		angles;				// Rotation
.vector		avelocity;			// Rotational speed
.vector		punchangle;			// Temp angle adjust from damage or recoil, usually used for weapon recoil on the player.
.string		classname;			// Spawn function name for entities.  Overrideable for redirects.
.string		model;				// The current model, either sprite .spr or 3D model .mdl.
.float		frame;				// The current model animation frame
.float		skin;				// The current model skin (aka texture)
.float		effects;			// Engine specific effects such as glow, muzzleflash, etc.
.vector		mins, maxs;			// Bounding box extents relative to origin
.vector		size;				// maxs - mins
.void()		touch;				// Touch function called by engine when two entities touch
.void()		use;				// Use function called when running target->targetname entity I/O
.void()		think;				// Think function called after nextthink time has elapsed.  Used for continuously updating or performing an action after a delay.
.void()		blocked;			// For doors or plats, called when can't push other
.float		nextthink;			// Time until think should be performed.  Must be greater than `time` before `think` will be called.
.entity		groundentity;		// Do not re-use, engine resets value all the time
.float		health;				// Entity's health.  Used by all damageable objects.
.float		frags;				// Number of kills the entity has achieved.  Usually used in multiplayer.
.float		weapon;				// One of the IT_SHOTGUN, etc flags
.string		weaponmodel;		// Current model for the weapon viewmodel.  Only visible by the current client.
.float		weaponframe;		// Current frame for the weapon viewmodel.
.float		currentammo;		// Current number to display on the HUD.  Could represent anything.
.float		ammo_shells, ammo_nails, ammo_rockets, ammo_cells; // Ammo for original weapons
.float		items;				// Bit flags for player inventory
.float		takedamage;
.entity		chain;
.float		deadflag;
.vector		view_ofs;			// Add to origin to get eye point
.float		button0;			// Left Mouse Button (Fire weapon)
.float		button1;			// Right Mouse Button (Alternate fire)
.float		button2;			// Space bar (Jump)
.float		impulse;			// Weapon changes
.float		fixangle;			// Generic value used to adjust yaw rotation angle.  Reused for other things.
.vector		v_angle;			// View or targeting angle for players
.float		idealpitch;			// Calculated pitch angle for lookup up slopes
.string		netname;			// Human readable name of an object used for printing to the console
.entity 	enemy;				// Who we don't like and are currently attacking.
.float		flags;
.float		colormap;
.float		team;
.float		max_health;			// Players maximum health is stored here
.float		teleport_time;		// Don't back up
.float		armortype;			// Save this fraction of incoming damage
.float		armorvalue;
.float		waterlevel;			// 0 = not in, 1 = feet, 2 = waist, 3 = eyes
.float		watertype;			// A contents value
.float		ideal_yaw;
.float		yaw_speed;
.entity		aiment;
.entity 	goalentity;			// A movetarget or an enemy
.float		spawnflags;
.string		target;
.string		targetname;
.float		dmg_take; 			// Damage is accumulated through a frame. and sent as one single message, so the super shotgun doesn't generate huge messages.
.float		dmg_save;
.entity		dmg_inflictor;
.entity		owner;				// Who launched a missile
.vector		movedir;			// Mostly for doors, but also used for waterjump
.string		message;			// Trigger messages
.float		sounds;				// Either a cd track number or sound number
.string		noise, noise1, noise2, noise3;	// contains names of wavs to play
void		end_sys_fields;		// Flag for structure dumping of entity fields.

//-------------------------- QC SPECIFIC VARIABLES ----------------------------
float FALSE		= 0;
float TRUE		= 1;
float NEGATIVE	= -1;
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
float	MOVETYPE_NONE			= 0;	// never moves
float	MOVETYPE_ANGLENOCLIP	= 1;
float	MOVETYPE_ANGLECLIP		= 2;
float	MOVETYPE_WALK			= 3;	// players only
float	MOVETYPE_STEP			= 4;	// discrete, not real time unless fall
float	MOVETYPE_FLY			= 5;
float	MOVETYPE_TOSS			= 6;	// gravity
float	MOVETYPE_PUSH			= 7;	// no clip to world, push and crush
float	MOVETYPE_NOCLIP			= 8;
float	MOVETYPE_FLYMISSILE		= 9;	// fly with extra size against monsters
float	MOVETYPE_BOUNCE			= 10;
float	MOVETYPE_BOUNCEMISSILE	= 11;	// bounce with extra size
float	MOVETYPE_FOLLOW 		= 12;
float	MOVETYPE_6DOF 			= 30;	// A glorified MOVETYPE_FLY. Players using this movetype will get some flightsim-like physics, with fully independant rotations (order-dependant transforms).
float	MOVETYPE_WALLWALK 		= 31;	// Players using this movetype will be able to orient themselves to walls, and then run up them.
float	MOVETYPE_PHYSICS 		= 32;	// Enable the use of ODE physics upon this entity.
float	SOLID_NOT			= 0;	// no interaction with other objects
float	SOLID_TRIGGER		= 1;	// touch on edge, but not blocking
float	SOLID_BBOX			= 2;	// touch on edge, block
float	SOLID_SLIDEBOX		= 3;	// touch on edge, but not an onground
float	SOLID_BSP			= 4;	// bsp clip, touch on edge, block
float	RANGE_MELEE			= 0;
float	RANGE_NEAR			= 1;
float	RANGE_MID			= 2;
float	RANGE_FAR			= 3;
float	DEAD_NO				= 0;
float	DEAD_DYING			= 1;
float	DEAD_DEAD			= 2;
float	DEAD_RESPAWNABLE	= 3;
float	DEAD_REMOVE			= 4;
float	DEAD_EXPLODE		= 5;
float	DEAD_FINISHED		= 6;
float	DAMAGE_NO			= 0;	// No damage
float	DAMAGE_YES			= 1;	// No grenades
float	DAMAGE_AIM			= 2;	// Everything hits
float	CONTENT_EMPTY		= -1;
float	CONTENT_SOLID		= -2;
float	CONTENT_WATER		= -3;
float	CONTENT_SLIME		= -4;
float	CONTENT_LAVA		= -5;
float	CONTENT_SKY			= -6;
float	STATE_TOP		= 0;
float	STATE_BOTTOM	= 1;
float	STATE_UP		= 2;
float	STATE_DOWN		= 3;
float	STATE_DISABLED	= 4;
float	STATE_ENABLED	= 5;
float	STATE_DELETE	= 6;
float	STATE_MOVING	= 7;
float	STATE_ONE		= 1;
float	STATE_TWO		= 2;
vector	VEC_ORIGIN = '0 0 0';
vector	VEC_HULLE_MIN = '-2 -2 -2'; // Minion Eggs = Scorpions, Spiders and Voreling
vector	VEC_HULLE_MAX = '2 2 2';
vector	VEC_HULLT_MIN = '-24 -24 0';
vector	VEC_HULLT_MAX = '24 24 40';
vector	VEC_HULL_MIN = '-16 -16 -24';
vector	VEC_HULL_MAX = '16 16 32';
vector	VEC_HULL2_MIN = '-32 -32 -24'; // Original ID Ogre, Shalrath, Demon, Shambler
vector	VEC_HULL2_MAX = '32 32 64';
vector	VEC_ITEM_MIN = '-16 -16 0';
vector	VEC_ITEM_MAX = '16 16 56';
float	SVC_DISCONNECT		= 2;	// Mainly used in client.qc
float	SVC_UPDATESTAT		= 3;	// Force update of stats
float	SVC_SETVIEW			= 5;	// Set camera viewpoint entity
float 	SVC_SETVIEWANGLES	= 10;	// Set camera viewing angles
float	STAT_TOTALSECRETS 	= 11;	// Added total monster message
float	STAT_TOTALMONSTERS 	= 12;
float   SVC_SCALE           = 20;
float	SVC_TEMPENTITY		= 23;
float	SVC_SETPAUSE		= 24;
float	SVC_CENTERPRINT		= 26;
float	SVC_KILLEDMONSTER	= 27;
float	SVC_FOUNDSECRET		= 28;
float	SVC_SPAWNSTATICSOUND= 29;
float	SVC_INTERMISSION	= 30;
float	SVC_FINALE			= 31;
float	SVC_CDTRACK			= 32;
float	SVC_SELLSCREEN		= 33;
float	SVC_CUTSCENE		= 34;
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
float   TE_EXPLOSION2   = 12;
float	TE_BEAM			= 13;  			
float	CHAN_AUTO	= 0;		// Sound channel 0 never willingly overrides other channels (1-7).  Always override a playing sound on that channel 0.
float	CHAN_WEAPON	= 1;
float	CHAN_VOICE	= 2;
float	CHAN_ITEM	= 3;
float	CHAN_BODY	= 4;
float	CHAN_FEET	= 5;
float	CHAN_EXTRA1	= 6;
float	CHAN_EXTRA2	= 7;
float	ATTN_NONE	= 0;
float	ATTN_NORM	= 1;
float	ATTN_FEETL	= 1.5;
float	ATTN_FEET	= 2;
float	ATTN_IDLE	= 2;
float	ATTN_ARMOUR	= 2;
float	ATTN_GIB	= 2;
float	ATTN_BREAK  = 2;
float	ATTN_WEAPON = 2.3;
float	ATTN_LOW	= 3;
float	ATTN_STATIC	= 3;
float	ATTN_QUIET	= 3.99;
float	UPDATE_GENERAL	= 0;
float	UPDATE_STATIC	= 1;
float	UPDATE_BINARY	= 2;
float	UPDATE_TEMP		= 3;
float	EF_BRIGHTFIELD	= 1;
float	EF_MUZZLEFLASH 	= 2;
float	EF_BRIGHTLIGHT 	= 4;
float	EF_DIMLIGHT 	= 8;
float	MSG_BROADCAST	= 0;		// unreliable to all
float	MSG_ONE			= 1;		// reliable to one (msg_entity)
float	MSG_ALL			= 2;		// reliable to all
float	MSG_INIT		= 3;		// write to the init string
float 	AS_RUNNING   = 0; // Hunt mode (find player)
float 	AS_STRAIGHT  = 1; // Running at player
float 	AS_SLIDING   = 2; // Straft attack
float 	AS_MELEE     = 3; // Melee attack
float 	AS_MISSILE   = 4; // Range attack
float 	AS_JUMP      = 5; // Jumping attack
float 	AS_TURRET    = 6; // Turret Range attack
float 	AS_SIDESTEP  = 7; // Turn 90 degrees and move to the side
float 	AS_BACKWARD  = 8; // Turn 180 degrees and move backwards
float 	AS_DODGING   = 9; // was 5 in hipnotic originally 
float 	AS_CHASING   = 10;// Use shortest, direct path to chase target.
float 	AS_VERTICAL  = 11;// Like AS_SLIDING, but vertical (up or down).
float 	AS_FLANKING  = 12;// AS_SLIDING if close, AS_STRAIGHT otherwise.
float 	AS_FLEEING   = 13;// Reverse of AS_STRAIGHT, used by wraith.
float 	AS_REAPER    = 14;// Sucking in souls, used by wraith.
float 	AS_COWARDLY  = 15;// Back off if too close.  Otherwise, as_straight.

float	movedist;
float	gameover;			// set when a rule exits
entity	newmis;				// launch_spike sets this after spawning it
entity	activator;			// the entity that activated a trigger or brush
entity	damage_attacker;	// set by T_Damage
float	framecount;
float	skill, oskill;
float 	developer;

.string		wad;
.string 	map;
.float		worldtype;		// 0=medieval 1=metal 2=base
.string		killtarget;
.float		light_lev;		// not used by game, but parsed by light util
.float		style;
.void()		th_stand;
.void()		th_walk;
.void()		th_run;
.void()		th_missile;
.void()		th_melee;
.void(entity inflictor, entity attacker, float damage) th_pain;
.void()		th_die;
.entity		oldenemy;		// mad at this player before taking damage
.float		speed;
.float		lefty;
.float		search_time;
.float		attack_state;
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
.float		show_hostile;	// set to time+0.2 whenever a client fires a weapon or takes damage.  Used to alert monsters that otherwise would let the player go
.float		jump_flag;		// player jump flag
.float		swim_flag;		// player swimming sound flag
.float		air_finished;	// when time > air_finished, start drowning
.float		bubble_count;	// keeps track of the number of bubbles
.string		deathtype;		// keeps track of how the player died
.string		mdl, mdl2;		// Extra mdl2 string
.vector		mangle;			// angle at start
.float		t_length, t_width;
.vector 	lastorigin;		// Last position of an entities origin
.vector		dest0, dest1, dest2, dest3;
.float		wait;	// time from firing to restarting
.float		delay, delay2;	// time from activation to firing
.entity		trigger_field;	// door's trigger entity
.string		noise4, noise6;
.float		dmg;			// damage done by door when hit
.float 		pausetime;
.entity 	movetarget;
.float 		inpain;			// Originally defined in zombie.qc
.float		movespeed;		// Movement speed (linked to skill)
.float		tetherlock;		// Is the monster locked from movement
.float		aflag;			// Ammo quantity stored on items
.float		aused;			// Ammo quantity used (respawn aware)
.float		cnt; 			// misc flag
.void()		think1;
.vector		finaldest, finalangle;
.float		count;			// for counting triggers
.float		endstate;		// final state for trigger_relay
.float		lip;
.float		state;
.vector		pos1, pos2, pos3; // top and bottom positions
.vector		pos4, pos5, pos6; // Move general variables
.float		height;
.float		waitmin, waitmin2, waitmin3; /*, waitmax*/
.float		distance;
.float		volume;

float		engine;				// Type of engine active 0=Fitz, 1=DP, 2=FTE
float		ext_active;			// PR extenstions active (DP/FTE)
float       ext_rerelease;      // Using the Quake Rerelease engine
float		ext_dpfog;			// Extra DP fog parameters
float		ext_dppart;			// Extra DP particle system
float		ext_ftepart;		// Extra FTE particle system
float		ext_dpsurf;			// Extra DP query surface information
float		ext_dprain;			// Extra DP particle rain system
float		ext_dpsnow;			// Extra DP particle snow system
float		ext_dprot;			// Extra DP rotating bmodel system
float		ext_fteskin;		// Extra FTE skin/ladder system
float		ext_frikfile;		// Extra FRIK File extension system
float		ext_ftestrings;		// Extra FTE/QSS file extensions
float		ext_sprintf;		// Sprintf C code function (exposed to QC)

float(float yaw, float dist) noclip_move;

// builtin functions
void(vector ang)	makevectors		= #1;	// sets v_forward, etc globals
void(entity e, vector o) setorigin	= #2;
void(entity e, string m) setmodel	= #3;	// set movetype and solid first
void(entity e, vector min, vector max) setsize = #4;
void() break						= #6;
float() random						= #7;	// returns 0 - 1
vector(vector v) normalize			= #9;
void(string e) error				= #10;
void(string e) objerror				= #11;
float(vector v) vlen				= #12;
float(vector v) vectoyaw			= #13;

float totaledicts, startframe_edicts;

entity() spawn_builtin				= #14;
// spawn() down below after dprint so it can warn when max edicts is reached.
void(vector v1, vector v2, float nomonsters, entity forent) traceline = #16; // sets trace_* globals.  nomonsters can be true to ignore blocking monsters.  An entity will also be ignored for testing if forent == test, a forent of world is ignored
entity() checkclient				= #17;	// returns a client to look for
entity(entity start, .string fld, string match) find = #18;
string(string s) precache_sound		= #19;
string(string s) precache_model		= #20;
void(entity client, string s)stuffcmd = #21;
entity(vector org, float rad) findradius = #22;
void(string s) dprint				= #25;
string(float f) ftos				= #26;
string(vector v) vtos				= #27;

void(entity targ) entity_stop;
entity testlastspawn;
entity() spawn = {
	local float emax;

	emax = 8191;
	if (ext_ftepart) emax = 14999;
	if (totaledicts >= emax) {
		if (developer > 1) {
			dprint("WARNING: Out of edicts!  Reached ");
			dprint(ftos(totaledicts));
			dprint(" edicts!\n");
		}
		if (!newmis) return world;

		newmis.flags = 0;
		entity_stop(newmis);
		return newmis;
	}
	if ((totaledicts - startframe_edicts) > 100 && framecount > 15) {
		if (developer > 1) dprint("WARNING: Spawned 100 new entities this frame! Stopped until next frame!\n");
		if (!newmis) return world;

		newmis.flags = 0;
		entity_stop(newmis);
		return newmis; // Prevent runaway loop errors on spawners and gibs.
	}

	totaledicts = totaledicts + 1;
	//if (self) {
	//	dprint("self: ");
	//	dprint(self.classname);
	//	dprint(" -- ");
	//}
	//dprint("spawned new entity ");
	//dprint(ftos(totaledicts));
	//dprint("\n");
	testlastspawn = spawn_builtin();
	return testlastspawn;
};
void() coredump						= #28;	// prints all edicts
void() traceon						= #29;	// turns statment trace on
void() traceoff						= #30;
float(float yaw, float dist) walkmove_builtin = #32; // returns TRUE or FALSE
float(float yaw, float dist) walkmove = {
	if (self.attack_state == AS_TURRET) return FALSE;
	if (self.movespeed < 0) return FALSE;
	if (self.tetherlock == TRUE) return FALSE;
	if (self.movetype == MOVETYPE_NOCLIP) return noclip_move (yaw, dist); // Nehahra wraith or custom
	return walkmove_builtin(yaw,dist);
};
void(entity) eprint 				= #33;
float() droptofloor					= #34; // TRUE if landed on floor
float(float v) rint					= #36; // round to nearest int
float(float v) floor				= #37; // largest integer <= v
float(float v) ceil					= #38; // smallest integer >= v
float(entity e) checkbottom			= #40; // true if self is on ground
float(vector v) pointcontents		= #41; // returns a CONTENT_*
float(float f) fabs 				= #43;
vector(entity e, float speed) aim 	= #44; // returns the shooting vector
float(string s) cvar 				= #45; // return cvar.value
void(string,...) localcmd 			= #46;
entity(entity e) nextent 			= #47; // for looping through all ents
void(vector o, vector d, float color, float count) particle = #48;// start a particle effect
void() ChangeYaw 					= #49; // turn towards self.ideal_yaw at self.yaw_speed
vector(vector v) vectoangles		= #51;
void(float to, float f) WriteByte		= #52;
void(float to, float f) WriteChar		= #53;
void(float to, float f) WriteShort		= #54;
void(float to, float f) WriteLong		= #55;
void(float to, float f) WriteCoord		= #56;
void(float to, float f) WriteAngle		= #57;
void(float to, string s) WriteString	= #58;
void(float to, entity s) WriteEntity	= #59;
// void(float f) bWriteChar				= #60;
// void(float f) bWriteShort			= #61;
// void(float f) bWriteLong				= #62;
// void(float f) bWriteCoord			= #63;
// void(float f) bWriteAngle			= #64;
// void(string s) bWriteString			= #65;
// void(entity e) bWriteEntity 			= #66;

void(float dist, float noclip) QC_MoveToGoal;
void(float dist) movetogoalplus;

void(float step) movetogoal_builtin 	= #67;
void(float step) movetogoal = {
	// Save origin for cinematic camera angle interpolation.  This does not cope
	// with bmodel origins, only point entities
	self.lastorigin = self.origin;
	if (self.attack_state == AS_TURRET) return;
	if (self.movespeed < 0) return;
	if (self.tetherlock == TRUE) return;
	if (self.movetype == MOVETYPE_NOCLIP) QC_MoveToGoal(step,TRUE); // Ghostly
	else if (self.flags & FL_SWIM) movetogoalplus(step);
	//else if (self.flags & FL_FLY) QC_MoveToGoal(step,FALSE);
	else movetogoal_builtin(step);
};
string(string s) precache_file			= #68; // Only in world.qc. No effect
                                               // except for -copy.
void(entity e) makestatic				= #69;
void(string var, string val) cvar_set 	= #72; // sets cvar.value
void(string var, string s, string s) cvar_setlong = #72; // sets cvar.value
void(vector pos, string samp, float vol, float atten) ambientsound = #74;
string(string s) precache_model2		= #75; // not used anymore
string(string s) precache_sound2		= #76; // registered version only
string(string s) precache_file2			= #77; // Only in world.qc
void(entity e) setspawnparms			= #78; // set parm1... to the values at
                                               // level start for coop respawn

entity sight_entity;		// Highlight an angry monster
float sight_entity_time;	// Time got angry

.string sighttarget;			// Attack this target if sighted
.string sightgroup;				// Group name for attacking as one

entity sightgroup_entity;		// Attack group all together
float sightgroup_entity_time;	// Time to activate
float(entity targ) infront;
float (entity targ) visible;
float(entity targ, float flat2d) range_distance;
float(float attackdist, float attackzaxis) ai_checkmelee;
float(entity targ) visblocked;
float(entity source, entity targ, vector s_offset, vector t_offset,
      float nomonsters) visxray;
float (entity targ, vector s_ofset, vector t_ofset) visblocked_wide;
float() FacingIdeal;
float(entity source, entity targ, float ignorenoshoot) ai_foundbreakable;
float modelindex_eyes, modelindex_player;
float intermission_running;											
float intermission_exittime;
string nextmap;				// Used by GotoNextMap()

.float dmgtime;				// Used by WaterMove()
.float poisonous;			// A monster with poisonous attack

void(entity targ) Client_LadderSounds;
void(entity targ) BleedDeBuff;
void(entity targ) BurnDeBuff;
void(entity targ) PoisonDeBuff;
void(entity targ) PlayLavaShieldSound;
void(entity targ) PlayBlastBeltSound;
void(entity targ) PlayPentagramSound;
float DAMARMOR = 1;		// Typical damage to health + armour
float NOARMOR = 2;		// Ingnores armour for damage reduction
float DAMSPLASH = 4;	// Splash damage only
float DAMAGEALL = 4;
float IGNORECLASS = 8;
void(entity targ, entity inflictor, entity attacker, float damage,
     float checkarmor) T_Damage;
void(entity inflictor, entity attacker, float damage, entity ignore,
     float checkclass) T_RadiusDamage;
float(entity targ, entity inflictor) CanDamage;
float enemy_vis, enemy_infront, enemy_range;
float enemy_yaw;

.float	healamount, healtype;

float (entity e, float healamount, float ignore) T_Heal;
void(entity targ) item_proglist_setup;
void() SUB_regen;
void() monster_sightsound;
void() monster_liquid_check;
void() monster_death_use;
void(float gib_no, float gib_qty) ThrowGib;
void() monster_ThrowGib;
void() SUB_Null;
void() SUB_UseTargets;
void() SUB_Remove;
float(float regbitflag) query_configflag;
float(float regbitflag) query_temp1flag;
void(float defvol) SUB_BoundSoundVolume;
void() trigger_bmodel_sounds;
void() trigger_bmodel_setup;
float() check_bmodel_keys;
void() pendulum_setuparray;
entity multi_ent;
float multi_damage;
void(entity targ) W_ChangeWeapon;
void(entity targ, float resetweaponframe) W_SetCurrentAmmo;
float(entity targ) W_BestWeapon;
void() W_WeaponFrame;
void(float sprite_type, vector org, string expl_sound) SpawnExplosion;
void(vector org, float velrnd, float upbase, float uprnd) SpawnProjectileSmoke;
void(entity source, entity targ, float side) SpawnMeatSpray;
void(entity targ, vector org, vector vel, float part_qty, float overridecol) SpawnBlood;