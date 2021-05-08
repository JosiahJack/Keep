/*
==============================================================================

GUG (Ported and reverse engineered from Quoth)

==============================================================================
*/

$cd id1/models/gug
$origin 0 0 24
$base base        
$skin base

$frame sit

$frame base

$frame idle1 idle2 idle3 idle4 idle5 idle6 idle7 idle8 idle9 idle10
$frame idle11 idle12 idle13 idle14 idle15 idle16 idle17 idle18 idle19 idle20
$frame idle21 idle22 idle23 idle24 idle25 idle26 idle27 idle28 idle29 idle30
$frame idle31 idle32 idle33 idle34 idle35 idle36 idle37 idle38 idle39 idle40
$frame idle41 idle42 idle43 idle44 idle45 idle46 idle47 idle48 idle49 idle50
$frame idle51 idle52 idle53 idle54 idle55 idle56 idle57 idle58 idle59 idle60
$frame idle61 idle62 idle63 idle64 idle65 idle66 idle67 idle68 idle69 idle70
$frame idle71 idle72 idle73 idle74 idle75 idle76 idle77 idle78 idle79 idle80

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10
$frame walk11 walk12 walk13 walk14 walk15 walk16

$frame run1 run2 run3 run4 run5 run6 run7 run8

$frame swipel1 swipel2 swipel3 swipel4 swipel5 swipel6 swipel7 swipel8
$frame swipel9 swipel10 swipel11 swipel12 swipel13 swipel14 swipel15 swipel16
$frame swipel17 swipel18 swipel19 swipel20 swipel21 swipel22 swipel23

$frame swiper1 swiper2 swiper3 swiper4 swiper5 swiper6 swiper7 swiper8
$frame swiper9 swiper10 swiper11 swiper12 swiper13 swiper14 swiper15 swiper16
$frame swiper17 swiper18 swiper19 swiper20 swiper21 swiper22 swiper23

$frame bile1 bile2 bile3 bile4 bile5 bile6 bile7 bile8 bile9 bile10
$frame bile11 bile12 bile13 bile14 bile15 bile16 bile17 bile18

$frame quake1 quake2 quake3 quake4 quake5 quake6 quake7 quake8 quake9 quake10
$frame quake11 quake12 quake13 quake14 quake15 quake16 quake17 quake18
$frame quake19 quake20 quake21 quake22 quake23 quake24

$frame pain1 pain2 pain3 pain4 pain5 pain6

$frame death1 death2 death3 death4 death5 death6 death7 death8 death9 death10
$frame death11 death12 death13 death14 death15 death16 death17 death18
$frame death19 death20 death21 death22 death23 death24 death25 death26
$frame death27 death28 death29 death30 death31 death32 death33 death34
$frame death35 death36 death37 death38 death39 death40 death41

//============================================================================

void() gug_quake2;

// Returns TRUE if gug is standing on ground it can pound.
float() GugOnGround =
{
    local   vector  spot, up;

    up = v_up * 50;      // As Mjolnir.
    spot = self.origin;
    traceline (spot, spot - up, TRUE, self);
    if (trace_fraction < 1)
        return TRUE;
    spot = self.origin + '15 15 0';
    traceline (spot, spot - up, TRUE, self);
    if (trace_fraction < 1)
        return TRUE;
    spot = self.origin + '-15 15 0';
    traceline (spot, spot - up, TRUE, self);
    if (trace_fraction < 1)
        return TRUE;
    spot = self.origin + '-15 -15 0';
    traceline (spot, spot - up, TRUE, self);
    if (trace_fraction < 1)
        return TRUE;
    spot = self.origin + '15 -15 0';
    traceline (spot, spot - up, TRUE, self);
    if (trace_fraction < 1)
        return TRUE;

    return FALSE;
};

//===========
// GugQuakeCheck
//
// If target is not in LOS, use an attack that doesn't care about line-of-fire.
// This will harass a player that tries to hide and spam grenades from a
// safe spot.
//===========
float() GugQuakeCheck =
{
    if (self.search_time < time)    // Use only when player is camping.
    if (time >= self.attack_finished)
    if (self.waitmax < time)    // Use only after a delay.
    if (enemy_range <= RANGE_MID)
    if (random() < 0.2)
    if (Grounded (self.enemy))  // Function in cool.qc.
    if (GugOnGround ())
    {
//dprint("harass!\n");
        local   float   nextone;

        gug_quake2 ();
        nextone = 1 + 2 * random();
        SUB_AttackFinished (nextone);
        return TRUE;
    }
    return FALSE;
};

