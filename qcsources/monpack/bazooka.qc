void() BabeRocketExplode = 
{
	T_RadiusDamage(self, self.owner, 80, world);
	sound(self, CHAN_VOICE, "weapons/r_exp3.wav", 1, ATTN_NORM);
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_TAREXPLOSION);
	WriteCoord(MSG_BROADCAST, self.origin_x);
	WriteCoord(MSG_BROADCAST, self.origin_y);
	WriteCoord(MSG_BROADCAST, self.origin_z);
	self.velocity = VEC_ORIGIN;
	self.touch = SUB_Null;
	setmodel(self, "progs/s_explod.spr");
	self.solid = SOLID_NOT;
	s_explode1();
};

void() BabeRocketExplodb = 
{
	T_RadiusDamage(self, self.owner, MOVETYPE_BOUNCE, world);
	sound(self, CHAN_VOICE, "weapons/r_exp3.wav", 1, ATTN_NORM);
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_TAREXPLOSION);
	WriteCoord(MSG_BROADCAST, self.origin_x);
	WriteCoord(MSG_BROADCAST, self.origin_y);
	WriteCoord(MSG_BROADCAST, self.origin_z);
	self.velocity = VEC_ORIGIN;
	self.touch = SUB_Null;
	setmodel(self, "progs/s_explod.spr");
	self.solid = SOLID_NOT;
	s_explode1();
};

void() BabeRocketTouch = 
{
	if (other == self.owner)
	{
		return;
	}
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	sound(self, CHAN_VOICE, "enforcer/enfstop.wav", 1, ATTN_STATIC);
	if (self.velocity == VEC_ORIGIN)
	{
		self.avelocity = VEC_ORIGIN;
	}
	if (other.health)
	{
		if (other.classname == "monster_bazooka")
		{
			BabeRocketExplodb();
		}
		else
		{
			BabeRocketExplode();
		}
		return;
	}
	else
	{
		WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte(MSG_BROADCAST, TE_TAREXPLOSION);
		WriteCoord(MSG_BROADCAST, self.origin_x);
		WriteCoord(MSG_BROADCAST, self.origin_y);
		WriteCoord(MSG_BROADCAST, self.origin_z);
	}
	remove(self);
};

