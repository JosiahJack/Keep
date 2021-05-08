void() trigger_drolejump_touch = 
{
	if ((other.flags & (FL_MONSTER | FL_FLY | FL_SWIM)) != FL_MONSTER)
	{
		return;
	}
	other.velocity_x = self.movedir_x * self.speed;
	other.velocity_y = self.movedir_y * self.speed;
	if (!(other.flags & FL_ONGROUND))
	{
		return;
	}
	if (other.badhealth != LIGHTNING_RANDOM)
	{
		return;
	}
	other.flags = other.flags - FL_ONGROUND;
	other.velocity_z = self.height;
};

void() trigger_drolejump = 
{
	if (!(self.speed))
	{
		self.speed = 200;
	}
	if (!(self.height))
	{
		self.height = 200;
	}
	if (self.angles == VEC_ORIGIN)
	{
		self.angles = '0 360 0';
	}
	InitTrigger();
	self.touch = trigger_drolejump_touch;
};

void() th_run_choice = 
{
	if (self.badhealth == LIGHTNING_RANDOM)
	{
		self.th_run = drole_run1;
		self.think = self.th_run;
	}
	else
	{
		self.th_run = drole_move1;
		self.think = self.th_run;
	}
};

void() ai_run_loiter = 
{
	local float ofs;
	self.ideal_yaw = enemy_yaw;
	if (self.lefty)
	{
		ofs = 85;
	}
	else
	{
		ofs = -85;
	}
	self.ideal_yaw = self.ideal_yaw + ofs;
	ChangeYaw();
	self.ideal_yaw = self.ideal_yaw - ofs;
	if (walkmove(self.ideal_yaw + ofs, movedist))
	{
		return;
	}
	self.lefty = LIGHTNING_RANDOM - self.lefty;
	walkmove(self.ideal_yaw - ofs, movedist);
};

void(float dist) ai_drole_run = 
{
	local vector delta;
	local float axis;
	local float direct;
	local float ang_rint;
	local float ang_floor;
	local float ang_ceil;
	local float enemydistance;
	enemydistance = vlen(self.enemy.origin - self.origin);
	if (enemydistance < 350 && enemy_vis && self.th_run != drole_run1)
	{
		if (self.attack_state != AS_LOITER)
		{
			self.attack_state = AS_LOITER;
		}
	}
	else
	{
		if (enemydistance >= 300)
		{
			if (self.attack_state != AS_STRAIGHT)
			{
				self.attack_state = AS_STRAIGHT;
			}
		}
		else
		{
			if (!enemy_vis)
			{
				if (self.attack_state != AS_STRAIGHT)
				{
					self.attack_state = AS_STRAIGHT;
				}
			}
			else
			{
				if (self.th_run == drole_run1)
				{
					if (self.attack_state != AS_STRAIGHT)
					{
						self.attack_state = AS_STRAIGHT;
					}
				}
			}
		}
	}
	if (enemy_vis)
	{
		self.drole_searchtime = time + LIGHTNING_RANDOM + LIGHTNING_BOOM * random();
	}
	if (self.badhealth == LIGHTNING_RANDOM && self.th_run != drole_run1)
	{
		self.th_run = drole_run1;
		self.think = self.th_run;
	}
	if (self.badhealth == MSG_BROADCAST && self.th_run != drole_move1 && self.drole_searchtime > time)
	{
		self.th_run = drole_move1;
		self.think = self.th_run;
	}
	else
	{
		if (self.badhealth == MSG_BROADCAST && !enemy_vis && self.th_run != drole_run1 && self.drole_searchtime < time)
		{
			self.th_run = drole_run1;
			self.think = self.th_run;
		}
	}
	movedist = dist;
	if (self.enemy.health <= MSG_BROADCAST)
	{
		self.enemy = world;
		if (self.oldenemy.health > MSG_BROADCAST)
		{
			self.enemy = self.oldenemy;
			HuntTarget();
		}
		else
		{
			if (self.movetarget)
			{
				self.th_walk();
			}
			else
			{
				self.th_stand();
			}
			return;
		}
	}
	self.show_hostile = time + LIGHTNING_RANDOM;
	enemy_vis = visible(self.enemy);
	if (enemy_vis)
	{
		self.search_time = time + AS_BLINDFIRE;
	}
	if (coop && self.search_time < time)
	{
		if (FindTarget())
		{
			return;
		}
	}
	enemy_infront = infront(self.enemy);
	enemy_range = range(self.enemy);
	enemy_yaw = vectoyaw(self.enemy.origin - self.origin);
	if (self.attack_state == AS_MISSILE)
	{
		ai_run_missile();
		return;
	}
	if (self.attack_state == AS_MELEE)
	{
		ai_run_melee();
		return;
	}
	if (CheckAnyAttack())
	{
		return;
	}
	if (self.attack_state == AS_LOITER)
	{
		ai_run_loiter();
		return;
	}
	movetogoal(dist);
	ai_shotcheck();
};

