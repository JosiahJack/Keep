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
// Implements: Buttons
//
// Description:
// Moving brush models intended for use as buttons.  Move on touch or shoot if
// they have health.  Buttons target something when activated.
//
// Buttons start out and can be pressed in.  The in state stays if wait is -1.
//=============================================================================

float BUTTON_STARTDIS = 32; // Button starts in disabled state

void() func_button_angletarget = { // [FUNCTION]
	TargetMovedir(self, TRUE); // Use sub function and return movetarget/dest1 values
	self.dest2 = self.oldorigin; // Need to use original spawn location because block functionality will have the func_button in between state positions (origin).
	if (self.height) { // Check for height plat movement system instead
		self.dest2 = self.dest2 - (self.size*0.5); // Convert self dest2 to func_train corner bottom left offset)
		self.movedir = normalize(self.dest1 - self.dest2); // re-calculate the movedir (bec of self origin is different).  dest1 should be setup in TargetMovedir function
		self.pos2 = self.pos1 + (self.movedir * self.height); // Simple movement along vector length (no lip changes).  Not easy to predict in the editor because its the long side of a trangle (other corners are func_button/angletarget).
	} else self.pos2 = self.pos1 + (self.dest1 - self.dest2) + (self.size*0.5); // Work out destination (using func_train bottom left offset)	
};

void() func_button_final_setup = { // [FUNCTION]
	if (self.angletarget != "") func_door_angletarget(); // Upate second position based on angletarget	
	
	if (self.spawnflags & BUTTON_STARTDIS) self.estate_disable(); // Check for the easy way to start a button disabled
	else if (self.estate & ESTATE_LOWER) { // Check for starting override for entity state
		if (self.estate == 1) self.estate_on();
		else if (self.estate == 2) { // Check fixed values (not ideal bec estate value could change)
			self.estate = ESTATE_ON; // Make sure off function works, start with on state
			self.estate_off();
		} else if (self.estate == 4) self.estate_disable();
	} else {
		if (self.spawnflags & ENT_STARTOFF) self.estate_off(); // Check for starting off or default=on
		else self.estate_on();
	}
};

// Phase 4 - Button CLOSED
void() func_button_done = { // [FUNCTION]
	self.frame = 0;	// Use normal textures
	self.state = STATE_BOTTOM; 
	if (self.health) self.takedamage = DAMAGE_YES;
};

// Phase 3 - Button Closing
void() func_button_return = { // [FUNCTION]
	self.state = STATE_DOWN; // Should the state be set outside of estate check?
	if (self.estate & ESTATE_BLOCK) return;
	if (self.noise1) sound(self,CHAN_VOICE, self.noise1, self.volume,ATTN_NORM);
	SUB_CalcMove (self.pos1, self.yaw_speed, func_button_done); // Add - return speed can now be different, yaw_speed = speed if nothing defined.
};

// Phase 2 - Button OPEN
void() func_button_wait = { // [FUNCTION]
	self.state = STATE_TOP; // Should the state be set outside of estate check?
	if (self.estate & ESTATE_BLOCK) return;
	self.nextthink = self.ltime + self.wait;
	self.think = func_button_return;
	activator = self.enemy;
	SUB_UseTargets();
	self.frame = 1;			// use alternate textures
};

// Phase 1 - Button Opening
void() func_button_fire = { // [FUNCTION]
	if (self.estate & ESTATE_BLOCK) return;
	if (self.state == STATE_UP || self.state == STATE_TOP) return;

	// Check for custom movement angle.  Always re-calculate to allow for updated movement.
	if (self.angletarget != "") {
		self.movetarget = find(world, targetname, self.angletarget); // Find the angle target entity
		self.dest1 = bmodel_origin(self); // Find origins of source/target entities
		if (self.movetarget.bsporigin) self.dest2 = bmodel_origin(self.movetarget);
		else self.dest2 = self.movetarget.origin;
		
		self.pos2 = self.pos1 + (self.dest2 - self.dest1) + (self.size*0.5); // Work out destination (using func_train bottom left offset)
	}

	self.state = STATE_UP;
	sound(self,CHAN_VOICE, self.noise, self.volume,ATTN_NORM);
	SUB_CalcMove (self.pos2, self.speed, func_button_wait);
};

