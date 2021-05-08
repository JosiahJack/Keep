/*
==============================================================================

Fury Knight

==============================================================================
*/

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
//void() FuryMissile;
void() FuryBossHome;
void() dfury_boss_char_a1;
void() dfury_boss_run1;
void() df_idle_sound;
void() dfury_boss_random_magic;		// adds random magic attack animation
					// in original ID1, only "dfury_magiccxx" is used
void()	dfury_boss_JumpTouch;

void(float AttackNumber) dfury_boss_shot2 =
{
	local	entity 	missile;
	local	vector	dir, org;
	local	float	dist, flytime;

	dir = normalize((self.enemy.origin + '0 0 10') - self.origin);
	dist = vlen (self.enemy.origin - self.origin);
	flytime = dist * 0.002;
	if (flytime < 0.1)
		flytime = 0.1;

	self.effects = self.effects | EF_MUZZLEFLASH;

	makevectors (self.angles);

	missile = spawn ();
	missile.owner = self;
	missile.solid = SOLID_BBOX;
	missile.movetype = MOVETYPE_FLYMISSILE;
	precache_model ("progs/proj_fury1.mdl");
	setmodel (missile, "progs/proj_fury1.mdl");

	setsize (missile, '0 0 0', '0 0 0');		

	if ( AttackNumber == 1)
	{
		org = self.origin + v_forward*20 + v_up*12; // 20 // 44;
	}
	else if ( AttackNumber == 2)
	{
		org = self.origin + v_forward*18 + v_up*10; // 18 // 42;
	}
	else if ( AttackNumber == 3)
	{
		org = self.origin + v_forward*12 + v_up*12 + v_right*20;
// up20
	}
    else if ( AttackNumber == 4)
	{
        org = self.origin + v_forward*20 + v_up*16;
	}

	setorigin ( missile, org );
	missile.velocity = dir * 500;
	missile.avelocity = '300 300 300';
	missile.enemy = self.enemy;
	missile.touch = FuryBossMissileTouch;
	missile.nextthink = time + 0.1;
	missile.think = FuryBossHome;
	sound (self, CHAN_WEAPON, "dfury/attack1.wav", 1, ATTN_NORM);
	self.attack_finished = time + 2;
};


