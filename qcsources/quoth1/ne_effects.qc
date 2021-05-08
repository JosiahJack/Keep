void() effect_pulse_launch = 
{
	local entity missile;
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "pulse";
	missile.velocity = self.movedir * self.speed;
	missile.touch = SUB_Remove;
	missile.nextthink = time + AS_BLINDFIRE;
	missile.think = SUB_Remove;
	missile.effects = EF_DIMLIGHT;
	setmodel(missile, "progs/s_null.spr");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, self.origin);
};

void() effect_pulse_loop = 
{
	if (self.wait > MSG_BROADCAST)
	{
		self.nextthink = time + self.wait;
	}
	self.think = effect_pulse_loop;
	effect_pulse_launch();
	if (self.wait == CONTENT_EMPTY)
	{
		SUB_Remove();
		return;
	}
};

void() effect_pulse_start = 
{
	self.nextthink = time + self.delay;
	self.think = effect_pulse_loop;
};

void() effect_pulse = 
{
	precache_model("progs/s_null.spr");
	SetMovedir();
	if (!(self.speed))
	{
		self.speed = 400;
	}
	if (!(self.delay))
	{
		self.delay = 0.1;
	}
	if (!(self.wait))
	{
		self.wait = LIGHTNING_RANDOM;
	}
	self.nextthink = time + self.delay;
	if (self.targetname)
	{
		self.nextthink = time + 1000000;
		self.use = effect_pulse_start;
	}
	self.think = effect_pulse_loop;
};

void() info_effect_pulse = 
{
	effect_pulse();
};

void() bug_bob = 
{
	self.nextthink = time + 0.1;
	self.think = bug_bob;
	if (self.multiplier > LIGHTNING_RANDOM)
	{
		self.multiplier = self.multiplier - 0.15;
	}
	if (self.multiplier < LIGHTNING_RANDOM)
	{
		self.multiplier = LIGHTNING_RANDOM;
	}
	self.velocity = self.velocity * 0.8 + (self.oldorigin - self.origin) * 0.2;
	if (random() < 0.030000 && self.ltime < time)
	{
		self.ltime = time + AS_LOITER;
		self.multiplier = 4.5;
	}
	self.velocity = normalize(self.velocity);
	self.velocity = self.velocity * ((20 + random() * SECRET_NO_SHOOT) * self.multiplier);
};

void() make_bugs = 
{
	local entity bug;
	local vector svec;
	bug = spawn();
	bug.oldorigin = self.origin;
	bug.movetype = MOVETYPE_NOCLIP;
	bug.solid = SOLID_NOT;
	bug.velocity_x = 20 + random() * -40;
	bug.velocity_y = 20 + random() * -40;
	bug.velocity_z = 20 + random() * -40;
	bug.nextthink = time + 0.1;
	bug.think = bug_bob;
	bug.classname = "lightchunk";
	bug.frame = MSG_BROADCAST;
	bug.cnt = MSG_BROADCAST;
	if (self.count > LIGHTNING_RANDOM)
	{
		setmodel(bug, "progs/marshsm.spr");
	}
	else
	{
		setmodel(bug, "progs/marsh.spr");
	}
	bug.frame = self.color;
	svec_x = 20 + random() * -40;
	svec_y = 20 + random() * -40;
	svec_z = 20 + random() * -40;
	svec = self.origin + svec;
	setorigin(bug, svec);
	setsize(bug, VEC_ORIGIN, VEC_ORIGIN);
	if (self.count < AS_BLINDFIRE)
	{
		self.nextthink = time + 0.1;
		self.think = make_bugs;
	}
	else
	{
		remove(self);
	}
	self.count = self.count + LIGHTNING_RANDOM;
};

void() light_marsh = 
{
	precache_model("progs/marsh.spr");
	precache_model("progs/marshsm.spr");
	make_bugs();
};

void() light_globe = 
{
	precache_model("progs/s_light.spr");
	setmodel(self, "progs/s_light.spr");
	self.frame = self.color;
	makestatic(self);
};

void() shake_use = 
{
	local entity qent;
	qent = spawn();
	qent.owner = self;
	qent.movetype = MOVETYPE_NONE;
	qent.solid = SOLID_NOT;
	qent.spawnmaster = activator;
	qent.nextthink = time + self.lip;
	qent.think = shaker_think;
	qent.multiplier = self.multiplier;
	qent.lip = self.lip;
	qent.duration = time + self.duration;
	qent.ltime = time + self.ltime;
	setsize(qent, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(qent, self.origin);
};

void() info_screenshake = 
{
	if (!(self.ltime))
	{
		self.ltime = LIGHTNING_RANDOM;
	}
	if (!(self.lip))
	{
		self.lip = 0.010000;
	}
	if (!(self.multiplier))
	{
		self.multiplier = 0.000500;
	}
	self.use = shake_use;
};

