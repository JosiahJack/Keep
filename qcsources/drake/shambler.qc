/*
==============================================================================

SHAMBLER

==============================================================================
*/

$cd id1/models/shams
$origin 0 0 24
$base base        
$skin base

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9
$frame stand10 stand11 stand12 stand13 stand14 stand15 stand16 stand17

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 
$frame walk8 walk9 walk10 walk11 walk12

$frame run1 run2 run3 run4 run5 run6

$frame smash1 smash2 smash3 smash4 smash5 smash6 smash7 
$frame smash8 smash9 smash10 smash11 smash12

$frame swingr1 swingr2 swingr3 swingr4 swingr5 
$frame swingr6 swingr7 swingr8 swingr9

$frame swingl1 swingl2 swingl3 swingl4 swingl5 
$frame swingl6 swingl7 swingl8 swingl9

$frame magic1 magic2 magic3 magic4 magic5 
$frame magic6 magic7 magic8 magic9 magic10 magic11 magic12

$frame pain1 pain2 pain3 pain4 pain5 pain6

$frame death1 death2 death3 death4 death5 death6 
$frame death7 death8 death9 death10 death11

$frame decap1 decap2 decap3 decap4 decap5 decap6 
$frame decap7 decap8 decap9 decap10 decap11

//============================================================================

//- - - - - - - - -
float() IsShamVile = {return (self.classname == "monster_shamvile");};
//- - - - - - - - -
//===========
// ShamCheckAttack
//
// The player is in view, so decide to move or launch an attack
// Returns FALSE if movement should continue
//============
float() ShamCheckAttack =
{
    local   vector  spot1, spot2;    
    local   entity  targ;
    local   float   sham;   // TRUE = Shambler, FALSE = Sha'Vile

    if (enemy_range == RANGE_MELEE)
    {
        if (CanDamage (self.enemy, self))
        {
            self.attack_state = AS_MELEE;
            return TRUE;
        }
    }

    sham = !IsShamVile ();
//- - - - - - - - -
    if (self.h2olevel == 3)     // 25 (eyes) < 40 (org)
        if (sham)
            return FALSE;   // PM:  Prevent lightning use while underwater.
//- - - - - - - - -
    if (time < self.attack_finished)
        return FALSE;
    
    if (!enemy_vis)
        return FALSE;
        
    targ = self.enemy;
    
// see if any entities are in the way of the shot
    spot1 = self.origin + self.view_ofs;
    spot2 = targ.origin + targ.view_ofs;

    if (sham)   // Shambler is limited by lightning bolt range.
        if (vlen(spot1 - spot2) > 600)
            return FALSE;

    traceline (spot1, spot2, FALSE, self);

    if (trace_inopen && trace_inwater)
        return FALSE;            // sight line crossed contents

    if (trace_ent != targ)
    {   // PM:  See CheckAttack in ai.qc for details.
        // Note:  All of the shambler's attacks can hit ghosts.
        if (trace_fraction < 1)
        {
            if (DontHurtMe (trace_ent))   // PM:  Check who's in the way.
                return FALSE;    // don't have a clear shot
        }
        else
        {
            if (targ.takedamage != DAMAGE_AIM)
                return FALSE;
            if (!IsGhost (targ))
                return FALSE;
        }
    }

// missile attack
// PM:  While the shambler doesn't need the range check, the Sha'Vile does.
    if (enemy_range == RANGE_FAR)
        return FALSE;
        
    self.attack_state = AS_MISSILE;
    SUB_AttackFinished (2 + 2*random());
    return TRUE;
};

//============================================================================

// STAND - - - - - - - - - - - - - - - -
void() sham_stand1  =[ $stand1,   sham_stand2  ] {ai_stand();};
void() sham_stand2  =[ $stand2,   sham_stand3  ] {ai_stand();};
void() sham_stand3  =[ $stand3,   sham_stand4  ] {ai_stand();};
void() sham_stand4  =[ $stand4,   sham_stand5  ] {ai_stand();};
void() sham_stand5  =[ $stand5,   sham_stand6  ] {ai_stand();};
void() sham_stand6  =[ $stand6,   sham_stand7  ] {ai_stand();};
void() sham_stand7  =[ $stand7,   sham_stand8  ] {ai_stand();};
void() sham_stand8  =[ $stand8,   sham_stand9  ] {ai_stand();};
void() sham_stand9  =[ $stand9,   sham_stand10 ] {ai_stand();};
void() sham_stand10 =[ $stand10,  sham_stand11 ] {ai_stand();};
void() sham_stand11 =[ $stand11,  sham_stand12 ] {ai_stand();};
void() sham_stand12 =[ $stand12,  sham_stand13 ] {ai_stand();};
void() sham_stand13 =[ $stand13,  sham_stand14 ] {ai_stand();};
void() sham_stand14 =[ $stand14,  sham_stand15 ] {ai_stand();};
void() sham_stand15 =[ $stand15,  sham_stand16 ] {ai_stand();};
void() sham_stand16 =[ $stand16,  sham_stand17 ] {ai_stand();};
void() sham_stand17 =[ $stand17,  sham_stand1  ] {ai_stand();};

