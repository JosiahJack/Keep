//==========================================================================
//
//  ICE
//
//==========================================================================

//==========================================================================
//  Ice Shards -- Used by white dragon, ice imp, and Rapture's water baron.

void() Ice_Touch =
{
    local   float   chunks, damage;
    local   vector  spot;

    if (pointcontents(self.origin) <= CONTENT_LAVA)     // Lava or sky.
        {remove(self);  return;}
    if (Reflected ())
        return;

    self.touch = SUB_Null;      // Stack overflow prevention.
    chunks = TRUE;
    damage = self.dmg;
    if (other.takedamage)
    {   // Check cold resistance here instead of in the damage functions
        // because it affects how much blood is spawned.
        damage = ceil(damage * (1 - other.resist_cold));
        if (damage > 0)
        {
            spawn_touchblood (damage, other.bloodtype);
            T_NewDamage (other, self, self.owner, damage, DF_NONE, "ice");
            chunks = FALSE;
        }
    }
    if (chunks)
    {   // Ice chunks.
        spawn_touchblood (10, CHUNKS_ICE);      // Ice chunks.
        sound (self, CHAN_WEAPON, "dragon/icehit.wav", 1, ATTN_NORM);
    }

// Become a mini-shockwave if close enough to the wall.
// In case of standard engines, just display a ring topside only.
    spot = self.origin;
    traceline (spot, spot + self.velocity, TRUE, world);  // Ignore creatures.
    if (trace_fraction >= 1.0)
        {remove (self);  return;}   // Too far from a solid surface.
    spot = trace_endpos + trace_plane_normal * 2;
    self.angles = vectoangles(trace_plane_normal);
    self.angles_y = anglemod(self.angles_y + 180);
    setorigin (self, spot);
    self.alpha = 0;
    BecomeAnyExplosion (RING2_ICE, 3, "progs/s_wave2.spr");
};

void() Ice_Think =
{
    Meteor_Trail (39, 2, FALSE);    // Function in 'fire.qc'.
    if (self.delay <= time)
        {remove (self); return;}
    if (pointcontents(self.origin) == CONTENT_LAVA)
        {remove (self); return;}

    self.nextthink = time + 0.1;
};

void(vector start, vector dir, float sped) Ice_Launch =
{
    newmis = spawn ();
    newmis.master       = newmis.owner      = self;
    newmis.movetype     = MOVETYPE_FLYMISSILE;
    newmis.solid        = SOLID_BBOX;
    newmis.classname    = "ice";
// set missile speed
    newmis.speed        = sped;
    newmis.velocity     = dir * sped;
    newmis.angles       = vectoangles(newmis.velocity);
// set missile damage
    newmis.dmg          = 9;
//    newmis.enemy        = targ;
    newmis.style        = DF_COLD | DF_SAFE;
// set missile special stuff
//    newmis.lefty        = 0;
    newmis.dest         = dir;
    newmis.oldorigin    = start;    // For proper particle trail drawing.
    newmis.alpha        = ALPHA_ICE;
// set missile duration
    newmis.touch        = Ice_Touch;
    newmis.delay        = time + 5;     // Total duration.  As spikes.
    newmis.nextthink    = 0.01;
    newmis.think        = Ice_Think;

    setall (newmis, "progs/ice.mdl", '0 0 0', '0 0 0', start);

//    launch_spike (start, dir);
//    setform (newmis, "progs/ice.mdl", VEC_ORIGIN, VEC_ORIGIN);        
//    newmis.style     = TE_KNIGHTSPIKE;
//    newmis.classname = "ice";
//    newmis.velocity  = dir*sped;
};


//==========================================================================
//  Iceballs -- Used by white wyrm.

// Iceball explosion effects, called by T_MissileTouch.
void() Iceball_Explode =
{
    sound (self, CHAN_AUTO, "weapons/shatter.wav", 1, ATTN_NORM);
    Tent_Explosion2 (self.origin, 32, 16);
    ShockWave (self.origin, RING_ICE, 3, "progs/s_wave.spr");
    BecomeIcyExp ();
};

