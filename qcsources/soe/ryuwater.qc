//==========================================================================
//  ryuwater.qc -- by Patrick Martin            Last updated:  5-5-2001
//--------------------------------------------------------------------------
//  This file contains code that deals with situations that involve water.
//==========================================================================


//==========================================================================
//  Water Fear and Avoidance

//----------------------------------------------------/ New Code /--------//
//  This negates the dragon's fear of water.  Used by dragon familiars
//  when in 'follow' mode.
//------------------------------------------------------------------------//
void() PM_NegateWaterFear =
{
    self.aflag = FALSE;
};

//----------------------------------------------------/ New Code /--------//
//  This sets the dragon's (lack of) fear of water.
//------------------------------------------------------------------------//
void(float type) PM_SetWaterFear =
{
    if (self.state == IQ_LOW)
    {
        PM_NegateWaterFear ();   // Too dumb to avoid water.
        return;
    }

    // Red and blue dragons avoid water.  The rest will swim if needed.
    if (type == SKIN_RED)
        self.aflag = TRUE;
    else if (type == SKIN_BLUE)
        self.aflag = TRUE;
    else
        self.aflag = FALSE;
};

//----------------------------------------------------/ New Code /--------//
//  This checks if the dragon should stay away from water.  Dragons that
//  only have breath weapons that are ineffective or too dangerous to use
//  underwater are usually afraid of water.  However, a dragon that is on
//  fire will venture into water, even if it normally avoids water.
//------------------------------------------------------------------------//
float() PM_Hydrophobic =
{
    // Any dragon on fire won't mind taking a dip to put out the fire.
    if (PM_IsBurning (self))
        return FALSE;

    // Return fear status.
    return self.aflag;
};

//----------------------------------------------------/ New Code /--------//
//  This checks if air is nearby from an underwater location.
//------------------------------------------------------------------------//
float(float dist) PM_FindAir =
{
    local   vector  dir;

    dir = self.origin;
    dir_z = dir_z + dist;
    traceline (self.origin, dir, FALSE, self);
    if (trace_inopen)
        if (trace_inwater)
            return TRUE;
    return FALSE;
};

//----------------------------------------------------/ New Code /--------//
//  This tells the dragon to escape a pool of water.
//------------------------------------------------------------------------//
float(float dist) PM_LeaveWater =
{
    // Check if air is above the water (like above a pool or river).
    if (PM_FindAir (1024))
        if (ryu_up (dist))
            return TRUE;

    // Check if air is below the water (only in levels with unusual design).
    if (PM_FindAir (-1024))
        if (ryu_down (dist))
            return TRUE;

    // No air is detected, continue on present course.
    return FALSE;
};

//----------------------------------------------------/ New Code /--------//
//  This checks if the dragon is near the surface of a body of liquid.
//------------------------------------------------------------------------//
float(float dist) PM_NearLiquid =
{
    local   vector  dir;    // Checkpoint above or below dragon.
    local   vector  org;    // Dragon origin;

    // If dragon is already in liquid for one reason or another, do nothing.
    if (PM_EntInWater(self))
        return FALSE;

    dist = dist * 0.5;      // Slow movement so dragon does not bounce.
    org = self.origin;

    // Avoid liquid below the dragon.
    dir = org;
    dir_z = dir_z - dist + self.mins_z - 16;
    traceline (org, dir, TRUE, self);
    if (trace_inopen)
        if (trace_inwater)
        {
            ai_face ();
            return ryu_up(dist);
        }

    // Avoid liquid above the dragon (highly unlikely).
    dir = org;
    dir_z = dir_z + dist + self.maxs_z + 16;
    traceline(org, dir, TRUE, self);
    if (trace_inopen)
        if (trace_inwater)
        {
            ai_face();
            return ryu_down(dist);
        }

    // No water is near the dragon.
    return FALSE;
};


//==========================================================================
//  Water Memory and Goal Creation

//----------------------------------------------------/ New Code /--------//
//  This checks if the dragon knows where to find water.
//------------------------------------------------------------------------//
float() PM_WaterUnknown =
{
    return (self.waterspot == VEC_ORIGIN);
};

