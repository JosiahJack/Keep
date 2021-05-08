/*
==============================================================================

AXEMAN / PLAYER

==============================================================================
*/

$cd id1/models/player_4
$origin 0 -6 24
$base base        
$skin skin

//
// running
//
$frame axrun1 axrun2 axrun3 axrun4 axrun5 axrun6

//
// standing
//
$frame axstnd1 axstnd2 axstnd3 axstnd4 axstnd5 axstnd6
$frame axstnd7 axstnd8 axstnd9 axstnd10 axstnd11 axstnd12

//
// pain
//
$frame axpain1 axpain2 axpain3 axpain4 axpain5 axpain6

//
// death
//
$frame axdeth1 axdeth2 axdeth3 axdeth4 axdeth5 axdeth6
$frame axdeth7 axdeth8 axdeth9

//
// attacks
//
$frame axatt1 axatt2 axatt3 axatt4 axatt5 axatt6

$frame axattb1 axattb2 axattb3 axattb4 axattb5 axattb6

$frame axattc1 axattc2 axattc3 axattc4 axattc5 axattc6

$frame axattd1 axattd2 axattd3 axattd4 axattd5 axattd6

//
// decap
//
$frame axdecap1 axdecap2 axdecap3 axdecap4 axdecap5 axdecap6
$frame axdecap7 axdecap8

//
// axe throw
//
$frame axthrow1 axthrow2 axthrow3 axthrow4 axthrow5 axthrow6

//==========================================================================

void() axeman_idle_sound =
{
    if (random() < 0.2)
    {
        if (self.classname == "monster_army_axe")
            sound (self, CHAN_VOICE, "soldier/idle.wav", 1, ATTN_IDLE);
        else
            sound (self, CHAN_VOICE, "axeman/aidle.wav", 1, ATTN_IDLE);
    }
};

// STAND
void() axe_stand2  =[ $axstnd2,  axe_stand2   ] {WalkFrame_Add ( $axstnd1, 1, 10 );  ai_stand();};
void() axe_stand1  ={WalkFrame_Check ( $axstnd1, $axstnd11 );  axe_stand2 ();};

// WALK
void() axe_walk1  =[ $axrun1,  axe_walk2   ] {axeman_idle_sound(); ai_walk(10);};
void() axe_walk2  =[ $axrun1,  axe_walk3   ] {ai_walk(10);};
void() axe_walk3  =[ $axrun2,  axe_walk4   ] {M_Step(); ai_walk(8);};
void() axe_walk4  =[ $axrun2,  axe_walk5   ] {ai_walk(8);};
void() axe_walk5  =[ $axrun3,  axe_walk6   ] {ai_walk(5);};
void() axe_walk6  =[ $axrun3,  axe_walk7   ] {ai_walk(4);};
void() axe_walk7  =[ $axrun4,  axe_walk8   ] {ai_walk(10);};
void() axe_walk8  =[ $axrun4,  axe_walk9   ] {ai_walk(10);};
void() axe_walk9  =[ $axrun5,  axe_walk10  ] {M_Step(); ai_walk(8);};
void() axe_walk10 =[ $axrun5,  axe_walk11  ] {ai_walk(8);};
void() axe_walk11 =[ $axrun6,  axe_walk12  ] {ai_walk(5);};
void() axe_walk12 =[ $axrun6,  axe_walk1   ] {ai_walk(4);};

// RUN
void(float d) axe_run =
{
    if (self.classname != "monster_army_axe")
        d = d * 2;      // Tronyn's classic axeman ran as fast as player.
    ai_run (d);
};
void() axe_run1  =[ $axrun1,  axe_run2   ] {axeman_idle_sound(); axe_run(20);};
void() axe_run2  =[ $axrun2,  axe_run3   ] {M_Step(); axe_run(16);};
void() axe_run3  =[ $axrun3,  axe_run4   ] {axe_run(9);};
void() axe_run4  =[ $axrun4,  axe_run5   ] {axe_run(20);};
void() axe_run5  =[ $axrun5,  axe_run6   ] {M_Step(); axe_run(16);};
void() axe_run6  =[ $axrun6,  axe_run1   ] {axe_run(9);};

// ATTACK
void(float d) axe_mac = {self.frame = self.frame + self.lip*6; ai_charge(d);};
void() axe_attack1  =[ $axatt1, axe_attack2 ] {axe_mac(20);};
void() axe_attack2  =[ $axatt2, axe_attack3 ] {axe_mac(16);ai_melee();};
void() axe_attack3  =[ $axatt3, axe_attack4 ] {axe_mac(9);ai_melee();};
void() axe_attack4  =[ $axatt4, axe_attack5 ] {axe_mac(10);ai_melee();};
void() axe_attack5  =[ $axatt5, axe_attack6 ] {axe_mac(8);};
void() axe_attack6  =[ $axatt6, axe_run1    ] {axe_mac(5);};

