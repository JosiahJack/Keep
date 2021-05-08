// 'fx.qc' contains code for explosions and sounds.

//==========================================================================
//  Temporary Entities

// PM:  These are common within the qc progs.

void(float fx, vector spot) Tent_Point =
{
    WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
    WriteByte (MSG_BROADCAST, fx);
    WriteCoord (MSG_BROADCAST, spot_x);
    WriteCoord (MSG_BROADCAST, spot_y);
    WriteCoord (MSG_BROADCAST, spot_z);
};

void(float fx, entity src, vector p1, vector p2) Tent_Beam =
{
    WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
    WriteByte (MSG_BROADCAST, fx);
    WriteEntity (MSG_BROADCAST, src);   // If client, origin overrides p1.
    WriteCoord (MSG_BROADCAST, p1_x);
    WriteCoord (MSG_BROADCAST, p1_y);
    WriteCoord (MSG_BROADCAST, p1_z);
    WriteCoord (MSG_BROADCAST, p2_x);
    WriteCoord (MSG_BROADCAST, p2_y);
    WriteCoord (MSG_BROADCAST, p2_z);
};

void(vector spot) Tent_Explosion =
{
    WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
    WriteByte (MSG_BROADCAST, TE_EXPLOSION);
    WriteCoord (MSG_BROADCAST, spot_x);
    WriteCoord (MSG_BROADCAST, spot_y);
    WriteCoord (MSG_BROADCAST, spot_z);
};

void(vector spot, float rgb, float add) Tent_Explosion2 =
{
    WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
    WriteByte (MSG_BROADCAST, 12);      // TE_EXPLOSION2
    WriteCoord (MSG_BROADCAST, spot_x);
    WriteCoord (MSG_BROADCAST, spot_y);
    WriteCoord (MSG_BROADCAST, spot_z);
    WriteByte (MSG_BROADCAST, rgb);     // First index to use on the palette.
    WriteByte (MSG_BROADCAST, add);     // Range is from rgb to rgb+add-1.
};

// Generic beam.
// NOTE:  Nehahra engine feature.  Not available in standard Quake.
//void(string text, entity src, vector p1, vector p2) Tent_NehBeam =
//{
//    WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
//    WriteByte (MSG_BROADCAST, 17);      // TE_LIGHTNING4
//    WriteString (MSG_BROADCAST, text);
//    WriteEntity (MSG_BROADCAST, src);   // If client, p1 is always origin.
//    WriteCoord (MSG_BROADCAST, p1_x);
//    WriteCoord (MSG_BROADCAST, p1_y);
//    WriteCoord (MSG_BROADCAST, p1_z);
//    WriteCoord (MSG_BROADCAST, p2_x);
//    WriteCoord (MSG_BROADCAST, p2_y);
//    WriteCoord (MSG_BROADCAST, p2_z);
//};

//void(vector p1, vector p2, vector ang) Tent_TomazRail =
//{   // MSG_BROADCAST should be 0.
//    WriteByte (0, SVC_TEMPENTITY); WriteByte (0, 17);
//    WriteCoord (0, p1_x); WriteCoord (0, p1_y); WriteCoord (0, p1_z);
//    WriteCoord (0, p2_x); WriteCoord (0, p2_y); WriteCoord (0, p2_z);
//    WriteCoord (0, ang_x); WriteCoord (0, ang_y); WriteCoord (0, ang_z);
//};

//- - - - - - - - -
void(vector spot) R_Exp3 =
{
    local   entity  e;

    e = spawn();
    setorigin (e, spot);
    sound (e, CHAN_AUTO, "weapons/r_exp3a.wav", 1, ATTN_NORM);
    remove (e);
};

void(vector spot) Rocket_Explosion1 =
{
    R_Exp3 (spot);

    Tent_Explosion (spot);
};

void(vector spot, float rgb, float add) Rocket_Explosion2 =
{
    R_Exp3 (spot);

    Tent_Explosion2 (spot, rgb, add);
};

void(vector spot) Rocket_TarExplosion =
{
    R_Exp3 (spot);

    WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
    WriteByte (MSG_BROADCAST, TE_TAREXPLOSION);
    WriteCoord (MSG_BROADCAST, spot_x);
    WriteCoord (MSG_BROADCAST, spot_y);
    WriteCoord (MSG_BROADCAST, spot_z);
};
//- - - - - - - - -


//==========================================================================
//  Common Explosions

