void() PM_UpdateGoldFear = 
{
	if (self.classname != "monster_golddragon")
	{
		return;
	}
	if (self.state > IQ_NORMAL)
	{
		if (self.enemy.health > MSG_BROADCAST)
		{
			if (PM_InLiquid(self.enemy))
			{
				self.aflag = 1;
				return;
			}
		}
	}
	self.aflag = 0;
};

float() PM_DragonChance = 
{
	if (enemy_range == RANGE_MELEE)
	{
		self.attack_finished = MSG_BROADCAST;
		return 0.9;
	}
	if (self.classname == "monster_reddragon" || self.classname == "monster_golddragon")
	{
		if (enemy_range == RANGE_NEAR)
		{
			return 0.2;
		}
		if (enemy_range == RANGE_MID)
		{
			return 0.1;
		}
		return 0.020000;
	}
	if (self.classname == "monster_bluedragon")
	{
		if (enemy_range == RANGE_NEAR)
		{
			return 0.05;
		}
		if (enemy_range == RANGE_MID)
		{
			return 0.020000;
		}
		return MSG_BROADCAST;
	}
	if (enemy_range == RANGE_NEAR)
	{
		return 0.2;
	}
	if (enemy_range == RANGE_MID)
	{
		return 0.05;
	}
	return MSG_BROADCAST;
};

float() PM_DragonCheckAttack = 
{
	local vector spot1;
	local vector spot2;
	local entity targ;
	local float chance;
	local float pause;
	targ = self.enemy;
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;
	if (self.state == IQ_LOW)
	{
		traceline(spot1, spot2, 1, self);
		if (trace_fraction < IQ_LOW)
		{
			return 0;
		}
	}
	else
	{
		traceline(spot1, spot2, 0, self);
		if (trace_ent != targ)
		{
			return 0;
		}
	}
	if (enemy_range == RANGE_MELEE)
	{
		if (self.th_melee)
		{
			if (CanDamage(targ, self))
			{
				self.attack_state = AS_MELEE;
				return 1;
			}
		}
	}
	if (!(self.th_missile))
	{
		return 0;
	}
	if (time < self.attack_finished)
	{
		return 0;
	}
	if (PM_Hydrophobic())
	{
		if (PM_InLiquid(self))
		{
			if (self.classname != "monster_golddragon")
			{
				return 0;
			}
		}
	}
	chance = PM_DragonChance();
	if (random() < chance)
	{
		self.th_missile();
		pause = random() * IQ_NORMAL + IQ_LOW;
		SUB_AttackFinished(pause);
		return 1;
	}
	return 0;
};

float(entity client) PM_NotSeen = 
{
	if (!infront(client))
	{
		return 1;
	}
	if (self.spawnflags & SPAWN_DORMANT)
	{
		if (self.classname != "monster_nightshade")
		{
			return 1;
		}
	}
	return 0;
};

float() PM_DragonFindTarget = 
{
	local entity client;
	local float r;
	if (self.spawnflags & SPAWN_PACIFIST)
	{
		return 0;
	}
	if (sight_entity_time >= time - 0.1 && !(self.spawnflags & IQ_LOW))
	{
		client = sight_entity;
		if (self.enemy.classname == "watergoal")
		{
			if (client.enemy == self.oldenemy)
			{
				return 0;
			}
		}
		else
		{
			if (client.enemy == self.enemy)
			{
				return 0;
			}
		}
	}
	else
	{
		client = checkclient();
		if (!client)
		{
			return 0;
		}
	}
	if (self.enemy.classname == "watergoal")
	{
		if (client == self.oldenemy)
		{
			return 0;
		}
	}
	else
	{
		if (client == self.enemy)
		{
			return 0;
		}
	}
	if (client.flags & FL_NOTARGET)
	{
		return 0;
	}
	if (client.items & IT_INVISIBILITY)
	{
		if (self.state < IQ_GENIUS)
		{
			if (self.classname != "monster_nightshade")
			{
				return 0;
			}
		}
	}
	r = range(client);
	if (r == RANGE_FAR)
	{
		return 0;
	}
	if (!visible(client))
	{
		return 0;
	}
	if (r == RANGE_NEAR)
	{
		if (client.show_hostile < time)
		{
			if (PM_NotSeen(client))
			{
				return 0;
			}
		}
	}
	else
	{
		if (r == RANGE_MID)
		{
			if (PM_NotSeen(client))
			{
				return 0;
			}
		}
	}
	if (self.enemy.classname == "watergoal")
	{
		self.oldenemy = client;
		if (self.oldenemy.classname != "player")
		{
			self.oldenemy = self.oldenemy.enemy;
			if (self.oldenemy.classname != "player")
			{
				self.oldenemy = world;
				return 0;
			}
		}
		PM_FoundSecondary();
	}
	else
	{
		self.enemy = client;
		if (self.enemy.classname != "player")
		{
			self.enemy = self.enemy.enemy;
			if (self.enemy.classname != "player")
			{
				self.enemy = world;
				return 0;
			}
		}
		FoundTarget();
	}
	return 1;
};

void(float dist, float sidemove) drag_missile = 
{
	PM_Regenerate();
	if (self.pos1 == VEC_ORIGIN)
	{
		PM_WaterMemory();
	}
	ai_face();
	if (self.state < IQ_GENIUS)
	{
		sidemove = dist;
	}
	if (PM_DetectDanger(sidemove))
	{
		return;
	}
	if (PM_Hydrophobic())
	{
		if (PM_NearLiquid(dist))
		{
			return;
		}
	}
	walkmove(self.angles_y, dist);
	PM_AntiClip();
	PM_AntiTrap(sidemove);
};

