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

void() FuryMissileTouch;
//void() FuryMissile;
//void() FuryHome;
void() dfury_char_a1;
void() dfury_run1;
void() df_idle_sound;
void() dfury_random_magic;		// adds random magic attack animation
					// in original ID1, only "dfury_magiccxx" is used
void()	dfury_JumpTouch;

/*
void(float AttackNumber) dfury_shot2 =
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
	missile.touch = FuryMissileTouch;
	missile.nextthink = time + 0.1;
	missile.think = FuryHome;
	sound (self, CHAN_WEAPON, "dfury/attack1.wav", 1, ATTN_NORM);
	self.attack_finished = time + 2;
};
*/

void(float offset) dfury_shot =
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
	
	if ((autocvar_skill_adjusted_hellknight_projectile_homing) && (skill != 0))
		launch_homing_spikes (org, vec);	// is located in wizard.qc
	else
		launch_enemy_spike (org, vec);
	newmis.classname = "furyspike";
	precache_model ("progs/proj_fury1.mdl");
	setmodel (newmis, "progs/proj_fury1.mdl");
	//setmodel (newmis, "progs/k_spike.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);		
	newmis.velocity = vec*700;
	newmis.avelocity = '300 300 300';
	newmis.touch = FuryMissileTouch;
	sound (self, CHAN_WEAPON, "dfury/attack1.wav", 1, ATTN_NORM);
};


/*
void(float offset) dfury_shot =
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
/*
void() FuryHome =
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
	self.think = FuryHome;	
};
*/

void() FuryMissileTouch =
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


void() CheckForCharge3 =
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
	dfury_char_a1 ();

};

void() CheckContinueCharge3 =
{
	if (time > self.attack_finished)
	{
		SUB_AttackFinished (3);
		dfury_run1 ();
		return;		// done charging
	}
	if (random() > 0.5)
		sound (self, CHAN_WEAPON, "knight/sword2.wav", 1, ATTN_NORM);
	else
		sound (self, CHAN_WEAPON, "knight/sword1.wav", 1, ATTN_NORM);
};

//===========================================================================

void(float loudness) dfury_footsteps =
{
if (autocvar_monsterfootsteps == 1)	// only play monster footsteps sound when cvar is 1
	{
	local float select;
	select = random();
	if (select <= 0.33)
		sound(self, CHAN_AUTO, "walk/dfury1.wav", loudness, ATTN_IDLE);
	else if (select <= 0.66)
		sound(self, CHAN_AUTO, "walk/dfury2.wav", loudness, ATTN_IDLE);
	else 
		sound(self, CHAN_AUTO, "walk/dfury3.wav", loudness, ATTN_IDLE);
	}
};


void()	dfury_stand1	=[	$stand1,	dfury_stand2	] {ai_stand();self.colormod = '1 1 1';};
void()	dfury_stand2	=[	$stand2,	dfury_stand3	] {ai_stand();};
void()	dfury_stand3	=[	$stand3,	dfury_stand4	] {ai_stand();};
void()	dfury_stand4	=[	$stand4,	dfury_stand5	] {ai_stand();};
void()	dfury_stand5	=[	$stand5,	dfury_stand6	] {ai_stand();};
void()	dfury_stand6	=[	$stand6,	dfury_stand7	] {ai_stand();};
void()	dfury_stand7	=[	$stand7,	dfury_stand8	] {ai_stand();};
void()	dfury_stand8	=[	$stand8,	dfury_stand9	] {ai_stand();};
void()	dfury_stand9	=[	$stand9,	dfury_stand1	] {ai_stand();};

//===========================================================================

void()	dfury_walk1	=[	$walk1,		dfury_walk2	] {
df_idle_sound();
ai_walk(2);self.colormod = '1 1 1'; dfury_footsteps (0.8);};
void()	dfury_walk2	=[	$walk2,		dfury_walk3	] {ai_walk(5);};
void()	dfury_walk3	=[	$walk3,		dfury_walk4	] {ai_walk(5);};
void()	dfury_walk4	=[	$walk4,		dfury_walk5	] {ai_walk(4);};
void()	dfury_walk5	=[	$walk5,		dfury_walk6	] {ai_walk(4);};
void()	dfury_walk6	=[	$walk6,		dfury_walk7	] {ai_walk(2);};
void()	dfury_walk7	=[	$walk7,		dfury_walk8	] {ai_walk(2);};
void()	dfury_walk8	=[	$walk8,		dfury_walk9	] {ai_walk(3);};
void()	dfury_walk9	=[	$walk9,		dfury_walk10	] {ai_walk(3);};
void()	dfury_walk10	=[	$walk10,	dfury_walk11	] {ai_walk(4);};
void()	dfury_walk11	=[	$walk11,	dfury_walk12	] {ai_walk(3); dfury_footsteps (0.8);};
void()	dfury_walk12	=[	$walk12,	dfury_walk13	] {ai_walk(4);};
void()	dfury_walk13	=[	$walk13,	dfury_walk14	] {ai_walk(6);};
void()	dfury_walk14	=[	$walk14,	dfury_walk1	] {ai_walk(2);};

//===========================================================================

void()	dfury_run1	=[	$run1,		dfury_run2	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);
df_idle_sound();
ai_run (20); CheckForCharge3 (); self.colormod = '1 1 1';};
void()	dfury_run2	=[	$run2,		dfury_run3	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(35); dfury_footsteps (1);};
void()	dfury_run3	=[	$run3,		dfury_run4	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(28);};
void()	dfury_run4	=[	$run4,		dfury_run5	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(26);};
void()	dfury_run5	=[	$run5,		dfury_run6	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(24);};
void()	dfury_run6	=[	$run6,		dfury_run1	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(23);};

//============================================================================

void()	dfury_pain1	=[	$pain1,		dfury_pain2	] {sound (self, CHAN_VOICE, "dfury/pain1.wav", 1, ATTN_NORM);self.colormod = '1 1 1';};
void()	dfury_pain2	=[	$pain2,		dfury_pain3	] {};
void()	dfury_pain3	=[	$pain3,		dfury_pain4	] {};
void()	dfury_pain4	=[	$pain4,		dfury_pain5	] {};
void()	dfury_pain5	=[	$pain5,		dfury_run1	] {};

//============================================================================

void()	dfury_jump1	=[	$lunge1,		dfury_jump2	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();self.tail_visible = 0;};
void()	dfury_jump2	=[	$lunge2,		dfury_jump3	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void()	dfury_jump3	=[	$lunge3,		dfury_jump4	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void()	dfury_jump4	=[	$lunge4,		dfury_jump5	]
{
	self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001); ai_face();
	self.tail_visible = 1;
	self.touch = dfury_JumpTouch;
	makevectors (self.angles);
	self.origin_z = self.origin_z + 1;
	self.velocity = v_forward * 800 + '0 0 250';
	if (self.flags & FL_ONGROUND)
		self.flags = self.flags - FL_ONGROUND;
};
void()	dfury_jump5	=[	$lunge5,		dfury_jump6	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);};
void()	dfury_jump6	=[	$lunge6,		dfury_jump7	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);};
void()	dfury_jump7	=[	$lunge7,		dfury_jump8	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);};
void()	dfury_jump8	=[ 	$lunge8,		dfury_jump9	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);};
void()	dfury_jump9	=[ 	$lunge9,		dfury_jump10	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);};
void()	dfury_jump10	=[ 	$lunge10,	dfury_jump1	] {
self.nextthink = time + 0.7;
// if 0.7 second pass, assume dfury is stuck and jump again
};

void()	dfury_jump11	=[ 	$lunge11,	dfury_jump12	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);self.tail_visible = 0;};
void()	dfury_jump12	=[ 	$lunge12,	dfury_run1	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);};



//=============================================================================


void() dfury_dieburn1	=[	$deathb1,	dfury_dieburn2	] {self.burnz_origin = 12;
burn_toggle_allround();
};
void() dfury_dieburn2	=[	$deathb2,	dfury_dieburn3	] {self.burnz_origin = 10;
};
void() dfury_dieburn3	=[	$deathb3,	dfury_dieburn4	] {self.burnz_origin = 6;
self.solid = SOLID_NOT;
};
void() dfury_dieburn4	=[	$deathb4,	dfury_dieburn5	] {self.burnz_origin = 3;
};
void() dfury_dieburn5	=[	$deathb5,	dfury_dieburn6	] {self.burnz_origin = 0;
};
void() dfury_dieburn6	=[	$deathb6,	dfury_dieburn7	] {self.burnz_origin = -2;
};
void() dfury_dieburn7	=[	$deathb7,	dfury_dieburn8	] {self.burnz_origin = -4;
};
void() dfury_dieburn8	=[	$deathb8,	dfury_dieburn9	] {self.burnz_origin = -6;
};
void() dfury_dieburn9	=[	$deathb9,	dfury_dieburn9	] {self.burnz_origin = -8;
};


var float autocvar_dfury = 5;     		// set cvar 'dfury' default to 5
var float autocvar_dfurycorpsehealth = 60;	// set cvar 'dfurycorpsehealth' default to 60
var float autocvar_dfurycorpseburnable = 1;	// set cvar 'dfurycorpseburnable' default to 1

