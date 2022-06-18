void(float reverse, float dist) PM_Eject = 
{
	local vector dir;
	local float idealyaw;
	local float headyaw;
	local float diffyaw;
	walkmove(reverse, dist);
	if (self.enemy)
	{
		traceline(self.origin, self.enemy.origin, 0, self);
		if (trace_ent == self.enemy)
		{
			self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
		}
		else
		{
			dir = normalize(self.enemy.origin - self.origin);
			idealyaw = vectoyaw(dir);
			idealyaw = anglemod(idealyaw);
			headyaw = anglemod(self.angles_y);
			diffyaw = anglemod(idealyaw - headyaw);
			if (diffyaw < 180)
			{
				self.ideal_yaw = anglemod(self.angles_y + 90);
			}
			else
			{
				self.ideal_yaw = anglemod(self.angles_y - 90);
			}
		}
		ChangeYaw();
		return;
	}
	if (random() < 0.5)
	{
		self.ideal_yaw = anglemod(self.angles_y + 90);
	}
	else
	{
		self.ideal_yaw = anglemod(self.angles_y - 90);
	}
	ChangeYaw();
};

void() PM_AntiClip = 
{
	local vector dir;
	local vector org;
	local float dist;
	org = self.origin;
	dir = org;
	dir_x = dir_x + self.maxs_x;
	traceline(org, dir, 0, self);
	if (trace_fraction < SPAWNFLAG_SUPERSPIKE)
	{
		dist = self.maxs_x * (SPAWNFLAG_SUPERSPIKE - trace_fraction);
		PM_Eject(180, dist);
	}
	else
	{
		dir_x = org_x + self.mins_x;
		traceline(org, dir, 0, self);
		if (trace_fraction < SPAWNFLAG_SUPERSPIKE)
		{
			dist = self.mins_x * (trace_fraction - SPAWNFLAG_SUPERSPIKE);
			PM_Eject(MSG_BROADCAST, dist);
		}
	}
	dir = org;
	dir_y = dir_y + self.maxs_y;
	traceline(org, dir, 0, self);
	if (trace_fraction < SPAWNFLAG_SUPERSPIKE)
	{
		dist = self.maxs_y * (SPAWNFLAG_SUPERSPIKE - trace_fraction);
		PM_Eject(270, dist);
	}
	else
	{
		dir_y = org_y + self.mins_y;
		traceline(org, dir, 0, self);
		if (trace_fraction < SPAWNFLAG_SUPERSPIKE)
		{
			dist = self.mins_y * (trace_fraction - SPAWNFLAG_SUPERSPIKE);
			PM_Eject(90, dist);
		}
	}
};

void(float dist) PM_AntiTrap = 
{
	local vector org;
	local vector spot;
	local entity clipped;
	if (self.classname == "monster_nightshade")
	{
		return;
	}
	if (self.enemy.classname == "player")
	{
		if (vlen(self.enemy.origin - self.origin) < 300)
		{
			spot = self.enemy.origin;
			spot_z = spot_z + self.enemy.mins_z;
			if (pointcontents(spot) == CONTENT_SOLID)
			{
				PM_FindBestPath(dist, clipped);
				return;
			}
		}
	}
	traceline(self.origin, self.enemy.origin, 0, self);
	if (trace_fraction < SPAWNFLAG_SUPERSPIKE)
	{
		if (trace_ent == world)
		{
			return;
		}
		if (trace_ent.solid == SOLID_BSP)
		{
			return;
		}
	}
	if (!trace_ent)
	{
		clipped = self.enemy;
	}
	else
	{
		clipped = trace_ent;
	}
	spot = trace_endpos;
	org = self.origin;
	if (spot_x >= org_x + self.maxs_x)
	{
		return;
	}
	if (spot_x <= org_x + self.mins_x)
	{
		return;
	}
	if (spot_y >= org_y + self.maxs_y)
	{
		return;
	}
	if (spot_y <= org_y + self.mins_y)
	{
		return;
	}
	if (spot_z >= org_z + self.maxs_z)
	{
		return;
	}
	if (spot_z <= org_z + self.mins_z)
	{
		return;
	}
	PM_FindBestPath(dist, clipped);
};

