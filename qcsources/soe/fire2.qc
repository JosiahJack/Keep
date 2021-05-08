//==========================================================================
//  fire2.qc -- by Patrick Martin               Last updated:  5-1-2001
//--------------------------------------------------------------------------
//  This file contains code that produces fire that burns entities.
//
//  Fire inflicts damage to entities near it.  In addition, there is a
//  chance that an affected entity will catch on fire.  If this happens,
//  the fire will burn the target for finite amount of time and inflict
//  more damage.  Fire will be snuffed if the burning entity enters at
//  least waist-deep into any liquid.  Fire can also spread from entity
//  to entity.  However, all frags (and anger) are given only to the
//  entity that originally spawned the fire.
//
//  FILE 2 -- Generic fire-based attacks.
//
//==========================================================================


//==========================================================================
//  Flame Clouds

//----------------------------------------------------/ New Code /--------//
//  This causes part of the flame cloud to rise.  The cloud can
//  rain fire as it rises.
//------------------------------------------------------------------------//
void() PM_CloudBurst =
{
    if (PM_EntInWater (self))
    {
        PM_BecomeSteam (self);
        return;
    }

    if (self.dmg)
        PM_BurnRadius (self, RADIUS_FIRE_SPLASH, self.pos1, self.pos2, 0, FALSE, world);

    if (random() < self.cnt)
        PM_FireDrop (self.flamer, self, self.origin, self.pos1, self.pos2, self.count);

    PM_PlayFireHitSound (self);
    setmodel (self, "progs/s_explod.spr");
    s_explode1 ();
};

//----------------------------------------------------/ New Code /--------//
//  This creates a flaming cloud that can rain fire.
//  Rainchance is expressed as a decimal number.  (e.g., 0.2 = 20%.)
//
//  cloud:   x = quota, y = side, z = depth.
//  timers:  x = base delay, y = extra max delay, z = deadly flag.
//  chance:  x = rain, y = blast, z = UNUSED (MeansOfDeath).
//  vel:     Velocity of flame.
//------------------------------------------------------------------------//
void(entity attacker, vector org, vector cloud, vector timers,
    vector hit_damage, vector burn_damage, vector chance, vector vel)
    PM_FlameCloud =
{
    local   vector  spot;       // Smoke origin.
    local   entity  smoke;      // Smoke entity.
    local   float   check;      // Max. number of attempts.
    local   float   limit;      // Max. number of attempts.
    local   float   tally;      // Number of flames created.
    local   float   trials;     // Number of attempts.

    check = cloud_x * 3;
    limit = check + cloud_x;
    trials = tally = 0;
    while ((trials < limit) && (tally < cloud_x))
    {
        spot_x = org_x + ((random() - 0.5) * cloud_y);
        spot_y = org_y + ((random() - 0.5) * cloud_y);
        spot_z = org_z + ((random() - 0.5) * cloud_z);

        if (trials > check)
        {
            if ((pointcontents(spot) == CONTENT_SOLID) ||
                (pointcontents(spot) == CONTENT_SKY))
            {
                traceline (org, spot, TRUE, world);
                spot = trace_endpos - org;
                spot = trace_endpos - 8*normalize(spot);
            }
        }

        if (pointcontents(spot) != CONTENT_SOLID)
        {
            if (pointcontents(spot) != CONTENT_SKY)
            {
                smoke = spawn ();
                setmodel (smoke, "");
                setsize (smoke, VEC_ORIGIN, VEC_ORIGIN);        
                setorigin (smoke, spot);

                smoke.movetype  = MOVETYPE_FLY;
                smoke.solid     = SOLID_NOT;
                smoke.velocity  = vel;
                smoke.touch     = SUB_Null;

                smoke.flamer    = attacker;
                smoke.owner     = smoke;
                smoke.classname = "fire";
                smoke.netname   = "fire";
                smoke.pos1      = hit_damage;
                smoke.pos2      = burn_damage;
                smoke.dmg       = timers_z; // If non-zero, cloud burns.
                smoke.cnt       = chance_x;
                smoke.count     = chance_y;

                smoke.nextthink = time + timers_x + random() * timers_y;
                smoke.think     = PM_CloudBurst;

                tally = tally + 1;
            }
        }

        trials = trials + 1;
    }
};


