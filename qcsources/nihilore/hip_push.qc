void() push_use = 
{
	local vector delta;
	local float x;
	local float y;
	local float pushang;
	if (!(other.flags & FL_CLIENT))
	{
		return;
	}
	if (other.absmin_z > self.absmax_z)
	{
		return;
	}
	delta = vectoangles(other.velocity);
	pushang = delta_y;
	walkmove(pushang, COUNTER_RANDOM * frametime);
	setorigin(self.owner, self.origin + self.pos1);
};

void() func_pushable = 
{
	local entity new;
	local vector newsize;
	self.mangle = self.angles;
	self.angles = VEC_ORIGIN;
	self.classname = "pushablewall";
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;
	setmodel(self, self.model);
	setorigin(self, self.origin);
	setsize(self, self.mins, self.maxs);
	self.oldorigin = self.origin;
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
	new.touch = push_use;
	new.pos1 = self.origin - new.origin;
};