//float   CX_ORANGE   = 0;
//float   CX_RED      = 1;
//float   CX_YELLOW   = 2;
//float   CX_BLUE     = 3;
//float   CX_PURPLE   = 4;

void(vector spot, float r) Colored_Explosion =
{
    local   float   base, add;

    if (r == 3)
        {base = 244; add = 3;}
    else if (r == 2)
        {base = 240; add = 4;}
    else if (r == 1)
        {base = 247; add = 5;}
    else
    {
        r = random() * 3;
        if (r < 1)
            {base = 224; add = 16;}
        else if (r < 2)
            {base = 230; add = 8;}
        else
            {base = 232; add = 8;}
    }
    Rocket_Explosion2 (spot, base, add);
};


//==========================================================================
//  Sprite Frame Data

// FIXME:  put unused in 's_unused.spr'.

// Frames for 's_fancy.spr'.
float   X32_PUFF_ORANGE     = 0;
float   X32_PUFF_BLUE       = 5;
float   X32_PUFF_PURPLE     = 10;
float   X32_CLOUD_GREEN     = 15;
// Remove - - - - -
float   X32_PLASMA_ORANGE   = 21;
float   X32_PLASMA_RED      = 27;
float   X32_PLASMA_YELLOW   = 33;
float   X32_PLASMA_BLUE     = 39;
//- - - - - - - - -
float   X32_STAR_ORANGE     = 45;
float   X32_STAR_RED        = 50;
float   X32_STAR_YELLOW     = 55;
float   X32_STAR_BLUE       = 60;
//- - - - - - - - -
// 4 frames
float   X32_SPARK_ORANGE    = 65;
float   X32_SPARK_RED       = 69;
float   X32_SPARK_YELLOW    = 73;
float   X32_SPARK_BLUE      = 77;
float   X32_CUT_ORANGE      = 81;
float   X32_CUT_RED         = 85;
float   X32_CUT_YELLOW      = 89;
float   X32_CUT_BLUE        = 93;
//- - - - - - - - -
float   X56_PUFF_ORANGE     = 97;
float   X56_PUFF_BLUE       = 103;
float   X56_PUFF_PURPLE     = 109;
float   X56_CLOUD_GREEN     = 115;
float   X56_PLASMA_ORANGE   = 120;
float   X56_PLASMA_RED      = 126;
float   X56_PLASMA_YELLOW   = 132;
float   X56_PLASMA_BLUE     = 138;
float   X56_SPLASH_RED      = 144;
float   X56_SPLASH_GREEN    = 147;
float   X56_SPLASH_PURPLE   = 150;
float   X80_SPARK_ORANGE    = 153;
float   X80_SPARK_RED       = 159;
float   X80_SPARK_YELLOW    = 165;
float   X80_SPARK_BLUE      = 171;

// Frames for 's_wave.spr'.
float   RING_FIRE       = 0;    // Custent's flaming shockwave, modified.
float   RING_BLUE       = 8;    // Drake's airstrike impact.
float   RING_QUAKE      = 14;   // Drake's quake slam.
float   RING_ICE        = 19;   // Iceball shockwave.
// Ends at frame 21.

// Select frames in 's_wave2.spr'.  Each color lasts 3 frames.
float   RING2_QUAKE     = 0;
float   RING2_ICE       = 6;
// Ends at frame 56.


//==========================================================================
//  Explosions

void() s_explode_think =
{
    if (self.frame >= self.cnt)
        {SUB_Remove ();  return;}

    self.frame = self.frame + 1;
    self.nextthink = time + self.wait;
    if (self.frame == self.cnt)
        self.think = SUB_Remove;
};

// As 'BecomeAnyExplosion', with adjustable frames per second.
// Used by some custom explosions.
void(float base, float add, float fps, string text) BecomeFpsExplosion =
{
    if (!add)
        add = 6;    // Assume standard duration of six frames.
    if (!fps)
        fps = 10;

// Become explosion code.
    self.movetype   = MOVETYPE_NONE;
    self.velocity   = '0 0 0';
    self.touch      = SUB_Null;
    setmodel (self, text);
    self.solid      = SOLID_NOT;
//- - - -
    self.frame      = base;
    self.cnt        = base + add - 1;
    self.wait       = 1 / fps;
    self.nextthink  = time + self.wait;
    self.think      = s_explode_think;
};

