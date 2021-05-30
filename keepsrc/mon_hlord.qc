/*
==============================================================================

KNIGHT

==============================================================================
*/

$cd id1/models/knight2
$origin 0 0 24
$base base
$skin skin

// 000-008
$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9

// 009-028
$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9
$frame walk10 walk11 walk12 walk13 walk14 walk15 walk16 walk17
$frame walk18 walk19 walk20

// 029-036
$frame run1 run2 run3 run4 run5 run6 run7 run8

// 037-041
$frame pain1 pain2 pain3 pain4 pain5

// 042-053
$frame death1 death2 death3 death4 death5 death6 death7 death8
$frame death9 death10 death11 death12

// 054-062
$frame deathb1 deathb2 deathb3 deathb4 deathb5 deathb6 deathb7 deathb8
$frame deathb9

// 063-078
$frame char_a1 char_a2 char_a3 char_a4 char_a5 char_a6 char_a7 char_a8
$frame char_a9 char_a10 char_a11 char_a12 char_a13 char_a14 char_a15 char_a16

// 079-092
$frame magica1 magica2 magica3 magica4 magica5 magica6 magica7 magica8
$frame magica9 magica10 magica11 magica12 magica13 magica14

// 093-105
$frame magicb1 magicb2 magicb3 magicb4 magicb5 magicb6 magicb7 magicb8
$frame magicb9 magicb10 magicb11 magicb12 magicb13

// 106-111
$frame char_b1 char_b2 char_b3 char_b4 char_b5 char_b6

// 112-121
$frame slice1 slice2 slice3 slice4 slice5 slice6 slice7 slice8 slice9 slice10

// 122-132
$frame smash1 smash2 smash3 smash4 smash5 smash6 smash7 smash8 smash9 smash10
$frame smash11

// 133-154
$frame w_attack1 w_attack2 w_attack3 w_attack4 w_attack5 w_attack6 w_attack7 
$frame w_attack8 w_attack9 w_attack10 w_attack11 w_attack12 w_attack13 w_attack14
$frame w_attack15 w_attack16 w_attack17 w_attack18 w_attack19 w_attack20 
$frame w_attack21 w_attack22 

// 155-165
$frame magicc1 magicc2 magicc3 magicc4 magicc5 magicc6 magicc7 magicc8
$frame magicc9 magicc10 magicc11

float       hknight_type;

// Makes the Bane gray and ghostly.  Called by 'painc' and 'magice' series.
void() bane_gray = {
    if (self.health <= self.waitmin)
    {   // Set up clone magic.
        self.health     = self.waitmin; // Yes, reset health.
        self.waitmax    =           // If lower than min, then max too.
        self.waitmin    = 0;        // Cannot use clone trick again.
        self.cnt        = skill;    // Number of clones to spawn.
        if (cranked)
            self.cnt        = self.cnt + 1;
    }
    else
        self.cnt        = 0;
    // Now the Bane becomes a phantom as he shadow walks.
    self.touch      = SUB_Null;     // In case of jump attack.
    self.takedamage = DAMAGE_NO;
    self.solid      = SOLID_NOT;
    self.skin       = SKIN_BANE_GRAY;   // Use grayscale Bane.
};

// Taking a hint from the axeman...
// Update:  Removed 'ai_forward(6);' from first frame to stop stack overflow.
void() bane_pain1 =[ $pain1, bane_pain2   ] {};
void() bane_pain2 =[ $pain2, bane_pain3   ] {ai_forward(8);};
void() bane_pain3 =[ $pain4, bane_pain4   ] {ai_forward(4);};
void() bane_pain4 =[ $pain5, hknight_run1 ] {ai_forward(2);};

void() bane_painb1=[ $pain1, bane_pain3   ] {};

// This pain makes the Bane pull the log trick from Naruto,
// only leave behind a fading image of the Bane instead of a log.
void() bane_painc1=[ $pain1, bane_magice9 ]
{
    bane_gray();
    bane_shadow();
    self.nextthink  = time + 0.5;
    self.modelindex = 0;
    EntryPoint_Spawn (self, self.enemy, self.enemy.origin, EntryPoint_Random);
};

void() hkfast_pain1    =[ $pain1, hknight_pain4 ] {};

float   BANE_CHAT       = 1;
float   BANE_RAGE       = 2;
float   BANE_CLONE      = 4;

// Broadcast message to players as if the Bane was a client.
void(string text) Bane_Speaks = {
    local   entity  pl;

    pl = find(world, classname, "player");
    while (pl) {
        sound (pl, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NORM);
        pl = find(pl, classname, "player");
    }
    bprint (text);
};

void() bane_die = {
	// ... You win... for now. (Ôèå Âáîåº ®®® Ùïõ ÷éî®®® æïò îï÷®)
	// ... I'll be back! (Ôèå Âáîåº ®®® Éàìì âå âáãë¡)
	// ... I will return! (Ôèå Âáîåº ®®® É ÷éìì òåôõòî¡)
	// ... We will meet again! (Ôèå Âáîåº ®®® ×å ÷éìì íååô áçáéî¡)
	// Update:  New taunts hinting of nsoe6.
    if (random() < 0.5)     // ... I still have the runes!
        Bane_Speaks ("Ôèå Âáîåº ®®® É óôéìì èáöå ôèå òõîåó¡\n");
    else                    // ... You have not won yet!
        Bane_Speaks ("Ôèå Âáîåº ®®® Ùïõ èáöå îïô ÷ïî ùåô¡\n");
    hknight_die ();
};


//============================================================================

// REVIVE - - - - - - - - - - - - - - -
void() hknight_revive1   =[ $death11,   hknight_revive2   ] {};
void() hknight_revive2   =[ $death10,   hknight_revive3   ] {};
void() hknight_revive3   =[ $death9,    hknight_revive4   ] {};
void() hknight_revive4   =[ $death8,    hknight_revive5   ] {};
void() hknight_revive5   =[ $death7,    hknight_revive6   ] {};
void() hknight_revive6   =[ $death6,    hknight_revive7   ] {};
void() hknight_revive7   =[ $death5,    hknight_revive8   ] {};
void() hknight_revive8   =[ $death4,    hknight_revive9   ] {};
void() hknight_revive9   =[ $death3,    hknight_revive10  ] {};
void() hknight_revive10  =[ $death2,    hknight_revive11  ] {};
void() hknight_revive11  =[ $death1,    hknight_revive12  ] {};
void() hknight_revive12  =[ $stand1,    hknight_run1      ] {};

void() hknight_reviveb1  =[ $deathb8,   hknight_reviveb2  ] {};
void() hknight_reviveb2  =[ $deathb7,   hknight_reviveb3  ] {};
void() hknight_reviveb3  =[ $deathb6,   hknight_reviveb4  ] {};
void() hknight_reviveb4  =[ $deathb5,   hknight_reviveb5  ] {};
void() hknight_reviveb5  =[ $deathb4,   hknight_reviveb6  ] {};
void() hknight_reviveb6  =[ $deathb3,   hknight_reviveb7  ] {};
void() hknight_reviveb7  =[ $deathb2,   hknight_reviveb8  ] {};
void() hknight_reviveb8  =[ $deathb1,   hknight_revive12  ] {};

void() hknight_revive =
{
    if ( self.frame == $deathb9 )
        hknight_reviveb1 ();
    else //if ( self.frame == $death10 )
        hknight_revive1 ();
};


//============================================================================
// BANE JUMP

void() Bane_JumpTouch;
void(float d) hk_charge;

