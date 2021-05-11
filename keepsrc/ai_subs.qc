/* AI Routines
 
 AI animation movement (used mostly in monsters QC file)
 - void(float dist) ai_forward
 - void(float dist) ai_back
 - void(float dist) ai_pain
 - void(float dist) ai_painforward
 - void() ai_turn
 - float() FacingIdeal
 - void() ai_face
 - void() ai_resetangles
 - void(float dist) ai_charge
 - void(float dist) ai_chargenoturn
 - void() ai_charge_side
 - void() ai_charge_front
 
 AI ATTACK states
 - void() ai_run_melee
 - void() ai_run_missile
 - void() ai_run_jump 
 - void(float dist) ai_run_slide
 - void(float dist) ai_run_sidestep
 - void(float dist) ai_run_backward
 
 AI interactions with Breakable System
 - float(entity source, entity targ, float ignorenoshoot) ai_foundbreakable
 - void(float brkdmg) ai_damagebreakable
 - void(float brkdmg) ai_jumpbreakable
 
 AI melee checks and damage
 - float(float attackdist) ai_checkmelee
 - void() ai_melee
 - void(float dmg_multiplier) ai_meleesmash
 - void() ai_melee_side

======================================================================*/

void() MonsterDeBuff;

void() ai_face = {
	if (self.health < 1) return;// Unusual check, caught elsewhere
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	ChangeYaw (); 				// Done in code
};

void(float dist) ai_forward = {
	MonsterDeBuff();
	walkmove (self.angles_y, dist);
};

// ai_forward + ai_face
void(float dist) ai_faceforward = {
	ai_face();
	ai_forward(dist);
};

void(float dist) ai_back = {
	MonsterDeBuff();
	walkmove ( (self.angles_y+180), dist);
};

void(float dist) ai_backface = { ai_face(); ai_back(dist); }; // faces then moves back.  Should be ai_faceback??

// ai_pain (just uses ai_back, at some point a randomized backwards stagger vector was planned, but I'm not going to change expected behavior -Qmaster)
void(float dist) ai_pain ={ai_back (dist);};

void(float dist) ai_painforward = {
	MonsterDeBuff();
	walkmove (self.angles_y, dist); // Not sure why Id used ideal_yaw when other functions use angles_y, commonized
		  // meanwhile in Rubicon...// johnfitz changed so movement is based on current yaw, not ideal_yaw, to match animation   Lookie there, we're on the same page. -Qmaster
};

// ai_turn (Very costly function, re-using FindTarget again)
void() ai_turn = {
	if (FindTarget()) return;
	ChangeYaw();			// Code function
};

float() FacingIdeal = {
	local float delta;
	
	delta = anglemod(self.angles_y - self.ideal_yaw);
	if (delta > 45 && delta < 315) return FALSE;
	else return TRUE;
};

void() ai_trackenemy = {
	if (visible(self.enemy)) {
		self.attack_track = self.enemy.origin;
		ai_face();
	}
};

void() ai_resetangles = {
	self.angles_x = self.angles_z = 0; // There is a chance when finished a monster jump that some of the angles (X/Z) values are wrong and need resetting.  Should only be used after jump functions
};

// ai_charge (generic), The monster is in a melee attack, so get as close as possible to .enemy
void(float dist) ai_charge = {
	MonsterDeBuff();
	ai_face ();
	movetogoal (dist);
};

void(float dist) ai_chargenoturn = {
	MonsterDeBuff();
	movetogoal (dist);
};

void() ai_charge_side = {
	local	vector	dtemp;
	local	float	heading;
	
	MonsterDeBuff();
	ai_face();
	makevectors (self.angles); // aim to the left of the enemy for a flyby
	dtemp = self.enemy.origin - (30 * v_right);
	heading = vectoyaw(dtemp - self.origin);
	walkmove(heading, 20);
};

void() ai_charge_front = {
	local	float	heading;
	
	MonsterDeBuff();
	ai_face();			// Turn towards enemy first	
	makevectors (self.angles);
	heading = vectoyaw(self.enemy.origin - self.origin);
	walkmove(heading, 10);
};

