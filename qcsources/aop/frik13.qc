void() GrenCheckAttack = 
{
	local vector spot1;
	local vector spot2;
	local entity targ;
	local float chance;
	if (time < self.attack_finished)
	{
		return 0;
	}
	if (enemy_range == RANGE_FAR)
	{
		if (self.attack_state != AS_STRAIGHT)
		{
			self.attack_state = AS_STRAIGHT;
			gren_run1();
		}
		return 0;
	}
	targ = self.enemy;
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;
	traceline(spot1, spot2, 0, self);
	if (trace_ent != targ)
	{
		if (self.attack_state != AS_STRAIGHT)
		{
			self.attack_state = AS_STRAIGHT;
			gren_run1();
		}
		return 0;
	}
	if (enemy_range == RANGE_MELEE)
	{
		return 1;
	}
	if (enemy_range == RANGE_MID)
	{
		if (self.attack_state != AS_STRAIGHT)
		{
			self.attack_state = AS_STRAIGHT;
			gren_run1();
		}
	}
	else
	{
		return 0;
	}
};

void() GrenAttackFinished = 
{
	self.attack_state = AS_STRAIGHT;
	self.think = gren_run1;
};

void() GrenStopSide = 
{
	self.attack_state = AS_STRAIGHT;
	self.think = gren_run1;
};

void() GrenStartSide = 
{
	self.attack_state = AS_SLIDING;
	self.think = gren_side1;
};

