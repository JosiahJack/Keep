/*
==============================================================================

KNIGHT

==============================================================================
*/

$cd id1/models/knight
$origin 0 0 24
$base base
$skin badass3

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9

$frame runb1 runb2 runb3 runb4 runb5 runb6 runb7 runb8

$frame runattack1 runattack2 runattack3 runattack4 runattack5
$frame runattack6 runattack7 runattack8 runattack9 runattack10
$frame runattack11

$frame pain1 pain2 pain3

$frame painb1 painb2 painb3 painb4 painb5 painb6 painb7 painb8 painb9
$frame painb10 painb11

$frame attackb1 attackb1 attackb2 attackb3 attackb4 attackb5
$frame attackb6 attackb7 attackb8 attackb9 attackb10

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9
$frame walk10 walk11 walk12 walk13 walk14

$frame kneel1 kneel2 kneel3 kneel4 kneel5

$frame standing2 standing3 standing4 standing5

$frame death1 death2 death3 death4 death5 death6 death7 death8
$frame death9 death10

$frame deathb1 deathb2 deathb3 deathb4 deathb5 deathb6 deathb7 deathb8
$frame deathb9 deathb10 deathb11

$frame decap1 decap2 decap3 decap4 decap5 decap6 decap7 decap8 decap9 decap10

$frame decapb1 decapb2 decapb3 decapb4 decapb5 decapb6 decapb7 decapb8
$frame decapb9 decapb10 decapb11

$frame decapc1 decapc2 decapc3 decapc4 decapc5

//==========================================================================
// New scenes on modified knight.  Shamelessly ripped from Qtest.
//$frame run1 run2 run3 run4 run5 run6 run7 run8 run9 run10 run11

//$frame attack1 attack2 attack3 attack4 attack5 attack6 attack7
//$frame attack8 attack9 attack10 attack11

//$frame jump1 jump2 jump3 jump4 jump5

//$frame deathc1 deathc2 deathc3 deathc4 deathc5
//==========================================================================

//=============
// ai_melee
//
// Melee attack with a sword.  Used by knights and hell knights.
// Update 9/2/09:  Used by several other custom monsters.
//=============
void() ai_melee =
{
    local   float   ldmg;

    if (!self.enemy)
        return;        // removed before stroke

    if (!CanDamage (self.enemy, self))      // PM:  Added just in case.
        return;
    if (!InMeleeRange (60))     // PM:  Dragons-related.
        return;
    if (IsGhost (self.enemy))   // PM:  Not allowed to hit wraith.
      if (!(self.enemy.xf2 & XF2_CLONE))  // Nsoe1 hack.
        return;

//- - - - - - - - -
//    if (cranked)
//        if (self.classname == "monster_spider")
//            Poison_Add (self.enemy, 0.2);
//- - - - - - - - -
    ldmg = SUB_MeleeDamage (3);
    // Use expanded damage function for hell knight obituary.
    T_NewDamage (self.enemy, self, self, ldmg, 0, "melee");
};

void() ai_melee_side =
{
    if (self.enemy)
        {ai_charge_side(); ai_melee();}     // Move then swing.
};


//==========================================================================

void() knight_sword_sound =
{
    if (random() > 0.5)
        sound (self, CHAN_WEAPON, "knight/sword2.wav", 1, ATTN_NORM);
    else
        sound (self, CHAN_WEAPON, "knight/sword1.wav", 1, ATTN_NORM);
};

// WIN - - - - - - - - - - - - - - - - -
// Update:  Kneeling is used as a victory dance.  Worked for Tekken.
void() knight_bow1  =[ $kneel1,  knight_bow2  ] {ai_turn();};
void() knight_bow2  =[ $kneel2,  knight_bow3  ] {ai_turn();};
void() knight_bow3  =[ $kneel3,  knight_bow4  ] {ai_turn();};
void() knight_bow4  =[ $kneel4,  knight_bow5  ] {
    self.height = (random() * 4 & 3) + 6;
    ai_turn();
};
void() knight_bow5  =[ $kneel5,  knight_bow6  ] {
    if (self.height > 0)
        {self.height = self.height - 1;  self.think = knight_bow5;}
    ai_turn();
};
void() knight_bow6  =[ $kneel4,  knight_bow7  ] {ai_turn();};
void() knight_bow7  =[ $kneel3,  knight_bow8  ] {ai_turn();};
void() knight_bow8  =[ $kneel2,  knight_bow9  ] {ai_turn();};
void() knight_bow9  =[ $kneel1,  monster_sow  ] {ai_turn();};

