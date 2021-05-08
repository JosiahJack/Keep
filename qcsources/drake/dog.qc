/*
==============================================================================

DOG

==============================================================================
*/
$cd id1/models/dog
$origin 0 0 24
$base base
$skin skin

$frame attack1 attack2 attack3 attack4 attack5 attack6 attack7 attack8

$frame death1 death2 death3 death4 death5 death6 death7 death8 death9

$frame deathb1 deathb2 deathb3 deathb4 deathb5 deathb6 deathb7 deathb8
$frame deathb9

$frame pain1 pain2 pain3 pain4 pain5 pain6

$frame painb1 painb2 painb3 painb4 painb5 painb6 painb7 painb8 painb9 painb10
$frame painb11 painb12 painb13 painb14 painb15 painb16

$frame run1 run2 run3 run4 run5 run6 run7 run8 run9 run10 run11 run12

$frame leap1 leap2 leap3 leap4 leap5 leap6 leap7 leap8 leap9

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8

$frame decap1 decap2 decap3 decap4 decap5 decap6 decap7 decap8 decap9

$frame decapb1 decapb2 decapb3 decapb4 decapb5 decapb6 decapb7 decapb8
$frame decapb9


//============================================================================

float() IsHellHound = {return self.skin == 2;};

//==============
// CheckDogMelee
//
// Returns TRUE if a melee attack would hit right now
//==============
float() CheckDogMelee =
{
    if (enemy_range == RANGE_MELEE)
    {    // FIXME: check canreach
        self.attack_state = AS_MELEE;
        return TRUE;
    }
    return FALSE;
};

//==============
// CheckDogJump
//==============
float() CheckDogJump =
{
    local   vector  dist;
    local   float   d;

    if (self.origin_z + self.mins_z > self.enemy.origin_z + self.enemy.mins_z
    + 0.75 * self.enemy.size_z)
        return FALSE;
        
    if (self.origin_z + self.maxs_z < self.enemy.origin_z + self.enemy.mins_z
    + 0.25 * self.enemy.size_z)
        return FALSE;
        
    dist    = self.enemy.origin - self.origin;
    dist_z  = 0;
    
    d = vlen(dist);
    
    if (d < 80)
        return FALSE;
        
    if (IsHellHound ())
    {
        if (d > 600)
            return FALSE;   // Too far away for jumping or shooting.
        if (d > 200)
        {   // Not close enough for jumping, so check for shooting.
            if (random() < 0.9)
                return FALSE;
        }
        return TRUE;
    }
    if (d > 150)
        return FALSE;
        
    return TRUE;
};

float() DogCheckAttack =
{
// if close enough for slashing, go for it (PM:  more like biting)
    if (CheckDogMelee ())
        {self.attack_state = AS_MELEE; return TRUE;}
    
    if (CheckDogJump ())
        {self.attack_state = AS_MISSILE; return TRUE;}
    
    return FALSE;
};

//============================================================================


void() dog_leap1;
void() dog_run1;

//================
// dog_bite
//================
void() dog_bite =
{
    if (!self.enemy)
        return;

    ai_charge(10);

    if (!CanDamage (self.enemy, self))
        return;

    local   float   ldmg;

    if (!InMeleeRange (100))    // PM:  Dragons-related.
        return;
    if (IsGhost (self.enemy))   // PM:  Not allowed to hit wraith.
        return;
        
    ldmg = SUB_MeleeDamage (8);
    if (IsHellHound ())
        ldmg = ldmg + 5;    // Hell hounds cause more damage.
    T_Damage (self.enemy, self, self, ldmg);
};

void() Dog_JumpTouch =
{
    local    float    ldmg;

    if (self.health <= 0)
        return;
        
    if (other.takedamage)
    {
        if ( vlen(self.velocity) > 300 )
        {
            if (IsHellHound ())
                ldmg = 20 + 10*random();
            else
                ldmg = 10 + 10*random();
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
            self.think = dog_leap1;
            self.nextthink = time + 0.1;
        }
        return;    // not on ground yet
    }

    self.touch = SUB_Null;
    self.think = dog_run1;
    self.nextthink = time + 0.1;
};


