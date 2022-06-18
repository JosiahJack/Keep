void() PM_FlapNoise = 
{
	if (!PM_InLiquid(self))
	{
		sound(self, CHAN_BODY, "dragon/idlefly.wav", USE_COUNT, ATTN_NORM);
	}
};

void() dragon_hover1 = [0, dragon_hover2]
{
	drag_stand(NO_ROTATE, MOVETIME);
};

void() dragon_hover2 = [1, dragon_hover3]
{
	drag_stand(NO_ROTATE, MOVETIME);
};

void() dragon_hover3 = [2, dragon_hover4]
{
	drag_stand(NO_ROTATE, MOVETIME);
};

void() dragon_hover4 = [3, dragon_hover5]
{
	drag_stand(NO_ROTATE, MOVETIME);
};

void() dragon_hover5 = [4, dragon_hover6]
{
	drag_stand(NO_ROTATE, MOVETIME);
};

void() dragon_hover6 = [5, dragon_hover7]
{
	drag_stand(NO_ROTATE, MOVETIME);
};

void() dragon_hover7 = [6, dragon_hover8]
{
	drag_stand(NO_ROTATE, MOVETIME);
};

void() dragon_hover8 = [7, dragon_hover9]
{
	PM_FlapNoise();
	drag_stand(NO_ROTATE, MOVETIME);
};

void() dragon_hover9 = [6, dragon_hover10]
{
	drag_stand(NO_ROTATE, MOVETIME);
};

void() dragon_hover10 = [5, dragon_hover11]
{
	drag_stand(NO_ROTATE, MOVETIME);
};

void() dragon_hover11 = [4, dragon_hover12]
{
	drag_stand(NO_ROTATE, MOVETIME);
};

void() dragon_hover12 = [3, dragon_hover13]
{
	drag_stand(NO_ROTATE, MOVETIME);
};

void() dragon_hover13 = [2, dragon_hover14]
{
	drag_stand(NO_ROTATE, MOVETIME);
};

void() dragon_hover14 = [1, dragon_hover1]
{
	drag_stand(NO_ROTATE, MOVETIME);
};

void() dragon_walk1 = [0, dragon_walk2]
{
	drag_walk(NO_ROTATE, MOVETIME);
};

void() dragon_walk2 = [1, dragon_walk3]
{
	drag_walk(NO_ROTATE, MOVETIME);
};

void() dragon_walk3 = [2, dragon_walk4]
{
	drag_walk(NO_ROTATE, MOVETIME);
};

void() dragon_walk4 = [3, dragon_walk5]
{
	drag_walk(NO_ROTATE, MOVETIME);
};

void() dragon_walk5 = [4, dragon_walk6]
{
	drag_walk(NO_ROTATE, MOVETIME);
};

void() dragon_walk6 = [5, dragon_walk7]
{
	drag_walk(NO_ROTATE, MOVETIME);
};

void() dragon_walk7 = [6, dragon_walk8]
{
	drag_walk(NO_ROTATE, MOVETIME);
};

void() dragon_walk8 = [7, dragon_walk9]
{
	PM_FlapNoise();
	drag_walk(NO_ROTATE, MOVETIME);
};

void() dragon_walk9 = [6, dragon_walk10]
{
	drag_walk(NO_ROTATE, MOVETIME);
};

void() dragon_walk10 = [5, dragon_walk11]
{
	drag_walk(NO_ROTATE, MOVETIME);
};

void() dragon_walk11 = [4, dragon_walk12]
{
	drag_walk(NO_ROTATE, MOVETIME);
};

void() dragon_walk12 = [3, dragon_walk13]
{
	drag_walk(NO_ROTATE, MOVETIME);
};

void() dragon_walk13 = [2, dragon_walk14]
{
	drag_walk(NO_ROTATE, MOVETIME);
};

void() dragon_walk14 = [1, dragon_walk1]
{
	drag_walk(NO_ROTATE, MOVETIME);
};

void() dragon_run1 = [0, dragon_run2]
{
	drag_run(MOVETIME);
};

void() dragon_run2 = [1, dragon_run3]
{
	drag_run(MOVETIME);
};

void() dragon_run3 = [2, dragon_run4]
{
	drag_run(MOVETIME);
};

void() dragon_run4 = [3, dragon_run5]
{
	drag_run(MOVETIME);
};

void() dragon_run5 = [4, dragon_run6]
{
	drag_run(MOVETIME);
};

void() dragon_run6 = [5, dragon_run7]
{
	drag_run(MOVETIME);
};

void() dragon_run7 = [6, dragon_run8]
{
	drag_run(MOVETIME);
};

void() dragon_run8 = [7, dragon_run9]
{
	PM_FlapNoise();
	drag_run(MOVETIME);
};

void() dragon_run9 = [6, dragon_run10]
{
	drag_run(MOVETIME);
};

void() dragon_run10 = [5, dragon_run11]
{
	drag_run(MOVETIME);
};

void() dragon_run11 = [4, dragon_run12]
{
	drag_run(MOVETIME);
};

void() dragon_run12 = [3, dragon_run13]
{
	drag_run(MOVETIME);
};

void() dragon_run13 = [2, dragon_run14]
{
	drag_run(MOVETIME);
};

void() dragon_run14 = [1, dragon_run1]
{
	drag_run(MOVETIME);
};

void(vector offset) PM_DragonBite = 
{
	local vector org;
	local vector dir;
	local vector delta;
	local float damage;
	delta = self.enemy.origin - self.origin;
	if (vlen(delta) > TOOCLOSE_CHARMER_DISTANCE)
	{
		return;
	}
	if (!CanDamage(self.enemy, self))
	{
		return;
	}
	if (self.enemy.health <= MSG_BROADCAST)
	{
		return;
	}
	sound(self, CHAN_WEAPON, "demon/dhit2.wav", USE_COUNT, ATTN_NORM);
	if (random() < 0.1)
	{
		damage = 60;
	}
	else
	{
		damage = random() * BURN_TIME + 15;
	}
	self.enemy.biteme = 1;
	T_Damage(self.enemy, self, self, damage);
	makevectors(self.angles);
	org = self.origin + v_forward * offset_x + v_right * offset_y + v_up * offset_z;
	dir = crandom() * 100 * v_right + random() * -50 * v_forward;
	SpawnMeatSpray(org, dir);
	self.enemy.biteme = 0;
};

