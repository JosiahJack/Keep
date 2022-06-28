//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: All
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
// Entity count: 29
// Function count: 57
//
// Implements: Triggers
//
// Description:
// Various invisible rectangular volumes that perform actions on things or when
// things enter them.
//=============================================================================

float TRIG_SPAWNBUBBLES = 2;	// Produce bubbles
float TRIG_SECRETNOMSG = 2;		// No default message
float TRIG_TELEPLAYER = 1;		// Player only
float TRIG_TELESILENT = 2;		// No teleport sound
float TRIG_TELEALWAYSON = 4;	// Trigger teleports starts on
float TRIG_TELEINSTANT = 8;		// Trigger instant teleport
float TRIG_TELEPROJECTILE = 16;	// Allow projectiles to use teleportors
float TRIG_NOTELESOUNDFX = 32;	// No teleport sound + FX
float TRIG_HURTMONSTER = 4;		// Only hurt monsters
float TRIG_HURTFALLING = 32;	// Only hurt if player falling
float TRIG_PUSHONCE = 1;		// Switch off after one use
float TRIG_PUSHSILENT = 2;		// No wind sound for player
float TRIG_PUSHNOMONSTER = 4;	// Monsters cannot use this push trigger
float TRIG_PUSHADDITIVE = 16;   // Velocity is continuously added, not set
float TRIG_PUSHARC = 32;		// Objects are carefully lobbed to a point.
float TRIG_CONVMONSTER = 2;		// Conveyor moving monsters
float TRIG_CONVITEM = 4;		// Conveyor moving items
float TRIG_CONVPUSHABLE = 8;	// Conveyor moving pushables
float TRIG_LADDERVELOCITY = 4;	// Enable velocity ladder system
float TRIG_LADDERFTESKIN = 8;	// Enable FTE skin ladder system
float TRIG_CMAPNOPAUSE = 1;		// Change level, no info screen, next map
float TRIG_CMAPRESETINV = 2;	// Reset inventory (shotgun+25shells)
float TRIG_CMAPSECSPAWN = 4;	// Spawn at the second spawn point
float TRIG_TAKEARTID = 2;		// Take artifacts, ID set
float TRIG_TAKEARTAD = 4;		// Take artifacts, AD set
float TRIG_TAKEARTVANIA = 8;	// Take artifacts, Vania set
float TRIG_TAKEARTALL = 14;		// All artifacts (2+4+8)
float TRIG_MONJUMPFLY = 2;		// Will affect flying units
float TRIG_MONJUMPSWIM = 4;		// Will affect swimming units
float TRIG_TSOUNDWGEO = 4;		// World Geometry interaction
float TRIG_TSOUNDDRAIN = 8;		// Drain effect when disabled
float TRIG_GRAVITYSERVER = 2;	// Change the server gravity
float TRIG_GRAVITYPLAYONLY = 4;	// Only work with the player
float TRIG_GRAVITYMONONLY = 8;	// Only work with monsters
float TRIG_GRAVITYRESET = 16;	// Reset entities to default gravity
float TRIG_VELPLAYER = 1;		// Player only trigger
float TRIG_VELMONSTER = 2;		// Monster only trigger
float TRIG_VELGRENADE = 4;		// Grenade projectile only trigger
float TRIG_VELROCKET = 8;		// Rocket projectile only trigger
float TRIG_VELEXCEPTION = 15;	// All exceptions merged together
float TRIG_VOIDNOCLIENT = 1;	// Clients will suffer no damage
float TRIG_VOIDNOMONSTER = 2;	// Monsters will be immune to the void
float TRIG_VOIDNOAMMO = 4;		// Ammo projectiles will pass through
float TRIG_VOIDNOEGG = 8;		// Minion eggs will ignore the void
float TRIG_VOIDNOTEMP = 16;		// Temporary entities will exist longer
float TRIG_VOIDNOITEM = 32;		// All items will carry on as before

float(entity o) AffectedByPhysics;

// If a dead body has touched a trigger, setup removal
float(entity body_ent, float body_death) trigger_check_body = { // [FUNCTION]
	if (body_ent.flags & FL_MONSTER && body_ent.deadflag == DEAD_DEAD) {
		body_ent.deadflag = body_death;
		body_ent.touchedvoid = TRUE;
		return TRUE;
	}
	return FALSE;
};

// Setup default dmg and dmgskill entity keys (used for hurt/teleport).
void(float dmgdef) trigger_dmgsetup = { // [FUNCTION]
	if (self.dmg < 0) self.dmg = 0;
	else if (self.dmg == 0) self.dmg = dmgdef;
	
	if (self.dmgskill_x < 0) self.dmgskill_x = 0;	// Skill 0
	if (self.dmgskill_y < 0) self.dmgskill_y = 0;	// Skill 1
	if (self.dmgskill_z < 0) self.dmgskill_z = 0;	// Skill 2+3
	if (CheckZeroVector(self.dmgskill)) self.dmgskill_x = self.dmgskill_y = self.dmgskill_z = self.dmg; // If no skill damage setup, use dmg default.
};

// Return damage based on current skill level.  Expects the dmgskill entity key to be setup beforehand
float() trigger_dmgquery = { // [FUNCTION]
	if (skill == SKILL_EASY) return self.dmgskill_x;
	if (skill == SKILL_NORMAL) return self.dmgskill_y;
	return self.dmgskill_z;
};

// Setup/Spawn/Remove bubbles inside a trigger volume.  Defaults to healing bubbles.
void() trigger_setup_bubbles = { // [FUNCTION]
	// Quake compilers can add the style key to any entity connected to dynamic lights, this is usually 32-64 in value and should not interfere, but never use style > 32 for any values.
	if (self.style == 1) self.mdl = "progs/ad171/s_bubble_grey.spr";
	else if (self.style == 2) self.mdl = "progs/ad171/s_bubble_brnd1.spr";
	else if (self.style == 4) self.mdl = "progs/ad171/s_bubble_grn1.spr";
	else if (self.style == 5) self.mdl = "progs/ad171/s_bubble_red1.spr";
	else if (self.style == 6) self.mdl = "progs/ad171/s_bubble_brnd2.spr";
	else if (self.style == 7) self.mdl = "progs/ad171/s_bubble_pinkyel.spr";
	else if (self.style == 8) self.mdl = "progs/ad171/s_bubble_brnl1.spr";
	else if (self.style == 9) self.mdl = "progs/ad171/s_bubble_purp1.spr";
	else if (self.style == 10) self.mdl = "progs/ad171/s_bubble_purp2.spr";
	else if (self.style == 11) self.mdl = "progs/ad171/s_bubble_brnl2.spr";
	else if (self.style == 12) self.mdl = "progs/ad171/s_bubble_grn2.spr";
	else if (self.style == 13) self.mdl = "progs/ad171/s_bubble_yell.spr";
	else if (self.style == 14) self.mdl = "progs/ad171/s_bubble_blue2.spr";
	else if (self.style == 15) self.mdl = "progs/ad171/s_bubble_red2.spr";
	else if (self.mdl == "") self.mdl = PART_BUBBLE_BLUE;
	precache_model(self.mdl);
	self.waitmin = self.bubble_count = 0;		// Reset counters
	if (!self.count) self.count = 5;			// max active bubbles
	if (!self.height) self.height = self.size_z;
	if (self.height < 64) self.height = 64;		// min top of volume
	self.oldorigin = bmodel_origin(self);
	self.oldorigin_z = self.mins_z;
	self.t_width = (self.size_x/2);
	self.t_length = (self.size_y/2);
	if (self.yaw_speed <= 0) self.yaw_speed = 0.5; // Default spawn rate for bubbles
};

void() trigger_remove_bubble = { // [FUNCTION]
	if (other == self.owner) return;			// Touching self, do nothing
	if (other.solid == SOLID_TRIGGER) return;	// trigger field, do nothing

	self.touch = SUB_Null;
	if (self.owner.bubble_count > 0) self.owner.bubble_count = self.owner.bubble_count - 1;
	remove(self);
};

void() trigger_update_bubble = { // [FUNCTION]
	// The size of the trigger is the default height for the bubbles to raise up, or the height can be specified as a value.
	self.lefty = fabs(self.origin_z - self.owner.oldorigin_z);
	if (self.lefty > self.owner.height) trigger_remove_bubble(); 
	else {
		self.velocity_x = self.velocity_y = 0; // Wobble on the X / Y axis as the bubble raises up
		if (random() < 0.5) self.velocity_x = self.velocity_x + crandom()*4;
		else self.velocity_y = self.velocity_y + crandom()*4;

		self.velocity_z = self.velocity_z + random(); // Make the bubble raise faster by random amounts
		self.nextthink = time + 0.5 + random()*0.5; // Keep updating bubble, 15 updates is the limit
		if (self.count < 15) self.count = self.count + 1;
		else trigger_remove_bubble();
	}
};

void() trigger_spawn_bubbles = { // [FUNCTION]
	local entity bubble;
	
	if (self.estate & ESTATE_BLOCK) return;
	if ( !(self.spawnflags & TRIG_SPAWNBUBBLES) ) return;

	if (self.bubble_count < self.count) {
		self.bubble_count = self.bubble_count + 1;
		bubble = spawn();
		bubble.owner = self;
		bubble.classname = "misc_bubble";
		bubble.classtype = CT_BUBBLE;
		bubble.classgroup = CG_TEMPENT;
		bubble.movetype = MOVETYPE_NOCLIP;
		bubble.solid = SOLID_TRIGGER;
		setmodel(bubble, self.mdl);
		bubble.frame = rint(random() * 3);		// Light/dark colours
		setsize (bubble, VEC_ORIGIN, VEC_ORIGIN);
		bubble.origin_x = self.oldorigin_x + crandom()*self.t_width;
		bubble.origin_y = self.oldorigin_y + crandom()*self.t_length;
		bubble.origin_z = self.oldorigin_z;
		setorigin(bubble, bubble.origin);
		bubble.velocity = vecrand(0,5,TRUE);
		bubble.velocity_z = 10 + random()*15;
		bubble.count = rint(random()*4);
		bubble.nextthink = time + 0.5 + random()*0.5;
		bubble.think = trigger_update_bubble;
		bubble.touch = trigger_remove_bubble;
	}
	self.think = trigger_spawn_bubbles; // Keep spawning bubbles until told not too!
	self.nextthink = time + self.yaw_speed + random()*self.yaw_speed;
};

// QUAKED trigger_multiple (0.5 0 0.5) ? NOTOUCH x DEVMODE x MODCHECK MONSTERS STARTOFF x Not_Easy Not_Normal Not_Hard Not_DM
// ------- KEYS --------
// targetname : trigger entity (works with entity state system)
// target  : trigger all these targets
// health  : Can be damaged instead of touched
// wait    : time between re-triggering
// delay   : delay before firing (after being triggered)
// count   : >0 = number of time can fire before switching off
// angle   : Facing Direction for trigger to work, use "360" for angle 0.
// sounds  : 1=Secret,2=talk(def),3=switch,4=silent,5=custom,6=secret2
// noise   : custom sound to play when triggered
// message : message to display when triggered
// -------- SPAWNFLAGS --------
// NOTOUCH : can only be triggered via other entities
// DEVMODE  : Will only trigger if developer mode active
// MODCHECK : Will remove this entity if THIS mod is active
// MONSTER  : can be touched/triggered by monsters
// STARTOFF : Requires trigger to activate
// ------- NOTES --------
// Variable sized bmodel that uses multiple times
void() trigger_multiple = { // [ENTITY]
	if (check_bmodel_keys()) return;	// Check for bmodel errors
	if (check_bmodel_notouch()) return;	// NO touch + NO targetname!
	if (check_bmodel_modver()) return;	// Check mod version correct

	trigger_bmodel_sounds();			// Precache any sounds
	self.classtype = CT_TRIGMULTI;
	self.classgroup = CG_TRIGGERS;
	InitTrigger ();
	if (!self.wait) self.wait = 0.2;
	trigger_bmodel_setup(); // Setup Entity State functionality
};

// QUAKED trigger_once (0.5 0 0.5) ? NOTOUCH x DEVMODE INVIEW MODCHECK MONSTER STARTOFF x Not_Easy Not_Normal Not_Hard Not_DM
// -------- KEYS --------
// targetname : trigger entity (works with entity state system)
// target  : trigger all these targets
// health  : Can be damaged instead of touched
// wait    : Always -1
// delay : delay before firing (after being triggered)
// angle   : Facing Direction for trigger to work, use "360" for angle 0.
// sounds  : 1=Secret,2=talk(def),3=switch,4=silent,5=custom,6=secret2
// noise   : custom sound to play when triggered
// message : message to display when triggered
// t_length : Inview distance (less than) to activate trigger
// -------- SPAWNFLAGS --------
// NOTOUCH  : can only be triggered via other entities
// DEVMODE  : Will only trigger if developer mode active
// INVIEW   : Player has to be infront and look at trigger (>30 & <60)
// MODCHECK : Will remove this entity if THIS mod is active
// MONSTER  : can be touched/triggered by monsters
// STARTOFF : Requires trigger to activate
// -------- NOTES --------
// Variable sized bmodel that uses once
void() trigger_once = { // [ENTITY]
	if (check_bmodel_keys()) return;	// Check for bmodel errors
	if (check_bmodel_notouch()) return;	// NO touch + NO targetname!
	if (check_bmodel_modver()) return;	// Check mod version correct

	trigger_bmodel_sounds();			// Precache any sounds
	self.classtype = CT_TRIGONCE;
	self.classgroup = CG_TRIGGERS;
	InitTrigger ();
	self.wait = -1;
	if (self.spawnflags & TRIG_INVIEW) {
		self.spawnflags = self.spawnflags | ENT_STARTOFF; // Inview triggers need to start delayed, high cpu functions.
		self.spawnflags = self.spawnflags - (self.spawnflags & TRIG_MONSTERS); // Cannot have inview triggers touched by monsters
	}

	trigger_bmodel_setup(); // Setup Entity State functionality
};

// QUAKED trigger_secret (.5 0 .5) ? NOTOUCH NOMSG x x x x STARTOFF x Not_Easy Not_Normal Not_Hard Not_DM
// ------- KEYS --------
// targetname : trigger entity (works with entity state system)
// target  : name of target(s) to trigger
// health  : Can be damaged instead of touched
// wait    : Always -1
// angle   : Facing Direction for trigger to work, use 360 for angle 0.
// sounds  : 1=Secret(def),2=talk,3=switch,4=silent,5=custom,6=secret2
// noise   : custom sound to play when triggered
// message : message to display when triggered
// -------- SPAWNFLAGS --------
// NOTOUCH : can only be triggered via other entities
// NOMSG   : Remove/Block any trigger secret message
// STARTOFF : Requires trigger to activate
// ------- NOTES --------
// Update map secret counter
void() trigger_secret = { // [ENTITY]
	if (check_bmodel_keys()) return;	// Check for bmodel errors
	if (check_bmodel_notouch()) return;	// NO touch + NO targetname!

	if (self.sounds == 0) self.sounds = 1;
	trigger_bmodel_sounds();				// Precache any sounds
	self.classtype = CT_TRIGSECRET;
	self.classgroup = CG_TRIGGERS;
	InitTrigger ();
	self.wait = -1;							// Trigger ONCE
	self.oldorigin = bmodel_origin(self);	// Save XYZ location
	self.count = 1;		// Add 1 secret
	total_secrets = total_secrets + self.count;
	if (!self.message) self.message = "You found a secret area!";
	if (self.spawnflags & TRIG_SECRETNOMSG) self.message = "";
	self.spawnflags = self.spawnflags - (self.spawnflags & TRIG_MONSTERS); // Cannot have secret triggers touched by monsters
	trigger_bmodel_setup(); // Setup Entity State functionality
};

void() trigger_teleport_sound = { // [ENTITY]
	if (!self.owner) { StopSound(self,CHAN_VOICE); return; } // Has the original bmodel trigger been deleted!?!  Clear sound channel with silence (full volume) if so.
	if (self.owner.attack_finished > time) return; // Has the trigger been hidden/removed?
	
	// The Quake sound system is really basic and dumb! :)
	// Originally the sound of the teleporter was setup as an ambientsound, which always play, loop and cannot be turned off!
	// Normal sounds are ONLY active when the player is in the same portal!
	// This is probably an optimization (engine) thing to save time constantly checking attenuation levels.
	// The teleporter sound is manually looped because of portal problems and so that the trigger can be turned on / off.
	// The waitmin parameter has to match the length of the sound, otherwise the looping will literally sound odd.
	self.nextthink = time + 0.1; // Keep checking for any updates
	self.think = trigger_teleport_sound;

	// Has the trigger changed state recently?
	if (self.owner.estate != self.estate) {
		self.estate = self.owner.estate; // Update sound emitter estate
		
		// If teleport off or disabled, do nothing
		if (self.estate & ESTATE_BLOCK) {
			StopSound(self,CHAN_VOICE); // Clear sound channel with silence (full volume)
			self.fly_sound = LARGE_TIMER;
		} else self.fly_sound = 0; // trigger has been switched on, reset sound
	}

	if (self.fly_sound < time ) { // Play the sound if loop has finished or been reset
		self.fly_sound = time + self.owner.waitmin;
		sound (self, CHAN_VOICE, self.owner.noise, self.owner.volume, ATTN_STATIC);
	}
};

// _use is main path for the closet monster setup where the trigger is fired
// and then anything touching the trigger 0.2s later is teleported
// This forces all touch triggers in a map to check what they are touching!
void() trigger_teleport_use = { // [FUNCTION]
	local entity teledest_ent;

	if (other.teledest > 0) { // Custom destination request
		teledest_ent = find (world, targetname, self.target); // Finds the FIRST teleporter target in entity list
		while(teledest_ent) {
			if (teledest_ent.teledest == other.teledest) { // Found a teleporter destination match?
				self.goalentity = teledest_ent;
				teledest_ent = world; // Stop searching entity list
			} else teledest_ent = find(teledest_ent, targetname, self.target); // Keep search in destination entity list
		}
	}
	
	// Deal with START OFF functionality first
	if (self.spawnflags & ENT_STARTOFF) {
		self.spawnflags = self.spawnflags - ENT_STARTOFF; // Remove start off flag and switch on entity
		self.estate_on();
		return;
	}

	if (self.estate & ESTATE_DISABLE) return; // Block entity state DISABLE


	if (self.estate & ESTATE_OFF) self.estate_on(); // Original AD behaviour; use/trigger = switch on teleport
	force_retouch = 2; // Force retouch is really hard on the engine because EVERY trigger in the map is re-checked for any touching objects.
	self.nextthink = time + 0.2;
	self.think = SUB_Null;
};