//----------------------------------------------------/ New Code /--------//
//  If the dragon is looking for water (because it is burning), and
//  water is directly above or below the dragon, then dive into it.
//------------------------------------------------------------------------//
void(float dist) PM_WaterDive =
{
    local   vector  dir;    // Point directly above or below the dragon.
    local   vector  org;    // Dragon origin;

    // If dragon does not know where to find water, do nothing.
    if (PM_WaterUnknown ())
        return;

    // If dragon is already in liquid for one reason or another, do nothing.
    if (PM_EntInWater (self))
        return;

    // Find liquid above or below the dragon depending where watergoal is.
    org = self.origin;
    dir = org;

    if (self.waterspot_z > self.origin_z)
    {
        dir_z = dir_z + self.mins_z + 2048;
        traceline(org, dir, TRUE, self);
        if (trace_inopen)
            if (trace_inwater)
                ryu_up (dist);
    }
    else
    {
        dir_z = dir_z + self.mins_z - 2048;
        traceline(org, dir, TRUE, self);
        if (trace_inopen)
            if (trace_inwater)
                ryu_down(dist);
    }
};

//----------------------------------------------------/ New Code /--------//
//  Place the watergoal back to the location in the dragon's memory.
//------------------------------------------------------------------------//
void() PM_RestoreWaterPath =
{
    setorigin (self.owner.watergoal, self.owner.waterspot);
};

//----------------------------------------------------/ New Code /--------//
//  This temporarily moves the watergoal so that the dragon will
//  fly elsewhere rather than get stuck.
//------------------------------------------------------------------------//
void() PM_WaterDetour =
{
    local   vector  spot;   // Temp watergoal location.

    // If dragon has no watergoal, do nothing.
    if (!self.watergoal)
        return;

    // Create a spot somewhere behind the dragon and fly to it...
    makevectors(self.angles);
    spot = self.waterspot - (v_forward * random() * 1024) +
        (v_right * ((random() * 2048) - 1024)) +
        (v_up * ((random() * 2048) - 1024));
    setorigin (self.watergoal, spot);

    // ...for about two seconds.
    self.watergoal.nextthink = time + 2;
    self.watergoal.think = PM_RestoreWaterPath;
};

//----------------------------------------------------/ New Code /--------//
//  This checks if obstacles are in the way of the dragon's path to
//  water.  If so, change it temporarily so that the dragon might be
//  able to overcome it.
//------------------------------------------------------------------------//
float(float dist) PM_CheckWaterPath =
{
    local   vector  dir;    // Checkpoint in front of dragon.
    local   vector  org;    // Dragon origin;

    makevectors(self.angles);
    org = self.origin;

    if (self.goalentity.origin_z < self.origin_z)
        org_z = org_z + self.mins_z;
    else
        org_z = org_z + self.maxs_z;

    dir = org + v_forward * 160;
    traceline(org, dir, FALSE, self);
    if (trace_fraction < 1)
        if (trace_ent != self.goalentity)
            if (!PM_WaterUnknown ())
                if (self.goalentity.origin == self.waterspot)
                    PM_WaterDetour();
};

//----------------------------------------------------/ New Code /--------//
//  If the spot is in water and the dragon thinks it can reach
//  it, put the spot in the dragon's memory and return TRUE.
//------------------------------------------------------------------------//
float(vector spot) PM_SightWater =
{
    // No valid spot was given.
    if (!spot)
        return FALSE;

    // Spot was not in water.
    if (pointcontents(spot) != CONTENT_WATER)
        if (pointcontents(spot) != CONTENT_SLIME)
            return FALSE;

    // If spot is blocked, then forget about it.
    traceline(self.origin, spot, TRUE, self);
    if (trace_fraction < 1)
        return FALSE;

    // Spot is valid, put it into the dragon's memory.
    self.waterspot = spot;
    return TRUE;
};

//----------------------------------------------------/ New Code /--------//
//  This returns TRUE if water is found; FALSE if not.
//------------------------------------------------------------------------//
float() PM_LocateWater =
{
    local   vector  dir;    // Point directly above or below the dragon.
    local   vector  org;    // Dragon origin;

    org = self.origin;

    // Find liquid below the dragon.
    dir = org;
    dir_z = dir_z + self.mins_z - 2048;
    traceline(org, dir, TRUE, self);
    if (PM_SightWater(trace_endpos))
        return TRUE;

    // Find liquid above the dragon.
    dir = org;
    dir_z = dir_z + self.maxs_z + 2048;
    traceline(org, dir, TRUE, self);
    if (PM_SightWater(trace_endpos))
        return TRUE;

    // Pick a random spot near and below the dragon.
    dir_x = org_x + random() * 2048 - 1024;
    dir_y = org_y + random() * 2048 - 1024;
    dir_z = org_z - random() * 1024;
    return PM_SightWater(dir);
};

