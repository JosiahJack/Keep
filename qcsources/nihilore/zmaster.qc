void() zmaster_stand1 = [0, zmaster_stand2]
{
	zmaster_find_easy_victim();
	if (self.effects != SERVOBOD_NONE)
	{
		sound(self, CHAN_WEAPON, "items/protect2.wav", SERVOBOD_BOTH, ATTN_NORM);
		self.effects = SERVOBOD_NONE;
	}
	if (random() < 0.2)
	{
		zm_idle_sound();
	}
	ai_stand();
};

void() zmaster_stand2 = [1, zmaster_stand3]
{
	ai_stand();
};

void() zmaster_stand3 = [2, zmaster_stand4]
{
	ai_stand();
};

void() zmaster_stand4 = [3, zmaster_stand5]
{
	ai_stand();
};

void() zmaster_stand5 = [4, zmaster_stand6]
{
	ai_stand();
};

void() zmaster_stand6 = [5, zmaster_stand7]
{
	ai_stand();
};

void() zmaster_stand7 = [6, zmaster_stand8]
{
	ai_stand();
};

void() zmaster_stand8 = [7, zmaster_stand9]
{
	ai_stand();
};

void() zmaster_stand9 = [8, zmaster_stand1]
{
	ai_stand();
};

void() zmaster_walk1 = [9, zmaster_walk2]
{
	if (self.effects != SERVOBOD_NONE)
	{
		sound(self, CHAN_WEAPON, "items/protect2.wav", SERVOBOD_BOTH, ATTN_NORM);
		self.effects = SERVOBOD_NONE;
	}
	if (random() < 0.2)
	{
		zm_idle_sound();
	}
	FootFall("zmaster/echo.wav", 0.2, SERVOBOD_BOTH, 0.8);
	ai_walk(SERVOBOD_RIGHT);
};

void() zmaster_walk2 = [10, zmaster_walk3]
{
	ai_walk(SVC_SETVIEWPORT);
};

void() zmaster_walk3 = [11, zmaster_walk4]
{
	ai_walk(SVC_SETVIEWPORT);
};

void() zmaster_walk4 = [12, zmaster_walk5]
{
	ai_walk(SPAWN_DEAD);
};

void() zmaster_walk5 = [13, zmaster_walk6]
{
	ai_walk(SPAWN_DEAD);
};

void() zmaster_walk6 = [14, zmaster_walk7]
{
	ai_walk(SERVOBOD_RIGHT);
};

void() zmaster_walk7 = [15, zmaster_walk8]
{
	ai_walk(SERVOBOD_RIGHT);
};

void() zmaster_walk8 = [16, zmaster_walk9]
{
	ai_walk(SERVOBOD_LEFT);
};

void() zmaster_walk9 = [17, zmaster_walk10]
{
	ai_walk(SERVOBOD_LEFT);
};

void() zmaster_walk10 = [18, zmaster_walk11]
{
	ai_walk(SPAWN_DEAD);
};

void() zmaster_walk11 = [19, zmaster_walk12]
{
	FootFall("zmaster/echo.wav", 0.2, SERVOBOD_BOTH, 0.8);
	ai_walk(SERVOBOD_LEFT);
};

void() zmaster_walk12 = [20, zmaster_walk13]
{
	ai_walk(SPAWN_DEAD);
};

void() zmaster_walk13 = [21, zmaster_walk14]
{
	ai_walk(TE_LIGHTNING2);
};

void() zmaster_walk14 = [22, zmaster_walk15]
{
	ai_walk(SERVOBOD_RIGHT);
};

void() zmaster_walk15 = [23, zmaster_walk16]
{
	ai_walk(SERVOBOD_RIGHT);
};

void() zmaster_walk16 = [24, zmaster_walk17]
{
	ai_walk(SPAWN_DEAD);
};

void() zmaster_walk17 = [25, zmaster_walk18]
{
	ai_walk(SERVOBOD_LEFT);
};

void() zmaster_walk18 = [26, zmaster_walk19]
{
	ai_walk(SERVOBOD_LEFT);
};

