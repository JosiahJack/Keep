float() GremlinAttemptWeaponSteal = 
{
	local vector delta;
	local entity tempself;
	local float best;
	local entity victim;
	local float amount;
	if (self.stoleweapon)
	{
		dprint("gremlin trying to steal a weapon again\n");
		return 0;
	}
	if (!(self.enemy.flags & FL_CLIENT))
	{
		return 0;
	}
	delta = self.enemy.origin - self.origin;
	if (vlen(delta) > 100)
	{
		return 0;
	}
	if (random() < 0.5)
	{
		return 0;
	}
	victim = self.enemy;
	best = victim.weapon;
	if (best == IT_AXE || best == IT_SHOTGUN || best == IT_MJOLNIR)
	{
		return 0;
	}
	victim.items = victim.items - (victim.items & best);
	self.items = self.items | best;
	self.weapon = best;
	self.items = self.items - (self.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS));
	if (best == IT_SUPER_SHOTGUN)
	{
		amount = victim.ammo_shells;
		if (amount > 20)
		{
			amount = 20;
		}
		victim.ammo_shells = victim.ammo_shells - amount;
		self.ammo_shells = self.ammo_shells + amount;
		self.items = self.items | IT_SHELLS;
		self.currentammo = self.ammo_shells;
		sprint(victim, "Gremlin stole your Super Shotgun\n");
	}
	else
	{
		if (best == IT_NAILGUN)
		{
			amount = victim.ammo_nails;
			if (amount > 40)
			{
				amount = 40;
			}
			victim.ammo_nails = victim.ammo_nails - amount;
			self.ammo_nails = self.ammo_nails + amount;
			self.items = self.items | IT_NAILS;
			self.currentammo = self.ammo_nails;
			sprint(victim, "Gremlin stole your Nailgun\n");
		}
		else
		{
			if (best == IT_SUPER_NAILGUN)
			{
				amount = victim.ammo_nails;
				if (amount > 40)
				{
					amount = 40;
				}
				victim.ammo_nails = victim.ammo_nails - amount;
				self.ammo_nails = self.ammo_nails + amount;
				self.items = self.items | IT_NAILS;
				self.currentammo = self.ammo_nails;
				sprint(victim, "Gremlin stole your Super Nailgun\n");
			}
			else
			{
				if (best == IT_GRENADE_LAUNCHER)
				{
					amount = victim.ammo_rockets;
					if (amount > MOVETYPE_FLY)
					{
						amount = MOVETYPE_FLY;
					}
					victim.ammo_rockets = victim.ammo_rockets - amount;
					self.ammo_rockets = self.ammo_rockets + amount;
					self.items = self.items | IT_ROCKETS;
					self.currentammo = self.ammo_rockets;
					sprint(victim, "Gremlin stole your Grenade Launcher\n");
				}
				else
				{
					if (best == IT_ROCKET_LAUNCHER)
					{
						amount = victim.ammo_rockets;
						if (amount > MOVETYPE_FLY)
						{
							amount = MOVETYPE_FLY;
						}
						victim.ammo_rockets = victim.ammo_rockets - amount;
						self.ammo_rockets = self.ammo_rockets + amount;
						self.items = self.items | IT_ROCKETS;
						self.currentammo = self.ammo_rockets;
						sprint(victim, "Gremlin stole your Rocket Launcher\n");
					}
					else
					{
						if (best == IT_LIGHTNING)
						{
							amount = victim.ammo_cells;
							if (amount > 40)
							{
								amount = 40;
							}
							victim.ammo_cells = victim.ammo_cells - amount;
							self.ammo_cells = self.ammo_cells + amount;
							self.items = self.items | IT_CELLS;
							self.currentammo = self.ammo_cells;
							sprint(victim, "Gremlin stole your Lightning Gun\n");
						}
						else
						{
							if (best == IT_LASER_CANNON)
							{
								amount = victim.ammo_cells;
								if (amount > 40)
								{
									amount = 40;
								}
								victim.ammo_cells = victim.ammo_cells - amount;
								self.ammo_cells = self.ammo_cells + amount;
								self.items = self.items | IT_CELLS;
								self.currentammo = self.ammo_cells;
								sprint(victim, "Gremlin stole your Laser Cannon\n");
							}
							else
							{
								if (best == IT_PROXIMITY_GUN)
								{
									amount = victim.ammo_rockets;
									if (amount > MOVETYPE_FLY)
									{
										amount = MOVETYPE_FLY;
									}
									victim.ammo_rockets = victim.ammo_rockets - amount;
									self.ammo_rockets = self.ammo_rockets + amount;
									self.items = self.items | IT_ROCKETS;
									self.currentammo = self.ammo_rockets;
									sprint(victim, "Gremlin stole your Proximity Gun\n");
								}
							}
						}
					}
				}
			}
		}
	}
	tempself = self;
	self = victim;
	self.weapon = W_BestWeapon();
	W_SetCurrentAmmo();
	self = tempself;
	self.stoleweapon = 1;
	self.attack_finished = time;
	if (random() > 0.65)
	{
		self.lastvictim = victim;
	}
	else
	{
		self.lastvictim = self;
	}
	victim = GremlinFindVictim();
	if (victim != world)
	{
		self.enemy = victim;
		FoundTarget();
		self.attack_finished = time;
		self.search_time = time + 1;
	}
	return 1;
};

float() GremlinFindTarget = 
{
	local entity head;
	local entity gorge;
	local float dist;
	local float result;
	if (self.stoleweapon == 0 && time > self.wait)
	{
		self.wait = time + 1;
		dist = 2000;
		gorge = world;
		head = nextent(world);
		while (head != world)
		{
			if (head.health < 1 && (head.flags & (FL_MONSTER | FL_CLIENT)))
			{
				result = fabs(head.origin_z - self.origin_z);
				if (visible(head) && result < 80 && head.gorging == 0 && visible_distance < dist)
				{
					dist = visible_distance;
					gorge = head;
				}
			}
			head = nextent(head);
		}
		if (gorge != world && dist < 700 * random())
		{
			self.oldenemy = self.enemy;
			self.gorging = 1;
			self.enemy = gorge;
			self.search_time = time + MOVETYPE_STEP;
			FoundTarget();
			return 1;
		}
	}
	else
	{
		if (self.stoleweapon)
		{
			head = GremlinFindVictim();
			if (head != world)
			{
				self.enemy = head;
				FoundTarget();
				self.attack_finished = time;
				self.search_time = time + FL_SWIM;
				return 1;
			}
		}
	}
	result = FindTarget();
	self.search_time = time + FL_SWIM;
	return result;
};

void(float dist) gremlin_walk = 
{
	movedist = dist;
	if (GremlinFindTarget())
	{
		return;
	}
	movetogoal(dist);
};

void() gremlin_stand = 
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

