//==========================================================================
//  petmove.qc -- by Patrick Martin             Last updated:  5-5-2001
//--------------------------------------------------------------------------
//  This file contains code that does collision checking as well as
//  teleporting pet dragons for whatever reason.
//==========================================================================


//==========================================================================
//  Vertical Adjustment

//----------------------------------------------------/ New Code /--------//
//  This causes the pet dragon to fly up or down to a set elevation
//  relative to its master.  The shift of elevation is returned.
//------------------------------------------------------------------------//
float(float offset, float zgoal) PM_SeekLevel =
{
    offset = offset + zgoal;    // Combine both arguments here.

    local   float   zspeed;

    zspeed = DRAGON_MINSPEED;
    if (offset > self.origin_z)
    {
        zspeed = offset - self.origin_z;
        if (zspeed > DRAGON_MINSPEED)
            zspeed = DRAGON_MINSPEED;
        ryu_up (zspeed);
        return zspeed;
    }
    if (offset < self.origin_z)
    {
        zspeed = self.origin_z - offset;
        if (zspeed > DRAGON_MINSPEED)
            zspeed = DRAGON_MINSPEED;
        ryu_down (zspeed);
        zspeed = 0 - zspeed;    // Don't return negative values.
        return zspeed;
    }
    return 0;
};

//----------------------------------------------------/ New Code /--------//
//  This changes the ideal height difference between the pet dragon and
//  its goal so that the dragon can fly over or under some obstacles.
//  If there is change, TRUE is returned.
//------------------------------------------------------------------------//
float() PM_ChangeOfs =
{
    local   vector  p1, p2;
    local   float   up, down;

    up = down = FALSE;

    makevectors(self.angles);
    p1   = self.origin;
    p1_z = p1_z + self.mins_z;
    p2   = p1 + v_forward * 150;
    traceline(p1, p2, FALSE, self);
    if (trace_fraction < 1)
        if (trace_ent != self.master)
            up = TRUE;

    p1   = self.origin;
    p1_z = p1_z + 32;  //self.maxs_z;
    p2   = p1 + v_forward * 150;
    traceline(p1, p2, FALSE, self);
    if (trace_fraction < 1)
        if (trace_ent != self.master)
            down = TRUE;

    if (up)
    {
        if (down)
            return FALSE;   // Must be up or down, but not both!

        // Dragon wants to go up.
        self.petofs = self.petofs + 24;
        return TRUE;
    }
    if (down)
    {
        // Dragon wants to go down.
        self.petofs = self.petofs - 24;
        return TRUE;
    }
    return FALSE;
};

//----------------------------------------------------/ New Code /--------//
//  This checks if an obstacle fully blocks the path from pet to master.
//------------------------------------------------------------------------//
float(entity pet) PM_PetOutOfSight =
{
    local   vector  p1, p2;

    // Check path between origins.
    p1 = pet.origin;
    p2 = pet.master.origin;
    traceline (p1, p2, TRUE, pet);
    if (trace_fraction == 1)
        return FALSE;

    // Check path between tops.
    p1 = pet.origin;
    p2 = pet.master.origin;
    p1_z = p1_z + pet.maxs_z;
    p2_z = p2_z + pet.master.maxs_z;
    traceline (p1, p2, TRUE, pet);
    if (trace_fraction == 1)
        return FALSE;

    // Check path between bottoms.
    p1 = pet.origin;
    p2 = pet.master.origin;
    p1_z = p1_z + pet.mins_z;
    p2_z = p2_z + pet.master.mins_z;
    traceline (p1, p2, TRUE, pet);
    if (trace_fraction == 1)
        return FALSE;

    // Path is (likely) blocked.
    return TRUE;
};


//==========================================================================
//  Pet Teleport

//----------------------------------------------------/ New Code /--------//
//  This checks if the dragon has disappeared and is hiding.
//------------------------------------------------------------------------//
float(entity pet) PM_PetHiding =
{
    if (!pet.solid)
        return TRUE;

    if (pet == pet.master.draco)
        if (!(pet.master.petflags & PET_READY))
            return TRUE;

    return FALSE;
};

