void() SUB_Null = 
{
};

void() SUB_Remove = 
{
	remove(self);
	return;
};

void() SetMovedir = 
{
	if (self.angles == '0 -1 0')
	{
		self.movedir = '0 0 1';
	}
	else
	{
		if (self.angles == '0 -2 0')
		{
			self.movedir = '0 0 -1';
		}
		else
		{
			makevectors(self.angles);
			self.movedir = v_forward;
		}
	}
	self.angles = VEC_ORIGIN;
};

void() DelayThink = 
{
	activator = self.enemy;
	SUB_UseTargets();
	remove(self);
};

void() SUB_UseTargets = 
{
	local entity t;
	local entity stemp;
	local entity otemp;
	local entity act;
	local float v;
	v = self.mode;
	if (self.delay)
	{
		t = spawn();
		t.classname = "DelayedUse";
		t.nextthink = time + self.delay;
		t.think = DelayThink;
		t.enemy = activator;
		t.message = self.message;
		t.killtarget = self.killtarget;
		t.target = self.target;
		return;
	}
	if (self.killtarget)
	{
		t = world;
		do
		{
			t = find(t, targetname, self.killtarget);
			if (!t)
			{
				return;
			}
			remove(t);
		} while (IT_RELIC1);
	}
	if (self.target)
	{
		act = activator;
		t = world;
		do
		{
			t = find(t, targetname, self.target);
			if (!t)
			{
				return;
			}
			if (t.classname == "trigger_push")
			{
				if (t.spawnflags & IT_RELIC2)
				{
					t.cnt = 0;
				}
			}
			stemp = self;
			otemp = other;
			self = t;
			other = stemp;
			if (self.classname == "barrier")
			{
				self.mode = v;
			}
			if (self.use != SUB_Null)
			{
				if (self.use)
				{
					self.use();
				}
			}
			self = stemp;
			other = otemp;
			activator = act;
		} while (IT_RELIC1);
	}
};

void() SUB_CalcMoveDone = 
{
	setorigin(self, self.finaldest);
	self.velocity = VEC_ORIGIN;
	self.nextthink = CONTENT_EMPTY;
	if (self.think1)
	{
		self.think1();
	}
};

void(vector tdest, float tspeed, <function> func) SUB_CalcMove = 
{
	local vector vdestdelta;
	local float len;
	local float traveltime;
	if (!tspeed)
	{
		objerror("No speed is defined!");
	}
	self.think1 = func;
	self.finaldest = tdest;
	if (tdest == self.origin)
	{
		self.velocity = VEC_ORIGIN;
		self.nextthink = self.ltime + 0.1;
		return;
	}
	vdestdelta = tdest - self.origin;
	len = vlen(vdestdelta);
	traveltime = len / tspeed;
	self.velocity = vdestdelta * (IT_RELIC1 / traveltime);
	self.think = SUB_CalcMoveDone;
	self.nextthink = self.ltime + traveltime;
};

