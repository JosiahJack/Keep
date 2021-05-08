void(float ofs, float turn) armagon_launch_missile = 
{
	local vector src;
	local vector vec;
	local vector targ;
	local vector ang;
	local entity missile;
	local float dist;
	ang = self.angles;
	ang_y = ang_y + self.fixangle;
	if (turn == USE_COUNT)
	{
		ang_y = ang_y + 165;
	}
	else
	{
		if (turn == LIGHTNING_BOOM)
		{
			ang_y = ang_y - 165;
		}
	}
	makevectors(ang);
	src = self.origin + '0 0 66' + v_right * ofs + v_forward * 84;
	targ = self.enemy.origin + self.enemy.view_ofs;
	if (skill != MSG_BROADCAST)
	{
		dist = vlen(targ - src);
		targ = targ + self.enemy.velocity * (dist / 1000);
	}
	vec = targ - src;
	vec = normalize(vec);
	dist = vec * v_forward;
	if (dist < self.worldtype)
	{
		vec = v_forward;
	}
	self.effects = self.effects | EF_MUZZLEFLASH;
	sound(self, CHAN_WEAPON, "weapons/sgun1.wav", USE_COUNT, ATTN_NORM);
	self.punchangle_x = CONTENT_SOLID;
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "missile";
	missile.velocity = vec * 1000;
	missile.angles = vectoangles(vec);
	missile.touch = T_MissileTouch;
	missile.nextthink = time + AS_DODGING;
	missile.think = SUB_Remove;
	setmodel(missile, "progs/missile.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, src);
};

void(float ofs) armagon_launch_laser = 
{
	local vector src;
	local vector vec;
	local vector targ;
	local float dist;
	local vector ang;
	ang = self.angles;
	ang_y = ang_y + self.fixangle;
	makevectors(ang);
	src = self.origin + '0 0 66' + v_right * ofs + v_forward * 84;
	targ = self.enemy.origin + self.enemy.view_ofs;
	if (skill != MSG_BROADCAST)
	{
		dist = vlen(targ - src);
		targ = targ + self.enemy.velocity * (dist / 1000);
	}
	vec = targ - src;
	vec = normalize(vec);
	dist = vec * v_forward;
	if (dist < self.worldtype)
	{
		vec = v_forward;
	}
	self.effects = self.effects | EF_MUZZLEFLASH;
	HIP_LaunchLaser(src, vec, MSG_BROADCAST);
};

void(float angdelta, float delta) armagon_turn = 
{
	if (fabs(angdelta) < MIN_ANGLE_DELTA)
	{
		self.fixangle = delta;
	}
	else
	{
		if (angdelta > AS_DODGING)
		{
			self.fixangle = self.fixangle + TE_LIGHTNING3;
		}
		else
		{
			if (angdelta < CONTENT_LAVA)
			{
				self.fixangle = self.fixangle - TE_LIGHTNING3;
			}
			else
			{
				self.fixangle = delta;
			}
		}
	}
};

void() armagon_think = 
{
	local float delta;
	local float angdelta;
	local float r;
	setorigin(self.trigger_field, self.origin);
	self.trigger_field.angles = self.angles;
	self.trigger_field.frame = self.frame;
	self.trigger_field.angles_y = self.trigger_field.angles_y + self.fixangle;
	enemy_yaw = vectoyaw(self.enemy.origin - self.origin);
	self.ideal_yaw = enemy_yaw;
	delta = self.ideal_yaw - self.angles_y;
	self.cnt = MSG_BROADCAST;
	if (delta > 180)
	{
		delta = delta - 360;
	}
	if (delta < -180)
	{
		delta = delta + 360;
	}
	if (fabs(delta) > 90)
	{
		delta = MSG_BROADCAST;
		self.cnt = USE_COUNT;
	}
	angdelta = delta - self.fixangle;
	armagon_turn(angdelta, delta);
	if (self.health < MSG_BROADCAST)
	{
		return;
	}
	if (time > self.super_time)
	{
		self.super_time = time + SVC_UPDATESTAT;
		if (random() < SERVO_VOLUME)
		{
			r = random();
			if (r < 0.25)
			{
				sound(self, CHAN_VOICE, "armagon/idle1.wav", USE_COUNT, ATTN_ARMAGON);
			}
			else
			{
				if (r < SERVO_VOLUME)
				{
					sound(self, CHAN_VOICE, "armagon/idle2.wav", USE_COUNT, ATTN_ARMAGON);
				}
				else
				{
					if (r < 0.75)
					{
						sound(self, CHAN_VOICE, "armagon/idle3.wav", USE_COUNT, ATTN_ARMAGON);
					}
					else
					{
						sound(self, CHAN_VOICE, "armagon/idle4.wav", USE_COUNT, ATTN_ARMAGON);
					}
				}
			}
		}
	}
};

void() armagon_walkthink = 
{
	local float delta;
	local float angdelta;
	local entity client;
	local float r;
	setorigin(self.trigger_field, self.origin);
	self.trigger_field.angles = self.angles;
	self.trigger_field.frame = self.frame;
	self.trigger_field.angles_y = self.trigger_field.angles_y + self.fixangle;
	ChangeYaw();
	delta = MSG_BROADCAST;
	self.cnt = MSG_BROADCAST;
	if (delta > 180)
	{
		delta = delta - 360;
	}
	if (delta < -180)
	{
		delta = delta + 360;
	}
	if (fabs(delta) > 90)
	{
		delta = MSG_BROADCAST;
		self.cnt = USE_COUNT;
	}
	angdelta = delta - self.fixangle;
	armagon_turn(angdelta, delta);
	if (self.health < MSG_BROADCAST)
	{
		return;
	}
	if (time > self.super_time)
	{
		self.super_time = time + SVC_UPDATESTAT;
		if (random() < SERVO_VOLUME)
		{
			r = random();
			if (r < 0.25)
			{
				sound(self, CHAN_VOICE, "armagon/idle1.wav", USE_COUNT, ATTN_ARMAGON);
			}
			else
			{
				if (r < SERVO_VOLUME)
				{
					sound(self, CHAN_VOICE, "armagon/idle2.wav", USE_COUNT, ATTN_ARMAGON);
				}
				else
				{
					if (r < 0.75)
					{
						sound(self, CHAN_VOICE, "armagon/idle3.wav", USE_COUNT, ATTN_ARMAGON);
					}
					else
					{
						sound(self, CHAN_VOICE, "armagon/idle4.wav", USE_COUNT, ATTN_ARMAGON);
					}
				}
			}
		}
	}
	client = checkclient();
	if (!client)
	{
		return;
	}
	if (visible(client))
	{
		self.enemy = client;
		FoundTarget();
	}
};

void() armagon_overleft_think = 
{
	local float delta;
	local float angdelta;
	ChangeYaw();
	walkmove(self.angles_y, TEAM2);
	setorigin(self.trigger_field, self.origin);
	self.trigger_field.angles = self.angles;
	self.trigger_field.frame = self.frame;
	self.trigger_field.angles_y = self.trigger_field.angles_y + self.fixangle;
	if (self.count == MSG_BROADCAST)
	{
		enemy_yaw = vectoyaw(self.enemy.origin - self.origin);
		self.ideal_yaw = enemy_yaw;
		delta = self.ideal_yaw - self.angles_y - 165;
		if (delta > 180)
		{
			delta = delta - 360;
		}
		if (delta < -180)
		{
			delta = delta + 360;
		}
		angdelta = delta - self.fixangle;
	}
	else
	{
		if (self.count == USE_COUNT)
		{
			armagon_launch_missile(40, USE_COUNT);
			return;
		}
		else
		{
			delta = MSG_BROADCAST;
			angdelta = delta - self.fixangle;
		}
	}
	armagon_turn(angdelta, delta);
};

void() armagon_overright_think = 
{
	local float delta;
	local float angdelta;
	ChangeYaw();
	walkmove(self.angles_y, TEAM2);
	setorigin(self.trigger_field, self.origin);
	self.trigger_field.angles = self.angles;
	self.trigger_field.frame = self.frame;
	self.trigger_field.angles_y = self.trigger_field.angles_y + self.fixangle;
	if (self.count == MSG_BROADCAST)
	{
		enemy_yaw = vectoyaw(self.enemy.origin - self.origin);
		self.ideal_yaw = enemy_yaw;
		delta = self.ideal_yaw - self.angles_y + 165;
		if (delta > 180)
		{
			delta = delta - 360;
		}
		if (delta < -180)
		{
			delta = delta + 360;
		}
		angdelta = delta - self.fixangle;
	}
	else
	{
		if (self.count == USE_COUNT)
		{
			armagon_launch_missile(-40, LIGHTNING_BOOM);
			return;
		}
		else
		{
			delta = MSG_BROADCAST;
			angdelta = delta - self.fixangle;
		}
	}
	armagon_turn(angdelta, delta);
};

void() armagon_stand1 = [64, armagon_stand2]
{
	ai_stand();
	armagon_think();
	self.nextthink = time + 0.2;
};

void() armagon_stand2 = [65, armagon_stand3]
{
	armagon_think();
	self.nextthink = time + 0.2;
};

void() armagon_stand3 = [66, armagon_stand4]
{
	armagon_think();
	self.nextthink = time + 0.2;
};

void() armagon_stand4 = [67, armagon_stand5]
{
	armagon_think();
	self.nextthink = time + 0.2;
};

void() armagon_stand5 = [68, armagon_stand6]
{
	armagon_think();
	self.nextthink = time + 0.2;
};

void() armagon_stand6 = [69, armagon_stand7]
{
	armagon_think();
	self.nextthink = time + 0.2;
};

void() armagon_stand7 = [70, armagon_stand8]
{
	armagon_think();
	self.nextthink = time + 0.2;
};

void() armagon_stand8 = [71, armagon_stand9]
{
	armagon_think();
	self.nextthink = time + 0.2;
};

void() armagon_stand9 = [72, armagon_stand10]
{
	armagon_think();
	self.nextthink = time + 0.2;
};

void() armagon_stand10 = [73, armagon_stand11]
{
	ai_stand();
	armagon_think();
	self.nextthink = time + 0.2;
};

void() armagon_stand11 = [74, armagon_stand12]
{
	armagon_think();
	self.nextthink = time + 0.2;
};

void() armagon_stand12 = [75, armagon_stand13]
{
	armagon_think();
	self.nextthink = time + 0.2;
};

void() armagon_stand13 = [76, armagon_stand14]
{
	armagon_think();
	self.nextthink = time + 0.2;
};

void() armagon_stand14 = [77, armagon_stand15]
{
	armagon_think();
	self.nextthink = time + 0.2;
};

void() armagon_stand15 = [78, armagon_stand16]
{
	armagon_think();
	self.nextthink = time + 0.2;
};

void() armagon_stand16 = [79, armagon_stand17]
{
	armagon_think();
	self.nextthink = time + 0.2;
};

void() armagon_stand17 = [80, armagon_stand18]
{
	armagon_think();
	self.nextthink = time + 0.2;
};

void() armagon_stand18 = [81, armagon_stand19]
{
	armagon_think();
	self.nextthink = time + 0.2;
};

void() armagon_stand19 = [82, armagon_stand20]
{
	armagon_think();
	self.nextthink = time + 0.2;
};

void() armagon_stand20 = [83, armagon_stand1]
{
	ai_stand();
	armagon_think();
	self.nextthink = time + 0.2;
};

void() armagon_walk1 = [0, armagon_walk2]
{
	movetogoal(TEAM2);
	armagon_walkthink();
};

void() armagon_walk2 = [1, armagon_walk3]
{
	movetogoal(TEAM2);
	armagon_walkthink();
};

void() armagon_walk3 = [2, armagon_walk4]
{
	sound(self, TE_WIZSPIKE, "armagon/servo.wav", SERVO_VOLUME, ATTN_ARMAGON);
	movetogoal(TEAM2);
	armagon_walkthink();
};

void() armagon_walk4 = [3, armagon_walk5]
{
	movetogoal(TEAM2);
	armagon_walkthink();
};

void() armagon_walk5 = [4, armagon_walk6]
{
	sound(self, TE_LIGHTNING2, "armagon/footfall.wav", USE_COUNT, ATTN_ARMAGON);
	movetogoal(TEAM2);
	armagon_walkthink();
};

void() armagon_walk6 = [5, armagon_walk7]
{
	movetogoal(TEAM2);
	armagon_walkthink();
};

void() armagon_walk7 = [6, armagon_walk8]
{
	movetogoal(TEAM2);
	armagon_walkthink();
};

void() armagon_walk8 = [7, armagon_walk9]
{
	movetogoal(TEAM2);
	armagon_walkthink();
};

void() armagon_walk9 = [8, armagon_walk10]
{
	sound(self, TE_WIZSPIKE, "armagon/servo.wav", SERVO_VOLUME, ATTN_ARMAGON);
	movetogoal(TEAM2);
	armagon_walkthink();
};

void() armagon_walk10 = [9, armagon_walk11]
{
	movetogoal(TEAM2);
	armagon_walkthink();
};

void() armagon_walk11 = [10, armagon_walk12]
{
	sound(self, TE_LIGHTNING2, "armagon/footfall.wav", USE_COUNT, ATTN_ARMAGON);
	movetogoal(TEAM2);
	armagon_walkthink();
};

void() armagon_walk12 = [11, armagon_walk1]
{
	movetogoal(TEAM2);
	armagon_walkthink();
};

void() armagon_run1 = [0, armagon_run2]
{
	ChangeYaw();
	RUN_STRAIGHT = USE_COUNT;
	ai_run(TEAM2);
	armagon_think();
};

void() armagon_run2 = [1, armagon_run3]
{
	ChangeYaw();
	RUN_STRAIGHT = USE_COUNT;
	ai_run(TEAM2);
	armagon_think();
};

void() armagon_run3 = [2, armagon_run4]
{
	sound(self, TE_WIZSPIKE, "armagon/servo.wav", SERVO_VOLUME, ATTN_ARMAGON);
	ChangeYaw();
	RUN_STRAIGHT = USE_COUNT;
	ai_run(TEAM2);
	armagon_think();
};

void() armagon_run4 = [3, armagon_run5]
{
	ChangeYaw();
	RUN_STRAIGHT = USE_COUNT;
	ai_run(TEAM2);
	armagon_think();
};

void() armagon_run5 = [4, armagon_run6]
{
	sound(self, TE_LIGHTNING2, "armagon/footfall.wav", USE_COUNT, ATTN_ARMAGON);
	ChangeYaw();
	RUN_STRAIGHT = USE_COUNT;
	ai_run(TEAM2);
	armagon_think();
};

void() armagon_run6 = [5, armagon_run7]
{
	ChangeYaw();
	RUN_STRAIGHT = USE_COUNT;
	ai_run(TEAM2);
	armagon_think();
};

void() armagon_run7 = [6, armagon_run8]
{
	ChangeYaw();
	RUN_STRAIGHT = USE_COUNT;
	ai_run(TEAM2);
	armagon_think();
};

void() armagon_run8 = [7, armagon_run9]
{
	ChangeYaw();
	RUN_STRAIGHT = USE_COUNT;
	ai_run(TEAM2);
	armagon_think();
};

void() armagon_run9 = [8, armagon_run10]
{
	sound(self, TE_WIZSPIKE, "armagon/servo.wav", SERVO_VOLUME, ATTN_ARMAGON);
	ChangeYaw();
	RUN_STRAIGHT = USE_COUNT;
	ai_run(TEAM2);
	armagon_think();
};

void() armagon_run10 = [9, armagon_run11]
{
	ChangeYaw();
	RUN_STRAIGHT = USE_COUNT;
	ai_run(TEAM2);
	armagon_think();
};

void() armagon_run11 = [10, armagon_run12]
{
	sound(self, TE_LIGHTNING2, "armagon/footfall.wav", USE_COUNT, ATTN_ARMAGON);
	ChangeYaw();
	RUN_STRAIGHT = USE_COUNT;
	ai_run(TEAM2);
	armagon_think();
};

void() armagon_run12 = [11, armagon_run1]
{
	local float delta;
	ChangeYaw();
	RUN_STRAIGHT = USE_COUNT;
	ai_run(TEAM2);
	armagon_think();
	if (self.cnt == USE_COUNT && time > self.attack_finished)
	{
		delta = self.ideal_yaw - self.angles_y;
		if (delta > 180)
		{
			delta = delta - 360;
		}
		if (delta < -180)
		{
			delta = delta + 360;
		}
		if (delta > MSG_BROADCAST)
		{
			self.think = armagon_overleft1;
		}
		else
		{
			self.think = armagon_overright1;
		}
		return;
	}
	if (self.lefty == USE_COUNT)
	{
		self.lefty = MSG_BROADCAST;
		self.think = self.th_missile;
	}
};

void() armagon_watk1 = [12, armagon_watk2]
{
	ChangeYaw();
	walkmove(self.angles_y, TEAM2);
	armagon_think();
};

void() armagon_watk2 = [13, armagon_watk3]
{
	sound(self, TE_WIZSPIKE, "armagon/servo.wav", SERVO_VOLUME, ATTN_ARMAGON);
	ChangeYaw();
	walkmove(self.angles_y, TEAM2);
	armagon_think();
};

void() armagon_watk3 = [14, armagon_watk4]
{
	ChangeYaw();
	walkmove(self.angles_y, TEAM2);
	armagon_think();
};

void() armagon_watk4 = [15, armagon_watk5]
{
	sound(self, TE_LIGHTNING2, "armagon/footfall.wav", USE_COUNT, ATTN_ARMAGON);
	ChangeYaw();
	walkmove(self.angles_y, TEAM2);
	armagon_think();
};

void() armagon_watk5 = [16, armagon_watk6]
{
	ChangeYaw();
	walkmove(self.angles_y, TEAM2);
	armagon_think();
};

void() armagon_watk6 = [17, armagon_watk7]
{
	ChangeYaw();
	walkmove(self.angles_y, TEAM2);
	armagon_think();
	armagon_launch_missile(40, MSG_BROADCAST);
};

void() armagon_watk7 = [18, armagon_watk8]
{
	ChangeYaw();
	walkmove(self.angles_y, TEAM2);
	armagon_think();
};

void() armagon_watk8 = [19, armagon_watk9]
{
	sound(self, TE_WIZSPIKE, "armagon/servo.wav", SERVO_VOLUME, ATTN_ARMAGON);
	ChangeYaw();
	walkmove(self.angles_y, TEAM2);
	armagon_think();
};

void() armagon_watk9 = [20, armagon_watk10]
{
	ChangeYaw();
	walkmove(self.angles_y, TEAM2);
	armagon_think();
};

void() armagon_watk10 = [21, armagon_watk11]
{
	sound(self, TE_LIGHTNING2, "armagon/footfall.wav", USE_COUNT, ATTN_ARMAGON);
	ChangeYaw();
	walkmove(self.angles_y, TEAM2);
	armagon_think();
};

void() armagon_watk11 = [22, armagon_watk13]
{
	ChangeYaw();
	walkmove(self.angles_y, TEAM2);
	armagon_think();
	armagon_launch_missile(-40, MSG_BROADCAST);
};

void() armagon_watk13 = [23, armagon_run1]
{
	ChangeYaw();
	walkmove(self.angles_y, TEAM2);
	armagon_think();
	SUB_AttackFinished(USE_COUNT);
};

void() armagon_wlaseratk1 = [12, armagon_wlaseratk2]
{
	ChangeYaw();
	walkmove(self.angles_y, TEAM2);
	armagon_think();
};

void() armagon_wlaseratk2 = [13, armagon_wlaseratk3]
{
	sound(self, TE_WIZSPIKE, "armagon/servo.wav", SERVO_VOLUME, ATTN_ARMAGON);
	ChangeYaw();
	walkmove(self.angles_y, TEAM2);
	armagon_think();
};

void() armagon_wlaseratk3 = [14, armagon_wlaseratk4]
{
	ChangeYaw();
	walkmove(self.angles_y, TEAM2);
	armagon_think();
};

void() armagon_wlaseratk4 = [15, armagon_wlaseratk5]
{
	sound(self, TE_LIGHTNING2, "armagon/footfall.wav", USE_COUNT, ATTN_ARMAGON);
	ChangeYaw();
	walkmove(self.angles_y, TEAM2);
	armagon_think();
};

void() armagon_wlaseratk5 = [16, armagon_wlaseratk6]
{
	ChangeYaw();
	walkmove(self.angles_y, TEAM2);
	armagon_think();
};

void() armagon_wlaseratk6 = [17, armagon_wlaseratk7]
{
	ChangeYaw();
	walkmove(self.angles_y, TEAM2);
	armagon_think();
	armagon_launch_laser(40);
};

void() armagon_wlaseratk7 = [18, armagon_wlaseratk8]
{
	ChangeYaw();
	walkmove(self.angles_y, TEAM2);
	armagon_think();
};

void() armagon_wlaseratk8 = [19, armagon_wlaseratk9]
{
	sound(self, TE_WIZSPIKE, "armagon/servo.wav", SERVO_VOLUME, ATTN_ARMAGON);
	ChangeYaw();
	walkmove(self.angles_y, TEAM2);
	armagon_think();
};

void() armagon_wlaseratk9 = [20, armagon_wlaseratk10]
{
	ChangeYaw();
	walkmove(self.angles_y, TEAM2);
	armagon_think();
};

void() armagon_wlaseratk10 = [21, armagon_wlaseratk11]
{
	sound(self, TE_LIGHTNING2, "armagon/footfall.wav", USE_COUNT, ATTN_ARMAGON);
	ChangeYaw();
	walkmove(self.angles_y, TEAM2);
	armagon_think();
};

void() armagon_wlaseratk11 = [22, armagon_wlaseratk13]
{
	ChangeYaw();
	walkmove(self.angles_y, TEAM2);
	armagon_think();
	armagon_launch_laser(-40);
};

void() armagon_wlaseratk13 = [23, armagon_run1]
{
	ChangeYaw();
	walkmove(self.angles_y, TEAM2);
	armagon_think();
	SUB_AttackFinished(USE_COUNT);
};

void() armagon_overleft1 = [25, armagon_overleft2]
{
	self.count = MSG_BROADCAST;
	armagon_overleft_think();
};

void() armagon_overleft2 = [26, armagon_overleft3]
{
	armagon_overleft_think();
};

void() armagon_overleft3 = [27, armagon_overleft4]
{
	sound(self, TE_WIZSPIKE, "armagon/servo.wav", SERVO_VOLUME, ATTN_ARMAGON);
	armagon_overleft_think();
};

void() armagon_overleft4 = [28, armagon_overleft5]
{
	armagon_overleft_think();
};

void() armagon_overleft5 = [29, armagon_overleft6]
{
	sound(self, TE_LIGHTNING2, "armagon/footfall.wav", USE_COUNT, ATTN_ARMAGON);
	armagon_overleft_think();
};

void() armagon_overleft6 = [30, armagon_overleft7]
{
	armagon_overleft_think();
};

void() armagon_overleft7 = [31, armagon_overleft8]
{
	armagon_overleft_think();
};

void() armagon_overleft8 = [32, armagon_overleft9]
{
	sound(self, TE_WIZSPIKE, "armagon/servo.wav", SERVO_VOLUME, ATTN_ARMAGON);
	armagon_overleft_think();
};

void() armagon_overleft9 = [33, armagon_overleft10]
{
	armagon_overleft_think();
};

void() armagon_overleft10 = [34, armagon_overleft11]
{
	sound(self, TE_LIGHTNING2, "armagon/footfall.wav", USE_COUNT, ATTN_ARMAGON);
	armagon_overleft_think();
};

void() armagon_overleft11 = [35, armagon_overleft12]
{
	self.count = USE_COUNT;
	armagon_overleft_think();
};

void() armagon_overleft12 = [36, armagon_overleft13]
{
	self.count = LIGHTNING_BOOM;
	armagon_overleft_think();
};

void() armagon_overleft13 = [37, armagon_overleft14]
{
	armagon_overleft_think();
};

void() armagon_overleft14 = [38, armagon_overleft15]
{
	armagon_overleft_think();
};

void() armagon_overleft15 = [39, armagon_run1]
{
	armagon_overleft_think();
	SUB_AttackFinished(USE_COUNT);
};

void() armagon_overright1 = [40, armagon_overright2]
{
	self.count = MSG_BROADCAST;
	armagon_overright_think();
};

void() armagon_overright2 = [41, armagon_overright3]
{
	armagon_overright_think();
};

void() armagon_overright3 = [42, armagon_overright4]
{
	sound(self, TE_WIZSPIKE, "armagon/servo.wav", SERVO_VOLUME, ATTN_ARMAGON);
	armagon_overright_think();
};

void() armagon_overright4 = [43, armagon_overright5]
{
	armagon_overright_think();
};

void() armagon_overright5 = [44, armagon_overright6]
{
	sound(self, TE_LIGHTNING2, "armagon/footfall.wav", USE_COUNT, ATTN_ARMAGON);
	self.count = USE_COUNT;
	armagon_overright_think();
};

void() armagon_overright6 = [45, armagon_overright7]
{
	self.count = LIGHTNING_BOOM;
	armagon_overright_think();
};

void() armagon_overright7 = [46, armagon_overright8]
{
	armagon_overright_think();
};

void() armagon_overright8 = [47, armagon_overright9]
{
	sound(self, TE_WIZSPIKE, "armagon/servo.wav", SERVO_VOLUME, ATTN_ARMAGON);
	armagon_overright_think();
};

void() armagon_overright9 = [48, armagon_overright10]
{
	armagon_overright_think();
};

void() armagon_overright10 = [49, armagon_overright11]
{
	sound(self, TE_LIGHTNING2, "armagon/footfall.wav", USE_COUNT, ATTN_ARMAGON);
	armagon_overright_think();
};

void() armagon_overright11 = [50, armagon_overright12]
{
	armagon_overright_think();
};

void() armagon_overright12 = [51, armagon_run1]
{
	armagon_overright_think();
	SUB_AttackFinished(USE_COUNT);
};

void() armagon_plant1 = [64, armagon_plant1]
{
	armagon_stand_attack();
	armagon_think();
};

void() armagon_stop1 = [84, armagon_stop2]
{
	armagon_think();
};

void() armagon_stop2 = [85, armagon_plant1]
{
	sound(self, TE_LIGHTNING2, "armagon/footfall.wav", USE_COUNT, ATTN_ARMAGON);
	armagon_think();
};

void() armagon_satk1 = [52, armagon_satk2]
{
	armagon_think();
};

void() armagon_satk2 = [53, armagon_satk3]
{
	armagon_think();
};

void() armagon_satk3 = [54, armagon_satk4]
{
	armagon_think();
};

void() armagon_satk4 = [55, armagon_satk5]
{
	armagon_think();
};

void() armagon_satk5 = [56, armagon_satk6]
{
	armagon_think();
};

void() armagon_satk6 = [57, armagon_satk7]
{
	sound(self, TE_LIGHTNING2, "armagon/footfall.wav", USE_COUNT, ATTN_ARMAGON);
	armagon_think();
};

void() armagon_satk7 = [58, armagon_satk8]
{
	armagon_think();
};

void() armagon_satk8 = [59, armagon_satk9]
{
	armagon_think();
};

void() armagon_satk9 = [60, armagon_satk10]
{
	armagon_think();
	armagon_launch_missile(40, MSG_BROADCAST);
	armagon_launch_missile(-40, MSG_BROADCAST);
};

void() armagon_satk10 = [61, armagon_satk11]
{
	armagon_think();
};

void() armagon_satk11 = [60, armagon_satk12]
{
	armagon_think();
	armagon_launch_missile(40, MSG_BROADCAST);
	armagon_launch_missile(-40, MSG_BROADCAST);
};

void() armagon_satk12 = [61, armagon_satk13]
{
	armagon_think();
};

void() armagon_satk13 = [60, armagon_satk14]
{
	armagon_think();
	armagon_launch_missile(40, MSG_BROADCAST);
	armagon_launch_missile(-40, MSG_BROADCAST);
};

void() armagon_satk14 = [61, armagon_satk15]
{
	armagon_think();
};

void() armagon_satk15 = [62, armagon_satk16]
{
	armagon_think();
};

void() armagon_satk16 = [63, armagon_plant1]
{
	armagon_think();
	SUB_AttackFinished(0.3);
};

void() armagon_slaser1 = [52, armagon_slaser2]
{
	armagon_think();
};

void() armagon_slaser2 = [53, armagon_slaser3]
{
	armagon_think();
};

void() armagon_slaser3 = [54, armagon_slaser4]
{
	armagon_think();
};

void() armagon_slaser4 = [55, armagon_slaser5]
{
	armagon_think();
};

void() armagon_slaser5 = [56, armagon_slaser6]
{
	armagon_think();
};

void() armagon_slaser6 = [57, armagon_slaser7]
{
	sound(self, TE_LIGHTNING2, "armagon/footfall.wav", USE_COUNT, ATTN_ARMAGON);
	armagon_think();
};

void() armagon_slaser7 = [58, armagon_slaser8]
{
	armagon_think();
};

void() armagon_slaser8 = [59, armagon_slaser9]
{
	armagon_think();
};

void() armagon_slaser9 = [60, armagon_slaser10]
{
	armagon_think();
	armagon_launch_laser(40);
	armagon_launch_laser(-40);
};

void() armagon_slaser10 = [61, armagon_slaser11]
{
	armagon_think();
};

void() armagon_slaser11 = [60, armagon_slaser12]
{
	armagon_think();
	armagon_launch_laser(40);
	armagon_launch_laser(-40);
};

void() armagon_slaser12 = [61, armagon_slaser13]
{
	armagon_think();
};

void() armagon_slaser13 = [60, armagon_slaser14]
{
	armagon_think();
	armagon_launch_laser(40);
	armagon_launch_laser(-40);
};

void() armagon_slaser14 = [61, armagon_slaser15]
{
	armagon_think();
};

void() armagon_slaser15 = [60, armagon_slaser16]
{
	armagon_think();
	armagon_launch_laser(40);
	armagon_launch_laser(-40);
};

void() armagon_slaser16 = [61, armagon_slaser17]
{
	armagon_think();
};

void() armagon_slaser17 = [60, armagon_slaser18]
{
	armagon_think();
	armagon_launch_laser(40);
	armagon_launch_laser(-40);
};

void() armagon_slaser18 = [61, armagon_slaser19]
{
	armagon_think();
};

void() armagon_slaser19 = [62, armagon_slaser20]
{
	armagon_think();
};

void() armagon_slaser20 = [63, armagon_plant1]
{
	armagon_think();
	SUB_AttackFinished(0.3);
};

void() armagon_die1 = [84, armagon_die2]
{
	armagon_think();
	self.nextthink = time + 0.2;
};

void() armagon_die2 = [85, armagon_die3]
{
	armagon_think();
	self.nextthink = time + 0.2;
};

void() armagon_die3 = [86, armagon_die4]
{
	armagon_think();
	self.nextthink = time + 0.2;
};

void() armagon_die4 = [87, armagon_die5]
{
	armagon_think();
	multi_explosion(self.origin + '0 0 48', 48, MIN_ANGLE_DELTA, TE_LIGHTNING2, 0.3, 0.3);
	sound(self, CHAN_AUTO, "armagon/death.wav", USE_COUNT, ATTN_NONE);
	self.nextthink = time + 0.2;
};

void() armagon_die5 = [88, armagon_die6]
{
	armagon_think();
	self.nextthink = time + 0.2;
};

void() armagon_die6 = [89, armagon_die7]
{
	armagon_think();
	self.nextthink = time + 0.2;
};

void() armagon_die7 = [90, armagon_die8]
{
	armagon_think();
	self.nextthink = time + 0.2;
};

void() armagon_die8 = [91, armagon_die9]
{
	armagon_think();
	self.nextthink = time + LIGHTNING_BOOM;
};

void() armagon_die9 = [92, armagon_die10]
{
	armagon_think();
	self.nextthink = time + 0.2;
};

void() armagon_die10 = [93, armagon_die11]
{
	armagon_think();
	self.nextthink = time + 0.2;
};

void() armagon_die11 = [94, armagon_die12]
{
	armagon_think();
	self.nextthink = time + 0.2;
};

void() armagon_die12 = [95, armagon_die13]
{
	armagon_think();
	self.nextthink = time + 0.2;
};

void() armagon_die13 = [96, armagon_die14]
{
	armagon_think();
	self.nextthink = time + 0.2;
};

void() armagon_die14 = [97, armagon_die14]
{
	local entity body;
	armagon_think();
	multi_explosion(self.origin + '0 0 80', 20, MIN_ANGLE_DELTA, SVC_UPDATESTAT, 0.1, SERVO_VOLUME);
	self.nextthink = CONTENT_EMPTY;
	self.movetype = MOVETYPE_NONE;
	self.takedamage = DAMAGE_NO;
	self.solid = SOLID_NOT;
	setsize(self, VEC_HULL2_MIN, '32 32 32');
	self.flags = MSG_BROADCAST;
	self.gorging = 1;
	self.wait = time + AS_DODGING;
	body = self.trigger_field;
	body.nextthink = CONTENT_EMPTY;
	self.movetype = MOVETYPE_NONE;
	body.takedamage = DAMAGE_NO;
	body.solid = SOLID_NOT;
	body.think = armagon_body_explode1;
	body.nextthink = time + 0.1;
	body.gorging = 1;
};

void() armagon_body_explode2 = 
{
	local entity expl;
	sound(self, CHAN_AUTO, "misc/longexpl.wav", USE_COUNT, ATTN_ARMAGON);
	self.think = armagon_body_explode2;
	ThrowGib("progs/gib1.mdl", -200);
	ThrowGib("progs/gib2.mdl", -200);
	ThrowGib("progs/gib3.mdl", -200);
	ThrowGib("progs/gib1.mdl", -200);
	ThrowGib("progs/gib2.mdl", -200);
	ThrowGib("progs/gib3.mdl", -200);
	ThrowGib("progs/gib1.mdl", -200);
	ThrowGib("progs/gib2.mdl", -200);
	ThrowGib("progs/gib3.mdl", -200);
	self.movetype = MOVETYPE_NONE;
	setmodel(self, "progs/s_explod.spr");
	self.solid = SOLID_NOT;
	self.nextthink = time + 0.1;
	s_explode1();
};

void() armagon_body_explode1 = 
{
	self.think = armagon_body_explode1;
	self.nextthink = time + 0.1;
	if (self.cnt == MSG_BROADCAST)
	{
		self.count = MSG_BROADCAST;
	}
	if (self.cnt < 25)
	{
		if (self.cnt > self.count)
		{
			ThrowGib("progs/gib1.mdl", -100);
			ThrowGib("progs/gib2.mdl", -100);
			ThrowGib("progs/gib3.mdl", -100);
			self.count = self.cnt + USE_COUNT;
		}
		self.cnt = self.cnt + USE_COUNT;
	}
	else
	{
		self.cnt = MSG_BROADCAST;
		self.think = armagon_body_explode2;
	}
};

void(entity attacker, float damage) armagon_pain = 
{
	if (self.health <= MSG_BROADCAST)
	{
		return;
	}
	if (damage < 25)
	{
		return;
	}
	if (self.pain_finished > time)
	{
		return;
	}
	self.pain_finished = time + LIGHTNING_BOOM;
	sound(self, CHAN_VOICE, "armagon/pain.wav", USE_COUNT, ATTN_NORM);
};

void() armagon_missile_attack = 
{
	if (random() < SERVO_VOLUME)
	{
		armagon_watk1();
	}
	else
	{
		armagon_wlaseratk1();
	}
};

void() armagon_repulse_attack = 
{
	local entity head;
	local vector dir;
	armagon_think();
	if (self.state == MSG_BROADCAST)
	{
		SUB_AttackFinished(SERVO_VOLUME);
		sound(self, CHAN_BODY, "armagon/repel.wav", USE_COUNT, ATTN_NORM);
		self.state = USE_COUNT;
		return;
	}
	else
	{
		if (self.state == USE_COUNT)
		{
			head = findradius(self.origin, 300);
			while (head)
			{
				if (!(head.flags & FL_NOTARGET) && (head.flags & FL_CLIENT))
				{
					if (visible(head) && head.health > MSG_BROADCAST)
					{
						dir = head.origin - (self.origin - '0 0 24');
						dir = normalize(dir);
						head.velocity = head.velocity + dir * CHARMED_RADIUS;
					}
				}
				head = head.chain;
			}
			T_RadiusDamage(self, self, 60, self);
			self.state = MSG_BROADCAST;
			SUB_AttackFinished(0.1);
		}
	}
};

void() armagon_stand_attack = 
{
	local vector spot1;
	local vector spot2;
	spot1 = self.origin + self.view_ofs;
	spot2 = self.enemy.origin + self.enemy.view_ofs;
	traceline(spot1, spot2, 0, self);
	if (trace_ent != self.enemy)
	{
		armagon_run1();
		return;
	}
	if (trace_inopen && trace_inwater)
	{
		armagon_run1();
		return;
	}
	if (time < self.attack_finished)
	{
		return;
	}
	if (vlen(spot2 - spot1) < MAX_CHARMER_DISTANCE && self.enemy.classname == "player")
	{
		armagon_repulse_attack();
		return;
	}
	self.state = MSG_BROADCAST;
	if (vlen(spot2 - spot1) > 450)
	{
		armagon_run1();
		return;
	}
	if (random() < SERVO_VOLUME)
	{
		armagon_satk1();
	}
	else
	{
		armagon_slaser1();
	}
	if (self.cnt == USE_COUNT)
	{
		armagon_run1();
		return;
	}
};

float() ArmagonCheckAttack = 
{
	local vector spot1;
	local vector spot2;
	local entity targ;
	local float ang;
	local float delta;
	local float dist;
	self.lefty = MSG_BROADCAST;
	targ = self.enemy;
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;
	traceline(spot1, spot2, 0, self);
	if (trace_ent != targ && !(self.charmed))
	{
		return 0;
	}
	if (trace_inopen && trace_inwater)
	{
		return 0;
	}
	if (time < self.attack_finished)
	{
		return 0;
	}
	ang = self.angles_y + self.fixangle;
	delta = self.ideal_yaw - ang;
	dist = vlen(spot2 - spot1);
	if (fabs(delta) > MIN_ANGLE_DELTA && dist > MAX_CHARMER_DISTANCE || self.enemy.classname != "player")
	{
		return 0;
	}
	if (dist < CTF_TARGET_PROTECT_RADIUS)
	{
		self.th_melee();
		return 1;
	}
	self.lefty = USE_COUNT;
	return 0;
};

void() monster_armagon = 
{
	local entity body;
	local float sk;
	if (deathmatch)
	{
		remove(self);
		return;
	}
	self.lefty = MSG_BROADCAST;
	sk = cvar("skill");
	precache_model("progs/armabody.mdl");
	precache_model("progs/armalegs.mdl");
	precache_sound("armagon/footfall.wav");
	precache_sound("armagon/servo.wav");
	precache_sound("armagon/death.wav");
	precache_sound("armagon/pain.wav");
	precache_sound("armagon/repel.wav");
	precache_sound("armagon/sight.wav");
	precache_sound("armagon/idle1.wav");
	precache_sound("armagon/idle2.wav");
	precache_sound("armagon/idle3.wav");
	precache_sound("armagon/idle4.wav");
	body = spawn();
	body.origin = self.origin;
	body.origin = body.origin - '0 0 64';
	self.solid = SOLID_SLIDEBOX;
	self.fixangle = MSG_BROADCAST;
	self.movetype = MOVETYPE_STEP;
	body.solid = SOLID_NOT;
	body.movetype = MOVETYPE_STEP;
	self.trigger_field = body;
	body.trigger_field = self;
	setmodel(body, "progs/armabody.mdl");
	setmodel(self, "progs/armalegs.mdl");
	setsize(self, '-48 -48 -24', '48 48 84');
	setorigin(self, self.origin);
	setorigin(body, body.origin);
	if (sk == MSG_BROADCAST)
	{
		self.yaw_speed = AS_DODGING;
		self.health = 2000;
		self.worldtype = 0.9;
	}
	else
	{
		if (sk == USE_COUNT)
		{
			self.yaw_speed = TE_LIGHTNING3;
			self.health = 2500;
			self.worldtype = 0.85;
		}
		else
		{
			self.yaw_speed = STAT_TOTALMONSTERS;
			self.health = 3500;
			self.worldtype = 0.75;
		}
	}
	self.state = MSG_BROADCAST;
	self.super_time = MSG_BROADCAST;
	self.endtime = MSG_BROADCAST;
	self.th_stand = armagon_stand1;
	self.th_walk = armagon_walk1;
	self.th_run = armagon_run1;
	self.th_die = armagon_die1;
	self.th_missile = armagon_missile_attack;
	self.th_melee = armagon_stop1;
	self.th_pain = armagon_pain;
	walkmonster_start();
};

