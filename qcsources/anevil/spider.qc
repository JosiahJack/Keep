void() spid_stand = [0, spid_stand]
{
	ai_stand();
};

void() spid_walk1 = [0, spid_walk2]
{
	if (random() < 0.2)
	{
		sound(self, CHAN_VOICE, "spider/idle.wav", SPAWN_CRUCIFIED, ATTN_IDLE);
	}
	ai_walk(SPAWN_SAC);
};

void() spid_walk2 = [1, spid_walk3]
{
	sound(self, CHAN_VOICE, "spider/tap.wav", SPAWN_CRUCIFIED, ATTN_IDLE);
	ai_walk(SPAWN_SAC);
};

void() spid_walk3 = [2, spid_walk4]
{
	ai_walk(SPAWN_SAC);
};

void() spid_walk4 = [3, spid_walk5]
{
	sound(self, CHAN_VOICE, "spider/tap.wav", SPAWN_CRUCIFIED, ATTN_IDLE);
	ai_walk(SPAWN_SAC);
};

void() spid_walk5 = [4, spid_walk6]
{
	ai_walk(SPAWN_SAC);
};

void() spid_walk6 = [5, spid_walk7]
{
	sound(self, CHAN_VOICE, "spider/tap.wav", SPAWN_CRUCIFIED, ATTN_IDLE);
	ai_walk(SPAWN_SAC);
};

void() spid_walk7 = [6, spid_walk8]
{
	ai_walk(SPAWN_SAC);
};

void() spid_walk8 = [7, spid_walk9]
{
	sound(self, CHAN_VOICE, "spider/tap.wav", SPAWN_CRUCIFIED, ATTN_IDLE);
	ai_walk(SPAWN_SAC);
};

void() spid_walk9 = [8, spid_walk10]
{
	ai_walk(SPAWN_SAC);
};

void() spid_walk10 = [9, spid_walk1]
{
	sound(self, CHAN_VOICE, "spider/tap.wav", SPAWN_CRUCIFIED, ATTN_IDLE);
	ai_walk(SPAWN_SAC);
};

void() spid_run1 = [0, spid_run2]
{
	if (random() < 0.2)
	{
		sound(self, CHAN_VOICE, "spider/idle.wav", SPAWN_CRUCIFIED, ATTN_IDLE);
	}
	ai_run(STAT_TOTALMONSTERS);
};

void() spid_run2 = [2, spid_run3]
{
	sound(self, CHAN_VOICE, "spider/tap.wav", SPAWN_CRUCIFIED, ATTN_IDLE);
	ai_run(STAT_TOTALMONSTERS);
};

void() spid_run3 = [4, spid_run4]
{
	ai_run(STAT_TOTALMONSTERS);
};

void() spid_run4 = [6, spid_run5]
{
	sound(self, CHAN_VOICE, "spider/tap.wav", SPAWN_CRUCIFIED, ATTN_IDLE);
	ai_run(STAT_TOTALMONSTERS);
};

void() spid_run5 = [8, spid_run6]
{
	ai_run(STAT_TOTALMONSTERS);
};

void() spid_run6 = [0, spid_run7]
{
	sound(self, CHAN_VOICE, "spider/tap.wav", SPAWN_CRUCIFIED, ATTN_IDLE);
	ai_run(STAT_TOTALMONSTERS);
};

void() spid_run7 = [2, spid_run8]
{
	ai_run(STAT_TOTALMONSTERS);
};

void() spid_run8 = [4, spid_run9]
{
	sound(self, CHAN_VOICE, "spider/tap.wav", SPAWN_CRUCIFIED, ATTN_IDLE);
	ai_run(STAT_TOTALMONSTERS);
};

void() spid_run9 = [6, spid_run10]
{
	ai_run(STAT_TOTALMONSTERS);
};

void() spid_run10 = [8, spid_run1]
{
	sound(self, CHAN_VOICE, "spider/tap.wav", SPAWN_CRUCIFIED, ATTN_IDLE);
	ai_run(STAT_TOTALMONSTERS);
};