void() zmaster_walk19 = [27, zmaster_walk20]
{
	ai_walk(SERVOBOD_LEFT);
};

void() zmaster_walk20 = [28, zmaster_walk1]
{
	ai_walk(SERVOBOD_RIGHT);
};

void() zmaster_pain1 = [37, zmaster_pain2]
{
	sound(self, CHAN_VOICE, "zmaster/pain.wav", SERVOBOD_BOTH, ATTN_NORM);
};

void() zmaster_pain2 = [38, zmaster_pain3]
{
};

void() zmaster_pain3 = [39, zmaster_pain4]
{
};

void() zmaster_pain4 = [40, zmaster_pain5]
{
};

void() zmaster_pain5 = [41, zmaster_run1]
{
};

void() zmaster_die1 = [42, zmaster_die2]
{
	ai_forward(SVC_SETVIEWANGLES);
};

void() zmaster_die2 = [43, zmaster_die3]
{
	ai_forward(SECRET_NO_SHOOT);
};

void() zmaster_die3 = [44, zmaster_die4]
{
	self.solid = SOLID_NOT;
	ai_forward(TE_WIZSPIKE);
};

void() zmaster_die4 = [45, zmaster_die5]
{
};

void() zmaster_die5 = [46, zmaster_die6]
{
};

void() zmaster_die6 = [47, zmaster_die7]
{
};

void() zmaster_die7 = [48, zmaster_die8]
{
};

void() zmaster_die8 = [49, zmaster_die9]
{
	ai_forward(SVC_SETVIEWANGLES);
};

void() zmaster_die9 = [50, zmaster_die10]
{
	ai_forward(STAT_TOTALSECRETS);
};

void() zmaster_die10 = [51, zmaster_die11]
{
};

void() zmaster_die11 = [52, zmaster_die12]
{
};

void() zmaster_die12 = [53, zmaster_die12]
{
};

void() zmaster_dieb1 = [54, zmaster_dieb2]
{
};

void() zmaster_dieb2 = [55, zmaster_dieb3]
{
	self.solid = SOLID_NOT;
};

void() zmaster_dieb3 = [56, zmaster_dieb4]
{
};

void() zmaster_dieb4 = [57, zmaster_dieb5]
{
};

void() zmaster_dieb5 = [58, zmaster_dieb6]
{
};

void() zmaster_dieb6 = [59, zmaster_dieb7]
{
};

void() zmaster_dieb7 = [60, zmaster_dieb8]
{
};

void() zmaster_dieb8 = [61, zmaster_dieb9]
{
};

void() zmaster_dieb9 = [62, zmaster_dieb9]
{
};

void() zmaster_die = 
{
	if (self.health < -40)
	{
		sound(self, CHAN_VOICE, "player/udeath.wav", SERVOBOD_BOTH, ATTN_NORM);
		ThrowHead("progs/h_zmastr.mdl", self.health);
		ThrowGib("progs/h_axzomb.mdl", self.health);
		ThrowGib("progs/h_axzomb.mdl", self.health);
		ThrowGib("progs/h_axzomb.mdl", self.health);
		ThrowGib("progs/zom_gib.mdl", self.health);
		ThrowGib("progs/zom_gib.mdl", self.health);
		ThrowGib("progs/zom_gib.mdl", self.health);
		return;
	}
	sound(self, CHAN_VOICE, "zmaster/death.wav", SERVOBOD_BOTH, ATTN_NORM);
	if (random() > 0.5)
	{
		zmaster_die1();
	}
	else
	{
		zmaster_dieb1();
	}
};

void() zmaster_seeker_hunt = 
{
	self.nextthink = time + 0.1;
	self.gorging = self.gorging + SERVOBOD_BOTH;
	if (self.gorging > SVC_INTERMISSION)
	{
		remove(self);
		return;
	}
	if (visible(self.enemy))
	{
		target_missile(self, self.enemy.origin, SPAWN_DEAD);
	}
};

void() zmaster_start_seeker = 
{
	self.gorging = ceil(random() * 20);
	self.nextthink = time + 0.010000 + random() * 0.5;
	self.think = zmaster_seeker_hunt;
};