void()	dfury_die1	=[	$death1,	dfury_die2	] {ai_forward(10);self.colormod = '1 1 1';};
void()	dfury_die2	=[	$death2,	dfury_die3	] {ai_forward(8);};
void()	dfury_die3	=[	$death3,	dfury_die4	]
{self.solid = SOLID_NOT; ai_forward(7);};
void()	dfury_die4	=[	$death4,	dfury_die5	] {};
void()	dfury_die5	=[	$death5,	dfury_die6	] {};
void()	dfury_die6	=[	$death6,	dfury_die7	] {};
void()	dfury_die7	=[	$death7,	dfury_die8	] {};
void()	dfury_die8	=[	$death8,	dfury_die9	] {ai_forward(10);};
void()	dfury_die9	=[	$death9,	dfury_die10	] {ai_forward(11);};
void()	dfury_die10	=[	$death10,	dfury_die11	] {};
void()	dfury_die11	=[	$death11,	dfury_die12	] {};
void()	dfury_die12	=[	$death12,	dfury_die13	] {};
void()	dfury_die13	=[	$death13,	dfury_die14	] {};
void()	dfury_die14	=[	$death14,	dfury_die15	] {sound (self, CHAN_AUTO, "hknight/fall.wav", 1, ATTN_IDLE);};
void()	dfury_die15	=[	$death15,	dfury_die16	] {};
void()	dfury_die16	=[	$death16,	dfury_die17	] {};
void()	dfury_die17	=[	$death17,	dfury_die17	] {
if (self.inflamed == 1)
{
	inflamed_die ();
	return;
}
local float zufall, zet, randomness;
	zet = 21;					// z-position of the wings (in relation to soul). Dependent on corpse size.
	if (autocvar_dfurycorpseburnable == 1)	// corpses are burnable
		self.burnable_corpse = 1;
// 	auto_cvar 'dfurycorpsehealth' has been set to  default = 60  in code above already
	self.delete_painskin = 1;		 	 // remove painskin
	if (self.monstermodel == 0)  
		CopyMonsterToBodyQue(autocvar_dfurycorpsehealth, "progs/h_hellkn.mdl");
	if (self.monstermodel == 1)  
		CopyMonsterToBodyQue(autocvar_dfurycorpsehealth, "progs/h_hellkn1.mdl");
if (self.nodeathanim == 1)
	return;
if (self.grimrock_helper == 0)
{
// 	auto_cvar 'dfury' has been declared in code above already
	var float autocvar_dfuryrandomness = 25;     	// set cvar 'dfuryrandomness' default to 25%
	autocvar_dfuryrandomness = autocvar_dfuryrandomness * 0.01;
	if (autocvar_dfury == 1)		// if 'dfury' is set via autoexec.cfg to '1' start ghost effect
		{
		randomness = random();
		if (randomness <= autocvar_dfuryrandomness)	// checks if death animation shall be started
			ghost_die ();
		}
	else if (autocvar_dfury == 2)	// if 'dfury' is set via autoexec.cfg to '2' start soul effect
		{
		randomness = random();
		if (randomness <= autocvar_dfuryrandomness)	// checks if death animation shall be started
			{
			if (self.monstermodel == 0)  
				soul ("progs/dfury.mdl", $death12, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
			else if (self.monstermodel == 1)  
				soul ("progs/dfury1.mdl", $death12, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
			}
		}
	else if (autocvar_dfury == 3)	// if 'dfury' is set via autoexec.cfg to '3' start vengeance effect
		{
		randomness = random();
		if (randomness <= autocvar_dfuryrandomness)	// checks if death animation shall be started
			vengeance_dfury ("progs/dfury.mdl", $death12); 
		}
	else if (autocvar_dfury == 5)		// if 'dfury' is set via autoexec.cfg to '5' start randomly one of these Death animations: 
		{				// (Ancient ghosts of the fallen ; Relieved souls of the enslaved ; Vengeance of the deceased)
		randomness = random();		// chance for effects (approx.): 36% / 26% / 38%
		if (randomness <= autocvar_dfuryrandomness)	// checks if death animation shall be started --> depending on monsters _randomness
			{					
			zufall = random();
			if (zufall > 0.64)
				ghost_die ();
			else if (zufall < 0.26)
				{
				if (self.monstermodel == 0)  
					soul ("progs/dfury.mdl", $death12, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
				else if (self.monstermodel == 1)  
					soul ("progs/dfury1.mdl", $death12, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
				}
			else
				vengeance_dfury ("progs/dfury.mdl", $death12);
			}
		}
	else				// if 'dfury' is set via autoexec.cfg to another value (example '0'), do nothing !
	{
	}
}
else if (self.grimrock_helper == 1)	// this new code is the the ending of cvar value "6" (which was started in monsters _die function)
	{
	zufall = random();
	if (zufall > 0.64)
		ghost_die ();
	else if (zufall < 0.26)
		{
		if (self.monstermodel == 0)  
			soul ("progs/dfury.mdl", $death12, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
		else if (self.monstermodel == 1)  
			soul ("progs/dfury1.mdl", $death12, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
		}
	else
		vengeance_dfury ("progs/dfury.mdl", $death12);
	}
};

void()	dfury_diessg1	=[	$ssgdeth1,	dfury_diessg2	] {};
void()	dfury_diessg2	=[	$ssgdeth2,	dfury_diessg3	] {sound (self, CHAN_VOICE, "player/gibsplit.wav", 1, ATTN_IDLE);};
void()	dfury_diessg3	=[	$ssgdeth3,	dfury_diessg4	] {ai_forward(8);};
void()	dfury_diessg4	=[	$ssgdeth4,	dfury_diessg5	] {sound (self, CHAN_AUTO, "misc/paste.wav", 1, ATTN_IDLE);};
void()	dfury_diessg5	=[	$ssgdeth5,	dfury_diessg6	] {pointparticles(particleeffectnum("blood_spurt"), self.origin, '0 0 0', 1);};
void()	dfury_diessg6	=[	$ssgdeth6,	dfury_diessg7	] {pointparticles(particleeffectnum("blood_spurt"), self.origin, '0 0 0', 1);};
void()	dfury_diessg7	=[	$ssgdeth7,	dfury_diessg8	] {sound (self, CHAN_AUTO, "misc/paste.wav", 1, ATTN_IDLE);};
void()	dfury_diessg8	=[	$ssgdeth8,	dfury_diessg9	] {ai_forward(8);pointparticles(particleeffectnum("blood_spurt"), self.origin, '0 0 0', 1);};
void()	dfury_diessg9	=[	$ssgdeth9,	dfury_diessg10] {pointparticles(particleeffectnum("blood_spurt"), self.origin, '0 0 0', 1);};
void()	dfury_diessg10=[	$ssgdeth10,	dfury_diessg11] {};
void()	dfury_diessg11=[	$ssgdeth11,	dfury_diessg12] {};
void()	dfury_diessg12=[	$ssgdeth12,	dfury_diessg13] {sound (self, CHAN_AUTO, "misc/paste.wav", 1, ATTN_IDLE);};
void()	dfury_diessg13=[	$ssgdeth13,	dfury_diessg14] {ai_forward(8);pointparticles(particleeffectnum("blood_spurt"), self.origin, '0 0 0', 1);};
void()	dfury_diessg14=[	$ssgdeth14,	dfury_diessg15] {};
void()	dfury_diessg15=[	$ssgdeth15,	dfury_diessg16] {pointparticles(particleeffectnum("blood_spurt"), self.origin, '0 0 0', 1);};
void()	dfury_diessg16=[	$ssgdeth16,	dfury_diessg17] {};
void()	dfury_diessg17=[	$ssgdeth17,	dfury_diessg18] {pointparticles(particleeffectnum("blood_spurt"), self.origin, '0 0 0', 1);};
void()	dfury_diessg18=[	$ssgdeth18,	dfury_diessg19] {};
void()	dfury_diessg19=[	$ssgdeth19,	dfury_diessg20] {};
void()	dfury_diessg20=[	$ssgdeth20,	dfury_diessg21] {};
void()	dfury_diessg21=[	$ssgdeth21,	dfury_diessg22] {self.solid = SOLID_NOT;};
void()	dfury_diessg22=[	$ssgdeth22,	dfury_diessg23] {};
void()	dfury_diessg23=[	$ssgdeth23,	dfury_diessg24] {};
void()	dfury_diessg24=[	$ssgdeth24,	dfury_diessg25] {sound (self, CHAN_AUTO, "dfury/fall.wav", 1, ATTN_IDLE);};
void()	dfury_diessg25=[	$ssgdeth25,	dfury_diessg26] {pointparticles(particleeffectnum("blood_spurt"), self.origin, '0 0 0', 1);};
void()	dfury_diessg26=[	$ssgdeth26,	dfury_diessg27] {};
void()	dfury_diessg27=[	$ssgdeth27,	dfury_diessg28] {};
void()	dfury_diessg28=[	$ssgdeth28,	dfury_diessg28] {};

void()	dfury_diessgb1	=[	$ssgdethb1,	dfury_diessgb2	] {};
void()	dfury_diessgb2	=[	$ssgdethb2,	dfury_diessgb3	] {sound (self, CHAN_VOICE, "player/gibsplit.wav", 1, ATTN_IDLE);if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
						pointparticles(particleeffectnum("blood_blast"), self.origin, '0 0 0', 1);};
void()	dfury_diessgb3	=[	$ssgdethb3,	dfury_diessgb4	] {};
void()	dfury_diessgb4	=[	$ssgdethb4,	dfury_diessgb5	] {self.solid = SOLID_NOT; sound (self, CHAN_AUTO, "misc/paste.wav", 1, ATTN_IDLE);};
void()	dfury_diessgb5	=[	$ssgdethb5,	dfury_diessgb6	] {pointparticles(particleeffectnum("blood_spurt"), self.origin, '0 0 0', 1);};
void()	dfury_diessgb6	=[	$ssgdethb6,	dfury_diessgb7	] {pointparticles(particleeffectnum("blood_spurt"), self.origin, '0 0 0', 1);};
void()	dfury_diessgb7	=[	$ssgdethb7,	dfury_diessgb8	] {sound (self, CHAN_AUTO, "misc/paste.wav", 1, ATTN_IDLE);};
void()	dfury_diessgb8	=[	$ssgdethb8,	dfury_diessgb9	] {ai_forward(8);pointparticles(particleeffectnum("blood_spurt"), self.origin, '0 0 0', 1);};
void()	dfury_diessgb9	=[	$ssgdethb9,	dfury_diessgb10	] {pointparticles(particleeffectnum("blood_spurt"), self.origin, '0 0 0', 1);};
void()	dfury_diessgb10	=[	$ssgdethb10,	dfury_diessgb11	] {};
void()	dfury_diessgb11	=[	$ssgdethb11,	dfury_diessgb12	] {};
void()	dfury_diessgb12	=[	$ssgdethb12,	dfury_diessgb12	] {};


void()	dfury_dieb1	=[	$deathb1,	dfury_dieb2	] {self.colormod = '1 1 1';};
void()	dfury_dieb2	=[	$deathb2,	dfury_dieb3	] {};
void()	dfury_dieb3	=[	$deathb3,	dfury_dieb4	]
{self.solid = SOLID_NOT;};
void()	dfury_dieb4	=[	$deathb4,	dfury_dieb5	] {};
void()	dfury_dieb5	=[	$deathb5,	dfury_dieb6	] {};
void()	dfury_dieb6	=[	$deathb6,	dfury_dieb7	] {sound (self, CHAN_AUTO, "dfury/fall.wav", 1, ATTN_IDLE);};
void()	dfury_dieb7	=[	$deathb7,	dfury_dieb8	] {};
void()	dfury_dieb8	=[	$deathb8,	dfury_dieb9	] {};
void()	dfury_dieb9	=[	$deathb9,	dfury_dieb10	] {};
void()	dfury_dieb10	=[	$deathb10,	dfury_dieb11	] {};
void()	dfury_dieb11	=[	$deathb11,	dfury_dieb12	] {};
void()	dfury_dieb12	=[	$deathb12,	dfury_dieb13	] {};
void()	dfury_dieb13	=[	$deathb13,	dfury_dieb14	] {};
void()	dfury_dieb14	=[	$deathb14,	dfury_dieb14	] {
if (self.inflamed == 1)
{
	inflamed_die ();
	return;
}
local float zufall, zet, randomness;
	zet = 21;					// z-position of the wings (in relation to soul). Dependent on corpse size.
	if (autocvar_dfurycorpseburnable == 1)	// corpses are burnable
		self.burnable_corpse = 1;
// 	auto_cvar 'dfurycorpsehealth' has been set to  default = 60  in code above already
	self.delete_painskin = 1;		 	 // remove painskin
	if (self.monstermodel == 0)  
		CopyMonsterToBodyQue(autocvar_dfurycorpsehealth, "progs/h_hellkn.mdl");
	if (self.monstermodel == 1)  
		CopyMonsterToBodyQue(autocvar_dfurycorpsehealth, "progs/h_hellkn1.mdl");
if (self.nodeathanim == 1)
	return;
if (self.grimrock_helper == 0)
{
// 	auto_cvar 'dfury' has been declared in code above already
	var float autocvar_dfuryrandomness = 25;     	// set cvar 'dfuryrandomness' default to 25%
	autocvar_dfuryrandomness = autocvar_dfuryrandomness * 0.01;
	if (autocvar_dfury == 1)		// if 'dfury' is set via autoexec.cfg to '1' start ghost effect
		{
		randomness = random();
		if (randomness <= autocvar_dfuryrandomness)	// checks if death animation shall be started
			ghost_die ();
		}
	else if (autocvar_dfury == 2)	// if 'dfury' is set via autoexec.cfg to '2' start soul effect
		{
		randomness = random();
		if (randomness <= autocvar_dfuryrandomness)	// checks if death animation shall be started
			{
			if (self.monstermodel == 0)  
				soul ("progs/dfury.mdl", $deathb9, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
			else if (self.monstermodel == 1)  
				soul ("progs/dfury1.mdl", $deathb9, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
			}
		}
	else if (autocvar_dfury == 3)	// if 'dfury' is set via autoexec.cfg to '3' start vengeance effect
		{
		randomness = random();
		if (randomness <= autocvar_dfuryrandomness)	// checks if death animation shall be started
			vengeance_dfury ("progs/dfury.mdl", $deathb9); 
		}
	else if (autocvar_dfury == 5)		// if 'dfury' is set via autoexec.cfg to '5' start randomly one of these Death animations: 
		{				// (Ancient ghosts of the fallen ; Relieved souls of the enslaved ; Vengeance of the deceased)
		randomness = random();		// chance for effects (approx.): 36% / 26% / 38%
		if (randomness <= autocvar_dfuryrandomness)	// checks if death animation shall be started --> depending on monsters _randomness
			{					
			zufall = random();
			if (zufall > 0.64)
				ghost_die ();
			else if (zufall < 0.26)
				{
				if (self.monstermodel == 0)  
					soul ("progs/dfury.mdl", $deathb9, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
				else if (self.monstermodel == 1)  
					soul ("progs/dfury1.mdl", $deathb9, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
				}
			else
				vengeance_dfury ("progs/dfury.mdl", $deathb9);
			}
		}
	else				// if 'dfury' is set via autoexec.cfg to another value (example '0'), do nothing !
	{
	}
}
else if (self.grimrock_helper == 1)	// this new code is the the ending of cvar value "6" (which was started in monsters _die function)
	{
	zufall = random();
	if (zufall > 0.64)
		ghost_die ();
	else if (zufall < 0.26)
		{
		if (self.monstermodel == 0)  
			soul ("progs/dfury.mdl", $deathb9, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
		else if (self.monstermodel == 1)  
			soul ("progs/dfury1.mdl", $deathb9, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
		}
	else
		vengeance_dfury ("progs/dfury.mdl", $deathb9);
	}
};



void(float maxgibs, float gibscounter) producegibs_dfury =	// creates as many gib-sets as defined in cvar 'gibsmultiplier'
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


void()	dfury_lightning_death	=[	$death1,	dfury_lightning_death1	] {
self.delete_painskin = 1;			  // remove painskin
if (autocvar_lightninggun_death_animation == 2)	  // start the "fade" effect instead of "coal" effect
	lightninggun_death_fade();
};

void()	dfury_lightning_death1 =[	$death1,	dfury_lightning_death1	] {
self.solid = SOLID_NOT;
self.baked = 1;
self.colormod = '0.25 0.22 0.22';	// skins gets darker (looks burned)
if (self.monstermodel == 0)  
	CopyMonsterToBodyQue(1, "progs/h_hellkn.mdl");
if (self.monstermodel == 1)  
	CopyMonsterToBodyQue(1, "progs/h_hellkn1.mdl");
};


void() dfury_die;
void() dfury_inflamed9;

void()	dfury_inflamed1 =[	$run1,	dfury_inflamed2] {ai_run_inflamed (20); self.nextthink = time + 0.09;
local float r;
r = random();
if (r < 0.3)
	sound (self, CHAN_VOICE, "dfury/grunt.wav", 1, ATTN_NORM);
else if (r < 0.82)
	sound (self, CHAN_VOICE, "dfury/pain2.wav", 1, ATTN_NORM);
};
void()	dfury_inflamed2 =[	$run2,	dfury_inflamed3] {ai_run_inflamed(25); dfury_footsteps (1); self.nextthink = time + 0.09;};
void()	dfury_inflamed3 =[	$run3,	dfury_inflamed4] {ai_run_inflamed(18); self.nextthink = time + 0.09;};
void()	dfury_inflamed4 =[	$run4,	dfury_inflamed5] {ai_run_inflamed(16); self.nextthink = time + 0.09;};
void()	dfury_inflamed5 =[	$run5,	dfury_inflamed6] {ai_run_inflamed(14); self.nextthink = time + 0.09;};
void()	dfury_inflamed6 =[	$run6,	dfury_inflamed7] {ai_run_inflamed(25); dfury_footsteps (0.8); self.nextthink = time + 0.09;};
void()	dfury_inflamed7 =[	$run7,	dfury_inflamed8] {ai_run_inflamed(21); self.nextthink = time + 0.09;
if (self.inflametime < time)
{
	dfury_die ();
	return;
}
if (random() < 0.5)
	dfury_inflamed9 ();	// start pain anim
};
void()	dfury_inflamed8 =[	$run8,	dfury_inflamed1] {ai_run_inflamed(13); self.nextthink = time + 0.09;};

void()	dfury_inflamed9 =[	$pain1,	dfury_inflamed10 ] { self.nextthink = time + 0.09;
local float r;
r = random();
if (r < 0.3)
	sound (self, CHAN_VOICE, "dfury/grunt.wav", 1, ATTN_NORM);
else if (r < 0.82)
	sound (self, CHAN_VOICE, "dfury/pain2.wav", 1, ATTN_NORM);
};
void()	dfury_inflamed10 =[	$pain2,	dfury_inflamed11 ] { self.nextthink = time + 0.09;};
void()	dfury_inflamed11 =[	$pain3,	dfury_inflamed12 ] { self.nextthink = time + 0.09;};
void()	dfury_inflamed12 =[	$pain4,	dfury_inflamed13 ] { self.nextthink = time + 0.09;};
void()	dfury_inflamed13 =[	$pain5,	dfury_inflamed8 ] { self.nextthink = time + 0.09;
if (self.inflametime < time)
{
	dfury_die ();
	return;
}
};




void() dfury_die =
{
	if (autocvar_lightninggun_death_animation)		// if 'lightninggun_death_animation' is enabled
	{
		if (self.enemy.weapon == IT_LIGHTNING && (self.enemy.meleeing == 0))	// when enemy was killed with lightning gun, go into baked mode
		{
			dfury_lightning_death();
			return;
		}
	}
local float maxgibs, gibscounter;
// check for gib
	if (self.health < -40)
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
		play_gibsound();
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
				if (self.monstermodel == 0)  
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
	}

	if (autocvar_burning_monsters_death_animation)		// if 'burning_monsters_death_animation' is enabled
	{
		if (self.inflamed == 0)		// enemy is not burning
		{
			local float zufa;
			zufa = random() * 100;
			if (((self.enemy.weapon == IT_GRENADE_LAUNCHER) || (self.enemy.weapon == IT_ROCKET_LAUNCHER)) && (zufa <= autocvar_burning_monsters_death_animation) && (self.watertype != CONTENT_WATER) && (self.enemy.meleeing == 0))	// when enemy was killed with explosives, set it on fire
			{
				self.delete_painskin = 1;	// remove painskin
				self.inflamed = 1;
				self.traileffectnum = particleeffectnum("burning_monster");
				self.inflametime = time + autocvar_burning_monsters_death_animation_time + random();
				dfury_inflamed1 ();
				return;
			}
		}
		else		// enemy is burning already and his "run-around-in-panic-time" has just ended
		{
			sound (self, CHAN_VOICE, "dfury/death2.wav", 1, ATTN_NORM);
			if (random() > 0.5)
				dfury_die1 ();
			else
				dfury_dieb1 ();
			return;
		}
	}

// regular death

local float zufall, randomness;
// auto_cvar 'dfury' has been declared in code above already
var float autocvar_dfuryrandomness = 25;     	// set cvar 'dfuryrandomness' default to 25%
autocvar_dfuryrandomness = autocvar_dfuryrandomness * 0.01;
if (autocvar_dfury == 4)		// if 'dfury' is set via autoexec.cfg to '4' start Death animation with "Legend of Grimrock" effect
	{
	randomness = random();
	if (randomness <= autocvar_dfuryrandomness)	// checks if death animation shall be started
		{
		//Gyro_Object_ClearPhysics(self);	// ENABLE this line if you want to disable GYRO during new "Legend of Grimrock" animation !!
		self.delete_painskin = 1;		// remove painskin
		dfury_dieburn1();
		return;			// jump out of this function !!
		}
	}
if (autocvar_dfury == 6)		// if 'dfury' is set via autoexec.cfg to '6' start random Death animation (all 4 effects !!)
	{				// chance for effects (approx.): 25% / 25% / 25% / 25%  
	randomness = random();
	if (randomness <= autocvar_dfuryrandomness)	// checks if death animation shall be started --> depending on monsters _randomness
		{					
		zufall = random();
		if (zufall <= 0.26)
			{
			//Gyro_Object_ClearPhysics(self);   // ENABLE this line if you want to disable GYRO during new "Legend of Grimrock" animation !!
			self.delete_painskin = 1;	    // remove painskin
			dfury_dieburn1();
			return;		// jump out of this function !!
			}		// if zufall is bigger than 0.26, use new code inside  upcoming function  for other 3 death animations
		else 
			self.grimrock_helper = 1;	// this float helps me to manipulate the other 3 death animations
		}
	else
		self.grimrock_helper = 2;	// this float helps me to manipulate the other 3 death animations
	}

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
	if (random() > 0.5)
		dfury_die1 ();
	else
		dfury_dieb1 ();
		
	
};



//============================================================================

void()	dfury_magica1 =[	$magica1,	dfury_magica2	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();self.colormod = '1.5 1 1';};
void()	dfury_magica2 =[	$magica2,	dfury_magica3	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();self.colormod = '2 1 1';};
void()	dfury_magica3 =[	$magica3,	dfury_magica4	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();self.colormod = '2.5 1 1';};
void()	dfury_magica4 =[	$magica4,	dfury_magica5	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();self.colormod = '3 1 1';};
void()	dfury_magica5 =[	$magica5,	dfury_magica6	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();self.colormod = '3.5 1 1';};
void()	dfury_magica6 =[	$magica6,	dfury_magica7	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void()	dfury_magica7 =[	$magica7,	dfury_magica8	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);};
void()	dfury_magica8 =[	$magica8,	dfury_magica9	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);};
void()	dfury_magica9 =[	$magica9,	dfury_magica10] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);dfury_shot(-2);dfury_shot(0);dfury_shot(2);};
void()	dfury_magica10 =[	$magica10,	dfury_magica11] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);};
void()	dfury_magica11 =[	$magica11,	dfury_magica12] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);};
void()	dfury_magica12 =[	$magica12,	dfury_magica13] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);self.colormod = '3 1 1';};
void()	dfury_magica13 =[	$magica13,	dfury_magica14] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();self.colormod = '2 1 1';};
void()	dfury_magica14 =[	$magica14,	dfury_run1	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();self.colormod = '1 1 1';
dfury_random_magic();};

//============================================================================

void()	dfury_magicb1 =[	$magicb1,	dfury_magicb2	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();
self.colormod = '1.5 1 1';};
void()	dfury_magicb2 =[	$magicb2,	dfury_magicb3	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();
self.colormod = '2 1 1';};
void()	dfury_magicb3 =[	$magicb3,	dfury_magicb4	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();
self.colormod = '2.5 1 1';};
void()	dfury_magicb4 =[	$magicb4,	dfury_magicb5	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();
self.colormod = '3 1 1';};
void()	dfury_magicb5 =[	$magicb5,	dfury_magicb6	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();
self.colormod = '3.5 1 1';};
void()	dfury_magicb6 =[	$magicb6,	dfury_magicb7	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void()	dfury_magicb7 =[	$magicb7,	dfury_magicb8	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);};
void()	dfury_magicb8 =[	$magicb8,	dfury_magicb9	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);};
void()	dfury_magicb9 =[	$magicb9,	dfury_magicb10] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);dfury_shot(-1);dfury_shot(0);dfury_shot(1);};
void()	dfury_magicb10 =[	$magicb10,	dfury_magicb11] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);};
void()	dfury_magicb11 =[	$magicb11,	dfury_magicb12] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);};
void()	dfury_magicb12 =[	$magicb12,	dfury_magicb13] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);
self.colormod = '2 1 1';};
void()	dfury_magicb13 =[	$magicb13,	dfury_run1] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();
self.colormod = '1 1 1';
dfury_random_magic();};

