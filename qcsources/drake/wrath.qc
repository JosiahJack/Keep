/*
==============================================================================

WRATH / WRAITH

==============================================================================
*/

$skin wrthskin

$frame first

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10 walk11
$frame walk12

$frame attack1 attack2 attack3 attack4 attack5 attack6 attack7
$frame attack8 attack9 attack10 attack11 attack12 attack13 attack14

$frame attackb1 attackb2 attackb3 attackb4 attackb5 attackb6 attackb7
$frame attackb8 attackb9 attackb10 attackb11 attackb12 attackb13

$frame attackc1 attackc2 attackc3 attackc4 attackc5 attackc6 attackc7
$frame attackc8 attackc9 attackc10 attackc11 attackc12 attackc13
$frame attackc14 attackc15

$frame pain1 pain2 pain3 pain4 pain5 pain6

$frame painb1 painb2 painb3 painb4 painb5 painb6 painb7 painb8 painb9
$frame painb10 painb11

$frame death1 death2 death3 death4 death5 death6 death7 death8 death9
$frame death10 death11 death12 death13 death14 death15

// PM:  Extended scenes for wraith variant.
$frame frame

$frame form1 form2 form3 form4 form5 form6 form7 form8 form9 form10 form11
$frame form12 form13 form14 form15 form16 form17 form18 form19

$frame painc1 painc2 painc3 painc4 painc5 painc6

$frame paind1 paind2 paind3 paind4 paind5 paind6 paind7 paind8 paind9
$frame paind10 paind11

$frame aether1 aether2 aether3 aether4 aether5 aether6 aether7
$frame aether8 aether9 aether10 aether11 aether12 aether13 aether14
$frame aether15 aether16 aether17 aether18

$frame deathb1 deathb2 deathb3 deathb4 deathb5 deathb6 deathb7 deathb8
$frame deathb9 deathb10

//==========================================================================
//  WrathMissile

void() WrathHome =[ 0, WrathHome ]
{
// PM:  Also remove missile if player goes to intermission or cutscene.
    if ((self.enemy.health < 1) || !self.enemy.modelindex)
        {remove(self); return;}

// PM:  Many engines do not support fullbright colors, so make the ball
// ping light periodically.
    if (self.attack_finished <= time)
    {
        self.effects = self.effects | EF_MUZZLEFLASH;
        self.attack_finished = time + 0.5;
    }

// NOTE:  Since the missiles are faster, don't bother searching for other
// missiles to merge into.
    particle (self.origin, '0 0 0', 233, 10);
    ai_track (self.enemy, self.speed);
    Ghost_Touch ();     // NEW:  Hit ghosts too!
};

void() WrathMissileTouch =
{
    if (other == self.master || (other.family & FAM_WRATH))
    {   // don't explode on any wraths
        remove (self);
        return;
    }
    T_MissileTouch ();
};

// Launches a homing missile with much in common with shalmissile.
void(vector start, vector dir) Wrath_Launch =
{
    local   entity  missile;

    missile = spawn ();
    missile.master      = missile.owner     = self;
    missile.movetype    = MOVETYPE_FLYMISSILE;
    missile.solid       = SOLID_BBOX;
// set missile speed
    if (skill >= 3)
        missile.speed       = 550;
    else
        missile.speed       = 400;
    missile.velocity    = dir * 400;
    missile.avelocity   = '300 300 300';
//    missile.angles      = vectoangles(missile.velocity);
// set missile damage
    if (cranked)
        missile.dmg         = 30;
    else
        missile.dmg         = 20;
    missile.enemy       = self.enemy;
    missile.style       = DF_ROCKET | DF_SAFE | DF_ZKILL;
    missile.worldtype   = MDAM_GRENADE;
    missile.yaw_speed   = 360;  // PM: Let dragons know this cannot be dodged.
// set missile duration
    missile.touch       = WrathMissileTouch;
    missile.nextthink   = time + 0.1;
    missile.think       = WrathHome;
    missile.think1      = Orange_Explosion;     // In shot.qc.
    missile.attack_finished = 0;

    setform (missile, "progs/w_ball.mdl", '0 0 0', '0 0 0');
    setorigin (missile, start);

    newmis = missile;
};

void(float AttackNumber) WrathMissile =
{
    local   vector  dir, org;

    self.effects = self.effects | EF_MUZZLEFLASH;
    self.attack_finished = time + 2;

    dir = normalize((self.enemy.origin + '0 0 10') - self.origin);
    makevectors (self.angles);
    if (AttackNumber == 1)          // Clap
        org = self.origin + v_forward*20 + v_up*12; // 20 // 44;
    else if (AttackNumber == 2)     // Ball
        org = self.origin + v_forward*18 + v_up*10; // 18 // 42;
    else if (AttackNumber == 3)     // Shove
        org = self.origin + v_forward*12 + v_up*12 + v_right*20;
    else if (AttackNumber == 4)     // Overlord
        org = self.origin + v_forward*20 + v_up*16;

    Wrath_Launch (org, dir);
};


//==========================================================================

void() wraith_flash =
{
    if (!self.modelindex)
        if (random() < 0.2)
            SUB_Flash ();
};

void() wraith_idle_sfx =
{
// Note:  skin 0 is the normal wrath skin.  skin 1 is a grayscale version
// with red eyes.  The latter is used for the ghostly wraith.  From here on,
// any conditional with 'self.skin' will assume wraith and not wrath.
    if (self.skin)
    {
        if (random() < 0.2)
        {   if (random() < 0.8)
                sound (self, CHAN_VOICE, "wraith/idle.wav", 1, ATTN_IDLE);
            else
                sound (self, CHAN_VOICE, "wraith/weird.wav", 1, ATTN_IDLE);
        }
    }
};

