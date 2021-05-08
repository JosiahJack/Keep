/*
==============================================================================

SPIDER

==============================================================================
*/

$cd id1/models/spider
$origin 0 0 24
$base base        
$skin skin

$frame sgrow1 sgrow2 sgrow3 sgrow4 sgrow5 sgrow6 sgrow7

$frame swalk1 swalk2 swalk3 swalk4 swalk5 swalk6 swalk7 swalk8 swalk9
$frame swalk10 swalk11 swalk12 swalk13 swalk14 swalk15 swalk16

$frame swait1 swait2 swait3 swait4 swait5 swait6 swait7 swait8 swait9
$frame swait10 swait11 swait12 swait13 swait14 swait15 swait16 swait17
$frame swait18 swait19 swait20 swait21 swait22 swait23 swait24 swait25
$frame swait26

$frame sattak1 sattak2 sattak3 sattak4 sattak5 sattak6 sattak7 sattak8
$frame sattak9 sattak10 sattak11 sattak12

$frame sbite1 sbite2 sbite3 sbite4 sbite5 sbite6 sbite7 sbite8 sbite9
$frame sbite10

$frame jump1 jump2 jump3 jump4 jump5 jump6 jump7 jump8 jump9 jump10
$frame jump11 jump12 jump13 jump14 jump15 jump16

$frame sdpain1 sdpain2 sdpain3 sdpain4 sdpain5 sdpain6 sdpain7 sdpain8
$frame sdpain9 sdpain10

$frame supain1 supain2 supain3 supain4 supain5 supain6 supain7 supain8

$frame sdeath1 sdeath2 sdeath3 sdeath4 sdeath5 sdeath6 sdeath7 sdeath8
$frame sdeath9 sdeath10 sdeath11 sdeath12 sdeath13 sdeath14 sdeath15
$frame sdeath16 sdeath17 sdeath18 sdeath19 sdeath20

// Ceiling frames
$frame scwalk1 scwalk2 scwalk3 scwalk4 scwalk5 scwalk6 scwalk7 scwalk8 scwalk9
$frame scwalk10 scwalk11 scwalk12 scwalk13 scwalk14 scwalk15 scwalk16

$frame scwait1 scwait2 scwait3 scwait4 scwait5 scwait6 scwait7 scwait8 scwait9
$frame scwait10 scwait11 scwait12 scwait13 scwait14 scwait15 scwait16 scwait17
$frame scwait18 scwait19 scwait20 scwait21 scwait22 scwait23 scwait24 scwait25
$frame scwait26

$frame scattak1 scattak2 scattak3 scattak4 scattak5 scattak6 scattak7 scattak8
$frame scattak9 scattak10 scattak11 scattak12

$frame scbite1 scbite2 scbite3 scbite4 scbite5 scbite6 scbite7 scbite8 scbite9
$frame scbite10

$frame scdpain1 scdpain2 scdpain3 scdpain4 scdpain5 scdpain6 scdpain7 scdpain8
$frame scdpain9 scdpain10

$frame scupain1 scupain2 scupain3 scupain4 scupain5 scupain6 scupain7 scupain8

$frame detach1 detach2 detach3

$frame scdeath1 scdeath2

//=============================================================================

void() spider_cpause1;
void() spider_crun1;
void() spider_pause1;
void() spider_run1;
void() spider_detach1;

void() spider_sfx_walk =
{
    local   float   vol;
    local   string  sfx;

    if (!self.flags & FL_ONGROUND)
        if ( self.frame < $scwalk1 )
            return;     // Must be on the ground or ceiling to make sound.

    vol = random();
    if (vol < 0.33)
        sfx = "spider/step1.wav";
    else if (vol < 0.66)
        sfx = "spider/step2.wav";
    else
        sfx = "spider/step3.wav";
    vol = random() * 0.3 + 0.7;
    sound (self, CHAN_BODY, sfx, vol, ATTN_NORM);
};

void() spider_walk =
{
    local   float   dist;

    dist = self.speed / 2;
    if (random() < 0.1)
        spider_sfx_walk();
    ai_walk (dist);
};

void() spider_wait =
{
    if (self.waitmin < time)
    {
        self.waitmin = self.waitmax;
        if ( self.frame < $scwalk1 )
            spider_run1 ();     // Should be safe enough, if waitmin is set.
        else
            spider_crun1 ();
    }
};

void() spider_run_move =
{
    local   float   dist;

    dist = self.speed;
    if (!(self.spawnflags & 8))
    {   // Move erratically if not in fast mode.
        if ((self.attack_state == AS_SLIDING) || (self.attack_state == AS_DODGING))
        {
            if (random() < 0.3)
                self.attack_state = AS_STRAIGHT;
        }
        else //if (self.attack_state == AS_STRAIGHT)
        {
            if (random() < 0.1)
                self.attack_state = AS_SLIDING;
        }
        if (self.attack_state > AS_STRAIGHT)
            dist = dist / 2;
    }
    else
        dist = floor(dist * 5 / 4);

    if (random() < 0.2)
        spider_sfx_walk();

    ai_run (dist);
};

void() spider_run =
{
//- - - - - - - - -
// Check for waiting.
    if (self.fighting)
    {
        if (self.waitmin < time)
        if (random() > skill / 5)
        if (self.spawnflags & 8 == 0)   // Must not be in fast mode.
        {   // Pause.
            self.waitmin = (random() * 8 + 7) * 0.05 + time;    // How long to wait.
            self.waitmax = (random() * 16 + 16) * 0.05 + time;  // When to wait again.
            if ( self.frame < $scwalk1 )
                spider_pause1 ();
            else
                spider_cpause1 ();
            return;
        }
    }
//- - - - - - - - -
    spider_run_move ();
};

//=============================================================================

