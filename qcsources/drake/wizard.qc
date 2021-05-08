/*
==============================================================================

WIZARD

==============================================================================
*/

$cd id1/models/a_wizard
$origin 0 0 24
$base wizbase    
$skin wizbase

$frame hover1 hover2 hover3 hover4 hover5 hover6 hover7 hover8
$frame hover9 hover10 hover11 hover12 hover13 hover14 hover15

$frame fly1 fly2 fly3 fly4 fly5 fly6 fly7 fly8 fly9 fly10
$frame fly11 fly12 fly13 fly14

$frame magatt1 magatt2 magatt3 magatt4 magatt5 magatt6 magatt7
$frame magatt8 magatt9 magatt10 magatt11 magatt12 magatt13

$frame pain1 pain2 pain3 pain4

$frame death1 death2 death3 death4 death5 death6 death7 death8

$frame decap1 decap2 decap3 decap4 decap5 decap6 decap7 decap8

//==========================================================================


void() wiz_run1;
void() wiz_side1;

//===================
// WizardCheckAttack
//===================
float() WizardCheckAttack =
{
    local   vector  spot1, spot2;    
    local   entity  targ;
    local   float   chance;

    if (time < self.attack_finished)
        return FALSE;
    if (!enemy_vis)
        return FALSE;

// PM:  Used to check for equality for far range, which doesn't work the
// same now that I added a new range between medium and far.
    if (enemy_range > RANGE_MID)    // Long or far range.
    {
        if (self.attack_state != AS_STRAIGHT)
        {
            self.attack_state = AS_STRAIGHT;
            wiz_run1 ();
        }
        return FALSE;
    }
        
    targ = self.enemy;
    
// see if any entities are in the way of the shot
    spot1 = self.origin + self.view_ofs;
    spot2 = targ.origin + targ.view_ofs;

    traceline (spot1, spot2, FALSE, self);

    if (trace_ent != targ)
        if (DontHurtMe (trace_ent))   // PM:  Check who's in the way.
    {    // don't have a clear shot, so move to a side
        if (self.attack_state != AS_STRAIGHT)
        {
            self.attack_state = AS_STRAIGHT;
            wiz_run1 ();
        }
        return FALSE;
    }
            
    if (enemy_range == RANGE_MELEE)
        chance = 0.9;
    else if (enemy_range == RANGE_NEAR)
        chance = 0.6;
    else if (enemy_range == RANGE_MID)
        chance = 0.2;
    else
        chance = 0;

    if (random () < chance)
    {
        self.attack_state = AS_MISSILE;
        return TRUE;
    }

    if (enemy_range == RANGE_MID)
    {
        if (self.attack_state != AS_STRAIGHT)
        {
            self.attack_state = AS_STRAIGHT;
            wiz_run1 ();
        }
    }
    else
    {
        if (self.attack_state != AS_SLIDING)
        {
            self.attack_state = AS_SLIDING;
            wiz_side1 ();
        }
    }
    
    return FALSE;
};

/*
=================
WizardAttackFinished
=================
*/
void() WizardAttackFinished =
{
    if (enemy_range >= RANGE_MID || !enemy_vis)
        {self.attack_state = AS_STRAIGHT;  self.think = wiz_run1;}
    else
        {self.attack_state = AS_SLIDING;  self.think = wiz_side1;}
};

/*
==============================================================================

FAST ATTACKS

==============================================================================
*/

void(vector st) Wiz_Fire =
{
    local   vector  vec;
    local   vector  p1, p2;
    local   entity  targ;

//- - - - - - - - -
    if (cranked)
        targ = self.enemy;
    else
        targ = world;
//- - - - - - - - -
    self.effects = self.effects | EF_MUZZLEFLASH;

    makevectors (self.enemy.angles);
    vec = v_right * 13;
    if (st_y < 0)
        vec = vec * -1;

    makevectors (self.angles);
    p1 = self.origin + v_forward*st_x + v_right*st_y + v_up*st_z;
    p2 = self.enemy.origin + vec;

    vec = Maim_Line (p1, p2, 600, targ, '0 0 0');
// PM:  Disabled sound because it was already played when attack began.
//    sound (self, CHAN_WEAPON, "wizard/wattack.wav", 1, ATTN_NORM);
    Acid_Launch (p1, vec, 600);
};