void() wraith_stand_fx =
{
    if (random() < 0.3)
        SUB_Flash ();
    if (random() < 0.05)
        sound (self, CHAN_VOICE, "wraith/idle.wav", 1, ATTN_IDLE);
};

// AETHER - - - - - - - - - - - - - - -
void() wraith_melee;
void() wraith_attack;

void() wraith_aether1  =[ $aether1,  wraith_aether2  ] {aether_out1();};
void() wraith_aether2  =[ $aether2,  wraith_aether3  ] {};
void() wraith_aether3  =[ $aether3,  wraith_aether4  ] {};
void() wraith_aether4  =[ $aether4,  wraith_aether5  ] {};
void() wraith_aether5  =[ $aether5,  wraith_aether6  ] {};
void() wraith_aether6  =[ $aether6,  wraith_aether7  ] {};
void() wraith_aether7  =[ $aether7,  wraith_aether8  ] {};
void() wraith_aether8  =[ $aether8,  wraith_aether9  ] {};
void() wraith_aether9  =[ $aether9,  wraith_aether10 ] {};
void() wraith_aether10 =[ $aether10, wraith_aether11 ] {};
void() wraith_aether11 =[ $aether11, wraith_aether12 ] {};
void() wraith_aether12 =[ $aether12, wraith_aether13 ] {};
void() wraith_aether13 =[ $aether13, wraith_aether14 ] {};
void() wraith_aether14 =[ $aether14, wraith_aether15 ] {};
void() wraith_aether15 =[ $aether15, wraith_aether16 ] {};
void() wraith_aether16 =[ $aether16, wraith_aether17 ] {};
void() wraith_aether17 =[ $aether17, wraith_aether18 ] {};
void() wraith_aether18 =[ $aether17, wrath_run1      ] {aether_out2();};

// Reappear on second frame to prevent any interpolation display glitches.
// FIXME:  Does not always prevent interpolation.
void() wraith_appear1  =[ $aether17, wraith_appear2  ] {self.nextthink = 0.01;};
void() wraith_appear2  =[ $aether17, wraith_appear3  ] {aether_in1();};
void() wraith_appear3  =[ $aether16, wraith_appear4  ] {};
void() wraith_appear4  =[ $aether15, wraith_appear5  ] {};
void() wraith_appear5  =[ $aether14, wraith_appear6  ] {};
void() wraith_appear6  =[ $aether13, wraith_appear7  ] {};
void() wraith_appear7  =[ $aether12, wraith_appear8  ] {};
void() wraith_appear8  =[ $aether11, wraith_appear9  ] {};
void() wraith_appear9  =[ $aether10, wraith_appear10 ] {};
void() wraith_appear10 =[ $aether9,  wraith_appear11 ] {};
void() wraith_appear11 =[ $aether8,  wraith_appear12 ] {};
void() wraith_appear12 =[ $aether7,  wraith_appear13 ] {};
void() wraith_appear13 =[ $aether6,  wraith_appear14 ] {};
void() wraith_appear14 =[ $aether5,  wraith_appear15 ] {};
void() wraith_appear15 =[ $aether4,  wraith_appear16 ] {};
void() wraith_appear16 =[ $aether3,  wraith_appear17 ] {};
void() wraith_appear17 =[ $aether2,  wraith_appear18 ] {};
void() wraith_appear18 =[ $aether1,  wrath_run1      ] {aether_in2(wraith_melee, wraith_attack);};

void() wraith_souls1  =[ $attack1,  wraith_souls2  ] {ai_face();
    sound (self, CHAN_VOICE, "wraith/talk1.wav", 1, ATTN_IDLE);
    self.gorging = TRUE;
//- - - - - - - - -
// If skipping phasing anim to attack, make sure wraith can take damage.
    if (!self.takedamage)
        if (self.modelindex)
//        if (( self.frame >= $form1 ) && ( self.frame <= $form19 ))
            self.takedamage = DAMAGE_AIM;
//- - - - - - - - -
};
void() wraith_souls2  =[ $attack10, wraith_souls3  ] {ai_face();};
void() wraith_souls3  =[ $attack11, wraith_souls4  ] {ai_face();};
void() wraith_souls4  =[ $attack12, wraith_souls3  ] {ai_face();
    if (self.enemy.classname != "soul")
        self.think = wrath_run1;
    else
        self.nextthink = random() * 0.2 + 0.1 + time;
};

// TRUE = Scene change.
float(float d, float run) ai_wraith1 =
{
    if (self.spawnflags & SPAWN_SOUL)
    {
        if (ai_aether (wraith_aether1, wraith_appear1))
            return TRUE;
        ai_wraith ("wraith/speak.wav");
        if (run)
        {   if (ai_souls (d, wraith_souls1))
                return TRUE;
        }
        else
        {   if (Wraith_FindSoul ())
                {self.th_run();  return TRUE;}
        }
    }
    else
        ai_wraith ("wraith/speak.wav");
    return FALSE;
};

// STAND - - - - - - - - - - - - - - - -
void() ai_wraith_stand =
{
    if (self.skin)
    {
        if (ai_wraith1 (0, FALSE))
            return;
        if (!self.modelindex)
            if (!(self.spawnflags & 1) || (self.attack_state == AS_FLEEING))
                wraith_stand_fx ();
    }
    ai_stand();
};
void() wrath_stand1 =[ $walk1,  wrath_stand1 ] {ai_wraith_stand();};

