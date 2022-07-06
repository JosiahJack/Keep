//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
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
// Implements: AI for flying monsters to stay above their enemy
//
// Description:
// Flying units maintain the same Z axis as their enemy targets
// This makes it impossible to have flying units above the player
// because the engine is constantly moving the monster downwards
//
// This system replaces the enemy target with a fake one which
// floats above the real enemy target. This fake marker can be
// seen if developer 1 is active, otherwise hidden
//
// The engine will track the fake enemytarget and gameplay functions
// can carry on using the real enemy target for calculations
//
// All the gameplay functions should use these self.enemy wrappers
// defined below to make sure they return the correct enemy! 
//=============================================================================

// Detects enemytarget and returns real ENEMY angles.  Returns the correct takedamage flag, useful for function tests
float() SUB_takedEnemyTarget = {
	if (!self.enemy) return -1;
	if (self.enemy.classtype == CT_ENEMYTARGET) {
		if (self.enemy.state == STATE_ON) return (self.enemy.enemy.takedamage);
		else return (self.enemy.takedamage);
	} else return (self.enemy.takedamage);
};

// Detects enemytarget and returns for flags bitwise operation.  Returns the correct entity flags, useful for function tests
float(float bitflag) SUB_flagsEnemyTarget = {
	if (!self.enemy) return -1;
	if (self.enemy.classtype == CT_ENEMYTARGET) {
		if (self.enemy.state == STATE_ON) return (self.enemy.enemy.flags & bitflag);
		else return (self.enemy.flags & bitflag);
	} else return (self.enemy.flags & bitflag);
};

// Detects enemytarget and returns real ENEMY angles.  Returns the correct entity angles, useful for function tests
vector() SUB_angEnemyTarget = {
	if (!self.enemy) return VEC_ORIGIN;
	if (self.enemy.classtype == CT_ENEMYTARGET) {
		if (self.enemy.state == STATE_ON) return self.enemy.enemy.angles;
		else return self.enemy.angles;
	} else return self.enemy.angles;
};

// Detects enemytarget and returns real ENEMY health
// Returns the correct entity health, useful for function tests
float() SUB_healthEnemyTarget = {
	if (!self.enemy) return -1;
	if (self.enemy.classtype == CT_ENEMYTARGET) {
		if (self.enemy.state == STATE_ON) return self.enemy.enemy.health;
		else return self.enemy.health;
	} else return self.enemy.health;
};

// Detects enemytarget and returns real ENEMY origin.  Returns the correct entity origin, useful for function tests
vector() SUB_orgEnemyTarget = {
	if (!self.enemy) return VEC_ORIGIN;
	if (self.enemy.classtype == CT_ENEMYTARGET) {
		if (self.enemy.state == STATE_ON) return self.enemy.enemy.origin;
		else return self.enemy.origin;
	}
	else return self.enemy.origin;
};

// Detects enemytarget and returns the real ENEMY entity.  Returns the correct entity, useful for function tests
entity() SUB_entEnemyTarget = {
	if (!self.enemy) return world;
	if (self.enemy.classtype == CT_ENEMYTARGET) {
		if (self.enemy.state == STATE_ON) return self.enemy.enemy;
		else return self.enemy;
	} else {
		return self.enemy;
	}
};

// Returns TRUE if enemytarget system active.  A simple test to see if enemytarget system is active
float() SUB_EnemyTarget = {
	if (!self.enemy) return -1;
	if (self.enemy.classtype == CT_ENEMYTARGET) {
		if (self.enemy.state == STATE_ON) return TRUE;
		else return FALSE;
	} else {
		return FALSE;
	}
};

// Self = monster; Will switch enemy and enemytarget around (restore).  Its a good idea to do this when the enemytarget is out of sight.  Will restore the enemy to the ground height (useful for doorways)
void() SUB_switchEnemyTarget = {
	if (self.enemytarget.classtype != CT_ENEMYTARGET) return;
	self.enemytarget.state = STATE_OFF;
	self.enemy = self.enemytarget.enemy;
	// If switching back to old enemy tracking system then block enemy targeting for a couple of secounds
	self.enemytargetlock = time + 2;
};

