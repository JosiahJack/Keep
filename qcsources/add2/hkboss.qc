void() hkbossMissile = 
{
	local entity missile;
	local vector dir;
	local float dist;
	local float flytime;
	dir = normalize(self.enemy.origin + '0 0 10' - self.origin);
	dist = vlen(self.enemy.origin - self.origin);
	flytime = dist * 0.002000;
	if (flytime < 0.1)
	{
		flytime = 0.1;
	}
	self.effects = self.effects | EF_MUZZLEFLASH;
	sound(self, CHAN_WEAPON, "shalrath/attack2.wav", 1, ATTN_NORM);
	missile = spawn();
	missile.owner = self;
	missile.solid = SOLID_BBOX;
	missile.movetype = MOVETYPE_FLYMISSILE;
	setmodel(missile, "progs/v_spike.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	missile.origin = self.origin + '0 0 10';
	missile.velocity = dir * CTF_TARGET_PROTECT_RADIUS;
	missile.avelocity = '300 300 300';
	missile.nextthink = flytime + time;
	missile.think = hkbossHome;
	missile.enemy = self.enemy;
	missile.touch = hkbossMissileTouch;
};

void() hkbossHome = 
{
	local vector dir;
	local vector vtemp;
	vtemp = self.enemy.origin + '0 0 10';
	if (self.enemy.health < 1)
	{
		remove(self);
		return;
	}
	dir = normalize(vtemp - self.origin);
	if (skill == MOVETYPE_WALK)
	{
		self.velocity = dir * 350;
	}
	else
	{
		self.velocity = dir * 250;
	}
	self.nextthink = time + 0.2;
	self.think = hkbossHome;
};

void() hkbossMissileTouch = 
{
	if (other == self.owner)
	{
		return;
	}
	if (other.classname == "monster_zombie")
	{
		T_Damage(other, self, self, 65);
	}
	T_RadiusDamage(self, self.owner, 26, world);
	sound(self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord(MSG_BROADCAST, self.origin_x);
	WriteCoord(MSG_BROADCAST, self.origin_y);
	WriteCoord(MSG_BROADCAST, self.origin_z);
	self.velocity = VEC_ORIGIN;
	self.touch = SUB_Null;
	setmodel(self, "progs/s_explod.spr");
	self.solid = SOLID_NOT;
	s_explode1();
};

void(float offset) hkboss_shot = 
{
	local vector offang;
	local vector org;
	local vector vec;
	offang = vectoangles(self.enemy.origin - self.origin);
	offang_y = offang_y + offset * MOVETYPE_TOSS;
	makevectors(offang);
	org = self.origin + self.mins + self.size * SERVO_VOLUME + v_forward * 20;
	vec = normalize(v_forward);
	vec_z = 0 - vec_z + (random() - SERVO_VOLUME) * 0.1;
	launch_spike(org, vec);
	newmis.classname = "knightspike";
	setmodel(newmis, "progs/k_spike.mdl");
	setsize(newmis, VEC_ORIGIN, VEC_ORIGIN);
	newmis.velocity = vec * 300;
	sound(self, CHAN_WEAPON, "hknight/attack1.wav", 1, ATTN_NORM);
};

void() hkboss_CheckForCharge = 
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
	hkboss_char_b1();
};

void() hkboss_CheckContinueCharge = 
{
	if (time > self.attack_finished)
	{
		SUB_AttackFinished(MOVETYPE_WALK);
		hkboss_run1();
		return;
	}
	if (random() > SERVO_VOLUME)
	{
		sound(self, CHAN_WEAPON, "knight/sword2.wav", 1, ATTN_NORM);
	}
	else
	{
		sound(self, CHAN_WEAPON, "knight/sword1.wav", 1, ATTN_NORM);
	}
};

void() hkboss_stand1 = [0, hkboss_stand2]
{
	ai_stand();
};

void() hkboss_stand2 = [1, hkboss_stand3]
{
	ai_stand();
};

void() hkboss_stand3 = [2, hkboss_stand4]
{
	ai_stand();
};

void() hkboss_stand4 = [3, hkboss_stand5]
{
	ai_stand();
};

void() hkboss_stand5 = [4, hkboss_stand6]
{
	ai_stand();
};

void() hkboss_stand6 = [5, hkboss_stand7]
{
	ai_stand();
};

void() hkboss_stand7 = [6, hkboss_stand8]
{
	ai_stand();
};

void() hkboss_stand8 = [7, hkboss_stand9]
{
	ai_stand();
};

void() hkboss_stand9 = [8, hkboss_stand1]
{
	ai_stand();
};

void() hkboss_walk1 = [9, hkboss_walk2]
{
	hkboss_idle_sound();
	ai_walk(FL_SWIM);
};

void() hkboss_walk2 = [10, hkboss_walk3]
{
	ai_walk(MOVETYPE_FLY);
};

void() hkboss_walk3 = [11, hkboss_walk4]
{
	ai_walk(MOVETYPE_FLY);
};

void() hkboss_walk4 = [12, hkboss_walk5]
{
	ai_walk(MOVETYPE_STEP);
};

void() hkboss_walk5 = [13, hkboss_walk6]
{
	ai_walk(MOVETYPE_STEP);
};

void() hkboss_walk6 = [14, hkboss_walk7]
{
	ai_walk(FL_SWIM);
};

void() hkboss_walk7 = [15, hkboss_walk8]
{
	ai_walk(FL_SWIM);
};

void() hkboss_walk8 = [16, hkboss_walk9]
{
	ai_walk(MOVETYPE_WALK);
};

void() hkboss_walk9 = [17, hkboss_walk10]
{
	ai_walk(MOVETYPE_WALK);
};

void() hkboss_walk10 = [18, hkboss_walk11]
{
	ai_walk(MOVETYPE_STEP);
};

void() hkboss_walk11 = [19, hkboss_walk12]
{
	ai_walk(MOVETYPE_WALK);
};

void() hkboss_walk12 = [20, hkboss_walk13]
{
	ai_walk(MOVETYPE_STEP);
};

void() hkboss_walk13 = [21, hkboss_walk14]
{
	ai_walk(MOVETYPE_TOSS);
};

void() hkboss_walk14 = [22, hkboss_walk15]
{
	ai_walk(FL_SWIM);
};

void() hkboss_walk15 = [23, hkboss_walk16]
{
	ai_walk(FL_SWIM);
};

void() hkboss_walk16 = [24, hkboss_walk17]
{
	ai_walk(MOVETYPE_STEP);
};

void() hkboss_walk17 = [25, hkboss_walk18]
{
	ai_walk(MOVETYPE_WALK);
};

void() hkboss_walk18 = [26, hkboss_walk19]
{
	ai_walk(MOVETYPE_WALK);
};

void() hkboss_walk19 = [27, hkboss_walk20]
{
	ai_walk(MOVETYPE_WALK);
};

void() hkboss_walk20 = [28, hkboss_walk1]
{
	ai_walk(FL_SWIM);
};

void() hkboss_run1 = [29, hkboss_run2]
{
	hkboss_idle_sound();
	ai_run(20);
	hkboss_CheckForCharge();
};

void() hkboss_run2 = [30, hkboss_run3]
{
	ai_run(25);
};

void() hkboss_run3 = [31, hkboss_run4]
{
	ai_run(18);
};

void() hkboss_run4 = [32, hkboss_run5]
{
	ai_run(FL_INWATER);
};

void() hkboss_run5 = [33, hkboss_run6]
{
	ai_run(TEAM2);
};

void() hkboss_run6 = [34, hkboss_run7]
{
	ai_run(25);
};

void() hkboss_run7 = [35, hkboss_run8]
{
	ai_run(21);
};

void() hkboss_run8 = [36, hkboss_run1]
{
	ai_run(13);
};

void() hkboss_pain1 = [37, hkboss_pain2]
{
	sound(self, CHAN_VOICE, "hknight/pain1.wav", 1, ATTN_NORM);
};

void() hkboss_pain2 = [38, hkboss_pain3]
{
};

void() hkboss_pain3 = [39, hkboss_pain4]
{
};

void() hkboss_pain4 = [40, hkboss_pain5]
{
};

void() hkboss_pain5 = [41, hkboss_run1]
{
};

void() hkboss_die1 = [42, hkboss_die2]
{
	ai_forward(MOVETYPE_BOUNCE);
};

void() hkboss_die2 = [43, hkboss_die3]
{
	ai_forward(FL_CLIENT);
};

void() hkboss_die3 = [44, hkboss_die4]
{
	self.solid = SOLID_NOT;
	ai_forward(MOVETYPE_PUSH);
};

void() hkboss_die4 = [45, hkboss_die5]
{
};

void() hkboss_die5 = [46, hkboss_die6]
{
};

void() hkboss_die6 = [47, hkboss_die7]
{
};

void() hkboss_die7 = [48, hkboss_die8]
{
};

void() hkboss_die8 = [49, hkboss_die9]
{
	ai_forward(MOVETYPE_BOUNCE);
};

void() hkboss_die9 = [50, hkboss_die10]
{
	ai_forward(MOVETYPE_BOUNCEMISSILE);
};

void() hkboss_die10 = [51, hkboss_die11]
{
};

void() hkboss_die11 = [52, hkboss_die12]
{
};

void() hkboss_die12 = [53, hkboss_die12]
{
};

void() hkboss_dieb1 = [54, hkboss_dieb2]
{
};

void() hkboss_dieb2 = [55, hkboss_dieb3]
{
};

void() hkboss_dieb3 = [56, hkboss_dieb4]
{
	self.solid = SOLID_NOT;
};

void() hkboss_dieb4 = [57, hkboss_dieb5]
{
};

void() hkboss_dieb5 = [58, hkboss_dieb6]
{
};

void() hkboss_dieb6 = [59, hkboss_dieb7]
{
};

void() hkboss_dieb7 = [60, hkboss_dieb8]
{
};

void() hkboss_dieb8 = [61, hkboss_dieb9]
{
};

void() hkboss_dieb9 = [62, hkboss_dieb9]
{
};

void() hkboss_die = 
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
	if (random() > SERVO_VOLUME)
	{
		hkboss_die1();
	}
	else
	{
		hkboss_dieb1();
	}
};

