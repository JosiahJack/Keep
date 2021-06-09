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
// Function count: 11
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

void(vector org, vector dir, vector avel, float proj_type) Launch_Grenade;

void() setup_minionsupport = {
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

void(entity msource, float countupd) update_minioncount = {
	if (!msource.minion_active) return;
	// Add to the active minion counters (check range limits)
	msource.minion_count = msource.minion_count + countupd;
	if (msource.minion_count < 0) msource.minion_count = 0;
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
float(entity msource) query_minionactive = {
	if (!msource.minion_active) return NEGATIVE;
	if (msource.minion_count < msource.minion_maxcount) return TRUE;
	else return FALSE;
};


void() delete_minionspace = { if (self.minion_test) entity_remove(self.minion_test,0.1); }
void() touch_minionspace = { if (other.flags & FL_CLIENT) self.aflag = TRUE; };

// Touch trigger version for detecting client/players too close to see if space to spawn
void(vector org, vector minspace, vector maxspace) setup_minionspace = {
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

float() test_minionspace = {
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
float(vector org) find_minionspace = {
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

void(vector minion_org, entity minion_targ) minion_spider;
void(vector minion_org, entity minion_targ) minion_scorpion;
void(vector minion_org, entity minion_targ) minion_voreling;

// Remove egg and throw gibs up as minion grows
void() Explode_Egg = {
	setmodel (self, "");
	if (self.classgroup == CT_MONWRAITH) self.gib1mdl = MODEL_PROJ_WSHELL; 
	else if (self.classgroup == CT_MONSHAL) self.gib1mdl = MODEL_PROJ_SSHELL; 
	self.gib1frame = 9;
	self.max_health = MON_GIBFOUNTAIN;
	ThrowGib(11,rint(2+random()*4));
	self.think = SUB_Remove; // Safely remove egg
	self.nextthink = time + 0.1;
};	

// Once the egg has landed via Grenade Touch function.  The minion is spawned and the egg is set to explode
void() Hatch_Egg = {
	if (self.state == STATE_DISABLED) return; // Block this functions
	if (self.touchedvoid) return; // Has the egg been marked for removal?

	if (!self.gibbed) {
		self.gibbed = TRUE; // only set once, float reuse! nothing to do with gibbing
		self.attack_finished = time + 6; // It's possible for the egg to get stuck, setup death timer
	}
	if (self.attack_finished < time) {
		self.state = STATE_DISABLED;
		self.think = Explode_Egg; // Egg has been stuck for too long, destroy it
		self.nextthink = time + 0.1;
		return;
	}
	// Turn off touch function and any movement
	self.touch = SUB_Null;
	self.movetype = MOVETYPE_NONE;
	self.takedamage = DAMAGE_NO;
	self.velocity = '0 0 0';
	
	// Check if the egg can hatch? turn on collision, setup new bounds and extend upwards for testing
	setsize (self, VEC_HULLT_MIN, VEC_HULLT_MAX);
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_TOSS;
	self.oldorigin = self.origin;
	self.origin_z = self.origin_z + 8;
	droptofloor();
	
	if (!walkmove(0,0) || pointcontents(self.origin) == CONTENT_SOLID) { // Can the egg hatch yet? Solid content?
		self.origin = self.oldorigin;
		self.think = Hatch_Egg;
		self.nextthink = time + 1 + random();
		self.solid = SOLID_NOT;		// turn off again
		return;
	}
	self.state = STATE_DISABLED; // Setup egg ready for minion
	traceline (self.origin+'0 0 128', self.origin-'0 0 256', TRUE, world);
	self.oldorigin = trace_endpos + '0 0 32'; // Setup spawn location for minion
	// Spawn minion inside of egg model.  self.owner is re-assigned to minion to avoid shell gibs interacting
	if (self.owner.classtype == CT_MONWRAITH) {
		if (self.owner.spawnflags & MON_WRAITH_SCORPIONS) minion_scorpion(self.oldorigin, self.enemy);
		else minion_spider(self.oldorigin, self.enemy);
	} else if (self.owner.classtype == CT_MONSHAL || self.owner.classtype == CT_MONSHALBOSS) {
		if (self.owner.classtype == CT_MONSHALBOSS) {
			sound (self, CHAN_WEAPON, "ad171/wraith/attack3.wav", 1, ATTN_NORM);
			minion_voreling(self.oldorigin+'0 0 4', self.enemy);
		} else {
			minion_voreling(self.oldorigin, self.enemy);
		}
	}
	self.think = Explode_Egg; 
	self.nextthink = time + 0.4; // Skip a couple of frames
};

// Work out direction speed of egg and then launch it!
void(vector eggofs) Create_Egg = {
	local vector org, dir;
	local float egg_speed;
	if (self.health < 1) return;
	
	// Turn towards player and drop the egg!
	makevectors(self.angles);
	org = self.origin + attack_vector(eggofs);
	egg_speed = self.minion_throwspeed + (random() * self.minion_throwextra);
	dir = (v_forward * egg_speed) + (v_right * (crandom()*self.minion_throwside));
	Launch_Grenade(org,dir,'0 0 0',CT_PROJ_MEGG);
	SUB_AttackFinished (2 + random());
};