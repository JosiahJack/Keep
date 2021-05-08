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
		sound(self, CHAN_VOICE, "soldier/idle.wav", START_OFF, ATTN_IDLE);
	}
	ai_walk(START_OFF);
};

void() army_walk2 = [91, army_walk3]
{
	ai_walk(START_OFF);
};

void() army_walk3 = [92, army_walk4]
{
	ai_walk(START_OFF);
};

void() army_walk4 = [93, army_walk5]
{
	ai_walk(START_OFF);
};

void() army_walk5 = [94, army_walk6]
{
	ai_walk(SILENT);
};

void() army_walk6 = [95, army_walk7]
{
	ai_walk(SVC_UPDATESTAT);
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
	ai_walk(SILENT);
};

void() army_walk10 = [99, army_walk11]
{
	ai_walk(SILENT);
};

void() army_walk11 = [100, army_walk12]
{
	ai_walk(SILENT);
};

void() army_walk12 = [101, army_walk13]
{
	ai_walk(START_OFF);
};

void() army_walk13 = [102, army_walk14]
{
	ai_walk(MSG_BROADCAST);
};

void() army_walk14 = [103, army_walk15]
{
	ai_walk(START_OFF);
};

void() army_walk15 = [104, army_walk16]
{
	ai_walk(START_OFF);
};

void() army_walk16 = [105, army_walk17]
{
	ai_walk(START_OFF);
};

void() army_walk17 = [106, army_walk18]
{
	ai_walk(SVC_UPDATESTAT);
};

void() army_walk18 = [107, army_walk19]
{
	ai_walk(SVC_UPDATESTAT);
};

void() army_walk19 = [108, army_walk20]
{
	ai_walk(SVC_UPDATESTAT);
};

void() army_walk20 = [109, army_walk21]
{
	ai_walk(SVC_UPDATESTAT);
};

void() army_walk21 = [110, army_walk22]
{
	ai_walk(SILENT);
};

void() army_walk22 = [111, army_walk23]
{
	ai_walk(START_OFF);
};

void() army_walk23 = [112, army_walk24]
{
	ai_walk(START_OFF);
};

void() army_walk24 = [113, army_walk1]
{
	ai_walk(START_OFF);
};

void() army_run1 = [73, army_run2]
{
	if (random() < 0.2)
	{
		sound(self, CHAN_VOICE, "soldier/idle.wav", START_OFF, ATTN_IDLE);
	}
	ai_run(STAT_TOTALSECRETS);
};

void() army_run2 = [74, army_run3]
{
	ai_run(15);
};

void() army_run3 = [75, army_run4]
{
	ai_run(SVC_SETVIEWANGLES);
};

void() army_run4 = [76, army_run5]
{
	ai_run(SVC_SETVIEWANGLES);
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
	ai_run(SVC_SETVIEWANGLES);
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
	if (self.classname == "monster_army_rocket")
	{
		ArmyFireRocket();
	}
	else
	{
		if (self.classname == "monster_army_grenade")
		{
			ArmyFireGrenade();
		}
		else
		{
			army_fire();
		}
	}
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
	ai_pain(START_OFF);
};

void() army_painb1 = [46, army_painb2]
{
};

void() army_painb2 = [47, army_painb3]
{
	ai_painforward(13);
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
	ai_pain(SILENT);
};

void() army_painb13 = [58, army_painb14]
{
};

void() army_painb14 = [59, army_run1]
{
};

void() army_painc1 = [60, army_painc2]
{
};

void() army_painc2 = [61, army_painc3]
{
	ai_pain(START_OFF);
};

void() army_painc3 = [62, army_painc4]
{
};

void() army_painc4 = [63, army_painc5]
{
};

void() army_painc5 = [64, army_painc6]
{
	ai_painforward(START_OFF);
};

void() army_painc6 = [65, army_painc7]
{
	ai_painforward(START_OFF);
};

void() army_painc7 = [66, army_painc8]
{
};

void() army_painc8 = [67, army_painc9]
{
	ai_pain(START_OFF);
};

void() army_painc9 = [68, army_painc10]
{
	ai_painforward(SECRET_1ST_DOWN);
};

void() army_painc10 = [69, army_painc11]
{
	ai_painforward(SVC_UPDATESTAT);
};

void() army_painc11 = [70, army_painc12]
{
	ai_painforward(TE_LIGHTNING2);
};

