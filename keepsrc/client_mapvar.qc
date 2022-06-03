//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: Arcane Dimensions (AD) and Qmaster
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
// Entity count: 7
// Function count: 11
//
// Implements: Mapvar System for remembering states across levels.
//
// Description:
// Allows for binary (0/1) map variables to be stored with the map save system
// by the engine. Some parm variables were unused and turned into variables for
// the map to use.  Useful to travel back and forth between levels or hubs and
// have various things opened or active when returning.
//
// Also includes my entities for my own global state system that does the same
// thing.  More the merrier. -Qmaster
//
// Also includes logic_auto for automatic triggering at map start.
//=============================================================================

float MAPV_BITS = 22;			// Bits used in each parm block
float MAPV_BLCK = 6;			// Blocks used (total parm's)
float MAPV_TOTAL = 132;			// Maximum amount of variables
float MAPV_QUERY = 1;			// Point entity - Query value
float MAPV_UPDATE = 2;			// Point entity - Update value
float MAPV_TOGGLE = 4;			// Point entity - Toggle value
float MAPV_MONSTERS = 32;		// Monsters can use bmodel trigger
float bitflags[24];				// Bitflag values
float mapvar[6];				// Map variables stored in savefile

// Setup the bitflag array (used in world.qc)
void() mapvar_setuparray = { // [FUNCTION]
	local float bitindex, bitpow;

	bitindex = 0; bitpow = 1; // Setup loop and first bit
	while (bitindex < 24) {
		bitflags[bitindex] = bitpow;
		bitpow = bitpow * 2;
		bitindex = bitindex + 1;
	}
};

// Reset all map variable banks to zero (used in client.qc)
void() mapvar_reset = { // [FUNCTION]
	local float mapv_bank;
	
	mapv_bank = 0;
	while (mapv_bank < MAPV_BLCK) {
		mapvar[mapv_bank] = 0;
		mapv_bank = mapv_bank + 1;
	}
};

// Read map variable from block/bits parms and return value
float(float mapv_indx) query_mapvar = { // [FUNCTION]
	local float mapv_bank, mapv_cell, mapv_bit;

	mapv_bank = floor(mapv_indx/MAPV_BITS); // Work out parm and bitflag index
	mapv_cell = mapv_indx - (mapv_bank*MAPV_BITS);
	if (mapv_bank < 0 || mapv_bank >= MAPV_BLCK) mapv_bank = 0; // Error check return value
	if (mapv_cell < 0 || mapv_cell >= MAPV_BITS) mapv_cell = 0;
	mapv_bit = mapvar[mapv_bank] & bitflags[mapv_cell]; // Find bitflag mask value
	if (mapv_bit > 0) return TRUE;
	else return FALSE;
};

// Update map variable from block/bits parms
void(float mapv_indx, float mapv_val) update_mapvar = { // [FUNCTION]
	local float mapv_bank, mapv_cell;

	mapv_bank = floor(mapv_indx/MAPV_BITS); // Work out parm and bitflag index
	mapv_cell = mapv_indx - (mapv_bank*MAPV_BITS);
	if (mapv_bank < 0 || mapv_bank >= MAPV_BLCK) mapv_bank = 0; // Error check return value
	if (mapv_cell < 0 || mapv_cell >= MAPV_BITS) mapv_cell = 0;
	mapvar[mapv_bank] = mapvar[mapv_bank] - (mapvar[mapv_bank] & bitflags[mapv_cell]); // Remove any existing bitflag value
	if (mapv_val == TRUE) mapvar[mapv_bank] = mapvar[mapv_bank] | bitflags[mapv_cell]; // Is the bit value TRUE?
};

// Set a range of map variables (used in triggers.qc)
void(vector mapv_range) mapvar_range = { // [FUNCTION]
	local vector mapv_dest;
	local float mapv_swap, mapv_loop;
	
	mapv_dest_x = fabs(rint(mapv_range_x)); // Remove any negative or fractions
	mapv_dest_y = fabs(rint(mapv_range_y));
	mapv_dest_z = fabs(rint(mapv_range_z));

	
	if (mapv_dest_x >= (MAPV_BLCK*MAPV_BITS)) mapv_dest_x = (MAPV_BLCK*MAPV_BITS) - 1; // Check for upper variable range
	if (mapv_dest_y >= (MAPV_BLCK*MAPV_BITS)) mapv_dest_y = (MAPV_BLCK*MAPV_BITS) - 1;
	if (mapv_dest_z > 1) mapv_dest_z = 1;

	// Check for reverse order on range
	if (mapv_dest_x > mapv_dest_y) {
		mapv_swap = mapv_dest_x;
		mapv_dest_x = mapv_dest_y;
		mapv_dest_y = mapv_swap;
	}

	mapv_loop = mapv_dest_x;
	while (mapv_loop <= mapv_dest_y) { // Count through range
		update_mapvar(mapv_loop, mapv_dest_z); // Change map variable
		mapv_loop = mapv_loop + 1;
	}
};