void(float offseth, float offsetv) zmaster_shot = 
{
	local entity firemis;
	local vector org;
	local vector vec;
	local vector dir;
	org = self.origin + v_up * SVC_INTERMISSION + v_forward * DOOR_TOGGLE;
	dir_x = 300;
	dir_y = offseth;
	dir_z = offsetv;
	firemis = launch_missile("progs/k_spike.mdl", org, dir);
	setup_missile(firemis, 0.2 + random() * SERVOBOD_RIGHT, zmaster_start_seeker, M_Spike_Touch, SERVOBOD_BOTH, SERVOBOD_BOTH);
	target_missile(firemis, self.enemy.origin, SVC_SETVIEWPORT);
	firemis.enemy = self.enemy;
	sound(self, CHAN_WEAPON, "hknight/attack1.wav", SERVOBOD_BOTH, ATTN_NORM);
};

void() zmaster_find_easy_victim = 
{
	local entity victim;
	local entity enemyold;
	local float curr_dist;
	local float min_dist;
	local float found_one;
	local float vdist;
	enemyold = self.enemy;
	min_dist = 1000;
	found_one = 0;
	victim = nextent(world);
	while (victim)
	{
		if (corpse_status(victim))
		{
			if (visible(victim))
			{
				curr_dist = vlen(self.origin - victim.origin);
				if (curr_dist < min_dist)
				{
					self.enemy = victim;
					found_one = 1;
					min_dist = curr_dist;
				}
			}
		}
		else
		{
			if (victim.classname == "monster_zombie" || victim.classname == "monster_axzombie")
			{
				if (victim.owner == world && visible(victim))
				{
					curr_dist = vlen(self.origin - victim.origin);
					if (curr_dist < min_dist)
					{
						self.enemy = victim;
						found_one = 1;
						min_dist = curr_dist;
					}
				}
			}
		}
		victim = nextent(victim);
	}
	if (found_one && enemyold != self.enemy)
	{
		FoundTarget();
		if (self.effects == SERVOBOD_NONE)
		{
			sound(self, CHAN_WEAPON, "items/protect.wav", SERVOBOD_BOTH, ATTN_NORM);
			self.effects = EF_BRIGHTFIELD;
		}
		self.oldenemy = enemyold;
		sound(self, CHAN_VOICE, "zmaster/toreturn.wav", SERVOBOD_BOTH, ATTN_NORM);
		self.currentammo = time + SPAWN_DEAD;
	}
	return found_one;
};

void() zmaster_run1 = [9, zmaster_run2]
{
	zm_idle_sound();
	FootFall("zmaster/echo.wav", 0.5, SERVOBOD_BOTH, 0.8);
	zmaster_run(SERVOBOD_RIGHT);
};

void() zmaster_run2 = [10, zmaster_run3]
{
	zmaster_run(SVC_SETVIEWPORT);
};

void() zmaster_run3 = [11, zmaster_run4]
{
	zmaster_run(SVC_SETVIEWPORT);
};

void() zmaster_run4 = [12, zmaster_run5]
{
	zmaster_run(SPAWN_DEAD);
};

void() zmaster_run5 = [13, zmaster_run6]
{
	zmaster_run(SPAWN_DEAD);
};

void() zmaster_run6 = [14, zmaster_run7]
{
	zmaster_run(SERVOBOD_RIGHT);
};

void() zmaster_run7 = [15, zmaster_run8]
{
	zmaster_run(SERVOBOD_RIGHT);
};

void() zmaster_run8 = [16, zmaster_run9]
{
	zmaster_run(SERVOBOD_LEFT);
};

void() zmaster_run9 = [17, zmaster_run10]
{
	zmaster_run(SERVOBOD_LEFT);
};

void() zmaster_run10 = [18, zmaster_run11]
{
	zmaster_run(SPAWN_DEAD);
};

void() zmaster_run11 = [19, zmaster_run12]
{
	FootFall("zmaster/echo.wav", 0.5, SERVOBOD_BOTH, 0.8);
	zmaster_run(SERVOBOD_LEFT);
};

void() zmaster_run12 = [20, zmaster_run13]
{
	zmaster_run(SPAWN_DEAD);
};

