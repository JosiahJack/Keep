//==========================================================================
//  Checks

float(entity e) IsDead = {return ((e.health <= 0) || e.deadflag);};

float(entity e) IsGhost =
    {return ((e.solid==SOLID_TRIGGER) && (e.movetype==MOVETYPE_NOCLIP));};

float(entity e) IsSlowed =
    {return ((e.curse_type == CURSE_SLOW) || e.slow_finished);};

float(entity e) IsMissile =
{
    if (!(e.flags & FLx_NOT_MISSILE))
    {
        if (e.solid == SOLID_BBOX)
        {
            // In Drake, if the entity does not have a modelindex,
            // assume it is a spawner of some sort, such as a firewall.
            if (e.modelindex)
            {
                if (e.touch)
                    if (e.touch != SUB_Null)
                        if (e.touch != SUB_Remove)
                            return TRUE;
            }
        }
// DISABLED -- Lavaballs are solid_bbox in Drake.
//        else if (e.solid == SOLID_TRIGGER)
//        {
//            if (e.classname == "fireball")  // Lavaball check.
//                return TRUE;
//        }
    }
    return FALSE;
};

// Returns TRUE if 'e' is invisible and intangible.
// Used by entities who can phase out of the level.
float(entity e) IsOut =
{
    if (e)
        return (!e.modelindex && (e.solid == SOLID_NOT));
    return TRUE;    // The world.
};

// Here because qcc can't compile 'if (s && (s != ""))'.
float(string s) IsEmptyString =
{
    if (s)
        if (s != "")
            return FALSE;
    return TRUE;
};

float(entity e) ImmuneToDamage =
{
    if (!e.takedamage)
        return TRUE;
    if (e.flags & FL_GODMODE)
        return TRUE;
    return (e.invincible_finished);
};

// Checks if entity 'e' can grunt in pain.
float(entity e) FeelsPain =
{
    if (e.health > 0)
        if (e.th_pain)
            if (e.th_pain != SUB_Null)
                if (e.pain_finished <= time)
                    if (!ImmuneToDamage (e))
                        return TRUE;

    return FALSE;
};

// Checks if the given two entities' bboxes overlap.
// Similar to 'EntitiesTouching', but uses absmin/absmax.
float(entity e1, entity e2) Overlap =
{
    if (e1.absmin_x > e2.absmax_x)  return FALSE;
    if (e1.absmax_x < e2.absmin_x)  return FALSE;
    if (e1.absmin_y > e2.absmax_y)  return FALSE;
    if (e1.absmax_y < e2.absmin_y)  return FALSE;
    if (e1.absmin_z > e2.absmax_z)  return FALSE;
    if (e1.absmax_z < e2.absmin_z)  return FALSE;
    return TRUE;
};

// Like 'Overlap' above, but adds distance.
// Useful to check collisions when one entity has a clip bonus.
float(entity e1, entity e2, float dist) Overlapped =
{
    if (e1.absmin_x > e2.absmax_x + dist)  return FALSE;
    if (e1.absmax_x < e2.absmin_x - dist)  return FALSE;
    if (e1.absmin_y > e2.absmax_y + dist)  return FALSE;
    if (e1.absmax_y < e2.absmin_y - dist)  return FALSE;
    if (e1.absmin_z > e2.absmax_z + dist)  return FALSE;
    if (e1.absmax_z < e2.absmin_z - dist)  return FALSE;
    return TRUE;
};

float(vector amin, vector amax, vector bmin, vector bmax) Point_Overlap =
{
    if (amin_x > bmax_x)  return FALSE;
    if (amax_x < bmin_x)  return FALSE;
    if (amin_y > bmax_y)  return FALSE;
    if (amax_y < bmin_y)  return FALSE;
    if (amin_z > bmax_z)  return FALSE;
    if (amax_z < bmin_z)  return FALSE;
    return TRUE;
};


//==========================================================================
//  Ghostbusters

// PM:  Here because several functions used are defined above in this file.