// WALK - - - - - - - - - - - - - - - -
void() sham_idle_sfx =
{
    if (IsShamVile ())
        sound (self, CHAN_VOICE, "shamvile/sidle2.wav", 1, ATTN_IDLE);
    else
        sound (self, CHAN_VOICE, "shambler/sidle.wav", 1, ATTN_IDLE);
};
void() sham_walk1   =[ $walk1,    sham_walk2   ] {ai_walk(10);};
void() sham_walk2   =[ $walk2,    sham_walk3   ] {ai_walk(9);};
void() sham_walk3   =[ $walk3,    sham_walk4   ] {ai_walk(9);};
void() sham_walk4   =[ $walk4,    sham_walk5   ] {ai_walk(5);};
void() sham_walk5   =[ $walk5,    sham_walk6   ] {ai_walk(6);};
void() sham_walk6   =[ $walk6,    sham_walk7   ] {ai_walk(12);};
void() sham_walk7   =[ $walk7,    sham_walk8   ] {ai_walk(8);};
void() sham_walk8   =[ $walk8,    sham_walk9   ] {ai_walk(3);};
void() sham_walk9   =[ $walk9,    sham_walk10  ] {ai_walk(13);};
void() sham_walk10  =[ $walk10,   sham_walk11  ] {ai_walk(9);};
void() sham_walk11  =[ $walk11,   sham_walk12  ] {ai_walk(7);};
void() sham_walk12  =[ $walk12,   sham_walk1   ] {ai_walk(7);
if (random() > 0.8)
    sham_idle_sfx ();
};

// RUN - - - - - - - - - - - - - - - - -
void() sham_raise1;
void(float d) sham_run =
{
    if (IsShamVile ())
    {
        if (!self.lip)
        if (ai_medic (d))
        {
            sham_raise1 ();
            return;
        }
    }
    ai_run (d);
};
void() sham_run1    =[ $run1,     sham_run2    ] {sham_run(20);};
void() sham_run2    =[ $run2,     sham_run3    ] {sham_run(24);};
void() sham_run3    =[ $run3,     sham_run4    ] {sham_run(20);};
void() sham_run4    =[ $run4,     sham_run5    ] {sham_run(20);};
void() sham_run5    =[ $run5,     sham_run6    ] {sham_run(24);};
void() sham_run6    =[ $run6,     sham_run1    ] {sham_run(20);
if (random() > 0.8)
    sham_idle_sfx ();
};
// Replacement run start for removing magic effects in case of target switch.
void() sham_run_go =
{
    if (self.owner)
        {remove (self.owner);  self.owner = world;}
    sham_run1 ();
};

// ATTACK - - - - - - - - - - - - - - -
void(float side) ShamClaw =
{
    if (!self.enemy)
        return;

    local   float   ldmg;

    if (side)
        {ai_charge(10); ldmg = 20;}   // One arm swing
    else
        {ai_charge(0); ldmg = 40;}    // Two arm smash!

// PM:  Check range first because sham-vile will throw fireballs on a whiff.
// CanDamage used to come first.
    if (!InMeleeRange (100))    // PM:  Dragons-related.
    {
        if (IsShamVile ())
        {
            if (side)
            {   // Throw some fireballs!
                if (side < 0)   // + = left, - = right.
                    M_FireKnight ('56 -10 75', FALSE);
                else
                    M_FireKnight ('66 6 61', FALSE);
            }
            else
                M_Firewall ();
        }
        return;
    }
    if (!CanDamage (self.enemy, self))
        return;
    // Let the mighty shambler tear a wraith apart!
        
    ldmg = SUB_MeleeDamage (ldmg);
    if (IsShamVile ())
    {   // Mutilate the enemy in some way if slain.
        if (side)
            T_NewDamage (self.enemy, self, self, ldmg, DF_SCAR, "decap_rip");
        else
            T_NewDamage (self.enemy, self, self, ldmg, DF_SCAR|DF_GIB, "");
    }
    else
        T_Damage (self.enemy, self, self, ldmg);
    sound (self, CHAN_VOICE, "shambler/smack.wav", 1, ATTN_NORM);

    makevectors (self.angles);  // PM:  This is new.
    if (side)
    {
        SpawnMeatSpray (self.origin + v_forward*16, side * v_right, self.enemy.bloodtype);
    }
    else
    {
        SpawnMeatSpray (self.origin + v_forward*16, crandom() * 100 * v_right, self.enemy.bloodtype);
        SpawnMeatSpray (self.origin + v_forward*16, crandom() * 100 * v_right, self.enemy.bloodtype);
    }
};