float(float offset) PM_AllClear = 
{
	local vector p1;
	local vector p2;
	p1 = p2 = self.origin;
	p2_z = p2_z + offset;
	traceline(p1, p2, 0, self);
	if (trace_fraction < SPAWNFLAG_SUPERSPIKE)
	{
		return 0;
	}
	if (trace_inwater)
	{
		if (pointcontents(self.origin) == CONTENT_EMPTY)
		{
			if (pointcontents(trace_endpos) == CONTENT_EMPTY || pointcontents(trace_endpos) == CONTENT_SKY)
			{
				return 0;
			}
			if (PM_Hydrophobic())
			{
				if (pointcontents(trace_endpos) == CONTENT_WATER || pointcontents(trace_endpos) == CONTENT_SLIME || pointcontents(trace_endpos) == CONTENT_LAVA)
				{
					return 0;
				}
			}
		}
	}
	p1_x = p1_x + self.maxs_x;
	p1_y = p1_y + self.maxs_y;
	p2_x = p2_x + self.mins_x;
	p2_y = p2_y + self.mins_y;
	traceline(p1, p2, 0, self);
	if (trace_fraction < SPAWNFLAG_SUPERSPIKE)
	{
		return 0;
	}
	p1_x = self.origin_x + self.mins_x;
	p2_x = self.origin_x + self.maxs_x;
	traceline(p1, p2, 0, self);
	if (trace_fraction < SPAWNFLAG_SUPERSPIKE)
	{
		return 0;
	}
	p1_y = self.origin_y + self.mins_y;
	p2_y = self.origin_y + self.maxs_y;
	traceline(p1, p2, 0, self);
	if (trace_fraction < SPAWNFLAG_SUPERSPIKE)
	{
		return 0;
	}
	p1_x = self.origin_x + self.maxs_x;
	p2_x = self.origin_x + self.mins_x;
	traceline(p1, p2, 0, self);
	if (trace_fraction < SPAWNFLAG_SUPERSPIKE)
	{
		return 0;
	}
	return 1;
};

float(float dist) go_down = 
{
	local vector dir;
	local float offset;
	dir = self.origin;
	dir_z = dir_z - dist;
	offset = self.mins_z - dist - 40;
	if (PM_AllClear(offset))
	{
		setorigin(self, dir);
		return 1;
	}
	return 0;
};

float(float dist) go_up = 
{
	local vector dir;
	local float offset;
	dir = self.origin;
	dir_z = dir_z + dist;
	offset = self.maxs_z + dist + 40;
	if (PM_AllClear(offset))
	{
		setorigin(self, dir);
		return 1;
	}
	return 0;
};

void(float newyaw, float dist) PM_Dodge = 
{
	if (!walkmove(newyaw, dist))
	{
		if (self.lefty > time)
		{
			self.lefty = time;
		}
		else
		{
			self.lefty = time + 0.5 + random();
		}
	}
	PM_AntiClip();
	ai_face();
	if (PM_Hydrophobic())
	{
		if (PM_InLiquid(self))
		{
			if (PM_LeaveWater(dist))
			{
				return;
			}
		}
	}
	if (self.enemy.classname == "watergoal")
	{
		if (random() < 0.5)
		{
			go_down(dist);
		}
		else
		{
			go_up(dist);
		}
		return;
	}
	if (self.enemy.origin_z > self.origin_z)
	{
		go_down(dist);
	}
	else
	{
		go_up(dist);
	}
};

float(float theta) PM_ChangeCourse = 
{
	if (theta < 60)
	{
		return -90;
	}
	if (theta < TOOCLOSE_CHARMER_DISTANCE)
	{
		return MSG_BROADCAST;
	}
	if (theta < 180)
	{
		return -90;
	}
	if (theta < 240)
	{
		return 90;
	}
	if (theta < 300)
	{
		return MSG_BROADCAST;
	}
	return 90;
};

