/*==============================================================================
KNIGHT
==============================================================================*/
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

void() knight_statue;
void() hknight_champion_magic;

float   SKIN_HELL_KNIGHT    = 0;
float   SKIN_HELL_KNIGHT2   = 1;
float   SKIN_HELL_LORD      = 2;
float   SKIN_HKBOSS         = 3;
float   SKIN_BANE           = 4;
float   SKIN_BANE_GRAY      = 5;
float   SKIN_DARK_LORD      = 6;
float   DARKLORD_NEAR       = 250;

void(float side) bane_melee;
void() hkboss_magic;
void() lord_magic;
void() hkboss_cache;
void() hklord_cache;

void()	hknight_stand1	= [	$stand1,	hknight_stand2	] { monster_idle_sound(); ai_stand(); };
void()	hknight_stand2	= [	$stand2,	hknight_stand3	] { ai_stand(); };
void()	hknight_stand3	= [	$stand3,	hknight_stand4	] { ai_stand(); };
void()	hknight_stand4	= [	$stand4,	hknight_stand5	] { ai_stand(); };
void()	hknight_stand5	= [	$stand5,	hknight_stand6	] { ai_stand(); };
void()	hknight_stand6	= [	$stand6,	hknight_stand7	] { ai_stand(); };
void()	hknight_stand7	= [	$stand7,	hknight_stand8	] { ai_stand(); };
void()	hknight_stand8	= [	$stand8,	hknight_stand9	] { ai_stand(); };
void()	hknight_stand9	= [	$stand9,	hknight_stand1	] { ai_stand(); };

void()	hknight_walk1	= [	$walk1,		hknight_walk2	] { monster_idle_sound(); ai_walk(2); };
void()	hknight_walk2	= [	$walk2,		hknight_walk3	] { monster_footstep(FALSE); ai_walk(5); };
void()	hknight_walk3	= [	$walk3,		hknight_walk4	] { ai_walk(5); };
void()	hknight_walk4	= [	$walk4,		hknight_walk5	] { ai_walk(4); };
void()	hknight_walk5	= [	$walk5,		hknight_walk6	] { ai_walk(4); };
void()	hknight_walk6	= [	$walk6,		hknight_walk7	] { ai_walk(2); };
void()	hknight_walk7	= [	$walk7,		hknight_walk8	] { ai_walk(2); };
void()	hknight_walk8	= [	$walk8,		hknight_walk9	] { ai_walk(3); };
void()	hknight_walk9	= [	$walk9,		hknight_walk10	] { ai_walk(3); };
void()	hknight_walk10	= [	$walk10,	hknight_walk11	] { ai_walk(4); };
void()	hknight_walk11	= [	$walk11,	hknight_walk12	] { monster_footstep(FALSE); ai_walk(3); };
void()	hknight_walk12	= [	$walk12,	hknight_walk13	] { ai_walk(4); };
void()	hknight_walk13	= [	$walk13,	hknight_walk14	] { ai_walk(6); };
void()	hknight_walk14	= [	$walk14,	hknight_walk15	] { ai_walk(2); };
void()	hknight_walk15	= [	$walk15,	hknight_walk16	] { ai_walk(2); };
void()	hknight_walk16	= [	$walk16,	hknight_walk17	] { ai_walk(4); };
void()	hknight_walk17	= [	$walk17,	hknight_walk18	] { ai_walk(3); };
void()	hknight_walk18	= [	$walk18,	hknight_walk19	] { ai_walk(3); };
void()	hknight_walk19	= [	$walk19,	hknight_walk20	] { ai_walk(3); };
void()	hknight_walk20	= [	$walk20,	hknight_walk1	] { ai_walk(2); };

void()	hknight_char_b1;

float(float d) ai_medic;
void() bane_magicd1; // Checks if the Bane can use a nearby dead body.
void() bane_magice1;
void() bane_strafe;
void() magica_sword_chop;
void() M_Lightwall;

void(float d) hk_run = {
    if (self.classname == "monster_bane") {
        d = d * 2;
        if (!self.waitmax) {
            if (ai_medic(d)) { // Hack:  Set attack_finished higher than time so that CheckForCharge fails, which would otherwise bypass ritual anim.
                self.attack_finished = time + 0.2;
                bane_magicd1();
                return;
            }

            if (self.search_time + 5 < time)
            if (self.enemy)
            if (!visible (self.enemy)) { // Teleport to the enemy.
                self.attack_finished = time + 0.2;
                self.search_time = time;    //+ 5;
                bane_magice1();
                return;
            }
        }
    }
    ai_run(d);
};

void()	hknight_run1	= [	$run1,		hknight_run2	] {
	if (self.classname == "monster_dark_lord") {
		self.th_run();
		return;
	}
	monster_idle_sound(); 

    hk_run(20); CheckForCharge();
};
void()	hknight_run2	= [	$run2,		hknight_run3	] { monster_footstep(FALSE); hk_run(25); };
void()	hknight_run3	= [	$run3,		hknight_run4	] { hk_run(18); };
void()	hknight_run4	= [	$run4,		hknight_run5	] { hk_run(16); };
void()	hknight_run5	= [	$run5,		hknight_run6	] { hk_run(14); };
void()	hknight_run6	= [	$run6,		hknight_run7	] { monster_footstep(FALSE); hk_run(25); };
void()	hknight_run7	= [	$run7,		hknight_run8	] { hk_run(21); };
void()	hknight_run8	= [	$run8,		hknight_run1	] { hk_run(13); };

void()	hknight_char_a1	= [	$char_a1,	hknight_char_a2	] { ai_charge(20); };
void()	hknight_char_a2	= [	$char_a2,	hknight_char_a3	] { monster_footstep(FALSE); ai_charge(25); };
void()	hknight_char_a3	= [	$char_a3,	hknight_char_a4	] { ai_charge(18); };
void()	hknight_char_a4	= [	$char_a4,	hknight_char_a5	] { ai_charge(16);SwordSwipeSound(); };
void()	hknight_char_a5	= [	$char_a5,	hknight_char_a6	] { ai_charge(14); };
void()	hknight_char_a6	= [	$char_a6,	hknight_char_a7	] { monster_footstep(FALSE); ai_charge(20); ai_melee(); };
void()	hknight_char_a7	= [	$char_a7,	hknight_char_a8	] { ai_charge(21); ai_melee(); };
void()	hknight_char_a8	= [	$char_a8,	hknight_char_a9	] { ai_charge(13); ai_melee(); };
void()	hknight_char_a9	= [	$char_a9,	hknight_char_a10] { ai_charge(20); ai_melee(); };
void()	hknight_char_a10= [	$char_a10,	hknight_char_a11] { monster_footstep(FALSE); ai_charge(20); ai_melee(); };
void()	hknight_char_a11= [	$char_a11,	hknight_char_a12] { ai_charge(18); ai_melee(); };
void()	hknight_char_a12= [	$char_a12,	hknight_char_a13] { ai_charge(16); };
void()	hknight_char_a13= [	$char_a13,	hknight_char_a14] { ai_charge(14); };
void()	hknight_char_a14= [	$char_a14,	hknight_char_a15] { monster_footstep(FALSE); ai_charge(25); };
void()	hknight_char_a15= [	$char_a15,	hknight_char_a16] { ai_charge(21); };
void()	hknight_char_a16= [	$char_a16,	hknight_run1	] { ai_charge(13); };

