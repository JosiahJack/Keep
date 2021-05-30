//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: All
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
// Function count: 28
//
// Implements: Subroutines and Entity I/O System
//
// Description:
// Various utility subroutine functions used everywhere as well as the main
// target->targetname entity I/O system.  Runs all forms of target such as
// target2, target3, target4, statetarget1 - statetarget32, killtarget, etc.
//=============================================================================

void() SUB_Null = {};
void() SUB_Remove = {remove(self);};
void(entity inflictor, entity attacker, float damage) SUB_Null_pain = {};
void() SUB_CalcMoveDone;
void() SUB_CalcAngleMoveDone;
void(vector marker_org, float marker_type) spawn_marker;
void(entity thekilled, entity attacker) AddToKills;
void(entity targ) AddToTotals;

// To determine if an entity is still active this function generates an unique number that can be checked/shared between linked entities.
void(entity targ) gen_unique_no = {
	if (targ.entno_unique == 0) targ.entno_unique = rint(random()*1000) * rint(random()*1000); // Check if target entity has an unique number already
};

// Most of the monsters have an attack_offset setup to spawn their proejctiles in the right location relative to their gun model.
// This function expects the makevectors has been done already.  makevectors (self.angles); <--- if missing, vector will be rubbish!
vector(vector attack_dir) attack_vector = {
	local vector retvec;

	retvec = v_forward * attack_dir_x;
	retvec = retvec + (v_right * attack_dir_y);
	retvec = retvec + (v_up * attack_dir_z);
	return retvec;
};

float(vector checkpos, vector abmax, vector abmin) SUB_CheckPointInBounds = {
	if ((checkpos_x < abmax_x) && (checkpos_y < abmax_y) && (checkpos_z < abmax_z) && (checkpos_x > abmin_x) && (checkpos_y > abmin_y) && (checkpos_z > abmin_z)) return TRUE;
	return FALSE;
};

// Bmodels have a 0,0,0 origin key, need to calculate from mins/maxs.  This function will return the true origin using mins/max vectors
vector(entity bmodel_ent) bmodel_origin = {
	local vector vdiff, vorigin;

	// Calculate the middle point of the mins/maxs size vectors
	vdiff_x = (bmodel_ent.maxs_x - bmodel_ent.mins_x) / 2;
	vdiff_y = (bmodel_ent.maxs_y - bmodel_ent.mins_y) / 2;
	vdiff_z = (bmodel_ent.maxs_z - bmodel_ent.mins_z) / 2;
	
	// The mins vector is an absolute value of where the Bmodel is located.  Add mins vector to middle point to get true origin
	// When bmodel do move they also update their origin co-ordinates, so any additional movement needs to be added as well.
	// This means that bmodels can be tracked by movement functions
	vorigin = bmodel_ent.origin + bmodel_ent.mins + vdiff;
	return vorigin; // Return origin
};

// This is version is using the bbmin/bbmax entity keys instead.  Useful if the entity is hidden and want to know origin
vector(entity bmodel_ent) bmodel_bborigin = {
	local vector vdiff, vorigin;
	vdiff_x = (bmodel_ent.bbmaxs_x - bmodel_ent.bbmins_x) * 0.5;
	vdiff_y = (bmodel_ent.bbmaxs_y - bmodel_ent.bbmins_y) * 0.5;
	vdiff_z = (bmodel_ent.bbmaxs_z - bmodel_ent.bbmins_z) * 0.5;
	vorigin = bmodel_ent.origin + bmodel_ent.bbmins + vdiff;
	return vorigin;
};

// Check for bmodel errors, model key empty (can crash engine)
float() check_bmodel_keys = {
	if (self.model == "") {
		// this error can be fatal for most engines, show warning
		dprint ("\b[BMODEL]\b "); dprint (self.classname);
		dprint (" ("); dprint (self.targetname);
		dprint (") missing MODEL key!\n");
		
		self.classtype = CT_DEVMARKER;		// Useless entity
		self.movetype = MOVETYPE_NONE;		// Stationary
		self.solid = SOLID_NOT;				// no world interaction
		
		// If developer active show yellow diamond
		if (developer > 0) setmodel(self, MODEL_BROKEN);
		else setmodel(self,"");
		
		// Make sure no world interaction
		setsize (self, VEC_ORIGIN, VEC_ORIGIN);
		
		// Randomly place debug diamond above 0,0,0
		self.pos1 = '0 0 0';
		self.pos1_z = random()*64;
		setorigin(self, self.pos1);
		
		// Do nothing with this entity
		return TRUE;
	}
	else return FALSE;
};
	
// QuakeEd only writes a single float for angles (bad idea), so up and down are just constant angles.
void() SetMovedir = {
	if (self.angles == '0 -1 0') self.movedir = '0 0 1';
	else if (self.angles == '0 -2 0') self.movedir = '0 0 -1';
	else {
		makevectors (self.angles);
		self.movedir = v_forward;
	}
	self.angles = '0 0 0'; // Bmodels need angles key reset otherwise twisted on spawn
};

float(vector check_vec) CheckZeroVector = {
	if (check_vec_x == 0 && check_vec_y == 0 && check_vec_z == 0) return TRUE;
	else return FALSE;
};

