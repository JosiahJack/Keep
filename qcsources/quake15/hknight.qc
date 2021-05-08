/*
==============================================================================

Hell-KNIGHT

==============================================================================
*/

$cd id1/models/knight2
$origin 0 0 24
$base base
$skin skin

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9
$frame walk10 walk11 walk12 walk13 walk14

$frame run1 run2 run3 run4 run5 run6 run7 run8

$frame pain1 pain2 pain3 pain4 pain5

$frame death1 death2 death3 death4 death5 death6 death7 death8
$frame death9 death10 death11 death12

$frame deathb1 deathb2 deathb3 deathb4 deathb5 deathb6 deathb7 deathb8
$frame deathb9

$frame char_a1 char_a2 char_a3 char_a4 char_a5 char_a6 char_a7 char_a8
$frame char_a9 char_a10 char_a11 char_a12 char_a13 char_a14 char_a15 char_a16

$frame magica1 magica2 magica3 magica4 magica5 magica6 magica7 magica8
$frame magica9 magica10 magica11 magica12 magica13 magica14

$frame magicb1 magicb2 magicb3 magicb4 magicb5 magicb6 magicb7 magicb8
$frame magicb9 magicb10 magicb11 magicb12 magicb13

$frame char_b1 char_b2 char_b3 char_b4 char_b5 char_b6

$frame slice1 slice2 slice3 slice4 slice5 slice6 slice7 slice8 slice9 slice10

$frame smash1 smash2 smash3 smash4 smash5 smash6 smash7 smash8 smash9 smash10
$frame smash11

$frame w_attack1 w_attack2 w_attack3 w_attack4 w_attack5 w_attack6 w_attack7 
$frame w_attack8 w_attack9 w_attack10 w_attack11 w_attack12 w_attack13 w_attack14
$frame w_attack15 w_attack16 w_attack17 w_attack18 w_attack19 w_attack20 
$frame w_attack21 w_attack22 

$frame magicc1 magicc2 magicc3 magicc4 magicc5 magicc6 magicc7 magicc8
$frame magicc9 magicc10 magicc11

$frame ssgdeth1 ssgdeth2 ssgdeth3 ssgdeth4 ssgdeth5 ssgdeth6 ssgdeth7 ssgdeth8 ssgdeth9 ssgdeth10
$frame ssgdeth11 ssgdeth12 ssgdeth13 ssgdeth14 ssgdeth15 ssgdeth16 ssgdeth17 ssgdeth18 ssgdeth19 ssgdeth20
$frame ssgdeth21 ssgdeth22 ssgdeth23 ssgdeth24 ssgdeth25 ssgdeth26 ssgdeth27 ssgdeth28

$frame ssgdethb1 ssgdethb2 ssgdethb3 ssgdethb4 ssgdethb5 ssgdethb6 ssgdethb7 ssgdethb8 ssgdethb9 ssgdethb10
$frame ssgdethb11 ssgdethb12

void() hknight_char_a1;
void() hknight_run1;
void() hk_idle_sound;
void() hknight_random_magic;		// adds random magic attack animation
					// in original ID1, only "hknight_magiccxx" is used


void(float offset) hknight_shot =
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
	newmis.classname = "knightspike";
	setmodel (newmis, "progs/k_spike.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);		
	newmis.velocity = vec*300;
	sound7(self, CHAN_WEAPON, "hknight/attack1.wav", 1, ATTN_NORM, SNDSPD);
};

void() CheckForCharge =
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
	hknight_char_a1 ();

};

void() CheckContinueCharge =
{
	if (time > self.attack_finished)
	{
		SUB_AttackFinished (3);
		hknight_run1 ();
		return;		// done charging
	}
	if (random() > 0.5)
		sound7(self, CHAN_WEAPON, "knight/sword2.wav", 1, ATTN_NORM, SNDSPD);
	else
		sound7(self, CHAN_WEAPON, "knight/sword1.wav", 1, ATTN_NORM, SNDSPD);
};

//===========================================================================

void(float loudness) hknight_footsteps =
{
if (autocvar_monsterfootsteps == 1)	// only play monster footsteps sound when cvar is 1
	{
	local float select;
	select = random();
	if (select <= 0.33)
		sound7(self, CHAN_AUTO, "walk/hknight1.wav", loudness, ATTN_IDLE, SNDSPD);
	else if (select <= 0.66)
		sound7(self, CHAN_AUTO, "walk/hknight2.wav", loudness, ATTN_IDLE, SNDSPD);
	else 
		sound7(self, CHAN_AUTO, "walk/hknight3.wav", loudness, ATTN_IDLE, SNDSPD);
	}
};


void()	hknight_stand1	=[	$stand1,	hknight_stand2	] {ai_stand();self.colormod = '1 1 1';};
void()	hknight_stand2	=[	$stand2,	hknight_stand3	] {ai_stand();};
void()	hknight_stand3	=[	$stand3,	hknight_stand4	] {ai_stand();};
void()	hknight_stand4	=[	$stand4,	hknight_stand5	] {ai_stand();};
void()	hknight_stand5	=[	$stand5,	hknight_stand6	] {ai_stand();};
void()	hknight_stand6	=[	$stand6,	hknight_stand7	] {ai_stand();};
void()	hknight_stand7	=[	$stand7,	hknight_stand8	] {ai_stand();};
void()	hknight_stand8	=[	$stand8,	hknight_stand9	] {ai_stand();};
void()	hknight_stand9	=[	$stand9,	hknight_stand1	] {ai_stand();};

//===========================================================================

void()	hknight_walk1	=[	$walk1,		hknight_walk2	] {
hk_idle_sound();
ai_walk(2);self.colormod = '1 1 1'; hknight_footsteps (0.8);};
void()	hknight_walk2	=[	$walk2,		hknight_walk3	] {ai_walk(5);};
void()	hknight_walk3	=[	$walk3,		hknight_walk4	] {ai_walk(5);};
void()	hknight_walk4	=[	$walk4,		hknight_walk5	] {ai_walk(4);};
void()	hknight_walk5	=[	$walk5,		hknight_walk6	] {ai_walk(4);};
void()	hknight_walk6	=[	$walk6,		hknight_walk7	] {ai_walk(2);};
void()	hknight_walk7	=[	$walk7,		hknight_walk8	] {ai_walk(2);};
void()	hknight_walk8	=[	$walk8,		hknight_walk9	] {ai_walk(3);};
void()	hknight_walk9	=[	$walk9,		hknight_walk10	] {ai_walk(3);};
void()	hknight_walk10	=[	$walk10,	hknight_walk11	] {ai_walk(4);};
void()	hknight_walk11	=[	$walk11,	hknight_walk12	] {ai_walk(3); hknight_footsteps (0.8);};
void()	hknight_walk12	=[	$walk12,	hknight_walk13	] {ai_walk(4);};
void()	hknight_walk13	=[	$walk13,	hknight_walk14	] {ai_walk(6);};
void()	hknight_walk14	=[	$walk14,	hknight_walk1	] {ai_walk(2);};

//===========================================================================

void()	hknight_run1	=[	$run1,		hknight_run2	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);
hk_idle_sound();
ai_run (20); CheckForCharge (); self.colormod = '1 1 1';};
void()	hknight_run2	=[	$run2,		hknight_run3	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(25); hknight_footsteps (1);};
void()	hknight_run3	=[	$run3,		hknight_run4	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(18);};
void()	hknight_run4	=[	$run4,		hknight_run5	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(16);};
void()	hknight_run5	=[	$run5,		hknight_run6	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(14);};
void()	hknight_run6	=[	$run6,		hknight_run7	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(25); hknight_footsteps (0.8);};
void()	hknight_run7	=[	$run7,		hknight_run8	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(21);};
void()	hknight_run8	=[	$run8,		hknight_run1	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(13);};

//============================================================================

void()	hknight_pain1	=[	$pain1,		hknight_pain2	] {sound7(self, CHAN_VOICE, "hknight/pain1.wav", 1, ATTN_NORM, SNDSPD);self.colormod = '1 1 1';};
void()	hknight_pain2	=[	$pain2,		hknight_pain3	] {};
void()	hknight_pain3	=[	$pain3,		hknight_pain4	] {};
void()	hknight_pain4	=[	$pain4,		hknight_pain5	] {};
void()	hknight_pain5	=[	$pain5,		hknight_run1	] {};

//============================================================================

//void(float maxgibs, float gibscounter) producegibs_hknight;

void() hknight_dieburn1	=[	$deathb1,	hknight_dieburn2	] {self.burnz_origin = 12;
burn_toggle_allround();
};
void() hknight_dieburn2	=[	$deathb2,	hknight_dieburn3	] {self.burnz_origin = 10;
};
void() hknight_dieburn3	=[	$deathb3,	hknight_dieburn4	] {self.burnz_origin = 6;
self.solid = SOLID_NOT;
};
void() hknight_dieburn4	=[	$deathb4,	hknight_dieburn5	] {self.burnz_origin = 3;
};
void() hknight_dieburn5	=[	$deathb5,	hknight_dieburn6	] {self.burnz_origin = 0;
};
void() hknight_dieburn6	=[	$deathb6,	hknight_dieburn7	] {self.burnz_origin = -2;
};
void() hknight_dieburn7	=[	$deathb7,	hknight_dieburn8	] {self.burnz_origin = -4;
};
void() hknight_dieburn8	=[	$deathb8,	hknight_dieburn9	] {self.burnz_origin = -6;
};
void() hknight_dieburn9	=[	$deathb9,	hknight_dieburn9	] {self.burnz_origin = -8;
};


var float autocvar_hknight = 5;     		// set cvar 'hknight' default to 5
var float autocvar_hknightcorpsehealth = 60;	// set cvar 'hknightcorpsehealth' default to 60
var float autocvar_hknightcorpseburnable = 1;	// set cvar 'hknightcorpseburnable' default to 1

