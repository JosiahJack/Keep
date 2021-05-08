/*
==============================================================================

OGRE

==============================================================================
*/

$cd id1/models/ogre_c
$origin 0 0 24
$base base        
$skin base

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7
$frame walk8 walk9 walk10 walk11 walk12 walk13 walk14 walk15 walk16

$frame run1 run2 run3 run4 run5 run6 run7 run8

$frame swing1 swing2 swing3 swing4 swing5 swing6 swing7
$frame swing8 swing9 swing10 swing11 swing12 swing13 swing14

$frame smash1 smash2 smash3 smash4 smash5 smash6 smash7
$frame smash8 smash9 smash10 smash11 smash12 smash13 smash14

$frame shoot1 shoot2 shoot3 shoot4 shoot5 shoot6

$frame pain1 pain2 pain3 pain4 pain5

$frame painb1 painb2 painb3

$frame painc1 painc2 painc3 painc4 painc5 painc6

$frame paind1 paind2 paind3 paind4 paind5 paind6 paind7 paind8 paind9 paind10
$frame paind11 paind12 paind13 paind14 paind15 paind16

$frame paine1 paine2 paine3 paine4 paine5 paine6 paine7 paine8 paine9 paine10
$frame paine11 paine12 paine13 paine14 paine15

$frame death1 death2 death3 death4 death5 death6
$frame death7 death8 death9 death10 death11 death12
$frame death13 death14

$frame bdeath1 bdeath2 bdeath3 bdeath4 bdeath5 bdeath6
$frame bdeath7 bdeath8 bdeath9 bdeath10

$frame pull1 pull2 pull3 pull4 pull5 pull6 pull7 pull8 pull9 pull10 pull11

$frame decap1 decap2 decap3 decap4 decap5 decap6
$frame decap7 decap8 decap9 decap10 decap11 decap12
$frame decap13 decap14

$frame decapb1 decapb2 decapb3 decapb4 decapb5 decapb6
$frame decapb7 decapb8 decapb9 decapb10

//============================================================================

//===========
// OgreCheckAttack
//
// The player is in view, so decide to move or launch an attack
// Returns FALSE if movement should continue
//============
float() OgreCheckAttack =
{
    local   vector  spot1, spot2;    
    local   entity  targ;
//    local   float   chance;

    if (enemy_range == RANGE_MELEE)
    {
        if (CanDamage (self.enemy, self))
        {
            self.attack_state = AS_MELEE;
            return TRUE;
        }
    }

    if (time < self.attack_finished)
        return FALSE;
    if (!enemy_vis)
        return FALSE;
    if (enemy_range == RANGE_FAR)
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
// PM:  Disabled unused legacy code.
//    else if (enemy_range == RANGE_NEAR)
//        chance = 0.10;
//    else if (enemy_range == RANGE_MID)
//        chance = 0.05;
//    else
//        chance = 0;

//- - - - - - - - -
// PM:  Attack spawns from left hand now, so make sure way is clear.
    spot1 = Vangles(spot2 - spot1);
    makevectors (spot1);    //(self.angles);
    spot1 = self.origin + v_forward*30 - v_right*5 + v_up*20;
    traceline (spot1, spot2, TRUE, self);
    if (trace_fraction < 1)
        return FALSE;
//- - - - - - - - -
    self.attack_state = AS_MISSILE;
    SUB_AttackFinished (1 + 2*random());
    return TRUE;
};

//=============================================================================


