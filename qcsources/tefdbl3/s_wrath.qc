float(entity thePoint) isSpawnPointEmpty = 
{
	local entity neighbors;
	local entity start;
	neighbors = findradius(thePoint.origin, FL_GODMODE);
	if (neighbors == world)
	{
		return 1;
	}
	start = neighbors;
	while (neighbors)
	{
		if (neighbors != thePoint)
		{
			if (neighbors.flags & FL_MONSTER)
			{
				return 0;
			}
			else
			{
				if (neighbors.classname == "player")
				{
					return 0;
				}
				else
				{
					if (neighbors.think)
					{
						return 0;
					}
				}
			}
		}
		neighbors = neighbors.chain;
		if (neighbors == start)
		{
			return 1;
		}
	}
	return 1;
};

entity() overlord_find_dest3 = 
{
	local entity furthestDest;
	local entity bestDest;
	local entity curDest;
	local entity thePlayer;
	local float theDist;
	local float curDist;
	local float dot;
	local vector curVector;
	furthestDest = world;
	bestDest = world;
	theDist = 0;
	thePlayer = find(world, classname, "player");
	curDest = world;
	makevectors(thePlayer.angles);
	while (1)
	{
		curDest = find(curDest, classname, "info_overlord_destination");
		if (curDest == world)
		{
			if (bestDest != world)
			{
				return bestDest;
			}
			return furthestDest;
		}
		if (isSpawnPointEmpty(curDest))
		{
			curVector = curDest.origin - thePlayer.origin;
			curDist = vlen(curVector);
			curVector = normalize(curVector);
			dot = curVector * v_forward;
			if (dot > 0.6)
			{
				if (curDist > MIN_CHARMER_DISTANCE)
				{
					bestDest = curDest;
				}
			}
			if (curDist > theDist)
			{
				furthestDest = curDest;
				theDist = curDist;
			}
		}
	}
	return world;
};

void() overlord_find_dest = 
{
	local entity curDest;
	local entity lastDest;
	local float loopCount;
	curDest = find(world, classname, "info_overlord_destination");
	if (curDest != world)
	{
		lastDest = curDest;
		loopCount = random() * MOVETYPE_FLY;
		while (loopCount > 1)
		{
			curDest = nextent(curDest);
			curDest = find(curDest, classname, "info_overlord_destination");
			if (curDest != world)
			{
				if (isSpawnPointEmpty(curDest))
				{
					loopCount = loopCount - 1;
					lastDest = curDest;
				}
				else
				{
					curDest = world;
				}
			}
			else
			{
				return lastDest;
			}
		}
		return curDest;
	}
	return curDest;
};

void() overlord_teleport = 
{
	local float chance;
	local entity theDest;
	local vector org;
	if (!(self.spawnflags & FL_SWIM))
	{
		return;
	}
	chance = random();
	if (chance > 0.75)
	{
		return;
	}
	theDest = overlord_find_dest3();
	if (theDest == world)
	{
		return;
	}
	spawn_tfog(self.origin);
	makevectors(self.angles);
	org = theDest.origin + FL_MONSTER * v_forward;
	spawn_tfog(org);
	spawn_tdeath(theDest.origin, self);
	setorigin(self, theDest.origin);
	self.flags = self.flags - (self.flags & FL_ONGROUND);
};

void() overlord_stand1 = [1, overlord_stand1]
{
	ai_stand();
};

void() overlord_walk01 = [1, overlord_walk02]
{
	ai_walk(FL_CLIENT);
};

void() overlord_walk02 = [2, overlord_walk03]
{
	ai_walk(FL_CLIENT);
};

void() overlord_walk03 = [3, overlord_walk04]
{
	ai_walk(FL_CLIENT);
};

void() overlord_walk04 = [4, overlord_walk05]
{
	ai_walk(FL_CLIENT);
};

void() overlord_walk05 = [5, overlord_walk06]
{
	ai_walk(FL_CLIENT);
};

void() overlord_walk06 = [6, overlord_walk07]
{
	ai_walk(FL_CLIENT);
};

void() overlord_walk07 = [7, overlord_walk08]
{
	ai_walk(FL_CLIENT);
};

void() overlord_walk08 = [8, overlord_walk09]
{
	ai_walk(FL_CLIENT);
};

