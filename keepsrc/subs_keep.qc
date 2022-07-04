//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: Nehahra
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
// Function count: 34
//
// Implements: Subroutines
//
// Description:
// Useful functions that simplify a lot of checks or provide global
// functionality.
//=============================================================================

// This reduces a lot of boilerplate code assigning a think and nextthink.
void(entity targ, void() th_think, float th_time) SUB_Think = { // [FUNCTION]
	if (th_time <= 0) th_time = 0.1;

	targ.think = th_think;
	if (targ.bsporigin > 0) targ.nextthink = targ.ltime + th_time;
	else targ.nextthink = time + th_time;
};

void(void() th_think, float th_time) SUB_SelfThink = { // [FUNCTION]
	SUB_Think(self,th_think,th_time);
};

float (entity o) IsProjectile = { // [FUNCTION]
	return (o.classgroup == CG_PROJALL || o.classgroup == CG_PROJSHELLS
		 || o.classgroup == CG_PROJNAILS  || o.classgroup == CG_PROJLAVANAILS
		 || o.classgroup == CG_PROJROCKETS  || o.classgroup == CG_PROJGRENADES
		 || o.classgroup == CG_PROJCELLS  || o.classgroup == CG_PROJHAZARD
		 || o.classgroup == CG_MINIONEGG || o.classgroup == CG_PROJMULTIROCKETS
		 || o.classgroup == CG_PROJBOLTSPOISON || o.classgroup == CG_PROJBOLTS
		 || o.classgroup == CG_PROJBLOODCRYSTALS || o.classgroup == CG_PROJVOID
		 || o.classgroup == CG_PROJMAGIC || o.classgroup == CG_PROJICE);
};

float(entity o) AffectedByPhysics = { // [FUNCTION]
	if (IsProjectile(o)) return TRUE;
	if (o.classtype == CT_FUNCBREAKOBJ) return TRUE;
	if (o.classtype == CT_TEMPGIB) return TRUE;
	if (o.classtype == CT_TEMPPHYS) return TRUE;
	if (o.classtype == CT_BUBBLE) return TRUE;
	if (o.classtype == CT_MISCDRIP) return TRUE;
	if (o.classtype == CT_TEMPSPARK) return TRUE;
	if (o.classtype == CT_PROJ_MEGG) return TRUE;
	return FALSE;
};

// From Quoth for calculating gib velocity for polyp
vector (float dm) VelocityForDamage = { // [FUNCTION]
	local vector v;

	v_x = 100 * crandom();
	v_y = 100 * crandom();
	v_z = 200 + 100 * random();
	if (dm > -50) {
		v = v * 0.7;
	} else {
		if (dm > -200) {
			v = v * 2;
		} else {
			v = v * 10;
		}
	}
	return v;
};

float(vector spot) InSky = { return (pointcontents(spot) == CONTENT_SKY); }; // [FUNCTION]
float(vector spot) InAir = { return (pointcontents(spot) == CONTENT_EMPTY); }; // [FUNCTION]
float(vector spot) InSolid = { return (pointcontents(spot) == CONTENT_SOLID); }; // [FUNCTION]
float(vector spot) InWater = { return (pointcontents(spot) == CONTENT_WATER); }; // [FUNCTION]
float(vector spot) InSlime = { return (pointcontents(spot) == CONTENT_SLIME); }; // [FUNCTION]
float(vector spot) InLava = { return (pointcontents(spot) == CONTENT_LAVA); }; // [FUNCTION]
// InSky not made since AD's check_skycontent is more robust and uses different advanced engine features.
float(vector spot) InLiquid = { // [FUNCTION]
	local float conts;

	conts = pointcontents(spot);
	return ((conts <= CONTENT_WATER) && (conts != CONTENT_SKY));
};

