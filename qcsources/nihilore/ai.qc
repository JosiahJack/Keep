float(float v) anglemod = 
{
	while (v >= 360)
	{
		v = v - 360;
	}
	while (v < MSG_BROADCAST)
	{
		v = v + 360;
	}
	return v;
};

void() movetarget_f = 
{
	if (!(self.targetname))
	{
		objerror("monster_movetarget: no targetname");
	}
	self.solid = SOLID_TRIGGER;
	self.touch = t_movetarget;
	setsize(self, '-8 -8 -8', '8 8 8');
};

void() path_corner = 
{
	path_entity_setup();
	movetarget_f();
};

void() t_movetarget = 
{
	local entity temp;
	if (other.movetarget != self)
	{
		return;
	}
	if (other.enemy)
	{
		return;
	}
	temp = self;
	self = other;
	other = temp;
	if (self.classname == "monster_ogre")
	{
		sound(self, CHAN_VOICE, "ogre/ogdrag.wav", BIT_1, ATTN_IDLE);
	}
	self.goalentity = self.movetarget = find(world, targetname, other.target);
	self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
	if (!(self.movetarget))
	{
		self.pausetime = time + 999999;
		self.th_stand();
		return;
	}
};

float(entity targ) range = 
{
	local vector spot1;
	local vector spot2;
	local float r;
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;
	r = vlen(spot1 - spot2);
	if (r < 120)
	{
		return RANGE_MELEE;
	}
	if (r < 500)
	{
		return RANGE_NEAR;
	}
	if (r < 1000)
	{
		return RANGE_MID;
	}
	return RANGE_FAR;
};

float(entity targ) visible = 
{
	local vector spot1;
	local vector spot2;
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;
	traceline(spot1, spot2, 1, self);
	if (trace_inopen && trace_inwater)
	{
		return 0;
	}
	if (trace_fraction == BIT_1)
	{
		return 1;
	}
	return 0;
};

float(entity targ) infront = 
{
	local vector vec;
	local float dot;
	if (self.classname == "monster_servomech")
	{
		return ServoInfront(targ);
	}
	makevectors(self.angles);
	vec = normalize(targ.origin - self.origin);
	dot = vec * v_forward;
	if (dot > 0.3)
	{
		return 1;
	}
	return 0;
};

void() HuntTarget = 
{
	self.goalentity = self.enemy;
	self.think = self.th_run;
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	self.nextthink = time + 0.1;
	SUB_AttackFinished(BIT_1);
};

