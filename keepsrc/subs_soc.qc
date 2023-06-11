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
// Function count: 23
//
// Implements: Arcane Dimensions and global subroutines by sock
//
// Description:
// Utility functions for AD features and other useful global functions.
//=============================================================================

float(vector spot) InSolid;
float(vector spot) InSky;

// Make sure vector range is positive and integers only (Z exception)
vector(vector mrange) CheckRangeVector = {
	local vector retvec;
	retvec_x = rint(fabs(mrange_x));
	retvec_y = rint(fabs(mrange_y));
	retvec_z = rint(mrange_z);
	return retvec;
};

vector(entity targ) bbox_volume = {
	local vector retvec;
	retvec_x = fabs(targ.bbmins_x) + fabs(targ.bbmaxs_x);
	retvec_y = fabs(targ.bbmins_y) + fabs(targ.bbmaxs_y);
	retvec_z = fabs(targ.bbmins_z) + fabs(targ.bbmaxs_z);
	return retvec;
};

// Trigger/use all entities that match the supplied targetname
// self is switched around so target use function works correctly
void(string target_strs, entity activator_ent) trigger_strs = {
	local entity tself, tother, tactivator, ent_list;

	// Some entities constantly use this function (<0.1s trigger)
	// This is just an entity key to block the debug info
	if (activator_ent.nodebuginfo == FALSE) {
		dprint("\b[STR_TRIG]\b Str ("); dprint(target_strs);
		dprint(") Activator ("); dprint(activator_ent.classname);
		if (target_strs == "") dprint(") - ERROR!!\n");
		else dprint(")\n");
	}

	// Prevent this function from triggering everything by
	// checking if the target_str is empty (empty = world)
	if (target_strs != "") {
		// Store self/other for later
		tself = self;
		tother = other;
		tactivator = activator;
		if (activator_ent.flags & FL_CLIENT) activator = activator_ent;
	
		// Build initial list from world
		ent_list = find(world, targetname, target_strs);
		// Cycle through list
		while(ent_list) {
			// Setup self/other ready for trigger/use function
			self = ent_list;
			other = tself;
			if (self.use) {
				self.activate = activator_ent;		// Link activator
				self.use();							// Fire use function
			}
			// Find next trigger from intial list (not world)
			ent_list = find(ent_list, targetname, target_strs);
		}
		// Restore self/other from previous temp storage
		self = tself;
		other = tother;
		if (activator_ent.flags & FL_CLIENT) activator = tactivator;
	}
};

// Trigger/use the entity supplied and activator self is switched around so target use function works correctly
void(entity target_ent, entity activator_ent) trigger_ent = {
	local entity tself, tother, tactivator;

	dprint("\b[ENT_TRIG]\b Ent ("); dprint(ftos(target_ent.classtype));
	dprint(") Activator ("); dprint(activator_ent.classname);
	if (!target_ent) {dprint(") - ERROR!!\n"); return; }
	else dprint(")\n");

	if (!target_ent.use) return;

	// Save self/other for later
	tself = self;
	tother = other;
	tactivator = activator;
	if (activator_ent.flags & FL_CLIENT) activator = activator_ent;
	
	// Switch around self/other for USE function
	self = target_ent;
	other = tself;
	
	// Use trigger
	if (self.use) {
		self.activate = activator_ent;		// Link activator
		self.use();							// Fire use function
	}
		
	// Restore self/other from previous temp storage
	self = tself;
	other = tother;
	if (activator_ent.flags & FL_CLIENT) activator = tactivator;
};

// Check if the entity has solid surface below 
// There is no entity type checks, can be any entity in theory!
// First check is checkbottom for completel bounding box coverage
// Second check is trace down to find floor surface below
// Typical trace down distance is 128 units with 24 unit difference
//
// Uses for this function:-
// ai_states.qc - ai_stand
// monsters.qc  - monster_deadbody_check
// ai_gibs.qc   - CheckFloorGib
// items.qc     - item_thinkloop
void(entity source, float floor_dist) ent_floorcheck = {
	local vector trace_pos1;
	local float trace_dist;

	// Tracedown directly from origin for floor check
	trace_pos1 = source.origin;
	trace_pos1_z = trace_pos1_z - FLOOR_TRACE_DIST;
	traceline (source.origin, trace_pos1, TRUE, source);
	trace_dist = source.origin_z - trace_endpos_z; // Work out distance from origin to floor
	
	// Check if the floor is too far away? (usually 24 units)
	if (trace_dist > floor_dist && source.flags & FL_ONGROUND) {
		// Move entity up and do a trace/fall down (256 units max)
		source.oldorigin = source.origin;
		source.origin_z = source.origin_z + 1;
		droptofloor();
		if (source.oldorigin != source.origin) {
			// lift entity upward and remove onground flag
			source.flags = source.flags - (source.flags & FL_ONGROUND);
			source.velocity_z = 10 + 10*random();
			// Check for any attachment (lids) for ammo
			if (source.classgroup == CG_AMMOITEM && source.attachment) {
				// sync flag/velocity so lid falls correctly
				source.attachment.flags = source.attachment.flags - (source.attachment.flags & FL_ONGROUND);
				source.attachment.velocity = source.velocity;
			}
		}
		// Move item back to original pos before droptofloor
		setorigin(source, source.oldorigin);
	}
};

