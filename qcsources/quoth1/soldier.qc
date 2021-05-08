void() army_stand1 = [0, army_stand2]
{
	ai_stand();
};

void() army_stand2 = [1, army_stand3]
{
	ai_stand();
};

void() army_stand3 = [2, army_stand4]
{
	ai_stand();
};

void() army_stand4 = [3, army_stand5]
{
	ai_stand();
};

void() army_stand5 = [4, army_stand6]
{
	ai_stand();
};

void() army_stand6 = [5, army_stand7]
{
	ai_stand();
};

void() army_stand7 = [6, army_stand8]
{
	ai_stand();
};

void() army_stand8 = [7, army_stand1]
{
	ai_stand();
};

void() army_walk1 = [90, army_walk2]
{
	if (random() < 0.2)
	{
		sound(self, CHAN_VOICE, "soldier/idle.wav", SPAWNFLAG_SUPERSPIKE, ATTN_IDLE);
	}
	ai_walk(SPAWNFLAG_SUPERSPIKE);
};

void() army_walk2 = [91, army_walk3]
{
	ai_walk(SPAWNFLAG_SUPERSPIKE);
};

void() army_walk3 = [92, army_walk4]
{
	ai_walk(SPAWNFLAG_SUPERSPIKE);
};

void() army_walk4 = [93, army_walk5]
{
	ai_walk(SPAWNFLAG_SUPERSPIKE);
};

void() army_walk5 = [94, army_walk6]
{
	ai_walk(SPAWNFLAG_LASER);
};

void() army_walk6 = [95, army_walk7]
{
	ai_walk(AS_MELEE);
};

void() army_walk7 = [96, army_walk8]
{
	ai_walk(SECRET_1ST_DOWN);
};

void() army_walk8 = [97, army_walk9]
{
	ai_walk(SECRET_1ST_DOWN);
};

void() army_walk9 = [98, army_walk10]
{
	ai_walk(SPAWNFLAG_LASER);
};

void() army_walk10 = [99, army_walk11]
{
	ai_walk(SPAWNFLAG_LASER);
};

void() army_walk11 = [100, army_walk12]
{
	ai_walk(SPAWNFLAG_LASER);
};

void() army_walk12 = [101, army_walk13]
{
	ai_walk(SPAWNFLAG_SUPERSPIKE);
};

void() army_walk13 = [102, army_walk14]
{
	ai_walk(MSG_BROADCAST);
};

void() army_walk14 = [103, army_walk15]
{
	ai_walk(SPAWNFLAG_SUPERSPIKE);
};

void() army_walk15 = [104, army_walk16]
{
	ai_walk(SPAWNFLAG_SUPERSPIKE);
};

void() army_walk16 = [105, army_walk17]
{
	ai_walk(SPAWNFLAG_SUPERSPIKE);
};

void() army_walk17 = [106, army_walk18]
{
	ai_walk(AS_MELEE);
};

void() army_walk18 = [107, army_walk19]
{
	ai_walk(AS_MELEE);
};

void() army_walk19 = [108, army_walk20]
{
	ai_walk(AS_MELEE);
};

void() army_walk20 = [109, army_walk21]
{
	ai_walk(AS_MELEE);
};

void() army_walk21 = [110, army_walk22]
{
	ai_walk(SPAWNFLAG_LASER);
};

void() army_walk22 = [111, army_walk23]
{
	ai_walk(SPAWNFLAG_SUPERSPIKE);
};

void() army_walk23 = [112, army_walk24]
{
	ai_walk(SPAWNFLAG_SUPERSPIKE);
};

void() army_walk24 = [113, army_walk1]
{
	ai_walk(SPAWNFLAG_SUPERSPIKE);
};

void() army_run1 = [73, army_run2]
{
	if (random() < 0.2)
	{
		sound(self, CHAN_VOICE, "soldier/idle.wav", SPAWNFLAG_SUPERSPIKE, ATTN_IDLE);
	}
	ai_run(TE_TELEPORT);
};

void() army_run2 = [74, army_run3]
{
	ai_run(15);
};

void() army_run3 = [75, army_run4]
{
	ai_run(TE_LAVASPLASH);
};

