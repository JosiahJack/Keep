void() grem_stand1 = [0, grem_stand2]
{
	local float rs;
	ai_stand();
	if (self.voice_finished < time)
	{
		rs = rint(random() * AS_MELEE + PLAT_LOW_TRIGGER);
		self.noise = "";
		if (rs == PLAT_LOW_TRIGGER)
		{
			self.noise = "gremlin/idle1.wav";
		}
		else
		{
			if (rs == IT_RELIC2)
			{
				self.noise = "gremlin/idle2.wav";
			}
			else
			{
				if (rs == AS_MELEE)
				{
					self.noise = "gremlin/idle3.wav";
				}
				else
				{
					self.noise = "gremlin/idle4.wav";
				}
			}
		}
		sound(self, CHAN_VOICE, self.noise, PLAT_LOW_TRIGGER, ATTN_NORM);
		self.voice_finished = time + TE_LIGHTNING1;
	}
};

void() grem_stand2 = [1, grem_stand3]
{
	ai_stand();
};

void() grem_stand3 = [2, grem_stand4]
{
	ai_stand();
};

void() grem_stand4 = [3, grem_stand5]
{
	ai_stand();
};

void() grem_stand5 = [4, grem_stand6]
{
	ai_stand();
};

void() grem_stand6 = [5, grem_stand7]
{
	ai_stand();
};

void() grem_stand7 = [6, grem_stand8]
{
	ai_stand();
};

void() grem_stand8 = [7, grem_stand9]
{
	ai_stand();
};

void() grem_stand9 = [8, grem_stand10]
{
	ai_stand();
};

void() grem_stand10 = [9, grem_stand11]
{
	ai_stand();
};

void() grem_stand11 = [10, grem_stand12]
{
	ai_stand();
};

void() grem_stand12 = [11, grem_stand13]
{
	ai_stand();
};

void() grem_stand13 = [12, grem_stand14]
{
	ai_stand();
};

void() grem_stand14 = [13, grem_stand15]
{
	ai_stand();
};

void() grem_stand15 = [14, grem_stand16]
{
	ai_stand();
};

void() grem_stand16 = [15, grem_stand17]
{
	ai_stand();
};

void() grem_stand17 = [16, grem_stand1]
{
	ai_stand();
};

void() grem_run1 = [17, grem_run2]
{
	ai_walk(TE_LAVASPLASH);
	frameskip(0.05);
};

void() grem_run2 = [18, grem_run3]
{
	ai_walk(TE_LAVASPLASH);
	frameskip(0.05);
};

void() grem_run3 = [19, grem_run4]
{
	ai_walk(TE_LAVASPLASH);
	frameskip(0.05);
};

void() grem_run4 = [20, grem_run5]
{
	ai_walk(TE_LAVASPLASH);
	frameskip(0.05);
};

void() grem_run5 = [21, grem_run6]
{
	ai_walk(TE_LAVASPLASH);
	frameskip(0.05);
};

void() grem_run6 = [22, grem_run7]
{
	ai_walk(TE_LAVASPLASH);
	frameskip(0.05);
};

void() grem_run7 = [23, grem_run8]
{
	ai_walk(TE_LAVASPLASH);
	frameskip(0.05);
};

void() grem_run8 = [24, grem_run9]
{
	ai_walk(TE_LAVASPLASH);
	frameskip(0.05);
};

void() grem_run9 = [25, grem_run10]
{
	ai_walk(TE_LAVASPLASH);
	frameskip(0.05);
};

void() grem_run10 = [26, grem_run11]
{
	ai_walk(TE_LAVASPLASH);
	frameskip(0.05);
};

void() grem_run11 = [27, grem_run12]
{
	ai_walk(TE_LAVASPLASH);
	frameskip(0.05);
};

void() grem_run12 = [28, grem_run13]
{
	ai_walk(TE_LAVASPLASH);
	frameskip(0.05);
};

void() grem_run13 = [29, grem_run14]
{
	ai_walk(TE_LAVASPLASH);
	frameskip(0.05);
};