float() SwingAgain =
{
    if (random() < 0.5)
    {   // Swing if the enemy is not in pieces.
        if (self.enemy.health > 0)
            return TRUE;
        if (self.enemy.modelindex == self.enemy.mindex2)
            return TRUE;
    }
    return FALSE;
};

void(float stype) sham_melee_sfx =
{
    local   string  text;

    if (IsShamVile ())
    {
        if (stype == 1)
            text = "shamvile/melee3.wav";
        else
            text = "shamvile/melee4.wav";
    }
    else
    {
        if (stype == 1)
            text = "shambler/melee1.wav";
        else
            text = "shambler/melee2.wav";
    }
    sound (self, CHAN_VOICE, text, 1, ATTN_NORM);
};
// Normal attacks -- standard Quake.
void() sham_smash1  =[ $smash1,   sham_smash2  ] {sham_melee_sfx(1); ai_charge(2);};
void() sham_smash2  =[ $smash2,   sham_smash3  ] {ai_charge(6);};
void() sham_smash3  =[ $smash3,   sham_smash4  ] {ai_charge(6);};
void() sham_smash4  =[ $smash4,   sham_smash5  ] {ai_charge(5);};
void() sham_smash5  =[ $smash5,   sham_smash6  ] {ai_charge(4);};
void() sham_smash6  =[ $smash6,   sham_smash7  ] {ai_charge(1);};
void() sham_smash7  =[ $smash7,   sham_smash8  ] {ai_charge(0);};
void() sham_smash8  =[ $smash8,   sham_smash9  ] {ai_charge(0);};
void() sham_smash9  =[ $smash9,   sham_smash10 ] {ai_charge(0);};
void() sham_smash10 =[ $smash10,  sham_smash11 ] {ShamClaw(0);};
void() sham_smash11 =[ $smash11,  sham_smash12 ] {ai_charge(5);};
void() sham_smash12 =[ $smash12,  sham_run1    ] {ai_charge(4);};

void() sham_swingr1;

void() sham_swingl1 =[ $swingl1,  sham_swingl2 ] {
    sham_melee_sfx(2);
    ai_charge(5);
};
void() sham_swingl2 =[ $swingl2,  sham_swingl3 ] {ai_charge(3);};
void() sham_swingl3 =[ $swingl3,  sham_swingl4 ] {ai_charge(7);};
void() sham_swingl4 =[ $swingl4,  sham_swingl5 ] {ai_charge(3);};
void() sham_swingl5 =[ $swingl5,  sham_swingl6 ] {ai_charge(7);};
void() sham_swingl6 =[ $swingl6,  sham_swingl7 ] {ai_charge(9);};
void() sham_swingl7 =[ $swingl7,  sham_swingl8 ] {ai_charge(5); ShamClaw(250);};
void() sham_swingl8 =[ $swingl8,  sham_swingl9 ] {ai_charge(4);};
void() sham_swingl9 =[ $swingl9,  sham_run1    ] {ai_charge(8);
    if (SwingAgain ())  // PM:  Don't swing if enemy was gibbed.
        self.think = sham_swingr1;
};

void() sham_swingr1 =[ $swingr1,  sham_swingr2 ] {sham_melee_sfx(1); ai_charge(1);};
void() sham_swingr2 =[ $swingr2,  sham_swingr3 ] {ai_charge(8);};
void() sham_swingr3 =[ $swingr3,  sham_swingr4 ] {ai_charge(14);};
void() sham_swingr4 =[ $swingr4,  sham_swingr5 ] {ai_charge(7);};
void() sham_swingr5 =[ $swingr5,  sham_swingr6 ] {ai_charge(3);};
void() sham_swingr6 =[ $swingr6,  sham_swingr7 ] {ai_charge(6);};
void() sham_swingr7 =[ $swingr7,  sham_swingr8 ] {ai_charge(6); ShamClaw(-250);};
void() sham_swingr8 =[ $swingr8,  sham_swingr9 ] {ai_charge(3);};
void() sham_swingr9 =[ $swingr9,  sham_run1    ] {ai_charge(11);    // !
// PM:  Combine two calls to ai_charge (1,10) into one (11).
    if (SwingAgain ())  // PM:  Don't swing if enemy was gibbed.
        self.think = sham_swingl1;
};

