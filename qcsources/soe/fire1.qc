//==========================================================================
//  fire1.qc -- by Patrick Martin               Last updated:  5-1-2001
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
//  FILE 1 -- The Core Burn Code.
//
//==========================================================================


//==========================================================================
//  General Fire Code

//----------------------------------------------------/ New Code /--------//
//  This precaches the fire-related files used by the fire code.
//------------------------------------------------------------------------//
void() PM_PrecacheFire =
{
    precache_model ("progs/flame2.mdl");

    precache_sound ("hknight/hit.wav");
};

//----------------------------------------------------/ New Code /--------//
//  This extinguishes the fire burning on a player (or other entity).
//  This function should be called whenever the fire burning on an
//  entity must be removed immediately.
//
//  Examples who and when this should be called for:
//  * All players (and their surrogates) when the level ends.
//  * Anytime a player respawns after dying (from the 'kill' command).
//  * Anyone who receives super-healing.
//------------------------------------------------------------------------//
void(entity ent) PM_KillFire =
{
    // This will cause the fire to burn itself out ASAP.
    ent.burnout = 0;

    // Check if the entity is linked to a burning flame.
    if (ent.burner)
    {
        // Unlink and remove the burning flame.
        ent.burner.nextthink    = 0.1;  // ASAP
        ent.burner.think        = BecomeExplosion;
        ent.burner              = world;
    }
};


//==========================================================================
//  Custom Explosions

//----------------------------------------------------/ New Code /--------//
//  This makes some smoke.
//------------------------------------------------------------------------//
void(entity fire) PM_MakeSmoke =
{
    particle (fire.origin, '0 0 100', 6, 50);
};

//----------------------------------------------------/ New Code /--------//
//  This turns the fire into smoke.
//------------------------------------------------------------------------//
void(entity fire) PM_BecomeSmoke =
{
    PM_MakeSmoke (fire);
    remove (fire);
};

//----------------------------------------------------/ New Code /--------//
//  This turns the fire into steam.
//------------------------------------------------------------------------//
void(entity fire) PM_BecomeSteam =
{
    sound (fire, CHAN_AUTO, "player/slimbrn2.wav", 1, ATTN_NORM);
    PM_BecomeSmoke (fire);
};

//----------------------------------------------------/ New Code /--------//
//  This plays a sound when fire impacts.
//------------------------------------------------------------------------//
void(entity fire) PM_PlayFireHitSound =
{
    sound (fire, CHAN_AUTO, "hknight/hit.wav", 1, ATTN_NORM);
};

//----------------------------------------------------/ New Code /--------//
//  The creates an explosion entity.
//------------------------------------------------------------------------//
void(vector spot) PM_MakeExplosion =
{
    local   entity  blank;

    blank = spawn();
    setmodel (blank, "progs/s_explod.spr");
    setsize (blank, '0 0 0', '0 0 0');        
    setorigin (blank, spot);

    blank.movetype  = MOVETYPE_NONE;
    blank.solid     = SOLID_NOT;
    blank.velocity  = '0 0 0';
    blank.touch     = SUB_Null;
    blank.nextthink = 0.1;  // ASAP
    blank.think     = s_explode1;
};

//----------------------------------------------------/ New Code /--------//
//  This spawns and returns a brand new flame.
//------------------------------------------------------------------------//
entity(entity attacker, entity victim, vector spot) PM_NewFire =
{
    local   entity  fire;

    fire = spawn();
    setmodel (fire, "progs/flame2.mdl");
    setsize (fire, '0 0 0', '0 0 0');
    setorigin (fire, spot);

    fire.solid              = SOLID_NOT;
    fire.takedamage         = DAMAGE_NO;
    fire.frame              = 0;
    fire.flamer             = attacker;
    fire.owner              = victim;
    fire.classname          = "fire";
    fire.netname            = "fire";
    fire.attack_finished    = time;

    return fire;
};


//==========================================================================
//  Queries

//----------------------------------------------------/ New Code /--------//
//  This checks if 'ent' is on fire and burning.
//------------------------------------------------------------------------//
float(entity ent) PM_IsBurning =
{
    return (ent.burnout > 0);
};

