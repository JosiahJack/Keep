void() onground_touch = 
{
	if (!(other.flags & FL_ONGROUND))
	{
		other.flags = other.flags | FL_ONGROUND;
	}
};

void() SceneryGibRemove = 
{
	if (self.alpha > 0.1)
	{
		self.alpha = self.alpha - 0.1;
	}
	else
	{
		remove(self);
		return;
	}
	self.nextthink = time + 0.2;
};

void(string gibname, vector org) ThrowSceneryGib = 
{
	local entity gib;
	gib = spawn();
	gib.movetype = MOVETYPE_BOUNCE;
	gib.solid = SOLID_NOT;
	gib.angles_y = random() * 360;
	makevectors(gib.angles);
	gib.velocity = v_forward * random() * 200;
	gib.velocity_z = random() * 300;
	if (random() < 0.25)
	{
		gib.avelocity = '1000 3000 2000';
	}
	else
	{
		if (random() < 0.5)
		{
			gib.avelocity = '100 500 350';
		}
		else
		{
			if (random() < 0.75)
			{
				gib.avelocity = '0 700 500';
			}
			else
			{
				gib.avelocity = '500 100 1000';
			}
		}
	}
	gib.nextthink = time + 0.2;
	gib.think = SceneryGibRemove;
	gib.alpha = PUSH_ONCE;
	setmodel(gib, gibname);
	setsize(gib, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(gib, org);
};

void() fountain_particlethink = 
{
	if (self.attack_finished < time)
	{
		remove(self);
		return;
	}
	else
	{
		particle(self.origin, VEC_ORIGIN, 208, SVC_SPAWNSTATIC);
	}
	self.nextthink = time + 0.010000;
};

void() fountain_think = 
{
	local entity part;
	part = spawn();
	part.owner = self;
	setmodel(part, "progs/null.spr");
	part.movetype = MOVETYPE_TOSS;
	part.solid = SOLID_NOT;
	part.takedamage = DAMAGE_NO;
	part.classname = "particle";
	setorigin(part, self.origin);
	setsize(part, VEC_ORIGIN, VEC_ORIGIN);
	part.angles_y = part.angles_y + random() * 360;
	makevectors(part.angles);
	part.velocity = v_forward * 150;
	part.velocity_z = 300 + random() * 350;
	part.attack_finished = time + 0.5 + random() * 1.5;
	part.attack_finished = time + PUSH_ONCE;
	part.think = fountain_particlethink;
	part.nextthink = time + 0.05 + random() * 0.2;
	self.nextthink = time + 0.1 + random() * 0.1;
};

void() fountain = 
{
	setmodel(self, "progs/null.spr");
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.takedamage = DAMAGE_NO;
	self.classname = "fountain";
	setsize(self, VEC_ORIGIN, VEC_ORIGIN);
	self.think = fountain_think;
	self.nextthink = time + 0.1;
	droptofloor();
};

void() particlesmoke = 
{
	particle(self.origin, VEC_ORIGIN, AS_MELEE, SVC_UPDATEFRAGS);
	if (self.attack_finished < time)
	{
		remove(self);
	}
	self.nextthink = time + 0.1;
};

void() create_smoke = 
{
	local entity smoke;
	smoke = spawn();
	setmodel(smoke, "progs/null.spr");
	smoke.movetype = MOVETYPE_NOCLIP;
	smoke.solid = SOLID_NOT;
	setorigin(smoke, self.origin - v_right * IT_RELIC4);
	smoke.velocity_z = smoke.velocity_z + 50 + random() * 100;
	smoke.attack_finished = time + 0.2 + random() * 0.6;
	smoke.nextthink = time + 0.1;
	smoke.think = particlesmoke;
	self.nextthink = time + 0.2;
};

void() ambience_smoke = 
{
	setmodel(self, "progs/null.spr");
	self.classname = "smokespawner";
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.takedamage = DAMAGE_NO;
	self.think = create_smoke;
	self.nextthink = time + 0.5 + random();
};

void() statue = 
{
	precache_model("progs/statue.mdl");
	setmodel(self, "progs/statue.mdl");
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_SLIDEBOX;
	self.takedamage = DAMAGE_NO;
	self.classname = "statue";
	self.touch = onground_touch;
	setsize(self, '-14 -38 -1', '41 55 136');
	droptofloor();
};

void() bench = 
{
	precache_model("progs/bench.mdl");
	setmodel(self, "progs/bench.mdl");
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_SLIDEBOX;
	self.takedamage = DAMAGE_NO;
	self.classname = "bench";
	setsize(self, '-14 -38 -1', '14 37 25');
	droptofloor();
};

void() statue2 = 
{
	precache_model("progs/statue2.mdl");
	setmodel(self, "progs/statue2.mdl");
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_SLIDEBOX;
	self.takedamage = DAMAGE_NO;
	self.classname = "statue2";
	self.touch = onground_touch;
	setsize(self, '-39 -23 -6', '10 6 96');
	droptofloor();
};

void() statue3 = 
{
	precache_model("progs/statue3.mdl");
	setmodel(self, "progs/statue3.mdl");
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_SLIDEBOX;
	self.takedamage = DAMAGE_NO;
	self.classname = "statue2";
	self.touch = onground_touch;
	setsize(self, '-39 -136 -1', '94 85 295');
	droptofloor();
};

void() lionhead = 
{
	precache_model("progs/lionhead.mdl");
	setmodel(self, "progs/lionhead.mdl");
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_SLIDEBOX;
	self.takedamage = DAMAGE_NO;
	self.classname = "statue2";
	self.touch = onground_touch;
	setsize(self, '-1 -29 -22', '47 28 31');
	makestatic();
};

void() tree = 
{
	precache_model("progs/tree.mdl");
	setmodel(self, "progs/tree.mdl");
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_SLIDEBOX;
	self.takedamage = DAMAGE_NO;
	self.classname = "tree";
	self.touch = onground_touch;
	setsize(self, '-36 -37 -0', '48 27 103');
	droptofloor();
};

void() flag = 
{
	precache_model("progs/flag.mdl");
	setmodel(self, "progs/flag.mdl");
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.takedamage = DAMAGE_NO;
	self.classname = "flag";
	setsize(self, '-7 -6 -7', '7 23 98');
	droptofloor();
	makestatic();
};

void() axe = 
{
	precache_model("progs/axe.mdl");
	setmodel(self, "progs/axe.mdl");
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.takedamage = DAMAGE_NO;
	self.classname = "axe";
	setsize(self, VEC_ORIGIN, VEC_ORIGIN);
	makestatic();
};

void() shield = 
{
	precache_model("progs/shield.mdl");
	setmodel(self, "progs/shield.mdl");
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.takedamage = DAMAGE_NO;
	self.classname = "shield";
	setsize(self, VEC_ORIGIN, VEC_ORIGIN);
	makestatic();
};

void() sword = 
{
	precache_model("progs/sword.mdl");
	setmodel(self, "progs/sword.mdl");
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.takedamage = DAMAGE_NO;
	self.classname = "sword";
	setsize(self, VEC_ORIGIN, VEC_ORIGIN);
	makestatic();
};

void() anvil = 
{
	precache_model("progs/anvil.mdl");
	setmodel(self, "progs/anvil.mdl");
	setsize(self, '-9 -34 -1', '7 21 23');
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_SLIDEBOX;
	self.takedamage = DAMAGE_NO;
	self.classname = "anvil";
	droptofloor();
};

void() banner = 
{
	precache_model("progs/banner.mdl");
	setmodel(self, "progs/banner.mdl");
	setsize(self, '-1 -46 -107', '0 45 0');
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.takedamage = DAMAGE_NO;
	self.classname = "banner";
	makestatic();
};

void() stool = 
{
	precache_model("progs/stool.mdl");
	setmodel(self, "progs/stool.mdl");
	setsize(self, '-7 -7 0', '7 7 25');
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_SLIDEBOX;
	self.takedamage = DAMAGE_NO;
	self.classname = "stool";
	droptofloor();
};

void() light_flame_brazier_short = 
{
	precache_model("progs/brazshrt.mdl");
	setmodel(self, "progs/brazshrt.mdl");
	setsize(self, '-7 -6 -17', '7 7 -2');
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.takedamage = DAMAGE_NO;
	self.classname = "braziers";
	droptofloor();
};

void() light_flame_brazier_tall = 
{
	precache_model("progs/braztall.mdl");
	setmodel(self, "progs/braztall.mdl");
	setsize(self, '-7 -7 -1', '7 7 95');
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.takedamage = DAMAGE_NO;
	self.classname = "braziert";
	droptofloor();
	makestatic();
};

void() light_lantern = 
{
	precache_model("progs/lantern.mdl");
	setmodel(self, "progs/lantern.mdl");
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.takedamage = DAMAGE_NO;
	self.classname = "brazierl";
	setsize(self, '-10 -10 -44', '10 10 5');
	makestatic();
};

void() misc_zombie = 
{
	precache_model("progs/hanged.mdl");
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.takedamage = DAMAGE_NO;
	setmodel(self, "progs/hanged.mdl");
	makestatic();
};

void() barrel_fadein = 
{
	if (self.alpha < PUSH_ONCE)
	{
		self.alpha = self.alpha + 0.010000;
	}
	else
	{
		self.alpha = PUSH_ONCE;
		return;
	}
	frameskip(0.05);
};

void() barrel_ressurect = 
{
	local float res;
	MakeSolidList();
	self.movetype = MOVETYPE_STEP;
	res = walkmove(self.angles_y, STATE_TOP);
	if (res)
	{
		self.health = SVC_SIGNONNUM;
		self.takedamage = DAMAGE_AIM;
		self.model = self.mdl;
		self.solid = SOLID_SLIDEBOX;
		setorigin(self, self.origin);
		self.think = barrel_fadein;
		self.nextthink = time;
	}
	else
	{
		self.solid = SOLID_NOT;
		self.nextthink = time + PUSH_ONCE;
	}
	self.movetype = MOVETYPE_NONE;
	UnmakeSolidList();
};

void() barrel_break = 
{
	sound(self, CHAN_AUTO, "misc/barrel.wav", PUSH_ONCE, ATTN_NORM);
	GiveExperience(IT_RELIC3);
	ThrowSceneryGib("progs/barrelgb.mdl", self.origin);
	ThrowSceneryGib("progs/barrelgb.mdl", self.origin);
	ThrowSceneryGib("progs/barrelgb.mdl", self.origin);
	ThrowSceneryGib("progs/barrelgb.mdl", self.origin);
	if (deathmatch == 0)
	{
		if (random() < 0.5)
		{
			drop_gold();
		}
		remove(self);
		return;
	}
	else
	{
		self.alpha = 0.1;
		self.takedamage = DAMAGE_NO;
		self.model = string_null;
		self.solid = SOLID_NOT;
		self.think = barrel_ressurect;
		self.nextthink = time + 180;
	}
	return;
};

void() barrel = 
{
	precache_model("progs/barrel.mdl");
	precache_model("progs/barrelgb.mdl");
	precache_sound("misc/barrel.wav");
	setmodel(self, "progs/barrel.mdl");
	self.mdl = self.model;
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_SLIDEBOX;
	self.takedamage = DAMAGE_AIM;
	self.classname = "breakable";
	self.netname = "solid";
	self.touch = onground_touch;
	if (!deathmatch)
	{
		self.health = 50;
	}
	else
	{
		self.health = SVC_SIGNONNUM;
	}
	setsize(self, '-15 -14 -25', '16 13 9');
	self.angles_y = random() * 360;
	self.th_die = barrel_break;
	self.noblood = 1;
	droptofloor();
};

void() light_torch_small_walltorch = 
{
	precache_model("progs/candle.mdl");
	setmodel(self, "progs/candle.mdl");
	makestatic();
};

void() candle2 = 
{
	precache_model("progs/candle2.mdl");
	setmodel(self, "progs/candle2.mdl");
	makestatic();
};

void() light_torch_long_walltorch = 
{
	precache_model("progs/longtrch.mdl");
	setmodel(self, "progs/longtrch.mdl");
	makestatic();
};

void() light_flame_large_yellow = 
{
	precache_model("progs/flame2.mdl");
	setmodel(self, "progs/flame2.mdl");
	self.frame = PUSH_ONCE;
	makestatic();
};

void() light_flame_small_yellow = 
{
	precache_model("progs/flame2.mdl");
	setmodel(self, "progs/flame2.mdl");
	makestatic();
};

void() grass = 
{
	precache_model("progs/grass.mdl");
	setmodel(self, "progs/grass.mdl");
	setsize(self, VEC_ORIGIN, VEC_ORIGIN);
	self.effects = EF_NOSHADOW;
	droptofloor();
	makestatic();
};

void() ThrowRubble = 
{
	local entity rock;
	local float x;
	local float y;
	local float z;
	x = random() * EF_ADDITIVE - IT_RELIC5;
	y = random() * EF_ADDITIVE - IT_RELIC5;
	z = random() * IT_RELIC5;
	rock = spawn();
	rock.angles_y = random() * 360;
	makevectors(rock.angles);
	rock.velocity = v_forward * 90;
	rock.velocity_z = 450;
	if (random() < 0.35)
	{
		setmodel(rock, "progs/rubble1.mdl");
	}
	else
	{
		if (random() < 0.65)
		{
			setmodel(rock, "progs/rubble2.mdl");
		}
		else
		{
			setmodel(rock, "progs/rubble3.mdl");
		}
	}
	setsize(rock, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(rock, self.origin + v_forward * x + v_up * z + v_right * y);
	rock.avelocity = '600 1000 900';
	rock.movetype = MOVETYPE_BOUNCE;
	rock.solid = SOLID_TRIGGER;
	rock.alpha = PUSH_ONCE;
	rock.think = SceneryGibRemove;
	rock.nextthink = time + 0.5;
};

void() boulder_think = 
{
	local entity y;
	local entity oself;
	y = searchradius(self.origin, 35);
	while (y)
	{
		if (y.classname == "breakable")
		{
			oself = self;
			self = y;
			if (self.th_die)
			{
				self.th_die();
			}
			self = oself;
			ThrowRubble();
			ThrowRubble();
			ThrowRubble();
			ThrowRubble();
			remove(self);
			return;
		}
		y = y.chain;
	}
	frameskip(0.1);
};

void() boulder_use = 
{
	self.avelocity = '500 -500 0';
	self.movetype = MOVETYPE_TOSS;
	self.think = boulder_think;
	self.nextthink = time + 0.1;
};

void() misc_boulder = 
{
	if (!(self.targetname))
	{
		objerror("error: misc_boulder with no target name!\n");
	}
	precache_model("progs/boulder.mdl");
	precache_model("progs/rubble1.mdl");
	precache_model("progs/rubble2.mdl");
	precache_model("progs/rubble3.mdl");
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.use = boulder_use;
	setmodel(self, "progs/boulder.mdl");
	setsize(self, '-27 -13 -26', '12 20 29');
};

void() destroy_think = 
{
	if (self.alpha > 0.1)
	{
		self.alpha = self.alpha - 0.1;
	}
	else
	{
		remove(self);
		return;
	}
	self.nextthink = time + 0.1;
};

void() destroy_destroy = 
{
	local vector h;
	h = self.absmin + (self.absmax - self.absmin) * 0.5;
	if (self.target)
	{
		SUB_UseTargets();
	}
	if (self.cnt == STATE_TOP)
	{
		ThrowSceneryGib("progs/wood1.mdl", h);
		ThrowSceneryGib("progs/wood2.mdl", h);
		ThrowSceneryGib("progs/wood3.mdl", h);
		ThrowSceneryGib("progs/wood1.mdl", h);
		ThrowSceneryGib("progs/wood2.mdl", h);
		ThrowSceneryGib("progs/wood3.mdl", h);
	}
	else
	{
		if (self.cnt == PUSH_ONCE)
		{
			ThrowSceneryGib("progs/rock1.mdl", h);
			ThrowSceneryGib("progs/rock2.mdl", h);
			ThrowSceneryGib("progs/rock3.mdl", h);
			ThrowSceneryGib("progs/rock1.mdl", h);
			ThrowSceneryGib("progs/rock2.mdl", h);
			ThrowSceneryGib("progs/rock3.mdl", h);
		}
		else
		{
			if (self.cnt == IT_RELIC2)
			{
				ThrowSceneryGib("progs/metal1.mdl", h);
				ThrowSceneryGib("progs/metal2.mdl", h);
				ThrowSceneryGib("progs/metal3.mdl", h);
				ThrowSceneryGib("progs/metal1.mdl", h);
				ThrowSceneryGib("progs/metal2.mdl", h);
				ThrowSceneryGib("progs/metal3.mdl", h);
			}
		}
	}
	if (self.noise != "" && self.cnt != IT_RELIC3)
	{
		sound(self, CHAN_AUTO, self.noise, PUSH_ONCE, ATTN_NORM);
	}
	remove(self);
	return;
};

void() func_destroy = 
{
	if (!(self.health))
	{
		self.health = PUSH_ONCE;
	}
	if (self.cnt == STATE_TOP)
	{
		precache_model("progs/wood1.mdl");
		precache_model("progs/wood2.mdl");
		precache_model("progs/wood3.mdl");
		self.noise = "misc/woodbrk.wav";
	}
	if (self.cnt == PUSH_ONCE)
	{
		precache_model("progs/rock1.mdl");
		precache_model("progs/rock2.mdl");
		precache_model("progs/rock3.mdl");
		self.noise = "misc/rocks.wav";
	}
	if (self.cnt == IT_RELIC2)
	{
		precache_model("progs/metal1.mdl");
		precache_model("progs/metal2.mdl");
		precache_model("progs/metal3.mdl");
		self.noise = "misc/metlbrk.wav";
	}
	if (self.noise)
	{
		precache_sound(self.noise);
	}
	self.netname = "solid";
	self.classname = "breakable";
	self.noblood = 1;
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	if (!(self.spawnflags & PUSH_ONCE))
	{
		self.takedamage = DAMAGE_YES;
	}
	else
	{
		self.takedamage = DAMAGE_NO;
	}
	if (self.health == STATE_TOP)
	{
		self.takedamage = DAMAGE_NO;
	}
	self.th_die = destroy_destroy;
	self.use = destroy_destroy;
	setmodel(self, self.model);
};

void() func_bell_touch = 
{
	if (other.classname == "player" && self.attack_finished < time)
	{
		if (other.velocity_z <= -100)
		{
			sound(self, CHAN_AUTO, "misc/bell.wav", PUSH_ONCE, ATTN_NORM);
			self.attack_finished = time + 4.5;
		}
	}
};

void() func_bell = 
{
	precache_sound("misc/bell.wav");
	self.angles = VEC_ORIGIN;
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_BSP;
	self.touch = func_bell_touch;
	setmodel(self, self.model);
};