void() hkboss_magica1 = [79, hkboss_magica2]
{
	ai_face();
};

void() hkboss_magica2 = [80, hkboss_magica3]
{
	ai_face();
};

void() hkboss_magica3 = [81, hkboss_magica4]
{
	ai_face();
};

void() hkboss_magica4 = [82, hkboss_magica5]
{
	ai_face();
};

void() hkboss_magica5 = [83, hkboss_magica6]
{
	ai_face();
};

void() hkboss_magica6 = [84, hkboss_magica7]
{
	ai_face();
};

void() hkboss_magica7 = [85, hkboss_magica8]
{
	ai_face();
};

void() hkboss_magica8 = [86, hkboss_magica9]
{
	hkboss_shot(0);
};

void() hkboss_magica9 = [87, hkboss_magica10]
{
	hkboss_shot(-0.5);
};

void() hkboss_magica10 = [88, hkboss_magica11]
{
	hkboss_shot(0);
};

void() hkboss_magica11 = [89, hkboss_magica12]
{
	hkboss_shot(SERVO_VOLUME);
};

void() hkboss_magica12 = [90, hkboss_magica13]
{
	hkboss_shot(0);
};

void() hkboss_magica13 = [91, hkboss_magica14]
{
	hkboss_shot(-0.5);
};

