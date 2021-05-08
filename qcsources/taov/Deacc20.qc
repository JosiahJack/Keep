void() zombie_boss_stand1 = [0, zombie_boss_stand2]
{
	ai_stand();
};

void() zombie_boss_stand2 = [1, zombie_boss_stand3]
{
	if (random() < 0.010000)
	{
		if (random() < 0.5)
		{
			sound(self, CHAN_VOICE, "zombie/idle1.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
		}
		else
		{
			sound(self, CHAN_VOICE, "zombie/idle2.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
		}
	}
	ai_stand();
};

void() zombie_boss_stand3 = [2, zombie_boss_stand4]
{
	ai_stand();
};

void() zombie_boss_stand4 = [3, zombie_boss_stand5]
{
	ai_stand();
};

void() zombie_boss_stand5 = [4, zombie_boss_stand6]
{
	ai_stand();
};

void() zombie_boss_stand6 = [5, zombie_boss_stand7]
{
	ai_stand();
};

void() zombie_boss_stand7 = [6, zombie_boss_stand8]
{
	ai_stand();
};

void() zombie_boss_stand8 = [7, zombie_boss_stand9]
{
	ai_stand();
};

void() zombie_boss_stand9 = [8, zombie_boss_stand10]
{
	ai_stand();
};

void() zombie_boss_stand10 = [9, zombie_boss_stand11]
{
	ai_stand();
};

void() zombie_boss_stand11 = [10, zombie_boss_stand12]
{
	ai_stand();
};

void() zombie_boss_stand12 = [11, zombie_boss_stand13]
{
	ai_stand();
};

void() zombie_boss_stand13 = [12, zombie_boss_stand14]
{
	ai_stand();
};

void() zombie_boss_stand14 = [13, zombie_boss_stand15]
{
	ai_stand();
};

void() zombie_boss_stand15 = [14, zombie_boss_stand1]
{
	ai_stand();
};

void() zombie_boss_run1 = [15, zombie_boss_run2]
{
	ai_walk(TE_LIGHTNING1);
};

void() zombie_boss_run2 = [16, zombie_boss_run3]
{
	ai_walk(TE_LIGHTNING1);
};

void() zombie_boss_run3 = [17, zombie_boss_run4]
{
	ai_walk(TE_LIGHTNING1);
};

void() zombie_boss_run4 = [18, zombie_boss_run5]
{
	ai_walk(TE_LIGHTNING1);
};

void() zombie_boss_run5 = [19, zombie_boss_run6]
{
	ai_walk(TE_LIGHTNING1);
};

void() zombie_boss_run6 = [20, zombie_boss_run7]
{
	ai_walk(STATE_TOP);
};

void() zombie_boss_run7 = [21, zombie_boss_run8]
{
	ai_walk(STATE_TOP);
};

void() zombie_boss_run8 = [22, zombie_boss_run9]
{
	ai_walk(STATE_TOP);
};

void() zombie_boss_run9 = [23, zombie_boss_run10]
{
	ai_walk(STATE_TOP);
};

void() zombie_boss_run10 = [24, zombie_boss_run11]
{
	ai_walk(STATE_TOP);
};

void() zombie_boss_run11 = [25, zombie_boss_run12]
{
	ai_walk(TE_LIGHTNING1);
};

void() zombie_boss_run12 = [26, zombie_boss_run13]
{
	ai_walk(TE_LIGHTNING1);
};

void() zombie_boss_run13 = [27, zombie_boss_run14]
{
	ai_walk(STATE_TOP);
};

void() zombie_boss_run14 = [28, zombie_boss_run15]
{
	ai_walk(STATE_TOP);
};

void() zombie_boss_run15 = [29, zombie_boss_run16]
{
	ai_walk(STATE_TOP);
};

void() zombie_boss_run16 = [30, zombie_boss_run17]
{
	ai_walk(STATE_TOP);
};

void() zombie_boss_run17 = [31, zombie_boss_run18]
{
	ai_walk(STATE_TOP);
};

void() zombie_boss_run18 = [32, zombie_boss_run19]
{
	ai_walk(STATE_TOP);
};

void() zombie_boss_run19 = [33, zombie_boss_run1]
{
	ai_walk(STATE_TOP);
};

void() zombie_boss_atta1 = [34, zombie_boss_atta2]
{
};

void() zombie_boss_atta2 = [35, zombie_boss_atta3]
{
};

void() zombie_boss_atta3 = [36, zombie_boss_atta4]
{
};

void() zombie_boss_atta4 = [37, zombie_boss_atta5]
{
};

void() zombie_boss_atta5 = [38, zombie_boss_run1]
{
	Darkball(IT_RELIC5);
};

void() zombie_boss_attb1 = [39, zombie_boss_attb2]
{
};

void() zombie_boss_attb2 = [40, zombie_boss_attb3]
{
};

void() zombie_boss_attb3 = [41, zombie_boss_attb4]
{
};

void() zombie_boss_attb4 = [42, zombie_boss_attb5]
{
};

void() zombie_boss_attb5 = [43, zombie_boss_attb6]
{
};

void() zombie_boss_attb6 = [44, zombie_boss_attb7]
{
};

void() zombie_boss_attb7 = [45, zombie_boss_run1]
{
	Darkball(IT_RELIC5);
};

void() zombie_boss_attc1 = [46, zombie_boss_attc2]
{
};

void() zombie_boss_attc2 = [47, zombie_boss_attc3]
{
};

void() zombie_boss_attc3 = [48, zombie_boss_attc4]
{
};

void() zombie_boss_attc4 = [49, zombie_boss_attc5]
{
};

void() zombie_boss_attc5 = [50, zombie_boss_attc6]
{
};

void() zombie_boss_attc6 = [51, zombie_boss_attc7]
{
};

void() zombie_boss_attc7 = [52, zombie_boss_attc8]
{
	Darkball(IT_RELIC5);
};

void() zombie_boss_attc8 = [53, zombie_boss_run1]
{
};

void() zombie_boss_missile = 
{
	if (random() < 0.33)
	{
		zombie_boss_atta1();
	}
	else
	{
		if (random() < 0.66)
		{
			zombie_boss_attb1();
		}
		else
		{
			zombie_boss_attc1();
		}
	}
};

void() zombie_boss_paina1 = [54, zombie_boss_paina2]
{
	if (random() < 0.5)
	{
		sound(self, CHAN_VOICE, "zombie/pain1.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	}
	else
	{
		sound(self, CHAN_VOICE, "zombie/pain2.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	}
};

void() zombie_boss_paina2 = [55, zombie_boss_paina3]
{
};

void() zombie_boss_paina3 = [56, zombie_boss_paina4]
{
};

void() zombie_boss_paina4 = [57, zombie_boss_paina5]
{
};

void() zombie_boss_paina5 = [58, zombie_boss_paina6]
{
};

void() zombie_boss_paina6 = [59, zombie_boss_paina7]
{
};

void() zombie_boss_paina7 = [60, zombie_boss_paina8]
{
};

void() zombie_boss_paina8 = [61, zombie_boss_paina9]
{
};

void() zombie_boss_paina9 = [62, zombie_boss_run1]
{
};

void() zombie_boss_painb1 = [63, zombie_boss_painb2]
{
	if (random() < 0.5)
	{
		sound(self, CHAN_VOICE, "zombie/pain3.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	}
	else
	{
		sound(self, CHAN_VOICE, "zombie/pain4.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	}
};

void() zombie_boss_painb2 = [64, zombie_boss_painb3]
{
};

void() zombie_boss_painb3 = [65, zombie_boss_painb4]
{
};

void() zombie_boss_painb4 = [66, zombie_boss_painb5]
{
};

void() zombie_boss_painb5 = [67, zombie_boss_painb6]
{
};

void() zombie_boss_painb6 = [68, zombie_boss_painb7]
{
};

void() zombie_boss_painb7 = [69, zombie_boss_painb8]
{
};

void() zombie_boss_painb8 = [70, zombie_boss_painb9]
{
};

void() zombie_boss_painb9 = [71, zombie_boss_painb10]
{
};

void() zombie_boss_painb10 = [72, zombie_boss_painb11]
{
};

void() zombie_boss_painb11 = [73, zombie_boss_painb12]
{
};

void() zombie_boss_painb12 = [74, zombie_boss_painb13]
{
};

void() zombie_boss_painb13 = [75, zombie_boss_run1]
{
};

void() zombie_boss_pain = 
{
	if (random() < 0.5)
	{
		zombie_boss_paina1();
	}
	else
	{
		zombie_boss_painb1();
	}
	monster_pain(self.enemy);
};

void() zombie_boss_die1 = [76, zombie_boss_die2]
{
	monster_death();
};

void() zombie_boss_die2 = [77, zombie_boss_die3]
{
	monster_death();
};

void() zombie_boss_die3 = [78, zombie_boss_die4]
{
	monster_death();
};

void() zombie_boss_die4 = [79, zombie_boss_die5]
{
	monster_death();
};

void() zombie_boss_die5 = [80, zombie_boss_die6]
{
	monster_death();
};

void() zombie_boss_die6 = [81, zombie_boss_die7]
{
	monster_death();
};

void() zombie_boss_die7 = [82, zombie_boss_die8]
{
	monster_death();
};

void() zombie_boss_die8 = [83, zombie_boss_die9]
{
	monster_death();
};

void() zombie_boss_die9 = [84, zombie_boss_die10]
{
	monster_death();
};

void() zombie_boss_die10 = [85, zombie_boss_die11]
{
	monster_death();
};

void() zombie_boss_die11 = [86, zombie_boss_die12]
{
	monster_death();
};

void() zombie_boss_die12 = [87, zombie_boss_die12]
{
	if (self.flags & FL_ONGROUND)
	{
		sound(self, CHAN_BODY, "zombie/splat.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
		ThrowGib("progs/gib2.mdl");
		ThrowGib("progs/gib3.mdl");
		ThrowGib("progs/gib3.mdl");
		ThrowGib("progs/gib3.mdl");
		ThrowGib("progs/gib1.mdl");
		ThrowGib("progs/gib1.mdl");
		ThrowGib("progs/gib1.mdl");
		ThrowGib("progs/gib1.mdl");
		remove(self);
		return;
	}
	monster_death();
};

void() zombie_boss_die = 
{
	if (self.gaveexp != 1)
	{
		self.movetype = MOVETYPE_TOSS;
		self.avelocity = '300 300 0';
		self.gaveexp = 1;
		GiveExperience(98);
		sound(self, CHAN_VOICE, "zombie/death.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	}
	if (self.knockback != IT_RELIC2 && self.knockback != AS_MELEE)
	{
		self.velocity = no;
		self.flags = self.flags - (self.flags & FL_ONGROUND);
		self.velocity = self.velocity + TE_LIGHTNING3 * v_forward * IT_RELIC4;
		self.velocity = self.velocity + 90 * '0 0 3';
	}
	zombie_boss_die1();
};

void() zombie_boss_grabbed1 = [64, zombie_boss_grabbed2]
{
	self.grab_finished = time + 0.5;
};

void() zombie_boss_grabbed2 = [64, zombie_boss_grabbed2]
{
	if (self.grab_finished < time || self.grabbed == 0)
	{
		self.th_run();
		return;
	}
};

void() monster_zombie_boss = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/zombieb.mdl");
	precache_model("progs/darkball.mdl");
	precache_sound("spells/dbfire.wav");
	precache_sound("spells/dbhit.wav");
	precache_sound("zombie/idle1.wav");
	precache_sound("zombie/idle2.wav");
	precache_sound("zombie/pain1.wav");
	precache_sound("zombie/pain2.wav");
	precache_sound("zombie/pain3.wav");
	precache_sound("zombie/pain4.wav");
	precache_sound("zombie/smack.wav");
	precache_sound("zombie/splat.wav");
	precache_sound("zombie/death.wav");
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/zombieb.mdl");
	setsize(self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	if (difficulty < IT_RELIC2)
	{
		self.max_health = 225;
		self.health = 225;
	}
	else
	{
		self.max_health = 383;
		self.health = 383;
	}
	self.state = self.max_health / AS_MELEE;
	self.netname = "solid";
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_NOT;
	self.classname = "zombieboss";
	self.th_stand = zombie_boss_stand1;
	self.th_run = zombie_boss_run1;
	self.th_pain = zombie_boss_pain;
	self.th_die = zombie_boss_die;
	self.th_grab = zombie_boss_grabbed1;
	self.th_magic = zombie_boss_missile;
	spawn_shadow();
	enemy_start();
};

