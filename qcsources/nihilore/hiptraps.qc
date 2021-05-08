void() spikemine_Home = 
{
	local entity head;
	local entity selected;
	local float cur_dist;
	local float head_dist;
	local vector dir;
	local vector vtemp;
	self.frame = self.frame + COUNTER_TOGGLE;
	if (self.frame == TE_LIGHTNING3)
	{
		self.frame = SERVOBOD_NONE;
	}
	self.nextthink = time + 0.2;
	self.think = spikemine_Home;
	if (self.search_time < time)
	{
		selected = world;
		cur_dist = 2000;
		head = findradius(self.origin, 2000);
		while (head)
		{
			if (!(head.flags & FL_NOTARGET) && (head.flags & FL_CLIENT))
			{
				if (visible(head) && head.health > SERVOBOD_NONE)
				{
					head_dist = vlen(head.origin - self.origin);
					if (head_dist < cur_dist)
					{
						selected = head;
						cur_dist = head_dist;
					}
				}
			}
			head = head.chain;
		}
		if (selected != world)
		{
			sound(self, CHAN_VOICE, "hipitems/spikmine.wav", COUNTER_TOGGLE, ATTN_NORM);
		}
		self.enemy = selected;
		self.search_time = time + 1.3;
	}
	if (self.enemy == world)
	{
		sound(self, CHAN_VOICE, "misc/null.wav", COUNTER_TOGGLE, ATTN_NORM);
		self.velocity = VEC_ORIGIN;
		return;
	}
	vtemp = self.enemy.origin + '0 0 10';
	dir = normalize(vtemp - self.origin);
	if (infront(self.enemy))
	{
		self.velocity = dir * (skill * 50 + 50);
	}
	else
	{
		self.velocity = dir * (skill * 50 + 150);
	}
};

void() spikemine_Touch = 
{
	if (self.health > SERVOBOD_NONE)
	{
		if (other.classname == "trap_spike_mine")
		{
			return;
		}
		if (other.classname == "missile")
		{
			return;
		}
		if (other.classname == "grenade")
		{
			return;
		}
		if (other.classname == "hiplaser")
		{
			return;
		}
		if (other.classname == "proximity_grenade")
		{
			return;
		}
		T_Damage(self, self, self, self.health + SVC_SETVIEWANGLES);
	}
	T_RadiusDamage(self, self, 110, world);
	sound(self, CHAN_WEAPON, "weapons/r_exp3.wav", COUNTER_TOGGLE, ATTN_NORM);
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord(MSG_BROADCAST, self.origin_x);
	WriteCoord(MSG_BROADCAST, self.origin_y);
	WriteCoord(MSG_BROADCAST, self.origin_z);
	sound(self, CHAN_VOICE, "misc/null.wav", COUNTER_TOGGLE, ATTN_NORM);
	self.velocity = VEC_ORIGIN;
	self.touch = SUB_Null;
	setmodel(self, "progs/s_explod.spr");
	self.solid = SOLID_NOT;
	s_explode1();
};

void() spike_mine_first_think = 
{
	self.think = spikemine_Home;
	self.nextthink = time + 0.1;
	self.search_time = SERVOBOD_NONE;
	self.takedamage = DAMAGE_AIM;
	self.use = monster_use;
};

void() trap_spike_mine = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/spikmine.mdl");
	precache_sound("weapons/r_exp3.wav");
	precache_sound("hipitems/spikmine.wav");
	precache_sound("misc/null.wav");
	setmodel(self, "progs/spikmine.mdl");
	setsize(self, self.mins, self.maxs);
	self.classname = "trap_spike_mine";
	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_FLYMISSILE;
	self.avelocity = '-50 100 150';
	if (cvar("skill") <= COUNTER_TOGGLE)
	{
		self.health = 200;
	}
	else
	{
		self.health = 400;
	}
	self.frame = SERVOBOD_NONE;
	self.think = spike_mine_first_think;
	self.touch = spikemine_Touch;
	self.th_die = spikemine_Touch;
	self.th_stand = spikemine_Home;
	self.th_walk = spikemine_Home;
	self.th_run = spikemine_Home;
	self.th_melee = spikemine_Home;
	self.th_missile = spikemine_Home;
	self.nextthink = time + 0.2;
	total_monsters = total_monsters + COUNTER_TOGGLE;
	self.flags = self.flags | FL_MONSTER;
	self.deathtype = "was blasted by a spike mine";
};

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
			sound(self, CHAN_AUTO, "weapons/lstart.wav", LIGHTNING_RANDOM, ATTN_NORM);
		}
		else
		{
			sound(self, CHAN_AUTO, "weapons/lhit.wav", LIGHTNING_RANDOM, ATTN_NORM);
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
	if (remainder > SERVOBOD_NONE)
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
	if (self.cnt == SERVOBOD_NONE)
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
		self.cnt = SERVOBOD_NONE;
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
	self.nextthink = SERVOBOD_NONE;
	if (self.classname != "trap_lightning_triggered")
	{
		self.nextthink = self.huntingcharmer + self.wait + self.ltime;
		self.think = lightning_think;
	}
};

