void() morph_stand1 = [0, morph_stand1]
{
	ai_stand();
};

void() morph_walk1 = [43, morph_walk2]
{
	ai_walk(MOVETYPE_WALK);
};

void() morph_walk2 = [44, morph_walk3]
{
	ai_walk(FL_SWIM);
};

void() morph_walk3 = [45, morph_walk4]
{
	ai_walk(MOVETYPE_STEP);
};

void() morph_walk4 = [46, morph_walk5]
{
	ai_walk(MOVETYPE_FLY);
};

void() morph_walk5 = [47, morph_walk6]
{
	ai_walk(MOVETYPE_FLY);
};

void() morph_walk6 = [48, morph_walk7]
{
	ai_walk(MOVETYPE_STEP);
};

void() morph_walk7 = [49, morph_walk8]
{
	ai_walk(FL_SWIM);
};

void() morph_walk8 = [50, morph_walk9]
{
	ai_walk(MOVETYPE_WALK);
};

void() morph_walk9 = [51, morph_walk10]
{
	ai_walk(MOVETYPE_STEP);
};

void() morph_walk10 = [52, morph_walk11]
{
	ai_walk(MOVETYPE_FLY);
};

void() morph_walk11 = [53, morph_walk12]
{
	ai_walk(MOVETYPE_FLY);
};

void() morph_walk12 = [54, morph_walk13]
{
	ai_walk(MOVETYPE_STEP);
};

void() morph_walk13 = [55, morph_walk1]
{
	ai_walk(MOVETYPE_WALK);
};

void() morph_run1 = [32, morph_run2]
{
	ai_run(MOVETYPE_PUSH);
};

void() morph_run2 = [33, morph_run3]
{
	ai_run(MOVETYPE_BOUNCEMISSILE);
};

void() morph_run3 = [34, morph_run4]
{
	ai_run(FL_INWATER);
};

void() morph_run4 = [35, morph_run5]
{
	ai_run(FL_INWATER);
};

void() morph_run5 = [36, morph_run6]
{
	ai_run(MOVETYPE_BOUNCEMISSILE);
};

void() morph_run6 = [37, morph_run7]
{
	ai_run(MOVETYPE_PUSH);
};

void() morph_run7 = [38, morph_run8]
{
	ai_run(MOVETYPE_BOUNCEMISSILE);
};

void() morph_run8 = [39, morph_run9]
{
	ai_run(15);
};

void() morph_run9 = [40, morph_run10]
{
	ai_run(19);
};

void() morph_run10 = [41, morph_run11]
{
	ai_run(15);
};

void() morph_run11 = [42, morph_run1]
{
	ai_run(MOVETYPE_BOUNCEMISSILE);
};

void() morph_stab2 = 
{
	local float dist;
	local float attackDamage;
	local vector org;
	local vector dir;
	if (!(self.enemy))
	{
		return;
	}
	if (!CanDamage(self.enemy, self))
	{
		return;
	}
	ai_face();
	dir = self.enemy.origin - self.origin + self.enemy.view_ofs;
	dist = vlen(dir);
	dir = normalize(dir);
	makevectors(self.angles);
	if (dist <= 90)
	{
		sound(self, CHAN_WEAPON, "enforcer/enfstop.wav", 1, ATTN_STATIC);
		attackDamage = random() * MOVETYPE_BOUNCE + 20;
		T_Damage(self.enemy, self, self, attackDamage);
		SpawnBlood(self.enemy.origin, v_forward * 150, 14);
	}
	else
	{
		self.effects = self.effects | EF_MUZZLEFLASH;
		org = self.origin + v_forward * 80 + v_right * MOVETYPE_STEP + '0 0 4';
		LaunchLaser(org, dir);
		if (dist)
		{
			LaunchLaser(org, dir + v_right * 0.040000);
			LaunchLaser(org, dir - v_right * 0.040000);
		}
		else
		{
			LaunchLaser(org, dir + v_right * 0.1);
			LaunchLaser(org, dir - v_right * 0.1);
		}
	}
};

