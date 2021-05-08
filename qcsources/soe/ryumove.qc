//==========================================================================
//  ryumove.qc -- by Patrick Martin             Last updated:  5-8-2001
//--------------------------------------------------------------------------
//  This file contains code that does collision checking as well as
//  detecting and dodging projectiles or other dangerous entities
//  nearby the dragon.
//==========================================================================


//==========================================================================
//  Anti-Clipping

//----------------------------------------------------/ New Code /--------//
//  This ejects the dragon from the obstacle it is clipping and
//  gives it a new direction to follow.
//------------------------------------------------------------------------//
void(float reverse, float dist) PM_Eject =
{
    local   vector  dir;       // Vector from monster to opponent.
    local   float   idealyaw;  // Yaw of 'dir' vector.
    local   float   headyaw;   // Current yaw of monster.
    local   float   diffyaw;   // Difference between 'ideal' and 'head'.

    // Eject the dragon from the obstacle.
    walkmove(reverse, dist);

    // Send the dragon off to another direction.  If dragon has an
    // opponent, the dragon will head straight at the opponent if
    // possible.  Otherwise, it will turn to the side.
    if (self.enemy)
    {
        traceline (self.origin, self.enemy.origin, FALSE, self);
        if (trace_ent == self.enemy)
            self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
        else
        {
            // Find angle to points to the opponent.
            dir = normalize(self.enemy.origin - self.origin);
            idealyaw = vectoyaw(dir);
            idealyaw = anglemod(idealyaw);

            // Find angle of where the dragon is facing.
            headyaw = anglemod(self.angles_y);

            // Find the difference bewteen the two angles.
            diffyaw = anglemod(idealyaw - headyaw);

            // Turn and (try to) follow the wall toward the opponent.
            if (diffyaw < 180)
                self.ideal_yaw = anglemod(self.angles_y + 90);
            else
                self.ideal_yaw = anglemod(self.angles_y - 90);
        }
        ChangeYaw ();
        return;
    }

    if (random() < 0.5)
        self.ideal_yaw = anglemod(self.angles_y + 90);
    else
        self.ideal_yaw = anglemod(self.angles_y - 90);
    ChangeYaw ();
};

//----------------------------------------------------/ New Code /--------//
//  This checks if the dragon is clipping any walls or solid entities
//  and if so, ejects the dragon from the obstacle.
//
//  NOTE:  The built-in functions 'walkmove' and 'movetogoal'
//         are buggy.  At least with large, flying monsters,
//         the functions seem to check only from self.mins to
//         self.origin with respect to the xy-plane.  As a result,
//         such a monster can easily clip the east or north walls,
//         and some sort of correction is necessary.
//
//         Unfortunately, there is no efficient way to check if
//         the dragon is clipping a sky brush.  Solution:  stick
//         with thin brushes and don't use skies as walls.
//------------------------------------------------------------------------//
float() PM_AntiClip =
{
    // Small dragons are ok -- they don't clip walls like large dragons.
    if (self.height == SIZE_SMALL)
        return 0;

    local   vector  dir;        // Point on one of the bbox faces.
    local   vector  org;        // Dragon origin.
    local   float   dist;       // Dist. needed to eject dragon from wall.
    local   float   clipcount;  // Number of walls dragon clipped.

    clipcount = 0;
    org = self.origin;

    // Check if the monster is clipping the east then west walls.
    dir = org;
    dir_x = dir_x + self.maxs_x;
    traceline (org, dir, FALSE, self);
    if (trace_fraction < 1)
    {
        dist = self.maxs_x * (1 - trace_fraction);
        PM_Eject (180, dist);
        clipcount = clipcount + 1;
    }
    else
    {
        dir_x = org_x + self.mins_x;
        traceline (org, dir, FALSE, self);
        if (trace_fraction < 1)
        {
            dist = self.mins_x * (trace_fraction - 1);
            PM_Eject (0, dist);
            clipcount = clipcount + 1;
        }
    }

    // Check if the monster is clipping the north then south walls.
    dir = org;
    dir_y = dir_y + self.maxs_y;
    traceline (org, dir, FALSE, self);
    if (trace_fraction < 1)
    {
        dist = self.maxs_y * (1 - trace_fraction);
        PM_Eject (270, dist);
        clipcount = clipcount + 1;
    }
    else
    {
        dir_y = org_y + self.mins_y;
        traceline (org, dir, FALSE, self);
        if (trace_fraction < 1)
        {
            dist = self.mins_y * (trace_fraction - 1);
            PM_Eject (90, dist);
            clipcount = clipcount + 1;
        }
    }

    return clipcount;
};

