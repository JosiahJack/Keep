//==========================================================================
//
//  LIGHTNING
//
//==========================================================================

//==========================================================================
//  Static Field

void(entity who, vector spot) StaticFx =
{
    local   float   zap;

    zap = random() * 2;     // For sounds.  Was 3.
    who.effects = who.effects | EF_MUZZLEFLASH;
    if (zap < 1)    // Sound was 'misc/power.wav;.
        sound (who, CHAN_AUTO, "weapons/zap1.wav", 1, ATTN_NORM);
    else
        sound (who, CHAN_AUTO, "weapons/zap2.wav", 1, ATTN_NORM);
    MakeFancy (spot, X32_STAR_BLUE, 5);
};

// Reduce current health of enemies around the inflictor by 25%.
void(entity inflictor, entity attacker, entity ignore, string dtype,
    float radius) StaticField =
{
    local   entity  head;
    local   vector  p1, p2;
    local   float   dflags;

// Damage flags:
// Lightning - Static Field was a lightning skill in Diablo 2.
// Percent   - Remove health by % instead of flat number, like in Diablo 2.
// Note, no armor is a possibility -- could go either way.
    dflags = DF_LIGHTNING | DF_PERCENT;
    p1 = inflictor.origin;
    head = findradius(p1, radius);
    while (head)
    {
        if (head != ignore)
        if (head.takedamage)
        if (head.flags & FLx_CREATURE)  // Don't zap objects.
        if (head.health > 0)
        if (head.solid > SOLID_NOT)     // So DarkPlaces won't gib the fallen.
        if (!Ally_Check (head, attacker))   // Zap only enemies.
        {
            if (CanDamage (head, inflictor))
            {
                p2 = Midpoint (head);
                p2 = p2 - 8*normalize(p2 - p1);

                StaticFx (head, p2);
                T_NewDamage (head, inflictor, attacker, 25, dflags, dtype);
            }
        }
        head = head.chain;
    }
};


//==========================================================================
//  Normal Lightning Bolt

// Creates a discharge effect.
void(entity ent) Discharge =
{
    local   float   damage;

    if (!ent)
        return;
    damage = floor (ent.ammo_cells * 35 / 2);  // Max cells is 200.
    if (damage < 1)
        return;
    Update_Cells (ent, 0);
    ent.currentammo = 0;    // For NPCs.
    if (ent.flags & FL_CLIENT)
        SUB_Think (ent, War_FindBestWeapon);

// FIXME:  In DarkPlaces, clients can set lightning color for themselves.
    Sfx_Discharge ();
    Rocket_Explosion2 (ent.origin, 244, 3);
    MakeFancy (ent.origin, X56_PLASMA_BLUE, 6);
    // PM:  Added rocket damage flag for shamblers' resistance.
    T_NewRadiusDamage (ent, ent, damage, world, DF_LIGHTNING|DF_ROCKET, "discharge");
};

// Spawns the blood caused by hits from lightning bolts.
void(entity targ, vector org, float damage) LightningBlood =
{
    local   float   den;

    den = (damage * (1 - targ.resist_light)) * 4;   // Was 'damage*4'
    den = floor (den);
    if (den > 0)
    {
        local   float   blud;

        if (targ.bloodtype == BLOOD_RED)
            blud = 225;     // Lightning blood.
        else
            blud = targ.bloodtype;
        if (blud > 0)
            particle (org, '0 0 100', blud, den);     // Hit/bleed
        else
            particle (org, '0 0 20', 0 - blud, 10);   // chunks
    }
};

//------------------------------------------------------------------------//
//  This inflicts damage to an entity hit by the lightning bolt.
//------------------------------------------------------------------------//
void(entity targ, entity inflictor, entity attacker, vector org,
    float damage, string dtype) BoltDamage =
{
    LightningBlood (targ, org, damage);
    T_NewDamage (targ, inflictor, attacker, damage, DF_LIGHTNING, dtype);
};

void(entity targ, entity inflictor, entity attacker, vector org,
    float damage, float dflags, string dtype) BoltDamage_Ex =
{
    LightningBlood (targ, org, damage);
    T_NewDamage (targ, inflictor, attacker, damage, DF_LIGHTNING | dflags, dtype);
};

