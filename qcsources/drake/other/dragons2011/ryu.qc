//==========================================================================
//
// DRAGON
// (The Qtest/Drake version)
//
//==========================================================================

$cd progs/dragon
$origin 0 0 24
$base base 
$skin skin


$frame fly1 fly2 fly3 fly4 fly5 fly6 fly7 fly8

$frame attack1 attack2 attack3 attack4 attack5 attack6
$frame attack7 attack8 attack9

$frame pain1 pain2 pain3 pain4 pain5 pain6

$frame painb1 painb2 painb3 painb4 painb5 painb6

$frame painc1 painc2 painc3 painc4 painc5 painc6

$frame death1 death2 death3 death4 death5 death6 death7 death8 death9
$frame death10 death11 death12 death13

$frame deathb1 deathb2 deathb3 deathb4 deathb5 deathb6

$frame decap1 decap2 decap3 decap4 decap5 decap6 decap7 decap8 decap9
$frame decap10 decap11 decap12 decap13

$frame decapb1 decapb2 decapb3 decapb4 decapb5 decapb6


////////////////////////////////////////////////////////////////////////////
//  1.0.  Definitions                                                     //
//                                                                        //
//  Custom constants, fields, and prototypes used by Dragons.             //
////////////////////////////////////////////////////////////////////////////

//- - Fields - -
.float  dodge_back;     // Time to reverse dodge, sort of like lefty.
// Replaced panic_time with inpain.

//- - Constants - -
float   RYU_RANGE_MELEE = 120;
float   RYU_RANGE_BEST  = 750;      // Maximum range for shot spray.
float   RYU_RANGE_MAX   = 2000;     // Maximum attack range.

// edict.skin
float   SKIN_RED        = 0;
float   SKIN_GREEN      = 1;
float   SKIN_BLUE       = 2;
float   SKIN_WHITE      = 3;
float   SKIN_GOLD       = 4;        // Kept only for Soul of Evil.
//float   SKIN_BLACK      = 5;

// edict.speed
float   SPEED_RYU_MIN   = 8;
float   SPEED_RYU_SLOW  = 20;

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

//==========================================================================
//  Basic Movement

// Checks if the dragon should be allowed to move freely, or horizontal only.
// TRUE = Free move allowed, FALSE = Flat move only.
float() Ryu_UseFreeMove =
{
    if (!self.enemy)
        return TRUE;    // Movement is automatically flat.
    if (self.h2olevel)
        return TRUE;    // Get out of the water ASAP.

//- - - - - - - - -
// The point of flat movement is to prevent the dragon from entering water.
// Builtin movement functions move the dragon 8 pixels toward its enemy
// per call.  Therefore, plot a point 7 pixels away from the bbox edge.
// If the point is in an offending liquid, use flat movement code to
// prevent entry.
//
// Also, if the dragon has a bbox maxs_z greater than 64, use flat movement
// to prevent (or greatly reduce the chance of) the dragon from clipping
// the ceiling.
//- - - - - - - - -
    local   vector  spot;
    local   float   diff, pc;

// NOTE:  Checks current point only, not post-move point.  Fix this!
    spot = self.origin;
    diff = spot_z - self.enemy.origin_z;
    if (diff < 30)
        spot_z = spot_z + self.maxs_z + 7;  // Going up.
    else if (diff > 40)
        spot_z = spot_z + self.mins_z - 7;  // Going down.
    else
        return TRUE;    // Already level, so no need to use flat move code
                        // because the engine code will do that for us.

    pc = pointcontents(spot);

// Don't let big dragons clip the ceiling.
// NOTE:  Doesn't always work -- fix.
    if (pc == CONTENT_SOLID)
        if (self.maxs_z > 64)
            return FALSE;   // Stop huge dragons from clipping the ceiling.

// Check for water.  Dragons who are afraid of water never go in.
// Dragons not afraid of water may enter water, but NOT slime/lava,
// unless the dragon has invunlerability.  No dragon may enter a sky brush.
    if (self.ryuflags & RYU_NO_WATER)
        diff = CONTENT_WATER;   // Never go into water no matter what.
    else if (self.invincible_time > time + 3)
        diff = CONTENT_SKY;     // Invulnerable!
    else
        diff = CONTENT_SLIME;   // Even those who can swim won't enter this.

// If test spot goes into the water, use flat move code.
    return (pc > diff);
};

float(float yaw, float dist) Ryu_WalkMove =
{
    if (Ryu_UseFreeMove ())
        return walkmove (yaw, dist);
    return flat_move (yaw, dist);
};

void(float dist) Ryu_MoveToGoal =
{
    if (Ryu_UseFreeMove ())
        movetogoal (dist);
    else
        flat_goal (dist);
};

