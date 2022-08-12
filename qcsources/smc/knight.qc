/*
==============================================================================

KNIGHT

==============================================================================
*/

$cd id1/models/knight
$origin 0 0 24
$base base
$skin badass3

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9

$frame runb1 runb2 runb3 runb4 runb5 runb6 runb7 runb8

//frame runc1 runc2 runc3 runc4 runc5 runc6

$frame runattack1 runattack2 runattack3 runattack4 runattack5
$frame runattack6 runattack7 runattack8 runattack9 runattack10
$frame runattack11

$frame pain1 pain2 pain3

$frame painb1 painb2 painb3 painb4 painb5 painb6 painb7 painb8 painb9
$frame painb10 painb11

//frame attack1 attack2 attack3 attack4 attack5 attack6 attack7
//frame attack8 attack9 attack10 attack11

$frame attackb1 attackb1 attackb2 attackb3 attackb4 attackb5
$frame attackb6 attackb7 attackb8 attackb9 attackb10

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9
$frame walk10 walk11 walk12 walk13 walk14

$frame kneel1 kneel2 kneel3 kneel4 kneel5

$frame standing2 standing3 standing4 standing5

$frame death1 death2 death3 death4 death5 death6 death7 death8
$frame death9 death10

$frame deathb1 deathb2 deathb3 deathb4 deathb5 deathb6 deathb7 deathb8
$frame deathb9 deathb10 deathb11


void(float loudness) knight_footsteps =
{
if (autocvar_monsterfootsteps == 1)	// only play monster footsteps sound when cvar is 1
	{
	local float select;
	select = random();
	if (select <= 0.33)
		sound(self, CHAN_AUTO, "walk/knight1.wav", loudness, ATTN_IDLE);
	else if (select <= 0.66)
		sound(self, CHAN_AUTO, "walk/knight2.wav", loudness, ATTN_IDLE);
	else 
		sound(self, CHAN_AUTO, "walk/knight3.wav", loudness, ATTN_IDLE);
	}
};


var float autocvar_knightpray = 1;	// set cvar 'knightpray' default to 1.  0= disabled  1= enabled: Knights have a certain chance to play the unused kneel-animation instead of standing. Furthermore they will sometimes fall on their knees and pray during patrol and regular standing animation.


void()	knight_still	=[	$kneel5,	knight_still	] {ai_stand();};	// new alternative stand "animation"

void() knight_pray1;
void()	knight_stand1	=[	$stand1,	knight_stand2	] {ai_stand();};
void()	knight_stand2	=[	$stand2,	knight_stand3	] {ai_stand();};
void()	knight_stand3	=[	$stand3,	knight_stand4	] {ai_stand();};
void()	knight_stand4	=[	$stand4,	knight_stand5	] {ai_stand();};
void()	knight_stand5	=[	$stand5,	knight_stand6	] {ai_stand();};
void()	knight_stand6	=[	$stand6,	knight_stand7	] {ai_stand();};
void()	knight_stand7	=[	$stand7,	knight_stand8	] {ai_stand();};
void()	knight_stand8	=[	$stand8,	knight_stand9	] {ai_stand();};
void()	knight_stand9	=[	$stand9,	knight_stand1	] {ai_stand();
if (autocvar_knightpray == 1)	
	{
	if (random() <= 0.06)		// 6% chance to kneel down and pray while standing
		knight_pray1();
	}
};

void()	knight_walk1	=[	$walk1,		knight_walk2	] {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "knight/idle.wav", 1,  ATTN_IDLE);
ai_walk(3);};
void()	knight_walk2	=[	$walk2,		knight_walk3	] {ai_walk(2);};
void()	knight_walk3	=[	$walk3,		knight_walk4	] {ai_walk(3); knight_footsteps (0.7);};
void()	knight_walk4	=[	$walk4,		knight_walk5	] {ai_walk(4);};
void()	knight_walk5	=[	$walk5,		knight_walk6	] {ai_walk(3);};
void()	knight_walk6	=[	$walk6,		knight_walk7	] {ai_walk(3);};
void()	knight_walk7	=[	$walk7,		knight_walk8	] {ai_walk(3);};
void()	knight_walk8	=[	$walk8,		knight_walk9	] {ai_walk(4);};
void()	knight_walk9	=[	$walk9,		knight_walk10	] {ai_walk(3);};
void()	knight_walk10	=[	$walk10,	knight_walk11	] {ai_walk(3); knight_footsteps (0.7);};
void()	knight_walk11	=[	$walk11,	knight_walk12	] {ai_walk(2);};
void()	knight_walk12	=[	$walk12,	knight_walk13	] {ai_walk(3);};
void()	knight_walk13	=[	$walk13,	knight_walk14	] {ai_walk(4);};
void()	knight_walk14	=[	$walk14,	knight_walk1	] {ai_walk(3);
if (autocvar_knightpray == 1)	
	{
	if (random() <= 0.07)		// 7% chance to kneel down and pray during patrol
		knight_bow1();
	}
};


void()	knight_run1	=[	$runb1,		knight_run2	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);
if (random() < 0.2)
	sound (self, CHAN_VOICE, "knight/idle.wav", 1,  ATTN_IDLE);
ai_run(16);};
void()	knight_run2	=[	$runb2,		knight_run3	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(20); knight_footsteps (0.9);};
void()	knight_run3	=[	$runb3,		knight_run4	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(13);};
void()	knight_run4	=[	$runb4,		knight_run5	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(7);};
void()	knight_run5	=[	$runb5,		knight_run6	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(16);};
void()	knight_run6	=[	$runb6,		knight_run7	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(20); knight_footsteps (0.9);};
void()	knight_run7	=[	$runb7,		knight_run8	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(14);};
void()	knight_run8	=[	$runb8,		knight_run1	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(6);};


void()	knight_runatk1	=[	$runattack1,		knight_runatk2	]
{
if (random() > 0.5)
	sound (self, CHAN_WEAPON, "knight/sword2.wav", 1, ATTN_NORM);
else
	sound (self, CHAN_WEAPON, "knight/sword1.wav", 1, ATTN_NORM);
ai_charge(20);
};
void()	knight_runatk2	=[	$runattack2,	knight_runatk3	] {ai_charge_side();};
void()	knight_runatk3	=[	$runattack3,	knight_runatk4	] {ai_charge_side(); knight_footsteps (0.7);};
void()	knight_runatk4	=[	$runattack4,	knight_runatk5	] {ai_charge_side();};
void()	knight_runatk5	=[	$runattack5,	knight_runatk6	] {ai_melee_side_knight();};
void()	knight_runatk6	=[	$runattack6,	knight_runatk7	] {ai_melee_side_knight(); knight_footsteps (0.6);};
void()	knight_runatk7	=[	$runattack7,	knight_runatk8	] {ai_melee_side_knight();};
void()	knight_runatk8	=[	$runattack8,	knight_runatk9	] {ai_melee_side_knight();};
void()	knight_runatk9	=[	$runattack9,	knight_runatk10	] {ai_melee_side_knight();};
void()	knight_runatk10	=[	$runattack10,	knight_runatk11	] {ai_charge_side();};
void()	knight_runatk11	=[	$runattack11,	knight_run1	] {ai_charge(10);};

