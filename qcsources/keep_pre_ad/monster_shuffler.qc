/*
========================================

THE SHUFFLER

also known as "The Nethergoat: Spawnmaster of the Elder World"


uses the following fields in unconventional ways:

.invincible_time 	- min time before next spawn - don't use invincible_finished because it affects T_Damage
.super_time	- min time before next charge - don't use super_damage_finished because it affects T_Damage


========================================
*/


void() shuffler_stand1 = [203, shuffler_stand2] 
{
	if (random() < 0.1)
	{
		if (self.voice_finished < time)
		{
			sound(self, CHAN_VOICE, "shuffler/breathe3.wav", 1, ATTN_NORM);
			self.voice_finished = time + 5;
		}
	}

	ai_stand();
};
void() shuffler_stand2 = [205, shuffler_stand3] {ai_stand();};
void() shuffler_stand3 = [207, shuffler_stand4] {ai_stand();};
void() shuffler_stand4 = [209, shuffler_stand5] {ai_stand();};
void() shuffler_stand5 = [211, shuffler_stand6] {ai_stand();};
void() shuffler_stand6 = [213, shuffler_stand7] {ai_stand();};
void() shuffler_stand7 = [215, shuffler_stand8] {ai_stand();};
void() shuffler_stand8 = [217, shuffler_stand9] {ai_stand();};
void() shuffler_stand9 = [219, shuffler_stand10] {ai_stand();};
void() shuffler_stand10 = [221, shuffler_stand11] {ai_stand();};
void() shuffler_stand11 = [223, shuffler_stand12] {ai_stand();};
void() shuffler_stand12 = [225, shuffler_stand1] {ai_stand();};

void() shuffler_walk1 = [227, shuffler_walk2] 
{
	if (random() < 0.2)
	{
		if (self.voice_finished < time)
		{
			sound(self, CHAN_VOICE, "shuffler/breathe1.wav", 1, ATTN_NORM);
			self.voice_finished = time + 5;
		}
	}

	ai_walk(12);
};
void() shuffler_walk2 = [229, shuffler_walk3] {ai_walk(12);};
void() shuffler_walk3 = [231, shuffler_walk4] {ai_walk(9);};
void() shuffler_walk4 = [233, shuffler_walk5] {ai_walk(10);sound(self, CHAN_BODY, "shuffler/step1.wav", 0.8, ATTN_NORM);};
void() shuffler_walk5 = [235, shuffler_walk6] {ai_walk(4);};
void() shuffler_walk6 = [237, shuffler_walk7] {ai_walk(9);};
void() shuffler_walk7 = [239, shuffler_walk8] {ai_walk(12);};
void() shuffler_walk8 = [241, shuffler_walk9] {ai_walk(12);};
void() shuffler_walk9 = [243, shuffler_walk10] {ai_walk(9);};
void() shuffler_walk10 = [245, shuffler_walk11] {ai_walk(10);sound(self, CHAN_BODY, "shuffler/step1.wav", 0.8, ATTN_NORM);};
void() shuffler_walk11 = [247, shuffler_walk12] {ai_walk(4);};
void() shuffler_walk12 = [249, shuffler_walk1] {ai_walk(9);};

void() shuffler_charge10;
float SHUFFLER_CHARGE_LEAP = 15;

void() ShufflerCheckForCharge =
{
	local float avspeed, len;	
	local vector disp;

	if (self.monsterflags & MF_CHAMPION)	//02/10/04 - white shufflers no longer charge
		return;

	if (time < self.super_time)
		return;	//don't charge again immediately

	if (!enemy_infront)
		return;		//only charge if facing enemy

	if (fabs(self.enemy.origin_z - self.origin_z) > 48)	//check they're on roughly the same level
		return;	

//do a quick check to see if the path is clear - don't use enemy_vis, as that sees through other monsters
	traceline(self.origin, self.enemy.origin, FALSE, self);
   	if (trace_ent != self.enemy)
      	return;     // don't have a clear run

//work out average charging speed...
	avspeed = (140 + 6*SHUFFLER_CHARGE_LEAP) / 12;	//average distance travelled per frame
	avspeed = avspeed * 20; //20 fps

//get distance to enemy, assuming level ground...
	disp = self.enemy.origin - self.origin;
	disp_z = 0;
	len = vlen(disp);

//charge for 2* the time it would theoretically take to reach enemy, and then some...
	self.attack_finished = time + (2*len / avspeed) + 5 + random()*5;	//time to spend charging	

	self.think = shuffler_charge10;
	self.nextthink = time + 0.1;
};