/*======================================================================
 ai_run_melee
 - Turn and close until within an angle to launch a melee attack
======================================================================*/
void() ai_run_melee = {
	self.ideal_yaw = enemy_yaw;		// This is defined in ai_run
	ChangeYaw ();					// Code function

	//----------------------------------------------------------------------
	// Facing towards the ENEMY target? (ideal_yaw)
	//----------------------------------------------------------------------
	if (FacingIdeal()) {
		self.th_melee ();
		self.attack_state = AS_STRAIGHT;
	}
};

/*======================================================================
 ai_run_missile
 - Turn in place until within an angle to launch a missile attack
======================================================================*/
void() ai_run_missile = {
	self.ideal_yaw = enemy_yaw;		// This is defined in ai_run
	ChangeYaw ();					// Code function
	
	//----------------------------------------------------------------------
	// Facing towards the ENEMY target? (ideal_yaw)
	//----------------------------------------------------------------------
	if (FacingIdeal()) {
		self.th_missile ();
		self.attack_state = AS_STRAIGHT;
	}
};

/*======================================================================
 ai_run_jump
 - Turn in place until within an angle to jump attack
======================================================================*/
void() ai_run_jump = {
	self.ideal_yaw = enemy_yaw;		// This is defined in ai_run
	ChangeYaw ();					// Code function
	
	//----------------------------------------------------------------------
	// Facing towards the ENEMY target? (ideal_yaw)
	//----------------------------------------------------------------------
	if (FacingIdeal()) {
		self.th_jump ();
		self.attack_state = AS_STRAIGHT;
	}
};

/*======================================================================
 ai_run_slide
 - Strafe sideways, but stay at aproximately the same range
======================================================================*/
void(float dist) ai_run_slide = {
	local float	ofs;

	MonsterDeBuff();

	// It is better to re-calcuate this than wait for ai_run to update
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);	
	// self.ideal_yaw = enemy_yaw;		// This is defined in ai_run
	ChangeYaw ();						// Code function
	if (self.lefty > 0) ofs = 90;
	else ofs = -90;
	
	// Tests if monsters can strafe or not by moving the monster
	if (walkmove (self.ideal_yaw + ofs, dist)) return;
	
	// Switch strafe sides for later use	
	self.lefty = rint(1 - self.lefty);
	if (walkmove (self.ideal_yaw - ofs, dist)) return;
	
	// Try moving backwards if both sides are blocked
	walkmove (self.ideal_yaw - 180, dist);
};

/*======================================================================
 ai_run_sidestep
 - Turn 90 degrees and move to the side
======================================================================*/
void(float dist) ai_run_sidestep = {
	local float	ofs;

	MonsterDeBuff();

	if (self.attack_sidestep < time) {
		self.attack_sidestep = time + 4 + random()*4;
		self.lefty = rint(1 - self.lefty);
	}
	if (self.lefty > 0) ofs = 85;
	else ofs = -85;

	// Work out angle to face for enemy and then turn +/- 90 degrees
	// so that the monster is moving sideways to the enemy
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin) + ofs;	
	ChangeYaw ();
	
	// Tests if monsters can move sideways
	if (walkmove (self.ideal_yaw, dist)) return;
	// Switch strafe sides for later use
	self.attack_sidestep = -1;
};

/*======================================================================
 ai_run_backwards
 - Turn 180 degrees and move backwards
======================================================================*/
void(float dist) ai_run_backward = {
	MonsterDeBuff();

	// Work out angle to face for enemy and then turn +/- 90 degrees
	// so that the monster is moving sideways to the enemy
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin) + 180;	
	ChangeYaw ();
	
	// Tests if monsters can move backwards
	if (walkmove (self.ideal_yaw, dist)) return;
	// Cannot walk backwards, move sideways instead
	self.attack_state = AS_SIDESTEP;
};