void(float offset) dfury_boss_shot =
{
	local	vector	offang;
	local	vector	org, vec;
	
	offang = vectoangles (self.enemy.origin - self.origin);
	offang_y = offang_y + offset * 6;
	
	makevectors (offang);

	org = self.origin + self.mins + self.size*0.5 + v_forward * 20;

// set missile speed
	vec = normalize (v_forward);
	vec_z = 0 - vec_z + (random() - 0.5)*0.1;
	//newmis.classname = "knightspike";
	launch_enemy_spike (org, vec);
	setmodel (newmis, "progs/k_spike.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);	
	//newmis.touch = FuryBossSpikeTouch;	
	newmis.velocity = vec*700;
	sound (self, CHAN_WEAPON, "dfury/proj.wav", 1, ATTN_NORM);
};


/*
void(float offset) dfury_boss_shot =
{
	local	vector	offang;
	local	vector	org, vec;
	
	offang = vectoangles (self.enemy.origin - self.origin);
	offang_y = offang_y + offset * 6;
	
	makevectors (offang);

	org = self.origin + self.mins + self.size*0.5 + v_forward * 20;

// set missile speed
	vec = normalize (v_forward);
	vec_z = 0 - vec_z + (random() - 0.5)*0.1;
	
	if ((autocvar_skill_adjusted_dfury_projectile_homing) && (skill != 0))
		launch_homing_spikes (org, vec);	// is located in wizard.qc
	else
		launch_enemy_spike (org, vec);
	newmis.classname = "furyspike";
	newmis.touch = FuryMissileTouch;
	precache_model ("progs/proj_fury1.mdl");
	setmodel (newmis, "progs/proj_fury1.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);		
	newmis.velocity = vec*700;
	sound (self, CHAN_WEAPON, "dfury/attack1.wav", 1, ATTN_NORM);
};
*/

void() dfury_boss_spawner =
{
	local vector distancedelta; 
	local vector nozdistancedelta; 
	local	entity missile;
	
	self.effects = self.effects | EF_MUZZLEFLASH;


	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
		
// set missile speed	

	makevectors (self.angles);

	var float autocvar_ogreaim = 0;
	distancedelta = self.enemy.origin - self.origin; //work out distance vector  
	nozdistancedelta = distancedelta;  //copy to no height distance vector 
	
	nozdistancedelta_z = 0;  //remove height 
	
	missile.velocity = normalize(distancedelta); //set the velocity to the distance
	missile.velocity = missile.velocity * 100 + v_right*(random());   //give it more power 
	
    //  missile.velocity_z = missile.velocity_z + vlen(nozdistancedelta)*0.7;  //add extra height for extra distance	
	
	missile.velocity_z = missile.velocity_z + 350 + vlen(nozdistancedelta)*0.22*(1 + (0.3*(random()))); 
	missile.avelocity = '300 300 300';

	missile.angles = vectoangles(missile.velocity);
	
	//missile.touch = FuryBossSpawnTouch;
	
// set missile duration
	missile.nextthink = time + 2.5;
	missile.think = FuryBossSpawnTouch;

	setmodel (missile, "progs/proj_summon.mdl");
	setsize (missile, '0 0 0', '0 0 0');	
	missile.scale = 2;	
	setorigin (missile, self.origin);
};


/*
void() dfury_boss_spawner =
{
	local	entity missile;
	
	
	sound (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);


	missile = spawn ();
	missile.cansplash = TRUE;
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	missile.classname = "spawnball";
		
// set missile speed	

	makevectors (self.v_angle);

	if (self.v_angle_x)
		missile.velocity = v_forward*60 + v_up * 200 + crandom()*v_right*10 + crandom()*v_up*10;
	else
	{
		missile.velocity = aim(self, 10000);
		missile.velocity = missile.velocity * 60;
		missile.velocity_z = 20;
	}

	missile.avelocity = '300 300 300';

	missile.angles = vectoangles(missile.velocity);
	
	//missile.touch = F;
	
// set missile duration
	missile.nextthink = time + 2.5;
	missile.think = FuryBossSpawnTouch;

	setmodel (missile, "progs/grenade.mdl");
	setsize (missile, '0 0 0', '0 0 0');		

	if ((autocvar_weapon_position_right) && (!autocvar_weapon_position_fully_adjustable) && (!cvar("chase_active")))	// if 'weapon_position_right' is set, move all projectiles to the right
		setorigin (missile, self.origin + self.view_ofs + v_up * -13 + v_right * 6);
	else if ((!autocvar_weapon_position_right) && (autocvar_weapon_position_fully_adjustable) && (!cvar("chase_active")))	// if 'weapon_position_fully_adjustable' is set, move all projectiles to an ADJUSTABLE position
		setorigin (missile, self.origin + self.view_ofs + v_up * -13 + v_right * autocvar_weapon_position_adjustable_projectile_grenade_offset);
	else
		setorigin (missile, self.origin);
};
*/

void() FuryBossHome =
{
	if (self.enemy.health < 1)
	{
		remove(self);
		return;
	}

	if (skill == 3)
		ai_track (self.enemy, 420);
	else
		ai_track (self.enemy, 300);

	self.nextthink = time + 0.2;
	self.think = FuryBossHome;	
};

void() FurySpawnerExplode =
{
	pointparticles(particleeffectnum("gibacid"), self.origin, '0 0 0', 1);

	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	//setmodel (self, "progs/s_explod.spr");
	self.solid = SOLID_NOT;
	s_explode1 ();
};

void() FuryBossSpawnTouch =
{
	local entity afritspawn, tmp;
	FurySpawnerExplode();
	afritspawn = spawn();
	sound (self, CHAN_WEAPON, "misc/summon.wav", 1, ATTN_NORM);
	afritspawn.classname = "monster_afrit";
	setorigin(afritspawn, self.origin);
	//afritspawn.angles = self.angles;
	tmp = self;
	self = afritspawn;
	monster_afrit();
	//self.scale = .4;

}


void() FuryBossMissileTouch =
{
	if (other == self.owner)
	{
		remove(self);
		return;		// don't explode on any fury knights

	}

	if (other.classname == "monster_zombie")
		T_Damage (other, self, self, 110);	
		
	T_RadiusDamage (self, self.owner, 20, world);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	setmodel (self, "progs/s_explod.spr");
	self.solid = SOLID_NOT;
	s_explode1 ();
	//sound (self, CHAN_WEAPON, "dfury/proj.wav", 1, ATTN_NORM);
};

void() FuryBossSpikeTouch =
{
	if (other == self.owner)
	{
		remove(self);
		return;		// don't explode on any fury knights

	}

	//T_Damage (self.enemy, self, self, 5);
	//T_RadiusDamage (self, self.owner, 7, world);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_KNIGHTSPIKE);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	//setmodel (self, "progs/s_flame.spr");
	self.solid = SOLID_NOT;
	s_explode1 ();
	T_RadiusDamage (self, self.owner, 5, world);	
	//sound (self, CHAN_WEAPON, "dfury/proj.wav", 1, ATTN_NORM);
};


void() CheckForCharge_boss =
{
// check for mad charge
if (!enemy_vis)
	return;
if (time < self.attack_finished)
	return;	
if ( fabs(self.origin_z - self.enemy.origin_z) > 20)
	return;		// too much height change
if ( vlen (self.origin - self.enemy.origin) < 80)
	return;		// use regular attack

// charge		
	SUB_AttackFinished (2);
	dfury_boss_char_a1 ();

};

void() CheckContinueCharge_boss =
{
	if (time > self.attack_finished)
	{
		SUB_AttackFinished (3);
		dfury_boss_run1 ();
		return;		// done charging
	}
	if (random() > 0.5)
		sound (self, CHAN_WEAPON, "knight/sword2.wav", 1, ATTN_NORM);
	else
		sound (self, CHAN_WEAPON, "knight/sword1.wav", 1, ATTN_NORM);
};

//===========================================================================

void(float loudness) dfury_boss_footsteps =
{
if (autocvar_monsterfootsteps == 1)	// only play monster footsteps sound when cvar is 1
	{
	local float select;
	select = random();
	if (select <= 0.33)
		sound(self, CHAN_AUTO, "walk/dfuryboss1.wav", loudness, ATTN_IDLE);
	else if (select <= 0.66)
		sound(self, CHAN_AUTO, "walk/dfuryboss2.wav", loudness, ATTN_IDLE);
	else 
		sound(self, CHAN_AUTO, "walk/dfuryboss3.wav", loudness, ATTN_IDLE);
	}
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

//===========================================================================

void()	dfury_boss_walk1	=[	$walk1,		dfury_boss_walk2	] {
df_idle_sound();
ai_walk(2);self.colormod = '1 1 1'; dfury_boss_footsteps (0.8);};
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

//===========================================================================

void()	dfury_boss_run1	=[	$run1,		dfury_boss_run2	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);
df_idle_sound();
ai_run (60); CheckForCharge3 (); self.colormod = '1 1 1';shambler_walking_quake ();dfury_boss_footsteps (1);};
void()	dfury_boss_run2	=[	$run2,		dfury_boss_run3	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(65);};
void()	dfury_boss_run3	=[	$run3,		dfury_boss_run4	] {shambler_walking_quake ();dfury_boss_footsteps (1);self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(48);};
void()	dfury_boss_run4	=[	$run4,		dfury_boss_run5	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(66);};
void()	dfury_boss_run5	=[	$run5,		dfury_boss_run6	] {shambler_walking_quake ();dfury_boss_footsteps (1);self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(44);};
void()	dfury_boss_run6	=[	$run6,		dfury_boss_run1	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(63);};

//============================================================================

void()	dfury_boss_pain1	=[	$pain1,		dfury_boss_pain2	] {sound (self, CHAN_VOICE, "dfury/pain1.wav", 1, ATTN_NORM);self.colormod = '1 1 1';};
void()	dfury_boss_pain2	=[	$pain2,		dfury_boss_pain3	] {};
void()	dfury_boss_pain3	=[	$pain3,		dfury_boss_pain4	] {};
void()	dfury_boss_pain4	=[	$pain4,		dfury_boss_pain5	] {};
void()	dfury_boss_pain5	=[	$pain5,		dfury_boss_run1	] {};

//============================================================================

void()	dfury_boss_jump1	=[	$lunge1,		dfury_boss_jump2	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.01);ai_face();self.tail_visible = 0;shambler_walking_quake ();dfury_boss_footsteps (1);};
void()	dfury_boss_jump2	=[	$lunge2,		dfury_boss_jump3	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.01);ai_face();shambler_walking_quake ();dfury_boss_footsteps (1);};
void()	dfury_boss_jump3	=[	$lunge3,		dfury_boss_jump4	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.01);ai_face();};
void()	dfury_boss_jump4	=[	$lunge4,		dfury_boss_jump5	]
{
	self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001); ai_face();
	self.tail_visible = 1;
	self.touch = dfury_boss_JumpTouch;
	makevectors (self.angles);
	self.origin_z = self.origin_z + 1;
	self.velocity = v_forward * 800 + '0 0 250';
	if (self.flags & FL_ONGROUND)
		self.flags = self.flags - FL_ONGROUND;
};
void()	dfury_boss_jump5	=[	$lunge5,		dfury_boss_jump6	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.01);};
void()	dfury_boss_jump6	=[	$lunge6,		dfury_boss_jump7	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.01);};
void()	dfury_boss_jump7	=[	$lunge7,		dfury_boss_jump8	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.01);};
void()	dfury_boss_jump8	=[ 	$lunge8,		dfury_boss_jump9	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.01);dfury_boss_footsteps (1);};
void()	dfury_boss_jump9	=[ 	$lunge9,		dfury_boss_jump10	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.01);dfury_boss_footsteps (1);};
void()	dfury_boss_jump10	=[ 	$lunge10,	dfury_boss_jump1	] {
self.nextthink = time + 0.7;
// if 0.7 second pass, assume dfury is stuck and jump again
};

void()	dfury_boss_jump11	=[ 	$lunge11,	dfury_boss_jump12	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.01);self.tail_visible = 0;shambler_walking_quake ();dfury_boss_footsteps (1);};
void()	dfury_boss_jump12	=[ 	$lunge12,	dfury_boss_run1	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.01);shambler_walking_quake ();Monster_Animation_EarthQuake (20, 377);dfury_boss_footsteps (1);};



//=============================================================================


