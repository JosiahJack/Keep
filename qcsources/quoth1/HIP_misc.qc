void() blocker_touch = 
{
	if (!(self.dmg))
	{
		return;
	}
	if (time < self.attack_finished)
	{
		return;
	}
	self.attack_finished = time + self.wait;
	T_Damage(other, self, self, self.dmg);
};

void() blocker_use = 
{
	if (!(self.state))
	{
		self.state = STAYOPEN;
		setorigin(self, self.origin - '8000 8000 8000');
		sound(self, CHAN_VOICE, self.noise1, STAYOPEN, ATTN_NORM);
	}
	else
	{
		self.state = OBJECT_ROTATE;
		setorigin(self, self.origin + '8000 8000 8000');
		sound(self, CHAN_VOICE, self.noise, STAYOPEN, ATTN_NORM);
	}
};

void() func_togglewall = 
{
	self.classname = "togglewall";
	self.movetype = MOVETYPE_PUSH;
	self.mdl = self.model;
	setmodel(self, self.model);
	setsize(self, self.mins, self.maxs);
	setorigin(self, self.origin);
	self.touch = blocker_touch;
	self.use = blocker_use;
	if (!(self.noise))
	{
		self.noise = "misc/null.wav";
	}
	if (!(self.noise1))
	{
		self.noise1 = "misc/null.wav";
	}
	if (!(self.wait))
	{
		self.wait = 0.5;
	}
	precache_sound(self.noise);
	precache_sound(self.noise1);
	self.solid = SOLID_BSP;
	self.model = string_null;
	if (self.spawnflags & START_OFF)
	{
		self.state = OBJECT_ROTATE;
		setorigin(self, self.origin + '8000 8000 8000');
	}
	else
	{
		self.state = STAYOPEN;
		sound(self, CHAN_VOICE, self.noise1, STAYOPEN, ATTN_NORM);
	}
};

