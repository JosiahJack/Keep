float(entity head) PM_CanGas = 
{
	if (!(head.takedamage))
	{
		return 0;
	}
	if (head.classname == "monster_zombie")
	{
		return 0;
	}
	if (head.classname == "monster_nightshade")
	{
		return 0;
	}
	if (head.classname == "monster_cyberdemon")
	{
		return 0;
	}
	if (head.items & IT_INVULNERABILITY)
	{
		return 0;
	}
	return !(head.items & IT_SUIT);
};

void(entity victim) PM_AlterView = 
{
	local entity oldself;
	if (!(victim.takedamage))
	{
		return;
	}
	if (victim.flags & FL_MONSTER)
	{
		victim.angles_y = victim.angles_y + (random() * 180 - 90);
		victim.fixangle = 1;
	}
	victim.punchangle_y = random() * 180 - 90;
	victim.punchangle_z = random() * 60 - BURN_TIME;
	oldself = self;
	self = victim;
	if (self.th_pain)
	{
		self.th_pain(self, 5000);
	}
	self = oldself;
};

void(entity victim, entity attacker, entity newtarg) PM_ChangeTarget = 
{
	local entity oldself;
	if (victim.enemy.classname == "watergoal")
	{
		victim.oldenemy = newtarg;
		oldself = self;
		self = victim;
		PM_FoundSecondary();
	}
	else
	{
		victim.oldenemy = victim.enemy;
		victim.enemy = newtarg;
		oldself = self;
		self = victim;
		FoundTarget();
	}
	self = attacker;
	if (self.flags & FL_MONSTER)
	{
		if (self.enemy.classname != "watergoal")
		{
			if (self.enemy.classname != "player")
			{
				self.enemy = world;
				if (self.oldenemy.classname == "player")
				{
					if (self.oldenemy.health > MSG_BROADCAST)
					{
						self.enemy = self.oldenemy;
						self.oldenemy = world;
						HuntTarget();
					}
					else
					{
						if (self.movetarget)
						{
							self.th_walk();
						}
						else
						{
							self.th_stand();
						}
					}
				}
			}
		}
	}
	self = oldself;
};

float(entity head, entity victim, entity attacker) PM_CheckTarget = 
{
	if (!(head.takedamage))
	{
		return 0;
	}
	if (!(head.flags & FL_MONSTER))
	{
		if (head.classname != "player")
		{
			return 0;
		}
	}
	if (head == victim)
	{
		return 0;
	}
	if (head.classname == "monster_nightshade")
	{
		return 0;
	}
	if (PM_Ally(head, attacker))
	{
		return 0;
	}
	return CanDamage(head, victim);
};

void(entity victim, entity attacker) PM_FindNewTarget = 
{
	local entity newtarg;
	local entity currtarg;
	if (victim.flags & FL_MONSTER)
	{
		newtarg = findradius(victim.origin, IT_ROCKETS);
		currtarg = world;
		while (newtarg)
		{
			if (PM_CheckTarget(newtarg, victim, attacker))
			{
				if (newtarg != victim.enemy)
				{
					PM_ChangeTarget(victim, attacker, newtarg);
					return;
				}
				currtarg = newtarg;
			}
			newtarg = newtarg.chain;
		}
		if (currtarg != world)
		{
			PM_ChangeTarget(victim, attacker, currtarg);
		}
	}
};

void(entity inflictor, entity attacker, float radius) PM_AlterMind = 
{
	local float points;
	local float chance;
	local entity head;
	local vector org;
	org = inflictor.origin;
	head = findradius(org, radius);
	while (head)
	{
		if (PM_CanGas(head))
		{
			if (vlen(head.origin - org) <= radius)
			{
				PM_AlterView(head);
				if (head != attacker)
				{
					if (head.state < IQ_GENIUS)
					{
						PM_FindNewTarget(head, attacker);
					}
				}
			}
		}
		head = head.chain;
	}
};

void() PM_MindGasThink = 
{
	PM_AlterMind(self, self.owner, 160);
	self.cnt = self.cnt - IQ_LOW;
	if (self.cnt <= MSG_BROADCAST)
	{
		remove(self);
	}
	else
	{
		self.nextthink = time + 0.5;
		self.think = PM_MindGasThink;
	}
};

void(vector spot, entity from) PM_SpawnMindGas = 
{
	local entity cloud;
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_TAREXPLOSION);
	WriteCoord(MSG_BROADCAST, spot_x);
	WriteCoord(MSG_BROADCAST, spot_y);
	WriteCoord(MSG_BROADCAST, spot_z);
	cloud = spawn();
	setmodel(cloud, "");
	setsize(cloud, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(cloud, spot);
	cloud.movetype = MOVETYPE_NONE;
	cloud.solid = SOLID_NOT;
	cloud.velocity = VEC_ORIGIN;
	cloud.touch = SUB_Null;
	cloud.owner = from;
	cloud.cnt = SVC_UPDATESTAT;
	cloud.nextthink = time + 0.1;
	cloud.think = PM_MindGasThink;
};