void() func_button_use = { // [FUNCTION]
	if (self.spawnflags & ENT_STARTOFF) self.estate_on(); // Deal with DELAY functionality first
	else {
		if (self.estate & ESTATE_BLOCK) return; // Block USE functionality if state wrong

		self.enemy = other;
		func_button_fire();
	}
};

// Default state for buttons, touch trigger
void() func_button_touch = { // [FUNCTION]
	if (!(other.flags & FL_CLIENT)) return;

	self.enemy = other;
	func_button_fire();
};

// Only active if health set on trigger, touch function disabled
void() func_button_killed = { // [FUNCTION]
	self.enemy = damage_attacker;
	self.health = self.max_health;
	self.takedamage = DAMAGE_NO;	// wil be reset upon return
	func_button_fire();
};

void() func_button_on = { // [FUNCTION]
	if (self.estate == ESTATE_ON) return; // Stop re-triggering ON state

	self.spawnflags = self.spawnflags - (self.spawnflags & ENT_STARTOFF); // No longer need this spawnflag, remove it
	self.estate = ESTATE_ON;
	self.movetype = MOVETYPE_PUSH;
	self.solid = SOLID_BSP;
	setmodel(self, self.mdl);
	setorigin(self, self.pos1); // Reset health, state and frame back to default
	self.state = STATE_BOTTOM;
	self.think = SUB_Null;
	self.frame = 0;
	if (self.max_health) { // reset health and damage trigger
		self.health = self.max_health;
		self.th_die = func_button_killed;
		self.takedamage = DAMAGE_YES;
	}
};

void() func_button_off = { // [FUNCTION]
	if (self.estate == ESTATE_OFF) return; // Stop re-triggering OFF state

	self.estate = ESTATE_OFF;
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	setmodel(self, "");
	StopSound(self,CHAN_VOICE); // Reset health, position and frame back to default
	self.takedamage = DAMAGE_NO;
	setorigin(self, self.pos1);
	self.state = STATE_BOTTOM;
	self.think = SUB_Null;
	self.frame = 0;
};

void() func_button_disable = { // [FUNCTION]
	self.estate = ESTATE_DISABLE; // Block damage function and show alternative texture
	self.takedamage = DAMAGE_NO;
	self.frame = 1;
	SUB_CalcMove (self.pos2, self.speed, func_button_wait); // Make sure the button is moved to finished state
};