void()	knight_atk1	=[	$attackb1,		knight_atk2	]
{
sound (self, CHAN_WEAPON, "knight/sword1.wav", 1, ATTN_NORM);
ai_charge(0);};
void()	knight_atk2	=[	$attackb2,		knight_atk3	] {ai_charge(7);};
void()	knight_atk3	=[	$attackb3,		knight_atk4	] {ai_charge(4);};
void()	knight_atk4	=[	$attackb4,		knight_atk5	] {ai_charge(0); knight_footsteps (0.6);};
void()	knight_atk5	=[	$attackb5,		knight_atk6	] {ai_charge(3);};
void()	knight_atk6	=[	$attackb6,		knight_atk7	] {ai_charge(4); ai_melee_knight();};
void()	knight_atk7	=[	$attackb7,		knight_atk8	] {ai_charge(1); ai_melee_knight();};
void()	knight_atk8	=[	$attackb8,		knight_atk9	] {ai_charge(3);
ai_melee_knight();};
void()	knight_atk9	=[	$attackb9,		knight_atk10	] {ai_charge(1);};
void()	knight_atk10	=[	$attackb10,		knight_run1	] {ai_charge(5); knight_footsteps (0.5);};

//void()	knight_atk9	=[	$attack9,		knight_atk10	] {};
//void()	knight_atk10	=[	$attack10,		knight_atk11	] {};
//void()	knight_atk11	=[	$attack11,		knight_run1	] {};

//===========================================================================

void()	knight_pain1	=[	$pain1,		knight_pain2	] {};
void()	knight_pain2	=[	$pain2,		knight_pain3	] {};
void()	knight_pain3	=[	$pain3,		knight_run1	] {};

void()	knight_painb1	=[	$painb1,	knight_painb2	] {ai_painforward(0);};
void()	knight_painb2	=[	$painb2,	knight_painb3	] {ai_painforward(3);};
void()	knight_painb3	=[	$painb3,	knight_painb4	] {};
void()	knight_painb4	=[	$painb4,	knight_painb5	] {};
void()	knight_painb5	=[	$painb5,	knight_painb6	] {ai_painforward(2);};
void()	knight_painb6	=[	$painb6,	knight_painb7	] {ai_painforward(4);};
void()	knight_painb7	=[	$painb7,	knight_painb8	] {ai_painforward(2); knight_footsteps (0.5);};
void()	knight_painb8	=[	$painb8,	knight_painb9	] {ai_painforward(5);};
void()	knight_painb9	=[	$painb9,	knight_painb10	] {ai_painforward(5); knight_footsteps (0.4);};
void()	knight_painb10	=[	$painb10,	knight_painb11	] {ai_painforward(0);};
void()	knight_painb11	=[	$painb11,	knight_run1	] {};

void(entity attacker, float damage)	knight_pain =
{
	local float r;

	if (self.pain_finished > time)
		return;

	if (autocvar_slowmotion >= 4)	// start slowmotion when hurting enemies
	{
		if (random () <= (autocvar_slowmotion_randomness_knight * 0.01))
			{
			the_matrix = 1;
			matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
			}
	}

	r = random();
	
	sound (self, CHAN_VOICE, "knight/khurt.wav", 1, ATTN_NORM);
	if (r < 0.85)
	{
		knight_pain1 ();
		self.pain_finished = time + 1;
	}
	else
	{
		knight_painb1 ();
		self.pain_finished = time + 1;
	}
	
};

//===========================================================================

void()	knight_bow1	=[	$kneel1,		knight_bow2	] {ai_turn();};
void()	knight_bow2	=[	$kneel2,		knight_bow3	] {ai_turn(); sound(self, CHAN_AUTO, "knight/pray.wav", 1, ATTN_IDLE);};
void()	knight_bow3	=[	$kneel3,		knight_bow4	] {ai_turn();};
void()	knight_bow4	=[	$kneel4,		knight_bow5	] {ai_turn();};
void()	knight_bow5	=[	$kneel5,		knight_bow5a	] {ai_turn(); self.nextthink = time + 0.45;};
void()	knight_bow5a	=[	$kneel5,		knight_bow5b	] {ai_turn(); self.nextthink = time + 0.45;};	
void()	knight_bow5b	=[	$kneel5,		knight_bow5c	] {ai_turn(); self.nextthink = time + 0.45;};	
void()	knight_bow5c	=[	$kneel5,		knight_bow5d	] {ai_turn(); self.nextthink = time + 0.45;};	
void()	knight_bow5d	=[	$kneel5,		knight_bow6	] {ai_turn(); self.nextthink = time + 0.45;};
void()	knight_bow6	=[	$kneel4,		knight_bow7	] {ai_turn();};
void()	knight_bow7	=[	$kneel3,		knight_bow8	] {ai_turn();};
void()	knight_bow8	=[	$kneel2,		knight_bow9	] {ai_turn();};
void()	knight_bow9	=[	$kneel1,		knight_bow10	] {ai_turn();};
void()	knight_bow10	=[	$walk1,			knight_walk1	] {ai_turn();};


void()	knight_pray1	=[	$kneel1,		knight_pray2	] {ai_stand();};
void()	knight_pray2	=[	$kneel2,		knight_pray3	] {ai_stand(); sound(self, CHAN_AUTO, "knight/pray.wav", 1, ATTN_IDLE);};
void()	knight_pray3	=[	$kneel3,		knight_pray4	] {ai_stand();};
void()	knight_pray4	=[	$kneel4,		knight_pray5	] {ai_stand();};
void()	knight_pray5	=[	$kneel5,		knight_pray5a	] {ai_stand(); self.nextthink = time + 0.45;};	
void()	knight_pray5a	=[	$kneel5,		knight_pray5b	] {ai_stand(); self.nextthink = time + 0.45;};	
void()	knight_pray5b	=[	$kneel5,		knight_pray5c	] {ai_stand(); self.nextthink = time + 0.45;};	
void()	knight_pray5c	=[	$kneel5,		knight_pray5d	] {ai_stand(); self.nextthink = time + 0.45;};	
void()	knight_pray5d	=[	$kneel5,		knight_pray6	] {ai_stand(); self.nextthink = time + 0.45;};	
void()	knight_pray6	=[	$kneel4,		knight_pray7	] {ai_stand();};
void()	knight_pray7	=[	$kneel3,		knight_pray8	] {ai_stand();};
void()	knight_pray8	=[	$kneel2,		knight_pray9	] {ai_stand();};
void()	knight_pray9	=[	$kneel1,		knight_pray10	] {ai_stand();};
void()	knight_pray10	=[	$stand1,		knight_stand1	] {ai_stand();};