void() hkboss_magica14 = [92, hkboss_run1]
{
	ai_face();
};

void() hkboss_magicb1 = [93, hkboss_magicb2]
{
	ai_face();
};

void() hkboss_magicb2 = [94, hkboss_magicb3]
{
	ai_face();
};

void() hkboss_magicb3 = [95, hkboss_magicb4]
{
	ai_face();
};

void() hkboss_magicb4 = [96, hkboss_magicb5]
{
	ai_face();
};

void() hkboss_magicb5 = [97, hkboss_magicb6]
{
	ai_face();
};

void() hkboss_magicb6 = [98, hkboss_magicb7]
{
	ai_face();
};

void() hkboss_magicb7 = [99, hkboss_magicb8]
{
	ai_face();
};

void() hkboss_magicb8 = [100, hkboss_magicb9]
{
	ai_face();
};

void() hkboss_magicb9 = [101, hkboss_magicb10]
{
	hkbossMissile();
};

void() hkboss_magicb10 = [102, hkboss_magicb11]
{
	ai_face();
};

void() hkboss_magicb11 = [103, hkboss_magicb12]
{
	ai_face();
};

void() hkboss_magicb12 = [104, hkboss_magicb13]
{
	ai_face();
};

void() hkboss_magicb13 = [105, hkboss_run1]
{
	ai_face();
};

void() hkboss_magicc1 = [155, hkboss_magicc2]
{
	ai_face();
};

void() hkboss_magicc2 = [156, hkboss_magicc3]
{
	ai_face();
};

void() hkboss_magicc3 = [157, hkboss_magicc4]
{
	ai_face();
};

