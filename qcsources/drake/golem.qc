/*
==============================================================================

KNIGHT / GOLEM

==============================================================================
*/

$cd id1/models/hk_golem
$origin 0 0 24
$base base
$skin skin

$frame stand1

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9
$frame walk10 walk11 walk12 walk13 walk14 walk15 walk16 walk17
$frame walk18 walk19 walk20

$frame death1 death2 death3 death4 death5 death6 death7 death8
$frame death9 death10 death11 death12

$frame magica1 magica2 magica3 magica4 magica5 magica6 magica7 magica8
$frame magica9 magica10 magica11 magica12 magica13 magica14

$frame magicb1 magicb2 magicb3 magicb4 magicb5 magicb6 magicb7 magicb8
$frame magicb9 magicb10 magicb11 magicb12 magicb13

$frame decap1 decap2 decap3 decap4 decap5 decap6 decap7 decap8
$frame decap9 decap10 decap11 decap12


//===========================================================================

// STAND - - - - - - - - - - - - - - - -
void() kolem_stand  =[ $stand1, kolem_stand ] {ai_stand();};

// WALK/RUN - - - - - - - - - - - - - -
// Walking animation.  Used by walking and running.
void(float mad) kolem_anim =
{
    local   float   move;

    if ((self.walkframe < 0) || (self.walkframe >= 20))
        self.walkframe = 0;

    self.frame = $walk1 + self.walkframe;
    self.walkframe = self.walkframe + 1;

    if (( self.frame == $walk2 ) || ( self.frame == $walk12 ))
    {   // Footstep.
        if (self.flags & FL_ONGROUND)
            sound (self, CHAN_FOOT, "golem/step.wav", 1, ATTN_NORM);
    }

    if (( self.frame == $walk1 ) || ( self.frame == $walk6 ) ||
    ( self.frame == $walk7 ) || ( self.frame == $walk14 ) ||
    ( self.frame == $walk15 ) || ( self.frame == $walk20 ))
        move = 2;
    else if (( self.frame == $walk8 ) || ( self.frame == $walk9 ) ||
    ( self.frame == $walk11 ) || ( self.frame == $walk17 ) ||
    ( self.frame == $walk18 ) || ( self.frame == $walk19 ))
        move = 3;
    else if (( self.frame == $walk4 ) || ( self.frame == $walk5 ) ||
    ( self.frame == $walk10 ) || ( self.frame == $walk12 ) ||
    ( self.frame == $walk16 ))
        move = 4;
    else if (( self.frame == $walk2 ) || ( self.frame == $walk3 ))
        move = 5;
    else //if ( self.frame == $walk13 )
        move = 6;

    if (mad)
        ai_run (move);
    else
        ai_walk (move);
};

void() kolem_reset =
{
    if (( self.frame < $walk1 ) || ( self.frame > $walk20 ))
        self.walkframe = 0;
};

void() kolem_walk2  =[ $walk1,  kolem_walk2  ] {kolem_anim(FALSE);};
void() kolem_walk1  = {kolem_reset(); kolem_walk2();};

void() kolem_run2   =[ $walk1,  kolem_run2   ] {kolem_anim(TRUE);};
void() kolem_run1   = {kolem_reset(); kolem_run2();};

// ATTACK - - - - - - - - - - - - - - -
void() kolem_magic1  =[ $magicb1,  kolem_magic2  ] {ai_face();};
void() kolem_magic2  =[ $magicb2,  kolem_magic3  ] {ai_face();};
void() kolem_magic3  =[ $magicb3,  kolem_magic4  ] {ai_face();};
void() kolem_magic4  =[ $magicb4,  kolem_magic5  ] {ai_face();};
void() kolem_magic5  =[ $magicb5,  kolem_magic6  ] {ai_face();};
void() kolem_magic6  =[ $magicb6,  kolem_magic7  ] {ai_face();};
void() kolem_magic7  =[ $magicb7,  kolem_magic8  ] {ai_face();};
void() kolem_magic8  =[ $magicb8,  kolem_magic9  ] {ai_face();};
void() kolem_magic9  =[ $magicb9,  kolem_magic10 ] {ai_face();
    sound (self, CHAN_WEAPON, "weapons/mirv1.wav", 1, ATTN_NORM);
    M_GoShard ('12 2 24', 0);
    SUB_AttackFinished (5);   // Enforce long delay between shots in non-NM.
};
void() kolem_magic10 =[ $magicb10, kolem_magic11 ] {ai_face(); M_GoShard ('12 2 24', -5); M_GoShard ('12 2 24', 5);};
void() kolem_magic11 =[ $magicb11, kolem_magic12 ] {ai_face(); M_GoShard ('12 2 24', -10); M_GoShard ('12 2 24', 10);};
void() kolem_magic12 =[ $magicb12, kolem_magic13 ] {ai_face();};
void() kolem_magic13 =[ $magicb13, kolem_run1    ] {ai_face();};

