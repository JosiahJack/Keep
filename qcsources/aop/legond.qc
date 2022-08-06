float() LegondCheckAttack = 
{
	local vector spot1;
	local vector spot2;
	local entity targ;
	local float chance;
	local float r;
	if (enemy_range != RANGE_MELEE)
	{
		if (time < self.attack_finished)
		{
			return 0;
		}
	}
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
	if (enemy_range == RANGE_MELEE)
	{
		self.th_melee();
		return 1;
	}
	if (enemy_range == RANGE_FAR)
	{
		chance = 0.1;
	}
	else
	{
		if (enemy_range == RANGE_MELEE)
		{
			chance = 0.9;
			self.attack_finished = MSG_BROADCAST;
		}
		else
		{
			if (enemy_range == RANGE_NEAR)
			{
				if (self.th_melee)
				{
					chance = 0.2;
				}
				else
				{
					chance = 0.4;
				}
			}
			else
			{
				if (enemy_range == RANGE_MID)
				{
					chance = 0.2;
				}
				else
				{
					chance = MSG_BROADCAST;
				}
			}
		}
	}
	r = random();
	if (random() < chance)
	{
		if (r < 0.25)
		{
			legond_shootb1();
		}
		else
		{
			if (r < 0.5)
			{
				legond_shoot1();
			}
			else
			{
				if (r < 0.75)
				{
					legond_combob1();
				}
				else
				{
					legond_light1();
				}
			}
		}
		SUB_AttackFinished(SPAWNFLAG_LASER * random());
		return 1;
	}
	return 0;
};

void() legond_stand1 = [1, legond_stand2]
{
	ai_stand();
};

void() legond_stand2 = [2, legond_stand3]
{
	ai_stand();
};

void() legond_stand3 = [3, legond_stand4]
{
	ai_stand();
};

void() legond_stand4 = [4, legond_stand5]
{
	ai_stand();
};

void() legond_stand5 = [5, legond_stand6]
{
	ai_stand();
};

void() legond_stand6 = [6, legond_stand7]
{
	ai_stand();
};

void() legond_stand7 = [7, legond_stand8]
{
	ai_stand();
};

void() legond_stand8 = [8, legond_stand9]
{
	ai_stand();
};

void() legond_stand9 = [9, legond_stand10]
{
	ai_stand();
};

void() legond_stand10 = [10, legond_stand1]
{
	ai_stand();
};

