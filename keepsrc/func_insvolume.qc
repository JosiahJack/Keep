//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: All, see credits folder
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
// Function count: 8
//
// Implements: func_insidevolume
//
// Description:
// Causes targets to fire when entities are inside the volume, partially
// inside the volume, and/or exiting the volume.  Super useful!
//=============================================================================

float FUNC_INSVOLPLAYER = 1;
float FUNC_INSVOLMONSTER = 2;
float FUNC_INSVOLITEM = 4;
float FUNC_INSVOLPUSHABLE = 8;

float(entity targ) func_insvolume_check = { // [FUNCTION]
	local vector targ_mins, targ_maxs;
	
	// Is the touching entity linked to anthing?
	if (targ.touching == world) return TRUE;
	
	// Is the touching entity linked to this inside volume?
	// Don't reset the touching entity, its being tested by something else
	if (targ.touching != self.owner) return TRUE;

	// Has the touching entity been switch off/disabled
	if (targ.estate & ESTATE_BLOCK) { targ.touching = world; return TRUE; }
	
	// Check for dead monsters and removed them from entity list
	if (targ.flags & FL_MONSTER) {
		if (self.owner.no_deadbody == 1 && targ.health < 1) { 
			targ.touching = world; 
			return TRUE;
		}
	}

	// Find entity origin
	if (targ.bsporigin) {
		// Bmodel origin is stored differently
		self.owner.pos3 = bmodel_origin(targ);
		// Min/max are only updated when spawned, use size instead
		targ_mins = self.owner.pos3 - (targ.size*0.5);
		targ_maxs = self.owner.pos3 + (targ.size*0.5);
	}
	else {
		// Point entity uses origin key
		self.owner.pos3 = targ.origin;
		// Min/max are created when spawned
		targ_mins = self.owner.pos3 + targ.mins;
		targ_maxs = self.owner.pos3 + targ.maxs;
	}

	// Test OUTSIDE space (targ max < trigger min)
	if (targ_maxs_x < self.owner.dest1_x || targ_maxs_y < self.owner.dest1_y ||
		targ_maxs_z < self.owner.dest1_z) {
		//dprint("ENT outside MINS\n");
		targ.touching = world; 
		self.owner.targetnumber = NEGATIVE;
		return TRUE;
	}
	// Test OUTSIDE space (targ min > trigger max)
	if (targ_mins_x > self.owner.dest2_x || targ_mins_y > self.owner.dest2_y ||
		targ_mins_z > self.owner.dest2_z) {
		//dprint("ENT outside MAXS\n");
		targ.touching = world; 
		self.owner.targetnumber = NEGATIVE;
		return TRUE;
	}

	// Test INSIDE space (targ min < trigger min)
	if (targ_mins_x < self.owner.dest1_x) return FALSE;
	if (targ_mins_y < self.owner.dest1_y) return FALSE;
	if (targ_mins_z < self.owner.dest1_z) return FALSE;
	
	// Test INSIDE space (targ max > trigger max)
	if (targ_maxs_x > self.owner.dest2_x) return FALSE;
	if (targ_maxs_y > self.owner.dest2_y) return FALSE;
	if (targ_maxs_z > self.owner.dest2_z) return FALSE;

	self.owner.targetnumber = TRUE; // Finally something INSIDE the volume!
	return FALSE;
};

void(entity targ) func_insvolume_add = { // [FUNCTION]
	if (self.tno1 == world) { self.tno1 = targ; targ.touching = self; }
	else if (self.tno2 == world) { self.tno2 = targ; targ.touching = self; }
	else if (self.tno3 == world) { self.tno3 = targ; targ.touching = self; }
	else if (self.tno4 == world) { self.tno4 = targ; targ.touching = self; }
	else if (self.tno5 == world) { self.tno5 = targ; targ.touching = self; }
	else {
		// A warning message for mappers to ignore! :P
		if (self.pain_finished < time) {
			self.pain_finished = time + 3;
			if (developer > 1) dprint("\b[INSVOL]\b More than 5 entities touching!\n");
		}
	}
};

