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
// Function count: 47
//
// Implements: AI Core Movement Subroutines
//
// Description:
// The various subroutines for monster movement and rotation.
//
// AI animation movement (used mostly in monsters QC file)
// - void(float dist) ai_forward
// - void(float dist) ai_back
// - void(float dist) ai_pain
// - void(float dist) ai_painforward
// - void() ai_turn
// - float() FacingIdeal
// - void() ai_face
// - void() ai_resetangles
// - void(float dist) ai_charge
// - void(float dist) ai_chargenoturn
// - void() ai_charge_side
// - void() ai_charge_front
//
// AI ATTACK states
// - void() ai_run_melee
// - void() ai_run_missile
// - void() ai_run_jump 
// - void(float dist) ai_run_slide
// - void(float dist) ai_run_sidestep
// - void(float dist) ai_run_backward
//
// AI interactions with Breakable System
// - float(entity source, entity targ, float ignorenoshoot) ai_foundbreakable
// - void(float brkdmg) ai_damagebreakable
// - void(float brkdmg) ai_jumpbreakable
//
// AI melee checks and damage
// - float(float attackdist) ai_checkmelee
// - void() ai_melee
// - void(float dmg_multiplier) ai_meleesmash
// - void() ai_melee_side
//=============================================================================

void() MonsterDeBuff;

void() ai_face = {
	//Commenting this out for the ballista.  Dangerous? if (self.health < 1) return;// Unusual check, caught elsewhere
	self.ideal_yaw = vectoyaw(SUB_orgEnemyTarget() - self.origin);
	ChangeYaw(); // Done in engine.
};

void(float dist) ai_forward = {
	MonsterDeBuff();
	walkmove(self.angles_y, dist);
};

// ai_forward + ai_face
void(float dist) ai_faceforward = {
	ai_face();
	ai_forward(dist);
};

void(float dist) ai_back = {
	MonsterDeBuff();
	walkmove((self.angles_y+180), dist);
};

void(float dist) ai_backface = { ai_face(); ai_back(dist); }; // faces then moves back.  Should be ai_faceback??

// ai_pain (just uses ai_back, at some point a randomized backwards stagger vector was planned, but I'm not going to change expected behavior -Qmaster)
void(float dist) ai_pain = { ai_back (dist); };

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
	ai_face();
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
	makevectors(self.angles); // aim to the left of the enemy for a flyby
	dtemp = self.enemy.origin - (30 * v_right);
	heading = vectoyaw(dtemp - self.origin);
	walkmove(heading, 20);
};

void() ai_charge_front = {
	local	float	heading;
	
	MonsterDeBuff();
	ai_face();			// Turn towards enemy first	
	makevectors(self.angles);
	heading = vectoyaw(self.enemy.origin - self.origin);
	walkmove(heading, 10);
};


// Turn and close until within an angle to launch a melee attack
void() ai_run_melee = {
	ai_face();
	if (FacingIdeal()) { // Facing towards the ENEMY target? (ideal_yaw)
		self.th_melee();
		self.attack_state = AS_STRAIGHT;
	}
};

// Turn in place until within an angle to launch a missile attack
void() ai_run_missile = {
	ai_face();
	if (FacingIdeal()) { // Facing towards the ENEMY target? (ideal_yaw)
		self.th_missile();
		self.attack_state = AS_STRAIGHT;
	}
};

// Turn in place until within an angle to jump attack
void() ai_run_jump = {
	ai_face();
	if (FacingIdeal()) { // Facing towards the ENEMY target? (ideal_yaw)
		self.th_jump();
		self.attack_state = AS_STRAIGHT;
	}
};

// Strafe sideways, but stay at aproximately the same range
void(float dist) ai_run_slide = {
	local float	ofs;

	MonsterDeBuff();
	ai_face();
	if (self.lefty > 0) ofs = 90;
	else ofs = -90;
	
	// Tests if monsters can strafe or not by moving the monster
	if (walkmove (self.ideal_yaw + ofs, dist)) return;
	
	self.lefty = rint(1 - self.lefty); // Switch strafe sides for later use
	if (walkmove (self.ideal_yaw - ofs, dist)) return;

	walkmove (self.ideal_yaw - 180, dist); // Try moving backwards if both sides are blocked
};

// Turn 90 degrees and move to the side
void(float dist) ai_run_sidestep = {
	local float	ofs;

	MonsterDeBuff();
	if (self.attack_sidestep < time) {
		self.attack_sidestep = time + 4 + random()*4;
		self.lefty = rint(1 - self.lefty);
	}
	if (self.lefty > 0) ofs = 85;
	else ofs = -85;

	// Work out angle to face for enemy and then turn +/- 90 degrees so that the monster is moving sideways to the enemy
	self.ideal_yaw = vectoyaw(SUB_orgEnemyTarget() - self.origin) + ofs; // `+ ofs` is Different than ai_face	
	ChangeYaw();
	
	// Tests if monsters can move sideways
	if (walkmove (self.ideal_yaw, dist)) return;
	// Switch strafe sides for later use
	self.attack_sidestep = -1;
};