// STAND - - - - - - - - - - - - - - - -
void() knight_stand1 =[ $stand1,  knight_stand2 ] {ai_stand();};
void() knight_stand2 =[ $stand2,  knight_stand3 ] {ai_stand();};
void() knight_stand3 =[ $stand3,  knight_stand4 ] {ai_stand();};
void() knight_stand4 =[ $stand4,  knight_stand5 ] {ai_stand();};
void() knight_stand5 =[ $stand5,  knight_stand6 ] {ai_stand();};
void() knight_stand6 =[ $stand6,  knight_stand7 ] {ai_stand();};
void() knight_stand7 =[ $stand7,  knight_stand8 ] {ai_stand();};
void() knight_stand8 =[ $stand8,  knight_stand9 ] {ai_stand();};
void() knight_stand9 =[ $stand9,  knight_stand1 ] {ai_stand();};

// WALK - - - - - - - - - - - - - - - -
void() knight_walk1  =[ $walk1,   knight_walk2  ] {
if (random() < 0.2)
    sound (self, CHAN_VOICE, "knight/idle.wav", 1,  ATTN_IDLE);
ai_walk(3);};
void() knight_walk2  =[ $walk2,   knight_walk3  ] {ai_walk(2);};
void() knight_walk3  =[ $walk3,   knight_walk4  ] {ai_walk(3);};
void() knight_walk4  =[ $walk4,   knight_walk5  ] {M_Step(); ai_walk(4);};
void() knight_walk5  =[ $walk5,   knight_walk6  ] {ai_walk(3);};
void() knight_walk6  =[ $walk6,   knight_walk7  ] {ai_walk(3);};
void() knight_walk7  =[ $walk7,   knight_walk8  ] {ai_walk(3);};
void() knight_walk8  =[ $walk8,   knight_walk9  ] {ai_walk(4);};
void() knight_walk9  =[ $walk9,   knight_walk10 ] {ai_walk(3);};
void() knight_walk10 =[ $walk10,  knight_walk11 ] {ai_walk(3);};
void() knight_walk11 =[ $walk11,  knight_walk12 ] {M_Step(); ai_walk(2);};
void() knight_walk12 =[ $walk12,  knight_walk13 ] {ai_walk(3);};
void() knight_walk13 =[ $walk13,  knight_walk14 ] {ai_walk(4);};
void() knight_walk14 =[ $walk14,  knight_walk1  ] {ai_walk(3);};

// RUN - - - - - - - - - - - - - - - -
void(float d) knight_run = {if (cranked) d = floor(d * 1.5);  ai_run(d);};

void() knight_run1   =[ $runb1,   knight_run2   ] {
if (random() < 0.2)
    sound (self, CHAN_VOICE, "knight/idle.wav", 1,  ATTN_IDLE);
knight_run(16);};
void() knight_run2   =[ $runb2,   knight_run3   ] {M_Step(); knight_run(20);};
void() knight_run3   =[ $runb3,   knight_run4   ] {knight_run(13);};
void() knight_run4   =[ $runb4,   knight_run5   ] {knight_run(7);};
void() knight_run5   =[ $runb5,   knight_run6   ] {knight_run(16);};
void() knight_run6   =[ $runb6,   knight_run7   ] {M_Step(); knight_run(20);};
void() knight_run7   =[ $runb7,   knight_run8   ] {knight_run(14);};
void() knight_run8   =[ $runb8,   knight_run1   ] {knight_run(6);};

