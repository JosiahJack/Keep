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
		sound(self, CHAN_VOICE, "ogre/ogdrag.wav", SPAWNFLAG_SUPERSPIKE, ATTN_IDLE);
	}
	if (other.target)
	{
		self.goalentity = self.movetarget = find(world, targetname, other.target);
		self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
		if (!(self.movetarget))
		{
			self.pausetime = time + 999999;
			self.th_stand();
			return;
		}
		else
		{
			if (other.delay)
			{
				self.pausetime = time + other.delay;
				self.th_stand();
			}
		}
	}
	else
	{
		self.pausetime = time + 999999;
		self.th_stand();
		return;
	}
};

void() t_followtarget = 
{
	local entity temp;
	local vector spot1;
	local vector spot2;
	local entity targ;
	local entity client;
	if (!(other.flags & FL_MONSTER))
	{
		return;
	}
	if (other.classname == "monster_decoy")
	{
		return;
	}
	if (other.wetsuit_time > time)
	{
		return;
	}
	targ = other.enemy;
	spot1 = other.origin + other.view_ofs;
	spot2 = targ.origin + targ.view_ofs;
	traceline(spot1, spot2, 0, other);
	if (trace_fraction == SPAWNFLAG_SUPERSPIKE)
	{
		return;
	}
	if (other.enemy)
	{
		other.oldenemy = other.enemy;
		other.enemy = world;
		other.think = other.th_walk;
	}
	temp = self;
	self = other;
	other = temp;
	self.goalentity = self.movetarget = find(world, targetname, other.target);
	self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
	self.wetsuit_time = time + SPAWNFLAG_LASER;
	if (!(self.movetarget))
	{
		if (self.oldenemy != world)
		{
			self.enemy = self.oldenemy;
			FoundTarget();
			return;
		}
		else
		{
			client = checkclient();
			if (!client)
			{
				self.enemy = client;
				FoundTarget();
				return;
			}
			self.pausetime = time + 999999;
			self.th_stand();
		}
	}
};

void() followtarget_f = 
{
	self.solid = SOLID_TRIGGER;
	self.touch = t_followtarget;
	setmodel(self, self.model);
	self.movetype = MOVETYPE_NONE;
	self.modelindex = MSG_BROADCAST;
	self.model = "";
};

void() path_follow = 
{
	followtarget_f();
};

void() path_follow2 = 
{
	self.solid = SOLID_TRIGGER;
	self.touch = t_followtarget;
	setsize(self, '-8 -8 -8', '8 8 8');
};

float(entity targ) range = 
{
	local vector spot1;
	local vector spot2;
	local float r;
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;
	r = vlen(spot1 - spot2);
	if (r < TOOCLOSE_CHARMER_DISTANCE)
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
	if (trace_fraction == SPAWNFLAG_SUPERSPIKE)
	{
		visible_distance = vlen(spot2 - spot1);
		return 1;
	}
	return 0;
};

float(entity targ) infront = 
{
	local vector vec;
	local float dot;
	makevectors(self.angles);
	vec = normalize(targ.origin - self.origin);
	dot = vec * v_forward;
	if (dot > 0.3)
	{
		return 1;
	}
	return 0;
};

void() UpdateCharmerGoal = 
{
	local entity targ;
	local vector d;
	d = normalize(self.origin - self.charmer.origin);
	if (self.huntingcharmer == SPAWNFLAG_SUPERSPIKE)
	{
		targ = spawn();
		self.trigger_field = targ;
		setorigin(targ, self.charmer.origin);
		self.huntingcharmer = SPAWNFLAG_LASER;
		self.goalentity = targ;
	}
	if (self.huntingcharmer == SPAWNFLAG_LASER)
	{
		targ = self.trigger_field;
		traceline(self.origin, self.charmer.origin, 1, self);
		if (trace_fraction == SPAWNFLAG_SUPERSPIKE)
		{
			setorigin(targ, self.charmer.origin);
		}
	}
	else
	{
		targ = self.trigger_field;
		setorigin(targ, self.charmer.origin + d * 300);
	}
};

void() HuntCharmer = 
{
	self.huntingcharmer = SPAWNFLAG_SUPERSPIKE;
	UpdateCharmerGoal();
	self.think = self.th_walk;
	self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
	self.nextthink = time + 0.1;
};

void() FleeCharmer = 
{
	self.huntingcharmer = SPAWNFLAG_SUPERSPIKE;
	UpdateCharmerGoal();
	self.huntingcharmer = SVC_UPDATESTAT;
	self.think = self.th_walk;
	self.nextthink = time + 0.1;
};

void() StopHuntingCharmer = 
{
	self.goalentity = world;
	if (self.huntingcharmer > SPAWNFLAG_SUPERSPIKE)
	{
		remove(self.trigger_field);
	}
	self.huntingcharmer = MSG_BROADCAST;
	self.think = self.th_stand;
	self.nextthink = time + 0.1;
};

void() HuntTarget = 
{
	self.goalentity = self.enemy;
	self.think = self.th_run;
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	self.nextthink = time + 0.1;
	SUB_AttackFinished(SPAWNFLAG_SUPERSPIKE);
};