void() grem_run14 = [30, grem_run15]
{
	ai_walk(TE_LAVASPLASH);
	frameskip(0.05);
};

void() grem_run15 = [31, grem_run1]
{
	ai_walk(TE_LAVASPLASH);
	frameskip(0.05);
};

void() Grem_JumpTouch = 
{
	local entity effect;
	local float ldmg;
	local vector dir;
	if (other.classname == "player" && !(other.flypain) && other.takedamage != DAMAGE_NO)
	{
		if (vlen(self.velocity) > 200)
		{
			effect = spawn();
			setorigin(effect, other.origin);
			setmodel(effect, "progs/hit.spr");
			effect.movetype = MOVETYPE_NONE;
			effect.think = fx_think;
			effect.nextthink = time;
			effect.solid = SOLID_NOT;
			ldmg = TE_LIGHTNING2 + TE_LAVASPLASH * random();
			other.knockback = PLAT_LOW_TRIGGER;
			T_Damage(other, self, self, ldmg);
			ThrowBloodSplat(dir, other.origin, other);
			ThrowBloodSplat(dir, other.origin, other);
			sound(self, CHAN_WEAPON, "player/bigcut.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
			self.velocity_x = STATE_TOP;
			self.cnt = STATE_TOP;
		}
	}
	self.touch = SUB_Null;
	self.think = grem_run1;
	self.nextthink = time + 0.1;
};

void() grem_leap1 = [60, grem_leap1]
{
	if (self.cnt >= IT_RELIC4)
	{
		self.cnt = STATE_TOP;
		self.think = grem_leap2;
	}
	else
	{
		if (self.cnt == STATE_TOP)
		{
			sound(self, CHAN_VOICE, "gremlin/leap.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
		}
	}
	self.cnt = self.cnt + PLAT_LOW_TRIGGER;
};

void() grem_leap2 = [61, grem_leap3]
{
	self.touch = Grem_JumpTouch;
	makevectors(self.angles);
	self.velocity = v_forward * 400 + '0 0 150';
	if (self.flags & FL_ONGROUND)
	{
		self.flags = self.flags - FL_ONGROUND;
	}
};

void() grem_leap3 = [34, grem_leap4]
{
};

void() grem_leap4 = [35, grem_leap5]
{
};

void() grem_leap5 = [36, grem_leap6]
{
};

void() grem_leap6 = [37, grem_leap7]
{
};

void() grem_leap7 = [38, grem_leap8]
{
};

void() grem_leap8 = [39, grem_leap9]
{
};

void() grem_leap9 = [40, grem_leap10]
{
};

void() grem_leap10 = [41, grem_leap11]
{
};

void() grem_leap11 = [42, grem_leap12]
{
};

void() grem_leap12 = [43, grem_leap13]
{
};

void() grem_leap13 = [44, grem_leap14]
{
};

void() grem_leap14 = [45, grem_leap15]
{
};

void() grem_leap15 = [46, grem_leap16]
{
};

void() grem_leap16 = [47, grem_run1]
{
};

void() grem_atk1 = [48, grem_atk2]
{
};

void() grem_atk2 = [49, grem_atk3]
{
};

void() grem_atk3 = [50, grem_atk4]
{
};

void() grem_atk4 = [51, grem_atk5]
{
};

void() grem_atk5 = [52, grem_atk6]
{
};

void() grem_atk6 = [53, grem_atk7]
{
};

void() grem_atk7 = [54, grem_atk8]
{
	FireMelee(TE_LIGHTNING2, SVC_SIGNONNUM, STATE_TOP, SVC_INTERMISSION, TE_LIGHTNING1, STATE_TOP, STATE_TOP);
};

void() grem_atk8 = [55, grem_atk9]
{
};

void() grem_atk9 = [56, grem_atk10]
{
};

void() grem_atk10 = [57, grem_atk11]
{
};

void() grem_atk11 = [58, grem_run1]
{
};

void() grem_maul1 = [59, grem_maul2]
{
};

void() grem_maul2 = [60, grem_maul3]
{
};

void() grem_maul3 = [61, grem_maul4]
{
};

void() grem_maul4 = [62, grem_maul5]
{
	FireMelee(TE_LIGHTNING1, SVC_SIGNONNUM, STATE_TOP, SVC_INTERMISSION, TE_LIGHTNING1, STATE_TOP, STATE_TOP);
};

void() grem_maul5 = [63, grem_maul6]
{
};

void() grem_maul6 = [64, grem_maul7]
{
};

void() grem_maul7 = [65, grem_maul8]
{
};

void() grem_maul8 = [66, grem_maul9]
{
	FireMelee(TE_LIGHTNING1, SVC_SIGNONNUM, STATE_TOP, SVC_INTERMISSION, TE_LIGHTNING1, STATE_TOP, STATE_TOP);
};

void() grem_maul9 = [67, grem_maul10]
{
};

void() grem_maul10 = [68, grem_maul11]
{
};

void() grem_maul11 = [69, grem_maul12]
{
};

void() grem_maul12 = [70, grem_maul13]
{
};

void() grem_maul13 = [71, grem_run1]
{
};

void() grem_lunge1 = [112, grem_lunge2]
{
};

void() grem_lunge2 = [113, grem_lunge3]
{
};

void() grem_lunge3 = [114, grem_lunge4]
{
};

void() grem_lunge4 = [115, grem_lunge5]
{
};

void() grem_lunge5 = [116, grem_lunge6]
{
};

void() grem_lunge6 = [117, grem_lunge7]
{
};

void() grem_lunge7 = [118, grem_lunge8]
{
};

void() grem_lunge8 = [119, grem_lunge9]
{
	FireMelee(IT_RELIC4, SVC_SIGNONNUM, PLAT_LOW_TRIGGER, SVC_INTERMISSION, TE_LIGHTNING1, STATE_TOP, STATE_TOP);
};

void() grem_lunge9 = [120, grem_lunge10]
{
};

void() grem_lunge10 = [121, grem_lunge11]
{
};

void() grem_lunge11 = [122, grem_run1]
{
};

void() grem_melee = 
{
	local float r;
	local float s;
	r = s = random();
	if (s < 0.5)
	{
		sound(self, CHAN_VOICE, "gremlin/attack1.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	}
	else
	{
		sound(self, CHAN_VOICE, "gremlin/attack2.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	}
	if (r < 0.35)
	{
		grem_lunge1();
	}
	else
	{
		if (r < 0.75)
		{
			grem_maul1();
		}
		else
		{
			grem_atk1();
		}
	}
};

void() grem_pain1 = [82, grem_pain2]
{
};

void() grem_pain2 = [83, grem_pain3]
{
};

void() grem_pain3 = [84, grem_pain4]
{
};

void() grem_pain4 = [85, grem_run1]
{
};

void() grem_painb1 = [86, grem_painb2]
{
};

void() grem_painb2 = [87, grem_painb3]
{
};

void() grem_painb3 = [88, grem_painb4]
{
};

void() grem_painb4 = [89, grem_painb5]
{
};

void() grem_painb5 = [90, grem_painb6]
{
};

void() grem_painb6 = [91, grem_run1]
{
};

void() grem_pain = 
{
	local float rs;
	self.touch = SUB_Null;
	self.cnt = STATE_TOP;
	rs = rint(random() * IT_RELIC2 + PLAT_LOW_TRIGGER);
	self.noise = "";
	if (rs == PLAT_LOW_TRIGGER)
	{
		self.noise = "gremlin/pain1.wav";
	}
	else
	{
		if (rs == IT_RELIC2)
		{
			self.noise = "gremlin/pain2.wav";
		}
		else
		{
			self.noise = "gremlin/pain3.wav";
		}
	}
	sound(self, CHAN_VOICE, self.noise, PLAT_LOW_TRIGGER, ATTN_NORM);
	if (random() > 0.5)
	{
		grem_pain1();
	}
	else
	{
		grem_painb1();
	}
	monster_pain(self.enemy);
};

void() grem_grabbed1 = [86, grem_grabbed2]
{
	self.grab_finished = time + 0.5;
};

void() grem_grabbed2 = [86, grem_grabbed2]
{
	if (self.grab_finished < time || self.grabbed == 0)
	{
		self.th_run();
		return;
	}
};

void() grem_death1 = [92, grem_death2]
{
	monster_death();
};

void() grem_death2 = [93, grem_death3]
{
	monster_death();
};

void() grem_death3 = [94, grem_death4]
{
	monster_death();
};

void() grem_death4 = [95, grem_death5]
{
	monster_death();
};

void() grem_death5 = [96, grem_death6]
{
	monster_death();
};

void() grem_death6 = [97, grem_death7]
{
	monster_death();
};

void() grem_death7 = [98, grem_death8]
{
	monster_death();
};

void() grem_death8 = [99, grem_death9]
{
	monster_death();
};

void() grem_death9 = [100, grem_death10]
{
	monster_death();
};

void() grem_death10 = [101, grem_death11]
{
	monster_death();
};

void() grem_death11 = [102, grem_death12]
{
	monster_death();
};

void() grem_death12 = [103, grem_death12]
{
	monster_death();
};

void() grem_deathb1 = [104, grem_deathb2]
{
	monster_death();
};

void() grem_deathb2 = [105, grem_deathb3]
{
	monster_death();
};

void() grem_deathb3 = [106, grem_deathb4]
{
	monster_death();
};

void() grem_deathb4 = [107, grem_deathb5]
{
	monster_death();
};

void() grem_deathb5 = [108, grem_deathb6]
{
	monster_death();
};

void() grem_deathb6 = [109, grem_deathb7]
{
	monster_death();
};

void() grem_deathb7 = [110, grem_deathb8]
{
	monster_death();
};

void() grem_deathb8 = [111, grem_deathb8]
{
	monster_death();
};

void() grem_die = 
{
	if (random() > 0.5)
	{
		grem_death1();
	}
	else
	{
		grem_deathb1();
	}
	if (self.gaveexp != 1)
	{
		if (random() > 0.5)
		{
			sound(self, CHAN_VOICE, "gremlin/death1.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
		}
		else
		{
			sound(self, CHAN_VOICE, "gremlin/death2.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
		}
		GiveExperience(SVC_CLIENTDATA);
		self.movetype = MOVETYPE_TOSS;
		self.avelocity = '300 300 0';
		self.gaveexp = 1;
	}
	if (self.knockback != IT_RELIC2 && self.knockback != AS_MELEE)
	{
		self.velocity = no;
	}
};

void() grem_jump = [37, grem_jump]
{
	if (self.flags & FL_ONGROUND)
	{
		grem_run1();
	}
};

void() monster_gremlin = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/grem.mdl");
	precache_sound("gremlin/idle1.wav");
	precache_sound("gremlin/idle2.wav");
	precache_sound("gremlin/idle3.wav");
	precache_sound("gremlin/idle4.wav");
	precache_sound("gremlin/attack1.wav");
	precache_sound("gremlin/attack2.wav");
	precache_sound("gremlin/leap.wav");
	precache_sound("gremlin/pain1.wav");
	precache_sound("gremlin/pain2.wav");
	precache_sound("gremlin/pain3.wav");
	precache_sound("gremlin/death1.wav");
	precache_sound("gremlin/death2.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/grem.mdl");
	if (difficulty < IT_RELIC2)
	{
		self.health = 80;
	}
	else
	{
		self.health = 120;
	}
	self.netname = "solid";
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_NOT;
	self.classname = "grem";
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.th_stand = grem_stand1;
	self.th_run = grem_run1;
	self.th_pain = grem_pain;
	self.th_die = grem_die;
	self.th_grab = grem_grabbed1;
	self.th_jump = grem_jump;
	self.th_missile = grem_leap1;
	self.th_melee = grem_melee;
	spawn_shadow();
	enemy_start();
};