// ATTACK - - - - - - - - - - - - - - -
void() knight_runatk1   =[ $runattack1,  knight_runatk2  ] {knight_sword_sound(); ai_charge(20);};
void() knight_runatk2   =[ $runattack2,  knight_runatk3  ] {ai_charge_side();};
void() knight_runatk3   =[ $runattack3,  knight_runatk4  ] {M_Step(); ai_charge_side();};
void() knight_runatk4   =[ $runattack4,  knight_runatk5  ] {ai_charge_side();};
void() knight_runatk5   =[ $runattack5,  knight_runatk6  ] {ai_melee_side();};
void() knight_runatk6   =[ $runattack6,  knight_runatk7  ] {M_Step(); ai_melee_side();};
void() knight_runatk7   =[ $runattack7,  knight_runatk8  ] {ai_melee_side();};
void() knight_runatk8   =[ $runattack8,  knight_runatk9  ] {ai_melee_side();};
void() knight_runatk9   =[ $runattack9,  knight_runatk10 ] {ai_melee_side();};
void() knight_runatk10  =[ $runattack10, knight_runatk11 ] {ai_charge_side();};
void() knight_runatk11  =[ $runattack11, knight_run1     ] {ai_charge(10);};

void() knight_atk1  =[ $attackb1,  knight_atk2  ] {sound (self, CHAN_WEAPON, "knight/sword1.wav", 1, ATTN_NORM); ai_charge(0);};
void() knight_atk2  =[ $attackb2,  knight_atk3  ] {ai_charge(7);};
void() knight_atk3  =[ $attackb3,  knight_atk4  ] {ai_charge(4);};
void() knight_atk4  =[ $attackb4,  knight_atk5  ] {ai_charge(0);};
void() knight_atk5  =[ $attackb5,  knight_atk6  ] {ai_charge(3);};
void() knight_atk6  =[ $attackb6,  knight_atk7  ] {ai_charge(4); ai_melee();};
void() knight_atk7  =[ $attackb7,  knight_atk8  ] {ai_charge(1); ai_melee();};
void() knight_atk8  =[ $attackb8,  knight_atk9  ] {ai_charge(3); ai_melee();};
void() knight_atk9  =[ $attackb9,  knight_atk10 ] {ai_charge(1);};
void() knight_atk10 =[ $attackb10, knight_run1  ] {ai_charge(5);};

//- - - - - - - - -
// Quickened attack for cranked knights.
void() knight_fast1  =[ $attackb1,  knight_fast2  ] {sound (self, CHAN_WEAPON, "knight/sword1.wav", 1, ATTN_NORM); ai_charge(0);};
void() knight_fast2  =[ $attackb2,  knight_fast3  ] {ai_charge(7);};
void() knight_fast3  =[ $attackb5,  knight_fast4  ] {ai_charge(7);};
void() knight_fast4  =[ $attackb6,  knight_fast5  ] {ai_charge(1); ai_melee();};
void() knight_fast5  =[ $attackb7,  knight_fast6  ] {ai_charge(3); ai_melee();};
void() knight_fast6  =[ $attackb9,  knight_fast7  ] {ai_charge(1); ai_melee();};
void() knight_fast7  =[ $attackb10, knight_run1   ] {ai_charge(5);};
//- - - - - - - - -

void() knight_attack =
{
    local   float   len;
    
// decide if now is a good swing time
    len = vlen(self.enemy.origin+self.enemy.view_ofs - (self.origin+self.view_ofs));
    
    if (len<80)
    {
        if (SUB_QuickAttack ())
            knight_fast1 ();
        else if (self.classname == "monster_warrior")
            knight_fast1 ();    // SoE:  These guys are a bit more experienced.
        else
            knight_atk1 ();
    }
    else
        knight_runatk1 ();
};

// PAIN - - - - - - - - - - - - - - - -
void() knight_pain1   =[ $pain1,   knight_pain2   ] {};
void() knight_pain2   =[ $pain2,   knight_pain3   ] {};
void() knight_pain3   =[ $pain3,   knight_run1    ] {};