void() zmaster_run13 = [21, zmaster_run14]
{
	zmaster_run(TE_LIGHTNING2);
};

void() zmaster_run14 = [22, zmaster_run15]
{
	zmaster_run(SERVOBOD_RIGHT);
};

void() zmaster_run15 = [23, zmaster_run16]
{
	zmaster_run(SERVOBOD_RIGHT);
};

void() zmaster_run16 = [24, zmaster_run17]
{
	zmaster_run(SPAWN_DEAD);
};

void() zmaster_run17 = [25, zmaster_run18]
{
	zmaster_run(SERVOBOD_LEFT);
};

void() zmaster_run18 = [26, zmaster_run19]
{
	zmaster_run(SERVOBOD_LEFT);
};

void() zmaster_run19 = [27, zmaster_run20]
{
	zmaster_run(SERVOBOD_LEFT);
};

void() zmaster_run20 = [28, zmaster_run1]
{
	zmaster_run(SERVOBOD_RIGHT);
};

void() zmaster_zombify = 
{
	local entity temp;
	local vector shift;
	temp = self;
	self = self.enemy;
	self.enemy = world;
	if (self.classname != "monster_zombie" && self.classname != "monster_axzombie")
	{
		self.ammo_shells = SERVOBOD_NONE;
		self.solid = SOLID_SLIDEBOX;
		self.movetype = MOVETYPE_STEP;
		setmodel(self, "progs/axzombie.mdl");
		setsize(self, VEC_HULL_MIN, '16 16 40');
		self.takedamage = DAMAGE_AIM;
		self.th_stand = zombie_stand1;
		self.th_walk = zombie_walk1;
		self.th_run = zombie_run1;
		self.th_pain = axzombie_pain;
		self.th_die = zombie_die;
		self.th_missile = zombie_missile;
		self.th_melee = zombie_missile;
		self.classname = "monster_axzombie";
		self.max_health = 400;
		self.health = self.max_health + SERVOBOD_BOTH;
		shift = self.origin + '0 0 8';
		setorigin(self, shift);
		traceline(self.origin, self.origin + '0 0 -60', 1, self);
		while (trace_fraction != SERVOBOD_BOTH)
		{
			shift = self.origin + '0 0 8';
			setorigin(self, shift);
			traceline(self.origin, self.origin + '0 0 -60', 1, self);
		}
		droptofloor();
		zombie_paine14b();
	}
	else
	{
		self.solid = SOLID_SLIDEBOX;
		self.movetype = MOVETYPE_STEP;
		setmodel(self, "progs/axzombie.mdl");
		setsize(self, VEC_HULL_MIN, '16 16 40');
		self.takedamage = DAMAGE_AIM;
		self.th_stand = zombie_stand1;
		self.th_walk = zombie_walk1;
		self.th_run = zombie_run1;
		self.th_pain = axzombie_pain;
		self.th_die = zombie_die;
		self.th_missile = zombie_missile;
		self.th_melee = zombie_missile;
		if (self.classname == "monster_zombie")
		{
			self.classname = "monster_axzombie";
			self.max_health = 400;
		}
		self.health = self.max_health + SERVOBOD_BOTH;
		zombie_painc8b();
	}
	self.owner = temp;
	self.nextthink = time + SERVOBOD_RIGHT;
	self = temp;
	self.wait = time + SERVOBOD_LEFT + random() * SERVOBOD_LEFT;
};

void() zmaster_magica1 = [79, zmaster_magica2]
{
	ai_face();
	if (self.effects != EF_BRIGHTFIELD)
	{
		sound(self, CHAN_WEAPON, "items/protect.wav", SERVOBOD_BOTH, ATTN_NORM);
	}
};

void() zmaster_magica2 = [79, zmaster_magica3]
{
	ai_face();
	self.effects = EF_BRIGHTFIELD;
	self.nextthink = time + 0.25;
};

void() zmaster_magica3 = [79, zmaster_magica4]
{
	self.nextthink = time + 0.5;
	ai_face();
};