void() BabeFireRocket = 
{
	local entity missile;
	local entity mpuff;
	local vector org;
	local vector vec;
	self.effects = self.effects | EF_MUZZLEFLASH;
	sound(self, CHAN_WEAPON, "weapons/sgun1.wav", 1, ATTN_NORM);
	makevectors(self.angles);
	org = self.origin + v_forward * SVC_INTERMISSION + v_right * 8.5 + '0 0 16';
	vec = normalize(vec);
	self.punchangle_x = CONTENT_SOLID;
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	makevectors(self.angles);
	missile.velocity = normalize(self.enemy.origin - self.origin);
	missile.velocity = missile.velocity * 1000;
	missile.angles = vectoangles(missile.velocity);
	missile.touch = BabeRocketTouch;
	missile.nextthink = time + MOVETYPE_FLY;
	missile.think = BabeRocketExplode;
	setmodel(missile, "progs/pulse.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, self.origin + v_forward * FL_CLIENT + '0 0 16');
};

void() babe_stand = [1, babe_stand2]
{
	if (random() < 0.1)
	{
		sound(self, CHAN_VOICE, "bazooka/when.wav", 1, ATTN_IDLE);
	}
};

void() babe_stand2 = [1, babe_stand3]
{
	ai_stand();
};

void() babe_stand3 = [2, babe_stand4]
{
	ai_stand();
};

void() babe_stand4 = [2, babe_stand5]
{
	ai_stand();
};

void() babe_stand5 = [3, babe_stand6]
{
	ai_stand();
};

void() babe_stand6 = [3, babe_stand7]
{
	ai_stand();
};

void() babe_stand7 = [4, babe_stand8]
{
	ai_stand();
};

void() babe_stand8 = [4, babe_stand9]
{
	ai_stand();
};

void() babe_stand9 = [5, babe_stand10]
{
	ai_stand();
};

void() babe_stand10 = [5, babe_stand11]
{
	ai_stand();
};

void() babe_stand11 = [5, babe_stand12]
{
	ai_stand();
};

void() babe_stand12 = [4, babe_stand13]
{
	ai_stand();
};

void() babe_stand13 = [4, babe_stand14]
{
	ai_stand();
};

void() babe_stand14 = [3, babe_stand15]
{
	ai_stand();
};

void() babe_stand15 = [3, babe_stand16]
{
	ai_stand();
};

void() babe_stand16 = [2, babe_stand17]
{
	ai_stand();
};

void() babe_stand17 = [2, babe_stand18]
{
	ai_stand();
};

void() babe_stand18 = [1, babe_stand]
{
	ai_stand();
};

void() babe_walk = [6, babe_walk1]
{
	sound(self, CHAN_VOICE, "bazooka/step1.wav", 1, ATTN_IDLE);
	ai_walk(FL_CLIENT);
};

void() babe_walk1 = [7, babe_walk2]
{
	ai_walk(0);
};

void() babe_walk2 = [8, babe_walk3]
{
	ai_walk(FL_INWATER);
};

void() babe_walk3 = [9, babe_walk4]
{
	ai_walk(BOSS);
};

void() babe_walk4 = [10, babe_walk5]
{
	sound(self, CHAN_VOICE, "bazooka/step1.wav", 1, ATTN_IDLE);
	ai_walk(FL_CLIENT);
};

void() babe_walk5 = [11, babe_walk6]
{
	ai_walk(0);
};

void() babe_walk6 = [12, babe_walk7]
{
	ai_walk(FL_CLIENT);
};

void() babe_walk7 = [13, babe_walk8]
{
	ai_walk(FL_INWATER);
};

void() babe_walk8 = [14, babe_walk]
{
	ai_walk(BOSS);
};

void() babe_run = [6, babe_run1]
{
	sound(self, CHAN_VOICE, "bazooka/step1.wav", 1, ATTN_IDLE);
	ai_run(FL_CLIENT);
};

void() babe_run1 = [7, babe_run2]
{
	ai_face();
};

void() babe_run2 = [8, babe_run3]
{
	ai_run(FL_INWATER);
};

void() babe_run3 = [9, babe_run4]
{
	ai_run(BOSS);
};

void() babe_run4 = [10, babe_run5]
{
	sound(self, CHAN_VOICE, "bazooka/step1.wav", 1, ATTN_IDLE);
	ai_run(FL_CLIENT);
};

void() babe_run5 = [11, babe_run6]
{
	ai_face();
};

void() babe_run6 = [12, babe_run7]
{
	ai_run(FL_CLIENT);
};

void() babe_run7 = [13, babe_run8]
{
	ai_run(FL_INWATER);
};

void() babe_run8 = [14, babe_run]
{
	ai_run(BOSS);
};

void() babe_fire1 = [15, babe_fire2]
{
	if (random() < 0.2)
	{
		sound(self, CHAN_VOICE, "bazooka/die.wav", 1, ATTN_NORM);
	}
	else
	{
		sound(self, CHAN_VOICE, "bazooka/stepstop.wav", 1, ATTN_IDLE);
	}
	ai_face();
};

void() babe_fire2 = [16, babe_fire3]
{
	ai_face();
};

void() babe_fire3 = [17, babe_fire4]
{
	ai_face();
};

void() babe_fire4 = [18, babe_fire5]
{
	ai_face();
};

void() babe_fire5 = [19, babe_fire6]
{
	ai_face();
};

void() babe_fire6 = [19, babe_fire7]
{
	ai_face();
};

void() babe_fire7 = [20, babe_fire8]
{
	ai_face();
	BabeFireRocket();
};

void() babe_fire8 = [21, babe_fire9]
{
	ai_face();
};

void() babe_fire9 = [22, babe_fire10]
{
	ai_face();
};

void() babe_fire10 = [23, babe_fire11]
{
	ai_face();
};

void() babe_fire11 = [24, babe_run]
{
	ai_face();
};

void() babe_pain1 = [25, babe_pain2]
{
	if (random() < 0.5)
	{
		sound(self, CHAN_VOICE, "bazooka/yeow.wav", 1, ATTN_IDLE);
	}
	else
	{
		sound(self, CHAN_VOICE, "bazooka/ooaa.wav", 1, ATTN_IDLE);
	}
};

void() babe_pain2 = [26, babe_pain3]
{
};

void() babe_pain3 = [27, babe_pain4]
{
	ai_painforward(FL_SWIM);
};

void() babe_pain4 = [28, babe_pain5]
{
	ai_painforward(1);
};

void() babe_pain5 = [29, babe_pain6]
{
};

void() babe_pain6 = [30, babe_run]
{
	ai_painforward(FL_SWIM);
};

void() babe_die1 = [31, babe_die2]
{
	ThrowGib("progs/gib1.mdl", self.health);
};

void() babe_die2 = [32, babe_die3]
{
};

void() babe_die3 = [33, babe_die4]
{
};

void() babe_die4 = [34, babe_die5]
{
};

void() babe_die5 = [35, babe_die6]
{
};

void() babe_die6 = [36, babe_die7]
{
};

void() babe_die7 = [37, babe_die8]
{
};

void() babe_die8 = [38, babe_die9]
{
};

void() babe_die9 = [39, babe_die10]
{
};

void() babe_die10 = [40, babe_die11]
{
};

void() babe_die11 = [41, babe_die12]
{
};

void() babe_die12 = [42, babe_die13]
{
};

void() babe_die13 = [43, babe_die14]
{
};

void() babe_die14 = [44, babe_die15]
{
	sound(self, CHAN_VOICE, "bazooka/stepstop.wav", 1, ATTN_IDLE);
};

void() babe_die15 = [45, babe_die16]
{
	self.solid = SOLID_NOT;
	self.ammo_rockets = FL_SWIM;
	DropBackpack();
	sound(self, CHAN_VOICE, "bazooka/dies2.wav", 1, ATTN_NORM);
};

void() babe_die16 = [46, babe_die17]
{
};

void() babe_die17 = [47, babe_die18]
{
};

void() babe_die18 = [48, babe_die19]
{
};

void() babe_die19 = [49, babe_die20]
{
};

void() babe_die20 = [50, babe_die21]
{
};

void() babe_die21 = [51, babe_die22]
{
};

void() babe_die22 = [53, babe_die22]
{
};

void() babe_die23 = [53, babe_die23]
{
};

void() babe_bpain01 = [54, babe_bpain02]
{
	ai_back(FL_SWIM);
	if (random() < 0.5)
	{
		sound(self, CHAN_VOICE, "bazooka/grrr.wav", 1, ATTN_IDLE);
	}
	else
	{
		sound(self, CHAN_VOICE, "bazooka/ahaia.wav", 1, ATTN_IDLE);
	}
};

void() babe_bpain02 = [55, babe_bpain03]
{
};

void() babe_bpain03 = [56, babe_bpain04]
{
};

void() babe_bpain04 = [57, babe_bpain05]
{
};

void() babe_bpain05 = [58, babe_bpain06]
{
};

void() babe_bpain06 = [59, babe_bpain07]
{
};

void() babe_bpain07 = [60, babe_bpain08]
{
};

void() babe_bpain08 = [61, babe_bpain09]
{
};

void() babe_bpain09 = [62, babe_bpain10]
{
};

void() babe_bpain10 = [63, babe_bpain11]
{
};

void() babe_bpain11 = [64, babe_run]
{
};

void() babe_bdeath01 = [65, babe_bdeath02]
{
};

void() babe_bdeath02 = [66, babe_bdeath03]
{
};

void() babe_bdeath03 = [67, babe_bdeath04]
{
};

void() babe_bdeath04 = [68, babe_bdeath05]
{
};

void() babe_bdeath05 = [69, babe_bdeath06]
{
};

void() babe_bdeath06 = [70, babe_bdeath07]
{
};

void() babe_bdeath07 = [71, babe_bdeath08]
{
	self.solid = SOLID_NOT;
	self.ammo_rockets = FL_SWIM;
	DropBackpack();
};

void() babe_bdeath08 = [72, babe_bdeath09]
{
};

void() babe_bdeath09 = [73, babe_bdeath10]
{
};

void() babe_bdeath10 = [74, babe_bdeath11]
{
};

void() babe_bdeath11 = [75, babe_bdeath12]
{
};

void() babe_bdeath12 = [76, babe_bdeath13]
{
};

void() babe_bdeath13 = [77, babe_bdeath14]
{
};

void() babe_bdeath14 = [78, babe_bdeath14]
{
};

void() babe_die = 
{
	if (self.health < -35)
	{
		sound(self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		ThrowHead("progs/h_babe.mdl", self.health);
		ThrowGib("progs/gib1.mdl", self.health);
		ThrowGib("progs/gib2.mdl", self.health);
		ThrowGib("progs/gib3.mdl", self.health);
		return;
	}
	if (random() < 0.5)
	{
		sound(self, CHAN_VOICE, "bazooka/dies1.wav", 1, ATTN_IDLE);
	}
	else
	{
		sound(self, CHAN_VOICE, "bazooka/dies3.wav", 1, ATTN_IDLE);
	}
	if (random() > 0.5)
	{
		babe_die1();
	}
	else
	{
		babe_bdeath01();
	}
};

void() babe_pain = 
{
	if (self.pain_finished > time)
	{
		return;
	}
	self.velocity_x = -50 - 50 * random();
	self.velocity_y = 0;
	self.velocity_z = MOVETYPE_FLY + FL_SWIM * random();
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	self.pain_finished = time + FL_SWIM - random();
	if (random() > 0.5)
	{
		babe_pain1();
	}
	else
	{
		babe_bpain01();
	}
};

void() monster_bazooka = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	self.monster_type = BAZOOKA;
	precache_model2("progs/bazooka.mdl");
	precache_model2("progs/h_babe.mdl");
	precache_model2("progs/pulse.mdl");
	precache_sound2("bazooka/step1.wav");
	precache_sound2("enforcer/enfstop.wav");
	precache_sound2("bazooka/grrr.wav");
	precache_sound2("bazooka/ahaia.wav");
	precache_sound2("bazooka/yeow.wav");
	precache_sound2("bazooka/ooaa.wav");
	precache_sound2("bazooka/when.wav");
	precache_sound2("bazooka/dies1.wav");
	precache_sound2("bazooka/dies2.wav");
	precache_sound2("bazooka/dies3.wav");
	precache_sound2("bazooka/die.wav");
	precache_sound2("bazooka/stepstop.wav");
	precache_sound2("weapons/sgun1.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/bazooka.mdl");
	setsize(self, VEC_HULL_MIN, '16 16 40');
	self.health = MIN_CHARMER_DISTANCE;
	self.th_stand = babe_stand;
	self.th_walk = babe_walk;
	self.th_run = babe_run;
	self.th_die = babe_die;
	self.th_pain = babe_pain;
	self.th_missile = babe_fire1;
	self.think = walkmonster_start;
	self.nextthink = time + 0.1 + random() * 0.1;
};

