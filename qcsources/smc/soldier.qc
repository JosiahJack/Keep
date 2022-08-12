/*
==============================================================================

SOLDIER / PLAYER

==============================================================================
*/

$cd id1/models/soldier3
$origin 0 -6 24
$base base		
$skin skin

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8

$frame death1 death2 death3 death4 death5 death6 death7 death8
$frame death9 death10

$frame deathc1 deathc2 deathc3 deathc4 deathc5 deathc6 deathc7 deathc8
$frame deathc9 deathc10 deathc11

$frame load1 load2 load3 load4 load5 load6 load7 load8 load9 load10 load11

$frame pain1 pain2 pain3 pain4 pain5 pain6

$frame painb1 painb2 painb3 painb4 painb5 painb6 painb7 painb8 painb9 painb10
$frame painb11 painb12 painb13 painb14

$frame painc1 painc2 painc3 painc4 painc5 painc6 painc7 painc8 painc9 painc10
$frame painc11 painc12 painc13

$frame run1 run2 run3 run4 run5 run6 run7 run8

$frame shoot1 shoot2 shoot3 shoot4 shoot5 shoot6 shoot7 shoot8 shoot9

$frame prowl_1 prowl_2 prowl_3 prowl_4 prowl_5 prowl_6 prowl_7 prowl_8
$frame prowl_9 prowl_10 prowl_11 prowl_12 prowl_13 prowl_14 prowl_15 prowl_16
$frame prowl_17 prowl_18 prowl_19 prowl_20 prowl_21 prowl_22 prowl_23 prowl_24

/*
==============================================================================
SOLDIER CODE
==============================================================================
*/

void(float loudness) soldier_footsteps =
{
if (autocvar_monsterfootsteps == 1)	// only play monster footsteps sound when cvar is 1
	{
	local float select;
	select = random();
	if (select <= 0.4)
		sound(self, CHAN_AUTO, "walk/soldier1.wav", loudness, ATTN_IDLE);
	else if (select <= 0.7)
		sound(self, CHAN_AUTO, "walk/soldier2.wav", loudness, ATTN_IDLE);
	else 
		sound(self, CHAN_AUTO, "walk/soldier3.wav", loudness, ATTN_IDLE);
	}
};


var float autocvar_soldierreloadanim = 1;	// set cvar 'soldierreloadanim' default to 1.  0= disabled  1= enabled: soldier have a certain chance to play the unused weapon-reload-animation. 
						// This has NO affect to the gameplay ! The soldier keeps on using ai_stand() or ai_walk() and keeps therefore scanning for player/enemies.

// new animation sequence (during standing) 
void() soldier_reload1a	      =[      $prowl_24,       soldier_reload2a      ] {ai_stand();};
void() soldier_reload2a       =[      $shoot2,         soldier_reload3a      ] {ai_stand();};
void() soldier_reload3a       =[      $shoot3,         soldier_reload4a      ] {ai_stand();};
void() soldier_reload4a       =[      $load1,          soldier_reload5a      ] {ai_stand();};
void() soldier_reload5a       =[      $load2,          soldier_reload6a      ] {ai_stand();};
void() soldier_reload6a       =[      $load3,          soldier_reload7a      ] {ai_stand();};
void() soldier_reload7a       =[      $load4,          soldier_reload8a      ] {ai_stand();};
void() soldier_reload8a       =[      $load5,          soldier_reload9a      ] {ai_stand();};
void() soldier_reload9a       =[      $load6,          soldier_reload10a     ] {ai_stand();};
void() soldier_reload10a      =[      $load7,          soldier_reload11a     ] {ai_stand();};
void() soldier_reload11a      =[      $load8,          soldier_reload12a     ] {ai_stand(); sound (self, CHAN_AUTO, "soldier/reload.wav", 0.75, ATTN_IDLE);};
void() soldier_reload12a      =[      $load9,          soldier_reload13a     ] {ai_stand();};
void() soldier_reload13a      =[      $load10,         soldier_reload14a     ] {ai_stand();};
void() soldier_reload14a      =[      $load11,         soldier_reload15a     ] {ai_stand();};
void() soldier_reload15a      =[      $shoot4,         soldier_reload16a     ] {ai_stand();};
void() soldier_reload16a      =[      $shoot3,         soldier_reload17a     ] {ai_stand();};
void() soldier_reload17a      =[      $shoot2,         soldier_reload18a     ] {ai_stand();};
void() soldier_reload18a      =[      $prowl_24,       army_stand1           ] {ai_stand();};

// new animation sequence (during walking) 
void() soldier_reload1	     =[      $prowl_24,       soldier_reload2      ] {ai_walk(0); soldier_footsteps (0.9);};
void() soldier_reload2       =[      $shoot2,         soldier_reload3      ] {ai_walk(0);};
void() soldier_reload3       =[      $shoot3,         soldier_reload4      ] {ai_walk(0);};
void() soldier_reload4       =[      $load1,          soldier_reload5      ] {ai_walk(0);};
void() soldier_reload5       =[      $load2,          soldier_reload6      ] {ai_walk(0);};
void() soldier_reload6       =[      $load3,          soldier_reload7      ] {ai_walk(0);};
void() soldier_reload7       =[      $load4,          soldier_reload8      ] {ai_walk(0);};
void() soldier_reload8       =[      $load5,          soldier_reload9      ] {ai_walk(0);};
void() soldier_reload9       =[      $load6,          soldier_reload10     ] {ai_walk(0);};
void() soldier_reload10      =[      $load7,          soldier_reload11     ] {ai_walk(0);};
void() soldier_reload11      =[      $load8,          soldier_reload12     ] {ai_walk(0); sound (self, CHAN_AUTO, "soldier/reload.wav", 0.75, ATTN_IDLE);};
void() soldier_reload12      =[      $load9,          soldier_reload13     ] {ai_walk(0);};
void() soldier_reload13      =[      $load10,         soldier_reload14     ] {ai_walk(0);};
void() soldier_reload14      =[      $load11,         soldier_reload15     ] {ai_walk(0);};
void() soldier_reload15      =[      $shoot4,         soldier_reload16     ] {ai_walk(0);};
void() soldier_reload16      =[      $shoot3,         soldier_reload17     ] {ai_walk(0);};
void() soldier_reload17      =[      $shoot2,         army_walk24	   ] {ai_walk(0);};


void() army_fire;

void()	army_stand1	=[	$stand1,	army_stand2	] {ai_stand();};
void()	army_stand2	=[	$stand2,	army_stand3	] {ai_stand();};
void()	army_stand3	=[	$stand3,	army_stand4	] {ai_stand();};
void()	army_stand4	=[	$stand4,	army_stand5	] {ai_stand();};
void()	army_stand5	=[	$stand5,	army_stand6	] {ai_stand();};
void()	army_stand6	=[	$stand6,	army_stand7	] {ai_stand();};
void()	army_stand7	=[	$stand7,	army_stand8	] {ai_stand();};
void()	army_stand8	=[	$stand8,	army_stand1	] {ai_stand();
if (autocvar_soldierreloadanim == 1)	
	{
	if (random() <= 0.06)		// 6% chance that soldier reloads his weapon 
		soldier_reload1a();
	}
};