void() overlord_walk09 = [9, overlord_walk10]
{
	ai_walk(FL_CLIENT);
};

void() overlord_walk10 = [10, overlord_walk11]
{
	ai_walk(FL_CLIENT);
};

void() overlord_walk11 = [11, overlord_walk12]
{
	ai_walk(FL_CLIENT);
};

void() overlord_walk12 = [12, overlord_walk13]
{
	ai_walk(FL_CLIENT);
};

void() overlord_walk13 = [13, overlord_walk14]
{
	ai_walk(FL_CLIENT);
};

void() overlord_walk14 = [14, overlord_walk15]
{
	ai_walk(FL_CLIENT);
};

void() overlord_walk15 = [15, overlord_walk01]
{
	ai_walk(FL_CLIENT);
};

void() overlord_run01 = [1, overlord_run02]
{
	ai_run(TE_EXPLOSION2);
};

void() overlord_run02 = [2, overlord_run03]
{
	ai_run(TE_EXPLOSION2);
};

void() overlord_run03 = [3, overlord_run04]
{
	ai_run(TE_EXPLOSION2);
};

void() overlord_run04 = [4, overlord_run05]
{
	ai_run(TE_EXPLOSION2);
};

void() overlord_run05 = [5, overlord_run06]
{
	ai_run(TE_EXPLOSION2);
};

void() overlord_run06 = [6, overlord_run07]
{
	ai_run(TE_EXPLOSION2);
};

void() overlord_run07 = [7, overlord_run08]
{
	ai_run(TE_EXPLOSION2);
};

void() overlord_run08 = [8, overlord_run09]
{
	ai_run(TE_EXPLOSION2);
};

void() overlord_run09 = [9, overlord_run10]
{
	ai_run(TE_EXPLOSION2);
};

void() overlord_run10 = [10, overlord_run11]
{
	ai_run(TE_EXPLOSION2);
};

void() overlord_run11 = [11, overlord_run12]
{
	ai_run(TE_EXPLOSION2);
};

void() overlord_run12 = [12, overlord_run13]
{
	ai_run(TE_EXPLOSION2);
};

void() overlord_run13 = [13, overlord_run14]
{
	ai_run(TE_EXPLOSION2);
};

void() overlord_run14 = [14, overlord_run15]
{
	ai_run(TE_EXPLOSION2);
};

void() overlord_run15 = [15, overlord_run01]
{
	ai_run(TE_EXPLOSION2);
};

void() overlord_at_a01 = [16, overlord_at_a02]
{
	ai_charge(TE_EXPLOSION2);
};

void() overlord_at_a02 = [17, overlord_at_a03]
{
	ai_charge(TE_EXPLOSION2);
};

void() overlord_at_a03 = [18, overlord_at_a04]
{
	ai_charge(TE_EXPLOSION2);
};

void() overlord_at_a04 = [19, overlord_at_a05]
{
	ai_charge(TE_EXPLOSION2);
};

void() overlord_at_a05 = [20, overlord_at_a06]
{
	ai_charge(TE_EXPLOSION2);
};

void() overlord_at_a06 = [21, overlord_at_a07]
{
	ai_charge(TE_EXPLOSION2);
};

void() overlord_at_a07 = [22, overlord_at_a08]
{
	overlord_smash();
};

void() overlord_at_a08 = [23, overlord_at_a09]
{
	ai_charge(TE_EXPLOSION2);
};

void() overlord_at_a09 = [24, overlord_at_a10]
{
	ai_charge(TE_EXPLOSION2);
};

void() overlord_at_a10 = [25, overlord_run01]
{
	ai_charge(TE_EXPLOSION2);
};

void() overlord_at_b01 = [26, overlord_at_b02]
{
	ai_charge(TE_EXPLOSION2);
};

void() overlord_at_b02 = [27, overlord_at_b03]
{
	ai_charge(TE_EXPLOSION2);
};

void() overlord_at_b03 = [28, overlord_at_b04]
{
	ai_charge(TE_EXPLOSION2);
};

void() overlord_at_b04 = [29, overlord_at_b05]
{
	ai_charge(TE_EXPLOSION2);
};

void() overlord_at_b05 = [30, overlord_at_b06]
{
	ai_charge(TE_EXPLOSION2);
};

