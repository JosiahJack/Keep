/*
==============================================================================

ELECTRIC EEL

==============================================================================
*/

$cd /qwork/xpack/models/eel
$origin 0 0 0
$scale .12
$base eelrest3
$skin eelfin

$frame eelswim1 eelswim2 eelswim3 eelswim4 eelswim5 eelswim6

$frame eeldth1 eeldth2 eeldth3 eeldth4 eeldth5
$frame eeldth6 eeldth7 eeldth8 eeldth9 eeldth10

//============================================================================

void(entity inflictor, entity attacker, float damage) T_EELZap =
{
    local   float   points;
    local   entity  head;
    local   vector  org;

    head = findradius(inflictor.origin, damage+40);
    while (head)
    {
        if (head.takedamage)
        {
            org = head.origin + (head.mins + head.maxs)*0.5;
            points = 0.5 * vlen(inflictor.origin - org);
            points = damage - points;
            if (points > 0)
            if (CanDamage (head, inflictor))
            if (head.flags & FL_INWATER)
            if (head.classname != attacker.classname) // Eels are immune.
                T_NewDamage (head, inflictor, attacker, points, DF_LIGHTNING, "");
        }
        head = head.chain;
    }
};

void() eel_pitch_change =
{
    if (pointcontents(self.origin) != CONTENT_WATER)
    {
        // PM:  Let gravity take care of the floor stuff.
//        droptofloor ();
        T_Damage (self, world, world, 6);
        return;
    }
    
    if (time < self.delay)
        return;

// Changed .weapon to .worldtype because of Drake's inventory code.
    if (self.worldtype > 10)
        self.worldtype = -10;

    if (self.worldtype < 0)
        self.angles_x = self.angles_x - 1.5;
    else if (self.worldtype > 0)
        self.angles_x = self.angles_x + 1.5;

    self.worldtype = self.worldtype + 1;
};

//============================================================================

// STAND - - - - - - - - - - - - - - - -
void() eel_stand = {ai_stand(); eel_pitch_change();};
void() eel_stand1  =[ $eelswim1, eel_stand2 ] {eel_stand();};
void() eel_stand2  =[ $eelswim2, eel_stand3 ] {eel_stand();};
void() eel_stand3  =[ $eelswim3, eel_stand4 ] {eel_stand();};
void() eel_stand4  =[ $eelswim4, eel_stand5 ] {eel_stand();};
void() eel_stand5  =[ $eelswim5, eel_stand6 ] {eel_stand();};
void() eel_stand6  =[ $eelswim6, eel_stand1 ] {eel_stand();};

// WALK - - - - - - - - - - - - - - - -
void() eel_walk = {ai_walk(6); eel_pitch_change();};
void() eel_walk1  =[ $eelswim1, eel_walk2 ] 
{
    if (random() < 0.2)
        sound (self, CHAN_VOICE, "eel/eactive1.wav", 1, ATTN_IDLE);
    eel_walk();
};
void() eel_walk2  =[ $eelswim2, eel_walk3 ] {eel_walk();};
void() eel_walk3  =[ $eelswim3, eel_walk4 ] {eel_walk();};
void() eel_walk4  =[ $eelswim4, eel_walk5 ] {eel_walk();};
void() eel_walk5  =[ $eelswim5, eel_walk6 ] {eel_walk();};
void() eel_walk6  =[ $eelswim6, eel_walk1 ] {eel_walk();};

// RUN - - - - - - - - - - - - - - - - -
void() eel_run = {ai_run(10); eel_pitch_change();};
void() eel_run1  =[ $eelswim1, eel_run2 ]
{
    if (random() < 0.4)
        sound (self, CHAN_VOICE, "eel/eactive1.wav", 1, ATTN_IDLE);
    eel_run();
};
void() eel_run2  =[ $eelswim2, eel_run3 ] {eel_run();};
void() eel_run3  =[ $eelswim3, eel_run4 ] {eel_run();};
void() eel_run4  =[ $eelswim4, eel_run5 ] {eel_run();};
void() eel_run5  =[ $eelswim5, eel_run6 ] {eel_run();};
void() eel_run6  =[ $eelswim6, eel_run1 ] {eel_run();};
void() eel_run0 = {self.skin = self.effects = 0; eel_run1();};

