void(entity missile, float mspeed, float accuracy) LaunchMissile = 
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

float() WizardCheckAttack = 
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
			wiz_run1();
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
			wiz_run1();
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
			chance = 0.6;
		}
		else
		{
			if (enemy_range == RANGE_MID)
			{
				chance = 0.2;
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
			wiz_run1();
		}
	}
	else
	{
		if (self.attack_state != AS_SLIDING)
		{
			self.attack_state = AS_SLIDING;
			wiz_side1();
		}
	}
	return 0;
};

void() WizardAttackFinished = 
{
	if (enemy_range >= RANGE_MID || !enemy_vis)
	{
		self.attack_state = AS_STRAIGHT;
		self.think = wiz_run1;
	}
	else
	{
		self.attack_state = AS_SLIDING;
		self.think = wiz_side1;
	}
};

void() Wiz_FastFire = 
{
	local vector vec;
	local vector dst;
	if (self.owner.health > MSG_BROADCAST)
	{
		self.owner.effects = self.owner.effects | EF_MUZZLEFLASH;
		makevectors(self.enemy.angles);
		dst = self.enemy.origin - 13 * self.movedir;
		vec = normalize(dst - self.origin);
		sound(self, CHAN_WEAPON, "wizard/wattack.wav", SPAWN_FLOATING, ATTN_NORM);
		launch_spike(self.origin, vec);
		newmis.velocity = vec * 600;
		newmis.owner = self.owner;
		newmis.classname = "wizspike";
		setmodel(newmis, "progs/w_spike.mdl");
		setsize(newmis, VEC_ORIGIN, VEC_ORIGIN);
	}
	remove(self);
};

void() Wiz_StartFast = 
{
	local entity missile;
	sound(self, CHAN_WEAPON, "wizard/wattack.wav", SPAWN_FLOATING, ATTN_NORM);
	self.v_angle = self.angles;
	makevectors(self.angles);
	missile = spawn();
	missile.owner = self;
	missile.nextthink = time + 0.6;
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, self.origin + '0 0 30' + v_forward * 14 + v_right * 14);
	missile.enemy = self.enemy;
	missile.nextthink = time + 0.8;
	missile.think = Wiz_FastFire;
	missile.movedir = v_right;
	missile = spawn();
	missile.owner = self;
	missile.nextthink = time + SPAWN_FLOATING;
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, self.origin + '0 0 30' + v_forward * 14 + v_right * -14);
	missile.enemy = self.enemy;
	missile.nextthink = time + 0.3;
	missile.think = Wiz_FastFire;
	missile.movedir = VEC_ORIGIN - v_right;
};

void() Wiz_idlesound = 
{
	local float wr;
	wr = random() * IQ_ULTIMATE;
	if (self.waitmin < time)
	{
		self.waitmin = time + SPAWN_STATUE;
		if (wr > 4.5)
		{
			sound(self, CHAN_VOICE, "wizard/widle1.wav", SPAWN_FLOATING, ATTN_IDLE);
		}
		if (wr < 1.5)
		{
			sound(self, CHAN_VOICE, "wizard/widle2.wav", SPAWN_FLOATING, ATTN_IDLE);
		}
	}
	return;
};

float(entity beacon, float attack) PM_WizTeleport = 
{
	local vector spot;
	local vector vec;
	local float dist;
	spot_x = beacon.origin_x + (random() * IT_CELLS - IT_ROCKETS);
	spot_y = beacon.origin_y + (random() * IT_CELLS - IT_ROCKETS);
	spot_z = beacon.origin_z + (random() * IT_NAILS - IT_SHELLS);
	vec = normalize(spot - beacon.origin);
	traceline(beacon.origin, spot, 1, beacon);
	spot = trace_endpos - vec * 50;
	if (vlen(spot - self.origin) < IT_LIGHTNING)
	{
		return 0;
	}
	if (PM_InWall(self, spot))
	{
		return 0;
	}
	if (!PM_TraceCheck(self, spot))
	{
		return 0;
	}
	if (attack)
	{
		traceline(spot, self.enemy.origin, 0, self);
		if (trace_fraction < SPAWN_FLOATING)
		{
			if (trace_ent != self.enemy)
			{
				return 0;
			}
		}
	}
	setorigin(self, spot);
	self.angles_y = vectoyaw(self.enemy.origin - spot);
	self.fixangle = 1;
	return 1;
};

void(entity beacon, float attack) PM_WizBlink = 
{
	local vector org;
	org = self.origin;
	if (PM_WizTeleport(beacon, attack))
	{
		spawn_tfog(org);
		spawn_tfog(self.origin);
	}
};

