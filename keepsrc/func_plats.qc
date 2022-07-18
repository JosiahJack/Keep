//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: Arcane Dimensions (AD) and ID1
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
// Entity count: 1
// Function count: 12
//
// Implements: Elevators, also known as Platforms or Plats for short
//
// Description:
// An elevator platform is a brush model entity that moves a specified height
// up and down.  Normal condition is to move down to its lowered state and wait
// for an activator to step onto the platform by entering its automatically
// created trigger.  The elevator then raises up to the top and waits at the
// top for a specified amount of time before lowering back down.
//
// Activation trigger can be as tall as the height or can use the low trigger
// option to better allow players to fall down to the bottom before activating,
// giving the player a chance to re-access the lower area.  Typically useful if
// the elevator is within a tube.
//
// Normal construction typically involves a "stem" which serves as the pillar
// or piston shaft that the platform is attached to.  Specifying the height
// directly overrides the brush model's height and allows for negative travel
// as well.
//
// Platforms are always created in the upper position, so they can be lit
// better.  If targetname is defined the func_plat starts high and is locked
// until triggered.  Once the func_plat has been triggered, it will become a
// normal platform and lower down to its lowered position.
//=============================================================================

float PLAT_LOW_TRIGGER = 1;
float PLAT_MIN_TRIGGER = 4;
float PLAT_START_LOWER = 8;
float PLAT_START_OPEN = 16;
float PLAT_STARTDIS = 32;		// Platform starts in disabled state

void() func_plat_hit_bottom = { // [FUNCTION]
	if (self.estate == ESTATE_OFF) return;

	self.state = STATE_BOTTOM;
	sound(self,CHAN_VOICE, self.noise1, self.volume,ATTN_NORM);
};

void() plat_hit_bottom = { func_plat_hit_bottom(); }; // [FUNCTION], Re-direction for map hacks (not used normally)

void() func_plat_go_down = { // [FUNCTION]
	if (self.estate == ESTATE_OFF) return;

	self.state = STATE_DOWN;
	sound(self,CHAN_VOICE, self.noise, self.volume,ATTN_NORM);
	SUB_CalcMove (self.pos2, self.speed, func_plat_hit_bottom);
};

void() func_plat_hit_top = { // [FUNCTION]
	if (self.estate == ESTATE_OFF) return;

	self.state = STATE_TOP;
	sound(self,CHAN_VOICE, self.noise1, self.volume,ATTN_NORM);
	self.think = func_plat_go_down;
	self.nextthink = self.ltime + 3;
};

void() func_plat_go_up = { // [FUNCTION]
	if (self.estate == ESTATE_OFF) return;

	self.state = STATE_UP;
	sound(self,CHAN_VOICE, self.noise, self.volume,ATTN_NORM);
	SUB_CalcMove (self.pos1, self.speed, func_plat_hit_top);
};

void() func_plat_trigger_touch = { // [FUNCTION]
	if (self.owner.estate & ESTATE_BLOCK) return;
	if (self.owner.state == STATE_DISABLED) return;
	if (!(other.flags & FL_CLIENT)) return;
	if (other.health <= 0) return;

	self = self.owner; // Switch the platform entity
	if (self.state == STATE_BOTTOM) func_plat_go_up();
	else if (self.state == STATE_TOP) self.nextthink = self.ltime + 1;	// delay going down
};

void() func_plat_trigger_spawn = { // [FUNCTION]
	local entity trigger;
	local vector tmin, tmax;

	trigger = spawn();
	trigger.owner = self;
	trigger.touch = func_plat_trigger_touch;
	trigger.movetype = MOVETYPE_NONE;
	trigger.solid = SOLID_TRIGGER;
	tmin = self.mins + '25 25 0';
	tmax = self.maxs - '25 25 -8';

	// The ID method is to take the maximum size of the platform and subtract the height. This fails if the platform
	// is moving around a central height point. The Alternative method uses the min bounding box value instead of max
	if (self.spawnflags & PLAT_MIN_TRIGGER) tmin_z = tmin_z - (self.height + 8); // This is not 100% capatible with id maps, so hence extra option!
	else tmin_z = tmax_z - (self.pos1_z - self.pos2_z + 8);

	if (self.spawnflags & PLAT_LOW_TRIGGER) tmax_z = tmin_z + 8;
	
	if (self.size_x <= 50) {
		tmin_x = (self.mins_x + self.maxs_x) / 2;
		tmax_x = tmin_x + 1;
	}

	if (self.size_y <= 50) {
		tmin_y = (self.mins_y + self.maxs_y) / 2;
		tmax_y = tmin_y + 1;
	}
	
	setsize (trigger, tmin, tmax);
};