void() shuffler_run6;
void() ShufflerCheckForChargeFinished =
{
	if (time < self.attack_finished)
		return;

	self.super_time = time + 2 + random()*5;	//min wait before next charge
	
	self.think = shuffler_run6;
	self.nextthink = time + 0.1;
};

void() shuffler_slap_right1;
void() shuffler_slap_left1;
void() shuffler_gore1;

void(float side) ShufflerDoSlap =
{
	if (side == 1)
		self.think = shuffler_slap_right1;
	else if (side == -1)
		self.think = shuffler_slap_left1;
	else
		self.think = shuffler_gore1;
};

void(float side) ShufflerCheckForSlap =
{
	if (enemy_range == RANGE_MELEE)
	{
		if(CanDamage(self.enemy, self))
		{
			ShufflerDoSlap(side);
			return;
		}
	}

	//find someone else to slap.

	local entity goon, best_goon;
	local float dot, best_dot;
	local vector vec;

	makevectors(self.angles);
	goon = findradius(self.origin, 120);

	best_dot = 0;
	best_goon = world;

	while(goon)
	{
		if (goon.flags & FL_MONSTER)
		if (goon.health > 0)
		if (!(goon.monsterflags & MF_GREATER_DEMON))	//only slap the lowly minions
		if (CanDamage(goon, self))
		{	
			//see if any entities are in the way of the shot
			traceline(self.origin, goon.origin, FALSE, self);
   			if (trace_ent == goon)	//potential goon
			{		
				vec = normalize(goon.origin - self.origin);
				dot = vec * v_forward;
				if (dot > best_dot)
				{
					best_dot = dot;
					best_goon = goon;
				}
			}
		}
		goon = goon.chain;
	}

	if (best_goon != world)
	{
		//found a goon to slap...

		dprint("goon found: ");
		dprint(best_goon.classname);
		dprint("\n");

		if (self.enemy.classname == "player")
			self.oldenemy = self.enemy;
		self.enemy = best_goon;
		self.monsterflags = self.monsterflags | MF_GOON_SLAP;
		self.goalentity = best_goon;
		self.ideal_yaw = vectoyaw(best_goon.origin - self.origin);

		ShufflerDoSlap(side);
	}
};

void() ShufflerFinishedGoonSlap =
{
	if (!(self.monsterflags & MF_GOON_SLAP))
		return;	

	self.monsterflags = self.monsterflags - MF_GOON_SLAP;
	self.enemy = self.oldenemy;
	self.oldenemy = world;
	self.goalentity = self.enemy;
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
};

void(float side) ShufflerMeleeDamage =
{
	local vector delta;
	local float ldmg, m;

	if (!self.enemy)
		return;

	delta = self.enemy.origin - self.origin;
	if (vlen(delta) > 100)
		return;

	if (!FacingIdeal())
		return;		//quick angle check (ideal_yaw set in ai_charge)

	if (!CanDamage(self.enemy, self))
		return;

	makevectors(self.angles);

	ldmg = (random() + random() + random()) * 10;

	if (self.enemy.flags & FL_MONSTER)
	{	
		if (!(self.monsterflags & MF_GOON_SLAP))
			ldmg = ldmg * 4;	//kill monster enemies quickly if it's not just a goonslap

		if (self.enemy.monsterflags & MF_ZOMBIE_GIB)	//always gib zombies even on a goonslap
		{
			if (ldmg < (self.enemy.health + 10))
				ldmg = self.enemy.health + 10;
		}
	}

	T_Damage(self.enemy, self, self, ldmg);	

	self.enemy.flags = self.enemy.flags - (self.enemy.flags & FL_ONGROUND);	

//don't go more than 300 on v_up, because they land on each other easily...
//put this after T_Damage() because otherwise player velocity is changed by damage momentum...

	if (side)	//it's a hand slap
	{
		sound(self, CHAN_WEAPON, "shuffler/slam.wav", 1, ATTN_NORM);
		self.enemy.velocity = v_forward*100 + ((50 + random()*50)*v_right*side) + v_up*300;
	}
	else		//it's a gore
	{
		sound(self, CHAN_WEAPON, "gibs/ut2gib1.wav", 1, ATTN_NORM);
		self.enemy.velocity = v_forward*200 + (crandom()*v_right*50) + v_up*300;

		if (!(self.monsterflags & MF_GOON_SLAP))
			self.attack_finished = 1;	//enemy successfully hit, so charge is now finished, unless it was a goon.
	}

	if (self.enemy.mass)
	{
		m = 1 / self.enemy.mass;
		self.enemy.velocity = self.enemy.velocity * m;
	}

//spawn some meat...
	SpawnMeatSpray(self.origin + v_forward*30, crandom() * 100 * v_right);
	SpawnMeatSpray(self.origin + v_forward*30, crandom() * 100 * v_right);
};