void() spid_melee1 = [0, spid_melee2]
{
	sound(self, CHAN_VOICE, "demon/dhit2.wav", SPAWN_CRUCIFIED, ATTN_NORM);
	ai_charge(STAT_TOTALMONSTERS);
};

void() spid_melee2 = [2, spid_melee3]
{
	ai_charge(STAT_TOTALMONSTERS);
};

void() spid_melee3 = [4, spid_melee4]
{
	ai_charge(STAT_TOTALMONSTERS);
};

void() spid_melee4 = [6, spid_melee5]
{
	ai_charge(STAT_TOTALMONSTERS);
};

void() spid_melee5 = [8, spid_melee6]
{
	ai_charge(STAT_TOTALMONSTERS);
};

void() spid_melee6 = [0, spid_melee7]
{
	ai_charge(STAT_TOTALMONSTERS);
};

void() spid_melee7 = [2, spid_melee8]
{
	ai_charge(STAT_TOTALMONSTERS);
};

void() spid_melee8 = [4, spid_melee9]
{
	ai_charge(STAT_TOTALMONSTERS);
};

void() spid_melee9 = [6, spid_melee10]
{
	ai_charge(STAT_TOTALMONSTERS);
};

void() spid_melee10 = [8, spid_run1]
{
	ai_melee();
};

void() spid_attack1 = [0, spid_attack2]
{
	sound(self, CHAN_VOICE, "spider/attack.wav", SPAWN_CRUCIFIED, ATTN_NORM);
	ai_charge(STAT_TOTALMONSTERS);
};

void() spid_attack2 = [2, spid_attack3]
{
	ai_charge(STAT_TOTALMONSTERS);
};

void() spid_attack3 = [4, spid_attack4]
{
	ai_charge(STAT_TOTALMONSTERS);
};

void() spid_attack4 = [6, spid_attack5]
{
	ai_charge(STAT_TOTALMONSTERS);
};

void() spid_attack5 = [8, spid_attack6]
{
	ai_charge(STAT_TOTALMONSTERS);
};

void() spid_attack6 = [0, spid_attack7]
{
	ai_charge(STAT_TOTALMONSTERS);
};

void() spid_attack7 = [2, spid_attack8]
{
	ai_charge(STAT_TOTALMONSTERS);
};

void() spid_attack8 = [4, spid_attack9]
{
	ai_charge(STAT_TOTALMONSTERS);
};

void() spid_attack9 = [6, spid_attack10]
{
	ai_charge(STAT_TOTALMONSTERS);
};

void() spid_attack10 = [8, spid_run1]
{
	SpiderMissile(MSG_BROADCAST);
};

void() spid_pain1 = [20, spid_pain2]
{
};

void() spid_pain2 = [21, spid_pain3]
{
};

void() spid_pain3 = [22, spid_pain4]
{
};

void() spid_pain4 = [23, spid_pain5]
{
};

void() spid_pain5 = [24, spid_pain6]
{
};

void() spid_pain6 = [25, spid_pain7]
{
};

void() spid_pain7 = [26, spid_pain8]
{
};

void() spid_pain8 = [27, spid_pain9]
{
};

void() spid_pain9 = [28, spid_pain10]
{
};

void() spid_pain10 = [29, spid_pain11]
{
};

void() spid_pain11 = [30, spid_run1]
{
};

void() spid_death1 = [10, spid_death3]
{
};

void() spid_death2 = [10, spid_death3]
{
};

void() spid_death3 = [11, spid_death4]
{
};

void() spid_death4 = [12, spid_death5]
{
};

void() spid_death5 = [13, spid_death6]
{
};

void() spid_death6 = [14, spid_death7]
{
};

void() spid_death7 = [15, spid_death8]
{
};

void() spid_death8 = [16, spid_death9]
{
};

void() spid_death9 = [17, spid_death10]
{
};

void() spid_death10 = [18, spid_death11]
{
};

void() spid_death11 = [19, spid_death11]
{
};