//----------------------------------------------------/ New Code /--------//
//  This causes the dragon to forget all its opponents and leave attack
//  mode immediately.
//------------------------------------------------------------------------//
float(entity pet) PM_PetInstantCalm =
{
    // Forget the enemy!
    if (pet.enemy)
    {
        if (pet.enemy.classname != "watergoal")
            pet.enemy = world;
    }
    pet.oldenemy = world;

    // Now make the dragon leave attack mode if possible.

    // If non-solid, assume it is not available, and don't set think stuff.
    if (PM_PetHiding (pet))
        return;

    // Get out of attack animation, and go idle immediately.
    if (pet == pet.master.draco)
    {
        pet.master.petflags = pet.master.petflags -
            (pet.master.petflags & PET_FORCED);
        if (pet.master.petflags & PET_STAY)
            pet.think      = pet.th_stand;
        else
            pet.think      = pet.th_walk;
    }
    else
    {
        pet.think      = pet.th_walk;
    }
    pet.nextthink  = 0.1;   // ASAP
};

//----------------------------------------------------/ New Code /--------//
//  This checks if the path near the desired spot is blocked.
//------------------------------------------------------------------------//
float(entity pet, vector spot) PM_PetSpotLineBlocked =
{
    traceline (pet.master.origin, spot, FALSE, pet.master);
    if (trace_fraction < 1)
    {
        if (trace_ent != pet)
            return TRUE;
        traceline (trace_endpos, spot, FALSE, pet);
        if (trace_fraction < 1)
            return TRUE;
    }

    return FALSE;
};

//----------------------------------------------------/ New Code /--------//
//  This checks if the spot is blocked from the dragon's master.
//------------------------------------------------------------------------//
float(entity pet, vector spot) PM_PetSpotBlocked =
{
    local   vector  p;

    // Check origin.
    p = spot;
    if (PM_PetSpotLineBlocked (pet, p))
        return TRUE;

    // Check bbox corners.
    // Order:  1)+++  2)-++  3)+-+  4)--+  5)++-  6)-+-  7)+--  8)---
    p_x = spot_x + pet.maxs_x;
    p_y = spot_y + pet.maxs_y;
    p_z = spot_z + pet.maxs_z;
    if (PM_PetSpotLineBlocked (pet, p))
        return TRUE;

    p_x = spot_x + pet.mins_x;
    if (PM_PetSpotLineBlocked (pet, p))
        return TRUE;

    p_x = spot_x + pet.maxs_x;
    p_y = spot_y + pet.mins_y;
    if (PM_PetSpotLineBlocked (pet, p))
        return TRUE;

    p_x = spot_x + pet.mins_x;
    if (PM_PetSpotLineBlocked (pet, p))
        return TRUE;

    p_x = spot_x + pet.maxs_x;
    p_y = spot_y + pet.maxs_y;
    p_z = spot_z + pet.mins_z;
    if (PM_PetSpotLineBlocked (pet, p))
        return TRUE;

    p_x = spot_x + pet.mins_x;
    if (PM_PetSpotLineBlocked (pet, p))
        return TRUE;

    p_x = spot_x + pet.maxs_x;
    p_y = spot_y + pet.mins_y;
    if (PM_PetSpotLineBlocked (pet, p))
        return TRUE;

    p_x = spot_x + pet.mins_x;
    if (PM_PetSpotLineBlocked (pet, p))
        return TRUE;

    return FALSE;
};

//----------------------------------------------------/ New Code /--------//
//  This checks if the dragon can occupy a given spot.  If so, TRUE is
//  returned.  The spot can be occupied only if the path between the
//  dragon familiar and master is not blocked, and if the spot is not
//  occupied by a solid.
//------------------------------------------------------------------------//
float(entity pet, vector spot) PM_GoodPetSpot =
{
    if (PM_PetSpotBlocked (pet, spot))
        return FALSE;
    if (PM_EntInWall (pet, spot))
        return FALSE;

    return TRUE;
};

//----------------------------------------------------/ New Code /--------//
//  This tries to teleport the dragon close to the player.
//------------------------------------------------------------------------//
vector(entity pet) PM_PetSpot4 =
{
    local   vector  org;
    local   vector  spot;

    makevectors (pet.master.angles);

    org = pet.master.origin + OFFSET_TELEPORT;

    // First attempt: Check in front of player.
    spot = org + v_forward * 60;
    if (PM_GoodPetSpot (pet, spot))
        return spot;

    // Second attempt: Check right of player.
    spot = org + v_right * 60;
    if (PM_GoodPetSpot (pet, spot))
        return spot;

    // Third attempt: Check left of player.
    spot = org - v_right * 60;
    if (PM_GoodPetSpot (pet, spot))
        return spot;

    // Fourth and final attempt: Check behind of player.
    spot = org - v_forward * 60;
    if (PM_GoodPetSpot (pet, spot))
        return spot;

    // Failed, so return a point the pet cannot use.
    return pet.master.origin;
};

