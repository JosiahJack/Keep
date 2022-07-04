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
// Function count: 19
//
// Implements: AI Behavior for Drake Dragons and Nightshade
//
// Description:
// The ryu dragons from Drake mod have various specialty behavior, defined
// here.
//
// Custom movetogoal
// The fundamentals!  Used when neither 'walkmove' nor 'movetogoal'
// alone are good enough.  This takes care of the problems of water
// immersion and wall clipping.  The point of flat movement is to prevent the
// dragon from entering water. Builtin movement functions move the dragon 8
// pixels toward its enemy per call.  Therefore, plot a point 7 pixels away
// from the bbox edge.  If the point is in an offending liquid, use flat
// movement code to prevent entry.  Also, if the dragon has a bbox maxs_z
// greater than 64, use flat movement to prevent (or greatly reduce the chance)
// of the dragon clipping the ceiling.
//
// Movement
// Does collision checking as well as detecting and dodging projectiles
// or other dangerous entities nearby the dragon.  Also deals with situations
// that involve water such as dragons who are afraid of water.  
//=============================================================================

.float  dodge_back;     // Time to reverse dodge, sort of like lefty.

// edict.spawnflags
float   SPAWN_WYRM  = 2;    // Upgrades dragon to full Qtest-sized.
float   SPAWN_FAST  = 4;
float   SPAWN_SLOW  = 8;
float   SPAWNx_SKILL= 12;   // Combo - 4+8.

// Basic Movement.  Checks if the dragon should be allowed to move freely, or horizontal only.  TRUE = Free move allowed, FALSE = Flat move only.
float() Ryu_UseFreeMove = {
    local vector spot;
    local float diff, pc;

    if (!self.enemy) return TRUE; // Movement is automatically flat.
    if (self.waterlevel) return TRUE; // Get out of the water ASAP.

    spot = self.origin;
    diff = spot_z - self.enemy.origin_z;
    if (diff < 30)
        spot_z = spot_z + self.maxs_z + 7;  // Going up.
    else if (diff > 40)
        spot_z = spot_z + self.mins_z - 7;  // Going down.
    else
        return TRUE; // Already level, so no need to use flat move code because the engine code will do that for us.

    pc = pointcontents(spot);
	// Don't let big dragons clip the ceiling.
    if ((pc == CONTENT_SOLID) && (self.maxs_z > 64)) return FALSE; // Stop huge dragons from clipping the ceiling.

	// Check for water.  Dragons who are afraid of water never go in.
	// Dragons not afraid of water may enter water, but NOT slime/lava, unless the dragon has invunlerability.  No dragon may enter a sky brush.
    if (self.ryuflags & RYU_NO_WATER) diff = CONTENT_WATER;   // Never go into water no matter what.
    else if (self.cross_finished > time + 3) diff = CONTENT_SKY;     // Protected from elements by cross.
    else diff = CONTENT_SLIME;   // Even those who can swim won't enter this.
	
    return (pc > diff); // If test spot goes into the water, use flat move code.
};

float(float yaw, float dist) Ryu_WalkMove = {
    if (Ryu_UseFreeMove()) return walkmove(yaw, dist); 
    return flat_move(yaw, dist);
};

// Angular Movement.  Reverses angle changes caused by tilting.  Should be called each frame unless the dragon needs to tilt.
void() ryu_untilt = {
    if (self.angles_z != 0) {
        if (self.angles_z < -5)
            self.angles_z = self.angles_z + 5;
        else if (self.angles_z < 5)
            self.angles_z = 0;
        else
            self.angles_z = self.angles_z - 5;
    }
};

// Called whenever the dragon strafes, this tilts the dragon's angles_z.  Note:  If called by wyrm AI, dist should always be high for big turns.
void(float left, float dist) ryu_tilt = {
    local float hi;

    if (dist > 20) {dist = 10; hi = 30;}// Fast -- Running
    else {dist = 5; hi = 20;}    		// Slow -- Walking

    if (left) { 
        hi = 0 - hi;
        left = self.angles_z - dist; // Going left.
        if (left < hi) left = hi;
    } else { 
        left = self.angles_z + dist; // Going right.
        if (left > hi) left = hi;
    }
    self.angles_z = left;
};

