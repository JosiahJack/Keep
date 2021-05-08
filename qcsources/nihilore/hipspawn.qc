void() spawn_think = 
{
	self.think = spawn_think;
	self.nextthink = time + STAYOPEN;
};

void() spawn_use = 
{
	local entity spawnentity;
	local entity tempself;
	if (self.spawnmulti == STAYOPEN)
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
	setorigin(spawnentity, self.origin);
	spawnentity.mins = spawnentity.spawnmins;
	spawnentity.maxs = spawnentity.spawnmaxs;
	setsize(spawnentity, spawnentity.mins, spawnentity.maxs);
	if (self.spawnsilent == OBJECT_ROTATE)
	{
		spawn_tfog(spawnentity.origin);
	}
	if (spawnentity.flags & FL_MONSTER)
	{
		if (self.spawnmulti != OBJECT_ROTATE)
		{
			total_monsters = total_monsters + STAYOPEN;
			WriteByte(MSG_BROADCAST, SVC_UPDATESTAT);
			WriteByte(MSG_BROADCAST, STAT_TOTALMONSTERS);
			WriteLong(MSG_BROADCAST, total_monsters);
		}
	}
	if (self.spawnmulti == OBJECT_ROTATE)
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
	deathmatch = OBJECT_ROTATE;
	if (!(self.spawnclassname))
	{
		spawnchance = random();
		monster = tempself;
		if (self.spawnmulti != OBJECT_ROTATE)
		{
			self.currentammo = 1;
		}
		temptotal_monsters = total_monsters;
		if (spawnchance < 0.5)
		{
			self = spawn();
			self.spawnfunction = monster_dog;
			self.spawnclassname = "monster_dog";
		}
		else
		{
			if (spawnchance < 0.8)
			{
				self = spawn();
				self.spawnfunction = monster_ogre;
				self.spawnclassname = "monster_ogre";
			}
			else
			{
				if (spawnchance < 0.92)
				{
					self = spawn();
					self.spawnfunction = monster_demon1;
					self.spawnclassname = "monster_demon1";
				}
				else
				{
					if (spawnchance < 0.970000)
					{
						self = spawn();
						self.spawnfunction = monster_zombie;
						self.spawnclassname = "monster_zombie";
					}
					else
					{
						self = spawn();
						self.spawnfunction = monster_shambler;
						self.spawnclassname = "monster_shambler";
					}
				}
			}
		}
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
		self.nextthink = time + STAYOPEN;
		monster = self;
		total_monsters = temptotal_monsters + STAYOPEN;
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
	}
	self = tempself;
	deathmatch = tempdeathmatch;
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;
	self.modelindex = OBJECT_ROTATE;
	self.model = "";
	setmodel(self, self.model);
	self.use = spawn_use;
	self.spawnmaster = monster;
};

void() func_spawn_small = 
{
	func_spawn();
};

