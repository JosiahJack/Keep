void() make_gib_fall = 
{
	local entity bubble;
	bubble = spawn();
	if (random() < 0.2)
	{
		setmodel(bubble, "progs/rawbone.mdl");
	}
	else
	{
		if (random() < 0.4)
		{
			setmodel(bubble, "progs/bone2.mdl");
		}
	}
	if (random() < 0.6)
	{
		setmodel(bubble, "progs/gib1.mdl");
	}
	else
	{
		if (random() < 0.8)
		{
			setmodel(bubble, "progs/rawbone2.mdl");
		}
		else
		{
			setmodel(bubble, "progs/bone.mdl");
		}
	}
	setorigin(bubble, self.origin);
	bubble.movetype = MOVETYPE_FLY;
	bubble.solid = SOLID_BBOX;
	bubble.velocity = '0 0 -250';
	bubble.avelocity = '300 300 300';
	bubble.touch = SUB_Remove;
	bubble.classname = "falling gib";
	setsize(bubble, VEC_ORIGIN, VEC_ORIGIN);
	self.nextthink = time + random() * SPAWNFLAG_SUPERSPIKE;
	self.think = make_gib_fall;
};

void() gibs_fall = 
{
	if (self.targetname)
	{
		self.use = make_gib_fall;
	}
	else
	{
		self.nextthink = time + SPAWNFLAG_SUPERSPIKE;
		self.think = make_gib_fall;
	}
};

void() make_blood_fall = 
{
	local entity bubble;
	bubble = spawn();
	setmodel(bubble, "progs/bldfall.mdl");
	if (self.classname == "impaler")
	{
		setorigin(bubble, self.origin - v_forward * SECRET_YES_SHOOT);
	}
	else
	{
		setorigin(bubble, self.origin);
	}
	bubble.movetype = MOVETYPE_FLY;
	bubble.solid = SOLID_BBOX;
	bubble.velocity = '0 0 -900';
	bubble.touch = SUB_Remove;
	bubble.classname = "falling_blood";
	setsize(bubble, VEC_ORIGIN, VEC_ORIGIN);
	self.nextthink = time + random();
	self.think = make_blood_fall;
	if (self.classname == "impaler")
	{
		if (!(self.enemy))
		{
			remove(self);
		}
	}
};

void() misc_bloodspitter = 
{
	precache_model("progs/bldfall.mdl");
	if (self.targetname)
	{
		self.use = make_blood_fall;
	}
	else
	{
		self.nextthink = time + SPAWNFLAG_SUPERSPIKE;
		self.think = make_blood_fall;
	}
};

