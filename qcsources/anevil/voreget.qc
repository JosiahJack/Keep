void() vore_stand1 = [0, vore_stand2]
{
	ai_stand();
};

void() vore_stand2 = [1, vore_stand3]
{
	ai_stand();
};

void() vore_stand3 = [2, vore_stand4]
{
	ai_stand();
};

void() vore_stand4 = [3, vore_stand5]
{
	ai_stand();
};

void() vore_stand5 = [4, vore_stand6]
{
	ai_stand();
};

void() vore_stand6 = [5, vore_stand7]
{
	ai_stand();
};

void() vore_stand7 = [6, vore_stand8]
{
	ai_stand();
};

void() vore_stand8 = [7, vore_stand1]
{
	ai_stand();
};

void() vore_walk1 = [90, vore_walk2]
{
	if (random() < 0.2)
	{
		sound(self, CHAN_VOICE, "voreget/idle.wav", SPAWN_CRUCIFIED, ATTN_IDLE);
	}
	ai_walk(SPAWN_CRUCIFIED);
};

void() vore_walk2 = [91, vore_walk3]
{
	ai_walk(SPAWN_CRUCIFIED);
};

void() vore_walk3 = [92, vore_walk4]
{
	ai_walk(SPAWN_CRUCIFIED);
};

void() vore_walk4 = [93, vore_walk5]
{
	ai_walk(SPAWN_CRUCIFIED);
};

void() vore_walk5 = [94, vore_walk6]
{
	ai_walk(SPAWN_LYINGDOWN);
};

void() vore_walk6 = [95, vore_walk7]
{
	ai_walk(IQ_HIGH);
};

void() vore_walk7 = [96, vore_walk8]
{
	ai_walk(SPAWN_SAC);
};

void() vore_walk8 = [97, vore_walk9]
{
	ai_walk(SPAWN_SAC);
};

void() vore_walk9 = [98, vore_walk10]
{
	ai_walk(SPAWN_LYINGDOWN);
};

void() vore_walk10 = [99, vore_walk11]
{
	ai_walk(SPAWN_LYINGDOWN);
};

void() vore_walk11 = [100, vore_walk12]
{
	ai_walk(SPAWN_LYINGDOWN);
};

void() vore_walk12 = [101, vore_walk13]
{
	ai_walk(SPAWN_CRUCIFIED);
};

void() vore_walk13 = [102, vore_walk14]
{
	ai_walk(MSG_BROADCAST);
};

void() vore_walk14 = [103, vore_walk15]
{
	ai_walk(SPAWN_CRUCIFIED);
};

void() vore_walk15 = [104, vore_walk16]
{
	ai_walk(SPAWN_CRUCIFIED);
};

void() vore_walk16 = [105, vore_walk17]
{
	ai_walk(SPAWN_CRUCIFIED);
};

void() vore_walk17 = [106, vore_walk18]
{
	ai_walk(IQ_HIGH);
};

void() vore_walk18 = [107, vore_walk19]
{
	ai_walk(IQ_HIGH);
};

void() vore_walk19 = [108, vore_walk20]
{
	ai_walk(IQ_HIGH);
};

void() vore_walk20 = [109, vore_walk21]
{
	ai_walk(IQ_HIGH);
};

void() vore_walk21 = [110, vore_walk22]
{
	ai_walk(SPAWN_LYINGDOWN);
};

void() vore_walk22 = [111, vore_walk23]
{
	ai_walk(SPAWN_CRUCIFIED);
};

void() vore_walk23 = [112, vore_walk24]
{
	ai_walk(SPAWN_CRUCIFIED);
};

void() vore_walk24 = [113, vore_walk1]
{
	ai_walk(SPAWN_CRUCIFIED);
};

void() vore_run1 = [73, vore_run2]
{
	if (random() < 0.2)
	{
		sound(self, CHAN_VOICE, "voreget/idle.wav", SPAWN_CRUCIFIED, ATTN_IDLE);
	}
	ai_run(STAT_TOTALSECRETS);
};

void() vore_run2 = [74, vore_run3]
{
	ai_run(15);
};