void() spider_pain = 
{
	if (self.pain_finished > time)
	{
		return;
	}
	sound(self, CHAN_VOICE, "spider/pain.wav", SPAWN_CRUCIFIED, ATTN_NORM);
	self.velocity_x = -50 - 50 * random();
	self.velocity_y = MSG_BROADCAST;
	self.velocity_z = MIN_CHARMER_DISTANCE + MIN_CHARMER_DISTANCE * random();
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	spid_pain1();
	self.pain_finished = time + IQ_HIGH;
};

void() spider_die = 
{
	if (self.health < -90)
	{
		sound(self, CHAN_VOICE, "player/udeath.wav", SPAWN_CRUCIFIED, ATTN_NORM);
		ThrowHead("progs/gib2.mdl", self.health, MSG_BROADCAST);
		ThrowGib("progs/gib1.mdl", self.health);
		ThrowGib("progs/gib2.mdl", self.health);
		ThrowGib("progs/gib3.mdl", self.health);
		return;
	}
	sound(self, CHAN_VOICE, "spider/death.wav", SPAWN_CRUCIFIED, ATTN_NORM);
	self.movetype = MOVETYPE_BOUNCE;
	self.velocity_x = -50 + 100 * random();
	self.velocity_y = -50 + 100 * random();
	self.velocity_z = 300 + 300 * random();
	self.avelocity_x = -20 + 40 * random();
	self.avelocity_y = -200 + 400 * random();
	self.avelocity_z = MSG_BROADCAST;
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	spid_death1();
	self.solid = SOLID_NOT;
};

void() CheckSpiderJump = 
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
	if (d > MAX_CHARMER_DISTANCE)
	{
		if (random() < 0.9)
		{
			return 0;
		}
	}
	return 1;
};

void() spider_jump = 
{
	if (!FL_ONGROUND)
	{
		return;
	}
	ai_face();
	makevectors(self.angles);
	self.origin_z = self.origin_z + SPAWN_CRUCIFIED;
	self.velocity = v_forward * MIN_CHARMER_DISTANCE + '0 0 600';
	if (self.flags & FL_ONGROUND)
	{
		self.flags = self.flags - FL_ONGROUND;
	}
};

void() spider_attack = 
{
	if (CheckSpiderJump)
	{
		if (random() < 0.5)
		{
			spider_jump();
		}
	}
	spid_attack1();
};

void(float offset) SpiderMissile = 
{
	local vector offang;
	local vector org;
	local vector vec;
	offang = vectoangles(self.enemy.origin - self.origin);
	offang_y = offang_y + offset * TE_LIGHTNING2;
	makevectors(offang);
	org = self.origin + self.mins + self.size * 0.5 + v_forward * IQ_ULTIMATE;
	vec = normalize(v_forward);
	vec_z = MSG_BROADCAST - vec_z + (random() - 0.5) * 0.1;
	launch_spike(org, vec);
	newmis.classname = "wizspike";
	setmodel(newmis, "progs/w_spike.mdl");
	setsize(newmis, VEC_ORIGIN, VEC_ORIGIN);
	newmis.velocity = vec * 300;
};

void() monster_spider = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model2("progs/spider.mdl");
	precache_model2("progs/w_spike.mdl");
	precache_sound2("spider/tap.wav");
	precache_sound2("spider/attack.wav");
	precache_sound2("demon/dhit2.wav");
	precache_sound2("spider/death.wav");
	precache_sound2("spider/idle.wav");
	precache_sound2("spider/pain.wav");
	precache_sound2("spider/sight.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/spider.mdl");
	setsize(self, VEC_HULL2_MIN, '32 32 5');
	if (!(self.health))
	{
		self.health = MAX_CHARMER_DISTANCE;
	}
	self.th_stand = spid_stand;
	self.th_walk = spid_walk1;
	self.th_run = spid_run1;
	self.th_die = spider_die;
	self.th_pain = spider_pain;
	self.th_missile = spider_attack;
	self.th_melee = spid_melee1;
	self.think = walkmonster_start;
	self.nextthink = time + 0.1 + random() * 0.1;
};

