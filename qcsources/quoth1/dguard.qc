void() dguard_hit = 
{
	if (vlen(self.enemy.origin - self.origin) > 100)
	{
		if (random() < 0.5)
		{
			sound(self, CHAN_WEAPON, "dguard/slmiss1.wav", LIGHTNING_RANDOM, ATTN_NORM);
		}
		else
		{
			sound(self, CHAN_WEAPON, "dguard/slmiss2.wav", LIGHTNING_RANDOM, ATTN_NORM);
		}
		return;
	}
	sound(self, CHAN_WEAPON, "dguard/slhit.wav", LIGHTNING_RANDOM, ATTN_NORM);
	T_Damage(self.enemy, self, self, SVC_INTERMISSION);
};

void() dguard_slash1 = [79, dguard_slash2]
{
	sound(self, CHAN_VOICE, "dguard/slash.wav", LIGHTNING_RANDOM, ATTN_NORM);
	ai_face();
	ai_forward(LIGHTNING_RANDOM);
};

void() dguard_slash2 = [80, dguard_slash3]
{
	ai_face();
	ai_forward(LIGHTNING_RANDOM);
};

void() dguard_slash3 = [81, dguard_slash4]
{
	ai_face();
	ai_forward(LIGHTNING_RANDOM);
};

void() dguard_slash4 = [82, dguard_slash5]
{
	ai_face();
	ai_forward(LIGHTNING_RANDOM);
};

void() dguard_slash5 = [83, dguard_slash6]
{
	ai_face();
	ai_forward(LIGHTNING_RANDOM);
};

void() dguard_slash6 = [84, dguard_slash7]
{
	ai_face();
	ai_forward(LIGHTNING_RANDOM);
};

void() dguard_slash7 = [85, dguard_slash8]
{
	ai_face();
	ai_forward(LIGHTNING_RANDOM);
};

void() dguard_slash8 = [86, dguard_slash9]
{
	ai_face();
	ai_forward(LIGHTNING_RANDOM);
};

void() dguard_slash9 = [87, dguard_slash10]
{
	ai_face();
	ai_forward(LIGHTNING_RANDOM);
};

void() dguard_slash10 = [88, dguard_slash11]
{
	ai_face();
	dguard_hit();
	ai_forward(LIGHTNING_RANDOM);
};

void() dguard_slash11 = [89, dguard_slash12]
{
	ai_face();
};

void() dguard_slash12 = [90, dguard_slash13]
{
	ai_face();
};

void() dguard_slash13 = [91, dguard_slash14]
{
	ai_face();
};

void() dguard_slash14 = [92, dguard_run1]
{
	ai_face();
};

void(float dmgamount) dg_slice = 
{
	if (vlen(self.enemy.origin - self.origin) > 100)
	{
		return;
	}
	T_Damage(self.enemy, self, self, dmgamount);
};

void() dguard_charge1 = [106, dguard_charge2]
{
	ai_charge(24);
	if (random() < 0.5)
	{
		sound(self, CHAN_VOICE, "knight/sword1.wav", LIGHTNING_RANDOM, ATTN_NORM);
	}
	else
	{
		sound(self, CHAN_VOICE, "knight/sword2.wav", LIGHTNING_RANDOM, ATTN_NORM);
	}
};

void() dguard_charge2 = [107, dguard_charge3]
{
	ai_charge(SVC_SPAWNSTATICSOUND);
};

void() dguard_charge3 = [108, dguard_charge4]
{
	ai_charge(22);
};

void() dguard_charge4 = [109, dguard_charge5]
{
	ai_charge(20);
	dg_slice(LIGHTNING_RANDOM);
};

void() dguard_charge5 = [110, dguard_charge6]
{
	ai_charge(18);
	dg_slice(AS_MELEE);
};

void() dguard_charge6 = [111, dguard_run1]
{
	ai_charge(20);
	dg_slice(LIGHTNING_BOOM);
};