//================
// OgreFireNail
//================
void() OgreFireNail =
{
    local   vector  org, dir, err, base;
    local   float   loop;

    self.effects = self.effects | EF_MUZZLEFLASH;

    sound (self, CHAN_WEAPON, "weapons/shotgn2.wav", 1, ATTN_NORM);

    err = '6 4.5 0';     // arctan(err) = '0.105 0.0787 0'.
    if (cranked)
        {loop = 6;  base = Aim_Lead (self.origin, self.enemy.origin, 1000, self.enemy);}
    else
        {loop = 4;  base = self.enemy.origin;}
    makevectors (self.angles);
    org = self.origin + v_forward*30 - v_right*5 + v_up*20;
    base = normalize (base - self.origin);  // Like enforcers.
    while (loop > 0)
    {
        loop = loop - 1;
        if (!loop)
            err = '0 0 0';  // Last shot in loop uses unaltered velocity.
        dir = Maim_Scatter (base, err);
        launch_spike (org, dir);
    }
};

//================
// OgreFireGrenade
//================
void() OgreFireGrenade =
{
    local   vector  org, dir, up;
    local   entity  targ;
    local   float   damage;

    self.effects = self.effects | EF_MUZZLEFLASH;

    sound (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);

    up = '0 0 200';
    makevectors (self.angles);
    if (cranked)
        {targ = self.enemy;  damage = 60;}
    else
        {targ = world;  damage = 40;}
// DISABLED -- Commented out for reference.
//    if (purist)
//    {   // Emulate old aim code.
//        org = self.origin;
//        dir = Aim_Lead (org, self.enemy.origin, 600, targ);
//        dir = normalize (dir - org);
//        dir_z = 0;
//    }
//    else
    {   // Improved aim code.
        org = self.origin + v_forward*30 - v_right*5 + v_up*20;
        dir = Maim_Grenade (org, self.enemy.origin, 600, up_z, targ, '0 0 0');
    }
    Grenade_Launch (org, dir, up);
    newmis.dmg = damage;
    newmis.think1 = Old_Explosion1;     // Added 11/10/09.
};


//=============================================================================

//================
// chainsaw
//
// FIXME
//================
void(float side) ogre_chainsaw =
{
    if (!self.enemy)
        return;
    if (!CanDamage (self.enemy, self))
        return;

    ai_charge (10);

    local   float   ldmg;

    if (!InMeleeRange (100))    // PM:  Dragons-related.
        return;
    if (IsGhost (self.enemy))   // NEW!
      if (!(self.enemy.xf2 & XF2_CLONE))  // Nsoe1 hack.
        return;     // Not allowed to hit wraith.
        
    ldmg = SUB_MeleeDamage (4);
    T_Damage (self.enemy, self, self, ldmg);
    if (side)
    {
        makevectors (self.angles);
        if (side == 1)      // smash anim if TRUE.
            SpawnMeatSpray (self.origin + v_forward*16, crandom() * 100 * v_right, self.enemy.bloodtype);
        else
            SpawnMeatSpray (self.origin + v_forward*16, side * v_right, self.enemy.bloodtype);
    }
};


// STAND - - - - - - - - - - - - - - - -
void() ogre_stand1  =[ $stand1,  ogre_stand2 ] {ai_stand();};
void() ogre_stand2  =[ $stand2,  ogre_stand3 ] {ai_stand();};
void() ogre_stand3  =[ $stand3,  ogre_stand4 ] {ai_stand();};
void() ogre_stand4  =[ $stand4,  ogre_stand5 ] {ai_stand();};
void() ogre_stand5  =[ $stand5,  ogre_stand6 ] {
if (random() < 0.2)
    sound (self, CHAN_VOICE, "ogre/ogidle.wav", 1, ATTN_IDLE);
ai_stand();
};
void() ogre_stand6  =[ $stand6,  ogre_stand7 ] {ai_stand();};
void() ogre_stand7  =[ $stand7,  ogre_stand8 ] {ai_stand();};
void() ogre_stand8  =[ $stand8,  ogre_stand9 ] {ai_stand();};
void() ogre_stand9  =[ $stand9,  ogre_stand1 ] {ai_stand();};