float(void() fail) OnCeiling =
{
    local   vector  p1, p2, up;

    p2 = self.origin;
    p2_z = p2_z + self.maxs_z - 1;
    p1 = p2;
    up = '0 0 18';      // or 8x+2.

    traceline (p2, p2 + up, TRUE, self);
    if (pointcontents (trace_endpos) != CONTENT_SKY)
    {
        if (trace_fraction < 1)
            return TRUE;
    
        p2_x = p1_x + self.mins_x;
        p2_y = p1_y + self.mins_y;
        traceline (p2, p2 + up, TRUE, self);
        if (trace_fraction < 1)
            return TRUE;
    
        p2_x = p1_x + self.maxs_x;
        traceline (p2, p2 + up, TRUE, self);
        if (trace_fraction < 1)
            return TRUE;
    
        p2_y = p1_y + self.maxs_y;
        traceline (p2, p2 + up, TRUE, self);
        if (trace_fraction < 1)
            return TRUE;
    
        p2_x = p1_x + self.mins_x;
        traceline (p2, p2 + up, TRUE, self);
        if (trace_fraction < 1)
            return TRUE;
    }

    fail ();
    return FALSE;
};

// Like 'droptofloor', except it tries to place 'self' at the ceiling.
float() RiseToCeiling =
{
    local   entity  swap;
    local   float   yes;

    swap = self;
    self = spawn();
    self.owner = swap;
    self.solid = swap.solid;
    self.movetype = swap.movetype;
    self.flags = FL_FLY;
    setsize (self, VEC_SPIDER_MIN, VEC_SPIDER_MAX2);
    setorigin (self, swap.origin);
    ai_up (256);    // FIXME:  256 is too much for 8 pixel steps loop.
    yes = OnCeiling (SUB_Null);
    if (yes)
    {   // Spider can cling to ceiling.
        setorigin (swap, self.origin);
// DISABLED -- Varies by monster.
          setsize (self, VEC_SPIDER_MIN, VEC_SPIDER_MAX2);  // Must do this.
//        self.flags      = self.flags | FL_FLY;
//        self.frame      = $scwalk1;     // So my code knows it's clinging.
    }
    remove (self);
    self = swap;
    return yes;
};

void() spider_ceil_stand =
{
    if (OnCeiling (spider_detach1))
        ai_stand ();
};

// For all of the ceiling movement, try to go up after each move in case
// of upward sloping ceilings (downward slope to spider).
void() spider_ceil_walk =
{
    if (OnCeiling (spider_detach1))
        {spider_walk ();  ai_up (16);}
};

void() spider_ceil_run =
{
    if (self.fighting)
        if (self.search_time < time)
            {spider_detach1();  return;}
// Note:  Spider may fly down toward enemy by 8 pixels, then go up 16.
// Motion may not be perfectly flat, but has the nice effect of letting
// the spider navigate some ceiling terrain.
    if (OnCeiling (spider_detach1))
        {spider_run ();  ai_up (24);}
};

void() spider_ceil_charge =
{
    if (OnCeiling (spider_detach1))
    {
        local   entity  swap;

        swap = self.enemy;
        self.enemy = world;     // Don't change elevation.
        ai_charge (2);
        self.enemy = swap;

        ai_up (16);
    }
};

//=============================================================================

vector() SpiderJumpVelocity =
{
    local   vector  vel;
//    local   float   lns;    // Hexen2's level*scale.

    makevectors (self.angles);

//    lns = 60;
//    vel = v_forward * (lns * 6);
//    vel_z = (lns * 5);

    // Jump like the baron and call it a day.
    // Comparison:  Fiend jumps at vx*600 + vz*250.
    if (self.spawnflags & 8)
        vel = v_forward * 750 + '0 0 180';      // Voreling
    else
        vel = v_forward * 400 + '0 0 300';      // Baron
    return vel;
};

//================
// CheckDemonJump
//================
float() CheckSpiderJump =
{
    local   vector  dist;
    local   float   d;

    if ( self.frame >= $scwalk1 )
    {   // On the ceiling, check for detach.
        if (self.enemy)
        {
            traceline (self.origin, self.origin - '0 0 1024', 2, self);
            if (trace_ent == self.enemy)
            {   // Target is underneath...
                // Note:  Spitters won't drop if they can shoot instead.
                if ((self.spawnflags & 4 == 0) || (enemy_range > RANGE_NEAR))
                    return TRUE;    // Drop on him.
            }
        }
        return FALSE;
    }

    if (self.attack_finished > time)
        return FALSE;   // Not allowed to jump for now.
//    if (!(self.flags & FL_ONGROUND))
//        return FALSE;   // Must be on the ground to jump.

// DISABLED -- Let spiders jump at players from above if we can hit.
//    if (self.origin_z + self.mins_z > self.enemy.origin_z + self.enemy.mins_z
//    + 0.75 * self.enemy.size_z)
//        return FALSE;       // Target is too low.
//        
//    if (self.origin_z + self.maxs_z < self.enemy.origin_z + self.enemy.mins_z
//    + 0.25 * self.enemy.size_z)
//        return FALSE;       // Target is too high.

    dist = self.enemy.origin - self.origin;
    dist_z = 0;
    d = vlen(dist);

    if (d < 100)
        return FALSE;       // Target is too close.
//    if (d > 400)    // Fiend used 200
//        return FALSE;
//    if (random() < 0.8)
//        return FALSE;

    dist = SpiderJumpVelocity ();
    TraceToss (self.origin, dist, FALSE, self, 3);
    if (trace_ent != self.enemy)
        return FALSE;

    return TRUE;
};

void() spider_fire1;
void() spider_cfire1;
float() SpiderCheckAttack =
{
//Returns TRUE if a melee attack would hit right now
// if close enough for slashing, go for it
    if (enemy_range == RANGE_MELEE)     // Was 'CheckDemonMelee'.
    {
        if (vlen (self.enemy.origin - self.origin) < 80)
        {
            self.attack_state = AS_MELEE;
            return TRUE;
        }
    }

    if (CheckSpiderJump ())
    {
        self.attack_state = AS_MISSILE;
        return TRUE;
    }

//- - - - - - - - -
// Spitter check
    if (self.spawnflags & 4)
    {
        if (enemy_vis)      // Should be set already during ai_run.
        if (FacingIdeal ())
        {
            local   float   chance;

            if (enemy_range == RANGE_MELEE)
                {chance = 0.9;  self.attack_finished = 0;}
            else if (enemy_range == RANGE_NEAR)
                chance = 0.2;
            else
                chance = 0;     // Spittle isn't a long range attack.

            if (random () < chance)
            {
                traceline (self.origin+self.view_ofs, self.enemy.origin+self.enemy.view_ofs, FALSE, self);
                if (trace_ent == self.enemy)
                {
                    chance = 2*random();
                    if ( self.frame < $scwalk1 )
                        spider_fire1 ();
                    else
                        spider_cfire1 ();
                    SUB_AttackFinished (chance);
                    return TRUE;
                }
            }
        }
    }
//- - - - - - - - -
    
    return FALSE;
};

