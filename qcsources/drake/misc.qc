//============================================================================

//============
// Prototypes:  moved to proto.qc.
//============


//==========================================================================
//  Blood (Gib) Fountain

float GIB_FOUNTAIN  = 2; //just because I made the zombies and push brush = 2

void(string gibname, vector av) FtGib;
void() misc_fireball;

void() gibs_fly =
{
    local   float   rnum; 

    rnum = random();
    if (rnum < 0.15)
    {
        FtGib ("progs/gib1.mdl", '100 200 300');    //Zer uses gib4.mdl.
        FtGib ("progs/gib2.mdl", '200 100 300');
        FtGib ("progs/gib3.mdl", '100 200 300');
        FtGib ("progs/h_player.mdl", '300 200 100');

        sound (self, CHAN_AUTO, "gibfnt/gf_sbig.wav", 1, ATTN_NORM);
    }
    else if (rnum < 0.45)
        FtGib ("progs/gib1.mdl", '100 200 300');
    else if (rnum < 0.85)
        FtGib ("progs/gib2.mdl", '100 200 300');    //Zer uses gib4.mdl.
    else
        FtGib ("progs/gib3.mdl", '100 200 300');

    if (random() < 0.5)
        sound (self, CHAN_VOICE, "gibfnt/gf_sprt1.wav", 1, ATTN_NORM);
    else
        sound (self, CHAN_VOICE, "gibfnt/gf_sprt2.wav", 1, ATTN_NORM);

    self.nextthink = time + (random() * 5) + 3;
    self.think = gibs_fly;
};

//============
// --> QUAKED misc_gibft (0 .5 .8) (-8 -8 -8) (8 8 8)
// Gib Fountain -- Zerstorer style.
//============
void() misc_gibft =
{
    self.spawnflags = self.spawnflags | GIB_FOUNTAIN;
    misc_fireball ();   // Classname will be changed later.
};


//==========================================================================
//  Lava Balls

//void() fire_sound =
//{
//    sound (self, CHAN_AUTO, "ambience/fb_fly.wav", 1, ATTN_NORM);
//    self.nextthink = time + 0.36;
//};

void() fire_touch =
{
    if (Reflected ())
        return;
    self.touch = SUB_Null;      // Stack overflow prevention.
    T_Damage (other, self, self, self.dmg);
    remove (self);
};

void() fire_fly =
{
    local   entity  fire;

    fire = spawn();
    fire.solid      = SOLID_BBOX;       // Was SOLID_TRIGGER;
    fire.movetype   = MOVETYPE_TOSS;
    fire.velocity_x = (random() * 100) - 50;
    fire.velocity_y = (random() * 100) - 50;
    fire.velocity_z = self.speed + (random() * 200);
    fire.classname = "fireball";
    fire.delay      = time + 5;
//    if (zerstorer)
//    {   fire.nextthink  = time + 0.2;
//        fire.think      = fire_sound;
//    }
//    else
    {   fire.nextthink  = fire.delay;
        fire.think      = SUB_Remove;
    }
    if (self.dmg < 40)
        fire.touch      = fire_touch;
    else
        fire.touch      = T_MissileTouch;   // New exploding lavaballs
    fire.dmg        = self.dmg;
    fire.master     =
    fire.owner      = self;     // Lets exploding lavaballs give proper obit.
    fire.style      = DF_ROCKET;    // For T_Missile*.
    setall (fire, "progs/lavaball.mdl", '0 0 0', '0 0 0', self.origin);

    self.nextthink  = time + (random() * 5) + 3;
    self.think      = fire_fly;
};

void() fire_use =
{
    if (self.nextthink == 0)
        self.nextthink = time + 0.5;
    else if (self.lefty)
        self.nextthink = 0;
    else
        remove (self);
};

//============
// --> QUAKED misc_fireball (0 .5 .8) (-8 -8 -8) (8 8 8)
// Lava Balls
//
// "spawnflags"
//  1 : If targeted, start on.
//  2 : Convert to gib fountain.
//  4 : If targeted, reusable toggle.
//============
void() misc_fireball =
{
    if (self.spawnflags & GIB_FOUNTAIN)
    {   // Use blood fountain code instead.
        precache_sound ("gibfnt/gf_sprt1.wav");
        precache_sound ("gibfnt/gf_sprt2.wav");
        precache_sound ("gibfnt/gf_plop.wav");
        precache_sound ("gibfnt/gf_sbig.wav");
//        if (zerstorer)
//            precache_model ("progs/gib4.mdl");
        self.classname  = "blood";
        self.nextthink  = time + (random() * 2);
        self.think      = gibs_fly;
    }
    else
    {   // Standard lavaball.
        precache_model ("progs/lavaball.mdl");
//        if (zerstorer)
//            precache_sound ("ambience/fb_fly.wav");
        self.classname  = "fireball";
        self.nextthink  = time + (random() * 5);
        self.think      = fire_fly;
    }
    if (!self.nextthink)
        self.nextthink  = 0.01;

    if (!self.speed)
        self.speed      = 1000;
    if (!self.dmg)
        self.dmg        = 20;

    if (self.targetname)
    {
        self.lefty = self.spawnflags & 4;
        if (!(self.spawnflags & 1))
            self.nextthink = 0;     // Start off.
        self.use = fire_use;
    }
};


//============================================================================

//==========================================================================
//  Radioactive Barrels