// Display the value of all map variable parm blocks
void() display_mapvar = { // [FUNCTION]
	local float loopbank, loopcell, loopspace, loopval;

	if ( !(self.flags & FL_CLIENT) ) return; // Default return conditions (must be player and developer)
	if (!mapvar_cvar) { sprint(self,"\b[MAPVAR]\b System has not been setup yet!\n"); return; } // Has the map variable system been setup?
	self.impulse = 0; // Reset impulse and initialize variables
	loopbank = loopcell = 0;
	dprint("\n\b[MAPVAR]\b Current System Values\n"); 
	dprint("--------------------------------------\n");
	while (loopbank < MAPV_BLCK) {
		dprint("Bank "); dprint(ftos(loopbank)); dprint(" - ");
		loopcell = 0; loopspace = 4;
		while (loopcell < MAPV_BITS) {
			loopval = query_mapvar((loopbank*MAPV_BITS)+loopcell);
			dprint(ftos(loopval));
			loopcell = loopcell+1;
			if (loopcell == loopspace) { dprint(" "); loopspace = loopspace+4; }
		}
		dprint("\n");
		loopbank = loopbank+1;
	}
	dprint("--------------------------------------\n");
};

void() trigger_mapvar_base_use = { // [FUNCTION]
	if (self.estate & ESTATE_BLOCK) return; // Block entity state exceptions
	if (self.attack_finished > time) return; // Is the trigger blocked? (trigger_once)

	if (self.style == MAPV_UPDATE) { // UPDATE : Map Variable
		self.lefty = self.cnt;
		update_mapvar(self.count, self.cnt);
	} else if (self.style == MAPV_TOGGLE) { // TOGGLE : map variable
		self.lefty = query_mapvar(self.count);
		self.lefty = 1 - self.lefty;
		update_mapvar(self.count, self.lefty);
	} else { // QUERY : map variable
		self.lefty = query_mapvar(self.count);
	}

	if (self.lefty == FALSE) { // Check for On/Off target(s)
		if (self.target != "") trigger_strs(self.target, activator); // Special target and...
	} else {
		if (self.target2 != "") trigger_strs(self.target2, activator); // target2 use only, no other targets checks needed.
	}

	// Check for switchable bmodel
	if (self.noise != "") {
		if (!self.oldenemy) self.oldenemy = find(world, targetname, self.noise); // Check if entity exists first

		// Only work with Bmodel entities (usually aframes)
		if (self.oldenemy.bsporigin) {
			if (self.lefty == TRUE) self.oldenemy.frame = 0; // Flashing (ON) is +0frame ; Static (OFF) is +aframe
			else self.oldenemy.frame = 1;
		}
	}

	// Check for fire once condition and wait timer
	if (self.wait < 0) self.attack_finished = LARGE_TIMER;
	else self.attack_finished = time + self.wait;
};

void() trigger_mapvar_base = { // [FUNCTION]
	if (self.targetname == "") dprint("\b[MAPVAR]\b Missing targetname!\n"); // Check for any missing keys
	self.count = fabs(rint(self.count)); // Remove any negative or fractions
	if (self.count >= (MAPV_BLCK*MAPV_BITS)) self.count = (MAPV_BLCK*MAPV_BITS) - 1; // Check for upper variable range
	if (self.cnt < FALSE || self.cnt > TRUE) self.cnt = FALSE; // Check for bitflag value range
	if (self.targetname != "") self.use = entity_state_use; // Setup Entity State functionality
	self.estate_use = trigger_mapvar_base_use;
	self.estate = ESTATE_ON;
};

// QUAKED trigger_mapvar_query (.5 .7 1) (-8 -8 -16) (8 8 16) x
// -------- KEYS --------
// targetname : trigger entity (works with entity state system)
// count   : Map Variable to check (range checks)
// target  : Map variable == 0 fire these target(s)
// target2 : Map variable == 1 fire these target(s)
// noise   : aframe switchable object
// wait    : -1 = trigger once
// -------- NOTES --------
// Trigger target(s) based on mapvar
void() trigger_mapvar_query = { // [ENTITY]
	self.classtype = CT_MAPVAR;
	self.style = MAPV_QUERY;
	trigger_mapvar_base();
};

// QUAKED trigger_mapvar_update (.5 .7 1) (-8 -8 -16) (8 8 16) x
// -------- KEYS --------
// targetname : trigger entity (works with entity state system)
// count   : Map Variable to check (range checks)
// cnt     : Value (0/1)
// target  : Map variable == 0 fire these target(s)
// target2 : Map variable == 1 fire these target(s)
// noise   : aframe switchable object
// wait    : -1 = trigger once
// -------- NOTES --------
// Update the value of mapvar
void() trigger_mapvar_update = { // [ENTITY]
	self.classtype = CT_MAPVAR;
	self.style = MAPV_UPDATE;
	trigger_mapvar_base();
};

