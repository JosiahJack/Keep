void() play_sound_use = 
{
	if (self.spawnflags & STAYOPEN)
	{
		if (self.state == OBJECT_ROTATE)
		{
			self.state = STAYOPEN;
			sound(self, self.impulse, self.noise, self.volume, self.speed);
		}
		else
		{
			self.state = OBJECT_ROTATE;
			sound(self, self.impulse, "misc/null.wav", self.volume, self.speed);
		}
	}
	else
	{
		sound(self, self.impulse, self.noise, self.volume, self.speed);
	}
};

void() PlaySoundThink = 
{
	local float t;
	t = self.wait * random();
	if (t < self.delay)
	{
		t = self.delay;
	}
	self.nextthink = time + t;
	play_sound_use();
};

void() PlaySoundLoop_toggle = 
{
	self.state = STAYOPEN - self.state;
	if (self.state == STAYOPEN)
	{
		sound(self, self.impulse, "misc/null.wav", self.volume, self.speed);
		return;
	}
};

void() PlaySoundLoop = 
{
	self.use = PlaySoundLoop_toggle;
	if (self.state == STAYOPEN)
	{
		return;
	}
	self.nextthink = time + self.wait;
	self.think = PlaySoundLoop;
	play_sound_use();
};

void() play_sound_triggered = 
{
	precache_sound(self.noise);
	precache_sound("misc/null.wav");
	if (self.volume == OBJECT_ROTATE)
	{
		self.volume = STAYOPEN;
	}
	if (self.speed == OBJECT_ROTATE)
	{
		self.speed = STAYOPEN;
	}
	if (self.speed == CONTENT_EMPTY)
	{
		self.speed = OBJECT_ROTATE;
	}
	if (self.spawnflags & STAYOPEN)
	{
		if (self.impulse == OBJECT_ROTATE)
		{
			self.impulse = STATE_CLOSING;
		}
	}
	self.use = play_sound_use;
	if (self.wait)
	{
		self.use = PlaySoundLoop;
	}
};

void() play_sound = 
{
	local float t;
	play_sound_triggered();
	if (self.wait == OBJECT_ROTATE)
	{
		self.wait = 20;
	}
	if (self.delay == OBJECT_ROTATE)
	{
		self.delay = TOUCH;
	}
	self.think = PlaySoundThink;
	t = self.wait * random();
	if (t < self.delay)
	{
		t = self.delay;
	}
	self.nextthink = time + t;
};

