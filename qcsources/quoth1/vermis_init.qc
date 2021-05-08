void() VermisFoundTarget = 
{
	if (self.enemy.classname == "player")
	{
		sight_entity = self;
		sight_entity_time = time;
	}
	self.show_hostile = time + LIGHTNING_RANDOM;
	self.goalentity = self.enemy;
	if (self.coiled != MSG_BROADCAST)
	{
		self.think = vermis_wake1;
		sound(self, CHAN_VOICE, "vermis/sight.wav", LIGHTNING_RANDOM, 0.4);
	}
	else
	{
		self.think = vermis_trans1;
		sound(self, CHAN_VOICE, "vermis/sight2.wav", LIGHTNING_RANDOM, 0.4);
	}
	self.th_stand = vermis_idle1;
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	self.nextthink = time + 0.1;
	self.shield = LIGHTNING_RANDOM;
};

void() vermis_use = 
{
	if (self.enemy)
	{
		return;
	}
	if (self.health <= MSG_BROADCAST)
	{
		return;
	}
	if (activator.items & IT_INVISIBILITY)
	{
		return;
	}
	if (activator.flags & FL_NOTARGET)
	{
		return;
	}
	if (activator.classname != "player")
	{
		return;
	}
	self.enemy = activator;
	self.nextthink = time + 0.1;
	self.think = VermisFoundTarget;
};

float() VermisFindTarget = 
{
	local entity client;
	local float r;
	if (sight_entity_time >= time - 0.1 && !(self.spawnflags & AS_MELEE))
	{
		client = sight_entity;
		if (client.enemy == self.enemy)
		{
			return 0;
		}
	}
	else
	{
		client = checkclient();
		if (!client)
		{
			return 0;
		}
	}
	if (client == self.enemy)
	{
		return 0;
	}
	if (client.flags & FL_NOTARGET)
	{
		return 0;
	}
	if (client.items & IT_INVISIBILITY)
	{
		return 0;
	}
	r = range(client);
	if (r == RANGE_FAR)
	{
		return 0;
	}
	if (!visible(client))
	{
		return 0;
	}
	if (r == RANGE_NEAR)
	{
		if (client.show_hostile < time && !infront(client))
		{
			return 0;
		}
	}
	else
	{
		if (r == RANGE_MID)
		{
			if (!infront(client))
			{
				return 0;
			}
		}
	}
	self.enemy = client;
	if (self.enemy.classname != "player")
	{
		self.enemy = self.enemy.enemy;
		if (self.enemy.classname != "player")
		{
			self.enemy = world;
			return 0;
		}
	}
	VermisFoundTarget();
	return 1;
};

void() vermis_start_go = 
{
	if (!(self.spawnflags & TRIGGER_SPAWN))
	{
		self.origin_z = self.origin_z + LIGHTNING_RANDOM;
	}
	self.takedamage = DAMAGE_AIM;
	self.ideal_yaw = self.angles * '0 1 0';
	if (!(self.yaw_speed))
	{
		self.yaw_speed = 15;
	}
	self.view_ofs = '0 0 25';
	self.use = vermis_use;
	self.flags = self.flags | FL_MONSTER;
	self.flags = self.flags | FL_FLY;
	self.pausetime = 100000000;
	self.th_stand();
	self.nextthink = self.nextthink + random() * 0.5;
	if (self.spawnflags & TRIGGER_SPAWN && (self.spawnflags & TRIGGER_AWAKE) && !(activator.items & IT_INVISIBILITY) && !(activator.flags & FL_NOTARGET) && activator.classname == "player")
	{
		self.enemy = activator;
		self.nextthink = time + 0.1;
		self.think = FoundTarget;
	}
	if (self.awake == LIGHTNING_RANDOM && !(self.enemy.items & IT_INVISIBILITY) && !(self.enemy.flags & FL_NOTARGET) && self.enemy.classname == "player")
	{
		self.nextthink = time + 0.1;
		self.think = FoundTarget;
	}
};

void() vermis_start = 
{
	if (!(self.spawnflags & TRIGGER_SPAWN))
	{
		self.nextthink = self.nextthink + random() * 0.5;
		self.think = vermis_start_go;
	}
	else
	{
		vermis_start_go();
	}
	total_monsters = total_monsters + LIGHTNING_RANDOM;
};

