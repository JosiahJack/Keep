//===========================================================================
//  Sounds
//===========================================================================

//void() thunder_go_boom =
//{
//    if (random() < 0.5)
//        sound (self, CHAN_AUTO, "ambience/thunder1.wav", 0.5, ATTN_NONE);
//    else
//        sound (self, CHAN_AUTO, "ambience/thunder2.wav", 0.5, ATTN_NONE);
//    self.think = thunder_go_boom;
//    self.nextthink = time + 40*random();
//};

//============
// --> QUAKED ambient_sound (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
// Generic ambient sound entity.
//============
void() ambient_sound =
{
// Confirm settings.
    if (!self.noise)
    {
        objerror ("ambient_sound: no noise");
        remove (self);
        return;
    }

    if (!self.volume)
        self.volume = 1;

    if (!self.speed)
        self.speed = ATTN_STATIC;   // Most ambient sounds use this.
    else if (self.speed < 0)
        self.speed = ATTN_NONE;

// Engage!
    precache_sound (self.noise);
    ambientsound (self.origin, self.noise, self.volume, self.speed);
};
// Quoth's version of all-purpose ambient sound function.
void() ambient_generalpurpose =
{
    if (!self.speed)
        self.speed = ATTN_NORM;     // Quoth compatibility.
    ambient_sound ();
};

// Attenuation is preset to 3.
void(string sfx, float vol) ambient_sfx =
{
    if (!vol)
        vol = 1;
    precache_sound (sfx);
    ambientsound (self.origin, sfx, vol, ATTN_STATIC);
};

// Standard Quake ambient sounds.
void() ambient_comp_hum     = {ambient_sfx ("ambience/comp1.wav", 1);};
void() ambient_drip         = {ambient_sfx ("ambience/drip1.wav", 0.5);};
void() ambient_drone        = {ambient_sfx ("ambience/drone6.wav", 0.5);};
void() ambient_fire         = {ambient_sfx ("ambience/fire1.wav", 0.5);};
void() ambient_flouro_buzz  = {ambient_sfx ("ambience/buzz1.wav", 1);};
void() ambient_light_buzz   = {ambient_sfx ("ambience/fl_hum1.wav", 0.5);};
void() ambient_thunder      = {ambient_sfx ("ambience/thunder1.wav", 0.5);};
//{
//    precache_sound ("ambience/thunder1.wav");
//    precache_sound ("ambience/thunder2.wav");
//    self.think = thunder_go_boom;
//    self.nextthink = time + 0.1 + random();
//};
void() ambient_suck_wind    = {ambient_sfx ("ambience/suck1.wav", 1);};
void() ambient_swamp1       = {ambient_sfx ("ambience/swamp1.wav", 0.5);};
void() ambient_swamp2       = {ambient_sfx ("ambience/swamp2.wav", 0.5);};
// Zerstorer ambient sounds!
void() ambient_rain         = {ambient_sfx ("ambience/rain.wav", 1);};
void() ambient_zend1        = {ambient_sfx ("ambience/zend1.wav", 0.9);};
void() ambient_zend2        = {ambient_sfx ("ambience/zend2.wav", 0.9);};
void() ambient_zend6        = {ambient_sfx ("ambience/zend6.wav", 0.6);};
// Hipnotic ambient sounds!
void() ambient_humming      = {ambient_sfx ("ambience/humming.wav", self.volume);};
void() ambient_rushing      = {ambient_sfx ("ambience/rushing.wav", self.volume);};
void() ambient_running_water= {ambient_sfx ("ambience/runwater.wav", self.volume);};
void() ambient_fan_blowing  = {ambient_sfx ("ambience/fanblow.wav", self.volume);};
void() ambient_waterfall    = {ambient_sfx ("ambience/waterfal.wav", self.volume);};
void() ambient_riftpower    = {ambient_sfx ("ambience/riftpowr.wav", self.volume);};
// Soul of Evil
void() ambient_wind1        = {ambient_sfx ("ambience/wind1.wav", 1);};
void() ambient_lava1        = {ambient_sfx ("ambience/lava1.wav", 1);};
void() ambient_water1       = {ambient_sfx ("ambience/current1.wav", 1);};
void() ambient_water2       = {ambient_sfx ("ambience/mov_watr.wav", 1);};
void() ambient_throb1       = {ambient_sfx ("ambience/amb21.wav", 1);};
void() ambient_throb2       = {ambient_sfx ("ambience/amb22.wav", 1);};
void() ambient_throb3       = {ambient_sfx ("ambience/amb23.wav", 1);};
void() ambient_throb4       = {ambient_sfx ("ambience/amb24.wav", 1);};

