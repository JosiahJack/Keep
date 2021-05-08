void() Rearthquake_rumble = 
{
	if (self.attack_finished < time)
	{
		stop_Rearthquake();
	}
	else
	{
		sound(self, CHAN_VOICE, "misc/rumble.wav", EQ_RANDOM, ATTN_NONE);
		self.think = Rearthquake_rumble;
		self.nextthink = time + EQ_RANDOM;
	}
};

void() start_Rearthquake = 
{
	Rearthquake_active = EQ_RANDOM;
	if (self.spawnflags & EQ_RANDOM)
	{
		self.attack_finished = time + random() * self.delay;
	}
	else
	{
		self.attack_finished = time + self.delay;
	}
	Rearthquake_rumble();
};

void() stop_Rearthquake = 
{
	Rearthquake_active = OBJECT_ROTATE;
	self.think = start_Rearthquake;
	if (self.spawnflags & EQ_RANDOM)
	{
		self.nextthink = time + random() * self.wait;
	}
	else
	{
		self.nextthink = time + self.wait;
	}
};

void() earthquake = 
{
	if (!(self.delay))
	{
		self.delay = 20;
	}
	if (!(self.wait))
	{
		self.wait = 60;
	}
	if (!(self.weapon))
	{
		self.weapon = APOCCAM_IMPULSE;
	}
	precache_sound("misc/rumble.wav");
	Rearthquake_active = OBJECT_ROTATE;
	Rearthquake_intensity = self.weapon * 0.5;
	setsize(self, VEC_ORIGIN, VEC_ORIGIN);
	self.think = stop_Rearthquake;
	self.nextthink = time + EQ_RANDOM;
};

void() Rearthquake_touch = 
{
	if (self.delay)
	{
		if (self.attack_finished < time)
		{
			sound(self, CHAN_VOICE, "misc/rumble.wav", EQ_RANDOM, ATTN_NORM);
			self.attack_finished = time + EQ_RANDOM;
		}
		if (other.classname == "player")
		{
			if (other.flags & FL_ONGROUND)
			{
				other.velocity_x = other.velocity_x + random() * self.weapon * TOUCH - self.weapon;
				other.velocity_y = other.velocity_y + random() * self.weapon * TOUCH - self.weapon;
				other.velocity_z = other.velocity_z + random() * self.weapon * TOUCH - self.weapon;
			}
		}
	}
};

void() Rearthquake_use = 
{
	self.delay = !(self.delay);
};

void() trigger_earthquake = 
{
	precache_sound("misc/rumble.wav");
	if (!(self.weapon))
	{
		self.weapon = APOCCAM_IMPULSE;
	}
	self.weapon = self.weapon * 0.5;
	self.delay = EQ_RANDOM;
	self.touch = Rearthquake_touch;
	if (self.targetname)
	{
		self.use = Rearthquake_use;
		self.delay = OBJECT_ROTATE;
	}
	InitTrigger();
};

void() kill_Rearthquake = 
{
	local entity eq;
	if (other.classname != "player")
	{
		return;
	}
	eq = find(world, classname, "earthquake");
	if (eq != world)
	{
		Rearthquake_active = OBJECT_ROTATE;
		remove(eq);
	}
};

void() trigger_earthquake_kill = 
{
	self.touch = kill_Rearthquake;
	InitTrigger();
};

