void() dog_stand1 = [69, dog_stand2]
{
	ai_stand();
};

void() dog_stand2 = [70, dog_stand3]
{
	ai_stand();
};

void() dog_stand3 = [71, dog_stand4]
{
	ai_stand();
};

void() dog_stand4 = [72, dog_stand5]
{
	ai_stand();
};

void() dog_stand5 = [73, dog_stand6]
{
	ai_stand();
};

void() dog_stand6 = [74, dog_stand7]
{
	ai_stand();
};

void() dog_stand7 = [75, dog_stand8]
{
	ai_stand();
};

void() dog_stand8 = [76, dog_stand9]
{
	ai_stand();
};

void() dog_stand9 = [77, dog_stand1]
{
	ai_stand();
};

void() dog_walk1 = [78, dog_walk2]
{
	ai_walk(IT_RELIC4);
};

void() dog_walk2 = [79, dog_walk3]
{
	ai_walk(IT_RELIC4);
};

void() dog_walk3 = [80, dog_walk4]
{
	ai_walk(IT_RELIC4);
};

void() dog_walk4 = [81, dog_walk5]
{
	ai_walk(IT_RELIC4);
};

void() dog_walk5 = [82, dog_walk6]
{
	ai_walk(IT_RELIC4);
};

void() dog_walk6 = [83, dog_walk7]
{
	ai_walk(IT_RELIC4);
};

void() dog_walk7 = [84, dog_walk8]
{
	ai_walk(IT_RELIC4);
};

void() dog_walk8 = [85, dog_walk1]
{
	ai_walk(IT_RELIC4);
};

void() dog_run1 = [48, dog_run2]
{
	ai_walk(SVC_SPAWNSTATIC);
};

void() dog_run2 = [49, dog_run3]
{
	ai_walk(SVC_SPAWNSTATIC);
};

void() dog_run3 = [50, dog_run4]
{
	ai_walk(SVC_SPAWNSTATIC);
};

void() dog_run4 = [51, dog_run5]
{
	ai_walk(SVC_SPAWNSTATIC);
};

void() dog_run5 = [52, dog_run6]
{
	ai_walk(SVC_SPAWNSTATIC);
};

void() dog_run6 = [53, dog_run7]
{
	ai_walk(SVC_SPAWNSTATIC);
};

void() dog_run7 = [54, dog_run8]
{
	ai_walk(SVC_SPAWNSTATIC);
};

void() dog_run8 = [55, dog_run9]
{
	ai_walk(SVC_SPAWNSTATIC);
};

void() dog_run9 = [56, dog_run10]
{
	ai_walk(SVC_SPAWNSTATIC);
};

void() dog_run10 = [57, dog_run11]
{
	ai_walk(SVC_SPAWNSTATIC);
};

void() dog_run11 = [58, dog_run12]
{
	ai_walk(SVC_SPAWNSTATIC);
};

void() dog_run12 = [59, dog_run1]
{
	ai_walk(SVC_SPAWNSTATIC);
};

void() dog_atta1 = [0, dog_atta2]
{
};

void() dog_atta2 = [1, dog_atta3]
{
};

void() dog_atta3 = [2, dog_atta4]
{
};

