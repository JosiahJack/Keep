/*
==============================================================================

SKULL WIZARD

==============================================================================
*/

$cd id1/models/skullwiz
$origin 0 0 24
$base base        
$skin skin

$frame skdeth1 skdeth2 skdeth3 skdeth4 skdeth5 skdeth6 skdeth7 skdeth8
$frame skdeth9 skdeth10 skdeth11 skdeth12 skdeth13 skdeth14 skdeth15

$frame skgate1 skgate2 skgate3 skgate4 skgate5 skgate6 skgate7 skgate8
$frame skgate9 skgate10 skgate11 skgate12 skgate13 skgate14 skgate15
$frame skgate16 skgate17 skgate18 skgate19 skgate20 skgate21 skgate22
$frame skgate23 skgate24 skgate25 skgate26 skgate27 skgate28 skgate29
$frame skgate30

$frame skpain1 skpain2 skpain3 skpain4 skpain5 skpain6 skpain7 skpain8
$frame skpain9 skpain10 skpain11 skpain12

$frame skredi1 skredi2 skredi3 skredi4 skredi5 skredi6 skredi7 skredi8
$frame skredi9 skredi10 skredi11 skredi12

$frame skspel1 skspel2 skspel3 skspel4 skspel5 skspel6 skspel7 skspel8
$frame skspel9 skspel10 skspel11 skspel12 skspel13 skspel14 skspel15

$frame sktele1 sktele2 sktele3 sktele4 sktele5 sktele6 sktele7 sktele8
$frame sktele9 sktele10 sktele11 sktele12 sktele13 sktele14 sktele15

$frame sktran1 sktran2 sktran3 sktran4 sktran5 sktran6 sktran7

$frame skwait1 skwait2 skwait3 skwait4 skwait5 skwait6 skwait7 skwait8
$frame skwait9 skwait10 skwait11 skwait12 skwait13 skwait14 skwait15
$frame skwait16 skwait17 skwait18 skwait19

$frame skwalk1 skwalk2 skwalk3 skwalk4 skwalk5 skwalk6 skwalk7 skwalk8
$frame skwalk9 skwalk10 skwalk11 skwalk12 skwalk13 skwalk14 skwalk15
$frame skwalk16 skwalk17 skwalk18 skwalk19 skwalk20 skwalk21 skwalk22
$frame skwalk23 skwalk24

// Extra frames to emulate teleporting effects since we can't rely on scale.
$frame skwarp1 skwarp2 skwarp3 skwarp4 skwarp5 skwarp6 skwarp7 skwarp8
$frame skwarp9

//=============================================================================

//vector  VEC_HULL1_MIN   = '-16 -16 -24';
vector  VEC_HULL1_MAX   = '16 16 40';

//float() skullwiz_lord = {return (self.classname == "monster_skull_wizard_lord");};
float() skullwiz_grunt =
{
//    if (self.classname == "monster_skull_wizard_boss");
//        return FALSE;
//    if (self.classname == "monster_skull_wizard_lord");
//        return FALSE;
//    return TRUE;

    return (self.classname == "monster_skull_wizard");
};

float() SkullWizCheckAttack =
{
    if (enemy_range > RANGE_MID)
        return FALSE;   // Incapable of long range combat.
    return CheckAttack ();
};


//==========================================================================
//  Skull Missile

void() SkullShot_Think =
{
    if (self.delay <= time)
        {remove (self);  return;}

    local   string  sfx;
    local   vector  ang;
    local   float   pit;

    if (self.enemy)
        Missile_Seek (self.enemy);

    if (self.skin)
    {   // Oscillate up and down, like shots from Metroid's wave gun.
        if (self.lefty)
            pit = -10;
        else
            pit = 10;
        self.lefty = !self.lefty;

//        if (self.enemy)
//        {   self.ideal_yaw = vectoyaw (self.enemy.origin - self.origin);
//            ChangeYaw ();
//        }

        ang = self.angles;
        ang_x = 0 - ang_x + pit;
        makevectors (ang);
        self.velocity = v_forward * self.speed;

        pit = 0.2;
        sfx = "skullwiz/scream2.wav";
    }
    else
    {
        pit = 0.1;
        sfx = "skullwiz/scream.wav";
    }

    if (self.wait <= time)
    {
        sound (self, CHAN_BODY, sfx, 1, ATTN_IDLE);
        self.wait = time + ((random() + 1) / 2);
    }

    self.nextthink = time + pit;
};

void(vector start, vector dir, float type) SkullShot_Launch =
{
    local   entity  missile;

    missile = spawn ();
    missile.master      = missile.owner     = self;
    missile.movetype    = MOVETYPE_FLYMISSILE;
    missile.solid       = SOLID_BBOX;
    missile.classname   = "skull";
// set missile speed
    missile.speed       = 600;
    missile.velocity    = dir * 600;
    missile.angles      = vectoangles(missile.velocity);
// set missile damage
    missile.dmg         = 15 + (type * 5);
    missile.enemy       = world;
    missile.style       = DF_SAFE;      // Don't hurt attacker.
// set missile duration
    missile.touch       = T_MissileTouch;
    missile.wait        = time + ((random() + 1) / 2);
    missile.delay       = time + 2.5;
    missile.nextthink   = time + 0.1;
    missile.think       = SkullShot_Think;
    missile.think1      = Orange_Explosion;

    missile.effects     = EF_DIMLIGHT;
    if (type > 1)
    {
        type = 1;   // Only two skins in flaming skull shot model.
        missile.dmg = 30;
        missile.yaw_speed = 40;
        missile.enemy = self.enemy;
    }
    else
        missile.yaw_speed = 0;
    missile.skin        = type;
    setall (missile, "progs/skulshot.mdl", '0 0 0', '0 0 0', start);

    newmis = missile;
};