//------------------------------------------------------------------------//
//  This strikes all entities hit by the lightning bolt.
//------------------------------------------------------------------------//
void(vector p1, vector p2, entity attacker, float damage, entity inflictor,
    float fx, string dtype) LightningBolt =
{
// The old lightning code spawned two more invisible beams at weird places
// that could damage and kill more enemies (or teammates).  The new code
// below creates a single piercing bolt that hits everything in its path,
// like the railgun.  Lightning in many games (e.g., D&D, Diablo) pierce.

    local   entity  ruler;
    local   entity  ignore;
    local   entity  targ;
    local   vector  start;
    local   vector  dir;
    local   float   dist;
    local   float   delta;
    local   float   yes;
    local   float   first;

    GhostTouch_On ();

    first =
    yes = TRUE;
    ruler = inflictor;

    dir = p2 - p1;
    delta = vlen(dir);  // Get total length in case of reflection.
    dir = normalize(dir);

    while (ruler)
    {
        ignore = inflictor = ruler;
        ruler = world;      // End loop unless set otherwise by reflection.
        start = p1;

        do
        {
            traceline (p1, p2, FALSE, ignore);
    
            p1 = trace_endpos;
            targ = trace_ent;

            if (targ.solid != SOLID_BSP)
                ignore = targ;
            else
                ignore = world;

            if (targ != inflictor)      // Dirty hack to prevent suicide.
            {
                if (HasReflection (targ, p1, damage))
                {
                    if (yes)
                    {
                        yes = FALSE;
                        ruler = targ;
                        delta = delta - vlen(p1 - start);   // Get remaining dist.
                        dir = normalize(p1 - targ.origin);
                        p2 = p1 + dir*delta;
                    }
                    else    // ...we give up.
                    {   // Use dummy entity to draw reflected bolt.
                        // If there are many, only one is drawn.
                        inflictor = lightning;
                    }
                    ignore = world;     // Stop bolt.
                    ReflectSound (targ);
                }
                else
                {
                    if (first)
                    if (targ.takedamage)
                        BoltDamage (targ, inflictor, attacker, p1, damage, dtype);
                }
            }

        // If current trace hits inflictor/attacker, next trace will miss all.
        // Move the new start point ahead slightly to prevent attacker from
        // hitting himself and preventing the bolt from piercing anymore.
        // (Note:  If attacker is inside the monster because of noclip,
        // he can still hit himself.)
            if (ignore)     // Always world if 'p2 == trace_endpos'.
            {
                dist = vlen(p2 - p1);
                if (dist > 1)
                    p1 = p1 + dir;
                else
                    ignore = world;   // Not enough distance left, so just stop.
            }
        }
        while (ignore);

        // Draw the lightning bolt between the two points.
        Tent_Beam (fx, inflictor, start, p1);
    }

    GhostTouch_Off ();
};
void(vector p1, vector p2, entity attacker, float damage) LightningBolt1 =
    { LightningBolt (p1, p2, attacker, damage, attacker, TE_LIGHTNING1, "lightning"); };
void(vector p1, vector p2, entity attacker, float damage) LightningBolt2 =
    { LightningBolt (p1, p2, attacker, damage, attacker, TE_LIGHTNING2, "lightning"); };

// DISABLED -- Replaced by W_FireThunderbolt below.
//void() W_FireLightning = {};


//==========================================================================
//  Burst Lightning

//
//  The "Burst" is a form of chain lightning cast at a target.  If the
//  target is struck, and there are more targets near the one first struck,
//  secondary bolts will erupt from the primary target and strike as many
//  extra targets as possible.
//
//  This form of chain lightning is based from the description of the
//  Chain Lightning spell in the 3rd edition of Dungeons and Dragons.
//

//------------------------------------------------------------------------//
//  This returns the endpoint where a bolt of chain lightning should
//  strike.  The spot returned is usually the center of the target struck.
//------------------------------------------------------------------------//
vector(entity attacker, entity targ, vector start, vector end)
    ChainLit_Point =
{
    local   vector  spot;

    spot = Midpoint (targ);
    traceline (start, spot, FALSE, attacker);
    if (trace_ent == targ)
    {
        // We can hit the center.  Find the best endpoint of the bolt
        // so that it looks good when drawn.  This point is located
        // between the targer's center and where the bolt hit.

        local   vector  dir;
        local   float   d_impact, d_ideal, dist;

        dir = spot - start;
        d_impact = vlen (spot - trace_endpos);
        d_ideal = vlen (dir);
        dir = normalize (dir);
    // Bolts in beam TEs are drawn in intervals of 30.
        dist = floor (d_ideal / 30) * 30;
        if (dist >= d_impact)
            end = start + dir*dist;
        else
        {
            spot = start + dir*(dist+30);
            if (spot_x >= targ.absmin_x)
              if (spot_x <= targ.absmax_x)
                if (spot_y >= targ.absmin_y)
                  if (spot_y <= targ.absmax_y)
                    if (spot_z >= targ.absmin_z)
                      if (spot_z <= targ.absmax_z)
                        end = spot;
        }
    }

    return end;
};