//===========
// GugCheckAttack
//
// The player is in view, so decide to move or launch an attack
// Returns FALSE if movement should continue
//============
float() GugCheckAttack =
{
    local   vector  spot1, spot2;    
    local   entity  targ;
    local   float   chance;
    local   float   dist;

    if (enemy_range > RANGE_MID)
        return FALSE;   // Lacks long range attacks.

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

    // With the bilebomb and earthquake attacks, the gug is all about
    // collateral damage, much like Lina's Dragon Slave from The Slayers.
    // Therefore, don't bother checking for friendly fire, only if the
    // target is in line of sight.
    traceline (spot1, spot2, TRUE, self);

    if (trace_inopen && trace_inwater)
        return FALSE;            // sight line crossed contents

    if (trace_fraction < 1)
        return FALSE;    // don't have a clear shot

// missile attack
    if (random () >= 0.2)
        return FALSE;

    chance = 1 + 2*random();
    self.th_missile ();
    SUB_AttackFinished (chance);
    return TRUE;
};


//============================================================================

void() Gug_Explosion =
{
    local   entity  e;

    e = spawn();
    setorigin (e, self.origin);
    sound (e, CHAN_AUTO, "gug/bile.wav", 1, ATTN_NORM);
    remove (e);

    Tent_Explosion2 (self.origin, 48, 16);
    BecomeFancy (X56_SPLASH_GREEN, 3);
};

void(float ofs) GugFrag_Launch =
{
    local   vector  dir, vel;
    local   float   r;
    local   float   qsin, qcos;

// Find cosine and sine of offset angle.
    r = random() * 60 + 30;
    dir = '0 0 0';
    dir_y = r;
    makevectors (dir);
    qcos = v_forward_x;
    qsin = v_forward_y;

    dir = '0 0 0';
    dir_y = ofs;
    makevectors (dir);
    vel = ((v_forward * qcos) + (v_up * qsin)) * 400;

    newmis = spawn ();
    newmis.master       = self.master;
    newmis.owner        = self.owner;
    newmis.movetype     = MOVETYPE_BOUNCE;
    newmis.solid        = SOLID_BBOX;
    newmis.classname    = "acid";
// set missile speed
    newmis.speed        = 300;  //400;
    newmis.velocity     = vel;
    newmis.avelocity    = '300 300 300';
    newmis.angles       = vectoangles(newmis.velocity);
// set missile damage
    newmis.dmg          = self.dmg;
    newmis.style        = self.style;
// set missile duration
    newmis.touch        = T_MissileTouch;
    newmis.nextthink    = time + 0.5 + random()*0.5;
    newmis.think        = T_MissileExplode;
    newmis.think1       = Gug_Explosion;

    setall (newmis, "progs/acidbal2.mdl", '0 0 0', '0 0 0', self.origin);
};

void() Gug_Split =
{
    local   float   add, ofs;

    if (self.cnt < 2)
        self.cnt = 2;   // Need at least two shots for useful splitting.
    else if (self.cnt > 8)
        self.cnt = 8;   // Protect against excess edict spawning.

    add = 360 / self.cnt;
    ofs = random() * add;
    while (ofs < 360)
        {GugFrag_Launch (ofs);  ofs = ofs + add;}
};

// Call this instead of T_Missilexxx because of splitting.
void() Gug_Touch =
{
    if (pointcontents(self.origin) == CONTENT_SKY)
        {remove(self);  return;}
    if (Reflected_Damage (COURAGE_DAMAGE))
        return;

    if (!self.dmg)
        self.dmg = 60;

    self.touch = SUB_Null;      // Stack overflow prevention.
/* FIXME:  As firebomb.
    if (other.takedamage == DAMAGE_AIM)
    {   // On direct hit, bypass split and explode for double damage.
        local   float   damage;

        damage = SUB_RandomDamage (self.dmg * 2);
        T_NewDamage (other, self, self.master, damage, self.style, self.classname);
    }
    else
*/
        Gug_Split ();    // Split into mini-bombs.
    T_NewRadiusDamage (self, self.master, self.dmg, other, self.style, self.classname);

    self.origin = self.origin - 8*normalize(self.velocity);
    Gug_Explosion ();
};