void() overlord_at_b06 = [31, overlord_at_b07]
{
	ai_charge(TE_EXPLOSION2);
};

void() overlord_at_b07 = [32, overlord_at_b08]
{
	ai_charge(TE_EXPLOSION2);
};

void() overlord_at_b08 = [33, overlord_at_b09]
{
	overlord_smash();
};

void() overlord_at_b09 = [34, overlord_at_b10]
{
	ai_charge(TE_EXPLOSION2);
};

void() overlord_at_b10 = [35, overlord_at_b11]
{
	ai_charge(TE_EXPLOSION2);
};

void() overlord_at_b11 = [36, overlord_at_b12]
{
	ai_charge(TE_EXPLOSION2);
};

void() overlord_at_b12 = [37, overlord_at_b13]
{
	ai_charge(TE_EXPLOSION2);
};

void() overlord_at_b13 = [38, overlord_at_b14]
{
	ai_charge(TE_EXPLOSION2);
};

void() overlord_at_b14 = [39, overlord_run01]
{
	ai_charge(TE_EXPLOSION2);
};

void() overlord_at_c01 = [40, overlord_at_c02]
{
	ai_charge(TE_EXPLOSION2);
};

void() overlord_at_c02 = [41, overlord_at_c03]
{
	ai_charge(TE_EXPLOSION2);
};

void() overlord_at_c03 = [42, overlord_at_c04]
{
	ai_charge(TE_EXPLOSION2);
};

void() overlord_at_c04 = [43, overlord_at_c05]
{
	ai_charge(TE_EXPLOSION2);
};

void() overlord_at_c05 = [44, overlord_at_c06]
{
	ai_charge(TE_EXPLOSION2);
};

void() overlord_at_c06 = [45, overlord_at_c07]
{
	overlord_smash();
};

void() overlord_at_c07 = [46, overlord_at_c08]
{
	ai_charge(TE_EXPLOSION2);
};

void() overlord_at_c08 = [47, overlord_at_c09]
{
	ai_charge(TE_EXPLOSION2);
};

void() overlord_at_c09 = [48, overlord_at_c10]
{
	ai_charge(TE_EXPLOSION2);
};

void() overlord_at_c10 = [49, overlord_at_c11]
{
	ai_charge(TE_EXPLOSION2);
};

void() overlord_at_c11 = [50, overlord_at_c12]
{
	overlord_smash();
};

void() overlord_at_c12 = [51, overlord_at_c13]
{
	ai_charge(TE_EXPLOSION2);
};

void() overlord_at_c13 = [52, overlord_at_c14]
{
	ai_charge(TE_EXPLOSION2);
};

void() overlord_at_c14 = [53, overlord_run01]
{
	ai_charge(TE_EXPLOSION2);
};

void() overlord_smash = 
{
	local vector delta;
	local float smashDmg;
	if (!(self.enemy))
	{
		return;
	}
	if (!CanDamage(self.enemy, self))
	{
		return;
	}
	ai_charge(MOVETYPE_BOUNCE);
	delta = self.enemy.origin - self.origin;
	if (vlen(delta) > 100)
	{
		return;
	}
	smashDmg = 20 + random() * MOVETYPE_BOUNCE;
	sound(self, CHAN_WEAPON, "s_wrath/smash.wav", 1, ATTN_NORM);
	T_Damage(self.enemy, self, self, smashDmg);
	delta = normalize(self.enemy.origin - self.origin + self.enemy.view_ofs);
	SpawnBlood(self.enemy.origin - delta * SVC_INTERMISSION, delta * -100, smashDmg);
};

void() overlord_melee = 
{
	local float r;
	r = random();
	if (r < 0.33)
	{
		overlord_at_a01();
	}
	else
	{
		if (r < 0.66)
		{
			overlord_at_b01();
		}
		else
		{
			overlord_at_c01();
		}
	}
};

void() overlord_msl_a01 = [54, overlord_msl_a02]
{
	ai_charge(TE_EXPLOSION2);
};

void() overlord_msl_a02 = [55, overlord_msl_a03]
{
	ai_charge(TE_EXPLOSION2);
};

void() overlord_msl_a03 = [56, overlord_msl_a04]
{
	ai_charge(TE_EXPLOSION2);
};

