void(entity player_ent) Chase_cam_setweapon = 
{
	local entity e;
	e = self;
	self = player_ent;
	if (self.dest2_x & CHSCAM_ON)
	{
		self.weaponmodel = "";
	}
	else
	{
		W_SetCurrentAmmo();
	}
	self = e;
};

void(entity cam_owner, vector vpos) Start_chase_cam = 
{
	local entity chase_cam;
	stuffcmd(cam_owner, "fov 80\n");
	chase_cam = spawn();
	chase_cam.owner = cam_owner;
	chase_cam.owner.dest2_x = chase_cam.owner.dest2_x | CHSCAM_ON;
	chase_cam.solid = SOLID_NOT;
	chase_cam.movetype = MOVETYPE_FLY;
	chase_cam.angles = chase_cam.owner.angles;
	setmodel(chase_cam, "progs/eyes.mdl");
	setsize(chase_cam, VEC_ORIGIN, VEC_ORIGIN);
	if (vpos == VEC_ORIGIN)
	{
		setorigin(chase_cam, chase_cam.owner.origin + '0 0 22');
	}
	else
	{
		setorigin(chase_cam, vpos);
	}
	chase_cam.classname = "chase_cam";
	chase_cam.nextthink = time + 0.1;
	chase_cam.think = Keep_cam_chasing_owner;
	chase_cam.owner.view_ofs_z = CONTENT_EMPTY;
	msg_entity = cam_owner;
	WriteByte(MSG_ONE, SVC_SETVIEWPORT);
	WriteEntity(MSG_ONE, chase_cam);
	Chase_cam_setweapon(cam_owner);
	chase_cam.ammo_shells = cam_owner.dest2_y / IQ_HIGH;
};

void() Reable_chase_cam = 
{
	self.nextthink = time + 0.1;
	if (self.owner.solid == SOLID_NOT)
	{
		self.owner.dest2_x = self.owner.dest2_x | CHSCAM_ON;
		remove(self);
		return;
	}
	if (self.owner.waterlevel)
	{
		return;
	}
	Start_chase_cam(self.owner, VEC_ORIGIN);
	remove(self);
};

void(float opt) Remove_chase_cam = 
{
	stuffcmd(self.owner, "fov 90\n");
	self.owner.dest2_x = self.owner.dest2_x - (self.owner.dest2_x & CHSCAM_ON);
	msg_entity = self.owner;
	WriteByte(MSG_ONE, SVC_SETVIEWPORT);
	WriteEntity(MSG_ONE, self.owner);
	setmodel(self, "");
	self.velocity = VEC_ORIGIN;
	self.owner.view_ofs_z = 22;
	Chase_cam_setweapon(self.owner);
	if (!opt)
	{
		self.nextthink = time + 0.1;
		self.think = Reable_chase_cam;
	}
	else
	{
		remove(self);
	}
};

