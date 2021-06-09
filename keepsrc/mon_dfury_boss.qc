//==============================================================================
// Brigade Commander
//==============================================================================
$cd id1/models/knight3
$origin 0 0 24
$base base
$skin skin

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9
$frame walk10 walk11 walk12 walk13 walk14

$frame run1 run2 run3 run4 run5 run6

$frame pain1 pain2 pain3 pain4 pain5

$frame death1 death2 death3 death4 death5 death6 death7 death8
$frame death9 death10 death11 death12 death13 death14 death15 death16 death17

$frame deathb1 deathb2 deathb3 deathb4 deathb5 deathb6 deathb7 deathb8
$frame deathb9 deathb10 deathb11 deathb12 deathb13 deathb14

$frame char_a1 char_a2 char_a3 char_a4 char_a5 char_a6 char_a7 char_a8
$frame char_a9 char_a10 char_a11 char_a12 char_a13 char_a14 char_a15 char_a16

$frame magica1 magica2 magica3 magica4 magica5 magica6 magica7 magica8
$frame magica9 magica10 magica11 magica12 magica13 magica14

$frame magicb1 magicb2 magicb3 magicb4 magicb5 magicb6 magicb7 magicb8
$frame magicb9 magicb10 magicb11 magicb12 magicb13

$frame char_b1 char_b2 char_b3 char_b4 char_b5 char_b6

$frame slice1 slice2 slice3 slice4 slice5 slice6 slice7 slice8 slice9 slice10
$frame slice11 slice12 slice13 slice14

$frame smash1 smash2 smash3 smash4 smash5 smash6 smash7 smash8 smash9 smash10
$frame smash11 smash12 smash13 smash14 smash15

$frame w_attack1 w_attack2 w_attack3 w_attack4 w_attack5 w_attack6 w_attack7 
$frame w_attack8 w_attack9 w_attack10 w_attack11 w_attack12 w_attack13 w_attack14
$frame w_attack15 w_attack16 //w_attack17 w_attack18 w_attack19 w_attack20 
//$frame w_attack21 w_attack22 

$frame magicc1 magicc2 magicc3 magicc4 magicc5 magicc6 magicc7 magicc8
$frame magicc9 magicc10 magicc11

$frame lunge1 lunge2 lunge3 lunge4 lunge5 lunge6 lunge7 lunge8 lunge9 lunge10
$frame lunge11 lunge12 lunge13 lunge14 lunge15

$frame ssgdeth1 ssgdeth2 ssgdeth3 ssgdeth4 ssgdeth5 ssgdeth6 ssgdeth7 ssgdeth8 ssgdeth9 ssgdeth10
$frame ssgdeth11 ssgdeth12 ssgdeth13 ssgdeth14 ssgdeth15 ssgdeth16 ssgdeth17 ssgdeth18 ssgdeth19 ssgdeth20
$frame ssgdeth21 ssgdeth22 ssgdeth23 ssgdeth24 ssgdeth25 ssgdeth26 ssgdeth27 ssgdeth28

$frame ssgdethb1 ssgdethb2 ssgdethb3 ssgdethb4 ssgdethb5 ssgdethb6 ssgdethb7 ssgdethb8 ssgdethb9 ssgdethb10
$frame ssgdethb11 ssgdethb12

void() dfury_boss_spawner;
void() FuryBossSpawnTouch;
void() FuryBossMissileTouch;
void() FuryBossSpikeTouch;
void() FuryBossHome;
void() dfury_boss_char_a1;
void() dfury_boss_run1;
void() dfury_boss_random_magic;		// adds random magic attack animation
void()	dfury_boss_JumpTouch; // in original ID1, only "dfury_magiccxx" is used

void() df_idle_sound = { if (random() < 0.2) sound (self, CHAN_VOICE, "q15/dfury/idle.wav", 1, ATTN_NORM); };

// Long reach!
void() ai_melee_dfury_boss = {
	local vector delta;
	local float ldmg;

	if (!self.enemy) return;		// removed before stroke
		
	delta = self.enemy.origin - self.origin;
	if (vlen(delta) > 80) return;

	ldmg = (random() + random() + random()) * 6;			// default 3
	T_Damage (self.enemy, self, self, ldmg,DAMARMOR);
};

void(float AttackNumber) dfury_boss_shot2 = {
	local	entity 	missile;
	local	vector	dir, org;
	local	float	dist, flytime;

	dir = normalize((self.enemy.origin + '0 0 10') - self.origin);
	dist = vlen (self.enemy.origin - self.origin);
	flytime = dist * 0.002;
	if (flytime < 0.1) flytime = 0.1;

	self.effects = self.effects | EF_MUZZLEFLASH;
	makevectors (self.angles);
	missile = spawn ();
	missile.owner = self;
	missile.solid = SOLID_BBOX;
	missile.movetype = MOVETYPE_FLYMISSILE;
	setmodel (missile, "progs/ad171/proj_fury1.mdl");
	setsize (missile, '0 0 0', '0 0 0');		

	if ( AttackNumber == 1) {
		org = self.origin + v_forward*20 + v_up*12; // 20 // 44;
	} else if ( AttackNumber == 2) {
		org = self.origin + v_forward*18 + v_up*10; // 18 // 42;
	} else if ( AttackNumber == 3) {
		org = self.origin + v_forward*12 + v_up*12 + v_right*20; // up20
	} else if ( AttackNumber == 4) {
        org = self.origin + v_forward*20 + v_up*16;
	}

	setorigin ( missile, org );
	missile.velocity = dir * 500;
	missile.avelocity = '300 300 300';
	missile.enemy = self.enemy;
	missile.touch = FuryBossMissileTouch;
	missile.nextthink = time + 0.1;
	missile.think = FuryBossHome;
	sound (self, CHAN_WEAPON, "q15/dfury/attack1.wav", 1, ATTN_NORM);
	self.attack_finished = time + 2;
};

void(float offset) dfury_boss_shot = {
	local	vector	offang, org, vec;
	
	offang = vectoangles (self.enemy.origin - self.origin);
	offang_y = offang_y + offset * 6;
	makevectors (offang);
	org = self.origin + self.mins + self.size*0.5 + v_forward * 20;
	vec = normalize (v_forward);
	vec_z = 0 - vec_z + (random() - 0.5)*0.1; // set missile speed
	launch_projectile (org, vec, CT_PROJ_HKN, 700);
	sound (self, CHAN_WEAPON, "q15/dfury/proj.wav", 1, ATTN_NORM);
};