// STAND - - - - - - - - - - - - - - - -
void() dog_stand1 =[ $stand1,  dog_stand2 ] {ai_stand();};
void() dog_stand2 =[ $stand2,  dog_stand3 ] {ai_stand();};
void() dog_stand3 =[ $stand3,  dog_stand4 ] {ai_stand();};
void() dog_stand4 =[ $stand4,  dog_stand5 ] {ai_stand();};
void() dog_stand5 =[ $stand5,  dog_stand6 ] {ai_stand();};
void() dog_stand6 =[ $stand6,  dog_stand7 ] {ai_stand();};
void() dog_stand7 =[ $stand7,  dog_stand8 ] {ai_stand();};
void() dog_stand8 =[ $stand8,  dog_stand9 ] {ai_stand();};
void() dog_stand9 =[ $stand9,  dog_stand1 ] {ai_stand();};

// WALK - - - - - - - - - - - - - - - -
void() dog_walk1  =[ $walk1,   dog_walk2  ] {
if (random() < 0.2)
    sound (self, CHAN_VOICE, "dog/idle.wav", 1, ATTN_IDLE);
ai_walk(8);};
void() dog_walk2  =[ $walk2,   dog_walk3  ] {ai_walk(8);};
void() dog_walk3  =[ $walk3,   dog_walk4  ] {ai_walk(8);};
void() dog_walk4  =[ $walk4,   dog_walk5  ] {ai_walk(8);};
void() dog_walk5  =[ $walk5,   dog_walk6  ] {ai_walk(8);};
void() dog_walk6  =[ $walk6,   dog_walk7  ] {ai_walk(8);};
void() dog_walk7  =[ $walk7,   dog_walk8  ] {ai_walk(8);};
void() dog_walk8  =[ $walk8,   dog_walk1  ] {ai_walk(8);};

// RUN - - - - - - - - - - - - - - - - -
void() dog_run1   =[ $run1,    dog_run2   ] {
if (random() < 0.2)
    sound (self, CHAN_VOICE, "dog/idle.wav", 1, ATTN_IDLE);
ai_run(16);};
void() dog_run2   =[ $run2,    dog_run3   ] {ai_run(32);};
void() dog_run3   =[ $run3,    dog_run4   ] {ai_run(32);};
void() dog_run4   =[ $run4,    dog_run5   ] {ai_run(20);};
void() dog_run5   =[ $run5,    dog_run6   ] {ai_run(64);};
void() dog_run6   =[ $run6,    dog_run7   ] {ai_run(32);};
void() dog_run7   =[ $run7,    dog_run8   ] {ai_run(16);};
void() dog_run8   =[ $run8,    dog_run9   ] {ai_run(32);};
void() dog_run9   =[ $run9,    dog_run10  ] {ai_run(32);};
void() dog_run10  =[ $run10,   dog_run11  ] {ai_run(20);};
void() dog_run11  =[ $run11,   dog_run12  ] {ai_run(64);};
void() dog_run12  =[ $run12,   dog_run1   ] {ai_run(32);};

// ATTACK - - - - - - - - - - - - - - -
void(vector st) Dog_Fire =
{
    local   vector  dir;
    local   vector  spot;

    makevectors (self.angles);
    spot = self.origin + v_forward*st_x + v_right*st_y + v_up*st_z;
    dir = Maim_Line (spot, self.enemy.origin, 1000, world, '1.2 0.9 0');
    Ryu_Fire (spot, dir, 1000, 0, 0);
};

void() dog_fire1  =[ $attack1, dog_fire2  ] {ai_face();};
void() dog_fire2  =[ $attack3, dog_fire3  ] {ai_face();
    sound (self, CHAN_WEAPON, "dragon/fire.wav", 1, ATTN_NORM);
    Dog_Fire('25 2 6');};
void() dog_fire3  =[ $attack3, dog_fire4  ] {ai_face(); Dog_Fire('25 2 6');};
void() dog_fire4  =[ $attack2, dog_fire5  ] {ai_face(); Dog_Fire('25 2 2');};
void() dog_fire5  =[ $attack1, dog_run1   ] {ai_face();};

void() dog_fast1  =[ $attack2, dog_fast2  ] {ai_charge(10);};
void() dog_fast2  =[ $attack4, dog_fast3  ] {sound (self, CHAN_VOICE, "dog/dattack1.wav", 1, ATTN_NORM);dog_bite();};
void() dog_fast3  =[ $attack5, dog_fast4  ] {ai_charge(10);};
void() dog_fast4  =[ $attack6, dog_fast5  ] {ai_charge(10);};
void() dog_fast5  =[ $attack7, dog_fast6  ] {ai_charge(10);};
void() dog_fast6  =[ $attack8, dog_run1   ] {ai_charge(10);};

