//==========================================================================
//  goal.qc
//--------------------------------------------------------------------------
//  Made for monsters who do not work well with the builtin movement
//  functions 'walkmove' and 'movetogoal'.  Such monsters include the
//  following:
//
//  * Wraiths and other ghostly monsters.
//  The builtin functions were made for monsters with MOVETYPE_STEP.
//  Anything with MOVETYPE_NOCLIP uses velocity for movement,
//  similar to missiles and the like.
//
//  * Anything with a bbox size bigger than '-32 -32 -24', '32 32 64'.
//  The builtin functions use standard bbox sizes (as defined in defs.qc)
//  for detecting bsps, and anything that is too big will simply ignore
//  its extra size and clip whatever when it moves north and/or east.
//  Such a monster needs its own movement code to prevent clipping.
//
//  * Anything with FL_SWIM.
//  If a swimming monster's origin tries to move up into empty space,
//  Quake aborts the entire move.  This means the monster is paralyzed,
//  unable to glide along the surface of the water.
//==========================================================================


//==========================================================================
//  Flat Movement -- Used by any flying or swimming monster.

// This is 'walkmove' without the vertical movement.
float(float yaw, float dist) flat_move =
{
    local   entity  swap;

    swap = self.enemy;
    self.enemy = world;     // This prevents 'self' from going up/down.
    dist = walkmove (yaw, dist);    // After this, dist = TRUE or FALSE.
    self.enemy = swap;
    return dist;
};

// This is 'movetogoal' without the vertical movement.
void(float dist) flat_goal =
{
    local   entity  swap;

    swap = self.enemy;
    self.enemy = world;     // This prevents 'self' from going up/down.
    movetogoal (dist);
    self.enemy = swap;
};


//==========================================================================
//  QuakeC MoveToGoal -- Made for big dragons who break builtin movement.

// Prototype -- function at bottom of this file.
float(float yaw, float dist) safe_move;

// Based on 'SV_StepDirection'.
// Use this only for big multi-hulled monsters such as dragons.
float(float yaw, float dist) QC_StepDir =
{
    self.ideal_yaw = yaw;
    ChangeYaw ();

//- - - - - - - - -
// First, move self.  If successful, see if self is facing ideal.
// If not, snap self back.
//    if (self.solid == SOLID_NOT)
    {   // Solid not entities cannot touch things.
        // The move_box entity should be solid_not.
        local   vector  spot;
    
        spot = self.origin;
        if (safe_move (yaw, dist))
        {
            if (!FacingIdeal ())
                setorigin (self, spot);   // Didn't turn enough so don't move.
            return TRUE;
        }
    }
// FIXME:  Code below breaks dragons' move code if used.  Don't know how yet.
//    else
//    {   // Can't risk touching triggers that may hurt or teleport self,
//        // so get a dummy to test movement.
//        local   entity  swap;
//        local   float   moved, faced;
//
//        UpdateMovebox ();
//        swap = self;
//        self = move_box;
//        moved = safe_move (yaw, dist);      // This moves the dummy.
//        faced = FacingIdeal ();
//        self = swap;
//        if (moved)
//        {   // Dummy made a move.
//            if (faced)
//                safe_move (yaw, dist);      // Move where the dummy moved.
//            return TRUE;
//        }
//    }
//- - - - - - - - -

    return FALSE;
};