// Will remove any enemytarget functionality safely as possible.  The enemytarget system should take care of itself and safely delete.  This is a brute force version that will make sure, "its dead jim!"
void(entity targ) SUB_removeEnemyTarget = {
	if (targ.enemytarget.classtype != CT_ENEMYTARGET) return;

	targ.enemytarget.state = STATE_OFF;
	SUB_Think(targ.enemytarget,SUB_Remove,0.1);
};

// Function called all the time when the enemytarget is active
void() SUB_updateEnemyTarget = {
	if (self.owner.health < 1) {
		self.state = STATE_OFF;
		self.think = SUB_Remove; // OWNER DIED - Safely remove this entity
		self.nextthink = time + 0.1;
	} else if (self.enemy.health < 1) {
		self.state = STATE_OFF; // TARGET DIED - Stop tracking, wait for another enemy
	} else if (self.state == STATE_ON) { // ENEMY ACTIVE - Update position and check for height change
		// Is there any random variance to the Z location?
		if (self.waitmin < time && self.wait > 0) {
			self.waitmin = time + self.wait + random()*self.wait;
			// Check if the enemy is close? Go to maximum height if inside melee range
			self.enemydist = range_distance(SUB_entEnemyTarget(), FALSE);
			if (self.enemydist < MONAI_ABOVEMELEE) self.view_ofs_z = self.height;
			else self.view_ofs_z = (self.height*0.25) + ((self.height*0.75) * random());
		}

		self.lip = pointcontents(self.enemy.origin + self.view_ofs); // Check for solid/sky origin content
		if (self.lip == CONTENT_SOLID || self.lip == CONTENT_SKY) {
			// Traceline upwards to nearest point
			traceline(self.enemy.origin, self.enemy.origin + self.view_ofs, TRUE, self);
			setorigin(self,trace_endpos);
		}
		else setorigin(self, self.enemy.origin + self.view_ofs);
		
		// Next update time tick (def=0.1s)
		self.think = SUB_updateEnemyTarget;
		self.nextthink = time + 0.1;
	}
};

float(entity targ, float zoffset, float rndtimer) SUB_setupEnemyTarget = {
	if (targ.movetype == MOVETYPE_FLY) return FALSE; // Don't try to get higher than other flying units.  Two monsters with the same abilty will constantly rise up
	
	if (self.enemytargetlock > time) { // Is enemy target temporarily locked?
		if (!self.enemytarget) return FALSE; // Target system active?
		self.enemytarget.state = STATE_OFF;
		self.enemy = self.enemytarget.enemy; // Restore any enemy targets
		return FALSE; 
	}
	
	if (!self.enemytarget) { // Create the enemytarget if one does not exist
		self.enemytarget = spawn();
		self.enemytarget.owner = self;
		self.enemytarget.classtype = CT_ENEMYTARGET;
		if (developer > 0 && !query_configflag(SVR_DEVHELPER)) { // Show enemytarget system in devmode ONLY (dev helper)
			self.enemytarget.mdl = MODEL_BROKEN;
			self.enemytarget.skin = SPNMARK_PURPLE;
			setmodel(self.enemytarget, self.enemytarget.mdl);
		}
		setsize (self.enemytarget, VEC_ORIGIN, VEC_ORIGIN);
		self.enemytarget.movetype = MOVETYPE_NONE;
		self.enemytarget.solid = SOLID_NOT;
		self.enemytarget.health = LARGE_TIMER; // Plenty of functions test for health and damage
		self.enemytarget.takedamage = DAMAGE_YES;
	}
	
	// If attacking a monster stay up high out its way, else move up and down
	if (targ.flags & FL_MONSTER) self.enemytarget.wait = 0;
	else if (self.bossflag) self.enemytarget.wait = 0;
	else self.enemytarget.wait = rndtimer;

	// Setup parameters and enable update routine
	self.enemytarget.state = STATE_ON;
	self.enemytarget.height = self.enemytarget.view_ofs_z = zoffset;
	self.enemytarget.enemy = targ;
	self.enemytarget.think = SUB_updateEnemyTarget;
	self.enemytarget.nextthink = time + 0.1;
	return TRUE;
};