void()	hknight_die1	=[	$death1,	hknight_die2	] {ai_forward(10);self.colormod = '1 1 1';};
void()	hknight_die2	=[	$death2,	hknight_die3	] {ai_forward(8);};
void()	hknight_die3	=[	$death3,	hknight_die4	]
{self.solid = SOLID_NOT; ai_forward(7);};
void()	hknight_die4	=[	$death4,	hknight_die5	] {};
void()	hknight_die5	=[	$death5,	hknight_die6	] {};
void()	hknight_die6	=[	$death6,	hknight_die7	] {};
void()	hknight_die7	=[	$death7,	hknight_die8	] {};
void()	hknight_die8	=[	$death8,	hknight_die9	] {ai_forward(10);};
void()	hknight_die9	=[	$death9,	hknight_die10	] {ai_forward(11);sound7(self, CHAN_AUTO, "hknight/fall.wav", 1, ATTN_IDLE, SNDSPD);};
void()	hknight_die10	=[	$death10,	hknight_die11	] {};
void()	hknight_die11	=[	$death11,	hknight_die12	] {};
void()	hknight_die12	=[	$death12,	hknight_die12	] {
if (self.inflamed == 1)
{
	inflamed_die ();
	return;
}
local float zufall, zet, randomness;
	zet = 21;					// z-position of the wings (in relation to soul). Dependent on corpse size.
	if (autocvar_hknightcorpseburnable == 1)	// corpses are burnable
		self.burnable_corpse = 1;
// 	auto_cvar 'hknightcorpsehealth' has been set to  default = 60  in code above already
	self.delete_painskin = 1;		 	 // remove painskin
	if (self.monstermodel == 0)  
		CopyMonsterToBodyQue(autocvar_hknightcorpsehealth, "progs/h_hellkn.mdl");
	if (self.monstermodel == 1)  
		CopyMonsterToBodyQue(autocvar_hknightcorpsehealth, "progs/h_hellkn1.mdl");
if (self.nodeathanim == 1)
	return;
if (self.grimrock_helper == 0)
{
// 	auto_cvar 'hknight' has been declared in code above already
	var float autocvar_hknightrandomness = 25;     	// set cvar 'hknightrandomness' default to 25%
	autocvar_hknightrandomness = autocvar_hknightrandomness * 0.01;
	if (autocvar_hknight == 1)		// if 'hknight' is set via autoexec.cfg to '1' start ghost effect
		{
		randomness = random();
		if (randomness <= autocvar_hknightrandomness)	// checks if death animation shall be started
			ghost_die ();
		}
	else if (autocvar_hknight == 2)	// if 'hknight' is set via autoexec.cfg to '2' start soul effect
		{
		randomness = random();
		if (randomness <= autocvar_hknightrandomness)	// checks if death animation shall be started
			{
			if (self.monstermodel == 0)  
				soul ("progs/hknight.mdl", $death12, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
			else if (self.monstermodel == 1)  
				soul ("progs/hknight1.mdl", $death12, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
			}
		}
	else if (autocvar_hknight == 3)	// if 'hknight' is set via autoexec.cfg to '3' start vengeance effect
		{
		randomness = random();
		if (randomness <= autocvar_hknightrandomness)	// checks if death animation shall be started
			vengeance_hknight ("progs/hknight.mdl", $death12); 
		}
	else if (autocvar_hknight == 5)		// if 'hknight' is set via autoexec.cfg to '5' start randomly one of these Death animations: 
		{				// (Ancient ghosts of the fallen ; Relieved souls of the enslaved ; Vengeance of the deceased)
		randomness = random();		// chance for effects (approx.): 36% / 26% / 38%
		if (randomness <= autocvar_hknightrandomness)	// checks if death animation shall be started --> depending on monsters _randomness
			{					
			zufall = random();
			if (zufall > 0.64)
				ghost_die ();
			else if (zufall < 0.26)
				{
				if (self.monstermodel == 0)  
					soul ("progs/hknight.mdl", $death12, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
				else if (self.monstermodel == 1)  
					soul ("progs/hknight1.mdl", $death12, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
				}
			else
				vengeance_hknight ("progs/hknight.mdl", $death12);
			}
		}
	else				// if 'hknight' is set via autoexec.cfg to another value (example '0'), do nothing !
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
			soul ("progs/hknight.mdl", $death12, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
		else if (self.monstermodel == 1)  
			soul ("progs/hknight1.mdl", $death12, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
		}
	else
		vengeance_hknight ("progs/hknight.mdl", $death12);
	}
};

void()	hknight_diessg1	=[	$ssgdeth1,	hknight_diessg2	] {ai_forward(5);};
void()	hknight_diessg2	=[	$ssgdeth2,	hknight_diessg3	] {ai_forward(5);sound7(self, CHAN_VOICE, "player/gibsplit.wav", 1, ATTN_IDLE, SNDSPD);};
void()	hknight_diessg3	=[	$ssgdeth3,	hknight_diessg4	] {ai_forward(5);self.solid = SOLID_NOT;};
void()	hknight_diessg4	=[	$ssgdeth4,	hknight_diessg5	] {sound7(self, CHAN_AUTO, "misc/paste.wav", 1, ATTN_IDLE, SNDSPD);};
void()	hknight_diessg5	=[	$ssgdeth5,	hknight_diessg6	] {self.traileffectnum = particleeffectnum("blood_spurt_trail");};
void()	hknight_diessg6	=[	$ssgdeth6,	hknight_diessg7	] {};
void()	hknight_diessg7	=[	$ssgdeth7,	hknight_diessg8	] {sound7(self, CHAN_AUTO, "misc/paste.wav", 1, ATTN_IDLE, SNDSPD);};
void()	hknight_diessg8	=[	$ssgdeth8,	hknight_diessg9	] {};
void()	hknight_diessg9	=[	$ssgdeth9,	hknight_diessg10] {self.traileffectnum = particleeffectnum("");};
void()	hknight_diessg10=[	$ssgdeth10,	hknight_diessg11] {};
void()	hknight_diessg11=[	$ssgdeth11,	hknight_diessg12] {ai_forward(8);};
void()	hknight_diessg12=[	$ssgdeth12,	hknight_diessg13] {ai_forward(8);sound7(self, CHAN_AUTO, "misc/paste.wav", 1, ATTN_IDLE, SNDSPD);};
void()	hknight_diessg13=[	$ssgdeth13,	hknight_diessg14] {ai_forward(8);self.traileffectnum = particleeffectnum("blood_spurt_trail");};
void()	hknight_diessg14=[	$ssgdeth14,	hknight_diessg15] {ai_forward(5);};
void()	hknight_diessg15=[	$ssgdeth15,	hknight_diessg16] {ai_forward(3);};
void()	hknight_diessg16=[	$ssgdeth16,	hknight_diessg17] {};
void()	hknight_diessg17=[	$ssgdeth17,	hknight_diessg18] {self.traileffectnum = particleeffectnum("");};
void()	hknight_diessg18=[	$ssgdeth18,	hknight_diessg19] {};
void()	hknight_diessg19=[	$ssgdeth19,	hknight_diessg20] {};
void()	hknight_diessg20=[	$ssgdeth20,	hknight_diessg21] {};
void()	hknight_diessg21=[	$ssgdeth21,	hknight_diessg22] {self.solid = SOLID_NOT;};
void()	hknight_diessg22=[	$ssgdeth22,	hknight_diessg23] {};
void()	hknight_diessg23=[	$ssgdeth23,	hknight_diessg24] {};
void()	hknight_diessg24=[	$ssgdeth24,	hknight_diessg25] {};
void()	hknight_diessg25=[	$ssgdeth25,	hknight_diessg26] {};
void()	hknight_diessg26=[	$ssgdeth26,	hknight_diessg27] {};
void()	hknight_diessg27=[	$ssgdeth27,	hknight_diessg28] {};
void()	hknight_diessg28=[	$ssgdethb1,	hknight_diessg28] {sound7(self, CHAN_AUTO, "hknight/fall.wav", 1, ATTN_IDLE, SNDSPD); sendParticle("blood_spurt", self.origin-'0 0 6', '0 0 0', 1);
		if (autocvar_hknightcorpseburnable == 1)		// corpses are burnable
		self.burnable_corpse = 1;
// 	auto_cvar 'knightcorpsehealth' has been set to  default = 60  in code above already
	self.delete_painskin = 1;		 	 // remove painskin
	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	CopyMonsterToBodyQue(autocvar_hknightcorpsehealth, "progs/gib_hknight_larm.mdl");
	//Above is corpse gibbing code - FIND CORPSE
	};

void()	hknight_diessgb1	=[	$ssgdethb1,	hknight_diessgb2	] {};
void()	hknight_diessgb2	=[	$ssgdethb2,	hknight_diessgb3	] {sound7(self, CHAN_VOICE, "player/gibsplit.wav", 1, ATTN_IDLE, SNDSPD);if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
						sendParticle("blood_blast", self.origin, '0 0 0', 1);};
void()	hknight_diessgb3	=[	$ssgdethb3,	hknight_diessgb4	] {};
void()	hknight_diessgb4	=[	$ssgdethb4,	hknight_diessgb5	] {self.solid = SOLID_NOT; sound7(self, CHAN_AUTO, "misc/paste.wav", 1, ATTN_IDLE, SNDSPD);self.traileffectnum = particleeffectnum("blood_spurt_trail");};
void()	hknight_diessgb5	=[	$ssgdethb5,	hknight_diessgb6	] {};
void()	hknight_diessgb6	=[	$ssgdethb6,	hknight_diessgb7	] {};
void()	hknight_diessgb7	=[	$ssgdethb7,	hknight_diessgb8	] {sound7(self, CHAN_AUTO, "misc/paste.wav", 1, ATTN_IDLE, SNDSPD);};
void()	hknight_diessgb8	=[	$ssgdethb8,	hknight_diessgb9	] {ai_forward(8);};
void()	hknight_diessgb9	=[	$ssgdethb9,	hknight_diessgb10	] {self.traileffectnum = particleeffectnum("");};
void()	hknight_diessgb10	=[	$ssgdethb10,	hknight_diessgb11	] {};
void()	hknight_diessgb11	=[	$ssgdethb11,	hknight_diessgb12	] {};
void()	hknight_diessgb12	=[	$ssgdethb12,	hknight_diessgb12	] { 
		if (autocvar_hknightcorpseburnable == 1)		// corpses are burnable
		self.burnable_corpse = 1;
// 	auto_cvar 'knightcorpsehealth' has been set to  default = 60  in code above already
	self.delete_painskin = 1;		 	 // remove painskin
	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	CopyMonsterToBodyQue(autocvar_hknightcorpsehealth, "progs/gib_hknight_head.mdl");
	//Above is corpse gibbing code - FIND CORPSE
	};
	
void()	hknight_diesnga1	=[	$ssgdethb1,	hknight_diesnga2	] {};
void()	hknight_diesnga2	=[	$ssgdethb2,	hknight_diesnga3	] {sound7(self, CHAN_VOICE, "player/gibsplit.wav", 1, ATTN_IDLE, SNDSPD);if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
						sendParticle("blood_blast", self.origin, '0 0 0', 1);};
void()	hknight_diesnga3	=[	$ssgdethb3,	hknight_diesnga4	] {};
void()	hknight_diesnga4	=[	$ssgdethb4,	hknight_diesnga5	] {self.solid = SOLID_NOT; sound7(self, CHAN_AUTO, "misc/paste.wav", 1, ATTN_IDLE, SNDSPD);};
void()	hknight_diesnga5	=[	$ssgdethb5,	hknight_diesnga6	] {self.traileffectnum = particleeffectnum("blood_spurt_trail");};
void()	hknight_diesnga6	=[	$ssgdethb6,	hknight_diesnga7	] {};
void()	hknight_diesnga7	=[	$ssgdethb7,	hknight_diesnga8	] {sound7(self, CHAN_AUTO, "misc/paste.wav", 1, ATTN_IDLE, SNDSPD);};
void()	hknight_diesnga8	=[	$ssgdethb8,	hknight_diesnga9	] {ai_forward(8);};
void()	hknight_diesnga9	=[	$ssgdethb9,	hknight_diesnga10	] {self.traileffectnum = particleeffectnum("");};
void()	hknight_diesnga10	=[	$ssgdethb10,	hknight_diesnga11	] {};
void()	hknight_diesnga11	=[	$ssgdethb11,	hknight_diesnga12	] {};
void()	hknight_diesnga12	=[	$ssgdethb12,	hknight_diesnga12	] { 
		if (autocvar_hknightcorpseburnable == 1)		// corpses are burnable
		self.burnable_corpse = 1;
// 	auto_cvar 'knightcorpsehealth' has been set to  default = 60  in code above already
	self.delete_painskin = 1;		 	 // remove painskin
	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	CopyMonsterToBodyQue(autocvar_hknightcorpsehealth, "progs/gib3.mdl");
	//Above is corpse gibbing code - FIND CORPSE
	};
	
void() hknight_make_corpse =
{

		if (autocvar_hknightcorpseburnable == 1)		// corpses are burnable
		self.burnable_corpse = 1;
	// 	auto_cvar 'knightcorpsehealth' has been set to  default = 60  in code above already
		self.delete_painskin = 1;		 	 // remove painskin
		setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
		CopyMonsterToBodyQue(autocvar_hknightcorpsehealth, "progs/gib_hknight_larm.mdl");
		//Above is corpse gibbing code - FIND CORPSE
}

void()	hknight_axdeth0	=[	0,	hknight_axdeth1	] {};
void()	hknight_axdeth1	=[	1,	hknight_axdeth2	] {self.solid = SOLID_NOT;};
void()	hknight_axdeth2	=[	2,	hknight_axdeth3	] {sound7(self, CHAN_VOICE, "player/gibsplit.wav", 1, ATTN_IDLE, SNDSPD);};
void()	hknight_axdeth3	=[	3,	hknight_axdeth4	] {};
void()	hknight_axdeth4	=[	4,	hknight_axdeth5	] {sound7(self, CHAN_AUTO, "misc/paste.wav", 1, ATTN_IDLE, SNDSPD);};
void()	hknight_axdeth5	=[	5,	hknight_axdeth6	] {self.traileffectnum = particleeffectnum("blood_spurt_trail");};
void()	hknight_axdeth6	=[	6,	hknight_axdeth7	] {};
void()	hknight_axdeth7	=[	7,	hknight_axdeth8	] {sound7(self, CHAN_AUTO, "misc/paste.wav", 1, ATTN_IDLE, SNDSPD);};
void()	hknight_axdeth8	=[	8,	hknight_axdeth9	] {};
void()	hknight_axdeth9	=[	9,	hknight_axdeth10] {};
void()	hknight_axdeth10=[	10,	hknight_axdeth11] {};
void()	hknight_axdeth11=[	11,	hknight_axdeth12] {};
void()	hknight_axdeth12=[	12,	hknight_axdeth13] {sound7(self, CHAN_AUTO, "misc/paste.wav", 1, ATTN_IDLE, SNDSPD);};
void()	hknight_axdeth13=[	13,	hknight_axdeth14] {};
void()	hknight_axdeth14=[	14,	hknight_axdeth15] {self.traileffectnum = particleeffectnum("");};
void()	hknight_axdeth15=[	15,	hknight_axdeth16] {pointparticles(particleeffectnum("blood_spurt"), self.origin, '0 0 0', 1);};
void()	hknight_axdeth16=[	16,	hknight_axdeth17] {};
void()	hknight_axdeth17=[	17,	hknight_axdeth18] {pointparticles(particleeffectnum("blood_spurt"), self.origin, '0 0 0', 1);};
void()	hknight_axdeth18=[	18,	hknight_axdeth19] {};
void()	hknight_axdeth19=[	19,	hknight_axdeth20] {};
void()	hknight_axdeth20=[	20,	hknight_axdeth21] {sound7(self, CHAN_AUTO, "hknight/fall.wav", 1, ATTN_IDLE, SNDSPD);};
void()	hknight_axdeth21=[	21,	hknight_axdeth22] {};
void()	hknight_axdeth22=[	22,	hknight_axdeth23] {};
void()	hknight_axdeth23=[	23,	hknight_axdeth23] {hknight_make_corpse();};


void()	hknight_dieb1	=[	$deathb1,	hknight_dieb2	] {self.colormod = '1 1 1';};
void()	hknight_dieb2	=[	$deathb2,	hknight_dieb3	] {};
void()	hknight_dieb3	=[	$deathb3,	hknight_dieb4	]
{self.solid = SOLID_NOT;};
void()	hknight_dieb4	=[	$deathb4,	hknight_dieb5	] {};
void()	hknight_dieb5	=[	$deathb5,	hknight_dieb6	] {};
void()	hknight_dieb6	=[	$deathb6,	hknight_dieb7	] {sound7(self, CHAN_AUTO, "hknight/fall.wav", 1, ATTN_IDLE, SNDSPD);};
void()	hknight_dieb7	=[	$deathb7,	hknight_dieb8	] {};
void()	hknight_dieb8	=[	$deathb8,	hknight_dieb9	] {};
void()	hknight_dieb9	=[	$deathb9,	hknight_dieb9	] {
if (self.inflamed == 1)
{
	inflamed_die ();
	return;
}
local float zufall, zet, randomness;
	zet = 21;					// z-position of the wings (in relation to soul). Dependent on corpse size.
	if (autocvar_hknightcorpseburnable == 1)	// corpses are burnable
		self.burnable_corpse = 1;
// 	auto_cvar 'hknightcorpsehealth' has been set to  default = 60  in code above already
	self.delete_painskin = 1;		 	 // remove painskin
	if (self.monstermodel == 0)  
		CopyMonsterToBodyQue(autocvar_hknightcorpsehealth, "progs/h_hellkn.mdl");
	if (self.monstermodel == 1)  
		CopyMonsterToBodyQue(autocvar_hknightcorpsehealth, "progs/h_hellkn1.mdl");
if (self.nodeathanim == 1)
	return;
if (self.grimrock_helper == 0)
{
// 	auto_cvar 'hknight' has been declared in code above already
	var float autocvar_hknightrandomness = 25;     	// set cvar 'hknightrandomness' default to 25%
	autocvar_hknightrandomness = autocvar_hknightrandomness * 0.01;
	if (autocvar_hknight == 1)		// if 'hknight' is set via autoexec.cfg to '1' start ghost effect
		{
		randomness = random();
		if (randomness <= autocvar_hknightrandomness)	// checks if death animation shall be started
			ghost_die ();
		}
	else if (autocvar_hknight == 2)	// if 'hknight' is set via autoexec.cfg to '2' start soul effect
		{
		randomness = random();
		if (randomness <= autocvar_hknightrandomness)	// checks if death animation shall be started
			{
			if (self.monstermodel == 0)  
				soul ("progs/hknight.mdl", $deathb9, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
			else if (self.monstermodel == 1)  
				soul ("progs/hknight1.mdl", $deathb9, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
			}
		}
	else if (autocvar_hknight == 3)	// if 'hknight' is set via autoexec.cfg to '3' start vengeance effect
		{
		randomness = random();
		if (randomness <= autocvar_hknightrandomness)	// checks if death animation shall be started
			vengeance_hknight ("progs/hknight.mdl", $deathb9); 
		}
	else if (autocvar_hknight == 5)		// if 'hknight' is set via autoexec.cfg to '5' start randomly one of these Death animations: 
		{				// (Ancient ghosts of the fallen ; Relieved souls of the enslaved ; Vengeance of the deceased)
		randomness = random();		// chance for effects (approx.): 36% / 26% / 38%
		if (randomness <= autocvar_hknightrandomness)	// checks if death animation shall be started --> depending on monsters _randomness
			{					
			zufall = random();
			if (zufall > 0.64)
				ghost_die ();
			else if (zufall < 0.26)
				{
				if (self.monstermodel == 0)  
					soul ("progs/hknight.mdl", $deathb9, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
				else if (self.monstermodel == 1)  
					soul ("progs/hknight1.mdl", $deathb9, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
				}
			else
				vengeance_hknight ("progs/hknight.mdl", $deathb9);
			}
		}
	else				// if 'hknight' is set via autoexec.cfg to another value (example '0'), do nothing !
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
			soul ("progs/hknight.mdl", $deathb9, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
		else if (self.monstermodel == 1)  
			soul ("progs/hknight1.mdl", $deathb9, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
		}
	else
		vengeance_hknight ("progs/hknight.mdl", $deathb9);
	}
};



void(float maxgibs, float gibscounter) producegibs_hknight =	// creates as many gib-sets as defined in cvar 'gibsmultiplier'
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
producegibs_hknight (maxgibs, gibscounter);
};


void()	hknight_lightning_death	=[	$death1,	hknight_lightning_death1	] {
self.delete_painskin = 1;			  // remove painskin
if (autocvar_lightninggun_death_animation == 2)	  // start the "fade" effect instead of "coal" effect
	lightninggun_death_fade();
};

void()	hknight_lightning_death1 =[	$death1,	hknight_lightning_death1	] {
self.solid = SOLID_NOT;
self.baked = 1;
self.colormod = '0.25 0.22 0.22';	// skins gets darker (looks burned)
if (self.monstermodel == 0)  
	CopyMonsterToBodyQue(1, "progs/h_hellkn.mdl");
if (self.monstermodel == 1)  
	CopyMonsterToBodyQue(1, "progs/h_hellkn1.mdl");
};


void() hknight_die;
void() hknight_inflamed9;

void()	hknight_inflamed1 =[	$run1,	hknight_inflamed2] {ai_run_inflamed (20); self.nextthink = time + 0.09;
local float r;
r = random();
if (r < 0.3)
	sound7(self, CHAN_VOICE, "hknight/grunt.wav", 1, ATTN_NORM, SNDSPD);
else if (r < 0.82)
	sound7(self, CHAN_VOICE, "hknight/pain2.wav", 1, ATTN_NORM, SNDSPD);
};
void()	hknight_inflamed2 =[	$run2,	hknight_inflamed3] {ai_run_inflamed(25); hknight_footsteps (1); self.nextthink = time + 0.09;};
void()	hknight_inflamed3 =[	$run3,	hknight_inflamed4] {ai_run_inflamed(18); self.nextthink = time + 0.09;};
void()	hknight_inflamed4 =[	$run4,	hknight_inflamed5] {ai_run_inflamed(16); self.nextthink = time + 0.09;};
void()	hknight_inflamed5 =[	$run5,	hknight_inflamed6] {ai_run_inflamed(14); self.nextthink = time + 0.09;};
void()	hknight_inflamed6 =[	$run6,	hknight_inflamed7] {ai_run_inflamed(25); hknight_footsteps (0.8); self.nextthink = time + 0.09;};
void()	hknight_inflamed7 =[	$run7,	hknight_inflamed8] {ai_run_inflamed(21); self.nextthink = time + 0.09;
if (self.inflametime < time)
{
	hknight_die ();
	return;
}
if (random() < 0.5)
	hknight_inflamed9 ();	// start pain anim
};
void()	hknight_inflamed8 =[	$run8,	hknight_inflamed1] {ai_run_inflamed(13); self.nextthink = time + 0.09;};

void()	hknight_inflamed9 =[	$pain1,	hknight_inflamed10 ] { self.nextthink = time + 0.09;
local float r;
r = random();
if (r < 0.3)
	sound7(self, CHAN_VOICE, "hknight/grunt.wav", 1, ATTN_NORM, SNDSPD);
else if (r < 0.82)
	sound7(self, CHAN_VOICE, "hknight/pain2.wav", 1, ATTN_NORM, SNDSPD);
};
void()	hknight_inflamed10 =[	$pain2,	hknight_inflamed11 ] { self.nextthink = time + 0.09;};
void()	hknight_inflamed11 =[	$pain3,	hknight_inflamed12 ] { self.nextthink = time + 0.09;};
void()	hknight_inflamed12 =[	$pain4,	hknight_inflamed13 ] { self.nextthink = time + 0.09;};
void()	hknight_inflamed13 =[	$pain5,	hknight_inflamed8 ] { self.nextthink = time + 0.09;
if (self.inflametime < time)
{
	hknight_die ();
	return;
}
};




void() hknight_die =
{
	if (autocvar_lightninggun_death_animation)		// if 'lightninggun_death_animation' is enabled
	{
		if (self.enemy.weapon == IT_LIGHTNING && (self.enemy.meleeing == 0))		// when enemy was killed with lightning gun, go into baked mode
		{
			hknight_lightning_death();
			return;
		}
	}
	else if (!self.shocked && self.enemy.weapon == IT_LIGHTNING && self.sticky != 1)
	{
		lg_death1();
		return;
	}
local float maxgibs, gibscounter;
// check for gib
	if (self.model == "progs/hknight_half.mdl" && (self.health < -40 || self.enemy.weapon == IT_CHAINSAW))
	{
		sendParticle("blood_saw", self.origin, '0 0 0', 1); 
		CeilSplat();
		CeilSplat();
		CeilSplat();
		CeilSplat();
		CeilSplat();
		sound7(self, CHAN_VOICE, "player/gib.wav", 1, ATTN_NORM, SNDSPD);
		gibdeath_effects();
		//sendParticle("blood_corpse_gib", self.origin, '0 0 0', 1);
		ThrowGib ("progs/gib_hknight_head.mdl", self.health/2);
		ThrowGib("progs/gib3.mdl", self.health);
		ThrowGib("progs/gib2.mdl", self.health);
		ThrowGib("progs/gib3.mdl", self.health);
		ThrowGib("progs/gib_hknight_rarm.mdl", self.health);
		ThrowGib("progs/gib2.mdl", self.health);
		ThrowHeart ("progs/gibheart.mdl", self.health);
		//ThrowWeapon("progs/w_dknightsword.mdl", self.health);
		
		remove(self);
		return;
	}
	else if (self.model == "progs/hknight_half.mdl")
	{
		sendParticle("blood_saw", self.origin, '0 0 0', 1); 
		sound7(self, CHAN_VOICE, "hknight/death.wav", 1, ATTN_NORM, SNDSPD);
		ThrowBody ("progs/gib_hknight_half.mdl", self.health);
		//ThrowGib("progs/gib_hknight_rarm.mdl", self.health);
		remove(self);
		return;
	}
	if (self.health < -40)
	{
		self.delete_painskin = 1;	// remove painskin
		gibbed_monsters = gibbed_monsters + 1;
		self.colormod = '1 1 1';
		if (autocvar_slowmotion >= 1)	// start slowmotion when gibbing living enemies
			{
			if (random () <= (autocvar_slowmotion_randomness_hknight * 0.01))
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
					sendParticle("blood_monster_gib", self.origin, '0 0 0', 1);
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
				gibdeath_effects();
				producegibs_hknight (maxgibs, gibscounter);
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
				hknight_inflamed1 ();
				return;
			}
		}
		else		// enemy is burning already and his "run-around-in-panic-time" has just ended
		{
			sound7(self, CHAN_VOICE, "hknight/death2.wav", 1, ATTN_NORM, SNDSPD);
			if (random() > 0.5)
				hknight_die1 ();
			else
				hknight_dieb1 ();
			return;
		}
	}

// regular death

local float zufall, randomness;
// auto_cvar 'hknight' has been declared in code above already
var float autocvar_hknightrandomness = 25;     	// set cvar 'hknightrandomness' default to 25%
autocvar_hknightrandomness = autocvar_hknightrandomness * 0.01;
if (autocvar_hknight == 4)		// if 'hknight' is set via autoexec.cfg to '4' start Death animation with "Legend of Grimrock" effect
	{
	randomness = random();
	if (randomness <= autocvar_hknightrandomness)	// checks if death animation shall be started
		{
		//Gyro_Object_ClearPhysics(self);	// ENABLE this line if you want to disable GYRO during new "Legend of Grimrock" animation !!
		self.delete_painskin = 1;		// remove painskin
		hknight_dieburn1();
		return;			// jump out of this function !!
		}
	}
if (autocvar_hknight == 6)		// if 'hknight' is set via autoexec.cfg to '6' start random Death animation (all 4 effects !!)
	{				// chance for effects (approx.): 25% / 25% / 25% / 25%  
	randomness = random();
	if (randomness <= autocvar_hknightrandomness)	// checks if death animation shall be started --> depending on monsters _randomness
		{					
		zufall = random();
		if (zufall <= 0.26)
			{
			//Gyro_Object_ClearPhysics(self);   // ENABLE this line if you want to disable GYRO during new "Legend of Grimrock" animation !!
			self.delete_painskin = 1;	    // remove painskin
			hknight_dieburn1();
			return;		// jump out of this function !!
			}		// if zufall is bigger than 0.26, use new code inside  upcoming function  for other 3 death animations
		else 
			self.grimrock_helper = 1;	// this float helps me to manipulate the other 3 death animations
		}
	else
		self.grimrock_helper = 2;	// this float helps me to manipulate the other 3 death animations
	}

// if 'hknight' has another value is checked inside prior function (= death animation function)

	if (autocvar_slowmotion >= 3)	// start slowmotion when regular killing living enemies
		{
		if (random () <= (autocvar_slowmotion_randomness_hknight * 0.01))
			{
			the_matrix = 1;
			matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
			}
		}
	sound7(self, CHAN_VOICE, "hknight/death1.wav", 1, ATTN_NORM, SNDSPD);
	if (random() > 0.5)
		hknight_die1 ();
	else
		hknight_dieb1 ();
		
	//FATALITIES
	
	if (self.enemy.meleeing == 0) //check before all fatalities to make sure attack type is not a kick
	{
		if (self.enemy.weapon == IT_AXE || self.enemy.weapon == IT_CHAINSAW)
			{
				if (random() < 0.5)
				{
					if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
						sendParticle("blood_blast", self.origin, '0 0 0', 1);
					ThrowGib ("progs/chop.mdl", self.health);
					ThrowGib ("progs/chop.mdl", self.health);
					ThrowGib ("progs/chop.mdl", self.health);
					self.delete_painskin = 1;
					if (self.skin == 0)
					{
						setmodel (self, self.model = "progs/hknight_axe.mdl");
						self.skin = 0;
						
					}
					else
					{
						setmodel (self, self.model = "progs/hknight_axe.mdl");
						self.skin = 1;
						
					}
					
					hknight_axdeth0();
					ThrowGib ("progs/chop.mdl", self.health);
				}
			}
		if (self.enemy.weapon == IT_SUPER_SHOTGUN)
			{
				if (random() < 0.4 || self.hitbox_pos == HEAD_SHOT)
				{
					if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
						sendParticle("blood_corpse_gib", self.origin, '0 0 0', 1);
					ThrowGib ("progs/chop.mdl", self.health);
					ThrowGib ("progs/chop.mdl", self.health);
					ThrowGib ("progs/chop.mdl", self.health);
					self.delete_painskin = 1;
					if (self.skin == 0)
					{
						setmodel (self, self.model = "progs/hknightssg.mdl");
						self.skin = 0;
					}
					else
					{
						setmodel (self, self.model = "progs/hknightssg.mdl");
						self.skin = 1;
					}
					hknight_diessg1();
					ThrowGib ("progs/chop.mdl", self.health);
				}
				else if (random() >= 0.4 && random() <= 0.7) 
				{
				if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
						sendParticle("blood_corpse_gib", self.origin, '0 0 0', 1);
					ThrowGib ("progs/chop.mdl", self.health);
					ThrowGib ("progs/chop.mdl", self.health);
					ThrowGib ("progs/chop.mdl", self.health);
					self.delete_painskin = 1;
					if (self.skin == 0)
					{
						setmodel (self, self.model = "progs/hknightssgb.mdl");
						self.skin = 0;
					}
					else
					{
						setmodel (self, self.model = "progs/hknightssgb.mdl");
						self.skin = 1;
					}
					hknight_diessgb1();
					ThrowGib ("progs/chop.mdl", self.health);
				}
				else
				{
				if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
						sendParticle("blood_monster_gibsm", self.origin, '0 0 0', 1);
					
					self.delete_painskin = 1;
					if (self.skin == 0)
					{
						setmodel (self, self.model = "progs/hknightblast.mdl");
						self.skin = 0;
					}
					else
					{
						setmodel (self, self.model = "progs/hknightblast.mdl");
						self.skin = 1;
					}
					hknight_die1();
					//ThrowHead ("progs/gib_hknight_head.mdl", self.health);
					ThrowHead ("progs/gib_hknight_torso.mdl", self.health);
					ThrowGib ("progs/gib_hknight_head.mdl", self.health);
					ThrowGib ("progs/gib_hknight_rarm.mdl", self.health);
					ThrowGib ("progs/gib_hknight_larm.mdl", self.health);
					ThrowGib ("progs/gib_knfoot_r.mdl", self.health);
					ThrowGib ("progs/gib_knfoot_l.mdl", self.health);
					sound7(self, CHAN_VOICE, "misc/corpsegib.wav", 1, ATTN_IDLE, SNDSPD);
					ThrowGib ("progs/chop.mdl", self.health);
				}
			}
		if (self.enemy.weapon == IT_GRENADE_LAUNCHER || self.enemy.weapon == IT_ROCKET_LAUNCHER)
			{
				//if (random() <= 0.7)
				//{
					if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
						sendParticle("blood_monster_gibsm", self.origin, '0 0 0', 1);
						hknight_die1();
					//ThrowHead ("progs/gib_hknight_head.mdl", self.health);
					ThrowHead ("progs/gib_hknight_torso.mdl", self.health);
					ThrowGib ("progs/gib_hknight_head.mdl", self.health);
					ThrowGib ("progs/gib_hknight_rarm.mdl", self.health);
					if (random()<0.5)
						ThrowGib ("progs/gib_hknight_larm.mdl", self.health);
					else
					{
						ThrowWeapon ("progs/w_dknightsword.mdl", self.health); 
						ThrowGib ("progs/gib_hknight_rarm.mdl", self.health);
					}
					ThrowGib ("progs/gib_knfoot_r.mdl", self.health);
					ThrowGib ("progs/gib_knfoot_l.mdl", self.health);
					sound7(self, CHAN_VOICE, "player/gib.wav", 1, ATTN_IDLE, SNDSPD);
					ThrowGib ("progs/chop.mdl", self.health);
					ThrowGib ("progs/chop.mdl", self.health);
				//}
			}
		if (self.enemy.weapon == IT_SUPER_NAILGUN)
			{
				if (random() <= 0.6)
				{
				if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
						sendParticle("blood_corpse_gib", self.origin, '0 0 0', 1);
					ThrowGib ("progs/chop.mdl", self.health);
					ThrowGib ("progs/chop.mdl", self.health);
					ThrowGib ("progs/chop.mdl", self.health);
					//ThrowGib ("progs/gib_hknight_torsoSNG.mdl", self.health);
					if (random() > 0.5 || self.hitbox_pos == HEAD_SHOT)
					{
						StickGib ("progs/gib_hknight_headSNG.mdl", self.health);
						ThrowGib ("progs/gib_hknight_torsoSNG.mdl", self.health);
					}
					else
					{
						ThrowGib ("progs/gib_hknight_headSNG.mdl", self.health);
						StickGib ("progs/gib_hknight_torsoSNG.mdl", self.health);
					}
					ThrowGib ("progs/gib_hknight_rarm.mdl", self.health);
					ThrowGib ("progs/chop.mdl", self.health);
					
					self.delete_painskin = 1;
					if (self.skin == 0)
					{
						setmodel (self, self.model = "progs/hknightSNG.mdl");
						self.skin = 0;
						
					}
					else
					{
						setmodel (self, self.model = "progs/hknightSNG.mdl");
						self.skin = 1;
					}
					hknight_diesnga1();
					//ThrowHead ("progs/gib_hknight_head.mdl", self.health);
			
					//ThrowGib ("progs/chop.mdl", self.health);
					//ThrowGib ("progs/chop.mdl", self.health);
					
					//ThrowGib ("progs/gib_hknight_rarm.mdl", self.health);
					//ThrowGib ("progs/gib_hknight_larm.mdl", self.health);
					//ThrowGib ("progs/gib_knfoot_r.mdl", self.health);
					//ThrowGib ("progs/gib_knfoot_l.mdl", self.health);
					sound7(self, CHAN_AUTO, "knight/dropsword.wav", 1, ATTN_IDLE, SNDSPD);
					ThrowWeapon ("progs/w_dknightsword.mdl", self.health); 
					ThrowGib ("progs/chop.mdl", self.health);
				}
				else
				{
				if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
						sendParticle("blood_corpse_gib", self.origin, '0 0 0', 1);
					ThrowGib ("progs/chop.mdl", self.health);
					ThrowGib ("progs/chop.mdl", self.health);
					ThrowGib ("progs/chop.mdl", self.health);
					if (random() > 0.5)
						StickGib ("progs/gib_hknight_torso_SNGb.mdl", self.health);
					else
						ThrowGib ("progs/gib_hknight_torso_SNGb.mdl", self.health);
					StickGib ("progs/gib_hknight_headSNG.mdl");//StockGib ("progs/gib_hknight_headSNG.mdl", self.health);
					if (random() > 0.5)
						StickGib ("progs/gib_hknight_rarm.mdl");
					else
						ThrowGib ("progs/gib_hknight_rarm.mdl", self.health);
					ThrowGib ("progs/chop.mdl", self.health);
					
					self.delete_painskin = 1;
					if (self.skin == 0)
					{
						setmodel (self, self.model = "progs/hknightSNG.mdl");
						self.skin = 0;
						
					}
					else
					{
						setmodel (self, self.model = "progs/hknightSNG.mdl");
						self.skin = 1;
					}
					hknight_diesnga1();
					sound7(self, CHAN_VOICE, "misc/corpsegib.wav", 1, ATTN_IDLE, SNDSPD);
					sound7(self, CHAN_AUTO, "knight/dropsword.wav", 1, ATTN_IDLE, SNDSPD);
					ThrowGib ("progs/chop.mdl", self.health);	
				}
			}
	}
};



//============================================================================

void()	hknight_magica1 =[	$magica1,	hknight_magica2	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();self.colormod = '1.5 1 1';};
void()	hknight_magica2 =[	$magica2,	hknight_magica3	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();self.colormod = '2 1 1';};
void()	hknight_magica3 =[	$magica3,	hknight_magica4	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();self.colormod = '2.5 1 1';};
void()	hknight_magica4 =[	$magica4,	hknight_magica5	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();self.colormod = '3 1 1';};
void()	hknight_magica5 =[	$magica5,	hknight_magica6	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();self.colormod = '3.5 1 1';};
void()	hknight_magica6 =[	$magica6,	hknight_magica7	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void()	hknight_magica7 =[	$magica7,	hknight_magica8	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);hknight_shot(-2);};
void()	hknight_magica8 =[	$magica8,	hknight_magica9	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);hknight_shot(-1);};
void()	hknight_magica9 =[	$magica9,	hknight_magica10] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);hknight_shot(0);};
void()	hknight_magica10 =[	$magica10,	hknight_magica11] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);hknight_shot(1);};
void()	hknight_magica11 =[	$magica11,	hknight_magica12] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);hknight_shot(2);};
void()	hknight_magica12 =[	$magica12,	hknight_magica13] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);hknight_shot(3);self.colormod = '3 1 1';};
void()	hknight_magica13 =[	$magica13,	hknight_magica14] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();self.colormod = '2 1 1';};
void()	hknight_magica14 =[	$magica14,	hknight_run1	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();self.colormod = '1 1 1';
hknight_random_magic();};

