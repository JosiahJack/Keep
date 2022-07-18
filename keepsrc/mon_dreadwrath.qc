//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \ 
// |  \ |___ |___ |        |  | \__/ |__/ 
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: Drake, Rogue
//
//
// Distribution / Copyright / Permissions 
//
// Please do not use any of these assets in ANY COMMERCIAL PROJECT.
// and remember to give credit if you use any of these assets. Please credit
// the appropriate authors of the various content used.  Refer to the credits
// folder.
//				  
// The QC files in this MOD are based on 1.06 source files by ID Software.
// These files are released under the terms of GNU General Public License v2 or
// later. You may use the source files as a base to build your own MODs as long
// as you release them under the same license and make the source available.
// Please also give proper credit. Check http://www.gnu.org for details.
//
// Quake is a registered trademark of id Software, Inc.
//
// All of these resources may be electronically distributed only at 
// NO CHARGE to the recipient.
//
// Stats:
// Entity count: 
// Function count: 
//
// Implements: Dread Wraith
//
// Description:
// Similar to the Rogue Overlord (aka Super Wrath) but has a powershield and
// random teleporting.
//
// Drake:  DoE overlord did not have the powershield, but in Drake, the
// overlord in boss mode gains a reflector shield that stays on until it
// attacks, then turns back on when finished attacking.
//=============================================================================

$skin s_wrtrst
$frame s_wrtfrm
$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10 walk11
$frame walk12 walk13 walk14 walk15
$frame attack1 attack2 attack3 attack4 attack5 attack6 attack7 attack8
$frame attack9 attack10
$frame attackb1 attackb2 attackb3 attackb4 attackb5 attackb6 attackb7
$frame attackb8 attackb9 attackb10 attackb11 attackb12 attackb13 attackb14
$frame attackc1 attackc2 attackc3 attackc4 attackc5 attackc6 attackc7
$frame attackc8 attackc9 attackc10 attackc11 attackc12 attackc13 attackc14
$frame magic1 magic2 magic3 magic4 magic5 magic6 magic7 magic8 magic9
$frame magic10 magic11 magic12
$frame pain1 pain2 pain3 pain4 pain5 pain6 pain7 pain8 pain9 pain10
$frame pain11 pain12 pain13 pain14
$frame painb1 painb2 painb3 painb4 painb5 painb6 painb7 painb8 painb9
$frame painb10 painb11 
$frame death1 death2 death3 death4 death5 death6 death7 death8 death9
$frame death10 death11 death12 death13 death14 death15 death16 death17
$frame frame1 // PM:  Extended scenes for wraith lord variant.
$frame form1 form2 form3 form4 form5 form6 form7 form8 form9 form10 form11
$frame form12 form13 form14 form15 form16 form17 form18 form19
$frame painc1 painc2 painc3 painc4 painc5 painc6 painc7
$frame paind1 paind2 paind3 paind4 paind5 paind6 paind7
$frame aether1 aether2 aether3 aether4 aether5 aether6 aether7
$frame aether8 aether9 aether10 aether11 aether12 aether13 aether14
$frame aether15 aether16 aether17 aether18
$frame deathb1 deathb2 deathb3 deathb4 deathb5 deathb6 deathb7 deathb8
$frame deathb9 deathb10

void() ai_shield_on = {
    if (self.spawnflags & 2)
        ReflectorShield (self);
};
void() ai_shield_off = {
    if (self.spawnflags & 2)
        if (!self.mirror_finished)
            self.effects = self.effects - (self.effects & EF_BRIGHTFIELD);
};

// AETHER - - - - - - - - - - - - - - -
void() overlord_attack;

void() dreadlord_aether1  = [$aether1,  dreadlord_aether2  ] { ai_shield_off(); aether_out1(); };
void() dreadlord_aether2  = [$aether2,  dreadlord_aether3  ] {};
void() dreadlord_aether3  = [$aether3,  dreadlord_aether4  ] {};
void() dreadlord_aether4  = [$aether4,  dreadlord_aether5  ] {};
void() dreadlord_aether5  = [$aether5,  dreadlord_aether6  ] {};
void() dreadlord_aether6  = [$aether6,  dreadlord_aether7  ] {};
void() dreadlord_aether7  = [$aether7,  dreadlord_aether8  ] {};
void() dreadlord_aether8  = [$aether8,  dreadlord_aether9  ] {};
void() dreadlord_aether9  = [$aether9,  dreadlord_aether10 ] {};
void() dreadlord_aether10 = [$aether10, dreadlord_aether11 ] {};
void() dreadlord_aether11 = [$aether11, dreadlord_aether12 ] {};
void() dreadlord_aether12 = [$aether12, dreadlord_aether13 ] {};
void() dreadlord_aether13 = [$aether13, dreadlord_aether14 ] {};
void() dreadlord_aether14 = [$aether14, dreadlord_aether15 ] {};
void() dreadlord_aether15 = [$aether15, dreadlord_aether16 ] {};
void() dreadlord_aether16 = [$aether16, dreadlord_aether17 ] {};
void() dreadlord_aether17 = [$aether17, dreadlord_aether18 ] {};
void() dreadlord_aether18 = [$aether17, overlord_run1      ] { aether_out2(); };

