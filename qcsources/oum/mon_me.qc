void() DrunkExplode = 
{
	T_RadiusDamage(self, self.owner, SVC_INTERMISSION, world);
	sound(self, CHAN_VOICE, "weapons/r_exp3.wav", 1, ATTN_NORM);
	self.velocity = VEC_ORIGIN;
	self.touch = SUB_Null;
	setmodel(self, "progs/s_explod.spr");
	self.movetype = MOVETYPE_FLYMISSILE;
	self.solid = SOLID_NOT;
	s_explode1();
};

void() drunkthink = 
{
	if (!infront(self.enemy))
	{
		return;
	}
	self.velocity = normalize(self.enemy.origin - self.origin);
	self.velocity = self.velocity * (450 + random() * 50);
	makevectors(self.velocity);
	self.velocity = self.velocity + v_right * ((random() * MAX_SHELLS + MAX_SHELLS) * self.cnt);
	self.angles = vectoangles(self.velocity);
	if (self.cnt == 1)
	{
		self.cnt = CONTENT_EMPTY;
	}
	else
	{
		self.cnt = 1;
	}
	if (vlen(self.enemy.origin - self.origin) > 250)
	{
		self.nextthink = time + 0.3;
	}
};

void() FireDrunkMissile = 
{
	local entity missile;
	local entity mpuff;
	local vector org;
	local vector lead;
	local vector spot;
	local float go;
	self.effects = self.effects | EF_MUZZLEFLASH;
	sound(self, CHAN_WEAPON, "me/me_fire2.wav", 1, ATTN_NORM);
	missile = spawn();
	missile.owner = self;
	missile.enemy = self.enemy;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	lead = normalize(self.enemy.origin - self.origin);
	missile.velocity = lead * (450 + random() * 50);
	makevectors(missile.velocity);
	missile.velocity = missile.velocity + v_up * (random() * 20 - MOVETYPE_BOUNCE) + v_right * (random() * 40 - 20);
	missile.angles = vectoangles(missile.velocity);
	missile.touch = DrunkExplode;
	missile.cnt = 1;
	missile.nextthink = time + 0.25;
	missile.think = drunkthink;
	setmodel(missile, "progs/memissil.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	makevectors(self.angles);
	org = self.origin + '0 0 28' + v_right * MOVETYPE_TOSS;
	setorigin(missile, org);
};

void() particlethink = 
{
	particle(self.origin, self.oldorigin, MOVETYPE_BOUNCE, SVC_INTERMISSION);
	particle(self.origin, self.oldorigin, 40, SVC_INTERMISSION);
	self.nextthink = time + 0.05;
};

void() FireParticleBeam = 
{
	local vector org;
	local vector mep;
	local vector nmep;
	local entity missile;
	local entity mpuff;
	local vector lead;
	local vector spot;
	local float go;
	self.effects = self.effects | EF_MUZZLEFLASH;
	makevectors(self.angles);
	org = self.origin + v_forward * SVC_INTERMISSION + v_right * 8.5 + '0 0 16';
	sound(self, CHAN_WEAPON, "me/me_fire1.wav", 1, ATTN_NORM);
	missile = spawn();
	missile.owner = self;
	missile.enemy = self.enemy;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.effects = EF_DIMLIGHT;
	go = vlen(self.enemy.origin - org) / 500;
	mep = self.enemy.velocity;
	mep_z = 0;
	spot = self.enemy.origin + mep * go;
	traceline(org, spot, 0, world);
	if (trace_fraction < 0.8)
	{
		spot = self.enemy.origin;
	}
	lead = normalize(spot - org);
	missile.oldorigin = lead * MOVETYPE_FLY;
	missile.velocity = lead * 620;
	missile.touch = Laser_Touch;
	missile.cnt = 1;
	missile.nextthink = time + 0.05;
	missile.think = particlethink;
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, org);
};

void() megaenforcer_fire = 
{
	local float edist;
	edist = vlen(self.enemy.origin - self.origin);
	if (edist < MAX_NAILS)
	{
		menf_atk1();
	}
	else
	{
		if (random() < 0.65 || edist > 700)
		{
			menf_satck1();
		}
		else
		{
			menf_atk1();
		}
	}
};

void() menf_stand1 = [0, menf_stand2]
{
	ai_stand();
};

void() menf_stand2 = [1, menf_stand3]
{
	ai_stand();
};

void() menf_stand3 = [2, menf_stand4]
{
	ai_stand();
};

void() menf_stand4 = [3, menf_stand5]
{
	ai_stand();
};

void() menf_stand5 = [4, menf_stand6]
{
	ai_stand();
};

