void() actor_pain1 = [46, actor_pain2]
{
	PainSound();
	self.weaponframe = 0;
};

void() actor_pain2 = [47, actor_pain3]
{
};

void() actor_pain3 = [48, actor_pain4]
{
};

void() actor_pain4 = [49, actor_pain5]
{
};

void() actor_pain5 = [50, actor_pain6]
{
};

void() actor_pain6 = [51, actor_run]
{
	if (self.count == 1 && self.enemy != world)
	{
		ai_run(MOVETYPE_BOUNCE);
	}
};

void() actor_pain = 
{
	local float r;
	if (self.pain_finished > time)
	{
		return;
	}
	ai_back(MOVETYPE_FLY);
	self.pain_finished = time + 0.7;
	actor_pain1();
};

void() actor_shot1 = [141, actor_shot2]
{
	self.weaponframe = 1;
	self.effects = self.effects | EF_MUZZLEFLASH;
};

void() actor_shot2 = [142, actor_shot3]
{
	self.weaponframe = FL_SWIM;
};

void() actor_shot3 = [143, actor_shot4]
{
	self.weaponframe = MOVETYPE_WALK;
};

void() actor_shot4 = [144, actor_shot5]
{
	self.weaponframe = MOVETYPE_STEP;
};

void() actor_shot5 = [145, actor_shot6]
{
	self.weaponframe = MOVETYPE_FLY;
};

void() actor_shot6 = [146, actor_run]
{
	self.weaponframe = MOVETYPE_TOSS;
};

void() Actor_Die = 
{
	if (self.health > -40)
	{
		self.health = -45;
	}
	ActorDie();
};

void() Actor_use = 
{
	if (self.spawnflags & ACTOR_DEAD)
	{
		self.takedamage = DAMAGE_AIM;
		self.enemy = checkclient();
		if (self.enemy)
		{
			self.movetarget = self.enemy;
			self.goalentity = self.enemy;
		}
		self.count = 1;
	}
	else
	{
		self.pausetime = time;
	}
};

void() GibActor = 
{
	self.frame = 0;
	self.think = SUB_UseTargets;
	ThrowHead("progs/h_player.mdl", self.health, self.dest);
	ThrowGib("progs/gib1.mdl", self.health, self.dest);
	ThrowGib("progs/gib2.mdl", self.health, self.dest);
	ThrowGib("progs/gib3.mdl", self.health, self.dest);
	self.deadflag = DEAD_DEAD;
	if (damage_attacker.classname == "teledeath")
	{
		sound(self, CHAN_VOICE, "player/teledth1.wav", 1, ATTN_NONE);
		return;
	}
	if (damage_attacker.classname == "teledeath2")
	{
		sound(self, CHAN_VOICE, "player/teledth1.wav", 1, ATTN_NONE);
		return;
	}
	if (random() < 0.5)
	{
		sound(self, CHAN_VOICE, "player/gib.wav", 1, ATTN_NONE);
	}
	else
	{
		sound(self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NONE);
	}
};

void() ActorDie = 
{
	local float i;
	self.deadflag = DEAD_DYING;
	self.solid = SOLID_NOT;
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	self.movetype = MOVETYPE_TOSS;
	if (self.velocity_z < MOVETYPE_BOUNCE)
	{
		self.velocity_z = self.velocity_z + random() * 300;
	}
	if (self.health < -20)
	{
		self.frame = 0;
		GibActor();
		return;
	}
	DeathSound();
	self.angles_x = 0;
	self.angles_z = 0;
	if (self.weapon == IT_AXE)
	{
		player_die_ax1();
		return;
	}
	i = cvar("temp1");
	if (!i)
	{
		i = 1 + floor(random() * MOVETYPE_TOSS);
	}
	if (i == 1)
	{
		player_diea1();
	}
	else
	{
		if (i == FL_SWIM)
		{
			player_dieb1();
		}
		else
		{
			if (i == MOVETYPE_WALK)
			{
				player_diec1();
			}
			else
			{
				if (i == MOVETYPE_STEP)
				{
					player_died1();
				}
				else
				{
					player_diee1();
				}
			}
		}
	}
};

void() actor_stand1 = [17, actor_stand1]
{
	self.weaponframe = 0;
	if (self.pausetime < time)
	{
		actor_run();
		return;
	}
	if (self.walkframe >= MOVETYPE_FLY)
	{
		self.walkframe = 0;
	}
	self.frame = 18 + self.walkframe;
	self.walkframe = self.walkframe + 1;
};

