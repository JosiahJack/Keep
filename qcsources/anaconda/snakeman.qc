void() snake_stand = [9, snake_stand2]
{
	ai_stand();
};

void() snake_stand2 = [10, snake_stand3]
{
	ai_turn();
};

void() snake_stand3 = [11, snake_stand4]
{
	ai_stand();
};

void() snake_stand4 = [12, snake_stand5]
{
	ai_turn();
};

void() snake_stand5 = [13, snake_stand6]
{
	ai_stand();
};

void() snake_stand6 = [14, snake_stand7]
{
	ai_turn();
};

void() snake_stand7 = [15, snake_stand8]
{
	ai_turn();
};

void() snake_stand8 = [14, snake_stand9]
{
	ai_turn();
};

void() snake_stand9 = [13, snake_stand10]
{
	ai_stand();
};

void() snake_stand10 = [12, snake_stand11]
{
	ai_turn();
};

void() snake_stand11 = [11, snake_stand12]
{
	ai_stand();
};

void() snake_stand12 = [10, snake_stand]
{
	ai_turn();
};

void() snake_walk1 = [0, snake_walk2]
{
	if (random() < 0.2)
	{
		sound(self, CHAN_VOICE, "wizard/widle2.wav", ATTN_NORM, ATTN_IDLE);
	}
	ai_walk(ATTN_IDLE);
};

void() snake_walk2 = [1, snake_walk3]
{
	ai_walk(SOLID_SLIDEBOX);
};

void() snake_walk3 = [2, snake_walk4]
{
	ai_walk(SOLID_SLIDEBOX);
};

void() snake_walk4 = [3, snake_walk5]
{
	ai_walk(SOLID_SLIDEBOX);
};

void() snake_walk5 = [4, snake_walk6]
{
	ai_walk(SOLID_SLIDEBOX);
};

void() snake_walk6 = [5, snake_walk7]
{
	ai_walk(SOLID_SLIDEBOX);
};

void() snake_walk7 = [6, snake_walk8]
{
	ai_walk(SOLID_SLIDEBOX);
};

void() snake_walk8 = [7, snake_walk9]
{
	ai_walk(SOLID_SLIDEBOX);
};

void() snake_walk9 = [8, snake_walk10]
{
	ai_walk(SOLID_SLIDEBOX);
};

void() snake_walk10 = [9, snake_walk11]
{
	ai_walk(SOLID_SLIDEBOX);
};

void() snake_walk11 = [10, snake_walk12]
{
	ai_walk(SOLID_SLIDEBOX);
};

void() snake_walk12 = [11, snake_walk13]
{
	ai_walk(ATTN_IDLE);
};

void() snake_walk13 = [12, snake_walk14]
{
	ai_walk(ATTN_IDLE);
};

void() snake_walk14 = [13, snake_walk15]
{
	ai_walk(ATTN_IDLE);
};

void() snake_walk15 = [14, snake_walk16]
{
	ai_walk(ATTN_NORM);
};

void() snake_walk16 = [15, snake_walk1]
{
	ai_walk(ATTN_NORM);
};

void() snake_run1 = [0, snake_run2]
{
	self.attack_state = AS_SLIDING;
	if (random() < 0.2)
	{
		sound(self, CHAN_VOICE, "wizard/widle1.wav", ATTN_NORM, ATTN_IDLE);
	}
	ai_run(MOVETYPE_TOSS);
};

void() snake_run2 = [2, snake_run3]
{
	ai_run(TE_LIGHTNING3);
};

void() snake_run3 = [4, snake_run4]
{
	ai_run(MOVETYPE_TOSS);
};

void() snake_run4 = [6, snake_run5]
{
	ai_run(TE_LIGHTNING3);
};

void() snake_run5 = [8, snake_run6]
{
	self.attack_state = AS_STRAIGHT;
	ai_face();
};

void() snake_run6 = [10, snake_run7]
{
	ai_run(15);
};

void() snake_run7 = [12, snake_run8]
{
	ai_run(12);
};

void() snake_run8 = [14, snake_run1]
{
	ai_run(15);
};

void() snake_attack1 = [16, snake_attack6]
{
	sound(self, CHAN_VOICE, "wizard/wattack.wav", AS_STRAIGHT, ATTN_NORM);
	ai_face();
};

void() snake_attack6 = [21, snake_attack7]
{
	ai_run(12);
	ai_run_slide();
	SnakeMissile(CHAN_VOICE);
	SnakeMissile(CONTENT_SOLID);
};

void() snake_attack7 = [22, snake_attack8]
{
	ai_run(12);
	ai_run_slide();
	SnakeMissile(ATTN_NORM);
	SnakeMissile(CONTENT_EMPTY);
};

void() snake_attack8 = [23, snake_attack9]
{
	ai_run(12);
	ai_run_slide();
	SnakeMissile(STATE_TOP);
	SnakeMissile(STATE_TOP);
};

void() snake_attack9 = [24, snake_attack10]
{
	ai_run(12);
	ai_run_slide();
	SnakeMissile(STATE_TOP);
	SnakeMissile(STATE_TOP);
};

void() snake_attack10 = [25, snake_run1]
{
	ai_run(12);
	ai_run_slide();
	SnakeMissile(STATE_TOP);
	SnakeMissile(STATE_TOP);
	SUB_CheckRefire(snake_attack1);
};

void() snake_pain1 = [26, snake_pain2]
{
};

