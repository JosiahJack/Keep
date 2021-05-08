void(float dist) gaunt_hadj = 
{
	local float hadj;
	local vector hadjvec;
	local float enemydistance;
	local vector mtemp;
	local vector org;
	local float ass;
	local vector org_flat;
	local vector oldorg_flat;
	local vector oldorg;
	local vector reqvel;
	local float d;
	self.velocity = VEC_ORIGIN;
	enemydistance = vlen(self.enemy.origin - self.origin);
	if (self.enemy.carrymode == LIGHTNING_RANDOM && enemydistance < 200)
	{
		dist = dist * CONTENT_EMPTY;
	}
	if (self.enemy != self.carry && self.carry != world)
	{
		gaunt_reset();
	}
	if (self.carry.health <= MSG_BROADCAST && self.carry != world)
	{
		gaunt_reset();
	}
	self.origin2 = self.origin;
	oldorg = self.origin;
	self.movetype = MOVETYPE_STEP;
	ai_run(dist);
	d = vlen(self.origin - oldorg);
	hadj = self.origin_z - self.origin2_z;
	if (visible(self.enemy))
	{
		hadj = hadj * self.vsightmultiplier;
	}
	else
	{
		hadj = hadj * self.vmultiplier;
	}
	hadjvec_z = hadj;
	setorigin(self, self.origin + hadjvec);
	self.velocity = VEC_ORIGIN;
	if (d <= dist + AS_BLINDFIRE)
	{
		self.movetype = MOVETYPE_FLY;
		reqvel = normalize(self.origin - oldorg) * dist * TE_WIZSPIKE;
		setorigin(self, oldorg);
		self.velocity = reqvel;
	}
};

float() GauntCheckAttack = 
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
			gaunt_run1();
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
			gaunt_run1();
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
			chance = 0.3;
		}
		else
		{
			if (enemy_range == RANGE_MID)
			{
				chance = 0.05;
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
	if (enemy_range > RANGE_NEAR)
	{
		if (self.attack_state != AS_STRAIGHT)
		{
			self.attack_state = AS_STRAIGHT;
			gaunt_run1();
		}
	}
	else
	{
		if (self.attack_state != AS_SLIDING)
		{
			self.attack_state = AS_SLIDING;
			gaunt_side1();
		}
	}
	return 0;
};

void() GauntAttackFinished = 
{
	if (enemy_range >= RANGE_MID || !enemy_vis)
	{
		self.attack_state = AS_STRAIGHT;
		self.think = gaunt_run1;
	}
	else
	{
		self.attack_state = AS_SLIDING;
		self.think = gaunt_side1;
	}
};

void() gaunt_strafe = 
{
	local float ofs;
	local float hadj;
	local vector hadjvec;
	local vector mtemp;
	local vector org;
	local float ass;
	local vector org_flat;
	local vector oldorg_flat;
	local vector oldorg;
	local vector reqvel;
	self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
	ChangeYaw();
	if (self.lefty == LIGHTNING_RANDOM)
	{
		ofs = 90;
	}
	else
	{
		ofs = -90;
	}
	self.origin2 = self.origin;
	oldorg = self.origin;
	walkmove(self.ideal_yaw - ofs, SECRET_NO_SHOOT * self.multiplier);
	hadj = self.origin_z - self.origin2_z;
	if (visible(self.enemy))
	{
		hadj = hadj * self.vsightmultiplier;
	}
	else
	{
		hadj = hadj * self.vmultiplier;
	}
	hadjvec_z = hadj;
	setorigin(self, self.origin + hadjvec);
	if (self.lip == MSG_BROADCAST)
	{
		self.movetype = MOVETYPE_FLY;
		reqvel = normalize(self.origin - oldorg) * SECRET_NO_SHOOT * TE_WIZSPIKE;
		setorigin(self, oldorg);
		self.velocity = reqvel;
	}
	if (self.lip == LIGHTNING_RANDOM)
	{
		self.lip = MSG_BROADCAST;
	}
};

void(vector p1, vector p2, entity from, float damage) GauntLightningDamage = 
{
	local entity e1;
	local entity e2;
	local vector f;
	f = p2 - p1;
	normalize(f);
	f_x = MSG_BROADCAST - f_y;
	f_y = f_x;
	f_z = MSG_BROADCAST;
	f = f * SECRET_YES_SHOOT;
	e2 = world;
	e1 = world;
	traceline(p1, p2, 0, self);
	if (trace_ent.classname != "player")
	{
		damage = 25;
	}
	if (trace_ent.takedamage)
	{
		particle(trace_endpos, '0 0 100', 225, damage * SECRET_1ST_DOWN);
		T_Damage(trace_ent, from, from, damage);
		if (self.classname == "player")
		{
			if (other.classname == "player")
			{
				trace_ent.velocity_z = trace_ent.velocity_z + 400;
			}
		}
	}
	e1 = trace_ent;
	traceline(p1 + f, p2 + f, 0, self);
	if (trace_ent != e1 && trace_ent.takedamage)
	{
		particle(trace_endpos, '0 0 100', 225, damage * SECRET_1ST_DOWN);
		T_Damage(trace_ent, from, from, damage);
	}
	e2 = trace_ent;
	traceline(p1 - f, p2 - f, 0, self);
	if (trace_ent != e1 && trace_ent != e2 && trace_ent.takedamage)
	{
		particle(trace_endpos, '0 0 100', 225, damage * SECRET_1ST_DOWN);
		T_Damage(trace_ent, from, from, damage);
	}
};

void(float offset) gaunt_lightning = 
{
	local vector offang;
	local vector org;
	local vector vec;
	local vector dir;
	local float damage;
	local float hadj;
	local vector hadjvec;
	local float ofs;
	local vector mtemp;
	local float ass;
	local vector org_flat;
	local vector oldorg_flat;
	local vector oldorg;
	local vector reqvel;
	self.effects = self.effects | EF_MUZZLEFLASH;
	self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
	ChangeYaw();
	if (self.lefty == LIGHTNING_RANDOM)
	{
		ofs = 90;
	}
	else
	{
		ofs = -90;
	}
	self.origin2 = self.origin;
	oldorg = self.origin;
	walkmove(self.ideal_yaw - ofs, SECRET_NO_SHOOT * self.multiplier);
	hadj = self.origin_z - self.origin2_z;
	if (visible(self.enemy))
	{
		hadj = hadj * self.vsightmultiplier;
	}
	else
	{
		hadj = hadj * self.vmultiplier;
	}
	hadjvec_z = hadj;
	setorigin(self, self.origin + hadjvec);
	if (self.lip == MSG_BROADCAST)
	{
		self.movetype = MOVETYPE_FLY;
		reqvel = normalize(self.origin - oldorg) * SECRET_NO_SHOOT * TE_WIZSPIKE;
		setorigin(self, oldorg);
		self.velocity = reqvel;
	}
	if (self.lip == LIGHTNING_RANDOM)
	{
		self.lip = MSG_BROADCAST;
	}
	if (self.enemy.classname == "player")
	{
		vec = self.enemy.origin - self.enemy.velocity * 0.085;
	}
	else
	{
		vec = self.enemy.origin - self.enemy.velocity * MSG_BROADCAST;
	}
	vec = normalize(vec - self.origin);
	if (vlen(self.enemy.origin - self.origin) > 1200)
	{
		vec = self.origin + vec * 1100;
	}
	else
	{
		vec = self.origin + vec * (vlen(self.enemy.origin - self.origin) + 20);
	}
	org = self.origin;
	traceline(org, vec, 1, self);
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_LIGHTNING2);
	WriteEntity(MSG_BROADCAST, self);
	WriteCoord(MSG_BROADCAST, org_x);
	WriteCoord(MSG_BROADCAST, org_y);
	WriteCoord(MSG_BROADCAST, org_z);
	WriteCoord(MSG_BROADCAST, trace_endpos_x);
	WriteCoord(MSG_BROADCAST, trace_endpos_y);
	WriteCoord(MSG_BROADCAST, trace_endpos_z);
	damage = (50 / (vlen(self.enemy.origin - trace_endpos) * 0.25) + LIGHTNING_RANDOM) * 0.75;
	if (self.enemy.carrymode == LIGHTNING_RANDOM)
	{
		damage = damage * 0.5;
	}
	GauntLightningDamage(self.origin, trace_endpos, self, damage);
	if (self.enemy.health <= MSG_BROADCAST && vlen(self.enemy.origin - self.origin) <= 600)
	{
		self.enemy.velocity = self.enemy.velocity + '0 0 10';
		dir = self.enemy.origin - (self.absmin + self.absmax) * 0.5;
		dir = normalize(dir);
		self.enemy.velocity = self.enemy.velocity + dir * 50;
	}
};

