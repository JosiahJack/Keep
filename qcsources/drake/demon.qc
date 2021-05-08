/*
==============================================================================

DEMON

==============================================================================
*/

$cd id1/models/demon3
$scale    0.8
$origin 0 0 24
$base base
$skin base

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9
$frame stand10 stand11 stand12 stand13

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8

$frame run1 run2 run3 run4 run5 run6

$frame leap1 leap2 leap3 leap4 leap5 leap6 leap7 leap8 leap9 leap10
$frame leap11 leap12

$frame pain1 pain2 pain3 pain4 pain5 pain6

$frame death1 death2 death3 death4 death5 death6 death7 death8 death9

$frame attacka1 attacka2 attacka3 attacka4 attacka5 attacka6 attacka7 attacka8
$frame attacka9 attacka10 attacka11 attacka12 attacka13 attacka14 attacka15

// Extended scenes - - - - - - - - - - -
$frame attackb1 attackb2 attackb3 attackb4 attackb5 attackb6 attackb7 attackb8
$frame attackb9 attackb10 attackb11 attackb12 attackb13 attackb14 attackb15
$frame attackb16 attackb17 attackb18

$frame decap1 decap2 decap3 decap4 decap5 decap6 decap7 decap8 decap9

$frame standb1 standb2 standb3 standb4 standb5 standb6 standb7 standb8
$frame standb9 standb10 standb11 standb12

$frame walkb1 walkb2 walkb3 walkb4 walkb5 walkb6 walkb7 walkb8 walkb9
$frame walkb10 walkb11 walkb12

$frame hop1 hop2 hop3 hop4 hop5 hop6 hop7


//===========================================================================

float   SPAWN_BERSERK   = 2;

//================
// CheckDemonJump
//================
float() CheckDemonJump =
{
    local   vector  dist;
    local   float   d;

    if (!cranked)   // PM:  Ignore normal height restrictions in Cranked mode.
    {
        if (self.origin_z + self.mins_z > self.enemy.origin_z + self.enemy.mins_z
        + 0.75 * self.enemy.size_z)
            return FALSE;       // Target is too low.
        
        if (self.origin_z + self.maxs_z < self.enemy.origin_z + self.enemy.mins_z
        + 0.25 * self.enemy.size_z)
            return FALSE;       // Target is too high.
    }

    dist = self.enemy.origin - self.origin;
    dist_z = 0;
    
    d = vlen(dist);
    
    if (d < 100)
        return FALSE;       // Target is too close.
        
    if (d > 200)
    {
        if (random() < 0.9)
            return FALSE;
    }
        
    return TRUE;
};

float() DemonCheckAttack =
{
//Returns TRUE if a melee attack would hit right now
// if close enough for slashing, go for it
    if (enemy_range == RANGE_MELEE)     // Was 'CheckDemonMelee'.
    {   // FIXME: check canreach
        self.attack_state = AS_MELEE;
        return TRUE;
    }

    if (CheckDemonJump ())
    {
        self.attack_state = AS_MISSILE;
        sound (self, CHAN_VOICE, "demon/djump.wav", 1, ATTN_NORM);
        return TRUE;
    }
    
    return FALSE;
};


//============================================================================

void()    Demon_JumpTouch;

// STAND - - - - - - - - - - - - - - - -
void() demon1_stand1  =[ $stand1,  demon1_stand2  ] {ai_stand();};
void() demon1_stand2  =[ $stand2,  demon1_stand3  ] {ai_stand();};
void() demon1_stand3  =[ $stand3,  demon1_stand4  ] {ai_stand();};
void() demon1_stand4  =[ $stand4,  demon1_stand5  ] {ai_stand();};
void() demon1_stand5  =[ $stand5,  demon1_stand6  ] {ai_stand();};
void() demon1_stand6  =[ $stand6,  demon1_stand7  ] {ai_stand();};
void() demon1_stand7  =[ $stand7,  demon1_stand8  ] {ai_stand();};
void() demon1_stand8  =[ $stand8,  demon1_stand9  ] {ai_stand();};
void() demon1_stand9  =[ $stand9,  demon1_stand10 ] {ai_stand();};
void() demon1_stand10 =[ $stand10, demon1_stand11 ] {ai_stand();};
void() demon1_stand11 =[ $stand11, demon1_stand12 ] {ai_stand();};
void() demon1_stand12 =[ $stand12, demon1_stand13 ] {ai_stand();};
void() demon1_stand13 =[ $stand13, demon1_stand1  ] {ai_stand();};