void()	hknight_char_b1	= [	$char_b1,	hknight_char_b2	] { CheckContinueCharge(); ai_charge(23); ai_melee(); };
void()	hknight_char_b2	= [	$char_b2,	hknight_char_b3	] { SwordSwipeSound(); ai_charge(17); ai_melee(); };
void()	hknight_char_b3	= [	$char_b3,	hknight_char_b4	] { ai_charge(12); ai_melee(); };
void()	hknight_char_b4	= [	$char_b4,	hknight_char_b5	] { monster_footstep(FALSE); ai_charge(22); ai_melee(); };
void()	hknight_char_b5	= [	$char_b5,	hknight_char_b6	] { ai_charge(18); ai_melee(); };
void()	hknight_char_b6	= [	$char_b6,	hknight_char_b1	] { ai_charge(8); ai_melee(); };

void()	hknight_slice1	= [	$slice1,	hknight_slice2	] { ai_charge(9); };
void()	hknight_slice2	= [	$slice2,	hknight_slice3	] { ai_charge(6); };
void()	hknight_slice3	= [	$slice3,	hknight_slice4	] { monster_footstep(FALSE); ai_charge(13); };
void()	hknight_slice4	= [	$slice4,	hknight_slice5	] { SwordSwipeSound(); ai_charge(4); };
void()	hknight_slice5	= [	$slice5,	hknight_slice6	] { ai_charge(7); ai_melee(); };
void()	hknight_slice6	= [	$slice6,	hknight_slice7	] { ai_charge(15); ai_melee(); };
void()	hknight_slice7	= [	$slice7,	hknight_slice8	] { monster_footstep(FALSE); ai_charge(8); ai_melee(); };
void()	hknight_slice8	= [	$slice8,	hknight_slice9	] { ai_charge(2); ai_melee(); };
void()	hknight_slice9	= [	$slice9,	hknight_slice10	] { ai_melee(); };
void()	hknight_slice10	= [	$slice10,	hknight_run1	] { ai_charge(3); };

void()	hknight_smash1	= [	$smash1,	hknight_smash2	] { ai_charge(1); };
void()	hknight_smash2	= [	$smash2,	hknight_smash3	] { ai_charge(13); };
void()	hknight_smash3	= [	$smash3,	hknight_smash4	] { SwordSwipeSound(); ai_charge(9); };
void()	hknight_smash4	= [	$smash4,	hknight_smash5	] { monster_footstep(FALSE); ai_charge(11); };
void()	hknight_smash5	= [	$smash5,	hknight_smash6	] { ai_charge(10);
	if ((self.classname == "monster_bane") || (self.classname == "monster_dark_lord")) {
		bane_melee(0); 
	} else {
		ai_melee();
	}
};
void()	hknight_smash6	= [	$smash6,	hknight_smash7	] { ai_charge(7); ai_melee(); };
void()	hknight_smash7	= [	$smash7,	hknight_smash8	] { ai_charge(12); ai_melee(); };
void()	hknight_smash8	= [	$smash8,	hknight_smash9	] { ai_charge(2); ai_melee(); };
void()	hknight_smash9	= [	$smash9,	hknight_smash10	] { monster_footstep(FALSE); ai_charge(3); ai_melee(); };
void()	hknight_smash10	= [	$smash10,	hknight_smash11	] { ai_charge(0); };
void()	hknight_smash11	= [	$smash11,	hknight_run1	] { ai_charge(0); };

void()	hknight_watk1	= [	$w_attack1,	hknight_watk2	] { ai_charge(2); };
void()	hknight_watk2	= [	$w_attack2,	hknight_watk3	] { ai_charge(0); };
void()	hknight_watk3	= [	$w_attack3,	hknight_watk4	] { ai_charge(0); };
void()	hknight_watk4	= [	$w_attack4,	hknight_watk5	] { SwordSwipeSound(); ai_melee(); };
void()	hknight_watk5	= [	$w_attack5,	hknight_watk6	] { ai_melee(); };
void()	hknight_watk6	= [	$w_attack6,	hknight_watk7	] { ai_melee(); };
void()	hknight_watk7	= [	$w_attack7,	hknight_watk8	] { ai_charge(1); };
void()	hknight_watk8	= [	$w_attack8,	hknight_watk9	] { ai_charge(4); };
void()	hknight_watk9	= [	$w_attack9,	hknight_watk10	] {
	if ((self.classname == "monster_bane") || (self.classname == "monster_dark_lord")) bane_melee(0); 
	ai_charge(5);
};
void()	hknight_watk10	= [	$w_attack10,	hknight_watk11	] { ai_charge(3); ai_melee(); };
void()	hknight_watk11	= [	$w_attack11,	hknight_watk12	] { monster_footstep(FALSE); ai_charge(2); ai_melee(); };
void()	hknight_watk12	= [	$w_attack12,	hknight_watk13	] { ai_charge(2); ai_melee(); };
void()	hknight_watk13	= [	$w_attack13,	hknight_watk14	] { ai_charge(0); };
void()	hknight_watk14	= [	$w_attack14,	hknight_watk15	] { SwordSwipeSound(); ai_charge(0); };
void()	hknight_watk15	= [	$w_attack15,	hknight_watk16	] { ai_charge(0); };
void()	hknight_watk16	= [	$w_attack16,	hknight_watk17	] { ai_charge(1);
	if ((self.classname == "monster_bane") || (self.classname == "monster_dark_lord")) sound(self,CHAN_WEAPON,"knight/sword2.wav",1,ATTN_NORM);
};
void()	hknight_watk17	= [	$w_attack17,	hknight_watk18	] { ai_charge(1); ai_melee(); };
void()	hknight_watk18	= [	$w_attack18,	hknight_watk19	] { ai_charge(3); ai_melee(); };
void()	hknight_watk19	= [	$w_attack19,	hknight_watk20	] { ai_charge(4); ai_melee(); };
void()	hknight_watk20	= [	$w_attack20,	hknight_watk21	] { ai_charge(6); };
void()	hknight_watk21	= [	$w_attack21,	hknight_watk22	] { ai_charge(7); };
void()	hknight_watk22	= [	$w_attack22,	hknight_run1	] { monster_footstep(FALSE); ai_charge(3); };

