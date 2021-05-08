void() enfly_stand1 = [0, enfly_stand2]
{
	ai_stand();
};

void() enfly_stand2 = [1, enfly_stand3]
{
	ai_stand();
};

void() enfly_stand3 = [2, enfly_stand4]
{
	ai_stand();
};

void() enfly_stand4 = [3, enfly_stand5]
{
	ai_stand();
};

void() enfly_stand5 = [4, enfly_stand6]
{
	ai_stand();
};

void() enfly_stand6 = [5, enfly_stand7]
{
	ai_stand();
};

void() enfly_stand7 = [6, enfly_stand1]
{
	ai_stand();
};

void() enfly_walk1 = [7, enfly_walk2]
{
	if (random() < 0.2)
	{
		sound(self, CHAN_VOICE, "enforcer/idle1.wav", SPAWN_CRUCIFIED, ATTN_IDLE);
	}
	ai_walk(SPAWNFLAG_LASER);
};

void() enfly_walk2 = [8, enfly_walk3]
{
	ai_walk(TE_LIGHTNING2);
};

void() enfly_walk3 = [9, enfly_walk4]
{
	ai_walk(TE_LIGHTNING2);
};

void() enfly_walk4 = [10, enfly_walk5]
{
	ai_walk(TE_LIGHTNING2);
};

void() enfly_walk5 = [11, enfly_walk6]
{
	ai_walk(TE_LIGHTNING2);
};

void() enfly_walk6 = [12, enfly_walk7]
{
	ai_walk(TE_LIGHTNING2);
};

void() enfly_walk7 = [13, enfly_walk8]
{
	ai_walk(TE_LIGHTNING2);
};

void() enfly_walk8 = [14, enfly_walk9]
{
	ai_walk(TE_LIGHTNING2);
};

void() enfly_walk9 = [15, enfly_walk10]
{
	ai_walk(TE_LIGHTNING2);
};

void() enfly_walk10 = [16, enfly_walk11]
{
	ai_walk(TE_LIGHTNING2);
};

void() enfly_walk11 = [17, enfly_walk12]
{
	ai_walk(TE_LIGHTNING2);
};

void() enfly_walk12 = [18, enfly_walk13]
{
	ai_walk(TE_LIGHTNING2);
};

void() enfly_walk13 = [19, enfly_walk14]
{
	ai_walk(TE_LIGHTNING2);
};

void() enfly_walk14 = [20, enfly_walk15]
{
	ai_walk(TE_LIGHTNING2);
};

void() enfly_walk15 = [21, enfly_walk16]
{
	ai_walk(TE_LIGHTNING2);
};

void() enfly_walk16 = [22, enfly_walk1]
{
	ai_walk(TE_LIGHTNING2);
};

void() enfly_run1 = [23, enfly_run2]
{
	if (random() < 0.2)
	{
		sound(self, CHAN_VOICE, "enforcer/idle1.wav", SPAWN_CRUCIFIED, ATTN_IDLE);
	}
	ai_run(18);
};

void() enfly_run2 = [24, enfly_run3]
{
	ai_run(SECRET_YES_SHOOT);
};

void() enfly_run3 = [25, enfly_run4]
{
	ai_run(SECRET_YES_SHOOT);
};

void() enfly_run4 = [26, enfly_run5]
{
	ai_run(SECRET_YES_SHOOT);
};

void() enfly_run5 = [27, enfly_run6]
{
	ai_run(SECRET_YES_SHOOT);
};

void() enfly_run6 = [28, enfly_run7]
{
	ai_run(SECRET_YES_SHOOT);
};

void() enfly_run7 = [29, enfly_run8]
{
	ai_run(SECRET_YES_SHOOT);
};

void() enfly_run8 = [30, enfly_run1]
{
	ai_run(SECRET_YES_SHOOT);
};

void() enfly_atk1 = [31, enfly_atk2]
{
	ai_face();
};

void() enfly_atk2 = [32, enfly_atk3]
{
	ai_face();
};

void() enfly_atk3 = [33, enfly_atk4]
{
	ai_face();
};

void() enfly_atk4 = [34, enfly_atk5]
{
	ai_face();
};

void() enfly_atk5 = [35, enfly_atk6]
{
	ai_face();
};

void() enfly_atk6 = [36, enfly_atk7]
{
	enforcer_fire();
};

void() enfly_atk7 = [37, enfly_atk8]
{
	ai_face();
};