void() dreadlord_appear1  = [$aether17, dreadlord_appear2  ] {};
void() dreadlord_appear2  = [$aether17, dreadlord_appear3  ] { aether_in1(); };
void() dreadlord_appear3  = [$aether16, dreadlord_appear4  ] {};
void() dreadlord_appear4  = [$aether15, dreadlord_appear5  ] {};
void() dreadlord_appear5  = [$aether14, dreadlord_appear6  ] {};
void() dreadlord_appear6  = [$aether13, dreadlord_appear7  ] {};
void() dreadlord_appear7  = [$aether12, dreadlord_appear8  ] {};
void() dreadlord_appear8  = [$aether11, dreadlord_appear9  ] {};
void() dreadlord_appear9  = [$aether10, dreadlord_appear10 ] {};
void() dreadlord_appear10 = [$aether9,  dreadlord_appear11 ] {};
void() dreadlord_appear11 = [$aether8,  dreadlord_appear12 ] {};
void() dreadlord_appear12 = [$aether7,  dreadlord_appear13 ] {};
void() dreadlord_appear13 = [$aether6,  dreadlord_appear14 ] {};
void() dreadlord_appear14 = [$aether5,  dreadlord_appear15 ] {};
void() dreadlord_appear15 = [$aether4,  dreadlord_appear16 ] {};
void() dreadlord_appear16 = [$aether3,  dreadlord_appear17 ] {};
void() dreadlord_appear17 = [$aether2,  dreadlord_appear18 ] {};
void() dreadlord_appear18 = [$aether1,  overlord_run1      ] { aether_in2(overlord_attack, overlord_attack); };

void() dreadlord_souls1  = [$attackb1,  dreadlord_souls2  ] {
	ai_face();
    sound(self,CHAN_VOICE, "wraith/talk1.wav",1,ATTN_IDLE);
    self.gorging = TRUE;
    if (!self.takedamage && self.modelindex) self.takedamage = DAMAGE_AIM; // If skipping phasing anim to attack, make sure wraith can take damage.

};
void() dreadlord_souls2  = [$attackc14, dreadlord_souls3  ] { ai_face(); };
void() dreadlord_souls3  = [$attackb1,  dreadlord_souls2  ] { ai_face();
    if (self.enemy.classtype != CT_SOUL) self.think = overlord_run1;
    else self.nextthink = random() * 0.2 + 0.1 + time;
};

float(float d, float run) ai_wraith2 = {
    ai_wraith("wraith/speak.wav");
    return FALSE;
};

void() ai_wraith2_stand = {
    if (self.skin) {
        if (ai_wraith2 (0, FALSE)) return;

        if (!self.modelindex)
            if (!(self.spawnflags & 1) || (self.attack_state == AS_FLEEING)) wraith_stand_fx();
    }
    ai_stand();
};
void() overlord_stand1 = [$walk1,  overlord_stand1 ] { ai_shield_off(); ai_wraith2_stand(); };

void(float d) ai_wraith2_walk = {
    if (self.skin) {
        if (ai_wraith2 (0, FALSE)) return;

        if (random() < 0.2) self.effects = self.effects | EF_MUZZLEFLASH;
        if (self.frame == $walk1 )
            wraith_idle_sfx();
    }
    ai_walk(d);
};
void() overlord_walk1  = [$walk1,  overlord_walk2  ] { ai_shield_off(); ai_wraith2_walk(8); };
void() overlord_walk2  = [$walk2,  overlord_walk3  ] { ai_wraith2_walk(8); };
void() overlord_walk3  = [$walk3,  overlord_walk4  ] { ai_wraith2_walk(8); };
void() overlord_walk4  = [$walk4,  overlord_walk5  ] { ai_wraith2_walk(8); };
void() overlord_walk5  = [$walk5,  overlord_walk6  ] { ai_wraith2_walk(8); };
void() overlord_walk6  = [$walk6,  overlord_walk7  ] { ai_wraith2_walk(8); };
void() overlord_walk7  = [$walk7,  overlord_walk8  ] { ai_wraith2_walk(8); };
void() overlord_walk8  = [$walk8,  overlord_walk9  ] { ai_wraith2_walk(8); };
void() overlord_walk9  = [$walk9,  overlord_walk10 ] { ai_wraith2_walk(8); };
void() overlord_walk10 = [$walk10, overlord_walk11 ] { ai_wraith2_walk(8); };
void() overlord_walk11 = [$walk11, overlord_walk12 ] { ai_wraith2_walk(8); };
void() overlord_walk12 = [$walk12, overlord_walk13 ] { ai_wraith2_walk(8); };
void() overlord_walk13 = [$walk13, overlord_walk14 ] { ai_wraith2_walk(8); };
void() overlord_walk14 = [$walk14, overlord_walk15 ] { ai_wraith2_walk(8); };
void() overlord_walk15 = [$walk15, overlord_walk1  ] { ai_wraith2_walk(8); };