void() Keep_cam_chasing_owner = 
{
	local vector vtmp1;
	local vector vtmp2;
	local vector owner_vec;
	local vector goal;
	local vector dir;
	local float dist;
	local float cap;
	local float f_f;
	self.nextthink = time + 0.1;
	if (!(self.owner.dest2_x & CHSCAM_ON))
	{
		Remove_chase_cam(1);
		return;
	}
	if (self.owner.solid == SOLID_NOT)
	{
		stuffcmd(self.owner, "fov 90\n");
		msg_entity = self.owner;
		WriteByte(MSG_ONE, SVC_SETVIEWPORT);
		WriteEntity(MSG_ONE, self.owner);
		remove(self);
		return;
	}
	if (self.owner.waterlevel)
	{
		Remove_chase_cam(0);
		return;
	}
	owner_vec = self.owner.origin + '0 0 22';
	dir_y = self.owner.v_angle_y;
	makevectors(dir);
	f_f = vlen(v_forward * 320 - self.owner.velocity);
	dir = v_forward;
	self.ammo_shells = self.ammo_shells + 4.5;
	if (self.ammo_shells > self.owner.dest2_y)
	{
		self.ammo_shells = self.owner.dest2_y;
	}
	makevectors(self.owner.v_angle);
	goal = owner_vec - v_forward * self.ammo_shells;
	goal_z = goal_z + 14 + self.ammo_shells * self.owner.dest2_z;
	if (self.owner.v_angle_x > MSG_BROADCAST)
	{
		cap = self.owner.v_angle_x;
		if (cap > 56)
		{
			cap = 56;
		}
		goal = goal + dir * cap;
		goal_z = goal_z - self.owner.v_angle_x * (self.ammo_shells * 0.010000);
		cap = self.owner.origin_z + SVC_FOUNDSECRET;
		if (goal_z < cap)
		{
			goal_z = cap;
		}
	}
	if (goal_z < owner_vec_z)
	{
		vtmp1 = goal;
		vtmp1_z = MSG_BROADCAST;
		vtmp2 = owner_vec;
		vtmp2_z = MSG_BROADCAST;
		cap = vlen(vtmp1 - vtmp2);
		if (cap < 100)
		{
			goal_z = goal_z + (100 - cap) * 0.6;
			if (goal_z > owner_vec_z)
			{
				goal_z = owner_vec_z;
			}
		}
	}
	traceline(owner_vec, goal, 0, self.owner);
	goal = trace_endpos + v_forward * H_MEGA;
	traceline(owner_vec, owner_vec - v_forward * self.ammo_shells, 0, self.owner);
	if (trace_fraction < FIRE)
	{
		self.ammo_shells = vlen(trace_endpos - owner_vec);
		cap = fabs(self.owner.v_angle_x) - SVC_SETVIEWANGLES;
		if (cap > MSG_BROADCAST)
		{
			self.ammo_shells = self.ammo_shells + cap;
		}
	}
	traceline(self.origin, goal, 0, self.owner);
	if (trace_fraction < FIRE)
	{
		dir = normalize(goal - owner_vec);
		dist = vlen(goal - owner_vec) * 0.5;
		goal = owner_vec + dir * dist;
	}
	traceline(goal, goal + '0 0 6', 0, self.owner);
	if (trace_fraction < FIRE)
	{
		goal = trace_endpos - '0 0 6';
	}
	else
	{
		traceline(goal, goal - '0 0 6', 0, self.owner);
		if (trace_fraction < FIRE)
		{
			goal = trace_endpos + '0 0 6';
		}
	}
	self.angles = self.owner.angles;
	traceline(self.origin, owner_vec, 0, self.owner);
	if (trace_fraction == FIRE)
	{
		dir = normalize(goal - self.origin);
		dist = vlen(goal - self.origin);
		cap = dist * 0.160000;
		if (cap > 5.2)
		{
			self.velocity = dir * dist * 5.2;
		}
		else
		{
			if (cap > FIRE)
			{
				self.velocity = dir * dist * cap;
			}
			else
			{
				self.velocity = dir * dist;
			}
		}
		if (f_f > 560)
		{
			self.velocity = self.velocity * H_MEGA;
		}
		if (self.oldorigin == self.origin)
		{
			if (dist > HUD_ON)
			{
				self.ammo_nails = self.ammo_nails + FIRE;
				if (self.ammo_nails > H_MEGA)
				{
					self.ammo_nails = MSG_BROADCAST;
					self.velocity = VEC_ORIGIN;
					setorigin(self, goal);
				}
			}
			else
			{
				self.ammo_nails = MSG_BROADCAST;
			}
		}
	}
	else
	{
		self.velocity = VEC_ORIGIN;
		setorigin(self, goal);
	}
	if (self.flags & FL_ONGROUND)
	{
		self.flags = self.flags - FL_ONGROUND;
	}
	self.oldorigin = self.origin;
};

void() Toggle_chase_cam = 
{
	if (self.waterlevel)
	{
		return;
	}
	if (self.dest2_x & CHSCAM_ON)
	{
		self.dest2_x = self.dest2_x - CHSCAM_ON;
	}
	else
	{
		Start_chase_cam(self, VEC_ORIGIN);
	}
};