void() army_run4 = [76, army_run5]
{
	ai_run(TE_LAVASPLASH);
};

void() army_run5 = [77, army_run6]
{
	ai_run(SECRET_NO_SHOOT);
};

void() army_run6 = [78, army_run7]
{
	ai_run(15);
};

void() army_run7 = [79, army_run8]
{
	ai_run(TE_LAVASPLASH);
};

void() army_run8 = [80, army_run1]
{
	ai_run(SECRET_NO_SHOOT);
};

void() army_atk1 = [81, army_atk2]
{
	ai_face();
};

void() army_atk2 = [82, army_atk3]
{
	ai_face();
};

void() army_atk3 = [83, army_atk4]
{
	ai_face();
};

void() army_atk4 = [84, army_atk5]
{
	ai_face();
};

void() army_atk5 = [85, army_atk6]
{
	ai_face();
	army_fire();
	self.effects = self.effects | EF_MUZZLEFLASH;
};

void() army_atk6 = [86, army_atk7]
{
	ai_face();
};

void() army_atk7 = [87, army_atk8]
{
	ai_face();
	SUB_CheckRefire(army_atk1);
};

void() army_atk8 = [88, army_atk9]
{
	ai_face();
};

void() army_atk9 = [89, army_run1]
{
	ai_face();
};