//----------------------------------------------------/ New Code /--------//
//  This checks if 'ent' is fire resistant.  Entities that are
//  resistant to fire return TRUE.  Entities that have no resistance
//  to fire return FALSE.
//
//  Fire resistant entities have the following benefits:
//  1) They can ignore some or all damage from fire-based attacks.
//  2) They can never be set on fire.
//------------------------------------------------------------------------//
float(entity ent) PM_FireResistant =
{
    //-----/ Inflammable entities /-----//
    // Any entity that is impervious to damage is inflammable.
    if (!ent.takedamage)
        return TRUE;

    // Burn only solid targets.
    if (ent.solid != SOLID_SLIDEBOX)
        if (ent.solid != SOLID_BBOX)
            return TRUE;

    // Make sure target is a creature or barrel and not some solid trigger.
    if (!PM_IsCreature (ent))
        return TRUE;
    //----------------------------------//

    // Any entity protected by a pentagram or bio-suit cannot burn.
    if (ent.items & (IT_INVULNERABILITY | IT_SUIT))
        return TRUE;

    // FIXME:  Should use a flag or field to speed up the checks.
    // The following monster types are fire resistant:
    if (ent.classname == "monster_shambler")    return TRUE;
    if (ent.classname == "monster_oldone")      return TRUE;
    if (ent.classname == "monster_cyberdemon")  return TRUE;
    if (ent.classname == "monster_dragon")
    {
        if (ent.skin == SKIN_RED)   return TRUE;
        if (ent.skin == SKIN_GOLD)  return TRUE;
    }

    // The entity is flammable and can be set on fire.
    return FALSE;
};


//==========================================================================
//  Fire Damage

//----------------------------------------------------/ New Code /--------//
//  This inflicts damage to a single entity.
//------------------------------------------------------------------------//
void(entity victim, entity fire, float damage) PM_NapalmDamage =
{
    victim.deathtype = "fire";
    T_Damage (victim, fire, fire.flamer, damage);

    if (victim.health > 0)
        victim.deathtype = string_null;
};

//----------------------------------------------------/ New Code /--------//
//  This damages a single entity and possibly sets it on fire.
//
//  NOTES:  hit_damage:   x = die, y = base, z = chance of burning.
//          burn_damage:  x = die, y = base, z = max. burn damage.
//          Points = 1d(die) + base.  (This is D&D notation)
//          Chance is expressed as a decimal number.  (e.g., 0.2 = 20%.)
//------------------------------------------------------------------------//
void(entity victim, entity fire, float multiplier, vector hit_damage,
    vector burn_damage) PM_BurnDamage =
{
    local   float   points;

    points = PM_RollDie (hit_damage_x, hit_damage_y);
    points = points * multiplier;
    points = ceil (points);

    if (PM_FireResistant (victim))
    {
        // Fire resistant entities take half damage and cannot ignite.
        points = points * 0.5;
        points = floor (points);
    }
    else
    {
        // Check if entity will catch on fire.
        if (random() < (hit_damage_z * multiplier))
            PM_Ignite (victim, fire.flamer, burn_damage);
    }

    if (points > 0)
        PM_NapalmDamage (victim, fire, points);
};

//----------------------------------------------------/ New Code /--------//
//  This damages entities within a certain radius.  There is
//  also a chance that affected entities will catch on fire.
//------------------------------------------------------------------------//
void(entity fire, float radius, vector hit_damage, vector burn_damage,
    float fade, float no_resist, entity ignore) PM_BurnRadius =
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
                    {
                        if (head == fire.flamer)
                            PM_BurnDamage (head, fire, 0.5, hit_damage, burn_damage);
                        else
                            PM_BurnDamage (head, fire, 1, hit_damage, burn_damage);
                    }

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
                {
                    org = head.origin + (head.mins + head.maxs)*0.5;
                    dist = vlen (fire.origin - org);
                    dist = 1 - (dist * fade / radius);
                    if (head == fire.flamer)
                        dist = dist * 0.5;  // Attacker takes 1/2 damage.
                    PM_BurnDamage (head, fire, dist, hit_damage, burn_damage);
                }

        head = head.chain;
    }
};