void() barrel_explode =
{
//- - - - - - - - -
// In case of 'info_notnull' special effects hacks.
    self.takedamage = DAMAGE_NO;
    self.classname  = "explo_box";
//- - - - - - - - -
    // New:  Explosions will anger the survivors, like in Doom.
    T_NewRadiusDamage (self, self.enemy, 160, world, DF_PROXY, self.classname);
    setorigin (self, self.origin + '0 0 32');   // Origin was set directly.
// PM:  Don't use BigBang, an edict hog, in case of barrel chain reactions
// like in e3m1.
    Rocket_Explosion1 (self.origin);    // Was before relocation.
    FlameWave ();       // PM:  Shockwave effects.
    BecomeExplosion2 ();
};

void() barrel_die =
{
// Delay explosion for a frame because we may be in the middle of a
// T_RadiusDamage, and calling another before the first is done will
// scramble the .chain linked list.
    self.touch      = SUB_Null;     // Can't push it anymore.
    self.takedamage = DAMAGE_NO;
    self.nextthink  = 0.01;
    self.think      = barrel_explode;
};

// PM:  New feature for Drake.
void() barrel_touch =
{
    if (other.flags & FLx_CREATURE)
        if (other.movetype == MOVETYPE_WALK)
            CheckOnTop ();      // Let player run on barrel as if ground.
};

void(string gfx) barrel_stats =
{
    self.solid      = SOLID_BBOX;
    self.movetype   = MOVETYPE_NONE;
    cache_set (gfx);
//    precache_sound ("weapons/r_exp3.wav");
    SUB_FullHealth (20);
    self.th_die     = barrel_die;
    self.takedamage = DAMAGE_AIM;
    self.bloodtype  = BLOOD_SPARKS + 1;     // +1 for no gore.
    self.classname  = "explo_box";
    if (gfx != "maps/b_explob.bsp")     //if (gfx == "maps/b_barrel.bsp")
    {   // Allow pushing physics.  For barrels and small nuke boxes.
        precache_sound ("misc/pushwood.wav");
        self.solid      = SOLID_SLIDEBOX;
        self.movetype   = MOVETYPE_PUSH;
        self.touch      = chest_push;
    }
    else
        self.touch      = barrel_touch;

    self.origin_z   = self.origin_z + 2;
    if (!droptofloor ())
    {
        print_self (self.classname, " fell out of level at ");
        remove (self);
    }
};

//============
// --> QUAKED misc_barrel (0 .5 .8) (-20 -20 -20) (20 20 20)
// Wooden barrel from Shadow of Innsmouth.  Used in Tronyn's maps.
//============
void() misc_barrel = {barrel_stats ("maps/b_barrel.bsp");};

//============
// --> QUAKED misc_explobox (0 .5 .8) (0 0 0) (32 32 64)
// TESTING THING
//============
void() misc_explobox = //{barrel_stats ("maps/b_explob.bsp");};
{
    if (medieval)   // In Medieval mode, replace nuke box with wooden barrel.
        barrel_stats ("maps/b_barrel.bsp");
    else
        barrel_stats ("maps/b_explob.bsp");
};

//============
// --> QUAKED misc_explobox2 (0 .5 .8) (0 0 0) (32 32 64)
// Smaller exploding box, REGISTERED ONLY
//============
void() misc_explobox2 = {barrel_stats ("maps/b_exbox2.bsp");};


//==========================================================================
//  Trap Shooters

float   SPAWNFLAG_SUPERSPIKE    = 1;
float   SPAWNFLAG_LASER         = 2;
// Hipnotic
//float   SPAWNFLAG_LAVABALL      = 4;
float   SPAWNFLAG_ROCKET        = 8;
float   SPAWNFLAG_SILENT        = 16;
// Rogue
//float   SPAWNFLAG_LAVASPIKE     = 4;
//float   SPAWNFLAG_SUPERLAVA     = 8;
//float   SPAWNFLAG_LAVASKILL     = 16;
//float   SPAWNFLAG_FIREBALL      = 32;

void(vector org, vector vec) LaunchLaser;

void() spikeshooter_use =
{
    local   float   loud;

    loud = !(self.spawnflags & SPAWNFLAG_SILENT);
    if (self.spawnflags & SPAWNFLAG_LASER)
    {
        if (loud)   // Was "enforcer/enfire.wav".
            sound (self, CHAN_VOICE, "hipweap/laserg.wav", 1, ATTN_NORM);
        LaunchLaser (self.origin, self.movedir);
    }
//    else if (self.spawnflags & SPAWNFLAG_LAVABALL)
//    {
//// PM: lavarock is 8 pixels down compared to lavaball.
//        if (loud)
//            sound (self, CHAN_VOICE, "misc/spike.wav", 1, ATTN_NORM);
//
//        local   entity  lavaball;
//        lavaball = spawn();
//        lavaball.movetype = MOVETYPE_FLYMISSILE;
//        lavaball.solid = SOLID_BBOX;
//        lavaball.classname = "lavaball";
//        // set lavaball speed
//        lavaball.velocity = self.movedir * 300;
//        lavaball.angles = vectoangles(lavaball.velocity);
//        lavaball.owner = self;
//        lavaball.touch = T_MissileTouch;
//        setmodel (lavaball, "progs/lavarock.mdl");
//        setsize (lavaball, '0 0 0', '0 0 0');   // '-4 -4 -4', '4 4 4'
//        setorigin (lavaball, self.origin);
//        lavaball.avelocity = '0 0 400';
//        lavaball.nextthink = time + 5;
//        lavaball.think = SUB_Remove;
//    }
    else if (self.spawnflags & SPAWNFLAG_ROCKET)
    {
        if (loud)
            sound (self, CHAN_VOICE, "weapons/sgun1.wav", 1, ATTN_NORM);
        Rocket_Launch (self.origin, self.movedir);
    }
    else
    {
        if (loud)
            sound (self, CHAN_VOICE, "weapons/spike2.wav", 1, ATTN_NORM);
        if (self.spawnflags & SPAWNFLAG_SUPERSPIKE)
            launch_superspike (self.origin, self.movedir);
        else
            launch_spike (self.origin, self.movedir);
//        newmis.velocity = self.movedir * 500;
    }

// Adjust speed if necessary.
    if (self.speed)
    {
        newmis.speed    = self.speed;
        newmis.velocity = newmis.dest   = self.movedir * self.speed;
    }
};