void(vector start, vector dir, float sped, float damage) Gug_Launch =
{
    newmis = spawn ();
    newmis.master       = newmis.owner      = self;
    newmis.movetype     = MOVETYPE_TOSS;
    newmis.solid        = SOLID_BBOX;
    newmis.classname    = "acid";
// set missile speed
    newmis.speed        = sped;
    newmis.velocity     = dir * sped;
    newmis.avelocity    = '200 100 300';
    newmis.angles       = vectoangles(newmis.velocity);
// set missile damage
    newmis.dmg          = damage;
    newmis.cnt          = 5;
// set missile special stuff
    newmis.dest         = dir;
    newmis.style        = DF_ACID | DF_ROCKET;
// set missile duration
    newmis.touch        = Gug_Touch;
    newmis.nextthink    = time + 5;
    newmis.think        = SUB_Remove;
    newmis.think1       = Gug_Explosion;

    setall (newmis, "progs/acidbal1.mdl", '0 0 0', '0 0 0', start);
};

void() Gug_Fork =
{
    local   entity  swap;
    local   vector  org, vx, vy;
    local   float   sped, damage;

    vx = vectoangles (self.velocity);
    makevectors (vx);
    vx = normalize (self.velocity);
    vy = v_right * 0.2;

    org = self.origin;
    sped = self.speed;
    damage = self.dmg;

    swap = self;
    self = self.master;
    Gug_Launch (org, vx + vy, sped, damage);
    Gug_Launch (org, vx - vy, sped, damage);
    self = swap;

    remove (self);
};

void() gugfire =
{
    local   entity  targ;
    local   vector  org, vec;
    local   float   sped;

// Ugh!  Chapter's custom leading.  I'll leave it as it as, mostly.
    org = self.origin + '0 0 56';
    if (self.enemy && visible (self.enemy))
    {
        vec = self.enemy.origin;
        targ = self.enemy;
    }
    else
    {
        vec = self.aim_here;
        targ = world;
    }

/*
    if (visible (self.enemy))
    {
        local   vector  lead;

        lead = '0 0 0';
        if (self.enemy.classname == "player")
        {
            lead = self.enemy.velocity * 0.4;
            lead_z = lead_z * 0.2;
        }
        vec = self.enemy.origin + lead;
    }
    else
        vec = (self.aim_here);
    vec = normalize (vec - org);
*/
//    sped = 600;
    sped = vlen (self.enemy.origin - self.origin) + 100;
    if (sped > 1000)
        sped = 1000;

    vec = Maim_Toss (org, vec, sped, 200, targ, '0 0 0');
    Gug_Launch (org, vec, sped, 30);
    newmis.velocity_z = newmis.velocity_z + 200;
    newmis.nextthink = time + 0.3;
    newmis.think = Gug_Fork;
//    GugBomb_Launch (org, vec);
};


//============================================================================

// STAND - - - - - - - - - - - - - - - -
// Only stand has idle sound, others have steps.
void() gug_stand1 =[ $idle1,  gug_stand2  ]
{
    self.walkframe = -1;
    self.height = $idle1;
    gug_stand2();
};
void() gug_stand2 =[ $idle1,  gug_stand2  ]
{
// Animate monster.
    self.walkframe = self.walkframe + 1;
    // Long scene is several merged, like drole.
    if ((self.walkframe < 0) || (self.walkframe >= 20))
    {
        local   float   r;
    
        r = random() * 4;
        if (r < 1)
            self.height = $idle1;
        else if (r < 2)
            self.height = $idle21;
        else if (r < 3)
            self.height = $idle41;
        else
            self.height = $idle61;
        self.walkframe = 0;
        if (random() > 0.8)
            sound (self, CHAN_VOICE, "gug/idle.wav", 1, ATTN_IDLE);
    }
    self.frame = self.height + self.walkframe;

// Monster AI.
    ai_stand();
};

// WALK - - - - - - - - - - - - - - - -
void() Sfx_GugStep =
{
// There's four step sounds, but they are sound alike, and I need
// slots to precache stuff.  Use only one sound.
    sound (self, CHAN_FOOT, "gug/step1.wav", 1, ATTN_IDLE);
};

