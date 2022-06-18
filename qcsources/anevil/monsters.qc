void() monster_use = 
{
	if (self.enemy)
	{
		return;
	}
	if (self.health <= MSG_BROADCAST)
	{
		return;
	}
	if (activator.items & IT_INVISIBILITY)
	{
		if (self.state < IQ_GENIUS)
		{
			if (self.classname != "monster_nightshade")
			{
				return;
			}
		}
	}
	if (activator.flags & FL_NOTARGET && activator.netname == "Susan")
	{
		return;
	}
	if (activator.classname != "player")
	{
		return;
	}
	if (self.superambush)
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
	if (self.oncedead)
	{
		return;
	}
	self.oncedead = 1;
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
	self.origin_z = self.origin_z + WEAPON_SHOTGUN;
	droptofloor();
	self.oncedead = 0;
	self.oldangles = self.angles;
	self.oldstart = self.origin + '0 0 1';
	self.takedamage = DAMAGE_AIM;
	self.ideal_yaw = self.angles * '0 1 0';
	if (!(self.yaw_speed))
	{
		self.yaw_speed = 20;
	}
	self.view_ofs = '0 0 25';
	self.use = monster_use;
	self.flags = self.flags | FL_MONSTER;
	if (!walkmove(MSG_BROADCAST, MSG_BROADCAST))
	{
		dprint("walkmonster in wall at: ");
		dprint(vtos(self.origin));
		dprint("\n");
	}
	if (self.health <= MSG_BROADCAST)
	{
		dprint("walkmonster killed at: ");
		dprint(vtos(self.origin));
		dprint("\n");
		return;
	}
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
	self.flags = self.flags | FL_MONSTER;
	self.think = walkmonster_start_go;
	total_monsters = total_monsters + WEAPON_SHOTGUN;
};

void() flymonster_start_go = 
{
	self.oncedead = 0;
	self.oldangles = self.angles;
	self.oldstart = self.origin + '0 0 1';
	self.takedamage = DAMAGE_AIM;
	self.ideal_yaw = self.angles * '0 1 0';
	if (!(self.yaw_speed))
	{
		self.yaw_speed = SVC_SETVIEWANGLES;
	}
	self.view_ofs = '0 0 25';
	self.use = monster_use;
	self.flags = self.flags | FL_FLY;
	self.flags = self.flags | FL_MONSTER;
	if (PM_InWall(self, self.origin))
	{
		dprint("flymonster in wall at: ");
		dprint(vtos(self.origin));
		dprint("\n");
	}
	if (self.health <= MSG_BROADCAST)
	{
		dprint("flymonster killed at: ");
		dprint(vtos(self.origin));
		dprint("\n");
		return;
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
	self.flags = self.flags | FL_MONSTER;
	self.think = flymonster_start_go;
	total_monsters = total_monsters + WEAPON_SHOTGUN;
};

void() swimmonster_start_go = 
{
	self.oncedead = 0;
	self.oldangles = self.angles;
	self.oldstart = self.origin + '0 0 1';
	self.takedamage = DAMAGE_AIM;
	self.ideal_yaw = self.angles * '0 1 0';
	if (!(self.yaw_speed))
	{
		self.yaw_speed = SVC_SETVIEWANGLES;
	}
	self.view_ofs = '0 0 10';
	self.use = monster_use;
	self.flags = self.flags | FL_SWIM;
	self.flags = self.flags | FL_MONSTER;
	if (PM_InWall(self, self.origin))
	{
		dprint("swimmonster in wall at: ");
		dprint(vtos(self.origin));
		dprint("\n");
	}
	if (self.health <= MSG_BROADCAST)
	{
		dprint("swimmonster killed at: ");
		dprint(vtos(self.origin));
		dprint("\n");
		return;
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
	self.flags = self.flags | FL_MONSTER;
	self.nextthink = self.nextthink + random() * 0.5;
	self.think = swimmonster_start_go;
	total_monsters = total_monsters + WEAPON_SHOTGUN;
};

