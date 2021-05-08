/*
==============================================================================

DROLE (Ported from Chapters/Quoth)

==============================================================================
*/

$cd id1/models/drole
$origin 0 0 24
$base base        
$skin base

$frame idle_a1 idle_a2 idle_a3 idle_a4 idle_a5 idle_a6 idle_a7 idle_a8
$frame idle_a9 idle_a10 idle_a11 idle_a12 idle_a13 idle_a14 idle_a15 idle_a16 
$frame idle_a17 idle_a18 idle_a19 idle_a20 idle_a21 idle_a22 idle_a23 
$frame idle_a24 idle_a25 idle_a26 idle_a27 idle_a28 idle_a29 idle_a30

$frame idle_b1 idle_b2 idle_b3 idle_b4 idle_b5 idle_b6 idle_b7 idle_b8
$frame idle_b9 idle_b10 idle_b11 idle_b12 idle_b13 idle_b14 idle_b15 idle_b16 
$frame idle_b17 idle_b18 idle_b19 idle_b20 idle_b21 idle_b22 idle_b23 
$frame idle_b24 idle_b25 idle_b26 idle_b27 idle_b28 idle_b29 idle_b30
$frame idle_b31 idle_b32 idle_b33 idle_b34 idle_b35 idle_b36 idle_b37
$frame idle_b38 idle_b39 idle_b40


$frame idle_c1 idle_c2 idle_c3 idle_c4 idle_c5 idle_c6 idle_c7 idle_c8
$frame idle_c9 idle_c10 idle_c11 idle_c12 idle_c13 idle_c14 idle_c15 idle_c16 
$frame idle_c17 idle_c18 idle_c19 idle_c20 idle_c21 idle_c22 idle_c23 
$frame idle_c24 idle_c25 idle_c26 idle_c27 idle_c28 idle_c29 idle_c30

$frame shoot1 shoot2 shoot3 shoot4 shoot5 shoot6 shoot7 shoot8 shoot9

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8

$frame jump1 jump2 jump3 jump4 jump5 jumpb1

$frame run1 run2 run3 run4 run5 run6 run7 run8

$frame pain1 pain2 pain3 pain4 pain5 pain6

$frame swiper1 swiper2 swiper3 swiper4 swiper5 swiper6 swiper7 swiper8
$frame swiper9 swiper10 swiper11 swiper12 swiper13 swiper14 swiper15 swiper16

$frame swipel1 swipel2 swipel3 swipel4 swipel5 swipel6 swipel7 swipel8
$frame swipel9 swipel10 swipel11 swipel12 swipel13 swipel14 swipel15 swipel16

$frame death1 death2 death3 death4 death5 death6 death7 death8 death9 death10
$frame death11 death12 death13 death14 death15 death16 death17 death18
$frame death19 death20 death21 death22 death23 death24 death25 death26

//============================================================================

//===========
// DroleCheckAttack
//
// The player is in view, so decide to move or launch an attack
// Returns FALSE if movement should continue
//============
float() DroleCheckAttack =
{
    local   vector  spot1, spot2;    
    local   entity  targ;
    local   float   chance;
    local   float   dist;

    if (enemy_range == RANGE_FAR)
        return FALSE;

    dist = vlen (self.enemy.origin - self.origin);
    if (dist < 150)
    if (enemy_vis || (enemy_range == RANGE_MELEE))
    if (CanDamage (self.enemy, self))
    if (self.th_melee)
    {
        self.th_melee ();
        return TRUE;
    }

    if (time < self.attack_finished)
        return FALSE;
    if (!enemy_vis)
        return FALSE;
    if (!self.th_missile)
        return FALSE;
        
    targ = self.enemy;
    
// see if any entities are in the way of the shot
    spot1 = self.origin + self.view_ofs;
    spot2 = targ.origin + targ.view_ofs;

    traceline (spot1, spot2, FALSE, self);

    if (trace_inopen && trace_inwater)
        return FALSE;            // sight line crossed contents

    if (trace_ent != targ)
        if (DontHurtMe (trace_ent))   // PM:  Check who's in the way.
            return FALSE;    // don't have a clear shot

// missile attack
    chance = 0;
    if (self.ryuflags & RYU_BERSERK)
    {   if (dist >= 250)
            chance = 0.3;
    }
    else    // We shoot more when not angry.
    {   if (dist >= 100)
            chance = 0.9;
    }
    // I don't know if Quoth has an RANGE_LONG equivalent, but I doubt it.
    // Fire less frequently from longer range.
    if (enemy_range > RANGE_MID)
        chance = chance / 2;

    if (random () >= chance)
        return FALSE;

    chance = 1 + 2*random();
    self.th_missile ();
    SUB_AttackFinished (chance);
    return TRUE;
};


