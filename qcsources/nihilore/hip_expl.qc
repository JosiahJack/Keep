void() exploder_fire = 
{
	local entity temp;
	temp = self;
	activator = other;
	SUB_UseTargets();
	self = temp;
	other = self;
	if (self.count)
	{
		sound(self, CHAN_AUTO, "misc/rublexp.wav", self.volume, self.speed);
	}
	else
	{
		if (self.dmg < 120)
		{
			sound(self, CHAN_AUTO, "misc/shortexp.wav", self.volume, self.speed);
		}
		else
		{
			sound(self, CHAN_AUTO, "misc/longexpl.wav", self.volume, self.speed);
		}
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
	if (self.count)
	{
		rubble_use();
	}
	BecomeBigExplosion();
};

void() exploder_use = 
{
	if (self.delay)
	{
		self.nextthink = time + self.delay;
		self.delay = SERVOBOD_NONE;
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
	if (self.dmg == SERVOBOD_NONE)
	{
		self.dmg = 120;
	}
	if (self.dmg < SERVOBOD_NONE)
	{
		self.dmg = SERVOBOD_NONE;
	}
	if (self.speed == SERVOBOD_NONE)
	{
		self.speed = USE_PARTICLES;
	}
	if (self.volume == SERVOBOD_NONE)
	{
		self.volume = USE_PARTICLES;
	}
	if (self.count)
	{
		precache_model("progs/rubble1.mdl");
		precache_model("progs/rubble2.mdl");
		precache_model("progs/rubble3.mdl");
		precache_sound("zombie/z_hit.wav");
		if (self.skin < SERVOBOD_NONE)
		{
			self.skin = floor(random() * 14);
		}
	}
};

void() multi_exploder_fire = 
{
	local entity temp;
	local entity expl;
	self.nextthink = time + self.wait;
	if (self.state == SERVOBOD_NONE)
	{
		self.state = USE_PARTICLES;
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
	if (self.spawnflags & USE_PARTICLES)
	{
		WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte(MSG_BROADCAST, TE_EXPLOSION);
		WriteCoord(MSG_BROADCAST, expl.origin_x);
		WriteCoord(MSG_BROADCAST, expl.origin_y);
		WriteCoord(MSG_BROADCAST, expl.origin_z);
	}
	if (self.count)
	{
		sound(expl, CHAN_VOICE, "misc/rublexp.wav", self.volume, self.speed);
	}
	else
	{
		sound(expl, CHAN_VOICE, "misc/shortexp.wav", self.volume, self.speed);
	}
	T_RadiusDamage(expl, self.owner, self.dmg, other);
	temp = self;
	self = expl;
	if (temp.count)
	{
		self.count = temp.count;
		self.skin = temp.skin;
		rubble_use();
	}
	BecomeBigExplosion();
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
		self.delay = SERVOBOD_NONE;
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
	self.modelindex = SERVOBOD_NONE;
	self.model = "";
	if (self.dmg == SERVOBOD_NONE)
	{
		self.dmg = 120;
	}
	if (self.dmg < SERVOBOD_NONE)
	{
		self.dmg = SERVOBOD_NONE;
	}
	if (self.duration == SERVOBOD_NONE)
	{
		self.duration = USE_PARTICLES;
	}
	if (self.speed == SERVOBOD_NONE)
	{
		self.speed = USE_PARTICLES;
	}
	if (self.volume == SERVOBOD_NONE)
	{
		self.volume = 0.5;
	}
	if (self.wait == SERVOBOD_NONE)
	{
		self.wait = 0.25;
	}
	self.state = SERVOBOD_NONE;
	if (self.count)
	{
		precache_model("progs/rubble1.mdl");
		precache_model("progs/rubble2.mdl");
		precache_model("progs/rubble3.mdl");
		precache_sound("zombie/z_hit.wav");
		if (self.skin < SERVOBOD_NONE)
		{
			self.skin = floor(random() * 14);
		}
	}
};