void(float base, float add, string text) BecomeAnyExplosion =
{
    if (!add)
        add = 6;    // Assume standard duration of six frames.

// Become explosion code.
    self.movetype   = MOVETYPE_NONE;
    self.velocity   = '0 0 0';
    self.touch      = SUB_Null;
    setmodel (self, text);
    self.solid      = SOLID_NOT;
//- - - -
    self.frame      = base;
    self.cnt        = base + add - 1;
    self.wait       = 0.1;
    self.nextthink  = time + 0.1;
    self.think      = s_explode_think;
};

void(vector spot, float base, float add, string text) MakeAnyExplosion =
{
    local   entity  swap;

    swap = self;

    self = spawn();
    setsize (self, '0 0 0', '0 0 0');        
    setorigin (self, spot);
    BecomeAnyExplosion (base, add, text);

    self = swap;
};

void(float base, float add) BecomeFancy =
    {BecomeAnyExplosion (base, add, "progs/s_fancy.spr");};

void(vector spot, float base, float add) MakeFancy =
    {MakeAnyExplosion (spot, base, add, "progs/s_fancy.spr");};
//- - - - - - - - -

// Standard original Quake explosion stuff from old 1.06 weapons.qc.
void() s_explode1   =[  0,  s_explode2  ] {};
void() s_explode2   =[  1,  s_explode3  ] {};
void() s_explode3   =[  2,  s_explode4  ] {};
void() s_explode4   =[  3,  s_explode5  ] {};
void() s_explode5   =[  4,  s_explode6  ] {};
void() s_explode6   =[  5,  SUB_Remove  ] {};

// Modified Custents explosion -- appended after standard explosion sprites.
// Fast version below.  Slow version was <7, 8, 10, 12, 14, 16, 18, 19, 20>.
void() s_explodeb1  =[  7,  s_explodeb2 ] {};
void() s_explodeb2  =[ 10,  s_explodeb3 ] {};
void() s_explodeb3  =[ 13,  s_explodeb4 ] {};
void() s_explodeb4  =[ 16,  s_explodeb5 ] {};
void() s_explodeb5  =[ 19,  s_explodeb6 ] {};
void() s_explodeb6  =[ 20,  SUB_Remove  ] {};

void() BecomeExplosion =
{
    self.movetype   = MOVETYPE_NONE;
    self.velocity   = '0 0 0';
    self.touch      = SUB_Null;
    setmodel (self, "progs/s_explod.spr");
    self.solid      = SOLID_NOT;
    s_explode1 ();
};

// This creates an explosion sprite entity from scratch.
void(vector spot) MakeExplosion =
{
    local   entity  swap;

    swap = self;

    self = spawn();
    setsize (self, '0 0 0', '0 0 0');        
    setorigin (self, spot);
    BecomeExplosion ();

    self = swap;
};


//==========================================================================
//  Ice Explosions

// iceball.mdl:  frames 0-2 = iceballs, frames 3-7 = explosion of shards.
void() BecomeIcyExp =
{
    self.skin = 0;
    BecomeAnyExplosion (3, 5, "progs/iceball.mdl");
    self.alpha = ALPHA_ICE;
};

void(vector spot) MakeIcyExp =
{
    local   entity  iced;

    iced = spawn();
    iced.movetype   = MOVETYPE_NONE;
    iced.velocity   = '0 0 0';
    iced.touch      = SUB_Null;
    iced.solid      = SOLID_NOT;
//- - - -
    iced.alpha      = ALPHA_ICE;
    iced.frame      = 3;
    iced.cnt        = iced.frame + 4;    // 5 - 1
    iced.wait       = 0.1;
    iced.nextthink  = time + 0.1;
    iced.think      = s_explode_think;
//- - - -
    setall (iced, "progs/iceball.mdl", '0 0 0', '0 0 0', spot);
};


//==========================================================================
//  More Fiery Explosions

void() s_fiery1 =[  1, s_fiery2 ] {};
void() s_fiery2 =[  3, s_fiery3 ] {};
void() s_fiery3 =[  5, s_fiery4 ] {};
void() s_fiery4 =[  7, s_fiery5 ] {};
void() s_fiery5 =[  9, s_fiery6 ] {};
void() s_fiery6 =[ 11, s_fiery7 ] {};
void() s_fiery7 =[ 13, s_fiery8 ] {};
void() s_fiery8 =[ 15, SUB_Remove ] {};