void() dfury_boss_dieburn1	=[	$deathb1,	dfury_boss_dieburn2	] {self.burnz_origin = 12;
burn_toggle_allround();
};
void() dfury_boss_dieburn2	=[	$deathb2,	dfury_boss_dieburn3	] {self.burnz_origin = 10;
};
void() dfury_boss_dieburn3	=[	$deathb3,	dfury_boss_dieburn4	] {self.burnz_origin = 6;
self.solid = SOLID_NOT;
};
void() dfury_boss_dieburn4	=[	$deathb4,	dfury_boss_dieburn5	] {self.burnz_origin = 3;
};
void() dfury_boss_dieburn5	=[	$deathb5,	dfury_boss_dieburn6	] {self.burnz_origin = 0;
};
void() dfury_boss_dieburn6	=[	$deathb6,	dfury_boss_dieburn7	] {self.burnz_origin = -2;
};
void() dfury_boss_dieburn7	=[	$deathb7,	dfury_boss_dieburn8	] {self.burnz_origin = -4;
};
void() dfury_boss_dieburn8	=[	$deathb8,	dfury_boss_dieburn9	] {self.burnz_origin = -6;
};
void() dfury_boss_dieburn9	=[	$deathb9,	dfury_boss_dieburn9	] {self.burnz_origin = -8;
};

void() bossdeath_2 =
{
	sendParticle("BOSS_DEATH_FIN", self.origin, '0 0 0', 1);
	
	//Half-Life 1 style explosion shake
	local entity shake = spawn();
	setorigin(shake, self.origin + '0 0 5');
	shake.think = screenshake;
	shake.attack_finished = time + 1;
	shake.nextthink = time + 0.1;
	
	sound7 (self.owner, CHAN_AUTO, "ambience/coaled_monster_explode.wav", .8, ATTN_NONE, SNDSPD);
	sound7 (self.owner, CHAN_AUTO, "dfury/boss_explode.wav", 1, ATTN_NONE, SNDSPD);

	ThrowBody ("progs/gib_sBoss.mdl", self.health-100);
	ThrowBody ("progs/gib_sBoss.mdl", self.health-100);
	ThrowBody ("progs/gib_sBoss.mdl", self.health-50);
	ThrowBody ("progs/gib_sBoss.mdl", self.health-100);
	ThrowBody ("progs/gib_sBoss.mdl", self.health-50);
	ThrowBody ("progs/gib_sBoss.mdl", self.health-100);
	ThrowBody ("progs/gib_sBoss.mdl", self.health-100);
	ThrowBody ("progs/gib_sBoss.mdl", self.health-50);
	ThrowBody ("progs/gib_sBoss.mdl", self.health-100);
	ThrowBody ("progs/gib_sBoss.mdl", self.health-50);
	ThrowBody ("progs/gib_sBoss.mdl", self.health-50);
	ThrowBody ("progs/gib_sBoss.mdl", self.health-100);
	ThrowBody ("progs/gib_sBoss.mdl", self.health-100);
	ThrowBody ("progs/gib_sBoss.mdl", self.health-50);
	ThrowBody ("progs/gib_sBoss.mdl", self.health-100);
	ThrowBody ("progs/gib_sBoss.mdl", self.health-50);
	
	
	remove(self.owner);
	remove(self);
}

void()	dfury_boss_loop1	=[	$death8,	dfury_boss_loop2 ] {};
void()	dfury_boss_loop2	=[	$death9,	dfury_boss_loop1 ] {};

void() bossdeath_ef =
{
	newmis = spawn();
	setmodel(newmis, "progs/spike.mdl");
	newmis.origin = self.origin;
	newmis.movetype = MOVETYPE_FLY;
	newmis.velocity = '0 0 10';
	newmis.traileffectnum = particleeffectnum("BOSS_DEATH"); 
	newmis.alpha = 0.0001;
	newmis.owner = self;
	
	local entity killmonsters = spawn();
	
	killmonsters.think = Genocide;
	killmonsters.nextthink = time;
	
	sound (self, CHAN_AUTO, "dfury/boss_death1.wav", 1, ATTN_NONE);
	
	newmis.think = bossdeath_2;
	newmis.nextthink = time + 7;
	
	self.skin = 0;
	
	self.think = dfury_boss_loop1;
	self.nextthink = time;
	
}

var float autocvar_dfury = 5;     		// set cvar 'dfury' default to 5
var float autocvar_dfurycorpsehealth = 60;	// set cvar 'dfurycorpsehealth' default to 60
//var float autocvar_dfurycorpseburnable = 1;	// set cvar 'dfurycorpseburnable' default to 1

void()	dfury_boss_die1	=[	$death1,	dfury_boss_die2	] {ai_forward(10);self.colormod = '1 1 1';};
void()	dfury_boss_die2	=[	$death2,	dfury_boss_die3	] {ai_forward(8);};
void()	dfury_boss_die3	=[	$death3,	dfury_boss_die4	]
{self.solid = SOLID_NOT; ai_forward(7);};
void()	dfury_boss_die4	=[	$death4,	dfury_boss_die5	] {};
void()	dfury_boss_die5	=[	$death5,	dfury_boss_die6	] {};
void()	dfury_boss_die6	=[	$death6,	dfury_boss_die7	] {};
void()	dfury_boss_die7	=[	$death7,	dfury_boss_die8	] {};
void()	dfury_boss_die8	=[	$death8,	dfury_boss_die9	] {ai_forward(10);};
void()	dfury_boss_die9	=[	$death9,	dfury_boss_die10	] {ai_forward(11); self.think = bossdeath_ef;self.nextthink = time;};
void()	dfury_boss_die10	=[	$death10,	dfury_boss_die11	] {};
void()	dfury_boss_die11	=[	$death11,	dfury_boss_die12	] {};
void()	dfury_boss_die12	=[	$death12,	dfury_boss_die13	] {};
void()	dfury_boss_die13	=[	$death13,	dfury_boss_die14	] {};
void()	dfury_boss_die14	=[	$death14,	dfury_boss_die15	] {sound (self, CHAN_AUTO, "dfury/fall.wav", 1, ATTN_IDLE);};
void()	dfury_boss_die15	=[	$death15,	dfury_boss_die16	] {};
void()	dfury_boss_die16	=[	$death16,	dfury_boss_die17	] {};
void()	dfury_boss_die17	=[	$death17,	dfury_boss_die17	] {
local float zufall, zet, randomness;
	zet = 21;					// z-position of the wings (in relation to soul). Dependent on corpse size.
// 	auto_cvar 'dfurycorpsehealth' has been set to  default = 60  in code above already
	self.delete_painskin = 1;		 	 // remove painskin
if (self.nodeathanim == 1)
	return;
};



void()	dfury_boss_dieb1	=[	$deathb1,	dfury_boss_dieb2	] {self.colormod = '1 1 1';};
void()	dfury_boss_dieb2	=[	$deathb2,	dfury_boss_dieb3	] {};
void()	dfury_boss_dieb3	=[	$deathb3,	dfury_boss_dieb4	]
{self.solid = SOLID_NOT;};
void()	dfury_boss_dieb4	=[	$deathb4,	dfury_boss_dieb5	] {};
void()	dfury_boss_dieb5	=[	$deathb5,	dfury_boss_dieb6	] {};
void()	dfury_boss_dieb6	=[	$deathb6,	dfury_boss_dieb7	] {sound (self, CHAN_AUTO, "dfury/fall.wav", 1, ATTN_IDLE);};
void()	dfury_boss_dieb7	=[	$deathb7,	dfury_boss_dieb8	] {};
void()	dfury_boss_dieb8	=[	$deathb8,	dfury_boss_dieb9	] {Monster_Animation_EarthQuake (20, 377);};
void()	dfury_boss_dieb9	=[	$deathb9,	dfury_boss_dieb10	] {};
void()	dfury_boss_dieb10	=[	$deathb10,	dfury_boss_dieb11	] {};
void()	dfury_boss_dieb11	=[	$deathb11,	dfury_boss_dieb12	] {};
void()	dfury_boss_dieb12	=[	$deathb12,	dfury_boss_dieb13	] {};
void()	dfury_boss_dieb13	=[	$deathb13,	dfury_boss_dieb14	] {};
void()	dfury_boss_dieb14	=[	$deathb14,	dfury_boss_dieb14	] {

local float zufall, zet, randomness;
	zet = 21;					// z-position of the wings (in relation to soul). Dependent on corpse size.
// 	auto_cvar 'dfurycorpsehealth' has been set to  default = 60  in code above already
	self.delete_painskin = 1;		 	 // remove painskin
if (self.nodeathanim == 1)
	return;
};



