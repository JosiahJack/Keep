void(float offset) hknight_shot = 
{
	local vector offang;
	local vector org;
	local vector vec;
	offang = vectoangles(self.enemy.origin - self.origin);
	offang_y = offang_y + offset * MOVETYPE_TOSS;
	makevectors(offang);
	org = self.origin + self.mins + self.size * 0.5 + v_forward * 20;
	vec = normalize(v_forward);
	vec_z = 0 - vec_z + (random() - 0.5) * 0.1;
	launch_spike(org, vec);
	newmis.classname = "knightspike";
	setmodel(newmis, "progs/k_spike.mdl");
	setsize(newmis, VEC_ORIGIN, VEC_ORIGIN);
	newmis.velocity = vec * 300;
	sound(self, CHAN_WEAPON, "hknight/attack1.wav", 1, ATTN_NORM);
};

void() CheckForCharge = 
{
	if (!enemy_vis)
	{
		return;
	}
	if (time < self.attack_finished)
	{
		return;
	}
	if (fabs(self.origin_z - self.enemy.origin_z) > 20)
	{
		return;
	}
	if (vlen(self.origin - self.enemy.origin) < 80)
	{
		return;
	}
	SUB_AttackFinished(FL_SWIM);
	hknight_char_a1();
};

void() CheckContinueCharge = 
{
	if (time > self.attack_finished)
	{
		SUB_AttackFinished(MOVETYPE_WALK);
		hknight_run1();
		return;
	}
	if (random() > 0.5)
	{
		sound(self, CHAN_WEAPON, "knight/sword2.wav", 1, ATTN_NORM);
	}
	else
	{
		sound(self, CHAN_WEAPON, "knight/sword1.wav", 1, ATTN_NORM);
	}
};

void() hknight_stand1 = [0, hknight_stand2]
{
	ai_stand();
};

void() hknight_stand2 = [1, hknight_stand3]
{
	ai_stand();
};

void() hknight_stand3 = [2, hknight_stand4]
{
	ai_stand();
};

void() hknight_stand4 = [3, hknight_stand5]
{
	ai_stand();
};

void() hknight_stand5 = [4, hknight_stand6]
{
	ai_stand();
};

void() hknight_stand6 = [5, hknight_stand7]
{
	ai_stand();
};

void() hknight_stand7 = [6, hknight_stand8]
{
	ai_stand();
};

void() hknight_stand8 = [7, hknight_stand9]
{
	ai_stand();
};

void() hknight_stand9 = [8, hknight_stand1]
{
	ai_stand();
};

void() hknight_walk1 = [9, hknight_walk2]
{
	hk_idle_sound();
	ai_walk(FL_SWIM);
};

void() hknight_walk2 = [10, hknight_walk3]
{
	ai_walk(MOVETYPE_FLY);
};

void() hknight_walk3 = [11, hknight_walk4]
{
	ai_walk(MOVETYPE_FLY);
};

void() hknight_walk4 = [12, hknight_walk5]
{
	ai_walk(MOVETYPE_STEP);
};

void() hknight_walk5 = [13, hknight_walk6]
{
	ai_walk(MOVETYPE_STEP);
};

void() hknight_walk6 = [14, hknight_walk7]
{
	ai_walk(FL_SWIM);
};

void() hknight_walk7 = [15, hknight_walk8]
{
	ai_walk(FL_SWIM);
};

void() hknight_walk8 = [16, hknight_walk9]
{
	ai_walk(MOVETYPE_WALK);
};

void() hknight_walk9 = [17, hknight_walk10]
{
	ai_walk(MOVETYPE_WALK);
};

void() hknight_walk10 = [18, hknight_walk11]
{
	ai_walk(MOVETYPE_STEP);
};

void() hknight_walk11 = [19, hknight_walk12]
{
	ai_walk(MOVETYPE_WALK);
};

void() hknight_walk12 = [20, hknight_walk13]
{
	ai_walk(MOVETYPE_STEP);
};

void() hknight_walk13 = [21, hknight_walk14]
{
	ai_walk(MOVETYPE_TOSS);
};

void() hknight_walk14 = [22, hknight_walk15]
{
	ai_walk(FL_SWIM);
};

void() hknight_walk15 = [23, hknight_walk16]
{
	ai_walk(FL_SWIM);
};

void() hknight_walk16 = [24, hknight_walk17]
{
	ai_walk(MOVETYPE_STEP);
};