// WALK - - - - - - - - - - - - - - - -
void(float d) ai_wraith_walk =
{
    if (self.skin)
    {
        if (ai_wraith1 (0, FALSE))
            return;
        wraith_flash ();
        if ( self.frame == $walk1 )
            wraith_idle_sfx ();
    }
    ai_walk(d);
};
void() wrath_walk1  =[ $walk1,  wrath_walk2  ] {ai_wraith_walk(8);};
void() wrath_walk2  =[ $walk2,  wrath_walk3  ] {ai_wraith_walk(8);};
void() wrath_walk3  =[ $walk3,  wrath_walk4  ] {ai_wraith_walk(8);};
void() wrath_walk4  =[ $walk4,  wrath_walk5  ] {ai_wraith_walk(8);};
void() wrath_walk5  =[ $walk5,  wrath_walk6  ] {ai_wraith_walk(8);};
void() wrath_walk6  =[ $walk6,  wrath_walk7  ] {ai_wraith_walk(8);};
void() wrath_walk7  =[ $walk7,  wrath_walk8  ] {ai_wraith_walk(8);};
void() wrath_walk8  =[ $walk8,  wrath_walk9  ] {ai_wraith_walk(8);};
void() wrath_walk9  =[ $walk9,  wrath_walk10 ] {ai_wraith_walk(8);};
void() wrath_walk10 =[ $walk10, wrath_walk11 ] {ai_wraith_walk(8);};
void() wrath_walk11 =[ $walk11, wrath_walk12 ] {ai_wraith_walk(8);};
void() wrath_walk12 =[ $walk12, wrath_walk1  ] {ai_wraith_walk(8);};

// RUN - - - - - - - - - - - - - - - - -
void(float d) ai_wraith_run =
{
    if (self.skin)
    {
        if (ai_wraith1 (d, TRUE))
            return;
        wraith_flash ();
        if ( self.frame == $walk1 )
            wraith_idle_sfx ();
    }
    ai_run(d);
};
void() wrath_run1   =[ $walk1,  wrath_run2   ] {ai_wraith_run(self.speed);};
void() wrath_run2   =[ $walk2,  wrath_run3   ] {ai_wraith_run(self.speed);};
void() wrath_run3   =[ $walk3,  wrath_run4   ] {ai_wraith_run(self.speed);};
void() wrath_run4   =[ $walk4,  wrath_run5   ] {ai_wraith_run(self.speed);};
void() wrath_run5   =[ $walk5,  wrath_run6   ] {ai_wraith_run(self.speed);};
void() wrath_run6   =[ $walk6,  wrath_run7   ] {ai_wraith_run(self.speed);};
void() wrath_run7   =[ $walk7,  wrath_run8   ] {ai_wraith_run(self.speed);};
void() wrath_run8   =[ $walk8,  wrath_run9   ] {ai_wraith_run(self.speed);};
void() wrath_run9   =[ $walk9,  wrath_run10  ] {ai_wraith_run(self.speed);};
void() wrath_run10  =[ $walk10, wrath_run11  ] {ai_wraith_run(self.speed);};
void() wrath_run11  =[ $walk11, wrath_run12  ] {ai_wraith_run(self.speed);};
void() wrath_run12  =[ $walk12, wrath_run1   ] {ai_wraith_run(self.speed);};

// For those summoned by Dark Lord.
void() wrath_grow1  =[ $form9,  wrath_grow2  ] {ai_face();};
void() wrath_grow2  =[ $form11, wrath_grow3  ] {ai_face();};
void() wrath_grow3  =[ $form13, wrath_grow4  ] {ai_face();};
void() wrath_grow4  =[ $form15, wrath_grow5  ] {ai_face();};
void() wrath_grow5  =[ $form17, wrath_run1   ] {ai_face();};

// ATTACK - - - - - - - - - - - - - - -
// Like ai_melee, but heals wrath as it causes damage.  Built for wraths.
void() ai_drain =
{
    local   float   damage, dflags, rgb, den;
    local   vector  vec;

    if (!self.enemy)
        return;
    if (!InMeleeRange (80))     // Wrath has long arms.
        return;
    if (!IsGhost (self))    // In case non-ghost uses this.
        if (!CanDamage (self.enemy, self))
            return;

    if (self.skin)
        rgb = 145;      // Purple for wraith.
    else
        rgb = 233;      // Orange for wrath.

// No armor, because armor cannot block incorporal attacks.
// Leech, because the wraith will suck and drain your life force.
    dflags = DF_NO_ARMOR | DF_LEECH;
    damage = SUB_MeleeDamage (3);
    den = ceil(damage * 4);

// Play effects.
    self.effects = self.effects | EF_MUZZLEFLASH;
    if (!self.t_width)
        sound (self, CHAN_WEAPON, "wraith/drain.wav", 1, ATTN_NORM);
    self.t_width = self.t_width + 1;

    makevectors (self.angles);
    vec = self.origin + (v_forward*47) + (v_right*6) + (v_up*10);
    particle (vec, '0 0 1', rgb, den);
// Do the damage.
    T_NewDamage (self.enemy, self, self, damage, dflags, "melee");
};

void() wrath_fail1   =[ $attackc13,  wrath_fail2   ] {ai_charge(self.speed);};
void() wrath_fail2   =[ $attackc14,  wrath_fail3   ] {ai_charge(self.speed);};
void() wrath_fail3   =[ $attackc15,  wrath_run1    ] {ai_charge(self.speed);};