void() dog_atta1  =[ $attack1, dog_atta2  ] {ai_charge(10);};
void() dog_atta2  =[ $attack2, dog_atta3  ] {ai_charge(10);};
void() dog_atta3  =[ $attack3, dog_atta4  ] {ai_charge(10);};
void() dog_atta4  =[ $attack4, dog_atta5  ] {sound (self, CHAN_VOICE, "dog/dattack1.wav", 1, ATTN_NORM);dog_bite();};
void() dog_atta5  =[ $attack5, dog_atta6  ] {ai_charge(10);};
void() dog_atta6  =[ $attack6, dog_atta7  ] {ai_charge(10);};
void() dog_atta7  =[ $attack7, dog_atta8  ] {ai_charge(10);};
void() dog_atta8  =[ $attack8, dog_run1   ] {ai_charge(10);};

void() dog_leap1  =[ $leap1,   dog_leap2  ] {ai_face();};
void() dog_leap2  =[ $leap2,   dog_leap3  ]
{
    ai_face();
    ai_dizzy();
    
    self.touch      = Dog_JumpTouch;
    makevectors (self.angles);
// DISABLED:  Don't need +1 to z, do we?
//    self.origin_z   = self.origin_z + 1;
    // PM:  Could speed up dog if cranked, but that may not be a good idea.
    // Note:  Hell hounds are trained in gravity, but not normal dogs.
    if (IsHellHound ())
        self.velocity   = v_forward * 600 + ('0 0 200' * Gs());
    else
        self.velocity   = v_forward * 300 + '0 0 200';
    self.flags      = self.flags - (self.flags & FL_ONGROUND);
};
void() dog_leap3  =[ $leap3,   dog_leap4  ] {};
void() dog_leap4  =[ $leap4,   dog_leap5  ] {};
void() dog_leap5  =[ $leap5,   dog_leap6  ] {};
void() dog_leap6  =[ $leap6,   dog_leap7  ] {};
void() dog_leap7  =[ $leap7,   dog_leap8  ] {};
void() dog_leap8  =[ $leap8,   dog_leap9  ] {};
//void() dog_leap9  =[ $leap9,   SUB_Null   ] {};
// PM:  Copied demon code so if dog gets stuck, make it jump.
void() dog_leap9  =[ $leap9,   dog_leap1  ]
{
    self.nextthink = time + 3;
    // If three seconds pass, assume demon is stuck and jump again.
};

// Hell hounds' missile function.
void() dog_missile =
{
    if (vlen(self.enemy.origin - self.origin) < 200)
        dog_leap1 ();
    else
        dog_fire1 ();
};

// PAIN - - - - - - - - - - - - - - - -
void() dog_pain1   =[ $pain1,   dog_pain2   ] {};
void() dog_pain2   =[ $pain2,   dog_pain3   ] {};
void() dog_pain3   =[ $pain3,   dog_pain4   ] {};
void() dog_pain4   =[ $pain4,   dog_pain5   ] {};
void() dog_pain5   =[ $pain5,   dog_pain6   ] {};
void() dog_pain6   =[ $pain6,   dog_run1    ] {};

void() dog_painb1  =[ $painb1,  dog_painb2  ] {};
void() dog_painb2  =[ $painb2,  dog_painb3  ] {};
void() dog_painb3  =[ $painb3,  dog_painb4  ] {ai_back(4);};
void() dog_painb4  =[ $painb4,  dog_painb5  ] {ai_back(12);};
void() dog_painb5  =[ $painb5,  dog_painb6  ] {ai_back(12);};
void() dog_painb6  =[ $painb6,  dog_painb7  ] {ai_back(2);};
void() dog_painb7  =[ $painb7,  dog_painb8  ] {};
void() dog_painb8  =[ $painb8,  dog_painb9  ] {ai_back(4);};
void() dog_painb9  =[ $painb9,  dog_painb10 ] {};
void() dog_painb10 =[ $painb10, dog_painb11 ] {ai_back(10);};
void() dog_painb11 =[ $painb11, dog_painb12 ] {};
void() dog_painb12 =[ $painb12, dog_painb13 ] {};
void() dog_painb13 =[ $painb13, dog_painb14 ] {};
void() dog_painb14 =[ $painb14, dog_painb15 ] {};
void() dog_painb15 =[ $painb15, dog_painb16 ] {};
void() dog_painb16 =[ $painb16, dog_run1    ] {};

