//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: Drake by Patrick Martin
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
// Function count: 21
//
// Implements: MIRV (Multiple Independently Targeted Reentry Vehicles)
//
// Description:
// For the MIRV weapon.  Launches a tracking rocket that follows player's view
// and then splits when player fires again into 4 mini rockets that home in on
// nearby monsters.  Effective for large groups of fliers.
//=============================================================================

//  Target Selection.  This checks if the target is inside the targeting box.  Attacker must be a client to work properly.  Non-clients that try to use this will likely get a result of FALSE.
 // TRUE = Target is in the box, FALSE = Target is outside.
float(entity targ, entity client) BfgLock_InSight = { // [FUNCTION]
    local vector vec, v1, v2;
    local float dot;

    v1 = client.origin + client.view_ofs;
    v2 = Midpoint (targ);
    vec = normalize (v2 - v1); // Check if the target is within the v_weapon's targeting box.
    makevectors (client.v_angle);
    dot = vec * v_forward;
    if (dot < LOCK_DOT_YAW) return FALSE; // NOT in the box.
    if (dot >= LOCK_DOT_PITCH) return TRUE; // Certainly IN the box.

    // We know the target is within the left and right bounds.  However, we don't know if the target is truly within the top and bottom bounds.  
    v1 = vectoangles(v_forward);
    v2 = vectoangles(vec);
    v1_x = 0 - v1_x; // Therefore, we need to create a vector whose pitch is the same as the aim vector AND whose yaw is the same as the ideal vector.  This fixes pitch reversal.  
    v1_y = v2_y;
    makevectors (v1);
    return (vec * v_forward) >= LOCK_DOT_PITCH; // Then we need to find the dot product of the new and ideal vectors.  If dot is greater than or equal to vertical dot, target is in the box.
};

// This checks if the target should be targeted by the weapon system.
float(entity targ, entity sensor, entity attacker) BfgLock_Confirm = { // [FUNCTION]
    local vector p1, p2;

    if (targ == attacker) return FALSE; // Don't turn on the attacker.
    if (!targ.takedamage) return FALSE; // Target must be mortal and solid. This will stop here in case targ is the world.
    if (targ.solid <= SOLID_TRIGGER) return FALSE;   // Ethereal, not solid. solid_not is less than trigger.
    if (targ.invisible_finished) return FALSE; // Target must not have stealth tech.
    if (targ.flags & FL_NOTARGET) return FALSE;

    p1 = sensor.origin + sensor.view_ofs; // Sensor entity must see the target. If sensor equals attacker, he must see target as the weapon would.
    p2 = Midpoint (targ);
    traceline (p1, p2, TRUE, sensor);
    if (trace_fraction < 1) return FALSE;   // Blocked!
    if (trace_inopen && trace_inwater) return FALSE;   // Lock cannot cross contents.
    if (Ally_Check (targ, attacker)) return FALSE; // Check relations to avoid friendly fire.
    return TRUE; // Target is confirmed.
};

// AreaBlaster = Fireballs that tear through and grind targets for a while before exploding.  Similar to the AreaBlaster special from the NES game
// The Guardian Legend.  For a more recent example, the ghosts from Hexen's priest weapon Wraithverge.
void() AreaBlaster_Touch = { // [FUNCTION]
    if (pointcontents(self.origin) == CONTENT_SKY) {remove (self); return;}
    if (Reflected()) return;

    if (other.takedamage) T_Damage (other, self, self.master, self.cnt, IGNORECLASS);
    else Tent_Point (TE_KNIGHTSPIKE, self.origin);

    if (other.solid != SOLID_BSP) self.owner = other;
};

