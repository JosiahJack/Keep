void function hknight_stand1();
{
  #0 hknight_stand2;
  ai_stand();
  ai_emnity("monster_qguy", 1500, 0);
}

Void function hknight_stand4();
{
  #3 hknight_stand5;
  ai_stand();
  ai_emnity("monster_qguy", 1500, 0);
}

Void function hknight_stand6();
{
  #5 hknight_stand7;
  ai_stand();
  ai_emnity("monster_qguy", 1500, 0);
}


Void function hknight_rush1();
{
  self.effects = self.effects | EF_MUZZLEFLASH;
  self.pain_finished = time + 1;
  #166 hknight_rush2;
  ai_face();
  ai_melee();
}

Void function hknight_rush2();
{
  if (!ai_knightrush()) {
    self.th_run();
    exit;
    }
  #167 hknight_rush3;
  ai_face();
  ai_melee();
  sound(self, CHAN_DAMAUL, "nehahra/sets/dml1_4.wav", 1, ATTN_NORM);
}

Void function hknight_rush3();
{
  self.effects = self.effects | EF_MUZZLEFLASH;
  if (!ai_knightrush()) {
    self.th_run();
    exit;
    }
  #168 hknight_rush4;
  ai_face();
  ai_melee();
}

Void function hknight_rush4();
{
  if (!ai_knightrush()) {
    self.th_run();
    exit;
    }
  #169 hknight_rush1;
  ai_face();
  ai_melee();
  sound(self, CHAN_DAMAUL, "nehahra/sets/dml1_4.wav", 1, ATTN_NORM);
}

Void function ai_knightrush();
{
  if (!infront(self.enemy)) {
    self.lives = self.lives + 1;
    if (self.lives > 13) {
      self.lives = 0;
      self.yaw_speed = 20;
      strategy_move = strategy_move - 1;
      return 0;
      }
    }  
  if (walkmove(self.angles_y, 23) == FALSE) {
    melee_rushhit();
    strategy_move = strategy_move - 1;
    self.yaw_speed = 20;
    return 0;
    }
  if (walkmove(self.angles_y, 23) == FALSE) {
    melee_rushhit();
    self.yaw_speed = 20;
    strategy_move = strategy_move - 1;
    return 0;
    }
  else {
    return 1;
    }
}

Void function melee_rushhit();
var
 ldmg : Real;
 delta : Vector;
{
  ai_face();
  walkmove(self.ideal_yaw, 12);
  delta = self.enemy.origin - self.origin;
  if (vlen(delta) > 100) {
    return 0;
    exit;
    }
  if (!CanDamage(self.enemy, self)) {
    return 0;
    exit;
    }
  ldmg = MOVETYPE_BOUNCE + MOVETYPE_BOUNCEMISSILE * random();
  T_Damage(self.enemy, self, self, ldmg);
  makevectors(self.angles);
  SpawnMeatSpray(self.origin + v_forward * FL_INWATER, 100 * v_right);
  SpawnMeatSpray(self.origin + v_forward * FL_INWATER, -100 * v_right);
  makevectors(self.enemy.angles);
  self.enemy.flags = self.enemy.flags - (self.enemy.flags & FL_ONGROUND);
  self.enemy.origin_z = self.enemy.origin_z + 1;
  self.enemy.velocity = v_forward * -200 + [0 0 220]; 
  return 1;
}

Void function hknight_walk1();
{
  #9 hknight_walk2;
  hk_idle_sound();
  ai_walk(FL_SWIM);
}

Void function hknight_walk2();
{
  #10 hknight_walk3;
  ai_walk(MOVETYPE_FLY);
  ai_emnity("monster_qguy", 1500, 0);
}

Void function hknight_walk3();
{
  #11 hknight_walk4;
  ai_walk(MOVETYPE_FLY);
}

Void function hknight_walk4();
{
  #12 hknight_walk5;
  ai_walk(MOVETYPE_STEP);
  ai_emnity("monster_qguy", 1500, 0);
}

Void function hknight_walk5();
{
  #13 hknight_walk6;
  ai_walk(MOVETYPE_STEP);
}

Void function hknight_walk6();
{
  #14 hknight_walk7;
  ai_walk(FL_SWIM);
}

Void function hknight_walk7();
{
  #15 hknight_walk8;
  ai_walk(FL_SWIM);
  ai_emnity("monster_qguy", 1500, 0);
}

Void function hknight_walk8();
{
  #16 hknight_walk9;
  ai_walk(MOVETYPE_WALK);
}