void() hkboss_magicc4 = [158, hkboss_magicc5]
{
	ai_face();
};

void() hkboss_magicc5 = [159, hkboss_magicc6]
{
	ai_face();
};

void() hkboss_magicc6 = [160, hkboss_magicc7]
{
	hkboss_shot(CONTENT_SOLID);
};

void() hkboss_magicc7 = [161, hkboss_magicc8]
{
	hkboss_shot(CONTENT_EMPTY);
};

void() hkboss_magicc8 = [162, hkboss_magicc9]
{
	hkboss_shot(0);
};

void() hkboss_magicc9 = [163, hkboss_magicc10]
{
	hkboss_shot(1);
};

void() hkboss_magicc10 = [164, hkboss_magicc11]
{
	hkboss_shot(FL_SWIM);
};

void() hkboss_magicc11 = [165, hkboss_run1]
{
	hkboss_shot(MOVETYPE_WALK);
};

void() hkboss_char_a1 = [63, hkboss_char_a2]
{
	ai_charge(20);
};

void() hkboss_char_a2 = [64, hkboss_char_a3]
{
	ai_charge(25);
};

void() hkboss_char_a3 = [65, hkboss_char_a4]
{
	ai_charge(18);
};

void() hkboss_char_a4 = [66, hkboss_char_a5]
{
	ai_charge(FL_INWATER);
};

void() hkboss_char_a5 = [67, hkboss_char_a6]
{
	ai_charge(TEAM2);
};

void() hkboss_char_a6 = [68, hkboss_char_a7]
{
	ai_charge(20);
	ai_melee();
};

void() hkboss_char_a7 = [69, hkboss_char_a8]
{
	ai_charge(21);
	ai_melee();
};

void() hkboss_char_a8 = [70, hkboss_char_a9]
{
	ai_charge(13);
	ai_melee();
};

void() hkboss_char_a9 = [71, hkboss_char_a10]
{
	ai_charge(20);
	ai_melee();
};

void() hkboss_char_a10 = [72, hkboss_char_a11]
{
	ai_charge(20);
	ai_melee();
};

void() hkboss_char_a11 = [73, hkboss_char_a12]
{
	ai_charge(18);
	ai_melee();
};

void() hkboss_char_a12 = [74, hkboss_char_a13]
{
	ai_charge(FL_INWATER);
};

void() hkboss_char_a13 = [75, hkboss_char_a14]
{
	ai_charge(TEAM2);
};

void() hkboss_char_a14 = [76, hkboss_char_a15]
{
	ai_charge(25);
};

void() hkboss_char_a15 = [77, hkboss_char_a16]
{
	ai_charge(21);
};

void() hkboss_char_a16 = [78, hkboss_run1]
{
	ai_charge(13);
};

void() hkboss_char_b1 = [106, hkboss_char_b2]
{
	ai_charge(SVC_TEMPENTITY);
	ai_melee();
};

void() hkboss_char_b2 = [107, hkboss_char_b3]
{
	ai_charge(17);
	ai_melee();
};

void() hkboss_char_b3 = [108, hkboss_char_b4]
{
	ai_charge(STAT_TOTALMONSTERS);
	ai_melee();
};

void() hkboss_char_b4 = [109, hkboss_char_b5]
{
	ai_charge(22);
	ai_melee();
};

void() hkboss_char_b5 = [110, hkboss_char_b6]
{
	ai_charge(18);
	ai_melee();
};

void() hkboss_char_b6 = [111, hkboss_char_b7]
{
	ai_charge(FL_CLIENT);
	ai_melee();
};

void() hkboss_char_b7 = [106, hkboss_char_b8]
{
	ai_charge(SVC_TEMPENTITY);
	ai_melee();
};

void() hkboss_char_b8 = [107, hkboss_char_b9]
{
	ai_charge(17);
	ai_melee();
};

void() hkboss_char_b9 = [108, hkboss_char_b10]
{
	ai_charge(STAT_TOTALMONSTERS);
	ai_melee();
};

void() hkboss_char_b10 = [109, hkboss_char_b11]
{
	ai_charge(22);
	ai_melee();
};

void() hkboss_char_b11 = [110, hkboss_char_b12]
{
	ai_charge(18);
	ai_melee();
};

void() hkboss_char_b12 = [111, hkboss_char_b13]
{
	ai_charge(FL_CLIENT);
	ai_melee();
};

void() hkboss_char_b13 = [106, hkboss_char_b14]
{
	ai_charge(SVC_TEMPENTITY);
	ai_melee();
};

