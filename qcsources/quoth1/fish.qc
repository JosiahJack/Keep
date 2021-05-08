void(float dist) ai_chargeswim = 
{
	local vector mtemp;
	local vector org;
	local vector org_flat;
	local vector oldorg_flat;
	local vector oldorg;
	local vector reqvel;
	local float d;
	oldorg = self.origin;
	self.movetype = MOVETYPE_STEP;
	ai_charge(dist);
	d = vlen(self.origin - oldorg);
	self.velocity = VEC_ORIGIN;
	if (d <= dist + AS_BLINDFIRE)
	{
		if (pointcontents(self.origin + '0 0 16') == CONTENT_EMPTY)
		{
			self.origin_z = oldorg_z;
		}
		self.movetype = MOVETYPE_FLY;
		reqvel = normalize(self.origin - oldorg) * dist * TE_WIZSPIKE;
		setorigin(self, oldorg);
		self.velocity = reqvel;
	}
	if (pointcontents(self.origin + VEC_ORIGIN) == CONTENT_EMPTY)
	{
		self.velocity_z = -8;
	}
};

void(float dist) ai_painswim = 
{
	local vector mtemp;
	local vector org;
	local vector org_flat;
	local vector oldorg_flat;
	local vector oldorg;
	local vector reqvel;
	local float d;
	oldorg = self.origin;
	self.movetype = MOVETYPE_STEP;
	ai_pain(dist);
	d = vlen(self.origin - oldorg);
	self.velocity = VEC_ORIGIN;
	if (d <= dist + AS_BLINDFIRE)
	{
		if (pointcontents(self.origin + '0 0 16') == CONTENT_EMPTY)
		{
			self.origin_z = oldorg_z;
		}
		self.movetype = MOVETYPE_FLY;
		reqvel = normalize(self.origin - oldorg) * dist * TE_WIZSPIKE;
		setorigin(self, oldorg);
		self.velocity = reqvel;
	}
	if (pointcontents(self.origin + VEC_ORIGIN) == CONTENT_EMPTY)
	{
		self.velocity_z = -8;
	}
};

void(float dist) ai_swim = 
{
	local vector mtemp;
	local vector org;
	local vector org_flat;
	local vector oldorg_flat;
	local vector oldorg;
	local vector reqvel;
	local float d;
	oldorg = self.origin;
	self.movetype = MOVETYPE_STEP;
	ai_run(dist);
	d = vlen(self.origin - oldorg);
	self.velocity = VEC_ORIGIN;
	if (d <= dist + AS_BLINDFIRE)
	{
		if (pointcontents(self.origin + '0 0 16') == CONTENT_EMPTY)
		{
			self.origin_z = oldorg_z;
		}
		self.movetype = MOVETYPE_FLY;
		reqvel = normalize(self.origin - oldorg) * dist * TE_WIZSPIKE;
		setorigin(self, oldorg);
		self.velocity = reqvel;
	}
	if (pointcontents(self.origin + VEC_ORIGIN) == CONTENT_EMPTY)
	{
		self.velocity_z = -8;
	}
};

void() f_stand1 = [39, f_stand2]
{
	ai_stand();
};

void() f_stand2 = [40, f_stand3]
{
	ai_stand();
};

void() f_stand3 = [41, f_stand4]
{
	ai_stand();
};

void() f_stand4 = [42, f_stand5]
{
	ai_stand();
};

void() f_stand5 = [43, f_stand6]
{
	ai_stand();
};

void() f_stand6 = [44, f_stand7]
{
	ai_stand();
};

void() f_stand7 = [45, f_stand8]
{
	ai_stand();
};

void() f_stand8 = [46, f_stand9]
{
	ai_stand();
};

void() f_stand9 = [47, f_stand10]
{
	ai_stand();
};

void() f_stand10 = [48, f_stand11]
{
	ai_stand();
};

void() f_stand11 = [49, f_stand12]
{
	ai_stand();
};

void() f_stand12 = [50, f_stand13]
{
	ai_stand();
};

void() f_stand13 = [51, f_stand14]
{
	ai_stand();
};

void() f_stand14 = [52, f_stand15]
{
	ai_stand();
};

void() f_stand15 = [53, f_stand16]
{
	ai_stand();
};