//==========================================================================
//  Fireballs

//----------------------------------------------------/ New Code /--------//
//  Flaming projectiles do the damage.
//------------------------------------------------------------------------//
void() PM_FireballTouch =
{
    if (other.solid == SOLID_TRIGGER)
        return; // trigger field, do nothing

    if (PM_EntInWater (self))
    {
        PM_BecomeSteam (self);
        return;
    }
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
        remove(self);
        return;
    }

    // hit something that bleeds
    self.effects = self.effects | EF_MUZZLEFLASH;
    PM_BurnRadius (self, RADIUS_FIRE_SPLASH, self.pos1, self.pos2, X_DELTA, FALSE, other);
    self.origin = self.origin - 8*normalize(self.velocity);
    if (other.takedamage)
        PM_BurnDamage (other, self, 1, self.pos1, self.pos2);
    else if (random() < self.cnt)
        PM_FireDrop (self.flamer, self, self.origin, self.pos1, self.pos2, self.dmg);
    PM_PlayFireHitSound (self);
    BecomeExplosion ();
};

//----------------------------------------------------/ New Code /--------//
//  Create and launch a small fireball.
//------------------------------------------------------------------------//
void(entity attacker, vector org, vector dir, float sped,
    vector hit_damage, vector burn_damage, vector chance, float toss)
    PM_FireFlamer =
{
    local   entity  fire;

    fire = PM_NewFire(attacker, attacker, org);
    fire.movetype           = MOVETYPE_FLYMISSILE;
    fire.solid              = SOLID_BBOX;
    fire.angles             = vectoangles(dir) + '90 0 0';
    fire.velocity           = dir * sped;
    fire.attack_finished    = 0;
    fire.touch              = PM_FireballTouch;
    fire.nextthink          = 0.1;  // ASAP
    fire.think              = PM_CheckFire;
    fire.pausetime          = time + (8000 / sped);
    fire.pos1               = hit_damage;
    fire.pos2               = burn_damage;
    fire.cnt                = chance_x;
    fire.dmg                = chance_y;
    setsize (fire, VEC_ORIGIN, VEC_ORIGIN);

    if (PM_EntInWater (fire))
    {
        PM_BecomeSteam (fire);
        return;
    }

    if (toss)
    {
        fire.movetype           = MOVETYPE_TOSS;
        fire.think              = PM_CheckTossFire;
    }
};

//----------------------------------------------------/ New Code /--------//
//  This spawns a small, fiery explosion instantly.  This is
//  the instant strike version of the above fireball attack.
//  Unlike the projectiles, beams are not stopped by water.
//------------------------------------------------------------------------//
void(entity attacker, vector org, vector dir, vector hit_damage,
    vector burn_damage, vector chance) PM_FireInstantFlamer =
{
    traceline (org, org + dir*8192, FALSE, attacker);

    if (trace_fraction >= 1)
        return;

    local   entity  victim;

    victim = trace_ent;
    org = trace_endpos;

    if (pointcontents(org) == CONTENT_SKY)
        return;

    local   entity  fire;

    fire = PM_NewFire(attacker, attacker, org);

    if (PM_EntInWater (fire))
    {
        PM_BecomeSteam (fire);
        return;
    }

    setmodel (fire, "progs/s_explod.spr");
    setsize (fire, '0 0 0', '0 0 0');        

    fire.movetype  = MOVETYPE_NONE;
    fire.solid     = SOLID_NOT;
    fire.velocity  = '0 0 0';
    fire.touch     = SUB_Null;
    fire.nextthink = 0.1;   // ASAP
    fire.think     = s_explode1;

    fire.effects = fire.effects | EF_MUZZLEFLASH;
    PM_BurnRadius (fire, RADIUS_FIRE_SPLASH, hit_damage, burn_damage, X_DELTA, FALSE, victim);
    fire.origin = fire.origin - 8*normalize(dir);
    if (victim.takedamage)
        PM_BurnDamage (victim, fire, 1, hit_damage, burn_damage);
    else if (random() < chance_x)
        PM_FireDrop (fire.flamer, fire, fire.origin, hit_damage, burn_damage, chance_y);

    PM_PlayFireHitSound (fire);
};


//==========================================================================
//  Flamethrower