//============================================================================

void() DroleBomb_Explosion =
{
    local   entity  e;

    e = spawn();
    setorigin (e, self.origin);
    sound (e, CHAN_AUTO, "drole/explode3.wav", 1, ATTN_NORM);
    remove (e);

    Tent_Explosion (self.origin);

    BecomeExplosion ();
};

void() drole_ball1  =[ 1, drole_ball2 ] {self.nextthink = time + 0.2;};
void() drole_ball2  =[ 2, drole_ball3 ] {self.velocity = self.velocity * 1.5;};
void() drole_ball3  =[ 3, drole_ball4 ] {self.velocity = self.velocity * 1.5;};
void() drole_ball4  =[ 3, SUB_Remove  ] {self.nextthink = time + 5;
    if (cranked)    // Fastballs only on cranked, not Chapter's/Quoth's non-easy.
        self.velocity = self.velocity * 6;      // Chapters Medium+.
    else
        self.velocity = self.velocity * 4.5;    // Chapters Easy/Quoth
};

void(vector start, vector dir) DroleBomb_Launch =
{
    local   entity  missile;

    missile = spawn ();
    missile.master      = missile.owner     = self;
    missile.movetype    = MOVETYPE_FLYMISSILE;
    missile.solid       = SOLID_BBOX;
    missile.classname   = "drolefireball";
// set missile speed
//    missile.speed       = 1000;
    missile.velocity    = dir * 100;
    missile.avelocity   = '400 400 400';
    missile.angles      = vectoangles(missile.velocity);
// set missile damage
    // Cranked shots are faster, like in Chapters.
    missile.dmg         = 50;
    missile.enemy       = world;
    missile.style       = DF_ROCKET;    // Shamblers take half damage.
    missile.frame       = 0;
// set missile duration
    missile.touch       = T_MissileTouch;
    missile.nextthink   = time + 0.05;   // Was 0.025.
    missile.think       = drole_ball1;
    missile.think1      = DroleBomb_Explosion;

    setall (missile, "progs/drlbomb.mdl", '0 0 0', '0 0 0', start);

    newmis = missile;
};

void() drolefire =
{
    local    vector    org, vec;

// Ugh!  Chapter's custom leading.  I'll leave it as it as, mostly.
    org = self.origin + '0 0 34';
    if (visible(self.enemy))
    {
        local   vector  lead;

        lead = '0 0 0';
        if (self.enemy.classname == "player")
        {
            lead = self.enemy.velocity * 0.4;
            lead_z = lead_z * 0.2;
        }
        vec = self.enemy.origin + '0 0 -8' + lead;
    }
    else
        vec = (self.aim_here + '0 0 -8');
    vec = normalize (vec - org);
    
    DroleBomb_Launch (org, vec);
};


//============================================================================

// STAND - - - - - - - - - - - - - - - -
void() drole_stand1 =[ $idle_a1,  drole_stand2  ]
{
    self.walkframe = -1;
    self.height = $idle_a1;
    drole_stand2 ();
};
void() drole_stand2 =[ $idle_a1,  drole_stand2  ]
{
// Animate monster.
    self.walkframe = self.walkframe + 1;
    if ((self.walkframe < 0) || (self.walkframe >= 30))
    {
        local   float   r;
    
        r = random() * 4;   // Was 3.
        if (r < 1)
            self.height = $idle_a1;
        else if (r < 2)
            self.height = $idle_b1;
        else
            self.height = $idle_c1;
        self.walkframe = 0;
    }
    self.frame = self.height + self.walkframe;

// Monster AI.
    ai_stand();
};