// Cycle between 3 melee attacks
// Attack 1 - Slice (one hand slashing run attack)
// Attack 2 - Smash (chop overhead to ground)
// Attack 3 - W_Attack (two handed slashing attack)
void() hknight_melee = { // [FUNCTION]
	self.meleeattack = self.meleeattack + 1;

	if (self.meleeattack == 1) hknight_slice1();
	else if (self.meleeattack == 2) hknight_smash1();
	else {
		hknight_watk1();
		self.meleeattack = 0;
	}
};

void(float offset) hknight_shot = {
	local	vector	offang;
	local	vector	org, dir;
	
	if (!self.enemy) return;
	if (self.health < 1) return;

	sound(self,CHAN_WEAPON,"hknight/attack1.wav",1,ATTN_NORM);
	self.attack_speed = SPEED_HKSPIKE + ( skill * SPEED_HKSKILL);
	offang = vectoangles (self.enemy.origin - self.origin);
	offang_y = offang_y + offset * 6;
	makevectors(offang);
	org = self.origin + self.mins + self.size*0.5 + v_forward * 20;
	dir = normalize (v_forward);
	dir_z = 0 - dir_z + (random() - 0.5)*0.1;
    if (self.classname == "monster_bane") {
        KnightBall_Launch(org, dir);
        newmis.dmg = 60;
        newmis.velocity = dir*600;
        if ((self.frame == $magicb6 ) || (self.frame == $magicc6 )) sound(self,CHAN_WEAPON,"drake/weapons/mirv1.wav",1,ATTN_NORM);
    } else if (self.classname == "monster_dark_lord") {
        NecroBolt_Launch(org,dir);
    } else {
		if (self.classtype == self.classtype == CT_MONSABERENFORCER) launch_projectile(org,dir,NO_SPIN,CT_PROJ_HKN_BLUE,self.attack_speed);
		else launch_projectile(org,dir,NO_SPIN,CT_PROJ_HKN,self.attack_speed);
	}
};

void() lord_magica7;

// Magic attack A (over head attack) - not used
void()	hknight_magica1 = [	$magica1,	hknight_magica2	] { ai_face(); if (self.classname == "monster_hell_lord" || self.classname == "monster_hkboss" || self.classname == "monster_bane") { bane_strafe(); } };
void()	hknight_magica2 = [	$magica2,	hknight_magica3	] { ai_face(); if (self.classname == "monster_hell_lord" || self.classname == "monster_hkboss" || self.classname == "monster_bane") { bane_strafe(); } };
void()	hknight_magica3 = [	$magica3,	hknight_magica4	] { ai_face(); if (self.classname == "monster_hell_lord" || self.classname == "monster_hkboss" || self.classname == "monster_bane") { bane_strafe(); } };
void()	hknight_magica4 = [	$magica4,	hknight_magica5	] { ai_face(); if (self.classname == "monster_hell_lord" || self.classname == "monster_hkboss" || self.classname == "monster_bane") { bane_strafe(); } };
void()	hknight_magica5 = [	$magica5,	hknight_magica6	] { ai_face(); if (self.classname == "monster_hell_lord" || self.classname == "monster_hkboss" || self.classname == "monster_bane") { bane_strafe(); } };
void()	hknight_magica6 = [	$magica6,	hknight_magica7	] {
	if (self.classname == "monster_hell_lord") self.think = lord_magica7;
	if (!(self.classname == "monster_hell_lord" || self.classname == "monster_hkboss" || self.classname == "monster_bane")) ai_face();
};
void()	hknight_magica7 = [	$magica7,	hknight_magica8	] {
	 if (self.classname == "monster_hell_lord" || self.classname == "monster_hkboss" || self.classname == "monster_bane") {
		ai_face();
		bane_strafe();
	} else {
		hknight_shot(-2);
	}
};
void()	hknight_magica8 = [	$magica8,	hknight_magica9	] {
	 if (self.classname == "monster_hell_lord" || self.classname == "monster_hkboss" || self.classname == "monster_bane") {
		ai_face();
		bane_strafe();
	} else {
		hknight_shot(-1);
	}
};
void()	hknight_magica9 = [	$magica9,	hknight_magica10] {
	 if (self.classname == "monster_hell_lord" || self.classname == "monster_hkboss" || self.classname == "monster_bane") {
		magica_sword_chop();
		M_Lightwall();
	} else {
		hknight_shot(0);
	}
};
void()	hknight_magica10 = [	$magica10,	hknight_magica11] {
	 if (self.classname == "monster_hell_lord" || self.classname == "monster_hkboss" || self.classname == "monster_bane") {
		ai_face();
		bane_strafe();
	} else {
		hknight_shot(1);
	}
};
void()	hknight_magica11 = [	$magica11,	hknight_magica12] {
	 if (self.classname == "monster_hell_lord" || self.classname == "monster_hkboss" || self.classname == "monster_bane") {
		ai_face();
		bane_strafe();
	} else {
		hknight_shot(2);
	}
};
void()	hknight_magica12 = [	$magica12,	hknight_magica13] {
	 if (self.classname == "monster_hell_lord" || self.classname == "monster_hkboss" || self.classname == "monster_bane") {
		ai_face();
		bane_strafe();
	} else {
		hknight_shot(3);
	}
};
void()	hknight_magica13 = [	$magica13,	hknight_magica14] {
	if (self.classname == "monster_hell_lord" || self.classname == "monster_hkboss" || self.classname == "monster_bane") bane_strafe();
	ai_face();
};
void()	hknight_magica14 = [	$magica14,	hknight_run1	] {
	if (self.classname == "monster_hell_lord" || self.classname == "monster_hkboss" || self.classname == "monster_bane") bane_strafe();
	ai_face();
};

void() darklord_magicb6;

// Magic attack B (pointing sword) - not used
void()	hknight_magicb1 = [	$magicb1,	hknight_magicb2	] { ai_face(); };
void()	hknight_magicb2 = [	$magicb2,	hknight_magicb3	] { ai_face(); };
void()	hknight_magicb3 = [	$magicb3,	hknight_magicb4	] { ai_face(); };
void()	hknight_magicb4 = [	$magicb4,	hknight_magicb5	] { ai_face(); };
void()	hknight_magicb5 = [	$magicb5,	hknight_magicb6	] {
	if (self.classname == "monster_dark_lord")
		{ self.think = darklord_magicb6; return; }
	ai_face();
};

void() ShalMissile;

