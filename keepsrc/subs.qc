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
// Function count: 30
//
// Implements: Subroutines and Entity I/O System
//
// Description:
// Various utility subroutine functions used everywhere as well as the main
// target->targetname entity I/O system.  Runs all forms of target such as
// target, target2, target3, target4, killtarget, etc.
//=============================================================================

void() SUB_CalcMoveDone;
void(entity thekilled, entity attacker) AddToKills;
void(entity targ) AddToTotals;
void(string text, string noise, entity act) Mass_Centerprint;
void(entity targ, float hpminimum, float had_regen) Client_CheckMaxHP;
void(float fx, vector spot) Tent_Point;
void(entity ent, void() thinkst) SUB_ThinkImmediate;
void() SUB_RemoveAttachments;
vector(entity targ) SUB_EntityOrigin;

void() SUB_Null = {}; // [FUNCTION]
void() SUB_Remove = { remove(self); }; // [FUNCTION]
void(entity inflictor, entity attacker, float damage) SUB_Null_pain = {}; // [FUNCTION]

// To determine if an entity is still active this function generates an unique number that can be checked/shared between linked entities.
void(entity targ) gen_unique_no = { // [FUNCTION]
	if (targ.entno_unique == 0) targ.entno_unique = rint(random()*1000) * rint(random()*1000); // Check if target entity has an unique number already
};

// Most of the monsters have an attack_offset setup to spawn their proejctiles in the right location relative to their gun model.
// This function expects the makevectors has been done already.  makevectors(self.angles); <--- if missing, vector will be rubbish!
vector(vector attack_dir) attack_vector = { // [FUNCTION]
	local vector retvec;

	retvec = v_forward * attack_dir_x;
	retvec = retvec + (v_right * attack_dir_y);
	retvec = retvec + (v_up * attack_dir_z);
	return retvec;
};

float(vector checkpos, vector abmax, vector abmin) SUB_CheckPointInBounds = { // [FUNCTION]
	if ((checkpos_x < abmax_x) && (checkpos_y < abmax_y) && (checkpos_z < abmax_z) && (checkpos_x > abmin_x) && (checkpos_y > abmin_y) && (checkpos_z > abmin_z)) return TRUE;
	return FALSE;
};