// A near-copy of ShamClaw.
void() KolemSword =
{
    if (!self.enemy)
        return;

    local   float   ldmg;

    if (!InMeleeRange (80))    // PM:  Dragons-related.
        return;
    if (!CanDamage (self.enemy, self))
        return;
    if (IsGhost (self.enemy))   // NEW!
        return;     // Cannot hit ghosts.
        
    ldmg = SUB_MeleeDamage (40);
    T_NewDamage (self.enemy, self, self, ldmg, DF_NONE, "melee");
    sound (self, CHAN_VOICE, "shambler/smack.wav", 1, ATTN_NORM);

    makevectors (self.angles);  // PM:  This is new.
    SpawnMeatSpray (self.origin + v_forward*16, crandom() * 100 * v_right, self.enemy.bloodtype);
    SpawnMeatSpray (self.origin + v_forward*16, crandom() * 100 * v_right, self.enemy.bloodtype);
};
void() kolem_smash1  =[ $magica1,  kolem_smash2  ] {ai_face();};
void() kolem_smash2  =[ $magica2,  kolem_smash3  ] {ai_face();};
void() kolem_smash3  =[ $magica3,  kolem_smash4  ] {ai_face();};
void() kolem_smash4  =[ $magica4,  kolem_smash5  ] {ai_face();};
void() kolem_smash5  =[ $magica5,  kolem_smash6  ] {ai_face();};
void() kolem_smash6  =[ $magica6,  kolem_smash7  ] {ai_face();};
void() kolem_smash7  =[ $magica7,  kolem_smash8  ] {ai_face();};
void() kolem_smash8  =[ $magica8,  kolem_smash9  ] {ai_face();};
void() kolem_smash9  =[ $magica9,  kolem_smash10 ] {ai_face(); KolemSword();};
void() kolem_smash10 =[ $magica10, kolem_smash11 ] {ai_face();};
void() kolem_smash11 =[ $magica11, kolem_smash12 ] {ai_face();};
void() kolem_smash12 =[ $magica12, kolem_smash13 ] {ai_face();};
void() kolem_smash13 =[ $magica13, kolem_smash14 ] {ai_face();};
void() kolem_smash14 =[ $magica14, kolem_run1    ] {ai_face();};
void() kolem_melee =
{
    if (InMeleeRange (80))
    {
        sound (self, CHAN_WEAPON, "hknight/slash1.wav", 1, ATTN_NORM);
        kolem_smash1 ();
    }
    else
        ai_charge (4);      // Not close enough -- continue march.
};

// PAIN - - - - - - - - - - - - - - - -
void(entity attacker, float damage) kolem_grunt =
{
// Normal pain routine.
    if (self.pain_finished > time)
        return;

// Golem never goes into pain anims.  Sound is all.
    sound (self, CHAN_VOICE, "hknight/grunt.wav", 1, ATTN_NORM);
    self.pain_finished = time + 2;

    attacker = attacker;  damage = damage;      // Appease FrikQcc.
};

void(entity attacker, float damage) kolem_pain =
{
// Enable missile attack if damaged enough.
    if (!self.th_missile)
    {   // Update:  Enable when damaged even once.
        if (self.health < self.max_health)  //(self.health <= self.max_health / 2)
            self.th_missile = kolem_magic1;
    }
    kolem_grunt (attacker, damage);
};

// DEATH - - - - - - - - - - - - - - - -
float(float dm) kolem_gib =
{
// check for gib
    if (self.health < self.gib_health)
    {
        local   float   mx;

        monster_drop ();    // Let it drop loot when smashed.

        sound (self, CHAN_VOICE, "misc/wallbrk.wav", 1, ATTN_NORM);
        mx = self.skin;     // Need to change self.skin for rubble*.mdl.
        self.skin = floor(self.skin / 2);
        ThrowIt ("progs/st_gib1.mdl", dm, GIBx_STATUE|GIB_SKIN_MATCH);
        ThrowIt ("progs/st_gib2.mdl", dm, GIBx_STATUE|GIB_SKIN_MATCH);
        ThrowIt ("progs/st_gib3.mdl", dm, GIBx_STATUE|GIB_SKIN_MATCH);
        self.skin = mx;     // Restore old skin.
        ThrowIt ("progs/h_hkolem.mdl", dm, GIBx_STATUE|GIB_HEAD);
        return TRUE;
    }
    return FALSE;
};