//----------------------------------------------------/ New Code /--------//
//  This tries to teleport the dragon near the player.
//------------------------------------------------------------------------//
vector(entity pet) PM_PetSpot5 =
{
    local   vector  org;
    local   vector  spot;

    makevectors (pet.master.angles);

    org = pet.master.origin + OFFSET_TELEPORT;

    // First attempt: check ahead and above the player.
    spot = org + v_forward * 200 + v_up * 85;
    if (PM_GoodPetSpot (pet, spot))
        return spot;

    // Second attempt: check to the right of the player.
    spot = org + v_right * 60;
    if (PM_GoodPetSpot (pet, spot))
        return spot;

    // Third attempt: check to the left of the player.
    spot = org - v_right * 60;
    if (PM_GoodPetSpot (pet, spot))
        return spot;

    // Fourth attempt: check right behind of the player.
    spot = org - v_forward * 60;
    if (PM_GoodPetSpot (pet, spot))
        return spot;

    // Fifth and final attempt: check straight ahead and up close.
    spot = org + v_forward * 60;
    if (PM_GoodPetSpot (pet, spot))
        return spot;

    // Failed, so return a point the pet cannot use.
    return pet.master.origin;
};

//----------------------------------------------------/ New Code /--------//
//  This tries to teleport the dragon near to the player.  TRUE is
//  returned if successful.
//------------------------------------------------------------------------//
float(entity pet, float near) PM_PetComeHere =
{
    if (PM_InCutscene (pet.master))
        return FALSE;   // Don't teleport near camera.

    local   vector  spot;

    if (near)
        spot = PM_PetSpot4 (pet);
    else
        spot = PM_PetSpot5 (pet);

    if (spot == pet.master.origin)
        return FALSE;   // No valid spot available.

    // Move to new destination.
    spawn_tfog (pet.origin);
    setorigin (pet, spot);
    spawn_tfog (pet.origin);

    // Face the master now.
    pet.angles_y = vectoyaw(pet.master.origin - pet.origin);
    pet.fixangle = TRUE;

    // Get dragon out of attack mode.
    PM_PetInstantCalm (pet);

    return TRUE;
};


//==========================================================================
//  Pet Block Detection and Escape

//----------------------------------------------------/ New Code /--------//
//  This looks for all bloodcubes a pet's master has.  If any are found,
//  the pet stays hidden until they all go away.
//------------------------------------------------------------------------//
float() PM_PetAvoidCube =
{
    local   entity  cube;
    local   float   cube_done;
    local   float   standby;

    standby = 0;

    cube = find(world, classname, "BloodCube");
    while (cube != world)
    {
        if (cube.owner == self.master)
        {
            // Remember the time when the last bloodcube expires.
            cube_done = cube.radsuit_finished - time;
            if (cube_done > standby)
                standby = cube_done;
        }

        cube = find(cube, classname, "BloodCube");
    }

    if (standby)
    {
        // Do not reappear until ALL bloodcubes owned by master are gone!
        self.nextthink = time + standby + 3;
        self.think = PM_PetReappear;
        return TRUE;
    }

    return FALSE;
};

//----------------------------------------------------/ New Code /--------//
//  This checks if the dragon is allowed to reappear.
//------------------------------------------------------------------------//
float() PM_DelayPetReturn =
{
    if (PM_InCutscene (self.master))
        return TRUE;    // Do not reappear during a cutscene.

    // Do not appear while master is firing a weapon.
    if (self.master.button0)
        if (!(self.master.petflags & PET_CONTROL))
            return TRUE;

    // May reappear normally.
    return FALSE;
};

