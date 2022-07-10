//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: All, though primarily Arcane Dimensions (AD) and Drake by
//               Patrick Martin
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
// Function count: 
//
// Implements: Projectile Aiming Prior To Launching, Shot Leading System
//
// Description:
// Generic functions for determining direcion and velocity of subsequently
// fired projectiles.  These do not actually spawn projectiles but handle only
// the aiming and other calculations prior to calling launch_projectile.
//
// Includes Drake's shot leading system:
// Adjusts firing angles based on target's velocity for smart aiming.
//
// The set of numbers in the 'spread' vectors passed to these aim
// functions are angles, not their tangents.
//
// Why pass the angles?  Because the values returned by crandom() with
// tangents passed to it tends to favor the edges.  For example, passing
// a tangent of 10000000 to crandom will very likely return a value that,
// if you calcualated its inverse tangent, be 89.x degrees.
//
// By passing the angle instead, there is no bias for any angle, assuming
// the random() function does its job.  After randomization, the angle may
// be converted to a tangent for whatever purpose.
//=============================================================================

// This returns the coefficient that multiplies an entity's velocity.
float(entity ent) Aim_SpeedMod = {
    local   float sped;

    sped = 1;
    if (ent.flags & FL_CLIENT) { // Only a player is affected by all of these events.
        if (ent.waterlevel == 3) {
            if (ent.wetsuit_finished > time) sped = 1.5;
        } else if (ent.waterlevel == 2) {
            if (ent.wetsuit_finished > time) sped = 1.25;
        }
        if ((ent.curse_type == CURSE_SLOW) || ent.slow_finished) sped = sped / 2; // Update: 10/29/10:  Check all sources of slow.
    }
    return sped;
};

//  This checks if an entity is falling.  Used by entities who lead shots.
float(entity ent) IsFalling = {
    // Not falling if flying, swimming, or already on the ground.
    if (ent.flags & FLx_NOT_FALLING) return FALSE; // Fly + Swim + FL_ONGROUND
    if (ent.movetype == MOVETYPE_FLY) return FALSE; // Flying
    if (ent.movetype == MOVETYPE_NOCLIP) return FALSE; // or ethereal targets
    if (ent.movetype == MOVETYPE_FLYMISSILE) return FALSE; // cannot fall.
    if (ent.movetype == MOVETYPE_WALK) { // Players need extra checking.
        if (ent.waterlevel >= 2) return FALSE;   // Swimming.
		if (ent.onladder > 0) return FALSE; // Climbing.
    }
    return TRUE; // Target is falling.
};

//  Check if target's vertical velocity should be ignored.
float(entity ent) Aim_IgnoreZ = {
    // A player swimming along the surface of water has a velocity that oscillates up and down constantly and should be ignored.
    // Flight via Dark Angel wings also has a similar effect in the air.
    if (ent.movetype == MOVETYPE_WALK) {
        if (!(ent.flags & FL_ONGROUND)) {
            if (ent.waterlevel)
                if (ent.waterlevel < 3) return TRUE;    // Swimming along water surface.

            if (ent.wing_finished)
                if (ent.button2)
                    if (ent.waterlevel < 2) return TRUE;    // Flying with Dark Angel wings.
        }
    }
    return FALSE;
};

//  This tries to predict where the target will go, then returns that spot.