// Returns the distance the dragon should move while strafing.  The idea is
// the dragon takes time to accelerate to full speed while sidestepping.
// However, the dragon will never move slower than the allowed minimum.
float(float dist) ryu_slide_speed = {
    if (dist <= SPEED_RYU_MIN) return SPEED_RYU_MIN;

    // Note:  Make sure the angle divisor matches the fast 'hi' in the above tilt function.
    dist = (dist - SPEED_RYU_MIN) * (fabs(self.angles_z) / 30);
    dist = floor(dist) + SPEED_RYU_MIN;
    return dist;
};

// Vertical Movement
// This checks if the dragon should stay away from water.  Dragons that
// only have breath weapons that are ineffective or too dangerous to use
// underwater are usually afraid of water.  However, a dragon that is on
// fire will venture into water, even if it normally avoids water.
// Update:  Monsters can drown or fry in water.  Remember that!
float() Ryu_HatesWater = {
    if (self.invincible_finished <= time + 3) { // Powerups ring at T-3 seconds.
        // Cheap hack -- make the dragon afraid of water when low on air.
        // Give at least five seconds because the dragon may either be in
        // deep water or caught up in battle.
        if (!(self.xfl & XFL_NO_AIR))   // SoE:  Disabled drowning
            if (self.air_finished < time + 5) return TRUE;    // Running out of air, so leave the water now!

        // If frying in the hot sauce, get out!  Even the new dragon move AI won't stop it from entering such liquid via teleportation.
        if (self.liquidbase <= CONTENT_SLIME) return TRUE;    // Burning in slime or lava!
    }

    if (self.burner) return FALSE;   // Any dragon on fire won't mind taking a dip.
    return (self.ryuflags & RYU_NO_WATER);  // Return fear status.
};

// This tells the dragon to escape a pool of water when true.
float(float dist) Ryu_LeaveWater = {
    // Check if air is above the water (like above a pool or river) from an underwater point.
    traceline(self.origin, self.origin + '0 0 2048', FALSE, self);
    if (trace_inopen && InLiquid(self.origin)) {
		if (ai_up(dist)) return TRUE;
	}

    // Removed:  Don't bother checking for air below water.  No air is detected, continue on present course.
    return FALSE;
};

// The dragon flies up or down based on current conditions.
void(float dist, entity ent) Ryu_VerticalSlide = {
    local float delta;

	// If in the unlikely event a water-fearing dragon is in the water, find some air and go in the direction it is found.
	if (self.classtype != CT_MONSHADE) {
		if (Ryu_HatesWater()) {
            if (Ryu_LeaveWater(dist)) return; // If a dragon is in the water, this makes the dragon rise out of it.
        }
	} else {
		// Fly away from goal.
		// Note:  Don't bother with the extra checks dragons go through.
		if (ent.origin_z <= self.origin_z)
			self.velocity_z = self.velocity_z + (dist * 10);
		else
			self.velocity_z = self.velocity_z - (dist * 10);

		return;
	}

	// Fly away from... whatever 'ent' is.
    if (ent.origin_z > self.origin_z) {
        // Going down would increase chances of evading ent.
        // Do it only if dragon is already above the goalentity.
        if (self.goalentity) {
            delta = (self.origin_z + 30) - self.goalentity.origin_z;
            if (delta < 0) return;     // Don't go down when climbing toward a goal.
            if (delta < dist)  dist = delta;   // Don't descend fully.
        }
        ai_down(dist);
        return;
    } else { // Thinking about going up.
        if (self.goalentity)
            if (self.origin_z - self.goalentity.origin_z > 1000) return;     // Don't fly so high up beyond medium range.
    }
    ai_up(dist); // Now we're really going.
};