void() knight_dieburn1	=[	$death1,	knight_dieburn2	] {self.burnz_origin = 12;
burn_toggle_allround();
};
void() knight_dieburn2	=[	$death2,	knight_dieburn3	] {self.burnz_origin = 11;
};
void() knight_dieburn3	=[	$death3,	knight_dieburn4	] {self.burnz_origin = 6;
self.solid = SOLID_NOT;
};
void() knight_dieburn4	=[	$death4,	knight_dieburn5	] {self.burnz_origin = 3;
};
void() knight_dieburn5	=[	$death5,	knight_dieburn6	] {self.burnz_origin = 0;
};
void() knight_dieburn6	=[	$death6,	knight_dieburn7	] {self.burnz_origin = -2;
};
void() knight_dieburn7	=[	$death7,	knight_dieburn8	] {self.burnz_origin = -5;
};
void() knight_dieburn8	=[	$death8,	knight_dieburn9	] {self.burnz_origin = -7;
};
void() knight_dieburn9	=[	$death9,	knight_dieburn9	] {self.burnz_origin = -9;
};


var float autocvar_knight = 5;     		// set cvar 'knight' default to 5
var float autocvar_knightcorpsehealth = 60;	// set cvar 'knightcorpsehealth' default to 60
var float autocvar_knightcorpseburnable = 0;	// set cvar 'knightcorpseburnable' default to 0