void(float dist, entity head) PM_FindBestPath = 
{
	local vector dir;
	local float misyaw;
	local float newyaw;
	local float oldyaw;
	dir = normalize(head.origin - self.origin);
	misyaw = vectoyaw(dir);
	misyaw = anglemod(misyaw);
	oldyaw = anglemod(self.angles_y);
	newyaw = misyaw - oldyaw;
	newyaw = anglemod(newyaw);
	newyaw = PM_ChangeCourse(newyaw);
	if (self.lefty > time)
	{
		newyaw = MSG_BROADCAST - newyaw;
	}
	oldyaw = oldyaw + newyaw;
	anglemod(oldyaw);
	PM_Dodge(oldyaw, dist);
};

float(entity head) PM_KeepAway = 
{
	if (head.burnend > time)
	{
		return 1;
	}
	if (self.state < IQ_GENIUS)
	{
		return 0;
	}
	if (!(self.th_missile))
	{
		return 0;
	}
	if (head.items & IT_INVULNERABILITY)
	{
		if (head.classname != "item_artifact_invulnerability")
		{
			return 1;
		}
	}
	if (head.items & IT_QUAD)
	{
		if (head.classname != "item_artifact_super_damage")
		{
			return 1;
		}
	}
	if (head.classname == "player")
	{
		if (vlen(head.origin - self.origin) > TOOCLOSE_CHARMER_DISTANCE)
		{
			if (head.weapon == IT_ROCKET_LAUNCHER)
			{
				return 1;
			}
			else
			{
				if (head.weapon == IT_GRENADE_LAUNCHER)
				{
					return 1;
				}
			}
		}
	}
	if (head.classname == "monster_demon1")
	{
		return 1;
	}
	if (head.classname == "monster_tarbaby")
	{
		return 1;
	}
	if (head.classname == "monster_nightshade")
	{
		if (head.health <= MSG_BROADCAST)
		{
			return 1;
		}
	}
	if (head.classname == "monster_cyberdemon")
	{
		return 1;
	}
	if (self.enemy == head)
	{
		if (head.classname == "monster_shambler")
		{
			if (skill < SVC_UPDATESTAT)
			{
				return 1;
			}
		}
		if (head.classname == "monster_snakeman")
		{
			return 1;
		}
	}
	return 0;
};

float(entity head) PM_IsHostile = 
{
	if (head.owner == self)
	{
		return 0;
	}
	if (head.fireowner == self)
	{
		return 0;
	}
	if (head.solid == SOLID_BBOX)
	{
		if (head.movetype == MOVETYPE_FLY)
		{
			return head.enemy != self;
		}
		if (head.movetype == MOVETYPE_FLYMISSILE)
		{
			return head.enemy != self;
		}
		if (head.movetype == MOVETYPE_BOUNCE)
		{
			return 1;
		}
		if (head.movetype == MOVETYPE_BOUNCEMISSILE)
		{
			return 1;
		}
		if (head.movetype == MOVETYPE_TOSS)
		{
			return 1;
		}
	}
	return PM_KeepAway(head);
};

entity() PM_FindThreat = 
{
	local entity head;
	head = findradius(self.origin, 300);
	while (head)
	{
		if (head != self)
		{
			traceline(self.origin, head.origin, 1, self);
			if (trace_fraction == SPAWNFLAG_SUPERSPIKE)
			{
				if (PM_IsHostile(head))
				{
					return head;
				}
			}
		}
		head = head.chain;
	}
	return head;
};

float(float dist) PM_DetectDanger = 
{
	local entity head;
	if (self.state < IQ_HIGH)
	{
		return 0;
	}
	head = PM_FindThreat();
	if (head)
	{
		PM_FindBestPath(dist, head);
		return 1;
	}
	return 0;
};