void() Wiz_idlesound =
{
    if (self.waitmin < time)
    {
        local   float   wr;

        wr = random() * 5;
        self.waitmin = time + 2;
        if (wr > 4.5) 
            sound (self, CHAN_VOICE, "wizard/widle1.wav", 1,  ATTN_IDLE);
        if (wr < 1.5)
            sound (self, CHAN_VOICE, "wizard/widle2.wav", 1, ATTN_IDLE);
    }
    return;
};

// STAND - - - - - - - - - - - - - - - -
void() wiz_stand1 =[ $hover1,  wiz_stand2 ] {ai_stand();};
void() wiz_stand2 =[ $hover2,  wiz_stand3 ] {ai_stand();};
void() wiz_stand3 =[ $hover3,  wiz_stand4 ] {ai_stand();};
void() wiz_stand4 =[ $hover4,  wiz_stand5 ] {ai_stand();};
void() wiz_stand5 =[ $hover5,  wiz_stand6 ] {ai_stand();};
void() wiz_stand6 =[ $hover6,  wiz_stand7 ] {ai_stand();};
void() wiz_stand7 =[ $hover7,  wiz_stand8 ] {ai_stand();};
void() wiz_stand8 =[ $hover8,  wiz_stand1 ] {ai_stand();};

// WALK - - - - - - - - - - - - - - - -
void() wiz_walk1  =[ $hover1,  wiz_walk2  ] {ai_walk(8);Wiz_idlesound();};
void() wiz_walk2  =[ $hover2,  wiz_walk3  ] {ai_walk(8);};
void() wiz_walk3  =[ $hover3,  wiz_walk4  ] {ai_walk(8);};
void() wiz_walk4  =[ $hover4,  wiz_walk5  ] {ai_walk(8);};
void() wiz_walk5  =[ $hover5,  wiz_walk6  ] {ai_walk(8);};
void() wiz_walk6  =[ $hover6,  wiz_walk7  ] {ai_walk(8);};
void() wiz_walk7  =[ $hover7,  wiz_walk8  ] {ai_walk(8);};
void() wiz_walk8  =[ $hover8,  wiz_walk1  ] {ai_walk(8);};

// RUN - - - - - - - - - - - - - - - - -
void() wiz_side1  =[ $hover1,  wiz_side2  ] {ai_run(8);Wiz_idlesound();};
void() wiz_side2  =[ $hover2,  wiz_side3  ] {ai_run(8);};
void() wiz_side3  =[ $hover3,  wiz_side4  ] {ai_run(8);};
void() wiz_side4  =[ $hover4,  wiz_side5  ] {ai_run(8);};
void() wiz_side5  =[ $hover5,  wiz_side6  ] {ai_run(8);};
void() wiz_side6  =[ $hover6,  wiz_side7  ] {ai_run(8);};
void() wiz_side7  =[ $hover7,  wiz_side8  ] {ai_run(8);};
void() wiz_side8  =[ $hover8,  wiz_side1  ] {ai_run(8);};

void() wiz_run1   =[ $fly1,    wiz_run2   ] {ai_run(16);Wiz_idlesound();};
void() wiz_run2   =[ $fly2,    wiz_run3   ] {ai_run(16);};
void() wiz_run3   =[ $fly3,    wiz_run4   ] {ai_run(16);};
void() wiz_run4   =[ $fly4,    wiz_run5   ] {ai_run(16);};
void() wiz_run5   =[ $fly5,    wiz_run6   ] {ai_run(16);};
void() wiz_run6   =[ $fly6,    wiz_run7   ] {ai_run(16);};
void() wiz_run7   =[ $fly7,    wiz_run8   ] {ai_run(16);};
void() wiz_run8   =[ $fly8,    wiz_run9   ] {ai_run(16);};
void() wiz_run9   =[ $fly9,    wiz_run10  ] {ai_run(16);};
void() wiz_run10  =[ $fly10,   wiz_run11  ] {ai_run(16);};
void() wiz_run11  =[ $fly11,   wiz_run12  ] {ai_run(16);};
void() wiz_run12  =[ $fly12,   wiz_run13  ] {ai_run(16);};
void() wiz_run13  =[ $fly13,   wiz_run14  ] {ai_run(16);};
void() wiz_run14  =[ $fly14,   wiz_run1   ] {ai_run(16);};