// Turn 180 degrees and move backwards
void(float dist) ai_run_backward = {
	MonsterDeBuff();
	
	// Work out angle to face for enemy and then turn +/- 90 degrees so that the monster is moving sideways to the enemy
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin) + 180; // `+ 180` is Different than ai_face	
	ChangeYaw();
	
	if (walkmove (self.ideal_yaw, dist)) return; // Tests if monsters can move backwards
	
	self.attack_state = AS_SIDESTEP; // Cannot walk backwards, move sideways instead
};

// Check if the monster is allowed to break the breakable!?!
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

float BRKTRACE_DIST = 128;
float BRKTRACE_ANG = 0.35;

// Check if the monster (self) can see any breakables infront (target).  Triple trace infront (self.angles) origin, +upward and +downward
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
	
	return FALSE; // No breakable found
};

// Check if a breakable/pushable is immune to damage from monsters
float(entity source, entity targ) ai_immunebreakable = {
	if (targ.classtype == CT_FUNCBREAK || targ.classtype == CT_FUNCBREAKMDL) { // Found a breakable? (BSP or model)
		if (source.flags & FL_MONSTER && targ.spawnflags & BREAK_NOMONSTER) return TRUE; // Check no damage spawnflag
	} else if (targ.classtype == CT_FUNCPUSHABLE) { // Found a pushable?
		if (source.flags & FL_MONSTER && targ.spawnflags & PUSH_NOMONSTER) return TRUE; // Check no damage spawnflag
	}
	return FALSE;
};

// If any breakables found, damage them to see if they will break.  Use the triple trace forward, upward and dowward to find breakables
void(float brkdmg) ai_damagebreakable = {
	local float ldmg;
	
	ldmg = (random() + random() + random()) * brkdmg; // Setup damage modifier

	// Triple trace directly infront of monster using angles
	if (ai_tracebreakable(BRKTRACE_DIST, BRKTRACE_ANG)) {
		if (self.flags & FL_MONSTER && trace_ent.brkmondmg > 0) ldmg = ldmg * trace_ent.brkmondmg; // Check for any monster damage modifier on breakable
		T_Damage (trace_ent, self, self, ldmg, DAMARMOR); // Apply damage to breakable
	}
};

// Check if the monster can trigger a breakable from jump attack
// Expecting SELF = monster and OTHER = breakable
void(float brkdmg) ai_jumpbreakable = {
	if (ai_foundbreakable(self, other, TRUE) && other.brktrigjump != 0) {
		// Found a breakable which is prone to jump damage
		trigger_ent(other, self);
	}
	else ai_damagebreakable(brkdmg);	// Damage any breakables
};

// See if any breakables are in the way (running forward)
void() CheckBlockedBreakable = {
	local float brklen;

	if (time < self.attack_finished) return; // Still busy attacking? do nothing	

	if (self.th_melee && self.meleerange <= 0) self.meleerange = MONAI_MELEEKNIGHT; // Double check a DEFAULT melee range exist, use knights

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
			} else if (brklen < self.meleerange && self.th_melee) {
				SUB_AttackFinished (1+random());
				self.attack_state = AS_MELEE;
			} else if (self.th_missile) {
				SUB_AttackFinished (1+random());
				self.attack_state = AS_MISSILE;
			}
		}
	}
};


