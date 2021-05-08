float() VLFindTargetUnder = 
{
	local entity head;
	local float m;
	local float n;
	local vector o;
	local vector p;
	head = findradius(self.origin, 1000);
	while (head)
	{
		if (head.classname == "player" && visible(head))
		{
			if (head.flags & FL_NOTARGET)
			{
				return 0;
			}
			if (head.items & IT_INVISIBILITY)
			{
				return 0;
			}
			o = self.origin;
			o_z = MSG_BROADCAST;
			p = head.origin;
			p_z = MSG_BROADCAST;
			m = vlen(p - o);
			if (self.marked == MSG_BROADCAST)
			{
				self.vltime = time + LIGHTNING_BOOM;
			}
			if (m < 192)
			{
				self.enemy = head;
				FoundTarget();
				return 1;
			}
			else
			{
				if (m < 400)
				{
					self.marked = LIGHTNING_RANDOM;
					if (self.vltime < time)
					{
						self.enemy = head;
						FoundTarget();
						return 1;
					}
				}
				else
				{
					if (self.marked == LIGHTNING_RANDOM && self.vltime < time - LIGHTNING_BOOM)
					{
						self.enemy = head;
						FoundTarget();
						return 1;
					}
				}
			}
		}
		head = head.chain;
	}
	return 0;
};

float() VLFindTarget = 
{
	local entity client;
	local float r;
	if (self.wait == LIGHTNING_RANDOM)
	{
		return 0;
	}
	if (sight_entity_time >= time - 0.1 && !(self.spawnflags & AS_MELEE))
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
			return 0;
		}
	}
	if (client == self.enemy)
	{
		return 0;
	}
	if (client.flags & FL_NOTARGET)
	{
		return 0;
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
	return 1;
};

void() ai_hang = 
{
	if (VLFindTarget())
	{
		return;
	}
	if (VLFindTargetUnder())
	{
		return;
	}
};

void() voreling_stand1 = [0, voreling_stand2]
{
	ai_stand();
	if (random() < 0.25 && self.ltime < time && (self.spawnflags & LIGHTNING_RANDOM))
	{
		sound(self, CHAN_VOICE, "voreling/idle.wav", LIGHTNING_RANDOM, AS_MELEE);
		self.ltime = time + 1.8;
	}
};

void() voreling_stand2 = [1, voreling_stand3]
{
	ai_stand();
};

void() voreling_stand3 = [2, voreling_stand4]
{
	ai_stand();
};

void() voreling_stand4 = [3, voreling_stand5]
{
	ai_stand();
};

void() voreling_stand5 = [4, voreling_stand6]
{
	ai_stand();
};

void() voreling_stand6 = [5, voreling_stand7]
{
	ai_stand();
};

void() voreling_stand7 = [6, voreling_stand8]
{
	ai_stand();
};

void() voreling_stand8 = [7, voreling_stand9]
{
	ai_stand();
};

void() voreling_stand9 = [8, voreling_stand10]
{
	ai_stand();
};

void() voreling_stand10 = [9, voreling_stand11]
{
	ai_stand();
};

void() voreling_stand11 = [10, voreling_stand12]
{
	ai_stand();
};

void() voreling_stand12 = [11, voreling_stand13]
{
	ai_stand();
};

void() voreling_stand13 = [12, voreling_stand1]
{
	ai_stand();
};

void() voreling_ceiling0 = [13, voreling_ceiling1]
{
	traceline(self.origin, self.origin + '0 0 1000', 1, self);
	setorigin(self, trace_endpos - '0 0 32');
	self.flags = self.flags | FL_ONGROUND;
};

void() voreling_ceiling1 = [13, voreling_ceiling2]
{
	ai_hang();
};

void() voreling_ceiling2 = [14, voreling_ceiling3]
{
	ai_hang();
};

void() voreling_ceiling3 = [16, voreling_ceiling4]
{
	ai_hang();
};

void() voreling_ceiling4 = [16, voreling_ceiling5]
{
	ai_hang();
};

void() voreling_ceiling5 = [17, voreling_ceiling6]
{
	ai_hang();
};

void() voreling_ceiling6 = [18, voreling_ceiling1]
{
	ai_hang();
};

void() voreling_walk1 = [24, voreling_walk2]
{
	ai_walk(AS_LOITER);
};

void() voreling_walk2 = [25, voreling_walk3]
{
	ai_walk(SECRET_1ST_DOWN);
};

