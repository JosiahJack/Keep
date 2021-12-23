void() sknight_stand = [11, sknight_stand]
{
	ai_stand();
};

void() sknight_walk1 = [15, sknight_walk2]
{
	if (random() < 0.2)
	{
		sound(self, CHAN_VOICE, "knight/idle.wav", SPAWNFLAG_SUPERSPIKE, ATTN_IDLE);
	}
	ai_walk(AS_MELEE);
};

void() sknight_walk2 = [16, sknight_walk3]
{
	ai_walk(SPAWNFLAG_LASER);
};

void() sknight_walk3 = [17, sknight_walk4]
{
	ai_walk(AS_MELEE);
};

void() sknight_walk4 = [18, sknight_walk5]
{
	ai_walk(SECRET_1ST_DOWN);
};

void() sknight_walk5 = [19, sknight_walk6]
{
	ai_walk(AS_MELEE);
};

void() sknight_walk6 = [20, sknight_walk7]
{
	ai_walk(AS_MELEE);
};

void() sknight_walk7 = [21, sknight_walk8]
{
	ai_walk(AS_MELEE);
};

void() sknight_walk8 = [22, sknight_walk9]
{
	ai_walk(SECRET_1ST_DOWN);
};

void() sknight_walk9 = [23, sknight_walk10]
{
	ai_walk(AS_MELEE);
};

void() sknight_walk10 = [24, sknight_walk11]
{
	ai_walk(AS_MELEE);
};

void() sknight_walk11 = [25, sknight_walk12]
{
	ai_walk(SPAWNFLAG_LASER);
};

void() sknight_walk12 = [26, sknight_walk13]
{
	ai_walk(AS_MELEE);
};

void() sknight_walk13 = [27, sknight_walk14]
{
	ai_walk(SECRET_1ST_DOWN);
};

void() sknight_walk14 = [28, sknight_walk1]
{
	ai_walk(AS_MELEE);
};

void() sknight_run1 = [0, sknight_run2]
{
	if (random() < 0.2)
	{
		sound(self, CHAN_VOICE, "knight/idle.wav", SPAWNFLAG_SUPERSPIKE, ATTN_IDLE);
	}
	ai_run(SECRET_YES_SHOOT);
};

void() sknight_run2 = [1, sknight_run3]
{
	ai_run(20);
};

void() sknight_run3 = [2, sknight_run4]
{
	ai_run(13);
};

void() sknight_run4 = [3, sknight_run5]
{
	ai_run(TE_WIZSPIKE);
};

void() sknight_run5 = [4, sknight_run6]
{
	ai_run(SECRET_YES_SHOOT);
};

void() sknight_run6 = [5, sknight_run7]
{
	ai_run(20);
};

void() sknight_run7 = [6, sknight_run8]
{
	ai_run(14);
};

void() sknight_run8 = [7, sknight_run1]
{
	ai_run(TE_LIGHTNING2);
};

void() ArrowTouch = 
{
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	sound(self, CHAN_WEAPON, "bowman/a-hit.wav", SPAWNFLAG_SUPERSPIKE, SPAWNFLAG_SUPERSPIKE);
	if (other.takedamage != DAMAGE_NO)
	{
		T_Damage(other, self, self.owner, TE_LAVASPLASH);
		remove(self);
	}
	else
	{
		self.velocity = VEC_ORIGIN;
		self.movetype = MOVETYPE_NONE;
		self.touch = SUB_Null;
		self.solid = SOLID_NOT;
	}
};

