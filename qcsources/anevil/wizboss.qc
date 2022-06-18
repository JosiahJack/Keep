void(entity missile, float mspeed, float accuracy) LaunchMissileB = 
{
	local vector vec;
	local vector move;
	local float fly;
	makevectors(self.angles);
	vec = self.enemy.origin + self.enemy.mins + self.enemy.size * 0.7 - missile.origin;
	fly = vlen(vec) / mspeed;
	move = self.enemy.velocity;
	move_z = MSG_BROADCAST;
	vec = vec + move * fly;
	vec = normalize(vec);
	vec = vec + accuracy * v_up * (random() - 0.5) + accuracy * v_right * (random() - 0.5);
	missile.velocity = vec * mspeed;
	missile.angles = VEC_ORIGIN;
	missile.angles_y = vectoyaw(missile.velocity);
	missile.nextthink = time + IQ_ULTIMATE;
	missile.think = SUB_Remove;
};

void() WizardCheckAttackB = 
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
	if (enemy_range == RANGE_FAR)
	{
		if (self.attack_state != AS_STRAIGHT)
		{
			self.attack_state = AS_STRAIGHT;
			wiz_runb1();
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
			wiz_runb1();
		}
		return 0;
	}
	if (enemy_range == RANGE_MELEE)
	{
		chance = 0.9;
	}
	else
	{
		if (enemy_range == RANGE_NEAR)
		{
			chance = 0.7;
		}
		else
		{
			if (enemy_range == RANGE_MID)
			{
				chance = 0.4;
			}
			else
			{
				chance = MSG_BROADCAST;
			}
		}
	}
	if (random() < chance)
	{
		self.attack_state = AS_MISSILE;
		return 1;
	}
	if (enemy_range == RANGE_MID)
	{
		if (self.attack_state != AS_STRAIGHT)
		{
			self.attack_state = AS_STRAIGHT;
			wiz_runb1();
		}
	}
	else
	{
		if (self.attack_state != AS_SLIDING)
		{
			self.attack_state = AS_SLIDING;
			wiz_sideb1();
		}
	}
	return 0;
};

void() WizardAttackFinishedb = 
{
	if (enemy_range >= RANGE_MID || !enemy_vis)
	{
		self.attack_state = AS_STRAIGHT;
		self.think = wiz_runb1;
	}
	else
	{
		self.attack_state = AS_SLIDING;
		self.think = wiz_sideb1;
	}
};

void() wiz_fastbFireB = 
{
	local vector vec;
	local vector dst;
	if (self.owner.health > MSG_BROADCAST)
	{
		self.owner.effects = self.owner.effects | EF_MUZZLEFLASH;
		makevectors(self.enemy.angles);
		dst = self.enemy.origin - 13 * self.movedir;
		vec = normalize(dst - self.origin);
		sound(self, CHAN_WEAPON, "wizboss/wattack.wav", SPAWN_FLOATING, ATTN_NORM);
		launch_spike(self.origin, vec);
		newmis.velocity = vec * 600;
		newmis.owner = self.owner;
		newmis.classname = "wizspike";
		setmodel(newmis, "progs/wbspike.mdl");
		setsize(newmis, VEC_ORIGIN, VEC_ORIGIN);
	}
	remove(self);
};

void() Wiz_StartFastB = 
{
	local entity missile;
	sound(self, CHAN_WEAPON, "wizboss/wattack.wav", SPAWN_FLOATING, ATTN_NORM);
	self.v_angle = self.angles;
	makevectors(self.angles);
	missile = spawn();
	missile.owner = self;
	missile.nextthink = time + 0.6;
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, self.origin + '0 0 30' + v_forward * 14 + v_right * 14);
	missile.enemy = self.enemy;
	missile.nextthink = time + 0.8;
	missile.think = wiz_fastbFireB;
	missile.movedir = v_right;
	missile = spawn();
	missile.owner = self;
	missile.nextthink = time + SPAWN_FLOATING;
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, self.origin + '0 0 30' + v_forward * 14 + v_right * -14);
	missile.enemy = self.enemy;
	missile.nextthink = time + 0.3;
	missile.think = wiz_fastbFireB;
	missile.movedir = VEC_ORIGIN - v_right;
};

