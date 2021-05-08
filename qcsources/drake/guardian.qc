/*
==============================================================================

GUARDIAN (Osiris)

==============================================================================
*/

// morph.qc

$skin aztec
$skin pharoah
$skin roman
$skin florskin

$frame mfstand1 
//$frame mfup01 mfup02 mfup03 mfup04 mfup05 mfup06
//$frame mfup07 mfup08 mfup09 mfup10 mfup11 mfup12

$frame start01 start02 start03 start04 start05 start06
$frame start07 start08 start09 start10 start11 start12
$frame start13 start14 start15 start16 start17 start18
$frame start19 start20 start21 start22 start23 start24
$frame start25 start26 start27 start28 start29 start30 start31

$frame mfrun01 mfrun02 mfrun03 mfrun04 mfrun05 mfrun06
$frame mfrun07 mfrun08 mfrun09 mfrun10 mfrun11

$frame mfwlk01 mfwlk02 mfwlk03 mfwlk04 mfwlk05 mfwlk06 mfwlk07 mfwlk08
$frame mfwlk09 mfwlk10 mfwlk11 mfwlk12 mfwlk13

$frame mfata01 mfata02 mfata03 mfata04 mfata05
$frame mfata06 mfata07 mfata08 mfata09

$frame mfatb01 mfatb02 mfatb03 mfatb04 mfatb05 mfatb06
$frame mfatb07 mfatb08 mfatb09 mfatb10 mfatb11

$frame mfatc01 mfatc02 mfatc03 mfatc04 mfatc05 mfatc06
$frame mfatc07 mfatc08 mfatc09 mfatc10 mfatc11 mfatc12
$frame mfatc13 mfatc14 mfatc15 mfatc16

$frame mfknck01 mfknck02 mfknck03 mfknck04 mfknck05 mfknck06
$frame mfknck07 mfknck08 mfknck09 mfknck10 mfknck11 mfknck12

$frame mfpain01 mfpain02 mfpain03 mfpain04 mfpain05
$frame mfpain06 mfpain07 mfpain08 mfpain09 mfpain10

$frame mfpbin01 mfpbin02 mfpbin03 mfpbin04 mfpbin05
$frame mfpbin06 mfpbin07

$frame mfdth01 mfdth02 mfdth03 mfdth04 mfdth05
$frame mfdth06 mfdth07 mfdth08 mfdth09 mfdth10
$frame mfdth11 mfdth12 mfdth13 mfdth14 mfdth15
$frame mfdth16 mfdth17 mfdth18 mfdth19 mfdth20
$frame mfdth21 

float MORPH_AZTEC    = 2;
float MORPH_EGYPT    = 4;
float MORPH_GREEK    = 8;

void() morph_summon;

// ========================
// standing
// ========================
void() morph_stand1 = [ $mfstand1, morph_stand1 ] { ai_stand(); };

// ========================
// movement
// ========================
// 3 2 1 1 0 1 2 3 4 5 4 2 1 0
// 3 2 1 2 3 4 4 3 2 1 2 3 3 
// 2 4 4 4 3 3 2 2 4 4 3 2 1
// 4 5 5 4 3 2 2 4 5 4 3 2 2
void() morph_walk1  =[ $mfwlk01, morph_walk2  ] {ai_walk(3);};
void() morph_walk2  =[ $mfwlk02, morph_walk3  ] {ai_walk(2);};
void() morph_walk3  =[ $mfwlk03, morph_walk4  ] {ai_walk(4);};
void() morph_walk4  =[ $mfwlk04, morph_walk5  ] {ai_walk(5);};
void() morph_walk5  =[ $mfwlk05, morph_walk6  ] {ai_walk(5);};
void() morph_walk6  =[ $mfwlk06, morph_walk7  ] {ai_walk(4);}; //1
void() morph_walk7  =[ $mfwlk07, morph_walk8  ] {ai_walk(2);}; //1 
void() morph_walk8  =[ $mfwlk08, morph_walk9  ] {ai_walk(3);};
void() morph_walk9  =[ $mfwlk09, morph_walk10 ] {ai_walk(4);};
void() morph_walk10 =[ $mfwlk10, morph_walk11 ] {ai_walk(5);};
void() morph_walk11 =[ $mfwlk11, morph_walk12 ] {ai_walk(5);};
void() morph_walk12 =[ $mfwlk12, morph_walk13 ] {ai_walk(4);};
void() morph_walk13 =[ $mfwlk13, morph_walk1  ] {ai_walk(3);}; //1

