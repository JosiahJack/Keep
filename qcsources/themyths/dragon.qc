void() drag_stnd1 = [0, drag_stnd2]
{
	sound(self, CHAN_VOICE, "dragon/idlefly.wav", 1, ATTN_IDLE);
	ai_stand();
};

void() drag_stnd2 = [1, drag_stnd3]
{
	drag_ai_stand();
};

void() drag_stnd3 = [2, drag_stnd4]
{
	drag_ai_stand();
};

void() drag_stnd4 = [3, drag_stnd5]
{
	drag_ai_stand();
};

void() drag_stnd5 = [4, drag_stnd6]
{
	drag_ai_stand();
};

void() drag_stnd6 = [5, drag_stnd7]
{
	drag_ai_stand();
};

void() drag_stnd7 = [6, drag_stnd8]
{
	drag_ai_stand();
};

void() drag_stnd8 = [7, drag_stnd9]
{
	drag_ai_stand();
};

void() drag_stnd9 = [6, drag_stnd10]
{
	drag_ai_stand();
};

void() drag_stnd10 = [5, drag_stnd11]
{
	drag_ai_stand();
};

void() drag_stnd11 = [4, drag_stnd12]
{
	drag_ai_stand();
};

void() drag_stnd12 = [3, drag_stnd13]
{
	drag_ai_stand();
};

void() drag_stnd13 = [2, drag_stnd14]
{
	drag_ai_stand();
};

void() drag_stnd14 = [1, drag_stnd1]
{
	drag_ai_stand();
};

void() drag_walk1 = [0, drag_walk2]
{
	sound(self, CHAN_VOICE, "dragon/idlefly.wav", 1, ATTN_IDLE);
	drag_ai_walk(MOVETYPE_FLY);
};

void() drag_walk2 = [1, drag_walk3]
{
	drag_ai_walk(MOVETYPE_FLY);
};

void() drag_walk3 = [2, drag_walk4]
{
	drag_ai_walk(MOVETYPE_FLY);
};

void() drag_walk4 = [3, drag_walk5]
{
	drag_ai_walk(MOVETYPE_FLY);
};

void() drag_walk5 = [4, drag_walk6]
{
	drag_ai_walk(MOVETYPE_FLY);
};

void() drag_walk6 = [5, drag_walk7]
{
	drag_ai_walk(MOVETYPE_FLY);
};

void() drag_walk7 = [6, drag_walk8]
{
	drag_ai_walk(MOVETYPE_FLY);
};

void() drag_walk8 = [7, drag_walk9]
{
	drag_ai_walk(MOVETYPE_FLY);
};

void() drag_walk9 = [6, drag_walk10]
{
	drag_ai_walk(MOVETYPE_FLY);
};

void() drag_walk10 = [5, drag_walk11]
{
	drag_ai_walk(MOVETYPE_FLY);
};

void() drag_walk11 = [4, drag_walk12]
{
	drag_ai_walk(MOVETYPE_FLY);
};

void() drag_walk12 = [3, drag_walk13]
{
	drag_ai_walk(MOVETYPE_FLY);
};

void() drag_walk13 = [2, drag_walk14]
{
	drag_ai_walk(MOVETYPE_FLY);
};

void() drag_walk14 = [1, drag_walk1]
{
	drag_ai_walk(MOVETYPE_FLY);
};

void() drag_run1 = [0, drag_run2]
{
	sound(self, CHAN_VOICE, "dragon/idlefly.wav", 1, ATTN_IDLE);
	drag_ai_run(14);
};

void() drag_run2 = [1, drag_run3]
{
	drag_ai_run(14);
};

void() drag_run3 = [2, drag_run4]
{
	drag_ai_run(14);
};

void() drag_run4 = [3, drag_run5]
{
	drag_ai_run(14);
};

void() drag_run5 = [4, drag_run6]
{
	drag_ai_run(14);
};

void() drag_run6 = [5, drag_run7]
{
	if (random() > 0.4)
	{
		self.velocity_z = self.velocity_z + 50;
	}
	drag_ai_run(14);
};

void() drag_run7 = [6, drag_run8]
{
	drag_ai_run(14);
};

void() drag_run8 = [7, drag_run9]
{
	drag_ai_run(14);
};

void() drag_run9 = [6, drag_run10]
{
	drag_ai_run(14);
};

void() drag_run10 = [5, drag_run11]
{
	drag_ai_run(14);
};

void() drag_run11 = [4, drag_run12]
{
	drag_ai_run(14);
};

void() drag_run12 = [3, drag_run13]
{
	drag_ai_run(14);
};

void() drag_run13 = [2, drag_run14]
{
	drag_ai_run(14);
};

void() drag_run14 = [1, drag_run1]
{
	drag_ai_run(14);
};

void() drag_pain1 = [8, drag_pain2]
{
};

void() drag_pain2 = [9, drag_run1]
{
};

void() drag_atk1 = [10, drag_atk2]
{
	sound(self, CHAN_VOICE, "dragon/attack.wav", 1, ATTN_NORM);
	drag_ai_charge(14);
};

void() drag_atk2 = [11, drag_atk3]
{
	drag_ai_charge(STAT_TOTALMONSTERS);
	DragonMissile();
};

void() drag_atk3 = [12, drag_atk4]
{
	drag_ai_charge(14);
	DragonMissile();
};

