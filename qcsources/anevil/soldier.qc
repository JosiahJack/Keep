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
		sound(self, CHAN_VOICE, "soldier/idle.wav", SPAWN_FLOATING, ATTN_IDLE);
	}
	ai_walk(SPAWN_FLOATING);
};

void() army_walk2 = [91, army_walk3]
{
	ai_walk(SPAWN_FLOATING);
};

void() army_walk3 = [92, army_walk4]
{
	ai_walk(SPAWN_FLOATING);
};

void() army_walk4 = [93, army_walk5]
{
	ai_walk(SPAWN_FLOATING);
};

void() army_walk5 = [94, army_walk6]
{
	ai_walk(SPAWN_STATUE);
};

void() army_walk6 = [95, army_walk7]
{
	ai_walk(IQ_HIGH);
};

void() army_walk7 = [96, army_walk8]
{
	ai_walk(SPAWN_KNEEL);
};

void() army_walk8 = [97, army_walk9]
{
	ai_walk(SPAWN_KNEEL);
};

void() army_walk9 = [98, army_walk10]
{
	ai_walk(SPAWN_STATUE);
};

void() army_walk10 = [99, army_walk11]
{
	ai_walk(SPAWN_STATUE);
};

void() army_walk11 = [100, army_walk12]
{
	ai_walk(SPAWN_STATUE);
};

void() army_walk12 = [101, army_walk13]
{
	ai_walk(SPAWN_FLOATING);
};

void() army_walk13 = [102, army_walk14]
{
	ai_walk(MSG_BROADCAST);
};

void() army_walk14 = [103, army_walk15]
{
	ai_walk(SPAWN_FLOATING);
};

void() army_walk15 = [104, army_walk16]
{
	ai_walk(SPAWN_FLOATING);
};

void() army_walk16 = [105, army_walk17]
{
	ai_walk(SPAWN_FLOATING);
};

void() army_walk17 = [106, army_walk18]
{
	ai_walk(IQ_HIGH);
};

void() army_walk18 = [107, army_walk19]
{
	ai_walk(IQ_HIGH);
};

void() army_walk19 = [108, army_walk20]
{
	ai_walk(IQ_HIGH);
};

void() army_walk20 = [109, army_walk21]
{
	ai_walk(IQ_HIGH);
};

void() army_walk21 = [110, army_walk22]
{
	ai_walk(SPAWN_STATUE);
};

void() army_walk22 = [111, army_walk23]
{
	ai_walk(SPAWN_FLOATING);
};

void() army_walk23 = [112, army_walk24]
{
	ai_walk(SPAWN_FLOATING);
};

void() army_walk24 = [113, army_walk1]
{
	ai_walk(SPAWN_FLOATING);
};