void() drole_stand_a1 = [0, drole_stand_a2]
{
	ai_stand();
};

void() drole_stand_a2 = [1, drole_stand_a3]
{
	ai_stand();
};

void() drole_stand_a3 = [2, drole_stand_a4]
{
	ai_stand();
};

void() drole_stand_a4 = [3, drole_stand_a5]
{
	ai_stand();
};

void() drole_stand_a5 = [4, drole_stand_a6]
{
	ai_stand();
};

void() drole_stand_a6 = [5, drole_stand_a7]
{
	ai_stand();
};

void() drole_stand_a7 = [6, drole_stand_a8]
{
	ai_stand();
};

void() drole_stand_a8 = [7, drole_stand_a9]
{
	ai_stand();
};

void() drole_stand_a9 = [8, drole_stand_a10]
{
	ai_stand();
};

void() drole_stand_a10 = [9, drole_stand_a11]
{
	ai_stand();
};

void() drole_stand_a11 = [10, drole_stand_a12]
{
	ai_stand();
};

void() drole_stand_a12 = [11, drole_stand_a13]
{
	ai_stand();
};

void() drole_stand_a13 = [12, drole_stand_a14]
{
	ai_stand();
};

void() drole_stand_a14 = [13, drole_stand_a15]
{
	ai_stand();
};

void() drole_stand_a15 = [14, drole_stand_a16]
{
	ai_stand();
};

void() drole_stand_a16 = [15, drole_stand_a17]
{
	ai_stand();
};

void() drole_stand_a17 = [16, drole_stand_a18]
{
	ai_stand();
};

void() drole_stand_a18 = [17, drole_stand_a19]
{
	ai_stand();
};

void() drole_stand_a19 = [18, drole_stand_a20]
{
	ai_stand();
};

void() drole_stand_a20 = [19, drole_stand_a21]
{
	ai_stand();
};

void() drole_stand_a21 = [20, drole_stand_a22]
{
	ai_stand();
};

void() drole_stand_a22 = [21, drole_stand_a23]
{
	ai_stand();
};

void() drole_stand_a23 = [22, drole_stand_a24]
{
	ai_stand();
};

void() drole_stand_a24 = [23, drole_stand_a25]
{
	ai_stand();
};

void() drole_stand_a25 = [24, drole_stand_a26]
{
	ai_stand();
};

void() drole_stand_a26 = [25, drole_stand_a27]
{
	ai_stand();
};

void() drole_stand_a27 = [26, drole_stand_a28]
{
	ai_stand();
};

void() drole_stand_a28 = [27, drole_stand_a29]
{
	ai_stand();
};

void() drole_stand_a29 = [28, drole_stand_a30]
{
	ai_stand();
};

void() drole_stand_a30 = [29, drole_stand_c1]
{
	ai_stand();
};

void() drole_stand_b1 = [30, drole_stand_b2]
{
	ai_stand();
};

void() drole_stand_b2 = [31, drole_stand_b3]
{
	ai_stand();
};

void() drole_stand_b3 = [32, drole_stand_b4]
{
	ai_stand();
};

void() drole_stand_b4 = [33, drole_stand_b5]
{
	ai_stand();
};

void() drole_stand_b5 = [34, drole_stand_b6]
{
	ai_stand();
};

void() drole_stand_b6 = [35, drole_stand_b7]
{
	ai_stand();
};

void() drole_stand_b7 = [36, drole_stand_b8]
{
	ai_stand();
};

void() drole_stand_b8 = [37, drole_stand_b9]
{
	ai_stand();
};

void() drole_stand_b9 = [38, drole_stand_b10]
{
	ai_stand();
};

void() drole_stand_b10 = [39, drole_stand_b11]
{
	ai_stand();
};

void() drole_stand_b11 = [40, drole_stand_b12]
{
	ai_stand();
};

void() drole_stand_b12 = [41, drole_stand_b13]
{
	ai_stand();
};

void() drole_stand_b13 = [42, drole_stand_b14]
{
	ai_stand();
};

void() drole_stand_b14 = [43, drole_stand_b15]
{
	ai_stand();
};

void() drole_stand_b15 = [44, drole_stand_b16]
{
	ai_stand();
};

void() drole_stand_b16 = [45, drole_stand_b17]
{
	ai_stand();
};

void() drole_stand_b17 = [46, drole_stand_b18]
{
	ai_stand();
};

void() drole_stand_b18 = [47, drole_stand_b19]
{
	ai_stand();
};

void() drole_stand_b19 = [48, drole_stand_b20]
{
	ai_stand();
};