void() FireBow = 
{
	local vector vec;
	local vector org;
	local float tm;
	org = self.origin + v_forward * SVC_FOUNDSECRET + v_up * TE_TELEPORT;
	vec = self.enemy.origin + '0 0 16' - (self.origin + '0 0 16');
	tm = vlen(vec) / 600;
	newmis = spawn();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLY;
	newmis.solid = SOLID_BBOX;
	vec = vec + self.enemy.velocity * tm;
	vec = normalize(vec);
	newmis.velocity = vec * 600;
	newmis.angles = vectoangles(newmis.velocity);
	newmis.touch = ArrowTouch;
	newmis.think = SUB_Remove;
	newmis.nextthink = time + SECRET_1ST_DOWN;
	setmodel(newmis, "progs/arrow.mdl");
	setsize(newmis, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(newmis, org);
	sound(self, CHAN_WEAPON, "bowman/a-fire.wav", SPAWNFLAG_SUPERSPIKE, 0.4);
	self.attack_finished = time + 0.6;
};

void() sknight_fire1 = [11, sknight_fire2]
{
	ai_face();
	if (!infront(self.enemy))
	{
		self.think = sknight_fire1;
		self.nextthink = time;
	}
};

void() sknight_fire2 = [11, sknight_fire3]
{
	ai_face();
	makevectors(self.angles);
	traceline(self.origin + v_forward * SVC_FOUNDSECRET + v_up * TE_TELEPORT, self.enemy.origin + '0 0 16', 0, self);
	if (trace_ent != self.enemy)
	{
		self.think = sknight_run1;
		self.nextthink = time;
	}
	else
	{
		FireBow();
		self.nextthink = time + 0.5;
	}
};

void() sknight_fire3 = [14, sknight_fire4]
{
	ai_face();
};

void() sknight_fire4 = [13, sknight_fire5]
{
	ai_face();
};

void() sknight_fire5 = [12, sknight_run1]
{
	ai_face();
};

void() sknight_pain1 = [8, sknight_pain2]
{
};

void() sknight_pain2 = [9, sknight_pain3]
{
};

void() sknight_pain3 = [10, sknight_run1]
{
};

void() sknight_die1 = [34, sknight_die2]
{
};

void() sknight_die2 = [35, sknight_die3]
{
};

void() sknight_die3 = [36, sknight_die4]
{
	self.solid = SOLID_NOT;
};

void() sknight_die4 = [37, sknight_die5]
{
};

void() sknight_die5 = [38, sknight_die6]
{
};

void() sknight_die6 = [39, sknight_die7]
{
};

void() sknight_die7 = [40, sknight_die8]
{
};

void() sknight_die8 = [41, sknight_die9]
{
};

void() sknight_die9 = [42, sknight_die10]
{
};

void() sknight_die10 = [43, sknight_die10]
{
};

void() sknight_dieb1 = [44, sknight_dieb2]
{
};

void() sknight_dieb2 = [45, sknight_dieb3]
{
};

void() sknight_dieb3 = [46, sknight_dieb4]
{
	self.solid = SOLID_NOT;
};

void() sknight_dieb4 = [47, sknight_dieb5]
{
};

void() sknight_dieb5 = [48, sknight_dieb6]
{
};

void() sknight_dieb6 = [49, sknight_dieb7]
{
};

void() sknight_dieb7 = [50, sknight_dieb8]
{
};

void() sknight_dieb8 = [51, sknight_dieb9]
{
};

void() sknight_dieb9 = [52, sknight_dieb10]
{
};

void() sknight_dieb10 = [53, sknight_dieb11]
{
};

void() sknight_dieb11 = [54, sknight_dieb11]
{
};

void() sknight_die = 
{
	sound(self, CHAN_VOICE, "knight/kdeath.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	if (random() < 0.5)
	{
		sknight_die1();
	}
	else
	{
		sknight_dieb1();
	}
};

void() monster_sknight = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/bowman.mdl");
	precache_model("progs/arrow.mdl");
	precache_sound("knight/kdeath.wav");
	precache_sound("knight/khurt.wav");
	precache_sound("knight/ksight.wav");
	precache_sound("knight/idle.wav");
	precache_sound("bowman/a-fire.wav");
	precache_sound("bowman/a-hit.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/bowman.mdl");
	setsize(self, VEC_HULL_MIN, '16 16 40');
	self.health = 75;
	self.th_stand = sknight_stand;
	self.th_walk = sknight_walk1;
	self.th_run = sknight_run1;
	self.th_missile = sknight_fire1;
	self.th_pain = sknight_pain1;
	self.th_die = sknight_die;
	walkmonster_start();
};