void() voreling_walk3 = [26, voreling_walk4]
{
	ai_walk(AS_LOITER);
};

void() voreling_walk4 = [27, voreling_walk5]
{
	ai_walk(SECRET_1ST_DOWN);
};

void() voreling_walk5 = [28, voreling_walk1]
{
	ai_walk(AS_BLINDFIRE);
};

void() voreling_run1 = [29, voreling_run2]
{
	ai_run(20);
};

void() voreling_run2 = [30, voreling_run3]
{
	ai_run(19);
};

void() voreling_run3 = [31, voreling_run4]
{
	ai_run(18);
};

void() voreling_run4 = [32, voreling_run1]
{
	ai_run(17);
};

void() voreling_attack1 = [39, voreling_attack2]
{
	ai_charge(20);
};

void() voreling_attack2 = [40, voreling_attack3]
{
	ai_charge(SECRET_YES_SHOOT);
};

void() voreling_attack3 = [41, voreling_attack4]
{
	ai_charge(TE_BEAM);
};

void() voreling_attack4 = [42, voreling_attack5]
{
	ai_charge(17);
};

void() voreling_attack5 = [43, voreling_attack6]
{
	ai_charge(18);
};

void() voreling_attack6 = [44, voreling_attack7]
{
	VorelingBite();
};

void() voreling_attack7 = [45, voreling_run1]
{
};

void() voreling_pain1 = [46, voreling_run1]
{
};

void() voreling_pain2 = [47, voreling_run1]
{
};

void() voreling_deatha1 = [48, voreling_deatha2]
{
};

void() voreling_deatha2 = [49, voreling_deatha3]
{
};

void() voreling_deatha3 = [50, voreling_deatha4]
{
};

void() voreling_deatha4 = [51, voreling_deatha5]
{
};

void() voreling_deatha5 = [52, voreling_deatha6]
{
};

void() voreling_deatha6 = [53, monster_fade]
{
	self.nextthink = time + 0.1;
};

void() voreling_deathb1 = [54, voreling_deathb2]
{
};

void() voreling_deathb2 = [55, voreling_deathb3]
{
};

void() voreling_deathb3 = [56, voreling_deathb4]
{
};

void() voreling_deathb4 = [57, voreling_deathb5]
{
};

void() voreling_deathb5 = [58, voreling_deathb6]
{
};

void() voreling_deathb6 = [59, voreling_deathb7]
{
};

void() voreling_deathb7 = [60, monster_fade]
{
	self.nextthink = time + 0.1;
};

void() voreling_jump1 = [33, voreling_jump2]
{
	ai_face();
};

void() voreling_jump2 = [34, voreling_jump3]
{
	ai_face();
	self.t_width = time + 0.1;
	self.touch = Voreling_JumpTouch;
	makevectors(self.angles);
	self.origin_z = self.origin_z + LIGHTNING_RANDOM;
	self.velocity = v_forward * 750 + '0 0 180';
	self.movetype = MOVETYPE_TOSS;
	if (self.flags & FL_ONGROUND)
	{
		self.flags = self.flags - FL_ONGROUND;
	}
};

void() voreling_jump3 = [37, voreling_jump4]
{
};

void() voreling_jump4 = [38, voreling_jump5]
{
};

void() voreling_jump5 = [38, voreling_jump1]
{
	self.nextthink = time + AS_MELEE;
};

void() voreling_pain = 
{
	if (self.pain_finished > time)
	{
		return;
	}
	sound(self, CHAN_VOICE, "voreling/pain.wav", LIGHTNING_RANDOM, ATTN_NORM);
	if (random() < 0.5)
	{
		voreling_pain1();
	}
	else
	{
		voreling_pain2();
	}
	self.pain_finished = time + AS_MELEE;
};

void(string gibname, float dm) ThrowLeg = 
{
	local entity new;
	new = spawn();
	new.origin = self.origin;
	setmodel(new, gibname);
	setsize(new, VEC_ORIGIN, VEC_ORIGIN);
	new.velocity = VelocityForDamage(dm);
	new.movetype = MOVETYPE_BOUNCE;
	new.solid = SOLID_NOT;
	new.avelocity_x = MSG_BROADCAST;
	new.avelocity_y = random() * 600 - 1200;
	new.avelocity_z = MSG_BROADCAST;
	new.think = SUB_Remove;
	new.ltime = time;
	new.nextthink = time + TE_LAVASPLASH + random() * TE_LAVASPLASH;
	new.frame = MSG_BROADCAST;
	new.flags = MSG_BROADCAST;
};

