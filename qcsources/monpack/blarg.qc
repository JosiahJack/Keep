void() blarg_bite = 
{
	local vector delta;
	local float ldmg;
	if (!(self.enemy))
	{
		return;
	}
	ai_charge(MOVETYPE_BOUNCE);
	if (!CanDamage(self.enemy, self))
	{
		return;
	}
	delta = self.enemy.origin - self.origin;
	if (vlen(delta) > 100)
	{
		return;
	}
	random();
	ldmg = (random() + random() + random()) * FL_CLIENT;
	T_Damage(self.enemy, self, self, ldmg);
};

void() Blarg_JumpTouch = 
{
	local float ldmg;
	if (self.health <= 0)
	{
		return;
	}
	if (other.takedamage)
	{
		if (vlen(self.velocity) > 300)
		{
			ldmg = MOVETYPE_FLY + MOVETYPE_BOUNCE * random();
			T_Damage(other, self, self, ldmg);
		}
	}
	if (!checkbottom(self))
	{
		if (self.flags & FL_ONGROUND)
		{
			self.touch = SUB_Null;
			self.think = blarg_leap1;
			self.nextthink = time;
		}
		return;
	}
	self.touch = SUB_Null;
	self.think = blarg_run8;
	self.nextthink = time;
};

void(entity attacker, float damage) blarg_pain = 
{
	if (self.touch == Blarg_JumpTouch)
	{
		return;
	}
	if (self.pain_finished > time)
	{
		return;
	}
	self.pain_finished = time + MOVETYPE_WALK;
	sound(self, CHAN_VOICE, "demon/dpain1.wav", 1, ATTN_NORM);
	return;
};