void(float maxgibs, float gibscounter) producegibs_dfury_boss =	// creates as many gib-sets as defined in cvar 'gibsmultiplier'
{
if (gibscounter >= maxgibs)
	return;
else
	{
	ThrowGib ("progs/gib1.mdl", self.health);
	ThrowGib ("progs/gib_4.mdl", self.health);
	ThrowGib ("progs/gib_5.mdl", self.health);
	ThrowGib ("progs/gib_knfoot_l.mdl", self.health);
	ThrowGib ("progs/gib_knfoot_r.mdl", self.health); 
	ThrowWeapon ("progs/w_dknightsword.mdl", self.health);  	
	}
gibscounter = gibscounter + 1;
producegibs_dfury (maxgibs, gibscounter);
};



void() dfury_boss_die;



void() dfury_boss_die =
{
local float maxgibs, gibscounter;
// check for gib
	/*if (self.health < -40)
	{
		self.delete_painskin = 1;	// remove painskin
		gibbed_monsters = gibbed_monsters + 1;
		self.colormod = '1 1 1';
		if (autocvar_slowmotion >= 1)	// start slowmotion when gibbing living enemies
			{
			if (random () <= (autocvar_slowmotion_randomness_dfury * 0.01))
				{
				the_matrix = 1;
				matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
				}
			}
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		//Comment below section to stop gibsmultiplier from overriding unique gib models
		var float autocvar_gibsmultiplier = 1;         	// set cvar 'gibsmultiplier' default to 1
			/*if (autocvar_gibsmultiplier == 1)		// if 'gibsmultiplier' doesnt exist in autoexec.cfg, or if 'gibsmultiplier' is set via autoexec.cfg to '1'
				{
				if (self.monstermodel == 0)  
					ThrowHead ("progs/h_hellkn.mdl", self.health);
				else if (self.monstermodel == 1)  
					ThrowHead ("progs/h_hellkn1.mdl", self.health);
				ThrowGib ("progs/gib1.mdl", self.health);
				ThrowGib ("progs/gib2.mdl", self.health);
				ThrowGib ("progs/gib3.mdl", self.health);
				if (autocvar_heartgib >= 1)		// if 'heartgib' doesnt exist in autoexec.cfg, or if 'heartgib' is set via autoexec.cfg to '1' or higher
					ThrowHeart ("progs/gibheart.mdl", self.health);
				if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
					pointparticles(particleeffectnum("blood_monster_gib"), self.origin, '0 0 0', 1);
				return;
				}*/
			//else 							// if 'gibsmultiplier' is set via autoexec.cfg to any other value than '1'
				//{						// --> produce more gibs
				/*if (self.monstermodel == 0)  
					ThrowHead ("progs/h_hellkn.mdl", self.health);
				else if (self.monstermodel == 1)  
					ThrowHead ("progs/h_hellkn1.mdl", self.health);
				if (autocvar_heartgib >= 1)		// if 'heartgib' doesnt exist in autoexec.cfg, or if 'heartgib' is set via autoexec.cfg to '1' or higher
					ThrowHeart ("progs/gibheart.mdl", self.health);
				maxgibs = autocvar_gibsmultiplier;
				gibscounter = 0;
				if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
					pointparticles(particleeffectnum("blood_monster_gib"), self.origin, '0 0 0', 1);
				producegibs_dfury (maxgibs, gibscounter);
				return;
				//}
	}*/

// regular death

local float zufall, randomness;
// auto_cvar 'dfury' has been declared in code above already
var float autocvar_dfuryrandomness = 25;     	// set cvar 'dfuryrandomness' default to 25%
autocvar_dfuryrandomness = autocvar_dfuryrandomness * 0.01;
// if 'dfury' has another value is checked inside prior function (= death animation function)

	if (autocvar_slowmotion >= 3)	// start slowmotion when regular killing living enemies
		{
		if (random () <= (autocvar_slowmotion_randomness_dfury * 0.01))
			{
			the_matrix = 1;
			matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
			}
		}
	sound (self, CHAN_VOICE, "dfury/death1.wav", 1, ATTN_NORM);
	
	dfury_boss_die1 ();
		
	//FATALITIES
	/*
	if (self.enemy.meleeing == 0) //check before all fatalities to make sure attack type is not a kick
	{
		if (self.enemy.weapon == IT_SUPER_SHOTGUN)
			{
				if (random() < 0.4)
				{
					if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
						pointparticles(particleeffectnum("blood_corpse_gib"), self.origin, '0 0 0', 1);
					ThrowGib ("progs/chop.mdl", self.health);
					ThrowGib ("progs/chop.mdl", self.health);
					ThrowGib ("progs/chop.mdl", self.health);
					self.delete_painskin = 1;
					if (self.skin == 0)
					{
						setmodel (self, self.model = "progs/dfuryssg.mdl");
						self.skin = 0;
					}
					else
					{
						setmodel (self, self.model = "progs/dfuryssg.mdl");
						self.skin = 1;
					}
					dfury_boss_diessg1();
					ThrowGib ("progs/chop.mdl", self.health);
				}
				else if (random() >= 0.4 && random() <= 0.7) 
				{
				if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
						pointparticles(particleeffectnum("blood_corpse_gib"), self.origin, '0 0 0', 1);
					ThrowGib ("progs/chop.mdl", self.health);
					ThrowGib ("progs/chop.mdl", self.health);
					ThrowGib ("progs/chop.mdl", self.health);
					self.delete_painskin = 1;
					if (self.skin == 0)
					{
						setmodel (self, self.model = "progs/dfuryssgb.mdl");
						self.skin = 0;
					}
					else
					{
						setmodel (self, self.model = "progs/dfuryssgb.mdl");
						self.skin = 1;
					}
					dfury_boss_diessgb1();
					ThrowGib ("progs/chop.mdl", self.health);
				}
				else
				{
				if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
						pointparticles(particleeffectnum("blood_monster_gibsm"), self.origin, '0 0 0', 1);
					
					self.delete_painskin = 1;
					if (self.skin == 0)
					{
						setmodel (self, self.model = "progs/dfuryblast.mdl");
						self.skin = 0;
					}
					else
					{
						setmodel (self, self.model = "progs/dfuryblast.mdl");
						self.skin = 1;
					}
					dfury_boss_die1();
					//ThrowHead ("progs/gib_dfury_boss_head.mdl", self.health);
					ThrowHead ("progs/gib_dfury_boss_torso.mdl", self.health);
					ThrowGib ("progs/gib_dfury_boss_head.mdl", self.health);
					ThrowGib ("progs/gib_dfury_boss_rarm.mdl", self.health);
					ThrowGib ("progs/gib_dfury_boss_larm.mdl", self.health);
					ThrowGib ("progs/gib_knfoot_r.mdl", self.health);
					ThrowGib ("progs/gib_knfoot_l.mdl", self.health);
					sound (self, CHAN_VOICE, "misc/corpsegib.wav", 1, ATTN_IDLE);
					ThrowGib ("progs/chop.mdl", self.health);
				}
			}
		if (self.enemy.weapon == IT_GRENADE_LAUNCHER || self.enemy.weapon == IT_ROCKET_LAUNCHER)
			{
				//if (random() <= 0.7)
				//{
					if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
						pointparticles(particleeffectnum("blood_monster_gibsm"), self.origin, '0 0 0', 1);
						dfury_boss_die1();
					//ThrowHead ("progs/gib_dfury_boss_head.mdl", self.health);
					ThrowHead ("progs/gib_dfury_boss_torso.mdl", self.health);
					ThrowGib ("progs/gib_dfury_boss_head.mdl", self.health);
					ThrowGib ("progs/gib_dfury_boss_rarm.mdl", self.health);
					ThrowGib ("progs/gib_dfury_boss_larm.mdl", self.health);
					ThrowGib ("progs/gib_knfoot_r.mdl", self.health);
					ThrowGib ("progs/gib_knfoot_l.mdl", self.health);
					sound (self, CHAN_VOICE, "player/gib.wav", 1, ATTN_IDLE);
					ThrowGib ("progs/chop.mdl", self.health);
					ThrowGib ("progs/chop.mdl", self.health);
				//}
			}
		if (self.enemy.weapon == IT_SUPER_NAILGUN)
			{
				if (random() <= 0.6)
				{
				if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
						pointparticles(particleeffectnum("blood_corpse_gib"), self.origin, '0 0 0', 1);
					ThrowGib ("progs/chop.mdl", self.health);
					ThrowGib ("progs/chop.mdl", self.health);
					ThrowGib ("progs/chop.mdl", self.health);
					ThrowGib ("progs/gib_dfury_boss_torsoSNG.mdl", self.health);
					ThrowGib ("progs/gib_dfury_boss_headSNG.mdl", self.health);
					ThrowGib ("progs/gib_dfury_boss_rarm.mdl", self.health);
					ThrowGib ("progs/chop.mdl", self.health);
					
					self.delete_painskin = 1;
					if (self.skin == 0)
					{
						setmodel (self, self.model = "progs/dfurySNG.mdl");
						self.skin = 0;
						
					}
					else
					{
						setmodel (self, self.model = "progs/dfurySNG.mdl");
						self.skin = 1;
					}
					dfury_boss_diessgb1();
					//ThrowHead ("progs/gib_dfury_boss_head.mdl", self.health);
			
					//ThrowGib ("progs/chop.mdl", self.health);
					//ThrowGib ("progs/chop.mdl", self.health);
					
					//ThrowGib ("progs/gib_dfury_boss_rarm.mdl", self.health);
					//ThrowGib ("progs/gib_dfury_boss_larm.mdl", self.health);
					//ThrowGib ("progs/gib_knfoot_r.mdl", self.health);
					//ThrowGib ("progs/gib_knfoot_l.mdl", self.health);
					sound (self, CHAN_AUTO, "knight/dropsword.wav", 1, ATTN_IDLE);
					ThrowGib ("progs/w_dknightsword.mdl", self.health); 
					ThrowGib ("progs/chop.mdl", self.health);
				}
				else
				{
				if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
						pointparticles(particleeffectnum("blood_corpse_gib"), self.origin, '0 0 0', 1);
					ThrowGib ("progs/chop.mdl", self.health);
					ThrowGib ("progs/chop.mdl", self.health);
					ThrowGib ("progs/chop.mdl", self.health);
					ThrowGib ("progs/gib_dfury_boss_torso_SNGb.mdl", self.health);
					ThrowGib ("progs/gib_dfury_boss_headSNG.mdl", self.health);
					ThrowGib ("progs/gib_dfury_boss_rarm.mdl", self.health);
					ThrowGib ("progs/chop.mdl", self.health);
					
					self.delete_painskin = 1;
					if (self.skin == 0)
					{
						setmodel (self, self.model = "progs/dfurySNG.mdl");
						self.skin = 0;
						
					}
					else
					{
						setmodel (self, self.model = "progs/dfurySNG.mdl");
						self.skin = 1;
					}
					dfury_boss_diessgb1();
					sound (self, CHAN_VOICE, "misc/corpsegib.wav", 1, ATTN_IDLE);
					sound (self, CHAN_AUTO, "knight/dropsword.wav", 1, ATTN_IDLE);
					ThrowGib ("progs/chop.mdl", self.health);	
				}
			}
	}*/
};