void() actor_run = [6, actor_run]
{
	if (self.dmg == 69)
	{
		if (time > 55)
		{
			self.think = SUB_Null;
			self.nextthink = CONTENT_EMPTY;
			self.pausetime = 999999;
			return;
		}
	}
	self.weaponframe = 0;
	self.oldorigin = self.origin;
	if (self.count == 0 || self.enemy == world)
	{
		movetogoal(self.speed);
	}
	else
	{
		if (self.count == 1)
		{
			self.enemy = checkclient();
		}
		if (self.enemy)
		{
			if (self.enemy.health <= 0)
			{
				self.enemy = world;
				self.count = 0;
				self.goalentity = self.movetarget = self.oldenemy;
				self.think = actor_run;
				self.nextthink = time + 0.010000;
				return;
			}
			self.movetarget = self.enemy;
			self.goalentity = self.enemy;
		}
		ai_run(self.speed);
	}
	if (self.count == 1)
	{
		self.enemy = checkclient();
	}
	if (self.walkframe == MOVETYPE_TOSS)
	{
		self.walkframe = 0;
	}
	self.frame = self.frame + self.walkframe;
	self.walkframe = self.walkframe + 1;
};

void() Actor_attack = 
{
	local float randatck;
	local vector dir;
	local entity en;
	if (self.attack_finished > time)
	{
		return;
	}
	randatck = random();
	if (randatck < 0.85)
	{
		ai_face();
		actor_shot1();
		self.effects = self.effects | EF_MUZZLEFLASH;
		sound(self, CHAN_WEAPON, "weapons/guncock.wav", 1, ATTN_NORM);
		en = self.enemy;
		dir = en.origin - en.velocity * 0.2;
		dir = normalize(dir - self.origin);
		FireBullets(MOVETYPE_BOUNCE, dir, '0.1 0.1 0');
		self.attack_finished = time + 1;
		return;
	}
};

void() actor_start = 
{
	if (self.spawnflags & ACTOR_DEAD)
	{
		self.origin_z = self.origin_z + 1;
		droptofloor();
		if (!walkmove(0, 0))
		{
			dprint("walkmonster in wall at: ");
			dprint(vtos(self.origin));
			dprint("\n");
		}
		if (self.target)
		{
			self.goalentity = self.movetarget = find(world, targetname, self.target);
			self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
			if (!(self.movetarget))
			{
				dprint("Actor can't find target at ");
				dprint(vtos(self.origin));
				dprint("\n");
			}
		}
		else
		{
			self.pausetime = 9999999;
		}
		self.takedamage = DAMAGE_NO;
		self.nextthink = time + 0.1;
		self.think = self.th_run;
	}
	else
	{
		if (self.target)
		{
			self.goalentity = self.movetarget = find(world, targetname, self.target);
			self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
			if (!(self.movetarget))
			{
				dprint("Actor can't find target at ");
				dprint(vtos(self.origin));
				dprint("\n");
			}
		}
		else
		{
			self.pausetime = 9999999;
		}
		droptofloor();
		actor_stand1();
	}
};

void() actor_sf64start = 
{
	local vector org;
	local entity teldeath;
	if (self.style)
	{
		makevectors(self.angles);
		org = self.origin + FL_INWATER * v_forward;
		spawn_tfog(org);
		teldeath = spawn();
		teldeath.origin = org;
		teldeath.owner = self;
		teldeath.think = sf64_teledeath;
		teldeath.nextthink = time + 0.2;
	}
	self.use = Actor_use;
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/player.mdl");
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	setorigin(self, self.origin);
	if (self.wait)
	{
		self.pausetime = time + self.wait;
	}
	self.nextthink = time + 0.1;
	self.think = actor_start;
};

void() misc_hostage = 
{
	local entity body;
	local entity d;
	if (deathmatch || coop)
	{
		remove(self);
	}
	if (self.spawnflags & MOVETYPE_STEP)
	{
		d = world;
		d = find(world, classname, "dummy");
		self.owner = d;
		if (d == world)
		{
			objerror("Couldn't find activating player");
		}
	}
	self.origin = self.origin + '0 0 56';
	self.classname = "actor";
	self.netname = "actor";
	self.health = 150;
	self.yaw_speed = SVC_INTERMISSION;
	self.count = 0;
	self.takedamage = DAMAGE_AIM;
	self.flags = FL_MONSTER | FL_CLIENT;
	self.waterlevel = 0;
	self.show_hostile = 0;
	self.attack_finished = 0;
	self.weapon = IT_ROCKET_LAUNCHER;
	self.ammo_nails = MAX_NAILS;
	self.ammo_rockets = MAX_SHELLS;
	self.currentammo = MAX_NAILS;
	if (self.spawnflags & ACTOR_DEAD)
	{
		total_monsters = total_monsters + 1;
	}
	if (self.wait)
	{
		self.pausetime = time + self.wait;
	}
	else
	{
		self.pausetime = 9999999;
	}
	self.weaponframe = 0;
	self.walkframe = 0;
	self.frame = STAT_TOTALMONSTERS;
	if (!(self.speed))
	{
		self.speed = MOVETYPE_BOUNCE;
	}
	self.th_stand = actor_stand1;
	self.th_run = actor_run;
	self.th_walk = actor_run;
	self.th_pain = actor_pain;
	self.th_die = ActorDie;
	self.th_missile = Actor_attack;
	self.th_melee = Actor_attack;
	if (self.spawnflags & FL_GODMODE)
	{
		self.use = actor_sf64start;
		return;
	}
	self.use = Actor_use;
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/player.mdl");
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	setorigin(self, self.origin);
	self.nextthink = time + 0.1;
	self.think = actor_start;
};