void() Wiz_idlesoundB = 
{
	local float wr;
	wr = random() * IQ_ULTIMATE;
	if (self.waitmin < time)
	{
		self.waitmin = time + SPAWN_STATUE;
		if (wr > 4.5)
		{
			sound(self, CHAN_VOICE, "wizboss/widle1.wav", SPAWN_FLOATING, ATTN_IDLE);
		}
		if (wr < 1.5)
		{
			sound(self, CHAN_VOICE, "wizboss/widle2.wav", SPAWN_FLOATING, ATTN_IDLE);
		}
	}
	return;
};

void() wiz_standb1 = [0, wiz_standb2]
{
	ai_stand();
};

void() wiz_standb2 = [1, wiz_standb3]
{
	ai_stand();
};

void() wiz_standb3 = [2, wiz_standb4]
{
	ai_stand();
};

void() wiz_standb4 = [3, wiz_standb5]
{
	ai_stand();
};

void() wiz_standb5 = [4, wiz_standb6]
{
	ai_stand();
};

void() wiz_standb6 = [5, wiz_standb7]
{
	ai_stand();
};

void() wiz_standb7 = [6, wiz_standb8]
{
	ai_stand();
};

void() wiz_standb8 = [7, wiz_standb1]
{
	ai_stand();
};

void() wiz_walkb1 = [0, wiz_walkb2]
{
	ai_walk(SPAWN_CUT);
	Wiz_idlesoundB();
};

void() wiz_walkb2 = [1, wiz_walkb3]
{
	ai_walk(SPAWN_CUT);
};

void() wiz_walkb3 = [2, wiz_walkb4]
{
	ai_walk(SPAWN_CUT);
};

void() wiz_walkb4 = [3, wiz_walkb5]
{
	ai_walk(SPAWN_CUT);
};

void() wiz_walkb5 = [4, wiz_walkb6]
{
	ai_walk(SPAWN_CUT);
};

void() wiz_walkb6 = [5, wiz_walkb7]
{
	ai_walk(SPAWN_CUT);
};

void() wiz_walkb7 = [6, wiz_walkb8]
{
	ai_walk(SPAWN_CUT);
};

void() wiz_walkb8 = [7, wiz_walkb1]
{
	ai_walk(SPAWN_CUT);
};

void() wiz_sideb1 = [0, wiz_sideb2]
{
	ai_run(SPAWN_CUT);
	Wiz_idlesoundB();
};

void() wiz_sideb2 = [1, wiz_sideb3]
{
	ai_run(SPAWN_CUT);
};

void() wiz_sideb3 = [2, wiz_sideb4]
{
	ai_run(SPAWN_CUT);
};

void() wiz_sideb4 = [3, wiz_sideb5]
{
	ai_run(SPAWN_CUT);
};

void() wiz_sideb5 = [4, wiz_sideb6]
{
	ai_run(SPAWN_CUT);
};

void() wiz_sideb6 = [5, wiz_sideb7]
{
	ai_run(SPAWN_CUT);
};

void() wiz_sideb7 = [6, wiz_sideb8]
{
	ai_run(SPAWN_CUT);
};

void() wiz_sideb8 = [7, wiz_sideb1]
{
	ai_run(SPAWN_CUT);
};

void() wiz_runb1 = [15, wiz_runb2]
{
	ai_run(SECRET_YES_SHOOT);
	Wiz_idlesoundB();
};

void() wiz_runb2 = [16, wiz_runb3]
{
	ai_run(SECRET_YES_SHOOT);
};

void() wiz_runb3 = [17, wiz_runb4]
{
	ai_run(SECRET_YES_SHOOT);
};

void() wiz_runb4 = [18, wiz_runb5]
{
	ai_run(SECRET_YES_SHOOT);
};

void() wiz_runb5 = [19, wiz_runb6]
{
	ai_run(SECRET_YES_SHOOT);
};

void() wiz_runb6 = [20, wiz_runb7]
{
	ai_run(SECRET_YES_SHOOT);
};

void() wiz_runb7 = [21, wiz_runb8]
{
	ai_run(SECRET_YES_SHOOT);
};

void() wiz_runb8 = [22, wiz_runb9]
{
	ai_run(SECRET_YES_SHOOT);
};

void() wiz_runb9 = [23, wiz_runb10]
{
	ai_run(SECRET_YES_SHOOT);
};

void() wiz_runb10 = [24, wiz_runb11]
{
	ai_run(SECRET_YES_SHOOT);
};

void() wiz_runb11 = [25, wiz_runb12]
{
	ai_run(SECRET_YES_SHOOT);
};

void() wiz_runb12 = [26, wiz_runb13]
{
	ai_run(SECRET_YES_SHOOT);
};