void() wrath_melee1  =[ $attackc15,  wrath_melee2  ] {ai_charge(self.speed);};
void() wrath_melee2  =[ $attackc14,  wrath_melee3  ] {ai_charge(self.speed);};
void() wrath_melee3  =[ $attackc13,  wrath_melee4  ] {ai_charge(self.speed);};
void() wrath_melee4  =[ $attackc9,   wrath_melee5  ] {ai_charge(self.speed); self.t_width = 0; ai_drain();};
void() wrath_melee5  =[ $attackc9,   wrath_melee6  ] {ai_charge(self.speed); ai_drain();};
void() wrath_melee6  =[ $attackc9,   wrath_melee7  ] {ai_charge(self.speed); ai_drain();
    if (self.t_width)
    {   // Wraith touched its target.
        if (self.t_width < 5)
            if (self.enemy.health > 0)
                if (InMeleeRange (80))
                    self.think = wrath_melee6;     // Suck some more life.
        return;
    }
    self.think = wrath_fail1;
};
void() wrath_melee7  =[ $attackc8,   wrath_melee8  ] {ai_charge(self.speed);};
void() wrath_melee8  =[ $attackc7,   wrath_melee9  ] {ai_charge(self.speed);};
// Todo:  Skip next two frames if cranked.
void() wrath_melee9  =[ $attackc6,   wrath_melee10 ] {ai_charge(self.speed);};
void() wrath_melee10 =[ $attackc5,   wrath_melee11 ] {ai_charge(self.speed);};
//
void() wrath_melee11 =[ $attackc4,   wrath_melee12 ] {ai_charge(self.speed);};
void() wrath_melee12 =[ $attackc3,   wrath_melee13 ] {ai_charge(self.speed);};
void() wrath_melee13 =[ $attackc2,   wrath_melee14 ] {ai_charge(self.speed);};
void() wrath_melee14 =[ $attackc1,   wrath_run1    ] {ai_charge(self.speed);};

void(float ofs) wrath_shot =
{
    local   vector  dir, org;

    dir = hknight_shot_dir (ofs);       // Calls 'makevectors'.
    org = self.origin + self.mins + self.size*0.5 + v_forward * 20;

// set missile speed
    launch_spike (org, dir);
    newmis.worldtype = TE_KNIGHTSPIKE;
    newmis.classname = "knightspike";
    if (self.skin)
    {   // Wraith
        sound (self, CHAN_WEAPON, "baron/throb.wav", 1, ATTN_NORM);
        setmodel (newmis, "progs/wr_spike.mdl");
        setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
        if (self.classname == "monster_wraith_lord")
            newmis.velocity = normalize(newmis.velocity)*600;
        else if (( self.frame >= $attack10 ) && ( self.frame <= $attack13 ))
            newmis.velocity = normalize(newmis.velocity)*450;
        else    // Assume shots were sweated out passively.
            newmis.velocity = normalize(newmis.velocity)*300;
    }
    else
    {
        sound (self, CHAN_WEAPON, "hknight/attack1.wav", 1, ATTN_NORM);
        setmodel (newmis, "progs/k_spike.mdl");
        setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
        if (self.classname == "monster_super_wrath")
            newmis.velocity = normalize(newmis.velocity)*450;
        else
            newmis.velocity = normalize(newmis.velocity)*300;
    }
};

//- - - - - - - - -
void() ai_wraith_charge =
{
    if (self.attack_state == AS_FLEEING)
        ai_face ();
    else
        ai_charge(self.speed);
};

void() wrath_spray1  =[ $attack14, wrath_spray2  ] {ai_wraith_charge();};
void() wrath_spray2  =[ $attack13, wrath_spray3  ] {ai_wraith_charge();wrath_shot(0);};
void() wrath_spray3  =[ $attack12, wrath_spray4  ] {ai_wraith_charge();wrath_shot(-1);wrath_shot(1);};
void() wrath_spray4  =[ $attack11, wrath_spray5  ] {ai_wraith_charge();wrath_shot(-2);wrath_shot(2);};
void() wrath_spray5  =[ $attack10, wrath_spray6  ] {ai_wraith_charge();};  //wrath_shot(-3);wrath_shot(3);}
void() wrath_spray6  =[ $attack9,  wrath_spray7  ] {ai_wraith_charge();};
void() wrath_spray7  =[ $attack8,  wrath_spray8  ] {ai_wraith_charge();};
void() wrath_spray8  =[ $attack7,  wrath_spray9  ] {ai_wraith_charge();};
void() wrath_spray9  =[ $attack6,  wrath_spray10 ] {ai_wraith_charge();};
void() wrath_spray10 =[ $attack5,  wrath_spray11 ] {ai_wraith_charge();};
void() wrath_spray11 =[ $attack4,  wrath_spray12 ] {ai_wraith_charge();};
void() wrath_spray12 =[ $attack3,  wrath_spray13 ] {ai_wraith_charge();};
void() wrath_spray13 =[ $attack2,  wrath_spray14 ] {ai_wraith_charge();};
void() wrath_spray14 =[ $attack1,  wrath_run1    ] {ai_wraith_charge();};