// Updates totals on the HUD (checks for client to exist)
// - Specify which total to update using constant
// - Uses MSG_ONE because it is more reliable across many clients
// - Other client updates (SVC_KILLEDMONSTER, SVC_FOUNDSECRET)
void(float hud_item) update_hud_totals = {
	// Has the client player been setup yet?
	if (client_ent && client_ent.flags & FL_CLIENT) {

		// Update total secrets
		if (hud_item & HUD_SECRETS) {
			msg_entity = client_ent;
			WriteByte (MSG_ONE, SVC_UPDATESTAT);
			WriteByte (MSG_ONE, STAT_TOTALSECRETS);
			WriteLong (MSG_ONE, total_secrets); 
		}
		// Update total monsters
		if (hud_item & HUD_MONSTERS) {
			msg_entity = client_ent;
			WriteByte (MSG_ONE, SVC_UPDATESTAT);
			WriteByte (MSG_ONE, STAT_TOTALMONSTERS);
			WriteLong (MSG_ONE, total_monsters); 
		}
	}
};

// Reduce any entity down to a non-interactive empty marker
void(entity targ) entity_stop = {
	if (targ == world) return;			// Targ is wrong
	if (targ.flags & FL_CLIENT) return;

	targ.use = targ.touch = SUB_Null;	// No more touchy
	targ.think = SUB_Null;				// No more thinking/animation
	targ.nextthink = -1;				// Never fire think
	targ.estate = ESTATE_OFF;			// Entity state off
	targ.takedamage = DAMAGE_NO;		// No pain/death triggers
	targ.height = 0;					// Model fade functionality
	targ.movetype = MOVETYPE_NONE;		// Stationary
	targ.solid = SOLID_NOT;				// no world interaction
	setsize (targ, VEC_ORIGIN, VEC_ORIGIN);		// No size, no impact
	targ.velocity = targ.avelocity = VEC_ORIGIN;// Frozen velocity
	targ.spawnflags = targ.effects = 0;			// reset flags
	targ.waitmin = time + LARGE_TIMER;			// Block touch function
	targ.attack_finished = time + LARGE_TIMER;	// Block all functions
};

// Reduce any entity down to a non-interactive empty marker
void(entity targ) entity_hide = {
	if (targ == world) return;			// Targ is wrong
	if (targ.flags & FL_CLIENT) return;

	entity_stop(targ);					// No world interaction.
	targ.modelindex = 0;				// Make sure no model.
	setmodel(targ, "");				    // Invisible.
};

void(entity targ, float removetime) entity_remove = {
	if (!targ) return;
	if (targ == world) return;
	if (targ.flags & FL_CLIENT) return;

	entity_hide(targ);
	SUB_Think(targ,SUB_Remove,removetime);
};

entity(vector spawn_org, string devmdl) spawn_devmarker = {
	if (devmdl == "") devmdl = "progs/q15/misc_broken.mdl";
	newmis = spawn();
	newmis.classtype = CT_DEVMARKER;
	newmis.movetype = MOVETYPE_NONE;
	newmis.solid = SOLID_NOT;
	setmodel(newmis,devmdl);
	setorigin(newmis,spawn_org);
	setsize(newmis,VEC_ORIGIN,VEC_ORIGIN);
	return newmis;
};

// Show where broken monster/items are located (developer only)
// SPNMARK_YELLOW, SPNMARK_BLUE, SPNMARK_GREEN, SPNMAKR_RED
void(vector marker_org, vector marker_ang, float type, float mskin) spawn_marker = {
	if (query_configflag(SVR_DEVHELPER)) return;
	if (developer <= 0) return;

	if (type) spawn_devmarker(marker_org,MODEL_CORNER1);
	else spawn_devmarker(marker_org,"progs/q15/misc_broken.mdl");

	newmis.angles = marker_ang;
	// Setup marker type (skin colour)
	// YELLOW = error, BLUE = delay, GREEN = nocount, RED = nightmare
	// YELLOW = 0, DARK GREEN = 1, GREEN = 2, WHITE = 3, RED = 4
	newmis.skin = mskin;
	newmis.frame = 0;
	if (type) newmis.alpha = 0.5 + random()*0.5;
	// If DP engine active remove particle shadow
	if (engine == ENG_DPEXT) newmis.effects = newmis.effects + EF_NOSHADOW;
};