void() morph_attack01 = [65, morph_attack02]
{
	ai_face();
};

void() morph_attack02 = [66, morph_attack03]
{
	ai_face();
};

void() morph_attack03 = [67, morph_attack04]
{
	ai_face();
};

void() morph_attack04 = [68, morph_attack05]
{
	ai_face();
};

void() morph_attack05 = [69, morph_attack06]
{
	ai_face();
};

void() morph_attack06 = [70, morph_attack07]
{
	ai_face();
};

void() morph_attack07 = [71, morph_attack08]
{
	morph_stab2();
};

void() morph_attack08 = [72, morph_attack09]
{
	ai_face();
};

void() morph_attack09 = [73, morph_attack10]
{
	ai_face();
};

void() morph_attack10 = [74, morph_attack11]
{
	ai_face();
};

void() morph_attack11 = [75, morph_attack12]
{
	ai_face();
};

void() morph_attack12 = [65, morph_run1]
{
	ai_face();
};

void() morph_bigattack01 = [76, morph_bigattack02]
{
	ai_face();
};

void() morph_bigattack02 = [77, morph_bigattack03]
{
	ai_face();
};

void() morph_bigattack03 = [78, morph_bigattack04]
{
	ai_face();
};

void() morph_bigattack04 = [79, morph_bigattack05]
{
	ai_face();
};

void() morph_bigattack05 = [80, morph_bigattack06]
{
	ai_face();
};

void() morph_bigattack06 = [81, morph_bigattack07]
{
	ai_face();
};

void() morph_bigattack07 = [82, morph_bigattack08]
{
	ai_face();
};

void() morph_bigattack08 = [83, morph_bigattack09]
{
	ai_face();
};

void() morph_bigattack09 = [84, morph_bigattack10]
{
	ai_face();
};

void() morph_bigattack10 = [85, morph_bigattack11]
{
	morph_stab2();
};

void() morph_bigattack11 = [86, morph_bigattack12]
{
	ai_face();
};

void() morph_bigattack12 = [87, morph_bigattack13]
{
	ai_face();
};

void() morph_bigattack13 = [88, morph_bigattack14]
{
	ai_face();
};

void() morph_bigattack14 = [89, morph_bigattack15]
{
	ai_face();
};

void() morph_bigattack15 = [90, morph_bigattack16]
{
	ai_face();
};

void() morph_bigattack16 = [91, morph_bigattack17]
{
	ai_face();
};

void() morph_bigattack17 = [76, morph_run1]
{
	ai_face();
};

void() morph_smack = 
{
	local vector delta;
	local float ldmg;
	if (!(self.enemy))
	{
		return;
	}
	if (!CanDamage(self.enemy, self))
	{
		return;
	}
	ai_face();
	delta = self.enemy.origin - self.origin;
	if (vlen(delta) > MAX_SHELLS)
	{
		return;
	}
	ldmg = random() * MOVETYPE_BOUNCE + MOVETYPE_BOUNCE;
	T_Damage(self.enemy, self, self, ldmg);
	makevectors(self.angles);
	self.enemy.velocity = v_forward * MAX_SHELLS + '0 0 100';
};

void() morph_knockback01 = [92, morph_knockback02]
{
	ai_face();
};

void() morph_knockback02 = [93, morph_knockback03]
{
	ai_face();
};

void() morph_knockback03 = [94, morph_knockback04]
{
	ai_face();
};

void() morph_knockback04 = [95, morph_knockback05]
{
	ai_face();
};

void() morph_knockback05 = [96, morph_knockback06]
{
	ai_face();
};

void() morph_knockback06 = [97, morph_knockback07]
{
	ai_face();
};

void() morph_knockback07 = [98, morph_knockback08]
{
	ai_face();
};