void() wrath_orb1  =[ $attackb1,  wrath_orb2  ] {ai_wraith_charge();};
void() wrath_orb2  =[ $attackb2,  wrath_orb3  ] {ai_wraith_charge();};
void() wrath_orb3  =[ $attackb3,  wrath_orb4  ] {ai_wraith_charge();};
void() wrath_orb4  =[ $attackb4,  wrath_orb5  ] {ai_wraith_charge();};
void() wrath_orb5  =[ $attackb5,  wrath_orb6  ] {ai_wraith_charge();};
void() wrath_orb6  =[ $attackb6,  wrath_orb7  ] {ai_wraith_charge();};
void() wrath_orb7  =[ $attackb7,  wrath_orb8  ] {ai_wraith_charge();
// Note:  Was done in the previous frame.
    if (self.skin)
        M_Shal30 ('18 0 10');
    else
        WrathMissile(2);
};
void() wrath_orb8  =[ $attackb8,  wrath_orb9  ] {ai_wraith_charge();};
void() wrath_orb9  =[ $attackb9,  wrath_orb10 ] {ai_wraith_charge();};
void() wrath_orb10 =[ $attackb10, wrath_orb11 ] {ai_wraith_charge();};
void() wrath_orb11 =[ $attackb11, wrath_orb12 ] {ai_wraith_charge();};
void() wrath_orb12 =[ $attackb12, wrath_orb13 ] {ai_wraith_charge();};
void() wrath_orb13 =[ $attackb13, wrath_run1  ] {ai_wraith_charge();};

void() wrath_attack = 
{
    local   float   r;

    sound (self, CHAN_VOICE, "wrath/watt.wav", 1, ATTN_NORM);
    r = random();
    if (self.enemy.classname == "monster_zombie")
    {   // Blast zombies out of existance.
        wrath_orb1 ();
        return;
    }
    if (r < 0.25)
    {   if (self.enemy.xfl & XFL_ARMORED)
            wrath_orb1 ();  // Missile spray is ineffective, so orb enemy!
        else
            wrath_spray1 ();
    }
    else if (InMeleeRange (80))
        wrath_melee1 ();
    else
        wrath_orb1 ();
};

// PAIN - - - - - - - - - - - - - - - -
void() wrath_pain1   =[ $pain1,   wrath_pain2   ] {};
void() wrath_pain2   =[ $pain2,   wrath_pain3   ] {};
void() wrath_pain3   =[ $pain3,   wrath_pain4   ] {};
void() wrath_pain4   =[ $pain4,   wrath_pain5   ] {};
void() wrath_pain5   =[ $pain5,   wrath_pain6   ] {};
void() wrath_pain6   =[ $pain6,   wrath_run1    ] {};

void() wrath_painb1  =[ $painb1,  wrath_painb2  ] {};
void() wrath_painb2  =[ $painb2,  wrath_painb3  ] {};
void() wrath_painb3  =[ $painb3,  wrath_painb4  ] {};
void() wrath_painb4  =[ $painb4,  wrath_painb5  ] {};
void() wrath_painb5  =[ $painb5,  wrath_painb6  ] {};
void() wrath_painb6  =[ $painb6,  wrath_painb7  ] {};
void() wrath_painb7  =[ $painb7,  wrath_painb8  ] {};
void() wrath_painb8  =[ $painb8,  wrath_painb9  ] {};
void() wrath_painb9  =[ $painb9,  wrath_painb10 ] {};
void() wrath_painb10 =[ $painb10, wrath_painb11 ] {};
void() wrath_painb11 =[ $painb11, wrath_run1    ] {};

void() wrath_pain =
{
    local   float   r;

    if (SUB_IgnorePain ())
        return;     // No pain anims in Nightmare.
    if (self.pain_finished > time)
        return;

    r = random();
    if (r > 0.1)
    {
        self.pain_finished = time + 0.5;
        return;
    }
            
    self.pain_finished = time + 3;
    sound (self, CHAN_VOICE, "wrath/wpain.wav", 1, ATTN_NORM);
    if (r < 0.07)
        wrath_pain1 ();
    else 
        wrath_painb1 ();
};

// DEATH - - - - - - - - - - - - - - - -
// DISABLED -- No holy weapons that smash undead.  Mjolnir doesn't count.
//void() wrath_disrupt9  =[ $aether9,  wrath_disrupt10 ]
//{
////    self.skin = 1;
//    self.solid = SOLID_NOT;
//    self.takedamage = DAMAGE_NO;
//    self.movetype = MOVETYPE_NONE;

//    if (self.health > -50)
//        self.health = -50;
//    ThrowGib ("progs/wrthgib1.mdl", self.health);
//    ThrowGib ("progs/wrthgib2.mdl", self.health);
//    ThrowGib ("progs/wrthgib3.mdl", self.health);
//    Rocket_Explosion2 (self.origin, 0, 4);
//};
//void() wrath_disrupt10 =[ $aether10, wrath_disrupt11 ] {};
//void() wrath_disrupt11 =[ $aether11, wrath_disrupt12 ] {};
//void() wrath_disrupt12 =[ $aether12, wrath_disrupt13 ] {};
//void() wrath_disrupt13 =[ $aether13, wrath_disrupt14 ] {};
//void() wrath_disrupt14 =[ $aether14, wrath_disrupt15 ] {};
//void() wrath_disrupt15 =[ $aether15, wrath_disrupt16 ] {};
//void() wrath_disrupt16 =[ $aether16, wrath_disrupt17 ] {};
//void() wrath_disrupt17 =[ $aether17, wrath_disrupt18 ] {};
//void() wrath_disrupt18 =[ $aether17, SUB_Null        ] {monster_null ();  monster_rod ();};