void(string fx, void() thinkst) Explosion_Start =
{
    self.movetype   = MOVETYPE_NONE;
    self.velocity   = '0 0 0';
    self.touch      = SUB_Null;
    setmodel (self, fx);
    self.solid      = SOLID_NOT;
    thinkst ();
};

void() BecomeTheBigFire =
{
    if (deathmatch || coop)
        Explosion_Start ("progs/s_expbig.spr", s_fiery1);
    else
        BecomeFpsExplosion (0, 17, 20, "progs/s_expbig.spr");
};

void() BecomeExplosion2 =
{
    if (deathmatch || coop)
        Explosion_Start ("progs/s_explod.spr", s_explodeb1);
    else
        BecomeFpsExplosion (6, 16, 25, "progs/s_explod.spr");
};

// This creates an explosion sprite entity from scratch.
// Used by 'monster_turret'.
void(vector spot) MakeExplosion2 =
{
    local   entity  swap;

    swap = self;

    self = spawn();
    setsize (self, '0 0 0', '0 0 0');        
    setorigin (self, spot);
    BecomeExplosion2 ();

    self = swap;
};


//==========================================================================
//  Alternate Explosions

void() Old_Explosion1 =
    {Rocket_Explosion1 (self.origin);  BecomeExplosion ();};

// Was named 'Knightball_Explode'.
void() Orange_Explosion =
{
    local   float   r;

    r = random() * 3;
    if (r < 1)
        Rocket_Explosion2 (self.origin, 224, 16);
    else if (r < 2)
        Rocket_Explosion2 (self.origin, 230, 8);
    else
        Rocket_Explosion2 (self.origin, 232, 8);
    BecomeExplosion ();
};


//==========================================================================
//  Shockwaves

void(vector spot, float base, float add, string text) ShockWave =
{
    local   entity  wav1, wav2, ts;
    local   vector  ang;

// NOTE:  Don't use world in the 4th (ignore) parm or else the traceline
// will pass through any non-world bsp entites, such as shootable
// trap doors.  Use self instead, which should be an inflictor entity.
    traceline (spot, spot - '0 0 64', TRUE, self);
    if (trace_fraction >= 1.0)
        return;     // Too far from ground.
    if ((trace_plane_normal * '0 0 1') < 0.5)   //<= 0.7071
        return;     // Ground slopes too much.

    spot = trace_endpos + trace_plane_normal * 2;
    ang = vectoangles(trace_plane_normal);
    ang_y = anglemod(ang_y + 180);

// Top side.
    wav1 = spawn();
    wav1.angles     = ang;
    setorigin (wav1, spot);

// Bottom side.
    ang_x = anglemod(ang_x + 180);
    wav2 = spawn();
    wav2.angles     = ang;
    setorigin (wav2, spot);

// Thinking
    ts = self;
    self = wav1;
    BecomeAnyExplosion (base, add, text);
    self = wav2;
    BecomeAnyExplosion (base, add, text);
    self = ts;
};

// Used by exploding barrels and MIRVs.  Yes, add 7 instead of 8.
void() FlameWave = {ShockWave (self.origin, RING_FIRE, 7, "progs/s_wave.spr");};

// Used by lightning strikes.
void() BlueWave = {ShockWave (self.origin, RING_BLUE, 4, "progs/s_wave.spr");};

// Like ShockWave, but show only the top side.
// Use for mini-rings, when you need a lot of them.
void(vector spot, float base, float add, string text) HalfWave =
{
    local   entity  wav1, ts;
    local   vector  ang;

    traceline (spot, spot - '0 0 64', TRUE, world);
    if (trace_fraction >= 1.0)
        return;     // Too far from ground.
    // Removed slope check.

    spot = trace_endpos + trace_plane_normal * 2;
    ang = vectoangles(trace_plane_normal);
    ang_y = anglemod(ang_y + 180);

// Top side.
    wav1 = spawn();
    wav1.angles     = ang;
    setorigin (wav1, spot);

// Thinking
    ts = self;
    self = wav1;
    BecomeAnyExplosion (base, add, text);
    self = ts;
};


//==========================================================================
//  Particle Explosions

// Particle explosion effects for plasma shots.