void(float dist) gremlin_run = 
{
	local entity oldtarget;
	local float r;
	local vector d;
	local vector ang;
	local float done;
	local vector end;
	local float c;
	if (self.watertype == CONTENT_LAVA)
	{
		T_Damage(self, world, world, 2000);
	}
	movedist = dist;
	if (self.stoleweapon)
	{
		self.frame = self.frame + 164 - 29;
	}
	if (self.gorging)
	{
		traceline(self.origin, self.enemy.origin, 1, self);
		if (trace_fraction != 1)
		{
			self.gorging = 0;
			return;
		}
		if (!visible(self.enemy))
		{
			self.gorging = 0;
			return;
		}
		r = vlen(self.enemy.origin - self.origin);
		if (r < 130)
		{
			ai_face();
			if (r < 45)
			{
				self.th_melee();
				self.attack_state = AS_STRAIGHT;
				return;
			}
			else
			{
				if (walkmove(self.angles_y, dist) == 0)
				{
					self.gorging = 0;
					return;
				}
			}
			return;
		}
		movetogoal(dist);
	}
	else
	{
		if (random() > 0.970000)
		{
			if (GremlinFindTarget())
			{
				return;
			}
		}
		if (self.stoleweapon)
		{
			if (self.enemy.health < 0 && self.enemy.classname == "player")
			{
				gremlin_glook1();
				return;
			}
			if (!GremlinCheckNoAmmo())
			{
				if (self.t_length == 1)
				{
					remove(self.trigger_field);
					self.goalentity = self.enemy;
					self.t_length = 0;
				}
				return;
			}
			r = vlen(self.enemy.origin - self.origin);
			d = normalize(self.origin - self.enemy.origin);
			if (self.t_length == 0)
			{
				if (r < MIN_CHARMER_DISTANCE)
				{
					self.trigger_field = spawn();
					setsize(self.trigger_field, '-1 -1 -1', '1 1 1');
					self.t_length = 1;
				}
			}
			if (self.t_length == 1)
			{
				if (r > 250)
				{
					remove(self.trigger_field);
					self.goalentity = self.enemy;
					self.t_length = 0;
				}
				else
				{
					if (r < 160)
					{
						ang = vectoangles(d);
						done = 0;
						c = 0;
						while (done == 0)
						{
							makevectors(ang);
							end = self.enemy.origin + v_forward * 350;
							traceline(self.enemy.origin, end, 0, self);
							if (trace_fraction == 1)
							{
								traceline(self.origin, end, 0, self);
								if (trace_fraction == 1)
								{
									done = 1;
								}
							}
							ang_y = anglemod(ang_y + 36);
							c = c + 1;
							if (c == MOVETYPE_BOUNCE)
							{
								done = 1;
							}
						}
						setorigin(self.trigger_field, end);
					}
					self.goalentity = self.trigger_field;
					self.ideal_yaw = vectoyaw(normalize(self.goalentity.origin - self.origin));
					ChangeYaw();
					movetogoal(dist);
					self.nextthink = time + GYRO_TURBULENCEMOD_AIR;
					return;
				}
			}
		}
		ai_run(dist);
		self.nextthink = time + GYRO_TURBULENCEMOD_AIR;
	}
};

void() gremlin_stand1 = [0, gremlin_stand2]
{
	gremlin_stand();
	self.nextthink = time + 0.2;
};

void() gremlin_stand2 = [1, gremlin_stand3]
{
	gremlin_stand();
	self.nextthink = time + 0.2;
};

void() gremlin_stand3 = [2, gremlin_stand4]
{
	gremlin_stand();
	self.nextthink = time + 0.2;
};

void() gremlin_stand4 = [3, gremlin_stand5]
{
	gremlin_stand();
	self.nextthink = time + 0.2;
};

void() gremlin_stand5 = [4, gremlin_stand6]
{
	gremlin_stand();
	self.nextthink = time + 0.2;
};

void() gremlin_stand6 = [5, gremlin_stand7]
{
	gremlin_stand();
	self.nextthink = time + 0.2;
};

void() gremlin_stand7 = [6, gremlin_stand8]
{
	gremlin_stand();
	self.nextthink = time + 0.2;
};

void() gremlin_stand8 = [7, gremlin_stand9]
{
	gremlin_stand();
	self.nextthink = time + 0.2;
};

void() gremlin_stand9 = [8, gremlin_stand10]
{
	gremlin_stand();
	self.nextthink = time + 0.2;
};

void() gremlin_stand10 = [9, gremlin_stand11]
{
	gremlin_stand();
	self.nextthink = time + 0.2;
};

void() gremlin_stand11 = [10, gremlin_stand12]
{
	gremlin_stand();
	self.nextthink = time + 0.2;
};

void() gremlin_stand12 = [11, gremlin_stand13]
{
	gremlin_stand();
	self.nextthink = time + 0.2;
};

void() gremlin_stand13 = [12, gremlin_stand14]
{
	gremlin_stand();
	self.nextthink = time + 0.2;
};

void() gremlin_stand14 = [13, gremlin_stand15]
{
	gremlin_stand();
	self.nextthink = time + 0.2;
};

void() gremlin_stand15 = [14, gremlin_stand16]
{
	gremlin_stand();
	self.nextthink = time + 0.2;
};

void() gremlin_stand16 = [15, gremlin_stand17]
{
	gremlin_stand();
	self.nextthink = time + 0.2;
};

void() gremlin_stand17 = [16, gremlin_stand1]
{
	gremlin_stand();
	self.nextthink = time + 0.2;
};

void() gremlin_walk1 = [17, gremlin_walk2]
{
	if (random() < GYRO_TURBULENCEMOD_AIR)
	{
		sound(self, CHAN_VOICE, "grem/idle.wav", 1, ATTN_IDLE);
	}
	gremlin_walk(FL_CLIENT);
};

void() gremlin_walk2 = [18, gremlin_walk3]
{
	gremlin_walk(FL_CLIENT);
};

void() gremlin_walk3 = [19, gremlin_walk4]
{
	gremlin_walk(FL_CLIENT);
};

void() gremlin_walk4 = [20, gremlin_walk5]
{
	gremlin_walk(FL_CLIENT);
};

void() gremlin_walk5 = [21, gremlin_walk6]
{
	gremlin_walk(FL_CLIENT);
};

void() gremlin_walk6 = [22, gremlin_walk7]
{
	gremlin_walk(FL_CLIENT);
};

void() gremlin_walk7 = [23, gremlin_walk8]
{
	gremlin_walk(FL_CLIENT);
};

void() gremlin_walk8 = [24, gremlin_walk9]
{
	gremlin_walk(FL_CLIENT);
};

void() gremlin_walk9 = [25, gremlin_walk10]
{
	gremlin_walk(FL_CLIENT);
};

void() gremlin_walk10 = [26, gremlin_walk11]
{
	gremlin_walk(FL_CLIENT);
};

void() gremlin_walk11 = [27, gremlin_walk12]
{
	gremlin_walk(FL_CLIENT);
};

void() gremlin_walk12 = [28, gremlin_walk1]
{
	gremlin_walk(FL_CLIENT);
};

void() gremlin_run1 = [29, gremlin_run2]
{
	if (random() < GYRO_TURBULENCEMOD_AIR)
	{
		sound(self, CHAN_VOICE, "grem/idle.wav", 1, ATTN_IDLE);
	}
	gremlin_run(0);
};

void() gremlin_run2 = [30, gremlin_run3]
{
	gremlin_run(FL_CLIENT);
};

void() gremlin_run3 = [31, gremlin_run4]
{
	gremlin_run(STAT_TOTALMONSTERS);
};