void() shooter_think =
{
    if (self.state)     // Hipnotic
        spikeshooter_use ();
    self.nextthink  = time + self.wait;
    // PM:  Missile velocity done at spikeshooter_use.
};


//============
// --> QUAKED trap_spikeshooter (0 .5 .8) (-8 -8 -8) (8 8 8) superspike laser
// When triggered, fires a spike in the direction set in QuakeEd.
// Laser is only for REGISTERED.
//============
void() trap_spikeshooter =
{
    local   float   sped;

    SetMovedir ();
    self.use = spikeshooter_use;
    if (self.spawnflags & SPAWNFLAG_LASER)
    {
        sped = 600;
        precache_model ("progs/laser.mdl");
        
//        precache_sound ("enforcer/enfire.wav");
        precache_sound ("enforcer/enfstop.wav");
        precache_sound ("hipweap/laserg.wav");      // Replaces enfire.wav.
    }
//    else if (self.spawnflags & SPAWNFLAG_LAVABALL)
//    {
//        sped = 300;
//    // PM:  Only difference between this and lavaball is one is 8 pixels
//    //      higher than the other.
//        precache_model ("progs/lavarock.mdl");
//
//        precache_sound ("misc/spike.wav");
//    }
    else if (self.spawnflags & SPAWNFLAG_ROCKET)
    {
        sped = 1000;
        precache_model ("progs/missile.mdl");

        precache_sound ("weapons/sgun1.wav");
    }
    else
    {
        sped = 500;
        precache_model ("progs/spike.mdl");

        precache_sound ("weapons/spike2.wav");
    }

// PM:  Allow option for speeds other than 500.
    if (self.speed <= 0)
        self.speed = sped;
};

//============
// --> QUAKED trap_shooter (0 .5 .8) (-8 -8 -8) (8 8 8) superspike laser
// Continuously fires spikes.
// "wait" time between spike (1.0 default)
// "nextthink" delay before firing first spike, so multiple shooters can be
// staggered.
//============
void() trap_shooter =
{
    trap_spikeshooter ();
    
    if (!self.wait)
        self.wait       = 1;
    self.state      = 1;    // Hipnotic's state addition.
    self.nextthink  = self.nextthink + self.wait + self.ltime;
    self.think      = shooter_think;
};

//- - - - - - - - -
// Hipnotic's new trap shooter use functions.
void() trap_shooter_use = {self.state = !self.state;};  // Was '1 - self.state'.

//============
// --> QUAKED trap_switched_shooter (0 .5 .8) (-8 -8 -8) (8 8 8) superspike laser lavaball rocket silent
// Continuously fires spikes.
// "wait" time between spike (1.0 default)
// "nextthink" delay before firing first spike, so multiple shooters can be stagered.
// "state" 0 initially off, 1 initially on. (0 default)
//============
void() trap_switched_shooter =
{
    trap_spikeshooter ();

    if (!self.wait)
        self.wait       = 1;
    self.nextthink  = self.nextthink + self.wait + self.ltime;
    self.think      = shooter_think;
    self.use        = trap_shooter_use;
};
//- - - - - - - - -


//==========================================================================
//  Air Bubbles

// Turn on the bubble spawner.  Once only (for now).
void() bubbles_on = {self.use = SUB_Null; make_bubbles();};

//============
// --> QUAKED air_bubbles (0 .5 .8) (-8 -8 -8) (8 8 8)
//
// testing air bubbles
//============
void() air_bubbles =
{
    if (deathmatch)
        {remove (self); return;}
    precache_model ("progs/s_bubble.spr");
    self.nextthink  = time + 1;
    self.think      = make_bubbles;
// PM:  If targeted, bubble spawner must be used first.
    if (self.targetname)
    {
        self.nextthink  = -1;
        self.use        = bubbles_on;
    }
};

void() make_bubbles =
{
    local   entity  bubble;

    bubble = spawn();
    setmodel (bubble, "progs/s_bubble.spr");
    setorigin (bubble, self.origin);
    bubble.movetype     = MOVETYPE_NOCLIP;
    bubble.solid        = SOLID_NOT;
    bubble.velocity     = '0 0 15';
    bubble.nextthink    = time + 0.5;
    bubble.think        = bubble_bob;
    bubble.touch        = bubble_remove;
    bubble.classname    = "bubble";
    bubble.frame        = 0;
    bubble.cnt          = 0;
    setsize (bubble, '-8 -8 -8', '8 8 8');

    self.nextthink      = time + random() + 0.5;
    self.think          = make_bubbles;
};

