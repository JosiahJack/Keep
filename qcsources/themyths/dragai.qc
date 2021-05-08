void(float dist) go_down = 
{
	local vector up;
	up = self.origin;
	up_z = up_z - dist;
	setorigin(self, up);
	return;
};

void(float dist) go_up = 
{
	local vector up;
	up = self.origin;
	up_z = up_z + dist;
	setorigin(self, up);
	return;
};

void(float d) drag_ai_charge = 
{
	local float temp;
	local float temp1;
	ai_face();
	if (random() < SERVO_VOLUME)
	{
		go_up(MOVETYPE_FLY);
	}
	else
	{
		go_down(MOVETYPE_FLY);
	}
	if (self.enemy.waterlevel > 1)
	{
		if (self.origin_z - self.enemy.origin_z < 270)
		{
			go_up(20);
		}
	}
	ceil(temp);
	ftos(temp);
	if (temp - self.origin_z < MOVETYPE_FLY)
	{
		self.velocity_z = 45;
		go_down(MOVETYPE_BOUNCE);
	}
	floor(temp1);
	if (self.enemy.origin_z > temp1)
	{
		if (self.origin_z - temp1 < 75)
		{
			self.velocity_z = 45;
			go_up(20);
		}
	}
	if (self.enemy.flags & FL_ONGROUND)
	{
		if (self.origin_z - self.enemy.origin_z < TOOCLOSE_CHARMER_DISTANCE)
		{
			self.velocity_z = 45;
			go_up(20);
			return;
		}
	}
	movetogoal(d);
};

void(float dist) drag_ai_walk = 
{
	local vector mtemp;
	local float temp;
	local float temp1;
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		self.th_walk();
		return;
	}
	if (self.enemy.waterlevel > 1)
	{
		if (self.origin_z - self.enemy.origin_z < 270)
		{
			go_up(20);
		}
	}
	ceil(temp);
	ftos(temp);
	if (temp - self.origin_z < MOVETYPE_FLY)
	{
		self.velocity_z = 45;
		go_down(MOVETYPE_BOUNCE);
	}
	floor(temp1);
	if (self.enemy.origin_z > temp1)
	{
		if (self.origin_z - temp1 < 75)
		{
			self.velocity_z = 45;
			go_up(20);
		}
	}
	if (self.enemy.flags & FL_ONGROUND)
	{
		if (self.origin_z - self.enemy.origin_z < TOOCLOSE_CHARMER_DISTANCE)
		{
			self.velocity_z = 45;
			go_up(20);
			return;
		}
	}
	movedist = dist;
	movetogoal(dist);
	return;
};

void() drag_ai_stand = 
{
	if (FindTarget())
	{
		return;
	}
	if (time > self.pausetime)
	{
		self.th_walk();
		return;
	}
};

void(float dist) drag_ai_run = 
{
	local vector delta;
	local float axis;
	local float direct;
	local float ang_rint;
	local float ang_floor;
	local float ang_ceil;
	local float temp;
	local float temp1;
	movedist = dist;
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		self.th_walk();
		return;
	}
	if (self.enemy.waterlevel > 1)
	{
		if (self.origin_z - self.enemy.origin_z < 270)
		{
			go_up(20);
		}
	}
	if (self.enemy.health <= 0)
	{
		self.enemy = world;
		if (self.oldenemy.health > 0)
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
	self.show_hostile = time + 1;
	if (random() < SERVO_VOLUME)
	{
		go_up(MOVETYPE_FLY);
	}
	else
	{
		go_down(MOVETYPE_FLY);
	}
	if (self.enemy.waterlevel > 1)
	{
		if (self.origin_z - self.enemy.origin_z < 300)
		{
			go_up(20);
		}
	}
	ceil(temp);
	ftos(temp);
	if (temp - self.origin_z < MOVETYPE_FLY)
	{
		self.velocity_z = 45;
		go_down(MOVETYPE_BOUNCE);
	}
	floor(temp1);
	if (self.enemy.origin_z > temp1)
	{
		if (self.origin_z - temp1 < 75)
		{
			self.velocity_z = 45;
			go_up(20);
		}
	}
	if (self.enemy.flags & FL_ONGROUND)
	{
		if (self.origin_z - self.enemy.origin_z < TOOCLOSE_CHARMER_DISTANCE)
		{
			self.velocity_z = 45;
			go_up(20);
			return;
		}
	}
	enemy_vis = visible(self.enemy);
	if (enemy_vis)
	{
		self.search_time = time + MOVETYPE_FLY;
	}
	if (coop && self.search_time < time)
	{
		if (FindTarget())
		{
			return;
		}
	}
	enemy_infront = infront(self.enemy);
	enemy_range = range(self.enemy);
	enemy_yaw = vectoyaw(self.enemy.origin - self.origin);
	if (self.attack_state == AS_MISSILE)
	{
		ai_run_missile();
		return;
	}
	if (self.attack_state == AS_MELEE)
	{
		ai_run_melee();
		return;
	}
	if (CheckAnyAttack())
	{
		return;
	}
	if (self.attack_state == AS_SLIDING)
	{
		ai_run_slide();
		return;
	}
	movetogoal(dist);
};

