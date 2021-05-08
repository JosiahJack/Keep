void() dog_bite = 
{
	local vector delta;
	local float ldmg;
	if (!(self.enemy))
	{
		return;
	}
	ai_charge(MOVETYPE_BOUNCE);
	if (!CanDamage(self.enemy, self))
	{
		return;
	}
	delta = self.enemy.origin - self.origin;
	if (vlen(delta) > 100)
	{
		return;
	}
	random();
	ldmg = (random() + random() + random()) * FL_CLIENT;
	T_Damage(self.enemy, self, self, ldmg);
};

void() Dog_JumpTouch = 
{
	local float ldmg;
	if (self.health <= 0)
	{
		return;
	}
	if (other.takedamage)
	{
		if (vlen(self.velocity) > 300)
		{
			ldmg = MOVETYPE_BOUNCE + MOVETYPE_BOUNCE * random();
			T_Damage(other, self, self, ldmg);
		}
	}
	if (!checkbottom(self))
	{
		if (self.flags & FL_ONGROUND)
		{
			self.touch = SUB_Null;
			self.think = dog_leap1;
			self.nextthink = time + 0.1;
		}
		return;
	}
	self.touch = SUB_Null;
	self.think = dog_run1;
	self.nextthink = time + 0.1;
};

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
	if (random() < 0.2)
	{
		sound(self, CHAN_VOICE, "dog/idle.wav", 1, ATTN_IDLE);
	}
	ai_walk(FL_CLIENT);
};

void() dog_walk2 = [79, dog_walk3]
{
	ai_walk(FL_CLIENT);
};

void() dog_walk3 = [80, dog_walk4]
{
	ai_walk(FL_CLIENT);
};

void() dog_walk4 = [81, dog_walk5]
{
	ai_walk(FL_CLIENT);
};

void() dog_walk5 = [82, dog_walk6]
{
	ai_walk(FL_CLIENT);
};

void() dog_walk6 = [83, dog_walk7]
{
	ai_walk(FL_CLIENT);
};

void() dog_walk7 = [84, dog_walk8]
{
	ai_walk(FL_CLIENT);
};

void() dog_walk8 = [85, dog_walk1]
{
	ai_walk(FL_CLIENT);
};

void() dog_run1 = [48, dog_run2]
{
	if (random() < 0.2)
	{
		sound(self, CHAN_VOICE, "dog/idle.wav", 1, ATTN_IDLE);
	}
	ai_run(FL_INWATER);
};

void() dog_run2 = [49, dog_run3]
{
	ai_run(FL_MONSTER);
};

void() dog_run3 = [50, dog_run4]
{
	ai_run(FL_MONSTER);
};

void() dog_run4 = [51, dog_run5]
{
	ai_run(20);
};

void() dog_run5 = [52, dog_run6]
{
	ai_run(FL_GODMODE);
};

void() dog_run6 = [53, dog_run7]
{
	ai_run(FL_MONSTER);
};

void() dog_run7 = [54, dog_run8]
{
	ai_run(FL_INWATER);
};

void() dog_run8 = [55, dog_run9]
{
	ai_run(FL_MONSTER);
};

void() dog_run9 = [56, dog_run10]
{
	ai_run(FL_MONSTER);
};

void() dog_run10 = [57, dog_run11]
{
	ai_run(20);
};

void() dog_run11 = [58, dog_run12]
{
	ai_run(FL_GODMODE);
};

void() dog_run12 = [59, dog_run1]
{
	ai_run(FL_MONSTER);
};

void() dog_atta1 = [0, dog_atta2]
{
	ai_charge(MOVETYPE_BOUNCE);
};

void() dog_atta2 = [1, dog_atta3]
{
	ai_charge(MOVETYPE_BOUNCE);
};

void() dog_atta3 = [2, dog_atta4]
{
	ai_charge(MOVETYPE_BOUNCE);
};

void() dog_atta4 = [3, dog_atta5]
{
	sound(self, CHAN_VOICE, "dog/dattack1.wav", 1, ATTN_NORM);
	dog_bite();
};

void() dog_atta5 = [4, dog_atta6]
{
	ai_charge(MOVETYPE_BOUNCE);
};

void() dog_atta6 = [5, dog_atta7]
{
	ai_charge(MOVETYPE_BOUNCE);
};

void() dog_atta7 = [6, dog_atta8]
{
	ai_charge(MOVETYPE_BOUNCE);
};

void() dog_atta8 = [7, dog_run1]
{
	ai_charge(MOVETYPE_BOUNCE);
};

void() dog_leap1 = [60, dog_leap2]
{
	ai_face();
};

void() dog_leap2 = [61, dog_leap3]
{
	ai_face();
	self.touch = Dog_JumpTouch;
	makevectors(self.angles);
	self.origin_z = self.origin_z + 1;
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

void() dog_pain6 = [31, dog_run1]
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
	ai_pain(MOVETYPE_STEP);
};