void() dfury_boss_spawner = {
	local vector distancedelta; 
	local vector nozdistancedelta; 
	local entity missile;
	
	self.effects = self.effects | EF_MUZZLEFLASH;
	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;	
	makevectors (self.angles);
	distancedelta = self.enemy.origin - self.origin; //work out distance vector  
	nozdistancedelta = distancedelta;  //copy to no height distance vector 
	nozdistancedelta_z = 0;  //remove height 
	missile.velocity = normalize(distancedelta); //set the velocity to the distance
	missile.velocity = missile.velocity * 100 + v_right*(random());   //give it more power 
	missile.velocity_z = missile.velocity_z + 350 + vlen(nozdistancedelta)*0.22*(1 + (0.3*(random()))); 
	missile.avelocity = '300 300 300';
	missile.angles = vectoangles(missile.velocity);
	missile.nextthink = time + 2.5; // set missile duration
	missile.think = FuryBossSpawnTouch;
	setmodel (missile, "progs/q15/proj_summon.mdl");
	setsize (missile, '0 0 0', '0 0 0');	
	missile.scale = 2;	
	setorigin (missile, self.origin);
};

void() FuryBossHome = {
	if (self.enemy.health < 1) { remove(self); return; }

	if (skill == 3) ai_track (self.enemy, 420);
	else ai_track (self.enemy, 300);

	self.nextthink = time + 0.2;
	self.think = FuryBossHome;	
};

void() FuryBossSpawnTouch = {
	makevectors(self.angles); // Find out if there is enough space to spawn a gargoyle, Findradius version
	// self.pos1 = self.origin + self.view_ofs + v_forward*64 + v_up*32;
	self.aflag = find_minionspace(self.origin);
	
	// If the spawn location all clear, spawn something!
	if (self.aflag == TRUE) {
		minion_gargoyle(self.origin, self.owner.enemy);
		sound (self, CHAN_WEAPON, "ad171/wraith/attack3.wav", 1, ATTN_NORM);
		// self.pos2 = self.origin - '0 0 16';	// Origin of gargoyle
	}

	if (ext_dppart) pointparticles(particleeffectnum("gibacid"), self.origin, '0 0 0', 1);
	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	setmodel (self, "progs/drake/s_explod.spr");
	self.solid = SOLID_NOT;
	s_explode1 ();
};

void() FuryBossMissileTouch = {
	if (other == self.owner || other.classgroup == self.classgroup || other.classtype == CT_MONDFURY) { remove(self); return; } // don't explode on any fury knight friends

	if (other.classgroup == CG_ZOMBIE) T_Damage (other, self, self, 110, DAMARMOR);	
	T_RadiusDamage (self, self.owner, 20, world, DAMAGEALL);
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	setmodel (self, "progs/drake/s_explod.spr");
	self.solid = SOLID_NOT;
	s_explode1 ();
};

void() FuryBossSpikeTouch = {
	if (other == self.owner || other.classgroup == self.classgroup || other.classtype == CT_MONDFURY) { remove(self); return; } // don't explode on any fury knight friends

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_KNIGHTSPIKE);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	setmodel (self, "progs/drake/s_explod.spr");
	self.solid = SOLID_NOT;
	s_explode1 ();
	T_RadiusDamage (self, self.owner, 5, world, DAMAGEALL);	
};

// check for mad charge
void() CheckForCharge_boss = {
	if (!enemy_vis) return; 
	if (time < self.attack_finished) return;	
	if ( fabs(self.origin_z - self.enemy.origin_z) > 20) return;		// too much height change
	if ( vlen (self.origin - self.enemy.origin) < 80) return;		// use regular attack

	SUB_AttackFinished (2);
	dfury_boss_char_a1 (); 	// charge!	
};

void() CheckContinueCharge_boss = {
	if (time > self.attack_finished) {
		SUB_AttackFinished (3);
		dfury_boss_run1 ();
		return;		// done charging
	}
	if (random() > 0.5)
		sound (self, CHAN_WEAPON, "knight/sword2.wav", 1, ATTN_NORM);
	else
		sound (self, CHAN_WEAPON, "knight/sword1.wav", 1, ATTN_NORM);
};

void(float loudness) dfury_boss_footsteps = {
	if (random() < 0.5) return; // minimize footstep frequency

	sound(self, CHAN_AUTO, "q15/dfury/dfuryboss_walk.wav", loudness, ATTN_IDLE);
};

void()	dfury_boss_stand1	=[	$stand1,	dfury_boss_stand2	] {ai_stand();self.colormod = '1 1 1';};
void()	dfury_boss_stand2	=[	$stand2,	dfury_boss_stand3	] {ai_stand();};
void()	dfury_boss_stand3	=[	$stand3,	dfury_boss_stand4	] {ai_stand();};
void()	dfury_boss_stand4	=[	$stand4,	dfury_boss_stand5	] {ai_stand();};
void()	dfury_boss_stand5	=[	$stand5,	dfury_boss_stand6	] {ai_stand();};
void()	dfury_boss_stand6	=[	$stand6,	dfury_boss_stand7	] {ai_stand();};
void()	dfury_boss_stand7	=[	$stand7,	dfury_boss_stand8	] {ai_stand();};
void()	dfury_boss_stand8	=[	$stand8,	dfury_boss_stand9	] {ai_stand();};
void()	dfury_boss_stand9	=[	$stand9,	dfury_boss_stand1	] {ai_stand();};

void()	dfury_boss_walk1	=[	$walk1,		dfury_boss_walk2	] {df_idle_sound(); ai_walk(2);self.colormod = '1 1 1'; dfury_boss_footsteps (0.8);};
void()	dfury_boss_walk2	=[	$walk2,		dfury_boss_walk3	] {ai_walk(5);};
void()	dfury_boss_walk3	=[	$walk3,		dfury_boss_walk4	] {ai_walk(5);};
void()	dfury_boss_walk4	=[	$walk4,		dfury_boss_walk5	] {ai_walk(4);};
void()	dfury_boss_walk5	=[	$walk5,		dfury_boss_walk6	] {ai_walk(4);};
void()	dfury_boss_walk6	=[	$walk6,		dfury_boss_walk7	] {ai_walk(2);};
void()	dfury_boss_walk7	=[	$walk7,		dfury_boss_walk8	] {ai_walk(2);};
void()	dfury_boss_walk8	=[	$walk8,		dfury_boss_walk9	] {ai_walk(3);};
void()	dfury_boss_walk9	=[	$walk9,		dfury_boss_walk10	] {ai_walk(3);};
void()	dfury_boss_walk10	=[	$walk10,	dfury_boss_walk11	] {ai_walk(4);};
void()	dfury_boss_walk11	=[	$walk11,	dfury_boss_walk12	] {ai_walk(3); dfury_boss_footsteps (1);};
void()	dfury_boss_walk12	=[	$walk12,	dfury_boss_walk13	] {ai_walk(4);};
void()	dfury_boss_walk13	=[	$walk13,	dfury_boss_walk14	] {ai_walk(6);};
void()	dfury_boss_walk14	=[	$walk14,	dfury_boss_walk1	] {ai_walk(2);};