void() gaunt_idlesound = 
{
	local float rndsnd;
	if (random() < 0.3 && self.idlesound_time < time)
	{
		rndsnd = random();
		if (rndsnd < 0.33)
		{
			sound(self, CHAN_VOICE, "gaunt/idle1.wav", LIGHTNING_RANDOM, 0.85);
		}
		else
		{
			if (rndsnd < 0.66)
			{
				sound(self, CHAN_VOICE, "gaunt/idle2.wav", LIGHTNING_RANDOM, 0.85);
			}
			else
			{
				sound(self, CHAN_VOICE, "gaunt/idle3.wav", LIGHTNING_RANDOM, 0.85);
			}
		}
		self.idlesound_time = time + SECRET_1ST_DOWN + AS_BLINDFIRE * random();
	}
};

void() gaunt_perch1 = [0, gaunt_perch2]
{
	self.frame = MSG_BROADCAST;
	ai_stand();
	gaunt_idlesound();
};

void() gaunt_perch2 = [0, gaunt_perch3]
{
	ai_stand();
	self.frame = LIGHTNING_RANDOM;
};

void() gaunt_perch3 = [0, gaunt_perch4]
{
	ai_stand();
	self.frame = LIGHTNING_BOOM;
};

void() gaunt_perch4 = [0, gaunt_perch5]
{
	ai_stand();
	self.frame = AS_MELEE;
};

void() gaunt_perch5 = [0, gaunt_perch6]
{
	ai_stand();
	self.frame = SECRET_1ST_DOWN;
};

void() gaunt_perch6 = [0, gaunt_perch7]
{
	ai_stand();
	self.frame = AS_BLINDFIRE;
};

void() gaunt_perch7 = [0, gaunt_perch8]
{
	ai_stand();
	self.frame = AS_LOITER;
};

void() gaunt_perch8 = [0, gaunt_perch9]
{
	ai_stand();
	self.frame = TE_WIZSPIKE;
};

void() gaunt_perch9 = [0, gaunt_perch10]
{
	ai_stand();
	self.frame = SECRET_NO_SHOOT;
};

void() gaunt_perch10 = [0, gaunt_perch11]
{
	ai_stand();
	self.frame = TE_LIGHTNING3;
};

void() gaunt_perch11 = [0, gaunt_perch12]
{
	ai_stand();
	self.frame = TE_LAVASPLASH;
};

void() gaunt_perch12 = [0, gaunt_perch13]
{
	ai_stand();
	self.frame = TE_TELEPORT;
};

void() gaunt_perch13 = [0, gaunt_perch14]
{
	ai_stand();
	self.frame = TE_EXPLOSION2;
};

void() gaunt_perch14 = [0, gaunt_perch15]
{
	ai_stand();
	self.frame = TE_BEAM;
};

void() gaunt_perch15 = [0, gaunt_perch16]
{
	ai_stand();
	self.frame = 14;
};

void() gaunt_perch16 = [0, gaunt_perch1]
{
	ai_stand();
	self.frame = 15;
};

void() gaunt_rise1 = [16, gaunt_rise2]
{
	self.pain_finished = time + LIGHTNING_RANDOM;
	self.th_pain = gaunt_Pain;
};

void() gaunt_rise2 = [17, gaunt_rise3]
{
	self.movetype = MOVETYPE_FLY;
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	self.velocity_z = 50;
	ai_face();
};

void() gaunt_rise3 = [18, gaunt_rise4]
{
	ai_face();
	self.velocity_z = 130;
};

void() gaunt_rise4 = [19, gaunt_rise5]
{
	ai_face();
	self.velocity_z = 180;
};

void() gaunt_rise5 = [20, gaunt_rise6]
{
	ai_face();
	self.velocity_z = 150;
};

void() gaunt_rise6 = [21, gaunt_rise7]
{
	ai_face();
	self.velocity_z = 100;
};

void() gaunt_rise7 = [22, gaunt_rise8]
{
	ai_face();
	self.velocity_z = 40;
};

void() gaunt_rise8 = [23, gaunt_run1]
{
	self.idlesound_time = time + LIGHTNING_BOOM;
	ai_face();
	self.velocity = VEC_ORIGIN;
	self.movetype = MOVETYPE_STEP;
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	self.th_run = gaunt_run1;
	self.th_stand = gaunt_stand1;
};