//=============================================================================

// STAND - - - - - - - - - - - - - - - -
void() spider_stand1  =[ $swait1,  spider_stand2  ] {ai_stand();};
void() spider_stand2  =[ $swait2,  spider_stand3  ] {ai_stand();};
void() spider_stand3  =[ $swait3,  spider_stand4  ] {ai_stand();};
void() spider_stand4  =[ $swait4,  spider_stand5  ] {ai_stand();};
void() spider_stand5  =[ $swait5,  spider_stand6  ] {ai_stand();};
void() spider_stand6  =[ $swait6,  spider_stand7  ] {ai_stand();};
void() spider_stand7  =[ $swait7,  spider_stand8  ] {ai_stand();};
void() spider_stand8  =[ $swait8,  spider_stand9  ] {ai_stand();};
void() spider_stand9  =[ $swait9,  spider_stand10 ] {ai_stand();};
void() spider_stand10 =[ $swait10, spider_stand11 ] {ai_stand();};
void() spider_stand11 =[ $swait11, spider_stand12 ] {ai_stand();};
void() spider_stand12 =[ $swait12, spider_stand13 ] {ai_stand();};
void() spider_stand13 =[ $swait13, spider_stand14 ] {ai_stand();};
void() spider_stand14 =[ $swait14, spider_stand15 ] {ai_stand();};
void() spider_stand15 =[ $swait15, spider_stand16 ] {ai_stand();};
void() spider_stand16 =[ $swait16, spider_stand17 ] {ai_stand();};
void() spider_stand17 =[ $swait17, spider_stand18 ] {ai_stand();};
void() spider_stand18 =[ $swait18, spider_stand19 ] {ai_stand();};
void() spider_stand19 =[ $swait19, spider_stand20 ] {ai_stand();};
void() spider_stand20 =[ $swait20, spider_stand21 ] {ai_stand();};
void() spider_stand21 =[ $swait21, spider_stand22 ] {ai_stand();};
void() spider_stand22 =[ $swait22, spider_stand23 ] {ai_stand();};
void() spider_stand23 =[ $swait23, spider_stand24 ] {ai_stand();};
void() spider_stand24 =[ $swait24, spider_stand25 ] {ai_stand();};
void() spider_stand25 =[ $swait25, spider_stand26 ] {ai_stand();};
void() spider_stand26 =[ $swait26, spider_stand1  ] {ai_stand();};

void() spider_cstand1  =[ $scwait1,  spider_cstand2  ] {spider_ceil_stand();};
void() spider_cstand2  =[ $scwait2,  spider_cstand3  ] {spider_ceil_stand();};
void() spider_cstand3  =[ $scwait3,  spider_cstand4  ] {spider_ceil_stand();};
void() spider_cstand4  =[ $scwait4,  spider_cstand5  ] {spider_ceil_stand();};
void() spider_cstand5  =[ $scwait5,  spider_cstand6  ] {spider_ceil_stand();};
void() spider_cstand6  =[ $scwait6,  spider_cstand7  ] {spider_ceil_stand();};
void() spider_cstand7  =[ $scwait7,  spider_cstand8  ] {spider_ceil_stand();};
void() spider_cstand8  =[ $scwait8,  spider_cstand9  ] {spider_ceil_stand();};
void() spider_cstand9  =[ $scwait9,  spider_cstand10 ] {spider_ceil_stand();};
void() spider_cstand10 =[ $scwait10, spider_cstand11 ] {spider_ceil_stand();};
void() spider_cstand11 =[ $scwait11, spider_cstand12 ] {spider_ceil_stand();};
void() spider_cstand12 =[ $scwait12, spider_cstand13 ] {spider_ceil_stand();};
void() spider_cstand13 =[ $scwait13, spider_cstand14 ] {spider_ceil_stand();};
void() spider_cstand14 =[ $scwait14, spider_cstand15 ] {spider_ceil_stand();};
void() spider_cstand15 =[ $scwait15, spider_cstand16 ] {spider_ceil_stand();};
void() spider_cstand16 =[ $scwait16, spider_cstand17 ] {spider_ceil_stand();};
void() spider_cstand17 =[ $scwait17, spider_cstand18 ] {spider_ceil_stand();};
void() spider_cstand18 =[ $scwait18, spider_cstand19 ] {spider_ceil_stand();};
void() spider_cstand19 =[ $scwait19, spider_cstand20 ] {spider_ceil_stand();};
void() spider_cstand20 =[ $scwait20, spider_cstand21 ] {spider_ceil_stand();};
void() spider_cstand21 =[ $scwait21, spider_cstand22 ] {spider_ceil_stand();};
void() spider_cstand22 =[ $scwait22, spider_cstand23 ] {spider_ceil_stand();};
void() spider_cstand23 =[ $scwait23, spider_cstand24 ] {spider_ceil_stand();};
void() spider_cstand24 =[ $scwait24, spider_cstand25 ] {spider_ceil_stand();};
void() spider_cstand25 =[ $scwait25, spider_cstand26 ] {spider_ceil_stand();};
void() spider_cstand26 =[ $scwait26, spider_cstand1  ] {spider_ceil_stand();};

void() spider_stand_go =
{
    if (self.frame < $scwalk1 )
        spider_stand1 ();
    else
        spider_cstand1 ();
};