// Check for SKILL spawning conditions (frame 0 check ONLY).  Returns FALSE = do nothing  TRUE = inhibit spawning
float() check_nightmare = {
	if (self.nightmare == TRUE) { // Check for nightmare skill only
		if (skill_cvar != TRUE) { skill = cvar("skill"); skill_cvar = TRUE; } // Double check the coop console variable, not setup till frame 1+.  Use a nosave variable to prevent constant cvar command checking.
		if (skill >= SKILL_NIGHTMARE) return FALSE;
		else {
			if (self.bsporigin) spawn_marker(bmodel_origin(self),'0 0 0',0,SPNMARK_RED); // Check for BSP entities has origin is different
			else spawn_marker(self.origin,'0 0 0',0,SPNMARK_RED);	
			entity_hide(self); // Hide instead of remove because of possible active touches.
			return TRUE;
		}
	}
	return FALSE;
};

// Check for COOP spawning conditions (frame 0 check ONLY).  Returns FALSE = do nothing  TRUE = inhibit spawning
float() check_coop = {
	if (self.cooponly == TRUE || self.cooponly == NEGATIVE) { // Check for coop only
		if (coop_cvar != TRUE) { coop = cvar("coop"); coop_cvar = TRUE; } // Double check the coop console variable, not setup till frame 1+.  Use a nosave variable to prevent constant cvar command checking.
		
		// Only one condition will let a cooponly item spawn
		// cooponly =  1 coop  = 0 inhibit = TRUE
		// cooponly =  1 coop >= 1 inhibit = FALSE
		// cooponly = -1 coop  = 0 inhibit = TRUE
		// cooponly = -1 coop >= 1 inhibit = TRUE
		if (self.cooponly == TRUE && coop > 0) return FALSE;
		else {
			if (self.bsporigin) spawn_marker(bmodel_origin(self),'0 0 0',0,SPNMARK_PURPLE); // Check for BSP entities has origin is different
			else spawn_marker(self.origin,'0 0 0',0,SPNMARK_PURPLE);
			entity_hide(self); // Hide entity instead of removing it because of possible active touch functions.
			return TRUE;
		}
	}
	return FALSE;
};

// Vector randomizer, used mostly for avelocity setups.  Used all over the place; monsters, weapons and gibs!
vector(float base, float rndmix, float plusminus) vecrand = { // [FUNCTION]
	local vector vecmix;
	if (plusminus) {
		vecmix_x = base + crandom() * rndmix; 
		vecmix_y = base + crandom() * rndmix; 
		vecmix_z = base + crandom() * rndmix; 
	} else {
		vecmix_x = base + random() * rndmix; 
		vecmix_y = base + random() * rndmix; 
		vecmix_z = base + random() * rndmix; 
	}
	return vecmix;
};

// Gradually fade out a model over time.  Optionally entity removal if height = 0
void() model_fade = { // [FUNCTION]
	if (coop > 2 && (self.classtype == CT_TEMPGIB || self.owner.classtype == CT_MISCGIBF)) {
		self.think = SUB_Null;
		return; // Keep gibs for versus mode :)
	}
    self.alpha = 1 - ((time - self.ltime) / 1);

    if (self.alpha > 1) self.alpha = 1;
    else if (self.alpha <= 0) {
        self.alpha = 0;
        self.model = "";
        // Remove model by default
        if (!self.height) {
			self.think = SUB_Remove;
			self.nextthink = time + 1;
 		}
        return;
    }

    self.nextthink = time + FADEMODEL_TIME;
};

// skill_chanceattack
// Calculate chance to attack player based on skill level and distance
// The standard ID range formula
// (enemy_range == RANGE_MELEE) chance = 0.9
// (enemy_range == RANGE_NEAR) chance = 0.4
// (enemy_range == RANGE_MID) chance = 0.05
// else chance = 0;
// The problem with this formula is that the chance factor is not gradual
// and will spike in chance when close to range boundaries
// Also this formula has no skill modifiers leading to limited gameplay rules

float() SUB_ChanceAttack = { // [FUNCTION]
	local float chrange, chskill, chance;
	
	chrange = chskill = 0; // taniwha patch
	
	// Upper and lower limits of range have fixed chance rates
	if (self.enemydist > MON_MAX_RANGE) chance =  0.05;
	else if (self.enemydist < MON_RANGE_MELEE) chance = 0.95;
	else {
		// Random chance of range attack based on player distance
		chrange = ((MON_MAX_RANGE - self.enemydist) / MON_STEPRANGE) / 10;
		
		// Skill modifier to chance (Easy -0.2 Norm -0.1, Hard 0, Night 0.1)
		chskill = ((skill-SKILL_HARD)*0.1);
		chance = chrange + chskill;
		
		// There Should always be a chance to HIT or MISS
		if (chance > 0.95) chance = 0.95;
		else if (chance < 0.05) chance = 0.05;
	}
	
	// Return result and finish debug information line
	if (random() < chance) return TRUE;
	else return FALSE;
};

