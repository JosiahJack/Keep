void() mage2_stand1 = [0, mage2_stand2]
{
	ai_stand();
};

void() mage2_stand2 = [1, mage2_stand3]
{
	ai_stand();
};

void() mage2_stand3 = [2, mage2_stand4]
{
	ai_stand();
};

void() mage2_stand4 = [3, mage2_stand1]
{
	ai_stand();
};

void() mage2_walk1 = [4, mage2_walk2]
{
	if (random() < 0.2)
	{
		sound(self, CHAN_VOICE, "knight/idle.wav", SPAWN_CRUCIFIED, ATTN_IDLE);
	}
	ai_walk(IQ_HIGH);
};

void() mage2_walk2 = [5, mage2_walk3]
{
	ai_walk(SPAWN_LYINGDOWN);
};

void() mage2_walk3 = [6, mage2_walk4]
{
	ai_walk(IQ_HIGH);
};

void() mage2_walk4 = [7, mage2_walk1]
{
	ai_walk(SPAWN_SAC);
};

void() mage2_run1 = [4, mage2_run2]
{
	if (random() < 0.2)
	{
		sound(self, CHAN_VOICE, "knight/idle.wav", SPAWN_CRUCIFIED, ATTN_IDLE);
	}
	ai_run(SECRET_YES_SHOOT);
};

void() mage2_run2 = [5, mage2_run3]
{
	ai_run(20);
};

void() mage2_run3 = [6, mage2_run4]
{
	ai_run(13);
};

void() mage2_run4 = [7, mage2_run1]
{
	ai_run(TE_WIZSPIKE);
};

void() mage2_atk1 = [8, mage2_atk2]
{
	sound(self, CHAN_WEAPON, "knight/sword1.wav", SPAWN_CRUCIFIED, ATTN_NORM);
	ai_charge(MSG_BROADCAST);
};

void() mage2_atk2 = [9, mage2_atk3]
{
	ai_charge(SPAWN_SAC);
};

void() mage2_atk3 = [10, mage2_atk4]
{
	ai_charge(SPAWN_SAC);
};

void() mage2_atk4 = [11, mage2_atk5]
{
	ai_charge(SPAWN_SAC);
};

void() mage2_atk5 = [8, mage2_atk6]
{
	ai_charge(IQ_HIGH);
	ai_melee();
};

void() mage2_atk6 = [9, mage2_atk7]
{
	ai_charge(IQ_HIGH);
	ai_melee();
};

void() mage2_atk7 = [10, mage2_atk8]
{
	ai_charge(IQ_HIGH);
	ai_melee();
};

void() mage2_atk8 = [13, mage2_run1]
{
	ai_charge(SPAWN_CRUCIFIED);
};

void() mage2_pain1 = [17, mage2_pain2]
{
};

void() mage2_pain2 = [18, mage2_pain3]
{
};

void() mage2_pain3 = [17, mage2_pain4]
{
};

void() mage2_pain4 = [18, mage2_run1]
{
};

void() mage2_painb1 = [19, mage2_painb2]
{
};

void() mage2_painb2 = [20, mage2_painb3]
{
};

void() mage2_painb3 = [21, mage2_painb4]
{
};

void() mage2_painb4 = [22, mage2_run1]
{
};

void(entity attacker, float damage) mage2_pain = 
{
	local float r;
	if (self.pain_finished > time)
	{
		return;
	}
	r = random();
	sound(self, CHAN_VOICE, "knight/khurt.wav", SPAWN_CRUCIFIED, ATTN_NORM);
	if (r < 0.55)
	{
		mage2_pain1();
		self.pain_finished = time + SPAWN_CRUCIFIED;
	}
	else
	{
		mage2_painb1();
		self.pain_finished = time + SPAWN_CRUCIFIED;
	}
};

void() mage2_die1 = [23, mage2_die2]
{
};

void() mage2_die2 = [24, mage2_die3]
{
};

void() mage2_die3 = [25, mage2_die4]
{
	self.solid = SOLID_NOT;
};

void() mage2_die4 = [26, mage2_die5]
{
};

void() mage2_die5 = [27, mage2_die6]
{
};

void() mage2_die6 = [28, mage2_die7]
{
};

void() mage2_die7 = [29, mage2_die]
{
};

void() mage2_die = 
{
	remove(self);
};

void() monster_mage2 = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/fragwiz.mdl");
	precache_sound("knight/kdeath.wav");
	precache_sound("knight/khurt.wav");
	precache_sound("knight/ksight.wav");
	precache_sound("knight/sword1.wav");
	precache_sound("knight/sword2.wav");
	precache_sound("knight/idle.wav");
	precache_sound("hknight/sboom2.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/fragwiz.mdl");
	setsize(self, VEC_HULL_MIN, '16 16 40');
	if (!(self.health))
	{
		self.health = 125;
	}
	self.th_stand = mage2_stand1;
	self.th_walk = mage2_walk1;
	self.th_run = mage2_run1;
	self.th_melee = mage2_atk1;
	self.th_pain = mage2_pain;
	self.th_die = mage2_die1;
	walkmonster_start();
};