// WALK - - - - - - - - - - - - - - - -
void() spider_walk1  =[ $swalk1,  spider_walk2  ] {spider_walk();};
void() spider_walk2  =[ $swalk2,  spider_walk3  ] {spider_walk();};
void() spider_walk3  =[ $swalk3,  spider_walk4  ] {spider_walk();};
void() spider_walk4  =[ $swalk4,  spider_walk5  ] {spider_walk();};
void() spider_walk5  =[ $swalk5,  spider_walk6  ] {spider_walk();};
void() spider_walk6  =[ $swalk6,  spider_walk7  ] {spider_walk();};
void() spider_walk7  =[ $swalk7,  spider_walk8  ] {spider_walk();};
void() spider_walk8  =[ $swalk8,  spider_walk9  ] {spider_walk();};
void() spider_walk9  =[ $swalk9,  spider_walk10 ] {spider_walk();};
void() spider_walk10 =[ $swalk10, spider_walk11 ] {spider_walk();};
void() spider_walk11 =[ $swalk11, spider_walk12 ] {spider_walk();};
void() spider_walk12 =[ $swalk12, spider_walk13 ] {spider_walk();};
void() spider_walk13 =[ $swalk13, spider_walk14 ] {spider_walk();};
void() spider_walk14 =[ $swalk14, spider_walk15 ] {spider_walk();};
void() spider_walk15 =[ $swalk15, spider_walk16 ] {spider_walk();};
void() spider_walk16 =[ $swalk16, spider_walk1  ] {spider_walk();};

void() spider_cwalk1  =[ $scwalk1,  spider_cwalk2  ] {spider_ceil_walk();};
void() spider_cwalk2  =[ $scwalk2,  spider_cwalk3  ] {spider_ceil_walk();};
void() spider_cwalk3  =[ $scwalk3,  spider_cwalk4  ] {spider_ceil_walk();};
void() spider_cwalk4  =[ $scwalk4,  spider_cwalk5  ] {spider_ceil_walk();};
void() spider_cwalk5  =[ $scwalk5,  spider_cwalk6  ] {spider_ceil_walk();};
void() spider_cwalk6  =[ $scwalk6,  spider_cwalk7  ] {spider_ceil_walk();};
void() spider_cwalk7  =[ $scwalk7,  spider_cwalk8  ] {spider_ceil_walk();};
void() spider_cwalk8  =[ $scwalk8,  spider_cwalk9  ] {spider_ceil_walk();};
void() spider_cwalk9  =[ $scwalk9,  spider_cwalk10 ] {spider_ceil_walk();};
void() spider_cwalk10 =[ $scwalk10, spider_cwalk11 ] {spider_ceil_walk();};
void() spider_cwalk11 =[ $scwalk11, spider_cwalk12 ] {spider_ceil_walk();};
void() spider_cwalk12 =[ $scwalk12, spider_cwalk13 ] {spider_ceil_walk();};
void() spider_cwalk13 =[ $scwalk13, spider_cwalk14 ] {spider_ceil_walk();};
void() spider_cwalk14 =[ $scwalk14, spider_cwalk15 ] {spider_ceil_walk();};
void() spider_cwalk15 =[ $scwalk15, spider_cwalk16 ] {spider_ceil_walk();};
void() spider_cwalk16 =[ $scwalk16, spider_cwalk1  ] {spider_ceil_walk();};

void() spider_walk_go =
{
    if (self.frame < $scwalk1 )
        spider_walk1 ();
    else
        spider_cwalk1 ();
};

// RUN - - - - - - - - - - - - - - - - -
// NOTE:  Spiders think twice as fast as hexen2 rate,
// or four times as fast as Quake.
void() spider_run1  =[ $swalk1,  spider_run2  ] {spider_run();};
void() spider_run2  =[ $swalk3,  spider_run3  ] {spider_run();};
void() spider_run3  =[ $swalk5,  spider_run4  ] {spider_run();};
void() spider_run4  =[ $swalk7,  spider_run5  ] {spider_run();};
void() spider_run5  =[ $swalk9,  spider_run6  ] {spider_run();};
void() spider_run6  =[ $swalk11, spider_run7  ] {spider_run();};
void() spider_run7  =[ $swalk13, spider_run8  ] {spider_run();};
void() spider_run8  =[ $swalk15, spider_run1  ] {spider_run();};

void() spider_crun1  =[ $scwalk1,  spider_crun2  ] {spider_ceil_run();};
void() spider_crun2  =[ $scwalk3,  spider_crun3  ] {spider_ceil_run();};
void() spider_crun3  =[ $scwalk5,  spider_crun4  ] {spider_ceil_run();};
void() spider_crun4  =[ $scwalk7,  spider_crun5  ] {spider_ceil_run();};
void() spider_crun5  =[ $scwalk9,  spider_crun6  ] {spider_ceil_run();};
void() spider_crun6  =[ $scwalk11, spider_crun7  ] {spider_ceil_run();};
void() spider_crun7  =[ $scwalk13, spider_crun8  ] {spider_ceil_run();};
void() spider_crun8  =[ $scwalk15, spider_crun1  ] {spider_ceil_run();};

void() spider_go = {self.waitmin = time + 1 + random();
    if ( self.frame < $scwalk1 )
        spider_run1();
    else
        spider_crun1();
};

void() spider_pause1  =[ $swait1,  spider_pause2  ] {spider_wait();};
void() spider_pause2  =[ $swait3,  spider_pause3  ] {spider_wait();};
void() spider_pause3  =[ $swait5,  spider_pause4  ] {spider_wait();};
void() spider_pause4  =[ $swait7,  spider_pause5  ] {spider_wait();};
void() spider_pause5  =[ $swait9,  spider_pause6  ] {spider_wait();};
void() spider_pause6  =[ $swait11, spider_pause7  ] {spider_wait();};
void() spider_pause7  =[ $swait13, spider_pause8  ] {spider_wait();};
void() spider_pause8  =[ $swait15, spider_pause9  ] {spider_wait();};
void() spider_pause9  =[ $swait17, spider_pause10 ] {spider_wait();};
void() spider_pause10 =[ $swait19, spider_pause11 ] {spider_wait();};
void() spider_pause11 =[ $swait21, spider_pause12 ] {spider_wait();};
void() spider_pause12 =[ $swait23, spider_pause13 ] {spider_wait();};
void() spider_pause13 =[ $swait25, spider_pause1  ] {spider_wait();};