void()	hknight_magicb6 = [	$magicb6,	hknight_magicb7	] { ai_face(); };
void()	hknight_magicb7 = [	$magicb7,	hknight_magicb8	] { hknight_shot(-2); };
void()	hknight_magicb8 = [	$magicb8,	hknight_magicb9	] { hknight_shot(-1); };
void()	hknight_magicb9 = [	$magicb9,	hknight_magicb10] {
	if (self.classname == "monster_hkboss") ShalMissile();
	hknight_shot(0);
};
void()	hknight_magicb10 = [	$magicb10,	hknight_magicb11] { hknight_shot(1); };
void()	hknight_magicb11 = [	$magicb11,	hknight_magicb12] { hknight_shot(2); };
void()	hknight_magicb12 = [	$magicb12,	hknight_magicb13] { hknight_shot(3); };
void()	hknight_magicb13 = [	$magicb13,	hknight_run1] {
	ai_face();
	if (self.classname == "monster_dark_lord")
		SUB_CheckRefire (hknight_magicb1);
};

void() bane_strafe;

// Magic attack C (swing sword in arc)
void()	hknight_magicc1 = [	$magicc1,	hknight_magicc2	] { ai_face(); };
void()	hknight_magicc2 = [	$magicc2,	hknight_magicc3	] { ai_face(); };
void()	hknight_magicc3 = [	$magicc3,	hknight_magicc4	] { ai_face(); };
void()	hknight_magicc4 = [	$magicc4,	hknight_magicc5	] { ai_face(); };
void()	hknight_magicc5 = [	$magicc5,	hknight_magicc6	] { ai_face(); };
void()	hknight_magicc6 = [	$magicc6,	hknight_magicc7	] { hknight_shot(-2); if (self.classname == "monster_bane") { bane_strafe(); }};
void()	hknight_magicc7 = [	$magicc7,	hknight_magicc8	] { hknight_shot(-1);if (self.classname == "monster_bane") { bane_strafe(); }};
void()	hknight_magicc8 = [	$magicc8,	hknight_magicc9	] { hknight_shot(0);if (self.classname == "monster_bane") { bane_strafe(); }};
void()	hknight_magicc9 = [	$magicc9,	hknight_magicc10] { hknight_shot(1);if (self.classname == "monster_bane") { bane_strafe(); }};
void()	hknight_magicc10 = [	$magicc10,	hknight_magicc11] { hknight_shot(2);if (self.classname == "monster_bane") { bane_strafe(); }};
void()	hknight_magicc11 = [	$magicc11,	hknight_run1] { hknight_shot(3);if (self.classname == "monster_bane") { bane_strafe(); }};

void() hknight_pointfire = { // [FUNCTION]
	local vector hkp_start, hkp_rand, hkp_end;
	
	// Make sure the knight is alive
	if (self.health < 1) return;

	// Time for a new LG hit sound?
	if (self.t_width < time) {
		// Lower volume and attenuation just in case of several together
		sound(self,CHAN_WEAPON,"weapons/lhit.wav", 0.75,ATTN_IDLE);
		self.t_width = time + 0.6;
	}

	// Update animation frames (default = MagicB6-11)
	self.frame = self.frame + self.pos3_z;
	if (self.frame < self.pos3_x) self.frame = self.pos3_y;
	if (self.frame > self.pos3_y) self.frame = self.pos3_x;
	self.ideal_yaw = vectoyaw(self.movetarget.origin - self.origin); 
	ChangeYaw(); // Turn the Knight towards lightning target
	makevectors(self.angles); // Work out start point of lightning bolt
	
	// Work out starting point for lightning on sword
	hkp_start = v_forward*self.pos1_x + v_right*self.pos1_y + v_up*self.pos1_z;
	hkp_rand = v_forward * (self.pos2_x * random());
	hkp_rand = hkp_rand + v_right * (self.pos2_y * random());
	hkp_rand = hkp_rand + v_up * (self.pos2_z * random());
	hkp_start = hkp_start + self.origin + hkp_rand;
	
	// Check for any random target origin variance
	if (self.t_length > 0) {
		hkp_end = vecrand(0,self.t_length,1);
		hkp_end = hkp_end + self.movetarget.origin;
	} else hkp_end = self.movetarget.origin; // Default (0) = exact target position

	// Update sword with lightning visuals
	if (self.attachment) {
		setorigin(self.attachment, self.origin);
		self.attachment.frame = self.frame;
		self.attachment.angles = self.angles;
		// Allow for no sword effect by going over max and reset
		self.attachment.alpha = self.attachment.alpha + random();
		if (self.attachment.alpha > 1) self.attachment.alpha = 0.01;
		// The four skins are randomly setup already
		self.lip = self.attachment.skin + 1;
		if (self.lip > 3) self.lip = 0;
		self.attachment.skin = self.lip;
		// Draw paticles on sword where lightning starts
		particle_explode(hkp_start, 2, 1, PARTICLE_BURST_BLUE, PARTICLE_BURST_LOSTUP);
	}
	
	Tent_Beam(TE_LIGHTNING2,self,hkp_start,hkp_end); // Create lightning bolt
	LightningDamage(hkp_start, hkp_end, self, self.dmg);
	
	// Keep Looping
	self.think = self.th_run;
	self.nextthink = time + 0.1;
	
};

void() hknight_pointsetup = { // [FUNCTION]
	local entity newpoint;

	if (self.target == "") {
		newpoint = spawn();
		setorigin(newpoint,self.origin + '0 0 64');
		self.movetarget = newpoint;
		// Save pain threshold and timeout for later
		self.finaldest_x = self.pain_flinch;
		self.finaldest_y = self.pain_timeout;
		// Reset all pain parameters so it always happens
		self.pain_flinch = self.pain_timeout = 0;
		self.pain_finished = self.pain_ignore = 0;
		self.infightextra = self.noinfighting = 0;
		// Stop other monsters attacking pointy knights
		self.flags = self.flags - (self.flags & FL_MONSTER);
		self.enemy = world;
		SUB_CreateSelfAttachment(self.weaponglow,1.0); // Create glowing sword and start pointing
		setmodel(self.attachment, self.attachment.mdl);
		setsize (self.attachment, VEC_ORIGIN, VEC_ORIGIN);
		self.attachment.movetype = MOVETYPE_NONE;
		self.attachment.solid = SOLID_NOT;
		self.th_run();
	} else {
		// Find Lightning bolt target
		self.movetarget = find(world, targetname, self.target);
		if (!self.movetarget) {
			dprint("\b[HKNIGHT]\b Pointing knight invalid target!\n");
			spawn_marker(self.origin,'0 0 0',0,SPNMARK_YELLOW);
			remove(self);
			return;
		}
		// Start pointing lightning sword!
		else {
			// Save pain threshold and timeout for later
			self.finaldest_x = self.pain_flinch;
			self.finaldest_y = self.pain_timeout;
			// Reset all pain parameters so it always happens
			self.pain_flinch = self.pain_timeout = 0;
			self.pain_finished = self.pain_ignore = 0;
			self.infightextra = self.noinfighting = 0;
			// Stop other monsters attacking pointy knights
			self.flags = self.flags - (self.flags & FL_MONSTER);
			self.enemy = world;
			SUB_CreateSelfAttachment(self.weaponglow,1.0); // Create glowing sword and start pointing
			setmodel(self.attachment, self.attachment.mdl);
			setsize (self.attachment, VEC_ORIGIN, VEC_ORIGIN);
			self.attachment.movetype = MOVETYPE_NONE;
			self.attachment.solid = SOLID_NOT;
			self.th_run();
		}
	}
};

