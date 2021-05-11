//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: All mods that have monsters.
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
// Function count: 68
//
// Implements: Check routines for monsters to decide when and which attacks
//
// Description:
// Specific routines for certain monster types to determine if they can melee 
// or missile (range) attack.  Always working 1 frame behind the ai_run
// function. Moved all checkattack routines here (previously inside each
// monster file).
//=============================================================================

float() archer_check_shot;
void() baron_cast1;
void() baron_slam1;
float() BaronGolem_Check;
float(entity ent) Grounded;
float(vector org) UpIsSky;
float() eidolon_WaveCheck;
float() mammoth_WaveCheck;
float() mammoth_CheckTether;
void() dcrossbow_stop1;
void() dcrossbow_fire1;
void() dcrossbow_slide1;
void() deathguard_charge1;
float()	CheckFragJump;
void() gaunt_run1;
void() gaunt_side1;
void() inquisitor_magica1;
void() inquisitor_magicb1;
void() inquisitor_magicc1;
void() inquisitor_magicd1;

// Mammoth style phases
float MM_PHASE0 = 0;		// Phase 0 - Locked
float MM_PHASE1 = 1;		// Phase 1 - Lasers
float MM_PHASE2 = 2;		// Phase 2 - Rockets
float MM_PHASE3 = 3;		// Phase 3 - Lasers + Grenades
float MM_PHASE4 = 4;		// Phase 4 - Death

// Why on earth are there so many check attack functions???
void() CheckAttack = {
	if (visblocked(self.enemy)) return; // Does the monster have a clear shot to the player? sightline can be blocked by other monsters

	// Melee attack
	// enemy_range is checked before this function (ai_run - ai.qc)
	// If the monster is within melee range they instantly attack
	if (ai_checkmelee(MONAI_MELEEKNIGHT,FALSE) && self.th_melee) {
		self.attack_state = AS_MELEE;
		self.th_melee ();
		return;
	}

	// If setup to be a turret, check range attack only
	if (self.movespeed < 0 && self.th_missile) {
		if (time < self.attack_finished) return;
		SUB_AttackFinished (2 + random());
		self.attack_state = AS_MISSILE;
		return;
	}
	
	if (!self.th_missile) return;
	if (time < self.attack_finished) return;
	if (enemy_range == RANGE_FAR) return;

	// Range attack.  The attack chance percentages are constant across skill levels
	if (enemy_range == RANGE_MELEE) { // range < 120 map units
		self.attack_chance = 0.9;
		self.attack_finished = 0;
	} else if (enemy_range == RANGE_NEAR) { // range < 500 map units
		if (self.th_melee) self.attack_chance = 0.2;
		else self.attack_chance = 0.4;
	} else if (enemy_range == RANGE_MID) { // range < 1000 map units
		if (self.th_melee) self.attack_chance = 0.05;
		else self.attack_chance = 0.1;
	} else self.attack_chance = 0;

	if (random () < self.attack_chance) {
		SUB_AttackFinished (2*random());
		self.th_missile ();
	}
};

// Rocket version has melee
void() SoldierCheckAttack = {
	// If setup to be a turret, check range attack only
	if (self.movespeed < 0) {
		if (time < self.attack_finished) return;
		if (visblocked(self.enemy)) return;
		SUB_AttackFinished (2 + random());
		self.attack_state = AS_MISSILE;
		return;
	}

	// If enemy is within melee range, just keep on attacking!
	// Original ID behaviour is 10% chance to not attack in melee range
	// This has changed so that the soldier is more agressive up close
	// The army rocket has a special behaviour for melee range
	if (self.classtype != CT_MONARMYROCKET && enemy_range == RANGE_MELEE) {
		self.attack_state = AS_MISSILE;
		return;
	}
	
	// Does the monster have a clear shot to the player? sightline can be blocked by other monsters
	if (visblocked(self.enemy)) return;
	if (!visxray(self.enemy, self.attack_offset, '0 0 0', FALSE)) return;

	if (self.classtype == CT_MONARMYROCKET) {
		if (ai_checkmelee(MONAI_RANGEARMYR,FALSE)) {
			self.oldorigin = self.origin;
			// If move backward works, run back animation
			if (walkmove(self.angles_y+180, 16)) {
				setorigin(self, self.oldorigin);
				self.attack_state = AS_MELEE;
				self.th_melee ();
				return;
			} else setorigin(self, self.oldorigin);
		}
	}

	// Range attack (bullets)
	if (time < self.attack_finished) return;
	if (enemy_range == RANGE_FAR) return;	
	if (enemy_range == RANGE_MELEE) self.attack_chance = 0.9;		// range < 120 map units
	else if (enemy_range == RANGE_NEAR) self.attack_chance = 0.4;	// range < 500 map units
	else if (enemy_range == RANGE_MID) self.attack_chance = 0.05;	// range < 1000 map units
	else self.attack_chance = 0;
	if (random () < self.attack_chance) {
		self.attack_state = AS_MISSILE;
		if (self.classtype == CT_MONARMYROCKET) SUB_AttackFinished (2 + random());
		else SUB_AttackFinished (1 + random());
		if (random() < 0.3) self.lefty = !self.lefty;
	}
};

// Melee=FIRE!
void() PyroCheckAttack = {
	// Does the monster have a clear shot to the player? sightline can be blocked by other monsters
	if (visblocked(self.enemy)) return;

	if (ai_checkmelee(MONAI_RANGEPYRO,FALSE)) {
		self.attack_state = AS_MELEE;
		self.th_melee ();
		return;
	}
};

void() ShamCheckAttack = {
	// Melee attack(claws/overhead smash)
	if (ai_checkmelee(MONAI_MELEESHAM,MONAI_MELEEZTALL)) {
		self.attack_state = AS_MELEE;
		self.th_melee (); // Don't wait for next frame, melee attack straight away (different id behaviour)
		return;
	}

	// Range attack (lightning)
	if (!enemy_vis) return;
	if (time < self.attack_finished) return;
	if (self.enemydist > MONAI_SHAMRANGE && !self.attack_sniper) return;
	if (visblocked(self.enemy)) return; // Does the monster have a clear shot to the player? sightline can be blocked by other monsters

	SUB_AttackFinished (2 + (2*random()));
	self.attack_state = AS_MISSILE;							
};

void() BogLordCheckAttack = {
	// Special attack setup (more aggressive)
	if (self.attack_rage > 0) {
		// Can the monster attack and see the enemy?
		// There is no intelligent sight check, its just rage!
		if (time > self.attack_finished && enemy_vis) {
			if (self.attack_rage > random()) {
				self.attack_state = AS_MELEE;
				self.th_melee ();
			}
			else self.attack_state = AS_MISSILE;
			return;
		}
	}

	// Melee attack(overhead slime balls)
	if (ai_checkmelee(MONAI_BOGLORDMELEE,MONAI_MELEEZTALL)) {
		// Easy to dodge ball attack, bolts are more difficult
		if (self.spawnflags & MON_BOGL_STRONG)
			self.attack_chance = random();
		else {
			// Easy = 10%, Normal = 20%, Hard = 30%, NM = 40%
			self.attack_chance = 0.1 + (skill * 0.1);
		}
		if (random() < self.attack_chance) self.attack_state = AS_MISSILE;
		else { self.attack_state = AS_MELEE; self.th_melee (); }
		return;
	}

	// Range attack (Fast volley of bolts)
	if (!enemy_vis) return;
	if (time < self.attack_finished) return;

	// Does the monster have a clear shot to the player? sightline can be blocked by other monsters
	if (visblocked(self.enemy)) return;

	// Setup attack chance of using fast bolt attack more often
	// easy=0.0, norm=0.2, hard=0.4, nm=0.6
	// The stronger version is just pure random 50/50
	if (self.spawnflags & MON_BOGL_STRONG) self.attack_chance = random();
	else self.attack_chance = 0.0 + (skill * 0.2);
	
	// Give the monster a chance to move if not tethered
	if (!self.tethered) SUB_AttackFinished (1 + 2*random());
	
	// Check for random chance to keep doing overhead smash
	if (random() > self.attack_chance) {
		self.attack_state = AS_MELEE;
		self.th_melee ();
	} else self.attack_state = AS_MISSILE; // Range attack harder to dodge at higher projectile speed
};

void() SeekerCheckAttack = {
	// Melee punch
	if (ai_checkmelee(MONAI_MELRAGESEEKER,MONAI_MELEEZTALL)) {
		// Need both arms for melee animation
		if (self.state == 0) {
			self.attack_state = AS_MELEE;
			self.th_melee ();
		}
		// Instantly go to rocket range attack
		// If the player is too close
		else {
			self.attack_state = AS_MISSILE;
			SUB_AttackFinished (1 + random());
		}
		return;
	}

	// Range attack (rockets or lasers)
	if (!enemy_vis) return;
	if (time < self.attack_finished) return;

	// Does the monster have a clear shot to the player? sightline can be blocked by other monsters
	if (visblocked(self.enemy)) return;

	self.attack_state = AS_MISSILE;
	SUB_AttackFinished (2 + 2*random());
};

void() SantaCheckAttack = {
	// Melee attack
	if (ai_checkmelee(MONAI_MELEESANTA,FALSE)) {
		self.attack_state = AS_MELEE;
		return;
	}

	// If setup to be a turret, check range attack only
	if (self.movespeed < 0) {
		if (time < self.attack_finished) return;
		if (visblocked(self.enemy)) return;
		SUB_AttackFinished (1 + 2*random());
		self.attack_state = AS_MISSILE;
		return;
	}

	// Let sightsound play out before machine gun attack
	if (self.attack_rage) {
		self.attack_finished = time + 3;
		self.attack_rage = FALSE;
	}	

	// Range attack (snowball machine gun)
	if (!enemy_vis) return;
	if (time < self.attack_finished) return;
	
	// Does the monster have a clear shot to the player? sightline can be blocked by other monsters
	if (visblocked(self.enemy)) return;
	// Check if gun is being blocked (extra wide check)
	if ( visblocked_wide(self.enemy, self.attack_offset, '0 0 0') ) return;
	
	// Straight to snow machine gun!
	self.attack_state = AS_MISSILE;
	SUB_AttackFinished (2 + 2*random());
};

void() RaindeerCheckAttack = {
	// Melee attack (Antlers)
	if (ai_checkmelee(MONAI_MELEERAINDEER,FALSE)) {
		self.attack_state = AS_MELEE;
		return;
	}

	// If setup to be a turret, check range attack only
	if (self.movespeed < 0) {
		if (time < self.attack_finished) return;
		if (visblocked(self.enemy)) return;
		SUB_AttackFinished (1 + 2*random());
		self.attack_state = AS_MISSILE;
		return;
	}

	// Range attack (rockets)
	if (!enemy_vis) return;
	if (time < self.attack_finished) return;
	// Does the monster have a clear shot to the player? sightline can be blocked by other monsters
	if (visblocked(self.enemy)) return;

	self.attack_state = AS_MISSILE;
	SUB_AttackFinished (2 + 2*random());
};

void() SnowmanCheckAttack = {
	// Melee attack
	if (ai_checkmelee(MONAI_MELEESNOWMAN,FALSE)) {
		self.attack_state = AS_MELEE;
		self.attack_finished = 0; // As soon as out of melee, range attack!
		return;
	}

	// Range attack (rockets)
	if (!enemy_vis) return;
	if (time < self.attack_finished) return;
	// Does the monster have a clear shot to the player? sightline can be blocked by other monsters
	if (visblocked(self.enemy)) return;

	self.attack_state = AS_MISSILE;
	SUB_AttackFinished (2 + 2*random());
};

void() GolemCheckAttack = {
	// Melee attack(Punch/Pound)
	if (!enemy_vis) return;
	if (self.enemydist < MONAI_MELEEGOLEM) {
		self.attack_state = AS_MELEE;
		return;
	}

	// Floor stomp attack
	if (self.enemydist < MONAI_GOLEMRANGE && random() < 0.3) {
		SUB_AttackFinished (1 + 2*random());
		self.th_slide ();
		return;
	}	

	// Range attack (Rock Attack)
	if (time < self.attack_finished) return;
	if (!self.th_missile) return;
	
	// Does the monster have a clear shot to the player? sightline can be blocked by other monsters
	if (!visblocked_wide(self.enemy, self.attack_offset, '0 0 24')) {
		self.attack_state = AS_MISSILE;
		SUB_AttackFinished (2 + 2*random());
	}
};