void() snake_pain2 = [27, snake_pain3]
{
};

void() snake_pain3 = [28, snake_pain4]
{
};

void() snake_pain4 = [29, snake_pain5]
{
};

void() snake_pain5 = [30, snake_pain6]
{
};

void() snake_pain6 = [31, snake_pain7]
{
};

void() snake_pain7 = [32, snake_run1]
{
};

void() snake_bpain1 = [52, snake_bpain2]
{
};

void() snake_bpain2 = [53, snake_bpain3]
{
};

void() snake_bpain3 = [54, snake_bpain4]
{
};

void() snake_bpain4 = [55, snake_bpain5]
{
};

void() snake_bpain5 = [56, snake_bpain6]
{
};

void() snake_bpain6 = [57, snake_bpain7]
{
};

void() snake_bpain7 = [58, snake_run1]
{
};

void() snake_death1 = [36, snake_death3]
{
};

void() snake_death3 = [37, snake_death4]
{
};

void() snake_death4 = [38, snake_death5]
{
};

void() snake_death5 = [39, snake_death6]
{
};

void() snake_death6 = [40, snake_death7]
{
};

void() snake_death7 = [41, snake_death8]
{
};

void() snake_death8 = [42, snake_death9]
{
};

void() snake_death9 = [43, snake_death10]
{
	self.ammo_nails = 15;
	DropBackpack();
};

void() snake_death10 = [44, snake_death11]
{
};

void() snake_death11 = [45, snake_death12]
{
};

void() snake_death12 = [45, snake_death12]
{
};

void() snake_dead1 = [46, snake_dead2]
{
};

void() snake_dead2 = [47, snake_dead3]
{
};

void() snake_dead3 = [48, snake_dead4]
{
};

void() snake_dead4 = [49, snake_dead5]
{
	self.ammo_nails = 15;
	DropBackpack();
};

void() snake_dead5 = [50, snake_dead6]
{
};

void() snake_dead6 = [51, snake_dead6]
{
};

void() snake_pain = 
{
	if (self.pain_finished > time)
	{
		return;
	}
	sound(self, CHAN_VOICE, "ogre/ogpain1.wav", ATTN_NORM, ATTN_NORM);
	self.velocity_x = -50 - 50 * random();
	self.velocity_y = STATE_TOP;
	self.velocity_z = TE_LIGHTNING1 + CHAN_VOICE * random();
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	self.pain_finished = time + SOLID_SLIDEBOX;
	if (random() > 0.5)
	{
		snake_pain1();
	}
	else
	{
		snake_bpain1();
	}
};

void() snake_die = 
{
	if (self.health < -25)
	{
		sound(self, CHAN_VOICE, "player/udeath.wav", ATTN_NORM, ATTN_NORM);
		ThrowHead("progs/gib3.mdl", self.health);
		ThrowGib("progs/gib1.mdl", self.health);
		ThrowGib("progs/gib2.mdl", self.health);
		ThrowGib("progs/uzi.mdl", self.health);
		ThrowGib("progs/uzi.mdl", self.health);
		ThrowGib("progs/gib2.mdl", self.health);
		return;
	}
	sound(self, CHAN_VOICE, "wizard/wdeath.wav", ATTN_NORM, ATTN_NORM);
	self.movetype = MOVETYPE_BOUNCE;
	self.velocity_x = -50 + 100 * random();
	self.velocity_y = -50 + 100 * random();
	self.velocity_z = CHAN_VOICE + CHAN_VOICE * random();
	self.avelocity_x = -20 + 40 * random();
	self.avelocity_y = -200 + 400 * random();
	self.avelocity_z = STATE_TOP;
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	self.solid = SOLID_NOT;
	snake_death1();
};

void(float offset) SnakeMissile = 
{
	local vector offang;
	local vector org;
	local vector vec;
	self.effects = self.effects | EF_MUZZLEFLASH;
	offang = vectoangles(self.enemy.origin - self.origin);
	offang_y = offang_y + offset * MOVETYPE_TOSS;
	makevectors(offang);
	org = self.origin - SVC_INTERMISSION * normalize(self.velocity);
	vec = normalize(v_forward);
	vec_z = SOLID_NOT - vec_z + (random() - 0.5) * 0.1;
	launch_spike(org, vec);
	newmis.classname = "LaunchNails";
	setmodel(newmis, "progs/spike.mdl");
	setsize(newmis, VEC_ORIGIN, VEC_ORIGIN);
	newmis.velocity = vec * 1000;
	sound(self, CHAN_WEAPON, "weapons/sgun1.wav", CHAN_WEAPON, ATTN_NORM);
};

void() monster_snakeman = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model2("progs/snakeman.mdl");
	precache_model2("progs/k_spike.mdl");
	precache_model2("progs/uzi.mdl");
	precache_sound2("wizard/wattack.wav");
	precache_sound2("wizard/widle2.wav");
	precache_sound2("wizard/wdeath.wav");
	precache_sound2("wizard/widle1.wav");
	precache_sound2("ogre/ogpain1.wav");
	precache_sound2("wizard/wdeath.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/snakeman.mdl");
	setsize(self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	self.health = 150;
	self.th_stand = snake_stand;
	self.th_walk = snake_walk1;
	self.th_run = snake_run1;
	self.th_die = snake_die;
	self.th_pain = snake_pain;
	self.th_missile = snake_attack1;
	self.think = walkmonster_start;
	self.nextthink = time + 0.1 + random() * 0.1;
};