// Pattern is vertices of a rhombic triacontahedron (i.e., d30).
// Warning:  Calls particle function more times than healthy (32 times).
void(vector spot, float sped, float rgb, float den) PX_D30 =
{
    particle (spot, '0 0 1' * sped, rgb, den);

    particle (spot, '.5076 .3688 .7787' * sped, rgb, den);
    particle (spot, '-.1939 .5967 .7787' * sped, rgb, den);
    particle (spot, '-.6274 0 .7787' * sped, rgb, den);
    particle (spot, '-.1939 -.5967 .7787' * sped, rgb, den);
    particle (spot, '.5076 -.3688 .7787' * sped, rgb, den);

    particle (spot, '.7905 .5743 .2128' * sped, rgb, den);
    particle (spot, '-.3019 .9293 .2128' * sped, rgb, den);
    particle (spot, '-.9771 0 .2128' * sped, rgb, den);
    particle (spot, '-.3019 -.9293 .2128' * sped, rgb, den);
    particle (spot, '.7905 -.5743 .2128' * sped, rgb, den);

    particle (spot, '.7236 .5257 -.4473' * sped, rgb, den);
    particle (spot, '-.2763 .8507 -.4473' * sped, rgb, den);
    particle (spot, '-.8944 0 -.4473' * sped, rgb, den);
    particle (spot, '-.2763 -.8507 -.4473' * sped, rgb, den);
    particle (spot, '.7236 -.5257 -.4473' * sped, rgb, den);

    particle (spot, '.8944 0 .4473' * sped, rgb, den);
    particle (spot, '.2763 .8507 .4473' * sped, rgb, den);
    particle (spot, '-.7236 .5257 .4473' * sped, rgb, den);
    particle (spot, '-.7236 -.5257 .4473' * sped, rgb, den);
    particle (spot, '.2763 -.8507 .4473' * sped, rgb, den);

    particle (spot, '.9771 0 -.2128' * sped, rgb, den);
    particle (spot, '.3019 .9293 -.2128' * sped, rgb, den);
    particle (spot, '-.7905 .5743 -.2128' * sped, rgb, den);
    particle (spot, '-.7905 -.5743 -.2128' * sped, rgb, den);
    particle (spot, '.3019 -.9293 -.2128' * sped, rgb, den);

    particle (spot, '.6274 0 -.7787' * sped, rgb, den);
    particle (spot, '.1939 .5967 -.7787' * sped, rgb, den);
    particle (spot, '-.5076 .3688 -.7787' * sped, rgb, den);
    particle (spot, '-.5076 -.3688 -.7787' * sped, rgb, den);
    particle (spot, '.1939 -.5967 -.7787' * sped, rgb, den);

    particle (spot, '0 0 -1' * sped, rgb, den);
};

// Icosahedron (d20) -- 12 particle calls.
void(vector spot, float sped, float rgb, float den) PX_D20 =
{
// Golden ratio = (1 + sqrt(5)) / 2.  (1:1.618)
    particle (spot, '0 .5257 .8507' * sped, rgb, den);
    particle (spot, '0 -.5257 .8507' * sped, rgb, den);
    particle (spot, '0 -.5257 -.8507' * sped, rgb, den);
    particle (spot, '0 .5257 -.8507' * sped, rgb, den);
    particle (spot, '.5257 .8507 0' * sped, rgb, den);
    particle (spot, '-.5257 .8507 0' * sped, rgb, den);
    particle (spot, '-.5257 -.8507 0' * sped, rgb, den);
    particle (spot, '.5257 -.8507 0' * sped, rgb, den);
    particle (spot, '.8507 0 .5257' * sped, rgb, den);
    particle (spot, '.8507 0 -.5257' * sped, rgb, den);
    particle (spot, '-.8507 0 -.5257' * sped, rgb, den);
    particle (spot, '-.8507 0 .5257' * sped, rgb, den);
};

// Generic custom particle explosion.
void(vector spot, vector x1, vector x2) Particle_Explosion =
{
    PX_D30 (spot, x1_x, x1_y, x1_z);
    PX_D20 (spot, x2_x, x2_y, x2_z);
};

// Spawns particles within an ent.  Bounds are the entity's hull boundaries.
void(entity ent, float color1, float color2) Particle_Cube =
{
    local   vector  spot;
    local   float   loop, r;

    loop = 11;
    while (loop > 0)
    {
        loop = loop - 1;
        spot_x = random();  spot_y = random();  spot_z = loop / 10;
        spot = Anypoint (ent, spot);
        r = color1;
        if (random() < 0.25)
            r = color2;
        particle (spot, '0 0 0', r, 5);
    }
};

