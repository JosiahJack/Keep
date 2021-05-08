// 'swap.qc' is a catch-all for code that varies depending on the progs.dat.
// In other words, one version for normal engines, and other for DarkPlaces.
// It is easier to swap one file as needed than several.

//==========================================================================
//  Flymode

// Custom flymode code is in its own file to make compiling progs.dat
// for standard engines and DarkPlaces easier by concentrating engine
// dependant code into one file then swapping it instead of several files
// when compiling the progs.

//---------------
// Water basics in q1source:
//
// The player is considered swimming if waterlevel is set at 2 or 3.
// While swimming, the player's speed is slowed to 70%.  Also, if none of
// the movement keys are pressed, and velocity is less than 100, the player
// automatically sinks at a rate of 48 per frame, which is 70% of 60.
//---------------
void() PlayerFly =
{
// Since oldorigin does not update in flymode, do it here.
// FIXME:  Make sure player is not in a solid.
    self.oldorigin = self.origin;

// Player begins to sink when velocity is less than 100.  70 is 70% of 100.
    if (vlen(self.velocity) >= 70)
    {
        self.waterlevel = 3;    // Swim mode gives player full 3D control.

    // If onground, moving will cause the pitch to center automatically if
    // mouselook is off, so remove the flag while the player swims in mid-air.
        self.flags = self.flags - (self.flags & FL_ONGROUND);

    // This negates the underwater speed penalty.  Don't forget to undo the
    // changes made here in PlayerPostThink.  Inspired by Hip's wetsuit code.
        if (self.h2olevel < 2)      // But only in the air.
            self.velocity = self.velocity * 1.429;    // 10/7 or 1.428571...
    }
    else
    {
        self.waterlevel = 0;    // So player doesn't sink while not moving.

    // While not in swim mode, the onground flag gives the player full
    // control in the air, so make sure the flag is on.
        self.flags = self.flags | FL_ONGROUND;
    }

// Since the player is flying, make sure the jumpreleased flag is off at
// all times so when the player loses flight, he can't jump in mid-air
// in case the onground flag is on.
    self.flags = self.flags - (self.flags & FL_JUMPRELEASED);

// A 'groundentity' is the entity the player stands on.  If the groundentity
// is not the world, the player is assumed to be standing on something that
// may move, such as an elevator, a train, trap door. etc.  If groundentity
// moves, the player tags along for the ride.  The problem comes in if a
// player, flying in mid-air, has a non-world, moving groundentity.  This
// lets the groundentity pull the player along when it shouldn't.  To fix
// this, always set the groundentity to the world, which can never move.
    self.groundentity = world;

// The jump button works a bit differently while in flymode.
    if (self.button2)
    {
        // Rise if in water.  Otherwise, slam on the brakes.
        if (self.h2olevel)
        {
            WaterRise (self);
            if (self.h2olevel < 2)
                self.velocity_z = self.velocity_z * 1.429;  // 10/7 or 1.428571...
        }
        else
            self.velocity_z = 0;
    }
};

//// Replacement flight function for the DarkPlaces engine.
//// Commented out for all other Quake engines.
//void() PlayerFly =
//{
//// This code is for the DarkPlaces engine.
//    self.flags = self.flags - (self.flags & FL_JUMPRELEASED);
//    if (self.button2)
//    {   // Rise if in water.  Otherwise, slam on the brakes.
//        if (self.h2olevel)
//            WaterRise (self);
//        else
//            self.velocity_z = 0;
//    }
//};

void() PlayerFly_PostThink =
{
// PM:  If compiling for DarkPlaces, comment the code below out so that
// nothing is done.
    if (self.waterlevel)
        if (self.h2olevel < 2)
            self.velocity = self.velocity * 0.7;
};


//==========================================================================
//  Effects

// Called by 'CheckArtifacts' in pow.qc.
// Haze code is here in case I can create better effects in custom engines.
// Particles is the best I can do in standard engines.
void(entity ent) Curse_Haze =
{
    if (ent.curse_ping < time)
    {
        local   vector  org;
        local   float   pal;
    
        ent.curse_ping = time + 0.05;
        org_x = random();  org_y = random();  org_z = 0.7;
        org = Anypoint (ent, org);
        if (ent.curse_type == CURSE_DAMAGE)
            pal = 233;  // Fiery orange
        else if (ent.curse_type == CURSE_WEAKEN)
            pal = 193;  // Bright yellow
        else if (ent.curse_type == CURSE_ARMOR)
            pal = 97;   // Rust brown
        else if (ent.curse_type == CURSE_SLOW)
            pal = 41;   // Light Blue
        else //if (ent.curse_type == CURSE_CONFUSE)
            pal = 145;  // Purple
//        else if (ent.curse_type == CURSE_LIFETAP)
//            pal = 73;   // Blood red
//        else if (ent.curse_type == CURSE_FREEZE)
//            pal = 209;  // Blue
        particle (org, '0 0 5', pal, 10);
    }
};