//============================================================================

void()	hknight_magicb1 =[	$magicb1,	hknight_magicb2	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();
self.colormod = '1.5 1 1';};
void()	hknight_magicb2 =[	$magicb2,	hknight_magicb3	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();
self.colormod = '2 1 1';};
void()	hknight_magicb3 =[	$magicb3,	hknight_magicb4	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();
self.colormod = '2.5 1 1';};
void()	hknight_magicb4 =[	$magicb4,	hknight_magicb5	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();
self.colormod = '3 1 1';};
void()	hknight_magicb5 =[	$magicb5,	hknight_magicb6	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();
self.colormod = '3.5 1 1';};
void()	hknight_magicb6 =[	$magicb6,	hknight_magicb7	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void()	hknight_magicb7 =[	$magicb7,	hknight_magicb8	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);hknight_shot(-2);};
void()	hknight_magicb8 =[	$magicb8,	hknight_magicb9	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);hknight_shot(-1);};
void()	hknight_magicb9 =[	$magicb9,	hknight_magicb10] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);hknight_shot(0);};
void()	hknight_magicb10 =[	$magicb10,	hknight_magicb11] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);hknight_shot(1);};
void()	hknight_magicb11 =[	$magicb11,	hknight_magicb12] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);hknight_shot(2);};
void()	hknight_magicb12 =[	$magicb12,	hknight_magicb13] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);hknight_shot(3);
self.colormod = '2 1 1';};
void()	hknight_magicb13 =[	$magicb13,	hknight_run1] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();
self.colormod = '1 1 1';
hknight_random_magic();};