// Spawns a dust cloud upward.  Used by Storm Baron's gust attack.
void(entity ent) Particle_Gust =
{
    local   vector  spot;
    local   float   loop;

    loop = 9;
    while (loop > 0)
    {
        loop = loop - 1;
        spot_x = random() * 2 - 0.5;
        spot_y = random() * 2 - 0.5;
        spot_z = loop / 8;
        spot = Anypoint (ent, spot);
        particle (spot, '0 0 8', 1, 5);
    }
};


//==========================================================================
//  Particle Beam

// Spawns a beam of particles.
void(vector start, vector end, float color1, float color2,
    float density, float full)  Particle_Beam =
{
    local   vector  delta;
    local   float   points;
    local   float   dist;
    local   vector  next;

    delta = end - start;
    dist = vlen(delta);

    if (full)
    {   // Unbroken, continuous trail.  Used by meteor.
        points = dist / 24;
        points = ceil(points);
        dist = -24;
    }
    else
    {   // Sparse, broken trail.  Useful for frost trails.
        if (deathmatch || coop)
            points = 2;
        else
            points = 3;
        dist = dist / points;
        dist = 0 - dist;
    }

    delta = normalize(delta);
    next = delta * dist;
    full = color1;

    while (points > 0)
    {
        particle (end, delta, full, density);
        end = end + next;
        points = points - 1;
        if (full == color1)
            full = color2;
        else
            full = color1;
    }
};

// This creates a small particle trail behind the shot.
void(float rgb, float density, float full) Meteor_Trail =
{
    Particle_Beam (self.oldorigin, self.origin, rgb, rgb, density, full);
    self.oldorigin = self.origin;   // Update previous point.
};


//==========================================================================
//  Nemesant Effects

// PM:  Like BecomeExplosion, but for the Nemesant's signature explosion.
// In Drake, some bosses use this for their post-mortem explosions.
void() WarpExplosion =
{
    sound (self, CHAN_AUTO, "nemesant/bigboom.wav", 1, ATTN_NORM);
    Tent_Point (TE_EXPLOSION, self.origin);
    FlameWave ();       // PM:  New shockwave effect at ground zero.
// DISABLED -- Quake effects may be a bit excessive.
//    Quake_Spawn (300, 0, self.origin, 0, 1);
    BecomeTheBigFire ();    // Replaced old fireball mdl with big sprite.
};

//- - - - - - - - -
// PM:  Moved circle drawing code from Zerstorer's misc.qc to here.
void(vector Center, float Radius, float CColor) DrawCircleXY =
{
local   float   MajorAxis, MinorAxis;
local   float   RadSqminusMajAxis, MinAxisSqThreshold;
local   vector  circlepos, vel;

    MajorAxis = 0;
    MinorAxis = Radius;
    circlepos_z = Center_z;
    vel = '0 0 1';

    RadSqminusMajAxis = Radius * Radius;
    MinAxisSqThreshold = MinorAxis * MinorAxis - MinorAxis;

    do {
        circlepos_x = Center_x+MajorAxis; circlepos_y = Center_y-MinorAxis;
        particle(circlepos, vel, CColor, 15);
        circlepos_x = Center_x-MajorAxis;
        particle(circlepos, vel, CColor, 15);
        circlepos_x = Center_x+MajorAxis; circlepos_y = Center_y+MinorAxis;
        particle(circlepos, vel, CColor, 15);
        circlepos_x = Center_x-MajorAxis;
        particle(circlepos, vel, CColor, 15);
        circlepos_x = Center_x+MinorAxis; circlepos_y = Center_y-MajorAxis;
        particle(circlepos, vel, CColor, 15);
        circlepos_x = Center_x-MinorAxis;
        particle(circlepos, vel, CColor, 15);
        circlepos_x = Center_x+MinorAxis; circlepos_y = Center_y+MajorAxis;
        particle(circlepos, vel, CColor, 15);
        circlepos_x = Center_x-MinorAxis;
        particle(circlepos, vel, CColor, 15);
        MajorAxis = MajorAxis + 20;
        RadSqminusMajAxis = RadSqminusMajAxis - (MajorAxis + MajorAxis - 20);
        if ( RadSqminusMajAxis <= MinAxisSqThreshold )
        {
            MinorAxis = MinorAxis - 20;
            MinAxisSqThreshold = MinAxisSqThreshold - (MinorAxis + MinorAxis);
        }
    } while ( MajorAxis <= MinorAxis );
};


