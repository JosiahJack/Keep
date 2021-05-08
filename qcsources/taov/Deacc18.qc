void() wraith_stand1 = [0, wraith_stand2]
{
	ai_stand();
	self.alpha = 0.2;
};

void() wraith_stand2 = [1, wraith_stand3]
{
	ai_stand();
};

void() wraith_stand3 = [2, wraith_stand4]
{
	ai_stand();
};

void() wraith_stand4 = [3, wraith_stand5]
{
	ai_stand();
};

void() wraith_stand5 = [4, wraith_stand6]
{
	ai_stand();
};

void() wraith_stand6 = [5, wraith_stand7]
{
	ai_stand();
};

void() wraith_stand7 = [6, wraith_stand8]
{
	ai_stand();
};

void() wraith_stand8 = [7, wraith_stand9]
{
	ai_stand();
};

void() wraith_stand9 = [8, wraith_stand10]
{
	ai_stand();
};

void() wraith_stand10 = [9, wraith_stand11]
{
	ai_stand();
};

void() wraith_stand11 = [10, wraith_stand12]
{
	ai_stand();
};

void() wraith_stand12 = [11, wraith_stand13]
{
	ai_stand();
};

void() wraith_stand13 = [12, wraith_stand14]
{
	ai_stand();
};

void() wraith_stand14 = [13, wraith_stand15]
{
	ai_stand();
};

void() wraith_stand15 = [14, wraith_stand16]
{
	ai_stand();
};

void() wraith_stand16 = [15, wraith_stand17]
{
	ai_stand();
};

void() wraith_stand17 = [16, wraith_stand1]
{
	ai_stand();
};

void() wraith_walk1 = [17, wraith_walk2]
{
	self.alpha = 0.2;
	ai_fly(IT_RELIC4);
};

