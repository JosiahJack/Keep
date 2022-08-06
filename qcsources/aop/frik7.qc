void() bar_spin1 = [0, bar_spin2]
{
	if (random() < 0.2)
	{
		sound(self, CHAN_AUTO, "enviro/physics/trspin1.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	}
	else
	{
		sound(self, CHAN_AUTO, "enviro/physics/trspin2.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	}
};

void() bar_spin2 = [1, bar_spin3]
{
};

void() bar_spin3 = [2, bar_spin4]
{
};

void() bar_spin4 = [3, bar_spin5]
{
};

void() bar_spin5 = [4, bar_spin6]
{
};

void() bar_spin6 = [5, bar_spin1]
{
};

void() TrapbarTouch = 
{
	local float damg;
	if (self.dmgtime < time)
	{
		damg = 200 + random() * 100;
		if (random() < 0.5)
		{
			sound(self, CHAN_AUTO, "enviro/physics/spill1.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
		}
		else
		{
			sound(self, CHAN_AUTO, "enviro/physics/spill2.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
		}
		if (random() < 0.5)
		{
			sound(self, CHAN_AUTO, "enviro/physics/pour.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
		}
		else
		{
			sound(self, CHAN_AUTO, "enviro/physics/trkild.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
		}
		sound(self, CHAN_AUTO, "enviro/physics/trcut.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
		sound(self, CHAN_AUTO, "enviro/physics/trcut.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
		sound(self, CHAN_AUTO, "enviro/physics/trcut.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
		T_Damage(other, self, self, damg);
		self.dmgtime = time + 0.1;
	}
};

void() dropblood = 
{
	local entity missile;
	local entity mpuff;
	local vector org;
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_NOT;
	missile.nextthink = time + SPAWNFLAG_SUPERSPIKE;
	missile.think = SUB_Remove;
	self.nextthink = time + 0.2;
	self.think = dropblood;
	if (random() < 0.5)
	{
		sound(self, CHAN_AUTO, "enviro/physics/spill2.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	}
	else
	{
		sound(self, CHAN_AUTO, "enviro/physics/spill1.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	}
	setmodel(missile, "progs/zom_gib.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	missile.velocity_z = missile.velocity_z + 250 + 50 * random();
	missile.avelocity = '3000 1000 2000';
	setorigin(missile, self.origin);
};

void() trapbar_explode = 
{
	sound(self, CHAN_AUTO, "enviro/physics/trstop.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	ThrowGib("progs/spidgib.mdl", self.health - 40 - random() * 40);
	ThrowGib("progs/spidgib.mdl", self.health - 40 - random() * 40);
	ThrowGib("progs/spidgib.mdl", self.health - 40 - random() * 40);
	ThrowGib("progs/spidgib.mdl", self.health - 40 - random() * 40);
	ThrowGib("progs/spidgib.mdl", self.health - 40 - random() * 40);
	ThrowGib("progs/spidgib.mdl", self.health - 40 - random() * 40);
	ThrowGib("progs/spidgib.mdl", self.health - 40 - random() * 40);
	ThrowGib("progs/spidgib.mdl", self.health - 40 - random() * 40);
	ThrowGib("progs/spidgib.mdl", self.health - 40 - random() * 40);
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord(MSG_BROADCAST, self.origin_x);
	WriteCoord(MSG_BROADCAST, self.origin_y);
	WriteCoord(MSG_BROADCAST, self.origin_z);
	BecomeExplosion();
};

void() trapbar_pain = 
{
	self.health = 5000;
};

void() trapbar = 
{
	local float oldz;
	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_NONE;
	precache_model("progs/trapbar.mdl");
	precache_model("progs/spidgib.mdl");
	precache_sound("enviro/physics/trkild.wav");
	precache_sound("enviro/physics/pour.wav");
	precache_sound("enviro/physics/spill1.wav");
	precache_sound("enviro/physics/spill2.wav");
	precache_sound("enviro/physics/trspin1.wav");
	precache_sound("enviro/physics/trspin2.wav");
	precache_sound("enviro/physics/trcut.wav");
	precache_sound("enviro/physics/trstop.wav");
	setmodel(self, "progs/trapbar.mdl");
	self.touch = TrapbarTouch;
	setsize(self, '-100 -34 -34', '100 34 34');
	self.nextthink = time + 0.2;
	self.think = dropblood;
	self.health = 5000;
	self.takedamage = DAMAGE_YES;
	self.th_die = trapbar_explode;
	self.th_pain = trapbar_pain;
	bar_spin1();
};