void() zmaster_magica4 = [80, zmaster_magica5]
{
	self.nextthink = time + 0.15;
	ai_face();
};

void() zmaster_magica5 = [81, zmaster_magica6]
{
	self.nextthink = time + 0.15;
	ai_face();
};

void() zmaster_magica6 = [82, zmaster_magica7]
{
	self.nextthink = time + 0.15;
	ai_face();
};

void() zmaster_magica7 = [83, zmaster_magica8]
{
	sound(self, CHAN_VOICE, "zmaster/energize.wav", SERVOBOD_BOTH, ATTN_NORM);
	self.nextthink = time + 0.15;
	ai_face();
	self.effects = self.effects | EF_DIMLIGHT;
};

void() zmaster_magica8 = [84, zmaster_magica9]
{
	self.nextthink = time + SERVOBOD_BOTH;
	ai_face();
};

void() zmaster_magica9 = [85, zmaster_magica10]
{
	ai_face();
};

void() zmaster_magica10 = [86, zmaster_magica11]
{
	ai_face();
};

void() zmaster_magica11 = [87, zmaster_magica12]
{
	ai_face();
};

void() zmaster_magica12 = [88, zmaster_magica13]
{
	ai_face();
};

void() zmaster_magica13 = [89, zmaster_magica14]
{
	ai_face();
	if (self.gorging != SERVOBOD_NONE)
	{
		if (range(self.enemy) != RANGE_MELEE)
		{
			self.endtime = 0.1;
			return;
		}
		else
		{
			self.endtime = 0.2;
		}
		if (self.enemy.classname != "player")
		{
			T_KillDamage(self.enemy, self, self);
		}
		else
		{
			T_Damage(self.enemy, self, self, 100);
		}
	}
	else
	{
		zmaster_zombify();
	}
	self.effects = EF_BRIGHTLIGHT + EF_BRIGHTFIELD;
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	if (self.gorging != SERVOBOD_NONE)
	{
		WriteByte(MSG_BROADCAST, TE_EXPLOSION);
	}
	else
	{
		WriteByte(MSG_BROADCAST, TE_TAREXPLOSION);
	}
	WriteCoord(MSG_BROADCAST, self.enemy.origin_x);
	WriteCoord(MSG_BROADCAST, self.enemy.origin_y);
	WriteCoord(MSG_BROADCAST, self.enemy.origin_z);
};

void() zmaster_magica14 = [89, zmaster_magica15]
{
};

void() zmaster_magica15 = [89, zmaster_magica16]
{
	self.effects = EF_DIMLIGHT + EF_BRIGHTFIELD;
};

void() zmaster_magica16 = [89, zmaster_magica17]
{
	self.nextthink = time + 0.75;
};

void() zmaster_magica17 = [90, zmaster_magica18]
{
	self.effects = self.effects - EF_DIMLIGHT;
	self.nextthink = time + self.endtime;
};

void() zmaster_magica18 = [91, zmaster_magica19]
{
	self.nextthink = time + self.endtime;
};

void() zmaster_magica19 = [92, zmaster_magica20]
{
	self.nextthink = time + self.endtime;
};

void() zmaster_magica20 = [79, zmaster_magica21]
{
	self.nextthink = time + self.endtime;
};

void() zmaster_magica21 = [41, zmaster_run1]
{
	if (self.endtime == 0.2)
	{
		self.nextthink = time + SERVOBOD_BOTH;
	}
	else
	{
		self.nextthink = time + 0.3;
	}
};

void() zmaster_magicb1 = [93, zmaster_magicb2]
{
	ai_face();
};

void() zmaster_magicb2 = [94, zmaster_magicb3]
{
	ai_face();
};

void() zmaster_magicb3 = [95, zmaster_magicb4]
{
	ai_face();
};

void() zmaster_magicb4 = [96, zmaster_magicb5]
{
	ai_face();
};

void() zmaster_magicb5 = [97, zmaster_magicb6]
{
	ai_face();
};

void() zmaster_magicb6 = [98, zmaster_magicb7]
{
	ai_face();
};

void() zmaster_magicb7 = [99, zmaster_magicb8]
{
	ai_face();
};