void()	army_walk1	=[	$prowl_1,	army_walk2	] {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "soldier/idle.wav", 1, ATTN_IDLE);
ai_walk(1);};
void()	army_walk2	=[	$prowl_2,	army_walk3	] {ai_walk(1);};
void()	army_walk3	=[	$prowl_3,	army_walk4	] {ai_walk(1);};
void()	army_walk4	=[	$prowl_4,	army_walk5	] {ai_walk(1);};
void()	army_walk5	=[	$prowl_5,	army_walk6	] {ai_walk(2);};
void()	army_walk6	=[	$prowl_6,	army_walk7	] {ai_walk(3);};
void()	army_walk7	=[	$prowl_7,	army_walk8	] {ai_walk(4);};
void()	army_walk8	=[	$prowl_8,	army_walk9	] {ai_walk(4);};
void()	army_walk9	=[	$prowl_9,	army_walk10	] {ai_walk(2);};
void()	army_walk10	=[	$prowl_10,	army_walk11	] {ai_walk(2);};
void()	army_walk11	=[	$prowl_11,	army_walk12	] {ai_walk(2);};
void()	army_walk12	=[	$prowl_12,	army_walk13	] {ai_walk(1); soldier_footsteps (0.9);};
void()	army_walk13	=[	$prowl_13,	army_walk14	] {ai_walk(0);};
void()	army_walk14	=[	$prowl_14,	army_walk15	] {ai_walk(1);};
void()	army_walk15	=[	$prowl_15,	army_walk16	] {ai_walk(1);};
void()	army_walk16	=[	$prowl_16,	army_walk17	] {ai_walk(1);};
void()	army_walk17	=[	$prowl_17,	army_walk18	] {ai_walk(3);};
void()	army_walk18	=[	$prowl_18,	army_walk19	] {ai_walk(3);};
void()	army_walk19	=[	$prowl_19,	army_walk20	] {ai_walk(3);};
void()	army_walk20	=[	$prowl_20,	army_walk21	] {ai_walk(3);};
void()	army_walk21	=[	$prowl_21,	army_walk22	] {ai_walk(2);};
void()	army_walk22	=[	$prowl_22,	army_walk23	] {ai_walk(1);};
void()	army_walk23	=[	$prowl_23,	army_walk24	] {ai_walk(1);
if (autocvar_soldierreloadanim == 1)	
	{
	if (random() <= 0.08)		// 8% chance that soldier reloads his weapon during patrol
		soldier_reload1();
	}
};
void()	army_walk24	=[	$prowl_24,	army_walk1	] {ai_walk(1); soldier_footsteps (0.9);};


void()	army_runshot1;

void()	army_run1	=[	$run1,		army_run2	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001); 
if (autocvar_soldier_run_and_shoot)
{
  if (borkfactor1()) 
	return;
}
if (random() < 0.2)
	sound (self, CHAN_VOICE, "soldier/idle.wav", 1, ATTN_IDLE);
if (autocvar_soldier_run_and_shoot)
{
    if (visible(self.enemy))
    {
//        if (infront(self.enemy))
//        {
	      if (random() < 0.63) 
	      {
	        self.attack_finished = time + 0.8;
	        army_runshot1();
	        return;
	      }
//        }
    }
}
ai_run(11);};
void()	army_run2	=[	$run2,		army_run3	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(15); soldier_footsteps (1);};
void()	army_run3	=[	$run3,		army_run4	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(10);};
void()	army_run4	=[	$run4,		army_run5	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(10);};
void()	army_run5	=[	$run5,		army_run6	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(8);};
void()	army_run6	=[	$run6,		army_run7	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(15); soldier_footsteps (1);};
void()	army_run7	=[	$run7,		army_run8	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(10);};
void()	army_run8	=[	$run8,		army_run1	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(8);};