void(vector st) M_FireSkull =
{
    local   vector  p1, p2, dir;
    local   entity  targ;

//    if (cranked)
//        targ = self.enemy;
//    else
        targ = world;
    makevectors (self.angles);
    p1 = self.origin + (v_forward * st_x) + (v_right * st_y) + (v_up * st_z);
    p2 = Aimpoint (self.enemy);
    dir = Maim_Line (p1, p2, 600, targ, '0 0 0');

    self.effects = self.effects | EF_MUZZLEFLASH;
    sound (self, CHAN_WEAPON, "skullwiz/firemisl.wav", 1, ATTN_NORM);

    SkullShot_Launch (p1, dir, self.skin);
};


//==========================================================================
//  Spider Summoning

void() monster_spider;
void() spider_cache;
void() spider_grow1;

// Update 12/24/09:  Keep pets under control.
void(entity who) KillOldPet;    // In doomcube.qc

float() EntryPoint_SkullWizSummon =
{
    return EntryPoint_Randomize_Ex (self.owner.dest1_x, self.owner.dest1_y, self.owner.dest2);
};

float(float right) SkullWiz_Summon =
{
    local   entity  parent;

    parent = self;
// Update 1/1/10:  Kill off old pets instead of outright failure.
    if (parent.pets >= 5)
        KillOldPet (parent);

    self = spawn();
    self.flags      = 0;

    // Was in spawn test func
    self.master     = parent;   // Needed as beacon to test spawn points.
    self.movetype   = MOVETYPE_STEP;
    self.solid      = SOLID_NOT;
    self.angles     = parent.angles;    // In case of sub-360 random yaw.
    setsize (self, VEC_SPIDER_MIN, VEC_SPIDER_MAX);
    // Set dest* because they will be overriden later.
    if (parent.deadflag)
        {self.dest1 = '60 40 0';  self.dest2 = '0 360 0';}
    else
    {
        self.dest1 = '100 60 0';  self.dest2 = '0 45 -1';
        if (right)
            self.dest2_z = 1;
    }

    if (!EntryPoint_Spawn (self, parent, parent.origin, EntryPoint_SkullWizSummon))
    {   // Failed -- No spawn point available this time.
        remove (self);
        self = parent;
        return FALSE;
    }
// Found a viable spawn point, so finish spawning the monster.
    if (time)
        self.spawned    = time;
    else
        self.spawned    = TRUE;
    self.skin       = ((parent.skin + 1) / 2) & 1;
    self.spawnflags = parent.spawnflags & SPAWN_WHITE;
    self.classname  = "monster_spider";
// Face master, and fix the angles so monster stands upright.
    self.angles_x   = 0;
    self.angles_y   = vectoyaw(parent.origin - self.origin);
    self.angles_z   = 0;
    if (parent.enemy)   // Face enemy instead if applicable.
        if (visible (parent.enemy))
            self.angles_y   = vectoyaw(parent.enemy.origin - self.origin);
    self.fixangle   = TRUE;
    self.enemy      = parent.enemy;
    monster_spider ();

// Override normal ai with growth ai, since it is summoned by skull wizard.
    sound (self, CHAN_VOICE, "skullwiz/gate.wav", 1, ATTN_NORM);
    self.enemy      = parent.enemy;
    spider_grow1 ();
// Pet counter, used to enforce limits.
    if (parent.health > 0)
    {
        self.xfl = self.xfl | XFL_PET;
        parent.pets = parent.pets + 1;
    }
    else
        self.master = self.enemy = world;

// Successfully spawned a new creature.
    newmis = self;
    self = parent;
    return TRUE;
};

// Skull wizard calls for help.  First, he tries to revive monsters.
// If that fails, he will summon spiders like in Hexen2.
void() skullwiz_help =
{
    if (self.xfl & XFL_BOSS)
    {   // Arcanum's boss version will revive monsters.
        SkullWiz_Summon (1);
        if (random() < 0.15)
            SkullWiz_Summon (0);
//        KillExcessPets (self, 5);
//        if (mass_revive (650))     // Was 300/1000.
//            return;
    }

    SkullWiz_Summon (0);
    if (random() < 0.15)
        SkullWiz_Summon (1);
//    KillExcessPets (self, 5);
};


//=============================================================================

// Checks if skull wizard should activate his teleport defense.
float() skullwiz_defense =
{
    local   entity  targ;
    local   vector  v1, v2, dir;

    targ = self.enemy;
    if (!targ)
        return FALSE;
    if (!visible (targ))
        return FALSE;
    if (targ.attack_time + 0.5 < time)
    {
        if (!(targ.flags & FL_MONSTER))
            return FALSE;
        if (random() < 0.8)
            if (vlen (targ.origin - self.origin) > 120)
                return FALSE;
    }

    v1 = targ.origin + '0 0 16';
    v2 = Midpoint (self);
    dir = normalize (v2 - v1);
    if (targ.flags & FLx_CREATURE == FL_CLIENT)
        makevectors (targ.v_angle);
    else
    {   //if (random() < 0.2)
            return FALSE;
        makevectors (targ.angles);
    }
    return (v_forward*dir > 0.8);
};

//=============================================================================