void() axe_attack =
{
    if (random() < 0.5)
        sound (self, CHAN_WEAPON, "axeman/axe1.wav", 1, ATTN_NORM);
    else
        sound (self, CHAN_WEAPON, "axeman/axe2.wav", 1, ATTN_NORM);

    if ((self.lip >= 3) || (self.lip < 0))
        self.lip = 0;
    else
        self.lip = floor(self.lip + 1);
    axe_attack1 ();
};

// Axe throwing.
void() axe_throw1 =[ $axatt1,   axe_throw2 ] {ai_charge(24);};
void() axe_throw2 =[ $axatt2,   axe_throw3 ] {ai_charge(45);};
void() axe_throw3 =[ $axthrow3, axe_throw4 ] {ai_charge(31);M_FireAxe('15 0 5', "progs/throwaxe.mdl");};
void() axe_throw4 =[ $axthrow4, axe_throw5 ] {ai_charge(20);};
void() axe_throw5 =[ $axthrow5, axe_throw6 ] {ai_charge(36);};
void() axe_throw6 =[ $axthrow6, axe_run1   ] {ai_charge(45);
if (range(self.enemy) > RANGE_MELEE)
    SUB_CheckRefire (axe_throw1);   // If not in melee, throw more axes.
};

// PAIN
void(float d) axe_forward =
{
    if (self.classname != "monster_army_axe")
        ai_forward (d);     // Tronyn's classic axeman slides forward.
};
void() axe_pain1 =[ $axpain1, axe_pain2 ] {};
void() axe_pain2 =[ $axpain2, axe_pain3 ] {axe_forward(6);};
void() axe_pain3 =[ $axpain3, axe_pain4 ] {axe_forward(8);};
void() axe_pain4 =[ $axpain4, axe_pain5 ] {axe_forward(4);};
void() axe_pain5 =[ $axpain5, axe_pain6 ] {axe_forward(2);};
void() axe_pain6 =[ $axpain6, axe_run1  ] {};

void(entity attacker, float damage) axe_pain =
{
    if (self.pain_finished > time)
        return;

    self.pain_finished = time + 1;
    if (self.classname == "monster_army_axe")
    {   // Since knights recover one second from short pain, use that.
        sound (self, CHAN_VOICE, "soldier/pain1.wav", 1, ATTN_NORM);
    }
    else
    {   // Classic axeman
    // PM:  We don't need damage for anything else, so use that.
        damage = random() * 3;
        if (damage < 1)
            sound (self, CHAN_VOICE, "me/mepain1.wav", 1, ATTN_NORM);
        else if (damage < 2)
            sound (self, CHAN_VOICE, "me/mepain2.wav", 1, ATTN_NORM);
        else
            sound (self, CHAN_VOICE, "me/mepain3.wav", 1, ATTN_NORM);
    }

    if (SUB_IgnorePain ())
        return;     // No pain frames in Nightmare.

    axe_pain1 ();
    attacker = attacker;    // Appease FrikQcc.
};

// DEATH
void() axe_decap1 =[ $axdecap1, axe_decap2  ] {blood_spray('-11 0 20', 1);};
void() axe_decap2 =[ $axdecap2, axe_decap3  ] {blood_spray('-16 0 21', 2);};
void() axe_decap3 =[ $axdecap3, axe_decap4  ] {blood_spray('-21 0 13', 1); monster_drop();};
void() axe_decap4 =[ $axdecap4, axe_decap5  ] {blood_spray('-21 0 8', 1);};
void() axe_decap5 =[ $axdecap5, axe_decap6  ] {};
void() axe_decap6 =[ $axdecap6, axe_decap7  ] {};
void() axe_decap7 =[ $axdecap7, axe_decap8  ] {};
void() axe_decap8 =[ $axdecap8, decap_end   ] {};

void() axe_die1 =[ $axdeth1, axe_die2    ] {};
void() axe_die2 =[ $axdeth2, axe_die3    ] {};
void() axe_die3 =[ $axdeth3, axe_die4    ] {monster_drop();};
void() axe_die4 =[ $axdeth4, axe_die5    ] {};
void() axe_die5 =[ $axdeth5, axe_die6    ] {};
void() axe_die6 =[ $axdeth6, axe_die7    ] {};
void() axe_die7 =[ $axdeth7, axe_die8    ] {};
void() axe_die8 =[ $axdeth8, axe_die9    ] {};
void() axe_die9 =[ $axdeth9, monster_end ] {};

float(float dm) axe_gib =
{
    if (self.health < self.gib_health)
    {
        sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
        ThrowHead ("progs/h_axeman.mdl", dm);
        ThrowGib ("progs/gib1.mdl", dm);
        ThrowGib ("progs/gib2.mdl", dm);
        ThrowGib ("progs/gib3.mdl", dm);
        return TRUE;
    }
    return FALSE;
};

