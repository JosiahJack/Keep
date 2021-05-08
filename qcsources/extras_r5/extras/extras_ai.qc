/*
================
getRidOfTempGoal

Remove temporary target
================
*/
void() getRidOfTempGoal =
{
    if(!self.tempgoal)
        return;

	self.enemy = self.oldenemy;
	self.goalentity = self.enemy;
	self.movetarget = self.enemy;

	remove(self.tempgoal);
	self.tempgoal = world;
}

/*
================
delayedTargetChange

Remove temporary target
================
*/
void() delayedTargetChange =
{
	self.owner.tempgoal = world;
	self.owner.enemy = self.owner.oldenemy;
	self.owner.goalentity = self.owner.enemy;
	self.owner.movetarget = self.owner.enemy;

	remove(self);
}

/*
================
SpawnTempGoal

Spawn temporary target/goal to follow, when on water surface
================
*/
void() SpawnTempGoal =
{
	local	entity	tmpgoal;
	local	vector	tmppos;
	
	if(!self.tempgoal)
	{
		//dprint("Creating temporary goal\n");
		tmpgoal = spawn();
		tmpgoal.classname = "tmp_goal";
		tmpgoal.health = 1;
		tmpgoal.movetype = MOVETYPE_NONE;
		tmpgoal.solid = SOLID_NOT;
		setorigin (tmpgoal, self.goalentity.origin);
		setsize (tmpgoal, '-4 -4 -4 ', '4 4 4');
		tmpgoal.view_ofs = ' 0 0 4 ';
		tmpgoal.owner = self;
		tmpgoal.think = delayedTargetChange;
		tmpgoal.nextthink = time + 2;

		self.tempgoal = tmpgoal;
		self.oldenemy = self.enemy;
		self.enemy = self.tempgoal;
	}

	tmppos = self.oldenemy.origin;
	tmppos_z = self.origin_z - self.size_z;

	setorigin (self.tempgoal, tmppos);
	self.goalentity = self.tempgoal;
	self.movetarget = self.tempgoal;
}

/*
================
unsuckFromWaterSurface

Return TRUE when unstuck procedure succeded
Return FALSE when unstuck procedure has been canceled or failed
================
*/
float() unsuckFromWaterSurface =
{
	if(self.oldenemy && range(self.oldenemy) == RANGE_MELEE && self.flags & FL_SWIM)
		return TRUE;

	if(self.flags & FL_SWIM)
	{
		if(pointcontents(self.origin + '0 0 10') > -3)
		{
			SpawnTempGoal();
			return TRUE;
		}
	}
	else if(self.flags & FL_FLY && self.infuncwater)
	{
		if(self.onSurface)
		{
			SpawnTempGoal();
			return TRUE;
		}
	}
	return FALSE;
}

/*
================
handleFuncWaterSwimming
================
*/
void() handleFuncWaterSwimming =
{
    if(self.infuncwater && self.flags)
    {
		self.gravity = 1;
		self.flags = self.flags | FL_FLY;
        self.flags = self.flags - (self.flags & FL_SWIM);
		if(self.movetype != MOVETYPE_STEP)
		{
			self.movetype = MOVETYPE_STEP;
		}
    }
	else if (!self.infuncwater && self.inBSPwater)
	{
		self.gravity = 1;
		self.flags = self.flags | FL_SWIM;
		if(self.movetype != MOVETYPE_STEP)
		{
			self.movetype = MOVETYPE_STEP;
		}
	}
	
	if(unsuckFromWaterSurface())
		return;
	
	if(!self.infuncwater && !self.inBSPwater)
	{
		self.gravity = 0.375;
		self.flags = self.flags - (self.flags & FL_SWIM);
		self.flags = self.flags - (self.flags & FL_FLY);
		
		if(self.flags & FL_ONGROUND)
		{
			self.gravity = 1;
			//dprint("On the ground!!!\n");
			self.flags = self.flags - (self.flags & FL_ONGROUND);
			self.flags = self.flags | FL_SWIM;
		}
	}
}

/*
================
ai_fish_movement

Fish movement - new logic
================
*/
void(string action, float value) ai_fish_movement=
{
	///////////////////////////////////
	///	Do things every animation frame
	handleFuncWaterSwimming();
	///////////////////////////////////

	///	Remember every action execute vanilla_water_check()
	if(action == "ai_walk")
	{
		ai_walk(value);
	}
	else if(action == "ai_run")
	{
		ai_run(value);
	}
	else if(action == "ai_pain")
	{
		ai_pain(value);
	}
	else if(action == "ai_charge")
	{
		if(!(self.enemy.flags & FL_CLIENT))
		{
			getRidOfTempGoal();
		}
		ai_charge(value);
	}
}