//----------------------------------------------------/ New Code /--------//
//  This checks if the dragon has clipped its enemy or any other entity
//  in the way.  If so, fly away from it so that it is unstuck.
//------------------------------------------------------------------------//
void(float dist) PM_AntiTrap =
{
    local   vector  org;            // Dragon origin
    local   vector  spot;           // Checkpoint
    local   entity  clipped;        // The entity in the way.

    // The dragon flies away if it clips and forces the player into
    // the ground.
    if (self.enemy.classname == "player")
        if (vlen(self.enemy.origin - self.origin) < DETECT_RADIUS)
        {
            spot = self.enemy.origin;
            spot_z = spot_z + self.enemy.mins_z;
            if (pointcontents(spot) == CONTENT_SOLID)
            {
                PM_FindBestPath(dist, self.enemy);
                return;
            }
        }

    // Now check if the dragon is merely clipping an entity.
    traceline(self.origin, self.enemy.origin, FALSE, self);

    // If something was found, make sure it is not part of the world.
    if (trace_fraction < 1)
    {
        if (trace_ent == world)
            return;
        if (trace_ent.solid == SOLID_BSP)
            return;
    }

    // If no trace entity was found, assume it is enemy.  (Maybe too close?)
    if (!trace_ent)
        clipped = self.enemy;
    else
        clipped = trace_ent;

    spot = trace_endpos;
    org = self.origin;

    // Check if location is inside the dragon's bbox.
    if (spot_x >= org_x + self.maxs_x)  return;
    if (spot_x <= org_x + self.mins_x)  return;
    if (spot_y >= org_y + self.maxs_y)  return;
    if (spot_y <= org_y + self.mins_y)  return;
    if (spot_z >= org_z + self.maxs_z)  return;
    if (spot_z <= org_z + self.mins_z)  return;

    // Entity is trapped; fly away from it to free it.
    PM_FindBestPath(dist, clipped);
};

//----------------------------------------------------/ New Code /--------//
//  This tells the dragon to circle the zombie if the zombie is down
//  and the dragon is within melee range.  This stops the dragon from
//  flying in too close to the zombie and stopping, which can pin the
//  zombie (and incidentally the dragon as well) indefinitely.
//------------------------------------------------------------------------//
float() PM_AntiZombiePin =
{
    if (self.enemy.solid == SOLID_NOT)
        if (enemy_range == RANGE_MELEE)
            if (self.enemy.classname == "monster_zombie")
            {
                ryu_circlestrafe (DRAGON_MINSPEED);
                return TRUE;
            }

    return FALSE;
};


//==========================================================================
//  Vertical Movement

//----------------------------------------------------/ New Code /--------//
//  This checks if any obstacles are in the way.  TRUE is returned
//  if no obstacles were found.
//------------------------------------------------------------------------//
float(float offset) PM_AllClear =
{
    local   vector  p1, p2;
    local   vector  probe;

    // Check straight up or down from the monster's origin.
    p1 = p2 = self.origin;
    p2_z = p2_z + offset;
    traceline (p1, p2, FALSE, self);
    if (trace_fraction < 1)
        return FALSE;

    // Special:  Check if a sky brush is in the way!
    if (trace_inwater)
        if (pointcontents(self.origin) == CONTENT_EMPTY)
        {
            local   float   content;

            probe = trace_endpos;
            content = pointcontents (probe);
            if (content == CONTENT_EMPTY)
            {
                if (self.enemy)
                {
                    traceline(self.origin, self.enemy.origin, TRUE, self);
                    if (trace_fraction < 1)
                        return FALSE;
                    if (!trace_inwater)
                        return FALSE;
                }
                else
                {
                    if (self.master.classname != "player")
                        return FALSE;

                    traceline(self.origin, self.master.origin, TRUE, self);
                    if (trace_fraction < 1)
                        return FALSE;
                }
            }
            if (content == CONTENT_SKY)
                return FALSE;

            // If dragon is hydrophobic, then do not pass through liquid.
            if (PM_Hydrophobic ())
            {
                if (content == CONTENT_WATER)
                    return FALSE;
                if (content == CONTENT_SLIME)
                    return FALSE;
                if (content == CONTENT_LAVA)
                    return FALSE;
            }
        }

    // Trace from NE to SW.
    p1_x = p1_x + self.maxs_x;
    p1_y = p1_y + self.maxs_y;
    p2_x = p2_x + self.mins_x;
    p2_y = p2_y + self.mins_y;
    traceline (p1, p2, FALSE, self);
    if (trace_fraction < 1)
        return FALSE;

    // Trace from NW to SE.
    p1_x = self.origin_x + self.mins_x;
    p2_x = self.origin_x + self.maxs_x;
    traceline (p1, p2, FALSE, self);
    if (trace_fraction < 1)
        return FALSE;

    // Trace from SW to NE.
    p1_y = self.origin_y + self.mins_y;
    p2_y = self.origin_y + self.maxs_y;
    traceline (p1, p2, FALSE, self);
    if (trace_fraction < 1)
        return FALSE;

    // Trace from SE to NW.
    p1_x = self.origin_x + self.maxs_x;
    p2_x = self.origin_x + self.mins_x;
    traceline (p1, p2, FALSE, self);
    if (trace_fraction < 1)
        return FALSE;

    // Monster passed all the checks -- no obstacles were found.
    return TRUE;
};

