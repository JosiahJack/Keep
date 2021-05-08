void() SpawnLightningThink = 
{
	if (time > self.delay)
	{
		remove(self);
		return;
	}
	self.think = SpawnLightningThink;
	if (checkclient())
	{
		if (self.style == MSG_BROADCAST)
		{
			WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
			WriteByte(MSG_BROADCAST, TE_LIGHTNING2);
			WriteEntity(MSG_BROADCAST, self);
			WriteCoord(MSG_BROADCAST, self.origin_x);
			WriteCoord(MSG_BROADCAST, self.origin_y);
			WriteCoord(MSG_BROADCAST, self.origin_z);
			WriteCoord(MSG_BROADCAST, self.oldorigin_x);
			WriteCoord(MSG_BROADCAST, self.oldorigin_y);
			WriteCoord(MSG_BROADCAST, self.oldorigin_z);
		}
		else
		{
			if (self.style == LIGHTNING_RANDOM)
			{
				WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
				WriteByte(MSG_BROADCAST, TE_LIGHTNING1);
				WriteEntity(MSG_BROADCAST, self);
				WriteCoord(MSG_BROADCAST, self.origin_x);
				WriteCoord(MSG_BROADCAST, self.origin_y);
				WriteCoord(MSG_BROADCAST, self.origin_z);
				WriteCoord(MSG_BROADCAST, self.oldorigin_x);
				WriteCoord(MSG_BROADCAST, self.oldorigin_y);
				WriteCoord(MSG_BROADCAST, self.oldorigin_z);
			}
		}
	}
	LightningDamage(self.origin, self.oldorigin, self.lastvictim, self.dmg);
	self.nextthink = time + 0.1;
};

void() LightningClear = 
{
	if (self.style == MSG_BROADCAST)
	{
		WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte(MSG_BROADCAST, TE_LIGHTNING2);
		WriteEntity(MSG_BROADCAST, self);
		WriteCoord(MSG_BROADCAST, IT_AXE);
		WriteCoord(MSG_BROADCAST, IT_AXE);
		WriteCoord(MSG_BROADCAST, IT_AXE);
		WriteCoord(MSG_BROADCAST, IT_AXE);
		WriteCoord(MSG_BROADCAST, IT_AXE);
		WriteCoord(MSG_BROADCAST, IT_AXE);
	}
	else
	{
		if (self.style == LIGHTNING_RANDOM)
		{
			WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
			WriteByte(MSG_BROADCAST, TE_LIGHTNING1);
			WriteEntity(MSG_BROADCAST, self);
			WriteCoord(MSG_BROADCAST, IT_AXE);
			WriteCoord(MSG_BROADCAST, IT_AXE);
			WriteCoord(MSG_BROADCAST, IT_AXE);
			WriteCoord(MSG_BROADCAST, IT_AXE);
			WriteCoord(MSG_BROADCAST, IT_AXE);
			WriteCoord(MSG_BROADCAST, IT_AXE);
		}
	}
};