void() enfly_atk8 = [38, enfly_atk9]
{
	ai_face();
};

void() enfly_atk9 = [35, enfly_atk10]
{
	ai_face();
};

void() enfly_atk10 = [36, enfly_atk11]
{
	enforcer_fire();
};

void() enfly_atk11 = [37, enfly_atk12]
{
	ai_face();
};

void() enfly_atk12 = [38, enfly_atk13]
{
	ai_face();
};

void() enfly_atk13 = [39, enfly_atk14]
{
	ai_face();
};

void() enfly_atk14 = [40, enfly_run1]
{
	ai_face();
	SUB_CheckRefire(enfly_atk1);
};

void() enfly_paina1 = [66, enfly_paina2]
{
};

void() enfly_paina2 = [67, enfly_paina3]
{
};

void() enfly_paina3 = [68, enfly_paina4]
{
};

void() enfly_paina4 = [69, enfly_run1]
{
};

void() enfly_painb1 = [70, enfly_painb2]
{
};

void() enfly_painb2 = [71, enfly_painb3]
{
};

void() enfly_painb3 = [72, enfly_painb4]
{
};

void() enfly_painb4 = [73, enfly_painb5]
{
};

void() enfly_painb5 = [74, enfly_run1]
{
};

void() enfly_painc1 = [75, enfly_painc2]
{
};

void() enfly_painc2 = [76, enfly_painc3]
{
};

void() enfly_painc3 = [77, enfly_painc4]
{
};

void() enfly_painc4 = [78, enfly_painc5]
{
};

void() enfly_painc5 = [79, enfly_painc6]
{
};

void() enfly_painc6 = [80, enfly_painc7]
{
};

void() enfly_painc7 = [81, enfly_painc8]
{
};

void() enfly_painc8 = [82, enfly_run1]
{
};

void() enfly_paind1 = [83, enfly_paind2]
{
};

void() enfly_paind2 = [84, enfly_paind3]
{
};

void() enfly_paind3 = [85, enfly_paind4]
{
};

void() enfly_paind4 = [86, enfly_paind5]
{
	ai_painforward(SPAWNFLAG_LASER);
};

void() enfly_paind5 = [87, enfly_paind6]
{
	ai_painforward(SPAWN_CRUCIFIED);
};

void() enfly_paind6 = [88, enfly_paind7]
{
};

void() enfly_paind7 = [89, enfly_paind8]
{
};

void() enfly_paind8 = [90, enfly_paind9]
{
};

void() enfly_paind9 = [91, enfly_paind10]
{
};

void() enfly_paind10 = [92, enfly_paind11]
{
};

void() enfly_paind11 = [93, enfly_paind12]
{
	ai_painforward(SPAWN_CRUCIFIED);
};

void() enfly_paind12 = [94, enfly_paind13]
{
	ai_painforward(SPAWN_CRUCIFIED);
};

void() enfly_paind13 = [95, enfly_paind14]
{
	ai_painforward(SPAWN_CRUCIFIED);
};

void() enfly_paind14 = [96, enfly_paind15]
{
};

void() enfly_paind15 = [97, enfly_paind16]
{
};

void() enfly_paind16 = [98, enfly_paind17]
{
	ai_pain(SPAWN_CRUCIFIED);
};

void() enfly_paind17 = [99, enfly_paind18]
{
	ai_pain(SPAWN_CRUCIFIED);
};

void() enfly_paind18 = [100, enfly_paind19]
{
};

void() enfly_paind19 = [101, enfly_run1]
{
};

void() enfly_die1 = [41, enfly_die2]
{
};

void() enfly_die2 = [42, enfly_die3]
{
};

void() enfly_die3 = [43, enfly_die4]
{
	self.solid = SOLID_NOT;
	self.ammo_cells = TE_LIGHTNING1;
	DropBackpack();
};

void() enfly_die4 = [44, enfly_die5]
{
	ai_forward(14);
};

void() enfly_die5 = [45, enfly_die6]
{
	ai_forward(SPAWNFLAG_LASER);
};

void() enfly_die6 = [46, enfly_die7]
{
};

void() enfly_die7 = [47, enfly_die8]
{
};

void() enfly_die8 = [48, enfly_die9]
{
};

void() enfly_die9 = [49, enfly_die10]
{
	ai_forward(AS_MELEE);
};

void() enfly_die10 = [50, enfly_die11]
{
	ai_forward(TE_LIGHTNING1);
};