void() gug_walk1  =[ $walk1,  gug_walk2  ] {ai_walk(3); Sfx_GugStep();};
void() gug_walk2  =[ $walk2,  gug_walk3  ] {ai_walk(3);};
void() gug_walk3  =[ $walk3,  gug_walk4  ] {ai_walk(7);};
void() gug_walk4  =[ $walk4,  gug_walk5  ] {ai_walk(8);};
void() gug_walk5  =[ $walk5,  gug_walk6  ] {ai_walk(4);};
void() gug_walk6  =[ $walk6,  gug_walk7  ] {ai_walk(3);};
void() gug_walk7  =[ $walk7,  gug_walk8  ] {ai_walk(3);};
void() gug_walk8  =[ $walk8,  gug_walk9  ] {ai_walk(5);};
void() gug_walk9  =[ $walk9,  gug_walk10 ] {ai_walk(4); Sfx_GugStep();};
void() gug_walk10 =[ $walk10, gug_walk11 ] {ai_walk(5);};
void() gug_walk11 =[ $walk11, gug_walk12 ] {ai_walk(6);};
void() gug_walk12 =[ $walk12, gug_walk13 ] {ai_walk(6);};
void() gug_walk13 =[ $walk13, gug_walk14 ] {ai_walk(5);};
void() gug_walk14 =[ $walk14, gug_walk15 ] {ai_walk(3);};
void() gug_walk15 =[ $walk15, gug_walk16 ] {ai_walk(3);};
void() gug_walk16 =[ $walk16, gug_walk1  ] {ai_walk(3);};

// RUN - - - - - - - - - - - - - - - - -
void() gug_run1 =[ $run1, gug_run2 ] {ai_run(8); Sfx_GugStep();};
void() gug_run2 =[ $run2, gug_run3 ] {ai_run(8);};
void() gug_run3 =[ $run3, gug_run4 ] {ai_run(12);};
void() gug_run4 =[ $run4, gug_run5 ] {ai_run(12);};
void() gug_run5 =[ $run5, gug_run6 ] {ai_run(18); Sfx_GugStep();};
void() gug_run6 =[ $run6, gug_run7 ] {ai_run(15);};
void() gug_run7 =[ $run7, gug_run8 ] {ai_run(11);};
void() gug_run8 =[ $run8, gug_run1 ] {ai_run(18);};

// ATTACK (Melee) - - - - - - - - - - -
void(float damage) GugHit =
{
    local   entity  head;
    local   vector  vel;
    local   float   hits;

    // If gug hits at least one entity, play smack sound.
    hits = 0;

    ai_charge(10);

// Gug hits everyone infront, so use findradius.
    head = findradius(self.origin, 120);
    while (head)
    {
        if (head != self)
        if (head.takedamage || (head.flags & FLx_CREATURE))
        if (infront (head))
        if (CanDamage (head, self))
        {
            hits = hits + 1;    // Gug whacked someone.

            // Send the victim flying back.
            if (head.mass && (head.mass <= MASS_SUPER))
            {
                vel = normalize (head.origin - self.origin) * 200;
                vel_z = vel_z + 400;
                if (head.mass == MASS_SUPER)
                    vel = vel * 0.5;
                head.flags = head.flags - (head.flags & FL_ONGROUND);
                head.velocity = head.velocity + vel;
            }
            // Use scar damage to crush zombies.
            T_NewDamage (head, self, self, damage, DF_SCAR, "");
        }
        head = head.chain;
    }

    if (hits)
        sound (self, CHAN_AUTO, "shambler/smack.wav", 1, ATTN_NORM);
};

void() GugCancelCheck =
{
    if (InMeleeRange (150))
    {
        if (self.enemy.health > 0)
            return;
        if (self.enemy.modelindex == self.enemy.mindex2)
            return;
    }
    self.think = gug_run1;
};

