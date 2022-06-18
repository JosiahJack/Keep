void(float chance) PM_GibZombie = 
{
	local vector delta;
	if (self.enemy.classname != "monster_zombie")
	{
		return;
	}
	chance = chance * 0.010000;
	delta = self.enemy.origin - self.origin;
	if (vlen(delta) <= 60)
	{
		if (random() < chance)
		{
			T_Damage(self.enemy, self, self, self.enemy.health);
		}
	}
};

float(float dist) PM_GrenadeFly = 
{
	local float g;
	local float base;
	g = cvar("sv_gravity") * 0.001250;
	if (dist > 900)
	{
		base = MAX_CHARMER_DISTANCE + (dist - (MAX_CHARMER_DISTANCE - dist * 0.2)) * 0.5;
	}
	else
	{
		if (dist > 700)
		{
			base = MAX_CHARMER_DISTANCE + (dist - (MAX_CHARMER_DISTANCE - dist * 0.15)) * 0.5;
		}
		else
		{
			if (dist > 500)
			{
				base = MAX_CHARMER_DISTANCE + (dist - (MAX_CHARMER_DISTANCE - dist * 0.1)) * 0.5;
			}
			else
			{
				if (dist > 300)
				{
					base = MAX_CHARMER_DISTANCE + (dist - MAX_CHARMER_DISTANCE) * 0.5;
				}
				else
				{
					if (dist > MAX_CHARMER_DISTANCE)
					{
						base = MAX_CHARMER_DISTANCE;
					}
					else
					{
						if (dist > 100)
						{
							base = dist;
						}
						else
						{
							base = 100;
						}
					}
				}
			}
		}
	}
	return base * g;
};

void() PM_SelfRevive = 
{
	local float chance;
	if (skill < IQ_LOW)
	{
		return 0;
	}
	else
	{
		if (skill < IQ_NORMAL)
		{
			chance = 0.1;
		}
		else
		{
			if (skill < SVC_UPDATESTAT)
			{
				chance = 0.25;
			}
			else
			{
				chance = 0.5;
			}
		}
	}
	return random() < chance;
};