void() menf_stand6 = [5, menf_stand7]
{
	ai_stand();
};

void() menf_stand7 = [6, menf_stand1]
{
	ai_stand();
};

void() menf_walk1 = [7, menf_walk2]
{
	if (random() < 0.2)
	{
		sound(self, CHAN_VOICE, "me/meidle.wav", 1, ATTN_IDLE);
	}
	ai_walk(FL_SWIM);
};

void() menf_walk2 = [8, menf_walk3]
{
	ai_walk(MOVETYPE_STEP);
};

void() menf_walk3 = [9, menf_walk4]
{
	ai_walk(MOVETYPE_STEP);
};

void() menf_walk4 = [10, menf_walk5]
{
	ai_walk(MOVETYPE_WALK);
};

void() menf_walk5 = [11, menf_walk6]
{
	ai_walk(1);
};

void() menf_walk6 = [12, menf_walk7]
{
	ai_walk(FL_SWIM);
};

void() menf_walk7 = [13, menf_walk8]
{
	ai_walk(FL_SWIM);
};

void() menf_walk8 = [14, menf_walk9]
{
	ai_walk(1);
};

void() menf_walk9 = [15, menf_walk10]
{
	ai_walk(FL_SWIM);
};

void() menf_walk10 = [16, menf_walk11]
{
	ai_walk(MOVETYPE_STEP);
};

void() menf_walk11 = [17, menf_walk12]
{
	ai_walk(MOVETYPE_STEP);
};

void() menf_walk12 = [18, menf_walk13]
{
	ai_walk(1);
};

void() menf_walk13 = [19, menf_walk14]
{
	ai_walk(FL_SWIM);
};

void() menf_walk14 = [20, menf_walk15]
{
	ai_walk(MOVETYPE_WALK);
};

void() menf_walk15 = [21, menf_walk16]
{
	ai_walk(MOVETYPE_STEP);
};

void() menf_walk16 = [22, menf_walk1]
{
	ai_walk(FL_SWIM);
};

void() menf_shld1 = [119, menf_shld2]
{
};

void() menf_shld2 = [120, menf_shld3]
{
};

void() menf_shld3 = [121, menf_shld4]
{
	self.takedamage = DAMAGE_NO;
	sound(self, CHAN_AUTO, "me/me_son.wav", 1, ATTN_NORM);
};

void() menf_shld4 = [122, menf_shld5]
{
};

void() menf_shld5 = [123, menf_shld6]
{
};

void() menf_shld6 = [124, menf_shld7]
{
};

void() menf_shld7 = [125, menf_run1]
{
};

void() menf_run1 = [23, menf_run2]
{
	if (random() < 0.2)
	{
		sound(self, CHAN_VOICE, "me/meidle.wav", 1, ATTN_IDLE);
	}
	ai_run(18);
	self.takedamage = DAMAGE_NO;
};

void() menf_run2 = [24, menf_run3]
{
	ai_run(14);
};

void() menf_run3 = [25, menf_run4]
{
	ai_run(MOVETYPE_PUSH);
};

void() menf_run4 = [26, menf_run5]
{
	ai_run(STAT_TOTALMONSTERS);
};

void() menf_run5 = [27, menf_run6]
{
	ai_run(14);
};

void() menf_run6 = [28, menf_run7]
{
	ai_run(14);
};

void() menf_run7 = [29, menf_run8]
{
	ai_run(MOVETYPE_PUSH);
};

void() menf_run8 = [30, menf_run1]
{
	ai_run(MOVETYPE_BOUNCEMISSILE);
};

void() menf_atk1 = [31, menf_atk2]
{
	ai_face();
	if (random() < 0.3)
	{
		self.think = menf_run1;
		return;
	}
	self.takedamage = DAMAGE_AIM;
	sound(self, CHAN_AUTO, "me/me_soff.wav", 1, ATTN_NORM);
};

void() menf_atk2 = [32, menf_atk3]
{
	ai_face();
};

void() menf_atk3 = [33, menf_atk4]
{
	ai_face();
};

void() menf_atk4 = [34, menf_atk7]
{
	ai_face();
};

void() menf_atk5 = [35, menf_atk6]
{
	ai_face();
};

void() menf_atk6 = [36, menf_atk7]
{
};

void() menf_atk7 = [37, menf_atk8]
{
	ai_face();
};

void() menf_atk8 = [38, menf_atk9]
{
	ai_face();
};

void() menf_atk9 = [35, menf_atk10]
{
	ai_face();
	self.oldorigin = self.enemy.origin;
};

void() menf_atk10 = [36, menf_atk11]
{
	FireParticleBeam();
};