// Called within 'BurstLit_Chain' below.
float(entity targ, entity inflictor, entity attacker, float damage,
    vector spot, string dtype, float bang)  BurstLit_Trace =
{
    local   vector  end;

    if (targ.flags & FL_CLIENT)
        end = targ.origin;      // Use origin because of TE beam code for clients.
    else
        end = Midpoint (targ);
    //- - - - -
    // Update:  Traceline must hit intended target!
    // Targets can take damage from one bolt once because they
    // can neither stack nor pierce.
    //
    // Note:  Ghost touch code must be called before calling
    // this function if ghosts are to be hit.
    //- - - - -
    traceline (spot, end, FALSE, inflictor);    // 3rd was TRUE.
    if (trace_ent == targ)
    {
        // Draw from source point to target point, except for players.
        // For players, draw from target point to source point
        // because engine always draws from origin in case of player.
        if (targ.flags & FL_CLIENT)
            Tent_Beam (TE_LIGHTNING2, targ, end, spot);
        else
            Tent_Beam (TE_LIGHTNING2, targ, spot, end);
        if (bang == 2)
            sound (inflictor, CHAN_VOICE, "weapons/lstart.wav", 1, ATTN_NORM);
        else if (bang)
            sound (inflictor, CHAN_VOICE, "weapons/lhit.wav", 1, ATTN_NORM);
        end = trace_endpos;     // Use where bolt hit for blood spot.
        BoltDamage (targ, inflictor, attacker, end, damage, dtype);
        return TRUE;
    }
    return FALSE;
};

// Shoots multiple lightning bolts at nearby targets from a common point.
// Used by burst lightning gun.  Also used by plasma discharge.
void(entity inflictor, entity attacker, float damage, entity ignore,
    vector spot, string dtype, vector pak, float bang)  BurstLit_Chain =
{
    local   entity  head, saved;
    local   float   hits;
//    local   vector  end;

    local   float   nff, radius, hi;

    nff = pak_x;
    radius = pak_y;
    hi = pak_z;

    hits = 0;
    saved = world;
    head = findradius (spot, radius);
    while (head)
    {
    // Notarget/stealth won't save you from discharge.
        if (head.takedamage == DAMAGE_AIM)      // Was flags & FLx_CREATURE.
        if (head != attacker)
        if (head != ignore)
        if (head.resist_light < 1)     // Don't waste hits on immune targets.
        if (!HasReflection (head, spot, damage))    // Too much work to bounce here, so pass!
        if (!(nff && Ally_Check (head, attacker)))  // nff = No Friendly Fire.
        {
            // Go to the trouble of zapping live, highly vulnerable targets
            // first instead of dead or resistant targets.
            if (head.deadflag || (head.health <= 0) || (head.resist_light > 0))
            {   // Dead or resistant -- save it for later.
                head.chain2 = saved;
                saved = head;
            }
            else if (BurstLit_Trace (head, inflictor, attacker, damage, spot, dtype, bang))
            {
                hits = hits + 1;
                if (hits >= hi)
                    return;
            }
        }
        head = head.chain;
    }
// Now we zap the saved targets because we ran out of other targets.
    while (saved)
    {
        if (BurstLit_Trace (saved, inflictor, attacker, damage, spot, dtype, bang))
        {
            hits = hits + 1;
            if (hits >= hi)
                return;
        }
        saved = saved.chain2;
    }
};