void() shuffler_run1 = [227, shuffler_run2] 
{	
	if (random() < 0.2)
	{
		if (self.voice_finished < time)
		{
			sound(self, CHAN_VOICE, "shuffler/breathe1.wav", 1, ATTN_NORM);
			self.voice_finished = time + 5;
		}
	}

	ai_run(12);	
};
void() shuffler_run2 = [229, shuffler_run3] {ai_run(12);};
void() shuffler_run3 = [231, shuffler_run4] 
{
	ai_run(9);
	ShufflerCheckForSlap(1);
};
void() shuffler_run4 = [233, shuffler_run5] 
{
	sound(self, CHAN_BODY, "shuffler/step1.wav", 1, ATTN_NORM);
	ai_run(10);
};
void() shuffler_run5 = [235, shuffler_run6] {ai_run(4);};
void() shuffler_run6 = [237, shuffler_run7] {ai_run(9);};
void() shuffler_run7 = [239, shuffler_run8] {ai_run(12);};
void() shuffler_run8 = [241, shuffler_run9] {ai_run(12);};
void() shuffler_run9 = [243, shuffler_run10] 
{
	ai_run(9);
	ShufflerCheckForSlap(-1);
};
void() shuffler_run10 = [245, shuffler_run11] 
{
	sound(self, CHAN_BODY, "shuffler/step1.wav", 1, ATTN_NORM);
	ai_run(10);
	ShufflerCheckForCharge();
};
void() shuffler_run11 = [247, shuffler_run12] {ai_run(4);};
void() shuffler_run12 = [249, shuffler_run1] {ai_run(9);};

//============================================================

//bwalk7,9,11,13,15,17 is right slap
//bwalk19,21,23,1,3,5 is left slap

void() shuffler_slap_right1 = [6, shuffler_slap_right2] {ai_charge(10);};
void() shuffler_slap_right2 = [8, shuffler_slap_right3] {ai_charge(4);};
void() shuffler_slap_right3 = [10, shuffler_slap_right4] {ai_charge(9);};
void() shuffler_slap_right4 = [12, shuffler_slap_right5] 
{
	ai_charge(12);
	ShufflerMeleeDamage(1);
};
void() shuffler_slap_right5 = [14, shuffler_slap_right6] {ai_charge(12);};
void() shuffler_slap_right6 = [16, shuffler_run10] {ai_charge(9);ShufflerFinishedGoonSlap();};		//bwalk17->walk19

void() shuffler_slap_left1 = [18, shuffler_slap_left2] {ai_charge(10);};
void() shuffler_slap_left2 = [20, shuffler_slap_left3] {ai_charge(4);};
void() shuffler_slap_left3 = [22, shuffler_slap_left4] {ai_charge(9);};
void() shuffler_slap_left4 = [0, shuffler_slap_left5] 
{
	ai_charge(12);
	ShufflerMeleeDamage(-1);
};
void() shuffler_slap_left5 = [2, shuffler_slap_left6] {ai_charge(12);};
void() shuffler_slap_left6 = [4, shuffler_run4] {ai_charge(9);ShufflerFinishedGoonSlap();};		//bwalk5->walk7



void() shuffler_gore1 = [61, shuffler_gore2] {ai_charge(25);self.nextthink = time + 0.05;};
void() shuffler_gore2 = [62, shuffler_gore3] {ai_charge(SHUFFLER_CHARGE_LEAP);self.nextthink = time + 0.05;};
void() shuffler_gore3 = [63, shuffler_gore4] {ai_charge(SHUFFLER_CHARGE_LEAP);self.nextthink = time + 0.05;};
void() shuffler_gore4 = [64, shuffler_gore5] 
{
	sound(self, CHAN_BODY, "shuffler/step2.wav", 1, ATTN_NORM);
	ai_charge(SHUFFLER_CHARGE_LEAP);
	ShufflerMeleeDamage(0);
	self.nextthink = time + 0.05;
};
void() shuffler_gore5 = [65, shuffler_gore6] {ai_charge(21);self.nextthink = time + 0.05;};
void() shuffler_gore6 = [66, shuffler_gore7] {ai_charge(24);self.nextthink = time + 0.05;};
void() shuffler_gore7 = [67, shuffler_gore8] {ai_charge(25);self.nextthink = time + 0.05;};
void() shuffler_gore8 = [68, shuffler_gore9] {ai_charge(SHUFFLER_CHARGE_LEAP);self.nextthink = time + 0.05;};
void() shuffler_gore9 = [69, shuffler_gore10] {ai_charge(SHUFFLER_CHARGE_LEAP);self.nextthink = time + 0.05;};
void() shuffler_gore10 = [70, shuffler_gore11] 
{
	sound(self, CHAN_BODY, "shuffler/step2.wav", 1, ATTN_NORM);
	ai_charge(SHUFFLER_CHARGE_LEAP);
	self.nextthink = time + 0.05;
};
void() shuffler_gore11 = [71, shuffler_gore12] {ai_charge(21);self.nextthink = time + 0.05;};
void() shuffler_gore12 = [72, shuffler_charge1] {ai_charge(24);ShufflerFinishedGoonSlap();self.nextthink = time + 0.05;};