void() dragon_bite1 = [8, dragon_bite2]
{
	drag_melee(NO_ROTATE, MOVETIME);
};

void() dragon_bite2 = [9, dragon_bite3]
{
	drag_melee(NO_ROTATE, MOVETIME);
};

void() dragon_bite3 = [10, dragon_bite4]
{
	drag_melee(NO_ROTATE, MOVETIME);
};

void() dragon_bite4 = [11, dragon_bite5]
{
	drag_melee(NO_ROTATE, MOVETIME);
};

void() dragon_bite5 = [12, dragon_bite6]
{
	drag_melee(NO_ROTATE, MOVETIME);
};

void() dragon_bite6 = [13, dragon_bite7]
{
	drag_melee(NO_ROTATE, MOVETIME);
};

void() dragon_bite7 = [14, dragon_bite8]
{
	drag_melee(NO_ROTATE, MOVETIME);
};

void() dragon_bite8 = [15, dragon_bite9]
{
	drag_melee(NO_ROTATE, MOVETIME);
};

void() dragon_bite9 = [16, dragon_bite10]
{
	PM_FlapNoise();
	drag_melee(NO_ROTATE, MOVETIME);
	PM_DragonBite('44 -3 -12');
};

void() dragon_bite10 = [15, dragon_bite11]
{
	drag_melee(NO_ROTATE, MOVETIME);
};

void() dragon_bite11 = [14, dragon_bite12]
{
	drag_melee(NO_ROTATE, MOVETIME);
};

void() dragon_bite12 = [13, dragon_bite13]
{
	drag_melee(NO_ROTATE, MOVETIME);
};

void() dragon_bite13 = [12, dragon_bite14]
{
	drag_melee(NO_ROTATE, MOVETIME);
};

void() dragon_bite14 = [11, dragon_bite15]
{
	drag_melee(NO_ROTATE, MOVETIME);
};

void() dragon_bite15 = [10, dragon_bite16]
{
	drag_melee(NO_ROTATE, MOVETIME);
};

void() dragon_bite16 = [9, dragon_bite17]
{
	drag_melee(NO_ROTATE, MOVETIME);
	PM_DragonBite('46 0 -2');
};

void() dragon_bite17 = [8, dragon_run1]
{
	drag_melee(NO_ROTATE, MOVETIME);
};

void() dragon_melee = 
{
	if (!(self.th_missile))
	{
		dragon_bite1();
		return;
	}
	if (vlen(self.enemy.origin - self.origin) <= TOOCLOSE_CHARMER_DISTANCE)
	{
		if (PM_Hydrophobic())
		{
			if (PM_InLiquid(self))
			{
				dragon_bite1();
				return;
			}
		}
		if (random() < 0.8)
		{
			dragon_bite1();
		}
		else
		{
			self.th_missile();
		}
	}
	else
	{
		self.th_missile();
	}
};

void() dragon_fire1 = [8, dragon_fire2]
{
	drag_missile(NO_ROTATE, MOVETIME);
};

void() dragon_fire2 = [9, dragon_fire3]
{
	drag_missile(NO_ROTATE, MOVETIME);
};

void() dragon_fire3 = [10, dragon_fire4]
{
	drag_missile(NO_ROTATE, MOVETIME);
};

void() dragon_fire4 = [11, dragon_fire5]
{
	drag_missile(NO_ROTATE, MOVETIME);
};

void() dragon_fire5 = [12, dragon_fire6]
{
	drag_missile(NO_ROTATE, MOVETIME);
};

void() dragon_fire6 = [13, dragon_fire7]
{
	drag_missile(NO_ROTATE, MOVETIME);
	sound(self, CHAN_WEAPON, "dragon/fire.wav", USE_COUNT, ATTN_NORM);
	PM_DragonFire('42 0 2');
};

void() dragon_fire7 = [14, dragon_fire8]
{
	drag_missile(NO_ROTATE, MOVETIME);
	PM_DragonFire('46 0 1');
};

void() dragon_fire8 = [15, dragon_fire9]
{
	drag_missile(NO_ROTATE, MOVETIME);
	PM_DragonFire('44 -2 -4');
};

void() dragon_fire9 = [16, dragon_fire10]
{
	PM_FlapNoise();
	drag_missile(NO_ROTATE, MOVETIME);
	PM_DragonFire('44 -3 -12');
};

void() dragon_fire10 = [15, dragon_fire11]
{
	drag_missile(NO_ROTATE, MOVETIME);
	PM_DragonFire('44 -2 -4');
};

void() dragon_fire11 = [14, dragon_fire12]
{
	drag_missile(NO_ROTATE, MOVETIME);
	PM_DragonFire('46 0 1');
};

void() dragon_fire12 = [13, dragon_fire13]
{
	drag_missile(NO_ROTATE, MOVETIME);
};

void() dragon_fire13 = [12, dragon_fire14]
{
	drag_missile(NO_ROTATE, MOVETIME);
};

void() dragon_fire14 = [11, dragon_fire15]
{
	drag_missile(NO_ROTATE, MOVETIME);
};

void() dragon_fire15 = [10, dragon_fire16]
{
	drag_missile(NO_ROTATE, MOVETIME);
};

void() dragon_fire16 = [9, dragon_fire17]
{
	drag_missile(NO_ROTATE, MOVETIME);
};

void() dragon_fire17 = [8, dragon_run1]
{
	drag_missile(NO_ROTATE, MOVETIME);
};

void() dragon_bolt1 = [8, dragon_bolt2]
{
	drag_missile(NO_ROTATE, MOVETIME);
};

void() dragon_bolt2 = [9, dragon_bolt3]
{
	drag_missile(NO_ROTATE, MOVETIME);
};

void() dragon_bolt3 = [10, dragon_bolt4]
{
	drag_missile(NO_ROTATE, MOVETIME);
};