// Fires a fat bolt of lightning, then splits into three thinner bolts
// after hitting a target.
void(vector p1, vector p2, entity attacker, float damage, float reach)
    BurstLit_Bolt =
{
//- - - - - - - - -
// 'inflictor' = Don't hit this entity during the traceline.
// 'src'       = From whom the lightning gets drawn from.
// 'targ'      = Target by traceline.
//- - - - - - - - -
    local   entity  inflictor, src, targ;
    local   vector  pak;
    local   float   boing;

    pak_x = TRUE;       // Friendly fire off.
    pak_y = reach;
    pak_z = 3;          // Max number of targets.

    inflictor = src = attacker;

    GhostTouch_On ();
//- - - - - - - - -
    while (src)
    {
    // Scan for a hit.
        reach = vlen(p2 - p1);
        traceline (p1, p2, FALSE, inflictor);
// DISABLED -- Auto-aimed bolts that stray too far to the side look bad.
//        if (trace_fraction == 1.0)      // Try again with a fatter trace.
//            traceline (p1, p2, 2, inflictor);
        p2 = trace_endpos;
        targ = trace_ent;

    // Check for reflection.
        boing = FALSE;
        if (targ)
            if (HasReflection (targ, p2, damage))
                boing = TRUE;

    // Draw beam.
        if (targ.takedamage)    // Hit something?  Aim bolt at its center.
            if (!boing)
                p2 = ChainLit_Point (attacker, targ, p1, p2);
        Tent_Beam (TE_LIGHTNING1, src, p1, p2);   // Use the fat beam.
        src = world;    // Unless reflected later, end loop when done.

    // Do hit effects and damage.
        if (boing)
        {
            ReflectSound (targ);
            if (src != lightning)
            {
                reach = reach - vlen(p2 - p1);  // Get remaining dist.
                p1 = p2;
                p2 = p2 + (normalize(p2 - targ.origin) * reach);
                inflictor = targ;
                src = lightning;
            }
        }
        else
        {
            if (targ.takedamage)
            {
                // Direct hit does full damage and splits the beam.
                BoltDamage (targ, inflictor, attacker, p2, damage, "thunderbolt");
                BurstLit_Chain (targ, attacker, damage * 2 / 3, targ, p2, "thunderbolt", pak, FALSE);
            }
        }
    }
//- - - - - - - - -
    GhostTouch_Off ();
};

// Fires either standard lightning or chain lightning.
// Replaces 'W_FireLightning' and custom 'W_FireBurstLight'.
void(float cl) W_FireThunderbolt =
{
    if (self.ammo_cells < 1)
        {War_FindBestWeapon (); return;}

// explode if under water
    if (self.h2olevel > 1)
        {Discharge (self); return;}

    local   vector  org;
    local   float   damage;     // Used as ammo cost first, then as damage.

    if (self.t_width < time)
    {
        sound (self, CHAN_WEAPON, "weapons/lhit.wav", 1, ATTN_NORM);
        self.t_width = time + 0.6;
    }
    self.punchangle_x = -2;

    damage = 2;
    if (self.tome_finished)
        damage = damage + 1;
    if (self.ammo_cells < damage)
        damage = self.ammo_cells;
    Update_Cells (self, self.ammo_cells - damage);
    damage = damage * 15;

// Grrr, when a beam is drawn from a client, it always starts from the
// origin no matter the source point passed.  QuakeC can't fix this
// without causing some other problem sore to the eyes.
    makevectors(self.v_angle);
    org = self.origin + '0 0 16';
// Note:  Changing 1st parm won't make lightning start elsewhere from client.
    if (cl)
        BurstLit_Bolt (self.origin, org + v_forward*600, self, damage, 350);
    else
        LightningBolt (self.origin, org + v_forward*600, self, damage, self, TE_LIGHTNING2, "thunderbolt");
};


//==========================================================================
//  "Storm" Lightning Strike  (a.k.a. Airstrike)

//------------------------------------------------------------------------//
//  This creates a blank entity that will zap targets in the water
//  within a radius for damage.
//
//  Update:  Added fields 'dflags' and 'dtype' for upgraded storms.
//------------------------------------------------------------------------//
void(entity attacker, vector spot, float damage, entity ignore,
    float dflags, string dtype)  Zapper_Spawn =
{
    local   entity  zap;

    zap = spawn();
    zap.movetype  = MOVETYPE_NONE;
    zap.velocity  = '0 0 0';
    zap.touch     = SUB_Null;
    zap.solid     = SOLID_NOT;
    zap.owner     = world;
    setall (zap, "", '0 0 0', '0 0 0', spot);   // invisible

    Rocket_Explosion2 (zap.origin, 244, 3);
    T_NewRadiusDamage (zap, attacker, damage, ignore, DF_LIGHTNING | dflags, dtype);

    remove (zap);
};