void() vore_run3 = [75, vore_run4]
{
	ai_run(SVC_SETVIEWANGLES);
};

void() vore_run4 = [76, vore_run5]
{
	ai_run(SVC_SETVIEWANGLES);
};

void() vore_run5 = [77, vore_run6]
{
	ai_run(SPAWN_CUT);
};

void() vore_run6 = [78, vore_run7]
{
	ai_run(15);
};

void() vore_run7 = [79, vore_run8]
{
	ai_run(SVC_SETVIEWANGLES);
};

void() vore_run8 = [80, vore_run1]
{
	ai_run(SPAWN_CUT);
};

void() vore_atk1 = [81, vore_atk2]
{
	sound(self, CHAN_VOICE, "voreget/attack.wav", SPAWN_CRUCIFIED, ATTN_NORM);
	ai_face();
};

void() vore_atk2 = [82, vore_atk3]
{
	ai_face();
};

void() vore_atk3 = [83, vore_atk4]
{
	ai_face();
};

void() vore_atk4 = [84, vore_atk5]
{
	ai_face();
};

void() vore_atk5 = [85, vore_atk6]
{
	ai_face();
	VoreMissile();
};

void() vore_atk6 = [86, vore_atk7]
{
	ai_face();
};

void() vore_atk7 = [87, vore_atk8]
{
	ai_face();
	SUB_CheckRefire(vore_atk1);
};

void() vore_atk8 = [88, vore_atk9]
{
	ai_face();
};

void() vore_atk9 = [89, vore_run1]
{
	ai_face();
};

void() vore_pain1 = [40, vore_pain2]
{
};

void() vore_pain2 = [41, vore_pain3]
{
};

void() vore_pain3 = [42, vore_pain4]
{
};

void() vore_pain4 = [43, vore_pain5]
{
};

void() vore_pain5 = [44, vore_pain6]
{
};

void() vore_pain6 = [45, vore_run1]
{
	ai_pain(SPAWN_CRUCIFIED);
};

void() vore_painb1 = [46, vore_painb2]
{
};

void() vore_painb2 = [47, vore_painb3]
{
	ai_painforward(13);
};

void() vore_painb3 = [48, vore_painb4]
{
	ai_painforward(TE_LIGHTNING3);
};

void() vore_painb4 = [49, vore_painb5]
{
};

void() vore_painb5 = [50, vore_painb6]
{
};

void() vore_painb6 = [51, vore_painb7]
{
};

void() vore_painb7 = [52, vore_painb8]
{
};

void() vore_painb8 = [53, vore_painb9]
{
};

void() vore_painb9 = [54, vore_painb10]
{
};

void() vore_painb10 = [55, vore_painb11]
{
};

void() vore_painb11 = [56, vore_painb12]
{
};

void() vore_painb12 = [57, vore_painb13]
{
	ai_pain(SPAWN_LYINGDOWN);
};

void() vore_painb13 = [58, vore_painb14]
{
};

void() vore_painb14 = [59, vore_run1]
{
};

void() vore_painc1 = [60, vore_painc2]
{
};

void() vore_painc2 = [61, vore_painc3]
{
	ai_pain(SPAWN_CRUCIFIED);
};

void() vore_painc3 = [62, vore_painc4]
{
};

void() vore_painc4 = [63, vore_painc5]
{
};

void() vore_painc5 = [64, vore_painc6]
{
	ai_painforward(SPAWN_CRUCIFIED);
};

void() vore_painc6 = [65, vore_painc7]
{
	ai_painforward(SPAWN_CRUCIFIED);
};

void() vore_painc7 = [66, vore_painc8]
{
};

void() vore_painc8 = [67, vore_painc9]
{
	ai_pain(SPAWN_CRUCIFIED);
};

void() vore_painc9 = [68, vore_painc10]
{
	ai_painforward(SPAWN_SAC);
};

void() vore_painc10 = [69, vore_painc11]
{
	ai_painforward(IQ_HIGH);
};

void() vore_painc11 = [70, vore_painc12]
{
	ai_painforward(TE_LIGHTNING2);
};