float(float amount) SUB_NudgeSelfPlacement = { // [FUNCTION]
	local float shift, pconts;
	local vector vec;

	shift = 0;
	while (shift < 6) {
		vec = VEC_ORIGIN;
		if (shift == 0) vec_z = amount; // Move up out of floor
		else if (shift == 1) vec_x = amount; // Move out of wall to east
		else if (shift == 2) vec_x = amount * -1; // Move out of wall west
		else if (shift == 3) vec_y = amount; // Move out of wall north
		else if (shift == 4) vec_y = amount * -1; // Move out of wall south
		else vec_z = amount * -1; // Lower from out of ceiling
		vec = vec + self.origin;
		pconts = pointcontents(vec);
		if (pconts != CONTENT_SOLID && pconts != CONTENT_SKY) {
			setorigin(self,vec);
			return TRUE; // Freed
		}
		shift = shift + 1;
	}

	dprint(self.classname);
	dprint(" has bad placement, starting in wall at ");
	dprint(vtos(self.origin));
	dprint(", attempted to nudge by ");
	dprint(ftos(amount));
	dprint(" in all 6 directions,\nbut couldn't find a way out! Removed!\n");
	return FALSE; // Still stuck :(.
};

// Creates a new vector.  From copper, renamed for clarity and avoid case insensitive errors.
vector(float x, float y, float z) NewVector = { // [FUNCTION]
	local vector swiz;

	swiz_x = x;
	swiz_y = y;
	swiz_z = z;
	return swiz;
};

// From copper, renamed for clarity
vector(vector a, vector b) vec_multiply_elementwise = { // [FUNCTION]
	return NewVector(a_x * b_x, a_y * b_y, a_z * b_z);
};

// Too commonly used, so I made a helper function for randomly picking and playing a whoosh.
void() SwordSwipeSound = { // [FUNCTION]
	self.lip = random();
	if (self.lip < 0.25) sound (self, CHAN_WEAPON, "ad171/weapons/sword1a.wav", 1, ATTN_NORM);
	else if (self.lip < 0.5) sound (self, CHAN_WEAPON, "ad171/weapons/sword2a.wav", 1, ATTN_NORM);
	else if (self.lip < 0.75) sound (self, CHAN_WEAPON, "ad171/weapons/sword1b.wav", 1, ATTN_NORM);
	else sound (self, CHAN_WEAPON, "ad171/weapons/sword2b.wav", 1, ATTN_NORM);
};
 
float() SUB_HideIfNoTargetname = { // [FUNCTION]
	if (self.targetname == "") {
		dprint("\b");
		dprint(self.classname);
		dprint("\b targetname missing\n");
		spawn_marker(self.origin, SPNMARK_YELLOW);
		entity_hide(self);
		return TRUE;
	}
	return FALSE;
};

float() SUB_HideIfNoTarget = { // [FUNCTION]
	if (self.target == "") {
		dprint("\b");
		dprint(self.classname);
		dprint("\b target missing\n");
		spawn_marker(self.origin, SPNMARK_YELLOW);
		entity_hide(self);
		return TRUE;
	}
	return FALSE;
};

// Check for random rotation setup and angle limits
void() SUB_CheckRandomizedAngles = { // [FUNCTION]
	if (self.angles_y < 0) self.angles_y = rint(random()*359);
	if (self.angles_y > 360) self.angles_y = 0;
};

void() SUB_FinishAttachment = { // [FUNCTION]
	if (self.attachment) {
		self.attachment.movetype = MOVETYPE_NONE;	// Stationary
		self.attachment.solid = SOLID_NOT;		// no world interaction
		setmodel(self.attachment,"");			// Hide model
		self.attachment.velocity = '0 0 0';
		self.attachment.state = STATE_OFF;
	}
};

void() SUB_FinishAttachment2 = { // [FUNCTION]
	if (self.attachment2) {
		self.attachment2.movetype = MOVETYPE_NONE;	// Stationary
		self.attachment2.solid = SOLID_NOT;			// no world interaction
		setmodel(self.attachment2,"");
		self.attachment2.velocity = '0 0 0';
		self.attachment2.state = STATE_OFF;
	}
};

void() SUB_FinishAttachment3 = { // [FUNCTION]
	if (self.attachment3) {
		self.attachment3.movetype = MOVETYPE_NONE;	// Stationary
		self.attachment3.solid = SOLID_NOT;			// no world interaction
		setmodel(self.attachment3,"");
		self.attachment3.velocity = '0 0 0';
		self.attachment3.state = STATE_OFF;
	}
};