void() f_stand16 = [54, f_stand17]
{
	ai_stand();
};

void() f_stand17 = [55, f_stand18]
{
	ai_stand();
};

void() f_stand18 = [56, f_stand1]
{
	ai_stand();
};

void() f_walk1 = [39, f_walk2]
{
	ai_walkfly(SECRET_NO_SHOOT);
};

void() f_walk2 = [40, f_walk3]
{
	ai_walkfly(SECRET_NO_SHOOT);
};

void() f_walk3 = [41, f_walk4]
{
	ai_walkfly(SECRET_NO_SHOOT);
};

void() f_walk4 = [42, f_walk5]
{
	ai_walkfly(SECRET_NO_SHOOT);
};

void() f_walk5 = [43, f_walk6]
{
	ai_walkfly(SECRET_NO_SHOOT);
};

void() f_walk6 = [44, f_walk7]
{
	ai_walkfly(SECRET_NO_SHOOT);
};

void() f_walk7 = [45, f_walk8]
{
	ai_walkfly(SECRET_NO_SHOOT);
};

void() f_walk8 = [46, f_walk9]
{
	ai_walkfly(SECRET_NO_SHOOT);
};

void() f_walk9 = [47, f_walk10]
{
	ai_walkfly(SECRET_NO_SHOOT);
};

void() f_walk10 = [48, f_walk11]
{
	ai_walkfly(SECRET_NO_SHOOT);
};

void() f_walk11 = [49, f_walk12]
{
	ai_walkfly(SECRET_NO_SHOOT);
};

void() f_walk12 = [50, f_walk13]
{
	ai_walkfly(SECRET_NO_SHOOT);
};

void() f_walk13 = [51, f_walk14]
{
	ai_walkfly(SECRET_NO_SHOOT);
};

void() f_walk14 = [52, f_walk15]
{
	ai_walkfly(SECRET_NO_SHOOT);
};

void() f_walk15 = [53, f_walk16]
{
	ai_walkfly(SECRET_NO_SHOOT);
};

void() f_walk16 = [54, f_walk17]
{
	ai_walkfly(SECRET_NO_SHOOT);
};

void() f_walk17 = [55, f_walk18]
{
	ai_walkfly(SECRET_NO_SHOOT);
};

void() f_walk18 = [56, f_walk1]
{
	ai_walkfly(SECRET_NO_SHOOT);
};

void() f_run1 = [39, f_run2]
{
	ai_swim(TE_EXPLOSION2);
	if (random() < 0.5)
	{
		sound(self, CHAN_VOICE, "fish/idle.wav", SPAWN_CRUCIFIED, ATTN_NORM);
	}
};

void() f_run2 = [41, f_run3]
{
	ai_swim(TE_EXPLOSION2);
};

void() f_run3 = [43, f_run4]
{
	ai_swim(TE_EXPLOSION2);
};

void() f_run4 = [45, f_run5]
{
	ai_swim(TE_EXPLOSION2);
};

void() f_run5 = [47, f_run6]
{
	ai_swim(TE_EXPLOSION2);
};

void() f_run6 = [49, f_run7]
{
	ai_swim(TE_EXPLOSION2);
};

void() f_run7 = [51, f_run8]
{
	ai_swim(TE_EXPLOSION2);
};

void() f_run8 = [53, f_run9]
{
	ai_swim(TE_EXPLOSION2);
};

void() f_run9 = [55, f_run1]
{
	ai_swim(TE_EXPLOSION2);
};

void() fish_melee = 
{
	local vector delta;
	local float ldmg;
	if (!(self.enemy))
	{
		return;
	}
	delta = self.enemy.origin - self.origin;
	if (vlen(delta) > 60)
	{
		return;
	}
	sound(self, CHAN_VOICE, "fish/bite.wav", SPAWN_CRUCIFIED, ATTN_NORM);
	ldmg = (random() + random()) * AS_MELEE;
	T_Damage(self.enemy, self, self, ldmg);
};

void() f_attack1 = [0, f_attack2]
{
	ai_chargeswim(TE_LAVASPLASH);
	self.velocity = VEC_ORIGIN;
};

void() f_attack2 = [1, f_attack3]
{
	ai_chargeswim(TE_LAVASPLASH);
};

void() f_attack3 = [2, f_attack4]
{
	fish_melee();
};