void() dragon_bolt4 = [11, dragon_bolt5]
{
	drag_missile(NO_ROTATE, MOVETIME);
};

void() dragon_bolt5 = [12, dragon_bolt6]
{
	drag_missile(NO_ROTATE, MOVETIME);
};

void() dragon_bolt6 = [13, dragon_bolt7]
{
	drag_missile(NO_ROTATE, MOVETIME);
};

void() dragon_bolt7 = [14, dragon_bolt8]
{
	drag_missile(NO_ROTATE, MOVETIME);
};

void() dragon_bolt8 = [15, dragon_bolt9]
{
	drag_missile(NO_ROTATE, MOVETIME);
};

void() dragon_bolt9 = [16, dragon_bolt10]
{
	PM_FlapNoise();
	drag_missile(NO_ROTATE, MOVETIME);
	sound(self, CHAN_WEAPON, "dragon/thunder.wav", USE_COUNT, ATTN_NORM);
	PM_DragonBolt('44 -3 -12');
};

void() dragon_bolt10 = [15, dragon_bolt11]
{
	drag_missile(NO_ROTATE, MOVETIME);
	PM_DragonBolt('44 -2 -4');
};

void() dragon_bolt11 = [14, dragon_bolt12]
{
	drag_missile(NO_ROTATE, MOVETIME);
	PM_DragonBolt('46 0 1');
};

void() dragon_bolt12 = [13, dragon_bolt13]
{
	drag_missile(NO_ROTATE, MOVETIME);
	PM_DragonBolt('42 0 2');
};

void() dragon_bolt13 = [12, dragon_bolt14]
{
	drag_missile(NO_ROTATE, MOVETIME);
};

void() dragon_bolt14 = [11, dragon_bolt15]
{
	drag_missile(NO_ROTATE, MOVETIME);
};

void() dragon_bolt15 = [10, dragon_bolt16]
{
	drag_missile(NO_ROTATE, MOVETIME);
};

void() dragon_bolt16 = [9, dragon_bolt17]
{
	drag_missile(NO_ROTATE, MOVETIME);
};

void() dragon_bolt17 = [8, dragon_run1]
{
	drag_missile(NO_ROTATE, MOVETIME);
};

void() dragon_spit1 = [8, dragon_spit2]
{
	drag_missile(NO_ROTATE, MOVETIME);
};

void() dragon_spit2 = [9, dragon_spit3]
{
	drag_missile(NO_ROTATE, MOVETIME);
};

void() dragon_spit3 = [10, dragon_spit4]
{
	drag_missile(NO_ROTATE, MOVETIME);
};

void() dragon_spit4 = [11, dragon_spit5]
{
	drag_missile(NO_ROTATE, MOVETIME);
};

void() dragon_spit5 = [12, dragon_spit6]
{
	drag_missile(NO_ROTATE, MOVETIME);
};

void() dragon_spit6 = [13, dragon_spit7]
{
	drag_missile(NO_ROTATE, MOVETIME);
	sound(self, CHAN_WEAPON, "dragon/spit.wav", USE_COUNT, ATTN_NORM);
	PM_DragonSpit('44 0 0');
};

void() dragon_spit7 = [14, dragon_spit8]
{
	drag_missile(NO_ROTATE, MOVETIME);
	PM_DragonSpit('46 0 1');
};

void() dragon_spit8 = [15, dragon_spit9]
{
	drag_missile(NO_ROTATE, MOVETIME);
	PM_DragonSpit('44 -2 -4');
};

void() dragon_spit9 = [16, dragon_spit10]
{
	PM_FlapNoise();
	drag_missile(NO_ROTATE, MOVETIME);
	PM_DragonSpit('44 -3 -12');
};

void() dragon_spit10 = [15, dragon_spit11]
{
	drag_missile(NO_ROTATE, MOVETIME);
	PM_DragonSpit('44 -2 -6');
};

void() dragon_spit11 = [14, dragon_spit12]
{
	drag_missile(NO_ROTATE, MOVETIME);
	PM_DragonSpit('46 0 0');
};

void() dragon_spit12 = [13, dragon_spit13]
{
	drag_missile(NO_ROTATE, MOVETIME);
};

void() dragon_spit13 = [12, dragon_spit14]
{
	drag_missile(NO_ROTATE, MOVETIME);
};

void() dragon_spit14 = [11, dragon_spit15]
{
	drag_missile(NO_ROTATE, MOVETIME);
};

void() dragon_spit15 = [10, dragon_spit16]
{
	drag_missile(NO_ROTATE, MOVETIME);
};

void() dragon_spit16 = [9, dragon_spit17]
{
	drag_missile(NO_ROTATE, MOVETIME);
};

void() dragon_spit17 = [8, dragon_run1]
{
	drag_missile(NO_ROTATE, MOVETIME);
};

void() dragon_spawn1 = [8, dragon_spawn2]
{
	drag_missile(NO_ROTATE, NO_ROTATE);
};

void() dragon_spawn2 = [9, dragon_spawn3]
{
	drag_missile(NO_ROTATE, NO_ROTATE);
};

void() dragon_spawn3 = [10, dragon_spawn4]
{
	drag_missile(NO_ROTATE, NO_ROTATE);
};

void() dragon_spawn4 = [11, dragon_spawn5]
{
	drag_missile(NO_ROTATE, NO_ROTATE);
};

void() dragon_spawn5 = [12, dragon_spawn6]
{
	drag_missile(NO_ROTATE, NO_ROTATE);
};

void() dragon_spawn6 = [13, dragon_spawn7]
{
	drag_missile(NO_ROTATE, NO_ROTATE);
	sound(self, CHAN_WEAPON, "dragon/spawn.wav", USE_COUNT, ATTN_NORM);
	PM_Spawn('44 0 0', 0.1);
};

void() dragon_spawn7 = [14, dragon_spawn8]
{
	drag_missile(NO_ROTATE, NO_ROTATE);
	PM_Spawn('46 0 1', 0.060000);
};

