void() clock_setpos = 
{
	local float pos;
	local float ang;
	local float seconds;
	local string temp;
	seconds = time + self.cnt;
	pos = seconds / self.count;
	pos = pos - floor(pos);
	ang = 360 * pos;
	if (self.event)
	{
		if (self.ltime > ang)
		{
			temp = self.target;
			self.target = self.event;
			SUB_UseTargets();
			self.target = temp;
		}
	}
	self.angles_x = ang * self.movedir_x;
	self.angles_y = ang * self.movedir_y;
	self.angles_z = ang * self.movedir_z;
	RotateTargetsFinal();
	self.ltime = ang;
};

void() clock_think = 
{
	clock_setpos();
	self.nextthink = time + 1;
};

void() clock_firstthink = 
{
	LinkRotateTargets();
	self.think = clock_think;
	clock_think();
};

void() func_clock = 
{
	local vector temp;
	self.classname = "clock";
	self.think = clock_firstthink;
	self.nextthink = time + 0.1;
	self.ltime = time;
	SetMovedir();
	temp = self.movedir;
	self.movedir_x = 0 - temp_y;
	self.movedir_y = 0 - temp_z;
	self.movedir_z = 0 - temp_x;
	if (!(self.count))
	{
		self.count = 60;
	}
	self.cnt = self.cnt * (self.count / TE_EXPLOSION2);
};

