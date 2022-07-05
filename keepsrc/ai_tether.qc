//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: Arcane Dimensions
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
// Function count: 4
//
// Implements: Monster Tether System
//
// Description:
// Sets up a tether point that monsters will return to once they have lost
// sight of the player.  Useful for passive monsters or monsters on guard.
//=============================================================================

.string		tethertarget;		// String name to link tethering too
.entity		tethertarg;			// Entity to track for tether system
.void()		th_tether;			// Function to call when at max range
.float		tethered;			// is the monster tethered during combat
.float		tetherrange;		// The circular range around tether point
.float		tetherdist;			// Distance from monster to tether point
.float		tetherenemy;		// Distance from enemy to tether point
.float		tetherwait;			// Amount of time to wait before returning
.float		tethertimer;		// Time before returning (code generated)
.float		tetherturn;			// Make sure monster turns towards enemy
.float		tetherpause;		// % to not pause attack at max range
.entity		tetherfocus;		// Enemy to turn towards while waiting
float TETHER_RADIUS = 300;		// Default tether radius
float TETHER_WAIT = 30;			// Default timer to wait before reset

void(entity targ) display_tethersystem = {
	local vector org;
	
	// Find origin of tether target
	if (targ.tethertarg) {
		if (targ.tethertarg.bsporigin) org = bmodel_origin(targ.tethertarg);
		else org = targ.tethertarg.origin;
	} else org = targ.origin; // Use own origin as backup
	
	self.tetherdist = vlen(targ.origin - org); // Find out own distance to tether
	// Find out enemy distance to tether
	if (targ.enemy) targ.tetherenemy = vlen(targ.enemy.origin - org);
	else targ.tetherenemy = 0;

	dprint("\b[Tether system]\b\n"); 
	dprint("--------------------------------------\n");
	dprint("Class ("); dprint(targ.classname); 
	if (targ.tethered) dprint(") Active (YES)\n");
	else dprint(") Active (NO)\n");
	dprint("Dist Max ("); dprint(ftos(targ.tetherrange));
	dprint(") Tether ("); dprint(ftos(targ.tetherdist)); 
	dprint(") Enemy ("); dprint(ftos(targ.tetherenemy)); 
	dprint(")\n");
	dprint("Wait time ("); dprint(ftos(targ.tetherwait));
	dprint(") Turn ("); dprint(ftos(targ.tetherturn));
	dprint(") Pause ("); dprint(ftos(targ.tetherpause));
	dprint(")\n");
	dprint("--------------------------------------\n");
};

// Check for tether point (find and setup entity)
void() setup_tethersystem = {
	// Check if the tether system be setup already
	if (self.tethertarget != "") {
		// Find the tether point (has to be path corner)
		self.tethertarg = find(world, targetname, self.tethertarget);
		if (self.tethertarg != world) {
			self.tethered = TRUE;
			self.tetherlock = FALSE; // Tether system is active (reset lock)
			if (self.tetherrange < 32) self.tetherrange = TETHER_RADIUS; // Setup default tether range
			if (self.tetherwait <= 0) self.tetherwait = TETHER_WAIT;
			self.tetherdist = self.tetherenemy = 0; // Reset distances (updated in check function)
			self.tethertimer = LARGE_TIMER; // No stand/walk timer active yet
			if (!self.th_tether) self.th_tether = self.th_missile; // Check for tether function (def=missile)
			self.tethertarget = ""; // Don't need tethertarget anymore
		}
		
		// Display debug info to console
		if (developer > 1) display_tethersystem(self);
	}
};

// Check for tether range and return TRUE if at radius limit
float() check_tethersystem = {
	local vector org;
	
	if (self.tethered == FALSE) return FALSE; // Is the system active on the monster?
	
	// Read tether target for BSP/Ent origin
	if (self.tethertarg.bsporigin) org = bmodel_origin(self.tethertarg);
	else org = self.tethertarg.origin;
	
	self.tetherdist = vlen(self.origin - org); // Setup tether distance for monster and enemy
	// Check for enemy entity first before distance check
	if (self.enemy) self.tetherenemy = vlen(self.enemy.origin - org);
	else self.tetherenemy = 0;
		
	self.tetherlock = FALSE; // Reset lock

	// If inside tether range, keep moving
	if (self.tetherdist < self.tetherrange) {
		return FALSE;
	} else {
		// If enemy behind tether point, move closer
		if (infront(self.tethertarg) && infront(self.enemy)) {
			return FALSE;
		} else { // Reach tether limit
			// Can monster see the enemy?
			if (enemy_vis) return TRUE;
			else {
				// Check for any passive monsters
				if (self.passive_mode) {
					// Return to passive monster state (reset)
					self.passive_state = MON_PASSIVESTATE_RESET;
					return FALSE;
				}
				
				// Check for no pause override
				if (self.tetherpause > 0) {
					if (random() <= self.tetherpause) return TRUE;
				}
				// At max range + cannot see enemy, exit combat
				self.tetherfocus = self.enemy;	// Save for later
				self.enemy = self.goalentity = self.movetarget = world;
				self.attack_state = AS_STRAIGHT;
				self.think = self.th_stand;		// Wait for enemy
				self.tethertimer = time + self.tetherwait;
			}
		}
	}
	return FALSE;
};

// Check tether timer for stand function
void() check_tethertimer = {
	if (self.tethered == FALSE) return;		// System active?
	if (!self.tethertarg) return;			// No target active
	if (self.enemy) return;					// In combat?
	
	// Has the timer been reached?
	if (self.tethertimer < time) {
		self.tetherlock = FALSE;			// Make sure not set
		self.goalentity = self.movetarget = self.tethertarg;
		self.tethertimer = LARGE_TIMER;		// Timer no longer needed
		self.pausetime = 0;					// Start walking
	} else {
		// Check to see if facing enemy is active?
		if (self.tetherturn && self.tetherfocus) {
			self.ideal_yaw = vectoyaw(self.tetherfocus.origin - self.origin);
			ChangeYaw();			
		}
	}
};