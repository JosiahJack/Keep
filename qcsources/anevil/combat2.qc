void() PM_FoundSecondary = 
{
	if (self.oldenemy.classname == "player")
	{
		sight_entity = self;
		sight_entity_time = time;
	}
	self.show_hostile = time + SPAWNFLAG_SUPERSPIKE;
	SightSound();
	self.think = self.th_run;
	self.nextthink = time + 0.1;
	SUB_AttackFinished(SPAWNFLAG_SUPERSPIKE);
};

float(entity head) PM_NotCreated = 
{
	if (head.classname == "monster_zombie")
	{
		if (head.owner.classname == "monster_nightshade")
		{
			return 0;
		}
		if (head.owner == head)
		{
			return 0;
		}
	}
	return 1;
};

float(entity victim, entity attacker) PM_Stable = 
{
	if (victim.classname != attacker.classname)
	{
		if (victim.state < IQ_GENIUS)
		{
			return 0;
		}
	}
	if (victim.classname == "monster_army")
	{
		return 0;
	}
	if (victim == attacker.enemy)
	{
		return 0;
	}
	if (victim.state == IQ_LOW)
	{
		return 0;
	}
	return 1;
};

float(entity victim, entity attacker) PM_GetMad = 
{
	if (victim == attacker)
	{
		return 0;
	}
	if (victim.enemy == attacker)
	{
		return 0;
	}
	if (attacker.health <= MSG_BROADCAST)
	{
		return 0;
	}
	if (victim.classname == "monster_nightshade")
	{
		return 0;
	}
	if (attacker.classname == "monster_nightshade")
	{
		return 0;
	}
	if (attacker.classname != "player")
	{
		if (PM_Stable(victim, attacker))
		{
			return 0;
		}
	}
	if (victim.enemy.classname == "watergoal")
	{
		return victim.oldenemy != attacker;
	}
	return 1;
};

