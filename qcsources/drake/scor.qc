/*
==============================================================================

SCOURGE

==============================================================================
*/

$cd hipwork\models\scourge
$origin 0 0 23
$base scorbase.asc

$skin skin

$frame stand1.asc stand2.asc stand3.asc stand4.asc stand5.asc stand6.asc
$frame stand7.asc stand8.asc stand9.asc stand10.asc stand11.asc stand12.asc

$frame walk1.asc walk2.asc walk3.asc walk4.asc walk5.asc walk6.asc

$frame shoot1.asc shoot2.asc

$frame sting1.asc sting2.asc sting3.asc sting4.asc sting5.asc sting6.asc
$frame sting7.asc sting8.asc sting9.asc sting10.asc sting11.asc

$frame pain1.asc pain2.asc pain3.asc pain4.asc pain5.asc

$frame death1.asc death2.asc death3.asc death4.asc death5.asc
//============================================================================

//===========
// ScourgeCheckAttack
//
// The player is in view, so decide to move or launch an attack
// Returns FALSE if movement should continue
//============
float() ScourgeCheckAttack =
{
    local   vector  spot1, spot2;
    local   entity  targ;
    local   float   chance;
    local   float   dist;

    targ = self.enemy;
// see if any entities are in the way of the shot
    spot1 = self.origin + self.view_ofs;
    spot2 = targ.origin + targ.view_ofs;

    dist = vlen(spot1 - spot2);
    if (InMeleeRange (100))     // PM:  Changed to work with big dragons.
    {   // Melee distance is less than the standard 120.
        if (CanDamage (self.enemy, self))
            {self.attack_state = AS_MELEE; return TRUE;}
    }
    if (time < self.attack_finished)
        return FALSE;

    if (!enemy_vis)
        return FALSE;

    chance = spot2_z - spot1_z;
    if (chance > 64)
        return FALSE;   // Too high.
    if (chance < -200)
        return FALSE;   // Too low.

    if (dist > 1000)
        return FALSE;   // Too far away.
    if (dist < 150)
        return FALSE;   // Too close.

    traceline (spot1, spot2, FALSE, self);

    if (trace_inopen && trace_inwater)
        return FALSE;            // sight line crossed contents

    if (trace_ent != targ)
        return FALSE;    // don't have a clear shot

// missile attack
    chance = 2 + 2*random();
    self.attack_state = AS_MISSILE;
    SUB_AttackFinished (chance);
    return TRUE;
};

// shoot1 = '14 28 -13' '14 -28 -13'
// shoot2 = '14 40 -13' '14 -40 -13'
// -6 ofs
void(float ox) SCOURGE_FireSpikes =
{
    local   vector  src, sr2, end, vec;

    self.effects = self.effects | EF_MUZZLEFLASH;

    ai_face();
    makevectors (self.angles);
//- - - -
// Old code.
//    src = self.origin - '0 0 19' + v_right*ox + v_forward*14;
//    vec = (self.enemy.origin + (200*v_forward)) - src;
//    vec = normalize(vec);
//- - - -
    src = self.origin + v_forward*14 + v_right*ox - '0 0 13';
    sr2 = src - v_right*(ox*2);
    end = self.enemy.origin + (200*v_forward);
    vec = Maim_Line (src, end, 1000, world, '0 0 0');
    sound (self, CHAN_WEAPON, "weapons/rocket1i.wav", 1, ATTN_NORM);
    launch_spike (src, vec);
    if (cranked)
    {
        vec = Maim_Line (sr2, end, 1000, world, '0 0 0');
        launch_spike (sr2, vec);
    }

    self.attack_finished = time + 0.2;
};

// Attack_With_Tail
//
void() Attack_With_Tail =
{
    local   float   ldmg;

    ai_face ();

    if (!InMeleeRange (100))    // PM:  Dragons-related.
        return;     // Too far away.
    if (!CanDamage (self.enemy, self))
        return;     // Blocked.

    // Smack the target!
    ldmg = SUB_MeleeDamage (40);
//    if (cranked)
//        Poison_Add (self.enemy, 1);   // As if the damage wasn't enough already.
    T_Damage (self.enemy, self, self, ldmg);
    sound (self, CHAN_WEAPON, "shambler/smack.wav", 1, ATTN_NORM);

    SpawnMeatSpray (self.origin + v_forward*16, crandom() * 50 * v_right, self.enemy.bloodtype);
};

