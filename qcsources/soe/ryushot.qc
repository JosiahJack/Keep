//==========================================================================
//  ryushot.qc -- by Patrick Martin             Last updated:  5-5-2001
//--------------------------------------------------------------------------
//  This file contains code that produces the dragons' attacks.
//==========================================================================

// Prototypes in weapons.qc.
vector() wall_velocity;
void(float damage) spawn_touchblood;
void(vector org, vector vel) SpawnMeatSpray;


//==========================================================================
//  Dragon Melee

//----------------------------------------------------/ New Code /--------//
//  The dragon makes a bite attack.
//------------------------------------------------------------------------//
void(vector offset, float reach, vector damage) PM_DragonBite =
{
    local   vector  delta;      // Distance between dragon and target.
	
    delta = self.enemy.origin - self.origin;

    // Check if the bite attack can hit.
    if (vlen(delta) > reach)
        return;
    if (!CanDamage (self.enemy, self))
        return;
    if (self.enemy.health <= 0)
        return;
    if (!self.enemy.takedamage)   // For mega-enforcer.
        return;
		
    // Bite attack is successful.
    local   vector  org;        // Location of dragon's head.
    local   vector  dir;        // Velocity of meat chunk.
    local   float   points;     // Amt. of health the target will lose.
    local   float   r;          // Random number.

    // Set the damage.
    r = random();
    sound (self, CHAN_WEAPON, "demon/dhit2.wav", 1, ATTN_NORM);
    points = random() * damage_x + damage_y;
    if (r < 0.05)
    {
        // Critical hit -- do maximum damage!
        if (self.enemy.classname == "monster_zombie")
        {
            // Zombies are automatically killed by a critical hit.
            if (points < ZOMBIE_HEALTH)
                points = ZOMBIE_HEALTH;
        }
        else
        {
            points = damage_x + damage_y;
        }
    }

    // Inflict the damage.
    self.enemy.deathtype = "dragon";
    T_Damage (self.enemy, self, self, points);
    if (self.enemy.health > 0)
        self.enemy.deathtype = string_null;

    // Throw a piece of meat from the dragon's head (mouth).
    makevectors (self.angles);
    org = self.origin + (v_forward * offset_x) + (v_right * offset_y) +
        (v_up * offset_z);
    dir = (random() * 200 - 100) * v_right + (random() * -50) * v_forward;
    SpawnMeatSpray (org, dir);
};


//==========================================================================
//  Dragon Aiming

//----------------------------------------------------/ New Code /--------//
//  If the dragon is owned by the player, aim where the player is
//  looking at.  If the dragon serves no one, just shoot straight ahead.
//------------------------------------------------------------------------//
vector() PM_AimForward =
{
    local   vector  p1, p2;

    if (self.master.classname == "player")
    {
        // Assume dragon was ordered to shoot.  Aim at player's target.
        makevectors(self.master.v_angle);
        p1 = self.master.origin + '0 0 16';    // level w/ crosshair
        p2 = p1 + v_forward*8192;
        traceline(p1, p2, FALSE, self.master);

        // If target is the pet, trace to endpoint from the pet instead.
        if (trace_ent == self)
            traceline(trace_endpos, p2, FALSE, self);

        return trace_endpos;
    }

    makevectors(self.angles);
    p1 = self.origin - '0 0 16';    // aim a bit downward
    p2 = p1 + v_forward*1024;
    traceline(p1, p2, TRUE, self);
    return trace_endpos;
};

//----------------------------------------------------/ New Code /--------//
//  This returns the spot where a projectile will strike.
//  Dragons will shoot at the spot where the target is currently
//  standing.
//------------------------------------------------------------------------//
vector() PM_GetShotSpot =
{
    // If the dragon has no enemy, aim straight ahead.
    if (!self.enemy)
        return PM_AimForward();

    // Aim at the center of the enemy.
    local   vector  spot;

    spot = self.enemy.origin + ((self.enemy.mins + self.enemy.maxs) * 0.5);
    return spot;
};