void() dragon_spawn8 = [15, dragon_spawn9]
{
	drag_missile(NO_ROTATE, NO_ROTATE);
	PM_Spawn('44 -2 -4', 0.020000);
};

void() dragon_spawn9 = [16, dragon_spawn10]
{
	PM_FlapNoise();
	drag_missile(NO_ROTATE, NO_ROTATE);
	PM_Spawn('44 -3 -12', -0.020000);
};

void() dragon_spawn10 = [15, dragon_spawn11]
{
	drag_missile(NO_ROTATE, NO_ROTATE);
	PM_Spawn('44 -2 -4', -0.060000);
};

void() dragon_spawn11 = [14, dragon_spawn12]
{
	drag_missile(NO_ROTATE, NO_ROTATE);
	PM_Spawn('46 0 1', -0.1);
};

void() dragon_spawn12 = [13, dragon_spawn13]
{
	drag_missile(NO_ROTATE, NO_ROTATE);
};

void() dragon_spawn13 = [12, dragon_spawn14]
{
	drag_missile(NO_ROTATE, NO_ROTATE);
};

void() dragon_spawn14 = [11, dragon_spawn15]
{
	drag_missile(NO_ROTATE, NO_ROTATE);
};

void() dragon_spawn15 = [10, dragon_spawn16]
{
	drag_missile(NO_ROTATE, NO_ROTATE);
};

void() dragon_spawn16 = [9, dragon_spawn17]
{
	drag_missile(NO_ROTATE, NO_ROTATE);
};

void() dragon_spawn17 = [8, dragon_run1]
{
	drag_missile(NO_ROTATE, NO_ROTATE);
};

void() dragon_blast1 = [8, dragon_blast2]
{
	drag_missile(NO_ROTATE, MOVETIME);
};

void() dragon_blast2 = [9, dragon_blast3]
{
	drag_missile(NO_ROTATE, MOVETIME);
};

void() dragon_blast3 = [10, dragon_blast4]
{
	drag_missile(NO_ROTATE, MOVETIME);
};

void() dragon_blast4 = [11, dragon_blast5]
{
	drag_missile(NO_ROTATE, MOVETIME);
};

void() dragon_blast5 = [12, dragon_blast6]
{
	drag_missile(NO_ROTATE, MOVETIME);
};

void() dragon_blast6 = [13, dragon_blast7]
{
	drag_missile(NO_ROTATE, MOVETIME);
};

void() dragon_blast7 = [14, dragon_blast8]
{
	drag_missile(NO_ROTATE, MOVETIME);
};

void() dragon_blast8 = [15, dragon_blast9]
{
	drag_missile(NO_ROTATE, MOVETIME);
};

void() dragon_blast9 = [16, dragon_blast10]
{
	PM_FlapNoise();
	drag_missile(NO_ROTATE, MOVETIME);
	sound(self, CHAN_WEAPON, "dragon/thunder.wav", USE_COUNT, ATTN_NORM);
	PM_DragonBlast('44 -3 -12');
};

void() dragon_blast10 = [15, dragon_blast11]
{
	drag_missile(NO_ROTATE, MOVETIME);
};

void() dragon_blast11 = [14, dragon_blast12]
{
	drag_missile(NO_ROTATE, MOVETIME);
};

void() dragon_blast12 = [13, dragon_blast13]
{
	drag_missile(NO_ROTATE, MOVETIME);
};

void() dragon_blast13 = [12, dragon_blast14]
{
	drag_missile(NO_ROTATE, MOVETIME);
};

void() dragon_blast14 = [11, dragon_blast15]
{
	drag_missile(NO_ROTATE, MOVETIME);
};

void() dragon_blast15 = [10, dragon_blast16]
{
	drag_missile(NO_ROTATE, MOVETIME);
};

void() dragon_blast16 = [9, dragon_blast17]
{
	drag_missile(NO_ROTATE, MOVETIME);
};

void() dragon_blast17 = [8, dragon_run1]
{
	drag_missile(NO_ROTATE, MOVETIME);
};

void() PM_GoldOption = 
{
	local float delta;
	if (PM_InLiquid(self))
	{
		if (self.state > IQ_LOW)
		{
			dragon_blast1();
			return;
		}
	}
	delta = vlen(self.enemy.origin - self.origin);
	if (PM_InLiquid(self.enemy))
	{
		if (self.state > IQ_NORMAL)
		{
			if (delta <= 1000)
			{
				self.aflag = 1;
				dragon_bolt1();
			}
			else
			{
				dragon_blast1();
			}
			return;
		}
	}
	if (self.enemy.classname == "monster_zombie")
	{
		if (self.state > IQ_NORMAL)
		{
			dragon_blast1();
			return;
		}
	}
	if (random() < 0.05)
	{
		if (delta <= 1000)
		{
			self.aflag = 1;
			dragon_bolt1();
			return;
		}
	}
	if (random() < 0.5)
	{
		dragon_fire1();
	}
	else
	{
		dragon_blast1();
	}
};

void() dragon_pain1 = [17, dragon_pain2]
{
	PM_Regenerate();
};

void() dragon_pain2 = [18, dragon_pain3]
{
	PM_Regenerate();
};

void() dragon_pain3 = [19, dragon_pain4]
{
	PM_Regenerate();
};

void() dragon_pain4 = [20, dragon_pain5]
{
	PM_Regenerate();
};

void() dragon_pain5 = [21, dragon_pain6]
{
	PM_Regenerate();
};

void() dragon_pain6 = [22, dragon_run1]
{
	PM_Regenerate();
};

void() dragon_painb1 = [23, dragon_painb2]
{
	PM_Regenerate();
};

void() dragon_painb2 = [24, dragon_painb3]
{
	PM_Regenerate();
};

void() dragon_painb3 = [25, dragon_painb4]
{
	PM_Regenerate();
};

void() dragon_painb4 = [26, dragon_painb5]
{
	PM_Regenerate();
};

void() dragon_painb5 = [27, dragon_painb6]
{
	PM_Regenerate();
};

void() dragon_painb6 = [28, dragon_run1]
{
	PM_Regenerate();
};