void() LaserTargeterTrack = 
{
	local vector src;
	self.nextthink = time + 0.05;
	if (!(self.owner.dest2_x & LASERTARG_ON))
	{
		if (self.owner.dest2_x & LASERTARG_LIT)
		{
			self.owner.dest2_x = self.owner.dest2_x | LASERTARG_ON;
			self.effects = self.effects | EF_DIMLIGHT;
		}
		else
		{
			remove(self);
			return;
		}
	}
	if (self.owner.solid == SOLID_NOT)
	{
		remove(self);
		return;
	}
	if (self.owner.weapon == IT_MJOLNIR || self.owner.weapon == IT_AXE)
	{
		if (self.model != "")
		{
			setmodel(self, "");
		}
	}
	else
	{
		if (self.model == "")
		{
			setmodel(self, "progs/null.spr");
		}
	}
	makevectors(self.owner.v_angle);
	self.angles = vectoangles(v_forward);
	src = self.owner.origin + v_forward * SVC_SETVIEWANGLES;
	src_z = self.owner.absmin_z + self.owner.size_z * 0.7;
	traceline(src, src + v_forward * IT_CELLS, 0, self.owner);
	setorigin(self, 0.1 * src + 0.9 * trace_endpos);
};

void(entity targ_owner) LaserTargeterToggle = 
{
	local entity e;
	if (targ_owner.dest2_x & LASERTARG_ON)
	{
		if (!deathmatch && !coop)
		{
			if (targ_owner.dest2_x & LASERTARG_LIT)
			{
				targ_owner.dest2_x = targ_owner.dest2_x - LASERTARG_LIT;
			}
			else
			{
				targ_owner.dest2_x = targ_owner.dest2_x | LASERTARG_LIT;
			}
		}
		targ_owner.dest2_x = targ_owner.dest2_x - LASERTARG_ON;
	}
	else
	{
		targ_owner.dest2_x = targ_owner.dest2_x | LASERTARG_ON;
		e = spawn();
		e.owner = targ_owner;
		e.movetype = MOVETYPE_NONE;
		e.solid = SOLID_NOT;
		setmodel(e, "progs/null.spr");
		setsize(e, VEC_ORIGIN, VEC_ORIGIN);
		setorigin(e, e.owner.origin);
		if (e.owner.dest2_x & LASERTARG_LIT)
		{
			e.effects = e.effects | EF_DIMLIGHT;
		}
		e.nextthink = time + 0.1;
		e.think = LaserTargeterTrack;
	}
};

void() Chase_cam_lvlstart_think = 
{
	if (self.owner.dest2_x & CHSCAM_ON)
	{
		Start_chase_cam(self.owner, VEC_ORIGIN);
	}
	if (self.owner.dest2_x & LASERTARG_ON)
	{
		self.owner.dest2_x = self.owner.dest2_x - LASERTARG_ON;
		LaserTargeterToggle(self.owner);
	}
	remove(self);
};

void() Chase_cam_level_start = 
{
	local entity e;
	e = spawn();
	e.owner = self;
	e.nextthink = time + 0.2;
	e.think = Chase_cam_lvlstart_think;
};

void(float opt) Chase_cam_change_dist = 
{
	local string s;
	if (!opt)
	{
		self.dest2_y = self.dest2_y - H_MEGA;
		if (self.dest2_y < SVC_SETVIEWANGLES)
		{
			self.dest2_y = SVC_SETVIEWANGLES;
		}
	}
	else
	{
		if (opt == FIRE)
		{
			self.dest2_y = self.dest2_y + H_MEGA;
		}
		else
		{
			self.dest2_y = cvar("temp1");
		}
	}
	sprint(self, "chasecam distance = ");
	s = ftos(self.dest2_y);
	sprint(self, s);
	sprint(self, "\n");
};

void(float opt) Chase_cam_change_zmult = 
{
	local string str;
	local float f;
	if (!opt)
	{
		self.dest2_z = self.dest2_z - 0.020000;
		if (self.dest2_z < MSG_BROADCAST)
		{
			self.dest2_z = MSG_BROADCAST;
		}
	}
	else
	{
		if (opt == FIRE)
		{
			self.dest2_z = self.dest2_z + 0.020000;
		}
		else
		{
			f = cvar("temp1");
			self.dest2_z = f * 0.010000;
		}
	}
	sprint(self, "chasecam verticle offset = ");
	f = self.dest2_z * 100;
	f = rint(f);
	str = ftos(f);
	sprint(self, str);
	sprint(self, "\n");
};