// Only switches teleport on, does not force retouch.  Need to trigger/use teleporter to get closet monster behaviour.
void() trigger_teleport_on = { // [FUNCTION]
	self.estate = ESTATE_ON;
	self.state = STATE_ON;
};

void() trigger_teleport_off = { // [FUNCTION]
	self.estate = ESTATE_OFF;
	self.state = STATE_OFF;
};

void() trigger_teleport_debug = { // [FUNCTION]
	if (self.estate & ESTATE_BLOCK) return;		// Entity state blocked
	if (self.debuglvl < 1) return;				// Check for debug mode
	if (!self.goalentity) return;				// Always need target
	if (self.alpha) return;						// Alpha set already

	self.alpha = self.waitmin3; // Reveal trigger surface
	setmodel (self, self.mdl);
	setsize(self, self.bbmins, self.bbmaxs);

	// Reveal destination surface, check for bmodel setup
	if (self.goalentity.bsporigin) {
		self.goalentity.alpha = self.waitmin3;
		setmodel (self.goalentity, self.goalentity.mdl);
		setsize(self.goalentity, self.goalentity.bbmins, self.goalentity.bbmaxs);
	}
};

float() trigger_teleportable = { // [FUNCTION]
	if (self.spawnflags & TRIG_TELEPLAYER && !(other.flags & FL_CLIENT)) return FALSE; // Is the teleporter designed for players only?
	if ((other.health < 1 || other.solid != SOLID_SLIDEBOX) && !(self.spawnflags & TRIG_TELEPROJECTILE) && !(self.spawnflags & 128)) return FALSE; // Only teleport living creatures and monsters (mostly) but let projectiles work with teleporters.
	if ((self.spawnflags & 128) && AffectedByPhysics(other)) return TRUE;  // Qmaster added spawnflag to affect all physical objects such as particles, rockets, etc.
	return TRUE; // Normal
};

void() trigger_teleport_touch = { // [FUNCTION]
	if (self.estate & ESTATE_BLOCK) return;		// Entity off/disabled?
	if (self.attack_finished > time) return;	// Trigger once?  Use to block ent_startoff, but estate_block takes care of it
	if (self.state == STATE_OFF) return;		// Waiting for trigger?
	if (!self.goalentity) return;				// Always need target
	if (!trigger_teleportable()) return;
	
	if (!CheckZeroVector(self.movedir)) { // Did the trigger have an angle key setup?
		if (!other.health) self.pos1 = vectoangles(other.velocity); // Projectiles (no health) are based on velocity
		else self.pos1 = other.angles; // Player/Monster can use angles field instead

		makevectors (self.pos1);
		self.ideal_yaw = self.movedir * v_forward; // Create a dot product of angles vector
		if (self.ideal_yaw < 0) return; // Is angle behind target angle (180 degree arc)
	}
	
	// New AD feature, fire targets on teleporter destination
	if (HasTargets(self.goalentity)) {
		SUB_UseTargetsOnEnt(self.goalentity);
		if (self.wait2 < 0 || self.goalentity.wait < 1) clear_trigstrs(self.goalentity);// only work once
	}

	// Fire all targets on trigger teleporter entity (ID code).  Not sure why? the target *should* be pointing at a single destination.
	// Mapper could use killtarget or message strings instead.  Can use target2, target3, etc. for additional triggers on teleport (new feature).
	SUB_UseTargets ();
	self.pos1 = other.origin; // POS1 = touching entity origin (starting point)
	if (self.goalentity.bsporigin) self.pos2 = self.goalentity.oldorigin; // POS2 = destination origin (can be bmodel or point entity)
	else self.pos2 = self.goalentity.origin;

	// POS3 = Spawn effect for destination (v_forward*32)

	self.dest0 = vectormod(other.angles); // Save for later (debuglvl)
	// I was under the impression that makevector/vectoangles was a loop.
	// This is not the case and the QC commands are not obvious about it
	// 
	// makevectors + v_angle + bsp + spr all pitch (X) one way
	// vectoangles + mdl pitch (X) the other way - thanks spike for info
	//
	// makevectors (self.angles);
	// self.velocity = v_forward * self.speed;
	// self.finalangle = vectoangles(self.velocity);
	//
	// self.angles should equal self.finalangle, but they do not!
	// The result of vectoangles will be reversed on the X axis
	// 
	// This has implications for when trying to create angles or direction
	// vectors for teleporter destination entities. Ideally the best
	// solution is that the destination entity has a target because that is
	// easier to create a direction vector from. Using angles to create
	// the direction vector will have the reverse X axis problem.
	//
	// Instant teleporter behave differently depending on what is being
	// teleported through them.
	// Entities with player or monster flags, will only be affected
	// by Y axis to prevent model distortion (you know, the upsidedown monster hack?).
	// Anything else (projectiles mostly) will be allowed to rotate
	// on any XYZ axis because they do not need to be upright for
	// collision and movement reasons.
	if (self.spawnflags & TRIG_TELEINSTANT) {
		// Check for any angle update (stored in mangle)
		if (!CheckZeroVector(self.goalentity.mangle)) {
			// TYPE 1 Instant teleport - Player / Monster (Y axis ONLY)
			if (other.flags & FLx_CREATURE) {
				// Work out XYZ difference between touch point and trigger origin.  The difference is relative coordinates around 0,0,0.
				self.pos4 = self.oldorigin - self.pos1;
				self.dest1 = vectormod(self.goalentity.mangle);
				self.pos5 = mathlib_vectorotateZ(self.pos4, self.dest1_y); // Rotate destination offset around 0,0,0 (Y axis angle only).  Uses Z axis for rot function because its a vector, not an angles
				self.pos2 = self.pos2 - self.pos5; // Update destination origin with XYZ rotation offset
				other.angles_y = anglemod(other.angles_y + self.dest1_y); // Only update the Y axis (leave XZ intact)
				makevectors(other.angles); // Must create facing angle before any fixangle updates.  This will maintain existing speed with teleportation.
				self.t_length = vlen(other.velocity);
				other.velocity = v_forward * self.t_length;
				if (other.flags & FL_CLIENT) { // Setup special player/client teleport/angle fields.  The player has two angle fields, model and camera.
					other.fixangle = 1;	// Turn this way immediately.  Fixangle will reset the v_angle (camera) on teleport
					other.teleport_time = time + 0.7; // Special state for engine
					other.v_angle_y = other.angles_y; // The up/down angle needs to be same on both entity keys
					other.v_angle_z = 0; // Stop any camera twisting
					other.angles = other.v_angle; // Sync model/cam angles
				}
			} else {
				// TYPE 2 Instant teleport - projectiles (XY axis)
				// X = up/down, Y = left/right, Z = twisting (no used)
				// Method 2 - Use new math rotation functionality
				// The difference is a relative co-ordinates around 0,0,0
				self.pos4 = self.oldorigin - self.pos1;
				self.dest1 = vectormod(self.goalentity.mangle);
				self.dest1_z = 0; // Twist (Z) angle not required, reset to zero to be safe.
				self.pos5 = mathlib_vectorotateZ(self.pos4, self.dest1_y); // Rotate destination offset around 0,0,0.  First rotation is Y angle (left/right), Z vector consistent
				self.pos6 = mathlib_vectorotateY(self.pos5, self.dest1_x); // Second rotation is X angle (up/down), Y vector consistent
				self.pos2 = self.pos2 - self.pos6; // Update destination origin with rotation offset
				if (self.telefixangle) other.angles = self.dest1; // Reset angles to consistent exit direction
				else other.angles = vectormod(other.angles + self.dest1); // Calculate angle offset based on destination angle

				self.pos5 = other.angles; // Creating Velocity from angles will reverse X axis
				if (self.dest1_x == 0) self.pos5_x = -self.pos5_x; // Only reverse X axis if destination X axis not used
				makevectors(self.pos5); // re-create velocity from new angles
				self.t_length = vlen(other.velocity);
				other.velocity = v_forward * self.t_length;
			}
		} else {
			self.pos4 = self.oldorigin - self.pos1; // Touch offset = difference between touch and actual origin
			self.pos2 = self.pos2 - self.pos4; // project XYZ difference from source to target triggers
		}
	} else { // DEFAULT TELEPORTER - Reset velocity, point ent target
		other.angles = vectormod(self.goalentity.mangle); // Turn entity towards facing angle of destination
		makevectors(other.angles);

		// Setup client teleport fields
		if (other.flags & FL_CLIENT) {
			other.fixangle = 1;					// turn this way immediately
			other.teleport_time = time + 0.7;	// Special state for engine
			other.velocity = v_forward * self.speed; // Default speed movement or override (AD only)
		} else if (other.flags & FL_MONSTER && vlen(other.velocity)!=0) { // Setup monster teleport fields
			other.velocity = v_forward * self.speed; // Stationary monsters (closets) should NOT be moving!
		} else if (self.spawnflags & TRIG_TELEPROJECTILE) { // Projectiles should be affected by speed override
			self.pos2 = self.pos2 - self.goalentity.view_ofs; // Destination teleport entities are adjusted upward by view_ofs.  Move destination origin back down to correct position.  Default for most entities is '0 0 0', otherwise its '0 0 27'
			if (!CheckZeroVector(self.goalentity.movedir)) other.velocity = self.goalentity.movedir * self.speed; // Check for target entity (angletarget) direction vector
			else other.velocity = v_forward * self.speed; // Use default velocity vector

			if (self.goalentity.mangle_x == 90 || self.goalentity.mangle_x == 270) other.angles_x = -other.angles_x; // This a stupid hack to get around the problem with up/down angles being back to front for models.  One day I will come back and fix this stupid hack!?!  ...Nah he probably won't lol.
		} else if (!other.health) { // This is usually used for gibs
			other.velocity = (v_forward * other.velocity_x) + (v_forward * other.velocity_y); // Add a little forward momentum to teleporting entity
		}
	}

	// Show extra dev/debug modes (1=markers, 2=arrows, 3=console text)
	if (self.debuglvl > 0) {
		trigger_teleport_debug(); // Turn the teleport triggers visable ingame
		
		// Spawn diamond markers for impact/exit
		if (self.debuglvl == 1) {
			spawn_marker(self.pos1, SPNMARK_YELLOW);
			spawn_marker(self.pos2, SPNMARK_BLUE);
		} else if (self.debuglvl >= 2) { // Spawn model arrows for impact/exit
			makevectors(self.dest0);
			self.pos5 = -v_forward * 32; // Project source angle backwards to create space for arrow
			spawn_arrow(self.pos1 + self.pos5, self.dest0, SPNMARK_YELLOW);
			self.pos6 = vectoangles(other.velocity); // Spawn exit arrow using velocity (actual direction)
			spawn_arrow(self.pos2, self.pos6, SPNMARK_YELLOW);
		}

		// Show original, new and destination angles
		if (self.debuglvl > 2) {
			dprint("Org ("); dprint(vtos(self.dest0));
			dprint(") New ("); dprint(vtos(other.angles));
			dprint(") Dest ("); dprint(vtos(self.goalentity.mangle));
			dprint(")\n");
		}
	}

	// Functionality for ALL original/instant teleporters
	if (self.spawnflags & TRIG_TELEPROJECTILE && !other.health) { // Update projectiles
		other.owner = self; // Owner changed to remove impact exception
		if (other.classgroup == CG_PROJROCKETS && !self.no_trackondeath) other.no_trackondeath = NEGATIVE; // Tracking (homing) projectiles need to stop steering
	}

	makevectors(other.angles); // The destination teleport effect is infront so its seen
	self.pos3 = self.pos2 + (32 * v_forward);

	// Generate spawn telporter glitter and sound.
	if (!(self.spawnflags & TRIG_NOTELESOUNDFX) && self.telefxtimer < time) {
		self.telefxtimer = time + self.waitmin2; // slowdown sound + fx (default = 0.2s)
		spawn_tfog (self.pos1); // create teleport effect at source
		spawn_tfog (self.pos3); // create teleport effect infront of destination
	}

	spawn_tdeath(self.pos2, other); // Kill anything at teleporter destination
	other.origin = self.pos2; // Move to new location
	setorigin (other, other.origin);
	other.flags = other.flags - (other.flags & FL_ONGROUND); // Telporting entities need ground flag removed
	self.dmg = trigger_dmgquery(); // Work out any teleport damage, based on skill level
	if (self.dmg > 0) T_Damage (other, self, self, self.dmg, DAMARMOR);

	// Check for a trigger_once condition
	if (self.wait < 0) {
		self.attack_finished = LARGE_TIMER;
		self.estate_off();
	}
};

void() trigger_teleport_setup = { // [FUNCTION]
	self.goalentity = find (world, targetname, self.target); // Finds the FIRST teleporter target in entity list
	if (!self.goalentity) {
		dprint("\b[TRIG_TELEPORT]\b Cannot find target\n");
		spawn_marker(self.oldorigin, SPNMARK_YELLOW);
		entity_hide(self);
		return;
	}

	// Check teleport destination entities are correct types
	// This is not a critical error condition, no need to stop
	// Display warning and spawn marker for deverloper mode
	if (self.spawnflags & TRIG_TELEINSTANT) {
		if (self.goalentity.classtype != CT_MISCTELINSTANT) {
			dprint("\b[TRIG_TELEPORT]\b Wrong Entity (");
			dprint(self.goalentity.classname); dprint(")\n");
			spawn_marker(self.oldorigin, SPNMARK_YELLOW);
		}
	} else {
		// Default teleporter requires correct dest entity
		if (self.goalentity.classtype != CT_MISCTELEPORT) {
			dprint("\b[TRIG_TELEPORT]\b Wrong Entity (");
			dprint(self.goalentity.classname); dprint(")\n");
			spawn_marker(self.oldorigin, SPNMARK_YELLOW);
		}
	}

	trigger_teleport_debug(); // Update trigger surface for debug info
};

// QUAKED trigger_teleport (0.5 0 0.5) ? PLAYER_ONLY SILENT STARTON INSTANT PROJECTILES NOTELEFX STARTOFF x Not_Easy Not_Normal Not_Hard Not_DM
// -------- KEYS --------
// targetname : trigger entity (works with entity state system)
// target  : Points to info_teleport_destination entity
// target2 : Can be used to fire additional targets
// wait    : -1 = teleport only triggers once (def=0)
// wait2   : -1 = target2 only fires once (def=-1)
// angle   : Facing Direction for trigger to work, use "360" for angle 0.
// speed   : forward momentum speed after teleporting (def=300)
// volume  : teleporter hum sound volume (def=0.5)
// noise   : custom sound to play when active (must be looped, def=hum1.wav)
// waitmin : the length of the custom sound (def=3.622 for hum1.wav)
// waitmin2: Time between teleport sound/fx (def=0.2s) being played
// waitmin3: Alpha value for debug lvl showing triggers ingame (def=0.75)
// dmg     : damage from using the teleport trigger (def=0)
// dmgskill: damage based on skill level X=Easy, Y=Normal, Z=Hard/NM (def=0,0,0)
// debuglvl: shows extra info 1=impact markers, 2=impact arrows, 3=console text
// telefixangle    : 1 = Fixed angle direction for instant teleporters
// no_trackondeath : 1 = Homing projectiles don't stop tracking (def=0 off)
// -------- SPAWNFLAGS --------
// PLAYER_ONLY : Can only be used by players (nothing else)
// SILENT      : No teleporter ambient sound regardless of state
// STARTON     : Will start active regardless of targetname setting
// INSTANT     : Instantly teleport (no adjustment to teleport velocity)
// PROJECTILES : Allow projectiles to use regular/instant teleporters 
// NOTELEFX    : No player sound + FX when teleporting entities
// STARTOFF    : Starts off and waits for trigger
// -------- NOTES --------
// Teleport player or monsters to target location (fixed or variable)
// if targetname is setup, the teleporter requires a trigger to activate
// This entity cannot be damaged and is always touchable once activated
// Can be switched on/off using entity state system (including tele hum sound)
void() trigger_teleport = { // [ENTITY]
	if (check_bmodel_keys()) return;	// Check for bmodel errors

	self.classtype = CT_TRIGTELEPORT;
	self.classgroup = CG_TRIGGERS;
	InitTrigger ();
	self.oldorigin = bmodel_origin(self); // True origin used for errors and debug info
	if (self.noise == "") self.noise = "ambience/hum1.wav"; // Always pre-cache telporter teleporter sound
	precache_sound (self.noise);
	SUB_BoundVolume(0.5);
	if (SUB_HideIfNoTarget()) return; // This is a critical error - teleporter going nowhere!?!

	self.spawnflags = self.spawnflags | TRIG_ALWAYTOUCH | TRIG_NODAMAGE; // No trigger damage functionality and always touchable! Spawnflag 1 is used for something else (notouch duplicate)
	if (self.speed <= 0) self.speed = 300;
	if (self.waitmin2 <= 0) self.waitmin2 = 0.2;
	if (self.waitmin3 <= 0) self.waitmin3 = 0.75;
	if (self.wait2 <= 0) self.wait2 = -1; // Secondary trigger (target2) default=only works once!
	if (self.waitmin <= 0.1) self.waitmin = 3.622; // The default of 3.622 is for hum1.wav.  The length of the custom sound cannot be < 0.1s.
	trigger_dmgsetup(0); // Setup any teleport damage (def=0) parameters
	self.touch = trigger_teleport_touch; // Trigger teleporters cannot be turned off (model hidden) because they are used for monster closets which are always active.
	self.solid = SOLID_TRIGGER;
	setsize (self, self.bbmins, self.bbmaxs);
	self.estate_on = trigger_teleport_on; // Setup Entity State functionality
	self.estate_off = trigger_teleport_off;
	self.estate_use = trigger_teleport_use;
	self.use = entity_state_use;
	
	// Annoying that the targetname is being used like this because there could have been a better way to do this type of functionality.
	// == "" teleporter works fine (starts on)
	// != "" teleporter requires trigger activation
	if (self.spawnflags & TRIG_TELEALWAYSON) self.estate_on();
	else if (self.spawnflags & ENT_STARTOFF) self.estate_off();
	else if (self.targetname != "") self.estate_off();
	else self.estate_on();
	
	// Setup independent sound emitter for teleporter state
	if (!(self.spawnflags & TRIG_TELESILENT)) {
		self.attachment = spawn();
		self.attachment.owner = self;
		self.attachment.estate = -1; // Always start by checking estate values
		self.attachment.movetype = MOVETYPE_NONE;
		self.attachment.solid = SOLID_NOT;
		setorigin(self.attachment, self.oldorigin);
		self.attachment.nextthink = time + 1;
		self.attachment.think = trigger_teleport_sound;
	}

	self.think = trigger_teleport_setup; // Make sure teleport target(s) exist
	self.nextthink = time + 0.1;
};
void() trigger_changelevel_finish = { // [FUNCTION]
	intermission_running = 1;
	if (deathmatch) intermission_exittime = time + 5; // enforce a wait time before allowing changelevel
	else intermission_exittime = time + 2;

	update_hud_totals(HUD_MONSTERS);	// Make screen total is correct
	update_hud_totals(HUD_SECRETS);		// Update monsters and secrets
	WriteByte(MSG_ALL,SVC_CDTRACK);		// Update CD track
	WriteByte(MSG_ALL,SVC_UPDATESTAT);	// Update stats, total kills etc
	WriteByte(MSG_ALL,SVC_UPDATESTAT);	// Update twice?
	StartIntermissionCamera();				// Setup intermission camera(s)
	WriteByte(MSG_ALL,SVC_INTERMISSION);	// Start intermission (lock movement)
};