// QUAKED trigger_mapvar_toggle (.5 .7 1) (-8 -8 -16) (8 8 16) x
// -------- KEYS --------
// targetname : trigger entity (works with entity state system)
// count   : Map Variable to check (range checks)
// target  : Map variable == 0 fire these target(s)
// target2 : Map variable == 1 fire these target(s)
// noise   : aframe switchable object
// wait    : -1 = trigger once
// -------- NOTES --------
// Toggle the value of mapvar
void() trigger_mapvar_toggle = { // [ENTITY]
	self.classtype = CT_MAPVAR;
	self.style = MAPV_TOGGLE;	
	trigger_mapvar_base();
};

void() trigger_mapvar_multiple_fire = { // [FUNCTION]
	if (self.attack_finished > time) return;	// Trigger once?

	self.lefty = query_mapvar(self.count); // Find out map variable value
	if (self.lefty == FALSE) {
		self.target = self.idle_sound; // Switch around target/message strings
		self.message = self.idle_soundcom;
	} else {
		self.target = self.idle_sound2; // Switch around target/message strings
		self.message = self.idle_soundcom2;
	}
	
	if (self.noise != "") sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM); // Play the sound ON the trigger, NOT the activator
	activator = self.bmodel_act; // Original trigger_multiple activator behaviour
	SUB_UseTargets(); 
	if (self.wait > 0) { // Is the trigger repeatable?
		self.attack_finished = time + self.wait;
		self.nextthink = self.attack_finished;
		self.think = self.estate_on;
	} else {
		self.attack_finished = LARGE_TIMER; // TRIGGER_ONCE functionality
		self.estate_off();
	}
};

// QUAKED trigger_mapvar_multiple (0.5 0 0.5) ? x x x x x MONSTERS STARTOFF x Not_Easy Not_Normal Not_Hard Not_DM
// ------- KEYS --------
// targetname : trigger entity (works with entity state system)
// count   : Map Variable to check (range checks)
// target  : Map variable == 0 fire these target(s)
// message : Map variable == 0 message to display
// target2 : Map variable == 1 fire these target(s)
// message2: Map variable == 1 message to display
// health  : Can be damaged instead of touched
// wait    : time between re-triggering
// delay   : delay before firing (after being triggered)
// angle   : Facing Direction for trigger to work, use "360" for angle 0.
// sounds  : 1=Secret,2=talk(def),3=switch,4=silent,5=custom,6=secret2
// noise   : custom sound to play when triggered
// -------- SPAWNFLAGS --------
// MONSTER  : can be touched/triggered by monsters
// STARTOFF : Requires trigger to activate
// ------- NOTES --------
// Touch trigger target(s) based on mapvar
void() trigger_mapvar_multiple = { // [ENTITY]
	if (check_bmodel_keys()) return;	// Check for bmodel errors

	self.lefty = 0; // Remove excessive spawnflags not used
	if (self.spawnflags & MAPV_MONSTERS) self.lefty = self.lefty | MAPV_MONSTERS;
	if (self.spawnflags & ENT_STARTOFF) self.lefty = self.lefty | ENT_STARTOFF;
	self.spawnflags = self.lefty;
	self.count = fabs(rint(self.count)); // Remove any negative or fractions
	if (self.count >= (MAPV_BLCK*MAPV_BITS)) self.count = (MAPV_BLCK*MAPV_BITS) - 1; // Check for upper variable range
	trigger_bmodel_sounds(); // Typical bmodel trigger setup
	self.classtype = CT_MAPVAR;
	InitTrigger ();
	if (!self.wait) self.wait = 0.2;
	self.idle_sound = self.target; // Save all entity targets for later
	self.idle_sound2 = self.target2;
	self.idle_soundcom = self.message;
	self.idle_soundcom2 = self.message2;
	self.target = ""; self.target2 = ""; // Reset all strings to prevent SUB_UseTargets errors
	self.message = ""; self.message2 = "";
	self.estate_fire = trigger_mapvar_multiple_fire; // Setup Entity State functionality
	trigger_bmodel_setup();	
};

void () logic_auto_think = { // [FUNCTION]
	if (self.use) self.use();
	SUB_UseTargets();
	self.think = self.use = SUB_Null; // go idle
	self.nextthink = time + 0.100;
};

void () logic_auto = { // [ENTITY]
	self.think = logic_auto_think;
	self.nextthink = time + 0.6 + self.delay; // Give at least a little more than 0.5s to start all other entities before firing targets
};

void() info_timer = { // [ENTITY], redirect for old techno progs....wait I made that and never released it so, why? -Qmaster ...because.
	self.classname = "logic_auto";
	if (!self.wait) self.wait = 1;
	if (!self.delay) self.delay = self.wait;
	logic_auto();
};