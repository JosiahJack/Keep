entity(entity bot) FindGoalMarker = 
{
	local entity goal;
	local float marker_no;
	if (bot.goalentity.ammo_shells == num_markers)
	{
		marker_no = 1;
	}
	else
	{
		marker_no = bot.goalentity.ammo_shells + 1;
	}
	goal = find(world, classname, "rally_bot_marker");
	while (goal != world)
	{
		if (goal.ammo_shells == marker_no)
		{
			return goal;
		}
		goal = find(goal, classname, "rally_bot_marker");
	}
	dprint("BOT_ERROR: Unable to find next bot marker\n");
	return bot.goalentity;
};

void(entity mt) checkforjump = 
{
	local float origheight;
	return 0;
};

float(vector offset, float frac) BotCheckMove = 
{
	local entity targ;
	local vector trans;
	trans = v_right * offset_x;
	trans_z = offset_z;
	targ = self.movetarget;
	traceline(self.origin + trans, targ.origin + trans, 0, targ);
	if (trace_fraction < 1 && trace_fraction < frac)
	{
		return trace_fraction;
	}
	else
	{
		return frac;
	}
};

float() movetotarget = 
{
	local vector trans;
	local vector vect;
	local vector org;
	local entity targ;
	local float frac;
	local float done;
	local float dist;
	local float i;
	i = 0;
	vect = normalize(self.movetarget.origin - self.origin);
	org = self.origin;
	dist = vlen(self.velocity) * (time - self.last_think_time);
	while (dist > 0)
	{
		if (walkmove(self.angles_y, dist))
		{
			return 1;
		}
		dist = dist - 4;
	}
	return 0;
	targ = self.movetarget;
	if (self.flags & FL_ONGROUND)
	{
		vect = self.origin;
		dist = vlen(self.velocity) * (time - self.last_think_time);
		if (walkmove(self.angles_y, dist))
		{
			if (vect_z - self.origin_z < 32)
			{
				return 1;
			}
		}
	}
	bprint("using custom movement\n");
	frac = 1;
	makevectors(self.angles);
	frac = BotCheckMove('0 0 0', frac);
	frac = BotCheckMove('0 0 30', frac);
	frac = BotCheckMove('0 0 -14', frac);
	frac = BotCheckMove('15 0 0', frac);
	frac = BotCheckMove('-15 0 0', frac);
	frac = BotCheckMove('15 0 30', frac);
	frac = BotCheckMove('-15 0 30', frac);
	frac = BotCheckMove('15 0 -14', frac);
	frac = BotCheckMove('-15 0 -14', frac);
	if (frac < 1 && vlen(frac * (targ.origin - self.origin)) <= 1)
	{
		if (!(self.flags & FL_ONGROUND))
		{
			if (trace_ent == world)
			{
				self.velocity = vlen(self.velocity) * trace_plane_normal * 0.5 - '0 0 50';
			}
		}
		return 0;
	}
	else
	{
		setorigin(self, self.origin + (targ.origin - self.origin) * frac);
		if (frac < 1)
		{
			vect = normalize(targ.origin - self.origin);
			setorigin(self, self.origin - vect);
		}
		if (self.flags & FL_ONGROUND && !checkbottom(self))
		{
			BotInAir();
			trans = self.angles;
			trans_x = self.veh_body.angles_x;
			makevectors(trans);
			self.velocity = v_forward * vlen(self.velocity);
			if (self.velocity_z < 0)
			{
				self.velocity_z = 0;
			}
			bprint("bot now in air: MOVETOTARGET\n");
		}
		return 1;
	}
};

float() CheckInAir = 
{
	local vector org;
	org = self.origin;
	traceline(org, org - '0 0 32', 0, self);
	if (trace_fraction < 1)
	{
		return 0;
	}
	traceline(org + '14 14 0', org + '14 14 -32', 0, self);
	if (trace_fraction < 1)
	{
		return 0;
	}
	traceline(org + '-14 14 0', org + '-14 14 -32', 0, self);
	if (trace_fraction < 1)
	{
		return 0;
	}
	traceline(org + '14 -14 0', org + '14 -14 -32', 0, self);
	if (trace_fraction < 1)
	{
		return 0;
	}
	traceline(org + '-14 -14 0', org + '-14 -14 -32', 0, self);
	if (trace_fraction < 1)
	{
		return 0;
	}
	return 1;
};