void() trigger_changelevel_fire = { // [FUNCTION]
	if (self.attack_finished > time) return;
	if (!(self.bmodel_act.flags & FL_CLIENT)) return;
	if (self.bmodel_act.health < 1) return;

	if (self.bmodel_act.in_a_vehicle) {
		TakeTargetOutOfVehicle(self.bmodel_act,FALSE,TRUE); // No jump, destroy car. Need this for getting back actual health.
	}

	self.attack_finished = LARGE_TIMER;
	self.touch = SUB_Null;
	ResetPowerSystem(self.bmodel_act,0,FALSE); // Remove all powerup/debuff effects
	ResetDebuffSystem(self.bmodel_act);
	if (!CheckZeroVector(self.mapvar_update)) mapvar_range(self.mapvar_update); // Check for map variables on exit
	rnd_ResetRandomSeed(RND_NORESETCHLVL); // LEVEL CHANGE = Reset randomizer seed
	
	// Reset player inventory back to ID default (shotgun+25shells)
	if (self.spawnflags & TRIG_CMAPRESETINV) {
		dprint("\b[CHANGELVL]\b Resetting client inventory!\n"); 
		self.bmodel_act.health = HEAL_PLAYMAX;
		self.bmodel_act.armortype = self.bmodel_act.armorvalue = 0;
		self.bmodel_act.ammo_shells = DEF_SHELLS;
		self.bmodel_act.ammo_nails = self.bmodel_act.ammo_rockets = self.bmodel_act.ammo_cells = 0;
		self.bmodel_act.items = IT_SHOTGUN | IT_AXE;
		self.bmodel_act.moditems = 0;
		self.bmodel_act.weapon = IT_SHOTGUN;
	}

	if ((cvar("noexit") == 1) || ((cvar("noexit") == 2) && (mapname != "start"))) { T_Damage (self.bmodel_act, self, self, MEGADEATH, NOARMOR); return; } // Some crazy DM parameters to prevent teleport exit

	if (coop || deathmatch) { bprint (self.bmodel_act.netname); bprint (" exited the level\n"); } // More crazy DM stuff.
	if (self.startspawn2 < 1 && self.startspawn2 > 7) self.startspawn2 = 0; // is there a special info_player_start2 location setup?  This will also reset any values back to zero (default).
	update_configflag(SVR_SPAWN_BIT1, floor( (self.startspawn2 & 1) / 1) );
	update_configflag(SVR_SPAWN_BIT2, floor( (self.startspawn2 & 2) / 2) );
	update_configflag(SVR_SPAWN_BIT3, floor( (self.startspawn2 & 4) / 4) );
	if (self.map) nextmap = self.map; // *change* if map key not defined, reload current map again
	SUB_UseTargets ();
	if ( (self.spawnflags & TRIG_CMAPNOPAUSE) && (deathmatch == 0) ) { GotoNextMap(); return; } // If no intermission, go straight to next map

	self.think = trigger_changelevel_finish; // We can't move people right now, because touch functions are called in the middle of C movement code, so set a think time to do it.
	self.nextthink = time + 0.1;
};

void() trigger_changelevel_setup = { if (!self.map) self.map = mapname; }; // [FUNCTION], If map not defined, use current mapname instead

void() changelevel_touch = { trigger_changelevel_fire();}; // [FUNCTION], Re-direction for map hacks (not used normally)

// QUAKED trigger_changelevel (0.5 0 0.5) ? NO_INTERMIS RESETINV x x x x STARTOFF x Not_Easy Not_Normal Not_Hard Not_DM
// -------- KEYS --------
// targetname : trigger entity (works with entity state system)
// target     : name of target(s) to trigger before intermission
// map        : The name of next map (e.g. e1m1) default=same map
// startspawn2: Special unique number (1-7) which must match info_player_start2
// mapvar_update : Map Variable range to trigger on use (start, finish, value)
// -------- SPAWNFLAGS --------
// NO_INTERMIS : No Intermission screen 
// RESETINV    : Reset player inventory to default (Shotgun+Shells)
// STARTOFF    : Starts off and waits for trigger
// -------- NOTES --------
// Finish current map, show intermission screen and loads next
// This entity cannot be damaged and is always touchable once activated
void() trigger_changelevel = { // [ENTITY]
	if (check_bmodel_keys()) return; // Check for bmodel errors

	self.classtype = CT_TRIGLEVEL;
	self.classgroup = CG_TRIGGERS;
	InitTrigger ();
	self.spawnflags = self.spawnflags | TRIG_ALWAYTOUCH | TRIG_NODAMAGE; // Spawnflag 1 is used for something else (notouch duplicate).  No trigger damage functionality and always touchable!
	self.spawnflags = self.spawnflags - (self.spawnflags & TRIG_MONSTERS); // Cannot have change level triggers touched by monsters
	if (self.targetname != "") self.use = entity_state_use; // Setup Entity State functionality
	self.estate_fire = trigger_changelevel_fire;
	trigger_bmodel_setup();
	self.think = trigger_changelevel_setup; // Wait for everything to spawn before checking map name
	self.nextthink = time + 1;
};

void() trigger_setskill_fire = { // [FUNCTION]
	if (self.attack_finished > time) return;

	cvar_set("skill", self.message); // There is no client check for the skill level change so that the use functionality can work from trigger chains.
	if (self.wait > 0) { // Is the trigger repeatable?
		self.attack_finished = time + self.wait;
		self.nextthink = self.attack_finished;
		self.think = self.estate_on;
	} else { // block trigger and turn off (trigger_once)
		self.attack_finished = LARGE_TIMER;
		self.estate_off();
	}
};

// QUAKED trigger_setskill (0.5 0 0.5) ? NOTOUCH x x x x x STARTOFF x Not_Easy Not_Normal Not_Hard Not_DM
// -------- KEYS --------
// targetname : trigger entity (works with entity state system)
// health  : Can be damaged instead of touched
// wait    : time between re-triggering (def=0.2s, -1=once)
// angle   : Facing Direction for trigger to work, use "360" for angle 0.
// message : Skill Level - 0 = easy, 1 = normal, 2 = hard, 3 = nightmare
// -------- SPAWNFLAGS --------
// NOTOUCH  : can only be triggered via other entities
// STARTOFF : Starts off and waits for trigger
// -------- NOTES --------
// Sets player skill level (via console)
void() trigger_setskill = { // [ENTITY]
	if (check_bmodel_keys()) return;	// Check for bmodel errors
	if (check_bmodel_notouch()) return;	// NO touch + NO targetname!

	self.classtype = CT_TRIGSKILLS;
	self.classgroup = CG_TRIGGERS;
	InitTrigger ();
	if (!self.wait) self.wait = 1;
	if (self.message == "") self.message = "0";
	self.spawnflags = self.spawnflags - (self.spawnflags & TRIG_MONSTERS); // Cannot have skill triggers touched by monsters
	self.estate_fire = trigger_setskill_fire; // Setup Entity State functionality
	trigger_bmodel_setup();
};

void() trigger_rune_fire = { // [FUNCTION]
	if (self.attack_finished > time) return; // Is the trigger blocked? (trigger_once)
	
	self.attack_finished = time + self.waitmin; // Stop the trigger constantly firing

	// Check for single rune trigger
	if (self.target) {
		if (query_configflag(SVR_RUNE_ALL) & self.customkey == self.customkey) {
			trigger_strs(self.target, self.bmodel_act); // This is after _use, _killed and _touch, so any reference to activator has to go through bmodel_act.
			if (self.wait < 0) self.attack_finished = LARGE_TIMER;
		}
	} else {
		// Check for multiple rune triggers
		if (query_configflag(self.customkey & SVR_RUNE_KEY1) == SVR_RUNE_KEY1 && self.noise1 != "") {
			trigger_strs(self.noise1, self.bmodel_act);
			if (self.wait < 0) self.attack_finished = LARGE_TIMER;
		}
		if (query_configflag(self.customkey & SVR_RUNE_KEY2) == SVR_RUNE_KEY2 && self.noise2 != "") {
			trigger_strs(self.noise2, self.bmodel_act);
			if (self.wait < 0) self.attack_finished = LARGE_TIMER;
		}
		if (query_configflag(self.customkey & SVR_RUNE_KEY3) == SVR_RUNE_KEY3 && self.noise3 != "") {
			trigger_strs(self.noise3, self.bmodel_act);
			if (self.wait < 0) self.attack_finished = LARGE_TIMER;
		}
		if (query_configflag(self.customkey & SVR_RUNE_KEY4) == SVR_RUNE_KEY4 && self.noise4 != "") {
			trigger_strs(self.noise4, self.bmodel_act);
			if (self.wait < 0) self.attack_finished = LARGE_TIMER;
		}
	}

	// The attack_finished is set by the RUNE condition being TRUE above.  The trigger is designed to be trigger_once (no need to check wait).
	if (self.attack_finished == LARGE_TIMER) self.estate_off(); // The trigger needs to meet a rune condition before switching off
};

// QUAKED trigger_rune (0.5 0 0.5) ? E1 E2 E3 E4 x x STARTOFF x Not_Easy Not_Normal Not_Hard Not_DM
// -------- KEYS --------
// targetname : trigger entity (works with entity state system)
// health  : Can be damaged instead of touched
// angle   : Facing Direction for trigger to work, use "360" for angle 0.
// target  : trigger to fire if player has MIXTURE of runes
// noise1  : trigger to fire if player has rune 1
// noise2  : trigger to fire if player has rune 2
// noise3  : trigger to fire if player has rune 3
// noise4  : trigger to fire if player has rune 4
// wait    : = -1 Only trigger once if the player has runes
// -------- SPAWNFLAGS --------
// E1 : Episode 1
// E2 : Episode 2
// E3 : Episode 3
// E4 : Episode 4
// STARTOFF : Starts off and waits for trigger
// -------- NOTES --------
// A Trigger that fires once if the player has certain runes.
// There are two ways this trigger can be used, a single check for multiple
// runes using target key OR individual triggers for runes using noise 1-4 keys
// This trigger is designed to work once when rune conditions are met
void() trigger_rune = { // [ENTITY]
	if (check_bmodel_keys()) return;	// Check for bmodel errors

	self.classtype = CT_TRIGRUNES;
	self.classgroup = CG_TRIGGERS;
	InitTrigger ();
	if (self.waitmin <=0) self.waitmin = 1;
	self.spawnflags = self.spawnflags | TRIG_ALWAYTOUCH; // Spawnflag 1 is used for something else (notouch duplicate)
	self.spawnflags = self.spawnflags - (self.spawnflags & TRIG_MONSTERS); // Cannot have rune triggers touched by monsters
	self.customkey = self.spawnflags & SVR_RUNE_ALL; // Calculate the rune key selection
	if (self.customkey == 0) { dprint("\b[trigger_rune]\b No runes setup on customkey! Defaulting to 1.\n"); self.customkey = SVR_RUNE_KEY1; } // Cannot do anything with the trigger if no runes are selected
	self.estate_fire = trigger_rune_fire; // Setup Entity State functionality
	trigger_bmodel_setup();
};

float() trigger_pushable = { // [FUNCTION]
	if (self.bmodel_act.classgroup == CG_PROJGRENADES) return TRUE; // Cool feature is that it will push grenades!
	if ((self.spawnflags & 8) && AffectedByPhysics(self.bmodel_act)) return TRUE;  // Qmaster added spawnflag to affect all physical objects such as particles, rockets, etc.
	if (self.bmodel_act.classtype == CT_PROJ_GL || self.bmodel_act.classtype == CT_PROJ_GLMON ||self.bmodel_act.classtype == CT_PROJ_MEGG) return TRUE; // Added player, ogre and minion eggs to the catch.
	return (self.bmodel_act.classtype == CT_TEMPGIB || self.bmodel_act.classtype == CT_FUNCBREAKOBJ); // Bonus!  Qmaster also has gibs affected.
};

void() trigger_push_fire = { // [FUNCTION]
	local float zdiff, dist, spdattn;

	if (self.estate & ESTATE_BLOCK) return;
	if (self.attack_finished > time) return;
	if (trigger_check_body(self.bmodel_act,DEAD_EXPLODE)) return; // Check for any dead monster bodies (no exceptions)
	if (self.spawnflags & TRIG_PUSHNOMONSTER && self.bmodel_act.flags & FL_MONSTER) return; // Check for no monster exception

	if (self.target != "") { self.angletarget = self.target; TargetMovedir(self, (self.spawnflags & TRIG_PUSHARC)); } // If custom push direction setup, calculate new facing angletarget
	if (trigger_pushable()) {
		if (self.spawnflags & TRIG_PUSHARC && self.movetarget) {
			dist = vlen((self.movetarget.origin - self.bmodel_act.origin));
			if (dist > self.tetherrange) self.bmodel_act.arcing = TRUE;
			if (dist < self.tetherdist) self.bmodel_act.arcing = FALSE;
			if (!self.bmodel_act.arcing) return;

			zdiff = self.movetarget.origin_z - self.bmodel_act.origin_z;
			self.finalangle = self.movetarget.origin;
			if (zdiff > 0) self.finalangle_z = self.finalangle_z + zdiff * 6.66 + 64;
			self.movedir = normalize(self.finalangle - self.bmodel_act.origin);
			spdattn = 10;
			if (dist < 128) spdattn = dist / 128 * 10;
			spdattn = SUB_ClampFloat(spdattn,25,spdattn);
			self.bmodel_act.velocity = self.movedir * self.speed * spdattn;
		} else {
			if (self.spawnflags & TRIG_PUSHADDITIVE) { // Additive velocity rather than forcing the entity to a velocity.
				self.attack_finished = time + 0.1;
				self.bmodel_act.velocity = self.bmodel_act.velocity + (self.speed * self.movedir * 10);
			} else self.bmodel_act.velocity = self.speed * self.movedir * 10; // This is after _use, _killed and _touch, so any reference to activator has to go through 'bmodel_act'.
		}
	} else if (self.bmodel_act.health > 0) { // Standard push for all bmodel_act living entities
		if (self.spawnflags & TRIG_PUSHARC && self.movetarget) {
			dist = vlen((self.movetarget.origin - self.bmodel_act.origin));
			if (dist > self.tetherrange) self.bmodel_act.arcing = TRUE;
			if (dist < self.tetherdist) self.bmodel_act.arcing = FALSE;
			if (!self.bmodel_act.arcing) return;

			zdiff = self.movetarget.origin_z - self.bmodel_act.origin_z;
			self.finalangle = self.movetarget.origin;
			if (zdiff > 0) self.finalangle_z = self.finalangle_z + zdiff * 6.66 + 64;
			self.movedir = normalize(self.finalangle - self.bmodel_act.origin);
			spdattn = 10;
			if (dist < 128) spdattn = dist / 128 * 10;
			spdattn = SUB_ClampFloat(spdattn,25,spdattn);
			self.bmodel_act.velocity = self.movedir * self.speed * spdattn;
		} else {
			if (self.spawnflags & TRIG_PUSHADDITIVE) { // Additive velocity rather than forcing the entity to a velocity.
				self.attack_finished = time + 0.1;
				self.bmodel_act.velocity = self.bmodel_act.velocity + (self.speed * self.movedir * 10);
			} else self.bmodel_act.velocity = self.speed * self.movedir * 10;
			if (self.bmodel_act.flags & FL_CLIENT) {
				if (self.bmodel_act.fly_sound < time) {
					self.bmodel_act.fly_sound = time + 1.5;
					sound (self.bmodel_act, CHAN_AUTO, self.noise, self.volume, ATTN_NORM); // Play wind sound for the player
				}
			}
		}
	}
	
	// Setup to trigger push once?
	if (self.wait < 0) {
		self.attack_finished = LARGE_TIMER;
		self.estate_off();
	}
};

void() trigger_push_touch = { self.bmodel_act = other; trigger_push_fire(); } // [FUNCTION], Map hack reference

