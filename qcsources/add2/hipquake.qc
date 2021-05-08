void() StopEarthQuake = 
{
	earthquake = MSG_BROADCAST;
};

void(float value) EarthQuakeTime = 
{
	value = value + time;
	if (value > earthquake)
	{
		earthquake = value;
	}
};

void() earthquake_prethink = 
{
};

void() earthquake_postthink = 
{
	if (earthquake > time)
	{
		if (quakeactive == MSG_BROADCAST)
		{
			sound(self, CHAN_VOICE, "misc/quake.wav", SPAWN_CRUCIFIED, ATTN_NONE);
			quakeactive = SPAWN_CRUCIFIED;
		}
		if (self.flags & FL_ONGROUND)
		{
			self.velocity = self.velocity + random() * '0 0 150';
		}
	}
	else
	{
		if (quakeactive == SPAWN_CRUCIFIED)
		{
			sound(self, CHAN_VOICE, "misc/quakeend.wav", SPAWN_CRUCIFIED, ATTN_NONE);
			quakeactive = MSG_BROADCAST;
		}
	}
};

void() earthquake_use = 
{
	EarthQuakeTime(self.dmg);
};

void() func_earthquake = 
{
	quakeactive = MSG_BROADCAST;
	precache_sound("misc/quake.wav");
	precache_sound("misc/quakeend.wav");
	self.classname = "earthquake";
	self.use = earthquake_use;
	self.think = SUB_Null;
	if (!(self.dmg))
	{
		self.dmg = 0.8;
	}
};