void() ShalCheckAttack = {
	// If setup to be a turret, check range attack only
	if (self.movespeed < 0) {
		if (time < self.attack_finished) return;
		// Slower spawnrate for minion eggs than voreballs
		if (!(self.spawnflags & MON_SHALRATH_MINIONS)) {
			if (visblocked(self.enemy)) return;
			SUB_AttackFinished (2*random());
		} else SUB_AttackFinished (1 + 2*random());
		self.attack_state = AS_MISSILE;
		return;
	}
	// Minion spawning shalraths should maintain distance, use the new turn and side walk function to stay mid range
	if (self.spawnflags & MON_SHALRATH_MINIONS && self.enemy.flags & FL_CLIENT) {
		// Calculate a flat vector to ignore Z axis difference
		self.enemydist = range_distance(self.enemy, TRUE);
		// If too far away from enemy, move in a straight line
		if (self.enemydist > MONAI_RANGESHAL) {
			self.attack_state = AS_STRAIGHT;
		} else {
			// If range attack still blocked, move sideway/backwards
			if (time < self.attack_finished) {
				// If too close, move backwards and sideways so that there is plenty of room to spawn more minions
				if (self.enemydist < MONAI_RANGESHAL2) self.attack_state = AS_BACKWARD;
				else self.attack_state = AS_SIDESTEP;
				// straight away move
				return;
			}
		}
	}

	// Does the monster have a clear shot to the enemy? sightline can be blocked by other monsters
	if (visblocked(self.enemy)) return;
		
	// Range attack
	// The attack chance percentages are constant across skill levels
	if (enemy_range == RANGE_FAR) return;
	if (time < self.attack_finished) return;

	// random chance based on distance to enemy
	if (enemy_range == RANGE_MELEE) {
		self.attack_chance = 0.9;	// < 120
		self.attack_finished = 0;	// If enemy really close, constantly fire!
	} else if (enemy_range == RANGE_NEAR) self.attack_chance = 0.4;	// < 500
	else if (enemy_range == RANGE_MID) self.attack_chance = 0.1;	// < 1000
	else self.attack_chance = 0;

	// Random chance of range attack?
	if (random () < self.attack_chance) {
		// Slower spawnrate for minion eggs than voreballs
		if (self.spawnflags & MON_SHALRATH_MINIONS) SUB_AttackFinished (1 + 2*random());
		else SUB_AttackFinished (2*random());
		self.attack_state = AS_MISSILE;
	}
};

void() EliminatorCheckAttack = {
	// Range attack (Plasma)
	if (!enemy_vis) return;
	if (time < self.attack_finished) return;
	// This is a range check for firing plasma bolts, easily works with massive range and attack_sniper
	if (enemy_range == RANGE_FAR && !self.attack_sniper) return;														 
	// Does the monster have a clear shot to the player? sightline can be blocked by other monsters
	if (visblocked(self.enemy)) return;

	// Aggressive range attack, no % chances
	self.attack_state = AS_MISSILE;
	SUB_AttackFinished (1 + 2*random());
};

// Range=Plasma/Rockets
void() MegaforceCheckAttack = {
	// Check for visibility
	if (!enemy_vis) return;

	// Close attack (Plasma)
	// Do a sight test from gun position to enemy (more accurate)
	if (ai_checkmelee(MONAI_RANGEMEGAF,FALSE) && 
		visxray(self.enemy, self.attack_offset, '0 0 0', FALSE)) {
		self.attack_state = AS_MELEE;
		self.th_melee ();
		return;
	}

	// Range attack (Rockets)
	if (time < self.attack_finished) return;
	// Does the monster have a clear shot to the player? sightline can be blocked by other monsters
	if (visblocked(self.enemy)) return;
	// This is a range check for firing rockets
	if (enemy_range == RANGE_FAR && !self.attack_sniper) return;

	// Aggressive range attack, no % chances
	self.attack_state = AS_MISSILE;
	SUB_AttackFinished (2 + 2*random());
};

// Melee=Flames/Plasma, Range=Rockets
void() DeflectorCheckAttack = {
	// Check for visibility
	if (!enemy_vis) return;

	// Plasma and Flame attacks are close combat attacks only
	// Enemy really needs to be infront as they front cone attacks
	if (ai_checkmelee(MONAI_RANGEDEFLECT,FALSE) && infront(self.enemy) ) {
		// Forced pause between attacks
		if (self.attack_timer < time) {
			// Rapid firing plasma projectiles
			if (self.spawnflags & MON_DEFLECTOR_PLASMA) {
				self.attack_state = AS_MELEE;
				self.th_melee ();
				return;
			} else {
				// Flame Count = Base (X) * (Skill * Y) Maximum = Z
				self.attack_count = SpriteCount_Flame(self.proj_attqty);
				// Any sprite space left for hazard projectiles?
				if (HazardProjectile_CheckLimit(self, self.attack_count)) {
					self.attack_state = AS_MELEE;
					self.th_melee ();
					return;
				}
			}
		}
	}
	
	// Range attack (Rockets)
	if (time < self.attack_finished) return;
	// Does the monster have a clear shot to the player?
	// sightline can be blocked by other monsters
	if (visblocked(self.enemy)) return;
	// This is a range check for firing rockets
	if (enemy_range == RANGE_FAR && !self.attack_sniper) return;

	// Aggressive range attack, no % chances
	self.attack_state = AS_MISSILE;
	SUB_AttackFinished (2 + 2*random());
};

// Melee=SSG / Range=GL
void() DefenderCheckAttack = {
	// Melee attack (Super Shotgun to face)
	if (ai_checkmelee(MONAI_RANGEDEFSSG,FALSE)) {
		self.attack_state = AS_MELEE;
		self.th_melee ();
		return;
	}

	// Range attack (Grenades)
	if (!enemy_vis) return;
	if (time < self.attack_finished) return;
	// This is a range check for firing grenades
	// It needs to be less than 600 units, otherwise likely to miss
	// No point having attack_sniper versions firing early
	if (enemy_range == RANGE_FAR) return;
	// Does the monster have a clear shot to the player? sightline can be blocked by other monsters
	if (visblocked(self.enemy)) return;
	
	// Check enemy for grenade resistance?
	if (self.enemy.bouncegrenade) {
		self.attack_state = AS_MELEE;
		self.th_melee ();
	} else {
		// Aggressive range attack, no % chances
		self.attack_state = AS_MISSILE;
		SUB_AttackFinished (1 + 2*random());
	}
};

void() FloydCheckAttack = {
	// Range attack (Plasma)
	if (!enemy_vis) return;
	if (time < self.attack_finished) return;
	// This is a range check for firing plasma bolts
	// Could easily work with massive range and attack_sniper
	if (enemy_range == RANGE_FAR && !self.attack_sniper) return;
	// Does the monster have a clear shot to the player? sightline can be blocked by other monsters
	if (visblocked(self.enemy)) return;

	// Aggressive range attack, no % chances
	self.attack_state = AS_MISSILE;
	SUB_AttackFinished (1 + 2*random());
};

// Vanilla, Hunter, Fishing and Mace versions
void() OgreCheckAttack = {
	// Melee attack (chainsaw)
	if (self.enemydist < self.meleerange) {
		self.attack_state = AS_MELEE;
		return;
	}

	// If setup to be a turret, check range attack only
	if (self.movespeed < 0) {
		if (time < self.attack_finished) return;
		if (visblocked(self.enemy)) return;
		SUB_AttackFinished (1 + 2*random());
		self.attack_state = AS_MISSILE;
		return;
	}

	// Range attack (grenades), strangely enough the chance attack percentages are not used
	if (!enemy_vis) return;
	if (time < self.attack_finished) return;
	// Does the monster have a clear shot to the player? sightline can be blocked by other monsters
	if (visblocked(self.enemy)) return;

	// Check enemy for grenade resistance?
	// Move closer to enemy instead for melee range
	if (!self.enemy.bouncegrenade) {
		self.attack_state = AS_MISSILE;
		// Fishing ogre fires much faster than standard
		if (self.classtype == CT_MONOGREFISH) SUB_AttackFinished (1 + random());
		else SUB_AttackFinished (1 + 2*random());
	}
};

// Hammer only, much faster)
void() OgreHamCheckAttack = {
	// Melee attack (Special hammer attack)
	if (self.spawnflags & MON_HOGRE_METAL) {
		if (self.enemydist < MONAI_MELEEOGREHAM) {
			self.attack_state = AS_MELEE;
			return;
		}
	} else {
		// Default melee attack, just a simple hammer
		if (self.enemydist < self.meleerange) {
			self.attack_state = AS_MELEE;
			return;
		}
	}

	// If setup to be a turret, check range attack only
	if (self.movespeed < 0) {
		if (time < self.attack_finished) return;
		if (visblocked(self.enemy)) return;
		SUB_AttackFinished (1 + 2*random());
		self.attack_state = AS_MISSILE;
		return;
	}

	// Range attack (grenades), strangely enough the chance attack percentages are not used
	if (!enemy_vis) return;
	if (time < self.attack_finished) return;
	// Does the monster have a clear shot to the player? sightline can be blocked by other monsters
	if (visblocked(self.enemy)) return;

	self.attack_state = AS_MISSILE;
	SUB_AttackFinished (1 + random());
};

void() FreddieCheckAttack = {
	// Melee attack (chainsaw)
	if (ai_checkmelee(MONAI_MELEEFREDDIE,MONAI_MELEEZTALL)) {
		// Hard/Nightmare skill have chance to ignore melee attacks
		if (skill < SKILL_HARD || (skill > SKILL_NORMAL && random() < 0.7)) {
			self.attack_state = AS_MELEE;
			return;
		}
	}

	// If setup to be a turret, check range attack only
	if (self.movespeed < 0) {
		if (time < self.attack_finished) return;
		if (visblocked(self.enemy)) return;
		SUB_AttackFinished (1 + 2*random());
		self.attack_state = AS_MISSILE;
		return;
	}

	// Range attack (spikes/laser)
	if (!enemy_vis) return;
	if (time < self.attack_finished) return;
	// Does the monster have a clear shot to the player? sightline can be blocked by other monsters
	if (visblocked(self.enemy)) return;

	// If Freddie too far away for stationary attack?
	if (self.enemydist > MONAI_RANGEFREDDIE && skill > SKILL_EASY) {
		// Work out vector angle of enemy infront
		makevectors (self.angles);
		self.pos1 = normalize (self.enemy.origin - self.origin);
		self.lip = self.pos1 * v_forward;
		// Is the enemy infront of freddie?
		if (self.lip > 0.8) {
			self.cnt = 0;
			self.attack_timer = TRUE;
			SUB_AttackFinished (1 + random());
		} else {
			// Small random chance of stop+fire
			if (random() < 0.2) {
				self.attack_timer = FALSE;
				self.attack_state = AS_MISSILE;
				SUB_AttackFinished (1 + 2*random());
			}
		}
	} else {
		// Close to enemy, stop+fire
		self.attack_timer = FALSE;
		self.attack_state = AS_MISSILE;
		SUB_AttackFinished (1 + 2*random());
	}
};

// No melee attack
void() WizardCheckAttack = {
	// Unique stuff for wizard above version
	if (self.spawnflags & MON_WIZARD_ABOVE) {
		// Cannot see enemy? stop chasing enemytarget
		if (!enemy_vis) {
			SUB_switchEnemyTarget();
			return;
		}
		// setup enemytarget if one is not active
		if (self.enemy.classtype != CT_ENEMYTARGET && self.height > 0) {
			if (SUB_setupEnemyTarget(self.enemy, self.height, MONAI_ABOVETIMER)) {
				self.enemy = self.enemytarget;
			}
		}
	}	

	// Do nothing if cannot see enemy or waiting for attack timer
	if (!enemy_vis) return;
	if (time < self.attack_finished) return;

	// If setup to be a turret, check range attack only
	if (self.movespeed < 0) {
		if (visblocked(self.enemy)) return;
		self.attack_state = AS_MISSILE;
		return;
	}

	// Range attack (spit)
	// Does the monster have a clear shot to the player? sightline can be blocked by other monsters
	// The original id behaviour is wizards run until within range
	if (enemy_range == RANGE_FAR || visblocked(SUB_entEnemyTarget()) ) {
		if (self.attack_state != AS_STRAIGHT) 
			self.attack_state = AS_STRAIGHT;
		return;
	}

	if (enemy_range == RANGE_MELEE) self.attack_chance = 0.9;		// range < 120 map units
	else if (enemy_range == RANGE_NEAR) self.attack_chance = 0.6;	// range < 500 map units
	else if (enemy_range == RANGE_MID) self.attack_chance = 0.2;	// range < 1000 map units
	else self.attack_chance = 0;
	if (random () < self.attack_chance) {
		self.attack_state = AS_MISSILE;
	} else if (enemy_range == RANGE_MID) { 
		if (self.attack_state != AS_STRAIGHT) self.attack_state = AS_STRAIGHT; // keep moving forward to enemy target
	} else {
		if (self.attack_state != AS_SLIDING) {
			self.attack_state = AS_SLIDING;
			self.th_slide ();
		}
	}
};