// We need these first three jump frame functions in case the Bane
// needs to jump again without selecting other random attacks.
void() bane_jump1   =[ $char_a1,  bane_jump2 ] {hk_charge(20);
    sound (self, CHAN_WEAPON, "hknight/slash1.wav", 1, ATTN_NORM);
};
void() bane_jump2   =[ $char_a2,  bane_jump3 ] {hk_charge(18);};
void() bane_jump3   =[ $char_a3,  bane_jump4 ] {hk_charge(16);};
void() bane_jump4   =[ $char_a4,  bane_jump5 ]
{
    if (self.health <= 0)
        {self.touch = SUB_Null;  self.think = hknight_die1;  return;}

    local   float   g;

    g = cvar("sv_gravity") / 800;

    ai_face();
    // Bane is a bbeg, so don't bother with invisibility shenanigans.
    // Ditto for the dark lord.
    self.touch = Bane_JumpTouch;
    makevectors (self.angles);
    self.velocity = (v_forward * 600) + ('0 0 250' * g);
    self.flags = self.flags - (self.flags & FL_ONGROUND);
};
// Standard demon jumps reach level ground in about 0.5 sec in normal g.
void() bane_jump5   =[ $char_a5,  bane_jump6 ] {self.nextthink = time + 0.5;};
// If three seconds pass, assume stuck then jump again.
void() bane_jump6   =[ $char_a6,  bane_jump1 ] {self.nextthink = time + 3;};
void() bane_jump7   =[ $char_a8,  hknight_char_a10 ] {};

void() Bane_JumpTouch = {
    local   float   ldmg;

    if (self.health <= 0) return;
        
    if (other.takedamage) {
        if ( vlen(self.velocity) > 400 ) {
            ldmg = 40 + 10*random();
			ldmg = Align_DamageModifier(other,self,ldmg, TRUE);
            T_Damage (other, self, self, ldmg, DAMARMOR);    
            if (self.health <= 0) return;     // PM:  Killed by thorns (empathy shields).
            if (( self.frame == $char_a4 ) || ( self.frame == $char_a5 )) {
                self.frame = $char_a6;  // Go to a stab frame.
                sound (self, CHAN_WEAPON, "drake/weapons/axhit.wav", 1, ATTN_NORM);
            }
        }
    }

    if (!checkbottom(self)) {
        if (self.flags & FL_ONGROUND)
        {    // jump randomly to not get hung up
//dprint ("popjump\n");
            self.touch = SUB_Null;
            self.think = bane_jump1;
            self.nextthink = time + 0.1;
        }
        return;    // not on ground yet
    }

    self.touch = SUB_Null;
    self.think = bane_jump7;
    self.nextthink = time + 0.1;
};

float() CheckBaneJump = {
    local   vector  dist;
    local   float   d;

// FIXME:  Check if jump will land on solid ground.

// Elevation check done in CheckForCharge.
//    d = self.enemy.origin_z + self.enemy.mins_z;
//    if (self.origin_z + self.mins_z > d + 0.75 * self.enemy.size_z)
//        return FALSE;       // Target is too low.
//    if (self.origin_z + self.maxs_z < d + 0.25 * self.enemy.size_z)
//        return FALSE;       // Target is too high.

    dist = self.enemy.origin - self.origin;
    dist_z = 0;
    d = vlen(dist);
    if (d < 100)
        return FALSE;       // Target is too close.
//    if (d > 200)
//        if (random() < 0.9)
//            return FALSE;
    if (d > 1000)
        return FALSE;       // Target is too far away.
    return TRUE;
};

// BANE AI
//============================================================================
void(float dist) ai_run_strafe;

void() bane_strafe = {
    if (self.classname == "monster_bane") {
        // Strafing distance was defined by movedist, which could be
        // anything.  Drake has removed movedist, and since this progs
        // is based on Drake, set distance here.

        self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
        ChangeYaw ();
        bane_shadow ();     // Shadow trails, like shadow kick.
        ai_run_strafe (20);     // Player walk speed.
    }
};

void() hk_face = {ai_face();  bane_strafe();};

//============================================================================
// ATTACK #1 (Modified for Lightning Airstrike)

// Here for incidental damage in case enemy runs up to melee range while
// the sword is coming down during the magica animation.
void() magica_sword_chop = {
    local   float   ldmg;
    local   vector  delta;
    
    ai_face (); // movement done elsewhere.
    delta = self.enemy.origin - self.origin;
    if (!InMeleeRange (80)) return; // 100 is too long.
    if (!CanDamage (self.enemy, self)) return;

    sound (self, CHAN_WEAPON, "drake/weapons/axhit.wav", 1, ATTN_NORM);
    makevectors (self.angles);
    ldmg = 20 + 10*random();    // Player normally does 20 damage with axe.
    T_Damage (self.enemy, self, self, ldmg, DAMARMOR);
    SpawnMeatSpray (self, self.enemy, (crandom() * 50) + 50);
};

// Bane summons a thunderstorm.
void() bane_magica1  =[ $magica1,  bane_magica2  ] {bane_storm( $magica1, $magica13 ); hk_face();};
void() bane_magica2  =[ $magica2,  bane_magica3  ] {hk_face();};
void() bane_magica3  =[ $magica3,  bane_magica4  ] {hk_face();};
void() bane_magica4  =[ $magica4,  bane_magica5  ] {hk_face();};
void() bane_magica5  =[ $magica5,  bane_magica6  ] {hk_face();};
void() bane_magica6  =[ $magica6,  bane_magica7  ] {hk_face();};
void() bane_magica7  =[ $magica7,  bane_magica8  ] {hk_face();};
void() bane_magica8  =[ $magica8,  bane_magica9  ] {hk_face();};
void() bane_magica9  =[ $magica9,  bane_magica10 ] {hk_face(); magica_sword_chop();};
void() bane_magica10 =[ $magica10, hknight_magica11 ] {hk_face();};
//void() bane_magica10 =[ $magica10, bane_magica11 ] {hk_face();};
//void() bane_magica11 =[ $magica11, bane_magica12 ] {hk_face();};
//void() bane_magica12 =[ $magica12, bane_magica13 ] {hk_face();};
//void() bane_magica13 =[ $magica13, bane_magica14 ] {hk_face();};
//void() bane_magica14 =[ $magica14, hknight_run1  ] {hk_face();};

void() darklord_magica1  =[ $magica1,  darklord_magica2  ] {hk_face();};
void() darklord_magica2  =[ $magica2,  darklord_magica3  ] {hk_face();};
void() darklord_magica3  =[ $magica3,  darklord_magica4  ] {hk_face();};
void() darklord_magica4  =[ $magica4,  darklord_magica5  ] {hk_face();};
void() darklord_magica5  =[ $magica5,  darklord_magica6  ] {hk_face();
    ReflectorShield (self);
    sound(self, 6, "items/protect.wav", 1, ATTN_NORM);
    self.pain_finished = time + 1;      // Uninterruptable by this point.
};
void() darklord_magica6  =[ $magica6,  darklord_magica7  ] {hk_face();};
void() darklord_magica7  =[ $magica7,  darklord_magica8  ] {hk_face();};
void() darklord_magica8  =[ $magica8,  darklord_magica9  ] {hk_face();};
void() darklord_magica9  =[ $magica9,  darklord_magica10 ] {hk_face(); magica_sword_chop();};
void() darklord_magica10 =[ $magica10, hknight_magica11  ] {hk_face();
    makevectors (self.angles);
    M_Slam (self.origin + v_forward*46);
    self.waitmin = time + 5;
};

// Hell Lords rain meteors down.
void() lord_meteor = {boss_meteor('50 0 100', 300, FALSE, FALSE);};
void() lord_magica7  =[ $magica7,  lord_magica8     ] {hk_face(); lord_meteor();};
void() lord_magica8  =[ $magica8,  lord_magica9     ] {hk_face(); if (skill >= 3) lord_meteor();};
void() lord_magica9  =[ $magica9,  lord_magica10    ] {hk_face(); magica_sword_chop();};
void() lord_magica10 =[ $magica10, hknight_magica11 ] {hk_face();};

//============================================================================
// ATTACK #2 (Modified for Fireball)

// Hell Lords launches more magic missiles.  Bane launches more fireballs.
void() lord_magicb6  =[ $magicb6,  lord_magicb7     ] {hknight_shot(0); bane_strafe();};
void() lord_magicb7  =[ $magicb7,  lord_magicb8     ] {hknight_shot(-1); bane_strafe();};
void() lord_magicb8  =[ $magicb8,  lord_magicb9     ] {hknight_shot(0); bane_strafe();};
void() lord_magicb9  =[ $magicb9,  lord_magicb10    ] {hknight_shot(1); bane_strafe();};
void() lord_magicb10 =[ $magicb10, hknight_magicb11 ] {hknight_shot(0); bane_strafe();};