void(float d) ai_wraith2_run = {
    if (self.skin) {
        if (ai_wraith2(d, TRUE)) return;

        if (random() < 0.2) self.effects = self.effects | EF_MUZZLEFLASH;
        if (self.frame == $walk1) wraith_idle_sfx();
    }
    ai_run(d);
};
void() overlord_run1   = [$walk1,  overlord_run2   ] { ai_shield_on(); ai_wraith2_run(self.speed); };
void() overlord_run2   = [$walk2,  overlord_run3   ] { ai_wraith2_run(self.speed); };
void() overlord_run3   = [$walk3,  overlord_run4   ] { ai_wraith2_run(self.speed); };
void() overlord_run4   = [$walk4,  overlord_run5   ] { ai_wraith2_run(self.speed); };
void() overlord_run5   = [$walk5,  overlord_run6   ] { ai_wraith2_run(self.speed); };
void() overlord_run6   = [$walk6,  overlord_run7   ] { ai_wraith2_run(self.speed); };
void() overlord_run7   = [$walk7,  overlord_run8   ] { ai_wraith2_run(self.speed); };
void() overlord_run8   = [$walk8,  overlord_run9   ] { ai_wraith2_run(self.speed); };
void() overlord_run9   = [$walk9,  overlord_run10  ] { ai_wraith2_run(self.speed); };
void() overlord_run10  = [$walk10, overlord_run11  ] { ai_wraith2_run(self.speed); };
void() overlord_run11  = [$walk11, overlord_run12  ] { ai_wraith2_run(self.speed); };
void() overlord_run12  = [$walk12, overlord_run13  ] { ai_wraith2_run(self.speed); };
void() overlord_run13  = [$walk13, overlord_run14  ] { ai_wraith2_run(self.speed); };
void() overlord_run14  = [$walk14, overlord_run15  ] { ai_wraith2_run(self.speed); };
void() overlord_run15  = [$walk15, overlord_run1   ] { ai_wraith2_run(self.speed); };

// PM:  Changed from void to float type so overlord can shoot on a miss.
float() overlord_smash = {
    local   vector  delta;
    local   float   smashDmg;

    ai_charge(self.speed);  // Was 10.

    if (!self.enemy)
        return TRUE;
    if (!CanDamage (self.enemy, self))
        return FALSE;
    if (!InMeleeRange (100))
        return FALSE;

    smashDmg = 20 + random() * 10;
    
    sound(self,CHAN_WEAPON,"s_wrath/smash.wav",1,ATTN_NORM);
    T_Damage(self.enemy, self, self, smashDmg);
    delta = normalize (self.enemy.origin - self.origin + self.enemy.view_ofs);
    SpawnBlood(self.enemy,self.enemy.origin - delta * 30, delta * -100, smashDmg, 0);
    return TRUE;
};

// Axe - - - - - - -
// PM:  No tele check at end of axe throw.
void() overlord_throw = [$attack10, overlord_refire] { ai_charge(self.speed); };

void() overlord_axe1  = [$attack1,  overlord_axe2  ] { ai_charge(self.speed); };
void() overlord_axe2  = [$attack2,  overlord_axe3  ] { ai_charge(self.speed); };
void() overlord_axe3  = [$attack3,  overlord_axe4  ] { ai_charge(self.speed); };
void() overlord_axe4  = [$attack4,  overlord_axe5  ] { ai_charge(self.speed); };
void() overlord_axe5  = [$attack5,  overlord_axe6  ] { ai_charge(self.speed); };
void() overlord_axe6  = [$attack6,  overlord_axe7  ] { ai_charge(self.speed); };
void() overlord_axe7  = [$attack7,  overlord_axe8  ] {
    if (!overlord_smash())      // Smites enemy in melee range.
    {
        M_FireAxe ('62 16 9', "progs/throwax2.mdl");
        self.think = overlord_throw;
    }
};
void() overlord_axe8  = [$attack8,  overlord_axe9  ] { ai_charge(self.speed); };
void() overlord_axe9  = [$attack9,  overlord_axe10 ] { ai_charge(self.speed); };
void() overlord_axe10 = [$attack10, overlord_run1  ] { ai_charge(self.speed); };

