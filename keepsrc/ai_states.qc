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
// Function count: 3
//
// Implements: AI Core System of stand, walk, and run
//
// Description:
// Standing is for when a monster is staying in place in idle animations.
// Walk is when a monster is following a path or a leader.
// Run is when a monster is in combat mode and actively chasing an enemy.
//=============================================================================

float SPEED_RYU_MIN   = 8;
float SPEED_RYU_SLOW  = 20;
float RYU_RANGE_MELEE = 120;
float RYU_RANGE_BEST  = 750; // Maximum range for shot spray.
float RYU_RANGE_MAX   = 2000;// Maximum attack range.
float(vector targorg, float angdiff) eidolon_angcheck;
float() Ryu_HatesWater;
float(float dist) Ryu_LeaveWater;
void() ryu_untilt;
float(entity ent) Ryu_NoShot;
float(float dist) Ryu_DetectDanger;
void(float dist, entity ent) Ryu_VerticalSlide;
float(float dist) Shade_AvoidGhost;
void() DragonCheckAttack;
void() Shade_CheckAttack;
void() ryu_run_attack;
void() nehwraith_souls1;

// Waiting around mode
void() ai_stand = {
	self.lastorigin = self.origin;		// Save for cinematic interpolation
	if (self.health < 1) return;		// Health < 0, no more standing
	check_tethertimer();				// Check for tethering system
	MonsterDeBuff();					// Check and apply poison

	if (self.classtype == CT_MONEIDOLON) {
		FindTarget(); // Keep looking for a player
		if (self.style == EIDOLON_PHASE1) { //1
			self.nextthink = time + 0.1; // Slow animation speed, trapped inside cage
			if (self.enemy.flags & FLx_CREATURE) { // Found a player, now track them around the room
				if (eidolon_angcheck(self.enemy.origin, 60)) self.think = self.th_walk;
			}
		}
		return;
	}

	if (FindTarget ()) return; // Found an enemy?

	//  The dragon hovers in place.  If a water-fearing dragon is underwater, it will escape the pool if possible. 
	//  The dragon glides along its path.  Like ryu_stand(), a water-fearing dragon will try to escape from any body of water if it is placed in one.
	if (self.classtype == CT_MONRYU || self.classtype == CT_MONWYRM) {
		if (Ryu_HatesWater()) {
			if (self.waterlevel) {
				if (Ryu_LeaveWater(self.speed)) return;
			}
		}
		ryu_untilt();  // Undo any angle changes due to evasion.
	}

	// Double check there is a goalentity, no pause and no turret
	if (self.goalentity && time > self.pausetime && self.movespeed >= 0) {
		// Make sure AI is turning towards new path corner direction
		self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
		ChangeYaw();
		self.th_walk();
	} else {
		// Only test ground walking monsters (no fly/swim/static).  Check global map variable first (default = off)
		if (map_bodyflrcheck == TRUE && self.classmove == MON_MOVEWALK) ent_floorcheck(self, FLOOR_TRACE_MONSTER);
	}
};