void() gug_swingl1  =[ $swipel1,  gug_swingl2   ] {ai_charge(8); sound (self, CHAN_VOICE, "gug/swipe.wav", 1, ATTN_NORM);};
void() gug_swingl2  =[ $swipel2,  gug_swingl3   ] {ai_charge(8);};
void() gug_swingl3  =[ $swipel3,  gug_swingl4   ] {ai_charge(12);};
void() gug_swingl4  =[ $swipel4,  gug_swingl5   ] {ai_charge(12);};
void() gug_swingl5  =[ $swipel5,  gug_swingl6   ] {ai_charge(18); Sfx_GugStep();};
void() gug_swingl6  =[ $swipel6,  gug_swingl7   ] {ai_charge(15);};
void() gug_swingl7  =[ $swipel7,  gug_swingl8   ] {ai_charge(5);};
void() gug_swingl8  =[ $swipel8,  gug_swingl9   ] {ai_charge(4); GugHit(35);};
void() gug_swingl9  =[ $swipel9,  gug_swingl10  ] {ai_charge(4);};
void() gug_swingl10 =[ $swipel10, gug_swingl11  ] {ai_charge(4);};
void() gug_swingl11 =[ $swipel11, gug_swingl12  ] {ai_charge(4);};
void() gug_swingl12 =[ $swipel12, gug_swingl13  ] {ai_charge(4);};
void() gug_swingl13 =[ $swipel13, gug_swingl14  ] {ai_charge(4); GugCancelCheck();};
void() gug_swingl14 =[ $swipel14, gug_swingl15  ] {ai_charge(4); sound (self, CHAN_WEAPON, "gug/throw.wav", 1, ATTN_NORM);};
void() gug_swingl15 =[ $swipel15, gug_swingl16  ] {ai_charge(4);};
void() gug_swingl16 =[ $swipel16, gug_swingl17  ] {ai_charge(3);};
void() gug_swingl17 =[ $swipel17, gug_swingl18  ] {ai_charge(2);};
void() gug_swingl18 =[ $swipel18, gug_swingl19  ] {ai_charge(8); GugHit(45);};
void() gug_swingl19 =[ $swipel19, gug_swingl20  ] {ai_charge(12);};
void() gug_swingl20 =[ $swipel20, gug_swingl21  ] {ai_charge(14);};
void() gug_swingl21 =[ $swipel21, gug_swingl22  ] {ai_charge(20); Sfx_GugStep();};
void() gug_swingl22 =[ $swipel22, gug_swingl23  ] {ai_charge(15);};
void() gug_swingl23 =[ $swipel23, gug_run1      ] {ai_charge(11);};


void() gug_swingr1  =[ $swiper1,  gug_swingr2   ] {ai_charge(8); sound (self, CHAN_VOICE, "gug/swipe.wav", 1, ATTN_NORM);};
void() gug_swingr2  =[ $swiper2,  gug_swingr3   ] {ai_charge(8);};
void() gug_swingr3  =[ $swiper3,  gug_swingr4   ] {ai_charge(12);};
void() gug_swingr4  =[ $swiper4,  gug_swingr5   ] {ai_charge(12);};
void() gug_swingr5  =[ $swiper5,  gug_swingr6   ] {ai_charge(18); Sfx_GugStep();};
void() gug_swingr6  =[ $swiper6,  gug_swingr7   ] {ai_charge(6);};
void() gug_swingr7  =[ $swiper7,  gug_swingr8   ] {ai_charge(5);};
void() gug_swingr8  =[ $swiper8,  gug_swingr9   ] {ai_charge(4); GugHit(35);};
void() gug_swingr9  =[ $swiper9,  gug_swingr10  ] {ai_charge(4);};
void() gug_swingr10 =[ $swiper10, gug_swingr11  ] {ai_charge(4);};
void() gug_swingr11 =[ $swiper11, gug_swingr12  ] {ai_charge(4);};
void() gug_swingr12 =[ $swiper12, gug_swingr13  ] {ai_charge(4);};
void() gug_swingr13 =[ $swiper13, gug_swingr14  ] {ai_charge(4); GugCancelCheck();};
void() gug_swingr14 =[ $swiper14, gug_swingr15  ] {ai_charge(4); sound (self, CHAN_WEAPON, "gug/throw.wav", 1, ATTN_NORM);};
void() gug_swingr15 =[ $swiper15, gug_swingr16  ] {ai_charge(4);};
void() gug_swingr16 =[ $swiper16, gug_swingr17  ] {ai_charge(3);};
void() gug_swingr17 =[ $swiper17, gug_swingr18  ] {ai_charge(2);};
void() gug_swingr18 =[ $swiper18, gug_swingr19  ] {ai_charge(8); GugHit(45);};
void() gug_swingr19 =[ $swiper19, gug_swingr20  ] {ai_charge(12);};
void() gug_swingr20 =[ $swiper20, gug_swingr21  ] {ai_charge(14);};
void() gug_swingr21 =[ $swiper21, gug_swingr22  ] {ai_charge(20); Sfx_GugStep();};
void() gug_swingr22 =[ $swiper22, gug_swingr23  ] {ai_charge(15);};
void() gug_swingr23 =[ $swiper23, gug_run1      ] {ai_charge(11);};

