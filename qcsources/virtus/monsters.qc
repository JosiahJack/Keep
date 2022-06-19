void() monster_use = 
{
	if (self.enemy)
	{
		return;
	}
	if (self.health <= 0)
	{
		return;
	}
	if (activator.items & IT_INVISIBILITY)
	{
		return;
	}
	if (activator.flags & FL_NOTARGET)
	{
		return;
	}
	if (activator.classname != "player")
	{
		return;
	}
	self.enemy = activator;
	self.nextthink = time + 0.1;
	self.think = FoundTarget;
};

void() monster_death_use = 
{
	local entity ent;
	local entity otemp;
	local entity stemp;
	if (self.flags & FL_FLY)
	{
		self.flags = self.flags - FL_FLY;
	}
	if (self.flags & FL_SWIM)
	{
		self.flags = self.flags - FL_SWIM;
	}
	if (!(self.target))
	{
		return;
	}
	activator = self.enemy;
	SUB_UseTargets();
};

void() walkmonster_start_go = 
{
	local string stemp;
	local entity etemp;
	self.origin_z = self.origin_z + 1;
	droptofloor();
	if (!walkmove(0, 0))
	{
		dprint("walkmonster in wall at: ");
		dprint(vtos(self.origin));
		dprint("\n");
	}
	self.takedamage = DAMAGE_AIM;
	self.ideal_yaw = self.angles * '0 1 0';
	if (!(self.yaw_speed))
	{
		self.yaw_speed = 20;
	}
	self.view_ofs = '0 0 25';
	self.use = monster_use;
	self.flags = self.flags | FL_MONSTER;
	if (self.target)
	{
		self.goalentity = self.movetarget = find(world, targetname, self.target);
		self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
		if (!(self.movetarget))
		{
			dprint("Monster can't find target at ");
			dprint(vtos(self.origin));
			dprint("\n");
		}
		if (self.movetarget.classname == "path_corner")
		{
			self.th_walk();
		}
		else
		{
			self.pausetime = 100000000;
		}
		self.th_stand();
	}
	else
	{
		self.pausetime = 100000000;
		self.th_stand();
	}
	self.nextthink = self.nextthink + random() * 0.5;
};

void() walkmonster_start = 
{
	self.nextthink = self.nextthink + random() * 0.5;
	self.think = walkmonster_start_go;
	total_monsters = total_monsters + 1;
};

void() flymonster_start_go = 
{
	self.takedamage = DAMAGE_AIM;
	self.ideal_yaw = self.angles * '0 1 0';
	if (!(self.yaw_speed))
	{
		self.yaw_speed = MOVETYPE_BOUNCE;
	}
	self.view_ofs = '0 0 25';
	self.use = monster_use;
	self.flags = self.flags | FL_FLY;
	self.flags = self.flags | FL_MONSTER;
	if (!walkmove(0, 0))
	{
		dprint("flymonster in wall at: ");
		dprint(vtos(self.origin));
		dprint("\n");
	}
	if (self.target)
	{
		self.goalentity = self.movetarget = find(world, targetname, self.target);
		if (!(self.movetarget))
		{
			dprint("Monster can't find target at ");
			dprint(vtos(self.origin));
			dprint("\n");
		}
		if (self.movetarget.classname == "path_corner")
		{
			self.th_walk();
		}
		else
		{
			self.pausetime = 100000000;
		}
		self.th_stand();
	}
	else
	{
		self.pausetime = 100000000;
		self.th_stand();
	}
};

void() flymonster_start = 
{
	self.nextthink = self.nextthink + random() * 0.5;
	self.think = flymonster_start_go;
	total_monsters = total_monsters + 1;
};

void() swimmonster_start_go = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	self.takedamage = DAMAGE_AIM;
	total_monsters = total_monsters + 1;
	self.ideal_yaw = self.angles * '0 1 0';
	if (!(self.yaw_speed))
	{
		self.yaw_speed = MOVETYPE_BOUNCE;
	}
	self.view_ofs = '0 0 10';
	self.use = monster_use;
	self.flags = self.flags | FL_SWIM;
	self.flags = self.flags | FL_MONSTER;
	if (self.target)
	{
		self.goalentity = self.movetarget = find(world, targetname, self.target);
		if (!(self.movetarget))
		{
			dprint("Monster can't find target at ");
			dprint(vtos(self.origin));
			dprint("\n");
		}
		self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
		self.th_walk();
	}
	else
	{
		self.pausetime = 100000000;
		self.th_stand();
	}
	self.nextthink = self.nextthink + random() * 0.5;
};

void() swimmonster_start = 
{
	self.nextthink = self.nextthink + random() * 0.5;
	self.think = swimmonster_start_go;
	total_monsters = total_monsters + 1;
};