//==========================================================================
//  Sounds

//- Quake CD Tracks -
//  1 = Non-music data (Quake exe, pak*.pak, etc.)
//  2 = Quake Theme
//  3 = Intermission
//  4 = Whispers
//  5 = Grizzly Grotto
//  6 = Slipgate Complex
//  7 = Underearth
//  8 = Castle of the Damned
//  9 = Necropolis
// 10 = Ziggurat Vertigo
// 11 = Gloom Keep
//- - - - - - - - - -
void(float music) CD_Track =
{
    WriteByte (MSG_ALL, SVC_CDTRACK);
    WriteByte (MSG_ALL, music);
    WriteByte (MSG_ALL, 3);
};
//- - - - - - - - - -

void(entity ent, float chan) StopSound =
    {sound (ent, chan, "misc/null.wav", 1, ATTN_NONE);};

// Was "weapons/discharg.wav".
void() Sfx_Discharge =
    {sound (self, CHAN_AUTO, "plasma/explode.wav", 1, ATTN_NORM);};

// Keep this handy due to r_exp3.wav replacements.
void() Sfx_Explode =
    {sound (self, CHAN_AUTO, "weapons/r_exp3a.wav", 1, ATTN_NORM);};

// Standard laser fire sound.  Used by enforcers and laser traps.
void() Sfx_LaserFire =
    {sound (self, CHAN_WEAPON, "hipweap/laserg.wav", 1, ATTN_NORM);};

// Lightning bolts.
void() Sfx_Zap =
{
    // Just like the Thunderbolt.
    sound (self, CHAN_WEAPON, "weapons/lhit.wav", 1, ATTN_NORM);
    sound (self, CHAN_AUTO, "weapons/lstart.wav", 1, ATTN_NORM);
};

// For small plasma hits.
void() Sfx_Buzz =
{
    if (random() < 0.5)
        sound (self, CHAN_AUTO, "weapons/zap1.wav", 1, ATTN_NORM);
    else
        sound (self, CHAN_AUTO, "weapons/zap2.wav", 1, ATTN_NORM);
}

// Play "weapons/ric*.wav".
void() Sfx_Ric =
{
    local   float   r;
    local   string  text;

    r = random() * 3;
    if (r < 1)
        text = "weapons/ric1.wav";
    else if (r < 2)
        text = "weapons/ric2.wav";
    else
        text = "weapons/ric3.wav";
    sound (self, CHAN_AUTO, text, 1, ATTN_NORM);
};

void() Sfx_Tink =
{
    if (random() < 0.8)
        sound (self, CHAN_AUTO, "weapons/tink1.wav", 1, ATTN_NORM);
    else
        Sfx_Ric ();
};

void() Sfx_Footstep =
{
//    local   float   r;
    local   string  text;

    if (!footsteps)
        return;     // Turned off.
    if (Armor_Exotic (self) == SUIT_SPIRIT)
        return;     // Suppress footsteps.
    if (self.h2olevel > 0)
        return;     // We would play water steps instead, but we have none.

    if (random() < 0.7)     // Was (random() * 4 & 3 == 2)
        text = "player/boot2.wav";
    else
        text = "player/boot3.wav";

// Later Quake games may use normal attenuation.  Here, use idle.
    sound (self, CHAN_FOOT, text, 1, ATTN_IDLE);
};

// Called by monsters when they should make a normal footstep.
// Should be used only by humanoid monsters such as soldiers and knights.
void() M_Step =
{
    if (self.flags & FL_ONGROUND)
        Sfx_Footstep ();
};


//=========================================================================
//  Animation

// Sets nextthink.  'fr' is frame time delay based on 35 fps.
// Used by code that emulates stuff from the Doom or Heretic games.
void(float fr) Doom_NextThink = {self.nextthink = time + (fr / 35);};

// Resets walkframe to zero if out of bounds.
void(float fmin, float fmax) WalkFrame_Check =
{
    if ((self.frame < fmin) || (self.frame > fmax))
        self.walkframe = 0;
};

// Adds 'fadd' to frame 'fr'.  Used to animate monsters.
void(float fr, float fadd, float fmax) WalkFrame_Add =
{
    if ((self.walkframe < 0) || (self.walkframe > fmax))
        self.walkframe = 0;
    self.frame = fr + self.walkframe;
    self.walkframe = self.walkframe + fadd;
};


//===========================/  END OF FILE  /===========================//