// No melee attack
void() SkullWizCheckAttack = {
	// Teleport away if player too close
	if (self.enemydist < MONAI_MELEESKULLW && !self.bodystatic) {
		self.attack_state = AS_MELEE;
		return;
	} else self.attack_state = AS_TURRET; // make sure enemy is stationary (turret)

	// Range / missile attack (skull attack)
	if (!enemy_vis) return;
	if (time < self.attack_finished) return;
	// Does the monster have a clear shot to the player? sightline can be blocked by other monsters
	if (visblocked(self.enemy)) return;

	self.attack_state = AS_MISSILE;
	SUB_AttackFinished (1 + 2*random());
};

void() LostCheckAttack = { // Found it!
	// setup enemytarget if one is not active
	if (self.enemy.classtype != CT_ENEMYTARGET && self.height > 0) {
		if (SUB_setupEnemyTarget(self.enemy, self.height, MONAI_ABOVETIMER)) {
			self.enemy = self.enemytarget;
		}
	}

	// Melee attack (bite)
	if (ai_checkmelee(MONAI_MELEELOSTSOUL,FALSE)) {
		self.attack_state = AS_MELEE;
		return;
	}

	// If too close, strafe sideways until can ram again, if too far, move closer
	if (self.enemydist < MONAI_RANGELOSTNEAR) {
		self.attack_state = AS_SLIDING;
		return;
	} else if (self.enemydist > MONAI_RANGELOSTFAR) {
		self.attack_state = AS_STRAIGHT;
		return;
	}

	// Cannot see enemy? go into guard mode
	if (!enemy_vis && self.lostsearch == FALSE) {
		SUB_switchEnemyTarget();
		self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
		self.lostsearch = TRUE;
		self.lostenemy = self.enemy;
		self.losttimer = time + MONAI_LOSTTIMER + random()*5;
		self.enemy = self.goalentity = self.movetarget = world;
		self.th_altstand();
		return;
	}
	
	// Range attack (Ramming Speed).  Only range attack if cooldown has finished
	if (time > self.attack_finished) {
		if (!visblocked_wide(SUB_entEnemyTarget(), self.view_ofs, '0 0 24')) {
			SUB_AttackFinished(2 + random());
			self.attack_state = AS_MISSILE;
		} else self.attack_state = AS_SLIDING; // No space for raming speed, strafe side to side
	} else self.attack_state = AS_SLIDING; // Wait for attack timer, better to face the player
};

void() JimCheckAttack = {
	// Cannot see enemy? stop chasing enemytarget
	if (!enemy_vis) {
		SUB_switchEnemyTarget();
		return;
	}

	// If setup to be a turret, check range attack only
	if (self.movespeed < 0) {
		if (time < self.attack_finished) return;
		if (!visblocked_wide(SUB_entEnemyTarget(), self.attack_offset, '0 0 0')) {
			SUB_AttackFinished(2 + random());
			self.attack_state = AS_MISSILE;
		}
		return;
	}

	// setup enemytarget if one is not active
	if (self.enemy.classtype != CT_ENEMYTARGET && self.height > 0) {
		if (SUB_setupEnemyTarget(self.enemy, self.height, MONAI_ABOVETIMER)) {
			self.enemy = self.enemytarget;
		}
	}

	// Range attack (Lasers).  Only range attack if cooldown has finished
	if (time > self.attack_finished) {
		if (enemy_range == RANGE_MELEE) self.attack_chance = 0.9;		// range < 120 map units
		else if (enemy_range == RANGE_NEAR) self.attack_chance = 0.6;	// range < 500 map units
		else if (enemy_range == RANGE_MID) self.attack_chance = 0.2;	// range < 1000 map units
		else self.attack_chance = 0;
		if (random () < self.attack_chance) {
			if (!visblocked_wide(SUB_entEnemyTarget(), self.attack_offset, '0 0 0')) {
				if (enemy_range != RANGE_MELEE)	SUB_AttackFinished(2 + random());
				self.attack_state = AS_MISSILE;
				return;
			}
		}
	}

	// Make sure jim maintains its distance (strafe)
	if (enemy_range >= RANGE_MID) {
		if (self.attack_state != AS_STRAIGHT) self.attack_state = AS_STRAIGHT;
	}
	else self.attack_state = AS_SLIDING;
};

void() SweeperCheckAttack = {
	// Cannot see enemy? stop chasing enemytarget (wait 20s)
	if (!enemy_vis && self.enemylastseen < (time - 20) ) {
		self.enemyexit = TRUE;
		return;
	}

	// If setup to be a turret, check range attack only
	if (self.movespeed < 0) {
		if (time < self.attack_finished) return;
		if (!visblocked_wide(SUB_entEnemyTarget(), self.attack_offset, '0 0 0')) {
			SUB_AttackFinished(2 + random());
			self.weaponstate = TRUE; 	// Mines/Lasers
			self.attack_state = AS_MISSILE;
		}
		return;
	}

	// setup enemytarget if one is not active
	if (self.enemy.classtype != CT_ENEMYTARGET && self.height > 0) {
		if (SUB_setupEnemyTarget(self.enemy, self.height, MONAI_ABOVETIMER)) {
			self.enemy = self.enemytarget;
		}
	}

	// Range attack (Mines/Spikes).  Range attack if cooldown has finished and can see enemy
	if (self.attack_finished < time && enemy_vis) {
		// Is the enemy close enough for plasma spin attack?
		if (self.enemydist < MONAI_RANGESWEEPER) {
			self.weaponstate = FALSE;	// Fire plasma
			SUB_AttackFinished(1);		// Relentless attacks
			self.attack_state = AS_MISSILE;
			return;
		} else {
			// Work out the distance below
			traceline(self.origin, self.origin + '0 0 -1024', TRUE, self);
			self.distance = fabs(vlen(trace_endpos - self.origin));

			// Is there enough space below to fire mines?
			if (self.distance > MONAI_RANGEMINESWEEPER) {
				self.weaponstate = TRUE;	// Fire Mines
				SUB_AttackFinished(2 + random());
				self.attack_state = AS_MISSILE;
				return;
			}
		}
	}

	// Make sure sweeper maintains its distance (strafe)
	if (enemy_range >= RANGE_MID) {
		if (self.attack_state != AS_STRAIGHT) self.attack_state = AS_STRAIGHT;
	}
	else self.attack_state = AS_SLIDING;
};

void() SentinelCheckAttack = {
	// Cannot see enemy? stop chasing enemytarget
	if (!enemy_vis) {
		SUB_switchEnemyTarget();
		return;
	}

	// setup enemytarget if one is not active
	if (self.enemy.classtype != CT_ENEMYTARGET && self.height > 0) {
		if (SUB_setupEnemyTarget(self.enemy, self.height, MONAI_ABOVETIMER)) {
			self.enemy = self.enemytarget;
		}
	}

	// Range attack (Laser/Nail).  Only range attack if cooldown has finished
	if (time > self.attack_finished) {
		if (!visblocked_wide(SUB_entEnemyTarget(), self.attack_offset, '0 0 0')) {
			SUB_AttackFinished(1);
			self.attack_state = AS_MISSILE;
			return;
		}
	}	
};

void() TurretbCheckAttack = {
	// Range attack (Laser/Plasma)
	// The angles_x field of the turret is reversed because the model is rotated wierdly and will cause problems with some ai_sub functions
	// which means only traceline AI sight tests can be used.

	// Can the turret see the enemy? (using a traceline function)
	self.finaldest = self.angles;
	self.finaldest_x = -self.finaldest_x;
	if ( !visang(self.enemy, '0 0 0', self.finaldest, FALSE) ) return;
	
	// Create backup copy of enemy origin so that if the turret loses sight of the enemy, it will use this origin instead
	// Not a great fan of monsters tracking enemies through walls and the turret shooting at the last known location can often lead
	// to some interesting surprises for strafing players.
	self.move_state = self.enemy.origin;

	// Is the enemy is close? keep fighting
	if (self.enemydist < self.distance)
		self.attack_timer = time + self.waitmin;

	// Only range attack if attack cooldown has finished
	if (time > self.attack_finished) {
		SUB_AttackFinished(1);
		self.attack_state = AS_MISSILE;
	}	
};

void() CenturionCheckAttack = {
	// Cannot see enemy? stop chasing enemytarget
	if (!enemy_vis) {
		SUB_switchEnemyTarget();
		return;
	}

	// If setup to be a turret, check range attack only
	if (self.movespeed < 0) {
		if (time < self.attack_finished) return;
		if (!visblocked_wide(SUB_entEnemyTarget(), self.attack_offset, '0 0 0')) {
			SUB_AttackFinished(2 + random());
			self.attack_state = AS_MISSILE;
		}
		return;
	}

	// setup enemytarget if one is not active
	if (self.enemy.classtype != CT_ENEMYTARGET && self.height > 0) {
		if (SUB_setupEnemyTarget(self.enemy, self.height, MONAI_ABOVETIMER)) {
			self.enemy = self.enemytarget;
		}
	}

	// Range attack (Plasma).  Only range attack if cooldown has finished
	if (time > self.attack_finished) {
		if (enemy_range == RANGE_MELEE) self.attack_chance = 0.9;		// range < 120 map units
		else if (enemy_range == RANGE_NEAR) self.attack_chance = 0.6;	// range < 500 map units
		else if (enemy_range == RANGE_MID) self.attack_chance = 0.2;	// range < 1000 map units
		else self.attack_chance = 0;
		if (random () < self.attack_chance) {
			if (!visblocked_wide(SUB_entEnemyTarget(), self.attack_offset, '0 0 0')) {
				if (enemy_range != RANGE_MELEE)	SUB_AttackFinished(2 + random());
				self.attack_state = AS_MISSILE;
				return;
			}
		}
	}	

	// Make sure the centurion maintains its distance (strafe)
	if (enemy_range >= RANGE_MID) {
		if (self.attack_state != AS_STRAIGHT) self.attack_state = AS_STRAIGHT;
	}
	else self.attack_state = AS_SLIDING;
};

void() GargoyleCheckAttack = {
	// Cannot see enemy? stop chasing enemytarget
	if (!enemy_vis) {
		SUB_switchEnemyTarget();
		return;
	}

	// If setup to be a turret, check range attack only
	if (self.movespeed < 0) {
		if (time < self.attack_finished) return;
		if (!visblocked_wide(SUB_entEnemyTarget(), self.attack_offset, '0 0 0')) {
			SUB_AttackFinished(2 + random());
			self.attack_state = AS_MISSILE;
		}
		return;
	}

	// setup enemytarget if one is not active
	if (self.enemy.classtype != CT_ENEMYTARGET && self.height > 0) {
		if (SUB_setupEnemyTarget(self.enemy, self.height, MONAI_ABOVETIMER)) {
			self.enemy = self.enemytarget;
		}
	}

	// Range attack (Fireball).  Only range attack if cooldown has finished
	if (time > self.attack_finished) {
		if (enemy_range == RANGE_MELEE) self.attack_chance = 0.9;		// range < 120 map units
		else if (enemy_range == RANGE_NEAR) self.attack_chance = 0.6;	// range < 500 map units
		else if (enemy_range == RANGE_MID) self.attack_chance = 0.2;	// range < 1000 map units
		else self.attack_chance = 0;
		if (random () < self.attack_chance) {
			if (!visblocked_wide(SUB_entEnemyTarget(), self.attack_offset, '0 0 0')) {
				if (enemy_range != RANGE_MELEE)	SUB_AttackFinished(2 + random());
				self.attack_state = AS_MISSILE;
				return;
			}
		}
	}
	
	// Make sure the gargoyle maintains its distance (strafe)
	if (enemy_range >= RANGE_MID) {
		if (self.attack_state != AS_STRAIGHT) self.attack_state = AS_STRAIGHT;
	}
	else self.attack_state = AS_SLIDING;
};