void() gremlin_run4 = [32, gremlin_run5]
{
	gremlin_run(FL_INWATER);
};

void() gremlin_run5 = [33, gremlin_run6]
{
	gremlin_run(FL_INWATER);
};

void() gremlin_run6 = [34, gremlin_run7]
{
	gremlin_run(STAT_TOTALMONSTERS);
};

void() gremlin_run7 = [35, gremlin_run8]
{
	gremlin_run(FL_CLIENT);
};

void() gremlin_run8 = [36, gremlin_run9]
{
	gremlin_run(0);
};

void() gremlin_run9 = [37, gremlin_run10]
{
	gremlin_run(FL_CLIENT);
};

void() gremlin_run10 = [38, gremlin_run11]
{
	gremlin_run(STAT_TOTALMONSTERS);
};

void() gremlin_run11 = [39, gremlin_run12]
{
	gremlin_run(FL_INWATER);
};

void() gremlin_run12 = [40, gremlin_run1]
{
	gremlin_run(FL_INWATER);
};

void() gremlin_run13 = [41, gremlin_run14]
{
	gremlin_run(STAT_TOTALMONSTERS);
};

void() gremlin_run14 = [42, gremlin_run15]
{
	gremlin_run(FL_CLIENT);
};

void() gremlin_run15 = [43, gremlin_run1]
{
	gremlin_run(0);
};

void() gremlin_jump1 = [44, gremlin_jump2]
{
	ai_face();
};

void() gremlin_jump2 = [45, gremlin_jump3]
{
	ai_face();
};

void() gremlin_jump3 = [46, gremlin_jump4]
{
	ai_face();
};

void() gremlin_jump4 = [47, gremlin_jump5]
{
	ai_face();
};

void() gremlin_jump5 = [48, gremlin_jump6]
{
	ai_face();
	if (self.flags & FL_ONGROUND)
	{
		self.touch = Gremlin_JumpTouch;
		makevectors(self.angles);
		self.origin_z = self.origin_z + 1;
		self.velocity = v_forward * 300 + '0 0 300';
		self.flags = self.flags - FL_ONGROUND;
	}
	else
	{
		gremlin_run1();
	}
};

void() gremlin_jump6 = [49, gremlin_jump7]
{
};

void() gremlin_jump7 = [50, gremlin_jump8]
{
};

void() gremlin_jump8 = [51, gremlin_jump9]
{
};

void() gremlin_jump9 = [52, gremlin_jump10]
{
};

void() gremlin_jump10 = [53, gremlin_jump11]
{
};

void() gremlin_jump11 = [54, gremlin_jump1]
{
	self.nextthink = time + MOVETYPE_WALK;
};

void() gremlin_jump12 = [55, gremlin_jump13]
{
};

void() gremlin_jump13 = [56, gremlin_jump14]
{
};

void() gremlin_jump14 = [57, gremlin_jump15]
{
};

void() gremlin_jump15 = [58, gremlin_jump16]
{
};

void() gremlin_jump16 = [59, gremlin_run1]
{
};

void() gremlin_shot1 = [135, gremlin_shot2]
{
	self.effects = self.effects | EF_MUZZLEFLASH;
};

void() gremlin_shot2 = [136, gremlin_shot3]
{
};

void() gremlin_shot3 = [137, gremlin_shot4]
{
};

void() gremlin_shot4 = [138, gremlin_shot5]
{
};

void() gremlin_shot5 = [139, gremlin_shot6]
{
};

void() gremlin_shot6 = [140, gremlin_run1]
{
};

void() gremlin_nail1 = [135, gremlin_nail2]
{
	self.effects = self.effects | EF_MUZZLEFLASH;
	Gremlin_FireNailGun(MOVETYPE_STEP);
};

void() gremlin_nail2 = [135, gremlin_nail3]
{
	self.effects = self.effects | EF_MUZZLEFLASH;
	Gremlin_FireNailGun(MOVETYPE_STEP);
};

void() gremlin_nail3 = [135, gremlin_nail4]
{
	self.effects = self.effects | EF_MUZZLEFLASH;
	Gremlin_FireNailGun(MOVETYPE_STEP);
};

void() gremlin_nail4 = [135, gremlin_nail5]
{
	self.effects = self.effects | EF_MUZZLEFLASH;
	Gremlin_FireNailGun(MOVETYPE_STEP);
};

void() gremlin_nail5 = [135, gremlin_nail6]
{
	self.effects = self.effects | EF_MUZZLEFLASH;
	Gremlin_FireNailGun(MOVETYPE_STEP);
};

void() gremlin_nail6 = [135, gremlin_nail7]
{
	self.effects = self.effects | EF_MUZZLEFLASH;
	Gremlin_FireNailGun(MOVETYPE_STEP);
};

void() gremlin_nail7 = [135, gremlin_run1]
{
};

void() gremlin_laser1 = [135, gremlin_laser2]
{
	self.effects = self.effects | EF_MUZZLEFLASH;
	Gremlin_FireLaserGun(MOVETYPE_STEP);
};

void() gremlin_laser2 = [135, gremlin_laser3]
{
	self.effects = self.effects | EF_MUZZLEFLASH;
	Gremlin_FireLaserGun(MOVETYPE_STEP);
};

void() gremlin_laser3 = [135, gremlin_laser4]
{
	self.effects = self.effects | EF_MUZZLEFLASH;
	Gremlin_FireLaserGun(MOVETYPE_STEP);
};

void() gremlin_laser4 = [135, gremlin_laser5]
{
	self.effects = self.effects | EF_MUZZLEFLASH;
	Gremlin_FireLaserGun(MOVETYPE_STEP);
};

void() gremlin_laser5 = [135, gremlin_laser6]
{
	self.effects = self.effects | EF_MUZZLEFLASH;
	Gremlin_FireLaserGun(MOVETYPE_STEP);
};

void() gremlin_laser6 = [135, gremlin_laser7]
{
	self.effects = self.effects | EF_MUZZLEFLASH;
	Gremlin_FireLaserGun(MOVETYPE_STEP);
};

void() gremlin_laser7 = [135, gremlin_run1]
{
};

void() gremlin_light1 = [135, gremlin_light2]
{
	Gremlin_FireLightningGun();
};

void() gremlin_light2 = [135, gremlin_light3]
{
	Gremlin_FireLightningGun();
};

void() gremlin_light3 = [135, gremlin_light4]
{
	Gremlin_FireLightningGun();
};

void() gremlin_light4 = [135, gremlin_light5]
{
	Gremlin_FireLightningGun();
};

void() gremlin_light5 = [135, gremlin_run1]
{
};

void() gremlin_rocket1 = [135, gremlin_rocket2]
{
	self.effects = self.effects | EF_MUZZLEFLASH;
};

void() gremlin_rocket2 = [136, gremlin_rocket3]
{
};

void() gremlin_rocket3 = [137, gremlin_rocket4]
{
};

void() gremlin_rocket4 = [138, gremlin_rocket5]
{
};

void() gremlin_rocket5 = [139, gremlin_rocket6]
{
};

void() gremlin_rocket6 = [140, gremlin_run1]
{
};

void() gremlin_lunge1 = [124, gremlin_lunge2]
{
	ai_charge(0);
};

void() gremlin_lunge2 = [125, gremlin_lunge3]
{
	ai_charge(0);
};