void() func_plat_use = { // [FUNCTION]
	if (self.spawnflags & ENT_STARTOFF) self.estate_on(); // Deal with START OFF functionality first
	else {
		if (self.estate & ESTATE_BLOCK) return; // Block USE functionality if state wrong

		if (self.state == STATE_DISABLED) func_plat_go_down();
	}
};

void() func_plat_on = { // [FUNCTION]
	if (self.estate == ESTATE_ON) return; // Stop re-triggering ON state
	
	self.spawnflags = self.spawnflags - (self.spawnflags & ENT_STARTOFF); // No longer need this spawnflag, remove it
	self.estate = ESTATE_ON;
	self.movetype = MOVETYPE_PUSH;
	self.solid = SOLID_BSP;
	setmodel(self, self.mdl);
	if (self.state != STATE_DISABLED) { // Reset health, state and frame back to default
		setorigin(self, self.pos2);
		self.state = STATE_BOTTOM;
		self.think = SUB_Null;
	}
	
	if (self.spawnflags & PLAT_STARTDIS) { // If platform started disable, release to lower position
		self.spawnflags = self.spawnflags - (self.spawnflags & PLAT_STARTDIS); // No longer need this spawnflag, remove it
		if (self.state == STATE_DISABLED) func_plat_go_down();
	}	
};

void() func_plat_off = { // [FUNCTION]
	if (self.estate == ESTATE_OFF) return; // Stop re-triggering OFF state

	self.estate = ESTATE_OFF;
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	setmodel(self, "");
	StopSound(self,CHAN_VOICE); // Stop all movement sounds
	if (self.state != STATE_DISABLED) { // Reset health, position and frame back to default
		setorigin(self, self.pos2);
		self.state = STATE_BOTTOM;
		self.think = SUB_Null;
	}
};

// Lock platform in current location
void() func_plat_disable = { // [FUNCTION]	
	self.estate = ESTATE_DISABLE;
};

void() func_plat_blocked = { // [FUNCTION]	
	T_Damage(other, self, self, 1, DAMARMOR);
	if (self.state == STATE_UP) func_plat_go_down();
	else if (self.state == STATE_DOWN) func_plat_go_up();
};

