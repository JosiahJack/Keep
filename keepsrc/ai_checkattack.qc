//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
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
// Function count: 75
//
// Implements: Check routines for monsters to decide when and which attacks
//
// Description:
// Specific routines for certain monster types to determine if they can melee 
// or missile (range) attack.  Always working 1 frame behind the ai_run
// function. Moved all checkattack routines here (previously inside each
// monster file).
//
// Why on earth are there so many check attack functions???
//=============================================================================

float() archer_check_shot;
void() baron_cast1;
void() baron_slam1;
float() BaronGolem_Check;
float(entity ent) QuakeHurts;
float(vector org, entity ignore) UpIsSky;
void() dcrossbow_stop1;
void() dcrossbow_fire1;
void() dcrossbow_slide1;
void() dcrossbow_ready1;
void() dcrossbow_melee;
void() deathguard_charge1;
float()	CheckFragJump;
void() gaunt_run1;
void() gaunt_side1;
void() inquisitor_magica1;
void() inquisitor_magicb1;
void() inquisitor_magicc1;
void() inquisitor_magicd1;
void() mcorn_atkb1;
float(vector waveqty) SpriteCount_Flame;
float(entity targ, float maxextra) HazardProjectile_CheckLimit;
void() dfury_boss_char_a1;
void() dfury_boss_run1;
void() hknight_char_b1;

float() IsSoldier = {
	return (self.classtype == CT_MONARMY
	         || self.classtype == CT_MONDRAKEGOBLIN
             || self.classtype == CT_MONBANDIT
		     || self.classtype == CT_MONREBEL
		     || self.classtype == CT_MONARMYGRENADE
		     || self.classtype == CT_MONARMYPLASMA
		     || self.classtype == CT_MONARMYSPIKE
		     || self.classtype == CT_MONARMYDBSHOTGUN
			 || self.classtype == CT_MONARMYROCKET);
};

float() IsShortHopper = {
	return (self.classtype == CT_MONJUDGE
	         || self.classtype == CT_MONHUNTRESS
             || self.classtype == CT_MONMINOTAUR
		     || self.classtype == CT_MONDFURY
		     || self.classtype == CT_MONJUSTICE
		     || self.classtype == CT_MONSCORPION
		     || self.classtype == CT_MINIONSCORPION
		     || self.classtype == CT_MONSTEELCLAW);
};

float() IsStrafeFlyer = {
	return (self.classtype == CT_MONCENTURION
	         || self.classtype == CT_MONGARGOYLE
             || self.classtype == CT_MINIONGARGOYLE
		     || self.classtype == CT_MONGARGOYLE_MINI
		     || self.classtype == CT_MONGAUNT
		     || self.classtype == CT_MINIONGAUNT
		     || self.classtype == CT_MONJIM
		     || self.classtype == CT_MONJIMROCKET
			 || self.classtype == CT_MONWIZBOSS
			 || self.classtype == CT_MONDRAKE
			 || self.classtype == CT_MINIONWIZARD
			 || self.classtype == CT_MONWIZARD
			 || self.classtype == CT_MONWRAITH);
};

void(float melee, float near, float mid) SetSelfAttackChances = {
	if (enemy_range == RANGE_MELEE) self.attack_chance = melee;		// range < 120 map units
	else if (enemy_range == RANGE_NEAR) self.attack_chance = near;	// range < 500 map units
	else if (enemy_range == RANGE_MID) self.attack_chance = mid;	// range < 1000 map units
	else self.attack_chance = 0;
};

void() JumpTouchReset = {
	self.jumptouch = world; // Reset last object touched.
	self.count = 0;	// Reset number of times jumped.
};

float() JumpAttackValid = {
	local vector ycheck;

	if (self.jump_flag >= time) return FALSE;
	if (!self.th_jump) return FALSE;
	if (self.classtype == CT_MONJUDGE || self.classtype == CT_MONHUNTRESS
        || self.classtype == CT_MONMANTICORE || self.classtype == CT_MONDFURY
		|| self.classtype == CT_MONMINOTAUR || self.classtype == CT_MONJUSTICE) {
		if (!infront(self.enemy)) return FALSE;
	}
	if (self.classtype == CT_MONHUNTRESS || self.classtype == CT_MONMANTICORE
		|| self.classtype == CT_MONDFURY || self.classtype == CT_MONJUSTICE) {
		if (visblocked(self.enemy)) return FALSE;
	}

	if (self.classtype == CT_MONMINOTAUR) {
		if (visblocked_wide(self.enemy,self.view_ofs,self.enemy.view_ofs)) {
			return FALSE;
		}
	}

	self.enemydist = range_distance(self.enemy, TRUE); // Too close/far?
	if (IsShortHopper()) { // Simpler hop check
		if (self.classtype != CT_MONSCORPION
			&& self.classtype != CT_MINIONSCORPION
			&& self.classtype != CT_MONSTEELCLAW
			&& self.enemy.origin_z > self.origin_z) return FALSE; // This is different than if IsShortHopper failed.
		if (self.enemydist <= self.jumprange_x) return FALSE;
		if (self.enemydist >= self.jumprange_y) return FALSE;
	} else { // Longer lunge checks
		if (self.origin_z + self.mins_z > self.enemy.origin_z + self.enemy.mins_z
			+ 0.75 * self.enemy.size_z) return FALSE; // Stop over jumping the enemy.
		if (self.origin_z + self.maxs_z < self.enemy.origin_z + self.enemy.mins_z
			+ 0.25 * self.enemy.size_z) return FALSE; // Stop under jumping the enemy.	
		if (self.enemydist < self.jumprange_x) return FALSE;
		if (self.classtype == CT_MONDOG
			&& self.enemydist > self.jumprange_y) return FALSE;

		// Check for low ceilings directly above the demon
		ycheck = '0 0 56';
		ycheck_z = ycheck_z + self.jumprange_y;
		traceline(self.origin, self.origin + ycheck, TRUE, self);
		self.height = fabs(vlen(trace_endpos - self.origin));
		// Ceiling is too low (looks dumb hitting ceilings)
		if (self.classtype != CT_MONDOG
			&& self.height < self.jumprange_z) return FALSE;
		else if (self.height < 80) return FALSE;

		// ** From necros **  Move self forward 16 units and check if blocked.
		self.pos1 = self.origin;
		self.ideal_yaw = vectoyaw(self.enemy.origin - self.pos1);
		// If move forward fails, move back and indicate no jump
		if (!walkmove(self.ideal_yaw, 16)) {
			setorigin(self, self.pos1);
			return FALSE;
		}
		
		setorigin(self, self.pos1);	// walkmove successful, move back.
		if ((self.classtype == CT_MONDOG || self.classtype == CT_MONHELLHOUND)
			&& self.enemy.origin_z > self.origin_z) return FALSE; // Check height.
	}
	return TRUE;
};