void() gug_melee =
{
    if (random() > 0.5)
        gug_swingl1 ();
    else
        gug_swingr1 ();
};

// ATTACK (Missile) - - - - - - - - - -
void() gug_bile1  =[ $bile1,  gug_bile2   ] {ai_face(); ai_shotcheck(); sound (self, CHAN_WEAPON, "gug/bileatk.wav", 1, ATTN_NORM);};
void() gug_bile2  =[ $bile2,  gug_bile3   ] {ai_face(); ai_shotcheck();};
void() gug_bile3  =[ $bile3,  gug_bile4   ] {ai_face(); ai_shotcheck();};
void() gug_bile4  =[ $bile4,  gug_bile5   ] {ai_face(); ai_shotcheck();};
void() gug_bile5  =[ $bile5,  gug_bile6   ] {ai_face(); ai_shotcheck();};
void() gug_bile6  =[ $bile6,  gug_bile7   ] {ai_face(); ai_shotcheck();};
void() gug_bile7  =[ $bile7,  gug_bile8   ] {ai_face(); ai_shotcheck(); gugfire();};
void() gug_bile8  =[ $bile8,  gug_bile9   ] {ai_face();};
void() gug_bile9  =[ $bile9,  gug_bile10  ] {ai_face();};
void() gug_bile10 =[ $bile10, gug_bile11  ] {ai_face();};
void() gug_bile11 =[ $bile11, gug_bile12  ] {ai_face();};
void() gug_bile12 =[ $bile12, gug_bile13  ] {ai_face();};
void() gug_bile13 =[ $bile13, gug_bile14  ] {ai_face();};
void() gug_bile14 =[ $bile14, gug_bile15  ] {ai_face();};
void() gug_bile15 =[ $bile15, gug_bile16  ] {ai_face();};
void() gug_bile16 =[ $bile16, gug_bile17  ] {ai_face();};
void() gug_bile17 =[ $bile17, gug_bile18  ] {ai_face();};
void() gug_bile18 =[ $bile18, gug_run1    ] {ai_face();};

void() gug_quake1  =[ $quake1,  gug_quake2   ] {ai_face(); sound (self, CHAN_WEAPON, "gug/quakeatk.wav", 1, ATTN_NORM);};
void() gug_quake2  =[ $quake2,  gug_quake3   ] {ai_face();};
void() gug_quake3  =[ $quake3,  gug_quake4   ] {ai_face();};
void() gug_quake4  =[ $quake4,  gug_quake5   ] {ai_face();};
void() gug_quake5  =[ $quake5,  gug_quake6   ] {ai_face();};
void() gug_quake6  =[ $quake6,  gug_quake7   ] {ai_face();};
void() gug_quake7  =[ $quake7,  gug_quake8   ] {ai_face();};
void() gug_quake8  =[ $quake8,  gug_quake9   ] {ai_face();};
void() gug_quake9  =[ $quake9,  gug_quake10  ] {ai_face();};
void() gug_quake10 =[ $quake10, gug_quake11  ] {ai_face();
    if (GugOnGround ())
    {
        sound (self, CHAN_AUTO, "gug/gquake.wav", 1, ATTN_NORM);
        Quake_Self (800, 10, self.origin, DF_TIMED, 3);
        self.waitmax = time + 5;    // No more quakes for five seconds.
    }
    // ELSE... No quake because ground was pulled out from under gug!
};
void() gug_quake11 =[ $quake11, gug_quake12  ] {ai_face();};
void() gug_quake12 =[ $quake12, gug_quake13  ] {ai_face();};
void() gug_quake13 =[ $quake13, gug_quake14  ] {ai_face();};
void() gug_quake14 =[ $quake14, gug_quake15  ] {ai_face();};
void() gug_quake15 =[ $quake15, gug_quake16  ] {ai_face();};
void() gug_quake16 =[ $quake16, gug_quake17  ] {ai_face();};
void() gug_quake17 =[ $quake17, gug_quake18  ] {ai_face();};
void() gug_quake18 =[ $quake18, gug_quake19  ] {ai_face();};
void() gug_quake19 =[ $quake19, gug_quake20  ] {ai_face();};
void() gug_quake20 =[ $quake20, gug_quake21  ] {ai_face();};
void() gug_quake21 =[ $quake21, gug_quake22  ] {ai_face();};
void() gug_quake22 =[ $quake22, gug_quake23  ] {ai_face();};
void() gug_quake23 =[ $quake23, gug_quake24  ] {ai_face();};
void() gug_quake24 =[ $quake24, gug_run1     ] {ai_face();};