void() overlord_msl_a04 = [57, overlord_msl_a05]
{
	ai_charge(TE_EXPLOSION2);
};

void() overlord_msl_a05 = [58, overlord_msl_a06]
{
	ai_charge(TE_EXPLOSION2);
};

void() overlord_msl_a06 = [59, overlord_msl_a07]
{
	WrathMissile(MOVETYPE_STEP);
};

void() overlord_msl_a07 = [60, overlord_msl_a08]
{
	ai_charge(TE_EXPLOSION2);
};

void() overlord_msl_a08 = [61, overlord_msl_a09]
{
	ai_charge(TE_EXPLOSION2);
};

void() overlord_msl_a09 = [62, overlord_msl_a10]
{
	ai_charge(TE_EXPLOSION2);
};

void() overlord_msl_a10 = [63, overlord_msl_a11]
{
	ai_charge(TE_EXPLOSION2);
};

void() overlord_msl_a11 = [64, overlord_msl_a12]
{
	ai_charge(TE_EXPLOSION2);
};

void() overlord_msl_a12 = [65, overlord_run01]
{
	overlord_teleport();
};

void() overlord_missile = 
{
	local float r;
	r = random();
	overlord_msl_a01();
};

void() overlord_pn_a01 = [66, overlord_pn_a02]
{
};

void() overlord_pn_a02 = [67, overlord_pn_a03]
{
};

void() overlord_pn_a03 = [68, overlord_pn_a04]
{
	overlord_teleport();
};

void() overlord_pn_a04 = [69, overlord_pn_a05]
{
};

void() overlord_pn_a05 = [70, overlord_pn_a06]
{
};

void() overlord_pn_a06 = [71, overlord_pn_a07]
{
};

void() overlord_pn_a07 = [72, overlord_run01]
{
};

void() overlord_pn_b01 = [80, overlord_pn_b02]
{
};

void() overlord_pn_b02 = [81, overlord_pn_b03]
{
};

void() overlord_pn_b03 = [82, overlord_pn_b04]
{
	overlord_teleport();
};

void() overlord_pn_b04 = [83, overlord_pn_b05]
{
};

void() overlord_pn_b05 = [84, overlord_pn_b06]
{
};

void() overlord_pn_b06 = [85, overlord_pn_b07]
{
};

void() overlord_pn_b07 = [86, overlord_run01]
{
};

void() overlord_pain = 
{
	local float r;
	if (self.pain_finished > time)
	{
		return;
	}
	r = random();
	if (r > 0.2)
	{
		return;
	}
	if (r < 0.15)
	{
		overlord_pn_a01();
	}
	else
	{
		overlord_pn_b01();
	}
	self.pain_finished = time + FL_SWIM;
	sound(self, CHAN_VOICE, "wrath/wpain.wav", 1, ATTN_NORM);
};

void(string gibName) ol_toss = 
{
	local vector flingVelocity;
	local entity myGib;
	makevectors(self.angles);
	flingVelocity = v_forward * 250 + v_up * 300;
	flingVelocity = flingVelocity + v_up * (random() * 100 - 50);
	flingVelocity = flingVelocity + v_right * (random() * MAX_CHARMER_DISTANCE - 100);
	myGib = StartGib(gibName);
	myGib.velocity = flingVelocity;
};

void() overlord_die01 = [91, overlord_die02]
{
	self.nextthink = time + 0.05;
};

void() overlord_die02 = [92, overlord_die03]
{
	self.flags = self.flags | FL_FLY;
	self.nextthink = time + 0.05;
};

void() overlord_die03 = [93, overlord_die04]
{
	self.nextthink = time + 0.05;
};

void() overlord_die04 = [94, overlord_die05]
{
	self.nextthink = time + 0.05;
};

void() overlord_die05 = [95, overlord_die06]
{
	self.nextthink = time + 0.05;
};

void() overlord_die06 = [96, overlord_die07]
{
	self.nextthink = time + 0.05;
};

void() overlord_die07 = [97, overlord_die08]
{
	self.nextthink = time + 0.05;
};

void() overlord_die08 = [98, overlord_die09]
{
	self.nextthink = time + 0.05;
};

