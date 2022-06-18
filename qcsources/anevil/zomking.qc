void() zombie_standk1 = [0, zombie_standk2]
{
	ai_stand();
};

void() zombie_standk2 = [1, zombie_standk3]
{
	ai_stand();
};

void() zombie_standk3 = [2, zombie_standk4]
{
	ai_stand();
};

void() zombie_standk4 = [3, zombie_standk5]
{
	ai_stand();
};

void() zombie_standk5 = [4, zombie_standk6]
{
	ai_stand();
};

void() zombie_standk6 = [5, zombie_standk7]
{
	ai_stand();
};

void() zombie_standk7 = [6, zombie_standk8]
{
	ai_stand();
};

void() zombie_standk8 = [7, zombie_standk9]
{
	ai_stand();
};

void() zombie_standk9 = [8, zombie_standk10]
{
	ai_stand();
};

void() zombie_standk10 = [9, zombie_standk11]
{
	ai_stand();
};

void() zombie_standk11 = [10, zombie_standk12]
{
	ai_stand();
};

void() zombie_standk12 = [11, zombie_standk13]
{
	ai_stand();
};

void() zombie_standk13 = [12, zombie_standk14]
{
	ai_stand();
};

void() zombie_standk14 = [13, zombie_standk15]
{
	ai_stand();
};

void() zombie_standk15 = [14, zombie_standk1]
{
	ai_stand();
};

void() zombie_walkk1 = [15, zombie_walkk2]
{
	ai_walk(MSG_BROADCAST);
};

void() zombie_walkk2 = [16, zombie_walkk3]
{
	ai_walk(SPAWN_LYINGDOWN);
};

void() zombie_walkk3 = [17, zombie_walkk4]
{
	ai_walk(IQ_HIGH);
};

void() zombie_walkk4 = [18, zombie_walkk5]
{
	ai_walk(SPAWN_LYINGDOWN);
};

void() zombie_walkk5 = [19, zombie_walkk6]
{
	ai_walk(SPAWN_CRUCIFIED);
};

void() zombie_walkk6 = [20, zombie_walkk7]
{
	ai_walk(MSG_BROADCAST);
};

void() zombie_walkk7 = [21, zombie_walkk8]
{
	ai_walk(MSG_BROADCAST);
};

void() zombie_walkk8 = [22, zombie_walkk9]
{
	ai_walk(MSG_BROADCAST);
};

void() zombie_walkk9 = [23, zombie_walkk10]
{
	ai_walk(MSG_BROADCAST);
};

void() zombie_walkk10 = [24, zombie_walkk11]
{
	ai_walk(MSG_BROADCAST);
};

void() zombie_walkk11 = [25, zombie_walkk12]
{
	ai_walk(SPAWN_LYINGDOWN);
};

void() zombie_walkk12 = [26, zombie_walkk13]
{
	ai_walk(SPAWN_LYINGDOWN);
};

void() zombie_walkk13 = [27, zombie_walkk14]
{
	ai_walk(SPAWN_CRUCIFIED);
};

void() zombie_walkk14 = [28, zombie_walkk15]
{
	ai_walk(MSG_BROADCAST);
};

void() zombie_walkk15 = [29, zombie_walkk16]
{
	ai_walk(MSG_BROADCAST);
};

void() zombie_walkk16 = [30, zombie_walkk17]
{
	ai_walk(MSG_BROADCAST);
};

void() zombie_walkk17 = [31, zombie_walkk18]
{
	ai_walk(MSG_BROADCAST);
};

void() zombie_walkk18 = [32, zombie_walkk19]
{
	ai_walk(MSG_BROADCAST);
};

void() zombie_walkk19 = [33, zombie_walkk1]
{
	ai_walk(MSG_BROADCAST);
	if (random() < 0.2)
	{
		sound(self, CHAN_VOICE, "zombie/z_idle.wav", SPAWN_CRUCIFIED, ATTN_IDLE);
	}
};

void() zombie_runk1 = [34, zombie_runk2]
{
	ai_run(SPAWN_CRUCIFIED);
	self.inpain = MSG_BROADCAST;
};

void() zombie_runk2 = [35, zombie_runk3]
{
	ai_run(SPAWN_CRUCIFIED);
};

void() zombie_runk3 = [36, zombie_runk4]
{
	ai_run(MSG_BROADCAST);
};