void() gaunt_stand1 = [24, gaunt_stand2]
{
	ai_stand();
	gaunt_idlesound();
};

void() gaunt_stand2 = [25, gaunt_stand3]
{
	ai_stand();
};

void() gaunt_stand3 = [26, gaunt_stand4]
{
	ai_stand();
};

void() gaunt_stand4 = [27, gaunt_stand5]
{
	ai_stand();
};

void() gaunt_stand5 = [28, gaunt_stand6]
{
	ai_stand();
};

void() gaunt_stand6 = [29, gaunt_stand7]
{
	ai_stand();
};

void() gaunt_stand7 = [30, gaunt_stand8]
{
	ai_stand();
};

void() gaunt_stand8 = [31, gaunt_stand9]
{
	ai_stand();
};

void() gaunt_stand9 = [32, gaunt_stand10]
{
	ai_stand();
};

void() gaunt_stand10 = [33, gaunt_stand11]
{
	ai_stand();
};

void() gaunt_stand11 = [34, gaunt_stand12]
{
	ai_stand();
};

void() gaunt_stand12 = [35, gaunt_stand13]
{
	ai_stand();
};

void() gaunt_stand13 = [36, gaunt_stand14]
{
	ai_stand();
};

void() gaunt_stand14 = [37, gaunt_stand15]
{
	ai_stand();
};

void() gaunt_stand15 = [38, gaunt_stand16]
{
	ai_stand();
};

void() gaunt_stand16 = [39, gaunt_stand17]
{
	ai_stand();
};

void() gaunt_stand17 = [40, gaunt_stand18]
{
	ai_stand();
};

void() gaunt_stand18 = [41, gaunt_stand19]
{
	ai_stand();
};

void() gaunt_stand19 = [42, gaunt_stand20]
{
	ai_stand();
};

void() gaunt_stand20 = [43, gaunt_stand1]
{
	ai_stand();
};

void() gaunt_walk1 = [24, gaunt_walk2]
{
	ai_walkfly(SECRET_NO_SHOOT);
	self.velocity = VEC_ORIGIN;
};

void() gaunt_walk2 = [25, gaunt_walk3]
{
	ai_walkfly(SECRET_NO_SHOOT);
};

void() gaunt_walk3 = [26, gaunt_walk4]
{
	ai_walkfly(SECRET_NO_SHOOT);
};

void() gaunt_walk4 = [27, gaunt_walk5]
{
	ai_walkfly(SECRET_NO_SHOOT);
};

void() gaunt_walk5 = [28, gaunt_walk6]
{
	ai_walkfly(SECRET_NO_SHOOT);
};

void() gaunt_walk6 = [29, gaunt_walk7]
{
	ai_walkfly(SECRET_NO_SHOOT);
};

void() gaunt_walk7 = [30, gaunt_walk8]
{
	ai_walkfly(SECRET_NO_SHOOT);
};

void() gaunt_walk8 = [31, gaunt_walk1]
{
	ai_walkfly(SECRET_NO_SHOOT);
};

void() gaunt_side1 = [24, gaunt_side2]
{
	gaunt_hadj(LIGHTNING_BOOM * self.multiplier);
	gaunt_idlesound();
};

void() gaunt_side2 = [25, gaunt_side3]
{
	gaunt_hadj(LIGHTNING_BOOM * self.multiplier);
};

void() gaunt_side3 = [26, gaunt_side4]
{
	gaunt_hadj(AS_MELEE * self.multiplier);
};

void() gaunt_side4 = [27, gaunt_side5]
{
	gaunt_hadj(AS_MELEE * self.multiplier);
};

void() gaunt_side5 = [28, gaunt_side6]
{
	gaunt_hadj(SECRET_1ST_DOWN * self.multiplier);
};

void() gaunt_side6 = [29, gaunt_side7]
{
	gaunt_hadj(AS_BLINDFIRE * self.multiplier);
};

void() gaunt_side7 = [30, gaunt_side8]
{
	gaunt_hadj(AS_LOITER * self.multiplier);
};

void() gaunt_side8 = [31, gaunt_side9]
{
	gaunt_hadj(SECRET_NO_SHOOT * self.multiplier);
};

void() gaunt_side9 = [32, gaunt_side10]
{
	gaunt_hadj(TE_LAVASPLASH * self.multiplier);
};

void() gaunt_side10 = [33, gaunt_side11]
{
	gaunt_hadj(TE_EXPLOSION2 * self.multiplier);
};

void() gaunt_side11 = [34, gaunt_side12]
{
	gaunt_hadj(LIGHTNING_BOOM * self.multiplier);
};

void() gaunt_side12 = [35, gaunt_side13]
{
	gaunt_hadj(LIGHTNING_BOOM * self.multiplier);
};

void() gaunt_side13 = [36, gaunt_side14]
{
	gaunt_hadj(AS_MELEE * self.multiplier);
};

void() gaunt_side14 = [37, gaunt_side15]
{
	gaunt_hadj(AS_MELEE * self.multiplier);
};

void() gaunt_side15 = [38, gaunt_side16]
{
	gaunt_hadj(SECRET_1ST_DOWN * self.multiplier);
};

void() gaunt_side16 = [39, gaunt_side17]
{
	gaunt_hadj(AS_BLINDFIRE * self.multiplier);
};

void() gaunt_side17 = [40, gaunt_side18]
{
	gaunt_hadj(AS_LOITER * self.multiplier);
};

void() gaunt_side18 = [41, gaunt_side19]
{
	gaunt_hadj(SECRET_NO_SHOOT * self.multiplier);
};

void() gaunt_side19 = [42, gaunt_side20]
{
	gaunt_hadj(TE_LAVASPLASH * self.multiplier);
};

void() gaunt_side20 = [43, gaunt_side1]
{
	gaunt_hadj(TE_EXPLOSION2 * self.multiplier);
};

void() gaunt_run1 = [24, gaunt_run2]
{
	gaunt_hadj(LIGHTNING_BOOM * self.multiplier);
	gaunt_idlesound();
};

void() gaunt_run2 = [25, gaunt_run3]
{
	gaunt_hadj(LIGHTNING_BOOM * self.multiplier);
};

void() gaunt_run3 = [26, gaunt_run4]
{
	gaunt_hadj(AS_MELEE * self.multiplier);
};

void() gaunt_run4 = [27, gaunt_run5]
{
	gaunt_hadj(AS_MELEE * self.multiplier);
};