void() zmaster_magicb8 = [100, zmaster_magicb9]
{
	ai_face();
};

void() zmaster_magicb9 = [101, zmaster_magicb10]
{
	zmaster_shot(SERVOBOD_NONE, SECRET_YES_SHOOT);
	zmaster_shot(80, SECRET_YES_SHOOT);
	zmaster_shot(-80, SECRET_YES_SHOOT);
	zmaster_shot(SERVOBOD_NONE, 80);
	zmaster_shot(SERVOBOD_NONE, -64);
	zmaster_shot(50, 80);
	zmaster_shot(-50, 80);
	zmaster_shot(50, -35);
	zmaster_shot(-50, -35);
};

void() zmaster_magicb10 = [102, zmaster_magicb11]
{
	ai_face();
};

void() zmaster_magicb11 = [103, zmaster_magicb12]
{
	ai_face();
};

void() zmaster_magicb12 = [104, zmaster_magicb13]
{
	ai_face();
};

void() zmaster_magicb13 = [105, zmaster_run1]
{
	ai_face();
};

void() zm_idle_sound = 
{
	if (random() < 0.2 && self.currentammo < time)
	{
		if (random() < 0.5)
		{
			sound(self, CHAN_VOICE, "zmaster/idle1.wav", SERVOBOD_BOTH, ATTN_NORM);
			self.currentammo = time + 2.5;
		}
		else
		{
			sound(self, CHAN_VOICE, "zmaster/idle2.wav", SERVOBOD_BOTH, ATTN_NORM);
			self.currentammo = time + 1.5;
		}
	}
};

void() zmaster_missile = 
{
	if (corpse_status(self.enemy))
	{
		return;
	}
	if (self.gorging > time)
	{
		return;
	}
	zmaster_magicb1();
	self.gorging = time + 2.5;
};

void() zmaster_melee = 
{
	if (corpse_status(self.enemy) || self.enemy.classname == "monster_zombie" || self.enemy.classname == "monster_axzombie")
	{
		self.gorging = SERVOBOD_NONE;
		zmaster_magica1();
	}
	else
	{
		if (random() < 0.25)
		{
			self.gorging = time + SVC_SETVIEWPORT;
			zmaster_magica1();
		}
		else
		{
			if (self.gorging > time)
			{
				return;
			}
			zmaster_magicb1();
			self.gorging = time + 1.5;
		}
	}
};

void(entity attacker, float damage) zmaster_pain = 
{
	if (self.pain_finished > time)
	{
		return;
	}
	sound(self, CHAN_VOICE, "zmaster/pain.wav", SERVOBOD_BOTH, ATTN_NORM);
	if (time - self.pain_finished > SVC_SETVIEWPORT)
	{
		zmaster_pain1();
		self.pain_finished = time + SERVOBOD_BOTH;
		return;
	}
	if (random() * 50 > damage)
	{
		return;
	}
	self.pain_finished = time + SERVOBOD_RIGHT;
	zmaster_pain1();
};

void() monster_zombie_master = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model2("progs/zmaster.mdl");
	precache_model2("progs/k_spike.mdl");
	precache_model2("progs/h_zmastr.mdl");
	precache_sound2("hknight/attack1.wav");
	precache_sound2("zmaster/death.wav");
	precache_sound("hknight/hit.wav");
	precache_sound2("hknight/slash1.wav");
	precache_sound2("zmaster/idle1.wav");
	precache_sound2("zmaster/idle2.wav");
	precache_sound2("zmaster/sight.wav");
	precache_sound2("zmaster/pain.wav");
	precache_sound2("zmaster/energize.wav");
	precache_sound2("zmaster/toreturn.wav");
	precache_sound2("zmaster/comnback.wav");
	precache_sound("items/protect.wav");
	precache_sound("items/protect2.wav");
	precache_sound("items/protect3.wav");
	precache_sound("zmaster/echo.wav");
	precache_model("progs/axzombie.mdl");
	precache_model("progs/h_axzomb.mdl");
	precache_model("progs/zom_gib.mdl");
	precache_sound("zombie/z_idle.wav");
	precache_sound("zombie/z_idle1.wav");
	precache_sound("zombie/z_shot1.wav");
	precache_sound("zombie/z_gib.wav");
	precache_sound("zombie/z_pain.wav");
	precache_sound("zombie/z_pain1.wav");
	precache_sound("zombie/z_fall.wav");
	precache_sound("zombie/z_miss.wav");
	precache_sound("zombie/z_hit.wav");
	precache_sound("zombie/idle_w2.wav");
	precache_sound("zombie/trick.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/zmaster.mdl");
	setsize(self, VEC_HULL_MIN, '16 16 40');
	self.health = 1250;
	self.th_stand = zmaster_stand1;
	self.th_walk = zmaster_walk1;
	self.th_run = zmaster_run1;
	self.th_melee = zmaster_melee;
	self.th_missile = zmaster_missile;
	self.th_pain = zmaster_pain;
	self.th_die = zmaster_die;
	if (!(self.gravity))
	{
		self.gravity = SERVOBOD_BOTH;
	}
	else
	{
		self.gravity = (self.gravity - SERVOBOD_BOTH) / 100;
	}
	walkmonster_start();
};