// Based on 'SV_NewChaseDir'.
void(float dist) QC_NewChaseDir =
{
    local   vector  delta;
    local   float   d1, d2;
    local   float   old, back, turn;

    old = floor (self.ideal_yaw / 45);  // IIRC, int chops off decimals.
    old = anglemod (old * 45);
    back = anglemod (old - 180);

    delta = self.goalentity.origin - self.origin;
    if (delta_x > 10)
        d1 = 0;
    else if (delta_x < -10)
        d1 = 180;
    else
        d1 = -1;
    if (delta_y < -10)
        d2 = 270;
    else if (delta_y > 10)
        d2 = 90;
    else
        d2 = -1;

// Try direct route.
    if (d1 != -1)
        if (d2 != -1)
    {
        if (d1 == 0)
            {if (d2 == 90) turn = 45; else turn = 315;}
        else
            {if (d2 == 90) turn = 135; else turn = 215;}

        if (turn != back)
            if (QC_StepDir (turn, dist))
                return;
    }

// Try other directions.
    local   float   ax, ay;

    ax = fabs(delta_x);
    ay = fabs(delta_y);
    if ((random() < 0.333) || (ay > ax))
        {turn = d1; d1 = d2; d2 = turn;}

    if (d1 != -1)
        if (d1 != back)
            if (QC_StepDir (d1, dist))
                return;
    if (d2 != -1)
        if (d2 != back)
            if (QC_StepDir (d2, dist))
                return;

// No direct path to goal, so pick another way.
    if (old != -1)
        if (QC_StepDir (old, dist))
            return;

    local   float   end, next;
    if (random() < 0.5)
        {turn = 0; end = 315; next = 45;}
    else
        {turn = 315; end = 0; next = -45;}

    while (turn <= end)
    {
        if (turn != back)
            if (QC_StepDir (turn, dist))
                return;
        turn = turn + next;
    }

    if (back != -1)
        if (QC_StepDir (back, dist))
            return;

// Can't move.
    self.ideal_yaw = old;

// Disabled bridge pull out code because only flying dragons use this code.
// Pull out code.
//    flat_move (0, 0);   // This will do the 'SV_FixCheckBottom' code.
};

// Based on 'SV_CloseEnough'.
float(float dist) QC_CloseEnough =
{
    if (self.goalentity.absmin_x > self.absmax_x + dist)  return FALSE;
    if (self.goalentity.absmax_x < self.absmin_x - dist)  return FALSE;
    if (self.goalentity.absmin_y > self.absmax_y + dist)  return FALSE;
    if (self.goalentity.absmax_y < self.absmin_y - dist)  return FALSE;
    if (self.goalentity.absmin_z > self.absmax_z + dist)  return FALSE;
    if (self.goalentity.absmax_z < self.absmin_z - dist)  return FALSE;
    return TRUE;
};

// This tries to emulate movetogoal for multiple bboxes acting as a unit.
// This is probably a very slow function compared to other functions.
// (However, it is not noticable at all with a modern computer.)
void(float dist) QC_MoveToGoal =
{
// Commented out because only dragons use this, and they fly.
//    if (!(self.flags & FLx_NOT_FALLING))    //(FL_ONGROUND|FL_FLY|FL_SWIM)
//        return;

// If next step hits enemy, stop.
    if (self.enemy)
        if (QC_CloseEnough (dist))
            return;

// Bump around...
    if (random() < 0.333)
        QC_NewChaseDir (dist);
    else if (!QC_StepDir (self.ideal_yaw, dist))
        QC_NewChaseDir (dist);
};


//==========================================================================
//  Noclip Movement -- Used by wraiths and other such ghostly monsters.

//============
// This is 'walkmove' for monsters with noclip movement.  Based on
// 'SV_movestep'.  Noclip entities are capable of unrestricted 3D movement.
//
// NOTE:  This function *always* returns TRUE.
// This function is float type for convenience (i.e., cut-and-paste code).
//============
float(float yaw, float dist) noclip_move =
{
    local   vector  move;

    move = '0 0 0'; move_y = yaw;
    makevectors (move);
    move = v_forward * dist * 10;
    if (self.enemy)
    {
        local   float   delta;

        delta = self.origin_z - self.enemy.origin_z;
        if (delta < 30)
            move_z = move_z + 80;
        else if (delta > 40)
            move_z = move_z - 80;
    }
    self.velocity = move;
    return TRUE;
};

// Based on 'SV_StepDirection'.
// Originally float type, but noclip movement cannot be blocked.
void(float yaw, float dist) noclip_step =
{
    self.ideal_yaw = yaw;
    ChangeYaw ();

    if (FacingIdeal ())
        noclip_move (yaw, dist);
    else
        self.velocity = '0 0 0';    // Didn't turn enough so don't move.
};