void() army_painc12 = [71, army_painc13]
{
	ai_painforward(SECRET_NO_SHOOT);
};

void() army_painc13 = [72, army_run1]
{
};

void(entity attacker, float damage) army_pain = 
{
	local float r;
	if (self.pain_finished > time)
	{
		return;
	}
	r = random();
	if (r < 0.2)
	{
		self.pain_finished = time + 0.6;
		army_pain1();
		sound(self, CHAN_VOICE, "soldier/pain1.wav", START_OFF, ATTN_NORM);
	}
	else
	{
		if (r < 0.6)
		{
			self.pain_finished = time + 1.1;
			army_painb1();
			sound(self, CHAN_VOICE, "soldier/pain2.wav", START_OFF, ATTN_NORM);
		}
		else
		{
			self.pain_finished = time + 1.1;
			army_painc1();
			sound(self, CHAN_VOICE, "soldier/pain2.wav", START_OFF, ATTN_NORM);
		}
	}
};

void() army_fire = 
{
	local vector dir;
	local entity en;
	ai_face();
	sound(self, CHAN_WEAPON, "soldier/sattck1.wav", START_OFF, ATTN_NORM);
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
	if (self.classname == "monster_army")
	{
		self.ammo_shells = SVC_SETVIEWPORT;
	}
	else
	{
		if (self.classname == "monster_army_rocket")
		{
			self.ammo_rockets = SILENT;
		}
	}
	if (self.classname == "monster_army_grenade")
	{
		self.ammo_rockets = START_OFF;
	}
	if (self.classname == "monster_army_nail")
	{
		self.ammo_nails = SVC_SETVIEWANGLES;
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

void() army_die10 = [17, army_die10]
{
};

void() army_cdie1 = [18, army_cdie2]
{
};

void() army_cdie2 = [19, army_cdie3]
{
	ai_back(SVC_SETVIEWPORT);
};

void() army_cdie3 = [20, army_cdie4]
{
	self.solid = SOLID_NOT;
	if (self.classname == "monster_army")
	{
		self.ammo_shells = SVC_SETVIEWPORT;
	}
	else
	{
		if (self.classname == "monster_army_rocket")
		{
			self.ammo_rockets = SILENT;
		}
	}
	if (self.classname == "monster_army_grenade")
	{
		self.ammo_rockets = START_OFF;
	}
	if (self.classname == "monster_army_nail")
	{
		self.ammo_nails = SVC_SETVIEWANGLES;
	}
	DropBackpack();
	ai_back(SECRET_1ST_DOWN);
};

void() army_cdie4 = [21, army_cdie5]
{
	ai_back(13);
};

void() army_cdie5 = [22, army_cdie6]
{
	ai_back(SVC_UPDATESTAT);
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

void() army_cdie11 = [28, army_cdie11]
{
};

void() army_die = 
{
	if (self.health < -35)
	{
		sound(self, CHAN_VOICE, "player/udeath.wav", START_OFF, ATTN_NORM);
		ThrowHead("progs/h_guard.mdl", self.health);
		ThrowGib("progs/gib1.mdl", self.health);
		ThrowGib("progs/gib2.mdl", self.health);
		ThrowGib("progs/gib3.mdl", self.health);
		return;
	}
	sound(self, CHAN_VOICE, "soldier/death1.wav", START_OFF, ATTN_NORM);
	if (random() < 0.5)
	{
		army_die1();
	}
	else
	{
		army_cdie1();
	}
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
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/soldier.mdl");
	setsize(self, VEC_HULL_MIN, '16 16 40');
	self.health = SVC_INTERMISSION;
	self.th_stand = army_stand1;
	self.th_walk = army_walk1;
	self.th_run = army_run1;
	self.th_missile = army_atk1;
	self.th_pain = army_pain;
	self.th_die = army_die;
	if (!(self.gravity))
	{
		self.gravity = START_OFF;
	}
	else
	{
		self.gravity = (self.gravity - START_OFF) / 100;
	}
	walkmonster_start();
};

void() ArmyFireRocket = 
{
	local entity firemis;
	local vector targ;
	sound(self, CHAN_WEAPON, "weapons/sgun1.wav", START_OFF, ATTN_NORM);
	makevectors(self.angles);
	firemis = launch_missile("progs/missile.mdl", self.origin + v_forward * SECRET_NO_SHOOT + '0 0 16', '1000 0 0');
	setdmg_missile(firemis, 15, 15);
	targ = self.enemy.origin + self.enemy.velocity * (vlen(self.origin - self.enemy.origin) / 1000);
	target_missile(firemis, targ, START_OFF);
};

void() monster_army_rocket = 
{
	monster_army();
	self.health = 115;
	self.skin = SVC_UPDATESTAT;
};

void() ArmyFireGrenade = 
{
	local entity firemis;
	local float rng;
	local vector firevec;
	local vector src;
	self.effects = self.effects | EF_MUZZLEFLASH;
	sound(self, CHAN_WEAPON, "weapons/grenade.wav", START_OFF, ATTN_NORM);
	makevectors(self.angles);
	src = self.origin + v_forward * SECRET_NO_SHOOT + '0 0 16';
	rng = vlen(src - self.enemy.origin);
	firevec_x = rng + 400;
	if (firevec_x > 1000)
	{
		firevec_x = 1000;
	}
	else
	{
		if (firevec_x < 600)
		{
			firevec_x = 600;
		}
	}
	firevec_z = rng * 0.3 + 50;
	if (firevec_z > 500)
	{
		firevec_z = 500;
	}
	firemis = launch_missile("progs/grenade.mdl", src, firevec);
	setdmg_missile(firemis, 20, SVC_SETVIEWANGLES);
	firevec = self.enemy.origin + self.enemy.velocity * (rng / firevec_x) * 0.5;
	target_missile(firemis, firevec, SVC_UPDATESTAT);
};

void() monster_army_grenade = 
{
	monster_army();
	self.health = 110;
	self.skin = SILENT;
};

void(float lead) ArmyFireNail = 
{
	local vector targ;
	sound(self, CHAN_WEAPON, "weapons/rocket1i.wav", START_OFF, ATTN_NORM);
	targ = self.enemy.origin + self.enemy.velocity * (vlen(self.origin - self.enemy.origin) / 1000) * lead;
	newmis = launch_missile("progs/s_spike.mdl", self.origin + '0 0 16', '800 0 0');
	target_missile(newmis, targ, START_OFF);
	setdmg_missile(newmis, SVC_UPDATESTAT, SVC_UPDATESTAT);
};

void() army_nail1 = [81, army_nail2]
{
	ai_face();
};

void() army_nail2 = [82, army_nail3]
{
	ai_face();
};

void() army_nail3 = [83, army_nail4]
{
	ai_face();
};

void() army_nail4 = [84, army_nail5]
{
	ai_face();
};

void() army_nail5 = [85, army_nail6]
{
	ai_face();
	ArmyFireNail(MSG_BROADCAST);
	ArmyFireNail(START_OFF);
	self.effects = self.effects | EF_MUZZLEFLASH;
};

void() army_nail6 = [84, army_nail7]
{
	ai_face();
};

void() army_nail7 = [85, army_nail8]
{
	ai_face();
	ArmyFireNail(MSG_BROADCAST);
	ArmyFireNail(0.8);
	self.effects = self.effects | EF_MUZZLEFLASH;
};

void() army_nail8 = [84, army_nail9]
{
	ai_face();
};

void() army_nail9 = [85, army_nail10]
{
	ai_face();
	ArmyFireNail(MSG_BROADCAST);
	ArmyFireNail(0.6);
	self.effects = self.effects | EF_MUZZLEFLASH;
};

void() army_nail10 = [84, army_nail11]
{
	ai_face();
};

void() army_nail11 = [85, army_nail12]
{
	ai_face();
	ArmyFireNail(MSG_BROADCAST);
	ArmyFireNail(0.4);
	self.effects = self.effects | EF_MUZZLEFLASH;
};

void() army_nail12 = [84, army_nail13]
{
	ai_face();
};

void() army_nail13 = [85, army_nail14]
{
	ai_face();
	ArmyFireNail(MSG_BROADCAST);
	ArmyFireNail(0.2);
	self.effects = self.effects | EF_MUZZLEFLASH;
};

void() army_nail14 = [86, army_nail15]
{
	ai_face();
};

void() army_nail15 = [87, army_nail16]
{
	ai_face();
	SUB_CheckRefire(army_nail1);
};

void() army_nail16 = [88, army_nail17]
{
	ai_face();
};

void() army_nail17 = [89, army_run1]
{
	ai_face();
};

void() monster_army_nail = 
{
	monster_army();
	self.health = 90;
	self.th_missile = army_nail1;
	self.skin = START_OFF;
};