//==========================================================================
//  Danger Evasion

//  Fly toward to direction that will most likely dodge the threat.
void(float newyaw, float dist, entity threat) Ryu_Dodge = {
    local   entity  targ;

	// Strafe away from the detected danger.  If path is blocked,
	// flag it with a time so that future checks use a different path.
    if (!walkmove(newyaw, dist)) {
        if (self.dodge_back > time)
            self.dodge_back = 0;
        else
            self.dodge_back = time + 0.5 + random();
    }
    targ = self.goalentity;
    self.ideal_yaw = vectoyaw (targ.origin - self.origin); 
    ChangeYaw(); // Face its goal.

	// Next, check if the dragon should slide vertically away from its goal.
    if (targ != threat) {
        // For elevation, if dragon is between the goal and threat entity,
        // don't slide vertically away from goal.  We do not want the dragon
        // to move toward the threat now would we?
        local   float   tz, sz;

        tz = targ.origin_z;
        sz = self.origin_z + self.view_ofs_z;
        if (tz < sz)
            {if (sz < threat.origin_z)  return;}
        else if (tz > sz)
            {if (sz > threat.origin_z)  return;}
    }
    Ryu_VerticalSlide(dist,targ);
};

//  Compare the yaws of the dragon's direction and the direction toward the threat, and find the best direction to dodge the threat on the results.
void(float dist, entity ent) Ryu_FindBestPath = {
    local   float   yaw;

    yaw = vectoyaw (ent.origin - self.origin);
	yaw = anglemod (yaw - self.angles_y);
    if (yaw < 60)   yaw = -90;   	  // Dodge right.
    else if (yaw < 120)  yaw = 0;     // Continue straight ahead.
    else if (yaw < 180)  yaw = -90;   // Dodge right.
    else if (yaw < 240)  yaw = 90;    // Dodge left.
    else if (yaw < 300)  yaw = 0;     // Continue straight ahead.
    else yaw = 90;                    // Dodge left.
	
    if (self.dodge_back > time) yaw = 0 - yaw; // Reverse direction if blocked recently.
    if (yaw != 0) { //Flip the dragon and adjust speed based on its angles. Sidestep.  +yaw = left, -yaw = right.
        ryu_tilt (yaw > 0, dist);
        dist = ryu_slide_speed (dist);
    } else ryu_untilt();
    Ryu_Dodge (self.angles_y + yaw, dist, ent); // Set new course and head in that direction if possible.
};

// Danger Detection.  This tells the dragon whether or not it is best to stay away from the entity.
// TRUE is returned if the dragon should stay away.
// FALSE is returned if the dragon is better off closing in on entity. Only alert dragons can spot who the entity is and what kind of weapons, items, or other abilities it has.
float(entity ent) Ryu_KeepAway = {
	local float dist;

    if (ent.burner && self.resist_fire < 1) return TRUE; // Check for burning first because even the stupid know that fire is bad.
	if (ent.health <= 0) return FALSE; // Checked burning first because the dead on fire is scary
    if ((self.classtype == CT_MONRYU || self.classtype == CT_MONWYRM) && !self.th_missile) return FALSE;   // Dragon has no choice but to attack up close.

	dist = (vlen(ent.origin - self.origin) >= 120);
	if (dist > 1000) return FALSE;

    if (ent.flags & FLx_CREATURE) {
        if (!Align_Match (ent, self)) { // Must be opposed.
            if (ent.invincible_finished > time || ent.super_damage_finished > time) return TRUE;    // Avoid if using pentagram or quad damage.

            // Check weapons.  Requires alertness to spot SCARY weapons.
            if (self.ryuflags & RYU_ALERT) {
				// If player, check his items.
				if (ent.flags & FL_CLIENT) {
					if (ent.selfweaponismoditems) {
						if (ent.weapon == IT_FLAK) return TRUE;
					} else {
						if ((ent.weapon == IT_GRENADE_LAUNCHER || ent.weapon == IT_ROCKET_LAUNCHER || ent.weapon == IT_MULTI_GRENADE || ent.weapon == IT_MULTI_ROCKET || ent.weapon == IT_PLASMA_GUN || (ent.weapon == IT_LIGHTNING && (ent.moditems & IT_UPGRADE_LG)))) return TRUE;
					}
				}
			}
  
			// The rest of the checks apply only if the entity is a live monster.
			if (ent.flags & FL_MONSTER) {

				// Update 6/2/2011:  Removed .threat field and simplified checks. Stay away from an enemy if it has more health than the dragon,
				// or anytime the dragon has low health and the enemy is melee only. Enemy is defined as any monster targeting the dragon, or the dragon targeting the given monster.
				if ((self.enemy == ent) || (ent.enemy == self)) {
					if (ent.classgroup == CG_SHAM) return TRUE;
					if (ent.classgroup == CG_DCAPTAIN) return TRUE;
					if (ent.classgroup == CG_BOSS || ent.bossflag) return TRUE;
					if (ent.classtype == CT_MONSPAWN) return TRUE; // These guys are bouncing bombs -- bad news!
					if (ent.health > self.health) return TRUE; // Looks big and scary!

					if (self.health <= 100) {
						// Dragon becomes more evasive against melee when weakened. After all, a knight cannot kill a dragon he cannot reach.
						if (!ent.th_missile) return TRUE; // More likely to live by hanging back.
					}
				}
			}
        }
        return FALSE; // Close in.
    }
    return FALSE; // It is best to close in on the enemy.
};

