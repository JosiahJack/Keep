void() func_drip_touch = 
{
	local float r;
	if (self.spawnflags & SPAWN_NOSOUND)
	{
		SUB_Remove();
		return;
	}
	if (other.classname == "worldspawn")
	{
		r = random() * IQ_HIGH;
		if (r < SPAWN_CRUCIFIED)
		{
			sound(self, CHAN_AUTO, "misc/drip/drip_1.wav", self.volume, self.speed);
		}
		else
		{
			if (r < SPAWN_LYINGDOWN)
			{
				sound(self, CHAN_AUTO, "misc/drip/drip_3.wav", self.volume, self.speed);
			}
			else
			{
				sound(self, CHAN_AUTO, "misc/drip/drip_4.wav", self.volume, self.speed);
			}
		}
	}
	else
	{
		if (other.classname == "drop")
		{
			return;
		}
		else
		{
			sound(self, CHAN_AUTO, "misc/drip/drip_2.wav", self.volume, self.speed);
		}
	}
	SUB_Remove();
};

void() func_drip_checkcontents = 
{
	if (pointcontents(self.origin) == CONTENT_WATER)
	{
		sound(self, CHAN_AUTO, "misc/drip/drip_1.wav", SPAWN_CRUCIFIED, ATTN_NORM);
		remove(self);
		return;
	}
	self.nextthink = time + 0.5;
};

void() func_drip_drop = 
{
	local entity drop;
	local float marty;
	drop = spawn();
	drop.classname = "drop";
	drop.solid = SOLID_TRIGGER;
	drop.movetype = MOVETYPE_BOUNCE;
	drop.touch = func_drip_touch;
	drop.volume = self.volume;
	drop.speed = self.speed;
	setorigin(drop, self.origin);
	if (self.spawnflags & SPAWN_WATER)
	{
		setmodel(drop, "progs/s_drip.spr");
		setsize(drop, VEC_ORIGIN, VEC_ORIGIN);
	}
	else
	{
		setmodel(drop, "progs/blood.mdl");
		setsize(drop, VEC_ORIGIN, VEC_ORIGIN);
	}
	drop.think = func_drip_checkcontents;
	drop.nextthink = time + 0.5;
	if (self.lip)
	{
		marty = random() * self.lip;
		marty = marty + self.delay;
		self.nextthink = time + marty;
	}
	else
	{
		self.nextthink = time + self.delay;
	}
};

void() func_drip = 
{
	if (self.spawnflags & SPAWN_WATER)
	{
		precache_model("progs/s_drip.spr");
	}
	else
	{
		precache_model("progs/blood.mdl");
	}
	precache_sound("misc/drip/drip_1.wav");
	precache_sound("misc/drip/drip_2.wav");
	precache_sound("misc/drip/drip_3.wav");
	precache_sound("misc/drip/drip_4.wav");
	if (!(self.delay))
	{
		self.delay = IQ_HIGH;
	}
	if (self.volume == MSG_BROADCAST)
	{
		self.volume = SPAWN_CRUCIFIED;
	}
	if (self.speed == MSG_BROADCAST)
	{
		self.speed = SPAWN_CRUCIFIED;
	}
	if (self.speed == CONTENT_EMPTY)
	{
		self.speed = MSG_BROADCAST;
	}
	self.think = func_drip_drop;
	self.nextthink = time + self.delay;
};

