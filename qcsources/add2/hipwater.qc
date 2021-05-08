void() bobbingwater_think = 
{
	local vector ang;
	self.count = self.count + self.speed * (time - self.ltime);
	if (self.count > 360)
	{
		self.count = self.count - 360;
	}
	ang_x = self.count;
	ang_y = MSG_BROADCAST;
	ang_z = MSG_BROADCAST;
	makevectors(ang);
	self.origin_z = v_forward_z * self.cnt;
	setorigin(self, self.origin);
	self.ltime = time;
	self.nextthink = time + 0.020000;
};

void() func_bobbingwater = 
{
	self.angles = VEC_ORIGIN;
	self.movetype = MOVETYPE_STEP;
	self.solid = SOLID_NOT;
	setmodel(self, self.model);
	self.think = bobbingwater_think;
	self.count = MSG_BROADCAST;
	self.cnt = self.size_z / LIGHTNING_BOOM;
	if (!(self.speed))
	{
		self.speed = NONBLOCKING;
	}
	self.speed = 360 / self.speed;
	self.nextthink = time + 0.020000;
	self.ltime = time;
};