void() darklord_magicb6  =[ $magicb6,  darklord_magicb7  ] {hk_face();};
void() darklord_magicb7  =[ $magicb7,  darklord_magicb8  ] {hk_face();};
void() darklord_magicb8  =[ $magicb8,  darklord_magicb9  ] {hk_face(); hknight_shot(0);
    local   vector  org;

    makevectors (self.angles);
    org = self.origin + (v_forward*16) + (v_right*2) + (v_up*24);
    MakeFancy (org, X32_STAR_RED, 2);
    self.effects = self.effects | EF_MUZZLEFLASH;
    sound (self, CHAN_WEAPON, "rogue/plasma/fire.wav", 1, ATTN_NORM);
//    SUB_AttackFinished (3);
    M_Reload (3);   // Three second delay before next salvo in non-NM.
};
void() darklord_magicb9  =[ $magicb9,  darklord_magicb10 ] {hk_face(); hknight_shot(-1);};
void() darklord_magicb10 =[ $magicb10, hknight_magicb11  ] {hk_face(); hknight_shot(1);};

// ATTACK #4 (Firewall -- Used by Hell Lords)
void() hknight_magicd1  =[ $magica1,  hknight_magicd2  ] {hk_face();};
void() hknight_magicd2  =[ $magica14, hknight_magicd3  ] {hk_face();};
void() hknight_magicd3  =[ $magica13, hknight_magicd4  ] {hk_face();};
void() hknight_magicd4  =[ $magica12, hknight_magicd5  ] {hk_face();};
void() hknight_magicd5  =[ $magica11, hknight_magicd6  ] {hk_face(); sound (self, CHAN_WEAPON, "drake/weapons/fwalltap.wav", 1, ATTN_NORM);};
void() hknight_magicd6  =[ $magica10, hknight_magicd7  ] {hk_face();};
void() hknight_magicd7  =[ $magica9,  hknight_magicd8  ] {hk_face(); M_Firewall();};
void() hknight_magicd8  =[ $magica8,  hknight_magicd9  ] {hk_face();};
void() hknight_magicd9  =[ $magica4,  hknight_magicd10 ] {hk_face();};
void() hknight_magicd10 =[ $magica3,  hknight_magicd11 ] {hk_face();};
void() hknight_magicd11 =[ $magica2,  hknight_magicd12 ] {hk_face();};
void() hknight_magicd12 =[ $magica1,  hknight_run1     ] {hk_face();};

//============================================================================
// ATTACK #5 (Wrath Summoning -- Used by Dark Lords)

// void() monster_wrath;
// void() wrath_grow1;

// FIXME:  Wrath summoning uses old code that needs updating.
void() dk_shield;
void() darklord_magicd1  =[ $magica1,  darklord_magicd2  ] {hk_face();};
void() darklord_magicd2  =[ $magica14, darklord_magicd3  ] {hk_face();};
void() darklord_magicd3  =[ $magica13, darklord_magicd4  ] {hk_face();};
void() darklord_magicd4  =[ $magica12, darklord_magicd5  ] {hk_face();};
void() darklord_magicd5  =[ $magica11, darklord_magicd6  ] {hk_face();};
void() darklord_magicd6  =[ $magica10, darklord_magicd7  ] {hk_face();};
void() darklord_magicd7  =[ $magica9,  hknight_magicd8   ] {hk_face(); /*SpawnMonster_Horde(ID_MP2_WRATH, 3);*/ dk_shield();};

//============================================================================
// ATTACK #6 (Monster Resurrection -- Bane exclusive)

void() bane_magicd1  =[ $magica1,  bane_magicd2  ] {ai_ritual();};
void() bane_magicd2  =[ $magica14, bane_magicd3  ] {ai_ritual();};
void() bane_magicd3  =[ $magica13, bane_magicd4  ] {ai_ritual();};
void() bane_magicd4  =[ $magica12, bane_magicd5  ] {ai_ritual();};
void() bane_magicd5  =[ $magica11, bane_magicd6  ] {ai_ritual();};
void() bane_magicd6  =[ $magica10, bane_magicd7  ] {ai_ritual();};
void() bane_magicd7  =[ $magica9,  bane_magicd8  ] {ai_ritual();};
void() bane_magicd8  =[ $magica8,  bane_magicd12 ] {ai_ritual(); self.fallen = world;};
//void() bane_magicd9  =[ $magica7,  bane_magicd10  ] {};
//void() bane_magicd10 =[ $magica6,  bane_magicd11 ] {};
//void() bane_magicd11 =[ $magica5,  bane_magicd12 ] {};
void() bane_magicd12 =[ $magica4,  bane_magicd13 ] {};
void() bane_magicd13 =[ $magica3,  bane_magicd14 ] {};
void() bane_magicd14 =[ $magica2,  bane_magicd15 ] {};
void() bane_magicd15 =[ $magica1,  hknight_run1  ] {};

//  Clones
void() clone_die = {
	// Copied from 'eyes.qc'...
    self.takedamage = DAMAGE_NO;    // PM:  Needed in Drake.
    self.modelindex = 0;
    self.solid      = SOLID_NOT;
    self.movetype   = MOVETYPE_NONE;
	// Use ten seconds in case of clone spawned thunderstorm.
    self.nextthink  = time + 5;     // Delay removal so obituaries work.
    self.think      = SUB_Remove;
    Burn_Null (self);
    spawn_tfog (self.origin); // Poof!
};

void() clone_spawn = {
    local entity kage;       // Watching too much Naruto, eh?

    kage = spawn();
    copyentity (self, kage);
    setorigin (kage, self.origin);
    EntryPoint_Spawn (kage, self, self.origin, EntryPoint_Random);
    kage.targetname = kage.killtarget = kage.target = kage.target2 = string_null;
    kage.spawned    = TRUE;
    kage.th_die     = clone_die;
    kage.owner     = self;
    kage.xfl        = kage.xfl - (kage.xfl & XFL_ADD_TO_KILL); // Clones automatically vanish when their owner dies, so don't count them.  One for all and all for one.
};

//============================================================================
// ATTACK #7 (Teleportation and Cloning -- also Bane exclusive)

void() bane_magice1  =[ $magicb1,  bane_magice2  ] {bane_gray(); hk_face();};
void() bane_magice2  =[ $magicb2,  bane_magice3  ] {hk_face();};
void() bane_magice3  =[ $magicb3,  bane_magice4  ] {hk_face();};
void() bane_magice4  =[ $magicb4,  bane_magice5  ] {hk_face();};
void() bane_magice5  =[ $magicb5,  bane_magice6  ] {hk_face();};
void() bane_magice6  =[ $magicb6,  bane_magice7  ] {hk_face();};
void() bane_magice7  =[ $magicb7,  bane_magice8  ] {hk_face();};
void() bane_magice8  =[ $magicb8,  bane_magice9  ] {hk_face();
// Disappear then teleport.
    self.nextthink  = time + 1;
    self.modelindex = 0;
    if (self.cnt > 0)
        EntryPoint_Spawn (self, self, self.origin, EntryPoint_Random);
    else
    {   if (!EntryPoint_Spawn (self, self.enemy, self.enemy.origin, EntryPoint_LongRandom))
            EntryPoint_Spawn (self, self, self.origin, EntryPoint_Random);
    }
};
void() bane_magice9  =[ $magicb8,  bane_magice10 ] {self.alpha = 0.2;
    self.modelindex = self.mindex2;
    hk_face();
    if (self.cnt > 0) {
        self.cnt = self.cnt - 1;    // Do before cloning.
        // Don't let the clones spawn more clones.
        if (self.owner.classname != self.classname)
            clone_spawn();      // Only the master can clone himself.
    }
};
void() bane_magice10 =[ $magicb8,  bane_magice11 ] {self.alpha = 0.4; hk_face();};
void() bane_magice11 =[ $magicb9,  bane_magice12 ] {self.alpha = 0.6; hk_face();};
void() bane_magice12 =[ $magicb10, bane_magice13 ] {self.alpha = 0.8; hk_face();};
void() bane_magice13 =[ $magicb11, bane_magice14 ] {self.alpha = 0; hk_face();
    if (self.cnt < 1) {
		if (walkmove (0, 0)) {
            self.takedamage = DAMAGE_AIM;
            self.solid      = SOLID_SLIDEBOX;
            self.skin       = SKIN_BANE;
			// Last minute feature:  The Bane speaks!
            if (!self.master)
            if (self.height) {
                if (self.height & BANE_CLONE) {
                    if (random() < 0.5)     // Die, maggot!
                        Bane_Speaks ("Ôèå Âáîåº Äéå¬ íáççïô¡\n");
                    else                    // Now die!
                        Bane_Speaks ("Ôèå Âáîåº Îï÷ äéå¡\n");
                } else if (self.height & BANE_RAGE) {
                    if (random() < 0.5)     // Behold my power!
                        Bane_Speaks ("Ôèå Âáîåº Âåèïìä¬ íù ðï÷åò¡\n");
                    else                    // Feel my wrath!
                        Bane_Speaks ("Ôèå Âáîåº Æååì íù ÷òáôè¡\n");
                }
                self.height = BANE_CHAT;
            }
            return;
        }
    }
	// Either not done cloning, or unable to move at current location.
	// Either way, use dimensional travel magic again.
    self.think = bane_magice8;
};