//  NOTE:  This only works on targets that have a velocity value.
//  In Quake, only players have a constantly updated velocity.  Monsters
//  do not update their velocity because they move in steps, unless it is
//  jumping or falling (e.g., fip2).  Bottom line:  This works reliably
//  only on players.
//
//  NOTE:  While using Law of Sines or application of (a/sin(A) = b/sin(B))
//  may be a more elegant way to a perfect answer, standard Quake does not
//  support trigonometric functions, and I suspect adding trig functions via
//  QuakeC and using them may involve running more code than necessary when
//  a more primitive yet simplier way (as far as Quake is concerned) of
//  getting an answer that is "close enough" is sufficient.
vector(vector p1, vector p2, float sped, entity targ) Aim_Lead = {
    local   float   mx, loop, airtime;
    local   float   xyz; // TRUE = Use all three dimensions.
    local   vector  lead, tv, spot;
    local   float   fell; // Distance fallen.
    local   float   gforce; // Target gravity.

    if (!targ) return p2; // No target.
    if (targ.movetype == MOVETYPE_NONE) return p2; // Can't move, ignore velocity.
    if (targ.movetype == MOVETYPE_STEP) { if (targ.flags & FLx_NOT_FALLING) return p2; } // Target velocity is not accurate.
    if (!sped) return p2; // Avoid division by zero.
    // Removed invisibility checks -- done elsewhere.

    // Now find the spot.
	//- - - - - - - - -
	// Update 7/31/09:  Check if target is riding on a grappling wire.
	// Note:  Applies only to attackers using the grappler to move,
	// not creatures hooked and drawn toward the grappler.  However,
	// since pulling hooked monsters is rare enough and does not apply
	// to players, I'm not adding another field and more code just to
	// make the case of aiming at hooked monsters pulled by players work.
    // wired = FALSE;
    // if (targ.hook.state)    // Should be 0 if targ.hook == world.
        //if (Grapple_Pull_Who (targ) == targ)
            //wired = TRUE;
	//- - - - - - - - -
    tv = targ.velocity;
	// Check if target's vertical velocity should be ignored.
    xyz = TRUE;
    // if (!wired)
        if (Aim_IgnoreZ (targ)) { xyz = FALSE; tv_z = 0;}

	// Calculate the time it takes for a missile to reach a given spot,
	// then calculate where the moving target will be after that amount of time.
	// However, after predicting where the target will be, it may take more or
	// less time for the missile to reach that spot.  Therefore, we ought to
	// recalculate the time needed to reach the real spot.  Each recalcuation
	// reduces the margin of error.  Idea is similar to a power series.
	// Yes, brute force may be ugly, but it gets the job done.
    mx = Aim_SpeedMod (targ);
    loop = 5;       // Make sure the number is odd.
    lead = p2;
    while (loop > 0) {
        airtime = vlen(lead - p1) / sped;
        lead = p2 + (tv * mx) * airtime;
        loop = loop - 1;
    }

	// Update 7/31/09:  Check if target is riding on a grappling wire.
    // if (wired) {
        // if (targ.hook.state != 2)
            // loop = (targ.hook.enemy.maxs_x + targ.maxs_x);
        // else
            // loop = targ.maxs_x;
        // tv = targ.hook.origin - targ.origin;
        // mx = (vlen(tv) - loop) / SPEED_HOOK;
        // if (mx < airtime)
        // {   // Target will be at the hook -- aim there!
            // tv = targ.hook.origin - normalize(tv)*loop;
            // return tv;
        // }
    // }

	// Check for gravity.  For better accuracy, this check should be done in
	// the above loop, but since this has much more code, just do this once,
	// even if accuracy isn't perfect.
    if (xyz) {
        if (IsFalling (targ)) {
			gforce = cvar("sv_gravity");
			if (targ.gravity) gforce = gforce * targ.gravity;

			fell = 0.5 * gforce * airtime * airtime;    // 1/2 gt^2.
			lead_z = lead_z - fell;
			traceline (p1, lead, TRUE, targ); // Check if the path to the spot is clear.
			if (trace_fraction < 1) {
				if (fell) {
					// Projected spot was blocked.  Check if the spot was blocked
					// due to the floor or ceiling alone.  If so, aim at the
					// surface.
					spot   = lead;
					spot_z = p2_z;
					traceline (spot, lead, TRUE, targ);
					lead = trace_endpos;
					if (fell > 0) lead_z = lead_z - targ.mins_z;      // floor
					else lead_z = lead_z - targ.maxs_z;      // ceiling
				}
			}
		}
	}
    return lead; // Our work here is done.
};