void() zombie_runk4 = [37, zombie_runk5]
{
	ai_run(SPAWN_CRUCIFIED);
};

void() zombie_runk5 = [38, zombie_runk6]
{
	ai_run(SPAWN_LYINGDOWN);
};

void() zombie_runk6 = [39, zombie_runk7]
{
	ai_run(IQ_HIGH);
};

void() zombie_runk7 = [40, zombie_runk8]
{
	ai_run(SPAWN_SAC);
};

void() zombie_runk8 = [41, zombie_runk9]
{
	ai_run(SPAWN_SAC);
};

void() zombie_runk9 = [42, zombie_runk10]
{
	ai_run(SPAWN_LYINGDOWN);
};

void() zombie_runk10 = [43, zombie_runk11]
{
	ai_run(MSG_BROADCAST);
};

void() zombie_runk11 = [44, zombie_runk12]
{
	ai_run(MSG_BROADCAST);
};

void() zombie_runk12 = [45, zombie_runk13]
{
	ai_run(MSG_BROADCAST);
};

void() zombie_runk13 = [46, zombie_runk14]
{
	ai_run(SPAWN_LYINGDOWN);
};

void() zombie_runk14 = [47, zombie_runk15]
{
	ai_run(SPAWN_SAC);
};

void() zombie_runk15 = [48, zombie_runk16]
{
	ai_run(TE_LIGHTNING2);
};

void() zombie_runk16 = [49, zombie_runk17]
{
	ai_run(TE_WIZSPIKE);
};

void() zombie_runk17 = [50, zombie_runk18]
{
	ai_run(IQ_HIGH);
};

void() zombie_runk18 = [51, zombie_runk1]
{
	ai_run(SPAWN_CUT);
	if (random() < 0.2)
	{
		sound(self, CHAN_VOICE, "zombie/z_idle.wav", SPAWN_CRUCIFIED, ATTN_IDLE);
	}
	if (random() > 0.8)
	{
		sound(self, CHAN_VOICE, "zombie/z_idle1.wav", SPAWN_CRUCIFIED, ATTN_IDLE);
	}
};

void() ZombieKGrenadeTouch = 
{
	local float gribs;
	if (other == self.owner)
	{
		return;
	}
	gribs = BURN_TIME;
	if (skill == SPAWN_LYINGDOWN)
	{
		gribs = 40;
	}
	if (skill == IQ_HIGH)
	{
		gribs = 40;
	}
	T_RadiusDamage(self, self.owner, gribs, self.owner);
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord(MSG_BROADCAST, self.origin_x);
	WriteCoord(MSG_BROADCAST, self.origin_y);
	WriteCoord(MSG_BROADCAST, self.origin_z);
	BecomeExplosion();
	return;
	if (other.takedamage)
	{
		T_Damage(other, self, self.owner, SVC_SETVIEWANGLES);
		sound(self, CHAN_WEAPON, "zombie/z_hit.wav", SPAWN_CRUCIFIED, ATTN_NORM);
		remove(self);
		return;
	}
	sound(self, CHAN_WEAPON, "zombie/z_miss.wav", SPAWN_CRUCIFIED, ATTN_NORM);
	self.velocity = VEC_ORIGIN;
	self.avelocity = VEC_ORIGIN;
	self.touch = SUB_Remove;
};