void()	hknight_pain1	= [	$pain1,		hknight_pain2	] {}; // [FUNCTION]
void()	hknight_pain2	= [	$pain2,		hknight_pain3	] {}; // [FUNCTION]
void()	hknight_pain3	= [	$pain3,		hknight_pain4	] {}; // [FUNCTION]
void()	hknight_pain4	= [	$pain4,		hknight_pain5	] {}; // [FUNCTION]
void()	hknight_pain5	= [	$pain5,		hknight_run1	] {}; // [FUNCTION]

void() hkfast_pain1;

void(entity inflictor, entity attacker, float damage) hknight_pain = { // [FUNCTION]
	// Check all pain conditions and set up what to do next
	monster_pain_check(attacker, damage);

	// Any pain animation/sound required?
	if (self.pain_check > 0) {
		if (self.pain_sound2) {
			if (random() < 0.5) sound(self,CHAN_VOICE, self.pain_sound,1,ATTN_NORM);
			else sound(self,CHAN_VOICE, self.pain_sound2,1,ATTN_NORM);
		} else sound(self,CHAN_VOICE, self.pain_sound,1,ATTN_NORM);

		if (self.pain_check == 1) hknight_pain1();
		else if (self.pain_check == 2) {
			// reset axe hit and setup short pain recovery
			self.pain_finished = time + 0.5;
			self.axhitme = 0;

			// Update:  Quicker pain for lords.
			if ((self.classname == "monster_hell_lord") || (self.classname == "monster_dark_lord")) {
				if (random() < 0.5) {
					hkfast_pain1();
					return;
				}
			}
			hknight_pain1();
		}
	}
};


void()	hknight_die1	= [	$death1,	hknight_die2	] {
	ai_forward(10);
	self.reviveframestart = $death12;
	self.reviveframeend = $death1;
};
void()	hknight_die2	= [	$death2,	hknight_die3	] { monster_check_gib(); ai_forward(8); };
void()	hknight_die3	= [	$death3,	hknight_die4	] { monster_check_gib();
	self.solid = SOLID_NOT; ai_forward(7); };
void()	hknight_die4	= [	$death4,	hknight_die5	] {};
void()	hknight_die5	= [	$death5,	hknight_die6	] {};
void()	hknight_die6	= [	$death6,	hknight_die7	] {};
void()	hknight_die7	= [	$death7,	hknight_die8	] {};
void()	hknight_die8	= [	$death8,	hknight_die9	] { ai_forward(10); };
void()	hknight_die9	= [	$death9,	hknight_die10	] { ai_forward(11); };
void()	hknight_die10	= [	$death10,	hknight_die11	] {};
void()	hknight_die11	= [	$death11,	hknight_die12	] { monster_death_postcheck(); };
void()	hknight_die12	= [	$death12,	hknight_die12	] { monster_deadbody_check(); };

void()	hknight_dieb1	= [	$deathb1,	hknight_dieb2	] {
	self.reviveframestart = $deathb9;
	self.reviveframeend = $deathb1;
};
void()	hknight_dieb2	= [	$deathb2,	hknight_dieb3	] { monster_check_gib(); };
void()	hknight_dieb3	= [	$deathb3,	hknight_dieb4	] { monster_check_gib(); self.solid = SOLID_NOT; };
void()	hknight_dieb4	= [	$deathb4,	hknight_dieb5	] {};
void()	hknight_dieb5	= [	$deathb5,	hknight_dieb6	] {};
void()	hknight_dieb6	= [	$deathb6,	hknight_dieb7	] {};
void()	hknight_dieb7	= [	$deathb7,	hknight_dieb8	] {};
void()	hknight_dieb8	= [	$deathb8,	hknight_dieb9	] { monster_death_postcheck(); };
void()	hknight_dieb9	= [	$deathb9,	hknight_dieb9	] { monster_deadbody_check(); };

void() hknight_die = { // [FUNCTION]
	monster_death_precheck(); // Pre-check routine to tidy up extra entities
	SUB_RemoveAttachment(); // Make sure attachments are removed

    if (self.classname == "monster_hell_lord") self.death_sound = "drake/archer/death2.wav";
    else if (self.classname == "monster_bane") {
        if (self.skin == SKIN_BANE_GRAY) self.skin = SKIN_BANE;
		self.modelindex = self.mindex2;
        self.death_sound = "drake/bane/death.wav";
    }	

	if (self.classtype == CT_MONSABERENFORCER) self.death_sound = "enforcer/death1.wav";

	// regular death
	if (!self.gibbed) {
		sound(self,CHAN_VOICE, self.death_sound,1,ATTN_NORM);
		if (random() > 0.5) hknight_die1();	// Forward - standard
		else hknight_dieb1();					// Backward - standard
	}
};

// Used by stone knights to wakup and attack the player
void() hknight_aistates = { // [FUNCTION]
	self.th_stand = hknight_stand1;		// Idling on feet
	self.th_walk = hknight_walk1;		// Walking
	self.th_run = hknight_run1;			// Running
	self.th_melee = hknight_melee;		// Sword attack
	if (self.classname == "monster_hell_knight_champion") self.th_missile = hknight_champion_magic;
	else {
		if (self.classname == "monster_hkboss") self.th_missile = hkboss_magic; // Either knight spikes or vore balls
		else {
			if (self.classname == "monster_hell_lord") self.th_missile = lord_magic;
			else self.th_missile = hknight_magicc1;	// Fire spikes
		}
	}
	self.th_charge = hknight_char_a1;	// Run + melee
	self.th_pain = hknight_pain;		// Stumble and pain
	self.th_die = hknight_die;			// Face meets floor
};

void() hknight_wakeup = { // [FUNCTION]
	if (self.health < 0) return;		// Check for sudden death!
	
	self.use = SUB_Null;				// no re-trigger
	self.takedamage = DAMAGE_AIM;		// Can receive damage
	self.spawnstatue = FALSE;			// No longer stationary
	hknight_aistates();					// Restore AI state functions
	monster_targets();					// Check for targets
};