Void function hknight_walk9();
{
  #17 hknight_walk10;
  ai_walk(MOVETYPE_WALK);
}

Void function hknight_walk10();
{
  #18 hknight_walk11;
  ai_walk(MOVETYPE_STEP);
  ai_emnity("monster_qguy", 1500, 0);
}

Void function hknight_walk11();
{
  #19 hknight_walk12;
  ai_walk(MOVETYPE_WALK);
}

Void function hknight_walk12();
{
  #20 hknight_walk13;
  ai_walk(MOVETYPE_STEP);
}

Void function hknight_walk13();
{
  #21 hknight_walk14;
  ai_walk(MOVETYPE_TOSS);
  ai_emnity("monster_qguy", 1500, 0);
}

Void function hknight_walk14();
{
  #22 hknight_walk15;
  ai_walk(FL_SWIM);
}

Void function hknight_walk15();
{
  #23 hknight_walk16;
  ai_walk(FL_SWIM);
}

Void function hknight_walk16();
{
  #24 hknight_walk17;
  ai_walk(MOVETYPE_STEP);
  ai_emnity("monster_qguy", 1500, 0);
}

Void function hknight_walk17();
{
  #25 hknight_walk18;
  ai_walk(MOVETYPE_WALK);
}

Void function hknight_walk18();
{
  #26 hknight_walk19;
  ai_walk(MOVETYPE_WALK);
  ai_emnity("monster_qguy", 1500, 0);
}

Void function hknight_walk19();
{
  #27 hknight_walk20;
  ai_walk(MOVETYPE_WALK);
}

Void function hknight_walk20();
{
  #28 hknight_walk1;
  ai_walk(FL_SWIM);
  ai_emnity("monster_qguy", 1500, 0);
}

Void function hknight_run1();
{
  if (borkfactor1()) {
    exit;
    }
  #29 hknight_run2;
  hk_idle_sound();
  ai_run(20);
}

void() hknight_run2 = [30, hknight_run3] { ai_run(25); };
void() hknight_run3 = [31, hknight_run4] { ai_run(18); if (self.jump_flag < time) ai_ledgejump(self.angles, 0); };
void() hknight_run4 = [32, hknight_run5] { ai_run(FL_INWATER); };
void function hknight_run5(); {
  if (CheckForCharge()) {
    exit;
    }
  #33 hknight_run6;
  ai_run(14);
}

void function hknight_run6();
{
  #34 hknight_run7;
  ai_run(25);
}
void() hknight_run7 = [35, hknight_run8] { ai_run(21); };
Void function hknight_run8();
{
  #36 hknight_run1;
  ai_run(13);
}

Void function hknight_pain1();
{
  #37 hknight_pain2;
  sound(self, CHAN_VOICE, "hknight/pain1.wav", 1, ATTN_NORM);
}

Void function hknight_pain2();
{
  #38 hknight_pain3;
}

Void function hknight_pain3();
{
  #39 hknight_pain4;
}

Void function hknight_pain4();
{
  #40 hknight_pain5;
}

Void function hknight_pain5();
{
  #41 hknight_run1;
}

Void function hknight_die1();
{
  #42 hknight_die2;
  ai_forward(MOVETYPE_BOUNCE);
}

Void function hknight_die2();
{
  #43 hknight_die3;
  ai_forward(FL_CLIENT);
}

Void function hknight_die3();
{
  #44 hknight_die4;
  self.solid = SOLID_NOT;
  ai_forward(MOVETYPE_PUSH);
}

Void function hknight_die4();
{
  #45 hknight_die5;
}

Void function hknight_die5();
{
  #46 hknight_die6;
}

Void function hknight_die6();
{
  #47 hknight_die7;
}

Void function hknight_die7();
{
  #48 hknight_die8;
}

Void function hknight_die8();
{
  #49 hknight_die9;
  ai_forward(MOVETYPE_BOUNCE);
}

Void function hknight_die9();
{
  #50 hknight_die10;
  ai_forward(MOVETYPE_BOUNCEMISSILE);
}

Void function hknight_die10();
{
  #51 hknight_die11;
}

Void function hknight_die11();
{
  #52 hknight_die12;
}

Void function hknight_die12();
{
  #53 corpse_think;
}

Void function hknight_dieb1();
{
  #54 hknight_dieb2;
}

Void function hknight_dieb2();
{
  #55 hknight_dieb3;
}

Void function hknight_dieb3();
{
  #56 hknight_dieb4;
  self.solid = SOLID_NOT;
}

