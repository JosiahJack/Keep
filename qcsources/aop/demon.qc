void() demon1_stand1 = [0, demon1_stand2]
{
	ai_stand();
};

void() demon1_stand2 = [1, demon1_stand3]
{
	ai_stand();
};

void() demon1_stand3 = [2, demon1_stand4]
{
	ai_stand();
};

void() demon1_stand4 = [3, demon1_stand5]
{
	ai_stand();
};

void() demon1_stand5 = [4, demon1_stand6]
{
	ai_stand();
};

void() demon1_stand6 = [5, demon1_stand7]
{
	ai_stand();
};

void() demon1_stand7 = [6, demon1_stand8]
{
	ai_stand();
};

void() demon1_stand8 = [7, demon1_stand9]
{
	ai_stand();
};

void() demon1_stand9 = [8, demon1_stand10]
{
	ai_stand();
};

void() demon1_stand10 = [9, demon1_stand11]
{
	ai_stand();
};

void() demon1_stand11 = [10, demon1_stand12]
{
	ai_stand();
};

void() demon1_stand12 = [11, demon1_stand13]
{
	ai_stand();
};

void() demon1_stand13 = [12, demon1_stand1]
{
	ai_stand();
};

void() demon1_walk1 = [13, demon1_walk2]
{
	if (random() < 0.2)
	{
		sound(self, CHAN_VOICE, "demon/idle1.wav", SPAWNFLAG_SUPERSPIKE, ATTN_IDLE);
	}
	ai_walk(SECRET_NO_SHOOT);
};

void() demon1_walk2 = [14, demon1_walk3]
{
	ai_walk(TE_LIGHTNING2);
};

void() demon1_walk3 = [15, demon1_walk4]
{
	ai_walk(TE_LIGHTNING2);
};

void() demon1_walk4 = [16, demon1_walk5]
{
	ai_walk(TE_WIZSPIKE);
};

void() demon1_walk5 = [17, demon1_walk6]
{
	ai_walk(SECRET_1ST_DOWN);
};

void() demon1_walk6 = [18, demon1_walk7]
{
	ai_walk(TE_LIGHTNING2);
};

void() demon1_walk7 = [19, demon1_walk8]
{
	ai_walk(TE_LAVASPLASH);
};

void() demon1_walk8 = [20, demon1_walk1]
{
	ai_walk(TE_LAVASPLASH);
};

void() demon1_run1 = [21, demon1_run2]
{
	if (random() < 0.2)
	{
		sound(self, CHAN_VOICE, "demon/idle1.wav", SPAWNFLAG_SUPERSPIKE, ATTN_IDLE);
	}
	ai_run(20);
};

void() demon1_run2 = [22, demon1_run3]
{
	ai_run(15);
};

void() demon1_run3 = [23, demon1_run4]
{
	ai_run(36);
};

void() demon1_run4 = [24, demon1_run5]
{
	ai_run(20);
};

void() demon1_run5 = [25, demon1_run6]
{
	ai_run(15);
};

void() demon1_run6 = [26, demon1_run1]
{
	ai_run(36);
};

void() demon1_jump1 = [27, demon1_jump2]
{
	ai_face();
};

void() demon1_jump2 = [28, demon1_jump3]
{
	ai_face();
};

void() demon1_jump3 = [29, demon1_jump4]
{
	ai_face();
};

void() demon1_jump4 = [30, demon1_jump5]
{
	if (self.health <= counter)
	{
		dprint("demon1_jump4: dead\n");
		self.touch = SUB_Null;
		self.think = demon1_die1;
		return;
	}
	ai_face();
	self.touch = Demon_JumpTouch;
	makevectors(self.angles);
	self.origin_z = self.origin_z + SPAWNFLAG_SUPERSPIKE;
	self.velocity = v_forward * 600 + '0 0 250';
	if (self.flags & FL_ONGROUND)
	{
		self.flags = self.flags - FL_ONGROUND;
	}
};

