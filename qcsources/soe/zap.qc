//==========================================================================
//  zap.qc -- by Patrick Martin                 Last updated:  4-10-2001
//--------------------------------------------------------------------------
//  This file contains code that inflicts the damage caused by a
//  penetrating bolt of lightning.
//==========================================================================


//==========================================================================
//  Zap Checks

//----------------------------------------------------/ New Code /--------//
//  This returns the level of zapping power the entity should suffer.
//------------------------------------------------------------------------//
float(entity ent) PM_ZapLevel =
{
    local   float   zaplevel;

    if (ent.flags & FL_CLIENT)
    {
        if (ent.waterlevel > 0)
            zaplevel = ent.waterlevel;
        else
            zaplevel = PM_WaterLevel (ent);
    }
    else
    {
        zaplevel = PM_WaterLevel (ent);

        // Flying or swimming monsters must be in deep water.
        if (ent.flags & (FL_FLY | FL_SWIM))
            if (zaplevel < 2)
                zaplevel = 0;
    }

    return zaplevel;
};

//----------------------------------------------------/ New Code /--------//
//  This checks if 'ent' is resistant to lightning.  Entities that are
//  resistant return TRUE.  Entities that have no resistance return FALSE.
//------------------------------------------------------------------------//
float(entity ent) PM_ZapResistant =
{
    // Any entity protected by a pentagram or bio-suit is insulated.
    if (ent.items & (IT_INVULNERABILITY | IT_SUIT))
        return TRUE;

    // FIXME:  Should use a flag or field to speed up the checks.
    // The following monster types are resistant to electricity:
    if (ent.classname == "monster_cyberdemon")  return TRUE;
    if (ent.classname == "monster_dragon")
    {
        if (ent.skin == SKIN_BLUE)  return TRUE;
    }

    // The entity is unprotected.
    return FALSE;
};


//==========================================================================
//  Discharge

//----------------------------------------------------/ New Code /--------//
//  This draws the static (lightning) used by the discharge.
//------------------------------------------------------------------------//
void(entity targ, entity zap, vector org) PM_StaticEffects =
{
    // Draw the lightning bolt between the two points.
    WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
    WriteByte (MSG_BROADCAST, TE_LIGHTNING2);
    WriteEntity (MSG_BROADCAST, targ);
    WriteCoord (MSG_BROADCAST, org_x);
    WriteCoord (MSG_BROADCAST, org_y);
    WriteCoord (MSG_BROADCAST, org_z);
    WriteCoord (MSG_BROADCAST, zap.origin_x);
    WriteCoord (MSG_BROADCAST, zap.origin_y);
    WriteCoord (MSG_BROADCAST, zap.origin_z);

    // Sound effects.
    sound (zap, CHAN_AUTO, "weapons/lhit.wav", 1, ATTN_NORM);
};

//----------------------------------------------------/ New Code /--------//
//  This inflicts electrical damage to targets caught in the discharge.
//------------------------------------------------------------------------//
void(entity inflictor, entity attacker, float damage, float radius,
    entity ignore) PM_DischargeDamage =
{
    local   float   radius;     // Speaks for itself.
    local   float   points;     // Damage taken by 'head'.
    local   entity  head;       // Entity affected.
    local   vector  org;        // Middle of 'head'.
    local   float   bolts;      // Max. bolts to display.

    bolts = 0;      // Static effects disabled.
    head = findradius(inflictor.origin, radius);
	
    // Fry everyone caught in the discharge.
	while (head)
    {
        if (head.takedamage)
        {
            if (head != ignore)
            {
                if (CanDamage (head, inflictor))
                {
                    org = head.origin + (head.mins + head.maxs)*0.5;

                    points = vlen(inflictor.origin - org);
                    points = damage - (points * 0.5);

                    if (head == attacker)
                        points = points * 0.5;
                    if (PM_ZapResistant (head))
                        points = points * 0.5;

                    if (points > 0)
                    {
                        if (bolts > 0)
                            if (head != inflictor)
                            {
                                PM_StaticEffects (head, inflictor, org);
                                bolts = bolts - 1;
                            }
                        head.deathtype = "lightning";
                        T_Damage (head, inflictor, attacker, points);
                        if (head.health > 0)
                            head.deathtype = string_null;
                    }
                }
            }
        }
        head = head.chain;
	}
};

//----------------------------------------------------/ New Code /--------//
//  This creates a particle explosion and damages entities within
//  the discharge radius.
//------------------------------------------------------------------------//
void(entity inflictor, entity attacker, float damage, entity ignore)
    PM_ZapDischarge =
{
    // Plasma explosion effects.  Needs Quake v1.08.
    WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
    WriteByte (MSG_BROADCAST, TE_EXPLOSION2);
    WriteCoord (MSG_BROADCAST, inflictor.origin_x);
    WriteCoord (MSG_BROADCAST, inflictor.origin_y);
    WriteCoord (MSG_BROADCAST, inflictor.origin_z);
    WriteByte (MSG_BROADCAST, 244);
    WriteByte (MSG_BROADCAST, 3);

    PM_DischargeDamage (inflictor, attacker, damage, damage+40, ignore);
};