//----------------------------------------------------/ New Code /--------//
//  This tells the dragon to go straight down.  Returns TRUE if successful.
//------------------------------------------------------------------------//
float(float dist) ryu_down =
{
    local   vector  dir;
    local   float   offset;

    dir   = self.origin;
    dir_z = dir_z - dist;
    offset = self.mins_z - dist;
    if (PM_AllClear (offset))
    {
        setorigin (self, dir);
        return TRUE;
    }
    return FALSE;
};

//----------------------------------------------------/ New Code /--------//
//  This tells the dragon to go straight up.  Returns TRUE if successful.
//------------------------------------------------------------------------//
float(float dist) ryu_up =
{
    local   vector  dir;
    local   float   offset;

    dir   = self.origin;
    dir_z = dir_z + dist;
    offset = self.maxs_z + self.maxs_z + dist;
    if (PM_AllClear(offset))
    {
        setorigin(self, dir);
        return TRUE;
    }
    return FALSE;
};

//----------------------------------------------------/ New Code /--------//
//  This checks if the dragon is within the xy-plane with respect
//  to its opponent.
//------------------------------------------------------------------------//
float() PM_CheckDragonLevel =
{
    local   float   ez;     // enemy's z value.
    local   float   sz;     // self's (the dragon's) z value.

    // Check if dragon is above enemy's head.  If so, return FALSE.
    sz = self.origin_z + self.mins_z - self.speed;
    ez = self.enemy.origin_z + self.enemy.maxs_z;
    if (ez < sz)
        return FALSE;

    // Check if dragon is below enemy's feet.  If so, return FALSE.
    sz = self.origin_z + self.maxs_z + self.speed;
    ez = self.enemy.origin_z + self.enemy.mins_z;
    if (ez > sz)
        return FALSE;

    // Dragon is level with its opponent.
    return TRUE;
};

//----------------------------------------------------/ New Code /--------//
//  The dragon flies up or down based on current conditions.
//------------------------------------------------------------------------//
void(float dist, entity ent) PM_VerticalSlide =
{
    // If in the unlikely event a water-fearing dragon is in the water,
    // find some air and go in the direction it is found.
    if (PM_Hydrophobic ())
        if (PM_EntInWater (self))
            if (PM_LeaveWater (dist))
                return;

    // If heading for water, fly up or down randomly.  (Panic flight.)
    if (ent.classname == "watergoal")
    {
        if (random() < 0.5)
            ryu_down (dist);
        else
            ryu_up (dist);
        return;
    }

    // Fly away from goal.
    if (ent.origin_z > self.origin_z)
        ryu_down (dist);
    else
        ryu_up (dist);
};


//==========================================================================
//  Danger Evasion

//----------------------------------------------------/ New Code /--------//
//  Fly toward to direction that will most likely dodge the threat.
//------------------------------------------------------------------------//
void(float newyaw, float dist, entity ent) PM_Dodge =
{
    // Strafe away from the detected danger.  If path is blocked,
    // flag it with a time so that future checks use a different path.
    if (!walkmove (newyaw, dist))
    {
        if (self.dodge_back > time)
            self.dodge_back = 0;
        else
            self.dodge_back = time + 0.5 + random();
    }
    PM_AntiClip();

    // Face target and change elevation.
    self.ideal_yaw = vectoyaw (ent.origin - self.origin);
    ChangeYaw ();
    PM_VerticalSlide (dist, ent);
};