// QUAKED trigger_push (0.5 0 0.5) ? PUSH_ONCE SILENT NOMONSTER x x x STARTOFF x Not_Easy Not_Normal Not_Hard Not_DM
// -------- KEYS --------
// targetname : trigger entity (works with entity state system)
// target : target entity for custom direction
// angle  : direction of push (-2 is down, -1 up)
// angles : Pitch Yaw Roll (up/down, angle, tilt left/right)
// speed  : Speed of push direction (def=1000)
// -------- SPAWNFLAGS --------
// PUSH_ONCE : trigger_once functionality
// SILENT    : No wind sound for player
// NOMONSTER : Monsters cannot be pushed by this trigger
// STARTOFF  : Starts off and waits for trigger
// -------- NOTES --------
// Push the Player, player/ogre grenades and minion eggs!
// This entity cannot be damaged and is always touchable once activated
void() trigger_push = { // [ENTITY]
	if (check_bmodel_keys()) return;	// Check for bmodel errors

	self.classtype = CT_TRIGPUSH;
	self.classgroup = CG_TRIGGERS;
	InitTrigger();
	if (!self.speed) self.speed = 1000;
	self.spawnflags = self.spawnflags | TRIG_ALWAYTOUCH | TRIG_NODAMAGE; // Spawnflag 1 is used for something else (notouch duplicate).  No trigger damage functionality and always touchable!
	if ( !(self.spawnflags & TRIG_PUSHSILENT) && self.noise == "") self.noise = "ambience/windfly.wav"; // Setup default wind sound if no custom sound found...
	if (self.noise == "") self.noise = SOUND_EMPTY; // ...else if silent trigger, use misc/null.wav blank sound.
	precache_sound (self.noise);
	if (self.spawnflags & TRIG_PUSHARC) {
		if (self.tetherrange <= 0) self.tetherrange = 512;
		if (self.tetherdist <= 0) self.tetherdist = 32;
		if (self.tetherdist > self.tetherrange) self.tetherrange = self.tetherdist + 1;
	}
	SUB_BoundVolume(1);
	if (self.spawnflags & TRIG_PUSHONCE) self.wait = -1;
	self.estate_fire = trigger_push_fire; // Setup Entity State functionality
	self.touch = trigger_bmodel_anytouch;
	trigger_bmodel_setup();
};

void() trigger_ladder_fire = { // [FUNCTION]
	local vector vel;
	float fvel, srv_upspeed, ladpos, ladspd;

	if (self.estate & ESTATE_BLOCK) return;
	if ( !(self.bmodel_act.flags & FL_CLIENT) ) return; // Ladders ONLY work with players.
	if ( self.bmodel_act.health < 1 ) return;
	if (self.bmodel_act.waterlevel > 1) return; // Don't stick underwater, or in the middle of a waterjump
	if (self.bmodel_act.flags & FL_WATERJUMP) return;
	if (self.bmodel_act.blockladder > time) return; // Is Ladder functionality blocked? (timer set in client)

	self.bmodel_act.entladder = self; // Keep track of ladder trigger for sound fx
	// Velocity Ladder code was originally by Frank Condello (extra4 mod)
	// Modified by Redfield and then streamlined and bugfixed by me (simonoc)
	// Fixed - Unstuck issues and top of ladder bumping the player off
	// Added - Jump ability to exit ladder anytime and footstep sound fx
	// Added - Ability to override any of the parameters for the system
	//
	// Update the client with code in PlayerPreThink.client.qc
	// Setup which ladder system is active and link back
	if (self.spawnflags & TRIG_LADDERVELOCITY) {
		makevectors (self.bmodel_act.angles);
		if ( (v_forward*self.movedir)< -0.5 ) return; // Compare ladder facing angle (180 degree freedom)

		ladpos = self.bmodel_act.origin_z + self.bmodel_act.mins_z; // Player feet position
		if (ladpos > self.absmax_z-self.lip) return; // Check if player is standing on top of the ladder
			
		self.bmodel_act.onladder = LADDER_VEL; // Allow jump to exit ladder trigger
		self.bmodel_act.velocity_z = 0; // Stop all vertical movement
		if (v_right*self.bmodel_act.velocity > self.pos2_x) { self.bmodel_act.velocity = v_right*self.pos1_x; return; } // Check for strafing on ladder (initial vel def=25, speed org=0.5)
		if (v_right*self.bmodel_act.velocity < -self.pos2_x) { self.bmodel_act.velocity = -v_right*self.pos1_x; return; } // Check for strafing on ladder (initial vel def=25, speed org=0.5)

		fvel = v_forward * self.bmodel_act.velocity; // Get the player's forward speed
		vel = '0 0 0'; // Our new velocity
		if (self.bmodel_act.v_angle_x <= self.pos2_y && fvel>0 ) { // Up (facing up/forward, angle def=15)
			self.bmodel_act.flags = self.bmodel_act.flags - (self.bmodel_act.flags & FL_ONGROUND); // Cannot go upward if onground flag active, engine would override z velocity.
			vel_z = fabs(self.bmodel_act.v_angle_x)*self.pos1_y; // Go faster when facing up (speed def=6)
			if (vel_z < self.pos2_z) vel_z = self.pos2_z; // Minimum velocity (only facing up, def vel=90)
		} else if ( self.bmodel_act.v_angle_x >= self.pos2_y && fvel<0 ) { // Up (facing down, angle def=15)
			self.bmodel_act.flags = self.bmodel_act.flags - (self.bmodel_act.flags & FL_ONGROUND); // Cannot go upward if onground flag active
			vel_z = self.bmodel_act.v_angle_x*self.pos1_z; // Go slower when facing down (speed def=4)
		} else if (self.bmodel_act.v_angle_x <= self.pos2_y && fvel<0 ) { // Down (facing up/forward, angle def=15)
			vel = vel + self.movedir*self.distance; // Push the player TOWARDS the ladder to stop falling off
			vel_z = fabs(self.bmodel_act.v_angle_x)*-self.pos1_y; // Go faster when facing up (speed was org=-5, changed to -6)
			if (vel_z > -self.pos2_z) vel_z = -self.pos2_z; // Minimum velocity (only facing up, org vel=-80)
		} else if ( self.bmodel_act.v_angle_x >= self.pos2_y && fvel>0 ) { // Down (facing down, angle def=15)		
			vel = vel - self.movedir*self.distance; // Push the player TOWARDS the ladder to stop falling off
			vel_z = self.bmodel_act.v_angle_x*-self.pos1_z; // Go slower when facing down (speed def=-4)
		} else {
			if (vel_z < self.height) vel_z = self.height; // Minimum velocity
		}

		srv_upspeed = cvar("cl_upspeed"); // Cap vertical movement to the server limits
		if (vel_z > srv_upspeed) vel_z = srv_upspeed; // Check for upper limit
		else if (vel_z < -1*srv_upspeed) vel_z = -1*srv_upspeed; // Check for lower limit using -1 reversal technique

		self.bmodel_act.velocity = vel; // Replace player velocity
		ladpos = self.bmodel_act.origin_z + self.bmodel_act.maxs_z + 8; // Is the player at the bottom or top of the ladder bmodel? reset distance travelled to prevent sound loop.
		if (ladpos >= self.absmax_z) self.bmodel_act.distladder = 0;
		ladpos = (self.bmodel_act.origin_z + self.bmodel_act.mins_z) - 8;
		if (ladpos <= self.absmin_z) self.bmodel_act.distladder = 0;
		ladspd = vlen(self.bmodel_act.origin - self.bmodel_act.orgladder); // Work out distance travelled (vlen) on ladder
		self.bmodel_act.distladder = self.bmodel_act.distladder + ladspd;
		if (self.bmodel_act.distladder > self.yaw_speed) { // Is it time to play a ladder sound?
			Client_LadderSounds(self.bmodel_act); // Play sound and reset counter
			self.bmodel_act.distladder = 0;
		}
		self.bmodel_act.orgladder = self.bmodel_act.origin; // Save new origin for next ladder cycle
	} else self.bmodel_act.onladder = LADDER_JUMP; // Default = ladder jump (to climb) system
};

// Player ladder (originally from Rubicon2 codebase by JohnFitz)
// - This is a very simple system, jump to attach to the ladder brush
// - move up down via jumpping (hook in preplayer code)
// - Added multiple climbing sounds (works with player footsound state)
// - Modified to have on/off/toggle state via triggers
// - Downsides to system, there is no abilty to go down a ladder

// Added two other ladder systems
// * VELOCITY is from extra4 mod and work similar to Quoth mod
// - Push forward to move up, sideways to strafe and down to climb down
// * FTESKIN is hardcoded into FTE/QSS engines
// - Works very similar to velocity system, push forward to climb
// QUAKED trigger_ladder (.5 .5 .5) ? x x VELOCITY FTESKIN x x STARTOFF x Not_Easy Not_Normal Not_Hard Not_DM
// -------- KEYS --------
// targetname : trigger entity (works with entity state system)
// angle      : direction player must be facing to climb ladder (required)
// waitmin    : time between climb sound (def = depends on sound type)
// speed      : velocity speed to climb ladder (def=160)
// sounds     : 1=metal, 2=wood, 3=rope, 4=silent, 5=custom (def=wood)
// noise1-4   : custom sounds to play when climbing ladder
// yaw_speed  : VELOCITY only - Movement distance for sound trigger
// distance   : VELOCITY only - Amount of velocity to push towards ladder (stickyness)
// lip        : VELOCITY only - Change the step amount at the top of the ladder
// height     : VELOCITY only - Default velocity upward if not doing anything on ladder
// pos1       : VELOCITY only - Speed adjustment for X=strafe, Y=up and Z=down movement
// pos2       : VELOCITY only - X=Strafe velocity, Y=Up/Down angle, Z=MIN velocity for up/down
// -------- SPAWNFLAGS --------
// VELOCITY : Will use the VELOCITY ladder system instead
// FTESKIN  : Will use the FTE/SKIN ladder system instead
// STARTOFF : Starts off and waits for trigger
// -------- NOTES --------
// Invisible brush based ladder
// This entity cannot be damaged and is always touchable once activated
void() trigger_ladder = { // [ENTITY]
	if (check_bmodel_keys()) return;	// Check for bmodel errors

	self.classtype = CT_TRIGLADDER;
	self.classgroup = CG_TRIGGERS;
	InitTrigger ();
	if (developer > 0) { // Show facing angle
		self.oldorigin = bmodel_origin(self) - (self.movedir*40); // Move origin back away from ladder
		self.finalangle = vectoangles(self.movedir); // Convert movedir back into an angle
		spawn_arrow(self.oldorigin, self.finalangle, 0); // Show debug arrow
	}

	// Default = wood
	if (!self.sounds) self.sounds = 2;
	if (self.sounds == 1) {				// Metal
		if(!self.waitmin) self.waitmin = 0.45;
		if (self.noise1 == "") self.noise1 = "ad171/player/ladmetal1.wav";
		if (self.noise2 == "") self.noise2 = "ad171/player/ladmetal2.wav";
		if (self.noise3 == "") self.noise3 = "ad171/player/ladmetal3.wav";
		if (self.noise4 == "") self.noise4 = "ad171/player/ladmetal4.wav";
	} else if (self.sounds == 2) {		// Wood
		if(!self.waitmin) self.waitmin = 0.4;
		if (self.noise1 == "") self.noise1 = "ad171/player/ladwood1.wav";
		if (self.noise2 == "") self.noise2 = "ad171/player/ladwood2.wav";
		if (self.noise3 == "") self.noise3 = "ad171/player/ladwood3.wav";
		if (self.noise4 == "") self.noise4 = "ad171/player/ladwood4.wav";
	} else if (self.sounds == 3) {		// Old Rope
		if(!self.waitmin) self.waitmin = 0.7;
		if (self.noise1 == "") self.noise1 = "ad171/player/ladrope1.wav";
		if (self.noise2 == "") self.noise2 = "ad171/player/ladrope2.wav";
		if (self.noise3 == "") self.noise3 = "ad171/player/ladrope3.wav";
		if (self.noise4 == "") self.noise4 = "ad171/player/ladrope4.wav";
	} else {
		// Custom or empty
		if (!self.waitmin) self.waitmin = 0.5;
		if (self.noise1 == "") self.noise1 = SOUND_EMPTY;
		if (self.noise2 == "") self.noise2 = SOUND_EMPTY;
		if (self.noise3 == "") self.noise3 = SOUND_EMPTY;
		if (self.noise4 == "") self.noise4 = SOUND_EMPTY;
	}
	precache_sound(self.noise1);
	precache_sound(self.noise2);
	precache_sound(self.noise3);
	precache_sound(self.noise4);
	SUB_BoundVolume(1);
	if (self.speed <= 0) self.speed = 160; // Velocity reset for upward movement (AD jump ladder system)
	self.spawnflags = self.spawnflags | TRIG_ALWAYTOUCH | TRIG_NODAMAGE; // No trigger damage functionality and always touchable!
	self.spawnflags = self.spawnflags - (self.spawnflags & TRIG_MONSTERS); // Cannot have ladder triggers touched by monsters
	if (self.spawnflags & TRIG_LADDERVELOCITY) { // Check for new velocity ladder system
		if (self.yaw_speed <= 0) self.yaw_speed = 60; // Movement distance for sound trigger
		if (self.distance <= 0) self.distance = 0.35; // Amount of velocity to push towards ladder (stickyness)
		if (self.lip <= 0) self.lip = 8; // Change the step amount at the top of the ladder
		if (self.height <= 0) self.height = 11.2; // Default velocity upward if not doing anything on ladder
		if (CheckZeroVector(self.pos1)) self.pos1 = '2.5 6 4'; // Speed adjustment for X=strafe, Y=up and Z=down movement
		if (CheckZeroVector(self.pos2)) self.pos2 = '25 15 90'; // X=Strafe velocity, Y=Up/Down angle, Z=MIN velocity for up/down
		self.spawnflags = self.spawnflags - (self.spawnflags & TRIG_LADDERFTESKIN); // Can't have both velocity + fteskin systems active once
	} else if (self.spawnflags & TRIG_LADDERFTESKIN) { // Enable FTE Skin/Ladder system (reqs FTE engine)
		self.spawnflags = self.spawnflags - (self.spawnflags & TRIG_LADDERVELOCITY);
		self.skin = -16;
	}

	self.estate_fire = trigger_ladder_fire; // Setup Entity State functionality
	trigger_bmodel_setup();
};

void() player_fallspeed_reset = { // [FUNCTION]
	map_jumpheight = DEF_JUMPHEIGHT;
	map_fallspeedlow = DEF_FALLSPEEDLOW;
	map_fallspeedhigh = DEF_FALLSPEEDHIGH;
	map_falldmg = DEF_FALLDMG;
	map_falldmgwater = DEF_FALLDMGWATER;
	map_fallspeeddebug = FALSE;
};

void() player_fallspeed_setup = { // [FUNCTION]
	if (self.jump_height > 0) map_jumpheight = self.jump_height; // Check for any custom player jump height settings
	
	// Low speed cannot be positive
	if (self.fall_speedlow > 0)
		dprint("\b[WORLD]\b LOW Player Fall Speed must be negative\n");
	// Check for any custom fall damage for the player
	else if (self.fall_speedlow < 0) map_fallspeedlow = self.fall_speedlow;

	// High speed cannot be positive
	if (self.fall_speedhigh > 0)
		dprint("\b[WORLD]\b HIGH Player Fall Speed must be negative\n");
	// Check for any custom fall damage for the player
	else if (self.fall_speedhigh < 0) {
		// Check high value is less than low value (both are negative no's)
		if (self.fall_speedhigh < self.fall_speedlow) 
			map_fallspeedhigh = self.fall_speedhigh;
		else 
			dprint("\b[WORLD]\b Player Fall Speed HIGH must be less than LOW\n");
	}
	
	// Allow for zero fall damage, use negative values
	if (self.fall_dmg < 0) map_falldmg = 0;
	else if (self.fall_dmg > 0) map_falldmg = self.fall_dmg;

	// Allow for damage when falling into water bodies
	if (self.fall_dmgwater < 0) map_falldmgwater = 0;
	else if (self.fall_dmgwater > 0) map_falldmgwater = self.fall_dmgwater;

	if (self.fall_speeddebug < 0) map_fallspeeddebug = 0; 
	else if (self.fall_speeddebug > 0) map_fallspeeddebug = TRUE; // Enable player velocity debug mode (developer = 1 required)
};

void() trigger_fallspeed_fire = { // [FUNCTION]
	if (self.estate & ESTATE_BLOCK) return; // Is the trigger turned off or disabled?
	if (self.attack_finished > time) return; // Is the trigger blocked? (trigger_once)

	player_fallspeed_setup(); // All value checks are done in function.  Updates all map values directly.

	// Check for any trigger events (noise/delay etc)
	// Play the sound ON the activator and display message
	if (self.message != "" && activator.flags & FL_CLIENT) centerprint (activator, self.message);
	if (self.noise != "") sound (activator, CHAN_VOICE, self.noise, self.volume, ATTN_NORM);
	if (HasTargets(self)) SUB_UseTargets(); 
	
	// Is the trigger repeatable?
	if (self.wait < 0) {
		self.attack_finished = LARGE_TIMER; // block trigger and turn off (trigger_once)
		self.estate_off();
	} else self.attack_finished = time + self.wait; // Delay trigger event
};