Void function hknight_dieb4();
{
  #57 hknight_dieb5;
}

Void function hknight_dieb5();
{
  #58 hknight_dieb6;
}

Void function hknight_dieb6();
{
  #59 hknight_dieb7;
}

Void function hknight_dieb7();
{
  #60 hknight_dieb8;
}

Void function hknight_dieb8();
{
  self.cnt = 0;
  #61 hknight_dieb9;
}

Void function hknight_dieb9();
{
  if (self.classtype == CT_MONBEARD && self.lives > 0) {
    self.aflag = 9 + random() + random() + random();
    #62 beard_returndelay;
    }
  else {
    Sub_UseTargets();
    #62 corpse_think;
    }
}

Void function beard_returndelay();
{
  if (self.cnt > self.aflag) {
    self.solid = SOLID_SLIDEBOX;
    if (!walkmove(0, 0)) {
      self.solid = SOLID_NOT;
      }
    else {
      self.cnt = 0;
      self.aflag = 0;
      self.health = 200;
      self.walkframe = 0;
      self.takedamage = DAMAGE_YES;
      beard_kippup();
      exit;
      }
    }
  #62 beard_returndelay;
  self.cnt = self.cnt + 1;
}

Void function beard_kippup();
{
  if (self.walkframe >= 9) {
    self.walkframe = 0;
    self.th_run();
    exit;
    }
  #166 beard_kippup;
  self.frame = 166 + self.walkframe;
  self.walkframe = self.walkframe + 1;
}