void() hkboss_char_b14 = [107, hkboss_char_b15]
{
	ai_charge(17);
	ai_melee();
};

void() hkboss_char_b15 = [108, hkboss_char_b16]
{
	ai_charge(STAT_TOTALMONSTERS);
	ai_melee();
};

void() hkboss_char_b16 = [109, hkboss_char_b17]
{
	ai_charge(22);
	ai_melee();
};

void() hkboss_char_b17 = [110, hkboss_char_b18]
{
	ai_charge(18);
	ai_melee();
};

void() hkboss_char_b18 = [111, hkboss_magicb1]
{
	ai_charge(FL_CLIENT);
};

void() hkboss_slice1 = [112, hkboss_slice2]
{
	ai_charge(MOVETYPE_FLYMISSILE);
};

void() hkboss_slice2 = [113, hkboss_slice3]
{
	ai_charge(MOVETYPE_TOSS);
};

void() hkboss_slice3 = [114, hkboss_slice4]
{
	ai_charge(13);
};

void() hkboss_slice4 = [115, hkboss_slice5]
{
	ai_charge(MOVETYPE_STEP);
};

void() hkboss_slice5 = [116, hkboss_slice6]
{
	ai_charge(MOVETYPE_PUSH);
	ai_melee();
};

void() hkboss_slice6 = [117, hkboss_slice7]
{
	ai_charge(CTF_CAPTURE_BONUS);
	ai_melee();
};

void() hkboss_slice7 = [118, hkboss_slice8]
{
	ai_charge(FL_CLIENT);
	ai_melee();
};

void() hkboss_slice8 = [119, hkboss_slice9]
{
	ai_charge(FL_SWIM);
	ai_melee();
};

void() hkboss_slice9 = [120, hkboss_slice10]
{
	ai_melee();
};

void() hkboss_slice10 = [121, hkboss_run1]
{
	ai_charge(MOVETYPE_WALK);
};

void() hkboss_smash1 = [122, hkboss_smash2]
{
	ai_charge(1);
};

void() hkboss_smash2 = [123, hkboss_smash3]
{
	ai_charge(13);
};

void() hkboss_smash3 = [124, hkboss_smash4]
{
	ai_charge(MOVETYPE_FLYMISSILE);
};

void() hkboss_smash4 = [125, hkboss_smash5]
{
	ai_charge(MOVETYPE_BOUNCEMISSILE);
};

void() hkboss_smash5 = [126, hkboss_smash6]
{
	ai_charge(MOVETYPE_BOUNCE);
	ai_melee();
};

void() hkboss_smash6 = [127, hkboss_smash7]
{
	ai_charge(MOVETYPE_PUSH);
	ai_melee();
};

void() hkboss_smash7 = [128, hkboss_smash8]
{
	ai_charge(STAT_TOTALMONSTERS);
	ai_melee();
};

void() hkboss_smash8 = [129, hkboss_smash9]
{
	ai_charge(FL_SWIM);
	ai_melee();
};

void() hkboss_smash9 = [130, hkboss_smash10]
{
	ai_charge(MOVETYPE_WALK);
	ai_melee();
};

void() hkboss_smash10 = [131, hkboss_smash11]
{
	ai_charge(0);
};

void() hkboss_smash11 = [132, hkboss_run1]
{
	ai_charge(0);
};

void() hkboss_watk1 = [133, hkboss_watk2]
{
	ai_charge(FL_SWIM);
};

void() hkboss_watk2 = [134, hkboss_watk3]
{
	ai_charge(0);
};

void() hkboss_watk3 = [135, hkboss_watk4]
{
	ai_charge(0);
};

void() hkboss_watk4 = [136, hkboss_watk5]
{
	ai_melee();
};

void() hkboss_watk5 = [137, hkboss_watk6]
{
	ai_melee();
};

void() hkboss_watk6 = [138, hkboss_watk7]
{
	ai_melee();
};

void() hkboss_watk7 = [139, hkboss_watk8]
{
	ai_charge(1);
};

void() hkboss_watk8 = [140, hkboss_watk9]
{
	ai_charge(MOVETYPE_STEP);
};

void() hkboss_watk9 = [141, hkboss_watk10]
{
	ai_charge(MOVETYPE_FLY);
};

void() hkboss_watk10 = [142, hkboss_watk11]
{
	ai_charge(MOVETYPE_WALK);
	ai_melee();
};