//----------------------------------------------------/ New Code /--------//
//  This checks if an entity is falling.  Used by dragons who lead shots.
//------------------------------------------------------------------------//
float(entity ent) PM_IsFalling =
{
    // Not falling if flying, swimming, or already on the ground.
    if (ent.flags & (FL_FLY | FL_SWIM | FL_ONGROUND))
        return FALSE;

    // Flying or etheral targets cannot fall.
    if (ent.movetype == MOVETYPE_FLY)
        return FALSE;
    if (ent.movetype == MOVETYPE_NOCLIP)
        return FALSE;
    if (ent.movetype == MOVETYPE_FLYMISSILE)
        return FALSE;

    // Players need extra checking.
    if (ent.classname == "player")
    {
        if (ent.waterlevel >= 2)
            return FALSE;   // Swimming.
    }

    // Target is falling.
    return TRUE;
};

//----------------------------------------------------/ New Code /--------//
//  This tries to predict where the target will go, then returns that
//  spot, provided that spot isn't blocked by an obstacle.
//
//  NOTE:  This only works on targets that have a velocity value.
//    In Quake, only players have a constantly updated velocity.
//    Monsters do not update their velocity because they move
//    in steps, unless it is jumping or falling (e.g., fiend).
//    Bottom line:  This only works reliably against players.
//------------------------------------------------------------------------//
vector(vector start, vector end, float sped) PM_LeadShot =
{
    // Check if allowed to use leading.
    if (self.state < IQ_GENIUS)
        return end;     // Not smart enough to use leading.

    // Check if it has a target.
    if (self.enemy)
    {
        if (self.enemy.movetype == MOVETYPE_NONE)
            return end;     // Can't move, ignore velocity.

        if (self.enemy.movetype == MOVETYPE_STEP)
            if (self.enemy.flags & (FL_FLY | FL_SWIM | FL_ONGROUND))
                return end;     // Target velocity is not accurate.

        local   float   dist;
        local   float   airtime;
        local   vector  move;
        local   vector  lead;

        dist = vlen(end - start);
        airtime = dist / sped;
        move = self.enemy.velocity;

        if (PM_IsFalling (self.enemy))
        {
            // Target is airborne and affected by gravity.
            local   float   fell;       // Distance from falling.
            local   float   framgrav;   // Gravity per frame.
            local   float   framtime;   // Frametime.
            local   float   loopcount;  // Loop counter
            local   float   looptime;   // Time variable in loop.

            framtime = 0.1;
            framgrav = cvar("sv_gravity");
            framgrav = framgrav * framtime;

            // Calculate falling distance.
            fell = 0;
            loopcount = airtime;
            while (loopcount > 0)
            {
                if (loopcount < framtime)
                    looptime = loopcount;   // Time is less than a frame.
                else
                    looptime = framtime;    // Time equals one frame.

                fell = fell + (looptime * move_z);
                move_z = move_z - framgrav;
                loopcount = loopcount - framtime;
            }

            // Get projected spot.
            lead_x = end_x + (airtime * move_x);
            lead_y = end_y + (airtime * move_y);
            lead_z = end_z + fell;

            // Check if the path to the spot is clear.
            traceline (start, lead, TRUE, self);
            if (trace_fraction < 1)
            {
                if (fell)
                {
                    // Projected spot was blocked.  Check if the spot was
                    // blocked due to the floor or ceiling alone.
                    local   vector  spot;

                    spot   = lead;
                    spot_z = end_z;

                    traceline (spot, lead, TRUE, self);
                    lead = trace_endpos;
                    if (fell > 0)
                        lead_z = lead_z - self.enemy.maxs_z;
                    else
                        lead_z = lead_z + self.enemy.mins_z;
                }
            }
        }
        else
        {
            // Target is not falling.  Vertical movement is constant.
            lead = end + airtime * move;
        }

        // Check if the path to the projected endpoint is clear.
        // NOTE:  This does NOT check if monsters are in the way.
        traceline (start, lead, TRUE, self);
        if (trace_fraction == 1)
            return lead;    // Success.
    }

    // Can't lead, return original target point.
    return end;
};