//- - - - - - - - -
// Quickened attacks -- custom addition for meaner monsters.
void() sham_csmash1  =[ $smash2,   sham_csmash2  ] {sham_melee_sfx(1);ai_charge(6);};
void() sham_csmash2  =[ $smash4,   sham_csmash3  ] {ai_charge(14);};
void() sham_csmash3  =[ $smash6,   sham_csmash4  ] {ai_charge(5);};
void() sham_csmash4  =[ $smash8,   sham_csmash5  ] {ai_charge(0);};
void() sham_csmash5  =[ $smash9,   sham_csmash6  ] {ai_charge(0);};
void() sham_csmash6  =[ $smash10,  sham_csmash7  ] {ShamClaw(0);};
void() sham_csmash7  =[ $smash12,  sham_run1     ] {ai_charge(9);};

void() sham_cswingr1;

void() sham_cswingl1 =[ $swingl2,  sham_cswingl2 ] {sham_melee_sfx(2);ai_charge(8);};
void() sham_cswingl2 =[ $swingl4,  sham_cswingl3 ] {ai_charge(10);};
void() sham_cswingl3 =[ $swingl5,  sham_cswingl4 ] {ai_charge(7);};
void() sham_cswingl4 =[ $swingl6,  sham_cswingl5 ] {ai_charge(9);};
void() sham_cswingl5 =[ $swingl7,  sham_cswingl6 ] {ai_charge(5); ShamClaw(250);};
void() sham_cswingl6 =[ $swingl9,  sham_run1     ] {ai_charge(12);
    if (SwingAgain ())  // PM:  Don't swing if enemy was gibbed.
        self.think = sham_cswingr1;
};

void() sham_cswingr1 =[ $swingr2,  sham_cswingr2 ] {sham_melee_sfx(1);ai_charge(9);};
void() sham_cswingr2 =[ $swingr4,  sham_cswingr3 ] {ai_charge(21);};
void() sham_cswingr3 =[ $swingr5,  sham_cswingr4 ] {ai_charge(3);};
void() sham_cswingr4 =[ $swingr6,  sham_cswingr5 ] {ai_charge(6);};
void() sham_cswingr5 =[ $swingr7,  sham_cswingr6 ] {ai_charge(6); ShamClaw(-250);};
void() sham_cswingr6 =[ $swingr9,  sham_run1     ] {ai_charge(6);
    if (SwingAgain ())  // PM:  Don't swing if enemy was gibbed.
        self.think = sham_cswingl1;
};
//- - - - - - - - -

void() sham_melee =
{
    local   float   chance;
    local   float   fast;

    if (IsShamVile ())
        fast = TRUE;
    else
        fast = SUB_QuickAttack ();

    chance = random();
    if ((chance > 0.6) || (self.health >= self.max_health))
    {   if (fast)    // Use faster attacks in Cranked mode.
            sham_csmash1 ();
        else
            sham_smash1 ();
    }
    else if (chance > 0.3)
    {   if (fast)
            sham_cswingr1 ();
        else
            sham_swingr1 ();
    }
    else
    {   if (fast)
            sham_cswingl1 ();
        else
            sham_swingl1 ();
    }
};


//============================================================================

void() sham_raise1  =[ $smash12, sham_raise2  ] {ai_ritual();};
void() sham_raise2  =[ $smash11, sham_raise3  ] {ai_ritual();};
void() sham_raise3  =[ $smash10, sham_raise4  ] {ai_ritual();};
void() sham_raise4  =[ $smash10, sham_raise6  ] {ai_ritual();};
//void() sham_raise5  =[ $smash10, sham_raise6  ] {ai_ritual();};
void() sham_raise6  =[ $smash9,  sham_raise7  ] {ai_ritual();};
void() sham_raise7  =[ $smash8,  sham_raise8  ] {ai_ritual();};
void() sham_raise8  =[ $smash6,  sham_raise9  ] {ai_ritual();};
void() sham_raise9  =[ $smash5,  sham_raise10 ] {ai_ritual(); self.fallen = world;};
void() sham_raise10 =[ $smash4,  sham_raise11 ] {};
void() sham_raise11 =[ $smash3,  sham_raise12 ] {};
void() sham_raise12 =[ $smash2,  sham_raise13 ] {};
void() sham_raise13 =[ $smash1,  sham_run1    ] {};


//============================================================================

