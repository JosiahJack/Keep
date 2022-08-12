void() f_stand1 = [39, f_stand2]
{
	ai_stand();
};

void() f_stand2 = [40, f_stand3]
{
	ai_stand();
};

void() f_stand3 = [41, f_stand4]
{
	ai_stand();
};

void() f_stand4 = [42, f_stand5]
{
	ai_stand();
};

void() f_stand5 = [43, f_stand6]
{
	ai_stand();
};

void() f_stand6 = [44, f_stand7]
{
	ai_stand();
};

void() f_stand7 = [45, f_stand8]
{
	ai_stand();
};

void() f_stand8 = [46, f_stand9]
{
	ai_stand();
};

void() f_stand9 = [47, f_stand10]
{
	ai_stand();
};

void() f_stand10 = [48, f_stand11]
{
	ai_stand();
};

void() f_stand11 = [49, f_stand12]
{
	ai_stand();
};

void() f_stand12 = [50, f_stand13]
{
	ai_stand();
};

void() f_stand13 = [51, f_stand14]
{
	ai_stand();
};

void() f_stand14 = [52, f_stand15]
{
	ai_stand();
};

void() f_stand15 = [53, f_stand16]
{
	ai_stand();
};

void() f_stand16 = [54, f_stand17]
{
	ai_stand();
};

void() f_stand17 = [55, f_stand18]
{
	ai_stand();
};

void() f_stand18 = [56, f_stand1]
{
	ai_stand();
};

void() f_walk1 = [39, f_walk2]
{
	ai_walk(8);
};

void() f_walk2 = [40, f_walk3]
{
	ai_walk(8);
};

void() f_walk3 = [41, f_walk4]
{
	ai_walk(8);
};

void() f_walk4 = [42, f_walk5]
{
	ai_walk(8);
};

void() f_walk5 = [43, f_walk6]
{
	ai_walk(8);
};

void() f_walk6 = [44, f_walk7]
{
	ai_walk(8);
};

void() f_walk7 = [45, f_walk8]
{
	ai_walk(8);
};

void() f_walk8 = [46, f_walk9]
{
	ai_walk(8);
};

void() f_walk9 = [47, f_walk10]
{
	ai_walk(8);
};

void() f_walk10 = [48, f_walk11]
{
	ai_walk(8);
};

void() f_walk11 = [49, f_walk12]
{
	ai_walk(8);
};

void() f_walk12 = [50, f_walk13]
{
	ai_walk(8);
};

void() f_walk13 = [51, f_walk14]
{
	ai_walk(8);
};

void() f_walk14 = [52, f_walk15]
{
	ai_walk(8);
};

void() f_walk15 = [53, f_walk16]
{
	ai_walk(8);
};

void() f_walk16 = [54, f_walk17]
{
	ai_walk(8);
};

void() f_walk17 = [55, f_walk18]
{
	ai_walk(8);
};

void() f_walk18 = [56, f_walk1]
{
	ai_walk(8);
};

void() f_run1 = [39, f_run2]
{
	ai_run(12);
	if (random() < 0.5)
	{
		sound(self, CHAN_VOICE, "fish/idle.wav", 1, ATTN_NORM);
	}
};

void() f_run2 = [41, f_run3]
{
	ai_run(12);
};

void() f_run3 = [43, f_run4]
{
	ai_run(12);
};

void() f_run4 = [45, f_run5]
{
	ai_run(12);
};

void() f_run5 = [47, f_run6]
{
	ai_run(12);
};

void() f_run6 = [49, f_run7]
{
	ai_run(12);
};

void() f_run7 = [51, f_run8]
{
	ai_run(12);
};

void() f_run8 = [53, f_run9]
{
	ai_run(12);
};

void() f_run9 = [55, f_run1]
{
	ai_run(12);
};

void() fish_melee = 
{
	local vector delta;
	local float ldmg;
	if (!(self.enemy))
	{
		return;
	}
	delta = self.enemy.origin - self.origin;
	if (vlen(delta) > 60)
	{
		return;
	}
	sound(self, CHAN_VOICE, "fish/bite.wav", 1, ATTN_NORM);
	random();
	ldmg = (random() + random()) * 3;
	T_Damage(self.enemy, self, self, ldmg);
};