void() f_attack4 = [3, f_attack5]
{
	ai_chargeswim(TE_LAVASPLASH);
};

void() f_attack5 = [4, f_attack6]
{
	ai_chargeswim(TE_LAVASPLASH);
};

void() f_attack6 = [5, f_attack7]
{
	ai_chargeswim(TE_LAVASPLASH);
};

void() f_attack7 = [6, f_attack8]
{
	ai_chargeswim(TE_LAVASPLASH);
};

void() f_attack8 = [7, f_attack9]
{
	ai_chargeswim(TE_LAVASPLASH);
};

void() f_attack9 = [8, f_attack10]
{
	fish_melee();
};

void() f_attack10 = [9, f_attack11]
{
	ai_chargeswim(TE_LAVASPLASH);
};

void() f_attack11 = [10, f_attack12]
{
	ai_chargeswim(TE_LAVASPLASH);
};

void() f_attack12 = [11, f_attack13]
{
	ai_chargeswim(TE_LAVASPLASH);
};

void() f_attack13 = [12, f_attack14]
{
	ai_chargeswim(TE_LAVASPLASH);
};

void() f_attack14 = [13, f_attack15]
{
	ai_chargeswim(TE_LAVASPLASH);
};

void() f_attack15 = [14, f_attack16]
{
	fish_melee();
};

void() f_attack16 = [15, f_attack17]
{
	ai_chargeswim(TE_LAVASPLASH);
};

void() f_attack17 = [16, f_attack18]
{
	ai_chargeswim(TE_LAVASPLASH);
};

void() f_attack18 = [17, f_run1]
{
	ai_chargeswim(TE_LAVASPLASH);
};

void(float spd) fish_floatdown = 
{
	if (self.movetype != MOVETYPE_FLY)
	{
		self.movetype = MOVETYPE_FLY;
	}
	if (self.flags & FL_ONGROUND)
	{
		self.flags = self.flags - (self.flags & FL_ONGROUND);
	}
	self.velocity = self.velocity * 0.5;
	self.velocity_z = spd * CONTENT_SOLID;
};

void() fish_floatup = 
{
	if (self.coiled < SPAWNFLAG_LASER)
	{
		self.avelocity_z = self.avelocity_z * 0.8;
		if (self.movetype != MOVETYPE_FLY)
		{
			self.movetype = MOVETYPE_FLY;
		}
		if (self.flags & FL_ONGROUND)
		{
			self.flags = self.flags - (self.flags & FL_ONGROUND);
		}
		if (pointcontents(self.origin + '0 0 24') == CONTENT_EMPTY)
		{
			self.velocity_z = MSG_BROADCAST;
			if (self.perch == MSG_BROADCAST)
			{
				self.coiled = self.coiled + SPAWN_CRUCIFIED;
				self.perch = SPAWN_CRUCIFIED;
			}
		}
		else
		{
			self.velocity_z = SECRET_YES_SHOOT;
		}
	}
	else
	{
		if (self.coiled >= SPAWNFLAG_LASER)
		{
			self.nextthink = time + 0.5;
			self.aflag = SPAWN_CRUCIFIED - self.aflag;
			if (self.aflag == SPAWN_CRUCIFIED)
			{
				self.velocity_z = CONTENT_EMPTY;
			}
			else
			{
				self.velocity_z = SPAWN_CRUCIFIED;
			}
		}
	}
};

void() f_death1 = [18, f_death2]
{
	self.avelocity_z = TE_LAVASPLASH * random();
	fish_floatup();
	sound(self, CHAN_VOICE, "fish/death.wav", SPAWN_CRUCIFIED, ATTN_NORM);
	if (!(self.corpse_time))
	{
		self.corpse_time = CORPSE_TIME_GLOBAL;
	}
};

void() f_death2 = [19, f_death3]
{
	self.solid = SOLID_NOT;
	fish_floatdown(24);
};

void() f_death3 = [20, f_death4]
{
	fish_floatdown(20);
};

void() f_death4 = [21, f_death5]
{
	fish_floatdown(18);
};

void() f_death5 = [22, f_death6]
{
	fish_floatdown(SECRET_YES_SHOOT);
};

void() f_death6 = [23, f_death7]
{
	fish_floatdown(14);
};

