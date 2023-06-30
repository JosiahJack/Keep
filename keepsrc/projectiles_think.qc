//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: All, though primarily Arcane Dimensions (AD)
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
// Entity count: 
// Function count: 
//
// Implements: Projectile Thinks
//
// Description:
// Generic functions for projectiles that perform various activities while
// alive.
//=============================================================================

void() spark_spawn;
void() beam_touch;
entity(vector org,vector dir,string emdl,float beginf,float endfrm,float anitm,float skn,vector vel) SpawnBFGBoom;
void(entity ent) Burn_Null;
vector(entity ent) Burn_Point;
float(entity ent) ImmuneToBurning;
void(vector spot, float hot) Firelink_Spawn;
void(entity targ, vector org, vector dir, float proj_color, float proj_size, float proj_life, float proj_speed) Launch_Flame;
vector(vector p1, vector p2, float sped, entity targ) Aim_Lead;
vector(vector p1, vector p2, float sped, entity targ, float ex) Aim_LineEx;
float(vector p1, vector p2, float sped) Aim_TossUp;
vector(vector p1, vector p2, float sped, float up, entity targ, vector spread) Maim_SmartBall;
entity() RainStorm_Ice;

void() Think_Projectile = { // [FUNCTION]
	if (self.attack_lifetime < time) { // Original projectile lifetime timer
        entity_remove(self, 0.1);
        return;
    }

	self.flags = self.flags - (self.flags & FL_ONGROUND); // Make sure onground flag is never set
	self.velocity = self.finalangle * self.attack_speed; // Keep updating velocity/angle, to prevent from stopping
	self.angles = vectoangles(self.finalangle);
	if (self.tracer_time) BDW_TracerEffect();
	self.nextthink = time + 0.1;
	self.think = Think_Projectile;
};

void() Steer_HomingMissile = { // [FUNCTION]
	if (self.enemy.health < 1) { entity_remove(self, random() * 3); return; } // If tracking enemies dies or end level? remove homing missiles

	if (frame_pause()) self.no_trackondeath = NEGATIVE;
	if (self.waitmin < time) self.owner = self; // After 1s let homing missiles impact on ower
	if (self.owner.health < 1 && self.no_trackondeath == TRUE) self.no_trackondeath = NEGATIVE; // Stop missile tracking if owner is dead and mode is enabled
	if (self.no_trackondeath == NEGATIVE) return; // Has projectile tracking been disabled?
	
	self.finaldest = self.enemy.origin + self.v_angle; // Full YAW movement speed, no restriction
	self.attack_track = normalize(self.finaldest - self.origin);
	self.velocity = self.attack_track * self.attack_speed; // Update velocity and model facing angle
	self.angles = vectoangles(self.velocity);
	self.nextthink = time + 0.2; // Slow speed update so the missile can sorta steer around corners, sloppy slow updates also allows for a better game experience.
	self.think = Steer_HomingMissile;	
};

void() Steer_LimitedMissile = { // [FUNCTION]
	local float veclen, vecdist;
	
	if (frame_pause()) { Puff_Missile(); return; } // No tracking during intermission / cinematic
	if (self.attack_finished < time) { // Remove projectile after a certain time limit
		if (self.part_qctrail == 0) Puff_Missile(); // Do nothing if controlled via custom particle trail
		return;
	}

	// play sound when starting the missile in flight
	if (self.attack_instant == TRUE && self.noise1 != "") sound(self,CHAN_WEAPON,self.noise1,1,ATTN_NORM);
	self.attack_instant = FALSE; // Only play first sound once

	// Stop steering if attacker or enemy is dead
	if (self.owner.health < 1) self.attack_disabled = TRUE;
	else if (self.enemy.health < 1) self.attack_disabled = TRUE;

	self.think = Steer_LimitedMissile;
	self.nextthink =  time + 0.2; // How often to steer projectile

	// The amount of time to keep steering rocket
	// Time = 0.2 * ( 5 + skill * 5) 
	// EASY = 1s, NORMAL = 2s, HARD = 3s, NM = 4s
	self.count = self.count + 1;
	if (self.count > (5 + (skill*5)) ) self.attack_disabled = TRUE;
	if (!self.attack_disabled) {
		// Steering rocket towards the enemy PART 1
		// First check - Is the rocket too close to the enemy?
		// Based on skill level change that distance to get closer
		// This can change if projectile is fast and tick rate slow
		// The distance check has to happen before sightline checks
		// otherwise the missile will do one last deadly adjustment!
		// Work out distance to enemy (target) origin
		veclen = vlen(self.enemy.origin - self.origin);
		// Skill distance: 160=Easy, 140=Normal, 120=Hard, 100=NM
		vecdist = SPEED_ROCSTEERDIS - (skill * SPEED_ROCSTEERDISSKILL);
		// Stop steering towards enemy if too close
		if (veclen < vecdist) self.attack_disabled = TRUE;
		else {
			// Steering rocket towards the enemy PART 2
			// Having the sight check on the rocket means it will turn corners
			// really fast and look/feel unfair (shalrath problems).
			// Part 1 - place a sight check from attacker to enemy
			// If the enemy has moved behind cover this will break LoS
			// and stop the rocket steering around corners
			// Part 2 - Restrict steering speed to stop sudden turns
			// Slowly build up to super accurate turning direction
			// All AI sight checks are designed for self as primary source
			// This 'Trace' does not involve self, reqs attacker -> enemy
			traceline(self.owner.origin + self.attack_offset, self.attack_origin, TRUE, self.owner);
			// Update tracking origin and direction
			if (trace_fraction == 1) {
				self.attack_origin = self.enemy.origin;
				self.attack_track = self.attack_origin - self.origin;
				// Accuracy starts low and increase over time
				if (self.attack_steering < 1) {
					self.attack_track = self.attack_track * self.attack_steering;
					self.attack_steering = self.attack_steering + SPEED_ROCSTEERINCACC;
				}
				self.attack_track = normalize(self.attack_track); // Normalize (ready for speed) after any steering adjustment
			} else self.attack_disabled = TRUE; // Once sight line broken, no more steering
		}
	}	

	// Make sure projectile velocity has an upper limit
	// Speed increase: 70=Easy, 80=Normal, 90=Hard, 100=NM
	if (self.attack_speed < self.attack_maxspeed) {
		self.attack_speed = self.attack_speed + SPEED_ROCSTEERINC + (skill * SPEED_ROCSTEERINCSKILL);
		if (self.attack_speed > self.attack_maxspeed) self.attack_speed = self.attack_maxspeed;
	}
		
	// Update direction, velocity and facing angle (facing velocity)
	self.velocity = self.attack_track * self.attack_speed;
	if (self.attack_angle) self.angles = vectoangles(self.velocity);
};

void() HIP_LaserThink = { // [FUNCTION]
	if (self.owner.tome_finished) { spark_spawn(); spark_spawn(); spark_spawn(); }
	if ( (time > self.attack_finished) ) { remove (self); return; }

	SUB_RemoveFlags(self,FL_ONGROUND); // Keep it bouncing.
	self.velocity = self.old_velocity;
	self.angles = vectoangles(self.velocity);
	self.nextthink = (time + 0.100);
};

void() ProximityGrenadeExplode = { // [FUNCTION]
    self.takedamage = DAMAGE_NO;
    NumProximityGrenades = (NumProximityGrenades - 1);
    sound(self,CHAN_WEAPON,"hipnotic/weapons/proxwarn.wav",TRUE,ATTN_NORM);
    self.think = ProximityExplode;
    self.nextthink = time + 0.5;
};

void() ProximityBomb = { // [FUNCTION]
    local entity head;

    self.think = ProximityBomb;
    SUB_AdvanceSkin(0,2); // Blink
    if (self.classtype != CT_PROXMINE) {
        if ((time > self.delay || NumProximityGrenades > 200) // Was 64
            || vlen(self.lastvictim.velocity) > 0) {
            ProximityGrenadeExplode();
            return;
        }
    }

    self.takedamage = DAMAGE_YES;
    if (random() < 0.33) { self.nextthink = (time + 0.250); return; }

    head = findradius(self.origin,140);
    while (head) {
        if (head != self) {
            if (head.flags & FLx_CREATURE) {
                if (head.health > 0) {
                    if (!Invisible(head)) {
                        if (head != self.owner) {
                            self.lastvictim = head;
                            ProximityGrenadeExplode();
                            return;
                        }
                    }
                }
            } else if (head.classtype == CT_THROWHAM) {
                self.lastvictim = head.owner;
                ProximityGrenadeExplode();
                return;
            }
        }
        head = head.chain;
    }
    self.lastvictim = world;
    self.nextthink = (time + 0.250);
};

