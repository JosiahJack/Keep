void() baron_block1 = [41, baron_block1]
{
	if (!(self.enemy.owner))
	{
		return;
	}
	if (self.enemy.owner.attack_finished < time && (self.flags & FL_ONGROUND))
	{
		baron_run1();
		return;
	}
	self.block_finished = time + 0.15;
	self.nextthink = time + 0.1;
};

void() baron_idle1 = [6, baron_idle2]
{
	ai_stand();
};

void() baron_idle2 = [7, baron_idle3]
{
	ai_stand();
};

void() baron_idle3 = [8, baron_idle4]
{
	ai_stand();
};

void() baron_idle4 = [9, baron_idle5]
{
	ai_stand();
};

void() baron_idle5 = [10, baron_idle6]
{
	ai_stand();
};

void() baron_idle6 = [11, baron_idle7]
{
	ai_stand();
};

void() baron_idle7 = [12, baron_idle8]
{
	ai_stand();
};

void() baron_idle8 = [13, baron_idle9]
{
	ai_stand();
};

void() baron_idle9 = [14, baron_idle10]
{
	ai_stand();
};

void() baron_idle10 = [15, baron_idle11]
{
	ai_stand();
};

void() baron_idle11 = [16, baron_idle12]
{
	ai_stand();
};

void() baron_idle12 = [17, baron_idle13]
{
	ai_stand();
};

void() baron_idle13 = [18, baron_idle14]
{
	ai_stand();
};

void() baron_idle14 = [19, baron_idle15]
{
	ai_stand();
};

void() baron_idle15 = [20, baron_idle16]
{
	ai_stand();
};

void() baron_idle16 = [21, baron_idle17]
{
	ai_stand();
};

void() baron_idle17 = [22, baron_idle18]
{
	ai_stand();
};

void() baron_idle18 = [23, baron_idle19]
{
	ai_stand();
};

void() baron_idle19 = [24, baron_idle20]
{
	ai_stand();
};

void() baron_idle20 = [25, baron_idle1]
{
	ai_stand();
};

void() baron_run1 = [0, baron_run2]
{
	ai_walk(TE_LAVASPLASH);
};

void() baron_run2 = [1, baron_run3]
{
	ai_walk(TE_LAVASPLASH);
};

void() baron_run3 = [2, baron_run4]
{
	ai_walk(TE_LAVASPLASH);
};

void() baron_run4 = [3, baron_run5]
{
	ai_walk(TE_LAVASPLASH);
};

void() baron_run5 = [4, baron_run6]
{
	ai_walk(TE_LAVASPLASH);
};

void() baron_run6 = [5, baron_run1]
{
	ai_walk(TE_LAVASPLASH);
};