void() PM_WizTripleBlink = 
{
	local vector org;
	local float success;
	org = self.origin;
	success = 0;
	success = success + PM_WizTeleport(self, 0);
	success = success + PM_WizTeleport(self, 0);
	success = success + PM_WizTeleport(self, 0);
	if (success)
	{
		spawn_tfog(org);
		spawn_tfog(self.origin);
	}
};

void() wiz_stand1 = [0, wiz_stand2]
{
	ai_stand();
};

void() wiz_stand2 = [1, wiz_stand3]
{
	ai_stand();
};

void() wiz_stand3 = [2, wiz_stand4]
{
	ai_stand();
};

void() wiz_stand4 = [3, wiz_stand5]
{
	ai_stand();
};

void() wiz_stand5 = [4, wiz_stand6]
{
	ai_stand();
};

void() wiz_stand6 = [5, wiz_stand7]
{
	ai_stand();
};

void() wiz_stand7 = [6, wiz_stand8]
{
	ai_stand();
};

void() wiz_stand8 = [7, wiz_stand1]
{
	ai_stand();
};

void() wiz_walk1 = [0, wiz_walk2]
{
	ai_walk(SPAWN_CUT);
	Wiz_idlesound();
};

void() wiz_walk2 = [1, wiz_walk3]
{
	ai_walk(SPAWN_CUT);
};

void() wiz_walk3 = [2, wiz_walk4]
{
	ai_walk(SPAWN_CUT);
};

void() wiz_walk4 = [3, wiz_walk5]
{
	ai_walk(SPAWN_CUT);
};

void() wiz_walk5 = [4, wiz_walk6]
{
	ai_walk(SPAWN_CUT);
};

void() wiz_walk6 = [5, wiz_walk7]
{
	ai_walk(SPAWN_CUT);
};

void() wiz_walk7 = [6, wiz_walk8]
{
	ai_walk(SPAWN_CUT);
};

void() wiz_walk8 = [7, wiz_walk1]
{
	ai_walk(SPAWN_CUT);
};

void() wiz_side1 = [0, wiz_side2]
{
	ai_run(SPAWN_CUT);
	Wiz_idlesound();
};

void() wiz_side2 = [1, wiz_side3]
{
	ai_run(SPAWN_CUT);
};

void() wiz_side3 = [2, wiz_side4]
{
	ai_run(SPAWN_CUT);
};

void() wiz_side4 = [3, wiz_side5]
{
	ai_run(SPAWN_CUT);
};

void() wiz_side5 = [4, wiz_side6]
{
	ai_run(SPAWN_CUT);
};

void() wiz_side6 = [5, wiz_side7]
{
	ai_run(SPAWN_CUT);
};

void() wiz_side7 = [6, wiz_side8]
{
	ai_run(SPAWN_CUT);
};

void() wiz_side8 = [7, wiz_side1]
{
	ai_run(SPAWN_CUT);
};

void() wiz_run1 = [15, wiz_run2]
{
	ai_run(SECRET_YES_SHOOT);
	Wiz_idlesound();
	if (random() < skill * 0.05)
	{
		PM_WizBlink(self.enemy, 0);
	}
};

void() wiz_run2 = [16, wiz_run3]
{
	ai_run(SECRET_YES_SHOOT);
};

void() wiz_run3 = [17, wiz_run4]
{
	ai_run(SECRET_YES_SHOOT);
};

void() wiz_run4 = [18, wiz_run5]
{
	ai_run(SECRET_YES_SHOOT);
};

void() wiz_run5 = [19, wiz_run6]
{
	ai_run(SECRET_YES_SHOOT);
};

void() wiz_run6 = [20, wiz_run7]
{
	ai_run(SECRET_YES_SHOOT);
};

void() wiz_run7 = [21, wiz_run8]
{
	ai_run(SECRET_YES_SHOOT);
};

void() wiz_run8 = [22, wiz_run9]
{
	ai_run(SECRET_YES_SHOOT);
};

void() wiz_run9 = [23, wiz_run10]
{
	ai_run(SECRET_YES_SHOOT);
};

void() wiz_run10 = [24, wiz_run11]
{
	ai_run(SECRET_YES_SHOOT);
};

void() wiz_run11 = [25, wiz_run12]
{
	ai_run(SECRET_YES_SHOOT);
};

void() wiz_run12 = [26, wiz_run13]
{
	ai_run(SECRET_YES_SHOOT);
};

void() wiz_run13 = [27, wiz_run14]
{
	ai_run(SECRET_YES_SHOOT);
};

void() wiz_run14 = [28, wiz_run1]
{
	ai_run(SECRET_YES_SHOOT);
};