// Target Selection.  This checks if the target is inside the targeting box.
// Attacker must be a client to work properly.  Non-clients that try to use 
// this will likely get a result of FALSE.
// TRUE = Target is in the box, FALSE = Target is outside.
float(entity targ, entity client) BfgLock_InSight = { // [FUNCTION]
    local vector vec, v1, v2;
    local float dot;

    v1 = client.origin + client.view_ofs;
    v2 = Midpoint (targ);
    vec = normalize (v2 - v1); // Check if the target is within the v_weapon's
							   // targeting box.
    makevectors(client.v_angle);
    dot = vec * v_forward;
    if (dot < LOCK_DOT_YAW) return FALSE; // NOT in the box.
    if (dot >= LOCK_DOT_PITCH) return TRUE; // Certainly IN the box.

    // We know the target is within the left and right bounds.  However, we 
	// don't know if the target is truly within the top and bottom bounds.  
    v1 = vectoangles(v_forward);
    v2 = vectoangles(vec);
    v1_x = 0 - v1_x; // Therefore, we need to create a vector whose pitch is 
					 // the same as the aim vector AND whose yaw is the same as
					 // the ideal vector.  This fixes pitch reversal.  
    v1_y = v2_y;
    makevectors(v1);
    return (vec * v_forward) >= LOCK_DOT_PITCH; // Then we need to find the dot 
												// product of the new and ideal 
												// vectors.  If dot is greater
												// than or equal to vertical
												// dot, target is in the box.
};

// Checks if the warhead can track either of its targets.
float() Warhead_See = { // [FUNCTION]
    local entity t1, t2;

    t1 = self.enemy;
    t2 = self.oldenemy;
    if (t1 && t1.takedamage && (t1.health <= 0 || t1.deadflag >= DEAD_DEAD)) { // Current target eliminated.
        if (self.oldenemy) { // Attack secondary target.
            t1 = self.enemy = t2;
            t2 = self.oldenemy = world;
        } else { // No targets left.  Note:  Comment this section out if you want warheads to chase gibs.
            self.enemy = self.oldenemy = world;
            return FALSE;
        }
    }

    if (t1) { // Target is available.
        if (!t1.invisible_finished && !(t1.flags & FL_NOTARGET)) return TRUE;

        // Primary target has stealth tech.  Check secondary target.
        if (t2) {
            if (((t2.takedamage || !(t2.health <= 0) || t2.deadflag)) && !t2.invisible_finished) {
				if (!(t2.flags & FL_NOTARGET)) { // Secondary target is live and uncloaked.
					traceline (self.origin, Midpoint(t2), TRUE, self);
					if (trace_fraction == 1) { // Secondary target found, swap targets.
						self.enemy = t2;
						self.oldenemy = t1;
						return TRUE;
					}
				}
			}
		}
    }
    return FALSE;
};

// Missile think.  Warhead seeks its acquired target.
void() Warhead_Think = { // [FUNCTION]
    local vector dir, spot, spot2, p1, p2;
    local float best, dist;
    local entity head;

    if (self.delay <= time) { // Pop when out of fuel.
        self.enemy = world;
		if (!self.dmg) self.dmg = 120;
		if (self.dmg > 0 && other.health > 0) {
			T_Damage(other, self, self.owner, self.dmg, DAMARMOR);
			T_RadiusDamage(self, self.owner, self.dmg, other, DAMAGEALL);
			R_Exp3(self.origin);
			Tent_Explosion(self.origin);
			BecomeExplosion2();
			if (other.resist_rockets > 0 || (other.resist_multi_rockets && self.classgroup == CG_PROJMULTIROCKETS)) Resist_Effects(other,self.origin,VEC_ORIGIN,0,AM_ROCKETS,other.pain_sound,SOUND_RESIST_ROCKET); // Rocket resistance is shown with puffs of smoke
		} else {
			// Check for poison debuff (using poisonous flag)
			if (self.poisonous == TRUE) {
				self.height = EXPLODE_POISON_MED; // Use new poison explosion
				PoisonDeBuff(other); // Poisonous projectiles
			}

			self.origin = self.origin - 8*normalize(self.velocity); // Move the explosion effect higher up from point of contact
			if (self.noise == "") self.noise = SOUND_REXP3; // Play original explosion sound or replacement
			R_Exp3(self.origin);
			Tent_Explosion(self.origin);
			BecomeExplosion2();
			T_RadiusDamage(self, self.owner, 120, other, DAMAGEALL);
		}
        return;
    }

    if (self.tome_finished) { // AreaBlaster.
        if (self.wait <= time) {
            self.wait = time + 0.2;
            self.owner = world;
        }
        if (((self.enemy.health <= 0) || self.enemy.deadflag)) self.enemy = world;
    }

    // Calculate new velocity.
    dir = self.movedir;
    if (Warhead_See ()) { // Aim for midpoint between top and center of enemy, if way is clear.
        spot = Midpoint (self.enemy);
        spot_z = (self.enemy.absmax_z - spot_z) * 0.5 + spot_z;
        traceline (self.origin, spot, TRUE, self);
        if (trace_fraction == 1) dir = Dir_GotoIdeal (dir, self.origin, spot, self.yaw_speed);
    } else if (self.tome_finished) {   // AreaBlaster -- Find new guy.
        best = 600;
        head = findradius (self.origin, best);
        while (head) {
            if ((head != self.owner) && (head.takedamage || !((head.health <= 0) || head.deadflag)) && !Ally_Check(head,self.master) && !head.invisible_finished && !(head.flags & FL_NOTARGET)) { // Secondary target is live and uncloaked.
                spot2 = Midpoint (head);
                traceline (self.origin, spot2, TRUE, self);
                if (trace_fraction == 1) {
                    dist = vlen (self.origin - spot2);
                    if (dist <= best) {
                        best = dist;
                        self.enemy = head;
                    }
                }
            }
            head = head.chain;
        }
    }
    dir = Dir_Change (dir, self.t_width, self.t_length);  // Give spiraling.

    // Update speeds and spiraling angles.  Note:  43 and 47 are primes closest to 45.
    self.speed      = self.speed + self.distance;
    self.t_width    = self.t_width + 0.5;
    self.t_length   = anglemod(self.t_length + 47);

    // Apply new velocity.
    if (self.flags & FL_ONGROUND) {
        SUB_RemoveFlags(self,FL_ONGROUND);
        if (self.owner.solid == SOLID_BSP) { // Glide along the ground.
            dir = 16*dir;
            p1 = self.origin - (dir);
            p2 = self.origin + (dir);
            traceline (p1, p2, TRUE, self);     // see through other monsters
            dir = Vec_Reflect (dir, trace_plane_normal, 1, 0);
            dir = normalize(dir);
        }
    }
    self.movedir    = dir;
    self.angles     = vectoangles(dir);
    self.velocity   = self.movedir * self.speed;
    self.nextthink  = time + 0.1;
};

// Checks if the weapon's targeting system is offline.
float() Mirv_Off = { // [FUNCTION]
    if (self.master.mirv1 != self) return TRUE; // Previously went offline.
    if (self.weapon != self.master.weapon && self.weaponismoditems != self.master.weaponismoditems) return TRUE; // Not holding the launching weapon.
    if (cinematic_running > 0 || cutscene > 0) return TRUE; // In a cutscene or intermission
    return FALSE;
};

// This severs the link between an attacker and his MIRV.
void() Mirv_Reset = { // [FUNCTION]
    if (self.master) {
		if (self.master.mirv1 == self) { // Make sure the missiles match.
			self.state = 0; // Disable payload targeting.
			if (self.master.flags & FL_CLIENT && self.master.button0) { // Give client a chance to release button after impact so that he doesn't accidently fire another MIRV.
				if (self.master.attack_finished < time + 0.5) self.master.attack_finished = time + 0.5;
			}
			self.master.mirv1 = world;
		}
	}
};

// Missile think.  Attacker guides the MIRV by sight.
void() Mirv_Think = { // [FUNCTION]
    local entity ent;
    local vector dir, org, vec;

    if (!self.th_win) self.th_win = Mirv_Split;
    if (self.delay <= time) { self.th_win(); return; }  // Out of fuel, release payload.
    if (Mirv_Off()) { Mirv_Split(); self.nextthink = self.delay; self.think = self.th_win; return; } // MIRV launcher inactive.
	if (self.state == 0) return;

    ent = self.master;
    dir = self.movedir;
    if (visible (ent)) { // Fly toward the spot its owner is aiming at. Missile must 'see' its owner.
        if (ent.flags & FL_CLIENT) { makevectors(ent.v_angle); vec = v_forward; }
        else vec = normalize (ent.enemy.origin - ent.origin);

        org = ent.origin + '0 0 16';
        traceline (org, org + vec*LOCK_RANGE, FALSE, ent);
        if (trace_fraction < 1) dir = Dir_GotoIdeal(dir,self.origin,trace_endpos,self.yaw_speed);
		else dir = Dir_GotoIdeal(dir, self.origin,trace_endpos,self.yaw_speed);
    }

    self.movedir    = dir;
    self.flags      = self.flags - (self.flags & FL_ONGROUND);
    self.angles     = vectoangles(dir);
    self.velocity   = self.movedir * self.speed;
    self.nextthink  = time + 0.2;
};