// Mace - - - - - -
void() overlord_spray1 = [$attackc6,  overlord_spray2 ] { nehwraith_shot(2);nehwraith_shot(1); };
void() overlord_spray2 = [$attackc7,  overlord_spray3 ] { ai_charge(self.speed);nehwraith_shot(0);nehwraith_shot(-1);nehwraith_shot(-2);nehwraith_shot(-3); };
void() overlord_spray3 = [$attackb11, overlord_spray4 ] { ai_charge(self.speed); };
void() overlord_spray4 = [$attackb12, overlord_spray5 ] { ai_charge(self.speed); };
void() overlord_spray5 = [$attackb13, overlord_spray6 ] { ai_charge(self.speed); };
void() overlord_spray6 = [$attackb14, overlord_run1   ] { ai_charge(self.speed);overlord_teleport(); };

void() overlord_mace1  = [$attackc1,  overlord_mace2  ] { ai_charge(self.speed); };
void() overlord_mace2  = [$attackc2,  overlord_mace3  ] { ai_charge(self.speed); };
void() overlord_mace3  = [$attackc3,  overlord_mace4  ] { ai_charge(self.speed); };
void() overlord_mace4  = [$attackc4,  overlord_mace5  ] { ai_charge(self.speed); };
void() overlord_mace5  = [$attackc5,  overlord_mace6  ] { ai_charge(self.speed); };
void() overlord_mace6  = [$attackc6,  overlord_mace7  ] {
    if (!overlord_smash())      // Smites enemy in melee range.
        overlord_spray1();     // Launch missiles on a miss.
};
void() overlord_mace7  = [$attackc7,  overlord_mace8  ] { ai_charge(self.speed); };
void() overlord_mace8  = [$attackc8,  overlord_mace9  ] { ai_charge(self.speed); };
void() overlord_mace9  = [$attackc9,  overlord_mace10 ] { ai_charge(self.speed); };
void() overlord_mace10 = [$attackc10, overlord_mace11 ] { ai_charge(self.speed); };
void() overlord_mace11 = [$attackc11, overlord_mace12 ] { overlord_smash(); };
void() overlord_mace12 = [$attackc12, overlord_mace13 ] { ai_charge(self.speed); };
void() overlord_mace13 = [$attackc13, overlord_mace14 ] { ai_charge(self.speed); };
void() overlord_mace14 = [$attackc14, overlord_run1   ] { ai_charge(self.speed); };

// Orb - - - - - - -
void(float AttackNumber) WrathMissile;

void() overlord_drain1 = [$magic6,    overlord_drain2 ] { self.t_width = 0; ai_charge(self.speed); ai_drain(); };
void() overlord_drain2 = [$attackc14, overlord_drain3 ] { ai_charge(self.speed); ai_drain(); };
void() overlord_drain3 = [$attackb1,  overlord_drain4 ] { ai_charge(self.speed); ai_drain(); };
void() overlord_drain4 = [$attackc14, overlord_drain5 ] { ai_charge(self.speed); ai_drain(); };
void() overlord_drain5 = [$attackb1,  overlord_drain6 ] { ai_charge(self.speed); ai_drain(); };
void() overlord_drain6 = [$attackc14, overlord_drain7 ] { ai_charge(self.speed); ai_drain(); };
void() overlord_drain7 = [$attackb1,  overlord_run1   ] { ai_charge(self.speed); ai_drain(); };

void() overlord_magic1  = [$magic1,  overlord_magic2  ] {
    if (!self.skin)
        sound(self,CHAN_VOICE, "wrath/watt.wav",1,ATTN_NORM);
    ai_shield_off(); ai_charge(self.speed); };
void() overlord_magic2  = [$magic2,  overlord_magic3  ] { ai_charge(self.speed); };
void() overlord_magic3  = [$magic3,  overlord_magic4  ] { ai_charge(self.speed); };
void() overlord_magic4  = [$magic4,  overlord_magic5  ] { ai_charge(self.speed); };
void() overlord_magic5  = [$magic5,  overlord_magic6  ] { ai_charge(self.speed); };
void() overlord_magic6  = [$magic6,  overlord_magic7  ] {//WrathMissile(4); };
    if (self.enemy)
    if (CanDamage (self.enemy, self))
    if (InMeleeRange (80))
    {   // We can touch the target.
        overlord_drain1();
        return;
    }
    // Couldn't touch the target, so launch orb.
    if (self.classname == "monster_wraith_lord")
        M_Shal30 ('20 0 16');
    else
        WrathMissile(4);
};
void() overlord_magic7  = [$magic7,  overlord_magic8  ] { ai_charge(self.speed); };
void() overlord_magic8  = [$magic8,  overlord_magic9  ] { ai_charge(self.speed); };
void() overlord_magic9  = [$magic9,  overlord_magic10 ] { ai_charge(self.speed); };
void() overlord_magic10 = [$magic10, overlord_magic11 ] { ai_charge(self.speed); };
void() overlord_magic11 = [$magic11, overlord_magic12 ] { ai_charge(self.speed); };
void() overlord_magic12 = [$magic12, overlord_run1    ] { overlord_teleport(); };