void() func_insvolume_touch = { // [FUNCTION]
	if (self.estate & ESTATE_BLOCK) return; // Block functionality if state wrong
	if (other.touching == self) return; // Already checking this (other) entity?

	// Check for an exact entity condition
	if (self.message2 != "") { 
		// Is the touching entity the correct entity?
		if (self.message2 != other.targetname) return;
	}

	self.lefty = FALSE; // Default = no touch

	// Test for all the different entity types
	if (self.spawnflags & FUNC_INSVOLPLAYER && other.flags & FL_CLIENT) self.lefty = TRUE;
	else if (self.spawnflags & FUNC_INSVOLMONSTER && other.flags & FL_MONSTER) {
		if (self.no_deadbody == 0) self.lefty = TRUE; // Test for dead/living monsters?
		else if (self.no_deadbody == 1 && other.health > 0)  self.lefty = TRUE;
	} else if (self.spawnflags & FUNC_INSVOLITEM && other.flags & FL_ITEM) self.lefty = TRUE;
	else if (self.spawnflags & FUNC_INSVOLPUSHABLE && other.classtype == CT_FUNCPUSHABLE) self.lefty = TRUE;
	
	if (self.lefty == FALSE) return; // If wrong type touching volume?

	// Add entity to volume list to keep checking
	if (other.touching == world) func_insvolume_add(other);
};

void() func_insvolume_on = { // [FUNCTION]
	if (self.estate == ESTATE_ON) return; // Stop re-triggering ON state

	self.spawnflags = self.spawnflags - (self.spawnflags & ENT_STARTOFF); // No longer need this spawnflag, remove it
	self.estate = ESTATE_ON;
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_TRIGGER;
	setsize (self, self.bbmins, self.bbmaxs);
};

void() func_insvolume_off = { // [FUNCTION]
	if (self.estate == ESTATE_OFF) return; // Stop re-triggering OFF state

	self.estate = ESTATE_OFF;
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	setsize (self, VEC_ORIGIN, VEC_ORIGIN);
};

void() func_insvolume_controller_think = { // [FUNCTION]
	self.think = func_insvolume_controller_think; // Keep the controller looping
	self.nextthink = time + 0.1;
	self.owner.targetnumber = FALSE;

	if (self.owner.estate & ESTATE_BLOCK) return; // If switched off/disabled

	// If no entities touching volume, do nothing.  This is a way to slow down the constant triggering
	if (self.owner.tno1 != world || self.owner.tno2 != world ||
		self.owner.tno3 != world || self.owner.tno4 != world ||
		self.owner.tno5 != world) {
	
		// Go through the entities touching this volume
		if (func_insvolume_check(self.owner.tno1) == TRUE) self.owner.tno1 = world;
		if (func_insvolume_check(self.owner.tno2) == TRUE) self.owner.tno2 = world;
		if (func_insvolume_check(self.owner.tno3) == TRUE) self.owner.tno3 = world;
		if (func_insvolume_check(self.owner.tno4) == TRUE) self.owner.tno4 = world;
		if (func_insvolume_check(self.owner.tno5) == TRUE) self.owner.tno5 = world;
		
		// Any entities pass the volume test? (FULL, PARTIAL and EXIT)
		if (self.owner.targetnumber == TRUE) {
			// FULLY inside the volume
			if (self.owner.target != "") { // No need to check all targets, special setup for 3 states.
				trigger_strs(self.owner.target, self.owner);
				if (self.owner.wait < 0) self.owner.target = "";
			}
		} else if (self.owner.targetnumber == NEGATIVE) {
			// Just EXIT the volume
			if (self.owner.message != "") { // No need to check all targets, special setup for 3 states.
				trigger_strs(self.owner.message, self.owner);
				if (self.owner.wait < 0) self.owner.message = "";
			}
		} else {
			// PARTIALLY inside the volume
			if (self.owner.target2 != "") { // No need to check all targets, special setup for 3 states.
				trigger_strs(self.owner.target2, self.owner);
			}
		}
	}
};