// Some entities have directional parameters (angles -> movedir).  This function searches for an angletarget entity (useful for tracking).
// Always finds the first target key (will fail if multiple targets).
void(entity targ, float return_target) TargetMovedir = {
	local entity angle_dest;
	local vector targ_origin, angle_dest_origin;

	if (targ.angletarget == "") return; // Exit if no angletarget defined
	
	angle_dest = find(world, targetname, targ.angletarget); // Find angle target entity
	if (angle_dest) {
		if (targ.bsporigin) targ_origin = bmodel_origin(targ); // Check for Bmodel origin for targ/angle_dest
		else targ_origin = targ.origin;
		if (angle_dest.bsporigin) angle_dest_origin = bmodel_origin(angle_dest);
		else angle_dest_origin = angle_dest.origin;

		self.movedir = normalize(angle_dest_origin - targ_origin); // Calculate facing angle towards target

		if (return_target) { // Modify variables for the calling function (def=FALSE).  Black box activity detected.
			self.movetarget = angle_dest;	// Target entity
			self.dest1 = angle_dest_origin;	// Target origin
		}
	}
};

// Used by thinks to automatically set default arguments
void() TargetMovedirReturn = { TargetMovedir(self, TRUE); };

// Setup triggers.  Angles are used for one-way touches.  An angle of 0 is assumed to mean no restrictions, so use a yaw of 360 instead.
void() InitTrigger = {
	if (CheckZeroVector(self.angles) == FALSE) SetMovedir();
	self.solid = SOLID_TRIGGER;
	self.movetype = MOVETYPE_NONE;
	self.mdl = self.model;		// Save model for later
	setmodel (self, self.mdl);	// set size and link into world
	self.bbmins = self.mins;	// Save bmodel bounds for later
	self.bbmaxs = self.maxs;
	self.bsporigin = TRUE;		// bmodel origin 0,0,0
	self.modelindex = 0;
	self.model = "";			// hide bmodel surface
};

// PM:  The point trigger version of InitTrigger.
void() InitPointTrigger = {
    local   vector  v1, v2;

    v1 = self.origin;
    v2 = v1 + self.mangle;
    self.model = "";
    setorigin (self, '0 0 0');
    InitTrigger ();     // Calls 'setmodel', so do first.
    setsize (self, v1, v2);     // Calling 'setmodel' resets entity size.
};

// Calculate self.velocity and self.nextthink to reach dest from self.origin traveling at speed.
void() SUB_FacingAngle_Tick = {
	self.faceangle_time = self.faceangle_time - self.faceangle_div; // Decrease move/face time
	
	if (self.faceangle_time <= 0) SUB_CalcMoveDone(); // Is the movetime over? on to tidy up function
	else {
		self.angles = self.angles + self.faceangle_inc; // Adjust angles slowly to match final angle
		
		// The 'moving time' does not always divide perfectly.  Allow for final remainder to be last division
		if (self.faceangle_time < self.faceangle_div) self.nextthink = time + self.faceangle_time;
		else self.nextthink = time + self.faceangle_div;
		
		self.think = SUB_FacingAngle_Tick; // Keep ticking through this function
	}
};

void(float movetime) SUB_FacingAngle_Setup = {
	local vector facediff;
	local float divtime;

	facediff = vectormod(self.finalangle - self.angles); // Convert angle difference to 0-360 scale
	// Check for 0/360 boundary and reverse difference
	if (facediff_x > 180) facediff_x = facediff_x - 360;
	if (facediff_y > 180) facediff_y = facediff_y - 360;
	if (facediff_z > 180) facediff_z = facediff_z - 360;
	if (self.faceangle_div < 0.02) self.faceangle_div = 0.05; // Tick rate of 0.05 is 20fps, the engine will struggle with <0.02
	divtime = movetime / self.faceangle_div;
	self.faceangle_inc = facediff / divtime;
	self.faceangle_time = movetime;
	self.nextthink = time + self.faceangle_div; // Nothing has moved yet, so wait a bit
	self.think = SUB_FacingAngle_Tick;
};

void(vector tdest, float tspeed, void() func) SUB_CalcMove = {
	local vector vdestdelta;
	local float len, traveltime;

	if (!tspeed) tspeed = 40;			// Create default speed if none specified
	self.think1 = func;					// Finished moving function
	self.finaldest = tdest;				// Final origin (Overwrite existing values)
	self.think = SUB_CalcMoveDone;		// Tidy up function
	vdestdelta = tdest - self.origin;	// set destdelta to the vector needed to move
	len = vlen (vdestdelta);			// calculate length of vector
	traveltime = len / tspeed;			// divide by speed to get time to reach dest
	if (self.faceangle > 0 && self.bsporigin > 0) self.faceangle = FALSE; // Check if faceangle is active on a func bmodel mover?
	
	// If move distance or time too small, snap to final location
	if (traveltime < 0.1 || tdest == self.origin) {
		if (self.faceangle > 0) self.angles = self.finalangle;
		self.velocity = '0 0 0';
		if (self.bsporigin > 0) self.nextthink = self.ltime + 0.1;
		else self.nextthink = time + 0.1;
		return;
	}

	if (self.classname == "fliquid") self.fmover = "moving"; // Update for moving liquids - from extras_r4/r5.  No sense having a separate SUB_fCalcMove for a one line difference.

	// scale the destdelta vector by the time spent traveling to get velocity
	self.velocity = vdestdelta * (1/traveltime);	// qcc won't take vec/float
	if (self.bsporigin > 0) self.nextthink = self.ltime + traveltime;
	else self.nextthink = time + traveltime;

	if (self.faceangle > 0) SUB_FacingAngle_Setup(traveltime); // Check for any facing angle functionality
};

