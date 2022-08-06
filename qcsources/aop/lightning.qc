void() light_lightning_use = 
{
	local float r;
	r = random();
	if (r < 0.1)
	{
		if (world.model == "maps/start.bsp")
		{
			if (deathmatch || coop)
			{
				return;
			}
			else
			{
				sound(self, CHAN_AUTO, "ambience/rain1.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NONE);
			}
		}
	}
	r = random();
	if (r < 0.1)
	{
		lightstyle(12, "m");
		if (r < 0.05)
		{
			sound(self, CHAN_AUTO, "ambience/thunder1.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
		}
		else
		{
			sound(self, CHAN_AUTO, "ambience/thunder2.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
		}
	}
	else
	{
		lightstyle(12, "a");
	}
	self.nextthink = time + 0.3;
	self.think = light_lightning_use;
};

void() light_lightning = 
{
	precache_sound("ambience/thunder1.wav");
	precache_sound("ambience/thunder2.wav");
	precache_sound("ambience/rain1.wav");
	lightstyle(12, "m");
	self.nextthink = time + 0.3;
	self.think = light_lightning_use;
};

void() play_sound_lightning = 
{
	local float r;
	r = random();
	if (world.model == "maps/start.bsp")
	{
		if (deathmatch || coop)
		{
			return;
		}
		else
		{
			sound(self, CHAN_AUTO, "ambience/rain1.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NONE);
		}
	}
	if (r < 0.5)
	{
		sound(self, CHAN_AUTO, "ambience/thunder1.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NONE);
	}
	else
	{
		sound(self, CHAN_AUTO, "ambience/thunder2.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NONE);
	}
};

void() sound_trigger_lightning = 
{
	precache_sound2("ambience/thunder1.wav");
	precache_sound2("ambience/thunder2.wav");
	precache_sound2("ambience/rain1.wav");
	self.use = play_sound_lightning;
};

void() light_lightning2 = 
{
	local float r;
	r = random();
	if (r < 0.030000)
	{
		lightstyle(self.style, "m");
		if (world.model == "maps/start.bsp")
		{
			if (deathmatch || coop)
			{
				return;
			}
			else
			{
				sound(self, CHAN_AUTO, "ambience/rain1.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
			}
		}
		r = random();
		if (r < 0.015000)
		{
			sound(self, CHAN_AUTO, "ambience/thunder1.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
		}
		else
		{
			sound(self, CHAN_AUTO, "ambience/thunder2.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
		}
	}
	else
	{
		lightstyle(self.style, "a");
	}
	self.nextthink = time + 0.1;
	self.think = light_lightning2;
};

void() traplight_use = 
{
	local vector org;
	local vector des;
	local entity targ;
	targ = find(world, targetname, self.target);
	org = self.origin;
	des = targ.origin;
	if (!(self.dmg))
	{
		self.dmg = TE_LIGHTNING1;
	}
	traceline(org, des, 1, self);
	sound(self, CHAN_AUTO, "weapons/lhit.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_LIGHTNING2);
	WriteEntity(MSG_BROADCAST, self);
	WriteCoord(MSG_BROADCAST, org_x);
	WriteCoord(MSG_BROADCAST, org_y);
	WriteCoord(MSG_BROADCAST, org_z);
	WriteCoord(MSG_BROADCAST, trace_endpos_x);
	WriteCoord(MSG_BROADCAST, trace_endpos_y);
	WriteCoord(MSG_BROADCAST, trace_endpos_z);
	LightningDamage(org, trace_endpos, self, self.dmg);
};

void() traplight_think = 
{
	traplight_use();
	self.nextthink = time + self.wait;
};

void() trap_lightning = 
{
	self.use = traplight_use;
	if (self.wait == MSG_BROADCAST)
	{
		self.wait = 0.5;
	}
};