// This is similar to traceline, except gravity affects this. Drake's QC implementation of engine builtin tracetoss.
// The value returned is the closest distance the path was to a point,
// which is necessary when comparing the better of two different traces.
// (Originally, the value returned is the time of flight before impact.)
// If mtype == MOVETYPE_BOUNCE, trace grenade path.
float(vector p1, vector vel, float nomon, entity ignore, float fuse, vector spot, float mtype) TraceBallistic = {
    local float fps, timeperframe, g, minv, maxv, t, dist, best;

	// The closer time per frame is to hosttime, the more accurate the trace is.
	// However, try to keep the number of traceline calls to a minimum.
	// Thus, 20 fps is a good compromise between accuracy and efficiency.
    fps = 20; // Don't use zero or negative number.
    timeperframe = 1 / fps;
    best = 20000; // More than 8000 * 2.
    t = 0;
    fuse = floor(fuse * fps);
    g = cvar("sv_gravity") * timeperframe;
    maxv = cvar("sv_maxvelocity");
    minv = 0 - maxv;
    if (vel_x > maxv)       vel_x = maxv; // Velocity check
    else if (vel_x < minv)  vel_x = minv;

    if (vel_y > maxv)       vel_y = maxv;
    else if (vel_y < minv)  vel_y = minv;

    if (vel_z > maxv) vel_z = maxv; // Lower bound for z done in loop.
    while (t < fuse) {
        if (vel_z < minv) vel_z = minv; // Velocity check.  Don't bother with reverse gravity.
        vel_z = vel_z - g;
        traceline (p1, p1 + (vel * timeperframe), nomon, ignore);
        p1 = trace_endpos;
        dist = vlen(p1 - spot);
        if (dist < best) best = dist;
        if (trace_fraction < 1) {
            if ((mtype != MOVETYPE_BOUNCE) || (trace_ent.takedamage == DAMAGE_AIM)) fuse = 0;   // Got a hit -- break the loop!
            else { // Rebound.  Emulate C physics code.
                vel = Vec_Reflect (vel, trace_plane_normal, 1.5, 0.1); // overbounce = 1.5, stop_epsilon = 0.1, as per C code.
                if (vel == '0 0 0') fuse = 0; // Stopped.
                else {
                    trace_ent = world; // Bounced off the guy.
                    trace_fraction = 1;
                }
            }
        }
        t = t + 1;
    }
    return best;
};

// This returns how much speed to add up for a toss projectile to hit the target point.
// The resulting speed can be much higher than the original.
float(vector p1, vector p2, float sped) Aim_TossUp = {
    local float gforce;     // Target gravity.
    local float up;         // Add to z.

    if (sped <= 0) return 0;   // Avoid division by zero.

    gforce = cvar("sv_gravity");
    p2 = p2 - p1;
    up = 0.5 * gforce / sped;
    up = vlen(p2) * up;
    return up;
};

vector(vector dir, vector vtan) Aim_Tangent = {
    local   vector  vang;
    local   float   mx;

    // Combine the tangent side vector to the old directional vector.
    mx = vlen (dir);
    dir = normalize (dir);
    vang = Vangles (dir);
    makevectors(vang);
    dir = dir + (vtan_x * v_right) + (vtan_y * v_up);
    dir = normalize (dir);

    return (dir * mx);
};

// spread:  x = horizontal, y = vertical, z = 0/1 for randomize/set.
vector(vector dir, vector spread) Aim_Scatter = {
    // Randomize the angles before converting them into tangents.
    if (!spread_z) {
		spread_x = crandom() * spread_x;
		spread_y = crandom() * spread_y;
	}
    spread_x = SUB_tan (spread_x); // This is NOT the same as mathlib_tangent.  DON'T REMOVE AGAIN!
	spread_y = SUB_tan (spread_y); // This is NOT the same as mathlib_tangent.  DON'T REMOVE AGAIN!
    return Aim_Tangent (dir, spread); // Combine the tangent side vector to the old directional vector.
};

