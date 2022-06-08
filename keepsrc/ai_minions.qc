//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: Arcane Dimensions (AD)
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
// Function count: 8
//
// Implements: Minion System for monsters to summon henchmen
//
// Description:
// Setup and update minion counters.  Centralized to reduce errors.
// monster_death_precheck removes them from their charmer's counter at minion
// death. Spawning a minion adds to the counter.
//
// Minion eggs are spawned projecile (egg) tossed at the player.  Waits for egg
// to bounce and settle befor it spawns a growing and rotating minion inside a
// bursting egg.
//=============================================================================

void() setup_minionsupport = { // [FUNCTION]
	// Reset all counters
	self.minion_active = TRUE;
	self.minion_count = 0;
	self.minion_trigger = 0;

	// Setup default max counters (check for existing values)
	if (!self.minion_maxcount) self.minion_maxcount = MIN_MAXACTIVE;
	if (!self.minion_maxtrigger) self.minion_maxtrigger = MIN_MAXTRIGGER;
	
	// Chance to fire original (base) attack of monster
	if (!self.minion_baseattack) self.minion_baseattack = TRUE;

	// Throw speed of minion ball/egg
	if (!self.minion_throwspeed) self.minion_throwspeed = MIN_THROWSPD;
	if (!self.minion_throwextra) self.minion_throwextra = MIN_THROWRND;
	if (!self.minion_throwside) self.minion_throwside = MIN_THROWSIDE;
};

void(entity msource, float countupd) update_minioncount = { // [FUNCTION]
	if (!msource.minion_active) return;
	// Add to the active minion counters (check range limits)
	msource.minion_count = msource.minion_count + countupd;
	msource.minion_count = SUB_ClampFloat(msource.minion_count,0,msource.minion_count); // Only prevent negative.
	if (msource.minion_count > msource.minion_maxcount) msource.minion_count = msource.minion_maxcount;

	// Check for trigger events (ignore death triggers)
	if (countupd > 0) {
		msource.minion_trigger = msource.minion_trigger + countupd;
		if (msource.minion_trigger >= msource.minion_maxtrigger) {
			msource.minion_trigger = 0;
			// Check for trigger event string?
			if (msource.miniontarget != "") trigger_strs(msource.miniontarget, msource);
		}
	}
};

// Check if anymore minions can be spawned at the moment
float(entity msource) query_minionactive = { // [FUNCTION]
	if (!msource.minion_active) return NEGATIVE;
	if (msource.minion_count < msource.minion_maxcount) return TRUE;
	else return FALSE;
};


void() delete_minionspace = { if (self.minion_test) entity_remove(self.minion_test,0.1); } // [FUNCTION]
void() touch_minionspace = { if (other.flags & FL_CLIENT) self.aflag = TRUE; }; // [FUNCTION]

// Touch trigger version for detecting client/players too close to see if space to spawn
void(vector org, vector minspace, vector maxspace) setup_minionspace = { // [FUNCTION]
	if (!self.minion_test) self.minion_test = spawn(); // Create a touch trigger if one does not exist
	// reset all parameters
	self.minion_test.movetype = MOVETYPE_NONE;
	self.minion_test.solid = SOLID_TRIGGER;
	setmodel(self.minion_test, MODEL_EMPTY);
	self.minion_test.skin = self.minion_test.frame = 0;
	self.minion_test.flags = 0;
	setorigin(self.minion_test, org); // Move touch trigger to correct location
	setsize (self.minion_test, minspace, maxspace);
	self.minion_test.touch = touch_minionspace; // Enable touch function
	self.minion_test.aflag = FALSE; // Reset collision flag
};

float() test_minionspace = { // [FUNCTION]
	if (!self.minion_test) return FALSE; // Quick exit if no touch entity exists

	// Basic world collision test for origin/min/max of spawn
	if (pointcontents(self.minion_test.origin) != CONTENT_EMPTY) return FALSE;
	if (pointcontents(self.minion_test.origin+'-16 -16 -24') != CONTENT_EMPTY) return FALSE;
	if (pointcontents(self.minion_test.origin+'16 16 40') != CONTENT_EMPTY) return FALSE;
	
	// Switch off touch function and check for collision
	self.minion_test.touch = SUB_Null;
	if (self.minion_test.aflag == TRUE) return FALSE;
	else return TRUE;
};

// Findradius version for detecting client/players too close and space to spawn
float(vector org) find_minionspace = { // [FUNCTION]
	local entity minstuff;
	local float foundclient;

	// Basic world collision test for origin/min/max of spawn
	if (pointcontents(org) != CONTENT_EMPTY) return FALSE;
	if (pointcontents(org+'-16 -16 -24') != CONTENT_EMPTY) return FALSE;
	if (pointcontents(org+'16 16 40') != CONTENT_EMPTY) return FALSE;
	
	foundclient = TRUE;
	// The player can cover crazy amount of distance very fast so extend radius out further to catch running players
	minstuff = findradius(org, MONAI_RANGESUMMON);
	while (minstuff) {
		if (minstuff.flags & FL_CLIENT) {
			foundclient = FALSE;
			minstuff = world;
		}
		minstuff = minstuff.chain;
	}
	return foundclient;
};