// WALK - - - - - - - - - - - - - - - -
void() ogre_walk1   =[ $walk1,   ogre_walk2  ] {M_Step(); ai_walk(3);};
void() ogre_walk2   =[ $walk2,   ogre_walk3  ] {ai_walk(2);};
void() ogre_walk3   =[ $walk3,   ogre_walk4  ] {ai_walk(2);
if (random() < 0.2)
    sound (self, CHAN_VOICE, "ogre/ogidle.wav", 1, ATTN_IDLE);
};
void() ogre_walk4   =[ $walk4,   ogre_walk5  ] {ai_walk(2);};
void() ogre_walk5   =[ $walk5,   ogre_walk6  ] {ai_walk(2);};
void() ogre_walk6   =[ $walk6,   ogre_walk7  ] {ai_walk(5);
if (random() < 0.1)
    sound (self, CHAN_VOICE, "ogre/ogdrag.wav", 1, ATTN_IDLE);
};
void() ogre_walk7   =[ $walk7,   ogre_walk8  ] {ai_walk(3);};
void() ogre_walk8   =[ $walk8,   ogre_walk9  ] {ai_walk(2);};
void() ogre_walk9   =[ $walk9,   ogre_walk10 ] {M_Step(); ai_walk(3);};
void() ogre_walk10  =[ $walk10,  ogre_walk11 ] {ai_walk(1);};
void() ogre_walk11  =[ $walk11,  ogre_walk12 ] {ai_walk(2);};
void() ogre_walk12  =[ $walk12,  ogre_walk13 ] {ai_walk(3);};
void() ogre_walk13  =[ $walk13,  ogre_walk14 ] {ai_walk(3);};
void() ogre_walk14  =[ $walk14,  ogre_walk15 ] {ai_walk(3);};
void() ogre_walk15  =[ $walk15,  ogre_walk16 ] {ai_walk(3);};
void() ogre_walk16  =[ $walk16,  ogre_walk1  ] {ai_walk(4);};

// RUN - - - - - - - - - - - - - - - - -
void() ogre_run1    =[ $run1,    ogre_run2   ] {ai_run(9);
if (random() < 0.2)
    sound (self, CHAN_VOICE, "ogre/ogidle2.wav", 1, ATTN_IDLE);
};
void() ogre_run2    =[ $run2,    ogre_run3   ] {M_Step(); ai_run(12);};
void() ogre_run3    =[ $run3,    ogre_run4   ] {ai_run(8);};
void() ogre_run4    =[ $run4,    ogre_run5   ] {ai_run(22);};
void() ogre_run5    =[ $run5,    ogre_run6   ] {ai_run(16);};
void() ogre_run6    =[ $run6,    ogre_run7   ] {M_Step(); ai_run(4);};
void() ogre_run7    =[ $run7,    ogre_run8   ] {ai_run(13);};
void() ogre_run8    =[ $run8,    ogre_run1   ] {ai_run(24);};

// ATTACK - - - - - - - - - - - - - - -
void() ogre_swing1  =[ $swing1,  ogre_swing2  ] {ai_charge(11);
sound (self, CHAN_WEAPON, "ogre/ogsawatk.wav", 1, ATTN_NORM);
};
void() ogre_swing2  =[ $swing2,  ogre_swing3  ] {ai_charge(1);};
void() ogre_swing3  =[ $swing3,  ogre_swing4  ] {ai_charge(4);};
void() ogre_swing4  =[ $swing4,  ogre_swing5  ] {ai_charge(13);};
void() ogre_swing5  =[ $swing5,  ogre_swing6  ] {M_Step(); ai_charge(9); ogre_chainsaw(0);self.angles_y = self.angles_y + random()*25;};
void() ogre_swing6  =[ $swing6,  ogre_swing7  ] {ogre_chainsaw(200);self.angles_y = self.angles_y + random()* 25;};
void() ogre_swing7  =[ $swing7,  ogre_swing8  ] {ogre_chainsaw(0);self.angles_y = self.angles_y + random()* 25;};
void() ogre_swing8  =[ $swing8,  ogre_swing9  ] {ogre_chainsaw(0);self.angles_y = self.angles_y + random()* 25;};
void() ogre_swing9  =[ $swing9,  ogre_swing10 ] {ogre_chainsaw(0);self.angles_y = self.angles_y + random()* 25;};
void() ogre_swing10 =[ $swing10, ogre_swing11 ] {ogre_chainsaw(-200);self.angles_y = self.angles_y + random()* 25;};
void() ogre_swing11 =[ $swing11, ogre_swing12 ] {ogre_chainsaw(0);self.angles_y = self.angles_y + random()* 25;};
void() ogre_swing12 =[ $swing12, ogre_swing13 ] {ai_charge(3);};
void() ogre_swing13 =[ $swing13, ogre_swing14 ] {ai_charge(8);};
void() ogre_swing14 =[ $swing14, ogre_run1    ] {ai_charge(9);};