//  This checks if the entity found is dangerous and should be avoided (if possible).
float(entity ent) Ryu_IsHostile = {
	local vector vec;
	local float before, after;
	
    if (ent.owner == self) return FALSE; // Ignore entities owned by its owner (for obvious reasons).

    if (IsMissile (ent)) { // Check if entity is an avoidable projectile and see if the dragon should avoid it.
        if (ent.enemy == self) {
			// Homing missile.
            if (ent.yaw_speed >= 180) return FALSE;   // Can't dodge this (vore/wrath) missile.
            return infront(ent);    // Dodge only if seen; hope it misses.
        }

        // Check if projectile can hit dragon.  NOTE:  32 = 16 for missile clip bonus + 16 for 2 builtin z moves.
        if (ent.velocity_z > 0) {
			if (ent.origin_z > self.origin_z + self.maxs_z + 32) return FALSE;   // Can't hit dragon below if going up.
        } else if (ent.velocity_z < 0) {
			if (ent.origin_z < self.origin_z + self.mins_z - 32) return FALSE;   // Can't hit dragon above if going down.
        }

		// Note:  If this section slows play too much, remove and return TRUE.  Check distance to projectile now (before) vs. one frame later (after).
		// If the expected distance increases (before < after), projectile is likely flying away so ignore it.  Otherwise, it is likely incoming so avoid it.
        vec = ent.origin - self.origin;
        before = vlen(vec);
        after = vlen(vec + (ent.velocity*0.1));
        return (before >= after);
    }
    return Ryu_KeepAway(ent); // Decide whether or not to stay away from the entity detected.
};

//  This checks if a dangerous entity is nearby and if so, get out of its way.
float(float dist) Ryu_DetectDanger = {
    local entity head;

    // Return the first threat found (if any).  Note:  Proper radius is ((maxs_x / 16) * 25) + 275.
    head = findradius(self.origin, self.maxs_x * 1.5625 + 275); // Find the first entity that poses a threat if any are nearby.
    while (head) {
        if (head != self) {
            traceline (self.origin, head.origin, TRUE, self);
            if (trace_fraction == 1)
                if (Ryu_IsHostile (head)) break; // Got one!
        }
        head = head.chain;
    }
    if (head) {Ryu_FindBestPath (dist, head); return TRUE;} // Got one!
    return FALSE;   // Nothing dangerous was found.
};

