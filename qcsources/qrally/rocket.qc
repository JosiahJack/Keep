entity(vector org, vector dir, float dist, float angle_range, string filter_class, entity ignore) FindSightEnemy = 
{
	local entity trav;
	local float trav_yaw;
	local float dir_yaw;
	dir_yaw = vectoyaw(dir);
	if (rally_type_index == 4 && self.classname == "player")
	{
		trav = find(world, classname, "monster_boss");
		if (trav != world && trav.health > 0)
		{
			return trav;
		}
	}
	trav = findradius(org, dist);
	while (trav != world)
	{
		if (filter_class == "all" || filter_class == trav.classname && trav != ignore)
		{
			if (trav.classname == "player" || trav.classname == "rally_kangaroo" || trav.classname == "rally_dude" || trav.classname == "monster_boss" && trav.health > 0)
			{
				trav_yaw = vectoyaw(trav.origin - org);
				if (fabs(angle_diff(dir_yaw, trav_yaw)) <= angle_range)
				{
					traceline(org, trav.origin, 1, world);
					if (trace_fraction == 1)
					{
						return trav;
					}
				}
			}
		}
		trav = trav.chain;
	}
	return trav;
};

void() RocketSeek = 
{
	local float current_speed;
	local vector target_vector;
	local vector vel;
	local vector unit_velocity;
	local vector target_org;
	if (self.enemy.health <= 0)
	{
		self.enemy = world;
		return;
	}
	if (self.enemy == world)
	{
		return;
	}
	if (self.last_idle < time - 5 && (self.owner.classname != "monster_boss" || self.last_idle < time - 10))
	{
		remove(self);
		return;
	}
	if (self.enemy.classname == "player" && self.enemy.velocity == '0 0 0')
	{
		return;
	}
	if (self.enemy.classname == "rally_dude" || self.enemy.classname == "rally_kangaroo" && vlen(self.origin - self.enemy.origin) < 64)
	{
		other = self.enemy;
		T_MissileTouch();
		return;
	}
	current_speed = vlen(self.velocity);
	target_org = self.enemy.origin;
	if (self.enemy.classname == "monster_boss")
	{
		target_org = target_org + '0 0 64';
	}
	target_vector = normalize(target_org - self.origin);
	unit_velocity = normalize(self.velocity);
	self.velocity = normalize(target_vector + unit_velocity * 3) * current_speed;
	vel = normalize(self.velocity);
	self.angles = vectoangles(vel);
	self.nextthink = time + 0.05;
};

