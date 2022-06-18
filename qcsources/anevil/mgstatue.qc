void() stat_angl = 
{
	precache_model("progs/anglstat.mdl");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_NONE;
	setmodel(self, "progs/anglstat.mdl");
	if (self.spawnflags & SPAWN_ROTATE)
	{
		setsize(self, '-30 -50 0', '29 44 132');
	}
	else
	{
		setsize(self, '-50 -30 0', '44 29 132');
	}
	self.origin_z = self.origin_z + SPAWN_CRUCIFIED;
	droptofloor();
};

void() stat_athena = 
{
	precache_model("progs/athena.mdl");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_NONE;
	setmodel(self, "progs/athena.mdl");
	if (self.spawnflags & SPAWN_ROTATE)
	{
		setsize(self, '-46 -13 -1', '29 32 99');
	}
	else
	{
		setsize(self, '-13 -46 -1', '32 29 99');
	}
	self.origin_z = self.origin_z + SPAWN_CRUCIFIED;
	droptofloor();
};

void() stat_caesar = 
{
	precache_model("progs/caesar.mdl");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_NONE;
	setmodel(self, "progs/caesar.mdl");
	if (self.spawnflags & SPAWN_ROTATE)
	{
		setsize(self, '-28 -11 0', '13 14 65');
	}
	else
	{
		setsize(self, '-11 -28 0', '14 13 65');
	}
	self.origin_z = self.origin_z + SPAWN_CRUCIFIED;
	droptofloor();
};

void() stat_fountain = 
{
	precache_model("progs/fountain.mdl");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_NONE;
	setmodel(self, "progs/fountain.mdl");
	setsize(self, '-31 -27 -1', '31 27 95');
	self.origin_z = self.origin_z + SPAWN_CRUCIFIED;
	droptofloor();
};

void() stat_lion = 
{
	precache_model("progs/lion.mdl");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_NONE;
	setmodel(self, "progs/lion.mdl");
	if (self.spawnflags & SPAWN_ROTATE)
	{
		setsize(self, '-15 -64 -1', '14 63 50');
	}
	else
	{
		setsize(self, '-64 -15 -1', '63 14 50');
	}
	self.origin_z = self.origin_z + SPAWN_CRUCIFIED;
	droptofloor();
};

void() stat_mars = 
{
	precache_model("progs/mars.mdl");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_NONE;
	setmodel(self, "progs/mars.mdl");
	if (self.spawnflags & SPAWN_ROTATE)
	{
		setsize(self, '-26 -10 -1', '37 28 91');
	}
	else
	{
		setsize(self, '-10 -26 -1', '28 37 91');
	}
	self.origin_z = self.origin_z + SPAWN_CRUCIFIED;
	droptofloor();
};

void() stat_tree = 
{
	precache_model("progs/tree.mdl");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_NONE;
	setmodel(self, "progs/tree.mdl");
	setsize(self, '-20 -20 0', '20 20 208');
	self.origin_z = self.origin_z + SPAWN_CRUCIFIED;
	droptofloor();
};

void() stat_tree2 = 
{
	precache_model("progs/tree2.mdl");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_NONE;
	setmodel(self, "progs/tree2.mdl");
	setsize(self, '-20 -20 -1', '20 20 174');
	self.origin_z = self.origin_z + SPAWN_CRUCIFIED;
	droptofloor();
};