void()	army_atk1	=[	$shoot1,	army_atk2	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void()	army_atk2	=[	$shoot2,	army_atk3	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void()	army_atk3	=[	$shoot3,	army_atk4	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void()	army_atk4	=[	$shoot4,	army_atk5	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void()	army_atk5	=[	$shoot5,	army_atk6	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();army_fire();
self.effects = self.effects | EF_MUZZLEFLASH;
local	vector org;
var float autocvar_soldiermuzzleflash = 1;     	// set cvar 'soldiermuzzleflash' default to 1
	if (autocvar_soldiermuzzleflash == 1)	// if 'soldiermuzzleflash' is '1' 
		{
		// adds muzzleflash to soldiers weapon (for original ID1 soldier model !!)
		makevectors (self.angles);	
		org = self.origin + v_up*17 + v_right*7 + v_forward*17;
		pointparticles(particleeffectnum("soldier_muzzleflash"), org, '0 0 0', 1);
		}
	else if (autocvar_soldiermuzzleflash == 2)	// if 'soldiermuzzleflash' is '2' 
		{
		// adds muzzleflash to soldiers weapon (for external soldier model !!)
		makevectors (self.angles);	
		org = self.origin + v_up*17 + v_right*5 + v_forward*21;
		pointparticles(particleeffectnum("soldier_muzzleflash"), org, '0 0 0', 1);
		}
	else if (autocvar_soldiermuzzleflash == 3)	// if 'soldiermuzzleflash' is '3' 
		{
			if (self.model == "progs/soldier.mdl")  // model is ID1 type
				{
				// adds muzzleflash to soldiers weapon (for original ID1 soldier model !!)
				makevectors (self.angles);	
				org = self.origin + v_up*17 + v_right*7 + v_forward*17;
				pointparticles(particleeffectnum("soldier_muzzleflash"), org, '0 0 0', 1);
				}
			else if (self.model == "progs/soldier1.mdl")  // model is external type	
				{
				// adds muzzleflash to soldiers weapon (for external soldier model !!)
				makevectors (self.angles);	
				org = self.origin + v_up*17 + v_right*5 + v_forward*21;
				pointparticles(particleeffectnum("soldier_muzzleflash"), org, '0 0 0', 1);
				}
		}
};
void()	army_atk6	=[	$shoot6,	army_atk7	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void()	army_atk7	=[	$shoot7,	army_atk8	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();SUB_CheckRefire (army_atk1);};
void()	army_atk8	=[	$shoot8,	army_atk9	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();
if (autocvar_gruntcasing == 1)
	casing (1);};
void()	army_atk9	=[	$shoot9,	army_run1	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};


void()	army_pain1	=[	$pain1,		army_pain2	] {};
void()	army_pain2	=[	$pain2,		army_pain3	] {};
void()	army_pain3	=[	$pain3,		army_pain4	] {};
void()	army_pain4	=[	$pain4,		army_pain5	] {};
void()	army_pain5	=[	$pain5,		army_pain6	] {};
void()	army_pain6	=[	$pain6,		army_run1	] {ai_pain(1);};

void()	army_painb1	=[	$painb1,	army_painb2	] {};
void()	army_painb2	=[	$painb2,	army_painb3	] {ai_painforward(13);};
void()	army_painb3	=[	$painb3,	army_painb4	] {ai_painforward(9);};
void()	army_painb4	=[	$painb4,	army_painb5	] {};
void()	army_painb5	=[	$painb5,	army_painb6	] {};
void()	army_painb6	=[	$painb6,	army_painb7	] {};
void()	army_painb7	=[	$painb7,	army_painb8	] {};
void()	army_painb8	=[	$painb8,	army_painb9	] {};
void()	army_painb9	=[	$painb9,	army_painb10	] {};
void()	army_painb10	=[	$painb10,	army_painb11	] {};
void()	army_painb11	=[	$painb11,	army_painb12	] { soldier_footsteps (0.85);};
void()	army_painb12	=[	$painb12,	army_painb13	] {ai_pain(2);};
void()	army_painb13	=[	$painb13,	army_painb14	] {};
void()	army_painb14	=[	$painb14,	army_run1	] {};

void()	army_painc1	=[	$painc1,	army_painc2	] {};
void()	army_painc2	=[	$painc2,	army_painc3	] {ai_pain(1);};
void()	army_painc3	=[	$painc3,	army_painc4	] {};
void()	army_painc4	=[	$painc4,	army_painc5	] {};
void()	army_painc5	=[	$painc5,	army_painc6	] {ai_painforward(1);};
void()	army_painc6	=[	$painc6,	army_painc7	] {ai_painforward(1);};
void()	army_painc7	=[	$painc7,	army_painc8	] {};
void()	army_painc8	=[	$painc8,	army_painc9	] {ai_pain(1);};
void()	army_painc9	=[	$painc9,	army_painc10	] {ai_painforward(4);};
void()	army_painc10	=[	$painc10,	army_painc11	] {ai_painforward(3); soldier_footsteps (0.85);};
void()	army_painc11	=[	$painc11,	army_painc12	] {ai_painforward(6);};
void()	army_painc12	=[	$painc12,	army_painc13	] {ai_painforward(8);};
void()	army_painc13	=[	$painc13,	army_run1	] { soldier_footsteps (0.85);};

void(entity attacker, float damage)	army_pain =
{
	local float r;
	
	if (self.pain_finished > time)
		return;

	if (autocvar_slowmotion >= 4)	// start slowmotion when hurting enemies
	{
		if (random () <= (autocvar_slowmotion_randomness_soldier * 0.01))
			{
			the_matrix = 1;
			matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
			}
	}

	r = random();

	if (r < 0.2)
	{
		self.pain_finished = time + 0.6;
		army_pain1 ();
		sound (self, CHAN_VOICE, "soldier/pain1.wav", 1, ATTN_NORM);
	}
	else if (r < 0.6)
	{
		self.pain_finished = time + 1.1;
		army_painb1 ();
		sound (self, CHAN_VOICE, "soldier/pain2.wav", 1, ATTN_NORM);
	}
	else
	{
		self.pain_finished = time + 1.1;
		army_painc1 ();
		sound (self, CHAN_VOICE, "soldier/pain2.wav", 1, ATTN_NORM);
	}
};


void() army_fire =
{
	local	vector	dir;
	local	entity	en;
	
	ai_face();
	
	sound (self, CHAN_WEAPON, "soldier/sattck1.wav", 1, ATTN_NORM);	

// fire somewhat behind the player, so a dodging player is harder to hit
	en = self.enemy;
	
	if (autocvar_skill_adjusted_soldier_aiming)
	{
		if (skill == 0)
			dir = en.origin - en.velocity*0.2; 
		else if (skill == 1)
			dir = en.origin - en.velocity*0.15; 
		else if (skill == 2)
			dir = en.origin - en.velocity*0.1; 
		else
			dir = en.origin - en.velocity*0.05; 
	}
	else
		dir = en.origin - en.velocity*0.2; 
	
	dir = normalize (dir - self.origin);
	
	FireBullets_soldier (4, dir, '0.1 0.1 0');
};



void()	army_runshot1	=[	164,	army_runshot2	] {
  if (borkfactor1()) 
	return;
  if (random() < 0.2) 
    	sound(self, CHAN_VOICE, "soldier/idle.wav", 1, ATTN_IDLE);
  if (!ai_threats())
 	   ai_run_slide(10);
  ai_face();
};

void()	army_runshot2	=[	165,	army_runshot3	] {
  if (!ai_threats())
    	ai_run_slide(9);
  ai_face();
};

void()	army_runshot3	=[	166,	army_runshot4	] {
  if (!ai_threats())
    	ai_run_slide(8);
  ai_face();
};

void()	army_runshot4	=[	167,	army_runshot5	] {
  if (!ai_threats())
    	ai_run_slide(8);
  ai_face();
};

void()	army_runshot5	=[	168,	army_runshot6	] {
  if (!ai_threats())
    	ai_run_slide(9);
  army_fire();
  self.effects = self.effects | EF_MUZZLEFLASH;
};

void()	army_runshot6	=[	169,	army_runshot7	] {
  if (!ai_threats())
    	ai_run_slide(10);
  ai_face();
};

void()	army_runshot7	=[	170,	army_runshot8	] {
  if (!ai_threats())
    	ai_run_slide(9);
  ai_face();
};

void()	army_runshot8	=[	171,	army_run1	] {
  if (self.enemy.health < 1) 
  {
    self.th_run();		// self.th_stand();
    return;
  }
  if (ai_threats())		// ((ai_threats()) && (random() > 0.8))
  {
    ai_face();
    army_runshot1();
    return;
  }
  self.tactic = 0;
  ai_run_slide(9);
  ai_face();
};



void() army_dieburn1	=[	$death1,	army_dieburn2	] {self.burnz_origin = 12;
burn_toggle_allround();
};
void() army_dieburn2	=[	$death2,	army_dieburn3	] {self.burnz_origin = 11;
};
void() army_dieburn3	=[	$death3,	army_dieburn4	] {self.burnz_origin = 6;
self.solid = SOLID_NOT;
self.ammo_shells = autocvar_backpack_soldier_shells;	// default 5 
self.backpack_thrower = 1; DropBackpack();
};
void() army_dieburn4	=[	$death4,	army_dieburn5	] {self.burnz_origin = 3;
};
void() army_dieburn5	=[	$death5,	army_dieburn6	] {self.burnz_origin = 0;
};
void() army_dieburn6	=[	$death6,	army_dieburn7	] {self.burnz_origin = -2;
};
void() army_dieburn7	=[	$death7,	army_dieburn8	] {self.burnz_origin = -4;
};
void() army_dieburn8	=[	$death8,	army_dieburn9	] {self.burnz_origin = -6;
};
void() army_dieburn9	=[	$death9,	army_dieburn10	] {self.burnz_origin = -8;
};
void() army_dieburn10	=[	$death10,	army_dieburn10	] {self.burnz_origin = -10;
};


var float autocvar_soldier = 5;     		// set cvar 'soldier' default to 5
var float autocvar_soldiercorpsehealth = 60;	// set cvar 'soldiercorpsehealth' default to 60
var float autocvar_soldiercorpseburnable = 0;	// set cvar 'soldiercorpseburnable' default to 0

void()	army_die1	=[	$death1,	army_die2	] {};
void()	army_die2	=[	$death2,	army_die3	] {};
void()	army_die3	=[	$death3,	army_die4	] {
self.solid = SOLID_NOT;
self.ammo_shells = autocvar_backpack_soldier_shells;	// default 5
self.backpack_thrower = 1;DropBackpack();};
void()	army_die4	=[	$death4,	army_die5	] {};
void()	army_die5	=[	$death5,	army_die6	] {};
void()	army_die6	=[	$death6,	army_die7	] {};
void()	army_die7	=[	$death7,	army_die8	] {sound (self, CHAN_AUTO, "soldier/fall_backwards.wav", 1, ATTN_IDLE);};
void()	army_die8	=[	$death8,	army_die9	] {};
void()	army_die9	=[	$death9,	army_die10	] {};
void()	army_die10	=[	$death10,	army_die10	] {
if (self.inflamed == 1)
{
	inflamed_die ();
	return;
}
local float zufall, zet, randomness;
	zet = 20;					// z-position of the wings (in relation to soul). Dependent on corpse size.
	if (autocvar_soldiercorpseburnable == 1)	// corpses are burnable
		self.burnable_corpse = 1;
// 	auto_cvar 'soldiercorpsehealth' has been set to  default = 60  in code above already
	self.delete_painskin = 1;		 	 // remove painskin
	if (self.monstermodel == 0)  
		CopyMonsterToBodyQue(autocvar_soldiercorpsehealth, "progs/h_guard.mdl");
	if (self.monstermodel == 1)  
		CopyMonsterToBodyQue(autocvar_soldiercorpsehealth, "progs/h_guard1.mdl");
if (self.nodeathanim == 1)
	return;
if (self.grimrock_helper == 0)
{
// 	auto_cvar 'soldier' has been declared in code above already
	var float autocvar_soldierrandomness = 20;     	// set cvar 'soldierrandomness' default to 20%
	autocvar_soldierrandomness = autocvar_soldierrandomness * 0.01;
	if (autocvar_soldier == 1)			// if 'soldier' is set via autoexec.cfg to '1' start ghost effect
		{
		randomness = random();
		if (randomness <= autocvar_soldierrandomness)	// checks if death animation shall be started
			ghost_die (); 
		}
	else if (autocvar_soldier == 2)		// if 'soldier' is set via autoexec.cfg to '2' start soul effect
		{
		randomness = random();
		if (randomness <= autocvar_soldierrandomness)	// checks if death animation shall be started
			{
			if (self.monstermodel == 0)  
				soul ("progs/soldier.mdl", $death10, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
			else if (self.monstermodel == 1)  
				soul ("progs/soldier1.mdl", $death10, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
			}
		}
	else if (autocvar_soldier == 3)		// if 'soldier' is set via autoexec.cfg to '3' start vengeance effect
		{
		randomness = random();
		if (randomness <= autocvar_soldierrandomness)	// checks if death animation shall be started
			vengeance_soldier ("progs/soldier.mdl", $death10);
 		}
	else if (autocvar_soldier == 5)		// if 'soldier' is set via autoexec.cfg to '5' start randomly one of these Death animations: 
		{				// (Ancient ghosts of the fallen ; Relieved souls of the enslaved ; Vengeance of the deceased)			
		randomness = random();		// chance for effects (approx.): 36% / 26% / 38%
		if (randomness <= autocvar_soldierrandomness)	// checks if death animation shall be started --> depending on monsters _randomness
			{					
			zufall = random();
			if (zufall > 0.64)
				ghost_die ();
			else if (zufall < 0.26)
				{
				if (self.monstermodel == 0)  
					soul ("progs/soldier.mdl", $death10, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
				else if (self.monstermodel == 1)  
					soul ("progs/soldier1.mdl", $death10, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
				}
			else
				vengeance_soldier ("progs/soldier.mdl", $death10);
			}
		}
	else				// if 'soldier' is set via autoexec.cfg to another value (example '0'), do nothing !
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
			soul ("progs/soldier.mdl", $death10, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
		else if (self.monstermodel == 1)  
			soul ("progs/soldier1.mdl", $death10, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
		}
	else
		vengeance_soldier ("progs/soldier.mdl", $death10);
	}
};


void()	army_cdie1	=[	$deathc1,	army_cdie2	] {};
void()	army_cdie2	=[	$deathc2,	army_cdie3	] {ai_back(5);};
void()	army_cdie3	=[	$deathc3,	army_cdie4	] {
self.solid = SOLID_NOT;
self.ammo_shells = autocvar_backpack_soldier_shells;	// default 5
self.backpack_thrower = 1;DropBackpack();ai_back(4);};
void()	army_cdie4	=[	$deathc4,	army_cdie5	] {ai_back(13);};
void()	army_cdie5	=[	$deathc5,	army_cdie6	] {ai_back(3);};
void()	army_cdie6	=[	$deathc6,	army_cdie7	] {ai_back(4);};
void()	army_cdie7	=[	$deathc7,	army_cdie8	] {};
void()	army_cdie8	=[	$deathc8,	army_cdie9	] {sound (self, CHAN_AUTO, "soldier/fall_forwards.wav", 1, ATTN_IDLE);};
void()	army_cdie9	=[	$deathc9,	army_cdie10	] {};
void()	army_cdie10	=[	$deathc10,	army_cdie11	] {};
void()	army_cdie11	=[	$deathc11,	army_cdie11	] {
if (self.inflamed == 1)
{
	inflamed_die ();
	return;
}
local float zufall, zet, randomness;
	zet = 20;					// z-position of the wings (in relation to soul). Dependent on corpse size.
	if (autocvar_soldiercorpseburnable == 1)	// corpses are burnable
		self.burnable_corpse = 1;
// 	auto_cvar 'soldiercorpsehealth' has been set to  default = 60  in code above already
	self.delete_painskin = 1;		 	 // remove painskin
	if (self.monstermodel == 0)  
		CopyMonsterToBodyQue(autocvar_soldiercorpsehealth, "progs/h_guard.mdl");
	if (self.monstermodel == 1)  
		CopyMonsterToBodyQue(autocvar_soldiercorpsehealth, "progs/h_guard1.mdl");
if (self.nodeathanim == 1)
	return;
if (self.grimrock_helper == 0)
{
// 	auto_cvar 'soldier' has been declared in code above already
	var float autocvar_soldierrandomness = 20;     	// set cvar 'soldierrandomness' default to 20%
	autocvar_soldierrandomness = autocvar_soldierrandomness * 0.01;
	if (autocvar_soldier == 1)			// if 'soldier' is set via autoexec.cfg to '1' start ghost effect
		{
		randomness = random();
		if (randomness <= autocvar_soldierrandomness)	// checks if death animation shall be started
			ghost_die ();
		}
	else if (autocvar_soldier == 2)		// if 'soldier' is set via autoexec.cfg to '2' start soul effect
		{
		randomness = random();
		if (randomness <= autocvar_soldierrandomness)	// checks if death animation shall be started
			{
			if (self.monstermodel == 0)  
				soul ("progs/soldier.mdl", $deathc11, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
			else if (self.monstermodel == 1)  
				soul ("progs/soldier1.mdl", $deathc11, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
			}
		}
	else if (autocvar_soldier == 3)		// if 'soldier' is set via autoexec.cfg to '3' start vengeance effect
		{
		randomness = random();
		if (randomness <= autocvar_soldierrandomness)	// checks if death animation shall be started
			vengeance_soldier ("progs/soldier.mdl", $deathc11); 
		}
	else if (autocvar_soldier == 5)		// if 'soldier' is set via autoexec.cfg to '5' start randomly one of these Death animations: 
		{				// (Ancient ghosts of the fallen ; Relieved souls of the enslaved ; Vengeance of the deceased)			
		randomness = random();		// chance for effects (approx.): 36% / 26% / 38%
		if (randomness <= autocvar_soldierrandomness)	// checks if death animation shall be started --> depending on monsters _randomness
			{					
			zufall = random();
			if (zufall > 0.64)
				ghost_die ();
			else if (zufall < 0.26)
				{
				if (self.monstermodel == 0)  
					soul ("progs/soldier.mdl", $deathc11, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
				else if (self.monstermodel == 1)  
					soul ("progs/soldier1.mdl", $deathc11, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
				}
			else
				vengeance_soldier ("progs/soldier.mdl", $deathc11);
			}
		}
	else				// if 'soldier' is set via autoexec.cfg to another value (example '0'), do nothing !
	{
	}
}
else if (self.grimrock_helper == 1)		// this new code is the the ending of cvar value "6" (which was started in monsters _die function)
	{					
	zufall = random();
	if (zufall > 0.64)
		ghost_die ();
	else if (zufall < 0.26)
		{
		if (self.monstermodel == 0)  
			soul ("progs/soldier.mdl", $deathc11, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
		else if (self.monstermodel == 1)  
			soul ("progs/soldier1.mdl", $deathc11, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
		}
	else
		vengeance_soldier ("progs/soldier.mdl", $deathc11);
	}
};


void(float maxgibs, float gibscounter) producegibs_grunt =		// creates as many gib-sets as defined in cvar 'gibsmultiplier'
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
producegibs_grunt (maxgibs, gibscounter);
};


void()	army_lightning_death	=[	$painb1,	army_lightning_death1	] {
self.delete_painskin = 1;			  // remove painskin
if (autocvar_lightninggun_death_animation == 2)	  // start the "fade" effect instead of "coal" effect
	{
	self.ammo_shells = autocvar_backpack_soldier_shells;	// default 5
	self.backpack_thrower = 1; 
	lightninggun_death_fade();
	}
};

void()	army_lightning_death1	=[	$painb1,	army_lightning_death1	] {
self.solid = SOLID_NOT;
self.baked = 1;
self.colormod = '0.25 0.22 0.22';	// skins gets darker (looks burned)
if (self.monstermodel == 0)  
	CopyMonsterToBodyQue(1, "progs/h_guard.mdl");
if (self.monstermodel == 1)  
	CopyMonsterToBodyQue(1, "progs/h_guard1.mdl");
};


void() army_die;
void() army_inflamed9;
void() army_inflamed18;

void()	army_inflamed1	=[	$run1,	army_inflamed2	] {ai_run_inflamed (11); self.nextthink = time + 0.07;
local float r;
r = random();
if (r < 0.3)
	sound (self, CHAN_VOICE, "soldier/pain1.wav", 1, ATTN_NORM);
else if (r < 0.82)
	sound (self, CHAN_VOICE, "soldier/pain2.wav", 1, ATTN_NORM);
};
void()	army_inflamed2	=[	$run2,	army_inflamed3	] {ai_run_inflamed(15); soldier_footsteps (1); self.nextthink = time + 0.07;};
void()	army_inflamed3	=[	$run3,	army_inflamed4	] {ai_run_inflamed(10); self.nextthink = time + 0.07;};
void()	army_inflamed4	=[	$run4,	army_inflamed5	] {ai_run_inflamed(10); self.nextthink = time + 0.07;};
void()	army_inflamed5	=[	$run5,	army_inflamed6	] {ai_run_inflamed(8); self.nextthink = time + 0.07;};
void()	army_inflamed6	=[	$run6,	army_inflamed7	] {ai_run_inflamed(15); soldier_footsteps (1); self.nextthink = time + 0.07;};
void()	army_inflamed7	=[	$run7,	army_inflamed8	] {ai_run_inflamed(10); self.nextthink = time + 0.07;};
void()	army_inflamed8	=[	$run8,	army_inflamed1	] {ai_run_inflamed(8); self.nextthink = time + 0.07;
if (self.inflametime < time)
{
	army_die ();
	return;
}
local float r;
r = random();
if (r < 0.27)
	army_inflamed9 ();	// part of pain anim (touch head)
else if (r < 0.44)
	army_inflamed18 ();	// part of pain anim (on knees)
};

void()	army_inflamed9	=[	$painc1, army_inflamed10	] {self.nextthink = time + 0.07;
local float r;
r = random();
if (r < 0.3)
	sound (self, CHAN_VOICE, "soldier/pain1.wav", 1, ATTN_NORM);
else if (r < 0.82)
	sound (self, CHAN_VOICE, "soldier/pain2.wav", 1, ATTN_NORM);
};
void()	army_inflamed10	=[	$painc2, army_inflamed11 ] {self.nextthink = time + 0.07;};
void()	army_inflamed11	=[	$painc3, army_inflamed12 ] {self.nextthink = time + 0.07;};
void()	army_inflamed12	=[	$painc4, army_inflamed13 ] {self.nextthink = time + 0.07;};
void()	army_inflamed13	=[	$painc5, army_inflamed14 ] {self.nextthink = time + 0.07;};
void()	army_inflamed14	=[	$painc6, army_inflamed15 ] {self.nextthink = time + 0.07;};
void()	army_inflamed15	=[	$painc5, army_inflamed16 ] {self.nextthink = time + 0.07;};
void()	army_inflamed16	=[	$painc4, army_inflamed17 ] {self.nextthink = time + 0.07;};
void()	army_inflamed17	=[	$painc1, army_inflamed1	] {self.nextthink = time + 0.07;
if (self.inflametime < time)
{
	army_die ();
	return;
}
};

void()	army_inflamed18	=[	$painc1,	army_inflamed19	] {self.nextthink = time + 0.07;
local float r;
r = random();
if (r < 0.3)
	sound (self, CHAN_VOICE, "soldier/pain1.wav", 1, ATTN_NORM);
else if (r < 0.82)
	sound (self, CHAN_VOICE, "soldier/pain2.wav", 1, ATTN_NORM);
};
void()	army_inflamed19	=[	$painb1, army_inflamed20 ] {self.nextthink = time + 0.07;};
void()	army_inflamed20	=[	$painb2, army_inflamed21 ] {self.nextthink = time + 0.07;};
void()	army_inflamed21	=[	$painb3, army_inflamed22 ] {self.nextthink = time + 0.07;};
void()	army_inflamed22	=[	$painb4, army_inflamed23 ] {self.nextthink = time + 0.07;};
void()	army_inflamed23	=[	$painb5, army_inflamed24 ] {self.nextthink = time + 0.07;};
void()	army_inflamed24	=[	$painb12, army_inflamed25 ] {self.nextthink = time + 0.07;};
void()	army_inflamed25	=[	$painb13, army_inflamed26 ] {self.nextthink = time + 0.07;};
void()	army_inflamed26	=[	$painb14, army_inflamed27 ] {self.nextthink = time + 0.07;};
void()	army_inflamed27	=[	$painc1, army_inflamed1	] {self.nextthink = time + 0.07;
if (self.inflametime < time)
{
	army_die ();
	return;
}
};



void() army_die =
{
	if (autocvar_lightninggun_death_animation)		// if 'lightninggun_death_animation' is enabled
	{
		if (self.enemy.weapon == IT_LIGHTNING)		// when enemy was killed with lightning gun, go into baked mode
		{
			army_lightning_death();
			return;
		}
	}

local float maxgibs, gibscounter;
// check for gib
	if (self.health < -35)
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
			if (random () <= (autocvar_slowmotion_randomness_soldier * 0.01))
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
					ThrowHead ("progs/h_guard.mdl", self.health);
				else if (self.monstermodel == 1)  
					ThrowHead ("progs/h_guard1.mdl", self.health);
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
					ThrowHead ("progs/h_guard.mdl", self.health);
				else if (self.monstermodel == 1)  
					ThrowHead ("progs/h_guard1.mdl", self.health);
					if (autocvar_heartgib >= 1)		// if 'heartgib' doesnt exist in autoexec.cfg, or if 'heartgib' is set via autoexec.cfg to '1' or higher
						ThrowHeart ("progs/gibheart.mdl", self.health);
				maxgibs = autocvar_gibsmultiplier;
				gibscounter = 0;
				if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
					pointparticles(particleeffectnum("blood_monster_gib"), self.origin, '0 0 0', 1);
				producegibs_grunt (maxgibs, gibscounter);
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
				army_inflamed1 ();
				return;
			}
		}
		else		// enemy is burning already and his "run-around-in-panic-time" has just ended
		{
			sound (self, CHAN_VOICE, "soldier/death1.wav", 1, ATTN_NORM);
			if (random() < 0.5)
				army_die1 ();
			else
				army_cdie1 ();
			return;
		}
	}

// regular death

local float zufall, randomness;
// auto_cvar 'soldier' has been declared in code above already
var float autocvar_soldierrandomness = 20;     	// set cvar 'soldierrandomness' default to 20%
autocvar_soldierrandomness = autocvar_soldierrandomness * 0.01;
if (autocvar_soldier == 4)		// if 'soldier' is set via autoexec.cfg to '4' start Death animation with "Legend of Grimrock" effect
	{
	randomness = random();
	if (randomness <= autocvar_soldierrandomness)	// checks if death animation shall be started
		{
		//Gyro_Object_ClearPhysics(self);	// ENABLE this line if you want to disable GYRO during new "Legend of Grimrock" animation !!
		self.delete_painskin = 1;		// remove painskin
		army_dieburn1();
		return;			// jump out of this function !!
		}
	}
if (autocvar_soldier == 6)		// if 'soldier' is set via autoexec.cfg to '6' start random Death animation (all 4 effects !!)
	{				// chance for effects (approx.): 25% / 25% / 25% / 25%  
	randomness = random();
	if (randomness <= autocvar_soldierrandomness)	// checks if death animation shall be started --> depending on monsters _randomness
		{					
		zufall = random();
		if (zufall <= 0.26)
			{
			//Gyro_Object_ClearPhysics(self);   // ENABLE this line if you want to disable GYRO during new "Legend of Grimrock" animation !!
			self.delete_painskin = 1;	    // remove painskin
			army_dieburn1();
			return;		// jump out of this function !!
			}		// if zufall is bigger than 0.26, use new code inside  upcoming function  for other 3 death animations
		else 
			self.grimrock_helper = 1;	// this float helps me to manipulate the other 3 death animations
		}
	else
		self.grimrock_helper = 2;	// this float helps me to manipulate the other 3 death animations
	}
	
// if 'soldier' has another value is checked inside prior function (= death animation function)

	if (autocvar_slowmotion >= 3)	// start slowmotion when regular killing living enemies
		{
		if (random () <= (autocvar_slowmotion_randomness_soldier * 0.01))
			{
			the_matrix = 1;
			matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
			}
		}
	sound (self, CHAN_VOICE, "soldier/death1.wav", 1, ATTN_NORM);
	if (random() < 0.5)
		army_die1 ();
	else
		army_cdie1 ();
};



/*QUAKED monster_army (1 0 0) (-16 -16 -24) (16 16 40) Ambush
*/
void() monster_army =
{	
	if (deathmatch)
	{
		remove(self);
		return;
	}

	precache_model ("progs/soldier.mdl");
	precache_model ("progs/h_guard.mdl");
	precache_model ("progs/gib1.mdl");
	precache_model ("progs/gib2.mdl");
	precache_model ("progs/gib3.mdl");

	precache_sound ("soldier/death1.wav");
	precache_sound ("soldier/idle.wav");
	precache_sound ("soldier/pain1.wav");
	precache_sound ("soldier/pain2.wav");
	precache_sound ("soldier/sattck1.wav");
	precache_sound ("soldier/sight1.wav");
	precache_sound ("soldier/fall_backwards.wav");
	precache_sound ("soldier/fall_forwards.wav");
	precache_sound ("soldier/reload.wav");
	precache_sound ("walk/soldier1.wav");
	precache_sound ("walk/soldier2.wav");
	precache_sound ("walk/soldier3.wav");

	precache_sound ("player/udeath.wav");		// gib death

	self.impulse = 0;
	self.cnt = 0;
	self.nojump = 1;		// dann springt er nicht von mauern (wie neh1m4 (?)

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

var float autocvar_soldiermultiskin = 0;     	// set cvar 'soldiermultiskin' default to 0
	local float zufall;
	if (autocvar_soldiermultiskin == 1)		// if 'soldiermultiskin' is set via autoexec.cfg to '1' use 2 different skins for ID1 model
	{
		self.multiskin = 1;
		setmodel (self, "progs/soldier.mdl");
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
	else if (autocvar_soldiermultiskin == 2)	// if 'soldiermultiskin' is set via autoexec.cfg to '2' use 1 Id1 model skin AND external model
	{
		self.multiskin = 2;
		precache_model ("progs/soldier1.mdl");
		precache_model ("progs/h_guard1.mdl");
		zufall = random();
		if (zufall >= 0.5)
			{
			setmodel (self, "progs/soldier.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 0;
			}
		else 
			{
			setmodel (self, "progs/soldier1.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 1;
			}
	}
	else if (autocvar_soldiermultiskin == 3)	// if 'soldiermultiskin' is set via autoexec.cfg to '3' use 2 Id1 model skins AND external model
	{
		self.multiskin = 3;
		precache_model ("progs/soldier1.mdl");
		precache_model ("progs/h_guard1.mdl");
		zufall = random();
		if (zufall > 0.66)
			{
			setmodel (self, "progs/soldier.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 0;
			}
		else if (zufall < 0.34)
			{
			setmodel (self, "progs/soldier.mdl");
			self.skin = 1;
			self.monsterskin = 1;
			self.monstermodel = 0;
			}
		else
			{
			setmodel (self, "progs/soldier1.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 1;
			}
	}
	else if (autocvar_soldiermultiskin == 4)	// if 'soldiermultiskin' is set via autoexec.cfg to '4' use 2 Id1 model skins AND 2 external model skins
	{
		self.multiskin = 4;
		precache_model ("progs/soldier1.mdl");
		precache_model ("progs/h_guard1.mdl");
		zufall = random();
		if (zufall > 0.75)
			{
			setmodel (self, "progs/soldier.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 0;
			}
		else if (zufall > 0.5 && zufall <= 0.75)
			{
			setmodel (self, "progs/soldier.mdl");
			self.skin = 1;
			self.monsterskin = 1;
			self.monstermodel = 0;
			}
		else if (zufall > 0.25 && zufall <= 0.5)
			{
			setmodel (self, "progs/soldier1.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 1;
			}
		else 
			{
			setmodel (self, "progs/soldier1.mdl");
			self.skin = 1;
			self.monsterskin = 1;
			self.monstermodel = 1;
			}
	}
	else						// standard Quake
		{
		setmodel (self, "progs/soldier.mdl");
		self.skin = 0;
		self.monsterskin = 0;
		self.monstermodel = 0;
		}

var float autocvar_soldier_size = 2;     	// set cvar 'soldier_size' default to 2
	local float zuffa;
	if (autocvar_soldier_size == 1)		// if 'soldier_size' is set via autoexec.cfg to '1' give monster random size between 100% and 114% (7% steps due to DP´s .scale restrictions)
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
	else if (autocvar_soldier_size == 2)		// if 'soldier_size' is set via autoexec.cfg to '2' give monster random size between 100% and 121% (7% steps due to DP´s .scale restrictions)
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
	else if (autocvar_soldier_size == 3)		// if 'soldier_size' is set via autoexec.cfg to '3' give monster random size between 100% and 128% (7% steps due to DP´s .scale restrictions)
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
	else if (autocvar_soldier_size == 4)		// if 'soldier_size' is set via autoexec.cfg to '4' give monster random size between 100% and 135% (7% steps due to DP´s .scale restrictions)
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
	else if (autocvar_soldier_size > 4)		// if 'soldier_size' is set via autoexec.cfg to a value bigger than '4' give monster the selected fixed size ==>  100% + [value]%  (7% steps due to DP´s .scale restrictions)
	{
		if (autocvar_soldier_size > 40)
			self.origin = self.origin + '0 0 10';		// might get stuck in floor otherwise. --> drop him to floor from higher position !
		self.scale = 1 + (autocvar_soldier_size * 0.01);
		self.sizefactor_x = 0;
		self.sizefactor_y = 0;
		self.sizefactor_z = autocvar_soldier_size * 0.25;
		self.sizediff = self.sizefactor;
		setsize (self, '-16 -16 -24' - self.sizediff, '16 16 40' - self.sizediff);
	}
	else
	{
		self.scale = 1;
		setsize (self, '-16 -16 -24', '16 16 40');
	}

var float autocvar_soldier_size_influenced_health = 0; 		  			// set cvar 'soldier_size_influenced_health' default to 0
	if (autocvar_soldier_size_influenced_health == 1)				// if 'soldier_size_influenced_health' is set via autoexec.cfg to '1' raise monster´s health according to its size  (use different formular for monsters with default health <100 and health >100 to be realistic/noticable)
		self.health = autocvar_soldier_health + ((self.scale - 1) * 100);	// default: 30
	else
		self.health = autocvar_soldier_health;					// default 30
	self.health_initial = self.health;

	if (autocvar_monster_random_skin_color_alteration && autocvar_soldier_random_skin_colors)	// modify/edit this monster types skin textures randomly (for higher variation in-game)
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
	
	self.th_stand = army_stand1;
	self.th_walk = army_walk1;
	self.th_run = army_run1;
	self.th_missile = army_atk1;
	self.th_pain = army_pain;
	self.th_die = army_die;
	if (autocvar_soldier_run_and_shoot)
		self.th_runfire = army_runshot1;

	self.alpha = autocvar_monstertransparency * 0.01;

	if (autocvar_spider_replace_soldier)		// if soldier shall be replaced by spider. Check the chance and do it !!)
		{	
		local float replacer;		
		replacer = autocvar_spider_replace_soldier * 0.01;
		if (random () <= replacer)
			{
			 local vector check;
			 check = (self.origin - ((VEC_HULL2_MIN + VEC_HULL2_MAX) * 0.5)) + '0 0 1';
			 if (((pointcontents(check) == CONTENT_WATER) && (autocvar_spider_can_spawn_in_water)) || (pointcontents(check) != CONTENT_WATER)) 	   // checks if monster is spawned in water. Spider is too small to be visible in shallow (not transparent) water, so better not change to spider.
				{
				self.skin = 0;
				self.health = 40;	// not autocvar_soldier_health for this monster
				self.scale = 1;
				setsize (self, '-16 -16 -24', '16 16 40');
				self.nextthink = time + 0.3;	
				self.think = SUB_Remove;
				monster_spider_start();
				return;
				}
			}
		}

	if (autocvar_reiver_replace_soldier)		// if shalrath shall be replaced by reiver. Check the chance and do it !!)
		{	
		local float replacez;		
		replacez = autocvar_reiver_replace_soldier * 0.01;
		if (random () <= replacez)
			{
			self.health = 50;		// not autocvar_soldier_health for this monster
			self.scale = 1;
			setsize (self, '-16 -16 -24', '16 16 40');
			self.nextthink = time + 0.3;	
			self.think = SUB_Remove;
			monster_reiver_liftorigin_start();
			return;
			}
		}

	if (autocvar_afrit_replace_soldier)		// if soldier shall be replaced by afrit. Check the chance and do it !!)
	{	
		local float replac;		
		replac = autocvar_afrit_replace_soldier * 0.01;
		if (random () <= replac)
			{
			self.health = 50;		// not autocvar_soldier_health for this monster
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

if (autocvar_reiver_supports_soldier)		// if Reiver shall be spawned in ADDITION to an existing soldier. Check the chance and do it !!)
	{	
	local float repla;		
	repla = autocvar_reiver_supports_soldier * 0.01;
	if (random () <= repla)
		add_reiver_support_walk ();
	}

if (autocvar_afrit_supports_soldier)		// if afrit shall be spawned in ADDITION to an existing soldier. Check the chance and do it !!)
	{	
	local float replace;		
	replace = autocvar_afrit_supports_soldier * 0.01;
	if (random () <= replace)
		add_afrit_support_walk ();
	}

var float autocvar_soldiermass = 1500;
MonsterPhysics (self, autocvar_soldiermass);		
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
void(string modelname, float modelframe) vengeance_soldier; 

==============================================================================
*/


void() vengeance_soldier_end1 = {					// end sequence
	self.alpha = -1;
	te_customflash (self.origin, 500, 0.7, '1 0 0');
	self.nextthink = time + 0.2;
      self.think = SUB_Remove;
};


void() vengeance_soldier_shoot = {		// player receives 1 damage when vengeance effect shoots (no chance to avoid !)

	local float shootdmg;

	var float autocvar_vengeancedamage = 0;   // set cvar 'vengeancedamage' default to 0
	if (autocvar_vengeancedamage == 0)	  	// if 'vengeancedamage' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '0'
		{						// no damage
		}
	else   	 					// if value is NOT "0" (example: "1"), player receives 1 damage 
		{
		shootdmg = 1; 		
		T_Damage (self.enemy, self, self, shootdmg); 	// analog to meele attack dog/fiend
		// T_Damage (other, self, self, shootdmg); 	// analog to jump damage dog/fiend
		}

	self.touch = SUB_Null;	// um nicht endlos damage zu kriegen !
};


void() vengeance_soldier_touch = {		// player receives 1-3  damage when he gets touched by vengeance effect

	local float ldmg;
	ldmg = rint(0.5 + (3 * random()));  	// chances=  33%: 1 damage /  33%: 2 damage  /  33%: 3 damage

	T_Damage (self.enemy, self, self, ldmg); 	// analog to meele attack dog/fiend
	// T_Damage (other, self, self, ldmg); 		// analog to jump damage dog/fiend

	self.touch = SUB_Null;			// um nicht endlos damage zu kriegen !

	self.think = vengeance_soldier_end1; 
	self.nextthink = time + 0.1;   
};
										//  from here on: run sequence. 

void() vengeance_soldier_run1 =[	$run1,	vengeance_soldier_run2 ]   {
	ai_face();
 	movetogoal (15);   // orig (11)
self.touch = vengeance_soldier_touch; 
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_soldier_run2 =[	$run2,	vengeance_soldier_run3 ]   {
	ai_face();
 	movetogoal (19);   // orig (15)
self.touch = vengeance_soldier_touch; 
	self.alpha = 0.36;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_soldier_run3 =[	$run3,	vengeance_soldier_run4 ]    {
	ai_face();
 	movetogoal (14);   // orig (10)
self.touch = vengeance_soldier_touch; 
	self.alpha = 0.33;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_soldier_run4 =[	$run4,	vengeance_soldier_run5 ]    {
	ai_face();
 	movetogoal (17);   // orig (13)
self.touch = vengeance_soldier_touch; 
	self.alpha = 0.3;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_soldier_run5 =[	$run5,	vengeance_soldier_run6 ]    {
	ai_face();
 	movetogoal (12);   // orig (8)
self.touch = vengeance_soldier_touch; 
	self.alpha = 0.27;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_soldier_run6 =[	$run6,	vengeance_soldier_run7 ]    {
	ai_face();
 	movetogoal (19);   // orig (15)
self.touch = vengeance_soldier_touch; 
	self.alpha = 0.24;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_soldier_run7 =[	$run7,	vengeance_soldier_run8 ]    {
	ai_face();
 	movetogoal (14);   // orig (10)
self.touch = vengeance_soldier_touch; 
	self.alpha = 0.21;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_soldier_run8 =[	$run8,	vengeance_soldier_shoot1 ]    {
	ai_face();
 	movetogoal (12);   // orig (8)
self.touch = vengeance_soldier_touch; 
	self.alpha = 0.2;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};

										//  from here on: attack/jump sequenz. 

void() vengeance_soldier_shoot1 =[ $shoot1,	vengeance_soldier_shoot2 ]    {
	ai_face();
self.touch = vengeance_soldier_touch; 
	self.alpha = 0.17;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_soldier_shoot2 =[ $shoot2,	vengeance_soldier_shoot3 ]    {
	ai_face();
self.touch = vengeance_soldier_touch; 
	self.alpha = 0.14;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_soldier_shoot3 =[ $shoot3,	vengeance_soldier_shoot4 ]    {
	ai_face();
self.touch = vengeance_soldier_touch; 
	self.alpha = 0.11;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_soldier_shoot4 =[ $shoot4,	vengeance_soldier_shoot5 ]    {
	ai_face();
self.touch = vengeance_soldier_touch; 
	self.alpha = 0.08;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_soldier_shoot5 =[ $shoot5,	vengeance_soldier_end1 ]    {
	ai_face();
self.touch = vengeance_soldier_touch; 
	self.alpha = 0.06;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
sound (self, CHAN_WEAPON, "soldier/sattck1.wav", 1, ATTN_NORM);	
vengeance_soldier_shoot ();
};



											//  from here on: ressurection sequence 1. 

void() vengeance_soldier11 =[	$death9,	vengeance_soldier12 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_soldier12 =[	$death8,	vengeance_soldier13 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_soldier13 =[	$death7,	vengeance_soldier14 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_soldier14 =[	$death6,	vengeance_soldier15 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_soldier15 =[	$death5,	vengeance_soldier16 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_soldier16 =[	$death4,	vengeance_soldier17 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_soldier17 =[	$death3,	vengeance_soldier18 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_soldier18 =[	$death2,	vengeance_soldier19 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_soldier19 =[	$death1,	vengeance_soldier_stand1 ]  {
	sound (self, CHAN_VOICE, "soldier/sight1.wav", 1, ATTN_NORM);
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_soldier_stand1 =[ $shoot1,	vengeance_soldier_run1 ]  {    // needed to make the animation fluent
	self.alpha = 0.4;									     	 // $shoot1 fills the frame gap
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};



											//  from here on: ressurection sequence 2. 

void() vengeance_soldier21 =[	$deathc10,	vengeance_soldier22 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_soldier22 =[	$deathc9,	vengeance_soldier23 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_soldier23 =[	$deathc8,	vengeance_soldier24 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_soldier24 =[	$deathc7,	vengeance_soldier25 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_soldier25 =[	$deathc6,	vengeance_soldier26 	]  {
// 	movetogoal (4); 			 
	walkmove (self.angles_y, 4);   
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_soldier26 =[	$deathc5,	vengeance_soldier27 	]  {
// 	movetogoal (3); 			 
	walkmove (self.angles_y, 3);   
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_soldier27 =[	$deathc4,	vengeance_soldier28 	]  {
// 	movetogoal (13);   		 
	walkmove (self.angles_y, 13);  
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_soldier28 =[	$deathc3,	vengeance_soldier29 	]  {
// 	movetogoal (4);  			
	walkmove (self.angles_y, 4);   
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_soldier29 =[	$deathc2,	vengeance_soldier210	]  {
// 	movetogoal (5);  			 
	walkmove (self.angles_y, 5);   
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_soldier210 =[ $deathc1,	vengeance_soldier_stand2 ]  {
	sound (self, CHAN_VOICE, "soldier/sight1.wav", 1, ATTN_NORM);
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_soldier_stand2 =[	$death1,	vengeance_soldier_run1 ]  {    // needed to make the animation fluent
	self.alpha = 0.4;									       // $death1 fills the frame gap
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};



								// from here on:  sequence where the corpse overbrights 
void()	vengeance_soldier_bright05 	= {
	self.alpha = 0.3;
	self.colormod = '6 1 1';
	self.glow_color = 75;
	self.glow_size = 450;
	self.nextthink = time + 0.1;
		if (self.frame == $death10)
			self.think = vengeance_soldier11;
		else
			self.think = vengeance_soldier21;
};
void()	vengeance_soldier_bright04 	= {
	self.alpha = 0.3;
	self.colormod = '5 1 1';
	self.glow_color = 75;
	self.glow_size = 350;
	self.nextthink = time + 0.1;
	self.think = vengeance_soldier_bright05;
};
void()	vengeance_soldier_bright03 	= {
	self.alpha = 0.3;
	self.colormod = '4 1 1';
	self.glow_color = 75;
	self.glow_size = 270;
	self.nextthink = time + 0.1;
	self.think = vengeance_soldier_bright04;
};
void()	vengeance_soldier_bright02 	= {
	self.alpha = 0.3;
	self.colormod = '3 1 1';
	self.glow_color = 75;
	self.glow_size = 185;
	self.nextthink = time + 0.1;
	self.think = vengeance_soldier_bright03;
}; 
void()	vengeance_soldier_bright01 	= {
	self.alpha = 0.3;
	self.colormod = '2 1 1';
	self.glow_color = 75;
	self.glow_size = 100;
	self.nextthink = time + 0.1;
	self.think = vengeance_soldier_bright02;
};
void()	vengeance_soldier_bright00 	= {  			// delay for 0.3 seconds before overbright process really begins
	self.alpha = 0.3;
	self.glow_color = 75;
	self.glow_size = 10;
	self.nextthink = time + 0.3;
	self.think = vengeance_soldier_bright01;
};



void(string modelname, float modelframe) vengeance_soldier =
{

local vector v;  			// v  was necessary at the begining of effect development, but isnt anymore now.
v_x = (self.origin_x);
v_y = (self.origin_y);
v_z = (self.origin_z);

      self.origin = v; 
   	self.touch = SUB_Null;                
	self.movetype = MOVETYPE_FLY;

	if (self.monstermodel == 0)  
		setmodel (self, "progs/soldier.mdl"); 
	else if (self.monstermodel == 1)  
		setmodel (self, "progs/soldier1.mdl"); 

	setsize (self, '-16 -16 -24', '16 16 40');
	self.frame = modelframe;	 // modelframe is depending on the individual monster (included in vengeance call)

	var float autocvar_vengeancedamage = 0;   // set cvar 'vengeancedamage' default to 0
	if (autocvar_vengeancedamage == 0)	  	// if 'vengeancedamage' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '0'
		self.solid = SOLID_NOT;			// vengeance effect is NOT solid and cannot hurt the player
	else
		self.solid = SOLID_SLIDEBOX;    	 	// if value is NOT "0", player get hurt from this effect (see func "vengeance_soldier_touch")!

	vengeance_soldier_bright00 ();			// starts the animation
};