void() overlord_attack = {
    local   float   r;

//- - - - - - - - -
// If skipping phasing anim to attack, make sure wraith can take damage.
    if (!self.takedamage)
        if ((self.frame >= $form1 ) && (self.frame <= $form19 ))
            self.takedamage = DAMAGE_AIM;
//- - - - - - - - -
    ai_shield_off();

    r = random();
//- - - - - - - - -
    if (r < 0.33)
    {
        if (self.frame == $attack10 )
            overlord_axe2();
        else
            overlord_axe1();
    }
    else if (r < 0.66)
        overlord_mace1();
    else
        overlord_magic1();
};

void() overlord_refire = {
    if (self.enemy.health > 0)
        if (visible (self.enemy))
            { overlord_attack();  return; }
    overlord_run1();
};

// PAIN - - - - - - - - - - - - - - - -
void() overlord_pain1  = [$pain1,  overlord_pain2  ] {};
void() overlord_pain2  = [$pain2,  overlord_pain3  ] {};
void() overlord_pain3  = [$pain3,  overlord_pain4  ] { overlord_teleport(); };
void() overlord_pain4  = [$pain4,  overlord_pain5  ] {};
void() overlord_pain5  = [$pain5,  overlord_pain6  ] {};
void() overlord_pain6  = [$pain9,  overlord_pain7  ] {};    //$pain6
void() overlord_pain7  = [$pain10, overlord_run1   ] {};    //$pain7

void() overlord_painb1 = [$painb1, overlord_painb2 ] {};
void() overlord_painb2 = [$painb2, overlord_painb3 ] {};
void() overlord_painb3 = [$painb3, overlord_painb4 ] { overlord_teleport(); };
void() overlord_painb4 = [$painb4, overlord_painb5 ] {};
void() overlord_painb5 = [$painb5, overlord_painb6 ] {};
void() overlord_painb6 = [$painb8, overlord_painb7 ] {};    //painb6
void() overlord_painb7 = [$painb9, overlord_run1   ] {};    //painb7

void() overlord_pain = {
    local   float   r;

    if (SUB_IgnorePain ())
        return;     // No pain anims in Nightmare.
    if (self.pain_finished > time)
        return;

    r = random();
    if (r > 0.2)
        return;

// Go to a pain frame.
    ai_shield_off();
    self.pain_finished = time + 2;
    sound(self,CHAN_VOICE, "wrath/wpain.wav",1,ATTN_NORM);
    if (r < 0.15)
        overlord_pain1();
    else 
        overlord_painb1();
};

// DEATH - - - - - - - - - - - - - - - -
void(string gibName, float eat) ol_toss = {
    local   vector  flingVelocity;

// DISABLED -- Old velocity code.
//    makevectors(self.angles);
//    flingVelocity = v_forward*250;
//    flingVelocity = flingVelocity + v_up * (300 + (random() * 100 - 50));
//    flingVelocity = flingVelocity + v_right * (random() * 200 - 100);

// PM:  More random velocity code.
    flingVelocity = self.angles;
    flingVelocity_y = random() * 360;
    makevectors(flingVelocity);
    flingVelocity = (v_forward * 250) + (v_up * (300 + (random() * 100 - 50)));

// Replaced StartGib with my gib code.
    Gib_Spawn (self.origin, gibName, flingVelocity, '0 0 0', 0, 0, eat, self.spawned);
};

void() ol_toss_loop = {
    local   float   loop;

    loop = 2;
    Rocket_Explosion2 (self.origin, 0, 4);
    while (loop > 0) {
        ol_toss("progs/gib1.mdl", TRUE);
        ol_toss("progs/gib2.mdl", TRUE);
        ol_toss("progs/gib3.mdl", TRUE);
        loop = loop - 1;
    }
};