// STAND - - - - - - - - - - - - - - - -
void() skullwiz_stand1  =[ $skwait1,  skullwiz_stand2  ] {ai_stand();};
void() skullwiz_stand2  =[ $skwait2,  skullwiz_stand3  ] {ai_stand();};
void() skullwiz_stand3  =[ $skwait3,  skullwiz_stand4  ] {ai_stand();};
void() skullwiz_stand4  =[ $skwait4,  skullwiz_stand5  ] {ai_stand();};
void() skullwiz_stand5  =[ $skwait5,  skullwiz_stand6  ] {ai_stand();};
void() skullwiz_stand6  =[ $skwait6,  skullwiz_stand7  ] {ai_stand();};
void() skullwiz_stand7  =[ $skwait7,  skullwiz_stand8  ] {ai_stand();};
void() skullwiz_stand8  =[ $skwait8,  skullwiz_stand9  ] {ai_stand();};
void() skullwiz_stand9  =[ $skwait9,  skullwiz_stand10 ] {ai_stand();};
void() skullwiz_stand10 =[ $skwait10, skullwiz_stand11 ] {ai_stand();};
void() skullwiz_stand11 =[ $skwait11, skullwiz_stand12 ] {ai_stand();};
void() skullwiz_stand12 =[ $skwait12, skullwiz_stand13 ] {ai_stand();};
void() skullwiz_stand13 =[ $skwait13, skullwiz_stand14 ] {ai_stand();};
void() skullwiz_stand14 =[ $skwait14, skullwiz_stand15 ] {ai_stand();};
void() skullwiz_stand15 =[ $skwait15, skullwiz_stand16 ] {ai_stand();};
void() skullwiz_stand16 =[ $skwait16, skullwiz_stand17 ] {ai_stand();};
void() skullwiz_stand17 =[ $skwait17, skullwiz_stand18 ] {ai_stand();};
void() skullwiz_stand18 =[ $skwait18, skullwiz_stand19 ] {ai_stand();};
void() skullwiz_stand19 =[ $skwait19, skullwiz_stand1  ] {ai_stand();};

// WALK - - - - - - - - - - - - - - - -
void() skullwiz_idle_sfx =
{
    if (skullwiz_grunt ())
        sound (self, CHAN_VOICE, "skullwiz/growl.wav", 1, ATTN_IDLE);
    else
        sound (self, CHAN_VOICE, "skullwiz/growl2.wav", 1, ATTN_IDLE);
};
void() skullwiz_walk1  =[ $skwalk1,  skullwiz_walk2  ] {
    if (random() < 0.1)
        skullwiz_idle_sfx ();
    ai_walk(2);
};
void() skullwiz_walk2  =[ $skwalk2,  skullwiz_walk3  ] {ai_walk(1);};
void() skullwiz_walk3  =[ $skwalk3,  skullwiz_walk4  ] {ai_walk(1);};
void() skullwiz_walk4  =[ $skwalk4,  skullwiz_walk5  ] {ai_walk(1);};
void() skullwiz_walk5  =[ $skwalk5,  skullwiz_walk6  ] {ai_walk(1);};
void() skullwiz_walk6  =[ $skwalk6,  skullwiz_walk7  ] {ai_walk(1);};
void() skullwiz_walk7  =[ $skwalk7,  skullwiz_walk8  ] {ai_walk(1);};
void() skullwiz_walk8  =[ $skwalk8,  skullwiz_walk9  ] {ai_walk(1);};
void() skullwiz_walk9  =[ $skwalk9,  skullwiz_walk10 ] {ai_walk(1);};
void() skullwiz_walk10 =[ $skwalk10, skullwiz_walk11 ] {ai_walk(1);};
void() skullwiz_walk11 =[ $skwalk11, skullwiz_walk12 ] {ai_walk(1);};
void() skullwiz_walk12 =[ $skwalk12, skullwiz_walk13 ] {ai_walk(1);};
void() skullwiz_walk13 =[ $skwalk13, skullwiz_walk14 ] {ai_walk(1);};
void() skullwiz_walk14 =[ $skwalk14, skullwiz_walk15 ] {ai_walk(1);};
void() skullwiz_walk15 =[ $skwalk15, skullwiz_walk16 ] {ai_walk(1);};
void() skullwiz_walk16 =[ $skwalk16, skullwiz_walk17 ] {ai_walk(1);};
void() skullwiz_walk17 =[ $skwalk17, skullwiz_walk18 ] {ai_walk(1);};
void() skullwiz_walk18 =[ $skwalk18, skullwiz_walk19 ] {ai_walk(1);};
void() skullwiz_walk19 =[ $skwalk19, skullwiz_walk20 ] {ai_walk(1);};
void() skullwiz_walk20 =[ $skwalk20, skullwiz_walk21 ] {ai_walk(1);};
void() skullwiz_walk21 =[ $skwalk21, skullwiz_walk22 ] {ai_walk(1);};
void() skullwiz_walk22 =[ $skwalk22, skullwiz_walk23 ] {ai_walk(1);};
void() skullwiz_walk23 =[ $skwalk23, skullwiz_walk24 ] {ai_walk(1);};
void() skullwiz_walk24 =[ $skwalk24, skullwiz_walk1  ] {ai_walk(1);};

// RUN - - - - - - - - - - - - - - - - -
void() skull_run;
void() skullwiz_run;
void(entity attacker, float damage) skullwiz_pain;

void() skullwiz_run1  =[ $skwalk1,  skullwiz_run2  ] {
    if (random() < 0.2)
        skullwiz_idle_sfx ();
    skull_run();
};
void() skullwiz_run2  =[ $skwalk3,  skullwiz_run3  ] {skull_run();};
void() skullwiz_run3  =[ $skwalk5,  skullwiz_run4  ] {skull_run();};
void() skullwiz_run4  =[ $skwalk7,  skullwiz_run5  ] {skull_run();};
void() skullwiz_run5  =[ $skwalk9,  skullwiz_run6  ] {skull_run();};
void() skullwiz_run6  =[ $skwalk11, skullwiz_run7  ] {skull_run();};
void() skullwiz_run7  =[ $skwalk13, skullwiz_run8  ] {skull_run();};
void() skullwiz_run8  =[ $skwalk15, skullwiz_run9  ] {skull_run();};
void() skullwiz_run9  =[ $skwalk17, skullwiz_run10 ] {skull_run();};
void() skullwiz_run10 =[ $skwalk19, skullwiz_run11 ] {skull_run();};
void() skullwiz_run11 =[ $skwalk21, skullwiz_run12 ] {skull_run();};
void() skullwiz_run12 =[ $skwalk23, skullwiz_run1  ] {skull_run();};

void(string sfx) skullwiz_telefx =
{
    //spawn_tfog (self.origin);
    Tent_Point (TE_TELEPORT, self.origin);
    sound (self, CHAN_AUTO, sfx, 1, ATTN_NORM);
};

