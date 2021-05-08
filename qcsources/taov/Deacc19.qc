void() zombie_stand1 = [0, zombie_stand2]
{
	ai_stand();
};

void() zombie_stand2 = [1, zombie_stand3]
{
	if (random() < 0.010000)
	{
		if (random() < 0.5)
		{
			sound(self, CHAN_VOICE, "zombie/idle1.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
		}
		else
		{
			sound(self, CHAN_VOICE, "zombie/idle2.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
		}
	}
	ai_stand();
};

void() zombie_stand3 = [2, zombie_stand4]
{
	ai_stand();
};

void() zombie_stand4 = [3, zombie_stand5]
{
	ai_stand();
};

void() zombie_stand5 = [4, zombie_stand6]
{
	ai_stand();
};

void() zombie_stand6 = [5, zombie_stand7]
{
	ai_stand();
};

void() zombie_stand7 = [6, zombie_stand8]
{
	ai_stand();
};

void() zombie_stand8 = [7, zombie_stand9]
{
	ai_stand();
};

void() zombie_stand9 = [8, zombie_stand10]
{
	ai_stand();
};

void() zombie_stand10 = [9, zombie_stand11]
{
	ai_stand();
};

void() zombie_stand11 = [10, zombie_stand12]
{
	ai_stand();
};

void() zombie_stand12 = [11, zombie_stand13]
{
	ai_stand();
};

void() zombie_stand13 = [12, zombie_stand14]
{
	ai_stand();
};

void() zombie_stand14 = [13, zombie_stand15]
{
	ai_stand();
};

void() zombie_stand15 = [14, zombie_stand1]
{
	ai_stand();
};

void() zombie_run1 = [15, zombie_run2]
{
	ai_walk(TE_LIGHTNING1);
};

void() zombie_run2 = [16, zombie_run3]
{
	ai_walk(TE_LIGHTNING1);
};

void() zombie_run3 = [17, zombie_run4]
{
	ai_walk(TE_LIGHTNING1);
};

void() zombie_run4 = [18, zombie_run5]
{
	ai_walk(TE_LIGHTNING1);
};

void() zombie_run5 = [19, zombie_run6]
{
	ai_walk(TE_LIGHTNING1);
};

void() zombie_run6 = [20, zombie_run7]
{
	ai_walk(TE_LIGHTNING1);
};

void() zombie_run7 = [21, zombie_run8]
{
	ai_walk(TE_LIGHTNING1);
};

void() zombie_run8 = [22, zombie_run9]
{
	ai_walk(TE_LIGHTNING1);
};

void() zombie_run9 = [23, zombie_run10]
{
	ai_walk(TE_LIGHTNING1);
};

void() zombie_run10 = [24, zombie_run11]
{
	ai_walk(TE_LIGHTNING1);
};

void() zombie_run11 = [25, zombie_run12]
{
	ai_walk(TE_LIGHTNING1);
};

void() zombie_run12 = [26, zombie_run13]
{
	ai_walk(TE_LIGHTNING1);
};

void() zombie_run13 = [27, zombie_run14]
{
	ai_walk(TE_LIGHTNING1);
};

void() zombie_run14 = [28, zombie_run15]
{
	ai_walk(TE_LIGHTNING1);
};

void() zombie_run15 = [29, zombie_run16]
{
	ai_walk(TE_LIGHTNING1);
};

void() zombie_run16 = [30, zombie_run17]
{
	ai_walk(TE_LIGHTNING1);
};

void() zombie_run17 = [31, zombie_run18]
{
	ai_walk(TE_LIGHTNING1);
};

void() zombie_run18 = [32, zombie_run1]
{
	ai_walk(TE_LIGHTNING1);
};

void() DarkBallRemove = 
{
	if (self.state == STATE_TOP)
	{
		sound(self, CHAN_AUTO, "spells/dbhit.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
		self.state = PLAT_LOW_TRIGGER;
	}
	if (self.cnt == PLAT_LOW_TRIGGER)
	{
		self.scale = self.scale + 0.05;
		setorigin(self, self.enemy.origin);
	}
	else
	{
		self.scale = self.scale - 0.05;
	}
	self.alpha = self.alpha - 0.010000;
	if (self.alpha < 0.1)
	{
		remove(self);
		return;
	}
	frameskip(0.010000);
};

void() DarkBallThink = 
{
	local entity head;
	local vector view;
	MakeSolidList();
	head = searchradius(self.origin, SVC_SIGNONNUM);
	while (head)
	{
		if (head.takedamage && self.owner != head && head == self.enemy)
		{
			if (head.block_finished < time)
			{
				if (head.classname != "zombieboss")
				{
					T_Damage(head, self.owner, self.owner, IT_RELIC3);
				}
				else
				{
					head.health = head.health + IT_RELIC4;
					if (head.health > head.max_health / IT_RELIC2)
					{
						head.health = head.max_health / IT_RELIC2;
					}
				}
			}
			else
			{
				view = vectoangles(head.origin - self.origin);
				self.angles_y = view_y;
				if (self.angles_y > 90 && self.angles_y < 270)
				{
					head.angles_y = STATE_TOP;
				}
				else
				{
					head.angles_y = 180;
				}
			}
			self.cnt = PLAT_LOW_TRIGGER;
			self.velocity = no;
			setorigin(self, head.origin);
			self.enemy = head;
			self.think = DarkBallRemove;
			self.nextthink = time + 0.1;
			return;
		}
		head = head.chain;
	}
	UnmakeSolidList();
	if (self.enemy == world || self.velocity == no || self.origin == self.oldorigin || self.enemy.health <= STATE_TOP)
	{
		remove(self);
		return;
	}
	if (self.fireballhome_finished < time)
	{
		self.velocity_x = self.velocity_x / IT_RELIC2;
		self.velocity_y = self.velocity_y / IT_RELIC2;
		self.fireballhome_finished = time + PLAT_LOW_TRIGGER;
	}
	if (self.origin_x < self.enemy.origin_x)
	{
		self.velocity_x = self.velocity_x + TE_LAVASPLASH * frametime * 75;
	}
	if (self.origin_x > self.enemy.origin_x)
	{
		self.velocity_x = self.velocity_x - TE_LAVASPLASH * frametime * 75;
	}
	if (self.origin_y < self.enemy.origin_y)
	{
		self.velocity_y = self.velocity_y + TE_LAVASPLASH * frametime * 75;
	}
	if (self.origin_y > self.enemy.origin_y)
	{
		self.velocity_y = self.velocity_y - TE_LAVASPLASH * frametime * 75;
	}
	if (self.origin_z < self.enemy.origin_z)
	{
		self.velocity_z = self.velocity_z + TE_LAVASPLASH * frametime * 75;
	}
	if (self.origin_z > self.enemy.origin_z)
	{
		self.velocity_z = self.velocity_z - TE_LAVASPLASH * frametime * 75;
	}
	if (self.flags & FL_ONGROUND)
	{
		self.flags = self.flags - FL_ONGROUND;
	}
	self.oldorigin = self.origin;
	self.nextthink = time + 0.010000;
};

void(float hight) Darkball = 
{
	local entity missile;
	makevectors(self.angles);
	sound(self, CHAN_WEAPON, "spells/dbfire.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_SLIDEBOX;
	missile.classname = "darkball";
	makevectors(self.angles);
	missile.velocity = aim(self, 350);
	missile.velocity = missile.velocity * 350;
	missile.angles = vectoangles(missile.velocity);
	missile.avelocity = '600 300 150';
	missile.scale = PLAT_LOW_TRIGGER;
	missile.alpha = PLAT_LOW_TRIGGER;
	missile.enemy = self.enemy;
	missile.touch = DarkBallRemove;
	missile.think = DarkBallThink;
	missile.nextthink = time + 0.1;
	setmodel(missile, "progs/darkball.mdl");
	setsize(missile, no, no);
	setorigin(missile, self.origin + v_forward * IT_RELIC4 + v_up * hight);
};

void() zombie_atta1 = [33, zombie_atta2]
{
};

void() zombie_atta2 = [34, zombie_atta3]
{
};

void() zombie_atta3 = [35, zombie_atta4]
{
};

void() zombie_atta4 = [36, zombie_atta5]
{
};

void() zombie_atta5 = [37, zombie_atta6]
{
};

void() zombie_atta6 = [38, zombie_atta7]
{
};

void() zombie_atta7 = [39, zombie_atta8]
{
};

void() zombie_atta8 = [40, zombie_atta9]
{
};

void() zombie_atta9 = [41, zombie_atta10]
{
};

void() zombie_atta10 = [42, zombie_atta11]
{
};

void() zombie_atta11 = [43, zombie_atta12]
{
};

void() zombie_atta12 = [44, zombie_atta13]
{
};

void() zombie_atta13 = [45, zombie_run1]
{
	Darkball(IT_RELIC4);
};

void() zombie_attb1 = [46, zombie_attb2]
{
};

void() zombie_attb2 = [47, zombie_attb3]
{
};

void() zombie_attb3 = [48, zombie_attb4]
{
};

void() zombie_attb4 = [49, zombie_attb5]
{
};

void() zombie_attb5 = [50, zombie_attb6]
{
};

void() zombie_attb6 = [51, zombie_attb7]
{
};

void() zombie_attb7 = [52, zombie_attb8]
{
};

void() zombie_attb8 = [53, zombie_attb9]
{
};

void() zombie_attb9 = [54, zombie_attb10]
{
};

void() zombie_attb10 = [55, zombie_attb11]
{
};

void() zombie_attb11 = [56, zombie_attb12]
{
};

void() zombie_attb12 = [57, zombie_attb13]
{
};

void() zombie_attb13 = [58, zombie_attb14]
{
};

void() zombie_attb14 = [59, zombie_run1]
{
	Darkball(IT_RELIC4);
};

void() zombie_attc1 = [60, zombie_attc2]
{
};

void() zombie_attc2 = [61, zombie_attc3]
{
};

void() zombie_attc3 = [62, zombie_attc4]
{
};

void() zombie_attc4 = [63, zombie_attc5]
{
};

void() zombie_attc5 = [64, zombie_attc6]
{
};

void() zombie_attc6 = [65, zombie_attc7]
{
};

void() zombie_attc7 = [66, zombie_attc8]
{
};

void() zombie_attc8 = [67, zombie_attc9]
{
};

void() zombie_attc9 = [68, zombie_attc10]
{
};

void() zombie_attc10 = [69, zombie_attc11]
{
};

void() zombie_attc11 = [70, zombie_attc12]
{
};

void() zombie_attc12 = [71, zombie_run1]
{
	Darkball(IT_RELIC5);
};

void() zombie_missile = 
{
	if (random() < 0.33)
	{
		zombie_atta1();
	}
	else
	{
		if (random() < 0.66)
		{
			zombie_attb1();
		}
		else
		{
			zombie_attc1();
		}
	}
};

void() zombie_paina1 = [72, zombie_paina2]
{
};

void() zombie_paina2 = [73, zombie_paina3]
{
};

void() zombie_paina3 = [74, zombie_paina4]
{
};

void() zombie_paina4 = [75, zombie_paina5]
{
};

void() zombie_paina5 = [76, zombie_paina6]
{
};

void() zombie_paina6 = [77, zombie_paina7]
{
};

void() zombie_paina7 = [78, zombie_paina8]
{
};

void() zombie_paina8 = [79, zombie_paina9]
{
};

void() zombie_paina9 = [80, zombie_paina10]
{
};

void() zombie_paina10 = [81, zombie_paina11]
{
};

void() zombie_paina11 = [82, zombie_paina12]
{
};

void() zombie_paina12 = [83, zombie_run1]
{
};

void() zombie_painb1 = [84, zombie_painb2]
{
};

void() zombie_painb2 = [85, zombie_painb3]
{
};

void() zombie_painb3 = [86, zombie_painb4]
{
};

void() zombie_painb4 = [87, zombie_painb5]
{
};

void() zombie_painb5 = [88, zombie_painb6]
{
};

void() zombie_painb6 = [89, zombie_painb7]
{
};

void() zombie_painb7 = [90, zombie_painb8]
{
};

void() zombie_painb8 = [91, zombie_painb9]
{
};

void() zombie_painb9 = [92, zombie_painb10]
{
};

void() zombie_painb10 = [93, zombie_painb11]
{
};

void() zombie_painb11 = [94, zombie_painb12]
{
};

void() zombie_painb12 = [95, zombie_painb13]
{
};

void() zombie_painb13 = [96, zombie_painb14]
{
};

void() zombie_painb14 = [97, zombie_painb15]
{
};

void() zombie_painb15 = [98, zombie_painb16]
{
};

void() zombie_painb16 = [99, zombie_painb17]
{
};

void() zombie_painb17 = [100, zombie_painb18]
{
};

void() zombie_painb18 = [101, zombie_run1]
{
};

void() zombie_painc1 = [102, zombie_painc2]
{
};

void() zombie_painc2 = [103, zombie_painc3]
{
};

void() zombie_painc3 = [104, zombie_painc4]
{
};

void() zombie_painc4 = [105, zombie_painc5]
{
};

void() zombie_painc5 = [106, zombie_painc6]
{
};

void() zombie_painc6 = [107, zombie_painc7]
{
};

void() zombie_painc7 = [108, zombie_painc8]
{
};

void() zombie_painc8 = [109, zombie_painc9]
{
};

void() zombie_painc9 = [110, zombie_painc10]
{
};

void() zombie_painc10 = [111, zombie_painc11]
{
};

void() zombie_painc11 = [112, zombie_painc12]
{
};

void() zombie_painc12 = [113, zombie_painc13]
{
};

void() zombie_painc13 = [114, zombie_run1]
{
};

void() zombie_pain = 
{
	if (random() < 0.5)
	{
		sound(self, CHAN_VOICE, "zombie/pain3.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	}
	else
	{
		sound(self, CHAN_VOICE, "zombie/pain4.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	}
	if (random() < 0.33)
	{
		zombie_paina1();
	}
	else
	{
		if (random() < 0.66)
		{
			zombie_painb1();
		}
		else
		{
			zombie_painc1();
		}
	}
	monster_pain(self.enemy);
};

void() zombie_die1 = [115, zombie_die2]
{
	monster_death();
};

void() zombie_die2 = [116, zombie_die3]
{
	monster_death();
};

void() zombie_die3 = [117, zombie_die4]
{
	monster_death();
};

void() zombie_die4 = [118, zombie_die5]
{
	monster_death();
};

void() zombie_die5 = [119, zombie_die6]
{
	monster_death();
};

void() zombie_die6 = [120, zombie_die7]
{
	monster_death();
};

void() zombie_die7 = [121, zombie_die8]
{
	monster_death();
};

void() zombie_die8 = [122, zombie_die9]
{
	monster_death();
};

void() zombie_die9 = [123, zombie_die10]
{
	monster_death();
};

void() zombie_die10 = [124, zombie_die11]
{
	monster_death();
};

void() zombie_die11 = [125, zombie_die12]
{
	monster_death();
};

void() zombie_die12 = [126, zombie_die12]
{
	if (self.flags & FL_ONGROUND)
	{
		sound(self, CHAN_BODY, "zombie/splat.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
		ThrowGib("progs/gib2.mdl");
		ThrowGib("progs/gib3.mdl");
		ThrowGib("progs/gib3.mdl");
		ThrowGib("progs/gib3.mdl");
		ThrowGib("progs/gib1.mdl");
		ThrowGib("progs/gib1.mdl");
		ThrowGib("progs/gib1.mdl");
		ThrowGib("progs/gib1.mdl");
		remove(self);
		return;
	}
	monster_death();
};

void() zombie_die = 
{
	if (self.gaveexp != 1)
	{
		self.movetype = MOVETYPE_TOSS;
		self.avelocity = '300 300 0';
		self.gaveexp = 1;
		GiveExperience(98);
		sound(self, CHAN_VOICE, "zombie/death.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	}
	if (self.knockback != IT_RELIC2 && self.knockback != AS_MELEE)
	{
		self.velocity = no;
		self.flags = self.flags - (self.flags & FL_ONGROUND);
		self.velocity = self.velocity + TE_LIGHTNING3 * v_forward * IT_RELIC4;
		self.velocity = self.velocity + 90 * '0 0 3';
	}
	zombie_die1();
};

void() zombie_grabbed1 = [85, zombie_grabbed2]
{
	self.grab_finished = time + 0.5;
};

void() zombie_grabbed2 = [85, zombie_grabbed2]
{
	if (self.grab_finished < time || self.grabbed == 0)
	{
		self.th_run();
		return;
	}
};

void() monster_zombie = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/zombie.mdl");
	precache_model("progs/darkball.mdl");
	precache_sound("spells/dbfire.wav");
	precache_sound("spells/dbhit.wav");
	precache_sound("zombie/idle1.wav");
	precache_sound("zombie/idle2.wav");
	precache_sound("zombie/pain1.wav");
	precache_sound("zombie/pain2.wav");
	precache_sound("zombie/pain3.wav");
	precache_sound("zombie/pain4.wav");
	precache_sound("zombie/smack.wav");
	precache_sound("zombie/splat.wav");
	precache_sound("zombie/death.wav");
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/zombie.mdl");
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	if (difficulty < IT_RELIC2)
	{
		self.health = 150;
	}
	else
	{
		self.health = 225;
	}
	self.state = self.health / AS_MELEE;
	self.netname = "solid";
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_NOT;
	self.classname = "zombie";
	self.th_stand = zombie_stand1;
	self.th_run = zombie_run1;
	self.th_pain = zombie_pain;
	self.th_die = zombie_die;
	self.th_grab = zombie_grabbed1;
	self.th_magic = zombie_missile;
	spawn_shadow();
	enemy_start();
};