// Restore pointy lightning knights to normal hell knights
void() hknight_pointwakeup = { // [FUNCTION]
	if (self.health < 0) return; // Check for sudden death!

	self.health = self.max_health = self.reset_health; // Always reset health+max back to default
	if (self.target2 != "") { // Fire any trigger event when breaking pointy pose
		trigger_strs(self.target2, self.enemy);
		self.target2 = "";		// Trigger once
	}

	self.pain_flinch = self.finaldest_x; // Restore pain threshold and timeout
	self.pain_timeout = self.finaldest_y;
	self.pain_finished = time + 2;
	self.flags = self.flags | FL_MONSTER; // Recognized by the things that need to recognize it as a monster now, previously was just a statue.
	if (self.spawnflags & MON_STATUE) { // Restore the nail resistance if setup to be a statue skin
		self.resist_nails = 0.2;
		self.reflectnails = TRUE; // Reflect nail projectiles
	}
	
	SUB_RemoveAttachment();		// Remove glowing sword
	hknight_aistates();					// Restore AI state functions

	// Check for any enemy target?
	if (self.enemy) {
		monster_sightsound();			// Sword sounds!
		FoundHuntTarget(TRUE);			// Setup goals and targets
		self.think = self.th_run;		// Move to running
	}
	else self.think = self.th_stand;	// Stand around
	self.nextthink = time + 0.1;
};

// Special pain function for pointy lightning knights
void(entity inflictor, entity attacker, float damage) hknight_pointpain = { // [FUNCTION]
	self.pain_finished = 0;
	if (!(attacker.flags & FL_CLIENT)) return;
	self.enemy = attacker;
	hknight_pointwakeup();
};

// Special use/trigger function for pointy lightning knights
void() hknight_pointuse = { // [FUNCTION]
	// Check for enemy/health/player exceptions
	if (self.enemy) return;
	if (self.health < 1) return;
	if (Invisible(activator)) return;
	
	self.use = SUB_Null; // Trigger once
	if (activator.flags & FL_CLIENT) self.enemy = activator; // Is the trigger the player?
	else self.enemy = world;
	hknight_pointwakeup();
};

void() monster_hell_knight_precache = { // [FUNCTION]
	precache_model("progs/qmaster/mon_hknight.mdl");
	precache_model("progs/h_hellkn.mdl");
	precache_model(MODEL_PROJ_HKN);
	precache_model("progs/ad171/w_hknightsword.mdl");
	precache_model("progs/ad171/gib_knfoot_l.mdl");
	precache_model("progs/ad171/gib_knfoot_r.mdl");
	precache_stonegibs(); // Always precache these stone gib models
	precache_model ("progs/ad171/mon_hknight_glow.mdl");
	precache_model("progs/newhouse/vk_spike.mdl");
	precache_sound("hknight/hit.wav");		
	precache_sound("hknight/attack1.wav"); // Firing of magic spikes (first 0.1s must loop)
	precache_sound("knight/sword2.wav");
	precache_sound("knight/sword2.wav");
	precache_sound("ad171/statue/idle1.wav");
	precache_sound("ad171/statue/idle2.wav");
	precache_sound("rogue/statue/idle.wav");
	precache_sound("rogue/statue/pain.wav");
	precache_sound("rogue/statue/death.wav");
	precache_sound("ad171/statue/sight.wav");
	precache_sound("rogue/statue/see.wav");
	precache_sound("hknight/idle.wav");
	precache_sound("hknight/pain1.wav");
	precache_sound("hknight/death1.wav");
	precache_sound("hknight/sight1.wav");
	precache_sound("hknight/attack1.wav");
	precache_sound("hknight/hit.wav");		// used by C code, so don't sound2
	precache_sound("hknight/slash1.wav");
	precache_sound("hknight/idle.wav");
	precache_sound("hknight/grunt.wav");
	precache_sound("knight/sword1.wav");
	precache_sound("knight/sword2.wav");
};

void() monster_hell_knight_enforcer_precache = { // [FUNCTION]
	monster_hell_knight_precache();
	precache_model ("progs/lieutenant/hknight.mdl");
	precache_model ("progs/h_mega.mdl");
	precache_sound("enforcer/death1.wav");
	precache_sound("enforcer/idle1.wav");
	precache_sound("enforcer/pain1.wav");
	precache_sound("enforcer/pain2.wav");
	precache_sound("enforcer/sight1.wav");
	precache_sound("enforcer/sight2.wav");
	precache_sound("enforcer/sight3.wav");
	precache_sound("enforcer/sight4.wav");
};