void() vore_painc12 = [71, vore_painc13]
{
	ai_painforward(SPAWN_CUT);
};

void() vore_painc13 = [72, vore_run1]
{
};

void() vore_die1 = [8, vore_die2]
{
};

void() vore_die2 = [9, vore_die3]
{
};

void() vore_die3 = [10, vore_die4]
{
	self.solid = SOLID_NOT;
	self.ammo_cells = IQ_ULTIMATE;
	DropBackpack();
};

void() vore_die4 = [11, vore_die5]
{
};

void() vore_die5 = [12, vore_die6]
{
};

void() vore_die6 = [13, vore_die7]
{
};

void() vore_die7 = [14, vore_die8]
{
};

void() vore_die8 = [15, vore_die9]
{
};

void() vore_die9 = [16, vore_die10]
{
};

void() vore_die10 = [17, vore_die10]
{
};

void() vore_cdie1 = [18, vore_cdie2]
{
};

void() vore_cdie2 = [19, vore_cdie3]
{
	ai_back(IQ_ULTIMATE);
};

void() vore_cdie3 = [20, vore_cdie4]
{
	self.solid = SOLID_NOT;
	self.ammo_cells = IQ_ULTIMATE;
	DropBackpack();
	ai_back(SPAWN_SAC);
};

void() vore_cdie4 = [21, vore_cdie5]
{
	ai_back(13);
};

void() vore_cdie5 = [22, vore_cdie6]
{
	ai_back(IQ_HIGH);
};

void() vore_cdie6 = [23, vore_cdie7]
{
	ai_back(SPAWN_SAC);
};

void() vore_cdie7 = [24, vore_cdie8]
{
};

void() vore_cdie8 = [25, vore_cdie9]
{
};

void() vore_cdie9 = [26, vore_cdie10]
{
};

void() vore_cdie10 = [27, vore_cdie11]
{
};

void() vore_cdie11 = [28, vore_cdie11]
{
};

void(entity attacker, float damage) vore_pain = 
{
	if (self.pain_finished > time)
	{
		return;
	}
	sound(self, CHAN_VOICE, "voreget/pain.wav", SPAWN_CRUCIFIED, ATTN_NORM);
	vore_pain1();
	self.pain_finished = time + IQ_HIGH;
};

void() vore_die = 
{
	if (self.health < -50)
	{
		sound(self, CHAN_VOICE, "player/udeath.wav", SPAWN_CRUCIFIED, ATTN_NORM);
		ThrowHead("progs/h_vore.mdl", self.health, self.skin);
		ThrowGib("progs/gib1.mdl", self.health);
		ThrowGib("progs/gib2.mdl", self.health);
		ThrowGib("progs/gib3.mdl", self.health);
		self.health = self.health * 2.5;
		ThrowGib("progs/gib1.mdl", self.health);
		ThrowGib("progs/gib2.mdl", self.health);
		ThrowGib("progs/gib3.mdl", self.health);
		return;
	}
	sound(self, CHAN_VOICE, "voreget/death.wav", SPAWN_CRUCIFIED, ATTN_NORM);
	vore_die1();
	if (random() < 0.5)
	{
		vore_die1();
	}
	else
	{
		vore_cdie1();
	}
};

void() VoreMissile = 
{
	local entity missile;
	local entity mpuff;
	local vector dir;
	local float dist;
	local float flytime;
	dir = normalize(self.enemy.origin + '0 0 10' - self.origin);
	dist = vlen(self.enemy.origin - self.origin);
	flytime = dist * 0.002000;
	if (flytime < 0.1)
	{
		flytime = 0.1;
	}
	self.effects = self.effects | EF_MUZZLEFLASH;
	sound(self, CHAN_WEAPON, "voreget/attack2.wav", SPAWN_CRUCIFIED, ATTN_NORM);
	if (self.skin == SPAWN_CRUCIFIED)
	{
		self.punchangle_x = CONTENT_SOLID;
	}
	missile = spawn();
	missile.owner = self;
	missile.solid = SOLID_BBOX;
	missile.movetype = MOVETYPE_FLYMISSILE;
	if (self.skin == SPAWN_CRUCIFIED)
	{
		setmodel(missile, "progs/lavaball.mdl");
	}
	else
	{
		setmodel(missile, "progs/v_spike.mdl");
	}
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	missile.origin = self.origin + '0 0 10';
	missile.velocity = dir * 400;
	if (self.skin == SPAWN_CRUCIFIED)
	{
		missile.avelocity = '100 200 300';
	}
	else
	{
		missile.avelocity = '300 300 300';
	}
	missile.nextthink = flytime + time;
	missile.think = VoreHome;
	missile.enemy = self.enemy;
	missile.touch = VoreMissileTouch;
};

