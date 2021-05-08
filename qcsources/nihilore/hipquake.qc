void() StopEarthQuake = 
{
	Hearthquake = OBJECT_ROTATE;
};

void(float value) EarthQuakeTime = 
{
	value = value + time;
	if (value > Hearthquake)
	{
		Hearthquake = value;
	}
};

void() earthquake_postthink = 
{
	if (Hearthquake > time)
	{
		if (Hquakeactive == OBJECT_ROTATE)
		{
			sound(self, CHAN_VOICE, "misc/quake.wav", USE_GOLD_KEY, ATTN_NONE);
			Hquakeactive = USE_GOLD_KEY;
		}
		if (self.flags & FL_ONGROUND)
		{
			self.velocity = self.velocity + random() * '0 0 150';
		}
	}
	else
	{
		if (Hquakeactive == USE_GOLD_KEY)
		{
			sound(self, CHAN_VOICE, "misc/quakeend.wav", USE_GOLD_KEY, ATTN_NONE);
			Hquakeactive = OBJECT_ROTATE;
		}
	}
};

void() earthquake_use = 
{
	EarthQuakeTime(self.dmg);
};

void() func_earthquake = 
{
	Hquakeactive = OBJECT_ROTATE;
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