void() gaunt_run5 = [28, gaunt_run6]
{
	gaunt_hadj(SECRET_1ST_DOWN * self.multiplier);
};

void() gaunt_run6 = [29, gaunt_run7]
{
	gaunt_hadj(AS_BLINDFIRE * self.multiplier);
};

void() gaunt_run7 = [30, gaunt_run8]
{
	gaunt_hadj(AS_LOITER * self.multiplier);
};

void() gaunt_run8 = [31, gaunt_run9]
{
	gaunt_hadj(SECRET_NO_SHOOT * self.multiplier);
};

void() gaunt_run9 = [32, gaunt_run10]
{
	gaunt_hadj(TE_LAVASPLASH * self.multiplier);
};

void() gaunt_run10 = [33, gaunt_run11]
{
	gaunt_hadj(TE_EXPLOSION2 * self.multiplier);
};

void() gaunt_run11 = [34, gaunt_run12]
{
	gaunt_hadj(LIGHTNING_BOOM * self.multiplier);
};

void() gaunt_run12 = [35, gaunt_run13]
{
	gaunt_hadj(LIGHTNING_BOOM * self.multiplier);
};

void() gaunt_run13 = [36, gaunt_run14]
{
	gaunt_hadj(AS_MELEE * self.multiplier);
};

void() gaunt_run14 = [37, gaunt_run15]
{
	gaunt_hadj(AS_MELEE * self.multiplier);
};

void() gaunt_run15 = [38, gaunt_run16]
{
	gaunt_hadj(SECRET_1ST_DOWN * self.multiplier);
};

void() gaunt_run16 = [39, gaunt_run17]
{
	gaunt_hadj(AS_BLINDFIRE * self.multiplier);
};

void() gaunt_run17 = [40, gaunt_run18]
{
	gaunt_hadj(AS_LOITER * self.multiplier);
};

void() gaunt_run18 = [41, gaunt_run19]
{
	gaunt_hadj(SECRET_NO_SHOOT * self.multiplier);
};

void() gaunt_run19 = [42, gaunt_run20]
{
	gaunt_hadj(TE_LAVASPLASH * self.multiplier);
};

void() gaunt_run20 = [43, gaunt_run1]
{
	gaunt_hadj(TE_EXPLOSION2 * self.multiplier);
};

void(float fxframe) gaunt_lightning_fx = 
{
	self.effects = self.effects | EF_MUZZLEFLASH;
	self.owner.frame = fxframe;
	setorigin(self.owner, self.origin - VEC_ORIGIN);
	self.owner.angles = self.angles;
};

void() gaunt_fast1 = [44, gaunt_fast2]
{
	local entity o;
	if (random() < 0.5)
	{
		self.lefty = LIGHTNING_RANDOM;
	}
	else
	{
		self.lefty = MSG_BROADCAST;
	}
	gaunt_strafe();
	self.effects = self.effects | EF_MUZZLEFLASH;
	self.owner = spawn();
	o = self.owner;
	setmodel(o, "progs/g_fx.mdl");
	setorigin(o, self.origin - VEC_ORIGIN);
	o.angles = self.angles;
	o.nextthink = time + LIGHTNING_RANDOM;
	o.think = SUB_Remove;
};

void() gaunt_fast2 = [45, gaunt_fast3]
{
	gaunt_strafe();
	gaunt_lightning_fx(LIGHTNING_RANDOM);
};

void() gaunt_fast3 = [46, gaunt_fast4]
{
	gaunt_strafe();
	gaunt_lightning_fx(LIGHTNING_BOOM);
};

void() gaunt_fast4 = [47, gaunt_fast5]
{
	gaunt_strafe();
	gaunt_lightning_fx(AS_MELEE);
};

void() gaunt_fast5 = [48, gaunt_fast6]
{
	gaunt_strafe();
	gaunt_lightning_fx(SECRET_1ST_DOWN);
};

void() gaunt_fast6 = [49, gaunt_fast7]
{
	gaunt_strafe();
	gaunt_lightning_fx(AS_BLINDFIRE);
};

void() gaunt_fast7 = [50, gaunt_fast8]
{
	gaunt_strafe();
	gaunt_lightning_fx(AS_LOITER);
};

void() gaunt_fast8 = [51, gaunt_fast9]
{
	gaunt_strafe();
	gaunt_lightning_fx(TE_WIZSPIKE);
};

void() gaunt_fast9 = [52, gaunt_fast10]
{
	gaunt_strafe();
	gaunt_lightning_fx(SECRET_NO_SHOOT);
};

void() gaunt_fast10 = [53, gaunt_fast11]
{
	gaunt_strafe();
	gaunt_lightning_fx(TE_LIGHTNING3);
};

void() gaunt_fast11 = [54, gaunt_fast12]
{
	sound(self, CHAN_WEAPON, "weapons/lstart.wav", LIGHTNING_RANDOM, ATTN_NORM);
	gaunt_lightning(LIGHTNING_RANDOM);
	remove(self.owner);
};

void() gaunt_fast12 = [55, gaunt_fast13]
{
	gaunt_lightning(MSG_BROADCAST);
};

void() gaunt_fast13 = [56, gaunt_fast14]
{
	gaunt_lightning(LIGHTNING_RANDOM);
};

void() gaunt_fast14 = [57, gaunt_fast15]
{
	gaunt_lightning(MSG_BROADCAST);
};

void() gaunt_fast15 = [58, gaunt_fast16]
{
	gaunt_lightning(LIGHTNING_RANDOM);
};

void() gaunt_fast16 = [59, gaunt_fast17]
{
};

void() gaunt_fast17 = [60, gaunt_fast18]
{
};

void() gaunt_fast18 = [61, gaunt_fast19]
{
};

void() gaunt_fast19 = [62, gaunt_fast20]
{
};

void() gaunt_fast20 = [63, gaunt_run1]
{
	ai_face();
	self.attack_state = AS_STRAIGHT;
};