// Bmodels have a 0,0,0 origin key, need to calculate from mins/maxs.  This function will return the true origin using mins/max vectors
vector(entity bmodel_ent) bmodel_origin = { // [FUNCTION]
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
vector(entity bmodel_ent) bmodel_bborigin = { // [FUNCTION]
	local vector vdiff, vorigin;
	vdiff_x = (bmodel_ent.bbmaxs_x - bmodel_ent.bbmins_x) * 0.5;
	vdiff_y = (bmodel_ent.bbmaxs_y - bmodel_ent.bbmins_y) * 0.5;
	vdiff_z = (bmodel_ent.bbmaxs_z - bmodel_ent.bbmins_z) * 0.5;
	vorigin = bmodel_ent.origin + bmodel_ent.bbmins + vdiff;
	return vorigin;
};

// Check for bmodel errors, model key empty (can crash engine)
float() check_bmodel_keys = { // [FUNCTION]
	if (self.model == "") {
		// this error can be fatal for most engines, show warning
		dprint ("\b[BMODEL]\b "); dprint (self.classname);
		dprint (" ("); dprint (self.targetname);
		dprint (") missing MODEL key!\n");
		
		self.classtype = CT_DEVMARKER;		// Useless entity
		self.movetype = MOVETYPE_NONE;		// Stationary
		self.solid = SOLID_NOT;				// no world interaction
		
		// If developer active show yellow diamond
		if (developer > 0) setmodel(self, "progs/q15/misc_broken.mdl");
		else setmodel(self,"");
		
		// Make sure no world interaction
		setsize (self, VEC_ORIGIN, VEC_ORIGIN);
		
		// Randomly place debug diamond above 0,0,0
		self.pos1 = '0 0 0';
		self.pos1_z = random()*64;
		setorigin(self, self.pos1);
		
		// Do nothing with this entity
		return TRUE;
	} else return FALSE;
};
	
// QuakeEd only writes a single float for angles (bad idea), so up and down are just constant angles.
void() SetMovedir = { // [FUNCTION]
	if (self.angles == '0 -1 0') self.movedir = '0 0 1';
	else if (self.angles == '0 -2 0') self.movedir = '0 0 -1';
	else {
		makevectors(self.angles);
		self.movedir = v_forward;
	}
	self.angles = '0 0 0'; // Bmodels need angles key reset otherwise twisted on spawn
};

float(vector check_vec) VectorIsAllZeros = { // [FUNCTION]
	return (check_vec_x == 0 && check_vec_y == 0 && check_vec_z == 0);
};

// Some entities have directional parameters (angles -> movedir).  This function searches for an angletarget entity (useful for tracking).
// Always finds the first target key (will fail if multiple targets).
void(entity targ, float return_target) TargetMovedir = { // [FUNCTION]
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
void() TargetMovedirReturn = { TargetMovedir(self, TRUE); }; // [FUNCTION]

// Setup triggers.  Angles are used for one-way touches.  An angle of 0 is assumed to mean no restrictions, so use a yaw of 360 instead.
void() InitTrigger = { // [FUNCTION]
	if (VectorIsAllZeros(self.angles) == FALSE) SetMovedir();
	self.solid = SOLID_TRIGGER;
	self.movetype = MOVETYPE_NONE;
	self.mdl = self.model;		// Save model for later
	setmodel(self, self.mdl);	// set size and link into world
	self.bbmins = self.mins;	// Save bmodel bounds for later
	self.bbmaxs = self.maxs;
	self.bsporigin = TRUE;		// bmodel origin 0,0,0
	self.modelindex = 0;
	self.model = "";			// hide bmodel surface
};

// PM:  The point trigger version of InitTrigger.
void() InitPointTrigger = { // [FUNCTION]
    local   vector  v1, v2;

    v1 = self.origin;
    v2 = v1 + self.mangle;
    self.model = "";
    setorigin(self, '0 0 0');
    InitTrigger();     // Calls 'setmodel', so do first.
    setsize (self, v1, v2);     // Calling 'setmodel' resets entity size.
};

// Calculate self.velocity and self.nextthink to reach dest from self.origin traveling at speed.
void() SUB_FacingAngle_Tick = { // [FUNCTION]
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

void(float movetime) SUB_FacingAngle_Setup = { // [FUNCTION]
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

void(vector tdest, float tspeed, void() func) SUB_CalcMove = { // [FUNCTION]
	local vector vdestdelta;
	local float len, traveltime;

	if (!tspeed) {
		tspeed = 40;			// Create default speed if none specified
		dprint("\bWarning\b No tspeed passed to SUB_CalcMove for ");
		dprint(self.classname);
		dprint("!\n");
	}
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
void()  SUB_CalcMoveDone = { // [FUNCTION]
	dprint("Calc move done!\n");
	if (self.classname == "fliquid") self.fmover = ""; // Update for moving liquids - from extras_r4/r5
	self.velocity = '0 0 0';
	setorigin(self, self.finaldest);
	self.nextthink = -1;
	if (self.think1) self.think1();
};

void() DelayThink = { // [FUNCTION]
	activator = self.enemy;
	SUB_UseTargets();
	remove(self);
};

// Checks if an entity has any target variables defined and returns TRUE if so.  Useful to know if a monster should not be removed before runing targets.
float(entity t) HasTargets = { // [FUNCTION]
	if (t.killtarget ||
		t.killtarget2 ||
		t.target ||
		t.target2 ||
		t.target3 ||
		t.target4) return TRUE;
	return FALSE;
};

// Clear all target strings
void(entity t) clear_trigstrs = { // [FUNCTION]
	t.killtarget = "";
	t.killtarget2 = "";
	t.target = "";
	t.target2 = "";
	t.target3 = "";
	t.target4 = "";
};

// sock: I really do hate this function because there is hardly any checks on it
// Qmaster: I overloaded remove() in where gyro overloaded it in gyro_main.qc
// to add all sorts of checks such as handling monster kill count, not removing
// player, not removing world, etc. so no worries here about removing
// attachments too.
void(string ktarg) SUB_KillTarget = { // [FUNCTION]
	local entity t;

	if (ktarg == "") return;

	t = find (world,targetname,ktarg);
	while(t) {
		// Try to minimize the entity chain damage, check for entity
		// attachments and delete them as well!
		SUB_ThinkImmediate(t,SUB_RemoveAttachments);
		if (t.entno_unique > 0) t.entno_unique = 0; // Reset unique ent number.
		remove(t); // Remove entity from chain list.  BOOM! She gone.
		t = find(t, targetname, ktarg); // Find the next victim to killtarget.
	}
};

void(string targname) SUB_Target = { // [FUNCTION]
	local entity t,act,stemp,otemp;

	if (targname == "") return;

	act = activator; // ID Code - Never switch around, not sure why it is here?
	t = find (world,targetname,targname);
	stemp = self;
	otemp = other; // Store self/other
	while(t) {
		if (t.use != SUB_Null) {
			if (t.use) {
				self = t; other = stemp; // Switch self/other
				self.activate = stemp; // used by the breakable system
				self.use(); // fire trigger
				self = stemp;
				other = otemp; // restore self/other
				activator = act; // ID code - Never changed, why restore it?
			}
		}
		t = find (t,targetname,targname); // Are there anymore targets left in the list?
	}
};

// Runs all targets for entity I/O.  The global "activator" should be set to the entity that initiated the firing.
// If self.delay is set, a DelayedUse entity will be created that will actually do the SUB_UseTargets after that many seconds have passed.  Centerprints any self.message to the activator.
// Removes all entities with a targetname that match self.killtarget, and removes them, so some events can remove other triggers.
// Search for (string)targetname in all entities that match (string)self.target and call their .use function
void() SUB_UseTargets = { // [FUNCTION]
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
		t.killtarget2 = self.killtarget2;
		t.target = self.target;
		t.target2 = self.target2;
		t.target3 = self.target3;
		t.target4 = self.target4;
		t.noise = self.noise;
		return;
	}
	
	// Check if previous delay has been disabled.  Unfortunately start off = OFF state and not easy to check for because some entities use that spawnflag bit for other things!
	if (self.classtype == CT_TRIGRELAYDELAY && (self.owner.estate & ESTATE_DISABLE)) return;

	Mass_Centerprint(self.message,self.noise,activator); // print any messages	
	if (self.killtarget != "") SUB_KillTarget(self.killtarget);
	if (self.killtarget2 != "") SUB_KillTarget(self.killtarget2);
	if (self.target != "") SUB_Target(self.target);
	if (self.target2 != "") SUB_Target(self.target2);
	if (self.target3 != "") SUB_Target(self.target3);
	if (self.target4 != "") SUB_Target(self.target4);
};

// Safe wrapper function to use instead of trigger_strs so all targets get ran and not just one
void(entity t) SUB_UseTargetsOnEnt = { // [FUNCTION]
	local entity stemp;
	
	if (!HasTargets(t)) return; // No targets to run
	stemp = self;
	self = t;
	SUB_UseTargets();
	self = stemp;
};

// Increases attack finished by specified value.  In nightmare mode, all attack_finished times become 0.
// Some monsters refire twice automatically (using .cnt variable).  Change nightmare to be less range spam and better time scaling.
void(float normal) SUB_AttackFinished = { // [FUNCTION]
	local float nightadj; // Easier to work out percentage

	if (self.slow_finished > time) normal = normal * 2;

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

// Used by soldiers and enforcers (special double fire mode)
void(void() thinkst) SUB_CheckRefire = { // [FUNCTION]
	if (skill != SKILL_NIGHTMARE) return;
	if (self.cnt == 1) return;
	if (!visible (self.enemy)) return;
	self.cnt = 1;
	self.think = thinkst;
};

void() play_teleport = { // [FUNCTION]
	self.lip = random() * 5;
	if (self.lip < 1) self.noise = "misc/r_tele1.wav";
	else if (self.lip < 2) self.noise = "misc/r_tele2.wav";
	else if (self.lip < 3) self.noise = "misc/r_tele3.wav";
	else if (self.lip < 4) self.noise = "misc/r_tele4.wav";
	else self.noise = "misc/r_tele5.wav";
	sound(self,CHAN_VOICE, self.noise,1,ATTN_NORM);
	self.nextthink = time + 2;	// Allow time for the sound to finish
	self.think = SUB_Remove;	// tidy up function
};

void(vector org) spawn_tfog = { // [FUNCTION]
	newmis = spawn();
	newmis.origin = org;
	newmis.nextthink = time + 0.2;
	newmis.think = play_teleport;
	Tent_Point(TE_TELEPORT,org);
};

void() spawn_tfog_self = { // [FUNCTION]
	spawn_tfog(self.origin);
};

void() tdeath_touch = { // [FUNCTION]
	if (other == self.owner) return; // Cannot telefrag yourself!?!
	if (ai_foundbreakable(self, other, FALSE)) return; // Check if found a breakable than cannot be broken
	
	// A boss cannot be telefragged (except shub).  Telefrag entity trying to telefrag boss instead!?!
	if (other.bossflag == TRUE) {
		if (other.classtype != CT_MONIDSHUB) {
			T_Damage(self.owner, other, other, MEGADEATH, NOARMOR); // Chaos cannot protect you from bosses!
			return;
		}
	}

	if (other.flags & FL_CLIENT) { // Frag anyone who teleports in on top of an invincible player
		if (other.invincible_finished > time || other.perms & POW_ARMORCHAOS) self.classname = "teledeath2";
		if ( !(self.owner.flags & FL_CLIENT) ) { // other monsters explode themselves
			T_Damage(self.owner, self, self, MEGADEATH, NOARMOR);
			return;
		}
	}

	// Sudden death incoming ...
	if (other.health) {
		if (other.perms & POW_ARMORCHAOS) {
			other.perms = other.perms - (other.perms & POW_ARMORCHAOS); // use it up
			other.health = 1;
			Client_CheckMaxHP(other,TRUE,FALSE); // Set to half health, the 2nd parameter does this normally for level transitions but we reuse it here
			T_Damage(self.owner, self, self, MEGADEATH, NOARMOR);
			return;
		}
		T_Damage(other, self, self, MEGADEATH, NOARMOR);
	}
};

void(vector org, entity death_owner) spawn_tdeath = { // [FUNCTION]
	local entity death;

	death = spawn();
	death.classname = "teledeath";
	death.owner = death_owner;
	death.movetype = MOVETYPE_NONE;
	death.solid = SOLID_TRIGGER;
	death.angles = '0 0 0';
	setsize (death, death_owner.mins - '1 1 1', death_owner.maxs + '1 1 1');
	setorigin(death, org);
	death.touch = tdeath_touch;
	death.nextthink = time + 0.2;
	death.think = SUB_Remove;
	force_retouch = 2; // !! This is extremely costly on the engine because it re-checks every trigger in the map to see if it is touching something.
};