// ATTACK - - - - - - - - - - - - - - -
void() wiz_fast1  =[ $magatt1, wiz_fast2  ] {ai_face();sound (self, CHAN_WEAPON, "wizard/wattack.wav", 1, ATTN_NORM);};
void() wiz_fast2  =[ $magatt2, wiz_fast3  ] {ai_face();};
void() wiz_fast3  =[ $magatt3, wiz_fast4  ] {ai_face();};
void() wiz_fast4  =[ $magatt4, wiz_fast5  ] {ai_face();Wiz_Fire('14 -14 30');if (cranked) Wiz_Fire('14 14 30');};
void() wiz_fast5  =[ $magatt5, wiz_fast6  ] {ai_face();};
void() wiz_fast6  =[ $magatt6, wiz_fast7  ] {ai_face();};
void() wiz_fast7  =[ $magatt5, wiz_fast8  ] {ai_face();};
void() wiz_fast8  =[ $magatt4, wiz_fast9  ] {ai_face();};
void() wiz_fast9  =[ $magatt3, wiz_fast10 ] {ai_face();Wiz_Fire('14 14 30');if (cranked) Wiz_Fire('14 -14 30');};
void() wiz_fast10 =[ $magatt2, wiz_run1   ] {ai_face();SUB_AttackFinished(2);WizardAttackFinished();};

// PAIN - - - - - - - - - - - - - - - -
void() wiz_pain1  =[ $pain1,   wiz_pain2  ] {};
void() wiz_pain2  =[ $pain2,   wiz_pain3  ] {};
void() wiz_pain3  =[ $pain3,   wiz_pain4  ] {};
void() wiz_pain4  =[ $pain4,   wiz_run1   ] {};

void(entity attacker, float damage) wiz_pain =
{
    if (self.pain_finished > time)
        return;     // Already in pain anim.

    self.pain_finished = time + 0.5;

    sound (self, CHAN_VOICE, "wizard/wpain.wav", 1, ATTN_NORM);
    if (random()*70 > damage)
        return;        // didn't flinch
    if (SUB_IgnorePain ())
        return;         // No pain anims in Nightmare.

    wiz_pain1 ();
    attacker = attacker;    // FrikQcc warning squelch!
};

// DEATH - - - - - - - - - - - - - - - -
void() wiz_decap1 =[ $decap1,  wiz_decap2  ] {blood_spray ('5 0 26', 1);
    self.velocity_x = -200 + 400*random();
    self.velocity_y = -200 + 400*random();
    self.velocity_z = 100 + 100*random();
    self.flags = self.flags - (self.flags & FL_ONGROUND);
};
void() wiz_decap2 =[ $decap2,  wiz_decap3  ] {blood_spray ('0 0 27', 2);};
void() wiz_decap3 =[ $decap3,  wiz_decap4  ] {blood_spray ('6 0 21', 1); monster_drop();};
void() wiz_decap4 =[ $decap4,  wiz_decap5  ] {blood_spray ('13 0 12', -1);};
void() wiz_decap5 =[ $decap5,  wiz_decap6  ] {};
void() wiz_decap6 =[ $decap6,  wiz_decap7  ] {};
void() wiz_decap7 =[ $decap7,  wiz_decap8  ] {};
void() wiz_decap8 =[ $decap8,  decap_end   ] {};

void() wiz_death1 =[ $death1,  wiz_death2  ] {};
void() wiz_death2 =[ $death2,  wiz_death3  ] {};
void() wiz_death3 =[ $death3,  wiz_death4  ] {monster_drop();};
void() wiz_death4 =[ $death4,  wiz_death5  ] {};
void() wiz_death5 =[ $death5,  wiz_death6  ] {};
void() wiz_death6 =[ $death6,  wiz_death7  ] {};
void() wiz_death7 =[ $death7,  wiz_death8  ] {};
void() wiz_death8 =[ $death8,  monster_end ] {};

float(float dm) wiz_gib =
{
    if (self.health < self.gib_health)
    {
        sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
        if (self.bloodtype == BLOOD_GREEN)
        {
            ThrowGib ("progs/gr_gib2.mdl", dm);
            ThrowGib ("progs/gr_gib2.mdl", dm);
            ThrowGib ("progs/gr_gib2.mdl", dm);
            ThrowHead ("progs/h_drake.mdl", dm);
        }
        else
        {
            ThrowGib ("progs/gib2.mdl", dm);
            ThrowGib ("progs/gib2.mdl", dm);
            ThrowGib ("progs/gib2.mdl", dm);
            ThrowHead ("progs/h_wizard.mdl", dm);
        }
        return TRUE;
    }
    return FALSE;
};

void() wiz_body =
{
    if (self.bloodtype == BLOOD_GREEN)
        decap_explode ("progs/gr_gib2.mdl", "progs/gr_gib2.mdl", "progs/gr_gib2.mdl");
    else
        decap_explode ("progs/gib2.mdl", "progs/gib2.mdl", "progs/gib2.mdl");
};