//============================================================================

void()	hknight_magicc1 =[	$magicc1,	hknight_magicc2	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();
self.colormod = '1.5 1 1';};
void()	hknight_magicc2 =[	$magicc2,	hknight_magicc3	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();
self.colormod = '2 1 1';};
void()	hknight_magicc3 =[	$magicc3,	hknight_magicc4	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();
self.colormod = '2.5 1 1';};
void()	hknight_magicc4 =[	$magicc4,	hknight_magicc5	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();
self.colormod = '3 1 1';};
void()	hknight_magicc5 =[	$magicc5,	hknight_magicc6	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();
self.colormod = '3.5 1 1';};
void()	hknight_magicc6 =[	$magicc6,	hknight_magicc7	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);hknight_shot(-2);};
void()	hknight_magicc7 =[	$magicc7,	hknight_magicc8	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);hknight_shot(-1);};
void()	hknight_magicc8 =[	$magicc8,	hknight_magicc9	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);hknight_shot(0);};
void()	hknight_magicc9 =[	$magicc9,	hknight_magicc10] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);hknight_shot(1);};
void()	hknight_magicc10 =[	$magicc10,	hknight_magicc11] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);hknight_shot(2);
self.colormod = '2 1 1';};
void()	hknight_magicc11 =[	$magicc11,	hknight_run1] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);hknight_shot(3);
self.colormod = '1 1 1';
hknight_random_magic();};