void() bubble_split =
{
    local   entity  bubble;

    bubble = spawn();
    setmodel (bubble, "progs/s_bubble.spr");
    setorigin (bubble, self.origin);
    bubble.movetype     = MOVETYPE_NOCLIP;
    bubble.solid        = SOLID_NOT;
    bubble.velocity     = self.velocity;
    bubble.nextthink    = time + 0.5;
    bubble.think        = bubble_bob;
    bubble.touch        = bubble_remove;
    bubble.classname    = "bubble";
    bubble.frame        = 1;
    bubble.cnt          = 10;
    setsize (bubble, '-8 -8 -8', '8 8 8');

    self.frame          = 1;
    self.cnt            = 10;
    if (self.h2olevel != 3)
        remove (self);
};

void() bubble_remove =
{
    if (other.classname == self.classname)
        return;     // Bubble bumped another bubble.  Had 'dprint ("bump");'.
    remove (self);
};

void() bubble_bob =
{
    local   float   rnd1, rnd2, rnd3;

    self.cnt = self.cnt + 1;
    if (self.cnt == 4)
        bubble_split ();
    if (self.cnt == 20)
        remove (self);

    rnd1 = self.velocity_x + (-10 + (random() * 20));
    rnd2 = self.velocity_y + (-10 + (random() * 20));
    rnd3 = self.velocity_z + 10 + random() * 10;

    if (rnd1 > 10)
        rnd1 = 5;
    if (rnd1 < -10)
        rnd1 = -5;
        
    if (rnd2 > 10)
        rnd2 = 5;
    if (rnd2 < -10)
        rnd2 = -5;
        
    if (rnd3 < 10)
        rnd3 = 15;
    if (rnd3 > 30)
        rnd3 = 25;
    
    self.velocity_x = rnd1;
    self.velocity_y = rnd2;
    self.velocity_z = rnd3;
        
    self.nextthink  = time + 0.5;
    self.think      = bubble_bob;
};


// Was in old 'player.qc'.
void() DeathBubblesSpawn =
{
    if (self.owner.h2olevel != 3)
    {
        remove (self);
        return;
    }

    local   entity  bubble;

    bubble = spawn();
    setmodel (bubble, "progs/s_bubble.spr");
    setorigin (bubble, self.owner.origin + '0 0 24');
    bubble.movetype     = MOVETYPE_NOCLIP;
    bubble.solid        = SOLID_NOT;
    bubble.velocity     = '0 0 15';
    bubble.nextthink    = time + 0.5;
    bubble.think        = bubble_bob;
    bubble.classname    = "bubble";
    bubble.frame        = 0;
    bubble.cnt          = 0;
    setsize (bubble, '-8 -8 -8', '8 8 8');
    self.nextthink      = time + 0.1;
    self.think          = DeathBubblesSpawn;
    self.air_finished   = self.air_finished + 1;

    if (self.air_finished >= self.bubble_count)
        remove (self);
};

void(float num_bubbles) DeathBubbles =
{
    local   entity  bubble_spawner;
    
    bubble_spawner = spawn();
    setorigin (bubble_spawner, self.origin);
    bubble_spawner.movetype     = MOVETYPE_NONE;
    bubble_spawner.solid        = SOLID_NOT;
    bubble_spawner.nextthink    = time + 0.1;
    bubble_spawner.think        = DeathBubblesSpawn;
    bubble_spawner.air_finished = 0;
    bubble_spawner.owner        = self;
    bubble_spawner.bubble_count = num_bubbles;
};

void(entity ent) MakeBubble =
{
    local   entity  bubble_spawner;
    
    bubble_spawner = spawn();
    setorigin (bubble_spawner, self.origin);
    bubble_spawner.movetype     = MOVETYPE_NONE;
    bubble_spawner.solid        = SOLID_NOT;
    bubble_spawner.nextthink    = time + 0.1;
    bubble_spawner.think        = DeathBubblesSpawn;
    bubble_spawner.air_finished = 0;
    bubble_spawner.owner        = ent;
    bubble_spawner.bubble_count = 1;
};

// FIXME:  Are there any custom maps that call this function via
//  info_notnull or other related shenannigans?
//void() PainBubble =
//{
//    if (self.h2otype == CONTENT_WATER || self.h2otype == CONTENT_SLIME)
//        DeathBubbles (1);
//};


//==========================================================================
//  Teleglitter

// NOTE:  We should not emulate Heretic's algorithm for teleglitter spawners
// because that produces too many edicts, which can cause packet overflow
// in standard engines.  Therefore, particles are sometimes spawned instead
// of sprites, and glitter sprites start with some velocity so they can
// collide with the ceiling sooner and disappear.

void() glitter_think =
{
    if (self.frame >= self.waitmax)
    {
        if (self.cnt > 5)   // 5 rewinds give 3 sec. life -- long enough.
            {remove (self);  return;}
        self.cnt = self.cnt + 1;
        self.frame = self.waitmin;
    }
    else
        self.frame = self.frame + 1;

    if (self.height)
    {   // Accelerate.
        self.speed = self.speed + self.height;
        self.velocity = self.movedir * self.speed;
    }

    self.nextthink = time + self.delay;
};