void() demon1_jump5 = [31, demon1_jump6]
{
};

void() demon1_jump6 = [32, demon1_jump7]
{
};

void() demon1_jump7 = [33, demon1_jump8]
{
};

void() demon1_jump8 = [34, demon1_jump9]
{
};

void() demon1_jump9 = [35, demon1_jump10]
{
};

void() demon1_jump10 = [36, demon1_jump1]
{
	if (self.exptime == counter)
	{
		self.nextthink = time + AS_MELEE;
	}
};

void() demon1_jump11 = [37, demon1_jump12]
{
};

void() demon1_jump12 = [38, demon1_run1]
{
};

void() demon1_atta1 = [54, demon1_atta2]
{
	ai_charge(SECRET_1ST_DOWN);
};

void() demon1_atta2 = [55, demon1_atta3]
{
	ai_charge(counter);
};

void() demon1_atta3 = [56, demon1_atta4]
{
	ai_charge(counter);
};

void() demon1_atta4 = [57, demon1_atta5]
{
	ai_charge(SPAWNFLAG_SUPERSPIKE);
};

void() demon1_atta5 = [58, demon1_atta6]
{
	ai_charge(SPAWNFLAG_LASER);
	Demon_Melee(200);
};

void() demon1_atta6 = [59, demon1_atta7]
{
	ai_charge(SPAWNFLAG_SUPERSPIKE);
};

void() demon1_atta7 = [60, demon1_atta8]
{
	ai_charge(TE_LIGHTNING2);
};

void() demon1_atta8 = [61, demon1_atta9]
{
	ai_charge(SECRET_NO_SHOOT);
};

void() demon1_atta9 = [62, demon1_atta10]
{
	ai_charge(SECRET_1ST_DOWN);
};

void() demon1_atta10 = [63, demon1_atta11]
{
	ai_charge(SPAWNFLAG_LASER);
};

void() demon1_atta11 = [64, demon1_atta12]
{
	Demon_Melee(-200);
};

void() demon1_atta12 = [65, demon1_atta13]
{
	ai_charge(TE_LIGHTNING1);
};

void() demon1_atta13 = [66, demon1_atta14]
{
	ai_charge(SECRET_NO_SHOOT);
};

void() demon1_atta14 = [67, demon1_atta15]
{
	ai_charge(SECRET_1ST_DOWN);
};

void() demon1_atta15 = [68, demon1_run1]
{
	ai_charge(SECRET_1ST_DOWN);
};

void() demon1_pain1 = [39, demon1_pain2]
{
};

void() demon1_pain2 = [40, demon1_pain3]
{
};

void() demon1_pain3 = [41, demon1_pain4]
{
};

void() demon1_pain4 = [42, demon1_pain5]
{
};

void() demon1_pain5 = [43, demon1_pain6]
{
};

void() demon1_pain6 = [44, demon1_run1]
{
};