void() wiz_fast1 = [29, wiz_fast2]
{
	if (random() < skill * 0.1)
	{
		PM_WizBlink(self, 1);
	}
	ai_face();
	Wiz_StartFast();
};

void() wiz_fast2 = [30, wiz_fast3]
{
	ai_face();
};

void() wiz_fast3 = [31, wiz_fast4]
{
	ai_face();
};

void() wiz_fast4 = [32, wiz_fast5]
{
	ai_face();
};

void() wiz_fast5 = [33, wiz_fast6]
{
	ai_face();
};

void() wiz_fast6 = [34, wiz_fast7]
{
	ai_face();
};

void() wiz_fast7 = [33, wiz_fast8]
{
	ai_face();
};

void() wiz_fast8 = [32, wiz_fast9]
{
	ai_face();
};

void() wiz_fast9 = [31, wiz_fast10]
{
	ai_face();
};

void() wiz_fast10 = [30, wiz_run1]
{
	ai_face();
	SUB_AttackFinished(SPAWN_STATUE);
	WizardAttackFinished();
};

void() wiz_pain1 = [42, wiz_pain2]
{
};

void() wiz_pain2 = [43, wiz_pain3]
{
};

void() wiz_pain3 = [44, wiz_pain4]
{
};

void() wiz_pain4 = [45, wiz_run1]
{
};

void() wiz_death1 = [46, wiz_death2]
{
	self.velocity_x = -200 + 400 * random();
	self.velocity_y = -200 + 400 * random();
	self.velocity_z = 100 + 100 * random();
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	sound(self, CHAN_VOICE, "wizard/wdeath.wav", SPAWN_FLOATING, ATTN_NORM);
};

void() wiz_death2 = [47, wiz_death3]
{
};

void() wiz_death3 = [48, wiz_death4]
{
	self.solid = SOLID_NOT;
};

void() wiz_death4 = [49, wiz_death5]
{
};

void() wiz_death5 = [50, wiz_death6]
{
};

void() wiz_death6 = [51, wiz_death7]
{
};

void() wiz_death7 = [52, wiz_death8]
{
};

void() wiz_death8 = [53, wiz_death8]
{
};

void() wiz_die = 
{
	if (self.health < -40)
	{
		sound(self, CHAN_VOICE, "player/udeath.wav", SPAWN_FLOATING, ATTN_NORM);
		ThrowHead("progs/h_wizard.mdl", self.health, self.skin);
		ThrowGib("progs/scraggib.mdl", self.health);
		ThrowGib("progs/scraggib.mdl", self.health);
		ThrowGib("progs/scraggib.mdl", self.health);
		self.health = self.health * 2.5;
		ThrowGib("progs/scraggib.mdl", self.health);
		ThrowGib("progs/scraggib.mdl", self.health);
		ThrowGib("progs/scraggib.mdl", self.health);
		return;
	}
	wiz_death1();
};

void(entity attacker, float damage) Wiz_Pain = 
{
	sound(self, CHAN_VOICE, "wizard/wpain.wav", SPAWN_FLOATING, ATTN_NORM);
	if (random() < skill * 0.05)
	{
		PM_WizTripleBlink();
	}
	if (random() * 70 > damage)
	{
		return;
	}
	wiz_pain1();
};

void() Wiz_Missile = 
{
	if (self.enemy.classname == "monster_zombie")
	{
		spawn_tfog(self.enemy.origin);
		spawn_tfog(self.origin);
		setorigin(self.enemy, self.origin);
		self.enemy.takedamage = DAMAGE_AIM;
		spawn_tdeath(self.origin, self);
		return;
	}
	wiz_fast1();
};

void() monster_wizard = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/wizard.mdl");
	precache_model("progs/h_wizard.mdl");
	precache_model("progs/w_spike.mdl");
	precache_model("progs/scraggib.mdl");
	precache_sound("wizard/hit.wav");
	precache_sound("wizard/wattack.wav");
	precache_sound("wizard/wdeath.wav");
	precache_sound("wizard/widle1.wav");
	precache_sound("wizard/widle2.wav");
	precache_sound("wizard/wpain.wav");
	precache_sound("wizard/wsight.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/wizard.mdl");
	setsize(self, VEC_HULL_MIN, '16 16 40');
	if (!(self.health))
	{
		self.health = 80;
	}
	self.th_stand = wiz_stand1;
	self.th_walk = wiz_walk1;
	self.th_run = wiz_run1;
	self.th_missile = Wiz_Missile;
	self.th_pain = Wiz_Pain;
	self.th_die = wiz_die;
	flymonster_start();
};