//============================================================================

void()	dfury_boss_magica1 =[	$magica1,	dfury_boss_magica2	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();self.colormod = '1.5 1 1';};
void()	dfury_boss_magica2 =[	$magica2,	dfury_boss_magica3	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();self.colormod = '2 1 1';};
void()	dfury_boss_magica3 =[	$magica3,	dfury_boss_magica4	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();self.colormod = '2.5 1 1';};
void()	dfury_boss_magica4 =[	$magica4,	dfury_boss_magica5	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();self.colormod = '3 1 1';};
void()	dfury_boss_magica5 =[	$magica5,	dfury_boss_magica6	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();self.colormod = '3.5 1 1';};
void()	dfury_boss_magica6 =[	$magica6,	dfury_boss_magica7	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void()	dfury_boss_magica7 =[	$magica7,	dfury_boss_magica8	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);dfury_boss_shot2(-2);};
void()	dfury_boss_magica8 =[	$magica8,	dfury_boss_magica9	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);};
void()	dfury_boss_magica9 =[	$magica9,	dfury_boss_magica10] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);dfury_boss_shot2(0);};
void()	dfury_boss_magica10 =[	$magica10,	dfury_boss_magica11] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);dfury_boss_shot2(1);};
void()	dfury_boss_magica11 =[	$magica11,	dfury_boss_magica12] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);};
void()	dfury_boss_magica12 =[	$magica12,	dfury_boss_magica13] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);dfury_boss_shot2(3);self.colormod = '3 1 1';};
void()	dfury_boss_magica13 =[	$magica13,	dfury_boss_magica14] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();self.colormod = '2 1 1';};
void()	dfury_boss_magica14 =[	$magica14,	dfury_boss_run1	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();self.colormod = '1 1 1';
dfury_boss_random_magic();};

//============================================================================

void()	dfury_boss_magicb1 =[	$magicb1,	dfury_boss_magicb2	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();
self.colormod = '1.5 1 1';};
void()	dfury_boss_magicb2 =[	$magicb2,	dfury_boss_magicb3	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();
self.colormod = '2 1 1';};
void()	dfury_boss_magicb3 =[	$magicb3,	dfury_boss_magicb4	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();
self.colormod = '2.5 1 1';};
void()	dfury_boss_magicb4 =[	$magicb4,	dfury_boss_magicb5	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();
self.colormod = '3 1 1';};
void()	dfury_boss_magicb5 =[	$magicb5,	dfury_boss_magicb6	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();
self.colormod = '3.5 1 1';};
void()	dfury_boss_magicb6 =[	$magicb6,	dfury_boss_magicb7	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void()	dfury_boss_magicb7 =[	$magicb7,	dfury_boss_magicb8	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);dfury_boss_shot(-2);};
void()	dfury_boss_magicb8 =[	$magicb8,	dfury_boss_magicb9	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);dfury_boss_shot(-1);};
void()	dfury_boss_magicb9 =[	$magicb9,	dfury_boss_magicb10] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);dfury_boss_shot(0);};
void()	dfury_boss_magicb10 =[	$magicb10,	dfury_boss_magicb11] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);dfury_boss_shot(1);};
void()	dfury_boss_magicb11 =[	$magicb11,	dfury_boss_magicb12] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);dfury_boss_shot(2);};
void()	dfury_boss_magicb12 =[	$magicb12,	dfury_boss_magicb13] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);dfury_boss_shot(3);
self.colormod = '2 1 1';};
void()	dfury_boss_magicb13 =[	$magicb13,	dfury_boss_run1] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();
self.colormod = '1 1 1';
dfury_boss_random_magic();};

