void() bobbingwater_think = 
{
	local vector ang;
	self.count = self.count + self.speed * (time - self.ltime);
	if (self.count > 360)
	{
		self.count = self.count - 360;
	}
	ang_x = self.count;
	ang_y = 0;
	ang_z = 0;
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
	self.count = 0;
	self.cnt = self.size_z / FL_SWIM;
	if (!(self.speed))
	{
		self.speed = MOVETYPE_STEP;
	}
	self.speed = 360 / self.speed;
	self.nextthink = time + 0.020000;
	self.ltime = time;
};