float() EntryPoint_WizRandom =
{
    local   float   r;

    r = 80;
    if (self.enemy.flags & FL_MONSTER)
        if (self.enemy.th_melee)
            r = 400;
    return EntryPoint_Randomize (r, 120);  //random(120,200)
};

void() skullwiz_blinkspeak_sfx =
{
    if (skullwiz_grunt ())
        sound (self, CHAN_VOICE, "skullwiz/blinkspk.wav", 1, ATTN_NORM);
    else
        sound (self, CHAN_VOICE, "skullwiz/blnkspk2.wav", 1, ATTN_NORM);
};

void() skullwiz_bfast1  =[ $sktele1,  skullwiz_bfast2  ] {skullwiz_blinkspeak_sfx();};
void() skullwiz_bfast2  =[ $sktele8,  skullwiz_blink8  ] {};

void() skullwiz_blink1  =[ $sktele1,  skullwiz_blink2  ] {skullwiz_blinkspeak_sfx();
    if (cranked || (self.xfl & XFL_BOSS))
        self.think = skullwiz_bfast2;
};
void() skullwiz_blink2  =[ $sktele3,  skullwiz_blink3  ] {};
void() skullwiz_blink3  =[ $sktele5,  skullwiz_blink4  ] {};
void() skullwiz_blink4  =[ $sktele7,  skullwiz_blink5  ] {};
void() skullwiz_blink5  =[ $sktele9,  skullwiz_blink6  ] {};
void() skullwiz_blink6  =[ $sktele11, skullwiz_blink7  ] {};
void() skullwiz_blink7  =[ $sktele13, skullwiz_blink8  ] {};
void() skullwiz_blink8  =[ $sktele15, skullwiz_blink9  ]
{
    self.takedamage = DAMAGE_NO;
    self.solid = SOLID_NOT;
    self.th_pain = SUB_Null;
};
void() skullwiz_blink9  =[ $skwarp2,  skullwiz_blink10 ] {};
void() skullwiz_blink10 =[ $skwarp4,  skullwiz_blink11 ] {};    //self.alpha = 0.75;};
void() skullwiz_blink11 =[ $skwarp6,  skullwiz_blink12 ] {};    //self.alpha = 0.5;};
void() skullwiz_blink12 =[ $skwarp8,  skullwiz_blink13 ] {};    //self.alpha = 0.25;};
void() skullwiz_blink13 =[ $skwarp9,  skullwiz_blinkin ]
{
    skullwiz_telefx ("skullwiz/blinkout.wav");
    setform (self, "", VEC_HULL_MIN, VEC_HULL1_MAX);    //self.modelindex = 0;
    self.nextthink = random() * 2.5 + 0.5 + time;
    if (self.search_time < time)
        self.search_time = time;
};

//- - - - - - - - -
float(entity who) skullwiz_seek;
//- - - - - - - - -
void() skullwiz_in1 =[ $skwarp8,  skullwiz_in2     ] {ai_face();};  //self.alpha = 0.25;};
void() skullwiz_in2 =[ $skwarp6,  skullwiz_in3     ] {ai_face();};  //self.alpha = 0.5;};
void() skullwiz_in3 =[ $skwarp4,  skullwiz_in4     ] {ai_face();};  //self.alpha = 0.75;};
void() skullwiz_in4 =[ $skwarp2,  skullwiz_run1    ] {ai_face();};  //self.alpha = 0;};
void() skullwiz_blinkin =[ $skwarp9,  skullwiz_blinkin ]
{
// Note:  Hexen2 did 500 checks every 2 seconds.
// In Drake, random teleport does 100 checks every other frame.
    local   entity  who;

// FIXME:  What if 'who' flies, phase through walls, or doesn't exist?
// Also, what if enemy hides at the top of a high pedestal?
    who = self;
    if (self.fighting)
    {   if (self.enemy)
            who = self.enemy;
    }
    else if (self.master)
        who = self.master;

    if (who)
    {
        if (!(who.flags & FL_ONGROUND))
        {
            traceline (who.origin, who.origin - '0 0 256', TRUE, who);
            if (trace_fraction == 1)
                who = self;     // Cannot go to target, so use self as beacon.
        }
        // FIXME:  If target is inside the wall (ghost?), warp back?
    }
    // FIXME:  ???else pick a player spawn point.

    if (skullwiz_seek (who))
        return;
    if (self.search_time + 5 < time)
    {   // Failed for too long, so warp back back close to original spot.
        if (skullwiz_seek (self))
            return;
    }
// Failed.
    self.nextthink = time + 0.2;

    // Update 6/3/11:  If wizard couldn't teleport after a really long time,
    // just telefrag and kill him!  Answers the FIXME problems above.
    // Not the ideal solution, but it is a solution.
    if (self.search_time + 120 < time)
        T_Kill (self, world, world, -99, "teledeath");
};
//- - - - - - - - -
float(entity who) skullwiz_seek =
{
    if (EntryPoint_Spawn (self, who, who.origin, EntryPoint_WizRandom))
    {
        // We found a potential spot, so warp in if wizard can move there.
        if (walkmove (0, 0))
        {
            skullwiz_telefx ("skullwiz/blinkin.wav");
            self.solid      = SOLID_SLIDEBOX;
            self.takedamage = DAMAGE_AIM;
            self.th_pain    = skullwiz_pain;
            setform (self, self.mdl, VEC_HULL_MIN, VEC_HULL1_MAX);
            skullwiz_in1 ();
            return TRUE;
        }
    }
    return FALSE;
};
//- - - - - - - - -

