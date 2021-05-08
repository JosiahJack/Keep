void() monster_fade_start = 
{
	local vector neworigin;
	if (self.mlah == MSG_BROADCAST)
	{
		self.movetype = MOVETYPE_NONE;
	}
	neworigin = self.origin;
	neworigin_z = neworigin_z - SPAWNFLAG_SUPERSPIKE;
	setorigin(self, neworigin);
	self.nextthink = time + 0.1;
	self.think = monster_fade_start;
	self.mlah = self.mlah + SPAWNFLAG_SUPERSPIKE;
	if (self.mlah >= 40)
	{
		self.think = SUB_Remove;
	}
};

void() monster_fade = 
{
	self.solid = SOLID_TRIGGER;
	setorigin(self, self.origin);
	if (!(self.corpse_time))
	{
		self.nextthink = time + CORPSE_TIME_GLOBAL;
	}
	else
	{
		if (self.corpse_time == CONTENT_EMPTY)
		{
			self.nextthink = time + 99999;
		}
		else
		{
			self.nextthink = time + self.corpse_time;
		}
	}
	self.think = monster_fade_start;
};

void() monster_spawn = 
{
	spawn_tdeath(self.origin, self);
	self.use = monster_use;
};