// WALK - - - - - - - - - - - - - - - -
void() drole_walk1  =[ $walk1,  drole_walk2 ] {ai_walk(10);};
void() drole_walk2  =[ $walk2,  drole_walk3 ] {ai_walk(9);};
void() drole_walk3  =[ $walk3,  drole_walk4 ] {ai_walk(9);};
void() drole_walk4  =[ $walk4,  drole_walk5 ] {ai_walk(5);};
void() drole_walk5  =[ $walk5,  drole_walk6 ] {ai_walk(6);};
void() drole_walk6  =[ $walk6,  drole_walk7 ] {ai_walk(12);};
void() drole_walk7  =[ $walk7,  drole_walk8 ] {ai_walk(8);};
void() drole_walk8  =[ $walk8,  drole_walk1 ] {
    if (random() > 0.87)    // Was 0.8.
        sound (self, CHAN_VOICE, "drole/idle.wav", 1, ATTN_IDLE);
    ai_walk(3);
};
// Removed last four half scene functions.  (13, 9, 7, 7)

// RUN - - - - - - - - - - - - - - - - -
// Walking at 150% speed.
void() drole_move1 =[ $walk1, drole_move2 ] {ai_run(15);};
void() drole_move2 =[ $walk2, drole_move3 ] {ai_run(14);};
void() drole_move3 =[ $walk3, drole_move4 ] {ai_run(14);};
void() drole_move4 =[ $walk4, drole_move5 ] {ai_run(8);};
void() drole_move5 =[ $walk5, drole_move6 ] {ai_run(9);};
void() drole_move6 =[ $walk6, drole_move7 ] {ai_run(18);};
void() drole_move7 =[ $walk7, drole_move8 ] {ai_run(12);};
void() drole_move8 =[ $walk8, drole_move1 ] {ai_run(5);
    if (random() > 0.87)
        sound (self, CHAN_VOICE, "drole/idle.wav", 1, ATTN_IDLE);
};

// Proper running.
void() drole_run1 =[ $run1, drole_run2 ] {ai_run(34);};
void() drole_run2 =[ $run2, drole_run3 ] {ai_run(32);};
void() drole_run3 =[ $run3, drole_run4 ] {ai_run(38);};
void() drole_run4 =[ $run4, drole_run5 ] {ai_run(35);};
void() drole_run5 =[ $run5, drole_run6 ] {ai_run(34);};
void() drole_run6 =[ $run6, drole_run7 ] {ai_run(32);};
void() drole_run7 =[ $run7, drole_run8 ] {ai_run(38);};
void() drole_run8 =[ $run8, drole_run1 ] {ai_run(35);
    if (random() > 0.8)
        sound (self, CHAN_VOICE, "drole/idle.wav", 1, ATTN_IDLE);
};

void() drole_run =
{
    if (self.health < (self.max_health * 0.7))
        self.ryuflags = self.ryuflags | RYU_BERSERK;
    else
        self.ryuflags = self.ryuflags - (self.ryuflags & RYU_BERSERK);

    if (self.ryuflags & RYU_BERSERK)
        drole_run1 ();      // Mad enough to run!
    else
        drole_move1 ();     // Don't run now, just walk.
};

// ATTACK (Melee) - - - - - - - - - - -
void() drole_swingr1;

void(float side) DroleHit =
{
    local   vector  delta;
    local   float   ldmg;

    ai_charge(10);

    delta = self.enemy.origin - self.origin;

    if (!InMeleeRange (100))    //if (vlen(delta) > 100)
        return;
    if (!CanDamage (self.enemy, self))
        return;
    if (IsGhost (self.enemy))   // NEW!
        return;     // Not allowed to hit wraith.

    ldmg = 10 + 10 * random();      // Quoth damage.
    if (cranked)
        ldmg = ldmg + 10;   // Chapters damage!
    T_Damage (self.enemy, self, self, ldmg);

    if (random() < 0.5)
        sound (self, CHAN_AUTO, "drole/strike1.wav", 1, ATTN_NORM);
    else
        sound (self, CHAN_AUTO, "drole/strike2.wav", 1, ATTN_NORM);

    if (side)
    {
        makevectors (self.angles);
        SpawnMeatSpray (self.origin + v_forward*16, side * v_right, self.enemy.bloodtype);
    }
};

