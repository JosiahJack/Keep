//==========================================================================
//  check.qc -- by Patrick Martin               Last updated:  3-27-2001
//--------------------------------------------------------------------------
//  This file contains code that determines whether an entity or a
//  location is inside the various contents found in Quake.
//==========================================================================


//==========================================================================
//  Entity in Solid Checks

//----------------------------------------------------/ New Code /--------//
//  This checks if a bbox is inside a wall or sky.  The bbox's origin
//  and corners are checked.  If any one points is within a solid or sky,
//  TRUE is returned.
//------------------------------------------------------------------------//
float(entity ent, vector spot) PM_EntInWall =
{
    local   vector  p;
    local   float   content;

    // Check origin.
    p = spot;
    content = pointcontents(p);
    if (content == CONTENT_SOLID)  return TRUE;
    if (content == CONTENT_SKY)    return TRUE;

    // Check bbox faces.
    // Order:  1)-00  2)+00  3)0-0  4)0+0  5)00-  6)00+
    p_x = spot_x + ent.mins_x;
    content = pointcontents(p);
    if (content == CONTENT_SOLID)  return TRUE;
    if (content == CONTENT_SKY)    return TRUE;

    p_x = spot_x + ent.maxs_x;
    content = pointcontents(p);
    if (content == CONTENT_SOLID)  return TRUE;
    if (content == CONTENT_SKY)    return TRUE;

    p = spot;
    p_y = spot_y + ent.mins_y;
    content = pointcontents(p);
    if (content == CONTENT_SOLID)  return TRUE;
    if (content == CONTENT_SKY)    return TRUE;

    p_y = spot_y + ent.maxs_y;
    content = pointcontents(p);
    if (content == CONTENT_SOLID)  return TRUE;
    if (content == CONTENT_SKY)    return TRUE;

    p = spot;
    p_z = spot_z + ent.mins_z;
    content = pointcontents(p);
    if (content == CONTENT_SOLID)  return TRUE;
    if (content == CONTENT_SKY)    return TRUE;

    p_z = spot_z + ent.maxs_z;
    content = pointcontents(p);
    if (content == CONTENT_SOLID)  return TRUE;
    if (content == CONTENT_SKY)    return TRUE;

    // Check bbox corners.
    // Order:  1)+++  2)-++  3)+-+  4)--+  5)++-  6)-+-  7)+--  8)---
    p_x = spot_x + ent.maxs_x;
    p_y = spot_y + ent.maxs_y;
    content = pointcontents(p);
    if (content == CONTENT_SOLID)  return TRUE;
    if (content == CONTENT_SKY)    return TRUE;

    p_x = spot_x + ent.mins_x;
    content = pointcontents(p);
    if (content == CONTENT_SOLID)  return TRUE;
    if (content == CONTENT_SKY)    return TRUE;

    p_x = spot_x + ent.maxs_x;
    p_y = spot_y + ent.mins_y;
    content = pointcontents(p);
    if (content == CONTENT_SOLID)  return TRUE;
    if (content == CONTENT_SKY)    return TRUE;

    p_x = spot_x + ent.mins_x;
    content = pointcontents(p);
    if (content == CONTENT_SOLID)  return TRUE;
    if (content == CONTENT_SKY)    return TRUE;

    p_x = spot_x + ent.maxs_x;
    p_y = spot_y + ent.maxs_y;
    p_z = spot_z + ent.mins_z;
    content = pointcontents(p);
    if (content == CONTENT_SOLID)  return TRUE;
    if (content == CONTENT_SKY)    return TRUE;

    p_x = spot_x + ent.mins_x;
    content = pointcontents(p);
    if (content == CONTENT_SOLID)  return TRUE;
    if (content == CONTENT_SKY)    return TRUE;

    p_x = spot_x + ent.maxs_x;
    p_y = spot_y + ent.mins_y;
    content = pointcontents(p);
    if (content == CONTENT_SOLID)  return TRUE;
    if (content == CONTENT_SKY)    return TRUE;

    p_x = spot_x + ent.mins_x;
    content = pointcontents(p);
    if (content == CONTENT_SOLID)  return TRUE;
    if (content == CONTENT_SKY)    return TRUE;

    return FALSE;
};