// Hydra/Drunk Missiles.  Not part of the MIRVs, but this borrows some code from there.
void() DrunkRocket_Think = { // [FUNCTION]
    local vector dir, vec;

    if (self.delay <= time) { // Pop when out of fuel.
        self.enemy = world;
		if (!self.dmg) self.dmg = 140; // Drake had this at 120, increased to improve overall effectiveness.
		if (self.dmg > 0 && other.health > 0) {
			T_Damage(other, self, self.owner, self.dmg, DAMARMOR);
			T_RadiusDamage(self, self.owner, self.dmg, other, DAMAGEALL);
			// Rocket resistance is shown with puffs of smoke
			if (other.resist_rockets > 0 || (other.resist_multi_rockets && self.classgroup == CG_PROJMULTIROCKETS)) {
				Resist_Effects(other,self.origin,VEC_ORIGIN,0,AM_ROCKETS,other.pain_sound,SOUND_RESIST_ROCKET);
			}
		} else {
			// Check for poison debuff (using poisonous flag)
			if (self.poisonous == TRUE) {
				self.height = EXPLODE_POISON_MED; // Use new poison explosion
				PoisonDeBuff(other); // Poisonous projectiles
			}
			self.origin = self.origin - 8*normalize(self.velocity); // Move the explosion effect higher up from point of contact
			if (self.noise == "") self.noise = SOUND_REXP3; // Play original explosion sound or replacement
			R_Exp3(self.origin);
			Tent_Explosion(self.origin);
			BecomeExplosion2();
		}
        return;
    }

    // Check if the enemy still exists.
    if (self.enemy) {
        if (!self.enemy.takedamage && (self.enemy.health <= 0)) {
            self.enemy = self.oldenemy; // Primary target gone; go to secondary target.
            self.oldenemy = world;
            if (!self.enemy.takedamage && (self.enemy.health <= 0)) self.enemy = world; // No more targets.
        }
    }

	// Calculate new velocity.
    dir = self.movedir; 
    if (self.enemy) {
        // Turn toward the enemy if not blocked.
        vec = Midpoint (self.enemy);
        traceline (self.origin, vec, TRUE, self);
        if (trace_fraction == 1) dir = Dir_GotoIdeal (dir, self.origin, vec, self.yaw_speed);
    }
    dir = Dir_Randomize (dir, self.cnt);     // For drunken flight.
    self.movedir    = dir;
    self.flags      = self.flags - (self.flags & FL_ONGROUND);
    self.angles     = vectoangles(self.movedir);
    self.velocity   = self.movedir * (self.speed + random() * self.height); // Apply new velocity.
    self.nextthink  = time + 0.2;
    if (self.delay < self.nextthink) self.nextthink = self.delay;
};

void() lightning_orb_think = { // [FUNCTION]
	if (self.attack_finished < time) { self.think = lightning_orb_death; self.nextthink = time + 0.1; return; }

	SpawnOrbLightning(self.origin,250,1.9);
	self.think = lightning_orb_think;
	self.nextthink = time + 0.1;
};

void() HomingMissileThink = { // [FUNCTION]
   local vector dir;

   if (self.enemy.health < TRUE) { MultiRocketExplode(); return; }

   dir = normalize ((self.enemy.origin - self.origin));
   self.velocity = (dir * 1000.000);
   self.nextthink = (time + 0.100);
   self.think = HomingMissileThink;
};

void() HomingMissileAcquire = { // [FUNCTION]
    local vector oldVelocity, aimangle;
    local float rad, loopiter;
    local entity head;

    if (self.delay < time) { MultiRocketExplode(); return ; }

    oldVelocity = self.velocity;
    makevectors(self.v_angle);
    self.velocity = aim (self,1000.000);
    self.velocity = (self.velocity * 1000.000);
    aimangle = (self.origin + self.velocity);
    traceline(self.origin,aimangle,FALSE,self);
    if ( (trace_fraction < TRUE) ) {
        if ((trace_ent.flags & FLx_CREATURE) && Align_Opposing(self,trace_ent)) {
            self.enemy = trace_ent;
            self.enemy.monsterflags = self.enemy.monsterflags | MF_QMASTER_TARGETTED;
            HomingMissileThink();
            return;
        }
    }

    if (self.tome_finished) {
        loopiter = 0;
        head = findradius(self.origin, 256);
        while (head) {
            loopiter = loopiter + 1;
            if (head != self && vlen(head.origin - self.owner.origin) > 192) {
                traceline(self.origin,head.origin,FALSE,self);
                if (trace_fraction < TRUE ) {
                    if ((trace_ent.flags & FLx_CREATURE)
                        && (!(trace_ent.monsterflags & MF_QMASTER_TARGETTED)
                            || random() < 0.2)
                        && Align_Opposing(self,trace_ent)) {

                        self.enemy = trace_ent;
                        self.enemy.monsterflags = self.enemy.monsterflags | MF_QMASTER_TARGETTED;
                        HomingMissileThink();
                        return;
                    }
                }
            }
            head = head.chain;
            if (loopiter >= 100) break;
        }
    }

    self.velocity = oldVelocity;
    self.v_angle = vectoangles(self.velocity);
    self.angles = self.v_angle;
    self.think = HomingMissileAcquire;
    self.nextthink = (time + 0.200);
};

void() beam_generate = { // [FUNCTION]
	local entity beamseg;

	beamseg = spawn();
	beamseg.owner = self.owner;
	beamseg.solid = SOLID_BBOX;
	setmodel(beamseg, "progs/custents/beam.mdl");
	setsize(beamseg, '0 0 0', '0 0 0');
	makevectors(self.owner.v_angle);
	if (self.owner.flags & FL_CLIENT) {
		self.owner.attack_finished = time + 0.5;
		setorigin(beamseg, self.owner.origin + v_forward*12 + self.owner.dest2);
		beamseg.velocity = aim(self.owner, 800) * 800;
	} else if (self.owner.flags & FL_MONSTER) {
		setorigin(beamseg, self.owner.origin);
		beamseg.velocity = normalize(self.owner.enemy.origin - self.owner.origin) * 800;
	} else {
		setorigin(beamseg, self.owner.origin);
		beamseg.velocity = self.owner.movedir * 800;
	}
	beamseg.angles = vectoangles(beamseg.velocity);
	beamseg.speed = 800;
	beamseg.classname = "beam";
	beamseg.movetype = MOVETYPE_FLYMISSILE;
	beamseg.currentammo = self.currentammo;
	beamseg.touch = beam_touch;
	beamseg.think = SUB_Remove;
	beamseg.nextthink = time + 6;
	sound(self.owner,CHAN_WEAPON,"weapons/lstart.wav",1,ATTN_NORM);
	self.currentammo = self.currentammo / 2;
	if ((self.owner.flags & FL_CLIENT) && self.deadflag == DEAD_NO) {
		self.owner.punchangle_x = -6;
		self.owner.velocity = self.velocity - v_forward * self.currentammo * 2;
	}

	if (self.currentammo < 1) remove(self);

	self.nextthink = time + 0.05;
};

void() BFGBoomThink = { // [FUNCTION]
    self.frame = self.frame + 1;
    self.think = BFGBoomThink;
    self.nextthink = time + self.pain_timeout;

    if (self.frame >= self.frame_override) {
        self.frame = self.frame_override;
        self.think = SUB_Remove;
        self.nextthink = time + self.pain_timeout;
    }
};

void() BFGTracerThink = { // [FUNCTION]
    local entity tracer;
    local vector org;
    local float dis;

    dis = vlen(self.view_ofs-self.oldorigin)/5;
    org = self.origin + self.pos1*dis;
    setorigin(self, org);
    tracer = SpawnBFGBoom(self.origin, self.pos1, "progs/madfox/s_bfg.spr", 8, 14, 0.06, 0, '0 0 0'); // Fixes improperly aligned sprite beamrings.
    if (tracer) tracer.angles_x = tracer.angles_x - tracer.angles_x*2;

    tracer = SpawnBFGBoom(self.origin, (self.pos1-self.pos1*2), "progs/madfox/s_bfg.spr", 8, 14, 0.06, 0, '0 0 0'); // Fixes improperly aligned sprite beamrings.
    if (tracer) tracer.angles_x = tracer.angles_x - tracer.angles_x*2;

    if (self.cnt == 5) {
        self.think = SUB_Remove;
        self.nextthink = time + 0.1;
    } else {
        self.think = BFGTracerThink;
        self.nextthink = time + 0.1;
        self.cnt = self.cnt + 1;
    }
};