void() baron_point1 = [26, baron_point2]
{
	if (self.origin_x < self.enemy.origin_x)
	{
		self.angles_y = STATE_TOP;
	}
	else
	{
		self.angles_y = 180;
	}
	sound(self, CHAN_VOICE, "baron/sight.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
};

void() baron_point2 = [27, baron_point3]
{
};

void() baron_point3 = [28, baron_point4]
{
};

void() baron_point4 = [29, baron_point5]
{
};

void() baron_point5 = [30, baron_point6]
{
};

void() baron_point6 = [31, baron_point7]
{
};

void() baron_point7 = [32, baron_point8]
{
};

void() baron_point8 = [33, baron_point9]
{
};

void() baron_point9 = [34, baron_point10]
{
};

void() baron_point10 = [35, baron_point11]
{
};

void() baron_point11 = [36, baron_run1]
{
};

void() baron_sight1 = [37, baron_sight2]
{
	sound(self, CHAN_WEAPON, "baron/swordraw.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
};

void() baron_sight2 = [38, baron_sight3]
{
};

void() baron_sight3 = [39, baron_sight4]
{
};

void() baron_sight4 = [40, baron_sight5]
{
};

void() baron_sight5 = [41, baron_sight5]
{
	local float r;
	r = random();
	if (r < 0.5)
	{
		baron_run1();
		return;
	}
	else
	{
		baron_point1();
		return;
	}
};

void() baron_hidesword1 = [41, baron_hidesword2]
{
};

void() baron_hidesword2 = [40, baron_hidesword3]
{
};

void() baron_hidesword3 = [39, baron_hidesword4]
{
};

void() baron_hidesword4 = [38, baron_hidesword4]
{
	if (self.enemy)
	{
		if (!(self.enemy.flypain))
		{
			HuntTarget();
		}
	}
	else
	{
		self.th_stand();
	}
};

void() baron_swing1 = [114, baron_swing2]
{
	frameskip(0.080000);
};

void() baron_swing2 = [115, baron_swing3]
{
	frameskip(0.080000);
};

void() baron_swing3 = [116, baron_swing4]
{
	frameskip(0.080000);
};

void() baron_swing4 = [117, baron_swing5]
{
	sound(self, CHAN_WEAPON, "baron/sword.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	frameskip(0.080000);
};

void() baron_swing5 = [118, baron_swing6]
{
	FireMelee(TE_LAVASPLASH, IT_RELIC5, STATE_TOP, 38, STATE_TOP, STATE_TOP, STATE_TOP);
	frameskip(0.080000);
};

void() baron_swing6 = [119, baron_run1]
{
	FireMelee(TE_LAVASPLASH, IT_RELIC5, AS_MELEE, 38, TE_LIGHTNING1, STATE_TOP, STATE_TOP);
	frameskip(0.080000);
};

void() baron_smash1 = [76, baron_smash2]
{
	frameskip(0.05);
};

void() baron_smash2 = [77, baron_smash3]
{
	frameskip(0.05);
};

void() baron_smash3 = [78, baron_smash4]
{
	frameskip(0.05);
};

void() baron_smash4 = [79, baron_smash5]
{
	frameskip(0.05);
};

void() baron_smash5 = [80, baron_smash6]
{
	frameskip(0.05);
};

void() baron_smash6 = [81, baron_smash7]
{
	frameskip(0.15);
};

void() baron_smash7 = [82, baron_smash8]
{
	frameskip(0.05);
};

void() baron_smash8 = [83, baron_smash9]
{
	local entity effect;
	local entity head;
	effect = spawn();
	setorigin(effect, self.origin + v_forward * SVC_PARTICLE - v_up * IT_RELIC4);
	setmodel(effect, "progs/grounded.mdl");
	effect.solid = SOLID_NOT;
	setsize(effect, '-21 -21 -16', '22 23 31');
	effect.movetype = MOVETYPE_STEP;
	effect.velocity_z = -999;
	effect.think = effect_think;
	effect.alpha = 0.2;
	effect.nextthink = time + 0.1;
	head = searchradius(self.origin, 60);
	while (head)
	{
		if (head.takedamage && head != self && !(head.flags & FL_MONSTER))
		{
			head.knockback = IT_RELIC2;
			T_Damage(head, self, self, IT_RELIC4);
			if (head.classname == "player")
			{
				head.owner.camshake_finished = time + 0.4;
			}
			sound(self, CHAN_WEAPON, "baron/smash.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
		}
		head = head.chain;
	}
	frameskip(PLAT_LOW_TRIGGER);
};

void() baron_smash9 = [84, baron_smash10]
{
	frameskip(0.05);
};

void() baron_smash10 = [85, baron_smash11]
{
	frameskip(0.05);
};

void() baron_smash11 = [86, baron_smash12]
{
	frameskip(0.05);
};

void() baron_smash12 = [87, baron_run1]
{
	frameskip(0.05);
};

void() baron_melee = 
{
	if (random() < 0.5)
	{
		baron_swing1();
	}
	else
	{
		baron_smash1();
	}
};

void() baron_pain1 = [88, baron_pain2]
{
};

void() baron_pain2 = [89, baron_pain3]
{
};

void() baron_pain3 = [90, baron_run1]
{
};

void() baron_pain = 
{
	baron_pain1();
	sound(self, CHAN_VOICE, "baron/pain.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	monster_pain(self.enemy);
};

void() baron_diea1 = [64, baron_diea2]
{
	monster_death();
};

void() baron_diea2 = [65, baron_diea3]
{
	monster_death();
};

void() baron_diea3 = [66, baron_diea4]
{
	monster_death();
};

void() baron_diea4 = [67, baron_diea5]
{
	monster_death();
};

void() baron_diea5 = [68, baron_diea6]
{
	monster_death();
};

void() baron_diea6 = [69, baron_diea6]
{
	monster_death();
};

void() baron_dieb1 = [70, baron_dieb2]
{
	monster_death();
};

void() baron_dieb2 = [71, baron_dieb3]
{
	monster_death();
};

void() baron_dieb3 = [72, baron_dieb4]
{
	monster_death();
};

void() baron_dieb4 = [73, baron_dieb5]
{
	monster_death();
};

void() baron_dieb5 = [74, baron_dieb6]
{
	monster_death();
};

void() baron_dieb6 = [75, baron_dieb6]
{
	monster_death();
};

void() baron_die = 
{
	if (self.gaveexp != 1)
	{
		GiveExperience(150);
		self.gaveexp = 1;
		sound(self, CHAN_VOICE, "baron/death.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
	}
	if (self.damage_type == TE_LIGHTNING1)
	{
		sound(self, CHAN_BODY, "misc/guts.wav", PLAT_LOW_TRIGGER, ATTN_NORM);
		ThrowBodyPart("progs/baron_c1.mdl");
		ThrowBodyPart("progs/baron_c2.mdl");
		remove(self);
		return;
	}
	if (self.knockback != IT_RELIC2 && self.knockback != AS_MELEE)
	{
		self.velocity = no;
		self.flags = self.flags - (self.flags & FL_ONGROUND);
		self.velocity = self.velocity + TE_LIGHTNING3 * v_forward * IT_RELIC4;
		self.velocity = self.velocity + 90 * '0 0 3';
	}
	if (random() > 0.5)
	{
		baron_diea1();
	}
	else
	{
		baron_dieb1();
	}
};

void() baron_jump1 = [108, baron_jump1]
{
	if (self.flags & FL_ONGROUND)
	{
		baron_jump2();
	}
};

void() baron_jump2 = [109, baron_jump3]
{
};

void() baron_jump3 = [110, baron_jump4]
{
};

void() baron_jump4 = [111, baron_jump5]
{
};

void() baron_jump5 = [112, baron_run1]
{
};

void() baron_grabbed1 = [91, baron_grabbed2]
{
	self.grab_finished = time + 0.5;
};

void() baron_grabbed2 = [91, baron_grabbed2]
{
	if (self.grab_finished < time || self.grabbed == 0)
	{
		self.th_run();
		return;
	}
};

void() monster_baron = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/baron.mdl");
	precache_model("progs/baron_c1.mdl");
	precache_model("progs/baron_c2.mdl");
	precache_sound("baron/swordraw.wav");
	precache_sound("baron/sword.wav");
	precache_sound("baron/sight.wav");
	precache_sound("baron/smash.wav");
	precache_sound("baron/pain.wav");
	precache_sound("baron/death.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/baron.mdl");
	if (difficulty < IT_RELIC2)
	{
		self.health = 300;
	}
	else
	{
		self.health = 450;
	}
	self.netname = "solid";
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_NOT;
	self.classname = "baron";
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.th_stand = baron_idle1;
	self.th_misc = baron_sight1;
	self.th_run = baron_run1;
	self.th_grab = baron_grabbed1;
	self.th_pain = baron_pain;
	self.th_die = baron_die;
	self.th_melee = baron_melee;
	self.th_block = baron_block1;
	if (!(self.ai_blockfreq))
	{
		if (difficulty == STATE_TOP)
		{
			self.ai_blockfreq = 0.1;
		}
		else
		{
			if (difficulty == PLAT_LOW_TRIGGER)
			{
				self.ai_blockfreq = 0.3;
			}
			else
			{
				self.ai_blockfreq = 0.5;
			}
		}
	}
	spawn_shadow();
	enemy_start();
};