void() blarg_stop = 
{
	if (self.health < -100)
	{
		sound(self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		ThrowHead("progs/gib2.mdl", self.health);
		ThrowGib("progs/gib1.mdl", self.health);
		ThrowGib("progs/gib2.mdl", self.health);
		ThrowGib("progs/gib3.mdl", self.health);
		return;
	}
	if (random() > 0.4)
	{
		blarg_stop1();
		return;
	}
	else
	{
		self.movetype = MOVETYPE_BOUNCE;
	}
	self.velocity_x = -50 + 100 * random();
	self.velocity_y = -50 + 100 * random();
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	blarg_bstop1();
};

void() blarg_stand1 = [42, blarg_stand2]
{
	ai_stand();
	if (random() < 0.05)
	{
		sound(self, CHAN_VOICE, "blarg/bidle.wav", 1, ATTN_NORM);
	}
	else
	{
		if (random() < 0.1)
		{
			sound(self, CHAN_VOICE, "blarg/bidle2.wav", 1, ATTN_NORM);
		}
	}
};

void() blarg_stand2 = [43, blarg_stand3]
{
	ai_stand();
};

void() blarg_stand3 = [44, blarg_stand4]
{
	ai_stand();
};

void() blarg_stand4 = [45, blarg_stand5]
{
	ai_stand();
};

void() blarg_stand5 = [46, blarg_stand6]
{
	ai_stand();
};

void() blarg_stand6 = [45, blarg_stand7]
{
	ai_stand();
};

void() blarg_stand7 = [44, blarg_stand8]
{
	ai_stand();
};

void() blarg_stand8 = [43, blarg_stand1]
{
	ai_stand();
};

void() blarg_stop1 = [30, blarg_stop2]
{
	sound(self, CHAN_VOICE, "demon/ddeath.wav", 1, ATTN_NORM);
};

void() blarg_stop2 = [31, blarg_stop3]
{
};

void() blarg_stop3 = [32, blarg_stop4]
{
};

void() blarg_stop4 = [33, blarg_stop5]
{
};

void() blarg_stop5 = [34, blarg_stop6]
{
	self.solid = SOLID_NOT;
};

void() blarg_stop6 = [35, blarg_stop7]
{
};

void() blarg_stop7 = [36, blarg_stop7]
{
};

void() blarg_bstop1 = [37, blarg_bstop2]
{
	sound(self, CHAN_VOICE, "demon/ddeath.wav", 1, ATTN_NORM);
	ai_forward(FL_INWATER);
};

void() blarg_bstop2 = [38, blarg_bstop3]
{
	ai_forward(MANGA);
};

void() blarg_bstop3 = [39, blarg_bstop4]
{
	ai_forward(MOVETYPE_BOUNCE);
};

void() blarg_bstop4 = [40, blarg_bstop5]
{
	ai_forward(MOVETYPE_FLY);
};

void() blarg_bstop5 = [41, blarg_bstop6]
{
	self.solid = SOLID_NOT;
};

void() blarg_bstop6 = [41, blarg_bstop7]
{
};

void() blarg_bstop7 = [41, blarg_bstop7]
{
};

void() blarg_walk1 = [0, blarg_walk2]
{
	if (random() < 0.2)
	{
		sound(self, CHAN_VOICE, "blarg/bidle.wav", 1, ATTN_IDLE);
	}
	ai_walk(FL_CLIENT);
};

void() blarg_walk2 = [1, blarg_walk3]
{
	ai_walk(FL_INWATER);
};

void() blarg_walk3 = [2, blarg_walk4]
{
	ai_walk(FL_INWATER);
};

void() blarg_walk4 = [3, blarg_walk6]
{
	ai_walk(FL_CLIENT);
};

void() blarg_walk6 = [4, blarg_walk7]
{
	ai_walk(FL_INWATER);
};

void() blarg_walk7 = [5, blarg_walk1]
{
	ai_walk(FL_INWATER);
};

void() blarg_run1 = [17, blarg_run2]
{
	ai_run(0);
	ai_face();
};

void() blarg_run2 = [18, blarg_run3]
{
	ai_run(0);
	ai_face();
};

void() blarg_run3 = [19, blarg_run4]
{
	ai_run(MOVETYPE_BOUNCE);
	ai_face();
};

void() blarg_run4 = [20, blarg_run5]
{
	ai_face();
	self.touch = Blarg_JumpTouch;
	makevectors(self.angles);
	self.origin_z = self.origin_z + 1;
	self.velocity = v_forward * 400 + '0 0 250';
	if (self.flags & FL_ONGROUND)
	{
		self.flags = self.flags - FL_ONGROUND;
	}
	sound(self, CHAN_VOICE, "blarg/bjump.wav", 1, ATTN_NORM);
	return;
};

void() blarg_run5 = [13, blarg_run6]
{
};

void() blarg_run6 = [14, blarg_run7]
{
};

void() blarg_run7 = [15, blarg_run8]
{
};

void() blarg_run8 = [16, blarg_run1]
{
};

void() blarg_atta1 = [18, blarg_atta2]
{
	ai_charge(MOVETYPE_BOUNCE);
	ai_face();
};

void() blarg_atta2 = [19, blarg_atta3]
{
	ai_charge(MOVETYPE_BOUNCE);
	ai_face();
};

void() blarg_atta3 = [20, blarg_atta4]
{
	ai_charge(MOVETYPE_BOUNCE);
	blarg_bite();
};

void() blarg_atta4 = [21, blarg_atta5]
{
	sound(self, CHAN_VOICE, "blarg/bjump2.wav", 1, ATTN_NORM);
	blarg_bite();
};

void() blarg_atta5 = [22, blarg_atta6]
{
	ai_charge(MOVETYPE_BOUNCE);
	blarg_bite();
};

void() blarg_atta6 = [23, blarg_atta7]
{
	ai_charge(MOVETYPE_BOUNCE);
};

void() blarg_atta7 = [24, blarg_atta8]
{
	ai_charge(MOVETYPE_BOUNCE);
};

void() blarg_atta8 = [25, blarg_run1]
{
	ai_charge(MOVETYPE_BOUNCE);
};

void() blarg_leap1 = [25, blarg_leap2]
{
	ai_face();
};

void() blarg_leap2 = [26, blarg_leap3]
{
	ai_face();
};

void() blarg_leap3 = [27, blarg_leap4]
{
	ai_face();
	self.touch = Blarg_JumpTouch;
	makevectors(self.angles);
	self.origin_z = self.origin_z + 1;
	self.velocity = v_forward * 600 + '0 0 250';
	if (self.flags & FL_ONGROUND)
	{
		self.flags = self.flags - FL_ONGROUND;
	}
	sound(self, CHAN_VOICE, "blarg/bjump.wav", 1, ATTN_NORM);
};

void() blarg_leap4 = [28, blarg_leap5]
{
};

void() blarg_leap5 = [29, blarg_leap6]
{
};

void() blarg_leap6 = [13, blarg_run1]
{
};

float() CheckBlargMelee = 
{
	if (enemy_range == RANGE_MELEE)
	{
		self.attack_state = AS_MELEE;
		return 1;
	}
	return 0;
};

float() CheckBlargJump = 
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
	dist_z = 0;
	d = vlen(dist);
	if (d < 80)
	{
		return 0;
	}
	if (d > MIN_CHARMER_DISTANCE)
	{
		return 0;
	}
	return 1;
};

void() BlargCheckAttack = 
{
	local vector vec;
	if (CheckBlargMelee())
	{
		self.attack_state = AS_MELEE;
		return 1;
	}
	if (CheckBlargJump())
	{
		self.attack_state = AS_MISSILE;
		return 1;
	}
	return 0;
};

void() monster_blarg = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	self.monster_type = BLARG;
	precache_model("progs/blarg.mdl");
	precache_sound("demon/dpain1.wav");
	precache_sound("demon/djump.wav");
	precache_sound("demon/sight2.wav");
	precache_sound("blarg/bidle.wav");
	precache_sound("blarg/bidle2.wav");
	precache_sound("blarg/bjump.wav");
	precache_sound("blarg/bjump2.wav");
	precache_sound("demon/ddeath.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/blarg.mdl");
	setsize(self, '-16 -35 -24', '16 35 20');
	self.health = 180;
	self.th_stand = blarg_stand1;
	self.th_walk = blarg_walk1;
	self.th_run = blarg_run1;
	self.th_melee = blarg_atta1;
	self.th_missile = blarg_leap1;
	self.th_pain = blarg_pain;
	self.th_die = blarg_stop;
	self.pain_finished = time + MOVETYPE_WALK;
	walkmonster_start();
};