// QUAKED trigger_fallspeed (.5 .5 .5) ? NOTOUCH x x x x x STARTOFF x Not_Easy Not_Normal Not_Hard Not_DM
// ------- KEYS --------
// targetname     : trigger entity (works with entity state system)
// target         : trigger all these targets when activated
// jump_height    : The player jump height (def=270) initial boast from standing still
// fall_speedlow  : Fall Speed for any checks (def=-300) must be negative no.
// fall_speedhigh : Fall Speed for damage check (def=-650) must be negative no.
// fall_speeddebug: Display players fall velocity to console (1=ON, -1=OFF)
// fall_dmg       : Fall damage for player (def=5, -1=no dmg/sound)
// fall_dmgwater  : Fall damage into water (>0 for dmg/sound, -1=no dmg/sound)
// wait           : -1=will only fire targets once (switches off)
// sounds         : 1=Secret,2=talk,3=switch,4=silent,6=secret2
// noise          : custom sound to play when triggered
// message        : message to display when triggered
// -------- SPAWNFLAGS --------
// NOTOUCH  : can only be triggered via other entities
// STARTOFF : Requires trigger to activate
// ------- NOTES --------
// Change the player velocity speed checks for fall damage
void() trigger_fallspeed = { // [ENTITY]
	if (check_bmodel_keys()) return;	// Check for bmodel errors
	if (check_bmodel_notouch()) return;	// NO touch + NO targetname!

	trigger_bmodel_sounds();			// Precache any sounds
	self.classtype = CR_TRIGFALLSPEED;
	self.classgroup = CG_TRIGGERS;
	InitTrigger ();
	if (self.targetname != "") self.use = entity_state_use; // Setup Entity State functionality
	self.estate_fire = trigger_fallspeed_fire;
	trigger_bmodel_setup();
};

void() trigger_maxhp_fire = { // [FUNCTION]
	local entity playent;
	
	if (self.estate & ESTATE_BLOCK) return; // Is the trigger turned off or disabled?
	if (self.attack_finished > time) return; // Is the trigger blocked? (trigger_once)

	self.waitmin = FALSE; // Only trigger if skill levels match
	playent = find(world, classname, "player"); // Find first client
	while (playent) {
		// 1 = EASY, 2 = NORMAL, 4 = HARD, 8 = NIGHTMARE, 15 = ALL
		if ((self.count & HP_EASY && skill == SKILL_EASY) || (self.count & HP_NORMAL && skill == SKILL_NORMAL) || (self.count & HP_HARD && skill == SKILL_HARD) || (self.count & HP_NIGHTMARE && skill >= SKILL_NIGHTMARE)) {
			self.waitmin = TRUE; // Skill level
			if (self.max_health > 0) playent.max_health = self.max_health; // Double check max is not negative or zero
			if (self.mega_health > 0) playent.mega_health = self.mega_health;

			// Cap health with new/current maximum
			if (playent.health > playent.max_health) {
				T_Damage(playent, world, world, 1, NOARMOR); // Tiny damage to trigger client animation/sound
				playent.health = playent.max_health;
			}
		}
		playent = find(playent, classname, "player"); // Find more (coop) player/clients
	}	

	if (self.waitmin == FALSE) return; // No skill condition found, exit

	if (self.message != "" && activator.flags & FL_CLIENT) centerprint (activator, self.message); // Check for any trigger events (noise/delay etc)
	if (self.noise != "") sound (activator, CHAN_VOICE, self.noise, self.volume, ATTN_NORM); // Play the sound ON the activator and display message
	if (HasTargets(self)) SUB_UseTargets();
	
	// Is the trigger repeatable?
	if (self.wait < 0) {
		self.attack_finished = LARGE_TIMER; // block trigger and turn off (trigger_once)
		self.estate_off();
	} else self.attack_finished = time + self.wait; // Delay trigger event
};

// QUAKED trigger_maxhp (.5 .5 .5) ? NOTOUCH x x x x x STARTOFF x Not_Easy Not_Normal Not_Hard Not_DM
// ------- KEYS --------
// targetname  : trigger entity (works with entity state system)
// target      : trigger all targets when activated
// max_health  : Maximum Health for ALL the player / client
// mega_health : Maximum Health for picking up the mega health item
// count       : Skill level (0=ALL, 1=EASY, 2=NORMAL, 4=HARD, 8=NM, 15=ALL)
// wait        : -1=will only fire targets once (switches off)
// sounds      : 1=Secret,2=talk,3=switch,4=silent,6=secret2
// noise       : custom sound to play when triggered
// message     : message to display when triggered
// -------- SPAWNFLAGS --------
// NOTOUCH  : can only be triggered via other entities
// STARTOFF : Requires trigger to activate
// ------- NOTES --------
// Change the player maximum hp and maximum mega values
void() trigger_maxhp = { // [ENTITY]
	if (check_bmodel_keys()) return;	// Check for bmodel errors
	if (check_bmodel_notouch()) return;	// NO touch + NO targetname!

	trigger_bmodel_sounds();			// Precache any sounds
	self.classtype = CR_TRIGMAXHP;
	self.classgroup = CG_TRIGGERS;
	InitTrigger ();
	if (self.max_health <= 0) self.max_health = 0;
	if (self.mega_health <= 0) self.mega_health = 0;
	if (self.count <= 0) self.count = 15;
	self.spawnflags = self.spawnflags | TRIG_NODAMAGE; // This trigger cannot be damaged (no health checks)
	if (self.targetname != "") self.use = entity_state_use; // Setup Entity State functionality
	self.estate_fire = trigger_maxhp_fire;
	trigger_bmodel_setup();
};

float(entity gcheck) trigger_gravity_exceptions = { // [FUNCTION]
	if (self.spawnflags & TRIG_GRAVITYMONONLY && !(gcheck.flags & FL_MONSTER)) return FALSE; // Is the gravity touch entity a monster?
	if (self.spawnflags & TRIG_GRAVITYPLAYONLY && !(gcheck.flags & FL_CLIENT)) return FALSE; // Is the gravity touch entity a player?
	return TRUE; // Carry on with logic
};

void() trigger_gravity_fire = { // [FUNCTION]
	local entity ent_list;

	if (self.estate & ESTATE_BLOCK) return; // Is the trigger turned off or disabled?
	if (other == self.owner) return; // Exclude owner and/or triggers
	if (other.solid == SOLID_TRIGGER) return;
	if (self.attack_finished > time) return; // Is the trigger blocked? (trigger_once)
	if (other.classtype == CT_WORLD) return; // Cannot set gravity on the world (its readonly and will crash)
	
	self.lip = FALSE; // Keep track of trigger firing
	if (self.spawnflags & TRIG_GRAVITYSERVER) { // Check for any world/map gravity change first
		self.height = cvar("sv_gravity"); // Find out the current gravity setting
		if (self.height != self.count) { // Check if gravity is different? (Stop constant trigger spam)
			// Work through exceptions first
			if (trigger_gravity_exceptions(other)) {
				// all CVAR_SERVERINFO console commands are reported to all clients as a way to prevent admin cheating!!!
				// There is no way to turn this off or make it silent :(  The engine code is quite explicit about what it does:
				// SV_BroadcastPrintf (""%s" changed to "%s"\n", var->name, var->string);
				// Reporting this to the console is fine, but printing it at the top of the main screen is just lame!
				// So I have a hack ...
				// Issue 4 line feeds after the cvar command! :P
				// This will clear the main screen buffer (usually 4 lines)
				// and keep the message only on the console (for reference)
				cvar_set("sv_gravity", ftos(self.count));
				if (other.flags & FL_CLIENT) sprint(other, "\n\n\n\n\n"); // Find the client to stuff the line feeds
				else if (client_ent.flags & FL_CLIENT) sprint(client_ent, "\n\n\n\n\n"); // Not every trigger will be the client, find another
				
				map_gravity = self.count; // Update globally stored gravity setting
				self.lip = TRUE; // Gravity changed (test for target/sound)
			}
		}
	} else { // Entity gravity
		if (self.target != "") { // Check for multiple targets? Only check target, special use for target2.
			ent_list = find(world, targetname, self.target); // Build initial list from world
			// Cycle through list
			while(ent_list) {
				// Work through exceptions first.
				if (trigger_gravity_exceptions(ent_list)) {
					if (ent_list.flags & FL_CLIENT) { // Found player?
						if (ent_list.onladder) ent_list.oldgravity = self.count; // Are they on a ladder? - store gravity for later.
						else ent_list.oldgravity = ent_list.gravity = self.count; // Update gravity and backup version.
					} else ent_list.gravity = self.count; // Reset entity gravity key
				
					self.lip = TRUE; // Gravity changed (test for target/sound)
				}
				ent_list = find(ent_list, targetname, self.target); // Find next ent from intial list (not world)
			}
		} else { // One target (other)
			// Work through exceptions first
			if (trigger_gravity_exceptions(other)) {
				// Does entity gravity need to change?
				if (other.gravity != self.count) {
					if (!self.nodebuginfo) {
						dprint("Entity ("); dprint(other.classname);
						dprint(") Grav Old ("); dprint(ftos(other.gravity));
					}
					
					// Found player?
					if (other.flags & FL_CLIENT) {
						if (other.onladder) other.oldgravity = self.count; // Are they on a ladder? - store gravity for later
						else other.oldgravity = other.gravity = self.count; // Update gravity and backup version
					} else other.gravity = self.count; // Reset entity gravity key

					if (!self.nodebuginfo) {
						dprint(") = New ("); dprint(ftos(other.gravity));
						dprint(")\n");
					}

					self.lip = TRUE; // Gravity changed (test for target/sound)
				}
			}
		}
	}
	
	// Only fire target2/noise2 if gravity changes
	if (self.lip) {
		// Check for any trigger events and re-trigger timer
		if (self.target2 != "" && self.pain_finished < time) {
			self.pain_finished = time + self.waitmin2;
			trigger_strs(self.target2, other);
		}	
		
		// Check for any sound events and re-trigger timer
		if (self.noise2 != "" && self.lefty < time) {
			self.lefty = time + self.waitmin;
			sound (activator, CHAN_VOICE, self.noise2, 1, ATTN_NORM);
		}
	}
	
	// Is the trigger repeatable?
	if (self.wait < 0) {
		self.attack_finished = LARGE_TIMER; // block trigger and turn off (trigger_once)
		self.estate_off();
	}
};

// QUAKED trigger_gravity (.5 .5 .5) ? NOTOUCH SERVER PLAYER MONSTER RESET x STARTOFF x Not_Easy Not_Normal Not_Hard Not_DM
// ------- KEYS --------
// targetname : trigger entity (works with entity state system)
// target   : Group of entities to affect with gravity update
// target2  : fire event(s) everytime gravity is changed
// waitmin2 : Minimum time between re-triggering fire events
// noise2   : Sound to play everytime gravity is changed
// waitmin  : Minimum time between re-triggering sound
// count    : Gravity value (server=0-1000 (def=800) entity=0-1, can be negative)
// wait     : (def) -1 = will only fire targets once
// -------- SPAWNFLAGS --------
// NOTOUCH  : can only be triggered via other entities
// SERVER   : Changes server gravity instead of entity gravity
// PLAYER   : Player(s) only can touch this trigger
// MONSTER  : Monster(s) only can touch this trigger
// RESET    : Reset any entity to default gravity (does not affect server)
// STARTOFF : Requires trigger to activate
// ------- NOTES --------
// Change entity/entities/player or server (world) gravity
void() trigger_gravity = { // [ENTITY]
	if (check_bmodel_keys()) return;	// Check for bmodel errors
	if (check_bmodel_notouch()) return;	// NO touch + NO targetname!
	
	self.classtype = CT_TRIGGRAVITY;
	self.classgroup = CG_TRIGGERS;
	InitTrigger ();
	if (self.noise2 != "") precache_sound(self.noise2); // Check for any sound wav file cache
	self.lefty = self.pain_finished = self.attack_finished = 0; // Reset all re-trigger timers (noise2/target2/wait once)

	if (self.gravity != 0 && !self.count) self.count = self.gravity; // Support hipnotic trigger_setgravity redirects.

	// Setup entity only reset option.  This exists because if an entity has the gravity key set it will override the server gravity.
	if (self.spawnflags & TRIG_GRAVITYRESET) {
		self.spawnflags = self.spawnflags - (self.spawnflags & TRIG_GRAVITYSERVER); // Remove any server spawnflag, this is entity only
		self.count = 1; // Default entity gravity is always 1.
	}
	
	// This trigger can work fine with any monsters and does support special trigger events via spawnflags for them (monsters)
	// Only exception is player only triggers
	if (self.spawnflags & TRIG_GRAVITYPLAYONLY) self.spawnflags = self.spawnflags - (self.spawnflags & TRIG_MONSTERS);
	else self.spawnflags = self.spawnflags | TRIG_MONSTERS; // Default is to let trigger work with monsters
	
	if (self.targetname != "") self.use = entity_state_use; // Setup Entity State functionality
	self.estate_fire = trigger_gravity_fire;
	trigger_bmodel_setup();
};

void() trigger_velocity_affected = { // [FUNCTION]
	self.state = FALSE;
	if (self.spawnflags & TRIG_VELPLAYER && self.bmodel_act.flags & FL_CLIENT) self.state = TRUE;
	if (self.spawnflags & TRIG_VELMONSTER && self.bmodel_act.flags & FL_MONSTER) self.state = TRUE;
	if (self.spawnflags & TRIG_VELGRENADE && self.bmodel_act.classgroup == CG_PROJGRENADES) self.state = TRUE;
	if (self.spawnflags & TRIG_VELROCKET && self.bmodel_act.classgroup == CG_PROJROCKETS) self.state = TRUE;
};

// Try to find client; other, owner or client_ent.  Centerprint messages require a client
void(string msg) trigger_velocity_msgprint = { // [FUNCTION]
	self.enemy = world;
	
	if (self.bmodel_act.flags & FL_CLIENT) self.enemy = self.bmodel_act; 
	else if (self.bmodel_act.owner.flags & FL_CLIENT) self.enemy = self.bmodel_act.owner;
	else self.enemy = client_ent;
	
	if (!self.enemy) dprint("\b[TRIG_VEL]\b No client for centerprint!"); // Got a client? show message to all clients
	else centerprint(self.enemy,msg);
};

void() trigger_velocity_fire = { // [FUNCTION]
	if (self.estate & ESTATE_BLOCK) return;
	if (self.attack_finished > time) return;
	
	// Check spawnflag exceptions; player/monster/grenade/rocket
	// All the exceptions need to be checked together (OR logic)
	// They can fine tune exactly what the trigger will work with
	if (self.spawnflags & TRIG_VELEXCEPTION) {
		trigger_velocity_affected(); // Sets self.state
		if (!self.state) {
			// touch triggers can re-trigger a lot, need to throttle response
			if (self.pain_finished < time) {
				self.pain_finished = time + self.waitmin2;
				if (self.message2 != "") trigger_velocity_msgprint(self.message2);
				if (self.target2 != "") trigger_strs(self.target2, self.bmodel_act); // Fire targets if exceptions have failed.  This is after bmodel _use, _killed and _touch, so any reference to the trigger activator has to go through 'bmodel_act'
			}	
			return; // Exceptions failed
		}
	}

	TargetMovedir(self, FALSE); // Check for any target entity tracking
	
	// Did the trigger have an angle key setup?
	if (CheckZeroVector(self.movedir) == FALSE) {
		self.pos4 = vectoangles(self.bmodel_act.velocity); // Work out projectile angle using velocity
		makevectors (self.pos4);
		self.pos5 = v_forward; // Save v_forward (directional vector) for later
		self.pos6 = vectoangles(self.movedir); // Work out trigger brush angle using movedir (angle)
		makevectors (self.pos6);
		
		// Spawn debug vector angle markers (throttle to 0.5s intervals)
		if (self.attack_timer < time) {
			self.attack_timer = time + 0.5;
			spawn_arrow(self.bmodel_act.origin, self.pos4, 0);
			spawn_arrow(self.bmodel_act.origin, self.pos6, 4);
		}

		self.lip = v_forward * self.pos5; // Dot product (cos) between angle vectors.  Use the same logic from the AI infront function.  1= perfect angle, 0 or less = 90+ angle difference
		if (self.lip < self.ideal_yaw) return; // Default angle tolerance is 0.3 (ideal_yaw entity key).  This is about 60 degree's either side of trigger angle.
	}

	self.pos1 = self.bmodel_act.origin;
	self.pos2 = self.bmodel_act.velocity; // Find out entity speed
	self.pos3 = self.pos1 + self.pos2; // Add velocity to origin to create future position
	self.t_length = vlen(self.pos3 - self.pos1); // Use vector length function to calc distance
	
	// Check velocity/speed and fire targets
	if (self.t_length > self.speed) {
		if (self.message != "") trigger_velocity_msgprint(self.message);
		if (self.target != "") trigger_strs(self.target, self.bmodel_act); // Fire target(s) if trigger successful.  Special setup, no extra targets checked.

		// Grenades will keep bouncing after hitting the trigger.  Allow mappers to override this behaviour (entity key)
		if (self.spawnflags & TRIG_VELGRENADE && self.bmodel_act.classgroup == CG_PROJGRENADES && self.dmg_take) {
			self.bmodel_act.think = self.bmodel_act.th_die; // Make any grenades explode on contact (no bounce)
			self.bmodel_act.nextthink = time;
		}
		
		// Setup trigger to only work once?
		if (self.wait < 0) {
			self.attack_finished = LARGE_TIMER;
			self.estate_off();
		} else self.attack_finished = time + self.waitmin; // Slow down re-trigger events
	}
};

void() trigger_velocity_setup = { // [FUNCTION]
	self.estate_fire = trigger_velocity_fire; // Setup Entity State functionality
	self.touch = trigger_bmodel_anytouch; // No extra conditions on the touch function
	self.delay = 0;	// Reset delay variable
	trigger_bmodel_setup();
};