void() wiz_runb13 = [27, wiz_runb14]
{
	ai_run(SECRET_YES_SHOOT);
};

void() wiz_runb14 = [28, wiz_runb1]
{
	ai_run(SECRET_YES_SHOOT);
};

void() wiz_fastb1 = [29, wiz_fastb2]
{
	ai_face();
	Wiz_StartFastB();
};

void() wiz_fastb2 = [30, wiz_fastb3]
{
	ai_face();
};

void() wiz_fastb3 = [31, wiz_fastb4]
{
	ai_face();
};

void() wiz_fastb4 = [32, wiz_fastb5]
{
	ai_face();
};

void() wiz_fastb5 = [33, wiz_fastb6]
{
	ai_face();
};

void() wiz_fastb6 = [34, wiz_fastb7]
{
	ai_face();
};

void() wiz_fastb7 = [33, wiz_fastb8]
{
	ai_face();
};

void() wiz_fastb8 = [32, wiz_fastb9]
{
	ai_face();
};

void() wiz_fastb9 = [31, wiz_fastb10]
{
	ai_face();
};

void() wiz_fastb10 = [30, wiz_runb1]
{
	ai_face();
	SUB_AttackFinished(SPAWN_STATUE);
	WizardAttackFinishedb();
};

void() wiz_painb1 = [42, wiz_painb2]
{
};

void() wiz_painb2 = [43, wiz_painb3]
{
};

void() wiz_painb3 = [44, wiz_painb4]
{
};

void() wiz_painb4 = [45, wiz_runb1]
{
};

void() wiz_deathb1 = [46, wiz_deathb2]
{
	self.velocity_x = -200 + 400 * random();
	self.velocity_y = -200 + 400 * random();
	self.velocity_z = 100 + 100 * random();
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	sound(self, CHAN_VOICE, "wizboss/wdeath.wav", SPAWN_FLOATING, ATTN_NORM);
};

void() wiz_deathb2 = [47, wiz_deathb3]
{
};

void() wiz_deathb3 = [48, wiz_deathb4]
{
	self.solid = SOLID_NOT;
};

void() wiz_deathb4 = [49, wiz_deathb5]
{
};

void() wiz_deathb5 = [50, wiz_deathb6]
{
};

void() wiz_deathb6 = [51, wiz_deathb7]
{
};

void() wiz_deathb7 = [52, wiz_deathb8]
{
};

void() wiz_deathb8 = [53, wiz_deathb8]
{
};

void() wiz_dieB = 
{
	if (self.health < -40)
	{
		sound(self, CHAN_VOICE, "player/udeath.wav", SPAWN_FLOATING, ATTN_NORM);
		ThrowHead("progs/h_wboss.mdl", self.health, self.skin);
		ThrowGib("progs/gib2.mdl", self.health);
		ThrowGib("progs/gib2.mdl", self.health);
		ThrowGib("progs/gib2.mdl", self.health);
		self.health = self.health * 2.5;
		ThrowGib("progs/gib2.mdl", self.health);
		ThrowGib("progs/gib2.mdl", self.health);
		ThrowGib("progs/gib2.mdl", self.health);
		return;
	}
	wiz_deathb1();
};

void(entity attacker, float damage) wiz_painb = 
{
	sound(self, CHAN_VOICE, "wizboss/wpain.wav", SPAWN_FLOATING, ATTN_NORM);
	if (random() * 70 > damage)
	{
		return;
	}
	wiz_painb1();
};

void() Wiz_MissileB = 
{
	wiz_fastb1();
};

void() monster_wizboss = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/wizboss.mdl");
	precache_model("progs/h_wboss.mdl");
	precache_model("progs/wbspike.mdl");
	precache_sound("wizboss/cwhit.wav");
	precache_sound("wizboss/wattack.wav");
	precache_sound("wizboss/wdeath.wav");
	precache_sound("wizboss/widle1.wav");
	precache_sound("wizboss/widle2.wav");
	precache_sound("wizboss/wpain.wav");
	precache_sound("wizboss/wsight.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/wizboss.mdl");
	setsize(self, VEC_HULL_MIN, '16 16 40');
	if (!(self.health))
	{
		self.health = 300;
	}
	self.th_stand = wiz_standb1;
	self.th_walk = wiz_walkb1;
	self.th_run = wiz_runb1;
	self.th_missile = Wiz_MissileB;
	self.th_pain = wiz_painb;
	self.th_die = wiz_dieB;
	flymonster_start();
};