// Custom scene.
void() demon1_standb1  =[ $standb1,  demon1_standb2  ] {ai_stand();};
void() demon1_standb2  =[ $standb2,  demon1_standb3  ] {ai_stand();};
void() demon1_standb3  =[ $standb3,  demon1_standb4  ] {ai_stand();};
void() demon1_standb4  =[ $standb4,  demon1_standb5  ] {ai_stand();};
void() demon1_standb5  =[ $standb5,  demon1_standb6  ] {ai_stand();};
void() demon1_standb6  =[ $standb6,  demon1_standb7  ] {ai_stand();};
void() demon1_standb7  =[ $standb7,  demon1_standb8  ] {ai_stand();};
void() demon1_standb8  =[ $standb8,  demon1_standb9  ] {ai_stand();};
void() demon1_standb9  =[ $standb9,  demon1_standb10 ] {ai_stand();};
void() demon1_standb10 =[ $standb10, demon1_standb11 ] {ai_stand();};
void() demon1_standb11 =[ $standb11, demon1_standb12 ] {ai_stand();};
void() demon1_standb12 =[ $standb12, demon1_standb1  ] {ai_stand();};

// WALK - - - - - - - - - - - - - - - -
void() demon1_walk1   =[ $walk1,   demon1_walk2   ] {
if (random() < 0.2)
    sound (self, CHAN_VOICE, "demon/idle1.wav", 1, ATTN_IDLE);
ai_walk(8);
};
void() demon1_walk2   =[ $walk2,   demon1_walk3   ] {ai_walk(6);};
void() demon1_walk3   =[ $walk3,   demon1_walk4   ] {ai_walk(6);};
void() demon1_walk4   =[ $walk4,   demon1_walk5   ] {ai_walk(7);};
void() demon1_walk5   =[ $walk5,   demon1_walk6   ] {ai_walk(4);};
void() demon1_walk6   =[ $walk6,   demon1_walk7   ] {ai_walk(6);};
void() demon1_walk7   =[ $walk7,   demon1_walk8   ] {ai_walk(10);};
void() demon1_walk8   =[ $walk8,   demon1_walk1   ] {ai_walk(10);};

// Alternate frames from Qtest demon.
void() demon1_walkb1  =[ $walkb1,  demon1_walkb2  ] {
if (random() < 0.2)
    sound (self, CHAN_VOICE, "demon/idle1.wav", 1, ATTN_IDLE);
ai_walk(4);
};
void() demon1_walkb2  =[ $walkb2,  demon1_walkb3  ] {ai_walk(6);};
void() demon1_walkb3  =[ $walkb3,  demon1_walkb4  ] {ai_walk(6);};
void() demon1_walkb4  =[ $walkb4,  demon1_walkb5  ] {ai_walk(7);};
void() demon1_walkb5  =[ $walkb5,  demon1_walkb6  ] {ai_walk(6);};
void() demon1_walkb6  =[ $walkb6,  demon1_walkb7  ] {ai_walk(6);};
void() demon1_walkb7  =[ $walkb7,  demon1_walkb8  ] {ai_walk(5);};
void() demon1_walkb8  =[ $walkb8,  demon1_walkb9  ] {ai_walk(12);};
void() demon1_walkb9  =[ $walkb9,  demon1_walkb10 ] {ai_walk(5);};
void() demon1_walkb10 =[ $walkb10, demon1_walkb11 ] {ai_walk(5);};
void() demon1_walkb11 =[ $walkb11, demon1_walkb12 ] {ai_walk(7);};
void() demon1_walkb12 =[ $walkb12, demon1_walkb1  ] {ai_walk(6);};