//==========================================================

float(float dist) ai_shuffler_charge =
{
	local	float	axis;

	movedist = dist;

// see if the enemy is dead
   	if (self.enemy.health <= 0)
	{
		self.enemy = world;		
	// FIXME: look all around for other targets
		if (self.oldenemy.health > 0)
		{
			self.enemy = self.oldenemy;
			HuntTarget();
		}
		else
		{
			if (self.movetarget)
				self.th_walk ();
			else
				self.th_stand ();
			return FALSE;
		}
	}

	self.show_hostile = time + 1;		// wake up other monsters

	enemy_range = range(self.enemy);	//used for shuffler gore slap

	self.yaw_speed = 10;	//set to half-yaw speed before movement...
      
	if (time > self.endtime)
      {	
		axis = walkmove (self.angles_y, movedist);
      	if (!axis)
         	{
			self.endtime = time + 0.5;	//time to spend doing normal movetogoal ai
         		movetogoal (dist);
			self.yaw_speed = 20; 
			return FALSE;
         	}
		
		self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
		ChangeYaw();
		self.yaw_speed = 20; 
		return TRUE;		
	}
	
	movetogoal(dist);      // done in C code...   
	self.yaw_speed = 20; 	//reset to normal after movement   
	return FALSE; 
};


//==========================================================

void() shuffler_charge1 = [24, shuffler_charge2] {ai_shuffler_charge(25);self.nextthink = time + 0.05;};
void() shuffler_charge2 = [25, shuffler_charge3] {ai_shuffler_charge(SHUFFLER_CHARGE_LEAP);self.nextthink = time + 0.05;};
void() shuffler_charge3 = [26, shuffler_charge4] {ai_shuffler_charge(SHUFFLER_CHARGE_LEAP);self.nextthink = time + 0.05;};
void() shuffler_charge4 = [27, shuffler_charge5] 
{
	sound(self, CHAN_BODY, "shuffler/step2.wav", 1, ATTN_NORM);

	if (!ai_shuffler_charge(SHUFFLER_CHARGE_LEAP))	//only check to stop charging if using movetogoal movement
		ShufflerCheckForChargeFinished();

	self.nextthink = time + 0.05;
};
void() shuffler_charge5 = [28, shuffler_charge6] {ai_shuffler_charge(21);self.nextthink = time + 0.05;};
void() shuffler_charge6 = [29, shuffler_charge7] {ai_shuffler_charge(24);self.nextthink = time + 0.05;};
void() shuffler_charge7 = [30, shuffler_charge8] {ai_shuffler_charge(25);self.nextthink = time + 0.05;};
void() shuffler_charge8 = [31, shuffler_charge9] {ai_shuffler_charge(SHUFFLER_CHARGE_LEAP);self.nextthink = time + 0.05;};
void() shuffler_charge9 = [32, shuffler_charge10] {ai_shuffler_charge(SHUFFLER_CHARGE_LEAP);self.nextthink = time + 0.05;};
void() shuffler_charge10 = [33, shuffler_charge11] 
{
	//this is actually the first function, as ShufflerCheckForCharge() calls shuffler_charge10
	self.pain_finished = time + 2;		//no pain while charging
	self.monster_fight_time = time + 2;		//no distractions while charging

	sound(self, CHAN_BODY, "shuffler/step2.wav", 1, ATTN_NORM);
	ai_shuffler_charge(SHUFFLER_CHARGE_LEAP);
	self.nextthink = time + 0.05;
};
void() shuffler_charge11 = [34, shuffler_charge12] {ai_shuffler_charge(21);self.nextthink = time + 0.05;};
void() shuffler_charge12 = [35, shuffler_charge1] {ai_shuffler_charge(24);ShufflerCheckForSlap(0);self.nextthink = time + 0.05;};



/*
=====================

SPAWNING

=====================
*/