//===========================================================================

void()	hknight_char_a1	=[	$char_a1,	hknight_char_a2	] {ai_charge(20);self.colormod = '1 1 1';};
void()	hknight_char_a2	=[	$char_a2,	hknight_char_a3	] {ai_charge(25); hknight_footsteps (0.9);};
void()	hknight_char_a3	=[	$char_a3,	hknight_char_a4	] {ai_charge(18);};
void()	hknight_char_a4	=[	$char_a4,	hknight_char_a5	] {ai_charge(16);};
void()	hknight_char_a5	=[	$char_a5,	hknight_char_a6	] {ai_charge(14);};
void()	hknight_char_a6	=[	$char_a6,	hknight_char_a7	] {ai_charge(20); ai_melee_hknight(); hknight_footsteps (0.9);};
void()	hknight_char_a7	=[	$char_a7,	hknight_char_a8	] {ai_charge(21); ai_melee_hknight();};
void()	hknight_char_a8	=[	$char_a8,	hknight_char_a9	] {ai_charge(13); ai_melee_hknight();};
void()	hknight_char_a9	=[	$char_a9,	hknight_char_a10	] {ai_charge(20); ai_melee_hknight(); hknight_footsteps (0.9);};
void()	hknight_char_a10=[	$char_a10,	hknight_char_a11	] {ai_charge(20); ai_melee_hknight();};
void()	hknight_char_a11=[	$char_a11,	hknight_char_a12	] {ai_charge(18); ai_melee_hknight();};
void()	hknight_char_a12=[	$char_a12,	hknight_char_a13	] {ai_charge(16);};
void()	hknight_char_a13=[	$char_a13,	hknight_char_a14	] {ai_charge(14); hknight_footsteps (0.9);};
void()	hknight_char_a14=[	$char_a14,	hknight_char_a15	] {ai_charge(25);};
void()	hknight_char_a15=[	$char_a15,	hknight_char_a16	] {ai_charge(21);};
void()	hknight_char_a16=[	$char_a16,	hknight_run1	] {ai_charge(13);};

//===========================================================================

void()	hknight_char_b1	=[	$char_b1,	hknight_char_b2	]
{CheckContinueCharge (); ai_charge(23); ai_melee_hknight();self.colormod = '1 1 1';};
void()	hknight_char_b2	=[	$char_b2,	hknight_char_b3	] {ai_charge(17); ai_melee_hknight();};
void()	hknight_char_b3	=[	$char_b3,	hknight_char_b4	] {ai_charge(12); ai_melee_hknight();};
void()	hknight_char_b4	=[	$char_b4,	hknight_char_b5	] {ai_charge(22); ai_melee_hknight(); hknight_footsteps (0.9);};
void()	hknight_char_b5	=[	$char_b5,	hknight_char_b6	] {ai_charge(18); ai_melee_hknight();};
void()	hknight_char_b6	=[	$char_b6,	hknight_char_b1	] {ai_charge(8); ai_melee_hknight();};

//===========================================================================