void() drole_stand_b20 = [49, drole_stand_b21]
{
	ai_stand();
};

void() drole_stand_b21 = [50, drole_stand_b22]
{
	ai_stand();
};

void() drole_stand_b22 = [51, drole_stand_b23]
{
	ai_stand();
};

void() drole_stand_b23 = [52, drole_stand_b24]
{
	ai_stand();
};

void() drole_stand_b24 = [53, drole_stand_b25]
{
	ai_stand();
};

void() drole_stand_b25 = [54, drole_stand_b26]
{
	ai_stand();
};

void() drole_stand_b26 = [55, drole_stand_b27]
{
	ai_stand();
};

void() drole_stand_b27 = [56, drole_stand_b28]
{
	ai_stand();
};

void() drole_stand_b28 = [57, drole_stand_b29]
{
	ai_stand();
};

void() drole_stand_b29 = [58, drole_stand_b30]
{
	ai_stand();
};

void() drole_stand_b30 = [59, drole_stand_b31]
{
	ai_stand();
};

void() drole_stand_b31 = [60, drole_stand_b32]
{
	ai_stand();
};

void() drole_stand_b32 = [61, drole_stand_b33]
{
	ai_stand();
};

void() drole_stand_b33 = [62, drole_stand_b34]
{
	ai_stand();
};

void() drole_stand_b34 = [63, drole_stand_b35]
{
	ai_stand();
};

void() drole_stand_b35 = [64, drole_stand_b36]
{
	ai_stand();
};

void() drole_stand_b36 = [65, drole_stand_b37]
{
	ai_stand();
};

void() drole_stand_b37 = [66, drole_stand_b38]
{
	ai_stand();
};

void() drole_stand_b38 = [67, drole_stand_b39]
{
	ai_stand();
};

void() drole_stand_b39 = [68, drole_stand_b40]
{
	ai_stand();
};

void() drole_stand_b40 = [69, drole_stand_c1]
{
	ai_stand();
};

void() drole_stand_c1 = [70, drole_stand_c2]
{
	ai_stand();
};

void() drole_stand_c2 = [71, drole_stand_c3]
{
	ai_stand();
};

void() drole_stand_c3 = [72, drole_stand_c4]
{
	ai_stand();
};

void() drole_stand_c4 = [73, drole_stand_c5]
{
	ai_stand();
};

void() drole_stand_c5 = [74, drole_stand_c6]
{
	ai_stand();
};

void() drole_stand_c6 = [75, drole_stand_c7]
{
	ai_stand();
};

void() drole_stand_c7 = [76, drole_stand_c8]
{
	ai_stand();
};

void() drole_stand_c8 = [77, drole_stand_c9]
{
	ai_stand();
};

void() drole_stand_c9 = [78, drole_stand_c10]
{
	ai_stand();
};

void() drole_stand_c10 = [79, drole_stand_c11]
{
	ai_stand();
};

void() drole_stand_c11 = [80, drole_stand_c12]
{
	ai_stand();
};

void() drole_stand_c12 = [81, drole_stand_c13]
{
	ai_stand();
};

void() drole_stand_c13 = [82, drole_stand_c14]
{
	ai_stand();
};

void() drole_stand_c14 = [83, drole_stand_c15]
{
	ai_stand();
};

void() drole_stand_c15 = [84, drole_stand_c16]
{
	ai_stand();
};

void() drole_stand_c16 = [85, drole_stand_c17]
{
	ai_stand();
};

void() drole_stand_c17 = [86, drole_stand_c18]
{
	ai_stand();
};

void() drole_stand_c18 = [87, drole_stand_c19]
{
	ai_stand();
};

void() drole_stand_c19 = [88, drole_stand_c20]
{
	ai_stand();
};

void() drole_stand_c20 = [89, drole_stand_c21]
{
	ai_stand();
};

void() drole_stand_c21 = [90, drole_stand_c22]
{
	ai_stand();
};

void() drole_stand_c22 = [91, drole_stand_c23]
{
	ai_stand();
};

void() drole_stand_c23 = [92, drole_stand_c24]
{
	ai_stand();
};

void() drole_stand_c24 = [93, drole_stand_c25]
{
	ai_stand();
};

void() drole_stand_c25 = [94, drole_stand_c26]
{
	ai_stand();
};

void() drole_stand_c26 = [95, drole_stand_c27]
{
	ai_stand();
};

void() drole_stand_c27 = [96, drole_stand_c28]
{
	ai_stand();
};

void() drole_stand_c28 = [97, drole_stand_c29]
{
	ai_stand();
};

void() drole_stand_c29 = [98, drole_stand_c30]
{
	ai_stand();
};