void() Echo_Think = { // [FUNCTION]
    if (frame_pause()) { remove(self); return; }

    if (((self.owner.button0 || self.owner.tome_finished || self.owner.perms & POW_DOUBLE)) && (self.owner.health > 0)) {
        SUB_ThinkImmediate(self.owner, self.think1);
    }
    remove(self);
};

// This creates a small particle trail behind the shot.
void(float rgb, float density, float full) Meteor_Trail = { // [FUNCTION]
    Particle_Beam (self.oldorigin, self.origin, rgb, rgb, density, full);
    self.oldorigin = self.origin;   // Update previous point.
};

void() AkArrow_Think = { // [FUNCTION]
    if (self.delay <= time) { remove (self); return; }

    self.speed   = vlen (self.velocity);
    self.movedir = self.dest = normalize (self.velocity);
    self.angles  = vectoangles(self.movedir);
    if (self.cnt) Meteor_Trail (self.cnt, 1, FALSE);
	else particle (self.origin, '0 0 0', 6, 1);	//ijed: subtle basic arrow trail

    self.nextthink = time + 0.05;
};

// From Drake's throwing axe.  This removes the axe if its surface moves or if
// its been out too long. Update:  Also called by goblin arrow code for the
// same purpose.
void() Axe_Watch = { // [FUNCTION]
    if (self.delay <= time) remove(self);
    else if (vlen (self.enemy.velocity) > 0) remove(self); // Surface moved, so remove the axe now.
    else {
		self.nextthink = time + 0.1;
		self.think = Axe_Watch;
	}
};

void() RyuPlasma_Think = { // [FUNCTION]
    local float pc;

    if (self.delay <= time) { remove (self);  return; }

    pc = GetContents(self.origin);
    if ((pc <= CONTENT_WATER) && (pc >= CONTENT_LAVA)) { RyuPlasma_Explode();  return; }

    particle(self.origin, self.velocity * 0.005, 9, self.waitmin);   //2
    particle(self.origin, self.velocity * 0.01, 41, self.waitmax);   //4
    self.nextthink = time + 0.05;
};

//  Acid -- Used by scrag and green dragon.
void() Acid_Think = { // [FUNCTION]
    if (self.delay <= time) { remove (self); return; }

    self.angles = vectoangles (self.velocity);
    self.nextthink = time + 0.1;
};

void() Ice_Think = { // [FUNCTION]
    Meteor_Trail (39, 2, FALSE);    // Function in 'fire.qc'.
    if (self.delay <= time) { remove (self); return; }
    if (GetContents(self.origin) == CONTENT_LAVA) { remove(self); return; }

    self.nextthink = time + 0.1;
};

// Thinking for iceballs.  Unlike shards, balls explode instead of melting.
void() Iceball_Think = { // [FUNCTION]
    Meteor_Trail (39, 2, TRUE); // Bigger ice chunks, so spawn a beam of frost.
	self.think = Iceball_Think;
    if ((self.delay > time) && (GetContents(self.origin) != CONTENT_LAVA)) { self.nextthink = time + 0.1;  return; }

    Touch_Missile(); // Time to blow up.
};

void() IceMineTrigger_Think = [ 0, IceMineTrigger_Think ] { if (self.owner) setorigin(self, self.owner.origin); }; // [FUNCTION]

void() RainStorm_Think = { // [FUNCTION]
    local vector p1, p2, dir;

    if (self.delay <= time) { super_active = 0; remove (self); return; }

    p1 = self.enemy.origin; // Find a point to spawn a rain drop.
    p2_x = crandom() * self.distance + p1_x;
    p2_y = crandom() * self.distance + p1_y;
    p2_z = p1_z;
    traceline (p1, p2, TRUE, self);
    p2 = trace_endpos;
    if (trace_fraction < 1) { // Move away from the wall a tiny bit.
        dir = normalize (p2 - p1);
        p2 = p2 - dir*2;
    }
    traceline (p2, p2 + '0 0 2048', TRUE, self);
    if (trace_fraction < 1) trace_endpos = trace_endpos - '0 0 2'; // Move endpoint away from the ceiling.  We can't pass vectors to a think function, so use trace_endpos.

    if (self.think1) self.think1();
    else { remove(self); return; }

    self.nextthink = time + self.wait;
};

void() RainsStormThinkFinish = { // [FUNCTION]
	RainStorm_Ice();
};

// Homing Rockets.  Returns a linked list of targets, with the best at the head of list.  Uses .chain2 to link targtes.
entity(entity attacker, vector org, vector dir, float radius, float scope) SuperRocket_Target = { // [FUNCTION]
    local entity head, targ, link, old;
    local vector vec, end;
    local float dotproduct;

    targ = world;
    head = findradius(org, radius);
    while (head) {
		// Target must be a living creature without any stealth tech.
        if (head.health > 0) {
            if (!Invisible(head)) {
                if (head.flags & FLx_CREATURE) {
                    if (Align_Opposing(attacker,head) || attacker.enemy == head) {
                        // Get the target whose direction matches aim vector the closest.
                        end = Midpoint (head);
                        vec = normalize (end - org);
                        dotproduct = vec * dir;
                        if (dotproduct > scope) {
                            traceline (org, end, TRUE, head);
                            if (trace_fraction == 1) {
                                // Accept as a possible target and make a chain of targets.
                                head.chain2 = world;
                                head.frate2 = dotproduct;
                                if (targ) {
                                    // Sort the chain by dot product in descending order.
                                    old = world;
                                    link = targ;
                                    while (link) {
                                        if (dotproduct > link.frate2) {
                                            // This target is more desirable.
                                            head.chain2 = link;
                                            if (old) old.chain2 = head;
                                            else targ = head;

                                            link = world;   // End this sub-loop.
                                        } else {
                                            // Next!
                                            old = link;
                                            link = link.chain2;
                                            if (!link) old.chain2 = head;
                                        }
                                    }
                                } else targ = head;
                            }
                        }
                    }
                }
            }
        }
        head = head.chain;
    }
    return targ;
};

// Sidewinder Rockets - - - - - - - - -
// Used by players and mega enforcers.
// Some of the sidewinder code is also used by other monsters (SoE acolyte).

// Missile angles oscillate around ideal_yaw.
// Use when missile needs to sidewind along a straight line.
void() Sidewind_Ideal = { // [FUNCTION]
    local float diff, yaw;

    yaw = self.ideal_yaw;
    diff = anglemod(yaw - self.angles_y);
    if ((diff > 0) && (diff <= 180)) self.ideal_yaw = self.angles_y + self.yaw_speed;   // Go left.
    else self.ideal_yaw = self.angles_y - self.yaw_speed;   // Go right;

    ChangeYaw();
    self.ideal_yaw = yaw;
};

// Missile changes pitch and yaw to face its target point.
// The missile must always turn toward ideal_yaw at full yaw_speed.
void(vector spot) Sidewind_Face = { // [FUNCTION]
    local vector ang;
    local float diff, up;

    if (self.lefty) { // Oscillate up and down slightly.
        up = (self.cnt & 7) * 45;
        up = SUB_cos(up) * 5;
        self.cnt = self.cnt + 1;
    } else up = 0;

    ang = normalize (spot - self.origin);
    ang = vectoangles (ang);
    self.angles_y = anglemod(self.angles_y);
    self.ideal_yaw = anglemod(ang_x + up); // Copy pitch into yaw to fool Quake into changing the pitch for us.
    diff = self.angles_y; // Remember this so we can restore yaw later.
    self.angles_y = self.angles_x;
    ChangeYaw(); // Change fake yaw using builtin.
    self.angles_x = self.angles_y;
    self.angles_y = diff;   // Restore yaw now that pitch has changed.
    diff = anglemod(ang_y - self.angles_y);
    if ((diff > 0) && (diff <= 180)) self.ideal_yaw = self.angles_y + self.yaw_speed;   // Go left.
    else self.ideal_yaw = self.angles_y - self.yaw_speed;   // Go right;

    self.ideal_yaw = anglemod(self.ideal_yaw);
    ChangeYaw(); // Change actual yaw using builtin.
};