void() GauntCheckAttack = {
	// Cannot see enemy? stop chasing enemytarget
	if (!enemy_vis) {
		SUB_switchEnemyTarget();
		return;
	}

	// If setup to be a turret, check range attack only
	if (self.movespeed < 0) {
		if (time < self.attack_finished) return;
		if (!visblocked_wide(SUB_entEnemyTarget(), self.attack_offset, '0 0 0')) {
			SUB_AttackFinished(2 + random());
			self.attack_state = AS_MISSILE;
		}
		return;
	}

	// setup enemytarget if one is not active
	if (self.enemy.classtype != CT_ENEMYTARGET && self.height > 0) {
		if (SUB_setupEnemyTarget(self.enemy, self.height, MONAI_ABOVETIMER)) {
			self.enemy = self.enemytarget;
		}
	}

	// Range attack (Plasma volley).  Only range attack if cooldown has finished
	if (time > self.attack_finished) {
		if (enemy_range == RANGE_MELEE) self.attack_chance = 0.9;		// range < 120 map units
		else if (enemy_range == RANGE_NEAR) self.attack_chance = 0.6;	// range < 500 map units
		else if (enemy_range == RANGE_MID) self.attack_chance = 0.2;	// range < 1000 map units
		else self.attack_chance = 0;
		if (random () < self.attack_chance) {
			if (!visblocked_wide(SUB_entEnemyTarget(), self.attack_offset, '0 0 0')) {
				if (enemy_range != RANGE_MELEE)	SUB_AttackFinished(2 + random());
				self.attack_state = AS_MISSILE;
				return;
			}
		}
	}

	// Make sure the Gaunt maintains its distance (strafe)
	if (enemy_range >= RANGE_MID) {
		if (self.attack_state != AS_STRAIGHT) self.attack_state = AS_STRAIGHT;
	}
	else self.attack_state = AS_SLIDING;
};

void() GauntCheckAttackQuoth = {
	local vector spot1, spot2;
	local entity targ;
	local float chance;

	if (time < self.attack_finished) return 0;
	if (!enemy_vis) return 0;

	if (enemy_range == RANGE_FAR) {
		if (self.attack_state != AS_STRAIGHT) {
			self.attack_state = AS_STRAIGHT;
			gaunt_run1();
		}
		return;
	}
	targ = self.enemy;
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;
	traceline(spot1, spot2, 0, self);
	if (trace_ent != targ) {
		if (self.attack_state != AS_STRAIGHT) {
			self.attack_state = AS_STRAIGHT;
			gaunt_run1();
		}
		return;
	}
	if (enemy_range == RANGE_MELEE) {
		chance = 0.9;
	} else {
		if (enemy_range == RANGE_NEAR) {
			chance = 0.3;
		} else {
			if (enemy_range == RANGE_MID) chance = 0.05;
		}
	}
	if (random() < chance) {
		self.attack_state = AS_MISSILE;
		return;
	}
	if (enemy_range > RANGE_NEAR) {
		if (self.attack_state != AS_STRAIGHT) {
			self.attack_state = AS_STRAIGHT;
			gaunt_run1();
		}
	} else {
		if (self.attack_state != AS_SLIDING) {
			self.attack_state = AS_SLIDING;
			gaunt_side1();
		}
	}
};

void() FishCheckAttack = {
	// Melee attack (Bite).  Uses larger knight distance.
	if (ai_checkmelee(MONAI_MELEEKNIGHT,FALSE)) {
		self.attack_state = AS_MELEE;
		self.th_melee ();
		return;
	}
};

void() EelCheckAttack = {
	// Range attack (Plasma bolt).  Only range attack if cooldown has finished
	if (time > self.attack_finished) {
		if (!visblocked_wide(self.enemy, self.attack_offset, '0 0 0')) {
			if (enemy_range != RANGE_MELEE)	SUB_AttackFinished(2 + random());
			self.attack_state = AS_MISSILE;
			return;
		}
	}

	// Make sure the Eel maintains its distance (strafe)
	if (enemy_range >= RANGE_MID || !enemy_vis) {
		if (self.attack_state != AS_STRAIGHT) self.attack_state = AS_STRAIGHT;
	}
	else self.attack_state = AS_SLIDING;
};

void() WraithCheckAttack = {
	// Cannot see enemy? stop chasing enemytarget
	if (!enemy_vis) {
		SUB_switchEnemyTarget();
		return;
	}

	// If setup to be a turret, check range attack only
	if (self.movespeed < 0) {
		if (time < self.attack_finished) return;
		if (!visblocked_wide(SUB_entEnemyTarget(), self.attack_offset, '0 0 0')) {
			SUB_AttackFinished(2 + random());
			self.attack_state = AS_MISSILE;
		}
		return;
	}

	// setup enemytarget if one os not active
	if (self.enemy.classtype != CT_ENEMYTARGET && self.height > 0) {
		if (SUB_setupEnemyTarget(self.enemy, self.height, MONAI_ABOVETIMER)) {
			self.enemy = self.enemytarget;
		}
	}

	// Range attack (burning and creature summons).  Much more aggressive decision on range attacks (ogre style)
	// No random chance percentages, logic with wraith magic function.  Only range attack if cooldown has finished.
	if (time > self.attack_finished) {
		if (!visblocked_wide(SUB_entEnemyTarget(), self.attack_offset, '0 0 0')) {
			if (enemy_range != RANGE_MELEE)	SUB_AttackFinished(2 + random());
			self.attack_state = AS_MISSILE;
			return;
		}
	}

	// If turret, then do not move sideways
	if (self.movespeed < 0) {
		if (self.attack_state != AS_STRAIGHT) self.attack_state = AS_STRAIGHT;
		return;
	}

	// Make sure the wraith maintains its distance (strafe)
	if (enemy_range >= RANGE_MID) {
		if (self.attack_state != AS_STRAIGHT) self.attack_state = AS_STRAIGHT;
	} else self.attack_state = AS_SLIDING;
};

void() MinotaurCheckAttack = {
	// If health is low enough, switch to rage mode; this does not affect the minion spawning version
	if ( !(self.spawnflags & MON_MINOTAUR_MINIONS) && self.movespeed >= 0) {
		if (self.health < self.max_health*0.5 && !self.attack_rage) {
			self.attack_rage = TRUE;
			self.th_charge();	// Short howl at the sky
			return;
		}
	}

	// Melee attack (claws)
	if (ai_checkmelee(MONAI_MELEEMINOTAUR,MONAI_MELEEZTALL)) {
		self.attack_state = AS_MELEE;
		return;
	}

	// If setup to be a turret, check range attack only
	if (self.movespeed < 0) {
		if (time < self.attack_finished) return;
		if (visblocked(self.enemy)) return;
		// Keep firing rockets when at range
		SUB_AttackFinished (1 + 2*random());
		self.attack_state = AS_MISSILE;
		return;
	}

	// RAGE mode (keep running at player)
	if (self.attack_rage) {
		if (self.attack_state != AS_STRAIGHT) self.attack_state = AS_STRAIGHT;
		// Check range and sight for a low chance range attack
		if (!enemy_vis) return;
		if (time < self.attack_finished) return;
		// If enemy not infront or random chance, stop and range attack
		if (!infront(self.enemy) || random() < 0.1) {
			// Does the monster have a clear shot to the player? sightline can be blocked by other monsters
			if (visblocked(self.enemy)) return;
			SUB_AttackFinished (2 + 2*random());
			self.attack_state = AS_MISSILE; // Plasma bolt attack
		}
	} else {
		// PASSIVE mode (keep at distance)
		// Is the player NOT visible? Keep getting closer
		if (!enemy_vis) {
			if (self.attack_state != AS_STRAIGHT) self.attack_state = AS_STRAIGHT;
		} else {
			// Mid Range attack (JUMP) Not spawning dark version
			if ( !(self.spawnflags & MON_MINOTAUR_MINIONS) && random() < 0.35) {
				// Jumped recently, facing right direction and not blocked?
				if (self.jump_flag < time && infront(self.enemy)) {
					if (!visblocked_wide(self.enemy, self.view_ofs, self.enemy.view_ofs) ) {
						// Check for enemy above? (z axis)
						if (self.enemy.origin_z <= self.origin_z) {
							// Is the minotaur within the right range?
							if (self.enemydist > self.jumprange_x && self.enemydist < self.jumprange_y) {
								SUB_AttackFinished (random()); // Block any range attacks for a while
								self.jumptouch = world;	// Reset last object touched
								self.count = 0;			// Number of times jumped
								self.th_jump ();
								return;
							}
						}
					}
				}
			}

			// Range / missile attack (plasma bolts).  Any chance of a range attack?
			if (time < self.attack_finished) {
				// Calculate a flat vector to ignore Z axis difference
				self.enemydist = range_distance(self.enemy, TRUE);
				// Don't always stay at absolute range, move closer
				if (random() < 0.15 && self.enemydist > MONAI_RANGEMINOTAUR) {
					self.attack_sidedeny = time + 1 + random();
					self.attack_state = AS_STRAIGHT;
				} else {
					// If not blocked, turn and move sideways
					if (self.attack_sidedeny < time) self.attack_state = AS_SIDESTEP;
				}
			} else {
				// Does the monster have a clear shot to the player? sightline can be blocked by other monsters
				if (visblocked(self.enemy)) return;

				SUB_AttackFinished (2 + 2*random()); // Keep firing plasma when at range
				self.attack_state = AS_MISSILE;
			}
		}
	}
};

void() DroleCheckAttack = {
	// Quoth setup - 500HP, with rage at 350HP.  Converted it to a % so mappers can change health
	if (self.movespeed >= 0) {
		if (self.health < self.max_health*0.7 && !self.attack_rage) self.attack_rage = TRUE;
	}

	// Melee attack (tentacles)
	if (ai_checkmelee(MONAI_MELEEDROLE2,MONAI_MELEEZTALL)) {
		self.attack_state = AS_MELEE;
		return;
	}

	// If setup to be a turret, check range attack only
	if (self.movespeed < 0) {
		if (time < self.attack_finished) return;
		if (visblocked(self.enemy)) return;
		// Keep firing rockets when at range
		SUB_AttackFinished (1 + 2*random());
		self.attack_state = AS_MISSILE;
		return;
	}

	// RAGE mode (keep running at player)
	if (self.attack_rage) {
		if (self.attack_state != AS_STRAIGHT) self.attack_state = AS_STRAIGHT;
		// Check range and sight for a low chance range attack
		if (!enemy_vis) return;
		if (time < self.attack_finished) return;
		// Calculate a flat vector to ignore Z axis difference.  Not convinced a flat vector is good for a melee only state
		// Switched to 3D distance chance so its not so dumb
		self.enemydist = range_distance(self.enemy, FALSE);
		if (self.enemydist > MONAI_RANGEDROLE && random() < 0.3) {
			// Does the monster have a clear shot to the player? sightline can be blocked by other monsters
			if (visblocked(self.enemy)) return;
			// Standard rocket attack
			SUB_AttackFinished (1 + 2*random());
			self.attack_state = AS_MISSILE;
		}
	} else {
		// PASSIVE mode (keep at distance)
		// Is the player visible? Keep getting closer
		if (!enemy_vis) {
			if (self.attack_state != AS_STRAIGHT) 
				self.attack_state = AS_STRAIGHT;
		} else {
			// Player in sight, fireball or loiter?  Any chance of a range attack?
			if (time < self.attack_finished) {
				// Calculate a flat vector to ignore Z axis difference.  Not convinced a flat vector is good for a melee only state
				// Switched to 3D distance chance so its not so dumb
				self.enemydist = range_distance(self.enemy, FALSE);
				// Don't always stay at absolute range, move closer 15% of the time
				if (random() < 0.15 && self.enemydist > MONAI_RANGEDROLE) {
					self.attack_sidedeny = time + 1 + random();
					self.attack_state = AS_STRAIGHT;
				} else {
					// If not blocked, turn and move sideways
					if (self.attack_sidedeny < time) self.attack_state = AS_SIDESTEP;
				}
			} else {
				// Does the monster have a clear shot to the player? sightline can be blocked by other monsters
				if (visblocked(self.enemy)) return;
				// Keep firing rockets when at range
				SUB_AttackFinished (1 + 2*random());
				self.attack_state = AS_MISSILE;
			}
		}
	}
};