void() drole_stand_c30 = [99, drole_stand_c1]
{
	local float animpick;
	ai_stand();
	animpick = random();
	if (animpick < 0.33)
	{
		self.think = drole_stand_a1;
	}
	else
	{
		if (animpick < 0.66)
		{
			self.think = drole_stand_b1;
		}
		else
		{
			self.think = self.think;
		}
	}
	if (random() > 0.5)
	{
		sound(self, CHAN_VOICE, "drole/idle.wav", LIGHTNING_RANDOM, ATTN_IDLE);
	}
};

void() drole_walk1 = [109, drole_walk2]
{
	ai_walk(TE_LAVASPLASH);
};

void() drole_walk2 = [110, drole_walk3]
{
	ai_walk(TE_LIGHTNING3);
};

void() drole_walk3 = [111, drole_walk4]
{
	ai_walk(TE_LIGHTNING3);
};

void() drole_walk4 = [112, drole_walk5]
{
	ai_walk(AS_BLINDFIRE);
};

void() drole_walk5 = [113, drole_walk6]
{
	ai_walk(AS_LOITER);
};

void() drole_walk6 = [114, drole_walk7]
{
	ai_walk(TE_EXPLOSION2);
};

void() drole_walk7 = [115, drole_walk8]
{
	ai_walk(SECRET_NO_SHOOT);
};

void() drole_walk8 = [116, drole_walk9]
{
	ai_walk(AS_MELEE);
};

void() drole_walk9 = [109, drole_walk10]
{
	ai_walk(TE_BEAM);
};

void() drole_walk10 = [110, drole_walk11]
{
	ai_walk(TE_LIGHTNING3);
};

void() drole_walk11 = [111, drole_walk12]
{
	ai_walk(TE_WIZSPIKE);
};

void() drole_walk12 = [112, drole_walk1]
{
	ai_walk(TE_WIZSPIKE);
	if (random() > 0.8)
	{
		sound(self, CHAN_VOICE, "drole/idle.wav", LIGHTNING_RANDOM, ATTN_IDLE);
	}
};

void() drole_run1 = [123, drole_run2]
{
	ai_drole_run(34 * self.coiled);
};

void() drole_run2 = [124, drole_run3]
{
	ai_drole_run(DOOR_TOGGLE * self.coiled);
};

void() drole_run3 = [125, drole_run4]
{
	ai_drole_run(38 * self.coiled);
};

void() drole_run4 = [126, drole_run5]
{
	ai_drole_run(35 * self.coiled);
};

void() drole_run5 = [127, drole_run6]
{
	ai_drole_run(34 * self.coiled);
};

void() drole_run6 = [128, drole_run7]
{
	ai_drole_run(DOOR_TOGGLE * self.coiled);
};

void() drole_run7 = [129, drole_run8]
{
	ai_drole_run(38 * self.coiled);
};

void() drole_run8 = [130, drole_run1]
{
	ai_drole_run(35 * self.coiled);
	if (random() > 0.8)
	{
		sound(self, CHAN_VOICE, "drole/idle.wav", LIGHTNING_RANDOM, ATTN_IDLE);
	}
};

void() drole_jump1 = [117, drole_jump2]
{
};

void() drole_jump2 = [118, drole_jump3]
{
};

void() drole_jump3 = [119, drole_jump4]
{
};

void() drole_jump4 = [120, drole_jump5]
{
};

void() drole_jump5 = [121, drole_run1]
{
};

void() drole_move1 = [109, drole_move2]
{
	ai_drole_run(TE_LAVASPLASH * 1.5);
};

void() drole_move2 = [110, drole_move3]
{
	ai_drole_run(TE_LIGHTNING3 * 1.5);
};

void() drole_move3 = [111, drole_move4]
{
	ai_drole_run(TE_LIGHTNING3 * 1.5);
};

void() drole_move4 = [112, drole_move5]
{
	ai_drole_run(AS_BLINDFIRE * 1.5);
};

void() drole_move5 = [113, drole_move6]
{
	ai_drole_run(AS_LOITER * 1.5);
};

void() drole_move6 = [114, drole_move7]
{
	ai_drole_run(TE_EXPLOSION2 * 1.5);
};

void() drole_move7 = [115, drole_move8]
{
	ai_drole_run(SECRET_NO_SHOOT * 1.5);
};

void() drole_move8 = [116, drole_move9]
{
	ai_drole_run(AS_MELEE * 1.5);
};

void() drole_move9 = [109, drole_move10]
{
	ai_drole_run(TE_BEAM * 1.5);
};

void() drole_move10 = [110, drole_move11]
{
	ai_drole_run(TE_LIGHTNING3 * 1.5);
};

void() drole_move11 = [111, drole_move12]
{
	ai_drole_run(TE_WIZSPIKE * 1.5);
};