void(float dist, float sidemove) drag_melee = 
{
	local vector delta;
	PM_Regenerate();
	if (self.pos1 == VEC_ORIGIN)
	{
		PM_WaterMemory();
	}
	ai_face();
	delta = self.enemy.origin - self.origin;
	if (vlen(delta) > TOOCLOSE_CHARMER_DISTANCE)
	{
		if (self.state < IQ_GENIUS)
		{
			if (PM_DetectDanger(dist))
			{
				return;
			}
		}
		else
		{
			if (PM_DetectDanger(sidemove))
			{
				return;
			}
		}
	}
	if (PM_Hydrophobic())
	{
		if (PM_NearLiquid(dist))
		{
			return;
		}
	}
	movetogoal(dist);
	PM_AntiClip();
	PM_AntiTrap(sidemove);
};

void(float dist) drag_panic = 
{
	movedist = dist;
	self.show_hostile = time + IQ_LOW;
	if (PM_DetectDanger(dist * IQ_NORMAL))
	{
		return;
	}
	PM_DragonStatus(dist);
	PM_CheckWaterPath(dist);
	movetogoal(dist);
	PM_AntiClip();
	walkmove(self.angles_y, dist);
	PM_AntiClip();
};

void(float dist, float panic) drag_stand = 
{
	PM_Regenerate();
	if (PM_DragonFindTarget())
	{
		return;
	}
	if (time > self.pausetime)
	{
		self.th_walk();
		return;
	}
	if (self.enemy.classname == "watergoal")
	{
		drag_panic(panic);
		return;
	}
	PM_DragonStatus(panic);
	if (PM_Hydrophobic())
	{
		if (PM_InLiquid(self))
		{
			PM_LeaveWater(dist);
			return;
		}
		PM_NearLiquid(dist);
	}
};

void(float dist, float panic) drag_walk = 
{
	PM_Regenerate();
	movedist = dist;
	if (PM_DragonFindTarget())
	{
		return;
	}
	if (self.enemy.classname == "watergoal")
	{
		drag_panic(panic);
		return;
	}
	PM_DragonStatus(panic);
	if (PM_Hydrophobic())
	{
		if (PM_InLiquid(self))
		{
			if (!PM_LeaveWater(dist))
			{
				movetogoal(dist);
				PM_AntiClip();
			}
			return;
		}
		if (PM_NearLiquid(dist))
		{
			return;
		}
	}
	movetogoal(dist);
	PM_AntiClip();
};

float() PM_BlockDragonSight = 
{
	if (self.state < IQ_HIGH)
	{
		return 1;
	}
	if (self.classname == "monster_bluedragon")
	{
		return 0;
	}
	if (self.classname == "monster_golddragon")
	{
		return 0;
	}
	return vlen(self.enemy.origin - self.origin) > TOOCLOSE_CHARMER_DISTANCE;
};

float(entity targ) drag_visible = 
{
	local vector spot1;
	local vector spot2;
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;
	traceline(spot1, spot2, 1, self);
	if (trace_inopen)
	{
		if (trace_inwater)
		{
			if (PM_BlockDragonSight())
			{
				return 0;
			}
		}
	}
	return trace_fraction == IQ_LOW;
};

void(float dist) drag_run_attack = 
{
	if (PM_DetectDanger(dist))
	{
		self.attack_state = AS_STRAIGHT;
		return;
	}
	self.ideal_yaw = enemy_yaw;
	ChangeYaw();
	if (FacingIdeal())
	{
		if (enemy_range == RANGE_MELEE)
		{
			if (self.th_melee)
			{
				self.th_melee();
				self.attack_state = AS_STRAIGHT;
				return;
			}
		}
		if (self.th_missile)
		{
			if (!PM_Hydrophobic() || !PM_InLiquid(self))
			{
				self.th_missile();
			}
		}
		self.attack_state = AS_STRAIGHT;
	}
};

void(float dist) drag_run = 
{
	PM_Regenerate();
	if (self.enemy.classname == "watergoal")
	{
		drag_panic(dist);
		return;
	}
	PM_UpdateGoldFear();
	movedist = dist;
	if (self.enemy.health <= MSG_BROADCAST)
	{
		self.enemy = world;
		if (self.oldenemy.health > MSG_BROADCAST)
		{
			self.enemy = self.oldenemy;
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
			return;
		}
	}
	self.show_hostile = time + IQ_LOW;
	enemy_vis = drag_visible(self.enemy);
	if (enemy_vis)
	{
		self.search_time = time + SVC_SETVIEWPORT;
	}
	if (coop || deathmatch)
	{
		if (self.search_time < time)
		{
			if (PM_DragonFindTarget())
			{
				return;
			}
		}
	}
	PM_DragonStatus(dist);
	enemy_infront = infront(self.enemy);
	enemy_range = range(self.enemy);
	enemy_yaw = vectoyaw(self.enemy.origin - self.origin);
	if (self.attack_state == AS_MISSILE)
	{
		drag_run_attack(dist);
		return;
	}
	if (self.attack_state == AS_MELEE)
	{
		drag_run_attack(dist);
		return;
	}
	if (enemy_vis)
	{
		if (PM_DragonCheckAttack())
		{
			return;
		}
	}
	if (PM_DetectDanger(dist))
	{
		return;
	}
	if (PM_Hydrophobic())
	{
		if (PM_InLiquid(self))
		{
			if (PM_LeaveWater(dist))
			{
				return;
			}
		}
		if (PM_NearLiquid(dist))
		{
			return;
		}
	}
	movetogoal(dist);
	PM_AntiClip();
	PM_AntiTrap(dist);
};