void() spider_cpause1  =[ $scwait1,  spider_cpause2  ] {spider_wait();};
void() spider_cpause2  =[ $scwait3,  spider_cpause3  ] {spider_wait();};
void() spider_cpause3  =[ $scwait5,  spider_cpause4  ] {spider_wait();};
void() spider_cpause4  =[ $scwait7,  spider_cpause5  ] {spider_wait();};
void() spider_cpause5  =[ $scwait9,  spider_cpause6  ] {spider_wait();};
void() spider_cpause6  =[ $scwait11, spider_cpause7  ] {spider_wait();};
void() spider_cpause7  =[ $scwait13, spider_cpause8  ] {spider_wait();};
void() spider_cpause8  =[ $scwait15, spider_cpause9  ] {spider_wait();};
void() spider_cpause9  =[ $scwait17, spider_cpause10 ] {spider_wait();};
void() spider_cpause10 =[ $scwait19, spider_cpause11 ] {spider_wait();};
void() spider_cpause11 =[ $scwait21, spider_cpause12 ] {spider_wait();};
void() spider_cpause12 =[ $scwait23, spider_cpause13 ] {spider_wait();};
void() spider_cpause13 =[ $scwait25, spider_cpause1  ] {spider_wait();};

// Called when spawned by a monster.
void() spider_grow1  =[ $sgrow1,  spider_grow2  ] {self.pain_finished = time + 1;};
void() spider_grow2  =[ $sgrow2,  spider_grow3  ] {};
void() spider_grow3  =[ $sgrow3,  spider_grow4  ] {};
void() spider_grow4  =[ $sgrow4,  spider_grow5  ] {};
void() spider_grow5  =[ $sgrow5,  spider_grow6  ] {};
void() spider_grow6  =[ $sgrow6,  spider_grow7  ] {};
void() spider_grow7  =[ $sgrow7,  spider_grow8  ] {};
void() spider_grow8  =[ $swait1,  spider_run1   ] {};

// ATTACK - - - - - - - - - - - - - - -
// Fires a single arcing shot at the player.
// Note:  Spiders are simple-minded bugs driven by instinct.
// Don't give them fancy targeting skills such as aiming to intercept.
void(vector st) SpiderFire =
{
    local   vector  p1, p2;
    local   float   sped;

    // Hull used to be mins_z = 0.  Now it is mins_z = -16.
    // This line of code is here so I don't need to change all SpiderFire
    // calls if the model/hull gets changed again.
    st_z = st_z + self.mins_z;

    sped = 800;
    makevectors (self.angles);
    p1 = self.origin + v_forward*st_x + v_right*st_y + v_up*st_z;
    p2 = self.enemy.origin + self.enemy.view_ofs;
    p2 = Maim_Toss (p1, p2, sped, 200, world, '0 0 0');

    sound (self, CHAN_WEAPON, "spider/attack.wav", 1, ATTN_NORM);
    Acid_Toss (p1, p2, sped);
};

// Normal firing anim.
void() spider_fire1  =[ $sattak1,  spider_fire3  ] {ai_face();};
void() spider_fire3  =[ $sattak5,  spider_fire5  ] {ai_face();};
void() spider_fire5  =[ $sattak9,  spider_fire7  ] {ai_face();};
void() spider_fire7  =[ $sbite1,   spider_fire8  ] {ai_face();};
void() spider_fire8  =[ $sbite3,   spider_fire9  ] {ai_face();};
void() spider_fire9  =[ $sbite5,   spider_fire10 ] {ai_face(); SpiderFire('12 0 30');};
void() spider_fire10 =[ $sbite7,   spider_fire11 ] {ai_face();};
void() spider_fire11 =[ $sbite9,   spider_fire12 ] {ai_face();};
void() spider_fire12 =[ $sattak9,  spider_fire13 ] {ai_face();};
void() spider_fire13 =[ $sattak5,  spider_fire14 ] {ai_face();};
void() spider_fire14 =[ $sattak1,  spider_run1   ] {ai_face();};

// Firing from the ceiling.
void() spider_cfire1  =[ $scattak1,  spider_cfire3  ] {ai_face();};
void() spider_cfire3  =[ $scattak5,  spider_cfire5  ] {ai_face();};
void() spider_cfire5  =[ $scattak9,  spider_cfire7  ] {ai_face();};
void() spider_cfire7  =[ $scbite1,   spider_cfire8  ] {ai_face();};
void() spider_cfire8  =[ $scbite3,   spider_cfire9  ] {ai_face();};
void() spider_cfire9  =[ $scbite5,   spider_cfire10 ] {ai_face(); SpiderFire('12 0 26');};
void() spider_cfire10 =[ $scbite7,   spider_cfire11 ] {ai_face();};
void() spider_cfire11 =[ $scbite9,   spider_cfire12 ] {ai_face();};
void() spider_cfire12 =[ $scattak9,  spider_cfire13 ] {ai_face();};
void() spider_cfire13 =[ $scattak5,  spider_cfire14 ] {ai_face();};
void() spider_cfire14 =[ $scattak1,  spider_crun1   ] {ai_face();};