float(float attTime) TurretMode = {
	// If setup to be a turret, check range attack only
	if (self.movespeed >= 0) return FALSE;
	if (time < self.attack_finished) return FALSE;
	if (self.classtype != CT_MONSHAL) {
		if (IsStrafeFlyer() || self.classtype == CT_MONSWEEPER
			|| self.classtype == CT_MONSENTINEL) {
			if (visblocked_wide(SUB_entEnemyTarget(),self.attack_offset,'0 0 0')) {
				return FALSE;
			}
		} else if (self.classtype == CT_MONDFURY
				   || self.classtype == CT_MONDSERG
				   || self.classtype == CT_MONDCROSS) {
			if (!visxray(self,self.enemy,self.attack_offset,'0 0 10',FALSE)) {
				return FALSE;
			}
		} else {
			if (visblocked(self.enemy)) return FALSE;
		}
	}

	if (attTime > 0) SUB_AttackFinished (2 + random());
	self.attack_state = AS_MISSILE;
	return TRUE;
}

float(float attTime) StandardVisCheckFailed = {
	if (TurretMode(attTime)) return TRUE; // Range attack only for turret.
	if (!enemy_vis) return TRUE;
	if (time < self.attack_finished) return TRUE;
	if (visblocked(self.enemy)) return TRUE; // Does the monster have a clear shot to the player? sightline can be blocked by other monsters
	if (enemy_range == RANGE_FAR && !self.attack_sniper
		&& self.minion_name == "") return TRUE; // No reason not to spawn 'em.
	return FALSE;
};

void() CheckAttack = { // [FUNCTION]
	local float tevis;

	if  (IsSoldier()) {
		if (TurretMode(2 + random())) return; // Range attack only for turret.

		// If enemy is within melee range, just keep on attacking!
		// Original ID behaviour is 10% chance to not attack in melee range
		// This has changed so that the soldier is more agressive up close
		// The army rocket has a special behaviour for melee range
		if (self.classtype != CT_MONARMYROCKET && enemy_range == RANGE_MELEE) {
			self.attack_state = AS_MISSILE;
			return;
		}
	}
	// Does the monster have a clear shot?  Sightline can be blocked by monsters
	// Ghosts can presumably see through walls.
	if (visblocked(self.enemy) && !IsGhost(self)) return;  

	// Melee attack
	// enemy_range is checked before this function (ai_run - ai.qc)
	// If the monster is within melee range they instantly attack
	if (ai_checkmelee(self.meleerange,self.meleerangez) && self.th_melee) {
		self.attack_state = AS_MELEE;
		self.th_melee();
		return;
	}

	tevis = enemy_vis;
	enemy_vis = TRUE;
	if (StandardVisCheckFailed(2 + random())) return;
	enemy_vis = tevis;
	if (!self.th_missile) return;

	// Range attack.  The attack chances are constant across skill levels.
	if (self.th_melee) SetSelfAttackChances(0.9,0.2,0.05);
	else SetSelfAttackChances(0.9,0.4,0.1);
	
	if (enemy_range == RANGE_MELEE) self.attack_finished = 0;
	if (random () < self.attack_chance) {
		SUB_AttackFinished (2*random());
		self.th_missile();
	}
};

// Rocket version has melee
void() SoldierCheckAttack = {
	if (TurretMode(2 + random())) return; // Range attack only for turret.

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

	if (self.classtype == CT_MONARMYROCKET) {
		if (ai_checkmelee(MONAI_RANGEARMYR,FALSE)) {
			self.oldorigin = self.origin;
			// If move backward works, run back animation
			if (walkmove(self.angles_y+180, 16)) {
				setorigin(self, self.oldorigin);
				self.attack_state = AS_MELEE;
				self.th_melee();
				return;
			} else setorigin(self, self.oldorigin);
		}
	}

	// Range attack (bullets)
	if (time < self.attack_finished) return;
	if (enemy_range == RANGE_FAR) return;

	SetSelfAttackChances(0.9,0.4,0.05);
	if (random () < self.attack_chance) {
		self.attack_state = AS_MISSILE;
		if (self.classtype == CT_MONARMYROCKET) SUB_AttackFinished (2 + random());
		else SUB_AttackFinished (1 + random());
		if (random() < 0.3) self.lefty = !self.lefty;
	}
};

// Death Knight charge.
void() CheckForCharge = {
	// There are 4 conditions to keep charging
	// Can see player, no attack timer, similar Z axis and outside melee range
	// Nightmare skill level can lock HK in constant charging (no attack timer)
	enemy_vis = visible(self.enemy);
	if (!enemy_vis) return;
	if (time < self.attack_finished) return;
	if (self.movespeed < 0) return;
	if (self.tetherlock) return;
	// Only charge at player if ground height < 20
	if ( fabs(self.origin_z - self.enemy.origin_z) > MONAI_CHARGEZAXIS) return;
	if (ai_checkmelee(MONAI_MELEEKNIGHT,FALSE)) return;

    if (self.classname == "monster_hkboss") {
		// Emulate old behavior.
        self.shots_left = 3;    // Replaced 'currentammo' with 'shots_*'.
        hknight_char_b1();
        return;
    }

	SUB_AttackFinished (2);
	
	// Used a pre-defined charge routine (th_charge) so that hell and death knights can share the same function
	if (self.th_charge) self.th_charge();
	else self.th_run();
};

// Knight continue charge
void() CheckContinueCharge = {
	if (self.movespeed < 0) return;
	if (self.tetherlock) return;

	if (time > self.attack_finished) {
		SUB_AttackFinished (3);
		self.th_run();
		return;	// done charging
	}
};

// Melee=FIRE!
void() PyroCheckAttack = {
	// Does the monster have a clear shot to the player? sightline can be blocked by other monsters
	if (visblocked(self.enemy)) return;

	if (ai_checkmelee(MONAI_RANGEPYRO,FALSE)) {
		self.attack_state = AS_MELEE;
		self.th_melee();
		return;
	}
};