void() dguard_slowcharge1 = [112, dguard_slowcharge2]
{
	ai_charge(TE_BEAM);
	if (random() < 0.5)
	{
		sound(self, CHAN_VOICE, "knight/sword1.wav", LIGHTNING_RANDOM, ATTN_NORM);
	}
	else
	{
		sound(self, CHAN_VOICE, "knight/sword2.wav", LIGHTNING_RANDOM, ATTN_NORM);
	}
};

void() dguard_slowcharge2 = [113, dguard_slowcharge3]
{
	ai_charge(14);
};

void() dguard_slowcharge3 = [114, dguard_slowcharge4]
{
	ai_charge(19);
};

void() dguard_slowcharge4 = [115, dguard_slowcharge5]
{
	ai_charge(17);
};

void() dguard_slowcharge5 = [116, dguard_slowcharge6]
{
	ai_charge(TE_EXPLOSION2);
	dg_slice(LIGHTNING_BOOM);
};

void() dguard_slowcharge6 = [117, dguard_slowcharge7]
{
	ai_charge(SECRET_NO_SHOOT);
	dg_slice(SECRET_1ST_DOWN);
};

void() dguard_slowcharge7 = [118, dguard_slowcharge8]
{
	ai_charge(TE_LAVASPLASH);
	dg_slice(LIGHTNING_BOOM);
};

void() dguard_slowcharge8 = [119, dguard_slowcharge9]
{
	ai_charge(AS_LOITER);
};

void() dguard_slowcharge9 = [120, dguard_slowcharge10]
{
	ai_charge(AS_MELEE);
};

void() dguard_slowcharge10 = [121, dguard_run1]
{
	ai_charge(LIGHTNING_BOOM);
};

void() dg_fireball_touch = 
{
	local vector org;
	if (other == self.owner)
	{
		return;
	}
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	org = self.origin - SECRET_NO_SHOOT * normalize(self.velocity);
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord(MSG_BROADCAST, org_x);
	WriteCoord(MSG_BROADCAST, org_y);
	WriteCoord(MSG_BROADCAST, org_z);
	sound(self, CHAN_VOICE, "dguard/hit.wav", LIGHTNING_RANDOM, ATTN_NORM);
	T_RadiusDamage(self, self.owner, 40, other);
	T_Damage(other, self, self.owner, SVC_KILLEDMONSTER + LIGHTNING_BOOM * random());
	if (other.classname != "player")
	{
		if (other.classname == "monster_zombie")
		{
			T_Damage(other, self, self.owner, 120);
		}
	}
	remove(self);
};