// Running at 75% speed
// Use CHAN_WEAPON instead of CHAN_VOICE.
void() drole_swingl1  =[ $swipel1,  drole_swingl2   ] {ai_charge(26); sound (self, CHAN_WEAPON, "drole/swipe.wav", 1, ATTN_NORM);};
void() drole_swingl2  =[ $swipel2,  drole_swingl3   ] {ai_charge(24);};
void() drole_swingl3  =[ $swipel3,  drole_swingl4   ] {ai_charge(29);};
void() drole_swingl4  =[ $swipel4,  drole_swingl5   ] {ai_charge(27);};
void() drole_swingl5  =[ $swipel5,  drole_swingl6   ] {ai_charge(26); DroleHit(250);};
void() drole_swingl6  =[ $swipel6,  drole_swingl7   ] {ai_charge(24); sound (self, CHAN_WEAPON, "drole/swipe.wav", 1, ATTN_NORM);};
void() drole_swingl7  =[ $swipel7,  drole_swingl8   ] {ai_charge(29);};
void() drole_swingl8  =[ $swipel8,  drole_swingl9   ] {ai_charge(27);};
void() drole_swingl9  =[ $swipel9,  drole_swingl10  ] {ai_charge(26);};
void() drole_swingl10 =[ $swipel10, drole_swingl11  ] {ai_charge(24); DroleHit(250);};
void() drole_swingl11 =[ $swipel11, drole_swingl12  ] {ai_charge(29);};
void() drole_swingl12 =[ $swipel12, drole_swingl13  ] {ai_charge(27);};
void() drole_swingl13 =[ $swipel13, drole_swingl14  ] {ai_charge(26);};
void() drole_swingl14 =[ $swipel14, drole_swingl15  ] {ai_charge(24);};
void() drole_swingl15 =[ $swipel15, drole_swingl16  ] {ai_charge(29);};
void() drole_swingl16 =[ $swipel16, drole_run       ] {ai_charge(27);
    if (random() < 0.5)
        if (!IsDead (self.enemy))
            if (InMeleeRange (140))
                self.think = drole_swingr1;
};

void() drole_swingr1  =[ $swiper1,  drole_swingr2   ] {ai_charge(26); sound (self, CHAN_WEAPON, "drole/swipe.wav", 1, ATTN_NORM);};
void() drole_swingr2  =[ $swiper2,  drole_swingr3   ] {ai_charge(24);};
void() drole_swingr3  =[ $swiper3,  drole_swingr4   ] {ai_charge(29);};
void() drole_swingr4  =[ $swiper4,  drole_swingr5   ] {ai_charge(27);};
void() drole_swingr5  =[ $swiper5,  drole_swingr6   ] {ai_charge(26); DroleHit(-250);};
void() drole_swingr6  =[ $swiper6,  drole_swingr7   ] {ai_charge(24); sound (self, CHAN_WEAPON, "drole/swipe.wav", 1, ATTN_NORM);};
void() drole_swingr7  =[ $swiper7,  drole_swingr8   ] {ai_charge(29);};
void() drole_swingr8  =[ $swiper8,  drole_swingr9   ] {ai_charge(27);};
void() drole_swingr9  =[ $swiper9,  drole_swingr10  ] {ai_charge(26);};
void() drole_swingr10 =[ $swiper10, drole_swingr11  ] {ai_charge(24); DroleHit(-250);};
void() drole_swingr11 =[ $swiper11, drole_swingr12  ] {ai_charge(29);};
void() drole_swingr12 =[ $swiper12, drole_swingr13  ] {ai_charge(27);};
void() drole_swingr13 =[ $swiper13, drole_swingr14  ] {ai_charge(26);};
void() drole_swingr14 =[ $swiper14, drole_swingr15  ] {ai_charge(24);};
void() drole_swingr15 =[ $swiper15, drole_swingr16  ] {ai_charge(29);};
void() drole_swingr16 =[ $swiper16, drole_run       ] {ai_charge(27);
    if (random() < 0.5)
        if (!IsDead (self.enemy))
            if (InMeleeRange (140))
                self.think = drole_swingl1;
};

void() drole_melee =
{
    if (random() > 0.5)
        drole_swingr1 ();
    else
        drole_swingl1 ();
};