//----------------------------------------------------/ New Code /--------//
//  This tries to set all entities within a certain radius on fire.
//------------------------------------------------------------------------//
void(entity fire, float radius, float chance, vector burn_damage,
    entity ignore) PM_IgniteRadius =
{
    if (radius < 1)
        return;

    local   entity  head;

    head = findradius(fire.origin, radius);

    while (head)
    {
        if (random() < chance)
            if (CanDamage (head, fire))
                if (head != ignore)
                    PM_Ignite (head, fire.flamer, burn_damage);

        head = head.chain;
    }
};

//----------------------------------------------------/ New Code /--------//
//  This returns the multiplier used to modify distance.
//  Used by attacks with burn radius damage.
//------------------------------------------------------------------------//
float(float radius, float factor, float damage) PM_DistanceFactor =
{
    // Avoid division by zero.
    if (damage < 1)
        return 0;

    // Get the distance modifier.
    local   float   fade;

    fade = radius * factor / damage;
    if (fade < 0)
        fade = 0;
    return fade;
};


//==========================================================================
//  Dripping Flames

//----------------------------------------------------/ New Code /--------//
//  This checks when to put out the fire.  The fire is put out when
//  the burning entity finds water or when the fire is done burning.
//  This is called on every frame.  Also, the fire can (but need not)
//  damage and ignite nearby targets.
//------------------------------------------------------------------------//
void() PM_CheckFire =
{
    // Put out the fire if it hits water.
    if (PM_EntInWater (self))
    {
        PM_BecomeSteam (self);
        return;
    }

    // The fire burns itself out after a period of time.
    if (self.pausetime < time)
    {
        if (self.effects & EF_DIMLIGHT)
            BecomeExplosion ();
        else
            PM_BecomeSmoke (self);
        return;
    }

    // The fire can inflict a minimal amount of burn damage.
    if (self.attack_finished)
    {
        if (self.attack_finished < time)
        {
            PM_BurnRadius (self, RADIUS_SMALL_BURN, '0 1 0.05', self.pos2, 0, FALSE, world);
            self.attack_finished = time + random();
        }
    }

    // Fire is still burning, check again.
    self.nextthink  = time + 0.1;
};

//----------------------------------------------------/ New Code /--------//
//  This adjusts the flame's angles as it flies through the air,
//  then it checks the flame normally.
//------------------------------------------------------------------------//
void() PM_CheckTossFire =
{
    local   vector  dir;

    dir = normalize (self.velocity);
    self.angles = vectoangles(dir) + '90 0 0';
    PM_CheckFire ();
};

//----------------------------------------------------/ New Code /--------//
//  Fire that drops onto an entity will set it on fire (if possible)
//  and explode to damage and possibly ignite nearby targets.
//------------------------------------------------------------------------//
void() PM_FireDropTouch =
{
    local   float   damage;

    if (other == self.owner)
        return;

    // If the flame is in water, dissolve into steam.
    if (PM_EntInWater (self))
    {
        PM_BecomeSteam (self);
        return;
    }

    // If it is in the sky, disappear.
	if (pointcontents(self.origin) == CONTENT_SKY)
    {
        remove (self);
        return;
	}

    // Explode and ignite.
    if ((other.solid != SOLID_BSP) || (random() < self.cnt))
    {
        if (other.takedamage)
            PM_BurnDamage (other, self, 1, self.pos1, self.pos2);
        PM_BurnRadius (self, RADIUS_FIRE_SPLASH, self.pos1, self.pos2, X_DELTA, FALSE, other);
        self.effects = self.effects | EF_MUZZLEFLASH;
        PM_PlayFireHitSound (self);
        BecomeExplosion ();
        return;
    }

    // The fire remains burning.
    self.velocity = '0 0 0';
    self.solid    = SOLID_NOT;
    setsize (self, '-4 -4 -12', '4 4 16');
    setorigin (self, self.origin + '0 0 12');
};