void() dragon_painc1 = [29, dragon_painc2]
{
	PM_Regenerate();
};

void() dragon_painc2 = [30, dragon_painc3]
{
	PM_Regenerate();
};

void() dragon_painc3 = [31, dragon_painc4]
{
	PM_Regenerate();
};

void() dragon_painc4 = [32, dragon_painc5]
{
	PM_Regenerate();
};

void() dragon_painc5 = [33, dragon_painc6]
{
	PM_Regenerate();
};

void() dragon_painc6 = [34, dragon_run1]
{
	PM_Regenerate();
};

void(entity attacker, float damage) dragon_pain = 
{
	local float r;
	if (self.pain_finished > time)
	{
		return;
	}
	self.pain_finished = time + USE_COUNT;
	if (self.classname == "monster_nightshade")
	{
		sound(self, CHAN_VOICE, "dragon/nitepain.wav", USE_COUNT, ATTN_NORM);
	}
	else
	{
		sound(self, CHAN_VOICE, "dragon/pain.wav", USE_COUNT, ATTN_NORM);
		if (random() * MAX_CHARMER_DISTANCE > damage)
		{
			return;
		}
	}
	r = random();
	if (r < 0.4)
	{
		dragon_pain1();
	}
	else
	{
		if (r < 0.8)
		{
			dragon_painb1();
		}
		else
		{
			dragon_painc1();
		}
	}
};

void() dragon_restart = [68, dragon_run1]
{
	spawn_tfog(self.oldstart);
	self.flags = self.flags | FL_FLY;
	PM_Reconstitute(VEC_DRAGON_MIN, VEC_DRAGON_MAX, self.max_health);
	PM_ResetEnemy();
	SUB_AttackFinished(USE_COUNT);
};

void() dragon_reform = 
{
	setsize(self, VEC_DRAGON_MIN, VEC_DRAGON_MAX);
	if (PM_Occupied(self.oldstart))
	{
		setsize(self, '-16 -16 0', '16 16 56');
		PM_Sleep(self.delay);
		self.think = dragon_reform;
		return;
	}
	spawn_tfog(self.origin + '0 0 41');
	setorigin(self, self.oldstart);
	setmodel(self, "progs/dragon.mdl");
	self.movetype = MOVETYPE_STEP;
	dragon_restart();
};

void() dragon_respawn = 
{
	setsize(self, VEC_DRAGON_MIN, VEC_DRAGON_MAX);
	if (PM_Occupied(self.oldstart))
	{
		PM_Sleep(self.delay);
		self.think = dragon_respawn;
		return;
	}
	spawn_tfog(self.origin);
	setorigin(self, self.oldstart);
	dragon_restart();
};

void() dragon_return1 = [62, dragon_return2]
{
	setsize(self, VEC_DRAGON_MIN, VEC_DRAGON_MAX);
	if (PM_Occupied(self.oldstart))
	{
		PM_Sleep(self.delay);
		self.think = dragon_return1;
		return;
	}
	setorigin(self, self.oldstart);
	setmodel(self, "progs/dragon.mdl");
	self.solid = SOLID_TRIGGER;
	self.movetype = MOVETYPE_STEP;
	setsize(self, VEC_DRAGON_MIN, VEC_DRAGON_MAX);
	self.angles = self.oldangles;
	self.fixangle = 1;
	self.flags = self.flags | FL_FLY;
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	sound(self, CHAN_VOICE, "dragon/niteact.wav", USE_COUNT, ATTN_NORM);
};

void() dragon_return2 = [63, dragon_return3]
{
};

void() dragon_return3 = [64, dragon_return4]
{
};

void() dragon_return4 = [65, dragon_return5]
{
};

void() dragon_return5 = [66, dragon_return6]
{
};

void() dragon_return6 = [67, dragon_return7]
{
};

void() dragon_return7 = [68, dragon_run1]
{
	self.health = self.max_health;
	self.takedamage = DAMAGE_AIM;
	PM_ResetEnemy();
};

void(string gibname, float dm, float gibskin) PM_ThrowWing = 
{
	local entity new;
	new = spawn();
	setmodel(new, gibname);
	setsize(new, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(new, self.origin);
	new.velocity = VelocityForDamage(dm);
	new.movetype = MOVETYPE_BOUNCE;
	new.solid = SOLID_NOT;
	new.avelocity_x = random() * 600;
	new.avelocity_y = random() * 600;
	new.avelocity_z = random() * 600;
	new.think = SUB_Remove;
	new.ltime = time;
	new.nextthink = time + SVC_SETVIEWANGLES + random() * SVC_SETVIEWANGLES;
	new.frame = OBJECT_ROTATE;
	new.flags = OBJECT_ROTATE;
	new.skin = gibskin;
};

void() dragon_die1 = [35, dragon_die2]
{
};

void() dragon_die2 = [36, dragon_die3]
{
};

void() dragon_die3 = [37, dragon_die4]
{
};

void() dragon_die4 = [38, dragon_die5]
{
};

void() dragon_die5 = [39, dragon_die6]
{
	self.solid = SOLID_NOT;
};

void() dragon_die6 = [40, dragon_die7]
{
};

void() dragon_die7 = [41, dragon_die8]
{
};

void() dragon_die8 = [42, dragon_die9]
{
};

void() dragon_die9 = [43, dragon_die10]
{
};

void() dragon_die10 = [44, dragon_die11]
{
};

void() dragon_die11 = [45, dragon_die12]
{
};

void() dragon_die12 = [46, dragon_die13]
{
};

void() dragon_die13 = [47, dragon_die14]
{
	if (self.spawnflags & SPAWN_RESPAWN)
	{
		PM_Sleep(self.delay);
		self.think = dragon_respawn;
	}
};

void() dragon_die14 = [47, dragon_die14]
{
};

void() dragon_dieb1 = [48, dragon_dieb2]
{
};

void() dragon_dieb2 = [49, dragon_dieb3]
{
};

void() dragon_dieb3 = [50, dragon_dieb4]
{
};

void() dragon_dieb4 = [51, dragon_dieb5]
{
};

void() dragon_dieb5 = [52, dragon_dieb6]
{
	self.solid = SOLID_NOT;
};

void() dragon_dieb6 = [53, dragon_dieb7]
{
	if (self.spawnflags & SPAWN_RESPAWN)
	{
		PM_Sleep(self.delay);
		self.think = dragon_respawn;
	}
};

void() dragon_dieb7 = [53, dragon_dieb7]
{
};

void() dragon_implode1 = [17, dragon_implode2]
{
};

void() dragon_implode2 = [18, dragon_implode3]
{
};

void() dragon_implode3 = [54, dragon_implode4]
{
};

void() dragon_implode4 = [55, dragon_implode5]
{
};

void() dragon_implode5 = [56, dragon_implode6]
{
};

void() dragon_implode6 = [57, dragon_implode7]
{
};

void() dragon_implode7 = [58, dragon_implode8]
{
};

void() dragon_implode8 = [59, dragon_implode9]
{
};

void() dragon_implode9 = [60, dragon_implode10]
{
};

void() dragon_implode10 = [61, SUB_Null]
{
	T_RadiusDamage(self, self, 160, world);
	sound(self, CHAN_VOICE, "blob/death1.wav", USE_GOLD_KEY, ATTN_NORM);
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_TAREXPLOSION);
	WriteCoord(MSG_BROADCAST, self.origin_x);
	WriteCoord(MSG_BROADCAST, self.origin_y);
	WriteCoord(MSG_BROADCAST, self.origin_z);
	if (self.spawnflags & SPAWN_RESPAWN)
	{
		PM_CoverUp();
		PM_Sleep(self.delay);
		self.think = dragon_return1;
		return;
	}
	PM_FreeSlaves();
	BecomeExplosion();
};