void() f_attack1 = [0, f_attack2]
{
	ai_charge(10);
};

void() f_attack2 = [1, f_attack3]
{
	ai_charge(10);
};

void() f_attack3 = [2, f_attack4]
{
	fish_melee();
};

void() f_attack4 = [3, f_attack5]
{
	ai_charge(10);
};

void() f_attack5 = [4, f_attack6]
{
	ai_charge(10);
};

void() f_attack6 = [5, f_attack7]
{
	ai_charge(10);
};

void() f_attack7 = [6, f_attack8]
{
	ai_charge(10);
};

void() f_attack8 = [7, f_attack9]
{
	ai_charge(10);
};

void() f_attack9 = [8, f_attack10]
{
	fish_melee();
};

void() f_attack10 = [9, f_attack11]
{
	ai_charge(10);
};

void() f_attack11 = [10, f_attack12]
{
	ai_charge(10);
};

void() f_attack12 = [11, f_attack13]
{
	ai_charge(10);
};

void() f_attack13 = [12, f_attack14]
{
	ai_charge(10);
};

void() f_attack14 = [13, f_attack15]
{
	ai_charge(10);
};

void() f_attack15 = [14, f_attack16]
{
	fish_melee();
};

void() f_attack16 = [15, f_attack17]
{
	ai_charge(10);
};

void() f_attack17 = [16, f_attack18]
{
	ai_charge(10);
};

void() f_attack18 = [17, f_run1]
{
	ai_charge(10);
};

void() f_death1 = [18, f_death2]
{
	sound(self, CHAN_VOICE, "fish/death.wav", 1, ATTN_NORM);
};

void() f_death2 = [19, f_death3]
{
};

void() f_death3 = [20, f_death4]
{
};

void() f_death4 = [21, f_death5]
{
};

void() f_death5 = [22, f_death6]
{
};

void() f_death6 = [23, f_death7]
{
};

void() f_death7 = [24, f_death8]
{
};

void() f_death8 = [25, f_death9]
{
};

void() f_death9 = [26, f_death10]
{
};

void() f_death10 = [27, f_death11]
{
};

void() f_death11 = [28, f_death12]
{
};

void() f_death12 = [29, f_death13]
{
};

void() f_death13 = [30, f_death14]
{
};

void() f_death14 = [31, f_death15]
{
};

void() f_death15 = [32, f_death16]
{
};

void() f_death16 = [33, f_death17]
{
};

void() f_death17 = [34, f_death18]
{
};

void() f_death18 = [35, f_death19]
{
};

void() f_death19 = [36, f_death20]
{
};

void() f_death20 = [37, f_death21]
{
};

void() f_death21 = [38, f_death21]
{
	self.solid = SOLID_NOT;
};

void() f_pain1 = [57, f_pain2]
{
};

void() f_pain2 = [58, f_pain3]
{
	ai_pain(6);
};

void() f_pain3 = [59, f_pain4]
{
	ai_pain(6);
};

void() f_pain4 = [60, f_pain5]
{
	ai_pain(6);
};

void() f_pain5 = [61, f_pain6]
{
	ai_pain(6);
};

void() f_pain6 = [62, f_pain7]
{
	ai_pain(6);
};

void() f_pain7 = [63, f_pain8]
{
	ai_pain(6);
};

void() f_pain8 = [64, f_pain9]
{
	ai_pain(6);
};

void() f_pain9 = [65, f_run1]
{
	ai_pain(6);
};

void(entity attacker, float damage) fish_pain = 
{
	f_pain1();
};

void() monster_fish = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model2("progs/fish.mdl");
	precache_sound2("fish/death.wav");
	precache_sound2("fish/bite.wav");
	precache_sound2("fish/idle.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/fish.mdl");
	setsize(self, '-16 -16 -24', '16 16 24');
	self.health = 25;
	self.th_stand = f_stand1;
	self.th_walk = f_walk1;
	self.th_run = f_run1;
	self.th_die = f_death1;
	self.th_pain = fish_pain;
	self.th_melee = f_attack1;
	swimmonster_start();
};

