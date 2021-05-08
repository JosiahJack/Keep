/*
==============================================================================

SHAL-RATH

==============================================================================
*/
$cd id1/models/shalrath
$origin 0 0 24
$base base
$skin skin
$scale 0.7

$frame attack1 attack2 attack3 attack4 attack5 attack6 attack7 attack8
$frame attack9 attack10 attack11

$frame pain1 pain2 pain3 pain4 pain5 

$frame death1 death2 death3 death4 death5 death6 death7

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10
$frame walk11 walk12

$frame decap1 decap2 decap3 decap4 decap5 decap6 decap7

//=================================================================

//================
// ShalMissile
//================
void() ShalMissile =
{
    M_Shal ('0 0 10');
};

// STAND - - - - - - - - - - - - - - - -
void() shal_stand  =[ $walk1,  shal_stand  ] {ai_stand();};

// WALK - - - - - - - - - - - - - - - -
void() shal_walk1  =[ $walk2,  shal_walk2  ] {
if (random() < 0.2)
    sound (self, CHAN_VOICE, "shalrath/idle.wav", 1, ATTN_IDLE);
ai_walk(6);};
void() shal_walk2  =[ $walk3,  shal_walk3  ] {ai_walk(4);};
void() shal_walk3  =[ $walk4,  shal_walk4  ] {ai_walk(0);};
void() shal_walk4  =[ $walk5,  shal_walk5  ] {ai_walk(0);};
void() shal_walk5  =[ $walk6,  shal_walk6  ] {ai_walk(0);};
void() shal_walk6  =[ $walk7,  shal_walk7  ] {ai_walk(0);};
void() shal_walk7  =[ $walk8,  shal_walk8  ] {ai_walk(5);};
void() shal_walk8  =[ $walk9,  shal_walk9  ] {ai_walk(6);};
void() shal_walk9  =[ $walk10, shal_walk10 ] {ai_walk(5);};
void() shal_walk10 =[ $walk11, shal_walk11 ] {ai_walk(0);};
void() shal_walk11 =[ $walk12, shal_walk12 ] {ai_walk(4);};
void() shal_walk12 =[ $walk1,  shal_walk1  ] {ai_walk(5);};

// RUN - - - - - - - - - - - - - - - - -
void() shal_run1   =[ $walk2,  shal_run2   ] {
if (random() < 0.2)
    sound (self, CHAN_VOICE, "shalrath/idle.wav", 1, ATTN_IDLE);
ai_run(6);};
void() shal_run2   =[ $walk3,  shal_run3   ] {ai_run(4);};
void() shal_run3   =[ $walk4,  shal_run4   ] {ai_run(0);};
void() shal_run4   =[ $walk5,  shal_run5   ] {ai_run(0);};
void() shal_run5   =[ $walk6,  shal_run6   ] {ai_run(0);};
void() shal_run6   =[ $walk7,  shal_run7   ] {ai_run(0);};
void() shal_run7   =[ $walk8,  shal_run8   ] {ai_run(5);};
void() shal_run8   =[ $walk9,  shal_run9   ] {ai_run(6);};
void() shal_run9   =[ $walk10, shal_run10  ] {ai_run(5);};
void() shal_run10  =[ $walk11, shal_run11  ] {ai_run(0);};
void() shal_run11  =[ $walk12, shal_run12  ] {ai_run(4);};
void() shal_run12  =[ $walk1,  shal_run1   ] {ai_run(5);};

// ATTACK - - - - - - - - - - - - - - -
void() shal_attack1  =[ $attack1,  shal_attack2  ] {
sound (self, CHAN_VOICE, "shalrath/attack.wav", 1, ATTN_NORM);
ai_face();
};
void() shal_attack2  =[ $attack2,  shal_attack3  ] {ai_face();};
void() shal_attack3  =[ $attack3,  shal_attack4  ] {ai_face();};
void() shal_attack4  =[ $attack4,  shal_attack5  ] {ai_face();};
void() shal_attack5  =[ $attack5,  shal_attack6  ] {ai_face();};
void() shal_attack6  =[ $attack6,  shal_attack7  ] {ai_face();};
void() shal_attack7  =[ $attack7,  shal_attack8  ] {ai_face();};
void() shal_attack8  =[ $attack8,  shal_attack9  ] {ai_face();};
void() shal_attack9  =[ $attack9,  shal_attack10 ] {ShalMissile();};
void() shal_attack10 =[ $attack10, shal_attack11 ] {ai_face();};
void() shal_attack11 =[ $attack11, shal_run1     ] {};

// PAIN - - - - - - - - - - - - - - - -
void() shal_pain1 =[ $pain1, shal_pain2 ] {};
void() shal_pain2 =[ $pain2, shal_pain3 ] {};
void() shal_pain3 =[ $pain3, shal_pain4 ] {};
void() shal_pain4 =[ $pain4, shal_pain5 ] {};
void() shal_pain5 =[ $pain5, shal_run1  ] {};