void()	dfury_boss_run1	=[	$run1,		dfury_boss_run2	] {df_idle_sound(); ai_run (55); CheckForCharge_boss (); self.colormod = '1 1 1';shambler_walking_quake ();dfury_boss_footsteps (1);};
void()	dfury_boss_run2	=[	$run2,		dfury_boss_run3	] {ai_run(60);};
void()	dfury_boss_run3	=[	$run3,		dfury_boss_run4	] {shambler_walking_quake ();dfury_boss_footsteps (1);ai_run(43);};
void()	dfury_boss_run4	=[	$run4,		dfury_boss_run5	] {ai_run(61);};
void()	dfury_boss_run5	=[	$run5,		dfury_boss_run6	] {shambler_walking_quake ();dfury_boss_footsteps (1);ai_run(39);};
void()	dfury_boss_run6	=[	$run6,		dfury_boss_run1	] {ai_run(58);};

void()	dfury_boss_pain1	=[	$pain1,		dfury_boss_pain2	] {sound (self, CHAN_VOICE, "q15/dfury/pain1.wav", 1, ATTN_NORM);self.colormod = '1 1 1';};
void()	dfury_boss_pain2	=[	$pain2,		dfury_boss_pain3	] {};
void()	dfury_boss_pain3	=[	$pain3,		dfury_boss_pain4	] {};
void()	dfury_boss_pain4	=[	$pain4,		dfury_boss_pain5	] {};
void()	dfury_boss_pain5	=[	$pain5,		dfury_boss_run1	] {};

void()	dfury_boss_jump1	=[	$lunge1,		dfury_boss_jump2	] {
	self.nextthink = (time + 0.1);
	ai_face();
	// self.tail_visible = 0;
	shambler_walking_quake ();
	dfury_boss_footsteps (1);
};
void()	dfury_boss_jump2	=[	$lunge2,		dfury_boss_jump3	] {self.nextthink = (time + 0.1);ai_face();shambler_walking_quake ();dfury_boss_footsteps (1);};
void()	dfury_boss_jump3	=[	$lunge3,		dfury_boss_jump4	] {self.nextthink = (time + 0.1);ai_face();};
void()	dfury_boss_jump4	=[	$lunge4,		dfury_boss_jump5	] {self.nextthink = (time + 0.1); ai_face();
	// self.tail_visible = 1;
	self.touch = dfury_boss_JumpTouch;
	makevectors (self.angles);
	self.origin_z = self.origin_z + 1;
	self.velocity = v_forward * 800 + '0 0 250';
	if (self.flags & FL_ONGROUND) self.flags = self.flags - FL_ONGROUND;
};
void()	dfury_boss_jump5	=[	$lunge5,		dfury_boss_jump6	] {self.nextthink = (time + 0.1);};
void()	dfury_boss_jump6	=[	$lunge6,		dfury_boss_jump7	] {self.nextthink = (time + 0.1);};
void()	dfury_boss_jump7	=[	$lunge7,		dfury_boss_jump8	] {self.nextthink = (time + 0.1);};
void()	dfury_boss_jump8	=[ 	$lunge8,		dfury_boss_jump9	] {self.nextthink = (time + 0.1);dfury_boss_footsteps (1);};
void()	dfury_boss_jump9	=[ 	$lunge9,		dfury_boss_jump10	] {self.nextthink = (time + 0.1);dfury_boss_footsteps (1);};
void()	dfury_boss_jump10	=[ 	$lunge10,	dfury_boss_jump1	] 	  {self.nextthink = (time + 0.7);}; // if 0.7 second pass, assume dfury is stuck and jump again
void()	dfury_boss_jump11	=[ 	$lunge11,	dfury_boss_jump12	] 	  {
	self.nextthink = (time + 0.1);
	// self.tail_visible = 0;
	shambler_walking_quake ();
	dfury_boss_footsteps (1);
};
void()	dfury_boss_jump12	=[ 	$lunge12,	dfury_boss_run1	] {
	self.nextthink = (time + 0.1);
	shambler_walking_quake ();
	Monster_Animation_EarthQuake (20, 377);
	dfury_boss_footsteps (1);
};

void() bossdeath_2 = {
	local entity shake;

	// if (ext_dppart) pointparticles(particleeffectnum("BOSS_DEATH_FIN"), self.origin, '0 0 0', 1);

	//Half-Life 1 style explosion shake
	shake = spawn();
	setorigin(shake, self.origin + '0 0 5');
	shake.think = screenshake;
	shake.attack_finished = time + 1;
	shake.nextthink = time + 0.1;
	sound(self.owner, CHAN_AUTO, "ambience/coaled_monster_explode.wav", .8, ATTN_NONE);
	sound(self.owner, CHAN_AUTO, "q15/dfury/boss_explode.wav", 1, ATTN_NONE);
	self.gib1mdl = "progs/q15/gib_sboss.mdl";
	ThrowGib(11, 16);
	remove(self.owner);
	remove(self);
}

void()	dfury_boss_loop1	=[	$death8,	dfury_boss_loop2 ] {};
void()	dfury_boss_loop2	=[	$death9,	dfury_boss_loop1 ] {};

void() Genocide = {
	local entity head;

	if (deathmatch || coop) return;
	
	head = nextent(world);
	while (head!=world) {
		if ((head.health > 0) && (head.flags & FL_MONSTER) && !(head.flags & FL_CLIENT)) {
			if (self.classname == "monster_dfury_boss")	
				T_Damage(head,world,world,head.health,DAMARMOR);
			else
				T_Damage(head,world,world,head.health+10,DAMARMOR);
		}
		head = nextent(head);
	}
};

void() bossdeath_ef = {
	local entity killmonsters, deatheffect;

	deatheffect = spawn();
	setmodel(deatheffect, "progs/spike.mdl");
	deatheffect.origin = self.origin;
	deatheffect.movetype = MOVETYPE_FLY;
	deatheffect.velocity = '0 0 10';
	deatheffect.traileffectnum = particleeffectnum("BOSS_DEATH"); 
	deatheffect.alpha = 0.0001;
	deatheffect.owner = self;
	sound (self, CHAN_AUTO, "q15/dfury/boss_death1.wav", 1, ATTN_NONE);
	deatheffect.think = bossdeath_2;
	deatheffect.nextthink = time + 7;
	
	// Kill all monsters in the map!!!
	if (self.spawnflags & 4) {
		killmonsters = spawn();	
		killmonsters.think = Genocide;
		killmonsters.nextthink = time;
	}

	self.skin = 0;
	self.think = dfury_boss_loop1;
	self.nextthink = time;
};

