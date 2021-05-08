void() knight_block1 = [68, knight_block1]
{
	if (!(self.enemy.owner))
	{
		return;
	}
	if (self.enemy.owner.attack_finished < time && (self.flags & FL_ONGROUND))
	{
		knight_run1();
		return;
	}
	self.block_finished = time + 0.15;
	self.nextthink = time + 0.1;
};

void() knight_yell = 
{
	local float r;
	local float h;
	h = random();
	r = random();
	if (h < 0.4 && self.voice_finished < time)
	{
		if (r < 0.35)
		{
			sound(self, CHAN_VOICE, "knight/yell1.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
		}
		else
		{
			if (r < 0.65)
			{
				sound(self, CHAN_VOICE, "knight/yell2.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
			}
			else
			{
				sound(self, CHAN_VOICE, "knight/yell3.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
			}
		}
		self.voice_finished = time + 0.6;
	}
};

void() knight_stand1 = [0, knight_stand2]
{
	ai_stand();
};

void() knight_stand2 = [1, knight_stand3]
{
	ai_stand();
};

void() knight_stand3 = [2, knight_stand4]
{
	ai_stand();
};

void() knight_stand4 = [3, knight_stand5]
{
	ai_stand();
};

void() knight_stand5 = [4, knight_stand6]
{
	ai_stand();
};

void() knight_stand6 = [5, knight_stand7]
{
	ai_stand();
};

void() knight_stand7 = [6, knight_stand8]
{
	ai_stand();
};

void() knight_stand8 = [7, knight_stand9]
{
	ai_stand();
};

void() knight_stand9 = [8, knight_stand1]
{
	ai_stand();
};

void() knight_walk1 = [52, knight_walk2]
{
	ai_walk(IT_RELIC3);
};

void() knight_walk2 = [53, knight_walk3]
{
	ai_walk(IT_RELIC3);
};

void() knight_walk3 = [54, knight_walk4]
{
	ai_walk(IT_RELIC3);
};

void() knight_walk4 = [55, knight_walk5]
{
	ai_walk(IT_RELIC3);
};

void() knight_walk5 = [56, knight_walk6]
{
	ai_walk(IT_RELIC3);
};

void() knight_walk6 = [57, knight_walk7]
{
	ai_walk(IT_RELIC3);
};

void() knight_walk7 = [58, knight_walk8]
{
	ai_walk(IT_RELIC3);
};

void() knight_walk8 = [59, knight_walk9]
{
	ai_walk(IT_RELIC3);
};

void() knight_walk9 = [60, knight_walk10]
{
	ai_walk(IT_RELIC3);
};

void() knight_walk10 = [61, knight_walk11]
{
	ai_walk(IT_RELIC3);
};

void() knight_walk11 = [62, knight_walk12]
{
	ai_walk(IT_RELIC3);
};

void() knight_walk12 = [63, knight_walk13]
{
	ai_walk(IT_RELIC3);
};

void() knight_walk13 = [64, knight_walk14]
{
	ai_walk(IT_RELIC3);
};

void() knight_walk14 = [65, knight_walk1]
{
	ai_walk(IT_RELIC3);
};

void() knight_run1 = [9, knight_run2]
{
	ai_walk(IT_RELIC4);
};

void() knight_run2 = [10, knight_run3]
{
	ai_walk(IT_RELIC4);
};

void() knight_run3 = [11, knight_run4]
{
	ai_walk(IT_RELIC4);
};

void() knight_run4 = [12, knight_run5]
{
	ai_walk(IT_RELIC4);
};

void() knight_run5 = [13, knight_run6]
{
	ai_walk(IT_RELIC4);
};

void() knight_run6 = [14, knight_run7]
{
	ai_walk(IT_RELIC4);
};

void() knight_run7 = [15, knight_run8]
{
	ai_walk(IT_RELIC4);
};

void() knight_run8 = [16, knight_run1]
{
	ai_walk(IT_RELIC4);
};

void() knight_atk1 = [44, knight_atk2]
{
	knight_yell();
	sound(self, CHAN_WEAPON, "knight/sword1.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
};

void() knight_atk2 = [45, knight_atk3]
{
};

void() knight_atk3 = [46, knight_atk4]
{
};

void() knight_atk4 = [47, knight_atk5]
{
	FireMelee(IT_RELIC3, TE_LAVASPLASH, STATE_TOP, 45, STATE_TOP, STATE_TOP, STATE_TOP);
};

void() knight_atk5 = [48, knight_atk6]
{
};

void() knight_atk6 = [49, knight_atk7]
{
};

void() knight_atk7 = [50, knight_atk8]
{
};

void() knight_atk8 = [51, knight_walk1]
{
};

void() knight_atkb1 = [17, knight_atkb2]
{
	ai_forward(TE_LIGHTNING2);
	knight_yell();
	frameskip(0.07);
};

void() knight_atkb2 = [18, knight_atkb3]
{
	ai_forward(TE_LIGHTNING2);
	frameskip(0.07);
};

void() knight_atkb3 = [19, knight_atkb4]
{
	ai_forward(TE_LIGHTNING2);
	frameskip(0.07);
};

void() knight_atkb4 = [20, knight_atkb5]
{
	ai_forward(TE_LIGHTNING2);
	frameskip(0.07);
};

void() knight_atkb5 = [21, knight_atkb6]
{
	ai_forward(TE_LIGHTNING2);
	sound(self, CHAN_WEAPON, "knight/sword1.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	frameskip(0.07);
};

void() knight_atkb6 = [22, knight_atkb7]
{
	FireMelee(IT_RELIC4, TE_LAVASPLASH, AS_MELEE, 45, TE_LIGHTNING1, STATE_TOP, STATE_TOP);
	ai_forward(TE_LIGHTNING2);
	frameskip(0.07);
};

void() knight_atkb7 = [23, knight_atkb8]
{
	ai_forward(TE_LIGHTNING2);
	frameskip(0.07);
};

void() knight_atkb8 = [24, knight_atkb9]
{
	ai_forward(TE_LIGHTNING2);
	frameskip(0.07);
};

void() knight_atkb9 = [25, knight_atkb10]
{
	ai_forward(TE_LIGHTNING2);
	frameskip(0.07);
};

void() knight_atkb10 = [26, knight_atkb11]
{
	ai_forward(TE_LIGHTNING2);
	frameskip(0.07);
};

void() knight_atkb11 = [27, knight_walk1]
{
	ai_forward(TE_LIGHTNING2);
	frameskip(0.07);
};

void() knight_pain1 = [28, knight_pain2]
{
	self.nextthink = time + 0.3;
};

void() knight_pain2 = [29, knight_pain3]
{
};

void() knight_pain3 = [30, knight_walk1]
{
};

void() knight_painb1 = [31, knight_painb2]
{
};

void() knight_painb2 = [32, knight_painb3]
{
};

void() knight_painb3 = [33, knight_painb4]
{
};

void() knight_painb4 = [34, knight_painb5]
{
};

void() knight_painb5 = [35, knight_painb6]
{
};

void() knight_painb6 = [36, knight_painb7]
{
};

void() knight_painb7 = [37, knight_painb8]
{
};

void() knight_painb8 = [38, knight_painb9]
{
};

void() knight_painb9 = [39, knight_painb10]
{
};

void() knight_painb10 = [40, knight_painb11]
{
};

void() knight_painb11 = [41, knight_walk1]
{
};

void() knight_pain = 
{
	local float r;
	local float h;
	r = h = random();
	monster_pain(self.enemy);
	if (h < 0.35)
	{
		sound(self, CHAN_VOICE, "knight/pain1.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	}
	else
	{
		if (h < 0.75)
		{
			sound(self, CHAN_VOICE, "knight/pain2.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
		}
		else
		{
			sound(self, CHAN_VOICE, "knight/pain3.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
		}
	}
	if (r < 0.35)
	{
		knight_pain1();
	}
	else
	{
		knight_painb1();
	}
};

void() knight_die1 = [75, knight_die2]
{
	monster_death();
};

void() knight_die2 = [76, knight_die3]
{
	monster_death();
};

void() knight_die3 = [77, knight_die4]
{
	monster_death();
};

void() knight_die4 = [78, knight_die5]
{
	monster_death();
};

void() knight_die5 = [79, knight_die6]
{
	monster_death();
};

void() knight_die6 = [80, knight_die7]
{
	monster_death();
};

void() knight_die7 = [81, knight_die8]
{
	monster_death();
};

void() knight_die8 = [82, knight_die9]
{
	monster_death();
};

void() knight_die9 = [83, knight_die10]
{
	monster_death();
};

void() knight_die10 = [84, knight_die10]
{
	monster_death();
};

void() knight_dieb1 = [85, knight_dieb2]
{
	monster_death();
};

void() knight_dieb2 = [86, knight_dieb3]
{
	monster_death();
};

void() knight_dieb3 = [87, knight_dieb4]
{
	monster_death();
};

void() knight_dieb4 = [88, knight_dieb5]
{
	monster_death();
};

void() knight_dieb5 = [89, knight_dieb6]
{
	monster_death();
};

void() knight_dieb6 = [90, knight_dieb7]
{
	monster_death();
};

void() knight_dieb7 = [91, knight_dieb8]
{
	monster_death();
};

void() knight_dieb8 = [92, knight_dieb9]
{
	monster_death();
};

void() knight_dieb9 = [93, knight_dieb10]
{
	monster_death();
};

void() knight_dieb10 = [94, knight_dieb11]
{
	monster_death();
};

void() knight_dieb11 = [95, knight_dieb11]
{
	monster_death();
};

void() knight_die = 
{
	if (self.gaveexp != 1)
	{
		self.gaveexp = 1;
		self.movetype = MOVETYPE_TOSS;
		self.avelocity = '300 300 0';
		GiveExperience(SVC_UPDATEFRAGS);
		sound(self, CHAN_VOICE, "knight/death.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	}
	if (self.damage_type == TE_LIGHTNING1)
	{
		sound(self, CHAN_BODY, "misc/guts.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
		ThrowBodyPart("progs/knig_c1.mdl");
		ThrowBodyPart("progs/knig_c2.mdl");
		remove(self);
		return;
	}
	if (self.knockback != IT_RELIC2 && self.knockback != AS_MELEE)
	{
		self.velocity = no;
		self.flags = self.flags - (self.flags & FL_ONGROUND);
		self.velocity = self.velocity + TE_LIGHTNING3 * v_forward * IT_RELIC4;
		self.velocity = self.velocity + 90 * '0 0 3';
	}
	if (random() < 0.5)
	{
		knight_die1();
	}
	else
	{
		knight_dieb1();
	}
};

void() knight_kneel1 = [70, knight_kneel2]
{
};

void() knight_kneel2 = [69, knight_kneel3]
{
};

void() knight_kneel3 = [68, knight_kneel4]
{
};

void() knight_kneel4 = [67, knight_kneel5]
{
};

void() knight_kneel5 = [66, knight_walk1]
{
};

void() knight_jump = [13, knight_jump]
{
	if (self.flags & FL_ONGROUND)
	{
		knight_kneel1();
	}
};

void() knight_grabbed1 = [28, knight_grabbed2]
{
	self.grab_finished = time + 0.5;
};

void() knight_grabbed2 = [28, knight_grabbed2]
{
	if (self.grab_finished < time || self.grabbed == 0)
	{
		self.th_walk();
		return;
	}
};

void() monster_knight = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_sound("knight/death.wav");
	precache_sound("knight/pain1.wav");
	precache_sound("knight/pain2.wav");
	precache_sound("knight/pain3.wav");
	precache_sound("knight/sword1.wav");
	precache_sound("knight/yell1.wav");
	precache_sound("knight/yell2.wav");
	precache_sound("knight/yell3.wav");
	precache_model("progs/knight.mdl");
	precache_model("progs/knig_c1.mdl");
	precache_model("progs/knig_c2.mdl");
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/knight.mdl");
	setsize(self, VEC_HULL_MIN, '16 16 40');
	if (difficulty < IT_RELIC2)
	{
		self.health = 100;
	}
	else
	{
		self.health = 150;
	}
	self.netname = "solid";
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_NOT;
	self.classname = "knight";
	self.th_stand = knight_stand1;
	self.th_walk = knight_walk1;
	self.th_run = knight_run1;
	self.th_melee = knight_atk1;
	self.th_missile = knight_atkb1;
	self.th_pain = knight_pain;
	self.th_grab = knight_grabbed1;
	self.th_die = knight_die;
	self.th_jump = knight_jump;
	self.th_block = knight_block1;
	if (!(self.ai_blockfreq))
	{
		if (difficulty == STATE_TOP)
		{
			self.ai_blockfreq = 0.010000;
		}
		else
		{
			if (difficulty == PLAT_LOW_TRIGGER)
			{
				self.ai_blockfreq = 0.05;
			}
			else
			{
				self.ai_blockfreq = 0.1;
			}
		}
	}
	spawn_shadow();
	enemy_start();
};