void() trap_lightning_use = 
{
	local vector p1;
	local vector p2;
	local vector dir;
	local float dst;
	local float remainder;
	local entity temp;
	if (time >= self.pausetime)
	{
		if (self.silentlightning == MSG_BROADCAST)
		{
			if (self.coiled == MSG_BROADCAST)
			{
				if (!(self.noise))
				{
					if (self.spawnflags & LIGHTNING_BOOM)
					{
						sound(self, CHAN_AUTO, "weapons/lstart.wav", LIGHTNING_RANDOM, ATTN_NORM);
					}
					else
					{
						sound(self, CHAN_AUTO, "weapons/lhit.wav", LIGHTNING_RANDOM, ATTN_NORM);
					}
				}
				else
				{
					sound(self, CHAN_AUTO, self.noise, LIGHTNING_RANDOM, ATTN_NORM);
				}
			}
		}
		if (self.classname == "trap_lightning_triggered")
		{
			self.pausetime = time + 0.1;
		}
	}
	if (self.target)
	{
		p1 = self.origin;
		p2 = self.enemy.origin;
	}
	else
	{
		makevectors(self.angles);
		self.movedir = v_forward;
		traceline(self.origin, self.origin + self.movedir * 600, 1, self);
		p1 = self.origin;
		p2 = trace_endpos;
	}
	dir = normalize(p2 - p1);
	dst = vlen(p2 - p1);
	dst = dst / SVC_INTERMISSION;
	remainder = dst - floor(dst);
	if (remainder > MSG_BROADCAST)
	{
		remainder = remainder - LIGHTNING_RANDOM;
		remainder = remainder * 15;
		p1 = p1 + remainder * dir;
		p2 = p2 - remainder * dir;
	}
	if (self.duration > 0.1)
	{
		temp = self;
		self = spawn();
		self.origin = p1;
		self.oldorigin = p2;
		self.lastvictim = temp;
		self.dmg = temp.dmg;
		self.delay = time + temp.duration;
		self.style = temp.style;
		SpawnLightningThink();
		self = temp;
	}
	else
	{
		if (self.style == MSG_BROADCAST)
		{
			WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
			WriteByte(MSG_BROADCAST, TE_LIGHTNING2);
			WriteEntity(MSG_BROADCAST, self);
			WriteCoord(MSG_BROADCAST, p1_x);
			WriteCoord(MSG_BROADCAST, p1_y);
			WriteCoord(MSG_BROADCAST, p1_z);
			WriteCoord(MSG_BROADCAST, p2_x);
			WriteCoord(MSG_BROADCAST, p2_y);
			WriteCoord(MSG_BROADCAST, p2_z);
		}
		else
		{
			if (self.style == LIGHTNING_RANDOM)
			{
				WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
				WriteByte(MSG_BROADCAST, TE_LIGHTNING1);
				WriteEntity(MSG_BROADCAST, self);
				WriteCoord(MSG_BROADCAST, p1_x);
				WriteCoord(MSG_BROADCAST, p1_y);
				WriteCoord(MSG_BROADCAST, p1_z);
				WriteCoord(MSG_BROADCAST, p2_x);
				WriteCoord(MSG_BROADCAST, p2_y);
				WriteCoord(MSG_BROADCAST, p2_z);
			}
		}
		LightningDamage(p1, p2, self, self.dmg);
		self.nextthink = time + self.duration;
		self.think = LightningClear;
	}
};

void() lightning_think = 
{
	local float timedelay;
	if (self.state)
	{
		trap_lightning_use();
	}
	if (self.cnt == MSG_BROADCAST)
	{
		if (self.spawnflags & LIGHTNING_RANDOM)
		{
			timedelay = self.wait * random();
		}
		else
		{
			timedelay = self.wait;
		}
		self.cnt = LIGHTNING_RANDOM;
		self.t_length = time + self.duration - 0.1;
		self.pausetime = time + self.duration - 0.1;
		if (self.pausetime < time + 0.3)
		{
			self.pausetime = time + 0.3;
		}
		if (timedelay < self.duration)
		{
			timedelay = self.duration;
		}
		self.t_width = time + timedelay;
	}
	if (time >= self.t_length)
	{
		self.cnt = MSG_BROADCAST;
		self.nextthink = self.t_width;
	}
	else
	{
		self.nextthink = time + 0.2;
	}
};

void() lightning_firstthink = 
{
	local entity targ;
	if (self.target)
	{
		targ = find(world, targetname, self.target);
		self.dest = targ.origin;
		self.enemy = targ;
	}
	self.think = SUB_Null;
	self.nextthink = MSG_BROADCAST;
	if (self.classname != "trap_lightning_triggered")
	{
		self.nextthink = self.huntingcharmer + self.wait + self.ltime;
		self.think = lightning_think;
	}
};

void() trap_lightning_triggered = 
{
	if (self.wait == MSG_BROADCAST)
	{
		self.wait = LIGHTNING_RANDOM;
	}
	if (self.dmg == MSG_BROADCAST)
	{
		self.dmg = SVC_INTERMISSION;
	}
	if (self.duration == MSG_BROADCAST)
	{
		self.duration = 0.1;
	}
	self.cnt = MSG_BROADCAST;
	self.use = trap_lightning_use;
	if (self.coiled == MSG_BROADCAST)
	{
		if (self.noise)
		{
			precache_sound(self.noise);
		}
		else
		{
			precache_sound("weapons/lhit.wav");
			precache_sound("weapons/lstart.wav");
		}
	}
	self.huntingcharmer = self.nextthink;
	self.think = lightning_firstthink;
	self.nextthink = time + 0.25;
	self.deathtype = "was electrocuted";
};

void() trap_lightning = 
{
	trap_lightning_triggered();
	self.state = LIGHTNING_RANDOM;
};

void() trap_lightning_switched_use = 
{
	self.state = LIGHTNING_RANDOM - self.state;
	if (self.state == LIGHTNING_RANDOM)
	{
		self.nextthink = self.huntingcharmer;
	}
};

void() trap_lightning_switched = 
{
	trap_lightning_triggered();
	self.use = trap_lightning_switched_use;
};