void() VoreHome = 
{
	local vector dir;
	local vector vtemp;
	vtemp = self.enemy.origin + '0 0 10';
	if (self.enemy.health < SPAWN_CRUCIFIED)
	{
		remove(self);
		return;
	}
	dir = normalize(vtemp - self.origin);
	if (skill == IQ_HIGH)
	{
		self.velocity = dir * MAX_CHARMER_DISTANCE;
	}
	else
	{
		self.velocity = dir * 50;
	}
	if (skill == IQ_HIGH)
	{
		self.nextthink = time + 0.2;
	}
	else
	{
		self.nextthink = time + 0.4;
	}
	self.think = VoreHome;
};

void() VoreMissileTouch = 
{
	if (other == self.owner)
	{
		return;
	}
	if (other.classname == "monster_zombie")
	{
		T_Damage(other, self, self, 110);
	}
	if (self.skin == SPAWN_CRUCIFIED)
	{
		T_RadiusDamage(self, self.owner, 35, world);
		sound(self, CHAN_WEAPON, "player/inlava.wav", SPAWN_CRUCIFIED, ATTN_NORM);
		self.origin = self.origin - SPAWN_CUT * normalize(self.velocity);
		WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte(MSG_BROADCAST, TE_LAVASPLASH);
		WriteCoord(MSG_BROADCAST, self.origin_x);
		WriteCoord(MSG_BROADCAST, self.origin_y);
		WriteCoord(MSG_BROADCAST, self.origin_z);
		remove(self);
	}
	else
	{
		T_RadiusDamage(self, self.owner, 35, world);
		sound(self, CHAN_WEAPON, "weapons/r_exp3.wav", SPAWN_CRUCIFIED, ATTN_NORM);
		WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte(MSG_BROADCAST, TE_EXPLOSION);
		WriteCoord(MSG_BROADCAST, self.origin_x);
		WriteCoord(MSG_BROADCAST, self.origin_y);
		WriteCoord(MSG_BROADCAST, self.origin_z);
		self.velocity = VEC_ORIGIN;
		self.touch = SUB_Null;
		setmodel(self, "progs/s_explod.spr");
		self.solid = SOLID_NOT;
		s_explode1();
	}
};

void() monster_voreget = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/voreget.mdl");
	precache_model2("progs/h_vore.mdl");
	precache_model2("progs/v_spike.mdl");
	precache_model2("progs/lavaball.mdl");
	precache_sound2("voreget/attack.wav");
	precache_sound2("voreget/attack2.wav");
	precache_sound2("voreget/death.wav");
	precache_sound2("voreget/idle.wav");
	precache_sound2("voreget/pain.wav");
	precache_sound2("voreget/sight.wav");
	precache_sound2("player/inlava.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/voreget.mdl");
	if (!(self.skin))
	{
		self.skin = MSG_BROADCAST;
	}
	setsize(self, VEC_HULL_MIN, '16 16 40');
	if (!(self.health))
	{
		self.health = MIN_CHARMER_DISTANCE;
	}
	self.th_stand = vore_stand1;
	self.th_walk = vore_walk1;
	self.th_run = vore_run1;
	self.th_missile = vore_atk1;
	self.th_pain = vore_pain;
	self.th_die = vore_die;
	self.think = walkmonster_start;
	self.nextthink = time + 0.1 + random() * 0.1;
};