// PM:  Modified scene for engines with interpolation.
void() overlord_die1  = [$death2,  overlord_die2  ] {
    if (Shattered()) return;
    self.flags = self.flags | FL_FLY;   // Don't fall!
    sound(self,CHAN_VOICE, "wrath/wdthc.wav",1,ATTN_NORM);
    // PM:  If ethereal, make them solid when killed.
    if (self.movetype == MOVETYPE_NOCLIP) {
        self.alpha = 0;
        self.movetype = MOVETYPE_STEP;
    }
};
void() overlord_die2  = [$death4,  overlord_die3  ] {};
void() overlord_die3  = [$death6,  overlord_die4  ] {};
void() overlord_die4  = [$death8,  overlord_die5  ] {};
void() overlord_die5  = [$death9,  overlord_die6  ] {};
void() overlord_die6  = [$death11, overlord_die7  ] {};
void() overlord_die7  = [$death13, overlord_die8  ] {};
void() overlord_die8  = [$death15, overlord_die9  ] {};
void() overlord_die9  = [$death16, overlord_die10 ] { self.model = "";
    monster_dead (TRUE);
    // PM:  Old code didn't have splash damage, which is silly if the lesser
    // wraths have it but their lords don't.  So go boom once.
    T_RadiusDamage(self, self, 80, world);
    Rocket_Explosion2 (self.origin, 0, 4);
    ol_toss("progs/s_wrtgb2.mdl", FALSE);
    ol_toss("progs/s_wrtgb3.mdl", FALSE);
    ol_toss("progs/wrthgib1.mdl", TRUE);
    ol_toss("progs/wrthgib2.mdl", TRUE);
    ol_toss("progs/wrthgib3.mdl", TRUE);
};
void() overlord_die10 = [$death17, overlord_die11 ] { ol_toss_loop(); };
void() overlord_die11 = [$death17, overlord_die11 ] {
    ol_toss_loop();
    remove(self);
};

// other -- Drake stuff

void() monster_super_wrath_precache = {
    precache_model ("progs/k_spike.mdl");
    precache_model ("progs/s_wrath.mdl");
    precache_model ("progs/s_wrtgb1.mdl");
    precache_model ("progs/s_wrtgb2.mdl");
    precache_model ("progs/s_wrtgb3.mdl");
    precache_model ("progs/throwax2.mdl");
    precache_model ("progs/wrthgib1.mdl");
    precache_model ("progs/wrthgib2.mdl");
    precache_model ("progs/wrthgib3.mdl");
    precache_model ("progs/w_ball.mdl");
    precache_sound("hknight/attack1.wav");
    precache_sound("hknight/hit.wav");    // used by C code, so don't sound2
    precache_sound("s_wrath/smash.wav");
    precache_sound("wraith/drain.wav");
    precache_sound("wrath/wsee.wav");
    precache_sound("wrath/watt.wav");
    precache_sound("wrath/wpain.wav");
    precache_sound("wrath/wdthc.wav");
};

//  Dread Lord  (Wraith Boss)

void() dreadlord_stand1  = [$form17, dreadlord_stand2  ] { ai_wraith2_stand(); };
void() dreadlord_stand2  = [$form15, dreadlord_stand3  ] { ai_wraith2_stand(); };
void() dreadlord_stand3  = [$form13, dreadlord_stand4  ] { ai_wraith2_stand(); };
void() dreadlord_stand4  = [$form11, dreadlord_stand5  ] { ai_wraith2_stand(); };
void() dreadlord_stand5  = [$form9,  dreadlord_stand6  ] { self.takedamage = DAMAGE_NO; ai_shield_off(); ai_wraith2_stand(); };
void() dreadlord_stand6  = [$form7,  dreadlord_stand7  ] { ai_wraith2_stand(); };
void() dreadlord_stand7  = [$form5,  dreadlord_stand8  ] { ai_wraith2_stand(); };
void() dreadlord_stand8  = [$form3,  dreadlord_stand9  ] { ai_wraith2_stand(); };
void() dreadlord_stand9  = [$form1,  dreadlord_stand10 ] { self.modelindex = 0; ai_wraith2_stand(); };
void() dreadlord_stand10 = [$form1,  dreadlord_stand10 ] { ai_wraith2_stand(); };
void() dreadlord_stand = { wraith_start (dreadlord_stand1, dreadlord_stand9); };

void() dreadlord_walk1  = [$form17, dreadlord_walk2  ] { ai_wraith2_walk(8); };
void() dreadlord_walk2  = [$form15, dreadlord_walk3  ] { ai_wraith2_walk(8); };
void() dreadlord_walk3  = [$form13, dreadlord_walk4  ] { ai_wraith2_walk(8); };
void() dreadlord_walk4  = [$form11, dreadlord_walk5  ] { ai_wraith2_walk(8); };
void() dreadlord_walk5  = [$form9,  dreadlord_walk6  ] { self.takedamage = DAMAGE_NO; ai_shield_off(); ai_wraith2_walk(8); };
void() dreadlord_walk6  = [$form7,  dreadlord_walk7  ] { ai_wraith2_walk(8); };
void() dreadlord_walk7  = [$form5,  dreadlord_walk8  ] { ai_wraith2_walk(8); };
void() dreadlord_walk8  = [$form3,  dreadlord_walk9  ] { ai_wraith2_walk(8); };
void() dreadlord_walk9  = [$form1,  dreadlord_walk10 ] { self.modelindex = 0;  ai_wraith2_walk(8); };
void() dreadlord_walk10 = [$form1,  dreadlord_walk10 ] { ai_wraith2_walk(8);
	if (random() < 0.2) self.effects = self.effects | EF_MUZZLEFLASH;
    if (random() < 1/12) wraith_idle_sfx();
};
void() dreadlord_walk = { wraith_start (dreadlord_walk1, dreadlord_walk9); };