// ATTACK (Missile) - - - - - - - - - -
void() drole_magic1  =[ $shoot1, drole_magic2   ] {ai_face(); ai_shotcheck(); sound (self, CHAN_WEAPON, "drole/fire.wav", 1, ATTN_NORM);};
void() drole_magic2  =[ $shoot2, drole_magic3   ] {ai_face(); ai_shotcheck();};
void() drole_magic3  =[ $shoot3, drole_magic4   ] {ai_face(); ai_shotcheck();};
void() drole_magic4  =[ $shoot4, drole_magic5   ] {ai_face(); ai_shotcheck(); drolefire();};
void() drole_magic5  =[ $shoot5, drole_magic6   ] {ai_face();};
void() drole_magic6  =[ $shoot6, drole_magic7   ] {ai_face();};
void() drole_magic7  =[ $shoot7, drole_magic8   ] {ai_face();};
void() drole_magic8  =[ $shoot8, drole_magic9   ] {ai_face();};
void() drole_magic9  =[ $shoot9, drole_magic10  ] {ai_face();};
void() drole_magic10 =[ $shoot8, drole_run      ] {ai_face();};

// PAIN - - - - - - - - - - - - - - - -
void() drole_pain1 =[ $pain1, drole_pain2 ] {ai_back(8);};
void() drole_pain2 =[ $pain2, drole_pain3 ] {ai_back(10);};
void() drole_pain3 =[ $pain3, drole_pain4 ] {ai_back(10);};
void() drole_pain4 =[ $pain4, drole_pain5 ] {ai_back(8);};
void() drole_pain5 =[ $pain5, drole_pain6 ] {ai_back(6);};
void() drole_pain6 =[ $pain6, drole_run   ] {ai_back(4);};

void(entity attacker, float damage) drole_pain =
{
    if (!(self.ryuflags & RYU_BERSERK))
    if (self.health < (self.max_health * 0.7))
    {   // Gets angry!
        self.ryuflags = self.ryuflags | RYU_BERSERK;
        self.pain_finished = time + 2;  // Wasn't here in Chapters source.
        sound (self, CHAN_VOICE, "drole/sight2.wav", 1, 0.5);
        drole_pain1 ();
        return;
    }

// don't make multiple pain sounds right after each other
    if (self.pain_finished > time)
        return;
    if (random() >= 0.3)
        return;     // didn't flinch

    self.pain_finished = time + 2;
    sound (self, CHAN_VOICE, "drole/pain.wav", 1, ATTN_NORM);
    if (SUB_IgnorePain ())
        return;
    drole_pain1 ();

    damage = damage;  attacker = attacker;  // Appease Qcc.
};

// DEATH - - - - - - - - - - - - - - - -
// Speed up animation slightly.
//void() drole_death1  =[ $death1,  drole_death2  ] {};
//void() drole_death2  =[ $death2,  drole_death3  ] {};
//void() drole_death3  =[ $death3,  drole_death4  ] {};   //self.solid = SOLID_NOT;};
//void() drole_death4  =[ $death4,  drole_death5  ] {};
//void() drole_death5  =[ $death5,  drole_death6  ] {};
//void() drole_death6  =[ $death6,  drole_death7  ] {};
//void() drole_death7  =[ $death7,  drole_death8  ] {};
void() drole_death1  =[ $death2,  drole_death2  ] {};
void() drole_death2  =[ $death4,  drole_death6  ] {};
void() drole_death6  =[ $death6,  drole_death7  ] {};
void() drole_death7  =[ $death7,  drole_death8  ] {};
void() drole_death8  =[ $death8,  drole_death9  ] {};
void() drole_death9  =[ $death9,  drole_death10 ] {};
void() drole_death10 =[ $death10, drole_death11 ] {};
void() drole_death11 =[ $death11, drole_death12 ] {};
void() drole_death12 =[ $death12, drole_death13 ] {};
void() drole_death13 =[ $death13, drole_death14 ] {};
void() drole_death14 =[ $death14, drole_death15 ] {};
void() drole_death15 =[ $death15, drole_death16 ] {};
void() drole_death16 =[ $death16, drole_death17 ] {};
void() drole_death17 =[ $death17, drole_death18 ] {};
void() drole_death18 =[ $death18, drole_death19 ] {};
void() drole_death19 =[ $death19, drole_death20 ] {};
void() drole_death20 =[ $death20, drole_death21 ] {self.solid = SOLID_NOT;};
void() drole_death21 =[ $death21, drole_death22 ] {};
void() drole_death22 =[ $death22, drole_death24 ] {};
//void() drole_death23 =[ $death23, drole_death24 ] {};
void() drole_death24 =[ $death24, drole_death26 ] {};
//void() drole_death25 =[ $death25, drole_death26 ] {};
void() drole_death26 =[ $death26, monster_end   ] {};
//