// RUN - - - - - - - - - - - - - - - - -
void() demon1_run1    =[ $run1,    demon1_run2    ] {
if (random() < 0.2)
    sound (self, CHAN_VOICE, "demon/idle1.wav", 1, ATTN_IDLE);
ai_run(20);};
void() demon1_run2    =[ $run2,    demon1_run3    ] {ai_run(15);};
void() demon1_run3    =[ $run3,    demon1_run4    ] {ai_run(36);};
void() demon1_run4    =[ $run4,    demon1_run5    ] {ai_run(20);};
void() demon1_run5    =[ $run5,    demon1_run6    ] {ai_run(15);};
void() demon1_run6    =[ $run6,    demon1_run1    ] {ai_run(36);};

void() demon1_hop1    =[ $hop1,    demon1_hop2    ] {};
void() demon1_hop2    =[ $hop2,    demon1_hop3    ] {};
void() demon1_hop3    =[ $hop3,    demon1_hop4    ] {};
void() demon1_hop4    =[ $hop4,    demon1_hop5    ] {};
void() demon1_hop5    =[ $hop5,    demon1_hop6    ] {};
void() demon1_hop6    =[ $hop6,    demon1_hop7    ] {};
void() demon1_hop7    =[ $hop7,    demon1_run1    ] {};

// ATTACK - - - - - - - - - - - - - - -
void() demon1_jump1   =[ $leap1,   demon1_jump2   ] {ai_face();};
void() demon1_jump2   =[ $leap2,   demon1_jump3   ] {ai_face();};
void() demon1_jump3   =[ $leap3,   demon1_jump4   ] {ai_face();};
void() demon1_jump4   =[ $leap4,   demon1_jump5   ]
{
    local   float   g;

    g = Gs();

    ai_face();
    ai_dizzy();     // PM:  Check for mis-aim from invisibility.

    self.touch      = Demon_JumpTouch;
    makevectors (self.angles);
    self.origin_z   = self.origin_z + 1;
    if (cranked)
    {
        local   vector  v1, v2, dir;
        local   float   up;

        // Aim from feet to enemy eyes.
        v1 = self.origin;
        v1_z = self.absmin_z + 1;
        v2 = self.enemy.origin;
        v2_z = self.enemy.absmin_z + self.enemy.size_z * 0.7;
        dir = v2 - v1;
        up = vlen(dir);
        dir = normalize (dir);
        if (up > 600)
            v2 = v1 + dir*600;
        up = Aim_TossUp (v1, v2, 600);     // Doesn't call makevectors.
        self.velocity   = dir * 600;
        self.velocity_z = self.velocity_z + up;
        // If not enough upward momentum, use normal velocity.
        if (self.velocity_z < 80 * g)
            self.velocity   = (v_forward * 600) + ('0 0 250' * g);
    }
    else
        self.velocity   = (v_forward * 600) + ('0 0 250' * g);
    self.flags      = self.flags - (self.flags & FL_ONGROUND);
};
void() demon1_jump5   =[ $leap5,   demon1_jump6   ] {};
void() demon1_jump6   =[ $leap6,   demon1_jump7   ] {};
void() demon1_jump7   =[ $leap7,   demon1_jump8   ] {};
void() demon1_jump8   =[ $leap8,   demon1_jump9   ] {};
void() demon1_jump9   =[ $leap9,   demon1_jump10  ] {};
void() demon1_jump10  =[ $leap10,  demon1_jump1   ]
{
    self.nextthink = time + 3;
    // If three seconds pass, assume demon is stuck and jump again.
};
void() demon1_jump11  =[ $leap11,  demon1_jump12  ] {};
void() demon1_jump12  =[ $leap12,  demon1_run1    ] {};