void(entity attacker, float damage) demon1_pain = 
{
	if (self.touch == Demon_JumpTouch)
	{
		return;
	}
	if (self.pain_finished > time)
	{
		return;
	}
	sound(self, CHAN_VOICE, "demon/dpain1.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	if (random() * 200 > damage)
	{
		return;
	}
	self.pain_finished = time + SPAWNFLAG_LASER;
	demon1_pain1();
};

void() demon1_die1 = [45, demon1_die2]
{
	sound(self, CHAN_VOICE, "demon/ddeath.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
};

void() demon1_die2 = [46, demon1_die3]
{
};

void() demon1_die3 = [47, demon1_die4]
{
};

void() demon1_die4 = [48, demon1_die5]
{
};

void() demon1_die5 = [49, demon1_die6]
{
};

void() demon1_die6 = [50, demon1_die7]
{
	self.solid = SOLID_NOT;
};

void() demon1_die7 = [51, demon1_die8]
{
};

void() demon1_die8 = [52, demon1_die9]
{
};

void() demon1_die9 = [53, demon1_die9]
{
	CorpseThink();
};

void() demon_die = 
{
	if (self.health < -80)
	{
		sound(self, CHAN_VOICE, "player/udeath.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
		ThrowHead("progs/h_demon.mdl", self.health);
		ThrowGib("progs/gib1.mdl", self.health);
		ThrowGib("progs/gib1.mdl", self.health);
		ThrowGib("progs/gib1.mdl", self.health);
		return;
	}
	demon1_die1();
};

void() Demon_MeleeAttack = 
{
	demon1_atta1();
};

void() monster_demon1 = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/demon.mdl");
	precache_model("progs/h_demon.mdl");
	precache_sound("demon/ddeath.wav");
	precache_sound("demon/dhit2.wav");
	precache_sound("demon/djump.wav");
	precache_sound("demon/dpain1.wav");
	precache_sound("demon/idle1.wav");
	precache_sound("demon/sight2.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/demon.mdl");
	setsize(self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	self.health = 300;
	self.th_stand = demon1_stand1;
	self.th_walk = demon1_walk1;
	self.th_run = demon1_run1;
	self.th_die = demon_die;
	self.th_melee = Demon_MeleeAttack;
	self.th_missile = demon1_jump1;
	self.th_pain = demon1_pain;
	walkmonster_start();
};

float() CheckDemonMelee = 
{
	if (enemy_range == RANGE_MELEE)
	{
		self.attack_state = AS_MELEE;
		return 1;
	}
	return 0;
};

float() CheckDemonJump = 
{
	local vector dist;
	local float d;
	if (self.origin_z + self.mins_z > self.enemy.origin_z + self.enemy.mins_z + 0.75 * self.enemy.size_z)
	{
		return 0;
	}
	if (self.origin_z + self.maxs_z < self.enemy.origin_z + self.enemy.mins_z + 0.25 * self.enemy.size_z)
	{
		return 0;
	}
	dist = self.enemy.origin - self.origin;
	dist_z = counter;
	d = vlen(dist);
	if (d < 100)
	{
		return 0;
	}
	if (d > 200)
	{
		if (random() < 0.9)
		{
			return 0;
		}
	}
	return 1;
};

float() DemonCheckAttack = 
{
	local vector vec;
	if (CheckDemonMelee())
	{
		self.attack_state = AS_MELEE;
		return 1;
	}
	if (CheckDemonJump())
	{
		self.attack_state = AS_MISSILE;
		sound(self, CHAN_VOICE, "demon/djump.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
		return 1;
	}
	return 0;
};

void(float side) Demon_Melee = 
{
	local float ldmg;
	local vector delta;
	ai_face();
	walkmove(self.ideal_yaw, 12);
	delta = self.enemy.origin - self.origin;
	if (vlen(delta) > 100)
	{
		return;
	}
	if (!CanDamage(self.enemy, self))
	{
		return;
	}
	sound(self, CHAN_WEAPON, "demon/dhit2.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	ldmg = TE_LAVASPLASH + TE_LIGHTNING1 * random();
	T_Damage(self.enemy, self, self, ldmg);
	makevectors(self.angles);
	SpawnMeatSpray(self.origin + v_forward * SECRET_YES_SHOOT, side * v_right);
};

void() Demon_JumpTouch = 
{
	local float ldmg;
	if (self.health <= counter || !(self.takedamage))
	{
		return;
	}
	if (other.takedamage)
	{
		if (vlen(self.velocity) > 400)
		{
			ldmg = 40 + TE_LAVASPLASH * random();
			T_Damage(other, self, self, ldmg);
		}
	}
	if (!checkbottom(self))
	{
		if (self.flags & FL_ONGROUND)
		{
			self.touch = SUB_Null;
			if (self.exptime == counter)
			{
				self.think = demon1_jump1;
				self.nextthink = time + 0.1;
			}
		}
		return;
	}
	self.touch = SUB_Null;
	if (self.exptime == counter)
	{
		self.think = demon1_jump11;
		self.nextthink = time + 0.1;
	}
};