// Call reload func to prevent wraith from shooting while it phases.
void() dreadlord_form1  = [$form1,  dreadlord_form2  ] { M_Reload (1); self.modelindex = self.mindex2; ai_wraith2_run(self.speed); };
void() dreadlord_form2  = [$form3,  dreadlord_form3  ] { ai_wraith2_run(self.speed); };
void() dreadlord_form3  = [$form5,  dreadlord_form4  ] { ai_wraith2_run(self.speed); };
void() dreadlord_form4  = [$form7,  dreadlord_form5  ] { ai_wraith2_run(self.speed); };
void() dreadlord_form5  = [$form9,  dreadlord_form6  ] { ai_wraith2_run(self.speed); };
void() dreadlord_form6  = [$form11, dreadlord_form7  ] { self.takedamage = DAMAGE_AIM; ai_shield_on(); ai_wraith2_run(self.speed); };
void() dreadlord_form7  = [$form13, dreadlord_form8  ] { ai_wraith2_run(self.speed); };
void() dreadlord_form8  = [$form15, dreadlord_form9  ] { ai_wraith2_run(self.speed); };
void() dreadlord_form9  = [$form17, overlord_run1    ] { ai_wraith2_run(self.speed); };
void() dreadlord_form = { wraith_start (overlord_run1, dreadlord_form1); };

void() dreadlord_pain1  = [$painc1,  dreadlord_pain2  ] {};
void() dreadlord_pain2  = [$painc2,  dreadlord_pain3  ] {};
void() dreadlord_pain3  = [$painc3,  dreadlord_pain4  ] { overlord_teleport(); };
void() dreadlord_pain4  = [$painc4,  dreadlord_pain5  ] {};
void() dreadlord_pain5  = [$painc5,  dreadlord_pain6  ] {};
void() dreadlord_pain6  = [$painc6,  dreadlord_pain7  ] {};
void() dreadlord_pain7  = [$painc7,  overlord_run1    ] {};

void() dreadlord_painb1 = [$paind1,  dreadlord_painb2 ] {};
void() dreadlord_painb2 = [$paind2,  dreadlord_painb3 ] {};
void() dreadlord_painb3 = [$paind3,  dreadlord_painb4 ] { overlord_teleport(); };
void() dreadlord_painb4 = [$paind4,  dreadlord_painb5 ] {};
void() dreadlord_painb5 = [$paind5,  dreadlord_painb6 ] {};
void() dreadlord_painb6 = [$paind6,  dreadlord_painb7 ] {};
void() dreadlord_painb7 = [$paind7,  overlord_run1    ] {};

void() dreadlord_pain = {
    local float r;

	// Don't run away unless it can phase out.
    if (self.spawnflags & SPAWN_SOUL)
        if (self.health < WRAITH_HP_AETHER)     // Don't use hp_critical.
            self.attack_state = AS_FLEEING;

    if (SUB_IgnorePain()) return; // No pain anims in Nightmare.
    if (self.pain_finished > time) return;

    r = random();
    if (r > 0.2) return;

	// Now do the standard pain routine.
    ai_shield_off();
    self.pain_finished = time + 2;
    sound(self,CHAN_VOICE, "wraith/growl2.wav",1,ATTN_NORM);
    self.velocity = '0 0 0';
    if (r < 0.15) dreadlord_pain1();
    else dreadlord_painb1();
};

void() dreadlord_die = [$deathb1,  dreadlord_die1] {
	monster_death_precheck(); // Pre-check routine to tidy up extra entities
	self.solid = SOLID_NOT;
    self.nextthink  = 0.01;
    self.modelindex = self.mindex2;
    self.takedamage = DAMAGE_NO;

	// Make sure body stays floating up where it finally dies
	// and do not drop to the ground (reset by monster_death_use func)
	self.flags = self.flags | FL_FLY;
    self.movetype = MOVETYPE_NONE;  // Freeze monster in place.
    if (random() < 0.2)
        sound(self,CHAN_VOICE, "wraith/talk3.wav",1,ATTN_NORM);
    else
        sound(self,CHAN_VOICE, "wraith/call.wav",1,ATTN_NORM);
};
// Use setorigin to force relink in case model is still not visible.
// Just don't call it in the same frame of a th_die call in case of loop.
void() dreadlord_die1  = [$deathb1,  dreadlord_die2  ] { setorigin(self,self.origin); };
void() dreadlord_die2  = [$deathb2,  dreadlord_die3  ] { monster_check_gib(); };
void() dreadlord_die3  = [$deathb3,  dreadlord_die4  ] {};
void() dreadlord_die4  = [$deathb4,  dreadlord_die5  ] {};
void() dreadlord_die5  = [$deathb5,  dreadlord_die6  ] {};
void() dreadlord_die6  = [$deathb6,  dreadlord_die7  ] { self.solid = SOLID_NOT; };
void() dreadlord_die7  = [$deathb7,  dreadlord_die8  ] {};
void() dreadlord_die8  = [$deathb8,  dreadlord_die9  ] {};
void() dreadlord_die9  = [$deathb9,  dreadlord_die10 ] { monster_death_postcheck(); };
void() dreadlord_die10 = [$deathb10, dreadlord_die10 ] { monster_deadbody_check(); };