void() knight_painb1  =[ $painb1,  knight_painb2  ] {};//ai_forward(0);};
void() knight_painb2  =[ $painb2,  knight_painb3  ] {ai_forward(3);};
void() knight_painb3  =[ $painb3,  knight_painb4  ] {};
void() knight_painb4  =[ $painb4,  knight_painb5  ] {};
void() knight_painb5  =[ $painb5,  knight_painb6  ] {ai_forward(2);};
void() knight_painb6  =[ $painb6,  knight_painb7  ] {ai_forward(4);};
void() knight_painb7  =[ $painb7,  knight_painb8  ] {ai_forward(2);};
void() knight_painb8  =[ $painb8,  knight_painb9  ] {ai_forward(5);};
void() knight_painb9  =[ $painb9,  knight_painb10 ] {ai_forward(5);};
void() knight_painb10 =[ $painb10, knight_painb11 ] {};//ai_forward(0);};
void() knight_painb11 =[ $painb11, knight_run1    ] {};

void(entity attacker, float damage) knight_pain =
{
    if (self.pain_finished > time)
        return;

    sound (self, CHAN_VOICE, "knight/khurt.wav", 1, ATTN_NORM);
    self.pain_finished = time + 1;

    if (SUB_IgnorePain ())
        return;     // No pain anims in Nightmare.

    if ((random() < 0.85) || (skill >= 3))
        knight_pain1 ();
    else
        knight_painb1 ();
    attacker = attacker;    // FrikQcc warning squelch!
    damage = damage;
};

// DEATH - - - - - - - - - - - - - - - -
void() knight_decap1  =[ $decap1,   knight_decap2  ] {blood_spray('-8 -3 16', 1);};
void() knight_decap2  =[ $decap2,   knight_decap3  ] {blood_spray('-15 -5 12', 2);};
void() knight_decap3  =[ $decap3,   knight_decap4  ] {blood_spray('-17 -3 6', 2); monster_drop();};
void() knight_decap4  =[ $decap4,   knight_decap5  ] {};
void() knight_decap5  =[ $decap5,   knight_decap6  ] {};
void() knight_decap6  =[ $decap6,   knight_decap7  ] {};
void() knight_decap7  =[ $decap7,   knight_decap8  ] {};
void() knight_decap8  =[ $decap8,   knight_decap9  ] {};
void() knight_decap9  =[ $decap9,   knight_decap10 ] {};
void() knight_decap10 =[ $decap10,  decap_end      ] {};

void() knight_decapb1  =[ $decapb1,   knight_decapb2  ] {blood_spray('-4 2 19', 1);};
void() knight_decapb2  =[ $decapb2,   knight_decapb3  ] {blood_spray('-4 2 16', 2);};
void() knight_decapb3  =[ $decapb3,   knight_decapb4  ] {blood_spray('-4 2 9', 1); monster_drop();};
void() knight_decapb4  =[ $decapb4,   knight_decapb5  ] {};
void() knight_decapb5  =[ $decapb5,   knight_decapb6  ] {};
void() knight_decapb6  =[ $decapb6,   knight_decapb7  ] {};
void() knight_decapb7  =[ $decapb7,   knight_decapb8  ] {blood_spray('12 4 3', -1);};
void() knight_decapb8  =[ $decapb8,   knight_decapb9  ] {};
void() knight_decapb9  =[ $decapb9,   knight_decapb10 ] {};
void() knight_decapb10 =[ $decapb10,  knight_decapb11 ] {};
void() knight_decapb11 =[ $decapb11,  decap_end       ] {};

void() knight_decapc1  =[ $decapc1,   knight_decapc2  ] {blood_spray('-3 -3 21', 1);};
void() knight_decapc2  =[ $decapc2,   knight_decapc3  ] {blood_spray('-11 -1 17', 2);};
void() knight_decapc3  =[ $decapc3,   knight_decapc4  ] {blood_spray('-13 -1 10', 2); monster_drop();};
void() knight_decapc4  =[ $decapc4,   knight_decapc5  ] {};
void() knight_decapc5  =[ $decapc5,   decap_end       ] {};

