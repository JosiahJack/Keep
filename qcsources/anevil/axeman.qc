void() MG_DeathBlow = 
{
	local vector delta;
	local float ldmg;
	if (!(self.enemy))
	{
		return;
	}
	delta = self.enemy.origin - self.origin;
	if (vlen(delta) > 90)
	{
		return;
	}
	if (!CanDamage(self.enemy, self))
	{
		return;
	}
	random();
	ldmg = (random() + random() + random()) * BURN_TIME;
	if (ldmg < 15)
	{
		ldmg = 15;
	}
	if (self.health < 20)
	{
		ldmg = ldmg + 15;
	}
	T_Damage(self.enemy, self, self, ldmg);
};

void() axe_stand1 = [6, axe_stand2]
{
	ai_stand();
};

void() axe_stand2 = [7, axe_stand3]
{
	ai_stand();
};

void() axe_stand3 = [8, axe_stand4]
{
	ai_stand();
};

void() axe_stand4 = [9, axe_stand5]
{
	ai_stand();
};

void() axe_stand5 = [10, axe_stand6]
{
	ai_stand();
};

void() axe_stand6 = [11, axe_stand7]
{
	ai_stand();
};

void() axe_stand7 = [12, axe_stand8]
{
	ai_stand();
};

void() axe_stand8 = [13, axe_stand9]
{
	ai_stand();
};

void() axe_stand9 = [14, axe_stand10]
{
	ai_stand();
};

void() axe_stand10 = [15, axe_stand11]
{
	ai_stand();
};

void() axe_stand11 = [16, axe_stand12]
{
	ai_stand();
};

void() axe_stand12 = [17, axe_stand1]
{
	ai_stand();
};

void() axe_walk1 = [0, axe_walk2]
{
	if (random() < 0.2)
	{
		sound(self, CHAN_VOICE, "soldier/idle.wav", SPAWN_FLOATING, ATTN_IDLE);
	}
	ai_walk(SPAWN_FLOATING);
};

void() axe_walk2 = [1, axe_walk3]
{
	ai_walk(SVC_SETVIEWANGLES);
};

void() axe_walk3 = [2, axe_walk4]
{
	ai_walk(SVC_SETVIEWANGLES);
};

void() axe_walk4 = [3, axe_walk5]
{
	ai_walk(SVC_SETVIEWANGLES);
};

void() axe_walk5 = [4, axe_walk6]
{
	ai_walk(SVC_SETVIEWANGLES);
};

void() axe_walk6 = [5, axe_walk1]
{
	ai_walk(SVC_SETVIEWANGLES);
};

void() axe_run1 = [0, axe_run2]
{
	if (random() < 0.2)
	{
		sound(self, CHAN_VOICE, "soldier/idle.wav", SPAWN_FLOATING, ATTN_IDLE);
	}
	ai_run(SPAWN_CUT);
};

void() axe_run2 = [1, axe_run3]
{
	ai_charge(15);
};

void() axe_run3 = [2, axe_run4]
{
	ai_run(15);
};

void() axe_run4 = [3, axe_run5]
{
	ai_run(15);
};

void() axe_run5 = [4, axe_run6]
{
	ai_run(15);
};

void() axe_run6 = [5, axe_run1]
{
	ai_run(15);
};

void() axe_pain1 = [18, axe_pain2]
{
};

void() axe_pain2 = [19, axe_pain3]
{
};

void() axe_pain3 = [20, axe_pain4]
{
};

void() axe_pain4 = [21, axe_pain5]
{
};

void() axe_pain5 = [22, axe_pain6]
{
};

void() axe_pain6 = [23, axe_run1]
{
	ai_pain(SPAWN_FLOATING);
};

void() axe_swinga1 = [33, axe_swinga2]
{
	ai_charge(TE_LIGHTNING3);
};

void() axe_swinga2 = [34, axe_swinga3]
{
	ai_charge(TE_LIGHTNING3);
	ai_melee();
};

void() axe_swinga3 = [35, axe_swinga4]
{
	ai_charge(TE_LIGHTNING3);
	ai_melee();
};

void() axe_swinga4 = [36, axe_swinga5]
{
	ai_charge(TE_LIGHTNING3);
	ai_melee();
};

void() axe_swinga5 = [37, axe_swinga6]
{
	ai_charge(TE_LIGHTNING3);
};

void() axe_swinga6 = [38, axe_run1]
{
	ai_charge(IQ_HIGH);
};

void() axe_swingb1 = [39, axe_swingb2]
{
	ai_charge(TE_LIGHTNING3);
};

void() axe_swingb2 = [40, axe_swingb3]
{
	ai_charge(TE_LIGHTNING3);
	ai_melee();
};

void() axe_swingb3 = [41, axe_swingb4]
{
	ai_charge(TE_LIGHTNING3);
	ai_melee();
};

void() axe_swingb4 = [42, axe_swingb5]
{
	ai_charge(TE_LIGHTNING3);
	ai_melee();
};

void() axe_swingb5 = [43, axe_swingb6]
{
	ai_charge(TE_LIGHTNING3);
};

void() axe_swingb6 = [44, axe_run1]
{
	ai_charge(IQ_HIGH);
};

void() axe_swingc1 = [45, axe_swingc2]
{
	ai_charge(TE_LIGHTNING3);
};

void() axe_swingc2 = [46, axe_swingc3]
{
	ai_charge(TE_LIGHTNING3);
};