void() bane_magice14 =[ $magicb12, bane_magice15 ] {hk_face();};
void() bane_magice15 =[ $magicb13, hknight_run1  ] {hk_face();};

void() hknight_magic = {
//    if (cranked && (random() < 0.25))
//        hknight_magica1 ();
//    else
        hknight_magicc1 ();
};

void() lord_magic = {
    local float r, add, opt;

    add = 1;
    opt = 2;
    if (M_FirewallCheck ()) opt = opt + 1;
    if (M_MeteorCheck ('50 0 112')) {add = 0;  opt = opt + 1;} // Using 50 and 100 as sides of a right triangle, hypotenuse is 111.8.
    r = random() * opt + add;
    if (r <= 1)
        hknight_magica1 ();     // Meteor
    else if (r <= 2)
        hknight_magicb1 ();     // Magic missile straight
    else if (r <= 3)
        hknight_magicc1 ();     // Magic missile spread
    else
        hknight_magicd1 ();     // Firewall
};

// FIXME:  Is this done aside from missing corpse scan/use?
void() darklord_magic = {
// Todo:
// If close, use slam, charge, or melee.
// else, shoot or summon.
    local   float   dist;

// FIXME:  Check for corpses to make wraths from.
//    if (self.minion_count < skill)
//        if (random() < 0.1)
//    if (random() < (skill - self.minion_count) * 0.1)
    if (self.spawnflags & 2)
        if (self.minion_count < 1)
            if (self.waitmax < time)
                {darklord_magicd1 ();  return;}

// Attacking...
    dist = vlen(self.enemy.origin - self.origin);
    if (dist <= DARKLORD_NEAR)
    {
        if (self.waitmin < time)
            {darklord_magica1();  return;}  // Thor's hand.
        CheckForCharge ();
        if (( self.frame == $char_a1 ) || ( self.frame == $char_b1 ))
            return;
    }
    hknight_magicb1 ();     // Magic missile straight
};

void() hkboss_magic = {
	local float r;

	self.meleeattack = self.meleeattack + 1;
	if (self.meleeattack > 255) self.meleeattack = 0; // capture fix from Drake's AddOne() but don't use global float aka gloat

	// Pattern:  1 pillar, 2 bombs, 1 spray.
	// Old behavior should be magica->magicb->magicc, but it seemed to favor B?
    r = self.meleeattack & 3;
    if (!r)
        hknight_magica1 ();
    else if (r != 3)
        hknight_magicb1 ();
    else
        hknight_magicc1 ();
};

void() bane_magic = {
	// PM:  Jumping done at charge anim.  However...
	// If enemy is low enough that CheckForCharge would abort, then we can
	// check for jumping.  We want the Bane to occasionally jump down toward
	// the enemy, much like old SoE.
	// Update:  If enemy is above, try to teleport to higher ground occasionally.
    if (random() < 0.25) {
        if (CheckBaneJump ()) {
            if (self.origin_z - self.enemy.origin_z > 20) {bane_jump1 ();  return;}
            if (!self.waitmax && ((self.enemy.origin_z - self.origin_z) > 20)) {bane_magice1 ();  return;} // Only if using new AI.
        }
	}

	// Check for thunderstorm.
    if (!self.waitmax)
        if (skill >= 1)
            if (!bane_has_storm ())
                if (random() < 0.5)
                    if (UpIsSky (self.enemy.origin)) {bane_magica1 ();  return;}   // Start a thunderstorm!

	// Spray some fireballs.
    if (random() <= 0.5)
        hknight_magicb1 ();
    else
        hknight_magicc1 ();
};

void(float side) bane_melee = {
    local   float   ldmg;
    local   vector  delta;

    if ((self.classname != "monster_bane") && (self.classname != "monster_dark_lord")) return;
    
    ai_face (); // movement done elsewhere.
    delta = self.enemy.origin - self.origin;
    if (!InMeleeRange (80)) return; // 100 is too long.
    if (!CanDamage (self.enemy, self)) return;
    // Let the Bane hit ghosts.  He's just that badass.
    // Update:  Dark Lord is Bane-Lite, at least in human form...
    sound (self, CHAN_WEAPON, "drake/bane/hit.wav", 1, ATTN_NORM);
    makevectors (self.angles);
    ldmg = 10 + 5*random();
    T_Damage (self.enemy, self, self, ldmg, DAMARMOR);
    SpawnMeatSpray(self, self.enemy, (crandom() * 50) + (50 * side));
};

void(float d) hk_charge = {
    local float dist;

    if ((self.classname == "monster_bane") || (self.classname == "monster_dark_lord")) {
        dist = d * 2;
        if (!QC_CloseEnough (dist)) d = dist;   // Move double speed.
    }
    ai_charge (d);
};

void() bane_slice1  =[ $slice1,  bane_slice2  ] {hk_charge(9);};
void() bane_slice2  =[ $slice3,  bane_slice3  ] {monster_footstep(FALSE); hk_charge(19);};
void() bane_slice3  =[ $slice5,  bane_slice4  ] {hk_charge(11); bane_melee(-200); ai_melee();};
void() bane_slice4  =[ $slice6,  bane_slice5  ] {hk_charge(15); ai_melee();};
void() bane_slice5  =[ $slice7,  bane_slice6  ] {monster_footstep(FALSE); hk_charge(8); ai_melee();};
void() bane_slice6  =[ $slice9,  bane_slice7  ] {hk_charge(2); ai_melee();};
void() bane_slice7  =[ $slice10, hknight_run1 ] {hk_charge(3);};

void() bane_smash1  =[ $smash2,  bane_smash2  ] {hk_charge(14);};
void() bane_smash2  =[ $smash4,  bane_smash3  ] {monster_footstep(FALSE); hk_charge(20);};
void() bane_smash3  =[ $smash5,  bane_smash4  ] {hk_charge(10); bane_melee(0); ai_melee();};
void() bane_smash4  =[ $smash6,  bane_smash5  ] {hk_charge(7); ai_melee();};
void() bane_smash5  =[ $smash7,  bane_smash6  ] {hk_charge(12); ai_melee();};
void() bane_smash6  =[ $smash8,  bane_smash7  ] {hk_charge(2); ai_melee();};
void() bane_smash7  =[ $smash9,  bane_smash8  ] {monster_footstep(FALSE); hk_charge(3); ai_melee();};
void() bane_smash8  =[ $smash11, hknight_run1 ] {hk_charge(0);};