void() dguard_shot = 
{
	local vector offang;
	local vector org;
	local vector vec;
	local vector d;
	local float t;
	local vector spot1;
	local vector spot2;
	local entity targ;
	local float chance;
	local float dgdist;
	targ = self.enemy;
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;
	traceline(spot1, spot2, 0, self);
	if (trace_ent != targ)
	{
		self.think = self.th_run;
		return;
	}
	newmis = spawn();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLY;
	newmis.solid = SOLID_BBOX;
	org = self.origin + '0 0 24';
	setmodel(newmis, "progs/fireball.mdl");
	setsize(newmis, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(newmis, org);
	if (visible(self.enemy))
	{
		vec = self.enemy.origin - '0 0 16' + self.enemy.velocity * MSG_BROADCAST;
		vec = normalize(vec - org);
	}
	else
	{
		vec = self.oldenemyorigin - '0 0 16';
		vec = normalize(vec - org);
	}
	newmis.velocity = vec * 900;
	newmis.angles = vectoangles(newmis.velocity);
	newmis.nextthink = time + AS_BLINDFIRE;
	newmis.think = SUB_Remove;
	newmis.touch = dg_fireball_touch;
	newmis.classname = "dguardfireball";
};

void() dguard_fire1 = [93, dguard_fire2]
{
	ai_shotcheck();
	sound(self, CHAN_VOICE, "dguard/fire.wav", LIGHTNING_RANDOM, ATTN_NORM);
	ai_face();
};

void() dguard_fire2 = [94, dguard_fire3]
{
	ai_shotcheck();
	ai_face();
};

void() dguard_fire3 = [95, dguard_fire4]
{
	ai_shotcheck();
	ai_face();
};

void() dguard_fire4 = [96, dguard_fire5]
{
	ai_shotcheck();
	ai_face();
};

void() dguard_fire5 = [97, dguard_fire6]
{
	ai_shotcheck();
	ai_face();
};

void() dguard_fire6 = [98, dguard_fire7]
{
	ai_shotcheck();
	ai_face();
};

void() dguard_fire7 = [99, dguard_fire8]
{
	ai_shotcheck();
	ai_face();
};

void() dguard_fire8 = [100, dguard_fire9]
{
	ai_shotcheck();
	ai_face();
};

void() dguard_fire9 = [101, dguard_fire10]
{
	ai_shotcheck();
	ai_face();
	dguard_shot();
};

void() dguard_fire10 = [102, dguard_fire11]
{
	ai_face();
};

void() dguard_fire11 = [103, dguard_fire12]
{
	ai_face();
};

void() dguard_fire12 = [104, dguard_fire13]
{
	ai_face();
};

void() dguard_fire13 = [105, dguard_run1]
{
	ai_face();
};

void() dguard_stand1 = [0, dguard_stand2]
{
	ai_stand();
};

void() dguard_stand2 = [1, dguard_stand3]
{
	ai_stand();
};

void() dguard_stand3 = [2, dguard_stand4]
{
	ai_stand();
};

void() dguard_stand4 = [3, dguard_stand5]
{
	ai_stand();
};

void() dguard_stand5 = [4, dguard_stand6]
{
	ai_stand();
};

void() dguard_stand6 = [5, dguard_stand7]
{
	ai_stand();
};

void() dguard_stand7 = [6, dguard_stand8]
{
	ai_stand();
};

void() dguard_stand8 = [7, dguard_stand9]
{
	ai_stand();
};

void() dguard_stand9 = [8, dguard_stand1]
{
	ai_stand();
};

void() dguard_walk1 = [9, dguard_walk2]
{
	dguard_idle_sound();
	ai_walk(LIGHTNING_BOOM);
};

void() dguard_walk2 = [10, dguard_walk3]
{
	ai_walk(AS_BLINDFIRE);
};

void() dguard_walk3 = [11, dguard_walk4]
{
	ai_walk(AS_BLINDFIRE);
};

void() dguard_walk4 = [12, dguard_walk5]
{
	ai_walk(SECRET_1ST_DOWN);
};

void() dguard_walk5 = [13, dguard_walk6]
{
	ai_walk(SECRET_1ST_DOWN);
};

void() dguard_walk6 = [14, dguard_walk7]
{
	ai_walk(LIGHTNING_BOOM);
};

void() dguard_walk7 = [15, dguard_walk8]
{
	ai_walk(LIGHTNING_BOOM);
};

void() dguard_walk8 = [16, dguard_walk9]
{
	ai_walk(AS_MELEE);
};

void() dguard_walk9 = [17, dguard_walk10]
{
	ai_walk(AS_MELEE);
};

void() dguard_walk10 = [18, dguard_walk11]
{
	ai_walk(SECRET_1ST_DOWN);
};

void() dguard_walk11 = [19, dguard_walk12]
{
	ai_walk(AS_MELEE);
};

void() dguard_walk12 = [20, dguard_walk13]
{
	ai_walk(SECRET_1ST_DOWN);
};

void() dguard_walk13 = [21, dguard_walk14]
{
	ai_walk(AS_LOITER);
};

void() dguard_walk14 = [22, dguard_walk15]
{
	ai_walk(LIGHTNING_BOOM);
};

void() dguard_walk15 = [23, dguard_walk16]
{
	ai_walk(LIGHTNING_BOOM);
};

void() dguard_walk16 = [24, dguard_walk17]
{
	ai_walk(SECRET_1ST_DOWN);
};

void() dguard_walk17 = [25, dguard_walk18]
{
	ai_walk(AS_MELEE);
};

void() dguard_walk18 = [26, dguard_walk19]
{
	ai_walk(AS_MELEE);
};

void() dguard_walk19 = [27, dguard_walk20]
{
	ai_walk(AS_MELEE);
};

void() dguard_walk20 = [28, dguard_walk1]
{
	ai_walk(LIGHTNING_BOOM);
};

void() dguard_run1 = [29, dguard_run2]
{
	dguard_idle_sound();
	ai_run(24);
};

void() dguard_run2 = [30, dguard_run3]
{
	ai_run(SVC_SPAWNSTATICSOUND);
};

void() dguard_run3 = [31, dguard_run4]
{
	ai_run(22);
};

void() dguard_run4 = [32, dguard_run5]
{
	ai_run(20);
};

void() dguard_run5 = [33, dguard_run6]
{
	ai_run(18);
};

void() dguard_run6 = [34, dguard_run7]
{
	ai_run(SVC_SPAWNSTATICSOUND);
};

void() dguard_run7 = [35, dguard_run8]
{
	ai_run(25);
};

void() dguard_run8 = [36, dguard_run1]
{
	ai_run(17);
};

void() dguard_pain1 = [37, dguard_pain2]
{
	sound(self, CHAN_VOICE, "dguard/pain1.wav", LIGHTNING_RANDOM, ATTN_NORM);
};

void() dguard_pain2 = [38, dguard_pain3]
{
};

void() dguard_pain3 = [39, dguard_pain4]
{
};

void() dguard_pain4 = [40, dguard_pain5]
{
};

void() dguard_pain5 = [41, dguard_run1]
{
};

void() dguard_die1 = [42, dguard_die2]
{
	ai_forward(TE_LAVASPLASH);
	sound(self, CHAN_VOICE, "dguard/death2.wav", LIGHTNING_RANDOM, ATTN_NORM);
};

void() dguard_die2 = [43, dguard_die3]
{
	ai_forward(SECRET_NO_SHOOT);
};

void() dguard_die3 = [44, dguard_die4]
{
	self.solid = SOLID_NOT;
	ai_forward(TE_WIZSPIKE);
};

void() dguard_die4 = [45, dguard_die5]
{
};

void() dguard_die5 = [46, dguard_die6]
{
	self.nextthink = time + 0.2;
};

void() dguard_die6 = [47, dguard_die7]
{
	self.nextthink = time + 0.2;
};

void() dguard_die7 = [48, dguard_die8]
{
	self.nextthink = time + 0.2;
};

void() dguard_die8 = [49, dguard_die9]
{
	ai_forward(TE_LAVASPLASH);
};

void() dguard_die9 = [50, dguard_die10]
{
	ai_forward(TE_TELEPORT);
};

void() dguard_die10 = [51, dguard_die11]
{
};

void() dguard_die11 = [52, dguard_die12]
{
};

void() dguard_die12 = [53, monster_fade]
{
	self.nextthink = time + 0.1;
};

void() dguard_dieb1 = [54, dguard_dieb2]
{
	sound(self, CHAN_VOICE, "dguard/death1.wav", LIGHTNING_RANDOM, ATTN_NORM);
};

void() dguard_dieb2 = [55, dguard_dieb3]
{
};

void() dguard_dieb3 = [56, dguard_dieb4]
{
	self.solid = SOLID_NOT;
};

void() dguard_dieb4 = [57, dguard_dieb5]
{
};

void() dguard_dieb5 = [58, dguard_dieb6]
{
};

void() dguard_dieb6 = [59, dguard_dieb7]
{
};

void() dguard_dieb7 = [60, dguard_dieb8]
{
};

void() dguard_dieb8 = [61, dguard_dieb9]
{
};

void() dguard_dieb9 = [62, monster_fade]
{
	self.nextthink = time + 0.1;
};

void() dguard_die = 
{
	if (self.health < -50)
	{
		sound(self, CHAN_VOICE, "player/udeath.wav", LIGHTNING_RANDOM, ATTN_NORM);
		ThrowHead("progs/h_dguard.mdl", self.health);
		ThrowGib("progs/gib1.mdl", self.health);
		ThrowGib("progs/gib2.mdl", self.health);
		ThrowGib("progs/gib3.mdl", self.health);
		return;
	}
	if (random() > 0.5)
	{
		dguard_die1();
	}
	else
	{
		dguard_dieb1();
	}
};

void() dguard_idle_sound = 
{
	if (random() < 0.2)
	{
		sound(self, CHAN_VOICE, "dguard/idle.wav", LIGHTNING_RANDOM, ATTN_NORM);
	}
};

void(entity attacker, float damage) dguard_pain = 
{
	if (self.pain_finished > time)
	{
		return;
	}
	if (random() > 0.5)
	{
		sound(self, CHAN_VOICE, "dguard/pain1.wav", LIGHTNING_RANDOM, ATTN_NORM);
	}
	else
	{
		sound(self, CHAN_VOICE, "dguard/pain2.wav", LIGHTNING_RANDOM, ATTN_NORM);
	}
	if (random() * SVC_INTERMISSION > damage)
	{
		return;
	}
	self.pain_finished = time + AS_BLINDFIRE;
	dguard_pain1();
};

void() dguard_melee = 
{
	dguard_slash1();
};

void() dguard_start = 
{
	local vector org;
	if (!(self.spawnflags & TRIGGER_SPAWNSILENT))
	{
		org = self.origin + SECRET_YES_SHOOT * v_forward;
		spawn_tfog(org);
	}
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/dguard.mdl");
	setsize(self, VEC_HULL_MIN, '16 16 40');
	self.health = 200;
	monster_spawn();
	walkmonster_start_go();
};

void() dguard_begin = 
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
	self.think = dguard_start;
};