void() wrath_die1  =[ $death2, wrath_die2  ] {
    if (Shattered ())
        return;
// DISABLED -- Holy weapons were scrapped.
//    if (Dispelled ())
//    {   // Killed by holy weapon?
//        wrath_disrupt9 ();
//        return;
//    }
    sound (self, CHAN_VOICE, "wrath/wdthc.wav", 1, ATTN_NORM);
};
void() wrath_die2 =[ $death3,  wrath_die3  ] {};
void() wrath_die3 =[ $death4,  wrath_die4  ] {};
void() wrath_die4 =[ $death5,  wrath_die5  ] {};
void() wrath_die5 =[ $death7,  wrath_die6  ] {};
void() wrath_die6 =[ $death9,  wrath_die7  ] {};
void() wrath_die7 =[ $death11, wrath_die8  ] {};
void() wrath_die8 =[ $death13, wrath_die9  ] {};
void() wrath_die9 =[ $death15, SUB_Null    ] 
{
    monster_dead (TRUE);    // It's dead -- unlink pets and drop items.

    ThrowGib ("progs/wrthgib1.mdl", self.health);
    ThrowGib ("progs/wrthgib2.mdl", self.health);
    ThrowGib ("progs/wrthgib3.mdl", self.health);

    T_RadiusDamage (self, self, 80, world);
    Rocket_Explosion2 (self.origin + '0 0 24', 0, 4);

    monster_null ();    // PM:  Sever all other connections first.
    monster_rod ();
//    remove (self);
};

// OTHER - - - - - - - - - - - - - - - -
void(float hello) wrath_sight =
{
    if (!hello)
        sound (self, CHAN_VOICE, "wrath/wsee.wav", 1, ATTN_NORM);
};

void() wrath_cache =
{
    precache_model ("progs/k_spike.mdl");
    precache_model ("progs/wrath.mdl");
    precache_model ("progs/w_ball.mdl");
    precache_model ("progs/wrthgib1.mdl");
    precache_model ("progs/wrthgib2.mdl");
    precache_model ("progs/wrthgib3.mdl");
    
    precache_sound ("hknight/attack1.wav");
    precache_sound ("hknight/hit.wav");    // used by C code, so don't sound2
    precache_sound ("wraith/drain.wav");
    precache_sound ("wrath/wsee.wav");
    precache_sound ("wrath/watt.wav");
    precache_sound ("wrath/wpain.wav");
    precache_sound ("wrath/wdthc.wav");
};

//============
// --> QUAKED monster_wrath (1 0 0) (-16 -16 -24) (16 16 32) Ambush
//============
void() monster_wrath =
{
    if (!self.spawned)
    {
        if (noenemies)
            {remove (self); return;}
        wrath_cache ();
    }

    self.skin       = 0;
    monster_form ("progs/wrath.mdl", VEC_HULL_MIN, VEC_HULL_MAX, 400, 0);
    self.mass       = MASS_LIGHT;

    self.th_stand   = wrath_stand1;
    self.th_walk    = wrath_walk1;
    self.th_run     = wrath_run1;
    // Original didn't have melee, so leave it undefined to preserve missile
    // attack chances.  Modified wrath will delay a bit before starting melee.
    self.th_missile = wrath_attack;
    self.th_pain    = wrath_pain;
    self.th_die     = wrath_die1;   // Note:  Explodes when destroyed.
    //- - - - - - - -
    self.th_sight   = wrath_sight;
    self.th_spawn   = monster_wrath;

    self.bloodtype  = BLOOD_DARK;   // It's like the Nazgul/ringwraith.
    self.family     = FAM_UNDEAD | FAM_WRATH;
    self.xfl        = XFL_ARMORED;      // Absorb magic missiles.
    self.yaw_speed  = 35;
    self.speed      = 12;   // For wrath/wraith shared movement ai.

    flymonster_start ();
};


//==========================================================================
//  Wraith  (Merger of modified wrath and Nehahra wraith.)
//==========================================================================

// STAND - - - - - - - - - - - - - - - -
void() wraith_stand1  =[ $form17, wraith_stand2  ] {ai_wraith_stand();};
void() wraith_stand2  =[ $form15, wraith_stand3  ] {ai_wraith_stand();};
void() wraith_stand3  =[ $form13, wraith_stand4  ] {ai_wraith_stand();};
void() wraith_stand4  =[ $form11, wraith_stand5  ] {ai_wraith_stand();};
void() wraith_stand5  =[ $form9,  wraith_stand6  ] {self.takedamage = DAMAGE_NO; ai_wraith_stand();};
void() wraith_stand6  =[ $form7,  wraith_stand7  ] {ai_wraith_stand();};
void() wraith_stand7  =[ $form5,  wraith_stand8  ] {ai_wraith_stand();};
void() wraith_stand8  =[ $form3,  wraith_stand9  ] {ai_wraith_stand();};
void() wraith_stand9  =[ $form1,  wraith_stand10 ] {self.modelindex = 0; ai_wraith_stand();};
void() wraith_stand10 =[ $form1,  wraith_stand10 ] {ai_wraith_stand();};
void() wraith_stand = {wraith_start (wraith_stand1, wraith_stand9);};

// WALK - - - - - - - - - - - - - - - -
void() wraith_walk1  =[ $form17, wraith_walk2  ] {ai_wraith_walk(8);};
void() wraith_walk2  =[ $form15, wraith_walk3  ] {ai_wraith_walk(8);};
void() wraith_walk3  =[ $form13, wraith_walk4  ] {ai_wraith_walk(8);};
void() wraith_walk4  =[ $form11, wraith_walk5  ] {ai_wraith_walk(8);};
void() wraith_walk5  =[ $form9,  wraith_walk6  ] {self.takedamage = DAMAGE_NO; ai_wraith_walk(8);};
void() wraith_walk6  =[ $form7,  wraith_walk7  ] {ai_wraith_walk(8);};
void() wraith_walk7  =[ $form5,  wraith_walk8  ] {ai_wraith_walk(8);};
void() wraith_walk8  =[ $form3,  wraith_walk9  ] {ai_wraith_walk(8);};
void() wraith_walk9  =[ $form1,  wraith_walk10 ] {self.modelindex = 0;  ai_wraith_walk(8);};
void() wraith_walk10 =[ $form1,  wraith_walk10 ] {ai_wraith_walk(8);
//    wraith_stand_fx();
    wraith_flash ();
    if (random() < 1/12)    //if ( self.frame == $walk1 )
        wraith_idle_sfx ();
};
void() wraith_walk = {wraith_start (wraith_walk1, wraith_walk9);};

