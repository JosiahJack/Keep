void() shal_stand = [23, shal_stand]
{
	ai_stand();
};

void() shal_invisible = 
{
	PM_VoreCloak((skill - SPAWN_ROTATE) * 40 + SVC_SETVIEWANGLES);
	shal_stand();
};

void() shal_walk1 = [24, shal_walk2]
{
	local float chance;
	if (skill > SPAWN_STRING)
	{
		chance = 80;
	}
	else
	{
		if (skill == SPAWN_STRING)
		{
			chance = 50;
		}
		else
		{
			chance = MSG_BROADCAST;
		}
	}
	PM_VoreCloak(chance);
	if (random() < 0.2)
	{
		sound(self, CHAN_VOICE, "shalrath/idle.wav", SPAWN_ROTATE, ATTN_IDLE);
	}
	ai_walk(TE_LIGHTNING2);
};

void() shal_walk2 = [25, shal_walk3]
{
	ai_walk(SPAWN_SAC);
};

void() shal_walk3 = [26, shal_walk4]
{
	ai_walk(MSG_BROADCAST);
};

void() shal_walk4 = [27, shal_walk5]
{
	ai_walk(MSG_BROADCAST);
};

void() shal_walk5 = [28, shal_walk6]
{
	ai_walk(MSG_BROADCAST);
};

void() shal_walk6 = [29, shal_walk7]
{
	ai_walk(MSG_BROADCAST);
};

void() shal_walk7 = [30, shal_walk8]
{
	ai_walk(IQ_ULTIMATE);
};

void() shal_walk8 = [31, shal_walk9]
{
	ai_walk(TE_LIGHTNING2);
};

void() shal_walk9 = [32, shal_walk10]
{
	ai_walk(IQ_ULTIMATE);
};

void() shal_walk10 = [33, shal_walk11]
{
	ai_walk(MSG_BROADCAST);
};

void() shal_walk11 = [34, shal_walk12]
{
	ai_walk(SPAWN_SAC);
};

void() shal_walk12 = [23, shal_walk1]
{
	ai_walk(IQ_ULTIMATE);
};

void() shal_run1 = [24, shal_run2]
{
	PM_VoreCloak(skill * 40);
	if (random() < 0.2)
	{
		sound(self, CHAN_VOICE, "shalrath/idle.wav", SPAWN_ROTATE, ATTN_IDLE);
	}
	ai_run(TE_LIGHTNING2);
};

void() shal_run2 = [25, shal_run3]
{
	ai_run(SPAWN_SAC);
};

void() shal_run3 = [26, shal_run4]
{
	ai_run(MSG_BROADCAST);
};

void() shal_run4 = [27, shal_run5]
{
	ai_run(MSG_BROADCAST);
};

void() shal_run5 = [28, shal_run6]
{
	ai_run(MSG_BROADCAST);
};

void() shal_run6 = [29, shal_run7]
{
	ai_run(MSG_BROADCAST);
};

void() shal_run7 = [30, shal_run8]
{
	ai_run(IQ_ULTIMATE);
};

void() shal_run8 = [31, shal_run9]
{
	ai_run(TE_LIGHTNING2);
};

void() shal_run9 = [32, shal_run10]
{
	ai_run(IQ_ULTIMATE);
};

void() shal_run10 = [33, shal_run11]
{
	ai_run(MSG_BROADCAST);
};

void() shal_run11 = [34, shal_run12]
{
	ai_run(SPAWN_SAC);
};

void() shal_run12 = [23, shal_run1]
{
	ai_run(IQ_ULTIMATE);
};

void() shal_attack1 = [0, shal_attack2]
{
	local float chance;
	if (self.model == "")
	{
		if (skill > SPAWN_STRING)
		{
			chance = 80;
		}
		else
		{
			chance = 50;
		}
		PM_VoreCloak(chance);
	}
	sound(self, CHAN_VOICE, "shalrath/attack.wav", SPAWN_ROTATE, ATTN_NORM);
	ai_face();
};

void() shal_attack2 = [1, shal_attack3]
{
	ai_face();
};

void() shal_attack3 = [2, shal_attack4]
{
	ai_face();
};