void() dragon_die = 
{
	PM_DragonStatus();
	if (self.classname == "monster_nightshade")
	{
		self.movetype = MOVETYPE_NONE;
		self.solid = SOLID_NOT;
		sound(self, CHAN_VOICE, "dragon/niteact.wav", USE_GOLD_KEY, ATTN_NORM);
		dragon_implode1();
		return;
	}
	if (self.health < -95)
	{
		sound(self, CHAN_VOICE, "player/udeath.wav", USE_GOLD_KEY, ATTN_NORM);
		ThrowHead("progs/tail.mdl", self.health, self.skin);
		ThrowGib("progs/gib3.mdl", self.health);
		ThrowGib("progs/gib3.mdl", self.health);
		ThrowGib("progs/gib3.mdl", self.health);
		PM_ThrowWing("progs/lwing.mdl", self.health, self.skin);
		PM_ThrowWing("progs/rwing.mdl", self.health, self.skin);
		if (self.spawnflags & SPAWN_RESPAWN)
		{
			PM_Sleep(self.delay);
			self.think = dragon_reform;
		}
		return;
	}
	self.velocity_x = -200 + 400 * random();
	self.velocity_y = -200 + 400 * random();
	self.velocity_z = 100 + 100 * random();
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	sound(self, CHAN_VOICE, "dragon/death.wav", USE_GOLD_KEY, ATTN_NORM);
	if (random() < 0.5)
	{
		dragon_die1();
	}
	else
	{
		dragon_dieb1();
	}
};

void() dragon_nosleep = 
{
	self.spawnflags = self.spawnflags - (self.spawnflags & SPAWN_DORMANT);
	self.th_stand = dragon_hover1;
	self.th_walk = dragon_walk1;
	self.th_run = dragon_run1;
	self.th_pain = dragon_pain;
	self.th_die = dragon_die;
};

void() dragon_rise1 = [53, dragon_rise2]
{
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	self.flags = self.flags | FL_FLY;
	dragon_nosleep();
	go_up(NO_ROTATE);
};

void() dragon_rise2 = [52, dragon_rise3]
{
	go_up(NO_ROTATE);
};

void() dragon_rise3 = [51, dragon_rise4]
{
	go_up(NO_ROTATE);
};

void() dragon_rise4 = [50, dragon_rise5]
{
	go_up(NO_ROTATE);
};

void() dragon_rise5 = [49, dragon_rise6]
{
	go_up(NO_ROTATE);
};

void() dragon_rise6 = [32, dragon_rise7]
{
	go_up(NO_ROTATE);
};

void() dragon_rise7 = [33, dragon_rise8]
{
	go_up(NO_ROTATE);
};

void() dragon_rise8 = [34, dragon_run1]
{
	go_up(NO_ROTATE);
};

void() dragon_sleep1 = [53, dragon_sleep2]
{
	setsize(self, VEC_DRAGON_MIN, VEC_DRAGON_MAX);
	self.flags = self.flags - (self.flags & FL_FLY);
	self.flags = self.flags - (self.flags & FL_ONGROUND);
};

void() dragon_sleep2 = [53, dragon_sleep2]
{
	PM_Regenerate();
	PM_DragonFindTarget();
};

void() dragon_murder = [53, dragon_die]
{
	dragon_nosleep();
};

void() dragon_vanish1 = [68, dragon_vanish2]
{
	drag_stand(NO_ROTATE, MOVETIME);
};

void() dragon_vanish2 = [67, dragon_vanish3]
{
	drag_stand(NO_ROTATE, MOVETIME);
};

void() dragon_vanish3 = [66, dragon_vanish4]
{
	drag_stand(NO_ROTATE, MOVETIME);
};

void() dragon_vanish4 = [65, dragon_vanish5]
{
	drag_stand(NO_ROTATE, MOVETIME);
};

void() dragon_vanish5 = [64, dragon_vanish6]
{
	drag_stand(NO_ROTATE, MOVETIME);
};

void() dragon_vanish6 = [63, dragon_vanish7]
{
	drag_stand(NO_ROTATE, MOVETIME);
};

void() dragon_vanish7 = [62, dragon_vanish8]
{
	drag_stand(NO_ROTATE, MOVETIME);
	self.model = "";
	self.takedamage = DAMAGE_NO;
};

