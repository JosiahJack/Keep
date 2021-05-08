void() counter_think = 
{
	self.cnt = self.cnt + 1;
	if (self.spawnflags & COUNTER_RANDOM)
	{
		self.state = random() * self.count;
		self.state = floor(self.state) + 1;
	}
	else
	{
		self.state = self.cnt;
	}
	activator = other;
	SUB_UseTargets();
	self.nextthink = time + self.wait;
	if (self.spawnflags & COUNTER_STEP)
	{
		counter_on_use();
	}
	if (self.cnt >= self.count)
	{
		self.cnt = 0;
		if (self.aflag || !(self.spawnflags & COUNTER_LOOP))
		{
			if (self.spawnflags & COUNTER_TOGGLE)
			{
				counter_on_use();
			}
			else
			{
				remove(self);
			}
		}
	}
};

void() counter_on_use = 
{
	if (self.cnt != 0 && (self.spawnflags & COUNTER_FINISHCOUNT))
	{
		self.aflag = 1;
		return;
	}
	self.use = counter_off_use;
	self.think = SUB_Null;
	self.aflag = 0;
};

void() counter_off_use = 
{
	self.aflag = 0;
	if (self.spawnflags & COUNTER_TOGGLE)
	{
		self.use = counter_on_use;
	}
	else
	{
		self.use = SUB_Null;
	}
	if (self.spawnflags & COUNTER_RESET)
	{
		self.cnt = 0;
		self.state = 0;
	}
	self.think = counter_think;
	if (self.delay)
	{
		self.nextthink = time + self.delay;
	}
	else
	{
		counter_think();
	}
};

float(entity counter) counter_GetCount = 
{
	local float value;
	if (counter.classname == "counter")
	{
		return counter.state;
	}
	return 0;
};

void() func_counter = 
{
	if (!(self.wait))
	{
		self.wait = 1;
	}
	self.count = floor(self.count);
	if (self.count <= 0)
	{
		self.count = MOVETYPE_BOUNCE;
	}
	self.cnt = 0;
	self.state = 0;
	self.classname = "counter";
	self.use = counter_off_use;
	self.think = SUB_Null;
	if (self.spawnflags & COUNTER_START_ON)
	{
		self.think = counter_off_use;
		self.nextthink = time + GYRO_TURBULENCEMOD_AIR;
	}
};

void() oncount_use = 
{
	if (counter_GetCount(other) == self.count)
	{
		activator = other;
		SUB_UseTargets();
	}
};

void() func_oncount = 
{
	self.count = floor(self.count);
	if (self.count <= 0)
	{
		self.count = 1;
	}
	self.classname = "oncount";
	self.use = oncount_use;
	self.think = SUB_Null;
};