void() gug_missile =
{
    if (self.waitmax <= time)
    if (random() < 0.25)
    if (Grounded (self.enemy))  // Function in cool.qc.
    if (GugOnGround ())
        {gug_quake1 ();  return;}

    gug_bile1 ();
};

// PAIN - - - - - - - - - - - - - - - -
void() gug_pain1 =[ $pain1, gug_pain2 ] {};
void() gug_pain2 =[ $pain2, gug_pain3 ] {ai_back(20);};
void() gug_pain3 =[ $pain3, gug_pain4 ] {ai_back(5);};
void() gug_pain4 =[ $pain4, gug_pain5 ] {ai_back(10);};
void() gug_pain5 =[ $pain5, gug_pain6 ] {ai_forward(2);};
void() gug_pain6 =[ $pain6, gug_run1  ] {ai_forward(2);};

void(entity attacker, float damage) gug_pain =
{
// don't make multiple pain sounds right after each other
    if (self.pain_finished > time)
        return;
    if (random() >= 0.2)    // Drole is 0.3.
        return;     // didn't flinch

    self.pain_finished = time + 2;
    sound (self, CHAN_VOICE, "gug/pain.wav", 1, ATTN_NORM);
    if (SUB_IgnorePain ())
        return;
    gug_pain1 ();

    damage = damage;  attacker = attacker;  // Appease Qcc.
};

// DEATH - - - - - - - - - - - - - - - -
// The gug is too big to suffer a special death.
void() gug_death1  =[ $death1,  gug_death2  ] {sound (self, CHAN_VOICE, "gug/death.wav", 1, ATTN_NORM);};
void() gug_death2  =[ $death2,  gug_death3  ] {};
void() gug_death3  =[ $death3,  gug_death4  ] {};
void() gug_death4  =[ $death4,  gug_death5  ] {};
void() gug_death5  =[ $death5,  gug_death6  ] {};
void() gug_death6  =[ $death6,  gug_death7  ] {};
void() gug_death7  =[ $death7,  gug_death8  ] {};
void() gug_death8  =[ $death8,  gug_death9  ] {};
void() gug_death9  =[ $death9,  gug_death10 ] {};
void() gug_death10 =[ $death10, gug_death11 ] {};
void() gug_death11 =[ $death11, gug_death12 ] {};
void() gug_death12 =[ $death12, gug_death13 ] {};
void() gug_death13 =[ $death13, gug_death14 ] {};
void() gug_death14 =[ $death14, gug_death15 ] {};
void() gug_death15 =[ $death15, gug_death16 ] {};
void() gug_death16 =[ $death16, gug_death17 ] {};
void() gug_death17 =[ $death17, gug_death18 ] {};
void() gug_death18 =[ $death18, gug_death19 ] {};
void() gug_death19 =[ $death19, gug_death20 ] {};
void() gug_death20 =[ $death20, gug_death21 ] {};
void() gug_death21 =[ $death21, gug_death22 ] {monster_drop();};
void() gug_death22 =[ $death22, gug_death24 ] {};
void() gug_death23 =[ $death23, gug_death24 ] {};
void() gug_death24 =[ $death24, gug_death25 ] {};
void() gug_death25 =[ $death25, gug_death26 ] {Quake_Self (800, 0, self.origin, DF_TIMED|DF_NO_KNOCK, 0.5);};
void() gug_death26 =[ $death26, gug_death27 ] {};
void() gug_death27 =[ $death27, gug_death28 ] {};
void() gug_death28 =[ $death28, gug_death29 ] {};
void() gug_death29 =[ $death29, gug_death30 ] {};
void() gug_death30 =[ $death30, gug_death31 ] {};
void() gug_death31 =[ $death31, gug_death32 ] {};
void() gug_death32 =[ $death32, gug_death33 ] {};
void() gug_death33 =[ $death33, gug_death34 ] {};
void() gug_death34 =[ $death34, gug_death35 ] {};
void() gug_death35 =[ $death35, gug_death36 ] {};
void() gug_death36 =[ $death36, gug_death37 ] {};
void() gug_death37 =[ $death37, gug_death38 ] {};
void() gug_death38 =[ $death38, gug_death39 ] {};
void() gug_death39 =[ $death39, gug_death40 ] {};
void() gug_death40 =[ $death40, gug_death41 ] {};
void() gug_death41 =[ $death41, monster_end ] {};