/*======================================================================
 ai_foundbreakable
  Check if the monster is allowed to break the breakable!?!
======================================================================*/
float(entity source, entity targ, float ignorenoshoot) ai_foundbreakable = {
	// Found a breakable in the way?
	if (targ.classtype == CT_FUNCBREAK || targ.classtype == CT_FUNCBREAKMDL) {
		// Check if a monster and nomonster damage/trigger allowed?
		if (source.flags & FL_MONSTER && targ.spawnflags & BREAK_NOMONSTER) return FALSE;
		// Ignoring noshoot spawnflag? (designed for jump/missile events)
		else if (ignorenoshoot == TRUE) return TRUE;
		// is breakable explosive damage only and attacker can use explosives?
		else if (targ.brktrigmissile && source.attack_explosive) return TRUE;
		// Can the breakable be damaged?
		else if (targ.spawnflags & BREAK_NOSHOOT) return FALSE;
		// Its a breakable that breaks!
		else return TRUE;
	}
	return FALSE;
};

/*======================================================================
 ai_tracebreakable
  Check if the monster (self) can see any breakables infront (target)
  Triple trace infront (self.angles) origin, +upward and +downward
======================================================================*/
float BRKTRACE_DIST = 128;
float BRKTRACE_ANG = 0.35;

float(float tracedist, float traceang) ai_tracebreakable = {
	local vector spot1, spot2;
	local float mon_height;
	
	// Take current facing angle of monster
	makevectors(self.angles);
	spot1 = self.origin;

	// Work out look up/down height for additional tracelines
	mon_height = (self.maxs_z - self.mins_z) * traceang;
	
	// Trace directly infront of entity using angles
	spot2 = spot1 + (v_forward * tracedist);
	traceline (spot1, spot2, FALSE, self);
	if (ai_foundbreakable(self, trace_ent, FALSE)) return TRUE;

	// Trace from origin and look UP!
	spot2 = spot1 + (v_forward * tracedist) + (v_up * mon_height);
	traceline (spot1, spot2, FALSE, self);
	if (ai_foundbreakable(self, trace_ent, FALSE)) return TRUE;

	// Trace from origin and look DOWN!
	spot2 = spot1 + (v_forward * tracedist) - (v_up * mon_height);
	traceline (spot1, spot2, FALSE, self);
	if (ai_foundbreakable(self, trace_ent, FALSE)) return TRUE;

	// No breakable found
	return FALSE;
};

/*======================================================================
 ai_immunebreakable
  Check if a breakable/pushable is immune to damage from monsters
======================================================================*/
float(entity source, entity targ) ai_immunebreakable = {
	// Found a breakable? (BSP or model)
	if (targ.classtype == CT_FUNCBREAK || targ.classtype == CT_FUNCBREAKMDL) {
		// Check no damage spawnflag?
		if (source.flags & FL_MONSTER && targ.spawnflags & BREAK_NOMONSTER)
			return TRUE;
	}
	// Found a pushable?
	else if (targ.classtype == CT_FUNCPUSHABLE) {
		// Check no damage spawnflag?
		if (source.flags & FL_MONSTER && targ.spawnflags & PUSH_NOMONSTER)
			return TRUE;
	}
	return FALSE;
};

/*======================================================================
 ai_damagebreakable
  If any breakables found, damage them to see if they will break
  Use the triple trace forward, upward and dowward to find breakables
======================================================================*/
void(float brkdmg) ai_damagebreakable = {
	local float ldmg;
	
	// Setup damage modifier
	ldmg = (random() + random() + random()) * brkdmg;

	// Triple trace directly infront of monster using angles
	if (ai_tracebreakable(BRKTRACE_DIST, BRKTRACE_ANG)) {
		// Check for any monster damage modifier on breakable
		if (self.flags & FL_MONSTER && trace_ent.brkmondmg > 0)
			ldmg = ldmg * trace_ent.brkmondmg;
		// Apply damage to breakable
		T_Damage (trace_ent, self, self, ldmg, DAMARMOR);
	}
};