//============
// --> QUAKED misc_noisemaker (1 0.5 0) (-10 -10 -10) (10 10 10)
// For optimzation testing, starts a lot of sounds.
//============
void() misc_noisemaker = {remove(self);};

// Full 'misc_noisemaker' code below.
//void() noise_think =
//{
//    self.think = time + 0.5;
//    sound (self, 1, "enforcer/enfire.wav", 1, ATTN_NORM);
//    sound (self, 2, "enforcer/enfstop.wav", 1, ATTN_NORM);
//    sound (self, 3, "enforcer/sight1.wav", 1, ATTN_NORM);
//    sound (self, 4, "enforcer/sight2.wav", 1, ATTN_NORM);
//    sound (self, 5, "enforcer/sight3.wav", 1, ATTN_NORM);
//    sound (self, 6, "enforcer/sight4.wav", 1, ATTN_NORM);
//    sound (self, 7, "enforcer/pain1.wav", 1, ATTN_NORM);
//};
//void() misc_noisemaker =
//{
//    precache_sound2 ("enforcer/enfire.wav");
//    precache_sound2 ("enforcer/enfstop.wav");
//    precache_sound2 ("enforcer/sight1.wav");
//    precache_sound2 ("enforcer/sight2.wav");
//    precache_sound2 ("enforcer/sight3.wav");
//    precache_sound2 ("enforcer/sight4.wav");
//    precache_sound2 ("enforcer/pain1.wav");
//};


//===========================================================================
//  Lights
//===========================================================================

float START_OFF = 1;
float ARCANUM_STORM = 2;    // Arcanum:  Light switching.

void() light_use =
{
    if (self.spawnflags & START_OFF)
    {
        if (self.spawnflags & ARCANUM_STORM)
        {
            local   float   r;

            r = random() * 4 & 3;
            if (r == 1)
                lightstyle (self.style, "zxvt");    //mkhj");
            else if (r == 2)
                lightstyle (self.style, "o");
            else if (r == 3)
                lightstyle (self.style, "abcdefghijklmlkjihgfedcb");
            else
                lightstyle (self.style, "mkhjhk");
        }
        else
            lightstyle (self.style, "m");
        self.spawnflags = self.spawnflags - START_OFF;
    }
    else
    {
        lightstyle (self.style, "a");
        self.spawnflags = self.spawnflags + START_OFF;
    }
};

// PM: NEW!
void() light_setup =
{
    if (self.style < 32)
        return;

    self.use = light_use;
    if (self.spawnflags & START_OFF)
        lightstyle (self.style, "a");
    else
        lightstyle (self.style, "m");
};

// PM: Zer...
void() ambient_fire_check =
{
//    if (zerstorer)
//        if (self.spawnflags & 2)
//            return;

    ambient_fire ();
};

//============
// --> QUAKED light (0 1 0) (-8 -8 -8) (8 8 8) START_OFF
// Non-displayed light.
// Default light value is 300
// Default style is 0
// If targeted, it will toggle between on or off.
//============
void() light =
{
    if (!self.targetname)   // inert light
        {remove (self); return;}

    light_setup ();
};

//============
// --> QUAKED light_fluoro (0 1 0) (-8 -8 -8) (8 8 8) START_OFF
// Non-displayed light.
// Default light value is 300
// Default style is 0
// If targeted, it will toggle between on or off.
// Makes steady fluorescent humming sound
//============
void() light_fluoro =
{
    light_setup ();
    ambient_light_buzz ();
};

//============
// --> QUAKED light_fluorospark (0 1 0) (-8 -8 -8) (8 8 8)
// Non-displayed light.
// Default light value is 300
// Default style is 10
// Makes sparking, broken fluorescent sound
//============
void() light_fluorospark =
{
    if (!self.style)
        self.style = 10;

    // 'ambient_flouro_buzz' uses volume of '1'.
    ambient_sfx ("ambience/buzz1.wav", 0.5);
};

