/*======================================================================
 Extra global functions
======================================================================*/
float FADEMODEL_TIME = 0.01;	// Small amount of time
void(entity inflictor, entity attacker, float damage) SUB_Null_pain = {};
void(vector spawn_org) spawn_marker;
void(entity targ) gen_unique_no = 
{
	// Check if target entity has an unique number already
	if (targ.entno_unique == 0) 
		targ.entno_unique = rint(random()*1000) * rint(random()*1000);
};


void(string target_strs, entity activator_ent) trigger_strs =
{
	local entity tself, tother, tactivator, ent_list;
	
	dprint("\b[STR_TRIG]\b Str ("); dprint(target_strs);
	dprint(") Activator ("); dprint(activator_ent.classname);
	if (target_strs == "") dprint(") - ERROR!!\n");
	else dprint(")\n");

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


float(vector check_vec) CheckZeroVector =
{
	if (check_vec_x == 0 && check_vec_y == 0 && check_vec_z == 0)
		return TRUE;
	else return FALSE;
};


//======================================================================
// Vector randomizer, used mostly for avelocity setups
// Used all over the place; monsters, weapons and gibs!
// 
//----------------------------------------------------------------------
vector(float base, float rndmix, float plusminus) vecrand =
{
	local vector vecmix;
	if (plusminus) {
		vecmix_x = base + crandom() * rndmix; 
		vecmix_y = base + crandom() * rndmix; 
		vecmix_z = base + crandom() * rndmix; 
	}
	else {
		vecmix_x = base + random() * rndmix; 
		vecmix_y = base + random() * rndmix; 
		vecmix_z = base + random() * rndmix; 
	}
	return vecmix;
};


void() model_fade =
{
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

vector(entity bmodel_ent) bmodel_origin =
{
	local vector vdiff, vorigin;

	// Calculate the middle point of the mins/maxs size vectors
	vdiff_x = (bmodel_ent.maxs_x - bmodel_ent.mins_x) / 2;
	vdiff_y = (bmodel_ent.maxs_y - bmodel_ent.mins_y) / 2;
	vdiff_z = (bmodel_ent.maxs_z - bmodel_ent.mins_z) / 2;

	// The mins vector is an absolute value of where the Bmodel is located
	// Add mins vector to middle point to get true origin
	// When bmodel do move they also update their origin co-ordinates
	// So any additional movement needs to be added as well
	// This means that bmodels can be tracked by movement functions
	vorigin = bmodel_ent.origin + bmodel_ent.mins + vdiff;
	
	// Return origin
	return vorigin;
};


//======================================================================
// Clear all trigger strings
//
//----------------------------------------------------------------------
void (entity targ) clear_trigstrs =
{
	if (targ.target != "") targ.target = string_null;
	//if (targ.target2 != "") targ.target2 = string_null;
	if (targ.killtarget != "") targ.killtarget = string_null;
};

//======================================================================
// Reduce any entity down to a non-interactive empty marker
//
//----------------------------------------------------------------------
void(entity targ) entity_hide =
{
	targ.use = targ.touch = SUB_Null;	// No more touchy
	targ.think = SUB_Null;				// No more thinking/animation
	targ.nextthink = -1;				// Never fire think
	targ.estate = ESTATE_OFF;			// Entity state off
	setmodel (targ, "");				// invisible
	targ.takedamage = DAMAGE_NO;		// No pain/death triggers
	targ.movetype = MOVETYPE_NONE;		// Stationary
	targ.solid = SOLID_NOT;				// no world interaction
	setsize (targ, VEC_ORIGIN, VEC_ORIGIN);		// No size, no impact
	targ.velocity = targ.avelocity = '0 0 0';	// Frozen velocity
	targ.spawnflags = targ.effects = 0;			// Leave flags alone
	targ.waitmin = time + LARGE_TIMER;	// Block any touch function
};

//----------------------------------------------------------------------
void(entity targ, float removetime) entity_remove =
{
	entity_hide(targ);
	targ.think = SUB_Remove;
	targ.nextthink = time + removetime;
};

//======================================================================
// Check for contact with sky brushes
// - Use pointcontent() for Typical/Enhanced Quake engines
// - Use new FTE string functions and surface check for Darkplaces engine
//
//----------------------------------------------------------------------
float(vector targ_origin) check_skycontent =
{
	local float surfnum;
	local string texturename;

	// Does the engine supports extended surface checks?
	if (ext_dpsurf) {
		surfnum = getsurfacenearpoint(world, targ_origin);
		if (surfnum >= 0) {
			texturename = getsurfacetexture(world, surfnum);
			if (strncasecmp(texturename, "SKY", 3) == 0) return TRUE;
		}
	}
	else {
		// Original method for checking sky content (Fitz engines)
		if (pointcontents(targ_origin) == CONTENT_SKY) return TRUE;
	}
	return FALSE;
};

//======================================================================
// Show where broken monster/items are located (developer only)
//
//----------------------------------------------------------------------
void(vector spawn_org) spawn_marker =
{
	local entity brokend;
	
	if (developer) {
		brokend = spawn();
		brokend.classtype = CT_DEVMARKER;
		brokend.movetype = MOVETYPE_NONE;
		brokend.solid = SOLID_NOT;
		setmodel(brokend, MODEL_BROKEN);
		setorigin(brokend, spawn_org);
		setsize (brokend, VEC_ORIGIN, VEC_ORIGIN);
		// If DP engine active remove particle shadow
		if (engine == ENG_DPEXT) brokend.effects = brokend.effects + EF_NOSHADOW;
	}
};

//======================================================================
// Trigger/use the entity supplied and activator
// self is switched around so target use function works correctly
//
//----------------------------------------------------------------------
void(entity target_ent, entity activator_ent) trigger_ent =
{
	local entity tself, tother, tactivator;

	dprint("\b[ENT_TRIG]\b Ent ("); dprint(ftos(target_ent.classtype));
	dprint(") Activator ("); dprint(activator_ent.classname);
	if (!target_ent) dprint(") - ERROR!!\n");
	else dprint(")\n");

	if (target_ent && target_ent.use) {
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
	}
};

/*======================================================================
 range_distance (target entity)
 	returns the vector distance between two points
======================================================================*/
float(entity targ, float flat2d) range_distance =
{
	local vector	spot1, spot2;
	local float		r;
		
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;
	if (flat2d) { spot1_z = spot2_z = 0; }
	r = vlen (spot1 - spot2);
	
	return r;
};


//----------------------------------------------------------------------
// Check point content for SOLID or SKY problems
//----------------------------------------------------------------------
float(vector pc_org) entity_pcontent =
{
	local float pcontent;
	pcontent = pointcontents(pc_org);
	if (pcontent == CONTENT_SOLID) return TRUE;
	if (check_skycontent(pc_org)) return TRUE;
	return FALSE;
}



//======================================================================
// Most of the monsters have an attack_offset setup to spawn their
// proejctiles in the right location relative to their gun model
// This function expects the makevectors has been done already
// makevectors (self.angles); <--- if missing, vector will be rubbish!
//----------------------------------------------------------------------
vector(vector attack_dir) attack_vector =
{
	local vector retvec;
	retvec = v_forward * attack_dir_x;
	retvec = retvec + (v_right * attack_dir_y);
	retvec = retvec + (v_up * attack_dir_z);
	return retvec;
};

void(vector org, float velrnd, float upbase, float uprnd) SpawnProjectileSmoke =
{
	newmis = spawn();
	newmis.classgroup = CG_TEMPENT;
	newmis.movetype = MOVETYPE_TOSS;
	newmis.solid = SOLID_NOT;
	setmodel(newmis, "progs/proj_smoke.mdl");
	setorigin(newmis, org);
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
	if (velrnd > 0) newmis.velocity = vecrand(0,velrnd,TRUE);
	else newmis.velocity = '0 0 0';
	newmis.velocity_z = upbase + random()*uprnd;
	newmis.nextthink = time + 1 + random()*3;
	newmis.think = SUB_Remove;
};


/*======================================================================
 walkmonster_start
  - Main entry point for ALL monster routines
======================================================================*/
void() walkmonster_start;

void() monster_start =
{
	self.flags = FL_MONSTER;			// Always reset this flag
	self.skin_override = self.skin;		// Save for later
	self.frame_override = self.frame;
	
	// Check for spawning conditions (nightmare, coop)
	//if (check_nightmare() == TRUE) return;
	//if (check_coop() == TRUE) return;
	
	// Warning if effects flag is active before spawning
	if (self.effects) {
		dprint("\b[MONSTER]\b Effects flag active\n");
		self.savedeffects = self.effects;
	}
	// Reset effects flag because some engines will show effects
	// This is especially obvious for delay spawned monsters
	self.effects = 0;

	self.oldorigin = self.origin;		// Save origin
	self.max_health = self.health;		// Save max health
	if (!self.gibhealth) self.gibhealth = 0 - self.health;	// Default gib health
	if (self.turrethealth < 0 || self.turrethealth > 1) self.turrethealth = 0.5;

	// Check if jump function has been disabled?
	if (self.jump_flag < 0) self.jump_flag = LARGE_TIMER;
	
	// Default attack function and class group
//	if (!self.th_checkattack) self.th_checkattack = CheckAttack;
	//if (!self.classgroup) self.classgroup = CG_MONSTERS;
	
	// Highlight monsters with forced no_zaware entity key
//	if (self.no_zaware && developer > 0 && !query_configflag(SVR_DEVHELPER)) 
		spawn_marker(self.origin+'0 0 32');

	// Setup bounding box based on presets
	//monster_bbox();
	// Cannot have multiple upgrade restrictions on monsters
	//remove_duplicate_upgrades();

	// Cannot delay spawn a monster if nothing can trigger it!?!
	if (self.spawnflags & MON_SPAWN_DELAY && self.targetname == "") {
		dprint("\b[MONSTER]\b Cannot delay spawn without targetname!\n");
		//spawn_marker(self.origin, SPNMARK_YELLOW);
		remove(self);
		return;
	}
	
	// Check for Axe / Shotgun upgrade monster exceptions?
	// Don't add these kind of monster to the count until spawned
	/*if (self.upgrade_axe || self.upgrade_ssg || self.upgrade_lg) {
		if ( !(self.spawnflags & MON_SPAWN_DELAY) ) {
			dprint("\b[MONSTER]\b need spawn delay for axe/shotgun/lg\n");
			spawn_marker(self.origin, SPNMARK_YELLOW);
			remove(self);
			return;
		}
		// make sure the monster has no nomonstercount exceptions
		if (self.nomonstercount) self.nomonstercount = 0;
	}
	else {*/
		// Allow mappers to spawn monsters that don't affect monster count
		// I know this can be a dangerous if used incorrectly, but good for statues
		if (!self.nomonstercount) total_monsters = total_monsters + 1;
		else {
			dprint("\b[MONSTER]\b ("); dprint(self.targetname);
			dprint(") - no monster count\n");
		}
	//}
	
	//----------------------------------------------------------------------
	// Detect monster armour map hack
	if (self.armorvalue || self.armortype) {
	// This hack really should be stopped, no point upsetting mappers at this point
	//		self.armorvalue = self.armortype = 0;
		dprint("\b[MAPHACKS]\b Using armor on monsters, use health key instead!\n");
	}

	/*if (self.spawnflags & MON_SPAWN_DELAY) {
		setmodel(self, string_null);
		self.solid = SOLID_NOT;				// No world interaction
		//self.use = monster_spawn;			// Wait for trigger
		
		if (developer > 0 && !query_configflag(SVR_DEVHELPER)) {
			self.movetype = MOVETYPE_NONE;
			self.solid = SOLID_NOT;
			setmodel(self, MODEL_BROKEN);
			if (self.nomonstercount == 1) self.skin = SPNMARK_GREEN;
			else self.skin = SPNMARK_BLUE;
			self.frame = 0;
		}
	}
	else {*/
		// Variable start delay on all monsters to reduce packet errors
		self.solid = SOLID_SLIDEBOX;				// Standard monster movement
	self.movetype = MOVETYPE_STEP;				// Standard monster movement
	setmodel(self, self.mdl);					// Setup model
	self.skin = self.skin_override;				// Restore any skins
	self.frame = self.frame_override;
	
	walkmonster_start();	
	//}
};