void() shuffler_howl1 = [73, shuffler_howl2] {sound(self, CHAN_VOICE, "shuffler/big3.wav", 1, ATTN_NORM);};
void() shuffler_howl2 = [75, shuffler_howl3] {};
void() shuffler_howl3 = [77, shuffler_howl4] {};
void() shuffler_howl4 = [79, shuffler_howl5] {};
void() shuffler_howl5 = [81, shuffler_howl6] {};
void() shuffler_howl6 = [83, shuffler_howl7] {};
void() shuffler_howl7 = [85, shuffler_howl8] {};
void() shuffler_howl8 = [87, shuffler_howl9] {};
void() shuffler_howl9 = [89, shuffler_howl10] {};
void() shuffler_howl10 = [91, shuffler_howl11] {};
void() shuffler_howl11 = [93, shuffler_howl12] {};
void() shuffler_howl12 = [95, shuffler_howl13] {};
void() shuffler_howl13 = [97, shuffler_howl14] {};
void() shuffler_howl14 = [99, shuffler_howl15] {};
void() shuffler_howl15 = [101, shuffler_howl16] {};
void() shuffler_howl16 = [103, shuffler_howl17] {};
void() shuffler_howl17 = [105, shuffler_howl18] {};
void() shuffler_howl18 = [107, shuffler_run1] {};

void(float beastie, vector org, vector vel, float ang, float update, entity attacker) BDW_SpawnMonster;

void() ShufflerDelaySpawnerGo =
{
	local entity spawner;

	spawner = self;
	self = self.spawnmaster;

	if (self.health > 0)	//don't spawn if just died
		BDW_SpawnMonster(spawner.items2, spawner.origin, '0 0 0', spawner.angles_y, TRUE, self.enemy);

	self = spawner;
	remove(self);
};

void(float beastie, vector org, float ang, float t) ShufflerDelaySpawner =
{
	//spawns a solid placeholder entity that is replaced by the monster at a later time.

	local entity new;

	new = spawn();
	new.classname = "shuffler_spawner";
	new.spawnmaster = self;

	new.solid = SOLID_SLIDEBOX;
	new.movetype = MOVETYPE_NONE;

	new.angles = '0 0 0';
	new.angles_y = ang;	//store the angle of monster

	new.items2 = beastie;	//store what monster to spawn

	new.think = ShufflerDelaySpawnerGo;
	new.nextthink = time + t;

      //testing sprite model
	//setmodel(new, "sprites/shalrath/s_vore.spr");
	setsize(new, VEC_HULL_MIN, VEC_HULL_MAX);
	setorigin(new, org);
};

float() ShufflerCheckForSpawn =
{
//FIXME: shuffler is currently really bad at seeing other monsters when it comes to checking the area

	if (!(self.monsterflags & MF_CHAMPION))
		return FALSE;	//only white shufflers spawn monsters

	if (enemy_range == RANGE_MELEE)
		return FALSE;	//too close and you risk running into newly spawned monster teledeaths
	
	if (self.frags < 3)
		return FALSE;

	if (time < self.invincible_time)
		return FALSE;	//wait a while before next spawning

	if (self.enemy.flags & FL_MONSTER)
		return FALSE;	//gets silly otherwise

	local float ang, beastie;
	local float spawn_forward 	= 68;
	local float spawn_right 	= 68;
	local float spawn_up 		= 40;
	local vector org, o_right, o_left, dir_ang;

	local vector box_lip = '16 16 16';	//this is just to give the bbox a bit of breathing space
							//fixme: why doesn't this cause the boxcheck to collide with the shuffler box?

	local vector box_mins;
	local vector box_maxs;

	box_mins = VEC_HULL_MIN - box_lip;
	box_maxs = VEC_HULL_MAX + box_lip;	

//get best angles for monsters by clamping it to 90 degrees

	ang = self.angles_y;

	if (ang > 315 || ang <=45)
		ang = 0;
	else if (ang > 45 && ang <= 135)
		ang = 90;
	else if (ang > 135 && ang <= 225)
		ang = 180;
	else
		ang = 270;

	dir_ang = '0 0 0';
	dir_ang_y = ang;

	makevectors(dir_ang);
	org = self.origin + v_forward*spawn_forward;
	org_z = org_z + spawn_up;

	if (SUB_BBoxInOccupied(box_mins, box_maxs, org))
		return FALSE;

	o_right = org + v_right*spawn_right - 0.5*v_forward*spawn_forward;

	if (SUB_BBoxInOccupied(box_mins, box_maxs, o_right))
		return FALSE;

	o_left = org - v_right*spawn_right - 0.5*v_forward*spawn_forward;

	if (SUB_BBoxInOccupied(box_mins, box_maxs, o_left))
		return FALSE;

//space is clear so spawn delay spawners...

	//beastie = MONSTER_FIEND;
	beastie = MONSTER_IMP;

	ShufflerDelaySpawner(beastie, org, ang, 0.9);
	ShufflerDelaySpawner(beastie, o_right, ang, 1.0);
	ShufflerDelaySpawner(beastie, o_left, ang, 1.1);

	shuffler_howl1();
	self.monster_fight_time = time + 2;		//don't get distracted whilst howling
	self.pain_finished = time + 2;		//don't go into pain frames
	self.invincible_time = time + 10;	//min time before next spawn

	return TRUE;
};

