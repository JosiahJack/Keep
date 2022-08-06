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

float() orig_random = 
{
	local float len;
	len = vlen(self.origin);
	return len - floor(len);
};

void() killed_monster = 
{
	if (cvar("developer") > WEAPON_SHOTGUN)
	{
		print_self("monster", "killed");
	}
	killed_monsters = killed_monsters + WEAPON_SHOTGUN;
	WriteByte(MSG_ALL, SVC_KILLEDMONSTER);
};

void(string type, string text) print_self = 
{
	dprint(type);
	dprint(" '");
	dprint(self.classname);
	dprint("' ");
	dprint(text);
	dprint(" at ");
	dprint(vtos(self.origin));
	dprint("\n");
};

void() walkmonster_start_go = 
{
	local string stemp;
	local entity etemp;
	self.origin_z = self.origin_z + WEAPON_SHOTGUN;
	droptofloor();
	if (!walkmove(counter, counter))
	{
		print_self("walkmonster", "in wall");
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
	if (self.health <= counter)
	{
		print_self("walkmonster", "killed");
		return;
	}
	if (self.target)
	{
		self.goalentity = self.movetarget = find(world, targetname, self.target);
		self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
		if (!(self.movetarget))
		{
			print_self("walkmonster", "can't find target");
		}
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
	self.nextthink = self.nextthink + random() * 0.5;
};

void() walkmonster_start = 
{
	self.nextthink = self.nextthink + random() * 0.5;
	self.think = walkmonster_start_go;
	total_monsters = total_monsters + WEAPON_SHOTGUN;
};

void() flymonster_start_go = 
{
	self.takedamage = DAMAGE_AIM;
	self.ideal_yaw = self.angles * '0 1 0';
	if (!(self.yaw_speed))
	{
		self.yaw_speed = TE_LAVASPLASH;
	}
	self.view_ofs = '0 0 25';
	self.use = monster_use;
	self.flags = self.flags | FL_FLY;
	self.flags = self.flags | FL_MONSTER;
	if (!walkmove(counter, counter))
	{
		print_self("flymonster", "in wall");
	}
	if (self.health <= counter)
	{
		print_self("flymonster", "killed");
		return;
	}
	if (self.target)
	{
		self.goalentity = self.movetarget = find(world, targetname, self.target);
		if (!(self.movetarget))
		{
			print_self("flymonster", "can't find target");
		}
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

void() flymonster_start = 
{
	self.nextthink = self.nextthink + random() * 0.5;
	self.think = flymonster_start_go;
	total_monsters = total_monsters + WEAPON_SHOTGUN;
};

void() swimmonster_start_go = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	self.takedamage = DAMAGE_AIM;
	self.ideal_yaw = self.angles * '0 1 0';
	if (!(self.yaw_speed))
	{
		self.yaw_speed = TE_LAVASPLASH;
	}
	self.view_ofs = '0 0 10';
	self.use = monster_use;
	self.flags = self.flags | FL_SWIM;
	self.flags = self.flags | FL_MONSTER;
	if (!walkmove(counter, counter))
	{
		print_self("swimmonster", "in wall");
	}
	if (self.health <= counter)
	{
		print_self("swimmonster", "killed");
		return;
	}
	if (self.target)
	{
		self.goalentity = self.movetarget = find(world, targetname, self.target);
		if (!(self.movetarget))
		{
			print_self("swimmonster", "can't find target");
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
	total_monsters = total_monsters + WEAPON_SHOTGUN;
};