void() skull_run =
{
    local   float   yes;

// Check for attacks to defend against.
    yes = 0;
    if (self.health < 50)
        yes = 1;
    else if (!skullwiz_grunt ())
        yes = 1;
    if (yes)
        if (skullwiz_defense ())
        {
            skullwiz_bfast1 ();
            return;
        }

// Check for teleportitus.
    if ( self.frame == $skwalk1 )
    {
        yes = 0;
        if (self.fighting)
            yes = 1;
        else
        {
            if (self.master)
                if (!visible (self.master))
                    yes = 1;
        }

        if (yes)
        {
            if (skullwiz_grunt ())
                yes = 0.2;
            else
                yes = 0.3;
            if (self.xfl & XFL_BOSS)
                yes = yes / 2;      // Don't let boss spam teleport as much.
            if (random() < yes)
            {
                skullwiz_blink1 ();
                return;
            }
        }
    }

// Check for teleportitus.
    ai_run(3);
};

// Initial run function.
void() skullwiz_run =
{
    if (self.th_pain == SUB_Null)
        skullwiz_blinkin ();    // Was phased out, so phase back in.
    else
        skullwiz_run1 ();
};

// ATTACK - - - - - - - - - - - - - - -
void() skullwiz_gate1   =[ $skgate1,  skullwiz_gate2   ] {sound (self, CHAN_VOICE, "skullwiz/gatespk.wav", 1, ATTN_NORM);};
void() skullwiz_gate2   =[ $skgate3,  skullwiz_gate3   ] {};
void() skullwiz_gate3   =[ $skgate5,  skullwiz_gate4   ] {};
void() skullwiz_gate4   =[ $skgate7,  skullwiz_gate5   ] {};
void() skullwiz_gate5   =[ $skgate9,  skullwiz_gate6   ] {};
void() skullwiz_gate6   =[ $skgate11, skullwiz_gate7   ] {};
void() skullwiz_gate7   =[ $skgate13, skullwiz_gate8   ] {};
void() skullwiz_gate8   =[ $skgate15, skullwiz_gate9   ] {};
void() skullwiz_gate9   =[ $skgate17, skullwiz_gate10  ] {};
void() skullwiz_gate10  =[ $skgate19, skullwiz_gate11  ] {};
void() skullwiz_gate11  =[ $skgate21, skullwiz_gate12  ] {skullwiz_help();};
void() skullwiz_gate12  =[ $skgate23, skullwiz_gate13  ] {};
void() skullwiz_gate13  =[ $skgate25, skullwiz_gate14  ] {};
void() skullwiz_gate14  =[ $skgate27, skullwiz_gate15  ] {};
void() skullwiz_gate15  =[ $skgate29, skullwiz_run1    ] {};

void() skullwiz_gatef1   =[ $skgate1,  skullwiz_gatef2   ] {sound (self, CHAN_VOICE, "skullwiz/gatespk.wav", 1, ATTN_NORM);};
void() skullwiz_gatef2   =[ $skgate5,  skullwiz_gatef3   ] {};
void() skullwiz_gatef3   =[ $skgate9,  skullwiz_gatef4   ] {};
void() skullwiz_gatef4   =[ $skgate13, skullwiz_gatef5   ] {};
void() skullwiz_gatef5   =[ $skgate17, skullwiz_gatef6   ] {};
void() skullwiz_gatef6   =[ $skgate21, skullwiz_gatef7   ] {skullwiz_help();};
void() skullwiz_gatef7   =[ $skgate25, skullwiz_gate15   ] {};

void() skullwiz_fire =
{
    if (FacingIdeal ())
    {   // Use '15 -5 25' for skullwz3.mdl.
        if (self.mdl == "progs/skullwz2.mdl")
            M_FireSkull ('15 -4 21');
        else
            M_FireSkull ('15 -4 17');
    }
    else
        self.frame = $skspel13;
};

void(void() f1, void() f2) skullwiz_rethink =
{
    if (self.enemy.health > 0)
    {
        if (random() < 0.5)
            self.think = f1;
        else if ( self.skin && (random() < (skill / 10 + 0.2)) )
            self.think = f2;
    }
};

void() skullwiz_missile1  =[ $skredi2,  skullwiz_missile2  ] {ai_face();};
void() skullwiz_missile2  =[ $skredi4,  skullwiz_missile3  ] {ai_face();};
void() skullwiz_missile3  =[ $skredi6,  skullwiz_missile4  ] {ai_face();};
void() skullwiz_missile4  =[ $skredi8,  skullwiz_missile5  ] {ai_face();};
void() skullwiz_missile5  =[ $skredi10, skullwiz_missile6  ] {ai_face();};
void() skullwiz_missile6  =[ $skspel2,  skullwiz_missile7  ] {ai_face();};
void() skullwiz_missile7  =[ $skspel4,  skullwiz_missile8  ] {ai_face();};
void() skullwiz_missile8  =[ $skspel6,  skullwiz_missile9  ] {ai_face();};
void() skullwiz_missile9  =[ $skspel8,  skullwiz_missile10 ] {ai_face();};
void() skullwiz_missile10 =[ $skspel10, skullwiz_missile11 ] {ai_face();};
void() skullwiz_missile11 =[ $skspel12, skullwiz_missile12 ] {ai_face(); skullwiz_fire();};
void() skullwiz_missile12 =[ $skspel14, skullwiz_missile13 ] {ai_face(); skullwiz_rethink(skullwiz_missile6, skullwiz_blink1);};
void() skullwiz_missile13 =[ $sktran1,  skullwiz_missile14 ] {ai_face();};
void() skullwiz_missile14 =[ $sktran3,  skullwiz_missile15 ] {ai_face();};
void() skullwiz_missile15 =[ $sktran5,  skullwiz_missile16 ] {ai_face();};
void() skullwiz_missile16 =[ $sktran7,  skullwiz_run1      ] {ai_face();};

//- - - - - - - - -
void() skullwiz_missilef7;

void() skullwiz_curse =[ $skspel13, skullwiz_missilef7 ] {self.nextthink = time + 0.2;
    ai_face();
// Try to charm tough monsters.  If that fails, slow 'em down.
    if (random() <= (self.enemy.health / 200))
        if (T_Confuse (self.enemy, self))
            return;     // Sic the victim at a random hostile target.
    T_Curse (self.enemy, self, CURSE_SLOW, 10);
};