void() drole_move12 = [112, drole_move1]
{
	ai_drole_run(TE_WIZSPIKE * 1.5);
	if (random() > 0.8)
	{
		sound(self, CHAN_VOICE, "drole/idle.wav", LIGHTNING_RANDOM, ATTN_IDLE);
	}
};

void() drole_smash1 = [122, drole_smash2]
{
	sound(self, CHAN_VOICE, "drole/swipe.wav", LIGHTNING_RANDOM, ATTN_NORM);
	ai_charge(LIGHTNING_BOOM);
};

void() drole_smash2 = [122, drole_smash3]
{
	ai_charge(AS_LOITER);
};

void() drole_smash3 = [122, drole_smash4]
{
	ai_charge(AS_LOITER);
};

void() drole_smash4 = [122, drole_smash5]
{
	ai_charge(AS_BLINDFIRE);
};

void() drole_smash5 = [122, drole_smash6]
{
	ai_charge(SECRET_1ST_DOWN);
};

void() drole_smash6 = [122, drole_smash7]
{
	ai_charge(LIGHTNING_RANDOM);
};

void() drole_smash7 = [122, drole_smash8]
{
	ai_charge(MSG_BROADCAST);
};

void() drole_smash8 = [122, drole_smash9]
{
	ai_charge(MSG_BROADCAST);
};

void() drole_smash9 = [122, drole_smash10]
{
	ai_charge(MSG_BROADCAST);
};

void() drole_smash10 = [122, drole_smash11]
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
	ldmg = 50;
	T_Damage(self.enemy, self, self, ldmg);
	if (random() < 0.5)
	{
		sound(self, CHAN_AUTO, "drole/strike1.wav", LIGHTNING_RANDOM, ATTN_NORM);
	}
	else
	{
		sound(self, CHAN_AUTO, "drole/strike2.wav", LIGHTNING_RANDOM, ATTN_NORM);
	}
	SpawnMeatSpray(self.origin + v_forward * SECRET_YES_SHOOT, crandom() * 100 * v_right);
	SpawnMeatSpray(self.origin + v_forward * SECRET_YES_SHOOT, crandom() * 100 * v_right);
};

void() drole_smash11 = [122, drole_smash12]
{
	ai_charge(AS_BLINDFIRE);
};

void() drole_smash12 = [122, drole_run1]
{
	ai_charge(SECRET_1ST_DOWN);
	th_run_choice();
};

void(float side) DroleHit = 
{
	local vector delta;
	local float ldmg;
	if (!(self.enemy))
	{
		return;
	}
	ai_charge(TE_LAVASPLASH);
	delta = self.enemy.origin - self.origin;
	if (vlen(delta) > 100)
	{
		return;
	}
	ldmg = TE_EXPLOSION2 + AS_LOITER * random();
	T_Damage(self.enemy, self, self, ldmg);
	if (random() < 0.5)
	{
		sound(self, CHAN_AUTO, "drole/strike1.wav", LIGHTNING_RANDOM, ATTN_NORM);
	}
	else
	{
		sound(self, CHAN_AUTO, "drole/strike2.wav", LIGHTNING_RANDOM, ATTN_NORM);
	}
	if (side)
	{
		makevectors(self.angles);
		SpawnMeatSpray(self.origin + v_forward * SECRET_YES_SHOOT, side * v_right);
	}
};

void() drole_swingl1 = [153, drole_swingl2]
{
	ai_charge(34 * self.coiled);
	sound(self, CHAN_VOICE, "drole/swipe.wav", LIGHTNING_RANDOM, ATTN_NORM);
};

void() drole_swingl2 = [154, drole_swingl3]
{
	ai_charge(DOOR_TOGGLE * self.coiled);
};

void() drole_swingl3 = [155, drole_swingl4]
{
	ai_charge(38 * self.coiled);
};

void() drole_swingl4 = [156, drole_swingl5]
{
	ai_charge(35 * self.coiled);
};

void() drole_swingl5 = [157, drole_swingl6]
{
	ai_charge(34 * self.coiled);
	DroleHit(-250);
};

void() drole_swingl6 = [158, drole_swingl7]
{
	ai_charge(DOOR_TOGGLE * self.coiled);
	sound(self, CHAN_VOICE, "drole/swipe.wav", LIGHTNING_RANDOM, ATTN_NORM);
};

void() drole_swingl7 = [159, drole_swingl8]
{
	ai_charge(38 * self.coiled);
};

void() drole_swingl8 = [160, drole_swingl9]
{
	ai_charge(35 * self.coiled);
};

void() drole_swingl9 = [161, drole_swingl10]
{
	ai_charge(34 * self.coiled);
};

void() drole_swingl10 = [162, drole_swingl11]
{
	ai_charge(DOOR_TOGGLE * self.coiled);
	DroleHit(-250);
};

void() drole_swingl11 = [163, drole_swingl12]
{
	ai_charge(38 * self.coiled);
};