void() bane_watk1  =[ $w_attack1,  bane_watk2  ] {hk_charge(2);};
void() bane_watk2  =[ $w_attack5,  bane_watk3  ] {bane_melee(0); ai_melee();};
void() bane_watk3  =[ $w_attack7,  bane_watk4  ] {hk_charge(1);};
void() bane_watk4  =[ $w_attack8,  bane_watk5  ] {hk_charge(4);};
void() bane_watk5  =[ $w_attack9,  bane_watk6  ] {hk_charge(5);};
void() bane_watk6  =[ $w_attack10, bane_watk7  ] {hk_charge(3); ai_melee();};
void() bane_watk7  =[ $w_attack11, bane_watk8  ] {monster_footstep(FALSE); hk_charge(2); ai_melee();};
void() bane_watk8  =[ $w_attack13, bane_watk9  ] {hk_charge(2); ai_melee();};
void() bane_watk9  =[ $w_attack14, bane_watk10 ] {hk_charge(0);};
void() bane_watk10 =[ $w_attack16, bane_watk11 ] {hk_charge(1);
    sound (self, CHAN_WEAPON, "knight/sword2.wav", 1, ATTN_NORM);
};
void() bane_watk11 =[ $w_attack18, bane_watk12 ] {hk_charge(4); bane_melee(200); ai_melee();};
void() bane_watk12 =[ $w_attack19, bane_watk13 ] {hk_charge(4); ai_melee();};
void() bane_watk13 =[ $w_attack20, bane_watk14 ] {hk_charge(6);};
void() bane_watk14 =[ $w_attack22, hknight_run1] {hk_charge(10);};

void(entity inflictor, entity attacker, float damage) bane_pain =
{
// Shadow clone magic check.
    if (!self.waitmax)
    {
        if (self.health <= self.waitmin)  // Does Bane have the ace in the hole?
        if ((self.enemy == attacker) || (self.oldenemy == attacker))    // Is Bane fighting his enemy?
        if (self.touch != Bane_JumpTouch)   // Is Bane not locked in motion?
        if (self.classname != self.master.classname)    // Is Bane real?
        if (walkmove (0, 0))            // Can the Bane move?
        {   //"Bushin no Kage!\n"
            if (self.height)
                self.height = self.height | BANE_CLONE;
            sound (self, CHAN_VOICE, "drake/bane/pain.wav", 1, ATTN_NORM);
            // Cloning will take a while, so no need to add to pain_finished.
            bane_painc1();
            return;
        }
    }
    else
    {
        if (self.health <= self.waitmax)
        if (self.touch != Bane_JumpTouch)   // Is Bane not locked in motion?
        if (self.classname != self.master.classname)    // Is Bane real?
        if (walkmove (0, 0))            // Can the Bane move?
        {   // The kid gloves come off.
            self.health = self.waitmax;
            self.waitmax = 0;
            if (self.height)
                self.height = self.height | BANE_RAGE;
            sound (self, CHAN_VOICE, "drake/bane/pain.wav", 1, ATTN_NORM);
            bane_painc1();
            return;
        }
    }

// Normal pain code.
    if (self.pain_finished > time)
        return;

    sound (self, CHAN_VOICE, "drake/bane/pain.wav", 1, ATTN_NORM);
    self.pain_finished = time + 1;

    if (self.touch == Bane_JumpTouch)
        return;         // Don't interrupt attack anim.
//- - - - - - - - -
// Teleport check.
    if (!self.waitmax)
    if (self.enemy)
    if (walkmove (0, 0))
    {
    // If caught in deadly environment, warp out!
        if (self.h2otype <= CONTENT_SLIME)
            if (!attacker)  // Attacker is world when damaged by slime/lava.
                {bane_painc1 ();  return;}
    // Warp occasionally.
        if (random() < 0.1)
            {bane_painc1 ();  return;}
    }
//- - - - - - - - -
    if (random()*30 > damage)
        return;        // didn't flinch
    if (SUB_IgnorePain ())
        return;         // No pain anims in Nightmare.

    if (random() < 0.5)
        bane_pain1 ();
    else
        bane_painb1 ();
};

// Update 1/7/10:  Moved hknight_type to globals.qc.

void() baneknight_melee =
{
    local   float   fast;

    hknight_type = hknight_type + 1;

    sound (self, CHAN_WEAPON, "hknight/slash1.wav", 1, ATTN_NORM);
    fast = 1;
    if (!SUB_QuickAttack ())
        if (self.classname == "monster_hell_knight") fast = 0;
    if (fast) {
        if (hknight_type == 1)
            bane_slice1 ();
        else if (hknight_type == 2)
            bane_smash1 ();
        else if (hknight_type == 3) {
            bane_watk1 ();
            hknight_type = 0;
        }
        return;
    }

    if (hknight_type == 1)
        hknight_slice1 ();
    else if (hknight_type == 2)
        hknight_smash1 ();
    else if (hknight_type == 3) {
        hknight_watk1 ();
        hknight_type = 0;
    }
};

void() bane_win = {
    sound (self, CHAN_VOICE, "drake/bane/laugh.wav", 1, ATTN_NONE); // Update:  Changed from ATTN_NORM to ATTN_NONE for level-wide low laugh.
    if (self.movetarget || self.charmer)
        self.th_walk ();
    else
        self.th_stand ();
};

// Files common to all of the hell knight variants.
void() hk_cache = {
    precache_model ("progs/ad171/mon_hknight.mdl");
    precache_model ("progs/k_spike.mdl");
    precache_model ("progs/h_hellkn.mdl");
    precache_sound ("hknight/attack1.wav");
    precache_sound ("hknight/hit.wav");    // used by C code, so don't sound2
    precache_sound ("hknight/slash1.wav");
    precache_sound ("hknight/idle.wav");
    precache_sound ("knight/sword1.wav");
    precache_sound ("knight/sword2.wav");
};

// Classic, standard hell knight.
void() hknight_cache = {
    hk_cache ();
    precache_sound ("hknight/death1.wav");
    precache_sound ("hknight/pain1.wav");
    precache_sound ("hknight/sight1.wav");
};

// Tougher and meaner red version with fire magic.
void() hklord_cache = {
    hk_cache ();
    precache_model ("progs/drake/lavarock.mdl");
    precache_sound ("drake/archer/death2.wav");
    precache_sound ("drake/archer/pain2.wav");
    precache_sound ("drake/archer/sight2.wav");
    precache_sound ("boss1/throw.wav");
    precache_sound ("drake/weapons/fwall.wav");
    precache_sound ("drake/weapons/fwallhit.wav");
    precache_sound ("drake/weapons/fwalltap.wav");
};

// For Rapture's hkboss.
void() hkboss_cache = {
    hknight_cache ();
    precache_sound ("drake/hknight/death1.wav");
    precache_sound ("drake/hknight/sboom.wav");
    precache_sound ("drake/hknight/sboom2.wav");
    precache_model ("progs/drake/v_spike.mdl");       // Used by hkboss.
    precache_sound ("drake/hkboss/iceball.wav");      // Used by hkboss.
};

void() monster_hell_lord = {monster_hell_knight ();};
void() monster_lord = {self.classname = "monster_hell_lord";  monster_hell_knight ();};

// For Rapture.
void() monster_hkboss = {monster_hell_knight ();};

//==========================================================================
//  The Bane  (SoE Big Bad Evil Guy, Hell Knight boss variant)
//==========================================================================

// In case Bane gets aggravated during teleportation...
void() bane_run = {
    if (self.skin == SKIN_BANE_GRAY)
        bane_painc1 ();     // Restart shadow walk.
    else
        hknight_run1 ();
};

