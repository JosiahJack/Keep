void() counter_think = 
{
	self.cnt = self.cnt + SPAWN_CRUCIFIED;
	if (self.spawnflags & COUNTER_RANDOM)
	{
		self.state = random() * self.count;
		self.state = floor(self.state) + SPAWN_CRUCIFIED;
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
		self.cnt = MSG_BROADCAST;
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
	if (self.cnt != MSG_BROADCAST && (self.spawnflags & COUNTER_FINISHCOUNT))
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
		self.cnt = MSG_BROADCAST;
		self.state = MSG_BROADCAST;
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
	return MSG_BROADCAST;
};

void() func_counter = 
{
	if (!(self.wait))
	{
		self.wait = SPAWN_CRUCIFIED;
	}
	self.count = floor(self.count);
	if (self.count <= MSG_BROADCAST)
	{
		self.count = MIN_ANGLE_DELTA;
	}
	self.cnt = MSG_BROADCAST;
	self.state = MSG_BROADCAST;
	self.classname = "counter";
	self.use = counter_off_use;
	self.think = SUB_Null;
	if (self.spawnflags & COUNTER_START_ON)
	{
		self.think = counter_off_use;
		self.nextthink = time + 0.1;
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
	if (self.count <= MSG_BROADCAST)
	{
		self.count = SPAWN_CRUCIFIED;
	}
	self.classname = "oncount";
	self.use = oncount_use;
	self.think = SUB_Null;
};