void() morph_knockback08 = [99, morph_knockback09]
{
	ai_face();
};

void() morph_knockback09 = [100, morph_knockback10]
{
	morph_smack();
};

void() morph_knockback10 = [101, morph_knockback11]
{
	ai_face();
};

void() morph_knockback11 = [102, morph_knockback12]
{
	ai_face();
};

void() morph_knockback12 = [103, morph_run1]
{
	ai_face();
};

void() morph_attack = 
{
	local float attackChoice;
	attackChoice = random();
	if (attackChoice < 0.5)
	{
		morph_bigattack01();
	}
	else
	{
		if (attackChoice < 0.75)
		{
			morph_attack01();
		}
		else
		{
			morph_knockback01();
		}
	}
};

void() morph_fire = 
{
	local vector org;
	local vector dir;
	ai_face();
	self.effects = self.effects | EF_MUZZLEFLASH;
	makevectors(self.angles);
	org = self.origin + v_forward * SVC_INTERMISSION + v_right * 8.5 + '0 0 16';
	dir = normalize(self.enemy.origin - self.origin);
	LaunchLaser(org, dir);
	if (vlen(self.enemy.origin - self.origin) > 400)
	{
		LaunchLaser(org, dir + v_right * 0.040000);
		LaunchLaser(org, dir - v_right * 0.040000);
	}
	else
	{
		LaunchLaser(org, dir + v_right * 0.1);
		LaunchLaser(org, dir - v_right * 0.1);
	}
};

void() morph_fire1 = [56, morph_fire2]
{
	ai_face();
};

void() morph_fire2 = [57, morph_fire3]
{
	ai_face();
};

void() morph_fire3 = [58, morph_fire4]
{
	ai_face();
};

void() morph_fire4 = [59, morph_fire5]
{
	morph_fire();
};

void() morph_fire5 = [60, morph_fire6]
{
	ai_face();
};

void() morph_fire6 = [61, morph_fire7]
{
	ai_face();
};

void() morph_fire7 = [62, morph_fire8]
{
	ai_face();
};

void() morph_fire8 = [63, morph_fire9]
{
	ai_face();
};

void() morph_fire9 = [64, morph_run1]
{
	ai_face();
};

void() morph_painA1 = [104, morph_painA2]
{
};

void() morph_painA2 = [105, morph_painA3]
{
};

void() morph_painA3 = [106, morph_painA4]
{
};

void() morph_painA4 = [107, morph_painA5]
{
};

void() morph_painA5 = [108, morph_painA6]
{
};

void() morph_painA6 = [109, morph_painA7]
{
};

void() morph_painA7 = [110, morph_painA8]
{
};

void() morph_painA8 = [111, morph_painA9]
{
};

void() morph_painA9 = [112, morph_painA10]
{
};

void() morph_painA10 = [113, morph_run1]
{
	if (skill > 0)
	{
		morph_teleport();
	}
};

void() morph_painB1 = [114, morph_painB2]
{
};

void() morph_painB2 = [115, morph_painB3]
{
};

void() morph_painB3 = [116, morph_painB4]
{
};

void() morph_painB4 = [117, morph_painB5]
{
};

void() morph_painB5 = [118, morph_painB6]
{
};

void() morph_painB6 = [119, morph_painB7]
{
};

void() morph_painB7 = [120, morph_run1]
{
	if (skill > 0)
	{
		morph_teleport();
	}
};

void() morph_pain = 
{
	local float painChoice;
	if (skill == MOVETYPE_WALK)
	{
		if (random() > 0.5)
		{
			morph_teleport();
		}
		return;
	}
	if (self.pain_finished > time)
	{
		return;
	}
	if (random() > 0.25)
	{
		return;
	}
	painChoice = random();
	self.pain_finished = time + FL_SWIM;
	sound(self, CHAN_VOICE, "guard/pain1.wav", 1, ATTN_NORM);
	if (painChoice > 0.6)
	{
		self.think = morph_painB1;
	}
	else
	{
		self.think = morph_painA1;
	}
	self.nextthink = time + 0.1;
};