void() knight_die1   =[ $death1,    knight_die2   ] {};
void() knight_die2   =[ $death2,    knight_die3   ] {};
void() knight_die3   =[ $death3,    knight_die4   ] {monster_drop();};
void() knight_die4   =[ $death4,    knight_die5   ] {};
void() knight_die5   =[ $death5,    knight_die6   ] {};
void() knight_die6   =[ $death6,    knight_die7   ] {};
void() knight_die7   =[ $death7,    knight_die8   ] {};
void() knight_die8   =[ $death8,    knight_die9   ] {};
void() knight_die9   =[ $death9,    knight_die10  ] {};
void() knight_die10  =[ $death10,   monster_end   ] {};

void() knight_dieb1  =[ $deathb1,   knight_dieb2  ] {};
void() knight_dieb2  =[ $deathb2,   knight_dieb3  ] {};
void() knight_dieb3  =[ $deathb3,   knight_dieb4  ] {monster_drop();};
void() knight_dieb4  =[ $deathb4,   knight_dieb5  ] {};
void() knight_dieb5  =[ $deathb5,   knight_dieb6  ] {};
void() knight_dieb6  =[ $deathb6,   knight_dieb7  ] {};
void() knight_dieb7  =[ $deathb7,   knight_dieb8  ] {};
void() knight_dieb8  =[ $deathb8,   knight_dieb9  ] {};
void() knight_dieb9  =[ $deathb9,   knight_dieb10 ] {};
void() knight_dieb10 =[ $deathb10,  knight_dieb11 ] {};
void() knight_dieb11 =[ $deathb11,  monster_end   ] {};

float(float dm) knight_gib =
{
    if (self.health < self.gib_health)
    {
        sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
        ThrowGib ("progs/gib1.mdl", dm);
        ThrowGib ("progs/gib2.mdl", dm);
        ThrowGib ("progs/gib3.mdl", dm);
        ThrowHead ("progs/h_knight.mdl", dm);
        return TRUE;
    }
    return FALSE;
};

void() knight_die =
{
//- - - - -
    if (Shattered ())
        return;
    if (Decapitated ())
    {
        local   float   r;

        r = random();
        if (r < 0.25)
            monster_decap ('-8 -3 16', knight_decap1);
        else if (r < 0.5)
            monster_decap ('-4 2 19', knight_decapb1);
        else
            monster_decap ('-3 -3 21', knight_decapc1);
        return;
    }
//- - - - -
// check for gib
    if (knight_gib (self.health))
        return;

// regular death
    sound (self, CHAN_VOICE, "knight/kdeath.wav", 1, ATTN_NORM);
    if (random() < 0.5)
        knight_die1 ();
    else
        knight_dieb1 ();
};

// REVIVE - - - - - - - - - - - - - - -
void() knight_revive1   =[ $death9,    knight_revive2   ] {};
void() knight_revive2   =[ $death8,    knight_revive3   ] {};
void() knight_revive3   =[ $death7,    knight_revive4   ] {};
void() knight_revive4   =[ $death6,    knight_revive5   ] {};
void() knight_revive5   =[ $death5,    knight_revive6   ] {};
void() knight_revive6   =[ $death4,    knight_revive7   ] {};
void() knight_revive7   =[ $death3,    knight_revive8   ] {};
void() knight_revive8   =[ $death2,    knight_revive9   ] {};
void() knight_revive9   =[ $death1,    knight_run1      ] {};