// QUAKED monster_hell_knight (1 0 0) (-16 -16 -24) (16 16 40) Ambush
void() monster_hell_knight = { // [ENTITY]
	if (monster_checkrandomizer() == TRUE) return; // Check for any random monster setups
	if (monster_checkspawn() == TRUE) return; // Check all spawn exceptions (monsters.qc)

	if (!self.mdl) self.mdl = "progs/qmaster/mon_hknight.mdl";			// Original ID Knight + extra skins
	if (!self.headmdl) self.headmdl = "progs/h_hellkn.mdl";
	if (!self.gib1mdl) self.gib1mdl = "progs/ad171/w_hknightsword.mdl";	// Unique sword
	if (!self.gib2mdl) self.gib2mdl = "progs/ad171/gib_knfoot_l.mdl";	// left foot
	if (!self.gib3mdl) self.gib3mdl = "progs/ad171/gib_knfoot_r.mdl";	// right foot
	if (self.classtype != CT_MONSABERENFORCER) self.gib1sound = GIB_IMPACT_METALA;
	if (random() < 0.5) self.gib2mdl = "";
	if (random() < 0.5) self.gib3mdl = "";
	if (self.classtype != CT_MONSABERENFORCER) {
		self.hello_sound = "hknight/idle.wav"; 
		self.hittype = HIT_METAL;
	} else {
		self.hello_sound = "enforcer/idle1.wav";
		if (!self.sight_sound) self.sight_sound = "enforcer/sight1.wav";
		if (!self.sight_sound2) self.sight_sound2 = "enforcer/sight2.wav";
		if (!self.sight_sound3) self.sight_sound3 = "enforcer/sight3.wav";
		if (!self.sight_sound4) self.sight_sound4 = "enforcer/sight4.wav";
	}
	Resist_ChangeType(self,-1); // Always reset Ammo Resistance to be consistent	
	if (self.spawnflags & MON_STATUE) {
		self.hittype = HIT_STONE;
		if (!self.idle_sound) self.idle_sound = "ad171/statue/idle1.wav";
		if (!self.idle_sound2) self.idle_sound2 = "ad171/statue/idle2.wav";
		if (!self.idle_soundcom) self.idle_soundcom = "rogue/statue/idle.wav";
		self.hello_sound = "ad171/statue/idle1.wav"; 
		self.pain_sound = "rogue/statue/pain.wav";
		self.death_sound = "rogue/statue/death.wav";
		if (random() < 0.5)
			self.sight_sound = "ad171/statue/sight.wav";
		else
			self.sight_sound = "rogue/statue/see.wav";
		self.gib1skin = 1;			  // Stoney sword
		self.gibtype = GIBTYPE_STONE; // Stoney gibs!
		self.gib2mdl = self.gib3mdl = "";
		self.resist_nails = 0.2;
		self.resist_lava_nails = 0.1;
		self.reflectnails = TRUE;	  // Reflect nail projectiles
	} else {
		if (!self.idle_sound) self.idle_sound = "hknight/idle.wav";
		if (!self.pain_sound) self.pain_sound = "hknight/pain1.wav";
		if (!self.death_sound) self.death_sound = "hknight/death1.wav";
		if (!self.sight_sound) self.sight_sound = "hknight/sight1.wav";
	}

	self.solid = SOLID_NOT;				// No interaction with world
	self.movetype = MOVETYPE_NONE;		// Static item, no movement
	if (self.bboxtype < 1) self.bboxtype = BBOX_TALL;
	self.gibhealth = -40;
	self.gibbed = FALSE;
	if (self.classname == "monster_hell_knight_champion") {
		if (self.health < 1) self.health = 350;
		if (self.skin == 0) self.exactskin = self.skin = 3; // Red trimmings and eyes, looking menacing
		if (self.deathstring == "") self.deathstring = " was fell before a Champion\n";
	} else {
		if (self.classname == "monster_hkboss") {
			if (self.health < 1) self.health = 900;
			self.gibhealth = MON_NEVERGIB;
			if (!self.skin) self.exactskin = self.skin = 13; // Green trimmings, looking snazzy
			if (self.deathstring == "") self.deathstring = " was slaughtered by a Warlord\n";
		} else {
			if (self.classname == "monster_hell_lord") {
				if (self.health < 1) self.health = 400;
				self.gibhealth = MON_NEVERGIB;
				self.sight_sound = "drake/archer/sight2.wav";
				self.hello_sound = "hknight/idle.wav"; 
				if (!self.skin) self.skin = 15; // Turquoise allover, looking sleek
				if (self.deathstring == "") self.deathstring = " fell before a Hell Lord\n";
			} else {
				if (self.health < 1) self.health = 250;
			}
		}
	}
	self.pain_flinch = 40;					// Medium pain threshold
	self.pain_timeout = 1.5;				// Higher than a knight
	self.steptype = FS_TYPEHEAVY;			// Heavy player
	self.meleeattack = rint(random()*3);	// randomize last melee attack
	self.th_die = hknight_die;				// Face meets floor

	// Special lightning point knight (metal/stone skins)
	if (self.spawnflags & MON_POINT_KNIGHT) {
		self.weaponglow = "progs/ad171/mon_hknight_glow.mdl"; // Glowing magical swords	
		if (self.spawnflags & MON_STATUE) {
			self.classgroup = CG_STONE;		// Stone hates metal!
			self.skin = 1;					// Stone skin
			self.pain_flinch = 60;			// Doubled
			self.pain_longanim = FALSE;		// resistant to shadow axe
			self.pain_timeout = 2;			// high pain threshold
			self.no_liquiddmg = TRUE;		// Immune to slime/lava
			self.resist_nails = 0.2;
			self.resist_lava_nails = 0.1;
			self.reflectnails = TRUE;		// Reflect nail projectiles
		}
		self.th_stand = hknight_pointsetup;	// Find target before shoot
		self.th_run = hknight_pointfire;	// Keep Looping
		self.th_pain = hknight_pointpain;	// Release from pointing
		self.think1 = hknight_pointuse;		// Special trigger event
		self.reset_health = self.health;	// Save for later
		self.health = MEGADEATH;			// Should be impossible to kill
		if (self.t_length < 0) self.t_length = 5;	// Random target factor
		if (self.dmg < 0) self.dmg = 5;				// Contact damage
		if (VectorIsAllZeros(self.pos1)) self.pos1 = '20 0 24'; // Setup default pose start pos + random modifier
		if (VectorIsAllZeros(self.pos2)) self.pos2 = '30 0 2';
		if (VectorIsAllZeros(self.pos3)) self.pos3 = '98 103 1'; // Setup default animation pose (magicB6 - magicB11)
	} else if (self.spawnflags & MON_STATUE) {
		// Detect statues and setup different parameters.  Tougher skin, less pain, heavy feet etc
		self.resist_nails = 0.2;
		self.resist_lava_nails = 0.1;
		self.reflectnails = TRUE;		// Reflect nail projectiles
		if (self.classname == "monster_hell_knight_champion") {
			self.classgroup = CG_DKNIGHT;	// Classic tincan!
			hknight_aistates();
			self.classtype = CT_MONHELLK;
			self.classmove = MON_MOVEWALK;
			monster_start();
			return;  // champion knights can't be statues!
		}
		self.classgroup = CG_STONE;		// Stone hates metal!
		self.hittype = HIT_STONE;
		self.skin = 1;					// Stone skin
		self.pain_flinch = 60;			// Doubled
		self.pain_longanim = FALSE;		// resistant to shadow axe
		self.pain_timeout = 2;			// high pain threshold
		self.no_liquiddmg = TRUE;		// Immune to slime/lava
		if (self.deathstring == "") self.deathstring = " was smashed by a Stone Death Knight\n";

		// Allow knights to start with a stone skin, but not be frozen!
		if (self.spawnflags & MON_NOTFROZEN) {
			self.spawnflags = self.spawnflags - MON_STATUE;
			hknight_aistates();			// setup AI state functions
		} else {
			self.spawnstatue = TRUE;		// Start as a statue
			self.th_stand = knight_statue;	// Stone idle sound
			self.think1 = hknight_wakeup;	// Wakeup function when triggered
			
			// Statues can change position when the player is not looking.  Specify a start/finish frame using pos1 or use frame.
			if (!self.pos1_x) {
				self.pos1_x = $w_attack1;		// Default pose (attacking)
				self.pos1_y = $w_attack15;
			}
			
			if (self.frame > 0) self.pos1_x = self.pos1_y = self.frame; // A frame has been specified, create a small range from that

			// Work out range, make sure no negative values
			self.pos1_z = fabs(self.pos1_y - self.pos1_x);
			self.frame = self.pos1_x;		// Setup frame / pose
		}
	} else {
		self.pain_longanim = TRUE;		// can be chopped with shadow axe
		if (self.classgroup <= 0) self.classgroup = CG_DKNIGHT;	// Classic tincan!
		hknight_aistates();				// setup AI state functions
	}
	if (self.deathstring == "") self.deathstring = " was slain by a Death Knight\n";
	self.classtype = CT_MONHELLK;
	self.classmove = MON_MOVEWALK;
	monster_start();
};

