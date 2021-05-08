void() horror_stand1 = [0, horror_stand2]
{
	ai_stand();
};

void() horror_stand2 = [1, horror_stand3]
{
	ai_stand();
};

void() horror_stand3 = [2, horror_stand4]
{
	ai_stand();
};

void() horror_stand4 = [3, horror_stand5]
{
	ai_stand();
};

void() horror_stand5 = [4, horror_stand6]
{
	ai_stand();
};

void() horror_stand6 = [5, horror_stand1]
{
	ai_stand();
};

void() horror_run1 = [12, horror_run2]
{
	ai_fly(35);
};

void() horror_run2 = [13, horror_run3]
{
	ai_fly(35);
};

void() horror_run3 = [14, horror_run4]
{
	ai_fly(35);
};

void() horror_run4 = [15, horror_run5]
{
	ai_fly(35);
};

void() horror_run5 = [16, horror_run6]
{
	ai_fly(35);
};

void() horror_run6 = [17, horror_run1]
{
	ai_fly(35);
};

void() horror_fireball1 = [24, horror_fireball2]
{
	Fireball(TE_LIGHTNING2, STATE_TOP);
	if (random() < 0.1)
	{
		sound(self, CHAN_VOICE, "horror/taunt.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	}
};

void() horror_fireball2 = [25, horror_fireball3]
{
};

void() horror_fireball3 = [26, horror_fireball4]
{
};

void() horror_fireball4 = [27, horror_fireball5]
{
};

void() horror_fireball5 = [28, horror_fireball6]
{
};

void() horror_fireball6 = [29, horror_run1]
{
};

void() horror_pain1 = [30, horror_pain2]
{
};

void() horror_pain2 = [31, horror_pain3]
{
};

void() horror_pain3 = [32, horror_pain4]
{
};

void() horror_pain4 = [33, horror_pain5]
{
};

void() horror_pain5 = [34, horror_pain6]
{
};

void() horror_pain6 = [35, horror_run1]
{
};

void() horror_pain = 
{
	self.velocity = no;
	sound(self, CHAN_BODY, "horror/pain.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	horror_pain1();
	monster_pain(self.enemy);
};

void() horror_die1 = [18, horror_die2]
{
	monster_death();
};

void() horror_die2 = [19, horror_die3]
{
	monster_death();
};

void() horror_die3 = [20, horror_die4]
{
	monster_death();
};

void() horror_die4 = [21, horror_die5]
{
	monster_death();
};

void() horror_die5 = [22, horror_die6]
{
	monster_death();
};

void() horror_die6 = [23, horror_die6]
{
	monster_death();
};

void() horror_die = 
{
	if (self.gaveexp != 1)
	{
		sound(self, CHAN_BODY, "horror/death.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
		self.movetype = MOVETYPE_TOSS;
		self.avelocity = '300 300 0';
		GiveExperience(SVC_SPAWNSTATIC);
		self.gaveexp = 1;
	}
	if (self.knockback != IT_RELIC2 && self.knockback != AS_MELEE)
	{
		self.velocity = no;
		self.flags = self.flags - (self.flags & FL_ONGROUND);
		self.velocity = self.velocity + TE_LIGHTNING3 * v_forward * IT_RELIC4;
		self.velocity = self.velocity + 90 * '0 0 3';
	}
	horror_die1();
};

void() monster_horror = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/horror.mdl");
	precache_sound("horror/pain.wav");
	precache_sound("horror/crunch.wav");
	precache_sound("horror/death.wav");
	precache_sound("horror/taunt.wav");
	self.movetype = MOVETYPE_FLY;
	setmodel(self, "progs/horror.mdl");
	setsize(self, '-21 -31 -16', '22 33 35');
	if (difficulty < IT_RELIC2)
	{
		self.health = 75;
	}
	else
	{
		self.health = 113;
	}
	self.netname = "solid";
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_NOT;
	self.classname = "horror";
	setorigin(self, self.origin);
	self.th_stand = horror_stand1;
	self.th_run = horror_run1;
	self.th_missile = horror_fireball1;
	self.th_pain = horror_pain;
	self.th_die = horror_die;
	spawn_shadow();
	enemy_start();
};