void() Demon_JumpTouch =
{
    local   float   ldmg;

    if (self.health <= 0)
        return;
        
    if (other.takedamage)
    {
        if ( vlen(self.velocity) > 400 )
        {
            ldmg = 40 + 10*random();
            T_Damage (other, self, self, ldmg);    

            if (self.health <= 0)
                return;     // PM:  Killed by thorns (empathy shields).
        }
    }

    if (!checkbottom(self))
    {
        if (self.flags & FL_ONGROUND)
        {    // jump randomly to not get hung up
//dprint ("popjump\n");
            self.touch = SUB_Null;
            self.think = demon1_jump1;
            self.nextthink = time + 0.1;

//            self.velocity_x = (random() - 0.5) * 600;
//            self.velocity_y = (random() - 0.5) * 600;
//            self.velocity_z = 200;
//            self.flags = self.flags - FL_ONGROUND;
        }
        return;    // not on ground yet
    }

    self.touch = SUB_Null;
    self.think = demon1_jump11;
    self.nextthink = time + 0.1;
};


//===========================================================================

// Used by berserker fiends.
void() Demon_Gore =
{
//    local   float   ldmg;
    local   vector  delta;
    
    delta = self.enemy.origin - self.origin;
    if (!InMeleeRange (80))     // Headbutt has less range.
        return;
    if (!CanDamage (self.enemy, self))
        return;
    if (IsGhost (self.enemy))   // NEW!
        return;     // Not allowed to hit wraith.

    // Note:  Different than Armagon's because we ignore elevation.
    local   vector  dir;

    dir = self.enemy.origin;
    dir_z = self.origin_z;     // Only interested in xy-plane, so ignore z.
    dir = normalize(dir - self.origin);
    dir = dir * 320;
    dir_z = 300;    // Add a little up to overcome normal gravity.
// Send the enemy flying.
    if (self.enemy.mass && (self.enemy.mass <= MASS_SUPER))
    {
        if (self.enemy.mass == MASS_SUPER)
            dir = dir * 0.5;
        self.enemy.flags = self.enemy.flags - (self.enemy.flags & FL_ONGROUND);
        self.enemy.velocity = self.enemy.velocity + dir;
    }
// Do the damage.  No knockback because we already applied it.
    sound (self, CHAN_WEAPON, "weapons/axhit.wav", 1, ATTN_NORM);
    T_NewDamage (self.enemy, self, self, 20, DF_NO_KNOCK, "");
};

void(float side) Demon_Melee =
{
    local   float   ldmg;
    local   vector  delta, org;
    
    ai_face ();
    walkmove (self.ideal_yaw, 12);    // allow a little closing

    delta = self.enemy.origin - self.origin;

    if (!InMeleeRange (100))    //if (vlen(delta) > 100)
        return;
    if (!CanDamage (self.enemy, self))
        return;
    if (IsGhost (self.enemy))   // NEW!
      if (!(self.enemy.xf2 & XF2_CLONE))  // Nsoe1 hack.
        return;     // Not allowed to hit wraith.

    sound (self, CHAN_WEAPON, "demon/dhit2.wav", 1, ATTN_NORM);
    makevectors (self.angles);
    org = self.origin + v_forward*16;
    if (side)
    {
        ldmg = 10 + 5*random();
        if (fabs(side) == 1)
            delta = 100 * ((side * v_right) + v_up);    // Qtest smash anim.
        else
            delta = side * v_right;     // standard
        T_Damage (self.enemy, self, self, ldmg);    
        SpawnMeatSpray (org, delta, self.enemy.bloodtype);
    }
    else
    {   // Custom double slam.
        ldmg = 20 + 10*random();
        T_Damage (self.enemy, self, self, ldmg);    
        SpawnMeatSpray (org, 100 * (v_up + v_right), self.enemy.bloodtype);
        SpawnMeatSpray (org, 100 * (v_up - v_right), self.enemy.bloodtype);
    }

// Old stuff.
//    T_Damage (self.enemy, self, self, ldmg);    
//
//    makevectors (self.angles);
//    SpawnMeatSpray (self.origin + v_forward*16, side * v_right, self.enemy.bloodtype);
};