//==========================================================================
//  Rain

// Spawns rain sprites.  Used in non-DP engines.
void() rain_drop =
{
    local   vector  org;
    local   entity  drop;
    local   float   loop;

    loop = self.count;
    while (loop > 0)
    {
        loop = loop - 1;

        org_x = self.origin_x + self.mangle_x * random();
        org_y = self.origin_y + self.mangle_y * random();
        org_z = self.origin_z + self.mangle_z * random();
        if (pointcontents (org) != CONTENT_SOLID)
        {
            drop = spawn();
            if (self.style)
            {   // Snow sprite
                drop.frame      = self.lefty;   //(serverflags & 15) * 5 + 4;
                drop.classname  = "snow";
            }
            else
            {   // Rain model
                drop.angles     = self.angles;
                drop.alpha      = 0.9;
                drop.frame      = 0;
                drop.skin       = self.lefty;   //serverflags & 15;
                drop.classname  = "rain";
            }
            drop.movetype   = MOVETYPE_FLY;
            drop.solid      = SOLID_TRIGGER;    // PM:  Watch for bugs.
            drop.velocity   = self.dest;
            drop.touch      = SUB_Remove;   //rain_touch;
            // PM:  Added as insurance in case rain never touches something.
            drop.nextthink  = time + 10;    // Was T+8.
            drop.think      = SUB_Remove;
            setall (drop, self.mdl, VEC_ORIGIN, VEC_ORIGIN, org);
        }
    }
};

void() rain_think =
{
    self.nextthink = time + self.wait;      // Was T+0.1;
//    IF (DarkPlaces)
//    {
//        if (self.style)
//            te_particlesnow(self.pos1, self.pos2, self.dest, self.count, self.cnt);
//        else
//            te_particlerain(self.pos1, self.pos2, self.dest, self.count, self.cnt);
//    }
//    ELSE
        rain_drop ();
};

//============
// --> QUAKED func_rain (0 .5 .8) ?
// --> QUAKED func_rain_point (0 .5 .8) (-8 -8 -8) (8 8 8)
// This is an invisible area like a trigger, which rain falls inside of.
//
// Keys:
// "velocity"
//  falling direction (should be something like '0 0 -700', use the X and Y velocity for wind)
// "cnt"
//  sets color of rain (default 12 - white)
// "count"
//  adjusts rain density, this many particles fall every second, experiment to see the effects (default is based on area size)
// "mangle" (func_rain_point only)
//  size of area
// "spawnflags" (rain only)
//  1 = Heavy rain (disables velocity X and Y)
//============
void(float point, float snow) func_rain_start =
{
//    IF (!DarkPlaces)
    {   // Rain is spam-tastic, so don't use in multiplayer.  Also...
        // If corpse removal is on, assume slow computer, and turn off rain.
        if (deathmatch || coop || corpse_removal)
            {remove (self);  return;}

        if (snow)
            self.mdl = "progs/s_spark.spr";
        else
        {   // Rain
            if (self.spawnflags & 1)
                self.mdl = "progs/rain20.mdl";
            else
                self.mdl = "progs/rain.mdl";
        }
        precache_model (self.mdl);
    }

    self.style = snow;
	self.dest = self.velocity;
    self.velocity = '0 0 0';
    if (self.dest == '0 0 0')   //(!self.dest)
    {
        if (snow)
            self.dest   = '0 0 -300';
        else
            self.dest   = '0 0 -700';
    }
    self.angles   = '0 0 0';
    self.movetype = MOVETYPE_NONE;
    self.solid    = SOLID_NOT;
    if (point)
    {   // Point
        self.pos1   = self.origin;
        self.pos2   = self.origin + self.mangle;
    }
    else
    {   // Trigger
        setmodel (self, self.model);
        setorigin (self, self.origin);
        setsize (self, self.mins, self.maxs);
        self.model    = "";

        self.pos1   = self.absmin;
        self.pos2   = self.absmax;
        self.mangle = self.pos2 - self.pos1;
    }
	if (!self.count)
        self.count  = self.mangle_x * self.mangle_y / 8192;
    self.wait = 0.1;
    if (self.count < 10)
        if (self.count > 0)
            self.wait = 1 / self.count;
//- - - - - - - - -
//    IF (!DarkPlaces)
        if (!snow)
        {
            if (self.spawnflags & 1)
            {   // Use rain patch to reduce density.
                self.count  = ceil (self.count / 4);
                self.dest_x = self.dest_y   = 0;
            }
            else
                self.angles = vectoangles (self.dest) + '90 0 0';
        }
//- - - - - - - - -
	if (self.count < 1)
        {remove (self);  return;}
	if (!self.cnt)
        self.cnt    = 12;
//- - - - - - - - -
    if (self.cnt >= 244)
    {
        if (self.cnt >= 252)
            self.lefty  = 18;
        else if (self.cnt >= 247)
            self.lefty  = 17;
        else
            self.lefty  = 16;
    }
    else
        self.lefty  = floor(self.cnt / 16);
    if (snow)
        self.lefty  = self.lefty * 5 + 4;
//- - - - - - - - -
	// convert from per second to per 0.1 sec,
    self.count    = ceil(self.count * 0.1);
    self.think    = rain_think;
    self.nextthink= time + 0.5;
};