void() hknight_die = {
	local float num;

	num = 0;
	strategy_move = 0;
	if (self.classtype == CT_MONBEARD) self.lives = self.lives - 1;

	if (self.health < -40) {
		sound(self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		if (self.classtype == CT_MONBEARD) {
			ThrowHead("progs/gib3.mdl", self.health);
		}
		else {
			ThrowHead("progs/h_hellkn.mdl", self.health);
		}
		ThrowGib("progs/gib1.mdl", self.health);
		ThrowGib("progs/gib2.mdl", self.health);
		ThrowGib("progs/gib3.mdl", self.health);
		return;
	}
	sound(self, CHAN_VOICE, "hknight/death1.wav", 1, ATTN_NORM);
	if (self.classtype == CT_MONBEARD) { hknight_dieb1(); return; }

	if (random() > 0.5) {
		hknight_die1();
	} else {
		hknight_dieb1();
	}
}

Void function hknight_magica1();
{
  #79 hknight_magica2;
  ai_face();
}

Void function hknight_magica2();
{
  #80 hknight_magica3;
  ai_face();
}

Void function hknight_magica3();
{
  #81 hknight_magica4;
  ai_face();
}

Void function hknight_magica4();
{
  #82 hknight_magica5;
  ai_face();
}

Void function hknight_magica5();
{
  #83 hknight_magica6;
  ai_face();
}

Void function hknight_magica6();
{
  #84 hknight_magica7;
  ai_face();
  if (ai_check_z()) {
    if (self.flags & FL_ONGROUND) {
      self.flags = self.flags - FL_ONGROUND;
      self.origin_z = self.origin_z + 1;
      self.velocity_z = 280;
      }
    }
}

Void function hknight_magica7();
{
  #85 hknight_magica8;
  hknight_shot(CONTENT_SOLID);
}

Void function hknight_magica8();
{
  #86 hknight_magica9;
  hknight_shot(CONTENT_EMPTY);
}

Void function hknight_magica9();
{
  #87 hknight_magica10;
  hknight_shot(0);
}

Void function hknight_magica10();
{
  #88 hknight_magica11;
  hknight_shot(1);
}

Void function hknight_magica11();
{
  #89 hknight_magica12;
  hknight_shot(FL_SWIM);
}

Void function hknight_magica12();
{
  #90 hknight_magica13;
  hknight_shot(MOVETYPE_WALK);
}

Void function hknight_magica13();
{
  #91 hknight_magica14;
  ai_face();
}

Void function hknight_magica14();
{
  #92 hknight_run1;
  ai_face();
}

Void function hknight_magicb1();
{
  #93 hknight_magicb2;
  ai_face();
}

Void function hknight_magicb2();
{
  #94 hknight_magicb3;
  ai_face();
}

Void function hknight_magicb3();
{
  #95 hknight_magicb4;
  ai_face();
}

Void function hknight_magicb4();
{
  #96 hknight_magicb5;
  ai_face();
}

Void function hknight_magicb5();
{
  #97 hknight_magicb6;
  ai_face();
}

Void function hknight_magicb6();
{
  #98 hknight_magicb7;
  ai_face();
  if (ai_check_z()) {
    if (self.flags & FL_ONGROUND) {
      self.flags = self.flags - FL_ONGROUND;
      self.origin_z = self.origin_z + 1;
      self.velocity_z = 300;
      }
    }
}

Void function hknight_magicb7();
{
  #99 hknight_magicb8;
  hknight_shot(CONTENT_SOLID);
}

Void function hknight_magicb8();
{
  #100 hknight_magicb9;
  hknight_shot(CONTENT_EMPTY);
}

Void function hknight_magicb9();
{
  #101 hknight_magicb10;
  hknight_shot(0);
}

Void function hknight_magicb10();
{
  #102 hknight_magicb11;
  hknight_shot(1);
}

Void function hknight_magicb11();
{
  #103 hknight_magicb12;
  hknight_shot(FL_SWIM);
}

Void function hknight_magicb12();
{
  #104 hknight_magicb13;
  hknight_shot(MOVETYPE_WALK);
}

Void function hknight_magicb13();
{
  #105 hknight_run1;
  ai_face();
}

Void function hknight_rushdecide();
{
  if (self.classname == self.classtype == CT_MONBEARD) {
    return 0;
    }
  if (self.origin_z == self.enemy.origin_z) {
    if (strategy_move < 2) {
      strategy_move = 1;
      sound(self, CHAN_BODY, "nehahra/sets/set2_4.wav", 1, ATTN_NONE);
      ai_face();
      self.yaw_speed = 5;
      hknight_rush1();
      return 1;
      exit;
      }
    }
  return 0;
}

Void function hknight_magicc1();
{
  if (self.classname == self.classtype == CT_MONBEARD) {
    beard_attack1();
    exit;
    }
  if (hknight_rushdecide()) {
    exit;
    }
  #155 hknight_magicc2;
  ai_face();
}

Void function hknight_magicc2();
{
  #156 hknight_magicc3;
  ai_face();
}

Void function hknight_magicc3();
{
  #157 hknight_magicc4;
  ai_face();
}

Void function hknight_magicc4();
{
  #158 hknight_magicc5;
  ai_face();
  if (ai_check_z()) {
    if (self.flags & FL_ONGROUND) {
      self.flags = self.flags - FL_ONGROUND;
      self.origin_z = self.origin_z + 1;
      self.velocity_z = 180;
      }
    }
}

Void function hknight_magicc5();
{
  #159 hknight_magicc6;
  ai_face();
}

Void function hknight_magicc6();
{
  #160 hknight_magicc7;
  hknight_shot(CONTENT_SOLID);

}

Void function hknight_magicc7();
{
  #161 hknight_magicc8;
  hknight_shot(CONTENT_EMPTY);
}

Void function hknight_magicc8();
{
  #162 hknight_magicc9;
  hknight_shot(0);
}

Void function hknight_magicc9();
{
  #163 hknight_magicc10;
  hknight_shot(1);
}

Void function hknight_magicc10();
{
  #164 hknight_magicc11;
  hknight_shot(FL_SWIM);
}

Void function hknight_magicc11();
{
  #165 hknight_run1;
  hknight_shot(MOVETYPE_WALK);
}

Void function hknight_char_a1();
{
  #63 hknight_char_a2;
  ai_charge(20);
}

Void function hknight_char_a2();
{
  #64 hknight_char_a3;
  ai_charge(25);
}

Void function hknight_char_a3();
{
  #65 hknight_char_a4;
  ai_charge(18);
}

Void function hknight_char_a4();
{
  #66 hknight_char_a5;
  ai_charge(FL_INWATER);
}

Void function hknight_char_a5();
{
  #67 hknight_char_a6;
  ai_charge(14);
}

Void function hknight_char_a6();
{
  #68 hknight_char_a7;
  ai_charge(20);
  ai_melee();
}

Void function hknight_char_a7();
{
  #69 hknight_char_a8;
  ai_charge(21);
  ai_melee();
}

Void function hknight_char_a8();
{
  #70 hknight_char_a9;
  ai_charge(13);
  ai_melee();
}

Void function hknight_char_a9();
{
  #71 hknight_char_a10;
  ai_charge(20);
  ai_melee();
}

Void function hknight_char_a10();
{
  #72 hknight_char_a11;
  ai_charge(20);
  ai_melee();
}

Void function hknight_char_a11();
{
  #73 hknight_char_a12;
  ai_charge(18);
  ai_melee();
}

Void function hknight_char_a12();
{
  #74 hknight_char_a13;
  ai_charge(FL_INWATER);
}

Void function hknight_char_a13();
{
  #75 hknight_char_a14;
  ai_charge(14);
}

Void function hknight_char_a14();
{
  #76 hknight_char_a15;
  ai_charge(25);
}

Void function hknight_char_a15();
{
  #77 hknight_char_a16;
  ai_charge(21);
}

Void function hknight_char_a16();
{
  #78 hknight_run1;
  ai_charge(13);
}

Void function hknight_char_b1();
{
  #106 hknight_char_b2;
  CheckContinueCharge();
  SwordSwipeSound();
  ai_charge(SVC_TEMPENTITY);
  ai_melee();
}

Void function hknight_char_b2();
{
  #107 hknight_char_b3;
  ai_charge(17);
  ai_melee();
}

Void function hknight_char_b3();
{
  #108 hknight_char_b4;
  ai_charge(12);
  ai_melee();
}

Void function hknight_char_b4();
{
  #109 hknight_char_b5;
  ai_charge(22);
  ai_melee();
}

Void function hknight_char_b5();
{
  #110 hknight_char_b6;
  ai_charge(18);
  ai_melee();
}

Void function hknight_char_b6();
{
  #111 hknight_char_b1;
  ai_charge(FL_CLIENT);
  ai_melee();
}

Void function hknight_slice1();
{
  #112 hknight_slice2;
  ai_charge(MOVETYPE_FLYMISSILE);
}

Void function hknight_slice2();
{
  #113 hknight_slice3;
  ai_charge(MOVETYPE_TOSS);
}

Void function hknight_slice3();
{
  #114 hknight_slice4;
  ai_charge(13);
}

Void function hknight_slice4();
{
  #115 hknight_slice5;
  ai_charge(MOVETYPE_STEP);
}

Void function hknight_slice5();
{
  #116 hknight_slice6;
  ai_charge(MOVETYPE_PUSH);
  ai_melee();
}

Void function hknight_slice6();
{
  #117 hknight_slice7;
  ai_charge(15);
  ai_melee();
}

Void function hknight_slice7();
{
  #118 hknight_slice8;
  ai_charge(FL_CLIENT);
  ai_melee();
}

Void function hknight_slice8();
{
  #119 hknight_slice9;
  ai_charge(FL_SWIM);
  ai_melee();
}

Void function hknight_slice9();
{
  #120 hknight_slice10;
  ai_melee();
}

Void function hknight_slice10();
{
  #121 hknight_run1;
  ai_charge(MOVETYPE_WALK);
}

Void function hknight_smash1();
{
  #122 hknight_smash2;
  ai_charge(1);
}

Void function hknight_smash2();
{
  #123 hknight_smash3;
  ai_charge(13);
}

Void function hknight_smash3();
{
  #124 hknight_smash4;
  ai_charge(MOVETYPE_FLYMISSILE);
}

Void function hknight_smash4();
{
  #125 hknight_smash6;
  ai_charge(MOVETYPE_BOUNCEMISSILE);
  ai_melee();
}

Void function hknight_smash6();
{
  #127 hknight_smash7;
  ai_charge(MOVETYPE_PUSH);
  ai_melee();
}

Void function hknight_smash7();
{
  #128 hknight_smash8;
  ai_charge(12);
  ai_melee();
}

Void function hknight_smash8();
{
  #129 hknight_smash9;
  ai_charge(FL_SWIM);
  ai_melee();
}

Void function hknight_smash9();
{
  #130 hknight_smash11;
  ai_charge(MOVETYPE_WALK);
  ai_melee();
}

Void function hknight_smash11();
{
  #132 hknight_run1;
  ai_charge(0);
}

Void function hknight_watk1();
{
  #133 hknight_watk3;
  ai_charge(4);
}

Void function hknight_watk3();
{
  #135 hknight_watk5;
  ai_charge(2);
}

Void function hknight_watk5();
{
  #137 hknight_watk7;
  ai_charge(2);
}

Void function hknight_watk7();
{
  #139 hknight_watk9;
  ai_charge(1);
  ai_melee();
}

Void function hknight_watk9();
{
  #141 hknight_watk11;
  ai_charge(MOVETYPE_FLY);
  ai_melee();
}

Void function hknight_watk11();
{
  #143 hknight_watk13;
  ai_charge(FL_SWIM);
}

Void function hknight_watk13();
{
  #145 hknight_watk15;
  ai_charge(2);
}

Void function hknight_watk15();
{
  #147 hknight_watk17;
  ai_charge(3);
}

Void function hknight_watk17();
{
  #149 hknight_watk19;
  ai_charge(1);
  ai_melee();
}

Void function hknight_watk19();
{
  #151 hknight_watk22;
  ai_charge(MOVETYPE_STEP);
}

Void function hknight_watk22();
{
  #153 hknight_run1;
  ai_charge(MOVETYPE_WALK);
}

Void function hk_idle_sound();
{
  if (random() < 0.2) {
    sound(self, CHAN_VOICE, "hknight/idle.wav", 1, ATTN_NORM);
    }
}

Void function hknight_pain(attacker : Object; damage : Real);
{
  if (self.pain_finished > time) {
    exit;
    }
  sound(self, CHAN_VOICE, "hknight/pain1.wav", 1, ATTN_NORM);
  if (time - self.pain_finished > MOVETYPE_FLY) {
    hknight_pain1();
    self.pain_finished = time + 1;
    exit;
    }
  if (random() * SVC_INTERMISSION > damage) {
    exit;
    }
  self.pain_finished = time + 1;
  hknight_pain1();
}

Void function hknight_melee();
{
  if (random() < 0.4) {
    if (self.classtype == CT_MONBEARD) {
      beard_attack1();
      exit;
      }
    }
  self.meleeattack = self.meleeattack + 1;
  sound(self, CHAN_WEAPON, "hknight/slash1.wav", 1, ATTN_NORM);
  if (self.meleeattack == 1) {
    hknight_slice1();
    }
  else {
    if (self.meleeattack == FL_SWIM) {
      hknight_smash1();
      }
    else {
      if (self.meleeattack == MOVETYPE_WALK) {
        hknight_watk1();
        self.meleeattack = 0;
        }
      }
    }
};

void() monster_beard_precache = {
	precache_model("progs/nehahra/beard.mdl");
	precache_sound("nehahra/ghoro/balls.wav");
	precache_sound("nehahra/ghoro/spawnb.wav");
	precache_sound("nehahra/ghoro/talk1.wav");
	precache_sound("nehahra/ghoro/talk2.wav");
	precache_sound("nehahra/ghoro/talk3.wav");
	precache_sound("nehahra/ghoro/laugh.wav");
	precache_model("progs/k_spike.mdl");
	precache_model("progs/h_hellkn.mdl");
	precache_sound("hknight/attack1.wav");
	precache_sound("hknight/death1.wav");
	precache_sound("hknight/pain1.wav");
	precache_sound("hknight/sight1.wav");
	precache_sound("hknight/hit.wav");
	precache_sound("hknight/slash1.wav");
	precache_sound("hknight/idle.wav");
	precache_sound("hknight/grunt.wav");
	precache_sound("knight/sword1.wav");
	precache_sound("knight/sword2.wav");
	precache_sound("nehahra/sets/set2_4.wav");
	precache_sound("nehahra/sets/dml1_4.wav");
};

void() monster_beard = {
	if (deathmatch) { remove(self); return; }

	setmodel(self, "progs/nehahra/beard.mdl");
	self.sight_sound = "nehahra/ghoro/laugh.wav";
	if (!(self.brain & NO_SWIM)) self.brain = self.brain | NO_SWIM;

	if (self.classname == "monster_beard") {
		self.classtype = CT_MONBEARD;
		self.lives = 8;
		self.th_wins = beard_wins;
		if (!(self.health)) self.health = 650;
		if (!(self.brain & BLINK)) self.brain = self.brain | BLINK;

		if (world.model == "maps/neh2m1.bsp") {
			self.th_stand = hknight_wait;
			self.th_walk = hknight_wait;
		}
	} else {
		self.health = 250;
	}

	if (!(self.brain & NAVLOGIC)) self.brain = self.brain | NAVLOGIC;

	if (self.targetname == "actor19" || self.targetname == "actor20") {
		self.th_stand = hknight_wait;
		self.th_walk = hknight_wait;
	} else {
		self.th_stand = hknight_stand1;
		self.th_walk = hknight_walk1;
	}


	self.th_run = hknight_run1;
	self.th_melee = hknight_melee;
	self.th_missile = hknight_magicc1;
	self.th_pain = hknight_pain;
	self.th_die = hknight_die;
	if (self.brain & TRIGGER_SPAWN) {
		self.use = hknight_start;
		return;
	}

	setsize(self, VEC_HULL_MIN, [16 16 40]);
	monster_start();
};

void() hknight_start = {
	trigger_spawnmonster();
	carnify_hknight();
};

Void function carnify_hknight();
{
  self.solid = SOLID_SLIDEBOX;
  self.movetype = MOVETYPE_STEP;
  setmodel(self, "progs/hknight.mdl");
  setsize(self, VEC_HULL_MIN, [16 16 40]);
  if (!(self.health)) {
    self.health = 250;
    }
  monster_start();
}

Void function hknight_wait();
{
  self.use = hknight_begin;
  if (self.walkframe >= 8) {
    self.walkframe = 0;
    }
  #0 hknight_wait;
  self.frame = 0 + self.walkframe;
  self.walkframe = self.walkframe + 1;
}

Void function hknight_begin();
{
  self.use = monster_use;
  self.th_stand = hknight_stand1;
  self.th_walk = hknight_walk1;
  if (self.goalentity == world) {
    #0 hknight_stand1;
    }
  else {
    #0 hknight_walk1;
    }
}


void() thinking_balls = {
	if (self.cnt > 10) {
		sound(self, CHAN_ENDER, "nehahra/ghoro/spawnb.wav", 1, ATTN_NORM);
		self.solid = SOLID_BBOX;
		self.touch = Brd_MissileTouch;
		self.think = fire_a_ball;
		self.nextthink = time + 1;
		return;
	}
		self.cnt = self.cnt + 1;
		ai_orbit_nehahra(self.boost, self.aether);
		if (self.pain_finished > time) {
		self.think = thinking_balls;
		self.nextthink = time + 0.1;
		return;
	}
	self.pain_finished = time + 1.1;
	sound(self, CHAN_AUTO, "nehahra/ghoro/balls.wav", 1, ATTN_NORM);
	self.think = thinking_balls;
	self.nextthink = time + 0.1;
};

Void function Brd_MissileTouch();
var
 damg : Real;
{
  if (other == self.owner) {
    exit;
    }
  if (pointcontents(self.origin) == CONTENT_SKY) {
    remove(self);
    exit;
    }
  if (other.health) {
    if (self.flags & FL_MONSTER) {
      damg = 25 + random() * 5;
      T_RadiusDamage(self, self.owner, 60, other);
      }
    else {
      damg = 100 + random() * 20;
      T_RadiusDamage(self, self.owner, 120, other);
      }
    T_Damage(other, self, self.owner, damg);
    self.origin = self.origin - FL_CLIENT * normalize(self.velocity);
    Tent_Explosion(self.origin);
    if (random() < 0.4) becomeexplosion();
    else becomeexplosion3();
    
    return;
    }
  sound(self, CHAN_BAL, "nehahra/ghoro/spawnb.wav", 1, ATTN_NORM);
  remove(self);
}

Void function fire_a_ball();
{
  self.blink = self.blink + 1;
  if (self.blink > 12) {
    sound(self, CHAN_BAL, "nehahra/ghoro/spawnb.wav", 1, ATTN_NORM);
    remove(self);
    exit;
    }
  sound(self, CHAN_AUTO, "nehahra/ghoro/balls.wav", 1, ATTN_NORM);
  self.solid = SOLID_BBOX;
  makevectors(self.owner.angles);
  self.velocity = normalize(self.enemy.origin - self.origin);
  self.velocity = self.velocity * 600;
  self.think = fire_a_ball;
  self.nextthink = time + 0.6;
}

void() ai_orbit_nehahra(float radius, vector offset) = {
	local vector dir;
	local float dist;

  if (self.rotate_type > 3 || self.rotate_type < 0) {
    self.rotate_type = 0;
    }
  traceline(self.origin, self.owner.origin + offset, TRUE, world);
  if (trace_fraction < 1) {
    setorigin (self, self.owner.origin + offset);
    self.rotate_type = self.rotate_type + 1;
    exit;
    }
  if (self.rotate_type == 0) {
    dir = (self.owner.origin + offset) - self.origin;
    dir_x = dir_x + radius;
    }
  else {
    if (self.rotate_type == 1) {
      dir = (self.owner.origin + offset) - self.origin;
      dir_y = dir_y + radius;
      }
    else {
      if (self.rotate_type == 2) {
        dir = (self.owner.origin + offset) - self.origin;
        dir_x = dir_x - radius;
        }
      else {
        dir = (self.owner.origin + offset) - self.origin;
        dir_y = dir_y - radius;
        }
      }
    }
  dist = vlen(dir);
  if (dist < 8) {
    self.rotate_type = self.rotate_type + 1;
    }
  else {
    if (dist < 50) {
      self.velocity = normalize(dir);
      self.velocity = self.velocity * 150;
      }
    else {
      self.velocity = normalize(dir);
      self.velocity = self.velocity * 500;
      }
    }
}

void(float num, vector dave) beard_balls = {
	local entity ball;

	sound(self, CHAN_VOICE, "nehahra/ghoro/spawnb.wav", 1, ATTN_NORM);
	ball = spawn();
	ball.movetype = MOVETYPE_FLYMISSILE;
	ball.solid = SOLID_NOT;
	ball.aether = dave;
	ball.boost = num;
	ball.enemy = self.enemy;
	ball.effects = EF_BRIGHTFIELD;
	ball.owner = self;
	setmodel (ball, "progs/s_explod.spr");
	setsize (ball, [0 0 0], [0 0 0]);     
	setorigin (ball, self.origin);
	ball.cnt = 0;
	ball.avelocity = [40 40 40];
	ball.think = thinking_balls;
	ball.nextthink = time + 0.1;
};

Void function beard_attack1();
{
  #92 beard_attack2;
  self.pain_finished = time + 2;
  ai_face();
}

Void function beard_attack2();
{
  #91 beard_attack3;
  ai_face();
  self.takedamage = DAMAGE_NO;
}

Void function beard_attack3();
{
  #90 beard_attack4;
  ai_face();
}

Void function beard_attack4();
{
  #89 beard_attack5;
  ai_face();
  self.effects = self.effects | EF_MUZZLEFLASH;
}

Void function beard_attack5();
{
  #88 beard_attack6;
  ai_face();
}

Void function beard_attack6();
{
  #87 beard_attack7;
  ai_face();
  self.effects = self.effects | EF_MUZZLEFLASH;
  beard_balls(5, [0 0 10]);
}

Void function beard_attack7();
{
  #86 beard_attack8;
  ai_face();
}

Void function beard_attack8();
{
  #85 beard_attack9;
  ai_face();
  self.effects = self.effects | EF_MUZZLEFLASH;
  beard_balls(5, [0 0 30]);
}

Void function beard_attack9();
{
  #84 beard_attack10;
  ai_face();
}

Void function beard_attack10();
{
  #83 beard_attack11;
  ai_face();
  self.effects = self.effects | EF_MUZZLEFLASH;
  beard_balls(9, [0 0 40]);
  self.takedamage = DAMAGE_AIM;
}

Void function beard_attack11();
{
  #84 beard_attack12;
  ai_face();
  self.effects = self.effects | EF_MUZZLEFLASH;
}

Void function beard_attack12();
{
  #85 beard_attack13;
  ai_face();
  self.effects = self.effects | EF_MUZZLEFLASH;
}

Void function beard_attack13();
{
  #84 beard_attack14;
  ai_face();
  self.effects = self.effects | EF_MUZZLEFLASH;
  self.walkframe = 0;
}

Void function beard_attack14();
{
  #85 beard_attack15;
  ai_face();
  self.effects = self.effects | EF_MUZZLEFLASH;
}

Void function beard_attack15();
{
  if (self.walkframe >= 11) {
    self.th_run();
    exit;
    }
  #95 beard_attack15;
  self.frame = 95 + self.walkframe;
  self.walkframe = self.walkframe + 1;
  ai_face();
}

Void function beard_wins();
{
  beard_talksound();
  if (random() < 0.4) {
    beard_look();
    }
  else {
    beard_nod();
    }
}

Void function beard_talksound();
var
 num : Real;
{
  num = random() + random();
  if (num < 0.6) {
    sound(self, CHAN_VOICE, "nehahra/ghoro/talk1.wav", 1, ATTN_NORM);
    exit;
    }
  if (num < 1.2) {
    sound(self, CHAN_VOICE, "nehahra/ghoro/talk2.wav", 1, ATTN_NORM);
    exit;
    }
  sound(self, CHAN_VOICE, "nehahra/ghoro/talk3.wav", 1, ATTN_NORM);
}

Void function beard_look();
{
  if (self.walkframe >= 18) {
    self.walkframe = 0;
    self.th_stand();
    exit;
    }
  #175 beard_look;
  self.frame = 175 + self.walkframe;
  self.walkframe = self.walkframe + 1;
}

Void function beard_nod();
{
  if (self.walkframe >= 9) {
    self.walkframe = 0;
    self.th_stand();
    exit;
    }
  #193 beard_nod;
  self.frame = 193 + self.walkframe;
  self.walkframe = self.walkframe + 1;
}