// Check if the monster (self) can attack enemy (target) and returns TRUE if the
// monster is within XYZ range.  Height is checked independently.
float(float attackdist, float attackzaxis) ai_checkmelee = {
	local vector spot1, spot2;
	local float delta, zdiff;

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

// Slashing type of damage facing forward, really assuming the monster is stationary while attacking
void() ai_melee = {
	local float ldmg;

	if (!self.enemy) return;			// removed before stroke
	ai_damagebreakable(10);				// Damage any breakables
	if (!ai_checkmelee(MONAI_MELEEFRONT,FALSE)) return;	// Too far away

	// Can the target bleed? - no blood/damage, quick exit
	// This candamage test not in origina id code (sync'd to melee_side)
	if (!CanDamage (self.enemy, self)) return;

	ldmg = (random() + random() + random()) * 3;
	T_Damage(self.enemy, self, self, ldmg, DAMARMOR);

	// Only spawn blood/gore/sound every second
	if (self.meleetimer < time) {
		self.meleetimer = time + 1;
		SpawnMeatSpray(self, self.enemy, random() * 100);
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

// Large smashing damage overhead attack, usually a single strike, really assuming the monster is stationary while attacking
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

void(vector imp_vec, float imp_damage, float imp_radius, float imp_forward, float imp_up) ai_shockwave = {
	local entity swave, sjump;
	local vector impact, fvel;
	local float vdist, vpercent, vdamage, vpart, impzdiff;
	
	// Big impact, flash effect
	self.effects = self.effects | EF_MUZZLEFLASH;

	// Play impact sound and work out where the impact is going to happen
	if (self.meleehitsound != "") sound(self, CHAN_WEAPON, self.meleehitsound, 1, ATTN_IDLE);
	makevectors(self.angles);
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
			// Check for equipped with blast belt? - play active sound
			if (sjump.flags & FLx_CREATURE && sjump.moditems & IT_ARTBLASTBELT) PlayBlastBeltSound(sjump);
			// Only affect players and other monsters AND breakables (BSP+model)
			else if (sjump.flags & FLx_CREATURE || sjump.classgroup == CG_BREAKABLE) {
				// Exclude breakable/pushable immune to monster damage
				// This does not catch breakables excluded from player damage
				if (ai_immunebreakable(self,sjump)) {
					dprint("[SHOCKWAVE] Breakable (");
					dprint(ftos(sjump.classtype));
					dprint(") spnflg ("); dprint(ftos(sjump.spawnflags));
					dprint(") Immune\n");
				}
				// Exclude statues, stone/heavy monsters and bosses!
				else if (sjump.classgroup != CG_STONE && sjump.bossflag == FALSE && sjump.mass < MASS_SUPER) {
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
							if (sjump.flags & FL_MONSTER) vpercent = vpercent * 0.75; // Monsters have less impact
							makevectors(self.angles); // Attacker facing angle								
							fvel = (v_forward * (imp_forward * vpercent)) + (v_up * (imp_up * vpercent)); // Combine forward/up force with existing velocity
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
	vpart = 64 + rint(random()*64); // Spawn particle explosion where impact is located
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
        } else walkmove(self.angles_y,0);    // Fails only in solid.

        dist = dist - 8;
    }
    self.enemy = swap;
    return (self.origin != spot);
};

float(float dist) ai_down = { return ai_up (0 - dist); };

// Custom strafing AI for Dragons!
// Move to the side of ideal_yaw.  Set ideal_yaw prior to a call to this function.  While similar to 'ai_run_slide', this function has two important differences.
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

// Move to the side of ideal_yaw.  Set ideal_yaw prior to a call to this function.  Called by 'ai_run_strafe'.
void(float dist) ai_run_side = {
    local   float   ofs;
    
    if (self.lefty) ofs = 90;
    else ofs = -90;

    if (walkmove (self.ideal_yaw + ofs, dist)) return;

    self.lefty = !self.lefty;
    walkmove (self.ideal_yaw - ofs, dist);
};


// Formerly ai_run_slide for Drake.  Strafe sideways, but stay at aproximately the same range
// PM:  Renamed to 'ai_run_strafe', and added float argument 'dist'.
//
// For guaranteed circle-strafing, do the following:
//  { ai_face(); ai_run_side(dist); ai_face();}
//
// The above description, which describes circle-strafing, is only true if enemy_yaw updates each frame, which is true only if this is called from
// ai_run.  If called directly, enemy_yaw probably will not be set, and the monster will simply move to the side.
void(float dist) ai_run_strafe = {
    self.ideal_yaw = enemy_yaw;
    ChangeYaw();
    ai_run_side (dist);
};

void(entity destEnt, float radius, vector offset) ai_orbit = {
   local vector dir;
   local float dist;

   if (self.orbitPosition > 3) self.orbitPosition = 0;
   else if (self.orbitPosition < 0) self.orbitPosition = 0;

   traceline(self.origin,(destEnt.origin + offset),TRUE,world);
   if (trace_fraction < 1) {
      setorigin(self,(destEnt.origin + offset));
      self.orbitPosition = (self.orbitPosition + TRUE);
      return;
   }

   if ( (self.orbitPosition == FALSE) ) {
      dir = ((destEnt.origin + offset) - self.origin);
      dir_x = (dir_x + radius);
   } else {
      if ( (self.orbitPosition == TRUE) ) {
         dir = ((destEnt.origin + offset) - self.origin);
         dir_y = (dir_y + radius);
      } else {
         if ( (self.orbitPosition == FL_SWIM) ) {
            dir = ((destEnt.origin + offset) - self.origin);
            dir_x = (dir_x - radius);
         } else {
            dir = ((destEnt.origin + offset) - self.origin);
            dir_y = (dir_y - radius);
         }
      }
   }
   dist = vlen (dir);
   if (dist < 8) self.orbitPosition = (self.orbitPosition + TRUE);
   else {
      if ( (dist < 50.000) ) {
         self.velocity = normalize (dir);
         self.velocity = (self.velocity * 150.000);
      } else {
         self.velocity = normalize (dir);
         self.velocity = (self.velocity * 500.000);
      }
   }
};

// From Quake 1.5 to move enemy towards destEnt
void(entity destEnt, float trackSpeed) ai_track = {
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
	makevectors(self.angles);
	if (self.meleetimer < time) { // Only spawn blood/gore/sound every second
		self.meleetimer = time + 1;
		SpawnBlood (self.enemy, self.origin + v_forward*50 + v_up*2, VEC_ORIGIN, 17,0);
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

void() ai_floatmove_start = {
	if (self.flags & (FL_FLY|FL_SWIM) == 0) return;
	
	self.velocity = '0 0 0';
	self.movetype = MOVETYPE_STEP;
	self.oldorigin = self.origin;
	self.flags = self.flags - (self.flags & FL_ONGROUND);
};

// Wrap movement code in this hot shtuff for making scrags do sick drifts
float(vector mask) ai_floatmove_ceiltrace = {
	local vector start, end;

	start = self.origin + vec_multiply_elementwise(self.maxs, mask);
	end = self.origin + vec_multiply_elementwise(VEC_HULL_MAX, mask);
	traceline(start, end, FALSE, self);
	if (trace_fraction < 1.0 || trace_startsolid || trace_allsolid) return FALSE;
	return TRUE;
};

float() ai_floatmove_ceilcheck = {
	if (!ai_floatmove_ceiltrace('0 0 1')) return FALSE;
	if (!ai_floatmove_ceiltrace('1 1 1')) return FALSE;
	if (!ai_floatmove_ceiltrace('-1 1 1')) return FALSE;
	if (!ai_floatmove_ceiltrace('1 -1 1')) return FALSE;
	if (!ai_floatmove_ceiltrace('-1 -1 1')) return FALSE;
	return TRUE;
};

float() ai_fishmovecheck = {
	local float opc;

	opc = pointcontents(self.oldorigin);

	// fish noclipping through ceilings
	if (pointcontents(self.origin) != opc || pointcontents(self.origin + '0 0 16') != opc || !ai_floatmove_ceilcheck()) return FALSE;
	return TRUE;
};

void(float dist) ai_floatmove_finish = {
	local float interv, spd, frac;
	local vector move;
	
	if (self.flags & (FL_FLY|FL_SWIM) == 0) return;
		
	self.movetype = MOVETYPE_FLY;
	move = self.origin - self.oldorigin;
	if (pointcontents(self.origin) == CONTENT_SOLID) { // fish have short bounding boxes, which in quake physics land means they can noclip through ceilings
		setorigin(self, self.oldorigin);
		self.velocity = '0 0 0';
		return;
	}

	if (vlen(move) > dist + 16) { self.velocity = '0 0 0'; return; } // probably touched a teleporter, so don't try to velocity interp
	
	interv = mathlib_max(0.01, self.nextthink - time);
	
	// flying/swimming monsters don't raise/lower for regular path walking normally, so fudge the z velocity manually
	if (self.goalentity.classtype == CT_PATHCORNER) {
		if (fabs(self.goalentity.origin_z - self.origin_z) > 16) {
			spd = vlen(move);
			frac = spd / vlen(self.goalentity.origin - self.origin);
			move_z = frac * (self.goalentity.origin_z - self.origin_z);
		}
	}
	// FL_SWIM just invalidates any movement out of water, so simulate velocity being clipped off at the surface instead.
	// TODO: support water volumes that end in other directions than up
	if ((self.flags & FL_SWIM) && !ai_fishmovecheck()) move_z = -1;
	setorigin(self, self.oldorigin);
	self.velocity = move / interv;
};

void(float dist) movetogoalplus = {
	ai_floatmove_start();
	movetogoal(dist);
	ai_floatmove_finish(dist);
};

float(float yaw, float dist) walkmoveplus = {
	local float result;
	local vector oldorg;

	ai_floatmove_start();
	oldorg = self.origin;
	result = walkmove(yaw, dist);
	if (oldorg == self.origin || !result) {
		ai_floatmove_finish(0);
		return FALSE;
	}
	ai_floatmove_finish(dist);
	return TRUE;
};

// For Kinn's Sergeant super grunt
float() ai_face_last = {
	if ( (visible(self.enemy)) || (self.enemy.origin == '0 0 0') ) {
		ai_face();
		return TRUE;
	}

	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	ChangeYaw();
	return FALSE;
};

// For the Ballista giant crossbow turret from Hexen 2
void() ai_attack_face =  {
    ai_face();
    if (FacingIdeal()) {
        if (self.attack_state == AS_MISSILE && self.th_missile) {
            self.th_missile();
        } else if (self.attack_state == AS_MELEE && self.th_melee) {
            self.th_melee();
        }
        self.attack_state = AS_STRAIGHT;
    }
};