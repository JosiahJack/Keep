void() gaunt_talk = 
{
	local float rs;
	rs = rint(random() * SVC_UPDATENAME + PLAT_LOW_TRIGGER);
	if (rs == PLAT_LOW_TRIGGER)
	{
		self.noise = "gaunt/talk1.wav";
	}
	if (rs == IT_RELIC2)
	{
		self.noise = "gaunt/talk2.wav";
	}
	if (rs == AS_MELEE)
	{
		self.noise = "gaunt/talk3.wav";
	}
	if (rs == IT_RELIC3)
	{
		self.noise = "gaunt/talk4.wav";
	}
	if (rs == TE_LIGHTNING1)
	{
		self.noise = "gaunt/talk5.wav";
	}
	if (rs == TE_LIGHTNING2)
	{
		self.noise = "gaunt/talk6.wav";
	}
	if (rs == TE_WIZSPIKE)
	{
		self.noise = "gaunt/talk7.wav";
	}
	if (rs == IT_RELIC4)
	{
		self.noise = "gaunt/talk8.wav";
	}
	if (rs == TE_LIGHTNING3)
	{
		self.noise = "gaunt/talk9.wav";
	}
	if (rs == TE_LAVASPLASH)
	{
		self.noise = "gaunt/talk10.wav";
	}
	if (rs == TE_TELEPORT)
	{
		self.noise = "gaunt/talk11.wav";
	}
	if (rs == SVC_LIGHTSTYLE)
	{
		self.noise = "gaunt/talk12.wav";
	}
	if (rs == SVC_UPDATENAME)
	{
		self.noise = "gaunt/talk13.wav";
	}
	if (rs == SVC_UPDATEFRAGS)
	{
		self.noise = "gaunt/talk14.wav";
	}
	sound(self, CHAN_VOICE, self.noise, PLAT_LOW_TRIGGER, ATTN_NORM);
};

void() gaunt_scream = 
{
	local float rs;
	rs = rint(random() * TE_WIZSPIKE + PLAT_LOW_TRIGGER);
	if (rs == PLAT_LOW_TRIGGER)
	{
		self.noise = "gaunt/scream1.wav";
	}
	if (rs == IT_RELIC2)
	{
		self.noise = "gaunt/scream2.wav";
	}
	if (rs == AS_MELEE)
	{
		self.noise = "gaunt/scream3.wav";
	}
	if (rs == IT_RELIC3)
	{
		self.noise = "gaunt/scream4.wav";
	}
	if (rs == TE_LIGHTNING1)
	{
		self.noise = "gaunt/scream5.wav";
	}
	if (rs == TE_LIGHTNING2)
	{
		self.noise = "gaunt/scream6.wav";
	}
	if (rs == TE_WIZSPIKE)
	{
		self.noise = "gaunt/scream7.wav";
	}
	if (rs == IT_RELIC4)
	{
		self.noise = "gaunt/scream8.wav";
	}
	sound(self, CHAN_VOICE, self.noise, PLAT_LOW_TRIGGER, ATTN_NORM);
};

void() gaunt_stand1 = [0, gaunt_stand2]
{
	ai_stand();
};

void() gaunt_stand2 = [1, gaunt_stand3]
{
	ai_stand();
};

void() gaunt_stand3 = [2, gaunt_stand4]
{
	ai_stand();
};

void() gaunt_stand4 = [3, gaunt_stand5]
{
	ai_stand();
};

void() gaunt_stand5 = [4, gaunt_stand6]
{
	ai_stand();
};

void() gaunt_stand6 = [5, gaunt_stand7]
{
	ai_stand();
};

void() gaunt_stand7 = [6, gaunt_stand8]
{
	ai_stand();
};

void() gaunt_stand8 = [7, gaunt_stand9]
{
	ai_stand();
};

void() gaunt_stand9 = [8, gaunt_stand10]
{
	ai_stand();
};

void() gaunt_stand10 = [9, gaunt_stand11]
{
	ai_stand();
};

void() gaunt_stand11 = [10, gaunt_stand12]
{
	ai_stand();
};