void() skullwiz_laser =
{
    local   vector  org, dir;
    local   float   frac;

    if (self.mdl == "progs/skullwz2.mdl")
        org = '15 -4 21';
    else
        org = '15 -4 17';
    makevectors (self.angles);
    org = self.origin + (v_forward*org_x) + (v_right*org_y) + (v_up*org_z);

    frac = Frac_ShotDown ();    // Lowers 'shots_left'.
    if (self.shots_left < 1)
        self.think = skullwiz_missilef7;
    self.effects = self.effects | EF_MUZZLEFLASH;
    dir = Midpoint (self.enemy);
    dir = Maim_LineEx (org, dir, 1000, self.enemy, '2 1.5 0', frac);
    sound (self, CHAN_WEAPON, "hknight/attack1.wav", 1, ATTN_NORM);
    Needle_Launch (org, dir, 0);
};
void() skullwiz_spray1  =[ $skspel12, skullwiz_spray2    ] {ai_face(); skullwiz_laser();};
void() skullwiz_spray2  =[ $skspel13, skullwiz_spray1    ] {ai_face(); skullwiz_laser();};
//- - - - - - - - -
void() skullwiz_missilef1  =[ $skredi2,  skullwiz_missilef2 ] {ai_face();};
void() skullwiz_missilef2  =[ $skredi6,  skullwiz_missilef3 ] {ai_face();};
void() skullwiz_missilef3  =[ $skredi10, skullwiz_missilef4 ] {ai_face();};
void() skullwiz_missilef4  =[ $skspel4,  skullwiz_missilef5 ] {ai_face();};
void() skullwiz_missilef5  =[ $skspel8,  skullwiz_missilef6 ] {ai_face();
    if (self.xfl & XFL_BOSS)
    {
        if (!self.enemy.curse_type && (random() < 0.5))
            self.think = skullwiz_curse;
        else if (random() < 0.5)
        {   self.shots_max = self.shots_left = 5;
            self.think = skullwiz_spray1;
        }
    }
};
void() skullwiz_missilef6  =[ $skspel12, skullwiz_missilef7 ] {ai_face(); skullwiz_fire();};
void() skullwiz_missilef7  =[ $skspel14, skullwiz_missilef8 ] {ai_face(); skullwiz_rethink(skullwiz_missilef4, skullwiz_bfast1);};
void() skullwiz_missilef8 =[ $sktran3,  skullwiz_missilef9 ] {ai_face();};
void() skullwiz_missilef9 =[ $sktran7,  skullwiz_run1      ] {ai_face();};

void() skullwiz_missile =
{
    if (self.skin)
    {
        if (self.xfl & XFL_BOSS)
        {   local   float   mx;

            if (!self.pets)
                mx = 0.5;
            else
                mx = 0.25;
            if (random() < mx)
                skullwiz_gatef1 ();
            else
                skullwiz_missilef1 ();
            return;
        }
        else if (random() < 0.15)
            {skullwiz_gate1 ();  return;}
    }
    skullwiz_missile1 ();
};

// Skullwiz version of repulsion.  Done differently than standard.
void() skullwiz_repel =
{
    if (!self.enemy)
        return;     // No one to attack.
    if (!InMeleeRange (120))
        return;
    if (!CanDamage (self.enemy, self))
        return;

    // Note:  Different than Armagon's because we ignore elevation.
    local   float   damage;

    damage = 10 + random() * 5;     //20
    T_Damage (self.enemy, self, self, damage);
    sound (self, CHAN_WEAPON, "skullwiz/push.wav", 1, ATTN_NORM);
    self.enemy.flags = self.enemy.flags - (self.enemy.flags & FL_ONGROUND);
    self.enemy.velocity = (self.enemy.origin - self.origin) * 10;
    if (!self.skin)
        self.enemy.velocity_z = 100;
    else
        self.enemy.velocity_z = 200;
};

void() skullwiz_melee1  =[ $skspel2,  skullwiz_melee2  ] {ai_charge(3);};
void() skullwiz_melee2  =[ $skspel4,  skullwiz_melee3  ] {ai_charge(3);};
void() skullwiz_melee3  =[ $skspel6,  skullwiz_melee4  ] {ai_charge(3);};
void() skullwiz_melee4  =[ $skspel8,  skullwiz_melee5  ] {ai_charge(3);};
void() skullwiz_melee5  =[ $skspel10, skullwiz_melee6  ] {ai_charge(3);
    if (self.skin)
        if (random() < 0.15)
            {skullwiz_gate1 ();  return;}
    skullwiz_repel ();
    if (random() < 0.5)
        self.think = skullwiz_missile6;
};
void() skullwiz_melee6  =[ $skspel12, skullwiz_melee7  ] {ai_charge(3);};
void() skullwiz_melee7  =[ $skspel14, skullwiz_run1    ] {ai_charge(3);};

void() skullwiz_meleef1 =[ $skspel4,  skullwiz_meleef2 ] {ai_charge(6);};
void() skullwiz_meleef2 =[ $skspel8,  skullwiz_meleef3 ] {ai_charge(6);};
void() skullwiz_meleef3 =[ $skspel12, skullwiz_meleef4 ] {ai_charge(6);
    if (random() < 0.15)
        {skullwiz_gatef1 ();  return;}
    skullwiz_repel ();
    if (random() < 0.5)
        self.think = skullwiz_missilef4;
};
void() skullwiz_meleef4 =[ $skspel12, skullwiz_run1    ] {ai_charge(6);};

void() skullwiz_melee =
{
    if (self.skin)
        if (self.xfl & XFL_BOSS)
            {skullwiz_meleef1 ();  return;}
    skullwiz_melee1 ();
};