void() ogre_smash1  =[ $smash1,  ogre_smash2  ] {ai_charge(6);
sound (self, CHAN_WEAPON, "ogre/ogsawatk.wav", 1, ATTN_NORM);
};
void() ogre_smash2  =[ $smash2,  ogre_smash3  ] {ai_charge(0);};
void() ogre_smash3  =[ $smash3,  ogre_smash4  ] {ai_charge(0);};
void() ogre_smash4  =[ $smash4,  ogre_smash5  ] {ai_charge(1);};
void() ogre_smash5  =[ $smash5,  ogre_smash6  ] {ai_charge(4);};
void() ogre_smash6  =[ $smash6,  ogre_smash7  ] {ai_charge(4); ogre_chainsaw(0);};
void() ogre_smash7  =[ $smash7,  ogre_smash8  ] {ai_charge(4); ogre_chainsaw(0);};
void() ogre_smash8  =[ $smash8,  ogre_smash9  ] {ai_charge(10); ogre_chainsaw(0);};
void() ogre_smash9  =[ $smash9,  ogre_smash10 ] {M_Step(); ai_charge(13); ogre_chainsaw(0);};
void() ogre_smash10 =[ $smash10, ogre_smash11 ] {ogre_chainsaw(1);};
void() ogre_smash11 =[ $smash11, ogre_smash12 ] {ai_charge(2); ogre_chainsaw(0);
self.nextthink = self.nextthink + random()*0.2;};    // slight variation
void() ogre_smash12 =[ $smash12, ogre_smash13 ] {ai_charge(2);};   // FIXED!
void() ogre_smash13 =[ $smash13, ogre_smash14 ] {ai_charge(4);};
void() ogre_smash14 =[ $smash14, ogre_run1    ] {ai_charge(12);};

void() ogre_melee =
{
    if (random() > 0.5)
        ogre_smash1 ();
    else
        ogre_swing1 ();
};

void() ogre_nail1   =[ $shoot1,  ogre_nail2   ] {ai_face();};
void() ogre_nail2   =[ $shoot2,  ogre_nail3   ] {ai_face();};
void() ogre_nail3   =[ $shoot2,  ogre_nail4   ] {ai_face();};
void() ogre_nail4   =[ $shoot3,  ogre_nail5   ] {ai_face();
if (self.skin == 1)
    OgreFireNail();
else
    OgreFireGrenade();
};
void() ogre_nail5   =[ $shoot4,  ogre_nail6   ] {ai_face();};
void() ogre_nail6   =[ $shoot5,  ogre_nail7   ] {ai_face();};
void() ogre_nail7   =[ $shoot6,  ogre_run1    ] {ai_face();};

// PAIN - - - - - - - - - - - - - - - -
void() ogre_pain1   =[ $pain1,   ogre_pain2   ] {};
void() ogre_pain2   =[ $pain2,   ogre_pain3   ] {};
void() ogre_pain3   =[ $pain3,   ogre_pain4   ] {};
void() ogre_pain4   =[ $pain4,   ogre_pain5   ] {};
void() ogre_pain5   =[ $pain5,   ogre_run1    ] {};

