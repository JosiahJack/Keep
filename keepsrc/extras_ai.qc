//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: Frank Condello (aka pOx), Khreathor for the extras_r5 update
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
// Function count: 6
//
// Implements: Swimming Surface-Smart AI
//
// Description:
// The surface-smart AI detects when a swimming monster is stuck at at a liquid
// surface and gets them unstuck by spawning a temporary goal for them to move
// down to away from the surface.  This allows them to keep chasing their enemy
// for as far as they can within the liquid rather than go up and get stuck
// like in ye olden days.
//=============================================================================

// Remove temporary target
void() getRidOfTempGoal = { // [FUNCTION]
    if (!self.tempgoal) return;

	self.enemy = self.oldenemy;
	self.goalentity = self.enemy;
	self.movetarget = self.enemy;
	remove(self.tempgoal);
	self.tempgoal = world;
};

// Remove temporary target
void() delayedTargetChange = { // [FUNCTION]
	self.owner.tempgoal = world;
	self.owner.enemy = self.owner.oldenemy;
	self.owner.goalentity = self.owner.enemy;
	self.owner.movetarget = self.owner.enemy;
	remove(self);
};

// Spawn temporary target/goal to follow, when on water surface
void() SpawnTempGoal = { // [FUNCTION]
	local entity tmpgoal;
	local vector tmppos;
	
	if (!self.tempgoal) {
		tmpgoal = spawn();
		tmpgoal.classname = "tmp_goal";
		tmpgoal.health = 1;
		tmpgoal.movetype = MOVETYPE_NONE;
		tmpgoal.solid = SOLID_NOT;
		setorigin(tmpgoal, self.goalentity.origin);
		setsize (tmpgoal, '-4 -4 -4 ', '4 4 4');
		tmpgoal.view_ofs = ' 0 0 4 ';
		tmpgoal.owner = self;
		tmpgoal.think = delayedTargetChange;
		tmpgoal.nextthink = time + 2;
		self.tempgoal = tmpgoal;
		self.oldenemy = self.enemy;
		self.enemy = self.tempgoal;
	}

	tmppos = self.oldenemy.origin;
	tmppos_z = self.origin_z - self.size_z;
	setorigin(self.tempgoal, tmppos);
	self.goalentity = self.tempgoal;
	self.movetarget = self.tempgoal;
};

// Return TRUE when unstuck procedure succeded
// Return FALSE when unstuck procedure has been canceled or failed
float() unsuckFromWaterSurface = { // [FUNCTION]
	if (((self.enemy.origin_z - self.origin_z) > 32) && (GetContents(self.enemy.origin) > CONTENT_WATER)) return FALSE;
	if (self.oldenemy && range(self.oldenemy) == RANGE_MELEE && self.flags & FL_SWIM) return TRUE;
	if (self.flags & FL_SWIM) {
		if (GetContents(self.origin + '0 0 10') > CONTENT_WATER) { SpawnTempGoal(); return TRUE; }
	} else if (self.flags & FL_FLY && self.infuncwater) {
		if (self.onsurface) { SpawnTempGoal(); return TRUE; }
	}
	return FALSE;
};

void() handleFuncWaterSwimming = { // [FUNCTION]
    if (self.infuncwater && self.flags) {
		self.gravity = 0.375;
		self.flags = self.flags | FL_FLY;
        self.flags = self.flags - (self.flags & FL_SWIM);
		if (self.movetype != MOVETYPE_STEP) self.movetype = MOVETYPE_STEP;
    } else if (!self.infuncwater && self.inBSPwater) {
		self.gravity = 0.375;
		self.flags = self.flags | FL_SWIM;
		if (self.movetype != MOVETYPE_STEP) self.movetype = MOVETYPE_STEP;
	}

	if (unsuckFromWaterSurface()) return;
	
	if (!self.infuncwater && !self.inBSPwater) {
		self.gravity = 0.375;
		self.flags = self.flags - (self.flags & FL_SWIM);
		self.flags = self.flags - (self.flags & FL_FLY);
		
		if (self.flags & FL_ONGROUND) {
			self.gravity = 0;
			self.flags = self.flags - (self.flags & FL_ONGROUND);
			self.flags = self.flags | FL_SWIM;
		}
	}
};

// Fish movement - new logic
void(string action, float value) ai_fish_movement= { // [FUNCTION]
	if (self.flags & FL_SWIM) handleFuncWaterSwimming(); // Do things every animation frame.

	if (action == "ai_walk") ai_walk(value);
	else if (action == "ai_run") ai_run(value);
	else if (action == "ai_pain") ai_pain(value);
	else if (action == "ai_charge") {
		if (!(self.enemy.flags & FL_CLIENT)) getRidOfTempGoal();
		ai_charge(value);
	}
};