vector(vector dir, vector spread) Maim_Scatter = {
    local   float   r;

    if (Invisible(self.enemy)) {
        r = random() * 4;   // Monsters have 25% chance to guess right.
        r = floor(r) * 5;   // Aim up to 15 degrees to either side.
        if (random() < 0.5) r = 0 - r;
    } else r = 0;

    // Randomize the angles before converting them into tangents.
    if (!spread_z) {
        spread_x = crandom() * spread_x;
        spread_y = crandom() * spread_y;
    }
    spread_x = SUB_tan(spread_x + r);  spread_y = SUB_tan(spread_y);

    // Combine the tangent side vector to the old directional vector.
    return Aim_Tangent (dir, spread);
};

float SHOT_TIME_TOSS   =  5.0;
float SHOT_TIME_BOUNCE =  2.5;    // Assuming grenades.
float SMARTBALL        = -1.0; // Used instead of a movetype to do hack.

// This returns the directional vector needed for a monster to hit its target.
// NOTE:  The vector returned can be smaller than a unit vector.  (Really, it should not because that is cheating.  Oh well.)
vector(vector p1, vector p2, float sped, float up, entity targ, float ex, float fuse, float mtype)  Aim_Ballistic = {
    local vector dir, vel, v1, v2, vup;
    local float d1, d2, toss, mx;

    if (!sped) return '0 0 0'; // Avoid divison by zero.

    vup = '0 0 0';
    vup_z = up;

	// Locate the point we want to aim at.
    if (targ) {
        dir = Aim_Lead (p1, p2, sped, targ);
        if (ex < 1)
            dir = p2 + ((dir - p2) * ex);   // Partial leading.
        // Check if the path to the projected endpoint is clear.
        // NOTE:  This does not check if monsters are in the way.
        traceline (p1, dir, TRUE, self);
        if (trace_fraction == 1) p2 = dir;   // Success.
    }
    self.dest = p2;

	// Get first vector:  Direction in the xy-plane only, eliminate z-axis.
	// This is closest, albeit not identical, to id's old aiming code.
    dir = normalize(p2 - p1);
    vel = dir * sped;
    vel_z = vel_z + up;
    v1 = v2 = dir;
    v1_z = 0;
    v1 = normalize (v1);

	// Get second vector:  Direction needed to hit opponent.  Does not account
	// for obstacles in the way.
    // Determine the extra vertical speed needed to hit the target point.
    toss = Aim_TossUp (p1, p2, sped);
    vel = dir * sped;
    vel_z = vel_z + toss - up;

    // At this point, the upward speed returned would let the monster hit the
    // target point with perfect accuracy.  However, that is cheating since
    // the player cannot do that trick, especially if it lets the monster hit
    // at ranges longer than the player could hit if using the same attack
    // (for example, grenades).
    //
    // For the sake of efficiency, allow this sort of cheating only if the
    // resulting speed is slower than normal, which lets the monster drop
    // grenades from above without overshooting the target point.

    mx = vlen(vel) / sped;
    vel = normalize (vel);
    if (mx < 1)     // Yes, we may return a shorter-than-unit vector.
        vel = vel * mx;
    v2 = vel;

    if (mtype == SMARTBALL) return v2;      // Smartball hack.

	// Project flight paths from the given two vectors.  If either hit the enemy,
	// return the direction.  In case both vectors can hit, select the first
	// forward-only vector, since it is the closest to the old monster aim code.
    if (self.enemy) {   // Check if we can hit our intended target.
        local   entity  vic;    // VICtim.
        local   entity  oown;   // Old OWNer, placeholder for swapping.

        vic = self.enemy;       // The target the trace needs to hit.
        oown = self.enemy.owner;    // See below in target spawn section.
        if (targ) {   // Shot leading on.
            // Note:  Leading shots to targ, so use targ, regardless of
            // self.enemy.  FWIW, targ is usually, if not always, self.enemy.
            if (p2 != targ.origin) {
                vic = spawn();   // Definitely NOT self.enemy or world.
                vic.owner = targ;
                vic.solid = targ.solid;
                vic.takedamage = targ.takedamage;
                setorigin(vic, p2);
                setsize (vic, targ.mins, targ.maxs);
                // Setting the enemy's owner to self lets traceline ignore
                // the enemy, if it ignores self.
                self.enemy.owner = self;
            }
        }
		// One
        d1 = TraceBallistic (p1, v1*sped + vup, FALSE, self, fuse, p2, mtype);
        if (trace_ent == vic) {
			if (vic != self.enemy) { self.enemy.owner = oown;  remove (vic);}
            return v1;      // ONE!
        }
		// Two
        d2 = TraceBallistic (p1, v2*sped + vup, FALSE, self, fuse, p2, mtype);
        if (trace_ent == vic) {
			if (vic != self.enemy) { self.enemy.owner = oown;  remove (vic);}
            return v2; // TWO!
        }
        // If we didn't eliminate the dummy target yet, remove it now.
        if (vic != self.enemy) { self.enemy.owner = oown;  remove (vic);}
    } else {   // No target to hit, so simply aim at the given point.
        d1 = TraceBallistic (p1, v1*sped + vup, FALSE, self, fuse, p2, mtype);
        d2 = TraceBallistic (p1, v2*sped + vup, FALSE, self, fuse, p2, mtype);
    }

	// Neither projections could hit the enemy, so pick the one that reached
	// the closest to the enemy.
    if (d2 < d1) return v2;      // 3D Ballistic
    return v1;      // 2D Forward
};