void() ogre_painb1  =[ $painb1,  ogre_painb2  ] {};
void() ogre_painb2  =[ $painb2,  ogre_painb3  ] {};
void() ogre_painb3  =[ $painb3,  ogre_run1    ] {};

void() ogre_painc1  =[ $painc1,  ogre_painc2  ] {};
void() ogre_painc2  =[ $painc2,  ogre_painc3  ] {};
void() ogre_painc3  =[ $painc3,  ogre_painc4  ] {};
void() ogre_painc4  =[ $painc4,  ogre_painc5  ] {};
void() ogre_painc5  =[ $painc5,  ogre_painc6  ] {};
void() ogre_painc6  =[ $painc6,  ogre_run1    ] {};

void() ogre_paind1  =[ $paind1,  ogre_paind2  ] {};
void() ogre_paind2  =[ $paind2,  ogre_paind3  ] {ai_back(10);};
void() ogre_paind3  =[ $paind3,  ogre_paind4  ] {ai_back(9);};
void() ogre_paind4  =[ $paind4,  ogre_paind5  ] {ai_back(4);};
void() ogre_paind5  =[ $paind5,  ogre_paind6  ] {};
void() ogre_paind6  =[ $paind6,  ogre_paind7  ] {};
void() ogre_paind7  =[ $paind7,  ogre_paind8  ] {};
void() ogre_paind8  =[ $paind8,  ogre_paind9  ] {};
void() ogre_paind9  =[ $paind9,  ogre_paind10 ] {};
void() ogre_paind10 =[ $paind10, ogre_paind11 ] {};
void() ogre_paind11 =[ $paind11, ogre_paind12 ] {};
void() ogre_paind12 =[ $paind12, ogre_paind13 ] {};
void() ogre_paind13 =[ $paind13, ogre_paind14 ] {};
void() ogre_paind14 =[ $paind14, ogre_paind15 ] {};
void() ogre_paind15 =[ $paind15, ogre_paind16 ] {};
void() ogre_paind16 =[ $paind16, ogre_run1    ] {};

void() ogre_paine1  =[ $paine1,  ogre_paine2  ] {};
void() ogre_paine2  =[ $paine2,  ogre_paine3  ] {ai_back(10);};
void() ogre_paine3  =[ $paine3,  ogre_paine4  ] {ai_back(9);};
void() ogre_paine4  =[ $paine4,  ogre_paine5  ] {ai_back(4);};
void() ogre_paine5  =[ $paine5,  ogre_paine6  ] {};
void() ogre_paine6  =[ $paine6,  ogre_paine7  ] {};
void() ogre_paine7  =[ $paine7,  ogre_paine8  ] {};
void() ogre_paine8  =[ $paine8,  ogre_paine9  ] {};
void() ogre_paine9  =[ $paine9,  ogre_paine10 ] {};
void() ogre_paine10 =[ $paine10, ogre_paine11 ] {};
void() ogre_paine11 =[ $paine11, ogre_paine12 ] {};
void() ogre_paine12 =[ $paine12, ogre_paine13 ] {};
void() ogre_paine13 =[ $paine13, ogre_paine14 ] {};
void() ogre_paine14 =[ $paine14, ogre_paine15 ] {};
void() ogre_paine15 =[ $paine15, ogre_run1    ] {};

void(entity attacker, float damage) ogre_pain =
{
// don't make multiple pain sounds right after each other
    if (self.pain_finished > time)
        return;

    local   float   r;

    sound (self, CHAN_VOICE, "ogre/ogpain1.wav", 1, ATTN_NORM);        
    self.pain_finished = time + 1;
    if (SUB_IgnorePain ())
        return;

    r = random();
//- - - - - - - - -
    if (skill >= 3)
        r = r * 0.75;   // Use quicker frames only.
//- - - - - - - - -
    if (r < 0.25)
        ogre_pain1 ();
    else if (r < 0.5)
        ogre_painb1 ();
    else if (r < 0.75)
        ogre_painc1 ();
    else
    {   // Longer pain anims.
        self.pain_finished = time + 2;
        if (r < 0.88)
            ogre_paind1 ();
        else
            ogre_paine1 ();
    }

    damage = damage;  attacker = attacker;  // FrikQcc warning squelch!
};