void() morph_die1 = [121, morph_die2]
{
};

void() morph_die2 = [122, morph_die3]
{
};

void() morph_die3 = [123, morph_die4]
{
};

void() morph_die4 = [124, morph_die5]
{
};

void() morph_die5 = [125, morph_die6]
{
};

void() morph_die6 = [126, morph_die7]
{
};

void() morph_die7 = [127, morph_die8]
{
};

void() morph_die8 = [128, morph_die9]
{
};

void() morph_die9 = [129, morph_die10]
{
	self.skin = self.skin + 1;
};

void() morph_die10 = [130, morph_die11]
{
};

void() morph_die11 = [131, morph_die12]
{
};

void() morph_die12 = [132, morph_die13]
{
};

void() morph_die13 = [133, morph_die14]
{
};

void() morph_die14 = [134, morph_die15]
{
};

void() morph_die15 = [135, morph_die16]
{
};

void() morph_die16 = [136, morph_die17]
{
};

void() morph_die17 = [137, morph_die18]
{
};

void() morph_die18 = [138, morph_die19]
{
};

void() morph_die19 = [139, morph_die20]
{
};

void() morph_die20 = [140, morph_die21]
{
};

void() morph_die21 = [141, morph_die21]
{
	remove(self);
};

void() morph_die = 
{
	sound(self, CHAN_VOICE, "guard/death.wav", 1, ATTN_NORM);
	self.solid = SOLID_NOT;
	self.think = morph_die1;
	self.nextthink = time + 0.1;
};

void() morph_wake1 = [1, morph_wake2]
{
	sound(self, CHAN_VOICE, "guard/see1.wav", 1, ATTN_NORM);
	if (self.owner)
	{
		total_monsters = total_monsters + 1;
		self.owner.cnt = self.owner.cnt + 1;
		WriteByte(MSG_BROADCAST, SVC_UPDATESTAT);
		WriteByte(MSG_BROADCAST, STAT_TOTALMONSTERS);
		WriteLong(MSG_BROADCAST, total_monsters);
	}
};

void() morph_wake2 = [2, morph_wake3]
{
};

void() morph_wake3 = [3, morph_wake4]
{
};

void() morph_wake4 = [4, morph_wake5]
{
};

void() morph_wake5 = [5, morph_wake6]
{
};

void() morph_wake6 = [6, morph_wake7]
{
};

void() morph_wake7 = [7, morph_wake8]
{
};

void() morph_wake8 = [8, morph_wake9]
{
};

void() morph_wake9 = [9, morph_wake10]
{
};

void() morph_wake10 = [10, morph_wake11]
{
};

void() morph_wake11 = [11, morph_wake12]
{
};

void() morph_wake12 = [12, morph_wake13]
{
};

void() morph_wake13 = [13, morph_wake14]
{
};

void() morph_wake14 = [14, morph_wake15]
{
};

void() morph_wake15 = [15, morph_wake16]
{
	self.skin = 1;
};

void() morph_wake16 = [16, morph_wake17]
{
};

void() morph_wake17 = [17, morph_wake18]
{
};

void() morph_wake18 = [18, morph_wake20]
{
};

void() morph_wake20 = [20, morph_wake21]
{
};

void() morph_wake21 = [21, morph_wake22]
{
};

void() morph_wake22 = [22, morph_wake23]
{
};

void() morph_wake23 = [23, morph_wake24]
{
};

void() morph_wake24 = [24, morph_wake25]
{
};

void() morph_wake25 = [25, morph_wake26]
{
};

void() morph_wake26 = [26, morph_wake27]
{
};

void() morph_wake27 = [27, morph_wake28]
{
};

void() morph_wake28 = [28, morph_wake29]
{
};