// skill_subattack
// Calculate attack_finished time based on skill level
float (float min_time, float ranbase_time) SUB_SkillAttack = {
	local float ran_time, sub_time;
	
	// Easy = min + random(base + 1.5)    Normal = min + random(base + 1.0)
	// Hard = min + random(base + 0.5)    Nightm = min + random(base + 0.0)
	ran_time = ranbase_time + ((SKILL_NIGHTMARE - skill) * 0.5);
	sub_time = min_time + (ran_time * random());
	
	return sub_time;
};

// SUB_Tracking
// Progressively tracks the origin of enemies making attacks more accurate
// * Original code by Necros (http://shoresofnis.com/)
vector(vector iorg, vector org_offset, entity targ, float zspeed) SUB_Tracking = {
	local vector vec, org;
	local float diff;

	// Allow for source origin to be fine tuned (directional)
	makevectors(self.angles);
	org = self.origin + attack_vector(org_offset);

	diff = vlen(iorg - org) / zspeed;		// Workout difference
	vec = targ.velocity;
	if (targ.flags & FL_MONSTER) vec_z = 0;	// Flatten Z axis for monsters
	else vec_z = vec_z * 0.2;				// Aim for headshot with players

	iorg = targ.origin + diff * vec;		// Refine target origin
	return iorg;
};

// SUB_Elevation
// Calculates the Elevation for Z Aware monsters
// * Original code by Preach (https://tomeofpreach.wordpress.com/)
// * Added support for variable origin locations and proj speeds
// * Added support for distance scaling linked to skill levels
float(float theta, vector sorg, vector mdest, float zspeed) SUB_Elevation = {
	local float a, b, c; 	//constants in the equation to be solved
	local vector ofs; 		//displacement we wish the projectile to travel
	local float y, z; 		//horizontal and vertical components of ofs
	local float tan_theta; 	//trig values of the angle theta
	local vector vec, eorg;
	local float dist, sperc, oldtheta;
	
	if (world.copperoptions & COPPER_SEMI_Z_AWARE_OGRES) theta = 18;

	// Place projectile destination at player head level
	if (self.classtype == CT_MONSPIDER) mdest = mdest + ELEV_SPID_OFS;
	else mdest = mdest + ELEV_VIEW_OFS;

	// Work out vector distance between source and destination
	// Normalize the distance and create a percentage of that
	// This is a skill based calculation so the aiming gets better
	// The grenade is aimed infront of target so that it bounces
	// No check for vertical difference so it bad going up height!
	// Zombie, poison spiders zaware calculation is fine, exception!
	if (self.classgroup != CG_ZOMBIE && self.classtype != CT_MONSPIDER
		&& self.classtype != CT_MONBOGLORD) {
		vec = mdest - sorg;
		dist = vlen(vec);
		vec = normalize(vec);
		sperc = 0.45 + skill*0.15;
		eorg = sorg + (vec * (dist*sperc));
		ofs = eorg - sorg;
	} else ofs = mdest - sorg;
		
	//calculate how far we are firing
	z = ofs_z;
	ofs_z = 0;
	y = vlen(ofs);
 
	// Map gravity is a global variable defined in world.qc
	//find the coefficients of the quadratic in tan(theta)
	a = 0.5 * map_gravity * y * y / (zspeed * zspeed);
	b = -y;
	c = a + z;
	if (b*b < 4*a*c) {
		if (world.copperoptions & COPPER_SEMI_Z_AWARE_OGRES) return theta;
		else return ELEV_DEFAULT; //check if the destination is too far to reach
	}
	if (world.copperoptions & COPPER_SEMI_Z_AWARE_OGRES && self.flags & FL_MONSTER) {
		y = 0; // Reset loop counter
		// newton raphson to within 1 degree, no more than 4x
		while (fabs(oldtheta - theta) > 1 && y < 4) {
			oldtheta = theta;
			tan_theta = mathlib_tan(theta);
			theta = mathlib_atan2(a*tan_theta*tan_theta - c, 2*a*tan_theta + b);
			y += 1; // Increment loop counter until we hit 4
		}
	} else {
		tan_theta = mathlib_tan(theta); //calculate the tan value of the given theta
		theta = mathlib_atan2(a*tan_theta*tan_theta - c, 2*a*tan_theta + b); //reuse ang to create the improved firing direction
	}
	while(theta > 90) theta = theta - 180; //constrain the values to stop anything too mad happening
	return theta;
};