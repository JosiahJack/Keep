void() trigger_void_touch = 
{
	if (other.classname == "monster_vermis")
	{
		return;
	}
	if (other.takedamage)
	{
		if (other.shield == SPAWN_CRUCIFIED)
		{
			T_Damage(other, self, self, other.health * SPAWNFLAG_LASER + SPAWN_CRUCIFIED);
		}
		else
		{
			T_Damage(other, self, self, other.health + SPAWN_CRUCIFIED);
		}
		if (other.flags & FL_MONSTER)
		{
			remove(other);
		}
	}
	if (other.classname == "gib" || other.classname == "grenade" || other.classname == "spike" || other.classname == "missile")
	{
		remove(other);
	}
	if (other.flags & FL_ITEM)
	{
		remove(other);
	}
	force_retouch = SPAWNFLAG_LASER;
};

void() trigger_void = 
{
	InitTrigger();
	self.touch = trigger_void_touch;
};

void() trigger_gravity_touch = 
{
	if (other.classname != "player")
	{
		return;
	}
	if (self.gravity == CONTENT_EMPTY)
	{
		other.gravity = SPAWN_CRUCIFIED;
	}
	else
	{
		other.gravity = self.gravity;
	}
};

void() trigger_setgravity = 
{
	InitTrigger();
	self.touch = trigger_gravity_touch;
	if (!(self.gravity))
	{
		self.gravity = CONTENT_EMPTY;
	}
	else
	{
		self.gravity = (self.gravity - SPAWN_CRUCIFIED) / 100;
	}
};