//============================================================================

void()	dfury_boss_magicc1 =[	$magicc1,	dfury_boss_magicc2	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();
self.colormod = '1.5 1 1';};
void()	dfury_boss_magicc2 =[	$magicc2,	dfury_boss_magicc3	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();
self.colormod = '2 1 1';};
void()	dfury_boss_magicc3 =[	$magicc3,	dfury_boss_magicc4	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();
self.colormod = '2.5 1 1';};
void()	dfury_boss_magicc4 =[	$magicc4,	dfury_boss_magicc5	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();
self.colormod = '3 1 1';};
void()	dfury_boss_magicc5 =[	$magicc5,	dfury_boss_magicc6	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();
self.colormod = '3.5 1 1';};
void()	dfury_boss_magicc6 =[	$magicc6,	dfury_boss_magicc7	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);dfury_boss_shot(-3);};
void()	dfury_boss_magicc7 =[	$magicc7,	dfury_boss_magicc8	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);dfury_boss_shot(-1);};
void()	dfury_boss_magicc8 =[	$magicc8,	dfury_boss_magicc9	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);dfury_boss_shot(0);};
void()	dfury_boss_magicc9 =[	$magicc9,	dfury_boss_magicc10] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);dfury_boss_shot(1);};
void()	dfury_boss_magicc10 =[	$magicc10,	dfury_boss_magicc11] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);dfury_boss_shot(3);
self.colormod = '2 1 1';};
void()	dfury_boss_magicc11 =[	$magicc11,	dfury_boss_run1] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);dfury_boss_shot(4);
self.colormod = '1 1 1';
dfury_boss_random_magic();};

void()	dfury_boss_spawn1 =[	$magicb1,	dfury_boss_spawn2	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();
self.colormod = '1.5 1 1';};
void()	dfury_boss_spawn2 =[	$magicb2,	dfury_boss_spawn3	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();
self.colormod = '2 1 1';};
void()	dfury_boss_spawn3 =[	$magicb3,	dfury_boss_spawn4	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();
self.colormod = '2.5 1 1';};
void()	dfury_boss_spawn4 =[	$magicb4,	dfury_boss_spawn5	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();
self.colormod = '3 1 1';};
void()	dfury_boss_spawn5 =[	$magicb5,	dfury_boss_spawn6	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();
self.colormod = '3.5 1 1';};
void()	dfury_boss_spawn6 =[	$magicb6,	dfury_boss_spawn7	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void()	dfury_boss_spawn7 =[	$magicb7,	dfury_boss_spawn8	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);};
void()	dfury_boss_spawn8 =[	$magicb8,	dfury_boss_spawn9	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);};
void()	dfury_boss_spawn9 =[	$magicb9,	dfury_boss_spawn10] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);};
void()	dfury_boss_spawn10 =[	$magicb10,	dfury_boss_spawn11] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);dfury_boss_spawner();};
void()	dfury_boss_spawn11 =[	$magicb11,	dfury_boss_spawn12] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);};
void()	dfury_boss_spawn12 =[	$magicb12,	dfury_boss_spawn13] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);dfury_boss_spawner();
self.colormod = '2 1 1';};
void()	dfury_boss_spawn13 =[	$magicb13,	dfury_boss_run1] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();
self.colormod = '1 1 1';
dfury_boss_random_magic();};

//===========================================================================

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
void()	dfury_boss_char_a16=[	$char_a16,	dfury_boss_run1	] {dfury_boss_footsteps (1);ai_charge(73);};

//===========================================================================

void()	dfury_boss_char_b1	=[	$char_b1,	dfury_boss_char_b2	]
{CheckContinueCharge3 (); ai_charge(23); ai_melee_dfury_boss();self.colormod = '1 1 1';};
void()	dfury_boss_char_b2	=[	$char_b2,	dfury_boss_char_b3	] {ai_charge(72); ai_melee_dfury_boss();dfury_boss_footsteps (1);};
void()	dfury_boss_char_b3	=[	$char_b3,	dfury_boss_char_b4	] {ai_charge(72); ai_melee_dfury_boss();dfury_boss_footsteps (1);};
void()	dfury_boss_char_b4	=[	$char_b4,	dfury_boss_char_b5	] {ai_charge(72); ai_melee_dfury_boss(); dfury_boss_footsteps (0.9);};
void()	dfury_boss_char_b5	=[	$char_b5,	dfury_boss_char_b6	] {ai_charge(78); ai_melee_dfury_boss();dfury_boss_footsteps (1);};
void()	dfury_boss_char_b6	=[	$char_b6,	dfury_boss_char_b1	] {ai_charge(78); ai_melee_dfury_boss();dfury_boss_footsteps (1);};

//===========================================================================

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
void()	dfury_boss_slice14	=[	$slice14,	dfury_boss_run1	] {ai_charge(53);};

//===========================================================================

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

//============================================================================

void()	dfury_boss_watk1	=[	$w_attack1,	dfury_boss_watk2	] {ai_charge(8);self.colormod = '1 1 1';};
void()	dfury_boss_watk2	=[	$w_attack2,	dfury_boss_watk3	] {ai_charge(0);};
void()	dfury_boss_watk3	=[	$w_attack3,	dfury_boss_watk4	] {ai_charge(0);};
void()	dfury_boss_watk4	=[	$w_attack4,	dfury_boss_watk5	] {ai_melee_dfury_boss();};
void()	dfury_boss_watk5	=[	$w_attack5,	dfury_boss_watk6	] {ai_melee_dfury_boss();};
void()	dfury_boss_watk6	=[	$w_attack6,	dfury_boss_watk7	] {ai_melee_dfury_boss();};
void()	dfury_boss_watk7	=[	$w_attack7,	dfury_boss_watk8	] {ai_charge(24);ai_melee_dfury_boss();};
void()	dfury_boss_watk8	=[	$w_attack8,	dfury_boss_watk9	] {ai_charge(30);ai_melee_dfury_boss();};
void()	dfury_boss_watk9	=[	$w_attack9,	dfury_boss_watk10	] {ai_charge(32);};
void()	dfury_boss_watk10	=[	$w_attack10,	dfury_boss_watk11	] {ai_charge(16); ai_melee_dfury_boss();};
void()	dfury_boss_watk11	=[	$w_attack11,	dfury_boss_watk12	] {ai_charge(15); ai_melee_dfury_boss(); dfury_boss_footsteps (0.8);};
void()	dfury_boss_watk12	=[	$w_attack12,	dfury_boss_watk13	] {ai_charge(15); ai_melee_dfury_boss();};
void()	dfury_boss_watk13	=[	$w_attack13,	dfury_boss_watk14	] {ai_charge(0);};
void()	dfury_boss_watk14	=[	$w_attack14,	dfury_boss_watk15	] {ai_charge(0);ai_melee_dfury_boss();};
void()	dfury_boss_watk15	=[	$w_attack15,	dfury_boss_watk16	] {ai_charge(0);ai_melee_dfury_boss();};
void()	dfury_boss_watk16	=[	$w_attack16,	dfury_boss_run1	] {ai_charge(13); dfury_boss_footsteps (0.8);};
/*
void()	dfury_boss_watk17	=[	$w_attack17,	dfury_boss_watk18	] {ai_charge(1); ai_melee_dfury_boss();};
void()	dfury_boss_watk18	=[	$w_attack18,	dfury_boss_watk19	] {ai_charge(3); ai_melee_dfury_boss();};
void()	dfury_boss_watk19	=[	$w_attack19,	dfury_boss_watk20	] {ai_charge(4); ai_melee_dfury_boss();};
void()	dfury_boss_watk20	=[	$w_attack20,	dfury_boss_watk21	] {ai_charge(6);};
void()	dfury_boss_watk21	=[	$w_attack21,	dfury_boss_watk22	] {ai_charge(7);};
void()	dfury_boss_watk22	=[	$w_attack22,	dfury_boss_run1	] {ai_charge(3); dfury_boss_footsteps (0.8);};*/