//----------------------------------------------------/ New Code /--------//
//  This spreads the fire a bit so that the stream appears to be a cone.
//  Currently used by the red and white dragons.
//------------------------------------------------------------------------//
vector(vector start, vector end) PM_RyuRandomSpread =
{
    local   float   dist;

    // (NOTE:  This is not the way I want to do this, but 'makevectors'
    //  does not seem to work right, so this will have to do.)
    dist = vlen(end - start);
    dist = dist / 1000;
    end_x = end_x + ((random() * 40 - 20) * dist);
    end_y = end_y + ((random() * 40 - 20) * dist);
    end_z = end_z + ((random() * 30 - 15) * dist);

    return end;
};

//----------------------------------------------------/ New Code /--------//
//  This alters the aim of the dragon by selecting a point between
//  the current aim point, and the aim point from the last frame.
//  Used to make a smooth stream of shots when more than one shot
//  is fired per frame.  Used by red and white dragons.
//------------------------------------------------------------------------//
vector(vector end) PM_InterAim =
{
    if (self.count > 0)
    {
        self.currentammo = self.currentammo - 1;
        if (self.currentammo)
        {
            local   vector  v1;

            v1 = (self.oldorigin - end) * (self.currentammo / self.count);
            end = end + v1;
        }
        else
        {
            // Final shot, remember spot now for the next frame.
            self.currentammo = self.count = 0;
            self.oldorigin = end;
        }
    }

    return end;
};

//----------------------------------------------------/ New Code /--------//
//  Get the point where the dragon would aim at.
//------------------------------------------------------------------------//
void(float is_pet) PM_SetDragonAim =
{
    // Determine shot speed.
    local   float   level, sped;

    if (is_pet)
        level = pet_level ();       // NOTE:  Function is in 'petai.qc'.
    else
        level = dragon_level ();

    if (level == 1)
        sped = SHOT1_SPEED;
    else if (level == 2)
        sped = SHOT2_SPEED;
    else if (level == 3)
        sped = SHOT3_SPEED;
    else //if (level == 4)
        sped = SHOT4_SPEED;

    // Find aim point.
    self.oldorigin = PM_GetShotSpot();
    self.oldorigin = PM_LeadShot(self.origin, self.oldorigin, sped);
};

//----------------------------------------------------/ New Code /--------//
//  This sets the shot counter for the dragons.  Red and white dragons
//  use it for aiming.  Blue dragons use it for possible discharge.
//------------------------------------------------------------------------//
void(float shots) PM_SetDragonAmmo =
{
    self.currentammo = self.count = shots;
};


//==========================================================================
//  Red Dragon

//----------------------------------------------------/ New Code /--------//
//  This damages entities within a certain radius.  There is also
//  a chance that affected entities will catch on fire.  The only
//  difference between 'PM_BurnRadius' in the Napalm files and this
//  is that the attacker is immune to the damage.
//
//  I did not want to write this, but it was the most expedient way
//  of making the attacker AND another chosen entity immune to the
//  damage.
//------------------------------------------------------------------------//
void(entity fire, float radius, vector hit_damage, vector burn_damage,
    float fade, float no_resist, entity ignore) PM_DragonBurnRadius =
{
    if (radius < 1)
        return;

    local   entity  head;

    head = findradius(fire.origin, radius);

    if (!fade)
    {
        // Easy case -- radius damage is constant.
        while (head)
        {
            if (CanDamage (head, fire))
                if ((!PM_FireResistant (head)) || (no_resist))
                    if (head != ignore)
                        if (head != fire.flamer)
                            PM_BurnDamage (head, fire, 1, hit_damage, burn_damage);

            head = head.chain;
        }
        return;
    }

    // General case -- radius damage decreases linearly from the center.
    local   vector  org;
    local   float   dist;

    while (head)
    {
        if (CanDamage (head, fire))
            if ((!PM_FireResistant (head)) || no_resist)
                if (head != ignore)
                    if (head != fire.flamer)    // Attacker takes no damage.
                    {
                        org = head.origin + (head.mins + head.maxs)*0.5;
                        dist = vlen (fire.origin - org);
                        dist = 1 - (dist * fade / radius);
                        PM_BurnDamage (head, fire, dist, hit_damage, burn_damage);
                    }

        head = head.chain;
    }
};