void() gaunt_stand12 = [11, gaunt_stand1]
{
	ai_stand();
};

void() gaunt_walk1 = [12, gaunt_walk2]
{
	ai_walk(AS_MELEE);
};

void() gaunt_walk2 = [13, gaunt_walk3]
{
	ai_walk(AS_MELEE);
};

void() gaunt_walk3 = [14, gaunt_walk4]
{
	ai_walk(AS_MELEE);
};

void() gaunt_walk4 = [15, gaunt_walk5]
{
	ai_walk(AS_MELEE);
};

void() gaunt_walk5 = [16, gaunt_walk6]
{
	ai_walk(AS_MELEE);
};

void() gaunt_walk6 = [17, gaunt_walk7]
{
	ai_walk(AS_MELEE);
};

void() gaunt_walk7 = [18, gaunt_walk8]
{
	ai_walk(AS_MELEE);
};

void() gaunt_walk8 = [19, gaunt_walk9]
{
	ai_walk(AS_MELEE);
};

void() gaunt_walk9 = [20, gaunt_walk10]
{
	ai_walk(AS_MELEE);
};

void() gaunt_walk10 = [21, gaunt_walk1]
{
	ai_walk(AS_MELEE);
};

void() gaunt_run1 = [93, gaunt_run2]
{
	ai_walk(SVC_UPDATENAME);
};

void() gaunt_run2 = [94, gaunt_run3]
{
	ai_walk(SVC_UPDATENAME);
};

void() gaunt_run3 = [95, gaunt_run4]
{
	ai_walk(SVC_UPDATENAME);
};

void() gaunt_run4 = [96, gaunt_run5]
{
	ai_walk(SVC_UPDATENAME);
};

void() gaunt_run5 = [97, gaunt_run6]
{
	ai_walk(SVC_UPDATENAME);
};

void() gaunt_run6 = [98, gaunt_run1]
{
	ai_walk(SVC_UPDATENAME);
};

void() gaunt_pain1 = [47, gaunt_pain2]
{
};

void() gaunt_pain2 = [48, gaunt_pain3]
{
};

void() gaunt_pain3 = [49, gaunt_pain4]
{
};

void() gaunt_pain4 = [50, gaunt_pain5]
{
};

void() gaunt_pain5 = [51, gaunt_pain6]
{
};

void() gaunt_pain6 = [52, gaunt_run1]
{
};

void() gaunt_finger1 = [58, gaunt_finger2]
{
	gaunt_talk();
	frameskip(0.020000);
};

void() gaunt_finger2 = [59, gaunt_finger3]
{
	frameskip(0.020000);
};

void() gaunt_finger3 = [60, gaunt_finger4]
{
	frameskip(0.020000);
};

void() gaunt_finger4 = [61, gaunt_finger5]
{
	frameskip(0.020000);
};

void() gaunt_finger5 = [62, gaunt_finger6]
{
	frameskip(0.020000);
};

void() gaunt_finger6 = [63, gaunt_finger7]
{
	frameskip(0.020000);
};

void() gaunt_finger7 = [64, gaunt_finger8]
{
	frameskip(0.020000);
};

void() gaunt_finger8 = [65, gaunt_finger9]
{
	frameskip(0.020000);
};

void() gaunt_finger9 = [66, gaunt_finger10]
{
};

void() gaunt_finger10 = [67, gaunt_finger11]
{
};

void() gaunt_finger11 = [68, gaunt_finger12]
{
	FireMelee(STATE_TOP, SVC_CLIENTDATA, AS_MELEE, 50, 99, STATE_TOP, STATE_TOP);
};

void() gaunt_finger12 = [65, gaunt_finger13]
{
};

void() gaunt_finger13 = [64, gaunt_finger14]
{
};

void() gaunt_finger14 = [63, gaunt_finger15]
{
};

void() gaunt_finger15 = [62, gaunt_finger16]
{
};

void() gaunt_finger16 = [61, gaunt_finger17]
{
};

void() gaunt_finger17 = [60, gaunt_finger18]
{
};