void() hknight_walk17 = [25, hknight_walk18]
{
	ai_walk(MOVETYPE_WALK);
};

void() hknight_walk18 = [26, hknight_walk19]
{
	ai_walk(MOVETYPE_WALK);
};

void() hknight_walk19 = [27, hknight_walk20]
{
	ai_walk(MOVETYPE_WALK);
};

void() hknight_walk20 = [28, hknight_walk1]
{
	ai_walk(FL_SWIM);
};

void() hknight_run1 = [29, hknight_run2]
{
	hk_idle_sound();
	ai_run(20);
	CheckForCharge();
};

void() hknight_run2 = [30, hknight_run3]
{
	ai_run(25);
};

void() hknight_run3 = [31, hknight_run4]
{
	ai_run(18);
};

void() hknight_run4 = [32, hknight_run5]
{
	ai_run(FL_INWATER);
};

void() hknight_run5 = [33, hknight_run6]
{
	ai_run(14);
};

void() hknight_run6 = [34, hknight_run7]
{
	ai_run(25);
};

void() hknight_run7 = [35, hknight_run8]
{
	ai_run(21);
};

void() hknight_run8 = [36, hknight_run1]
{
	ai_run(13);
};

void() hknight_pain1 = [37, hknight_pain2]
{
	sound(self, CHAN_VOICE, "hknight/pain1.wav", 1, ATTN_NORM);
};

void() hknight_pain2 = [38, hknight_pain3]
{
};

void() hknight_pain3 = [39, hknight_pain4]
{
};

void() hknight_pain4 = [40, hknight_pain5]
{
};

void() hknight_pain5 = [41, hknight_run1]
{
};

void() hknight_die1 = [42, hknight_die2]
{
	ai_forward(MOVETYPE_BOUNCE);
};

void() hknight_die2 = [43, hknight_die3]
{
	ai_forward(FL_CLIENT);
};

void() hknight_die3 = [44, hknight_die4]
{
	self.solid = SOLID_NOT;
	ai_forward(MOVETYPE_PUSH);
};

void() hknight_die4 = [45, hknight_die5]
{
};

void() hknight_die5 = [46, hknight_die6]
{
};

void() hknight_die6 = [47, hknight_die7]
{
};

void() hknight_die7 = [48, hknight_die8]
{
};

void() hknight_die8 = [49, hknight_die9]
{
	ai_forward(MOVETYPE_BOUNCE);
};

void() hknight_die9 = [50, hknight_die10]
{
	ai_forward(MOVETYPE_BOUNCEMISSILE);
};

void() hknight_die10 = [51, hknight_die11]
{
};

void() hknight_die11 = [52, hknight_die12]
{
};

void() hknight_die12 = [53, hknight_die12]
{
};

void() hknight_dieb1 = [54, hknight_dieb2]
{
};

void() hknight_dieb2 = [55, hknight_dieb3]
{
};

void() hknight_dieb3 = [56, hknight_dieb4]
{
	self.solid = SOLID_NOT;
};

void() hknight_dieb4 = [57, hknight_dieb5]
{
};

void() hknight_dieb5 = [58, hknight_dieb6]
{
};

void() hknight_dieb6 = [59, hknight_dieb7]
{
};

void() hknight_dieb7 = [60, hknight_dieb8]
{
};

void() hknight_dieb8 = [61, hknight_dieb9]
{
};

void() hknight_dieb9 = [62, hknight_dieb9]
{
};