//----------------------------------------------------/ New Code /--------//
//  This checks if flames should drop (after a fireball impact).
//------------------------------------------------------------------------//
float(entity fire) PM_CheckRyuFireDrop =
{
    if (random() < fire.cnt)
    {
        // Drop flame if it is not inside or directly above the dragon.
        local   entity  ryu;
        local   vector  spot;

        ryu = fire.flamer;
        spot = fire.origin;

        if (spot_x > (ryu.origin_x + ryu.maxs_x + 5))  return TRUE;
        if (spot_y > (ryu.origin_y + ryu.maxs_y + 5))  return TRUE;
        if (spot_x < (ryu.origin_x + ryu.mins_x - 5))  return TRUE;
        if (spot_y < (ryu.origin_y + ryu.mins_y - 5))  return TRUE;
        if (spot_z < (ryu.origin_z + ryu.mins_z - 5))  return TRUE;
    }

    return FALSE;
};

//----------------------------------------------------/ New Code /--------//
//  Flaming projectiles inflict damage and can ignite on contact.
//------------------------------------------------------------------------//
void() PM_DragonFireTouch =
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

    // hit something that bleeds
    self.effects = self.effects | EF_MUZZLEFLASH;
    PM_DragonBurnRadius (self, RADIUS_FIRE_SPLASH, self.pos1, self.pos2, X_DELTA, FALSE, other);
    self.origin = self.origin - 8*normalize(self.velocity);
    if (other.takedamage)
        PM_BurnDamage (other, self, 1, self.pos1, self.pos2);
    else if (PM_CheckRyuFireDrop (self))
        PM_FireDrop (self.flamer, self, self.origin, self.pos1, self.pos2, self.dmg);

    sound (self, CHAN_WEAPON, "dragon/firehit.wav", 1, ATTN_NORM);
    BecomeExplosion ();
};

//----------------------------------------------------/ New Code /--------//
//  This adjusts the speed of the fireball.
//------------------------------------------------------------------------//
void() PM_DragonFireStart =
{
    self.velocity   = self.velocity * self.height;
    self.nextthink  = time + 0.1;
    self.think      = PM_CheckFire;

    PM_CheckFire();
};