void() shal_attack4 = [3, shal_attack5]
{
	ai_face();
};

void() shal_attack5 = [4, shal_attack6]
{
	ai_face();
};

void() shal_attack6 = [5, shal_attack7]
{
	ai_face();
};

void() shal_attack7 = [6, shal_attack8]
{
	ai_face();
};

void() shal_attack8 = [7, shal_attack9]
{
	ai_face();
};

void() shal_attack9 = [8, shal_attack10]
{
	local float chance;
	PM_VoreCloak(MSG_BROADCAST);
	chance = skill * 0.1;
	chance = chance + 0.1;
	if (self.enemy != world)
	{
		if (random() < chance)
		{
			PM_VoreFireball();
		}
		else
		{
			ShalMissile();
		}
	}
};

void() shal_attack10 = [9, shal_attack11]
{
	ai_face();
};

void() shal_attack11 = [10, shal_run1]
{
};

void() shal_pain1 = [11, shal_pain2]
{
};

void() shal_pain2 = [12, shal_pain3]
{
};

void() shal_pain3 = [13, shal_pain4]
{
};

void() shal_pain4 = [14, shal_pain5]
{
};

void() shal_pain5 = [15, shal_run1]
{
};

void() shal_death1 = [16, shal_death2]
{
	PM_VoreCloak(MSG_BROADCAST);
};

void() shal_death2 = [17, shal_death3]
{
};

void() shal_death3 = [18, shal_death4]
{
};

void() shal_death4 = [19, shal_death5]
{
};

void() shal_death5 = [20, shal_death6]
{
};

void() shal_death6 = [21, shal_death7]
{
};

void() shal_death7 = [22, shal_death7]
{
};

void() shalrath_pain = 
{
	if (self.pain_finished > time)
	{
		return;
	}
	sound(self, CHAN_VOICE, "shalrath/pain.wav", SPAWN_ROTATE, ATTN_NORM);
	shal_pain1();
	self.pain_finished = time + IQ_HIGH;
};

void() shalrath_die = 
{
	self.health = -160;
	ThrowHead("progs/h_shal.mdl", self.health, self.skin);
	sound(self, CHAN_VOICE, "shalrath/death.wav", SPAWN_ROTATE, ATTN_NORM);
	T_RadiusDamage(self, self, 160, world);
	self.origin = self.origin - SPAWN_CUT * normalize(self.velocity);
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_TAREXPLOSION);
	WriteCoord(MSG_BROADCAST, self.origin_x);
	WriteCoord(MSG_BROADCAST, self.origin_y);
	WriteCoord(MSG_BROADCAST, self.origin_z);
	BecomeExplosion();
};

void(float chance) PM_VoreCloak = 
{
	chance = chance * 0.010000;
	if (random() < chance)
	{
		self.model = "";
		self.takedamage = DAMAGE_YES;
	}
	else
	{
		self.model = "progs/shalrath.mdl";
		self.takedamage = DAMAGE_AIM;
	}
};

void() PM_VoreFireballTouch = 
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
	T_RadiusDamage(self, self.owner, TOOCLOSE_CHARMER_DISTANCE, self.owner);
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord(MSG_BROADCAST, self.origin_x);
	WriteCoord(MSG_BROADCAST, self.origin_y);
	WriteCoord(MSG_BROADCAST, self.origin_z);
	BecomeExplosion();
};