//- - - - - - - - -
//  Wyrm_WalkMove
//- - - - - - - - -
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
//- - - - - - - - -
float(float yaw, float dist) Wyrm_WalkMove =
{
    local   entity  swap;
    local   vector  org;
    local   float   flat, up;

    org = self.origin;

// Prepare empty hull for movement.
    setorigin (move_box, self.origin);
    setsize (move_box, self.mins, self.maxs);
//    move_box.solid      = SOLID_NOT;
//    move_box.movetype   = self.movetype;
    move_box.flags      = FL_FLY;
    move_box.angles     = self.angles;
    move_box.ideal_yaw  = self.ideal_yaw;
    move_box.enemy      = self.enemy;   // For walkmove's up/down motion.
    move_box.goalentity = self.goalentity;
    move_box.owner      = self;         // So box can pass through owner.
// Splash sound control.  Synchronize builtin water values with the dragon's.
// Otherwise, any time the dragon is underwater, Quake will think the
// hull box enters water when it moves, resulting in repeating splash
// sounds each frame.
    move_box.waterlevel = self.waterlevel;
    move_box.watertype  = self.watertype;

    swap = self;
    self = move_box;

// Check if the dragon could move at all.  Use the move box to test the move.
// This checks the SW corner.
    if (!Ryu_WalkMove (yaw, dist))
        {self = swap; return FALSE;}

// Remember this!  All movement must have the same elevation.
    flat = FALSE;
    up = self.origin_z;

// The dragon could move, so now use move box to check.
// The SW corner is guaranteed to move correctly, so check the other corners.
    local   float   lo, hi;
    local   vector  add;

    lo = swap.mins_x + 32;
    hi = swap.maxs_x - 32;

// Reset hull size to standard big size.
    setsize (move_box, VEC_HULL2_MIN, VEC_HULL2_MAX);

    add = '0 0 0';
// Check NW corner.
    add_x = lo;
    add_y = hi;
    setorigin (self, org + add);
    if (!Ryu_WalkMove (yaw, dist))
        {self = swap; return FALSE;}
    if (self.origin_z != up)
        flat = TRUE;
// Check NE corner.
    add_x = hi;
    setorigin (self, org + add);
    if (!Ryu_WalkMove (yaw, dist))
        {self = swap; return FALSE;}
    if (self.origin_z != up)
        flat = TRUE;
// Check SE corner.
    add_y = lo;
    setorigin (self, org + add);
    if (!Ryu_WalkMove (yaw, dist))
        {self = swap; return FALSE;}
    if (self.origin_z != up)
        flat = TRUE;
// If the dragon is larger than a 128x128 area, areas between the corners
// must be checked too.  Otherwise, we are done.
    if (swap.maxs_x > 96)
    {   // 4x4 -- Safe up to 256x256.
    // Check S face.
        add_x = 32;
        setorigin (self, org + add);
        if (!Ryu_WalkMove (yaw, dist))
            {self = swap; return FALSE;}
        if (self.origin_z != up)
            flat = TRUE;
        add_x = -32;
        setorigin (self, org + add);
        if (!Ryu_WalkMove (yaw, dist))
            {self = swap; return FALSE;}
        if (self.origin_z != up)
            flat = TRUE;
    // Check N face.
        add_y = hi;
        setorigin (self, org + add);
        if (!Ryu_WalkMove (yaw, dist))
            {self = swap; return FALSE;}
        if (self.origin_z != up)
            flat = TRUE;
        add_x = 32;
        setorigin (self, org + add);
        if (!Ryu_WalkMove (yaw, dist))
            {self = swap; return FALSE;}
        if (self.origin_z != up)
            flat = TRUE;
    // Check W face.
        add_x = lo;
        add_y = 32;
        setorigin (self, org + add);
        if (!Ryu_WalkMove (yaw, dist))
            {self = swap; return FALSE;}
        if (self.origin_z != up)
            flat = TRUE;
        add_y = -32;
        setorigin (self, org + add);
        if (!Ryu_WalkMove (yaw, dist))
            {self = swap; return FALSE;}
        if (self.origin_z != up)
            flat = TRUE;
    // Check E face.
        add_x = hi;
        setorigin (self, org + add);
        if (!Ryu_WalkMove (yaw, dist))
            {self = swap; return FALSE;}
        if (self.origin_z != up)
            flat = TRUE;
        add_y = 32;
        setorigin (self, org + add);
        if (!Ryu_WalkMove (yaw, dist))
            {self = swap; return FALSE;}
        if (self.origin_z != up)
            flat = TRUE;
    // Check the middle.  Yes, we need to do this too to prevent the
    // dragon for clipping things directly above or below it, such as
    // the tops of pyramids or obelisks.
        add_x = 32;
        setorigin (self, org + add);
        if (!Ryu_WalkMove (yaw, dist))
            {self = swap; return FALSE;}
        if (self.origin_z != up)
            flat = TRUE;
        add_x = -32;
        setorigin (self, org + add);
        if (!Ryu_WalkMove (yaw, dist))
            {self = swap; return FALSE;}
        if (self.origin_z != up)
            flat = TRUE;
        add_y = -32;
        setorigin (self, org + add);
        if (!Ryu_WalkMove (yaw, dist))
            {self = swap; return FALSE;}
        if (self.origin_z != up)
            flat = TRUE;
        add_x = 32;
        setorigin (self, org + add);
        if (!Ryu_WalkMove (yaw, dist))
            {self = swap; return FALSE;}
        if (self.origin_z != up)
            flat = TRUE;
    }
    else if (swap.maxs_x > 64)
    {   // 3x3 -- Safe up to 192x192.
    // Check S face.
        add_x = 0;
        setorigin (self, org + add);
        if (!Ryu_WalkMove (yaw, dist))
            {self = swap; return FALSE;}
        if (self.origin_z != up)
            flat = TRUE;
    // Check N face.
        add_y = hi;
        setorigin (self, org + add);
        if (!Ryu_WalkMove (yaw, dist))
            {self = swap; return FALSE;}
        if (self.origin_z != up)
            flat = TRUE;
    // Check W face.
        add_x = lo;
        add_y = 0;
        setorigin (self, org + add);
        if (!Ryu_WalkMove (yaw, dist))
            {self = swap; return FALSE;}
        if (self.origin_z != up)
            flat = TRUE;
    // Check E face.
        add_x = hi;
        setorigin (self, org + add);
        if (!Ryu_WalkMove (yaw, dist))
            {self = swap; return FALSE;}
        if (self.origin_z != up)
            flat = TRUE;
    // Check the middle.  Yes, we need to do this too to prevent the
    // dragon for clipping things directly above or below it, such as
    // the tops of pyramids or obelisks.
        add_x = 0;
        setorigin (self, org + add);
        if (!Ryu_WalkMove (yaw, dist))
            {self = swap; return FALSE;}
        if (self.origin_z != up)
            flat = TRUE;
    }

// Test movement successful.  Now move the dragon for real.
    self = swap;
    if (flat)
        return flat_move (yaw, dist);
    return Ryu_WalkMove (yaw, dist);
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
void() ryu_untilt =
{
    if (self.angles_z != 0)
    {
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
void(float left, float dist) ryu_tilt =
{
    local   float   hi;

    if (dist > 20)
        {dist = 10; hi = 30;}   // Fast -- Running
    else
        {dist = 5; hi = 20;}    // Slow -- Walking

    if (left)
    {   // Going left.
        hi = 0 - hi;
        left = self.angles_z - dist;
        if (left < hi)
            left = hi;
    }
    else
    {   // Going right.
        left = self.angles_z + dist;
        if (left > hi)
            left = hi;
    }
    self.angles_z = left;
};

// Returns the distance the dragon should move while strafing.  The idea is
// the dragon takes time to accelerate to full speed while sidestepping.
// However, the dragon will never move slower than the allowed minimum.
float(float dist) ryu_slide_speed =
{
    if (dist <= SPEED_RYU_MIN)
        return SPEED_RYU_MIN;

    // Note:  Make sure the angle divisor matches the fast 'hi' in the
    // above tilt function.
    dist = (dist - SPEED_RYU_MIN) * (fabs(self.angles_z) / 30);
    dist = floor(dist) + SPEED_RYU_MIN;
    return dist;
};

//=============
// ai_run_bank -- Custom strafing AI for Dragons!
//
// Move to the side of ideal_yaw.  Assumes ideal_yaw was set prior to a
// call to this function.  While similar to 'ai_run_slide', this function
// has two important differences.
//
// * Only one move attempt is made.  If it fails, it does not get a second
//   try to move to the other side.
//
// * If the move fails, the 'lefty' value is toggled only if 'self' was
//   leaning toward the side it tried to move to.
//
// This is used to help provide the illusion of a momentum change.
//=============
void(float dist) ai_run_bank =
{
    local   float   ofs, flip;
    
    if (self.lefty)
        {ofs = 90;  flip = (self.angles_z < 0);}
    else
        {ofs = -90;  flip = (self.angles_z > 0);}

    if (!safe_move (self.ideal_yaw + ofs, dist))  // Do this first to move!
        if (flip)
            self.lefty = !self.lefty;
};


//==========================================================================
//  Vertical Movement

//------------------------------------------------------------------------//
//  This checks if the dragon should stay away from water.  Dragons that
//  only have breath weapons that are ineffective or too dangerous to use
//  underwater are usually afraid of water.  However, a dragon that is on
//  fire will venture into water, even if it normally avoids water.
//
//  Update:  Monsters can drown or fry in water.  Remember that!
//------------------------------------------------------------------------//
float() Ryu_HatesWater =
{
/* Commented out Drake only stuff.  Not supported in standard.
    if (self.invincible_time <= time + 3)   // Powerups ring at T-3 seconds.
    {
        // Cheap hack -- make the dragon afraid of water when low on air.
        // Give at least five seconds because the dragon may either be in
        // deep water or caught up in battle.
        if (!(self.xfl & XFL_NO_AIR))
            if (self.air_finished < time + 5)
                return TRUE;    // Running out of air, so leave the water now!

        // If frying in the hot sauce, get out!  Even the new dragon move AI
        // won't stop it from entering such liquid via teleportation.
        if (self.h2otype <= CONTENT_SLIME)
            return TRUE;    // Burning in slime or lava!
    }

// PM:  Burning removed!
//    if (IsBurning (self))
//        return FALSE;   // Any dragon on fire won't mind taking a dip.
*/

    return (self.ryuflags & RYU_NO_WATER);  // Return fear status.
};

//------------------------------------------------------------------------//
//  This tells the dragon to escape a pool of water.
//------------------------------------------------------------------------//
float(float dist) Ryu_LeaveWater =
{
    // Check if air is above the water (like above a pool or river)
    // from an underwater point.
    traceline (self.origin, self.origin + '0 0 2048', FALSE, self);
    if (trace_inopen)
        if (trace_inwater)
            if (ai_up (dist))
                return TRUE;

    // Removed:  Don't bother checking for air below water.

    // No air is detected, continue on present course.
    return FALSE;
};

//------------------------------------------------------------------------//
//  If a dragon is in the water, this makes the dragon rise out of it.
//------------------------------------------------------------------------//
float(float dist) Ryu_GetOutOfWater =
{
    if (Ryu_HatesWater ())
        if (self.h2olevel)
            if (Ryu_LeaveWater (dist))
                return TRUE;

    return FALSE;
};

//------------------------------------------------------------------------//
//  The dragon flies up or down based on current conditions.
//------------------------------------------------------------------------//
void(float dist, entity ent) Ryu_VerticalSlide =
{
// If in the unlikely event a water-fearing dragon is in the water,
// find some air and go in the direction it is found.
    if (Ryu_GetOutOfWater (dist))
        return;

// Fly away from... whatever 'ent' is.
    if (ent.origin_z > self.origin_z)
    {   // Going down would increase chances of evading ent.
        // Do it only if dragon is already above the goalentity.
        if (self.goalentity)
        {
            local   float   delta;

            delta = (self.origin_z + 30) - self.goalentity.origin_z;
            if (delta < 0)
                return;     // Don't go down when climbing toward a goal.
            if (delta < dist)
                dist = delta;   // Don't descend fully.
        }
        dist = 0 - dist;
    }
    else
    {   // Thinking about going up.
        if (self.goalentity)
            if (self.origin_z - self.goalentity.origin_z > 1000)
                return;     // Don't fly so high up beyond medium range.
    }
// Now we're really going.
    ai_up (dist);
};


//==========================================================================
//  Danger Evasion

//------------------------------------------------------------------------//
//  Fly toward to direction that will most likely dodge the threat.
//------------------------------------------------------------------------//
void(float newyaw, float dist, entity threat) Ryu_Dodge =
{
// Strafe away from the detected danger.  If path is blocked,
// flag it with a time so that future checks use a different path.
    if (!safe_move (newyaw, dist))
    {
        if (self.dodge_back > time)
            self.dodge_back = 0;
        else
            self.dodge_back = time + 0.5 + random();
    }

    local   entity  targ;

    targ = self.goalentity;

// Face its goal.
    self.ideal_yaw = vectoyaw (targ.origin - self.origin);
    ChangeYaw ();

// Next, check if the dragon should slide vertically away from its goal.
    if (targ != threat)
    {
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

//------------------------------------------------------------------------//
//  Find the best direction to head for.
//------------------------------------------------------------------------//
float(float theta) Ryu_ChangeCourse =
{
    theta = anglemod (theta);
    if (theta < 60)   return -90;   // Dodge right.
    if (theta < 120)  return 0;     // Continue straight ahead.
    if (theta < 180)  return -90;   // Dodge right.
    if (theta < 240)  return 90;    // Dodge left.
    if (theta < 300)  return 0;     // Continue straight ahead.
    return 90;                      // Dodge left.
};

//------------------------------------------------------------------------//
//  Compare the yaws of the dragon's direction and the direction
//  toward the threat, and find the best direction to dodge the
//  threat on the results.
//------------------------------------------------------------------------//
void(float dist, entity ent) Ryu_FindBestPath =
{
    local   float   yaw;

    yaw = vectoyaw (ent.origin - self.origin);
    yaw = Ryu_ChangeCourse (yaw - self.angles_y);
    if (self.dodge_back > time)
        yaw = 0 - yaw;      // Reverse direction if blocked recently.

// Flip the dragon and adjust speed based on its angles.
    if (yaw != 0)
    {   // Sidestep.  +yaw = left, -yaw = right.
        ryu_tilt (yaw > 0, dist);
        dist = ryu_slide_speed (dist);
    }
    else
        ryu_untilt ();

// Set new course and head in that direction if possible.
    Ryu_Dodge (self.angles_y + yaw, dist, ent);
};


//==========================================================================
//  Danger Detection

//------------------------------------------------------------------------//
//  This tells the dragon whether or not it is best to stay away from
//  the entity.  TRUE is returned if the dragon should stay away.
//  FALSE is returned if the dragon is better off closing in on entity.
//  Only alert dragons can spot who the entity is and what kind of
//  weapons, items, or other abilities it has.
//------------------------------------------------------------------------//
float(entity ent) Ryu_KeepAway =
{
// Begin standard check.
    if (!(self.ryuflags & RYU_ALERT))
        return FALSE;   // Not smart enough to use keep away tactics.
    if (!self.th_missile)
        return FALSE;   // Has no choice but to attack up close.

// DRAGONS 2011:  Check living monsters or players.
    if (ent.health > 0)
    if (ent.flags & (FL_CLIENT|FL_MONSTER))
    {
        if (ent.invincible_finished || ent.super_damage_finished)
            return TRUE;    // Avoid if using invulnerability or quad damage.

    // Stay away from the following:
    // NOTE:  Threat flags must be assigned to monsters in their own file.
    // Update 6/2/2011:  Removed .threat field and simplified checks.
        // Stay away from the following entities only if it is an enemy.
        // Update:  Ditto if the dragon is targeted by one of them.
        if ((self.enemy == ent) || (ent.enemy == self))
        {
            if (ent.enemy == self)
                if (ent.health > self.health)
                    return TRUE;    // Evade targets tougher than the dragon.

            if (self.health <= 100)
            {   // Dragon becomes more evasive when weakened.
                if (ent.flags & FL_MONSTER)
                    if (!ent.th_missile)
                        return TRUE;    // More likely to live by hanging back.
            }
        }
    }

    // It is best to close in on the enemy.
    return FALSE;
};

//------------------------------------------------------------------------//
//  This checks if the entity found is dangerous and should be avoided
//  (if possible).
//------------------------------------------------------------------------//
float(entity ent) Ryu_IsHostile =
{
    // Ignore entities owned by its owner (for obvious reasons).
    if (ent.owner == self)
        return FALSE;

    // Check if entity is an avoidable projectile.
    if (IsMissile (ent))
    {   // Found a projectile.  See if the dragon should avoid it.
        if (ent.enemy == self)
        {   // Homing missile.
            if (self.owner.classname == "monster_shalrath")     //(ent.yaw_speed >= 180)
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
    //- - - - - - - - -
    }

    // Decide whether or not to stay away from the entity detected.
    return Ryu_KeepAway (ent);
};

//------------------------------------------------------------------------//
//  This searches for dangerous entities near the dragon.
//------------------------------------------------------------------------//
entity() Ryu_FindThreat =
{
    local   entity  head;

    // Return the first threat found (if any).
    // Note:  Proper radius is ((maxs_x / 16) * 25) + 275.
    head = findradius(self.origin, self.maxs_x * 1.5625 + 275);
    while (head)
    {
        if (head != self)
        {
            traceline (self.origin, head.origin, TRUE, self);
            if (trace_fraction == 1)
                if (Ryu_IsHostile (head))
                    return head;    // Got one!
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
float(float dist) Ryu_DetectDanger =
{
// Find the first entity that poses a threat if any are nearby.
    local   entity  head;

    head = Ryu_FindThreat ();
    if (head)
        {Ryu_FindBestPath (dist, head); return TRUE;}   // Got one!
    return FALSE;   // Nothing dangerous was found.
};


////////////////////////////////////////////////////////////////////////////
//  1.3.  General Dragon AI                                               //
//                                                                        //
//  Dictates the AI of the dragons.                                       //
////////////////////////////////////////////////////////////////////////////

//==========================================================================
//  Dragon Combat

//------------------------------------------------------------------------//
//  This checks if the dragon cannot use its missile attacks because
//  of some detrimental side effect that could result from it.
//------------------------------------------------------------------------//
float(entity ent) Ryu_NoShot =
{
    if (ent.h2olevel > 1)
    {
        local   float   element;

        element = ent.ryuflags & RYU_ELEMENTS;
        if (element == RYU_USE_LITE)
            return TRUE;    // Lightning is useless underwater.
        else if (element == RYU_USE_ICE)
        {   if (ent.h2otype == CONTENT_LAVA)
                return TRUE;    // Melts in lava!
        }
    }
/* DISABLED -- Reflection is in Drake only, so this is useless.
//- - - - - - - - -
// Update:  Reflector shield.
// Watching attacks bounce off the reflector shield is fun, even if the
// dragon knows better not to attack.  Therefore, dragon must be alert
// to avoid attacking.  (Otherwise, what fun would that be to the player?)
    if (ent.ryuflags & RYU_ALERT)
        if (ent.enemy)
            if (HasReflection (ent.enemy, self.origin, 0))
                return TRUE;    // Attacks can bounce back.
//- - - - - - - - -
*/
    return FALSE;   // May attack.
};

//------------------------------------------------------------------------//
//  Check if an attack can be made.
//------------------------------------------------------------------------//
float() DragonCheckAttack =
{
    local   vector  spot1, spot2;
    local   entity  targ;
    local   float   nofire;     // Melee only if TRUE.
    local   float   chance, reach;

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
    if (trace_ent != targ)
    {
        // Could not see the target.
        if (trace_fraction < 1)
        {   // Blocked by obstacle.  If blocked by monster, flag it so
            // dragon may try to move around it vertically.
            targ = trace_ent;
            {
                if (targ)
                    if (targ.solid == SOLID_SLIDEBOX)
                        if (targ.health > 0)
                            self.attack_state = AS_SLIDING;
            }
/* PM:  Drake stuff, don't bother with target checking.
            if (DontHurtMe (targ))
                return FALSE;

        // Whoever blocked the way is an enemy too, so continue the check.
            chance = 0;     // Disable melee this time.
            targ = self.enemy;
*/
            nofire = TRUE;
        }
        else
        {   // Target is non-solid.  (e.g., downed zombies, nightshade.)
            // Dragon can try to engage it in melee, provided the target is
            // vulnerable to damage.  Don't use missile attack because it
            // will pass through the enemy harmlessly.

            // NOTE:  Don't use ghost check because it fails on downed
            // zombies.

            if (!targ.takedamage)
                return FALSE;
// Commented out because those with no mindex should have DAMAGE_NO too.
//            if (!targ.modelindex)
//                return FALSE;

/* PM:  Ghosts applicable only in Drake.
            // Update:  Lightning will hit ghosts, so fail only if either
            // does not apply.
            if (self.ryuflags & RYU_ELEMENTS != RYU_USE_LITE)
                nofire = TRUE;
            else if (!IsGhost (targ))
                nofire = TRUE;
*/
            nofire = TRUE;
        }
    }

    // If target is reachable within melee range, the dragon will attack
    // the target if the dragon has a melee attack.
    if (enemy_range == RANGE_MELEE)
        if (chance)
            if (self.th_melee)
                if (CanDamage (targ, self))
                {
                    self.attack_state = AS_MELEE;
                    return TRUE;
                }

// missile attack

    // Check if the dragon can shoot.
    if (nofire)
    {
        self.attack_state = AS_STRAIGHT;
        return FALSE;
    }
    if (Ryu_NoShot (self))
        return FALSE;

    // Check if allowed to attack.
    if (time < self.attack_finished)
        return FALSE;

// Determine the chance that the dragon will use its breath weapon.
    if (enemy_range == RANGE_MELEE)
    {   // Any dragon will almost certainly attack within melee range.
        self.attack_finished = 0;
        chance = 0.9;
    }
    else if (enemy_range == RANGE_NEAR)
    {   // Short range (120-500)
        chance = 0.2;
    }
    else
    {
        reach = RYU_RANGE_MAX;
        if (vlen(spot2 - spot1) > reach)
        {   // Target is outside of attack range.
            self.attack_state = AS_STRAIGHT;
            return FALSE;
        }
        if (enemy_range == RANGE_MID)
            chance = 0.1;   // Medium range (500-1000)
        else
            chance = 0.02;  // Long range (1000+)
    }

// The dragon decides whether to attack or move on.
    if (random () < chance)
    {
        local   float   pause;

        pause = random() * 2 + 1;   // Has long attack anim.
        SUB_AttackFinished (pause);   // Reversed in custom 'ai.qc' too.
        self.th_missile ();
        return TRUE;
    }

// If the function made it this far, the dragon moves on.
    return FALSE;
};


//==========================================================================
//  Dragon Behavior

//------------------------------------------------------------------------//
//  This checks if the dragon should strafe.
//------------------------------------------------------------------------//
float() Ryu_DoStrafe =
{
    // Always strafe if it wants to, especially after flinching from pain.
    if (self.inpain >= time)
        return TRUE;

    if (self.enemy.classname == "monster_zombie")   //(self.enemy.xfl & XFL_ZOMBIE)
        return FALSE;   // Always approach zombies, unless panicked.
                        // Reason is only melee attacks can hurt them.

    // If inclined to strafe, do it half the time.
    if (random() < 0.5)
    {   // Strafe when enemy attacked recently.
        if (self.enemy.attack_finished >= time)
            return TRUE;
        if (self.enemy.show_hostile >= time)
            return TRUE;
    }

    // Dragon decided not to strafe after all.
    return FALSE;
};

//------------------------------------------------------------------------//
//  The dragon decides whether to strafe or hold still while attacking.
//  Used in missile attacks.
//------------------------------------------------------------------------//
void() Ryu_StrafeOption =
{
    if (Ryu_DoStrafe ())
    {
        self.attack_state = AS_SLIDING;
        if (random() < 0.5)
            self.lefty = !self.lefty;
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
float(float melee) ryu_step =
{
    // Turn to face enemy.
    ai_face ();

    {
        local   float   evade;

        evade = TRUE;
        if (melee)
        {   // Disable evasion if attempting a melee with nearby opponent.
            local   float   r;

            r = (self.maxs_x + self.enemy.maxs_x) * 1.4142 + 30;
            if (r < 120)
                r = 120;    // Standard melee range.
            if (vlen(self.enemy.origin - self.origin) <= r)
                evade = FALSE;      // In range, close in for the kill.
            // If evade is still TRUE, enemy moved out of range, so back off.
        }
        if (evade)
        {
            if (self.ryuflags & RYU_ALERT)
            {
                if (Ryu_DetectDanger (self.speed))
                    return FALSE;
            }
            else
            {
                if (self.attack_state != AS_SLIDING)
                    if (Ryu_DetectDanger (SPEED_RYU_MIN))
                        return FALSE;
            }
        }
    }

    // Check if the dragon is in strafe mode.
    if (self.attack_state == AS_SLIDING)
    {
        local   float   dist;

        ryu_tilt (self.lefty, self.speed);

        dist = ryu_slide_speed (self.speed);
        // Replaced 'ai_run_circle (self.speed);' with new bank code.
        // Call 'ai_face' before AND after the move function to circlestrafe.
        ai_face ();
        ai_run_bank (dist);
        ai_face ();

        return FALSE;
    }

// Proceed forward.
    ryu_untilt ();  // Undo any angle changes due to evasion.
    return TRUE;
};

//------------------------------------------------------------------------//
//  The dragon is engaged in melee with its opponent.
//------------------------------------------------------------------------//
void() ryu_melee =
{
    if (ryu_step (TRUE))
        safe_goal (SPEED_RYU_MIN);   // Close in on the opponent.
};

//------------------------------------------------------------------------//
//  Face and close in on the opponent while attacking.
//------------------------------------------------------------------------//
void() ryu_missile =
{
    if (ryu_step (FALSE))
        safe_move (self.angles_y, SPEED_RYU_MIN);    // Move straight in.
};

//------------------------------------------------------------------------//
//  The dragon hovers in place.  If a water-fearing dragon is
//  underwater, it will escape the pool if possible. 
//
//  The dragon glides along its path.  Like ryu_stand(), a
//  water-fearing dragon will try to escape from any body of
//  water if it is placed in one.
//------------------------------------------------------------------------//
void(float dist) ryu_idle =
{
    if (Ryu_HatesWater ())
    {
        if (self.h2olevel)
        {
            if (Ryu_LeaveWater (self.speed))
                return;
        // Dragon could not rise toward air.  If in walk mode, increase
        // speed in the hope of finding another way toward air faster.
            if (dist)       // In walk mode.
                dist = self.speed;
        }
    }

    ryu_untilt ();  // Undo any angle changes due to evasion.

    if (dist)
        safe_goal (dist);
};

void() ryu_stand =
{
    if (FindTarget ())
        return;

    ryu_idle (0);   // This will eject the dragon from water.
};

void() ryu_walk =
{
    if (FindTarget ())
        return;

    ryu_idle (SPEED_RYU_MIN);
};

//------------------------------------------------------------------------//
//  This checks whether the dragon is allowed to attack its target
//  when one is in air while the other is in liquid.
//------------------------------------------------------------------------//
float() Ryu_BlockCrossfire =
{
    if (self.th_missile)
    {
        local   float   elements;

        elements = self.ryuflags & RYU_ELEMENTS;
        if (elements == RYU_USE_LITE)
            return FALSE;   // Shoot lightning into water to fry targets.
        else if (elements == RYU_USE_ICE)
        {   // Don't shoot ice if either endpoint is in lava.
            if (self.h2otype == CONTENT_LAVA)
                if (self.h2olevel > 1)
                    return TRUE;    // Mouth in lava.
            if (self.enemy.h2otype == CONTENT_LAVA)
                if (self.enemy.h2olevel == 3)
                    return TRUE;    // Target covered under lava.
        }
        // Check alert AFTER element check.
        if (self.ryuflags & RYU_ALERT)
            return FALSE;   // Smart enough to aim through water.
    }
    // Cannot attack at all.
    return TRUE;
};

//------------------------------------------------------------------------//
//  This checks if the dragon's target can be seen.  This is different
//  from the original visible() function in that some dragons can see
//  a swimming target through the water.
//------------------------------------------------------------------------//
float(entity targ) ryu_visible =
{
    local   vector  spot1, spot2;
    
    spot1 = self.origin + self.view_ofs;
    spot2 = targ.origin + targ.view_ofs;
    traceline (spot1, spot2, TRUE, self);   // see through other monsters
    
    // Some dragons can see targets through liquid while others cannot.
    if (trace_inopen)
        if (trace_inwater)
            if (Ryu_BlockCrossfire ())
                if (vlen(self.enemy.origin - self.origin) > 120)
                    return FALSE;

    return (trace_fraction == 1);
};

//------------------------------------------------------------------------//
//  The dragon rotates in place (via multiple calls to this function)
//  until it faces its opponent.  Upon facing an opponent, the dragon
//  will launch an attack.
//------------------------------------------------------------------------//
void() ryu_run_attack =
{
    // Rotate to face opponent.
    self.ideal_yaw = enemy_yaw;
    ChangeYaw ();

    // Check if dragon is facing opponent.  If so, attack!
    if (FacingIdeal ())
    {
        self.attack_state = AS_STRAIGHT;

        // Check for melee attack first.
        if (enemy_range == RANGE_MELEE)
            if (self.th_melee)
            {
                self.th_melee ();
                return;
            }

        // Not close enough for melee, so shoot instead if possible.
        if (self.th_missile)
            if (!Ryu_NoShot (self))
            {
//                if (!IsGhost (self.enemy))
                {
                    self.th_missile ();
                    return;
                }
            }
    }

    // Break off the attack if a projectile or some other danger is nearby.
    if (Ryu_DetectDanger (self.speed))
        self.attack_state = AS_STRAIGHT;
};

//------------------------------------------------------------------------//
//  This checks if the dragon is able to attack the target.
//------------------------------------------------------------------------//
float() Draco_CanAttackTarget =
{
    if (!enemy_vis)
        return FALSE;   // Standard.  Must see the target.
    if (!self.enemy.takedamage)
        return FALSE;   // In case mega-enforcer shields stays on long.
    // Don't let water-hating dragons get stuck trying to shoot zombies
    // that are underwater to death -- it is useless.
    if (Ryu_HatesWater ())
        if (self.enemy.classname == "monster_zombie")   //xfl & XFL_ZOMBIE)    // Anyone harmed only by scar.
            if (!self.h2olevel)
                if (self.enemy.h2olevel > 2)
                    return FALSE;

    return TRUE;
};

//- - - - - - - - -
// Imported from Drake's ai.qc.
// Check if self should stop running after enemy.
float() ai_run_kill =
{
    local   float   roar;

// Check for victory sound.  Must do first because enemy will be changed.
// Sound is played only if enemy slain is a client.
    roar = FALSE;
    if (self.enemy)
        if (self.enemy.classname == "player")
            if (self.enemy.enemy == self)   // enemy set at death.
                roar = TRUE;

    self.enemy = world;
// FIXME: look all around for other targets
    if (self.oldenemy.health > 0)
    {
        self.enemy = self.oldenemy;
        self.oldenemy = world;
        // FIXME:  Replace with simpler version without the thinking.
        HuntTarget ();
    }
    else
    {
        if (roar)
        {
            if (self.maxs_x <= 32)
                sound (self, CHAN_VOICE, "dragon/idle2.wav", 1, ATTN_NORM);
            else
                sound (self, CHAN_VOICE, "dragon/idle1.wav", 1, ATTN_NORM);
        }
        self.enemy = self.oldenemy = world;
        if (self.movetarget)
            self.th_walk ();
        else
            self.th_stand ();
        return TRUE;
    }
    return FALSE;
};
//- - - - - - - - -

//------------------------------------------------------------------------//
//  The dragon is flying around while fighting.  It may attack,
//  dodge missiles, or just simply move toward the opponent at
//  normal running speed.
//------------------------------------------------------------------------//
void() ryu_run =
{
    local   float   standby;
    local   float   dist;

    dist = self.speed;

    standby = 5;    // Standard.

//- - - - - - - - - - - - - -
// see if the enemy is dead
    if (self.enemy.health <= 0)
        if (ai_run_kill ())
            return;
//- - - - - - - - - - - - - -

// DISABLED:  Monsters reveal themselves only when waking up or attacking.
// This change was done due to the new alignment rules.
//    self.show_hostile = time + 1;        // wake up other monsters

// check knowledge of enemy
    enemy_vis = ryu_visible(self.enemy);
    if (enemy_vis)
        self.search_time = time + 5;

// look for other targets if current target is unavailable.
// Do this in single-player and DM because of minions and their alignment.
    if (self.search_time < time)
    {
        // Hasn't seen enemy in a while.  Get out of strafe mode.
        if (self.attack_state == AS_SLIDING)
            self.attack_state = AS_STRAIGHT;

        if (FindTarget ())
            return;
    }

//    enemy_infront = infront(self.enemy);
    enemy_range = range(self.enemy);
    enemy_yaw = vectoyaw(self.enemy.origin - self.origin);

    if (self.attack_state == AS_MELEE)
        {ryu_run_attack (); return;}

// Hunt mode.
    if (enemy_vis)
        if (DragonCheckAttack ())
        {   self.show_hostile = time + 1;   // wake up other monsters
            return;         // beginning an attack
        }

    // Avoid projectiles or other threats.
    if (Ryu_DetectDanger (self.speed))
        return;

    ryu_untilt ();  // Undo any angle changes due to evasion.

    // If the dragon does not like water, stay away from it.
    if (Ryu_GetOutOfWater (self.speed))
        return;

// Check if dragon is in strafe mode.
    if (self.attack_state == AS_SLIDING)
    {
    // Set enemy to world for the first move so dragon stays at same
    // altitude.  Dragon should not sink toward enemy if it is trying
    // to fly up and away for whatever reason.
        local   entity  e;

        e = self.enemy;
        self.enemy = world;
        safe_goal (dist);
        self.enemy = e;

        Ryu_VerticalSlide (dist, self.enemy);
        return;
    }

// head straight in
    // Fast, larger dragons sometimes have trouble closing in for melee.
    // In close range, check if normal speed is too fast.  If so, fly in
    // at minimum speed.
    dist = self.speed;
    if (enemy_range == RANGE_NEAR)
        if (QC_CloseEnough (dist))
            dist = SPEED_RYU_MIN;
    safe_goal (dist);
};


////////////////////////////////////////////////////////////////////////////
//  1.4.  Wyrm AI                                                         //
//                                                                        //
//  Special AI for huge (full Qtest-sized) boss dragons.                  //
////////////////////////////////////////////////////////////////////////////

// Finds a random player in the game.
entity() RandomPlayer =
{
    local   entity  e;

    e = find (world, classname, "player");
    if (deathmatch || coop)
    {
        local   float   loop;

        loop = 0;
        while (e)
        {   loop = loop + 1;
            e = find (e, classname, "player");
        }
        loop = loop * random();
        loop = ceil (loop);
        e = world;
        do
        {
            e = find (e, classname, "player");
            loop = loop - 1;
        } while (loop > 0);
    }
    return e;
};

// Movement when not on a path.
void() wyrm_glide =
{
    local   entity  swap;
    local   float   sped, ofs, left;

// Fly at walk speed when idle or run speed when mad at someone.
    sped = 20;
    if (self.enemy)
        if (!self.spawnflags & SPAWN_SLOW)
            sped = 32;

// Change angles.
    ofs = anglemod(self.angles_y - self.ideal_yaw);
    if (ofs >= 180)
        {left = 1;  ofs = ofs - 360;}
    else
        left = 0;
    ChangeYaw ();
    if (fabs(ofs) <= self.yaw_speed)
        {ryu_untilt ();  left = 1;}
    else
        {ryu_tilt (left, 32);  left = 0;  sped = 20;}

// Forward movement.
    swap = self.enemy;
    self.enemy = world;
//- - - - - - - - -
    if (!self.th_move (self.angles_y, sped))
    {   // Something got in the way.
        if (left)
            self.ideal_yaw = anglemod(self.ideal_yaw + 180);
    }
//- - - - - - - - -
    self.enemy = swap;
};

// Normal move.
void(entity targ) wyrm_move =
{
    local   entity  swap, oe;
    local   float   sped, ofs, left, oy, nopath;
    local   vector  ang;

    if (self.movetarget)
        nopath = FALSE;
    else
        nopath = TRUE;

    sped = 20;
    if (self.enemy)
        if (!self.spawnflags & SPAWN_SLOW)
            if (targ != self.enemy)     // Attacking if FALSE.
                sped = 32;

    self.goalentity = targ;     // In case we need 'movetogoal'.
    self.ideal_yaw = vectoyaw(targ.origin - self.origin);

    // Remember previous angles in case we need to change them back.
    ang = self.angles;
    oy = self.ideal_yaw;
// Change angles.
    ofs = anglemod(self.angles_y - self.ideal_yaw);
    if (ofs >= 180)
        {left = 1;  ofs = ofs - 360;}
    else
        left = 0;
    ChangeYaw ();
    if (fabs(ofs) <= self.yaw_speed)
        ryu_untilt ();
    else
        {ryu_tilt (left, sped);  sped = 20;}

// Forward movement.
    swap = self.enemy;
    if (nopath || (targ != self.enemy))
        self.enemy = world;

    oe = self.enemy;
    if (!self.th_move (self.angles_y, sped))
    {   // Something got in the way.
        if (!self.enemy)
        {   // Restore previous angles then bump around with movetogoal.
            self.ideal_yaw = oy;
            self.angles = ang;
            self.th_goal (sped);
            ryu_untilt ();
        }
    }
    self.enemy = oe;    // In case of change by trigger_hurt and the like.

// Vertical movement.  Must have a path to be allowed.
    if (!nopath)
        if (targ)           // If FALSE, no target to follow.
            if (!self.enemy)    // If FALSE, done already with builtin move.
            {
                left = targ.origin_z - self.origin_z;
                if (left > 8)
                    left = 8;
                else if (left < -8)
                    left = -8;
                ai_up (left);
            }

    self.enemy = swap;
};

// Checks if a target is inview for the wyrm.
float(entity targ) wyrm_inview =
{
    local   vector  spot1, spot2;

    if (targ.health <= 0)
        return FALSE;   // Dead or the world -- No target!
    if (!targ.modelindex)
        return FALSE;   // sf64 and/or eth wraith.  Treat as non-existant.
    if (targ != self.enemy)
    {
        if (targ.flags & FL_NOTARGET)
            return FALSE;   // Target has stealth.
        // This is boss AI, so ignore invisibility ring.
    }

// Is the target in front of the dragon?
    makevectors (self.angles);
    spot1 = targ.origin;
    spot1_z = self.origin_z;    // Ignore elevation difference.
    spot1 = normalize (spot1 - self.origin);
    if (spot1 * v_forward < 0)      // Was <= 0.3.
        return FALSE;   // In the rear.

// Can the dragon see the target?
    spot1 = self.origin + self.view_ofs;
    spot2 = targ.origin + targ.view_ofs;
    traceline (spot1, spot2, TRUE, self);
    // This is a boss -- cross contents won't save you, mwahaha!
    if (trace_fraction != 1)
        return FALSE;   // Cannot see target.

    // Note:  Don't bother checking for friendly fire.  Attacks tend
    // to spread out a bit, so a simple traceline check won't cut it.
    // Besides, the boss doesn't care about small fry getting in the way.

    return TRUE;    // "Rebel base in range!" -- Star Wars.
};

// TRUE = Dragon roared and won't attack, FALSE = May attack.
// Roaring stops dragon from attacking instantly, unless in Nightmare.
float(entity targ) wyrm_see_new =
{
    if (!self.enemy)
    {   // Found an enemy, so roar.
        self.enemy = targ;  // Must do before warning other monsters.
//        SoundTarget ();     // Alert other monsters and roar.
//- - - - - - - - -
        if (self.enemy.classname == "player")
        {    // let other monsters see this monster for a while
            sight_entity = self;
            sight_entity_time = time;
        }
        self.show_hostile = time + 1;        // wake up other monsters
        SightSound ();
//- - - - - - - - -
        if (skill < 3)
            return TRUE;    // Just roar only.
    }
    else
    {   // Replace oldenemy with previous enemy.
        if (self.enemy != targ)
            self.oldenemy = self.enemy;
    }
    self.enemy = targ;
    return FALSE;
};

// Scan for an enemy to attack.
void() wyrm_scan =
{
    // Update enemy list if target dies.
    if (self.enemy)
    {
        if (self.enemy.health <= 0)
        {
            self.attack_finished = 0;
            if (self.enemy.classname == "player")
                if (self.enemy.enemy == self)
                {   // Killed a PC, so gloat for a moment.
                    sound (self, CHAN_VOICE, "dragon/idle1.wav", 1, ATTN_NORM);
                }
            if (self.oldenemy.health <= 0)
                self.enemy = world;
            else
                self.enemy = self.oldenemy;
            self.oldenemy = world;
        }
    }

// NOTE:  As a wyrm, check for enemies only.
    // Check for missile attack.
    if (self.attack_finished <= time)
    {
        local   entity  targ, seen;

        seen = world;
        {   // Check for a player first, then npc next.
            // Don't use checkclient because wyrm attacks are checked only
            // in one frame once per animation cycle.
            targ = RandomPlayer ();
            if (targ != self.enemy)     // If FALSE, check targ later.
                if (wyrm_inview (targ))
                    {if (wyrm_see_new (targ)) return;  seen = targ;}
        }

        if (!seen)
        {   // No fresh meat?  Check its current targets.
            if (self.enemy)
            {
                if (!wyrm_inview (self.enemy))
                {   // Current enemy not found.
                    targ = world;
                    if (self.oldenemy)
                        if (wyrm_inview (self.oldenemy))
                            targ = self.enemy;
                    if (targ)
                    {   // Secondary enemy found, so swap targets.
                        self.enemy = self.oldenemy;
                        self.oldenemy = targ;
                    }
                    else
                    {   // No targets handy.  If target is still visible,
                        // dragon has a small chance to fire anyway.
                        if (random() < (1 - (self.yaw_speed * 0.02)))
                            return;
                        if (!visible (self.enemy))
                            return;
                    }
                }
            }
        }

        if (self.enemy)
        {
            if (self.th_missile)
                self.think = self.th_missile;
        }
    }
};


////////////////////////////////////////////////////////////////////////////
//  2.1.  Dragon Attacks                                                  //
////////////////////////////////////////////////////////////////////////////

//- - - - - - - - - - - - - - - - - - -
//  NOTE:  Use of fields normally unused (by monsters) in standard Quake.
//  Mod-makers beware!  If other custom code uses these fields,
//  make sure they do not interfere with their use by the dragons.
//
// .worldtype = attack type dragon will use; like .weapon for clients.
// .count     = max shots per salvo; like .ammo_shells for clients.
// .height    = shot damage.
// .volume    = shots remaining in a salvo.
//
// Update 9/3/09:  count/volume replaced buy shots_max/shots_left.
//
//  NOTE #2:  There are even more such recycled fields further below.
//- - - - - - - - - - - - - - - - - - -

//==========================================================================
//  Dragon Melee

//------------------------------------------------------------------------//
//  This returns the point of the dragon's mouth relative to its origin.
//  All frames from 8 to 16 are part of the attack scene.
//------------------------------------------------------------------------//
vector() Ryu_Offset =
{
    local   float   fr;

    fr = self.frame;

// Now find where the dragon's mouth is.
// FIXME:  Wyrm spawn?
    if (self.maxs_x > 96)
    {   // Wyrm/dragon2.mdl.  Assumes +20.
        if (fr==16)  return '88 -9 2';    if (fr==15)  return '92 -7 20';
        if (fr==14)  return '94 -1 32';   if (fr==13)  return '86 -1 36';
//        if (fr==12)  return '72 -1 48';   if (fr==11)  return '80 -1 32';
//        if (fr==10)  return '94 -1 24';
        return '96 -1 20';
    }
//    if (self.flags & FL_MONSTER)
    {   // Half-scale/dragon1.mdl.  Assumes +2.
        if (fr==16)  return '43 -5 -6';   if (fr==15)  return '46 -3 2';
        if (fr==14)  return '47 -1 8';    if (fr==13)  return '41 -1 12';
//        if (fr==12)  return '35 -1 17';   if (fr==11)  return '39 -1 10';
//        if (fr==10)  return '46 -1 4';
        return '47 -1 3';
    }
};

//------------------------------------------------------------------------//
//  The dragon makes a bite attack.
//------------------------------------------------------------------------//
void() Ryu_Bite =
{
    // Check if the bite attack can hit.
    if (!InMeleeRange (RYU_RANGE_MELEE))
        return;
    if (!CanDamage (self.enemy, self))
        return;
    if (!self.enemy.takedamage)   // For mega-enforcer.
        return;

    // Bite attack is successful.
    local   vector  org;        // Location of dragon's head.
    local   vector  dir;        // Velocity of meat chunk.
    local   float   damage;

    org = Ryu_Offset ();

// Inflict the damage.  Scar damage hurts and kills zombies.
// Like many of Quake2 monsters' melee attacks, damage ranges from
// x to x+5, while x is a multiple of 5, and damage has a minimum of 5.
// Note:  x = ((maxs_x / 16) - 1 + random + cranked) * 5.
// Update 4/23/2009:  Do 15-20 damage for standard.  Wyrms multiply damage.
    damage = 15 + random()*5;
// DISABLED:  Cranked is a Drake feature.
//    if (cranked)
//        damage = damage + 5;
    if (self.spawnflags & SPAWN_WYRM)   // Moot since wyrms can't bite.
        damage = damage * 4;
    sound (self, CHAN_WEAPON, "demon/dhit2.wav", 1, ATTN_NORM);
//    T_NewDamage (self.enemy, self, self, damage, DF_SCAR, "melee");
    if (self.enemy.classname == "monster_zombie")
    {   // Scar damage -- Keep track of damage done to zombies.
        self.enemy.count = self.enemy.count + damage;
        if (self.enemy.count >= self.enemy.health)
            damage = self.enemy.count;      // Kill it!
    }
    T_Damage (self.enemy, self, self, damage);

// Throw a piece of meat from the dragon's head (mouth).
    makevectors (self.angles);
    org = self.origin + (v_forward*org_x) + (v_right*org_y) + (v_up*org_z);
    dir = (random() * -50) * v_forward;
    dir = dir + ((random() * 200 - 100) * v_right);
    SpawnMeatSpray (org, dir);
};


//==========================================================================
//  Dragon Aiming

//------------------------------------------------------------------------//
//  This returns the spot where a projectile will strike.  Dragons
//  will shoot at the spot where the target is currently standing.
//------------------------------------------------------------------------//
vector() Ryu_TargetPoint =
{
    // If the dragon has no enemy, aim straight ahead.
    if (self.enemy)
    {
        local   vector  end;

        end = Midpoint (self.enemy);

        // If target is in water and not the dragon, aim at the head.
        if (self.enemy.h2olevel >= 2)
            if (self.h2olevel < 2)
                end_z = end_z + (self.enemy.maxs_z * 0.5);

        return end;
    }
// Aiming on its own... Aim forward and slightly downward.
    makevectors (self.angles);
    return (self.origin + v_forward*1024 - '0 0 16');
};


//==========================================================================
//  Missile Attacks

//------------------------------------------------------------------------//
//  This creates a fireball shot by a dragon.  Used by both PCs and NPCs.
//------------------------------------------------------------------------//
void(vector start, vector dir, float sped, float up, float damage) Ryu_Fire =
{
    if (damage)
    {   // Big super fireball.
        Meteor_Launch (self, start, dir, sped, damage);
        newmis.delay      = time + 2.5;     // Same fuse as a grenade.
        newmis.movetype   = MOVETYPE_TOSS;
    }
    else
    {   // Normal fireball.
        // Fuse is (10 * reach / speed) + 1.  If speed is double the reach,
        // duration is 6 frames.  Fade anim is 3 frames, so the pre-fade
        // duration is 3 frames.
        // NOTE:  Don't use self.height for damage here because of PC use.
        Fireball_Launch (self, start, dir, sped, 9);
        newmis.delay      = time + 0.3;
        newmis.noise      = "dragon/firehit.wav";
        if (Fireball_InWater (newmis))
            return;
    }
    // Note:  Make sure the damage flags field is same one used in 'fire.qc'.
//    newmis.style      = newmis.style | DF_SAFE;   // Harmless to attacker.
    if (newmis.movetype == MOVETYPE_TOSS)
    {
        newmis.velocity_z = newmis.velocity_z + up;
        dir = normalize (newmis.velocity);
        newmis.angles     = vectoangles(dir) + '90 0 0';
    }
// DISABLED -- Player can't morph into a dragon in Dragons2011.
//    if (self.flags & FL_CLIENT)
//        SUB_Flash ();   // Don't light up custom muzzle flashes in Qrack.
//    else
        self.effects = self.effects | EF_MUZZLEFLASH;
};

//------------------------------------------------------------------------//
//  Ryu_Multishot (formerly Ryu_Ice)
//
//  This creates a shotgun burst of ice (or whatever).
//
//  The family of the Ps explained:
//  p1 = Origin of attack, generally out of one of the attacker's orifices.
//  p2 = Endpoint 1, generally where the target is when attack is launched.
//  p3 = Endpoint 2, where the target is predicted to be after some time.
//  p4 = Endpoint 3, a point chosen somewhere between p2 and p3.  Aim here!
//------------------------------------------------------------------------//
void(vector p1, vector p2, float sped, float damage, entity targ,
    float shots, float atype)  Ryu_Multishot =
{
    local   float   bomb;
    local   float   sped2;      // New speed for hellball.
    local   float   frac, loop;
    local   vector  dir, err, p3, p4;

// Extra stuff for more multishot types.
    bomb = atype & RYU_BOMB;
    atype = atype & RYU_ELEMENTS;

// Begin old multishot stuff.
    err = '6 4.5 0';    // For ice dragon, 5x the spread as fire spray.

    p3 = Aim_Lead (p1, p2, sped, targ);

    loop = floor(shots);
    while (loop > 0)
    {
        loop = loop - 1;    // Do first because we use 'loop - 1' in calcs.

        if (loop)
        {
            frac = 1 - (loop / shots);
            if (self.spawnflags & SPAWN_SLOW)
                frac = frac * 0.5;      // Can't fully track if slow.
            p4 = p2 + ((p3 - p2) * frac);
            sped2 = sped * (random() / 3 + 1);  // Boost speed by up to 33%.
        }
        else
        {   // Aim final shot on target.
            err = '0 0 0';
            p4 = p3;
            sped2 = sped;
        }
        traceline (p1, p4, TRUE, self);
        if (trace_fraction < 1)
            p4 = p2;    // Point is blocked, so don't lead.

        // Calculate aim vector.
        if ( bomb && (atype != RYU_USE_LITE) )
            dir = Aim_Toss (p1, p4, sped2, 200, world);
        else
            dir = normalize (p4 - p1);
        dir = Maim_Scatter (dir, err);

        if (atype & RYU_ELEMENTS == RYU_USE_ICE)
        {   // Ice spray.
            if (bomb)
            {   // Explosive iceballs.
                Iceball_Toss (p1, dir, sped2, self.height);
                newmis.velocity_z = newmis.velocity_z + 200;
            }
            else
            {   // Ice shards.  Default damage is 9, so raise it if too weak.
                Ice_Launch (p1, dir, sped2);    // Use 'sped' for same speed.
                newmis.delay = time + 0.7;  // Total duration.  Was 0.8.
            }
            if (newmis.dmg < damage)
                newmis.dmg = damage;
        }
        else if (bomb)
        {
            if (atype == RYU_USE_FIRE)
                Ryu_Fire (p1, dir, sped2, 200, self.height);
            else if (atype == RYU_USE_LITE)
                Plasma_Launch (p1, dir, sped2, self.height);
            else if (atype == RYU_USE_ACID)
            {
                Acidball_Launch (p1, dir, sped2, self.height);
                newmis.velocity_z = newmis.velocity_z + 200;
            }
        }
        // ELSE unknown attack type and do nothing.
    }
};


//==========================================================================
//  Missile Spawning

//------------------------------------------------------------------------//
//  This spawns a missile at the dragon's mouth then launches said
//  missile at the target.  The missile cast varies by type.
//------------------------------------------------------------------------//
void() Ryu_Shot_Fire =
{
    local   entity  targ;   // Use shot leading if targ != world;
    local   vector  dir;    // Vector from 'start' to 'end'.
    local   vector  start;  // Location of dragon's mouth.
    local   vector  end;    // Place where projectile will strike.
    local   float   sped;   // Missile speed or lightning bolt range.
    local   float   frac;   // Lead coefficient.  0 = no lead, 1 = perfect.

// As with players, pay ammo cost first then attack.
    if (self.shots_left < 1)
        return;     // Out of ammo.

    // Calculate lead coefficient.  The value begins at or close to zero at
    // the start of the salvo, then the value increases with each successive
    // shot until it reaches one at the final shot.
    frac = Frac_ShotDown();     // Lowers 'shots_left', pays ammo cost.
    if (self.spawnflags & SPAWN_SLOW)
        frac = frac * 0.5;      // Can't fully track if slow.

    targ = self.enemy;
    // Shot speed varies by dragon size -- bigger is faster.
    // Faster because of gravity or short range.
    // Note:  Proper speed is ((maxs_x / 16) * 100) + 600.
    // Update 4/23/2009:  1000 for dragons, 1200 for wyrms.
    // Speed may be increased by another 66%, so limit
    // speed to 1200 so that it cannot exceed 2000.
    if (self.spawnflags & SPAWN_WYRM)
        sped = 1200;
    else
        sped = 1000;

    makevectors (self.angles);

// Find the location of the dragon's mouth (or head).
    start = Ryu_Offset ();
    start = self.origin + (v_forward * start_x) + (v_right * start_y) +
        (v_up * start_z);
    end = Ryu_TargetPoint ();   // Get the spot where dragon is aiming at.

// Select an attack.
    if (self.worldtype == RYU_USE_FIRE)
    {
        sped = sped * 1.25;     // Fire spray shots are 25% faster.
        dir = Maim_LineEx (start, end, sped, targ, '1.2 0.9 0', frac);
        Ryu_Fire (start, dir, sped, 200, 0);
        if (self.height > 9)
            newmis.dmg = self.height;   // Extra damage.
//        if (qrack)
            if ( !self.shots_left || (self.shots_left == (self.shots_max - 1)) )
                newmis.effects = newmis.effects | EF_DIMLIGHT;
    }
    else if (self.worldtype == RYU_USE_ACID)
    {
        dir = Maim_TossEx (start, end, sped, 200, targ, '0 0 0', frac);
        Acid_Toss (start, dir, sped);
        if (self.height > 9)
            newmis.dmg = self.height;   // Extra damage.
    }
    else if (self.worldtype == RYU_USE_LITE)
    {
        // Check for discharge, just like Thunderbolt-wielding player.
        self.effects = self.effects | EF_MUZZLEFLASH;
        if (self.h2olevel > 1)
        {   // Dragon is deep enough in water so discharge.
            // Note:  Discharge is weak, so just fizzle harmlessly.
            sound (self, CHAN_WEAPON, "misc/power.wav", 1, ATTN_NORM);
            self.shots_left = 0;
            return;
        }

        sped = RYU_RANGE_BEST;

        // Dragon will aim bolt behind the target during the early frames
        // of a salvo.  This is done to reduce damage from an otherwise
        // unavoidable attack.  An exception is made if the target is in
        // the water, in which case, the aim becomes perfect (or rather
        // the error calcuation is skipped) to simulate water conductivity.
        if (self.enemy)
            if (self.enemy.h2olevel < 2)
                end = end - (self.enemy.velocity * ((1 - frac) * 0.2));

        dir = Maim_Line (start, end, 0, world, '0 0 0');    // Insta-hit.
        end = start + (dir * sped);

    // Create the bolt of lightning.
        LightningBolt2 (start, end, self, self.height);
    }
    else
    {   // Multiple shot attacks.
        if (self.worldtype & RYU_BOMB)
        {   // Super shots
            if (!self.ryuflags & RYU_ALERT)     // Leading is unfairly hard,
                targ = world;                   // so don't unless cranked.
            if (self.worldtype & RYU_ELEMENTS == RYU_USE_LITE)
                sped = sped - 200;      // Treat as one size less.
        }
        else if (self.worldtype & RYU_ELEMENTS == RYU_USE_ICE)
            sped = sped * 1.25;
        else
            return;     // Invalid attack type.
        self.shots_left = 0;   // Launch all shots in one burst.
        Ryu_Multishot (start, end, sped, self.height, targ, self.shots_max, self.worldtype);
    }
};

// Used for delayed calls to Ryu_Shot_Fire by Ryu_Shot.
void() Ryu_Shot_Think =
{
    if (self.owner.health > 0)      // Dead if FALSE.
        SUB_Think (self.owner, Ryu_Shot_Fire);

    remove (self);
};

// This calls the dragon's missile spawning function now or later.
// If delayed, a dummy entity to spawned to call the delayed function
// at the time designated by 'pause'.
void(float pause) Ryu_Shot =
{
    if (pause)
    {
        local   entity  echo;

        echo = spawn();
        echo.owner = self;
        echo.nextthink = time + pause;
        echo.think = Ryu_Shot_Think;
    }
    else
        Ryu_Shot_Fire ();
};


////////////////////////////////////////////////////////////////////////////
//  3.1.  Sounds                                                          //
////////////////////////////////////////////////////////////////////////////

void() ryu_sfx_fly =
{
    if (self.super_sound < time)    // Not while Quad is sounding.
    {
        if (self.h2olevel <= 1)     // Not while in the water.
            sound (self, CHAN_BODY, "dragon/fly.wav", 1, ATTN_NORM);
        else if ((self.h2otype == CONTENT_WATER) || (self.h2otype == CONTENT_SLIME))
            sound (self, CHAN_BODY, "dragon/flywater.wav", 1, ATTN_NORM);
    }
};

void() ryu_sfx_fire =
{
    local   float   type;

    type = self.worldtype & RYU_ELEMENTS;
    if (type == RYU_USE_FIRE)
        sound (self, CHAN_WEAPON, "dragon/fire.wav", 1, ATTN_NORM);
    else if (type == RYU_USE_ACID)
        sound (self, CHAN_WEAPON, "dragon/acid.wav", 1, ATTN_NORM);
    else if (type == RYU_USE_LITE)
    {
        if (self.worldtype & RYU_BOMB)
            sound (self, CHAN_WEAPON, "weapons/lstart.wav", 1, ATTN_NORM);
        else
        {
            sound (self, CHAN_WEAPON, "weapons/lstart.wav", 1, ATTN_NORM);
            sound (self, CHAN_AUTO, "weapons/lhit.wav", 1, ATTN_NORM);
        }
    }
    else if (type == RYU_USE_ICE)
        sound (self, CHAN_WEAPON, "dragon/ice.wav", 1, ATTN_NORM);
};

void() ryu_sfx_idle =
    {sound (self, CHAN_VOICE, "dragon/idle1.wav", 1, ATTN_NORM);};

void() ryu_sfx_roar =
{
    if (self.spawnflags & SPAWN_WYRM)
        sound (self, CHAN_VOICE, "dragon/sight1.wav", 1, 0.5);
    else
        sound (self, CHAN_VOICE, "dragon/sight1.wav", 1, ATTN_NORM);
    self.pain_finished = time + 1;  // Don't let pain stop the roar.
};


////////////////////////////////////////////////////////////////////////////
//  3.2.  Animation                                                       //
////////////////////////////////////////////////////////////////////////////

//============
// MOVEMENT
//============

//------------------------------------------------------------------------//
//  Fly animation forward.  Used for stand, walk, and run anims.
//
//  Stand = Dragon hovers in place.
//  Walk  = The dragon slowly glides along its path.
//  Run   = The dragon flies quickly toward the enemy.
//------------------------------------------------------------------------//
void() dragon_fly_anim =
{
    local   float   fadd;

    if ((self.frame > 7) || (self.walkframe >= 13))
        fadd = self.walkframe = 0;
    else if (self.walkframe >= 7)
        fadd = 14 - self.walkframe;
    else
        fadd = self.walkframe;

    self.frame = $fly1 + fadd;
    self.walkframe = self.walkframe + 1;

    if ( self.frame == $fly8 )
        ryu_sfx_fly ();
};

void() dragon_stand =[ $fly1, dragon_stand  ] {dragon_fly_anim(); ryu_stand();};
void() dragon_walk  =[ $fly1, dragon_walk   ] {dragon_fly_anim(); ryu_walk();};
void() dragon_run   =[ $fly1, dragon_run    ] {dragon_fly_anim(); ryu_run();};

void() wyrm_fly   =[ $fly1, wyrm_fly    ]
{
    dragon_fly_anim();

// Custom move and attack AI.
    if (self.movetarget)
        wyrm_move (self.movetarget);
    else
        wyrm_glide ();

    if ( self.frame == $fly1 )
        wyrm_scan ();
};

void() wyrm_start =
{
//    if (self.target2)
//    {
//        self.target = self.target2;
//        self.target2 = world.null_string;
//    }
    if (self.movetarget.classname != "path_corner")
    {
        self.movetarget = world;
        self.ideal_yaw = self.angles_y;
    }

    self.th_stand = self.th_walk = self.th_run = wyrm_fly;
    wyrm_fly ();
};

void() dragon_go =
{
    if (self.ryuflags & RYU_PATH)
        wyrm_fly ();
    else
        dragon_run ();
};


//============
// ATTACKS
//============
void() dragon_bite1  =[ $attack1,  dragon_bite2  ] {/*W_ShowHostile();*/ ryu_melee();};
void() dragon_bite2  =[ $attack2,  dragon_bite3  ] {ryu_melee();};
void() dragon_bite3  =[ $attack3,  dragon_bite4  ] {ryu_melee();};
void() dragon_bite4  =[ $attack4,  dragon_bite5  ] {ryu_melee();};
void() dragon_bite5  =[ $attack5,  dragon_bite6  ] {ryu_melee();};
void() dragon_bite6  =[ $attack6,  dragon_bite7  ] {ryu_melee();};
void() dragon_bite7  =[ $attack7,  dragon_bite8  ] {ryu_melee();};
void() dragon_bite8  =[ $attack8,  dragon_bite9  ] {ryu_melee();};
void() dragon_bite9  =[ $attack9,  dragon_bite10 ] {ryu_melee(); ryu_sfx_fly (); Ryu_Bite ();};
void() dragon_bite10 =[ $attack8,  dragon_bite11 ] {ryu_melee();};
void() dragon_bite11 =[ $attack7,  dragon_bite12 ] {ryu_melee();};
void() dragon_bite12 =[ $attack6,  dragon_bite13 ] {ryu_melee();};
void() dragon_bite13 =[ $attack5,  dragon_bite14 ] {ryu_melee();};
void() dragon_bite14 =[ $attack4,  dragon_bite15 ] {ryu_melee();};
void() dragon_bite15 =[ $attack3,  dragon_bite16 ] {ryu_melee();};
void() dragon_bite16 =[ $attack2,  dragon_bite17 ] {ryu_melee(); Ryu_Bite ();};
void() dragon_bite17 =[ $attack1,  dragon_go     ] {ryu_melee(); self.attack_state = AS_STRAIGHT; self.walkframe = 0;};

//------------------------------------------------------------------------//
//  This checks if the dragon can bite its target.
//------------------------------------------------------------------------//
float(float chance) Ryu_CanBite =
{
// Check if missile attack is effective or not.
    if (!self.th_missile)
        return TRUE;    // Can't shoot.
    if (Ryu_NoShot (self))
        return TRUE;    // Not allowed to fire.
    if (self.enemy.solid <= SOLID_TRIGGER)
        return TRUE;    // Missile attacks pass through non-solid enemies.

    if (Ryu_BlockCrossfire ())
    {
        // Not allowed to see into water, so check contents.
        traceline (self.origin, self.enemy.origin, TRUE, self);
        if (trace_inopen)
            if (trace_inwater)
                return TRUE;    // Can't see through water.
    }

// Now check if the dragon really wants to bite.
    if (random() < chance)
        if (InMeleeRange (RYU_RANGE_MELEE))
            return TRUE;

// Don't bite -- fire away instead.
    return FALSE;
};

//------------------------------------------------------------------------//
//  Melee attack start.  About midway into the animation, the dragon
//  decides whether to bite or to shoot something.  This is used by
//  smart dragons to foil the 'run in-and-out' strategy used by players.
//  (Also called 'shambler dance' by the authors of Quoth.)
//
//  That is, run in to trigger melee attack, then run away to make said
//  attack whiff.  
//------------------------------------------------------------------------//
void() dragon_strike =
{
    local   float   chance;

    if (self.inpain >= time)
    {   // Dragon wants to circle-strafe and shoot.
        self.attack_state = AS_SLIDING;
        if (random() < 0.5)
            self.lefty = !self.lefty;
        chance = 0;
    }
    else
    {   // Try to close in.  High chance of bite.  Always bite zombies
        // or anyone else who is hurt only by scar damage.
        self.attack_state = AS_STRAIGHT;
        if (Ryu_KeepAway (self.enemy))
            chance = 0;     // Always shoot if trying to get away.
        else if (self.enemy.classname == "monster_zombie")  //xfl & XFL_ZOMBIE)
            chance = 1;     // Bite causes scar damage.
        else
            chance = 0.8;   // Standard.
    }

    // If dragon can bite the target, do it.
    if (Ryu_CanBite (chance))
        dragon_bite1 ();
    else
        self.th_missile ();   // Shoot at target.  Assumes th_missile exists.
};

//- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

//------------------------------------------------------------------------//
//  This makes the dragon decide whether or not to use meteor instead
//  of fire spray.
//------------------------------------------------------------------------//
float() Ryu_UseSpecial =
{
    local   float   atype;

    if (self.spawnflags & SPAWN_WYRM)
        return TRUE;    // Big enough to spam multiple destructive blasts.

// Smaller dragons choose between several small shots or one big blast.
// Most small shots are faster and fatter but have limited range.
// Big shots are either slower or bound by gravity, but cause high damage
// and splash.  A spray of small shots is preferable to one big shot,
// so if the enemy is in range and not a zombie, spray away!
    atype = self.worldtype & RYU_ELEMENTS;
    if (atype == RYU_USE_FIRE)
    {   // If water is in the way, shoot meteors to penetrate it.
        if (self.h2olevel >= 2)
            return TRUE;    // Underwater.  Only meteors are effective.
        if (self.enemy)
            if (self.enemy.h2olevel >= 3)
                return TRUE;    // Target is underwater.
    }
    if (self.enemy)
    {   // If enemy is a zombie or too far away, lob big shots.
        if (self.enemy.classname == "monster_zombie")   //xfl & XFL_ZOMBIE)
        {   // Zombies need high damage to kill.
            if (atype != RYU_USE_FIRE)      // Fire causes scar damage.
                return TRUE;
        }
        if (atype != RYU_USE_ACID)      // All acid shots have same flight.
        {
            if (vlen(self.enemy.origin - self.origin) > RYU_RANGE_BEST)
                return TRUE;
        }
    }
    return FALSE;   // Spray small shots.
};

//------------------------------------------------------------------------//
//  This selects the attack used based on type.
//------------------------------------------------------------------------//
void() Ryu_SetAttack =
{
    local   float   shots;
    local   float   element;

// Select attack type.
    element = self.worldtype = self.ryuflags & RYU_ELEMENTS;
    if (Ryu_UseSpecial ())
        self.worldtype = self.worldtype | RYU_BOMB;

// Select attack based on type and change the thinking logic accordingly.
//- - - - - - - - - - - - - - - - - - -
// Recycled field alert!
// .wait        = time to add between shots in a salvo.
// .delay       = time between an attack function call and the attack itself.
//- - - - - - - - - - - - - - - - - - -
    if (self.worldtype & RYU_BOMB)
    {
        if (self.spawnflags & SPAWN_WYRM)
            shots = 4;
        else
            shots = 1;
        if (element == RYU_USE_LITE) 
            self.height = 40;
        else
            self.height = 80;
//        if (cranked)    // Increase damage by 50% if true.
//            self.height = self.height * 3 / 2;

        self.shots_max = self.shots_left = shots;
        self.wait = 0.6 / shots;
        self.delay = 0.3;
    }
    else
    {   // Generic projectile attacks
        local   float   fts;    // Frames To Shoot.
        local   float   multi;  // Multishot attack if TRUE.

//        if (cranked)
//            shots = 12;
//        else
            shots = 8;

        fts = 6;
        multi = FALSE;
        if (self.worldtype == RYU_USE_LITE)
        {
            shots = ((shots / 2) & 255) + ((random() * 2 * (shots & 1)) & 1);
            self.height = 10;   // Same damage as shambler bolt.
            if (shots > 12)
                {self.height = shots; shots = 10; fts = 5;}
        }
        else
        {
        // Damage.
            self.height = 9;
        // Special:  If too many shots, cap number and increase damage.
            if (self.worldtype == RYU_USE_FIRE)
                {if (shots > 18) {self.height = shots / 2; shots = 18;}}
            else
                {if (shots > 9) {self.height = shots; shots = 9;}}
        // Ice check.
            if (self.worldtype == RYU_USE_ICE)
                multi = TRUE;
        }
    // Shots.
        self.shots_max = self.shots_left = shots;
    // Rate of fire.
        if (shots > fts)
            self.wait = fts / 10 / shots;
        else
            self.wait = 0.1;
    // Attack delay.
    // Note:  Multishot attacks launches all ammo in an instant, so treat
    // them as single-shot.
        if ((self.shots_left <= 1) || multi)
            self.delay = 0.3;  // $attack9
        else if (self.shots_left <= 2)
            self.delay = 0.2;  // $attack8
        else if (self.shots_left <= 4)
            self.delay = 0.1;  // $attack7
        else
            self.delay = 0;    // $attack6
    }
};

// Standard missile attack for dragons.
void() ryu_rapid_fire =
{
    if (!self.wait)
        self.wait = 0.1;    // Do this to avoid infinite loop.
    else if (self.wait < 0.01)
        self.wait = 0.01;   // 10 shots per frame max -- spamtastic.

// Note:  Start _click with 0.1 or higher to delay attack.
// 0.1 is for ten frames per second, the default animation rate.
    while (self.delay < 0.1)
    {
        if (self.shots_left == self.shots_max)
            ryu_sfx_fire();     // Play sound on the first shot.
        Ryu_Shot (self.delay);     // Spawn the attack.
        self.delay = self.delay + self.wait;
    }
    self.delay = self.delay - 0.1;
};

void() dragon_ranged =
{
    if (self.ryuflags & RYU_PATH)
        wyrm_move (self.enemy);
    else
        ryu_missile ();
};
void() dragon_missile1  =[ $attack1,  dragon_missile2  ] {
//    W_ShowHostile ();
    if (!(self.ryuflags & RYU_PATH))
        Ryu_StrafeOption ();
    dragon_ranged();
};
void() dragon_missile2  =[ $attack2,  dragon_missile3  ] {dragon_ranged();};
void() dragon_missile3  =[ $attack3,  dragon_missile4  ] {dragon_ranged();};
void() dragon_missile4  =[ $attack4,  dragon_missile5  ] {dragon_ranged();};
void() dragon_missile5  =[ $attack5,  dragon_missile6  ] {dragon_ranged();};
void() dragon_missile6  =[ $attack6,  dragon_missile7  ] {dragon_ranged(); Ryu_SetAttack(); ryu_rapid_fire();};
void() dragon_missile7  =[ $attack7,  dragon_missile8  ] {dragon_ranged(); ryu_rapid_fire();};
void() dragon_missile8  =[ $attack8,  dragon_missile9  ] {dragon_ranged(); ryu_rapid_fire();};
void() dragon_missile9  =[ $attack9,  dragon_missile10 ] {dragon_ranged(); ryu_sfx_fly(); ryu_rapid_fire();};
void() dragon_missile10 =[ $attack8,  dragon_missile11 ] {dragon_ranged(); ryu_rapid_fire();};
void() dragon_missile11 =[ $attack7,  dragon_missile12 ] {dragon_ranged(); ryu_rapid_fire();};
void() dragon_missile12 =[ $attack6,  dragon_missile13 ] {dragon_ranged();};
void() dragon_missile13 =[ $attack5,  dragon_missile14 ] {dragon_ranged();};
void() dragon_missile14 =[ $attack4,  dragon_missile15 ] {dragon_ranged();};
void() dragon_missile15 =[ $attack3,  dragon_missile16 ] {dragon_ranged();};
void() dragon_missile16 =[ $attack2,  dragon_missile17 ] {dragon_ranged();};
void() dragon_missile17 =[ $attack1,  dragon_go        ] {
    dragon_ranged();
    if (self.ryuflags & RYU_PATH)
        self.attack_finished = time + (1.2 * (3 - skill));
    self.walkframe = 0;
// DISABLED -- Draco bot is obsolete and was removed.
//    self.ryuflags = self.ryuflags - (self.ryuflags & RYU_FORCED);
};
// Remove force attack flag at the end of the attack scene so the player
// can order another attack should Draco remain in fight mode.


//============
// PAIN
//============
void() dragon_pain1  =[ $pain1,   dragon_pain2  ] {ryu_untilt();};
void() dragon_pain2  =[ $pain2,   dragon_pain3  ] {ryu_untilt();};
void() dragon_pain3  =[ $pain3,   dragon_pain4  ] {ryu_untilt();};
void() dragon_pain4  =[ $pain4,   dragon_pain5  ] {ryu_untilt();};
void() dragon_pain5  =[ $pain5,   dragon_pain6  ] {ryu_untilt();};
void() dragon_pain6  =[ $pain6,   dragon_go     ] {ryu_untilt();};

void() dragon_painb1 =[ $painb1,  dragon_painb2 ] {ryu_untilt();};
void() dragon_painb2 =[ $painb2,  dragon_painb3 ] {ryu_untilt();};
void() dragon_painb3 =[ $painb3,  dragon_painb4 ] {ryu_untilt();};
void() dragon_painb4 =[ $painb4,  dragon_painb5 ] {ryu_untilt();};
void() dragon_painb5 =[ $painb5,  dragon_painb6 ] {ryu_untilt();};
void() dragon_painb6 =[ $painb6,  dragon_go     ] {ryu_untilt();};

void() dragon_painc1 =[ $painc1,  dragon_painc2 ] {ryu_untilt();};
void() dragon_painc2 =[ $painc2,  dragon_painc3 ] {ryu_untilt();};
void() dragon_painc3 =[ $painc3,  dragon_painc4 ] {ryu_untilt();};
void() dragon_painc4 =[ $painc4,  dragon_painc5 ] {ryu_untilt();};
void() dragon_painc5 =[ $painc5,  dragon_painc6 ] {ryu_untilt();};
void() dragon_painc6 =[ $painc6,  dragon_go     ] {ryu_untilt();};

void(entity attacker, float damage) dragon_pain =
{
    local   float   r;      // Multi-purpose number.
    local   string  sfx;

//- - - - - - - - -
    if (self.ryuflags & RYU_PATH)
    {   // Wyrm:  Get mad at attacker only if it is not in an attack frame.
        // Must do before proper pain code below.
        local   float   fr;

        fr = self.frame;
        if (( fr < $attack1 ) || ( fr > $attack9 ))
        {
//            if (Enemy_Check (self, attacker))
//                NewEnemy (attacker);
            if (attacker)
            if (self != attacker && attacker != self.enemy)
            if (self.classname != attacker.classname) 
            {
                if (self.enemy.classname == "player")
                    self.oldenemy = self.enemy;
                self.enemy = attacker;
                FoundTarget ();
            }
        }
    }
//- - - - - - - - -

    if (self.pain_finished > time)
        return;

    self.pain_finished = time + 1;
//- - - - - - - - -
    if (self.ryuflags & RYU_PATH)
    {   // Wyrm:  Spin toward attacker if not on a path.
        // Do only if it can show pain at this time.
        if (!self.movetarget)       // Must not have a path to follow.
        if (attacker)
        if (self.enemy == attacker)
        if (self.attack_finished <= time)   // Don't spin if it can't attack.
        if (visible (attacker))
            self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
    }
//- - - - - - - - -

    r = 400;
    sfx = "dragon/pain1.wav";

    sound (self, CHAN_VOICE, sfx, 1, ATTN_NORM);
    if ((random() * r) > damage)
        return;         // didn't flinch
    if (damage < self.health * 0.01)    // FIXME:  Use max_health instead?
        return;         // Damage dealt is too low to cause flinching.
    if (skill >= 3)
        return;         // No pain anims in Nightmare.

    self.inpain = time + 2; // Strafe soon after pain.
    self.attack_state = AS_STRAIGHT;
    self.attack_finished = 0;       // can attack anytime now!
    self.walkframe = 0;     // Reset fly anim.

// Choose one of three pain scenes.
    r = random();
    if (r < 0.4)
        dragon_pain1 ();
    else if (r < 0.7)       // Was 0.8 in older Dragons.
        dragon_painb1 ();
    else
        dragon_painc1 ();

    attacker = attacker;    // FrikQcc warning squelch!
};

//============
// DEATH
//============
void() dragon_die1  =[ $death1,   dragon_die2  ] {};
void() dragon_die2  =[ $death2,   dragon_die3  ] {};
void() dragon_die3  =[ $death3,   dragon_die4  ] {};
void() dragon_die4  =[ $death4,   dragon_die5  ] {};
void() dragon_die5  =[ $death5,   dragon_die6  ] {self.solid = SOLID_NOT;};
void() dragon_die6  =[ $death6,   dragon_die7  ] {};
void() dragon_die7  =[ $death7,   dragon_die8  ] {};
void() dragon_die8  =[ $death8,   dragon_die9  ] {};
void() dragon_die9  =[ $death9,   dragon_die10 ] {};
void() dragon_die10 =[ $death10,  dragon_die11 ] {};
void() dragon_die11 =[ $death11,  dragon_die12 ] {};
void() dragon_die12 =[ $death12,  dragon_die13 ] {};
void() dragon_die13 =[ $death13,  SUB_Null     ] {};

void() dragon_dieb1 =[ $deathb1,  dragon_dieb2 ] {};
void() dragon_dieb2 =[ $deathb2,  dragon_dieb3 ] {};
void() dragon_dieb3 =[ $deathb3,  dragon_dieb4 ] {};
void() dragon_dieb4 =[ $deathb4,  dragon_dieb5 ] {};
void() dragon_dieb5 =[ $deathb5,  dragon_dieb6 ] {self.solid = SOLID_NOT;};
void() dragon_dieb6 =[ $deathb6,  SUB_Null     ] {};

void() dragon_die =
{
// Snap tilt angles back to zero now.
    self.angles_x = self.angles_z = 0;

// Check for gib.
    if (self.health < -80)
    {
        sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
        ThrowHead ("progs/dr1_head.mdl", self.health);
        ThrowGib ("progs/dr1_lw.mdl", self.health);
        ThrowGib ("progs/dr1_rw.mdl", self.health);
        ThrowGib ("progs/dr1_tail.mdl", self.health);
        ThrowGib ("progs/gib2.mdl", self.health);    // Torso chunks
        ThrowGib ("progs/gib3.mdl", self.health);    // Red meat
        ThrowGib ("progs/gib3.mdl", self.health);    // Red meat
        return;
    }

// Regular death.
    self.velocity_x = -200 + 400*random();
    self.velocity_y = -200 + 400*random();
    self.velocity_z =  100 + 100*random();
    self.flags = self.flags - (self.flags & FL_ONGROUND);
    sound (self, CHAN_VOICE, "dragon/death1.wav", 1, ATTN_NORM);
    if (random() < 0.5)
    {   // Shove it up a little for the fallback death anim.
        self.velocity_z = 250 + 100*random();
        dragon_die1 ();
    }
    else
        dragon_dieb1 ();
};

//==========================================================================

void() death_puff =
{
    local   vector  spot;
    local   entity  puff;

    spot_x = self.absmin_x + self.size_x * random();
    spot_y = self.absmin_y + self.size_y * random();
    spot_z = self.absmin_z + self.size_z * 0.5 * random();

    puff = spawn();
    setorigin (puff, spot);
    puff.effects = EF_MUZZLEFLASH;
    sound (puff, CHAN_AUTO, "hknight/hit.wav", 1, ATTN_NORM);
    SUB_Think (puff, BecomeExplosion);  // FIXME:  Invisible in Qrack.
};

void() wyrm_explode =
{
    local   entity  swap;
    local   float   loop;
    local   vector  org;
    local   vector  vx, vy, vz;

    self.nextthink = -1;
    self.think = SUB_Null;      // It's dead for sure.

// Lavasplash particles form a box with a size of 270x270x64.
// 135 * 1.4142 = 190.9188.  So use 160 damage for explosion radius of 200.
// Damage first, then effects.
    T_RadiusDamage (self, self, 160, self);
    sound (self, CHAN_BODY, "boss1/out1.wav", 1, ATTN_NORM);
    Tent_Point (TE_LAVASPLASH, self.origin - '0 0 32');

// The big fireball at the center.
    swap = self;
    self = spawn();
    setorigin (self, swap.origin + '0 0 24');

    sound (self, CHAN_AUTO, "nemesant/bigboom.wav", 1, ATTN_NORM);
    Tent_Point (TE_EXPLOSION, self.origin);
    ShockWave (self.origin, RING_FIRE, 7, "progs/s_wave.spr");
    BecomeTheBigFire ();    // Replaced old fireball mdl with big sprite.

    self = swap;

// Spawn dragon parts.
    self.health = -99;      // Some gibs get some velocity.

    org = self.origin;
    makevectors (self.angles);
    vx = v_forward;  vy = v_right;  vz = v_up;

    sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
// Throw dragon parts first.
// They will be thrown from a point relative to the body instead of randomly.
    // Since we do not want to update corpse origin, don't use setorigin.
    self.origin = org - vy*72 - vz*20;
    ThrowGib ("progs/dr2_lw.mdl", self.health);
    self.origin = org + vy*72 - vz*20;
    ThrowGib ("progs/dr2_rw.mdl", self.health);
    if ( self.frame == $deathb6 )
        self.origin = org - vx*72 - vz*20;
    else
        self.origin = org + vx*72 - vz*20;
    ThrowGib ("progs/dr2_tail.mdl", self.health);
    self.origin = org;      // Restore origin.

// Throw random meat chunks.
    loop = 5;
    while (loop > 0)
        {ThrowGib ("progs/gib2.mdl", self.health);  loop = loop - 1;}
    loop = 2;
    while (loop > 0)
        {ThrowGib ("progs/gib3.mdl", self.health);  loop = loop - 1;}

// Throw the head.  Now we can set origin for real.
    if ( self.frame == $deathb6 )
        org = org + (vx * 88);
    else
        org = org - (vx * 88);
    setorigin (self, org);
    ThrowHead ("progs/dr2_head.mdl", self.health);
};

void() wyrm_countdown =
{
    if (self.cnt > 0)
        self.cnt = self.cnt - 1;
    else
        self.think = wyrm_explode;
};

void() wyrm_die1  =[ $death1,  wyrm_die2  ] {};
void() wyrm_die2  =[ $death2,  wyrm_die3  ] {};
void() wyrm_die3  =[ $death3,  wyrm_die4  ] {};
void() wyrm_die4  =[ $death4,  wyrm_die5  ] {};
void() wyrm_die5  =[ $death5,  wyrm_die6  ] {self.solid = SOLID_NOT;};
void() wyrm_die6  =[ $death6,  wyrm_die7  ] {death_puff();};
void() wyrm_die7  =[ $death7,  wyrm_die8  ] {};
void() wyrm_die8  =[ $death8,  wyrm_die9  ] {};
void() wyrm_die9  =[ $death9,  wyrm_die10 ] {};
void() wyrm_die10 =[ $death10, wyrm_die11 ] {};
void() wyrm_die11 =[ $death11, wyrm_die12 ] {death_puff();};
void() wyrm_die12 =[ $death12, wyrm_die13 ] {};
void() wyrm_die13 =[ $death13, wyrm_die14 ] {death_puff(); self.nextthink = time + 0.2;};
void() wyrm_die14 =[ $death13, wyrm_die15 ] {death_puff(); self.nextthink = time + 0.3;};
void() wyrm_die15 =[ $death13, wyrm_die16 ] {death_puff(); self.nextthink = time + 0.2;};
void() wyrm_die16 =[ $death13, wyrm_die16 ] {death_puff(); wyrm_countdown();};

void() wyrm_dieb1  =[ $deathb1,  wyrm_dieb2  ] {};
void() wyrm_dieb2  =[ $deathb2,  wyrm_dieb3  ] {};
void() wyrm_dieb3  =[ $deathb3,  wyrm_dieb4  ] {};
void() wyrm_dieb4  =[ $deathb4,  wyrm_dieb5  ] {};
void() wyrm_dieb5  =[ $deathb5,  wyrm_dieb6  ] {self.solid = SOLID_NOT;};
void() wyrm_dieb6  =[ $deathb6,  wyrm_dieb7  ] {death_puff(); self.nextthink = time + 0.5;};
void() wyrm_dieb7  =[ $deathb6,  wyrm_dieb8  ] {death_puff(); self.nextthink = time + 0.4;};
void() wyrm_dieb8  =[ $deathb6,  wyrm_dieb9  ] {death_puff(); self.nextthink = time + 0.3;};
void() wyrm_dieb9  =[ $deathb6,  wyrm_dieb10 ] {death_puff(); self.nextthink = time + 0.2;};
void() wyrm_dieb10 =[ $deathb6,  wyrm_dieb10 ] {death_puff(); wyrm_countdown();};

// Special death for the dragon king.
void() wyrm_die =
{
// Snap tilt angles back to zero now.
    self.angles_x = self.angles_z = 0;

// No gib check, no decapitation, just a simple death scene.
// Well, it is like Shub's with an initial dying anim then the big kaboom.
    self.cnt = (random() * 10 + 5) & 15;    // Extra explosions before last.
    self.velocity_x = -200 + 400*random();
    self.velocity_y = -200 + 400*random();
    self.velocity_z =  100 + 100*random();
    self.flags = self.flags - (self.flags & FL_ONGROUND);
    // The wyrm is a boss, so use full volume.
    sound (self, CHAN_VOICE, "dragon/death1.wav", 1, ATTN_NONE);
    if (random() < 0.5)
    {   // Shove it up a little for the fallback death anim.
        self.velocity_z = 250 + 100*random();
        wyrm_die1 ();
    }
    else
        wyrm_dieb1 ();
};

//==========================================================================

// Set dragon properties based on elemental type.
// Called once by monster_dragon, and multiple times by Draco.
void(entity ent) Ryu_ElementalStats =
{
    local   float   element, evade;

// Assign stats based on elemental type.
    evade = TRUE;
    element = ent.ryuflags & RYU_ELEMENTS;
    if (element == RYU_USE_ACID)
        evade = FALSE;
    else if (element == RYU_USE_ICE)
        evade = FALSE;

// Set water evasion flag.
    if (evade)
        ent.ryuflags = ent.ryuflags | RYU_NO_WATER;
    else
        ent.ryuflags = ent.ryuflags - (ent.ryuflags & RYU_NO_WATER);

// Set breath attack flags.
    ent.ryuflags = ent.ryuflags - (ent.ryuflags & RYU_ELEMENTS);
    ent.ryuflags = ent.ryuflags | element;
};

// Assigns elemental type based on skin color.  Used by monster_dragon only.
void() Ryu_SetElement =
{
    local   float   rgb;

    rgb = self.skin;
    if (rgb == SKIN_GREEN)        self.ryuflags = RYU_USE_ACID;
    else if (rgb == SKIN_BLUE)    self.ryuflags = RYU_USE_LITE;
    else if (rgb == SKIN_WHITE)   self.ryuflags = RYU_USE_ICE;
    else                          self.ryuflags = RYU_USE_FIRE;
};

void(string s1, vector v1, vector v2, float hp, float gib) monster_form =
{
    self.solid      = SOLID_SLIDEBOX;
    self.movetype   = MOVETYPE_STEP;
    setmodel (self, s1);
    setsize (self, v1, v2);
// PM:  Health is fixed.  Uncomment to allow map-defined health.
//    if ((self.health < 1) || (self.health > 40000))
        self.health = hp;
};

// Sets a wide variety of stats for monster_dragon.
void() dragon_stats =
{
// Set skin and its related stats first.
    Ryu_SetElement ();      // Resets edict.ryuflags.
    Ryu_ElementalStats (self);
//- - - - - - - - -
// Set size-dependant stats (model, hull size, and health).
// NOTES:
// * Health used to be 50 * level * level, where level = self.maxs_x / 16.
// * Last parm is gib_health.  Zero means gibbed only by telefrag.
//- - - - - - - - -
    if (self.spawnflags & SPAWN_WYRM)
    {   // Too big for normal ai.
        self.ryuflags = self.ryuflags | RYU_PATH;
        monster_form ("progs/dragon2.mdl", '-112 -112 -24', '112 112 112', 3000, 0);
        // Will use flymonster's slower, default turning speed.
    }
    else
    {
        monster_form ("progs/dragon1.mdl", '-56 -56 -24', '56 56 56', 750, -90);
        // Set yaw (turning) speed.
        if (!self.yaw_speed)
            self.yaw_speed = 20;    // Same as walkmonster.
    }

//////////////////
// Fast = more alert -- better dodging and aiming.
// Slow = slower speed, poor tracking.
    local   float   powlevel;

    if (self.spawnflags & SPAWNx_SKILL == SPAWNx_SKILL)
        powlevel = cvar("skill");      // Conflict -- let skill decide.
    else if (self.spawnflags & SPAWN_FAST)
        powlevel = 2;
    else if (self.spawnflags & SPAWN_SLOW)
        powlevel = 0;
    else
        powlevel = 1;

// Set speed.
    if (powlevel)
    {
        self.spawnflags = self.spawnflags - (self.spawnflags & SPAWN_SLOW);
        if (powlevel >= 2)
            self.ryuflags = self.ryuflags | RYU_ALERT;
        self.speed = 32;
    }
    else
        self.speed = 20;
//////////////////
};

//==========================================================================

void() dragon_cache =
{
    precache_model ("progs/dr1_head.mdl");  // Gib (head)
    precache_model ("progs/dr1_lw.mdl");    // Gib (left wing)
    precache_model ("progs/dr1_rw.mdl");    // Gib (right wing)
    precache_model ("progs/dr1_tail.mdl");  // Gib (tail)
    precache_model ("progs/dragon1.mdl");   // Qtest dragon (various sizes)

    precache_model ("progs/acidbal1.mdl");  // Bile bomb
//    precache_model ("progs/bolt.mdl");      // Lightning bolt
    precache_model ("progs/flame2.mdl");    // Flames
    precache_model ("progs/ice.mdl");       // Ice Shard
    precache_model ("progs/iceball.mdl");   // Ice Ball
    precache_model ("progs/plasma.mdl");    // Plasma ball
    precache_model ("progs/s_fancy.spr");   // Custom explosion sprites.
    precache_model ("progs/s_wave.spr");    // Sprite shockwave
    precache_model ("progs/s_wave2.spr");   // Ice bolt ripple
    precache_model ("progs/w_spike.mdl");   // Acid shot

    precache_sound ("demon/dhit2.wav");
    precache_sound ("dragon/acid.wav");
    precache_sound ("dragon/death1.wav");
    precache_sound ("dragon/fire.wav");
    precache_sound ("dragon/firehit.wav");
    precache_sound ("dragon/fly.wav");
    precache_sound ("dragon/flywater.wav");
    precache_sound ("dragon/ice.wav");
    precache_sound ("dragon/icehit.wav");
    precache_sound ("dragon/idle1.wav");
    precache_sound ("dragon/pain1.wav");
    precache_sound ("dragon/sight1.wav");
//    precache_sound ("imp/shard.wav");
    precache_sound ("misc/power.wav");      // Discharge & Fizzle
//    precache_sound ("weapons/lhit.wav");    // Lightning
//    precache_sound ("weapons/lstart.wav");  // Lightning start
    precache_sound ("weapons/shatter.wav");
    precache_sound ("wizard/hit.wav");

    precache_sound ("plasma/explode.wav");
//    precache_sound ("plasma/flight.wav");
//    precache_sound ("plasma/fire.wav");
//    precache_sound ("weapons/discharg.wav"); // Plasma explosion
};

// Cache files used only by the dragon boss.
void() wyrm_cache =
{
    precache_model ("progs/dr2_head.mdl");  // Gib (head)
    precache_model ("progs/dr2_lw.mdl");    // Gib (left wing)
    precache_model ("progs/dr2_rw.mdl");    // Gib (right wing)
    precache_model ("progs/dr2_tail.mdl");  // Gib (tail)
    precache_model ("progs/dragon2.mdl");   // Qtest dragon (full-sized)

    // Post-mortem fireworks.
    precache_model ("progs/s_expbig.spr");

    precache_sound ("boss1/out1.wav");
    precache_sound ("hknight/hit.wav");     // used by C code, so don't sound2
    precache_sound ("nemesant/bigboom.wav");
};

//============
// --> QUAKED monster_dragon (1 0 0) (-56 -56 -24) (56 56 56) Ambush Boss Fast Slow
//============
void() monster_dragon =
{
//- - We want to use the Qtest-based dragon. - -
// Back to our regularly scheduled monster spawning...
    local   float   wyrm;

    wyrm = self.spawnflags & SPAWN_WYRM;
//    if (!self.spawned)
    {   // Spawned at start of level, rather than later via summoning.
        if (deathmatch)
            {remove (self); return;}
        dragon_cache ();
        if (wyrm)
            wyrm_cache ();
    }

// Check skin first.
    if (self.skin == 1)        self.skin = SKIN_GREEN;
    else if (self.skin == 2)   self.skin = SKIN_BLUE;
    else if (self.skin == 3)   self.skin = SKIN_WHITE;
    else if (self.skin == 4)   self.skin = SKIN_GOLD;
    else                       self.skin = SKIN_RED;        // The default.

// For the rest of the stats...
    dragon_stats ();
    if (wyrm)
    {   // Gliding AI.
        self.th_stand   =
        self.th_walk    =
        self.th_run     = wyrm_start;
        self.th_die     = wyrm_die;
        // Cannot melee.
    }
    else
    {   // Classic Dragons AI.
        self.th_stand   = dragon_stand;
        self.th_walk    = dragon_walk;
        self.th_run     = dragon_run;
        self.th_melee   = dragon_strike;
        self.th_die     = dragon_die;
    }
    self.th_missile = dragon_missile1;
    self.th_pain    = dragon_pain;
    //- - - - - - - -
//- - - - - - - - -
    self.th_move    = Wyrm_WalkMove;
    self.th_goal    = QC_MoveToGoal;

    flymonster_start ();
};

//============
// --> QUAKED monster_dragon_wyrm (1 0 0) (-112 -112 -24) (112 112 112) Ambush x Fast Slow
//============
void() monster_dragon_wyrm =
{
    self.spawnflags = self.spawnflags | SPAWN_WYRM;
    self.classname = "monster_dragon";
    monster_dragon();
};


//===========================/  END OF FILE  /===========================//