void() demon1_atta1  =[ $attacka1,  demon1_atta2  ] {ai_charge(4);};
void() demon1_atta2  =[ $attacka2,  demon1_atta3  ] {ai_charge(0);};
void() demon1_atta3  =[ $attacka3,  demon1_atta4  ] {ai_charge(0);};
void() demon1_atta4  =[ $attacka4,  demon1_atta5  ] {ai_charge(1);};
void() demon1_atta5  =[ $attacka5,  demon1_atta6  ] {ai_charge(2); Demon_Melee(200);};
void() demon1_atta6  =[ $attacka6,  demon1_atta7  ] {ai_charge(1);};
void() demon1_atta7  =[ $attacka7,  demon1_atta8  ] {ai_charge(6);};
void() demon1_atta8  =[ $attacka8,  demon1_atta9  ] {ai_charge(8);};
void() demon1_atta9  =[ $attacka9,  demon1_atta10 ] {ai_charge(4);};
void() demon1_atta10 =[ $attacka10, demon1_atta11 ] {ai_charge(2);};
void() demon1_atta11 =[ $attacka11, demon1_atta12 ] {Demon_Melee(-200);};
void() demon1_atta12 =[ $attacka12, demon1_atta13 ] {ai_charge(5);};
void() demon1_atta13 =[ $attacka13, demon1_atta14 ] {ai_charge(8);};
void() demon1_atta14 =[ $attacka14, demon1_atta15 ] {ai_charge(4);};
void() demon1_atta15 =[ $attacka15, demon1_run1   ] {ai_charge(4);};

// Update:  Sped up Qtest anim to match standard.
void() demon1_smash1  =[ $attackb1,  demon1_smash2  ] {ai_charge(4);};
void() demon1_smash2  =[ $attackb2,  demon1_smash3  ] {ai_charge(1);};
void() demon1_smash3  =[ $attackb3,  demon1_smash4  ] {ai_charge(2);};
void() demon1_smash4  =[ $attackb4,  demon1_smash5  ] {ai_charge(2);};
void() demon1_smash5  =[ $attackb5,  demon1_smash7  ] {ai_charge(2);};
//void() demon1_smash6  =[ $attackb6,  demon1_smash7  ] {ai_charge(6);};
void() demon1_smash7  =[ $attackb7,  demon1_smash8  ] {ai_charge(16);Demon_Melee(1);};  //6+10
void() demon1_smash8  =[ $attackb8,  demon1_smash9  ] {ai_charge(9);};
void() demon1_smash9  =[ $attackb9,  demon1_smash10 ] {ai_charge(5);};
void() demon1_smash10 =[ $attackb10, demon1_smash11 ] {ai_charge(1);};
void() demon1_smash11 =[ $attackb11, demon1_smash13 ] {ai_charge(0);};
//void() demon1_smash12 =[ $attackb12, demon1_smash13 ] {ai_charge(2);};
void() demon1_smash13 =[ $attackb13, demon1_smash14 ] {ai_charge(9);};  //2+7
void() demon1_smash14 =[ $attackb14, demon1_smash15 ] {ai_charge(12);Demon_Melee(-1);};
void() demon1_smash15 =[ $attackb15, demon1_smash16 ] {ai_charge(6);};
void() demon1_smash16 =[ $attackb16, demon1_smash18 ] {ai_charge(1);};
//void() demon1_smash17 =[ $attackb17, demon1_smash18 ] {ai_charge(1);};
void() demon1_smash18 =[ $attackb18, demon1_run1    ] {ai_charge(3);};  //1+2

void() demon1_fasta1  =[ $attacka2,  demon1_fasta2  ] {ai_charge(0);};
void() demon1_fasta2  =[ $attacka3,  demon1_fasta3  ] {ai_charge(0);};
void() demon1_fasta3  =[ $attacka5,  demon1_fasta4  ] {ai_charge(3); Demon_Melee(200);};
void() demon1_fasta4  =[ $attacka6,  demon1_fasta5  ] {ai_charge(1);};
void() demon1_fasta5  =[ $attacka7,  demon1_fasta6  ] {ai_charge(6);};
void() demon1_fasta6  =[ $attacka9,  demon1_fasta7  ] {ai_charge(11);};
void() demon1_fasta7  =[ $attacka11, demon1_fasta8  ] {ai_charge(2); Demon_Melee(-200);};
void() demon1_fasta8  =[ $attacka12, demon1_fasta9  ] {ai_charge(5);};
void() demon1_fasta9  =[ $attacka13, demon1_fasta10 ] {ai_charge(8);};
void() demon1_fasta10 =[ $attacka15, demon1_run1    ] {ai_charge(8);};