// DEATH - - - - - - - - - - - - - - - -
void() ogre_decap1    =[ $decap1,   ogre_decap2   ] {blood_spray ('9 2 26', 1);};
void() ogre_decap2    =[ $decap2,   ogre_decap3   ] {blood_spray ('1 3 27', 2);};
void() ogre_decap3    =[ $decap3,   ogre_decap4   ] {blood_spray ('-5 1 28', 1); monster_drop();};
void() ogre_decap4    =[ $decap4,   ogre_decap5   ] {blood_spray ('-8 0 27', 1);};
void() ogre_decap5    =[ $decap5,   ogre_decap6   ] {}; //blood_spray ('-12 0 24', 1);};
void() ogre_decap6    =[ $decap6,   ogre_decap7   ] {};
void() ogre_decap7    =[ $decap7,   ogre_decap8   ] {};
void() ogre_decap8    =[ $decap8,   ogre_decap9   ] {};
void() ogre_decap9    =[ $decap9,   ogre_decap10  ] {};
void() ogre_decap10   =[ $decap10,  ogre_decap11  ] {};
void() ogre_decap11   =[ $decap11,  ogre_decap12  ] {};
void() ogre_decap12   =[ $decap12,  ogre_decap13  ] {};
void() ogre_decap13   =[ $decap13,  ogre_decap14  ] {};
void() ogre_decap14   =[ $decap14,  decap_end     ] {};

void() ogre_decapb1   =[ $decapb1,  ogre_decapb2  ] {blood_spray ('9 2 26', 1);};
void() ogre_decapb2   =[ $decapb2,  ogre_decapb3  ] {ai_forward(5); blood_spray ('3 3 26', 2);};
void() ogre_decapb3   =[ $decapb3,  ogre_decapb4  ] {monster_drop(); blood_spray ('8 3 25', 1);};
void() ogre_decapb4   =[ $decapb4,  ogre_decapb5  ] {ai_forward(1);};
void() ogre_decapb5   =[ $decapb5,  ogre_decapb6  ] {ai_forward(3);};
void() ogre_decapb6   =[ $decapb6,  ogre_decapb7  ] {ai_forward(7); blood_spray ('12 3 19', -1);};
void() ogre_decapb7   =[ $decapb7,  ogre_decapb8  ] {ai_forward(25);};
void() ogre_decapb8   =[ $decapb8,  ogre_decapb9  ] {};
void() ogre_decapb9   =[ $decapb9,  ogre_decapb10 ] {};
void() ogre_decapb10  =[ $decapb10, decap_end     ] {};

void() ogre_die1    =[ $death1,   ogre_die2   ] {};
void() ogre_die2    =[ $death2,   ogre_die3   ] {};
void() ogre_die3    =[ $death3,   ogre_die4   ] {monster_drop();};
void() ogre_die4    =[ $death4,   ogre_die5   ] {};
void() ogre_die5    =[ $death5,   ogre_die6   ] {};
void() ogre_die6    =[ $death6,   ogre_die7   ] {};
void() ogre_die7    =[ $death7,   ogre_die8   ] {};
void() ogre_die8    =[ $death8,   ogre_die9   ] {};
void() ogre_die9    =[ $death9,   ogre_die10  ] {};
void() ogre_die10   =[ $death10,  ogre_die11  ] {};
void() ogre_die11   =[ $death11,  ogre_die12  ] {};
void() ogre_die12   =[ $death12,  ogre_die13  ] {};
void() ogre_die13   =[ $death13,  ogre_die14  ] {};
void() ogre_die14   =[ $death14,  monster_end ] {};