void() gaunt_reset = 
{
	local entity tempself;
	if (self.health > MSG_BROADCAST)
	{
		sound(self, CHAN_VOICE, "gaunt/sight.wav", LIGHTNING_RANDOM, ATTN_NORM);
	}
	setsize(self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	self.movetype = MOVETYPE_FLY;
	self.carry.velocity = self.velocity;
	self.carry.velocity = normalize(self.carry.velocity);
	self.carry.velocity = self.carry.velocity * 50;
	self.velocity = VEC_ORIGIN;
	self.ltime = time + TE_LAVASPLASH;
	self.carry.client_gaunt_swoop_time = time + 2.5;
	self.think = gaunt_stand1;
	self.carrymode = MSG_BROADCAST;
	self.carry.carrymode = MSG_BROADCAST;
	self.carry.items = self.carry.items | self.carry.items_stasis;
	self.carry.weapon = self.carry.rememberweapon;
	tempself = self;
	self = self.carry;
	if (self.health > MSG_BROADCAST)
	{
		W_SetCurrentAmmo();
	}
	self = tempself;
	if (self.carry.classname == "player")
	{
		self.carry.movetype = MOVETYPE_WALK;
	}
	else
	{
		self.carry.movetype = MOVETYPE_STEP;
	}
	self.touch = SUB_Null;
	if (self.enemy.health <= MSG_BROADCAST || self.enemy != self.carry)
	{
		self.enemy = world;
		return;
	}
	self.carry = world;
	self.goalentity = self.carry;
	HuntTarget();
};

void() carry_enemy = 
{
	local vector org;
	local entity head;
	local vector m;
	self.carry.flags = self.carry.flags - (self.carry.flags & FL_ONGROUND);
	self.carry.movetype = MOVETYPE_FLY;
	self.carry.teleport_time = time + 0.2;
	setorigin(self.carry, self.origin - '0 0 68');
	self.carry.velocity = self.velocity;
	if (self.enemy != self.carry)
	{
		gaunt_reset();
	}
	if (self.carry.health <= MSG_BROADCAST)
	{
		gaunt_reset();
	}
};

void() gaunt_moveup = 
{
	local vector mtemp;
	local vector org;
	local float ass;
	local vector org_flat;
	local vector oldorg_flat;
	org = self.origin;
	traceline(org, org + '0 0 64', 1, self);
	if (vlen(trace_endpos - org) < 56)
	{
		return;
	}
	traceline(org, org + '-32 -32 64', 1, self);
	if (fabs(org_z - trace_endpos_z) < 56)
	{
		return;
	}
	traceline(org, org + '-32 32 64', 1, self);
	if (fabs(org_z - trace_endpos_z) < 56)
	{
		return;
	}
	traceline(org, org + '32 -32 64', 1, self);
	if (fabs(org_z - trace_endpos_z) < 56)
	{
		return;
	}
	traceline(org, org + VEC_HULL2_MAX, 1, self);
	if (fabs(org_z - trace_endpos_z) < 56)
	{
		return;
	}
	setorigin(self, self.origin + '0 0 18');
};

void(float dist) ai_pathfollow = 
{
	local vector mtemp;
	local vector org;
	local float ass;
	local vector org_flat;
	local vector oldorg_flat;
	local vector oldorg;
	local vector reqvel;
	local float d;
	oldorg = self.origin;
	self.movetype = MOVETYPE_STEP;
	if (vlen(self.goalentity.origin - self.origin) < TRIGGER_AWAKE)
	{
		self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
		walkmove(self.ideal_yaw, dist);
	}
	else
	{
		movetogoal(dist);
	}
	d = vlen(self.origin - oldorg);
	if (self.goalentity.origin_z > self.origin_z)
	{
		gaunt_moveup();
	}
	if (d <= DOOR_TOGGLE)
	{
		self.movetype = MOVETYPE_NOCLIP;
		reqvel = normalize(self.origin - oldorg) * dist * TE_WIZSPIKE;
		setorigin(self, oldorg);
		self.velocity = reqvel;
	}
};

void() gaunt_carry1 = [24, gaunt_carry2]
{
	local entity tempself;
	local float dmgnow;
	ai_pathfollow(AS_LOITER * self.multiplier);
	carry_enemy();
	if (self.carry.health >= LIGHTNING_RANDOM)
	{
		dmgnow = random() * LIGHTNING_BOOM + LIGHTNING_BOOM;
		SpawnBlood(self.carry.origin + '0 0 24', VEC_ORIGIN, LIGHTNING_BOOM);
		if (self.enemy.health <= dmgnow && !(self.enemy.flags & FL_GODMODE) && self.enemy.invincible_finished < time)
		{
			self.enemy.deathtype = "swoop";
			gaunt_reset();
		}
		T_Damage(self.enemy, self, self, dmgnow);
	}
};

void() gaunt_carry2 = [25, gaunt_carry3]
{
	ai_pathfollow(SECRET_NO_SHOOT * self.multiplier);
	carry_enemy();
	gaunt_idlesound();
};

void() gaunt_carry3 = [26, gaunt_carry4]
{
	ai_pathfollow(AS_BLINDFIRE * self.multiplier);
	carry_enemy();
};

void() gaunt_carry4 = [27, gaunt_carry5]
{
	ai_pathfollow(AS_MELEE * self.multiplier);
	carry_enemy();
};

void() gaunt_carry5 = [28, gaunt_carry6]
{
	ai_pathfollow(SECRET_1ST_DOWN * self.multiplier);
	carry_enemy();
	self.carry.punchangle_z = AS_MELEE - random() * AS_LOITER;
};

void() gaunt_carry6 = [29, gaunt_carry7]
{
	ai_pathfollow(AS_BLINDFIRE * self.multiplier);
	carry_enemy();
};

void() gaunt_carry7 = [30, gaunt_carry8]
{
	ai_pathfollow(SECRET_NO_SHOOT * self.multiplier);
	carry_enemy();
};

void() gaunt_carry8 = [31, gaunt_carry9]
{
	ai_pathfollow(TE_LAVASPLASH * self.multiplier);
	carry_enemy();
};

void() gaunt_carry9 = [32, gaunt_carry10]
{
	ai_pathfollow(TE_LAVASPLASH * self.multiplier);
	carry_enemy();
};

void() gaunt_carry10 = [33, gaunt_carry11]
{
	ai_pathfollow(TE_LIGHTNING3 * self.multiplier);
	carry_enemy();
	self.carry.punchangle_z = AS_MELEE - random() * AS_LOITER;
};

void() gaunt_carry11 = [34, gaunt_carry12]
{
	ai_pathfollow(SECRET_NO_SHOOT * self.multiplier);
	carry_enemy();
};

void() gaunt_carry12 = [35, gaunt_carry13]
{
	ai_pathfollow(AS_BLINDFIRE * self.multiplier);
	carry_enemy();
};

void() gaunt_carry13 = [36, gaunt_carry14]
{
	ai_pathfollow(AS_MELEE * self.multiplier);
	carry_enemy();
};

void() gaunt_carry14 = [37, gaunt_carry15]
{
	ai_pathfollow(SECRET_1ST_DOWN * self.multiplier);
	carry_enemy();
};

void() gaunt_carry15 = [38, gaunt_carry16]
{
	ai_pathfollow(AS_BLINDFIRE * self.multiplier);
	carry_enemy();
	self.carry.punchangle_z = AS_MELEE - random() * AS_LOITER;
};

void() gaunt_carry16 = [39, gaunt_carry17]
{
	ai_pathfollow(AS_LOITER * self.multiplier);
	carry_enemy();
};

void() gaunt_carry17 = [40, gaunt_carry18]
{
	ai_pathfollow(AS_LOITER * self.multiplier);
	carry_enemy();
};

void() gaunt_carry18 = [41, gaunt_carry19]
{
	ai_pathfollow(TE_LAVASPLASH * self.multiplier);
	carry_enemy();
};

void() gaunt_carry19 = [42, gaunt_carry20]
{
	ai_pathfollow(TE_LAVASPLASH * self.multiplier);
	carry_enemy();
};

void() gaunt_carry20 = [43, gaunt_carry1]
{
	ai_pathfollow(TE_LIGHTNING3 * self.multiplier);
	carry_enemy();
};

void() findclosestpath = 
{
	local entity head;
	local float m;
	local float n;
	self.goalentity = self.movetarget = find(world, targetname, self.pathtarget);
	head = findradius(self.origin, 10000);
	while (head)
	{
		if (head.classname == "gaunt_corner" && head.targetname == self.pathtarget)
		{
			m = vlen(self.origin - head.origin);
			n = vlen(self.origin - self.goalentity.origin);
			if (m < n)
			{
				self.movetarget = head;
				self.goalentity = head;
			}
		}
		head = head.chain;
	}
};

void() Gaunt_Touch = 
{
	local entity tempself;
	if (other.health <= MSG_BROADCAST)
	{
		return;
	}
	if (other != self.enemy)
	{
		setsize(self, VEC_HULL2_MIN, VEC_HULL2_MAX);
		self.movetype = MOVETYPE_STEP;
	}
	self.angles = VEC_ORIGIN;
	self.touch = SUB_Null;
	self.velocity = VEC_ORIGIN;
	self.carrymode = MSG_BROADCAST;
	self.flags = self.flags + (self.flags & FL_ONGROUND);
	self.think = gaunt_run1;
	self.ltime = time + SECRET_1ST_DOWN;
	if (other.takedamage && other.classname != "monster_gaunt" && other.carrymode != LIGHTNING_RANDOM && other == self.enemy)
	{
		sound(self, CHAN_VOICE, "gaunt/hit.wav", LIGHTNING_RANDOM, ATTN_NORM);
		self.carry = other;
		setorigin(self, self.origin + '0 0 64');
		setorigin(self.carry, self.origin - '0 0 68');
		self.touch = SUB_Null;
		tempself = self;
		self = self.carry;
		if (self.items & IT_SUPER_SHOTGUN)
		{
			self.items_stasis = self.items_stasis | IT_SUPER_SHOTGUN;
		}
		if (self.items & IT_NAILGUN)
		{
			self.items_stasis = self.items_stasis | IT_NAILGUN;
		}
		if (self.items & IT_SUPER_NAILGUN)
		{
			self.items_stasis = self.items_stasis | IT_SUPER_NAILGUN;
		}
		if (self.items & IT_GRENADE_LAUNCHER)
		{
			self.items_stasis = self.items_stasis | IT_GRENADE_LAUNCHER;
		}
		if (self.items & IT_ROCKET_LAUNCHER)
		{
			self.items_stasis = self.items_stasis | IT_ROCKET_LAUNCHER;
		}
		if (self.items & IT_LIGHTNING)
		{
			self.items_stasis = self.items_stasis | IT_LIGHTNING;
		}
		if (self.items & IT_PLASMA)
		{
			self.items_stasis = self.items_stasis | IT_PLASMA;
		}
		self.rememberweapon = self.weapon;
		self.items = self.items - (self.items & (IT_SUPER_SHOTGUN | IT_NAILGUN | IT_SUPER_NAILGUN | IT_GRENADE_LAUNCHER | IT_ROCKET_LAUNCHER | IT_LIGHTNING | IT_PLASMA));
		self.weapon = W_BestWeapon();
		W_SetCurrentAmmo();
		self = tempself;
		self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
		self.carrymode = LIGHTNING_RANDOM;
		self.carry.carrymode = LIGHTNING_RANDOM;
		findclosestpath();
		gaunt_carry1();
	}
};

void() check_player_carry_status = 
{
	if (self.enemy.carrymode == LIGHTNING_RANDOM)
	{
		self.angles = VEC_ORIGIN;
		self.touch = SUB_Null;
		self.velocity = VEC_ORIGIN;
		self.movetype = MOVETYPE_STEP;
		self.carrymode = MSG_BROADCAST;
		self.flags = self.flags + (self.flags & FL_ONGROUND);
		self.think = gaunt_run1;
		self.ltime = time + SECRET_1ST_DOWN;
		return;
	}
	return;
};

void() gaunt_flyswoop = 
{
	self.velocity = self.goalentity.origin - self.origin + '0 0 32';
	self.velocity = normalize(self.velocity);
	self.velocity = self.velocity * 600;
	self.angles = vectoangles(self.velocity);
};

void() gaunt_charge1 = [72, gaunt_charge2]
{
	check_player_carry_status();
};

void() gaunt_charge2 = [73, gaunt_charge3]
{
	gaunt_flyswoop();
	check_player_carry_status();
};

void() gaunt_charge3 = [74, gaunt_charge4]
{
	gaunt_flyswoop();
	check_player_carry_status();
};

void() gaunt_charge4 = [75, gaunt_charge5]
{
	gaunt_flyswoop();
	check_player_carry_status();
};

void() gaunt_charge5 = [76, gaunt_charge2]
{
	gaunt_flyswoop();
	check_player_carry_status();
};

void(float thespeed) gaunt_flyup = 
{
	self.movetype = MOVETYPE_FLYMISSILE;
	self.velocity_z = thespeed;
};

void() gaunt_precharge1 = [64, gaunt_precharge2]
{
	gaunt_flyup(SVC_INTERMISSION);
	self.pain_finished = time + SECRET_1ST_DOWN;
};

void() gaunt_precharge2 = [65, gaunt_precharge3]
{
	gaunt_flyup(40);
};

void() gaunt_precharge3 = [66, gaunt_precharge4]
{
	gaunt_flyup(50);
};

void() gaunt_precharge4 = [67, gaunt_precharge5]
{
	gaunt_flyup(60);
};

void() gaunt_precharge5 = [68, gaunt_precharge6]
{
	gaunt_flyup(80);
};

void() gaunt_precharge6 = [69, gaunt_precharge7]
{
	gaunt_flyup(100);
};

void() gaunt_precharge7 = [70, gaunt_precharge8]
{
	gaunt_flyup(120);
};

void() gaunt_precharge8 = [71, gaunt_charge1]
{
	gaunt_flyup(150);
	self.carrymode = LIGHTNING_BOOM;
	self.movetype = MOVETYPE_FLYMISSILE;
	self.touch = Gaunt_Touch;
	makevectors(self.angles);
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	self.origin_z = self.origin_z + LIGHTNING_RANDOM;
	self.velocity = normalize(self.goalentity.origin - self.origin + '0 0 32') * 600;
	self.angles = vectoangles(self.velocity);
};

void() gaunt_paina1 = [82, gaunt_paina2]
{
};

void() gaunt_paina2 = [83, gaunt_paina3]
{
};

void() gaunt_paina3 = [84, gaunt_paina4]
{
};

void() gaunt_paina4 = [85, gaunt_paina5]
{
};

void() gaunt_paina5 = [86, gaunt_paina6]
{
};

void() gaunt_paina6 = [87, gaunt_run1]
{
};

void() gaunt_painb1 = [88, gaunt_painb2]
{
};

void() gaunt_painb2 = [89, gaunt_painb3]
{
};

void() gaunt_painb3 = [90, gaunt_painb4]
{
};

void() gaunt_painb4 = [91, gaunt_painb5]
{
};

void() gaunt_painb5 = [92, gaunt_run1]
{
};

void() gaunt_carrypaina1 = [82, gaunt_carrypaina2]
{
	ai_pathfollow(LIGHTNING_BOOM * self.multiplier);
	carry_enemy();
};

void() gaunt_carrypaina2 = [83, gaunt_carrypaina3]
{
	ai_pathfollow(LIGHTNING_BOOM * self.multiplier);
	carry_enemy();
};

void() gaunt_carrypaina3 = [84, gaunt_carrypaina4]
{
	ai_pathfollow(LIGHTNING_BOOM * self.multiplier);
	carry_enemy();
};

void() gaunt_carrypaina4 = [85, gaunt_carrypaina5]
{
	ai_pathfollow(LIGHTNING_BOOM * self.multiplier);
	carry_enemy();
};

void() gaunt_carrypaina5 = [86, gaunt_carrypaina6]
{
	ai_pathfollow(LIGHTNING_BOOM * self.multiplier);
	carry_enemy();
};

void() gaunt_carrypaina6 = [87, gaunt_carry1]
{
	ai_pathfollow(LIGHTNING_BOOM * self.multiplier);
	carry_enemy();
};

void() gaunt_carrypainb1 = [88, gaunt_carrypainb2]
{
	ai_pathfollow(LIGHTNING_BOOM * self.multiplier);
	carry_enemy();
};

void() gaunt_carrypainb2 = [89, gaunt_carrypainb3]
{
	ai_pathfollow(LIGHTNING_BOOM * self.multiplier);
	carry_enemy();
};

void() gaunt_carrypainb3 = [90, gaunt_carrypainb4]
{
	ai_pathfollow(LIGHTNING_BOOM * self.multiplier);
	carry_enemy();
};

void() gaunt_carrypainb4 = [91, gaunt_carrypainb5]
{
	ai_pathfollow(LIGHTNING_BOOM * self.multiplier);
	carry_enemy();
};

void() gaunt_carrypainb5 = [92, gaunt_carry1]
{
	ai_pathfollow(LIGHTNING_BOOM * self.multiplier);
	carry_enemy();
};

void() gaunt_deatha_continue = 
{
	self.touch = SUB_Null;
	self.think = gaunt_deatha6;
};

void() gaunt_deathb_continue = 
{
	self.touch = SUB_Null;
	self.think = gaunt_deathb7;
};

void() gaunt_deatha1 = [93, gaunt_deatha2]
{
	self.touch = gaunt_deatha_continue;
};

void() gaunt_deatha2 = [94, gaunt_deatha3]
{
};

void() gaunt_deatha3 = [95, gaunt_deatha4]
{
};

void() gaunt_deatha4 = [96, gaunt_deatha5]
{
};

void() gaunt_deatha5 = [97, gaunt_deatha5]
{
};

void() gaunt_deatha6 = [98, gaunt_deatha7]
{
	self.solid = SOLID_NOT;
	self.touch = SUB_Null;
};

void() gaunt_deatha7 = [99, gaunt_deatha8]
{
};

void() gaunt_deatha8 = [100, monster_fade]
{
};

void() gaunt_deathb1 = [101, gaunt_deathb2]
{
	self.touch = gaunt_deathb_continue;
};

void() gaunt_deathb2 = [102, gaunt_deathb3]
{
};

void() gaunt_deathb3 = [103, gaunt_deathb4]
{
};

void() gaunt_deathb4 = [104, gaunt_deathb5]
{
};

void() gaunt_deathb5 = [105, gaunt_deathb6]
{
};

void() gaunt_deathb6 = [106, gaunt_deathb6]
{
};

void() gaunt_deathb7 = [107, gaunt_deathb8]
{
	self.solid = SOLID_NOT;
	self.touch = SUB_Null;
};

void() gaunt_deathb8 = [108, monster_fade]
{
};

void() gaunt_die = 
{
	if (self.carry)
	{
		self.carry.carrymode = MSG_BROADCAST;
	}
	self.angles = VEC_ORIGIN;
	self.velocity = VEC_ORIGIN;
	self.attack_state = AS_STRAIGHT;
	if (self.health < -90)
	{
		sound(self, CHAN_VOICE, "player/udeath.wav", LIGHTNING_RANDOM, ATTN_NORM);
		ThrowHead("progs/h_gaunt.mdl", self.health);
		ThrowGib("progs/gib2.mdl", self.health);
		ThrowGib("progs/gib2.mdl", self.health);
		ThrowGib("progs/gib2.mdl", self.health);
		return;
	}
	sound(self, CHAN_VOICE, "gaunt/death.wav", LIGHTNING_RANDOM, ATTN_NORM);
	if (self.carrymode == LIGHTNING_RANDOM)
	{
		gaunt_reset();
	}
	self.movetype = MOVETYPE_STEP;
	self.velocity_x = -100 + 200 * random();
	self.velocity_y = -100 + 200 * random();
	self.velocity_z = 150 + 100 * random();
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	if (random() < 0.5)
	{
		self.think = gaunt_deatha1;
	}
	else
	{
		self.think = gaunt_deathb1;
	}
};

void() gaunt_Pain = 
{
	if (self.pain_finished > time)
	{
		return;
	}
	if (random() < 0.6)
	{
		return;
	}
	self.velocity = VEC_ORIGIN;
	sound(self, CHAN_VOICE, "gaunt/pain.wav", LIGHTNING_RANDOM, ATTN_NORM);
	if (self.carrymode == LIGHTNING_RANDOM)
	{
		if (random() < 0.5)
		{
			gaunt_carrypaina1();
		}
		else
		{
			gaunt_carrypainb1();
		}
	}
	else
	{
		self.pain_finished = time + TE_WIZSPIKE;
		self.movetype = MOVETYPE_STEP;
		self.attack_state = AS_STRAIGHT;
		if (random() < 0.5)
		{
			gaunt_paina1();
		}
		else
		{
			gaunt_painb1();
		}
	}
};

float(entity targ, entity viewpoint) visible2 = 
{
	local vector spot1;
	local vector spot2;
	spot1 = viewpoint.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;
	traceline(spot1, spot2, 1, self);
	if (trace_inopen && trace_inwater)
	{
		return 0;
	}
	if (trace_fraction == LIGHTNING_RANDOM)
	{
		return 1;
	}
	return 0;
};

void() gaunt_checkswoop = 
{
	local entity head;
	local float m;
	local float n;
	local float allowswoop;
	head = findradius(self.origin, 10000);
	while (head)
	{
		if (head.classname == "gaunt_corner" && head.targetname == self.pathtarget)
		{
			m = vlen(self.enemy.origin - head.origin);
			if (m > 500 && visible2(head, self.enemy))
			{
				return 1;
			}
			if (m <= 500 && !visible2(head, self.enemy))
			{
				return 1;
			}
		}
		head = head.chain;
	}
	return 0;
};

void() gaunt_Missile = 
{
	self.attack_state = AS_STRAIGHT;
	self.movetype = MOVETYPE_STEP;
	if (self.ltime < time && vlen(self.origin - self.enemy.origin) < 750 && self.enemy.carrymode == MSG_BROADCAST && self.swoop != MSG_BROADCAST && (self.enemy.flags & FL_CLIENT) && self.enemy.client_gaunt_swoop_time < time)
	{
		if (!gaunt_checkswoop)
		{
			return;
		}
		setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
		self.ltime = time + TE_LAVASPLASH;
		self.pain_finished = time + TE_WIZSPIKE;
		gaunt_precharge1();
		return;
	}
	if (self.swoop == LIGHTNING_BOOM)
	{
		return;
	}
	if (random() < 0.4 && self.swoop == LIGHTNING_RANDOM && self.enemy.carrymode == MSG_BROADCAST)
	{
		gaunt_fast1();
	}
	else
	{
		if (random() < 0.7 && self.swoop != LIGHTNING_RANDOM && self.enemy.carrymode == MSG_BROADCAST)
		{
			gaunt_fast1();
		}
	}
	return;
};

void() gaunt_start = 
{
	local vector org;
	if (!(self.spawnflags & TRIGGER_SPAWNSILENT))
	{
		org = self.origin + SECRET_YES_SHOOT * v_forward;
		spawn_tfog(org);
	}
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/gaunt.mdl");
	setsize(self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	self.health = 375;
	if (self.perch == LIGHTNING_RANDOM)
	{
		self.origin_z = self.origin_z + LIGHTNING_RANDOM;
		droptofloor();
		self.th_stand = gaunt_perch1;
		self.th_run = gaunt_rise1;
	}
	monster_spawn();
	flymonster_start_go();
};

void() gaunt_begin = 
{
	if (self.spawndelay > MSG_BROADCAST)
	{
		self.nextthink = time + self.spawndelay;
	}
	else
	{
		if (self.spawndelay == CONTENT_EMPTY)
		{
			self.nextthink = time + random() * 0.4;
		}
		else
		{
			self.nextthink = time + 0.1;
		}
	}
	self.think = gaunt_start;
};

void() monster_gaunt = 
{
	if (!(self.pathtarget) && self.swoop == LIGHTNING_RANDOM)
	{
		bprint("problem with monster_gaunt at:");
		bprint(vtos(self.origin));
		bprint("\n");
		objerror("Swoop key set to 1 but no pathtarget set.  remember, you need to point the gaunt to it's gaunt_corner entities via the pathtarget field.");
	}
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/gaunt.mdl");
	precache_model("progs/h_gaunt.mdl");
	precache_model("progs/g_fx.mdl");
	precache_sound("gaunt/death.wav");
	precache_sound("gaunt/idle1.wav");
	precache_sound("gaunt/idle2.wav");
	precache_sound("gaunt/idle3.wav");
	precache_sound("gaunt/pain.wav");
	precache_sound("gaunt/sight.wav");
	self.takedamage = DAMAGE_AIM;
	self.yaw_speed = 35;
	self.th_stand = gaunt_stand1;
	self.th_walk = gaunt_walk1;
	self.th_run = gaunt_run1;
	self.th_missile = gaunt_Missile;
	self.th_die = gaunt_die;
	if (self.perch == LIGHTNING_RANDOM)
	{
		self.th_pain = gaunt_rise1;
	}
	else
	{
		self.th_pain = gaunt_Pain;
	}
	if (!(self.multiplier))
	{
		self.multiplier = AS_MELEE;
	}
	if (!(self.vmultiplier))
	{
		self.vmultiplier = -0.2;
	}
	if (!(self.vsightmultiplier))
	{
		self.vsightmultiplier = -0.9;
	}
	if (self.spawnflags & TRIGGER_SPAWN)
	{
		self.use = gaunt_begin;
		total_monsters = total_monsters + LIGHTNING_RANDOM;
		return;
	}
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/gaunt.mdl");
	setsize(self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	self.health = 375;
	if (self.perch == LIGHTNING_RANDOM)
	{
		self.origin_z = self.origin_z + LIGHTNING_RANDOM;
		droptofloor();
		self.th_stand = gaunt_perch1;
		self.th_run = gaunt_rise1;
	}
	flymonster_start();
};

