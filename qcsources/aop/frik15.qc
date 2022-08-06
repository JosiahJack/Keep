void() lenforcer_fire = 
{
	local vector org;
	local vector dir;
	self.effects = self.effects | EF_MUZZLEFLASH;
	ai_face();
	sound(self, CHAN_WEAPON, "weapons/light2/lghit2.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	org = self.origin + '0 0 12' - v_right * SECRET_NO_SHOOT;
	dir = self.enemy.origin + '0 0 16' - org;
	dir = normalize(dir);
	traceline(org, self.origin + dir * 350, 1, self);
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_LIGHTNING2);
	WriteEntity(MSG_BROADCAST, self);
	WriteCoord(MSG_BROADCAST, org_x);
	WriteCoord(MSG_BROADCAST, org_y);
	WriteCoord(MSG_BROADCAST, org_z);
	WriteCoord(MSG_BROADCAST, trace_endpos_x);
	WriteCoord(MSG_BROADCAST, trace_endpos_y);
	WriteCoord(MSG_BROADCAST, trace_endpos_z);
	LightningDamage(self.origin, trace_endpos + v_forward * SECRET_1ST_DOWN, self, AS_MELEE);
};

void() lenf_stand1 = [0, lenf_stand2]
{
	ai_stand();
};

void() lenf_stand2 = [1, lenf_stand3]
{
	ai_stand();
};

void() lenf_stand3 = [2, lenf_stand4]
{
	ai_stand();
};

void() lenf_stand4 = [3, lenf_stand5]
{
	ai_stand();
};

void() lenf_stand5 = [4, lenf_stand6]
{
	ai_stand();
};

void() lenf_stand6 = [5, lenf_stand7]
{
	ai_stand();
};

void() lenf_stand7 = [6, lenf_stand1]
{
	ai_stand();
};

void() lenf_walk1 = [7, lenf_walk2]
{
	if (random() < 0.2)
	{
		sound(self, CHAN_AUTO, "monsters/lenforce/leidle1.wav", SPAWNFLAG_SUPERSPIKE, ATTN_IDLE);
	}
	ai_walk(SPAWNFLAG_LASER);
};

void() lenf_walk2 = [8, lenf_walk3]
{
	ai_walk(SECRET_1ST_DOWN);
};

void() lenf_walk3 = [9, lenf_walk4]
{
	ai_walk(SECRET_1ST_DOWN);
};

void() lenf_walk4 = [10, lenf_walk5]
{
	ai_walk(AS_MELEE);
};

void() lenf_walk5 = [11, lenf_walk6]
{
	ai_walk(SPAWNFLAG_SUPERSPIKE);
};

void() lenf_walk6 = [12, lenf_walk7]
{
	ai_walk(SPAWNFLAG_LASER);
};

void() lenf_walk7 = [13, lenf_walk8]
{
	ai_walk(SPAWNFLAG_LASER);
};

void() lenf_walk8 = [14, lenf_walk9]
{
	ai_walk(SPAWNFLAG_SUPERSPIKE);
};

void() lenf_walk9 = [15, lenf_walk10]
{
	ai_walk(SPAWNFLAG_LASER);
};

void() lenf_walk10 = [16, lenf_walk11]
{
	ai_walk(SECRET_1ST_DOWN);
};

void() lenf_walk11 = [17, lenf_walk12]
{
	ai_walk(SECRET_1ST_DOWN);
};

void() lenf_walk12 = [18, lenf_walk13]
{
	ai_walk(SPAWNFLAG_SUPERSPIKE);
};

void() lenf_walk13 = [19, lenf_walk14]
{
	ai_walk(SPAWNFLAG_LASER);
};

void() lenf_walk14 = [20, lenf_walk15]
{
	ai_walk(AS_MELEE);
};

void() lenf_walk15 = [21, lenf_walk16]
{
	ai_walk(SECRET_1ST_DOWN);
};

void() lenf_walk16 = [22, lenf_walk1]
{
	ai_walk(SPAWNFLAG_LASER);
};

void() lenf_run1 = [23, lenf_run2]
{
	if (random() < 0.2)
	{
		sound(self, CHAN_AUTO, "monsters/lenforce/leidle1.wav", SPAWNFLAG_SUPERSPIKE, ATTN_IDLE);
	}
	ai_run(18);
};

void() lenf_run2 = [24, lenf_run3]
{
	ai_run(14);
};

void() lenf_run3 = [25, lenf_run4]
{
	ai_run(TE_WIZSPIKE);
};

void() lenf_run4 = [26, lenf_run5]
{
	ai_run(12);
};

void() lenf_run5 = [27, lenf_run6]
{
	ai_run(14);
};

void() lenf_run6 = [28, lenf_run7]
{
	ai_run(14);
};

void() lenf_run7 = [29, lenf_run8]
{
	ai_run(TE_WIZSPIKE);
};