//- - - - - - - - -
void() CastVileFire =
{
    local   vector  org, spot;
    local   float   damage, direct;

    org = self.origin + '0 0 40';           // As lightning source.
    spot = self.enemy.origin + '0 0 16';    // As lightning target point.

    self.effects = self.effects | EF_MUZZLEFLASH;
    ai_face ();

    traceline (org, spot, TRUE, self);
    if (trace_fraction < 1)
        if (!CanDamage (self.enemy, self))
            return;

//    org = Aimpoint (self.enemy);
//    org = org + (normalize(org - self.origin + '0 0 40') * 8);
    org = spot + (normalize(spot - org) * 8);

// Arch-Vile had two damage calls.
//    T_Damage (self.enemy, self, self, 20);
//    T_RadiusDamage (self.enemy, self, 70, world);

    // Update:  Inflict double standard lightning damage instead of old
    // complicated archsham method.
    damage = 60;
    if (self.enemy.classname == "monster_zombie")
        direct = self.enemy.health + 50;
    else
        direct = SUB_RandomDamage (damage);

    // Note:  Doesn't auto-gib when slain like in old archsham mod.
    T_Damage (self.enemy, self.enemy, self, direct);
    T_NewRadiusDamage (self.enemy, self, damage, self.enemy, DF_SAFE|DF_PUSH_NPC, "");
    if (self.enemy.flags & FLx_CREATURE)
    {   // Old arch-sham velocity changed to nemesant's.
        self.enemy.velocity_x = (random() * 400) - 200;
        self.enemy.velocity_y = (random() * 400) - 200;
        self.enemy.velocity_z = (random() * 300) + 400;
        self.enemy.flags = self.enemy.flags - (self.enemy.flags & FL_ONGROUND);
    }

    Rocket_Explosion1 (org);
    ShockWave (org, 0, 6, "progs/s_wave.spr");
    MakeExplosion (org);
};
//- - - - - - - - -
void() CastLightning =
{
    local    vector    org, dir;
    
    self.effects = self.effects | EF_MUZZLEFLASH;

    ai_face ();

    org = self.origin + '0 0 40';
    if (pointcontents(org) <= CONTENT_WATER)
        return;     // PM:  Can't cast sparky underwater.
    dir = Maim_Line (org, self.enemy.origin + '0 0 16', 0, self.enemy, '0 0 0');
    LightningBolt1 (org, self.origin + dir*600, self, 10);
};

void() ShamMagicRemove =
{
// 'self' is the static electricity crackling between the shambler's hands.
// 'self.owner' should be the shambler that spawned 'self',
// and 'self.owner.owner' should be the same as 'self'.

    if (self.owner)
        if (self.owner.owner == self)
            self.owner.owner = world;
    remove (self);
};

void() ShamMagicThink =
{
    if (self.delay <= time)
        {ShamMagicRemove ();  return;}
    self.nextthink = time + 0.05;

// Update location, in case shambler was moved.
    self.angles = self.owner.angles;
    setorigin (self, self.owner.origin);
};