// Path/leader following mode
void(float dist) ai_walk = {
	local vector vertdiff;
	local entity stemp;
	
	if (self.health < 1) return; // Health < 0, no more walking
	if (self.movespeed < 0) { self.th_stand(); return; } // Turret monsters don't walk, they stand around

	MonsterDeBuff(); // Check and apply poison
	if (FindTarget()) return; // Found a player?

	// Allow for flying units to move up/down between path corners
	if (self.classmove == MON_MOVEFLY) {
		if (fabs(self.origin_z - self.goalentity.origin_z) > MON_ZTOL) { // Allow for some Z axis tolerance
			if (self.move_elev == 0) self.move_elev = MON_ZMOVEMENT;
			if (self.origin_z < self.goalentity.origin_z) 
				self.origin_z = self.origin_z + self.move_elev;
			else self.origin_z = self.origin_z - self.move_elev;

			vertdiff = '0 0 0';
			vertdiff_x = fabs(self.goalentity.origin_x - self.origin_x);
			vertdiff_y = fabs(self.goalentity.origin_y - self.origin_y);
			// Are the path corners stacked on top of each other?
			if (vertdiff_x < MON_ZTOL && vertdiff_y < MON_ZTOL) dist = 0;
		}
	}

	//  The dragon hovers in place.  If a water-fearing dragon is underwater, it will escape the pool if possible. 
	//  The dragon glides along its path.  Like ryu_stand(), a water-fearing dragon will try to escape from any body of water if it is placed in one.
	if (self.classtype == CT_MONRYU || self.classtype == CT_MONWYRM) {
		if (Ryu_HatesWater ()) {
			if (self.waterlevel) {
				if (Ryu_LeaveWater(self.speed)) return;
				// Dragon could not rise toward air.  If in walk mode, increase speed in the hope of finding another way toward air faster.
				dist = self.speed; // In walk mode.
			}
		}
		ryu_untilt();  // Undo any angle changes due to evasion.
	}

	if (self.solid == SOLID_NOT && self.goalentity.classtype == CT_PATHCORNER) {
		if (vlen(self.goalentity.origin - self.origin) < 32 && self.attack_finished < time) {
			self.attack_finished = time + 0.5;
			stemp = self;
			other = self;
			self = other.goalentity;
			other.goalentity.touch();
			self = stemp;
			return;
		}
	}

	if (self.temperament == TEMPRA_COWARDLY && self.charmer) dist = dist * 2.5;
	else if (self.temperament == TEMPRA_CALM && self.charmer) dist = dist * 2;
	movedist = dist;
	movetogoal(dist);
};

void() CheckAttack;