void() voreling_die = 
{
	if (self.health < -50)
	{
		sound(self, CHAN_VOICE, "player/udeath.wav", LIGHTNING_RANDOM, ATTN_NORM);
		ThrowLeg("progs/vleg.mdl", self.health);
		ThrowLeg("progs/vleg.mdl", self.health);
		ThrowLeg("progs/vleg.mdl", self.health);
		SUB_Remove();
		return;
	}
	sound(self, CHAN_VOICE, "voreling/death.wav", LIGHTNING_RANDOM, ATTN_NORM);
	if (self.health < -25)
	{
		voreling_deathb1();
	}
	else
	{
		voreling_deatha1();
	}
	self.solid = SOLID_NOT;
};

void() VorelingBite = 
{
	local vector delta;
	local float ldmg;
	if (!(self.enemy))
	{
		return;
	}
	if (!CanDamage(self.enemy, self))
	{
		return;
	}
	ai_charge(20);
	delta = self.enemy.origin - self.origin;
	if (vlen(delta) > TRIGGER_SPAWN)
	{
		return;
	}
	ldmg = AS_MELEE + random() * AS_MELEE;
	T_Damage(self.enemy, self, self, ldmg);
	SpawnMeatSpray(self.origin + v_forward * SECRET_YES_SHOOT, (random() * 60 - SVC_INTERMISSION) * v_right);
	sound(self, CHAN_VOICE, "voreling/bitestrt.wav", LIGHTNING_RANDOM, ATTN_NORM);
};

float() CheckVlingJump = 
{
	local vector dist;
	local float d;
	if (self.origin_z + self.mins_z > self.enemy.origin_z + self.enemy.mins_z + 0.75 * self.enemy.size_z)
	{
		return 0;
	}
	if (self.origin_z + self.maxs_z < self.enemy.origin_z + self.enemy.mins_z + 0.25 * self.enemy.size_z)
	{
		return 0;
	}
	dist = self.enemy.origin - self.origin;
	dist_z = MSG_BROADCAST;
	d = vlen(dist);
	if (d < 100)
	{
		return 0;
	}
	if (d > 400)
	{
		return 0;
	}
	return 1;
};

void() vling_jump = 
{
	local vector vec;
	if (CheckVlingJump())
	{
		voreling_jump1();
	}
};

void() Voreling_JumpTouch = 
{
	local float ldmg;
	if (self.health <= MSG_BROADCAST)
	{
		return;
	}
	if (self.t_width > time && other.classname == "monster_voreling")
	{
		return;
	}
	if (other.takedamage)
	{
		if (vlen(self.velocity) > 400)
		{
			ldmg = TE_WIZSPIKE + SECRET_1ST_DOWN * random();
			if (other.classname == "monster_voreling")
			{
				ldmg = LIGHTNING_RANDOM;
			}
			T_Damage(other, self, self, ldmg);
			self.touch = SUB_Null;
		}
	}
	sound(self, CHAN_BODY, "voreling/land.wav", LIGHTNING_RANDOM, ATTN_NORM);
	if (other.takedamage == DAMAGE_AIM)
	{
		sound(self, CHAN_VOICE, "voreling/bite.wav", LIGHTNING_RANDOM, ATTN_NORM);
	}
	if (!checkbottom(self))
	{
		if (self.flags & FL_ONGROUND)
		{
			self.touch = SUB_Null;
			self.think = voreling_jump1;
			self.nextthink = time + 0.1;
		}
		return;
	}
	self.movetype = MOVETYPE_STEP;
	self.touch = SUB_Null;
	self.think = voreling_run1;
	self.nextthink = time + 0.1;
};