// PAIN - - - - - - - - - - - - - - - -
void() skullwiz_painblink =
{
//    self.pain_finished = time + 3;
    if (self.fighting)
        if (random() < 0.2)
            self.think = skullwiz_blink1;
};

void() skullwiz_pain1  =[ $skpain1,  skullwiz_pain2  ] {};
void() skullwiz_pain2  =[ $skpain3,  skullwiz_pain3  ] {};
void() skullwiz_pain3  =[ $skpain5,  skullwiz_pain4  ] {};
void() skullwiz_pain4  =[ $skpain7,  skullwiz_pain5  ] {};
void() skullwiz_pain5  =[ $skpain9,  skullwiz_pain6  ] {};
void() skullwiz_pain6  =[ $skpain11, skullwiz_run1   ] {skullwiz_painblink();};

void(entity attacker, float damage) skullwiz_pain =
{
    if (self.pain_finished > time)
        return;

    self.pain_finished = time + 3;
    if (skullwiz_grunt ())
        sound (self, CHAN_VOICE, "skullwiz/pain.wav", 1, ATTN_NORM);
    else
        sound (self, CHAN_VOICE, "skullwiz/pain2.wav", 1, ATTN_IDLE);

    if (SUB_IgnorePain ())
        return;         // No pain anims in Nightmare.

    skullwiz_pain1();

    attacker = attacker;  damage = damage;      // Appease FrikQcc.
};

// DEATH - - - - - - - - - - - - - - - -
void(vector org, vector vel) SkullWiz_SpawnSmoke =
{
    local   entity  gib;

    gib = spawn ();
    gib.owner       = self;
    gib.movetype    = MOVETYPE_FLY;
    gib.solid       = SOLID_NOT;
    gib.velocity    = vel * 10;
    gib.nextthink   = time + 0.5;
    gib.think       = SUB_Remove;
    setmodel (gib, "progs/smoke.mdl");
    setsize (gib, '0 0 0', '0 0 0');
    setorigin (gib, org);
};

void() SkullWiz_Smoke =
{
    local   vector  org;

    makevectors (self.angles);
    org = self.origin + (v_forward*4) + (v_up*20);
    SkullWiz_SpawnSmoke (org, '0 0 12');
    SkullWiz_SpawnSmoke (org, '0 8 8');
    SkullWiz_SpawnSmoke (org, '0 -8 8');
};

void() skullwiz_die1  =[ $skdeth1,  skullwiz_die2  ] {};
void() skullwiz_die2  =[ $skdeth3,  skullwiz_die3  ] {};
void() skullwiz_die3  =[ $skdeth5,  skullwiz_die4  ] {};
void() skullwiz_die4  =[ $skdeth7,  skullwiz_die5  ] {  //monster_drop();
    if (self.spawnfunction != item_artifact_tomeofpower)
    {
        if (self.skin == 2)     // Burn skullwiz boss's Tome of Power!
            ThrowIt ("progs/skulbook.mdl", self.health, GIB_SKIN_MATCH|GIB_BURN);
        else
            ThrowIt ("progs/skulbook.mdl", self.health, GIB_SKIN_MATCH);
    }
    ThrowJunk ("progs/skulhead.mdl", self.health);
    monster_drop();
    ai_back(1);
};
void() skullwiz_die5  =[ $skdeth9,  skullwiz_die6  ] {ai_back(8);};
void() skullwiz_die6  =[ $skdeth11, skullwiz_die7  ] {ai_back(7);};
void() skullwiz_die7  =[ $skdeth13, skullwiz_die8  ] {};
void() skullwiz_die8  =[ $skdeth15, monster_end    ] {
    if (self.deathtype == "impulse")
        return;     // Probably killed by genocide cheat.
    SkullWiz_Summon (0);
    if (random() < 0.5)
        SkullWiz_Summon (1);
    if (!skullwiz_grunt ())
    {
        SkullWiz_Summon (0);
        // Hexen2 made him smoke, but I won't port that here.
    }
};

void() skullwiz_die =
{
    if (self.touch == SUB_Null)
    {   // Phased out -- restore model now.
        self.solid      = SOLID_SLIDEBOX;
        self.takedamage = DAMAGE_AIM;
        self.th_pain    = skullwiz_pain;
        setform (self, self.mdl, VEC_HULL_MIN, VEC_HULL1_MAX);
    }

    if (Shattered ())
        return;
    if (Decapitated ())
    {
        SkullWiz_Smoke ();
        skullwiz_die4 ();
        return;
    }

    if (skullwiz_grunt ())
        sound (self, CHAN_VOICE, "skullwiz/death.wav", 1, ATTN_NORM);
    else
        sound (self, CHAN_VOICE, "skullwiz/death2.wav", 1, ATTN_NORM);
    SkullWiz_Smoke ();
    skullwiz_die1 ();
};

// REVIVE - - - - - - - - - - - - - - -
void() skullwiz_revive1  =[ $skdeth14, skullwiz_revive2  ] {};
void() skullwiz_revive2  =[ $skdeth13, skullwiz_revive3  ] {};
void() skullwiz_revive3  =[ $skdeth12, skullwiz_revive4  ] {};
void() skullwiz_revive4  =[ $skdeth11, skullwiz_revive5  ] {};
void() skullwiz_revive5  =[ $skdeth10, skullwiz_revive6  ] {};
void() skullwiz_revive6  =[ $skdeth9,  skullwiz_revive7  ] {};
void() skullwiz_revive7  =[ $skdeth8,  skullwiz_revive8  ] {};
void() skullwiz_revive8  =[ $skdeth7,  skullwiz_revive9  ] {};
// From here, the head reforms.
void() skullwiz_revive9  =[ $skdeth6,  skullwiz_revive10 ] {};
void() skullwiz_revive10 =[ $skdeth5,  skullwiz_revive11 ] {};
void() skullwiz_revive11 =[ $skdeth4,  skullwiz_revive12 ] {};
void() skullwiz_revive12 =[ $skdeth3,  skullwiz_revive13 ] {};
void() skullwiz_revive13 =[ $skdeth2,  skullwiz_revive14 ] {};
void() skullwiz_revive14 =[ $skdeth1,  skullwiz_run1     ] {};