// Combat mode.  This is the primary AI for all monsters.
void(float dist) ai_run = {
	local float winner;
	local entity e, client;

	if (self.health < 1) return;	// Health < 0, no more running
	MonsterDeBuff();			// Check and apply poison
	if (self.slow_finished > time) dist = dist * 0.5;
	movedist = dist;
	winner = FALSE;
    if (self.enemy) {
		if ((self.enemy.flags & FLx_CREATURE)) {
			if (visible(self.enemy)) {
				self.carry_time = 0;
				winner = TRUE;
				self.ideal_yaw = vectoyaw (self.enemy.origin - self.origin); // Set yaw in case we need to face the fallen during the dance.
			} else {
				self.carry_time = self.carry_time + 0.1;	
			}
		}
		if (self.enemy.classtype == CT_SOUL) {
			self.gorging = TRUE;
			if (self.classtype == CT_MONWRAITHNEHAHRA) { SUB_SelfThink(nehwraith_souls1,0.1); return; }
		}
	}

	if (self.hasobject == "true") take_monster_object(self); // drop our stuff

	// Is the enemy dead or no longer taking damage?
	if (SUB_healthEnemyTarget() < 1 || SUB_takedEnemyTarget() == DAMAGE_NO || self.enemyexit) {
		self.enemyexit = FALSE; // Reset any exit conditions
		SUB_switchEnemyTarget(); // Remove any enemy target entity tracking
		self.enemy = self.goalentity = self.movetarget = world; // Reset enemy and target system

		// Is the old enemy still alive and can it be damaged?
		if (self.oldenemy.health > 0 && self.oldenemy.takedamage > 0) {
			self.enemy = self.oldenemy;
			HuntTarget();
		} else {
			if (self.passive_mode == TRUE) { // Was this a passive monster before combat?
				// Return to passive monster state (reset)
				self.passive_state = MON_PASSIVESTATE_RESET;
				check_passivestate_system(self);
				if (self.charmer) HuntCharmer(); // Go follow our leader again
			} else {
				if (self.charmer) {
					HuntCharmer(); // Go follow our leader again
					return; // Exit run function
				}

				// Go back on the beat
				if (self.target != "") self.movetarget = find(world, targetname, self.target); // Monster busy with something else?
				 
				if (self.movetarget.classtype == CT_PATHCORNER) { // Check for path corners (patrols) and return to stand/walk
					self.goalentity = self.movetarget;
					self.think = self.th_walk;
				} else self.think = self.th_stand;
			}
			if (winner && self.th_win) { self.th_win(); return;}   // We have a winner!

			if (self.movetarget || self.charmer)
				self.th_walk();
			else
				self.th_stand();
			return; // Exit run function
		}
	}
	
	self.show_hostile = time + 1; // Wake up any monsters in visual range

	// check visibility of enemy
	enemy_vis = visible(SUB_entEnemyTarget());
	if (enemy_vis) {
		// Used to wake up other enemies
		self.search_time = time + 5;
		self.calm_memory_finished = time + 2;
		// The last time the enemy was in sight
		self.enemylastseen = time;
	} else {
		if (IsLoyal(self)) {
			if (!self.charmer) { // already have a leader to follow
				client = SeeFriendly(); // hey buddy!
				if (client) {
					if ((IsLeader(client))) { FollowTheLeader(client); return; }
				}
			}
		}
		if (self.temperament == TEMPRA_COWARDLY) self.search_time = time - 1; // forget it, too SCARY!
	}

	// look for other coop players or go back to leader
	if ((coop || self.charmer) && self.search_time < time) {
		if (self.classtype == CT_MONRYU || self.classtype == CT_MONWYRM || self.classtype == CT_MONSHADE) {
			// Hasn't seen enemy in a while.  Get out of strafe mode.
			if (self.attack_state == AS_SLIDING) self.attack_state = AS_STRAIGHT;
		}
		if (self.charmer) {  // already have a leader to follow
			// dprint("Ok boss, let's get out of here\n");
			self.enemy = self.oldenemy = world;
			HuntCharmer();	
			FindTarget();
			return;
		} else {
			if (IsLoyal(self) && self.calm_memory_finished < time) { // Find a leader
				client = SeeFriendly(); // hey buddy!
				if (client) {
					if ((IsLeader(client))) { FollowTheLeader(client); return; }
				}
			}
		}
		if (FindTarget ()) return;
	}

	// Calculate if goal/enemy is infront, the range and direction
	enemy_infront = infront(SUB_entEnemyTarget());
	enemy_range = range(SUB_entEnemyTarget());
	enemy_yaw = vectoyaw(SUB_orgEnemyTarget() - self.origin);

	// Dragonz are special :|
	if (self.classtype == CT_MONRYU || self.classtype == CT_MONWYRM || self.classtype == CT_MONSHADE) {
		if (self.attack_state == AS_MELEE) {
			self.ideal_yaw = enemy_yaw; //  The dragon rotates in place until it faces its opponent.
			ChangeYaw();

			// Check if dragon is facing opponent.  If so, attack!
			if (FacingIdeal ()) {
				self.attack_state = AS_STRAIGHT;

				// Check for melee attack first.
				if (enemy_range == RANGE_MELEE)
					if (self.th_melee) {
						self.th_melee();
						return;
					}

				if (self.classtype == CT_MONSHADE) {
					if (Shade_AvoidGhost (self.speed)) self.attack_state = AS_STRAIGHT;
					return; // Break off the attack if too close to another nightshade.
				} 

				// Not close enough for melee, so shoot instead if possible.
				if (self.th_missile && !Ryu_NoShot(self)) {
					self.th_missile();
					return;
				}
			}
			
			if (Ryu_DetectDanger (self.speed)) self.attack_state = AS_STRAIGHT; // Break off the attack if a projectile or some other danger is nearby.
			return;
		}

		if (self.classtype == CT_MONSHADE) {
			if (enemy_vis) Shade_CheckAttack();
		} else {
			if (enemy_vis) DragonCheckAttack(); // Hunt mode.
			if (!Indestructable(self))
				if (Ryu_DetectDanger(self.speed)) return; // Avoid projectiles or other threats.

			ryu_untilt(); // Undo any angle changes due to evasion.
			if (Ryu_HatesWater() && self.waterlevel && Ryu_LeaveWater(self.speed)) return; // If a dragon hates and is in water, this makes dragon rise out of it.
		}
	}

	self.enemydist = range_distance(SUB_entEnemyTarget(), FALSE);

	// Check for temporary turret mode via trigger_monsterturret
	if (self.turretactive.classtype == CT_TRIGMONTURRET && enemy_vis && self.th_missile) {
		if (self.turrettimer < time) {
			// Is there a chance to pause?
			if (random() < self.turretactive.count)  self.turrettimer = time + 1 + random()*2;
			self.attack_state = AS_TURRET;
			ai_run_missile();
			return;
		}
	}
	
	// Check if tether system is active
	if (check_tethersystem() && self.health > 0) {
		self.tetherlock = TRUE;
		if (self.th_tether) self.think = self.th_tether;
		return;
	}

	if (check_passivestate_system(self)) return; // Check for the passive state system (reset/timer etc)
	
	CheckBlockedBreakable(); // Check if blocked by breakables

	if (self.attack_state == AS_MISSILE) {
		ai_run_missile(); return;
	} else if (self.attack_state == AS_JUMP) {
		ai_run_jump(); return;
	} else if (self.attack_state == AS_MELEE) {
		ai_run_melee(); return;
	}

	// This has to go after range/melee attack state checks otherwise the AI will not do anything
	// These checks are for the next frame, not this one.  Exception : wizards need to strafe quickly

	// Some monsters don't have distance checks, like wizards
	// All monsters have checkattack defined, no need for ifs and buts!
	if (self.enemymaxdist || self.attack_sniper || self.enemydist < MON_MAX_RANGE) {
		if (!self.th_checkattack) self.th_checkattack = CheckAttack;
		self.th_checkattack();
	}

	if (self.attack_state == AS_SLIDING) {
		// Check if dragon is in strafe mode.
		if (self.classtype == CT_MONRYU || self.classtype == CT_MONWYRM) {
			// Set enemy to world for the first move so dragon stays at same
			// altitude.  Dragon should not sink toward enemy if it is trying
			// to fly up and away for whatever reason.
			e = self.enemy;
			self.enemy = world;
			movetogoal (dist);
			self.enemy = e;
			Ryu_VerticalSlide (dist, self.enemy);
			return;
		}
		ai_run_slide (dist); return; // normal
	} else if (self.attack_state == AS_SIDESTEP) {
		ai_run_sidestep (dist); return;
	} else if (self.attack_state == AS_BACKWARD) {
		ai_run_backward (dist); return;
	}

	// head straight in
    // Fast, larger dragons sometimes have trouble closing in for melee.
    // In close range, check if normal speed is too fast.  If so, fly in
    // at minimum speed.
	if (self.classtype == CT_MONRYU || self.classtype == CT_MONWYRM) {
		dist = self.speed;
		if (enemy_range == RANGE_NEAR && QC_CloseEnough (dist)) dist = SPEED_RYU_MIN;
		movetogoal(dist);
	} else{
		if (self.classtype == CT_MONSHADE) {
			if (self.velocity == '0 0 0')
				movetogoal (SPEED_RYU_MIN);
			else
				movetogoal (self.speed);

			// Check if in strafe mode.
			if (self.attack_state == AS_SLIDING) {
				Ryu_VerticalSlide (self.speed, self.enemy);
				if (pointcontents (self.origin) == CONTENT_SOLID) self.attack_state = AS_STRAIGHT;
			}
		} else {
			movetogoalplus(dist); // head straight towards the enemy...unless of course I am a turret!
		}
	}
};