void() wiz_die =
{
    if (Shattered ())
        return;
    if (Decapitated ())
    {
        monster_decap ('5 0 26', wiz_decap1);
        newmis.th_die = wiz_body;
        return;
    }

// check for gib
    if (wiz_gib (self.health))
        return;

    self.velocity_x = -200 + 400*random();
    self.velocity_y = -200 + 400*random();
    self.velocity_z = 100 + 100*random();
    self.flags = self.flags - (self.flags & FL_ONGROUND);
    sound (self, CHAN_VOICE, "wizard/wdeath.wav", 1, ATTN_NORM);

    wiz_death1 ();
};

// REVIVE - - - - - - - - - - - - - - -
void() wiz_revive1 =[ $death7, wiz_revive2 ] {self.flags = (self.flags - (self.flags & FL_ONGROUND)) | FL_FLY;};
void() wiz_revive2 =[ $death6, wiz_revive3 ] {};
void() wiz_revive3 =[ $death5, wiz_revive4 ] {};
void() wiz_revive4 =[ $death4, wiz_revive5 ] {};
void() wiz_revive5 =[ $death3, wiz_revive6 ] {};
void() wiz_revive6 =[ $death2, wiz_revive7 ] {};
void() wiz_revive7 =[ $death1, wiz_run1    ] {};


// OTHER - - - - - - - - - - - - - - - -
void(float hello) wiz_sight =
{
    if (hello)
    {
        if (random() < 0.5)
            sound (self, CHAN_VOICE, "wizard/widle1.wav", 1, ATTN_NORM);
        else
            sound (self, CHAN_VOICE, "wizard/widle2.wav", 1, ATTN_NORM);
    }
    else
        sound (self, CHAN_VOICE, "wizard/wsight.wav", 1, ATTN_NORM);
};

// SoE:  Precache both drake and scrag versions.
void() wiz_cache =
{
    precache_blood (BLOOD_GREEN);
    precache_model ("progs/gr_gib2.mdl");

    precache_model ("progs/wizard.mdl");
    precache_model ("progs/h_drake.mdl");
    precache_model ("progs/h_wizard.mdl");
    precache_model ("progs/w_spike.mdl");

    precache_sound ("wizard/hit.wav");        // used by c code
    precache_sound ("wizard/wattack.wav");
    precache_sound ("wizard/wdeath.wav");
    precache_sound ("wizard/widle1.wav");
    precache_sound ("wizard/widle2.wav");
    precache_sound ("wizard/wpain.wav");
    precache_sound ("wizard/wsight.wav");
};

//============
// QUAKED monster_wizard (1 0 0) (-16 -16 -24) (16 16 40) Ambush
//============
void() monster_wizard =
{
    if (!self.spawned)
    {
        if (noenemies)
            {remove (self); return;}
        wiz_cache ();
    }

    if (!respawning)
    {
        if (soul_evil)
        {   // Reverse the skins in SoE.
            if (self.skin)
                self.skin = 0;
            else
                self.skin = 1;
        }
    }
    monster_form ("progs/wizard.mdl", '-16 -16 -24', '16 16 40', 80, -40);
    self.mdl_head   = "progs/h_wizard.mdl";
    self.mass       = MASS_MEDIUM;

    self.th_stand   = wiz_stand1;
    self.th_walk    = wiz_walk1;
    self.th_run     = wiz_run1;
    self.th_missile = wiz_fast1;
    self.th_pain    = wiz_pain;
    self.th_die     = wiz_die;
    //- - - - - - - -
    self.th_check   = WizardCheckAttack;
    self.th_sight   = wiz_sight;
    self.th_gib     = wiz_gib;
    self.th_revive  = wiz_revive1;
    self.th_spawn   = monster_wizard;

    self.burn_ofs   = '4 0 24';
    self.xfl        = XFL_NO_AIR | XFL_SLIMER;  // Amphibious.
    if (self.skin)
    {
        self.bloodtype  = BLOOD_GREEN;
        self.mdl_head   = "progs/h_drake.mdl";
    }
    if (soul_evil)
        monster_purse (2, 0.1, 1);      // 2 gems max, 10% for 1 gem.

    flymonster_start ();
};

// Green version of the scrag.  Bleeds green when hurt.
void() monster_drake =
{
    self.skin = 1;
    self.classname = "monster_wizard";
    monster_wizard ();
};


//===========================/  END OF FILE  /===========================//
