void() dknight_stand1 = [0, dknight_stand2]
{
	ai_stand();
};

void() dknight_stand2 = [1, dknight_stand3]
{
	ai_stand();
};

void() dknight_stand3 = [2, dknight_stand4]
{
	ai_stand();
};

void() dknight_stand4 = [3, dknight_stand5]
{
	ai_stand();
};

void() dknight_stand5 = [4, dknight_stand6]
{
	ai_stand();
};

void() dknight_stand6 = [5, dknight_stand7]
{
	ai_stand();
};

void() dknight_stand7 = [6, dknight_stand8]
{
	ai_stand();
};

void() dknight_stand8 = [7, dknight_stand9]
{
	ai_stand();
};

void() dknight_stand9 = [8, dknight_stand1]
{
	ai_stand();
};

void() dknight_walk1 = [53, dknight_walk2]
{
	local float r;
	r = random();
	if (r <= 0.2)
	{
		sound(self, CHAN_VOICE, "monsters/dknight/dkidle1.wav", SPAWNFLAG_SUPERSPIKE, ATTN_IDLE);
	}
	else
	{
		if (r <= 0.4)
		{
			sound(self, CHAN_VOICE, "monsters/dknight/dkidle2.wav", SPAWNFLAG_SUPERSPIKE, ATTN_IDLE);
		}
		else
		{
			sound(self, CHAN_VOICE, "monsters/dknight/dkidle3.wav", SPAWNFLAG_SUPERSPIKE, ATTN_IDLE);
		}
	}
	ai_walk(SECRET_NO_SHOOT);
};

void() dknight_walk2 = [54, dknight_walk3]
{
	ai_walk(SPAWNFLAG_LASER);
};

void() dknight_walk3 = [55, dknight_walk4]
{
	ai_walk(AS_MELEE);
};

void() dknight_walk4 = [56, dknight_walk5]
{
	ai_walk(SECRET_1ST_DOWN);
};

void() dknight_walk5 = [57, dknight_walk6]
{
	ai_walk(AS_MELEE);
};

void() dknight_walk6 = [58, dknight_walk7]
{
	ai_walk(AS_MELEE);
};

void() dknight_walk7 = [59, dknight_walk8]
{
	ai_walk(AS_MELEE);
};

void() dknight_walk8 = [60, dknight_walk9]
{
	ai_walk(SECRET_1ST_DOWN);
};

void() dknight_walk9 = [61, dknight_walk10]
{
	ai_walk(AS_MELEE);
};

void() dknight_walk10 = [62, dknight_walk11]
{
	ai_walk(AS_MELEE);
};

void() dknight_walk11 = [63, dknight_walk12]
{
	ai_walk(SPAWNFLAG_LASER);
};

void() dknight_walk12 = [64, dknight_walk13]
{
	ai_walk(AS_MELEE);
};

void() dknight_walk13 = [65, dknight_walk14]
{
	ai_walk(SECRET_1ST_DOWN);
};

void() dknight_walk14 = [66, dknight_walk1]
{
	ai_walk(AS_MELEE);
	self.oldorigin = self.origin;
};

void() dknight_run1 = [9, dknight_run2]
{
	local float r;
	r = random();
	if (r <= 0.2)
	{
		sound(self, CHAN_VOICE, "monsters/dknight/dkidle1.wav", SPAWNFLAG_SUPERSPIKE, ATTN_IDLE);
	}
	else
	{
		if (r <= 0.4)
		{
			sound(self, CHAN_VOICE, "monsters/dknight/dkidle2.wav", SPAWNFLAG_SUPERSPIKE, ATTN_IDLE);
		}
		else
		{
			sound(self, CHAN_VOICE, "monsters/dknight/dkidle3.wav", SPAWNFLAG_SUPERSPIKE, ATTN_IDLE);
		}
	}
	ai_run(SVC_INTERMISSION);
};

void() dknight_run2 = [10, dknight_run3]
{
	ai_run(SVC_INTERMISSION);
};

void() dknight_run3 = [11, dknight_run4]
{
	ai_run(SVC_INTERMISSION);
};

void() dknight_run4 = [12, dknight_run5]
{
	ai_run(SVC_INTERMISSION);
};

void() dknight_run5 = [13, dknight_run6]
{
	ai_run(SVC_INTERMISSION);
};

void() dknight_run6 = [14, dknight_run7]
{
	ai_run(SVC_INTERMISSION);
};