void() gaunt_finger18 = [59, gaunt_finger19]
{
};

void() gaunt_finger19 = [58, gaunt_run1]
{
};

void() gaunt_pain = 
{
	if (self.beams_shot != STATE_TOP)
	{
		self.beams_shot = STATE_TOP;
	}
	sound(self, CHAN_VOICE, "gaunt/pain.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	gaunt_pain1();
	monster_pain(self.enemy);
};

void() gaunt_die1 = [0, gaunt_die2]
{
	monster_death();
};

void() gaunt_die2 = [1, gaunt_die3]
{
	monster_death();
};

void() gaunt_die3 = [2, gaunt_die4]
{
	monster_death();
};

void() gaunt_die4 = [3, gaunt_die5]
{
	monster_death();
};

void() gaunt_die5 = [4, gaunt_die5]
{
	if (self.flags & FL_ONGROUND)
	{
		sound(self, CHAN_BODY, "misc/guts.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
		ThrowGib("progs/gib2.mdl");
		ThrowGib("progs/gib3.mdl");
		ThrowGib("progs/gib3.mdl");
		ThrowGib("progs/gib3.mdl");
		ThrowGib("progs/gib1.mdl");
		ThrowGib("progs/gib1.mdl");
		ThrowGib("progs/gib1.mdl");
		ThrowGib("progs/gib1.mdl");
		remove(self);
		return;
	}
	monster_death();
};

void() gaunt_die = 
{
	if (self.beams_shot != STATE_TOP)
	{
		self.beams_shot = STATE_TOP;
	}
	setmodel(self, "progs/b_gaunt.mdl");
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	if (self.gaveexp != 1)
	{
		GiveExperience(41);
		self.movetype = MOVETYPE_TOSS;
		self.avelocity = '100 100 0';
		self.gaveexp = 1;
		ThrowHead("progs/h_gaunt.mdl", self.origin + v_up * SVC_SETPAUSE, self);
		sound(self, CHAN_VOICE, "gaunt/death.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	}
	if (self.knockback != IT_RELIC2 && self.knockback != AS_MELEE)
	{
		self.velocity = no;
	}
	gaunt_die1();
};

void() gaunt_grabbed1 = [49, gaunt_grabbed2]
{
	self.grab_finished = time + 0.8;
};

void() gaunt_grabbed2 = [49, gaunt_grabbed2]
{
	if (self.grab_finished < time || self.grabbed == 0)
	{
		self.th_run();
		return;
	}
};

void() gaunt_firebolt1 = [22, gaunt_firebolt2]
{
	spawn_magicfog();
};

void() gaunt_firebolt2 = [23, gaunt_firebolt3]
{
};

void() gaunt_firebolt3 = [24, gaunt_firebolt4]
{
};

void() gaunt_firebolt4 = [25, gaunt_firebolt5]
{
};

void() gaunt_firebolt5 = [26, gaunt_firebolt6]
{
};

void() gaunt_firebolt6 = [27, gaunt_firebolt7]
{
};

void() gaunt_firebolt7 = [28, gaunt_firebolt8]
{
	Fireball(TE_WIZSPIKE, SVC_CLIENTDATA);
};

void() gaunt_firebolt8 = [29, gaunt_firebolt9]
{
};

void() gaunt_firebolt9 = [30, gaunt_firebolt10]
{
};

void() gaunt_firebolt10 = [31, gaunt_run1]
{
};

void() gaunt_fireball1 = [32, gaunt_fireball2]
{
	spawn_magicfog();
};

void() gaunt_fireball2 = [33, gaunt_fireball3]
{
};

void() gaunt_fireball3 = [34, gaunt_fireball4]
{
};

void() gaunt_fireball4 = [35, gaunt_fireball5]
{
};

void() gaunt_fireball5 = [36, gaunt_fireball6]
{
};

void() gaunt_fireball6 = [37, gaunt_fireball7]
{
};

void() gaunt_fireball7 = [38, gaunt_fireball8]
{
};

void() gaunt_fireball8 = [39, gaunt_fireball9]
{
};

void() gaunt_fireball9 = [40, gaunt_fireball10]
{
};

void() gaunt_fireball10 = [41, gaunt_fireball11]
{
};

void() gaunt_fireball11 = [42, gaunt_fireball12]
{
	Fireball(TE_LIGHTNING1, SVC_CLIENTDATA);
};

void() gaunt_fireball12 = [43, gaunt_fireball13]
{
	Fireball(TE_LIGHTNING1, SVC_CLIENTDATA);
};

void() gaunt_fireball13 = [44, gaunt_fireball14]
{
	Fireball(TE_LIGHTNING1, SVC_CLIENTDATA);
};

void() gaunt_fireball14 = [45, gaunt_fireball15]
{
};

void() gaunt_fireball15 = [46, gaunt_run1]
{
};

void() gaunt_firebeam1 = [69, gaunt_firebeam2]
{
	local entity effect;
	spawn_magicfog();
	effect = spawn();
	setorigin(effect, self.origin);
	setmodel(effect, "progs/chrgebm.spr");
	effect.movetype = MOVETYPE_NONE;
	effect.solid = SOLID_NOT;
	effect.alpha = 0.2;
	effect.think = chargebeam_effect;
	effect.nextthink = time + 0.010000;
	sound(effect, CHAN_AUTO, "spells/charge.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
};

void() gaunt_firebeam2 = [70, gaunt_firebeam3]
{
};

void() gaunt_firebeam3 = [71, gaunt_firebeam4]
{
	self.nextthink = time + 0.7;
};

void() gaunt_firebeam4 = [72, gaunt_firebeam5]
{
};

void() gaunt_firebeam5 = [73, gaunt_firebeam6]
{
};

void() gaunt_firebeam6 = [74, gaunt_firebeam7]
{
};

void() gaunt_firebeam7 = [75, gaunt_firebeam8]
{
};

void() gaunt_firebeam8 = [76, gaunt_firebeam9]
{
};

void() gaunt_firebeam9 = [77, gaunt_firebeam10]
{
};

void() gaunt_firebeam10 = [78, gaunt_firebeam11]
{
};

void() gaunt_firebeam11 = [79, gaunt_firebeam12]
{
};

void() gaunt_firebeam12 = [80, gaunt_firebeam13]
{
};

void() gaunt_firebeam13 = [81, gaunt_firebeam14]
{
	if (self.beams_shot < SVC_INTERMISSION)
	{
		Firebeam(IT_RELIC2, SVC_LIGHTSTYLE);
		self.beams_shot = self.beams_shot + PLAT_LOW_TRIGGER;
	}
	else
	{
		self.beams_shot = STATE_TOP;
		gaunt_run1();
	}
	if (self.beams_shot <= PLAT_LOW_TRIGGER)
	{
		Firebeam_Muzzle();
	}
};

void() gaunt_firebeam14 = [82, gaunt_firebeam15]
{
	if (self.beams_shot < SVC_INTERMISSION)
	{
		Firebeam(PLAT_LOW_TRIGGER, SVC_LIGHTSTYLE);
		self.beams_shot = self.beams_shot + PLAT_LOW_TRIGGER;
	}
	else
	{
		self.beams_shot = STATE_TOP;
		gaunt_run1();
	}
};

void() gaunt_firebeam15 = [83, gaunt_firebeam13]
{
	if (self.beams_shot < SVC_INTERMISSION)
	{
		Firebeam(PLAT_LOW_TRIGGER, SVC_CLIENTDATA);
		self.beams_shot = self.beams_shot + PLAT_LOW_TRIGGER;
	}
	else
	{
		self.beams_shot = STATE_TOP;
		gaunt_run1();
	}
};

void() gaunt_charge1 = [84, gaunt_charge2]
{
	spawn_magicfog();
};

void() gaunt_charge2 = [85, gaunt_charge3]
{
};

void() gaunt_charge3 = [86, gaunt_charge4]
{
};

void() gaunt_charge4 = [87, gaunt_charge5]
{
};

void() gaunt_charge5 = [88, gaunt_charge6]
{
};

void() gaunt_charge6 = [89, gaunt_charge7]
{
};

void() gaunt_charge7 = [90, gaunt_charge8]
{
};

void() gaunt_charge8 = [91, gaunt_charge9]
{
};

void() gaunt_charge9 = [92, gaunt_charge9]
{
	local entity effect;
	if (self.ammo_shells < 150)
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
		self.ammo_shells = self.ammo_shells + AS_MELEE;
	}
	else
	{
		gaunt_charge10();
	}
};

void() gaunt_charge10 = [91, gaunt_charge11]
{
};

void() gaunt_charge11 = [90, gaunt_charge12]
{
};

void() gaunt_charge12 = [89, gaunt_charge13]
{
};

void() gaunt_charge13 = [88, gaunt_charge14]
{
};

void() gaunt_charge14 = [87, gaunt_charge15]
{
};

void() gaunt_charge15 = [86, gaunt_charge16]
{
};

void() gaunt_charge16 = [85, gaunt_charge17]
{
};

void() gaunt_charge17 = [84, gaunt_run1]
{
};

void() gaunt_magic = 
{
	gaunt_scream();
	if (self.ammo_shells <= TE_LIGHTNING3)
	{
		gaunt_charge1();
		return;
	}
	if (self.ammo_shells < TE_LAVASPLASH)
	{
		gaunt_firebolt1();
		self.ammo_shells = STATE_TOP;
		return;
	}
	if (random() < 0.4 && self.ammo_shells > TE_LIGHTNING3)
	{
		gaunt_firebolt1();
		self.ammo_shells = self.ammo_shells - TE_LAVASPLASH;
	}
	else
	{
		if (random() < 0.7 && self.ammo_shells > SVC_SETPAUSE)
		{
			gaunt_fireball1();
			self.ammo_shells = self.ammo_shells - SVC_SIGNONNUM;
		}
		else
		{
			if (self.ammo_shells > 74)
			{
				gaunt_firebeam1();
				self.ammo_shells = self.ammo_shells - 75;
			}
		}
	}
};

void() monster_gaunt = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/gaunt.mdl");
	precache_model("progs/b_gaunt.mdl");
	precache_model("progs/h_gaunt.mdl");
	precache_sound("gaunt/charge.wav");
	precache_sound("gaunt/pain.wav");
	precache_sound("gaunt/death.wav");
	precache_sound("gaunt/talk1.wav");
	precache_sound("gaunt/talk2.wav");
	precache_sound("gaunt/talk3.wav");
	precache_sound("gaunt/talk4.wav");
	precache_sound("gaunt/talk5.wav");
	precache_sound("gaunt/talk6.wav");
	precache_sound("gaunt/talk7.wav");
	precache_sound("gaunt/talk8.wav");
	precache_sound("gaunt/talk9.wav");
	precache_sound("gaunt/talk10.wav");
	precache_sound("gaunt/talk11.wav");
	precache_sound("gaunt/talk12.wav");
	precache_sound("gaunt/talk13.wav");
	precache_sound("gaunt/talk14.wav");
	precache_sound("gaunt/scream1.wav");
	precache_sound("gaunt/scream2.wav");
	precache_sound("gaunt/scream3.wav");
	precache_sound("gaunt/scream4.wav");
	precache_sound("gaunt/scream5.wav");
	precache_sound("gaunt/scream6.wav");
	precache_sound("gaunt/scream7.wav");
	precache_sound("gaunt/scream8.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/gaunt.mdl");
	if (difficulty < IT_RELIC2)
	{
		self.health = 175;
	}
	else
	{
		self.health = 263;
	}
	self.netname = "solid";
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_NOT;
	self.classname = "gaunt";
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.ammo_shells = 150;
	self.th_stand = gaunt_stand1;
	self.th_walk = gaunt_walk1;
	self.th_run = gaunt_run1;
	self.th_grab = gaunt_grabbed1;
	self.th_pain = gaunt_pain;
	self.th_die = gaunt_die;
	self.th_melee = gaunt_finger1;
	self.th_magic = gaunt_magic;
	spawn_shadow();
	enemy_start();
};