void() dog_pain =
{
    if (self.pain_finished > time)
        return;

    sound (self, CHAN_VOICE, "dog/dpain1.wav", 1, ATTN_NORM);

    if (IsHellHound ())
        self.pain_finished = time + 1;
    else
        self.pain_finished = time + 0.5;
    if (SUB_IgnorePain ())
        return;

    if ((random() > 0.5) || (skill >= 3))
        dog_pain1 ();
    else if (self.health < 50)    // PM:  New check for tougher dog variants.
    {
        self.pain_finished = time + 1.5;
        dog_painb1 ();
    }
};

// DEATH - - - - - - - - - - - - - - - -
void() dog_decap1  =[ $decap1,   dog_decap2    ] {monster_drop(); blood_spray ('11 2 4', 1);};
void() dog_decap2  =[ $decap2,   dog_decap3    ] {blood_spray ('13 2 4', 2);};
void() dog_decap3  =[ $decap3,   dog_decap4    ] {blood_spray ('11 3 6', 1);};
void() dog_decap4  =[ $decap4,   dog_decap5    ] {blood_spray ('11 3 5', 1);};
void() dog_decap5  =[ $decap5,   dog_decap6    ] {};  //blood_spray ('12 3 0', -1);};
void() dog_decap6  =[ $decap6,   dog_decap7    ] {};
void() dog_decap7  =[ $decap7,   dog_decap8    ] {};
void() dog_decap8  =[ $decap8,   dog_decap9    ] {};
void() dog_decap9  =[ $decap9,   decap_end     ] {};

void() dog_decapb1  =[ $decapb1,   dog_decapb2    ] {monster_drop(); blood_spray ('9 7 2', 1);};
void() dog_decapb2  =[ $decapb2,   dog_decapb3    ] {blood_spray ('8 7 3', 2);};
void() dog_decapb3  =[ $decapb3,   dog_decapb4    ] {blood_spray ('6 11 4', 2);};
void() dog_decapb4  =[ $decapb4,   dog_decapb5    ] {}; //blood_spray ('3 13 0', 1);};
void() dog_decapb5  =[ $decapb5,   dog_decapb6    ] {}; //blood_spray ('0 14 -8', 1);};
void() dog_decapb6  =[ $decapb6,   dog_decapb7    ] {};
void() dog_decapb7  =[ $decapb7,   dog_decapb8    ] {};
void() dog_decapb8  =[ $decapb8,   dog_decapb9    ] {};
void() dog_decapb9  =[ $decapb9,   decap_end      ] {};

void() dog_die1  =[ $death1,   dog_die2    ] {};
void() dog_die2  =[ $death2,   dog_die3    ] {};
void() dog_die3  =[ $death3,   dog_die4    ] {};
void() dog_die4  =[ $death4,   dog_die5    ] {};
void() dog_die5  =[ $death5,   dog_die6    ] {};
void() dog_die6  =[ $death6,   dog_die7    ] {};
void() dog_die7  =[ $death7,   dog_die8    ] {};
void() dog_die8  =[ $death8,   dog_die9    ] {};
void() dog_die9  =[ $death9,   monster_end ] {};

void() dog_dieb1 =[ $deathb1,  dog_dieb2   ] {};
void() dog_dieb2 =[ $deathb2,  dog_dieb3   ] {};
void() dog_dieb3 =[ $deathb3,  dog_dieb4   ] {};
void() dog_dieb4 =[ $deathb4,  dog_dieb5   ] {};
void() dog_dieb5 =[ $deathb5,  dog_dieb6   ] {};
void() dog_dieb6 =[ $deathb6,  dog_dieb7   ] {};
void() dog_dieb7 =[ $deathb7,  dog_dieb8   ] {};
void() dog_dieb8 =[ $deathb8,  dog_dieb9   ] {};
void() dog_dieb9 =[ $deathb9,  monster_end ] {};