void() dknight_run7 = [15, dknight_run8]
{
	ai_run(SVC_INTERMISSION);
};

void() dknight_run8 = [16, dknight_run1]
{
	ai_run(SVC_INTERMISSION);
};

void() dknight_bow1 = [17, dknight_bow2]
{
	ai_face();
	makevectors(self.angles);
	self.origin_z = self.origin_z + SPAWNFLAG_SUPERSPIKE;
	self.velocity = '0 0 200' + v_forward * 500;
	if (self.flags & FL_ONGROUND)
	{
		self.flags = self.flags - FL_ONGROUND;
	}
};

void() dknight_bow2 = [44, dknight_bow3]
{
	ai_turn();
};

void() dknight_bow3 = [45, dknight_bow4]
{
	ai_turn();
};

void() dknight_bow4 = [46, dknight_bow5]
{
	ai_turn();
};

void() dknight_bow5 = [47, dknight_bow6]
{
	ai_face();
};

void() dknight_bow6 = [48, dknight_bow7]
{
	ai_turn();
};

void() dknight_bow7 = [49, dknight_bow8]
{
	ai_turn();
};

void() dknight_bow8 = [50, dknight_bow9]
{
	ai_turn();
};

void() dknight_bow9 = [25, dknight_bow10]
{
	ai_turn();
};

void() dknight_bow10 = [26, dknight_bow11]
{
	ai_turn();
};

void() dknight_bow11 = [53, dknight_run1]
{
	ai_face();
};

