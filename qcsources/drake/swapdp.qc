// 'swap.qc' is a catch-all for code that varies depending on the progs.dat.
// In other words, one version for normal engines, and other for DarkPlaces.
// It is easier to swap one file as needed than several.

// This is 'swap.dp', the DarkPlaces version of 'swap.qc'.

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

// Replacement flight function for the DarkPlaces engine.
void() PlayerFly =
{
// This code is for the DarkPlaces engine.
    self.flags = self.flags - (self.flags & FL_JUMPRELEASED);
    if (self.button2)
    {   // Rise if in water.  Otherwise, slam on the brakes.
        if (self.h2olevel)
            WaterRise (self);
        else
            self.velocity_z = 0;
    }
};

void() PlayerFly_PostThink = {};    // Do nothing in DarkPlaces.


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
            pal = 41;   // Light blue
        else //if (ent.curse_type == CURSE_CONFUSE)
            pal = 145;  // Purple
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
// Yay!  Rain and snow functions that replace edict spam.
    if (self.style)
        te_particlesnow(self.pos1, self.pos2, self.dest, self.count, self.cnt);
    else
        te_particlerain(self.pos1, self.pos2, self.dest, self.count, self.cnt);
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


//===========================/  END OF FILE  /===========================//