void() monster_bane = {
	if (deathmatch) { remove(self); return; }

	self.mdl = "progs/ad171/mon_hknight.mdl";			// Original ID Knight + extra skins
	self.headmdl = "progs/h_hellkn.mdl";
    precache_model ("progs/ad171/mon_hknight.mdl");
    precache_model ("progs/drake/k_ball.mdl");    // Bane fireball.
    precache_model ("progs/h_hellkn.mdl");
	precache_model ("progs/drake/s_wave.spr");

    precache_sound ("ambience/thunder1.wav");
    precache_sound ("drake/ambience/thunder2.wav");
    precache_sound ("drake/bane/death.wav");
    precache_sound ("drake/bane/growl.wav");
    precache_sound ("drake/bane/hit.wav");
    precache_sound ("drake/bane/laugh.wav");
    precache_sound ("drake/bane/pain.wav");
    precache_sound ("drake/bane/sight.wav");
    precache_sound ("drake/bane/thunder.wav");
    precache_sound ("hknight/slash1.wav");
    precache_sound ("knight/sword1.wav");
    precache_sound ("knight/sword2.wav");
    precache_sound ("hipnotic/weapons/mjolhit.wav");
    precache_sound ("drake/misc/dsslop.wav");
    precache_sound ("drake/weapons/axhit.wav");

	self.gib1mdl = "progs/ad171/w_hknightsword.mdl";	// Unique sword
	self.gib2mdl = "progs/ad171/gib_knfoot_l.mdl";	// left foot
	self.gib3mdl = "progs/ad171/gib_knfoot_r.mdl";	// right foot
	
	precache_model (self.mdl);
	precache_model (self.headmdl);
	precache_model (MODEL_PROJ_HKN);
	precache_model (self.gib1mdl);
	precache_model (self.gib2mdl);
	precache_model (self.gib3mdl);

	self.gib1sound = GIB_IMPACT_METALA;
	if (random() < 0.5) self.gib2mdl = string_null;
	if (random() < 0.5) self.gib3mdl = string_null;

	precache_sound ("hknight/attack1.wav");
	precache_sound ("knight/sword2.wav");
	precache_sound ("hknight/hit.wav");	
			
	self.idle_sound = "hknight/idle.wav";
	precache_sound (self.idle_sound);

	self.pain_sound = "drake/bane/pain.wav";
	self.death_sound = "drake/bane/death.wav";
	self.sight_sound = "drake/bane/sight.wav";
	self.hello_sound = string_null; 

	precache_sound (self.pain_sound);
	precache_sound (self.death_sound);
	precache_sound (self.sight_sound);
	
    self.mass = MASS_MEDIUM;
    self.skin = SKIN_BANE;
	self.solid = SOLID_NOT;				// No interaction with world
	self.movetype = MOVETYPE_NONE;		// Static item, no movement
	if (self.bboxtype < 1) self.bboxtype = BBOX_TALL;
	if (self.health < 1) self.health = 2000;
	self.gibhealth = -90;
	self.gibbed = FALSE;
	self.pain_flinch = 120;
	self.pain_timeout = 5;
	self.steptype = FS_TYPEHEAVY;
	self.meleeattack = rint(random()*3);	// randomize last melee attack
	self.th_die = hknight_die;				// Face meets floor

    if (cvar("skill") < 1) {
        self.waitmin = self.waitmax = -1;   // No clones or rage on Easy.
    } else if (cvar("skill") < 2) {
        self.waitmin = floor(self.health / 4);   // Clones with 500 health.
        self.waitmax = floor(self.health / 2);   // Rage at half hp.
    } else {
        self.waitmax = self.health / 3;
        self.waitmin = floor(self.waitmax);      // Clones with 666 health.
        self.waitmax = floor(self.waitmax * 2);  // Rage at 66% hp.
    }

	self.hittype = HIT_METAL;
    self.xfl        = XFL_ARMORED | XFL_BOSS;   // Don't dare hit the king!
    self.ryuflags   = RYU_ALERT | RYU_INSANE;
	self.pain_longanim = FALSE;

	self.th_stand = hknight_stand1;		// Idling on feet
	self.th_walk = hknight_walk1;		// Walking
	self.th_run = bane_run;			// Running
	self.th_melee = baneknight_melee;		// Sword attack
	self.th_missile = bane_magic;	// Fire spikes
	self.th_charge = hknight_char_a1;	// Run + melee
	self.th_pain = bane_pain;		// Stumble and pain
	self.th_die = hknight_die;			// Face meets floor
    self.th_win     = bane_win;
    self.th_spawn   = monster_bane;
	if (self.deathstring == "") self.deathstring = " provided sport for Bane\n";

	// Always reset Ammo Resistance to be consistent
	self.resist_shells = self.resist_nails = 0;
	self.resist_rockets = self.resist_cells = 0;

	self.classtype = CT_MONBANE;
	self.classgroup = CG_DCAPTAIN;	// Rule over seargent and fury knights but lesser knights are disloyal
	self.classmove = MON_MOVEWALK;

    if (soul_evil) monster_purse (20, 1, 0.5);

	monster_start();
};

//==========================================================================
//  The Dark Lord  (Wraith in Black Armor, a bit like Tolkien's Nazgul)
//
//  Update 5/??/2011:  Now includes a two-stage version similar to
//  Dracula in (early) Castlevania, the human form and beast form.
//==========================================================================

void(float d) dk_slow;
void(float d) dk_fast;

void() darklord_run1  =[ $walk1,  darklord_run2  ] {dk_slow(2);};
void() darklord_run2  =[ $walk2,  darklord_run3  ] {monster_footstep(FALSE); dk_slow(5);};
void() darklord_run3  =[ $walk3,  darklord_run4  ] {dk_slow(5);};
void() darklord_run4  =[ $walk4,  darklord_run5  ] {dk_slow(4);};
void() darklord_run5  =[ $walk5,  darklord_run6  ] {dk_slow(4);};
void() darklord_run6  =[ $walk6,  darklord_run7  ] {dk_slow(2);};
void() darklord_run7  =[ $walk7,  darklord_run8  ] {dk_slow(2);};
void() darklord_run8  =[ $walk8,  darklord_run9  ] {dk_slow(3);};
void() darklord_run9  =[ $walk9,  darklord_run10 ] {dk_slow(3);};
void() darklord_run10 =[ $walk10, darklord_run11 ] {dk_slow(4);};
void() darklord_run11 =[ $walk11, darklord_run12 ] {dk_slow(3);};
void() darklord_run12 =[ $walk12, darklord_run13 ] {monster_footstep(FALSE); dk_slow(4);};
void() darklord_run13 =[ $walk13, darklord_run14 ] {dk_slow(6);};
void() darklord_run14 =[ $walk14, darklord_run15 ] {dk_slow(2);};
void() darklord_run15 =[ $walk15, darklord_run16 ] {dk_slow(2);};
void() darklord_run16 =[ $walk16, darklord_run17 ] {dk_slow(4);};
void() darklord_run17 =[ $walk17, darklord_run18 ] {dk_slow(3);};
void() darklord_run18 =[ $walk18, darklord_run19 ] {dk_slow(3);};
void() darklord_run19 =[ $walk19, darklord_run20 ] {dk_slow(3);};
void() darklord_run20 =[ $walk20, darklord_run1  ] {dk_slow(2);};
//void() darklord_run20 =[ $walk20, darklord_run21 ] {dk_slow(2);};
//void() darklord_run21 =[ $walk20, darklord_run2  ] {dk_slow(2);};

void() darklord_fast1 =[ $run1, darklord_fast2 ] {monster_idle_sound(); dk_fast(20);};
void() darklord_fast2 =[ $run2, darklord_fast3 ] {monster_footstep(FALSE); dk_fast(25);};
void() darklord_fast3 =[ $run3, darklord_fast4 ] {dk_fast(18);};
void() darklord_fast4 =[ $run4, darklord_fast5 ] {dk_fast(16);};
void() darklord_fast5 =[ $run5, darklord_fast6 ] {dk_fast(14);};
void() darklord_fast6 =[ $run6, darklord_fast7 ] {monster_footstep(FALSE); dk_fast(25);};
void() darklord_fast7 =[ $run7, darklord_fast8 ] {dk_fast(21);};
void() darklord_fast8 =[ $run8, darklord_fast1 ] {dk_fast(13);};

void() dk_shield = {
    if (self.minion_count < 1)  // FIXME:  Check for wraths.
    {
        if (self.flags & FL_GODMODE)
        {
            self.flags = self.flags - FL_GODMODE;   //(self.flags & FL_GODMODE);
            self.waitmax = time + 10;   // Give player time to attack.
        }
        if (!self.mirror_finished)
            self.effects = self.effects - (self.effects & EF_BRIGHTFIELD);
    } else {
        if (!(self.flags & FL_GODMODE))
        {
            self.flags = self.flags | FL_GODMODE;
            ReflectorShield (self);
            sound(self, 6, "items/protect.wav", 1, ATTN_NORM);
        }
    }
};

void(float d) dk_slow = {
    if (!self.enemy) {darklord_fast1 ();  return;}
    if (!visible (self.enemy)) {darklord_fast1 ();  return;}
    dk_shield ();
    ai_run(d);
};

void(float d) dk_fast = {
	if (self.enemy)
		if (visible (self.enemy)) {darklord_run1 ();  return;}
    dk_shield ();
    ai_run(d);
};

void(float d) dk_charge = { hk_charge(d*2); };
void() dk_idle_sound = { if (random() < 0.2) sound (self, CHAN_VOICE, "drake/darklord/idle1.wav", 1, ATTN_NORM); };