void() demon1_fastb1  =[ $attackb2,  demon1_fastb2  ] {ai_charge(1);};
void() demon1_fastb2  =[ $attackb3,  demon1_fastb3  ] {ai_charge(2);};
void() demon1_fastb3  =[ $attackb5,  demon1_fastb4  ] {ai_charge(3);};
void() demon1_fastb4  =[ $attackb7,  demon1_fastb5  ] {ai_charge(10);Demon_Melee(1);};
void() demon1_fastb5  =[ $attackb8,  demon1_fastb6  ] {ai_charge(9);};
void() demon1_fastb6  =[ $attackb10, demon1_fastb7  ] {ai_charge(10);};
void() demon1_fastb7  =[ $attackb11, demon1_fastb9  ] {ai_charge(0);};
//void() demon1_fastb8  =[ $attackb12, demon1_fastb9  ] {ai_charge(2);};
void() demon1_fastb9  =[ $attackb14, demon1_fastb10 ] {ai_charge(12);Demon_Melee(-1);}; //2+10
void() demon1_fastb10 =[ $attackb15, demon1_fastb12 ] {ai_charge(6);};
//void() demon1_fastb11 =[ $attackb16, demon1_fastb12 ] {ai_charge(1);};
void() demon1_fastb12 =[ $attackb18, demon1_run1    ] {ai_charge(4);};  //1+3

// Gore - - - - - -
void() demon1_combo6  =[ $leap11,    demon1_combo7  ] {ai_charge(2); Demon_Melee(0);};
void() demon1_combo7  =[ $leap12,    demon1_run1   ] {ai_charge(0);};

// Yes, show hop2 first then hop1 for the headbutt to look right.
void() demon1_bash1  =[ $attacka1,  demon1_bash2  ] {ai_charge(4);};
void() demon1_bash2  =[ $hop2,      demon1_bash3  ] {ai_face(); ai_back(5);};
void() demon1_bash3  =[ $hop1,      demon1_bash4  ] {ai_face(); ai_back(5);};
void() demon1_bash4  =[ $hop3,      demon1_bash5  ] {ai_face(); ai_forward(23); Demon_Gore();};
void() demon1_bash5  =[ $hop4,      demon1_bash6  ] {//ai_charge(2);
    ai_face ();
    makevectors (self.angles);
    self.velocity = v_forward*400 + '0 0 200';  // Normal jump is '600 0 250'.
    self.flags = self.flags - (self.flags & FL_ONGROUND);
    if (cranked || (self.spawnflags & SPAWN_BERSERK))
    {   // Attack again.
        self.frame = $leap10;
        self.think = demon1_combo6;
    }
};
void() demon1_bash6  =[ $hop5,      demon1_bash7  ] {};
void() demon1_bash7  =[ $hop6,      demon1_bash8  ] {};
void() demon1_bash8  =[ $hop7,      demon1_run1   ] {};
//- - - - - - - - -

void() Demon_MeleeAttack =
{
    local   float   fast, r;

// Shadow version always swings quicker than normal.
// FIXME:  No!  Not in Drake.
    fast = SUB_QuickAttack ();
    if (self.skin == 1)
        fast = 1;

    // one of two attacks
    // Pattern:  Every third attack is an overhead.
    r = self.height = (self.height + 1) & 3;    //AddOne() & 3;
    if (r == 3)
        r = self.height = 0;
    if (self.spawnflags & SPAWN_BERSERK)
    {   fast = 1;
        r = r + 1;      // Berserker.
    }

    if (r == 2)
    {   // Overhead smash from Qtest and Nehahra.
        if (fast)
            demon1_fastb1 ();
        else
            demon1_smash1 ();
    }
    else if (r == 3)
        demon1_bash1 ();
    else
    {   // Standard slash.
        if (fast)
            demon1_fasta1 ();
        else
            demon1_atta1 ();
    }
};

//===========================================================================