// Thinking for iceballs.  Unlike shards, balls explode instead of melting.
void() Iceball_Think =
{
// Bigger ice chunks, so spawn a beam of frost.
    Meteor_Trail (39, 2, TRUE);     // Function in 'fire.qc'.
    if (self.delay > time)
        if (pointcontents(self.origin) != CONTENT_LAVA)
            {self.nextthink = time + 0.1;  return;}

// Time to blow up.
    T_MissileTouch ();
};

// Launch an explosive icy spikeball.
void(vector start, vector dir, float sped) Iceball_Launch =
{
    Ice_Launch (start, dir, sped);

    setmodel (newmis, "progs/iceball.mdl");
    setsize (newmis, '0 0 0', '0 0 0');

    newmis.avelocity = '300 300 300';
    newmis.dmg      = 60;
    newmis.alpha    = ALPHA_ICEBALL;
    newmis.touch    = T_MissileTouch;
    newmis.think    = Iceball_Think;
    newmis.think1   = Iceball_Explode;
};

void(vector start, vector dir, float sped, float damage) Iceball_Toss =
{
    Ice_Launch (start, dir, sped);

    setmodel (newmis, "progs/iceball.mdl");
    setsize (newmis, '0 0 0', '0 0 0');

    newmis.movetype = MOVETYPE_TOSS;
    newmis.avelocity = '300 300 300';
    newmis.dmg      = damage;
    newmis.alpha    = ALPHA_ICEBALL;
    newmis.touch    = T_MissileTouch;
    newmis.think    = Iceball_Think;
    newmis.think1   = Iceball_Explode;
};


//==========================================================================
//  Ice Mines

// Treat destroyed mines as barrels.
void() IceMine_Die =
{
    if (self.trigger_field)
        {remove (self.trigger_field);  self.trigger_field = world;}
    self.th_die= SUB_Null;      // Don't 'die' again if damaged more.
    self.touch = SUB_Null;      // Stack overflow prevention.
    self.solid = SOLID_NOT;
    self.enemy = world;
    self.nextthink = 0.01;
    self.think = T_MissileExplode;
};

void(entity targ) IceMine_Explode =
{
    if (self.trigger_field)
        {remove (self.trigger_field);  self.trigger_field = world;}
    self.touch = SUB_Null;      // Stack overflow prevention.
    self.enemy = targ;          // For modified T_MissileExplode.
    T_MissileExplode ();
};

void() IceMine_Touch =
{
// Target must either be shootable or a creature.
    if (other.takedamage != DAMAGE_AIM)
        if (!(other.flags & FLx_CREATURE))
            return;
// Don't explode on attacker.
    if (other == self.master)
        return;

// Removed sky and reflection checks because they do not apply to land mines.
    IceMine_Explode (other);
};

void() mine1 =[ 1, mine2    ] {};
void() mine2 =[ 2, mine3    ] {
    local   float   pc;

    pc = pointcontents(self.origin);
    if (pc == CONTENT_LAVA)
        {IceMine_Explode (world);  return;}
    if (self.delay > time)
        self.think = mine2;

    if (self.flags & FL_ONGROUND)
        return;     // Attached to the ground.

// Float check.  Ice is less dense than water.
    if ((pc == CONTENT_WATER) || (pc == CONTENT_SLIME))
    {   // Float to the surface;
        self.movetype = MOVETYPE_FLY;
//        self.flags = self.flags - (self.flags & FL_ONGROUND);
        self.velocity_z = self.velocity_z + 48;
        if (self.velocity_z > 48)
            self.velocity_z = 48;
    }
    else
        self.movetype = MOVETYPE_TOSS;
};
void() mine3 =[ 3, SUB_Null ] {IceMine_Explode (world);};

