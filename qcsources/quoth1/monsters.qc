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
	if (self.classname == "monster_polyp" && self.startonground == WEAPON_SHOTGUN)
	{
		self.nextthink = time + 0.1;
		self.think = PolypFoundTarget;
	}
	else
	{
		self.nextthink = time + 0.1;
		self.think = FoundTarget;
	}
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
	activator = self.enemy;
	SUB_UseTargets();
};

void() walkmonster_start_go = 
{
	local string stemp;
	local entity etemp;
	if (!(self.spawnflags & TRIGGER_SPAWN))
	{
		self.origin_z = self.origin_z + WEAPON_SHOTGUN;
		droptofloor();
	}
	if (!walkmove(MSG_BROADCAST, MSG_BROADCAST))
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
			self.th_stand();
		}
	}
	else
	{
		self.pausetime = 100000000;
		self.th_stand();
	}
	self.nextthink = self.nextthink + random() * 0.5;
	if (self.spawnflags & TRIGGER_SPAWN && (self.spawnflags & TRIGGER_AWAKE) && !(activator.items & IT_INVISIBILITY) && !(activator.flags & FL_NOTARGET) && activator.classname == "player")
	{
		self.enemy = activator;
		FoundTarget();
	}
	if (self.awake == WEAPON_SHOTGUN && !(self.enemy.items & IT_INVISIBILITY) && !(self.enemy.flags & FL_NOTARGET) && self.enemy.classname == "player")
	{
		self.awake = MSG_BROADCAST;
		FoundTarget();
	}
};

void() walkmonster_start = 
{
	if (!(self.spawnflags & TRIGGER_SPAWN))
	{
		self.nextthink = self.nextthink + random() * 0.5;
		self.think = walkmonster_start_go;
	}
	else
	{
		self.nextthink = time + 0.1;
		self.think = walkmonster_start_go;
	}
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
	if (!walkmove(MSG_BROADCAST, MSG_BROADCAST))
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
			self.th_stand();
		}
	}
	else
	{
		self.pausetime = 100000000;
		self.th_stand();
	}
	if (self.spawnflags & TRIGGER_SPAWN && (self.spawnflags & TRIGGER_AWAKE) && !(activator.items & IT_INVISIBILITY) && !(activator.flags & FL_NOTARGET) && activator.classname == "player")
	{
		self.enemy = activator;
		if (self.classname == "monster_polyp")
		{
			PolypFoundTarget();
		}
		else
		{
			FoundTarget();
		}
	}
	if (self.awake == WEAPON_SHOTGUN && !(self.enemy.items & IT_INVISIBILITY) && !(self.enemy.flags & FL_NOTARGET) && self.enemy.classname == "player")
	{
		self.awake = MSG_BROADCAST;
		FoundTarget();
	}
};

void() flymonster_start = 
{
	if (!(self.spawnflags & TRIGGER_SPAWN))
	{
		self.nextthink = self.nextthink + random() * 0.5;
		self.think = flymonster_start_go;
	}
	else
	{
		self.nextthink = time + 0.1;
		self.think = flymonster_start_go;
	}
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
	if (self.spawnflags & TRIGGER_SPAWN && (self.spawnflags & TRIGGER_AWAKE) && !(activator.items & IT_INVISIBILITY) && !(activator.flags & FL_NOTARGET) && activator.classname == "player")
	{
		self.enemy = activator;
		self.nextthink = time + 0.1;
		self.think = FoundTarget;
	}
	if (self.awake == WEAPON_SHOTGUN && !(self.enemy.items & IT_INVISIBILITY) && !(self.enemy.flags & FL_NOTARGET) && self.enemy.classname == "player")
	{
		self.nextthink = time + 0.1;
		self.awake = MSG_BROADCAST;
		self.think = FoundTarget;
	}
};

void() swimmonster_start = 
{
	if (!(self.spawnflags & TRIGGER_SPAWN))
	{
		self.nextthink = self.nextthink + random() * 0.5;
		self.think = swimmonster_start_go;
	}
	else
	{
		self.nextthink = time + 0.1;
		self.think = swimmonster_start_go;
	}
	total_monsters = total_monsters + WEAPON_SHOTGUN;
};