//============================================================================

void()	dfury_magicc1 =[	$magicc1,	dfury_magicc2	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();
self.colormod = '1.5 1 1';};
void()	dfury_magicc2 =[	$magicc2,	dfury_magicc3	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();
self.colormod = '2 1 1';};
void()	dfury_magicc3 =[	$magicc3,	dfury_magicc4	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();
self.colormod = '2.5 1 1';};
void()	dfury_magicc4 =[	$magicc4,	dfury_magicc5	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();
self.colormod = '3 1 1';};
void()	dfury_magicc5 =[	$magicc5,	dfury_magicc6	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();
self.colormod = '3.5 1 1';};
void()	dfury_magicc6 =[	$magicc6,	dfury_magicc7	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);};
void()	dfury_magicc7 =[	$magicc7,	dfury_magicc8	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);};
void()	dfury_magicc8 =[	$magicc8,	dfury_magicc9	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);dfury_shot(-3);dfury_shot(-1);dfury_shot(1);dfury_shot(3);};
void()	dfury_magicc9 =[	$magicc9,	dfury_magicc10] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);};
void()	dfury_magicc10 =[	$magicc10,	dfury_magicc11] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);
self.colormod = '2 1 1';};
void()	dfury_magicc11 =[	$magicc11,	dfury_run1] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);
self.colormod = '1 1 1';
dfury_random_magic();};