void() darklord_slice1  =[ $slice1,  darklord_slice2  ] {dk_idle_sound(); dk_charge(9);};
void() darklord_slice2  =[ $slice3,  darklord_slice3  ] {monster_footstep(FALSE); dk_charge(19);};
void() darklord_slice3  =[ $slice5,  darklord_slice4  ] {dk_charge(11); bane_melee(-200); ai_melee();};
void() darklord_slice4  =[ $slice6,  darklord_slice5  ] {dk_charge(15); ai_melee();};
void() darklord_slice5  =[ $slice7,  darklord_slice6  ] {monster_footstep(FALSE); dk_charge(8); ai_melee();};
void() darklord_slice6  =[ $slice9,  darklord_slice7  ] {dk_charge(2); ai_melee();};
void() darklord_slice7  =[ $slice10, hknight_run1 ] {dk_charge(3);};

void() darklord_smash1  =[ $smash2,  darklord_smash2  ] {dk_idle_sound(); dk_charge(14);};
void() darklord_smash2  =[ $smash4,  darklord_smash3  ] {monster_footstep(FALSE); dk_charge(20);};
void() darklord_smash3  =[ $smash5,  darklord_smash4  ] {dk_charge(10); bane_melee(0); ai_melee();};
void() darklord_smash4  =[ $smash6,  darklord_smash5  ] {dk_charge(7); ai_melee();};
void() darklord_smash5  =[ $smash7,  darklord_smash6  ] {dk_charge(12); ai_melee();};
void() darklord_smash6  =[ $smash8,  darklord_smash7  ] {dk_charge(2); ai_melee();};
void() darklord_smash7  =[ $smash9,  darklord_smash8  ] {monster_footstep(FALSE); dk_charge(3); ai_melee();};
void() darklord_smash8  =[ $smash11, hknight_run1 ] {dk_charge(0);};

void() darklord_watk1  =[ $w_attack1,  darklord_watk2  ] {dk_idle_sound(); dk_charge(2);};
void() darklord_watk2  =[ $w_attack5,  darklord_watk3  ] {bane_melee(0); ai_melee();};
void() darklord_watk3  =[ $w_attack7,  darklord_watk4  ] {dk_charge(1);};
void() darklord_watk4  =[ $w_attack8,  darklord_watk5  ] {dk_charge(4);};
void() darklord_watk5  =[ $w_attack9,  darklord_watk6  ] {dk_charge(5);};
void() darklord_watk6  =[ $w_attack10, darklord_watk7  ] {dk_charge(3); ai_melee();};
void() darklord_watk7  =[ $w_attack11, darklord_watk8  ] {monster_footstep(FALSE); dk_charge(2); ai_melee();};
void() darklord_watk8  =[ $w_attack13, darklord_watk9  ] {dk_charge(2); ai_melee();};
void() darklord_watk9  =[ $w_attack14, darklord_watk10 ] {dk_charge(0);};
void() darklord_watk10 =[ $w_attack16, darklord_watk11 ] {dk_charge(1);
    sound (self, CHAN_WEAPON, "knight/sword2.wav", 1, ATTN_NORM);
};
void() darklord_watk11 =[ $w_attack18, darklord_watk12 ] {dk_charge(4); bane_melee(200); ai_melee();};
void() darklord_watk12 =[ $w_attack19, darklord_watk13 ] {dk_charge(4); ai_melee();};
void() darklord_watk13 =[ $w_attack20, darklord_watk14 ] {dk_charge(6);};
void() darklord_watk14 =[ $w_attack22, hknight_run1] {dk_charge(10);};

void() darklord_melee =
{
    if (self.waitmin < time)
        {darklord_magica1(); return;}

    hknight_type = hknight_type + 1;

    sound (self, CHAN_WEAPON, "hknight/slash1.wav", 1, ATTN_NORM);
    if (hknight_type == 1)
        darklord_slice1 ();
    else if (hknight_type == 2)
        darklord_smash1 ();
    else if (hknight_type == 3)
    {
        darklord_watk1 ();
        hknight_type = 0;
    }
};

//============================================================================

void() darklord_thebeast;   // Look in 'dragon.qc'.

void() darklord_fall1  =[ $stand1,  darklord_fall2  ] {ai_forward(10);};
void() darklord_fall2  =[ $stand2,  darklord_fall3  ] {ai_forward(8);};
void() darklord_fall3  =[ $stand3,  darklord_fall4  ] {ai_forward(7);};
void() darklord_fall4  =[ $stand4,  darklord_fall5  ] {};
void() darklord_fall5  =[ $stand5,  darklord_fall6  ] {};
void() darklord_fall6  =[ $stand6,  darklord_fall7  ] {};
void() darklord_fall7  =[ $stand7,  darklord_fall8  ] {};
void() darklord_fall8  =[ $stand8,  darklord_fall9  ] {ai_forward(10);};
void() darklord_fall9  =[ $stand9,  darklord_fall10 ] {ai_forward(11);};
void() darklord_fall10 =[ $stand1, darklord_fall11 ] {};
void() darklord_fall11 =[ $stand2, darklord_fall12 ] {};
void() darklord_fall12 =[ $stand3, darklord_thebeast ] {
    Quake_Level (0, self.origin, 5);
    self.nextthink = time + 3;
};

void(entity inflictor, entity attacker, float damage) darklord_pain = {
    if (self.max_health - self.health >= 1000) {
		// Took enough damage to die.  So feign death before transforming.
        local   vector  st;

        // Become immune to damage and reset health.
        self.flags = self.flags | FL_GODMODE;
        self.health = self.max_health - 1000;

        // Reset some things.
        self.th_stand   = SUB_Null;
        self.th_walk    = SUB_Null;
        self.th_run     = darklord_thebeast;
        self.th_melee   = SUB_Null;
        self.th_missile = SUB_Null;
        self.th_pain    = SUB_Null_pain;
        self.effects    = 0;    // PM:  Erase shield, lights, and the rest.
		self.jump_time  = 0;
		self.zapper_time        = 0;
        sound (self, CHAN_VOICE, "drake/darklord/death.wav", 1, ATTN_NORM); // Fake death.
        makevectors (self.angles);
        st = '-2 0 28';
        st = self.origin + v_forward*st_x + v_right*st_y + v_up*st_z;
        Rocket_Explosion2 (st, 32, 5);
        darklord_fall1 ();
        return;
    }
    hknight_pain (inflictor, attacker, damage); // Proceed as usual.
};

//============================================================================

// Note:  The dark lord's helmet explodes when destroyed.
void() darklord_die1  =[ $death1,  darklord_die2  ] {ai_forward(10);};
void() darklord_die2  =[ $death2,  darklord_die3  ] {ai_forward(8);};
void() darklord_die3  =[ $death3,  darklord_die4  ] {ai_forward(7);};
void() darklord_die4  =[ $death4,  darklord_die5  ] {};
void() darklord_die5  =[ $death5,  darklord_die6  ] {};
void() darklord_die6  =[ $death6,  darklord_die7  ] {};
void() darklord_die7  =[ $death7,  darklord_die8  ] {};
void() darklord_die8  =[ $death8,  darklord_die9  ] {ai_forward(10);};
void() darklord_die9  =[ $death9,  darklord_die10 ] {ai_forward(11);};
void() darklord_die10 =[ $death10, darklord_die11 ] {};
void() darklord_die11 =[ $death11, darklord_die12 ] {};
void() darklord_die12 =[ $death12, darklord_die12 ] {};

void() darklord_dieb1 =[ $deathb1, darklord_dieb2 ] {};
void() darklord_dieb2 =[ $deathb2, darklord_dieb3 ] {};
void() darklord_dieb3 =[ $deathb3, darklord_dieb4 ] {};
void() darklord_dieb4 =[ $deathb4, darklord_dieb5 ] {};
void() darklord_dieb5 =[ $deathb5, darklord_dieb6 ] {};
void() darklord_dieb6 =[ $deathb6, darklord_dieb7 ] {};
void() darklord_dieb7 =[ $deathb7, darklord_dieb8 ] {};
void() darklord_dieb8 =[ $deathb8, darklord_dieb9 ] {};
void() darklord_dieb9 =[ $deathb9, darklord_dieb9   ] {};