// Specially made for the "smart balls" launched by Zerstorer's Nemesant.
vector(vector p1, vector p2, float sped, float up, entity targ, vector spread) Maim_SmartBall = {
    p2 = Aim_Ballistic (p1, p2, sped, up, targ, 1, SHOT_TIME_TOSS, SMARTBALL);
    p2 = Maim_Scatter (p2, spread);
    return p2;
};

vector(vector p1, vector p2, float sped, entity targ, float ex) Aim_LineEx = {
    local vector dir;
    
    if (sped) {
        if (targ) {
            dir = Aim_Lead (p1, p2, sped, targ);
            if (ex < 1) dir = p2 + ((dir - p2) * ex);   // Partial leading.
            // Check if the path to the projected endpoint is clear.
            // NOTE:  This does not check if monsters are in the way.
            traceline (p1, dir, TRUE, self);
            if (trace_fraction == 1) p2 = dir;   // Success.
        }
	} //else if no speed, do instant-hit... and avoid division by zero.
    dir = normalize (p2 - p1);
    return dir;
};

vector(vector p1, vector p2, float sped, entity targ, vector spread, float ex) Maim_LineEx = {
    p2 = Aim_LineEx(p1, p2, sped, targ, ex);
    p2 = Maim_Scatter(p2, spread);
    return p2;
};

// This traces for the vector normal to a surface.  It also resets the
// missile's origin.
void() BounceShot_TraceNormal = {
    local   vector  spot1, spot2;

    self.movedir = normalize (self.dest);
    spot1 = self.origin - (16*self.movedir);
    spot2 = self.origin + (16*self.movedir);
    traceline (spot1, spot2, FALSE, self);  // see through other monsters
    setorigin(self, trace_endpos);     //self.origin = trace_endpos;
};

// The moves a missile after an impact.
void() BounceShot_Move = {
    self.velocity   = Vec_Reflect (self.movedir, trace_plane_normal, 2, 0);
    self.velocity   = normalize(self.velocity);
    self.velocity   = self.dest         = self.speed * self.velocity;
    self.flags      = self.flags - (self.flags & FL_ONGROUND);
    self.angles     = vectoangles(self.velocity);
};

// This updates the velocity and angles of a missile.  Needed for
// rebounding shots.  Used by pulse rifle and Hip's laser cannon.
void() BounceShot_Think = {
    if (time > self.delay) { remove (self); return;}

    self.flags      = self.flags - (self.flags & FL_ONGROUND);
    self.velocity   = self.dest;    //old_velocity;
    self.angles     = vectoangles(self.velocity);
    self.nextthink  = time + 0.05;
};

