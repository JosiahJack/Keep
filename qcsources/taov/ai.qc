float(entity targ) check_attack = 
{
	local vector vec;
	local float dot;
	makevectors(self.angles);
	vec = normalize(targ.origin - self.origin);
	dot = vec * v_forward;
	if (dot > 0.9)
	{
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

float(entity targ) range = 
{
	local float r;
	r = vlen(self.origin - targ.origin);
	if (r >= STATE_TOP && r <= 40)
	{
		return RANGE_CLOSE;
	}
	else
	{
		if (r > 40 && r <= 75)
		{
			return RANGE_MELEE;
		}
		else
		{
			if (r > 75 && r <= 85)
			{
				return RANGE_NEAR;
			}
			else
			{
				if (r > 85 && r < 200)
				{
					return RANGE_MID;
				}
				else
				{
					return RANGE_FAR;
				}
			}
		}
	}
};

void() HuntTarget = 
{
	self.show_hostile = time + PUSH_ONCE;
	self.goalentity = self.enemy;
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	if (self.origin_x < self.enemy.origin_x)
	{
		self.angles_y = STATE_TOP;
	}
	else
	{
		self.angles_y = 180;
	}
	if (self.classname == "baron")
	{
		self.monster_running = 0;
		self.think = self.th_misc;
		self.nextthink = time + 0.1;
		return;
	}
	if (range(self.enemy) >= RANGE_FAR)
	{
		if (self.th_run)
		{
			self.monster_running = 1;
			self.think = self.th_run;
			self.nextthink = time + 0.1;
			return;
		}
	}
	self.monster_running = 0;
	if (self.th_walk)
	{
		self.think = self.th_walk;
	}
	else
	{
		self.think = self.th_run;
	}
	self.nextthink = time + 0.1;
};

void() FindTarget = 
{
	local entity player;
	local entity monster;
	if (self.awareness == IT_RELIC3 || self.enemy)
	{
		return;
	}
	monster = searchradius(self.origin, 500);
	while (monster)
	{
		if (monster.show_hostile > time && visible(monster) && range(monster) <= RANGE_MID && monster.enemy.health > STATE_TOP)
		{
			dprint(self.classname);
			dprint(" has woken up to fight.\n");
			self.enemy = monster.enemy;
			self.think = HuntTarget;
			self.nextthink = time + 0.1;
			return;
		}
		monster = monster.chain;
	}
	if (self.awareness != AS_MELEE)
	{
		player = find(world, classname, "player");
		while (player)
		{
			if (self.awareness == STATE_TOP)
			{
				if (visible(player) && player.deadflag != DEAD_DEAD && range(player) <= RANGE_MID)
				{
					if (player.running == 1 || infront(player))
					{
						dprint(self.classname);
						dprint(" has woken up to fight.\n");
						self.enemy = player;
						self.think = HuntTarget;
						self.nextthink = time + 0.1;
						return;
					}
				}
			}
			else
			{
				if (self.awareness == PUSH_ONCE)
				{
					if (visible(player) && player.deadflag != DEAD_DEAD)
					{
						dprint(self.classname);
						dprint(" has woken up to fight.\n");
						self.enemy = player;
						self.think = HuntTarget;
						self.nextthink = time + 0.1;
						return;
					}
				}
				else
				{
					if (self.awareness == IT_RELIC2)
					{
						if (player.deadflag != DEAD_DEAD)
						{
							dprint(self.classname);
							dprint(" has woken up to fight.\n");
							self.enemy = player;
							self.think = HuntTarget;
							self.nextthink = time + 0.1;
							return;
						}
					}
				}
			}
			player = find(player, classname, "player");
		}
	}
	else
	{
		player = find(world, classname, "camera");
		while (player)
		{
			if (self.origin_x < player.origin_x + 250 && self.origin_x > player.origin_x - 250 && player.char.deadflag != DEAD_DEAD)
			{
				dprint(self.classname);
				dprint(" has woken up to fight.\n");
				self.enemy = player.char;
				self.think = HuntTarget;
				self.nextthink = time + 0.1;
				return;
			}
			player = find(player, classname, "camera");
		}
	}
};

void() ai_stand = 
{
	local vector view;
	if (self.health < PUSH_ONCE)
	{
		return;
	}
	walkmove(STATE_TOP, STATE_TOP);
	if (!(self.enemy))
	{
		FindTarget();
	}
	else
	{
		if (self.stand_finished > time)
		{
			if (visible(self.enemy))
			{
				CombatThink();
			}
			if (range(self.enemy) >= RANGE_FAR && (self.flags & FL_ONGROUND))
			{
				if (self.th_run)
				{
					if (self.monster_running == 0)
					{
						self.monster_running = 1;
						self.think = self.th_run;
					}
				}
				else
				{
					if (self.monster_running == 1)
					{
						self.monster_running = 0;
						self.think = self.th_walk;
					}
				}
			}
			if (self.classname == "esquid")
			{
				self.angles_y = self.angles_y + SVC_INTERMISSION;
			}
			else
			{
				if (self.flags & FL_ONGROUND)
				{
					if (self.forceface_finished > time)
					{
						view = vectoangles(self.enemy.origin - self.origin);
						self.angles_y = view_y;
					}
					else
					{
						if (self.origin_x < self.enemy.origin_x)
						{
							self.angles_y = STATE_TOP;
						}
						else
						{
							self.angles_y = 180;
						}
					}
					self.velocity_y = STATE_TOP;
					self.velocity_x = STATE_TOP;
					self.flags = self.flags - FL_ONGROUND;
				}
			}
			if (self.classname == "archer")
			{
				self.forceface_finished = time + 100;
			}
			return;
		}
		if (!(self.enemy.flypain))
		{
			HuntTarget();
		}
		else
		{
			if (self.classname == "baron")
			{
				self.think = baron_hidesword1;
				self.nextthink = time + 0.1;
			}
			self.ai_reattack = 0;
		}
	}
};

void() CombatThink = 
{
	local float r;
	local float h;
	if (!(self.th_melee) && !(self.th_missile) && !(self.th_magic))
	{
		return;
	}
	r = range(self.enemy);
	h = random();
	if (self.th_block)
	{
		if (self.grabbed == 0)
		{
			if (!(self.flags & FL_ONGROUND) && self.enemy.onground == 0 && difficulty > STATE_TOP)
			{
				if (difficulty == PUSH_ONCE && random() < self.ai_blockfreq || difficulty > PUSH_ONCE)
				{
					self.think = self.th_block;
					self.nextthink = time + 0.2;
					return;
				}
			}
			else
			{
				if (random() < self.ai_blockfreq && self.enemy.owner.attack_finished > time && self.enemy.angles_y != self.angles_y)
				{
					self.th_block();
					return;
				}
			}
		}
	}
	if (self.ai_reattack == 0 && self.enemy.tired_finished < time && self.classname != "gaunt" && self.classname != "archg")
	{
		if (difficulty == STATE_TOP)
		{
			if (random() > 0.1)
			{
				return;
			}
		}
		if (difficulty == PUSH_ONCE)
		{
			if (random() > 0.5)
			{
				return;
			}
		}
	}
	if (self.flags & FL_ONGROUND)
	{
		self.flags = self.flags - FL_ONGROUND;
		self.velocity_y = STATE_TOP;
		self.velocity_x = STATE_TOP;
	}
	if (self.movetype == MOVETYPE_FLY || self.movetype == MOVETYPE_NOCLIP)
	{
		if (r == RANGE_MELEE || r == RANGE_CLOSE)
		{
			if (self.th_melee)
			{
				self.th_melee();
			}
		}
		else
		{
			if (random() < 0.1)
			{
				if (self.th_missile)
				{
					self.th_missile();
				}
			}
		}
		return;
	}
	if (self.ai_reattack == 1)
	{
		if (self.ai_attack == STATE_TOP)
		{
			if (self.th_melee)
			{
				self.th_melee();
			}
		}
		else
		{
			if (self.ai_attack == PUSH_ONCE)
			{
				if (h < 0.5)
				{
					if (self.th_missile)
					{
						self.th_missile();
					}
				}
			}
			else
			{
				if (self.ai_attack == IT_RELIC2)
				{
					if (self.classname == "gaunt" && self.classname == "archg")
					{
						if (h < 0.5)
						{
							if (self.th_magic)
							{
								self.th_magic();
							}
						}
					}
					else
					{
						if (h < 0.080000)
						{
							if (self.th_magic)
							{
								self.th_magic();
							}
						}
					}
				}
			}
		}
		self.ai_reattack = 0;
		return;
	}
	if (self.classname == "esquid")
	{
		if (r <= RANGE_MID)
		{
			if (self.th_missile)
			{
				self.th_missile();
			}
			self.ai_attack = PUSH_ONCE;
		}
		return;
	}
	if (self.classname == "archer")
	{
		if (random() > 0.1)
		{
			return;
		}
		if (self.th_missile)
		{
			self.th_missile();
		}
		return;
	}
	if (self.classname == "zombie" && self.enemy.classname == "zombieboss")
	{
		if (self.th_magic)
		{
			self.th_magic();
		}
		return;
	}
	if (infront(self.enemy) && self.classname != "archer")
	{
		if (r == RANGE_MELEE || r == RANGE_CLOSE)
		{
			if (self.th_melee)
			{
				self.th_melee();
			}
			self.ai_attack = STATE_TOP;
		}
		else
		{
			if (r == RANGE_NEAR && check_attack(self.enemy))
			{
				if (self.th_missile)
				{
					self.th_missile();
				}
				self.ai_attack = PUSH_ONCE;
			}
			else
			{
				if (r > RANGE_NEAR && check_attack(self.enemy))
				{
					if (self.classname == "gaunt" && self.classname == "archg")
					{
						if (h < 0.5)
						{
							if (self.th_magic)
							{
								self.th_magic();
							}
						}
					}
					else
					{
						if (h < 0.080000)
						{
							if (self.th_magic)
							{
								self.th_magic();
							}
							self.ai_attack = IT_RELIC2;
						}
					}
				}
			}
		}
	}
};

void() ai_run_slide = 
{
	walkmove(self.ideal_yaw - 90, movedist);
};

void(float dist) ai_forward = 
{
	walkmove(self.angles_y, dist);
};

void(float dir) monsterjump = 
{
	sound(self, CHAN_BODY, "player/jump.wav", PUSH_ONCE, ATTN_NORM);
	self.velocity = VEC_ORIGIN;
	self.velocity_z = 165;
	if (dir == STATE_TOP)
	{
		if (self.angles_y == STATE_TOP)
		{
			self.velocity_x = 135;
		}
		else
		{
			self.velocity_x = -135;
		}
	}
	else
	{
		if (dir == PUSH_ONCE)
		{
			if (self.angles_y == STATE_TOP)
			{
				self.velocity_y = 125;
			}
			else
			{
				self.velocity_y = -125;
			}
		}
		else
		{
			if (dir == IT_RELIC2)
			{
				if (self.angles_y == STATE_TOP)
				{
					self.velocity_y = -125;
				}
				else
				{
					self.velocity_y = 125;
				}
			}
		}
	}
	if (self.flags & FL_ONGROUND)
	{
		self.flags = self.flags - FL_ONGROUND;
	}
	self.think = self.th_jump;
	self.nextthink = time + 0.1;
};

void() check_for_ledge = 
{
	local vector org;
	local entity checker;
	local entity oself;
	local float cj;
	if (self.origin_z - TE_LIGHTNING1 < self.enemy.origin_z)
	{
		return;
	}
	makevectors(self.angles);
	if (self.check_finished < time)
	{
		self.check_finished = time + 0.5;
		org = self.origin + v_forward * 35;
		traceline(org, org - v_up * 60, 0, self);
		if (trace_fraction == PUSH_ONCE)
		{
			checker = spawn();
			setmodel(checker, "progs/null.spr");
			setorigin(checker, trace_endpos);
			checker.movetype = MOVETYPE_STEP;
			setsize(checker, self.mins, self.maxs);
			oself = self;
			self = checker;
			droptofloor();
			cj = walkmove(STATE_TOP, STATE_TOP);
			self = oself;
			if (cj == 1 && (checker.flags & FL_ONGROUND))
			{
				monsterjump(STATE_TOP);
			}
			if (checker)
			{
				remove(checker);
			}
			return;
		}
		org = self.origin - v_right * 35;
		traceline(org, org - v_up * 60, 0, self);
		if (trace_fraction == PUSH_ONCE)
		{
			checker = spawn();
			setmodel(checker, "progs/null.spr");
			setorigin(checker, trace_endpos);
			checker.movetype = MOVETYPE_STEP;
			setsize(checker, self.mins, self.maxs);
			oself = self;
			self = checker;
			droptofloor();
			cj = walkmove(STATE_TOP, STATE_TOP);
			self = oself;
			if (cj == 1 && (checker.flags & FL_ONGROUND))
			{
				monsterjump(PUSH_ONCE);
			}
			if (checker)
			{
				remove(checker);
			}
			return;
		}
		org = self.origin + v_right * 35;
		traceline(org, org - v_up * 60, 0, self);
		if (trace_fraction == PUSH_ONCE)
		{
			checker = spawn();
			setmodel(checker, "progs/null.spr");
			setorigin(checker, trace_endpos);
			checker.movetype = MOVETYPE_STEP;
			setsize(checker, self.mins, self.maxs);
			oself = self;
			self = checker;
			droptofloor();
			cj = walkmove(STATE_TOP, STATE_TOP);
			self = oself;
			if (cj == 1 && (checker.flags & FL_ONGROUND))
			{
				monsterjump(IT_RELIC2);
			}
			if (checker)
			{
				remove(checker);
			}
			return;
		}
	}
};

void(float dist) ai_fly = 
{
	local float r;
	local vector source;
	if (self.health < PUSH_ONCE)
	{
		return;
	}
	if (self.twister_damage_finished < time)
	{
		if (self.classname == "horror")
		{
			self.movetype = MOVETYPE_FLY;
		}
		else
		{
			self.movetype = MOVETYPE_NOCLIP;
		}
		self.angles_z = STATE_TOP;
		self.angles_x = STATE_TOP;
		self.avelocity = VEC_ORIGIN;
	}
	if (self.enemy.health < PUSH_ONCE)
	{
		self.velocity = VEC_ORIGIN;
		self.ai_reattack = 0;
		if (self.movetype != MOVETYPE_NOCLIP)
		{
			self.enemy = world;
		}
		self.th_stand();
		return;
	}
	if (self.health < PUSH_ONCE)
	{
		self.th_die();
		return;
	}
	r = range(self.enemy);
	if (self.origin_x < self.enemy.origin_x)
	{
		self.angles_y = STATE_TOP;
	}
	else
	{
		self.angles_y = 180;
	}
	if (self.enemy.flypain)
	{
		self.velocity = VEC_ORIGIN;
		self.th_stand();
		return;
	}
	if (self.movetype == MOVETYPE_NOCLIP)
	{
		if (self.airtight_finished < time)
		{
			if (random() < 0.5)
			{
				self.velocity_x = self.velocity_x / IT_RELIC2;
				self.velocity_y = self.velocity_y / IT_RELIC2;
				self.velocity_z = self.velocity_z / IT_RELIC2;
			}
			else
			{
				if (other.classname != "ghost")
				{
					self.velocity = VEC_ORIGIN;
				}
			}
			self.airtight_finished = time + 0.4;
		}
	}
	CombatThink();
	if (self.movetype != MOVETYPE_NOCLIP)
	{
		if (visible(self.enemy))
		{
			if (self.origin_x < self.enemy.origin_x)
			{
				self.velocity_x = self.velocity_x + dist;
			}
			if (self.origin_x > self.enemy.origin_x)
			{
				self.velocity_x = self.velocity_x - dist;
			}
			if (self.origin_y < self.enemy.origin_y)
			{
				self.velocity_y = self.velocity_y + dist;
			}
			if (self.origin_y > self.enemy.origin_y)
			{
				self.velocity_y = self.velocity_y - dist;
			}
			if (self.origin_z < self.enemy.origin_z)
			{
				self.velocity_z = self.velocity_z + dist;
			}
			if (self.origin_z > self.enemy.origin_z)
			{
				self.velocity_z = self.velocity_z - dist / IT_RELIC2;
			}
			source = self.origin;
			traceline(source, source - v_up * 100, 0, self);
			if (trace_fraction == PUSH_ONCE)
			{
				return;
			}
			if (trace_ent.solid == SOLID_BSP)
			{
				self.velocity_z = self.velocity_z + dist * IT_RELIC2;
			}
		}
		else
		{
			self.velocity = VEC_ORIGIN;
			self.velocity_z = self.velocity_z + SVC_CLIENTDATA;
		}
	}
	else
	{
		if (self.origin_x < self.enemy.origin_x)
		{
			self.velocity_x = self.velocity_x + dist;
		}
		if (self.origin_x > self.enemy.origin_x)
		{
			self.velocity_x = self.velocity_x - dist;
		}
		if (self.origin_y < self.enemy.origin_y)
		{
			self.velocity_y = self.velocity_y + dist;
		}
		if (self.origin_y > self.enemy.origin_y)
		{
			self.velocity_y = self.velocity_y - dist;
		}
		if (self.origin_z < self.enemy.origin_z)
		{
			self.velocity_z = self.velocity_z + dist;
		}
		if (self.origin_z > self.enemy.origin_z)
		{
			self.velocity_z = self.velocity_z - dist;
		}
	}
	if (self.flags & FL_ONGROUND)
	{
		self.flags = self.flags - FL_ONGROUND;
	}
	if (self.flags & FL_PARTIALGROUND)
	{
		self.flags = self.flags - FL_PARTIALGROUND;
	}
	if (vlen(self.velocity) > 800)
	{
		self.velocity = self.velocity * 0.333;
	}
};

void(float dist) ai_walk = 
{
	local float r;
	local float ran;
	local entity y;
	local vector view;
	if (self.health < PUSH_ONCE)
	{
		return;
	}
	r = range(self.enemy);
	if (self.enemy.health < PUSH_ONCE)
	{
		self.ai_reattack = 0;
		self.enemy = world;
		if (self.classname == "baron")
		{
			self.think = baron_hidesword1;
		}
		else
		{
			self.th_stand();
		}
		return;
	}
	if (self.classname == "zombie")
	{
		if (self.enemy.classname != "zombieboss")
		{
			y = find(world, classname, "zombieboss");
			while (y)
			{
				if (y.health <= y.state)
				{
					self.oldenemy = self.enemy;
					self.enemy = y;
				}
				y = find(y, classname, "zombieboss");
			}
			y = find(world, classname, "zombieboss");
		}
		else
		{
			if (self.enemy.health >= self.enemy.max_health / IT_RELIC2)
			{
				if (self.oldenemy.health > STATE_TOP)
				{
					self.enemy = self.oldenemy;
				}
				else
				{
					self.enemy = world;
					self.th_stand();
					return;
				}
			}
		}
	}
	if (self.th_jump)
	{
		if (self.flags & FL_ONGROUND && self.nojump == 0)
		{
			check_for_ledge();
		}
	}
	if (self.classname == "esquid")
	{
		self.angles_y = self.angles_y + SVC_INTERMISSION;
	}
	else
	{
		if (self.flags & FL_ONGROUND)
		{
			if (self.forceface_finished > time)
			{
				view = vectoangles(self.enemy.origin - self.origin);
				self.angles_y = view_y;
			}
			else
			{
				if (self.origin_x < self.enemy.origin_x)
				{
					self.angles_y = STATE_TOP;
				}
				else
				{
					self.angles_y = 180;
				}
			}
		}
	}
	if (self.classname == "archer")
	{
		self.forceface_finished = time + 100;
	}
	if (self.monster_running == 0 && self.classname != "baron" && self.classname != "esquid" && self.enemy.tired_finished < time)
	{
		if (self.stand_finished < time)
		{
			if (random() < 0.1)
			{
				if (random() < 0.7)
				{
					self.stand_finished = time + PUSH_ONCE * random() * IT_RELIC2;
					self.th_stand();
					return;
				}
			}
		}
		else
		{
			return;
		}
	}
	if (self.enemy.flypain)
	{
		self.th_stand();
		return;
	}
	if (self.enemy.angles_y != self.angles_y && self.classname != "esquid")
	{
		if (self.enemy.velocity_z >= TE_LAVASPLASH || (self.enemy.velocity_z <= -10 && self.enemy.attack_finished > time))
		{
			if (random() < 0.5)
			{
				self.wiggledir = STATE_TOP;
			}
			else
			{
				self.wiggledir = PUSH_ONCE;
			}
			self.backtime = time + 0.5;
		}
		ran = random();
		if (ran < 0.030000)
		{
			self.behind_finished = time + 1.5;
		}
	}
	if (self.backtime > time)
	{
		if (self.enemy.tired_finished > time)
		{
			self.backtime = time;
		}
		else
		{
			if (self.flags & FL_ONGROUND)
			{
				if (self.wiggledir == STATE_TOP)
				{
					self.velocity_y = dist;
				}
				else
				{
					self.velocity_y = dist * CONTENT_EMPTY;
				}
			}
		}
		dist = dist * CONTENT_EMPTY;
	}
	if (self.classname != "esquid")
	{
		if (r <= RANGE_NEAR || r <= RANGE_MELEE && self.enemy.tired_finished < time)
		{
			if (random() < 0.5)
			{
				self.wiggledir = STATE_TOP;
			}
			else
			{
				self.wiggledir = PUSH_ONCE;
			}
			self.backtime = time + 0.4 * random() + 0.8;
		}
		else
		{
			movedist = dist;
		}
	}
	if (self.enemy.angles_y == self.angles_y && self.backtime > time)
	{
		self.backtime = time;
	}
	if (self.behind_finished > time)
	{
		if (self.enemy.flypain || self.backtime > time)
		{
			return;
		}
		ai_run_slide();
	}
	if (r <= RANGE_CLOSE)
	{
		if (self.distance_mode == 0)
		{
			self.distance_mode = 1;
			self.ideal_yaw = vectoyaw(self.enemy.origin + self.origin);
		}
	}
	else
	{
		if (self.distance_mode == 1)
		{
			self.distance_mode = 0;
			self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
		}
	}
	if (self.flags & FL_ONGROUND)
	{
		if (range(self.enemy) >= RANGE_FAR)
		{
			if (self.th_run)
			{
				if (self.monster_running == 0)
				{
					self.monster_running = 1;
					self.think = self.th_run;
				}
			}
			else
			{
				if (self.monster_running == 1)
				{
					self.monster_running = 0;
					self.think = self.th_walk;
				}
			}
		}
		else
		{
			if (self.monster_running != 0)
			{
				self.monster_running = 0;
				if (self.th_walk)
				{
					self.think = self.th_walk;
				}
				else
				{
					self.think = self.th_run;
				}
			}
		}
	}
	if (self.ai_reattack == 0)
	{
		movetogoal(dist);
	}
	if (visible(self.enemy))
	{
		CombatThink();
	}
	else
	{
		if (self.classname == "archer" && self.mode == PUSH_ONCE)
		{
			CombatThink();
		}
	}
};

void() wakeup = 
{
	local entity player;
	player = find(world, classname, "player");
	while (player)
	{
		dprint(self.classname);
		dprint(" has woken up to fight.\n");
		self.enemy = player;
		self.think = HuntTarget;
		self.nextthink = time + 0.1;
		return;
	}
	player = find(player, classname, "player");
};

void(entity attacker) monster_pain = 
{
	if (self.flags & FL_ONGROUND)
	{
		self.flags = self.flags - FL_ONGROUND;
		self.velocity_y = STATE_TOP;
		self.velocity_x = STATE_TOP;
	}
	if (self.grabbed == 1)
	{
		self.th_grab();
	}
	if (self.movetype == MOVETYPE_FLY)
	{
		self.velocity_z = self.velocity_z - 150;
	}
	else
	{
		if (self.movetype == MOVETYPE_NOCLIP)
		{
			self.velocity = VEC_ORIGIN;
		}
	}
	makevectors(self.angles);
	if (self.knockback == PUSH_ONCE)
	{
		self.velocity = VEC_ORIGIN;
		self.velocity_z = 300;
		if (attacker.angles_y == STATE_TOP)
		{
			self.velocity_x = 100;
		}
		else
		{
			self.velocity_x = -100;
		}
		if (self.flags & FL_ONGROUND)
		{
			self.flags = self.flags - FL_ONGROUND;
		}
	}
	else
	{
		if (self.knockback == IT_RELIC2)
		{
			self.velocity = VEC_ORIGIN;
			self.velocity_z = 425;
			if (self.flags & FL_ONGROUND)
			{
				self.flags = self.flags - FL_ONGROUND;
			}
		}
		else
		{
			if (self.knockback == AS_MELEE)
			{
				self.velocity = VEC_ORIGIN;
				setorigin(self, self.origin);
				self.velocity_z = 300;
				if (attacker.angles_y == STATE_TOP)
				{
					self.velocity_x = 300;
				}
				else
				{
					self.velocity_x = -300;
				}
				if (self.flags & FL_ONGROUND)
				{
					self.flags = self.flags - FL_ONGROUND;
				}
			}
			else
			{
				if (self.knockback == IT_RELIC3)
				{
					self.velocity_z = 200;
					if (attacker.angles_y == STATE_TOP)
					{
						self.velocity_x = 50;
					}
					else
					{
						self.velocity_x = -50;
					}
					if (self.flags & FL_ONGROUND)
					{
						self.flags = self.flags - FL_ONGROUND;
					}
					self.paincount = IT_RELIC2;
				}
				else
				{
					if (self.knockback == TE_LIGHTNING1)
					{
						self.velocity = VEC_ORIGIN;
						self.velocity_z = 350;
						if (attacker.angles_y == STATE_TOP)
						{
							self.velocity_x = 200;
						}
						else
						{
							self.velocity_x = -200;
						}
						if (self.flags & FL_ONGROUND)
						{
							self.flags = self.flags - FL_ONGROUND;
						}
					}
				}
			}
		}
	}
	self.knockback = 0;
};

void() monster_death = 
{
	if (self.flags & FL_ONGROUND)
	{
		self.velocity_y = STATE_TOP;
		self.velocity_x = STATE_TOP;
	}
	if (self.deadflag == DEAD_DEAD)
	{
		return;
	}
	if (vlen(self.velocity) < PUSH_ONCE || (self.flags & FL_ONGROUND) || (self.flags & FL_PARTIALGROUND) || self.origin == self.oldorigin)
	{
		if (self.classname == "horror")
		{
			sound(self, CHAN_AUTO, "horror/crunch.wav", PUSH_ONCE, ATTN_NORM);
			ThrowGib("progs/gib1.mdl");
			ThrowGib("progs/gib3.mdl");
			ThrowGib("progs/gib1.mdl");
			ThrowGib("progs/gib3.mdl");
		}
		else
		{
			sound(self, CHAN_BODY, "misc/hitgrond.wav", PUSH_ONCE, ATTN_NORM);
		}
		self.avelocity = VEC_ORIGIN;
		self.angles_x = STATE_TOP;
		self.takedamage = DAMAGE_NO;
		self.deadflag = DEAD_DEAD;
		if (self.flags & FL_ONGROUND)
		{
			self.flags = self.flags - FL_ONGROUND;
		}
		return;
	}
	self.oldorigin = self.origin;
};

void() enemy_start = 
{
	total_monsters = total_monsters + PUSH_ONCE;
	if (self.classname == "archer" && self.mode == PUSH_ONCE)
	{
		total_monsters = total_monsters - PUSH_ONCE;
	}
	if (!walkmove(STATE_TOP, STATE_TOP))
	{
		dprint("walkmonster in wall at: ");
		dprint(vtos(self.origin));
		dprint("\n");
	}
	if (self.movetype == MOVETYPE_STEP && self.nodrop == STATE_TOP)
	{
		droptofloor();
	}
	self.use = wakeup;
	self.netname = "solid";
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_NOT;
	self.flags = self.flags | FL_MONSTER;
	if (self.th_stand)
	{
		self.th_stand();
	}
};