void() dog_atta4 = [3, dog_atta5]
{
	sound(self, CHAN_VOICE, "dog/bite.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	FireMelee(IT_RELIC2, 45, STATE_TOP, SVC_SIGNONNUM, STATE_TOP, STATE_TOP, STATE_TOP);
};

void() dog_atta5 = [4, dog_atta6]
{
};

void() dog_atta6 = [5, dog_atta7]
{
};

void() dog_atta7 = [6, dog_atta8]
{
};

void() dog_atta8 = [7, dog_walk1]
{
};

void() Dog_JumpTouch = 
{
	local entity effect;
	local float ldmg;
	local vector dir;
	if (other.classname == "player" && !(other.flypain) && other.takedamage != DAMAGE_NO)
	{
		if (vlen(self.velocity) > 150)
		{
			effect = spawn();
			setorigin(effect, other.origin);
			setmodel(effect, "progs/hit.spr");
			effect.movetype = MOVETYPE_NONE;
			effect.think = fx_think;
			effect.nextthink = time;
			effect.solid = SOLID_NOT;
			other.knockback = PLAT_LOW_TRIGGER;
			ldmg = AS_MELEE + TE_LIGHTNING1 * random();
			T_Damage(other, self, self, ldmg);
			ThrowBloodSplat(dir, other.origin, other);
			ThrowBloodSplat(dir, other.origin, other);
			sound(self, CHAN_VOICE, "dog/bite.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
			sound(self, CHAN_WEAPON, "player/swordhit.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
			self.velocity_x = STATE_TOP;
		}
	}
	self.touch = SUB_Null;
	self.think = dog_walk1;
	self.nextthink = time + 0.1;
};

void() dog_leap1 = [60, dog_leap2]
{
	sound(self, CHAN_VOICE, "dog/growl.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	self.nextthink = time + 0.8;
};

void() dog_leap2 = [61, dog_leap3]
{
	self.touch = Dog_JumpTouch;
	makevectors(self.angles);
	self.origin_z = self.origin_z + PLAT_LOW_TRIGGER;
	self.velocity = v_forward * 300 + '0 0 200';
	if (self.flags & FL_ONGROUND)
	{
		self.flags = self.flags - FL_ONGROUND;
	}
};

void() dog_leap3 = [62, dog_leap4]
{
};

void() dog_leap4 = [63, dog_leap5]
{
};

void() dog_leap5 = [64, dog_leap6]
{
};

void() dog_leap6 = [65, dog_leap7]
{
};

void() dog_leap7 = [66, dog_leap8]
{
};

void() dog_leap8 = [67, dog_leap9]
{
};

void() dog_leap9 = [68, dog_leap9]
{
};

void() dog_pain1 = [26, dog_pain2]
{
};

void() dog_pain2 = [27, dog_pain3]
{
};

void() dog_pain3 = [28, dog_pain4]
{
};

void() dog_pain4 = [29, dog_pain5]
{
};

void() dog_pain5 = [30, dog_pain6]
{
};

void() dog_pain6 = [31, dog_walk1]
{
};

void() dog_painb1 = [32, dog_painb2]
{
};

void() dog_painb2 = [33, dog_painb3]
{
};

void() dog_painb3 = [34, dog_painb4]
{
};

void() dog_painb4 = [35, dog_painb5]
{
};

void() dog_painb5 = [36, dog_painb6]
{
};

void() dog_painb6 = [37, dog_painb7]
{
};

void() dog_painb7 = [38, dog_painb8]
{
};

void() dog_painb8 = [39, dog_painb9]
{
};

void() dog_painb9 = [40, dog_painb10]
{
};

void() dog_painb10 = [41, dog_painb11]
{
};

void() dog_painb11 = [42, dog_painb12]
{
};

void() dog_painb12 = [43, dog_painb13]
{
};

void() dog_painb13 = [44, dog_painb14]
{
};

void() dog_painb14 = [45, dog_painb15]
{
};

void() dog_painb15 = [46, dog_painb16]
{
};

void() dog_painb16 = [47, dog_walk1]
{
};

void() dog_pain = 
{
	self.touch = SUB_Null;
	sound(self, CHAN_VOICE, "dog/yelp.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	if (random() > 0.5)
	{
		dog_pain1();
	}
	else
	{
		dog_painb1();
	}
	monster_pain(self.enemy);
};

void() dog_die1 = [8, dog_die2]
{
	monster_death();
};

void() dog_die2 = [9, dog_die3]
{
	monster_death();
};

void() dog_die3 = [10, dog_die4]
{
	monster_death();
};

void() dog_die4 = [11, dog_die5]
{
	monster_death();
};

void() dog_die5 = [12, dog_die6]
{
	monster_death();
};

void() dog_die6 = [13, dog_die7]
{
	monster_death();
};

void() dog_die7 = [14, dog_die8]
{
	monster_death();
};

void() dog_die8 = [15, dog_die9]
{
	monster_death();
};

void() dog_die9 = [16, dog_die9]
{
	monster_death();
};

void() dog_dieb1 = [17, dog_dieb2]
{
	monster_death();
};

void() dog_dieb2 = [18, dog_dieb3]
{
	monster_death();
};

void() dog_dieb3 = [19, dog_dieb4]
{
	monster_death();
};

void() dog_dieb4 = [20, dog_dieb5]
{
	monster_death();
};

void() dog_dieb5 = [21, dog_dieb6]
{
	monster_death();
};

void() dog_dieb6 = [22, dog_dieb7]
{
	monster_death();
};

void() dog_dieb7 = [23, dog_dieb8]
{
	monster_death();
};

void() dog_dieb8 = [24, dog_dieb9]
{
	monster_death();
};

void() dog_dieb9 = [25, dog_dieb9]
{
	monster_death();
};

void() dog_die = 
{
	if (self.gaveexp != 1)
	{
		GiveExperience(IT_RELIC4);
		self.movetype = MOVETYPE_TOSS;
		self.avelocity = '300 -300 0';
		self.gaveexp = 1;
		sound(self, CHAN_VOICE, "dog/cry.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	}
	if (self.damage_type == TE_LIGHTNING1)
	{
		sound(self, CHAN_BODY, "misc/guts.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
		ThrowBodyPart("progs/dog_c1.mdl");
		ThrowBodyPart("progs/dog_c2.mdl");
		remove(self);
		return;
	}
	if (self.knockback != IT_RELIC2 && self.knockback != AS_MELEE)
	{
		self.velocity = no;
		self.flags = self.flags - (self.flags & FL_ONGROUND);
		self.velocity = self.velocity + TE_LIGHTNING3 * v_forward * IT_RELIC4;
		self.velocity = self.velocity + 90 * '0 0 3';
	}
	if (random() > 0.5)
	{
		dog_die1();
	}
	else
	{
		dog_dieb1();
	}
};

void() dog_jump = [64, dog_jump]
{
	if (self.flags & FL_ONGROUND)
	{
		dog_walk1();
	}
};

void() monster_dog = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/dog.mdl");
	precache_model("progs/dog_c1.mdl");
	precache_model("progs/dog_c2.mdl");
	precache_sound("dog/bite.wav");
	precache_sound("dog/yelp.wav");
	precache_sound("dog/cry.wav");
	precache_sound("dog/growl.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/dog.mdl");
	setsize(self, VEC_HULL2_MIN, '32 32 40');
	if (difficulty < IT_RELIC2)
	{
		self.health = 51;
	}
	else
	{
		self.health = 100;
	}
	self.netname = "solid";
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_NOT;
	self.classname = "dog";
	self.th_stand = dog_stand1;
	self.th_walk = dog_walk1;
	self.th_run = dog_run1;
	self.th_pain = dog_pain;
	self.th_die = dog_die;
	self.th_melee = dog_atta1;
	self.th_missile = dog_leap1;
	self.th_jump = dog_jump;
	spawn_shadow();
	enemy_start();
};