//============================================================================

void() dfury_boss_idle_sound =
{
	if (random() < 0.2)
		sound (self, CHAN_VOICE, "dfury/idle.wav", 1, ATTN_NORM);
};

void(entity attacker, float damage)	dfury_boss_pain =
{
	if (self.pain_finished > time)
		return;

	sound (self, CHAN_VOICE, "dfury/pain1.wav", 1, ATTN_NORM);

	if (time - self.pain_finished > 5)
	{	// allways go into pain frame if it has been a while
		if (autocvar_slowmotion >= 4)	// start slowmotion when hurting enemies
		{
			if (random () <= (autocvar_slowmotion_randomness_dfury * 0.01))
				{
				the_matrix = 1;
				matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
				}
		}
		dfury_boss_pain1 ();
		self.pain_finished = time + 1;
		return;
	}
	
	if ((random()*30 > damage) )
		return;		// didn't flinch

	if (autocvar_slowmotion >= 4)	// start slowmotion when hurting enemies
	{
		if (random () <= (autocvar_slowmotion_randomness_dfury * 0.01))
			{
			the_matrix = 1;
			matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
			}
	}

	self.pain_finished = time + 1;
	dfury_boss_pain1 ();
};

float	dfury_boss_type;

void() dfury_boss_melee =
{
	dfury_boss_type = dfury_boss_type + 1;

	sound (self, CHAN_WEAPON, "dfury/slash1.wav", 1, ATTN_NORM);
	if (dfury_boss_type == 1)
		dfury_boss_slice1 ();
	else if (dfury_boss_type == 2)
		dfury_boss_smash1 ();
	else if (dfury_boss_type == 3)
	{
		dfury_boss_watk1 ();
		dfury_boss_type = 0;
	}
};

