.float  dodge_back;     // Time to reverse dodge, sort of like lefty.
entity() RandomPlayer;

// edict.spawnflags
float   SPAWN_WYRM  = 2;    // Upgrades dragon to full Qtest-sized.
float   SPAWN_FAST  = 4;
float   SPAWN_SLOW  = 8;
float   SPAWNx_SKILL= 12;   // Combo - 4+8.

////////////////////////////////////////////////////////////////////////////
//  1.1.  Custom MoveToGoal AI                                            //
//                                                                        //
//  The fundamentals!  Used when neither 'walkmove' nor 'movetogoal'      //
//  alone are good enough.  This takes care of the problems of water      //
//  immersion and wall clipping.                                          //
////////////////////////////////////////////////////////////////////////////

//  Basic Movement
// Checks if the dragon should be allowed to move freely, or horizontal only.
// TRUE = Free move allowed, FALSE = Flat move only.
float() Ryu_UseFreeMove = {
    local   vector  spot;
    local   float   diff, pc;

    if (!self.enemy) return TRUE; // Movement is automatically flat.
    if (self.h2olevel) return TRUE; // Get out of the water ASAP.

	// The point of flat movement is to prevent the dragon from entering water. Builtin movement functions move the dragon 8 pixels toward its enemy
	// per call.  Therefore, plot a point 7 pixels away from the bbox edge. If the point is in an offending liquid, use flat movement code to prevent entry.
	// Also, if the dragon has a bbox maxs_z greater than 64, use flat movement to prevent (or greatly reduce the chance of) the dragon from clipping the ceiling.
	// NOTE:  Checks current point only, not post-move point.  Fix this!
    spot = self.origin;
    diff = spot_z - self.enemy.origin_z;
    if (diff < 30)
        spot_z = spot_z + self.maxs_z + 7;  // Going up.
    else if (diff > 40)
        spot_z = spot_z + self.mins_z - 7;  // Going down.
    else
        return TRUE; // Already level, so no need to use flat move code because the engine code will do that for us.

    pc = pointcontents(spot);
	// Don't let big dragons clip the ceiling. NOTE:  Doesn't always work -- fix.
    if (pc == CONTENT_SOLID)
        if (self.maxs_z > 64) return FALSE; // Stop huge dragons from clipping the ceiling.

	// Check for water.  Dragons who are afraid of water never go in.
	// Dragons not afraid of water may enter water, but NOT slime/lava, unless the dragon has invunlerability.  No dragon may enter a sky brush.
    if (self.ryuflags & RYU_NO_WATER) diff = CONTENT_WATER;   // Never go into water no matter what.
    else if (self.cross_finished > time + 3) diff = CONTENT_SKY;     // Protected from elements by cross.
    else diff = CONTENT_SLIME;   // Even those who can swim won't enter this.

	// If test spot goes into the water, use flat move code.
    return (pc > diff);
};

float(float yaw, float dist) Ryu_WalkMove = {
    if (Ryu_UseFreeMove ()) return walkmove(yaw, dist);
    return flat_move(yaw, dist);
};

void(float dist) Ryu_MoveToGoal = {
    if (Ryu_UseFreeMove ()) movetogoal (dist);
    else flat_goal (dist);
};

////////////////////////////////////////////////////////////////////////////
//  1.2.  Dragon Movement AI                                              //
//                                                                        //
//  Does collision checking as well as detecting and dodging projectiles  //
//  or other dangerous entities nearby the dragon.                        //
//                                                                        //
//  Also deals with situations that involve water.                        //
////////////////////////////////////////////////////////////////////////////

//==========================================================================
//  Angular Movement

// Reverses angle changes caused by tilting.  Should be called each frame
// unless the dragon needs to tilt.
void() ryu_untilt = {
    if (self.angles_z != 0) {
        if (self.angles_z < -5)
            self.angles_z = self.angles_z + 5;
        else if (self.angles_z < 5)
            self.angles_z = 0;
        else //if (self.angles_z > 5)
            self.angles_z = self.angles_z - 5;
    }
};