//----------------------------------------------------/ New Code /--------//
//  This creates a blank entity that will zap targets in the water
//  within a radius for damage.
//------------------------------------------------------------------------//
void(entity attacker, vector spot, float damage, entity ignore)
    PM_SpawnDischarge =
{
    local   entity  zap;

    zap = spawn();
    setmodel (zap, "");   // invisible
    setsize (zap, '0 0 0', '0 0 0');
    setorigin (zap, spot);
    zap.movetype  = MOVETYPE_NONE;
    zap.velocity  = '0 0 0';
    zap.touch     = SUB_Null;
    zap.solid     = SOLID_NOT;
    zap.owner     = self;

    PM_ZapDischarge (zap, attacker, damage, ignore);

    remove (zap);
};


//==========================================================================
//  Zap Endpoint Location

//----------------------------------------------------/ New Code /--------//
//  This checks if a line is traced through water, and if so, find
//  the point where it touched water.
//------------------------------------------------------------------------//
vector(vector start, vector end, vector dir) PM_TraceStopAtWater =
{
    if (PM_VecInWater (start))
        return start;

    traceline (start, end, TRUE, world);
    if (trace_inwater)
    {
        local   float   no_cross;
        local   vector  spot;

        no_cross = TRUE;
        spot = start;

        while (no_cross)
        {
            // Do 1 trace per 8 pixels.  Thorough but not very efficient.
            end = spot + dir*8;
            traceline (spot, end, TRUE, world);
            if (trace_inwater)
                no_cross = FALSE;
            else
                spot = end;
        }
    }

    return end;
};

//----------------------------------------------------/ New Code /--------//
//  This returns the real endpoint.
//------------------------------------------------------------------------//
vector(vector start, vector end, float nohitmon, entity ignore, vector dir)
    PM_ZapEndpoint =
{
    // Find the true endpoint.
    traceline (start, end, nohitmon, ignore);
    end = trace_endpos;

    // Make sure the line stops at water.
    end = PM_TraceStopAtWater (start, end, dir);

    return end;
};


//==========================================================================
//  Zap "Rail" Bolt

//----------------------------------------------------/ New Code /--------//
//  This inflicts damage to all entities hit by the lightning bolt.
//------------------------------------------------------------------------//
void(entity attacker, entity targ, vector org, vector damage)
    PM_ZapBoltDamage =
{
    local   float   points;
    local   float   zaplevel;

    // Water no longer boosts damage.
    zaplevel = 1;

////////////////////////////////////////////////
// Disabled code...                           //
//--------------------------------------------//
// Targets in water take up to 4x damage.     //
//    zaplevel = PM_ZapLevel (targ);          //
//    if (zaplevel && PM_IsCreature (targ))   //
//        zaplevel = zaplevel + 1;            //
//    else                                    //
//        zaplevel = 1;                       //
////////////////////////////////////////////////

    // Get damage.
    points = PM_RollDie (damage_x, damage_y);
    points = points * zaplevel * damage_z;
    if (PM_ZapResistant (targ))
        points = points * 0.5;

    // Hit/bleed effect.
    particle (org, '0 0 100', 225, points*4);

    // Hurt the target.
    targ.deathtype = "lightning";
    T_Damage (targ, attacker, attacker, points);
    if (targ.health > 0)
        targ.deathtype = string_null;
};

//----------------------------------------------------/ New Code /--------//
//  This strikes all entities hit by the lightning bolt.
//------------------------------------------------------------------------//
void(entity attacker, vector start, vector end, vector damage)
    PM_ZapBolt =
{
    local   entity  ignore;
    local   entity  targ;
    local   vector  org;

    ignore = attacker;
    org = start;

    // Trace at least once.
    do
    {
        traceline (start, end, FALSE, ignore);

        start = trace_endpos;
        targ = trace_ent;

        if (trace_fraction < 1)
        {
            if (targ.solid == SOLID_BSP)
                ignore = world;
            else
                ignore = targ;

            if (targ.takedamage)
                PM_ZapBoltDamage (attacker, targ, start, damage);
        }
        else
        {
            ignore = world;
        }
    }
    while (ignore);

    // Draw the lightning bolt between the two points.
    WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
    WriteByte (MSG_BROADCAST, TE_LIGHTNING2);
    WriteEntity (MSG_BROADCAST, attacker);
    WriteCoord (MSG_BROADCAST, org_x);
    WriteCoord (MSG_BROADCAST, org_y);
    WriteCoord (MSG_BROADCAST, org_z);
    WriteCoord (MSG_BROADCAST, start_x);
    WriteCoord (MSG_BROADCAST, start_y);
    WriteCoord (MSG_BROADCAST, start_z);
};


//===========================/  END OF FILE  /===========================//