void() monster_deathguard = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/dguard.mdl");
	precache_model("progs/fireball.mdl");
	precache_model("progs/h_dguard.mdl");
	precache_sound("dguard/fire.wav");
	precache_sound("dguard/death1.wav");
	precache_sound("dguard/death2.wav");
	precache_sound("dguard/pain1.wav");
	precache_sound("dguard/pain2.wav");
	precache_sound("dguard/sight1.wav");
	precache_sound("dguard/sight2.wav");
	precache_sound("dguard/sight3.wav");
	precache_sound("dguard/sight4.wav");
	precache_sound("dguard/hit.wav");
	precache_sound("dguard/slash.wav");
	precache_sound("knight/sword1.wav");
	precache_sound("knight/sword2.wav");
	precache_sound("dguard/slhit.wav");
	precache_sound("dguard/slmiss1.wav");
	precache_sound("dguard/slmiss2.wav");
	precache_sound("dguard/idle.wav");
	self.class = "hellknight";
	self.th_stand = dguard_stand1;
	self.th_walk = dguard_walk1;
	self.th_run = dguard_run1;
	self.th_melee = dguard_slash1;
	self.th_missile = dguard_fire1;
	self.th_pain = dguard_pain;
	self.th_die = dguard_die;
	if (self.spawnflags & TRIGGER_SPAWN)
	{
		self.use = dguard_begin;
		total_monsters = total_monsters + LIGHTNING_RANDOM;
		return;
	}
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/dguard.mdl");
	setsize(self, VEC_HULL_MIN, '16 16 40');
	self.health = 200;
	walkmonster_start();
};

void() monster_death_guard = 
{
	self.classname = "monster_deathguard";
	monster_deathguard();
	return;
};

float() DGuardCheckAttack = 
{
	local vector spot1;
	local vector spot2;
	local entity targ;
	local float chance;
	local float dgdist;
	targ = self.enemy;
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;
	traceline(spot1, spot2, 0, self);
	if (trace_ent != targ)
	{
		return 0;
	}
	if (trace_inopen && trace_inwater)
	{
		return 0;
	}
	dgdist = vlen(self.enemy.origin - self.origin);
	if (dgdist < 100)
	{
		self.th_melee();
		return 1;
	}
	else
	{
		if (dgdist < 190 && dgdist > 140)
		{
			dguard_charge1();
			return 1;
		}
	}
	if (time < self.attack_finished)
	{
		return 0;
	}
	if (enemy_range == RANGE_FAR)
	{
		return 0;
	}
	if (dgdist < 300)
	{
		return 0;
	}
	else
	{
		if (dgdist >= 300)
		{
			chance = 0.5;
		}
	}
	if (random() < chance)
	{
		self.th_missile();
		SUB_AttackFinished(1.4 * random() + 0.8);
		return 1;
	}
	return 0;
};

