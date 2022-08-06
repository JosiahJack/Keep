void() particle_think = 
{
	local float thinktime;
	local float intensity;
	if (self.weapon >= MSG_BROADCAST)
	{
		thinktime = self.weapon;
	}
	else
	{
		thinktime = random() * self.weapon * CONTENT_EMPTY;
	}
	if (self.owner.frags >= MSG_BROADCAST)
	{
		intensity = self.owner.frags;
	}
	else
	{
		intensity = random() * self.owner.frags * CONTENT_EMPTY;
	}
	particle(self.origin, VEC_ORIGIN, self.owner.colormap, intensity);
	self.nextthink = time + thinktime;
	if (self.currentammo < time)
	{
		remove(self);
	}
};

void() pixel_think = 
{
	local entity part;
	local float r;
	part = spawn();
	r = random();
	setorigin(part, self.origin);
	if (r < 0.05)
	{
		sound(self, CHAN_AUTO, "ambience/pixels.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	}
	if (self.spawnflags)
	{
		part.movetype = MOVETYPE_TOSS;
	}
	else
	{
		part.movetype = MOVETYPE_FLYMISSILE;
	}
	if (self.speed >= MSG_BROADCAST)
	{
		part.velocity = self.movedir * self.speed;
	}
	else
	{
		part.velocity = self.movedir * random() * self.speed * CONTENT_EMPTY;
	}
	part.weapon = self.weapon;
	part.nextthink = time;
	part.think = particle_think;
	part.owner = self;
	if (self.currentammo >= MSG_BROADCAST)
	{
		part.currentammo = time + self.currentammo;
	}
	else
	{
		part.currentammo = time + random() * self.currentammo * CONTENT_EMPTY;
	}
	if (self.teleport_time >= MSG_BROADCAST)
	{
		self.nextthink = time + self.teleport_time;
	}
	else
	{
		self.nextthink = time + random() * self.teleport_time * CONTENT_EMPTY;
	}
};

void() misc_pixel = 
{
	precache_model2("progs/null.mdl");
	precache_sound2("ambience/pixels.wav");
	self.think = pixel_think;
	self.nextthink = time;
	self.teleport_time = self.teleport_time / 100;
	self.currentammo = self.currentammo / 100;
	self.weapon = self.weapon / 100;
};