// Made so monsters who step on the iceball will explode it.
void() IceMineTrigger_Touch =
{
    local   entity  ice, swap;

    ice = self.owner;

    if (!ice || (ice == self))
        {remove (self);  return;}

    if (!(other.flags & FL_MONSTER))
        return;     // Other things should be able touch the iceball itself.
//    if (other == ice.owner)
//        return;     // Iceball owner is immune.
    if (other == ice.master)
        return;     // Iceball owner is immune.
    if (!(ice.flags & FL_ONGROUND) || (ice.velocity != '0 0 0'))
        return;     // Anything can touch iceball if it's moving.

// Set off the mine!
    if (other)
        other.flags = other.flags - (other.flags & FL_ONGROUND);
    self.touch = SUB_Null;
    swap = self;
    self = ice;

    self.trigger_field = world;
    self.touch = SUB_Null;      // Stack overflow prevention.
    self.enemy = other;         // For modified T_MissileExplode.
    self.owner = other;         // Pass through the mine.
    T_MissileExplode ();

    self = swap;
    remove (self);
};

void() IceMineTrigger_Think =[ 0, IceMineTrigger_Think ]
{
    if (self.owner)
        setorigin (self, self.owner.origin);
};

void(vector start) IceMine_Spawn =
{
    local   entity  ice, swap;

// Spawn the ice mine.
    ice = spawn ();
    ice.owner        = world;
    ice.master       = self;
    ice.movetype     = MOVETYPE_TOSS;
    ice.solid        = SOLID_BBOX;
    ice.classname    = "ice";
// set missile speed
    ice.velocity     = '0 0 0';
    ice.avelocity    = '0 0 0';
    ice.angles       = '0 0 0';
// set missile damage
    ice.dmg          = 90;
    ice.style        = DF_COLD;
// set miscellaneous
    ice.health       = 25;   // Barrels use 20 hp.
    ice.takedamage   = DAMAGE_YES;
    ice.bloodtype    = CHUNKS_ICE;
    ice.hittype      = HIT_STONE;
    ice.th_die       = IceMine_Die;
    ice.resist_cold  = 1;    // Immune to cold.
    ice.resist_fire  = -1;   // Fire melts ice!
// set missile duration
    ice.touch        = IceMine_Touch;
    ice.think1       = Iceball_Explode;
    ice.frame        = 0;
    ice.alpha        = ALPHA_ICEBALL;
    ice.think        = mine1;
    ice.nextthink    = time + 0.1;
    ice.delay        = time + 30;

    setall (ice, "progs/iceball.mdl", '-16 -16 0', '16 16 16', start);

// Set the mine on the floor.
//    if (pointcontents(start) == CONTENT_EMPTY)
    {
        swap = self;
        self = ice;
        droptofloor();
        self = swap;
    }

// Spawn touch field.
// With solid_bbox and movetype_toss, monsters can walk on the iceball
// without exploding it, which is unfair.  Therefore, place a trigger
// field over the iceball so anytime a monster tries to walk on the ice,
// the iceball will explode as expected.
    swap = spawn ();
    swap.master     = swap.owner    = ice;
    swap.movetype   = MOVETYPE_NONE;
    swap.solid      = SOLID_TRIGGER;
    swap.nextthink  = time + 0.1;
    swap.think      = IceMineTrigger_Think;
    swap.touch      = IceMineTrigger_Touch;
    setall (swap, "", '-16 -16 0', '16 16 32', start);

    ice.trigger_field  = swap;      // Link touch field to the iceball.
    newmis = ice;       // In case we need to modify the mine later.

// Spawning effects.
    sound (ice, CHAN_AUTO, "weapons/freeze.wav", 1, ATTN_NORM);
    ShockWave (ice.origin + '0 0 4', RING_ICE, 3, "progs/s_wave.spr");
};


//===========================/  END OF FILE  /===========================//