//===========================================================================

void()	dfury_char_a1	=[	$char_a1,	dfury_char_a2	] {ai_charge(30);self.colormod = '1 1 1';};
void()	dfury_char_a2	=[	$char_a2,	dfury_char_a3	] {ai_charge(35); dfury_footsteps (0.9);};
void()	dfury_char_a3	=[	$char_a3,	dfury_char_a4	] {ai_charge(28);if (random() > .3) dfury_jump1();};
void()	dfury_char_a4	=[	$char_a4,	dfury_char_a5	] {ai_charge(26);};
void()	dfury_char_a5	=[	$char_a5,	dfury_char_a6	] {ai_charge(24);};
void()	dfury_char_a6	=[	$char_a6,	dfury_char_a7	] {ai_charge(30); ai_melee_dfury(); dfury_footsteps (0.9);};
void()	dfury_char_a7	=[	$char_a7,	dfury_char_a8	] {ai_charge(31); ai_melee_dfury();};
void()	dfury_char_a8	=[	$char_a8,	dfury_char_a9	] {ai_charge(33); ai_melee_dfury();};
void()	dfury_char_a9	=[	$char_a9,	dfury_char_a10	] {ai_charge(30); ai_melee_dfury(); dfury_footsteps (0.9);};
void()	dfury_char_a10=[	$char_a10,	dfury_char_a11	] {ai_charge(30); ai_melee_dfury();};
void()	dfury_char_a11=[	$char_a11,	dfury_char_a12	] {ai_charge(28); ai_melee_dfury();};
void()	dfury_char_a12=[	$char_a12,	dfury_char_a13	] {ai_charge(26);};
void()	dfury_char_a13=[	$char_a13,	dfury_char_a14	] {ai_charge(24); dfury_footsteps (0.9);};
void()	dfury_char_a14=[	$char_a14,	dfury_char_a15	] {ai_charge(35);};
void()	dfury_char_a15=[	$char_a15,	dfury_char_a16	] {ai_charge(31);};
void()	dfury_char_a16=[	$char_a16,	dfury_run1	] {ai_charge(23);};