void() dog_painb4 = [35, dog_painb5]
{
	ai_pain(STAT_TOTALMONSTERS);
};

void() dog_painb5 = [36, dog_painb6]
{
	ai_pain(STAT_TOTALMONSTERS);
};

void() dog_painb6 = [37, dog_painb7]
{
	ai_pain(FL_SWIM);
};

void() dog_painb7 = [38, dog_painb8]
{
};

void() dog_painb8 = [39, dog_painb9]
{
	ai_pain(MOVETYPE_STEP);
};

void() dog_painb9 = [40, dog_painb10]
{
};

void() dog_painb10 = [41, dog_painb11]
{
	ai_pain(MOVETYPE_BOUNCE);
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

void() dog_painb16 = [47, dog_run1]
{
};

void() dog_pain = 
{
	sound(self, CHAN_VOICE, "dog/dpain1.wav", 1, ATTN_NORM);
	if (random() > 0.5)
	{
		dog_pain1();
	}
	else
	{
		dog_painb1();
	}
};

void() dog_die1 = [8, dog_die2]
{
};

void() dog_die2 = [9, dog_die3]
{
};

void() dog_die3 = [10, dog_die4]
{
};

void() dog_die4 = [11, dog_die5]
{
};

void() dog_die5 = [12, dog_die6]
{
};

void() dog_die6 = [13, dog_die7]
{
};

void() dog_die7 = [14, dog_die8]
{
};

void() dog_die8 = [15, dog_die9]
{
};

void() dog_die9 = [16, dog_die9]
{
	vigil_settoremove();
};

void() dog_dieb1 = [17, dog_dieb2]
{
};

void() dog_dieb2 = [18, dog_dieb3]
{
};

void() dog_dieb3 = [19, dog_dieb4]
{
};

void() dog_dieb4 = [20, dog_dieb5]
{
};

void() dog_dieb5 = [21, dog_dieb6]
{
};

void() dog_dieb6 = [22, dog_dieb7]
{
};

void() dog_dieb7 = [23, dog_dieb8]
{
};

void() dog_dieb8 = [24, dog_dieb9]
{
};

void() dog_dieb9 = [25, dog_dieb9]
{
	vigil_settoremove();
};

void() dog_die = 
{
	if (self.health < -35)
	{
		sound(self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		ThrowGib("progs/gib3.mdl", self.health);
		ThrowGib("progs/gib3.mdl", self.health);
		ThrowGib("progs/gib3.mdl", self.health);
		ThrowHead("progs/h_dog.mdl", self.health);
		return;
	}
	sound(self, CHAN_VOICE, "dog/ddeath.wav", 1, ATTN_NORM);
	self.solid = SOLID_NOT;
	if (random() > 0.5)
	{
		dog_die1();
	}
	else
	{
		dog_dieb1();
	}
};

float() CheckDogMelee = 
{
	if (enemy_range == RANGE_MELEE)
	{
		self.attack_state = AS_MELEE;
		return 1;
	}
	return 0;
};

float() CheckDogJump = 
{
	local vector dist;
	local float d;
	if (self.origin_z + self.mins_z > self.enemy.origin_z + self.enemy.mins_z + 0.75 * self.enemy.size_z)
	{
		return 0;
	}
	if (self.origin_z + self.maxs_z < self.enemy.origin_z + self.enemy.mins_z + 0.25 * self.enemy.size_z)
	{
		return 0;
	}
	dist = self.enemy.origin - self.origin;
	dist_z = 0;
	d = vlen(dist);
	if (d < 80)
	{
		return 0;
	}
	if (d > 150)
	{
		return 0;
	}
	return 1;
};

float() DogCheckAttack = 
{
	local vector vec;
	if (CheckDogMelee())
	{
		self.attack_state = AS_MELEE;
		return 1;
	}
	if (CheckDogJump())
	{
		self.attack_state = AS_MISSILE;
		return 1;
	}
	return 0;
};

void() monster_dog = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/h_dog.mdl");
	precache_model("progs/dog.mdl");
	precache_sound("dog/dattack1.wav");
	precache_sound("dog/ddeath.wav");
	precache_sound("dog/dpain1.wav");
	precache_sound("dog/dsight.wav");
	precache_sound("dog/idle.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/dog.mdl");
	setsize(self, VEC_HULL2_MIN, '32 32 40');
	self.health = 25;
	self.th_stand = dog_stand1;
	self.th_walk = dog_walk1;
	self.th_run = dog_run1;
	self.th_pain = dog_pain;
	self.th_die = dog_die;
	self.th_melee = dog_atta1;
	self.th_missile = dog_leap1;
	walkmonster_start();
};

