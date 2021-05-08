void() UpdateItems = 
{
	if (self.gunitems & GUN_SHOTGUN)
	{
		self.items = self.items | IT_SHOTGUN;
	}
	if (self.gunitems & GUN_SUPER_SHOTGUN)
	{
		self.items = self.items | IT_SUPER_SHOTGUN;
	}
	if (self.gunitems & GUN_NAILGUN)
	{
		self.items = self.items | IT_NAILGUN;
	}
	if (self.gunitems & GUN_SUPER_NAILGUN)
	{
		self.items = self.items | IT_SUPER_NAILGUN;
	}
	if (self.gunitems & GUN_GRENADE_LAUNCHER)
	{
		self.items = self.items | IT_GRENADE_LAUNCHER;
	}
	if (self.gunitems & GUN_ROCKET_LAUNCHER)
	{
		self.items = self.items | IT_ROCKET_LAUNCHER;
	}
	if (self.gunitems & GUN_LIGHTNING)
	{
		self.items = self.items | IT_LIGHTNING;
	}
	if (self.gunitems & GUN_PLASMAGUN)
	{
		self.items = self.items | IT_PLASMAGUN;
	}
	if (self.gunitems & GUN_ANTISHAMBLER)
	{
		self.items = self.items | IT_ANTISHAMBLER;
	}
};