//----------------------------------------------------/ New Code /--------//
//  This is a variation of InWall.  The bbox is checked if it is a
//  empty air; that is not inside solid, water, or anything else.
//  If any one point is within a brush, FALSE is returned.
//------------------------------------------------------------------------//
float(entity ent, vector spot) PM_EntInEmpty =
{
    local   vector  p;

    // Check origin.
    p = spot;
    if (pointcontents(p) != CONTENT_EMPTY)  return FALSE;

    // Check bbox faces.
    // Order:  1)-00  2)+00  3)0-0  4)0+0  5)00-  6)00+
    p_x = spot_x + ent.mins_x;
    if (pointcontents(p) != CONTENT_EMPTY)  return FALSE;

    p_x = spot_x + ent.maxs_x;
    if (pointcontents(p) != CONTENT_EMPTY)  return FALSE;

    p = spot;
    p_y = spot_y + ent.mins_y;
    if (pointcontents(p) != CONTENT_EMPTY)  return FALSE;

    p_y = spot_y + ent.maxs_y;
    if (pointcontents(p) != CONTENT_EMPTY)  return FALSE;

    p = spot;
    p_z = spot_z + ent.mins_z;
    if (pointcontents(p) != CONTENT_EMPTY)  return FALSE;

    p_z = spot_z + ent.maxs_z;
    if (pointcontents(p) != CONTENT_EMPTY)  return FALSE;

    // Check bbox corners.
    // Order:  1)+++  2)-++  3)+-+  4)--+  5)++-  6)-+-  7)+--  8)---
    p_x = spot_x + ent.maxs_x;
    p_y = spot_y + ent.maxs_y;
    if (pointcontents(p) != CONTENT_EMPTY)  return FALSE;

    p_x = spot_x + ent.mins_x;
    if (pointcontents(p) != CONTENT_EMPTY)  return FALSE;

    p_x = spot_x + ent.maxs_x;
    p_y = spot_y + ent.mins_y;
    if (pointcontents(p) != CONTENT_EMPTY)  return FALSE;

    p_x = spot_x + ent.mins_x;
    if (pointcontents(p) != CONTENT_EMPTY)  return FALSE;

    p_x = spot_x + ent.maxs_x;
    p_y = spot_y + ent.maxs_y;
    p_z = spot_z + ent.mins_z;
    if (pointcontents(p) != CONTENT_EMPTY)  return FALSE;

    p_x = spot_x + ent.mins_x;
    if (pointcontents(p) != CONTENT_EMPTY)  return FALSE;

    p_x = spot_x + ent.maxs_x;
    p_y = spot_y + ent.mins_y;
    if (pointcontents(p) != CONTENT_EMPTY)  return FALSE;

    p_x = spot_x + ent.mins_x;
    if (pointcontents(p) != CONTENT_EMPTY)  return FALSE;

    return TRUE;
};