//----------------------------------------------------/ New Code /--------//
//  Find the best direction to head for.
//------------------------------------------------------------------------//
float(float theta) PM_ChangeCourse =
{
    if (theta < 60)   return -90;   // Dodge right.
    if (theta < 120)  return 0;     // Continue straight ahead.
    if (theta < 180)  return -90;   // Dodge right.
    if (theta < 240)  return 90;    // Dodge left.
    if (theta < 300)  return 0;     // Continue straight ahead.
    return 90;                      // Dodge left.
};

//----------------------------------------------------/ New Code /--------//
//  Compare the yaws of the dragon's direction and the direction
//  toward the threat, and find the best direction to dodge the
//  threat on the results.
//------------------------------------------------------------------------//
void(float dist, entity ent) PM_FindBestPath =
{
    local   vector  dir;       // Vector from monster to danger.
    local   float   misyaw;    // Yaw of 'dir' vector.
    local   float   newyaw;    // Yaw that points to the new direction.
    local   float   oldyaw;    // Current yaw of monster.

    // Find yaw of vector pointing from monster to the detected entity.
    dir = normalize(ent.origin - self.origin);
    misyaw = vectoyaw(dir);
    misyaw = anglemod(misyaw);

    // Get yaw of the monster.
    oldyaw = anglemod(self.angles_y);

    // Find the best new path (direction) for the monster.
    newyaw = misyaw - oldyaw;
    newyaw = anglemod(newyaw);
    newyaw = PM_ChangeCourse(newyaw);

    // If path was recently blocked, reverse the direction.
    if (self.dodge_back > time)
        newyaw = 0 - newyaw;

    // Set new course and head in that direction if possible.
    // NOTE:  Slide vertically away from goal, not actual threat.
    oldyaw = oldyaw + newyaw;
    anglemod(oldyaw);
    PM_Dodge(oldyaw, dist, self.goalentity);
};


//==========================================================================
//  Danger Detection