//------------------------------------------------------------------------//
//  This creates a lightning bolt that flashes down from the sky and
//  strikes with explosive impact.
//------------------------------------------------------------------------//
void(entity attacker, vector spot, float damage, float dflags, string dtype)
    Thunderstrike_Ex =
{
    local   vector  air, start, end;
    local   entity  targ, ignore;

    air = '0 0 2048';   // Max limit of lightning draw length possible.
    traceline (spot, spot + air, TRUE, world);
    start = trace_endpos - '0 0 2';

    // WARNING:  Using 'world' as last traceline argument does not work.
    //   Trying to do so causes the trace to ignore all, even if the
    //   third argument is FALSE.
    //
    // Create dummy entity to serve as ignore for the traceline.
    // That way, the lightning strike can hit even the attacker.
    local   entity  zap;

    zap = spawn();
    zap.movetype  = MOVETYPE_NONE;
    zap.velocity  = '0 0 0';
    zap.touch     = SUB_Null;
    zap.solid     = SOLID_NOT;
    zap.owner     = world;
    setall (zap, "", '0 0 0', '0 0 0', spot);   // invisible

    // Execute trace.
    GhostTouch_On ();
    traceline (start, spot - air, FALSE, zap);
    targ = trace_ent;
    GhostTouch_Off ();
    // Don't remove zap now, we need it later for thunder effects.

    // Proceed with traceline results.
    if (targ.takedamage)
    {
        // Direct hit.
        end = Midpoint (targ);
        ignore = targ;

        // Trace up from target center to new point in the sky.
        traceline (end, end + air, TRUE, world);
        start = trace_endpos - '0 0 2';

        // Damage the target.
        // NOTE:  Reflection won't save the target from the wrath of god.
        local   float   points;

        points = SUB_RandomDamage (damage);
        BoltDamage_Ex (targ, attacker, attacker, end, points, dflags, dtype);
    }
    else
    {
        end = trace_endpos;
        ignore = world;
    }

    // Create lightning and thunder effects.
    setorigin (zap, end);
    sound (zap, CHAN_AUTO, "hipweap/mjolhit.wav", 1, 0.5);  // It's loud.
    Tent_Beam (TE_LIGHTNING1, zap, end, start);    // Draw big bolt upward.
    remove (zap);   // Dummy served its purpose, now begone.

    if (pointcontents(end) == CONTENT_SKY)
        return;     // Don't explode if it hits sky below.

    // Create explosion on impact.
    Zapper_Spawn (attacker, end, damage, ignore, dflags, dtype);
    ShockWave (end + '0 0 4', 8, 4, "progs/s_wave.spr");
};

void(entity attacker, vector spot, float damage) Thunderstrike =
    {Thunderstrike_Ex (attacker, spot, damage, DF_NONE, "lightning");};


//==========================================================================
//
//  PLASMA
//  (DoE style plasma, used by blue dragon and modified Mjolnir.)
//
//==========================================================================

void() Plasma_Fx =
{
    Sfx_Buzz ();

// FIXME:  Once I build my custom engine, uncomment and fill in the blanks.
//    if (engine)
//    {   // Drake engine, use custom mini-explosion
//    }
//    else
    {
        self.effects = EF_MUZZLEFLASH;
        Particle_Explosion (self.origin, '6 9 2', '10 41 3');
    }

    BecomeFancy (X32_PLASMA_BLUE, 6);
};

// Called by exploding plasma balls.  Also by Mjolnir.
void() Plasma_Discharge =
{
// Reference for DoE plasma discharge stats.
// BurstLit_Chain (self, self.owner, 50, world, self.origin, self.classname, '0 320 5', TRUE);
    local   vector  pak;

    pak_x = self.style;
    pak_y = self.distance;
    pak_z = self.count;     //5;

    GhostTouch_On ();
    BurstLit_Chain (self, self.master, self.dmg*0.5, self.enemy, self.origin, self.classname, pak, TRUE);
    GhostTouch_Off ();
};

