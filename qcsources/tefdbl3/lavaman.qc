void() LavaManCheckAttack = 
{
	local vector spot1;
	local vector spot2;
	local entity targ;
	ai_face();
	targ = self.enemy;
	spot1 = self.origin + '0 0 64';
	traceline(spot1, targ.origin, 0, self);
	if (trace_inopen && trace_inwater)
	{
		return 0;
	}
	if (trace_ent != targ)
	{
		return 0;
	}
	if (time < self.attack_finished)
	{
		return 0;
	}
	self.th_missile();
	SUB_AttackFinished(1 + random());
	return 1;
};

void() lavaman_hunt = 
{
	local entity possibleEnemy;
	local vector viewPoint;
	if (self.enemy.health <= 0)
	{
		viewPoint = self.origin + '0 0 96';
		possibleEnemy = find(self.enemy, classname, "player");
		traceline(viewPoint, possibleEnemy.origin, 1, world);
		if (trace_fraction == 1)
		{
			self.enemy = possibleEnemy;
		}
	}
	if (self.enemy)
	{
		ai_face();
		self.movetarget = self.enemy;
		self.goalentity = self.enemy;
	}
};

void() lavaman_rise1 = [0, lavaman_rise2]
{
	sound(self, CHAN_WEAPON, "boss1/out1.wav", 1, ATTN_NORM);
};

void() lavaman_rise2 = [1, lavaman_rise3]
{
	sound(self, CHAN_VOICE, "boss1/sight1.wav", 1, ATTN_NORM);
};

void() lavaman_rise3 = [2, lavaman_rise4]
{
};

void() lavaman_rise4 = [3, lavaman_rise5]
{
};

void() lavaman_rise5 = [4, lavaman_rise6]
{
};

void() lavaman_rise6 = [5, lavaman_rise7]
{
};

void() lavaman_rise7 = [6, lavaman_rise8]
{
};

void() lavaman_rise8 = [7, lavaman_rise9]
{
};

void() lavaman_rise9 = [8, lavaman_rise10]
{
};

void() lavaman_rise10 = [9, lavaman_rise11]
{
};

void() lavaman_rise11 = [10, lavaman_rise12]
{
};

void() lavaman_rise12 = [11, lavaman_rise13]
{
};

void() lavaman_rise13 = [12, lavaman_rise14]
{
};

void() lavaman_rise14 = [13, lavaman_rise15]
{
};

void() lavaman_rise15 = [14, lavaman_rise16]
{
};

void() lavaman_rise16 = [15, lavaman_rise17]
{
};

void() lavaman_rise17 = [16, lavaman_fire1]
{
};

void() lavaman_stand = 
{
	if (self.enemy)
	{
		LavaManCheckAttack();
	}
	else
	{
		lavaman_hunt();
	}
	ai_stand();
};

void() lavaman_idle1 = [17, lavaman_idle2]
{
	if (random() < 0.2)
	{
		sound(self, CHAN_VOICE, "boss1/sight1.wav", 1, ATTN_NORM);
	}
};

void() lavaman_idle2 = [18, lavaman_idle3]
{
	lavaman_stand();
};

void() lavaman_idle3 = [19, lavaman_idle4]
{
	lavaman_stand();
};

void() lavaman_idle4 = [20, lavaman_idle5]
{
	lavaman_stand();
};

void() lavaman_idle5 = [21, lavaman_idle6]
{
	lavaman_stand();
};

void() lavaman_idle6 = [20, lavaman_idle7]
{
	lavaman_stand();
};

void() lavaman_idle7 = [19, lavaman_idle8]
{
	lavaman_stand();
};

void() lavaman_idle8 = [18, lavaman_idle9]
{
	lavaman_stand();
};

void() lavaman_idle9 = [17, lavaman_idle1]
{
	lavaman_stand();
};

void() lavaman_walk = 
{
	if (self.enemy)
	{
		LavaManCheckAttack();
	}
	else
	{
		lavaman_hunt();
	}
	ai_walk(FL_SWIM);
};

void() lavaman_walk1 = [17, lavaman_walk2]
{
	lavaman_walk();
};

void() lavaman_walk2 = [18, lavaman_walk3]
{
	lavaman_walk();
};

void() lavaman_walk3 = [19, lavaman_walk4]
{
	lavaman_walk();
};

void() lavaman_walk4 = [20, lavaman_walk5]
{
	lavaman_walk();
};

void() lavaman_walk5 = [21, lavaman_walk6]
{
	lavaman_walk();
};

void() lavaman_walk6 = [22, lavaman_walk7]
{
	lavaman_walk();
};

