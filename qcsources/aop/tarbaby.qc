void() tbaby_stand1 = [0, tbaby_stand1]
{
	ai_stand();
};

void() tbaby_hang1 = [0, tbaby_hang1]
{
	ai_stand();
};

void() tbaby_walk1 = [0, tbaby_walk2]
{
	ai_turn();
};

void() tbaby_walk2 = [1, tbaby_walk3]
{
	ai_turn();
};

void() tbaby_walk3 = [2, tbaby_walk4]
{
	ai_turn();
};

void() tbaby_walk4 = [3, tbaby_walk5]
{
	ai_turn();
};

void() tbaby_walk5 = [4, tbaby_walk6]
{
	ai_turn();
};

void() tbaby_walk6 = [5, tbaby_walk7]
{
	ai_turn();
};

void() tbaby_walk7 = [6, tbaby_walk8]
{
	ai_turn();
};

void() tbaby_walk8 = [7, tbaby_walk9]
{
	ai_turn();
};

void() tbaby_walk9 = [8, tbaby_walk10]
{
	ai_turn();
};

void() tbaby_walk10 = [9, tbaby_walk11]
{
	ai_turn();
};

void() tbaby_walk11 = [10, tbaby_walk12]
{
	ai_walk(SPAWNFLAG_LASER);
};

void() tbaby_walk12 = [11, tbaby_walk13]
{
	ai_walk(SPAWNFLAG_LASER);
};

void() tbaby_walk13 = [12, tbaby_walk14]
{
	ai_walk(SPAWNFLAG_LASER);
};

void() tbaby_walk14 = [13, tbaby_walk15]
{
	ai_walk(SPAWNFLAG_LASER);
};

void() tbaby_walk15 = [14, tbaby_walk16]
{
	ai_walk(SPAWNFLAG_LASER);
};

void() tbaby_walk16 = [15, tbaby_walk17]
{
	ai_walk(SPAWNFLAG_LASER);
};

void() tbaby_walk17 = [16, tbaby_walk18]
{
	ai_walk(SPAWNFLAG_LASER);
};

void() tbaby_walk18 = [17, tbaby_walk19]
{
	ai_walk(SPAWNFLAG_LASER);
};

void() tbaby_walk19 = [18, tbaby_walk20]
{
	ai_walk(SPAWNFLAG_LASER);
};

void() tbaby_walk20 = [19, tbaby_walk21]
{
	ai_walk(SPAWNFLAG_LASER);
};

void() tbaby_walk21 = [20, tbaby_walk22]
{
	ai_walk(SPAWNFLAG_LASER);
};

void() tbaby_walk22 = [21, tbaby_walk23]
{
	ai_walk(SPAWNFLAG_LASER);
};

void() tbaby_walk23 = [22, tbaby_walk24]
{
	ai_walk(SPAWNFLAG_LASER);
};

void() tbaby_walk24 = [23, tbaby_walk25]
{
	ai_walk(SPAWNFLAG_LASER);
};

void() tbaby_walk25 = [24, tbaby_walk1]
{
	ai_walk(SPAWNFLAG_LASER);
};

void() tbaby_run1 = [25, tbaby_run2]
{
	ai_face();
};

void() tbaby_run2 = [26, tbaby_run3]
{
	ai_face();
};

void() tbaby_run3 = [27, tbaby_run4]
{
	ai_face();
};

void() tbaby_run4 = [28, tbaby_run5]
{
	ai_face();
};

void() tbaby_run5 = [29, tbaby_run6]
{
	ai_face();
};

void() tbaby_run6 = [30, tbaby_run7]
{
	ai_face();
};

void() tbaby_run7 = [31, tbaby_run8]
{
	ai_face();
};

void() tbaby_run8 = [32, tbaby_run9]
{
	ai_face();
};

void() tbaby_run9 = [33, tbaby_run10]
{
	ai_face();
};

void() tbaby_run10 = [34, tbaby_run11]
{
	ai_face();
};

void() tbaby_run11 = [35, tbaby_run12]
{
	ai_run(SPAWNFLAG_LASER);
};

void() tbaby_run12 = [36, tbaby_run13]
{
	ai_run(SPAWNFLAG_LASER);
};

void() tbaby_run13 = [37, tbaby_run14]
{
	ai_run(SPAWNFLAG_LASER);
};

void() tbaby_run14 = [38, tbaby_run15]
{
	ai_run(SPAWNFLAG_LASER);
};

void() tbaby_run15 = [39, tbaby_run16]
{
	ai_run(SPAWNFLAG_LASER);
};

void() tbaby_run16 = [40, tbaby_run17]
{
	ai_run(SPAWNFLAG_LASER);
};

void() tbaby_run17 = [41, tbaby_run18]
{
	ai_run(SPAWNFLAG_LASER);
};

void() tbaby_run18 = [42, tbaby_run19]
{
	ai_run(SPAWNFLAG_LASER);
};