void() lenf_run8 = [30, lenf_run1]
{
	ai_run(TE_TELEPORT);
};

void() lenf_atk1 = [31, lenf_atk2]
{
	ai_face();
};

void() lenf_atk2 = [32, lenf_atk3]
{
	ai_face();
};

void() lenf_atk3 = [33, lenf_atk4]
{
	ai_face();
};

void() lenf_atk4 = [34, lenf_atk5]
{
	ai_face();
};

void() lenf_atk5 = [35, lenf_atk6]
{
	ai_face();
};

void() lenf_atk6 = [36, lenf_atk7]
{
	lenforcer_fire();
};

void() lenf_atk7 = [37, lenf_atk8]
{
	lenforcer_fire();
};

void() lenf_atk8 = [38, lenf_atk9]
{
	lenforcer_fire();
};

void() lenf_atk9 = [35, lenf_atk10]
{
	lenforcer_fire();
};

void() lenf_atk10 = [36, lenf_atk11]
{
	lenforcer_fire();
};

void() lenf_atk11 = [37, lenf_atk12]
{
	ai_face();
};

void() lenf_atk12 = [38, lenf_atk13]
{
	ai_face();
};

void() lenf_atk13 = [39, lenf_atk14]
{
	ai_face();
};

void() lenf_atk14 = [40, lenf_run1]
{
	ai_face();
	SUB_CheckRefire(lenf_atk1);
};

void() lenf_paina1 = [66, lenf_paina2]
{
};

void() lenf_paina2 = [67, lenf_paina3]
{
};

void() lenf_paina3 = [68, lenf_paina4]
{
};

void() lenf_paina4 = [69, lenf_run1]
{
};

void() lenf_painb1 = [70, lenf_painb2]
{
};

void() lenf_painb2 = [71, lenf_painb3]
{
};

void() lenf_painb3 = [72, lenf_painb4]
{
};

void() lenf_painb4 = [73, lenf_painb5]
{
};

void() lenf_painb5 = [74, lenf_run1]
{
};

void() lenf_painc1 = [75, lenf_painc2]
{
};

void() lenf_painc2 = [76, lenf_painc3]
{
};

void() lenf_painc3 = [77, lenf_painc4]
{
};

void() lenf_painc4 = [78, lenf_painc5]
{
};

void() lenf_painc5 = [79, lenf_painc6]
{
};

void() lenf_painc6 = [80, lenf_painc7]
{
};

void() lenf_painc7 = [81, lenf_painc8]
{
};

void() lenf_painc8 = [82, lenf_run1]
{
};

void() lenf_paind1 = [83, lenf_paind2]
{
};

void() lenf_paind2 = [84, lenf_paind3]
{
};

void() lenf_paind3 = [85, lenf_paind4]
{
};

void() lenf_paind4 = [86, lenf_paind5]
{
	ai_painforward(SPAWNFLAG_LASER);
};

void() lenf_paind5 = [87, lenf_paind6]
{
	ai_painforward(SPAWNFLAG_SUPERSPIKE);
};

void() lenf_paind6 = [88, lenf_paind7]
{
};

void() lenf_paind7 = [89, lenf_paind8]
{
};

void() lenf_paind8 = [90, lenf_paind9]
{
};

void() lenf_paind9 = [91, lenf_paind10]
{
};

void() lenf_paind10 = [92, lenf_paind11]
{
};

void() lenf_paind11 = [93, lenf_paind12]
{
	ai_painforward(SPAWNFLAG_SUPERSPIKE);
};

void() lenf_paind12 = [94, lenf_paind13]
{
	ai_painforward(SPAWNFLAG_SUPERSPIKE);
};

void() lenf_paind13 = [95, lenf_paind14]
{
	ai_painforward(SPAWNFLAG_SUPERSPIKE);
};

void() lenf_paind14 = [96, lenf_paind15]
{
};

void() lenf_paind15 = [97, lenf_paind16]
{
};

void() lenf_paind16 = [98, lenf_paind17]
{
	ai_pain(SPAWNFLAG_SUPERSPIKE);
};

void() lenf_paind17 = [99, lenf_paind18]
{
	ai_pain(SPAWNFLAG_SUPERSPIKE);
};

void() lenf_paind18 = [100, lenf_paind19]
{
};

void() lenf_paind19 = [101, lenf_run1]
{
};