void() dknight_startfire = 
{
	local vector offang;
	local vector org;
	local vector vec;
	local vector emy;
	local float rand;
	local float r;
	rand = random();
	r = random();
	org = self.origin;
	if (r >= 0.5)
	{
		emy = self.enemy.origin + v_right * (rand * 48);
	}
	else
	{
		emy = self.enemy.origin - v_right * (rand * 48);
	}
	traceline(org, emy, 1, self);
	sound(self, CHAN_WEAPON, "monsters/dknight/dklight.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_LIGHTNING2);
	WriteEntity(MSG_BROADCAST, self);
	WriteCoord(MSG_BROADCAST, org_x);
	WriteCoord(MSG_BROADCAST, org_y);
	WriteCoord(MSG_BROADCAST, org_z);
	WriteCoord(MSG_BROADCAST, trace_endpos_x);
	WriteCoord(MSG_BROADCAST, trace_endpos_y);
	WriteCoord(MSG_BROADCAST, trace_endpos_z);
	LightningDamage(org, trace_endpos, self, AS_MELEE);
	self.oldorigin = self.origin;
};

void() dknight_shoot1 = [44, dknight_shoot2]
{
	ai_face();
};

void() dknight_shoot2 = [45, dknight_shoot3]
{
	ai_face();
};

void() dknight_shoot3 = [46, dknight_shoot4]
{
	ai_face();
};

void() dknight_shoot4 = [47, dknight_shoot5]
{
	ai_face();
};

void() dknight_shoot5 = [48, dknight_shoot6]
{
	ai_face();
};

void() dknight_shoot6 = [49, dknight_shoot7]
{
	ai_face();
	dknight_startfire();
};

void() dknight_shoot7 = [50, dknight_shoot8]
{
	ai_face();
	dknight_startfire();
};

void() dknight_shoot8 = [51, dknight_shoot9]
{
	ai_face();
	dknight_startfire();
};

void() dknight_shoot9 = [52, dknight_shoot10]
{
	ai_face();
	dknight_startfire();
};

void() dknight_shoot10 = [51, dknight_shoot11]
{
	ai_face();
	dknight_startfire();
};

void() dknight_shoot11 = [52, dknight_shoot12]
{
	ai_face();
	dknight_startfire();
};

void() dknight_shoot12 = [53, dknight_run1]
{
	ai_face();
};

void() dknight_runatk1 = [17, dknight_runatk2]
{
	ai_charge(20);
};

void() dknight_runatk2 = [18, dknight_runatk3]
{
	ai_charge_side();
};

void() dknight_runatk3 = [19, dknight_runatk4]
{
	ai_charge_side();
};

void() dknight_runatk4 = [20, dknight_runatk5]
{
	ai_charge_side();
};

void() dknight_runatk5 = [21, dknight_runatk6]
{
	local float r;
	r = random();
	if (r < 0.5)
	{
		sound(self, CHAN_BODY, "monsters/dknight/dkswzap1.wav", SPAWNFLAG_SUPERSPIKE, ATTN_IDLE);
	}
	else
	{
		sound(self, CHAN_BODY, "monsters/dknight/dkswzap2.wav", SPAWNFLAG_SUPERSPIKE, ATTN_IDLE);
	}
	ai_melee_side();
};

void() dknight_runatk6 = [22, dknight_runatk7]
{
	ai_melee_side();
};

void() dknight_runatk7 = [23, dknight_runatk8]
{
	ai_melee_side();
};

void() dknight_runatk8 = [24, dknight_runatk9]
{
	ai_melee_side();
};

void() dknight_runatk9 = [25, dknight_runatk10]
{
	ai_melee_side();
};

void() dknight_runatk10 = [26, dknight_runatk11]
{
	ai_charge_side();
};

void() dknight_runatk11 = [27, dknight_run1]
{
	ai_charge(TE_LAVASPLASH);
};

void() dknight_atk1 = [42, dknight_atk2]
{
	ai_charge(MSG_BROADCAST);
};

void() dknight_atk2 = [44, dknight_atk3]
{
	ai_charge(TE_WIZSPIKE);
};

void() dknight_atk3 = [45, dknight_atk4]
{
	ai_charge(SECRET_1ST_DOWN);
};

void() dknight_atk4 = [46, dknight_atk5]
{
	ai_charge(MSG_BROADCAST);
};

void() dknight_atk5 = [47, dknight_atk6]
{
	local float r;
	r = random();
	if (r < 0.5)
	{
		sound(self, CHAN_BODY, "monsters/dknight/dkswzap1.wav", SPAWNFLAG_SUPERSPIKE, ATTN_IDLE);
	}
	else
	{
		sound(self, CHAN_BODY, "monsters/dknight/dkswzap2.wav", SPAWNFLAG_SUPERSPIKE, ATTN_IDLE);
	}
	ai_charge(AS_MELEE);
};

void() dknight_atk6 = [48, dknight_atk7]
{
	ai_charge(SECRET_1ST_DOWN);
	ai_melee();
};

void() dknight_atk7 = [49, dknight_atk8]
{
	ai_charge(SPAWNFLAG_SUPERSPIKE);
	ai_melee();
};

void() dknight_atk8 = [50, dknight_atk9]
{
	ai_charge(AS_MELEE);
	ai_melee();
};

void() dknight_atk9 = [51, dknight_atk10]
{
	ai_charge(SPAWNFLAG_SUPERSPIKE);
};

void() dknight_atk10 = [52, dknight_run1]
{
	ai_charge(TE_LIGHTNING1);
};

void() dknight_pain1 = [28, dknight_pain2]
{
};

void() dknight_pain2 = [29, dknight_pain3]
{
};

void() dknight_pain3 = [30, dknight_run1]
{
};

void() dknight_painb1 = [31, dknight_painb2]
{
	ai_painforward(MSG_BROADCAST);
};

void() dknight_painb2 = [32, dknight_painb3]
{
	ai_painforward(AS_MELEE);
};

void() dknight_painb3 = [33, dknight_painb4]
{
};

void() dknight_painb4 = [34, dknight_painb5]
{
};

void() dknight_painb5 = [35, dknight_painb6]
{
	ai_painforward(SPAWNFLAG_LASER);
};

void() dknight_painb6 = [36, dknight_painb7]
{
	ai_painforward(SECRET_1ST_DOWN);
};

void() dknight_painb7 = [37, dknight_painb8]
{
	ai_painforward(SPAWNFLAG_LASER);
};

void() dknight_painb8 = [38, dknight_painb9]
{
	ai_painforward(TE_LIGHTNING1);
};

void() dknight_painb9 = [39, dknight_painb10]
{
	ai_painforward(TE_LIGHTNING1);
};

void() dknight_painb10 = [40, dknight_painb11]
{
	ai_painforward(MSG_BROADCAST);
};

void() dknight_painb11 = [41, dknight_run1]
{
};

void(entity attacker, float damage) dknight_pain = 
{
	local float r;
	self.oldorigin = self.origin;
	if (self.pain_finished > time)
	{
		return;
	}
	r = random();
	if (r <= 0.5)
	{
		sound(self, CHAN_VOICE, "monsters/dknight/dkhurt1.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	}
	else
	{
		sound(self, CHAN_VOICE, "monsters/dknight/dkhurt2.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	}
	if (r < 0.85)
	{
		dknight_pain1();
		self.pain_finished = time + SPAWNFLAG_SUPERSPIKE;
	}
	else
	{
		dknight_painb1();
		self.pain_finished = time + SPAWNFLAG_SUPERSPIKE;
	}
};

void() dknight_die1 = [76, dknight_die2]
{
};

void() dknight_die2 = [77, dknight_die3]
{
};

void() dknight_die3 = [78, dknight_die4]
{
	self.solid = SOLID_NOT;
};

void() dknight_die4 = [79, dknight_die5]
{
};

void() dknight_die5 = [80, dknight_die6]
{
};

void() dknight_die6 = [81, dknight_die7]
{
};

void() dknight_die7 = [82, dknight_die8]
{
};

void() dknight_die8 = [83, dknight_die9]
{
};

void() dknight_die9 = [84, dknight_die10]
{
};

void() dknight_die10 = [85, dknight_die10]
{
	CorpseThink();
};

void() dknight_dieb1 = [86, dknight_dieb2]
{
};

void() dknight_dieb2 = [87, dknight_dieb3]
{
};

void() dknight_dieb3 = [88, dknight_dieb4]
{
	self.solid = SOLID_NOT;
};

void() dknight_dieb4 = [89, dknight_dieb5]
{
};

void() dknight_dieb5 = [90, dknight_dieb6]
{
};

void() dknight_dieb6 = [91, dknight_dieb7]
{
};

void() dknight_dieb7 = [92, dknight_dieb8]
{
};

void() dknight_dieb8 = [93, dknight_dieb9]
{
};

void() dknight_dieb9 = [94, dknight_dieb10]
{
};

void() dknight_dieb10 = [95, dknight_dieb11]
{
};

void() dknight_dieb11 = [96, dknight_dieb11]
{
	CorpseThink();
};

void() dknight_die = 
{
	local float r;
	if (self.health < -40)
	{
		sound(self, CHAN_ITEM, "player/udeath.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
		ThrowHead("progs/h_dkni.mdl", self.health);
		ThrowGib("progs/gib1.mdl", self.health);
		ThrowGib("progs/gib2.mdl", self.health);
		ThrowGib("progs/gib3.mdl", self.health);
		return;
	}
	r = random();
	if (r <= 0.5)
	{
		sound(self, CHAN_ITEM, "monsters/dknight/dkdeath1.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	}
	else
	{
		sound(self, CHAN_ITEM, "monsters/dknight/dkdeath2.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	}
	if (random() < 0.5)
	{
		dknight_die1();
	}
	else
	{
		dknight_dieb1();
	}
};

void() dknightattack = 
{
	if (random() < 0.25)
	{
		sound(self, CHAN_WEAPON, "shalrath/attack2.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
		dknight_bow1();
	}
	else
	{
		sound(self, CHAN_WEAPON, "monsters/dknight/dkzap.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
		dknight_shoot1();
	}
};

void() monster_dknight = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model2("progs/dknight.mdl");
	precache_model2("progs/h_dkni.mdl");
	precache_sound2("monsters/dknight/dksight1.wav");
	precache_sound2("monsters/dknight/dksight2.wav");
	precache_sound2("monsters/dknight/dksight3.wav");
	precache_sound2("monsters/dknight/dklight.wav");
	precache_sound2("monsters/dknight/dkidle1.wav");
	precache_sound2("monsters/dknight/dkidle2.wav");
	precache_sound2("monsters/dknight/dkidle3.wav");
	precache_sound2("monsters/dknight/dkhurt1.wav");
	precache_sound2("monsters/dknight/dkhurt2.wav");
	precache_sound2("monsters/dknight/dkdeath1.wav");
	precache_sound2("monsters/dknight/dkdeath2.wav");
	precache_sound2("monsters/dknight/dkzap.wav");
	precache_sound2("monsters/dknight/dkswzap1.wav");
	precache_sound2("monsters/dknight/dkswzap2.wav");
	precache_sound2("shalrath/attack2.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/dknight.mdl");
	setsize(self, VEC_HULL_MIN, '16 16 40');
	self.health = 200;
	self.th_stand = dknight_stand1;
	self.th_walk = dknight_walk1;
	self.th_run = dknight_run1;
	self.th_melee = dknight_atk1;
	self.th_pain = dknight_pain;
	self.th_die = dknight_die;
	self.th_missile = dknightattack;
	walkmonster_start();
};

void() CheckdknightMelee = 
{
	if (enemy_range == RANGE_MELEE)
	{
		self.attack_state = AS_MELEE;
		return 1;
	}
	return 0;
};