//============
// --> QUAKED light_globe (0 1 0) (-8 -8 -8) (8 8 8)
// Sphere globe light.
// Default light value is 300
// Default style is 0
//============
void() light_globe =
{
    cache_set ("progs/s_light.spr");
    makestatic (self);
};

//============
// --> QUAKED light_torch_small_walltorch (0 .5 0) (-10 -10 -20) (10 10 20)
// Short wall torch
// Default light value is 200
// Default style is 0
//============
void() light_torch_small_walltorch =
{
// SoE:  Gross hack: Remove torches to make room for lanterns.
    if (soul_evil)
        if (world.model == "maps/nsoe6.bsp")
            {remove (self);  return;}
//- - - - - - - - -
    cache_set ("progs/flame.mdl");
    ambient_fire_check ();
    makestatic (self);
};

//============
// --> QUAKED light_flame_large_yellow (0 1 0) (-10 -10 -12) (12 12 18)
// Large yellow flame ball
//============
void() light_flame_large_yellow =
{
    cache_set ("progs/flame2.mdl");
    self.frame = 1;
    ambient_fire_check ();
    makestatic (self);
};

//============
// --> QUAKED light_flame_small_yellow (0 1 0) (-8 -8 -8) (8 8 8) START_OFF
// Small yellow flame ball
//============
void() light_flame_small_yellow =
{
    cache_set ("progs/flame2.mdl");
    ambient_fire_check ();
    makestatic (self);
};

//============
// --> QUAKED light_flame_small_white (0 1 0) (-10 -10 -40) (10 10 40) START_OFF
// Small white flame ball
//============
void() light_flame_small_white = {light_flame_small_yellow();};

//- - - - - - - - -
// Rogue lights
//============
// --> QUAKED light_lantern (0 1 0) (-10 -10 -20) (10 10 20)
// Lantern
// Default light value is 200
// Default style is 0
//============
void() light_lantern =
{
    cache_set ("progs/lantern.mdl");
    makestatic (self);
};

//============
// --> QUAKED light_candle (0 1 0) (-4 -4 -10) (4 4 10)
// Candle
// Default light value is 200
// Default style is 0
//============
void() light_candle =
{
    cache_set ("progs/candle.mdl");
    makestatic (self);
};
//- - - - - - - - -


//===============
// Called by 'worldspawn'.
void() lightstyle_setup =
{
// Setup light animation tables. 'a' is total darkness, 'z' is maxbright.

// 0 normal
    lightstyle(0, "m");
// 1 FLICKER (first variety)
    lightstyle(1, "mmnmmommommnonmmonqnmmo");
// 2 SLOW STRONG PULSE
    lightstyle(2, "abcdefghijklmnopqrstuvwxyzyxwvutsrqponmlkjihgfedcba");
// 3 CANDLE (first variety)
    lightstyle(3, "mmmmmaaaaammmmmaaaaaabcdefgabcdefg");
// 4 FAST STROBE
    lightstyle(4, "mamamamamama");
// 5 GENTLE PULSE 1
    lightstyle(5,"jklmnopqrstuvwxyzyxwvutsrqponmlkj");
// 6 FLICKER (second variety)
    lightstyle(6, "nmonqnmomnmomomno");
// 7 CANDLE (second variety)
    lightstyle(7, "mmmaaaabcdefgmmmmaaaammmaamm");
// 8 CANDLE (third variety)
    lightstyle(8, "mmmaaammmaaammmabcdefaaaammmmabcdefmmmaaaa");
// 9 SLOW STROBE (fourth variety)
    lightstyle(9, "aaaaaaaazzzzzzzz");
// 10 FLUORESCENT FLICKER
    lightstyle(10, "mmamammmmammamamaaamammma");
// 11 SLOW PULSE NOT FADE TO BLACK
    lightstyle(11, "abcdefghijklmnopqrrqponmlkjihgfedcba");
//---------------
// Zerstorer light styles.
//    if (zerstorer)
//    {
//    // 15 LIGHTNING #1
//        lightstyle(15, "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaakaaf");
//    // 16 LIGHTNING #2
//        lightstyle(16, "aaadaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaagaa");
//    // 17 LIGHTNING #3
//        lightstyle(17, "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaia");
//    }
//---------------

// styles 32-62 are assigned by the light program for switchable lights

// 63 testing
//    lightstyle(63, "a");
};