void() drole_swingl12 = [164, drole_swingl13]
{
	ai_charge(35 * self.coiled);
};

void() drole_swingl13 = [165, drole_swingl14]
{
	ai_charge(34 * self.coiled);
};

void() drole_swingl14 = [166, drole_swingl15]
{
	ai_charge(DOOR_TOGGLE * self.coiled);
};

void() drole_swingl15 = [167, drole_swingl16]
{
	ai_charge(38 * self.coiled);
};

void() drole_swingl16 = [168, drole_run1]
{
	local float enemydistance;
	ai_charge(35 * self.coiled);
	enemydistance = vlen(self.enemy.origin - self.origin);
	ai_charge(TE_LAVASPLASH);
	th_run_choice();
	if (random() < 0.5 && enemydistance < 140 && self.enemy.health > MSG_BROADCAST)
	{
		self.think = drole_swingr1;
	}
};

void() drole_swingr1 = [137, drole_swingr2]
{
	ai_charge(34 * self.coiled);
	sound(self, CHAN_VOICE, "drole/swipe.wav", LIGHTNING_RANDOM, ATTN_NORM);
};

void() drole_swingr2 = [138, drole_swingr3]
{
	ai_charge(DOOR_TOGGLE * self.coiled);
};

void() drole_swingr3 = [139, drole_swingr4]
{
	ai_charge(38 * self.coiled);
};

void() drole_swingr4 = [140, drole_swingr5]
{
	ai_charge(35 * self.coiled);
};

void() drole_swingr5 = [141, drole_swingr6]
{
	ai_charge(34 * self.coiled);
	DroleHit(-250);
};

void() drole_swingr6 = [142, drole_swingr7]
{
	ai_charge(DOOR_TOGGLE * self.coiled);
	sound(self, CHAN_VOICE, "drole/swipe.wav", LIGHTNING_RANDOM, ATTN_NORM);
};

void() drole_swingr7 = [143, drole_swingr8]
{
	ai_charge(38 * self.coiled);
};

void() drole_swingr8 = [144, drole_swingr9]
{
	ai_charge(35 * self.coiled);
};

void() drole_swingr9 = [145, drole_swingr10]
{
	ai_charge(34 * self.coiled);
};

void() drole_swingr10 = [146, drole_swingr11]
{
	ai_charge(DOOR_TOGGLE * self.coiled);
	DroleHit(-250);
};

void() drole_swingr11 = [147, drole_swingr12]
{
	ai_charge(38 * self.coiled);
};

void() drole_swingr12 = [148, drole_swingr13]
{
	ai_charge(35 * self.coiled);
};

void() drole_swingr13 = [149, drole_swingr14]
{
	ai_charge(34 * self.coiled);
};

void() drole_swingr14 = [150, drole_swingr15]
{
	ai_charge(DOOR_TOGGLE * self.coiled);
};

void() drole_swingr15 = [151, drole_swingr16]
{
	ai_charge(38 * self.coiled);
};

void() drole_swingr16 = [152, drole_run1]
{
	local float enemydistance;
	ai_charge(35 * self.coiled);
	enemydistance = vlen(self.enemy.origin - self.origin);
	ai_charge(TE_LAVASPLASH);
	th_run_choice();
	if (random() < 0.5 && enemydistance < 140 && self.enemy.health > MSG_BROADCAST)
	{
		self.think = drole_swingl1;
	}
};

void() drole_melee = 
{
	if (random() > 0.5)
	{
		drole_swingr1();
	}
	else
	{
		drole_swingl1();
	}
};

void() drole_ball_touch = 
{
	local vector org;
	if (other == self.owner)
	{
		return;
	}
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	org = self.origin - SECRET_NO_SHOOT * normalize(self.velocity);
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord(MSG_BROADCAST, org_x);
	WriteCoord(MSG_BROADCAST, org_y);
	WriteCoord(MSG_BROADCAST, org_z);
	sound(self, CHAN_AUTO, "drole/explode3.wav", LIGHTNING_RANDOM, ATTN_NORM);
	T_RadiusDamage(self, self.owner, 80, other);
	T_Damage(other, self, self.owner, 43 + AS_BLINDFIRE * random());
	remove(self);
};

void() drole_ball1 = [1, drole_ball2]
{
	ai_face();
	ai_shotcheck();
	self.nextthink = time + 0.2;
};

void() drole_ball2 = [2, drole_ball3]
{
	ai_face();
	ai_shotcheck();
	self.velocity = self.velocity * 1.5;
};

void() drole_ball3 = [3, drole_ball4]
{
	self.velocity = self.velocity * 1.5;
};