/*
==================================================

MISSILE ATTACK

==================================================
*/

void() shuffler_missile_explode =
{
	local vector org;

	org = self.origin - 8*normalize(self.velocity);	

	self.movetype = MOVETYPE_NONE;
	self.touch = SUB_Null;
	self.solid = SOLID_NOT;

	self.velocity = '0 0 0';	

	if (self.owner.monsterflags & MF_CHAMPION)
		setmodel(self, "sprites/starb/starb_eb.spr");
	else
		setmodel(self, "sprites/starb/starb_eg.spr");

	setsize(self, '0 0 0', '0 0 0');
	setorigin(self, org);

	self.frame = 0;
	self.idleweaponframe = 5;
	self.think = BDW_SpriteGenericPlayOnce;
	self.nextthink = time + 0.05;
};

void() shuffler_missile_touch =
{
	if (other == self.owner)
		return;

	if (other.solid == SOLID_TRIGGER)
		return;	// trigger field, do nothing

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

// hit something that bleeds
	if (other.takedamage)
	{
		spawn_touchblood(9);
		T_Damage (other, self, self.owner, 9);
	}	

	sound(self, CHAN_VOICE, "shuffler/expsmall.wav", 1, ATTN_NORM);
	shuffler_missile_explode();
};

void() shuffler_shot =
{
	local	vector offang, dir;
	local	vector org, vec;
	local entity en;
	local float t, fast;

	if (self.monsterflags & MF_CHAMPION)
		fast = 1000;
	else
		fast = 750;

	fast = fast + (random()*fast*0.3);

	makevectors(self.angles);
	org = self.origin + '0 0 48' + v_forward*24;	//origin of missile

	en = self.enemy;
	t = (vlen(en.origin - self.origin)) / fast;	//rough calculation of time to reach enemy
	dir = en.velocity * t * 0.5;				//0.5 tones it down a bit
	dir_z = 0;							//jumping produces sillyness
	dir = dir + en.origin + en.view_ofs - org;	//vector to hit him directly in the face

	offang = vectoangles(dir);
	offang_y = offang_y + crandom()*4;
	offang_x = offang_x + crandom()*4;

	makevectors(offang);
	vec = normalize(v_forward);
	vec_z = vec_z * -1;		//???

	launch_spike(org, vec);
	newmis.velocity = vec * fast;
	newmis.classname = "shuffler_missile";
	newmis.touch = shuffler_missile_touch;

	if (self.monsterflags & MF_CHAMPION)
	{
		newmis.color = 40;	//blue
		setmodel(newmis, "sprites/starb/starb_b.spr");	// blue shot		
	}
	else
	{
		//newmis.color = 232;	//lava red
		//setmodel(newmis, "sprites/starb/starb_r.spr");	// red shot
		newmis.color = 104;	//yellow/gold	
		setmodel(newmis, "sprites/starb/starb_g.spr");		// gold shot		

	}		

	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);

	//experimental tracer effect...
	newmis.oldorigin = org;
	newmis.think = BDW_TracerEffect;
	newmis.nextthink = 1;	//next frame
};

void() shuffler_magic1 = [161, shuffler_magic2] {ai_face();};
void() shuffler_magic2 = [163, shuffler_magic3] {ai_face();};
void() shuffler_magic3 = [165, shuffler_magic4] {ai_face();};
void() shuffler_magic4 = [167, shuffler_magic5] {ai_face();};
void() shuffler_magic5 = [169, shuffler_magic6] {ai_face();};
void() shuffler_magic6 = [171, shuffler_magic7] {ai_face();};
void() shuffler_magic7 = [173, shuffler_magic8] {ai_face();};
void() shuffler_magic8 = [175, shuffler_magic9] {ai_face();};
void() shuffler_magic9 = [177, shuffler_magic10] 
{
//shot starts on frame 177
	ai_face(); 
	sound(self, CHAN_WEAPON, "shuffler/firefblt.wav", 1, ATTN_NORM); 
	shuffler_shot();
	shuffler_shot(); 
};
void() shuffler_magic10 = [179, shuffler_magic11] {ai_face(); shuffler_shot();shuffler_shot(); };
void() shuffler_magic11 = [181, shuffler_magic12] {ai_face(); shuffler_shot();shuffler_shot(); };
void() shuffler_magic12 = [183, shuffler_magic13] {ai_face();};
void() shuffler_magic13 = [185, shuffler_magic14] {ai_face();};
void() shuffler_magic14 = [187, shuffler_magic15] {ai_face();};
void() shuffler_magic15 = [189, shuffler_magic16] {ai_face();};
void() shuffler_magic16 = [191, shuffler_run1] {ai_face();};