void() ogre_bdie1   =[ $bdeath1,  ogre_bdie2  ] {};
void() ogre_bdie2   =[ $bdeath2,  ogre_bdie3  ] {ai_forward(5);};
void() ogre_bdie3   =[ $bdeath3,  ogre_bdie4  ] {monster_drop();};
void() ogre_bdie4   =[ $bdeath4,  ogre_bdie5  ] {ai_forward(1);};
void() ogre_bdie5   =[ $bdeath5,  ogre_bdie6  ] {ai_forward(3);};
void() ogre_bdie6   =[ $bdeath6,  ogre_bdie7  ] {ai_forward(7);};
void() ogre_bdie7   =[ $bdeath7,  ogre_bdie8  ] {ai_forward(25);};
void() ogre_bdie8   =[ $bdeath8,  ogre_bdie9  ] {};
void() ogre_bdie9   =[ $bdeath9,  ogre_bdie10 ] {};
void() ogre_bdie10  =[ $bdeath10, monster_end ] {};

float(float dm) ogre_gib =
{
    if (self.health < self.gib_health)
    {
        sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
        ThrowGib ("progs/gib3.mdl", dm);
        ThrowGib ("progs/gib3.mdl", dm);
        ThrowGib ("progs/gib3.mdl", dm);
        ThrowHead ("progs/h_ogre.mdl", dm);
        return TRUE;
    }
    return FALSE;
};

void() ogre_body =
    {decap_explode ("progs/gib3.mdl", "progs/gib3.mdl", "progs/gib3.mdl");};

void() ogre_die =
{
    if (Shattered ())
        return;
    if (Decapitated ())
    {
        if (random() < 0.5)
            monster_decap ('9 2 26', ogre_decap1);
        else
            monster_decap ('9 2 26', ogre_decapb1);
        newmis.th_die = ogre_body;
        return;
    }
// check for gib
    if (ogre_gib (self.health))
        return;

    sound (self, CHAN_VOICE, "ogre/ogdth.wav", 1, ATTN_NORM);
    if (random() < 0.5)
        ogre_die1 ();
    else
        ogre_bdie1 ();
};

// REVIVE - - - - - - - - - - - - - - -
void() ogre_revive1  =[ $death13,  ogre_revive2  ] {};
void() ogre_revive2  =[ $death12,  ogre_revive3  ] {};
void() ogre_revive3  =[ $death11,  ogre_revive4  ] {};
void() ogre_revive4  =[ $death10,  ogre_revive5  ] {};
void() ogre_revive5  =[ $death9,   ogre_revive6  ] {};
void() ogre_revive6  =[ $death8,   ogre_revive7  ] {};
void() ogre_revive7  =[ $death7,   ogre_revive8  ] {};
void() ogre_revive8  =[ $death6,   ogre_revive9  ] {};
void() ogre_revive9  =[ $death5,   ogre_revive10 ] {};
void() ogre_revive10 =[ $death4,   ogre_revive11 ] {};
void() ogre_revive11 =[ $death3,   ogre_revive12 ] {};
void() ogre_revive12 =[ $death2,   ogre_revive13 ] {};
void() ogre_revive13 =[ $death1,   ogre_run1     ] {};

void() ogre_reviveb1  =[ $bdeath9,   ogre_reviveb2  ] {};
void() ogre_reviveb2  =[ $bdeath8,   ogre_reviveb3  ] {};
void() ogre_reviveb3  =[ $bdeath7,   ogre_reviveb4  ] {};
void() ogre_reviveb4  =[ $bdeath6,   ogre_reviveb5  ] {};
void() ogre_reviveb5  =[ $bdeath5,   ogre_reviveb6  ] {};
void() ogre_reviveb6  =[ $bdeath4,   ogre_reviveb7  ] {};
void() ogre_reviveb7  =[ $bdeath3,   ogre_reviveb8  ] {};
void() ogre_reviveb8  =[ $bdeath2,   ogre_reviveb9  ] {};
void() ogre_reviveb9  =[ $bdeath1,   ogre_run1      ] {};