float(float dm) dog_gib =
{
// check for gib
    if (self.health < self.gib_health)
    {
        sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
        ThrowGib ("progs/gib3.mdl", dm);
        ThrowGib ("progs/gib3.mdl", dm);
        ThrowGib ("progs/gib3.mdl", dm);
        ThrowHead ("progs/h_dog.mdl", dm);
        return TRUE;
    }
    return FALSE;
};
void() dog_die =
{
    if (Shattered ())
        return;
    if (Decapitated ())
    {
        if (random() < 0.5)
            monster_decap ('13 2 4', dog_decap1);
        else
            monster_decap ('9 7 2', dog_decapb1);
        newmis.th_die = ogre_body;      // They share the same gibs.
        return;
    }
// check for gib
    if (dog_gib (self.health))
        return;

// regular death
    sound (self, CHAN_VOICE, "dog/ddeath.wav", 1, ATTN_NORM);
    monster_drop ();

    if (random() > 0.5)
        dog_die1 ();
    else
        dog_dieb1 ();
};

// REVIVE - - - - - - - - - - - - - - -
void() dog_revive1  =[ $death8,   dog_revive2  ] {};
void() dog_revive2  =[ $death7,   dog_revive3  ] {};
void() dog_revive3  =[ $death6,   dog_revive4  ] {};
void() dog_revive4  =[ $death5,   dog_revive5  ] {};
void() dog_revive5  =[ $death4,   dog_revive6  ] {};
void() dog_revive6  =[ $death3,   dog_pain3    ] {};

void() dog_reviveb1 =[ $deathb8,  dog_reviveb2 ] {};
void() dog_reviveb2 =[ $deathb7,  dog_painb5   ] {};

void() dog_revive =
{
    if ( self.frame == $deathb9 )
        dog_reviveb1 ();
    else
        dog_revive1 ();
};


//===========================================================================

// OTHER - - - - - - - - - - - - - - - -
void(float hello) dog_sight =
{
    if (hello)
    {
        if (random() < 0.5)
            sound (self, CHAN_VOICE, "dog/dattack1.wav", 1, ATTN_NORM); //Arf!
        else
            sound (self, CHAN_VOICE, "dog/idle.wav", 1, ATTN_NORM);
    }
    else
        sound (self, CHAN_VOICE, "dog/dsight.wav", 1, ATTN_NORM);
};

// FIXME:  Hell hound should have different, more sinister sounds.
void() dog_cache =
{
    precache_model ("progs/h_dog.mdl");
    precache_model ("progs/dog.mdl");

    precache_sound ("dragon/fire.wav");
    precache_sound ("dragon/firehit.wav");
    precache_sound ("dog/dattack1.wav");
    precache_sound ("dog/ddeath.wav");
    precache_sound ("dog/dpain1.wav");
    precache_sound ("dog/dsight.wav");
    precache_sound ("dog/idle.wav");
};

//============
// QUAKED monster_dog (1 0 0) (-32 -32 -24) (32 32 40) Ambush
//============
void() monster_dog;

void() monster_hell_hound =
{
    self.skin = 2;
    self.classname = "monster_dog";
    monster_dog ();
};

void() monster_dog =
{
    if (!self.spawned)
    {
        if (noenemies)
            {remove (self); return;}
        dog_cache ();
// FIXME:  Hell hound should have different, more sinister sounds.
    }

    local   float   hp;
    local   float   evil;

    if (!respawning)
    {
        if (soul_evil)
        {   // Reverse skins in SoE.
            if (!self.skin)
                self.skin = 1;
            else if (self.skin == 1)
                self.skin = 0;
        }
    }
    evil = IsHellHound ();
    if (evil)
    {   self.th_spawn   = monster_hell_hound;
        hp = 150;   // Hell Hound
    }
    else
    {   self.th_spawn   = monster_dog;
        hp = 25;    // Normal Rottweiler
    }
    monster_form ("progs/dog.mdl", '-32 -32 -24', '32 32 40', hp, -35);
    self.mdl_head   = "progs/h_dog.mdl";
    self.mass       = MASS_LIGHT;

    self.th_stand   = dog_stand1;
    self.th_walk    = dog_walk1;
    self.th_run     = dog_run1;
    if (evil)
        self.th_missile = dog_missile;
    else
        self.th_missile = dog_leap1;
    if (cranked)
        self.th_melee   = dog_fast1;    // PM:  Quicker bite anim.
    else
        self.th_melee   = dog_atta1;
    self.th_pain    = dog_pain;
    self.th_die     = dog_die;
    //- - - - - - - -
    self.th_check   = DogCheckAttack;
    self.th_sight   = dog_sight;
    self.th_gib     = dog_gib;
    self.th_revive  = dog_revive;

    if (soul_evil)
        monster_purse (1, 0.05, 0);     // 5% of coin in the stomach.

    monster_start ();
};


//===========================/  END OF FILE  /===========================//