void() darklord_die = {
// check for gib
//    if (Shattered ())
//        return;

// regular death
    local   vector  st;

    sound (self, CHAN_VOICE, "drake/darklord/death.wav", 1, ATTN_NORM);

    if (random() > 0.5)
        {st = '-2 0 28'; darklord_die1 ();}
    else
        {st = '-3 0 33'; darklord_dieb1 ();}
    makevectors (self.angles);
    st = self.origin + v_forward*st_x + v_right*st_y + v_up*st_z;
    Rocket_Explosion2 (st, 32, 5);
};

//============
// --> QUAKED monster_dark_lord (1 0 0) (-16 -16 -24) (16 16 40) Ambush Guardian Beast
// Guardian version can raise a shield and summon wraths.
// Beast version has 4000+ hp and morphs into a dragon when damaged enough.
// The boss flags can stack!
//============
void() monster_dark_lord = {
    local   float   hp;

	// Check all spawn exceptions (monsters.qc)
	if (monster_checkspawn() == TRUE) return;

    if (self.spawnflags & 4) {
        hp = 4000 + (500 * cvar("skill"));
		if (self.deathstring == "")  self.deathstring = " fell before a Beastly Dark Lord\n";
    } else {
		if (self.deathstring == "")  self.deathstring = " fell before a Dark Lord\n";
        hp = 1000;
	}

	self.mdl = "progs/ad171/mon_hknight.mdl";			// Original ID Knight + extra skins
	self.headmdl = "progs/h_hellkn.mdl";
    precache_model ("progs/ad171/mon_hknight.mdl");
    precache_model ("progs/drake/k_ball.mdl");    // Bane fireball.
    precache_model ("progs/h_hellkn.mdl");
	precache_model ("progs/drake/s_wave.spr");

    precache_sound ("ambience/thunder1.wav");
    precache_sound ("drake/ambience/thunder2.wav");
    precache_sound ("drake/bane/death.wav");
    precache_sound ("drake/bane/growl.wav");
    precache_sound ("drake/bane/laugh.wav");
    precache_sound ("drake/bane/pain.wav");
    precache_sound ("drake/bane/sight.wav");
    precache_sound ("drake/bane/thunder.wav");
    precache_sound ("hknight/slash1.wav");
    precache_sound ("knight/sword1.wav");
    precache_sound ("knight/sword2.wav");
    precache_sound ("hipnotic/weapons/mjolhit.wav");
    precache_sound ("drake/misc/dsslop.wav");
    precache_sound ("drake/weapons/axhit.wav");
	precache_sound ("drake/archer/sight2.wav");

    precache_model ("progs/drake/r_bolt.mdl");
    // The dark lord's head explodes when killed, so no head gib needed.
    precache_sound ("drake/bane/hit.wav");
    precache_sound ("drake/darklord/death.wav");
    precache_sound ("drake/darklord/idle1.wav");
    precache_sound ("drake/darklord/pain.wav");
    precache_sound ("drake/darklord/sight.wav");
	self.sight_sound = "drake/darklord/sight.wav";
	self.hello_sound = "drake/darklord/idle1.wav"; 
    precache_sound ("drake/darklord/death.wav");
    precache_sound ("items/protect.wav");   // Powerup sound
    precache_sound ("rogue/plasma/explode.wav");
    precache_sound ("rogue/plasma/fire.wav");
    precache_sound ("drake/skullwiz/gate.wav");   // For wrath summoning.

	self.gib1mdl = "progs/ad171/w_hknightsword.mdl";	// Unique sword
	self.gib2mdl = "progs/ad171/gib_knfoot_l.mdl";	// left foot
	self.gib3mdl = "progs/ad171/gib_knfoot_r.mdl";	// right foot
	
	precache_model (self.mdl);
	precache_model (self.headmdl);
	precache_model (MODEL_PROJ_HKN);
	precache_model (self.gib1mdl);
	precache_model (self.gib2mdl);
	precache_model (self.gib3mdl);

	self.gib1sound = GIB_IMPACT_METALA;
	if (random() < 0.5) self.gib2mdl = string_null;
	if (random() < 0.5) self.gib3mdl = string_null;

	precache_sound ("hknight/attack1.wav");
	precache_sound ("knight/sword2.wav");
	precache_sound ("hknight/hit.wav");			
	self.idle_sound = "drake/darklord/idle1.wav";
	precache_sound (self.idle_sound);
	self.pain_sound = "drake/darklord/pain.wav";
	self.death_sound = "drake/darklord/death.wav";
	precache_sound (self.pain_sound);
	precache_sound (self.death_sound);
	precache_sound (self.sight_sound);
    precache_model ("progs/drake/dragon.mdl");
    precache_model ("progs/drake/drggib01.mdl");
    precache_model ("progs/drake/drggib02.mdl");
    precache_model ("progs/drake/drggib03.mdl");
    precache_model ("progs/drake/plasma.mdl");
    precache_sound ("rogue/dragon/see.wav");
    precache_sound ("rogue/dragon/active.wav");
    precache_sound ("rogue/dragon/attack.wav");
    precache_sound ("drake/dragon/fly1.wav");
    precache_sound ("drake/dragon/flywater.wav");
    precache_sound ("rogue/dragon/pain.wav");
    precache_sound ("rogue/dragon/death.wav");
	precache_sound ("drake/dragon/fire.wav");
    precache_sound ("shambler/smack.wav");
    self.mass = MASS_MEDIUM;
    self.skin = SKIN_DARK_LORD;
	self.solid = SOLID_NOT;				// No interaction with world
	self.movetype = MOVETYPE_NONE;		// Static item, no movement
	if (self.bboxtype < 1) self.bboxtype = BBOX_TALL;
	if (self.health < 1) self.health = hp; // 1000, unless beast then 4000 + (skill * 500)
	self.gibhealth = MON_NEVERGIB;		// Cannot be gibbed by weapons
	self.gibbed = FALSE;
	self.pain_flinch = 120;
	self.pain_timeout = 5;
	self.steptype = FS_TYPEHEAVY;
	self.meleeattack = rint(random()*3);	// randomize last melee attack
	self.th_die = hknight_die;				// Face meets floor

    if (cvar("skill") < 1) {
        self.waitmin = self.waitmax = -1;   // No clones or rage on Easy.
    } else if (cvar("skill") < 2) {
        self.waitmin = floor(self.health / 4);   // Clones with 500 health.
        self.waitmax = floor(self.health / 2);   // Rage at half hp.
    } else {
        self.waitmax = self.health / 3;
        self.waitmin = floor(self.waitmax);      // Clones with 666 health.
        self.waitmax = floor(self.waitmax * 2);  // Rage at 66% hp.
    }

	self.hittype = HIT_METAL;
    self.xfl        = XFL_ARMORED;
    if (self.spawnflags & 6) {
		self.deathstring = " fell before a Guardian Dark Lord\n";
        self.xfl        = XFL_BOSS;
	}
    self.ryuflags   = RYU_ALERT | RYU_INSANE;
	self.pain_longanim = FALSE;

	self.th_stand = hknight_stand1;		// Idling on feet
	self.th_walk = hknight_walk1;		// Walking
	self.th_run = darklord_run1;			// Running
	self.th_melee = darklord_melee;		// Sword attack
	self.th_missile = darklord_magic;	// Fire spikes
	self.th_charge = hknight_char_a1;	// Run + melee
    if (self.spawnflags & 4)
        self.th_pain    = darklord_pain;    // Checks for stage change.
    else
        self.th_pain    = hknight_pain;
	self.th_die = darklord_die;			// Face meets floor
    self.th_win     = bane_win;
    self.th_spawn   = monster_bane;

	// Always reset Ammo Resistance to be consistent
	self.resist_shells = self.resist_nails = 0;
	self.resist_rockets = self.resist_cells = 0;

	// Check passive system for exceptions
	setup_passivestate(self);

	self.classtype = CT_MONDARKLORD;
	self.classgroup = CG_DCAPTAIN;	// Rule over seargent and fury knights but lesser knights are disloyal
	self.classmove = MON_MOVEWALK;

    if (soul_evil) monster_purse (20, 1, 0.5);

	monster_start();
};