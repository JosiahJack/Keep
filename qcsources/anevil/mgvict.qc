void() waiting1 = [0, waiting1]
{
};

void() waiting2 = [1, waiting2]
{
};

void() victimised = 
{
	sound(self, CHAN_VOICE, "player/udeath.wav", SPAWN_CRUCIFIED, ATTN_NORM);
	ThrowHead("progs/skull.mdl", self.health, self.skin);
	ThrowGib("progs/gib1.mdl", self.health);
	ThrowGib("progs/gib2.mdl", self.health);
	ThrowGib("progs/gib3.mdl", self.health);
	return;
};

void() decor_victim = 
{
	precache_model("progs/victim.mdl");
	precache_model("progs/skull.mdl");
	precache_model("progs/gib1.mdl");
	precache_model("progs/gib2.mdl");
	precache_model("progs/gib3.mdl");
	precache_sound("player/udeath.wav");
	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_NONE;
	setmodel(self, "progs/victim.mdl");
	setsize(self, '-30 -16 -32', '25 17 11');
	if (!(self.health))
	{
		self.health = SPAWN_CRUCIFIED;
	}
	self.movetype = MOVETYPE_NONE;
	self.th_die = victimised;
	if (self.spawnflags & SPAWN_UPPER)
	{
		self.th_stand = waiting2;
		self.th_walk = waiting2;
		self.th_run = waiting2;
		self.th_melee = waiting2;
		self.th_pain = waiting2;
	}
	else
	{
		self.th_stand = waiting1;
		self.th_walk = waiting1;
		self.th_run = waiting1;
		self.th_melee = waiting1;
		self.th_pain = waiting1;
		self.th_die = victimised;
	}
	total_monsters = total_monsters - SPAWN_CRUCIFIED;
	walkmonster_start();
};