void() BotInAir = 
{
	bprint("bot is in air\n");
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	self.bot_flags = self.bot_flags | BF_STARTJUMP;
	self.last_jump_z = 0;
	setorigin(self, self.origin + '0 0 1');
};

void() bot_think = 
{
	local vector heading;
	local vector old_vel;
	local vector org;
	local float vel_speed;
	local float ftemp;
	local float vel_z;
	local vector left;
	local vector right;
	local vector vtemp;
	local vector leftend;
	local vector rightend;
	local float leftlen;
	local float rightlen;
	local float newheading;
	local float can_move;
	local vector tail_angle;
	local vector slide_angle;
	local vector right_end;
	local vector left_end;
	local float accel;
	local float max_speed;
	local float winning_slowdown;
	local float olddist;
	local float newdist;
	local string str;
	self.lastpostorg = self.oldorigin;
	self.oldorigin = self.origin;
	if (!(self.flags & FL_ONGROUND) && checkbottom(self))
	{
		self.flags = self.flags | FL_ONGROUND;
	}
	else
	{
		if (self.flags & FL_ONGROUND && CheckInAir())
		{
			BotInAir();
		}
	}
	if (self.last_changemaxspeed_time < time - 2)
	{
		ftemp = 10;
		if (self.maxspeed < BOT_MAXSPEED)
		{
			if (self.maxspeed > BOT_MAXSPEED - 50)
			{
				if (self.speeding_up)
				{
					ftemp = 7;
				}
				else
				{
					ftemp = 13;
				}
			}
			else
			{
				self.speeding_up = 1;
			}
		}
		else
		{
			if (self.maxspeed < BOT_MAXSPEED + 50)
			{
				if (self.speeding_up)
				{
					ftemp = 7;
				}
				else
				{
					ftemp = 13;
				}
			}
			else
			{
				self.speeding_up = 0;
			}
		}
		self.maxspeed = self.maxspeed + random() * 20 - ftemp;
		if (self.maxspeed < BOT_MAXSPEED - 100)
		{
			self.maxspeed = BOT_MAXSPEED - 100;
		}
		else
		{
			if (self.maxspeed > BOT_MAXSPEED + 100)
			{
				self.maxspeed = BOT_MAXSPEED + 100;
			}
		}
	}
	if (!(self.flags & FL_ONGROUND))
	{
		self.roll_velocity = '0 0 0';
		self.velocity_z = self.velocity_z - cvar("sv_gravity") * (time - self.last_think_time);
		if (self.velocity_z < -250)
		{
			self.velocity_z = -250;
		}
	}
	else
	{
		self.velocity_z = 0;
	}
	vel_z = self.velocity_z;
	if (self.flags & FL_ONGROUND)
	{
		tail_angle = vectoangles(self.veh_tail.veh_dir);
		if (fabs(angle_diff(tail_angle_y, self.veh_body.angles_y)) > 15)
		{
			self.velocity = self.velocity * (0.9 - random() * 0.05);
		}
		heading = self.goalentity.origin - self.origin;
		heading = vectoangles(heading);
		accel = BOT_ACCEL * (time - self.last_think_time) * (1 + (random() - 0.5) * 0.2);
		if (vlen(self.velocity) == 0)
		{
			self.velocity = normalize(self.goalentity.origin - self.origin) * 10;
		}
		else
		{
			if (teamplay < 3 && self.position == 1)
			{
				accel = BOT_ACCEL * (time - self.last_think_time) * 0.8;
			}
			self.velocity = self.velocity + normalize(self.velocity) * accel;
		}
		winning_slowdown = 1;
		if (teamplay < 3 && self.position == 1)
		{
			winning_slowdown = 0.8;
		}
		if (vlen(self.velocity) > self.maxspeed * winning_slowdown)
		{
			self.velocity = normalize(self.velocity) * (self.maxspeed * winning_slowdown);
		}
	}
	vel_speed = vlen(self.velocity);
	if (self.flags & FL_ONGROUND)
	{
		if (!(self.bot_flags & BF_STUCK) && !(self.flags & BF_AVOID))
		{
			traceline(self.origin, self.goalentity.origin, 1, self);
			if (trace_fraction == 1)
			{
				ftemp = heading_y;
			}
			else
			{
				ftemp = self.ideal_yaw;
			}
			self.angles_y = MoveToAngle(self.angles_y, ftemp, BOT_TURNSPEED);
			if (fabs(angle_diff(self.angles_y, ftemp)) > 35)
			{
				self.velocity = self.velocity - normalize(self.velocity) * accel * 2;
			}
		}
		if (self.angles_y == heading_y && !(self.bot_flags & BF_STUCK))
		{
			makevectors(self.angles);
			org = self.origin;
			traceline(org, org + v_forward * 512, 0, self);
			if (trace_ent == world)
			{
				org = self.origin - v_right * 16;
				traceline(org, org + v_forward * 512, 0, self);
			}
			if (trace_ent == world)
			{
				org = self.origin + v_right * 16;
				traceline(org, org + v_forward * 512, 0, self);
			}
			if (trace_ent == world)
			{
				org = self.origin - v_right * 32;
				traceline(org, org + v_forward * 512, 0, self);
			}
			if (trace_ent == world)
			{
				org = self.origin + v_right * 32;
				traceline(org, org + v_forward * 512, 0, self);
			}
			if (trace_ent == world)
			{
				org = self.origin - v_right * 48;
				traceline(org, org + v_forward * 512, 0, self);
			}
			if (trace_ent == world)
			{
				org = self.origin + v_right * 48;
				traceline(org, org + v_forward * 512, 0, self);
			}
			if (trace_ent != world && trace_ent.solid == SOLID_BBOX && vlen(trace_ent.velocity) < vel_speed)
			{
				self.e_avoid = trace_ent;
				self.bot_flags = self.bot_flags | BF_AVOID;
			}
			else
			{
				self.bot_flags = self.bot_flags - (self.bot_flags & BF_AVOID);
			}
		}
	}
	setorigin(self.movetarget, self.origin + self.velocity * (time - self.last_think_time));
	olddist = vlen(self.origin - self.goalentity.origin);
	PlayerPreThink();
	can_move = 1;
	if (self.flags & FL_ONGROUND)
	{
		org = self.movetarget.origin;
		self = self.movetarget;
		makevectors(self.veh_body.angles);
		self.origin = self.origin + '0 0 8' + '0 0 1' * (v_forward_z + 0.5) * vlen(self.origin - self.owner.origin);
		if (droptofloor())
		{
			if (org_z - self.origin_z > 24)
			{
				self.origin = org;
			}
		}
		else
		{
			self.origin = org;
		}
		self = self.owner;
	}
	if (self.flags & FL_ONGROUND)
	{
		if (can_move)
		{
			if (!movetotarget() || (self.bot_flags & BF_AVOID))
			{
				if (self.origin == self.oldorigin)
				{
					self.bot_flags = self.bot_flags | BF_STUCK;
				}
				vel_speed = vlen(self.origin - self.oldorigin) / (time - self.last_think_time);
				vtemp = normalize(self.velocity) * vel_speed;
				if (vel_speed - vlen(vtemp) > BOT_MAX_SLOWDOWN)
				{
					self.velocity = self.velocity - normalize(vtemp) * BOT_MAX_SLOWDOWN;
				}
				else
				{
					self.velocity = vtemp;
				}
				if (!(self.bot_flags & BF_STUCK))
				{
					if (self.bot_flags & BF_AVOID)
					{
						vtemp = normalize(self.goalentity.origin - self.e_avoid.origin);
						makevectors(vtemp);
						org = self.e_avoid.origin;
						traceline(org, org + v_right * 512, 0, self.e_avoid);
						right = trace_endpos - org;
						rightend = trace_endpos;
						traceline(org, org - v_right * 512, 0, self.e_avoid);
						left = trace_endpos - org;
						leftend = trace_endpos;
						leftlen = vlen(left);
						rightlen = vlen(right);
						if (leftlen > rightlen)
						{
							vtemp = normalize(leftend - self.origin);
							vtemp = vectoangles(vtemp);
							self.angles_y = MoveToAngle(anglemod(self.angles_y), vtemp_y, BOT_TURNSPEED);
						}
						else
						{
							vtemp = normalize(rightend - self.origin);
							vtemp = vectoangles(vtemp);
							self.angles_y = MoveToAngle(anglemod(self.angles_y), vtemp_y, BOT_TURNSPEED * 2);
						}
					}
				}
				else
				{
					vtemp = normalize(self.goalentity.origin - self.origin);
					vtemp = vectoangles(vtemp);
					makevectors(vtemp);
					org = self.origin;
					traceline(org, org + v_forward * 64, 0, self);
					if (trace_fraction < 1 && trace_ent == world)
					{
						vtemp = vectoangles(trace_plane_normal);
						self.angles_y = MoveToAngle(anglemod(self.angles_y), vtemp_y, BOT_TURNSPEED * 2);
					}
					traceline(org, org + v_right * 512, 0, self);
					right = trace_endpos - org;
					traceline(org, org - v_right * 512, 0, self);
					left = trace_endpos - org;
					leftlen = vlen(left);
					rightlen = vlen(right);
					if (leftlen > rightlen)
					{
						self.angles_y = MoveToAngle(anglemod(self.angles_y), self.angles_y + BOT_TURNSPEED, BOT_TURNSPEED / 1);
					}
					else
					{
						if (rightlen > leftlen)
						{
							self.angles_y = MoveToAngle(anglemod(self.angles_y), self.angles_y - BOT_TURNSPEED, BOT_TURNSPEED / 1);
						}
					}
				}
			}
			else
			{
				self.bot_flags = self.bot_flags - (self.bot_flags & BF_STUCK);
			}
		}
	}
	else
	{
		movetotarget();
	}
	newdist = vlen(self.origin - self.goalentity.origin);
	if (newdist < 160 && newdist < olddist)
	{
		self.ideal_yaw = self.goalentity.angles_y;
		self.goalentity = FindGoalMarker(self);
	}
	traceline(self.origin, self.goalentity.origin, 0, self);
	if (trace_ent == world)
	{
		self.bot_flags = self.bot_flags - (self.bot_flags & BF_AVOID);
	}
	PlayerPostThink();
	if (hold_flag)
	{
		self.velocity = normalize(self.velocity);
		vtemp = normalize(self.goalentity.origin - self.origin);
		self.angles = vectoangles(vtemp);
	}
	self.last_think_time = time;
	self.nextthink = time + 0.05;
};