void() Plasma_Explode =
{
    if (!self.dmg)
        self.dmg = 100;
    if (!self.distance)
        self.distance = 320;
    if (!self.count)
        self.count = 5;

    if (self.enemy)
    {
        local   float   dmg1, dmg2;

        dmg1 = (0.8 + random()*0.2) * self.dmg;   // Was '80 + random()*20'.
        dmg1 = ResistDamage (self.enemy, dmg1, DF_LIGHTNING | DF_ROCKET);
    // PM:  Add discharge damage to impact damage, then ignore other in
    // the discharge call.  Saves a hit in the discharge for someone else.
        dmg2 = ResistDamage (self.enemy, self.dmg * 0.5, DF_LIGHTNING);
        if (self.style)
            if (Ally_Check (self.enemy, self.master))
                dmg2 = 0;   // Discharge would not hit target.
        T_NewDamage (self.enemy, self, self.master, dmg1 + dmg2, DF_NONE, self.classname);
    }
    // don't do radius damage to the other, because all the damage
    // was done in the impact
    // Note:  Radius damage was 70.
    T_NewRadiusDamage (self, self.master, self.dmg*0.7, self.enemy, DF_LIGHTNING | DF_ROCKET, self.classname);

    sound (self, CHAN_AUTO, "plasma/explode.wav", 1, ATTN_NORM);
    self.origin = self.origin - 8*normalize(self.velocity);
    setorigin (self, self.origin);      // PM:  Do it right.
    Rocket_Explosion2 (self.origin, 244, 3);
    Plasma_Discharge ();
    BecomeFancy (X56_PLASMA_BLUE, 6);
};

void() Plasma_Touch =
{
    if (pointcontents(self.origin) == CONTENT_SKY)
        {remove (self);  return;}
    if (Reflected ())
        return;

    self.enemy = other;
    Plasma_Explode ();
};

void() Plasma_Think =
{
    local   float   pc;

    if (self.delay <= time)
        {remove (self);  return;}
    pc = pointcontents(self.origin);
    if ((pc <= CONTENT_WATER) && (pc >= CONTENT_LAVA))
    {
        if (self.touch == Plasma_Touch)
            Plasma_Explode();
        else
            T_MissileExplode();
        return;
    }

    particle (self.origin, self.velocity * 0.005, 9, self.waitmin);   //2
    particle (self.origin, self.velocity * 0.01, 41, self.waitmax);   //4
    self.nextthink = time + 0.05;

    Ghost_Touch ();
};

void(vector start, vector dir, float sped, float damage, float big)
    Plasma_Launch =
{
    newmis = spawn ();
    newmis.master       = newmis.owner      = self;
    newmis.movetype     = MOVETYPE_FLYMISSILE;
    newmis.solid        = SOLID_BBOX;
    newmis.classname    = "plasma";
// set missile speed
    newmis.movedir      = dir;
    newmis.speed        = sped;
    newmis.velocity     = dir * sped;
    newmis.avelocity    = '300 300 300';
    newmis.angles       = vectoangles(newmis.velocity);
// set missile damage
    newmis.dmg          = damage;
    //effects set below.
    newmis.distance     = damage + 220;     // 320 when dmg == 100.
    newmis.enemy        = world;
    newmis.style        = FALSE;    // TRUE is 'no friendly fire' discharge.
    // Note:  Mjolnir has a range of 350.
// set missile duration
    newmis.touch        = Plasma_Touch;
    newmis.delay        = time + 5;     // Total duration.  As spikes.
    newmis.nextthink    = 0.01;
    newmis.think        = Plasma_Think;
    if (big)
    {   // Big plasma balls from DoE.
        newmis.waitmin      = 2;
        newmis.waitmax      = 4;
        newmis.effects      = EF_DIMLIGHT;  // DoE used EF_BRIGHTLIGHT.
        setall (newmis, "progs/plasma.mdl", '0 0 0', '0 0 0', start);
//        sound (newmis, CHAN_WEAPON, "plasma/flight.wav", 1, ATTN_NORM);
    }
    else
    {   // Mini plasma balls, much like in Quoth.
        newmis.waitmin      =
        newmis.waitmax      = 1;
        newmis.nextthink    = time + 0.1;
        newmis.touch        = T_MissileTouch;
        newmis.think1       = Plasma_Fx;

        newmis.style        = DF_SCAR | DF_LIGHTNING;
        newmis.skin         = 3;
    
        if (self)
        if (self.tracer_time <= time)
        {   self.tracer_time    = time + 0.5;
            newmis.effects      = newmis.effects | EF_DIMLIGHT;
        }
        setall (newmis, "progs/plasma1.mdl", '0 0 0', '0 0 0', start);
    }
};