void() lavaman_walk7 = [23, lavaman_walk8]
{
	lavaman_walk();
};

void() lavaman_walk8 = [24, lavaman_walk9]
{
	lavaman_walk();
};

void() lavaman_walk9 = [25, lavaman_walk10]
{
	lavaman_walk();
};

void() lavaman_walk10 = [26, lavaman_walk11]
{
	lavaman_walk();
};

void() lavaman_walk11 = [27, lavaman_walk12]
{
	lavaman_walk();
};

void() lavaman_walk12 = [28, lavaman_walk13]
{
	lavaman_walk();
};

void() lavaman_walk13 = [29, lavaman_walk14]
{
	lavaman_walk();
};

void() lavaman_walk14 = [30, lavaman_walk15]
{
	lavaman_walk();
};

void() lavaman_walk15 = [31, lavaman_walk16]
{
	lavaman_walk();
};

void() lavaman_walk16 = [32, lavaman_walk17]
{
	lavaman_walk();
};

void() lavaman_walk17 = [33, lavaman_walk18]
{
	lavaman_walk();
};

void() lavaman_walk18 = [34, lavaman_walk19]
{
	lavaman_walk();
};

void() lavaman_walk19 = [35, lavaman_walk20]
{
	lavaman_walk();
};

void() lavaman_walk20 = [36, lavaman_walk21]
{
	lavaman_walk();
};

void() lavaman_walk21 = [37, lavaman_walk22]
{
	lavaman_walk();
};

void() lavaman_walk22 = [38, lavaman_walk23]
{
	lavaman_walk();
};

void() lavaman_walk23 = [39, lavaman_walk24]
{
	lavaman_walk();
};

void() lavaman_walk24 = [40, lavaman_walk25]
{
	lavaman_walk();
};

void() lavaman_walk25 = [41, lavaman_walk26]
{
	lavaman_walk();
};

void() lavaman_walk26 = [42, lavaman_walk27]
{
	lavaman_walk();
};

void() lavaman_walk27 = [43, lavaman_walk28]
{
	lavaman_walk();
};

void() lavaman_walk28 = [44, lavaman_walk29]
{
	lavaman_walk();
};

void() lavaman_walk29 = [45, lavaman_walk30]
{
	lavaman_walk();
};

void() lavaman_walk30 = [46, lavaman_walk31]
{
	lavaman_walk();
};

void() lavaman_walk31 = [47, lavaman_walk1]
{
};

void() lavaman_run = 
{
	if (self.enemy)
	{
		LavaManCheckAttack();
	}
	else
	{
		lavaman_hunt();
	}
	ai_run(FL_SWIM);
};

void() lavaman_run1 = [17, lavaman_run2]
{
	lavaman_run();
};

void() lavaman_run2 = [18, lavaman_run3]
{
	lavaman_run();
};

void() lavaman_run3 = [19, lavaman_run4]
{
	lavaman_run();
};

void() lavaman_run4 = [20, lavaman_run5]
{
	lavaman_run();
};

void() lavaman_run5 = [21, lavaman_run6]
{
	lavaman_run();
};

void() lavaman_run6 = [22, lavaman_run7]
{
	lavaman_run();
};

void() lavaman_run7 = [23, lavaman_run8]
{
	lavaman_run();
};

void() lavaman_run8 = [24, lavaman_run9]
{
	lavaman_run();
};

void() lavaman_run9 = [25, lavaman_run10]
{
	lavaman_run();
};

void() lavaman_run10 = [26, lavaman_run11]
{
	lavaman_run();
};

void() lavaman_run11 = [27, lavaman_run12]
{
	lavaman_run();
};

void() lavaman_run12 = [28, lavaman_run13]
{
	lavaman_run();
};

void() lavaman_run13 = [29, lavaman_run14]
{
	lavaman_run();
};

void() lavaman_run14 = [30, lavaman_run15]
{
	lavaman_run();
};

void() lavaman_run15 = [31, lavaman_run16]
{
	lavaman_run();
};

void() lavaman_run16 = [32, lavaman_run17]
{
	lavaman_run();
};

void() lavaman_run17 = [33, lavaman_run18]
{
	lavaman_run();
};

void() lavaman_run18 = [34, lavaman_run19]
{
	lavaman_run();
};

void() lavaman_run19 = [35, lavaman_run20]
{
	lavaman_run();
};

void() lavaman_run20 = [36, lavaman_run21]
{
	lavaman_run();
};

void() lavaman_run21 = [37, lavaman_run22]
{
	lavaman_run();
};

void() lavaman_run22 = [38, lavaman_run23]
{
	lavaman_run();
};