// Melee
void() spider_bite1  =[ $sattak1,  spider_bite3  ] {ai_charge(2);};
//void() spider_bite2  =[ $sattak3,  spider_bite3  ] {ai_charge(2);};
void() spider_bite3  =[ $sattak5,  spider_bite5  ] {ai_charge(2);};
//void() spider_bite4  =[ $sattak7,  spider_bite5  ] {ai_charge(2);};
void() spider_bite5  =[ $sattak9,  spider_bite7  ] {ai_charge(2);};
//void() spider_bite6  =[ $sattak11, spider_bite7  ] {ai_charge(2);};
void() spider_bite7  =[ $sbite1,   spider_bite8  ] {ai_charge(2);};
void() spider_bite8  =[ $sbite3,   spider_bite9  ] {ai_charge(2);};
void() spider_bite9  =[ $sbite5,   spider_bite10 ] {ai_charge(2); sound(self, CHAN_VOICE, "spider/bite.wav", 1, ATTN_NORM);};
void() spider_bite10 =[ $sbite7,   spider_bite11 ] {ai_charge(2); ai_melee();};
void() spider_bite11 =[ $sbite9,   spider_bite12 ] {ai_charge(2);
    if (self.enemy.health > 0)
        if (vlen(self.enemy.origin - self.origin) < 80)
        {
            if ((self.spawnflags & 8) && (random() < 0.5))
                self.think = spider_bite8;
            else if (random() < (skill * 0.1 + 0.4))
                self.think = spider_bite7;
        }
};
void() spider_bite12 =[ $sattak9,  spider_bite13 ] {ai_charge(2);};
void() spider_bite13 =[ $sattak5,  spider_bite14 ] {ai_charge(2);};
void() spider_bite14 =[ $sattak1,  spider_run1   ] {ai_charge(2);};

void() spider_cbite1  =[ $scattak1,  spider_cbite3  ] {spider_ceil_charge();};
void() spider_cbite3  =[ $scattak5,  spider_cbite5  ] {spider_ceil_charge();};
void() spider_cbite5  =[ $scattak9,  spider_cbite7  ] {spider_ceil_charge();};
void() spider_cbite7  =[ $scbite1,   spider_cbite8  ] {spider_ceil_charge();};
void() spider_cbite8  =[ $scbite3,   spider_cbite9  ] {spider_ceil_charge();};
void() spider_cbite9  =[ $scbite5,   spider_cbite10 ] {spider_ceil_charge(); sound(self, CHAN_VOICE, "spider/bite.wav", 1, ATTN_NORM);};
void() spider_cbite10 =[ $scbite7,   spider_cbite11 ] {spider_ceil_charge(); ai_melee();};
void() spider_cbite11 =[ $scbite9,   spider_cbite12 ] {spider_ceil_charge();
    if (self.enemy.health > 0)
        if (vlen(self.enemy.origin - self.origin) < 80)
        {
            if ((self.spawnflags & 8) && (random() < 0.5))
                self.think = spider_cbite8;
            else if (random() < (skill * 0.1 + 0.4))
                self.think = spider_cbite7;
        }
};
void() spider_cbite12 =[ $scattak9,  spider_cbite13 ] {spider_ceil_charge();};
void() spider_cbite13 =[ $scattak5,  spider_cbite14 ] {spider_ceil_charge();};
void() spider_cbite14 =[ $scattak1,  spider_crun1   ] {spider_ceil_charge();};

void() spider_melee =
{
    if (InMeleeRange (80))
    {
        if ( self.frame < $scwalk1 )
            spider_bite1 ();
        else
            spider_cbite1 ();
    }
    else
        ai_charge (self.speed);     // Too far away, move in.
};

void() spider_jumptouch;

void() face_me = {self.angles_y = self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);};

// Transition from end of jump to attack and bite.
void() spider_jend1  =[ $sattak7,  spider_jend2  ] {};
void() spider_jend2  =[ $sattak11, spider_bite7  ] {};

// Jump
void() spider_jump1  =[ $jump1,    spider_jump2  ] {face_me(); ai_charge(4);};
void() spider_jump2  =[ $jump3,    spider_jump3  ] {face_me(); ai_charge(4);};
void() spider_jump3  =[ $jump5,    spider_jump4  ] {
    face_me();
    self.cnt = 1;
    self.attack_finished = time + 3 + random();     // T+7 in Hexen2.
    self.touch = spider_jumptouch;
    self.velocity = SpiderJumpVelocity();     // Calls makevectors.
    self.flags = self.flags - (self.flags & FL_ONGROUND);
};
void() spider_jump4  =[ $jump7,    spider_jump5  ] {};
void() spider_jump5  =[ $jump8,    spider_jump6  ] {};
void() spider_jump6  =[ $jump9,    spider_jump7  ] {};
//void() spider_jump7  =[ $jump11,   spider_jump8  ] {
void() spider_jump7  =[ $jump11,   spider_run1   ] {
    if (visible (self.enemy))
    {
        local   vector  vec;
    
        vec = self.enemy.origin;
        vec_z = self.origin_z;
        vec = vec - self.origin;
        if (vlen(vec) < 200)
        {
            makevectors (self.angles);
            if (v_forward * normalize (vec) > 0.5) 
                self.think = spider_jend1;
        }
    }
};
//void() spider_jump8  =[ $jump11,   spider_jump1  ] {self.nextthink = time + 3;};

void() spider_tjump2 =[ $jump5,    spider_jump4  ]
{
    self.cnt = 0;   // No damage.
    // Since jump was forced by trigger, don't set attack_finished.
    self.touch = spider_jumptouch;
    // velocity and onground set by trigger.
};
void() spider_tjump =
{
    if ( self.frame < $scwalk1 )
        spider_tjump2 ();   // On the ceiling.
};

void() spider_jumptouch =
{
    local   float   up;

    if (self.health <= 0)
        return;

    if (self.cnt)
    {
        self.cnt = 0;
        if (other.takedamage)
        if (other.classname != self.classname)
        {
            up = 10 + random() * 5;     // Was 10.
            T_Damage (other, self, self, up);
            if (self.health <= 0)
                return;     // Killed by empathy shields.
        }
    }
    self.touch = monster_touch;     // Only one damage call per jump.

    if (!checkbottom (self))
    {   // Not firmly on solid ground.
        up = FALSE;
        if (self.flags & FL_ONGROUND)
            up = TRUE;
        else
        {
            if (other.flags & FLx_CREATURE)
            {
                if (self.absmin_z >= other.absmax_z)    //(self.origin_z >= other.origin_z + other.maxs_z)
                    up = TRUE;      // Landed on someone's head.
            }
        }

        if (up)
        {    // jump randomly to not get hung up
//            self.touch = monster_touch;
            self.think = spider_jump2;
            self.nextthink = time + 0.1;
        }
        return;    // not on ground yet
    }
//    self.touch = monster_touch;
//    if (( self.frame >= $sattak8 ) && ( self.frame <= $sbite10 ))
//        return;     // Don't interrupt an attack in progress.
//    self.think = spider_run1;
//    self.nextthink = time + 0.1;
};