void() ShamCheckAttack = {
	// Melee attack(claws/overhead smash)
	if (ai_checkmelee(MONAI_MELEESHAM,MONAI_MELEEZTALL)) {
		self.attack_state = AS_MELEE;
		self.th_melee(); // Don't wait for next frame, melee attack straight away (different id behaviour)
		return;
	}

	if (self.enemydist > MONAI_SHAMRANGE && !self.attack_sniper && self.classtype != CT_MONSHAMVILE) return;
	if (StandardVisCheckFailed(1 + 2 * random())) return;

	SUB_AttackFinished(2 + (2*random()));
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
				self.th_melee();
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
		else { self.attack_state = AS_MELEE; self.th_melee(); }
		return;
	}

	if (StandardVisCheckFailed(1 + 2 * random())) return;

	// Setup attack chance of using fast bolt attack more often
	// easy=0.0, norm=0.2, hard=0.4, nm=0.6
	// The stronger version is just pure random 50/50
	if (self.spawnflags & MON_BOGL_STRONG) self.attack_chance = random();
	else self.attack_chance = 0.0 + (skill * 0.2);

	if (!self.tethered) SUB_AttackFinished(1 + 2*random());
	if (random() > self.attack_chance) { // Random chance of overhead smash.
		self.attack_state = AS_MELEE;
		self.th_melee();
	} else self.attack_state = AS_MISSILE; // Range attack harder to dodge at higher projectile speed
};

void() SeekerCheckAttack = {
	// Melee punch
	if (ai_checkmelee(MONAI_MELRAGESEEKER,MONAI_MELEEZTALL)) {
		// Need both arms for melee animation
		if (self.state == 0) {
			self.attack_state = AS_MELEE;
			self.th_melee();
		}
		// Instantly go to rocket range attack
		// If the player is too close
		else {
			self.attack_state = AS_MISSILE;
			SUB_AttackFinished (1 + random());
		}
		return;
	}

	if (StandardVisCheckFailed(2 + 2 * random())) return;

	self.attack_state = AS_MISSILE;
	SUB_AttackFinished (2 + 2*random());
};

void() SantaCheckAttack = {
	// Melee attack
	if (ai_checkmelee(MONAI_MELEESANTA,FALSE)) {
		self.attack_state = AS_MELEE;
		return;
	}

	if (StandardVisCheckFailed(1 + 2 * random())) return;

	// Let sightsound play out before machine gun attack
	if (self.attack_rage) {
		SUB_AttackFinished(3);
		self.attack_rage = FALSE;
	}

	// Check if gun is being blocked (extra wide check)
	if (visblocked_wide(self.enemy, self.attack_offset, '0 0 0') ) return;

	self.attack_state = AS_MISSILE; // Range attack (snowball machine gun)
	SUB_AttackFinished (2 + 2*random());
};

void() SnowmanCheckAttack = {
	if (ai_checkmelee(self.meleerange,self.meleerangez)) {
		self.attack_state = AS_MELEE; // Melee attack
		self.attack_finished = 0; // As soon as out of melee, range attack!
		return;
	}

	if (StandardVisCheckFailed(2 + 2 * random())) return;

	self.attack_state = AS_MISSILE;
	SUB_AttackFinished (2 + 2*random());
};