void() lavaman_run23 = [39, lavaman_run24]
{
	lavaman_run();
};

void() lavaman_run24 = [40, lavaman_run25]
{
	lavaman_run();
};

void() lavaman_run25 = [41, lavaman_run26]
{
	lavaman_run();
};

void() lavaman_run26 = [42, lavaman_run27]
{
	lavaman_run();
};

void() lavaman_run27 = [43, lavaman_run28]
{
	lavaman_run();
};

void() lavaman_run28 = [44, lavaman_run29]
{
	lavaman_run();
};

void() lavaman_run29 = [45, lavaman_run30]
{
	lavaman_run();
};

void() lavaman_run30 = [46, lavaman_run31]
{
	lavaman_run();
};

void() lavaman_run31 = [47, lavaman_run1]
{
};

void() lavaman_fire1 = [57, lavaman_fire2]
{
	ai_face();
};

void() lavaman_fire2 = [58, lavaman_fire3]
{
	ai_charge(1);
};

void() lavaman_fire3 = [59, lavaman_fire4]
{
	ai_face();
};

void() lavaman_fire4 = [60, lavaman_fire5]
{
	ai_face();
};

void() lavaman_fire5 = [61, lavaman_fire6]
{
	ai_charge(1);
};

void() lavaman_fire6 = [62, lavaman_fire7]
{
	ai_face();
};

void() lavaman_fire7 = [63, lavaman_fire8]
{
	lavaman_missile(1);
};

void() lavaman_fire8 = [64, lavaman_fire9]
{
	ai_face();
};

void() lavaman_fire9 = [65, lavaman_fire10]
{
	ai_face();
};

void() lavaman_fire10 = [66, lavaman_fire11]
{
	ai_charge(1);
};

void() lavaman_fire11 = [67, lavaman_fire12]
{
	ai_face();
};

void() lavaman_fire12 = [68, lavaman_fire13]
{
	ai_charge(1);
};

void() lavaman_fire13 = [69, lavaman_fire14]
{
	ai_face();
};

void() lavaman_fire14 = [70, lavaman_fire15]
{
	ai_face();
};

void() lavaman_fire15 = [71, lavaman_fire16]
{
	ai_charge(1);
};

void() lavaman_fire16 = [72, lavaman_fire17]
{
	ai_charge(1);
};

void() lavaman_fire17 = [73, lavaman_fire18]
{
	ai_face();
};

void() lavaman_fire18 = [74, lavaman_fire19]
{
	lavaman_missile(FL_SWIM);
};

void() lavaman_fire19 = [75, lavaman_fire20]
{
	ai_face();
};

void() lavaman_fire20 = [76, lavaman_fire21]
{
	ai_face();
};

void() lavaman_fire21 = [77, lavaman_fire22]
{
	ai_face();
};

void() lavaman_fire22 = [78, lavaman_fire23]
{
	ai_charge(1);
};

void() lavaman_fire23 = [79, lavaman_run1]
{
};

void() lavaman_shocka1 = [80, lavaman_shocka2]
{
};

void() lavaman_shocka2 = [81, lavaman_shocka3]
{
};

void() lavaman_shocka3 = [82, lavaman_shocka4]
{
};

void() lavaman_shocka4 = [83, lavaman_shocka5]
{
};

void() lavaman_shocka5 = [84, lavaman_shocka6]
{
};

void() lavaman_shocka6 = [85, lavaman_shocka7]
{
};

void() lavaman_shocka7 = [86, lavaman_shocka8]
{
};

void() lavaman_shocka8 = [87, lavaman_shocka9]
{
};

void() lavaman_shocka9 = [88, lavaman_shocka10]
{
};

void() lavaman_shocka10 = [89, lavaman_run1]
{
};

void() lavaman_pain = 
{
	if (self.pain_finished > time)
	{
		return;
	}
	if (random() < 0.05)
	{
		self.pain_finished = time + FL_SWIM;
		lavaman_shocka1();
	}
};

void() lavaman_death1 = [48, lavaman_death2]
{
	sound(self, CHAN_VOICE, "boss1/death.wav", 1, ATTN_NORM);
};

void() lavaman_death2 = [49, lavaman_death3]
{
};

void() lavaman_death3 = [50, lavaman_death4]
{
};

void() lavaman_death4 = [51, lavaman_death5]
{
};

void() lavaman_death5 = [52, lavaman_death6]
{
};

void() lavaman_death6 = [53, lavaman_death7]
{
};

void() lavaman_death7 = [54, lavaman_death8]
{
};

void() lavaman_death8 = [55, lavaman_death9]
{
};