// Based on 'SV_NewChaseDir'.
void(float dist) noclip_chase =
{
    local   vector  delta;
    local   float   d1, d2;
    local   float   old, back, turn;

    old = floor (self.ideal_yaw / 45);  // IIRC, int chops off decimals.
    old = anglemod (old * 45);
    back = anglemod (old - 180);

    delta = self.goalentity.origin - self.origin;
    if (delta_x > 10)
        d1 = 0;
    else if (delta_x < -10)
        d1 = 180;
    else
        d1 = -1;
    if (delta_y < -10)
        d2 = 270;
    else if (delta_y > 10)
        d2 = 90;
    else
        d2 = -1;

// Try direct route.
    if (d1 != -1)
        if (d2 != -1)
    {
        if (d1 == 0)
            {if (d2 == 90) turn = 45; else turn = 315;}
        else
            {if (d2 == 90) turn = 135; else turn = 215;}

        if (turn != back)
            {noclip_step (turn, dist); return;}
    }

// Try other directions.
    local   float   ax, ay;

    ax = fabs(delta_x);
    ay = fabs(delta_y);
    if ((random() < 0.333) || (ay > ax))
        {turn = d1; d1 = d2; d2 = turn;}

    if (d1 != -1)
        if (d1 != back)
            {noclip_step (d1, dist); return;}
    if (d2 != -1)
        if (d2 != back)
            {noclip_step (d2, dist); return;}

// No direct path to goal, so pick another way.
    noclip_step (old, dist);
};

//============
// This is 'movetogoal' for monsters with noclip movement.
// Based on 'SV_MoveToGoal'.
//============
void(float dist) noclip_goal =
{
// Noclip entities have full, unrestricted 3D movement.

// If next step hits enemy, stop... but only if wraith is not in a wall.
// Why?  Because the wraith can't attack effectively if pinned in the wall.
    if (self.enemy)
        if (QC_CloseEnough (dist))
            if (pointcontents (self.origin) != CONTENT_SOLID)
                {self.velocity = '0 0 0'; return;}

    if (random() < 0.333)
        noclip_chase (dist);
    else
        noclip_step (self.ideal_yaw, dist);
};


//==========================================================================
//  Swimming -- Used by rotfish.

float(float yaw, float dist) swim_move =
{
    if (self.origin_z < self.enemy.origin_z + 30)
    {   // Will try to go up.
        if (pointcontents (self.origin + '0 0 8') == CONTENT_EMPTY)
            return flat_move (yaw, dist);
    }
//    else if (self.origin_z > self.enemy.origin_z - 40)
//    {   // Will try to go down.
//        if (pointcontents (self.origin - '0 0 32') == CONTENT_EMPTY)
//            return flat_move (yaw, dist);
//    }
    return walkmove (yaw, dist);
};

void(float dist) swim_goal =
{
    if (self.origin_z < self.enemy.origin_z + 30)
    {
        if (pointcontents (self.origin + '0 0 8') == CONTENT_EMPTY)
            {flat_goal (dist); return;}
    }
//    else if (self.origin_z > self.enemy.origin_z - 40)
//    {
//        if (pointcontents (self.origin - '0 0 32') == CONTENT_EMPTY)
//            {flat_goal (dist); return;}
//    }
    movetogoal (dist);
};


//==========================================================================
//  Safe Movement Functions

// The following two "safe_" functions help improve stability at the
// cost of speed.  Monsters should have th_move and th_goal defined,
// but in case they do not, do something to prevent a crash by call to
// undefined function.
float(float yaw, float dist) safe_move =
{
    if (self.th_move)
        return self.th_move (yaw, dist);
// If the first check failed, that means self.th_move was undefined,
// and the game would have crashed due to a call to an undefined function.
    if (self.movetype == MOVETYPE_NOCLIP)
        return noclip_move (yaw, dist);
// Disabled:  Monster should call swim_* via self.th_*.
//    if (self.flags & FL_SWIM)
//        return swim_move (yaw, dist);
    return walkmove (yaw, dist);
};

void(float dist) safe_goal =
{
    if (self.th_goal)
        self.th_goal (dist);
// If the first check failed, that means self.th_goal was undefined,
// and the game would have crashed due to a call to an undefined function.
    else
    {
        if (self.movetype == MOVETYPE_NOCLIP)
            noclip_goal (dist);
//        else if (self.flags & FL_SWIM)
//            swim_goal (dist);
        else
            movetogoal (dist);  // The original builtin.
    }
};


//===========================/  END OF FILE  /===========================//
