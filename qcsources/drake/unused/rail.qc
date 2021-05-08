//==========================================================================
//
//  RAILGUN
//
//==========================================================================

// This inflicts damage to an entity hit by the railgun.
void(entity targ, entity attacker, vector vel, float damage, string dtype)
    Rail_Damage =
{
    local   vector  org, vy, vz;
    local   float   dflags;

    org = trace_endpos - vel*4;
    vy = v_right*crandom();
    vz = v_up*crandom();

    vel = vel + vy + vz;
    vel = normalize(vel);
    vel = vel + 2*trace_plane_normal;
    vel = vel * 200;

// No need to check takedamage since this function should be called only
// if the target could take damage to begin with.  Also, since many
// particles are needed for the trail, halve the particles used for blood.
    SpawnBlood (org, vel*0.2, damage*0.5, targ.bloodtype);

// Yes, shambler takes half damage from the railgun too.
// The slugs are derived from the rockets' warheads.
    dflags = DF_ROCKET;
    if (attacker.tome_finished)
        dflags = dflags | DF_PUSH_NPC;
    T_NewDamage (targ, attacker, attacker, damage, dflags, dtype);
};

// Returns TRUE if the target passed was hit for the first time.
float(entity targ) NewRailTarget =
{
    local   entity  e;

    e = shot_head;  // Start at the beginning of the list.
    while (e)
    {
        if (e == targ)
            return FALSE;   // Already hit before, so don't hit again.
        if (e == e.chain)
            return FALSE;   // Infinite loop, break it.
        e = e.chain;
    }
    return TRUE;    // "Ahhh... fresh meat!" -- The Butcher from Diablo I.
};

// This creates the railgun attack.  'self' is the attacker.
// Update:  Don't bother with reflection, meaning railgun trumps it.
void(vector p1, vector p2, float damage) Rail_Attack =
{
    local   entity  targ;
    local   vector  dir;
    local   float   dist;
    local   float   points;

    targ = self;
    dir = normalize(p2 - p1);

    // Trace at least once.
    do
    {
        traceline (p1, p2, FALSE, targ);

        p1 = trace_endpos;
        targ = trace_ent;

        if (targ)
        {
            if (targ.takedamage)
            {
                if (targ != self)   // Never hit the attacker.
                    if (NewRailTarget (targ))
                {   // Add target to the list, then damage it.  It is safe
                    // to use 'chain' because findradius won't be called.
                    targ.chain = shot_head;
                    shot_head = targ;

                    points = SUB_RandomDamage (damage);
                    Rail_Damage (targ, self, dir, points, "railgun");
                }
            }
            else
            {   // Note:  This should happen only with moving walls.
                if (targ.solid == SOLID_BSP)
                    targ = world;   // Stop the trace here and now.
            }
        }

    // Move the new start point ahead slightly to prevent attacker from
    // hitting himself and preventing the bolt from piercing anymore.
    // (Note:  If attacker is inside the monster because of noclip,
    // he can still hit himself.)
        if (targ)   // Always world if 'p2 == trace_endpos'.
        {
            dist = vlen(p2 - p1);
            if (dist > 1)
                p1 = p1 + dir;
            else
                targ = world;   // Not enough distance left, so just stop.
        }
    }
    while (targ);

// Store endpoint so it can be used later by railgun smoke tracing code.
    if (trace_endpos != p1)
        trace_endpos = p1;
};

//- - - - - - - - -
void(vector start, vector dir, float damage) Rail_Launch =
{
    local   float   cork;
    local   float   dist, width;
    local   vector  vang, side, up;
    local   vector  org, vel;
    local   vector  end;

// Determine the color used by the corkscrew vapor trail.
    if (deathmatch)
    {   // Corkscrew color matches team color in deathmatch
        cork = self.team - 1;
        if ((cork >= 0) && (cork < 14))
        {
            if (cork < 8)
                cork = cork*16 + 9;
            else //if (cork < 14)
                cork = cork*16 + 1;
        }
        else
            cork = 233;     // No team?  Use the fire colors.
    }
    else
        cork = 209;     // Bright deep blue color.

    if (self.tome_finished)
    {   // Shoots a fatter, multicolored beam.
        width = 15;
        cork = parms_pack (249, 241, 0);    // Was '241 cork 0'.
    }
    else
    {
        width = 7;      // Was 15 to emulate flymissile size.
    }
    vang = Vangles (dir);
    makevectors (vang);
    side = v_right * width;
    up = v_up * width;

// Scan for targets to hit.
    shot_head = world;      // Clear railgun linked list.
    Rail_Attack (start, start + dir*4096, damage);  // sets 'trace_endpos'.
    end = trace_endpos;
    dist = vlen(end - start);
    if (dist < 4096)
        Tent_Point (TE_GUNSHOT, end - dir*4);

// Widen the hitscan by tracing more lines around the primary.
// Why not use 'traceline(va, vb, 2, e)'?  The extra size works only on
// monsters, and it sometimes misses monsters if the gun is fired at
// point-blank range.  This will hit everything.
    vel = dir*dist;
//    if (width > 2)
    {   // Trace more lines to emulate flymissile clip bonus.
        org = start + side + up;  Rail_Attack (org, org + vel, damage);
        org = start - side + up;  Rail_Attack (org, org + vel, damage);
        org = start - side - up;  Rail_Attack (org, org + vel, damage);
        org = start + side - up;  Rail_Attack (org, org + vel, damage);
    }

// Draw railgun trail.
    Rail_Trail (start, end, vang, cork);
};

//================
// W_FireRailgun
//================
void() W_FireRailgun =
{
    if (self.ammo_rockets < 1)
        {War_FindBestWeapon (); return;}

    self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;
    sound (self, CHAN_WEAPON, "weapons/rg_fire.wav", 1, ATTN_NORM);
    self.punchangle_x = -8;

    local   vector  org, dir;
    local   float   damage;

    makevectors (self.v_angle);

// DISABLED -- Powered by magnetism and not some explosive charge in
// a round of ammo, I am not sure recoil is a good idea.
//    // Send the attacker backwards a little.
//    self.velocity = self.velocity - (v_forward * 100);

    org = self.origin + v_forward*8 + '0 0 16';     // Centered v_model.
    dir = v_forward;    // Don't use aim because it makes hitting multiple
                        // targets behind the first harder.

    if (self.tome_finished)
        damage = 200;   // ...and shoots faster!
    else
        damage = 150;
    Rail_Launch (org, dir, damage);
};


//===========================/  END OF FILE  /===========================//