void() knight_reviveb1  =[ $deathb10,  knight_reviveb2  ] {};
void() knight_reviveb2  =[ $deathb9,   knight_reviveb3  ] {};
void() knight_reviveb3  =[ $deathb8,   knight_reviveb4  ] {};
void() knight_reviveb4  =[ $deathb7,   knight_reviveb5  ] {};
void() knight_reviveb5  =[ $deathb6,   knight_reviveb6  ] {};
void() knight_reviveb6  =[ $deathb5,   knight_reviveb7  ] {};
void() knight_reviveb7  =[ $deathb4,   knight_reviveb8  ] {};
void() knight_reviveb8  =[ $deathb3,   knight_reviveb9  ] {};
void() knight_reviveb9  =[ $deathb2,   knight_reviveb10 ] {};
void() knight_reviveb10 =[ $deathb1,   knight_reviveb11 ] {};
void() knight_reviveb11 =[ $standing2, knight_run1      ] {};

void() knight_revive =
{
    if ( self.frame == $deathb11 )
        knight_reviveb1 ();
    else //if ( self.frame == $death10 )
        knight_revive1 ();
};

//===========================================================================

// OTHER - - - - - - - - - - - - - - - -
void(float hello) knight_sight =
{
    if (hello)
        sound (self, CHAN_VOICE, "knight/idle.wav", 1, ATTN_NORM);
    else
        sound (self, CHAN_VOICE, "knight/ksight.wav", 1, ATTN_NORM);
};

void() knight_cache =
{
    precache_model ("progs/knight.mdl");
    precache_model ("progs/h_knight.mdl");

    precache_sound ("knight/kdeath.wav");
    precache_sound ("knight/khurt.wav");
    precache_sound ("knight/ksight.wav");
    precache_sound ("knight/sword1.wav");
    precache_sound ("knight/sword2.wav");
    precache_sound ("knight/idle.wav");
//    precache_sound ("weapons/clang.wav");
};

//============
// --> QUAKED monster_knight (1 0 0) (-16 -16 -24) (16 16 40) Ambush Warrior
//============
void() monster_knight;

void() monster_warrior = {self.skin = 1;  monster_knight();};

void() monster_knight =
{
    if (!self.spawned)
    {
        if (noenemies)
            {remove(self); return;}
//- - - - - - - - -
// SoE Indian Summer hack.
        if (soul_evil)
            if (world.model == "maps/nsoe1.bsp")
                {remove(self); return;}   // Lone knight at start is annoying.
//- - - - - - - - -
        knight_cache ();
    }

    if (!respawning)
    {
        if (soul_evil)
        {   // SoE:  sf 1 upgrades, sf 2 is ambush.
            if (self.spawnflags & 1)
            {
                self.spawnflags = self.spawnflags - 1;
                self.skin = 1;
            }
            if (self.spawnflags & 2)
                self.spawnflags = (self.spawnflags - 2) | 1;
        }
        else
        {
            if (self.spawnflags & 2)
                self.skin = 1;
        }
    }
    if (self.skin == 1)
    {
        self.classname = "monster_warrior";
        if (soul_evil)
            monster_purse (2, 0.75, 0);
        monster_form ("progs/knight.mdl", '-16 -16 -24', '16 16 40', 150, -40);
        self.th_spawn   = monster_warrior;
    }
    else
    {
        self.skin       = 0;
        if (soul_evil)
            monster_purse (2, 0.5, 0);
        monster_form ("progs/knight.mdl", '-16 -16 -24', '16 16 40', 75, -40);
        self.th_spawn   = monster_knight;
    }
    self.mdl_head   = "progs/h_knight.mdl";
    self.mass       = MASS_MEDIUM;

    self.th_stand   = knight_stand1;
    self.th_walk    = knight_walk1;
    self.th_run     = knight_run1;
    self.th_melee   = knight_attack;    // Was knight_atk1.
    self.th_pain    = knight_pain;
    self.th_die     = knight_die;
    //- - - - - - - -
    self.th_sight   = knight_sight;
    self.th_gib     = knight_gib;
    self.th_revive  = knight_revive;
    self.th_win     = knight_bow1;

    self.xfl        = XFL_ARMORED;
    self.family     = FAM_BANE;
    self.hittype    = HIT_METAL;

    monster_start ();
};


//===========================/  END OF FILE  /===========================//