//===========================================================================

void()	dfury_char_b1	=[	$char_b1,	dfury_char_b2	]
{CheckContinueCharge3 (); ai_charge(23); ai_melee_dfury();self.colormod = '1 1 1';};
void()	dfury_char_b2	=[	$char_b2,	dfury_char_b3	] {ai_charge(27); ai_melee_dfury();};
void()	dfury_char_b3	=[	$char_b3,	dfury_char_b4	] {ai_charge(22); ai_melee_dfury();};
void()	dfury_char_b4	=[	$char_b4,	dfury_char_b5	] {ai_charge(32); ai_melee_dfury(); dfury_footsteps (0.9);};
void()	dfury_char_b5	=[	$char_b5,	dfury_char_b6	] {ai_charge(28); ai_melee_dfury();};
void()	dfury_char_b6	=[	$char_b6,	dfury_char_b1	] {ai_charge(8); ai_melee_dfury();};

//===========================================================================

void()	dfury_slice1	=[	$slice1,	dfury_slice2	] {ai_charge(19);self.colormod = '1 1 1';};
void()	dfury_slice2	=[	$slice2,	dfury_slice3	] {ai_charge(16);};
void()	dfury_slice3	=[	$slice3,	dfury_slice4	] {ai_charge(23); dfury_footsteps (0.8);};
void()	dfury_slice4	=[	$slice4,	dfury_slice5	] {ai_charge(14);};
void()	dfury_slice5	=[	$slice5,	dfury_slice6	] {ai_charge(17); ai_melee_dfury();};
void()	dfury_slice6	=[	$slice6,	dfury_slice7	] {ai_charge(25); ai_melee_dfury();};
void()	dfury_slice7	=[	$slice7,	dfury_slice8	] {ai_charge(18); ai_melee_dfury(); dfury_footsteps (0.8);};
void()	dfury_slice8	=[	$slice8,	dfury_slice9	] {ai_charge(12); ai_melee_dfury();};
void()	dfury_slice9	=[	$slice9,	dfury_slice10	] {ai_melee_dfury();};
void()	dfury_slice10	=[	$slice10,	dfury_slice11	] {ai_charge(14);ai_melee_dfury();};
void()	dfury_slice11	=[	$slice11,	dfury_slice12	] {ai_charge(14);ai_melee_dfury();};
void()	dfury_slice12	=[	$slice12,	dfury_slice13	] {ai_charge(14);ai_melee_dfury();};
void()	dfury_slice13	=[	$slice13,	dfury_slice14	] {ai_charge(14);ai_melee_dfury();};
void()	dfury_slice14	=[	$slice14,	dfury_run1	] {ai_charge(13);};

//===========================================================================

void()	dfury_smash1	=[	$smash1,	dfury_smash2	] {ai_charge(1);self.colormod = '1 1 1';};
void()	dfury_smash2	=[	$smash2,	dfury_smash3	] {ai_charge(23);};
void()	dfury_smash3	=[	$smash3,	dfury_smash4	] {ai_charge(9);};
void()	dfury_smash4	=[	$smash4,	dfury_smash5	] {ai_charge(21); dfury_footsteps (0.8);};
void()	dfury_smash5	=[	$smash5,	dfury_smash6	] {ai_charge(20); ai_melee_dfury();};
void()	dfury_smash6	=[	$smash6,	dfury_smash7	] {ai_charge(7); ai_melee_dfury();};
void()	dfury_smash7	=[	$smash7,	dfury_smash8	] {ai_charge(22); ai_melee_dfury();};
void()	dfury_smash8	=[	$smash8,	dfury_smash9	] {ai_charge(2); ai_melee_dfury();};
void()	dfury_smash9	=[	$smash9,	dfury_smash10	] {ai_charge(3); ai_melee_dfury(); dfury_footsteps (0.8);};
void()	dfury_smash10	=[	$smash10,	dfury_smash11	] {ai_charge(0);};
void()	dfury_smash11	=[	$smash11,	dfury_smash12	] {ai_charge(0);};
void()	dfury_smash12	=[	$smash12,	dfury_smash13	] {ai_charge(0);};
void()	dfury_smash13	=[	$smash13,	dfury_smash14	] {ai_charge(0);};
void()	dfury_smash14	=[	$smash14,	dfury_smash15	] {ai_charge(0);};
void()	dfury_smash15	=[	$smash15,	dfury_run1	] {ai_charge(0);};

//============================================================================

void()	dfury_watk1	=[	$w_attack1,	dfury_watk2	] {ai_charge(2);self.colormod = '1 1 1';};
void()	dfury_watk2	=[	$w_attack2,	dfury_watk3	] {ai_charge(0);};
void()	dfury_watk3	=[	$w_attack3,	dfury_watk4	] {ai_charge(0);};
void()	dfury_watk4	=[	$w_attack4,	dfury_watk5	] {ai_melee_dfury();};
void()	dfury_watk5	=[	$w_attack5,	dfury_watk6	] {ai_melee_dfury();};
void()	dfury_watk6	=[	$w_attack6,	dfury_watk7	] {ai_melee_dfury();};
void()	dfury_watk7	=[	$w_attack7,	dfury_watk8	] {ai_charge(1);ai_melee_dfury();};
void()	dfury_watk8	=[	$w_attack8,	dfury_watk9	] {ai_charge(4);ai_melee_dfury();};
void()	dfury_watk9	=[	$w_attack9,	dfury_watk10	] {ai_charge(5);};
void()	dfury_watk10	=[	$w_attack10,	dfury_watk11	] {ai_charge(3); ai_melee_dfury();};
void()	dfury_watk11	=[	$w_attack11,	dfury_watk12	] {ai_charge(2); ai_melee_dfury(); dfury_footsteps (0.8);};
void()	dfury_watk12	=[	$w_attack12,	dfury_watk13	] {ai_charge(2); ai_melee_dfury();};
void()	dfury_watk13	=[	$w_attack13,	dfury_watk14	] {ai_charge(0);};
void()	dfury_watk14	=[	$w_attack14,	dfury_watk15	] {ai_charge(0);ai_melee_dfury();};
void()	dfury_watk15	=[	$w_attack15,	dfury_watk16	] {ai_charge(0);ai_melee_dfury();};
void()	dfury_watk16	=[	$w_attack16,	dfury_run1	] {ai_charge(3); dfury_footsteps (0.8);};
/*
void()	dfury_watk17	=[	$w_attack17,	dfury_watk18	] {ai_charge(1); ai_melee_dfury();};
void()	dfury_watk18	=[	$w_attack18,	dfury_watk19	] {ai_charge(3); ai_melee_dfury();};
void()	dfury_watk19	=[	$w_attack19,	dfury_watk20	] {ai_charge(4); ai_melee_dfury();};
void()	dfury_watk20	=[	$w_attack20,	dfury_watk21	] {ai_charge(6);};
void()	dfury_watk21	=[	$w_attack21,	dfury_watk22	] {ai_charge(7);};
void()	dfury_watk22	=[	$w_attack22,	dfury_run1	] {ai_charge(3); dfury_footsteps (0.8);};*/

//============================================================================

void() df_idle_sound =
{
	if (random() < 0.2)
		sound (self, CHAN_VOICE, "dfury/idle.wav", 1, ATTN_NORM);
};

void(entity attacker, float damage)	dfury_pain =
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
		dfury_pain1 ();
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
	dfury_pain1 ();
};

float	dfury_type;

void() dfury_melee =
{
	dfury_type = dfury_type + 1;

	sound (self, CHAN_WEAPON, "dfury/slash1.wav", 1, ATTN_NORM);
	if (dfury_type == 1)
		dfury_slice1 ();
	else if (dfury_type == 2)
		dfury_smash1 ();
	else if (dfury_type == 3)
	{
		dfury_watk1 ();
		dfury_type = 0;
	}
};