// The next three functions are designed specifically for the mega enforcers' sidewinder missiles (which the player may use too). but are also used for the Necromancer boss's Necrosnake attack
void() Sidewinder_Think = { // [FUNCTION]
    local vector vec, dir;
    local float sped, d1, d2;

    if (self.delay < time) {
        if (self.classgroup == CG_PROJROCKETS) {
            other = self.enemy;
            Touch_Missile(); // Out of gas.
        } else remove(self); // For acolytes' venom shots.
        return;
    }

    if (self.enemy && !Invisible(self.enemy)) {
        if (vlen(self.enemy.origin - self.origin) < 40) {
            other = self.enemy;
            Touch_Missile();
            return;
        }
        vec = Aimpoint (self.enemy);    // Was self.enemy.origin;
        Sidewind_Face (vec);
        if (!self.volume) { // Lose track if missile flies past its target.
            dir = normalize(self.velocity);
            d1 = normalize(self.enemy.origin - self.origin) * dir;
            if (d1 < 0) { // Target is behind the missile.
                if (self.master.flags & FL_MONSTER) {
                    d1 = vlen (vec - self.owner.origin); // Check if missile is further away than the target...
                    d2 = vlen (self.origin - self.owner.origin); // ...then assume the missile flew behind the target and drop the target.
                    if (d2 > (d1 + 50)) self.enemy = world; // Assumed to be behind target.
                }
            }
        }
    } else if ((self.master == self.owner) && (!self.oldenemy)) Sidewind_Face (self.pos2);      // No target to begin with.
    else Sidewind_Ideal();

    sped = random() * 50 + 450;
    vec = self.angles;
    vec_x = 0 - vec_x;
    makevectors(vec);
    self.velocity = v_forward * sped;
    if (self.lefty & 1) { self.lefty = 2; self.nextthink = time + 0.1; }
    else self.nextthink = time + 0.2;
};

void() NecroBolt_Think = { // [FUNCTION]
    local vector vec;

    if (self.delay <= time) {
        if ((self.dmg <= 40) || (self.enemy.health <= 0)) { BecomeFancy(X32_STAR_RED + 3,2); return; } // The bolt dies.

        vec = Aimpoint(self.enemy);
        vec = normalize(vec - self.origin);
        self.dmg        = self.dmg - 10; // Each update weakens the bolt, so long distance attacks are less effective (lost magic).
        self.delay      = time + 1; // Much like Diablo2 Guided Arrow.
        self.velocity   = vec * self.speed;
        self.angles     = vectoangles(self.velocity);
        self.owner      = world;    // Let bolt hit the source now.
    }
    particle (self.origin, self.velocity * 0.005, 73, 2); // Draw particle trail.
    particle (self.origin, self.velocity * 0.01, 225, 4);
    self.nextthink = time + 0.1;
};

// Points missile toward its target.  Used by Mjolnir.
// Note:  Missile facing favors two dimension movement.
void(entity targ) Missile_Seek = {
    local vector vec, ang;
    local float diff;

    if (targ) {
        if (Invisible(targ)) {
            if (!(self.classname == "Mjolnir" && self.master == targ)) return;
		}

        vec = Aimpoint (targ);
        if (self.state) vec = Aim_Lead(self.origin, vec, self.speed, targ); // Check for intercept course.
        // Point missile toward a point in space.
        //
        // Note:  Missile will seek the same elevation as its target point.
        // This means if missile is at the same altitude as its target, missile
        // will not climb or dive to loop toward the target even if such three
        // dimensional manuvering would let it loop back faster.  Instead,
        // it will loop to the side.  This does not mean the missile cannot
        // climb or dive toward the target; in fact, it will do so if there
        // is a elevation difference between the missile and its target.
        //
        // This two dimensional movement is good for sidewinding missiles
        // and the Mjolnir.  For other missiles, not so much.
        ang = normalize (vec - self.origin);
        ang = vectoangles (ang);
        self.angles_y = anglemod(self.angles_y);
        // Change pitch - - - - - - -
        // Copy pitch into yaw to fool Quake into changing the pitch for us.
        self.ideal_yaw = anglemod(ang_x);
        diff = self.angles_y;   // Remember this so we can restore yaw later.
        self.angles_y = self.angles_x;
        ChangeYaw();
        self.angles_x = self.angles_y;
        self.angles_y = diff;   // Restore yaw now that pitch has changed.
        // Change yaw - - - - - - - -
        self.ideal_yaw = anglemod(ang_y);
        ChangeYaw();
        vec = self.angles;
        vec_x = 0 - vec_x;
        makevectors(vec);
        self.velocity = v_forward * self.speed;
        self.movedir = v_forward;
    }
};

// Points missile toward its target.
// Function runs more code, but missiles can climb or dive more.
// Used by homing missiles in this file.
void(entity targ) Missile_Seek_3D = {
    local vector  vec, dir;

    if (targ) {
        if (Invisible(targ)) return;

        vec = Aimpoint (targ);
        if (self.state) vec = Aim_Lead (self.origin, vec, self.speed, targ); // Check for intercept course.
        dir = normalize (self.velocity);
        dir = self.movedir = Dir_GotoIdeal (dir, self.origin, vec, self.yaw_speed);
        self.angles = vectoangles (dir);
        self.velocity = dir * self.speed;
    }
};

// Controls hammer velocity.  Called by Thor_Think.  Cause thrown hammer to fly towards a given target.
void(entity targ) Thor_Fly = { // [FUNCTION]
    local vector ang;
    local float diff;

    self.flags = self.flags - (self.flags & FL_ONGROUND);
    self.avelocity_x = 0 - THOR_SPEED;
    ang = self.angles; // Temporarily set angles to the direction the missile is traveling.
    self.angles = vectoangles (self.movedir);
    diff = ang_x - self.angles_x;
    Missile_Seek(targ); // Update velocity and angles based on missile angles.
    self.angles_x = anglemod (self.angles_x + diff); // Restore pitch to what it should be now.
    if (self.angles_x >= 180) self.angles_x = self.angles_x - 360;
};

// Track the nearest target.
void() Thor_Think = [ 0, Thor_Think ] { // [FUNCTION]
    local entity targ;

    if (self.master.hammer_finished < time) { // Time's up, return to attacker now!
        Thor_Poof();
        return;
    }

    if (self.owner == self.master) { // Outgoing for an attack.
        if (self.enemy) { // Return to attacker if target is gone. ToP:  If no 
                          // juice, return after a short delay.
            if (((self.enemy.solid < SOLID_BBOX)
                  && (self.enemy.takedamage != DAMAGE_AIM)
                  || (self.enemy.health <= 0))
                  || (!self.enemy.modelindex)
                  || ((!self.ammo_cells)
                  && (self.delay <= time))) {
                self.owner = world;
            }
        } else {
            if (self.delay <= time) self.owner = world; // Return to attacker
                                                        // if hammer flew long
                                                        // enough.
        }
        targ = self.enemy;
    } else targ = self.master;     // Returning back to attacker.

    Thor_Fly(targ);
};

entity() W_ThorTarget = { // [FUNCTION]
    local   entity  head, targ;
    local   float   best, dist, dot;
    local   vector  org, spot, vec, vx;

    if (self.flags & FL_CLIENT) makevectors(self.v_angle);
    else makevectors(self.angles);
    vx = v_forward;
    org = self.origin + self.view_ofs;
    targ = world;
    best = 10000000;
    head = findradius(org,2000); // Don't give hammer more range.
    while (head) {
        if (head.modelindex && !(head.flags & FL_NOTARGET) && (head.flags & FLx_CREATURE)
            && head.health > 0 && head.solid >= SOLID_BBOX && Align_Opposing(head, self)) {
            spot = Midpoint (head);
            traceline (org, spot, TRUE, self);
            if (trace_fraction == 1) {
                vec = head.origin - org;
                dot = normalize (vec) * vx;
                if (dot > 0.7071) { // Must be within 90 fov.
					dist = vlen(vec) / dot;
					if (dist < best) {
						best = dist;
						targ = head;
					}
                }
            }
        }
        head = head.chain;
    }
    return targ;
};

// Added 12/23/2009:
// Used by hammer slam to repel missiles and crush fallen zombies.
void(entity inflictor, float damage) Hammer_Block = { // [FUNCTION]
    local   entity  head;
    local   vector  spot, org;
    local   float   points;

    spot = inflictor.origin;
    head = QC_FindRadius(spot, damage + 40);
    while (head) {
        if (head.owner != self)
        if (head.solid == SOLID_NOT) { // Hit zombies!
            if (head.takedamage && head.modelindex && (head.health > 0) && head.classgroup == CG_ZOMBIE && (head.classtype != CT_MONMUMMY || self.tome_finished) &&(head.bodyonflr == MON_ONFLR)) {
                org = Midpoint (head);
                points = 0.5 * vlen(spot - org);
                points = damage - points;
                if (points > 0)
                if (CanDamage (head, inflictor)) {
                    if (points < self.health) points = self.health; // Insta-kill.
					monster_flrbody_gib(head, points);
                }
            }
        } else {
            if (IsMissile (head)) {
                traceline (spot, head.origin, TRUE, self);
                if (trace_fraction == 1) Block_Missile (head, spot);
            }
        }
        head = head.chain;
    }
};

// Super Grenades from Drake
void() SuperGrenade_Think = { // [FUNCTION]
    if (self.delay <= time) { Explode_Grenade();  return; }

    self.angles = vectoangles (self.velocity);
    self.nextthink = time + 0.05;
};