void() SetBotNetName = 
{
	if (num_bots == 1)
	{
		self.netname = "RidahBot";
	}
	else
	{
		if (num_bots == 2)
		{
			self.netname = "DaKillerBot";
		}
		else
		{
			if (num_bots == 3)
			{
				self.netname = "B-MonEy Bot";
			}
			else
			{
				if (num_bots == 4)
				{
					self.netname = "SumalethBot";
				}
				else
				{
					if (num_bots == 5)
					{
						self.netname = "[jD] Bot";
					}
					else
					{
						self.netname = "DruBot";
					}
				}
			}
		}
	}
};

void() SpawnBot = 
{
	local entity bot;
	local entity temp;
	local entity espawn;
	bot = spawn();
	bot.movetarget = spawn();
	temp = bot.movetarget;
	temp.view_ofs = '0 0 7';
	bot.movetarget.owner = bot;
	bot.movetarget.solid = SOLID_NOT;
	setsize(temp, VEH_MIN, VEH_MAX);
	bot.movetarget.owner = bot;
	temp = self;
	self = bot;
	num_bots = num_bots + 1;
	bot.classname = "rally_bot";
	bot.is_racer = "yes";
	SetBotNetName();
	bot.solid = SOLID_SLIDEBOX;
	bot.movetype = MOVETYPE_STEP;
	bot.view_ofs = '0 0 7';
	bot.takedamage = DAMAGE_NO;
	bot.ideal_yaw = bot.angles * '0 1 0';
	setsize(bot, VEH_MIN, VEH_MAX);
	bot.health = 100;
	espawn = SelectSpawnPoint();
	setorigin(bot, espawn.origin + '0 0 1');
	droptofloor();
	self.flags = self.flags | FL_ONGROUND | FL_MONSTER | FL_FLY;
	bot.angles = espawn.angles;
	bot.use_surface_angle = 1;
	bot.last_engine_ratio = -1;
	ClientConnect();
	CreateVehicleEntities();
	self.last_marker_num = 0;
	self.last_marker = world;
	self.maxspeed = BOT_MAXSPEED;
	self.goalentity = FindGoalMarker(self);
	self.angles = vectoangles(self.goalentity.origin - self.origin);
	if (!(self.racing_flags & QR_RACING))
	{
		self.last_lap = 0;
		self.fastest_lap = 999999;
		self.last_lap_time = 0;
		self.last_marker_num = 0;
		self.racing_flags = self.racing_flags | QR_RACING;
		self.racing_flags = self.racing_flags | QR_START_READY;
	}
	if (deathmatch || coop)
	{
		makevectors(self.angles);
		spawn_tfog(self.origin + v_forward * 20);
	}
	spawn_tdeath(self.origin, self);
	self.last_think_time = time;
	bot.think = bot_think;
	bot.nextthink = time + 0.1;
	bot.bot_flags = 0;
	self = temp;
};