// 8 6 4 10 13 13 11 10
// 11 15 10 10 8 15 10 8 8 8 8
// 6 9 13 13 9 6 9 13 15 13 9
void() morph_run1  =[ $mfrun01, morph_run2  ] {
    // In Drake, powerups may remove it's light, so refresh if necessary.
    if (self.xf2 & XF2_CLONE == 0)
        self.effects = self.effects | EF_DIMLIGHT;
    ai_run( 7);};    // 33
void() morph_run2  =[ $mfrun02, morph_run3  ] {ai_run(11);};
void() morph_run3  =[ $mfrun03, morph_run4  ] {ai_run(16);};
void() morph_run4  =[ $mfrun04, morph_run5  ] {ai_run(16);};    // 36
void() morph_run5  =[ $mfrun05, morph_run6  ] {ai_run(11);};
void() morph_run6  =[ $mfrun06, morph_run7  ] {ai_run( 7);};    // 38
void() morph_run7  =[ $mfrun07, morph_run8  ] {ai_run(11);};
void() morph_run8  =[ $mfrun08, morph_run9  ] {ai_run(15);};    // 40
void() morph_run9  =[ $mfrun09, morph_run10 ] {ai_run(19);};
void() morph_run10 =[ $mfrun10, morph_run11 ] {ai_run(15);};
void() morph_run11 =[ $mfrun11, morph_run1  ] {ai_run(11);};    // 43

// ========================
// new attack code
// ========================
void() morph_stabbed1 =[ $mfatb09, morph_stabbed2 ] {ai_face();};
void() morph_stabbed2 =[ $mfatb10, morph_stabbed3 ] {ai_face();};
void() morph_stabbed3 =[ $mfatb11, morph_stabbed4 ] {ai_face();};
void() morph_stabbed4 =[ $mfatb01, morph_run1     ] {ai_face();};

void(vector st) morph_laser =
{
    local   vector  delta, dir, org;
    local   float   err;

    makevectors (self.angles);

    org = self.origin + (v_forward*st_x) + (v_right*st_y) + (v_up*st_z);
    delta = self.enemy.origin - self.origin;
//    dir = normalize (delta);
    dir = Maim_Line (self.origin, self.enemy.origin, 1000, world, '0 0 0');
    if (vlen(delta) > 400)
        err = 0.04;
    else
        err = 0.1;
    delta = v_right * err;

    sound (self, CHAN_WEAPON, "me/me_fire1.wav", 1, ATTN_NORM);

    self.effects = self.effects | EF_MUZZLEFLASH;
    LaunchLaser (org, dir);
    LaunchLaser (org, dir + delta);
    LaunchLaser (org, dir - delta);
};

void() morph_stab2 =
{
    if (!self.enemy)
        return;
    if (!CanDamage (self.enemy, self))
        return;

    ai_face();

    if (InMeleeRange (90))
    {
        local   float   damage;

        makevectors (self.angles);

        self.think = morph_stabbed1;    // Do before T_Damage.
        damage = (random() * 10) + 20;
        sound (self, CHAN_WEAPON, "shambler/smack.wav", 1, ATTN_NORM);
        // PM:  Added scar damage so it isn't helpless against a zombie.
        T_NewDamage (self.enemy, self, self, damage, DF_SCAR, "");
        SpawnBlood ( self.enemy.origin, v_forward * 150, 14, self.enemy.bloodtype);
    }
    else
        morph_laser ('80 4 4');
};

