void() exploder_fire = 
{
	local entity temp;
	temp = self;
	activator = other;
	SUB_UseTargets();
	self = temp;
	other = self;
	if (self.dmg < TOOCLOSE_CHARMER_DISTANCE)
	{
		sound(self, CHAN_AUTO, "misc/shortexp.wav", self.volume, self.speed);
	}
	else
	{
		sound(self, CHAN_AUTO, "misc/longexpl.wav", self.volume, self.speed);
	}
	T_RadiusDamage(self, self.owner, self.dmg, other);
	if (self.spawnflags & USE_PARTICLES)
	{
		WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte(MSG_BROADCAST, TE_EXPLOSION);
		WriteCoord(MSG_BROADCAST, self.origin_x);
		WriteCoord(MSG_BROADCAST, self.origin_y);
		WriteCoord(MSG_BROADCAST, self.origin_z);
	}
	BecomeExplosion();
};

void() exploder_use = 
{
	if (self.delay)
	{
		self.nextthink = time + self.delay;
		self.delay = MSG_BROADCAST;
		self.think = exploder_fire;
	}
	else
	{
		exploder_fire();
	}
};

void() func_exploder = 
{
	precache_sound("misc/shortexp.wav");
	precache_sound("misc/longexpl.wav");
	self.classname = "exploder";
	self.use = exploder_use;
	if (self.dmg == MSG_BROADCAST)
	{
		self.dmg = TOOCLOSE_CHARMER_DISTANCE;
	}
	if (self.dmg < MSG_BROADCAST)
	{
		self.dmg = MSG_BROADCAST;
	}
	if (self.speed == MSG_BROADCAST)
	{
		self.speed = SPAWN_ROTATE;
	}
	if (self.volume == MSG_BROADCAST)
	{
		self.volume = SPAWN_ROTATE;
	}
};

void() multi_exploder_fire = 
{
	local entity temp;
	local entity expl;
	self.nextthink = time + self.wait;
	if (self.state == MSG_BROADCAST)
	{
		self.state = SPAWN_ROTATE;
		self.duration = time + self.duration;
		temp = self;
		activator = other;
		SUB_UseTargets();
		self = temp;
		other = self;
	}
	if (time > self.duration)
	{
		remove(self);
		return;
	}
	expl = spawn();
	expl.owner = self.owner;
	expl.dmg = self.dmg;
	expl.origin_x = self.absmin_x + random() * (self.absmax_x - self.absmin_x);
	expl.origin_y = self.absmin_y + random() * (self.absmax_y - self.absmin_y);
	expl.origin_z = self.absmin_z + random() * (self.absmax_z - self.absmin_z);
	sound(expl, CHAN_VOICE, "misc/shortexp.wav", self.volume, self.speed);
	T_RadiusDamage(expl, self.owner, self.dmg, other);
	if (self.spawnflags & USE_PARTICLES)
	{
		WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte(MSG_BROADCAST, TE_EXPLOSION);
		WriteCoord(MSG_BROADCAST, expl.origin_x);
		WriteCoord(MSG_BROADCAST, expl.origin_y);
		WriteCoord(MSG_BROADCAST, expl.origin_z);
	}
	temp = self;
	self = expl;
	BecomeExplosion();
	self = temp;
};

void(vector loc, float rad, float damage, float dur, float pause, float vol) multi_explosion = 
{
	local entity temp;
	temp = self;
	self = spawn();
	self.origin = loc;
	self.dmg = damage;
	self.duration = dur;
	self.wait = pause;
	self.owner = world;
	self.absmin = self.origin - rad * '1 1 1';
	self.absmax = self.origin + rad * '1 1 1';
	self.think = multi_exploder_fire;
	self.volume = vol;
	multi_exploder_fire();
	self = temp;
};

void() multi_exploder_use = 
{
	if (self.delay)
	{
		self.nextthink = time + self.delay;
		self.delay = MSG_BROADCAST;
		self.think = multi_exploder_fire;
	}
	else
	{
		self.think = multi_exploder_fire;
		multi_exploder_fire();
	}
};

void() func_multi_exploder = 
{
	precache_sound("misc/shortexp.wav");
	precache_sound("misc/longexpl.wav");
	self.classname = "exploder";
	self.use = multi_exploder_use;
	setmodel(self, self.model);
	self.movetype = MOVETYPE_NONE;
	self.modelindex = MSG_BROADCAST;
	self.model = "";
	if (self.dmg == MSG_BROADCAST)
	{
		self.dmg = TOOCLOSE_CHARMER_DISTANCE;
	}
	if (self.dmg < MSG_BROADCAST)
	{
		self.dmg = MSG_BROADCAST;
	}
	if (self.duration == MSG_BROADCAST)
	{
		self.duration = SPAWN_ROTATE;
	}
	if (self.speed == MSG_BROADCAST)
	{
		self.speed = SPAWN_ROTATE;
	}
	if (self.volume == MSG_BROADCAST)
	{
		self.volume = 0.5;
	}
	if (self.wait == MSG_BROADCAST)
	{
		self.wait = 0.25;
	}
	self.state = MSG_BROADCAST;
};

