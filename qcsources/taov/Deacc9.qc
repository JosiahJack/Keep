void() ghost_think = 
{
	local entity targ;
	local float disto;
	local float draindelay;
	targ = searchradius(self.origin, 200);
	while (targ)
	{
		if (targ.classname == "player" && visible(targ) && targ.health > PLAT_LOW_TRIGGER && targ.invunerability_finished < time && targ.takedamage != DAMAGE_NO)
		{
			disto = vlen(targ.origin - self.origin);
			if (self.attack_finished < time)
			{
				if (difficulty == STATE_TOP)
				{
					draindelay = disto / 1000;
				}
				else
				{
					if (difficulty == PLAT_LOW_TRIGGER)
					{
						draindelay = disto / 750;
					}
					else
					{
						draindelay = disto / 500;
					}
				}
				if (draindelay < 0.2)
				{
					draindelay = 0.2;
				}
				targ.health = targ.health - PLAT_LOW_TRIGGER;
				self.attack_finished = time + draindelay;
			}
		}
		targ = targ.chain;
	}
	if (self.enemy && self.enemy.health > STATE_TOP)
	{
		if (!(self.enemy.flypain))
		{
			ai_fly(SVC_LIGHTSTYLE);
		}
	}
	else
	{
		ai_stand();
		self.velocity = no;
	}
	frameskip(0.1);
};

void() ghost_pain = 
{
	monster_pain(self.enemy);
	sound(self, CHAN_BODY, "ghost/pain.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
};

void() ghost_die = 
{
	if (self.gaveexp != 1)
	{
		sound(self, CHAN_BODY, "ghost/death.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
		GiveExperience(65);
		self.gaveexp = 1;
		monster_death();
		remove(self);
		return;
	}
};

void() monster_ghost = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_sound("ghost/pain.wav");
	precache_sound("ghost/death.wav");
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NOCLIP;
	setmodel(self, "progs/null.spr");
	if (difficulty < IT_RELIC2)
	{
		self.health = SVC_SIGNONNUM;
	}
	else
	{
		self.health = 50;
	}
	self.netname = "solid";
	self.effects = EF_DIMLIGHT;
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_NOT;
	self.flags = FL_MONSTER;
	self.classname = "ghost";
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.noblood = 1;
	self.awareness = PLAT_LOW_TRIGGER;
	self.th_stand = ghost_think;
	self.th_run = ghost_think;
	self.th_pain = ghost_pain;
	self.th_die = ghost_die;
	self.think = ghost_think;
	self.nextthink = time;
	enemy_start();
};

void() spawn_ghost = 
{
	local entity ghost;
	ghost = spawn();
	ghost.solid = SOLID_NOT;
	ghost.movetype = MOVETYPE_NOCLIP;
	setorigin(ghost, self.origin);
	setmodel(ghost, "progs/null.spr");
	if (difficulty < IT_RELIC2)
	{
		ghost.health = SVC_SIGNONNUM;
	}
	else
	{
		ghost.health = 50;
	}
	ghost.netname = "solid";
	ghost.flags = FL_MONSTER;
	ghost.effects = EF_DIMLIGHT;
	ghost.takedamage = DAMAGE_AIM;
	ghost.solid = SOLID_NOT;
	ghost.classname = "ghost2";
	setsize(ghost, VEC_HULL_MIN, VEC_HULL_MAX);
	ghost.noblood = 1;
	ghost.th_stand = ghost_think;
	ghost.th_run = ghost_think;
	ghost.th_pain = ghost_pain;
	ghost.th_die = ghost_die;
	ghost.awareness = PLAT_LOW_TRIGGER;
	ghost.think = ghost.th_stand;
	ghost.nextthink = time;
};