// ========================
// hand to hand attack
// ========================
void() morph_bigattack01 =[ $mfatc01, morph_bigattack06 ] {ai_face();};
//void() morph_bigattack02 =[ $mfatc02, morph_bigattack03 ] {ai_face();};
//void() morph_bigattack03 =[ $mfatc03, morph_bigattack04 ] {ai_face();};
//void() morph_bigattack04 =[ $mfatc04, morph_bigattack05 ] {ai_face();};
//void() morph_bigattack05 =[ $mfatc05, morph_bigattack06 ] {ai_face();};
void() morph_bigattack06 =[ $mfatc06, morph_bigattack07 ] {ai_face();};
void() morph_bigattack07 =[ $mfatc07, morph_bigattack08 ] {ai_face();};
void() morph_bigattack08 =[ $mfatc08, morph_bigattack09 ] {ai_face();};
void() morph_bigattack09 =[ $mfatc09, morph_bigattack10 ] {ai_face();};
void() morph_bigattack10 =[ $mfatc10, morph_bigattack11 ] {morph_stab2();};
void() morph_bigattack11 =[ $mfatc11, morph_bigattack12 ] {ai_face();};
void() morph_bigattack12 =[ $mfatc12, morph_bigattack13 ] {ai_face();};
void() morph_bigattack13 =[ $mfatc13, morph_bigattack14 ] {ai_face();};
void() morph_bigattack14 =[ $mfatc14, morph_bigattack15 ] {ai_face();};
void() morph_bigattack15 =[ $mfatc15, morph_bigattack16 ] {ai_face();};
void() morph_bigattack16 =[ $mfatc16, morph_bigattack17 ] {ai_face();};
void() morph_bigattack17 =[ $mfatc01, morph_run1        ] {ai_face();};

void() morph_smack = 
{
    local float     ldmg;

    if (!self.enemy)
        return;
    if (!CanDamage (self.enemy, self))
        return;

    ai_face();

    if (!InMeleeRange (100))
        return;
    if (IsGhost (self.enemy))   // NEW!
        return;     // Not allowed to hit wraith.

    sound (self, CHAN_WEAPON, "weapons/axhit.wav", 1, ATTN_NORM);

    makevectors (self.angles);
    // velocity was vx*100 + vz*100.  Wasn't forceful enough.
    self.enemy.velocity = v_forward*100 + '0 0 100'*random() + '0 0 400';
    self.enemy.flags = self.enemy.flags - (self.enemy.flags & FL_ONGROUND);

    ldmg = (random() * 10) + 10;
    T_Damage (self.enemy, self, self, ldmg);

// Not here.
};

void() morph_knockback01 =[ $mfknck01, morph_knockback02 ] {ai_face();};
void() morph_knockback02 =[ $mfknck02, morph_knockback03 ] {ai_face();};
void() morph_knockback03 =[ $mfknck03, morph_knockback04 ] {ai_face();};
void() morph_knockback04 =[ $mfknck04, morph_knockback05 ] {ai_face();};
void() morph_knockback05 =[ $mfknck05, morph_knockback06 ] {ai_face();};
//void() morph_knockback06 =[ $mfknck06, morph_knockback07 ] {ai_face();};
//void() morph_knockback07 =[ $mfknck07, morph_knockback08 ] {ai_face();};
//void() morph_knockback08 =[ $mfknck08, morph_knockback09 ] {ai_face();};
//void() morph_knockback09 =[ $mfknck09, morph_knockback10 ] {morph_smack();};
void() morph_knockback06 =[ $mfknck06, morph_knockback08 ] {morph_smack();};
void() morph_knockback08 =[ $mfknck08, morph_knockback09 ] {ai_face();};
void() morph_knockback09 =[ $mfknck09, morph_knockback10 ] {ai_face();};
void() morph_knockback10 =[ $mfknck10, morph_knockback11 ] {ai_face();};
void() morph_knockback11 =[ $mfknck11, morph_knockback12 ] {ai_face();};
void() morph_knockback12 =[ $mfknck12, morph_run1        ] {ai_face();};

void() morph_attack =
{
    if (random() >= 0.75)
    if (InMeleeRange (80))
    if (!IsGhost (self.enemy))
        {morph_knockback01();  return;}
    morph_bigattack01();
};

// ========================
// ranged attack
// ========================
void() morph_fire1 =[ $mfata01, morph_fire2 ] {ai_face();};
void() morph_fire2 =[ $mfata02, morph_fire3 ] {ai_face();};
void() morph_fire3 =[ $mfata03, morph_fire4 ] {ai_face();};
void() morph_fire4 =[ $mfata04, morph_fire5 ] {ai_face(); morph_laser ('30 8.5 16');};
void() morph_fire5 =[ $mfata05, morph_fire6 ] {ai_face();};
void() morph_fire6 =[ $mfata06, morph_fire7 ] {ai_face();};
void() morph_fire7 =[ $mfata07, morph_fire8 ] {ai_face();};
void() morph_fire8 =[ $mfata08, morph_fire9 ] {ai_face();};
void() morph_fire9 =[ $mfata09, morph_run1  ] {ai_face();};