//==========================================================================
//  Scourge Triggers

void() scourge_strafeleft1;
void() scourge_straferight1;
// PM:  From here on, edict.lastvictim is replaced by edict.trigger_field.

//
// ScourgeTriggerThink
//
void() ScourgeTriggerThink =
{
    local   entity  targ;

    if (self.trigger_field.health <= 0)
    {
        if (self.trigger_field)
            self.trigger_field = world;
        remove(self);
        return;
    }
    targ = self.trigger_field;
    makevectors (targ.angles);
    setorigin (self, targ.origin + (v_forward*300));
    self.nextthink = time + 0.1;
};

//
// ScourgeTriggerTouch
//
void() ScourgeTriggerTouch =
{
    local   entity  targ;
    local   vector  dir;

    if (other.flags & FLx_CREATURE)     //(FL_MONSTER|FL_CLIENT)
        return;
    if (other.movetype != MOVETYPE_FLYMISSILE)
        return;

    targ = self.trigger_field;
    if (targ.health <= 0)
    {   // 'targ' scorpion is dead.
        if (targ)
            targ.trigger_field = world;
        remove (self);
        return;
    }
    dir = targ.origin - other.origin;
    dir = normalize(dir);
    if ((dir * normalize(other.velocity)) < 0.8)
        return;

// PM:  edict.duration replaced by edict.volume.
    if (time > targ.volume)
    {
        targ.volume = time + 1.5;
        if (random() < 0.5)
            SUB_Think (targ, scourge_strafeleft1);
        else
            SUB_Think (targ, scourge_straferight1);
    }
};

// PM:  Added sfx parm.
void(float sfx) scourge_think =
{
    if (!self.trigger_field)
    {
        local   entity  trig;

        trig = spawn();
        trig.angles         = '0 0 0';
        trig.solid = SOLID_TRIGGER;
        setsize( trig, '-64 -64 -24', '64 64 64');
        trig.takedamage     = DAMAGE_NO;
        trig.movetype       = MOVETYPE_NONE;
        trig.modelindex     = 0;
        trig.model          = "";
        trig.trigger_field  = self;
        trig.think          = ScourgeTriggerThink;
        trig.touch          = ScourgeTriggerTouch;
        trig.nextthink      = time + 0.1 + random();
        setorigin (trig, self.origin);
        self.trigger_field = trig;
    }

//- - - - - - - - -
// PM:  Sounds do not move with the source entity.  This means a sound
// that plays at point A will continue to play at point A even after the
// entity that made the sound moved to point B a thousand or more pixels
// away.  'scourge/walk.wav' is a looping sound, and the old code toggled
// it on or off as needed.  However, that led to times when the walk sound
// could be heard from a location nowhere near the scorpion.  To fix this,
// always play the walk sound when needed to update the source point.
// The walking will sound a bit different than normal, but it should still
// suffice.  In this case, purists can whine for all I care.
//
// Also removed references to edict.spawnsilent and edict.spawnmulti.
//- - - - - - - - -
    if (sfx)
        sound (self, CHAN_BODY, "scourge/walk1.wav", 1, ATTN_IDLE);
    else if (self.waitmax)
        StopSound (self, CHAN_BODY);
    self.waitmax = sfx;
};

//============================================================================
// PM:  Don't bother with safe_move.  Assume th_move is walkmove.
void(float dist) ai_right = {walkmove ((self.angles_y+90), dist);};

void(float dist) ai_left = {walkmove ((self.angles_y+270), dist);};

//============================================================================