/*======================================================================
 ai_jumpbreakable
  Check if the monster can trigger a breakable from jump attack
  Expecting SELF = monster and OTHER = breakable
======================================================================*/
void(float brkdmg) ai_jumpbreakable = {
	if (ai_foundbreakable(self, other, TRUE) && other.brktrigjump != 0) {
		// Found a breakable which is prone to jump damage
		trigger_ent(other, self);
	}
	else ai_damagebreakable(brkdmg);	// Damage any breakables
};

/*======================================================================
 CheckBlockedBreakable
  See if any breakables are in the way (running forward)
======================================================================*/
void() CheckBlockedBreakable = {
	local float brklen;

	// Still busy attacking? do nothing	
	if (time < self.attack_finished) return;

	// Double check a DEFAULT melee range exist, use knights
	if (self.th_melee && !self.meleerange)
		self.meleerange = MONAI_MELEEKNIGHT;

	// Triple trace directly infront of monster using angles
	if (ai_tracebreakable(BRKTRACE_DIST, BRKTRACE_ANG)) {
		if (ai_foundbreakable(self, trace_ent, FALSE)) {
			// Find out exactly how far away breakable bounding box is
			brklen = fabs(vlen(self.origin - trace_endpos));
			
			// Check breakable within melee/missile range?
			// Added extra check for explosive damage on breakbles (1.8)
			if (self.attack_explosive && trace_ent.brktrigmissile) {
				SUB_AttackFinished (1+random());
				self.attack_state = AS_MISSILE;
			}
			else if (brklen < self.meleerange && self.th_melee) {
				SUB_AttackFinished (1+random());
				self.attack_state = AS_MELEE;
			}
			else if (self.th_missile) {
				SUB_AttackFinished (1+random());
				self.attack_state = AS_MISSILE;
			}
		}
	}
};

/*======================================================================
 ai_checkmelee
  Check if the monster (self) can attack enemy (target)
  and returns TRUE if the monster is within XYZ range
======================================================================*/
float(float attackdist, float attackzaxis) ai_checkmelee = {
	local vector	spot1, spot2;
	local float 	delta, zdiff;

	// Setup default
	if (attackzaxis <= 0) attackzaxis = MONAI_MELEEZAXIS;
	
	// Calculate distance and z axis difference seperate
	spot1 = SUB_orgEnemyTarget();
	spot2 = self.origin;
	zdiff = fabs(spot1_z - spot2_z);
	spot1_z = spot2_z = 0;				// Flatten Z axis before vector length
	delta = vlen(spot1 - spot2);		// Calculate vector distance

	// Is the enemy too far away and the zaxis is wrong (too low/high)
	if (delta <= attackdist && zdiff <= MONAI_MELEEZAXIS) return TRUE;
	else return FALSE;
};

/*======================================================================
 ai_melee (generic)
 - slashing type of damage facing forward
   really assuming the monster is stationary while attacking
======================================================================*/
void() ai_melee = {
	local float ldmg;

	if (!self.enemy) return;			// removed before stroke
	ai_damagebreakable(10);				// Damage any breakables
	if (!ai_checkmelee(MONAI_MELEEFRONT,FALSE)) return;	// Too far away

	// Can the target bleed? - no blood/damage, quick exit
	// This candamage test not in origina id code (sync'd to melee_side)
	if (!CanDamage (self.enemy, self)) return;

	ldmg = (random() + random() + random()) * 3;
	T_Damage (self.enemy, self, self, ldmg, DAMARMOR);

	// Only spawn blood/gore/sound every second
	if (self.meleetimer < time) {
		self.meleetimer = time + 1;
		SpawnMeatSpray (self, self.enemy, random() * 100);
	}

	// Check for poisonous blades!
	if (self.poisonous) PoisonDeBuff(self.enemy);
	
	// Some melee weapons have swing and hit as separate sounds
	// This is trigger_once per melee combat swing
	if (self.meleecontact) {
		self.meleecontact = FALSE;
		if (self.meleehitsound != "") sound (self, CHAN_WEAPON, self.meleehitsound, 1, ATTN_NORM);
	}
};