void() army_rocket_touch = 
{
	local vector org;
	if (other == self.owner)
	{
		return;
	}
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	org = self.origin - SECRET_NO_SHOOT * normalize(self.velocity);
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord(MSG_BROADCAST, org_x);
	WriteCoord(MSG_BROADCAST, org_y);
	WriteCoord(MSG_BROADCAST, org_z);
	sound(self, CHAN_AUTO, "dguard/hit.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	if (other)
	{
		T_RadiusDamage(self, self.owner, 45, other);
		T_Damage(other, self, self.owner, SVC_TEMPENTITY + AS_BLINDFIRE * random());
	}
	else
	{
		T_RadiusDamage(self, self.owner, 45, world);
	}
	self.movetype = MOVETYPE_NONE;
	self.velocity = VEC_ORIGIN;
	self.touch = SUB_Null;
	setmodel(self, "progs/s_explod.spr");
	self.solid = SOLID_NOT;
	s_explode1();
};

void() army_rocket_think = 
{
	local vector dir;
	local vector vtemp;
	self.speed = self.speed + 100;
	self.count = self.count + SPAWNFLAG_SUPERSPIKE;
	if (self.count >= 20)
	{
		army_rocket_touch();
		return;
	}
	self.nextthink = time + 0.1;
	self.think = army_rocket_think;
	if (!visible(self.enemy) || self.enemy.health < SPAWNFLAG_SUPERSPIKE)
	{
		self.velocity = normalize(self.velocity);
		self.velocity = self.velocity * self.speed;
		return;
	}
	self.velocity = self.velocity * 0.15 + (self.enemy.origin - (self.origin + '0 0 -12')) * 0.85;
	self.velocity = normalize(self.velocity);
	self.velocity = self.velocity * self.speed;
	self.angles = vectoangles(self.velocity);
};

void() army_rocket_fire = 
{
	local vector offang;
	local vector org;
	local vector vec;
	local vector lead;
	local vector d;
	local float t;
	local vector spot1;
	local vector spot2;
	local entity targ;
	local float chance;
	local float dgdist;
	newmis = spawn();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLY;
	newmis.solid = SOLID_BBOX;
	org = self.origin + '0 0 8';
	sound(self, CHAN_WEAPON, "soldier/rocket.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	setmodel(newmis, "progs/missile.mdl");
	setsize(newmis, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(newmis, org);
	if (visible(self.enemy))
	{
		vec = self.enemy.origin + '0 0 -8';
	}
	else
	{
		if (!visible(self.enemy))
		{
			vec = self.oldenemyorigin + '0 0 -8';
		}
	}
	vec = normalize(vec - org);
	newmis.enemy = self.enemy;
	newmis.velocity = vec * 200;
	newmis.speed = 250;
	newmis.angles = vectoangles(newmis.velocity);
	newmis.nextthink = time + 0.1;
	newmis.think = army_rocket_think;
	newmis.touch = army_rocket_touch;
	newmis.classname = "army_rocket";
};

void() army_rocket_atk1 = [29, army_rocket_load2]
{
	ai_face();
	sound(self, CHAN_VOICE, "soldier/load.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	ai_shotcheck();
};

void() army_rocket_load2 = [30, army_rocket_load3]
{
	ai_face();
	self.pain_finished = time + 1.3;
	ai_shotcheck();
};

void() army_rocket_load3 = [31, army_rocket_load4]
{
	ai_face();
	ai_shotcheck();
};

void() army_rocket_load4 = [32, army_rocket_load5]
{
	ai_face();
	ai_shotcheck();
};

void() army_rocket_load5 = [33, army_rocket_load6]
{
	ai_face();
	ai_shotcheck();
};

void() army_rocket_load6 = [34, army_rocket_load7]
{
	ai_face();
	ai_shotcheck();
};

void() army_rocket_load7 = [35, army_rocket_load8]
{
	ai_face();
	ai_shotcheck();
};

void() army_rocket_load8 = [36, army_rocket_load9]
{
	ai_face();
	ai_shotcheck();
};

void() army_rocket_load9 = [37, army_rocket_load10]
{
	ai_face();
	ai_shotcheck();
};

void() army_rocket_load10 = [38, army_rocket_load11]
{
	ai_face();
	ai_shotcheck();
};

void() army_rocket_load11 = [39, army_rocket_atk5]
{
	ai_face();
	ai_shotcheck();
	traceline(self.origin + '0 0 8', self.oldenemyorigin, 0, self);
	if (vlen(self.origin - trace_endpos) < TRIGGER_SPAWN)
	{
		self.think = army_run1;
	}
};

void() army_rocket_atk5 = [85, army_rocket_atk6]
{
	ai_face();
	army_rocket_fire();
	ai_shotcheck();
	self.effects = self.effects | EF_MUZZLEFLASH;
};

void() army_rocket_atk6 = [86, army_rocket_atk7]
{
	ai_face();
};

void() army_rocket_atk7 = [87, army_rocket_atk8]
{
	ai_face();
	SUB_CheckRefire(army_rocket_atk1);
};

void() army_rocket_atk8 = [88, army_rocket_atk9]
{
	ai_face();
};

void() army_rocket_atk9 = [89, army_run1]
{
	ai_face();
	SUB_AttackFinished(SPAWNFLAG_SUPERSPIKE + random());
};

void() army_pain1 = [40, army_pain2]
{
};

void() army_pain2 = [41, army_pain3]
{
};

void() army_pain3 = [42, army_pain4]
{
};

void() army_pain4 = [43, army_pain5]
{
};

void() army_pain5 = [44, army_pain6]
{
};

void() army_pain6 = [45, army_run1]
{
	ai_pain(SPAWNFLAG_SUPERSPIKE);
	if (self.classname == "monster_army_rocket")
	{
		self.pain_finished = time + AS_BLINDFIRE;
	}
};

void() army_painb1 = [46, army_painb2]
{
};

void() army_painb2 = [47, army_painb3]
{
	ai_painforward(TE_BEAM);
};

void() army_painb3 = [48, army_painb4]
{
	ai_painforward(TE_LIGHTNING3);
};

void() army_painb4 = [49, army_painb5]
{
};

void() army_painb5 = [50, army_painb6]
{
};

void() army_painb6 = [51, army_painb7]
{
};

void() army_painb7 = [52, army_painb8]
{
};

void() army_painb8 = [53, army_painb9]
{
};

void() army_painb9 = [54, army_painb10]
{
};

void() army_painb10 = [55, army_painb11]
{
};

void() army_painb11 = [56, army_painb12]
{
};

void() army_painb12 = [57, army_painb13]
{
	ai_pain(SPAWNFLAG_LASER);
};

void() army_painb13 = [58, army_painb14]
{
};

void() army_painb14 = [59, army_run1]
{
	if (self.classname == "monster_army_rocket")
	{
		self.pain_finished = time + AS_BLINDFIRE;
	}
};

void() army_painc1 = [60, army_painc2]
{
};

void() army_painc2 = [61, army_painc3]
{
	ai_pain(SPAWNFLAG_SUPERSPIKE);
};

void() army_painc3 = [62, army_painc4]
{
};

void() army_painc4 = [63, army_painc5]
{
};

void() army_painc5 = [64, army_painc6]
{
	ai_painforward(SPAWNFLAG_SUPERSPIKE);
};

void() army_painc6 = [65, army_painc7]
{
	ai_painforward(SPAWNFLAG_SUPERSPIKE);
};

void() army_painc7 = [66, army_painc8]
{
};

void() army_painc8 = [67, army_painc9]
{
	ai_pain(SPAWNFLAG_SUPERSPIKE);
};

void() army_painc9 = [68, army_painc10]
{
	ai_painforward(SECRET_1ST_DOWN);
};

void() army_painc10 = [69, army_painc11]
{
	ai_painforward(AS_MELEE);
};

void() army_painc11 = [70, army_painc12]
{
	ai_painforward(AS_LOITER);
};

void() army_painc12 = [71, army_painc13]
{
	ai_painforward(SECRET_NO_SHOOT);
};

void() army_painc13 = [72, army_run1]
{
	if (self.classname == "monster_army_rocket")
	{
		self.pain_finished = time + AS_BLINDFIRE;
	}
};

void(entity attacker, float damage) army_pain = 
{
	local float r;
	if (self.pain_finished > time)
	{
		return;
	}
	if (self.classname == "monster_army_rocket")
	{
		self.skin = SPAWNFLAG_SUPERSPIKE;
	}
	r = random();
	if (r < 0.2)
	{
		self.pain_finished = time + 0.6;
		army_pain1();
		sound(self, CHAN_VOICE, "soldier/pain1.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	}
	else
	{
		if (r < 0.6)
		{
			self.pain_finished = time + 1.1;
			army_painb1();
			sound(self, CHAN_VOICE, "soldier/pain2.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
		}
		else
		{
			self.pain_finished = time + 1.1;
			army_painc1();
			sound(self, CHAN_VOICE, "soldier/pain2.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
		}
	}
};

void() army_fire = 
{
	local vector dir;
	local entity en;
	ai_face();
	sound(self, CHAN_WEAPON, "soldier/sattck1.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	en = self.enemy;
	dir = en.origin - en.velocity * 0.2;
	dir = normalize(dir - self.origin);
	FireBullets(SECRET_1ST_DOWN, dir, '0.1 0.1 0');
};

void() army_die1 = [8, army_die2]
{
};

void() army_die2 = [9, army_die3]
{
};

void() army_die3 = [10, army_die4]
{
	self.solid = SOLID_NOT;
	if (self.classname == "monster_army_rocket")
	{
		self.ammo_rockets = SPAWNFLAG_SUPERSPIKE;
	}
	else
	{
		self.ammo_shells = AS_BLINDFIRE;
	}
	DropBackpack();
};

void() army_die4 = [11, army_die5]
{
};

void() army_die5 = [12, army_die6]
{
};

void() army_die6 = [13, army_die7]
{
};

void() army_die7 = [14, army_die8]
{
};

void() army_die8 = [15, army_die9]
{
};

void() army_die9 = [16, army_die10]
{
};

void() army_die10 = [17, monster_fade]
{
	self.nextthink = time + 0.1;
};

void() army_cdie1 = [18, army_cdie2]
{
};

void() army_cdie2 = [19, army_cdie3]
{
	ai_back(AS_BLINDFIRE);
};

void() army_cdie3 = [20, army_cdie4]
{
	self.solid = SOLID_NOT;
	if (self.classname == "monster_army_rocket")
	{
		self.ammo_rockets = SPAWNFLAG_SUPERSPIKE;
	}
	else
	{
		self.ammo_shells = AS_BLINDFIRE;
	}
	DropBackpack();
	ai_back(SECRET_1ST_DOWN);
};

void() army_cdie4 = [21, army_cdie5]
{
	ai_back(TE_BEAM);
};

void() army_cdie5 = [22, army_cdie6]
{
	ai_back(AS_MELEE);
};

void() army_cdie6 = [23, army_cdie7]
{
	ai_back(SECRET_1ST_DOWN);
};

void() army_cdie7 = [24, army_cdie8]
{
};

void() army_cdie8 = [25, army_cdie9]
{
};

void() army_cdie9 = [26, army_cdie10]
{
};

void() army_cdie10 = [27, army_cdie11]
{
};

void() army_cdie11 = [28, monster_fade]
{
	self.nextthink = time + 0.1;
};

void() army_die = 
{
	if (self.classname == "monster_army_rocket")
	{
		self.skin = SPAWNFLAG_SUPERSPIKE;
	}
	if (self.health < -35)
	{
		sound(self, CHAN_VOICE, "player/udeath.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
		ThrowHead("progs/h_guard.mdl", self.health);
		ThrowGib("progs/gib1.mdl", self.health);
		ThrowGib("progs/gib2.mdl", self.health);
		ThrowGib("progs/gib3.mdl", self.health);
		return;
	}
	sound(self, CHAN_VOICE, "soldier/death1.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	if (random() < 0.5)
	{
		army_die1();
	}
	else
	{
		army_cdie1();
	}
};

void() army_start = 
{
	local vector org;
	if (!(self.spawnflags & TRIGGER_SPAWNSILENT))
	{
		org = self.origin + SECRET_YES_SHOOT * v_forward;
		spawn_tfog(org);
	}
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/soldier.mdl");
	setsize(self, VEC_HULL_MIN, '16 16 40');
	if (self.classname == "monster_army")
	{
		self.health = SVC_INTERMISSION;
	}
	else
	{
		self.health = 60;
	}
	monster_spawn();
	walkmonster_start_go();
};

void() army_begin = 
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
	self.think = army_start;
};

void() monster_army = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/soldier.mdl");
	precache_model("progs/h_guard.mdl");
	precache_model("progs/gib1.mdl");
	precache_model("progs/gib2.mdl");
	precache_model("progs/gib3.mdl");
	precache_sound("soldier/death1.wav");
	precache_sound("soldier/idle.wav");
	precache_sound("soldier/pain1.wav");
	precache_sound("soldier/pain2.wav");
	precache_sound("soldier/sattck1.wav");
	precache_sound("soldier/sight1.wav");
	precache_sound("player/udeath.wav");
	self.th_stand = army_stand1;
	self.th_walk = army_walk1;
	self.th_run = army_run1;
	self.th_missile = army_atk1;
	self.th_pain = army_pain;
	self.th_die = army_die;
	if (self.spawnflags & TRIGGER_SPAWN)
	{
		self.use = army_begin;
		total_monsters = total_monsters + SPAWNFLAG_SUPERSPIKE;
		return;
	}
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/soldier.mdl");
	setsize(self, VEC_HULL_MIN, '16 16 40');
	self.health = SVC_INTERMISSION;
	walkmonster_start();
};

void() monster_army_rocket = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/soldier.mdl");
	precache_model("progs/h_guard.mdl");
	precache_model("progs/gib1.mdl");
	precache_model("progs/gib2.mdl");
	precache_model("progs/gib3.mdl");
	precache_sound("soldier/death1.wav");
	precache_sound("soldier/idle.wav");
	precache_sound("soldier/pain1.wav");
	precache_sound("soldier/pain2.wav");
	precache_sound("dguard/hit.wav");
	precache_sound("soldier/rocket.wav");
	precache_sound("soldier/load.wav");
	precache_sound("soldier/sight1.wav");
	precache_sound("player/udeath.wav");
	self.th_stand = army_stand1;
	self.th_walk = army_walk1;
	self.th_run = army_run1;
	self.th_missile = army_rocket_atk1;
	self.th_pain = army_pain;
	self.th_die = army_die;
	self.skin = SPAWNFLAG_SUPERSPIKE;
	if (self.spawnflags & TRIGGER_SPAWN)
	{
		self.use = army_begin;
		total_monsters = total_monsters + SPAWNFLAG_SUPERSPIKE;
		return;
	}
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/soldier.mdl");
	setsize(self, VEC_HULL_MIN, '16 16 40');
	self.health = 60;
	walkmonster_start();
};