void() PM_VoreFireball = 
{
	local entity missile;
	local vector dir;
	dir = normalize(self.enemy.origin + '0 0 10' - self.origin);
	self.effects = self.effects | EF_MUZZLEFLASH;
	sound(self, CHAN_WEAPON, "shalrath/attack2.wav", SPAWN_ROTATE, ATTN_NORM);
	missile = spawn();
	setmodel(missile, "progs/lavaball.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, self.origin + '0 0 10');
	missile.owner = self;
	missile.solid = SOLID_BBOX;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.velocity = dir * 600;
	missile.avelocity = '300 300 300';
	missile.nextthink = time + IQ_ULTIMATE;
	missile.think = PM_VoreFireballTouch;
	missile.touch = PM_VoreFireballTouch;
};

void() PM_VoreGasThink = 
{
	PM_AlterMind(self, self.owner, 100);
	self.cnt = self.cnt - SPAWN_ROTATE;
	if (self.cnt <= MSG_BROADCAST)
	{
		remove(self);
	}
	else
	{
		self.nextthink = time + 0.5;
		self.think = PM_VoreGasThink;
	}
};

void(vector spot, entity from) PM_SpawnVoreGas = 
{
	local entity cloud;
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_TAREXPLOSION);
	WriteCoord(MSG_BROADCAST, spot_x);
	WriteCoord(MSG_BROADCAST, spot_y);
	WriteCoord(MSG_BROADCAST, spot_z);
	cloud = spawn();
	setmodel(cloud, "");
	setsize(cloud, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(cloud, spot);
	cloud.movetype = MOVETYPE_NONE;
	cloud.solid = SOLID_NOT;
	cloud.velocity = VEC_ORIGIN;
	cloud.cnt = IQ_HIGH;
	cloud.owner = from;
	cloud.nextthink = time + 0.1;
	cloud.think = PM_VoreGasThink;
	cloud.touch = SUB_Null;
};

void() ShalMissile = 
{
	local entity missile;
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
	sound(self, CHAN_WEAPON, "shalrath/attack2.wav", SPAWN_ROTATE, ATTN_NORM);
	missile = spawn();
	missile.owner = self;
	missile.solid = SOLID_BBOX;
	missile.movetype = MOVETYPE_FLYMISSILE;
	setmodel(missile, "progs/v_spike.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	missile.origin = self.origin + '0 0 10';
	missile.velocity = dir * 400;
	missile.avelocity = '300 300 300';
	missile.nextthink = flytime + time;
	missile.think = ShalHome;
	missile.enemy = self.enemy;
	missile.touch = ShalMissileTouch;
};

void() ShalHome = 
{
	local vector dir;
	local vector vtemp;
	vtemp = self.enemy.origin + '0 0 10';
	if (self.enemy.health < SPAWN_ROTATE)
	{
		ShalMissileTouch();
		return;
	}
	dir = normalize(vtemp - self.origin);
	if (skill > SPAWN_STRING)
	{
		self.velocity = dir * 350;
	}
	else
	{
		self.velocity = dir * 250;
	}
	self.nextthink = time + 0.2;
	self.think = ShalHome;
};

void() ShalMissileTouch = 
{
	if (other == self.owner)
	{
		return;
	}
	if (other.classname == "monster_zombie")
	{
		T_Damage(other, self, self, 110);
	}
	T_RadiusDamage(self, self.owner, skill, self.owner);
	sound(self, CHAN_WEAPON, "weapons/r_exp3.wav", SPAWN_ROTATE, ATTN_NORM);
	self.effects = self.effects | EF_MUZZLEFLASH;
	PM_SpawnVoreGas(self.origin, self.owner);
	self.velocity = VEC_ORIGIN;
	self.touch = SUB_Null;
	setmodel(self, "progs/s_explod.spr");
	self.solid = SOLID_NOT;
	s_explode1();
};

void() monster_shalrath = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model2("progs/shalrath.mdl");
	precache_model2("progs/h_shal.mdl");
	precache_model2("progs/v_spike.mdl");
	precache_sound2("shalrath/attack.wav");
	precache_sound2("shalrath/attack2.wav");
	precache_sound2("shalrath/death.wav");
	precache_sound2("shalrath/idle.wav");
	precache_sound2("shalrath/pain.wav");
	precache_sound2("shalrath/sight.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/shalrath.mdl");
	setsize(self, VEC_HULL2_MIN, '32 32 40');
	if (!(self.health))
	{
		self.health = 400;
	}
	self.th_stand = shal_invisible;
	self.th_walk = shal_walk1;
	self.th_run = shal_run1;
	self.th_die = shalrath_die;
	self.th_pain = shalrath_pain;
	self.th_missile = shal_attack1;
	self.think = walkmonster_start;
	self.nextthink = time + 0.1 + random() * 0.1;
};