void()	dfury_boss_die1		=[	$death1,	dfury_boss_die2	] {ai_forward(10);self.colormod = '1 1 1';};
void()	dfury_boss_die2		=[	$death2,	dfury_boss_die3	] {ai_forward(8);};
void()	dfury_boss_die3		=[	$death3,	dfury_boss_die4	] {self.solid = SOLID_NOT; ai_forward(7);};
void()	dfury_boss_die4		=[	$death4,	dfury_boss_die5	] {};
void()	dfury_boss_die5		=[	$death5,	dfury_boss_die6	] {};
void()	dfury_boss_die6		=[	$death6,	dfury_boss_die7	] {};
void()	dfury_boss_die7		=[	$death7,	dfury_boss_die8	] {};
void()	dfury_boss_die8		=[	$death8,	dfury_boss_die9	] {ai_forward(10);};
void()	dfury_boss_die9		=[	$death9,	dfury_boss_die10] {ai_forward(11); self.think = bossdeath_ef;self.nextthink = time;};
void()	dfury_boss_die10	=[	$death10,	dfury_boss_die11] {};
void()	dfury_boss_die11	=[	$death11,	dfury_boss_die12] {};
void()	dfury_boss_die12	=[	$death12,	dfury_boss_die13] {};
void()	dfury_boss_die13	=[	$death13,	dfury_boss_die14] {};
void()	dfury_boss_die14	=[	$death14,	dfury_boss_die15] {sound (self, CHAN_AUTO, "q15/dfury/fall.wav", 1, ATTN_IDLE);};
void()	dfury_boss_die15	=[	$death15,	dfury_boss_die16] {};
void()	dfury_boss_die16	=[	$death16,	dfury_boss_die17] {};
void()	dfury_boss_die17	=[	$death17,	dfury_boss_die17] {};

// void()	dfury_boss_dieb1	=[	$deathb1,	dfury_boss_dieb2	] {self.colormod = '1 1 1';};
// void()	dfury_boss_dieb2	=[	$deathb2,	dfury_boss_dieb3	] {};
// void()	dfury_boss_dieb3	=[	$deathb3,	dfury_boss_dieb4	] {self.solid = SOLID_NOT;};
// void()	dfury_boss_dieb4	=[	$deathb4,	dfury_boss_dieb5	] {};
// void()	dfury_boss_dieb5	=[	$deathb5,	dfury_boss_dieb6	] {};
// void()	dfury_boss_dieb6	=[	$deathb6,	dfury_boss_dieb7	] {sound (self, CHAN_AUTO, "q15/dfury/fall.wav", 1, ATTN_IDLE);};
// void()	dfury_boss_dieb7	=[	$deathb7,	dfury_boss_dieb8	] {};
// void()	dfury_boss_dieb8	=[	$deathb8,	dfury_boss_dieb9	] {Monster_Animation_EarthQuake (20, 377);};
// void()	dfury_boss_dieb9	=[	$deathb9,	dfury_boss_dieb10	] {};
// void()	dfury_boss_dieb10	=[	$deathb10,	dfury_boss_dieb11	] {};
// void()	dfury_boss_dieb11	=[	$deathb11,	dfury_boss_dieb12	] {};
// void()	dfury_boss_dieb12	=[	$deathb12,	dfury_boss_dieb13	] {};
// void()	dfury_boss_dieb13	=[	$deathb13,	dfury_boss_dieb14	] {};
// void()	dfury_boss_dieb14	=[	$deathb14,	dfury_boss_dieb14	] {};

// creates as many gib-sets as defined in cvar 'gibsmultiplier'
void(float maxgibs, float gibscounter) producegibs_dfury_boss =	{
	if (gibscounter >= maxgibs) {
		return;
	} else {
		// Bit hacky :\
		self.gibtype = GIBTYPE_BLOOD;
		ThrowGib(1, 1);
		self.gib1mdl = "progs/ad171/gib_4.mdl";
		ThrowGib(11, 1);
		self.gib1mdl = GIB5_BLOOD;
		ThrowGib(11, 1);
		self.gibtype = GIBTYPE_METAL;
		self.gib1mdl = "progs/ad171/gib_knfoot_l.mdl"; 	
		ThrowGib(11, 1);
		self.gib1mdl = "progs/ad171/gib_knfoot_r.mdl"; 	
		ThrowGib(11, 1);
		self.gib1mdl = "progs/ad171/w_dknightsword.mdl";
		ThrowGib(11, 1);
	}
	gibscounter = gibscounter + 1;
	producegibs_dfury_boss (maxgibs, gibscounter);
};

void() dfury_boss_die = {
	// regular death only
	sound (self, CHAN_VOICE, "q15/dfury/death1.wav", 1, ATTN_NORM);
	dfury_boss_die1 ();
};

void()	dfury_boss_magica1 =[	$magica1,	dfury_boss_magica2	] {self.nextthink = (time + 0.1);ai_face();self.colormod = '1.5 1 1';};
void()	dfury_boss_magica2 =[	$magica2,	dfury_boss_magica3	] {self.nextthink = (time + 0.1);ai_face();self.colormod = '2 1 1';};
void()	dfury_boss_magica3 =[	$magica3,	dfury_boss_magica4	] {self.nextthink = (time + 0.1);ai_face();self.colormod = '2.5 1 1';};
void()	dfury_boss_magica4 =[	$magica4,	dfury_boss_magica5	] {self.nextthink = (time + 0.1);ai_face();self.colormod = '3 1 1';};
void()	dfury_boss_magica5 =[	$magica5,	dfury_boss_magica6	] {self.nextthink = (time + 0.1);ai_face();self.colormod = '3.5 1 1';};
void()	dfury_boss_magica6 =[	$magica6,	dfury_boss_magica7	] {self.nextthink = (time + 0.1);ai_face();};
void()	dfury_boss_magica7 =[	$magica7,	dfury_boss_magica8	] {self.nextthink = (time + 0.1);dfury_boss_shot2(-2);};
void()	dfury_boss_magica8 =[	$magica8,	dfury_boss_magica9	] {self.nextthink = (time + 0.1);};
void()	dfury_boss_magica9 =[	$magica9,	dfury_boss_magica10] {self.nextthink = (time + 0.1);dfury_boss_shot2(0);};
void()	dfury_boss_magica10 =[	$magica10,	dfury_boss_magica11] {self.nextthink = (time + 0.1);dfury_boss_shot2(1);};
void()	dfury_boss_magica11 =[	$magica11,	dfury_boss_magica12] {self.nextthink = (time + 0.1);};
void()	dfury_boss_magica12 =[	$magica12,	dfury_boss_magica13] {self.nextthink = (time + 0.1);dfury_boss_shot2(3);self.colormod = '3 1 1';};
void()	dfury_boss_magica13 =[	$magica13,	dfury_boss_magica14] {self.nextthink = (time + 0.1);ai_face();self.colormod = '2 1 1';};
void()	dfury_boss_magica14 =[	$magica14,	dfury_boss_run1	] {self.nextthink = (time + 0.1);ai_face();self.colormod = '1 1 1';dfury_boss_random_magic();};