float(entity targ, entity attacker) Ally_Check;

// This redirects a missile to an enemy.  Must call BounceShot_Move first.
void() BounceShot_Seek = {
    local   entity  head, best;
    local   vector  dir, spot;
    local   float   bdot, dot;

    best = world;
    dir = trace_plane_normal;   //self.dest
    bdot = 0;
    head = findradius (self.origin, 2000);
    while (head) {
        if (head.takedamage) {
            if (!Invisible(head)) {
                if (head != self) {
                    if (head != self.master) {
                        if (!Ally_Check(head,self.master)) {
                            if (CanDamage(head, self)) {
                                spot = Midpoint(head);
                                dot = normalize(spot - self.origin) * dir;
                                if (dot > bdot) {
                                    best = head;
                                    bdot = dot;
                                }
                            }
                        }
                    }
                }
            }
        }
        head = head.chain;
    }

    if (best) {
        self.velocity   = Midpoint (best);
        self.velocity   = normalize (self.velocity - self.origin);
        self.velocity   = self.dest = self.speed * self.velocity;
        self.angles     = vectoangles(self.velocity);
    }
};

void(vector st) M_FireSmart = { // [FUNCTION]
    local vector p1, p2, dir, up;
    local entity targ;

    targ = world;
    makevectors(self.angles);
    p1 = self.origin + (v_forward*st_x) + (v_right*st_y) + (v_up*st_z);
    p2 = Aimpoint (self.enemy);
    up = '0 0 0';
    up_z = Aim_TossUp (p1, p2, 600);
    dir = Maim_SmartBall (p1, p2, 600, up_z, targ, '0 0 0');
    if (!targ) { // In case we can't hit enemy, just lob it straight ahead.
		TraceBallistic (p1,up + (dir*600),FALSE,self,5,p1,MOVETYPE_TOSS);
        if (trace_ent != self.enemy) up_z = 200;
    }
    self.effects = self.effects | EF_MUZZLEFLASH;
    sound(self, CHAN_AUTO, "zerstorer/trog/frblfly.wav", 0.6, ATTN_NORM);
    launch_projectile(p1,dir,NO_SPIN,CT_PROJ_SMARTBALL,600);
    newmis.velocity = newmis.velocity + up;
};

// Work out direction speed of egg and then launch it!
void(vector eggofs) Create_Egg = {
	local vector org, dir;
	local float egg_speed;
	if (self.health < 1) return;
	
	// Turn towards player and drop the egg!
	makevectors(self.angles);
	org = self.origin + attack_vector(eggofs);
	egg_speed = self.minion_throwspeed + (random() * self.minion_throwextra);
	dir = v_forward * egg_speed + (v_right * (crandom()*self.minion_throwside));
	launch_projectile(org,dir,NO_SPIN,CT_PROJ_MEGG,1);
	SUB_AttackFinished (2 + random());
};

void(float offset) dprince_hazard = { // [FUNCTION]
	local vector org, torg, dir, ang, avel;
	local float targetang, haz_loop;
	
	if (!self.enemy) return;
	if (self.enemy.health < 1) return;

	sound(self, CHAN_WEAPON, "hknight/attack1.wav", 1, ATTN_NORM);
	makevectors(self.angles);	
	org = self.origin + attack_vector(self.attack_offset);
	if (skill <= SKILL_NORMAL) haz_loop = 1;
	else haz_loop = 2;
	
	while(haz_loop > 0) {
		// Keep looping
		haz_loop = haz_loop - 1;
		torg = self.enemy.origin;
		// Last projectile (0) is direct at enemy
		if (haz_loop > 0) {
			// Very large random area around target
			torg_x = torg_x + (crandom() * 128);
			torg_y = torg_y + (crandom() * 128);
		}
		// Work out elevation towards target origin
		targetang = SUB_Elevation(ELEV_DEFAULT, self.origin, torg, SPEED_DPRINCE);
		ang = vectoangles(torg - org);
		ang_x = -targetang;
		makevectors(ang);
		// fire projectile in arc pattern (offset)
		dir = ( (v_forward * (0.75 + random()*0.25)) + (v_right * (offset*0.1)) ) * SPEED_DPRINCE;	
		// Some random angle rotation
		avel = vecrand(100,200,FALSE);
		Launch_Hazard(org, dir, avel, CT_PROJ_DPRINCE2);
	}
};