void() gremlin_lunge3 = [126, gremlin_lunge4]
{
	ai_charge(0);
};

void() gremlin_lunge4 = [127, gremlin_lunge5]
{
	ai_charge(0);
};

void() gremlin_lunge5 = [128, gremlin_lunge6]
{
	ai_charge(0);
};

void() gremlin_lunge6 = [129, gremlin_lunge7]
{
	ai_charge(0);
};

void() gremlin_lunge7 = [130, gremlin_lunge8]
{
	ai_charge(15);
};

void() gremlin_lunge8 = [131, gremlin_lunge9]
{
	ai_charge(0);
	Gremlin_Melee(0);
};

void() gremlin_lunge9 = [132, gremlin_lunge10]
{
	ai_charge(0);
};

void() gremlin_lunge10 = [133, gremlin_lunge11]
{
	ai_charge(0);
};

void() gremlin_lunge11 = [134, gremlin_run1]
{
	ai_charge(0);
};

void() gremlin_claw1 = [60, gremlin_claw2]
{
	ai_charge(0);
};

void() gremlin_claw2 = [61, gremlin_claw3]
{
	ai_charge(0);
};

void() gremlin_claw3 = [62, gremlin_claw4]
{
	ai_charge(0);
};

void() gremlin_claw4 = [63, gremlin_claw5]
{
	ai_charge(0);
};

void() gremlin_claw5 = [64, gremlin_claw6]
{
	ai_charge(0);
};

void() gremlin_claw6 = [65, gremlin_claw7]
{
	ai_charge(0);
	Gremlin_Melee(MAX_CHARMER_DISTANCE);
};

void() gremlin_claw7 = [66, gremlin_claw8]
{
	ai_charge(15);
};

void() gremlin_claw8 = [67, gremlin_claw9]
{
	ai_charge(0);
};

void() gremlin_claw9 = [68, gremlin_claw10]
{
	ai_charge(0);
};

void() gremlin_claw10 = [69, gremlin_claw11]
{
	ai_charge(0);
};

void() gremlin_claw11 = [70, gremlin_run1]
{
	ai_charge(0);
};

void() gremlin_gorge1 = [71, gremlin_gorge2]
{
	ai_charge(1);
};

void() gremlin_gorge2 = [72, gremlin_gorge3]
{
	ai_charge(1);
};

void() gremlin_gorge3 = [73, gremlin_gorge4]
{
	ai_charge(FL_SWIM);
};

void() gremlin_gorge4 = [74, gremlin_gorge5]
{
	ai_charge(0);
};

void() gremlin_gorge5 = [75, gremlin_gorge6]
{
	ai_charge(0);
};

void() gremlin_gorge6 = [76, gremlin_gorge7]
{
	ai_charge(0);
	Gremlin_Gorge(MAX_CHARMER_DISTANCE);
};

void() gremlin_gorge7 = [77, gremlin_gorge8]
{
	ai_charge(0);
};

void() gremlin_gorge8 = [78, gremlin_gorge9]
{
	ai_charge(0);
	Gremlin_Gorge(-200);
};

void() gremlin_gorge9 = [79, gremlin_gorge10]
{
	ai_charge(0);
};

void() gremlin_gorge10 = [80, gremlin_gorge11]
{
	ai_charge(0);
};

void() gremlin_gorge11 = [81, gremlin_gorge12]
{
	ai_charge(0);
};

void() gremlin_gorge12 = [82, gremlin_gorge13]
{
	ai_charge(0);
};

void() gremlin_gorge13 = [83, gremlin_gorge1]
{
	ai_charge(0);
};

void() gremlin_look1 = [90, gremlin_look2]
{
	self.nextthink = time + 0.2;
};

void() gremlin_look2 = [91, gremlin_look3]
{
	self.nextthink = time + 0.2;
};

void() gremlin_look3 = [92, gremlin_look4]
{
	self.nextthink = time + 0.2;
};

void() gremlin_look4 = [93, gremlin_look5]
{
	self.nextthink = time + 0.2;
};

void() gremlin_look5 = [94, gremlin_look6]
{
	self.nextthink = time + 0.2;
};

void() gremlin_look6 = [95, gremlin_look7]
{
	self.nextthink = time + 0.2;
};

void() gremlin_look7 = [96, gremlin_look8]
{
	self.nextthink = time + 0.2;
};

void() gremlin_look8 = [97, gremlin_look9]
{
	self.nextthink = time + 0.2;
};

void() gremlin_look9 = [98, gremlin_run1]
{
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
	}
};

void() gremlin_glook1 = [141, gremlin_glook2]
{
};

void() gremlin_glook2 = [142, gremlin_glook3]
{
};

void() gremlin_glook3 = [143, gremlin_glook4]
{
};

void() gremlin_glook4 = [144, gremlin_glook5]
{
};

void() gremlin_glook5 = [145, gremlin_glook6]
{
};

void() gremlin_glook6 = [146, gremlin_glook7]
{
};

void() gremlin_glook7 = [147, gremlin_glook8]
{
};

void() gremlin_glook8 = [148, gremlin_glook9]
{
};

void() gremlin_glook9 = [149, gremlin_glook10]
{
};

void() gremlin_glook10 = [150, gremlin_glook11]
{
};

void() gremlin_glook11 = [151, gremlin_glook12]
{
};

void() gremlin_glook12 = [152, gremlin_glook13]
{
};

void() gremlin_glook13 = [153, gremlin_glook14]
{
};

void() gremlin_glook14 = [154, gremlin_glook15]
{
};

void() gremlin_glook15 = [155, gremlin_glook16]
{
};

void() gremlin_glook16 = [156, gremlin_glook17]
{
};

void() gremlin_glook17 = [157, gremlin_glook18]
{
};

void() gremlin_glook18 = [158, gremlin_glook19]
{
};

void() gremlin_glook19 = [159, gremlin_glook20]
{
};

void() gremlin_glook20 = [160, gremlin_glook20]
{
	GremlinDropBackpack();
	self.stoleweapon = 0;
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
	}
};

void() gremlin_pain1 = [100, gremlin_pain2]
{
	ai_back(MOVETYPE_STEP);
};

void() gremlin_pain2 = [101, gremlin_pain3]
{
	ai_back(MOVETYPE_STEP);
};

void() gremlin_pain3 = [102, gremlin_pain4]
{
	ai_back(FL_SWIM);
};

void() gremlin_pain4 = [103, gremlin_run1]
{
};

void() gremlin_gunpain1 = [161, gremlin_gunpain2]
{
	ai_back(MOVETYPE_STEP);
};

void() gremlin_gunpain2 = [162, gremlin_gunpain3]
{
	ai_back(FL_SWIM);
};

void() gremlin_gunpain3 = [163, gremlin_run1]
{
};