void() morph_wake29 = [29, morph_wake30]
{
};

void() morph_wake30 = [30, morph_wake31]
{
};

void() morph_wake31 = [31, morph_stand1]
{
	self.solid = SOLID_SLIDEBOX;
	self.takedamage = DAMAGE_AIM;
	self.skin = self.skin - 1;
	if (self.owner)
	{
		self.think = morph_run1;
		self.nextthink = time + 0.1;
	}
};

void(entity theMorph) morph_setup = 
{
	theMorph.solid = SOLID_SLIDEBOX;
	theMorph.movetype = MOVETYPE_STEP;
	theMorph.takedamage = DAMAGE_NO;
	theMorph.flags = theMorph.flags | FL_MONSTER;
	theMorph.ideal_yaw = theMorph.angles * '0 1 0';
	if (!(theMorph.yaw_speed))
	{
		theMorph.yaw_speed = 20;
	}
	theMorph.view_ofs = '0 0 25';
	theMorph.frame = 1;
	setmodel(theMorph, theMorph.model);
	setsize(theMorph, VEC_HULL_MIN, VEC_HULL_MAX);
	theMorph.th_stand = morph_stand1;
	theMorph.th_walk = morph_walk1;
	theMorph.th_run = morph_run1;
	theMorph.th_missile = morph_fire1;
	theMorph.th_melee = morph_attack;
	theMorph.th_pain = morph_pain;
	theMorph.th_die = morph_die;
	if (theMorph.owner)
	{
		theMorph.effects = 0;
		theMorph.health = MAX_SHELLS;
		theMorph.spawnflags = theMorph.owner.spawnflags;
	}
	else
	{
		theMorph.effects = theMorph.effects | EF_DIMLIGHT;
		theMorph.health = 2000;
		theMorph.cnt = 0;
	}
	theMorph.skin = FL_SWIM;
};

void() morph_wake = 
{
	if (isSpawnPointEmpty(self))
	{
		morph_setup(self);
		self.think = morph_wake1;
	}
	else
	{
		self.think = morph_wake;
	}
	self.nextthink = time + 0.1;
};

void() morph_use = 
{
	if (self.delay)
	{
		self.think = morph_wake;
		self.nextthink = time + self.delay;
	}
	else
	{
		self.think = morph_wake;
		self.nextthink = time + 0.1;
	}
};

void() morph_teleport = 
{
	local entity theDest;
	local entity theChild;
	local entity selfTemp;
	if (skill == 0)
	{
		return;
	}
	if (self.owner)
	{
		return;
	}
	if (self.cnt > skill)
	{
		return;
	}
	theDest = overlord_find_dest3();
	if (theDest == world)
	{
		return;
	}
	self.cnt = self.cnt + 1;
	theChild = spawn();
	theChild.model = self.model;
	theChild.angles = theDest.mangle;
	theChild.owner = self;
	theChild.enemy = self.enemy;
	theChild.movetarget = self.movetarget;
	theChild.goalentity = self.goalentity;
	theChild.mangle = theDest.mangle;
	theChild.classname = "monster_morph";
	morph_setup(theChild);
	setorigin(theChild, theDest.origin);
	droptofloor();
	theChild.think = morph_wake1;
	theChild.nextthink = time + 0.3;
	remove(theDest);
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
		curDest = find(curDest, classname, "info_teleport_destination");
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
				if (curDist > 150)
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

void() monster_morph = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model("progs/morph_eg.mdl");
	self.model = "progs/morph_eg.mdl";
	self.cnt = 0;
	precache_model2("progs/laser.mdl");
	precache_sound2("enforcer/enfire.wav");
	precache_sound2("guard/death.wav");
	precache_sound2("guard/pain1.wav");
	precache_sound2("guard/see1.wav");
	total_monsters = total_monsters + 1;
	if (self.targetname)
	{
		self.use = morph_use;
	}
	else
	{
		morph_wake();
	}
};

