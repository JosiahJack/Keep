void() blud_stand1 = [1, blud_stand2]
{
	if (random() < 0.2)
	{
		sound(self, CHAN_AUTO, "monsters/blud/blidle3.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	}
	ai_stand();
};

void() blud_stand2 = [2, blud_stand3]
{
	ai_stand();
};

void() blud_stand3 = [3, blud_stand4]
{
	ai_stand();
};

void() blud_stand4 = [4, blud_stand5]
{
	ai_stand();
};

void() blud_stand5 = [5, blud_stand6]
{
	ai_stand();
};

void() blud_stand6 = [6, blud_stand1]
{
	ai_stand();
};

void() blud_walk1 = [7, blud_walk2]
{
	if (random() < 0.2)
	{
		sound(self, CHAN_AUTO, "monsters/blud/blidle4.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	}
	ai_walk(AS_MELEE);
};

void() blud_walk2 = [8, blud_walk3]
{
	ai_walk(SPAWNFLAG_LASER);
};

void() blud_walk3 = [9, blud_walk4]
{
	ai_walk(AS_MELEE);
};

void() blud_walk4 = [10, blud_walk5]
{
	ai_walk(DOOR_DONT_LINK);
};

void() blud_walk5 = [11, blud_walk6]
{
	ai_walk(AS_MELEE);
};

void() blud_walk6 = [12, blud_walk1]
{
	ai_walk(AS_MELEE);
};

void() Blud_JumpTouch = 
{
	local float ldmg;
	if (self.health <= counter || !(self.takedamage))
	{
		return;
	}
	if (other.takedamage)
	{
		ldmg = (random() + random() + random()) * 20;
		T_Damage(self.enemy, self, self, ldmg);
		sound(self, CHAN_BODY, "monsters/blud/blood.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
		SpawnMeatSpray(self.origin + v_forward * SECRET_YES_SHOOT, crandom() * 100 * v_right);
		SpawnMeatSpray(self.origin + v_forward * SECRET_YES_SHOOT, crandom() * 100 * v_right);
		SpawnMeatSpray(self.origin + v_forward * SECRET_YES_SHOOT, crandom() * 100 * v_right);
		SpawnMeatSpray(self.origin + v_forward * SECRET_YES_SHOOT, crandom() * 100 * v_right);
		SpawnMeatSpray(self.origin + v_forward * SECRET_YES_SHOOT, crandom() * 100 * v_right);
		SpawnMeatSpray(self.origin + v_forward * SECRET_YES_SHOOT, crandom() * 100 * v_right);
	}
	self.touch = SUB_Null;
};

void() blud_atkc1 = [23, blud_atkc2]
{
	local vector dist;
	local vector org;
	if (self.health <= counter)
	{
		dprint("blud_atkc1: dead\n");
		self.touch = SUB_Null;
		self.think = blud_die1;
		return;
	}
	ai_face();
	sound(self, CHAN_AUTO, "monsters/blud/blatt2.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	makevectors(self.angles);
	self.touch = Blud_JumpTouch;
	self.origin_z = self.origin_z + SPAWNFLAG_SUPERSPIKE;
	self.velocity = v_forward * 600 + '0 0 250';
	if (self.flags & FL_ONGROUND)
	{
		self.flags = self.flags - FL_ONGROUND;
	}
};

void() blud_atkc2 = [24, blud_atkc3]
{
	ai_face();
};

void() blud_atkc3 = [25, blud_atkc4]
{
	ai_face();
};

void() blud_atkc4 = [26, blud_atkc5]
{
	ai_face();
};

void() blud_atkc5 = [27, blud_atkc6]
{
	ai_face();
};

void() blud_atkc6 = [28, blud_run1]
{
	ai_face();
};

void() blud_run1 = [7, blud_run2]
{
	if (random() < 0.6)
	{
		if (random() < 0.1)
		{
			sound(self, CHAN_AUTO, "monsters/blud/blidle1.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
		}
		else
		{
			if (random() < 0.2)
			{
				sound(self, CHAN_AUTO, "monsters/blud/blidle2.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
			}
		}
		blud_atkc1();
		return;
	}
	ai_run(SECRET_YES_SHOOT);
};

void() blud_run2 = [8, blud_run3]
{
	ai_run(20);
};

void() blud_run3 = [9, blud_run4]
{
	ai_run(24);
};

void() blud_run4 = [10, blud_run5]
{
	ai_run(22);
};

void() blud_run5 = [11, blud_run6]
{
	ai_run(24);
};

void() blud_run6 = [12, blud_run1]
{
	ai_run(20);
};

void() blud_suck = 
{
	local vector delta;
	local float ldmg;
	if (!(self.enemy))
	{
		return;
	}
	ai_charge(MSG_BROADCAST);
	delta = self.enemy.origin - self.origin;
	if (vlen(delta) > 100)
	{
		return;
	}
	if (!CanDamage(self.enemy, self))
	{
		return;
	}
	ldmg = (random() + random() + random()) * TE_LAVASPLASH;
	T_Damage(self.enemy, self, self, ldmg);
	sound(self, CHAN_AUTO, "monsters/blud/blidle3.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	SpawnMeatSpray(self.origin + v_forward * SECRET_YES_SHOOT, crandom() * 100 * v_right);
	SpawnMeatSpray(self.origin + v_forward * SECRET_YES_SHOOT, crandom() * 100 * v_right);
	SpawnMeatSpray(self.origin + v_forward * SECRET_YES_SHOOT, crandom() * 100 * v_right);
	SpawnMeatSpray(self.origin + v_forward * SECRET_YES_SHOOT, crandom() * 100 * v_right);
	SpawnMeatSpray(self.origin + v_forward * SECRET_YES_SHOOT, crandom() * 100 * v_right);
	SpawnMeatSpray(self.origin + v_forward * SECRET_YES_SHOOT, crandom() * 100 * v_right);
};

void() blud_atk1 = [29, blud_atk2]
{
	ai_charge(20);
	blud_suck();
};

void() blud_atk2 = [30, blud_atk3]
{
	ai_charge(21);
};

void() blud_atk3 = [31, blud_atk4]
{
	ai_charge(22);
};

void() blud_atk4 = [32, blud_atk5]
{
	ai_charge(SVC_TEMPENTITY);
	blud_suck();
};

void() blud_atk5 = [33, blud_atk6]
{
	ai_charge(24);
};

void() blud_atk6 = [34, blud_atk7]
{
	ai_charge(25);
};

void() blud_atk7 = [35, blud_atk8]
{
	ai_charge(26);
};

void() blud_atk8 = [36, blud_atk9]
{
	ai_charge(SVC_KILLEDMONSTER);
	blud_suck();
};

void() blud_atk9 = [37, blud_atk10]
{
	ai_charge(26);
};

void() blud_atk10 = [38, blud_atk11]
{
	ai_charge(25);
};

void() blud_atk11 = [39, blud_atk12]
{
	ai_charge(24);
};

void() blud_atk12 = [40, blud_atk13]
{
	ai_charge(SVC_TEMPENTITY);
	blud_suck();
};

void() blud_atk13 = [41, blud_atk14]
{
	ai_charge(22);
};

void() blud_atk14 = [42, blud_atk15]
{
	ai_charge(21);
};

void() blud_atk15 = [43, blud_atk16]
{
	ai_charge(20);
};

void() blud_atk16 = [44, blud_atk17]
{
	ai_charge(19);
	blud_suck();
};

void() blud_atk17 = [45, blud_run1]
{
	ai_charge(18);
};

void() BludGrenadeTouch = 
{
	if (other == self.owner)
	{
		return;
	}
	if (other.takedamage)
	{
		T_Damage(other, self, self.owner, TE_LAVASPLASH);
		sound(self, CHAN_WEAPON, "zombie/z_hit.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
		SpawnMeatSpray(self.origin + v_forward * SECRET_YES_SHOOT, crandom() * 100 * v_right);
		SpawnMeatSpray(self.origin + v_forward * SECRET_YES_SHOOT, crandom() * 100 * v_right);
		SpawnMeatSpray(self.origin + v_forward * SECRET_YES_SHOOT, crandom() * 100 * v_right);
		remove(self);
		return;
	}
	if (self.velocity == VEC_ORIGIN)
	{
		self.avelocity = VEC_ORIGIN;
	}
	if (self.cnt != MSG_BROADCAST)
	{
		sound(self, CHAN_WEAPON, "zombie/z_miss.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
		SpawnMeatSpray(self.origin + v_forward * SECRET_YES_SHOOT, crandom() * 100 * v_right);
		SpawnMeatSpray(self.origin + v_forward * SECRET_YES_SHOOT, crandom() * 100 * v_right);
		SpawnMeatSpray(self.origin + v_forward * SECRET_YES_SHOOT, crandom() * 100 * v_right);
		remove(self);
		return;
	}
	self.cnt = SPAWNFLAG_SUPERSPIKE;
};

void() BludFireGrenade = 
{
	local entity missile;
	local entity mpuff;
	local vector org;
	sound(self, CHAN_AUTO, "monsters/blud/blatt1.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	org = self.origin;
	makevectors(self.angles);
	missile.velocity = normalize(self.enemy.origin - org);
	missile.velocity = missile.velocity * 900;
	missile.velocity_z = 100;
	missile.avelocity = '3000 1000 2000';
	missile.touch = BludGrenadeTouch;
	missile.nextthink = time + 2.5;
	missile.think = SUB_Remove;
	setmodel(missile, "progs/bone2.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, org);
};

void() BludFireGrenade2 = 
{
	local entity missile;
	local entity mpuff;
	local vector org;
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	org = self.origin;
	makevectors(self.angles);
	missile.velocity = normalize(self.enemy.origin - org);
	missile.velocity = missile.velocity * 700;
	missile.velocity_z = 90;
	missile.avelocity = '3000 1000 2000';
	missile.touch = BludGrenadeTouch;
	missile.nextthink = time + 2.5;
	missile.think = SUB_Remove;
	setmodel(missile, "progs/gib2.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, org);
};

void() BludFireGrenade3 = 
{
	local entity missile;
	local entity mpuff;
	local vector org;
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	org = self.origin;
	makevectors(self.angles);
	missile.velocity = normalize(self.enemy.origin - org);
	missile.velocity = missile.velocity * 500;
	missile.velocity_z = 80;
	missile.avelocity = '3000 1000 2000';
	missile.touch = BludGrenadeTouch;
	missile.nextthink = time + 2.5;
	missile.think = SUB_Remove;
	setmodel(missile, "progs/gib3.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, org);
};

void() blud_atkb1 = [13, blud_atkb2]
{
	ai_face();
};

void() blud_atkb2 = [14, blud_atkb3]
{
	ai_face();
};

void() blud_atkb3 = [15, blud_atkb4]
{
	ai_face();
	BludFireGrenade();
};

void() blud_atkb4 = [16, blud_atkb5]
{
	ai_face();
};

void() blud_atkb5 = [17, blud_atkb6]
{
	ai_face();
};

void() blud_atkb6 = [18, blud_atkb7]
{
	ai_face();
	BludFireGrenade2();
};

void() blud_atkb7 = [19, blud_atkb8]
{
	ai_face();
};

void() blud_atkb8 = [20, blud_atkb9]
{
	ai_face();
};

void() blud_atkb9 = [21, blud_atkb10]
{
	ai_face();
	BludFireGrenade3();
};

void() blud_atkb10 = [22, blud_run1]
{
	ai_face();
};

void() blud_pain1 = [46, blud_pain2]
{
};

void() blud_pain2 = [47, blud_pain3]
{
};

void() blud_pain3 = [48, blud_pain4]
{
};

void() blud_pain4 = [49, blud_run1]
{
};

void(entity attacker, float damage) blud_pain = 
{
	if (self.pain_finished > time)
	{
		return;
	}
	if (random() * 400 > damage)
	{
		return;
	}
	if (self.health <= MSG_BROADCAST)
	{
		return;
	}
	if (random() < 0.2)
	{
		sound(self, CHAN_AUTO, "monsters/blud/blhurt2.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	}
	else
	{
		if (random() < 0.4)
		{
			sound(self, CHAN_AUTO, "monsters/blud/blhurt3.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
		}
		else
		{
			if (random() < 0.6)
			{
				sound(self, CHAN_AUTO, "monsters/blud/blhurt1.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
			}
		}
	}
	blud_pain1();
	self.pain_finished = time + SPAWNFLAG_LASER;
};

void() gib_blud = 
{
	ThrowGib("progs/xtragib.mdl", self.health);
	ThrowGib("progs/gib1.mdl", self.health);
	ThrowGib("progs/bone.mdl", self.health);
	ThrowGib("progs/gib2.mdl", self.health);
	ThrowGib("progs/xtragib.mdl", self.health);
	ThrowGib("progs/bone2.mdl", self.health);
	ThrowGib("progs/gib1.mdl", self.health);
	ThrowGib("progs/xtragib.mdl", self.health);
	ThrowGib("progs/gib2.mdl", self.health);
	ThrowGib("progs/xtragib.mdl", self.health);
	ThrowGib("progs/rawbone.mdl", self.health);
	ThrowGib("progs/gib3.mdl", self.health);
	ThrowHead("progs/rawbone.mdl", self.health);
};

void() blud_die1 = [50, blud_die2]
{
	sound(self, CHAN_AUTO, "monsters/blud/bldie.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	self.th_die = SUB_Null;
};

void() blud_die2 = [51, blud_die3]
{
	ThrowGib("progs/xtragib.mdl", self.health);
	ThrowGib("progs/gib1.mdl", self.health);
	ThrowGib("progs/bone.mdl", self.health);
};

void() blud_die3 = [52, blud_die4]
{
};

void() blud_die4 = [53, blud_die5]
{
	ThrowGib("progs/xtragib.mdl", self.health);
};

void() blud_die5 = [54, blud_die6]
{
};

void() blud_die6 = [55, blud_die7]
{
};

void() blud_die7 = [56, blud_die8]
{
	ThrowGib("progs/xtragib.mdl", self.health);
};

void() blud_die8 = [57, blud_die9]
{
};

void() blud_die9 = [58, blud_die10]
{
};

void() blud_die10 = [59, blud_die11]
{
};

void() blud_die11 = [60, blud_die12]
{
	ThrowGib("progs/xtragib.mdl", self.health);
	ThrowGib("progs/gib1.mdl", self.health);
	ThrowGib("progs/xtragib.mdl", self.health);
	ThrowGib("progs/bone.mdl", self.health);
};

void() blud_die12 = [61, blud_die13]
{
};

void() blud_die13 = [62, blud_die14]
{
};

void() blud_die14 = [63, blud_die15]
{
	ThrowGib("progs/xtragib.mdl", self.health);
};

void() blud_die15 = [64, blud_die16]
{
};

void() blud_die16 = [65, blud_die17]
{
	ThrowGib("progs/rawbone.mdl", self.health);
};

void() blud_die17 = [64, blud_die18]
{
};

void() blud_die18 = [63, blud_die19]
{
	ThrowGib("progs/xtragib.mdl", self.health);
};

void() blud_die19 = [62, blud_die20]
{
};

void() blud_die20 = [61, blud_die21]
{
};

void() blud_die21 = [60, blud_die22]
{
};

void() blud_die22 = [59, blud_die23]
{
	ThrowGib("progs/bone.mdl", self.health);
	ThrowGib("progs/xtragib.mdl", self.health);
};

void() blud_die23 = [58, blud_die24]
{
};

void() blud_die24 = [57, blud_die25]
{
};

void() blud_die25 = [56, blud_die26]
{
	ThrowGib("progs/bone.mdl", self.health);
};

void() blud_die26 = [55, blud_die27]
{
};

void() blud_die27 = [54, blud_die28]
{
};

void() blud_die28 = [53, blud_die29]
{
	ThrowGib("progs/xtragib.mdl", self.health);
};

void() blud_die29 = [52, blud_die30]
{
};

void() blud_die30 = [51, blud_die31]
{
};

void() blud_die31 = [50, blud_die32]
{
	ThrowGib("progs/xtragib.mdl", self.health);
};

void() blud_die32 = [51, blud_die33]
{
};

void() blud_die33 = [52, blud_die34]
{
	ThrowGib("progs/xtragib.mdl", self.health);
	ThrowGib("progs/gib2.mdl", self.health);
};

void() blud_die34 = [53, blud_die35]
{
};

void() blud_die35 = [54, blud_die36]
{
};

void() blud_die36 = [55, blud_die37]
{
};

void() blud_die37 = [56, blud_die38]
{
	ThrowGib("progs/xtragib.mdl", self.health);
	ThrowGib("progs/gib2.mdl", self.health);
};

void() blud_die38 = [57, blud_die39]
{
};

void() blud_die39 = [58, blud_die40]
{
};

void() blud_die40 = [59, blud_die41]
{
	ThrowGib("progs/xtragib.mdl", self.health);
	ThrowGib("progs/bone.mdl", self.health);
};

void() blud_die41 = [60, blud_die42]
{
};

void() blud_die42 = [61, blud_die43]
{
	ThrowGib("progs/gib1.mdl", self.health);
};

void() blud_die43 = [62, blud_die44]
{
};

void() blud_die44 = [63, blud_die45]
{
	ThrowGib("progs/rawbone.mdl", self.health);
	ThrowGib("progs/xtragib.mdl", self.health);
};

void() blud_die45 = [64, blud_die46]
{
};

void() blud_die46 = [65, blud_die46]
{
	gib_blud();
};

void() monster_blud = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model2("progs/blud.mdl");
	precache_model2("progs/xtragib.mdl");
	precache_model2("progs/bone.mdl");
	precache_model2("progs/bone2.mdl");
	precache_model2("progs/rawbone.mdl");
	precache_model2("progs/rawbone2.mdl");
	precache_sound2("monsters/blud/blatt1.wav");
	precache_sound2("monsters/blud/blatt2.wav");
	precache_sound2("monsters/blud/bldie.wav");
	precache_sound2("monsters/blud/blhurt1.wav");
	precache_sound2("monsters/blud/blhurt2.wav");
	precache_sound2("monsters/blud/blhurt3.wav");
	precache_sound2("monsters/blud/blidle1.wav");
	precache_sound2("monsters/blud/blidle2.wav");
	precache_sound2("monsters/blud/blidle3.wav");
	precache_sound2("monsters/blud/blidle4.wav");
	precache_sound2("monsters/blud/blood.wav");
	precache_sound2("monsters/blud/blsight.wav");
	precache_sound2("zombie/z_miss.wav");
	precache_sound2("zombie/z_hit.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/blud.mdl");
	setsize(self, '-22 -46 -68', '24 35 72');
	self.health = 3000;
	self.th_stand = blud_stand1;
	self.th_walk = blud_walk1;
	self.th_run = blud_run1;
	self.th_melee = blud_atk1;
	self.th_missile = blud_atkb1;
	self.th_pain = blud_pain;
	self.th_die = blud_die1;
	walkmonster_start();
};