void()	dfury_boss_magicb1 =[	$magicb1,	dfury_boss_magicb2]  {self.nextthink = (time + 0.1);ai_face();self.colormod = '1.5 1 1';};
void()	dfury_boss_magicb2 =[	$magicb2,	dfury_boss_magicb3]  {self.nextthink = (time + 0.1);ai_face();self.colormod = '2 1 1';};
void()	dfury_boss_magicb3 =[	$magicb3,	dfury_boss_magicb4]  {self.nextthink = (time + 0.1);ai_face();self.colormod = '2.5 1 1';};
void()	dfury_boss_magicb4 =[	$magicb4,	dfury_boss_magicb5]  {self.nextthink = (time + 0.1);ai_face();self.colormod = '3 1 1';};
void()	dfury_boss_magicb5 =[	$magicb5,	dfury_boss_magicb6]  {self.nextthink = (time + 0.1);ai_face();self.colormod = '3.5 1 1';};
void()	dfury_boss_magicb6 =[	$magicb6,	dfury_boss_magicb7]  {self.nextthink = (time + 0.1);ai_face();};
void()	dfury_boss_magicb7 =[	$magicb7,	dfury_boss_magicb8]  {self.nextthink = (time + 0.1);dfury_boss_shot(-2);};
void()	dfury_boss_magicb8 =[	$magicb8,	dfury_boss_magicb9]  {self.nextthink = (time + 0.1);dfury_boss_shot(-1);};
void()	dfury_boss_magicb9 =[	$magicb9,	dfury_boss_magicb10] {self.nextthink = (time + 0.1);dfury_boss_shot(0);};
void()	dfury_boss_magicb10 =[	$magicb10,	dfury_boss_magicb11] {self.nextthink = (time + 0.1);dfury_boss_shot(1);};
void()	dfury_boss_magicb11 =[	$magicb11,	dfury_boss_magicb12] {self.nextthink = (time + 0.1);dfury_boss_shot(2);};
void()	dfury_boss_magicb12 =[	$magicb12,	dfury_boss_magicb13] {self.nextthink = (time + 0.1);dfury_boss_shot(3);self.colormod = '2 1 1';};
void()	dfury_boss_magicb13 =[	$magicb13,	dfury_boss_run1]	 {self.nextthink = (time + 0.1);ai_face();self.colormod = '1 1 1';dfury_boss_random_magic();};

void()	dfury_boss_magicc1 =[	$magicc1,	dfury_boss_magicc2	] {self.nextthink = (time + 0.1);ai_face();self.colormod = '1.5 1 1';};
void()	dfury_boss_magicc2 =[	$magicc2,	dfury_boss_magicc3	] {self.nextthink = (time + 0.1);ai_face();self.colormod = '2 1 1';};
void()	dfury_boss_magicc3 =[	$magicc3,	dfury_boss_magicc4	] {self.nextthink = (time + 0.1);ai_face();self.colormod = '2.5 1 1';};
void()	dfury_boss_magicc4 =[	$magicc4,	dfury_boss_magicc5	] {self.nextthink = (time + 0.1);ai_face();self.colormod = '3 1 1';};
void()	dfury_boss_magicc5 =[	$magicc5,	dfury_boss_magicc6	] {self.nextthink = (time + 0.1);ai_face();self.colormod = '3.5 1 1';};
void()	dfury_boss_magicc6 =[	$magicc6,	dfury_boss_magicc7	] {self.nextthink = (time + 0.1);dfury_boss_shot(-3);};
void()	dfury_boss_magicc7 =[	$magicc7,	dfury_boss_magicc8	] {self.nextthink = (time + 0.1);dfury_boss_shot(-1);};
void()	dfury_boss_magicc8 =[	$magicc8,	dfury_boss_magicc9	] {self.nextthink = (time + 0.1);dfury_boss_shot(0);};
void()	dfury_boss_magicc9 =[	$magicc9,	dfury_boss_magicc10]  {self.nextthink = (time + 0.1);dfury_boss_shot(1);};
void()	dfury_boss_magicc10 =[	$magicc10,	dfury_boss_magicc11]  {self.nextthink = (time + 0.1);dfury_boss_shot(3);self.colormod = '2 1 1';};
void()	dfury_boss_magicc11 =[	$magicc11,	dfury_boss_run1] 	  {self.nextthink = (time + 0.1);dfury_boss_shot(4);self.colormod = '1 1 1';dfury_boss_random_magic();};

void()	dfury_boss_spawn1 =[	$magicb1,	dfury_boss_spawn2	] {self.nextthink = (time + 0.1);ai_face();self.colormod = '1.5 1 1';};
void()	dfury_boss_spawn2 =[	$magicb2,	dfury_boss_spawn3	] {self.nextthink = (time + 0.1);ai_face();self.colormod = '2 1 1';};
void()	dfury_boss_spawn3 =[	$magicb3,	dfury_boss_spawn4	] {self.nextthink = (time + 0.1);ai_face();self.colormod = '2.5 1 1';};
void()	dfury_boss_spawn4 =[	$magicb4,	dfury_boss_spawn5	] {self.nextthink = (time + 0.1);ai_face();self.colormod = '3 1 1';};
void()	dfury_boss_spawn5 =[	$magicb5,	dfury_boss_spawn6	] {self.nextthink = (time + 0.1);ai_face();self.colormod = '3.5 1 1';};
void()	dfury_boss_spawn6 =[	$magicb6,	dfury_boss_spawn7	] {self.nextthink = (time + 0.1);ai_face();};
void()	dfury_boss_spawn7 =[	$magicb7,	dfury_boss_spawn8	] {self.nextthink = (time + 0.1);};
void()	dfury_boss_spawn8 =[	$magicb8,	dfury_boss_spawn9	] {self.nextthink = (time + 0.1);};
void()	dfury_boss_spawn9 =[	$magicb9,	dfury_boss_spawn10]   {self.nextthink = (time + 0.1);};
void()	dfury_boss_spawn10 =[	$magicb10,	dfury_boss_spawn11]   {self.nextthink = (time + 0.1);dfury_boss_spawner();};
void()	dfury_boss_spawn11 =[	$magicb11,	dfury_boss_spawn12]   {self.nextthink = (time + 0.1);};
void()	dfury_boss_spawn12 =[	$magicb12,	dfury_boss_spawn13]   {self.nextthink = (time + 0.1);dfury_boss_spawner();self.colormod = '2 1 1';};
void()	dfury_boss_spawn13 =[	$magicb13,	dfury_boss_run1]	  {self.nextthink = (time + 0.1);ai_face();self.colormod = '1 1 1';dfury_boss_random_magic();};