//- - - - - - - - -
// Called by a missile 'self' to touch a ghost if both entities overlap.
// Check if the missile 'self' is overlapping a ghost.
//
// NOTE:  Place at the end of any (ghost bane) missile's think function
// because missile is not always removed on touch, especially with reflection.
//- - - - - - - - -
void() Ghost_Touch =
{
    local   entity  head;
    local   float   dist;       // For missile clip bonus.

    if (!ghosttouch)
        return;     // No ghosts on the level to justify code hog.

    if (self.movetype == MOVETYPE_FLYMISSILE)
        dist = 15;
    else
        dist = 0;
    head = findradius(self.origin, 120);
    while (head)
    {
        if (head.modelindex)    // Hit only if visible
            if (IsGhost (head))
                if (self.owner != head)     // Missiles pass through owner.
                    if (Overlapped (head, self, dist))
                    {
                        if (self.touch)
                            if (self.touch != SUB_Null)
                            {
                                local   entity  oo;

                                oo = other;
                                other = head;
                                self.touch ();
                                other = oo;
//                                return;     // TRUE.
                            }
                        return;     // FALSE.  Missile was a dud!
                    }
        head = head.chain;
    }
//    return FALSE;
};

// Makes ghosts solid so lightning bolts can hit them.
void() GhostTouch_On =
{
    local   entity  ent, after;

    if (!ghosttouch)
        return;     // No ghosts on the level to justify code hog.

// PM:  Do NOT use linked lists to speed things up because of the possibility
// of targets getting hit more than once, and if that happens, the list will
// become a linked circle which, in other words, means an infinite loop.
// Looping through the edict list twice, once to turn on ghost touch and
// again to turn it off, is slower than desired, but safer.
    ent = nextent (world);
    while (ent)
    {
        // Setorigin may change links, so get the next guy now.
        after = nextent (ent);
        // Update 6/20/2011:  Optimize code to avert Mjolnir thunderstorm
        // crash bug in FitzQuake/Quakespasm.  Make sure conditions match
        // those in 'IsGhost'
        if (ent.solid==SOLID_TRIGGER)
        if (ent.movetype==MOVETYPE_NOCLIP)
        {
            ent.solid = SOLID_SLIDEBOX;   // This alone won't change now until setorigin is called.
            setorigin (ent, ent.origin);  // we tell engine to update entity.
            ent.xfl = ent.xfl | XFL_FLUX;
        }
        ent = after;
    }
};

// Makes solid ghosts non-solid again.
// *Must call this before exiting the function.*
void() GhostTouch_Off =
{
    local   entity  ent, after;

    if (!ghosttouch)
        return;     // No ghosts on the level to justify code hog.

    ent = nextent (world);
    while (ent)
    {
        // Setorigin may change links, so get the next guy now.
        after = nextent (ent);
        if (ent.xfl & XFL_FLUX)
        {
            ent.xfl = ent.xfl - XFL_FLUX;
            // It is possible for solid to change if killed, so check first.
            if (ent.solid == SOLID_SLIDEBOX)
            {
                ent.solid = SOLID_TRIGGER;
                setorigin (ent, ent.origin);
            }
        }
        ent = after;
    }
};


//==========================================================================
//  Other

//- - - - - - - - -
// Touch function.
//
// Give 'other' ground physics if standing on top of something.
//
// Originally used by chests only.  Now it is used by some monsters,
// those that can be stepped and walked on.  Such monsters include
// spiders and Shub-Niggurath.
//- - - - - - - - -
void() CheckOnTop =
{
    if (!(other.flags & FL_ONGROUND))
    {   // See if player is standing on the chest.
        local   vector  down, org, spot;

        down = '0 0 -4';
        org = other.origin;
        org_z = org_z + other.mins_z + 1;

    // Check four away from bbox edge.
        spot_x = org_x + other.mins_x + 4;
        spot_y = org_y + other.mins_y + 4;
        spot_z = org_z;
        traceline (spot, spot + down, FALSE, other);
        if (trace_ent == self)
            {other.flags = other.flags | FL_ONGROUND; return;}
        spot_x = org_x + other.maxs_x - 4;
        traceline (spot, spot + down, FALSE, other);
        if (trace_ent == self)
            {other.flags = other.flags | FL_ONGROUND; return;}
        spot_y = org_y + other.maxs_y - 4;
        traceline (spot, spot + down, FALSE, other);
        if (trace_ent == self)
            {other.flags = other.flags | FL_ONGROUND; return;}
        spot_x = org_x + other.mins_x + 4;
        traceline (spot, spot + down, FALSE, other);
        if (trace_ent == self)
            {other.flags = other.flags | FL_ONGROUND; return;}
    }
};


//===========================/  END OF FILE  /===========================//