//----------------------------------------------------/ New Code /--------//
//  Flames fall and become smaller.
//------------------------------------------------------------------------//
void(entity attacker, entity victim, vector spot, vector hit_damage,
    vector burn_damage, float chance) PM_FireDrop =
{
    local   entity  fire;

    fire = PM_NewFire(attacker, victim, spot);

    fire.attack_finished   = time;

    fire.movetype   = MOVETYPE_TOSS;
    fire.solid      = SOLID_BBOX;
    fire.takedamage = DAMAGE_NO;

    setmodel (fire, "progs/flame2.mdl");
    setsize (fire, '0 0 0', '0 0 0');

    fire.frame      = 0;
    fire.classname  = "fire";
    fire.netname    = "fire";
    fire.angles     = '0 0 0';
    fire.velocity   = '0 0 0';
    fire.touch      = PM_FireDropTouch;
    fire.cnt        = chance;       // Chance fire explodes on contact.
    fire.pausetime  = random() * 3 + 2 + time;

    fire.pos1       = hit_damage;
    fire.pos2       = burn_damage;

    fire.nextthink  = 0.1;  // ASAP
    fire.think      = PM_CheckFire;
};


//==========================================================================
//  Burn Control

//----------------------------------------------------/ New Code /--------//
//  This returns the best location on the entity for where the fire
//  should burn.
//------------------------------------------------------------------------//
vector(entity ent) PM_FireSpot =
{
    local   vector  spot;

    // Get the entity's forward direction.
    makevectors (ent.angles);

    // Put the flame at the best spot on an entity.
    spot = ent.origin + (v_forward * 4);

    // FIXME:  If shambler or cyberdemon were flammable, put flame
    //         ahead/higher by xy+16/z+32.
    // Some monsters need the flame placed elsewhere so that it looks right.
    if (ent.classname == "monster_wizard")
        spot_z  = spot_z + 24;
    else if (ent.classname == "monster_zombie")
        spot_z  = spot_z - 5;   // NOTE:  Flame can disappear underwater.
    else if (ent.classname == "monster_spider")
        return spot;    // For 'Willy' the spider.
    else
        spot_z  = spot_z + 16;

    return spot;
};

//----------------------------------------------------/ New Code /--------//
//  This checks if the fire burning on an entity should die.
//------------------------------------------------------------------------//
float() PM_FlameOut =
{
    // Fall off the entity if it is dead.
    if (self.owner.health < 1)
    {
        PM_FireDrop (self.flamer, self.owner, self.origin, self.pos1, self.pos2, 0);
        self.owner.burnout  = 0;
        self.owner.burner   = world;
        BecomeExplosion ();
        return TRUE;
    }

    // The fire burns itself out it reaches its damage limit.
    if (self.owner.burnout <= 0)
    {
        self.owner.burnout  = 0;
        self.owner.burner   = world;
        BecomeExplosion ();
        return TRUE;
    }

    // Donning invulnerability or bio-suit puts out the fire immediately.
    if (self.owner.items & (IT_INVULNERABILITY | IT_SUIT))
    {
        self.owner.burnout  = 0;
        self.owner.burner   = world;
        BecomeExplosion ();
        return TRUE;
    }

    // If entity becomes immune to damage (e.g., mega-enforcer),
    // snuff the fire.
    //
    // NOTE:  If a cutscene activates, the player becomes a camera,
    //        and immune to damage, so the flame will disappear.
    //        We don't want flames burning the camera so this is good.
    //        In short, the player who was burning gets a lucky break.
    if (!self.owner.takedamage)
    {
        self.owner.burnout  = 0;
        self.owner.burner   = world;
        BecomeExplosion ();
        return TRUE;
    }

    // Check if the victim found some water.
    local   entity  head;

    head = self.owner;
    if (self.origin_z < head.origin_z)
        head = self;    // Flame is lower so check it instead.

    if (PM_EntInWater (head))
    {
        self.owner.burnout  = 0;
        self.owner.burner   = world;
        PM_BecomeSteam (self);
        return TRUE;
    }

    // Let the fire burn.
    return FALSE;
};