// Range - Grenades (uses generic attack function in projectiles.qc)
// Nail - Alternative firemode (based on nail ogre from Marcher Fortress)
void() OgreFireADNails = {
	local vector org, dir, vec;
	local float loopvar;

	if (self.health < 1) return; // Check for death?

	loopvar = 0;
	self.effects = self.effects | EF_MUZZLEFLASH; // Light up face, setup projectile speed and play fire sound
	self.attack_speed = SPEED_NAILOGREPROJ + (skill * SPEED_NAILOGRESKILL);
	sound(self, CHAN_WEAPON, "xmas/snowman/nail_fire.wav", 1, ATTN_NORM);
	makevectors(self.angles); // turn and face your enemy!
	org = self.origin + attack_vector(self.attack_offset);
	if (self.attack_count <= 0) self.attack_count = 5; // Shoot something!
	while (loopvar < self.attack_count) { // Loop through the nail burst (all at once)
		vec = (crandom()*20)*v_right + (crandom()*20)*v_up; // Random circle spread pattern
		dir = normalize((self.enemy.origin + vec) - org);
		launch_projectile(org,dir,NO_SPIN,CT_PROJ_MONNG,self.attack_speed); // Generate a red hot nail projectile
		loopvar = loopvar + 1;
	}
};

// FLAMES PATTERN 2 - straight line towards player
void() judge_fireflameline = {
	local vector org, dir;
	local float fire_col;

	// Judge cannot find target!
	if (!self.enemy) return;

	// Turn toward enemy
	ai_face();
	makevectors(self.angles);	
	org = self.origin + attack_vector(self.attack_offset2);
	dir = v_forward;
	
	// Setup colour scheme (was original red/blue flames)
	fire_col = FLAME_RED;
	// Fire that flame!
	// Origin, v_forward, colour, sfx
	Launch_Trail (org, dir, fire_col, "");
};

void() pyro_fire = {
	local vector org, dir, targ_org;

	if (self.health < 1) return;
	
	makevectors(self.angles);
	org = self.origin + attack_vector(self.attack_offset);
	// point the flames at the feet of the player
	if (self.enemy.flags & FL_CLIENT) targ_org = self.enemy.origin - '0 0 20';
	else targ_org = self.enemy.origin - self.enemy.view_ofs;
	dir = normalize(targ_org - self.origin);
	pyroflame_spawn(org, dir);
};

void(vector org, float type) M_LaunchFlameWall = {
	local vector torg, dir, ang;
	local float targetang, fire_life;

	// Start with facing angle
	makevectors(self.angles);	
	// Work out offset (24 unit) from left to right (- to +)
    if (self.classtype == CT_MONINQUISITOR) {
        if (self.lefty == 0) self.lefty = 1;
        torg = self.enemy.origin + (v_right * (self.attack_count*24*self.lefty));
	} else {
        torg = self.enemy.origin + (v_right * (self.proj_attarc*24));
    }
	targetang = SUB_Elevation(ELEV_DEFAULT, self.origin, torg, SPEED_FLAME);
	// Work out angle
	ang = vectoangles(torg - org);
	ang_x = -targetang;	// Negative = upwards angle 
	makevectors(ang);
	// fire flames forward with slight Z wobble
	dir = (v_forward + (v_up * (random()*0.2)) ) * SPEED_FLAME;

	// Fire that flame!
	fire_life = (LIFE_FLAME/2) + random() + random();
	if (random() < 0.5) self.part_exitpuff = FALSE;
	else self.part_exitpuff = TRUE;
	// target, origin, v_forward, colour, size, lifetime, speed
	Launch_Flame(self,org,dir,type,-1,fire_life,SPEED_FLAME);
};