void(float opt) Chase_cam_read_temp1 = 
{
	if (!opt)
	{
		Chase_cam_change_dist(H_MEGA);
	}
	else
	{
		Chase_cam_change_zmult(H_MEGA);
	}
};

void(float opt) HUD_print_info = 
{
	local string str;
	local float cap;
	local float c;
	local float c2;
	local float c_inc;
	if (!(self.dest2_x & HUD_ON))
	{
		return;
	}
	if (opt == FIRE)
	{
		self.dest1_x = self.health;
		c2 = 15;
		if (self.ammo_shells > 9.5)
		{
			c2 = c2 - 0.5;
		}
		if (self.ammo_shells > 99.5)
		{
			c2 = c2 - 0.5;
		}
		if (self.ammo_nails > 9.5)
		{
			c2 = c2 - 0.5;
		}
		if (self.ammo_nails > 99.5)
		{
			c2 = c2 - 0.5;
		}
		if (self.ammo_rockets > 9.5)
		{
			c2 = c2 - 0.5;
		}
		if (self.ammo_rockets > 99.5)
		{
			c2 = c2 - 0.5;
		}
		if (self.ammo_cells > 9.5)
		{
			c2 = c2 - 0.5;
		}
		if (self.ammo_cells > 99.5)
		{
			c2 = c2 - 0.5;
		}
		c = MSG_BROADCAST;
		while (c < c2)
		{
			sprint(self, " ");
			c = c + FIRE;
		}
		str = ftos(self.ammo_shells);
		sprint(self, str);
		sprint(self, "é");
		str = ftos(self.ammo_nails);
		sprint(self, str);
		sprint(self, "é");
		str = ftos(self.ammo_rockets);
		sprint(self, str);
		sprint(self, "é");
		str = ftos(self.ammo_cells);
		sprint(self, str);
		if (self.armortype > 0.78)
		{
			str = "\nÉÉÉ ";
			cap = MAX_CHARMER_DISTANCE;
		}
		else
		{
			if (self.armortype > 0.580000)
			{
				str = "\nÉÉ  ";
				cap = MIN_CHARMER_DISTANCE;
			}
			else
			{
				if (self.armortype > 0.28)
				{
					str = "\nÉ   ";
					cap = 100;
				}
				else
				{
					str = "\n    ";
					cap = MSG_BROADCAST;
				}
			}
		}
		sprint(self, str);
		if (cap > 0.5)
		{
			c_inc = cap * 0.0303;
			c = c_inc;
			sprint(self, "ù");
			c2 = MSG_BROADCAST;
			while (c2 < SVC_CDTRACK)
			{
				c = c + c_inc;
				if (c < self.armorvalue)
				{
					if (c > cap - c_inc)
					{
						sprint(self, "ü");
					}
					else
					{
						sprint(self, "û");
					}
				}
				c2 = c2 + FIRE;
			}
		}
		sprint(self, "\n");
	}
	else
	{
		cap = self.dest1_x;
		self.dest1_x = self.health;
		if (self.health > 100.5 && cap == self.health + FIRE)
		{
			return;
		}
		sprint(self, "\n\n");
	}
	c = 2.777;
	cap = self.health;
	if (cap > 100 - c)
	{
		cap = 100 - c;
	}
	sprint(self, "Ä");
	while (c < cap)
	{
		sprint(self, "Å");
		c = c + 2.777;
	}
	if (self.health > 99.5)
	{
		sprint(self, "Ç");
	}
	if (opt == FIRE)
	{
		if (self.items & IT_KEY1)
		{
			sprint(self, "\nS");
		}
		else
		{
			sprint(self, "\n ");
		}
		if (self.items & IT_KEY2)
		{
			sprint(self, "G");
		}
		else
		{
			sprint(self, " ");
		}
		if (self.dest2_x & CHSCAM_ON)
		{
			if (self.weapon == IT_SHOTGUN)
			{
				str = "   Shotgun    ";
			}
			else
			{
				if (self.weapon == IT_SUPER_SHOTGUN)
				{
					str = "   Dbl Brl    ";
				}
				else
				{
					if (self.weapon == IT_NAILGUN)
					{
						str = "   Nailgun    ";
					}
					else
					{
						if (self.weapon == IT_SUPER_NAILGUN)
						{
							str = "   Sup Nailgun";
						}
						else
						{
							if (self.weapon == IT_GRENADE_LAUNCHER)
							{
								str = "   Grenades   ";
							}
							else
							{
								if (self.weapon == IT_ROCKET_LAUNCHER)
								{
									str = "   Rockets    ";
								}
								else
								{
									if (self.weapon == IT_LIGHTNING)
									{
										str = "   Lghtng Gun ";
									}
									else
									{
										if (self.weapon == IT_PROXIMITY_GUN)
										{
											str = "   Prox Gun   ";
										}
										else
										{
											if (self.weapon == IT_MJOLNIR)
											{
												str = "   Mjolnir    ";
											}
											else
											{
												if (self.weapon == IT_LASER_CANNON)
												{
													str = "   Laser      ";
												}
												else
												{
													str = "   Axe        ";
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
		else
		{
			str = "              ";
		}
		sprint(self, str);
	}
	else
	{
		sprint(self, "\n                ");
	}
	if (self.health < 100.5)
	{
		sprint(self, "\n");
	}
	else
	{
		sprint(self, "               ");
		c = 225;
		while (c > 99)
		{
			if (self.health > c)
			{
				sprint(self, "é");
			}
			else
			{
				sprint(self, " ");
			}
			c = c - 25;
		}
		sprint(self, "\n");
	}
};

void(float opt) HotKey_weapon = 
{
	local float w;
	if (self.weapon != IT_GRENADE_LAUNCHER && self.weapon != IT_ROCKET_LAUNCHER && self.weapon != IT_AXE)
	{
		self.dest_x = self.weapon;
	}
	if (opt == FIRE)
	{
		w = IT_AXE;
	}
	else
	{
		if (opt == H_MEGA)
		{
			if (!(self.items & IT_GRENADE_LAUNCHER))
			{
				return;
			}
			w = IT_GRENADE_LAUNCHER;
		}
		else
		{
			if (!(self.items & IT_ROCKET_LAUNCHER))
			{
				return;
			}
			w = IT_ROCKET_LAUNCHER;
		}
	}
	self.weapon = w;
	W_SetCurrentAmmo();
};

void() HotKey_previous_weapon = 
{
	if (!(self.dest_x))
	{
		return;
	}
	self.weapon = self.dest_x;
	W_SetCurrentAmmo();
};

void() HotKey_CycleWeaponCommand = 
{
	local float w;
	local float it;
	local float am;
	local float c;
	c = MSG_BROADCAST;
	w = self.weapon;
	it = self.items;
	self.impulse = MSG_BROADCAST;
	while (FIRE)
	{
		am = MSG_BROADCAST;
		if (w == IT_AXE)
		{
			w = IT_SHOTGUN;
			if (self.ammo_shells < FIRE)
			{
				am = FIRE;
			}
		}
		else
		{
			if (w == IT_SHOTGUN)
			{
				w = IT_SUPER_SHOTGUN;
				if (self.ammo_shells < H_MEGA)
				{
					am = FIRE;
				}
			}
			else
			{
				if (w == IT_SUPER_SHOTGUN)
				{
					w = IT_NAILGUN;
					if (self.ammo_nails < FIRE)
					{
						am = FIRE;
					}
				}
				else
				{
					if (w == IT_NAILGUN)
					{
						w = IT_SUPER_NAILGUN;
						if (self.ammo_nails < H_MEGA)
						{
							am = FIRE;
						}
					}
					else
					{
						if (w == IT_SUPER_NAILGUN)
						{
							w = IT_PROXIMITY_GUN;
							if (self.ammo_rockets < FIRE)
							{
								am = FIRE;
							}
						}
						else
						{
							if (w == IT_GRENADE_LAUNCHER)
							{
								w = IT_PROXIMITY_GUN;
								if (self.ammo_rockets < FIRE)
								{
									am = FIRE;
								}
							}
							else
							{
								if (w == IT_PROXIMITY_GUN)
								{
									w = IT_LIGHTNING;
									if (self.ammo_cells < FIRE)
									{
										am = FIRE;
									}
								}
								else
								{
									if (w == IT_ROCKET_LAUNCHER)
									{
										w = IT_LIGHTNING;
										if (self.ammo_cells < FIRE)
										{
											am = FIRE;
										}
									}
									else
									{
										if (w == IT_LIGHTNING)
										{
											w = IT_LASER_CANNON;
											if (self.ammo_cells < FIRE)
											{
												am = FIRE;
											}
										}
										else
										{
											if (w == IT_LASER_CANNON)
											{
												w = IT_MJOLNIR;
											}
											else
											{
												if (w == IT_MJOLNIR)
												{
													w = IT_SHOTGUN;
													if (self.ammo_shells < FIRE)
													{
														am = FIRE;
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
		if (it & w && am == MSG_BROADCAST)
		{
			self.weapon = w;
			W_SetCurrentAmmo();
			return;
		}
		if (c > STAT_TOTALMONSTERS)
		{
			return;
		}
		c = c + FIRE;
	}
};

void() HotKey_CycleWeaponReverseCommand = 
{
	local float w;
	local float it;
	local float am;
	local float c;
	c = MSG_BROADCAST;
	w = self.weapon;
	it = self.items;
	self.impulse = MSG_BROADCAST;
	while (FIRE)
	{
		am = MSG_BROADCAST;
		if (w == IT_MJOLNIR)
		{
			w = IT_LASER_CANNON;
			if (self.ammo_cells < FIRE)
			{
				am = FIRE;
			}
		}
		else
		{
			if (w == IT_LASER_CANNON)
			{
				w = IT_LIGHTNING;
				if (self.ammo_cells < FIRE)
				{
					am = FIRE;
				}
			}
			else
			{
				if (w == IT_LIGHTNING)
				{
					w = IT_PROXIMITY_GUN;
					if (self.ammo_rockets < FIRE)
					{
						am = FIRE;
					}
				}
				else
				{
					if (w == IT_ROCKET_LAUNCHER)
					{
						w = IT_PROXIMITY_GUN;
						if (self.ammo_rockets < FIRE)
						{
							am = FIRE;
						}
					}
					else
					{
						if (w == IT_PROXIMITY_GUN)
						{
							w = IT_SUPER_NAILGUN;
							if (self.ammo_nails < H_MEGA)
							{
								am = FIRE;
							}
						}
						else
						{
							if (w == IT_GRENADE_LAUNCHER)
							{
								w = IT_SUPER_NAILGUN;
								if (self.ammo_nails < H_MEGA)
								{
									am = FIRE;
								}
							}
							else
							{
								if (w == IT_SUPER_NAILGUN)
								{
									w = IT_NAILGUN;
									if (self.ammo_nails < FIRE)
									{
										am = FIRE;
									}
								}
								else
								{
									if (w == IT_NAILGUN)
									{
										w = IT_SUPER_SHOTGUN;
										if (self.ammo_shells < H_MEGA)
										{
											am = FIRE;
										}
									}
									else
									{
										if (w == IT_SUPER_SHOTGUN)
										{
											w = IT_SHOTGUN;
											if (self.ammo_shells < FIRE)
											{
												am = FIRE;
											}
										}
										else
										{
											if (w == IT_SHOTGUN)
											{
												w = IT_MJOLNIR;
											}
											else
											{
												if (w == IT_AXE)
												{
													w = IT_MJOLNIR;
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
		if (it & w && am == MSG_BROADCAST)
		{
			self.weapon = w;
			W_SetCurrentAmmo();
			return;
		}
		if (c > STAT_TOTALMONSTERS)
		{
			return;
		}
		c = c + FIRE;
	}
};

void() S_E_CLVLS_trigger = 
{
	if (other.classname != "player")
	{
		return;
	}
	if (other.velocity_z > 100)
	{
		changelevel_touch();
		return;
	}
	if (time < self.healamount)
	{
		return;
	}
	self.healamount = time + IQ_HIGH;
	sound(other, CHAN_AUTO, self.noise, FIRE, ATTN_NORM);
	centerprint(other, self.message);
};

void(string t_mapname, vector t_origin, string t_msg) S_E_CLVLS_makeone = 
{
	local entity e;
	local entity tmp_e;
	e = spawn();
	e.message = t_msg;
	e.map = t_mapname;
	e.spawnflags = FIRE;
	setmodel(e, "progs/g_hammer.mdl");
	setsize(self, '-16 -16 0', '16 16 56');
	setorigin(e, t_origin);
	e.noise = "misc/talk.wav";
	e.touch = S_E_CLVLS_trigger;
	tmp_e = self;
	self = e;
	StartItem();
	self = tmp_e;
};

void() S_E_CLVLS_teleto_12 = 
{
	if (other.origin_x > self.origin_x - HUD_ON && other.origin_x < self.origin_x + HUD_ON && other.origin_y > self.origin_y - HUD_ON && other.origin_y < self.origin_y + HUD_ON)
	{
		if (self.ammo_nails == MSG_BROADCAST)
		{
			self.ammo_nails = time + FIRE;
		}
		else
		{
			if (time > self.ammo_nails && self.ammo_shells == MSG_BROADCAST)
			{
				self.ammo_shells = FIRE;
				sound(other, CHAN_AUTO, "misc/talk.wav", FIRE, ATTN_NORM);
				sprint(other, "That's one small step for a man...\n");
			}
		}
	}
	if (other.origin_z > self.origin_z + 80)
	{
		other.gravity = self.gravity;
		teleport_touch();
		if (self.ammo_shells == FIRE)
		{
			sprint(other, "One giant leap for Mankind. :-)\n");
		}
		self.ammo_shells = H_MEGA;
	}
};

void() S_E_CLVLS_teletouch = 
{
	if (other.classname != "player")
	{
		return;
	}
	if (self.target == "TD_12")
	{
		S_E_CLVLS_teleto_12();
		return;
	}
	other.gravity = self.gravity;
	teleport_touch();
	if (self.target == "TD_0")
	{
		self.target = "TD_0b";
	}
	else
	{
		if (self.target == "TD_0b")
		{
			self.target = "TD_0c";
		}
		else
		{
			if (self.target == "TD_0c")
			{
				self.target = "TD_0";
			}
		}
	}
};

void(vector t_origin, string t_dest, float t_gravity) S_E_CLVLS_maketele = 
{
	local entity e;
	local entity tmp_e;
	e = spawn();
	e.classname = "trigger_teleport";
	e.target = t_dest;
	e.gravity = t_gravity;
	e.touch = S_E_CLVLS_teletouch;
	e.use = teleport_use;
	setmodel(e, "progs/horn.mdl");
	setsize(e, '-1 -1 0', '1 1 96');
	setorigin(e, t_origin);
	tmp_e = self;
	self = e;
	StartItem();
	self = tmp_e;
};

void(vector t_origin) S_E_CLVLS_make100health = 
{
	local entity e;
	local entity tmp_e;
	if (deathmatch)
	{
		return;
	}
	e = spawn();
	e.classname = "item_health";
	e.touch = health_touch;
	setmodel(e, "maps/b_bh100.bsp");
	e.noise = "items/r_item2.wav";
	e.healamount = 100;
	e.healtype = H_MEGA;
	setsize(e, '-16 -16 0', '16 16 56');
	setorigin(e, t_origin);
	tmp_e = self;
	self = e;
	StartItem();
	self = tmp_e;
};

void(string t_name, vector t_origin, vector t_mangle) S_E_CLVLS_maketeledest = 
{
	local entity e;
	e = spawn();
	e.classname = "info_teleport_destination";
	e.model = "";
	e.targetname = t_name;
	e.origin = t_origin;
	e.mangle = t_mangle;
};

void(float t_orx, float t_ory, float t_orz, vector t_angles) S_E_CLVLS_gremlin = 
{
	local entity e;
	local entity tmp_e;
	local float i;
	local float wpn;
	if (deathmatch)
	{
		return;
	}
	i = random();
	if (i < 0.15)
	{
		wpn = IT_GRENADE_LAUNCHER;
	}
	else
	{
		if (i < 0.3)
		{
			wpn = IT_NAILGUN;
		}
		else
		{
			if (i < 0.45)
			{
				wpn = IT_LASER_CANNON;
			}
			else
			{
				wpn = MSG_BROADCAST;
			}
		}
	}
	e = spawn();
	e.classname = "monster_gremlin";
	tmp_e = self;
	self = e;
	self.origin_x = t_orx;
	self.origin_y = t_ory;
	self.origin_z = t_orz;
	self.angles = t_angles;
	NumGremlins = NumGremlins + FIRE;
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
	if (wpn)
	{
		self.stoleweapon = 1;
		self.lastvictim = self;
		self.items = wpn;
		self.weapon = wpn;
		if (wpn == IT_GRENADE_LAUNCHER)
		{
			self.ammo_rockets = WEAPON_SPIKES;
			self.currentammo = self.ammo_rockets;
			self.items = self.items | IT_ROCKETS;
		}
		else
		{
			if (wpn == IT_NAILGUN)
			{
				self.ammo_nails = 25;
				self.currentammo = self.ammo_nails;
				self.items = self.items | IT_NAILS;
			}
			else
			{
				if (wpn == IT_LASER_CANNON)
				{
					self.ammo_cells = 25;
					self.currentammo = self.ammo_cells;
					self.items = self.items | IT_CELLS;
				}
			}
		}
	}
	self = tmp_e;
};

void() S_E_CLVLS_marquee = 
{
	self.nextthink = time + FIRE;
	self.ammo_shells = self.ammo_shells + FIRE;
	centerprint(self.owner, "≠ √Ë·ÛÂ„·Ì …… QuakeC mod ≠\n\n≠     for Mission Pack 1     ≠\n\n≠  written by Rob Albin  ≠");
	if (self.ammo_shells > IQ_HIGH)
	{
		remove(self);
	}
};

void() Spawn_extra_changelevels = 
{
	local float i;
	local entity e;
	if (time < SVC_SETVIEWANGLES)
	{
		e = spawn();
		e.owner = self.owner;
		e.nextthink = time + IQ_HIGH;
		e.think = S_E_CLVLS_marquee;
	}
	if (S_E_CLVLS_flag)
	{
		return;
	}
	S_E_CLVLS_flag = 1;
	S_E_CLVLS_makeone("e1m1", '1052 -940 8', "Exit to ID's episode 1");
	S_E_CLVLS_makeone("e2m1", '1107 -406 8', "Exit to ID's episode 2");
	S_E_CLVLS_makeone("e3m1", '590 -948 8', "Exit to ID's episode 3");
	S_E_CLVLS_makeone("e4m1", '503 -410 8', "Exit to ID's episode 4");
	S_E_CLVLS_maketeledest("TD_0", '-249.6 708.4 360', '0 -90 0');
	S_E_CLVLS_maketeledest("TD_0b", '220.4 318.1 216', '0 90 0');
	S_E_CLVLS_maketeledest("TD_0c", '335 1185 155', '0 90 0');
	S_E_CLVLS_maketeledest("TD_12", '1013 -705 -8', VEC_ORIGIN);
	S_E_CLVLS_maketeledest("TD_34", '618.7 -745.2 200', '0 90 0');
	S_E_CLVLS_maketele('927.8 -319.8 248', "TD_12", 0.15);
	S_E_CLVLS_maketele('1258 -890 248', "TD_34", 0.15);
	S_E_CLVLS_maketele('630 -688 8', "TD_0", FIRE);
	i = SVC_SELLSCREEN;
	while (i < 630)
	{
		S_E_CLVLS_gremlin(i, 680, 376, '0 -90 0');
		S_E_CLVLS_gremlin(i, 640, 376, '0 -90 0');
		i = i + 90;
	}
	S_E_CLVLS_make100health('112 1008 168');
};