void() f_death7 = [24, f_death8]
{
	fish_floatdown(TE_EXPLOSION2);
};

void() f_death8 = [25, f_death9]
{
	fish_floatdown(TE_LAVASPLASH);
};

void() f_death9 = [26, f_death10]
{
	fish_floatdown(AS_LOITER);
};

void() f_death10 = [27, f_death11]
{
	fish_floatup();
};

void() f_death11 = [28, f_death12]
{
	fish_floatup();
};

void() f_death12 = [29, f_death13]
{
	fish_floatup();
};

void() f_death13 = [30, f_death14]
{
	fish_floatup();
};

void() f_death14 = [31, f_death15]
{
	fish_floatup();
};

void() f_death15 = [32, f_death16]
{
	fish_floatup();
};

void() f_death16 = [33, f_death17]
{
	fish_floatup();
};

void() f_death17 = [34, f_death18]
{
	fish_floatup();
};

void() f_death18 = [35, f_death19]
{
	fish_floatup();
};

void() f_death19 = [36, f_death20]
{
	fish_floatup();
};

void() f_death20 = [37, f_death21]
{
	fish_floatup();
	self.count = time + self.corpse_time;
	self.coiled = self.coiled + SPAWN_CRUCIFIED;
	self.velocity_x = MSG_BROADCAST;
	self.velocity_y = MSG_BROADCAST;
	self.avelocity = VEC_ORIGIN;
};

void() f_death21 = [38, f_death21]
{
	fish_floatup();
	if (self.corpse_time > MSG_BROADCAST)
	{
		if (time > self.count)
		{
			monster_fade();
			self.velocity = '0 0 -6';
		}
	}
	if (self.corpse_time < MSG_BROADCAST)
	{
		if (pointcontents(self.origin + '0 0 45') == CONTENT_SOLID)
		{
			self.velocity = VEC_ORIGIN;
			self.think = f_death_stop;
		}
	}
};

void() f_death_stop = [38, f_death_stop]
{
	self.nextthink = time + 60;
};

void() f_pain1 = [57, f_pain2]
{
	self.velocity = VEC_ORIGIN;
};

void() f_pain2 = [58, f_pain3]
{
	ai_painswim(AS_LOITER);
};

void() f_pain3 = [59, f_pain4]
{
	ai_painswim(AS_LOITER);
};

void() f_pain4 = [60, f_pain5]
{
	ai_painswim(AS_LOITER);
};

void() f_pain5 = [61, f_pain6]
{
	ai_painswim(AS_LOITER);
};

void() f_pain6 = [62, f_pain7]
{
	ai_painswim(AS_LOITER);
};

void() f_pain7 = [63, f_pain8]
{
	ai_painswim(AS_LOITER);
};

void() f_pain8 = [64, f_pain9]
{
	ai_painswim(AS_LOITER);
};

void() f_pain9 = [65, f_run1]
{
	ai_painswim(AS_LOITER);
};

void(entity attacker, float damage) fish_pain = 
{
	f_pain1();
};

void() fish_start = 
{
	local vector org;
	if (!(self.spawnflags & TRIGGER_SPAWNSILENT))
	{
		org = self.origin + SECRET_YES_SHOOT * v_forward;
		spawn_tfog(org);
	}
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/fish.mdl");
	setsize(self, VEC_HULL_MIN, '16 16 24');
	self.health = 25;
	monster_spawn();
	swimmonster_start_go();
};

void() fish_begin = 
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
			self.nextthink = time + 0.1;
		}
	}
	self.think = fish_start;
};

void() monster_fish = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model2("progs/fish.mdl");
	precache_sound2("fish/death.wav");
	precache_sound2("fish/bite.wav");
	precache_sound2("fish/idle.wav");
	self.th_stand = f_stand1;
	self.th_walk = f_walk1;
	self.th_run = f_run1;
	self.th_die = f_death1;
	self.th_pain = fish_pain;
	self.th_melee = f_attack1;
	if (self.spawnflags & TRIGGER_SPAWN)
	{
		self.use = fish_begin;
		total_monsters = total_monsters + SPAWN_CRUCIFIED;
		return;
	}
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/fish.mdl");
	setsize(self, VEC_HULL_MIN, '16 16 24');
	self.health = 25;
	swimmonster_start();
};