void() func_rain = {func_rain_start (FALSE, FALSE);};
void() func_rain_point = {func_rain_start (TRUE, FALSE);};

void() func_snow = {func_rain_start (FALSE, TRUE);};
void() func_snow_point = {func_rain_start (TRUE, TRUE);};


//==========================================================================
//  Rail Trail

// Placed in 'swap.qc' because some engines support builtin rail trails,
// and we can use that instead of the particle hogs used in standard.

// This creates the corkscrew particle trail.
void() Rail_Cork =
{
    local   vector  org, dir, next;
    local   float   dist, limit;
    local   float   loop;

    org = self.dest;     // Origin from last frame.

// Particles are spawned up to 16 units away from a given point.
// NOTE:  Make sure 'limit' is evenly divisible by 'dist'.
    dir = self.movedir;
    dist = 16;
    if (sys_ticrate)
        limit = rint(4160 * sys_ticrate / dist) * dist;
    else
        limit = 416;

    if (self.distance < limit)
    {
        loop = ceil(self.distance / dist);
        self.distance = 0;
    }
    else
    {
        loop = limit / dist;
        self.distance = self.distance - limit;
        self.dest = self.dest + dir*limit;
    }
    next = dir * dist;

// Draw corkscrew trail from the source to the end.
    while (loop > 0)
    {
        // Draw some particles off to the side.
        makevectors (self.angles);
        // Had 'org + v_right*24, dir'
        particle (org + v_right*8, dir + v_right*4, self.waitmin, 4);
        if (self.waitmax)
            particle (org - v_right*8, dir - v_right*8, self.waitmax, 8);

        //- - - - - - - - -
        // Advance the loop counter.
        //
        // Add a prime number to the next angle to minimize the use of the
        // same angle.  This is much like Diablo II's Frozen Orb, which uses
        // 19/64.  Adding the number makes the trail go clockwise while
        // subtracting the number makes the trail go counter-clockwise.
        //
        // Note:  TomazQuake adds +5 per pixel in its TE_RAILTRAIL.
        //- - - - - - - - -
        self.angles_z = anglemod(self.angles_z - 19);
        org = org + next;
        loop = loop - 1;
    }

    if (self.distance < 0)
        {remove (self); return;}
    self.nextthink = time + sys_ticrate;
};

void(vector p1, vector p2, vector ang, float cork) Rail_Trail =
{
// FIXME:  If engine supports TE_RAILTRAIL, use that instead of the code
//  below.  However, the standard Quake engine does not support that,
//  and even if it did, it would be a grenade trail with a rocket
//  explosion at the endpoint, not the corkscrew like in Quake2 or
//  TomazQuake.

    local   entity  railer;
    local   vector  dir;
    local   float   dist, rc1, rc2;

    rc1 = parms_unpack (cork, 1);
    rc2 = parms_unpack (cork, 2);

    dir = p2 - p1;
    dist = vlen (dir);
    dir = normalize (dir);

// Spawn center smoke trail.
// Note:  Because the smoke missile is movetype_noclip, it is not bound
// by 'sv_maxvelocity'.  In other words, it can go as fast as it wants.
    railer = spawn();
    railer.movetype  = MOVETYPE_NOCLIP;     // Yes, we need a ghost missile!
    railer.solid     = SOLID_NOT;
    railer.owner     = self;
    railer.velocity  = dir * (dist * 10);
    railer.nextthink = time + 0.1;      // Trace smoke for one frame.
    railer.think     = SUB_Remove;
    if (rc2)    // Assume Tome of Power induced fat trail if TRUE.
        railer.model    = "progs/smoke2.mdl";
    else
        railer.model    = "progs/smoke.mdl";
    setall (railer, railer.model, '0 0 0', '0 0 0', p1);

// Spawn corkscrew tracer.
    railer = spawn();
    railer.movetype  = MOVETYPE_NONE;
    railer.solid     = SOLID_NOT;
    railer.owner     = self;
// Railgun trace stats.
    railer.angles    = ang;
    railer.movedir   = dir;
    railer.dest      = p1;          // Use this instead of origin.
    railer.waitmin   = rc1;
    railer.waitmax   = rc2;
    railer.distance  = dist;
    railer.nextthink = 0.01;        // Start at the next frame.
    railer.think     = Rail_Cork;
    setall (railer, "", '0 0 0', '0 0 0', p1);
};

// For engines that support TomazQuake railgun effects.
//void(vector p1, vector p2, vector ang, float cork) Rail_Trail =
//{
//    Tent_TomazRail (p1, p2, ang);
//    cork = cork;    // Appease compiler.
//};


//===========================/  END OF FILE  /===========================//