void() make_glitter =
{
// Show some fireworks.
    local   vector  spot, vel;
    local   float   rgb;

    spot_x = self.absmin_x + (random() * self.size_x);
    spot_y = self.absmin_y + (random() * self.size_y);
    spot_z = self.absmin_z + (random() * self.size_z);
    vel = self.movedir * self.speed;
    rgb = self.count;   //(serverflags & 15) * 16;

    if (self.lefty)
    {
    // Show particles only if the client can see the spawn point.
    // We need this check because in software mode (WinQuake),
    // a client can see particles through non-world wall entities
    // if said client is a long distance away.
        local   float   go;

        go = TRUE;
        if (!(deathmatch || coop))      // Don't try this in netgames.
        {
            local   entity  targ;

            targ = checkclient ();
            if (targ)
            {
                traceline (targ.origin + targ.view_ofs, spot, TRUE, targ);
                if (trace_fraction < 1)
                    go = FALSE;
            }
            else
                go = FALSE;
        }
        if (go)
        {
            if (rgb > 251)
                rgb = 9;
            else if (rgb > 246)
                rgb = 225;
            else if (rgb > 243)
                rgb = 41;
            else if (rgb > 239)
                rgb = 193;
            particle (spot, vel*0.1, rgb, 10);
        }
    }
    else
    {   // Heretic-style teleglitter.
        if (rgb > 251)
            rgb = 90;
        else if (rgb > 246)
            rgb = 85;
        else if (rgb > 243)
            rgb = 80;
        else
            rgb = floor(rgb / 16) * 5;

        newmis = spawn();
        setmodel (newmis, "progs/s_spark.spr");
        setorigin (newmis, spot);
        newmis.movetype     = MOVETYPE_FLY;
        newmis.solid        = SOLID_TRIGGER;
        newmis.velocity     = vel;
        newmis.delay        = 0.1;
        newmis.nextthink    = time + newmis.delay;
        newmis.think        = glitter_think;
        newmis.touch        = SUB_Remove;
        newmis.classname    = "glitter";
        newmis.frame        = rgb;
        newmis.cnt          = 0;
        // Note:  If glitter start splashing, change size to '0 0 0'.
        setsize (newmis, '-1 -1 -1', '1 1 1');
        newmis.movedir      = self.movedir;
        newmis.speed        = self.speed;
        newmis.waitmin      = newmis.frame;
        newmis.waitmax      = newmis.frame + 4;
        newmis.height       = self.height;
    }
    self.lefty = !self.lefty;   // Alternate between particles and sprites.

    self.nextthink      = time + self.wait;
    self.think          = make_glitter;
};

//============
// --> QUAKED misc_glitter (0 .5 .8) (-8 -8 -8) (8 8 8)
// Heretic-style teleglitter generator.  Use on exit or teleport pads.
// Otherwise, similar idea to air_bubbles.
//============
void() misc_glitter =
{
    if (self.classname == "misc_glitter")
    {   // Merely a glitter spawner.
        if (deathmatch)
            {remove (self); return;}
        setsize (self, '-16 -16 -8', '16 16 48');
    }
    else
    {   // Teleporter destination with glitter spawnflag on.
        if (deathmatch)
            return;
        // Destinations are set 27 units above placement, so subtract
        // that much from new bbox mins/maxs_z to get proper bounds.
        // Update:  z - 26 should do.
        setsize (self, '-16 -16 -34', '16 16 22');
//        self.angles = '0 0 0';
    }
    precache_model ("progs/s_spark.spr");

    if (!self.wait)
        self.wait   = 0.1;
    if (!self.count)        // Palette color.
        self.count  = 244;  // Default is bright electric blue.
    if (!self.speed)
        self.speed  = 100;
    if (!self.height)
        self.height = 50;   // Acceleration per frame for teleglitter.

// Sparks should fly up by default.  An angle of 0 is assumed to mean
// undefined, so to force east flight path, use a yaw of 360 instead.
    if (self.angles != '0 0 0')
        SetMovedir ();
    else
        self.movedir = '0 0 1';

    self.nextthink  = time + 1;
    self.think      = make_glitter;
};

//- - - - - - - - -
// Creates a glitter spawner.  Called by spawn functions of other entities
// such as teleporter and changelevel triggers, and used by them to create
// glittering teleporter pads like in Heretic.
//- - - - - - - - -
void() Glitter_Spawner =
{
    if (deathmatch)
        return;     // Disabled, so don't waste time spawning an entity.

    local   entity  test;
    local   vector  spot;

    spot = Anypoint (self, '0.5 0.5 0');    //Midpoint (self);
    spot_z = spot_z + 8;
    test = spawn();
    test.classname  = "misc_glitter";
    test.count      = self.count;       // Glitter color
    setorigin (test, spot);
    SUB_Think (test, misc_glitter);
};


//==========================================================================
//  Big Bell

// Note to self:  ATTN_NORM, which equals 1, has a maximum range of 1000.
// ATTN_NONE, which equals 0, is heard at full volume anywhere.  The bell
// should be heard much further away than a distance of 1000, yet shouldn't
// be heard at full volume everywhere.  Armagon uses attenuation of 0.5,
// which lets him be heard up to a distance of 2000.  Since the bell should
// be heard up to at least 4000, use 0.25.  For up to 8000, use 0.125.