// After moving, set origin to exact final destination rather than last value that is very very close but not quite.
void()  SUB_CalcMoveDone = {
	if (self.classname == "fliquid") self.fmover = string_null; // Update for moving liquids - from extras_r4/r5
	self.velocity = '0 0 0';
	setorigin(self, self.finaldest);
	self.nextthink = -1;
	if (self.think1) self.think1();
};

void() DelayThink = {
	activator = self.enemy;
	SUB_UseTargets ();
	remove(self);
};

// Checks if an entity has any target variables defined and returns TRUE if so.  Useful to know if a monster should not be removed before runing targets.
float(entity t) HasTargets = {
	if (t.killtarget ||
		t.target ||
		t.target2 ||
		t.target3 ||
		t.target4 ||
		t.statetarget1 ||
		t.statetarget2 ||
		t.statetarget3 ||
		t.statetarget4 ||
		t.statetarget5 ||
		t.statetarget6 ||
		t.statetarget7 ||
		t.statetarget8 ||
		t.statetarget9 ||
		t.statetarget10 ||
		t.statetarget11 ||
		t.statetarget12 ||
		t.statetarget13 ||
		t.statetarget14 ||
		t.statetarget15 ||
		t.statetarget16 ||
		t.statetarget17 ||
		t.statetarget18 ||
		t.statetarget19 ||
		t.statetarget20 ||
		t.statetarget21 ||
		t.statetarget22 ||
		t.statetarget23 || // ridiculous ain't it!
		t.statetarget24 ) return TRUE;
	return FALSE;
};

// Clear all target strings
void (entity t) clear_trigstrs = {
	t.killtarget = string_null;
	t.target = string_null;
	t.target2 = string_null;
	t.target3 = string_null;
	t.target4 = string_null;
	t.statetarget1 = string_null;
	t.statetarget2 = string_null;
	t.statetarget3 = string_null;
	t.statetarget4 = string_null;
	t.statetarget5 = string_null;
	t.statetarget6 = string_null;
	t.statetarget7 = string_null;
	t.statetarget8 = string_null;
	t.statetarget9 = string_null;
	t.statetarget10 = string_null;
	t.statetarget11 = string_null;
	t.statetarget12 = string_null;
	t.statetarget13 = string_null;
	t.statetarget14 = string_null;
	t.statetarget15 = string_null;
	t.statetarget16 = string_null;
	t.statetarget17 = string_null;
	t.statetarget18 = string_null;
	t.statetarget19 = string_null;
	t.statetarget20 = string_null;
	t.statetarget21 = string_null;
	t.statetarget22 = string_null;
	t.statetarget23 = string_null;
	t.statetarget24 = string_null;
};

void(string text) Mass_Centerprint;