void() trap_lightning_triggered = 
{
	if (self.wait == SERVOBOD_NONE)
	{
		self.wait = LIGHTNING_RANDOM;
	}
	if (self.dmg == SERVOBOD_NONE)
	{
		self.dmg = SVC_INTERMISSION;
	}
	if (self.duration == SERVOBOD_NONE)
	{
		self.duration = 0.1;
	}
	self.cnt = SERVOBOD_NONE;
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

void() trap_tesla_scan = 
{
	local entity head;
	local entity prev;
	tesla_numtargets = SERVOBOD_NONE;
	head = findradius(self.origin, self.distance);
	while (head)
	{
		if (!(head.flags & FL_NOTARGET) && (head.flags & self.cnt))
		{
			if (visible(head) && head.health > SERVOBOD_NONE)
			{
				if (tesla_numtargets == SERVOBOD_NONE)
				{
					tesla_target = head;
				}
				else
				{
					prev.next_ent = head;
				}
				tesla_numtargets = tesla_numtargets + LIGHTNING_RANDOM;
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
	self.owner.attack_state = LIGHTNING_BOOM;
	if (time > self.delay)
	{
		remove(self);
		return;
	}
	traceline(self.origin, self.enemy.origin, 1, self);
	if (trace_fraction != LIGHTNING_RANDOM || self.enemy.health <= SERVOBOD_NONE || vlen(self.origin - self.enemy.origin) > self.distance + SVC_SETVIEWANGLES)
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
	if (self.duration > SERVOBOD_NONE)
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
	if (self.state == SERVOBOD_NONE)
	{
		self.nextthink = time + 0.25;
		return;
	}
	if (self.attack_state == SERVOBOD_NONE)
	{
		self.think = trap_tesla_think;
		trap_tesla_scan();
		if (tesla_numtargets > SERVOBOD_NONE)
		{
			if (self.wait > SERVOBOD_NONE)
			{
				sound(self, CHAN_AUTO, "misc/tesla.wav", LIGHTNING_RANDOM, ATTN_NORM);
			}
			self.attack_state = LIGHTNING_RANDOM;
			self.nextthink = time + self.wait;
			return;
		}
		self.nextthink = time + 0.25;
		if (self.delay > SERVOBOD_NONE)
		{
			if (time > self.search_time)
			{
				self.attack_state = SERVOBOD_LEFT;
			}
		}
	}
	else
	{
		if (self.attack_state == LIGHTNING_RANDOM)
		{
			trap_tesla_scan();
			while (tesla_numtargets > SERVOBOD_NONE)
			{
				sound(self, CHAN_AUTO, "hipweap/mjolhit.wav", LIGHTNING_RANDOM, ATTN_NORM);
				SpawnTeslaLightning(tesla_target);
				tesla_target = tesla_target.next_ent;
				tesla_numtargets = tesla_numtargets - LIGHTNING_RANDOM;
			}
			self.attack_state = LIGHTNING_BOOM;
			self.nextthink = time + LIGHTNING_RANDOM;
		}
		else
		{
			if (self.attack_state == LIGHTNING_BOOM)
			{
				self.attack_state = SERVOBOD_LEFT;
				self.nextthink = time + 0.2;
			}
			else
			{
				if (self.attack_state == SERVOBOD_LEFT)
				{
					self.attack_state = SERVOBOD_NONE;
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
	precache_sound("hipweap/mjolhit.wav");
	if (self.wait == SERVOBOD_NONE)
	{
		self.wait = LIGHTNING_BOOM;
	}
	if (self.dmg == SERVOBOD_NONE)
	{
		self.dmg = LIGHTNING_BOOM + SVC_SETVIEWPORT * cvar("skill");
	}
	if (self.duration == SERVOBOD_NONE)
	{
		self.duration = CONTENT_EMPTY;
	}
	if (self.distance == SERVOBOD_NONE)
	{
		self.distance = 600;
	}
	if (self.spawnflags & LIGHTNING_RANDOM)
	{
		self.cnt = FL_CLIENT | FL_MONSTER;
	}
	else
	{
		self.cnt = FL_CLIENT;
	}
	self.use = trap_lightning_switched_use;
	if (self.delay == SERVOBOD_NONE)
	{
		self.delay = CONTENT_EMPTY;
	}
	self.nextthink = time + random();
	self.think = trap_tesla_think;
	self.lastvictim = world;
	tesla_numtargets = SERVOBOD_NONE;
	self.attack_state = SERVOBOD_NONE;
	self.deathtype = "is electrocuted";
};

void() trap_gods_wrath_use = 
{
	if (self.attack_state == SERVOBOD_NONE)
	{
		self.search_time = time + self.delay;
		self.lastvictim = activator;
		trap_tesla_think();
	}
};

void() trap_gods_wrath = 
{
	if (self.delay == SERVOBOD_NONE)
	{
		self.delay = SVC_SETVIEWPORT;
	}
	trap_tesla_coil();
	self.wait = SERVOBOD_NONE;
	self.state = LIGHTNING_RANDOM;
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
	while (tesla_numtargets > SERVOBOD_NONE)
	{
		delta = self.origin - tesla_target.origin;
		dir = normalize(delta);
		vel = dir * self.speed;
		tesla_target.velocity = tesla_target.velocity + vel;
		tesla_target = tesla_target.next_ent;
		tesla_numtargets = tesla_numtargets - LIGHTNING_RANDOM;
	}
	self.nextthink = time + 0.1;
};

void() trap_gravity_well = 
{
	self.solid = SOLID_TRIGGER;
	self.movetype = MOVETYPE_NONE;
	setsize(self, '-16 -16 -16', '16 16 16');
	if (self.dmg == SERVOBOD_NONE)
	{
		self.dmg = 10000;
	}
	if (self.speed == SERVOBOD_NONE)
	{
		self.speed = 210;
	}
	if (self.distance == SERVOBOD_NONE)
	{
		self.distance = 600;
	}
	if (self.spawnflags & LIGHTNING_RANDOM)
	{
		self.cnt = FL_CLIENT | FL_MONSTER;
	}
	else
	{
		self.cnt = FL_CLIENT;
	}
	self.attack_finished = SERVOBOD_NONE;
	self.think = trap_gravity_think;
	self.touch = trap_gravity_touch;
	self.lastvictim = world;
	tesla_numtargets = SERVOBOD_NONE;
	self.nextthink = time + 0.1;
	self.ltime = time;
};