// QUAKED trigger_velocity (0.5 0 0.5) ? PLAYER MONSTER GRENADE ROCKET x x STARTOFF x Not_Easy Not_Normal Not_Hard Not_DM
// -------- KEYS --------
// targetname : trigger entity (works with entity state system)
// target    : fire event(s) everytime trigger conditions successful
// target2   : fire event(s) everytime trigger exceptions fail
// angle     : Facing Direction for trigger to work, use "360" for angle 0
// ideal_yaw : Facing angle sensitivity (def=0.3, range = 0 - 1)
// speed     : Minimum velocity speed to trigger (def=500)
// waitmin   : (def=1s) Time between target/message working again
// waitmin2  : (def=1s) Time between target2/message2 working again
// wait      : -1 = Only fire the trigger functionality once
// delay     : -1 = No spawn delay, 0 (def=1s), +0 = spawn delay
// message   : display message everytime trigger conditions successful
// message2  : display message everytime trigger exceptions fail
// dmg_take  : Grenades will explode on impact of this trigger
// -------- SPAWNFLAGS --------
// PLAYER    : Player only trigger
// MONSTER   : Monster only trigger
// GRENADE   : Grenade projectile only trigger
// ROCKET    : Rocket projectile only trigger
// STARTOFF  : Starts off and waits for trigger
// -------- NOTES --------
// Check for projectile / player velocity!
// This entity cannot be damaged and is always touchable
void() trigger_velocity = { // [ENTITY]
	if (check_bmodel_keys()) return;	// Check for bmodel errors

	self.classtype = CT_TRIGVELOCITY;
	self.classgroup = CG_TRIGGERS;
	InitTrigger ();
	self.spawnflags = self.spawnflags | TRIG_ALWAYTOUCH | TRIG_NODAMAGE; // Spawnflag 1 is used for something else (notouch duplicate).  No trigger damage functionality and always touchable!
	if (self.waitmin <= 0) self.waitmin = 1;
	if (self.waitmin2 <= 0) self.waitmin2 = 1;
	if (!self.speed) self.speed = 500;
	if (self.ideal_yaw <= 0) self.ideal_yaw = 0.3;
	if (self.ideal_yaw > 1) self.ideal_yaw = 1;
	if (self.delay == 0) self.delay = 1;
	if (self.delay > 0) {
		self.think = trigger_velocity_setup;
		self.nextthink = time + self.delay; // This trigger is highly sensitive to touch functionality.  Delay spawn/setup so that everything else can settle.
	} else trigger_velocity_setup(); // Negative forces instant.
};

void() trigger_takeartifact_fire = { // [FUNCTION]
	local float inv_artifact;

	if (self.attack_finished > time) return; // Is the trigger blocked? (trigger_once)
	if (!(self.bmodel_act.flags & FL_CLIENT)) return; // Activator can only be the player
	if (self.bmodel_act.health < 1) return;
	
	inv_artifact = FALSE;

	// Turn off Suit/InvRing/Quad/Pentagram artifacts ONLY
	if (self.spawnflags & TRIG_TAKEARTID) {
		if ((self.bmodel_act.items & IT_INVISIBILITY) || (self.bmodel_act.items & IT_INVULNERABILITY) || (self.bmodel_act.items & IT_SUIT) || (self.bmodel_act.items & IT_QUAD)) {
			inv_artifact = TRUE;
			ResetPowerInvRing(self.bmodel_act, self.waitmin);
			ResetPowerPent(self.bmodel_act, self.waitmin);
			ResetPowerEnvSuit(self.bmodel_act, self.waitmin);
			ResetPowerQuad(self.bmodel_act, self.waitmin);
		}
	}

	// Turn off SharpShooter/Nail Piercer artifacts ONLY
	if (self.spawnflags & TRIG_TAKEARTAD) {
		if ((self.bmodel_act.moditems & IT_ARTSHARP) ||
			(self.bmodel_act.moditems & IT_ARTPIERCE)) {
			inv_artifact = TRUE;
			ResetPowerSharp(self.bmodel_act, self.waitmin);
			ResetPowerPiercer(self.bmodel_act, self.waitmin);
		}
	}

	// Turn off Lavashield/Airtank/Blastbelt/Jumpboots artifacts ONLY
	if (self.spawnflags & TRIG_TAKEARTVANIA) {
		if ((self.bmodel_act.moditems & IT_ARTLAVASHIELD) ||
			(self.bmodel_act.moditems & IT_ARTWETSUIT) ||
			(self.bmodel_act.moditems & IT_ARTBLASTBELT) ||
			(self.bmodel_act.moditems & IT_ARTJUMPBOOTS)) {
			inv_artifact = TRUE;
			ResetPowerLavaShield(self.bmodel_act, self.waitmin);
			ResetPowerAirTank(self.bmodel_act, self.waitmin);
			ResetPowerBlastbelt(self.bmodel_act, self.waitmin);
			ResetPowerJumpBoots(self.bmodel_act, self.waitmin);
		}
	}
	
	// Found any active artifacts?
	if (inv_artifact) {
		activator = self.bmodel_act; // Extra triggers (target/targe2), message + sound
		SUB_UseTargets();
		
		// Play the sound ON the activator
		if (self.distance < time && self.noise != "") {
			self.distance = time + self.waitmin3; // setup slow down timer
			sound (activator, CHAN_VOICE, self.noise, self.volume, ATTN_NORM);
		}

		// Setup trigger to only work once?
		if (self.wait < 0) {
			self.attack_finished = LARGE_TIMER;
			self.estate_off();
		} else self.attack_finished = time + self.waitmin2; // Slow down re-trigger timing
	}
};

// QUAKED trigger_takeartifact (0.5 0 0.5) ? NOTOUCH ID AD VANIA x x STARTOFF x Not_Easy Not_Normal Not_Hard Not_DM
// -------- KEYS --------
// targetname : trigger entity (works with entity state system)
// target   : trigger all these targets
// angle    : Facing Direction for trigger to work, use "360" for angle 0.
// sounds   : 1=Secret,2=talk,3=switch,4=silent(def),5=custom,6=secret2
// noise    : custom sound to play when triggered
// message  : message to display when triggered
// waitmin  : Override timer for powerup, anything below value is ignored (def=0)
// waitmin2 : Slow down timer for trigger working again (def=0.1s)
// waitmin3 : Slow down timer for sound playing (def=1s)
// wait     : -1 = trigger once functionality (def=0)
// -------- SPAWNFLAGS --------
// NOTOUCH  : can only be triggered via other entities
// ID       : Take only = Suit/InvRing/Quad/Pentagram
// AD       : Take only = SharpShooter/Nail Piercer
// VANIA    : Take only = Lavashield/Airtank/Blastbelt/Jumpboots
// STARTOFF : Requires trigger to activate
// -------- NOTES --------
// Variable sized bmodel used to take powerups from the player
void() trigger_takeartifact = { // [ENTITY]
	if (check_bmodel_keys()) return;	// Check for bmodel errors
	if (check_bmodel_notouch()) return;	// NO touch + NO targetname!
	
	self.classtype = CT_TRIGTAKEART;
	self.classgroup = CG_TRIGGERS;
	InitTrigger ();
	if (self.sounds <= 0) self.sounds = 4;	// Default = silence
	trigger_bmodel_sounds();				// Precache any sounds
	if (self.waitmin <= 0) self.waitmin = 0; // check power timeout is not negative
	if (self.waitmin2 < 0.1) self.waitmin2 = 0.1; // slowdown timer for re-triggering
	if (self.waitmin3 < 0.1) self.waitmin3 = 1; // slowdown timer for sounds
	if (!(self.spawnflags & TRIG_TAKEARTALL)) self.spawnflags = self.spawnflags | TRIG_TAKEARTALL; // Check for remove all functionality (default)
	self.spawnflags = self.spawnflags - (self.spawnflags & TRIG_MONSTERS); // Cannot have trigger touched by monsters
	self.spawnflags = self.spawnflags | TRIG_NODAMAGE; // No trigger damage functionality!
	self.estate_fire = trigger_takeartifact_fire; // Setup Entity State functionality
	trigger_bmodel_setup();
};

void() trigger_giveitem_fire = { // [FUNCTION]
	local entity stemp;

	if (self.attack_finished > time) return; // Is the trigger blocked? (trigger_once)
	if (!(self.bmodel_act.flags & FL_CLIENT)) return; // Activator can only be the player
	if (self.bmodel_act.health < 1) return;
	if (self.target == "") return;

	stemp = self; activator = self.bmodel_act; // Save for later and reset activator
	if (self.noise != "") sound (activator, CHAN_VOICE, self.noise, self.volume, ATTN_NORM); // Play the sound ON the activator and display message
	if (self.message != "") centerprint (activator, self.message);
	self.enemy = find (world, targetname, self.target); // Search entity list for targets
	while(self.enemy) {
		if (self.enemy.flags & FL_ITEM) { // This only works with items
			if (self.enemy.spawnflags & ENT_STARTOFF) { // Only works with items that start off
				if (self.enemy.touch2 != SUB_Null) {
					other = self.bmodel_act; // Switch to item for touch function
					activator = self.bmodel_act;
					self = self.enemy; 
					self.spawnflags = self.spawnflags - (self.spawnflags & ITEM_RESPAWN); // make sure items never respawn and silent pickup
					self.respawn_time = -1;
					self.respawn_trig = FALSE;
					self.spawnflags = self.spawnflags | ITEM_FLOATING; // item should always be floating (no drop to floor functions)
					if (stemp.sounds != 4) self.noise = SOUND_EMPTY; // give trigger sound overrides all items
					self.touch2 () ; // Use original touch function
					self = stemp;
				}
			}
		}
		self.enemy = find (self.enemy, targetname, self.target); // Are there anymore targets left in the list?
	}
	
	if (self.target2 != "") trigger_strs(self.target2, self.bmodel_act); // Target is used for giving items only.  Check if target2 for other entity types.
	self.attack_finished = LARGE_TIMER; // always TRIGGER_ONCE functionality
};

// QUAKED trigger_giveitems (0.5 0 0.5) ? NOTOUCH x x x x x STARTOFF x Not_Easy Not_Normal Not_Hard Not_DM
// The target items only work if delay spawned spawnflag is set
// The pickup sound can be turned off by adding sounds=4 to item
// The target items will not respawn or work more than once
// -------- KEYS --------
// targetname : trigger entity (works with entity state system)
// target  : Trigger items (only) to give to the player
// target2 : Trigger other type of entities (relays, estate etc)
// wait    : -1 = Always fire targets once (cannot be reset)
// angle   : Facing Direction for trigger to work, use "360" for angle 0.
// sounds  : 1=Secret,2=talk(def),3=switch,4=silent,5=custom,6=secret2
// noise   : custom sound to play when triggered
// message : message to display when triggered
// -------- SPAWNFLAGS --------
// NOTOUCH  : can only be triggered via other entities
// STARTOFF : Requires trigger to activate
// -------- NOTES --------
// Variable sized bmodel used to give items to activator
// The target items only work if delay spawned spawnflag is set
// The pickup sound can be turned off by adding sounds=4 to item
// The target items will not respawn or work more than once.
void() trigger_giveitems = { // [ENTITY]
	if (check_bmodel_keys()) return;	// Check for bmodel errors
	if (check_bmodel_notouch()) return;	// NO touch + NO targetname!
	
	self.classtype = CT_TRIGGIVEITEM;
	self.classgroup = CG_TRIGGERS;
	InitTrigger ();
	if (self.sounds == 0) self.sounds = 4;	// Default = silence
	trigger_bmodel_sounds();				// Precache any sounds
	self.wait = -1; // Always trigger once functionality
	self.spawnflags = self.spawnflags - (self.spawnflags & TRIG_MONSTERS); // Cannot have trigger touched by monsters
	self.spawnflags = self.spawnflags | TRIG_NODAMAGE; // No trigger damage functionality!
	self.estate_fire = trigger_giveitem_fire; // Setup Entity State functionality
	trigger_bmodel_setup();
};

void() trigger_fog_fire = { // [FUNCTION]
	if (self.estate & ESTATE_BLOCK) return;
	if (self.attack_finished > time) return;
	
	// Print dev message if worldspawn not setup correctly
	// First fog blend will be weird otherwise
	if (!fog_active) {
		if (self.pain_finished < time) {
			dprint("\b[FOG]\b Missing density + colour on worldspawn!\n");
			dprint("\b[FOG]\b First fog blend requires worldspawn setup\n");
		}
		self.pain_finished = time + 1;
	}	
	
	// Crazy test option, random fog!
	if (self.lefty > 0) {
		if (self.lefty == 2) self.fog_density = random()*10; // Extra test mode (-2) for fog density 1-10
		else self.fog_density = random(); // Default test mode (-1) for fog density 0-1
		self.fog_colour_x = random();
		self.fog_colour_y = random();
		self.fog_colour_z = random();
		self.speed = 1 + random()*4;

		// Show values on console
		if (developer > 0) {
			dprint("[FOG] DRGB ("); 
			lftos(self.owner, self.fog_density, 2,3, BUFFER_DPRINT); dprint(")(");
			lftos(self.owner, self.fog_colour_x, 1,3, BUFFER_DPRINT); dprint(" ");
			lftos(self.owner, self.fog_colour_y, 1,3, BUFFER_DPRINT); dprint(" ");
			lftos(self.owner, self.fog_colour_z, 1,3, BUFFER_DPRINT); dprint(")\n");
		}
	}

	fade_fog(self.fog_density, self.fog_colour, self.speed); // Update global fog controller
	SUB_UseTargets();
	
	// Is the trigger repeatable?
	if (self.wait > 0) {
		if (self.wait < self.speed) self.wait = self.speed + 0.1;
		self.attack_finished = time + self.wait;
		self.nextthink = self.attack_finished;
		self.think = self.estate_on;
	} else { // block trigger and turn off (trigger_once)
		self.attack_finished = LARGE_TIMER;
		self.estate_off();
	}
};

void() trigger_fog_waitforcontrol = { // [FUNCTION]
	if (fog_control && fog_active) {
		self.estate_fire = trigger_fog_fire; // Setup Entity State functionality
		trigger_bmodel_setup();
	} else {
		self.think = trigger_fog_waitforcontrol;
		self.nextthink = time + 0.1 + random();
	}
};

// QUAKED trigger_fog (.5 .5 .5) ? NOTOUCH x x x x x STARTOFF x Not_Easy Not_Normal Not_Hard Not_DM
// -------- KEYS --------
// targetname : trigger entity (works with entity state system)
// target  : name of target(s) to trigger
// speed   : time (secs) to fade from current to new (-1 = instant, 2s = default)
// wait    : time between re-triggering (def=2s, -1=once)
// angle   : Facing Direction for trigger to work, use "360" for angle 0.
// fog_density : new fog density (def=0.1, -1=debug mode, -2=debug+ mode)
// fog_colour  : new fog colours (def=0.1 0.1 0.1)
// -------- SPAWNFLAGS --------
// STARTOFF : Starts off and waits for trigger
// -------- NOTES --------
// Trigger change global fog to new value over time
void() trigger_fog = { // [ENTITY]
	if (check_bmodel_keys()) return;	// Check for bmodel errors
	if (check_bmodel_notouch()) return;	// NO touch + NO targetname!
	
	self.classtype = CT_TRIGFOG;
	self.classgroup = CG_TRIGGERS;
	InitTrigger ();
	if (self.speed == 0) self.speed = 2; // A fade time < minimum fade time = instant change
	if (self.speed < FADEFOG_TIME) self.speed = FADEFOG_TIME;
	if (self.wait == 0) self.wait = 2;
	self.attack_finished = 0;
	self.spawnflags = self.spawnflags - (self.spawnflags & TRIG_MONSTERS); // Cannot have trigger touched by monsters

	// Check for debug test mode (random density/colour)
	if (self.fog_density == -10) self.lefty = 1;		// Density 0-1
	else if (self.fog_density == -20) self.lefty = 2;	// Density 0-10
	else self.lefty = 0;
	
	// Default density/colour
	if (self.fog_density < 0) self.fog_density = 0;
	else if (self.fog_density == 0) self.fog_density = DEF_FOGDEN;

	// Check for fog colour 0,0,0 (black) option
	if (self.fog_colour_x < 0 || self.fog_colour_y < 0 || self.fog_colour_z < 0) self.fog_colour = '0 0 0';
	else if (CheckZeroVector(self.fog_colour)) self.fog_colour = DEF_FOGCOL; // Default colour (0.1 0.1 0.1)

	trigger_fog_waitforcontrol();
};

void() trigger_skyfog_fire = { // [FUNCTION]
	if (self.estate & ESTATE_BLOCK) return;
	if (self.attack_finished > time) return;

	if (!skyfog_active) {
		if (self.pain_finished < time) {
			dprint("\b[SKYFOG]\b Missing density on worldspawn!\n"); // Print dev message if worldspawn not setup correctly.  First sky fog blend will be weird otherwise.
			dprint("\b[SKYFOG]\b First fog blend requires worldspawn setup\n");
		}
		self.pain_finished = time + 1;
	}	
	
	// Crazy test option, random sky fog!
	if (self.lefty > 0) {
		self.skyfog_density = random(); // Default test mode (-1) for fog density 0-1
		self.speed = 1 + random();
		if (developer > 0) { dprint("[SKYFOG] Density ("); lftos(self.owner, self.skyfog_density, 1,3, BUFFER_DPRINT); dprint(")\n"); } // Show values on console
	}

	fade_skyfog(self.skyfog_density, self.speed); // Update global sky fog controller
	SUB_UseTargets();
	
	// Is the trigger repeatable?
	if (self.wait > 0) {
		if (self.wait < self.speed) self.wait = self.speed + 0.1;
		self.attack_finished = time + self.wait;
		self.nextthink = self.attack_finished;
		self.think = self.estate_on;
	} else {
		self.attack_finished = LARGE_TIMER; // block trigger and turn off (trigger_once)
		self.estate_off();
	}
};

void() trigger_skyfog_waitforcontrol = { // [FUNCTION]
	if (skyfog_control && skyfog_active) {
		self.estate_fire = trigger_skyfog_fire; // Setup Entity State functionality
		trigger_bmodel_setup();
	} else {
		self.think = trigger_skyfog_waitforcontrol;
		self.nextthink = time + 0.1 + random();
	}
};

