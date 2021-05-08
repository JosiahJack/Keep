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
	LightningDamage(self.origin, self.oldorigin, self.lastvictim, self.dmg);
	self.nextthink = time + 0.1;
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
		if (self.spawnflags & LIGHTNING_BOOM)
		{
			sound(self, CHAN_AUTO, "weapons/lstart.wav", 1, ATTN_NORM);
		}
		else
		{
			sound(self, CHAN_AUTO, "weapons/lhit.wav", 1, ATTN_NORM);
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
	if (remainder > 0)
	{
		remainder = remainder - 1;
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
		SpawnLightningThink();
		self = temp;
	}
	else
	{
		if (checkclient())
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
			LightningDamage(p1, p2, self, self.dmg);
		}
		else
		{
			LightningDamage(p1, p2, self, self.dmg);
		}
	}
};

void() lightning_think = 
{
	local float timedelay;
	if (self.state)
	{
		trap_lightning_use();
	}
	if (self.cnt == 0)
	{
		if (self.spawnflags & LIGHTNING_RANDOM)
		{
			timedelay = self.wait * random();
		}
		else
		{
			timedelay = self.wait;
		}
		self.cnt = 1;
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
		self.cnt = 0;
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
	self.nextthink = 0;
	if (self.classname != "trap_lightning_triggered")
	{
		self.nextthink = self.huntingcharmer + self.wait + self.ltime;
		self.think = lightning_think;
	}
};

void() trap_lightning_triggered = 
{
	if (self.wait == 0)
	{
		self.wait = 1;
	}
	if (self.dmg == 0)
	{
		self.dmg = SVC_INTERMISSION;
	}
	if (self.duration == 0)
	{
		self.duration = 0.1;
	}
	self.cnt = 0;
	self.use = trap_lightning_use;
	precache_sound("weapons/lhit.wav");
	precache_sound("weapons/lstart.wav");
	self.huntingcharmer = self.nextthink;
	self.think = lightning_firstthink;
	self.nextthink = time + 0.25;
	self.deathtype = "is electrocuted";
};

void() trap_lightning = 
{
	trap_lightning_triggered();
	self.state = 1;
};

void() trap_lightning_switched_use = 
{
	self.state = 1 - self.state;
	if (self.state == 1)
	{
		self.nextthink = self.huntingcharmer;
	}
};

void() trap_lightning_switched = 
{
	trap_lightning_triggered();
	self.use = trap_lightning_switched_use;
};

void() trap_tesla_scan = 
{
	local entity head;
	local entity prev;
	tesla_numtargets = 0;
	head = findradius(self.origin, self.distance);
	while (head)
	{
		if (!(head.flags & FL_NOTARGET) && (head.flags & self.cnt))
		{
			if (visible(head) && head.health > 0)
			{
				if (tesla_numtargets == 0)
				{
					tesla_target = head;
				}
				else
				{
					prev.next_ent = head;
				}
				tesla_numtargets = tesla_numtargets + 1;
				prev = head;
				if (tesla_numtargets == self.count)
				{
					return;
				}
			}
		}
		head = head.chain;
	}
};

void() TeslaLightningThink = 
{
	self.owner.attack_state = FL_SWIM;
	if (time > self.delay)
	{
		remove(self);
		return;
	}
	traceline(self.origin, self.enemy.origin, 1, self);
	if (trace_fraction != 1 || self.enemy.health <= 0 || vlen(self.origin - self.enemy.origin) > self.distance + MOVETYPE_BOUNCE)
	{
		remove(self);
		return;
	}
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_LIGHTNING2);
	WriteEntity(MSG_BROADCAST, self);
	WriteCoord(MSG_BROADCAST, self.origin_x);
	WriteCoord(MSG_BROADCAST, self.origin_y);
	WriteCoord(MSG_BROADCAST, self.origin_z);
	WriteCoord(MSG_BROADCAST, trace_endpos_x);
	WriteCoord(MSG_BROADCAST, trace_endpos_y);
	WriteCoord(MSG_BROADCAST, trace_endpos_z);
	LightningDamage(self.origin, trace_endpos, self.lastvictim, self.dmg);
	self.nextthink = time + 0.1;
};

void(entity targ) SpawnTeslaLightning = 
{
	local entity lgt;
	lgt = spawn();
	if (self.duration > 0)
	{
		lgt.delay = time + self.duration;
	}
	else
	{
		lgt.delay = time + 9999;
	}
	lgt.enemy = targ;
	lgt.distance = self.distance;
	lgt.owner = self;
	lgt.lastvictim = self.lastvictim;
	lgt.dmg = self.dmg;
	lgt.origin = self.origin;
	lgt.think = TeslaLightningThink;
	lgt.nextthink = time;
	lgt.deathtype = self.deathtype;
};