void() shalrath_pain =
{
    if (self.pain_finished > time)
        return;

    self.pain_finished = time + 3;
    sound (self, CHAN_VOICE, "shalrath/pain.wav", 1, ATTN_NORM);

    if (SUB_IgnorePain ())
        return;         // No pain anims in Nightmare.

    shal_pain1();
};

// DEATH - - - - - - - - - - - - - - - -
void() shal_decap1 =[ $decap1, shal_decap2 ] {blood_spray('-22 8 23', 1); monster_drop ();};
void() shal_decap2 =[ $decap2, shal_decap3 ] {blood_spray('-25 7 9', 2);};
void() shal_decap3 =[ $decap3, shal_decap4 ] {blood_spray('-28 6 -2', 2);};
void() shal_decap4 =[ $decap4, shal_decap5 ] {};
void() shal_decap5 =[ $decap5, shal_decap6 ] {};
void() shal_decap6 =[ $decap6, shal_decap7 ] {};
void() shal_decap7 =[ $decap7, decap_end   ] {};

void() shal_death1 =[ $death1, shal_death2 ] {};
void() shal_death2 =[ $death2, shal_death3 ] {};
void() shal_death3 =[ $death3, shal_death4 ] {};
void() shal_death4 =[ $death4, shal_death5 ] {};
void() shal_death5 =[ $death5, shal_death6 ] {};
void() shal_death6 =[ $death6, shal_death7 ] {};
void() shal_death7 =[ $death7, monster_end ] {};

float(float dm) shalrath_gib =
{
    if (self.health < self.gib_health)
    {
        sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
        ThrowGib ("progs/gib1.mdl", dm);
        ThrowGib ("progs/gib2.mdl", dm);
        ThrowGib ("progs/gib3.mdl", dm);
        ThrowHead ("progs/h_shal.mdl", dm);
        return TRUE;
    }
    return FALSE;
};

void() shalrath_die =
{
    if (Shattered ())
        return;
// check for decapitation
    if (Decapitated ())
    {
        monster_decap ('-22 8 23', shal_decap1);
        return;
    }

// check for gib
    if (shalrath_gib (self.health))
        return;

    sound (self, CHAN_VOICE, "shalrath/death.wav", 1, ATTN_NORM);
    monster_drop ();
    shal_death1 ();
};

// REVIVE - - - - - - - - - - - - - - -
void() shal_revive1  =[ $death6,  shal_revive2  ] {};
void() shal_revive2  =[ $death5,  shal_revive3  ] {};
void() shal_revive3  =[ $death4,  shal_revive4  ] {};
void() shal_revive4  =[ $death3,  shal_revive5  ] {};
void() shal_revive5  =[ $death2,  shal_revive6  ] {};
void() shal_revive6  =[ $death1,  shal_pain5    ] {};

//=================================================================

// OTHER - - - - - - - - - - - - - - - -
void(float hello) shal_sight =
{
    if (hello)
        sound (self, CHAN_VOICE, "shalrath/idle.wav", 1, ATTN_NORM);
    else
        sound (self, CHAN_VOICE, "shalrath/sight.wav", 1, ATTN_NORM);
};

void() shal_cache =
{
    precache_model ("progs/shalrath.mdl");
    precache_model ("progs/h_shal.mdl");
    precache_model ("progs/v_spike.mdl");
    
    precache_sound ("shalrath/attack.wav");
    precache_sound ("shalrath/attack2.wav");
    precache_sound ("shalrath/death.wav");
    precache_sound ("shalrath/idle.wav");
    precache_sound ("shalrath/pain.wav");
    precache_sound ("shalrath/sight.wav");
};

// NOTE:  Should add ceiling walker variant, but I don't have time now.
//============
// --> QUAKED monster_shalrath (1 0 0) (-32 -32 -24) (32 32 48) Ambush
//============
void() monster_shalrath =
{
    if (!self.spawned)
    {
        if (noenemies)
            {remove (self); return;}
        shal_cache ();
    }

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
    monster_form ("progs/shalrath.mdl", VEC_HULL2_MIN, VEC_HULL2_MAX, 400, -90);
    self.mdl_head   = "progs/h_shal.mdl";
    self.mass       = MASS_HEAVY;

    self.th_stand   = shal_stand;
    self.th_walk    = shal_walk1;
    self.th_run     = shal_run1;
    self.th_missile = shal_attack1;
    self.th_pain    = shalrath_pain;
    self.th_die     = shalrath_die;
    //- - - - - - - -
    self.th_sight   = shal_sight;
    self.th_gib     = shalrath_gib;
    self.th_revive  = shal_revive1;
    self.th_spawn   = monster_shalrath;

    self.xfl        = XFL_GHOST_BANE;
    if (soul_evil)
        monster_purse (1, 1, 1);    // One guaranteed gem. 

    monster_start ();
};


//===========================/  END OF FILE  /===========================//