void() dragon_vanish8 = [62, dragon_vanish8]
{
	drag_stand(NO_ROTATE, MOVETIME);
};

void() dragon_vanish = 
{
	if (self.takedamage)
	{
		dragon_vanish1();
	}
	else
	{
		dragon_vanish8();
	}
};

void() dragon_lurk1 = [68, dragon_lurk2]
{
	drag_walk(NO_ROTATE, MOVETIME);
};

void() dragon_lurk2 = [67, dragon_lurk3]
{
	drag_walk(NO_ROTATE, MOVETIME);
};

void() dragon_lurk3 = [66, dragon_lurk4]
{
	drag_walk(NO_ROTATE, MOVETIME);
};

void() dragon_lurk4 = [65, dragon_lurk5]
{
	drag_walk(NO_ROTATE, MOVETIME);
};

void() dragon_lurk5 = [64, dragon_lurk6]
{
	drag_walk(NO_ROTATE, MOVETIME);
};

void() dragon_lurk6 = [63, dragon_lurk7]
{
	drag_walk(NO_ROTATE, MOVETIME);
};

void() dragon_lurk7 = [62, dragon_lurk8]
{
	drag_walk(NO_ROTATE, MOVETIME);
	self.model = "";
	self.takedamage = DAMAGE_NO;
};

void() dragon_lurk8 = [62, dragon_lurk8]
{
	drag_walk(NO_ROTATE, MOVETIME);
	if (random() < 0.010000)
	{
		sound(self, CHAN_VOICE, "dragon/niteact.wav", USE_GOLD_KEY, ATTN_NORM);
	}
};

void() dragon_lurk = 
{
	if (self.takedamage)
	{
		dragon_lurk1();
	}
	else
	{
		dragon_lurk8();
	}
};

void() dragon_quickvanish = [62, dragon_vanish8]
{
	self.model = "";
	self.takedamage = DAMAGE_NO;
	self.th_stand = dragon_vanish;
	self.th_walk = dragon_lurk;
};

void() dragon_quicklurk = [62, dragon_lurk8]
{
	self.model = "";
	self.takedamage = DAMAGE_NO;
	self.th_stand = dragon_vanish;
	self.th_walk = dragon_lurk;
};

void() dragon_appear1 = [62, dragon_appear2]
{
	drag_run(MOVETIME);
};

void() dragon_appear2 = [63, dragon_appear3]
{
	drag_run(MOVETIME);
};

void() dragon_appear3 = [64, dragon_appear4]
{
	drag_run(MOVETIME);
};

void() dragon_appear4 = [65, dragon_appear5]
{
	drag_run(MOVETIME);
};

void() dragon_appear5 = [66, dragon_appear6]
{
	drag_run(MOVETIME);
};

void() dragon_appear6 = [67, dragon_appear7]
{
	drag_run(MOVETIME);
};

void() dragon_appear7 = [68, dragon_run1]
{
	drag_run(MOVETIME);
};

void() dragon_appear = 
{
	if (self.takedamage)
	{
		dragon_run1();
	}
	else
	{
		self.model = "progs/dragon.mdl";
		self.takedamage = DAMAGE_AIM;
		dragon_appear1();
	}
};

void() dragon_nopeace = 
{
	self.spawnflags = self.spawnflags - (self.spawnflags & SPAWN_PACIFIST);
	if (self.spawnflags & SPAWN_DORMANT)
	{
		self.th_run = dragon_appear;
	}
	else
	{
		self.th_run = dragon_run1;
	}
	self.th_run();
};

void(float default) PM_VerifyHealth = 
{
	if (!(self.health))
	{
		self.health = default;
	}
	self.health = floor(self.health);
	if (self.health < USE_GOLD_KEY)
	{
		self.health = default;
	}
	if (self.health > 40000)
	{
		self.health = 40000;
	}
	self.max_health = self.health;
	if (!(self.count) || !(self.wait))
	{
		self.count = OBJECT_ROTATE;
		self.wait = OBJECT_ROTATE;
		return;
	}
	self.count = floor(self.count);
	if (self.count < USE_GOLD_KEY || self.wait < 0.1)
	{
		self.count = OBJECT_ROTATE;
		self.wait = OBJECT_ROTATE;
		return;
	}
	if (self.count > self.max_health)
	{
		self.count = self.max_health;
	}
};

void(float default) PM_VerifyIQ = 
{
	if (!(self.state))
	{
		self.state = default;
		return;
	}
	self.state = floor(self.state);
	if (self.state < IQ_LOW)
	{
		self.state = default;
		return;
	}
	if (self.state > IQ_ULTIMATE)
	{
		self.state = default;
		return;
	}
	if (self.classname != "monster_reddragon")
	{
		if (self.classname != "monster_golddragon")
		{
			if (self.state > IQ_GENIUS)
			{
				self.state = IQ_GENIUS;
			}
		}
	}
};

void() PM_VerifyRespawn = 
{
	if (!(self.delay))
	{
		self.delay = OBJECT_ROTATE;
	}
	else
	{
		if (self.delay < OBJECT_ROTATE)
		{
			self.delay = OBJECT_ROTATE;
		}
		else
		{
			if (self.delay < STATE_OPEN)
			{
				self.delay = STATE_OPEN;
			}
		}
	}
};

void(float hydrophobic) PM_SetFear = 
{
	if (self.state == IQ_LOW)
	{
		self.aflag = 0;
		return;
	}
	self.aflag = hydrophobic;
};

void() PM_CheckSleep = 
{
	if (self.spawnflags & SPAWN_DORMANT)
	{
		self.th_stand = dragon_sleep1;
		self.th_walk = dragon_sleep1;
		self.th_run = dragon_rise1;
		self.th_pain = dragon_rise1;
		self.th_die = dragon_murder;
	}
};

void() PM_PrecacheDragon = 
{
	precache_model2("progs/dragon.mdl");
	precache_model2("progs/tail.mdl");
	precache_model2("progs/lwing.mdl");
	precache_model2("progs/rwing.mdl");
	precache_sound2("demon/dhit2.wav");
	precache_sound2("dragon/idlefly.wav");
	precache_sound2("dragon/sight.wav");
	precache_sound2("dragon/pain.wav");
	precache_sound2("dragon/death.wav");
};