void() DSergeantCheckAttack = {
	// Does the monster have a clear shot to the player? sightline can be blocked by other monsters
	if (visblocked(self.enemy)) return;

	// Melee attack, enemy_range is checked before this function (ai_run - ai.qc)
	// If the monster is within melee range they instantly attack
	if (ai_checkmelee(MONAI_MELEEFRONT,FALSE)) {
		self.attack_state = AS_MELEE;
		self.th_melee ();
		return;
	}

	// If setup to be a turret, check range attack only
	if (self.movespeed < 0) {
		if (time < self.attack_finished) return;
		// If the sightline between self and player blocked by anything, keep moving
		if (!visxray(self.enemy, self.attack_offset, '0 0 10', FALSE)) return;
		self.attack_state = AS_MISSILE;
		return;
	}

	// If range blocked do charging instead
	if (time < self.attack_finished) {
		// Charge attack.  Player within certain range, height and charging not blocked?
		self.height = fabs(self.origin_z - self.enemy.origin_z);
		if (ai_checkmelee(MONAI_CHARGEFLAIL,FALSE) && self.height < MONAI_CHARGEZAXIS
				&& self.attack_timer < time) {
			// If attack timer not active, bump up with a random amount
			if (self.attack_finished < time) SUB_AttackFinished (random());
			self.th_charge ();
			return;
		}	
	} else {
		// Range attack - Homing missile
		// If the sightline between self and player blocked, allow for monsters to be hit (infighting rules!)
		if (!visxray(self.enemy, self.attack_offset, '0 0 10', FALSE)) return;
		self.attack_state = AS_MISSILE;
	}
};

void() DPrinceCheckAttack = {
	// Does the monster have a clear shot to the player? sightline can be blocked by other monsters
	if (visblocked(self.enemy)) return;

	// Melee attack, enemy_range is checked before this function (ai_run - ai.qc)
	// If the monster is within melee range they instantly attack
	if (ai_checkmelee(MONAI_MELEEFRONT,FALSE)) {
		self.attack_state = AS_MELEE;
		self.th_melee (); 
		return;
	}

	// Range attack
	if (time < self.attack_finished) return;
	// Hazard projectiles are fired over 6 frames
	if (skill <= SKILL_NORMAL) self.attack_count = 6;
	else self.attack_count = 12;

	// Weaponstate range attacks: 1=Close range (hazard), 2=Far range (rockets)
	// Always attack monsters with rockets (good range/damage)
	if (self.enemy.flags & FL_MONSTER) self.weaponstate = 2;
	else if (self.enemy.origin_z > (self.origin_z+MONAI_STEPLARGE)) self.weaponstate = 2; // If enemy too far above (vertical height) don't use hazard.  Allow some extra height (steplarge) for jumping players
	else if (!(HazardProjectile_CheckLimit(self, self.attack_count))) self.weaponstate = 2; // If reached hazard projectile limit use rockets instead
	else if (self.enemydist < MONAI_RANGEDPRINCE) self.weaponstate = 1; // If enemy close, use hazard attack
	else self.weaponstate = 2; // Default = rocket attack
	
	// Turret mode needs to fire much faster
	if (self.movespeed < 0) {
		SUB_AttackFinished (1 + random());
	} else {
		// The hazard attack should be faster recovery time
		if (self.weaponstate > 1) SUB_AttackFinished (2 + random());
		else SUB_AttackFinished (1 + random());
	}
	self.attack_state = AS_MISSILE; // Range attacks (decided by weaponstate)
};

void() DFuryCheckAttack = {
	// Does the monster have a clear shot to the player? sightline can be blocked by other monsters
	if (visblocked(self.enemy)) return;
		
	// Melee attack, enemy_range is checked before this function (ai_run - ai.qc)
	// If the monster is within melee range they instantly attack
	if (ai_checkmelee(MONAI_MELEEFRONT,FALSE)) {
		self.attack_state = AS_MELEE;
		self.th_melee (); 
		return;
	}

	// If setup to be a turret, check range attack only
	if (self.movespeed < 0) {
		if (time < self.attack_finished) return;
		// If the sightline between self and player blocked by anything, keep moving
		if (!visxray(self.enemy, self.attack_offset, '0 0 0', FALSE)) return;
		self.attack_state = AS_MISSILE;
		return;
	}

	// is the enemy close enough for a double sword slice attack?
	if (self.enemydist < self.jumprange_x) {
		self.attack_state = AS_MELEE;
		self.th_slide (); 
		return;
	}

	// Mid Range attack (JUMP).  Jumped recently, facing right direction and not blocked?
	if (self.jump_flag < time && infront(self.enemy) && !visblocked(self.enemy) ) {
		if (self.enemy.origin_z <= self.origin_z) { // Check for enemy above? (z axis)
			if (self.enemydist > self.jumprange_x && self.enemydist < self.jumprange_y) { // Is the fury knight within the right range?
				SUB_AttackFinished (random()); // Block any range attacks for a while
				self.jumptouch = world;		// Reset last object touched
				self.count = 0;				// Number of times jumped
				if (random() < 0.65) self.th_jump ();
				else self.th_charge ();
				return;
			}
		}
	}
	// Range attack.  The attack chance percentages are constant across skill levels
	if (time < self.attack_finished) return;
	// If the sightline between self and player blocked by anything, keep moving
	if (!visxray(self.enemy, self.attack_offset, '0 0 0', FALSE)) return;
	
	if (enemy_range == RANGE_MELEE) self.attack_chance = 0.9;		// range < 120 map units
	else if (enemy_range == RANGE_NEAR) self.attack_chance = 0.4;	// range < 500 map units
	else if (enemy_range == RANGE_MID) self.attack_chance = 0.05;	// range < 1000 map units
	else self.attack_chance = 0;
	if (random () < self.attack_chance) self.attack_state = AS_MISSILE;
};

void() JusticeCheckAttack = {
	// Special melee attack for monster infighting
	if (self.enemy.flags & FL_MONSTER) {
		// If monster outside of melee range, blast them with range
		if (self.enemydist > self.meleerange) self.attack_state = AS_MISSILE;
		else self.attack_state = AS_MELEE;
		return;
	}

	// If setup to be a turret, check range attack only
	if (self.movespeed < 0) {
		if (time < self.attack_finished) return;
		if (visblocked(self.enemy)) return;
		SUB_AttackFinished (1 + 2*random());
		self.attack_state = AS_MISSILE;
		return;
	}

	// Melee attack (Slash (left/right) and overhead smash)
	if (ai_checkmelee(MONAI_MELEEJUSTICE,FALSE)) {
		// Looks really odd if justice just charges all the time.  Random chance to stop and do a range (flame/spike) attack
		if (self.enemydist > MONAI_CLOSEJUSTICE && random() < 0.5) {
			self.attack_state = AS_MISSILE;
			SUB_AttackFinished (2 + random());
		} else self.attack_state = AS_MELEE; // Swing or Smash
		return;
	}

	// Range attack conditions
	if (!enemy_vis) return; // Can see the enemy?
	if (time < self.attack_finished) return; // Range/Jump attacks blocked for a while
	// If the sightline between self and player blocked by anything, keep moving
	if (!visxray(self.enemy, self.attack_offset, '0 0 0', FALSE)) return;

	// Mid Range attack (JUMP).  Jumped recently, facing right direction and not blocked?
	if ( self.jump_flag < time && infront(self.enemy) && !visblocked(self.enemy) ) {
		// Check for enemy above? (z axis)
		if (self.enemy.origin_z <= self.origin_z) {
			// Is the justice knight within the right range?
			if (self.enemydist > self.jumprange_x && self.enemydist < self.jumprange_y) {
				SUB_AttackFinished (random()); // Block any range attacks for a while
				self.jumptouch = world;		// Reset last object touched
				self.count = 0;				// Number of times jumped
				self.th_jump ();
				return;
			}
		}
	}
	// Range attack (Spikes or Flames)
	if (self.enemydist < MONAI_RANGEJUSTICE) return;
	self.attack_state = AS_MISSILE;
	SUB_AttackFinished (2 + random());
};

// Normal attack states checks
void() DCrossCheckAttack = {
	if (!enemy_vis) return;

	// Melee attack (blunt end of crossbow)
	if (ai_checkmelee(MONAI_MELEEKNIGHT,FALSE)) {
		self.attack_state = AS_MELEE;
		return;
	}

	// If setup to be a turret, check range attack only
	if (self.movespeed < 0) {
		if (time < self.attack_finished) return;
		// If sight blocked by another monster, do nothing
		if (!visblocked_wide(self.enemy, self.attack_offset, '0 0 0')) return;
		self.attack_state = AS_MISSILE;
		return;
	}

	// Range / missile attack (slow bolts)
	// The range logic is done via two set of animations (hold/slide).  Once within a certain range, stay there and snipe at the enemy
	if (enemy_range == RANGE_NEAR || self.enemymaxdist) { // range < 500 map units
		if (!visblocked_wide(self.enemy, self.attack_offset, '0 0 0')) { // If sight blocked by another monster, slide to the side
			self.attack_state = AS_SLIDING;
			self.th_slide ();
		} else {
			// No monster in the way, hold still and start aiming
			self.attack_state = AS_MISSILE;
			self.th_missile ();
		}
	} else self.attack_state = AS_STRAIGHT;
};

// Hold and slide function while aiming
void() dcrossbow_checkattack = {
	local float boltspeed;

	if (self.health < 1) return; // Always return if monster is dead!

	// Check to see if enemy is dead? back to run/hunt cycle
	if (self.enemy.health < 1) {
		dcrossbow_stop1();
	} else {
		// is the enemy visible? (liquid check)
		if (visible(self.enemy)) {
			self.weaponswitch = time + 1;
			// Is the enemy blocked by another enemy?
			if (!visblocked_wide(self.enemy, self.attack_offset, '0 0 0')) {
				// Is the enemy within melee range?
				if (ai_checkmelee(MONAI_MELEEKNIGHT,FALSE)) {
					self.th_melee();
				} else {
					boltspeed = SPEED_DCROSS + (skill*SPEED_BOLTSKILL); // Skill level adjustment for bolt speed
					self.attack_track = SUB_Tracking(self.attack_track, self.attack_offset, self.enemy, boltspeed);
					self.attack_chance = self.attack_chance + 0.2; // Chance of attack? start out low and get better chance+tracking over time	
					if (random() < self.attack_chance) dcrossbow_fire1();
				}
			}
		} else {
			// Have not see player for a while, stop wating and hunt for them
			if (self.weaponswitch < time+0.1) {
				dcrossbow_stop1();
			} else {
				if (self.attack_state == AS_MISSILE) self.think = dcrossbow_slide1; // If cannot see player try strafe side to side first before hunt mode
			}
		}
	}
};

// The player is in view, so decide to jump or melee
void() ZombiekCheckAttack = {
	if (!enemy_vis) return;

	// Melee attack (rusty sword)
	if (ai_checkmelee(MONAI_MELEEKNIGHT,FALSE)) {
		self.attack_state = AS_MELEE;
		return;
	}

	// If setup to be a turret, randomly do melee attacks
	if (self.movespeed < 0) {
		if (random() < MONAI_TURRETMODE) return;
		self.attack_state = AS_MELEE;
		return;
	}

	// Range / missile attack (jumping)
	if (time < self.attack_finished) return;
	self.attack_chance = 0.3 + skill*0.1;
	if (random() < self.attack_chance) {
		// Is the enemy the right distance away and the random chance is correct?
		if (self.enemydist > self.jumprange_x && self.enemydist < self.jumprange_y) {
			SUB_AttackFinished (2 + random()*2);
			self.jumptouch = world;			// Reset last object touched
			self.count = 0;					// Number of times jumped
			self.attack_state = AS_JUMP;	// JUMP JUMP JUMP!
		}
	}
};

// The player is in view, so blow up!
void() BoilCheckAttack = {
	if (!enemy_vis) return;
	// Only has one attack, run at player and explode.  Does one simple range check regardless if turret
	if (self.enemydist < MONAI_MELEEBOIL) self.attack_state = AS_MELEE;
};

void() SpawnCheckAttack = {
	// Spawns don't start jumping straight away unless they can directly see the player.
	// They slowly crawl around which can make them tricky to plan for an ambush.
	// Does the monster have a clear shot to the player? sightline can be blocked by other monsters
	if (visblocked(self.enemy)) return;

	// JUMP Melee attack.  This pretty much a close quarter jump in the face attack!
	if (ai_checkmelee(MONAI_MELEESPAWN,FALSE)) {
		self.attack_state = AS_MELEE;
		self.th_melee();
		return;
	}

	// If setup to be a turret, randomly do melee attacks
	if (self.movespeed < 0) {
		if (random() < MONAI_TURRETMODE) return;
		self.attack_state = AS_MELEE;
		return;
	}

	// JUMP Range attack
	// The attack chance percentages are constant across skill levels
	if (time < self.attack_finished) return;


	if (enemy_range == RANGE_MELEE) {
		self.attack_chance = 0.9;
		self.attack_finished = 0;
	} else if (enemy_range == RANGE_NEAR) self.attack_chance = 0.2;
	else if (enemy_range == RANGE_MID) self.attack_chance = 0.05;
	else self.attack_chance = 0;

	if (random () < self.attack_chance) {
		SUB_AttackFinished (2*random());
		self.jumptouch = world;			// Reset last object touched
		self.count = 0;					// Number of times jumped
		self.attack_state = AS_JUMP;	// JUMP JUMP JUMP!
	}
};