// Runs all targets for entity I/O.  The global "activator" should be set to the entity that initiated the firing.
// If self.delay is set, a DelayedUse entity will be created that will actually do the SUB_UseTargets after that many seconds have passed.  Centerprints any self.message to the activator.
// Removes all entities with a targetname that match self.killtarget, and removes them, so some events can remove other triggers.
// Search for (string)targetname in all entities that match (string)self.target and call their .use function
void() SUB_UseTargets = {
	local entity t, stemp, otemp, act;

	if (self.delay) { // check for a delay
		t = spawn(); // create a temp object to fire at a later time after time + self.delay
		t.classname = "DelayedUse";
		t.classtype = CT_TRIGRELAYDELAY;
		t.owner = self;
		t.nextthink = time + self.delay;
		t.think = DelayThink;
		t.enemy = activator;
		t.message = self.message;
		t.killtarget = self.killtarget;
		t.target = self.target;
		t.target2 = self.target2;
		t.target3 = self.target3;
		t.target4 = self.target4;
		t.statetarget1 = self.statetarget1;
		t.statetarget2 = self.statetarget2;
		t.statetarget3 = self.statetarget3;
		t.statetarget4 = self.statetarget4;
		t.statetarget5 = self.statetarget5;
		t.statetarget6 = self.statetarget6;
		t.statetarget7 = self.statetarget7;
		t.statetarget8 = self.statetarget8;
		t.statetarget9 = self.statetarget9;
		t.statetarget10 = self.statetarget10;
		t.statetarget11 = self.statetarget11;
		t.statetarget12 = self.statetarget12;
		t.statetarget13 = self.statetarget13;
		t.statetarget14 = self.statetarget14;
		t.statetarget15 = self.statetarget15;
		t.statetarget16 = self.statetarget16;
		t.statetarget17 = self.statetarget17;
		t.statetarget18 = self.statetarget18;
		t.statetarget19 = self.statetarget19;
		t.statetarget20 = self.statetarget20;
		t.statetarget21 = self.statetarget21;
		t.statetarget22 = self.statetarget22;
		t.statetarget23 = self.statetarget23;
		t.statetarget24 = self.statetarget24; // ridiculous ain't it!
		t.noise = self.noise;
		return;
	}
	
	// Check if previous delay has been disabled.  Unfortunately start off = OFF state and not easy to check for because some entities use that spawnflag bit for other things!
	if (self.classtype == CT_TRIGRELAYDELAY && (self.owner.estate & ESTATE_DISABLE)) return;

	// print any messages
	if (activator.flags & FL_CLIENT && self.message != "") {
		if (coop > 0) Mass_Centerprint(self.message);
		else centerprint (activator, self.message); // Write message to single client
		
		if (self.noise == "") sound (activator, CHAN_VOICE, SOUND_TALK, 1, ATTN_NORM); // Default noise = classic boop boop sound
	}

	// sock: I really do hate this function because there is hardly any checks on entities being removed; added a player check for sanity!
	if (self.killtarget != "") {
		t = find (world, targetname, self.killtarget);
		while(t) {
			if (t.flags & FL_MONSTER && t.health > 0) { // Check for activate mosnters? Tidy up kill counter
				if (t.nomonstercount) AddToTotals(self); // If a monster marked with no monster count dies update HUD totals to reflect death properly
				AddToKills(self,activator);
			}
			if (!(t.flags & FL_CLIENT)) { // Added extra check to prevent player client removal!?!
				// Try to minimize the entity chain damage, check for entity attachments and delete them as well!
				if (t.attachment) remove(t.attachment);
				if (t.attachment2) remove(t.attachment2);
				if (t.attachment3) remove(t.attachment3);
				// Make sure any unique ent number is reset
				if (t.entno_unique > 0) t.entno_unique = 0;
				remove (t); // Remove entity from chain list.  BOOM! She gone
			}
			t = find (t, targetname, self.killtarget); // Find the next killtarget
		} 
	}
	if (self.target != "") {
		act = activator;	// ID Code - Never switch around, not sure why it is here?
		t = find (world, targetname, self.target);
		stemp = self; otemp = other;		// Store self/other
		while(t) {
			if (t.use != SUB_Null) {
				if (t.use) {
					self = t; other = stemp;		// Switch self/other
					self.activate = stemp;			// used by the breakable system
					self.use ();					// fire trigger
					self = stemp; other = otemp;	// restore self/other
					activator = act;		// ID code - Never changed, why restore it?
				}
			}
			// Are there anymore targets left in the list?
			t = find (t, targetname, self.target);
		} 
	}
	if (self.target2 != "") {
		act = activator;	// ID Code - Never switch around, not sure why it is here?
		t = find (world, targetname, self.target2);
		stemp = self; otemp = other;		// Store self/other
		while(t) {
			if (t.use != SUB_Null) {
				if (t.use) {
					self = t; other = stemp;// Switch self/other
					self.activate = stemp;	// used mostly by the breakable system
					self.use ();			// fire trigger
					self = stemp; other = otemp;	// restore self/other
					activator = act;		// ID code - Never changed, why restore it?
				}
			}
			t = find (t, targetname, self.target2);
		} 
	}
	if (self.target3 != "") {
		act = activator;	// ID Code - Never switch around, not sure why it is here?
		t = find (world, targetname, self.target3);
		stemp = self; otemp = other;		// Store self/other
		while(t) {
			if (t.use != SUB_Null) {
				if (t.use) {
					self = t; other = stemp;// Switch self/other
					self.activate = stemp;	// used mostly by the breakable system
					self.use ();			// fire trigger
					self = stemp; other = otemp;	// restore self/other
					activator = act;		// ID code - Never changed, why restore it?
				}
			}
			t = find (t, targetname, self.target3);
		} 
	}
	if (self.target4 != "") {
		act = activator;	// ID Code - Never switch around, not sure why it is here?
		t = find (world, targetname, self.target4);
		stemp = self; otemp = other;		// Store self/other
		while(t) {
			if (t.use != SUB_Null) {
				if (t.use) {
					self = t; other = stemp;// Switch self/other
					self.activate = stemp;	// used mostly by the breakable system
					self.use ();			// fire trigger
					self = stemp; other = otemp;	// restore self/other
					activator = act;		// ID code - Never changed, why restore it?
				}
			}
			t = find (t, targetname, self.target4);
		} 
	}
	if (self.statetarget1 != "" && (globalstate & GLOBALSTATE_1)) {
		act = activator;	// ID Code - Never switch around, not sure why it is here?
		t = find (world, targetname, self.statetarget1);
		stemp = self; otemp = other;		// Store self/other
		while(t) {
			if (t.use != SUB_Null) {
				if (t.use) {
					self = t; other = stemp;// Switch self/other
					self.activate = stemp;	// used mostly by the breakable system
					self.use ();			// fire trigger
					self = stemp; other = otemp;	// restore self/other
					activator = act;		// ID code - Never changed, why restore it?
				}
			}
			t = find (t, targetname, self.statetarget1);
		} 
	}
	if (self.statetarget2 != "" && (globalstate & GLOBALSTATE_2)) {
		act = activator;	// ID Code - Never switch around, not sure why it is here?
		t = find (world, targetname, self.statetarget2);
		stemp = self; otemp = other;		// Store self/other
		while(t) {
			if (t.use != SUB_Null) {
				if (t.use) {
					self = t; other = stemp;// Switch self/other
					self.activate = stemp;	// used mostly by the breakable system
					self.use ();			// fire trigger
					self = stemp; other = otemp;	// restore self/other
					activator = act;		// ID code - Never changed, why restore it?
				}
			}
			t = find (t, targetname, self.statetarget2);
		} 
	}
	if (self.statetarget3 != "" && (globalstate & GLOBALSTATE_3)) {
		act = activator;	// ID Code - Never switch around, not sure why it is here?
		t = find (world, targetname, self.statetarget3);
		stemp = self; otemp = other;		// Store self/other
		while(t) {
			if (t.use != SUB_Null) {
				if (t.use) {
					self = t; other = stemp;// Switch self/other
					self.activate = stemp;	// used mostly by the breakable system
					self.use ();			// fire trigger
					self = stemp; other = otemp;	// restore self/other
					activator = act;		// ID code - Never changed, why restore it?
				}
			}
			t = find (t, targetname, self.statetarget3);
		} 
	}
	if (self.statetarget4 != "" && (globalstate & GLOBALSTATE_4)) {
		act = activator;	// ID Code - Never switch around, not sure why it is here?
		t = find (world, targetname, self.statetarget4);
		stemp = self; otemp = other;		// Store self/other
		while(t) {
			if (t.use != SUB_Null) {
				if (t.use) {
					self = t; other = stemp;// Switch self/other
					self.activate = stemp;	// used mostly by the breakable system
					self.use ();			// fire trigger
					self = stemp; other = otemp;	// restore self/other
					activator = act;		// ID code - Never changed, why restore it?
				}
			}
			t = find (t, targetname, self.statetarget4);
		} 
	}
	if (self.statetarget5 != "" && (globalstate & GLOBALSTATE_5)) {
		act = activator;	// ID Code - Never switch around, not sure why it is here?
		t = find (world, targetname, self.statetarget5);
		stemp = self; otemp = other;		// Store self/other
		while(t) {
			if (t.use != SUB_Null) {
				if (t.use) {
					self = t; other = stemp;// Switch self/other
					self.activate = stemp;	// used mostly by the breakable system
					self.use ();			// fire trigger
					self = stemp; other = otemp;	// restore self/other
					activator = act;		// ID code - Never changed, why restore it?
				}
			}
			t = find (t, targetname, self.statetarget5);
		} 
	}
	if (self.statetarget6 != "" && (globalstate & GLOBALSTATE_6)) {
		act = activator;	// ID Code - Never switch around, not sure why it is here?
		t = find (world, targetname, self.statetarget6);
		stemp = self; otemp = other;		// Store self/other
		while(t) {
			if (t.use != SUB_Null) {
				if (t.use) {
					self = t; other = stemp;// Switch self/other
					self.activate = stemp;	// used mostly by the breakable system
					self.use ();			// fire trigger
					self = stemp; other = otemp;	// restore self/other
					activator = act;		// ID code - Never changed, why restore it?
				}
			}
			t = find (t, targetname, self.statetarget6);
		} 
	}
	if (self.statetarget7 != "" && (globalstate & GLOBALSTATE_7)) {
		act = activator;	// ID Code - Never switch around, not sure why it is here?
		t = find (world, targetname, self.statetarget7);
		stemp = self; otemp = other;		// Store self/other
		while(t) {
			if (t.use != SUB_Null) {
				if (t.use) {
					self = t; other = stemp;// Switch self/other
					self.activate = stemp;	// used mostly by the breakable system
					self.use ();			// fire trigger
					self = stemp; other = otemp;	// restore self/other
					activator = act;		// ID code - Never changed, why restore it?
				}
			}
			t = find (t, targetname, self.statetarget7);
		} 
	}
	if (self.statetarget8 != "" && (globalstate & GLOBALSTATE_8)) {
		act = activator;	// ID Code - Never switch around, not sure why it is here?
		t = find (world, targetname, self.statetarget8);
		stemp = self; otemp = other;		// Store self/other
		while(t) {
			if (t.use != SUB_Null) {
				if (t.use) {
					self = t; other = stemp;// Switch self/other
					self.activate = stemp;	// used mostly by the breakable system
					self.use ();			// fire trigger
					self = stemp; other = otemp;	// restore self/other
					activator = act;		// ID code - Never changed, why restore it?
				}
			}
			t = find (t, targetname, self.statetarget8);
		} 
	}
	if (self.statetarget9 != "" && (globalstate & GLOBALSTATE_9)) {
		act = activator;	// ID Code - Never switch around, not sure why it is here?
		t = find (world, targetname, self.statetarget9);
		stemp = self; otemp = other;		// Store self/other
		while(t) {
			if (t.use != SUB_Null) {
				if (t.use) {
					self = t; other = stemp;// Switch self/other
					self.activate = stemp;	// used mostly by the breakable system
					self.use ();			// fire trigger
					self = stemp; other = otemp;	// restore self/other
					activator = act;		// ID code - Never changed, why restore it?
				}
			}
			t = find (t, targetname, self.statetarget9);
		} 
	}
	if (self.statetarget10 != "" && (globalstate & GLOBALSTATE_10)) {
		act = activator;	// ID Code - Never switch around, not sure why it is here?
		t = find (world, targetname, self.statetarget10);
		stemp = self; otemp = other;		// Store self/other
		while(t) {
			if (t.use != SUB_Null) {
				if (t.use) {
					self = t; other = stemp;// Switch self/other
					self.activate = stemp;	// used mostly by the breakable system
					self.use ();			// fire trigger
					self = stemp; other = otemp;	// restore self/other
					activator = act;		// ID code - Never changed, why restore it?
				}
			}
			t = find (t, targetname, self.statetarget10);
		} 
	}
	if (self.statetarget11 != "" && (globalstate & GLOBALSTATE_11)) {
		act = activator;	// ID Code - Never switch around, not sure why it is here?
		t = find (world, targetname, self.statetarget11);
		stemp = self; otemp = other;		// Store self/other
		while(t) {
			if (t.use != SUB_Null) {
				if (t.use) {
					self = t; other = stemp;// Switch self/other
					self.activate = stemp;	// used mostly by the breakable system
					self.use ();			// fire trigger
					self = stemp; other = otemp;	// restore self/other
					activator = act;		// ID code - Never changed, why restore it?
				}
			}
			t = find (t, targetname, self.statetarget11);
		} 
	}
	if (self.statetarget12 != "" && (globalstate & GLOBALSTATE_12)) {
		act = activator;	// ID Code - Never switch around, not sure why it is here?
		t = find (world, targetname, self.statetarget12);
		stemp = self; otemp = other;		// Store self/other
		while(t) {
			if (t.use != SUB_Null) {
				if (t.use) {
					self = t; other = stemp;// Switch self/other
					self.activate = stemp;	// used mostly by the breakable system
					self.use ();			// fire trigger
					self = stemp; other = otemp;	// restore self/other
					activator = act;		// ID code - Never changed, why restore it?
				}
			}
			t = find (t, targetname, self.statetarget12);
		} 
	}
	if (self.statetarget13 != "" && (globalstate & GLOBALSTATE_13)) {
		act = activator;	// ID Code - Never switch around, not sure why it is here?
		t = find (world, targetname, self.statetarget13);
		stemp = self; otemp = other;		// Store self/other
		while(t) {
			if (t.use != SUB_Null) {
				if (t.use) {
					self = t; other = stemp;// Switch self/other
					self.activate = stemp;	// used mostly by the breakable system
					self.use ();			// fire trigger
					self = stemp; other = otemp;	// restore self/other
					activator = act;		// ID code - Never changed, why restore it?
				}
			}
			t = find (t, targetname, self.statetarget13);
		} 
	}
	if (self.statetarget14 != "" && (globalstate & GLOBALSTATE_14)) {
		act = activator;	// ID Code - Never switch around, not sure why it is here?
		t = find (world, targetname, self.statetarget14);
		stemp = self; otemp = other;		// Store self/other
		while(t) {
			if (t.use != SUB_Null) {
				if (t.use) {
					self = t; other = stemp;// Switch self/other
					self.activate = stemp;	// used mostly by the breakable system
					self.use ();			// fire trigger
					self = stemp; other = otemp;	// restore self/other
					activator = act;		// ID code - Never changed, why restore it?
				}
			}
			t = find (t, targetname, self.statetarget14);
		} 
	}
	if (self.statetarget15 != "" && (globalstate & GLOBALSTATE_15)) {
		act = activator;	// ID Code - Never switch around, not sure why it is here?
		t = find (world, targetname, self.statetarget15);
		stemp = self; otemp = other;		// Store self/other
		while(t) {
			if (t.use != SUB_Null) {
				if (t.use) {
					self = t; other = stemp;// Switch self/other
					self.activate = stemp;	// used mostly by the breakable system
					self.use ();			// fire trigger
					self = stemp; other = otemp;	// restore self/other
					activator = act;		// ID code - Never changed, why restore it?
				}
			}
			t = find (t, targetname, self.statetarget15);
		} 
	}
	if (self.statetarget16 != "" && (globalstate & GLOBALSTATE_16)) {
		act = activator;	// ID Code - Never switch around, not sure why it is here?
		t = find (world, targetname, self.statetarget16);
		stemp = self; otemp = other;		// Store self/other
		while(t) {
			if (t.use != SUB_Null) {
				if (t.use) {
					self = t; other = stemp;// Switch self/other
					self.activate = stemp;	// used mostly by the breakable system
					self.use ();			// fire trigger
					self = stemp; other = otemp;	// restore self/other
					activator = act;		// ID code - Never changed, why restore it?
				}
			}
			t = find (t, targetname, self.statetarget16);
		} 
	}
	if (self.statetarget17 != "" && (globalstate & GLOBALSTATE_17)) {
		act = activator;	// ID Code - Never switch around, not sure why it is here?
		t = find (world, targetname, self.statetarget17);
		stemp = self; otemp = other;		// Store self/other
		while(t) {
			if (t.use != SUB_Null) {
				if (t.use) {
					self = t; other = stemp;// Switch self/other
					self.activate = stemp;	// used mostly by the breakable system
					self.use ();			// fire trigger
					self = stemp; other = otemp;	// restore self/other
					activator = act;		// ID code - Never changed, why restore it?
				}
			}
			t = find (t, targetname, self.statetarget17);
		} 
	}
	if (self.statetarget18 != "" && (globalstate & GLOBALSTATE_18)) {
		act = activator;	// ID Code - Never switch around, not sure why it is here?
		t = find (world, targetname, self.statetarget18);
		stemp = self; otemp = other;		// Store self/other
		while(t) {
			if (t.use != SUB_Null) {
				if (t.use) {
					self = t; other = stemp;// Switch self/other
					self.activate = stemp;	// used mostly by the breakable system
					self.use ();			// fire trigger
					self = stemp; other = otemp;	// restore self/other
					activator = act;		// ID code - Never changed, why restore it?
				}
			}
			t = find (t, targetname, self.statetarget18);
		} 
	}
	if (self.statetarget19 != "" && (globalstate & GLOBALSTATE_19)) {
		act = activator;	// ID Code - Never switch around, not sure why it is here?
		t = find (world, targetname, self.statetarget19);
		stemp = self; otemp = other;		// Store self/other
		while(t) {
			if (t.use != SUB_Null) {
				if (t.use) {
					self = t; other = stemp;// Switch self/other
					self.activate = stemp;	// used mostly by the breakable system
					self.use ();			// fire trigger
					self = stemp; other = otemp;	// restore self/other
					activator = act;		// ID code - Never changed, why restore it?
				}
			}
			t = find (t, targetname, self.statetarget19);
		} 
	}
	if (self.statetarget20 != "" && (globalstate & GLOBALSTATE_20)) {
		act = activator;	// ID Code - Never switch around, not sure why it is here?
		t = find (world, targetname, self.statetarget20);
		stemp = self; otemp = other;		// Store self/other
		while(t) {
			if (t.use != SUB_Null) {
				if (t.use) {
					self = t; other = stemp;// Switch self/other
					self.activate = stemp;	// used mostly by the breakable system
					self.use ();			// fire trigger
					self = stemp; other = otemp;	// restore self/other
					activator = act;		// ID code - Never changed, why restore it?
				}
			}
			t = find (t, targetname, self.statetarget20);
		} 
	}
	if (self.statetarget21 != "" && (globalstate & GLOBALSTATE_21)) {
		act = activator;	// ID Code - Never switch around, not sure why it is here?
		t = find (world, targetname, self.statetarget21);
		stemp = self; otemp = other;		// Store self/other
		while(t) {
			if (t.use != SUB_Null) {
				if (t.use) {
					self = t; other = stemp;// Switch self/other
					self.activate = stemp;	// used mostly by the breakable system
					self.use ();			// fire trigger
					self = stemp; other = otemp;	// restore self/other
					activator = act;		// ID code - Never changed, why restore it?
				}
			}
			t = find (t, targetname, self.statetarget21);
		} 
	}
	if (self.statetarget22 != "" && (globalstate & GLOBALSTATE_22)) {
		act = activator;	// ID Code - Never switch around, not sure why it is here?
		t = find (world, targetname, self.statetarget22);
		stemp = self; otemp = other;		// Store self/other
		while(t) {
			if (t.use != SUB_Null) {
				if (t.use) {
					self = t; other = stemp;// Switch self/other
					self.activate = stemp;	// used mostly by the breakable system
					self.use ();			// fire trigger
					self = stemp; other = otemp;	// restore self/other
					activator = act;		// ID code - Never changed, why restore it?
				}
			}
			t = find (t, targetname, self.statetarget22);
		} 
	}
	if (self.statetarget23 != "" && (globalstate & GLOBALSTATE_23)) {
		act = activator;	// ID Code - Never switch around, not sure why it is here?
		t = find (world, targetname, self.statetarget23);
		stemp = self; otemp = other;		// Store self/other
		while(t) {
			if (t.use != SUB_Null) {
				if (t.use) {
					self = t; other = stemp;// Switch self/other
					self.activate = stemp;	// used mostly by the breakable system
					self.use ();			// fire trigger
					self = stemp; other = otemp;	// restore self/other
					activator = act;		// ID code - Never changed, why restore it?
				}
			}
			t = find (t, targetname, self.statetarget23);
		} 
	}
	if (self.statetarget24 != "" && (globalstate & GLOBALSTATE_24)) {
		act = activator;	// ID Code - Never switch around, not sure why it is here?
		t = find (world, targetname, self.statetarget24);
		stemp = self; otemp = other;		// Store self/other
		while(t) {
			if (t.use != SUB_Null) {
				if (t.use) {
					self = t; other = stemp;// Switch self/other
					self.activate = stemp;	// used mostly by the breakable system
					self.use ();			// fire trigger
					self = stemp; other = otemp;	// restore self/other
					activator = act;		// ID code - Never changed, why restore it?
				}
			}
			t = find (t, targetname, self.statetarget24);
		} 
	}
};