void() monster_reddragon = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	PM_PrecacheDragon();
	precache_model2("progs/flame2.mdl");
	precache_sound2("dragon/fire.wav");
	precache_sound2("dragon/firehit.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/dragon.mdl");
	setsize(self, VEC_DRAGON_MIN, VEC_DRAGON_MAX);
	PM_VerifyHealth(1000);
	PM_VerifyIQ(IQ_GENIUS);
	PM_VerifyRespawn();
	PM_SetFear(1);
	self.skin = OBJECT_ROTATE;
	self.lefty = time;
	self.th_stand = dragon_hover1;
	self.th_walk = dragon_walk1;
	self.th_run = dragon_run1;
	self.th_melee = dragon_melee;
	self.th_missile = dragon_fire1;
	self.th_pain = dragon_pain;
	self.th_die = dragon_die;
	PM_CheckSleep();
	flymonster_start();
};

void() monster_bluedragon = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	PM_PrecacheDragon();
	precache_sound2("dragon/thunder.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/dragon.mdl");
	setsize(self, VEC_DRAGON_MIN, VEC_DRAGON_MAX);
	PM_VerifyHealth(500);
	PM_VerifyIQ(IQ_HIGH);
	PM_VerifyRespawn();
	PM_SetFear(1);
	self.skin = USE_GOLD_KEY;
	self.lefty = time;
	self.th_stand = dragon_hover1;
	self.th_walk = dragon_walk1;
	self.th_run = dragon_run1;
	self.th_melee = dragon_melee;
	self.th_missile = dragon_bolt1;
	self.th_pain = dragon_pain;
	self.th_die = dragon_die;
	PM_CheckSleep();
	flymonster_start();
};

void() monster_greendragon = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	PM_PrecacheDragon();
	precache_model2("progs/w_spike.mdl");
	precache_sound2("dragon/spit.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/dragon.mdl");
	setsize(self, VEC_DRAGON_MIN, VEC_DRAGON_MAX);
	PM_VerifyHealth(500);
	PM_VerifyIQ(IQ_HIGH);
	PM_VerifyRespawn();
	PM_SetFear(0);
	self.skin = TOUCH;
	self.lefty = time;
	self.th_stand = dragon_hover1;
	self.th_walk = dragon_walk1;
	self.th_run = dragon_run1;
	self.th_melee = dragon_melee;
	self.th_missile = dragon_spit1;
	self.th_pain = dragon_pain;
	self.th_die = dragon_die;
	PM_CheckSleep();
	flymonster_start();
};

void() monster_nightshade = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	PM_PrecacheDragon();
	PM_PrecacheMinion();
	precache_sound2("wizard/hit.wav");
	precache_sound2("blob/death1.wav");
	precache_sound2("dragon/spawn.wav");
	precache_sound2("dragon/nitepain.wav");
	precache_sound2("dragon/niteact.wav");
	self.solid = SOLID_TRIGGER;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/dragon.mdl");
	setsize(self, VEC_DRAGON_MIN, VEC_DRAGON_MAX);
	PM_VerifyHealth(250);
	self.state = IQ_NORMAL;
	PM_VerifyRespawn();
	PM_SetFear(0);
	self.skin = STATE_FIND;
	self.lip = OBJECT_ROTATE;
	if (!(self.height))
	{
		self.height = STATE_OPENING;
	}
	self.lefty = time;
	if (self.spawnflags & SPAWN_DORMANT)
	{
		self.th_stand = dragon_quickvanish;
		self.th_walk = dragon_quicklurk;
		self.th_run = dragon_appear;
	}
	else
	{
		self.th_stand = dragon_hover1;
		self.th_walk = dragon_walk1;
		self.th_run = dragon_run1;
	}
	if (self.spawnflags & SPAWN_PACIFIST)
	{
		self.th_run = dragon_nopeace;
	}
	self.th_melee = dragon_bite1;
	self.th_missile = dragon_spawn1;
	self.th_pain = dragon_pain;
	self.th_die = dragon_die;
	flymonster_start();
};

void() monster_golddragon = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	PM_PrecacheDragon();
	precache_model2("progs/flame2.mdl");
	precache_model2("progs/k_spike.mdl");
	precache_sound2("dragon/fire.wav");
	precache_sound2("dragon/firehit.wav");
	precache_sound2("dragon/thunder.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/dragon.mdl");
	setsize(self, VEC_DRAGON_MIN, VEC_DRAGON_MAX);
	PM_VerifyHealth(1000);
	PM_VerifyIQ(IQ_GENIUS);
	PM_VerifyRespawn();
	PM_SetFear(0);
	self.skin = NONBLOCKING;
	self.lefty = time;
	self.th_stand = dragon_hover1;
	self.th_walk = dragon_walk1;
	self.th_run = dragon_run1;
	if (self.state == IQ_LOW)
	{
		self.th_melee = dragon_melee;
	}
	else
	{
		self.th_melee = dragon_blast1;
	}
	self.th_missile = PM_GoldOption;
	self.th_pain = dragon_pain;
	self.th_die = dragon_die;
	PM_CheckSleep();
	flymonster_start();
};

void() monster_dragon = 
{
	if (!(self.skin))
	{
		self.skin = OBJECT_ROTATE;
	}
	self.skin = floor(self.skin);
	if (self.skin == NONBLOCKING)
	{
		self.classname = "monster_golddragon";
		monster_golddragon();
		return;
	}
	if (self.skin == STATE_FIND)
	{
		self.classname = "monster_nightshade";
		monster_nightshade();
		return;
	}
	if (self.skin == TOUCH)
	{
		self.classname = "monster_greendragon";
		monster_greendragon();
		return;
	}
	if (self.skin == USE_GOLD_KEY)
	{
		self.classname = "monster_bluedragon";
		monster_bluedragon();
		return;
	}
	self.skin = OBJECT_ROTATE;
	self.classname = "monster_reddragon";
	monster_reddragon();
};