//----------------------------------------------------/ New Code /--------//
//  This creates a fireball shot by a red dragon.
//
//  NOTE:  'dec' is used to make the fireball move slower than full speed
//    for one frame.  After one frame, fireball begins moving at full
//    speed.  This is used to give the illusion that the dragon is
//    launching a fireball at a constant rate faster than ten frames
//    per second.
//------------------------------------------------------------------------//
void(vector offset, float sped, vector hit_dmg, float dec) PM_DragonFire =
{
    local   vector  dir;    // Vector from 'start' to 'end'.
    local   vector  start;  // Location of dragon's mouth.
    local   vector  end;    // Place where projectile will strike.

    makevectors(self.angles);

    // Find the location of the dragon's mouth (or head).
    start = self.origin + (v_forward * offset_x) +
          (v_right * offset_y) + (v_up * offset_z);

    // Get the spot where dragon is aiming at.
    end = PM_GetShotSpot ();
    end = PM_LeadShot (start, end, sped);
    end = PM_InterAim (end);

    // If the target is swimming, aim higher.
    if (self.enemy)
        if (self.state > IQ_LOW)
            if (PM_EntInWater (self.enemy))
                end_z = end_z + (self.enemy.maxs_z * 0.5);

    // Spread the fire a bit so that the stream appears to be a cone.
    end = PM_RyuRandomSpread (start, end);

    dir = normalize(end - start);

    // Make the fireball.
    local   entity  fire;   // Flaming missile.

    fire = PM_NewFire(self, self, start);
    fire.movetype           = MOVETYPE_FLYMISSILE;
    fire.solid              = SOLID_BBOX;
    fire.angles             = vectoangles(dir) + '90 0 0';
    fire.velocity           = dir * sped * dec;
    fire.attack_finished    = 0;
    fire.touch              = PM_DragonFireTouch;
    fire.nextthink          = time + 0.1;   // Think changes after a frame.
    fire.think              = PM_DragonFireStart;
    fire.pausetime          = time + (8000 / sped);
    fire.pos1               = hit_dmg;
    fire.pos2               = DMG_ONFIRE;
    fire.cnt                = 0.1;
    fire.dmg                = 0;
    fire.height             = 1 / dec;
    setsize (fire, VEC_ORIGIN, VEC_ORIGIN);

    if (PM_EntInWater (fire))
    {
        PM_BecomeSteam (fire);
        return;
    }
    self.effects = self.effects | EF_MUZZLEFLASH;
};


//==========================================================================
//  White Dragon

//----------------------------------------------------/ New Code /--------//
//  This creates a small particle trail behind the shot.
//------------------------------------------------------------------------//
void(float color, float density, float full) PM_MakeShotTrail =
{
    local   vector  delta;
    local   float   points;
    local   float   dist;
    local   vector  next;
    local   vector  end;

    delta = self.origin - self.dest;
    dist = vlen(delta);

    if (full)
    {
        // Unbroken, continuous trail.  Used by gold dragon.
        points = dist / 24;
        points = ceil(points);
        dist = -24;
    }
    else
    {
        // Sparse, broken trail.  Used by white dragon.
        if (deathmatch || coop)
            points = 2;
        else
            points = 3;
        dist = dist / points;
        dist = 0 - dist;
    }

    delta = normalize(delta);
    next = delta * dist;
    end = self.origin;

    while (points > 0)
    {
        particle (end, delta, color, density);
        end = end + next;
        points = points - 1;
    }

    // Update previous point.
    self.dest = self.origin;
};

//----------------------------------------------------/ New Code /--------//
//  This checks if 'ent' is resistant to ice.  Entities that are
//  resistant return TRUE.  Entities that have no resistance return FALSE.
//------------------------------------------------------------------------//
float(entity ent) PM_IceResistant =
{
    // Any entity protected by a pentagram or bio-suit is insulated.
    if (ent.items & (IT_INVULNERABILITY | IT_SUIT))
        return TRUE;

    // FIXME:  Should use a flag or field to speed up the checks.
    // The following monster types are resistant to ice:
    if (ent.classname == "monster_shambler")    return TRUE;
    if (ent.classname == "monster_cyberdemon")  return TRUE;
    if (ent.classname == "monster_dragon")
    {
        if (ent.skin == SKIN_WHITE)  return TRUE;
    }

    // The entity is unprotected.
    return FALSE;
};

//----------------------------------------------------/ New Code /--------//
//  This spawns frost for ice that impacts the wall.
//------------------------------------------------------------------------//
void(float damage) PM_SpawnTouchIce =
{
    local   vector  vel;

    vel = wall_velocity() * 0.2;
    particle (self.origin + vel*0.01, vel*0.1, 41, damage*2);
};