void(entity attacker, float damage) gremlin_pain = 
{
	local float r;
	if (random() < 0.8)
	{
		self.gorging = 0;
		self.enemy = attacker;
		FoundTarget();
	}
	if (self.touch == Gremlin_JumpTouch)
	{
		return;
	}
	if (self.pain_finished > time)
	{
		return;
	}
	self.pain_finished = time + 1;
	r = random();
	if (r < 0.33)
	{
		sound(self, CHAN_VOICE, "grem/pain1.wav", 1, ATTN_NORM);
	}
	else
	{
		if (r < 0.66)
		{
			sound(self, CHAN_VOICE, "grem/pain2.wav", 1, ATTN_NORM);
		}
		else
		{
			sound(self, CHAN_VOICE, "grem/pain3.wav", 1, ATTN_NORM);
		}
	}
	if (self.stoleweapon)
	{
		gremlin_gunpain1();
	}
	else
	{
		gremlin_pain1();
	}
};

void() gremlin_spawn1 = [84, gremlin_spawn2]
{
	self.nextthink = time + 0.3;
	self.th_pain = SUB_Null;
};

void() gremlin_spawn2 = [85, gremlin_spawn3]
{
	self.nextthink = time + 0.3;
};

void() gremlin_spawn3 = [86, gremlin_spawn4]
{
	self.nextthink = time + 0.3;
};

void() gremlin_spawn4 = [87, gremlin_spawn5]
{
	self.nextthink = time + 0.3;
};

void() gremlin_spawn5 = [88, gremlin_spawn6]
{
	self.nextthink = time + 0.3;
};

void() gremlin_spawn6 = [89, gremlin_run1]
{
	self.th_pain = gremlin_pain;
};

void() gremlin_die1 = [104, gremlin_die2]
{
	sound(self, CHAN_VOICE, "grem/death.wav", 1, ATTN_NORM);
};

void() gremlin_die2 = [105, gremlin_die3]
{
	ai_forward(FL_SWIM);
};

void() gremlin_die3 = [106, gremlin_die4]
{
	ai_forward(1);
};

void() gremlin_die4 = [107, gremlin_die5]
{
	ai_forward(FL_SWIM);
};

void() gremlin_die5 = [108, gremlin_die6]
{
	ai_forward(1);
};

void() gremlin_die6 = [109, gremlin_die7]
{
	self.solid = SOLID_NOT;
};

void() gremlin_die7 = [110, gremlin_die8]
{
	ai_forward(FL_SWIM);
};

void() gremlin_die8 = [111, gremlin_die9]
{
	ai_forward(1);
};

void() gremlin_die9 = [112, gremlin_die10]
{
	ai_forward(FL_SWIM);
};

void() gremlin_die10 = [113, gremlin_die11]
{
	ai_forward(1);
};

void() gremlin_die11 = [114, gremlin_die12]
{
	ai_forward(FL_SWIM);
};

void() gremlin_die12 = [115, gremlin_die12]
{
};