void() kolem_die1  =[ $death1,  kolem_die2  ] {ai_forward(10);};
void() kolem_die2  =[ $death2,  kolem_die3  ] {ai_forward(8);};
void() kolem_die3  =[ $death3,  kolem_die4  ] {ai_forward(7);};
void() kolem_die4  =[ $death4,  kolem_die5  ] {};
void() kolem_die5  =[ $death5,  kolem_die6  ] {};
void() kolem_die6  =[ $death6,  kolem_die7  ] {self.nextthink = time + 0.5;};
void() kolem_die7  =
{
    self.health = self.gib_health - 1;
    kolem_gib (-50);
};

void() kolem_die =
{
// check for gib
    if (kolem_gib (self.health))
        return;

// regular death
    sound (self, CHAN_VOICE, "golem/death.wav", 1, ATTN_NORM);
    kolem_die1 ();
};


//============================================================================

// STATUES - - - - - - - - - - - - - - -
void() kolem_use =
{
    self.xsf = self.xsf | XSF_STATUE;   // So monstart doesn't set think.
    monster_start_go ();
    self.takedamage = DAMAGE_AIM;
    kolem_run1 ();
};

void() kolem_statue_start = {statue_start (kolem_use);};

// OTHER - - - - - - - - - - - - - - - -
void(float hello) kolem_sight =
{
// No greeting sound.  Just croak if mad at something.
    if (!hello)
        sound (self, CHAN_VOICE, "golem/sight.wav", 1, ATTN_NORM);
};

void() kolem_cache =
{
    precache_model ("progs/akarrow.mdl");
    precache_model ("progs/hk_golem.mdl");
    precache_model ("progs/h_hkolem.mdl");
    precache_model ("progs/st_gib1.mdl");
    precache_model ("progs/st_gib2.mdl");
    precache_model ("progs/st_gib3.mdl");

    precache_sound ("golem/death.wav");
    precache_sound ("golem/sight.wav");
    precache_sound ("golem/step.wav");
    precache_sound ("hknight/grunt.wav");
    precache_sound ("hknight/slash1.wav");
    precache_sound ("misc/wallbrk.wav");
    precache_sound ("shambler/smack.wav");
    precache_sound ("weapons/mirv1.wav");   // In case MIRV is forbidden.
};

//============
// QUAKED monster_golem (1 0 0) (-16 -16 -24) (16 16 40) Ambush x Statue
//============
void() monster_golem =
{
    if (!self.spawned)
    {
        if (noenemies)
            {remove (self); return;}
        kolem_cache ();
    }

    local   float   hp;

    if (!respawning)
        self.skin = (random() * 2) & 1;
    hp = 500;
    monster_form ("progs/hk_golem.mdl", '-16 -16 -24', '16 16 40', hp, -80);
    self.mdl_head   = "progs/h_hkolem.mdl";
    self.mass       = MASS_SUPER;

    self.th_stand   = kolem_stand;
    self.th_walk    = kolem_walk1;
    self.th_run     = kolem_run1;
    // No missile attack, yet.
    // Update:  If summoned by necro boss, give the missile attack now!
    if (self.spawned)
        if (self.master.classname == "monster_necromancer")
            self.th_missile = kolem_magic1;
    self.th_melee   = kolem_melee;
    self.th_pain    = kolem_pain;
    // No pain -- it's a monolith of stone!
    self.th_die     = kolem_die;
    //- - - - - - - -
    self.th_sight   = kolem_sight;
    self.th_gib     = kolem_gib;
    self.th_spawn   = monster_golem;

    self.bloodtype  = -1;   // Stone.
    self.family     = FAM_BANE;
    self.xfl        = XFL_ARMORED;
    self.hittype    = HIT_STONE;
    if (soul_evil)
        monster_purse (2, 1, 1);    // Two gems, assume they're his eyeballs.

    if (!respawning)
    if (self.spawnflags & SPAWN_STATUE)
    {   // Statue stuff.
        if (self.spawnflags & SPAWNx_DELAY)
        {   // Conflict, sf64 overrides statue.
            // FIXME:  Resolve conflict so that statue can delay spawn.
            self.spawnflags = self.spawnflags - (self.spawnflags & SPAWN_STATUE);
        }
        else
        {   // Golem becomes a statue.
            // Note:  Don't let statues use sf64.
            self.takedamage = DAMAGE_NO;
            self.nextthink  = time + 0.2;
            self.think      = kolem_statue_start;
            return;
        }
    }
    monster_start ();
};


//===========================/  END OF FILE  /===========================//