// Called whenever the dragon strafes, this tilts the dragon's angles_z.
// Note:  If called by wyrm AI, dist should always be high for big turns.
// FIXME:  Should confirm angles with 'anglemod'.
void(float left, float dist) ryu_tilt = {
    local   float   hi;

    if (dist > 20)
        {dist = 10; hi = 30;}   // Fast -- Running
    else
        {dist = 5; hi = 20;}    // Slow -- Walking

    if (left) { // Going left.
        hi = 0 - hi;
        left = self.angles_z - dist;
        if (left < hi) left = hi;
    } else { // Going right.
        left = self.angles_z + dist;
        if (left > hi) left = hi;
    }
    self.angles_z = left;
};

// Returns the distance the dragon should move while strafing.  The idea is
// the dragon takes time to accelerate to full speed while sidestepping.
// However, the dragon will never move slower than the allowed minimum.
float(float dist) ryu_slide_speed = {
    if (dist <= SPEED_RYU_MIN) return SPEED_RYU_MIN;

    // Note:  Make sure the angle divisor matches the fast 'hi' in the
    // above tilt function.
    dist = (dist - SPEED_RYU_MIN) * (fabs(self.angles_z) / 30);
    dist = floor(dist) + SPEED_RYU_MIN;
    return dist;
};

//==========================================================================
//  Vertical Movement
//  This checks if the dragon should stay away from water.  Dragons that
//  only have breath weapons that are ineffective or too dangerous to use
//  underwater are usually afraid of water.  However, a dragon that is on
//  fire will venture into water, even if it normally avoids water.
//  Update:  Monsters can drown or fry in water.  Remember that!
//------------------------------------------------------------------------//
float() Ryu_HatesWater = {
    if (self.invincible_finished <= time + 3) { // Powerups ring at T-3 seconds.
        // Cheap hack -- make the dragon afraid of water when low on air.
        // Give at least five seconds because the dragon may either be in
        // deep water or caught up in battle.
        if (!(self.xfl & XFL_NO_AIR))   // SoE:  Disabled drowning
            if (self.air_finished < time + 5) return TRUE;    // Running out of air, so leave the water now!

        // If frying in the hot sauce, get out!  Even the new dragon move AI won't stop it from entering such liquid via teleportation.
        if (self.h2otype <= CONTENT_SLIME) return TRUE;    // Burning in slime or lava!
    }

    if (IsBurning (self)) return FALSE;   // Any dragon on fire won't mind taking a dip.
    return (self.ryuflags & RYU_NO_WATER);  // Return fear status.
};

//  This tells the dragon to escape a pool of water when true.
float(float dist) Ryu_LeaveWater = {
    // Check if air is above the water (like above a pool or river)
    // from an underwater point.
    traceline (self.origin, self.origin + '0 0 2048', FALSE, self);
    if (trace_inopen)
        if (trace_inwater)
            if (ai_up (dist)) return TRUE;

    // Removed:  Don't bother checking for air below water.  No air is detected, continue on present course.
    return FALSE;
};

//  If a dragon is in the water, this makes the dragon rise out of it.
float(float dist) Ryu_GetOutOfWater = {
    if (Ryu_HatesWater ()) {
        if (self.h2olevel) {
            if (Ryu_LeaveWater (dist)) return TRUE;
		}
	}
    return FALSE;
};


//  The dragon flies up or down based on current conditions.
void(float dist, entity ent) Ryu_VerticalSlide = {
    local float delta;

	// If in the unlikely event a water-fearing dragon is in the water,
	// find some air and go in the direction it is found.
	if (self.classtype != CT_MONSHADE) {
		if (Ryu_GetOutOfWater (dist)) return;
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
        dist = 0 - dist;
    } else { // Thinking about going up.
        if (self.goalentity)
            if (self.origin_z - self.goalentity.origin_z > 1000) return;     // Don't fly so high up beyond medium range.
    }
    ai_up (dist); // Now we're really going.
};

//==========================================================================
//  Danger Evasion

//  Fly toward to direction that will most likely dodge the threat.
void(float newyaw, float dist, entity threat) Ryu_Dodge = {
    local   entity  targ;

	// Strafe away from the detected danger.  If path is blocked,
	// flag it with a time so that future checks use a different path.
    if (!walkmove (newyaw, dist)) {
        if (self.dodge_back > time)
            self.dodge_back = 0;
        else
            self.dodge_back = time + 0.5 + random();
    }
    targ = self.goalentity;
    self.ideal_yaw = vectoyaw (targ.origin - self.origin); 
    ChangeYaw (); // Face its goal.

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
    Ryu_VerticalSlide (dist, targ);
};