// QUAKED monster_hell_pointknight (0.75 0.5 0) (-16 -16 -24) (16 16 40) AMBUSH STATUE x NOSIGHT NOIDLE NOGFX STARTOFF x Not_Easy Not_Normal Not_Hard Not_DM
// { model(":progs/qmaster/mon_hknight.mdl"); }
// Special Electricity Pointing Hell Knight
// -------- KEYS --------
// targetname : monster/trigger name
// target : target for electricity
// target2 : trigger to fire when electricity stopped
// pos1 : XYZ offset to start lightning (uses v_forward/v_right/v_up)
// pos2 : XYZ random offset to start lightning (uses v_forward/v_right/v_up)
// pos3 : Animation lightning frame set (Start/Finish/Direction)
// t_length : random wobble to electricity target origin (0=def 5)
// dmg : amount of contact damage with electricity (0=def 5)
// health : Override default health settings
// deathtarget : entity to trigger upon death (useful if target field already in use)
// health : Override default health settings
// upgrade_ssg : 1 = will only spawn if shotgun upgrade active on server
// upgrade_axe : 1 = will only spawn if axe upgrade active on server
// upgrade_lg : 1 = will only spawn if lightning gun upgrade active on server
// nomonstercount : will not be included in any monster count functionality
// no_zaware : All Z Aware projectiles will be disabled
// bboxtype : Change bbox 1=Tiny,4=Short,5=Tall,7=Wide,8=Giant,10=Massive
// gibondeath : 1 = always explode in a shower of gibs on death
// bodyfadeaway : Time (secs) before body/head will fade away (default=0)
// -------- SPAWNFLAGS --------
// AMBUSH : the monster will only wake up on seeing the player, not by another monster
// STATUE : Stone statue skin
// NOSIGHT : No sight sound
// NOIDLE : No idle sound
// NOGFX : No spawn effect or sound when triggered
// STARTOFF : Trigger Spawn
// -------- NOTES --------
// Special Electricity Pointing Hell Knight
void() monster_hell_pointknight = { // [ENTITY]
	local entity newpoint;

	self.spawnflags = self.spawnflags | MON_POINT_KNIGHT; // Setup with new special spawnflag (not mapper controlled)
	self.spawnflags = self.spawnflags - (self.spawnflags & MON_NOTFROZEN); // remove notfrozen and angry, always start/spawn firing lightning
	self.spawnflags = self.spawnflags - (self.spawnflags & MON_SPAWN_ANGRY);
	if (self.deathstring == "") self.deathstring = " was cleaved by an Electrical Death Knight\n";
	if (self.target == "") {
		// Create one!
		newpoint = spawn();
		setorigin(newpoint,self.origin + '0 0 64');
		self.movetarget = newpoint;
		dprint("\b[HKNIGHT]\b Pointing knight needs target! Made one anyway 64 units above its head.\n");
	}
	monster_hell_knight(); // Loop back through existing hell knight function
};

// Light Saber Enforcer from back2forwards by The Lieutenant
void() monster_hell_knight_enforcer = { // [ENTITY]
	self.spawnflags = self.spawnflags - (self.spawnflags & MON_STATUE); // Force non-statue for this guy, we have a light saber after all
	self.spawnflags = self.spawnflags - (self.spawnflags & MON_POINT_KNIGHT); // Force normality
	self.classtype = CT_MONSABERENFORCER;
	self.mdl = ("progs/lieutenant/hknight.mdl");
	self.headmdl = "progs/h_mega.mdl";
	self.death_sound = "enforcer/death1.wav";
	if (!self.idle_sound) self.idle_sound = "enforcer/idle1.wav";
	if (!self.sight_sound) self.sight_sound = "enforcer/sight1.wav";
	if (!self.sight_sound2) self.sight_sound2 = "enforcer/sight2.wav";
	if (!self.sight_sound3) self.sight_sound3 = "enforcer/sight3.wav";
	if (!self.sight_sound4) self.sight_sound4 = "enforcer/sight4.wav";
	self.idle_sound = "enforcer/idle1.wav";
	self.pain_sound = "enforcer/pain1.wav";
	self.pain_sound2 = "enforcer/pain2.wav";
	self.exactskin = 0;
	if (self.health <= 0) self.health = 105;
	if (self.deathstring == "") self.deathstring = " was cauterized by a Saber Enforcer\n";
	self.classgroup = CG_ENFORCER;
	monster_hell_knight();
};

// ben - 08/04/03 - a champion knight  always strides into battle - never runs.
void()	hknight_stride1	= [	$walk1,	hknight_stride2	] { monster_idle_sound(); ai_run(2); };
void()	hknight_stride2	= [	$walk2,	hknight_stride3	] { ai_run(5); };
void()	hknight_stride3	= [	$walk3,	hknight_stride4	] { ai_run(5); };
void()	hknight_stride4	= [	$walk4,	hknight_stride5	] { ai_run(4); };
void()	hknight_stride5	= [	$walk5,	hknight_stride6	] { ai_run(4); };
void()	hknight_stride6	= [	$walk6,	hknight_stride7	] { ai_run(2); };
void()	hknight_stride7	= [	$walk7,	hknight_stride8	] { ai_run(2); };
void()	hknight_stride8	= [	$walk8,	hknight_stride9	] { ai_run(3); };
void()	hknight_stride9	= [	$walk9,	hknight_stride10	] { ai_run(3); };
void()	hknight_stride10= [	$walk10,	hknight_stride11	] { ai_run(4); };
void()	hknight_stride11= [	$walk11,	hknight_stride12	] { ai_run(3); };
void()	hknight_stride12= [	$walk12,	hknight_stride13	] { ai_run(4); };
void()	hknight_stride13= [	$walk13,	hknight_stride14	] { ai_run(6); };
void()	hknight_stride14= [	$walk14,	hknight_stride15	] { ai_run(2); };
void()	hknight_stride15= [	$walk15,	hknight_stride16	] { ai_run(2); };
void()	hknight_stride16= [	$walk16,	hknight_stride17	] { ai_run(4); };
void()	hknight_stride17= [	$walk17,	hknight_stride18	] { ai_run(3); };
void()	hknight_stride18= [	$walk18,	hknight_stride19	] { ai_run(3); };
void()	hknight_stride19= [	$walk19,	hknight_stride20	] { ai_run(3); };
void()	hknight_stride20= [	$walk20,	hknight_stride1	] { ai_run(2); };

// A champion has a choice of two missile attacks - a faster version of the standard attack, and a vore-style homing missile. eventually he will be able to teleport.
void() hknight_champion_magic = { // [FUNCTION]
	if (random() < 0.6) hknight_magicc1();
	else hknight_magicb1();
};

void() monster_hell_knight_champion = { // [ENTITY]
	if (self.deathstring == "")  self.deathstring = " was conquered by a Champion Death Knight\n";
	monster_hell_knight();
}