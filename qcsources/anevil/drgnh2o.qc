float() PM_Hydrophobic = 
{
	if (self.burnend > time)
	{
		return 0;
	}
	return self.aflag;
};

float(float dist) PM_FindAir = 
{
	local vector dir;
	dir = self.origin;
	dir_z = dir_z + dist;
	traceline(self.origin, dir, 0, self);
	if (trace_inopen)
	{
		if (trace_inwater)
		{
			return 1;
		}
	}
	return 0;
};

float(float dist) PM_LeaveWater = 
{
	if (PM_FindAir(IT_ROCKETS))
	{
		if (go_up(dist))
		{
			return 1;
		}
	}
	if (PM_FindAir(-1024))
	{
		if (go_down(dist))
		{
			return 1;
		}
	}
	return 0;
};

float(float dist) PM_NearLiquid = 
{
	local vector dir;
	local vector org;
	if (PM_InLiquid(self))
	{
		return 0;
	}
	dist = dist * 0.5;
	org = self.origin;
	dir = org;
	dir_z = dir_z - dist + self.mins_z - HUD_ON;
	traceline(org, dir, 1, self);
	if (trace_inopen)
	{
		if (trace_inwater)
		{
			ai_face();
			if (go_up(dist))
			{
				return 1;
			}
			else
			{
				return 0;
			}
		}
	}
	dir = org;
	dir_z = dir_z + dist + self.maxs_z + HUD_ON;
	traceline(org, dir, 1, self);
	if (trace_inopen)
	{
		if (trace_inwater)
		{
			ai_face();
			if (go_down(dist))
			{
				return 1;
			}
			else
			{
				return 0;
			}
		}
	}
	return 0;
};

void(float dist) PM_WaterDive = 
{
	local vector dir;
	local vector org;
	if (self.pos1 == VEC_ORIGIN)
	{
		return;
	}
	if (PM_InWater(self))
	{
		return;
	}
	org = self.origin;
	dir = org;
	if (self.pos1_z > self.origin_z)
	{
		dir_z = dir_z + self.mins_z + IT_CELLS;
		traceline(org, dir, 1, self);
		if (trace_inopen)
		{
			if (trace_inwater)
			{
				go_up(dist);
			}
		}
	}
	else
	{
		dir_z = dir_z + self.mins_z - IT_CELLS;
		traceline(org, dir, 1, self);
		if (trace_inopen)
		{
			if (trace_inwater)
			{
				go_down(dist);
			}
		}
	}
};

void() PM_RestoreWaterPath = 
{
	setorigin(self.owner.watergoal, self.owner.pos1);
};

void() PM_WaterDetour = 
{
	if (!(self.watergoal))
	{
		return;
	}
	makevectors(self.angles);
	self.pos2 = self.pos1 - v_forward * random() * IT_ROCKETS + v_right * (random() * IT_CELLS - IT_ROCKETS) + v_up * (random() * IT_CELLS - IT_ROCKETS);
	setorigin(self.watergoal, self.pos2);
	self.watergoal.nextthink = time + IQ_NORMAL;
	self.watergoal.think = PM_RestoreWaterPath;
};

void(float dist) PM_CheckWaterPath = 
{
	local vector dir;
	local vector org;
	makevectors(self.angles);
	org = self.origin;
	if (self.goalentity.origin_z < self.origin_z)
	{
		org_z = org_z + self.mins_z;
	}
	else
	{
		org_z = org_z + self.maxs_z;
	}
	dir = org + v_forward * 160;
	traceline(org, dir, 0, self);
	if (trace_fraction < SPAWNFLAG_SUPERSPIKE)
	{
		if (trace_ent != self.goalentity)
		{
			if (self.pos1 != VEC_ORIGIN)
			{
				if (self.goalentity.origin == self.pos1)
				{
					PM_WaterDetour();
				}
			}
		}
	}
};

float(vector spot) PM_SightWater = 
{
	if (!spot)
	{
		return 0;
	}
	if (pointcontents(spot) != CONTENT_WATER)
	{
		if (pointcontents(spot) != CONTENT_SLIME)
		{
			return 0;
		}
	}
	traceline(self.origin, spot, 1, self);
	if (trace_fraction < SPAWNFLAG_SUPERSPIKE)
	{
		return 0;
	}
	self.pos1 = spot;
	return 1;
};

float() PM_LocateWater = 
{
	local vector dir;
	local vector org;
	org = self.origin;
	dir = org;
	dir_z = dir_z + self.mins_z - IT_CELLS;
	traceline(org, dir, 1, self);
	if (PM_SightWater(trace_endpos))
	{
		return 1;
	}
	dir = org;
	dir_z = dir_z + self.maxs_z + IT_CELLS;
	traceline(org, dir, 1, self);
	if (PM_SightWater(trace_endpos))
	{
		return 1;
	}
	dir_x = org_x + random() * IT_CELLS - IT_ROCKETS;
	dir_y = org_y + random() * IT_CELLS - IT_ROCKETS;
	dir_z = org_z - random() * IT_ROCKETS;
	return PM_SightWater(dir);
};

void() PM_WaterMemory = 
{
	if (PM_InWater(self))
	{
		self.pos1 = self.origin;
		return;
	}
	if (self.pos1 != VEC_ORIGIN)
	{
		return;
	}
	if (PM_LocateWater())
	{
		return;
	}
	if (self.pos1 == VEC_ORIGIN)
	{
		if (self.enemy)
		{
			if (PM_InWater(self.enemy))
			{
				self.pos1 = self.enemy.origin;
			}
		}
	}
};

void(vector spot) PM_NewWaterGoal = 
{
	self.watergoal = spawn();
	setmodel(self.watergoal, "");
	setsize(self.watergoal, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(self.watergoal, spot);
	self.watergoal.solid = SOLID_NOT;
	self.watergoal.movetype = MOVETYPE_NONE;
	self.watergoal.takedamage = DAMAGE_NO;
	self.watergoal.touch = SUB_Null;
	self.watergoal.classname = "watergoal";
	self.watergoal.owner = self;
	self.watergoal.health = 50000;
	self.oldenemy = self.enemy;
	self.enemy = self.watergoal;
	self.goalentity = self.watergoal;
};

void() PM_SeekWater = 
{
	if (self.watergoal)
	{
		return;
	}
	if (self.pos1 != VEC_ORIGIN)
	{
		PM_NewWaterGoal(self.pos1);
	}
};

void(float dist) PM_DragonStatus = 
{
	if (self.state < IQ_HIGH)
	{
		return;
	}
	PM_WaterMemory();
	if (self.burnend > time)
	{
		if (self.health > MSG_BROADCAST)
		{
			PM_SeekWater();
			PM_WaterDive(dist);
			return;
		}
	}
	if (self.watergoal)
	{
		remove(self.watergoal);
		self.watergoal = world;
		self.enemy = self.oldenemy;
		self.oldenemy = world;
		self.goalentity = self.enemy;
		self.pos1 = VEC_ORIGIN;
	}
};