// Note:  If adding arch-vile, use this too.
void() VileMagicThink =
{
    local   vector  v1, v2;
    local   entity  attacker, targ;

    if (self.delay <= time)
        {ShamMagicRemove ();  return;}
    self.nextthink = time + 0.1;    // Leave at 0.1 for flame effects below.

    attacker = self.owner;
    targ = attacker.enemy;

    // Update location, in case 'Vile was moved.
    self.angles = attacker.angles;
    makevectors (self.angles);
    self.origin = attacker.origin + (v_forward*self.dest_x) +
        (v_right*self.dest_y) + (v_up*self.dest_z);
    setorigin (self, self.origin);

// See if attack can hit target.  If so, spawn some fire, like Arch-Vile.
    v1 = attacker.origin + '0 0 40';
    v2 = targ.origin + '0 0 16';
    traceline (v1, v2, TRUE, self);
    if (trace_fraction < 1)
        if (!CanDamage (targ, attacker))
            return;

    if (self.cnt)
    {
        self.cnt = 0;
        sound (targ, CHAN_AUTO, "shamvile/burn.wav", 1, ATTN_NORM);
    }
    MakeFlame (targ);
    self.lefty = !self.lefty;
    if (self.lefty)
        MakeFlame (targ);
};
//- - - - - - - - -
void() shamvile_magic6  =[ $magic6,  shamvile_magic9  ]
{
    if (self.owner)
        {remove (self.owner); self.owner = world;}
    CastVileFire ();    // Arch-Vile attack knockoff.
};
void() shamvile_magic9  =[ $magic9,  shamvile_magic10 ] {ai_face();};
void() shamvile_magic10 =[ $magic10, shamvile_magic11 ] {ai_face();};
void() shamvile_magic11 =[ $magic11, sham_magic12     ] {ai_face();};
//- - - - - - - - -
void() sham_magic1  =[ $magic1,  sham_magic2  ] {ai_face();
    // Note:  dsvilatk.wav from Doom2 is nice for the Vile variant,
    // but nsoe2 uses many sounds, so stick with the basic shambler sound.
    sound (self, CHAN_WEAPON, "shambler/sattck1.wav", 1, ATTN_NORM);
};
void() sham_magic2  =[ $magic2,  sham_magic3  ] {ai_face();};
void() sham_magic3  =[ $magic3,  sham_magic4  ]
{
    ai_face();

//    self.nextthink = self.nextthink + 0.2;

    if (!SUB_QuickAttack ())
        self.nextthink = time + 0.3;

    local   entity  o;

    self.effects = self.effects | EF_MUZZLEFLASH;
    ai_face();

// PM:  Changed effects thinking so it sticks to shambler in case it moves.
// Also, use custom sprite file for classic fireball so it gets drawn.
    self.owner = spawn();
    o = self.owner;
    if (IsShamVile ())
    {   // Sham-vile magic.
        self.nextthink = self.nextthink + 0.1;  // Extend delay a bit more.
        o.frame     = X56_PUFF_ORANGE;
        setmodel (o, "progs/s_fancy.spr");  // Use in case of ports like Qrack.
        makevectors (self.angles);
        o.origin = self.origin + (v_forward*30) + (v_right*20) + (v_up*78);
        setorigin (o, o.origin);
        // Do some semblence of arch-vile flames.
        o.dest      = '30 20 78';
        o.cnt       = 1;
        o.think     = VileMagicThink;
    }
    else
    {   // Standard lightning bolt.
        o.frame     = 0;
        setmodel (o, "progs/s_light.mdl");
        setorigin (o, self.origin);
        o.think     = ShamMagicThink;
    }
    o.nextthink = 0.01;
    o.delay     = time + 1; //0.7;
    o.angles    = self.angles;
    o.owner     = self;     // Heh, they own each other.
};
void() sham_magic4  =[ $magic4,  sham_magic5  ]
{
    self.effects = self.effects | EF_MUZZLEFLASH;
    if (self.owner)
    {   // Frame may not be at zero.
        self.owner.frame = self.owner.frame + 1;    //1;
        if (self.owner.lefty)
            {MakeFlame (self.enemy);  MakeFlame (self.enemy);}
    }
};
void() sham_magic5  =[ $magic5,  sham_magic6  ]
{
    self.effects = self.effects | EF_MUZZLEFLASH;
    if (self.owner)
    {
        self.owner.frame = self.owner.frame + 1;    //2;
        if (self.owner.lefty)
            {MakeFlame (self.enemy);  MakeFlame (self.enemy);}
    }
    if (IsShamVile ())
        self.think = shamvile_magic6;
};
void() sham_magic6  =[ $magic6,  sham_magic9  ]
{
    if (self.owner)
        {remove (self.owner); self.owner = world;}
    CastLightning();     // mouth = '24 -10 40' for magic678.
//    sound (self, CHAN_WEAPON, "shambler/sboom.wav", 1, ATTN_NORM);
    Sfx_Zap ();     // PM:  Use thunderbolt sounds.
};
void() sham_magic9  =[ $magic9,  sham_magic10 ] {CastLightning();};   //'18 -8 47'
void() sham_magic10 =[ $magic10, sham_magic11 ] {CastLightning();};   //'-28 -5 52'
void() sham_magic11 =[ $magic11, sham_magic12 ] {if (skill == 3) CastLightning();};   //'-24 0 52'
void() sham_magic12 =[ $magic12, sham_run1    ] {};

//- - - - - - - - -
// PM:  Sha'Vile missile attack.
// Can choose either to lob fireballs or to spawn an explosion.
void() shamvile_magic =
{
    local   float   chance;

// Don't lob fireballs at enemies immune to them.
    if (range (self.enemy) > RANGE_MID)
        chance = random() * 0.6;    // Arch-Vile has max range of 1024, unless shot.
    else if (self.enemy.classname == "monster_zombie")
        chance = 1;     // Fireballs aren't strong enough.
    else if (IsGhost (self.enemy))
        chance = 1;     // Fireballs pass through harmlessly.
    else
        chance = random();
// Select attack to use.
    if (chance > 0.6)
        sham_magic1 ();
    else if (chance > 0.3)
        sham_cswingr1 ();
    else
        sham_cswingl1 ();
};
//- - - - - - - - -


// PAIN - - - - - - - - - - - - - - - -
void() sham_pain1 =[ $pain1, sham_pain2 ] {};
void() sham_pain2 =[ $pain2, sham_pain3 ] {};
void() sham_pain3 =[ $pain3, sham_pain4 ] {};
void() sham_pain4 =[ $pain4, sham_pain5 ] {};
void() sham_pain5 =[ $pain5, sham_pain6 ] {};
void() sham_pain6 =[ $pain6, sham_run1  ] {};

void(entity attacker, float damage) sham_pain =
{
    if (self.pain_finished > time)
        return;

    if (IsShamVile ())
        sound (self, CHAN_VOICE, "shamvile/shurt2.wav", 1, ATTN_NORM);
    else
        sound (self, CHAN_VOICE, "shambler/shurt2.wav", 1, ATTN_NORM);
    self.pain_finished = time + 0.5;

    if (random()*400 > damage)
        return;         // didn't flinch
    if (SUB_IgnorePain ())
        return;         // No pain anims in Nightmare.

    // Managed to send the mighty shambler reeling.
    // If hit while casting, remove the spell.
    if (self.owner)
        {remove (self.owner); self.owner = world;}
    self.pain_finished = time + 2;      // Extend the pain time.
    sham_pain1 ();
    attacker = attacker;    // FrikQcc warning squelch!
};