void() GolemCheckAttack = {
	if (!enemy_vis) return;
	if (self.enemydist < MONAI_MELEEGOLEM) {
		self.attack_state = AS_MELEE; // Melee attack(Punch/Pound)
		return;
	}

	// Floor stomp attack
	if (self.enemydist < MONAI_GOLEMRANGE && random() < 0.3) {
		SUB_AttackFinished (1 + 2*random());
		self.th_slide();
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
	local float attTime;

	if (!(self.spawnflags & MON_SHALRATH_MINIONS)) attTime = 2*random();
	else attTime = 1 + 2 * random();

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

	if (StandardVisCheckFailed(attTime)) return;

	SetSelfAttackChances(0.9,0.4,0.1); // Chance based on distance to enemy.
	if (enemy_range == RANGE_MELEE) self.attack_finished = 0; // Constantly fire!
	if (random () < self.attack_chance) { // Random chance of range attack?
		// Slower spawnrate for minion eggs than voreballs
		if (self.spawnflags & MON_SHALRATH_MINIONS) SUB_AttackFinished (1 + 2*random());
		else SUB_AttackFinished (2*random());
		self.attack_state = AS_MISSILE;
	}
};

void() EliminatorCheckAttack = {
	if (StandardVisCheckFailed(1 + 2 * random())) return;														 

	self.attack_state = AS_MISSILE; // Aggressive range attack, no % chances
	SUB_AttackFinished (1 + 2*random());
};

// Melee=Flames/Plasma, Range=Rockets
void() DeflectorCheckAttack = {
	if (!enemy_vis) return; // Check for visibility

	// Plasma and Flame attacks are close combat attacks only
	// Enemy really needs to be infront as they front cone attacks
	if (ai_checkmelee(self.meleerange,self.meleerangez)
		&& (infront(self.enemy) || self.classtype == CT_MONMEGAFORCE)) {
		if (self.classtype == CT_MONMEGAFORCE) {
			self.attack_state = AS_MELEE;
			self.th_melee();
			return;
		} else {
			// Forced pause between attacks
			if (self.attack_timer < time) {
				// Rapid firing plasma projectiles
				if (self.spawnflags & MON_DEFLECTOR_PLASMA) {
					self.attack_state = AS_MELEE;
					self.th_melee();
					return;
				} else {
					// Flame Count = Base (X) * (Skill * Y) Maximum = Z
					self.attack_count = SpriteCount_Flame(self.proj_attqty);
					// Any sprite space left for hazard projectiles?
					if (HazardProjectile_CheckLimit(self, self.attack_count)) {
						self.attack_state = AS_MELEE;
						self.th_melee();
						return;
					}
				}
			}
		}
	}
	
	if (StandardVisCheckFailed(1 + 2 * random())) return;

	self.attack_state = AS_MISSILE; // Aggressive range attack, no % chances
	SUB_AttackFinished (2 + 2*random());
};

// Melee=SSG / Range=GL
void() DefenderCheckAttack = {
	// Melee attack (Super Shotgun to face)
	if (ai_checkmelee(self.meleerange,self.meleerangez)) {
		self.attack_state = AS_MELEE;
		self.th_melee();
		return;
	}

	if (StandardVisCheckFailed(1 + 2 * random())) return;
	
	// Check enemy for grenade resistance?
	if (self.enemy.bouncegrenade) {
		self.attack_state = AS_MELEE;
		self.th_melee();
	} else {
		self.attack_state = AS_MISSILE; // Aggressive range attack, no % chances
		SUB_AttackFinished (1 + 2*random());
	}
};

// Vanilla, Hunter, Fishing and Mace versions
void() OgreCheckAttack = {
	// Melee attack (chainsaw)
	if (ai_checkmelee(self.meleerange,self.meleerangez)) {
		self.attack_state = AS_MELEE;
		return;
	}

	if (StandardVisCheckFailed(1 + 2 * random())) return;

	// Check enemy for grenade resistance?
	// Move closer to enemy instead for melee range
	if (!self.enemy.bouncegrenade || self.classtype == CT_MONRAINDEER) {
		self.attack_state = AS_MISSILE;
		// Fishing ogre fires much faster than standard
		if (self.classtype == CT_MONOGREFISH) SUB_AttackFinished (1 + random());
		else if (self.classtype == CT_MONRAINDEER) SUB_AttackFinished (2 + 2*random());
		else SUB_AttackFinished (1 + 2*random());
	}
};

// Hammer only, much faster
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

	if (StandardVisCheckFailed(1 + 2 * random())) return;

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

	if (StandardVisCheckFailed(1 + 2 * random())) return;

	// If Freddie too far away for stationary attack?
	if (self.enemydist > MONAI_RANGEFREDDIE && skill > SKILL_EASY) {
		// Work out vector angle of enemy infront
		makevectors(self.angles);
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
	if (self.spawnflags & MON_WIZARD_ABOVE || self.classtype == CT_MONSENTINEL) {
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

	if (self.classtype == CT_MONSENTINEL) { TurretMode(1); return; }
	if (!enemy_vis) return; // Do nothing if cannot see enemy or waiting for attack timer
	if (time < self.attack_finished) return;
	if (TurretMode(0)) return; // Range attack only for turret.

	// Range attack (spit)
	// Does the monster have a clear shot to the player? sightline can be blocked by other monsters
	// The original id behaviour is wizards run until within range
	if (enemy_range == RANGE_FAR || visblocked(SUB_entEnemyTarget()) ) {
		if (self.attack_state != AS_STRAIGHT) 
			self.attack_state = AS_STRAIGHT;
		return;
	}
	SetSelfAttackChances(0.9,0.6,0.2);
	if (random () < self.attack_chance) {
		self.attack_state = AS_MISSILE;
	} else if (enemy_range == RANGE_MID) { 
		if (self.attack_state != AS_STRAIGHT) self.attack_state = AS_STRAIGHT; // keep moving forward to enemy target
	} else {
		if (self.attack_state != AS_SLIDING) {
			self.attack_state = AS_SLIDING;
			if (self.th_slide) self.th_slide();
			else self.attack_state = AS_STRAIGHT;
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

	if (StandardVisCheckFailed(1 + 2 * random())) return;

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

void() StrafeFlyerCheckAttack = {
	// Cannot see enemy? stop chasing enemytarget
	if (!enemy_vis) {
		SUB_switchEnemyTarget();
		return;
	}

	if (TurretMode(2 + random())) return; // Range attack only for turret.

	// setup enemytarget if one is not active
	if (self.enemy.classtype != CT_ENEMYTARGET && self.height > 0) {
		if (SUB_setupEnemyTarget(self.enemy, self.height, MONAI_ABOVETIMER)) {
			self.enemy = self.enemytarget;
		}
	}

	// Range attack (Lasers).  Only range attack if cooldown has finished
	if (time > self.attack_finished) {
		if (self.classtype == CT_MONWRAITH) {
			if (!visblocked_wide(SUB_entEnemyTarget(), self.attack_offset, '0 0 0')) {
				if (enemy_range != RANGE_MELEE)	SUB_AttackFinished(2 + random());
				self.attack_state = AS_MISSILE;
				return;
			}
		} else {
			SetSelfAttackChances(0.9,0.6,0.2);
			if (random () < self.attack_chance) {
				if (!visblocked_wide(SUB_entEnemyTarget(), self.attack_offset, '0 0 0')) {
					if (enemy_range != RANGE_MELEE)	SUB_AttackFinished(2 + random());
					self.attack_state = AS_MISSILE;
					return;
				}
			}
		}
	}

	if (self.classtype == CT_MONWRAITH) {
		// If turret, then do not move sideways
		if (self.movespeed < 0) {
			if (self.attack_state != AS_STRAIGHT) self.attack_state = AS_STRAIGHT;
			return;
		}
	}

	// Make sure jim maintains its distance (strafe)
	if (enemy_range >= RANGE_MID) {
		if (self.attack_state != AS_STRAIGHT) self.attack_state = AS_STRAIGHT;
	}
	else self.attack_state = AS_SLIDING;
};

void() GauntCheckAttackQuoth = {
	if (time < self.attack_finished) return 0;
	if (!enemy_vis) return 0;

	if (enemy_range == RANGE_FAR) {
		if (self.attack_state != AS_STRAIGHT) {
			self.attack_state = AS_STRAIGHT;
			gaunt_run1();
		}
		return;
	}

	if (visblocked(self.enemy)) {
		if (self.attack_state != AS_STRAIGHT) {
			self.attack_state = AS_STRAIGHT;
			gaunt_run1();
		}
		return;
	}
	SetSelfAttackChances(0.9,0.3,0.05);
	if (random() < self.attack_chance) {
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
		self.th_melee();
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
	} else self.attack_state = AS_SLIDING;
};

void() MinotaurCheckAttack = {
	local float ragepercent;

	// Using % (350/500) so mappers can change health.  Quoth had 350 for drole.
	if (self.classtype == CT_MONDROLE) ragepercent = 0.7;
	else ragepercent = 0.5;

	// If health is low enough, switch to rage mode; this does not affect the minion spawning version
	if (self.minion_name == "" && self.movespeed >= 0) {
		if (self.health < self.max_health * ragepercent && !self.attack_rage) {
			self.attack_rage = TRUE;
			if (self.classtype != CT_MONDROLE) {
				self.th_charge();	// Short howl at the sky
				return;
			}
		}
	}

	// Melee attack (claws)
	if (ai_checkmelee(self.meleerange,self.meleerangez)) {
		self.attack_state = AS_MELEE;
		return;
	}

	if (TurretMode(1 + 2*random())) return; // Range attack only for turret.

	// RAGE mode (keep running at player)
	if (self.attack_rage) {
		if (self.attack_state != AS_STRAIGHT) self.attack_state = AS_STRAIGHT;
		// Check range and sight for a low chance range attack
		if (!enemy_vis) return;
		if (time < self.attack_finished) return;

		if (self.classtype == CT_MONDROLE) {
			// Calculate a flat vector to ignore Z axis difference.  Not too
			// convinced a flat vector is good for a melee only state.  Using
			// to 3D distance chance so it's not so dumb
			self.enemydist = range_distance(self.enemy, FALSE);
			if (self.enemydist > MONAI_RANGEDROLE && random() < 0.3) {
				// Does the monster have a clear shot to the player? sightline can be blocked by other monsters
				if (visblocked(self.enemy)) return;
				// Standard rocket attack
				SUB_AttackFinished (1 + 2*random());
				self.attack_state = AS_MISSILE;
			}
		} else {
			// If enemy not infront or random chance, stop and range attack
			if (!infront(self.enemy) || random() < 0.1) {
				// Does the monster have a clear shot to the player? sightline
				// can be blocked by other monsters
				if (visblocked(self.enemy)) return;

				SUB_AttackFinished (2 + 2*random());
				self.attack_state = AS_MISSILE; // Plasma bolt attack
			}
		}
	} else {
		// PASSIVE mode (keep at distance)
		// Is the player NOT visible? Keep getting closer
		if (!enemy_vis) {
			if (self.attack_state != AS_STRAIGHT) self.attack_state = AS_STRAIGHT;
		} else {
			// Mid Range attack (JUMP) Not spawning dark version
			if (self.minion_name == "" && random() < 0.35) {
				// Jumped recently, facing right direction and not blocked?
				if (JumpAttackValid()) {
					SUB_AttackFinished (random()); // Block any range attacks for a while
					JumpTouchReset();
					self.th_jump();
					return;
				}
			}

			// Range / missile attack (plasma bolts).  Any chance of a range attack?
			if (time < self.attack_finished) {
				// Calculate a flat vector to ignore Z axis difference
				self.enemydist = range_distance(self.enemy, TRUE);
				// Don't always stay at absolute range, move closer
				if (random() < 0.15 && self.enemydist > 300) {
					self.attack_sidedeny = time + 1 + random();
					self.attack_state = AS_STRAIGHT;
				} else {
					// If not blocked, turn and move sideways
					if (self.attack_sidedeny < time) self.attack_state = AS_SIDESTEP;
				}
			} else {
				// Does the monster have a clear shot to the player? sightline
				// can be blocked by other monsters.
				if (visblocked(self.enemy)) return;

				SUB_AttackFinished (2 + 2*random()); // Keep firing plasma when
													 // at range.
				self.attack_state = AS_MISSILE;
			}
		}
	}
};

void() DSergeantCheckAttack = {
	local vector targoffset;
	// Does the monster have a clear shot to the player? sightline can be blocked by other monsters
	if (visblocked(self.enemy)) return;

	// Melee attack, enemy_range is checked before this function (ai_run - ai.qc)
	// If the monster is within melee range they instantly attack
	if (ai_checkmelee(self.meleerange,self.meleerangez)) {
		self.attack_state = AS_MELEE;
		self.th_melee();
		return;
	}

	if (TurretMode(0)) return; // Range attack only for turret.

	if (self.classtype == CT_MONDFURY) {
		targoffset = '0 0 0';
		// is the enemy close enough for a double sword slice attack?
		if (self.enemydist < self.jumprange_x) {
			self.attack_state = AS_MELEE;
			self.th_slide(); 
			return;
		}

		if (JumpAttackValid()) {
			SUB_AttackFinished (random()); // Block any range attacks for a while
			JumpTouchReset();
			if (random() < 0.65) self.th_jump();
			else self.th_charge();
			return;
		}
	} else targoffset = '0 0 10';

	// If range blocked do charging instead
	if (time < self.attack_finished) {
		if (self.classtype == CT_MONDFURY) return;

		// Charge attack.  Player within certain range, height and charging not blocked?
		self.height = fabs(self.origin_z - self.enemy.origin_z);
		if (ai_checkmelee(MONAI_CHARGEFLAIL,FALSE) && self.height < MONAI_CHARGEZAXIS
				&& self.attack_timer < time) {
			// If attack timer not active, bump up with a random amount
			if (self.attack_finished < time) SUB_AttackFinished (random());
			self.th_charge();
			return;
		}	
	} else {
		// Range attack - Homing missile
		// If the sightline between self and player blocked, allow for monsters to be hit (infighting rules!)
		if (!visxray(self,self.enemy,self.attack_offset,targoffset,FALSE)) return;

		if (self.classtype == CT_MONDFURY) {
			SetSelfAttackChances(0.9,0.4,0.05);
			if (random () < self.attack_chance) self.attack_state = AS_MISSILE;
		} else self.attack_state = AS_MISSILE;
	}
};

void() DPrinceCheckAttack = {
	// Does the monster have a clear shot to the player? sightline can be blocked by other monsters
	if (visblocked(self.enemy)) return;

	// Melee attack, enemy_range is checked before this function (ai_run - ai.qc)
	// If the monster is within melee range they instantly attack
	if (ai_checkmelee(self.meleerange,self.meleerangez)) {
		self.attack_state = AS_MELEE;
		self.th_melee(); 
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
	if (self.movespeed < 0) SUB_AttackFinished (1 + random());
	else {
		// The hazard attack should be faster recovery time
		if (self.weaponstate > 1) SUB_AttackFinished (2 + random());
		else SUB_AttackFinished (1 + random());
	}
	self.attack_state = AS_MISSILE; // Range attacks (decided by weaponstate)
};

void() JusticeCheckAttack = {
	// Special melee attack for monster infighting
	if (self.enemy.flags & FL_MONSTER) {
		// If monster outside of melee range, blast them with range
		if (self.enemydist > self.meleerange) self.attack_state = AS_MISSILE;
		else self.attack_state = AS_MELEE;
		return;
	}

	if (TurretMode(1 + 2*random())) return; // Range attack only for turret.

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
	if (!visxray(self,self.enemy,self.attack_offset,'0 0 0',FALSE)) return;

	if (JumpAttackValid()) {
		SUB_AttackFinished (random()); // Block any range attacks for a while
		JumpTouchReset();
		self.th_jump();
		return;
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

	if (TurretMode(0)) return; // Range attack only for turret.

	// Range / missile attack (slow bolts)
	// The range logic is done via two set of animations (hold/slide).  Once within a certain range, stay there and snipe at the enemy
	if (enemy_range == RANGE_NEAR || self.enemymaxdist) { // range < 500 map units
		if (!visblocked_wide(self.enemy, self.attack_offset, '0 0 0')) { // If sight blocked by another monster, slide to the side
			self.attack_state = AS_SLIDING;
			self.th_slide();
		} else {
			// No monster in the way, hold still and start aiming
			self.attack_state = AS_MISSILE;
			self.th_missile();
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
		if (enemy_vis) {
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
	if (ai_checkmelee(self.meleerange,self.meleerangez)) {
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
	if (JumpAttackValid()) {
		JumpTouchReset();
		self.attack_state = AS_JUMP; // JUMP JUMP JUMP!
	}
};

void() ScorpionCheckAttack = {
	// Melee attack (CLAWS)
	if (ai_checkmelee(MONAI_MELEESCORPION,FALSE)) {
		self.attack_state = AS_MELEE;
		self.th_melee();
		return;
	}

	if (TurretMode(2 + random())) return; // Range attack only for turret.
	if (!enemy_vis) return;
	if (time < self.attack_finished) return;

	if (self.spawnflags & MON_SCORPION_STINGER) { // Range attack (JUMP/TAIL)
		// check for extra wide space to jump
		if (!visblocked_wide(self, self.attack_offset, self.enemy.view_ofs)) return;
		
		if (JumpAttackValid()) {
			JumpTouchReset();
			self.attack_state = AS_JUMP;
		}
	} else {
		SetSelfAttackChances(0.9,0.6,0.2);
		if (random () < self.attack_chance) {
			SUB_AttackFinished (2 + random());
			self.attack_state = AS_MISSILE;
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
	
	if (JumpAttackValid()) {
		JumpTouchReset();
		self.attack_state = AS_JUMP;
	}
};

void() VorelingCheckAttack = {
	// Melee attack (BITE).  Check that within range of a bite attack
	if (ai_checkmelee(self.meleerange,self.meleerangez)) {
		self.attack_state = AS_MELEE;
		return;
	}

	// Range attack (Large Purple Voreling = SPIT).  Behaves like a wizards; strafe, spit goo
	if (self.spawnflags & MON_VORELING_LARGE) {
		if (TurretMode(2 + random())) return; // Range attack only for turret.
		if (!enemy_vis) return;
		if (time < self.attack_finished) return;

		// Does the monster have a clear shot to the player? sightline can be blocked by other monsters
		if (enemy_range == RANGE_FAR || visblocked(self.enemy)) {
			if (self.attack_state != AS_STRAIGHT) {
				self.attack_state = AS_STRAIGHT;
				self.th_run();
			}
			return;
		}
		SetSelfAttackChances(0.9,0.6,0.2);
		if (random () < self.attack_chance) {
			SUB_AttackFinished (2 + random());
			self.attack_state = AS_MISSILE;
		} else if (enemy_range == RANGE_MID) {
			if (self.attack_state != AS_STRAIGHT) {
				self.attack_state = AS_STRAIGHT;
				self.th_run();
			}
		} else {
			if (self.attack_state != AS_SLIDING) {
				self.attack_state = AS_SLIDING;
				self.th_slide();
			}
		}
	} else {
		// Range attack (Small White Voreling = JUMP).  Behaves like a dog; run
		// and jump.  Is it time to jump?
		if (JumpAttackValid()) {
			JumpTouchReset();
			self.attack_state = AS_JUMP; // JUMP JUMP JUMP!
		}
	}
};

void() LavaManCheckAttack = {
   if (!visblocked_wide(SUB_entEnemyTarget(), self.attack_offset,'0 0 0')) return;
   if (time < self.attack_finished) return;

   self.attack_state = AS_MISSILE;
   SUB_AttackFinished(random());
};

void() GremlinCheckAttack = {
   if ((time < self.attack_finished)) return;

   if (self.enemydist <= 90 && self.stoleweapon == FALSE) {
      self.attack_state = AS_MELEE;
      return;
   }

   if (self.stoleweapon) {
      self.attack_state = AS_MISSILE;
      return;
   }
};

void() DragonCheckAttack = {
    local   vector  spot1, spot2;
    local   entity  targ;
    local   float   nofire, chance, reach;

    // Check if the dragon has a breath weapon.
    if (self.th_missile) nofire = FALSE;
    else nofire = TRUE;

    targ = self.enemy;
    chance = 1;     // Melee attack enabled.
    if ((visblocked(self.enemy))) { // Check if dragon can see the target.
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
        if (self.enemydist > reach) { // Target is outside of attack range.
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
        self.th_missile();
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
    traceline(spot1,spot2, FALSE, self);
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
    if (enemy_range == RANGE_MELEE) { self.attack_finished = 0; chance = 0.9; }
    else if (enemy_range == RANGE_NEAR) // Short range (120-500)
        chance = 0.2;
    else
        chance = 0.05;

    if (random () < chance) {
        self.th_missile();
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
        self.th_missile();
        SUB_AttackFinished (chance);
        return;
    }
};

float() ArmagonCheckAttack = {
   local vector spot1, spot2;
   local entity targ;
   local float ang, delta;

   self.lefty = FALSE;
   targ = self.enemy;
   spot1 = (self.origin + self.view_ofs);
   spot2 = (targ.origin + targ.view_ofs);
   traceline(spot1,spot2,FALSE,self);
   if (trace_ent != targ && !self.charmed) return (FALSE);
   if (trace_inopen && trace_inwater) return (FALSE);
   if (time < self.attack_finished) return (FALSE);

   ang = (self.angles_y + self.fixangle);
   delta = (self.ideal_yaw - ang);
   if (((fabs(delta) > MOVETYPE_BOUNCE) && self.enemydist > 200)
	   || (self.enemy.classname != "player")) return ( FALSE );
   if (self.enemydist < 400) { self.th_melee(); return ( TRUE ); }
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
            baron_cast1();
        } else if (self.level == BARON_EARTH) {
            if ((r < 0.5) && !super_active && QuakeHurts(self.enemy)) baron_slam1();
            else if (BaronGolem_Check ()) baron_cast1();
            else return;
        } else if (self.level == BARON_AIR) {
            if (UpIsSky (self.enemy.origin, self.enemy)) {
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

float(float midrange, float usechance) SpecialBossRangeAttacks = {
	//  Only range attack if cooldown has finished
	if (time <= self.attack_finished) return FALSE;
	if (self.enemydist < midrange && random() < 0.75
		|| (usechance && self.attack_chance > random())) {
		// Skill 0=3s, 1=2.25s, 2=1.5s, 3=0.75s
		self.attack_speed = (4 - skill) * 0.75;
		SUB_AttackFinished(self.attack_speed + random());
		self.attack_state = AS_MELEE;
		return TRUE;
	} else {
		self.attack_speed = (4 - skill) * 1;
		SUB_AttackFinished(self.attack_speed + random());
		self.attack_state = AS_MISSILE;
		return TRUE;
	}

	return FALSE;
};

void() EidolonCheckAttack = {
	local float currentdist;

	if (SUB_BossWaveCheck(CT_MONEIDOLONWAVE)) return; // Check for boss wave trigger events

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

	SpecialBossRangeAttacks(MONAI_MEDIUMEIDO,FALSE); // Range attacks (Boulder + Rock Storm).
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
		SUB_AttackFinished(((4-skill)*0.5) + random() + random());
		self.th_slide();
		return;
	}

	if (!enemy_vis) return; // Range attacks (O Rings + Ceiling Rubble)
	
	// Does the monster have a clear shot to the player? sightline can be blocked by other monsters
	if (!visblocked_wide(self.enemy, self.attack_offset, self.enemy.view_ofs)) {
		SUB_AttackFinished(((4-skill)*0.6) + random() + random());
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
	if (JumpAttackValid()) {
		JumpTouchReset();
		SUB_AttackFinished(random()); // Block any range attacks for a while
		self.th_jump();
		return;
	}

	// Range attack (Spikes or Flames)
	if (time < self.attack_finished) return;
	self.attack_state = AS_MISSILE;
	SUB_AttackFinished (2 + random());
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
	
	if (SpecialBossRangeAttacks(MONAI_CLOSENOUR,TRUE)) return;// Range attacks (Spit and Bomb).  Attack_chance override (percentage 0-1 chance)

	// Maintain distance (strafe)
	if (enemy_range >= RANGE_MID || !enemy_vis) {
		if (self.attack_state != AS_STRAIGHT) self.attack_state = AS_STRAIGHT;
	}
	else self.attack_state = AS_SLIDING;
};

void() DGuardCheckAttack = {
	local vector spot1, spot2;
	local entity targ;

	spot1 = self.origin + self.view_ofs;
	spot2 = self.enemy.origin + self.enemy.view_ofs;
	traceline(spot1,spot2, 0, self);
	if (trace_ent != self.enemy) return;
	if (trace_inopen && trace_inwater) return;

	if (self.enemydist < 100) {
		self.th_melee();
		return;
	} else {
		if (self.enemydist < 190 && self.enemydist > 140) {
			deathguard_charge1();
			return;
		}
	}
	if (time < self.attack_finished) return;
	if (enemy_range == RANGE_FAR) return;
	if (self.enemydist < 300) return;

	if (random() < 0.5) {
		self.th_missile();
		SUB_AttackFinished(1.4 * random() + 0.8);
		return;
	}
};

void() FragCheckAttack = {
	if (enemy_range == RANGE_MELEE) { self.attack_state = AS_MELEE; return; } // if close enough for slashing, go for it
	if (CheckFragJump ()) { self.attack_state = AS_MISSILE; return; }
};

void() InquisitorCheckAttack = {
	local float rnd, dist;

	self.enemydist = range_distance(self.enemy,FALSE);
	if (self.enemydist <= 350) { inquisitor_magica1(); return; } // Staff plant storm cloud, especially if within Mjolnir range

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
	self.th_missile();
	return;
};

void() SGruntCheckAttack = {
	if (enemy_range == RANGE_MELEE) {
		if (self.enemydist < 80) { // needs to be really close
			if (CanDamage (self.enemy, self)) {
				self.attack_state = AS_MELEE;
				return;
			}
		}
	}

	if (time < self.attack_finished) return;
	if (!enemy_vis) return;
	if (enemy_range == RANGE_FAR) return;	

	self.attack_state = AS_MISSILE;
	SUB_AttackFinished (3 + 3*random());
};

void() KarasuCheckAttack = {
	// Melee attack(punch)
	if (ai_checkmelee(MONAI_MELEEKARASU, FALSE)) {
		// Increasing chance of lightning strike with skill
		// Easy = 25%, Normal = 35%, Hard = 45%, NM = 55%
		self.attack_chance = 0.25 + (skill * 0.1);
		
		if (random() < self.attack_chance) self.attack_state = AS_MISSILE;
		else { self.attack_state = AS_MELEE; self.th_melee(); }
		return;
	}

	// Range attack (beam, lightning, rocks)
	if (!enemy_vis) return;
	if (time < self.attack_finished) return;
	if (self.enemydist > MONAI_KARASURANGE && !self.attack_sniper) return;

	// Does the monster have a clear shot to the player? sightline can be blocked by other monsters
	if (visblocked(self.enemy)) return;

	SUB_AttackFinished (2 + (2*random()));
	self.attack_state = AS_MISSILE;
};

void() WolfCheckAttack = {
	if (visblocked(self.enemy)) return; // Does the monster have a clear shot to the player? sightline can be blocked by other monsters
		
	// Melee attack uses larger check distance then shorter check before attack
	if (ai_checkmelee(self.meleerange, self.meleerangez)) {
		self.attack_state = AS_MELEE;
		self.th_melee(); 
		return;
	}

	if (!enemy_vis) return;
	if (time < self.attack_finished) return;
	if (self.enemydist > MONAI_WOLFRANGE && !self.attack_sniper) return;

	SUB_AttackFinished (2 + (2*random()));
	self.attack_state = AS_MISSILE; // Range attack (energy sword)
};

void() HuntressCheckAttack = {
	// Melee attack(swords)
	if (ai_checkmelee(MONAI_MELEEHUNTRESS, FALSE)) {
		// Increasing chance of ranged attack with skill
		// Easy = 15%, Normal = 25%, Hard = 35%, NM = 45%
		self.attack_chance = 0.15 + (skill * 0.1);
		
		if (random() < self.attack_chance) {
			self.attack_state = AS_MISSILE;
		} else {
			self.attack_state = AS_MELEE;
			self.th_melee();
		}
		return;
	}

	// Mid Range attack (JUMP).  Jumped recently, facing right direction and
	// not blocked?
	if (JumpAttackValid()) {
		SUB_AttackFinished(random());
		JumpTouchReset();
		if (random() < 0.7) self.th_jump();
		else {
			self.th_missile();
		}
		return;
	}

	// Range attack (pistol, spears)
	if (!enemy_vis) return;
	if (time < self.attack_finished) return;

	// Does the monster have a clear shot to the player? sightline can be blocked by other monsters
	if (visblocked(self.enemy)) return;

	SUB_AttackFinished (2 + (2*random()));
	self.attack_state = AS_MISSILE;
};

void() SpiritCheckAttack = {
	if (self.enemydist < self.meleerange) {
		self.attack_state = AS_MELEE;
		return;
	}
};

void() ManticoreCheckAttack = {
	// Melee attack (tail swipe).  Check that within range.
	if (ai_checkmelee(MONAI_MELEEDEMON,FALSE)) {
		self.attack_state = AS_MELEE;
		return;
	}

	// If setup to be a turret, check range attack only
	if (self.movespeed < 0 && self.skin != 1) {
		self.attack_state = AS_MISSILE;
		if (visblocked(self.enemy)) {
			SUB_AttackFinished (2 + (2*random()));
			mcorn_atkb1();
		}
		return;
	} else if (self.skin == 1) {
		self.attack_state = AS_MELEE;
		if (visblocked(self.enemy)) {
			SUB_AttackFinished (2 + (2*random()));
			mcorn_atkb1();
		}
		return;
	}

	if (JumpAttackValid()) {
		SUB_AttackFinished (random());
		JumpTouchReset();
		if (self.skin != 1) {
			if (random() < 0.7) self.th_jump();
			else 				self.th_missile();
		} else self.th_jump(); // No missile if Lich Fiend
		return;
	}

	if (!enemy_vis) return;
	if (time < self.attack_finished) return;
	if (visblocked(self.enemy)) {
		SUB_AttackFinished (2 + (2*random()));
		self.attack_state = AS_MISSILE; // Range attack
		mcorn_atkb1();
		return;
	}

	SUB_AttackFinished (2 + (2*random()));
	self.attack_state = AS_MISSILE; // Range attack
};

// Check to see if the turret will fire
float() CheckTurretAttack = { // [FUNCTION]
	local vector spot1, spot2;	
	local entity targ;
	local float chance;

	targ = self.enemy;
	spot1 = self.origin + self.view_ofs;// see if any entities are in the way of the shot
	spot2 = targ.origin + targ.view_ofs;
	traceline(spot1,spot2, FALSE, self);
	if (trace_ent != targ) return FALSE;		// don't have a clear shot	
	if (trace_inopen && trace_inwater) return FALSE;			// sight line crossed contents
	if (time < self.attack_finished) return FALSE;
		
	if (enemy_range == RANGE_MELEE) chance = 0.9;
	else if (enemy_range == RANGE_NEAR) chance = 0.5;
	else if (enemy_range == RANGE_MID) chance = 0.2;
	else chance = 0.05;

	if (random () < chance) {
		self.th_missile();
		if (self.spawnflags & TUR_LASERS) SUB_AttackFinished(1.5 + 2*random());
		else if (self.spawnflags & TUR_ROCKETS) SUB_AttackFinished(1.5 + 3*random());
		else if (self.spawnflags & TUR_PPC) SUB_AttackFinished(2 + 2*random());
		else SUB_AttackFinished (1 + 1.5*random());
		return TRUE;
	}
	return FALSE;
};

// ATTACK.  SoE:  Check added so hell lords don't summon meteors at inappropriate times.
float(vector p) M_MeteorCheck = { // [FUNCTION]
    local vector org, vec;

	self.enemydist = range_distance(self.enemy,FALSE);
    if (self.enemydist < 200) return FALSE; // Enemy too close to attacker.

	vec = self.enemy.origin - self.origin;
    org = vectoangles(vec);
    makevectors(org);
    org = self.origin + p_x*v_forward + p_y*v_right + p_z*'0 0 1';
    if (vlen(self.enemy.origin - org) < 200) return FALSE; // Not enough time for target to react.

    traceline(self.origin, org, TRUE, self);
    if (trace_fraction < 1) return FALSE; // Spawn point blocked.
    return TRUE;
};

// Checks if the firewall is effective against an enemy.  Assumed to be called during ai_run and self.th_missile().
float() M_FirewallCheck = { // [FUNCTION]
    if (self.waterlevel) return FALSE;   // Spawnpoint underwater.
    if (!(self.flags & FL_ONGROUND)) return FALSE;   // Not on the ground.

    if (self.enemy) {
        if (self.enemy.waterlevel) return FALSE;       // Underwater.

		self.enemydist = range_distance(self.enemy,FALSE);
        if (self.enemydist > 1000) return FALSE;       // Too far away.

        if (!(self.enemy.flags & FL_ONGROUND)) {
            traceline (self.enemy.origin, self.enemy.origin - '0 0 100', TRUE, self.enemy);
            if (trace_fraction == 1) return FALSE;   // High above the ground.
        }
    }
    return TRUE; // Fire away.
};

// Check for mad charge.
void(float zdiff, float dist, void() chargefunc) CheckForCharge_boss = {
	if (!enemy_vis) return; 
	if (time < self.attack_finished) return;	
	if ( fabs(self.origin_z - self.enemy.origin_z) > zdiff) return;		// too much height change

	self.enemydist = range_distance(self.enemy,FALSE);
	if (self.enemydist < dist) return;		// use regular attack

	SUB_AttackFinished (2);
	chargefunc(); 	// Charge!	
};

void() dcrossbow_checkmelee = {
	// Always return if monster is dead!
	if (self.health < 1) return;

	// Check to see if enemy is dead? back to run/hunt cycle
	if (self.enemy.health < 1) ai_run(0);
	else {
		// Is the enemy within melee range?
		// If not then do a quick hipshot at the player
		if (!ai_checkmelee(MONAI_MELEEKNIGHT,FALSE)) {
			self.attack_chance = -1;	// Start with higher percentage
			dcrossbow_ready1();			// Raise up crossbow ready
		}
		else dcrossbow_melee();
	}
};

void() CheckGugAttack = {
	local vector spot1, spot2;

	if (self.carry_time > 8) {
		if (self.t_width < time) {
			if (!enemy_vis) {
				self.th_novis();
				return;
			}
		}
	}

	if (StandardVisCheckFailed(2 + 2 * random())) return;
	if (self.enemydist < 170) { self.th_melee(); return; }

	SetSelfAttackChances(0.9,0.8,0.2);
	if (random() < self.attack_chance) {
		self.th_missile();
		SUB_AttackFinished(2.3 + 0.3 * random());
	}
};

float() CheckVermisAttack =  {
	local vector spot1, spot2;

	self.enemydist = range_distance(self.enemy,FALSE);
	spot1 = self.origin + self.view_ofs;
	spot2 = SUB_orgEnemyTarget() + self.enemy.view_ofs;
	traceline(spot1,spot2,0,self);
	if (trace_inopen && trace_inwater) return FALSE;

	if (self.enemydist < 340 && self.enemy.movetype != MOVETYPE_FLY) {
		if (self.th_melee) { self.th_melee(); return TRUE; }
	}
	if (!(self.th_missile)) return FALSE;
	if (time < self.attack_finished) return FALSE;
	if (trace_ent != self.enemy && random() < 0.3) return FALSE;

	if (random() < 0.9) {
		self.th_missile();
		SUB_AttackFinished(2 + 1 * random());
		return TRUE;
	}
	return FALSE;
};