void() drole_ball4 = [3, SUB_Remove]
{
	local float sk;
	self.nextthink = time + AS_BLINDFIRE;
	sk = cvar("skill");
	if (sk == MSG_BROADCAST)
	{
		self.velocity = self.velocity * 3.5;
	}
	else
	{
		self.velocity = self.velocity * 4.5;
	}
};

void() drolefire = 
{
	local vector offang;
	local vector org;
	local vector vec;
	local vector lead;
	local vector d;
	local float t;
	local vector spot1;
	local vector spot2;
	local entity targ;
	local float chance;
	local float dgdist;
	newmis = spawn();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;
	org = self.origin + '0 0 34';
	setmodel(newmis, "progs/drlbomb.mdl");
	setsize(newmis, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(newmis, org);
	newmis.frame = MSG_BROADCAST;
	if (visible(self.enemy))
	{
		if (self.enemy.classname == "player" || self.enemy.classname == "monster_gaunt")
		{
			lead = self.enemy.velocity * 0.4;
			lead_z = lead_z * 0.2;
			vec = self.enemy.origin + '0 0 -8' + lead;
		}
		else
		{
			vec = self.enemy.origin + '0 0 -8';
		}
		vec = normalize(vec - org);
	}
	else
	{
		vec = self.oldenemyorigin + '0 0 -8';
		vec = normalize(vec - org);
	}
	newmis.velocity = vec * 80;
	newmis.avelocity = '400 400 400';
	newmis.angles = vectoangles(newmis.velocity);
	newmis.nextthink = time + 0.025;
	newmis.think = drole_ball1;
	newmis.touch = drole_ball_touch;
	newmis.classname = "drolefireball";
};

void() drole_magic1 = [100, drole_magic2]
{
	ai_face();
	ai_shotcheck();
	sound(self, CHAN_WEAPON, "drole/fire.wav", LIGHTNING_RANDOM, ATTN_NORM);
};

void() drole_magic2 = [101, drole_magic3]
{
	ai_face();
	ai_shotcheck();
};

void() drole_magic3 = [102, drole_magic4]
{
	ai_face();
	ai_shotcheck();
};

void() drole_magic4 = [103, drole_magic5]
{
	ai_face();
	ai_shotcheck();
	drolefire();
};

void() drole_magic5 = [104, drole_magic6]
{
	ai_face();
	ai_shotcheck();
};

void() drole_magic6 = [105, drole_magic9]
{
	ai_face();
	ai_shotcheck();
};

void() drole_magic9 = [106, drole_magic10]
{
	ai_face();
	ai_shotcheck();
};

void() drole_magic10 = [107, drole_magic11]
{
	ai_face();
	ai_shotcheck();
};

void() drole_magic11 = [108, drole_magic12]
{
	ai_face();
	ai_shotcheck();
};

void() drole_magic12 = [107, drole_run1]
{
	ai_face();
	th_run_choice();
	ai_shotcheck();
};

void() drole_magic = 
{
	local float enemydistance;
	enemydistance = vlen(self.enemy.origin - self.origin);
	if (self.badhealth == LIGHTNING_RANDOM && enemydistance < 250)
	{
		return;
	}
	drole_magic1();
};

void() drole_pain1 = [131, drole_pain2]
{
	ai_back(SECRET_NO_SHOOT);
};

void() drole_pain2 = [132, drole_pain3]
{
	ai_back(TE_LAVASPLASH);
};

void() drole_pain3 = [133, drole_pain4]
{
	ai_back(TE_LAVASPLASH);
};

void() drole_pain4 = [134, drole_pain5]
{
	ai_back(SECRET_NO_SHOOT);
};

void() drole_pain5 = [135, drole_pain6]
{
	ai_back(AS_LOITER);
};

void() drole_pain6 = [136, drole_run1]
{
	ai_back(SECRET_1ST_DOWN);
	th_run_choice();
};

void(entity attacker, float damage) drole_pain = 
{
	if (self.health < 350 && self.badhealth == MSG_BROADCAST)
	{
		self.badhealth = LIGHTNING_RANDOM;
		sound(self, CHAN_AUTO, "drole/sight2.wav", LIGHTNING_RANDOM, 0.5);
		drole_pain1();
		return;
	}
	if (random() < 0.3 && self.health > MSG_BROADCAST)
	{
		if (self.pain_finished > time)
		{
			return;
		}
		self.pain_finished = time + LIGHTNING_BOOM;
		sound(self, CHAN_VOICE, "drole/pain.wav", LIGHTNING_RANDOM, ATTN_NORM);
		drole_pain1();
	}
};

void() drole_death1 = [169, drole_death2]
{
};

void() drole_death2 = [170, drole_death3]
{
};

void() drole_death3 = [171, drole_death4]
{
	self.solid = SOLID_NOT;
};

void() drole_death4 = [172, drole_death5]
{
};

void() drole_death5 = [173, drole_death6]
{
};

void() drole_death6 = [174, drole_death7]
{
};

void() drole_death7 = [175, drole_death8]
{
};

void() drole_death8 = [176, drole_death9]
{
};

void() drole_death9 = [177, drole_death10]
{
};

void() drole_death10 = [178, drole_death11]
{
};

void() drole_death11 = [179, drole_death12]
{
};

void() drole_death12 = [180, drole_death13]
{
};

void() drole_death13 = [181, drole_death14]
{
};

void() drole_death14 = [182, drole_death15]
{
};

void() drole_death15 = [183, drole_death16]
{
};

void() drole_death16 = [184, drole_death17]
{
};

void() drole_death17 = [185, drole_death18]
{
};

void() drole_death18 = [186, drole_death19]
{
};

void() drole_death19 = [187, drole_death20]
{
};

void() drole_death20 = [188, drole_death21]
{
};

void() drole_death21 = [189, drole_death22]
{
};

void() drole_death22 = [190, drole_death23]
{
};

void() drole_death23 = [191, drole_death24]
{
};

void() drole_death24 = [192, drole_death25]
{
};

void() drole_death25 = [193, drole_death26]
{
};

void() drole_death26 = [194, monster_fade]
{
};

void() drole_die = 
{
	if (self.health < -60)
	{
		sound(self, CHAN_VOICE, "player/udeath.wav", LIGHTNING_RANDOM, ATTN_NORM);
		ThrowHead("progs/h_drole.mdl", self.health);
		ThrowGib("progs/gib1.mdl", self.health);
		ThrowGib("progs/gib2.mdl", self.health);
		ThrowGib("progs/gib3.mdl", self.health);
		return;
	}
	sound(self, CHAN_VOICE, "drole/death.wav", LIGHTNING_RANDOM, ATTN_NORM);
	drole_death1();
};

void() drole_start = 
{
	local vector org;
	if (!(self.spawnflags & TRIGGER_SPAWNSILENT))
	{
		org = self.origin + SECRET_YES_SHOOT * v_forward;
		spawn_tfog(org);
	}
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/drole.mdl");
	setsize(self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	self.coiled = 0.8;
	self.health = 500;
	monster_spawn();
	walkmonster_start_go();
};

void() drole_begin = 
{
	if (self.spawndelay == LIGHTNING_RANDOM)
	{
		self.nextthink = time + random() * 0.4;
	}
	else
	{
		self.nextthink = time + 0.1;
	}
	self.think = drole_start;
};

void() monster_drole = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/drole.mdl");
	precache_model("progs/h_drole.mdl");
	precache_model("progs/drlbomb.mdl");
	precache_sound("drole/explode3.wav");
	precache_sound("drole/death.wav");
	precache_sound("drole/pain.wav");
	precache_sound("drole/idle.wav");
	precache_sound("drole/sight.wav");
	precache_sound("drole/sight2.wav");
	precache_sound("drole/strike1.wav");
	precache_sound("drole/strike2.wav");
	precache_sound("drole/swipe.wav");
	precache_sound("drole/fire.wav");
	self.th_stand = drole_stand_c1;
	self.th_walk = drole_walk1;
	self.th_run = drole_move1;
	self.th_die = drole_die;
	self.th_melee = drole_melee;
	self.th_missile = drole_magic;
	self.th_pain = drole_pain;
	self.coiled = 0.8;
	if (self.spawnflags & TRIGGER_SPAWN)
	{
		self.use = drole_begin;
		total_monsters = total_monsters + LIGHTNING_RANDOM;
		return;
	}
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/drole.mdl");
	setsize(self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	self.health = 500;
	walkmonster_start();
};

float() DroleCheckAttack = 
{
	local vector spot1;
	local vector spot2;
	local entity targ;
	local float chance;
	local float enemydistance;
	if (!enemy_vis)
	{
		return 0;
	}
	if (enemy_range == RANGE_FAR)
	{
		if (self.attack_state != AS_STRAIGHT)
		{
			self.attack_state = AS_STRAIGHT;
			drole_run1();
		}
		return 0;
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
	enemydistance = vlen(self.enemy.origin - self.origin);
	if (enemydistance < 150)
	{
		self.th_melee();
		return 1;
	}
	if (time < self.attack_finished)
	{
		return 0;
	}
	if (enemy_range == RANGE_FAR)
	{
		return 0;
	}
	if (self.badhealth == MSG_BROADCAST)
	{
		if (enemydistance >= 100)
		{
			chance = 0.9;
		}
	}
	else
	{
		if (enemydistance >= 100)
		{
			chance = 0.3;
		}
	}
	if (random() < chance)
	{
		self.th_missile();
		SUB_AttackFinished(LIGHTNING_RANDOM + LIGHTNING_BOOM * random());
		return 1;
	}
	return 0;
};