void() army_run1 = [73, army_run2]
{
	if (random() < 0.2)
	{
		sound(self, CHAN_VOICE, "soldier/idle.wav", SPAWN_FLOATING, ATTN_IDLE);
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
	ai_run(SPAWN_CUT);
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
	ai_run(SPAWN_CUT);
};

void() army_load1 = [29, army_load2]
{
	ai_face();
};

void() army_load2 = [30, army_load3]
{
	ai_face();
};

void() army_load3 = [31, army_load4]
{
	ai_face();
};

void() army_load4 = [32, army_load5]
{
	ai_face();
};

void() army_load5 = [33, army_load6]
{
	ai_face();
};

void() army_load6 = [34, army_load7]
{
	ai_face();
};

void() army_load7 = [35, army_load8]
{
	ai_face();
};

void() army_load8 = [36, army_load9]
{
	ai_face();
};

void() army_load9 = [37, army_load10]
{
	ai_face();
	if (self.lip == SPAWN_STATUE)
	{
		sound(self, CHAN_WEAPON, "weapons/load2.wav", SPAWN_FLOATING, ATTN_NORM);
	}
	else
	{
		sound(self, CHAN_WEAPON, "weapons/load.wav", SPAWN_FLOATING, ATTN_NORM);
	}
};

void() army_load10 = [38, army_load11]
{
	ai_face();
};

void() army_load11 = [39, army_atk5]
{
	ai_face();
};

void() army_nload1 = [29, army_nload2]
{
	ai_face();
};

void() army_nload2 = [30, army_nload3]
{
	ai_face();
};

void() army_nload3 = [31, army_nload4]
{
	ai_face();
};

void() army_nload4 = [32, army_nload5]
{
	ai_face();
};

void() army_nload5 = [33, army_nload6]
{
	ai_face();
};

void() army_nload6 = [34, army_nload7]
{
	ai_face();
};

void() army_nload7 = [35, army_nload8]
{
	ai_face();
};

void() army_nload8 = [36, army_nload9]
{
	ai_face();
};

void() army_nload9 = [37, army_nload10]
{
	ai_face();
	sound(self, CHAN_WEAPON, "weapons/load.wav", SPAWN_FLOATING, ATTN_NORM);
};

void() army_nload10 = [38, army_nload11]
{
	ai_face();
};

void() army_nload11 = [39, army_natk3]
{
	ai_face();
};

void() army_atk1 = [81, army_atk2]
{
	ai_face();
	monster_movetogoal(15);
	if (random() > 0.8 || self.lip == SPAWN_STATUE)
	{
		army_load1();
	}
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
	if (self.ammo_rockets > MSG_BROADCAST && random() > 0.9)
	{
		self.ammo_rockets = self.ammo_rockets - SPAWN_FLOATING;
		OgreFireGrenade();
	}
	else
	{
		army_fire();
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

void() army_natk1 = [81, army_natk2]
{
	ai_face();
	monster_movetogoal(15);
	if (random() > 0.8)
	{
		army_nload1();
	}
};

void() army_natk2 = [82, army_natk3]
{
	ai_face();
};

void() army_natk3 = [83, army_natk4]
{
	ai_face();
	sound(self, CHAN_WEAPON, "weapons/mgun.wav", SPAWN_FLOATING, ATTN_NORM);
	army_firenails();
	self.effects = self.effects | EF_MUZZLEFLASH;
};

void() army_natk4 = [84, army_natk5]
{
	ai_face();
	army_firenails();
	self.effects = self.effects | EF_MUZZLEFLASH;
};

void() army_natk5 = [85, army_natk6]
{
	ai_face();
	army_firenails();
	self.effects = self.effects | EF_MUZZLEFLASH;
};

void() army_natk6 = [86, army_natk7]
{
	ai_face();
	army_firenails();
	self.effects = self.effects | EF_MUZZLEFLASH;
};

void() army_natk7 = [87, army_natk8]
{
	ai_face();
	SUB_CheckRefire(army_natk1);
};

void() army_natk8 = [88, army_natk9]
{
	ai_face();
};

void() army_natk9 = [89, army_run1]
{
	ai_face();
};

void() army_fatk1 = [81, army_fatk2]
{
	ai_face();
	monster_movetogoal(15);
};

void() army_fatk2 = [82, army_fatk3]
{
	ai_face();
};

void() army_fatk3 = [83, army_fatk4]
{
	ai_face();
};

void() army_fatk4 = [84, army_fatk5]
{
	ai_face();
};

void() army_fatk5 = [85, army_fatk5a]
{
	sound(self, CHAN_WEAPON, "weapons/Flamer1.wav", SPAWN_FLOATING, ATTN_NORM);
	ai_face();
	PM_Army_Flame();
	self.effects = self.effects | EF_MUZZLEFLASH;
};

void() army_fatk5a = [85, army_fatk5b]
{
	ai_face();
	PM_Army_Flame();
	self.effects = self.effects | EF_MUZZLEFLASH;
};

void() army_fatk5b = [85, army_fatk6]
{
	ai_face();
	PM_Army_Flame();
	self.effects = self.effects | EF_MUZZLEFLASH;
};

void() army_fatk6 = [86, army_fatk7]
{
	ai_face();
};

void() army_fatk7 = [87, army_fatk8]
{
	ai_face();
	SUB_CheckRefire(army_fatk1);
};

void() army_fatk8 = [88, army_fatk9]
{
	ai_face();
};

void() army_fatk9 = [89, army_run1]
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
	ai_pain(SPAWN_FLOATING);
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
	ai_pain(SPAWN_STATUE);
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
	ai_pain(SPAWN_FLOATING);
};

void() army_painc3 = [62, army_painc4]
{
};

void() army_painc4 = [63, army_painc5]
{
};

void() army_painc5 = [64, army_painc6]
{
	ai_painforward(SPAWN_FLOATING);
};

void() army_painc6 = [65, army_painc7]
{
	ai_painforward(SPAWN_FLOATING);
};

void() army_painc7 = [66, army_painc8]
{
};

void() army_painc8 = [67, army_painc9]
{
	ai_pain(SPAWN_FLOATING);
};

void() army_painc9 = [68, army_painc10]
{
	ai_painforward(SPAWN_KNEEL);
};

void() army_painc10 = [69, army_painc11]
{
	ai_painforward(IQ_HIGH);
};

void() army_painc11 = [70, army_painc12]
{
	ai_painforward(TE_LIGHTNING2);
};

void() army_painc12 = [71, army_painc13]
{
	ai_painforward(SPAWN_CUT);
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
		sound(self, CHAN_VOICE, "soldier/pain1.wav", SPAWN_FLOATING, ATTN_NORM);
	}
	else
	{
		if (r < 0.6)
		{
			self.pain_finished = time + 1.1;
			army_painb1();
			sound(self, CHAN_VOICE, "soldier/pain2.wav", SPAWN_FLOATING, ATTN_NORM);
		}
		else
		{
			self.pain_finished = time + 1.1;
			army_painc1();
			sound(self, CHAN_VOICE, "soldier/pain2.wav", SPAWN_FLOATING, ATTN_NORM);
		}
	}
};

void() PM_ArmyBurnTouch = 
{
	local entity fire;
	if (other.solid == SOLID_TRIGGER)
	{
		return;
	}
	if (PM_InWater(self))
	{
		PM_MakeSteam(self);
		remove(self);
	}
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	self.owner = self;
	self.effects = self.effects | EF_MUZZLEFLASH;
	PM_BurnRadius(self, 70, TE_LIGHTNING2, SPAWN_KNEEL, 0.1, other);
	self.origin = self.origin - SPAWN_CUT * normalize(self.velocity);
	if (other.takedamage)
	{
		PM_BurnDamage(other, self, TE_LIGHTNING2, TE_LIGHTNING3, 0.2);
	}
	else
	{
		if (random() < 0.2)
		{
			fire = PM_NewFire(self.fireowner, self, self.origin);
			PM_FireDrop(fire, MSG_BROADCAST);
		}
	}
	BecomeExplosion();
};

void() PM_Army_Flame = 
{
	local vector dir;
	local vector org;
	local vector spot;
	ai_face();
	makevectors(self.angles);
	org = self.origin + v_forward * 18 + v_right * TE_LIGHTNING2 + v_up * 14;
	spot = self.enemy.origin;
	spot_x = spot_x + crandom() * 24;
	spot_y = spot_y + crandom() * 24;
	spot_z = spot_z + crandom() * SVC_SETVIEWANGLES;
	dir = normalize(spot - org);
	newmis = PM_NewFire(self, self, org);
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;
	newmis.angles = vectoangles(dir) + '90 0 0';
	newmis.touch = PM_ArmyBurnTouch;
	newmis.nextthink = time;
	newmis.think = PM_CheckFire;
	newmis.burnend = time + TE_LIGHTNING2;
	setsize(newmis, VEC_ORIGIN, VEC_ORIGIN);
	if (PM_InWater(newmis))
	{
		PM_MakeSteam(newmis);
		remove(newmis);
	}
	newmis.velocity = dir * 600;
};

void() army_fire = 
{
	local vector dir;
	local entity en;
	ai_face();
	en = self.enemy;
	dir = en.origin - en.velocity * 0.2;
	dir = normalize(dir - self.origin);
	if (self.lip == SPAWN_FLOATING)
	{
		sound(self, CHAN_WEAPON, "soldier/sattck1.wav", SPAWN_FLOATING, ATTN_NORM);
		FireBullets(SPAWN_KNEEL, dir, '0.1 0.1 0');
	}
	else
	{
		sound(self, CHAN_WEAPON, "weapons/shotgn2.wav", SPAWN_FLOATING, ATTN_NORM);
		FireBullets(14, dir, '0.1 0.1 0');
	}
};

void() army_firenails = 
{
	local vector dir;
	self.attack_finished = time;
	old = self.enemy;
	dir = old.origin - old.velocity * 0.2;
	dir = normalize(dir - self.origin);
	launch_spike(self.origin + '0 0 16', dir);
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
	ai_back(IQ_ULTIMATE);
};

void() army_cdie3 = [20, army_cdie4]
{
	self.solid = SOLID_NOT;
	DropBackpack();
	ai_back(SPAWN_KNEEL);
};

void() army_cdie4 = [21, army_cdie5]
{
	ai_back(13);
};

void() army_cdie5 = [22, army_cdie6]
{
	ai_back(IQ_HIGH);
};

void() army_cdie6 = [23, army_cdie7]
{
	ai_back(SPAWN_KNEEL);
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
	if (self.lip == SPAWN_KNEEL)
	{
		self.health = -100;
		sound(self, CHAN_WEAPON, "weapons/r_exp3.wav", SPAWN_FLOATING, ATTN_NORM);
		sound(self, CHAN_VOICE, "player/udeath.wav", SPAWN_FLOATING, ATTN_NORM);
		ThrowHead("progs/skull.mdl", self.health, self.skin);
		ThrowGib("progs/gib1.mdl", self.health);
		ThrowGib("progs/gib2.mdl", self.health);
		ThrowGib("progs/gib3.mdl", self.health);
		self.classname = "explo_grunt";
		T_RadiusDamage(self, self, 100, world);
		particle(self.origin, VEC_ORIGIN, 75, 255);
		self.origin_z = self.origin_z + DOOR_TOGGLE;
		BecomeExplosion();
		return;
	}
	if (self.health < -35)
	{
		sound(self, CHAN_VOICE, "player/udeath.wav", SPAWN_FLOATING, ATTN_NORM);
		sound(self, CHAN_WEAPON, "weapons/load.wav", SPAWN_FLOATING, ATTN_NORM);
		ThrowHead("progs/skull.mdl", self.health, self.skin);
		ThrowGib("progs/gib1.mdl", self.health);
		ThrowGib("progs/gib2.mdl", self.health);
		ThrowGib("progs/gib3.mdl", self.health);
		return;
	}
	sound(self, CHAN_WEAPON, "weapons/load.wav", SPAWN_FLOATING, ATTN_NORM);
	sound(self, CHAN_VOICE, "soldier/death1.wav", SPAWN_FLOATING, ATTN_NORM);
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
	local float rrrump;
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/soldier.mdl");
	precache_model("progs/skull.mdl");
	precache_model("progs/gib1.mdl");
	precache_model("progs/gib2.mdl");
	precache_model("progs/gib3.mdl");
	precache_sound("soldier/death1.wav");
	precache_sound("soldier/idle.wav");
	precache_sound("soldier/pain1.wav");
	precache_sound("soldier/pain2.wav");
	precache_sound("soldier/sattck1.wav");
	precache_sound("soldier/sight1.wav");
	precache_sound("hknight/hit.wav");
	precache_sound("weapons/load.wav");
	precache_sound("player/udeath.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/soldier.mdl");
	rrrump = random() * SVC_SETVIEWANGLES;
	if (self.lip > SPAWN_KNEEL)
	{
		self.lip = MSG_BROADCAST;
	}
	if (!(self.lip))
	{
		if (rrrump > TE_WIZSPIKE)
		{
			self.lip = SPAWN_FLOATING;
		}
		else
		{
			if (rrrump > SPAWN_KNEEL)
			{
				self.lip = IQ_HIGH;
			}
			else
			{
				if (rrrump > SPAWN_STATUE)
				{
					self.lip = SPAWN_STATUE;
				}
				else
				{
					self.lip = SPAWN_KNEEL;
				}
			}
		}
	}
	setsize(self, VEC_HULL_MIN, '16 16 40');
	if (!(self.health))
	{
		self.health = 80;
	}
	self.crit = SVC_SETVIEWANGLES;
	self.th_stand = army_stand1;
	self.th_walk = army_walk1;
	self.th_run = army_run1;
	if (self.lip == SPAWN_FLOATING)
	{
		self.th_missile = army_atk1;
		self.ammo_shells = 20;
		self.ammo_rockets = SPAWN_FLOATING;
	}
	if (self.lip == SPAWN_STATUE)
	{
		self.th_missile = army_atk1;
		self.ammo_shells = 20;
		precache_sound("weapons/load2.wav");
	}
	if (self.lip == IQ_HIGH)
	{
		precache_sound("weapons/mgun.wav");
		self.th_missile = army_natk1;
		self.ammo_nails = 25;
	}
	if (self.lip == SPAWN_KNEEL)
	{
		self.th_missile = army_fatk1;
		precache_sound("weapons/Flamer1.wav");
		precache_sound("weapons/Flamer2.wav");
		precache_sound("weapons/r_exp3.wav");
		precache_model("progs/flame2.mdl");
	}
	self.th_pain = army_pain;
	self.th_die = army_die;
	walkmonster_start();
};

void() monster_nazi = 
{
	monster_army();
};