//----------------------------------------------------/ New Code /--------//
//  This keeps the fire on an entity burning.
//------------------------------------------------------------------------//
void() PM_Burn =
{
    // Check if fire should be snuffed.
    if (PM_FlameOut ())
        return;

    // Burn 'em all!
    local   vector  spot;       // Spot on entity where fire will burn.

    spot = PM_FireSpot(self.owner);     // Find the best spot on target.
    setorigin (self, spot);             // Keep the fire on target.

    if (self.attack_finished < time)
    {
        local   float   damage;

        damage = PM_RollDie (self.pos1_x, self.pos1_y);
        if (self.owner.burnout < damage)
            damage = self.owner.burnout;

        if (self.owner.classname == "monster_zombie")
        {
            // Burning zombies can be destroyed outright by the fire.
            if (random() < (damage / ZOMBIE_HEALTH))
                damage = ZOMBIE_HEALTH;
        }

        // Spread the fire and do the damage!
        PM_BurnRadius (self, RADIUS_LARGE_BURN, self.pos1, self.pos2, 0, FALSE, self.owner);
        PM_NapalmDamage (self.owner, self, damage);

        // Update the burn damage limit.
        self.owner.burnout = self.owner.burnout - damage;
        if (self.owner.burnout < 0)
            self.owner.burnout = 0;     // Limit reached -- put out fire!

        // The fire can burn again after a moment.
        self.attack_finished = time + 1;
        self.pain_finished   = time + 0.5;
    }
    else if (self.pain_finished < time)
    {
        // No damage, but try to set nearby entities on fire.
        PM_IgniteRadius (self, RADIUS_LARGE_BURN, self.pos1_z, self.pos2, self.owner);
        self.pain_finished   = self.attack_finished;
    }

    self.nextthink  = time + 0.1;
};

//----------------------------------------------------/ New Code /--------//
//  This sets the victim on fire.
//------------------------------------------------------------------------//
void(entity victim, entity attacker, vector burn_damage) PM_Ignite =
{
    // An entity that resists fire cannot be set on fire.
    if (PM_FireResistant (victim))
        return;

    // Set radius damage.
    local   vector  hit_damage;

    hit_damage_x = burn_damage_x;
    hit_damage_y = burn_damage_y;
    hit_damage_z = 0.5;     // 50% chance of igniting within burn radius.

    // Check if the entity is linked to a burning flame.
    if (victim.burner)
    {
        if (victim.burner.flamer == attacker)
        {
            // Same attacker, just reset maximum burn damage.
            if (victim.burnout < burn_damage_z)
                victim.burnout = burn_damage_z;

            // Reset flame damage.
            victim.burner.pos1  = hit_damage;
            victim.burner.pos2  = burn_damage;

            return;
        }

        // Put out old fire and replace it with another.
        victim.burner.nextthink = 0.1;  // ASAP
        victim.burner.think = BecomeExplosion;
    }

    // Make some fire!
    local   entity  fire;       // The new fire that will be created.
    local   vector  spot;       // The spot where the new fire will appear.

    // Get the spot where the fire will erupt.
    spot = PM_FireSpot (victim);

    // If entity was not on fire, make a small flaming explosion.
    if (!victim.burnout)
        PM_MakeExplosion (spot);

    // Entity will burn until damage limit is reached.
    victim.burnout  = burn_damage_z;

    // Create the fire.
    fire = PM_NewFire (attacker, victim, spot);
    victim.burner   = fire; // Link entity to fire.

    fire.frame      = 1;    // Use a *big* flame.
    fire.effects    = fire.effects | EF_DIMLIGHT;

    fire.pos1       = hit_damage;
    fire.pos2       = burn_damage;

    fire.attack_finished    = 0;
    fire.pain_finished      = 0;

    fire.nextthink  = 0.1;  // ASAP
    fire.think      = PM_Burn;
};


//===========================/  END OF FILE  /===========================//
