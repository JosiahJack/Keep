void() SUB_Null = 
{
};

void() SUB_Remove = 
{
	remove(self);
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

void() InitTrigger = 
{
	if (self.angles != VEC_ORIGIN)
	{
		SetMovedir();
	}
	self.solid = SOLID_TRIGGER;
	setmodel(self, self.model);
	self.movetype = MOVETYPE_NONE;
	self.modelindex = MSG_BROADCAST;
	self.model = "";
};

void(entity ent, vector tdest, float tspeed, <function> func) SUB_CalcMoveEnt = 
{
	local entity stemp;
	stemp = self;
	self = ent;
	SUB_CalcMove(tdest, tspeed, func);
	self = stemp;
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
	self.think = SUB_CalcMoveDone;
	if (tdest == self.origin)
	{
		self.velocity = VEC_ORIGIN;
		self.nextthink = self.ltime + 0.1;
		return;
	}
	vdestdelta = tdest - self.origin;
	len = vlen(vdestdelta);
	traveltime = len / tspeed;
	if (traveltime < 0.1)
	{
		self.velocity = VEC_ORIGIN;
		self.nextthink = self.ltime + 0.1;
		return;
	}
	self.nextthink = self.ltime + traveltime;
	self.velocity = vdestdelta * (BIT_1 / traveltime);
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

void(entity ent, vector destangle, float tspeed, <function> func) SUB_CalcAngleMoveEnt = 
{
	local entity stemp;
	stemp = self;
	self = ent;
	SUB_CalcAngleMove(destangle, tspeed, func);
	self = stemp;
};

void(vector destangle, float tspeed, <function> func) SUB_CalcAngleMove = 
{
	local vector destdelta;
	local float len;
	local float traveltime;
	if (!tspeed)
	{
		objerror("No speed is defined!");
	}
	destdelta = destangle - self.angles;
	len = vlen(destdelta);
	traveltime = len / tspeed;
	self.nextthink = self.ltime + traveltime;
	self.avelocity = destdelta * (BIT_1 / traveltime);
	self.think1 = func;
	self.finalangle = destangle;
	self.think = SUB_CalcAngleMoveDone;
};

void() SUB_CalcAngleMoveDone = 
{
	self.angles = self.finalangle;
	self.avelocity = VEC_ORIGIN;
	self.nextthink = CONTENT_EMPTY;
	if (self.think1)
	{
		self.think1();
	}
};

void() DelayThink = 
{
	activator = self.enemy;
	SUB_UseTargets();
	remove(self);
};

void(string matchstring, <objdata> matchfield) SUB_UseSpecificTarget = 
{
	local entity t;
	local entity stemp;
	local entity otemp;
	local entity act;
	act = activator;
	t = find(world, matchfield, matchstring);
	while (t != world)
	{
		stemp = self;
		otemp = other;
		self = t;
		other = stemp;
		if (self.use != SUB_Null)
		{
			if (self.use)
			{
				lastnameused = matchstring;
				self.use();
			}
		}
		self = stemp;
		other = otemp;
		activator = act;
		t = find(t, matchfield, matchstring);
	}
};

void() SUB_UseTargets = 
{
	local entity t;
	if (self.delay)
	{
		t = spawn();
		t.classname = "DelayedUse";
		t.nextthink = time + self.delay;
		t.think = DelayThink;
		t.enemy = activator;
		t.message = self.message;
		t.killtarget = self.killtarget;
		t.killtarget2 = self.killtarget2;
		t.target = self.target;
		t.target2 = self.target2;
		t.target3 = self.target3;
		t.target4 = self.target4;
		return;
	}
	if (activator.classname == "player" && self.message != "")
	{
		centerprint(activator, self.message);
		if (!(self.noise))
		{
			sound(activator, CHAN_VOICE, "misc/talk.wav", BIT_1, ATTN_NORM);
		}
	}
	if (self.killtarget)
	{
		t = find(world, targetname, self.killtarget);
		while (t != world)
		{
			remove(t);
			t = find(t, targetname, self.killtarget);
		}
		t = find(world, targetname2, self.killtarget);
		while (t != world)
		{
			remove(t);
			t = find(t, targetname2, self.killtarget);
		}
		t = find(world, targetname3, self.killtarget);
		while (t != world)
		{
			remove(t);
			t = find(t, targetname3, self.killtarget);
		}
		t = find(world, targetname4, self.killtarget);
		while (t != world)
		{
			remove(t);
			t = find(t, targetname4, self.killtarget);
		}
	}
	if (self.killtarget2)
	{
		t = find(world, targetname, self.killtarget2);
		while (t != world)
		{
			remove(t);
			t = find(t, targetname, self.killtarget2);
		}
		t = find(world, targetname2, self.killtarget2);
		while (t != world)
		{
			remove(t);
			t = find(t, targetname2, self.killtarget2);
		}
		t = find(world, targetname3, self.killtarget2);
		while (t != world)
		{
			remove(t);
			t = find(t, targetname3, self.killtarget2);
		}
		t = find(world, targetname4, self.killtarget2);
		while (t != world)
		{
			remove(t);
			t = find(t, targetname4, self.killtarget2);
		}
	}
	if (self.target)
	{
		SUB_UseSpecificTarget(self.target, targetname);
		SUB_UseSpecificTarget(self.target, targetname2);
		SUB_UseSpecificTarget(self.target, targetname3);
		SUB_UseSpecificTarget(self.target, targetname4);
	}
	if (self.target2)
	{
		SUB_UseSpecificTarget(self.target2, targetname);
		SUB_UseSpecificTarget(self.target2, targetname2);
		SUB_UseSpecificTarget(self.target2, targetname3);
		SUB_UseSpecificTarget(self.target2, targetname4);
	}
	if (self.target3)
	{
		SUB_UseSpecificTarget(self.target3, targetname);
		SUB_UseSpecificTarget(self.target3, targetname2);
		SUB_UseSpecificTarget(self.target3, targetname3);
		SUB_UseSpecificTarget(self.target3, targetname4);
	}
	if (self.target4)
	{
		SUB_UseSpecificTarget(self.target4, targetname);
		SUB_UseSpecificTarget(self.target4, targetname2);
		SUB_UseSpecificTarget(self.target4, targetname3);
		SUB_UseSpecificTarget(self.target4, targetname4);
	}
};

void(string matchstring) SUB_UseName = 
{
	SUB_UseSpecificTarget(matchstring, targetname);
	SUB_UseSpecificTarget(matchstring, targetname2);
	SUB_UseSpecificTarget(matchstring, targetname3);
	SUB_UseSpecificTarget(matchstring, targetname4);
};

void(float normal) SUB_AttackFinished = 
{
	self.cnt = MSG_BROADCAST;
	if (skill != SVC_UPDATESTAT)
	{
		self.attack_finished = time + normal;
	}
};

void(<function> thinkst) SUB_CheckRefire = 
{
	if (skill != SVC_UPDATESTAT)
	{
		return;
	}
	if (self.cnt == BIT_1)
	{
		return;
	}
	if (!visible(self.enemy))
	{
		return;
	}
	self.cnt = BIT_1;
	self.think = thinkst;
};