// QUAKED trigger_skyfog (.5 .5 .5) ? NOTOUCH x x x x x STARTOFF x Not_Easy Not_Normal Not_Hard Not_DM
// -------- KEYS --------
// targetname : trigger entity (works with entity state system)
// target  : name of target(s) to trigger
// speed   : time (secs) to fade from current to new (-1 = instant, 2s = default)
// wait    : time between re-triggering (def=2s, -1=once)
// angle   : Facing Direction for trigger to work, use "360" for angle 0.
// skyfog_density : new sky fog density (def=0.5, -1=debug mode)
// -------- SPAWNFLAGS --------
// STARTOFF : Starts off and waits for trigger
// -------- NOTES --------
// Trigger change global sky fog to new value over time
void() trigger_skyfog = { // [ENTITY]
	if (check_bmodel_keys()) return;	// Check for bmodel errors
	if (check_bmodel_notouch()) return;	// NO touch + NO targetname!

	self.classtype = CT_TRIGSKYFOG;
	self.classgroup = CG_TRIGGERS;
	InitTrigger ();

	// A fade time < minimum fade time = instant change
	if (self.speed == 0) self.speed = 2;
	if (self.speed < FADEFOG_TIME) self.speed = FADEFOG_TIME;
	if (self.wait == 0) self.wait = 2;
	self.attack_finished = 0;
	self.spawnflags = self.spawnflags - (self.spawnflags & TRIG_MONSTERS); // Cannot have sky fog triggers touched by monsters

	// Check for debug test mode (random density)
	if (self.skyfog_density == -10) self.lefty = 1;	// Density 0-1
	else self.lefty = 0;
	
	// Default density
	if (self.skyfog_density < 0) self.skyfog_density = 0;
	else if (self.skyfog_density == 0) self.skyfog_density = DEF_SKYFOGDEN;

	trigger_skyfog_waitforcontrol();
};

void() trigger_monsternojump_fire = { // [FUNCTION]
	// This is after bmodel _use, _killed and _touch, so any reference to the trigger activator has to go through 'bmodel_act'
	if (self.estate & ESTATE_BLOCK) return;
	if (self.attack_finished > time) return;
	if (!(self.bmodel_act.flags & FL_MONSTER)) return; // Block non-monsters
	if (self.noise1 != string_null && self.bmodel_act.classname != self.noise1) return; // Is there any classname exception setup?
	
	// Check for any extra triggers
	if (HasTargets(self)) {
		SUB_UseTargets();
		clear_trigstrs(self); // Fire them once!
	}

	self.bmodel_act.jump_flag = time + self.delay; // Update jump flag to block jump attacks
	self.attack_finished = time + self.waitmin; // Restrict the trigger to 0.1s re-triggering

	// Setup to trigger push once?
	if (self.wait < 0) {
		self.attack_finished = LARGE_TIMER;
		self.estate_off();
	}
};

// QUAKED trigger_monsternojump (.5 .5 .5) ? x x x x x x STARTOFF x Not_Easy Not_Normal Not_Hard Not_DM
// -------- KEYS --------
// targetname : trigger entity (works with entity state system)
// wait   : -1 = trigger_once functionality
// delay  : time to delay jump attack by (def=0.5s)
// waitmin: Re-trigger timer to stop touch flooding (def=0.1s)
// noise1 : specify classname that CAN use this trigger (noise1=monster_dog)
// -------- SPAWNFLAGS --------
// STARTOFF : Starts off and waits for trigger
// -------- NOTES --------
// Stop monsters from using jump attacks.
void() trigger_monsternojump = { // [ENTITY]
	if (check_bmodel_keys()) return;	// Check for bmodel errors

	self.classtype = CT_TRIGNOJUMP;
	self.classgroup = CG_TRIGGERS;
	InitTrigger ();
	if (!self.delay) self.delay = 0.5;
	if (!self.waitmin) self.waitmin = 0.1;
	self.spawnflags = self.spawnflags | TRIG_ALWAYTOUCH | TRIG_NODAMAGE; // No trigger damage functionality and always touchable!
	self.estate_fire = trigger_monsternojump_fire; // Setup Entity State functionality
	self.touch = trigger_bmodel_anytouch;
	trigger_bmodel_setup();
};

void() trigger_nomonjump = { trigger_monsternojump(); }; // [ENTITY], Re-direct because it was renamed to be more consistent

void() trigger_monsterdrop_use = { // [FUNCTION]
	if (self.estate & ESTATE_BLOCK) return;
	if (self.attack_finished > time) return;
	if (self.target == "") return;

	self.oldenemy = find(world, targetname, self.target); // Build initial list from world
	while (self.oldenemy) {
		if (self.oldenemy.flags & FL_MONSTER) { // only works with monsters
			if (!(self.oldenemy.flags & (FL_FLY || FL_SWIM))) { // Double check for swim/fly types
				if (self.oldenemy.flags & FL_ONGROUND) { // Got to be onground already
					self.oldenemy.flags = self.oldenemy.flags - FL_ONGROUND; // Set monster in motion
					self.oldenemy.velocity_z = self.height;
				}
			}
		}
		self.oldenemy = find(self.oldenemy, targetname, self.target);
	}

	// Setup to trigger once functionality?
	if (self.wait < 0) {
		self.attack_finished = LARGE_TIMER;
		self.estate_off();
	}
};

// QUAKED trigger_monsterdrop (0 .5 .5) (-8 -8 -8) (8 8 8) x x x x x x STARTOFF x Not_Easy Not_Normal Not_Hard Not_DM
// Drop monster(s) to floor
// -------- KEYS --------
// targetname : trigger entity (works with entity state system)
// wait   : -1 = trigger_once functionality
// height : the speed thrown upwards (def 50)
// -------- SPAWNFLAGS --------
// STARTOFF : Starts off and waits for trigger
// -------- NOTES --------
// Drop monster(s) to floor
void() trigger_monsterdrop = { // [ENTITY]
	self.classtype = CT_TRIGMONDROP;
	self.classgroup = CG_TARGETS;
	if (check_nightmare() == TRUE) return; // Check for firing conditions (nightmare, coop)
	if (check_coop() == TRUE) return;

	if (!self.height) self.height = 50;
	if (self.targetname != "") self.use = entity_state_use; // Setup Entity State functionality
	self.estate_use = trigger_monsterdrop_use;
	self.estate = ESTATE_ON;
};

void() trigger_monsterjump_fire = { // [FUNCTION]
	local entity sactivator;

	if (self.estate & ESTATE_BLOCK) return;
	if (self.attack_finished > time) return;
	if (self.bmodel_act.spawnstatue) return; // Cannot move spawning statues.  After bmodel _use, _killed and _touch, so any reference to activator has to go through 'bmodel_act'.
	if (self.bmodel_act.jump_flag > time) return; // Check monster is not jumping already
	if (self.bmodel_act.bodyonflr == MON_ONFLR) return; // Cannot make dead bodies jump
	if (self.bmodel_act.ignore_monjump > 0) return; // entity excluded from using monster jump triggers
	if (!CheckZeroVector(self.movedir2)) { makevectors (self.bmodel_act.angles); if (v_forward * self.movedir2 < 0) return; } // Did the trigger have an angle key setup?
	if (!(self.bmodel_act.flags & FL_MONSTER)) return; // Block non-monsters and fly/swim if spawnflag not set
	if (!(self.spawnflags & TRIG_MONJUMPFLY) && self.bmodel_act.flags & FL_FLY) return;
	if (!(self.spawnflags & TRIG_MONJUMPSWIM) && self.bmodel_act.flags & FL_SWIM) return;
	if (self.noise1 != "") { // Is there any classname exception setup?
		if (self.bmodel_act.classname != self.noise1) return;
		if (self.bmodel_act.classtype == CT_MONDROLE && !self.bmodel_act.attack_rage) return; // extra special condition for enraged drole's
	}
	
	sactivator = activator; // Preserve activator just in case.
	activator = self.bmodel_act;
	if (HasTargets(self)) SUB_UseTargets(); // Check for any triggers and fire away.
	activator = sactivator; // Restore activator.  Like this never even happened.
	
	// Flying/Swimming monsters only need a push in the right direction
	if (self.bmodel_act.flags & FL_FLY || self.bmodel_act.flags & FL_SWIM) {
		self.bmodel_act.velocity = self.movedir * self.speed;
	} else {
		self.bmodel_act.velocity_x = self.movedir_x * self.speed; // set XY even if not on ground, so the jump will clear lips
		self.bmodel_act.velocity_y = self.movedir_y * self.speed;
		if (self.bmodel_act.flags & FL_ONGROUND ) {
			self.bmodel_act.flags = self.bmodel_act.flags - FL_ONGROUND;
			self.bmodel_act.velocity_z = self.height; // Do the jump.
		}
	}

	// Setup to trigger push once?
	if (self.wait < 0) {
		self.attack_finished = LARGE_TIMER;
		self.estate_off();
	}
};

// QUAKED trigger_monsterjump (.5 .5 .5) ? x FLYING SWIMMING x x x STARTOFF x Not_Easy Not_Normal Not_Hard Not_DM
// -------- KEYS --------
// targetname : trigger entity (works with entity state system)
// target     : target entity for custom direction
// target2    : targets to fire when the trigger is used
// wait       : -1 = trigger_once functionality
// angle      : direction of push (-2 is down, -1 up)
// angletarget: targeting entity used for custom direction
// mangle     : facing direction for activating the trigger
// speed      : the speed thrown forward (def 200)
// height     : the speed thrown upwards (def 200)
// noise1     : specify classname that CAN use this trigger (noise1=monster_dog)
// -------- SPAWNFLAGS --------
// FLYING   : Will affect flying monsters
// SWIMMING  : Will affect swimming monsters
// STARTOFF : Starts off and waits for trigger
// -------- NOTES --------
// Push monsters in a certain direction
// This entity cannot be damaged and is always touchable once activated
void() trigger_monsterjump = { // [ENTITY]
	if (check_bmodel_keys()) return; // Check for bmodel errors

	self.classtype = CT_TRIGMONJUMP;
	self.classgroup = CG_TRIGGERS;
	if (!CheckZeroVector(self.mangle)) { // Check for a facing angle (used later in fire function)
		makevectors (self.mangle);
		self.movedir2 = v_forward;
	} else self.movedir2 = VEC_ORIGIN; // Default setup (not used)
	
	if (self.angles_y == 0) self.angles_y = 360; // Default jump angle is 360, needs to be set BEFORE InitTrigger
	InitTrigger ();
	if (!self.speed) self.speed = 200;
	if (!self.height) self.height = 200;
	self.spawnflags = self.spawnflags | TRIG_ALWAYTOUCH | TRIG_NODAMAGE; // No trigger damage functionality and always touchable!
	self.estate_fire = trigger_monsterjump_fire; // Setup Entity State functionality
	self.touch = trigger_bmodel_anytouch;
	trigger_bmodel_setup();
	if (self.target != "") { // If target is setup, calculate new facing angletarget. Not used for targets, no need to check all.
		self.angletarget = self.target;
		self.nextthink = time + 1 + random();
		self.think = TargetMovedirReturn;
	}
};

void() trigger_drolejump = { // [ENTITY]
	self.noise1 = "monster_drole";
	trigger_monsterjump();
};

void() trigger_monsterturret_fire = { // [FUNCTION]
	local entity tself;
	
	if (self.estate & ESTATE_BLOCK) return;
	if (self.attack_finished > time) return;	// trigger_once functionality
	if (!(self.bmodel_act.flags & FL_MONSTER)) return;	// ONLY Monsters!
	if (self.bmodel_act.health < 1) return;		// Dead things cannot be turrets!
	if (self.bmodel_act.movespeed < 0) return;	// Already a turret!?!
	if (!self.bmodel_act.enemy) return;			// This is a combat node only
	if (self.bmodel_act.turretactive) return;	// Already using a turret position
	if (!self.bmodel_act.th_missile) return;	// Only works if got range attack
	if (self.noise1 != "") { if (self.noise1 != self.bmodel_act.classname) return; }

	tself = self;
	self = self.bmodel_act; // Switch self to monster.  After bmodel _use, _killed and _touch, so any reference to activator has to go through 'bmodel_act'.
	other = tself; 
	if (visible(self.enemy) && infront(self.enemy)) self.turretactive = other; // Link the monster to the turret (used by ai_run)
	self = tself; // Restore to the trigger_monsterturret

	// Setup to trigger push once?
	if (self.wait < 0) {
		self.attack_finished = LARGE_TIMER;
		self.estate_off();
	}
};

// QUAKED trigger_monsterturret (0.5 0.3 0) ? x x x x x x STARTOFF x Not_Easy Not_Normal Not_Hard Not_DM
// -------- KEYS --------
// targetname : trigger entity (works with entity state system)
// wait   : -1 = Only trigger a monster turret function once
// count  : random chance to pause; constant = -1, def = 0.25, range = 0 - 1
// noise1 : only works with this type of monster (monster_ogre)
// -------- SPAWNFLAGS --------
// STARTOFF : Starts off and waits for trigger
// -------- NOTES --------
// Temporarily turn a monster into a turret
// This entity cannot be damaged and is always touchable once activated
void() trigger_monsterturret = { // [ENTITY]
	if (check_bmodel_keys()) return;	// Check for bmodel errors

	self.classtype = CT_TRIGMONTURRET;
	self.classgroup = CG_TRIGGERS;
	if (self.angles_y == 0) self.angles_y = 360;
	InitTrigger ();
	if (self.count < 0) self.count = -1;
	else if (self.count == 0 || self.count > 1) self.count = 0.25;
	
	self.spawnflags = self.spawnflags | TRIG_ALWAYTOUCH | TRIG_NODAMAGE; // No trigger damage functionality and always touchable!
	self.estate_fire = trigger_monsterturret_fire; // Setup Entity State functionality
	self.touch = trigger_bmodel_anytouch;
	trigger_bmodel_setup();
};

void() trigger_hurt_fire = { // [FUNCTION]
	if (self.attack_finished > time) return;
	if (self.bmodel_act.takedamage == DAMAGE_NO) return; // After bmodel _use, _killed and _touch, so any reference activator has to go through 'bmodel_act'.
	if (self.spawnflags & TRIG_HURTMONSTER && !(self.bmodel_act.flags & FL_MONSTER)) return;
	if (self.spawnflags & TRIG_HURTFALLING) { // Check for falling damage conditions (player + flying + speeding)
		if (!(self.bmodel_act.flags & FLx_CREATURE)) return; // Only affects players and monsters
		if (self.bmodel_act.flags & FL_ONGROUND) return;
		if (self.bmodel_act.health < 1) return; // Can't kill something dead already!
		if (fabs(self.bmodel_act.velocity_z) < self.speed) return;
	}
	if (trigger_check_body(self.bmodel_act,DEAD_EXPLODE)) return; // Check for any dead monster bodies (no exceptions)
	if (self.bmodel_act.flags & FL_CLIENT && self.bmodel_act.flags & FL_GODMODE) return; // Check for godmode players taking screenshots!
	if (self.bmodel_act.flags & FL_CLIENT && self.bmodel_act.movetype == MOVETYPE_NOCLIP) return; // Be nice to noclippers taking screenshots!

	self.attack_finished = time + self.wait; // Block touch function based on wait time
	self.dmg = trigger_dmgquery(); // Work out damage based on skill level
	T_Damage (self.bmodel_act, self, self, self.dmg, DAMARMOR); // Do the damage (using armour/pent resistance)

	// Check for any extra triggers
	if (HasTargets(self)) {
		SUB_UseTargets();
		clear_trigstrs(self); // Fire them once!
	}
};

void() trigger_hurt_on = { // [FUNCTION]
	self.estate = ESTATE_ON;
	self.solid = SOLID_TRIGGER;
	setsize (self, self.bbmins, self.bbmaxs); // Restore bounding box (dev testing visual thing)
	trigger_spawn_bubbles(); // Spawn bubbles inside volume brush
};

// QUAKED trigger_hurt (.5 .5 .5) ? x BUBBLES MONSTER_ONLY x MODCHECK FALLING STARTOFF x Not_Easy Not_Normal Not_Hard Not_DM
// -------- KEYS --------
// targetname : trigger entity (works with entity state system)
// dmg     : damage from contact with trigger (def=5)
// dmgskill: damage based on skill level X=Easy, Y=Normal, Z=Hard/NM (def=0,0,0)
// wait    : time between pain contact (def=1s)
// angle   : Facing Direction for trigger to work, use "360" for angle 0.
// speed   : used by falling spawnflag for velocity check (def=300)
// height  : Maximum travel distance up for bubbles (default trigger size)
// count   : total amount of active bubbles at once (default 5)
// style   : 1-15 (grey,brown1,blue1,green1,red1,brown2,pinkyel,brown3,purp1,purp2,brown4,green2,yellow,blue2,red2)
// -------- SPAWNFLAGS --------
// BUBBLES  : Spawn bubbles within trigger volume when active
// MONSTER_ONLY : Will only affect monsters
// MODCHECK : Will remove this entity if THIS mod is active
// FALLING  : Only hurts if the player is falling (speed=velocity)
// STARTOFF : Starts off and waits for trigger
// -------- NOTES --------
// Will hurt any touching entity that can take damage
// This entity cannot be damaged and is always touchable once activated
void() trigger_hurt = { // [ENTITY]
	if (check_bmodel_keys()) return;	// Check for bmodel errors
	if (check_bmodel_modver()) return;	// Check mod version correct

	self.classtype = CT_TRIGHURT;
	self.classgroup = CG_TRIGGERS;
	InitTrigger ();
	trigger_dmgsetup(5);	// Setup default dmg
	if (self.wait <= 0) self.wait = 1;
	if (self.spawnflags & TRIG_SPAWNBUBBLES) trigger_setup_bubbles(); // Setup bubble model/counter/volume
	if (self.spawnflags & TRIG_HURTFALLING && self.speed < 1) self.speed = 300; // Setup default falling damage speed
	self.spawnflags = self.spawnflags | TRIG_ALWAYTOUCH | TRIG_NODAMAGE; // No trigger damage functionality and always touchable!
	if (self.targetname != "") self.use = entity_state_use; // Setup Entity State functionality
	self.estate_on = trigger_hurt_on;
	self.estate_off = trigger_bmodel_off;
	self.estate_disable = trigger_bmodel_disable;
	if (self.dmg > 0) {
		self.estate_fire = trigger_hurt_fire;
		self.touch = trigger_bmodel_anytouch;
	}

	if (self.spawnflags & ENT_STARTOFF) self.estate_off(); // Switch on OR off?
	else self.estate_on();
};

