void() skel_run1 = [0, skel_run2]
{
	ai_walk(SVC_CLIENTDATA);
};

void() skel_run2 = [1, skel_run3]
{
	ai_walk(SVC_CLIENTDATA);
};

void() skel_run3 = [2, skel_run4]
{
	ai_walk(SVC_CLIENTDATA);
};

void() skel_run4 = [3, skel_run5]
{
	ai_walk(SVC_CLIENTDATA);
};

void() skel_run5 = [4, skel_run6]
{
	ai_walk(SVC_CLIENTDATA);
};

void() skel_run6 = [5, skel_run1]
{
	ai_walk(SVC_CLIENTDATA);
};

void() skel_stand1 = [6, skel_stand2]
{
	if (self.flags & FL_ONGROUND)
	{
		if (random() < 0.5)
		{
			skeleton_jump();
		}
	}
	ai_stand();
};

void() skel_stand2 = [7, skel_stand3]
{
	ai_stand();
};

void() skel_stand3 = [8, skel_stand4]
{
	ai_stand();
};

void() skel_stand4 = [9, skel_stand5]
{
	ai_stand();
};

void() skel_stand5 = [10, skel_stand6]
{
	ai_stand();
};

void() skel_stand6 = [11, skel_stand7]
{
	ai_stand();
};

void() skel_stand7 = [12, skel_stand8]
{
	ai_stand();
};

void() skel_stand8 = [13, skel_stand9]
{
	ai_stand();
};

void() skel_stand9 = [14, skel_stand10]
{
	ai_stand();
};

void() skel_stand10 = [15, skel_stand11]
{
	ai_stand();
};

void() skel_stand11 = [16, skel_stand12]
{
	ai_stand();
};

void() skel_stand12 = [17, skel_stand13]
{
	ai_stand();
};

void() skel_stand13 = [18, skel_stand14]
{
	ai_stand();
};

void() skel_stand14 = [19, skel_stand15]
{
	ai_stand();
};

void() skel_stand15 = [20, skel_stand16]
{
	ai_stand();
};

void() skel_stand16 = [21, skel_stand17]
{
	ai_stand();
};

void() skel_stand17 = [22, skel_stand18]
{
	ai_stand();
};

void() skel_stand18 = [23, skel_stand19]
{
	ai_stand();
};

void() skel_stand19 = [24, skel_stand20]
{
	ai_stand();
};

void() skel_stand20 = [25, skel_stand21]
{
	ai_stand();
};

void() skel_stand21 = [26, skel_stand22]
{
	ai_stand();
};

void() skel_stand22 = [27, skel_stand1]
{
	ai_stand();
};