void() overlord_die09 = [99, overlord_die10]
{
	self.nextthink = time + 0.05;
};

void() overlord_die10 = [99, overlord_die11]
{
	self.nextthink = time + 0.05;
};

void() overlord_die11 = [100, overlord_die12]
{
	self.nextthink = time + 0.05;
};

void() overlord_die12 = [101, overlord_die13]
{
	self.nextthink = time + 0.05;
};

void() overlord_die13 = [102, overlord_die14]
{
	self.nextthink = time + 0.05;
};

void() overlord_die14 = [103, overlord_die15]
{
	self.nextthink = time + 0.05;
};

void() overlord_die15 = [104, overlord_die16]
{
	self.nextthink = time + 0.05;
};

void() overlord_die16 = [105, overlord_die17]
{
	self.nextthink = time + 0.05;
};

void() overlord_die17 = [106, overlord_die18]
{
	self.model = "";
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_EXPLOSION2);
	WriteCoord(MSG_BROADCAST, self.origin_x);
	WriteCoord(MSG_BROADCAST, self.origin_y);
	WriteCoord(MSG_BROADCAST, self.origin_z);
	WriteByte(MSG_BROADCAST, 0);
	WriteByte(MSG_BROADCAST, MOVETYPE_STEP);
	ol_toss("progs/s_wrtgb2.mdl");
	ol_toss("progs/s_wrtgb3.mdl");
	ol_toss("progs/wrthgib1.mdl");
	ol_toss("progs/wrthgib2.mdl");
	ol_toss("progs/wrthgib3.mdl");
	self.nextthink = time + 0.1;
};

void() overlord_die18 = [107, overlord_die19]
{
	local float counter;
	counter = FL_SWIM;
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_EXPLOSION2);
	WriteCoord(MSG_BROADCAST, self.origin_x);
	WriteCoord(MSG_BROADCAST, self.origin_y);
	WriteCoord(MSG_BROADCAST, self.origin_z);
	WriteByte(MSG_BROADCAST, 0);
	WriteByte(MSG_BROADCAST, MOVETYPE_STEP);
	while (counter > 0)
	{
		ol_toss("progs/gib1.mdl");
		ol_toss("progs/gib2.mdl");
		ol_toss("progs/gib3.mdl");
		counter = counter - 1;
	}
	self.nextthink = time + 0.1;
};

void() overlord_die19 = [107, overlord_die19]
{
	local float counter;
	counter = FL_SWIM;
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_EXPLOSION2);
	WriteCoord(MSG_BROADCAST, self.origin_x);
	WriteCoord(MSG_BROADCAST, self.origin_y);
	WriteCoord(MSG_BROADCAST, self.origin_z);
	WriteByte(MSG_BROADCAST, 0);
	WriteByte(MSG_BROADCAST, MOVETYPE_STEP);
	while (counter > 0)
	{
		ol_toss("progs/gib1.mdl");
		ol_toss("progs/gib2.mdl");
		ol_toss("progs/gib3.mdl");
		counter = counter - 1;
	}
	remove(self);
};

void() monster_super_wrath = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/s_wrath.mdl");
	precache_model("progs/s_wrtgb2.mdl");
	precache_model("progs/s_wrtgb3.mdl");
	precache_model("progs/wrthgib1.mdl");
	precache_model("progs/wrthgib2.mdl");
	precache_model("progs/wrthgib3.mdl");
	precache_model("progs/w_ball.mdl");
	precache_sound("wrath/wsee.wav");
	precache_sound("wrath/watt.wav");
	precache_sound("wrath/wpain.wav");
	precache_sound("wrath/wdthc.wav");
	precache_sound("s_wrath/smash.wav");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "progs/s_wrath.mdl");
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.health = CHARMED_RADIUS;
	self.pain_finished = 0;
	self.th_stand = overlord_stand1;
	self.th_walk = overlord_walk01;
	self.th_run = overlord_run01;
	self.th_missile = overlord_missile;
	self.th_melee = overlord_melee;
	self.th_pain = overlord_pain;
	self.th_die = overlord_die02;
	flymonster_start();
};

void() info_overlord_destination = 
{
	self.mangle = self.angles;
	self.angles = VEC_ORIGIN;
	self.model = "";
	self.origin = self.origin + '0 0 27';
};