void() axe_die =
{
    if (Shattered ())
        return;
//- - - - - - - - -
// Here because decapitated monsters can drop stuff.
    // If killed by a player, and he doesn't have an axe, drop one.
    if (weapon_name (WAR_AXE) == "Axe")
    {   // First, remove axe from the arsenal.  It's a hack to fix what's below.
        self.arsenal = self.arsenal - (self.arsenal & WAR_AXE);
        // Next, add the axe to the backpack.
        if (self.enemy.flags & FL_CLIENT)
            if (!(self.enemy.arsenal & WAR_AXE))
                self.arsenal = self.arsenal | WAR_AXE;
    }
//- - - - - - - - -
    if (Decapitated ())
    {
        monster_decap ('-11 0 20', axe_decap1);
        return;
    }
    if (axe_gib (self.health))
        return;

    if (self.classname == "monster_army_axe")
        sound (self, CHAN_VOICE, "soldier/death1.wav", 1, ATTN_NORM);
    else
        sound (self, CHAN_VOICE, "me/medeath1.wav", 1, ATTN_NORM);
    axe_die1 ();
};

// REVIVE - - - - - - - - - - - - - - -
void() axe_revive1  =[ $axdeth8,  axe_revive2  ] {};
void() axe_revive2  =[ $axdeth7,  axe_revive3  ] {};
void() axe_revive3  =[ $axdeth6,  axe_revive4  ] {};
void() axe_revive4  =[ $axdeth5,  axe_revive5  ] {};
void() axe_revive5  =[ $axdeth4,  axe_revive6  ] {};
void() axe_revive6  =[ $axdeth3,  axe_revive7  ] {};
void() axe_revive7  =[ $axdeth2,  axe_revive8  ] {};
void() axe_revive8  =[ $axdeth1,  axe_revive9  ] {};
void() axe_revive9  =[ $axpain1,  axe_run1     ] {};

//============================================================================

// OTHER
void(float hello) axe_sight =
{
    if (hello)
        sound (self, CHAN_VOICE, "axeman/aidle.wav", 1, ATTN_NORM);
    else
        sound (self, CHAN_VOICE, "me/mesight2.wav", 1, ATTN_NORM);
};

void() axeman_cache =
{
    precache_model ("progs/axeman.mdl");
    precache_model ("progs/h_axeman.mdl");
    precache_model ("progs/throwaxe.mdl");

    precache_sound ("axeman/axe1.wav");
    precache_sound ("axeman/axe2.wav");
    precache_sound ("axeman/aidle.wav");
    precache_sound ("me/medeath1.wav");
    precache_sound ("me/mepain1.wav");
    precache_sound ("me/mepain2.wav");
    precache_sound ("me/mepain3.wav");
    precache_sound ("me/mesight2.wav");
    precache_sound ("zombie/z_hit.wav");    // throw ax hit
};

//============
// --> QUAKED monster_axeman (1 0 0) (-16 -16 -24) (16 16 40) Ambush
//============
void() monster_axeman;

// Convert to axeman.
void() monster_thug =
{
    self.skin = 1;
    self.classname = "monster_axeman";
    monster_axeman();
};

void() monster_army_axe =
{
    self.skin = 3;
    monster_axeman();
};

void() monster_axeman =
{
    local   float   mx;
    local   float   thug, grunt;

    thug = ((self.skin == 1) || (self.skin == 2));
    grunt = (self.skin == 3);
    if (!self.spawned)
    {
        if (noenemies)
            {remove (self); return;}
        axeman_cache ();
        if (grunt)
            army_cache ();
    }

    if (grunt)
        monster_form ("progs/axeman.mdl", '-16 -16 -24', '16 16 40', 75, -35);
    else
    {
        if (thug)
            mx = 200;
        else
            mx = 300;   // Knight
        monster_form ("progs/axeman.mdl", '-16 -16 -24', '16 16 40', mx, -40);
    }
    self.mdl_head   = "progs/h_axeman.mdl";
    self.mass       = MASS_MEDIUM;

    self.th_stand   = axe_stand1;
    self.th_walk    = axe_walk1;
    self.th_run     = axe_run1;
    if (!grunt)
        if (cranked || !thug)
            self.th_missile = axe_throw1;
    self.th_melee   = axe_attack;
    self.th_pain    = axe_pain;
    self.th_die     = axe_die;
    //- - - - - - - -
    self.th_sight   = axe_sight;
    self.th_gib     = axe_gib;
    self.th_revive  = axe_revive1;

    if (grunt)
    {
        self.th_spawn   = monster_army_axe;
        self.th_sight   = army_sight;
        self.family     = FAM_ARMY;
        self.ryuflags   = RYU_INSANE;
    }
    else if (!thug)
    {
        self.th_spawn   = monster_axeman;
        self.family     = FAM_BANE;
        self.xfl        = XFL_ARMORED;
        self.hittype    = HIT_METAL;
    }
    else    // forest thug
        self.th_spawn   = monster_thug;
    if (soul_evil)
        monster_purse (3, 0.5, 0);

    monster_start ();
};

void() monster_ax = {self.classname = "monster_axeman"; monster_axeman();};


//===========================/  END OF FILE  /===========================//