void() wraith_walk2 = [18, wraith_walk3]
{
	local float r;
	r = random();
	if (random() < 0.1)
	{
		self.velocity = no;
		if (r < 0.5)
		{
			sound(self, CHAN_VOICE, "wraith/idle1.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
		}
		else
		{
			sound(self, CHAN_VOICE, "wraith/idle2.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
		}
	}
	ai_fly(IT_RELIC5);
};

void() wraith_walk3 = [19, wraith_walk4]
{
	ai_fly(IT_RELIC5);
};

void() wraith_walk4 = [20, wraith_walk5]
{
	ai_fly(IT_RELIC5);
};

void() wraith_walk5 = [21, wraith_walk6]
{
	ai_fly(IT_RELIC5);
};

void() wraith_walk6 = [22, wraith_walk7]
{
	ai_fly(IT_RELIC5);
};

void() wraith_walk7 = [23, wraith_walk8]
{
	ai_fly(IT_RELIC5);
};

void() wraith_walk8 = [24, wraith_walk9]
{
	ai_fly(IT_RELIC5);
};

void() wraith_walk9 = [25, wraith_walk10]
{
	ai_fly(IT_RELIC5);
};

void() wraith_walk10 = [26, wraith_walk11]
{
	ai_fly(IT_RELIC5);
};

void() wraith_walk11 = [27, wraith_walk12]
{
	ai_fly(IT_RELIC5);
};

void() wraith_walk12 = [28, wraith_walk1]
{
	if (random() < 0.2)
	{
		self.velocity = no;
	}
	ai_fly(IT_RELIC5);
};

void() wraith_smash1 = [35, wraith_smash2]
{
	frameskip(0.080000);
};

void() wraith_smash2 = [36, wraith_smash3]
{
	frameskip(0.080000);
};

void() wraith_smash3 = [37, wraith_smash4]
{
	frameskip(0.080000);
};

void() wraith_smash4 = [38, wraith_smash5]
{
	frameskip(0.080000);
};

void() wraith_smash5 = [39, wraith_smash6]
{
	frameskip(0.080000);
};

void() wraith_smash6 = [40, wraith_smash7]
{
	frameskip(0.080000);
};

void() wraith_smash7 = [41, wraith_smash8]
{
	frameskip(0.080000);
};

void() wraith_smash8 = [42, wraith_smash9]
{
	frameskip(0.080000);
};

void() wraith_smash9 = [43, wraith_smash10]
{
	FireMelee(SVC_CLIENTDATA, 35, IT_RELIC2, 50, TE_LIGHTNING1, STATE_TOP, PLAT_LOW_TRIGGER);
	frameskip(0.080000);
};

void() wraith_smash10 = [44, wraith_smash11]
{
	frameskip(0.080000);
};

void() wraith_smash11 = [45, wraith_smash12]
{
	frameskip(0.080000);
};

void() wraith_smash12 = [46, wraith_walk1]
{
	frameskip(0.080000);
};

void() wraith_strike1 = [47, wraith_strike2]
{
	frameskip(0.080000);
};

void() wraith_strike2 = [48, wraith_strike3]
{
	frameskip(0.080000);
};

void() wraith_strike3 = [49, wraith_strike4]
{
	frameskip(0.080000);
};

void() wraith_strike4 = [50, wraith_strike5]
{
	frameskip(0.080000);
};

void() wraith_strike5 = [51, wraith_strike6]
{
	FireMelee(SVC_CLIENTDATA, 35, AS_MELEE, 50, TE_LIGHTNING1, STATE_TOP, PLAT_LOW_TRIGGER);
	frameskip(0.080000);
};

void() wraith_strike6 = [52, wraith_strike7]
{
	frameskip(0.080000);
};

void() wraith_strike7 = [53, wraith_strike8]
{
	frameskip(0.080000);
};

void() wraith_strike8 = [54, wraith_strike9]
{
	frameskip(0.080000);
};

void() wraith_strike9 = [55, wraith_walk1]
{
	frameskip(0.080000);
};

void() wraith_cstrike1 = [56, wraith_cstrike2]
{
	frameskip(0.080000);
};

void() wraith_cstrike2 = [57, wraith_cstrike3]
{
	frameskip(0.080000);
};

void() wraith_cstrike3 = [58, wraith_cstrike4]
{
	frameskip(0.080000);
};

void() wraith_cstrike4 = [59, wraith_cstrike5]
{
	frameskip(0.080000);
};

void() wraith_cstrike5 = [60, wraith_cstrike6]
{
	frameskip(0.080000);
};

void() wraith_cstrike6 = [61, wraith_cstrike7]
{
	FireMelee(SVC_CLIENTDATA, 35, AS_MELEE, 50, TE_LIGHTNING1, STATE_TOP, PLAT_LOW_TRIGGER);
	frameskip(0.080000);
};

void() wraith_cstrike7 = [62, wraith_cstrike8]
{
	frameskip(0.080000);
};

void() wraith_cstrike8 = [63, wraith_cstrike9]
{
	frameskip(0.080000);
};

void() wraith_cstrike9 = [64, wraith_walk1]
{
	frameskip(0.080000);
};

void() wraith_magic1 = [65, wraith_magic2]
{
	frameskip(0.080000);
};

void() wraith_magic2 = [66, wraith_magic3]
{
	frameskip(0.080000);
};

void() wraith_magic3 = [67, wraith_magic4]
{
	frameskip(0.080000);
};

void() wraith_magic4 = [68, wraith_magic5]
{
	frameskip(0.080000);
};

void() wraith_magic5 = [69, wraith_magic6]
{
	frameskip(0.080000);
};

void() wraith_magic6 = [70, wraith_magic7]
{
	FireMelee(SVC_CLIENTDATA, 35, AS_MELEE, 50, TE_LIGHTNING1, STATE_TOP, PLAT_LOW_TRIGGER);
	frameskip(0.080000);
};

void() wraith_magic7 = [71, wraith_magic8]
{
	frameskip(0.080000);
};

void() wraith_magic8 = [72, wraith_magic9]
{
	frameskip(0.080000);
};

void() wraith_magic9 = [73, wraith_magic10]
{
	frameskip(0.080000);
};

void() wraith_magic10 = [74, wraith_magic11]
{
	frameskip(0.080000);
};

void() wraith_magic11 = [75, wraith_magic12]
{
	frameskip(0.080000);
};

void() wraith_magic12 = [76, wraith_walk1]
{
	frameskip(0.080000);
};

void() wraith_melee = 
{
	local float r;
	r = random();
	self.alpha = PLAT_LOW_TRIGGER;
	if (r < 0.25)
	{
		wraith_smash1();
	}
	else
	{
		if (r < 0.5)
		{
			wraith_strike1();
		}
		else
		{
			if (r < 0.75)
			{
				wraith_cstrike1();
			}
			else
			{
				wraith_magic1();
			}
		}
	}
};

void() wraith_pain1 = [77, wraith_pain2]
{
};

void() wraith_pain2 = [78, wraith_pain3]
{
};

void() wraith_pain3 = [79, wraith_pain4]
{
};

void() wraith_pain4 = [80, wraith_pain5]
{
};

void() wraith_pain5 = [81, wraith_pain6]
{
};

void() wraith_pain6 = [82, wraith_walk1]
{
};

void() wraith_pain = 
{
	self.alpha = PLAT_LOW_TRIGGER;
	wraith_pain1();
	monster_pain(self.enemy);
};

void() wraith_death1 = [83, wraith_death2]
{
	monster_death();
	self.alpha = self.alpha - 0.1;
};

void() wraith_death2 = [84, wraith_death3]
{
	monster_death();
	self.alpha = self.alpha - 0.1;
};

void() wraith_death3 = [85, wraith_death4]
{
	monster_death();
	self.alpha = self.alpha - 0.1;
};

void() wraith_death4 = [86, wraith_death5]
{
	monster_death();
	self.alpha = self.alpha - 0.1;
};

void() wraith_death5 = [87, wraith_death6]
{
	monster_death();
	self.alpha = self.alpha - 0.1;
};

void() wraith_death6 = [88, wraith_death7]
{
	monster_death();
	self.alpha = self.alpha - 0.1;
};

void() wraith_death7 = [89, wraith_death8]
{
	monster_death();
	self.alpha = self.alpha - 0.1;
};

void() wraith_death8 = [90, wraith_death9]
{
	monster_death();
	self.alpha = self.alpha - 0.1;
};

void() wraith_death9 = [91, wraith_death10]
{
	monster_death();
	self.alpha = self.alpha - 0.1;
};

void() wraith_death10 = [92, wraith_death11]
{
	monster_death();
	self.alpha = self.alpha - 0.1;
};

void() wraith_death11 = [93, wraith_death12]
{
	monster_death();
};

void() wraith_death12 = [94, wraith_death12]
{
	monster_death();
	remove(self);
	return;
};

void() WraithSwordTouch = 
{
	if (other.solid == SOLID_BSP)
	{
		sound(self, CHAN_BODY, "player/shwing.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	}
};

void() ThrowWraithSword = 
{
	local entity esword;
	esword = spawn();
	esword.owner = self;
	esword.movetype = MOVETYPE_TOSS;
	esword.solid = SOLID_TRIGGER;
	esword.angles_y = random() * 360;
	makevectors(esword.angles);
	esword.velocity = v_forward * 100;
	esword.velocity_z = 250;
	esword.touch = WraithSwordTouch;
	if (esword.flags & FL_ONGROUND)
	{
		esword.flags = esword.flags - FL_ONGROUND;
	}
	esword.avelocity = crandom() * '0 600 0';
	setmodel(esword, "progs/wr_sword.mdl");
	setsize(esword, '-16 -16 0', '16 16 56');
	setorigin(esword, self.origin);
};

void() wraith_die = 
{
	if (self.gaveexp != 1)
	{
		sound(self, CHAN_VOICE, "wraith/death.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
		ThrowWraithSword();
		self.alpha = PLAT_LOW_TRIGGER;
		wraith_death1();
		self.velocity = no;
		GiveExperience(100);
		self.gaveexp = 1;
		spawn_ghost();
	}
};

void() monster_wraith = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/wraith.mdl");
	precache_model("progs/wr_sword.mdl");
	precache_sound("wraith/idle1.wav");
	precache_sound("wraith/idle2.wav");
	precache_sound("wraith/death.wav");
	precache_sound("ghost/pain.wav");
	precache_sound("ghost/death.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_NOCLIP;
	setmodel(self, "progs/wraith.mdl");
	if (difficulty < IT_RELIC2)
	{
		self.health = 175;
	}
	else
	{
		self.health = 263;
	}
	self.netname = "solid";
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_NOT;
	self.classname = "wraith";
	setsize(self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	self.alpha = 0.2;
	self.th_stand = wraith_stand1;
	self.th_walk = wraith_walk1;
	self.th_pain = wraith_pain;
	self.th_die = wraith_die;
	self.th_melee = wraith_melee;
	self.noblood = 1;
	enemy_start();
};

