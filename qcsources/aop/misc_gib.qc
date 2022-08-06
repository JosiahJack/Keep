void() misc_gib2 = 
{
	local float rnum;
	if (self.mdl == string_null)
	{
		rnum = random();
		if (rnum < 0.25)
		{
			self.mdl = "progs/gib1.mdl";
		}
		else
		{
			if (rnum < 0.5)
			{
				self.mdl = "progs/gib2.mdl";
			}
			else
			{
				if (rnum < 0.75)
				{
					self.mdl = "progs/bone2.mdl";
				}
				else
				{
					self.mdl = "progs/bone.mdl";
				}
			}
		}
	}
	precache_model(self.mdl);
	setmodel(self, self.mdl);
	setsize(self, VEC_ORIGIN, VEC_ORIGIN);
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_TOSS;
};

void() misc_gib = 
{
	local float r;
	r = random();
	if (r < 0.3)
	{
		precache_model("progs/bone2.mdl");
		setmodel(self, "progs/bone2.mdl");
	}
	else
	{
		if (r < 0.6)
		{
			precache_model("progs/gib2.mdl");
			setmodel(self, "progs/gib2.mdl");
		}
		else
		{
			precache_model("progs/bone.mdl");
			setmodel(self, "progs/bone.mdl");
		}
	}
	setsize(self, VEC_ORIGIN, VEC_ORIGIN);
	self.solid = SOLID_NOT;
	self.angles_x = self.angles_x + random() * 360;
	self.angles_y = self.angles_y + random() * 360;
	self.angles_z = self.angles_z + random() * 360;
	self.movetype = MOVETYPE_TOSS;
	self.origin_z = self.origin_z + SPAWNFLAG_SUPERSPIKE;
	droptofloor();
};