// PAIN - - - - - - - - - - - - - - - -
void() demon1_pain1 =[ $pain1, demon1_pain2 ] {};
void() demon1_pain2 =[ $pain2, demon1_pain3 ] {};
void() demon1_pain3 =[ $pain3, demon1_pain4 ] {};
void() demon1_pain4 =[ $pain4, demon1_pain5 ] {};
void() demon1_pain5 =[ $pain5, demon1_pain6 ] {};
void() demon1_pain6 =[ $pain6, demon1_run1  ] {};

//void() demon1_painb1 =[ $leap1,  demon1_bash2 ] {ai_forward(12);};
//void() demon1_painb1 =[ $leap2,  demon1_painb2 ] {ai_forward(6);};
//void() demon1_painb2 =[ $hop1,   demon1_painb3 ] {ai_back(18);};    //24
//void() demon1_painb3 =[ $hop2,   demon1_painb4 ] {ai_forward(5);};
//void() demon1_painb4 =[ $hop3,   demon1_painb5 ] {ai_forward(18);};
//void() demon1_painb5 =[ $pain6,  demon1_run1   ] {ai_forward(4);};
//void() demon1_painb5 =[ $leap11, demon1_painb6 ] {ai_forward(3);};
//void() demon1_painb6 =[ $leap12, demon1_run1   ] {};

void(entity attacker, float damage) demon1_pain =
{
    if (self.touch == Demon_JumpTouch)
        return;

    if (self.pain_finished > time)
        return;

    self.pain_finished = time + 1;
    sound (self, CHAN_VOICE, "demon/dpain1.wav", 1, ATTN_NORM);

    if (random()*200 > damage)
        return;        // didn't flinch
    if (SUB_IgnorePain ())
        return;         // No pain anims in Nightmare.

    demon1_pain1 ();
    attacker = attacker;    // FrikQcc warning squelch!
};

// DEATH - - - - - - - - - - - - - - - -
void() demon1_decap1 =[ $decap1, demon1_decap2 ] {blood_spray('-4 0 22', 1);};
void() demon1_decap2 =[ $decap2, demon1_decap3 ] {blood_spray('-6 1 22', 1);};
void() demon1_decap3 =[ $decap3, demon1_decap4 ] {blood_spray('-8 1 20', 1);};
void() demon1_decap4 =[ $decap4, demon1_decap5 ] {blood_spray('-10 2 15', 1);};
void() demon1_decap5 =[ $decap5, demon1_decap6 ] {blood_spray('-16 6 6', 1);};
void() demon1_decap6 =[ $decap6, demon1_decap7 ] {blood_spray('-18 8 0', 1);monster_drop();};
void() demon1_decap7 =[ $decap7, demon1_decap8 ] {};
void() demon1_decap8 =[ $decap8, demon1_decap9 ] {};
void() demon1_decap9 =[ $decap9, decap_end     ] {};

void() demon1_die1 =[ $death1, demon1_die2 ] {sound (self, CHAN_VOICE, "demon/ddeath.wav", 1, ATTN_NORM);};
void() demon1_die2 =[ $death2, demon1_die3 ] {};
void() demon1_die3 =[ $death3, demon1_die4 ] {};
void() demon1_die4 =[ $death4, demon1_die5 ] {};
void() demon1_die5 =[ $death5, demon1_die6 ] {};
void() demon1_die6 =[ $death6, demon1_die7 ] {monster_drop();};
void() demon1_die7 =[ $death7, demon1_die8 ] {};
void() demon1_die8 =[ $death8, demon1_die9 ] {};
void() demon1_die9 =[ $death9, monster_end ] {};

float(float dm) demon_gib =
{
// check for gib
    if (self.health < self.gib_health)
    {
        sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
        ThrowGib ("progs/gib1.mdl", dm);
        ThrowGib ("progs/gib1.mdl", dm);
        ThrowGib ("progs/gib1.mdl", dm);
        ThrowHead ("progs/h_demon.mdl", dm);
        return TRUE;
    }
    return FALSE;
};

void() demon_body =
    {decap_explode ("progs/gib1.mdl", "progs/gib1.mdl", "progs/gib1.mdl");};