void(entity attacker, float damage) lenf_pain = 
{
	local float r;
	r = random();
	if (self.pain_finished > time)
	{
		return;
	}
	if (r < 0.2)
	{
		sound(self, CHAN_BODY, "monsters/lenforce/lepain1.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
		lenf_paina1();
		self.pain_finished = time + SPAWNFLAG_SUPERSPIKE;
	}
	else
	{
		if (r < 0.4)
		{
			sound(self, CHAN_BODY, "monsters/lenforce/lepain2.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
			lenf_painb1();
			self.pain_finished = time + SPAWNFLAG_SUPERSPIKE;
		}
		else
		{
			if (r < 0.7)
			{
				sound(self, CHAN_BODY, "monsters/lenforce/lepain3.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
				lenf_painc1();
				self.pain_finished = time + SPAWNFLAG_SUPERSPIKE;
			}
			else
			{
				sound(self, CHAN_BODY, "monsters/lenforce/lepain4.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
				lenf_paind1();
				self.pain_finished = time + SPAWNFLAG_LASER;
			}
		}
	}
};

void() lenf_die1 = [41, lenf_die2]
{
};

void() lenf_die2 = [42, lenf_die3]
{
};

void() lenf_die3 = [43, lenf_die4]
{
	self.solid = SOLID_NOT;
	self.ammo_cells = TE_LIGHTNING1;
	DropBackpack();
};

void() lenf_die4 = [44, lenf_die5]
{
	ai_forward(14);
};

void() lenf_die5 = [45, lenf_die6]
{
	ai_forward(SPAWNFLAG_LASER);
};

void() lenf_die6 = [46, lenf_die7]
{
};

void() lenf_die7 = [47, lenf_die8]
{
};

void() lenf_die8 = [48, lenf_die9]
{
};

void() lenf_die9 = [49, lenf_die10]
{
	ai_forward(AS_MELEE);
};

void() lenf_die10 = [50, lenf_die11]
{
	ai_forward(TE_LIGHTNING1);
};

void() lenf_die11 = [51, lenf_die12]
{
	ai_forward(TE_LIGHTNING1);
};

void() lenf_die12 = [52, lenf_die13]
{
	ai_forward(TE_LIGHTNING1);
};

void() lenf_die13 = [53, lenf_die14]
{
};

void() lenf_die14 = [54, lenf_die14]
{
	CorpseThink();
};

void() lenf_fdie1 = [55, lenf_fdie2]
{
};

void() lenf_fdie2 = [56, lenf_fdie3]
{
};

void() lenf_fdie3 = [57, lenf_fdie4]
{
	self.solid = SOLID_NOT;
	self.ammo_cells = TE_LIGHTNING1;
	DropBackpack();
};

void() lenf_fdie4 = [58, lenf_fdie5]
{
};

void() lenf_fdie5 = [59, lenf_fdie6]
{
};

void() lenf_fdie6 = [60, lenf_fdie7]
{
};

void() lenf_fdie7 = [61, lenf_fdie8]
{
};

void() lenf_fdie8 = [62, lenf_fdie9]
{
};

void() lenf_fdie9 = [63, lenf_fdie10]
{
};

void() lenf_fdie10 = [64, lenf_fdie11]
{
};

void() lenf_fdie11 = [65, lenf_fdie11]
{
	CorpseThink();
};

void() lenf_die = 
{
	if (self.health < -35)
	{
		sound(self, CHAN_VOICE, "player/udeath.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
		ThrowHead("progs/h_mega.mdl", self.health);
		ThrowGib("progs/gib1.mdl", self.health);
		ThrowGib("progs/gib2.mdl", self.health);
		ThrowGib("progs/gib3.mdl", self.health);
		return;
	}
	if (random() > 0.5)
	{
		sound(self, CHAN_AUTO, "monsters/lenforce/ledeath1.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
		lenf_die1();
	}
	else
	{
		sound(self, CHAN_AUTO, "monsters/lenforce/ledeath2.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
		lenf_fdie1();
	}
};

void() monster_lenforcer = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/enforcer.mdl");
	precache_model("progs/h_mega.mdl");
	precache_sound("monsters/lenforce/ledeath1.wav");
	precache_sound("monsters/lenforce/ledeath2.wav");
	precache_sound("monsters/lenforce/leidle1.wav");
	precache_sound("monsters/lenforce/lepain1.wav");
	precache_sound("monsters/lenforce/lepain2.wav");
	precache_sound("monsters/lenforce/lepain3.wav");
	precache_sound("monsters/lenforce/lepain4.wav");
	precache_sound("monsters/lenforce/lesight1.wav");
	precache_sound("monsters/lenforce/lesight2.wav");
	precache_sound("monsters/lenforce/lesight3.wav");
	precache_sound("monsters/lenforce/lesight4.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/enforcer.mdl");
	setsize(self, VEC_HULL_MIN, '16 16 40');
	self.health = 120;
	self.th_stand = lenf_stand1;
	self.th_walk = lenf_walk1;
	self.th_run = lenf_run1;
	self.th_pain = lenf_pain;
	self.th_die = lenf_die;
	self.th_missile = lenf_atk1;
	walkmonster_start();
};

void() monster_x = 
{
	remove(self);
	return;
};