void() Gren_idlesound = 
{
	local float wr;
	wr = random() * TE_LIGHTNING1;
	if (self.waitmin < time)
	{
		self.waitmin = time + SPAWNFLAG_LASER;
		if (wr > 3.5)
		{
			sound(self, CHAN_ITEM, "monsters/grenling/grcoon.wav", SPAWNFLAG_SUPERSPIKE, ATTN_IDLE);
		}
		if (wr < AS_MELEE)
		{
			sound(self, CHAN_AUTO, "monsters/grenling/grhover.wav", SPAWNFLAG_SUPERSPIKE, ATTN_IDLE);
		}
		if (wr < SPAWNFLAG_LASER)
		{
			sound(self, CHAN_AUTO, "monsters/grenling/grtalk1.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
		}
		if (wr > SECRET_1ST_DOWN)
		{
			sound(self, CHAN_AUTO, "monsters/grenling/grtalk2.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
		}
	}
	return;
};

void() gren_stand1 = [26, gren_stand2]
{
	ai_stand();
};

void() gren_stand2 = [27, gren_stand3]
{
	ai_stand();
};

void() gren_stand3 = [28, gren_stand4]
{
	ai_stand();
};

void() gren_stand4 = [29, gren_stand5]
{
	ai_stand();
};

void() gren_stand5 = [30, gren_stand6]
{
	ai_stand();
};

void() gren_stand6 = [31, gren_stand1]
{
	ai_stand();
};

void() gren_walk1 = [48, gren_walk2]
{
	ai_walk(SECRET_NO_SHOOT);
	Gren_idlesound();
};

void() gren_walk2 = [49, gren_walk3]
{
	ai_walk(SECRET_NO_SHOOT);
};

void() gren_walk3 = [50, gren_walk4]
{
	ai_walk(SECRET_NO_SHOOT);
};

void() gren_walk4 = [51, gren_walk5]
{
	ai_walk(SECRET_NO_SHOOT);
};

void() gren_walk5 = [52, gren_walk6]
{
	ai_walk(SECRET_NO_SHOOT);
};

void() gren_walk6 = [53, gren_walk7]
{
	ai_walk(SECRET_NO_SHOOT);
};

void() gren_walk7 = [54, gren_walk8]
{
	ai_walk(SECRET_NO_SHOOT);
};

void() gren_walk8 = [55, gren_walk1]
{
	ai_walk(SECRET_NO_SHOOT);
};

void() gren_side1 = [38, gren_side2]
{
	ai_run(SECRET_YES_SHOOT);
	Gren_idlesound();
};

void() gren_side2 = [39, gren_side3]
{
	ai_run(SECRET_YES_SHOOT);
};

void() gren_side3 = [40, gren_side4]
{
	ai_run(SECRET_YES_SHOOT);
};

void() gren_side4 = [41, gren_side5]
{
	ai_run(SECRET_YES_SHOOT);
};

void() gren_side5 = [42, gren_side6]
{
	ai_run(SECRET_YES_SHOOT);
};

void() gren_side6 = [43, gren_side7]
{
	ai_run(SECRET_YES_SHOOT);
};

void() gren_side7 = [44, gren_side8]
{
	ai_run(SECRET_YES_SHOOT);
};

void() gren_side8 = [45, gren_run1]
{
	ai_run(SECRET_YES_SHOOT);
	GrenStopSide();
};

void() gren_run1 = [32, gren_run2]
{
	ai_run(24);
	Gren_idlesound();
};

void() gren_run2 = [33, gren_run3]
{
	ai_run(24);
};

void() gren_run3 = [34, gren_run4]
{
	ai_run(24);
};

void() gren_run4 = [35, gren_run5]
{
	ai_run(24);
};

void() gren_run5 = [36, gren_run6]
{
	ai_run(24);
};

void() gren_run6 = [37, gren_run1]
{
	ai_run(24);
};

void() Gren_Swipe = 
{
	local vector delta;
	local float ldmg;
	if (!(self.enemy))
	{
		return;
	}
	ai_charge(MSG_BROADCAST);
	delta = self.enemy.origin - self.origin;
	if (vlen(delta) > 100)
	{
		sound(self, CHAN_WEAPON, "monsters/grenling/grswipe.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
		return;
	}
	if (!CanDamage(self.enemy, self))
	{
		sound(self, CHAN_WEAPON, "monsters/grenling/grswipe.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
		return;
	}
	ldmg = (random() + random() + random()) * AS_MELEE;
	T_Damage(self.enemy, self, self, ldmg);
	sound(self, CHAN_AUTO, "monsters/grenling/grcut.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	SpawnMeatSpray(self.origin + v_forward * SECRET_YES_SHOOT, crandom() * 100 * v_right);
	SpawnMeatSpray(self.origin + v_forward * SECRET_YES_SHOOT, crandom() * 100 * v_right);
};

void() gren_fast1 = [64, gren_fast2]
{
	ai_charge(24);
};

void() gren_fast2 = [65, gren_fast3]
{
	ai_charge(24);
};

void() gren_fast3 = [66, gren_fast4]
{
	ai_charge(24);
};

void() gren_fast4 = [67, gren_fast5]
{
	ai_charge(24);
};

void() gren_fast5 = [68, gren_fast6]
{
	ai_charge(24);
	Gren_Swipe();
};

void() gren_fast6 = [69, gren_fast7]
{
	ai_charge(24);
};

void() gren_fast7 = [70, gren_fast8]
{
	ai_charge(24);
};

void() gren_fast8 = [71, gren_run1]
{
	ai_charge(24);
	SUB_AttackFinished(SPAWNFLAG_LASER);
	GrenAttackFinished();
};

void() gren_fastb1 = [72, gren_fastb2]
{
	ai_charge(24);
};

void() gren_fastb2 = [73, gren_fastb3]
{
	ai_charge(24);
};

void() gren_fastb3 = [74, gren_fastb4]
{
	ai_charge(24);
};

void() gren_fastb4 = [75, gren_fastb5]
{
	ai_charge(24);
};

void() gren_fastb5 = [76, gren_fastb6]
{
	ai_charge(24);
	Gren_Swipe();
};

void() gren_fastb6 = [77, gren_fastb7]
{
	ai_charge(24);
};

void() gren_fastb7 = [78, gren_fastb8]
{
	ai_charge(24);
};

void() gren_fastb8 = [79, gren_fastb9]
{
	ai_charge(24);
};

void() gren_fastb9 = [80, gren_fastb10]
{
	ai_charge(24);
	Gren_Swipe();
};

void() gren_fastb10 = [81, gren_run1]
{
	ai_charge(24);
	SUB_AttackFinished(SPAWNFLAG_LASER);
};

void() gren_fastc1 = [82, gren_fastc2]
{
	ai_charge(24);
	Gren_Swipe();
};

void() gren_fastc2 = [83, gren_fastc3]
{
	ai_charge(24);
};

void() gren_fastc3 = [84, gren_fastc4]
{
	ai_charge(24);
};

void() gren_fastc4 = [85, gren_fastc5]
{
	ai_charge(24);
};

void() gren_fastc5 = [86, gren_fastc6]
{
	ai_charge(24);
	Gren_Swipe();
};

void() gren_fastc6 = [87, gren_fastc7]
{
	ai_charge(24);
};

void() gren_fastc7 = [88, gren_fastc8]
{
	ai_charge(24);
};

void() gren_fastc8 = [89, gren_fastc9]
{
	ai_charge(24);
};

void() gren_fastc9 = [90, gren_fastc10]
{
	ai_charge(24);
	Gren_Swipe();
};

void() gren_fastc10 = [91, gren_fastc11]
{
	ai_charge(24);
};

void() gren_fastc11 = [92, gren_run1]
{
	ai_charge(24);
	SUB_AttackFinished(SPAWNFLAG_LASER);
	GrenAttackFinished();
};

void() gren_fast = 
{
	if (random() <= 0.3)
	{
		gren_fast1();
	}
	else
	{
		if (random() <= 0.6)
		{
			gren_fastb1();
		}
		else
		{
			gren_fastc1();
		}
	}
};

void() gren_pain1 = [93, gren_pain2]
{
};

void() gren_pain2 = [94, gren_pain3]
{
};

void() gren_pain3 = [95, gren_pain4]
{
};

void() gren_pain4 = [96, gren_pain5]
{
};

void() gren_pain5 = [97, gren_pain6]
{
};

void() gren_pain6 = [98, gren_pain7]
{
};

void() gren_pain7 = [99, gren_run1]
{
	GrenStopSide();
};

void() gren_painb1 = [100, gren_painb2]
{
};

void() gren_painb2 = [101, gren_painb3]
{
};

void() gren_painb3 = [102, gren_painb4]
{
};

void() gren_painb4 = [103, gren_painb5]
{
};

void() gren_painb5 = [104, gren_painb6]
{
};

void() gren_painb6 = [105, gren_painb7]
{
};

void() gren_painb7 = [106, gren_run1]
{
	GrenStopSide();
};

void() gren_death1 = [107, gren_death2]
{
	self.velocity_x = -200 + 400 * random();
	self.velocity_y = -200 + 400 * random();
	self.velocity_z = 100 + 100 * random();
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	sound(self, CHAN_VOICE, "monsters/grenling/grdie1.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	self.solid = SOLID_NOT;
	setsize(self, '-29 -21 -8', '29 24 4');
};

void() gren_death2 = [108, gren_death3]
{
};

void() gren_death3 = [109, gren_death4]
{
};

void() gren_death4 = [110, gren_death5]
{
};

void() gren_death5 = [111, gren_death6]
{
};

void() gren_death6 = [112, gren_death7]
{
};

void() gren_death7 = [113, gren_death8]
{
};

void() gren_death8 = [114, gren_death9]
{
};

void() gren_death9 = [115, gren_death10]
{
};

void() gren_death10 = [116, gren_death10]
{
	CorpseThink();
};

void() gren_deathb1 = [119, gren_deathb2]
{
	self.velocity_x = -200 + 400 * random();
	self.velocity_y = -200 + 400 * random();
	self.velocity_z = 100 + 100 * random();
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	sound(self, CHAN_VOICE, "monsters/grenling/grdie2.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	self.solid = SOLID_NOT;
	setsize(self, '-8 -8 -8', '8 8 4');
};

void() gren_deathb2 = [120, gren_deathb3]
{
};

void() gren_deathb3 = [121, gren_deathb4]
{
};

void() gren_deathb4 = [122, gren_deathb5]
{
};

void() gren_deathb5 = [123, gren_deathb6]
{
};

void() gren_deathb6 = [124, gren_deathb7]
{
};

void() gren_deathb7 = [125, gren_deathb8]
{
};

void() gren_deathb8 = [126, gren_deathb9]
{
};

void() gren_deathb9 = [127, gren_deathb10]
{
};

void() gren_deathb10 = [128, gren_deathb11]
{
};

void() gren_deathb11 = [129, gren_deathb11]
{
	CorpseThink();
};

void() gren_die = 
{
	if (self.health < -40)
	{
		sound(self, CHAN_VOICE, "monsters/grenling/grdie1.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
		ThrowHead("progs/h_gren.mdl", self.health);
		ThrowGib("progs/grenbone.mdl", self.health);
		ThrowGib("progs/grenbone.mdl", self.health);
		ThrowGib("progs/grenbone.mdl", self.health);
		ThrowGib("progs/grenbone.mdl", self.health);
		ThrowGib("progs/gib2.mdl", self.health);
		ThrowGib("progs/gib2.mdl", self.health);
		return;
	}
	if (random() < 0.5)
	{
		gren_death1();
	}
	else
	{
		gren_deathb1();
	}
};

void(entity attacker, float damage) Gren_Pain = 
{
	if (random() * 70 > damage)
	{
		return;
	}
	if (self.pain_finished > time)
	{
		return;
	}
	if (random() > 0.5)
	{
		sound(self, CHAN_BODY, "monsters/grenling/grpain1.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
		gren_pain1();
		self.pain_finished = time + 0.2;
	}
	else
	{
		sound(self, CHAN_BODY, "monsters/grenling/grpain2.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
		gren_painb1();
		self.pain_finished = time + 0.4;
	}
};

void() monster_grenling = 
{
	local float rand;
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/grenling.mdl");
	precache_model("progs/grenbone.mdl");
	precache_model("progs/h_gren.mdl");
	precache_model("progs/w_spike.mdl");
	precache_sound("monsters/grenling/grswipe.wav");
	precache_sound("monsters/grenling/grcut.wav");
	precache_sound("monsters/grenling/grtalk1.wav");
	precache_sound("monsters/grenling/grtalk2.wav");
	precache_sound("monsters/grenling/grcoon.wav");
	precache_sound("monsters/grenling/grdie1.wav");
	precache_sound("monsters/grenling/grdie2.wav");
	precache_sound("monsters/grenling/grhover.wav");
	precache_sound("monsters/grenling/grpain1.wav");
	precache_sound("monsters/grenling/grpain2.wav");
	precache_sound("monsters/grenling/grsight1.wav");
	precache_sound("monsters/grenling/grsight2.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/grenling.mdl");
	setsize(self, '-26 -26 -25', '15 28 20');
	self.health = 130;
	rand = random() * TE_LIGHTNING2;
	if (rand < SPAWNFLAG_SUPERSPIKE)
	{
		self.th_stand = gren_stand1;
	}
	else
	{
		if (rand < SPAWNFLAG_LASER)
		{
			self.th_stand = gren_stand2;
		}
		else
		{
			if (rand < AS_MELEE)
			{
				self.th_stand = gren_stand3;
			}
			else
			{
				if (rand < SECRET_1ST_DOWN)
				{
					self.th_stand = gren_stand4;
				}
				else
				{
					if (rand < TE_LIGHTNING1)
					{
						self.th_stand = gren_stand5;
					}
					else
					{
						self.th_stand = gren_stand6;
					}
				}
			}
		}
	}
	self.th_walk = gren_walk1;
	self.th_run = gren_run1;
	self.th_melee = gren_fast;
	self.th_pain = Gren_Pain;
	self.th_die = gren_die;
	flymonster_start();
};

void() monster_gren = 
{
	monster_grenling();
};