void() legond_walk1 = [11, legond_walk1]
{
	local float r;
	r = random();
	if (r < 0.3)
	{
		sound(self, CHAN_BODY, "monsters/legond/lidle.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	}
	ai_walk(SECRET_YES_SHOOT);
};

void() legond_walk2 = [12, legond_walk3]
{
	ai_walk(14);
};

void() legond_walk3 = [13, legond_walk4]
{
	ai_walk(13);
};

void() legond_walk4 = [14, legond_walk5]
{
	ai_walk(15);
};

void() legond_walk5 = [15, legond_walk6]
{
	ai_walk(SECRET_YES_SHOOT);
};

void() legond_walk6 = [16, legond_walk7]
{
	ai_walk(14);
};

void() legond_walk7 = [17, legond_walk8]
{
	ai_walk(13);
};

void() legond_walk8 = [18, legond_walk9]
{
	ai_walk(15);
};

void() legond_walk9 = [19, legond_walk10]
{
	ai_walk(13);
};

void() legond_walk10 = [20, legond_walk11]
{
	ai_walk(SECRET_YES_SHOOT);
};

void() legond_walk11 = [21, legond_walk12]
{
	ai_walk(17);
};

void() legond_walk12 = [22, legond_walk1]
{
	ai_walk(15);
};

void() legond_run1 = [27, legond_run2]
{
	local float r;
	r = random();
	if (r < 0.3)
	{
		sound(self, CHAN_BODY, "monsters/legond/lidle.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	}
	ai_run(18);
};

void() legond_run2 = [28, legond_run3]
{
	ai_run(17);
};

void() legond_run3 = [29, legond_run4]
{
	ai_run(SECRET_YES_SHOOT);
};

void() legond_run4 = [30, legond_run5]
{
	ai_run(18);
};

void() legond_run5 = [31, legond_run6]
{
	ai_run(17);
};

void() legond_run6 = [32, legond_run7]
{
	ai_run(15);
};

void() legond_run7 = [33, legond_run8]
{
	ai_run(SECRET_YES_SHOOT);
};

void() legond_run8 = [34, legond_run9]
{
	ai_run(17);
};

void() legond_run9 = [35, legond_run10]
{
	ai_run(18);
};

void() legond_run10 = [36, legond_run11]
{
	ai_run(19);
};

void() legond_run11 = [37, legond_run12]
{
	ai_run(15);
};

void() legond_run12 = [38, legond_run1]
{
	ai_run(SVC_TEMPENTITY);
};

void() Legond_MissileTouch = 
{
	local float damg;
	if (other == self.owner)
	{
		return;
	}
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	damg = 80 + random() * 20;
	if (other.health)
	{
		if (other.classname == "monster_shambler")
		{
			damg = damg * 0.5;
		}
		T_Damage(other, self, self.owner, damg);
		self.health = self.health + damg;
	}
	if (skill == AS_MELEE)
	{
		T_RadiusDamage(self, self.owner, 100, other);
	}
	if (skill == SPAWNFLAG_LASER)
	{
		T_RadiusDamage(self, self.owner, 90, other);
	}
	if (skill == SPAWNFLAG_SUPERSPIKE)
	{
		T_RadiusDamage(self, self.owner, 80, other);
	}
	else
	{
		T_RadiusDamage(self, self.owner, 70, other);
	}
	self.origin = self.origin - SECRET_NO_SHOOT * normalize(self.velocity);
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord(MSG_BROADCAST, self.origin_x);
	WriteCoord(MSG_BROADCAST, self.origin_y);
	WriteCoord(MSG_BROADCAST, self.origin_z);
	BecomeExplosion();
};

void(vector org, vector vec) LaunchRocket = 
{
	ai_face();
	self.attack_finished = time + 0.8;
	vec = normalize(vec);
	newmis = spawn();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLY;
	newmis.solid = SOLID_BBOX;
	setmodel(newmis, "progs/missile2.mdl");
	setsize(newmis, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(newmis, org);
	newmis.velocity = vec * 700;
	newmis.angles = vectoangles(newmis.velocity);
	newmis.nextthink = time + TE_LIGHTNING1;
	newmis.think = SUB_Remove;
	newmis.touch = Legond_MissileTouch;
};

void() LegondFireRocket = 
{
	local vector org;
	self.effects = self.effects | EF_MUZZLEFLASH;
	makevectors(self.angles);
	org = self.origin + v_forward * SECRET_NO_SHOOT + v_right * 12 + v_up * 12 + '0 0 16';
	sound(self, CHAN_WEAPON, "monsters/legond/lshot.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	LaunchRocket(org, self.enemy.origin - self.origin - v_up * random() * 80);
};

void() LegondFireRocketB = 
{
	local float r;
	local vector org;
	local vector org2;
	self.effects = self.effects | EF_MUZZLEFLASH;
	makevectors(self.angles);
	org = self.origin + v_forward * SECRET_NO_SHOOT - v_right * 12 + v_up * 12 + '0 0 16';
	org2 = self.origin + v_forward * SECRET_NO_SHOOT + v_right * 12 + v_up * 12 + '0 0 16';
	r = random() * 80;
	sound(self, CHAN_WEAPON, "monsters/legond/lshot.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	LaunchRocket(org, self.enemy.origin - self.origin - v_up * r);
	sound(self, CHAN_WEAPON, "monsters/legond/lshot.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	LaunchRocket(org2, self.enemy.origin - self.origin - v_up * r);
};

void() legond_shoot1 = [62, legond_shoot2]
{
	ai_face();
};

void() legond_shoot2 = [63, legond_shoot3]
{
	ai_face();
};

void() legond_shoot3 = [64, legond_shoot4]
{
	ai_face();
};

void() legond_shoot4 = [65, legond_shoot5]
{
	ai_face();
};

void() legond_shoot5 = [66, legond_shoot6]
{
	ai_face();
};

void() legond_shoot6 = [67, legond_shoot7]
{
	ai_face();
};

void() legond_shoot7 = [68, legond_shoot8]
{
	ai_face();
};

void() legond_shoot8 = [69, legond_shoot9]
{
	ai_face();
	LegondFireRocket();
};

void() legond_shoot9 = [70, legond_shoot10]
{
	ai_face();
};

void() legond_shoot10 = [71, legond_shoot11]
{
	ai_face();
};

void() legond_shoot11 = [72, legond_shoot12]
{
	ai_face();
};

void() legond_shoot12 = [73, legond_run1]
{
	ai_face();
};

void() legond_shootb1 = [74, legond_shootb2]
{
	ai_face();
};

void() legond_shootb2 = [75, legond_shootb3]
{
	ai_face();
};

void() legond_shootb3 = [76, legond_shootb4]
{
	ai_face();
};

void() legond_shootb4 = [77, legond_shootb5]
{
	ai_face();
};

void() legond_shootb5 = [78, legond_shootb6]
{
	ai_face();
};

void() legond_shootb6 = [79, legond_shootb7]
{
	ai_face();
};

void() legond_shootb7 = [80, legond_shootb8]
{
	ai_face();
};

void() legond_shootb8 = [81, legond_shootb9]
{
	ai_face();
};

void() legond_shootb9 = [82, legond_shootb10]
{
	ai_face();
};

void() legond_shootb10 = [83, legond_shootb11]
{
	ai_face();
	LegondFireRocketB();
};

void() legond_shootb11 = [84, legond_shootb12]
{
	ai_face();
};

void() legond_shootb12 = [85, legond_shootb13]
{
	ai_face();
};

void() legond_shootb13 = [86, legond_shootb14]
{
	ai_face();
};

void() legond_shootb14 = [87, legond_run1]
{
	ai_face();
};

void() Legond_FireLightning = 
{
	local vector org;
	local vector dir;
	self.effects = self.effects | EF_MUZZLEFLASH;
	ai_face();
	sound(self, CHAN_ITEM, "monsters/legond/lpull.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	org = self.origin + '0 0 12' - v_right * SECRET_NO_SHOOT;
	dir = self.enemy.origin + '0 0 16' - org;
	dir = normalize(dir);
	traceline(org, self.origin + dir * 600, 1, self);
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_LIGHTNING2);
	WriteEntity(MSG_BROADCAST, self);
	WriteCoord(MSG_BROADCAST, org_x);
	WriteCoord(MSG_BROADCAST, org_y);
	WriteCoord(MSG_BROADCAST, org_z);
	WriteCoord(MSG_BROADCAST, trace_endpos_x);
	WriteCoord(MSG_BROADCAST, trace_endpos_y);
	WriteCoord(MSG_BROADCAST, trace_endpos_z);
	LightningDamage(org, trace_endpos + v_forward * SECRET_1ST_DOWN, self, SECRET_1ST_DOWN);
	self.health = self.health + AS_MELEE;
	self.enemy.velocity = '0 0 150' + v_forward * 400;
	if (self.flags & FL_ONGROUND)
	{
		self.flags = self.flags - FL_ONGROUND;
	}
};

void() legond_light1 = [49, legond_light2]
{
	ai_face();
};

void() legond_light2 = [48, legond_light3]
{
	ai_face();
};

void() legond_light3 = [47, legond_light4]
{
	ai_face();
};

void() legond_light4 = [46, legond_light5]
{
	ai_face();
};

void() legond_light5 = [45, legond_light6]
{
	ai_face();
	Legond_FireLightning();
};

void() legond_light6 = [45, legond_light7]
{
	ai_face();
	Legond_FireLightning();
};

void() legond_light7 = [45, legond_light8]
{
	ai_face();
	Legond_FireLightning();
};

void() legond_light8 = [44, legond_light9]
{
	ai_face();
};

void() legond_light9 = [43, legond_light10]
{
	ai_face();
};

void() legond_light10 = [42, legond_light11]
{
	ai_face();
};

void() legond_light11 = [41, legond_light12]
{
	ai_face();
};

void() legond_light12 = [40, legond_light13]
{
	ai_face();
};

void() legond_light13 = [39, legond_run1]
{
	ai_face();
};

void() Legond_Punch = 
{
	local vector delta;
	local float ldmg;
	if (!(self.enemy))
	{
		return;
	}
	delta = self.enemy.origin - self.origin;
	sound(self, CHAN_BODY, "monsters/legond/lswipe.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	if (vlen(delta) > 100)
	{
		return;
	}
	if (!CanDamage(self.enemy, self))
	{
		return;
	}
	ldmg = (random() + random() + random()) * TE_LIGHTNING3;
	sound(self, CHAN_WEAPON, "monsters/legond/legsmak.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	T_Damage(self.enemy, self, self, ldmg);
	self.health = self.health + ldmg;
	SpawnMeatSpray(self.origin + v_forward * SECRET_YES_SHOOT, crandom() * 100 * v_right);
	SpawnMeatSpray(self.origin + v_forward * SECRET_YES_SHOOT, crandom() * 100 * v_right);
	self.enemy.velocity = '0 0 150' + v_forward * 350;
	if (self.flags & FL_ONGROUND)
	{
		self.flags = self.flags - FL_ONGROUND;
	}
};

void() legond_punch1 = [39, legond_punch2]
{
	ai_charge(12);
};

void() legond_punch2 = [40, legond_punch3]
{
	ai_charge(SECRET_NO_SHOOT);
};

void() legond_punch3 = [41, legond_punch4]
{
	ai_charge(TE_LIGHTNING3);
};

void() legond_punch4 = [42, legond_punch5]
{
	ai_charge(TE_TELEPORT);
	Legond_Punch();
};

void() legond_punch5 = [43, legond_punch6]
{
	ai_charge(TE_LAVASPLASH);
	Legond_Punch();
};

void() legond_punch6 = [44, legond_punch7]
{
	ai_charge(12);
};

void() legond_punch7 = [45, legond_punch8]
{
	ai_charge(SECRET_NO_SHOOT);
};

void() legond_punch8 = [46, legond_punch9]
{
	ai_charge(TE_LIGHTNING3);
};

void() legond_punch9 = [47, legond_punch10]
{
	ai_charge(TE_TELEPORT);
};

void() legond_punch10 = [48, legond_punch11]
{
	ai_charge(TE_LAVASPLASH);
};

void() legond_punch11 = [49, legond_run1]
{
	ai_charge(12);
};

void() Legond_SoftPunch = 
{
	local vector delta;
	local float ldmg;
	if (!(self.enemy))
	{
		return;
	}
	delta = self.enemy.origin - self.origin;
	sound(self, CHAN_BODY, "monsters/legond/lswipe.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	if (vlen(delta) > 100)
	{
		return;
	}
	if (!CanDamage(self.enemy, self))
	{
		return;
	}
	ldmg = (random() + random() + random()) * AS_MELEE;
	sound(self, CHAN_WEAPON, "monsters/legond/legsmak.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	T_Damage(self.enemy, self, self, ldmg);
	self.health = self.health + ldmg;
	SpawnMeatSpray(self.origin + v_forward * SECRET_YES_SHOOT, crandom() * 100 * v_right);
};

void() legond_combo1 = [39, legond_combo2]
{
	ai_charge(12);
};

void() legond_combo2 = [41, legond_combo3]
{
	ai_charge(SECRET_NO_SHOOT);
};

void() legond_combo3 = [43, legond_combo4]
{
	ai_charge(TE_LIGHTNING3);
};

void() legond_combo4 = [45, legond_combo5]
{
	ai_charge(TE_TELEPORT);
	Legond_SoftPunch();
};

void() legond_combo5 = [46, legond_combo6]
{
	ai_charge(TE_LAVASPLASH);
	Legond_SoftPunch();
};

void() legond_combo6 = [49, legond_combo7]
{
	ai_charge(12);
};

void() legond_combo7 = [39, legond_combo8]
{
	ai_charge(12);
};

void() legond_combo8 = [41, legond_combo9]
{
	ai_charge(SECRET_NO_SHOOT);
};

void() legond_combo9 = [43, legond_combo10]
{
	ai_charge(TE_LIGHTNING3);
};

void() legond_combo10 = [45, legond_combo11]
{
	ai_charge(TE_TELEPORT);
	Legond_SoftPunch();
};

void() legond_combo11 = [46, legond_combo12]
{
	ai_charge(TE_LAVASPLASH);
	Legond_SoftPunch();
};

void() legond_combo12 = [49, legond_combo13]
{
	ai_charge(12);
};

void() legond_combo13 = [50, legond_combo14]
{
	ai_charge(12);
};

void() legond_combo14 = [52, legond_combo15]
{
	ai_charge(SECRET_NO_SHOOT);
};

void() legond_combo15 = [54, legond_combo16]
{
	ai_charge(TE_LIGHTNING3);
	Legond_Punch();
};

void() legond_combo16 = [56, legond_combo17]
{
	ai_charge(TE_TELEPORT);
};

void() legond_combo17 = [58, legond_combo18]
{
	ai_charge(TE_LAVASPLASH);
};

void() legond_combo18 = [60, legond_combo19]
{
	ai_charge(12);
};

void() legond_combo19 = [62, legond_combo20]
{
	ai_face();
};

void() legond_combo20 = [64, legond_combo21]
{
	ai_face();
};

void() legond_combo21 = [66, legond_combo22]
{
	ai_face();
};

void() legond_combo22 = [68, legond_combo23]
{
	ai_face();
	LegondFireRocket();
};

void() legond_combo23 = [70, legond_combo24]
{
	ai_face();
};

void() legond_combo24 = [72, legond_combo25]
{
	ai_face();
};

void() legond_combo25 = [49, legond_combo26]
{
	ai_face();
};

void() legond_combo26 = [47, legond_combo27]
{
	ai_face();
	Legond_FireLightning();
};

void() legond_combo27 = [45, legond_combo28]
{
	ai_face();
	Legond_FireLightning();
};

void() legond_combo28 = [43, legond_combo29]
{
	ai_face();
	Legond_FireLightning();
};

void() legond_combo29 = [41, legond_combo30]
{
	ai_face();
};

void() legond_combo30 = [39, legond_run1]
{
	ai_face();
};

void() legond_combob1 = [74, legond_combob2]
{
	ai_face();
};

void() legond_combob2 = [76, legond_combob3]
{
	ai_face();
};

void() legond_combob3 = [78, legond_combob4]
{
	ai_face();
};

void() legond_combob4 = [80, legond_combob5]
{
	ai_face();
};

void() legond_combob5 = [82, legond_combob6]
{
	ai_face();
};

void() legond_combob6 = [83, legond_combob7]
{
	ai_face();
	LegondFireRocketB();
};

void() legond_combob7 = [85, legond_combob8]
{
	ai_face();
};

void() legond_combob8 = [87, legond_combob9]
{
	ai_face();
};

void() legond_combob9 = [49, legond_combob10]
{
	ai_face();
};

void() legond_combob10 = [47, legond_combob11]
{
	ai_face();
	Legond_FireLightning();
};

void() legond_combob11 = [45, legond_combob12]
{
	ai_face();
	Legond_FireLightning();
};

void() legond_combob12 = [43, legond_combob13]
{
	ai_face();
	Legond_FireLightning();
};

void() legond_combob13 = [41, legond_combob14]
{
	ai_face();
};

void() legond_combob14 = [39, legond_combob15]
{
	ai_face();
};

void() legond_combob15 = [50, legond_combob16]
{
	ai_charge(12);
};

void() legond_combob16 = [52, legond_combob17]
{
	ai_charge(TE_LIGHTNING3);
};

void() legond_combob17 = [54, legond_combob18]
{
	ai_charge(TE_LAVASPLASH);
};

void() legond_combob18 = [56, legond_combob19]
{
	ai_charge(SECRET_NO_SHOOT);
	Legond_SoftPunch();
};

void() legond_combob19 = [58, legond_combob20]
{
	ai_charge(TE_TELEPORT);
};

void() legond_combob20 = [57, legond_combob21]
{
	ai_charge(12);
};

void() legond_combob21 = [56, legond_combob22]
{
	ai_charge(TE_LAVASPLASH);
};

void() legond_combob22 = [57, legond_combob23]
{
	ai_charge(SECRET_NO_SHOOT);
	Legond_Punch();
};

void() legond_combob23 = [58, legond_run1]
{
	ai_charge(TE_TELEPORT);
};

void() legond_kick1 = [50, legond_kick2]
{
	ai_charge(12);
};

void() legond_kick2 = [51, legond_kick3]
{
	ai_charge(SECRET_NO_SHOOT);
};

void() legond_kick3 = [52, legond_kick4]
{
	ai_charge(TE_LIGHTNING3);
};

void() legond_kick4 = [53, legond_kick5]
{
	ai_charge(TE_TELEPORT);
};

void() legond_kick5 = [54, legond_kick6]
{
	ai_charge(TE_LAVASPLASH);
};

void() legond_kick6 = [55, legond_kick7]
{
	ai_charge(12);
	Legond_Punch();
};

void() legond_kick7 = [56, legond_kick8]
{
	ai_charge(SECRET_NO_SHOOT);
	Legond_Punch();
};

void() legond_kick8 = [57, legond_kick9]
{
	ai_charge(TE_LIGHTNING3);
	Legond_Punch();
};

void() legond_kick9 = [58, legond_kick10]
{
	ai_charge(TE_TELEPORT);
};

void() legond_kick10 = [59, legond_kick11]
{
	ai_charge(TE_LAVASPLASH);
};

void() legond_kick11 = [60, legond_kick12]
{
	ai_charge(SECRET_NO_SHOOT);
};

void() legond_kick12 = [61, legond_run1]
{
	ai_charge(12);
};

void() Legond_Melee = 
{
	if (random() < 0.4)
	{
		legond_punch1();
	}
	else
	{
		if (random() > 0.7)
		{
			legond_kick1();
		}
		else
		{
			legond_combo1();
		}
	}
};

void() Legond_Des_return = 
{
	self.cnt = MSG_BROADCAST;
};

void() Legond_Teleport = 
{
	local float v;
	local string tmpstr;
	local entity head;
	head = findradius(self.origin, 500);
	while (head)
	{
		if (head.classname == "legond_teledes" && head.cnt == MSG_BROADCAST)
		{
			if (random() < 0.3)
			{
				WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
				WriteByte(MSG_BROADCAST, TE_TELEPORT);
				WriteCoord(MSG_BROADCAST, self.origin_x);
				WriteCoord(MSG_BROADCAST, self.origin_y);
				WriteCoord(MSG_BROADCAST, self.origin_z);
				WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
				WriteByte(MSG_BROADCAST, TE_TELEPORT);
				WriteCoord(MSG_BROADCAST, head.origin_x);
				WriteCoord(MSG_BROADCAST, head.origin_y);
				WriteCoord(MSG_BROADCAST, head.origin_z);
				self.origin = head.origin;
				v = random() * TE_LIGHTNING1;
				if (v < SPAWNFLAG_SUPERSPIKE)
				{
					tmpstr = "misc/r_tele1.wav";
				}
				else
				{
					if (v < SPAWNFLAG_LASER)
					{
						tmpstr = "misc/r_tele2.wav";
					}
					else
					{
						if (v < AS_MELEE)
						{
							tmpstr = "misc/r_tele3.wav";
						}
						else
						{
							if (v < SECRET_1ST_DOWN)
							{
								tmpstr = "misc/r_tele4.wav";
							}
							else
							{
								tmpstr = "misc/r_tele5.wav";
							}
						}
					}
				}
				sound(self, CHAN_ITEM, tmpstr, SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
				sound(self, CHAN_AUTO, "monsters/legond/legond.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
				head.cnt = SPAWNFLAG_SUPERSPIKE;
				head.nextthink = time + random() * 20;
				head.think = Legond_Des_return;
				return;
			}
		}
		head = head.chain;
	}
};

void() legond_pain1 = [88, legond_pain2]
{
	ai_painforward(MSG_BROADCAST);
};

void() legond_pain2 = [89, legond_pain3]
{
	ai_painforward(AS_MELEE);
};

void() legond_pain3 = [90, legond_pain4]
{
};

void() legond_pain4 = [91, legond_pain5]
{
};

void() legond_pain5 = [92, legond_pain6]
{
	ai_painforward(SPAWNFLAG_LASER);
};

void() legond_pain6 = [93, legond_pain7]
{
	ai_painforward(SECRET_1ST_DOWN);
};

void() legond_pain7 = [92, legond_pain8]
{
	ai_painforward(SPAWNFLAG_LASER);
};

void() legond_pain8 = [91, legond_pain9]
{
	ai_painforward(TE_LIGHTNING1);
};

void() legond_pain9 = [90, legond_pain10]
{
	ai_painforward(TE_LIGHTNING1);
};

void() legond_pain10 = [89, legond_pain11]
{
	ai_painforward(MSG_BROADCAST);
};

void() legond_pain11 = [88, legond_run1]
{
	Legond_Teleport();
};

void(entity attacker, float damage) Legond_Pain = 
{
	if (random() * 275 > damage)
	{
		return;
	}
	if (self.health <= MSG_BROADCAST)
	{
		return;
	}
	if (self.pain_finished > time)
	{
		return;
	}
	if (random() <= 0.5)
	{
		sound(self, CHAN_VOICE, "monsters/legond/lpain1.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	}
	else
	{
		sound(self, CHAN_VOICE, "monsters/legond/lpain2.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	}
	self.pain_finished = time + TE_LIGHTNING1;
	legond_pain1();
};

void() legond_die1 = [94, legond_die2]
{
	sound(self, CHAN_AUTO, "monsters/legond/lpain2.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
};

void() legond_die2 = [95, legond_die3]
{
};

void() legond_die3 = [96, legond_die4]
{
};

void() legond_die4 = [97, legond_die5]
{
	self.solid = SOLID_NOT;
};

void() legond_die5 = [98, legond_die6]
{
	sound(self, CHAN_AUTO, "monsters/legond/ldeath.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
};

void() legond_die6 = [99, legond_die7]
{
};

void() legond_die7 = [100, legond_die8]
{
};

void() legond_die8 = [101, legond_die9]
{
};

void() legond_die9 = [102, legond_die10]
{
};

void() legond_die10 = [103, legond_die11]
{
};

void() legond_die11 = [104, legond_die12]
{
};

void() legond_die12 = [105, legond_die13]
{
};

void() legond_die13 = [106, legond_die14]
{
};

void() legond_die14 = [107, legond_die15]
{
};

void() legond_die15 = [108, legond_die16]
{
};

void() legond_die16 = [109, legond_die17]
{
};

void() legond_die17 = [109, legond_die18]
{
};

void() legond_die18 = [109, legond_die19]
{
};

void() legond_die19 = [109, legond_die20]
{
};

void() legond_die20 = [109, legond_die21]
{
};

void() legond_die21 = [109, legond_die22]
{
};

void() legond_die22 = [109, legond_die23]
{
};

void() legond_die23 = [109, legond_die24]
{
	if (coop != SPAWNFLAG_LASER)
	{
		NextLevel();
	}
};

void() legond_die24 = [109, legond_die24]
{
	CorpseThink();
};

void() monster_legond = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/legond.mdl");
	precache_model("progs/missile2.mdl");
	precache_sound("monsters/legond/legond.wav");
	precache_sound("monsters/legond/legsmak.wav");
	precache_sound("monsters/legond/lpain1.wav");
	precache_sound("monsters/legond/lpain2.wav");
	precache_sound("monsters/legond/lshot.wav");
	precache_sound("monsters/legond/lpull.wav");
	precache_sound("monsters/legond/ldeath.wav");
	precache_sound("monsters/legond/lswipe.wav");
	precache_sound("monsters/legond/lidle.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/legond.mdl");
	setsize(self, '-5 -14 -1', '11 14 53');
	self.health = 3000;
	self.th_stand = legond_stand1;
	self.th_walk = legond_walk1;
	self.th_run = legond_run1;
	self.th_melee = Legond_Melee;
	self.th_pain = Legond_Pain;
	self.th_die = legond_die1;
	self.th_missile = legond_shoot1;
	walkmonster_start();
};

void() legond_teledes = 
{
	self.solid = SOLID_BBOX;
	setmodel(self, "progs/null.mdl");
	self.movetype = MOVETYPE_FLY;
	self.velocity = VEC_ORIGIN;
	setsize(self, VEC_ORIGIN, VEC_ORIGIN);
	self.cnt = SPAWNFLAG_SUPERSPIKE;
	self.nextthink = time + random() * 20;
	self.think = Legond_Des_return;
};