// ========================
// pain
// ========================
void() morph_painA1  =[ $mfpain01, morph_painA2  ] {};
void() morph_painA2  =[ $mfpain02, morph_painA3  ] {};
void() morph_painA3  =[ $mfpain03, morph_painA4  ] {};
void() morph_painA4  =[ $mfpain04, morph_painA5  ] {};
void() morph_painA5  =[ $mfpain05, morph_painA6  ] {};
void() morph_painA6  =[ $mfpain06, morph_painA7  ] {};
void() morph_painA7  =[ $mfpain07, morph_painA8  ] {};
void() morph_painA8  =[ $mfpain08, morph_painA9  ] {};
void() morph_painA9  =[ $mfpain09, morph_painA10 ] {};
void() morph_painA10 =[ $mfpain10, morph_run1    ] {morph_summon();};

void() morph_painB1  =[ $mfpbin01, morph_painB2 ] {};
void() morph_painB2  =[ $mfpbin02, morph_painB3 ] {};
void() morph_painB3  =[ $mfpbin03, morph_painB4 ] {};
void() morph_painB4  =[ $mfpbin04, morph_painB5 ] {};
void() morph_painB5  =[ $mfpbin05, morph_painB6 ] {};
void() morph_painB6  =[ $mfpbin06, morph_painB7 ] {};
void() morph_painB7  =[ $mfpbin07, morph_run1   ] {morph_summon();};

void() morph_pain =
{
    local   float   painChoice;

    if (SUB_IgnorePain ())
    {
        if (random() > 0.5)
            morph_summon();
//- - - - - - - - -
        if (self.pain_finished > time)
            return;
        self.pain_finished = time + 2;
        sound (self, CHAN_VOICE, "guard/pain1.wav", 1, ATTN_NORM);
//- - - - - - - - -
        return;
    }
    
    if (self.pain_finished > time)
        return;
    if (random() > 0.25)
        return;
    
    painChoice = random();
    self.pain_finished = time + 2;

    sound (self, CHAN_VOICE, "guard/pain1.wav", 1, ATTN_NORM);
    if ( painChoice > 0.6)
        morph_painB1 ();
    else
        morph_painA1 ();
};

// ========================
// die
// ========================
void() morph_die1  =[ $mfdth01, morph_die2  ] {};        // 122
void() morph_die2  =[ $mfdth02, morph_die3  ] {};
void() morph_die3  =[ $mfdth03, morph_die4  ] {};
void() morph_die4  =[ $mfdth04, morph_die5  ] {};
void() morph_die5  =[ $mfdth05, morph_die6  ] {};        // 126
void() morph_die6  =[ $mfdth06, morph_die7  ] {};
void() morph_die7  =[ $mfdth07, morph_die8  ] {};
void() morph_die8  =[ $mfdth08, morph_die9  ] {};        // 129
void() morph_die9  =[ $mfdth09, morph_die10 ] {self.skin = 1; self.deadflag = DEAD_DEAD; Pets_Free (self);};
void() morph_die10 =[ $mfdth10, morph_die11 ] {};
void() morph_die11 =[ $mfdth11, morph_die12 ] {};
void() morph_die12 =[ $mfdth12, morph_die13 ] {};        // 132
void() morph_die13 =[ $mfdth13, morph_die14 ] {};
void() morph_die14 =[ $mfdth14, morph_die15 ] {};
void() morph_die15 =[ $mfdth15, morph_die16 ] {};
void() morph_die16 =[ $mfdth16, morph_die17 ] {};        // 136
void() morph_die17 =[ $mfdth17, morph_die18 ] {};
void() morph_die18 =[ $mfdth18, morph_die19 ] {};
void() morph_die19 =[ $mfdth19, morph_die20 ] {};
void() morph_die20 =[ $mfdth20, morph_die21 ] {};        // 140
void() morph_die21 =[ $mfdth21, monster_rod ] {};

void() morph_die =
{
    sound ( self, CHAN_VOICE, "guard/death.wav", 1, ATTN_NORM);
    self.solid = SOLID_NOT;
    morph_die1 ();
};