float(float dm) drole_gib =
{
    if (self.health < self.gib_health)
    {
        sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
        ThrowGib ("progs/gib1.mdl", dm);
        ThrowGib ("progs/gib2.mdl", dm);
        ThrowGib ("progs/gib3.mdl", dm);
        ThrowHead ("progs/h_drole.mdl", dm);
        return TRUE;
    }
    return FALSE;
};

void() drole_die =
{
    if (Shattered ())
        return;

    // Head is so small don't bother with decapitation.

// check for gib
    if (drole_gib (self.health))
        return;

    sound (self, CHAN_VOICE, "drole/death.wav", 1, ATTN_NORM);
    drole_death1 ();
};

// REVIVE - - - - - - - - - - - - - - -
void() drole_revive1  =[ $death24,  drole_revive2  ] {};
void() drole_revive2  =[ $death22,  drole_revive3  ] {};
void() drole_revive3  =[ $death20,  drole_revive4  ] {};
void() drole_revive4  =[ $death18,  drole_revive5  ] {};
void() drole_revive5  =[ $death16,  drole_revive6  ] {};
void() drole_revive6  =[ $death14,  drole_revive7  ] {};
void() drole_revive7  =[ $death12,  drole_revive8  ] {};
void() drole_revive8  =[ $death10,  drole_revive9  ] {};
void() drole_revive9  =[ $death8,   drole_revive10 ] {};
void() drole_revive10 =[ $death6,   drole_revive11 ] {};
void() drole_revive11 =[ $death4,   drole_revive12 ] {};
void() drole_revive12 =[ $death2,   drole_run      ] {};


//============================================================================

// OTHER - - - - - - - - - - - - - - - -
void(float hello) drole_sight =
{
    if (hello)
        sound (self, CHAN_VOICE, "drole/idle.wav", 1, ATTN_NORM);
    else
    {   // Hostile sound.
        if (self.ryuflags & RYU_BERSERK)
            sound (self, CHAN_VOICE, "drole/sight2.wav", 1, ATTN_NORM);
        else
            sound (self, CHAN_VOICE, "drole/sight.wav", 1, ATTN_NORM);
    }
};

void() drole_cache =
{
    precache_model ("progs/drole.mdl");
    precache_model ("progs/h_drole.mdl");
    precache_model ("progs/drlbomb.mdl");
    
    precache_sound ("drole/explode3.wav");
    precache_sound ("drole/death.wav");
    precache_sound ("drole/pain.wav");
    precache_sound ("drole/idle.wav");
    precache_sound ("drole/sight.wav");
    precache_sound ("drole/sight2.wav");
    precache_sound ("drole/strike1.wav");
    precache_sound ("drole/strike2.wav");
    precache_sound ("drole/swipe.wav");
    precache_sound ("drole/fire.wav");
};

//============
// --> QUAKED monster_drole (1 0 0) (-32 -32 -24) (32 32 64) Ambush
//============
void() monster_drole =
{
    if (!self.spawned)
    {
        if (noenemies)
            {remove (self); return;}
        drole_cache ();
    }

    // Gib health was -60, but use more instead thanks to corpse mutilation.
    monster_form ("progs/drole.mdl", VEC_HULL2_MIN, VEC_HULL2_MAX, 500, -80);
    self.mdl_head   = "progs/h_drole.mdl";
    self.mass       = MASS_HEAVY;

    self.th_stand   = drole_stand1;
    self.th_walk    = drole_walk1;
    self.th_run     = drole_run;
    self.th_missile = drole_magic1;
    self.th_melee   = drole_melee;
    self.th_pain    = drole_pain;
    self.th_die     = drole_die;
    //- - - - - - - -
    self.th_sight   = drole_sight;
    self.th_check   = DroleCheckAttack;
    self.th_gib     = drole_gib;
    self.th_revive  = drole_revive1;
    self.th_spawn   = monster_drole;

    self.ryuflags = self.ryuflags - (self.ryuflags & RYU_BERSERK);

    monster_start ();
};


//===========================/  END OF FILE  /===========================//