float() ShufflerCheckAttack =
{
	local vector	spot1, spot2;
	local entity	targ;

	if (time < self.attack_finished)
		return FALSE;	

	if (random() < 0.2)	//can spawn minions even if enemy not in range
	{
		if (ShufflerCheckForSpawn())		
			return TRUE;
	}

	targ = self.enemy;

// see if any entities are in the way of the shot
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;

	traceline (spot1, spot2, FALSE, self);

   	if (trace_ent != targ)
      	return FALSE;     // don't have a clear shot

	if (trace_inopen && trace_inwater)
		return FALSE;			// sight line crossed contents		

	if (enemy_range == RANGE_FAR)
		return FALSE;	

	if (random() < 0.2)
	{
		//if (ShufflerCheckForSpawn())		
		//	return TRUE;

		//else, do a projectile attack...
		self.attack_state = AS_MISSILE;
		SUB_AttackFinished(2 + 2*random());
		return TRUE;
	}

	return FALSE;
};


/*
=============================

PAIN/DEATH

=============================
*/

/*
void() shuffler_pain1 = [133, shuffler_pain2] {};
void() shuffler_pain2 = [135, shuffler_pain3] {};
void() shuffler_pain3 = [137, shuffler_pain4] {};
void() shuffler_pain4 = [139, shuffler_run1] {};
*/

void() shuffler_pain1 = [133, shuffler_pain2] {};
void() shuffler_pain2 = [134, shuffler_pain3] {};
void() shuffler_pain3 = [135, shuffler_pain4] {};
void() shuffler_pain4 = [136, shuffler_pain5] {};
void() shuffler_pain5 = [137, shuffler_pain6] {};
void() shuffler_pain6 = [138, shuffler_pain7] {};
void() shuffler_pain7 = [139, shuffler_pain8] {};
void() shuffler_pain8 = [140, shuffler_run1] {};

void() shuffler_shrug1 = [141, shuffler_shrug2] {};
void() shuffler_shrug2 = [143, shuffler_shrug3] {};
void() shuffler_shrug3 = [145, shuffler_shrug4] {};
void() shuffler_shrug4 = [147, shuffler_shrug5] {};
void() shuffler_shrug5 = [149, shuffler_shrug6] {};
void() shuffler_shrug6 = [151, shuffler_shrug7] {};
void() shuffler_shrug7 = [153, shuffler_shrug8] {};
void() shuffler_shrug8 = [155, shuffler_shrug9] {};
void() shuffler_shrug9 = [157, shuffler_shrug10] {};
void() shuffler_shrug10 = [159, shuffler_run1] {};


void() shuffler_death1 = [36, shuffler_death2] {};
void() shuffler_death2 = [38, shuffler_death3] {ai_forward(2);};
void() shuffler_death3 = [40, shuffler_death4] {ai_forward(4);};
void() shuffler_death4 = [42, shuffler_death5] {ai_forward(8);};
void() shuffler_death5 = [44, shuffler_death6] {ai_forward(10);};
void() shuffler_death6 = [46, shuffler_death7] {ai_forward(11);};
void() shuffler_death7 = [48, shuffler_death8] {ai_forward(11);self.solid = SOLID_NOT;};
void() shuffler_death8 = [50, shuffler_death9] {ai_forward(10);};
void() shuffler_death9 = [52, shuffler_death10] {ai_forward(8);};
void() shuffler_death10 = [54, shuffler_death11] {ai_forward(4);};
void() shuffler_death11 = [56, shuffler_death12] {ai_forward(7);};
void() shuffler_death12 = [58, shuffler_death13] {BDW_BodyDropSound();ai_forward(4);};
void() shuffler_death13 = [60, BDW_CorpseRemove] {ai_forward(3);};