//----------------------------------------------------/ New Code /--------//
//  The pet dragon reappears soon after disappearing for some reason.
//------------------------------------------------------------------------//
void() PM_PetReappear =
{
    // Check if it should reappear at this time.
    if (PM_DelayPetReturn ())
    {
        // Not allowed to return to master.
        self.nextthink  = time + 0.2;
        self.think      = PM_PetReappear;
        return;
    }

    // Do not reappear until ALL bloodcubes owned by master are gone!
    if (PM_PetAvoidCube ())
        return;

    local   vector  spot;

    // Try to reappear normally.
    setsize (self, VEC_RYU2_MIN, VEC_RYU2_MAX);
    spot = PM_PetSpot5 (self);
    if (spot == self.master.origin)
    {
        // No valid reentry point.  Try again later.
        self.nextthink = time + 1;
        self.think = PM_PetReappear;
        return;
    }

    setorigin (self, spot);

    self.movetype   = MOVETYPE_STEP;
    self.touch      = PM_PetTouch;
    self.takedamage = DAMAGE_AIM;
    self.solid      = SOLID_SLIDEBOX;
    self.angles_y   = vectoyaw(self.master.origin - self.origin);
    self.fixangle   = TRUE;

    spawn_tfog (self.origin);
    setmodel (self, "progs/dragon2.mdl");
    setsize (self, VEC_RYU2_MIN, VEC_RYU2_MAX);

    if (self == self.master.draco)
    {
        // FIXME:  Draco won't talk if it was evil before being pacified.
        self.master.petflags = self.master.petflags | PET_READY;
        PM_DracoTalk (self, "I am back.");
    }
    PM_PetInstantCalm (self);
};

//----------------------------------------------------/ New Code /--------//
//  If a pet is blocking its master's way, it will remember.  If it
//  blocked its master after a few seconds, it will disappear.
//------------------------------------------------------------------------//
void(entity pet, float standby) PM_PetDisappear =
{
    // Dragon has gone for a while... assume fire was put out in meantime.
    PM_KillFire (pet);

    // Make the dragon disappear.
    pet.movetype   = MOVETYPE_NONE;
    pet.velocity   = '0 0 0';
    pet.touch      = SUB_Null;
    pet.takedamage = DAMAGE_NO;
    pet.solid      = SOLID_NOT;
    if (pet == pet.master.draco)
        pet.master.petflags = pet.master.petflags -
            (pet.master.petflags & PET_READY);
    spawn_tfog (pet.origin);
    setmodel (pet, "");
    setorigin (pet, VEC_ORIGIN);
    pet.nextthink  = time + standby;
    pet.think      = PM_PetReappear;
};

//----------------------------------------------------/ New Code /--------//
//  If a pet is blocking its master's way, move out of the way.
//------------------------------------------------------------------------//
float() PM_CheckPetBlock =
{
    if (!self.pettouch)
    {
        self.inway = 0;
        return FALSE;
    }

    self.pettouch = FALSE;

    // Go straight up if possible.
    if (self.origin_z >= self.master.origin_z)
    {
        if (ryu_up (DRAGON_MINSPEED))
        {
            self.inway = 0;
            return TRUE;
        }
    }

    // NOTE:  Never go down, so player can't use dragon as a platform...

    // Move away from master if vertical movement is impossible.
    if (!walkmove (self.angles_y, self.speed))
    {
        self.ideal_yaw = vectoyaw(self.origin - self.master.origin);
        ChangeYaw ();

        if (FacingIdeal ())
        {
            if (walkmove (self.angles_y, self.speed))
            {
                self.inway = 0;
            }
            else if (self.inway >= 50)
            {
                // Can't move?  Teleport as a last resort!
                if (self.health > COST_PET_TELEPORT)
                {
                    if (self == self.master.draco)
                        PM_DracoTalk (self, "In your way?  I will be back.");
                    self.health = self.health - COST_PET_TELEPORT;
                    self.inway = 0;
                    PM_PetDisappear (self, 5);
                }
            }
            else
            {
                self.inway = self.inway + 1;
            }
        }
    }
    else
    {
        self.inway = 0;
    }

    return TRUE;
};

//----------------------------------------------------/ New Code /--------//
//  If a pet is touched by its master, it will know.  This is used
//  to make the pet disappear if it blocks its master's way.
//------------------------------------------------------------------------//
void() PM_PetTouch =
{
    if (other == self.master)
        if (self.enemy.classname != "watergoal")
            self.pettouch = TRUE;
};


//==========================================================================
//  Pet Anti-Clipping