void() demon_die =
{
//- - - - -
    if (Shattered ())
        return;
    if (Decapitated ())
    {
        monster_decap ('-4 0 22', demon1_decap1);
        newmis.th_die = demon_body;
        return;
    }
//- - - - -
// check for gib
    if (demon_gib (self.health))
        return;

// regular death
    demon1_die1 ();
};

// REVIVE - - - - - - - - - - - - - - -
void() demon1_revive1 =[ $death8, demon1_revive2 ] {};
void() demon1_revive2 =[ $death7, demon1_revive3 ] {};
void() demon1_revive3 =[ $death6, demon1_revive4 ] {};
void() demon1_revive4 =[ $death5, demon1_revive5 ] {};
void() demon1_revive5 =[ $death4, demon1_revive6 ] {};
void() demon1_revive6 =[ $death3, demon1_revive7 ] {};
void() demon1_revive7 =[ $death2, demon1_revive8 ] {};
void() demon1_revive8 =[ $death1, demon1_pain5   ] {};


// OTHER - - - - - - - - - - - - - - - -
void(float hello) demon_sight =
{
    if (hello)
        sound (self, CHAN_VOICE, "demon/idle1.wav", 1, ATTN_NORM);
    else
        sound (self, CHAN_VOICE, "demon/sight2.wav", 1, ATTN_NORM);
};

void() demon1_cache =
{
    precache_model ("progs/demon.mdl");
    precache_model ("progs/h_demon.mdl");

    precache_sound ("demon/ddeath.wav");
    precache_sound ("demon/dhit2.wav");
    precache_sound ("demon/djump.wav");
    precache_sound ("demon/dpain1.wav");
    precache_sound ("demon/idle1.wav");
    precache_sound ("demon/sight2.wav");
};

//============
// --> QUAKED monster_demon1 (1 0 0) (-32 -32 -24) (32 32 64) Ambush Berserk
//
// skin
// 0 = Original skin
// 1 = Soul of Evil shadow beast
// 2 = Gray wolf-fiend
// 3 = Red eyed black fiend
// 4 = Snow fiend
//
// I'd rather put black fiend at skin 1, but that breaks old SoE maps.
//============
void() monster_demon1 =
{
    if (!self.spawned)
    {
        if (noenemies)
            {remove (self); return;}
        demon1_cache ();
    }

    local   float   hp;

    if (self.spawnflags & SPAWN_BERSERK)
        hp = 375;   // Emulate Nehahra's alpha field.
    else
        hp = 300;
    if (world.tronyn & DJG_SNOW)
        self.skin = 3;
    else if (!respawning)
    {   // Convert old skin to match those in updated model.
        if (soul_evil)
        {
            if (world.model == "maps/nsoe2.bsp")
                self.skin = 2;      // Convert to wolf-fiend variant.
        }
    }
    monster_form ("progs/demon.mdl", VEC_HULL2_MIN, VEC_HULL2_MAX, hp, -80);
    self.mdl_head   = "progs/h_demon.mdl";
    self.mass       = MASS_HEAVY;

    if (self.spawnflags & SPAWN_BERSERK)
    {   self.th_stand   = demon1_standb1;
        self.th_walk    = demon1_walkb1;
    }
    else
    {   self.th_stand   = demon1_stand1;
        self.th_walk    = demon1_walk1;
    }
    self.th_run     = demon1_run1;
    self.th_missile = demon1_jump1;         // jump attack
    self.th_melee   = Demon_MeleeAttack;    // Formerly 'demon1_atta1'.
    self.th_pain    = demon1_pain;
    self.th_die     = demon_die;
    //- - - - - - - -
    self.th_jump    = demon1_hop1;
    self.th_check   = DemonCheckAttack;
    self.th_sight   = demon_sight;
    self.th_gib     = demon_gib;
    self.th_revive  = demon1_revive1;
    self.th_spawn   = monster_demon1;
        
    if (soul_evil)
        monster_purse (2, 0.05, 1);     // 5% of either horn is gem quality.

    monster_start ();
};


//===========================/  END OF FILE  /===========================//