// This animates the bell.
// Hexen2 bell frames:  <ringA: 0-30>, <ringB: 31-51>
void() bell_ring =[ 0, bell_ring ]
{
    self.walkframe = self.walkframe + 1;
    if (self.walkframe >= self.waitmax)
    {   // Done ringing and animating.
        self.frame = self.walkframe = 0;
        self.think = SUB_Null;
        return;
    }
    self.frame = self.waitmin + self.walkframe;

// Big bell should be heard from long distance, see attenuation note above.
    if (!self.waitmin)  // Using ringing anim if TRUE.
        if ((self.frame == 2) || (self.frame == 7) || (self.frame == 11))
            sound (self, CHAN_AUTO, "misc/bellring.wav", 1, 0.2);
};

// Self-explanatory -- called when bell gets used.
void() bell_use =
{
    if (self.frame)
        if (self.frame <= 12)
            return;     // Already ringing.
    self.walkframe = 0;
    self.waitmin = 0;  self.waitmax = 30;
    bell_ring ();
};

// Called when bell takes a big hit.
void() bell_bighit =
{
    self.takedamage = DAMAGE_YES;
    self.health = self.max_health;      // Reset for the next hit.
    bell_use();
};

// Called when bell takes a small hit.
void(entity attacker, float damage) bell_hit =
{
    self.health = self.max_health;      // Reset for the next hit.
    if (damage < 20)
    {   // Small hit.
        if (self.frame)
            if (self.frame < 47)
                return;     // Too much momemtum to overcome.
        self.walkframe = 10;
    }
    else
    {   // Medium hit.
        if (self.frame)
        {
            if (self.frame < 18)
                return;     // Bell still ringing from use.
            if (self.frame >= 31)
                if (self.frame < 41)
                    return;     // Bell still has extra momemtum.
        }
        self.walkframe = 0;
    }
    self.waitmin = 31;  self.waitmax = 21;
    bell_ring ();

    attacker = attacker;    // Appease FrikQcc.
};

//============
// --> QUAKED misc_bell (0 .5 .8) (-64 -64 -80) (64 64 88)
// Huge bell.  Use in belltowers.
//
// Note:  This is a modified Hexen2 bell.  The model was shifted upward
// by 112 pixels.
//
// In Hexen2, bell has a hull from '-100 -100 -210' to '100 100 8'.
//============
void() misc_bell =
{
    cache_set ("progs/bellring.mdl");
    precache_sound ("misc/bellring.wav");
    setsize (self, '-64 -64 -80', '64 64 88');
    self.movetype   = MOVETYPE_NONE;
    self.velocity   = '0 0 0';
    self.touch      = SUB_Null;
    self.solid      = SOLID_BBOX;
    self.use        = bell_use;
    self.th_pain    = bell_hit;
    self.th_die     = bell_bighit;
    self.frame      = 0;
    self.max_health = self.health   = 200;
    self.takedamage = DAMAGE_YES;
};


//==========================================================================
//  Decorations

void(string gibname) ThrowTreeChunks;       // FIXME:  Move elsewhere?

//============
// PlaceDecor
//
// plants the object on the floor
//============
void() PlaceDecor =
{
    self.solid      = SOLID_BBOX;
    self.movetype   = MOVETYPE_TOSS;    
    self.velocity   = '0 0 0';
    self.origin_z   = self.origin_z + 1;    // Other items used +6.
    if (!droptofloor ())
    {
        print_self (self.classname, " fell out of level at ");
        remove (self);
        return;
    }
};

//============
// --> QUAKED misc_decor (0 .5 .8) ?
// Miscellaneous solid object that just sits there.
//============
void() misc_decor =
{
    if (!self.mdl)
    {   // Default to Zerstorer tree.
        self.mdl = "progs/tree_zer.mdl";
        self.pos1 = '-16 -16 0';
        self.pos2 = '16 16 86';
    }
    cache_set (self.mdl);
    setsize (self, self.pos1, self.pos2);

    self.nextthink  = time + 0.2;   // items start after other solids
    self.think      = PlaceDecor;
};

//- - - - - - - - -
void(float loop, float dm) statue_pieces =
{
    local   float   hp;

// PM:  Use Drake gib functions so that carnivores can't eat tree splinters.
    hp = self.health;
    self.health = dm;   // So the rocks have some velocity.
    sound (self, CHAN_AUTO, "misc/wallbrk.wav", 1, ATTN_NORM);
    do
    {
        if (random() < 0.5)
            ThrowTreeChunks ("progs/imp_rock.mdl");
        else
            ThrowTreeChunks ("progs/st_gib3.mdl");
        loop = loop - 1;
    } while (loop > 0);
    self.health = hp;
};

void() statue_crumble =
{
    monster_death_use ();

    statue_pieces (8, self.health);

// PM:  Don't remove self now because we may be in the middle of a
// damage chain, such as one made by T_RadiusDamage.
    self.modelindex = mindex_inviso;    // Disappear.
    self.nextthink = time + 0.1;
    self.think = SUB_Remove;

    self.solid = SOLID_NOT;
    self.takedamage = DAMAGE_NO;
};

// If a client stands on a statue, smash it.  Stops client from using
// the statue as a platform to reach places he shouldn't yet.
void() crumble_check =
{
    if (other.flags & FLx_CREATURE)
        if (other.movetype == MOVETYPE_WALK)
            if (other.health > 0)
//                if (other.absmin_z >= self.absmax_z)
                if (other.origin_z + other.mins_z >= self.origin_z + self.maxs_z)
                {   // Crumble after touch loop.
                    self.touch = SUB_Null;
                    self.nextthink = time + 0.1;
                    self.think = statue_crumble;
                }
};
//- - - - - - - - -