//----------------------------------------------------/ New Code /--------//
//  A pet dragon that gets caught inside a wall loses health.  If
//  it has any health left, it disappears then teleports to near
//  its master.  TRUE is returned if the dragon got caught in a wall.
//------------------------------------------------------------------------//
float() PM_PetGoneInWall =
{
    local   float   content;

    content = pointcontents (self.origin);
    if ((content == CONTENT_SOLID) || (content == CONTENT_SKY))
    {
        self.health = self.health - COST_PET_TELEPORT;
        if (self == self.master.draco)
        {
            // Draco
            if (self.health <= 0)
            {
                PM_KillDraco (self.master, TRUE);
                return TRUE;
            }
            PM_DracoTalk (self, "OUCH!");
        }
        else
        {
            // Some minor familiar...
            if (self.health <= 0)
            {
                PM_InstantKillPet (self, TRUE);
                return TRUE;
            }
        }

        PM_PetDisappear (self, 5);
        return TRUE;
    }

    return FALSE;
};

//----------------------------------------------------/ New Code /--------//
//  This checks if the pet dragon has clipped its master.  If so,
//  fly away from it so that the player is unstuck.
//------------------------------------------------------------------------//
void(entity ent) PM_PetAntiTrap =
{
    local   vector  org;    // Dragon origin
    local   vector  spot;   // Checkpoint

    // The dragon flies away if it clips & forces the player to the ground.
    if (vlen(self.master.origin - self.origin) < DETECT_RADIUS)
    {
        spot = self.master.origin;
        spot_z = spot_z + self.master.mins_z;
        if (pointcontents(spot) == CONTENT_SOLID)
        {
            PM_FindBestPath (self.speed, self.master);
            return;
        }
    }

    // Check if an entity is inside the dragon.  If so, fly away from it.
    if (ent.solid == SOLID_SLIDEBOX)
        if (ent != self)
        {
            // Dragon definitely clipped someone.
            PM_FindBestPath (self.speed, ent);
            return;
        }

    // Now check if the dragon is clipping its master.
    traceline(self.origin, self.master.origin, FALSE, self);

    if (trace_ent != self.master)
        return;

    spot = trace_endpos;
    org  = self.origin;

    // Check if location is inside the dragon's bbox.
    if (spot_x >= org_x + self.maxs_x)  return;
    if (spot_x <= org_x + self.mins_x)  return;
    if (spot_y >= org_y + self.maxs_y)  return;
    if (spot_y <= org_y + self.mins_y)  return;
    if (spot_z >= org_z + self.maxs_z)  return;
    if (spot_z <= org_z + self.mins_z)  return;

    // Entity is trapped; fly away from it to free it.
    PM_FindBestPath (self.speed, self.master);
};


//==========================================================================
//  Grenade Detection

//----------------------------------------------------/ New Code /--------//
//  This checks if the given entity is a grenade or rocket.
//------------------------------------------------------------------------//
float(entity ent) PM_IsGrenade =
{
    if (ent.classname == "grenade")
        return TRUE;
    if (ent.classname == "missile")
        return TRUE;

    return FALSE;
};

//----------------------------------------------------/ New Code /--------//
//  This searches for players' grenades near the dragon.
//  This is similar to 'PM_FindThreat'.
//------------------------------------------------------------------------//
entity() PM_PetFindBombs =
{
    local   entity   head;

    // Same radius as in 'PM_FindThreat'.
    head = findradius(self.origin, DETECT_RADIUS);

    // Return the first grenade found (if any).
    while (head)
    {
        if (head != self)
        {
            traceline (self.origin, head.origin, TRUE, self);
            if (trace_fraction == 1)
                if (head.owner != self.enemy)
                    if (PM_IsGrenade (head))
                    {
                        // Avoid grenades from allies.
                        if (head.owner.classname == "player")
                            if (PM_PlayerOnSameTeam (head.owner, self.master))
                                return head;    // Got one!

                        if (head.owner == self.master)
                            return head;    // Got one!
                    }
        }
        head = head.chain;
    }

    // If the function made it this far, nothing valid was found.
    return head;
};

//----------------------------------------------------/ New Code /--------//
//  This checks if a grenade is nearby and if so, get out of its way.
//  This is similar to 'PM_DetectDanger'.
//------------------------------------------------------------------------//
float(float dist) PM_PetDetectBombs =
{
    local   entity  head;

    // Check if the monster will bother dodging.
    if (self.state < IQ_HIGH)
        return FALSE;

    // Find the first grenade if any.
    head = PM_PetFindBombs ();
    if (head)
    {
        // Got one!
        PM_FindBestPath (dist, head);
        return TRUE;
	}

    // No grenade was found.
    return FALSE;
};


//===========================/  END OF FILE  /===========================//