void() menf_atk11 = [37, menf_atk12]
{
	ai_face();
};

void() menf_atk12 = [38, menf_atk13]
{
	ai_face();
	sound(self, CHAN_AUTO, "me/me_son.wav", 1, ATTN_NORM);
};

void() menf_atk13 = [39, menf_atk14]
{
	ai_face();
};

void() menf_atk14 = [40, menf_run1]
{
	ai_face();
	SUB_CheckRefire(menf_atk1);
	self.takedamage = DAMAGE_NO;
};

void() menf_satck1 = [112, menf_satck2]
{
	ai_face();
	self.takedamage = DAMAGE_AIM;
	sound(self, CHAN_AUTO, "me/me_soff.wav", 1, ATTN_NORM);
};

void() menf_satck2 = [113, menf_satck3]
{
	ai_face();
};

void() menf_satck3 = [113, menf_satck4]
{
	ai_face();
};

void() menf_satck4 = [114, menf_satck5]
{
	ai_face();
};

void() menf_satck5 = [115, menf_satck6]
{
	ai_face();
};

void() menf_satck6 = [115, menf_satck7]
{
	ai_face();
};

void() menf_satck7 = [116, menf_satck8]
{
	ai_face();
	FireDrunkMissile();
};

void() menf_satck8 = [117, menf_satck9]
{
	ai_face();
	sound(self, CHAN_AUTO, "me/me_son.wav", 1, ATTN_NORM);
};

void() menf_satck9 = [118, menf_run1]
{
	ai_face();
	self.takedamage = DAMAGE_NO;
};

void() menf_paina1 = [76, menf_paina2]
{
};

void() menf_paina2 = [77, menf_paina3]
{
};

void() menf_paina3 = [78, menf_paina4]
{
};

void() menf_paina4 = [79, menf_run1]
{
};

void() menf_painb1 = [80, menf_painb2]
{
};

void() menf_painb2 = [81, menf_painb3]
{
};

void() menf_painb3 = [82, menf_painb4]
{
};

void() menf_painb4 = [83, menf_painb5]
{
};

void() menf_painb5 = [84, menf_run1]
{
};

void() menf_painc1 = [85, menf_painc2]
{
};

void() menf_painc2 = [86, menf_painc3]
{
};

void() menf_painc3 = [87, menf_painc4]
{
};

void() menf_painc4 = [88, menf_painc5]
{
};

void() menf_painc5 = [89, menf_painc6]
{
};

void() menf_painc6 = [90, menf_painc7]
{
};

void() menf_painc7 = [91, menf_painc8]
{
};

void() menf_painc8 = [92, menf_run1]
{
};

void() menf_paind1 = [93, menf_paind2]
{
};

void() menf_paind2 = [94, menf_paind3]
{
};

void() menf_paind3 = [95, menf_paind4]
{
};

void() menf_paind4 = [96, menf_paind5]
{
	ai_painforward(FL_SWIM);
};

void() menf_paind5 = [97, menf_paind6]
{
	ai_painforward(1);
};

void() menf_paind6 = [98, menf_paind7]
{
};

void() menf_paind7 = [99, menf_paind8]
{
};

void() menf_paind8 = [100, menf_paind9]
{
};

void() menf_paind9 = [101, menf_paind10]
{
};

void() menf_paind10 = [102, menf_paind11]
{
};

void() menf_paind11 = [103, menf_paind12]
{
	ai_painforward(1);
};

void() menf_paind12 = [104, menf_paind13]
{
	ai_painforward(1);
};

void() menf_paind13 = [105, menf_paind14]
{
	ai_painforward(1);
};

void() menf_paind14 = [106, menf_paind15]
{
};

void() menf_paind15 = [107, menf_paind16]
{
};

void() menf_paind16 = [108, menf_paind17]
{
	ai_pain(1);
};

void() menf_paind17 = [109, menf_paind18]
{
	ai_pain(1);
};

void() menf_paind18 = [110, menf_paind19]
{
};

void() menf_paind19 = [111, menf_run1]
{
};

void(entity attacker, float damage) menf_pain = 
{
	local float r;
	if (self.pain_finished > time || self.health > 120)
	{
		return;
	}
	r = random();
	if (r < 0.3)
	{
		sound(self, CHAN_VOICE, "me/mepain1.wav", 1, ATTN_NORM);
	}
	else
	{
		if (r < 0.6)
		{
			sound(self, CHAN_VOICE, "me/mepain2.wav", 1, ATTN_NORM);
		}
		else
		{
			sound(self, CHAN_VOICE, "me/mepain3.wav", 1, ATTN_NORM);
		}
	}
	r = random();
	if (r < 0.2)
	{
		self.pain_finished = time + 1;
		menf_paina1();
	}
	else
	{
		if (r < 0.4)
		{
			self.pain_finished = time + 1;
			menf_painb1();
		}
		else
		{
			if (r < 0.6)
			{
				self.pain_finished = time + 1;
				menf_painc1();
			}
			else
			{
				if (r < 0.85 && self.health < 75)
				{
					self.pain_finished = time + FL_SWIM;
					menf_paind1();
				}
			}
		}
	}
};