// ========================
// hide in floor
// ========================
void() morph_wake1  =[ $start01, morph_wake2  ] {sound (self, CHAN_VOICE, "guard/see1.wav", 1, ATTN_NORM);};
void() morph_wake2  =[ $start02, morph_wake3  ] {};
void() morph_wake3  =[ $start03, morph_wake4  ] {};
void() morph_wake4  =[ $start04, morph_wake5  ] {};
void() morph_wake5  =[ $start05, morph_wake6  ] {};
void() morph_wake6  =[ $start06, morph_wake7  ] {};
void() morph_wake7  =[ $start07, morph_wake8  ] {};
void() morph_wake8  =[ $start08, morph_wake9  ] {};
void() morph_wake9  =[ $start09, morph_wake10 ] {};
void() morph_wake10 =[ $start10, morph_wake11 ] {};
void() morph_wake11 =[ $start11, morph_wake12 ] {};
void() morph_wake12 =[ $start12, morph_wake13 ] {};
void() morph_wake13 =[ $start13, morph_wake14 ] {};
void() morph_wake14 =[ $start14, morph_wake15 ] {};
void() morph_wake15 =[ $start15, morph_wake16 ] {self.skin = 1;};
void() morph_wake16 =[ $start16, morph_wake17 ] {};
void() morph_wake17 =[ $start17, morph_wake18 ] {};
void() morph_wake18 =[ $start18, morph_wake20 ] {};
//void() morph_wake18 =[ $start18, morph_wake19 ] {};
//void() morph_wake19 =[ $start19, morph_wake20 ] {};
void() morph_wake20 =[ $start20, morph_wake21 ] {};
void() morph_wake21 =[ $start21, morph_wake22 ] {};
void() morph_wake22 =[ $start22, morph_wake23 ] {};
void() morph_wake23 =[ $start23, morph_wake24 ] {};
void() morph_wake24 =[ $start24, morph_wake25 ] {};
void() morph_wake25 =[ $start25, morph_wake26 ] {};
void() morph_wake26 =[ $start26, morph_wake27 ] {};
void() morph_wake27 =[ $start27, morph_wake28 ] {};
void() morph_wake28 =[ $start28, morph_wake29 ] {};
void() morph_wake29 =[ $start29, morph_wake30 ] {};
void() morph_wake30 =[ $start30, morph_wake31 ] {};
void() morph_wake31 =[ $start31, morph_stand1 ] 
{
    self.solid      = SOLID_SLIDEBOX;
    self.takedamage = DAMAGE_AIM;        
    self.skin       = 0;
    if (self.xf2 & XF2_CLONE)
        self.think      = morph_run1;
    if (self.enemy)
        self.think      = morph_run1;
};

void() morph_wake =
{
    if (isSpawnPointEmpty(self))
    {
        self.solid      = SOLID_SLIDEBOX;
        self.movetype   = MOVETYPE_STEP;
        self.takedamage = DAMAGE_NO;
        self.flags      = self.flags | FL_MONSTER;
        self.ideal_yaw  = self.angles * '0 1 0';
        self.frame      = $start01;
        self.skin       = 2;
        setmodel (self, self.model);
        setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
        if (self.xf2 & XF2_CLONE == 0)
            self.effects = self.effects | EF_DIMLIGHT;

        morph_wake1 ();
        return;
    }
    self.think = morph_wake;
    self.nextthink = time + 0.1;
};

void() morph_use =
{
//    self.enemy = activator;
    self.think = morph_wake;
    if ( self.delay )
        self.nextthink = time + self.delay;
    else
        self.nextthink = time + 0.1;
};