//  Dragon Combat.  This checks if the dragon cannot use its missile attacks because of some detrimental side effect that could result from it.
float(entity ent) Ryu_NoShot = {
    local float element;

    if (ent.waterlevel > 1) {
        element = ent.ryuflags & RYU_ELEMENTS;
        if (element == RYU_USE_LITE) return TRUE;    // Lightning is useless underwater.
        else if (element == RYU_USE_ICE) { 
            if (ent.liquidbase == CONTENT_LAVA) return TRUE;    // Melts in lava!
        }
    }

	// Update:  Reflector shield.
	// Watching attacks bounce off the reflector shield is fun, even if the
	// dragon knows better not to attack.  Therefore, dragon must be alert
	// to avoid attacking.  (Otherwise, what fun would that be to the player?)
    if (ent.ryuflags & RYU_ALERT)
        if (ent.enemy)
            if (HasReflection (ent.enemy, self.origin, 0)) return TRUE;    // Attacks can bounce back.

    return FALSE;   // May attack.
};

// This checks if the dragon should strafe. Returns true if should strafe.
float() Ryu_DoStrafe = {
    if (ImmuneToDamage (self)) return FALSE; // No need to circle-strafe if invulnerable.
    if (self.inpain >= time) return TRUE; // Always strafe if it wants to, especially after flinching from pain.
    if (self.enemy.xfl & XFL_ZOMBIE) return FALSE; // Always approach zombies, unless panicked. Reason is only melee attacks can hurt them.

    if (random() < 0.5) { // If inclined to strafe, do it half the time.  
        if (self.enemy.attack_finished >= time) return TRUE; // Strafe when enemy attacked recently.
        if (self.enemy.show_hostile >= time) return TRUE;
    }
    return FALSE; // Dragon decided not to strafe after all.
};

// The dragon decides whether to strafe or hold still while attacking. Used in missile attacks.
void() Ryu_StrafeOption = {
    if (Ryu_DoStrafe ()) {
        self.attack_state = AS_SLIDING;
        if (random() < 0.5) self.lefty = !self.lefty;
        return;
    }
    self.attack_state = AS_STRAIGHT;    // Don't strafe.
};

//  This checks if the dragon is allowed to make a step toward its enemy.
//  Conditions that force the dragon to either stand its ground or dodge
//  incoming threats causes this function to return FALSE.  Otherwise,
//  the dragon will be allowed to step forward and TRUE will be returned.
float(float melee) ryu_step = {
    local float evade, r, dist;

    ai_face();
    if (!ImmuneToDamage (self)) {
        evade = TRUE;
        if (melee) {   // Disable evasion if attempting a melee with nearby opponent.
            r = (self.maxs_x + self.enemy.maxs_x) * 1.4142 + 30;
            if (r < 120) r = 120;    // Standard melee range.
            if (vlen(self.enemy.origin - self.origin) <= r) evade = FALSE;      // In range, close in for the kill.
        }
        if (evade) { // If evade is still TRUE, enemy moved out of range, so back off.
            if (self.ryuflags & RYU_ALERT) {
                if (Ryu_DetectDanger (self.speed)) return FALSE;
            } else {
                if (self.attack_state != AS_SLIDING)
                    if (Ryu_DetectDanger(SPEED_RYU_MIN)) return FALSE;
            }
        }
    }

    if (self.attack_state == AS_SLIDING) { // Check if the dragon is in strafe mode.
        ryu_tilt (self.lefty, self.speed);
        dist = ryu_slide_speed (self.speed);
        // Call 'ai_face' before (done above)...
        ai_run_bank(dist); // PM replaced 'ai_run_circle (self.speed);' with new bank code.
        ai_face(); // ...AND after the move function to circlestrafe.
        return FALSE;
    }

    ryu_untilt(); // Undo any angle changes due to evasion.
    return TRUE; // Proceed forward.
};

void() ryu_melee = {
    if (ryu_step(TRUE)) movetogoal(SPEED_RYU_MIN);   // Close in on the opponent.
};