void()	hknight_slice1	=[	$slice1,	hknight_slice2	] {ai_charge(9);self.colormod = '1 1 1';};
void()	hknight_slice2	=[	$slice2,	hknight_slice3	] {ai_charge(6);};
void()	hknight_slice3	=[	$slice3,	hknight_slice4	] {ai_charge(13); hknight_footsteps (0.8);};
void()	hknight_slice4	=[	$slice4,	hknight_slice5	] {ai_charge(4);};
void()	hknight_slice5	=[	$slice5,	hknight_slice6	] {ai_charge(7); ai_melee_hknight();};
void()	hknight_slice6	=[	$slice6,	hknight_slice7	] {ai_charge(15); ai_melee_hknight();};
void()	hknight_slice7	=[	$slice7,	hknight_slice8	] {ai_charge(8); ai_melee_hknight(); hknight_footsteps (0.8);};
void()	hknight_slice8	=[	$slice8,	hknight_slice9	] {ai_charge(2); ai_melee_hknight();};
void()	hknight_slice9	=[	$slice9,	hknight_slice10	] {ai_melee_hknight();};
void()	hknight_slice10	=[	$slice10,	hknight_run1	] {ai_charge(3);};

//===========================================================================

void()	hknight_smash1	=[	$smash1,	hknight_smash2	] {ai_charge(1);self.colormod = '1 1 1';};
void()	hknight_smash2	=[	$smash2,	hknight_smash3	] {ai_charge(13);};
void()	hknight_smash3	=[	$smash3,	hknight_smash4	] {ai_charge(9);};
void()	hknight_smash4	=[	$smash4,	hknight_smash5	] {ai_charge(11); hknight_footsteps (0.8);};
void()	hknight_smash5	=[	$smash5,	hknight_smash6	] {ai_charge(10); ai_melee_hknight();};
void()	hknight_smash6	=[	$smash6,	hknight_smash7	] {ai_charge(7); ai_melee_hknight();};
void()	hknight_smash7	=[	$smash7,	hknight_smash8	] {ai_charge(12); ai_melee_hknight();};
void()	hknight_smash8	=[	$smash8,	hknight_smash9	] {ai_charge(2); ai_melee_hknight();};
void()	hknight_smash9	=[	$smash9,	hknight_smash10	] {ai_charge(3); ai_melee_hknight(); hknight_footsteps (0.8);};
void()	hknight_smash10	=[	$smash10,	hknight_smash11	] {ai_charge(0);};
void()	hknight_smash11	=[	$smash11,	hknight_run1	] {ai_charge(0);};

//============================================================================

void()	hknight_watk1	=[	$w_attack1,	hknight_watk2	] {ai_charge(2);self.colormod = '1 1 1';};
void()	hknight_watk2	=[	$w_attack2,	hknight_watk3	] {ai_charge(0);};
void()	hknight_watk3	=[	$w_attack3,	hknight_watk4	] {ai_charge(0);};
void()	hknight_watk4	=[	$w_attack4,	hknight_watk5	] {ai_melee_hknight();};
void()	hknight_watk5	=[	$w_attack5,	hknight_watk6	] {ai_melee_hknight();};
void()	hknight_watk6	=[	$w_attack6,	hknight_watk7	] {ai_melee_hknight();};
void()	hknight_watk7	=[	$w_attack7,	hknight_watk8	] {ai_charge(1);};
void()	hknight_watk8	=[	$w_attack8,	hknight_watk9	] {ai_charge(4);};
void()	hknight_watk9	=[	$w_attack9,	hknight_watk10	] {ai_charge(5);};
void()	hknight_watk10	=[	$w_attack10,	hknight_watk11	] {ai_charge(3); ai_melee_hknight();};
void()	hknight_watk11	=[	$w_attack11,	hknight_watk12	] {ai_charge(2); ai_melee_hknight(); hknight_footsteps (0.8);};
void()	hknight_watk12	=[	$w_attack12,	hknight_watk13	] {ai_charge(2); ai_melee_hknight();};
void()	hknight_watk13	=[	$w_attack13,	hknight_watk14	] {ai_charge(0);};
void()	hknight_watk14	=[	$w_attack14,	hknight_watk15	] {ai_charge(0);};
void()	hknight_watk15	=[	$w_attack15,	hknight_watk16	] {ai_charge(0);};
void()	hknight_watk16	=[	$w_attack16,	hknight_watk17	] {ai_charge(1);};
void()	hknight_watk17	=[	$w_attack17,	hknight_watk18	] {ai_charge(1); ai_melee_hknight();};
void()	hknight_watk18	=[	$w_attack18,	hknight_watk19	] {ai_charge(3); ai_melee_hknight();};
void()	hknight_watk19	=[	$w_attack19,	hknight_watk20	] {ai_charge(4); ai_melee_hknight();};
void()	hknight_watk20	=[	$w_attack20,	hknight_watk21	] {ai_charge(6);};
void()	hknight_watk21	=[	$w_attack21,	hknight_watk22	] {ai_charge(7);};
void()	hknight_watk22	=[	$w_attack22,	hknight_run1	] {ai_charge(3); hknight_footsteps (0.8);};

//============================================================================

void()	hknight_crawl1	=[	$stand1,	hknight_crawl2	] {ai_walk(1);self.health = self.health - 0.5; if (self.health <= 0) hknight_die();
};
void()	hknight_crawl2	=[	$stand2,	hknight_crawl3	] {ai_walk(1);};
void()	hknight_crawl3	=[	$stand3,	hknight_crawl4	] {ai_walk(1);if (random() < 0.3) sound7(self, CHAN_VOICE, "hknight/pain2.wav", 1, ATTN_NORM, SNDSPD);};
void()	hknight_crawl4	=[	$stand4,	hknight_crawl5	] {ai_walk(3);};
void()	hknight_crawl5	=[	$stand5,	hknight_crawl6	] {ai_walk(4);};
void()	hknight_crawl6	=[	$stand6,	hknight_crawl7	] {ai_walk(4);};
void()	hknight_crawl7	=[	$stand7,	hknight_crawl8	] {ai_walk(4);};
void()	hknight_crawl8	=[	$stand8,	hknight_crawl1	] {ai_walk(3);};

void() hk_idle_sound =
{
	if (random() < 0.2)
		sound7(self, CHAN_VOICE, "hknight/idle.wav", 1, ATTN_NORM, SNDSPD);
};

void(entity attacker, float damage)	hknight_pain =
{
	if (attacker.meleeing == 0 && (attacker.weapon == IT_ROCKET_LAUNCHER || attacker.weapon == IT_GRENADE_LAUNCHER) && random(100) < 25)
	{
		setmodel (self, "progs/hknight_half.mdl");
		setsize (self, '-12 -12 -24', '12 12 -7');
		sendParticle("blood_saw", self.origin, '0 0 0', 1); 
		sendParticle("blood_corpse_gib", self.origin, '0 0 0', 1);
		//self.think = ogre_crawl1;
		//self.nextthink = time + 0.1;
		self.velocity = '0 0 30' + v_forward * 8;
		ThrowGib ("progs/gib_knfoot_l.mdl", self.health);
		ThrowGib ("progs/gib_knfoot_r.mdl", self.health);
		ThrowGib("progs/gib_hknight_rarm.mdl", self.health);
		sound7 (self, CHAN_VOICE, "zombie/z_gib.wav", 1, ATTN_NORM, SNDSPD);
		ThrowWeapon ("progs/w_dknightsword.mdl", self.health);
		self.traileffectnum = particleeffectnum("med_bloodtrail_TR");
		self.th_stand = hknight_crawl1;
		self.th_run = SUB_Null;
		self.th_melee = SUB_Null;
		self.th_pain = SUB_Null;
		self.th_missile = SUB_Null;
		self.health = 15;
		self.goalentity = world;
		//self.th_die = ogre_crdie;
		self.th_stand();
		return;
	}
	if (self.pain_finished > time)
		return;

	sound7(self, CHAN_VOICE, "hknight/pain1.wav", 1, ATTN_NORM, SNDSPD);

	if (time - self.pain_finished > 5)
	{	// allways go into pain frame if it has been a while
		if (autocvar_slowmotion >= 4)	// start slowmotion when hurting enemies
		{
			if (random () <= (autocvar_slowmotion_randomness_hknight * 0.01))
				{
				the_matrix = 1;
				matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
				}
		}
		hknight_pain1 ();
		self.pain_finished = time + 1;
		return;
	}
	
	if ((random()*30 > damage) )
		return;		// didn't flinch

	if (autocvar_slowmotion >= 4)	// start slowmotion when hurting enemies
	{
		if (random () <= (autocvar_slowmotion_randomness_hknight * 0.01))
			{
			the_matrix = 1;
			matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
			}
	}

	self.pain_finished = time + 1;
	hknight_pain1 ();
};

float	hknight_type;

void() hknight_melee =
{
	hknight_type = hknight_type + 1;

	sound7(self, CHAN_WEAPON, "hknight/slash1.wav", 1, ATTN_NORM, SNDSPD);
	if (hknight_type == 1)
		hknight_slice1 ();
	else if (hknight_type == 2)
		hknight_smash1 ();
	else if (hknight_type == 3)
	{
		hknight_watk1 ();
		hknight_type = 0;
	}
};

void() hknight_random_magic =		// adds random magic attack animation
{						// in original ID1, only "hknight_magiccxx" is used
local float zufall;
	zufall = random();
		if (zufall > 0.66)
			self.th_missile = hknight_magica1;
		else if (zufall < 0.34)
			self.th_missile = hknight_magicb1;
		else
			self.th_missile = hknight_magicc1;	
};

/*QUAKED monster_hell_knight (1 0 0) (-16 -16 -24) (16 16 40) Ambush
*/
void() monster_hell_knight =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	precache_model2 ("progs/hknight.mdl");
	precache_model2 ("progs/hknight_half.mdl");
	precache_model2 ("progs/gib_hknight_half.mdl");
	precache_model2 ("progs/k_spike.mdl");
	precache_model2 ("progs/h_hellkn.mdl");
	
	precachegibs_knights();

	precache_sound2 ("hknight/attack1.wav");
	precache_sound2 ("hknight/death.wav");
	precache_sound2 ("hknight/death1.wav");
	precache_sound2 ("hknight/pain1.wav");
	precache_sound  ("hknight/death2.wav");
	precache_sound  ("hknight/pain2.wav");
	precache_sound2 ("hknight/sight1.wav");
	precache_sound("hknight/hit.wav");		// used by C code, so don't sound2
	precache_sound2 ("hknight/slash1.wav");
	precache_sound2 ("hknight/idle.wav");
	precache_sound2 ("hknight/grunt.wav");
	precache_sound("hknight/fall.wav");
	precache_sound("walk/hknight1.wav");
	precache_sound("walk/hknight2.wav");
	precache_sound("walk/hknight3.wav");
	precache_sound("knight/dropsword.wav");
	
	precache_sound("knight/sword1.wav");
	precache_sound("knight/sword2.wav");
	
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