// STAND - - - - - - - - - - - - - - - -
void() scourge_stand_act = {ai_stand(); scourge_think(0);};
void() scourge_stand1  =[ $stand1.asc,  scourge_stand2  ] {scourge_stand_act();};
void() scourge_stand2  =[ $stand2.asc,  scourge_stand3  ] {scourge_stand_act();};
void() scourge_stand3  =[ $stand3.asc,  scourge_stand4  ] {scourge_stand_act();};
void() scourge_stand4  =[ $stand4.asc,  scourge_stand5  ] {scourge_stand_act();};
void() scourge_stand5  =[ $stand5.asc,  scourge_stand6  ] {scourge_stand_act();};
void() scourge_stand6  =[ $stand6.asc,  scourge_stand7  ] {scourge_stand_act();};
void() scourge_stand7  =[ $stand7.asc,  scourge_stand8  ] {scourge_stand_act();};
void() scourge_stand8  =[ $stand8.asc,  scourge_stand9  ] {scourge_stand_act();};
void() scourge_stand9  =[ $stand9.asc,  scourge_stand10 ] {scourge_stand_act();};
void() scourge_stand10 =[ $stand10.asc, scourge_stand11 ] {scourge_stand_act();};
void() scourge_stand11 =[ $stand11.asc, scourge_stand12 ] {scourge_stand_act();};
void() scourge_stand12 =[ $stand12.asc, scourge_stand1  ] {scourge_stand_act();};

// WALK - - - - - - - - - - - - - - - -
void() scourge_walk1 =[ $walk1.asc, scourge_walk2 ]
{
    if (random() < 0.1)
        sound (self, CHAN_VOICE, "scourge/idle.wav", 1, ATTN_IDLE);
    scourge_think(1);
    ai_walk(8);
};
void() scourge_walk2 =[ $walk2.asc, scourge_walk3 ] {ai_walk(8);};
void() scourge_walk3 =[ $walk3.asc, scourge_walk4 ] {ai_walk(8);};
void() scourge_walk4 =[ $walk4.asc, scourge_walk5 ] {ai_walk(8);};
void() scourge_walk5 =[ $walk5.asc, scourge_walk6 ] {ai_walk(8);};
void() scourge_walk6 =[ $walk6.asc, scourge_walk1 ] {ai_walk(8);};

// RUN - - - - - - - - - - - - - - - - -
void() scourge_run1 =[ $walk1.asc, scourge_run2  ]
{
    if (random() < 0.1)
        sound (self, CHAN_VOICE, "scourge/idle.wav", 1, ATTN_IDLE);
    scourge_think(1);
    ai_run(18);
};
void() scourge_run2 =[ $walk2.asc, scourge_run3 ] {ai_run(14);};
void() scourge_run3 =[ $walk3.asc, scourge_run4 ] {ai_run(14);};
void() scourge_run4 =[ $walk4.asc, scourge_run5 ] {ai_run(14);};
void() scourge_run5 =[ $walk5.asc, scourge_run6 ] {ai_run(14);};
void() scourge_run6 =[ $walk6.asc, scourge_run1 ] {ai_run(14);};
// PM:  Reset zigzag pattern when activated.
void() scourge_run = {self.attack_state = AS_DODGING; scourge_run1();};

void() scourge_strafeleft1  =[ $walk1.asc, scourge_strafeleft2  ] {scourge_think(1);ai_left(20);};
void() scourge_strafeleft2  =[ $walk2.asc, scourge_strafeleft3  ] {ai_left(20);};
void() scourge_strafeleft3  =[ $walk3.asc, scourge_strafeleft4  ] {ai_left(20);};
void() scourge_strafeleft4  =[ $walk4.asc, scourge_strafeleft5  ] {ai_left(14);};
void() scourge_strafeleft5  =[ $walk5.asc, scourge_strafeleft6  ] {ai_left(14);};
void() scourge_strafeleft6  =[ $walk6.asc, scourge_run1         ] {ai_left(14);};

void() scourge_straferight1 =[ $walk1.asc, scourge_straferight2 ] {scourge_think(1);ai_right(20);};
void() scourge_straferight2 =[ $walk2.asc, scourge_straferight3 ] {ai_right(20);};
void() scourge_straferight3 =[ $walk3.asc, scourge_straferight4 ] {ai_right(20);};
void() scourge_straferight4 =[ $walk4.asc, scourge_straferight5 ] {ai_right(14);};
void() scourge_straferight5 =[ $walk5.asc, scourge_straferight6 ] {ai_right(14);};
void() scourge_straferight6 =[ $walk6.asc, scourge_run1         ] {ai_right(14);};