void() ActorJump = 
{
	local vector vel;
	vel = self.origin - self.oldorigin;
	self.velocity = normalize(vel) * (self.speed * MOVETYPE_BOUNCE);
	if (self.waterlevel >= FL_SWIM)
	{
		if (self.watertype == CONTENT_WATER)
		{
			self.velocity_z = MAX_SHELLS;
		}
		else
		{
			if (self.watertype == CONTENT_SLIME)
			{
				self.velocity_z = 80;
			}
			else
			{
				self.velocity_z = 50;
			}
		}
		if (self.swim_flag < time)
		{
			self.swim_flag = time + 1;
			if (random() < 0.5)
			{
				sound(self, CHAN_BODY, "misc/water1.wav", 1, ATTN_NORM);
			}
			else
			{
				sound(self, CHAN_BODY, "misc/water2.wav", 1, ATTN_NORM);
			}
		}
		return;
	}
	sound(self, CHAN_BODY, "player/plyrjmp8.wav", 1, ATTN_NORM);
	self.flags = self.flags - FL_ONGROUND;
	setorigin(self, self.origin + '0 0 2');
	self.velocity_z = self.velocity_z + 270;
};

void(vector dir) actor_rocket = 
{
	local entity missile;
	local entity mpuff;
	local vector back;
	sound(self, CHAN_WEAPON, "weapons/sgun1.wav", 1, ATTN_NONE);
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "missile";
	makevectors(self.v_angle);
	missile.velocity = dir;
	missile.velocity = missile.velocity * 800;
	missile.angles = vectoangles(missile.velocity);
	missile.touch = SUB_Remove;
	missile.nextthink = time + MOVETYPE_FLY;
	missile.think = SUB_Remove;
	setmodel(missile, "progs/missile.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, self.origin + v_forward * FL_CLIENT + '0 0 16');
};

void() Actor_shoot = 
{
	local vector dir;
	local entity en;
	ai_face();
	en = self.enemy;
	dir = en.origin - en.velocity * 0.2;
	dir = normalize(dir - self.origin);
	if (self.spawnflags & ACTOR_ROCKET)
	{
		actor_rocket(dir);
	}
	else
	{
		sound(self, CHAN_WEAPON, "weapons/guncock.wav", 1, ATTN_NORM);
		FireBullets(FL_CLIENT, dir, '0.1 0.1 0');
	}
	self.attack_finished = time + 1;
	self.enemy = world;
};

void() t_actortarget = 
{
	local entity temp;
	if (self.rad_time > time)
	{
		return;
	}
	if (other.classname != "actor")
	{
		return;
	}
	if (other.count == FL_SWIM)
	{
		return;
	}
	if (other.goalentity != self)
	{
		return;
	}
	self.rad_time = time + 2.5;
	other.goalentity = other.movetarget = find(world, targetname, self.target);
	other.ideal_yaw = vectoyaw(other.goalentity.origin - other.origin);
	if (self.speed)
	{
		other.th_walk = actor_run;
		other.th_run = actor_run;
		other.speed = self.speed;
	}
	if (self.message)
	{
		self.target = self.message;
		SUB_UseTargets();
	}
	if (self.dmg)
	{
		self.nextthink = time + 0.1;
		self.think = SUB_Remove;
	}
	if (self.spawnflags & FREEZE)
	{
		other.th_walk = actor_stand1;
		other.th_run = actor_stand1;
	}
	if (self.spawnflags & ACTOR_JUMP)
	{
		temp = self;
		self = other;
		ActorJump();
		self = temp;
		return;
	}
	if (self.spawnflags & ACTOR_SHOOT)
	{
		other.enemy = find(world, targetname, self.noise);
		temp = self;
		self = other;
		actor_shot1();
		Actor_shoot();
		if (!(temp.targetname))
		{
			self.pausetime = time + 999999;
			self.th_stand();
			self = temp;
			return;
		}
		self = temp;
		return;
	}
	if (self.spawnflags & ACTOR_ATTACK)
	{
		other.enemy = find(world, targetname, self.noise);
		while (!(other.enemy.flags & FL_MONSTER))
		{
			other.enemy = find(other.enemy, targetname, self.noise);
		}
		other.count = FL_SWIM;
		other.oldenemy = other.goalentity;
		return;
	}
	if (self.wait)
	{
		self.rad_time = self.rad_time + self.wait;
		temp = self;
		self = other;
		self.pausetime = time + temp.wait;
		actor_stand1();
		self = temp;
		return;
	}
	if (!(other.movetarget))
	{
		temp = self;
		self = other;
		self.pausetime = time + 999999;
		self.th_stand();
		self = temp;
		return;
	}
};

void() s_at = 
{
	self.solid = SOLID_TRIGGER;
	self.touch = t_actortarget;
	setsize(self, '-8 -8 -12', '8 8 24');
};

void() actor_target = 
{
	if (!(self.targetname))
	{
		objerror("actor_target: no targetname");
	}
	self.nextthink = time + 0.1;
	self.think = s_at;
};