// Safe wrapper function to use instead of trigger_strs so all targets get ran and not just one
void(entity t) SUB_UseTargetsOnEnt = {
	local entity stemp;
	
	if (!HasTargets(t)) return; // No targets to run
	stemp = self;
	self = t;
	SUB_UseTargets();
	self = stemp;
};

// Increases attack finished by specified value.  In nightmare mode, all attack_finished times become 0.
// Some monsters refire twice automatically (using .cnt variable).  Change nightmare to be less range spam and better time scaling.
void(float normal) SUB_AttackFinished = {
	local float nightadj; // Easier to work out percentage

	self.cnt = 0; // reset checkfire counter
	if (skill == SKILL_NIGHTMARE) {
		// Nightmare mode is just endless range attacks!  I never thought this was a good way to end skill levels.
		// Changed nightmare mode to 50-75% decrease in time.  Exceptions to nightmare mode (minion spawning) - 75-100% time.
		nightadj = 0.5 + (random()*0.25);
		if (self.minion_active) nightadj = nightadj + 0.25;
		// The original ID shamblers were lightning turrets on Nightmare
		// Shamblers don't scale with skill levels in AD because they don't have projectiles, so they need a switch instead.
		// On Nightmare skill Shamblers go from 2-4s to 1s!  Instead of 2-4s, NM is 0.6-1.2s, Average 1.2s +2 frames.
		if (self.classtype == CT_MONSHAM) nightadj = 0.4;
		self.attack_finished = time + (normal*nightadj);
	} else self.attack_finished = time + normal; // Easy, Nornal and Hard skill all pass through, no change
};