void() axe_swingc3 = [47, axe_swingc4]
{
	ai_charge(TE_LIGHTNING3);
	MG_DeathBlow();
};

void() axe_swingc4 = [48, axe_swingc5]
{
	ai_charge(TE_LIGHTNING3);
};

void() axe_swingc5 = [49, axe_swingc6]
{
	ai_charge(TE_LIGHTNING3);
};

void() axe_swingc6 = [50, axe_run1]
{
	ai_charge(IQ_HIGH);
};

void() axe_swingd1 = [51, axe_swingd2]
{
	ai_charge(TE_LIGHTNING3);
};

void() axe_swingd2 = [52, axe_swingd3]
{
	ai_charge(TE_LIGHTNING3);
};

void() axe_swingd3 = [53, axe_swingd4]
{
	ai_charge(TE_LIGHTNING3);
	ai_melee();
};

void() axe_swingd4 = [54, axe_swingd5]
{
	ai_charge(TE_LIGHTNING3);
};

void() axe_swingd5 = [55, axe_swingd6]
{
	ai_charge(TE_LIGHTNING3);
};

void() axe_swingd6 = [56, axe_run1]
{
	ai_charge(IQ_HIGH);
};

void(entity attacker, float damage) axe_pain = 
{
	local float r;
	if (self.pain_finished > time)
	{
		return;
	}
	axe_pain1();
	r = random();
	if (r < 0.2)
	{
		self.pain_finished = time + 0.6;
		sound(self, CHAN_VOICE, "soldier/pain1.wav", SPAWN_FLOATING, ATTN_NORM);
	}
	else
	{
		self.pain_finished = time + 1.1;
		sound(self, CHAN_VOICE, "soldier/pain2.wav", SPAWN_FLOATING, ATTN_NORM);
	}
};

void() axe_kill = 
{
	local float r;
	dprint(" axe kill \n");
	r = random();
	if (self.health < 20 || random() < skill * 0.05 || self.enemy.classname == "monster_zombie" && skill > MSG_BROADCAST)
	{
		sound(self, CHAN_WEAPON, "axemen/woosh.wav", SPAWN_FLOATING, ATTN_NORM);
		axe_swingc1();
	}
	else
	{
		if (r < 0.4)
		{
			sound(self, CHAN_WEAPON, "axemen/woosh.wav", SPAWN_FLOATING, ATTN_NORM);
			axe_swinga1();
		}
		else
		{
			if (r < 0.7)
			{
				sound(self, CHAN_WEAPON, "axemen/woosh.wav", SPAWN_FLOATING, ATTN_NORM);
				axe_swingb1();
			}
			else
			{
				sound(self, CHAN_WEAPON, "axemen/woosh.wav", SPAWN_FLOATING, ATTN_NORM);
				axe_swingd1();
			}
		}
	}
};

void() axe_die1 = [24, axe_die2]
{
	ai_back(SPAWN_CUT);
};

void() axe_die2 = [25, axe_die3]
{
	ai_back(SVC_SETVIEWANGLES);
};

void() axe_die3 = [26, axe_die4]
{
	self.solid = SOLID_NOT;
};

void() axe_die4 = [27, axe_die5]
{
};

void() axe_die5 = [28, axe_die6]
{
};

void() axe_die6 = [29, axe_die7]
{
};

void() axe_die7 = [30, axe_die8]
{
};

void() axe_die8 = [31, axe_die9]
{
};

void() axe_die9 = [32, axe_die9]
{
};

void() axe_die = 
{
	if (self.health < -35)
	{
		sound(self, CHAN_VOICE, "player/udeath.wav", SPAWN_FLOATING, ATTN_NORM);
		ThrowHead("progs/skull.mdl", self.health, self.skin);
		ThrowGib("progs/gib1.mdl", self.health);
		ThrowGib("progs/gib2.mdl", self.health);
		ThrowGib("progs/gib3.mdl", self.health);
		self.health = self.health * 2.5;
		ThrowGib("progs/gib1.mdl", self.health);
		ThrowGib("progs/gib2.mdl", self.health);
		ThrowGib("progs/gib3.mdl", self.health);
		return;
	}
	sound(self, CHAN_VOICE, "axemen/axdeath.wav", SPAWN_FLOATING, ATTN_NORM);
	axe_die1();
};

void() monster_axeman = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/axeman.mdl");
	precache_model("progs/skull.mdl");
	precache_model("progs/gib1.mdl");
	precache_model("progs/gib2.mdl");
	precache_model("progs/gib3.mdl");
	precache_sound("soldier/death1.wav");
	precache_sound("soldier/idle.wav");
	precache_sound("soldier/pain1.wav");
	precache_sound("soldier/pain2.wav");
	precache_sound("soldier/sattck1.wav");
	precache_sound("soldier/sight1.wav");
	precache_sound("hknight/hit.wav");
	precache_sound("axemen/axdeath.wav");
	precache_sound("axemen/woosh.wav");
	precache_sound("player/udeath.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/axeman.mdl");
	setsize(self, VEC_HULL_MIN, '16 16 40');
	if (!(self.health))
	{
		self.health = 70;
	}
	self.crit = 15;
	self.th_stand = axe_stand1;
	self.th_walk = axe_walk1;
	self.th_run = axe_run1;
	self.th_melee = axe_kill;
	self.th_pain = axe_pain;
	self.th_die = axe_die;
	dprint("MARTINMARTINMARTIN\n");
	walkmonster_start();
};