void() ogre_revive =
{
    if ( self.frame == $bdeath10 )
        ogre_reviveb1 ();
    else //if ( self.frame == $death14 )
        ogre_revive1 ();
};


//============================================================================

// OTHER - - - - - - - - - - - - - - - -
void(float hello) ogre_sight =
{
    if (hello)
        sound (self, CHAN_VOICE, "ogre/ogidle2.wav", 1, ATTN_NORM);
    else
        sound (self, CHAN_VOICE, "ogre/ogwake.wav", 1, ATTN_NORM);
};

void() ogre_cache =
{
    precache_model ("progs/ogre.mdl");
    precache_model ("progs/h_ogre.mdl");
    precache_model ("progs/grenade.mdl");

    precache_sound ("ogre/ogdrag.wav");
    precache_sound ("ogre/ogdth.wav");
    precache_sound ("ogre/ogidle.wav");
    precache_sound ("ogre/ogidle2.wav");
    precache_sound ("ogre/ogpain1.wav");
    precache_sound ("ogre/ogsawatk.wav");
    precache_sound ("ogre/ogwake.wav");
//    precache_sound ("weapons/bounce.wav");
//    precache_sound ("weapons/grenade.wav");
//    precache_sound ("weapons/shotgn2.wav");     // Flak gun
};

//============
// --> QUAKED monster_ogre (1 0 0) (-32 -32 -24) (32 32 64) Ambush
//============
void() monster_ogre =
{
    if (!self.spawned)
    {
        if (noenemies)
            {remove (self); return;}
        ogre_cache ();
    }

    local   float   saw;

    monster_form ("progs/ogre.mdl", VEC_HULL2_MIN, VEC_HULL2_MAX, 200, -80);
    self.mdl_head   = "progs/h_ogre.mdl";
    self.mass       = MASS_HEAVY;

    self.th_stand   = ogre_stand1;
    self.th_walk    = ogre_walk1;
    self.th_run     = ogre_run1;
    self.th_missile = ogre_nail1;
    self.th_melee   = ogre_melee;
    self.th_pain    = ogre_pain;
    self.th_die     = ogre_die;
    //- - - - - - - -
    self.th_sight   = ogre_sight;
    self.th_check   = OgreCheckAttack;
    self.th_gib     = ogre_gib;
    self.th_revive  = ogre_revive;
    self.th_spawn   = monster_ogre;

    // Ogres tend to be greedy, so drop some cash when killed.
    if (soul_evil)
    {   saw = 0;
        monster_purse (3, 0.75, 0.25);
    }
    else
    {   saw = WAR_CHAINSAW;
// DISABLED -- No money in normal games.
//        monster_purse (2, 1, 0);    // "Shave and a haircut, two bits!"
    }
    if (self.skin == 1)
        monster_guns (saw, 0, 10, 0, 0);
    else
        monster_guns (saw, 0, 0, 2, 0);

    monster_start ();
};

void() monster_ogre_marksman =
{
// PM:  Leave classname alone.
    monster_ogre ();
    self.th_check = CheckAttack;    // Just like in vanilla Quake.
};

//============
// --> QUAKED monster_ogre_flak (1 0 0) (-32 -32 -24) (32 32 64) Ambush
//============
void() monster_ogre_flak =
{
    self.skin = 1;
    self.classname = "monster_ogre";
    monster_ogre ();
};

// PM:  Removed custom 'monster_ogre_rocket'.
// Rocket ogre is too gimmicky, so add only if it's a boss.

// Replace snakeman with flak ogre.  It was good during its time,
// but these days, I don't need it.
void() monster_snakeman = {monster_ogre_flak();};


//===========================/  END OF FILE  /===========================//
