//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: Qmaster, Drake, Nehahra
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
// Function count: 55
//
// Implements: Subroutines
//
// Description:
// Useful functions that simplify a lot of checks or provide global
// functionality.
//=============================================================================

void() SUB_FindRandomSpawnSpot;
void() spirit_glow;

//  This makes an entity do a think function right now.  From Drake.
void(entity ent, void() thinkst) SUB_ThinkImmediate = { // [FUNCTION]
    local entity swap;

    swap = self;
    self = ent;
    thinkst();
    self = swap;
};

// This reduces a lot of boilerplate code assigning a think and nextthink.
void(entity targ, void() th_think, float delaytime) SUB_Think = { // [FUNCTION]
	if (delaytime <= 0) { SUB_ThinkImmediate(targ,th_think); return; }

	targ.think = th_think;
	if (targ.bsporigin > 0 && targ.solid > SOLID_TRIGGER) {
		targ.nextthink = targ.ltime + delaytime; // Brush entities use ltime.
	} else targ.nextthink = time + delaytime;    // Point entities use time.
};

void(void() th_think, float delaytime) SUB_SelfThink = { // [FUNCTION]
	SUB_Think(self,th_think,delaytime);
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
	if (dm > -50) return v * 0.7;
	if (dm > -200) return v * 2;
	return v * 10;
};

// Add and create list once of all func water volumes for checking contents.
// Copies Gyro_ObjectList_Add but has to be different since we use unique fields.
void(entity e) FliquidList_Add = { // [FUNCTION]
	if (!e) return;
	if (!fliquid_head) {
		fliquid_head = e; // Start the list.
		fliquid_head.fliquid_inlist = TRUE;
		return;
	}
	if (e.fliquid_inlist) return; // Already in the list, whoops.

	e.fliquid_inlist = TRUE;
	e.fliquid_next = fliquid_head;
	fliquid_head.fliquid_prev = e;
	fliquid_head = e;
};


void(entity e) FliquidList_Remove = { // [FUNCTION]
	if (!e.fliquid_inlist) return; // Not a func liquid volume

	if (e.fliquid_prev) e.fliquid_prev.fliquid_next = e.fliquid_next;
	else fliquid_head = e.fliquid_next;

	if (e.fliquid_next) e.fliquid_next.fliquid_prev = e.fliquid_prev;
	e.fliquid_inlist = FALSE;
	e.fliquid_next = e.fliquid_prev = world;
};

entity(vector spot) GetFuncLiquidAtPoint = { // [FUNCTION]
	local entity ent, start;

	start = ent = fliquid_head;
	while(ent) {
		if ((spot_x<ent.absmax_x) && (spot_y<ent.absmax_y)
			&& (spot_z<ent.absmax_z) && (spot_x>ent.absmin_x)
			&& (spot_y>ent.absmin_y) && (spot_z>ent.absmin_z)) {
			return ent;
		}
		ent = ent.fliquid_next;
		if (ent == start) return world;
	}
	return world;
}

float(vector spot) InLiquid = { // [FUNCTION]
	local float conts;
	local entity ent;

	conts = pointcontents(spot);
	if ((conts <= CONTENT_WATER) && (conts != CONTENT_SKY)) {
		if (conts == CONTENT_WATER) return 1;
		else if (conts == CONTENT_SLIME) return 2;
		else return 3; // CONTENT_LAVA
	} else {
		// Ok, now check for func water volumes.
		ent = GetFuncLiquidAtPoint(spot);	
		if (ent) {
			if (ent.watertype == CONTENT_WATER) return 1;
			else if (ent.watertype == CONTENT_SLIME) return 2;
			else return 3; // CONTENT_LAVA
		}
		return 0;
	}
};

