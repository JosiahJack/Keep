void() archg_stand1 = [0, archg_stand2]
{
	ai_stand();
};

void() archg_stand2 = [1, archg_stand3]
{
	ai_stand();
};

void() archg_stand3 = [2, archg_stand4]
{
	ai_stand();
};

void() archg_stand4 = [3, archg_stand5]
{
	ai_stand();
};

void() archg_stand5 = [4, archg_stand6]
{
	ai_stand();
};

void() archg_stand6 = [5, archg_stand7]
{
	ai_stand();
};

void() archg_stand7 = [6, archg_stand8]
{
	ai_stand();
};

void() archg_stand8 = [7, archg_stand9]
{
	ai_stand();
};

void() archg_stand9 = [8, archg_stand10]
{
	ai_stand();
};

void() archg_stand10 = [9, archg_stand11]
{
	ai_stand();
};

void() archg_stand11 = [10, archg_stand12]
{
	ai_stand();
};

void() archg_stand12 = [11, archg_stand13]
{
	ai_stand();
};

void() archg_stand13 = [12, archg_stand14]
{
	ai_stand();
};

void() archg_stand14 = [13, archg_stand15]
{
	ai_stand();
};

void() archg_stand15 = [14, archg_stand16]
{
	ai_stand();
};

void() archg_stand16 = [15, archg_stand17]
{
	ai_stand();
};

void() archg_stand17 = [16, archg_stand18]
{
	ai_stand();
};

void() archg_stand18 = [17, archg_stand19]
{
	ai_stand();
};

void() archg_stand19 = [18, archg_stand1]
{
	ai_stand();
};

void() archg_walk1 = [19, archg_walk2]
{
	ai_walk(TE_WIZSPIKE);
};

void() archg_walk2 = [20, archg_walk3]
{
	ai_walk(TE_WIZSPIKE);
};

void() archg_walk3 = [21, archg_walk4]
{
	ai_walk(TE_WIZSPIKE);
};

void() archg_walk4 = [22, archg_walk5]
{
	ai_walk(TE_WIZSPIKE);
};

void() archg_walk5 = [23, archg_walk6]
{
	ai_walk(TE_WIZSPIKE);
};

void() archg_walk6 = [24, archg_walk7]
{
	ai_walk(TE_WIZSPIKE);
};

void() archg_walk7 = [25, archg_walk8]
{
	ai_walk(TE_WIZSPIKE);
};

void() archg_walk8 = [26, archg_walk9]
{
	ai_walk(TE_WIZSPIKE);
};

void() archg_walk9 = [27, archg_walk10]
{
	ai_walk(TE_WIZSPIKE);
};

void() archg_walk10 = [28, archg_walk11]
{
	ai_walk(TE_WIZSPIKE);
};

void() archg_walk11 = [29, archg_walk12]
{
	ai_walk(TE_WIZSPIKE);
};

void() archg_walk12 = [30, archg_walk13]
{
	ai_walk(TE_WIZSPIKE);
};

void() archg_walk13 = [31, archg_walk14]
{
	ai_walk(TE_WIZSPIKE);
};

void() archg_walk14 = [32, archg_walk1]
{
	ai_walk(TE_WIZSPIKE);
};

void() archg_charge1 = [33, archg_charge2]
{
	spawn_magicfog();
};

void() archg_charge2 = [34, archg_charge3]
{
};

void() archg_charge3 = [35, archg_charge4]
{
};

void() archg_charge4 = [36, archg_charge5]
{
};

void() archg_charge5 = [37, archg_charge6]
{
};

void() archg_charge6 = [38, archg_charge7]
{
};

void() archg_charge7 = [39, archg_charge8]
{
};

void() archg_charge8 = [40, archg_charge9]
{
};

void() archg_charge9 = [41, archg_charge10]
{
};

void() archg_charge10 = [42, archg_charge11]
{
};

void() archg_charge11 = [43, archg_charge12]
{
};

void() archg_charge12 = [44, archg_charge13]
{
};

void() archg_charge13 = [45, archg_charge14]
{
};

void() archg_charge14 = [46, archg_charge15]
{
};