//  Find the best direction to head for.
float(float theta) Ryu_ChangeCourse = {
    theta = anglemod (theta);
    if (theta < 60)   return -90;   // Dodge right.
    if (theta < 120)  return 0;     // Continue straight ahead.
    if (theta < 180)  return -90;   // Dodge right.
    if (theta < 240)  return 90;    // Dodge left.
    if (theta < 300)  return 0;     // Continue straight ahead.
    return 90;                      // Dodge left.
};

//  Compare the yaws of the dragon's direction and the direction
//  toward the threat, and find the best direction to dodge the
//  threat on the results.
void(float dist, entity ent) Ryu_FindBestPath = {
    local   float   yaw;

    yaw = vectoyaw (ent.origin - self.origin);
    yaw = Ryu_ChangeCourse (yaw - self.angles_y);
    if (self.dodge_back > time) yaw = 0 - yaw; // Reverse direction if blocked recently.
    if (yaw != 0) { //Flip the dragon and adjust speed based on its angles. Sidestep.  +yaw = left, -yaw = right.
        ryu_tilt (yaw > 0, dist);
        dist = ryu_slide_speed (dist);
    } else ryu_untilt ();
    Ryu_Dodge (self.angles_y + yaw, dist, ent); // Set new course and head in that direction if possible.
};

// Danger Detection.  This tells the dragon whether or not it is best to stay away from the entity.
// TRUE is returned if the dragon should stay away.
// FALSE is returned if the dragon is better off closing in on entity. Only alert dragons can spot who the entity is and what kind of weapons, items, or other abilities it has.
float(entity ent) Ryu_KeepAway = {
	local float dist;

    if (IsBurning(ent) && self.resist_fire < 1) return TRUE; // Check for burning first because even the stupid know that fire is bad.
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
					if (ent.classgroup == CG_BOSS || ent.bossflag || ent.xfl & XFL_BOSS) return TRUE;
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
    if (ent.owner == self) return FALSE; // Ignore entities owned by its owner (for obvious reasons).

    // Check if entity is an avoidable projectile.
    if (IsMissile (ent)) { // Found a projectile.  See if the dragon should avoid it.
        if (ent.enemy == self)
        {   // Homing missile.
            if (ent.yaw_speed >= 180)
                return FALSE;   // Can't dodge this (vore/wrath) missile.
            return infront(ent);    // Dodge only if seen; hope it misses.
        }

        // Check if projectile can hit dragon.
        // NOTE:  32 = 16 for missile clip bonus + 16 for 2 builtin z moves.
        if (ent.velocity_z > 0)
        {   if (ent.origin_z > self.origin_z + self.maxs_z + 32)
                return FALSE;   // Can't hit dragon below if going up.
        }
        else if (ent.velocity_z < 0)
        {   if (ent.origin_z < self.origin_z + self.mins_z - 32)
                return FALSE;   // Can't hit dragon above if going down.
        }

    // Note:  If this section slows play too much, remove and return TRUE.
        // Check distance to projectile now (before) vs. one frame later
        // (after).  If the expected distance increases (before < after),
        // assume projectile is flying away and ignore it.  Otherwise,
        // assume it is incoming and avoid it.
        local   vector  vec;
        local   float   before, after;

        vec = ent.origin - self.origin;
        before = vlen(vec);
        after = vlen(vec + (ent.velocity*0.1));
        return (before >= after);
    }

    // Decide whether or not to stay away from the entity detected.
    return Ryu_KeepAway (ent);
};

//  This searches for dangerous entities near the dragon.
entity() Ryu_FindThreat = {
    local   entity  head;

    // Return the first threat found (if any).
    // Note:  Proper radius is ((maxs_x / 16) * 25) + 275.
    head = findradius(self.origin, self.maxs_x * 1.5625 + 275);
    while (head) {
        if (head != self) {
            traceline (self.origin, head.origin, TRUE, self);
            if (trace_fraction == 1)
                if (Ryu_IsHostile (head)) return head;    // Got one!
        }
        head = head.chain;
    }

    // If the function made it this far, nothing valid was found.
    return head;
};