// QUAKED func_button (0 .5 .8) ? x x x x x STARTDIS STARTOFF x Not_Easy Not_Normal Not_Hard Not_DM
// -------- KEYS --------
// targetname  : trigger entity (works with entity state system)
// target      : name of target(s) to trigger at the start of the wait phase
// target2     : additional target(s) to trigger when activated
// angle       : determines the move direction, use "360" for angle 0
// angletarget : Entity (path_corner) to move towards (custom direction)
// speed       : Move Speed (def=40)
// yaw_speed   : return movement speed (def=speed)
// wait        : wait before returning (def=1, -1 = never return)
// delay       : delay before button triggers
// lip         : lip remaining at end of move. (def=4)
// height      : Exact distance to move (works like func_plat and uses angles)
// health      : Can be damaged instead of touched
// noradiusdmg : Can not be damaged by splashdamage, direct damage only
// sounds      : 0=steam metal, 1=wooden, 2=metallic, 3=in-out, 4=Silent, 5=Custom
// noise       : custom sound - 1st movement
// noise1      : custom sound - 2nd movement ('buttons/switch21.wav')
// volume      : Volume for all custom sounds played (def=1, range=0-1)
// message     : Centerprint Message to display when triggered
// estate      : Override starting entity state 1=ON, 2=OFF, 4=DISABLE
// _dirt       : -1 = will be excluded from dirtmapping
// _minlight   : Minimum light level for any surface of the brush model
// _mincolor   : Minimum light color for any surface (def='1 1 1' RGB)
// _shadow     : Will cast shadows on other models and itself
// _shadowself : Will cast shadows on itself
// -------- SPAWNFLAGS --------
// STARTDIS : Starts disabled and waits for trigger
// STARTOFF : Starts off and waits for trigger
// -------- NOTES --------
// Button (bmodel) with two states
void() func_button = { // [ENTITY]
	if (check_bmodel_keys()) return;	// Check for bmodel errors

	if (self.noise == "") self.noise = SOUND_EMPTY; // Setup all empty/silent sound files first
	if (self.sounds == 0) self.noise = "buttons/airbut1.wav"; // Default 0 = air button
	else if (self.sounds == 1) self.noise = "buttons/switch21.wav";
	else if (self.sounds == 2) self.noise = "buttons/switch02.wav";
	else if (self.sounds == 3) self.noise = "buttons/switch04.wav";
	else if (self.sounds == 4) self.noise = SOUND_EMPTY;
	precache_sound(self.noise);
	if (self.noise1 != "") precache_sound(self.noise1);
	SUB_BoundSoundVolume(1);
	self.classtype = CT_FUNCBUTTON;
	self.classgroup = CG_FUNCMOVER;
	self.bsporigin = TRUE;
	self.mdl = self.model;
	if (self.angles_y == 0) self.angles_y = 360;
	SetMovedir();	// Setup move direction base on angles
	if (!self.speed) self.speed = 40; // Default parameters and states
	if (!self.yaw_speed) self.yaw_speed = self.speed; // Second movement speed can be different, yaw_speed
	if (!self.wait) self.wait = 1;
	if (!self.lip) self.lip = 4;
	self.state = STATE_BOTTOM;
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	setmodel(self, self.mdl); // Add bmodel to world and work out movement positions
	setorigin(self, self.origin);
	setsize (self, self.mins , self.maxs);
	self.pos1 = self.origin;
	self.oldorigin = bmodel_origin(self);
	if (check_nightmare() == TRUE) { entity_hide(self); return; } // Check for spawning conditions (nightmare, coop).  Needs to exist after entity has been added to work for BSPorigin.
	if (check_coop() == TRUE) { entity_hide(self); return; }
	if (self.height > 0) self.pos2 = self.pos1 + (self.movedir*self.height); // Check if height is defined? (used by func_plat).  Much easier system to setup, instead of voodoo lip magic!
	else self.pos2 = self.pos1 + self.movedir*(fabs(self.movedir*self.size) - self.lip); // Default movement system = move direction * (size - lip)
	
	if (self.spawnflags & BUTTON_STARTDIS && self.targetname == "") { // Cannot have a button start off or disabled with no targetname, how can it be actived!?!  Just use a plain wall otherwise.
		dprint("\b[BUTTON]\b Starting DISABLED with no targetname!\n");
		spawn_marker(self.oldorigin,'0 0 0',0,SPNMARK_YELLOW);
		entity_hide(self);
		return;
	}
	
	if (self.spawnflags & ENT_STARTOFF && self.targetname == "") {
		dprint("\b[BUTTON]\b Starting OFF with no targetname!\n");
		spawn_marker(self.oldorigin,'0 0 0',0,SPNMARK_YELLOW);
		entity_hide(self);
		return;
	}	

	// Can either shoot a button or touch it, never both
	if (self.health) {
		self.max_health = self.health;
		self.th_die = func_button_killed;
		self.takedamage = DAMAGE_YES;
	} else self.touch = func_button_touch; // Important OR condition (touching only)

	self.blocked = SUB_Null; // do nothing, just don't come all the way back out
	if (self.targetname != "") self.use = entity_state_use; // Setup Entity State functionality
	self.estate_on = func_button_on;
	self.estate_off = func_button_off;
	self.estate_use = func_button_use;
	self.estate_disable = func_button_disable;
	if (self.angletarget != "") { // Need spawn delay if using angletarget (target not ready)
		self.think = func_button_final_setup; // Check for any final setup conditions
		self.nextthink = self.ltime + 0.1;
	} else func_button_final_setup(); // Original setup, no delay on spawn
};