//----------------------------------------------------/ New Code /--------//
//  This lets the dragon remember the location where it encounters
//  water.
//------------------------------------------------------------------------//
void() PM_WaterMemory =
{
    // If currently in water, remember current location.
    if (PM_EntInWater (self))
    {
        self.waterspot = self.origin;
        return;
    }

    // If the dragon knows where to find water, don't look for water.
    // The following line of code is here for performance reasons.
    // However, if you want the dragon to remember the location of
    // water it finds most recently, remove or comment out the next line.
    if (!PM_WaterUnknown ())
        return;

    // Check for water below or above the dragon.
    if (PM_LocateWater ())
        return;

    // If enemy was in water, assume the dragon knows where the enemy found
    // some.  If the dragon's master is a player, also check if the master
    // found some water.  Make this check only if the dragon does not know
    // where to find water.
    if (PM_WaterUnknown ())
    {
        if (self.enemy)
            if (PM_EntInWater (self.enemy))
            {
                self.waterspot = self.enemy.origin;
                return;
            }

        if (self.master.classname == "player")
            if (PM_EntInWater (self.master))
                self.waterspot = self.master.origin;
    }
};

//----------------------------------------------------/ New Code /--------//
//  This creates the goal where the dragon will fly to put out the fire.
//------------------------------------------------------------------------//
void(vector spot) PM_NewWaterGoal =
{
    self.watergoal = spawn();
    setmodel (self.watergoal, "");
    setsize (self.watergoal, '0 0 0', '0 0 0');
    setorigin (self.watergoal, spot);
    self.watergoal.solid      = SOLID_NOT;
    self.watergoal.movetype   = MOVETYPE_NONE;
    self.watergoal.takedamage = DAMAGE_NO;
    self.watergoal.touch      = SUB_Null;
    self.watergoal.classname  = "watergoal";
    self.watergoal.owner      = self;
    self.watergoal.health     = 50000;

    self.oldenemy   = self.enemy;
    self.enemy      = self.watergoal;
    self.goalentity = self.watergoal;
};

//----------------------------------------------------/ New Code /--------//
//  The dragon sets a new path to a body of water.
//------------------------------------------------------------------------//
void() PM_SeekWater =
{
    if (self.watergoal)
        return;    // On its way to some water.

    // If dragon knows where to find water, then head straight for it.
    if (!PM_WaterUnknown ())
        PM_NewWaterGoal (self.waterspot);
};

//----------------------------------------------------/ New Code /--------//
//  This clears the memory when a dragon is spawned.
//------------------------------------------------------------------------//
void(entity ent) PM_ClearWaterMemory =
{
    ent.waterspot = VEC_ORIGIN;
};

//----------------------------------------------------/ New Code /--------//
//  This removes the dragon's water goal entity if it exists.
//------------------------------------------------------------------------//
void(entity ent) PM_RemoveWaterGoal =
{
    if (ent.watergoal)
    {
        remove (ent.watergoal);
        ent.watergoal   = world;
        ent.enemy       = ent.oldenemy;
        ent.oldenemy    = world;
        ent.goalentity  = ent.enemy;

        // Make the dragon forget the watergoal.  Reason:  If dragon failed
        // to reach water before the fire burns out, water is assumed to be
        // unreachable.  If water was found, it will find it immediately
        // after forgetting -- in effect, it 'remembers'.

        PM_ClearWaterMemory (ent);
    }
};

//----------------------------------------------------/ New Code /--------//
//  This updates the dragon's memory of the location of water and
//  checks if the dragon is burning or not.  If the dragon catches
//  on fire, it creates a new goal centered at the location of water
//  currently in the dragon's memory.  If the fire is extinguished
//  or the dragon dies, the goal is removed.
//------------------------------------------------------------------------//
void(float dist) PM_DragonWaterStatus =
{
    // Check if the dragon is smart enough to look for water.
    if (self.state < IQ_HIGH)
        return;

    // Check for water.  If found, remember the location.
    PM_WaterMemory();

    // If dragon is burning, forget about the target and find some water.
    if (PM_IsBurning (self))
        if (self.health > 0)
        {
            PM_SeekWater();         // Set a path to some water.
            PM_WaterDive(dist);     // Dive into water if found.
            return;
        }

    // Dragon is not burning, remove watergoal if it exists.
    PM_RemoveWaterGoal (self);
};


//===========================/  END OF FILE  /===========================//