//============================================================================

// DEATH - - - - - - - - - - - - - - - -
//void() sham_decap1  =[ $decap1,  sham_decap2  ] {blood_spray('16 0 40', 1);};
void() sham_decap2  =[ $decap2,  sham_decap3  ] {blood_spray('-8 8 55', 1);};
void() sham_decap3  =[ $decap3,  sham_decap4  ] {blood_spray('-16 7 54', 2); monster_drop();};
void() sham_decap4  =[ $decap4,  sham_decap5  ] {blood_spray('-16 6 50', 1);};
void() sham_decap5  =[ $decap5,  sham_decap6  ] {blood_spray('-20 4 42', 1);};
void() sham_decap6  =[ $decap6,  sham_decap7  ] {}; //blood_spray('-20 -2 32', 1);};
void() sham_decap7  =[ $decap7,  sham_decap8  ] {};
void() sham_decap8  =[ $decap8,  sham_decap9  ] {};
void() sham_decap9  =[ $decap9,  sham_decap10 ] {};
void() sham_decap10 =[ $decap10, sham_decap11 ] {};
void() sham_decap11 =[ $decap11, decap_end    ] {};

void() sham_death1  =[ $death1,  sham_death2  ] {};
void() sham_death2  =[ $death2,  sham_death3  ] {};
void() sham_death3  =[ $death3,  sham_death4  ] {monster_drop();};
void() sham_death4  =[ $death4,  sham_death5  ] {};
void() sham_death5  =[ $death5,  sham_death6  ] {};
void() sham_death6  =[ $death6,  sham_death7  ] {};
void() sham_death7  =[ $death7,  sham_death8  ] {};
void() sham_death8  =[ $death8,  sham_death9  ] {};
void() sham_death9  =[ $death9,  sham_death10 ] {};
void() sham_death10 =[ $death10, sham_death11 ] {};
void() sham_death11 =[ $death11, monster_end  ] {};

float(float dm) sham_gib =
{
    if (self.health < self.gib_health)
    {
        sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
        ThrowGib ("progs/gib1.mdl", dm);
        ThrowGib ("progs/gib2.mdl", dm);
        ThrowGib ("progs/gib3.mdl", dm);
        ThrowHead ("progs/h_shams.mdl", dm);
        return TRUE;
    }
    return FALSE;
};

void() sham_die =
{
// Remove all spellcasting effects.
    if (self.owner)
        {remove (self.owner); self.owner = world;}

// check for gib
    if (Shattered ())
        return;
    if (Decapitated ())
    {
        monster_decap ('-8 8 55', sham_decap2);     //'16 0 40', sham_decap1
        return;
    }

// check for gib
    if (sham_gib (self.health))
        return;

// regular death
    if (IsShamVile ())
        sound (self, CHAN_VOICE, "shamvile/sdeath.wav", 1, ATTN_NORM);
    else
        sound (self, CHAN_VOICE, "shambler/sdeath.wav", 1, ATTN_NORM);
    sham_death1 ();
};

// REVIVE - - - - - - - - - - - - - - -
void() sham_revive1  =[ $death10, sham_revive2  ] {};
void() sham_revive2  =[ $death9,  sham_revive3  ] {};
void() sham_revive3  =[ $death8,  sham_revive4  ] {};
void() sham_revive4  =[ $death7,  sham_revive5  ] {};
void() sham_revive5  =[ $death6,  sham_revive6  ] {};
void() sham_revive6  =[ $death5,  sham_revive7  ] {};
void() sham_revive7  =[ $death4,  sham_revive8  ] {};
void() sham_revive8  =[ $death3,  sham_revive9  ] {};
void() sham_revive9  =[ $death2,  sham_revive10 ] {};
void() sham_revive10 =[ $death1,  sham_run1     ] {};

//============================================================================


// OTHER - - - - - - - - - - - - - - - -
void(float hello) sham_sight =
{
    if (IsShamVile ())
    {
        if (hello)
            sound (self, CHAN_VOICE, "shamvile/sidle2.wav", 1, ATTN_NORM);
        else
            sound (self, CHAN_VOICE, "shamvile/ssight2.wav", 1, ATTN_NORM);
        return;
    }
    if (hello)
        sound (self, CHAN_VOICE, "shambler/sidle.wav", 1, ATTN_NORM);
    else
        sound (self, CHAN_VOICE, "shambler/ssight.wav", 1, ATTN_NORM);
};