// RUN - - - - - - - - - - - - - - - - -
// Call reload func to prevent wraith from shooting while it phases.
void() wraith_form1  =[ $form1,  wraith_form2  ] {M_Reload (1); self.modelindex = self.mindex2; ai_wraith_run(self.speed);};
void() wraith_form2  =[ $form3,  wraith_form3  ] {ai_wraith_run(self.speed);};
void() wraith_form3  =[ $form5,  wraith_form4  ] {ai_wraith_run(self.speed);};
void() wraith_form4  =[ $form7,  wraith_form5  ] {ai_wraith_run(self.speed);};
void() wraith_form5  =[ $form9,  wraith_form6  ] {ai_wraith_run(self.speed);};
void() wraith_form6  =[ $form11, wraith_form7  ] {self.takedamage = DAMAGE_AIM; ai_wraith_run(self.speed);};
void() wraith_form7  =[ $form13, wraith_form8  ] {ai_wraith_run(self.speed);};
void() wraith_form8  =[ $form15, wraith_form9  ] {ai_wraith_run(self.speed);};
void() wraith_form9  =[ $form17, wrath_run1    ] {ai_wraith_run(self.speed);};
void() wraith_form = {wraith_start (wrath_run1, wraith_form1);};

// ATTACK - - - - - - - - - - - - - - -
void() wraith_attack =
{
    local   float   r;

//- - - - - - - - -
// If skipping phasing anim to attack, make sure wraith can take damage.
    if (!self.takedamage)
        if (( self.frame >= $form1 ) && ( self.frame <= $form19 ))
            self.takedamage = DAMAGE_AIM;
//- - - - - - - - -
    r = random();
    if ((r < 0.25) && !(self.spawnflags & 2))   // No orbs in Nehahra mode.
        wrath_orb1 ();
    else if (r < 0.5)
        wrath_spray1 ();
    else
    {   // Nehahra wraith spontaneously sweated out bullets some of the time.
        r = crandom() * 1;  //3;
        wrath_shot (r);
    }
};

void() wraith_melee =
{
    local   float   chance;

//- - - - - - - - -
// If skipping phasing anim to attack, make sure wraith can take damage.
    if (!self.takedamage)
        if (( self.frame >= $form1 ) && ( self.frame <= $form19 ))
            self.takedamage = DAMAGE_AIM;
//- - - - - - - - -
    if (InMeleeRange (80))
        chance = 0.75;
    else
        chance = 0.5;

    if (random() < chance)
        wrath_melee1 ();
    else
        wraith_attack ();
};

// PAIN - - - - - - - - - - - - - - - -
void() wraith_pain1 =[ $painc1,  wraith_pain2 ] {};
void() wraith_pain2 =[ $painc2,  wraith_pain3 ] {};
void() wraith_pain3 =[ $painc3,  wraith_pain4 ] {};
void() wraith_pain4 =[ $painc4,  wraith_pain5 ] {};
void() wraith_pain5 =[ $painc5,  wraith_pain6 ] {};
void() wraith_pain6 =[ $painc6,  wrath_run1  ] {};

//void() wraith_painb1  =[ $paind1,  wraith_painb2  ] {};
//void() wraith_painb2  =[ $paind2,  wraith_painb3  ] {};
//void() wraith_painb3  =[ $paind3,  wraith_painb4  ] {};
//void() wraith_painb4  =[ $paind4,  wraith_painb5  ] {};
//void() wraith_painb5  =[ $paind5,  wraith_painb6  ] {};
void() wraith_painb6  =[ $paind6,  wraith_painb7  ] {};
void() wraith_painb7  =[ $paind7,  wraith_painb8  ] {};
void() wraith_painb8  =[ $paind8,  wraith_painb9  ] {};
void() wraith_painb9  =[ $paind9,  wraith_painb10 ] {};
void() wraith_painb10 =[ $paind10, wraith_painb11 ] {};
void() wraith_painb11 =[ $paind11, wrath_run1    ] {};

void(entity attacker, float damage) wraith_pain =
{
// Note:  In Nehahra, wraiths always bleed when hurt.  Not here in Drake.
    local   float   r, opf;

// Run away only if using soul ai.
// Makes 100% kills too hard if wraith gets away.
    if (self.spawnflags & SPAWN_SOUL)
        if (self.health < WRAITH_HP_CRITICAL)
            self.attack_state = AS_FLEEING;

    opf = self.pain_finished;
    if (opf <= time)
    {
        r = random();
        if (r < 0.5)    //0.3)
            sound (self, CHAN_VOICE, "wraith/growl2.wav", 1, ATTN_NORM);
        else //if (r < 0.6)
            sound (self, CHAN_VOICE, "wraith/idle2.wav", 1, ATTN_NORM);
//        else
//            r = 0;
        self.pain_finished = time + 2;
    }

    if (opf > time)
        return;         // Still reeling from pain last time.
    if (SUB_IgnorePain ())
        return;         // No pain anims in Nightmare.
    if (random() < 0.4)
        return;

// Now do the standard pain routine.
    self.gorging = FALSE;   // Get out of reaper mode.
    self.pain_finished = time + 5;
    self.velocity = '0 0 0';
    if (random() < 0.5)
        wraith_pain1 ();
    else
        wraith_painb6 ();

    attacker = attacker;  damage = damage;  // Appease FrikQcc!
};