void() Voreling_DropTouch = 
{
	local float ldmg;
	if (self.health <= MSG_BROADCAST)
	{
		return;
	}
	if (other.takedamage)
	{
		if (self.velocity_z > 100 || self.velocity_z < -100)
		{
			if (other != self.enemy)
			{
				return;
			}
			ldmg = TE_WIZSPIKE + SECRET_1ST_DOWN * random();
			T_Damage(other, self, self, ldmg);
			self.touch = SUB_Null;
			if (other.takedamage == DAMAGE_AIM)
			{
				sound(self, CHAN_VOICE, "voreling/bite.wav", LIGHTNING_RANDOM, ATTN_NORM);
			}
		}
	}
	if (!checkbottom(self))
	{
		if (self.flags & FL_ONGROUND)
		{
			self.touch = SUB_Null;
			self.think = voreling_jump1;
			self.nextthink = time + 0.1;
		}
		return;
	}
	sound(self, CHAN_VOICE, "voreling/land.wav", LIGHTNING_RANDOM, ATTN_NORM);
	self.touch = SUB_Null;
	self.think = voreling_run1;
	self.nextthink = time + 0.1;
};

void() Voreling_FallCheck = 
{
	if (self.health <= MSG_BROADCAST)
	{
		return;
	}
	if (checkbottom(self))
	{
		self.think = voreling_run1;
		self.touch = SUB_Null;
		self.nextthink = time + 0.1;
	}
	return;
};

void() voreling_drop1 = [23, voreling_fall1]
{
	self.touch = Voreling_DropTouch;
	self.th_stand = voreling_stand1;
	self.th_walk = voreling_walk1;
	self.th_run = voreling_run1;
	self.th_die = voreling_die;
	self.th_pain = voreling_pain;
	self.th_melee = voreling_attack1;
	self.th_missile = vling_jump;
	self.flags = self.flags - FL_ONGROUND;
	self.velocity = '0 0 -320';
	self.pain_finished = time + LIGHTNING_RANDOM;
	if (self.health <= MSG_BROADCAST)
	{
		self.th_die();
	}
};

void() voreling_fall1 = [19, voreling_fall2]
{
	Voreling_FallCheck();
};

void() voreling_fall2 = [20, voreling_fall3]
{
	Voreling_FallCheck();
};

void() voreling_fall3 = [21, voreling_fall4]
{
	Voreling_FallCheck();
};

void() voreling_fall4 = [22, voreling_fall5]
{
	Voreling_FallCheck();
};

void() voreling_fall5 = [23, voreling_fall2]
{
	Voreling_FallCheck();
};

void() vling_start = 
{
	local vector org;
	if (!(self.spawnflags & TRIGGER_SPAWNSILENT))
	{
		org = self.origin + SECRET_YES_SHOOT * v_forward;
		spawn_tfog(org);
	}
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/voreling.mdl");
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.health = 65;
	self.yaw_speed = 25;
	monster_spawn();
	walkmonster_start_go();
};

void() vling_begin = 
{
	if (self.spawndelay > MSG_BROADCAST)
	{
		self.nextthink = time + self.spawndelay;
	}
	else
	{
		if (self.spawndelay == CONTENT_EMPTY)
		{
			self.nextthink = time + random() * 0.4;
		}
		else
		{
			self.nextthink = time + 0.1 + random() * 0.1;
		}
	}
	self.think = vling_start;
};

void() monster_voreling = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/voreling.mdl");
	precache_model("progs/h_shal.mdl");
	precache_model("progs/vleg.mdl");
	precache_sound("voreling/death.wav");
	precache_sound("voreling/idle.wav");
	precache_sound("voreling/pain.wav");
	precache_sound("voreling/sight.wav");
	precache_sound("voreling/land.wav");
	precache_sound("voreling/bite.wav");
	precache_sound("voreling/bitestrt.wav");
	if (self.dangle == LIGHTNING_RANDOM)
	{
		self.th_stand = voreling_ceiling0;
		self.th_walk = voreling_drop1;
		self.th_run = voreling_drop1;
		self.th_die = voreling_drop1;
		self.th_pain = voreling_drop1;
		self.th_melee = voreling_drop1;
		self.th_missile = voreling_drop1;
	}
	else
	{
		self.th_stand = voreling_stand1;
		self.th_walk = voreling_walk1;
		self.th_run = voreling_run1;
		self.th_die = voreling_die;
		self.th_pain = voreling_pain;
		self.th_melee = voreling_attack1;
		self.th_missile = vling_jump;
	}
	if (self.spawnflags & TRIGGER_SPAWN)
	{
		self.use = vling_begin;
		total_monsters = total_monsters + LIGHTNING_RANDOM;
		return;
	}
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/voreling.mdl");
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.health = 65;
	self.yaw_speed = 25;
	self.think = walkmonster_start;
	self.nextthink = time + 0.1 + random() * 0.1;
};