void() SUB_FinishAttachments = { // [FUNCTION]
	SUB_FinishAttachment();
	SUB_FinishAttachment2();
	SUB_FinishAttachment3();
};

void() SUB_RemoveAttachment = { // [FUNCTION]
	if (self.attachment) {
		self.attachment.state = FALSE;
		self.attachment.think = SUB_Remove;
		self.attachment.nextthink = time + 0.1;
	}
};

void() SUB_RemoveAttachment2 = { // [FUNCTION]
	if (self.attachment2) {
		self.attachment2.state = FALSE;
		self.attachment2.think = SUB_Remove;
		self.attachment2.nextthink = time + 0.1;
	}
};

void() SUB_RemoveAttachment3 = { // [FUNCTION]
	if (self.attachment3) {
		self.attachment3.state = FALSE;
		self.attachment3.think = SUB_Remove;
		self.attachment3.nextthink = time + 0.1;
	}
};

void() SUB_RemoveAttachments = { // [FUNCTION]
	SUB_RemoveAttachment();
	SUB_RemoveAttachment2();
	SUB_RemoveAttachment3();
};

void() SUB_CalcAngleMoveDone =  { // [FUNCTION]
   self.angles = self.finalangle;
   self.avelocity = VEC_ORIGIN;
   self.nextthink = -1;
   if (self.think1) self.think1();
};

void(vector destangle, float tspeed) SUB_CalcAngleMove = { // [FUNCTION]
	local vector destdelta;
	local float len, traveltime;

	if (tspeed <= 0) tspeed = 0.01388; // 72fps delta time.
	destdelta = (destangle - self.angles);
	len = vlen(destdelta);
	traveltime = (len/tspeed);
	self.nextthink = (self.ltime + traveltime);
	if (traveltime <= 0) traveltime = 0.01388;
	self.avelocity = (destdelta * (1 / traveltime));
	self.finalangle = destangle;
	self.think = SUB_CalcAngleMoveDone;
};

// Wrapper function for assigning to self.think.
void() SUB_CalcAngleMoveThink = { // [FUNCTION]
	SUB_CalcAngleMove(self.mangle,10);
};

float(float val, float min, float max) SUB_ClampFloat = { // [FUNCTION]
	local float retval;

	retval = val;
	if (retval < min) retval = min;
	if (retval > max) retval = max;
	return retval;
}

// Hexen 2 general sequence animator
void SUB_AdvanceFrame(float min, float max) = { // [FUNCTION]
	self.walkframe = SUB_ClampFloat(self.frame + 1,min,max);
	self.frame = self.walkframe;
	if (self.walkframe >= max) self.walkframe = min - 1;
};

void SUB_AdvanceSkin(float min, float max) = { // [FUNCTION]
	self.walkskin = SUB_ClampFloat(self.skin + 1,min,max);
	self.skin = self.walkskin;
	if (self.walkskin == max) self.walkskin = min - 1;
};

float(entity targ) SUB_DropToFloor = { // [FUNCTION]
	local entity stemp;
	local float result;

	result = FALSE;
	stemp = self;
	self = targ;
	result = droptofloor();
	self = stemp;
	return result;
};

// Checks all effects and states that would render targ invisible.  Not to be
// confused with visible() which does traceline checks.
float(entity targ) Invisible = { // [FUNCTION]
	if (targ == world) return TRUE; // We shouldn't want to see the world.
	if (targ.flags & FL_NOTARGET) return TRUE;
	if (targ.invisible_finished >= time) return TRUE;
	if (targ.items & IT_INVISIBILITY) return TRUE;
	if (targ.alpha < 0.1) return TRUE;
	if (targ.modelindex == 0) return TRUE;
	if (targ.estate == ESTATE_OFF) return TRUE;
	if (targ.model == "") return TRUE;
	return FALSE;
};

float(entity targ) Indestructable = {
	if (targ.flags & FL_GODMODE) return TRUE;
	if (targ.invincible_finished >= time) return TRUE;
	return FALSE;
};

// Account for rounding errors on critical checks.
float(float first, float second) SafeEquals = {
	if (first == second) return TRUE; // In fact, equal.
	if (fabs(first - second) < MATH_EPSILON) return TRUE; // Close enough.
	return FALSE; // Nope, not equal.
};