void() SightSound = 
{
	local float rsnd;
	if (self.classname == "monster_ogre")
	{
		sound(self, CHAN_VOICE, "ogre/ogwake.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	}
	else
	{
		if (self.classname == "monster_knight")
		{
			sound(self, CHAN_VOICE, "knight/ksight.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
		}
		else
		{
			if (self.classname == "monster_shambler")
			{
				sound(self, CHAN_VOICE, "shambler/ssight.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
			}
			else
			{
				if (self.classname == "monster_demon1")
				{
					sound(self, CHAN_VOICE, "demon/sight2.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
				}
				else
				{
					if (self.classname == "monster_wizard")
					{
						sound(self, CHAN_VOICE, "wizard/wsight.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
					}
					else
					{
						if (self.classname == "monster_zombie")
						{
							sound(self, CHAN_VOICE, "zombie/z_idle.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
						}
						else
						{
							if (self.classname == "monster_dog")
							{
								sound(self, CHAN_VOICE, "dog/dsight.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
							}
							else
							{
								if (self.classname == "monster_hell_knight")
								{
									sound(self, CHAN_VOICE, "hknight/sight1.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
								}
								else
								{
									if (self.classname == "monster_tarbaby")
									{
										sound(self, CHAN_VOICE, "blob/sight1.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
									}
									else
									{
										if (self.classname == "monster_vomit")
										{
											sound(self, CHAN_VOICE, "vomitus/v_sight1.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
										}
										else
										{
											if (self.classname == "monster_enforcer")
											{
												rsnd = rint(random() * SVC_UPDATESTAT);
												if (rsnd == SPAWNFLAG_SUPERSPIKE)
												{
													sound(self, CHAN_VOICE, "enforcer/sight1.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
												}
												else
												{
													if (rsnd == SPAWNFLAG_LASER)
													{
														sound(self, CHAN_VOICE, "enforcer/sight2.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
													}
													else
													{
														if (rsnd == MSG_BROADCAST)
														{
															sound(self, CHAN_VOICE, "enforcer/sight3.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
														}
														else
														{
															sound(self, CHAN_VOICE, "enforcer/sight4.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
														}
													}
												}
											}
											else
											{
												if (self.classname == "monster_army")
												{
													sound(self, CHAN_VOICE, "soldier/sight1.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
												}
												else
												{
													if (self.classname == "monster_shalrath")
													{
														sound(self, CHAN_VOICE, "shalrath/sight.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
													}
													else
													{
														if (self.classname == "monster_gremlin")
														{
															if (self.stoleweapon == MSG_BROADCAST)
															{
																sound(self, CHAN_VOICE, "grem/sight1.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
															}
														}
														else
														{
															if (self.classname == "monster_scourge")
															{
																sound(self, CHAN_VOICE, "scourge/sight.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
															}
															else
															{
																if (self.classname == "monster_armagon")
																{
																	sound(self, CHAN_VOICE, "armagon/sight.wav", SPAWNFLAG_SUPERSPIKE, 0.1);
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
		if (self.charmed)
		{
			if (self.charmer == self.enemy || self.charmer == self.enemy.charmer)
			{
				self.enemy = world;
				return;
			}
		}
		sight_entity = self;
		sight_entity_time = time;
	}
	else
	{
		if (self.charmed)
		{
			if (self.charmer == self.enemy.charmer)
			{
				self.enemy = world;
				return;
			}
		}
	}
	self.show_hostile = time + SPAWNFLAG_SUPERSPIKE;
	SightSound();
	HuntTarget();
};

float() FindTarget = 
{
	local entity client;
	local float r;
	local entity head;
	local entity selected;
	local float dist;
	if (self.charmed)
	{
		self.effects = self.effects | EF_DIMLIGHT;
		if (self.huntingcharmer > MSG_BROADCAST)
		{
			UpdateCharmerGoal();
			r = vlen(self.origin - self.goalentity.origin);
			if (r < MIN_CHARMER_DISTANCE)
			{
				if (self.huntingcharmer == SVC_UPDATESTAT && r > TOOCLOSE_CHARMER_DISTANCE)
				{
					return 0;
				}
				StopHuntingCharmer();
				return 1;
			}
		}
		else
		{
			if (vlen(self.origin - self.charmer.origin) > MAX_CHARMER_DISTANCE)
			{
				HuntCharmer();
				return 0;
			}
			else
			{
				if (vlen(self.origin - self.charmer.origin) < TOOCLOSE_CHARMER_DISTANCE)
				{
					FleeCharmer();
					return 0;
				}
			}
		}
	}
	if (sight_entity_time >= time - 0.1 && !(self.spawnflags & SVC_UPDATESTAT) && !(self.charmed))
	{
		client = sight_entity;
		if (client.enemy == self.enemy)
		{
			return;
		}
	}
	else
	{
		if (self.charmed)
		{
			selected = world;
			dist = CHARMED_RADIUS;
			head = findradius(self.origin, CHARMED_RADIUS);
			while (head)
			{
				if (!(head.flags & FL_NOTARGET) && (head.flags & FL_MONSTER))
				{
					if (visible(head) && visible_distance < dist && head.health > MSG_BROADCAST)
					{
						if (head != self && head != self.charmer && head.charmer != self.charmer)
						{
							selected = head;
							dist = visible_distance;
						}
					}
				}
				head = head.chain;
			}
			if (selected == world)
			{
				return 0;
			}
			client = selected;
		}
		else
		{
			client = checkclient();
			if (!client)
			{
				return 0;
			}
		}
	}
	if (client == self.enemy)
	{
		return 0;
	}
	if (!(self.charmed))
	{
		if (client.flags & FL_NOTARGET)
		{
			return 0;
		}
	}
	if (client.items & IT_INVISIBILITY)
	{
		return 0;
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
	if (!(self.charmed))
	{
		if (r == RANGE_NEAR)
		{
			if (client.show_hostile < time && !infront(client))
			{
				return 0;
			}
		}
		else
		{
			if (r == RANGE_MID)
			{
				if (!infront(client))
				{
					return 0;
				}
			}
		}
	}
	self.enemy = client;
	if (!(self.charmed) && !(self.enemy.charmed))
	{
		if (self.enemy.classname != "player")
		{
			self.enemy = self.enemy.enemy;
			if (self.enemy.classname != "player")
			{
				self.enemy = world;
				return 0;
			}
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
	movedist = dist;
	if (FindTarget())
	{
		return;
	}
	if (self.huntingcharmer)
	{
		movetogoal(dist);
		self.nextthink = time + (self.nextthink - time) / SPAWNFLAG_LASER;
	}
	else
	{
		movetogoal(dist);
	}
};

void() ai_stand = 
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

void() ai_turn = 
{
	if (FindTarget())
	{
		return;
	}
	ChangeYaw();
};

void() ai_turn_in_place = 
{
	local float delta;
	self.nextthink = time + 0.1;
	enemy_yaw = vectoyaw(self.enemy.origin - self.origin);
	delta = fabs(self.angles_y - enemy_yaw);
	if (delta > MIN_ANGLE_DELTA)
	{
		self.ideal_yaw = enemy_yaw;
		ChangeYaw();
	}
	else
	{
		self.think = self.th_run;
	}
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
	if (self.classname == "monster_gremlin")
	{
		return GremlinCheckAttack();
	}
	if (self.classname == "monster_scourge")
	{
		return ScourgeCheckAttack();
	}
	if (self.classname == "monster_armagon")
	{
		return ArmagonCheckAttack();
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
	self.lefty = SPAWNFLAG_SUPERSPIKE - self.lefty;
	walkmove(self.ideal_yaw - ofs, movedist);
};

void() ai_run_dodge = 
{
	local float ofs;
	local float newyaw;
	self.nextthink = time + 0.1;
	if (self.lefty)
	{
		ofs = 40;
	}
	else
	{
		ofs = -40;
	}
	if (time > self.ltime)
	{
		self.lefty = SPAWNFLAG_SUPERSPIKE - self.lefty;
		self.ltime = time + 0.8;
	}
	newyaw = enemy_yaw + ofs;
	self.ideal_yaw = enemy_yaw;
	if (walkmove(newyaw, movedist))
	{
		ChangeYaw();
		return;
	}
	self.lefty = SPAWNFLAG_SUPERSPIKE - self.lefty;
	self.ltime = time + 0.8;
	newyaw = enemy_yaw - ofs;
	self.ideal_yaw = enemy_yaw;
	walkmove(newyaw, movedist);
	ChangeYaw();
};

void(float dist) ai_run = 
{
	local vector delta;
	local float axis;
	local float direct;
	local float ang_rint;
	local float ang_floor;
	local float ang_ceil;
	local float angledelta;
	movedist = dist;
	if (self.enemy.health <= MSG_BROADCAST || (self.charmed && self.charmer == self.enemy))
	{
		self.enemy = world;
		if (self.charmed)
		{
			HuntCharmer();
			return;
		}
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
	self.show_hostile = time + SPAWNFLAG_SUPERSPIKE;
	enemy_vis = visible(self.enemy);
	if (enemy_vis)
	{
		self.search_time = time + AS_DODGING;
	}
	if (coop && self.search_time < time && !(self.charmed))
	{
		if (FindTarget())
		{
			return;
		}
	}
	enemy_infront = infront(self.enemy);
	enemy_range = range(self.enemy);
	enemy_yaw = vectoyaw(self.enemy.origin - self.origin);
	if (self.th_turn)
	{
		angledelta = fabs(self.angles_y - enemy_yaw);
		if (angledelta > MIN_ANGLE_DELTA)
		{
			self.th_turn();
			return;
		}
	}
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
	if (self.attack_state == AS_DODGING)
	{
		ai_run_dodge();
		return;
	}
	if (RUN_STRAIGHT && time > self.endtime)
	{
		RUN_STRAIGHT = MSG_BROADCAST;
		axis = walkmove(self.angles_y, movedist);
		if (!axis)
		{
			self.endtime = time + SVC_UPDATESTAT;
			movetogoal(dist);
		}
	}
	else
	{
		movetogoal(dist);
	}
};