void() sham_cache =
{
    precache_model ("progs/shambler.mdl");
    precache_model ("progs/s_light.mdl");
    precache_model ("progs/h_shams.mdl");
    precache_model ("progs/bolt.mdl");
    
    precache_sound ("shambler/sattck1.wav");
//    precache_sound ("shambler/sboom.wav");
    precache_sound ("shambler/sdeath.wav");
    precache_sound ("shambler/shurt2.wav");
    precache_sound ("shambler/sidle.wav");
    precache_sound ("shambler/ssight.wav");
    precache_sound ("shambler/melee1.wav");
    precache_sound ("shambler/melee2.wav");
    precache_sound ("shambler/smack.wav");
//    precache_sound ("weapons/lhit.wav");
//    precache_sound ("weapons/lstart.wav");
};

void() shamvile_cache =
{
// Sha'Vile exclusive sounds.
    precache_model ("progs/shambler.mdl");
    precache_model ("progs/h_shams.mdl");
    precache_model ("progs/k_ball.mdl");        // Fireballs

    precache_sound ("baron/fireball.wav");
    precache_sound ("shambler/sattck1.wav");
    precache_sound ("shambler/smack.wav");
    precache_sound ("shamvile/burn.wav");
    precache_sound ("shamvile/melee3.wav");
    precache_sound ("shamvile/melee4.wav");
    precache_sound ("shamvile/sdeath.wav");
    precache_sound ("shamvile/shurt2.wav");
    precache_sound ("shamvile/sidle2.wav");
    precache_sound ("shamvile/ssight2.wav");
    precache_sound ("weapons/fwall.wav");
    precache_sound ("weapons/fwallhit.wav");
//    precache_sound ("weapons/fwalltap.wav");
};

//============
// --> QUAKED monster_shambler (1 0 0) (-32 -32 -24) (32 32 64) Ambush Vile
//============
void() monster_shamvile;
//============
void() monster_shambler =
{
    if (self.spawnflags & 2)
        self.classname = "monster_shamvile";

    if (!self.spawned)
    {
        if (noenemies)
            {remove (self); return;}
        if (IsShamVile ())
            shamvile_cache ();
        else
            sham_cache ();
    }

    if (IsShamVile ())
    {   // Meaner variant.
    // SoE Hack:  Disable shamviles' revival powers in soe2m6.
        self.lip = 0;
        if (!self.spawned)
            if (world.model == "maps/soe2m6.bsp")
                {self.lip = 1;  self.health = 600;}
        self.skin       = 2;
        monster_form ("progs/shambler.mdl", VEC_HULL2_MIN, VEC_HULL2_MAX, 1000, -60);
        self.th_missile = shamvile_magic;
        self.th_spawn   = monster_shamvile;
    // Gets fire resistance for being hellspawn.
        self.resist_fire    = 0.5;
    }
    else
    {   // Standard.
        monster_form ("progs/shambler.mdl", VEC_HULL2_MIN, VEC_HULL2_MAX, 600, -60);
        self.th_missile = sham_magic1;
        self.th_revive  = sham_revive1;
        self.th_spawn   = monster_shambler;
    // Gets cold resistance because he looks like an abominable snowman.
        self.resist_cold    = 0.5;
    }
    self.mdl_head   = "progs/h_shams.mdl";
    self.mass       = MASS_HEAVY;

    self.th_stand   = sham_stand1;
    self.th_walk    = sham_walk1;
    self.th_run     = sham_run_go;      // Was sham_run1.
//    self.th_missile = sham_magic1;
    self.th_melee   = sham_melee;
    self.th_pain    = sham_pain;
    self.th_die     = sham_die;
    //- - - - - - - -
    self.th_check   = ShamCheckAttack;
    self.th_sight   = sham_sight;
    self.th_gib     = sham_gib;
//    self.th_revive  = sham_revive1;

// Rocket resistance is standard.
    self.resist_rocket  = 0.5;
// Model is too big for burning to look good.
    self.xfl        = XFL_NO_BURN | XFL_IMMUNITY | XFL_GHOST_BANE;
    if (soul_evil)
        monster_purse (4, 0.5, 1);

    monster_start ();
};

//============
// --> QUAKED monster_shamvile (1 0 0) (-32 -32 -24) (32 32 64) Ambush
// Sha'Vile: Meaner black shambler with classic Arch-Vile powers.
//============
void() monster_shamvile =
{
    self.classname = "monster_shamvile";
    monster_shambler ();
};

/* FIXME:  Not ready yet!
//============
// --> QUAKED monster_yeti (1 0 0) (-32 -32 -24) (32 32 64) Ambush
// Shambler with snowman skin.  Breathes ice instead of lightning.
// Otherwise, it is the same monster.
//============
void() monster_yeti =
{
    self.classname = "monster_yeti";
    monster_shambler ();
};
*/


//===========================/  END OF FILE  /===========================//