//================
// W_FirePlasma
//================
void(float big) W_FirePlasma =
{
    if (self.ammo_cells < 1)
        {War_FindBestWeapon (); return;}

// explode if under water
    if (self.h2olevel > 1)
        {Discharge (self); return;}

    local   float   cost, damage, sped;
    local   vector  start, dir;
    local   string  fx;

    if (big)
    {
// FIXME:  If cells too low, shoot normal plasma instead.
// DoE plasma had its own ammo, but we shall use standard cells instead.
// Update 3/30/2010:  Used as BFG 10K substitute, the plasma gun in ToP mode.
        sped = 1250;
        cost = 6;   // Note:  Use 8 or 10 instead if not using Tome of Power.
        if (self.ammo_cells < cost)
            cost = self.ammo_cells;
        damage = cost * 15 + 10;      //damage * 20;
        fx = "weapons/plasma2.wav";
    }
    else
    {
// Note:  Quoth shot 50 damage missiles at a rate of 5/sec.
// Also in Quoth, a direct hit with plasma did the full 50 damage,
// and gibbed zombies on contact.  Here, use a random damage range
// from 5/6ths to full just like rockets.  For zombies, use scar damage.
        sped = 1000;
        cost = 3;
        if (self.ammo_cells < cost)
            cost = self.ammo_cells;
        damage = cost * 15 + 5;   // Add 5 to 45 to get 50.
        fx = "weapons/plasma1.wav";
    }
    Update_Cells (self, self.ammo_cells - cost);
    sound (self, CHAN_WEAPON, fx, 1, ATTN_NORM);
    self.punchangle_x = -2;

    makevectors (self.v_angle);
    start = self.origin + v_forward*8 + '0 0 16';
    dir = aim(self, sped);
    if (!big)
        dir = Aim_Scatter (dir, '1 1 0');
    Plasma_Launch (start, dir, sped, damage, big);
};


//==========================================================================
//  Death Ray

void(vector spot) Make_PlasmaFx =
{
    local   entity  ent;

    ent = spawn();
    setorigin (ent, spot);
    SUB_Think (ent, Plasma_Fx);
};

// Fires a cone of electric death that zaps everyone within 30 degrees of
// the aim vector infront of start point, up to a range defined by radius.
// Attacker is assumed to be self.
void(vector start, vector dir, float damage, float radius, float ang, string dtype)
    DeathRay =
{
    local   entity  attacker, inflictor, head;
    local   vector  end, vec;

//- - - - - - - - -
    // Create dummy entity at spawn point so that 'CanDamage' works right.
    inflictor = spawn();
    setorigin (inflictor, start);
//- - - - - - - - -
    attacker = self;
    head = findradius(start, radius);
    while (head)
    {
        if (head.takedamage)
        if (head != attacker)
        if (head.health > 0)
        if (head.solid > SOLID_NOT)     // So DarkPlaces won't gib the fallen.
        {
            if (CanDamage (head, inflictor))
            {
                end = Midpoint (head);
                vec = normalize(end - start);
                if (dir * vec > ang)
                {
                    end = end - 8*vec;
                    Make_PlasmaFx (end);
                    T_NewDamage (head, attacker, attacker, damage, DF_LIGHTNING | DF_NO_GIB, dtype);
                }
            }
        }
        head = head.chain;
    }
//- - - - - - - - -
    remove (inflictor);
//- - - - - - - - -
};

//================
// W_FireDeathRay
//================
void() W_FireDeathRay =
{
    local   float   cost, damage, reach;
    local   vector  org;

    if (self.ammo_cells < 1)
        {War_FindBestWeapon (); return;}

// explode if under water
    if (self.h2olevel > 1)
        {Discharge (self); return;}

    reach = 600;
    damage = 15;
    cost = 120;     // Was 100.
    cost = ceil(cost / damage);
    if (self.ammo_cells < cost)
        cost = self.ammo_cells;
    Update_Cells (self, self.ammo_cells - cost);
    damage = floor(cost * damage);

    sound (self, CHAN_WEAPON, "weapons/lstart.wav", 1, ATTN_NORM);
    self.punchangle_x = -2;

    makevectors(self.v_angle);
    org = self.origin + '0 0 16';
    DeathRay (org, v_forward, damage, reach, COS30, "deathray");
};


//===========================/  END OF FILE  /===========================//