//============
// --> QUAKED info_lightstyle (.5 .5 .5) (-8 -8 -8) (8 8 32)
// Drake entity.
// Modifies an entry in the light animation table, then removes itself.
// Can override standard values in lightstyles from 0 to 11.
//
// "style"  Lightstyle to change.  Ranges from 0 to 31.
// "message"  Light cycle.  Use lowercase letters only!
//
// Note:  Do NOT use style of 0 because lightning storm effects from
// Mjolnir and some bosses' attacks can change lightstyle 0 briefly
// before restoring it back to standard "m".
//============
void() info_lightstyle =
{
    if (!IsEmptyString (self.message))
        lightstyle (self.style & 31, self.message);
    remove (self);
};


//===========================================================================
//
//  HIPNOTIC ADDITIONS
//
//===========================================================================

// from hipmisc.qc

void() play_sound_use =
{
    if (self.spawnflags & 1)
    {
        if (self.state == 0)
        {
            self.state = 1;
            sound (self, self.impulse, self.noise, self.volume, self.speed);
        }
        else
        {
            self.state = 0;
            sound (self, self.impulse, "misc/null.wav", self.volume, self.speed);
        }
    }
    else
    {
        sound (self, self.impulse, self.noise, self.volume, self.speed);
    }
};

void() PlaySoundThink =
{
    local   float   t;
    t = self.wait * random();
    if (t < self.delay)
        t = self.delay;
    self.nextthink = time + t;
    play_sound_use();
};

//============
// --> QUAKED play_sound_triggered (0.3 0.1 0.6) (-8 -8 -8) (8 8 8) toggle
// play a sound when it is used
// "toggle" determines whether sound should be stopped when triggered again
// "volume" how loud (1 default full volume)
// "noise" sound to play
// "impulse" channel on which to play sound (0-7) (0 automatic is default)
// "speed" attenuation factor
//    -1 - no attenuation
//     1 - normal
//     2 - idle
//     3 - static
//============
void() play_sound_triggered =
{
    precache_sound (self.noise);
    precache_sound ("misc/null.wav");
    if (self.volume == 0)
        self.volume = 1;
    if (self.speed == 0)
        self.speed = 1;
    if (self.speed == -1)
        self.speed = 0;
    if (self.spawnflags & 1)
        if (self.impulse == 0)
            self.impulse = 7;
    self.use = play_sound_use;
};

//============
// --> QUAKED play_sound (0.3 0.1 0.6) (-8 -8 -8) (8 8 8)
// play a sound on a periodic basis
// "volume" how loud (1 default full volume)
// "noise" sound to play
// "wait" random time between sounds (default 20)
// "delay" minimum delay between sounds (default 2)
// "impulse" channel on which to play sound (0-7) (0 automatic is default)
// "speed" attenuation factor
//    -1 - no attenuation
//     1 - normal
//     2 - idle
//     3 - static
//============
void() play_sound =
{
    local   float   t;

    play_sound_triggered ();
    if (self.wait == 0)
        self.wait = 20;
    if (self.delay == 0)
        self.delay = 2;
    self.think = PlaySoundThink;
    t = self.wait * random();
    if (t < self.delay)
        t = self.delay;
    self.nextthink = time + t;
};

//============
// --> QUAKED random_thunder (0.3 0.1 0.6) (-10 -10 -8) (10 10 8)
// "wait" random time between strikes (default 20)
// "delay" minimum delay between strikes (default 2)
// "volume" how loud (1 default full volume)
// "speed" attenuation factor
//    -1 - no attenuation
//     1 - normal
//     2 - idle
//     3 - static
//============
void() random_thunder =
{
    self.noise = "ambience/thunder1.wav";
    play_sound ();
    self.impulse = 6;
};

//============
// --> QUAKED random_thunder_triggered (0.3 0.1 0.6) (-10 -10 -8) (10 10 8) toggle
// "toggle" determines whether sound should be stopped when triggered again
// "volume" how loud (1 default full volume)
// "speed" attenuation factor
//    -1 - no attenuation
//     1 - normal
//     2 - idle
//     3 - static
//============
void() random_thunder_triggered =
{
    self.noise = "ambience/thunder1.wav";
    play_sound_triggered();
    self.impulse = 6;
};


//===========================/  END OF FILE  /===========================//