// ATTACK - - - - - - - - - - - - - - -
void() eel_melee =
{
    local float     attackOK;

    attackOK = 1;

    traceline (self.origin, self.enemy.origin, FALSE, self);

    if (trace_ent != self.enemy)
        attackOK = FALSE;       // don't have a clear shot
    if (trace_inopen)
        if (trace_inwater)
            attackOK = FALSE;           // sight line crossed contents

    if (attackOK)
        T_EELZap (self, self, 45);
    self.skin = self.effects = 0;
};

void() eel_charge = {ai_charge(8); eel_pitch_change();};
void() eel_attack1 =[ $eelswim1, eel_attack2 ] {eel_charge();};
void() eel_attack2 =[ $eelswim2, eel_attack3 ] {eel_charge();};
void() eel_attack3 =[ $eelswim3, eel_attack4 ] {eel_charge();};
void() eel_attack4 =[ $eelswim4, eel_attack5 ] {eel_charge();};
void() eel_attack5 =[ $eelswim5, eel_attack6 ] {eel_charge();};
void() eel_attack6 =[ $eelswim6, eel_attack7 ] {eel_charge();};
void() eel_attack7 =[ $eelswim1, eel_attack8 ] {eel_charge();};
void() eel_attack8 =[ $eelswim2, eel_attack9 ] 
{ 
    self.effects = EF_DIMLIGHT;
    self.skin = 1;
    eel_charge();
    sound (self, CHAN_WEAPON, "eel/eatt1.wav", 1, ATTN_NORM);
};
void() eel_attack9 =[ $eelswim3, eel_attack10 ] {self.skin=2; eel_charge();};
void() eel_attack10=[ $eelswim4, eel_attack11 ] {self.skin=3; eel_charge();};
void() eel_attack11=[ $eelswim5, eel_attack12 ] {self.effects = EF_BRIGHTLIGHT; self.skin=4; eel_charge();};
void() eel_attack12=[ $eelswim6, eel_run1     ] {self.skin=5; eel_melee();};

// PAIN - - - - - - - - - - - - - - - -
void() eel_pain1  =[ $eeldth1, eel_pain2 ] {};
void() eel_pain2  =[ $eeldth2, eel_pain3 ] {};
void() eel_pain3  =[ $eeldth3, eel_pain4 ] {};
void() eel_pain4  =[ $eeldth4, eel_pain5 ] {};
void() eel_pain5  =[ $eeldth3, eel_pain6 ] {};
void() eel_pain6  =[ $eeldth2, eel_pain7 ] {};
void() eel_pain7  =[ $eeldth1, eel_run1  ] {};

void(entity attacker, float damage) eel_pain =
{
    if (SUB_IgnorePain ())
        return;     // No pain frames in Nightmare.
    if (self.pain_finished > time)
        return;
    if (damage <= 0)    // PM:  Added for Drake.
        return;     // Probably got hit by lightning, ignore it.

    self.pain_finished = time + 1;
    sound (self, CHAN_VOICE, "eel/epain3.wav", 1, ATTN_NORM); 
    self.skin = self.effects = 0;
    eel_pain1 ();

    attacker = attacker;  damage = damage;  // Appease FrikQcc.
};

