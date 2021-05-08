void() spawn_think = 
{
	self.think = spawn_think;
	self.nextthink = time + STAYOPEN;
};

void(vector org) spawn_use = 
{
	local entity spawnentity;
	local entity tempself;
	spawnentity = spawn();
	SUB_CopyEntity(self.spawnmaster, spawnentity);
	spawnentity.nextthink = time + 0.2;
	spawnentity.think = spawnentity.spawnthink;
	spawnentity.model = spawnentity.spawnmodel;
	spawnentity.solid = spawnentity.spawnsolidtype;
	setmodel(spawnentity, spawnentity.model);
	setorigin(spawnentity, org);
	spawnentity.mins = spawnentity.spawnmins;
	spawnentity.maxs = spawnentity.spawnmaxs;
	setsize(spawnentity, spawnentity.mins, spawnentity.maxs);
	spawnentity.enemy = self.enemy;
	spawnentity.awake = self.awake;
};

void() spawn_loop = 
{
	while (self.cnt < self.count)
	{
		spawn_use(self.neworigin);
		self.neworigin_x = self.neworigin_x + self.lip;
		if (self.neworigin_x > self.origin_x + self.t_width)
		{
			self.neworigin_y = self.neworigin_y + self.lip;
			self.neworigin_x = self.origin_x - self.t_width;
		}
		if (self.neworigin_y > self.origin_y + self.t_width)
		{
			SUB_Remove();
		}
		self.cnt = self.cnt + STAYOPEN;
		if (self.cnt >= self.count)
		{
			SUB_Remove();
		}
	}
};

void() spawn_loop_start = 
{
	if (self.awake == STAYOPEN)
	{
		self.enemy = activator;
	}
	spawn_loop();
};

void() func_multispawn = 
{
	local entity tempself;
	local entity monster;
	local float tempdeathmatch;
	local float temptotal_monsters;
	local vector mn;
	local vector mx;
	if (!(self.count))
	{
		self.count = SVC_UPDATESTAT;
	}
	if (!(self.t_width))
	{
		self.t_width = SET_DAMAGE;
	}
	if (!(self.lip))
	{
		self.lip = SET_DAMAGE;
	}
	tempself = self;
	tempdeathmatch = deathmatch;
	deathmatch = OBJECT_ROTATE;
	self = spawn();
	SUB_CopyEntity(tempself, self);
	temptotal_monsters = total_monsters;
	if (self.spawnclassname == string_null)
	{
		objerror("No spawnclassname defined");
	}
	self.classname = self.spawnclassname;
	self.spawnfunction();
	if (self.spawnmulti != OBJECT_ROTATE)
	{
		total_monsters = temptotal_monsters;
	}
	self.spawnmodel = self.model;
	self.spawnmins = self.mins;
	self.spawnmaxs = self.maxs;
	setmodel(self, "");
	self.model = "";
	setsize(self, self.spawnmins, self.spawnmaxs);
	self.spawnsolidtype = self.solid;
	self.solid = SOLID_NOT;
	self.spawnthink = self.think;
	self.think = spawn_think;
	self.nextthink = time + STAYOPEN;
	monster = self;
	self = tempself;
	deathmatch = tempdeathmatch;
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;
	self.modelindex = OBJECT_ROTATE;
	self.model = "";
	setmodel(self, self.model);
	self.neworigin = self.origin;
	self.neworigin_x = self.origin_x - self.t_width;
	self.neworigin_y = self.origin_y - self.t_width;
	self.use = spawn_loop_start;
	self.spawnmaster = monster;
	if (self.count)
	{
		total_monsters = temptotal_monsters + self.count;
		WriteByte(MSG_BROADCAST, SVC_UPDATESTAT);
		WriteByte(MSG_BROADCAST, STAT_TOTALMONSTERS);
		WriteLong(MSG_BROADCAST, total_monsters);
	}
};

void() horde_loop = 
{
	self.coiled = STAYOPEN;
	if (!spawn_tcheck(self.origin))
	{
		spawn_use(self.origin);
		spawn_tfog(self.origin);
		self.cnt = self.cnt + STAYOPEN;
		if (self.use1)
		{
			SUB_UseSpecificTarget(self.use1, targetname);
		}
		self.coiled = OBJECT_ROTATE;
	}
	self.think = horde_loop;
	if (self.coiled == STAYOPEN)
	{
		self.nextthink = time + 0.3;
	}
	else
	{
		self.nextthink = time + self.wait;
	}
	if (self.cnt >= self.count)
	{
		SUB_Remove();
	}
};

void() horde_loop_start = 
{
	self.enemy = activator;
	horde_loop();
};

void() func_hordespawn = 
{
	local entity tempself;
	local entity monster;
	local float tempdeathmatch;
	local float temptotal_monsters;
	local vector mn;
	local vector mx;
	temptotal_monsters = total_monsters;
	if (!(self.count))
	{
		self.count = SVC_UPDATESTAT;
	}
	if (self.wait == OBJECT_ROTATE)
	{
		self.wait = 0.3;
	}
	if (self.spawnclassname == string_null)
	{
		objerror("No spawnclassname defined");
	}
	monster = spawn();
	SUB_CopyEntity(self, monster);
	monster.classname = self.spawnclassname;
	tempself = self;
	self = monster;
	self.spawnfunction();
	monster = self;
	self = tempself;
	monster.spawnmodel = monster.model;
	monster.spawnmins = monster.mins;
	monster.spawnmaxs = monster.maxs;
	setmodel(monster, "");
	monster.model = "";
	setsize(monster, monster.spawnmins, monster.spawnmaxs);
	monster.spawnsolidtype = monster.solid;
	monster.solid = SOLID_NOT;
	monster.spawnthink = monster.think;
	monster.think = spawn_think;
	monster.nextthink = time + STAYOPEN;
	monster.enemy = activator;
	monster.awake = STAYOPEN;
	self.enemy = activator;
	self.awake = STAYOPEN;
	self.spawnmaster = monster;
	total_monsters = temptotal_monsters;
	total_monsters = total_monsters + self.count;
	WriteByte(MSG_BROADCAST, SVC_UPDATESTAT);
	WriteByte(MSG_BROADCAST, STAT_TOTALMONSTERS);
	WriteLong(MSG_BROADCAST, total_monsters);
	self.use = horde_loop_start;
};