void() dfury_random_magic =		// adds random magic attack animation
{						// in original ID1, only "dfury_magiccxx" is used
local float zufall;
	zufall = random();
		if (zufall > 0.66)
			self.th_missile = dfury_magica1;
		else if (zufall < 0.34)
			self.th_missile = dfury_magicb1;
		else
			self.th_missile = dfury_magicc1;	
};

//boss jump attack

void()	dfury_JumpTouch =
{
	local	float	ldmg;

	if (self.health <= 0)
		return;
		
	if (other.takedamage)
	{
		if ( vlen(self.velocity) > 400 )
		{
			var float autocvar_dfury_size_influenced_attack = 0; 	  		// set cvar 'dfury_size_influenced_attack' default to 0
			if (autocvar_dfury_size_influenced_attack == 1)				// if 'dfury_size_influenced_attack' is set via autoexec.cfg to '1' raise monsterÕ³ attack values according to its size 
				ldmg = (autocvar_dfury_jump * self.scale) + 10*random();	// default 40
			else
				ldmg = autocvar_dfury_jump + 10*random();			// default 40
			if (self.enemy.classname == "monster_knight")
				T_Damage (other, self, self, ldmg);	
		}
	}

	if (!checkbottom(self))
	{
		self.tail_visible = 0;
		if (self.flags & FL_ONGROUND)
		{	// jump randomly to not get hung up
//dprint ("popjump\n");
	self.touch = SUB_Null;
	if (self.monstermodel == 2)
	 	self.think = teneb_jump1;
	else
	 	self.think = dfury_jump1;
	self.nextthink = time + 0.1;

//			self.velocity_x = (random() - 0.5) * 600;
//			self.velocity_y = (random() - 0.5) * 600;
//			self.velocity_z = 200;
//			self.flags = self.flags - FL_ONGROUND;
		}
		return;	// not on ground yet
	}

	self.touch = SUB_Null;
	if (self.monstermodel == 2)
	 	self.think = teneb_jump7;
	else
	 	self.think = dfury_jump11;
	self.nextthink = time + 0.1;
};


/*QUAKED monster_dfury (1 0 0) (-16 -16 -24) (16 16 40) Ambush
*/
void() monster_dfury =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	precache_model2 ("progs/dfury.mdl");
	precache_model2 ("progs/k_spike.mdl");
	precache_model2 ("progs/h_hellkn.mdl");

	
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
	precache_sound ("dfury/fall.wav");
	precache_sound ("walk/dfury1.wav");
	precache_sound ("walk/dfury2.wav");
	precache_sound ("walk/dfury3.wav");
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
		setmodel (self, "progs/dfury.mdl");
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
			setmodel (self, "progs/dfury.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 0;
			}
		else if (zufall < 0.34)
			{
			setmodel (self, "progs/dfury.mdl");
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
			setmodel (self, "progs/dfury.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 0;
			}
		else if (zufall > 0.5 && zufall <= 0.75)
			{
			setmodel (self, "progs/dfury.mdl");
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
		setmodel (self, "progs/dfury.mdl");
		self.skin = 0;
		self.monsterskin = 0;
		self.monstermodel = 0;
		}

var float autocvar_dfury_size = 2;     	// set cvar 'dfury_size' default to 2
	local float zuffa;
	if (autocvar_dfury_size == 1)		// if 'dfury_size' is set via autoexec.cfg to '1' give monster random size between 100% and 114% (7% steps due to DP´s .scale restrictions)
	{
		zuffa = random();			//  je 7% um ca. 1.7 größer  (bei 24er Ausgangs bbox Mitte)
		if (zuffa <= 0.33)			//  1.07 ==> -25.7    1.14 ==> -27.4 
		{					//  1.07 ==> -25    1.14 ==> -27  
			self.scale = 1.14;
			self.sizediff = '0 0 3';
			setsize (self, '-16 -16 -24' - self.sizediff, '16 16 40' - self.sizediff);
		}
		else if (zuffa <= 0.66)
		{
			self.scale = 1.07;
			self.sizediff = '0 0 1';
			setsize (self, '-16 -16 -24' - self.sizediff, '16 16 40' - self.sizediff);
		}
		else
		{
			self.scale = 1;
			setsize (self, '-16 -16 -24', '16 16 40');
		}
	}
	else if (autocvar_dfury_size == 2)		// if 'dfury_size' is set via autoexec.cfg to '2' give monster random size between 100% and 121% (7% steps due to DP´s .scale restrictions)
	{
			self.scale = 1;
			setsize (self, '-26 -26 -24', '26 26 70');
	}
	else if (autocvar_dfury_size == 3)		// if 'dfury_size' is set via autoexec.cfg to '3' give monster random size between 100% and 128% (7% steps due to DP´s .scale restrictions)
	{
		zuffa = random();			//  je 7% um ca. 1.7 größer  (bei 24er Ausgangs bbox Mitte)
		if (zuffa <= 0.2)			//  1.07 ==> -25.7    1.14 ==> -27.4    1.21 ==> 29   1.28 ==> 31
		{					//  1.07 ==> -25    1.14 ==> -27    1.21 ==> 29   1.28 ==> 31
			self.scale = 1.28;
			self.sizediff = '0 0 7';
			setsize (self, '-16 -16 -24' - self.sizediff, '16 16 40' - self.sizediff);
		}
		else if (zuffa <= 0.4)
		{
			self.scale = 1.21;
			self.sizediff = '0 0 5';
			setsize (self, '-16 -16 -24' - self.sizediff, '16 16 40' - self.sizediff);
		}
		else if (zuffa <= 0.6)
		{
			self.scale = 1.14;
			self.sizediff = '0 0 3';
			setsize (self, '-16 -16 -24' - self.sizediff, '16 16 40' - self.sizediff);
		}
		else if (zuffa <= 0.8)
		{
			self.scale = 1.07;
			self.sizediff = '0 0 1';
			setsize (self, '-16 -16 -24' - self.sizediff, '16 16 40' - self.sizediff);
		}
		else
		{
			self.scale = 1;
			setsize (self, '-16 -16 -24', '16 16 40');
		}
	}
	else if (autocvar_dfury_size == 4)		// if 'dfury_size' is set via autoexec.cfg to '4' give monster random size between 100% and 135% (7% steps due to DP´s .scale restrictions)
	{
		zuffa = random();			//  je 7% um ca. 1.7 größer  (bei 24er Ausgangs bbox Mitte)
		if (zuffa <= 0.17)			//  1.07 ==> -25.7    1.14 ==> -27.4    1.21 ==> 29.1   1.28 ==> 30.8   1.35 ==> 32.5
		{					//  1.07 ==> -25    1.14 ==> -27    1.21 ==> 29   1.28 ==> 31   1.35 ==> 33
			self.scale = 1.35;
			self.sizediff = '0 0 9';
			setsize (self, '-16 -16 -24' - self.sizediff, '16 16 40' - self.sizediff);
		}
		else if (zuffa <= 0.34)
		{
			self.scale = 1.28;
			self.sizediff = '0 0 7';
			setsize (self, '-16 -16 -24' - self.sizediff, '16 16 40' - self.sizediff);
		}
		else if (zuffa <= 0.5)
		{
			self.scale = 1.21;
			self.sizediff = '0 0 5';
			setsize (self, '-16 -16 -24' - self.sizediff, '16 16 40' - self.sizediff);
		}
		else if (zuffa <= 0.67)
		{
			self.scale = 1.14;
			self.sizediff = '0 0 3';
			setsize (self, '-16 -16 -24' - self.sizediff, '16 16 40' - self.sizediff);
		}
		else if (zuffa <= 0.84)
		{
			self.scale = 1.07;
			self.sizediff = '0 0 1';
			setsize (self, '-16 -16 -24' - self.sizediff, '16 16 40' - self.sizediff);
		}
		else
		{
			self.scale = 1;
			setsize (self, '-16 -16 -24', '16 16 40');
		}
	}
	else if (autocvar_dfury_size > 4)		// if 'dfury_size' is set via autoexec.cfg to a value bigger than '4' give monster the selected fixed size ==>  100% + [value]%  (7% steps due to DP´s .scale restrictions)
	{
		if (autocvar_dfury_size > 40)
			self.origin = self.origin + '0 0 10';		// might get stuck in floor otherwise. --> drop him to floor from higher position !
		self.scale = 1 + (autocvar_dfury_size * 0.01);
		self.sizefactor_x = 0;
		self.sizefactor_y = 0;
		self.sizefactor_z = autocvar_dfury_size * 0.25;
		self.sizediff = self.sizefactor;
		setsize (self, '-16 -16 -24' - self.sizediff, '16 16 40' - self.sizediff);
	}
	else
	{
		self.scale = 1;
		setsize (self, '-16 -16 -24', '16 16 40');
	}

var float autocvar_dfury_size_influenced_health = 0; 		  		// set cvar 'dfury_size_influenced_health' default to 0
	if (autocvar_dfury_size_influenced_health == 1)			// if 'dfury_size_influenced_health' is set via autoexec.cfg to '1' raise monster´s health according to its size  (use different formular for monsters with default health <100 and health >100 to be realistic/noticable)
		self.health = autocvar_dfury_health * self.scale;		// default: 250
	else
		self.health = autocvar_dfury_health;			// default 250
	self.health_initial = self.health;

	if (autocvar_monster_random_skin_color_alteration && autocvar_dfury_random_skin_colors)	// modify/edit this monster types skin textures randomly (for higher variation in-game)
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

	self.th_stand = dfury_stand1;
	self.th_walk = dfury_walk1;
	self.th_run = dfury_run1;
	self.th_melee = dfury_melee;

  	self.th_missile = dfury_random_magic;		// adds random magic attack animation
  //  self.th_missile = dfury_magicc1;		// in original ID1, only "dfury_magiccXX" is used

	self.th_pain = dfury_pain;
	self.th_die = dfury_die;
  
  	self.alpha = autocvar_monstertransparency * 0.01;
/*
	if (autocvar_warlord_replace_dfury)		// if dfury shall be replaced by Warlord. Check the chance and do it !!)
		{	
		local float replacerr;		
		replacerr = autocvar_warlord_replace_dfury * 0.01;
		if (random () <= replacerr)
			{
			self.scale = 1;
			setsize (self, '-16 -16 -24', '16 16 40');
			self.nextthink = time + 0.3;	
			self.think = SUB_Remove;
			monster_hell_knight2_start();
			return;
			}
		}

	if (autocvar_carnivean_replace_dfury)	// if dfury shall be replaced by Carnivean. Check the chance and do it !!)
		{	
		local float replacerrrrr;		
		replacerrrrr = autocvar_carnivean_replace_dfury * 0.01;
		if (random () <= replacerrrrr)
			{
			self.health = autocvar_knight_health + 50;	// default 75 + 50
			self.scale = 1;
			setsize (self, '-16 -16 -24', '16 16 40');
			self.nextthink = time + 0.3;	
			self.think = SUB_Remove;
			monster_carnivean_start();
			return;
			}
		}

	if (autocvar_torment_replace_dfury)		// if dfury shall be replaced by Torment. Check the chance and do it !!)
		{	
		local float replacerrr;		
		replacerrr = autocvar_torment_replace_dfury * 0.01;
		if (random () <= replacerrr)
			{
			self.health = autocvar_dfury_health;	// default 250
			self.scale = 1;
			setsize (self, '-16 -16 -24', '16 16 40');
			self.nextthink = time + 0.3;	
			self.think = SUB_Remove;
			monster_torment_start();
			return;
			}
		}

	if (autocvar_yakman_replace_dfury)		// if dfury shall be replaced by Yakman. Check the chance and do it !!)
		{	
		local float replacerrrr;		
		replacerrrr = autocvar_yakman_replace_dfury * 0.01;
		if (random () <= replacerrrr)
			{
			self.health = autocvar_dfury_health + 50;		// default 250 + 50
			self.scale = 1;
			setsize (self, '-16 -16 -24', '16 16 40');
			self.nextthink = time + 0.3;	
			self.think = SUB_Remove;
			monster_yakman_start();
			return;
			}
		}

	if (autocvar_spider_replace_dfury)		// if dfury shall be replaced by spider. Check the chance and do it !!)
		{	
		local float replacer;		
		replacer = autocvar_spider_replace_dfury * 0.01;
		if (random () <= replacer)
			{
			 local vector check;
			 check = (self.origin - ((VEC_HULL2_MIN + VEC_HULL2_MAX) * 0.5)) + '0 0 1';
			 if (((pointcontents(check) == CONTENT_WATER) && (autocvar_spider_can_spawn_in_water)) || (pointcontents(check) != CONTENT_WATER)) 	   // checks if monster is spawned in water. Spider is too small to be visible in shallow (not transparent) water, so better not change to spider.
				{
				self.skin = 5;
				self.health = autocvar_dfury_health;	// default 250
				self.scale = 1;
				setsize (self, '-16 -16 -24', '16 16 40');
				self.nextthink = time + 0.3;	
				self.think = SUB_Remove;
				monster_spider_start();
				return;
				}
			}
		}

	if (autocvar_reiver_replace_dfury)		// if dfury shall be replaced by reiver. Check the chance and do it !!)
		{	
		local float replacez;		
		replacez = autocvar_reiver_replace_dfury * 0.01;
		if (random () <= replacez)
			{
			self.health = autocvar_dfury_health;	// default 250
			self.scale = 1;
			setsize (self, '-16 -16 -24', '16 16 40');
			self.nextthink = time + 0.3;	
			self.think = SUB_Remove;
			monster_reiver_liftorigin_start();
			return;
			}
		}

	if (autocvar_afrit_replace_dfury)		// if dfury shall be replaced by afrit. Check the chance and do it !!)
		{	
		local float replac;		
		replac = autocvar_afrit_replace_dfury * 0.01;
		if (random () <= replac)
			{
			self.health = autocvar_dfury_health;	// default 250
			self.scale = 1;
			setsize (self, '-16 -16 -24', '16 16 40');
			self.nextthink = time + 0.3;	
			self.think = SUB_Remove;
			monster_afrit_liftorigin_start();
			return;
			}
		}
*/
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

do_the_cloning();

/*if (autocvar_reiver_supports_dfury)		// if reiver shall be spawned in ADDITION to an existing dfury. Check the chance and do it !!)
	{	
	local float replacce;		
	replacce = autocvar_reiver_supports_dfury * 0.01;
	if (random () <= replacce)
		add_reiver_support_walk ();
	}
*/
if (autocvar_afrit_supports_dfury)		// if afrit shall be spawned in ADDITION to an existing dfury. Check the chance and do it !!)
	{	
	local float replace;		
	replace = autocvar_afrit_supports_dfury * 0.01;
	if (random () <= replace)
		add_afrit_support_walk ();
	}

var float autocvar_dfurymass = 4500;
MonsterPhysics (self, autocvar_dfurymass);
};


