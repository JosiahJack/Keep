//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: Arcane Dimensions (AD), Mission Pack 2 (Rogue)
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
// Entity count: 2
// Function count: 6
//
// Implements: Rogue Buzzsaw Trap with AD Updates
//
// Description:
// Moving spinning saw that follows a path like a func_train would.  Noisy.
// * Originally based on code from Rogue Software
// * Extra code support from lunaran
//=============================================================================

float SAW_STARTON = 1;
float SAW_XAXIS = 16;
float SAW_REVERSE = 32;

void() trap_sawblade_touch = { // [FUNCTION]
	if (self.estate & ESTATE_OFF) return; // Blade can still hurt if touched, except when OFF = not visible
	if (trigger_check_body(other,DEAD_EXPLODE)) return; // Double check if dead monster body!
	if (other.health < 1 || other.takedamage == DAMAGE_NO) return;
	if (self.attack_finished > time) return;
	
	// --- lunaran -------------------
	// Different touch damage based on blade state
	if (self.state == STATE_ON) {
		if (self.waitmin > 0) self.attack_finished = time + self.waitmin;
		if (self.noise2 !="") sound(self,CHAN_AUTO,self.noise2, 1, 1); // Hit sounded added by Lunaran, added sound string check
	} else {
		if (self.height > 0) self.attack_finished = time + self.height;
	}
		
	
	if (other.flags & FL_MONSTER && other.health < 100) T_Damage(other, self, self, other.max_health + 100, DAMARMOR); // Instant death for weak monsters
	else T_Damage(other, self, self, self.dmg, DAMARMOR); // Small damage but can be lethal because of how often touch runs

	SpawnMeatSpray ( other, other, crandom() * 200); // Blood and gore at object location not sawblade
};

// New slowdown/stop function by lunaran
void() trap_sawblade_stopthink = { // [FUNCTION]
	float remaining;

	if (self.pain_finished <= time) { self.velocity = self.avelocity = '0 0 0'; return; } // If slow down time expired, make sure blade has stopped
	
	remaining = (self.pain_finished - time) / self.lip;

	// Quit moving if we've hit the next pathcorner.  It'd be cooler to continue on the track as we decelerate but this way we don't have to muck about in the func_train code.
	if (self.rad_time && self.rad_time <= time) {
		self.velocity = '0 0 0';
		setorigin(self, self.finaldest);
		self.rad_time = 0;
	}

	if (VectorIsAllZeros(self.velocity) == FALSE) self.velocity = normalize(self.velocity) * self.speed * remaining; // Ramp down from original speed and spinrate over self.lip seconds
	self.avelocity = normalize(self.avelocity) * self.yaw_speed * remaining;
	self.nextthink = time + 0.05; // Double tick time to smooth out slowdown
}

// New slowdown/stop function by lunaran
void() trap_sawblade_stop = { // [FUNCTION]
	float d, timeToPathCorner;

	sound(self,CHAN_VOICE, self.noise,1,ATTN_NORM); // Play wind down stop sound
	self.pain_finished = time + self.lip; // save the time we become completely still in pain_finished
	timeToPathCorner = vlen(self.origin-self.finaldest) / self.speed; // So when we hit next pathcorner (if ever), we can stop there.
	
	// linear deceleration = stopping distance of exactly 1/2 speed*stoptime
	if (self.lip * 0.5 > timeToPathCorner ) {
		d = mathlib_sqrt( 1 - ( 2 * timeToPathCorner / self.lip ) ); // linear deceleration = exponential time taken relative to distance
		d = self.lip * (1 - d);
		self.rad_time = time + d; // save the time in rad_time
	}
	self.think = trap_sawblade_stopthink;
	self.think();
};

void() trap_sawblade_use = { // [FUNCTION]
	if (self.estate & ESTATE_BLOCK) return; // Block entity state OFF + DISABLE

	// Toggle function
	if (self.state == STATE_OFF) {
		self.state = STATE_ON;
		func_train_resume(); // Use special train resume function, modified to handle buzzsaw exceptions.
	} else {
		self.state = STATE_OFF;
		trap_sawblade_stop();
	}
};

void() trap_sawblade_setup = { // [FUNCTION]
	if (self.spawnflags & ENT_STARTOFF) self.spawnflags = self.spawnflags - ENT_STARTOFF; // Remove start off flag and switch on entity
	self.estate_on();					// Switch on entity
	func_train_startcorner();			// Move to first corner
	self.estate_use = trap_sawblade_use;// Switch ON sawblade
	self.estate_fire = func_train_next;	// Move to next path corner
	self.state = STATE_OFF;				// sawblade is OFF, waiting
	self.touch = trap_sawblade_touch; // Sharp pointy edges!
	if (self.owner && self.spawnflags & SAW_STARTON) { // Did the first corner (owner) exist?
		self.nextthink = time + 0.1;
		self.think = self.estate_use;
	}
};