//----------------------------------------------------/ New Code /--------//
//  These are like 's_explode*' except the sprite turns into steam
//  if it touches water.  This is used for flaming sprites.
//
//  NOTE:  Use 'owner' of fire instead of 'flamer' for ignoring.
//------------------------------------------------------------------------//
void() s_napalm1 =[ 0, s_napalm2 ]
{   if (PM_EntInWater (self))
        PM_BecomeSteam (self);
};
void() s_napalm2 =[ 1, s_napalm3 ]
{   if (PM_EntInWater (self))
        PM_BecomeSteam (self);
};
void() s_napalm3 =[ 2, s_napalm4 ]
{   if (PM_EntInWater (self))
    {   PM_BecomeSteam (self);  return;  }
    PM_BurnRadius (self, RADIUS_FIRE_SPLASH, self.pos1, self.pos2, 0, FALSE, self.owner);
};
void() s_napalm4 =[ 2, s_napalm5 ]
{   if (PM_EntInWater (self))
    {   PM_BecomeSteam (self);  return;  }
    PM_BurnRadius (self, RADIUS_FIRE_SPLASH, self.pos1, self.pos2, 0, FALSE, self.owner);
};
void() s_napalm5 =[ 3, s_napalm6 ]
{   if (PM_EntInWater (self))
    {   PM_BecomeSteam (self);  return;  }
    PM_BurnRadius (self, RADIUS_FIRE_SPLASH, self.pos1, self.pos2, 0, FALSE, self.owner);
};
void() s_napalm6 =[ 4, SUB_Remove ]
{   if (PM_EntInWater (self))
    {   PM_BecomeSteam (self);  return;  }
    PM_BurnRadius (self, RADIUS_FIRE_SPLASH, self.pos1, self.pos2, 0, FALSE, self.owner);
};

//----------------------------------------------------/ New Code /--------//
//  Flaming projectiles do the damage.
//------------------------------------------------------------------------//
void() PM_FlamethrowerTouch =
{
    if (other.solid == SOLID_TRIGGER)
        return; // trigger field, do nothing

    if (PM_EntInWater (self))
    {
        PM_BecomeSteam (self);
        return;
    }
    if (pointcontents(self.origin) == CONTENT_SKY)
	{
        remove (self);
        return;
    }

    local   vector  neworg;

    PM_BurnRadius (self, RADIUS_FIRE_SPLASH, self.dest1, self.pos2, X_DELTA, FALSE, other);

    neworg = self.origin - 8*normalize(self.velocity);
    setorigin (self, neworg);

    if (other.takedamage)
        PM_BurnDamage (other, self, 1, self.dest1, self.pos2);
    else if (random() < self.cnt)
        PM_FireDrop (self.flamer, self, self.origin, self.dest1, self.pos2, self.dmg);

    self.touch      = SUB_Null;
    self.solid      = SOLID_NOT;
    self.takedamage = DAMAGE_NO;
    self.movetype   = MOVETYPE_NONE;
    self.velocity   = '0 0 0';
};

//----------------------------------------------------/ New Code /--------//
//  This creates a spherical flaming projectile.
//------------------------------------------------------------------------//
void(entity attacker, vector org, vector dir, float sped,
    vector fry_damage, vector hit_damage, vector burn_damage,
    vector chance) PM_FireFlamethrower =
{
    local   entity  fire;

    fire = PM_NewFire(attacker, attacker, org);
    fire.movetype   = MOVETYPE_FLYMISSILE;
    fire.solid      = SOLID_BBOX;
    setmodel (fire, "progs/s_explod.spr");
    fire.frame      = 0;
    fire.velocity   = dir * sped;
    fire.dest1      = hit_damage;
    fire.pos1       = fry_damage;
    fire.pos2       = burn_damage;
    fire.cnt        = chance_x;
    fire.dmg        = chance_y;
    fire.touch      = PM_FlamethrowerTouch;
    fire.nextthink  = 0.1;  // ASAP
    fire.think      = s_napalm1;
    setsize (fire, VEC_ORIGIN, VEC_ORIGIN);        

    if (PM_EntInWater (fire))
    {
        PM_BecomeSteam (fire);
        return;
    }
};


//===========================/  END OF FILE  /===========================//