void() shuffler_die =
{
	//kill all the shuffler's minions
	/*
	minion = nextent(world);
	while(minion)
	{
		if (minion.spawnmaster == self)
		{
			if (minion.health > 0)
			T_Damage(minion, world, world, minion.health + 10);
		}
		minion = nextent(minion);
	}
	*/

// check for gib
	if (self.health < -1000)	//could lower this if you get a head gib sorted
	{
		self.skin = 0;
		MonsterGibLarge("progs/gib4.mdl");	//fixme: need a head gib
		return;
	}

// regular death
	sound(self, CHAN_VOICE, "shuffler/death.wav", 1, ATTN_NORM);
	shuffler_death1();
};

void(entity attacker, float damage) shuffler_pain = 
{
	if (self.health <= 0)
		return;		// allready dying, don't go into pain frame

	if (self.pain_finished > time)
		return;
	
	if (random() < (self.health / self.max_health))
		return;	

	if (random()*200 > damage)
		return;		// didn't flinch		

	if (random() < 0.5)
	{
		sound(self, CHAN_VOICE, "shuffler/pain.wav", 1, ATTN_NORM);
		shuffler_pain1();
	}
	else
	{
		sound(self, CHAN_VOICE, "shuffler/big1.wav", 1, ATTN_NORM);
		shuffler_shrug1();
	}

	self.pain_finished = time + 2;
};




void() shuffler_sight =
{
	sound(self, CHAN_VOICE, "shuffler/big3.wav", 1, 0.5);
	self.voice_finished = time + 5;
};

void() monster_black_shuffler_precache =
{
	precache_model("progs/gauroch.mdl");
	//precache_model("progs/h_shams.mdl");	//temp

	//precache_model("sprites/starb/starb_r.spr");
	//precache_model("sprites/starb/starb_er.spr");
	
	precache_model("sprites/starb/starb_g.spr");
	precache_model("sprites/starb/starb_eg.spr");

	precache_sound("shuffler/firefblt.wav");
	precache_sound("shuffler/expsmall.wav");

	precache_sound("shuffler/step1.wav");	//walk
	precache_sound("shuffler/step2.wav");	//charge
	precache_sound("shuffler/slam.wav");	//gore/melee
	//precache_sound("shuffler/gore.wav");

	precache_sound("gibs/ut2gib1.wav");	
	//precache_sound("gibs/ut2gib3.wav");
	
	precache_sound("shuffler/big3.wav");	//sight
	precache_sound("shuffler/big1.wav");	//shrug
	precache_sound("shuffler/pain.wav");	//pain
	precache_sound("shuffler/death.wav");	//pain
	precache_sound("shuffler/breathe3.wav");	//idle
	precache_sound("shuffler/breathe1.wav");	//hunting
};

void() monster_black_shuffler_init =
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/gauroch.mdl");	
	setsize (self, '-32 -32 -24', '32 32 80');	

	self.health = 1200;
	
	self.mass = 2;
	self.skin = 1;
	
	self.monsterflags = self.monsterflags | MF_GREATER_DEMON;
	self.monsterflags = self.monsterflags | MF_TFRAG_PRIORITY;

	self.th_stand = shuffler_stand1;
	self.th_walk = shuffler_walk1;
	self.th_run = shuffler_run1;
	self.th_die = shuffler_die;
	//self.th_melee = shuffler_melee;		
	self.th_missile = shuffler_magic1;			
	self.th_pain = shuffler_pain;
		
	self.check_attack = ShufflerCheckAttack;
	self.sight_sound = shuffler_sight;
	self.classname = "monster_shuffler";
};

void() monster_black_shuffler =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	monster_black_shuffler_precache();	
	
	//if (MonsterSpawnedLater(MONSTER_BLACK_SHUFFLER))		
	//	return;
	
	monster_black_shuffler_init();
	walkmonster_start();
};

void() monster_white_shuffler_precache =
{
	monster_black_shuffler_precache();
	monster_imp_precache();

	precache_model("sprites/shalrath/s_vore.spr");
	precache_model("sprites/starb/starb_b.spr");
	precache_model("sprites/starb/starb_eb.spr");
};

void() monster_white_shuffler_init =
{
	monster_black_shuffler_init();

	self.health = 1800;
		
	self.skin = 0;
	self.frags = 4;	//stores how many monsters he's currently allowed to spawn
	self.monsterflags = self.monsterflags | MF_COUNT_FRAGS;	//kills increase self.frags
	self.monsterflags = self.monsterflags | MF_CHAMPION;
};

void() monster_white_shuffler =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	monster_white_shuffler_precache();	
	
	//if (MonsterSpawnedLater(MONSTER_WHITE_SHUFFLER))		
	//	return;
	
	monster_white_shuffler_init();
	walkmonster_start();
};

//testing...
void() monster_archvile = 
{
	if (random() < 0.5)
		monster_black_shuffler();
	else
		monster_white_shuffler();
};