// Check for contact with sky brushes.  Use pointcontent() for Typical/Enhanced
// Quake engines.  Use new FTE string functions and surface check for FTE/DP.
// This was check_skycontent in AD.  Renamed to align with the others and save
// on characters used.
float(vector spot) InSky = { // [FUNCTION]
	local float surfnum;
	local string texturename;

	// Projectile owner exeception (bad FPS for large maps).
	if (self.owner.proj_noskycheck == TRUE) return FALSE;
	else if (ext_dpsurf) {
		surfnum = getsurfacenearpoint(world,spot);
		if (surfnum >= 0) {
			texturename = getsurfacetexture(world,surfnum);
			if (strncasecmp(texturename,"SKY",3) == 0) return TRUE;
		}
	} else if (pointcontents(spot) == CONTENT_SKY) return TRUE;
	return FALSE;
};
float(vector spot) InAir = { return (pointcontents(spot) == CONTENT_EMPTY); }; // [FUNCTION]
float(vector spot) InSolid = { return (pointcontents(spot) == CONTENT_SOLID); }; // [FUNCTION]
float(vector spot) InWater = { return (InLiquid(spot) == 1); }; // [FUNCTION]
float(vector spot) InSlime = { return (InLiquid(spot) == 2); }; // [FUNCTION]
float(vector spot) InLava = { return (InLiquid(spot) == 3); }; // [FUNCTION]

float(vector spot) GetContents = { // [FUNCTION]
	local float conts;

	conts = InLiquid(spot);
	if (conts == 1) return CONTENT_WATER;
	else if (conts == 2) return CONTENT_SLIME;
	else if (conts == 3) return CONTENT_LAVA;
	else return pointcontents(spot);
};

float(entity targ) LiquidBase = { // [FUNCTION]
	local vector base;

	base = targ.origin; // Check for liquid at monsters feet (bottom of bounding box)
	base_z = base_z + targ.mins_z;
	targ.liquidbase = GetContents(base);
	return targ.liquidbase;
};

float(vector spot) InOpenOrLiquid = { // [FUNCTION]
	local float conts;

	conts = pointcontents(spot);
	if (conts != CONTENT_SOLID && conts != CONTENT_SKY) return TRUE;
	return FALSE;
}

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
		if (InOpenOrLiquid(vec)) {
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
	if (self.lip < 0.25) sound(self,CHAN_WEAPON,"ad171/weapons/sword1a.wav",1,ATTN_NORM);
	else if (self.lip < 0.5) sound(self,CHAN_WEAPON,"ad171/weapons/sword2a.wav",1,ATTN_NORM);
	else if (self.lip < 0.75) sound(self,CHAN_WEAPON,"ad171/weapons/sword1b.wav",1,ATTN_NORM);
	else sound(self,CHAN_WEAPON,"ad171/weapons/sword2b.wav",1,ATTN_NORM);
};
 
float() SUB_HideIfNoTargetname = { // [FUNCTION]
	if (self.targetname == "") {
		dprint("\b");
		dprint(self.classname);
		dprint("\b targetname missing\n");
		spawn_marker(self.origin,'0 0 0',0,SPNMARK_YELLOW);
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
		spawn_marker(self.origin,'0 0 0',0,SPNMARK_YELLOW);
		entity_hide(self);
		return TRUE;
	}
	return FALSE;
};

// Check for random rotation setup and angle limits
void() SUB_CheckRandomizedAngles = { // [FUNCTION]
	local float loopiter;

	if (self.angles_y == -1) self.angles_y = rint(random()*359);
	loopiter = 0;
	while (self.angles_y > 360) {
		if (loopiter >= 20) return;

		loopiter = loopiter + 1;
		self.angles_y = self.angles_y - 360;
	}
};

entity(string attmodel, float attalpha) SUB_CreateAttachment = { // [FUNCTION]
	local entity att;

	att = spawn();
	if (!att) return world;

	att.owner = self;
	att.classtype = CT_ATTACHMENT;
	att.mdl = attmodel;
	att.alpha = attalpha;
	return att;
};

void(string attmodel, float attalpha) SUB_CreateSelfAttachment = { // [FUNCTION]
	if (!self.attachment) self.attachment = SUB_CreateAttachment(attmodel,attalpha);
};

void(string attmodel, float attalpha) SUB_CreateSelfAttachment2 = { // [FUNCTION]
	if (!self.attachment2) self.attachment2 = SUB_CreateAttachment(attmodel,attalpha);
};

void(string attmodel, float attalpha) SUB_CreateSelfAttachment3 = { // [FUNCTION]
	if (!self.attachment3) self.attachment3 = SUB_CreateAttachment(attmodel,attalpha);
};