// DEATH - - - - - - - - - - - - - - - -
void() eel_death1  =[ $eeldth1,  eel_death2  ]
{
    self.flags = self.flags | FL_SWIM;
    sound (self, CHAN_VOICE, "eel/edie3r.wav", 1, ATTN_NORM);
};
void() eel_death2  =[ $eeldth2,  eel_death3  ] {};
void() eel_death3  =[ $eeldth3,  eel_death4  ] {};
void() eel_death4  =[ $eeldth4,  eel_death5  ] {};
void() eel_death5  =[ $eeldth3,  eel_death6  ] {};
void() eel_death6  =[ $eeldth2,  eel_death7  ] {};
void() eel_death7  =[ $eeldth1,  eel_death8  ] {};
void() eel_death8  =[ $eeldth2,  eel_death9  ] {};
void() eel_death9  =[ $eeldth3,  eel_death10 ] {};
void() eel_death10 =[ $eeldth4,  eel_death11 ] {};
void() eel_death11 =[ $eeldth5,  eel_death12 ]
{
    self.flags = self.flags - (self.flags & FL_SWIM);
    setsize (self, '0 0 0', '0 0 0');
//    monster_drop ();
};
void() eel_death12 =[ $eeldth6,  eel_death13 ] {};
void() eel_death13 =[ $eeldth7,  eel_death14 ] {};
void() eel_death14 =[ $eeldth8,  eel_death15 ] {};
void() eel_death15 =[ $eeldth9,  eel_death16 ] {};  //droptofloor();};
void() eel_death16 =[ $eeldth10, monster_end ] {};

float(float dm) eel_gib =
{
    if (self.health < self.gib_health)
    {
        self.flags = self.flags - (self.flags & FL_SWIM);
        sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);    //player/teledth1.wav
        ThrowHead ("progs/eelgib.mdl", dm);
        ThrowGib ("progs/gib1.mdl", dm);
        ThrowGib ("progs/gib1.mdl", dm);
// PM:  Call twice instead of three times.
//        ThrowGib ("progs/gib1.mdl", dm);
        return TRUE;
    }
    return FALSE;
};

void() eel_death =
{
    self.skin =  self.effects = 0;      // change to normal skin.
    if (Shattered ())
        return;
    if (eel_gib (self.health))
        return;
    eel_death1 ();
};

// OTHER - - - - - - - - - - - - - - - -
void(float hello) eel_sight =
{
    if (!hello)
        sound (self, CHAN_VOICE, "eel/eelc5.wav", 1, ATTN_NORM);
};

void() eel_cache =
{
    precache_model ("progs/eel2.mdl");
    precache_model ("progs/eelgib.mdl");
//    precache_model ("progs/gib1.mdl");
    
    precache_sound ("eel/edie3r.wav");
    precache_sound ("eel/epain3.wav");
    precache_sound ("eel/eactive1.wav");
    precache_sound ("eel/eatt1.wav");
    precache_sound ("eel/eelc5.wav");
};

//============
// --> QUAKED monster_eel (1 0 0) (-16 -16 -24) (16 16 32) Ambush
//============
void() monster_eel =
{
    if (!self.spawned)
    {
        if (noenemies)
            {remove (self); return;}
        eel_cache ();
    }
    self.skin       = 0;
// Raised gib health from -12 to -25 because of corpse mutilation in Drake.
    monster_form ("progs/eel2.mdl", VEC_HULL_MIN, VEC_HULL_MAX, 60, -25);
    self.mdl_head   = "progs/eelgib.mdl";
    self.mass       = MASS_LIGHT;

    self.th_stand   = eel_stand1;
    self.th_walk    = eel_walk1;
    self.th_run     = eel_run0;
    self.th_die     = eel_death;
    self.th_pain    = eel_pain;
    self.th_melee   = eel_attack1;

    self.th_sight   = eel_sight;
    self.th_gib     = eel_gib;
    self.th_spawn   = monster_eel;

    self.delay = time + random() * 6;
    self.worldtype = 0;
    self.resist_light = 1;      // PM:  Now they are immune to lightning.

    swimmonster_start ();
};


//===========================/  END OF FILE  /===========================//