void() monster_wraith_lord_precache = {
    precache_model ("progs/s_wrath.mdl");
    precache_model ("progs/soul.mdl");
    precache_model ("progs/throwax2.mdl");
    precache_model ("progs/v_spike.mdl");
    precache_model ("progs/wr_spike.mdl");
    precache_sound("baron/throb.wav");
    precache_sound("hkboss/iceball.wav");
    precache_sound("hknight/attack1.wav");
    precache_sound("s_wrath/smash.wav");
    precache_sound("wraith/call.wav");
    precache_sound("wraith/drain.wav");
    precache_sound("wraith/growl2.wav");
    precache_sound("wraith/idle.wav");
    precache_sound("wraith/idle2.wav");
    precache_sound("wraith/return.wav");
    precache_sound("wraith/rych1.wav");    // "Got his soul!"
    precache_sound("wraith/select.wav");
    precache_sound("wraith/soul.wav");
    precache_sound("wraith/speak.wav");
    precache_sound("wraith/talk1.wav");
    precache_sound("wraith/talk3.wav");
    precache_sound("wraith/weird.wav");
};

// --> QUAKED monster_wraith_lord (1 0 0) (-16 -16 -24) (16 16 32) Ambush BossMode Souls
// a.k.a. Dread Lord or Dread Wraith.
void() monster_wraith_lord = {
	if (monster_checkrandomizer() == TRUE) return; // Check for any random monster setups
	if (monster_checkspawn() == TRUE) return; // Check all spawn exceptions (monsters.qc)

	if (!self.mdl) self.mdl = "progs/drake/s_wrath.mdl";
	if (!self.mdl) self.gib1mdl = "progs/rogue/wrthgib1.mdl";
	if (!self.mdl) self.gib2mdl = "progs/rogue/wrthgib2.mdl";
	if (!self.mdl) self.gib3mdl = "progs/rogue/wrthgib3.mdl";
	self.pain_sound = "nehahra/wraith/wpain.wav";
	self.idle_sound = "nehahra/wraith/idle.wav";
	self.idle_sound2 = "nehahra/wraith/idle2.wav";
	self.idle_soundcom = "nehahra/wraith/idle3.wav";
	self.sight_sound = "nehahra/wraith/wsee.wav";
	self.solid = SOLID_NOT;				// No interaction with world
	self.movetype = MOVETYPE_NONE;		// Static item, no movement
	if (self.bboxtype < 1) self.bboxtype = BBOX_TALL;
	if (self.health < 1) self.health = 1000;
	self.gibhealth = MON_NEVERGIB;		// Cannot be gibbed by weapons, gibs on death always
	self.gibbed = FALSE;				// not falling apart
	self.pain_flinch = 70;				// High pain threshold
	self.blockudeath = TRUE;			// no humanoid death sound
	self.height = MONAI_ABOVEDIST;		// Enemytarget distance above
    self.skin = 1;
    self.alpha = 0.7;

    if (self.spawnflags & 1) { // Use phasing in ambush mode.
        self.th_stand   = dreadlord_stand;
        self.th_walk    = dreadlord_walk;
        self.th_run     = dreadlord_form;
    } else { // The first three functions are shared by both wrath and wraith.
        self.th_stand   = overlord_stand1;
        self.th_walk    = overlord_walk1;
        self.th_run     = overlord_run1;
    }
    self.th_missile =
    self.th_melee   = overlord_attack;
    self.th_pain    = dreadlord_pain;
    self.th_die     = dreadlord_die;
    self.th_spawn   = monster_wraith_lord;
    self.pain_finished  = 0;
    self.bloodtype      = BLOOD_DARK;
	self.classtype		= CT_MONDREADWRAITH;
    self.classgroup     = CG_SPIDER;
    self.speed          = 8;
    if (self.deathstring == "")  self.deathstring = " was desecrated by a Dread Wraith\n";
    if (self.spawnflags & 2) self.bossflag = TRUE;
	Resist_ChangeType(self,-1); // Always reset Ammo Resistance to be consistent
    monster_start();
};