// Used by soliders and enforcers (special double fire mode)
void (void() thinkst) SUB_CheckRefire = {
	if (skill != SKILL_NIGHTMARE) return;
	if (self.cnt == 1) return;
	if (!visible (self.enemy)) return;
	self.cnt = 1;
	self.think = thinkst;
};

void() play_teleport = {
	self.lip = random() * 5;
	if (self.lip < 1) self.noise = "misc/r_tele1.wav";
	else if (self.lip < 2) self.noise = "misc/r_tele2.wav";
	else if (self.lip < 3) self.noise = "misc/r_tele3.wav";
	else if (self.lip < 4) self.noise = "misc/r_tele4.wav";
	else self.noise = "misc/r_tele5.wav";
	sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	self.nextthink = time + 2;	// Allow time for the sound to finish
	self.think = SUB_Remove;	// tidy up function
};

void(vector org) spawn_tfog = {
	local entity spawneffect;
	
	spawneffect = spawn ();
	spawneffect.origin = org;
	spawneffect.nextthink = time + 0.2;
	spawneffect.think = play_teleport;
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_TELEPORT);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
};

void(entity targ, float hpminimum, float had_regen) Client_CheckMaxHP;

void() tdeath_touch = {
	if (other == self.owner) return; // Cannot telefrag yourself!?!
	if (ai_foundbreakable(self, other, FALSE)) return; // Check if found a breakable than cannot be broken
	
	// A boss cannot be telefragged (except shub).  Telefrag entity trying to telefrag boss instead!?!
	if (other.bossflag == TRUE) {
		if (other.classtype != CT_MONIDSHUB) {
			T_Damage (self.owner, other, other, MEGADEATH, NOARMOR); // Chaos cannot protect you from bosses!
			return;
		}
	}

	if (other.flags & FL_CLIENT) { // Frag anyone who teleports in on top of an invincible player
		if (other.invincible_finished > time || other.perms & POW_ARMORCHAOS) self.classname = "teledeath2";
		if ( !(self.owner.flags & FL_CLIENT) ) { // other monsters explode themselves
			T_Damage (self.owner, self, self, MEGADEATH, NOARMOR);
			return;
		}
	}

	// Sudden death incoming ...
	if (other.health){
		if (other.perms & POW_ARMORCHAOS) {
			other.perms = other.perms - (other.perms & POW_ARMORCHAOS); // use it up
			other.health = 1;
			Client_CheckMaxHP(other,TRUE,FALSE); // Set to half health, the 2nd parameter does this normally for level transitions but we reuse it here
			T_Damage (self.owner, self, self, MEGADEATH, NOARMOR);
			return;
		}
		T_Damage (other, self, self, MEGADEATH, NOARMOR);
	}
};

void(vector org, entity death_owner) spawn_tdeath = {
	local entity death;

	death = spawn();
	death.classname = "teledeath";
	death.owner = death_owner;
	death.movetype = MOVETYPE_NONE;
	death.solid = SOLID_TRIGGER;
	death.angles = '0 0 0';
	setsize (death, death_owner.mins - '1 1 1', death_owner.maxs + '1 1 1');
	setorigin (death, org);
	death.touch = tdeath_touch;
	death.nextthink = time + 0.2;
	death.think = SUB_Remove;
	force_retouch = 2; // !! This is extremely costly on the engine because it re-checks every trigger in the map to see if it is touching something.
};