void() SightSound = 
{
	local float rsnd;
	if (self.classname == "monster_ogre")
	{
		sound(self, CHAN_VOICE, "ogre/ogwake.wav", BIT_1, ATTN_NORM);
	}
	else
	{
		if (self.classname == "monster_knight")
		{
			sound(self, CHAN_VOICE, "knight/ksight.wav", BIT_1, ATTN_NORM);
		}
		else
		{
			if (self.classname == "monster_shambler")
			{
				sound(self, CHAN_VOICE, "shambler/ssight.wav", BIT_1, ATTN_NORM);
			}
			else
			{
				if (self.classname == "monster_demon1")
				{
					sound(self, CHAN_VOICE, "demon/sight2.wav", BIT_1, ATTN_NORM);
				}
				else
				{
					if (self.classname == "monster_wizard")
					{
						sound(self, CHAN_VOICE, "wizard/wsight.wav", BIT_1, ATTN_NORM);
					}
					else
					{
						if (self.classname == "monster_zombie")
						{
							sound(self, CHAN_VOICE, "zombie/z_idle.wav", BIT_1, ATTN_NORM);
						}
						else
						{
							if (self.classname == "monster_dog")
							{
								sound(self, CHAN_VOICE, "dog/dsight.wav", BIT_1, ATTN_NORM);
							}
							else
							{
								if (self.classname == "monster_hell_knight")
								{
									sound(self, CHAN_VOICE, "hknight/sight1.wav", BIT_1, ATTN_NORM);
								}
								else
								{
									if (self.classname == "monster_tarbaby")
									{
										sound(self, CHAN_VOICE, "blob/sight1.wav", BIT_1, ATTN_NORM);
									}
									else
									{
										if (self.classname == "monster_vomit")
										{
											sound(self, CHAN_VOICE, "vomitus/v_sight1.wav", BIT_1, ATTN_NORM);
										}
										else
										{
											if (self.classname == "monster_enforcer")
											{
												rsnd = rint(random() * SVC_UPDATESTAT);
												if (rsnd == BIT_1)
												{
													sound(self, CHAN_VOICE, "enforcer/sight1.wav", BIT_1, ATTN_NORM);
												}
												else
												{
													if (rsnd == BIT_2)
													{
														sound(self, CHAN_VOICE, "enforcer/sight2.wav", BIT_1, ATTN_NORM);
													}
													else
													{
														if (rsnd == MSG_BROADCAST)
														{
															sound(self, CHAN_VOICE, "enforcer/sight3.wav", BIT_1, ATTN_NORM);
														}
														else
														{
															sound(self, CHAN_VOICE, "enforcer/sight4.wav", BIT_1, ATTN_NORM);
														}
													}
												}
											}
											else
											{
												if (self.classname == "monster_army")
												{
													sound(self, CHAN_VOICE, "soldier/sight1.wav", BIT_1, ATTN_NORM);
												}
												else
												{
													if (self.classname == "monster_shalrath")
													{
														sound(self, CHAN_VOICE, "shalrath/sight.wav", BIT_1, ATTN_NORM);
													}
													else
													{
														if (self.classname == "monster_ogrerocket")
														{
															sound(self, CHAN_VOICE, "ogre/ogwake.wav", BIT_1, ATTN_NORM);
														}
														else
														{
															if (self.classname == "monster_zombie_master")
															{
																sound(self, CHAN_VOICE, "zmaster/sight.wav", BIT_1, ATTN_NORM);
																self.currentammo = time + BIT_2;
															}
															else
															{
																if (self.classname == "monster_axzombie")
																{
																	sound(self, CHAN_VOICE, "zombie/z_idle.wav", BIT_1, ATTN_NORM);
																}
																else
																{
																	if (self.classname == "monster_turret")
																	{
																		sound(self, CHAN_VOICE, "turret/beammode.wav", BIT_1, ATTN_NORM);
																	}
																	else
																	{
																		if (self.classname == "monster_servomech")
																		{
																			sound(self, CHAN_VOICE, "mech/pow_up.wav", BIT_1, ATTN_NORM);
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
				}
			}
		}
	}
};

void() FoundTarget = 
{
	if (self.enemy.classname == "player")
	{
		sight_entity = self;
		sight_entity_time = time;
	}
	self.show_hostile = time + BIT_1;
	SightSound();
	HuntTarget();
};

float() FindTarget = 
{
	local entity client;
	local float r;
	if (self.classname == "monster_zombie" || self.classname == "monster_axzombie" && self.owner != world)
	{
		return 0;
	}
	if (sight_entity_time >= time - 0.1 && !(self.spawnflags & SVC_UPDATESTAT))
	{
		client = sight_entity;
		if (client.enemy == self.enemy)
		{
			return;
		}
	}
	else
	{
		client = checkclient();
		if (!client)
		{
			return FindMechTarget();
		}
	}
	if (client == self.enemy)
	{
		return FindMechTarget();
	}
	if (client.flags & FL_NOTARGET)
	{
		return FindMechTarget();
	}
	if (client.items & IT_INVISIBILITY)
	{
		return FindMechTarget();
	}
	if (client.apocflags & VIEW_RCAM)
	{
		return FindMechTarget();
	}
	r = range(client);
	if (r == RANGE_FAR)
	{
		return FindMechTarget();
	}
	if (!visible(client))
	{
		return FindMechTarget();
	}
	if (r == RANGE_NEAR)
	{
		if (client.show_hostile < time && !infront(client))
		{
			return FindMechTarget();
		}
	}
	else
	{
		if (r == RANGE_MID)
		{
			if (!infront(client))
			{
				return FindMechTarget();
			}
		}
	}
	self.enemy = client;
	if (self.enemy.classname != "player")
	{
		self.enemy = self.enemy.enemy;
		if (self.enemy.classname != "player")
		{
			self.enemy = world;
			return FindMechTarget();
		}
	}
	FoundTarget();
	return 1;
};

void(float dist) ai_forward = 
{
	walkmove(self.angles_y, dist);
};

void(float dist) ai_back = 
{
	walkmove(self.angles_y + 180, dist);
};

void(float dist) ai_pain = 
{
	ai_back(dist);
};

void(float dist) ai_painforward = 
{
	walkmove(self.ideal_yaw, dist);
};

void(float dist) ai_walk = 
{
	local vector mtemp;
	local float tmpflt;
	local vector tmpvec;
	movedist = dist;
	if (self.classname == "monster_dragon")
	{
		movetogoal(dist);
		return;
	}
	if (self.classname == "monster_servomech")
	{
		tmpvec = self.angles;
		self.angles = self.aiment.angles;
		tmpflt = FindTarget();
		self.angles = tmpvec;
		if (tmpflt)
		{
			return;
		}
	}
	else
	{
		if (FindTarget())
		{
			return;
		}
	}
	movetogoal(dist);
};

void() ai_stand = 
{
	local float tmpflt;
	local vector tmpvec;
	if (self.classname == "monster_servomech")
	{
		tmpvec = self.angles;
		self.angles = self.aiment.angles;
		tmpflt = FindTarget();
		self.angles = tmpvec;
		if (tmpflt)
		{
			return;
		}
	}
	else
	{
		if (FindTarget())
		{
			return;
		}
	}
	if (time > self.pausetime)
	{
		self.th_walk();
		return;
	}
};

void() ai_turn = 
{
	if (FindTarget())
	{
		return;
	}
	ChangeYaw();
};

void(vector dest3) ChooseTurn = 
{
	local vector dir;
	local vector newdir;
	dir = self.origin - dest3;
	newdir_x = trace_plane_normal_y;
	newdir_y = MSG_BROADCAST - trace_plane_normal_x;
	newdir_z = MSG_BROADCAST;
	if (dir * newdir > MSG_BROADCAST)
	{
		dir_x = MSG_BROADCAST - trace_plane_normal_y;
		dir_y = trace_plane_normal_x;
	}
	else
	{
		dir_x = trace_plane_normal_y;
		dir_y = MSG_BROADCAST - trace_plane_normal_x;
	}
	dir_z = MSG_BROADCAST;
	self.ideal_yaw = vectoyaw(dir);
};

float() FacingIdeal = 
{
	local float delta;
	delta = anglemod(self.angles_y - self.ideal_yaw);
	if (delta > 45 && delta < 315)
	{
		return 0;
	}
	return 1;
};

float() CheckAnyAttack = 
{
	if (!enemy_vis)
	{
		return;
	}
	if (self.classname == "monster_army")
	{
		return SoldierCheckAttack();
	}
	if (self.classname == "monster_ogre")
	{
		return OgreCheckAttack();
	}
	if (self.classname == "monster_shambler")
	{
		return ShamCheckAttack();
	}
	if (self.classname == "monster_demon1")
	{
		return DemonCheckAttack();
	}
	if (self.classname == "monster_dog")
	{
		return DogCheckAttack();
	}
	if (self.classname == "monster_wizard")
	{
		return WizardCheckAttack();
	}
	if (self.classname == "monster_servomech")
	{
		return ServomechCheckAttack();
	}
	return CheckAttack();
};

void() ai_run_melee = 
{
	self.ideal_yaw = enemy_yaw;
	ChangeYaw();
	if (FacingIdeal())
	{
		self.th_melee();
		self.attack_state = AS_STRAIGHT;
	}
};

void() ai_run_missile = 
{
	self.ideal_yaw = enemy_yaw;
	ChangeYaw();
	if (FacingIdeal())
	{
		self.th_missile();
		self.attack_state = AS_STRAIGHT;
	}
};

void() ai_run_slide = 
{
	local float ofs;
	self.ideal_yaw = enemy_yaw;
	ChangeYaw();
	if (self.lefty)
	{
		ofs = 90;
	}
	else
	{
		ofs = -90;
	}
	if (walkmove(self.ideal_yaw + ofs, movedist))
	{
		return;
	}
	self.lefty = BIT_1 - self.lefty;
	walkmove(self.ideal_yaw - ofs, movedist);
};

void(float dist) ai_run = 
{
	local vector delta;
	local float axis;
	local float direct;
	local float ang_rint;
	local float ang_floor;
	local float ang_ceil;
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
	self.show_hostile = time + BIT_1;
	enemy_vis = visible(self.enemy);
	if (enemy_vis)
	{
		self.search_time = time + SVC_SETVIEWPORT;
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