void()	knight_die1	=[	$death1,	knight_die2	] {};
void()	knight_die2	=[	$death2,	knight_die3	] {};
void()	knight_die3	=[	$death3,	knight_die4	] 
{self.solid = SOLID_NOT;};
void()	knight_die4	=[	$death4,	knight_die5	] {};
void()	knight_die5	=[	$death5,	knight_die6	] {};
void()	knight_die6	=[	$death6,	knight_die7	] {};
void()	knight_die7	=[	$death7,	knight_die8	] { sound (self, CHAN_AUTO, "knight/fall_backwards.wav", 1, ATTN_IDLE);};
void()	knight_die8	=[	$death8,	knight_die9	] {};
void()	knight_die9	=[	$death9,	knight_die10] {};
void()	knight_die10=[	$death10,	knight_die10] {
if (self.inflamed == 1)
{
	inflamed_die ();
	return;
}
local float zufall, zet, randomness;
	zet = 20;					// z-position of the wings (in relation to soul). Dependent on corpse size.
	if (autocvar_knightcorpseburnable == 1)		// corpses are burnable
		self.burnable_corpse = 1;
// 	auto_cvar 'knightcorpsehealth' has been set to  default = 60  in code above already
	self.delete_painskin = 1;		 	 // remove painskin
	if (self.monstermodel == 0)  
		CopyMonsterToBodyQue(autocvar_knightcorpsehealth, "progs/h_knight.mdl");
	if (self.monstermodel == 1)  
		CopyMonsterToBodyQue(autocvar_knightcorpsehealth, "progs/h_knight1.mdl");
if (self.nodeathanim == 1)
	return;
if (self.grimrock_helper == 0)
{
// 	auto_cvar 'knight' has been declared in code above already
	var float autocvar_knightrandomness = 20;     	// set cvar 'knightrandomness' default to 20%
	autocvar_knightrandomness = autocvar_knightrandomness * 0.01;
	if (autocvar_knight == 1)		// if 'knight' is set via autoexec.cfg to '1' start ghost effect
		{
		randomness = random();
		if (randomness <= autocvar_knightrandomness)	// checks if death animation shall be started
			ghost_die ();
		}
	else if (autocvar_knight == 2)	// if 'knight' is set via autoexec.cfg to '2' start soul effect
		{
		randomness = random();
		if (randomness <= autocvar_knightrandomness)	// checks if death animation shall be started
			{
			if (self.monstermodel == 0)  
				soul ("progs/knight.mdl", $death10, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
			else if (self.monstermodel == 1)  
				soul ("progs/knight1.mdl", $death10, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
			}
		}
	else if (autocvar_knight == 3)	// if 'knight' is set via autoexec.cfg to '3' start vengeance effect
		{
		randomness = random();
		if (randomness <= autocvar_knightrandomness)	// checks if death animation shall be started
			vengeance_knight ("progs/knight.mdl", $death10); 
		}
	else if (autocvar_knight == 5)		// if 'knight' is set via autoexec.cfg to '5' start randomly one of these Death animations: 
		{				// (Ancient ghosts of the fallen ; Relieved souls of the enslaved ; Vengeance of the deceased)	
		randomness = random();		// chance for effects (approx.): 36% / 26% / 38%
		if (randomness <= autocvar_knightrandomness)	// checks if death animation shall be started --> depending on monsters _randomness
			{					
			zufall = random();
			if (zufall > 0.64)
				ghost_die ();
			else if (zufall < 0.26)
				{
				if (self.monstermodel == 0)  
					soul ("progs/knight.mdl", $death10, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
				else if (self.monstermodel == 1)  
					soul ("progs/knight1.mdl", $death10, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
				}
			else
				vengeance_knight ("progs/knight.mdl", $death10);
			}
		}
	else				// if 'knight' is set via autoexec.cfg to another value (example '0'), do nothing !
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
			soul ("progs/knight.mdl", $death10, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
		else if (self.monstermodel == 1)  
			soul ("progs/knight1.mdl", $death10, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
		}
	else
		vengeance_knight ("progs/knight.mdl", $death10);
	}
};


void()	knight_dieb1	=[	$deathb1,	knight_dieb2	] {};
void()	knight_dieb2	=[	$deathb2,	knight_dieb3	] {};
void()	knight_dieb3	=[	$deathb3,	knight_dieb4	] 	
{self.solid = SOLID_NOT;};
void()	knight_dieb4	=[	$deathb4,	knight_dieb5	] {};
void()	knight_dieb5	=[	$deathb5,	knight_dieb6	] {};
void()	knight_dieb6	=[	$deathb6,	knight_dieb7	] {};
void()	knight_dieb7	=[	$deathb7,	knight_dieb8	] {};
void()	knight_dieb8	=[	$deathb8,	knight_dieb9	] {};
void()	knight_dieb9	=[	$deathb9,	knight_dieb10	] { sound (self, CHAN_AUTO, "knight/fall_forwards.wav", 1, ATTN_IDLE);};
void()	knight_dieb10 = [	$deathb10,	knight_dieb11	] {};
void()	knight_dieb11 = [	$deathb11,	knight_dieb11	] {
if (self.inflamed == 1)
{
	inflamed_die ();
	return;
}
local float zufall, zet, randomness;
	zet = 20;					// z-position of the wings (in relation to soul). Dependent on corpse size.
	if (autocvar_knightcorpseburnable == 1)		// corpses are burnable
		self.burnable_corpse = 1;
// 	auto_cvar 'knightcorpsehealth' has been set to  default = 60  in code above already
	self.delete_painskin = 1;		 	 // remove painskin
	if (self.monstermodel == 0)  
		CopyMonsterToBodyQue(autocvar_knightcorpsehealth, "progs/h_knight.mdl");
	if (self.monstermodel == 1)  
		CopyMonsterToBodyQue(autocvar_knightcorpsehealth, "progs/h_knight1.mdl");
if (self.nodeathanim == 1)
	return;
if (self.grimrock_helper == 0)
{
// 	auto_cvar 'knight' has been declared in code above already
	var float autocvar_knightrandomness = 20;     	// set cvar 'knightrandomness' default to 20%
	autocvar_knightrandomness = autocvar_knightrandomness * 0.01;
	if (autocvar_knight == 1)		// if 'knight' is set via autoexec.cfg to '1' start ghost effect
		{
		randomness = random();
		if (randomness <= autocvar_knightrandomness)	// checks if death animation shall be started
			ghost_die ();
		}
	else if (autocvar_knight == 2)	// if 'knight' is set via autoexec.cfg to '2' start soul effect
		{
		randomness = random();
		if (randomness <= autocvar_knightrandomness)	// checks if death animation shall be started
			{
			if (self.monstermodel == 0)  
				soul ("progs/knight.mdl", $deathb11, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
			else if (self.monstermodel == 1)  
				soul ("progs/knight1.mdl", $deathb11, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
			}
		}
	else if (autocvar_knight == 3)	// if 'knight' is set via autoexec.cfg to '3' start vengeance effect
		{
		randomness = random();
		if (randomness <= autocvar_knightrandomness)	// checks if death animation shall be started
			vengeance_knight ("progs/knight.mdl", $deathb11); 
		}
	else if (autocvar_knight == 5)		// if 'knight' is set via autoexec.cfg to '5' start randomly one of these Death animations: 
		{				// (Ancient ghosts of the fallen ; Relieved souls of the enslaved ; Vengeance of the deceased)	
		randomness = random();		// chance for effects (approx.): 36% / 26% / 38%
		if (randomness <= autocvar_knightrandomness)	// checks if death animation shall be started --> depending on monsters _randomness
			{				
			zufall = random();
			if (zufall > 0.64)
				ghost_die ();
			else if (zufall < 0.26)
				{
				if (self.monstermodel == 0)  
					soul ("progs/knight.mdl", $deathb11, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
				else if (self.monstermodel == 1)  
					soul ("progs/knight1.mdl", $deathb11, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
				}
			else
				vengeance_knight ("progs/knight.mdl", $deathb11);
			}
		}
	else				// if 'knight' is set via autoexec.cfg to another value (example '0'), do nothing !
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
			soul ("progs/knight.mdl", $deathb11, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
		else if (self.monstermodel == 1)  
			soul ("progs/knight1.mdl", $deathb11, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
		}
	else
		vengeance_knight ("progs/knight.mdl", $deathb11);
	}
};


void(float maxgibs, float gibscounter) producegibs_knight =		// creates as many gib-sets as defined in cvar 'gibsmultiplier'
{
if (gibscounter >= maxgibs)
	return;
else
	{
	ThrowGib ("progs/gib1.mdl", self.health);
	ThrowGib ("progs/gib2.mdl", self.health);
	ThrowGib ("progs/gib3.mdl", self.health);   	
	}

gibscounter = gibscounter + 1;
producegibs_knight (maxgibs, gibscounter);
};


void()	knight_lightning_death	=[	$pain1,	knight_lightning_death1	] {
self.delete_painskin = 1;			  // remove painskin
if (autocvar_lightninggun_death_animation == 2)	  // start the "fade" effect instead of "coal" effect
	lightninggun_death_fade();
};

void()	knight_lightning_death1	=[	$pain1,	knight_lightning_death1	] {
self.solid = SOLID_NOT;
self.baked = 1;
self.colormod = '0.25 0.22 0.22';	// skins gets darker (looks burned)
if (self.monstermodel == 0)  
	CopyMonsterToBodyQue(1, "progs/h_knight.mdl");
if (self.monstermodel == 1)  
	CopyMonsterToBodyQue(1, "progs/h_knight1.mdl");
};


void() knight_die;
void() knight_inflamed9;
void() knight_inflamed12;

void()	knight_inflamed1 =[	$runb1,	knight_inflamed2 ] {ai_run_inflamed(16); self.nextthink = time + 0.09;
if (random() < 0.8)
	sound (self, CHAN_VOICE, "knight/khurt1.wav", 1, ATTN_NORM);
};
void()	knight_inflamed2 =[	$runb2,	knight_inflamed3 ] {ai_run_inflamed(20); knight_footsteps (0.9);self.nextthink = time + 0.09;};
void()	knight_inflamed3 =[	$runb3,	knight_inflamed4 ] {ai_run_inflamed(13);self.nextthink = time + 0.09;};
void()	knight_inflamed4 =[	$runb4,	knight_inflamed5 ] {ai_run_inflamed(7);self.nextthink = time + 0.09;};
void()	knight_inflamed5 =[	$runb5,	knight_inflamed6 ] {ai_run_inflamed(16);self.nextthink = time + 0.09;};
void()	knight_inflamed6 =[	$runb6,	knight_inflamed7 ] {ai_run_inflamed(20); knight_footsteps (0.9);self.nextthink = time + 0.09;};
void()	knight_inflamed7 =[	$runb7,	knight_inflamed8 ] {ai_run_inflamed(14);self.nextthink = time + 0.09;
if (self.inflametime < time)
{
	knight_die ();
	return;
}
local float r;
r = random();
if (r < 0.22)
	knight_inflamed9 ();	// pain anim (lean back)
else if (r < 0.47)
	knight_inflamed12 ();	// pain anim (hold throat)
};
void()	knight_inflamed8 =[	$runb8,	knight_inflamed1 ] {ai_run_inflamed(6);self.nextthink = time + 0.09;};

void()	knight_inflamed9 =[	$pain1,	knight_inflamed10 ] {
if (random() < 0.6)
	sound (self, CHAN_VOICE, "knight/khurt1.wav", 1, ATTN_NORM);
};
void()	knight_inflamed10 =[	$pain2,	knight_inflamed11 ] {};
void()	knight_inflamed11 =[	$pain3,	knight_inflamed8 ] {
if (self.inflametime < time)
{
	knight_die ();
	return;
}
};

void()	knight_inflamed12 =[	$painb1, knight_inflamed13 ] {ai_painforward(0);self.nextthink = time + 0.08;
if (random() < 0.8)
	sound (self, CHAN_VOICE, "knight/khurt1.wav", 1, ATTN_NORM);
};
void()	knight_inflamed13 =[	$painb2, knight_inflamed14 ] {ai_painforward(3);self.nextthink = time + 0.08;};
void()	knight_inflamed14 =[	$painb3, knight_inflamed15 ] {self.nextthink = time + 0.08;};
void()	knight_inflamed15 =[	$painb4, knight_inflamed16 ] {self.nextthink = time + 0.08;};
void()	knight_inflamed16 =[	$painb5, knight_inflamed17 ] {ai_painforward(2);self.nextthink = time + 0.08;};
void()	knight_inflamed17 =[	$painb6, knight_inflamed18 ] {ai_painforward(4);self.nextthink = time + 0.08;};
void()	knight_inflamed18 =[	$painb7, knight_inflamed19 ] {ai_painforward(2); knight_footsteps (0.5);self.nextthink = time + 0.08;};
void()	knight_inflamed19 =[	$painb8, knight_inflamed20 ] {ai_painforward(5);self.nextthink = time + 0.08;};
void()	knight_inflamed20 =[	$painb9, knight_inflamed21 ] {ai_painforward(5); knight_footsteps (0.4);self.nextthink = time + 0.08;};
void()	knight_inflamed21 =[	$painb10, knight_inflamed22 ] {ai_painforward(0);self.nextthink = time + 0.08;};
void()	knight_inflamed22 =[	$painb11, knight_inflamed8 ] {self.nextthink = time + 0.08;
if (self.inflametime < time)
{
	knight_die ();
	return;
}
};




void() knight_die =
{
	if (autocvar_lightninggun_death_animation)		// if 'lightninggun_death_animation' is enabled
	{
		if (self.enemy.weapon == IT_LIGHTNING)		// when enemy was killed with lightning gun, go into baked mode
		{
			knight_lightning_death();
			return;
		}
	}
local float maxgibs, gibscounter;
// check for gib
	if (self.health < -40)
	{
		if ((!cvar("chase_active")) && (self.enemy.classname == "player") && (autocvar_HUD_blood_splatter))	// we are in 1st person mode
		{
			if (vlen (self.enemy.origin - self.origin) < autocvar_HUD_blood_splatter)
				blood_HUD_splat = 1;
		}

		self.delete_painskin = 1;	// remove painskin
		gibbed_monsters = gibbed_monsters + 1;
		if (autocvar_slowmotion >= 1)	// start slowmotion when gibbing living enemies
			{
			if (random () <= (autocvar_slowmotion_randomness_knight * 0.01))
				{
				the_matrix = 1;
				matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
				}
			}
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		var float autocvar_gibsmultiplier = 1;         	// set cvar 'gibsmultiplier' default to 1
			if (autocvar_gibsmultiplier == 1)		// if 'gibsmultiplier' doesnt exist in autoexec.cfg, or if 'gibsmultiplier' is set via autoexec.cfg to '1'
				{
				if (self.monstermodel == 0)  
					ThrowHead ("progs/h_knight.mdl", self.health);
				else if (self.monstermodel == 1)  
					ThrowHead ("progs/h_knight1.mdl", self.health);
				ThrowGib ("progs/gib1.mdl", self.health);
				ThrowGib ("progs/gib2.mdl", self.health);
				ThrowGib ("progs/gib3.mdl", self.health);
				if (autocvar_heartgib >= 1)		// if 'heartgib' doesnt exist in autoexec.cfg, or if 'heartgib' is set via autoexec.cfg to '1' or higher
					ThrowHeart ("progs/gibheart.mdl", self.health);
				if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
					pointparticles(particleeffectnum("blood_monster_gib"), self.origin, '0 0 0', 1);
				return;
				}
			else 							// if 'gibsmultiplier' is set via autoexec.cfg to any other value than '1'
				{						// --> produce more gibs
				if (self.monstermodel == 0)  
					ThrowHead ("progs/h_knight.mdl", self.health);
				else if (self.monstermodel == 1)  
					ThrowHead ("progs/h_knight1.mdl", self.health);
				if (autocvar_heartgib >= 1)		// if 'heartgib' doesnt exist in autoexec.cfg, or if 'heartgib' is set via autoexec.cfg to '1' or higher
					ThrowHeart ("progs/gibheart.mdl", self.health);
				maxgibs = autocvar_gibsmultiplier;
				gibscounter = 0;
				if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
					pointparticles(particleeffectnum("blood_monster_gib"), self.origin, '0 0 0', 1);
				producegibs_knight (maxgibs, gibscounter);
				return;
				}
	}

	if (autocvar_burning_monsters_death_animation)		// if 'burning_monsters_death_animation' is enabled
	{
		if (self.inflamed == 0)		// enemy is not burning
		{
			local float zufa;
			zufa = random() * 100;
			if (((self.enemy.weapon == IT_GRENADE_LAUNCHER) || (self.enemy.weapon == IT_ROCKET_LAUNCHER)) && (zufa <= autocvar_burning_monsters_death_animation) && (self.watertype != CONTENT_WATER))	// when enemy was killed with explosives, set it on fire
			{
				self.delete_painskin = 1;	// remove painskin
				self.inflamed = 1;
				self.traileffectnum = particleeffectnum("burning_monster");
				self.inflametime = time + autocvar_burning_monsters_death_animation_time + random();
				knight_inflamed1 ();
				return;
			}
		}
		else		// enemy is burning already and his "run-around-in-panic-time" has just ended
		{
			sound (self, CHAN_VOICE, "knight/kdeath1.wav", 1, ATTN_NORM);
			if (random() < 0.5)
				knight_die1 ();
			else
				knight_dieb1 ();
			return;
		}
	}

// regular death

local float zufall, randomness;
// auto_cvar 'knight' has been declared in code above already
var float autocvar_knightrandomness = 20;     	// set cvar 'knightrandomness' default to 20%
autocvar_knightrandomness = autocvar_knightrandomness * 0.01;
if (autocvar_knight == 4)		// if 'knight' is set via autoexec.cfg to '4' start Death animation with "Legend of Grimrock" effect
	{
	randomness = random();
	if (randomness <= autocvar_knightrandomness)	// checks if death animation shall be started
		{
		//Gyro_Object_ClearPhysics(self);	// ENABLE this line if you want to disable GYRO during new "Legend of Grimrock" animation !!
		self.delete_painskin = 1;		// remove painskin
		knight_dieburn1();
		return;			// jump out of this function !!
		}
	}
if (autocvar_knight == 6)		// if 'knight' is set via autoexec.cfg to '6' start random Death animation (all 4 effects !!)
	{				// chance for effects (approx.): 25% / 25% / 25% / 25%  
	randomness = random();
	if (randomness <= autocvar_knightrandomness)	// checks if death animation shall be started --> depending on monsters _randomness
		{					
		zufall = random();
		if (zufall <= 0.26)
			{
			//Gyro_Object_ClearPhysics(self);   // ENABLE this line if you want to disable GYRO during new "Legend of Grimrock" animation !!
			self.delete_painskin = 1;	    // remove painskin
			knight_dieburn1();
			return;		// jump out of this function !!
			}		// if zufall is bigger than 0.26, use new code inside  upcoming function  for other 3 death animations
		else 
			self.grimrock_helper = 1;	// this float helps me to manipulate the other 3 death animations
		}
	else
		self.grimrock_helper = 2;	// this float helps me to manipulate the other 3 death animations
	}
	
// if 'knight' has another value is checked inside prior function (= death animation function)

	if (autocvar_slowmotion >= 3)	// start slowmotion when regular killing living enemies
		{
		if (random () <= (autocvar_slowmotion_randomness_knight * 0.01))
			{
			the_matrix = 1;
			matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
			}
		}
	sound (self, CHAN_VOICE, "knight/kdeath.wav", 1, ATTN_NORM);
	if (random() < 0.5)
		knight_die1 ();
	else
		knight_dieb1 ();
};


void() knight_random_stand =		// adds random stand animation: "kneel"
{					// in original ID1, the "kneel" animation-framegroup was not used. It is so beautiful that I want to bring it in with a 20% chance.
	if (random() < 0.8)
		self.th_stand = knight_stand1;
	else 
		self.th_stand = knight_still;	
};


/*QUAKED monster_knight (1 0 0) (-16 -16 -24) (16 16 40) Ambush
*/
void() monster_knight =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	precache_model ("progs/knight.mdl");
	precache_model ("progs/h_knight.mdl");

	precache_sound ("knight/kdeath.wav");
	precache_sound ("knight/khurt.wav");
	precache_sound ("knight/kdeath1.wav");
	precache_sound ("knight/khurt1.wav");
	precache_sound ("knight/ksight.wav");
	precache_sound ("knight/sword1.wav");
	precache_sound ("knight/sword2.wav");
	precache_sound ("knight/idle.wav");
	precache_sound ("knight/fall_backwards.wav");
	precache_sound ("knight/fall_forwards.wav");
	precache_sound ("knight/pray.wav");
	precache_sound ("walk/knight1.wav");
	precache_sound ("walk/knight2.wav");
	precache_sound ("walk/knight3.wav");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	
var float autocvar_knightmultiskin = 0;     	// set cvar 'knightmultiskin' default to 0
	local float zufall;
	if (autocvar_knightmultiskin == 1)		// if 'knightmultiskin' is set via autoexec.cfg to '1' use 2 different skins for ID1 model
	{
		self.multiskin = 1;
		setmodel (self, "progs/knight.mdl");
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
	else if (autocvar_knightmultiskin == 2)	// if 'knightmultiskin' is set via autoexec.cfg to '2' use 1 Id1 model skin AND external model
	{
		self.multiskin = 2;
		precache_model ("progs/knight1.mdl");
		precache_model ("progs/h_knight1.mdl");
		zufall = random();
		if (zufall >= 0.5)
			{
			setmodel (self, "progs/knight.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 0;
			}
		else 
			{
			setmodel (self, "progs/knight1.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 1;
			}
	}
	else if (autocvar_knightmultiskin == 3)	// if 'knightmultiskin' is set via autoexec.cfg to '3' use 2 Id1 model skins AND external model
	{
		self.multiskin = 3;
		precache_model ("progs/knight1.mdl");
		precache_model ("progs/h_knight1.mdl");
		zufall = random();
		if (zufall > 0.66)
			{
			setmodel (self, "progs/knight.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 0;
			}
		else if (zufall < 0.34)
			{
			setmodel (self, "progs/knight.mdl");
			self.skin = 1;
			self.monsterskin = 1;
			self.monstermodel = 0;
			}
		else
			{
			setmodel (self, "progs/knight1.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 1;
			}
	}
	else if (autocvar_knightmultiskin == 4)	// if 'knightmultiskin' is set via autoexec.cfg to '4' use 2 Id1 model skins AND 2 external model skins
	{
		self.multiskin = 4;
		precache_model ("progs/knight1.mdl");
		precache_model ("progs/h_knight1.mdl");
		zufall = random();
		if (zufall > 0.75)
			{
			setmodel (self, "progs/knight.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 0;
			}
		else if (zufall > 0.5 && zufall <= 0.75)
			{
			setmodel (self, "progs/knight.mdl");
			self.skin = 1;
			self.monsterskin = 1;
			self.monstermodel = 0;
			}
		else if (zufall > 0.25 && zufall <= 0.5)
			{
			setmodel (self, "progs/knight1.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 1;
			}
		else 
			{
			setmodel (self, "progs/knight1.mdl");
			self.skin = 1;
			self.monsterskin = 1;
			self.monstermodel = 1;
			}
	}
	else						// standard Quake
		{
		setmodel (self, "progs/knight.mdl");
		self.skin = 0;
		self.monsterskin = 0;
		self.monstermodel = 0;
		}

var float autocvar_knight_size = 2;     	// set cvar 'knight_size' default to 2
	local float zuffa;
	if (autocvar_knight_size == 1)		// if 'knight_size' is set via autoexec.cfg to '1' give monster random size between 100% and 114% (7% steps due to DP´s .scale restrictions)
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
	else if (autocvar_knight_size == 2)		// if 'knight_size' is set via autoexec.cfg to '2' give monster random size between 100% and 121% (7% steps due to DP´s .scale restrictions)
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
	else if (autocvar_knight_size == 3)		// if 'knight_size' is set via autoexec.cfg to '3' give monster random size between 100% and 128% (7% steps due to DP´s .scale restrictions)
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
	else if (autocvar_knight_size == 4)		// if 'knight_size' is set via autoexec.cfg to '4' give monster random size between 100% and 135% (7% steps due to DP´s .scale restrictions)
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
	else if (autocvar_knight_size > 4)		// if 'knight_size' is set via autoexec.cfg to a value bigger than '4' give monster the selected fixed size ==>  100% + [value]%  (7% steps due to DP´s .scale restrictions)
	{
		if (autocvar_knight_size > 40)
			self.origin = self.origin + '0 0 10';		// might get stuck in floor otherwise. --> drop him to floor from higher position !
		self.scale = 1 + (autocvar_knight_size * 0.01);
		self.sizefactor_x = 0;
		self.sizefactor_y = 0;
		self.sizefactor_z = autocvar_knight_size * 0.25;
		self.sizediff = self.sizefactor;
		setsize (self, '-16 -16 -24' - self.sizediff, '16 16 40' - self.sizediff);
	}
	else
	{
		self.scale = 1;
		setsize (self, '-16 -16 -24', '16 16 40');
	}

var float autocvar_knight_size_influenced_health = 0; 		  	// set cvar 'knight_size_influenced_health' default to 0
	if (autocvar_knight_size_influenced_health == 1)		// if 'knight_size_influenced_health' is set via autoexec.cfg to '1' raise monster´s health according to its size  (use different formular for monsters with default health <100 and health >100 to be realistic/noticable)
		self.health = autocvar_knight_health + ((self.scale - 1) * 100);  // default: 75
	else
		self.health = autocvar_knight_health;				  // default 75
	self.health_initial = self.health;

	if (autocvar_monster_random_skin_color_alteration && autocvar_knight_random_skin_colors)	// modify/edit this monster types skin textures randomly (for higher variation in-game)
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

	if (autocvar_knightpray == 1)	
		self.th_stand = knight_random_stand;
	else
		self.th_stand = knight_stand1;
	self.th_walk = knight_walk1;
	self.th_run = knight_run1;
	self.th_melee = knight_atk1;
	self.th_pain = knight_pain;
	self.th_die = knight_die;
	
	self.alpha = autocvar_monstertransparency * 0.01;

	if (autocvar_yakman_replace_knight)	// if knight shall be replaced by Yakman. Check the chance and do it !!)
		{	
		local float replacerrrrr;		
		replacerrrrr = autocvar_yakman_replace_knight * 0.01;
		if (random () <= replacerrrrr)
			{
			self.health = autocvar_knight_health + 50;		// default 75 + 50
			self.scale = 1;
			setsize (self, '-16 -16 -24', '16 16 40');
			self.nextthink = time + 0.3;	
			self.think = SUB_Remove;
			monster_yakman_start();
			return;
			}
		}

	if (autocvar_carnivean_replace_knight)	// if knight shall be replaced by Carnivean. Check the chance and do it !!)
		{	
		local float replacerrrr;		
		replacerrrr = autocvar_carnivean_replace_knight * 0.01;
		if (random () <= replacerrrr)
			{
			self.health = autocvar_knight_health;		// default 75
			self.scale = 1;
			setsize (self, '-16 -16 -24', '16 16 40');
			self.nextthink = time + 0.3;	
			self.think = SUB_Remove;
			monster_carnivean_start();
			return;
			}
		}

	if (autocvar_torment_replace_knight)	// if knight shall be replaced by Torment. Check the chance and do it !!)
		{	
		local float replacerrr;		
		replacerrr = autocvar_torment_replace_knight * 0.01;
		if (random () <= replacerrr)
			{
			self.health = autocvar_knight_health;		// default 75
			self.scale = 1;
			setsize (self, '-16 -16 -24', '16 16 40');
			self.nextthink = time + 0.3;	
			self.think = SUB_Remove;
			monster_torment_start();
			return;
			}
		}

	if (autocvar_spider_replace_knight)		// if knight shall be replaced by spider. Check the chance and do it !!)
		{	
		local float replacer;		
		replacer = autocvar_spider_replace_knight * 0.01;
		if (random () <= replacer)
			{
			 local vector check;
			 check = (self.origin - ((VEC_HULL2_MIN + VEC_HULL2_MAX) * 0.5)) + '0 0 1';
			 if (((pointcontents(check) == CONTENT_WATER) && (autocvar_spider_can_spawn_in_water)) || (pointcontents(check) != CONTENT_WATER)) 	   // checks if monster is spawned in water. Spider is too small to be visible in shallow (not transparent) water, so better not change to spider.
				{
				self.skin = 0;
				self.health = autocvar_knight_health;		// default 75
				self.scale = 1;
				setsize (self, '-16 -16 -24', '16 16 40');
				self.nextthink = time + 0.3;	
				self.think = SUB_Remove;
				monster_spider_start();
				return;
				}
			}
		}

	if (autocvar_reiver_replace_knight)		// if knight shall be replaced by reiver. Check the chance and do it !!)
		{	
		local float replacez;		
		replacez = autocvar_reiver_replace_knight * 0.01;
		if (random () <= replacez)
			{
			self.health = autocvar_knight_health + 25;		// default 75 + 25
			self.scale = 1;
			setsize (self, '-16 -16 -24', '16 16 40');
			self.nextthink = time + 0.3;	
			self.think = SUB_Remove;
			monster_reiver_liftorigin_start();
			return;
			}
		}
		
	if (autocvar_afrit_replace_knight)		// if knight shall be replaced by afrit. Check the chance and do it !!)
		{	
		local float replac;		
		replac = autocvar_afrit_replace_knight * 0.01;
		if (random () <= replac)
			{
			self.health = autocvar_knight_health;		// default 75
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

if (autocvar_reiver_supports_knight)		// if reiver shall be spawned in ADDITION to an existing knight. Check the chance and do it !!)
	{	
	local float replacce;		
	replacce = autocvar_reiver_supports_knight * 0.01;
	if (random () <= replacce)
		add_reiver_support_walk ();
	}

if (autocvar_afrit_supports_knight)		// if afrit shall be spawned in ADDITION to an existing knight. Check the chance and do it !!)
	{	
	local float replace;		
	replace = autocvar_afrit_supports_knight * 0.01;
	if (random () <= replace)
		add_afrit_support_walk ();
	}

var float autocvar_knightmass = 2000;
MonsterPhysics (self, autocvar_knightmass);	
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

This function must be declared at the end of defs.qc:
void(string modelname, float modelframe) vengeance_knight; 

==============================================================================
*/


void() vengeance_knight_end1 = {					// end sequence
	self.alpha = -1;
	te_customflash (self.origin, 500, 0.7, '1 0 0');
	self.nextthink = time + 0.2;
      self.think = SUB_Remove;
};


void() vengeance_knight_touch = {       // player receives 1-3 damage when he gets touched by vengeance effect

	local float ldmg;
	ldmg = rint(0.5 + (3 * random()));  	// chances=  33%: 1 damage /  33%: 2 damage  /  33%: 3 damage

	T_Damage (self.enemy, self, self, ldmg);  	// analog to meele attack dog/fiend
	// T_Damage (other, self, self, ldmg); 		// analog to jump damage dog/fiend

	self.touch = SUB_Null;			 // um nicht endlos damage zu kriegen !

		self.think = vengeance_knight_end1; 
		self.nextthink = time + 0.1;    	
};
										//  from here on: run sequence. 

void() vengeance_knight_run1 =[	$runb1,	vengeance_knight_run2 ]   {
	ai_face();
 	movetogoal (20);   // orig (16)
self.touch = vengeance_knight_touch;
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_knight_run2 =[	$runb2,	vengeance_knight_run3 ]   {
	ai_face();
 	movetogoal (24);    // orig (20)
self.touch = vengeance_knight_touch;
	self.alpha = 0.36;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_knight_run3 =[	$runb3,	vengeance_knight_run4 ]    {
	ai_face();
 	movetogoal (17);   // orig (13)
self.touch = vengeance_knight_touch;
	self.alpha = 0.32;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_knight_run4 =[	$runb4,	vengeance_knight_run5 ]    {
	ai_face();
 	movetogoal (11);   // orig (7)
self.touch = vengeance_knight_touch;
	self.alpha = 0.28;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_knight_run5 =[	$runb5,	vengeance_knight_runattack1 ]    {
	ai_face();
 	movetogoal (20);   // orig (16)
self.touch = vengeance_knight_touch;
	self.alpha = 0.24;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};

								//  from here on: attack/jump sequenz. 

void() vengeance_knight_runattack1 =[ $runattack1,	vengeance_knight_runattack2 ]    {
	ai_face();
 	movetogoal (23);  // orig (20)
self.touch = vengeance_knight_touch;
	self.alpha = 0.2;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_knight_runattack2 =[ $runattack2,	vengeance_knight_runattack3 ]    {
	ai_face();
 	movetogoal (23);  // orig (20)
self.touch = vengeance_knight_touch;
	self.alpha = 0.16;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_knight_runattack3 =[ $runattack3,	vengeance_knight_runattack4 ]    {
	ai_face();
 	movetogoal (23);  // orig (20)
	sound (self, CHAN_WEAPON, "knight/sword1.wav", 1, 4);
self.touch = vengeance_knight_touch;
	self.alpha = 0.13;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_knight_runattack4 =[ $runattack5,	vengeance_knight_runattack5 ]    {
	ai_face();
 	movetogoal (23);  // orig (20)
self.touch = vengeance_knight_touch;
	self.alpha = 0.1;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_knight_runattack5 =[ $runattack6,	vengeance_knight_end1 ]    {
	ai_face();
 	movetogoal (23);  // orig (20)
self.touch = vengeance_knight_touch;
	makevectors (self.angles);
	self.origin_z = self.origin_z + 1;
	self.velocity = v_forward * 100 + '0 0 10';
	self.alpha = 0.07;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};


										//  from here on: ressurection sequence 1. 

void() vengeance_knight11 =[	$death9,	vengeance_knight12 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_knight12 =[	$death8,	vengeance_knight13 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_knight13 =[	$death7,	vengeance_knight14 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_knight14 =[	$death6,	vengeance_knight15 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_knight15 =[	$death5,	vengeance_knight16 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_knight16 =[	$death4,	vengeance_knight17 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_knight17 =[	$death3,	vengeance_knight18 	]  {
	sound (self, CHAN_VOICE, "knight/ksight.wav", 1, ATTN_NORM);
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_knight18 =[	$death2,	vengeance_knight19 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_knight19 =[ $death1,	vengeance_knight_walk16 ]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_knight_walk16 =[ $walk6,	vengeance_knight_run1 ]  {    // needed to make the animation fluent
	self.alpha = 0.4;									// $walk6 fills the frame gap
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};


											//  from here on: ressurection sequence 2. 

void() vengeance_knight21 =[	$deathb10,	vengeance_knight22 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_knight22 =[	$deathb9,	vengeance_knight23 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_knight23 =[	$deathb8,	vengeance_knight24 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_knight24 =[	$deathb7,	vengeance_knight25 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_knight25 =[	$deathb6,	vengeance_knight26 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_knight26 =[	$deathb5,	vengeance_knight27 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_knight27 =[	$deathb4,	vengeance_knight28 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_knight28 =[	$deathb3,	vengeance_knight29 	]  {
	sound (self, CHAN_VOICE, "knight/ksight.wav", 1, ATTN_NORM);
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_knight29 =[	$deathb2,	vengeance_knight210 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_knight210 =[ $deathb1,	vengeance_knight_walk26]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_knight_walk26 =[ $walk6,	vengeance_knight_run1 ]  {    // needed to make the animation fluent
	self.alpha = 0.4;	     								// $walk6 fills the frame gap
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};


								// from here on:  sequence where the corpse overbrights 
void()	vengeance_knight_bright05 	= {
	self.alpha = 0.3;
	self.colormod = '6 1 1';
	self.glow_color = 75;
	self.glow_size = 450;
	self.nextthink = time + 0.1;
		if (self.frame == $death10)
			self.think = vengeance_knight11;
		else
			self.think = vengeance_knight21;
};
void()	vengeance_knight_bright04 	= {
	self.alpha = 0.3;
	self.colormod = '5 1 1';
	self.glow_color = 75;
	self.glow_size = 350;
	self.nextthink = time + 0.1;
	self.think = vengeance_knight_bright05;
};
void()	vengeance_knight_bright03 	= {
	self.alpha = 0.3;
	self.colormod = '4 1 1';
	self.glow_color = 75;
	self.glow_size = 270;
	self.nextthink = time + 0.1;
	self.think = vengeance_knight_bright04;
};
void()	vengeance_knight_bright02 	= {
	self.alpha = 0.3;
	self.colormod = '3 1 1';
	self.glow_color = 75;
	self.glow_size = 185;
	self.nextthink = time + 0.1;
	self.think = vengeance_knight_bright03;
}; 
void()	vengeance_knight_bright01 	= {
	self.alpha = 0.3;
	self.colormod = '2 1 1';
	self.glow_color = 75;
	self.glow_size = 100;
	self.nextthink = time + 0.1;
	self.think = vengeance_knight_bright02;
};
void()	vengeance_knight_bright00 	= {  			// delay for 0.3 seconds before overbright process really begins
	self.alpha = 0.3;
	self.glow_color = 75;
	self.glow_size = 10;
	self.nextthink = time + 0.3;
	self.think = vengeance_knight_bright01;
};



void(string modelname, float modelframe) vengeance_knight =
{

local vector v;  			// v  was necessary at the begining of effect development, but isnt anymore now.
v_x = (self.origin_x);
v_y = (self.origin_y);
v_z = (self.origin_z);

      self.origin = v; 
   	self.touch = SUB_Null;                
	self.movetype = MOVETYPE_FLY;
	
	if (self.monstermodel == 0)  
		setmodel (self, "progs/knight.mdl"); 
	else if (self.monstermodel == 1)  
		setmodel (self, "progs/knight1.mdl"); 

	setsize (self, '-16 -16 -24', '16 16 40');
	self.frame = modelframe;	 // modelframe is depending on the individual monster (included in vengeance call)

	var float autocvar_vengeancedamage = 0;   // set cvar 'vengeancedamage' default to 0
	if (autocvar_vengeancedamage == 0)	  	// if 'vengeancedamage' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '0'
		self.solid = SOLID_NOT;			// vengeance effect is NOT solid and cannot hurt the player
	else
		self.solid = SOLID_SLIDEBOX;    	  // if value is NOT "0", player get hurt from this effect (see func "vengeance_knight_touch")!

	vengeance_knight_bright00 ();			 // starts the animation
};
 