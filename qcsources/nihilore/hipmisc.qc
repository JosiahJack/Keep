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

void() random_thunder = 
{
	self.noise = "ambience/thunder1.wav";
	play_sound();
	self.impulse = STATE_OPENING;
};

void() random_thunder_triggered = 
{
	self.noise = "ambience/thunder1.wav";
	play_sound_triggered();
	self.impulse = STATE_OPENING;
};

void() info_command = 
{
	if (self.message)
	{
		localcmd(self.message);
	}
};

void() effect_teleport_use = 
{
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_TELEPORT);
	WriteCoord(MSG_BROADCAST, self.origin_x);
	WriteCoord(MSG_BROADCAST, self.origin_y);
	WriteCoord(MSG_BROADCAST, self.origin_z);
	sound(self, CHAN_VOICE, "misc/r_tele1.wav", STAYOPEN, ATTN_NORM);
};

void() effect_teleport = 
{
	precache_sound("misc/r_tele1.wav");
	self.use = effect_teleport_use;
};

void() wallsprite = 
{
	if (!(self.model))
	{
		self.model = "progs/s_blood1.spr";
	}
	precache_model(self.model);
	setmodel(self, self.model);
	if (self.angles == '0 -1 0')
	{
		self.angles = '-90 0 0';
	}
	else
	{
		if (self.angles == '0 -2 0')
		{
			self.angles = '90 0 0';
		}
	}
	makevectors(self.angles);
	setorigin(self, self.origin - v_forward * 0.2);
	makestatic(self);
};