void() SuperRocket_Think = { // [FUNCTION]
	local float seen;

    if (self.delay <= time) {
		other = self.enemy;
        Touch_Missile();
        return;
    }

	spark_spawn();
	spark_spawn();
	spark_spawn();
    self.yaw_speed = self.yaw_speed + self.cnt;     // See launch func below.
    self.velocity = normalize(self.velocity);
    if (self.enemy && self.enemy.health > 0) {
        if (!Invisible(self.enemy)) {
            if (visible(self.enemy)) {
                if (self.wait <= time) {
                    self.wait = time + 0.5;
                    // Use owner instead of master because missile passes owner.
                    if (!self.owner) self.enemy = SuperRocket_Target(self.master, self.origin, self.velocity, 1000, self.volume);
                    else self.enemy = SuperRocket_Target(self.owner, self.origin, self.velocity, 1000, self.volume);
                    if (self.enemy) seen = TRUE;
                }
            }
        }
    }
    if (seen) Missile_Seek_3D (self.enemy);
    self.speed = self.speed + self.height;
    if (self.speed > 1500) self.speed = 1500;
    self.velocity = normalize(self.velocity)*self.speed;
    self.nextthink = time + 0.1;
};

// Sample exploding function to use when calling 'xfx' in 'FireExpShots'
void() TraceExploShell_Think = { // [FUNCTION]
    T_RadiusDamage(self, self.owner, self.dmg, self.enemy, DAMAGEALL);
	R_ExpSmall(self.origin); //Replaced Rocket_Explosion2 (self.origin, 224, 16); with R_ExpSmall and Tent_Explosion2 in order to have more distinct and abrupt blast sound.
	Tent_Explosion2(self.origin, 224, 16);
    BecomeFancy(X32_PUFF_ORANGE, 5);
};

void() FrozenThink = { // [FUNCTION]
	if (self.health < self.cnt) {
		self.count = self.count + (self.cnt - self.health);
		if (self.health < self.gibhealth || self.health < 600) {
            Shattered();
            return;
        }

		sound(self,CHAN_ITEM,"drake/weapons/icehit.wav",1,ATTN_NORM);
	}
	self.cnt = self.health;
	self.think = FrozenThink;
	self.nextthink = time + 0.1;
};

void() Buriza_Think = { // [FUNCTION]
    if (self.delay <= time) { remove (self); return; }

    self.nextthink = time + 0.05;
    self.flags = self.flags - (self.flags & FL_ONGROUND);
    self.velocity = self.dest;
    self.movedir = normalize (self.dest);
    self.angles  = vectoangles(self.movedir);
    Meteor_Trail (41, 1, FALSE);
};

//  Explosion Effects.  This enforces air resistance on embers and updates their angles.  NOTE:  Modified flame has ember scene; frames start at 2, ends at 7.
void() Ember_Think = { // [FUNCTION]
    local vector  dir;

    if (self.delay <= time) { remove (self); return; }
    dir = normalize (self.velocity);  // Update angles to its current direction.
    self.angles = vectoangles(dir) + '90 0 0';
    self.velocity = self.velocity * 0.75; // Cheap hack -- apply air resistance by reducing velocity.
};

// Spawns an ember and smoke in most of its think frames.
void() Smokey_Think = { // [FUNCTION]
	local float ftime;
	local vector spot;

    if (self.wait > time) {
        if (self.enemy.modelindex) {
			ftime = floor(time * 10);
			if (ftime & 1) {
				spot = Midpoint (self.enemy);
				particle (spot, '0 0 100', 1, 5); // Make a thin trail of smoke above the flame, plus a few embers.
				if ((ftime & 2) && !InLiquid(spot)) MakeFlame (self.enemy);
			}
			self.nextthink = time + 0.1;
			return;
		}
	}
    remove(self);
};

//  This makes the fire cause damage to whom it burns.
void() Burn_Burn = { // [FUNCTION]
    local float damage;
    local entity targ;

    if (self.owner.effects & (EF_DIMLIGHT | EF_BRIGHTLIGHT))
        self.effects = self.effects - (self.effects & EF_DIMLIGHT); // Dynamic lights are slow so turn off the flame's light if the burning entity already has light of its own.
    else
        self.effects = self.effects | EF_DIMLIGHT;

    if (self.delay <= time) { // Burn the target.
        targ = self.owner;
        damage = BURN_PER_SECOND;
        if (damage > self.dmg) damage = self.dmg;

        if (damage > 0) { // Negative damage prevention.
            if (targ.health > 0) { // Don't let burn damage gib the dead.
                if (targ.classgroup == CG_ZOMBIE) T_Damage(targ, targ, self.master, damage + 2, DAMARMOR);    // Update 5/13/10:  More damage to zombies to overcome regeneration.
                else T_Damage(targ, targ, self.master, damage, DAMARMOR);
            }
            T_RadiusDamage(self, self.master, damage, self.owner, DAMAGEALL);
        }

        // Subtract from total... after the damage is done because I want
        // the pain sounds done first before tampering with the flame.
        if (!self.deadflag) {
            self.dmg = self.dmg - damage;
            if (self.dmg < 1) { Burn_Null(targ); return; }
        }
        // The fire can burn again after a moment.
        // Note:  findradius is called once per burning entity, and that
        // can mean many times in horde combat scenarios.  To minimize
        // frequent calling, inflict damage once every second, much like
        // slime bathing, even though I wanted more frequent calls.
        self.delay = time + 1;
    }
};

// Check if the flame should be snuffed, else move flame with the entity it is burning and apply damage.
void() Burn_Think = { // [FUNCTION]
    local entity targ;
    local vector spot;
    local float pc;

    targ = self.owner;
    if (!targ) { remove (self); return; }

    self.nextthink = time + 0.100;
	self.think = Burn_Think;
    if (targ.burner != self) { Burn_Null (targ); return; } // This should not happen.

	//if (self.walkframe >= self.pos2_y) self.walkframe = self.pos2_x;
	//else self.walkframe = self.walkframe + 1;

	self.frame = 0;//self.walkframe;

	// From here on in either mode, the flame goes through a four step process:
	// * Check for flame removal.
	// * Move the flame so that it sticks to its target.
	// * Pick behavior based on its new location (e.g., water snuffs most fires).
	// * If flame is still burning, check for damage to targets.
    if (self.deadflag) { // Death mode uses different burn rules.
        if (self.owner.deadflag >= DEAD_DEAD || self.owner.solid == SOLID_NOT) { Smokey(targ); Burn_Null(targ); return; } // Done burning.

        spot = Burn_Point(self.owner); // Move the flame to its target's center point.
        setorigin(self, spot);
        if (InLiquid(spot)) { // Hide the flame and make steam in its place.  Hiss!!
			setmodel(self, "");
			sound(self,CHAN_AUTO,"player/slimbrn2.wav",1,ATTN_NORM);
			particle(spot, '0 0 100', 1, 50);
        } else Burn_Burn(); // Flame is not in the water, keep burning until it's out of fuel.
    } else { // Standard burn mode.
        if (targ.health < 1) { Smokey(targ); Burn_Null(targ); return; } // If enemy is dead, snuff current flame and create smoker that puffs smoke and a few embers for a second or two.
        if (self.dmg < 1) { Burn_Null(targ); return; } // Out of fuel, snuff.
        if (ImmuneToBurning(targ)) { Burn_Null(targ); return; } // Target suddenly can't burn, snuff.

        spot = Burn_Point (targ);
        setorigin(self, spot); // Move the flame.
        pc = pointcontents (spot);
        if (pc <= CONTENT_WATER) { // Check if flame is in the water.
            self.cnt = 1; // Flame disappears instead of exploding.
            Burn_Null(targ); // Snuff it. Sever link between flame and its victim.
            if (pc >= CONTENT_SLIME) { 
                sound(targ,CHAN_AUTO,"player/slimbrn2.wav",1,ATTN_NORM); // Sizzle
				particle (spot, '0 0 100', 1, 50); // In water or slime, make some steam too.  In lava or sky, just disappear.
            } return;
        }
        Burn_Burn(); // Keep on burning.
    }
};

//  Check if fireball is in the water and if so remove it.  Returns TRUE if fireball was removed.
float(entity fire) Fireball_InWater = { // [FUNCTION]
    local float pc;

    pc = InLiquid(self.origin);
    if (!pc) return FALSE; // 8/24/09:  So fire can rain from the sky.

    if (pc == CONTENT_WATER || pc == CONTENT_SLIME) Fireball_Steam(self);
    entity_remove(self,0.1);
    return TRUE;
};

// This is the end of a fireball's think phase.
void() Fireball_EndFrame = { // [FUNCTION]
    if (Fireball_InWater(self)) return;

    // Check if flame should burn things near it.
    if (self.wait) {
        if (self.wait <= time) { // Burn nearby enemies.
            if (self.owner.resist_fire > 0) T_RadiusDamage(self, self.owner, 1, self.owner, DAMAGEALL); // This is so dragons (or players with powerups) don't hurt themselves with their own flames.
            else T_RadiusDamage(self, self.owner, 1, world, DAMAGEALL); // It's a tiny flame so just do damage, nothing fancy.  Negative radius for the constant damage.
            self.wait = time + random();
        }
	}
    self.nextthink  = time + 0.1; // Fire is still burning, check again on the next frame.
};

