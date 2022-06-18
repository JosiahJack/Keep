void(entity missile, float mspeed, float accuracy) LaunchSpell = 
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
	missile.nextthink = time + 15;
	missile.think = SUB_Remove;
};

void() MageCheckAttack = 
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
			mag_run1();
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
			mag_run1();
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
			mag_run1();
		}
	}
	else
	{
		if (self.attack_state != AS_SLIDING)
		{
			self.attack_state = AS_SLIDING;
			mag_side1();
		}
	}
	return 0;
};

void() MageAttackFinished = 
{
	if (enemy_range >= RANGE_MID || !enemy_vis)
	{
		self.attack_state = AS_STRAIGHT;
		self.think = mag_run1;
	}
	else
	{
		self.attack_state = AS_SLIDING;
		self.think = mag_side1;
	}
};

void() shot_touch = 
{
	if (other == self.owner)
	{
		return;
	}
	if (other.takedamage == DAMAGE_AIM)
	{
		spawn_touchblood(TE_LIGHTNING3);
		T_Damage(other, self, self.owner, 15);
	}
	particle(self.origin, self.velocity * -0.5, 225, 20);
	remove(self);
};

void() Mag_StartFast = 
{
	local entity missile;
	local vector dst;
	sound(self, CHAN_WEAPON, "mage1/magefire.wav", SPAWN_CRUCIFIED, ATTN_NORM);
	self.v_angle = self.angles;
	makevectors(self.angles);
	missile = spawn();
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.owner = self;
	missile.enemy = self.enemy;
	setorigin(missile, self.origin + '0 0 30' + v_forward * 18);
	self.effects = self.owner.effects | EF_MUZZLEFLASH;
	sound(self, CHAN_WEAPON, "mage1/magefire.wav", SPAWN_CRUCIFIED, ATTN_NORM);
	missile.classname = "projectile";
	missile.touch = shot_touch;
	setmodel(missile, "progs/v_spike.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	LaunchSpell(missile, 600, 0.1);
};

void() Mag_idlesound = 
{
	local float wr;
	wr = random() * IQ_ULTIMATE;
	if (self.waitmin < time)
	{
		self.waitmin = time + SPAWN_LYINGDOWN;
		if (wr > 4.5)
		{
			sound(self, CHAN_VOICE, "mage1/mageatta.wav", SPAWN_CRUCIFIED, ATTN_IDLE);
		}
		if (wr < 1.5)
		{
			sound(self, CHAN_VOICE, "mage1/magesite.wav", SPAWN_CRUCIFIED, ATTN_IDLE);
		}
	}
	return;
};

void() mag_stand1 = [0, mag_stand2]
{
	ai_stand();
};

void() mag_stand2 = [1, mag_stand3]
{
	ai_stand();
};

void() mag_stand3 = [2, mag_stand4]
{
	ai_stand();
};

void() mag_stand4 = [3, mag_stand5]
{
	ai_stand();
};

void() mag_stand5 = [4, mag_stand6]
{
	ai_stand();
};

void() mag_stand6 = [5, mag_stand7]
{
	ai_stand();
};

void() mag_stand7 = [6, mag_stand1]
{
	ai_stand();
};

void() mag_walk1 = [0, mag_walk2]
{
	ai_walk(SPAWN_CUT);
	Mag_idlesound();
};

void() mag_walk2 = [1, mag_walk3]
{
	ai_walk(SPAWN_CUT);
};

void() mag_walk3 = [2, mag_walk4]
{
	ai_walk(SPAWN_CUT);
};

void() mag_walk4 = [3, mag_walk5]
{
	ai_walk(SPAWN_CUT);
};

void() mag_walk5 = [4, mag_walk6]
{
	ai_walk(SPAWN_CUT);
};

void() mag_walk6 = [5, mag_walk7]
{
	ai_walk(SPAWN_CUT);
};

void() mag_walk7 = [6, mag_walk1]
{
	ai_walk(SPAWN_CUT);
};

void() mag_side1 = [0, mag_side2]
{
	ai_run(SPAWN_CUT);
	Mag_idlesound();
};

void() mag_side2 = [1, mag_side3]
{
	ai_run(SPAWN_CUT);
};

void() mag_side3 = [2, mag_side4]
{
	ai_run(SPAWN_CUT);
};

void() mag_side4 = [3, mag_side5]
{
	ai_run(SPAWN_CUT);
};

void() mag_side5 = [4, mag_side6]
{
	ai_run(SPAWN_CUT);
};

void() mag_side6 = [5, mag_side7]
{
	ai_run(SPAWN_CUT);
};

void() mag_side7 = [6, mag_side1]
{
	ai_run(SPAWN_CUT);
};

void() mag_run1 = [0, mag_run2]
{
	ai_run(SECRET_YES_SHOOT);
	Mag_idlesound();
};

void() mag_run2 = [1, mag_run3]
{
	ai_run(SECRET_YES_SHOOT);
};

void() mag_run3 = [2, mag_run4]
{
	ai_run(SECRET_YES_SHOOT);
};

void() mag_run4 = [3, mag_run5]
{
	ai_run(SECRET_YES_SHOOT);
};

void() mag_run5 = [4, mag_run6]
{
	ai_run(SECRET_YES_SHOOT);
};

void() mag_run6 = [5, mag_run7]
{
	ai_run(SECRET_YES_SHOOT);
};

void() mag_run7 = [6, mag_run1]
{
	ai_run(SECRET_YES_SHOOT);
};

void() mag_fast1 = [7, mag_fast2]
{
	ai_face();
};

void() mag_fast2 = [8, mag_fast3]
{
	ai_face();
};

void() mag_fast3 = [9, mag_fast4]
{
	ai_face();
};

void() mag_fast4 = [10, mag_fast5]
{
	ai_face();
};

void() mag_fast5 = [11, mag_fast6]
{
	ai_face();
};

void() mag_fast6 = [12, mag_fast7]
{
	ai_face();
};

void() mag_fast7 = [13, mag_fast8]
{
	ai_face();
};

void() mag_fast8 = [14, mag_fast9]
{
	ai_face();
};

void() mag_fast9 = [15, mag_fast10]
{
	ai_face();
};

void() mag_fast10 = [16, mag_fast11]
{
	ai_face();
};

void() mag_fast11 = [17, mag_fast12]
{
	ai_face();
};

void() mag_fast12 = [18, mag_fast13]
{
	ai_face();
	Mag_StartFast();
};

void() mag_fast13 = [19, mag_fast14]
{
	ai_face();
};

void() mag_fast14 = [20, mag_fast15]
{
	ai_face();
};

void() mag_fast15 = [21, mag_run1]
{
	ai_face();
};

void() mag_pain1 = [28, mag_pain2]
{
};

void() mag_pain2 = [29, mag_pain3]
{
};

void() mag_pain3 = [30, mag_pain4]
{
};

void() mag_pain4 = [31, mag_pain5]
{
};

void() mag_pain5 = [32, mag_pain6]
{
};

void() mag_pain6 = [33, mag_pain7]
{
};

void() mag_pain7 = [34, mag_run1]
{
};

void() mag_death1 = [35, mag_death2]
{
	self.velocity_x = -200 + 400 * random();
	self.velocity_y = -200 + 400 * random();
	self.velocity_z = 100 + 100 * random();
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	sound(self, CHAN_VOICE, "mage1/magedth.wav", SPAWN_CRUCIFIED, ATTN_NORM);
};

void() mag_death2 = [36, mag_death3]
{
};

void() mag_death3 = [37, mag_death4]
{
	self.solid = SOLID_NOT;
};

void() mag_death4 = [38, mag_death5]
{
};

void() mag_death5 = [39, mag_death6]
{
};

void() mag_death6 = [40, mag_death7]
{
};

void() mag_death7 = [41, mag_death8]
{
};

void() mag_death8 = [42, mag_death9]
{
};

void() mag_death9 = [43, mag_death10]
{
};

void() mag_death10 = [44, mag_death11]
{
};

void() mag_death11 = [45, mag_death12]
{
};

void() mag_death12 = [46, mag_death13]
{
};

void() mag_death13 = [47, mag_death14]
{
};

void() mag_death14 = [48, mag_death15]
{
};

void() mag_death15 = [49, mag_death16]
{
};

void() mag_death16 = [50, mag_death17]
{
};

void() mag_death17 = [51, mag_death17]
{
};

void(vector org, vector vel, float damage) SpawnRain = 
{
	particle(org, vel * 0.1, IT_MJOLNIR, damage * SPAWN_LYINGDOWN);
	particle(org, vel * 0.3, 144, damage * SPAWN_LYINGDOWN);
	particle(org, vel * 0.4, 134, damage * SPAWN_LYINGDOWN);
	particle(org, vel * 0.6, MIN_CHARMER_DISTANCE, damage * SPAWN_LYINGDOWN);
};

void() mag_die = 
{
	if (self.health < -40)
	{
		sound(self, CHAN_VOICE, "mage1/magedth.wav", SPAWN_CRUCIFIED, ATTN_NORM);
		WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte(MSG_BROADCAST, TE_TAREXPLOSION);
		WriteCoord(MSG_BROADCAST, self.origin_x);
		WriteCoord(MSG_BROADCAST, self.origin_y);
		WriteCoord(MSG_BROADCAST, self.origin_z);
		SpawnRain(self.origin, VEC_ORIGIN, 50);
		return;
	}
	mag_death1();
};

void(entity attacker, float damage) Mag_Pain = 
{
	sound(self, CHAN_VOICE, "mage1/magepain.wav", SPAWN_CRUCIFIED, ATTN_NORM);
	if (random() * 70 > damage)
	{
		return;
	}
	mag_pain1();
};

void() Mag_Missile = 
{
	mag_fast1();
};

void() monster_mage1 = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/mage1.mdl");
	precache_model("progs/v_spike.mdl");
	precache_sound("wizard/hit.wav");
	precache_sound("mage1/mageatta.wav");
	precache_sound("mage1/magedth.wav");
	precache_sound("mage1/magesite.wav");
	precache_sound("mage1/magepain.wav");
	precache_sound("mage1/magefire.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/mage1.mdl");
	setsize(self, VEC_HULL_MIN, '16 16 40');
	self.health = 90;
	self.th_stand = mag_stand1;
	self.th_walk = mag_walk1;
	self.th_run = mag_run1;
	self.th_missile = Mag_Missile;
	self.th_pain = Mag_Pain;
	self.th_die = mag_die;
	flymonster_start();
};

