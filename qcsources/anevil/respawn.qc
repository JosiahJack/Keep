float(vector spot) PM_Occupied = 
{
	if (PM_InWall(self, spot))
	{
		return 1;
	}
	return !PM_TraceCheck(self, spot);
};

void() PM_CoverUp = 
{
	local entity blank;
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.velocity = VEC_ORIGIN;
	self.touch = SUB_Null;
	setmodel(self, "");
	blank = spawn();
	setmodel(blank, "progs/s_explod.spr");
	setsize(blank, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(blank, self.origin);
	blank.movetype = MOVETYPE_NONE;
	blank.solid = SOLID_NOT;
	blank.velocity = VEC_ORIGIN;
	blank.touch = SUB_Null;
	blank.nextthink = time;
	blank.think = s_explode1;
};

void() PM_ResetPath = 
{
	if (self.target)
	{
		self.goalentity = self.movetarget = find(world, targetname, self.target);
		self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
		if (self.movetarget.classname == "path_corner")
		{
			self.th_walk();
		}
		else
		{
			self.pausetime = 100000000;
			self.th_stand();
		}
	}
	else
	{
		self.pausetime = 100000000;
		self.th_stand();
	}
};

void() PM_ResetEnemy = 
{
	if (self.enemy.classname == "player")
	{
		if (self.oldenemy.classname != "player")
		{
			self.oldenemy = world;
		}
		HuntTarget();
		return;
	}
	if (self.oldenemy.classname == "player")
	{
		self.enemy = self.oldenemy;
		self.oldenemy = world;
		HuntTarget();
		return;
	}
	self.enemy = world;
	self.oldenemy = world;
	PM_ResetPath();
};

void(vector hullmin, vector hullmax, float hp) PM_Reconstitute = 
{
	self.solid = SOLID_SLIDEBOX;
	setsize(self, hullmin, hullmax);
	if (self.flags & FL_SWIM)
	{
		self.view_ofs = '0 0 10';
	}
	else
	{
		self.view_ofs = '0 0 25';
	}
	self.angles = self.oldangles;
	self.fixangle = 1;
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	self.health = hp;
	self.takedamage = DAMAGE_AIM;
};

float() PM_RandomSleep = 
{
	local float sleeptime;
	local float d1;
	local float d2;
	d1 = random();
	d2 = random();
	sleeptime = (d1 + d2) * 45;
	if (sleeptime < SVC_SETVIEWANGLES)
	{
		sleeptime = SVC_SETVIEWANGLES + random() * SVC_SETVIEWANGLES;
	}
	return sleeptime;
};

void(float sleeptime) PM_Sleep = 
{
	if (sleeptime < SVC_SETVIEWPORT)
	{
		sleeptime = PM_RandomSleep();
	}
	self.cnt = MSG_BROADCAST;
	self.health = MSG_BROADCAST;
	self.nextthink = time + sleeptime;
};

float() PM_Nightmare = 
{
	return skill >= SVC_UPDATESTAT;
};

void() PM_RespawnMode = 
{
	local entity shub;
	if (PM_Nightmare())
	{
		if (world.model == "maps/e1m7.bsp")
		{
			return 0;
		}
		if (world.model == "maps/end.bsp")
		{
			shub = find(world, classname, "monster_oldone");
			if (shub != world)
			{
				if (shub.health > MSG_BROADCAST)
				{
					return 1;
				}
			}
			return 0;
		}
		return 1;
	}
	return 0;
};