void() menf_die1 = [51, menf_die2]
{
};

void() menf_die2 = [52, menf_die3]
{
};

void() menf_die3 = [53, menf_die4]
{
	self.solid = SOLID_NOT;
	self.ammo_cells = MOVETYPE_FLY;
	DropBackpack();
};

void() menf_die4 = [54, menf_die5]
{
	ai_forward(14);
};

void() menf_die5 = [55, menf_die6]
{
	ai_forward(FL_SWIM);
};

void() menf_die6 = [56, menf_die7]
{
};

void() menf_die7 = [57, menf_die8]
{
};

void() menf_die8 = [58, menf_die9]
{
};

void() menf_die9 = [59, menf_die10]
{
	ai_forward(MOVETYPE_WALK);
};

void() menf_die10 = [60, menf_die11]
{
	ai_forward(MOVETYPE_FLY);
};

void() menf_die11 = [61, menf_die12]
{
	ai_forward(MOVETYPE_FLY);
};

void() menf_die12 = [62, menf_die13]
{
	ai_forward(MOVETYPE_FLY);
};

void() menf_die13 = [63, menf_die14]
{
};

void() menf_die14 = [64, menf_die14]
{
};

void() menf_fdie1 = [65, menf_fdie2]
{
};

void() menf_fdie2 = [66, menf_fdie3]
{
};

void() menf_fdie3 = [67, menf_fdie4]
{
	self.solid = SOLID_NOT;
	self.ammo_cells = MOVETYPE_FLY;
	DropBackpack();
};

void() menf_fdie4 = [68, menf_fdie5]
{
};

void() menf_fdie5 = [69, menf_fdie6]
{
};

void() menf_fdie6 = [70, menf_fdie7]
{
};

void() menf_fdie7 = [71, menf_fdie8]
{
};

void() menf_fdie8 = [72, menf_fdie9]
{
};

void() menf_fdie9 = [73, menf_fdie10]
{
};

void() menf_fdie10 = [74, menf_fdie11]
{
};

void() menf_fdie11 = [75, menf_fdie11]
{
};

void() menf_die = 
{
	if (self.health < -35)
	{
		sound(self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		ThrowHead("progs/h_me.mdl", self.health, self.dest);
		ThrowGib("progs/gib1.mdl", self.health, self.dest);
		ThrowGib("progs/gib2.mdl", self.health, self.dest);
		ThrowGib("progs/gib3.mdl", self.health, self.dest);
		return;
	}
	if (random() > 0.5)
	{
		sound(self, CHAN_VOICE, "me/medeath2.wav", 1, ATTN_NORM);
		menf_die1();
	}
	else
	{
		sound(self, CHAN_VOICE, "me/medeath1.wav", 1, ATTN_NORM);
		menf_fdie1();
	}
};

void() monster_me = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model2("progs/enforce2.mdl");
	precache_model2("progs/h_me.mdl");
	precache_model2("progs/memissil.mdl");
	precache_sound2("me/medeath1.wav");
	precache_sound2("me/medeath2.wav");
	precache_sound2("me/me_fire1.wav");
	precache_sound2("me/me_fire2.wav");
	precache_sound2("me/meidle.wav");
	precache_sound2("enforcer/enfstop.wav");
	precache_sound2("me/mepain1.wav");
	precache_sound2("me/mepain2.wav");
	precache_sound2("me/mepain3.wav");
	precache_sound2("me/mesight1.wav");
	precache_sound2("me/mesight2.wav");
	precache_sound2("me/mesight3.wav");
	precache_sound2("me/me_son.wav");
	precache_sound2("me/me_soff.wav");
	self.th_stand = menf_stand1;
	self.th_walk = menf_walk1;
	self.th_run = menf_shld1;
	self.th_pain = menf_pain;
	self.th_die = menf_die;
	self.th_missile = megaenforcer_fire;
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/enforce2.mdl");
	setsize(self, VEC_HULL_MIN, '16 16 40');
	self.health = 150;
	self.flags = self.flags + FL_BLUE;
	walkmonster_start();
	self.takedamage = DAMAGE_NO;
};

