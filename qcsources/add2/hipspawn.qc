void() spawn_think = 
{
	self.think = spawn_think;
	self.nextthink = time + SPAWN_CRUCIFIED;
};

void() spawn_use = 
{
	local entity spawnentity;
	local entity tempself;
	if (self.spawnmulti == SPAWN_CRUCIFIED || horn_active)
	{
		spawnentity = spawn();
		SUB_CopyEntity(self.spawnmaster, spawnentity);
	}
	else
	{
		spawnentity = self.spawnmaster;
	}
	spawnentity.model = spawnentity.spawnmodel;
	spawnentity.solid = spawnentity.spawnsolidtype;
	spawnentity.think = spawnentity.spawnthink;
	setmodel(spawnentity, spawnentity.model);
	setorigin(spawnentity, spawnentity.origin);
	spawnentity.mins = spawnentity.spawnmins;
	spawnentity.maxs = spawnentity.spawnmaxs;
	setsize(spawnentity, spawnentity.mins, spawnentity.maxs);
	if (self.spawnsilent == MSG_BROADCAST)
	{
		spawn_tfog(spawnentity.origin);
	}
	if (horn_active)
	{
		spawnentity.charmer = horn_charmer;
		spawnentity.charmed = SPAWN_CRUCIFIED;
	}
	if (spawnentity.flags & FL_MONSTER)
	{
		if (self.spawnmulti != MSG_BROADCAST && horn_active == MSG_BROADCAST)
		{
			total_monsters = total_monsters + SPAWN_CRUCIFIED;
			WriteByte(MSG_BROADCAST, SVC_UPDATESTAT);
			WriteByte(MSG_BROADCAST, STAT_TOTALMONSTERS);
			WriteLong(MSG_BROADCAST, total_monsters);
		}
		if (horn_active)
		{
			spawnentity.effects = spawnentity.effects | EF_DIMLIGHT;
		}
	}
	if (self.spawnmulti == MSG_BROADCAST && horn_active == MSG_BROADCAST)
	{
		remove(self);
	}
};

void() func_spawn = 
{
	local entity tempself;
	local entity monster;
	local float tempdeathmatch;
	local float temptotal_monsters;
	local vector mn;
	local vector mx;
	local float spawnchance;
	tempself = self;
	tempdeathmatch = deathmatch;
	deathmatch = MSG_BROADCAST;
	if (!(self.spawnfunction))
	{
		spawnchance = random();
		monster = tempself;
		temptotal_monsters = total_monsters;
		self = spawn();
		SUB_CopyEntity(tempself, self);
		self.spawnfunction = monster_dog;
		self.spawnclassname = "monster_dog";
		self.classname = self.spawnclassname;
		self.spawnfunction();
		self.spawnmodel = self.model;
		self.spawnmins = self.mins;
		self.spawnmaxs = self.maxs;
		setmodel(self, "");
		setsize(self, self.spawnmins, self.spawnmaxs);
		self.spawnsolidtype = self.solid;
		self.solid = SOLID_NOT;
		self.spawnthink = self.think;
		self.think = spawn_think;
		self.nextthink = time + SPAWN_CRUCIFIED;
		if (spawnchance < 0.5 && monster == tempself)
		{
			monster = self;
		}
		self = spawn();
		SUB_CopyEntity(tempself, self);
		self.spawnfunction = monster_ogre;
		self.spawnclassname = "monster_ogre";
		self.classname = self.spawnclassname;
		self.spawnfunction();
		self.spawnmodel = self.model;
		self.spawnmins = self.mins;
		self.spawnmaxs = self.maxs;
		setmodel(self, "");
		setsize(self, self.spawnmins, self.spawnmaxs);
		self.spawnsolidtype = self.solid;
		self.solid = SOLID_NOT;
		self.spawnthink = self.think;
		self.think = spawn_think;
		self.nextthink = time + SPAWN_CRUCIFIED;
		if (spawnchance < 0.8 && monster == tempself)
		{
			monster = self;
		}
		self = spawn();
		SUB_CopyEntity(tempself, self);
		self.spawnfunction = monster_demon1;
		self.spawnclassname = "monster_demon1";
		self.classname = self.spawnclassname;
		self.spawnfunction();
		self.spawnmodel = self.model;
		self.spawnmins = self.mins;
		self.spawnmaxs = self.maxs;
		setmodel(self, "");
		setsize(self, self.spawnmins, self.spawnmaxs);
		self.spawnsolidtype = self.solid;
		self.solid = SOLID_NOT;
		self.spawnthink = self.think;
		self.think = spawn_think;
		self.nextthink = time + SPAWN_CRUCIFIED;
		if (spawnchance < 0.92 && monster == tempself)
		{
			monster = self;
		}
		self = spawn();
		SUB_CopyEntity(tempself, self);
		self.spawnfunction = monster_zombie;
		self.spawnclassname = "monster_zombie";
		self.classname = self.spawnclassname;
		self.spawnfunction();
		self.spawnmodel = self.model;
		self.spawnmins = self.mins;
		self.spawnmaxs = self.maxs;
		setmodel(self, "");
		setsize(self, self.spawnmins, self.spawnmaxs);
		self.spawnsolidtype = self.solid;
		self.solid = SOLID_NOT;
		self.spawnthink = self.think;
		self.think = spawn_think;
		self.nextthink = time + SPAWN_CRUCIFIED;
		if (spawnchance < 0.970000 && monster == tempself)
		{
			monster = self;
		}
		self = spawn();
		SUB_CopyEntity(tempself, self);
		self.spawnfunction = monster_shambler;
		self.spawnclassname = "monster_shambler";
		self.classname = self.spawnclassname;
		self.spawnfunction();
		self.spawnmodel = self.model;
		self.spawnmins = self.mins;
		self.spawnmaxs = self.maxs;
		setmodel(self, "");
		setsize(self, self.spawnmins, self.spawnmaxs);
		self.spawnsolidtype = self.solid;
		self.solid = SOLID_NOT;
		self.spawnthink = self.think;
		self.think = spawn_think;
		self.nextthink = time + SPAWN_CRUCIFIED;
		if (monster == tempself)
		{
			monster = self;
		}
		total_monsters = temptotal_monsters + SPAWN_CRUCIFIED;
	}
	else
	{
		self = spawn();
		SUB_CopyEntity(tempself, self);
		temptotal_monsters = total_monsters;
		if (self.spawnclassname == string_null)
		{
			objerror("No spawnclassname defined");
		}
		self.classname = self.spawnclassname;
		self.spawnfunction();
		if (self.spawnmulti != MSG_BROADCAST)
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
		self.nextthink = time + SPAWN_CRUCIFIED;
		monster = self;
	}
	self = tempself;
	deathmatch = tempdeathmatch;
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;
	self.modelindex = MSG_BROADCAST;
	self.model = "";
	setmodel(self, self.model);
	self.use = spawn_use;
	self.spawnmaster = monster;
};

void() func_spawn_small = 
{
	func_spawn();
};