void(entity att, vector spot, vector ang) SUB_FinishAttachmentEntity = {
	if (!att) return;

	att.movetype = MOVETYPE_NONE;	// Stationary
	att.solid = SOLID_NOT;		// no world interaction
	att.frame = 0;
	att.skin = 0;
	setmodel(att,"");			// Hide model
	setsize(att,VEC_ORIGIN,VEC_ORIGIN);
	setorigin(att,self.origin); // Doesn't matter if this is correct, invisible.
	att.velocity = '0 0 0';
	att.angles = self.angles; // This will work on the ones that need it.
	att.state = STATE_OFF;
};

void() SUB_AttachmentFinishSelf = {
	SUB_FinishAttachmentEntity(self,self.origin,self.angles);
};

void() SUB_FinishAttachment = { // [FUNCTION]
	if (self.attachment) SUB_FinishAttachmentEntity(self.attachment,self.origin,self.angles);
};

void() SUB_FinishAttachment2 = { // [FUNCTION]
	if (self.attachment2) SUB_FinishAttachmentEntity(self.attachment2,self.origin,self.angles);
};

void() SUB_FinishAttachment3 = { // [FUNCTION]
	if (self.attachment3) SUB_FinishAttachmentEntity(self.attachment3,self.origin,self.angles);
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

void(entity targ, float fl) SUB_RemoveFlags = { // [FUNCTION]
	if (targ.flags & fl) targ.flags = targ.flags - (targ.flags & fl);
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

// Prevent value from being within range.
// VALID...min...INVALID...max...VALID
float(float val, float min, float max) SUB_ReverseClampFloat = { // [FUNCTION]
	local float retval;

	if (min > max) { retval = max; max = min; min = retval; } // Flip if needed.
	if (min == max && val != min) return val; // Easy out!

	retval = val;
	if (retval < max && retval > min) {
		if (max - retval < retval - min) retval = max; // Closer to max, put at.
		else retval = min; // Closer to min, put at.
	}
	return retval;
}

// Prevent value from being outside range.
// INVALID...min...VALID...max...INVALID
float(float val, float min, float max) SUB_ClampFloat = { // [FUNCTION]
	local float retval;

	if (min > max) { retval = max; max = min; min = retval; } // Flip if needed.
	if (min == max) {
		if (val == min) return val; // Matchy matchy!
		return min; // Return the unique value that satisfies the range.
	}
	if (val < max && val > min) return val; // Easy out!

	retval = val;
	if (retval < min) retval = min;
	if (retval > max) retval = max;
	return retval;
}

// Hexen 2 general sequence animator
void SUB_AdvanceFrame(float min, float max) = { // [FUNCTION]
	self.walkframe = SUB_ClampFloat(self.frame + 1,min,max);
	self.frame = self.walkframe;
	if (self.walkframe >= max) self.walkframe = min;
};

void SUB_ReverseFrame(float min, float max) = { // [FUNCTION]
	self.walkframe = SUB_ClampFloat(self.frame - 1,min,max);
	self.frame = self.walkframe;
	if (self.walkframe <= min) self.walkframe = max;
};

void SUB_AdvanceSkin(float min, float max) = { // [FUNCTION]
	self.walkskin = SUB_ClampFloat(self.skin + 1,min,max);
	self.skin = self.walkskin;
	if (self.walkskin == max) self.walkskin = min;
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
	if (!targ) return FALSE;
	if (targ.flags & FL_NOTARGET) return TRUE;
	if (targ.items & IT_INVISIBILITY) return TRUE;
	if (targ.invisible_finished > time) return TRUE;
	if (cinematic_running && targ.flags & FL_CLIENT && targ.solid == SOLID_NOT) return TRUE; // Prevent seeing players who are cameras but not ghosts and such.
	return FALSE;
};

float(entity targ) Indestructable = { // [FUNCTION]
	if (targ.flags & FL_GODMODE) return TRUE;
	if (targ.takedamage <= DAMAGE_NO) return TRUE;
	if (targ.invincible_finished >= time) return TRUE;
	return FALSE;
};

// Account for rounding errors on critical checks.
float(float first, float second) SafeEquals = { // [FUNCTION]
	if (first == second) return TRUE; // In fact, equal.
	if (fabs(first - second) < MATH_EPSILON) return TRUE; // Close enough.
	return FALSE; // Nope, not equal.
};

float(entity thePoint) IsSpaceClearAtEntity = { // [FUNCTION]
   local entity neighbors;
   local entity start;

	if (!InOpenOrLiquid(thePoint.origin)) return FALSE;

   neighbors = findradius (thePoint.origin,64);
   if (neighbors == world) return TRUE;

   start = neighbors;
   while (neighbors) {
      if (neighbors != thePoint) {
         if ((neighbors.flags & FLx_CREATURE)) return FALSE;
         else if (neighbors.solid) return FALSE;
      }
      neighbors = neighbors.chain;
      if (neighbors == start) return TRUE;
   }
   return TRUE;
};



entity(string cname, entity targ) SUB_FindByClassnameAwayFrom = { // [FUNCTION]
	local entity furthestDest, bestDest, curDest;
	local float theDist, curDist, dot, loop;
	local vector curVector;

	if (!targ) return world;
	if (cname == "") return world;

	furthestDest = world;
	bestDest = world;
	theDist = FALSE;
	makevectors(targ.angles);
	loop = 0;
	curDest = find(curDest,classname,cname);
	while (curDest) {
		loop = loop + 1;
		if (loop > 16) break;

		if (curDest == world) {
			if (bestDest != world) return bestDest;
			return furthestDest;
		}
		if (IsSpaceClearAtEntity(curDest)) {
			curVector = (curDest.origin - targ.origin);
			curDist = vlen(curVector);
			curVector = normalize(curVector);
			dot = curVector * v_forward;
			if (dot > 0.6) {
				if (curDist > 150) bestDest = curDest;
			}
			if (curDist > theDist) {
				furthestDest = curDest;
				theDist = curDist;
			}
		}
	}
	return world;
};

// Used by monsters who teleport themselves to find a spot.
entity() SUB_FindTeleportDestinationEntity = { // [FUNCTION]
	local entity enem, result;
	local string targtype;
	local float loop;

	if (self.enemy) enem = self.enemy;
	else enem = find(world,classname,"player");

	if (self.classtype == CT_MONWRATHOVERLORD) targtype = "info_overlord_destination";
	else if (self.classtype == CT_MONMORPH) targtype = "info_morph_destination";
	else targtype = "info_teleport_destination";

	result = SUB_FindByClassnameAwayFrom(targtype,enem);
	if (result) return result;

	if (targtype != "info_teleport_destination") targtype = "info_teleport_destination";
	else targtype = "info_target";

	result = SUB_FindByClassnameAwayFrom(targtype,enem);
	if (result) return result;

	if (targtype != "info_target") targtype = "info_target";
	result = SUB_FindByClassnameAwayFrom(targtype,enem);
	if (result) return result;

	result = spawn(); // Generate random point to spawn at.
	if (!result) return world;

	setorigin(result,vecrand(SUB_ReverseClampFloat(crandom() * 192,-128,128),128,TRUE));
	traceline(result.origin,self.enemy.origin,FALSE,self);
	result.think = SUB_Remove;
	result.nextthink = time + 0.05; // Ensure this tempent is removed!
	if (trace_ent == self.enemy) return result;
	return world;
};

// Wait for enemy to be far enough away from found spawn location (def=192).
void() SUB_WaitForSpawnLink = { // [FUNCTION]
	self.nextthink = time + 0.5 + random();
	self.think = SUB_WaitForSpawnLink;
	setorigin(self, self.movelast.origin);	// move to new location
	self.enemydist = range_distance(self.enemy,FALSE);

	// Is the enemy too close or dead?
	if (self.enemydist > self.movelast.distance || self.enemy.health < 1) {
		// Move to new location
		self.solid = SOLID_SLIDEBOX;				// Standard monster movement
		setmodel(self, self.mdl);					// Setup model
		setsize (self, self.bbmins, self.bbmaxs);	// Restore BB size
	
		// Test if new location is solid?
		if (!walkmove (0, 0)) {
			self.solid = SOLID_NOT;					// No world interaction yet
			setmodel(self,"");						// Turn off model
			if (self.classtype == CT_MONSPIRIT) spirit_glow();
		} else self.th_spawn();
	}
};

// Cycle around teleport location chain list to pick a mapper specified spot.
void() SUB_CheckSpawnLinkList = { // [FUNCTION]
	// Does the blink list exist already?
	if (self.movelast.classtype != CT_SKULLTELEPORT) {
		self.movelast = find(world,targetname,self.target2);
		// Does the entity chain exist?
		if (self.movelast.classtype == CT_SKULLTELEPORT) SUB_WaitForSpawnLink();
		else {
			self.target2 = ""; // target2 is not valid, do regular teleport
			SUB_FindRandomSpawnSpot();
		}
	} else {
		// Move forward in chain and try next spawn location
		self.movelast = self.movelast.enemy;
		SUB_WaitForSpawnLink();
	}
};

// Finishes restoring solidity and model, else keep checking.
void(vector org) SUB_FindRandomSpawnSpotFinish = { // [FUNCTION]
	if (!self.th_spawn) self.th_spawn = self.th_stand;
	if (!self.th_spawn) {
		SUB_SelfThink(SUB_Remove,0.1);
		dprint("Entity ");
		dprint(self.classname);
		dprint(" had no th_spawn and now th_stand fallback, removed\n");
		return;
	}

	// Move to new location
	self.solid = SOLID_SLIDEBOX;				// Standard monster movement
	setmodel(self, self.mdl);					// Setup model
	setsize (self, self.bbmins, self.bbmaxs);	// Restore BB size
	setorigin(self, org);						// move to new location
	
	// Test if new location is solid?
	if (!walkmove (0, 0)) {
		self.solid = SOLID_NOT;					// No world interaction yet
		setmodel(self,"");						// Turn off model
		setorigin(self, self.oldorigin);		// restore original location
		if (self.classtype == CT_MONSPIRIT) spirit_glow();
		self.nextthink = time + 1;				// Keep checking
		self.think = SUB_FindRandomSpawnSpot;
	} else self.th_spawn();
};

// Find new teleport location.  Requires:
// self.height to be set.
// self.distmin to be set (min range)
// self.meleerange to be set mid range.  Enemy must be further than this.
// self.distmax to be set for max range.  Furthest point to spawn from start.
void() SUB_FindRandomSpawnSpot = { // [FUNCTION]
	local float dist, edist, blinkfinished, blinkcount;
	local vector org, org_ofs, angle_vec;

	blinkfinished = TRUE; blinkcount = 0;
	org = angle_vec = org_ofs = '0 0 0'; 
	org_ofs_z = self.height;
	self.oldorigin = self.origin;
	
	// Trace upwards to find ceiling or maximum teleport height
	traceline(self.origin, self.origin+org_ofs, TRUE, self);
	org_ofs = trace_endpos;
	
	// Loop around for possible locations
	while(blinkfinished) {
		blinkcount = blinkcount + 1;		// next loop
		angle_vec_y = random() * 360;		// Random direction
		makevectors(angle_vec);				// make vector
		
		// Generate random angle and trace teleport direction
		dist = self.distmin + (random() * self.distmax);
		org = org_ofs + (v_forward * dist);
		traceline(org_ofs, org, TRUE, self);
		
		// Check distance is far enough away from enemy
		// Move away from any walls (traceline is surface contact)
		dist = vlen(trace_endpos - org_ofs) - 32;
		org = org_ofs + (v_forward * dist);
		if (self.enemy) {
			edist = vlen(self.enemy.origin - org);
		} else {
			// No enemy so guarantee spawn.
			edist = self.meleerange + 1;
		}

		// Is the enemy far enough away?
		if (edist > self.meleerange || !self.enemy) {
			// Trace down to floor below new point
			traceline(org, org - '0 0 512', TRUE, self);
			org = trace_endpos + self.view_ofs;
			
			// The teleport fuction is working with a radius command
			// and this will ignore walls and just find any position
			// in all directions. This can lead to the monster (e.g. skullwiz)
			// teleporting behind walls or other parts of the map!
			// This can be prevent in two ways:
			// 1) linesight between this monster and player
			// - can leads to less interesting locations (always insight)
			// 2) linesight between new location and old
			// - This allows this monster to teleport around corner
			//   and still be within the same area!
			//
			// Trace through monsters and check trace fraction
			traceline(org, self.origin, TRUE, self);
			if (trace_fraction == 1) blinkfinished = FALSE;
		}

		// Been looping too long, back to original location
		if (blinkcount > 10) {
			blinkfinished = FALSE;
			org = self.origin;
		}
	}
	
	SUB_FindRandomSpawnSpotFinish(org);
};

// Setup wave HP and trigger boundaries
void() SUB_BossWaveSetupHP = { // [FUNCTION]
	// Is there anymore boss waves left?
	if (self.bosswave >= self.bosswavetotal) {
		self.health = self.bosswaveqty; // Only one wave left (death is final trigger)
		self.bosswavetrig = -1000;
	} else {
		// Multiple waves are still left (reset hp+trigger)
		// Always reset HP to stop high DPS weapons trashing waves boundaries
		self.health = ((self.bosswavetotal - self.bosswave) + 1) * self.bosswaveqty;
		// The wave trigger is always one wave lower
		self.bosswavetrig = self.health - self.bosswaveqty;
	}
	// Debug messages for wave and health
	dprint("\b[BOSS]\b Wave ("); dprint(ftos(self.bosswave));
	dprint(" / "); dprint(ftos(self.bosswavetotal));
	dprint(") HP ("); dprint(ftos(self.health));
	dprint(") Trig ("); dprint(ftos(self.bosswavetrig));
	dprint(")\n");
};

// Check for boss wave boundary event.
float(float ctype) SUB_BossWaveCheck = { // [FUNCTION]
	if (self.classtype == CT_MONJUDGE && self.style == 3) return TRUE;

	if (self.health > 1 && self.health < self.bosswavetrig) {
		// Check for wave boundary triggers
		self.noise = "";
		if (self.bosswave == 1) self.noise = self.noise1;
		else if (self.bosswave == 2) self.noise = self.noise2;
		else if (self.bosswave == 3) self.noise = self.noise3;
		else if (self.bosswave == 4) self.noise = self.noise4;
		
		// Is there any trigger for the wave boundary?
		if (self.noise != "") {
			if (self.classtype == CT_MONJUDGE || self.classtype == CT_MONNOUR
				|| self.classtype == CT_MONXXCHTHON
				|| self.classtype == CT_MONXXSHUB) {
				trigger_strs(self.noise, self);
			} else {
				self.attachment2 = find(world, targetname, self.noise);
				// Spawn any adds to keep player busy
				if (self.attachment2.classtype == ctype) {
					if (HasTargets(self.attachment2)) {
						SUB_UseTargetsOnEnt(self.attachment2);
					}
					self.th_jump(); // Turn around and blow up breakables
				}
			}
		}

		// Update Boss wave parameters (next wave!)
		self.bosswave = self.bosswave + 1;
		SUB_BossWaveSetupHP();	// Reset trigger/hp
		if (self.classtype == CT_MONJUDGE|| self.classtype == CT_MONNOUR
			|| self.classtype == CT_MONXXCHTHON
			|| self.classtype == CT_MONXXSHUB) {
			self.style = 3; // Summon mode
		}
		return TRUE;
	}
	return FALSE;
};

float(entity targ) Armored = {
	if (targ.armorvalue > 0 && targ.armortype > 0) return TRUE;
	if (targ.hittype == HIT_METAL) return TRUE;
	if (targ.classgroup == CG_OGRE) {
		if ((targ.spawnflags & MON_OGRE_GREEN)
			|| (targ.spawnflags & MON_HOGRE_METAL)) {
			return TRUE;
		}
	}
	return FALSE;
};

float(entity targ) StoneArmored = {
	if (targ.hittype == HIT_STONE) return TRUE;
	if (targ.classgroup == CG_STONE) return TRUE;
	if (targ.gibtype == GIBTYPE_STONE) return TRUE;
	return FALSE;
};

vector(entity targ) SUB_EntityOrigin = {
	if (targ.bsporigin) return = bmodel_origin(targ);
	else return targ.origin;
};

vector(entity targ) AbsBoundsCenter = {
	return ((targ.absmin + targ.absmax) * 0.5);
};

void() SUB_GrowAngle = { self.angles_y = self.angles_y + self.lefty; };