void() func_insvolume_controller_setup = { // [FUNCTION]
	if (!self.attachment) self.attachment = spawn(); // Check if controller entity been setup
	self.attachment.owner = self; // Setup link back to inside volume
	self.attachment.classtype = CT_CONTROL;
	self.attachment.movetype = MOVETYPE_NONE;
	self.attachment.solid = SOLID_NOT;
	self.oldorigin = bmodel_origin(self); // Setup controller above model origin location
	setorigin(self.attachment, self.oldorigin + '0 0 32');
	setsize (self.attachment, VEC_ORIGIN, VEC_ORIGIN);
	self.attachment.think = func_insvolume_controller_think; // Start controller think loop
	self.attachment.nextthink = time + 0.1 + self.delay;
};

// QUAKED func_insidevolume (0 .5 .8) ? PLAYER MONSTER ITEM PUSHABLE x x STARTOFF x Not_Easy Not_Normal Not_Hard Not_DM
// Function to test if an entity bounding box is inside of this volume
// -------- KEYS --------
// targetname : trigger entity (works with entity state system)
// target  : Name of target(s) to trigger when fully INSIDE (fires every 0.1s)
// target2 : Name of target(s) to trigger when partial INSIDE (fires every 0.1s)
// message : Name of target(s) to trigger when exit VOLUME (fires on exit only)
// wait    : -1 = Fire the fully/exit volume target(s) once
// delay   : Delay time before volume controller becomes active
// message2: Name of the only entity that can interact with this volume
// no_deadbody : 1 = Monster dead bodies don't work with volume test
// -------- SPAWNFLAGS --------
// PLAYER    : Will react to player(s)
// MONSTER   : Will react to monster(s)
// ITEM      : Will react to item(s)
// PUSHABLE  : Will react to pushable(s)
// STARTOFF  : Starts off and waits for trigger
// -------- NOTES --------
// Function to test if an entity bounding box is inside of this volume
void() func_insidevolume = { // [ENTITY]
	if (check_bmodel_keys()) return;	// Check for bmodel errors

	// No trigger/movement angles
	self.angles = '0 0 0'; self.movedir = '0 0 0';

	self.classtype = CT_FUNCINSVOLUME;
	self.nodebuginfo = TRUE;
	
	// Setup like a trigger in the map
	InitTrigger();
	setsize (self, self.bbmins, self.bbmaxs);
	
	// Work out actual world origin coordinates
	self.pos1 = self.size * 0.5;
	self.pos2 = bmodel_origin(self);
	
	// Setup trigger boundary edges
	self.dest1 = self.pos2 - self.pos1;
	self.dest2 = self.pos2 + self.pos1;
	
	// Block all trigger extra parameters (not needed)
	self.health = self.max_health = 0;
	self.takedamage = DAMAGE_NO;
	if (self.delay < 0) self.delay = 0;
	
	// Reset all touch entities to monitor
	self.tno1 = self.tno2 = self.tno3 = self.tno4 = self.tno5 = world;

	// Check for spawning conditions (nightmare, coop)
	// Needs to exist after entity has been added to work for BSPorigin
	if (check_nightmare() == TRUE) return;
	if (check_coop() == TRUE) return;
	
	// Setup Entity State functionality
	if (self.targetname != "") self.use = entity_state_use;
	self.estate_on = func_insvolume_on;
	self.estate_off = func_insvolume_off;
	self.touch = func_insvolume_touch;
	
	// Check for starting off or default=on
	if (self.spawnflags & ENT_STARTOFF) self.estate_off();
	else self.estate_on();
	
	// Setup volume controller (tests volumes)
	self.think = func_insvolume_controller_setup;
	self.nextthink = time + 0.2;	
};