//- - - - - - - - -
void() monster_morph;
float(vector spot) morph_spawn =
{
    local   entity  parent;

    parent = self;

    self = spawn();
//    self.flags      = 0;

    // Was in spawn test func
    self.master     = parent;
    self.movetype   = MOVETYPE_STEP;
    self.solid      = SOLID_NOT;
    setsize (self, '-16 -16 -24', '16 16 40');

    if (!EntryPoint_Spawn (self, world, spot, EntryPoint_One))
    {   // Failed -- No spawn point available this time.
        remove (self);
        self = parent;
        return FALSE;
    }
// Found a viable spawn point, so finish spawning the monster.
    self.spawned    = TRUE;
    self.skin       = 0;
    if (parent.alignment == GOOD)
        self.spawnflags = SPAWN_WHITE;
    else
        self.spawnflags = 0;
    self.classname  = parent.classname;
// Face master, and fix the angles so monster stands upright.
    self.angles_x   = 0;
    self.angles_y   = vectoyaw(parent.origin - self.origin);
    self.angles_z   = 0;
    if (parent.enemy)   // Face enemy instead if applicable.
        if (visible (parent.enemy))
            self.angles_y   = vectoyaw(parent.enemy.origin - self.origin);
    self.fixangle   = TRUE;
// The monster shall appear now.
    monster_morph ();

// Pet counter, used to enforce limits... used by nightshade.
    self.xfl = self.xfl | XFL_PET;
    parent.pets = parent.pets + 1;

// Successfully spawned a new creature.
    newmis = self;
    self = parent;
    return TRUE;
};
//- - - - - - - - -
void() morph_summon =
{
    local   entity  theDest;
    local   string  text;
    
    if (self.xf2 & XF2_CLONE)
        return;
    if (self.height > (1+skill))  // Replaced 'childredSpawned' with 'height'.
        return;
        
    if (world.model == "maps/or1.bsp")
        text = "info_teleport_destination";
    else
        text = "info_overlord_destination";
    theDest = M_FindDest (text);
    if (theDest == world)
        return;

//    if (SpawnMonster (self, theDest.origin, ID_GUARDIAN, EntryPoint_One))
    if (morph_spawn (theDest.origin))
        self.height = self.height + 1;

//    theChild.think = morph_wake1;
//    theChild.nextthink = time + 0.3;
};

void() morph_go =
{
    self.skin       = 2;
    self.th_stand   = morph_stand1;
    self.th_walk    = morph_walk1;
    self.th_run     = morph_run1;
    morph_wake1 ();
};
void() morph_floor =
{
    self.skin       = 2;
    self.th_stand   = morph_stand1;
    self.th_walk    = morph_walk1;
    self.th_run     = morph_run1;
    self.use        = morph_use;

// Undo the things done in monsters.qc.
    self.modelindex = 0;
    self.movetype   = MOVETYPE_NONE;
    self.solid      = SOLID_NOT;
    self.takedamage = DAMAGE_NO;
};

void() morph_cache =
{
    precache_model ("progs/morph_eg.mdl");
    precache_model ("progs/laser.mdl");
    
    precache_sound ("enforcer/enfstop.wav");
    precache_sound ("guard/death.wav");
    precache_sound ("guard/pain1.wav");
    precache_sound ("guard/see1.wav");
    precache_sound ("me/me_fire1.wav");
    precache_sound ("shambler/smack.wav");
};

/*QUAKED monster_morph (1 0 0) (-16 -16 -24) (16 16 32) Ambush Aztec Egyptian Greek
The morphing monster.

Select the look of the monster (Aztec,Greek,Egyptian).
If the monster has a targetname (triggered by something) he will rise up out of the floor when triggered.
*/
void() monster_morph =
{
    local   float   hp;

// Tronyn uses only the Egyptian version.
    if (!self.spawned)
    {
        if (noenemies)
            {remove (self); return;}
        morph_cache ();
    }

    if (self.classname == self.master.classname)    // Clone.
    {
        hp = 200;
        self.th_stand   =
        self.th_walk    =
        self.th_run     = morph_go;
        self.xf2        = XF2_CLONE;
    }
    else
    {
        hp = 2000;

    // If targeted and not using delayed spawned, setup floor stuff.
        if (self.targetname)
        if (self.spawnflags & SPAWNx_DELAY == 0)
        {
            self.th_stand   =
            self.th_walk    =
            self.th_run     = morph_floor;
        }
        if (!self.th_run)
        {
            self.th_stand   = morph_stand1;
            self.th_walk    = morph_walk1;
            self.th_run     = morph_run1;
            self.effects    = self.effects | EF_DIMLIGHT;
        }
    }
// These guys are tall, so extend their height a bit.
    self.model = "progs/morph_eg.mdl";
    monster_form ("progs/morph_eg.mdl", '-16 -16 -24', '16 16 40', hp, 0);
    self.mass       = MASS_SUPER;

    self.th_missile = morph_fire1;
    self.th_melee   = morph_attack;
    self.th_pain    = morph_pain;
    self.th_die     = morph_die;
    //- - - - - - - -
    self.th_spawn   = monster_morph;

    self.family     = FAM_GOLEM;

    monster_start ();
};


//===========================/  END OF FILE  /===========================//