// This checks when to put out the fire.  The fire is put out when the burning entity finds water or when the fire is done burning.
void() FloorFire_Think = { // [FUNCTION]
    if (self.delay <= time) { // The fire burns itself out after a period of time.
		particle (self.origin, '0 0 100', 1, 50);
        remove (self);
        return;
    }
    Fireball_EndFrame();
};

//  This updates the fireball's angles as it flies through the air.
void() Fireball_Update = { // [FUNCTION]
    local vector dir;

    dir = normalize (self.velocity);
    self.angles = vectoangles(dir) + self.pos1; // Update:  Use variable 'self.pos1' instead of always '90 0 0'.
};

//  This gradually shrinks the fireball into nothing as it flies.
void() Fireball_Fade = { // [FUNCTION]
    if (self.frame >= self.delay) { remove (self);  return; }

    self.frame = self.frame + 1;
    Fireball_Update();
    Fireball_EndFrame();
};

//  This checks the fireball as it flies through the air.
void() Fireball_Think = { // [FUNCTION]
    if (self.delay <= time) { // Make the fireball fade into nothing.  Takes 3 frames to fade.
        self.delay  = 31;
        self.think  = Fireball_Fade;
    }
    Fireball_Update();
    Fireball_EndFrame();
};

//  This checks the big fireball.  It loses strength if it travels through water.  While active, the fireball leaves behind a trail of steam or embers.
void() Meteor_Think = { // [FUNCTION]
    local float rgb, density;

    rgb = 6; // Default trail is steam.
    density = 16;
    if (InLiquid(self.origin)) {
        self.dmg = self.dmg - 10; // Fireball loses strength in water.  Loses 10 damage per frame.  Used to be 10% damage in Dragons.
        self.dmg = SUB_ClampFloat(self.dmg,0,self.dmg);
    } else if (!InLiquid(self.oldorigin)) {
        rgb = 233; // Fireball has not been in water lately, so make an ember trail.
        density = 8;
    }
    Meteor_Trail (rgb, density, TRUE); // Particle trail.
    Fireball_Update(); 
    if (self.dmg <= 0) { Meteor_Fizzle(self); return; } // Fizzle if it lost all power.
    if (self.delay < time) { Meteor_Explode(); return; } // The fireball will explode after a period of time.

    self.nextthink  = time + 0.1; // Fire is still burning, check again.
};

// Animate the flame links in the firewall.
void() Firelink_Think { // [FUNCTION]
    self.walkframe = self.walkframe + 1;
    if (self.walkframe >= self.pos2_y) remove (self);
    else {
		self.frame = self.walkframe;
		particle (self.origin + '0 0 17', '0 0 25', self.volume, self.cnt);
	}
	self.think = Firelink_Think;
	self.nextthink = time + self.pos2_z;
};

void() Firewall_Think = { // [FUNCTION]
    local float pc;
    local vector spot;

    if (self.delay <= time) { remove (self);  return; }   // Time's up.

    pc = pointcontents (self.origin);
    if (pc == CONTENT_SOLID) { remove (self);  return; }   // In the void.

	if (self.classgroup == CG_PROJCELLS) {
		// Spawn a lightning bolt.
		traceline (self.origin, self.origin + '0 0 4096', TRUE, self);
		spot = trace_endpos;
		LightningBolt(spot,spot - '0 0 8192',self.master,self.dmg,self,TE_LIGHTNING2);
		particle (trace_endpos, trace_plane_normal, 41, 10);
	} else if (self.classgroup == CG_PROJFIRE) {
		// Spawn a flame.
		traceline(self.origin, self.origin - '0 0 600', TRUE, self);
		spot = trace_endpos;
		pc = pointcontents (spot); // Spawn a flame only if there is open space on the ground.
		if (trace_fraction < 1 && pc != CONTENT_SOLID && pc != CONTENT_SKY) Firelink_Spawn(spot,(pc == CONTENT_EMPTY));
	}

    if (self.enemy) { // Steer toward the enemy.
        spot = self.enemy.origin + self.enemy.view_ofs;
		spot = Aim_LineEx(self.origin,spot,SPEED_FIREWALL,self.enemy,1); // Change yaw only.  Plots intercept course.
		self.ideal_yaw = vectoyaw(spot);
		self.ideal_yaw = anglemod(self.ideal_yaw);
		ChangeYaw();  // Change yaw only.   
        spot = self.angles;
        spot_x = 0 - spot_x;
        makevectors(spot);
        self.movedir  = v_forward; // Update direction.
    }
    self.velocity   = self.movedir * self.speed;
    self.angles     = vectoangles(self.velocity);
    self.nextthink  = time + 0.05;
};

void() faspell_frames = { // [FUNCTION]
	local float old_angle, old_count;
	local vector new_posA, new_posB, posA, posB;

	self.think = faspell_frames;
	self.nextthink = time + HX_FRAME_TIME;
	SUB_AdvanceFrame(0,8);
	old_angle = self.spell_angle;
	old_count = self.count;
	self.spell_angle += random(32,42);
	if (self.spell_angle >= 360) self.spell_angle -= 360.00000;
	if (self.count < 6) self.count += 0.60000;
	makevectors(self.angles);
	posA = ((v_right * mathlib_sin(self.spell_angle)) * self.count);
	posB = ((v_right * mathlib_sin(old_angle)) * old_count);
	new_posA = (posA - posB);
	posA = ((v_up * mathlib_cos(self.spell_angle)) * self.count);
	posB = ((v_up * mathlib_cos(old_angle)) * old_count);
	new_posB = (posA - posB);
	new_posA += new_posB;
	walkmove(self.angles_y, vlen(new_posA - new_posB));
	if (self.lifetime < time) remove(self);
};

void() FlareGlitter_Think = { // [FUNCTION]
    self.frame = self.frame + 4;
    if (self.flags & FL_ONGROUND) self.nextthink = time + 0.1;
    else self.nextthink = time + 0.2;

    self.think = SUB_Remove;
};

void() Flare_Think = { // [FUNCTION]
    local float den;

    if (self.delay <= time) { 
		if (self.effects & EF_BRIGHTLIGHT) {
            self.effects = EF_DIMLIGHT;
			self.delay = time + 2;
        } else {
            remove (self);
			return;
		}
    }

    self.nextthink = time + 0.1;
    self.think = Flare_Think;
    if (self.lefty) FlareGlitter();
    else { // Spawn some particles at the source.
        den = ceil(self.delay - time) * 4;
        if (den > 254) den = 254;
        particle(self.origin,VEC_ORIGIN,232,den);
    }
    self.lefty = !self.lefty;
};

// Activates the spark generator that was spawned recently.
void() Flare_Activate = { // [FUNCTION]
    self.velocity = '0 0 -10';
    self.effects = EF_BRIGHTLIGHT;
    self.delay = time + 3;
    Flare_Think();
};

void() Animate_HazardProjectile = {
	// Check if owner of flame is busy and needs flame to stop!
	if (self.owner.part_exitbusy > 0 && self.part_exitbusy == FALSE) {
		// Kill the entity this frame (0) or the next (+0.05)
		if (random() < 0.5) self.attack_finished = 0;
		else self.attack_finished = time + 0.05;
		// Randomly get rid of half of all smoke puffs
		if (self.part_exitpuff && random() < 0.5)
			self.part_exitpuff = FALSE;
		// Block this feature, its finished
		self.part_exitbusy = TRUE;
	}
	// Projectile has run out of time (cope with hazard counters)
	if (self.attack_finished < time) { HazardProjectile_Finished(self); return; }
	
	// Animate sprite
	self.walkframe = self.walkframe + 1;
	if (self.walkframe >= FRAME_FLAME) self.walkframe = 0;
	self.frame = self.walkframe;
	
	// Keep playing ambient sound
	if (self.noise != "" && self.volume < time) {
		sound(self,CHAN_AUTO,self.noise, 0.3,ATTN_IDLE);
		self.volume = time + 1;
	}

	// Advanced engines?
	if (ext_dppart) {
		// Way to disable DP/FTE/QSS particle effects
		if (self.owner.dpp_flame > 0) {
			// Really need low particle rate (can trash frame rate)
			if (query_configflag(SVR_SPRPARTON) == FALSE && random() < self.owner.dpp_flame) {
				// Only use this for the red flames
				if (self.part_style == PARTICLE_BURST_RED)
					// Use the small flame particle effect (dots+smoke)
					pointparticles(particleeffectnum(DPP_FLAMES), self.origin, '0 0 0', 1);
			}
		}
	}// else {
	if (random() < 0.05) SpawnProjectileSmoke(self.origin, 200, 50, 250); // Random particle spark
	if (random() < self.part_chance) particle_explode(self.origin+self.part_ofs, self.part_base+random()*self.part_rand, self.part_life+random(), self.part_style, 0); // Random particle burst, expects defaults have been setup
	//}
	
	// Keep looping
	self.think = Animate_HazardProjectile;
	self.nextthink = time + 0.1;	
};