//----------------------------------------------------/ New Code /--------//
//  This checks if a bbox at a starting point is inside a wall or sky.
//  The bbox's origin and corners are checked.  If any one point is
//  within a solid or sky, TRUE is returned.  Unlike the above check,
//  the actual bbox may touch the wall and pass the check.
//------------------------------------------------------------------------//
float(entity ent, vector spot) PM_EntStartInWall =
{
    local   vector  p;
    local   float   content;

    // Check origin.
    p = spot;
    content = pointcontents(p);
    if (content == CONTENT_SOLID)  return TRUE;
    if (content == CONTENT_SKY)    return TRUE;

    // Get adjusted bounds.
    local   float   x1, x2, y1, y2, z1, z2;

    x1 = ent.mins_x + 0.1;
    x2 = ent.maxs_x - 0.1;
    y1 = ent.mins_y + 0.1;
    y2 = ent.maxs_y - 0.1;
    z1 = ent.mins_z + 0.1;
    z2 = ent.maxs_z - 0.1;

    // Check bbox faces.
    // Order:  1)-00  2)+00  3)0-0  4)0+0  5)00-  6)00+
    p_x = spot_x + x1;
    content = pointcontents(p);
    if (content == CONTENT_SOLID)  return TRUE;
    if (content == CONTENT_SKY)    return TRUE;

    p_x = spot_x + x2;
    content = pointcontents(p);
    if (content == CONTENT_SOLID)  return TRUE;
    if (content == CONTENT_SKY)    return TRUE;

    p = spot;
    p_y = spot_y + y1;
    content = pointcontents(p);
    if (content == CONTENT_SOLID)  return TRUE;
    if (content == CONTENT_SKY)    return TRUE;

    p_y = spot_y + y2;
    content = pointcontents(p);
    if (content == CONTENT_SOLID)  return TRUE;
    if (content == CONTENT_SKY)    return TRUE;

    p = spot;
    p_z = spot_z + z1;
    content = pointcontents(p);
    if (content == CONTENT_SOLID)  return TRUE;
    if (content == CONTENT_SKY)    return TRUE;

    p_z = spot_z + z2;
    content = pointcontents(p);
    if (content == CONTENT_SOLID)  return TRUE;
    if (content == CONTENT_SKY)    return TRUE;

    // Check bbox corners.
    // Order:  1)+++  2)-++  3)+-+  4)--+  5)++-  6)-+-  7)+--  8)---
    p_x = spot_x + x2;
    p_y = spot_y + y2;
    content = pointcontents(p);
    if (content == CONTENT_SOLID)  return TRUE;
    if (content == CONTENT_SKY)    return TRUE;

    p_x = spot_x + x1;
    content = pointcontents(p);
    if (content == CONTENT_SOLID)  return TRUE;
    if (content == CONTENT_SKY)    return TRUE;

    p_x = spot_x + x2;
    p_y = spot_y + y1;
    content = pointcontents(p);
    if (content == CONTENT_SOLID)  return TRUE;
    if (content == CONTENT_SKY)    return TRUE;

    p_x = spot_x + x1;
    content = pointcontents(p);
    if (content == CONTENT_SOLID)  return TRUE;
    if (content == CONTENT_SKY)    return TRUE;

    p_x = spot_x + x2;
    p_y = spot_y + y2;
    p_z = spot_z + z1;
    content = pointcontents(p);
    if (content == CONTENT_SOLID)  return TRUE;
    if (content == CONTENT_SKY)    return TRUE;

    p_x = spot_x + x1;
    content = pointcontents(p);
    if (content == CONTENT_SOLID)  return TRUE;
    if (content == CONTENT_SKY)    return TRUE;

    p_x = spot_x + x2;
    p_y = spot_y + y1;
    content = pointcontents(p);
    if (content == CONTENT_SOLID)  return TRUE;
    if (content == CONTENT_SKY)    return TRUE;

    p_x = spot_x + x1;
    content = pointcontents(p);
    if (content == CONTENT_SOLID)  return TRUE;
    if (content == CONTENT_SKY)    return TRUE;

    return FALSE;
};


//==========================================================================
//  Water Checks

//----------------------------------------------------/ New Code /--------//
//  This checks if an entity's origin is in water.
//------------------------------------------------------------------------//
float(entity ent) PM_EntInWater =
{
    local   float   content;

    content = pointcontents (ent.origin);

    if (content == CONTENT_WATER)
        return TRUE;
    if (content == CONTENT_SLIME)
        return TRUE;
    if (content == CONTENT_LAVA)
        return TRUE;

    // Not in water.
    return FALSE;
};

//----------------------------------------------------/ New Code /--------//
//  This checks if a given point in space is in water.
//------------------------------------------------------------------------//
float(vector vec) PM_VecInWater =
{
    local   float   content;

    content = pointcontents (vec);

    if (content == CONTENT_WATER)
        return TRUE;
    if (content == CONTENT_SLIME)
        return TRUE;
    if (content == CONTENT_LAVA)
        return TRUE;

    // Not in water.
    return FALSE;
};

//----------------------------------------------------/ New Code /--------//
//  This returns the water level of an entity.
//------------------------------------------------------------------------//
float(entity ent) PM_WaterLevel =
{
    local   vector  spot;

    spot = ent.origin;
    spot_z = ent.origin_z + ent.maxs_z - 1;
    if (PM_VecInWater (spot))
        return 3;
    spot_z = ent.origin_z;
    if (PM_VecInWater (spot))
        return 2;
    spot_z = ent.origin_z + ent.mins_z + 1;
    if (PM_VecInWater (spot))
        return 1;
    return 0;
};


//==========================================================================
//  Sight Checks

//----------------------------------------------------/ New Code /--------//
//  This returns the dot product of two vectors.  One vector is the
//  attacker's aim, and the other is the path to the target.
//------------------------------------------------------------------------//
float(entity targ, entity attacker) PM_DotTarget =
{
    if (targ == attacker)
        return 0;

    local   vector  vec;
    local   float   dot;
	
    if (attacker.classname == "player")
        makevectors (attacker.v_angle);
    else
        makevectors (attacker.angles);
    vec = normalize (targ.origin - attacker.origin);
	dot = vec * v_forward;
	
    return dot;
};