// Turn on model/world interaction
void() trap_sawblade_on = { // [FUNCTION]
	if (self.estate == ESTATE_ON) return; // Stop re-triggering ON state

	self.estate = ESTATE_ON;				// Switch on entity
	self.solid = SOLID_TRIGGER;				// Keep on cutting!
	self.movetype = MOVETYPE_NOCLIP;		// Free movement
	setmodel(self, self.mdl);				// Show bmodel/model
	setsize (self, self.bbmins , self.bbmaxs);	// Use pre-defined size
	StopSound(self,CHAN_VOICE); // Stop any current sounds, new sound will play in func_train function
	self.velocity = self.avelocity = '0 0 0';	// reset velocity/rotation
};

void() trap_sawbladey = { // [ENTITY]
	// 0 = No sound, 1 = buzzzzz, 5 = custom
	if (self.sounds > 0) {
		if (self.sounds == 1) {
			self.noise = ("ad171/traps/sawblade_off.wav");
			self.noise1 = ("ad171/traps/sawblade_on.wav");
			self.noise2 = ("ad171/traps/sawstrike1.wav");	// lunaran
		} else if (self.sounds == 5) {
			if (self.noise == "") self.noise = SOUND_EMPTY;
			if (self.noise1 == "") self.noise1 = SOUND_EMPTY;
			if (self.noise2 == "") self.noise2 = SOUND_EMPTY;	// lunaran
		}	
		precache_sound(self.noise);
		precache_sound(self.noise1);
		precache_sound(self.noise2);	// lunaran
	}

	self.mdl = "progs/ad171/trap_sawblade.mdl";
	precache_model (self.mdl);
	self.classtype = CT_SAWBLADE;
	self.state = STATE_OFF;
	self.volume = 0.5;
	if (self.target == "") dprint("\b[SAWBLADE]\b missing path corner target!\n"); // Error - Check for first path corner target

	// Setup orientiation and bounding box parameters
	// required for state on and touch function
	if (self.spawnflags & SAW_XAXIS) {
		self.angles = '0 0 0';
		self.bbmins = '-20 -2 -20';
		self.bbmaxs = '20 2 20';
	} else {
		self.angles = '0 90 0';
		self.bbmins = '-2 -20 -20';
		self.bbmaxs = '2 20 20';
	}
	
	if (!self.dmg) self.dmg = 4;			// Default touch damage
	if (!self.waitmin) self.waitmin = 0.1;	// Damage throttle ON state
	if (self.speed < 1) self.speed = 100;	// Default path speed
	self.wait = self.delay = 0;				// reset wait and delay
	
	// --- lunaran ----------------------
	if (!self.height) self.height = 1; 		// Damage throttle OFF state
	if (!self.lip) self.lip = 2;			// Deceleration time, -1 for none
	if (self.lip < 0) self.lip = 0;			// Convert -1 switch to 0 time
	
	if (!self.yaw_speed) self.yaw_speed = 180; // Setup default rotation speed
	self.v_angle = '0 0 0';
	self.v_angle_x = self.yaw_speed;
	self.dest0 = self.finaldest = self.origin; // Save spawn location
	if (self.target == "") self.owner = self;
	self.bsporigin = FALSE;
	if (self.spawnflags & SAW_STARTON && self.spawnflags & ENT_STARTOFF) self.spawnflags = self.spawnflags - ENT_STARTOFF; // Cannot have start ON and OFF together, remove OFF state!

	// Setup train direction (switchable via path corners)
	if (self.spawnflags & SAW_REVERSE) self.direction = 1;
	else self.direction = 0;
	
	if (self.targetname != "") self.use = entity_state_use; // Setup Entity State functionality
	self.estate_on = trap_sawblade_on;
	self.estate_off = func_train_off;
	self.estate_use = trap_sawblade_setup;
	self.estate_reset = func_train_reset;
	self.estate_disable = func_train_disable;
	if (self.spawnflags & ENT_STARTOFF) self.estate_off();
	else {
		self.nextthink = time + 0.1;
		self.think = self.estate_use;
	}
};

// QUAKED trap_sawbladex (0 .5 .8) (-18 -18 -18) (18 18 18) STARTON x x x x REVERSE STARTOFF x
// -------- KEYS --------
// targetname : toggle state (use trigger ent for exact state)
// target   : Name of first path_corner to start at (instant move)
// speed    : Speed to follow path, def=100
// yaw_speed : Rotation speed for Saw Blade (def=180)
// dmg      : Damage to do for each contact, def=4
// waitmin  : Damage throttle for ON touch function, def=0.1s
// height   : Damage throttle for OFF touch function, def=1s
// lip      : Deceleration time; def=2s, =-1 instant stop
// sounds   : 0=Silent, 1=Woodmill, 5=Custom sounds
// noise    : custom sound - stopped
// noise1   : custom sound - moving (looping)
// -------- SPAWNFLAGS --------
// STARTON  : Start moving straight away if targetname is used
// REVERSE  : Start going backward through path_corner chain
// STARTOFF : Starts off and waits for trigger
// -------- NOTES --------
// Rotating Saw Blade
void() trap_sawbladex = { // [ENTITY]
	self.spawnflags = self.spawnflags | SAW_XAXIS;
	trap_sawbladey();
};