///////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////  below code added by Seven  //////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////
/*
==============================================================================

Creates "Vengeance of the deceased" effect.    

Modelname and Modelframe is taken from call after regular death animations:    
void(string modelname, float modelframe) vengeance;
Example: 
vengeance ("progs/soldier.mdl", $death10);

This function must be declared at the end of defs.qc (example):
void(string modelname, float modelframe) vengeance_dfury; 

==============================================================================
*/


void() vengeance_dfury_end1 = {					// end sequence
	self.alpha = -1;
	te_customflash (self.origin, 500, 0.7, '1 0 0');
	self.nextthink = time + 0.2;
      self.think = SUB_Remove;
};


void() vengeance_dfury_touch = {       // player receives 1-3 damage when he gets touched by vengeance effect

	local float ldmg;
	ldmg = rint(0.5 + (3 * random()));  	// chances=  33%: 1 damage /  33%: 2 damage  /  33%: 3 damage

	 T_Damage (self.enemy, self, self, ldmg);  	// analog to meele attack dog/fiend
	// T_Damage (other, self, self, ldmg); 		// analog to jump damage dog/fiend

	self.touch = SUB_Null; 			// um nicht endlos damage zu kriegen !

		self.think = vengeance_dfury_end1; 
		self.nextthink = time + 0.1;   
};