void() DemonCheckAttack = {
	// Melee attack (CLAWS).  Check that within range of a claw attack
	if (ai_checkmelee(MONAI_MELEEDEMON,FALSE)) {
		self.attack_state = AS_MELEE;
		return;
	}

	// If setup to be a turret, randomly do melee attacks
	if (self.movespeed < 0) {
		if (random() < MONAI_TURRETMODE) return;
		self.attack_state = AS_MELEE;
		return;
	}

	// Range attack (JUMP) Time for another jump?
	if (self.jump_flag < time) {
		// Stop the demon over or under jumping the enemy
		if (self.origin_z + self.mins_z > self.enemy.origin_z + self.enemy.mins_z
		+ 0.75 * self.enemy.size_z) return;
		if (self.origin_z + self.maxs_z < self.enemy.origin_z + self.enemy.mins_z
		+ 0.25 * self.enemy.size_z) return;
			
		// Check for closeness, but not long range!
		self.enemydist = range_distance(self.enemy, TRUE);
		if (self.enemydist < self.jumprange_x) return;
		
		// Check for low ceilings directly above the demon
		traceline(self.origin, self.origin + '0 0 256', TRUE, self);
		self.height = fabs(vlen(trace_endpos - self.origin));
		// Ceiling is too low (looks dumb hitting ceilings)
		if (self.height < MONAI_JUMPDEMONCHECK) return; 

		// ** QC code from necros **  Move the demon forward 16 units and check if blocked
		self.pos1 = self.origin;
		self.ideal_yaw = vectoyaw(self.enemy.origin - self.pos1);
		// If move forward fails, move back and indicate no jump
		if (!walkmove(self.ideal_yaw, 16)) {
			setorigin(self, self.pos1);
			return;
		}
		
		setorigin(self, self.pos1);			// walkmove successful, move demon back
		self.jumptouch = world;				// Reset last object touched
		self.count = 0;						// Number of times jumped
		self.attack_state = AS_JUMP;		// JUMP JUMP JUMP!
	}
};

void() ScorpionCheckAttack = {
	// Melee attack (CLAWS)
	if (ai_checkmelee(MONAI_MELEESCORPION,FALSE)) {
		self.attack_state = AS_MELEE;
		self.th_melee ();
		return;
	}

	// If setup to be a turret, do range attacks
	if (self.movespeed < 0) {
		if (time < self.attack_finished) return;
		SUB_AttackFinished (2 + random());
		self.attack_state = AS_MISSILE;
		return;
	}
	
	// Range attack (JUMP/TAIL)
	if (!enemy_vis) return;
	if (time < self.attack_finished) return;

	if (self.spawnflags & MON_SCORPION_STINGER) {
		// check for extra wide space to jump
		if (!visblocked_wide(self, self.attack_offset, self.enemy.view_ofs)) return;
		
		// Time for another jump?
		if (self.jump_flag < time) {
			self.enemydist = range_distance(self.enemy, TRUE);
			if (self.enemydist < self.jumprange_x) return;
			if (self.enemydist > self.jumprange_y) return;

			self.jumptouch = world;		// Reset last object touched
			self.count = 0;				// Number of times jumped
			self.attack_state = AS_JUMP;
		}
	} else {
		if (enemy_range == RANGE_MELEE) self.attack_chance = 0.9;		// range < 120 map units
		else if (enemy_range == RANGE_NEAR) self.attack_chance = 0.6;	// range < 500 map units
		else if (enemy_range == RANGE_MID) self.attack_chance = 0.2;	// range < 1000 map units
		else self.attack_chance = 0;
		if (random () < self.attack_chance) {
			SUB_AttackFinished (2 + random());
			self.attack_state = AS_MISSILE;
		}
	}
};

void()	DogCheckAttack = {
	// Melee attack (BITE).  Check that within range of a bite attack
	if (ai_checkmelee(MONAI_MELEEDOG,FALSE)) {
		self.attack_state = AS_MELEE;
		return;
	}

	// If setup to be a turret, randomly do melee attacks
	if (self.movespeed < 0) {
		if (random() < MONAI_TURRETMODE) return;
		self.attack_state = AS_MELEE;
		return;
	}

	// Range attack (JUMP).  Has the dog jumped less than 2 seconds ago?
	if (self.jump_flag < time) {
		// Stop the dog over or under jumping the enemy
		if (self.origin_z + self.mins_z > self.enemy.origin_z + self.enemy.mins_z
		+ 0.75 * self.enemy.size_z) return;
		if (self.origin_z + self.maxs_z < self.enemy.origin_z + self.enemy.mins_z
		+ 0.25 * self.enemy.size_z) return;
			
		self.enemydist = range_distance(self.enemy, TRUE);
		if (self.enemydist < self.jumprange_x) return;
		if (self.enemydist > self.jumprange_y) return;

		// Check for enemy above? (z axis)
		if (self.enemy.origin_z > self.origin_z) return;
		self.jumptouch = world;			// Reset last object touched
		self.count = 0;					// Number of times jumped
		self.attack_state = AS_JUMP;
	}
};

void() SpiderCheckAttack = {
	// Melee attack (BITE)
	if (ai_checkmelee(MONAI_MELEESPIDER,FALSE)) { // Check that within range of a bite attack
		self.attack_state = AS_MELEE;
		return;
	}

	// Range attack (Large Green Spider = SPIT).  Behaves like a wizards; strafe, spit goo
	if (self.spawnflags & MON_SPIDER_LARGE) {
		if (!enemy_vis) return;
		if (time < self.attack_finished) return;

		// Does the monster have a clear shot to the player? sightline can be blocked by other monsters
		if (enemy_range == RANGE_FAR || visblocked(self.enemy)) {
			if (self.attack_state != AS_STRAIGHT) {
				self.attack_state = AS_STRAIGHT;
				self.th_run ();
			}
			return;
		}

		if (enemy_range == RANGE_MELEE) self.attack_chance = 0.9;		// range < 120 map units
		else if (enemy_range == RANGE_NEAR) self.attack_chance = 0.6;	// range < 500 map units
		else if (enemy_range == RANGE_MID) self.attack_chance = 0.2;	// range < 1000 map units
		else self.attack_chance = 0;
		if (random () < self.attack_chance) {
			SUB_AttackFinished (2 + random());
			self.attack_state = AS_MISSILE;
		} else if (enemy_range == RANGE_MID) {
			if (self.attack_state != AS_STRAIGHT) {
				self.attack_state = AS_STRAIGHT;
				self.th_run ();
			}
		} else {
			if (self.attack_state != AS_SLIDING) {
				self.attack_state = AS_SLIDING;
				self.th_slide ();
			}
		}
	} else {
		// Range attack (Small Brown Spider = JUMP).  Behaves like a dog; run and jump
		if (self.jump_flag < time) { // Is it time to jump?
			// Stop the spider over or under jumping the enemy
			if (self.origin_z + self.mins_z > self.enemy.origin_z + self.enemy.mins_z
			+ 0.75 * self.enemy.size_z) return;
			if (self.origin_z + self.maxs_z < self.enemy.origin_z + self.enemy.mins_z
			+ 0.25 * self.enemy.size_z) return;
				
			self.enemydist = range_distance(self.enemy, TRUE);
			if (self.enemydist < self.jumprange_x) return;
			if (self.enemydist > self.jumprange_y) return;
			if (self.enemy.origin_z > self.origin_z) return; // Check for enemy above? (z axis)
			self.jumptouch = world;		// Reset last object touched
			self.count = 0;				// Number of times jumped
			self.attack_state = AS_JUMP;
		}
	}
};

void() SteelclawCheckAttack = {
	// Melee attack (BITE).  Check that within range of a bite attack
	if (ai_checkmelee(MONAI_MELEESTEELCLAW,FALSE) && random() < 0.5) {
		self.attack_state = AS_MELEE;
		return;
	}

	// Range attack (JUMP), check for extra wide space to jump
	if (!visblocked_wide(self, self.attack_offset, self.enemy.view_ofs)) return;
	
	// Time for another jump?
	if (self.jump_flag < time) {
		self.enemydist = range_distance(self.enemy, TRUE);
		if (self.enemydist < self.jumprange_x) return;
		if (self.enemydist > self.jumprange_y) return;

		self.jumptouch = world;		// Reset last object touched
		self.count = 0;				// Number of times jumped
		self.attack_state = AS_JUMP;
	}
};

void() ElfCheckAttack = {
	// Melee attack (CANE).  Check that within range of a cane attack
	if (ai_checkmelee(MONAI_MELEEELF,FALSE)) {
		self.attack_state = AS_MELEE;
		return;
	}

	// Range attack (Elf 2 (Black pants) = Magic).  Behaves like a wizards; strafe, spit goo
	if (self.spawnflags & MON_ELF_MAGIC) {
		if (!enemy_vis) return;
		if (time < self.attack_finished) return;

		// Does the monster have a clear shot to the player?
		// sightline can be blocked by other monsters
		if (enemy_range == RANGE_FAR || visblocked(self.enemy)) {
			if (self.attack_state != AS_STRAIGHT) {
				self.attack_state = AS_STRAIGHT;
				self.th_run ();
			}
			return;
		}

		if (enemy_range == RANGE_MELEE) self.attack_chance = 0.9;		// range < 120 map units
		else if (enemy_range == RANGE_NEAR) self.attack_chance = 0.6;	// range < 500 map units
		else if (enemy_range == RANGE_MID) self.attack_chance = 0.2;	// range < 1000 map units
		else self.attack_chance = 0;
		if (random () < self.attack_chance) {
			SUB_AttackFinished (2 + random());
			self.attack_state = AS_MISSILE;
		} else if (enemy_range == RANGE_MID) {
			if (self.attack_state != AS_STRAIGHT) {
				self.attack_state = AS_STRAIGHT;
				self.th_run ();
			}
		} else {
			if (self.attack_state != AS_SLIDING) {
				self.attack_state = AS_SLIDING;
				self.th_slide ();
			}
		}
	} else {
		// Range attack (Elf 1 (green/red pants) = JUMP). Behaves like a dog; run and jump.  Is it time to jump?
		if (self.jump_flag < time) {
			// Stop the elf over or under jumping the enemy
			if (self.origin_z + self.mins_z > self.enemy.origin_z + self.enemy.mins_z + 0.75 * self.enemy.size_z) return;
			if (self.origin_z + self.maxs_z < self.enemy.origin_z + self.enemy.mins_z + 0.25 * self.enemy.size_z) return;
	
			self.enemydist = range_distance(self.enemy, TRUE);
			if (self.enemydist < self.jumprange_x) return;
			if (self.enemydist > self.jumprange_y) return;
			// Check for enemy above? (z axis)
			if (self.enemy.origin_z > self.origin_z) return;
			self.jumptouch = world;		// Reset last object touched
			self.count = 0;				// Number of times jumped
			self.attack_state = AS_JUMP;
		}
	}
};