void()	dfury_boss_char_a1	=[	$char_a1,	dfury_boss_char_a2	] {ai_charge(76);self.colormod = '1 1 1';dfury_boss_footsteps (1);};
void()	dfury_boss_char_a2	=[	$char_a2,	dfury_boss_char_a3	] {ai_charge(70); dfury_boss_footsteps (0.9);dfury_boss_footsteps (1);};
void()	dfury_boss_char_a3	=[	$char_a3,	dfury_boss_char_a4	] {dfury_boss_footsteps (1);ai_charge(78);if (random() > .3) dfury_boss_jump1();};
void()	dfury_boss_char_a4	=[	$char_a4,	dfury_boss_char_a5	] {ai_charge(76);dfury_boss_footsteps (1);};
void()	dfury_boss_char_a5	=[	$char_a5,	dfury_boss_char_a6	] {ai_charge(74);dfury_boss_footsteps (1);};
void()	dfury_boss_char_a6	=[	$char_a6,	dfury_boss_char_a7	] {dfury_boss_footsteps (1);ai_charge(70); ai_melee_dfury_boss();};
void()	dfury_boss_char_a7	=[	$char_a7,	dfury_boss_char_a8	] {dfury_boss_footsteps (1);ai_charge(71); ai_melee_dfury_boss();};
void()	dfury_boss_char_a8	=[	$char_a8,	dfury_boss_char_a9	] {dfury_boss_footsteps (1);ai_charge(73); ai_melee_dfury_boss();};
void()	dfury_boss_char_a9	=[	$char_a9,	dfury_boss_char_a10	] {dfury_boss_footsteps (1);ai_charge(70); ai_melee_dfury_boss();};
void()	dfury_boss_char_a10=[	$char_a10,	dfury_boss_char_a11	] {dfury_boss_footsteps (1);ai_charge(70); ai_melee_dfury_boss();};
void()	dfury_boss_char_a11=[	$char_a11,	dfury_boss_char_a12	] {dfury_boss_footsteps (1);ai_charge(78); ai_melee_dfury_boss();};
void()	dfury_boss_char_a12=[	$char_a12,	dfury_boss_char_a13	] {dfury_boss_footsteps (1);ai_charge(76);};
void()	dfury_boss_char_a13=[	$char_a13,	dfury_boss_char_a14	] {ai_charge(74); dfury_boss_footsteps (0.9);};
void()	dfury_boss_char_a14=[	$char_a14,	dfury_boss_char_a15	] {dfury_boss_footsteps (1);ai_charge(75);};
void()	dfury_boss_char_a15=[	$char_a15,	dfury_boss_char_a16	] {dfury_boss_footsteps (1);ai_charge(71);};
void()	dfury_boss_char_a16=[	$char_a16,	dfury_boss_run1	] 	  {dfury_boss_footsteps (1);ai_charge(73);};

void()	dfury_boss_char_b1	=[	$char_b1,	dfury_boss_char_b2	] {CheckContinueCharge_boss (); ai_charge(23); ai_melee_dfury_boss();self.colormod = '1 1 1';};
void()	dfury_boss_char_b2	=[	$char_b2,	dfury_boss_char_b3	] {ai_charge(72); ai_melee_dfury_boss();dfury_boss_footsteps (1);};
void()	dfury_boss_char_b3	=[	$char_b3,	dfury_boss_char_b4	] {ai_charge(72); ai_melee_dfury_boss();dfury_boss_footsteps (1);};
void()	dfury_boss_char_b4	=[	$char_b4,	dfury_boss_char_b5	] {ai_charge(72); ai_melee_dfury_boss(); dfury_boss_footsteps (0.9);};
void()	dfury_boss_char_b5	=[	$char_b5,	dfury_boss_char_b6	] {ai_charge(78); ai_melee_dfury_boss();dfury_boss_footsteps (1);};
void()	dfury_boss_char_b6	=[	$char_b6,	dfury_boss_char_b1	] {ai_charge(78); ai_melee_dfury_boss();dfury_boss_footsteps (1);};

void()	dfury_boss_slice1	=[	$slice1,	dfury_boss_slice2	] {ai_charge(79);self.colormod = '1 1 1';};
void()	dfury_boss_slice2	=[	$slice2,	dfury_boss_slice3	] {ai_charge(76);};
void()	dfury_boss_slice3	=[	$slice3,	dfury_boss_slice4	] {ai_charge(73); dfury_boss_footsteps (0.8);};
void()	dfury_boss_slice4	=[	$slice4,	dfury_boss_slice5	] {ai_charge(74);};
void()	dfury_boss_slice5	=[	$slice5,	dfury_boss_slice6	] {ai_charge(77); ai_melee_dfury_boss();};
void()	dfury_boss_slice6	=[	$slice6,	dfury_boss_slice7	] {ai_charge(75); ai_melee_dfury_boss();};
void()	dfury_boss_slice7	=[	$slice7,	dfury_boss_slice8	] {ai_charge(78); ai_melee_dfury_boss(); dfury_boss_footsteps (0.8);};
void()	dfury_boss_slice8	=[	$slice8,	dfury_boss_slice9	] {ai_charge(72); ai_melee_dfury_boss();};
void()	dfury_boss_slice9	=[	$slice9,	dfury_boss_slice10	] {ai_melee_dfury_boss();};
void()	dfury_boss_slice10	=[	$slice10,	dfury_boss_slice11	] {ai_charge(64);ai_melee_dfury_boss();dfury_boss_footsteps (1);};
void()	dfury_boss_slice11	=[	$slice11,	dfury_boss_slice12	] {ai_charge(64);ai_melee_dfury_boss();};
void()	dfury_boss_slice12	=[	$slice12,	dfury_boss_slice13	] {ai_charge(64);ai_melee_dfury_boss();};
void()	dfury_boss_slice13	=[	$slice13,	dfury_boss_slice14	] {ai_charge(64);ai_melee_dfury_boss();dfury_boss_footsteps (1);};
void()	dfury_boss_slice14	=[	$slice14,	dfury_boss_run1	]	  {ai_charge(53);};

