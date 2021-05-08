void() push_die = 
{
	remove(self);
};

void() push_use = 
{
	local vector delta;
	local float x;
	local float y;
	makevectors(other.angles);
	x = fabs(other.velocity_x);
	y = fabs(other.velocity_y);
	dprint(ftos(x));
	dprint(", ");
	dprint(ftos(y));
	if (x > y)
	{
		dprint(" x move\n\n\n\n");
		if (other.velocity_x > 0)
		{
			walkmove(0, FL_INWATER * frametime);
		}
		else
		{
			walkmove(180, FL_INWATER * frametime);
		}
	}
	else
	{
		dprint(" y move\n\n\n\n");
		if (other.velocity_y > 0)
		{
			walkmove(90, FL_INWATER * frametime);
		}
		else
		{
			walkmove(270, FL_INWATER * frametime);
		}
	}
	delta = self.origin - self.oldorigin;
	setorigin(self.owner, self.owner.oldorigin + delta);
};

void() func_pushable = 
{
	local entity new;
	local vector newsize;
	self.mangle = self.angles;
	self.angles = VEC_ORIGIN;
	self.classname = "pushablewall";
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	setmodel(self, self.model);
	setorigin(self, self.origin);
	setsize(self, self.mins, self.maxs);
	self.oldorigin = self.origin;
	if (self.spawnflags & 1)
	{
		self.health = 20;
		self.th_die = push_die;
		self.takedamage = DAMAGE_AIM;
	}
	new = spawn();
	new.owner = self;
	new.mangle = self.mangle;
	new.angles = self.angles;
	new.classname = "pushablewallproxy";
	new.solid = SOLID_BBOX;
	new.movetype = MOVETYPE_STEP;
	new.origin = (self.mins + self.maxs) * 0.5 + '0 0 1';
	newsize = (self.maxs - self.mins) * 0.5;
	new.mins = '-1 -1 0' - newsize;
	new.maxs = '1 1 -2' + newsize;
	setsize(new, new.mins, new.maxs);
	setorigin(new, new.origin);
	new.oldorigin = new.origin;
	new.touch = push_use;
	if (self.spawnflags & 1)
	{
		new.health = 20;
		new.th_die = barrel_explode;
		new.takedamage = DAMAGE_AIM;
	}
};