void() hkboss_watk11 = [143, hkboss_watk12]
{
	ai_charge(FL_SWIM);
	ai_melee();
};

void() hkboss_watk12 = [144, hkboss_watk13]
{
	ai_charge(FL_SWIM);
	ai_melee();
};

void() hkboss_watk13 = [145, hkboss_watk14]
{
	ai_charge(0);
};

void() hkboss_watk14 = [146, hkboss_watk15]
{
	ai_charge(0);
};

void() hkboss_watk15 = [147, hkboss_watk16]
{
	ai_charge(0);
};

void() hkboss_watk16 = [148, hkboss_watk17]
{
	ai_charge(1);
};

void() hkboss_watk17 = [149, hkboss_watk18]
{
	ai_charge(1);
	ai_melee();
};

void() hkboss_watk18 = [150, hkboss_watk19]
{
	ai_charge(MOVETYPE_WALK);
	ai_melee();
};

void() hkboss_watk19 = [151, hkboss_watk20]
{
	ai_charge(MOVETYPE_STEP);
	ai_melee();
};

void() hkboss_watk20 = [152, hkboss_watk21]
{
	ai_charge(MOVETYPE_TOSS);
};

void() hkboss_watk21 = [153, hkboss_watk22]
{
	ai_charge(MOVETYPE_PUSH);
};

void() hkboss_watk22 = [154, hkboss_run1]
{
	ai_charge(MOVETYPE_WALK);
};

void() hkboss_idle_sound = 
{
	if (random() < 0.2)
	{
		sound(self, CHAN_VOICE, "hknight/idle.wav", 1, ATTN_NORM);
	}
};

void(entity attacker, float damage) hkboss_pain = 
{
	if (self.pain_finished > time)
	{
		return;
	}
	sound(self, CHAN_VOICE, "hknight/pain1.wav", 1, ATTN_NORM);
	if (time - self.pain_finished > MOVETYPE_FLY)
	{
		hkboss_pain1();
		self.pain_finished = time + 1;
		return;
	}
	if (random() * SVC_INTERMISSION > damage)
	{
		return;
	}
	self.pain_finished = time + 1;
	hkboss_pain1();
};

void() hkboss_melee = 
{
	hkboss_type = hkboss_type + 1;
	sound(self, CHAN_WEAPON, "hknight/slash1.wav", 1, ATTN_NORM);
	if (hkboss_type == 1)
	{
		hkboss_slice1();
	}
	else
	{
		if (hkboss_type == FL_SWIM)
		{
			hkboss_smash1();
		}
		else
		{
			if (hkboss_type == MOVETYPE_WALK)
			{
				hkboss_watk1();
				hkboss_type = 0;
			}
		}
	}
};

void() hkboss_magic = 
{
	hkboss_magic_type = hkboss_magic_type + 1;
	if (hkboss_magic_type == 1)
	{
		hkboss_magica1();
	}
	else
	{
		if (hkboss_magic_type == FL_SWIM)
		{
			hkboss_magicb1();
		}
		else
		{
			if (hkboss_magic_type == MOVETYPE_WALK)
			{
				hkboss_magicc1();
				hkboss_magic_type = 0;
			}
		}
	}
};

void() monster_hkboss = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model2("progs/hkboss.mdl");
	precache_model2("progs/k_spike.mdl");
	precache_model2("progs/h_hellkn.mdl");
	precache_model2("progs/v_spike.mdl");
	precache_sound2("hknight/attack1.wav");
	precache_sound2("hknight/death1.wav");
	precache_sound2("hknight/pain1.wav");
	precache_sound2("hknight/sight1.wav");
	precache_sound("hknight/hit.wav");
	precache_sound2("hknight/slash1.wav");
	precache_sound2("hknight/idle.wav");
	precache_sound2("hknight/grunt.wav");
	precache_sound2("shalrath/attack2.wav");
	precache_sound("knight/sword1.wav");
	precache_sound("knight/sword2.wav");
	precache_sound2("items/protect3.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/hkboss.mdl");
	setsize(self, VEC_HULL_MIN, '16 16 40');
	self.health = 900;
	self.th_stand = hkboss_stand1;
	self.th_walk = hkboss_walk1;
	self.th_run = hkboss_run1;
	self.th_melee = hkboss_melee;
	self.th_missile = hkboss_magic;
	self.th_pain = hkboss_pain;
	self.th_die = hkboss_die;
	walkmonster_start();
};