void()	dfury_boss_smash1	=[	$smash1,	dfury_boss_smash2	] {ai_charge(1);self.colormod = '1 1 1';};
void()	dfury_boss_smash2	=[	$smash2,	dfury_boss_smash3	] {ai_charge(48);};
void()	dfury_boss_smash3	=[	$smash3,	dfury_boss_smash4	] {ai_charge(9);};
void()	dfury_boss_smash4	=[	$smash4,	dfury_boss_smash5	] {ai_charge(51); dfury_boss_footsteps (0.8);};
void()	dfury_boss_smash5	=[	$smash5,	dfury_boss_smash6	] {ai_charge(40); ai_melee_dfury_boss();};
void()	dfury_boss_smash6	=[	$smash6,	dfury_boss_smash7	] {ai_charge(7); ai_melee_dfury_boss();};
void()	dfury_boss_smash7	=[	$smash7,	dfury_boss_smash8	] {ai_charge(42); ai_melee_dfury_boss();};
void()	dfury_boss_smash8	=[	$smash8,	dfury_boss_smash9	] {ai_charge(42); ai_melee_dfury_boss();Monster_Animation_EarthQuake (20, 377);dfury_boss_footsteps (1);};
void()	dfury_boss_smash9	=[	$smash9,	dfury_boss_smash10	] {ai_charge(3); ai_melee_dfury_boss();Monster_Animation_EarthQuake (20, 377);};
void()	dfury_boss_smash10	=[	$smash10,	dfury_boss_smash11	] {ai_charge(0);Monster_Animation_EarthQuake (20, 377);};
void()	dfury_boss_smash11	=[	$smash11,	dfury_boss_smash12	] {ai_charge(0);};
void()	dfury_boss_smash12	=[	$smash12,	dfury_boss_smash13	] {ai_charge(0);};
void()	dfury_boss_smash13	=[	$smash13,	dfury_boss_smash14	] {ai_charge(0);};
void()	dfury_boss_smash14	=[	$smash14,	dfury_boss_smash15	] {ai_charge(0);dfury_boss_footsteps (1);};
void()	dfury_boss_smash15	=[	$smash15,	dfury_boss_run1	] {ai_charge(0);};

void()	dfury_boss_watk1	=[	$w_attack1,	dfury_boss_watk2	] 	  {ai_charge(8);self.colormod = '1 1 1';};
void()	dfury_boss_watk2	=[	$w_attack2,	dfury_boss_watk3	]	  {ai_charge(0);};
void()	dfury_boss_watk3	=[	$w_attack3,	dfury_boss_watk4	]	  {ai_charge(0);};
void()	dfury_boss_watk4	=[	$w_attack4,	dfury_boss_watk5	]	  {ai_melee_dfury_boss();};
void()	dfury_boss_watk5	=[	$w_attack5,	dfury_boss_watk6	]	  {ai_melee_dfury_boss();};
void()	dfury_boss_watk6	=[	$w_attack6,	dfury_boss_watk7	] 	  {ai_melee_dfury_boss();};
void()	dfury_boss_watk7	=[	$w_attack7,	dfury_boss_watk8	] 	  {ai_charge(24);ai_melee_dfury_boss();};
void()	dfury_boss_watk8	=[	$w_attack8,	dfury_boss_watk9	] 	  {ai_charge(30);ai_melee_dfury_boss();};
void()	dfury_boss_watk9	=[	$w_attack9,	dfury_boss_watk10	]	  {ai_charge(32);};
void()	dfury_boss_watk10	=[	$w_attack10,	dfury_boss_watk11	] {ai_charge(16); ai_melee_dfury_boss();};
void()	dfury_boss_watk11	=[	$w_attack11,	dfury_boss_watk12	] {ai_charge(15); ai_melee_dfury_boss(); dfury_boss_footsteps (0.8);};
void()	dfury_boss_watk12	=[	$w_attack12,	dfury_boss_watk13	] {ai_charge(15); ai_melee_dfury_boss();};
void()	dfury_boss_watk13	=[	$w_attack13,	dfury_boss_watk14	] {ai_charge(0);};
void()	dfury_boss_watk14	=[	$w_attack14,	dfury_boss_watk15	] {ai_charge(0);ai_melee_dfury_boss();};
void()	dfury_boss_watk15	=[	$w_attack15,	dfury_boss_watk16	] {ai_charge(0);ai_melee_dfury_boss();};
void()	dfury_boss_watk16	=[	$w_attack16,	dfury_boss_run1	] 	  {ai_charge(13); dfury_boss_footsteps (0.8);};

void() dfury_boss_idle_sound = {
	if (random() < 0.2) sound (self, CHAN_VOICE, "q15/dfury/idle.wav", 1, ATTN_NORM);
};

void(entity inflictor, entity attacker, float damage)	dfury_boss_pain = {
	if (self.pain_finished > time) return;

	sound (self, CHAN_VOICE, "q15/dfury/pain1.wav", 1, ATTN_NORM);
	if (time - self.pain_finished > 5) {	// allways go into pain frame if it has been a while
		dfury_boss_pain1 ();
		self.pain_finished = time + 1;
		return;
	}
	
	if ((random()*30) > damage) return;		// didn't flinch

	self.pain_finished = time + 1;
	dfury_boss_pain1 ();
};

void() dfury_boss_melee = {
	self.style = self.style + 1;

	sound (self, CHAN_WEAPON, "q15/dfury/slash1.wav", 1, ATTN_NORM);
	if (self.style == 1)
		dfury_boss_slice1 ();
	else if (self.style == 2)
		dfury_boss_smash1 ();
	else if (self.style == 3) {
		dfury_boss_watk1 ();
		self.style = 0;
	}
};

// adds random magic attack animation
void() dfury_boss_random_magic = {
	local float zufall;
	zufall = random();
	if (zufall > 0.56 && zufall < 0.62)
		self.th_missile = dfury_boss_magica1;
	else if (zufall > 0.61)
		self.th_missile = dfury_boss_spawn1;
	else if (zufall < 0.34)
		self.th_missile = dfury_boss_magicb1;
	else
		self.th_missile = dfury_boss_magicc1;	
};

//boss jump attack
void()	dfury_boss_JumpTouch = {
	local float ldmg;

	if (self.health <= 0) return;
		
	if (other.takedamage) {
		if ( vlen(self.velocity) > 100 ) {
			ldmg = 50 + 10*random();	// default 40
			ldmg = Align_DamageModifier(other,self,ldmg, TRUE);
			if (other.classname == "player") T_Damage (other, self, self, ldmg, DAMARMOR);	
		}
	}

	if (!checkbottom(self)) {
		// self.tail_visible = 0;
		if (self.flags & FL_ONGROUND) { // jump randomly to not get hung up
			self.touch = SUB_Null;
			self.think = dfury_boss_jump1;
			self.nextthink = time + 0.1;
		}
		return;	// not on ground yet
	}

	self.touch = SUB_Null;
	self.think = dfury_boss_jump11;
	self.nextthink = time + 0.1;
};