// OTHER - - - - - - - - - - - - - - - -
void(float hello) skullwiz_sight =
{
    if (!skullwiz_grunt ())
    {
        if (hello)
            sound (self, CHAN_VOICE, "skullwiz/gatespk2.wav", 1, ATTN_NORM);
        else
            sound (self, CHAN_VOICE, "skullwiz/growl2.wav", 1, ATTN_NORM);
    }
    else
    {
        if (hello)
            sound (self, CHAN_VOICE, "skullwiz/gatespk.wav", 1, ATTN_NORM);
        else
            sound (self, CHAN_VOICE, "skullwiz/growl.wav", 1, ATTN_NORM);
    }
};

void() skullwiz_cache =
{
    precache_model ("progs/skulbook.mdl");
    precache_model ("progs/skulhead.mdl");
    precache_model ("progs/skulshot.mdl");
    precache_model ("progs/smoke.mdl");

    precache_sound ("skullwiz/blinkin.wav");
    precache_sound ("skullwiz/blinkout.wav");
    precache_sound ("skullwiz/firemisl.wav");
    precache_sound ("skullwiz/gate.wav");
    precache_sound ("skullwiz/gatespk.wav");
    precache_sound ("skullwiz/push.wav");
};

void() skullwiz_grunt_cache =
{
    precache_model ("progs/skullwiz.mdl");
    skullwiz_cache ();
    precache_sound ("skullwiz/blinkspk.wav");
    precache_sound ("skullwiz/death.wav");
    precache_sound ("skullwiz/growl.wav");
    precache_sound ("skullwiz/pain.wav");
    precache_sound ("skullwiz/scream.wav");
};

void() skullwiz_lord_cache =
{
    precache_model ("progs/skullwiz.mdl");
    skullwiz_cache ();
    precache_sound ("skullwiz/blnkspk2.wav");
    precache_sound ("skullwiz/death2.wav");
    precache_sound ("skullwiz/growl2.wav");
    precache_sound ("skullwiz/pain2.wav");
    precache_sound ("skullwiz/scream2.wav");
};

void() skullwiz_boss_cache =
{
    precache_model ("progs/skullwz2.mdl");
    precache_model ("progs/needle.mdl");
    skullwiz_cache ();
    precache_sound ("curse/x_muddle.wav");
    precache_sound ("curse/x_slow.wav");
    precache_sound ("skullwiz/blnkspk2.wav");
    precache_sound ("skullwiz/death2.wav");
    precache_sound ("skullwiz/growl2.wav");
    precache_sound ("skullwiz/pain2.wav");
    precache_sound ("skullwiz/scream2.wav");
};

//============
// --> QUAKED monster_skull_wizard (1 0 0) (-16 16 -24) (16 16 40) Ambush Boss
//============
void() monster_skull_wizard =
{
    local   float   hp;

// Note:  maxs is '24 24 40' in Hexen2.  However, Quake will use the
// ogre/shambler-sized hull ('32 32 64') to move the odd-sized hull around.
// Thus, use a player-sized hull instead.
    if (!self.spawned)
    {
        if (noenemies)
            {remove (self); return;}

        if (self.classname == "monster_skull_wizard_boss")
            skullwiz_boss_cache ();
        else if (self.classname == "monster_skull_wizard_lord")
            skullwiz_lord_cache ();
        else
            skullwiz_grunt_cache ();

        spider_cache ();        // Summons spiders.
    }

// Note:  Lords are 120% larger than grunts in Hexen2.
// However, 120% is too big for player-sized hull.  110% is about as big as
// some of the other player-sized monsters such as the baron and the necro.
// Could use one-size-fits-all for all types to save memory requirements
// due to filesize of Hexen2 models, but I'll use a bigger model for the
// boss, and the normal size for the weaker wizards.
    if (self.classname == "monster_skull_wizard_boss")
    {
        hp = 1000;
        self.mdl    = "progs/skullwz2.mdl";
        self.skin   = 2;
        self.xfl    = XFL_BOSS;
        if (!self.spawned)
        if (!self.spawnfunction)    // Give book if undefined item drop.
        {   // Drop a Tome of Power when killed.
            self.spawnclassname = "item_artifact_tomeofpower";
            self.spawnfunction  = item_artifact_tomeofpower;
        }
    }
    else
    {
        if (self.classname == "monster_skull_wizard_lord")
            {hp = 650;  self.skin = 1;}
        else
            {hp = 150;  self.skin = 0;}
        self.mdl    = "progs/skullwiz.mdl";
        self.th_revive  = skullwiz_revive1;
    }
    monster_form (self.mdl, '-16 -16 -24', '16 16 40', hp, 0);
    self.mass   = MASS_MEDIUM;

    self.th_stand   = skullwiz_stand1;
    self.th_walk    = skullwiz_walk1;
    self.th_run     = skullwiz_run;
    self.th_missile = skullwiz_missile;
    self.th_melee   = skullwiz_melee;
    self.th_pain    = skullwiz_pain;
    self.th_die     = skullwiz_die;
    //- - - - - - - -
    self.th_sight   = skullwiz_sight;
    self.th_check   = SkullWizCheckAttack;
//    self.th_revive  = skullwiz_revive1;
    self.th_spawn   = monster_skull_wizard;

    if (soul_evil)
        monster_purse (3, 0.75, 0.5);
    self.family     = FAM_NECRO;
    self.xfl        = self.xfl | XFL_INEDIBLE;      // Meatless after death.

    monster_start ();
};

void() monster_skull_wizard_boss = {self.skin = 2;  monster_skull_wizard();};

void() monster_skull_wizard_lord = {self.skin = 1;  monster_skull_wizard();};


//===========================/  END OF FILE  /===========================//