/*======================================================================
 ai_meleesmash (generic)
 - large smashing damage overhead attack, usually a single strike
   really assuming the monster is stationary while attacking
======================================================================*/
void(float dmg_multiplier) ai_meleesmash = {
	local float ldmg;

	if (!self.enemy) return;						// removed before stroke
	ai_damagebreakable(3*dmg_multiplier);			// Damage any breakables
	// Is the enemy too far away, ++ extra Z height
	if (!ai_checkmelee(self.meleerange,MONAI_MELEEZTALL)) return;	// Too far away

	// Can the target bleed? - no blood/damage, quick exit
	// This candamage test not in origina id code (sync'd to melee_side)
	if (!CanDamage (self.enemy, self)) return;

	// This function is designed for monsters attacking players or infighting
	// If this is infighting do more damage as it will look more impressive
	// Also if this damage is enough to kill in a single blow, gib for effect
	if (self.enemy.flags & FL_MONSTER) dmg_multiplier = dmg_multiplier * 2;

	// 1-9 damage
	ldmg = (random() + random() + random()) * dmg_multiplier;
	if (ldmg < 1) ldmg = 1;
	if (self.enemy.health < ldmg) ldmg = ldmg*3;
	T_Damage (self.enemy, self, self, ldmg, DAMARMOR);

	// Lots of blood and gore
	SpawnMeatSpray (self, self.enemy, crandom() * 100);
	SpawnMeatSpray (self, self.enemy, crandom() * 100);
	
	// Check for poisonous blades!
	if (self.poisonous) PoisonDeBuff(self.enemy);

	// Some melee weapons have swing and hit as separate sounds
	// This is trigger_once per melee combat swing
	if (self.meleecontact) {
		self.meleecontact = FALSE;
		if (self.meleehitsound) sound (self, CHAN_WEAPON, self.meleehitsound, 1, ATTN_NORM);
	}
};

/*======================================================================
 ai_melee_side (generic)
 - move forward/side and attack (can cause animation sliding errors)
   this is really designed for glancing blows and monsters which are
   moving fast like they are charging at the player
======================================================================*/
void() ai_melee_side = {
	local float ldmg;

	if (!self.enemy) return;	// removed before stroke
	ai_damagebreakable(10);		// Damage any breakables
	ai_charge_side();					// move (20 units) to the side of enemy
	if (!ai_checkmelee(MONAI_MELEESIDE,FALSE)) return;	// Too far away

	// Can the target bleed? - no blood/damage, quick exit
	if (!CanDamage (self.enemy, self)) return;

	ldmg = (random() + random() + random()) * 3;
	T_Damage (self.enemy, self, self, ldmg, DAMARMOR);
	SpawnMeatSpray (self, self.enemy, random() * 50);

	// Check for poisonous blades!
	if (self.poisonous) PoisonDeBuff(self.enemy);

	// Some melee weapons have swing and hit as separate sounds
	// This is trigger_once per melee combat swing
	// No check if meleehitsound is defined or not
	if (self.meleecontact) {
		self.meleecontact = FALSE;
		sound (self, CHAN_WEAPON, self.meleehitsound, 1, ATTN_NORM);
	}
};

/*======================================================================
 ai_shockwave
 - produce a large ground slam/shockwave effect
 - Used by hammer ogres, golems and barons
======================================================================*/
void() ai_shockwave_think = {
	self.wait = rint((time - self.ltime)*10);
	if (self.wait > 6) {
		SUB_Remove();
	} else {
		self.frame = self.wait;
		if (self.wait > 4) {
			if (!self.delay) self.delay = time;
			self.alpha = 1-((time - self.delay)*5);
		}
		self.angles_y = anglemod(self.angles_y + rint(random()*20));
		self.nextthink = time + TIME_MINTICK;
	}
};