//------------------------------------------------------------------------//
//  This checks if a dangerous entity is nearby and if so, get out of
//  its way.
//------------------------------------------------------------------------//
float(float dist) Ryu_DetectDanger = {
	// Find the first entity that poses a threat if any are nearby.
    local   entity  head;

    head = Ryu_FindThreat ();
    if (head) {Ryu_FindBestPath (dist, head); return TRUE;}   // Got one!
    return FALSE;   // Nothing dangerous was found.
};


////////////////////////////////////////////////////////////////////////////
//  1.3.  General Dragon AI                                               //
//                                                                        //
//  Dictates the AI of the dragons.                                       //
////////////////////////////////////////////////////////////////////////////

//  Dragon Combat
//  This checks if the dragon cannot use its missile attacks because of some detrimental side effect that could result from it.
float(entity ent) Ryu_NoShot = {
    local float element;

    if (ent.h2olevel > 1) {
        element = ent.ryuflags & RYU_ELEMENTS;
        if (element == RYU_USE_LITE) return TRUE;    // Lightning is useless underwater.
        else if (element == RYU_USE_ICE) { 
            if (ent.h2otype == CONTENT_LAVA) return TRUE;    // Melts in lava!
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

//==========================================================================
//  Dragon Behavior

//  This checks if the dragon should strafe. Returns true if should strafe.
float() Ryu_DoStrafe = {
    if (ImmuneToDamage (self)) return FALSE; // No need to circle-strafe if invulnerable.
    if (self.inpain >= time) return TRUE; // Always strafe if it wants to, especially after flinching from pain.
    if (self.enemy.xfl & XFL_ZOMBIE) return FALSE; // Always approach zombies, unless panicked. Reason is only melee attacks can hurt them.

    // If inclined to strafe, do it half the time.
    if (random() < 0.5) { // Strafe when enemy attacked recently.
        if (self.enemy.attack_finished >= time) return TRUE;
        if (self.enemy.show_hostile >= time) return TRUE;
    }

    // Dragon decided not to strafe after all.
    return FALSE;
};

//  The dragon decides whether to strafe or hold still while attacking. Used in missile attacks.
void() Ryu_StrafeOption = {
    if (Ryu_DoStrafe ()) {
        self.attack_state = AS_SLIDING;
        if (random() < 0.5) self.lefty = !self.lefty;
        return;
    }
    self.attack_state = AS_STRAIGHT;    // Don't strafe.
};

//------------------------------------------------------------------------//
//  This checks if the dragon is allowed to make a step toward its enemy.
//  Conditions that force the dragon to either stand its ground or dodge
//  incoming threats causes this function to return FALSE.  Otherwise,
//  the dragon will be allowed to step forward and TRUE will be returned.
//------------------------------------------------------------------------//
float(float melee) ryu_step = {
    local float evade, r, dist;

    ai_face ();
    if (!ImmuneToDamage (self)) {
        evade = TRUE;
        if (melee) {   // Disable evasion if attempting a melee with nearby opponent.
            r = (self.maxs_x + self.enemy.maxs_x) * 1.4142 + 30;
            if (r < 120) r = 120;    // Standard melee range.
            if (vlen(self.enemy.origin - self.origin) <= r) evade = FALSE;      // In range, close in for the kill.
            // If evade is still TRUE, enemy moved out of range, so back off.
        }
        if (evade) {
            if (self.ryuflags & RYU_ALERT) {
                if (Ryu_DetectDanger (self.speed)) return FALSE;
            } else {
                if (self.attack_state != AS_SLIDING)
                    if (Ryu_DetectDanger (SPEED_RYU_MIN)) return FALSE;
            }
        }
    }

    // Check if the dragon is in strafe mode.
    if (self.attack_state == AS_SLIDING) {
        ryu_tilt (self.lefty, self.speed);
        dist = ryu_slide_speed (self.speed);
        // Replaced 'ai_run_circle (self.speed);' with new bank code. Call 'ai_face' before AND after the move function to circlestrafe.
        ai_face ();
        ai_run_bank (dist);
        ai_face ();
        return FALSE;
    }

	// Proceed forward.
    ryu_untilt ();  // Undo any angle changes due to evasion.
    return TRUE;
};

void() ryu_melee = {
    if (ryu_step (TRUE)) movetogoal(SPEED_RYU_MIN);   // Close in on the opponent.
};

//  Face and close in on the opponent while attacking.
void() ryu_missile = {
    if (ryu_step (FALSE)) walkmove (self.angles_y, SPEED_RYU_MIN);    // Move straight in.
};