void(float dist) zmaster_run = 
{
	local vector delta;
	local float axis;
	local float direct;
	local float ang_rint;
	local float ang_floor;
	local float ang_ceil;
	local float r;
	movedist = dist;
	if (time > self.wait)
	{
		zmaster_find_easy_victim();
		self.wait = time + 1.5;
	}
	if (self.effects != SERVOBOD_NONE)
	{
		if (self.enemy.classname != "monster_zombie" && self.enemy.classname != "monster_axzombie" && !corpse_status(self.enemy))
		{
			sound(self, CHAN_WEAPON, "items/protect2.wav", SERVOBOD_BOTH, ATTN_NORM);
			self.effects = SERVOBOD_NONE;
		}
	}
	else
	{
		if (self.enemy.classname == "monster_zombie" || self.enemy.classname == "monster_axzombie" && self.enemy.owner != world)
		{
			if (self.oldenemy)
			{
				self.enemy = self.oldenemy;
				self.oldenemy = world;
				FoundTarget();
			}
		}
	}
	if (corpse_status(self.enemy))
	{
		r = vlen(self.enemy.origin - self.origin);
		if (r < 80)
		{
			self.th_melee();
			return;
		}
		if (!visible(self.enemy))
		{
			if (visible(self.oldenemy))
			{
				self.enemy = self.oldenemy;
			}
		}
	}
	if (self.enemy.classname == "headib" || self.enemy.owner != world)
	{
		self.enemy = world;
		if (self.oldenemy.owner != self && (self.oldenemy.health > SERVOBOD_NONE || corpse_status(self.oldenemy)))
		{
			self.enemy = self.oldenemy;
			self.oldenemy = world;
			HuntTarget();
			sound(self, CHAN_VOICE, "zmaster/comnback.wav", SERVOBOD_BOTH, ATTN_NORM);
			self.currentammo = time + 2.5;
		}
		else
		{
			if (self.movetarget)
			{
				self.th_walk();
			}
			else
			{
				self.th_stand();
			}
			return;
		}
	}
	self.show_hostile = time + SERVOBOD_BOTH;
	enemy_vis = visible(self.enemy);
	if (enemy_vis)
	{
		self.search_time = time + SVC_SETVIEWPORT;
	}
	enemy_infront = infront(self.enemy);
	enemy_range = range(self.enemy);
	enemy_yaw = vectoyaw(self.enemy.origin - self.origin);
	if (CheckAnyAttack())
	{
		return;
	}
	movetogoal(dist);
};

float(entity testent) corpse_status = 
{
	if (testent.classname == "corpse")
	{
		return 1;
	}
	else
	{
		if (testent.health <= SERVOBOD_NONE && (testent.flags & (FL_MONSTER | FL_CLIENT)))
		{
			if (testent.classname != "headgib")
			{
				return 1;
			}
		}
		else
		{
			if (testent.classname == "player")
			{
				if (testent.deadflag)
				{
					return 1;
				}
			}
		}
	}
	return 0;
};