void() VorelingCheckAttack = {
	// Melee attack (BITE).  Check that within range of a bite attack
	if (ai_checkmelee(MONAI_MELEEVORELING,FALSE)) {
		self.attack_state = AS_MELEE;
		return;
	}

	// Range attack (Large Purple Voreling = SPIT).  Behaves like a wizards; strafe, spit goo
	if (self.spawnflags & MON_VORELING_LARGE) {
		if (!enemy_vis) return;
		if (time < self.attack_finished) return;

		// Does the monster have a clear shot to the player? sightline can be blocked by other monsters
		if (enemy_range == RANGE_FAR || visblocked(self.enemy)) {
			if (self.attack_state != AS_STRAIGHT) {
				self.attack_state = AS_STRAIGHT;
				self.th_run ();
			}
			return;
		}

		if (enemy_range == RANGE_MELEE) self.attack_chance = 0.9;		// range < 120 map units
		else if (enemy_range == RANGE_NEAR) self.attack_chance = 0.6;	// range < 500 map units
		else if (enemy_range == RANGE_MID) self.attack_chance = 0.2;	// range < 1000 map units
		else self.attack_chance = 0;
		if (random () < self.attack_chance) {
			SUB_AttackFinished (2 + random());
			self.attack_state = AS_MISSILE;
		} else if (enemy_range == RANGE_MID) {
			if (self.attack_state != AS_STRAIGHT) {
				self.attack_state = AS_STRAIGHT;
				self.th_run ();
			}
		} else {
			if (self.attack_state != AS_SLIDING) {
				self.attack_state = AS_SLIDING;
				self.th_slide ();
			}
		}
	} else {
		// Range attack (Small White Voreling = JUMP).  Behaves like a dog; run and jump.  Is it time to jump?
		if (self.jump_flag < time) {
			// Stop the voreling over or under jumping the enemy
			if (self.origin_z + self.mins_z > self.enemy.origin_z + self.enemy.mins_z + 0.75 * self.enemy.size_z) return;
			if (self.origin_z + self.maxs_z < self.enemy.origin_z + self.enemy.mins_z + 0.25 * self.enemy.size_z) return;	
			
			self.enemydist = range_distance(self.enemy, TRUE); // Too close/far?
			if (self.enemydist < self.jumprange_x) return;
			if (self.enemydist > self.jumprange_y) return;
			// Check for enemy above? (z axis)
			if (self.enemy.origin_z > self.origin_z) return;
			self.jumptouch = world;			// Reset last object touched
			self.count = 0;					// Number of times jumped
			self.attack_state = AS_JUMP;
		}
	}
};

void() SwamplingCheckAttack = {
	// Melee attack (BITE).  Check that within range of a bite attack
	if (ai_checkmelee(MONAI_MELEESWAMPLING,FALSE)) {
		self.attack_state = AS_MELEE;
		return;
	}

	// Range attack (Large Green Swampling = SPIT).   Behaves like a wizards; strafe, spit goo
	if (self.spawnflags & MON_SWAMPLING_LARGE) {
		if (!enemy_vis) return;
		if (time < self.attack_finished) return;

		// Does the monster have a clear shot to the player? sightline can be blocked by other monsters
		if (enemy_range == RANGE_FAR || visblocked(self.enemy)) {
			if (self.attack_state != AS_STRAIGHT) {
				self.attack_state = AS_STRAIGHT;
				self.th_run ();
			}
			return;
		}

		if (enemy_range == RANGE_MELEE) self.attack_chance = 0.9;		// range < 120 map units
		else if (enemy_range == RANGE_NEAR) self.attack_chance = 0.6;	// range < 500 map units
		else if (enemy_range == RANGE_MID) self.attack_chance = 0.2;	// range < 1000 map units
		else self.attack_chance = 0;
		if (random () < self.attack_chance) {
			SUB_AttackFinished (2 + random());
			self.attack_state = AS_MISSILE;
		} else if (enemy_range == RANGE_MID) {
			if (self.attack_state != AS_STRAIGHT) {
				self.attack_state = AS_STRAIGHT;
				self.th_run ();
			}
		} else {
			if (self.attack_state != AS_SLIDING) {
				self.attack_state = AS_SLIDING;
				self.th_slide ();
			}
		}
	} else {
		// Range attack (Small Light Green Swampling = JUMP).  Behaves like a dog; run and jump.  Is it time to jump?
		if (self.jump_flag < time) {
			// Stop the swampling over or under jumping the enemy
			if (self.origin_z + self.mins_z > self.enemy.origin_z + self.enemy.mins_z
			+ 0.75 * self.enemy.size_z) return;
			if (self.origin_z + self.maxs_z < self.enemy.origin_z + self.enemy.mins_z
			+ 0.25 * self.enemy.size_z) return;
				
			// Too close/far?
			self.enemydist = range_distance(self.enemy, TRUE);
			if (self.enemydist < self.jumprange_x) return;
			if (self.enemydist > self.jumprange_y) return;
			// Check for enemy above? (z axis)
			if (self.enemy.origin_z > self.origin_z) return;
			self.jumptouch = world;			// Reset last object touched
			self.count = 0;					// Number of times jumped
			self.attack_state = AS_JUMP;
		}
	}
};

void () LavaManCheckAttack = {
   if (!visblocked_wide(SUB_entEnemyTarget(), self.attack_offset,'0 0 0')) return;
   if (time < self.attack_finished) return;

   self.attack_state = AS_MISSILE;
   SUB_AttackFinished ((random()));
};

void () GremlinCheckAttack = {
   local vector spot1, spot2;
   local entity targ;

   targ = self.enemy;
   if ((time < self.attack_finished)) return;

   spot1 = self.origin;
   spot2 = targ.origin;
   if ( ((vlen ((spot2 - spot1)) <= 90.000) && (self.stoleweapon == FALSE)) ) {
      self.attack_state = AS_MELEE;
      return;
   }

   if (self.stoleweapon) {
      self.attack_state = AS_MISSILE;
      return;
   }
   return;
};

void() DragonCheckAttack = {
    local   vector  spot1, spot2;
    local   entity  targ;
    local   float   nofire, chance, reach;

    // Check if the dragon has a breath weapon.
    if (self.th_missile)
        nofire = FALSE;
    else
        nofire = TRUE;

    // Check if dragon can see the target.
    targ = self.enemy;
    spot1 = self.origin + self.view_ofs;
    spot2 = targ.origin + targ.view_ofs;
    chance = 1;     // Melee attack enabled.
    traceline (spot1, spot2, FALSE, self);
    if (trace_ent != targ) {
        // Could not see the target.
        if (trace_fraction < 1) {   // Blocked by obstacle.  If blocked by monster, flag it so
            targ = trace_ent; // dragon may try to move around it vertically.
			if (targ) {
				if (targ.solid == SOLID_SLIDEBOX) {
					if (targ.health > 0) self.attack_state = AS_SLIDING;
				}
			}
			if (!(targ.flags & FLx_CREATURE) || self.enemy.solid <= SOLID_TRIGGER || Align_Match(self,targ) || targ.enemy == self || targ == self.oldenemy) return FALSE;
			// Whoever blocked the way is an enemy too, so continue the check.
            chance = 0;     // Disable melee this time.
            targ = self.enemy;
        } else {
			// Target is non-solid.  (e.g., downed zombies, nightshade.)
            // Dragon can try to engage it in melee, provided the target is
            // vulnerable to damage.  Don't use missile attack because it
            // will pass through the enemy harmlessly.

            if (!targ.takedamage) return;

            if (self.ryuflags & RYU_ELEMENTS != RYU_USE_LITE) nofire = TRUE;
        }
    }

    // If target is reachable within melee range, the dragon will attack the target if the dragon has a melee attack.
    if (enemy_range == RANGE_MELEE)
        if (chance)
            if (self.th_melee)
                if (CanDamage (targ, self)) { self.attack_state = AS_MELEE; return ; }

	// Missile attack, Check if the dragon can shoot.
    if (nofire) { self.attack_state = AS_STRAIGHT; return; }
    if (Ryu_NoShot (self)) return;
    if (time < self.attack_finished) return; // Check if allowed to attack.

	// Determine the chance that the dragon will use its breath weapon.
    if (enemy_range == RANGE_MELEE) { // Any dragon will almost certainly attack within melee range.
        self.attack_finished = 0;
        chance = 0.9;
    } else if (enemy_range == RANGE_NEAR) { // Short range (120-500)
        chance = 0.2;
    } else {
        reach = RYU_RANGE_MAX;
        if (vlen(spot2 - spot1) > reach) { // Target is outside of attack range.
            self.attack_state = AS_STRAIGHT;
            return;
        }
        if (enemy_range == RANGE_MID)
            chance = 0.1;   // Medium range (500-1000)
        else
            chance = 0.02;  // Long range (1000+)
    }

	// The dragon decides whether to attack or move on.
    if (random () < chance) {
        SUB_AttackFinished ((random() * 2 + 1));   // Reversed in custom 'ai.qc' too.
        self.th_missile ();
        return;
    } // move on
};

void() Shade_CheckAttack = {
    local   vector  spot1, spot2;
    local   entity  targ;
    local   float   chance, pause;

    if (enemy_range > RANGE_MID) {
		// Nightshade cannot attack from long range (1000+).
        self.attack_state = AS_STRAIGHT;    // Don't fly too far away.
        return;
    }

    targ = self.enemy;
    spot1 = self.origin + self.view_ofs;
    spot2 = targ.origin + targ.view_ofs;

    // Check if attack is blocked by creature.
    // If so, flag it so dragon may try to move around it vertically.
    traceline (spot1, spot2, FALSE, self);
    if ((trace_ent != targ) && (trace_fraction < 1)) {
        targ = trace_ent;
        if (targ)
            if (targ.solid == SOLID_SLIDEBOX)
                if (targ.health)
                    self.attack_state = AS_SLIDING;

        return;
    }

    // If target is reachable within melee range, so attack if possible.
	if ((enemy_range == RANGE_MELEE) && (self.th_melee) && CanDamage (targ, self)) { self.attack_state = AS_MELEE; return; }

    // Check if nightshade can shoot missile attack
    if (!self.th_missile) {
        self.attack_state = AS_STRAIGHT;
        return;
    }
        
    // Check if allowed to attack.
    if (time < self.attack_finished) return;

    // Determine the chance that the nightshade will attack.
    if (enemy_range == RANGE_MELEE) {self.attack_finished = 0; chance = 0.9;}
    else if (enemy_range == RANGE_NEAR) // Short range (120-500)
        chance = 0.2;
    else
        chance = 0.05;

    if (random () < chance) {
        self.th_missile ();
        pause = random() * 2 + 1;
        SUB_AttackFinished (pause);
        return;
    } // If the function made it this far, the nightshade moves on.
};

void() ArcherCheckAttack = {
    local float chance;

    if (enemy_range == RANGE_FAR) return; // Don't call traceline again when we don't need to.
    if (!archer_check_shot ()) return;
    if (time < self.attack_finished) return;

    if (enemy_range == RANGE_MELEE) {
        chance = 0.9;
        self.attack_finished = 0;
    } else if (enemy_range == RANGE_NEAR) chance = 0.4;
    else if (enemy_range == RANGE_MID) chance = 0.1;
    else chance = 0.04;

    if (random () < chance) {
        chance = 2*random();
        self.th_missile ();
        SUB_AttackFinished (chance);
        return;
    }
};

float() ArmagonCheckAttack = {
   local vector spot1, spot2;
   local entity targ;
   local float ang, delta, dist;

   self.lefty = FALSE;
   targ = self.enemy;
   spot1 = (self.origin + self.view_ofs);
   spot2 = (targ.origin + targ.view_ofs);
   traceline (spot1,spot2,FALSE,self);
   if (trace_ent != targ && !self.charmed) return (FALSE);
   if (trace_inopen && trace_inwater) return (FALSE);
   if (time < self.attack_finished) return (FALSE);

   ang = (self.angles_y + self.fixangle);
   delta = (self.ideal_yaw - ang);
   dist = vlen ((spot2 - spot1));
   if (((fabs(delta) > MOVETYPE_BOUNCE) && dist > 200) || (self.enemy.classname != "player")) return ( FALSE );
   if (dist < 400.000) { self.th_melee (); return ( TRUE ); }
   self.lefty = TRUE;
   return FALSE;
};

// Only used on skill 2 and above for specialty bosses
void() BaronBossCheckAttack = {
    local float r;

	// If target is not in LOS, use an attack that doesn't care about line-of-fire.  This will harass a player that tries to hide and spam grenades from a safe spot.
    if ((enemy_range <= RANGE_MID) && (time >= self.attack_finished) && (self.waitmax < time) && (random() < 0.01)) { // Use only after a delay.
        r = random();
        if (self.level == BARON_FIRE) {
            baron_cast1 ();
        } else if (self.level == BARON_EARTH) {
            if ((r < 0.5) && !super_active && Grounded (self.enemy)) baron_slam1();
            else if (BaronGolem_Check ()) baron_cast1();
            else return;
        } else if (self.level == BARON_AIR) {
            if (UpIsSky (self.enemy.origin)) {
                if ((r < 0.5) && !super_active)
                    baron_slam1();
                else
                    baron_cast1();
            } else if (!super_active)
                baron_slam1();
            else return;
        } else if (self.level == BARON_WATER) {
            if ((r < 0.5) && !super_active)
                baron_cast1();
            else
                baron_slam1();
        } else return;
        SUB_AttackFinished (2*r);
        return;
    }
};