void() dfury_boss_pause = {
	sound ( self, CHAN_AUTO, "drake/misc/wallbrk.wav", 1, ATTN_NONE);
	self.skin = 1;
	self.takedamage = DAMAGE_AIM;
	self.th_stand = dfury_boss_stand1;
	self.th_walk = dfury_boss_walk1;
	self.th_run = dfury_boss_run1;
	self.th_melee = dfury_boss_melee;
	self.th_missile = dfury_boss_random_magic;
	self.th_pain = dfury_boss_pain;
	self.th_die = dfury_boss_die;
	self.use = SUB_Null;
	self.think = dfury_boss_run1;
	self.enemy = activator;
	self.nextthink = time + 0.1;
	FoundHuntTarget(FALSE);	
	self.delay = 0;	
};

void() dfury_boss_pause1 = {
	self.takedamage = DAMAGE_NO;
	self.use = dfury_boss_pause;
	self.think = dfury_boss_pause1;
    self.nextthink = time + 0.1;
    self.skin = 0;
};

//QUAKED monster_dfury (1 0 0) (-16 -16 -24) (16 16 40) Ambush
void() monster_dfury_boss = {
	// Check all spawn exceptions (monsters.qc)
	if (monster_checkspawn() == TRUE) return;

	self.mdl = "progs/q15/dfury_boss.mdl";
	precache_model ("progs/q15/dfury_boss.mdl");
	precache_model ("progs/k_spike.mdl");
	precache_model ("progs/q15/proj_summon.mdl");
	precache_model ("progs/q15/gib_sboss.mdl");
	precache_model ("progs/gib1.mdl");
	precache_model ("progs/ad171/gib_4.mdl");
	precache_model (GIB5_BLOOD);
	precache_model ("progs/ad171/gib_knfoot_l.mdl");
	precache_model ("progs/ad171/gib_knfoot_r.mdl");
	precache_model ("progs/ad171/w_dknightsword.mdl");
	precache_model ("progs/drake/s_explod.spr");
	precache_sound ("q15/dfury/boss_explode.wav");
	precache_sound ("q15/dfury/boss_death1.wav");
	precache_sound ("q15/dfury/attack1.wav");
	precache_sound ("q15/dfury/death1.wav");
	precache_sound ("q15/dfury/pain1.wav");
	precache_sound ("q15/dfury/death2.wav");
	precache_sound ("q15/dfury/pain2.wav");
	precache_sound ("q15/dfury/sight1.wav");
	precache_sound ("quoth/dguard/hit.wav");
	precache_sound ("q15/dfury/slash1.wav");
	precache_sound ("q15/dfury/idle.wav");
	precache_sound ("q15/dfury/proj.wav");
	precache_sound ("q15/dfury/fall.wav");
	precache_sound ("q15/dfury/dfuryboss_walk.wav");
	precache_sound ("ad171/wraith/attack3.wav");
	precache_sound ("ad171/gibs/gibmetalb.wav");
	precache_sound ("drake/misc/wallbrk.wav");
	precache_sound ("knight/sword1.wav");
	precache_sound ("knight/sword2.wav");

	// Precache minion stuff since we use it regardless of the presence of a monster_minotaurminion
	precache_model ("progs/ad171/mon_gargoyle.mdl");
	precache_model ("progs/ad171/h_gargoyle.mdl");
	precache_model (MODEL_PROJ_GARGBALL);		// FB growing 8 frames
	precache_model (MODEL_PROJ_GARGOYLE);		// red/smoke wiz projectile
	precache_model (MODEL_PROJ_GARGOYLEGRN);	// acid/smoke wiz projectile
	precache_model ("progs/ad171/gib_gargwing1.mdl");
	precache_model ("progs/ad171/gib_gargwing2.mdl");
	precache_sound ("ad171/gargoyle/idle1.wav");
	precache_sound ("ad171/gargoyle/perch1.wav");
	precache_sound ("ad171/gargoyle/perch2.wav");
	precache_sound ("ad171/gargoyle/attack1.wav");	// Doom imp fireball!
	precache_sound ("ad171/gargoyle/swoop1.wav");
	precache_sound ("ad171/gargoyle/swoop2.wav");
	precache_sound ("ad171/gargoyle/swoop1hit.wav");
	precache_sound ("ad171/gargoyle/wings1.wav");
	precache_sound ("ad171/gargoyle/pain75.wav");
	precache_sound ("ad171/gargoyle/pain100.wav");
	precache_sound ("ad171/gargoyle/death1.wav");
	precache_sound ("ad171/gargoyle/sight1.wav");
	precache_model ("progs/ad171/proj_fury1.mdl");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel (self, "progs/q15/dfury_boss.mdl");
	self.skin = 0;
	self.scale = 1;
	setsize (self, '-26 -30 -24', '26 30 100');

	if (skill == 3 || coop) self.health = 4700;
	else if (skill == 2) self.health = 4300;
	else self.health = 3500;			// dfury_boss_health
	self.max_health = self.health;

	self.classtype = CT_MONDFURYBOSS;
	self.classmove = MON_MOVEWALK;	
	self.classgroup = CG_DEMON;	// Don't fight my minions!  Sorry knights

	// statue
	if (self.spawnflags & 2) {
		self.skin = 0;
		if (self.frame == 0) self.frame = 10;
		if (!self.targetname) {
			dprint ("statue not targeted\n");
			dprint (self.classname);
			dprint (" at ");
			dprint (vtos(self.origin));
			dprint ("\n");
			return;
		}
		self.classgroup = CG_STONE;	// Join the statues!
		self.use = dfury_boss_pause;
		self.th_stand = dfury_boss_pause1;
		self.th_walk = dfury_boss_pause1;
		self.th_run = dfury_boss_pause1;
		if (self.deathstring == "")  self.deathstring = " was smashed by a Stone Brigade Commander's fury\n";
	} else {
		self.skin = 1; // Normal skin is on 1, yeah it's weird
		self.th_stand = dfury_boss_stand1;
		self.th_walk = dfury_boss_walk1;
		self.th_run = dfury_boss_run1;
		self.th_melee = dfury_boss_melee;
		self.th_missile = dfury_boss_random_magic;		// adds random magic attack animation
		self.th_pain = dfury_boss_pain;
		self.th_die = dfury_boss_die;
		if (self.deathstring == "")  self.deathstring = " felt the Brigade Commander's fury like a whirlwind\n";
	}

	monster_start ();
};