void() skel_atk1 = [43, skel_atk2]
{
	sound(self, CHAN_WEAPON, "skeleton/attack.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
};

void() skel_atk2 = [44, skel_atk3]
{
};

void() skel_atk3 = [45, skel_atk4]
{
};

void() skel_atk4 = [46, skel_atk5]
{
	FireMelee(TE_LIGHTNING3, IT_RELIC5, STATE_TOP, SVC_INTERMISSION, STATE_TOP, STATE_TOP, STATE_TOP);
};

void() skel_atk5 = [47, skel_atk6]
{
};

void() skel_atk6 = [48, skel_atk7]
{
};

void() skel_atk7 = [49, skel_atk8]
{
};

void() skel_atk8 = [50, skel_run1]
{
};

void() skel_pain1 = [28, skel_pain2]
{
};

void() skel_pain2 = [29, skel_pain3]
{
};

void() skel_pain3 = [30, skel_pain4]
{
};

void() skel_pain4 = [31, skel_pain5]
{
};

void() skel_pain5 = [32, skel_run1]
{
};

void() skel_particle_think = 
{
	if (self.attack_finished < time)
	{
		remove(self);
	}
	particle(self.origin, no, SVC_LIGHTSTYLE, TE_LIGHTNING2);
	self.nextthink = time + 0.010000;
};

void() skel_particle = 
{
	local entity spark;
	spark = spawn();
	spark.angles_y = random() * 360;
	makevectors(spark.angles);
	spark.velocity = v_forward * 50;
	spark.velocity_z = 250;
	spark.owner = self;
	spark.movetype = MOVETYPE_TOSS;
	spark.solid = SOLID_NOT;
	spark.classname = "spark";
	setmodel(spark, string_null);
	setsize(spark, no, no);
	makevectors(self.angles);
	setorigin(spark, self.origin);
	spark.attack_finished = time + PLAT_LOW_TRIGGER;
	spark.think = skel_particle_think;
	spark.nextthink = time;
};

void() skel_pain = 
{
	skel_particle();
	sound(self, CHAN_BODY, "skeleton/smash.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	skel_pain1();
	monster_pain(self.enemy);
};

void() SkelHead_Touch = 
{
	if (other.solid == SOLID_BSP)
	{
		sound(self, CHAN_BODY, "skeleton/bounce.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	}
};

void() SkelFinal2 = 
{
	local entity head;
	head = spawn();
	head.solid = SOLID_TRIGGER;
	head.movetype = MOVETYPE_BOUNCE;
	head.angles_y = random() * 360;
	makevectors(head.angles);
	head.origin_z = head.origin_z + PLAT_LOW_TRIGGER;
	head.velocity = v_forward * 150 + '0 0 175';
	if (head.flags & FL_ONGROUND)
	{
		head.flags = head.flags - FL_ONGROUND;
	}
	head.touch = SkelHead_Touch;
	head.think = BecomeFlame;
	head.avelocity = crandom() * '0 600 0';
	head.nextthink = time + AS_MELEE;
	setmodel(head, "progs/skelhead.mdl");
	setorigin(head, self.origin);
	setsize(head, '-6 -4 -1', '5 4 7');
	self.think = BecomeFlame;
	self.nextthink = time + 0.1;
};

void() SkelFinal1 = 
{
	sound(self, CHAN_VOICE, "skeleton/death.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	self.think = SkelFinal2;
	self.nextthink = time + 0.010000;
};

void() skel_die1 = [33, skel_die2]
{
	monster_death();
};

void() skel_die2 = [34, skel_die3]
{
	monster_death();
};

void() skel_die3 = [35, skel_die4]
{
	monster_death();
};

void() skel_die4 = [36, skel_die5]
{
	monster_death();
};

void() skel_die5 = [37, skel_die6]
{
	monster_death();
};

void() skel_die6 = [38, skel_die7]
{
	monster_death();
};

void() skel_die7 = [39, skel_die8]
{
	monster_death();
};

void() skel_die8 = [40, skel_die9]
{
	monster_death();
};

void() skel_die9 = [41, skel_die10]
{
	monster_death();
};

void() skel_die10 = [42, skel_die10]
{
	monster_death();
	if (self.flags & FL_ONGROUND)
	{
		sound(self, CHAN_BODY, "skeleton/smash.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
		self.think = SkelFinal1;
		self.nextthink = time + PLAT_LOW_TRIGGER;
	}
};

void() skel_die = 
{
	if (self.gaveexp != 1)
	{
		self.movetype = MOVETYPE_TOSS;
		self.avelocity = '300 300 0';
		self.gaveexp = 1;
		GiveExperience(SVC_SPAWNBASELINE);
	}
	if (self.knockback != IT_RELIC2 && self.knockback != AS_MELEE)
	{
		self.velocity = no;
		self.flags = self.flags - (self.flags & FL_ONGROUND);
		self.velocity = self.velocity + TE_LIGHTNING3 * v_forward * IT_RELIC4;
		self.velocity = self.velocity + 90 * '0 0 3';
	}
	skel_die1();
};

void() skel_jump1 = [51, skel_jump2]
{
	frameskip(0.080000);
};

void() skel_jump2 = [52, skel_jump3]
{
	frameskip(0.080000);
};

void() skel_jump3 = [53, skel_jump4]
{
	frameskip(0.080000);
};

void() skel_jump4 = [54, skel_jump5]
{
	frameskip(0.080000);
};

void() skel_jump5 = [55, skel_jump6]
{
	frameskip(0.080000);
};

void() skel_jump6 = [56, skel_jump7]
{
	frameskip(0.080000);
};

void() skel_jump7 = [57, skel_jump8]
{
	frameskip(0.080000);
};

void() skel_jump8 = [58, skel_jump9]
{
	frameskip(0.080000);
};

void() skel_jump9 = [59, skel_jump10]
{
	frameskip(0.080000);
};

void() skel_jump10 = [60, skel_jump11]
{
	frameskip(0.080000);
};

void() skel_jump11 = [61, skel_jump12]
{
	frameskip(0.080000);
};

void() skel_jump12 = [62, skel_jump12]
{
	if (self.flags & FL_ONGROUND)
	{
		skel_run1();
	}
};

void() skeleton_jump = 
{
	local entity check;
	local entity oself;
	local float cj;
	if (!(self.enemy))
	{
		return;
	}
	if (self.cnt > time)
	{
		return;
	}
	makevectors(self.enemy.angles);
	check = spawn();
	check.movetype = MOVETYPE_STEP;
	setmodel(check, "progs/null.spr");
	setorigin(check, self.origin + v_forward * 200 + v_up * EF_ADDITIVE);
	setsize(check, self.mins, self.maxs);
	oself = self;
	self = check;
	droptofloor();
	cj = walkmove(STATE_TOP, STATE_TOP);
	self = oself;
	if (cj == 1 && (check.flags & FL_ONGROUND) && (self.flags & FL_ONGROUND))
	{
		makevectors(self.angles);
		self.origin_z = self.origin_z + PLAT_LOW_TRIGGER;
		self.velocity = v_forward * 150 + '0 0 300';
		if (self.flags & FL_ONGROUND)
		{
			self.flags = self.flags - FL_ONGROUND;
		}
		skel_jump1();
		sound(self, CHAN_BODY, "player/jump.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
		self.cnt = time + AS_MELEE;
	}
	if (check)
	{
		remove(check);
	}
	return;
};

void() skel_grabbed1 = [29, skel_grabbed2]
{
	self.grab_finished = time + 0.5;
};

void() skel_grabbed2 = [29, skel_grabbed2]
{
	if (self.grab_finished < time || self.grabbed == 0)
	{
		self.th_run();
		return;
	}
};

void() monster_skeleton = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/skeleton.mdl");
	precache_model("progs/skelhead.mdl");
	precache_sound("skeleton/smash.wav");
	precache_sound("skeleton/bounce.wav");
	precache_sound("skeleton/attack.wav");
	precache_sound("skeleton/death.wav");
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/skeleton.mdl");
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	if (difficulty < IT_RELIC2)
	{
		self.health = 160;
	}
	else
	{
		self.health = 240;
	}
	self.netname = "solid";
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_NOT;
	self.classname = "skeleton";
	self.th_stand = skel_stand1;
	self.th_run = skel_run1;
	self.th_melee = skel_atk1;
	self.th_pain = skel_pain;
	self.th_die = skel_die;
	self.noblood = 1;
	self.th_grab = skel_grabbed1;
	self.th_jump = skel_jump1;
	spawn_shadow();
	enemy_start();
};