void() vengeance_dfury_skull =			//  calls skull in skull.qc   
{
	local	vector	offang, org;
	
	offang = vectoangles (self.enemy.origin - self.origin);
	makevectors (offang);
	org = self.origin + self.mins + self.size*0.5 + v_forward * 20;   
	org_z = org_z + 10;   		 // to adjust spawning coordinate of skull. Depending on the monster it spawnes.

	launch_vengeance_skull (org); 	
	newmis.classname = "skull";
	setmodel (newmis, "progs/skull.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);	

	newmis.scale = 0.9;		//  set size of the skull here.  Depending on the monster it spawnes. ;)

	precache_sound ("vengeance/skull.wav");	
	precache_sound ("vengeance/skulltouch.wav");  
};


									//  from here on: run sequence. 

void() vengeance_dfury_run1 =[	$run1,	vengeance_dfury_run2 ]   {
	ai_face();
 	movetogoal (19);  // orig(20)
self.touch = vengeance_dfury_touch;
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_dfury_run2 =[	$run2,	vengeance_dfury_run3 ]   {
	ai_face();
 	movetogoal (24);   // orig(25)
self.touch = vengeance_dfury_touch;
	self.alpha = 0.37;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_dfury_run3 =[	$run3,	vengeance_dfury_run4 ]    {
	ai_face();
 	movetogoal (17);   // orig(18)
self.touch = vengeance_dfury_touch;
	self.alpha = 0.34;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_dfury_run4 =[	$run4,	vengeance_dfury_run5 ]    {
	ai_face();
 	movetogoal (15);    // orig(16)
self.touch = vengeance_dfury_touch;
	self.alpha = 0.31;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_dfury_run5 =[	$run5,	vengeance_dfury_run6 ]    {
	ai_face();
 	movetogoal (13);   // orig(14)
self.touch = vengeance_dfury_touch;
	self.alpha = 0.28;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_dfury_run6 =[	$run6,	vengeance_dfury_run7 ]    {
	ai_face();
 	movetogoal (24);   // orig(25)
self.touch = vengeance_dfury_touch;
	self.alpha = 0.25;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_dfury_run7 =[	$run7,	vengeance_dfury_random ]    {
	ai_face();
 	movetogoal (20);   // orig(21)
self.touch = vengeance_dfury_touch;
	self.alpha = 0.22;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};


							//  from here on: attack/jump sequenz. 

void() vengeance_dfury_chara1 =[ $char_a1,	vengeance_dfury_chara2 ]    {
	ai_face();
 	movetogoal (19);    // orig(20)
self.touch = vengeance_dfury_touch;
	self.alpha = 0.2;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_dfury_chara2 =[ $char_a2,	vengeance_dfury_chara3 ]    {
	ai_face();
 	movetogoal (24);   // orig(25)
self.touch = vengeance_dfury_touch; 
	self.alpha = 0.17;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_dfury_chara3 =[ $char_a3,	vengeance_dfury_chara4 ]    {
	ai_face();
 	movetogoal (17);   // orig(18)
self.touch = vengeance_dfury_touch;
	self.alpha = 0.14;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_dfury_chara4 =[ $char_a4,	vengeance_dfury_chara5 ]    {
	ai_face();
 	movetogoal (15);   // orig(16)
self.touch = vengeance_dfury_touch;
sound (self, CHAN_VOICE, "dfury/slash1.wav", 1, 4);
	self.alpha = 0.11;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_dfury_chara5 =[ $char_a5,	vengeance_dfury_chara6 ]    {
	ai_face();
 	movetogoal (13);   // orig(14)
self.touch = vengeance_dfury_touch;
	self.alpha = 0.08;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_dfury_chara6 =[ $char_a6,	vengeance_dfury_end1 ]    {
	ai_face();
 	movetogoal (19);   // orig(20)
self.touch = vengeance_dfury_touch;
	makevectors (self.angles);
	self.origin_z = self.origin_z + 1;
	self.velocity = v_forward * 130 + '0 0 10';
	self.alpha = 0.05;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};


							//  from here on: skull spawn sequenz. 

void() vengeance_dfury_skull1 =[ $magica2,	vengeance_dfury_skull2 ]    {
	ai_face();
self.touch = vengeance_dfury_touch;
	self.alpha = 0.2;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_dfury_skull2 =[ $magica3,	vengeance_dfury_skull3 ]    {
sound (self, CHAN_VOICE, "vengeance/dfurymag.wav", 0.8, ATTN_NORM);	
	ai_face();
self.touch = vengeance_dfury_touch; 
	self.alpha = 0.2;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_dfury_skull3 =[ $magica4,	vengeance_dfury_skull4 ]    {
	ai_face();
self.touch = vengeance_dfury_touch;
	self.alpha = 0.2;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_dfury_skull4 =[ $magica5,	vengeance_dfury_skull5 ]    {
	ai_face();
self.touch = vengeance_dfury_touch;
	self.alpha = 0.2;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_dfury_skull5 =[ $magica6,	vengeance_dfury_skull6 ]    {
	ai_face();
self.touch = vengeance_dfury_touch;
	self.alpha = 0.2;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_dfury_skull6 =[ $magica5,	vengeance_dfury_skull7 ]    {
	ai_face();
self.touch = vengeance_dfury_touch;
	self.alpha = 0.2;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_dfury_skull7 =[ $magica8,	vengeance_dfury_skull8 ]    {
	ai_face();
self.touch = vengeance_dfury_touch;
	self.alpha = 0.15;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_dfury_skull8 =[ $magica8,	vengeance_dfury_end1 ]    {
	ai_face();
	movetogoal (2);
self.touch = vengeance_dfury_touch;
	self.alpha = 0.1;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
vengeance_dfury_skull();
};



void()	vengeance_dfury_random 	= {		// random final animation selection
	self.alpha = 0.22;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.01;
		if (random() > 0.45)
			self.think = vengeance_dfury_chara1;
		else
			self.think = vengeance_dfury_skull1;
};


										//  from here on: ressurection sequence 1. 

void() vengeance_dfury11 =[	$death11,	vengeance_dfury12 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_dfury12 =[	$death10,	vengeance_dfury13 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_dfury13 =[	$death9,	vengeance_dfury14 	]  {
	walkmove ( (self.angles_y+180), 11);  
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_dfury14 =[	$death8,	vengeance_dfury15 	]  {
	walkmove ( (self.angles_y+180), 10);  
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_dfury15 =[	$death7,	vengeance_dfury16 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_dfury16 =[	$death6,	vengeance_dfury17 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_dfury17 =[	$death5,	vengeance_dfury18 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_dfury18 =[	$death4,	vengeance_dfury19 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_dfury19 =[	$death3,	vengeance_dfury110 	]  {
sound (self, CHAN_WEAPON, "dfury/sight1.wav", 1, ATTN_NORM);
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_dfury110 =[ $death2,	vengeance_dfury111 	]  {
	walkmove ( (self.angles_y+180), 8);  
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_dfury111 =[ $death1,	vengeance_dfury_stand1 ]  {
	walkmove ( (self.angles_y+180), 10);  
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_dfury_stand1 =[ $run8,	vengeance_dfury_run1 ]  {    // needed to make the animation fluent
	self.alpha = 0.4;	 								 // $run8 fills the frame gap	
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};


											//  from here on: ressurection sequence 2. 

void() vengeance_dfury21 =[	$deathb8,	vengeance_dfury22 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_dfury22 =[	$deathb7,	vengeance_dfury23 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_dfury23 =[	$deathb6,	vengeance_dfury24 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_dfury24 =[	$deathb5,	vengeance_dfury25 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_dfury25 =[	$deathb4,	vengeance_dfury26 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_dfury26 =[	$deathb3,	vengeance_dfury27 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_dfury27 =[	$deathb2,	vengeance_dfury28 	]  {
sound (self, CHAN_WEAPON, "dfury/sight1.wav", 1, ATTN_NORM);
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_dfury28 =[ $deathb1,	vengeance_dfury_stand2 ]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_dfury_stand2 =[	$stand1,	vengeance_dfury_stand21 ]  {    // needed to make the animation fluent
	self.alpha = 0.4;										    // $stand1 fills the frame gap
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_dfury_stand21 =[ $run8,	vengeance_dfury_run1 ]  {    // needed to make the animation fluent
	self.alpha = 0.4;	 									 // $run8 fills the frame gap
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};



								// from here on:  sequence where the corpse overbrights 
void()	vengeance_dfury_bright05 	= {
	self.alpha = 0.3;
	self.colormod = '6 1 1';
	self.glow_color = 75;
	self.glow_size = 450;
	self.nextthink = time + 0.1;
		if (self.frame == $death12)
			self.think = vengeance_dfury11;
		else
			self.think = vengeance_dfury21;
};
void()	vengeance_dfury_bright04 	= {
	self.alpha = 0.3;
	self.colormod = '5 1 1';
	self.glow_color = 75;
	self.glow_size = 350;
	self.nextthink = time + 0.1;
	self.think = vengeance_dfury_bright05;
};
void()	vengeance_dfury_bright03 	= {
	self.alpha = 0.3;
	self.colormod = '4 1 1';
	self.glow_color = 75;
	self.glow_size = 270;
	self.nextthink = time + 0.1;
	self.think = vengeance_dfury_bright04;
};
void()	vengeance_dfury_bright02 	= {
	self.alpha = 0.3;
	self.colormod = '3 1 1';
	self.glow_color = 75;
	self.glow_size = 185;
	self.nextthink = time + 0.1;
	self.think = vengeance_dfury_bright03;
}; 
void()	vengeance_dfury_bright01 	= {
	self.alpha = 0.3;
	self.colormod = '2 1 1';
	self.glow_color = 75;
	self.glow_size = 100;
	self.nextthink = time + 0.1;
	self.think = vengeance_dfury_bright02;
};
void()	vengeance_dfury_bright00 	= {  			// delay for 0.3 seconds before overbright process really begins
	self.alpha = 0.3;
	self.glow_color = 75;
	self.glow_size = 10;
	self.nextthink = time + 0.3;
	self.think = vengeance_dfury_bright01;
};



void(string modelname, float modelframe) vengeance_dfury =
{

local vector v;  			// v  was necessary at the begining of effect development, but isnt anymore now.

v_x = (self.origin_x);
v_y = (self.origin_y);
v_z = (self.origin_z);

//	precache_model ("progs/skull.mdl");		// precached in worldspawn() due to savegame-bug
//	precache_sound ("vengeance/dfurymag.wav");	// precached in worldspawn() due to savegame-bug

      self.origin = v; 
   	self.touch = SUB_Null;                
	self.movetype = MOVETYPE_FLY;
	
	if (self.monstermodel == 0)  
		setmodel (self, "progs/dfury.mdl"); 
	else if (self.monstermodel == 1)  
		setmodel (self, "progs/dfury1.mdl"); 

	setsize (self, '-16 -16 -24', '16 16 40');
	self.frame = modelframe;	 // modelframe is depending on the individual monster (included in vengeance call)

	var float autocvar_vengeancedamage = 0;   // set cvar 'vengeancedamage' default to 0
	if (autocvar_vengeancedamage == 0)	  	// if 'vengeancedamage' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '0'
		self.solid = SOLID_NOT;			// vengeance effect is NOT solid and cannot hurt the player
	else
		self.solid = SOLID_SLIDEBOX;    	// if value is NOT "0", player get hurt from this effect (see func "vengeance_dfury_touch")!

	vengeance_dfury_bright00 ();		// starts the animation
};