void() enfly_die11 = [51, enfly_die12]
{
	ai_forward(TE_LIGHTNING1);
};

void() enfly_die12 = [52, enfly_die13]
{
	ai_forward(TE_LIGHTNING1);
};

void() enfly_die13 = [53, enfly_die14]
{
};

void() enfly_die14 = [54, enfly_die14]
{
};

void() enfly_fdie1 = [55, enfly_fdie2]
{
};

void() enfly_fdie2 = [56, enfly_fdie3]
{
};

void() enfly_fdie3 = [57, enfly_fdie4]
{
	self.solid = SOLID_NOT;
	self.ammo_cells = TE_LIGHTNING1;
	DropBackpack();
};

void() enfly_fdie4 = [58, enfly_fdie5]
{
};

void() enfly_fdie5 = [59, enfly_fdie6]
{
};

void() enfly_fdie6 = [60, enfly_fdie7]
{
};

void() enfly_fdie7 = [61, enfly_fdie8]
{
};

void() enfly_fdie8 = [62, enfly_fdie9]
{
};

void() enfly_fdie9 = [63, enfly_fdie10]
{
};

void() enfly_fdie10 = [64, enfly_fdie11]
{
};

void() enfly_fdie11 = [65, enfly_fdie11]
{
};

void(entity attacker, float damage) enfly_pain = 
{
	local float r;
	r = random();
	if (self.pain_finished > time)
	{
		return;
	}
	if (r < 0.5)
	{
		sound(self, CHAN_VOICE, "enforcer/pain1.wav", SPAWN_CRUCIFIED, ATTN_NORM);
	}
	else
	{
		sound(self, CHAN_VOICE, "enforcer/pain2.wav", SPAWN_CRUCIFIED, ATTN_NORM);
	}
	if (r < 0.2)
	{
		self.pain_finished = time + SPAWN_CRUCIFIED;
		enfly_paina1();
	}
	else
	{
		if (r < 0.4)
		{
			self.pain_finished = time + SPAWN_CRUCIFIED;
			enfly_painb1();
		}
		else
		{
			if (r < 0.7)
			{
				self.pain_finished = time + SPAWN_CRUCIFIED;
				enfly_painc1();
			}
			else
			{
				self.pain_finished = time + SPAWNFLAG_LASER;
				enfly_paind1();
			}
		}
	}
};

void() enfly_die = 
{
	if (self.health < -35)
	{
		sound(self, CHAN_VOICE, "player/udeath.wav", SPAWN_CRUCIFIED, ATTN_NORM);
		ThrowHead("progs/h_mega.mdl", self.health);
		ThrowGib("progs/gib1.mdl", self.health);
		ThrowGib("progs/gib2.mdl", self.health);
		ThrowGib("progs/gib3.mdl", self.health);
		return;
	}
	sound(self, CHAN_VOICE, "enforcer/death1.wav", SPAWN_CRUCIFIED, ATTN_NORM);
	self.velocity_x = -200 + 400 * random();
	self.velocity_y = -200 + 400 * random();
	self.velocity_z = 100 + 100 * random();
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	if (random() > 0.5)
	{
		enfly_die1();
	}
	else
	{
		enfly_fdie1();
	}
};

void() monster_enforcerfly = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model2("progs/enforcef.mdl");
	precache_model2("progs/h_mega.mdl");
	precache_model2("progs/laser.mdl");
	precache_sound2("enforcer/death1.wav");
	precache_sound2("enforcer/enfire.wav");
	precache_sound2("enforcer/enfstop.wav");
	precache_sound2("enforcer/idle1.wav");
	precache_sound2("enforcer/pain1.wav");
	precache_sound2("enforcer/pain2.wav");
	precache_sound2("enforcer/sight1.wav");
	precache_sound2("enforcer/sight2.wav");
	precache_sound2("enforcer/sight3.wav");
	precache_sound2("enforcer/sight4.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	self.wad = "monster";
	self.classname = "monster_enforcer";
	setmodel(self, "progs/enforcef.mdl");
	setsize(self, VEC_HULL_MIN, '16 16 40');
	self.health = 80;
	self.th_stand = enfly_stand1;
	self.th_walk = enfly_walk1;
	self.th_run = enfly_run1;
	self.th_pain = enfly_pain;
	self.th_die = enfly_die;
	self.th_missile = enfly_atk1;
	flymonster_start();
};