//----------------------------------------------------/ New Code /--------//
//  Ice shards inflict damage on contact.
//------------------------------------------------------------------------//
void() PM_DragonIceTouch =
{
	if (other == self.owner)
		return;

	if (other.solid == SOLID_TRIGGER)
		return;	// trigger field, do nothing

    local   float   content;

    content = pointcontents(self.origin);
    if (content == CONTENT_SKY)
    {
        remove(self);
		return;
	}
    if (content == CONTENT_LAVA)
    {
        remove(self);
		return;
	}
	
    // hit something that bleeds
	if (other.takedamage)
    {
        if (PM_IceResistant (other))
            self.dmg = self.dmg * 0.5;
        spawn_touchblood (self.dmg);
        other.deathtype = "ice";
        T_Damage (other, self, self.owner, self.dmg);
        if (other.health > 0)
            other.deathtype = string_null;
	}
    else
    {
        PM_SpawnTouchIce (self.dmg);
        sound (self, CHAN_WEAPON, "dragon/icehit.wav", 1, ATTN_NORM);
    }

    remove (self);
};

//----------------------------------------------------/ New Code /--------//
//  This checks the ice shard.  The shard spawns a small trail of frost
//  as it flies through the air.
//------------------------------------------------------------------------//
void() PM_DragonIceThink =
{
    // Spawn a small trail of frost.
    PM_MakeShotTrail (39, 2, FALSE);

    // Ice shard will disappear after a period of time.
    if (self.pausetime < time)
    {
        remove (self);
        return;
    }
    // Ice shards will melt in lava.
    if (pointcontents(self.origin) == CONTENT_LAVA)
    {
        remove (self);
        return;
    }

    // Ice is still active, check again.
    self.nextthink  = time + 0.1;
};

//----------------------------------------------------/ New Code /--------//
//  This adjusts the speed of the ice shard.
//------------------------------------------------------------------------//
void() PM_DragonIceStart =
{
    self.velocity   = self.velocity * self.height;
    self.nextthink  = time + 0.1;
    self.think      = PM_DragonIceThink;

    PM_DragonIceThink ();
};

//----------------------------------------------------/ New Code /--------//
//  This creates an ice shard shot by a white dragon.
//------------------------------------------------------------------------//
void(vector offset, float sped, float damage, float dec) PM_DragonIce =
{
    local   vector  dir;    // Vector from 'start' to enemy origin.
    local   vector  start;  // Location of dragon's mouth.
    local   vector  end;    // Place where projectile will strike.
    local   entity  shard;  // Ice shard missile.

    makevectors(self.angles);

    // Find the location of the dragon's mouth (or head).
    start = self.origin + (v_forward * offset_x) +
        (v_right * offset_y) + (v_up * offset_z);

    // Aim straight at where the target is currently standing,
    // then spread the shot.
    end = PM_GetShotSpot ();
    end = PM_LeadShot (start, end, sped);
    end = PM_InterAim (end);
    end = PM_RyuRandomSpread (start, end);

    dir = normalize (end - start);
	
    // Create the ice shard.
    shard = spawn();
    setmodel (shard, "progs/ice.mdl");
    setsize (shard, '0 0 0', '0 0 0');        
    setorigin (shard, start);
    shard.movetype   = MOVETYPE_FLYMISSILE;
    shard.solid      = SOLID_BBOX;
    shard.owner      = self;
    shard.angles     = vectoangles(dir);
    shard.dmg        = damage;
    shard.touch      = PM_DragonIceTouch;
    shard.nextthink  = time + 0.1;
    shard.think      = PM_DragonIceStart;
    shard.pausetime  = time + (8000 / sped);
    shard.velocity   = dir * sped * dec;
    shard.dest       = start;
    shard.height     = 1 / dec;
};


//==========================================================================
//  Blue Dragon

