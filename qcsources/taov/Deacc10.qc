void() ghoul_stand1 = [0, ghoul_stand2]
{
	ai_stand();
};

void() ghoul_stand2 = [1, ghoul_stand3]
{
	ai_stand();
};

void() ghoul_stand3 = [2, ghoul_stand4]
{
	ai_stand();
};

void() ghoul_stand4 = [3, ghoul_stand5]
{
	ai_stand();
};

void() ghoul_stand5 = [4, ghoul_stand6]
{
	ai_stand();
};

void() ghoul_stand6 = [5, ghoul_stand7]
{
	ai_stand();
};

void() ghoul_stand7 = [6, ghoul_stand1]
{
	ai_stand();
};

void() ghoul_rise1 = [35, ghoul_rise1]
{
	self.takedamage = DAMAGE_NO;
	ai_stand();
	if (self.enemy)
	{
		ghoul_rise2();
	}
};

void() ghoul_rise2 = [36, ghoul_rise3]
{
	particle(self.origin - v_up * IT_RELIC5, no, SVC_PARTICLE, SVC_SIGNONNUM);
};

void() ghoul_rise3 = [37, ghoul_rise4]
{
	particle(self.origin - v_up * IT_RELIC5, no, SVC_PARTICLE, SVC_SIGNONNUM);
};

void() ghoul_rise4 = [38, ghoul_rise5]
{
	particle(self.origin - v_up * IT_RELIC5, no, SVC_PARTICLE, SVC_SIGNONNUM);
};

void() ghoul_rise5 = [39, ghoul_rise6]
{
	particle(self.origin - v_up * IT_RELIC5, no, SVC_PARTICLE, SVC_SIGNONNUM);
};

void() ghoul_rise6 = [40, ghoul_rise7]
{
	particle(self.origin - v_up * IT_RELIC5, no, SVC_PARTICLE, SVC_SIGNONNUM);
};

void() ghoul_rise7 = [41, ghoul_rise8]
{
	particle(self.origin - v_up * IT_RELIC5, no, SVC_PARTICLE, SVC_SIGNONNUM);
};

void() ghoul_rise8 = [42, ghoul_rise9]
{
	particle(self.origin - v_up * IT_RELIC5, no, SVC_PARTICLE, SVC_SIGNONNUM);
};

void() ghoul_rise9 = [43, ghoul_rise10]
{
	particle(self.origin - v_up * IT_RELIC5, no, SVC_PARTICLE, SVC_SIGNONNUM);
};

void() ghoul_rise10 = [44, ghoul_rise11]
{
	particle(self.origin - v_up * IT_RELIC5, no, SVC_PARTICLE, SVC_SIGNONNUM);
};

void() ghoul_rise11 = [45, ghoul_rise12]
{
	particle(self.origin - v_up * IT_RELIC5, no, SVC_PARTICLE, SVC_SIGNONNUM);
};

void() ghoul_rise12 = [46, ghoul_rise13]
{
	particle(self.origin - v_up * IT_RELIC5, no, SVC_PARTICLE, SVC_SIGNONNUM);
};

void() ghoul_rise13 = [47, ghoul_rise14]
{
	particle(self.origin - v_up * IT_RELIC5, no, SVC_PARTICLE, SVC_SIGNONNUM);
};

void() ghoul_rise14 = [48, ghoul_rise15]
{
	particle(self.origin - v_up * IT_RELIC5, no, SVC_PARTICLE, SVC_SIGNONNUM);
};

void() ghoul_rise15 = [49, ghoul_rise16]
{
	particle(self.origin - v_up * IT_RELIC5, no, SVC_PARTICLE, SVC_SIGNONNUM);
};

void() ghoul_rise16 = [50, ghoul_stand1]
{
	self.th_stand = ghoul_stand1;
	particle(self.origin - v_up * IT_RELIC5, no, SVC_PARTICLE, SVC_SIGNONNUM);
	spawn_shadow();
};

void() ghoul_walk1 = [7, ghoul_walk2]
{
	self.takedamage = DAMAGE_AIM;
	ai_walk(IT_RELIC2);
};

void() ghoul_walk2 = [8, ghoul_walk3]
{
	ai_walk(IT_RELIC2);
};

void() ghoul_walk3 = [9, ghoul_walk4]
{
	ai_walk(IT_RELIC2);
};

void() ghoul_walk4 = [10, ghoul_walk5]
{
	ai_walk(IT_RELIC2);
};

void() ghoul_walk5 = [11, ghoul_walk6]
{
	ai_walk(IT_RELIC2);
};