// REVIVE - - - - - - - - - - - - - - -
// FIXME:  Make sure it works if enabled.
void() gug_revive1  =[ $death24,  gug_revive2  ] {};
void() gug_revive2  =[ $death22,  gug_revive3  ] {};
void() gug_revive3  =[ $death20,  gug_revive4  ] {};
void() gug_revive4  =[ $death18,  gug_revive5  ] {};
void() gug_revive5  =[ $death16,  gug_revive6  ] {};
void() gug_revive6  =[ $death14,  gug_revive7  ] {};
void() gug_revive7  =[ $death12,  gug_revive8  ] {};
void() gug_revive8  =[ $death10,  gug_revive9  ] {};
void() gug_revive9  =[ $death8,   gug_revive10 ] {};
void() gug_revive10 =[ $death6,   gug_revive11 ] {};
void() gug_revive11 =[ $death4,   gug_revive12 ] {};
void() gug_revive12 =[ $death2,   gug_run1     ] {};


//============================================================================

// OTHER - - - - - - - - - - - - - - - -
void(float hello) gug_sight =
{
    if (hello)
        sound (self, CHAN_VOICE, "gug/idle.wav", 1, ATTN_NORM);
    else
        sound (self, CHAN_VOICE, "gug/sight.wav", 1, ATTN_NORM);
};

void() gug_cache =
{
    precache_model ("progs/gug.mdl");
    precache_model ("progs/acidbal1.mdl");
    precache_model ("progs/acidbal2.mdl");
    
    precache_sound ("gug/bile.wav");
    precache_sound ("gug/bileatk.wav");
    precache_sound ("gug/death.wav");
    precache_sound ("gug/gquake.wav");
    precache_sound ("gug/idle.wav");
    precache_sound ("gug/pain.wav");
    precache_sound ("gug/quakeatk.wav");
    precache_sound ("gug/sight.wav");
    precache_sound ("gug/step1.wav");
// Drake sucks a lot of sound slots, so just one step sound for the gug.
//    precache_sound ("gug/step2.wav");
//    precache_sound ("gug/step3.wav");
//    precache_sound ("gug/step4.wav");
    precache_sound ("gug/swipe.wav");
    precache_sound ("gug/throw.wav");
    precache_sound ("shambler/smack.wav");
};

//============
// --> QUAKED monster_gug (1 0 0) (-32 -32 -24) (32 32 64) Ambush
//============
void() monster_gug =
{
    if (!self.spawned)
    {
        if (noenemies)
            {remove (self); return;}
        gug_cache ();
    }

    monster_form ("progs/gug.mdl", VEC_HULL2_MIN, VEC_HULL2_MAX, 1000, 0);
    self.mass       = MASS_SUPER;

    self.th_stand   = gug_stand1;
    self.th_walk    = gug_walk1;
    self.th_run     = gug_run1;
    self.th_missile = gug_missile;
    self.th_melee   = gug_melee;
    self.th_pain    = gug_pain;
    self.th_die     = gug_death1;
    //- - - - - - - -
    self.th_sight   = gug_sight;
    self.th_check   = GugCheckAttack;
// DISABLED -- If sha'vile cannot be revived, neither should the gug.
//    self.th_revive  = gug_revive1;
    self.th_harass  = GugQuakeCheck;
    self.th_spawn   = monster_gug;

    self.waitmax = 0;       // Earthquake timer.

    monster_start ();
};


//===========================/  END OF FILE  /===========================//