void() spider_detach1  =[ $detach1, spider_detach2  ] {
// Initiate a jumping attack by falling down.
    self.touch      = spider_jumptouch;
    self.cnt        = 1;
    self.velocity   = '0 0 0';
    self.flags      = self.flags - (self.flags & (FL_FLY | FL_ONGROUND));
// Reset size to normal.
    setsize (self, VEC_SPIDER_MIN, VEC_SPIDER_MAX);
};
void() spider_detach2 =[ $detach2, spider_detach3  ] {};
void() spider_detach3 =[ $detach3, spider_run1     ] {};

void() spider_jump =
{
    if ( self.frame < $scwalk1 )
    {
        if (self.spawnflags & 8)
            spider_jump2 ();
        else
            spider_jump1 ();
    }
    else
        spider_detach1 ();
};

// PAIN - - - - - - - - - - - - - - - -
void() spider_painlo1 =[ $sdpain1,  spider_painlo2 ] {};
void() spider_painlo2 =[ $sdpain3,  spider_painlo3 ] {};
void() spider_painlo3 =[ $sdpain5,  spider_painlo4 ] {};
void() spider_painlo4 =[ $sdpain7,  spider_painlo5 ] {};
void() spider_painlo5 =[ $sdpain9,  spider_run1    ] {};

void() spider_painhi1 =[ $supain1,  spider_painhi2 ] {};
void() spider_painhi2 =[ $supain3,  spider_painhi3 ] {};
void() spider_painhi3 =[ $supain5,  spider_painhi4 ] {};
void() spider_painhi4 =[ $supain7,  spider_run1    ] {};

//void() spider_cpainlo1 =[ $scdpain1,  spider_cpainlo2 ] {};
//void() spider_cpainlo2 =[ $scdpain3,  spider_cpainlo3 ] {};
//void() spider_cpainlo3 =[ $scdpain5,  spider_cpainlo4 ] {};
//void() spider_cpainlo4 =[ $scdpain7,  spider_cpainlo5 ] {};
//void() spider_cpainlo5 =[ $scdpain9,  spider_crun1    ] {};

//void() spider_cpainhi1 =[ $scupain1,  spider_cpainhi2 ] {};
//void() spider_cpainhi2 =[ $scupain3,  spider_cpainhi3 ] {};
//void() spider_cpainhi3 =[ $scupain5,  spider_cpainhi4 ] {};
//void() spider_cpainhi4 =[ $scupain7,  spider_crun1    ] {};

void(entity attacker, float damage) spider_pain =
{
    if (self.pain_finished > time)
        return;
    if (random() * self.health > damage)    // Yes, place before pain sound.
        return;

    sound (self, CHAN_VOICE, "spider/pain.wav", 1, ATTN_NORM);
    self.pain_finished = time + 0.2;

    if ( self.frame >= $scwalk1 )   // Pain causes spider to fall from ceiling.
        {spider_detach1 ();  return;}

    if (self.touch == spider_jumptouch)
        return;     // No pain anims during jump.
    if (SUB_IgnorePain ())
        return;     // No pain anims in Nightmare.

// DISABLED -- No need to check if detached from ceiling.
//    if ( self.frame >= $scwalk1 )
//    {   // Spider is on the ceiling.
//        if (( self.frame >= $scattak8 ) && ( self.frame <= $scbite10 ))
//            spider_cpainhi1 ();
//        else
//            spider_cpainlo1 ();
//        return;
//    }
    if (( self.frame >= $sattak8 ) && ( self.frame <= $sbite10 ))
        spider_painhi1 ();
    else
        spider_painlo1 ();

    attacker = attacker;        // Appease FrikQcc.
};

// DEATH - - - - - - - - - - - - - - - -
void() spider_die1  =[ $sdeath2,  spider_die2  ] {};
void() spider_die2  =[ $sdeath4,  spider_die3  ] {};
void() spider_die3  =[ $sdeath6,  spider_die4  ] {};
void() spider_die4  =[ $sdeath8,  spider_die5  ] {};
void() spider_die5  =[ $sdeath10, spider_die6  ] {};
void() spider_die6  =[ $sdeath12, spider_die7  ] {};
void() spider_die7  =[ $sdeath14, spider_die8  ] {};
void() spider_die8  =[ $sdeath16, spider_die9  ] {};
void() spider_die9  =[ $sdeath18, spider_die10 ] {};
void() spider_die10 =[ $sdeath20, monster_end  ] {};

void() spider_cdie1  =[ $scdeath1,  spider_cdie2 ] {};
void() spider_cdie2  =[ $scdeath2,  spider_die4  ] {};

float(float dm) spider_gib =
{
// check for gib
    if (self.health < self.gib_health)
    {
        local   vector  org;
        local   float   fr;
        local   string  g1, g2;

        if (self.bloodtype == BLOOD_GREEN)
            {fr = X56_SPLASH_GREEN; g1 = "progs/gr_gib.mdl"; g2 = "progs/sp_gib.mdl";}
        else
            {fr = X56_SPLASH_RED; g1 = "progs/zom_gib.mdl"; g2 = "progs/sp_gib2.mdl";}
        if ( self.frame >= $scwalk1 )
            org = self.origin + '0 0 46';
        else
            org = self.origin + '0 0 10';
        MakeFancy (org, fr, 3);
        sound (self, CHAN_VOICE, "spider/gib1.wav", 1, ATTN_NORM);
        ThrowGib (g1, dm);
        ThrowGib (g1, dm);
        ThrowGib (g2, dm);
        self.skin = 0;  // So Quake won't complain about missing skin on gibs.
        ThrowHead (g2, dm);
        return TRUE;
    }
    return FALSE;
};

