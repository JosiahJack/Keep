
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
	//}
};

/*----------------------------------------------------------------------
square root
----------------------------------------------------------------------*/
float(float num) mathlib_sqrt =
{
	local float apr;

	//this sets a level of accuracy, it's a global float
	if(mathlib_accuracy <= 0) mathlib_accuracy = 0.001;   

	if (num < mathlib_accuracy) return 0;
	if (num>1) apr = num;
	else apr = 1;
	do {
		apr = (num + (apr * apr)) / (2 * apr);
	}
	while (fabs((apr * apr) - num) > (num * mathlib_accuracy));
	return apr;
};

void() func_train_resume =
{
	local float pc_dist;
	
	// Final destionation not setup correctly, move on
	if (self.goalentity.classname != "path_corner") self.estate_fire();
	
	pc_dist = fabs(vlen(self.finaldest - self.origin));
	if (pc_dist > 0) {
		// Play moving sound if active (sounds = 1 or 5)
		if ( self.sounds > 0) sound (self, CHAN_VOICE, self.noise1, self.volume, ATTN_NORM);
		// Setup sawblades to keep spinning
		if (self.classname != "trap_sawbladex" || self.classname == "trap_sawbladey") {
			if (self.movedir_x > 0 || self.movedir_y > 0 || self.movedir_z > 0)
				self.avelocity = -self.v_angle;
			else self.avelocity = self.v_angle;
		}
		// Double check distance is setup correctly
		if (self.distance < 1) self.distance = self.speed;
		if (!self.bsporigin) self.ltime = time;
		SUB_CalcMove (self.finaldest, self.distance, func_train_pause);
	}
	// Too close to final destination, just move on
	else self.estate_fire();
};