// Any monster, regardless of size, uses one of three clipping hull sizes.
//
//  if (size_x < 3)
//      clip size:  '0 0 0'
//  else if (size_x <= 32)
//      clip size:  mins = '-16 -16 -24', maxs = '16 16 32'
//  else
//      clip size:  mins = '-32 -32 -24', maxs = '32 32 64'
//
// The largest clip size available is size_x = 64.
//
// Monsters whose actual size is bigger than the largest hull size will
// clip into the north and east walls.  Their bbox begins at the point
// mins, and ends at mins + '64 64 88'.  The excess is ignored, which is
// why they clip into said walls.
//
// To fix the clipping problem, move a test clip box of the largest size
// multiple times from different points.  If each test move succeeds,
// then the actual move should not clip any walls... in theory.
//
// Notes about the anti-clip code below:
// size_x <= 64:  Totally unnecessary, just use one of the standard hulls.
//
// 64 < size_x <= 128:  Works almost flawlessly.
//
// size_x > 128:  Works okay with simple architecture and a relatively flat
//  and smooth floor and ceiling (such as the open sky).  Works not-so-well
//  with complex architecture and broken terrain, where the dragon may clip
//  walls and get stuck inside of them.
float(float yaw, float dist) Wyrm_WalkMove = {
    local   entity  swap;
    local   vector  org, add;
    local   float   flat, up, lo, hi;

    org = self.origin;
    setorigin (move_box, self.origin);
    setsize (move_box, self.mins, self.maxs);
    move_box.flags      = FL_FLY;
    move_box.angles     = self.angles;
    move_box.ideal_yaw  = self.ideal_yaw;
    move_box.enemy      = self.enemy;   // For walkmove's up/down motion.
    move_box.goalentity = self.goalentity;
    move_box.owner      = self;         // So box can pass through owner.
	// Splash sound control.  Synchronize builtin water values with the dragon's.  Otherwise, any time the dragon is underwater, Quake will think the
	// hull box enters water when it moves, resulting in repeating splash sounds each frame.
    move_box.waterlevel = self.waterlevel;
    move_box.watertype  = self.watertype;
    swap = self;
    self = move_box;
    if (!Ryu_WalkMove (yaw, dist)) {self = swap; return FALSE;} // Check if the dragon could move at all.  Use the move box to test the move.  This checks the SW corner.

    flat = FALSE;
    up = self.origin_z; // Remember this!  All movement must have the same elevation.

	// The dragon could move, so now use move box to check.
	// The SW corner is guaranteed to move correctly, so check the other corners.
    lo = swap.mins_x + 32;
    hi = swap.maxs_x - 32;
    setsize (move_box, VEC_HULL2_MIN, VEC_HULL2_MAX); // Reset hull size to standard big size.
    add = VEC_ORIGIN;
	
	// Check NW corner.
    add_x = lo;
    add_y = hi;
    setorigin (self, org + add);
    if (!Ryu_WalkMove (yaw, dist)) {self = swap; return FALSE;}
    if (self.origin_z != up) flat = TRUE;
	
	// Check NE corner.
    add_x = hi;
    setorigin (self, org + add);
    if (!Ryu_WalkMove (yaw, dist)) {self = swap; return FALSE;}
    if (self.origin_z != up) flat = TRUE;
	
	// Check SE corner.
    add_y = lo;
    setorigin (self, org + add);
    if (!Ryu_WalkMove (yaw, dist)) {self = swap; return FALSE;}
    if (self.origin_z != up) flat = TRUE;
	
	// If the dragon is larger than a 128x128 area, areas between the corners must be checked too.  Otherwise, we are done.
    if (swap.maxs_x > 96) { // 4x4 -- Safe up to 256x256.
		// Check S face.
        add_x = 32;
        setorigin (self, org + add);
        if (!Ryu_WalkMove (yaw, dist)) {self = swap; return FALSE;}
        if (self.origin_z != up) flat = TRUE;
		
        add_x = -32;
        setorigin (self, org + add);
        if (!Ryu_WalkMove (yaw, dist)) {self = swap; return FALSE;}
        if (self.origin_z != up) flat = TRUE;
		
		// Check N face.
        add_y = hi;
        setorigin (self, org + add);
        if (!Ryu_WalkMove (yaw, dist)) {self = swap; return FALSE;}
        if (self.origin_z != up) flat = TRUE;
		
        add_x = 32;
        setorigin (self, org + add);
        if (!Ryu_WalkMove (yaw, dist)) {self = swap; return FALSE;}
        if (self.origin_z != up) flat = TRUE;
		
		// Check W face.
        add_x = lo;
        add_y = 32;
        setorigin (self, org + add);
        if (!Ryu_WalkMove (yaw, dist)) {self = swap; return FALSE;}
        if (self.origin_z != up) flat = TRUE;
		
        add_y = -32;
        setorigin (self, org + add);
        if (!Ryu_WalkMove (yaw, dist)) {self = swap; return FALSE;}
        if (self.origin_z != up) flat = TRUE;
		
		// Check E face.
        add_x = hi;
        setorigin (self, org + add);
        if (!Ryu_WalkMove (yaw, dist)) {self = swap; return FALSE;}
        if (self.origin_z != up) flat = TRUE;
		
        add_y = 32;
        setorigin (self, org + add);
        if (!Ryu_WalkMove (yaw, dist)) {self = swap; return FALSE;}
        if (self.origin_z != up) flat = TRUE;
		
		// Check the middle.  Yes, we need to do this too to prevent the dragon for clipping things directly above or below it, such as the tops of pyramids or obelisks.
        add_x = 32;
        setorigin (self, org + add);
        if (!Ryu_WalkMove (yaw, dist)) {self = swap; return FALSE;}
        if (self.origin_z != up) flat = TRUE;
		
        add_x = -32;
        setorigin (self, org + add);
        if (!Ryu_WalkMove (yaw, dist)) {self = swap; return FALSE;}
        if (self.origin_z != up) flat = TRUE;
		
        add_y = -32;
        setorigin (self, org + add);
        if (!Ryu_WalkMove (yaw, dist)) {self = swap; return FALSE;}
        if (self.origin_z != up) flat = TRUE;
		
        add_x = 32;
        setorigin (self, org + add);
        if (!Ryu_WalkMove (yaw, dist)) {self = swap; return FALSE;}
        if (self.origin_z != up) flat = TRUE;
		
    } else if (swap.maxs_x > 64) { // 3x3 -- Safe up to 192x192.
		// Check S face.
        add_x = 0;
        setorigin (self, org + add);
        if (!Ryu_WalkMove (yaw, dist)) {self = swap; return FALSE;}
        if (self.origin_z != up) flat = TRUE;
		
		// Check N face.
        add_y = hi;
        setorigin (self, org + add);
        if (!Ryu_WalkMove (yaw, dist)) {self = swap; return FALSE;}
        if (self.origin_z != up) flat = TRUE;
		
		// Check W face.
        add_x = lo;
        add_y = 0;
        setorigin (self, org + add);
        if (!Ryu_WalkMove (yaw, dist)) {self = swap; return FALSE;}
        if (self.origin_z != up) flat = TRUE;
		
		// Check E face.
        add_x = hi;
        setorigin (self, org + add);
        if (!Ryu_WalkMove (yaw, dist)) {self = swap; return FALSE;}
        if (self.origin_z != up) flat = TRUE;
		
		// Check the middle.  Yes, we need to do this too to prevent the dragon for clipping things directly above or below it, such as the tops of pyramids or obelisks.
        add_x = 0;
        setorigin (self, org + add);
        if (!Ryu_WalkMove (yaw, dist)) {self = swap; return FALSE;}
        if (self.origin_z != up) flat = TRUE;
    }

	// Test movement successful.  Now move the dragon for real.
    self = swap;
    if (flat) return flat_move (yaw, dist);
    return Ryu_WalkMove (yaw, dist);
};