void() trap_tesla_think = 
{
	if (self.state == 0)
	{
		self.nextthink = time + 0.25;
		return;
	}
	if (self.attack_state == 0)
	{
		self.think = trap_tesla_think;
		trap_tesla_scan();
		if (tesla_numtargets > 0)
		{
			if (self.wait > 0)
			{
				sound(self, CHAN_AUTO, "misc/tesla.wav", 1, ATTN_NORM);
			}
			self.attack_state = 1;
			self.nextthink = time + self.wait;
			return;
		}
		self.nextthink = time + 0.25;
		if (self.delay > 0)
		{
			if (time > self.search_time)
			{
				self.attack_state = MOVETYPE_WALK;
			}
		}
	}
	else
	{
		if (self.attack_state == 1)
		{
			trap_tesla_scan();
			while (tesla_numtargets > 0)
			{
				sound(self, CHAN_AUTO, "weapons/lstart.wav", 1, ATTN_NORM);
				SpawnTeslaLightning(tesla_target);
				tesla_target = tesla_target.next_ent;
				tesla_numtargets = tesla_numtargets - 1;
			}
			self.attack_state = FL_SWIM;
			self.nextthink = time + 1;
		}
		else
		{
			if (self.attack_state == FL_SWIM)
			{
				self.attack_state = MOVETYPE_WALK;
				self.nextthink = time + 0.2;
			}
			else
			{
				if (self.attack_state == MOVETYPE_WALK)
				{
					self.attack_state = 0;
					self.nextthink = time + 0.1;
					if (self.classname == "trap_gods_wrath")
					{
						self.nextthink = CONTENT_EMPTY;
					}
				}
			}
		}
	}
};

void() trap_tesla_coil = 
{
	precache_sound("misc/tesla.wav");
	precache_sound("weapons/lstart.wav");
	if (self.wait == 0)
	{
		self.wait = FL_SWIM;
	}
	if (self.dmg == 0)
	{
		self.dmg = FL_SWIM + MOVETYPE_FLY * cvar("skill");
	}
	if (self.duration == 0)
	{
		self.duration = CONTENT_EMPTY;
	}
	if (self.distance == 0)
	{
		self.distance = 600;
	}
	if (self.spawnflags & 1)
	{
		self.cnt = FL_CLIENT | FL_MONSTER;
	}
	else
	{
		self.cnt = FL_CLIENT;
	}
	self.use = trap_lightning_switched_use;
	if (self.delay == 0)
	{
		self.delay = CONTENT_EMPTY;
	}
	self.nextthink = time + random();
	self.think = trap_tesla_think;
	self.lastvictim = world;
	tesla_numtargets = 0;
	self.attack_state = 0;
	self.deathtype = "is electrocuted";
};

void() trap_gods_wrath_use = 
{
	if (self.attack_state == 0)
	{
		self.search_time = time + self.delay;
		self.lastvictim = activator;
		trap_tesla_think();
	}
};

void() trap_gods_wrath = 
{
	if (self.delay == 0)
	{
		self.delay = MOVETYPE_FLY;
	}
	trap_tesla_coil();
	self.wait = 0;
	self.state = 1;
	self.nextthink = CONTENT_EMPTY;
	self.deathtype = "suffers the wrath of God";
	self.use = trap_gods_wrath_use;
};

void() trap_gravity_touch = 
{
	if (self.attack_finished > time)
	{
		return;
	}
	if (other.takedamage)
	{
		T_Damage(other, self, self, self.dmg);
		self.attack_finished = time + 0.2;
	}
};

void() trap_gravity_think = 
{
	local vector vel;
	local vector dir;
	local vector delta;
	self.ltime = time;
	trap_tesla_scan();
	while (tesla_numtargets > 0)
	{
		delta = self.origin - tesla_target.origin;
		dir = normalize(delta);
		vel = dir * self.speed;
		tesla_target.velocity = tesla_target.velocity + vel;
		tesla_target = tesla_target.next_ent;
		tesla_numtargets = tesla_numtargets - 1;
	}
	self.nextthink = time + 0.1;
};

void() trap_gravity_well = 
{
	self.solid = SOLID_TRIGGER;
	self.movetype = MOVETYPE_NONE;
	setsize(self, '-16 -16 -16', '16 16 16');
	if (self.dmg == 0)
	{
		self.dmg = 10000;
	}
	if (self.speed == 0)
	{
		self.speed = 210;
	}
	if (self.distance == 0)
	{
		self.distance = 600;
	}
	if (self.spawnflags & 1)
	{
		self.cnt = FL_CLIENT | FL_MONSTER;
	}
	else
	{
		self.cnt = FL_CLIENT;
	}
	self.attack_finished = 0;
	self.think = trap_gravity_think;
	self.touch = trap_gravity_touch;
	self.lastvictim = world;
	tesla_numtargets = 0;
	self.nextthink = time + 0.1;
	self.ltime = time;
};