void() gremlin_gib = 
{
	sound(self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
	ThrowHead("progs/h_grem.mdl", -35);
	ThrowGib("progs/gib1.mdl", -35);
	ThrowGib("progs/gib1.mdl", -35);
	ThrowGib("progs/gib1.mdl", -35);
};

void() gremlin_flip1 = [116, gremlin_flip2]
{
	ai_face();
	makevectors(self.angles);
	self.origin_z = self.origin_z + 1;
	self.velocity = '0 0 350' - v_forward * MAX_CHARMER_DISTANCE;
	if (self.flags & FL_ONGROUND)
	{
		self.flags = self.flags - FL_ONGROUND;
	}
	sound(self, CHAN_VOICE, "grem/death.wav", 1, ATTN_NORM);
};

void() gremlin_flip2 = [117, gremlin_flip3]
{
	ai_face();
};

void() gremlin_flip3 = [118, gremlin_flip4]
{
};

void() gremlin_flip4 = [119, gremlin_flip5]
{
};

void() gremlin_flip5 = [120, gremlin_flip6]
{
};

void() gremlin_flip6 = [121, gremlin_flip7]
{
	self.touch = Gremlin_FlipTouch;
};

void() gremlin_flip7 = [122, gremlin_gib]
{
	self.nextthink = time + MOVETYPE_WALK;
};

void() gremlin_flip8 = [123, gremlin_flip8]
{
	self.solid = SOLID_NOT;
};

void() GremlinDropBackpack = 
{
	local entity item;
	item = spawn();
	item.origin = self.origin - '0 0 24';
	self.items = self.items - (self.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS));
	item.items = self.items;
	if (item.items & IT_AXE)
	{
		item.netname = "Axe";
	}
	else
	{
		if (item.items & IT_SHOTGUN)
		{
			item.netname = "Shotgun";
		}
		else
		{
			if (item.items & IT_SUPER_SHOTGUN)
			{
				item.netname = "Double-barrelled Shotgun";
			}
			else
			{
				if (item.items & IT_NAILGUN)
				{
					item.netname = "Nailgun";
				}
				else
				{
					if (item.items & IT_SUPER_NAILGUN)
					{
						item.netname = "Super Nailgun";
					}
					else
					{
						if (item.items & IT_GRENADE_LAUNCHER)
						{
							item.netname = "Grenade Launcher";
						}
						else
						{
							if (item.items & IT_ROCKET_LAUNCHER)
							{
								item.netname = "Rocket Launcher";
							}
							else
							{
								if (item.items & IT_LIGHTNING)
								{
									item.netname = "Thunderbolt";
								}
								else
								{
									if (item.items & IT_LASER_CANNON)
									{
										item.netname = "Laser Cannon";
									}
									else
									{
										if (item.items & IT_PROXIMITY_GUN)
										{
											item.netname = "Proximity Gun";
										}
										else
										{
											if (item.items & IT_MJOLNIR)
											{
												item.netname = "Mjolnir";
											}
											else
											{
												item.netname = "";
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
	item.ammo_shells = self.ammo_shells;
	item.ammo_nails = self.ammo_nails;
	item.ammo_rockets = self.ammo_rockets;
	item.ammo_cells = self.ammo_cells;
	if (item.ammo_shells < 0)
	{
		item.ammo_shells = 0;
	}
	if (item.ammo_nails < 0)
	{
		item.ammo_nails = 0;
	}
	if (item.ammo_rockets < 0)
	{
		item.ammo_rockets = 0;
	}
	if (item.ammo_cells < 0)
	{
		item.ammo_cells = 0;
	}
	item.velocity_z = 300;
	item.velocity_x = -100 + random() * MAX_CHARMER_DISTANCE;
	item.velocity_y = -100 + random() * MAX_CHARMER_DISTANCE;
	item.flags = FL_ITEM;
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_TOSS;
	setmodel(item, "progs/backpack.mdl");
	setsize(item, '-16 -16 0', '16 16 56');
	item.touch = BackpackTouch;
	item.nextthink = time + TOOCLOSE_CHARMER_DISTANCE;
	item.think = SUB_Remove;
};

void() gremlin_die = 
{
	local vector vec;
	local float dot;
	if (self.items & (IT_SUPER_SHOTGUN | IT_NAILGUN | IT_SUPER_NAILGUN | IT_GRENADE_LAUNCHER | IT_ROCKET_LAUNCHER | IT_LIGHTNING | IT_LASER_CANNON | IT_PROXIMITY_GUN))
	{
		GremlinDropBackpack();
		self.stoleweapon = 0;
	}
	makevectors(self.angles);
	vec = normalize(damage_attacker.origin - self.origin);
	dot = vec * v_forward;
	if (self.health < -35)
	{
		sound(self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		ThrowHead("progs/h_grem.mdl", self.health);
		ThrowGib("progs/gib1.mdl", self.health);
		ThrowGib("progs/gib1.mdl", self.health);
		ThrowGib("progs/gib1.mdl", self.health);
		return;
	}
	else
	{
		if (dot > 0.7 && random() < 0.5 && (self.flags & FL_ONGROUND))
		{
			gremlin_flip1();
			return;
		}
	}
	gremlin_die1();
};

void() Gremlin_MeleeAttack = 
{
	local float num;
	if (self.gorging)
	{
		gremlin_gorge1();
	}
	else
	{
		if (self.stoleweapon == 1)
		{
			objerror("gremlin meleeing with stolen weapon");
		}
		else
		{
			if (self.enemy.flags & FL_CLIENT && random() < 0.4)
			{
				if (GremlinAttemptWeaponSteal())
				{
					return;
				}
			}
		}
		num = random();
		if (num < 0.3)
		{
			gremlin_claw1();
		}
		else
		{
			if (num < 0.6)
			{
				gremlin_lunge1();
			}
			else
			{
				gremlin_claw1();
			}
		}
	}
};

float() GremlinCheckNoAmmo = 
{
	if (self.currentammo > 0)
	{
		return 1;
	}
	else
	{
		self.stoleweapon = 0;
		return 0;
	}
};

entity() GremlinFindVictim = 
{
	local entity head;
	local entity selected;
	local float dist;
	local float head_dist;
	local float decision;
	self.search_time = time + 1;
	selected = world;
	dist = 1000;
	head = findradius(self.origin, 1000);
	while (head)
	{
		if (!(head.flags & FL_NOTARGET) && (head.flags & FL_MONSTER || (head.flags & FL_CLIENT)))
		{
			visible(head);
			if (visible(head) && head.health > 0 && head != self)
			{
				head_dist = vlen(head.origin - self.origin);
				if (head == self.lastvictim)
				{
					head_dist = head_dist * FL_SWIM;
				}
				if (head.flags & FL_CLIENT)
				{
					head_dist = head_dist / 1.5;
				}
				if (head.classname == self.classname)
				{
					head_dist = head_dist * 1.5;
				}
				if (head_dist < dist)
				{
					selected = head;
					dist = head_dist;
				}
			}
		}
		head = head.chain;
	}
	self.lastvictim = selected;
	return selected;
};

void() Gremlin_FireRocket = 
{
	local entity missile;
	local entity mpuff;
	local vector dir;
	self.ammo_rockets = self.ammo_rockets - 1;
	self.currentammo = self.ammo_rockets - 1;
	self.effects = self.effects | EF_MUZZLEFLASH;
	sound(self, CHAN_WEAPON, "weapons/sgun1.wav", 1, ATTN_NORM);
	self.punchangle_x = CONTENT_SOLID;
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "missile";
	dir = normalize(self.enemy.origin - self.origin);
	self.v_angle = vectoangles(dir);
	makevectors(self.v_angle);
	dir = dir + crandom() * GYRO_TURBULENCEMOD_AIR * v_right + crandom() * GYRO_TURBULENCEMOD_AIR * v_up;
	missile.velocity = normalize(dir);
	missile.velocity = missile.velocity * 1000;
	missile.angles = vectoangles(missile.velocity);
	missile.touch = T_MissileTouch;
	missile.nextthink = time + MOVETYPE_FLY;
	missile.think = SUB_Remove;
	setmodel(missile, "progs/missile.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, self.origin + v_forward * FL_CLIENT + '0 0 16');
};

void(float ox) Gremlin_FireNailGun = 
{
	local vector dir;
	self.ammo_nails = self.ammo_nails - 1;
	self.currentammo = self.ammo_nails - 1;
	self.effects = self.effects | EF_MUZZLEFLASH;
	sound(self, CHAN_WEAPON, "weapons/rocket1i.wav", 1, ATTN_NORM);
	dir = normalize(self.enemy.origin - self.origin);
	self.v_angle = vectoangles(dir);
	makevectors(self.v_angle);
	dir = dir + crandom() * GYRO_TURBULENCEMOD_AIR * v_right + crandom() * GYRO_TURBULENCEMOD_AIR * v_up;
	dir = normalize(dir);
	launch_spike(self.origin + '0 0 16', dir);
};

void(float ox) Gremlin_FireLaserGun = 
{
	local vector dir;
	self.ammo_cells = self.ammo_cells - 1;
	self.currentammo = self.ammo_cells - 1;
	self.effects = self.effects | EF_MUZZLEFLASH;
	sound(self, CHAN_WEAPON, "weapons/rocket1i.wav", 1, ATTN_NORM);
	dir = normalize(self.enemy.origin - self.origin);
	self.v_angle = vectoangles(dir);
	makevectors(self.v_angle);
	dir = dir + crandom() * GYRO_TURBULENCEMOD_AIR * v_right + crandom() * GYRO_TURBULENCEMOD_AIR * v_up;
	dir = normalize(dir);
	HIP_LaunchLaser(self.origin + '0 0 16', dir, 0);
};

void() Gremlin_FireShotGun = 
{
	local vector dir;
	self.ammo_shells = self.ammo_shells - 1;
	self.currentammo = self.ammo_shells - 1;
	self.effects = self.effects | EF_MUZZLEFLASH;
	sound(self, CHAN_WEAPON, "weapons/guncock.wav", 1, ATTN_NORM);
	dir = normalize(self.enemy.origin - self.origin);
	self.v_angle = vectoangles(dir);
	makevectors(self.v_angle);
	dir = dir + crandom() * GYRO_TURBULENCEMOD_AIR * v_right + crandom() * GYRO_TURBULENCEMOD_AIR * v_up;
	dir = normalize(dir);
	self.v_angle = vectoangles(dir);
	FireBullets(MOVETYPE_TOSS, dir, '0.040000 0.040000 0');
};

void() Gremlin_FireSuperShotGun = 
{
	local vector dir;
	self.ammo_shells = self.ammo_shells - FL_SWIM;
	self.currentammo = self.ammo_shells - FL_SWIM;
	self.effects = self.effects | EF_MUZZLEFLASH;
	sound(self, CHAN_WEAPON, "weapons/shotgn2.wav", 1, ATTN_NORM);
	dir = normalize(self.enemy.origin - self.origin);
	self.v_angle = vectoangles(dir);
	makevectors(self.v_angle);
	dir = dir + crandom() * 0.3 * v_right + crandom() * 0.3 * v_up;
	dir = normalize(dir);
	self.v_angle = vectoangles(dir);
	FireBullets(14, dir, '0.14 0.080000 0');
};

void() Gremlin_FireLightningGun = 
{
	local vector org;
	local vector dir;
	local float cells;
	if (self.watertype <= CONTENT_WATER)
	{
		cells = self.ammo_cells;
		self.ammo_cells = 0;
		discharged = 1;
		T_RadiusDamage(self, self, 35 * cells, world);
		discharged = 0;
		return;
	}
	self.effects = self.effects | EF_MUZZLEFLASH;
	ai_face();
	self.ammo_cells = self.ammo_cells - FL_SWIM;
	self.currentammo = self.ammo_cells - FL_SWIM;
	org = self.origin + '0 0 16';
	dir = self.enemy.origin + '0 0 16' - org;
	dir = normalize(dir);
	dir = normalize(self.enemy.origin - self.origin);
	self.v_angle = vectoangles(dir);
	makevectors(self.v_angle);
	dir = dir + crandom() * GYRO_TURBULENCEMOD_AIR * v_right + crandom() * GYRO_TURBULENCEMOD_AIR * v_up;
	dir = normalize(dir);
	traceline(org, self.origin + dir * 600, 1, self);
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_LIGHTNING2);
	WriteEntity(MSG_BROADCAST, self);
	WriteCoord(MSG_BROADCAST, org_x);
	WriteCoord(MSG_BROADCAST, org_y);
	WriteCoord(MSG_BROADCAST, org_z);
	WriteCoord(MSG_BROADCAST, trace_endpos_x);
	WriteCoord(MSG_BROADCAST, trace_endpos_y);
	WriteCoord(MSG_BROADCAST, trace_endpos_z);
	LightningDamage(org, trace_endpos + dir * MOVETYPE_STEP, self, SVC_INTERMISSION);
};

void() GremlinFireProximityGrenade = 
{
	local entity missile;
	local vector dir;
	NumProximityGrenades = NumProximityGrenades + 1;
	self.ammo_rockets = self.ammo_rockets - 1;
	self.currentammo = self.ammo_rockets - 1;
	sound(self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);
	missile = spawn();
	missile.owner = self;
	missile.lastvictim = self;
	missile.movetype = MOVETYPE_TOSS;
	missile.solid = SOLID_BBOX;
	missile.classname = "proximity_grenade";
	missile.takedamage = DAMAGE_NO;
	missile.health = MOVETYPE_FLY;
	missile.state = 0;
	dir = normalize(self.enemy.origin - self.origin);
	self.v_angle = vectoangles(dir);
	makevectors(self.v_angle);
	dir = dir + crandom() * GYRO_TURBULENCEMOD_AIR * v_right + crandom() * GYRO_TURBULENCEMOD_AIR * v_up;
	dir = normalize(dir);
	missile.velocity = dir * 600;
	missile.velocity_z = MAX_CHARMER_DISTANCE;
	missile.avelocity = '100 600 100';
	missile.angles = vectoangles(missile.velocity);
	missile.touch = ProximityGrenadeTouch;
	missile.nextthink = time + FL_SWIM;
	missile.delay = time + 15 + MOVETYPE_BOUNCE * random();
	missile.think = ProximityBomb;
	missile.th_die = ProximityGrenadeExplode;
	setmodel(missile, "progs/proxbomb.mdl");
	setorigin(missile, self.origin);
	setsize(missile, '-1 -1 -1', '1 1 1');
};

float() GremlinWeaponAttack = 
{
	local float r;
	local entity targ;
	local vector vec;
	if (!GremlinCheckNoAmmo())
	{
		return 0;
	}
	self.show_hostile = time + 1;
	if (self.weapon == IT_SHOTGUN)
	{
		gremlin_shot1();
		Gremlin_FireShotGun();
		SUB_AttackFinished(1);
	}
	else
	{
		if (self.weapon == IT_SUPER_SHOTGUN)
		{
			gremlin_shot1();
			Gremlin_FireSuperShotGun();
			SUB_AttackFinished(1);
		}
		else
		{
			if (self.weapon == IT_NAILGUN)
			{
				gremlin_nail3();
				SUB_AttackFinished(1);
			}
			else
			{
				if (self.weapon == IT_SUPER_NAILGUN)
				{
					gremlin_nail3();
					SUB_AttackFinished(1);
				}
				else
				{
					if (self.weapon == IT_GRENADE_LAUNCHER)
					{
						gremlin_rocket1();
						OgreFireGrenade();
						self.ammo_rockets = self.ammo_rockets - 1;
						self.currentammo = self.ammo_rockets - 1;
						SUB_AttackFinished(1);
					}
					else
					{
						if (self.weapon == IT_ROCKET_LAUNCHER)
						{
							gremlin_rocket1();
							Gremlin_FireRocket();
							SUB_AttackFinished(1);
						}
						else
						{
							if (self.weapon == IT_LIGHTNING)
							{
								gremlin_light1();
								SUB_AttackFinished(1);
								sound(self, CHAN_AUTO, "weapons/lstart.wav", 1, ATTN_NORM);
							}
							else
							{
								if (self.weapon == IT_LASER_CANNON)
								{
									gremlin_laser3();
									SUB_AttackFinished(1);
								}
								else
								{
									if (self.weapon == IT_PROXIMITY_GUN)
									{
										gremlin_rocket1();
										GremlinFireProximityGrenade();
										SUB_AttackFinished(1);
									}
								}
							}
						}
					}
				}
			}
		}
	}
	return 1;
};

void() Gremlin_MissileAttack = 
{
	if (self.stoleweapon)
	{
		if (GremlinWeaponAttack())
		{
			return;
		}
		else
		{
			if (random() < GYRO_TURBULENCEMOD_AIR && (self.flags & FL_ONGROUND))
			{
				gremlin_jump1();
				return;
			}
		}
	}
	if (self.flags & FL_ONGROUND)
	{
		gremlin_jump1();
	}
};

void() monster_gremlin = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	NumGremlins = NumGremlins + 1;
	precache_model("progs/grem.mdl");
	precache_model("progs/h_grem.mdl");
	precache_sound("grem/death.wav");
	precache_sound("grem/attack.wav");
	precache_sound("demon/djump.wav");
	precache_sound("demon/dhit2.wav");
	precache_sound("grem/pain1.wav");
	precache_sound("grem/pain2.wav");
	precache_sound("grem/pain3.wav");
	precache_sound("grem/idle.wav");
	precache_sound("grem/sight1.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/grem.mdl");
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.health = 100;
	self.max_health = 101;
	self.yaw_speed = 40;
	self.th_stand = gremlin_stand1;
	self.th_walk = gremlin_walk1;
	self.th_run = gremlin_run1;
	self.th_die = gremlin_die;
	self.th_melee = Gremlin_MeleeAttack;
	self.th_missile = Gremlin_MissileAttack;
	self.th_pain = gremlin_pain;
	walkmonster_start();
};

float() GremlinCheckAttack = 
{
	local vector spot1;
	local vector spot2;
	local entity targ;
	local float chance;
	targ = self.enemy;
	if (time < self.attack_finished)
	{
		return 0;
	}
	spot1 = self.origin;
	spot2 = targ.origin;
	if (vlen(spot2 - spot1) <= 90 && self.stoleweapon == 0)
	{
		self.attack_state = AS_MELEE;
		return 1;
	}
	chance = 0.030000 + self.stoleweapon;
	if (random() < chance)
	{
		self.attack_state = AS_MISSILE;
		return 1;
	}
	return 0;
};

void(float side) Gremlin_Melee = 
{
	local float ldmg;
	local vector delta;
	ai_face();
	delta = self.enemy.origin - self.origin;
	if (vlen(delta) > 100)
	{
		return;
	}
	if (!CanDamage(self.enemy, self))
	{
		return;
	}
	sound(self, CHAN_WEAPON, "grem/attack.wav", 1, ATTN_NORM);
	ldmg = MOVETYPE_BOUNCE + MOVETYPE_FLY * random();
	T_Damage(self.enemy, self, self, ldmg);
	makevectors(self.angles);
	SpawnMeatSpray(self.origin + v_forward * FL_INWATER, side * v_right);
};

void(float dm) Gremlin_ThrowHead = 
{
	local string gibname;
	if (self.classname == "monster_ogre")
	{
		gibname = "progs/h_ogre.mdl";
	}
	else
	{
		if (self.classname == "monster_knight")
		{
			gibname = "progs/h_knight.mdl";
		}
		else
		{
			if (self.classname == "monster_shambler")
			{
				gibname = "progs/h_shams.mdl";
			}
			else
			{
				if (self.classname == "monster_demon1")
				{
					gibname = "progs/h_demon.mdl";
				}
				else
				{
					if (self.classname == "monster_wizard")
					{
						gibname = "progs/h_wizard.mdl";
					}
					else
					{
						if (self.classname == "monster_zombie")
						{
							gibname = "progs/h_zombie.mdl";
						}
						else
						{
							if (self.classname == "monster_dog")
							{
								gibname = "progs/h_dog.mdl";
							}
							else
							{
								if (self.classname == "monster_hell_knight")
								{
									gibname = "progs/h_hellkn.mdl";
								}
								else
								{
									if (self.classname == "monster_enforcer")
									{
										gibname = "progs/h_mega.mdl";
									}
									else
									{
										if (self.classname == "monster_army")
										{
											gibname = "progs/h_guard.mdl";
										}
										else
										{
											if (self.classname == "monster_shalrath")
											{
												gibname = "progs/h_shal.mdl";
											}
											else
											{
												if (self.classname == "monster_gremlin")
												{
													gibname = "progs/h_grem.mdl";
												}
												else
												{
													if (self.classname == "monster_scourge")
													{
														gibname = "progs/h_scourg.mdl";
													}
													else
													{
														if (self.classname == "monster_fish")
														{
															gibname = "progs/gib1.mdl";
														}
														else
														{
															gibname = "progs/h_player.mdl";
														}
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
	ThrowHead(gibname, dm);
};

void(entity targ, entity inflictor, entity attacker, float damage) Gremlin_Damage = 
{
	if (targ.flags & FL_GODMODE)
	{
		return;
	}
	if (targ.invincible_finished >= time)
	{
		if (self.invincible_sound < time)
		{
			sound(targ, CHAN_ITEM, "items/protect3.wav", 1, ATTN_NORM);
			self.invincible_sound = time + FL_SWIM;
		}
		return;
	}
	if (teamplay == 1 && targ.team > 0 && targ.team == attacker.team)
	{
		return;
	}
	targ.health = targ.health - damage;
};

void() Gremlin_Split = 
{
	local entity grem;
	local entity temp;
	local entity head;
	local float done;
	local vector ang;
	local float c;
	local vector pos;
	local float proceed;
	if (NumSpawnGremlins >= NumGremlins * FL_SWIM)
	{
		return;
	}
	done = 0;
	c = 0;
	ang = self.angles;
	while (done == 0)
	{
		makevectors(ang);
		pos = self.origin + 80 * v_forward;
		head = findradius(pos, 35);
		proceed = 1;
		while (head)
		{
			if (head.health > 0 && (head.flags & (FL_MONSTER | FL_CLIENT)))
			{
				proceed = 0;
			}
			head = head.chain;
		}
		traceline(self.origin, pos, 0, self);
		if (trace_fraction == 1 && proceed == 1)
		{
			traceline(self.origin, pos - '40 40 0', 0, self);
			if (trace_fraction == 1)
			{
				traceline(self.origin, pos + '40 40 0', 0, self);
				if (trace_fraction == 1)
				{
					traceline(self.origin, pos + '0 0 64', 0, self);
					if (trace_fraction == 1)
					{
						traceline(self.origin, pos - '0 0 64', 0, self);
						if (trace_fraction != 1)
						{
							done = 1;
						}
					}
				}
			}
		}
		if (done == 0)
		{
			ang_y = ang_y + 36;
			c = c + 1;
			if (c == MOVETYPE_BOUNCE)
			{
				return;
			}
		}
	}
	NumSpawnGremlins = NumSpawnGremlins + 1;
	grem = spawn();
	SUB_CopyEntity(self, grem);
	grem.solid = SOLID_SLIDEBOX;
	grem.movetype = MOVETYPE_STEP;
	setmodel(grem, "progs/grem.mdl");
	setsize(grem, VEC_HULL_MIN, VEC_HULL_MAX);
	if (self.health < 100)
	{
		self.health = 100;
	}
	grem.health = self.health / FL_SWIM;
	self.health = self.health / FL_SWIM;
	grem.stoleweapon = 0;
	grem.items = 0;
	total_monsters = total_monsters + 1;
	WriteByte(MSG_BROADCAST, SVC_UPDATESTAT);
	WriteByte(MSG_BROADCAST, STAT_TOTALMONSTERS);
	WriteLong(MSG_BROADCAST, total_monsters);
	setorigin(grem, pos);
	temp = self;
	self = grem;
	gremlin_spawn1();
	self.enemy = world;
	self.gorging = 0;
	self = temp;
};

void(float side) Gremlin_Gorge = 
{
	local float ldmg;
	local vector delta;
	local entity temp;
	delta = self.enemy.origin - self.origin;
	sound(self, CHAN_WEAPON, "demon/dhit2.wav", 1, ATTN_NORM);
	ldmg = MOVETYPE_PUSH + MOVETYPE_FLY * random();
	Gremlin_Damage(self.enemy, self, self, ldmg);
	makevectors(self.angles);
	SpawnMeatSpray(self.origin + v_forward * FL_INWATER, side * v_right);
	if (self.enemy.health < -200)
	{
		if (self.enemy.gorging == 0)
		{
			self.enemy.gorging = 1;
			sound(self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
			temp = self;
			self = self.enemy;
			Gremlin_ThrowHead(-15);
			self = temp;
			ldmg = MIN_CHARMER_DISTANCE + 100 * random();
			T_Heal(self, ldmg, 0);
			Gremlin_Split();
		}
		self.enemy = world;
		self.gorging = 0;
		gremlin_look1();
	}
};

void() Gremlin_JumpTouch = 
{
	local float ldmg;
	if (self.health <= 0)
	{
		return;
	}
	if (!checkbottom(self))
	{
		if (self.flags & FL_ONGROUND)
		{
			self.touch = SUB_Null;
			self.think = gremlin_jump1;
			self.nextthink = time + GYRO_TURBULENCEMOD_AIR;
		}
		return;
	}
	self.touch = SUB_Null;
	self.think = gremlin_jump12;
	self.nextthink = time + GYRO_TURBULENCEMOD_AIR;
};

void() Gremlin_FlipTouch = 
{
	local float ldmg;
	if (!checkbottom(self))
	{
		if (self.flags & FL_ONGROUND)
		{
			self.touch = SUB_Null;
			self.think = gremlin_flip1;
			self.nextthink = time + GYRO_TURBULENCEMOD_AIR;
		}
		return;
	}
	self.touch = SUB_Null;
	self.think = gremlin_flip8;
	self.nextthink = time + GYRO_TURBULENCEMOD_AIR;
};