void() drag_atk4 = [13, drag_atk5]
{
	drag_ai_charge(STAT_TOTALMONSTERS);
	DragonMissile();
};

void() drag_atk5 = [14, drag_atk6]
{
	drag_ai_charge(14);
	DragonMissile();
};

void() drag_atk6 = [15, drag_atk7]
{
	drag_ai_charge(STAT_TOTALMONSTERS);
	DragonMissile();
};

void() drag_atk7 = [16, drag_atk8]
{
	drag_ai_charge(14);
	DragonMissile();
};

void() drag_atk8 = [17, drag_run1]
{
	drag_ai_charge(STAT_TOTALMONSTERS);
	SUB_AttackFinished(MOVETYPE_WALK);
};

void() drag_dth1 = [0, drag_dth2]
{
	self.velocity_x = -250 + 400 * random();
	self.velocity_y = -250 + 400 * random();
	self.velocity_z = MIN_CHARMER_DISTANCE + 100 * random();
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	sound(self, CHAN_VOICE, "dragon/death.wav", 1, ATTN_NORM);
};

void() drag_dth2 = [1, drag_dth3]
{
};

void() drag_dth3 = [2, drag_dth4]
{
};

void() drag_dth4 = [3, drag_dth5]
{
};

void() drag_dth5 = [4, drag_dth5]
{
};

void(entity attacker, float damage) dragon_pain = 
{
	self.enemy = attacker;
	if (self.pain_finished > time)
	{
		return;
	}
	sound(self, CHAN_VOICE, "dragon/pain.wav", 1, ATTN_NORM);
	if (random() * 75 > damage)
	{
		return;
	}
	self.pain_finished = time + MOVETYPE_WALK;
};

void() dragon_die = 
{
	if (self.health < -50)
	{
		sound(self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		if (random() < 0.7)
		{
			ThrowHead("progs/t_drag.mdl", self.health * 1.5 * random());
		}
		else
		{
			ThrowHead("progs/w_drag.mdl", self.health * 1.5 * random());
		}
		ThrowGib("progs/gib1.mdl", self.health * 1.5 * random());
		ThrowGib("progs/gib3.mdl", self.health * 1.5 * random());
		ThrowGib("progs/gib1.mdl", self.health * 1.5 * random());
		ThrowGib("progs/gib3.mdl", self.health * 1.5 * random());
		ThrowGib("progs/gib1.mdl", self.health * 1.5 * random());
		ThrowGib("progs/gib3.mdl", self.health * 1.5 * random());
		ThrowGib("progs/gib1.mdl", self.health * 1.5 * random());
		ThrowGib("progs/gib3.mdl", self.health * 1.5 * random());
		return;
	}
	self.solid = SOLID_NOT;
	drag_dth1();
};

void(float offset) DragonMissile = 
{
	local vector org;
	local vector vec;
	local float ox;
	makevectors(self.angles);
	org = self.origin + v_forward * SVC_INTERMISSION + v_right * ox + VEC_ORIGIN;
	vec = self.enemy.origin - self.origin;
	vec = normalize(vec);
	WeldFire(org, vec);
};

void() DragonCheckAttack = 
{
	local vector spot1;
	local vector spot2;
	local entity targ;
	local float chance;
	if (time < self.attack_finished)
	{
		return 0;
	}
	if (!enemy_vis)
	{
		return 0;
	}
	targ = self.enemy;
	if (self.enemy.health <= 0)
	{
		return 0;
	}
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;
	traceline(spot1, spot2, 0, self);
	if (trace_ent != targ)
	{
		if (self.attack_state != AS_STRAIGHT)
		{
			self.attack_state = AS_STRAIGHT;
			drag_run1();
		}
		return 0;
	}
	if (enemy_range == RANGE_MELEE)
	{
		walkmove(self.angles_y + 180, MOVETYPE_FLY);
		self.velocity_z = MIN_CHARMER_DISTANCE;
		self.velocity_y = MIN_CHARMER_DISTANCE * random();
		self.velocity_x = MIN_CHARMER_DISTANCE * random();
		chance = 0.9;
	}
	if (enemy_range == RANGE_NEAR)
	{
		chance = SERVO_VOLUME;
	}
	else
	{
		if (enemy_range == RANGE_MID)
		{
			chance = 0.2;
		}
	}
	if (random() > chance)
	{
		self.attack_state = AS_MISSILE;
		return 1;
	}
	return 0;
};

void() monster_dragon = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model2("progs/dragon.mdl");
	precache_model2("progs/t_drag.mdl");
	precache_model2("progs/w_drag.mdl");
	precache_model2("progs/flame.mdl");
	precache_model2("progs/flame2.mdl");
	precache_sound2("dragon/attack.wav");
	precache_sound2("dragon/death.wav");
	precache_sound("dragon/hit.wav");
	precache_sound2("dragon/idlefly.wav");
	precache_sound2("dragon/pain.wav");
	precache_sound2("dragon/sight.wav");
	precache_sound2("hknight/idle.wav");
	precache_sound2("ambience/fire1.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/dragon.mdl");
	setsize(self, '-148 -160 -35', '148 160 10');
	self.health = 900;
	self.th_stand = drag_stnd1;
	self.th_walk = drag_walk1;
	self.th_run = drag_run1;
	self.th_die = dragon_die;
	self.th_pain = dragon_pain;
	self.th_missile = drag_atk1;
	flymonster_start();
};