// DEATH - - - - - - - - - - - - - - - -
void() wraith_die   =[ $deathb1,  wraith_die1  ] {
    self.nextthink  = 0.01;
    self.modelindex = self.mindex2;
    self.takedamage = DAMAGE_NO;
    self.movetype = MOVETYPE_NONE;  // Freeze monster in place.
    if (random() < 0.2)
        sound (self, CHAN_VOICE, "wraith/talk3.wav", 1, ATTN_NORM);
    else
        sound (self, CHAN_VOICE, "wraith/call.wav", 1, ATTN_NORM);
};
// Use setorigin to force relink in case model is still not visible.
// Just don't call it in the same frame of a th_die call in case of loop.
void() wraith_die1  =[ $deathb1,  wraith_die2  ] {setorigin (self, self.origin);};
void() wraith_die2  =[ $deathb2,  wraith_die3  ] {};
void() wraith_die3  =[ $deathb3,  wraith_die4  ] {};
void() wraith_die4  =[ $deathb4,  wraith_die5  ] {};
void() wraith_die5  =[ $deathb5,  wraith_die6  ] {};
void() wraith_die6  =[ $deathb6,  wraith_die7  ] {monster_dead (TRUE);};
void() wraith_die7  =[ $deathb7,  wraith_die8  ] {};
void() wraith_die8  =[ $deathb8,  wraith_die9  ] {};
void() wraith_die9  =[ $deathb9,  wraith_die10 ] {};
void() wraith_die10 =[ $deathb10, monster_rod  ] {};

// OTHER - - - - - - - - - - - - - - - -
void(float hello) wraith_sight =
{
    if (hello)
        sound (self, CHAN_VOICE, "wraith/idle.wav", 1, ATTN_NORM);
    else
        sound (self, CHAN_VOICE, "wraith/talk1.wav", 1, ATTN_NORM);
};

void() wraith_cache =
{
    precache_model ("progs/soul.mdl");
    precache_model ("progs/v_spike.mdl");
    precache_model ("progs/wr_spike.mdl");
    precache_model ("progs/wrath.mdl");

    precache_sound ("baron/throb.wav");
    precache_sound ("hkboss/iceball.wav");
    precache_sound ("hknight/attack1.wav");
    precache_sound ("wraith/call.wav");
    precache_sound ("wraith/drain.wav");
    precache_sound ("wraith/growl2.wav");
    precache_sound ("wraith/idle.wav");
    precache_sound ("wraith/idle2.wav");
    precache_sound ("wraith/return.wav");
    precache_sound ("wraith/rych1.wav");    // "Got his soul!"
    precache_sound ("wraith/select.wav");
    precache_sound ("wraith/soul.wav");
    precache_sound ("wraith/speak.wav");
    precache_sound ("wraith/talk1.wav");
    precache_sound ("wraith/talk3.wav");
    precache_sound ("wraith/weird.wav");
};

//============
// --> QUAKED monster_wraith (1 0 0) (-16 -16 -24) (16 16 32) Ambush Nehahra Souls
//============
void() monster_wraith =
{
    if (!self.spawned)
    {
        if (noenemies)
            {remove (self); return;}
        wraith_cache ();
    }

    local   float   hp, calm;

    if (self.spawnflags & 2)
        {hp = 600;  calm = RYU_CALM;}   // Emulate Nehahra wraith.
    else
        {hp = 400;  calm = 0;}

// Drake:  Wraith is now a wrath variant.
    self.skin = 1;
    ghost_form ("progs/wrath.mdl", VEC_HULL_MIN, VEC_HULL_MAX, hp);

    if (self.spawnflags & 1)
    {   // Use phasing in ambush mode.
        self.th_stand   = wraith_stand;
        self.th_walk    = wraith_walk;
        self.th_run     = wraith_form;
    }
    else
    {   // The first three functions are shared by both wrath and wraith.
        self.th_stand   = wrath_stand1;
        self.th_walk    = wrath_walk1;
        self.th_run     = wrath_run1;
    }
// The rest are different.
    self.th_melee   = wraith_melee;
    self.th_missile = wraith_attack;
    self.th_pain    = wraith_pain;
    self.th_die     = wraith_die;   //die1;

// Completely silent in Nehahra, but make some noise here.
    self.th_sight   = wraith_sight;
    self.th_spawn   = monster_wraith;

    self.attack_state   = AS_STRAIGHT;
    self.alpha      = 0.7;
    self.bloodtype  = BLOOD_DARK;   // It's like the Nazgul/ringwraith.
    self.family     = FAM_UNDEAD | FAM_WRATH;
    self.ryuflags   = RYU_REAPER | calm;
    self.xfl        = XFL_ARMORED;      // Absorb magic missiles.
    // yaw_speed: wrath = 35, Neh wraith = 10.  Here, use 20.
    if (self.spawnflags & 2)
    {   // Nehahra mode.
        self.speed        = 8;
        self.attack_state = AS_CHASING;
        self.spawnflags   = self.spawnflags | SPAWN_SOUL;
    }
    else
        self.speed      = 12;

// Do this instead of 'flymonster_start' to use normal yaw speed.
    self.flags = self.flags | FL_FLY;
    monster_start ();
};


//===========================/  END OF FILE  /===========================//