void() trigger_heal_touch = { // [FUNCTION]
	if (self.estate & ESTATE_BLOCK) return;		// Function off/disabled
	if (self.attack_finished > time) return;	// Touch blocked (temporary)
	if ( !(other.flags & FL_CLIENT) ) return;	// Only works with clients
	if (other.health < 1 ) return;				// Cannot heal, target is dead
	if (self.health < 1) return;				// Run out of health
	
	self.attack_finished = time + self.wait; // Do not constantly check healing, use wait
	if (!T_Heal(other, self.healamount, 0)) return; // Can the pool heal the player?

	sound (other, CHAN_BODY, self.noise, self.volume, ATTN_NORM); // Healing sound
	if (self.max_health > 0) self.health = self.health - self.healamount; // Has the pool run out of health?
	if (self.health < 1) { // Has the healing trigger expired?
		if (self.lip < 2) centerprint (other, self.message2); // Only block message lip=1 healing 2=all messages
		if (self.target2 != "") {trigger_strs(self.target2, other); self.target2 = "";} // Fire any targets once (finish of healing cycle)
		entity_state_off(); // Switch off healing trigger
	} else {
		if (self.target != "") {trigger_strs(self.target, other);self.target = "";} // Fire any targets once (start of healing cycle)
		if (!self.lip) centerprint (other, self.message); // Display healing message (check for lip block)
	}
};	

void() trigger_heal_on = { // [FUNCTION]
	if (self.health <= 0) return;

	self.estate = ESTATE_ON;
	self.solid = SOLID_TRIGGER;
	setsize (self, self.bbmins, self.bbmaxs); // Restore bounding box (dev testing visual thing)
	trigger_spawn_bubbles(); // Spawn bubbles inside volume brush
};

void() trigger_heal_reset = { // [FUNCTION]
	if (self.max_health <= 0) return;

	self.health = self.max_health; // Reset health, targets and switch on entity 
	if (self.noise1 != "") self.target = self.noise1;
	if (self.noise2 != "") self.target2 = self.noise2;
	self.estate_on();
};

// QUAKED trigger_heal (.5 .5 .5) ? x BUBBLES x x x x STARTOFF x Not_Easy Not_Normal Not_Hard Not_DM
// -------- KEYS --------
// targetname : trigger entity (works with entity state system)
// target  : trigger once when players stands in trigger (start cycle)
// target2 : trigger once when healing expires (finish cycle)
// wait    : time between healing (default 1s)
// healamount : amount to heal each time touched (default 10)
// max_health : total amount to heal (default 50, -1=no limit)
// sounds  : 1=heal_15, 2=heal_25, 3=heal_100, 4=respawn, 5=custom (default 1)
// noise   : Custom sound for healing
// lip     : All messages are silent to the player (heal/expire) 1=block heal 2=block all
// message : centerprints when players stands in trigger
// message2 : centerprints when healing function has expired
// height  : Maximum travel distance up for bubbles (default trigger size)
// count   : total amount of active bubbles at once (default 5)
// style   : 1-15 (grey,brown1,blue1,green1,red1,brown2,pinkyel,brown3,purp1,purp2,brown4,green2,yellow,blue2,red2)
// yaw_speed : spawning rate (def=0.5) for bubbles (speed + random() x speed)
// -------- SPAWNFLAGS --------
// BUBBLES  : Spawn bubbles within trigger volume when active
// STARTOFF : Starts off and waits for trigger
// -------- NOTES --------
// Heals any player who touches this trigger, can be triggered on/off and produces 
// bubbles within the bounding box of the trigger when spawnflag enabled
void() trigger_heal = { // [ENTITY]
	if (check_bmodel_keys()) return;	// Check for bmodel errors

	self.classtype = CT_TRIGHEAL;
	self.classgroup = CG_TRIGGERS;
	InitTrigger ();
	if (self.sounds == 2) self.noise = SOUND_HEAL25; // Setup default healing sound
	else if (self.sounds == 3) self.noise = SOUND_HEAL100;
	else if (self.sounds == 4) self.noise = SOUND_RESPAWN;
	else if (self.sounds == 5 && self.noise == "") self.noise = SOUND_HEAL15;
	else self.noise = SOUND_HEAL15;

	precache_sound(self.noise);
	SUB_BoundVolume(1);
	if (self.spawnflags & TRIG_SPAWNBUBBLES) trigger_setup_bubbles(); // Setup bubble model/counter/volume
	if (!self.wait) self.wait = 1;					// Default trigger time
	if (self.healamount < 1) self.healamount = 10;	// Quantity to heal each touch trigger
	if (!self.max_health) self.max_health = 50;		// Default max healing
	if (self.max_health > 0 && self.max_health < self.healamount) self.healamount = self.max_health; // Cannot have healamount large than max, need to cap healamount
	if (self.max_health < 0) self.health = 100;		// max < 0 = Infinite healing
	else self.health = self.max_health;				// Reset total ready
		
	if (!self.message) self.message = "You feel the effects of the healing pool";
	if (!self.message2) self.message2 = "The Healing Pool has expired!";
	if (self.target != "" ) self.noise1 = self.target; // Save any trigger names for reset events.  No need to check all targets, special setup that only uses target and...
	if (self.target2 != "" ) self.noise2 = self.target2; // ...target2, no need to check all targets.
	if (self.targetname != "") self.use = entity_state_use; // Setup Entity State functionality
	self.estate_on = trigger_heal_on;
	self.estate_off = trigger_bmodel_off;
	self.estate_disable = trigger_bmodel_disable;
	self.estate_reset = trigger_heal_reset;
	self.touch = trigger_heal_touch;
	if (self.spawnflags & ENT_STARTOFF) self.estate_off(); // Switch on OR off?
	else self.estate_on();
};

void() trigger_tsound_touch = { // [FUNCTION]
	if (self.estate & ESTATE_BLOCK) return;		// Function off/disabled
	if (self.attack_finished > time) return;	// Touch blocked (temporary)
	if ( !(other.flags & FL_CLIENT) ) return;	// Only works with clients
	if (other.health < 1 ) return;				// other is dead

	if (other.touchedliquid < time) sound (other, CHAN_BODY, self.noise, self.volume, ATTN_NORM);
	other.touchedliquid = time + 0.1;
	other.touchedsound = self.noise1;
	self.attack_finished = time + 0.05;
};

void() trigger_tsound_on = { // [FUNCTION]
	self.spawnflags = self.spawnflags - (self.spawnflags & ENT_STARTOFF); // No longer need this spawnflag, remove it
	self.estate = ESTATE_ON;
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_TRIGGER;
	self.origin = self.oldorigin;
	self.alpha = self.water_alpha;
	if (self.spawnflags & TRIG_TSOUNDWGEO) setmodel (self, self.mdl);
};

void() trigger_tsound_fade = { // [FUNCTION]
    self.lip = self.speed - ((time - self.ltime) / self.speed); // Take draining time and divide by time passed
	self.alpha = self.lip * (self.water_alpha / self.speed); // Start at current alpha value and move towards 0
	self.origin_z = self.origin_z - (self.speed * self.yaw_speed); // Slowly sink into the ground as alpha fading
    if (self.alpha <= 0) {
        self.alpha = 0.01;
		self.modelindex = 0; // Make sure no model
		self.model = "";
		self.estate = ESTATE_OFF;
        return;
    } else self.nextthink = time + FADEMODEL_TIME; // Keep on loop (using minimum QS time segment)
};

void() trigger_tsound_drain = { sound(self, CHAN_AUTO, self.owner.noise2, self.owner.volume, ATTN_NORM); }; // [FUNCTION], Used as a think.

void() trigger_tsound_disable = { // [FUNCTION]
	if (self.estate & ESTATE_BLOCK) return;
	self.solid = SOLID_NOT;
	self.estate = ESTATE_DISABLE;
	if (self.spawnflags & TRIG_TSOUNDDRAIN) {
		self.ltime = time; // Allow for bmodel timer to alpha correctly
		self.think = trigger_tsound_fade; // Gradually fade and lower bmodel
		self.nextthink = time + FADEMODEL_TIME;
		self.sound_emitter.think = trigger_tsound_drain; // Start playing draining sound
		self.sound_emitter.nextthink = time + self.super_time;
	}
};

void() trigger_tsound_syncalpha = { // [FUNCTION]
	if (self.water_alpha > 0) self.alpha = self.water_alpha; // Allow for trigger to override global water alpha
	else if (liquid_alpha > 0) self.alpha = liquid_alpha;
	else self.alpha = 1;
	
	self.water_alpha = self.alpha; // Save this value for later
	if (!(self.spawnflags & ENT_STARTOFF)) self.estate_on();
};

// QUAKED trigger_touchsound (.5 .5 .5) ? x x WORLDGEO DRAIN x x STARTOFF x Not_Easy Not_Normal Not_Hard Not_DM
// ------- KEYS --------
// targetname : trigger entity (works with entity state system)
// sounds     : 1=Water (def) 2=Slime 3=Lava 4=silent 5=custom
// noise      : Custom trigger touch sound
// noise1     : Custom trigger exit sound
// noise2     : Custom draining sound
// speed      : Time (def=1.5s) to drain liquid
// yaw_speed  : Vertical drain speed (def=0.05)
// water_alpha: Alpha value for liquid (override worldspawn)
// -------- SPAWNFLAGS --------
// WORLDGEO : Will draw bmodel (not just a trigger)
// DRAIN    : Drain effect when trigger_disabled
// STARTOFF : Requires trigger to activate
// ------- NOTES --------
// Plays sounds when touched by the player
void() trigger_touchsound = { // [ENTITY]
	if (check_bmodel_keys()) return;	// Check for bmodel errors

	self.classtype = CT_TRIGTSOUND;
	self.classgroup = CG_TRIGGERS;
	InitTrigger ();
	if (!self.speed) self.speed = 1.5;
	if (!self.yaw_speed) self.yaw_speed = 0.05;
	if (self.super_time < 0.1) self.super_time = 0.1;
	self.attack_finished = 0;
	self.oldorigin = self.origin; // Restored later for ON function
	if (self.sounds < 1) self.sounds = 1; // Default sounds (water)
	if (self.sounds == 1) {
		if (self.noise == "") self.noise = "player/inh2o.wav";
		if (self.noise1 == "") self.noise1 = "misc/outwater.wav";
	} else if (self.sounds == 2) {
		if (self.noise == "") self.noise = "player/slimbrn2.wav";
		if (self.noise1 == "") self.noise1 = "misc/outwater.wav";
	} else if (self.sounds == 3) {
		if (self.noise == "") self.noise = "player/inlava.wav";
		if (self.noise1 == "") self.noise1 = "misc/outwater.wav";
	} else { // Silent for > 3
		if (self.noise == "") self.noise = SOUND_EMPTY;
		if (self.noise1 == "") self.noise1 = SOUND_EMPTY;
	}
	precache_sound(self.noise); // Precache all sounds
	precache_sound(self.noise1);	
	SUB_BoundVolume(1);
	if (self.spawnflags & TRIG_TSOUNDDRAIN) {
		if (self.noise2 == "") self.noise2 = "ad171/ambience/liquid_drain.wav";
		precache_sound(self.noise2);
		self.sound_emitter = spawn();
		self.sound_emitter.owner = self;
		self.sound_emitter.origin = bmodel_origin(self) + '0 0 32'; // Create an entity to play drain sound bmodel origins are at 0,0,0 so never play properly.
		self.sound_emitter.solid = SOLID_NOT;
		self.sound_emitter.movetype = MOVETYPE_NONE;
		setmodel(self.sound_emitter, MODEL_EMPTY);
		setorigin(self.sound_emitter, self.sound_emitter.origin);
	}
	if (self.targetname != "") self.use = entity_state_use; // Setup Entity State functionality
	self.estate_on = trigger_tsound_on;
	self.estate_off = trigger_bmodel_off;
	self.estate_disable = trigger_tsound_disable;
	self.touch = trigger_tsound_touch;
	if (self.spawnflags & ENT_STARTOFF) self.estate_off(); // Switch off?
	self.think = trigger_tsound_syncalpha; // Sync the water alpha console variable
	self.nextthink = time + 0.1 + random(); // Give time for console variable to initialize.
};

void() trigger_void_touch = { // [FUNCTION]
	if (self.estate & ESTATE_BLOCK) return; // Exception, entity state and particles!
	if (other.classtype == CT_PARTICLE) return;
	if (other.classgroup == CG_PROJHAZARD) { HazardProjectile_Finished(other); return; } // Hazard projectiles MUST update counters (no exceptions)
	if (trigger_check_body(other,DEAD_REMOVE)) return; // Check for any dead monster bodies (no exceptions)
	if (self.spawnflags & TRIG_VOIDNOCLIENT && other.flags & FL_CLIENT) return; // Process spawnflag exceptions
	if (self.spawnflags & TRIG_VOIDNOMONSTER && other.flags & FL_MONSTER) return;
	if (self.spawnflags & TRIG_VOIDNOAMMO) {
		if (other.classgroup == CG_PROJALL) return;
		else if (other.classgroup == CG_PROJSHELLS) return;
		else if (other.classgroup == CG_PROJNAILS) return;
		else if (other.classgroup == CG_PROJROCKETS) return; // Rocket+Homing
		else if (other.classgroup == CG_PROJGRENADES) return;
		else if (other.classgroup == CG_PROJCELLS) return;
	}
	if (self.spawnflags & TRIG_VOIDNOEGG && other.classgroup == CG_MINIONEGG) return;
	if (self.spawnflags & TRIG_VOIDNOTEMP && other.classgroup == CG_TEMPENT) return;
	if (self.spawnflags & TRIG_VOIDNOITEM) {
		if (other.classgroup == CG_WEAPON) return;
		else if (other.classgroup == CG_AMMOITEM) return;
		else if (other.classgroup == CG_ARMOR) return;
		else if (other.classgroup == CG_KEY) return;
		else if (other.classgroup == CG_RUNE) return;
		else if (other.classgroup == CG_ARTIFACT) return;
	}
	if (other.movetype == MOVETYPE_NOCLIP && other.flags & FL_CLIENT) return; // Player is on noclip, be nice to testers!

	other.touchedvoid = TRUE; // flag touching entity, so other functions will ignore it
	if (other.flags & FLx_CREATURE) T_Damage(other,self,self,other.health+8,NOARMOR); // Let monsters and clients die through their own functions
	else {
		// Remove all ammo projectiles on contact
		// Hide other items types (may have particles active)
		if (other.classgroup == CG_PROJALL) entity_remove(other,0.1);
		else if (other.classgroup == CG_PROJSHELLS) entity_remove(other,0.1);
		else if (other.classgroup == CG_PROJNAILS) entity_remove(other,0.1);
		else if (other.classgroup == CG_PROJROCKETS) entity_remove(other,0.1);
		else if (other.classgroup == CG_PROJGRENADES) entity_remove(other,0.1);
		else if (other.classgroup == CG_PROJCELLS) entity_remove(other,0.1);
		else if (other.classgroup == CG_MINIONEGG) entity_remove(other,0.1);
		else if (other.classgroup == CG_TEMPENT) entity_remove(other,0.1);
		else if (other.classgroup == CG_WEAPON) entity_hide(other);
		else if (other.classgroup == CG_AMMOITEM) {
			entity_hide(other);
			if (other.attachment) entity_hide(other.attachment); // Hide any shell/nail lids, glowing swords, etc.
		} else if (other.classgroup == CG_ARMOR) entity_hide(other);
		else if (other.classgroup == CG_KEY) entity_hide(other);
		else if (other.classgroup == CG_RUNE) entity_hide(other);
		else if (other.classgroup == CG_ARTIFACT) entity_hide(other);
		else if (other.classgroup == CG_MISCENT) entity_hide(other);
		else if (other.classgroup == CG_BREAKABLE) entity_hide(other);
	}
};

// QUAKED trigger_void (.5 .5 .5) ? NO_CLIENT NO_MONSTER NO_AMMO NO_EGG NO_TEMP NO_ITEM STARTOFF x Not_Easy Not_Normal Not_Hard Not_DM
// ------- KEYS --------
// targetname : trigger entity (works with entity state system)
// -------- SPAWNFLAGS --------
// NO_CLIENT  : Ignore clients (anything flagged as a client)
// NO_MONSTER : Ignore monsters (anything flagged as a monster)
// NO_AMMO    : Ignore ammo types (all ammo projectile types)
// NO_EGG     : Ignore minion eggs (affects shalrath, wraiths)
// NO_TEMP    : Ignore temporary ents (gibs, sparks, smoke)
// NO_ITEM    : Ignore items (weapons,armor,keys,runes,powerups)
// STARTOFF : Requires trigger to activate
// ------- NOTES --------
// Garbage collector for out of bounds such as bottom of coagula maps, edges of voids, etc.
void() trigger_void = { // [ENTITY]
	if (check_bmodel_keys()) return;	// Check for bmodel errors

	self.classtype = CT_TRIGVOID;
	self.classgroup = CG_TRIGGERS;
	InitTrigger ();
	setsize (self, self.bbmins, self.bbmaxs); // Activate trigger (always ON)
	if (self.targetname != "") self.use = entity_state_use; // Setup Entity State functionality
	self.touch = trigger_void_touch; // This does not work via typical trigger bmodel paths.  This trigger is special, needs to work straight away
	if (self.spawnflags & ENT_STARTOFF) self.estate = ESTATE_OFF; // There is only a toggle/on/off state function
	else self.estate = ESTATE_ON;
};

void () version_touch = { // [FUNCTION]
   if (self.nextthink > time) return ;
   if (!(self.flags & FL_CLIENT)) return;

   centerprint(other,self.message);
};

void () trigger_version = { // [ENTITY]
   self.touch = version_touch;
   InitTrigger();
};