//----------------------------------------------------/ New Code /--------//
//  This creates a lightning bolt shot by a blue dragon.
//------------------------------------------------------------------------//
void(vector offset, float reach, vector damage) PM_DragonBolt =
{
    local   vector  dir;        // Vector from 'start' to 'end'.
    local   vector  start;      // Location of dragon's mouth.
    local   vector  end;        // Place where lightning will strike.

    if (self.currentammo < 1)
        return;     // Already discharged underwater.

    self.effects = self.effects | EF_MUZZLEFLASH;

    // Check for discharge.  Use dragon as the test, much like a
    // Thunderbolt-wielding player.  Should use 'start' as the source
    // instead, not the attacker.
    if (PM_WaterLevel(self) > 1)
    {
        // Dragon is deep enough in water so discharge.
        local   float   zap_dmg;    // Maximum discharge damage.

        zap_dmg = ((damage_x + damage_y) * damage_z) * 4 * self.currentammo;
        PM_ZapDischarge (self, self, zap_dmg, world);
        self.currentammo = 0;
        return;
    }

    makevectors (self.angles);

    // Find the location of the dragon's mouth (or head).
    start = self.origin + (v_forward * offset_x) +
        (v_right * offset_y) + (v_up * offset_z);

    // Aim straight at the middle of the target.
    end = PM_GetShotSpot();

    // Find the endpoint of the lightning.
    dir = normalize(end - start);
    end = start + (dir * reach);
    traceline (start, end, TRUE, self);
    end = trace_endpos + (dir * 4);

    // Create the bolt of lightning.
    PM_ZapBolt (self, start, end, damage);
    self.currentammo = self.currentammo - 1;
};


//==========================================================================
//  Gold Dragon

//----------------------------------------------------/ New Code /--------//
//  The fireball explodes then creates a small cloud of fire.
//------------------------------------------------------------------------//
void(entity targ) PM_BlastExplode =
{
    local   vector  damage;
    local   float   radius;
    local   float   fade;

    // Set radius damage first.
    damage_x = 0;           // No random damage.
    damage_y = self.dmg;    // Damage is constant.
    damage_z = 0.5;         // 50% chance max of burning.

    radius = self.dmg + 40;
    fade = PM_DistanceFactor (radius, 0.5, self.dmg);

    // Do splash damage first then explode.
    PM_DragonBurnRadius (self, radius, damage, self.pos2, fade, TRUE, targ);
    self.origin = self.origin - 8*normalize(self.velocity);

    WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
    WriteByte (MSG_BROADCAST, TE_EXPLOSION);
    WriteCoord (MSG_BROADCAST, self.origin_x);
    WriteCoord (MSG_BROADCAST, self.origin_y);
    WriteCoord (MSG_BROADCAST, self.origin_z);

    if (targ.takedamage)
    {
        // Someone took a direct hit.
        if (targ.classname == "monster_zombie")
        {
            // Kill zombies outright.
            damage_x = 0;
            damage_y = ZOMBIE_HEALTH + 50;
        }
        else if (self.dmg < 20)
        {
            damage_x = self.dmg;
            damage_y = 0;
        }
        else
        {
            damage_x = 20;
            damage_y = self.dmg - damage_x;
        }
        damage_z = 1;           // Ignite on contact.

        PM_BurnDamage (targ, self, 1, damage, self.pos2);
    }
    else if (PM_CheckRyuFireDrop (self))
    {
        PM_FireDrop (self.flamer, self, self.origin, self.pos1, self.pos2, 0);
    }

    // Explode in a cloud of fire.
    fade = self.dmg * 0.05;
    fade = ceil(fade);
    if (fade > 6)
        fade = 6;
    if (fade > 1)
    {
        local   vector  cloud;

        cloud_x = fade;
        cloud_y = cloud_z = fade * 20;
        PM_FlameCloud (self.flamer, self.origin, cloud, '0 0.2 0', self.pos1, self.pos2, '0 0 0', '0 0 50');
    }

    BecomeExplosion ();
};