void() spider_die =
{
    if (Shattered ())
        return;

// Make sure tiny spiders get splattered.
    if ( self.frame >= $sgrow1 )
        if ( self.frame <= $sgrow7 )
            if (self.health >= self.gib_health)
                self.health = self.gib_health - 1;
// If decapitated, splatter instead.
    if (Decapitated ())
        self.health = self.gib_health - 1;

// check for gib
    if (spider_gib (self.health))
        return;

// regular death
    sound (self, CHAN_VOICE, "spider/death.wav", 1, ATTN_NORM);
    monster_drop ();
    if ( self.frame >= $scwalk1 )
    {   // Was on the ceiling.
        setsize (self, VEC_SPIDER_MIN, VEC_SPIDER_MAX);
        spider_cdie1 ();
    }
    else
        spider_die1 ();
};

// REVIVE - - - - - - - - - - - - - - -
void() spider_revive1  =[ $sdeath18, spider_revive2  ] {};
void() spider_revive2  =[ $sdeath16, spider_revive3  ] {};
void() spider_revive3  =[ $sdeath14, spider_revive4  ] {};
void() spider_revive4  =[ $sdeath12, spider_revive5  ] {};
void() spider_revive5  =[ $sdeath10, spider_revive6  ] {};
void() spider_revive6  =[ $sdeath8,  spider_revive7  ] {};
void() spider_revive7  =[ $sdeath6,  spider_revive8  ] {};
void() spider_revive8  =[ $sdeath4,  spider_revive9  ] {};
void() spider_revive9  =[ $sdeath2,  spider_run1     ] {};

//=============================================================================

// OTHER - - - - - - - - - - - - - - - -
void(float hello) spider_sight =
{
    if (!hello)
        sound (self, CHAN_VOICE, "shalrath/idle.wav", 1, ATTN_NORM);
};

void() spider_cache =
{
    precache_blood (BLOOD_GREEN);

    precache_model ("progs/spider.mdl");
    precache_model ("progs/sp_gib.mdl");
    precache_model ("progs/sp_gib2.mdl");

    precache_sound ("shalrath/idle.wav");
    precache_sound ("spider/attack.wav");   // PM:  Missile sound.
    precache_sound ("spider/bite.wav");
    precache_sound ("spider/death.wav");
    precache_sound ("spider/gib1.wav");
    precache_sound ("spider/pain.wav");
    precache_sound ("spider/step1.wav");
    precache_sound ("spider/step2.wav");
    precache_sound ("spider/step3.wav");
};

// Note:  Due to how Quake moves boxes around, having spiders that can
// crawl on the walls or ceilings is problematic.
// For instance, we cannot merely rotate entity angles because the bbox
// does not rotate with the model.  Also, if we want the spider to stick
// to the ceiling, we need to use a bbox size of '0 0 0', '32 32 56', or
// '64 64 88'.  The spider is bigger than point-size, but not player-size,
// let alone ogre/shambler size.  For spiders, we need a player-sized hull
// for as long as it sticks to the ceiling.  Once it detachs, give back
// a smaller hull so bullets won't hit as easily.

// Originally had mins at '-16 -16 0' for easy scaling (in ports) and
// easy auto aim.  However, this causes excessive splashing sounds when
// entering and leaving puddles of water, and also poor reach with ai_melee.
// The mins was reset at '-16 -16 -16' to fix the problems of splashing
// and melee range.  Auto-aiming with hitscan weapons is a bit difficult
// now though.

//============
// --> QUAKED monster_spider (1 0 0) (-16 -16 -16) (16 16 40) Ambush Ceiling Spitter Fast
// Maxs when not on ceiling is '16 16 20'.
//============
void() monster_spider =
{
    if (!self.spawned)
    {
        if (noenemies)
            {remove (self); return;}
        spider_cache ();
    }

    if (self.skin != 2)     // skin==2 is Kinn's bloody spider.
        self.bloodtype  = BLOOD_GREEN;

// bigred = 225, smallred = 50, bigyel = 75, smallyel = 30.
// gib_health was -20, but that's too low, so use -35.

// Note:  Don't use size_z <= 32 because spiders can walk on each other
// then get stuck in mid-air.  36 seems to stop that nonsense, yet is
// small enough to let the player jump on a spider.
    monster_form ("progs/spider.mdl", VEC_SPIDER_MIN, VEC_SPIDER_MAX, 50, -35);
    if (self.bloodtype != BLOOD_GREEN)
        self.mdl_head   = "progs/sp_gib2.mdl";  // Red blood chunk.
    else
        self.mdl_head   = "progs/sp_gib.mdl";   // Green blood chunk.
    self.mass   = MASS_LIGHT;

    self.th_stand   = spider_stand_go;
    self.th_walk    = spider_walk_go;
    self.th_run     = spider_go;        //spider_run1;
    self.th_missile = spider_jump;
    self.th_melee   = spider_melee;
    self.th_pain    = spider_pain;
    self.th_die     = spider_die;
    //- - - - - - - -
    self.th_jump    = spider_tjump;
    self.th_sight   = spider_sight;
    self.th_check   = SpiderCheckAttack;
    self.th_gib     = spider_gib;
    self.th_revive  = spider_revive1;
    self.th_spawn   = monster_spider;

    self.family     = FAM_SPIDER;

    self.touch      = monster_touch;
    self.speed      = 16;
    self.view_ofs   = '0 0 9';    // Unusual bbox requires unusual view_ofs.

// Ceiling code check - - - - - - - - -
    if (self.spawnflags & 2)
    {   // Attempt to cling on a ceiling.
        // Make a dummy then move it straight up.
        // If dummy gets moved to the ceiling, make the spider stick.
        if (RiseToCeiling ())
        {
            setsize (self, VEC_SPIDER_MIN, VEC_SPIDER_MAX2);  // Must do this.
            self.flags      = self.flags | FL_FLY;
            self.frame      = $scwalk1;     // So my code knows it's clinging.
        }
    }
//- - - - - - - - - - - - - - - - - - -

    monster_start ();
};


//===========================/  END OF FILE  /===========================//