var float autocvar_hknightmultiskin = 0;     	// set cvar 'hknightmultiskin' default to 0
	local float zufall;
	if (autocvar_hknightmultiskin == 1)		// if 'hknightmultiskin' is set via autoexec.cfg to '1' use 2 different skins for ID1 model
	{
		self.multiskin = 1;
		setmodel (self, "progs/hknight.mdl");
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
	else if (autocvar_hknightmultiskin == 2)	// if 'hknightmultiskin' is set via autoexec.cfg to '2' use 1 Id1 model skin AND external model
	{
		self.multiskin = 2;
		precache_model ("progs/hknight1.mdl");
		precache_model ("progs/h_hellkn1.mdl");
		zufall = random();
		if (zufall >= 0.5)
			{
			setmodel (self, "progs/hknight.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 0;
			}
		else 
			{
			setmodel (self, "progs/hknight1.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 1;
			}
	}
	else if (autocvar_hknightmultiskin == 3)	// if 'hknightmultiskin' is set via autoexec.cfg to '3' use 2 Id1 model skins AND external model
	{
		self.multiskin = 3;
		precache_model ("progs/hknight1.mdl");
		precache_model ("progs/h_hellkn1.mdl");
		zufall = random();
		if (zufall > 0.66)
			{
			setmodel (self, "progs/hknight.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 0;
			}
		else if (zufall < 0.34)
			{
			setmodel (self, "progs/hknight.mdl");
			self.skin = 1;
			self.monsterskin = 1;
			self.monstermodel = 0;
			}
		else
			{
			setmodel (self, "progs/hknight1.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 1;
			}
	}
	else if (autocvar_hknightmultiskin == 4)	// if 'hknightmultiskin' is set via autoexec.cfg to '4' use 2 Id1 model skins AND 2 external model skins
	{
		self.multiskin = 4;
		precache_model ("progs/hknight1.mdl");
		precache_model ("progs/h_hellkn1.mdl");
		zufall = random();
		if (zufall > 0.75)
			{
			setmodel (self, "progs/hknight.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 0;
			}
		else if (zufall > 0.5 && zufall <= 0.75)
			{
			setmodel (self, "progs/hknight.mdl");
			self.skin = 1;
			self.monsterskin = 1;
			self.monstermodel = 0;
			}
		else if (zufall > 0.25 && zufall <= 0.5)
			{
			setmodel (self, "progs/hknight1.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 1;
			}
		else 
			{
			setmodel (self, "progs/hknight1.mdl");
			self.skin = 1;
			self.monsterskin = 1;
			self.monstermodel = 1;
			}
	}
	else						// standard Quake
		{
		setmodel (self, "progs/hknight.mdl");
		self.skin = 0;
		self.monsterskin = 0;
		self.monstermodel = 0;
		}

var float autocvar_hknight_size = 2;     	// set cvar 'hknight_size' default to 2
	local float zuffa;
	if (autocvar_hknight_size == 1)		// if 'hknight_size' is set via autoexec.cfg to '1' give monster random size between 100% and 114% (7% steps due to DP´s .scale restrictions)
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
	else if (autocvar_hknight_size == 2)		// if 'hknight_size' is set via autoexec.cfg to '2' give monster random size between 100% and 121% (7% steps due to DP´s .scale restrictions)
	{
		zuffa = random();			//  je 7% um ca. 1.7 größer  (bei 24er Ausgangs bbox Mitte)
		if (zuffa <= 0.25)			//  1.07 ==> -25.7    1.14 ==> -27.4    1.21 ==> 29
		{					//  1.07 ==> -25    1.14 ==> -27    1.21 ==> 29
			self.scale = 1.21;
			self.sizediff = '0 0 5';
			setsize (self, '-16 -16 -24' - self.sizediff, '16 16 40' - self.sizediff);
		}
		else if (zuffa <= 0.5)
		{
			self.scale = 1.14;
			self.sizediff = '0 0 3';
			setsize (self, '-16 -16 -24' - self.sizediff, '16 16 40' - self.sizediff);
		}
		else if (zuffa <= 0.75)
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
	else if (autocvar_hknight_size == 3)		// if 'hknight_size' is set via autoexec.cfg to '3' give monster random size between 100% and 128% (7% steps due to DP´s .scale restrictions)
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
	else if (autocvar_hknight_size == 4)		// if 'hknight_size' is set via autoexec.cfg to '4' give monster random size between 100% and 135% (7% steps due to DP´s .scale restrictions)
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
	else if (autocvar_hknight_size > 4)		// if 'hknight_size' is set via autoexec.cfg to a value bigger than '4' give monster the selected fixed size ==>  100% + [value]%  (7% steps due to DP´s .scale restrictions)
	{
		if (autocvar_hknight_size > 40)
			self.origin = self.origin + '0 0 10';		// might get stuck in floor otherwise. --> drop him to floor from higher position !
		self.scale = 1 + (autocvar_hknight_size * 0.01);
		self.sizefactor_x = 0;
		self.sizefactor_y = 0;
		self.sizefactor_z = autocvar_hknight_size * 0.25;
		self.sizediff = self.sizefactor;
		setsize (self, '-16 -16 -24' - self.sizediff, '16 16 40' - self.sizediff);
	}
	else
	{
		self.scale = 1;
		setsize (self, '-16 -16 -24', '16 16 40');
	}

var float autocvar_hknight_size_influenced_health = 0; 		  		// set cvar 'hknight_size_influenced_health' default to 0
	if (autocvar_hknight_size_influenced_health == 1)			// if 'hknight_size_influenced_health' is set via autoexec.cfg to '1' raise monster´s health according to its size  (use different formular for monsters with default health <100 and health >100 to be realistic/noticable)
		self.health = autocvar_hellknight_health * self.scale;		// default: 250
	else
		self.health = autocvar_hellknight_health;			// default 250
	self.health_initial = self.health;

	if (autocvar_monster_random_skin_color_alteration && autocvar_hknight_random_skin_colors)	// modify/edit this monster types skin textures randomly (for higher variation in-game)
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

	self.th_stand = hknight_stand1;
	self.th_walk = hknight_walk1;
	self.th_run = hknight_run1;
	self.th_melee = hknight_melee;

  	self.th_missile = hknight_random_magic;		// adds random magic attack animation
  //  self.th_missile = hknight_magicc1;		// in original ID1, only "hknight_magiccXX" is used

	self.th_pain = hknight_pain;
	self.th_die = hknight_die;
  
  	self.alpha = autocvar_monstertransparency * 0.01;

	if (autocvar_warlord_replace_hknight)		// if hknight shall be replaced by Warlord. Check the chance and do it !!)
		{	
		local float replacerr;		
		replacerr = autocvar_warlord_replace_hknight * 0.01;
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

	if (autocvar_carnivean_replace_hellknight)	// if hknight shall be replaced by Carnivean. Check the chance and do it !!)
		{	
		local float replacerrrrr;		
		replacerrrrr = autocvar_carnivean_replace_hellknight * 0.01;
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

	if (autocvar_torment_replace_hknight)		// if hknight shall be replaced by Torment. Check the chance and do it !!)
		{	
		local float replacerrr;		
		replacerrr = autocvar_torment_replace_hknight * 0.01;
		if (random () <= replacerrr)
			{
			self.health = autocvar_hellknight_health;	// default 250
			self.scale = 1;
			setsize (self, '-16 -16 -24', '16 16 40');
			self.nextthink = time + 0.3;	
			self.think = SUB_Remove;
			monster_torment_start();
			return;
			}
		}

	if (autocvar_yakman_replace_hellknight)		// if hknight shall be replaced by Yakman. Check the chance and do it !!)
		{	
		local float replacerrrr;		
		replacerrrr = autocvar_yakman_replace_hellknight * 0.01;
		if (random () <= replacerrrr)
			{
			self.health = autocvar_hellknight_health + 50;		// default 250 + 50
			self.scale = 1;
			setsize (self, '-16 -16 -24', '16 16 40');
			self.nextthink = time + 0.3;	
			self.think = SUB_Remove;
			monster_yakman_start();
			return;
			}
		}

	if (autocvar_spider_replace_hknight)		// if hknight shall be replaced by spider. Check the chance and do it !!)
		{	
		local float replacer;		
		replacer = autocvar_spider_replace_hknight * 0.01;
		if (random () <= replacer)
			{
			 local vector check;
			 check = (self.origin - ((VEC_HULL2_MIN + VEC_HULL2_MAX) * 0.5)) + '0 0 1';
			 if (((pointcontents(check) == CONTENT_WATER) && (autocvar_spider_can_spawn_in_water)) || (pointcontents(check) != CONTENT_WATER)) 	   // checks if monster is spawned in water. Spider is too small to be visible in shallow (not transparent) water, so better not change to spider.
				{
				self.skin = 5;
				self.health = autocvar_hellknight_health;	// default 250
				self.scale = 1;
				setsize (self, '-16 -16 -24', '16 16 40');
				self.nextthink = time + 0.3;	
				self.think = SUB_Remove;
				monster_spider_start();
				return;
				}
			}
		}

	if (autocvar_reiver_replace_hknight)		// if hellknight shall be replaced by reiver. Check the chance and do it !!)
		{	
		local float replacez;		
		replacez = autocvar_reiver_replace_hknight * 0.01;
		if (random () <= replacez)
			{
			self.health = autocvar_hellknight_health;	// default 250
			self.scale = 1;
			setsize (self, '-16 -16 -24', '16 16 40');
			self.nextthink = time + 0.3;	
			self.think = SUB_Remove;
			monster_reiver_liftorigin_start();
			return;
			}
		}

	if (autocvar_afrit_replace_hknight)		// if hknight shall be replaced by afrit. Check the chance and do it !!)
		{	
		local float replac;		
		replac = autocvar_afrit_replace_hknight * 0.01;
		if (random () <= replac)
			{
			self.health = autocvar_hellknight_health;	// default 250
			self.scale = 1;
			setsize (self, '-16 -16 -24', '16 16 40');
			self.nextthink = time + 0.3;	
			self.think = SUB_Remove;
			monster_afrit_liftorigin_start();
			return;
			}
		}

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

if (autocvar_reiver_supports_hknight)		// if reiver shall be spawned in ADDITION to an existing hknight. Check the chance and do it !!)
	{	
	local float replacce;		
	replacce = autocvar_reiver_supports_hknight * 0.01;
	if (random () <= replacce)
		add_reiver_support_walk ();
	}

if (autocvar_afrit_supports_hknight)		// if afrit shall be spawned in ADDITION to an existing hknight. Check the chance and do it !!)
	{	
	local float replace;		
	replace = autocvar_afrit_supports_hknight * 0.01;
	if (random () <= replace)
		add_afrit_support_walk ();
	}

var float autocvar_hknightmass = 2500;
MonsterPhysics (self, autocvar_hknightmass);
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
void(string modelname, float modelframe) vengeance_hknight; 

==============================================================================
*/


void() vengeance_hknight_end1 = {					// end sequence
	self.alpha = -1;
	te_customflash (self.origin, 500, 0.7, '1 0 0');
	self.nextthink = time + 0.2;
      self.think = SUB_Remove;
};


void() vengeance_hknight_touch = {       // player receives 1-3 damage when he gets touched by vengeance effect

	local float ldmg;
	ldmg = rint(0.5 + (3 * random()));  	// chances=  33%: 1 damage /  33%: 2 damage  /  33%: 3 damage

	 T_Damage (self.enemy, self, self, ldmg);  	// analog to meele attack dog/fiend
	// T_Damage (other, self, self, ldmg); 		// analog to jump damage dog/fiend

	self.touch = SUB_Null; 			// um nicht endlos damage zu kriegen !

		self.think = vengeance_hknight_end1; 
		self.nextthink = time + 0.1;   
};


void() vengeance_hknight_skull =			//  calls skull in skull.qc   
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

	precache_sound("vengeance/skull.wav");	
	precache_sound("vengeance/skulltouch.wav");  
};


									//  from here on: run sequence. 

void() vengeance_hknight_run1 =[	$run1,	vengeance_hknight_run2 ]   {
	ai_face();
 	movetogoal (19);  // orig(20)
self.touch = vengeance_hknight_touch;
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight_run2 =[	$run2,	vengeance_hknight_run3 ]   {
	ai_face();
 	movetogoal (24);   // orig(25)
self.touch = vengeance_hknight_touch;
	self.alpha = 0.37;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight_run3 =[	$run3,	vengeance_hknight_run4 ]    {
	ai_face();
 	movetogoal (17);   // orig(18)
self.touch = vengeance_hknight_touch;
	self.alpha = 0.34;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight_run4 =[	$run4,	vengeance_hknight_run5 ]    {
	ai_face();
 	movetogoal (15);    // orig(16)
self.touch = vengeance_hknight_touch;
	self.alpha = 0.31;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight_run5 =[	$run5,	vengeance_hknight_run6 ]    {
	ai_face();
 	movetogoal (13);   // orig(14)
self.touch = vengeance_hknight_touch;
	self.alpha = 0.28;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight_run6 =[	$run6,	vengeance_hknight_run7 ]    {
	ai_face();
 	movetogoal (24);   // orig(25)
self.touch = vengeance_hknight_touch;
	self.alpha = 0.25;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight_run7 =[	$run7,	vengeance_hknight_random ]    {
	ai_face();
 	movetogoal (20);   // orig(21)
self.touch = vengeance_hknight_touch;
	self.alpha = 0.22;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};


							//  from here on: attack/jump sequenz. 

void() vengeance_hknight_chara1 =[ $char_a1,	vengeance_hknight_chara2 ]    {
	ai_face();
 	movetogoal (19);    // orig(20)
self.touch = vengeance_hknight_touch;
	self.alpha = 0.2;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight_chara2 =[ $char_a2,	vengeance_hknight_chara3 ]    {
	ai_face();
 	movetogoal (24);   // orig(25)
self.touch = vengeance_hknight_touch; 
	self.alpha = 0.17;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight_chara3 =[ $char_a3,	vengeance_hknight_chara4 ]    {
	ai_face();
 	movetogoal (17);   // orig(18)
self.touch = vengeance_hknight_touch;
	self.alpha = 0.14;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight_chara4 =[ $char_a4,	vengeance_hknight_chara5 ]    {
	ai_face();
 	movetogoal (15);   // orig(16)
self.touch = vengeance_hknight_touch;
sound7(self, CHAN_VOICE, "hknight/slash1.wav", 1, 4);
	self.alpha = 0.11;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight_chara5 =[ $char_a5,	vengeance_hknight_chara6 ]    {
	ai_face();
 	movetogoal (13);   // orig(14)
self.touch = vengeance_hknight_touch;
	self.alpha = 0.08;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight_chara6 =[ $char_a6,	vengeance_hknight_end1 ]    {
	ai_face();
 	movetogoal (19);   // orig(20)
self.touch = vengeance_hknight_touch;
	makevectors (self.angles);
	self.origin_z = self.origin_z + 1;
	self.velocity = v_forward * 130 + '0 0 10';
	self.alpha = 0.05;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};


							//  from here on: skull spawn sequenz. 

void() vengeance_hknight_skull1 =[ $magica2,	vengeance_hknight_skull2 ]    {
	ai_face();
self.touch = vengeance_hknight_touch;
	self.alpha = 0.2;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight_skull2 =[ $magica3,	vengeance_hknight_skull3 ]    {
sound7(self, CHAN_VOICE, "vengeance/hknightmag.wav", 0.8, ATTN_NORM, SNDSPD);	
	ai_face();
self.touch = vengeance_hknight_touch; 
	self.alpha = 0.2;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight_skull3 =[ $magica4,	vengeance_hknight_skull4 ]    {
	ai_face();
self.touch = vengeance_hknight_touch;
	self.alpha = 0.2;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight_skull4 =[ $magica5,	vengeance_hknight_skull5 ]    {
	ai_face();
self.touch = vengeance_hknight_touch;
	self.alpha = 0.2;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight_skull5 =[ $magica6,	vengeance_hknight_skull6 ]    {
	ai_face();
self.touch = vengeance_hknight_touch;
	self.alpha = 0.2;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight_skull6 =[ $magica5,	vengeance_hknight_skull7 ]    {
	ai_face();
self.touch = vengeance_hknight_touch;
	self.alpha = 0.2;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight_skull7 =[ $magica8,	vengeance_hknight_skull8 ]    {
	ai_face();
self.touch = vengeance_hknight_touch;
	self.alpha = 0.15;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight_skull8 =[ $magica8,	vengeance_hknight_end1 ]    {
	ai_face();
	movetogoal (2);
self.touch = vengeance_hknight_touch;
	self.alpha = 0.1;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
vengeance_hknight_skull();
};



void()	vengeance_hknight_random 	= {		// random final animation selection
	self.alpha = 0.22;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.01;
		if (random() > 0.45)
			self.think = vengeance_hknight_chara1;
		else
			self.think = vengeance_hknight_skull1;
};


										//  from here on: ressurection sequence 1. 

void() vengeance_hknight11 =[	$death11,	vengeance_hknight12 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight12 =[	$death10,	vengeance_hknight13 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight13 =[	$death9,	vengeance_hknight14 	]  {
	walkmove ( (self.angles_y+180), 11);  
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight14 =[	$death8,	vengeance_hknight15 	]  {
	walkmove ( (self.angles_y+180), 10);  
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight15 =[	$death7,	vengeance_hknight16 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight16 =[	$death6,	vengeance_hknight17 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight17 =[	$death5,	vengeance_hknight18 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight18 =[	$death4,	vengeance_hknight19 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight19 =[	$death3,	vengeance_hknight110 	]  {
sound7(self, CHAN_WEAPON, "hknight/sight1.wav", 1, ATTN_NORM, SNDSPD);
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight110 =[ $death2,	vengeance_hknight111 	]  {
	walkmove ( (self.angles_y+180), 8);  
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight111 =[ $death1,	vengeance_hknight_stand1 ]  {
	walkmove ( (self.angles_y+180), 10);  
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight_stand1 =[ $run8,	vengeance_hknight_run1 ]  {    // needed to make the animation fluent
	self.alpha = 0.4;	 								 // $run8 fills the frame gap	
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};


											//  from here on: ressurection sequence 2. 

void() vengeance_hknight21 =[	$deathb8,	vengeance_hknight22 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight22 =[	$deathb7,	vengeance_hknight23 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight23 =[	$deathb6,	vengeance_hknight24 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight24 =[	$deathb5,	vengeance_hknight25 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight25 =[	$deathb4,	vengeance_hknight26 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight26 =[	$deathb3,	vengeance_hknight27 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight27 =[	$deathb2,	vengeance_hknight28 	]  {
sound7(self, CHAN_WEAPON, "hknight/sight1.wav", 1, ATTN_NORM, SNDSPD);
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight28 =[ $deathb1,	vengeance_hknight_stand2 ]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight_stand2 =[	$stand1,	vengeance_hknight_stand21 ]  {    // needed to make the animation fluent
	self.alpha = 0.4;										    // $stand1 fills the frame gap
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_hknight_stand21 =[ $run8,	vengeance_hknight_run1 ]  {    // needed to make the animation fluent
	self.alpha = 0.4;	 									 // $run8 fills the frame gap
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};



								// from here on:  sequence where the corpse overbrights 
void()	vengeance_hknight_bright05 	= {
	self.alpha = 0.3;
	self.colormod = '6 1 1';
	self.glow_color = 75;
	self.glow_size = 450;
	self.nextthink = time + 0.1;
		if (self.frame == $death12)
			self.think = vengeance_hknight11;
		else
			self.think = vengeance_hknight21;
};
void()	vengeance_hknight_bright04 	= {
	self.alpha = 0.3;
	self.colormod = '5 1 1';
	self.glow_color = 75;
	self.glow_size = 350;
	self.nextthink = time + 0.1;
	self.think = vengeance_hknight_bright05;
};
void()	vengeance_hknight_bright03 	= {
	self.alpha = 0.3;
	self.colormod = '4 1 1';
	self.glow_color = 75;
	self.glow_size = 270;
	self.nextthink = time + 0.1;
	self.think = vengeance_hknight_bright04;
};
void()	vengeance_hknight_bright02 	= {
	self.alpha = 0.3;
	self.colormod = '3 1 1';
	self.glow_color = 75;
	self.glow_size = 185;
	self.nextthink = time + 0.1;
	self.think = vengeance_hknight_bright03;
}; 
void()	vengeance_hknight_bright01 	= {
	self.alpha = 0.3;
	self.colormod = '2 1 1';
	self.glow_color = 75;
	self.glow_size = 100;
	self.nextthink = time + 0.1;
	self.think = vengeance_hknight_bright02;
};
void()	vengeance_hknight_bright00 	= {  			// delay for 0.3 seconds before overbright process really begins
	self.alpha = 0.3;
	self.glow_color = 75;
	self.glow_size = 10;
	self.nextthink = time + 0.3;
	self.think = vengeance_hknight_bright01;
};



void(string modelname, float modelframe) vengeance_hknight =
{

local vector v;  			// v  was necessary at the begining of effect development, but isnt anymore now.

v_x = (self.origin_x);
v_y = (self.origin_y);
v_z = (self.origin_z);

//	precache_model ("progs/skull.mdl");		// precached in worldspawn() due to savegame-bug
//	precache_sound("vengeance/hknightmag.wav");	// precached in worldspawn() due to savegame-bug

      self.origin = v; 
   	self.touch = SUB_Null;                
	self.movetype = MOVETYPE_FLY;
	
	if (self.monstermodel == 0)  
		setmodel (self, "progs/hknight.mdl"); 
	else if (self.monstermodel == 1)  
		setmodel (self, "progs/hknight1.mdl"); 

	setsize (self, '-16 -16 -24', '16 16 40');
	self.frame = modelframe;	 // modelframe is depending on the individual monster (included in vengeance call)

	var float autocvar_vengeancedamage = 0;   // set cvar 'vengeancedamage' default to 0
	if (autocvar_vengeancedamage == 0)	  	// if 'vengeancedamage' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '0'
		self.solid = SOLID_NOT;			// vengeance effect is NOT solid and cannot hurt the player
	else
		self.solid = SOLID_SLIDEBOX;    	// if value is NOT "0", player get hurt from this effect (see func "vengeance_hknight_touch")!

	vengeance_hknight_bright00 ();		// starts the animation
};

