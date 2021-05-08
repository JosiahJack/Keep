void() StopEarthQuake = 
{
	earthquake = 0;
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
		if (quakeactive == 0)
		{
			sound(self, CHAN_VOICE, "misc/quake.wav", 1, ATTN_NONE);
			quakeactive = 1;
		}
		if (self.flags & FL_ONGROUND)
		{
			self.velocity = self.velocity + random() * '0 0 150';
		}
	}
	else
	{
		if (quakeactive == 1)
		{
			sound(self, CHAN_VOICE, "misc/quakeend.wav", 1, ATTN_NONE);
			quakeactive = 0;
		}
	}
};

void() earthquake_use = 
{
	EarthQuakeTime(self.dmg);
};

void() func_earthquake = 
{
	quakeactive = 0;
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