// QUAKED func_plat (0 .5 .8) ? LOW_TRIGGER x MIN_TRIGGER START_LOWER START_OPEN x STARTOFF x
// A Platform (bmodel) with 2 states
// -------- KEYS --------
// targetname : = "" plat start low, != "" plat starts high and reqs trigger to work
// if using entity state system set START_LOWER spawnflags to fix this problem
// speed  : moving speed (def=150)
// height : determines the distance to move, instead of bmodel bounds
// sounds : 1=Base, 0 or 2=Medieval (def), 4=Silent, 5=Custom sounds
// noise  : custom sound - moving (looping)
// noise1 : custom sound - Stopped
// volume : Volume for all custom sounds played (def=1, range=0-1)
// _dirt       : -1 = will be excluded from dirtmapping
// _minlight   : Minimum light level for any surface of the brush model
// _mincolor   : Minimum light color for any surface (def='1 1 1' RGB)
// _shadow     : Will cast shadows on other models and itself
// _shadowself : Will cast shadows on itself
// -------- SPAWNFLAGS --------
// LOW_TRIGGER : touch trigger will not keep the platform at the top, will reset
// MIN_TRIGGER : uses the min bounding box (instead of max) to calculate trigger
// START_LOWER : will start the platform lower regardless of targetname
// START_OPEN : Used for lighting issues, place at bottom position
// STARTOFF : Starts off and waits for trigger
void() func_plat = { // [ENTITY]
	if (check_bmodel_keys()) return;	// Check for bmodel errors

	if (self.sounds == 0) self.sounds = 2; // default sound = medieval
	if (self.sounds == 1) {
		self.noise = "plats/plat1.wav";
		self.noise1 = "plats/plat2.wav";
	} else if (self.sounds == 2) {
		self.noise = "plats/medplat1.wav";
		self.noise1 = "plats/medplat2.wav";
	} else {
		if (self.noise == "" || self.sounds == 4) self.noise = SOUND_EMPTY; // sounds 4 = silent, sounds 5 = custom
		if (self.noise1 == "" || self.sounds == 4) self.noise1 = SOUND_EMPTY;
	}
	precache_sound(self.noise);
	precache_sound(self.noise1);
	SUB_BoundVolume(1);	
	self.classtype = CT_FUNCPLAT;
	self.classgroup = CG_FUNCMOVER;
	self.bsporigin = TRUE;
	self.mdl = self.model;
	self.mangle = self.angles; // save angles to mangle for use later by movement code
	self.angles = '0 0 0'; // angles has to be 0 0 0 otherwise brush model is twisted
	if (!self.t_length) self.t_length = 80; // This is not used anywhere, old code ideas from ID
	if (!self.t_width) self.t_width = 10;
	if (!self.speed) self.speed = 150;
	self.state = STATE_BOTTOM; // Default state (lower)
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	setorigin(self, self.origin);	
	setmodel(self, self.mdl);
	setsize (self, self.mins , self.maxs);
	if (self.targetname != "" && self.estate > 0) { // Check for any entity state setups (OFF/DISABLE).  Need targetname defined (can't active bmodel otherwise).
		if (self.estate == ESTATE_OFF) self.spawnflags = self.spawnflags | ENT_STARTOFF;
		if (self.estate == ESTATE_DISABLE) self.spawnflags = self.spawnflags | PLAT_STARTDIS;
	} else self.estate = ESTATE_ON; // Default state

	if (self.spawnflags & PLAT_STARTDIS && self.targetname == "") { // Cannot have a platform start off or disabled with no targetname, how can it be actived!?!
		dprint("\b[PLAT]\b Starting DISABLED with no targetname!  Removed disabled flag.\n");
		self.spawnflags = self.spawnflags - PLAT_STARTDIS;
		self.estate = ESTATE_ON;
	}

	if (self.spawnflags & ENT_STARTOFF && self.targetname == "") {
		dprint("\b[PLAT]\b Starting OFF with no targetname! Going ahead and turning on.\n");
		self.spawnflags = self.spawnflags - ENT_STARTOFF;
		self.estate = ESTATE_ON;
	}	
	
	if (check_nightmare() == TRUE) return; // Check for spawning conditions (nightmare, coop).  Needs to exist after entity has been added to work for BSPorigin.
	if (check_coop() == TRUE) return;
	
	// Move the platform up to open position (lighting issues)
	// Need to update mins/maxs so that spawn trigger is correct
	// otherwise it will be in original position and spawn low
	if (self.spawnflags & PLAT_START_OPEN) {
		self.origin_z = self.origin_z + self.height;
		self.mins_z = self.mins_z + self.height;
		self.maxs_z = self.maxs_z + self.height;
	}

	self.pos1 = self.pos2 = self.origin; // pos1 is the top position, pos2 is the bottom
	if (self.height) self.pos2_z = self.origin_z - fabs(self.height); // self.height cannot be a negative, min/maxs will be back-to-front
	else self.pos2_z = self.origin_z - self.size_z + 8;

	func_plat_trigger_spawn(); // Setup touch trigger and block function
	self.blocked = func_plat_blocked;
	
	// Annoying that the targetname is being used like this because
	// there could have been a better way to do this type of functionality
	// == "" Platform starts in lower position (default)
	// != "" Platform starts in upper position and requires trigger to work
	if (self.targetname != "" && !(self.spawnflags & PLAT_START_LOWER)) self.state = STATE_DISABLED;
	else setorigin(self, self.pos2);	// Start in lower position
	
	if (self.targetname != "") self.use = entity_state_use; // Setup Entity State functionality
	self.estate_on = func_plat_on;
	self.estate_off = func_plat_off;
	self.estate_use = func_plat_use;
	self.estate_disable = func_plat_disable;
	if (self.spawnflags & PLAT_STARTDIS) self.estate_disable(); // Check for the easy way to start a platform disabled
	else if (self.spawnflags & ENT_STARTOFF) self.estate_off(); // Check for starting override for entity state
	else self.estate_on();
};