void() hknight_die = 
{
	if (self.health < -40)
	{
		sound(self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		ThrowHead("progs/h_hellkn.mdl", self.health);
		ThrowGib("progs/gib1.mdl", self.health);
		ThrowGib("progs/gib2.mdl", self.health);
		ThrowGib("progs/gib3.mdl", self.health);
		return;
	}
	sound(self, CHAN_VOICE, "hknight/death1.wav", 1, ATTN_NORM);
	if (random() > 0.5)
	{
		hknight_die1();
	}
	else
	{
		hknight_dieb1();
	}
};

void() hknight_magica1 = [79, hknight_magica2]
{
	ai_face();
};

void() hknight_magica2 = [80, hknight_magica3]
{
	ai_face();
};

void() hknight_magica3 = [81, hknight_magica4]
{
	ai_face();
};

void() hknight_magica4 = [82, hknight_magica5]
{
	ai_face();
};

void() hknight_magica5 = [83, hknight_magica6]
{
	ai_face();
};

void() hknight_magica6 = [84, hknight_magica7]
{
	ai_face();
};

void() hknight_magica7 = [85, hknight_magica8]
{
	hknight_shot(CONTENT_SOLID);
};

void() hknight_magica8 = [86, hknight_magica9]
{
	hknight_shot(CONTENT_EMPTY);
};

void() hknight_magica9 = [87, hknight_magica10]
{
	hknight_shot(0);
};

void() hknight_magica10 = [88, hknight_magica11]
{
	hknight_shot(1);
};

void() hknight_magica11 = [89, hknight_magica12]
{
	hknight_shot(FL_SWIM);
};

void() hknight_magica12 = [90, hknight_magica13]
{
	hknight_shot(MOVETYPE_WALK);
};

void() hknight_magica13 = [91, hknight_magica14]
{
	ai_face();
};

void() hknight_magica14 = [92, hknight_run1]
{
	ai_face();
};

void() hknight_magicb1 = [93, hknight_magicb2]
{
	ai_face();
};

void() hknight_magicb2 = [94, hknight_magicb3]
{
	ai_face();
};

void() hknight_magicb3 = [95, hknight_magicb4]
{
	ai_face();
};

void() hknight_magicb4 = [96, hknight_magicb5]
{
	ai_face();
};

void() hknight_magicb5 = [97, hknight_magicb6]
{
	ai_face();
};

void() hknight_magicb6 = [98, hknight_magicb7]
{
	ai_face();
};

void() hknight_magicb7 = [99, hknight_magicb8]
{
	hknight_shot(CONTENT_SOLID);
};

void() hknight_magicb8 = [100, hknight_magicb9]
{
	hknight_shot(CONTENT_EMPTY);
};

void() hknight_magicb9 = [101, hknight_magicb10]
{
	hknight_shot(0);
};

void() hknight_magicb10 = [102, hknight_magicb11]
{
	hknight_shot(1);
};

void() hknight_magicb11 = [103, hknight_magicb12]
{
	hknight_shot(FL_SWIM);
};

void() hknight_magicb12 = [104, hknight_magicb13]
{
	hknight_shot(MOVETYPE_WALK);
};

void() hknight_magicb13 = [105, hknight_run1]
{
	ai_face();
};

void() hknight_magicc1 = [155, hknight_magicc2]
{
	ai_face();
};

void() hknight_magicc2 = [156, hknight_magicc3]
{
	ai_face();
};

void() hknight_magicc3 = [157, hknight_magicc4]
{
	ai_face();
};

void() hknight_magicc4 = [158, hknight_magicc5]
{
	ai_face();
};

void() hknight_magicc5 = [159, hknight_magicc6]
{
	ai_face();
};

void() hknight_magicc6 = [160, hknight_magicc7]
{
	hknight_shot(CONTENT_SOLID);
};

void() hknight_magicc7 = [161, hknight_magicc8]
{
	hknight_shot(CONTENT_EMPTY);
};

void() hknight_magicc8 = [162, hknight_magicc9]
{
	hknight_shot(0);
};

void() hknight_magicc9 = [163, hknight_magicc10]
{
	hknight_shot(1);
};

void() hknight_magicc10 = [164, hknight_magicc11]
{
	hknight_shot(FL_SWIM);
};

void() hknight_magicc11 = [165, hknight_run1]
{
	hknight_shot(MOVETYPE_WALK);
};

void() hknight_char_a1 = [63, hknight_char_a2]
{
	ai_charge(20);
};

void() hknight_char_a2 = [64, hknight_char_a3]
{
	ai_charge(25);
};

void() hknight_char_a3 = [65, hknight_char_a4]
{
	ai_charge(18);
};

void() hknight_char_a4 = [66, hknight_char_a5]
{
	ai_charge(FL_INWATER);
};

void() hknight_char_a5 = [67, hknight_char_a6]
{
	ai_charge(14);
};

void() hknight_char_a6 = [68, hknight_char_a7]
{
	ai_charge(20);
	ai_melee();
};

void() hknight_char_a7 = [69, hknight_char_a8]
{
	ai_charge(21);
	ai_melee();
};

void() hknight_char_a8 = [70, hknight_char_a9]
{
	ai_charge(13);
	ai_melee();
};

void() hknight_char_a9 = [71, hknight_char_a10]
{
	ai_charge(20);
	ai_melee();
};

void() hknight_char_a10 = [72, hknight_char_a11]
{
	ai_charge(20);
	ai_melee();
};

void() hknight_char_a11 = [73, hknight_char_a12]
{
	ai_charge(18);
	ai_melee();
};

void() hknight_char_a12 = [74, hknight_char_a13]
{
	ai_charge(FL_INWATER);
};

void() hknight_char_a13 = [75, hknight_char_a14]
{
	ai_charge(14);
};

void() hknight_char_a14 = [76, hknight_char_a15]
{
	ai_charge(25);
};

void() hknight_char_a15 = [77, hknight_char_a16]
{
	ai_charge(21);
};

void() hknight_char_a16 = [78, hknight_run1]
{
	ai_charge(13);
};

void() hknight_char_b1 = [106, hknight_char_b2]
{
	CheckContinueCharge();
	ai_charge(SVC_TEMPENTITY);
	ai_melee();
};

void() hknight_char_b2 = [107, hknight_char_b3]
{
	ai_charge(17);
	ai_melee();
};

void() hknight_char_b3 = [108, hknight_char_b4]
{
	ai_charge(12);
	ai_melee();
};

void() hknight_char_b4 = [109, hknight_char_b5]
{
	ai_charge(22);
	ai_melee();
};

void() hknight_char_b5 = [110, hknight_char_b6]
{
	ai_charge(18);
	ai_melee();
};

void() hknight_char_b6 = [111, hknight_char_b1]
{
	ai_charge(FL_CLIENT);
	ai_melee();
};

void() hknight_slice1 = [112, hknight_slice2]
{
	ai_charge(MOVETYPE_FLYMISSILE);
};

void() hknight_slice2 = [113, hknight_slice3]
{
	ai_charge(MOVETYPE_TOSS);
};

void() hknight_slice3 = [114, hknight_slice4]
{
	ai_charge(13);
};

void() hknight_slice4 = [115, hknight_slice5]
{
	ai_charge(MOVETYPE_STEP);
};

void() hknight_slice5 = [116, hknight_slice6]
{
	ai_charge(MOVETYPE_PUSH);
	ai_melee();
};

void() hknight_slice6 = [117, hknight_slice7]
{
	ai_charge(15);
	ai_melee();
};

void() hknight_slice7 = [118, hknight_slice8]
{
	ai_charge(FL_CLIENT);
	ai_melee();
};

void() hknight_slice8 = [119, hknight_slice9]
{
	ai_charge(FL_SWIM);
	ai_melee();
};

void() hknight_slice9 = [120, hknight_slice10]
{
	ai_melee();
};

void() hknight_slice10 = [121, hknight_run1]
{
	ai_charge(MOVETYPE_WALK);
};

void() hknight_smash1 = [122, hknight_smash2]
{
	ai_charge(1);
};

void() hknight_smash2 = [123, hknight_smash3]
{
	ai_charge(13);
};

void() hknight_smash3 = [124, hknight_smash4]
{
	ai_charge(MOVETYPE_FLYMISSILE);
};

void() hknight_smash4 = [125, hknight_smash5]
{
	ai_charge(MOVETYPE_BOUNCEMISSILE);
};

void() hknight_smash5 = [126, hknight_smash6]
{
	ai_charge(MOVETYPE_BOUNCE);
	ai_melee();
};

void() hknight_smash6 = [127, hknight_smash7]
{
	ai_charge(MOVETYPE_PUSH);
	ai_melee();
};

void() hknight_smash7 = [128, hknight_smash8]
{
	ai_charge(12);
	ai_melee();
};

void() hknight_smash8 = [129, hknight_smash9]
{
	ai_charge(FL_SWIM);
	ai_melee();
};

void() hknight_smash9 = [130, hknight_smash10]
{
	ai_charge(MOVETYPE_WALK);
	ai_melee();
};

void() hknight_smash10 = [131, hknight_smash11]
{
	ai_charge(0);
};

void() hknight_smash11 = [132, hknight_run1]
{
	ai_charge(0);
};

void() hknight_watk1 = [133, hknight_watk2]
{
	ai_charge(FL_SWIM);
};

void() hknight_watk2 = [134, hknight_watk3]
{
	ai_charge(0);
};

void() hknight_watk3 = [135, hknight_watk4]
{
	ai_charge(0);
};

void() hknight_watk4 = [136, hknight_watk5]
{
	ai_melee();
};

void() hknight_watk5 = [137, hknight_watk6]
{
	ai_melee();
};

void() hknight_watk6 = [138, hknight_watk7]
{
	ai_melee();
};

void() hknight_watk7 = [139, hknight_watk8]
{
	ai_charge(1);
};

void() hknight_watk8 = [140, hknight_watk9]
{
	ai_charge(MOVETYPE_STEP);
};

void() hknight_watk9 = [141, hknight_watk10]
{
	ai_charge(MOVETYPE_FLY);
};

void() hknight_watk10 = [142, hknight_watk11]
{
	ai_charge(MOVETYPE_WALK);
	ai_melee();
};

void() hknight_watk11 = [143, hknight_watk12]
{
	ai_charge(FL_SWIM);
	ai_melee();
};

void() hknight_watk12 = [144, hknight_watk13]
{
	ai_charge(FL_SWIM);
	ai_melee();
};

void() hknight_watk13 = [145, hknight_watk14]
{
	ai_charge(0);
};

void() hknight_watk14 = [146, hknight_watk15]
{
	ai_charge(0);
};

void() hknight_watk15 = [147, hknight_watk16]
{
	ai_charge(0);
};

void() hknight_watk16 = [148, hknight_watk17]
{
	ai_charge(1);
};

void() hknight_watk17 = [149, hknight_watk18]
{
	ai_charge(1);
	ai_melee();
};

void() hknight_watk18 = [150, hknight_watk19]
{
	ai_charge(MOVETYPE_WALK);
	ai_melee();
};

void() hknight_watk19 = [151, hknight_watk20]
{
	ai_charge(MOVETYPE_STEP);
	ai_melee();
};

void() hknight_watk20 = [152, hknight_watk21]
{
	ai_charge(MOVETYPE_TOSS);
};

void() hknight_watk21 = [153, hknight_watk22]
{
	ai_charge(MOVETYPE_PUSH);
};

void() hknight_watk22 = [154, hknight_run1]
{
	ai_charge(MOVETYPE_WALK);
};

void() hk_idle_sound = 
{
	if (random() < 0.2)
	{
		sound(self, CHAN_VOICE, "hknight/idle.wav", 1, ATTN_NORM);
	}
};

void(entity attacker, float damage) hknight_pain = 
{
	if (self.pain_finished > time)
	{
		return;
	}
	sound(self, CHAN_VOICE, "hknight/pain1.wav", 1, ATTN_NORM);
	if (time - self.pain_finished > MOVETYPE_FLY)
	{
		hknight_pain1();
		self.pain_finished = time + 1;
		return;
	}
	if (random() * SVC_INTERMISSION > damage)
	{
		return;
	}
	self.pain_finished = time + 1;
	hknight_pain1();
};

void() hknight_melee = 
{
	hknight_type = hknight_type + 1;
	sound(self, CHAN_WEAPON, "hknight/slash1.wav", 1, ATTN_NORM);
	if (hknight_type == 1)
	{
		hknight_slice1();
	}
	else
	{
		if (hknight_type == FL_SWIM)
		{
			hknight_smash1();
		}
		else
		{
			if (hknight_type == MOVETYPE_WALK)
			{
				hknight_watk1();
				hknight_type = 0;
			}
		}
	}
};

void() monster_hell_knight = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model2("progs/hknight.mdl");
	precache_model2("progs/k_spike.mdl");
	precache_model2("progs/h_hellkn.mdl");
	precache_sound2("hknight/attack1.wav");
	precache_sound2("hknight/death1.wav");
	precache_sound2("hknight/pain1.wav");
	precache_sound2("hknight/sight1.wav");
	precache_sound("hknight/hit.wav");
	precache_sound2("hknight/slash1.wav");
	precache_sound2("hknight/idle.wav");
	precache_sound2("hknight/grunt.wav");
	precache_sound("knight/sword1.wav");
	precache_sound("knight/sword2.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/hknight.mdl");
	setsize(self, VEC_HULL_MIN, '16 16 40');
	self.health = 250;
	self.th_stand = hknight_stand1;
	self.th_walk = hknight_walk1;
	self.th_run = hknight_run1;
	self.th_melee = hknight_melee;
	self.th_missile = hknight_magicc1;
	self.th_pain = hknight_pain;
	self.th_die = hknight_die;
	walkmonster_start();
};