void(vector st) ZombieKFireGrenade = 
{
	local entity missile;
	local entity mpuff;
	local vector org;
	local float dist;
	local float fly;
	local float airtime;
	local vector move;
	local vector spot;
	sound(self, CHAN_WEAPON, "zombie/z_shot1.wav", SPAWN_CRUCIFIED, ATTN_NORM);
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	org = self.origin + st_x * v_forward + st_y * v_right + (st_z - 24) * v_up;
	makevectors(self.angles);
	dist = vlen(self.enemy.origin - self.origin);
	airtime = dist / 600;
	move = self.enemy.velocity;
	move_z = MSG_BROADCAST;
	spot = self.enemy.origin + airtime * move;
	if (vlen(spot - self.origin) < dist)
	{
		spot = self.enemy.origin + airtime * move * 0.7;
	}
	else
	{
		if (vlen(spot - self.origin) > dist)
		{
			spot = self.enemy.origin + airtime * move * 1.2;
		}
	}
	if (skill > SPAWN_CRUCIFIED)
	{
		missile.velocity = normalize(spot - org);
	}
	else
	{
		missile.velocity = normalize(self.enemy.origin - org);
	}
	missile.velocity = missile.velocity * 600;
	dist = vlen(spot - org);
	fly = PM_GrenadeFly(dist);
	missile.velocity_z = missile.velocity_z + fly;
	missile.avelocity = '3000 1000 2000';
	missile.touch = ZombieKGrenadeTouch;
	missile.nextthink = time + 2.5;
	missile.think = SUB_Remove;
	setmodel(missile, "progs/zom_gib.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, org);
};

void() zombie_attak1 = [52, zombie_attak2]
{
	ai_face();
};

void() zombie_attak2 = [53, zombie_attak3]
{
	ai_face();
};

void() zombie_attak3 = [54, zombie_attak4]
{
	ai_face();
};

void() zombie_attak4 = [55, zombie_attak5]
{
	ai_face();
};

void() zombie_attak5 = [56, zombie_attak6]
{
	ai_face();
};

void() zombie_attak6 = [57, zombie_attak7]
{
	ai_face();
};

void() zombie_attak7 = [58, zombie_attak8]
{
	ai_face();
};

void() zombie_attak8 = [59, zombie_attak9]
{
	ai_face();
};

void() zombie_attak9 = [60, zombie_attak10]
{
	ai_face();
};

void() zombie_attak10 = [61, zombie_attak11]
{
	ai_face();
};

void() zombie_attak11 = [62, zombie_attak12]
{
	ai_face();
};

void() zombie_attak12 = [63, zombie_attak13]
{
	ai_face();
};

void() zombie_attak13 = [64, zombie_runk1]
{
	ai_face();
	ZombieKFireGrenade('-10 -22 30');
};

void() zombie_attbk1 = [65, zombie_attbk2]
{
	ai_face();
};

void() zombie_attbk2 = [66, zombie_attbk3]
{
	ai_face();
};

void() zombie_attbk3 = [67, zombie_attbk4]
{
	ai_face();
};

void() zombie_attbk4 = [68, zombie_attbk5]
{
	ai_face();
};

void() zombie_attbk5 = [69, zombie_attbk6]
{
	ai_face();
};

void() zombie_attbk6 = [70, zombie_attbk7]
{
	ai_face();
};

void() zombie_attbk7 = [71, zombie_attbk8]
{
	ai_face();
};

void() zombie_attbk8 = [72, zombie_attbk9]
{
	ai_face();
};

void() zombie_attbk9 = [73, zombie_attbk10]
{
	ai_face();
};

void() zombie_attbk10 = [74, zombie_attbk11]
{
	ai_face();
};

void() zombie_attbk11 = [75, zombie_attbk12]
{
	ai_face();
};

void() zombie_attbk12 = [76, zombie_attbk13]
{
	ai_face();
};

void() zombie_attbk13 = [77, zombie_attbk14]
{
	ai_face();
};

void() zombie_attbk14 = [77, zombie_runk1]
{
	ai_face();
	ZombieKFireGrenade('-10 -24 29');
};

void() zombie_attck1 = [79, zombie_attck2]
{
	ai_face();
};

void() zombie_attck2 = [80, zombie_attck3]
{
	ai_face();
};

void() zombie_attck3 = [81, zombie_attck4]
{
	ai_face();
};

void() zombie_attck4 = [82, zombie_attck5]
{
	ai_face();
};

void() zombie_attck5 = [83, zombie_attck6]
{
	ai_face();
};

void() zombie_attck6 = [84, zombie_attck7]
{
	ai_face();
};

void() zombie_attck7 = [85, zombie_attck8]
{
	ai_face();
};

void() zombie_attck8 = [86, zombie_attck9]
{
	ai_face();
};

void() zombie_attck9 = [87, zombie_attck10]
{
	ai_face();
};

void() zombie_attck10 = [88, zombie_attck11]
{
	ai_face();
};

void() zombie_attck11 = [89, zombie_attck12]
{
	ai_face();
};

void() zombie_attck12 = [90, zombie_runk1]
{
	ai_face();
	ZombieKFireGrenade('-12 -19 29');
};

void() zombiek_missile = 
{
	local float r;
	r = random();
	if (r < 0.3)
	{
		zombie_attak1();
	}
	else
	{
		if (r < 0.6)
		{
			zombie_attbk1();
		}
		else
		{
			zombie_attck1();
		}
	}
};

void() zombie_painak1 = [91, zombie_painak2]
{
	sound(self, CHAN_VOICE, "zombie/z_pain.wav", SPAWN_CRUCIFIED, ATTN_NORM);
};

void() zombie_painak2 = [92, zombie_painak3]
{
	ai_painforward(IQ_HIGH);
};

void() zombie_painak3 = [93, zombie_painak4]
{
	ai_painforward(SPAWN_CRUCIFIED);
};

void() zombie_painak4 = [94, zombie_painak5]
{
	ai_pain(SPAWN_CRUCIFIED);
};

void() zombie_painak5 = [95, zombie_painak6]
{
	ai_pain(IQ_HIGH);
};

void() zombie_painak6 = [96, zombie_painak7]
{
	ai_pain(SPAWN_CRUCIFIED);
};

void() zombie_painak7 = [97, zombie_painak8]
{
};

void() zombie_painak8 = [98, zombie_painak9]
{
};

void() zombie_painak9 = [99, zombie_painak10]
{
};

void() zombie_painak10 = [100, zombie_painak11]
{
};

void() zombie_painak11 = [101, zombie_painak12]
{
};

void() zombie_painak12 = [102, zombie_runk1]
{
};

void() zombie_painbk1 = [103, zombie_painbk2]
{
	sound(self, CHAN_VOICE, "zombie/z_pain1.wav", SPAWN_CRUCIFIED, ATTN_NORM);
};

void() zombie_painbk2 = [104, zombie_painbk3]
{
	ai_pain(SPAWN_LYINGDOWN);
};

void() zombie_painbk3 = [105, zombie_painbk4]
{
	ai_pain(SPAWN_CUT);
};

void() zombie_painbk4 = [106, zombie_painbk5]
{
	ai_pain(TE_LIGHTNING2);
};

void() zombie_painbk5 = [107, zombie_painbk6]
{
	ai_pain(SPAWN_LYINGDOWN);
};

void() zombie_painbk6 = [108, zombie_painbk7]
{
};

void() zombie_painbk7 = [109, zombie_painbk8]
{
};

void() zombie_painbk8 = [110, zombie_painbk9]
{
};

void() zombie_painbk9 = [111, zombie_painbk10]
{
	sound(self, CHAN_BODY, "zombie/z_fall.wav", SPAWN_CRUCIFIED, ATTN_NORM);
};

void() zombie_painbk10 = [112, zombie_painbk11]
{
};

void() zombie_painbk11 = [113, zombie_painbk12]
{
};

void() zombie_painbk12 = [114, zombie_painbk13]
{
};

void() zombie_painbk13 = [115, zombie_painbk14]
{
};

void() zombie_painbk14 = [116, zombie_painbk15]
{
};

void() zombie_painbk15 = [117, zombie_painbk16]
{
};

void() zombie_painbk16 = [118, zombie_painbk17]
{
};

void() zombie_painbk17 = [119, zombie_painbk18]
{
};

void() zombie_painbk18 = [120, zombie_painbk19]
{
};

void() zombie_painbk19 = [121, zombie_painbk20]
{
};

void() zombie_painbk20 = [122, zombie_painbk21]
{
};

void() zombie_painbk21 = [123, zombie_painbk22]
{
};

void() zombie_painbk22 = [124, zombie_painbk23]
{
};

void() zombie_painbk23 = [125, zombie_painbk24]
{
};

void() zombie_painbk24 = [126, zombie_painbk25]
{
};

void() zombie_painbk25 = [127, zombie_painbk26]
{
	ai_painforward(SPAWN_CRUCIFIED);
};

void() zombie_painbk26 = [128, zombie_painbk27]
{
};

void() zombie_painbk27 = [129, zombie_painbk28]
{
};

void() zombie_painbk28 = [130, zombie_runk1]
{
};

void() zombie_painck1 = [131, zombie_painck2]
{
	sound(self, CHAN_VOICE, "zombie/z_pain1.wav", SPAWN_CRUCIFIED, ATTN_NORM);
};

void() zombie_painck2 = [132, zombie_painck3]
{
};

void() zombie_painck3 = [133, zombie_painck4]
{
	ai_pain(IQ_HIGH);
};

void() zombie_painck4 = [134, zombie_painck5]
{
	ai_pain(SPAWN_CRUCIFIED);
};

void() zombie_painck5 = [135, zombie_painck6]
{
};

void() zombie_painck6 = [136, zombie_painck7]
{
};

void() zombie_painck7 = [137, zombie_painck8]
{
};

void() zombie_painck8 = [138, zombie_painck9]
{
};

void() zombie_painck9 = [139, zombie_painck10]
{
};

void() zombie_painck10 = [140, zombie_painck11]
{
};

void() zombie_painck11 = [141, zombie_painck12]
{
	ai_painforward(SPAWN_CRUCIFIED);
};

void() zombie_painck12 = [142, zombie_painck13]
{
	ai_painforward(SPAWN_CRUCIFIED);
};

void() zombie_painck13 = [143, zombie_painck14]
{
};

void() zombie_painck14 = [144, zombie_painck15]
{
};

void() zombie_painck15 = [145, zombie_painck16]
{
};

void() zombie_painck16 = [146, zombie_painck17]
{
};

void() zombie_painck17 = [147, zombie_painck18]
{
};

void() zombie_painck18 = [148, zombie_runk1]
{
};

void() zombie_paindk1 = [149, zombie_paindk2]
{
	sound(self, CHAN_VOICE, "zombie/z_pain.wav", SPAWN_CRUCIFIED, ATTN_NORM);
};

void() zombie_paindk2 = [150, zombie_paindk3]
{
};

void() zombie_paindk3 = [151, zombie_paindk4]
{
};

void() zombie_paindk4 = [152, zombie_paindk5]
{
};

void() zombie_paindk5 = [153, zombie_paindk6]
{
};

void() zombie_paindk6 = [154, zombie_paindk7]
{
};

void() zombie_paindk7 = [155, zombie_paindk8]
{
};

void() zombie_paindk8 = [156, zombie_paindk9]
{
};

void() zombie_paindk9 = [157, zombie_paindk10]
{
	ai_pain(SPAWN_CRUCIFIED);
};

void() zombie_paindk10 = [158, zombie_paindk11]
{
};

void() zombie_paindk11 = [159, zombie_paindk12]
{
};

void() zombie_paindk12 = [160, zombie_paindk13]
{
};

void() zombie_paindk13 = [161, zombie_runk1]
{
};

void() zombie_painek1 = [162, zombie_painek2]
{
	sound(self, CHAN_VOICE, "zombie/z_pain.wav", SPAWN_CRUCIFIED, ATTN_NORM);
	self.health = 60;
};

void() zombie_painek2 = [163, zombie_painek3]
{
	ai_pain(SPAWN_CUT);
};

void() zombie_painek3 = [164, zombie_painek4]
{
	ai_pain(IQ_ULTIMATE);
};

void() zombie_painek4 = [165, zombie_painek5]
{
	ai_pain(IQ_HIGH);
};

void() zombie_painek5 = [166, zombie_painek6]
{
	ai_pain(SPAWN_CRUCIFIED);
};

void() zombie_painek6 = [167, zombie_painek7]
{
	ai_pain(SPAWN_LYINGDOWN);
};

void() zombie_painek7 = [168, zombie_painek8]
{
	ai_pain(SPAWN_CRUCIFIED);
};

void() zombie_painek8 = [169, zombie_painek9]
{
	ai_pain(SPAWN_CRUCIFIED);
};

void() zombie_painek9 = [170, zombie_painek10]
{
	ai_pain(SPAWN_LYINGDOWN);
};

void() zombie_painek10 = [171, zombie_painek11]
{
	sound(self, CHAN_BODY, "zombie/z_fall.wav", SPAWN_CRUCIFIED, ATTN_NORM);
	self.solid = SOLID_NOT;
};

void() zombie_painek11 = [172, zombie_painek12]
{
	self.nextthink = self.nextthink + IQ_ULTIMATE;
	self.health = MSG_BROADCAST;
};

void() zombie_painek12 = [173, zombie_painek13]
{
	self.health = 60;
	sound(self, CHAN_VOICE, "zombie/z_idle.wav", SPAWN_CRUCIFIED, ATTN_IDLE);
	self.solid = SOLID_SLIDEBOX;
	if (!walkmove(MSG_BROADCAST, MSG_BROADCAST))
	{
		self.think = zombie_painek11;
		self.solid = SOLID_NOT;
		return;
	}
};

void() zombie_painek13 = [174, zombie_painek14]
{
};

void() zombie_painek14 = [175, zombie_painek15]
{
};

void() zombie_painek15 = [176, zombie_painek16]
{
};

void() zombie_painek16 = [177, zombie_painek17]
{
};

void() zombie_painek17 = [178, zombie_painek18]
{
};

void() zombie_painek18 = [179, zombie_painek19]
{
};

void() zombie_painek19 = [180, zombie_painek20]
{
};

void() zombie_painek20 = [181, zombie_painek21]
{
};

void() zombie_painek21 = [182, zombie_painek22]
{
};

void() zombie_painek22 = [183, zombie_painek23]
{
};

void() zombie_painek23 = [184, zombie_painek24]
{
};

void() zombie_painek24 = [185, zombie_painek25]
{
};

void() zombie_painek25 = [186, zombie_painek26]
{
	ai_painforward(IQ_ULTIMATE);
};

void() zombie_painek26 = [187, zombie_painek27]
{
	ai_painforward(IQ_HIGH);
};

void() zombie_painek27 = [188, zombie_painek28]
{
	ai_painforward(SPAWN_CRUCIFIED);
};

void() zombie_painek28 = [189, zombie_painek29]
{
	ai_pain(SPAWN_CRUCIFIED);
};

void() zombie_painek29 = [190, zombie_painek30]
{
};

void() zombie_painek30 = [191, zombie_runk1]
{
};

void() zombiek_die = 
{
	DropDeadMans();
	sound(self, CHAN_VOICE, "zombie/z_gib.wav", SPAWN_CRUCIFIED, ATTN_NORM);
	ThrowHead("progs/crown.mdl", self.health, self.skin);
	self.health = self.health * 1.5;
	ThrowGib("progs/gib1.mdl", self.health);
	ThrowGib("progs/gib2.mdl", self.health);
	ThrowGib("progs/gib3.mdl", self.health);
	self.health = self.health * 1.5;
	ThrowGib("progs/gib1.mdl", self.health);
	ThrowGib("progs/gib2.mdl", self.health);
	ThrowGib("progs/gib3.mdl", self.health);
};

void(entity attacker, float take) zombiek_pain = 
{
	local float r;
	self.health = 60;
	if (take < TE_LIGHTNING3)
	{
		return;
	}
	if (self.inpain == SPAWN_LYINGDOWN)
	{
		return;
	}
	if (take >= 25)
	{
		self.inpain = SPAWN_LYINGDOWN;
		zombie_painek1();
		return;
	}
	if (self.inpain)
	{
		self.pain_finished = time + IQ_HIGH;
		return;
	}
	if (self.pain_finished > time)
	{
		self.inpain = SPAWN_LYINGDOWN;
		zombie_painek1();
		return;
	}
	self.inpain = SPAWN_CRUCIFIED;
	r = random();
	if (r < 0.25)
	{
		zombie_painak1();
	}
	else
	{
		if (r < 0.5)
		{
			zombie_painbk1();
		}
		else
		{
			if (r < 0.75)
			{
				zombie_painck1();
			}
			else
			{
				zombie_paindk1();
			}
		}
	}
};

void() monster_zomking = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/zomking.mdl");
	precache_model("progs/zom_gib.mdl");
	precache_model("progs/crown.mdl");
	precache_sound("zombie/z_idle.wav");
	precache_sound("zombie/z_idle1.wav");
	precache_sound("zombie/z_shot1.wav");
	precache_sound("zombie/z_gib.wav");
	precache_sound("zombie/z_pain.wav");
	precache_sound("zombie/z_pain1.wav");
	precache_sound("zombie/z_fall.wav");
	precache_sound("zombie/z_miss.wav");
	precache_sound("zombie/z_hit.wav");
	precache_sound("zombie/idle_w2.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/zomking.mdl");
	setsize(self, '-32 -32 -48', '32 32 80');
	self.health = 60;
	self.th_stand = zombie_standk1;
	self.th_walk = zombie_walkk1;
	self.th_run = zombie_runk1;
	self.th_pain = zombiek_pain;
	self.th_die = zombiek_die;
	self.th_missile = zombiek_missile;
	walkmonster_start();
};