void() lavaman_death9 = [56, lavaman_death10]
{
	sound(self, CHAN_BODY, "boss1/out1.wav", 1, ATTN_NORM);
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_LAVASPLASH);
	WriteCoord(MSG_BROADCAST, self.origin_x);
	WriteCoord(MSG_BROADCAST, self.origin_y);
	WriteCoord(MSG_BROADCAST, self.origin_z);
};

void() lavaman_death10 = [56, lavaman_death10]
{
	remove(self);
};

void() lavaman_touch = 
{
	local float damg;
	if (other == self.owner)
	{
		return;
	}
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	damg = 40;
	if (other.health)
	{
		if (other.classname == "monster_shambler")
		{
			damg = damg * 0.5;
		}
		T_Damage(other, self, self.owner, damg);
	}
	T_RadiusDamage(self, self.owner, 40, other);
	self.origin = self.origin - FL_CLIENT * normalize(self.velocity);
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord(MSG_BROADCAST, self.origin_x);
	WriteCoord(MSG_BROADCAST, self.origin_y);
	WriteCoord(MSG_BROADCAST, self.origin_z);
	BecomeExplosion();
};

void(float AttackNumber) lavaman_missile = 
{
	local entity fireball;
	local vector offang;
	local vector org;
	local vector vec;
	local vector d;
	local float t;
	makevectors(self.angles);
	if (AttackNumber == 1)
	{
		org = self.origin + v_forward * 40 + v_right * 65 + v_up * 130;
	}
	else
	{
		if (AttackNumber == FL_SWIM)
		{
			org = self.origin + v_forward * 40 - v_right * 75 + v_up * 125;
		}
	}
	d = self.enemy.origin;
	t = vlen(d - org);
	t = t / 380;
	if (t > 1.75)
	{
		t = 1.75;
	}
	if (t < 1)
	{
		t = 1;
	}
	vec = normalize(d - org);
	fireball = spawn();
	fireball.owner = self;
	fireball.movetype = MOVETYPE_BOUNCE;
	fireball.solid = SOLID_BBOX;
	fireball.angles = vectoangles(vec);
	fireball.touch = lavaman_touch;
	fireball.classname = "lavaman_ball";
	setmodel(fireball, "progs/lavaball.mdl");
	setsize(fireball, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(fireball, org);
	fireball.velocity = vec * 600 * t;
	fireball.velocity_z = fireball.velocity_z + MAX_CHARMER_DISTANCE * t;
	fireball.avelocity = '200 100 300';
	fireball.think = SUB_Remove;
	fireball.nextthink = time + MOVETYPE_TOSS;
	sound(self, CHAN_WEAPON, "boss1/throw.wav", 1, ATTN_NORM);
	if (self.enemy.health <= 0)
	{
		lavaman_idle1();
	}
};

void() lavaman_awake = 
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	self.takedamage = DAMAGE_AIM;
	self.flags = self.flags | FL_MONSTER;
	self.ideal_yaw = self.angles * '0 1 0';
	if (!(self.yaw_speed))
	{
		self.yaw_speed = 20;
	}
	setmodel(self, "progs/lavaman.mdl");
	setsize(self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	self.view_ofs = '0 0 48';
	self.health = 1250 + 250 * cvar("skill");
	self.th_stand = lavaman_idle1;
	self.th_walk = lavaman_walk1;
	self.th_run = lavaman_walk1;
	self.th_missile = lavaman_fire1;
	self.th_pain = lavaman_pain;
	self.th_die = lavaman_death1;
	self.th_melee = lavaman_fire1;
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_LAVASPLASH);
	WriteCoord(MSG_BROADCAST, self.origin_x);
	WriteCoord(MSG_BROADCAST, self.origin_y);
	WriteCoord(MSG_BROADCAST, self.origin_z);
	if (!(activator.items & IT_INVISIBILITY))
	{
		if (!(activator.flags & FL_NOTARGET))
		{
			if (activator.classname == "player")
			{
				self.enemy = activator;
			}
		}
	}
	droptofloor();
	lavaman_rise1();
};

void() monster_lava_man = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/lavaman.mdl");
	precache_model("progs/lavaball.mdl");
	precache_sound("weapons/rocket1i.wav");
	precache_sound("boss1/out1.wav");
	precache_sound("boss1/sight1.wav");
	precache_sound("misc/power.wav");
	precache_sound("boss1/throw.wav");
	precache_sound("boss1/pain.wav");
	precache_sound("boss1/death.wav");
	total_monsters = total_monsters + 1;
	if (self.spawnflags & FL_SWIM)
	{
		self.use = lavaman_awake;
		return;
	}
	lavaman_awake();
};