//----------------------------------------------------/ New Code /--------//
//  The large fireball explodes on contact and inflicts severe damage
//  within a radius.
//------------------------------------------------------------------------//
void() PM_BlastTouch =
{
    if (other.solid == SOLID_TRIGGER)
        return; // trigger field, do nothing

    // Destroy fireball if it has no power or if it touches the sky.
    if (self.dmg <= 0)
    {
        PM_BecomeSteam (self);
        return;
    }
    if (pointcontents(self.origin) == CONTENT_SKY)
    {
        remove (self);
        return;
    }

    // Do the damage.
    PM_BlastExplode (other);
};

//----------------------------------------------------/ New Code /--------//
//  This checks the big fireball.  It loses strength if it travels
//  through water.  While active, the fireball leaves behind a trail
//  of steam or embers.
//------------------------------------------------------------------------//
void() PM_BlastThink =
{
    local   float   color;
    local   float   density;

    // Default trail is steam.
    color = 6;
    density = 16;

    if (PM_EntInWater (self))
    {
        // Fireball loses strength in water.
        self.dmg = self.dmg - 5;
    }
    else if (!PM_VecInWater (self.dest))
    {
        // Fireball has not been in water lately, so make an ember trail.
        color = 233;
        density = 8;
    }

    PM_MakeShotTrail (color, density, TRUE);

    // Fizzle if it lost all power.
    if (self.dmg <= 0)
    {
        PM_BecomeSteam (self);
        return;
    }

    // The fireball will explode after a period of time.
    if (self.pausetime < time)
    {
        PM_BlastExplode (world);
        return;
    }

    // Fire is still burning, check again.
    self.nextthink  = time + 0.1;
};

//----------------------------------------------------/ New Code /--------//
//  This creates a highly explosive fireball shot by a gold dragon.
//------------------------------------------------------------------------//
void(vector offset, float damage, float sped, vector hit_damage)
    PM_DragonBlast =
{
    local   vector  dir;    // Vector from 'start' to enemy origin.
    local   vector  start;  // Location of dragon's mouth.
    local   vector  end;    // Place where projectile will strike.

    makevectors(self.angles);

    // Find the location of the dragon's mouth (or head).
    start = self.origin + (v_forward * offset_x) + (v_right * offset_y) +
        (v_up * offset_z);

    // Aim straight at the spot.
    end = PM_GetShotSpot ();

    // Lead shots some of the time to keep the target guessing.
    if (random() < 0.5)
        end = PM_LeadShot (start, end, sped);

    // If target is in water and not the dragon, aim at the head.
    if (self.enemy)
        if (self.state > IQ_LOW)
            if (PM_EntInWater (self.enemy))
                if (!PM_EntInWater (self))
                    end_z = end_z + (self.enemy.maxs_z * 0.5);

    dir = normalize(end - start);
	
    // Make the fireball.
    local   entity  fire;

    fire = PM_NewFire(self, self, start);
    fire.movetype           = MOVETYPE_FLYMISSILE;
    fire.solid              = SOLID_BBOX;
    fire.frame              = 1;
    fire.effects            = fire.effects | EF_DIMLIGHT;
    fire.angles             = vectoangles(dir) + '90 0 0';
    fire.velocity           = dir * sped;
    fire.attack_finished    = time + 0.1;
    fire.touch              = PM_BlastTouch;
    fire.nextthink          = 0.1;      // ASAP
    fire.think              = PM_BlastThink;
    fire.pausetime          = time + (8000 / sped);
    fire.pos1               = hit_damage;
    fire.pos2               = DMG_ONFIRE;
    fire.cnt                = 0.3;      // For fire drop test, like red.
    fire.dmg                = damage;
    fire.dest               = start;
    setsize (fire, VEC_ORIGIN, VEC_ORIGIN);

    self.effects = self.effects | EF_MUZZLEFLASH;
};


//===========================/  END OF FILE  /===========================//