void() ghoul_walk6 = [12, ghoul_walk7]
{
	ai_walk(IT_RELIC2);
};

void() ghoul_walk7 = [13, ghoul_walk8]
{
	ai_walk(IT_RELIC2);
};

void() ghoul_walk8 = [14, ghoul_walk9]
{
	ai_walk(IT_RELIC2);
};

void() ghoul_walk9 = [15, ghoul_walk10]
{
	ai_walk(TE_LIGHTNING1);
};

void() ghoul_walk10 = [16, ghoul_walk11]
{
	ai_walk(IT_RELIC4);
};

void() ghoul_walk11 = [17, ghoul_walk12]
{
	ai_walk(IT_RELIC2);
};

void() ghoul_walk12 = [18, ghoul_walk1]
{
	ai_walk(IT_RELIC2);
};

void() ghoul_atk1 = [19, ghoul_atk2]
{
};

void() ghoul_atk2 = [20, ghoul_atk3]
{
};

void() ghoul_atk3 = [21, ghoul_atk4]
{
	FireMelee(IT_RELIC2, TE_LIGHTNING1, STATE_TOP, SVC_SIGNONNUM, PLAT_LOW_TRIGGER, STATE_TOP, STATE_TOP);
};

void() ghoul_atk4 = [22, ghoul_atk5]
{
};

void() ghoul_atk5 = [23, ghoul_atk6]
{
};

void() ghoul_atk6 = [24, ghoul_atk7]
{
};

void() ghoul_atk7 = [25, ghoul_atk8]
{
};

void() ghoul_atk8 = [26, ghoul_walk1]
{
	FireMelee(IT_RELIC2, TE_LIGHTNING1, STATE_TOP, SVC_SIGNONNUM, PLAT_LOW_TRIGGER, STATE_TOP, STATE_TOP);
};

void() ghoul_die1 = [27, ghoul_die2]
{
	monster_death();
	walkmove(self.angles_y + 180, TE_WIZSPIKE);
};

void() ghoul_die2 = [28, ghoul_die3]
{
	monster_death();
	walkmove(self.angles_y + 180, TE_WIZSPIKE);
};

void() ghoul_die3 = [29, ghoul_die4]
{
	monster_death();
	walkmove(self.angles_y + 180, TE_WIZSPIKE);
};

void() ghoul_die4 = [30, ghoul_die5]
{
	monster_death();
	walkmove(self.angles_y + 180, TE_WIZSPIKE);
};

void() ghoul_die5 = [31, ghoul_die6]
{
	monster_death();
	walkmove(self.angles_y + 180, TE_WIZSPIKE);
};

void() ghoul_die6 = [32, ghoul_die7]
{
	monster_death();
	walkmove(self.angles_y + 180, TE_WIZSPIKE);
};

void() ghoul_die7 = [33, ghoul_die8]
{
	monster_death();
	walkmove(self.angles_y + 180, TE_WIZSPIKE);
};

void() ghoul_die8 = [34, ghoul_die8]
{
	monster_death();
};

void() ghoul_grabbed1 = [0, ghoul_grabbed2]
{
	self.grab_finished = time + 0.5;
};

void() ghoul_grabbed2 = [0, ghoul_grabbed2]
{
	if (self.grab_finished < time || self.grabbed == 0)
	{
		self.th_run();
		return;
	}
};

void() ghoul_die = 
{
	if (self.gaveexp != 1)
	{
		sound(self, CHAN_VOICE, "ghoul/death.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
		GiveExperience(SVC_SPAWNSTATIC);
		self.movetype = MOVETYPE_TOSS;
		self.gaveexp = 1;
	}
	if (self.knockback != IT_RELIC2 && self.knockback != AS_MELEE)
	{
		self.velocity = no;
	}
	ghoul_die1();
};

void() ghoul_pain = 
{
	sound(self, CHAN_VOICE, "ghoul/pain.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	monster_pain(self.enemy);
};

void() monster_ghoul = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/ghoul.mdl");
	precache_sound("ghoul/pain.wav");
	precache_sound("ghoul/death.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/ghoul.mdl");
	if (difficulty < IT_RELIC2)
	{
		self.health = 115;
	}
	else
	{
		self.health = 173;
	}
	self.netname = "solid";
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_NOT;
	self.classname = "ghoul";
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.th_stand = ghoul_rise1;
	self.th_run = ghoul_walk1;
	self.th_pain = ghoul_pain;
	self.th_die = ghoul_die;
	self.th_melee = ghoul_atk1;
	self.th_grab = ghoul_grabbed1;
	enemy_start();
};