void() tbaby_run19 = [43, tbaby_run20]
{
	ai_run(SPAWNFLAG_LASER);
};

void() tbaby_run20 = [44, tbaby_run21]
{
	ai_run(SPAWNFLAG_LASER);
};

void() tbaby_run21 = [45, tbaby_run22]
{
	ai_run(SPAWNFLAG_LASER);
};

void() tbaby_run22 = [46, tbaby_run23]
{
	ai_run(SPAWNFLAG_LASER);
};

void() tbaby_run23 = [47, tbaby_run24]
{
	ai_run(SPAWNFLAG_LASER);
};

void() tbaby_run24 = [48, tbaby_run25]
{
	ai_run(SPAWNFLAG_LASER);
};

void() tbaby_run25 = [49, tbaby_run1]
{
	ai_run(SPAWNFLAG_LASER);
};

void() Tar_JumpTouch = 
{
	local float ldmg;
	if (self.health <= counter || !(self.takedamage))
	{
		return;
	}
	if (other.takedamage && other.classname != self.classname)
	{
		if (vlen(self.velocity) > 400)
		{
			ldmg = TE_LAVASPLASH + TE_LAVASPLASH * random();
			T_Damage(other, self, self, ldmg);
			sound(self, CHAN_WEAPON, "blob/hit1.wav", SPAWN_CRUCIFIED, ATTN_NORM);
		}
	}
	else
	{
		sound(self, CHAN_WEAPON, "blob/land1.wav", SPAWN_CRUCIFIED, ATTN_NORM);
	}
	if (!checkbottom(self))
	{
		if (self.flags & FL_ONGROUND)
		{
			self.touch = SUB_Null;
			self.think = tbaby_run1;
			self.movetype = MOVETYPE_STEP;
			self.nextthink = time + 0.1;
		}
		return;
	}
	self.touch = SUB_Null;
	self.think = tbaby_jump1;
	self.nextthink = time + 0.1;
};

void() tbaby_fly1 = [56, tbaby_fly2]
{
};

void() tbaby_fly2 = [57, tbaby_fly3]
{
};

void() tbaby_fly3 = [58, tbaby_fly4]
{
};

void() tbaby_fly4 = [59, tbaby_fly1]
{
	self.cnt = self.cnt + SPAWN_CRUCIFIED;
	if (self.cnt == SECRET_1ST_DOWN)
	{
		tbaby_jump5();
	}
};

void() tbaby_jump1 = [50, tbaby_jump2]
{
	ai_face();
};

void() tbaby_jump2 = [51, tbaby_jump3]
{
	ai_face();
};

void() tbaby_jump3 = [52, tbaby_jump4]
{
	ai_face();
};

void() tbaby_jump4 = [53, tbaby_jump5]
{
	ai_face();
};

void() tbaby_jump5 = [54, tbaby_jump6]
{
	if (self.health <= counter)
	{
		dprint("tbaby_jump5: dead\n");
		self.touch = SUB_Null;
		self.think = tbaby_die1;
		return;
	}
	self.movetype = MOVETYPE_BOUNCE;
	self.touch = Tar_JumpTouch;
	makevectors(self.angles);
	self.origin_z = self.origin_z + SPAWN_CRUCIFIED;
	self.velocity = v_forward * 600 + '0 0 200';
	self.velocity_z = self.velocity_z + random() * 150;
	if (self.flags & FL_ONGROUND)
	{
		self.flags = self.flags - FL_ONGROUND;
	}
	self.cnt = counter;
};

void() tbaby_jump6 = [55, tbaby_fly1]
{
};

void() tbaby_die1 = [60, tbaby_die2]
{
	self.takedamage = DAMAGE_NO;
};

void() tbaby_die2 = [60, tbaby_run1]
{
	T_RadiusDamage(self, self, 120, world);
	sound(self, CHAN_VOICE, "blob/death1.wav", SPAWN_CRUCIFIED, ATTN_NORM);
	self.origin = self.origin - SECRET_NO_SHOOT * normalize(self.velocity);
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_TAREXPLOSION);
	WriteCoord(MSG_BROADCAST, self.origin_x);
	WriteCoord(MSG_BROADCAST, self.origin_y);
	WriteCoord(MSG_BROADCAST, self.origin_z);
	BecomeExplosion();
};

void() monster_tarbaby = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model2("progs/tarbaby.mdl");
	precache_sound2("blob/death1.wav");
	precache_sound2("blob/hit1.wav");
	precache_sound2("blob/land1.wav");
	precache_sound2("blob/sight1.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/tarbaby.mdl");
	setsize(self, VEC_HULL_MIN, '16 16 40');
	self.health = 80;
	self.th_stand = tbaby_stand1;
	self.th_walk = tbaby_walk1;
	self.th_run = tbaby_run1;
	self.th_missile = tbaby_jump1;
	self.th_melee = tbaby_jump1;
	self.th_die = tbaby_die1;
	walkmonster_start();
};