//============
// --> QUAKED misc_statue (.8 .5 .5) (-32 -32 -24) (32 32 80)
// A statue of the player.  Used in soeexit.bsp.
//============
void() misc_statue =
{
    if (world.model == "maps/soeexit.bsp")
    {   // PM:  Replaced by bigger player model made for this purpose.
        self.mdl    = "progs/hero.mdl";
        self.skin   = 0;
        self.frame  = 0;
        self.pos1   = '-32 -32 -24';
        self.pos2   = '32 32 80';
        self.touch  = barrel_touch;     // Walk on statue.
    }
    else
    {   // Default to angel statue.  Since the model is rectangular,
        // calculate the bbox dimensions.
        local   vector  trig;
        local   float   vx, vy;

        trig = CoSine (self.angles_y);
        vx = fabs(16 * trig_x) & 31 + 32;
        vy = fabs(16 * trig_y) & 31 + 32;

        self.mdl    = "progs/anglstat.mdl";
        self.skin   = 0;
        self.frame  = 0;
        self.pos1_x = 0 - vx;
        self.pos1_y = 0 - vy;
        self.pos1_z = 0;
        self.pos2_x = vx;
        self.pos2_y = vy;
        self.pos2_z = 120;
        self.touch  = crumble_check;

        precache_model ("progs/imp_rock.mdl");
        precache_model ("progs/st_gib3.mdl");
        precache_sound ("misc/wallbrk.wav");
    }

    misc_decor ();
};

//============
// --> QUAKED misc_statue_angel (.8 .5 .5) (-60 -60 -0) (60 60 120)
// A statue of Hexen2's praying angel.  For Arcanum.
//============
void() misc_statue_angel = {misc_statue ();};


//==========================================================================
//  Trees

void() tree_pain =
{
    if (self.pain_finished > time)
        return;

    sound (self, CHAN_VOICE, "misc/met2wd.wav", 1, ATTN_NORM);
    self.pain_finished = time + 0.1;    //2;
};

void() tree_die =   //[ 0, SUB_Remove]
{
    monster_death_use ();

    sound (self, CHAN_VOICE, "misc/woodbrk.wav", 1, ATTN_NORM);

// PM:  Use Drake gib functions so that carnivores can't eat tree splinters.
    if (self.health > -50)
        self.health = -50;  // So gibs have some velocity.
    ThrowTreeChunks ("progs/rubble1.mdl");
    ThrowTreeChunks ("progs/rubble2.mdl");
    ThrowTreeChunks ("progs/rubble3.mdl");
    ThrowTreeChunks ("progs/rubble4.mdl");

// PM:  Don't remove self now because we may be in the middle of a
// damage chain, such as one made by T_RadiusDamage.
    self.modelindex = mindex_inviso;    // Disappear.
    self.nextthink = time + 0.1;
    self.think = SUB_Remove;

    self.solid = SOLID_NOT;
    self.takedamage = DAMAGE_NO;
};

//============
// --> QUAKED misc_tree (0 .5 .8) (-16 -16 0) (16 16 86)
// A tree!
//============
void() misc_tree =
{
    self.cnt = floor(self.cnt);
    if ((self.cnt < 0) || (self.cnt > 3))
        self.cnt = 0;

// FIXME:  Reverse for Drake.
    if (!self.cnt)
    {
        self.mdl = "progs/tree.mdl";
        self.pos1 = '-16 -16 0';
        self.pos2 = '16 16 128';

        // Update 2/12/2011:  Snow skin for unf2.
        if (world.tronyn & DJG_SNOW)
            self.skin = 1;
    }
    else
    {
        self.mdl = "progs/tree_zer.mdl";
        self.pos1 = '-16 -16 0';
        self.pos2 = '16 16 86';
        if (self.cnt == 2)
            self.skin = 1;

        // Update 2/12/2011:  Snow skin for unf2.
        if (world.tronyn & DJG_SNOW)
            self.skin = 2;
    }

    if (self.spawnflags & 1)
    {
        if (!self.health)
            self.health = 200;
        self.max_health = self.health;
        self.th_pain = tree_pain;
        self.th_die  = tree_die;
        self.takedamage = DAMAGE_YES;   // PM:  Don't use damage_aim.
        precache_model ("progs/rubble1.mdl");
        precache_model ("progs/rubble2.mdl");
        precache_model ("progs/rubble3.mdl");
        precache_model ("progs/rubble4.mdl");
        precache_sound ("misc/met2wd.wav");
        precache_sound ("misc/woodbrk.wav");
        self.bloodtype = 17;    // Roughly tree sap color.
    }
    else
        self.takedamage = DAMAGE_NO;

    misc_decor ();
};

// Zerstorer's tree entity.  Converted for Drake.
void() item_tree = {self.classname = "misc_tree";  misc_tree ();};


//==========================================================================
//  OUM Specialities

void() eye_candy_frames =
{
    self.nextthink = time + self.delay;

    if (self.spawnflags & 1)
        self.frame = self.frame - 1;
    else
        self.frame = self.frame + 1;

    if (self.frame > self.waitmax)
        self.frame = self.waitmin;
    else if (self.frame < self.waitmin)
        self.frame = self.waitmax;
};