// ATTACK - - - - - - - - - - - - - - -
// PM:  Each of the frames had a second spike commented out.
//  Also, changed oxs -- 40 is 28, and 56 is 40.
void() scourge_atk1 =[ $shoot1.asc, scourge_atk2 ] {scourge_think(0); SCOURGE_FireSpikes(28);};
void() scourge_atk2 =[ $shoot2.asc, scourge_atk3 ] {SCOURGE_FireSpikes(-40);};
void() scourge_atk3 =[ $shoot1.asc, scourge_atk4 ] {SCOURGE_FireSpikes(-28);};
void() scourge_atk4 =[ $shoot2.asc, scourge_atk5 ] {SCOURGE_FireSpikes(40);};
void() scourge_atk5 =[ $shoot1.asc, scourge_atk6 ] {SCOURGE_FireSpikes(28);};
void() scourge_atk6 =[ $shoot2.asc, scourge_atk7 ] {SCOURGE_FireSpikes(-40);};
void() scourge_atk7 =[ $shoot1.asc, scourge_atk8 ] {SCOURGE_FireSpikes(-28);};
void() scourge_atk8 =[ $shoot2.asc, scourge_run1 ]
{
    local   float   pause;

    pause = 4*random();
    SCOURGE_FireSpikes(40);
    SUB_AttackFinished (pause);
};

void() scourge_melee1  =[ $sting1.asc,  scourge_melee2  ] {scourge_think(0);ai_charge(3);};
void() scourge_melee2  =[ $sting2.asc,  scourge_melee3  ] {ai_charge(3);};
void() scourge_melee3  =[ $sting3.asc,  scourge_melee4  ] {ai_charge(2);};
void() scourge_melee4  =[ $sting4.asc,  scourge_melee5  ] {ai_charge(2);};
void() scourge_melee5  =[ $sting5.asc,  scourge_melee6  ]
{
    sound (self, CHAN_WEAPON, "scourge/tailswng.wav", 1, ATTN_NORM);
    ai_charge(3);
};
void() scourge_melee6  =[ $sting6.asc,  scourge_melee7  ] {ai_charge(1);};
void() scourge_melee7  =[ $sting7.asc,  scourge_melee8  ] {Attack_With_Tail();};
void() scourge_melee8  =[ $sting8.asc,  scourge_melee9  ] {ai_face();};
void() scourge_melee9  =[ $sting9.asc,  scourge_melee10 ] {ai_face();};
void() scourge_melee10 =[ $sting10.asc, scourge_melee11 ] {ai_face();};
void() scourge_melee11 =[ $sting11.asc, scourge_run1    ] {ai_face(); SUB_CheckRefire (scourge_melee1);};

//
// scourge_melee
//
void() scourge_melee =
{
    local   float   de;

    de = 2 * random();
    scourge_melee1();
    SUB_AttackFinished (de);
};

// PAIN - - - - - - - - - - - - - - - -
void() scourge_pain1 =[ $pain1.asc, scourge_pain2 ] {scourge_think(0);};
void() scourge_pain2 =[ $pain2.asc, scourge_pain3 ] {};
void() scourge_pain3 =[ $pain3.asc, scourge_pain4 ] {};
void() scourge_pain4 =[ $pain4.asc, scourge_pain5 ] {};
void() scourge_pain5 =[ $pain5.asc, scourge_run1  ] {};

void(entity attacker, float damage) scourge_pain =
{
// PM:  Moved damage check below.
    if (self.pain_finished > time)
        return;

    damage = (random()*50 > damage);
    if (damage)
        return;        // didn't flinch
    sound (self, CHAN_VOICE, "scourge/pain.wav", 1, ATTN_NORM);
    self.pain_finished = time + 2.0;
    if (SUB_IgnorePain ())
        return;     // PM:  No pain frames in Nightmare.

    scourge_pain1 ();
    attacker = attacker;    // FrikQcc warning squelch!
};

// DEATH - - - - - - - - - - - - - - - -
void() scourge_die1 =[ $death1.asc, scourge_die2 ] {};  //scourge_think(0);
void() scourge_die2 =[ $death2.asc, scourge_die3 ] {};
void() scourge_die3 =[ $death3.asc, scourge_die4 ] {monster_drop();};
void() scourge_die4 =[ $death4.asc, scourge_die5 ] {};
void() scourge_die5 =[ $death5.asc, monster_end  ] {};