//----------------------------------------------------/ New Code /--------//
//  This checks if an entity can be seen by 'eyes'.
//------------------------------------------------------------------------//
float(entity ent, entity eyes, float nocross) PM_EntIsVisible =
{
    local   vector  p1, p2;

    p1 = eyes.origin + eyes.view_ofs;
    p2 = ent.origin + ent.view_ofs;

    traceline (p1, p2, TRUE, eyes);

    if (nocross)
        if (trace_inopen)
            if (trace_inwater)
                return FALSE;   // Path crossed contents.

    return (trace_fraction == 1);
};

//----------------------------------------------------/ New Code /--------//
//  This checkes if the path between two points is clear.
//  Monsters in the way are ignored.
//------------------------------------------------------------------------//
float(vector v1, vector v2, entity ignore) PM_PathClear =
{
    traceline (v1, v2, TRUE, ignore);
    if (trace_fraction < 1)
        return FALSE;

    return TRUE;
};


//==========================================================================
//  Miscellaneous Entity Checks

//----------------------------------------------------/ New Code /--------//
//  This checks if the entity is a creature and not an obstacle of
//  the world.  Barrels are considered creatures in this check.
//------------------------------------------------------------------------//
float(entity ent) PM_IsCreature =
{
    // Viable targets include monsters, players, and barrels.
    if (ent.flags & FL_MONSTER)
        return TRUE;
    if (ent.classname == "player")
        return TRUE;
    if (ent.classname == "misc_explobox")
        return TRUE;
    if (ent.classname == "misc_explobox2")
        return TRUE;

    // Not a target.
    return FALSE;
};

//----------------------------------------------------/ New Code /--------//
//  This checks if the entity is immortal.  If so, TRUE is returned.
//
//  Monsters that die only if they take damage greater than or equal
//  to their health (e.g., zombies) are not considered in this check.
//------------------------------------------------------------------------//
float(entity ent) PM_IsImmortal =
{
    // Entities that are immune to damage are immortal.
    if (!ent.takedamage)
        return TRUE;

    // Those with the 'god' cheat can't die.
    if (ent.flags & FL_GODMODE)
        return TRUE;

    // Those with invulnerability are unstoppable.
    if (ent.items & IT_INVULNERABILITY)
        return TRUE;

    // Entity is vulnerable.
    return FALSE;
};

//----------------------------------------------------/ New Code /--------//
//  This checks if the entity is a projectile.
//------------------------------------------------------------------------//
float(entity ent) PM_IsProjectile =
{
    // NOTE:  For (speed) efficiency reasons, the exception list is
    //   placed in each block, rather than here as one time only.

    // All known projectiles (save lavaballs) use type SOLID_BBOX.
    if (ent.solid == SOLID_BBOX)
    {
        // Exception list:  Monsters, items, and barrels aren't projectiles.
        if (ent.flags & (FL_MONSTER | FL_ITEM))
            return FALSE;
        if (ent.classname == "misc_explobox")
            return FALSE;
        if (ent.classname == "misc_explobox2")
            return FALSE;

        // Put the rain found in many mods on the list too.
        if (ent.classname == "raindrop")
            return FALSE;

        // FIXME:  Mods like Zerstorer have more exceptions such as trees.
        //   Add them here on a case-by-case basis.

        // Not on exception list.  Now check if it really is a projectile.
        if (ent.movetype == MOVETYPE_FLY)
            return TRUE;
        if (ent.movetype == MOVETYPE_FLYMISSILE)
            return TRUE;
        if (ent.movetype == MOVETYPE_BOUNCE)
            return TRUE;
        if (ent.movetype == MOVETYPE_BOUNCEMISSILE)
            return TRUE;
        if (ent.movetype == MOVETYPE_TOSS)
            return TRUE;

        // Not a projectile.
        return FALSE;
    }

    if (ent.solid == SOLID_TRIGGER)
    {
        // Only known 'trigger' projectile is the lavaball.
        if (ent.classname == "fireball")
            return TRUE;

        // Not a projectile.
        return FALSE;
    }

    // Not a projectile.
    return FALSE;
};

//----------------------------------------------------/ New Code /--------//
//  This calculates the damage needed to kill an armored target.
//------------------------------------------------------------------------//
float(entity ent) PM_ArmoredHealth =
{
    if (!ent.armorvalue)
        return ent.health;
    if (!ent.armortype)
        return ent.health;

    // Entity has armor.
    local   float   points;

    points = ent.health + ent.armorvalue;
    if (ent.armortype < 1)
    {
        local   float   maxed;

        maxed = ent.health / (1 - ent.armortype);
        if (points > maxed)
            return maxed;
    }

    return points;
};


//===========================/  END OF FILE  /===========================//