void() dfury_boss_random_magic =		// adds random magic attack animation
{						// in original ID1, only "dfury_boss_magiccxx" is used
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

void()	dfury_boss_JumpTouch =
{
	local	float	ldmg;

	if (self.health <= 0)
		return;
		
	if (other.takedamage)
	{
		if ( vlen(self.velocity) > 100 )
		{
				ldmg = 50 + 10*random();	// default 40
			if (other.classname == "player")
				T_Damage (other, self, self, 40);	
		}
	}

	if (!checkbottom(self))
	{
		self.tail_visible = 0;
		if (self.flags & FL_ONGROUND)
		{	// jump randomly to not get hung up
//dprint ("popjump\n");
	self.touch = SUB_Null;
	 self.think = dfury_boss_jump1;
	self.nextthink = time + 0.1;

//			self.velocity_x = (random() - 0.5) * 600;
//			self.velocity_y = (random() - 0.5) * 600;
//			self.velocity_z = 200;
//			self.flags = self.flags - FL_ONGROUND;
		}
		return;	// not on ground yet
	}

	self.touch = SUB_Null;
	 self.think = dfury_boss_jump11;
	self.nextthink = time + 0.1;
};


void() dfury_boss_pause =
{
	precache_sound ("misc/wallbrk.wav");
	sound ( self, CHAN_AUTO, "misc/wallbrk.wav", 1, ATTN_NONE);

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
	self.think = FoundTarget;
		
	self.delay = 0;
		
};

void() dfury_boss_pause1 =
{
	self.takedamage = DAMAGE_NO;
	self.use = dfury_boss_pause;
	self.think = dfury_boss_pause1;
    self.nextthink = time + 0.1;
    self.skin = 0;
};


/*QUAKED monster_dfury (1 0 0) (-16 -16 -24) (16 16 40) Ambush
*/
void() monster_dfury_boss =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	//precache_model2 ("progs/dfury.mdl");
	precache_model2 ("progs/dfury_boss.mdl");
	precache_model2 ("progs/k_spike.mdl");
	//precache_model2 ("progs/h_hellkn.mdl");
	precache_model ("progs/proj_summon.mdl");

	precache_model ("progs/gib_sBoss.mdl");
	
	precache_sound2 ("dfury/boss_explode.wav");
	precache_sound2 ("dfury/boss_death1.wav");
	precache_sound2 ("dfury/attack1.wav");
	precache_sound2 ("dfury/death1.wav");
	precache_sound2 ("dfury/pain1.wav");
	precache_sound  ("dfury/death2.wav");
	precache_sound  ("dfury/pain2.wav");
	precache_sound2 ("dfury/sight1.wav");
	precache_sound ("dfury/hit.wav");		// used by C code, so don't sound2
	precache_sound2 ("dfury/slash1.wav");
	precache_sound2 ("dfury/idle.wav");
	precache_sound2 ("dfury/grunt.wav");
	precache_sound2 ("dfury/proj.wav");
	precache_sound ("dfury/fall.wav");
	precache_sound ("walk/dfury1.wav");
	precache_sound ("walk/dfury2.wav");
	precache_sound ("walk/dfury3.wav");
	precache_sound ("walk/dfuryboss1.wav");
	precache_sound ("walk/dfuryboss2.wav");
	precache_sound ("walk/dfuryboss3.wav");
	precache_sound ("misc/summon.wav");
	precache_sound ("knight/dropsword.wav");
	
	precache_sound ("knight/sword1.wav");
	precache_sound ("knight/sword2.wav");
	
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

var float autocvar_dfurymultiskin = 0;     	// set cvar 'dfurymultiskin' default to 0
	local float zufall;
	if (autocvar_dfurymultiskin == 1)		// if 'dfurymultiskin' is set via autoexec.cfg to '1' use 2 different skins for ID1 model
	{
		self.multiskin = 1;
		//if (self.spawnflags & 2)
			setmodel (self, "progs/dfury_boss.mdl");
		//else
			//setmodel (self, "progs/dfury.mdl");
		//self.scale = 1;
		zufall = random();
		if (zufall >= 0.5)
			{
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 0;
			}
		else 
			{
			self.skin = 1;
			self.monsterskin = 1;
			self.monstermodel = 0;
			}
	}
	else if (autocvar_dfurymultiskin == 2)	// if 'dfurymultiskin' is set via autoexec.cfg to '2' use 1 Id1 model skin AND external model
	{
		self.multiskin = 2;
		precache_model ("progs/dfury1.mdl");
		precache_model ("progs/h_hellkn1.mdl");
		zufall = random();
		if (zufall >= 0.5)
			{
			//setmodel (self, "progs/dfury.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 0;
			}
		else 
			{
			//setmodel (self, "progs/dfury1.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 1;
			}
	}
	else if (autocvar_dfurymultiskin == 3)	// if 'dfurymultiskin' is set via autoexec.cfg to '3' use 2 Id1 model skins AND external model
	{
		self.multiskin = 3;
		precache_model ("progs/dfury1.mdl");
		precache_model ("progs/h_hellkn1.mdl");
		zufall = random();
		if (zufall > 0.66)
			{
			setmodel (self, "progs/dfury_boss.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 0;
			}
		else if (zufall < 0.34)
			{
			setmodel (self, "progs/dfury_boss.mdl");
			self.skin = 1;
			self.monsterskin = 1;
			self.monstermodel = 0;
			}
		else
			{
			setmodel (self, "progs/dfury1.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 1;
			}
	}
	else if (autocvar_dfurymultiskin == 4)	// if 'dfurymultiskin' is set via autoexec.cfg to '4' use 2 Id1 model skins AND 2 external model skins
	{
		self.multiskin = 4;
		precache_model ("progs/dfury1.mdl");
		precache_model ("progs/h_hellkn1.mdl");
		zufall = random();
		if (zufall > 0.75)
			{
			setmodel (self, "progs/dfury_boss.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 0;
			}
		else if (zufall > 0.5 && zufall <= 0.75)
			{
			setmodel (self, "progs/dfury_boss.mdl");
			self.skin = 1;
			self.monsterskin = 1;
			self.monstermodel = 0;
			}
		else if (zufall > 0.25 && zufall <= 0.5)
			{
			setmodel (self, "progs/dfury1.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 1;
			}
		else 
			{
			setmodel (self, "progs/dfury1.mdl");
			self.skin = 1;
			self.monsterskin = 1;
			self.monstermodel = 1;
			}
	}
	else						// standard Quake
		{
		setmodel (self, "progs/dfury_boss.mdl");
		self.skin = 0;
		self.monsterskin = 0;
		self.monstermodel = 0;
		}


	self.scale = 1;
	setsize (self, '-26 -30 -24', '26 30 100');

	if (skill == 3 || coop)
		self.health = 4700;
	else if (skill == 2)
		self.health = 4300;
	else
		self.health = 3500;			// dfury_boss_health
	self.health_initial = self.health;

	if (autocvar_monster_random_skin_color_alteration && autocvar_dfury_boss_random_skin_colors)	// modify/edit this monster types skin textures randomly (for higher variation in-game)
	{												// limit values to avoid extreme colors
		self.colormod_x = random ();
		if (self.colormod_x < 0.5)
			self.colormod_x = self.colormod_x + 0.5;
		if (autocvar_monster_random_skin_color_alteration == 1)		// only slight changes allowed
		{
			if (self.colormod_x < 0.75)
				self.colormod_x = self.colormod_x + 0.25;
		}
		else if (autocvar_monster_random_skin_color_alteration == 2)	// moderate changes allowed
		{
			if (self.colormod_x < 0.65)
				self.colormod_x = self.colormod_x + 0.25;
		}
		else								// stronger changes allowed
		{
			if (self.colormod_x < 0.55)
				self.colormod_x = self.colormod_x + 0.25;
		}
		self.colormod_y = random ();
		if (self.colormod_y < 0.5)
			self.colormod_y = self.colormod_y + 0.5;
		if (autocvar_monster_random_skin_color_alteration == 1)		// only slight changes allowed
		{
			if (self.colormod_y < 0.75)
				self.colormod_y = self.colormod_y + 0.25;
		}
		else if (autocvar_monster_random_skin_color_alteration == 2)	// moderate changes allowed
		{
			if (self.colormod_y < 0.65)
				self.colormod_y = self.colormod_y + 0.25;
		}
		else								// stronger changes allowed
		{
			if (self.colormod_y < 0.55)
				self.colormod_y = self.colormod_y + 0.25;
		}
		self.colormod_z = random ();
		if (self.colormod_z < 0.5)
			self.colormod_z = self.colormod_z + 0.5;
		if (autocvar_monster_random_skin_color_alteration == 1)		// only slight changes allowed
		{
			if (self.colormod_z < 0.75)
				self.colormod_z = self.colormod_z + 0.25;
		}
		else if (autocvar_monster_random_skin_color_alteration == 2)	// moderate changes allowed
		{
			if (self.colormod_z < 0.65)
				self.colormod_z = self.colormod_z + 0.25;
		}
		else								// stronger changes allowed
		{
			if (self.colormod_z < 0.55)
				self.colormod_z = self.colormod_z + 0.25;
		}
	}
	
	if (self.spawnflags & 2) // statue
	{
		if (self.frame == 0)
			self.frame = 10;
		if (!self.targetname)
		{
			dprint ("statue not targeted\n");
			dprint (self.classname);
			dprint (" at ");
			dprint (vtos(self.origin));
			dprint ("\n");
			return;
		}
					
		self.use = dfury_boss_pause;
		self.th_stand = dfury_boss_pause1;
		self.th_walk = dfury_boss_pause1;
		self.th_run = dfury_boss_pause1;
/*
        self.th_stand = knight_pause1;
        self.th_walk = knight_pause;
		self.th_run = knight_pause;
		self.th_melee = knight_atk1;
		self.th_pain = knight_pause;
		self.th_die = knight_die;
*/
		walkmonster_start ();
	}
	else
	{
	self.th_stand = dfury_boss_stand1;
	self.th_walk = dfury_boss_walk1;
	self.th_run = dfury_boss_run1;
	self.th_melee = dfury_boss_melee;

  	self.th_missile = dfury_boss_random_magic;		// adds random magic attack animation
  //  self.th_missile = dfury_boss_magicc1;		// in original ID1, only "dfury_boss_magiccXX" is used

	self.th_pain = dfury_boss_pain;
	self.th_die = dfury_boss_die;
  
  	self.alpha = autocvar_monstertransparency * 0.01;

	if (autocvar_painskin_transparency)
	{
		entity pain_skin_entity;

		pain_skin_entity = spawn();
		pain_skin_entity.solid = SOLID_NOT;
		pain_skin_entity.movetype = MOVETYPE_NOCLIP;	
		pain_skin_entity.owner = self;
		setmodel (pain_skin_entity,self.model);
		setsize (pain_skin_entity, VEC_HULL2_MIN - self.sizediff, VEC_HULL2_MAX - self.sizediff);	
		setorigin (pain_skin_entity, '0 0 0');
		pain_skin_entity.skin = self.skin;
		pain_skin_entity.colormod_x = self.colormod_x;
		pain_skin_entity.colormod_y = self.colormod_y;
		pain_skin_entity.colormod_z = self.colormod_z;
		pain_skin_entity.monstermodel = self.monstermodel;
		pain_skin_entity.frame = self.frame;	
		pain_skin_entity.alpha = autocvar_painskin_transparency;
		pain_skin_entity.think = pain_skin_entity_think;
		pain_skin_entity.nextthink = time;

		setattachment(pain_skin_entity, self, "test");	
	}

	walkmonster_start ();
	}
//do_the_cloning();

var float autocvar_dfury_boss_mass = 6500;
MonsterPhysics (self, autocvar_dfurymass);

};