void() Fire_Trail = {
	local float trblocked, trstepup;

	if (self.count < 0) return; // Flame trail inactive
	
	// Check if the hazard projectile limit exists and has been reached?
	if ( !(HazardProjectile_CheckLimit(self.owner,1)) ) trblocked = TRUE;
	else {
		trblocked = trstepup = FALSE; // default condition
		// Move forward along the line (movedir)
		self.pos2 = self.pos1 + (self.movedir * self.owner.proj_trdist);
		// Is next position is solid world/geo?
		if (InSolid(self.pos2)) {
			// Check maximum step height is available?
			if (InAir(self.pos2 + self.finaldest)) { // Fire must have air.
				// Trace down from maximum step height to find new pos
				traceline(self.pos2 + self.finaldest, self.pos2, TRUE, self);
				self.pos2 = trace_endpos + '0 0 8';
				trstepup = TRUE;
			} else trblocked = TRUE; // Max step height is solid geo/world
		}
		
		if (!InAir(self.pos2)) { // Is next position solid, liquid or sky?
			trblocked = TRUE;
		} else {
			// Can previous position see next position? nothing blocking
			traceline(self.pos1, self.pos2, TRUE, self);
			// 'STEP UP' will often block line of sight to next point
			if (trace_fraction < 1 && trstepup == FALSE) trblocked = TRUE;
			else {
				traceline(self.pos2, self.pos2 - (self.finaldest*2), TRUE, self); // Find ground below next step point
				self.t_length = fabs(self.pos1_z - trace_endpos_z); // Check distance between step points
				if (self.t_length > (self.owner.proj_trstep+8)) trblocked = TRUE; // Can only step up or down a certain distance
				if (!InAir(trace_endpos)) trblocked = TRUE; // Check final position is not solid,liquid or sky
			}
		}
		
		// Is the next sprite blocked?
		if (trblocked == FALSE) {
			self.pos1 = trace_endpos; // Update line position (next point)
			self.height = self.owner.proj_trlife + random() + random(); // Random lifetime
			self.pos3 = vecrand(0, self.owner.proj_trwobble, TRUE); // Setup random wobble to origin for new flame
			self.pos3_z = 0; self.pos3 = self.pos3 + self.pos1; // Flatten any z changes first
			Launch_Flame (self.owner, self.pos3, '0 0 0', self.lip, -1, self.height, 0); // target, origin, v_forward, colour, size, lifetime, speed
		}
	}

	// Keep counting down
	self.count = self.count - 1;
	// reach end of the line?
	if (self.count <= 0 || trblocked == TRUE) {
		self.count = 0;
		self.origin = self.pos1 + '0 0 24';
		// Move to explosion for t_radiusdamage
		setorigin(self, self.origin);
		SpawnExplosion(self.attack_expflame, self.origin, self.noise);
		// Any explosive damage?
		if (self.owner.proj_trdmg > 0)  T_RadiusDamage(self, self.owner, self.owner.proj_trdmg, world, DAMAGEALL);
	} else {
		// Keep looping
		self.think = Fire_Trail;
		self.nextthink = time + self.speed;
	}
};

void() pyroflame_think = {
	self.cnt = self.cnt + 1;
	if (self.cnt > 6) remove(self);
	else {
		self.frame = self.cnt;
		// Randomly drift upwards and slow down forward movement
		self.velocity_z = self.velocity_z + 10 + (random() * 20);
		self.velocity = self.velocity - (self.movedir * 0.125);
		self.nextthink = time + 0.1;
	}
}

//  Smart Fireballs -- Used by nemesant (and SoE sorcerer).
void() SmartBall_Think = { // [FUNCTION]
    if (self.delay <= time) { remove(self); return; }

    self.angles = vectoangles(self.velocity);
	// Changed particle count from 25 at 10/sec to 10 at 20/sec.  2000 speed rocket trails spawn 11 at about 50/sec.
    particle (self.origin, '0 0 1', 233, 10);   //particle (self.origin, '0 0 1', 233, 25);
    self.nextthink = time + 0.05;               //self.nextthink = time + 0.1;
};

void() SmartBall_Bounce = { // [FUNCTION]
    local   vector  p1, p2;
    local   float   up;

    p1 = self.origin;
    p2 = self.enemy.origin + self.enemy.view_ofs;   // Go for the eyes.
    up = Aim_TossUp (p1, p2, 400);
    self.flags = self.flags - (self.flags & FL_ONGROUND); 
    self.velocity = Maim_SmartBall(p1, p2, 400, up, world, '0 0 0'); // Fireballs can be fooled by invisibility.
    self.velocity = self.velocity * 400;
    self.velocity_z = self.velocity_z + up;
    self.angles = vectoangles(self.velocity);
    self.nextthink = time + 0.01;
    self.think = SmartBall_Think;
};

//  Tornado -- Used by the wind baron.  Sucks in targets near the cone, and damages those already in it.
void() Tornado_Attack = { // [FUNCTION]
    local entity head;
    local vector delta, spot, vel;
    local float hit;

	// Note:  Walls offer no protection against the baron's tornado.
    head = findradius (self.origin, 256);
    while (head) {
        if (head != self)
        if (head != self.master)
        if (head.origin_z + head.maxs_z >= self.origin_z) { // Head must be at or above spawnpoint.
            // Get horizontal distance between target and center.
            spot = head.origin;  spot_z = self.origin_z;
            delta = self.origin - spot;     // delta_z should be 0.

            // First, inflict some damage.
            hit = (vlen(delta) < 100);
            if (hit) T_Damage(head,self,self.master,self.dmg,DAMARMOR);

            // Next, suck the target into the vortex if possible.
            if (((head.flags & FLx_CREATURE) && head.mass <= MASS_HEAVY) || (AffectedByPhysics(head)) && head.movetype != MOVETYPE_NONE) {
                if (hit || (head.flags & FL_MONSTER)) { // Sweep the target off its feet.
                    if (!hit && (head.flags & FL_ONGROUND) && head.velocity_z < 80) head.velocity_z = 80;
                    head.flags = head.flags - (head.flags & FL_ONGROUND); // Walkers lose control of movement.
                }
                vel = head.velocity;
                vel_x = vel_x * 0.5;
                vel_y = vel_y * 0.5;
                if (hit) {
                    vel_z = vel_z * 0.5;
                    if (vel_z < 150) vel_z = 150; // Float up and away.
                }
                head.velocity = vel + normalize(delta) * 100;
            }
        }
        head = head.chain;
    }
};

// Thinking for the smoke particles in the tornado.
void() tornado2 = [ 0, tornado2 ] { // [FUNCTION]
    local vector spot, trig, dir;

    if (self.delay <= time) { remove (self); return; }

    self.speed = self.speed + 8;
    self.height = self.height + 24;
    self.cnt = anglemod (self.cnt + 47);
    spot = self.oldorigin;
    spot_z = spot_z + self.height;
    trig = CoSine(self.cnt);
    dir = (('1 0 0' * self.speed) * trig_x) + (('0 1 0' * self.speed) * trig_y);
    spot = spot + dir;
    setorigin(self, spot);
};

// Think function for the tornado.  Spawns all of its effects.
void() tornado1 = [ 0, tornado1 ] { // [FUNCTION]
    if (self.delay <= time) {
        super_active = FALSE;
        StopSound (self, 6);
        remove (self);
        return;
    }

    if (self.t_width < time) {
        self.t_width = time + 1;
        sound(self,CHAN_AUTO,"drake/baron/tornado.wav",1,ATTN_NORM);
    }
    Tornado_Attack();
    self.height = (self.height + 3) & 7;
    self.cnt = anglemod(self.cnt + 107);
    newmis = spawn();
    newmis.owner      = self;
    newmis.movetype   = MOVETYPE_NOCLIP;
    newmis.solid      = SOLID_NOT;
    newmis.velocity   = '0 0 0';
    newmis.nextthink  = 0.01;
    newmis.delay      = time + 1.2;     // FIXME:  Use T+1?
    if (newmis.delay > self.delay) newmis.delay = self.delay;     // Last no longer than parent.
    newmis.think      = tornado2;
    newmis.cnt        = self.cnt + self.height;
    newmis.oldorigin  = self.origin;
    setall(newmis, "progs/drake/smoke.mdl", '0 0 0', '0 0 0', self.origin);
};

void() vermis_spore_think = {
	if (self.ltime < time) vermis_spore_explode();
	self.nextthink = time + 0.1;
	self.think = vermis_spore_think;
};