// Alternate explosion function for warheads.
void() SmallExplosion = { // [FUNCTION]
    Rocket_Explosion2(self.origin, 96, 16);
    BecomeExplosion();
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
			T_Damage (other, self, self.owner, self.dmg, DAMARMOR);
			T_RadiusDamage (self, self.owner, self.dmg, other, DAMAGEALL);
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
        self.flags      = self.flags - FL_ONGROUND;
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

// Spawns and launches a payload warhead.  'self' is its parent MIRV.
void(vector start, vector dir, float ang, entity targ1, entity targ2) Warhead_Launch = { // [FUNCTION]
    newmis = spawn();
    if (self.tome_finished) {
		setmodel(newmis,"progs/drake/k_ball.mdl");
		newmis.distance   = 0;    // Constant speed during flight.
        newmis.yaw_speed  = 40;   // Faster turn speed.
        newmis.touch      = AreaBlaster_Touch;
    } else {
		setmodel(newmis,"progs/drake/memissil.mdl");
		newmis.distance   = rint(self.speed * 0.05);  // Acceleration per frame.
		newmis.yaw_speed  = 30;   // Turning speed in degrees.  10 thinks/sec.
		newmis.touch      = T_MissileTouch;
	}
    setsize(newmis, '0 0 0', '0 0 0');
    setorigin(newmis, start);
    newmis.movetype   = MOVETYPE_FLYMISSILE;
    newmis.solid      = SOLID_BBOX;
    newmis.angles     = vectoangles(dir);
    newmis.t_length   = ang;  // Affects warhead's spiraling flight path.
    newmis.t_width    = 0;    // Ditto.
    newmis.speed      = self.speed;
    newmis.dmg        = 95; //self.cnt;
	newmis.pos1 		= '95 0 135';	// Base + Random, Splash
    newmis.delay      = time + 2 + random() * 0.5;    // Grenades are 2.5.
    newmis.style      = self.style;
    newmis.cnt        = AREABLASTER_DAMAGE;
    newmis.wait       = time + 0.2;   // AreaBlaster retouch time.
    newmis.velocity   = dir * self.speed;
    newmis.nextthink  = time + 0.3;   // Give time for payload to spread.
    newmis.think      = Warhead_Think;
	newmis.height = EXPLODE_SMALL;
    newmis.master     = self.master; // Use 'master' instead of 'owner' so warheads can strike attacker.
    newmis.owner      = world;
    newmis.enemy      = targ1;
    newmis.oldenemy   = targ2;
    newmis.classname  = "mirv";   // Use the same obits as its parent.
    newmis.movedir    = dir;
    newmis.think1     = SmallExplosion;
    newmis.tome_finished  = self.tome_finished;
};

// Guided Missile.  This selects targets for the payload warheads to lock on to.  Returns the best target as the head of a list of viable targets.
entity() Payload_Target = { // [FUNCTION]
    local entity best, head, ent;
    local vector org, vec, forwardfacing;
    local float dist, dot, pc, in;

    ent = self.master;
    pc = ent.flags & FL_CLIENT;
    best = world;
    org = self.master.origin + self.master.view_ofs;
    head = findradius(org, LOCK_RANGE);
    if (pc) {
		makevectors (self.master.v_angle);
        forwardfacing = v_forward;
    } else forwardfacing = normalize (ent.enemy.origin - ent.origin);

    while (head) {
        if (BfgLock_Confirm (head, self.master, self.master)) {
            vec = Midpoint(head) - org; // Path toward target.
            dot = normalize(vec) * forwardfacing;
            if (dot >= LOCK_DOT_YAW) { // Assumes constant > 0.
                if (pc) in = BfgLock_InSight (head, self.master); // Check if the target is within the gun sights.
                else in = TRUE;  // Always so for npcs.

                if (in) { // Take this target!
                    dist = vlen(vec) / dot; // Treat targets that are not perfectly lined up further away than they really are.  Like squaring the circle.
                    head.rate2 = dist;
                    if (!best || (dist < best.rate2)) { // Place at the head of the list.
                        head.chain2 = best;
                        best = head;
                    } else { // Placed somewhere under head.
                        ent = best;
                        while (ent) {
                            if (!ent.chain2 || (dist < ent.chain2.rate2)) { // Insert into list then get out of loop.
                                head.chain2 = ent.chain2;
                                ent.chain2 = head;
                                ent = world;
                            }
                            if (ent == ent.chain2) ent = world;    // Avoid infinite loop.
                            else ent = ent.chain2;
                        }
                    }
                }
            }
        }
        head = head.chain;
    }
    return best; // Return the head of the hitlist.
};

// This launches all the warheads in a MIRV's payload.
void() Mirv_Payload = { // [FUNCTION]
    local entity first, head, t1, t2;
    local float loop, hi, theta, qcsin, qccos;
    local vector dir, trig, vx, vy, vz;

    dir = Vangles(self.movedir);
    makevectors(dir); // Get unit vectors along the three axes.
    vx = v_forward; vy = v_right; vz = v_up; // Necessary because CoSine() calls makevectors again and musses them up.
    hi = self.count; // Set loop counter equal to the number of warheads to spawn.
    if (hi < 2) hi = 2; // By definition, MIRVs carry at least two warheads.
    loop = hi;
    hi = 360 / hi;

	// Acquire a list of viable targets.
    if (self.state) head = Payload_Target ();
    else head = world;
    first = head;

    trig = CoSine(10);
    qccos = trig_x; // Approximate cos of 10deg
    qcsin = trig_y; // Approximate sin of 10deg

	// Spawn each payload missile.
    while (loop) {
        if (head) {
			t1 = head;
            head = head.chain2;
            if (!head) head = first;
            t2 = head;
        } else t1 = t2 = world;

        theta = anglemod (loop * hi + 90);
		trig = CoSine (theta);
        dir = (vx*qccos) + ( ((vy*trig_x) + (vz*trig_y))*qcsin );
        Warhead_Launch (self.origin, dir, theta, t1, t2);
        loop = loop - 1;
    }
};

// Checks if the weapon's targeting system is offline.
float() Mirv_Off = { // [FUNCTION]
    if (self.master.mirv1 != self) return TRUE; // Previously went offline.
    if (self.weapon != self.master.weapon && self.selfweaponismoditems != self.master.selfweaponismoditems) return TRUE; // Not holding the launching weapon.
    if (frame_pause()) return TRUE; // In a cutscene or intermission
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

// Called when a MIRV slams into something before releasing its payload.
void() Mirv_Touch = { // [FUNCTION]
    Mirv_Reset (); // Turn off control.
    if (pointcontents(self.origin) == CONTENT_SKY) {remove (self); return;}
    if (Reflected_Damage (COURAGE_DAMAGE)) return;

    if (self.tome_finished) Mirv_Payload(); // Unleash AreaBlaster payload.
    self.touch = SUB_Null; // Stack overflow prevention.
    self.enemy = other;
	if (!self.dmg) self.dmg = 120;
	if (self.dmg > 0 && other.health > 0) {
		T_Damage (other, self, self.owner, self.dmg, DAMARMOR);
		T_RadiusDamage (self, self.owner, self.dmg, other, DAMAGEALL);
		if (other.resist_rockets > 0 || (other.resist_multi_rockets && self.classgroup == CG_PROJMULTIROCKETS)) Resist_Effects(other,self.origin,VEC_ORIGIN,0,AM_ROCKETS,other.pain_sound,SOUND_RESIST_ROCKET); // Rocket resistance is shown with puffs of smoke
	} else {
		// Check for poison debuff (using poisonous flag)
		if (self.poisonous == TRUE) {
			self.height = EXPLODE_POISON_MED; // Use new poison explosion
			PoisonDeBuff(other); // Poisonous projectiles
		}

		T_RadiusDamage (self, self.owner, self.pos1_z, other, DAMAGEALL);
	}
	
	self.origin = self.origin - 8*normalize(self.velocity); // Move the explosion effect higher up from point of contact
	if (self.noise == "") self.noise = SOUND_REXP3; // Play original explosion sound or replacement
	R_Exp3(self.origin);
	Tent_Explosion(self.origin);
	BecomeExplosion2 ();
};

// This causes to split into multiple small rockets, releasing its payload.
void() Mirv_Split = { // [FUNCTION]
    Mirv_Reset ();
    sound (self, CHAN_WEAPON, "drake/weapons/mirv2.wav", 1, ATTN_NORM);
    self.effects = self.effects | EF_MUZZLEFLASH;
    Mirv_Payload ();
    BecomeExplosion();
};

// Lets 'self' use a linked MIRV by releasing its payload.
void() Mirv_Use = { // [FUNCTION]
    if (self.mirv1) { // Enforce a brief delay so the attacker cannot hit himself with the payload because the MIRV split too close after launch.
        if (!self.mirv1.th_win) self.mirv1.th_win = Mirv_Split;
        if (time - self.mirv1.search_time > 0.3) {
            SUB_ThinkImmediate (self.mirv1, self.mirv1.th_win);
        } else self.mirv1.delay = time + (time - self.mirv1.search_time); // Can't use it now.  Since attack was released, MIRV will split.  Reducing fuel to ensure the split is an ugly but simple hack.
    }
};

// Missile think.  Attacker guides the MIRV by sight.
void() Mirv_Think = { // [FUNCTION]
    local entity ent;
    local vector dir, org, vec;

    if (!self.th_win) self.th_win = Mirv_Split;
    if (self.delay <= time) { self.th_win (); return; }  // Out of fuel, release payload.
    if (Mirv_Off()) { Mirv_Split(); self.nextthink = self.delay; self.think = self.th_win; return; } // MIRV launcher inactive.
	if (self.state == 0) return;

    ent = self.master;
    dir = self.movedir;
    if (visible (ent)) { // Fly toward the spot its owner is aiming at. Missile must 'see' its owner.
        if (ent.flags & FL_CLIENT) {makevectors (ent.v_angle); vec = v_forward; }
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

// This spawns and launches a MIRV.
void(vector start, vector dir) Mirv_Launch = { // [FUNCTION]
    newmis = spawn();
    setmodel (newmis, "progs/drake/rocket1.mdl");
    setsize (newmis, '0 0 0', '0 0 0');
    setorigin (newmis, start);
    newmis.movetype   = MOVETYPE_FLYMISSILE;
    newmis.solid      = SOLID_BBOX;
    newmis.angles     = vectoangles(dir);
	newmis.classgroup = CG_PROJROCKETS;
    newmis.speed      = 500;
    newmis.yaw_speed  = 40;       // Turning speed in degrees.  5 thinks/sec.
    newmis.delay      = time + 16;    // 500 * 16 = 8K range.  Was T+10.
    newmis.dmg        = 190;          // MIRV damage.  See below for details.
	newmis.pos1		= '190 0 230';
    newmis.count      = COST_MIRV;    // Number of warheads in payload.
    newmis.cnt        = 95;   // Warhead damage, same power as Hip proxy bomb.

	// damage | radius |  volume (4*pi*r*r*r/3)
	//--------+--------+------------
	//    95  |   135  | 10305994.7
	//   190  |   230  | 50965010.4
	//
	// MIRVs release five warheads.  If a MIRV explodes before releasing
	// its payload, make a single large blast with the combined blast volume
	// (not damage) from each warhead.
	//
	// Note that the sphere with 230 radius has roughly five times more volume
	// than the sphere with 135 radius.
	//
	// If you want to change warhead damage, make sure MIRV radius is
	// 1.71 (or cube root of 5) times warhead radius.
    newmis.velocity   = dir * newmis.speed;
    newmis.touch      = Mirv_Touch;
    newmis.nextthink  = time + 0.2;
    newmis.think      = Mirv_Think;
    newmis.master     = newmis.owner    = self;
    newmis.enemy      = world;
    newmis.classname  = "mirv";
    newmis.movedir    = dir;
    newmis.tome_finished  = self.tome_finished;
    newmis.search_time= time;
    newmis.state      = 1;    // Warhead auto-targeting: 0 = off, 1 = on.
    newmis.weapon        = self.weapon;
	newmis.selfweaponismoditems = self.selfweaponismoditems;
    newmis.think1     = BecomeBigBang;    // Use alternate explosion code.
    newmis.th_win     = Mirv_Split;
    if (self) self.mirv1 = newmis;
};

// Called when player launches a MIRV.
void() W_FireStinger = { // [FUNCTION]
    local vector start;

    if (self.ammo_rockets < COST_MIRV) return;

    self.currentammo = self.ammo_rockets = self.ammo_rockets - COST_MIRV; // Cost of admission paid.  Launch the big missile.
    sound (self, CHAN_WEAPON, "drake/weapons/mirv1.wav", 1, ATTN_NORM);
    self.punchangle = '6 0 -12';
    makevectors (self.v_angle);
    self.velocity = self.velocity - (v_forward * 100);  // Recoil!
    start = self.origin + self.view_ofs + (v_forward*8) + (v_right*8);
    Mirv_Launch (start, v_forward);
};

// Hydra/Drunk Missiles.  Not part of the MIRVs, but this borrows some code from there.
void() DrunkRocket_Think = { // [FUNCTION]
    local vector dir, vec;

    if (self.delay <= time) { // Pop when out of fuel.
        self.enemy = world;
		if (!self.dmg) self.dmg = 120;
		if (self.dmg > 0 && other.health > 0) {
			T_Damage (other, self, self.owner, self.dmg, DAMARMOR);
			T_RadiusDamage (self, self.owner, self.dmg, other, DAMAGEALL);
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
			BecomeExplosion2 ();
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

void(entity attacker, vector start, vector dir, float damage,entity targ1, entity targ2) DrunkRocket_Launch = { // [FUNCTION]
    newmis = spawn();
    newmis.master       = newmis.owner      = attacker;
    newmis.movetype     = MOVETYPE_FLYMISSILE;
    newmis.solid        = SOLID_BBOX;
    newmis.classname    = "rocket";
    newmis.yaw_speed    = 40;   // Note:  Missiles think 5/sec, not 10/sec.
    newmis.speed        = 450;
    newmis.height       = 50;
    newmis.movedir      = dir;
    newmis.velocity     = dir * 600;
    newmis.angles       = vectoangles(newmis.velocity);
    newmis.dmg          = damage;
	newmis.classgroup = CG_PROJROCKETS;
    newmis.enemy        = targ1;
    newmis.oldenemy     = targ2;
    newmis.ideal_yaw    = newmis.angles_y;
    newmis.cnt          = 20;   // Random angle used for drunken flight.
    newmis.touch        = T_MissileTouch;
    newmis.delay        = time + 2 + random() * 0.5;    // Grenades are 2.5.
    newmis.nextthink    = time + 0.2;
    newmis.think        = DrunkRocket_Think;
    newmis.think1       = SmallExplosion;
    setall (newmis, "progs/drake/memissil.mdl", '0 0 0', '0 0 0', start);
};

// Splits the missile and launches all payload missiles.
void() Hydra_Split = { // [FUNCTION]
    local vector start, dir, vx, vy, trig;
    local entity t0, t1, t2;
    local float loop, cost;

    loop = self.count;
    cost = loop - 1;
    start = self.origin;
    dir = self.angles;  dir_x = 0 - dir_x;
    makevectors (dir);
    vx = v_forward;
    vy = v_right;
    t0 = t1 = SuperRocket_Target(self.master, start, v_forward, 2000, 0.3); // Search for targets infront of the parent missile.
    while (loop > 0) {
        t2 = t1.chain2;
        if (!t2) t2 = t0;
        loop = loop - 1;
        trig = CoSine((cost - loop * 2) * 10);     // 20 degrees of separation.
        dir = (vx*trig_x) + (vy*trig_y);
        DrunkRocket_Launch(self.master, start, dir, 90, t1, t2);
        t1 = t2;
    }
    remove(self);
};

// Launches a small MIRV that splits into mini-rockets a few frames
// after launch.  One big rocket causes less backlash than several
// smaller rockets.
//
// I wanted a multi-rocket launcher, much like a shotgun that fires rockets
// instead of pellets, but backlash from multiple rockets at point-blank
// causes too much damage and knockback.  Instead, a MIRV is launched.
// See above for details.
void() W_FireHydra = { // [FUNCTION]
    local vector start, dir;
    local float cost;

    if (self.ammo_rockets < 1) return;

    cost = 3;
    if (self.ammo_rockets < cost) cost = self.ammo_rockets;
    self.currentammo = self.ammo_rockets = self.ammo_rockets - cost;
    sound(self, CHAN_WEAPON, "zerstorer/weapons/stunfire.wav", 1, ATTN_NORM);
    self.punchangle_x = -2;
    makevectors (self.v_angle);
    start = self.origin + v_forward*8 + '0 0 16';
    dir = v_forward;
	Launch_Missile(start, dir, '0 0 0', CT_PROJ_ROCKET, SPEED_RLPLAYER);
    newmis.velocity = dir * 600;
    newmis.count    = cost;         // # of warheads after splitting.
    newmis.nextthink= time + 0.2;
    newmis.think    = Hydra_Split;
    if (cost >= 2) { // Make bigger explosion if payload includes multiple rockets.
        newmis.dmg      = cost * 30 + 60;
        newmis.think1   = BecomeBigBang;
    }
};