void() archg_charge15 = [47, archg_charge15]
{
	local entity effect;
	if (self.ammo_shells < 200)
	{
		effect = spawn();
		setorigin(effect, self.origin - v_up * IT_RELIC4);
		setmodel(effect, "progs/grounded.mdl");
		effect.solid = SOLID_NOT;
		setsize(effect, '-21 -21 -16', '22 23 31');
		effect.movetype = MOVETYPE_FLY;
		effect.think = effect_think;
		effect.alpha = 0.2;
		effect.nextthink = time + 0.1;
		sound(self, CHAN_BODY, "gaunt/charge.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
		self.ammo_shells = self.ammo_shells + TE_LIGHTNING2;
	}
	else
	{
		archg_charge16();
	}
};

void() archg_charge16 = [46, archg_charge17]
{
};

void() archg_charge17 = [45, archg_charge18]
{
};

void() archg_charge18 = [44, archg_charge19]
{
};

void() archg_charge19 = [43, archg_charge20]
{
};

void() archg_charge20 = [42, archg_charge21]
{
};

void() archg_charge21 = [41, archg_charge22]
{
};

void() archg_charge22 = [40, archg_charge23]
{
};

void() archg_charge23 = [39, archg_charge24]
{
};

void() archg_charge24 = [38, archg_charge25]
{
};

void() archg_charge25 = [37, archg_charge26]
{
};

void() archg_charge26 = [36, archg_charge27]
{
};

void() archg_charge27 = [35, archg_charge28]
{
};

void() archg_charge28 = [34, archg_charge29]
{
};

void() archg_charge29 = [33, archg_walk1]
{
};

void() archg_melee1 = [81, archg_melee2]
{
};

void() archg_melee2 = [82, archg_melee3]
{
};

void() archg_melee3 = [83, archg_melee4]
{
};

void() archg_melee4 = [84, archg_melee5]
{
};

void() archg_melee5 = [85, archg_melee6]
{
};

void() archg_melee6 = [86, archg_melee7]
{
	FireMelee(STATE_TOP, SVC_CLIENTDATA, AS_MELEE, 50, 99, STATE_TOP, STATE_TOP);
};

void() archg_melee7 = [87, archg_melee8]
{
};

void() archg_melee8 = [88, archg_melee9]
{
};

void() archg_melee9 = [89, archg_melee10]
{
};

void() archg_melee10 = [90, archg_melee11]
{
};

void() archg_melee11 = [91, archg_walk1]
{
};

void() archg_fireball1 = [59, archg_fireball2]
{
	spawn_magicfog();
};

void() archg_fireball2 = [60, archg_fireball3]
{
};

void() archg_fireball3 = [61, archg_fireball4]
{
};

void() archg_fireball4 = [62, archg_fireball5]
{
};

void() archg_fireball5 = [63, archg_fireball6]
{
	Fireball(TE_LIGHTNING2, TE_WIZSPIKE);
};

void() archg_fireball6 = [64, archg_fireball7]
{
	Fireball(TE_LIGHTNING2, AS_MELEE);
};

void() archg_fireball7 = [65, archg_fireball8]
{
};

void() archg_fireball8 = [66, archg_fireball9]
{
};

void() archg_fireball9 = [67, archg_walk1]
{
};

void() archg_lightning1 = [48, archg_lightning2]
{
	spawn_magicfog();
};

void() archg_lightning2 = [49, archg_lightning3]
{
};

void() archg_lightning3 = [50, archg_lightning4]
{
};

void() archg_lightning4 = [51, archg_lightning5]
{
};

void() archg_lightning5 = [52, archg_lightning6]
{
};

void() archg_lightning6 = [53, archg_lightning7]
{
};

void() archg_lightning7 = [54, archg_lightning8]
{
	sound(self, CHAN_AUTO, "spells/lightn.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
};

void() archg_lightning8 = [55, archg_lightning8]
{
	if (self.lcount > 50)
	{
		archg_lightning9();
	}
	else
	{
		LightningStorm();
	}
	self.lcount = self.lcount + PLAT_LOW_TRIGGER;
};

void() archg_lightning9 = [56, archg_lightning10]
{
};

void() archg_lightning10 = [57, archg_lightning11]
{
};

void() archg_lightning11 = [58, archg_walk1]
{
};

void() archg_icefield1 = [48, archg_icefield2]
{
	local entity effect;
	spawn_magicfog();
	effect = spawn();
	setorigin(effect, self.origin + v_up * 50);
	setmodel(effect, "progs/chargice.spr");
	effect.movetype = MOVETYPE_NONE;
	effect.solid = SOLID_NOT;
	effect.alpha = 0.2;
	effect.think = chargeice_effect;
	effect.nextthink = time + 0.010000;
	sound(effect, CHAN_AUTO, "spells/charge.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	self.nextthink = time + 0.3;
};

void() archg_icefield2 = [49, archg_icefield3]
{
};

void() archg_icefield3 = [50, archg_icefield4]
{
};

void() archg_icefield4 = [51, archg_icefield5]
{
};

void() archg_icefield5 = [52, archg_icefield6]
{
};

void() archg_icefield6 = [53, archg_icefield7]
{
};

void() archg_icefield7 = [54, archg_icefield8]
{
};

void() archg_icefield8 = [55, archg_icefield9]
{
};

void() archg_icefield9 = [56, archg_icefield10]
{
};

void() archg_icefield10 = [57, archg_icefield11]
{
};

void() archg_icefield11 = [58, archg_walk1]
{
	IceField();
};

void() archg_magic = 
{
	self.lcount = STATE_TOP;
	if (self.ammo_shells <= TE_LIGHTNING3)
	{
		archg_charge1();
		return;
	}
	if (self.ammo_shells < TE_LAVASPLASH)
	{
		archg_fireball1();
		self.ammo_shells = STATE_TOP;
		return;
	}
	if (random() < 0.3 && self.ammo_shells > TE_LIGHTNING3)
	{
		archg_fireball1();
		self.ammo_shells = self.ammo_shells - TE_LAVASPLASH;
	}
	else
	{
		if (random() < 0.7 && self.ammo_shells > 44)
		{
			archg_lightning1();
			self.ammo_shells = self.ammo_shells - 45;
		}
		else
		{
			if (self.ammo_shells > SVC_SETPAUSE && self.attack_finished < time && self.enemy.onground == 1)
			{
				self.attack_finished = time + AS_MELEE;
				archg_icefield1();
				self.ammo_shells = self.ammo_shells - SVC_SIGNONNUM;
			}
		}
	}
};

void() archg_pain1 = [67, archg_walk1]
{
};

void() archg_pain = 
{
	archg_pain1();
	sound(self, CHAN_VOICE, "archg/pain.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	monster_pain(self.enemy);
};

void() archg_death1 = [68, archg_death2]
{
	monster_death();
};

void() archg_death2 = [69, archg_death3]
{
	monster_death();
};

void() archg_death3 = [70, archg_death4]
{
	monster_death();
};

void() archg_death4 = [71, archg_death5]
{
	monster_death();
};

void() archg_death5 = [72, archg_death6]
{
	monster_death();
};

void() archg_death6 = [73, archg_death7]
{
	monster_death();
};

void() archg_death7 = [74, archg_death8]
{
	monster_death();
};

void() archg_death8 = [75, archg_death9]
{
	monster_death();
};

void() archg_death9 = [76, archg_death10]
{
	monster_death();
};

void() archg_death10 = [77, archg_death11]
{
	monster_death();
};

void() archg_death11 = [78, archg_death12]
{
	monster_death();
};

void() archg_death12 = [79, archg_death13]
{
	monster_death();
};

void() archg_death13 = [80, archg_death13]
{
	monster_death();
};

void() archg_die = 
{
	self.velocity = no;
	if (self.gaveexp != 1)
	{
		sound(self, CHAN_VOICE, "archg/death.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
		GiveExperience(65);
		self.movetype = MOVETYPE_TOSS;
		self.gaveexp = 1;
	}
	if (self.knockback != IT_RELIC2 && self.knockback != AS_MELEE)
	{
		self.velocity = no;
	}
	archg_death1();
};

void() archg_melee = 
{
	if (random() < 0.1 && self.ammo_shells > SVC_SETPAUSE && self.attack_finished < time && self.enemy.onground == 1)
	{
		archg_icefield1();
		self.ammo_shells = self.ammo_shells - SVC_SIGNONNUM;
		self.attack_finished = time + AS_MELEE;
	}
	else
	{
		archg_melee1();
	}
};

void() monster_archghoul = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/archg.mdl");
	precache_sound("archg/pain.wav");
	precache_sound("archg/death.wav");
	precache_sound("gaunt/charge.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/archg.mdl");
	if (difficulty < IT_RELIC2)
	{
		self.health = 225;
	}
	else
	{
		self.health = 338;
	}
	self.netname = "solid";
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_NOT;
	self.classname = "archg";
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.ammo_shells = 200;
	self.th_stand = archg_stand1;
	self.th_walk = archg_walk1;
	self.th_pain = archg_pain;
	self.th_die = archg_die;
	self.th_grab = archg_melee;
	self.th_melee = archg_melee;
	self.th_magic = archg_magic;
	spawn_shadow();
	enemy_start();
};