//----------------------------------------------------------------------
void(vector imp_vec, float imp_damage, float imp_radius, float imp_forward, float imp_up) ai_shockwave = {
	local entity swave, sjump;
	local vector impact, fvel;
	local float vdist, vpercent, vdamage, vpart, impzdiff;
	
	// Big impact, flash effect
	self.effects = self.effects | EF_MUZZLEFLASH;

	// Play impact sound and work out where the impact is going to happen
	sound (self, CHAN_WEAPON, self.meleehitsound, 1, ATTN_IDLE);
	makevectors (self.angles);
	// Replaced this crazy mess with function attack_vector
	//impact = self.origin + v_forward*imp_vec_x + v_right*imp_vec_y + v_up*imp_vec_z;
	impact = self.origin + attack_vector(imp_vec);

	// Push all entities within a certain radius outwards
	// Do this find search before spawning ring and particles
	// findradius will find ALL entities regardless of type
	sjump = findradius(impact, imp_radius);
	while(sjump) {
		// Ignore monster (self)
		if (sjump != self) {
			// Check for player + blast belt? - play active sound
			if (sjump.flags & FL_CLIENT && sjump.moditems & IT_ARTBLASTBELT)
				PlayBlastBeltSound(sjump);
			// Only affect players and other monsters AND breakables (BSP+model)
			else if (sjump.flags & FL_CLIENT || sjump.flags & FL_MONSTER || sjump.classgroup == CG_BREAKABLE) {
				// Exclude breakable/pushable immune to monster damage
				// This does not catch breakables excluded from player damage
				if (ai_immunebreakable(self, sjump)) {
					dprint("[SHOCKWAVE] Breakable (");
					dprint(ftos(sjump.classtype));
					dprint(") spnflg ("); dprint(ftos(sjump.spawnflags));
					dprint(") Immune\n");
				}
				// Exclude statues, stone/heavy monsters and bosses!
				else if (sjump.classgroup != CG_STONE && sjump.bossflag == FALSE) {
					// Is the entity on the ground or a breakable?
					// The test for breakables exceptions is done earlier
					// Breakable bmodel/model don't have onground flag set
					// The onground test is really to catch player/monsters
					if (sjump.flags & FL_ONGROUND || sjump.classgroup == CG_BREAKABLE) {
						// Is the entity too far above or below the impact?
						impzdiff = fabs(sjump.origin_z - impact_z);
						if (impzdiff < MONAI_IMPACTZAXIS) {
							// Distance between impact and enemy/entity
							vdist = vlen(sjump.origin - impact);
							// Percentage of impact force
							vpercent = 1 - (vdist / imp_radius);
							vdamage = rint(imp_damage * vpercent);
							// Impact damage radius is half for breakables
							// Otherwise whole rooms would be destroyed!
							if (sjump.classgroup == CG_BREAKABLE) {
								if (vdist > (imp_radius * 0.5)) vdamage = 0;
							}
							// Only apply impact damage to players (not monsters)
							// The damage was previously a meleerange with +/- 48 zaxis
							// Been changed to a radius damage as its radius impact!
							// Percentage (distance) of the impact damaged specified
							// This will STILL not apply if blast belt or jumping :P
							// Breakable's need source (self) for impact direction
							// to spawn breakable pieces away from impact location
							if (vdamage > 0) {
								if (sjump.classgroup == CG_BREAKABLE)
									T_Damage (sjump, self, self, imp_damage*vpercent, DAMARMOR);
								else
									T_Damage (sjump, world, world, imp_damage*vpercent, DAMARMOR);
							}
							
							// Monsters have less impact
							if (sjump.flags & FL_MONSTER) vpercent = vpercent * 0.75;
							// Attacker facing angle
							makevectors(self.angles);									
							// Combine forward/up force with existing velocity
							fvel = (v_forward * (imp_forward * vpercent)) + (v_up * (imp_up * vpercent));
							sjump.velocity = sjump.velocity + fvel;
							sjump.flags = sjump.flags - (sjump.flags & FL_ONGROUND);
						}
					}
				}
			}
		}
		sjump = sjump.chain;
	}

	// Spawn impact model ring on the ground
	swave = spawn();
	swave.mdl = MODEL_PROJ_RINGSHOCK;	
	setmodel(swave,swave.mdl);
	setsize(swave, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(swave, impact);		// on floor, slight up (2 pixels)
	swave.solid = SOLID_NOT;		// No interaction with world
	swave.movetype = MOVETYPE_NONE;	// Static item, no movement
	swave.think = ai_shockwave_think;
	swave.nextthink = time + TIME_MINTICK;	// High time loop
	swave.ltime = swave.nextthink;
	
	// Spawn particle explosion where impact is located
	vpart = 64 + rint(random()*64);
	particle_explode(impact, vpart, 0.5, PARTICLE_BURST_FIRE, PARTICLE_BURST_SHOCKWAVE); 
};

// From Drake
// This is 'walkmove' without the vertical movement.
float(float yaw, float dist) flat_move = {
    local   entity  swap;

	MonsterDeBuff();
    swap = self.enemy;
    self.enemy = world;     // This prevents 'self' from going up/down.
    dist = walkmove (yaw, dist);    // After this, dist = TRUE or FALSE.
    self.enemy = swap;
    return dist;
};

// This is 'movetogoal' without the vertical movement.
void(float dist) flat_goal = {
    local   entity  swap;

	MonsterDeBuff();
    swap = self.enemy;
    self.enemy = world;     // This prevents 'self' from going up/down.
    movetogoal (dist);
    self.enemy = swap;
};

// Tells the monster to go straight up, if distance is positive.
// A negative distance will make the monster go down instead.
// Returns TRUE if fully or partially successful at moving.
//
// Originally from Dragons.
float(float dist) ai_up = {
    local entity  box, os, swap;
    local vector  spot;

    if (dist < 0) {
        dist = 0 - dist;    // 'fabs' it.
        temp_goal.origin_z = self.origin_z - 40 - dist;     // Going down.
    } else {
        temp_goal.origin_z = self.origin_z - 30 + dist;     // Going up.
	}

    setorigin (temp_goal, temp_goal.origin);
    spot = self.origin;
    swap = self.enemy;
    self.enemy = temp_goal;
    while (dist > 0) {
        if (dist < 8) { // walkmove moves self up or down 8 units at a time. Last run through loop.  Go through the trouble of moving less than 8 units.
            box = spawn(); // Create a dummy to move for the monster.  If the dummy can move, it is safe to set origin directly for monster.
            box.oldorigin   = self.origin;
            box.angles      = self.angles;
            box.solid       = self.solid;
            box.movetype    = self.movetype;
            box.flags       = self.flags & FLx_NOT_FALLING;
            box.enemy       = self.enemy;
            box.owner       = self;     // Pass through monster.
            setsize (box, self.mins, self.maxs);
            setorigin (box, self.origin);
            os = self;
            self = box;
            if (walkmove (self.angles_y, 0)) { // Dummy moved, now move the monster precisely.
                if (self.origin_z > self.oldorigin_z) { // Going up.
                    os.origin_z = os.origin_z + dist;
                    setorigin (os, os.origin);
                } else if (self.origin_z < self.oldorigin_z) { // Going down.
                    os.origin_z = os.origin_z - dist;
                    setorigin (os, os.origin);
                }
            }
            remove (box);
            self = os;
        } else {
            walkmove (self.angles_y, 0);    // Fails only in solid.
		}
        dist = dist - 8;
    }
    self.enemy = swap;
    return (self.origin != spot);
};

float(float dist) ai_down = {return ai_up (0 - dist);};

// Custom strafing AI for Dragons!
// Move to the side of ideal_yaw.  Assumes ideal_yaw was set prior to a call to this function.  While similar to 'ai_run_slide', this function has two important differences.
// * Only one move attempt is made.  If it fails, it does not get a second try to move to the other side.
// * If the move fails, the 'lefty' value is toggled only if 'self' was leaning toward the side it tried to move to.
// * This is used to help provide the illusion of a momentum change.
void(float dist) ai_run_bank = {
    local float ofs, flip;
    
    if (self.lefty) {
		ofs = 90;  flip = (self.angles_z < 0);
    } else {
		ofs = -90;  flip = (self.angles_z > 0);
	}

    if (!walkmove (self.ideal_yaw + ofs, dist)) { // Do this first to move!
        if (flip) self.lefty = !self.lefty;
	}
};

//=============
// ai_run_side
//
// Move to the side of ideal_yaw.  Assumes ideal_yaw was set prior to a
// call to this function.  Called by 'ai_run_strafe'.
//=============
void(float dist) ai_run_side = {
    local   float   ofs;
    
    if (self.lefty) ofs = 90;
    else ofs = -90;

    if (walkmove (self.ideal_yaw + ofs, dist)) return;

    self.lefty = !self.lefty;
    walkmove (self.ideal_yaw - ofs, dist);
};

//=============
// ai_run_strafe (formerly ai_run_slide)
//
// Strafe sideways, but stay at aproximately the same range
// PM:  Renamed to 'ai_run_strafe', and added float argument 'dist'.
//
// The above description, which describes circle-strafing, is only true if
// enemy_yaw updates each frame, which is true only if this is called from
// ai_run.  If called directly, enemy_yaw probably will not be set, and the
// monster will simply move to the side.
//
// For guaranteed circle-strafing, do the following:
//  {ai_face(); ai_run_side(dist); ai_face();}
//=============
void(float dist) ai_run_strafe = {
    self.ideal_yaw = enemy_yaw;
    ChangeYaw ();
    ai_run_side (dist);
};

// From Quake 1.5 to move enemy towards destEnt
void (entity destEnt, float trackSpeed) ai_track = {
   local vector dir;

   dir = (destEnt.origin + destEnt.view_ofs);
   dir = normalize ((dir - self.origin));
   self.velocity = (dir * trackSpeed);
};

void(float dist) ai_run;
void(float dist) ai_walk;

// Only used by Quoth Polyp
void(float dist) ai_walkfly = {
	local vector oldorg;
	local vector reqvel;
	local float d;
	
	oldorg = self.origin;
	self.movetype = MOVETYPE_STEP;
	ai_walk(dist);
	d = vlen(self.origin - oldorg);
	self.velocity = VEC_ORIGIN;
	if (d <= dist + 5) {
		self.movetype = MOVETYPE_FLY;
		reqvel = normalize(self.origin - oldorg) * dist * 7;
		setorigin(self, oldorg);
		self.velocity = reqvel;
	}
};

// Only used by Quoth Sentinel
void(float dist) ai_runfly = {
	local vector oldorg;
	local vector reqvel;
	local float d;
	
	oldorg = self.origin;
	self.movetype = MOVETYPE_STEP;
	ai_run(dist);
	d = vlen(self.origin - oldorg);
	self.velocity = VEC_ORIGIN;
	if (d <= dist + 5) {
		self.movetype = MOVETYPE_FLY;
		reqvel = normalize(self.origin - oldorg) * dist * 7;
		setorigin(self, oldorg);
		self.velocity = reqvel;
	}
};

void(float scratch_noise) ai_melee_carnivean = {
	local vector	delta;
	local float 	ldmg;

	if (!self.enemy) return;		// removed before stroke

	delta = self.enemy.origin - self.origin;
	if (vlen(delta) > 100) return;
		
	ldmg = (random() + random() + random()) * 4;
	T_Damage (self.enemy, self, self, ldmg, DAMARMOR);
	makevectors (self.angles);
	if (self.meleetimer < time) { // Only spawn blood/gore/sound every second
		self.meleetimer = time + 1;
		SpawnBlood (self.enemy, self.origin + v_forward*50 + v_up*2, VEC_ORIGIN, 17);
		SpawnMeatSpray(self, self.enemy, crandom () * 100);	// spawn a little gore
	}

	if (scratch_noise) sound (self, CHAN_AUTO, "demon/dhit2.wav", 0.5, ATTN_NORM);
};

void() ai_melee_torment = {
	local vector	delta;
	local float 	ldmg;

	if (!self.enemy) return;		// removed before stroke
		
	delta = self.enemy.origin - self.origin;
	if (vlen(delta) > 77) return;
		
	ldmg = (random() + random() + random()) * 4;
	T_Damage (self.enemy, self, self, ldmg, DAMARMOR);
};