float(float dm) scourge_gib =
{
    if (self.health < self.gib_health)
    {
        sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
        ThrowHead ("progs/h_scourg.mdl", dm);
        ThrowGib ("progs/gib1.mdl", dm);
        ThrowGib ("progs/gib2.mdl", dm);
        ThrowGib ("progs/gib3.mdl", dm);
        return TRUE;
    }
    return FALSE;
};

void() scourge_die =
{
// stop sound
    scourge_think (0);

// do this after think above so any created trigger gets removed.
    if (self.trigger_field)
    {
        remove (self.trigger_field);
        self.trigger_field = world;
    }

    if (Shattered ())
        return;
// Note:  Head is almost half its body size, so decapitation is pointless.
// Update 9/4/09:  Gib instead.
    if (Decapitated ())
    {   // Model isn't suited for decapitation, so gib instead.
        if (self.health >= self.gib_health)
            self.health = self.gib_health - 1;
    }
// check for gib
    if (scourge_gib (self.health))
        return;

// regular death
    sound (self, CHAN_VOICE, "scourge/pain2.wav", 1, ATTN_NORM);        
    scourge_die1 ();
};

void() scourge_void =
{
    monster_void ();
    // Shut off looping sounds.
    StopSound (self, CHAN_VOICE);   //ATTN_NORM
    StopSound (self, CHAN_BODY);    //ATTN_IDLE
};

// REVIVE - - - - - - - - - - - - - - -
void() scourge_revive1 =[ $death4.asc, scourge_revive2 ] {};
void() scourge_revive2 =[ $death3.asc, scourge_revive3 ] {};
void() scourge_revive3 =[ $death2.asc, scourge_revive4 ] {};
void() scourge_revive4 =[ $death1.asc, scourge_pain1   ] {};

// OTHER - - - - - - - - - - - - - - - -
void(float hello) scourge_sight =
{
    if (hello)
        sound (self, CHAN_VOICE, "scourge/idle.wav", 1, ATTN_NORM);
    else
        sound (self, CHAN_VOICE, "scourge/sight1.wav", 1, ATTN_NORM);
};

void() scourge_cache =
{
    precache_model ("progs/scor.mdl");
    precache_model ("progs/h_scourg.mdl");
    precache_model ("progs/spike.mdl");

// Update:  Replaced looped *.wav files with unlooped *1.wav.
//    precache_sound ("misc/null.wav");
    precache_sound ("scourge/idle.wav");
    precache_sound ("scourge/pain.wav");
    precache_sound ("scourge/pain2.wav");
    precache_sound ("scourge/sight1.wav");      // Replaced sight.wav.
    precache_sound ("scourge/tailswng.wav");
    precache_sound ("scourge/walk1.wav");       // Replaced walk.wav.
    precache_sound ("shambler/smack.wav");
//    precache_sound ("weapons/clang.wav");
//    precache_sound ("weapons/rocket1i.wav");
};

//============
// --> QUAKED monster_scourge (1 0 0) (-32 -32 -24) (32 32 64) Ambush
//============
void() monster_scourge =
{
    if (!self.spawned)
    {
        if (noenemies)
            {remove(self); return;}
        scourge_cache ();
    }

    monster_form ("progs/scor.mdl", VEC_HULL2_MIN, VEC_HULL2_MAX, 300, -35);
    self.mdl_head   = "progs/h_scourg.mdl";
    self.mass       = MASS_HEAVY;

    self.th_stand   = scourge_stand1;
    self.th_walk    = scourge_walk1;
    self.th_run     = scourge_run;      // PM:  Formerly scourge_run1.
    self.th_melee   = scourge_melee;
    self.th_missile = scourge_atk1;
    self.th_pain    = scourge_pain;
    self.th_die     = scourge_die;
    //- - - - - - - -
    self.th_sight   = scourge_sight;
    self.th_check   = ScourgeCheckAttack;
    self.th_gib     = scourge_gib;
    self.th_void    = scourge_void;
    self.th_revive  = scourge_revive1;
    self.th_spawn   = monster_scourge;

    self.burn_ofs   = '4 0 8';
    if (soul_evil)
        self.purse      = '2 0.1 1';    // 2 gems max, 10% for 1 gem.
// attack_state set by th_run.
    self.hittype    = HIT_METAL;
    self.trigger_field  = world;

    self.yaw_speed  = 60;
    monster_start ();
};


//===========================/  END OF FILE  /===========================//