void() EidolonCheckAttack = {
	local float currentdist;

	if (eidolon_WaveCheck() == TRUE) return; // Check for boss wave trigger events

	// Check the tether system
	currentdist = vlen(self.origin - self.movelast.origin);
	if (currentdist > self.tetherrange) { // Is the boss at maximum range?
		// Can the boss see the player?
		if (enemy_vis) {
			self.attack_state = AS_MELEE;
		} else {
			// At max range + cannot see player, exit combat
			self.enemytarget = self.enemy;
			self.enemy = world;
			self.goalentity = self.movetarget = self.movelast;
			self.attack_state = AS_STRAIGHT;
			self.think = self.th_walk;
		}
		return;
	}

	// Check Melee range and constantly fire
	if (self.enemydist < MONAI_CLOSEEIDO) { self.attack_state = AS_MELEE; return; }

	// Range attacks (Boulder + Rock Storm).  Only range attack if cooldown has finished
	if (time > self.attack_finished) {
		// Intense rock storm attack
		if (self.enemydist < MONAI_MEDIUMEIDO && random() < 0.75) {
			// Skill 0=3s, 1=2.25s, 2=1.5s, 3=0.75s
			self.attack_speed = (4 - skill) * 0.75;
			self.attack_finished = time + self.attack_speed + random();
			self.attack_state = AS_MELEE;
			return;
		} else {
			// Large boulder attack.  Skill 0=4s, 1=3s, 2=2s, 3=1s
			self.attack_speed = (4 - skill) * 1;
			self.attack_finished = time + self.attack_speed + random();
			self.attack_state = AS_MISSILE;
			return;
		}
	}
};

void() IcegCheckAttack = {
	// Check Melee range and constantly fire
	if (self.enemydist < MONAI_MELEEICEG) {
		self.attack_finished = time + 1;
		self.attack_state = AS_MELEE;
		return;
	}
	
	if (time < self.attack_finished) return; // Walk around a bit

	// Floor stomp attack
	if (self.enemydist < MONAI_STOMPICEG && random() < 0.5) {
		self.attack_finished = time + ((4-skill)*0.5) + random() + random();
		self.th_slide ();
		return;
	}

	if (!enemy_vis) return; // Range attacks (O Rings + Ceiling Rubble)
	
	// Does the monster have a clear shot to the player? sightline can be blocked by other monsters
	if (!visblocked_wide(self.enemy, self.attack_offset, self.enemy.view_ofs)) {
		self.attack_finished = time + ((4-skill)*0.6) + random() + random();
		self.attack_state = AS_MISSILE;
	}
};

void() JudgeCheckAttack = {
	// Special melee attack for monster infighting
	if (self.enemy.flags & FL_MONSTER) {
		// If monster outside of melee range, blast them with range
		if (self.enemydist > self.meleerange) self.attack_state = AS_MISSILE;
		else self.attack_state = AS_MELEE;
		return;
	}

	// Check for Blast Belt and create random chance of detecting it
	if (self.enemy.flags & FL_CLIENT && self.enemy.moditems & IT_ARTBLASTBELT) self.attack_chance = random();
	else self.attack_chance = 0;
	
	if (self.enemydist < MONAI_MELEEJUDGE && self.attack_chance < 0.5) { self.attack_state = AS_MELEE; return; } // Melee attack (Special fist ground smash)
	if (!enemy_vis) return; // Can see the enemy?
	if (visblocked(self.enemy)) return; // Does the monster have a clear shot to the player?
	
	// Mid Range attack (JUMP)
	// Jumped recently, facing right direction and not blocked?
	if ( self.jump_flag < time && infront(self.enemy) ) {
		if (self.enemy.origin_z <= self.origin_z) { // Check for enemy above? (z axis)
			if (self.enemydist > self.jumprange_x && self.enemydist < self.jumprange_y) { // Is the judge within the right range?
				SUB_AttackFinished (random()); // Block any range attacks for a while
				self.jumptouch = world;		// Reset last object touched
				self.count = 0;				// Number of times jumped
				self.th_jump ();
				return;
			}
		}
	}

	// Range attack (Spikes or Flames)
	if (time < self.attack_finished) return;
	self.attack_state = AS_MISSILE;
	SUB_AttackFinished (2 + random());
};

void() LfiendCheckAttack = {
	if (self.enemydist < MONAI_MELEELFIEND) { self.attack_state = AS_MELEE; return; } // Check Melee range and start clawing at the player

	// Range attacks (Fireballs, Giant Spheres and Firestorms).  Only range attack if cooldown has finished
	if (time > self.attack_finished) {
		// Quick fireball attacks
		if (self.enemydist < MONAI_CLOSELFIEND && random() < 0.75) {
			// Skill 0=3s, 1=2.25s, 2=1.5s, 3=0.75s
			self.attack_speed = (4 - skill) * 0.75;
			self.attack_finished = time + self.attack_speed + random();
			self.attack_state = AS_MISSILE;
			return;
		} else {
			// Summon giant sphere of Doom!
			// Skill 0=4s, 1=3s, 2=2s, 3=1s
			self.attack_speed = (4 - skill) * 1;
			self.attack_finished = time + self.attack_speed + random();
			self.attack_state = AS_JUMP;
			return;
		}
	}
};

void() mammothCheckAttack = {
	local vector armorg, eorg;

	if (mammoth_WaveCheck() == TRUE) return; // Check for boss wave trigger events

	// setup enemytarget if one is not active
	if (self.enemy.classtype != CT_ENEMYTARGET) {
		if (SUB_setupEnemyTarget(self.enemy, self.height, MONAI_ABOVETIMER)) {
			self.enemy = self.enemytarget;
		}
	}

	// Melee attack (Dumping fire on to player/floor), this has always got to be available, no cooldown
	// Flatten distance checks, the mammoth is constantly flying
	self.enemydist = range_distance(SUB_entEnemyTarget(), TRUE);
	// Any sprite space left for hazard projectiles? (def=14 frames)
	// There is no skill difference with the fire/dump attack
	if (HazardProjectile_CheckLimit(self, self.proj_attqty_z)) {
		if (self.enemydist < MONAI_MELEEMAMMOTH) {
			self.attack_state = AS_MELEE;
			return;
		}
	}
	
	// Mammoth is a very wide and needs more visibility checks, especially for the arms during phase 1 & 2.
	self.attack_sidedeny = FALSE; // Phase 3 = central attacks, front and top only
	if (!enemy_vis) {
		eorg = self.enemy.origin + self.enemy.view_ofs; // Work out enemy origin + vertical offset
		makevectors(self.angles);
		if (self.style == MM_PHASE3) armorg = self.origin + attack_vector('30 24 46'); // Phase 3 has no arms, use left/right side of body instead
		else armorg = self.origin + attack_vector('30 38 46');

		traceline (armorg, eorg, TRUE, self);
		if (trace_fraction == 1) { 
			enemy_vis = TRUE;
		} else {
			// first arm was blocked, try second instead
			if (self.style == MM_PHASE3) armorg = self.origin + attack_vector('30 -24 46');
			else armorg = self.origin + attack_vector('30 -38 46');

			traceline (armorg, eorg, TRUE, self);
			if (trace_fraction == 1) enemy_vis = TRUE;
		}
		if (enemy_vis) self.attack_sidedeny = TRUE; // Partly blocked, so use agressive attack instead
	}
	
	// Range attacks (Laser, Rockets, Arc and Grenades) if cooldown has finished and can see enemy
	if (self.attack_finished < time && enemy_vis) {
		// Is the enemy close enough for attack? If the mammoth at maximum tether range, keep firing!
		if (mammoth_CheckTether() || self.enemydist < MONAI_RANGEMAMMOTH) {
			SUB_AttackFinished(2 + random());
			self.attack_state = AS_MISSILE;
			return;
		}
	}

	if (mammoth_CheckTether()) return; // Don't strafe if at max tether range

	// Maintain distance (strafe)
	if (enemy_range >= RANGE_MID || !enemy_vis) {
		if (self.attack_state != AS_STRAIGHT) self.attack_state = AS_STRAIGHT;
	}
	else self.attack_state = AS_SLIDING;
};

void() NourCheckAttack = {
	// setup enemytarget if one is not active
	if (self.enemy.classtype != CT_ENEMYTARGET) {
		if (SUB_setupEnemyTarget(self.enemy, self.height, MONAI_ABOVETIMER)) {
			self.enemy = self.enemytarget;
		}
	}

	// Check Melee range and constantly fire
	if (self.enemydist < MONAI_MELEENOUR) {
		self.attack_state = AS_MELEE;
		return;
	}
	
	// Range attacks (Spit and Bomb).  Attack_chance override (percentage 0-1 chance)
	// Only range attack if cooldown has finished
	if (time > self.attack_finished) {
		// Fast/intense nail/spit attack
		if (self.enemydist < MONAI_CLOSENOUR || self.attack_chance > random()) {
			// Skill 0=3s, 1=2.25s, 2=1.5s, 3=0.75s
			self.attack_speed = (4 - skill) * 0.75;
			self.attack_finished = time + self.attack_speed + random();
			self.attack_state = AS_MELEE;
			return;
		} else {
			// Large rocket bomb attack with floor damage.  Skill 0=4s, 1=3s, 2=2s, 3=1s
			self.attack_speed = (4 - skill) * 1;
			self.attack_finished = time + self.attack_speed + random();
			self.attack_state = AS_MISSILE;
			return;
		}
	}

	// Maintain distance (strafe)
	if (enemy_range >= RANGE_MID || !enemy_vis) {
		if (self.attack_state != AS_STRAIGHT) self.attack_state = AS_STRAIGHT;
	}
	else self.attack_state = AS_SLIDING;
};

void() DGuardCheckAttack = {
	local vector spot1, spot2;
	local entity targ;
	local float chance, dgdist;

	targ = self.enemy;
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;
	traceline(spot1, spot2, 0, self);
	if (trace_ent != targ) return;
	if (trace_inopen && trace_inwater) return;

	dgdist = vlen(self.enemy.origin - self.origin);
	if (dgdist < 100) {
		self.th_melee();
		return;
	} else {
		if (dgdist < 190 && dgdist > 140) { deathguard_charge1(); return; }
	}
	if (time < self.attack_finished) return;
	if (enemy_range == RANGE_FAR) return;
	if (dgdist < 300) return;

	if (dgdist >= 300) chance = 0.5;
	if (random() < chance) {
		self.th_missile();
		SUB_AttackFinished(1.4 * random() + 0.8);
		return;
	}
};

void() FragCheckAttack = {
	if (enemy_range == RANGE_MELEE) { self.attack_state = AS_MELEE; return; } // if close enough for slashing, go for it
	if (CheckFragJump ()) {self.attack_state = AS_MISSILE; return; }
};

void() InquisitorCheckAttack = {
	local float rnd, dist;

	dist = vlen(self.enemy.origin - self.origin);
	if (dist <= 350) { inquisitor_magica1(); return; } // Staff plant storm cloud, especially if within Mjolnir range

	rnd = random() * 100;
	
	if (rnd < 25)
		inquisitor_magica1(); // Staff plant storm cloud
	else if (rnd < 50)
		inquisitor_magicb1();
	else if (rnd < 75)
		inquisitor_magicc1();
	else {
		// Can't see the enemy?
		if ((!enemy_vis || visblocked(self.enemy)) || random() < 0.2)
			inquisitor_magicd1(); // Bile bomb at enemy's feet when we can't see them
		else
			inquisitor_magicb1(); // Bone attack
	}
};

void() RavenCheckAttack = {
	// Hitscan attack (Claw/Bite).  Uses larger range then attack completes after closer distance check
	if (!enemy_vis) return; // Cannot see enemy? stop chasing enemytarget
	if (time < self.attack_finished) return;
	if (self.enemydist > MONAI_RANGERAVEN) return;
	
	// Does the monster have a clear shot to the player? sightline can be blocked by other monsters
	if (visblocked(self.enemy)) return;
	
	self.attack_state = AS_MISSILE;
	self.th_missile ();
	return;
};

void() SGruntCheckAttack = {
	local vector spot1, spot2;
	local float	r;

	spot1 = self.origin + self.view_ofs;
	spot2 = self.enemy.origin + self.enemy.view_ofs;
	if (enemy_range == RANGE_MELEE) {
		r = vlen(spot1 - spot2);
		if (r < 80) { // needs to be really close
			if (CanDamage (self.enemy, self)) {
				self.attack_state = AS_MELEE;
				return;
			}
		}
	}

	if (time < self.attack_finished) return;
	if (!visible(self.enemy)) return;
	if (enemy_range == RANGE_FAR) return;	

	self.attack_state = AS_MISSILE;
	SUB_AttackFinished (3 + 3*random());
};