void() eye_candy =
{
    local   vector  emin, emax, ang;

    emin = self.mins;
    emax = self.maxs;
    ang = self.angles;

    self.movetype = MOVETYPE_FLY;
    if (self.solid)
        self.solid = SOLID_BBOX;
    else
        self.solid = SOLID_NOT;

    if (world.model == "maps/oum4.bsp")
        self.model = "progs/pl_oum.mdl";    // Use Zer/OUM's player model
    else if (!self.model)
        self.model = "progs/player.mdl";
    cache_set (self.model);

    if (self.waitmin || self.waitmax)
    {
        self.frame = self.waitmin;
        if (!self.delay)
            self.delay = 0.1;
        self.nextthink = time + self.delay;
        self.think = eye_candy_frames;
    }
    setsize (self, emin, emax);

    ang_x = 0 - anglemod(ang_x);
    ang_y = anglemod(ang_y);
    ang_z = anglemod(ang_z);
    self.angles = ang;
};


//===========================================================================
//
//  HIPNOTIC ADDITIONS
//
//===========================================================================

//--------------------
// hipholes.qc.
//--------------------

//============
// --> QUAKED wallsprite (0 1 0) (-8 -8 -8) (8 8 8)
// Places a sprite on a wall.  Angles should be opposite of face.
//
// "model" sprite to place on wall.  Default is "progs/s_blood1.spr".
//============
void() wallsprite =
{
    if (!self.model)
        self.model = "progs/s_blood1.spr";

    cache_set (self.model);

    // QuakeEd doesn't save up and down angles properly.
    if (self.angles == '0 -1 0')
        self.angles = '-90 0 0';
    else if (self.angles == '0 -2 0')
        self.angles = '90 0 0';

    // Pull the sprite away from the wall slightly to
    // get rid of z sort errors.
    makevectors (self.angles);
    setorigin (self, self.origin - ( v_forward * 0.2 ) );
    makestatic (self);
};

// Removed bullethole code.  I don't want to tangle up the weapons code
// with it.  Also, in very dark levels, such as those in Zerstorer, the
// outline of the bulletholes can be very bright (because all sprites
// are drawn fullbright), compared to the walls, ruining the mood.
//
// Also, some custom Quake engines, such as DarkPlaces and Qrack,
// have their own wall scorch marks for bullet holes and the like.
//
// In addition, some gl engines blend the graphics, which means the
// transparent color sometimes gets changed into a different color,
// and is no longer transparent.  This results in a pinkish outline
// surrounding the sprite.


//--------------------
// hipitems.qc
//--------------------

void() trap_gravity_touch =
{
    if ( self.attack_finished > time )
        return;

    if (other.takedamage)
    {
        if (self.dmg)
            T_Damage (other, self, self, self.dmg);
        else
            T_Kill (other, self, self, -99, "");
        self.attack_finished = time + 0.2;
    }
};

void() trap_gravity_think =
{
    local   vector  vel;
    local   entity  head;
    local   float   hits;

    self.ltime = time;      // PM:  Does this do anything useful?
    self.nextthink = time + 0.1;

    hits = 0;
    head = findradius(self.origin, self.distance);
    while (head)
    {
        if(!(head.flags & FL_NOTARGET))
        if (head.flags & self.cnt)
        if (head.health > 0)
        if (head.mass)      // PM:  Drake
//        if (head.struck_by_mjolnir==0)      // PM:  What?!
        if (visible (head))
        {
            vel = normalize (self.origin - head.origin) * self.speed;
            // PM:  SoE replaces Drake's scuba with radsuit.
            if (head.radsuit_finished)
                if (self.spawnflags & 2)    //UNDERWATER
                    vel = vel * 0.6;
            if (head.mass == MASS_SUPER)
                vel = vel * 0.5;
            head.velocity = head.velocity + vel;
            hits = hits + 1;
            if (hits >= self.count)
                return;
        }
        head = head.chain;
    }
};

//============
// --> QUAKED trap_gravity_well (.8 .5 0) (-8 -8 -8) (8 8 8) targetenemies UNDERWATER
// targets enemies in vicinity and draws them near, gibbing them on contact.
//
// UNDERWATER cuts the pull in half for players wearing the wetsuit
//
// "distance" how far the gravity well should reach (600 default)
// "count" number of people to target (2 default)
// "speed" is how strong the pull is. (210 default)
// "dmg" is how much damage to do each touch. (10000 default)
//============
void() trap_gravity_well =
{
    self.solid = SOLID_TRIGGER;
    self.movetype = MOVETYPE_NONE;
    setsize( self, '-16 -16 -16','16 16 16');
    if (!self.dmg)
        self.dmg = 10000;
    if (!self.speed)
        self.speed = 210;
    if (!self.distance)
        self.distance = 600;
//    if (!self.count)        // PM:  This is missing in hipitems.qc.
//        self.count = 2;
    if (self.spawnflags & 1)
        self.cnt = FL_CLIENT | FL_MONSTER;
    else
        self.cnt = FL_CLIENT;

    self.attack_finished = 0;
    self.think = trap_gravity_think;
    self.touch = trap_gravity_touch;
    self.oldenemy = world;
    self.nextthink = time + 0.1;
    self.ltime = time;
};


//===========================/  END OF FILE  /===========================//