//----------------------------------------------------/ New Code /--------//
//  This tells the dragon whether or not it is best to stay away from
//  the entity.  TRUE is returned if the dragon should stay away.
//  FALSE is returned if the dragon is better off closing in on entity.
// 
//  Only very smart dragons (genius level or greater) have the knowledge
//  to figure out who the entity is and what kind of weapons, items, or
//  other abilities he/she/it has.
//------------------------------------------------------------------------//
float(entity ent) PM_KeepAway =
{
    // Look out for fire.
    if (PM_IsBurning (ent))
    {
        // Stay away from the enemy if he is burning.
        if (ent == self.enemy)
            return TRUE;

        // Dragons vulnerable to fire stay away from any burning entity.
        if (self.skin != SKIN_RED)
            if (self.skin != SKIN_GOLD)
                return TRUE;
    }

    // Only smarter dragons will use selective keep away tactics.
    if (self.state < IQ_GENIUS)
        return FALSE;

    // A dragon with no missile attack has no choice but to attack up close.
    if (!self.th_missile)
        return FALSE;

//-----/ Familiar only code /-----//
    // If dragon is a player's familiar, stay away only from bad guys.
    // NOTE:  This uses a function from 'petai.qc'.
    if (self.master.classname == "player")
    {
        if (PM_IsPetAlly (ent, self))
            return FALSE;
    }
//--------------------------------//

    // Check if entity is dying or dead.
    if (ent.health <= 0)
    {
        // Entity is dying/dead.  Entities that do destructive things
        // when killed (such as exploding) should be avoided.

        // Avoid the spawn at all costs!  Explosion damage isn't pretty.
        if (ent.classname == "monster_tarbaby")
            return TRUE;

        // Nightshade explode when killed.
        if (ent.classname == "monster_nightshade")
            return TRUE;

        // Entity is harmless now that it is dead.
        return FALSE;
    }

    // If entity is a player, stay away if he is using rockets.
    if (ent.classname == "player")
    {
        if (vlen(ent.origin - self.origin) > 120)
        {
            if (ent.weapon == IT_ROCKET_LAUNCHER)
                return TRUE;
            if (ent.weapon == IT_GRENADE_LAUNCHER)
                return TRUE;
            // FIXME:  Add chainsaw from Zerstorer here.
        }
    }

    // If anyone is invincible, stay away!
    if (ent.items & IT_INVULNERABILITY)
        if (ent.invincible_finished >= time)
            return TRUE;

    // Stay away from anyone who has quad damage.
    if (ent.items & IT_QUAD)
        if (ent.super_damage_finished >= time)
            return TRUE;

    // A fiend that can jump repeatedly at the dragon's back will kill
    // the dragon quickly so stay away from the fiend.  Also, a fiend
    // that cannot reach the dragon is helpless.
    if (ent.classname == "monster_demon1")
    {
        // Fiend is dangerous only when it is awake.
        if (ent.enemy)
        {
            // If dragon is the target, always stay away.
            if (ent.enemy == self)
                return TRUE;

            // Get out of the fiend's way if it can see its opponent.
            if (PM_EntIsVisible (ent.enemy, ent, TRUE))
                return TRUE;
        }
    }

    // Avoid the spawn at all costs!  Explosion damage isn't pretty.
    // It is here too because they explode almost immediately after death.
    if (ent.classname == "monster_tarbaby")
        return TRUE;

    // The cyberdemon is too trigger-happy for his own good :)
    // Besides, don't even think about engaging the cyberdemon in melee!
    if (ent.classname == "monster_cyberdemon")
        return TRUE;

    // Stay away from the following entities only if it is an enemy.
    if (self.enemy == ent)
    {
        // Stay away from these if dragon has low health.
        if (self.health <= 50)
        {
            if (ent.classname == "monster_ogre")
                return TRUE;
            if (ent.classname == "monster_knight")
                return TRUE;

            // Comments on other possible candidates:
            // Death Knight -- He will spray the area with magic missiles
            //  so it doesn't do much good to stay away from him.
            // Rottweiler -- It is so flimsy and weak, just kill it.
            //  If it was stronger, treat it like the fiend.
        }

        // The shambler is usually at a disadvantage from a distance.
        if (ent.classname == "monster_shambler")
            if (skill < 3)
                return TRUE;

        // Snakeman is most dangerous up close.
        if (ent.classname == "monster_snakeman")
            return TRUE;
    }

    // It is best to close in on the enemy.
    return FALSE;
};

//----------------------------------------------------/ New Code /--------//
//  This checks if the entity found is dangerous and should be avoided
//  (if possible).
//------------------------------------------------------------------------//
float(entity ent) PM_IsHostile =
{
    // Ignore entities owned by its owner (for obvious reasons).
    if (ent.owner == self)
        return FALSE;
    if (ent.flamer == self)
        return FALSE;

    // Check if entity is an avoidable projectile.
    if (PM_IsProjectile (ent))
    {
        if (ent.enemy == self)
            return FALSE;   // Homing missile -- don't bother.
        if (ent.solid == SOLID_TRIGGER)
            if (ent.classname == "fireball")
                return FALSE;   // Ignore lavaballs.

        return TRUE;
    }

    // Decide whether or not to stay away from the entity detected.
    return PM_KeepAway (ent);
};

//----------------------------------------------------/ New Code /--------//
//  This searches for dangerous entities near the dragon.
//------------------------------------------------------------------------//
entity() PM_FindThreat =
{
    local   entity   head;

    // Radius of 300 seems to be optimal (used to be 500).
    head = findradius(self.origin, DETECT_RADIUS);

    // Return the first threat found (if any).
    while (head)
    {
        if (head != self)
        {
            traceline (self.origin, head.origin, TRUE, self);
            if (trace_fraction == 1)
                if (PM_IsHostile (head))
                    return head;    // Got one!
        }
        head = head.chain;
    }

    // If the function made it this far, nothing valid was found.
    return head;
};

//----------------------------------------------------/ New Code /--------//
//  This checks if a dangerous entity is nearby and if so, get out of
//  its way.
//------------------------------------------------------------------------//
float(float dist) PM_DetectDanger =
{
    local   entity  head;

    // Check if the monster will bother dodging.
    if (self.state < IQ_HIGH)
        return FALSE;

    // Find the first entity that poses a threat if any are nearby.
    head = PM_FindThreat ();
    if (head)
    {
        // Got one!
        PM_FindBestPath (dist, head);
        return TRUE;
	}

    // Nothing dangerous was found.
    return FALSE;
};


//===========================/  END OF FILE  /===========================//
