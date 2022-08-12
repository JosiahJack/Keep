/*
==============================================================================

SOLDIER / PLAYER

==============================================================================
*/

$cd id1/models/enforcer
$origin 0 -6 24
$base base
$skin skin

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10
$frame walk11 walk12 walk13 walk14 walk15 walk16

$frame run1 run2 run3 run4 run5 run6 run7 run8

$frame attack1 attack2 attack3 attack4 attack5 attack6
$frame attack7 attack8 attack9 attack10

$frame death1 death2 death3 death4 death5 death6 death7 death8
$frame death9 death10 death11 death12 death13 death14

$frame fdeath1 fdeath2 fdeath3 fdeath4 fdeath5 fdeath6 fdeath7 fdeath8
$frame fdeath9 fdeath10 fdeath11

$frame paina1 paina2 paina3 paina4

$frame painb1 painb2 painb3 painb4 painb5

$frame painc1 painc2 painc3 painc4 painc5 painc6 painc7 painc8

$frame paind1 paind2 paind3 paind4 paind5 paind6 paind7 paind8
$frame paind9 paind10 paind11 paind12 paind13 paind14 paind15 paind16
$frame paind17 paind18 paind19


void() Laser_Touch =
{
	local vector org;

	if (other == self.owner)
		return;		// don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

//MED 01/16/97 added silent command

   if (!(self.spawnflags & SPAWNFLAG_SILENT))
      sound (self, CHAN_WEAPON, "enforcer/enfstop.wav", 1, ATTN_STATIC);
	org = self.origin - 8*normalize(self.velocity);

	if (other.health)
	{
		SpawnBlood (org, self.velocity*0.2, 15);
		var float autocvar_enforcer_size_influenced_attack = 0; 	  			// set cvar 'enforcer_size_influenced_attack' default to 0
		if (autocvar_enforcer_size_influenced_attack == 1)					// if 'enforcer_size_influenced_attack' is set via autoexec.cfg to '1' raise monster´s attack values according to its size 
			T_Damage (other, self, self.owner, autocvar_enforcer_laser * self.owner.scale);	// default 15
		else
			T_Damage (other, self, self.owner, autocvar_enforcer_laser);			// default 15
	}
	else
	{
		pointparticles(particleeffectnum("laser_impact"), org, '0 0 0', 1); 
	}

	remove(self);
};


void() Laser_Touch2 =
{
	local vector org;

	if (other == self.owner)
		return;		// don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

//MED 01/16/97 added silent command

   if (!(self.spawnflags & SPAWNFLAG_SILENT))
      sound (self, CHAN_WEAPON, "enforcer/enfstop.wav", 1, ATTN_STATIC);
	org = self.origin - 8*normalize(self.velocity);

	if (other.health)
	{
		SpawnBlood (org, self.velocity*0.2, 15);
		T_Damage (other, self, self.owner, 15);
	}
	else
	{
		pointparticles(particleeffectnum("laser_impact2"), org, '0 0 0', 1); 
	}

	remove(self);
};


void(vector org, vector vec) LaunchLaser =
{
	local	vector	vec;

	if (self.classname == "monster_enforcer")
		sound (self, CHAN_WEAPON, "enforcer/enfire.wav", 1, ATTN_NORM);

	vec = normalize(vec);

	newmis = spawn();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLY;
	newmis.solid = SOLID_BBOX;
	/*
	newmis.effects = EF_DIMLIGHT;
	*/
newmis.traileffectnum = particleeffectnum("laser_trail");

	setmodel (newmis, "progs/laser.mdl");
	setsize (newmis, '0 0 0', '0 0 0');

	setorigin (newmis, org);

	newmis.velocity = vec * 600;
	newmis.angles = vectoangles(newmis.velocity);

	newmis.nextthink = time + 5;
	newmis.think = SUB_Remove;
	newmis.touch = Laser_Touch;
};


void(vector org, vector vec) LaunchLaser2 =
{
	local	vector	vec;
		
	if (self.classname == "monster_enforcer")
		sound (self, CHAN_WEAPON, "enforcer/enfire.wav", 1, ATTN_NORM);

	vec = normalize(vec);
	
	newmis = spawn();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLY;
	newmis.solid = SOLID_BBOX;
	/*
	newmis.effects = EF_DIMLIGHT;
	*/
newmis.traileffectnum = particleeffectnum("laser_trail2");

	setmodel (newmis, "progs/laser.mdl");
	setsize (newmis, '0 0 0', '0 0 0');		

	setorigin (newmis, org);

	newmis.velocity = vec * 600;
	newmis.angles = vectoangles(newmis.velocity);

	newmis.nextthink = time + 5;
	newmis.think = SUB_Remove;
	newmis.touch = Laser_Touch2;
};



void() enforcer_fire =
{
	local vector org;

	self.effects = self.effects | EF_MUZZLEFLASH;
	makevectors (self.angles);

	org = self.origin + v_forward * 30 + v_right * 8.5 + '0 0 16';

	LaunchLaser(org, self.enemy.origin - self.origin);
};

//============================================================================


void(float loudness) enforcer_footsteps =
{
if (autocvar_monsterfootsteps == 1)	// only play monster footsteps sound when cvar is 1
	{
	local float select;
	select = random();
	if (select <= 0.25)
		sound(self, CHAN_AUTO, "walk/enforcer1.wav", loudness, ATTN_IDLE);
	else if (select <= 0.5)
		sound(self, CHAN_AUTO, "walk/enforcer2.wav", loudness, ATTN_IDLE);
	else if (select <= 0.75)
		sound(self, CHAN_AUTO, "walk/enforcer3.wav", loudness, ATTN_IDLE);
	else 
		sound(self, CHAN_AUTO, "walk/enforcer4.wav", loudness, ATTN_IDLE);
	}
};


void()	enf_stand1	=[	$stand1,	enf_stand2	] {ai_stand();};
void()	enf_stand2	=[	$stand2,	enf_stand3	] {ai_stand();};
void()	enf_stand3	=[	$stand3,	enf_stand4	] {ai_stand();};
void()	enf_stand4	=[	$stand4,	enf_stand5	] {ai_stand();};
void()	enf_stand5	=[	$stand5,	enf_stand6	] {ai_stand();};
void()	enf_stand6	=[	$stand6,	enf_stand7	] {ai_stand();};
void()	enf_stand7	=[	$stand7,	enf_stand1	] {ai_stand();};

void()	enf_walk1	=[	$walk1 ,	enf_walk2	] {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "enforcer/idle1.wav", 1, ATTN_IDLE);
ai_walk(2);enforcer_footsteps (0.95);};
void()	enf_walk2	=[	$walk2 ,	enf_walk3	] {ai_walk(4);};
void()	enf_walk3	=[	$walk3 ,	enf_walk4	] {ai_walk(4);};
void()	enf_walk4	=[	$walk4 ,	enf_walk5	] {ai_walk(3);};
void()	enf_walk5	=[	$walk5 ,	enf_walk6	] {ai_walk(1);};
void()	enf_walk6	=[	$walk6 ,	enf_walk7	] {ai_walk(2);};
void()	enf_walk7	=[	$walk7 ,	enf_walk8	] {ai_walk(2);};
void()	enf_walk8	=[	$walk8 ,	enf_walk9	] {ai_walk(1);};
void()	enf_walk9	=[	$walk9 ,	enf_walk10	] {ai_walk(2);};
void()	enf_walk10	=[	$walk10,	enf_walk11	] {ai_walk(4);enforcer_footsteps (0.95);};
void()	enf_walk11	=[	$walk11,	enf_walk12	] {ai_walk(4);};
void()	enf_walk12	=[	$walk12,	enf_walk13	] {ai_walk(1);};
void()	enf_walk13	=[	$walk13,	enf_walk14	] {ai_walk(2);};
void()	enf_walk14	=[	$walk14,	enf_walk15	] {ai_walk(3);};
void()	enf_walk15	=[	$walk15,	enf_walk16	] {ai_walk(4);};
void()	enf_walk16	=[	$walk16,	enf_walk1	] {ai_walk(2);};

void()	enf_run1	=[	$run1  ,	enf_run2	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);
if (random() < 0.2)
	sound (self, CHAN_VOICE, "enforcer/idle1.wav", 1, ATTN_IDLE);
ai_run(18);};
void()	enf_run2	=[	$run2  ,	enf_run3	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(14);};
void()	enf_run3	=[	$run3  ,	enf_run4	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(7);enforcer_footsteps (1);};
void()	enf_run4	=[	$run4  ,	enf_run5	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(12);};
void()	enf_run5	=[	$run5  ,	enf_run6	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(14);};
void()	enf_run6	=[	$run6  ,	enf_run7	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(14);};
void()	enf_run7	=[	$run7  ,	enf_run8	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(7);enforcer_footsteps (1);};
void()	enf_run8	=[	$run8  ,	enf_run1	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(11);};

void()	enf_atk1	=[	$attack1,	enf_atk2	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void()	enf_atk2	=[	$attack2,	enf_atk3	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void()	enf_atk3	=[	$attack3,	enf_atk4	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void()	enf_atk4	=[	$attack4,	enf_atk5	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void()	enf_atk5	=[	$attack5,	enf_atk6	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void()	enf_atk6	=[	$attack6,	enf_atk7	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);enforcer_fire();};
void()	enf_atk7	=[	$attack7,	enf_atk8	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void()	enf_atk8	=[	$attack8,	enf_atk9	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void()	enf_atk9	=[	$attack5,	enf_atk10	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void()	enf_atk10	=[	$attack6,	enf_atk11	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);enforcer_fire();};
void()	enf_atk11	=[	$attack7,	enf_atk12	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void()	enf_atk12	=[	$attack8,	enf_atk13	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void()	enf_atk13	=[	$attack9,	enf_atk14	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void()	enf_atk14	=[	$attack10,	enf_run1	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();
SUB_CheckRefire (enf_atk1);
};

void()	enf_paina1	=[	$paina1,	enf_paina2	] {};
void()	enf_paina2	=[	$paina2,	enf_paina3	] {};
void()	enf_paina3	=[	$paina3,	enf_paina4	] {};
void()	enf_paina4	=[	$paina4,	enf_run1	] {};

void()	enf_painb1	=[	$painb1,	enf_painb2	] {};
void()	enf_painb2	=[	$painb2,	enf_painb3	] {};
void()	enf_painb3	=[	$painb3,	enf_painb4	] {};
void()	enf_painb4	=[	$painb4,	enf_painb5	] {};
void()	enf_painb5	=[	$painb5,	enf_run1	] {};

void()	enf_painc1	=[	$painc1,	enf_painc2	] {};
void()	enf_painc2	=[	$painc2,	enf_painc3	] {};
void()	enf_painc3	=[	$painc3,	enf_painc4	] {};
void()	enf_painc4	=[	$painc4,	enf_painc5	] {};
void()	enf_painc5	=[	$painc5,	enf_painc6	] {};
void()	enf_painc6	=[	$painc6,	enf_painc7	] {};
void()	enf_painc7	=[	$painc7,	enf_painc8	] {};
void()	enf_painc8	=[	$painc8,	enf_run1	] {};

void()	enf_paind1	=[	$paind1,	enf_paind2	] {};
void()	enf_paind2	=[	$paind2,	enf_paind3	] {};
void()	enf_paind3	=[	$paind3,	enf_paind4	] {};
void()	enf_paind4	=[	$paind4,	enf_paind5	] {ai_painforward(2);};
void()	enf_paind5	=[	$paind5,	enf_paind6	] {ai_painforward(1);};
void()	enf_paind6	=[	$paind6,	enf_paind7	] {};
void()	enf_paind7	=[	$paind7,	enf_paind8	] {};
void()	enf_paind8	=[	$paind8,	enf_paind9	] {};
void()	enf_paind9	=[	$paind9,	enf_paind10	] {};
void()	enf_paind10	=[	$paind10,	enf_paind11	] {};
void()	enf_paind11	=[	$paind11,	enf_paind12	] {ai_painforward(1);};
void()	enf_paind12	=[	$paind12,	enf_paind13	] {ai_painforward(1);};
void()	enf_paind13	=[	$paind13,	enf_paind14	] {ai_painforward(1);enforcer_footsteps (0.9);};
void()	enf_paind14	=[	$paind14,	enf_paind15	] {};
void()	enf_paind15	=[	$paind15,	enf_paind16	] {};
void()	enf_paind16	=[	$paind16,	enf_paind17	] {ai_pain(1);};
void()	enf_paind17	=[	$paind17,	enf_paind18	] {ai_pain(1);};
void()	enf_paind18	=[	$paind18,	enf_paind19	] {};
void()	enf_paind19	=[	$paind19,	enf_run1	] {};

void(entity attacker, float damage)	enf_pain =
{
	local float r;

	r = random ();
	if (self.pain_finished > time)
		return;
	
	if (autocvar_slowmotion >= 4)	// start slowmotion when hurting enemies
	{
		if (random () <= (autocvar_slowmotion_randomness_enforcer * 0.01))
			{
			the_matrix = 1;
			matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
			}
	}

	if (r < 0.5)
		sound (self, CHAN_VOICE, "enforcer/pain1.wav", 1, ATTN_NORM);
	else
		sound (self, CHAN_VOICE, "enforcer/pain2.wav", 1, ATTN_NORM);

	if (r < 0.2)
	{
		self.pain_finished = time + 1;
		enf_paina1 ();
	}
	else if (r < 0.4)
	{
		self.pain_finished = time + 1;
		enf_painb1 ();
	}
	else if (r < 0.7)
	{
		self.pain_finished = time + 1;
		enf_painc1 ();
	}
	else
	{
		self.pain_finished = time + 2;
		enf_paind1 ();
	}
};

//============================================================================



void() enf_dieburn1	=[	$death1,	enf_dieburn2	] {self.burnz_origin = 12;
burn_toggle_allround();
};
void() enf_dieburn2	=[	$death2,	enf_dieburn3	] {self.burnz_origin = 11;
};
void() enf_dieburn3	=[	$death3,	enf_dieburn4	] {self.burnz_origin = 6;
self.solid = SOLID_NOT;
self.ammo_cells = autocvar_backpack_enforcer_cells;	// default 5
self.backpack_thrower = 2; DropBackpack();
};
void() enf_dieburn4	=[	$death4,	enf_dieburn5	] {self.burnz_origin = 3;
};
void() enf_dieburn5	=[	$death5,	enf_dieburn6	] {self.burnz_origin = 0;
};
void() enf_dieburn6	=[	$death6,	enf_dieburn7	] {self.burnz_origin = -2;
};
void() enf_dieburn7	=[	$death7,	enf_dieburn8	] {self.burnz_origin = -4;
};
void() enf_dieburn8	=[	$death8,	enf_dieburn9	] {self.burnz_origin = -6;
};
void() enf_dieburn9	=[	$death9,	enf_dieburn10	] {self.burnz_origin = -8;
};
void() enf_dieburn10	=[	$death10,	enf_dieburn10	] {self.burnz_origin = -10;
};


var float autocvar_enforcer = 3;     		// set cvar 'enforcer' default to 3
var float autocvar_enforcercorpsehealth = 60;	// set cvar 'enforcercorpsehealth' default to 60
var float autocvar_enforcercorpseburnable = 0;	// set cvar 'enforcercorpseburnable' default to 0

void()	enf_die1	=[	$death1,	enf_die2	] {};
void()	enf_die2	=[	$death2,	enf_die3	] {};
void()	enf_die3	=[	$death3,	enf_die4	]
{self.solid = SOLID_NOT;self.ammo_cells = autocvar_backpack_enforcer_cells;	// default 5
self.backpack_thrower = 2; DropBackpack();};
void()	enf_die4	=[	$death4,	enf_die5	] {ai_forward(14);};
void()	enf_die5	=[	$death5,	enf_die6	] {ai_forward(2);};
void()	enf_die6	=[	$death6,	enf_die7	] {};
void()	enf_die7	=[	$death7,	enf_die8	] {};
void()	enf_die8	=[	$death8,	enf_die9	] {};
void()	enf_die9	=[	$death9,	enf_die10	] {ai_forward(3);};
void()	enf_die10	=[	$death10,	enf_die11	] {ai_forward(5);sound (self, CHAN_AUTO, "enforcer/fall_forwards.wav", 1, ATTN_IDLE);};
void()	enf_die11	=[	$death11,	enf_die12	] {ai_forward(5);};
void()	enf_die12	=[	$death12,	enf_die13	] {ai_forward(5);};
void()	enf_die13	=[	$death13,	enf_die14	] {};
void()	enf_die14	=[	$death14,	enf_die14	] {
if (self.inflamed == 1)
{
	inflamed_die ();
	return;
}
local float zufall, zet, randomness;
	zet = 25;					// z-position of the wings (in relation to soul). Dependent on corpse size.
	if (autocvar_enforcercorpseburnable == 1)	// corpses are burnable
		self.burnable_corpse = 1;
// 	auto_cvar 'enforcercorpsehealth' has been set to  default = 60  in code above already

	if (self.monstermodel == 0)  
		CopyMonsterToBodyQue(autocvar_enforcercorpsehealth, "progs/h_mega.mdl");
	if (self.monstermodel == 1)  
		CopyMonsterToBodyQue(autocvar_enforcercorpsehealth, "progs/h_mega1.mdl");
if (self.nodeathanim == 1)
	return;
if (self.grimrock_helper == 0)
{
// 	auto_cvar 'enforcer' has been declared in code above already
	var float autocvar_enforcerrandomness = 25;     	// set cvar 'enforcerrandomness' default to 25%
	autocvar_enforcerrandomness = autocvar_enforcerrandomness * 0.01;
	if (autocvar_enforcer == 1)			// if 'enforcer' is set via autoexec.cfg to '1' start ghost effect
		{
		randomness = random();
		if (randomness <= autocvar_enforcerrandomness)	// checks if death animation shall be started
			ghost_die ();
		}
	else if (autocvar_enforcer == 2)		// if 'enforcer' is set via autoexec.cfg to '2' start soul effect
		{
		randomness = random();
		if (randomness <= autocvar_enforcerrandomness)	// checks if death animation shall be started
			{
			if (self.monstermodel == 0)  
				soul ("progs/enforcer.mdl", $death14, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
			else if (self.monstermodel == 1)  
				soul ("progs/enforcer1.mdl", $death14, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
			}
		}
	else if (autocvar_enforcer == 3)		// if 'enforcer' is set via autoexec.cfg to '3' start vengeance effect
		{
		randomness = random();
		if (randomness <= autocvar_enforcerrandomness)	// checks if death animation shall be started
			vengeance_enforcer ("progs/enforcer.mdl", $death14); 
		}
	else if (autocvar_enforcer == 5)		// if 'enforcer' is set via autoexec.cfg to '5' start randomly one of these Death animations: 
		{					// (Ancient ghosts of the fallen ; Relieved souls of the enslaved ; Vengeance of the deceased)
		randomness = random();			// chance for effects (approx.): 36% / 26% / 38%
		if (randomness <= autocvar_enforcerrandomness)	// checks if death animation shall be started --> depending on monsters _randomness
			{				
			zufall = random();
			if (zufall > 0.64)
				ghost_die ();
			else if (zufall < 0.26)
				{
				if (self.monstermodel == 0)  
					soul ("progs/enforcer.mdl", $death14, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
				else if (self.monstermodel == 1)  
					soul ("progs/enforcer1.mdl", $death14, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
				}
			else
				vengeance_enforcer ("progs/enforcer.mdl", $death14);
			}
		}
	else				// if 'enforcer' is set via autoexec.cfg to another value (example '0'), do nothing !
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
			soul ("progs/enforcer.mdl", $death14, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
		else if (self.monstermodel == 1)  
			soul ("progs/enforcer1.mdl", $death14, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
		}
	else
		vengeance_enforcer ("progs/enforcer.mdl", $death14);
	}
};


void()	enf_fdie1	=[	$fdeath1,	enf_fdie2	] {};
void()	enf_fdie2	=[	$fdeath2,	enf_fdie3	] {};
void()	enf_fdie3	=[	$fdeath3,	enf_fdie4	] 
{self.solid = SOLID_NOT; self.ammo_cells = autocvar_backpack_enforcer_cells;	// default 5
self.backpack_thrower = 2; DropBackpack();};
void()	enf_fdie4	=[	$fdeath4,	enf_fdie5	] {};
void()	enf_fdie5	=[	$fdeath5,	enf_fdie6	] {};
void()	enf_fdie6	=[	$fdeath6,	enf_fdie7	] {};
void()	enf_fdie7	=[	$fdeath7,	enf_fdie8	] {};
void()	enf_fdie8	=[	$fdeath8,	enf_fdie9	] {};
void()	enf_fdie9	=[	$fdeath9,	enf_fdie10	] {sound (self, CHAN_AUTO, "enforcer/fall_backwards.wav", 1, ATTN_IDLE);};
void()	enf_fdie10	=[	$fdeath10,	enf_fdie11	] {};
void()	enf_fdie11	=[	$fdeath11,	enf_fdie11	] {
if (self.inflamed == 1)
{
	inflamed_die ();
	return;
}
local float zufall, zet, randomness;
	zet = 25;						// z-position of the wings (in relation to soul). Dependent on corpse size.
	if (autocvar_enforcercorpseburnable == 1)	// corpses are burnable
		self.burnable_corpse = 1;
// 	auto_cvar 'enforcercorpsehealth' has been set to  default = 60  in code above already

	if (self.monstermodel == 0)  
		CopyMonsterToBodyQue(autocvar_enforcercorpsehealth, "progs/h_mega.mdl");
	if (self.monstermodel == 1)  
		CopyMonsterToBodyQue(autocvar_enforcercorpsehealth, "progs/h_mega1.mdl");
if (self.nodeathanim == 1)
	return;

if (self.grimrock_helper == 0)
{
// 	auto_cvar 'enforcer' has been declared in code above already
	var float autocvar_enforcerrandomness = 25;     	// set cvar 'enforcerrandomness' default to 25%
	autocvar_enforcerrandomness = autocvar_enforcerrandomness * 0.01;
	if (autocvar_enforcer == 1)			// if 'enforcer' is set via autoexec.cfg to '1' start ghost effect
		{
		randomness = random();
		if (randomness <= autocvar_enforcerrandomness)	// checks if death animation shall be started
			ghost_die ();
		}
	else if (autocvar_enforcer == 2)		// if 'enforcer' is set via autoexec.cfg to '2' start soul effect
		{
		randomness = random();
		if (randomness <= autocvar_enforcerrandomness)	// checks if death animation shall be started
			{
			if (self.monstermodel == 0)  
				soul ("progs/enforcer.mdl", $fdeath11, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
			else if (self.monstermodel == 1)  
				soul ("progs/enforcer1.mdl", $fdeath11, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
			}
		}
	else if (autocvar_enforcer == 3)		// if 'enforcer' is set via autoexec.cfg to '3' start vengeance effect
		{
		randomness = random();
		if (randomness <= autocvar_enforcerrandomness)	// checks if death animation shall be started
			vengeance_enforcer ("progs/enforcer.mdl", $fdeath11); 
		}
	else if (autocvar_enforcer == 5)		// if 'enforcer' is set via autoexec.cfg to '5' start randomly one of these Death animations: 
		{					// (Ancient ghosts of the fallen ; Relieved souls of the enslaved ; Vengeance of the deceased)
		randomness = random();			// chance for effects (approx.): 36% / 26% / 38%
		if (randomness <= autocvar_enforcerrandomness)	// checks if death animation shall be started --> depending on monsters _randomness
			{				
			zufall = random();
			if (zufall > 0.64)
				ghost_die ();
			else if (zufall < 0.26)
				{
				if (self.monstermodel == 0)  
					soul ("progs/enforcer.mdl", $fdeath11, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
				else if (self.monstermodel == 1)  
					soul ("progs/enforcer1.mdl", $fdeath11, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
				}
			else
				vengeance_enforcer ("progs/enforcer.mdl", $fdeath11);
			}
		}
	else				// if 'enforcer' is set via autoexec.cfg to another value (example '0'), do nothing !
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
			soul ("progs/enforcer.mdl", $fdeath11, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
		else if (self.monstermodel == 1)  
			soul ("progs/enforcer1.mdl", $fdeath11, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
		}
	else
		vengeance_enforcer ("progs/enforcer.mdl", $fdeath11);
	}
};


void(float maxgibs, float gibscounter) producegibs_enforcer =	// creates as many gib-sets as defined in cvar 'gibsmultiplier'
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
producegibs_enforcer (maxgibs, gibscounter);
};


void()	enforcer_lightning_death	=[	$painb4,	enforcer_lightning_death1	] {
if (autocvar_lightninggun_death_animation == 2)	  // start the "fade" effect instead of "coal" effect
	{
	self.ammo_cells = autocvar_backpack_enforcer_cells;	// default 5
	self.backpack_thrower = 2;
	lightninggun_death_fade();
	}
};

void()	enforcer_lightning_death1	=[	$painb4,	enforcer_lightning_death1	] {
self.solid = SOLID_NOT;
self.baked = 1;
self.colormod = '0.25 0.22 0.22';	// skins gets darker (looks burned)
if (self.monstermodel == 0)  
	CopyMonsterToBodyQue(1, "progs/h_mega.mdl");
if (self.monstermodel == 1)  
	CopyMonsterToBodyQue(1, "progs/h_mega1.mdl");
};


void() enf_die;
void() enf_inflamed9;
void() enf_inflamed15;

void()	enf_inflamed1	=[	$run1,	enf_inflamed2	] {ai_run_inflamed(18); self.nextthink = time + 0.07;
local float r;
r = random();
if (r < 0.4)
	sound (self, CHAN_VOICE, "enforcer/pain1.wav", 1, ATTN_NORM);
else if (r < 0.8)
	sound (self, CHAN_VOICE, "enforcer/pain2.wav", 1, ATTN_NORM);
};
void()	enf_inflamed2 =[	$run2,	enf_inflamed3	] {ai_run_inflamed(14); self.nextthink = time + 0.07;};
void()	enf_inflamed3 =[	$run3,	enf_inflamed4	] {ai_run_inflamed(7); enforcer_footsteps (1); self.nextthink = time + 0.07;};
void()	enf_inflamed4 =[	$run4,	enf_inflamed5	] {ai_run_inflamed(12); self.nextthink = time + 0.07;};
void()	enf_inflamed5 =[	$run5,	enf_inflamed6	] {ai_run_inflamed(14); self.nextthink = time + 0.07;};
void()	enf_inflamed6 =[	$run6,	enf_inflamed7	] {ai_run_inflamed(14); self.nextthink = time + 0.07;};
void()	enf_inflamed7 =[	$run7,	enf_inflamed8	] {ai_run_inflamed(7); enforcer_footsteps (1); self.nextthink = time + 0.07;};
void()	enf_inflamed8 =[	$run8,	enf_inflamed1	] {ai_run_inflamed(11); self.nextthink = time + 0.07;
if (self.inflametime < time)
{
	enf_die ();
	return;
}
local float r;
r = random();
if (r < 0.22)
	enf_inflamed9 ();	// pain anim (lean backwards)
else if (r < 0.45)
	enf_inflamed15 ();	// pain anim (on knees)
};

void()	enf_inflamed9 =[	$painb1, enf_inflamed10	] { self.nextthink = time + 0.07;
local float r;
r = random();
if (r < 0.4)
	sound (self, CHAN_VOICE, "enforcer/pain1.wav", 1, ATTN_NORM);
else if (r < 0.8)
	sound (self, CHAN_VOICE, "enforcer/pain2.wav", 1, ATTN_NORM);
};
void()	enf_inflamed10 =[	$painb2, enf_inflamed11	] { self.nextthink = time + 0.07;};
void()	enf_inflamed11 =[	$painb3, enf_inflamed12	] { self.nextthink = time + 0.07;};
void()	enf_inflamed12 =[	$painb4, enf_inflamed13	] { self.nextthink = time + 0.07;};
void()	enf_inflamed13 =[	$painb5, enf_inflamed14	] { self.nextthink = time + 0.07;};
void()	enf_inflamed14 =[	$run8, enf_inflamed1	] {ai_run_inflamed(6); self.nextthink = time + 0.07;
if (self.inflametime < time)
{
	enf_die ();
	return;
}
};

void()	enf_inflamed15	=[	$paind1, enf_inflamed16	] { self.nextthink = time + 0.07;};
void()	enf_inflamed16	=[	$paind2, enf_inflamed17	] { self.nextthink = time + 0.07;
local float r;
r = random();
if (r < 0.4)
	sound (self, CHAN_VOICE, "enforcer/pain1.wav", 1, ATTN_NORM);
else if (r < 0.8)
	sound (self, CHAN_VOICE, "enforcer/pain2.wav", 1, ATTN_NORM);
};
void()	enf_inflamed17	=[	$paind3, enf_inflamed18	] { self.nextthink = time + 0.07;};
void()	enf_inflamed18	=[	$paind4, enf_inflamed19	] { ai_painforward(2); self.nextthink = time + 0.07;};
void()	enf_inflamed19	=[	$paind5, enf_inflamed20	] { ai_painforward(1); self.nextthink = time + 0.07;};
void()	enf_inflamed20	=[	$paind6, enf_inflamed21	] { self.nextthink = time + 0.07;};
void()	enf_inflamed21	=[	$paind7, enf_inflamed22	] { self.nextthink = time + 0.06;};
void()	enf_inflamed22	=[	$paind8, enf_inflamed23	] { self.nextthink = time + 0.06;};
void()	enf_inflamed23	=[	$paind9, enf_inflamed24	] { self.nextthink = time + 0.06;};
void()	enf_inflamed24	=[	$paind10, enf_inflamed25 ] { self.nextthink = time + 0.06;};
void()	enf_inflamed25	=[	$paind11, enf_inflamed26 ] { ai_painforward(1); self.nextthink = time + 0.06;};
void()	enf_inflamed26	=[	$paind12, enf_inflamed27 ] { ai_painforward(1); self.nextthink = time + 0.06;};
void()	enf_inflamed27	=[	$paind13, enf_inflamed28 ] { ai_painforward(1);enforcer_footsteps (0.9); self.nextthink = time + 0.06;};
void()	enf_inflamed28	=[	$paind14, enf_inflamed29 ] { self.nextthink = time + 0.06;};
void()	enf_inflamed29	=[	$paind15, enf_inflamed30 ] { self.nextthink = time + 0.07;};
void()	enf_inflamed30	=[	$paind16, enf_inflamed31 ] { ai_pain(1); self.nextthink = time + 0.07;};
void()	enf_inflamed31	=[	$paind17, enf_inflamed32 ] { ai_pain(1); self.nextthink = time + 0.07;};
void()	enf_inflamed32	=[	$paind18, enf_inflamed33 ] { self.nextthink = time + 0.07;};
void()	enf_inflamed33	=[	$paind19, enf_inflamed1	] { self.nextthink = time + 0.07;
if (self.inflametime < time)
{
	enf_die ();
	return;
}
};




void() enf_die =
{
	if (autocvar_lightninggun_death_animation)		// if 'lightninggun_death_animation' is enabled
	{
		if (self.enemy.weapon == IT_LIGHTNING)		// when enemy was killed with lightning gun, go into baked mode
		{
			enforcer_lightning_death();
			return;
		}
	}
local float maxgibs, gibscounter;
// check for gib
	if (self.health < -35)
	{
		if (autocvar_slowmotion >= 1)	// start slowmotion when gibbing living enemies
			{
			if (random () <= (autocvar_slowmotion_randomness_enforcer * 0.01))
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
					ThrowHead ("progs/h_mega.mdl", self.health);
				else if (self.monstermodel == 1)  
					ThrowHead ("progs/h_mega1.mdl", self.health);
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
					ThrowHead ("progs/h_mega.mdl", self.health);
				else if (self.monstermodel == 1)  
					ThrowHead ("progs/h_mega1.mdl", self.health);
				if (autocvar_heartgib >= 1)		// if 'heartgib' doesnt exist in autoexec.cfg, or if 'heartgib' is set via autoexec.cfg to '1' or higher
					ThrowHeart ("progs/gibheart.mdl", self.health);
				maxgibs = autocvar_gibsmultiplier;
				gibscounter = 0;
				if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
					pointparticles(particleeffectnum("blood_monster_gib"), self.origin, '0 0 0', 1);
				producegibs_enforcer (maxgibs, gibscounter);
				return;
				}
	}

	if (autocvar_burning_monsters_death_animation)		// if 'burning_monsters_death_animation' is enabled
	{
		if (self.inflamed == 0)		// enemy is not burning
		{
			local float zufa;
			zufa = random() * 100;
			if (((self.enemy.weapon == IT_GRENADE_LAUNCHER) || (self.enemy.weapon == IT_ROCKET_LAUNCHER) || (self.enemy.weapon == IT_PROXIMITY_GUN)) && (zufa <= autocvar_burning_monsters_death_animation) && (self.watertype != CONTENT_WATER))	// when enemy was killed with explosives, set it on fire
			{
				self.inflamed = 1;
				self.traileffectnum = particleeffectnum("burning_monster");
				self.inflametime = time + autocvar_burning_monsters_death_animation_time + random();
				enf_inflamed1 ();
				return;
			}
		}
		else		// enemy is burning already and his "run-around-in-panic-time" has just ended
		{
			sound (self, CHAN_VOICE, "enforcer/death1.wav", 1, ATTN_NORM);
			if (random() > 0.5)
				enf_die1 ();
			else
				enf_fdie1 ();
			return;
		}
	}

// regular death

local float zufall, randomness;
// auto_cvar 'enforcer' has been declared in code above already
var float autocvar_enforcerrandomness = 25;     	// set cvar 'enforcerrandomness' default to 25%
autocvar_enforcerrandomness = autocvar_enforcerrandomness * 0.01;
if (autocvar_enforcer == 4)		// if 'enforcer' is set via autoexec.cfg to '4' start Death animation with "Legend of Grimrock" effect
	{
	randomness = random();
	if (randomness <= autocvar_enforcerrandomness)	// checks if death animation shall be started
		{
		//Gyro_Object_ClearPhysics(self);	// ENABLE this line if you want to disable GYRO during new "Legend of Grimrock" animation !!
		enf_dieburn1();
		return;			// jump out of this function !!
		}
	}
if (autocvar_enforcer == 6)		// if 'enforcer' is set via autoexec.cfg to '6' start random Death animation (all 4 effects !!)
	{				// chance for effects (approx.): 25% / 25% / 25% / 25%  
	randomness = random();
	if (randomness <= autocvar_enforcerrandomness)	// checks if death animation shall be started --> depending on monsters _randomness
		{					
		zufall = random();
		if (zufall <= 0.26)
			{
			//Gyro_Object_ClearPhysics(self);   // ENABLE this line if you want to disable GYRO during new "Legend of Grimrock" animation !!
			enf_dieburn1();
			return;		// jump out of this function !!
			}		// if zufall is bigger than 0.26, use new code inside  upcoming function  for other 3 death animations
		else 
			self.grimrock_helper = 1;	// this float helps me to manipulate the other 3 death animations
		}
	else
		self.grimrock_helper = 2;	// this float helps me to manipulate the other 3 death animations
	}
	
// if 'enforcer' has another value is checked inside prior function (= death animation function)

	if (autocvar_slowmotion >= 3)	// start slowmotion when regular killing living enemies
		{
		if (random () <= (autocvar_slowmotion_randomness_enforcer * 0.01))
			{
			the_matrix = 1;
			matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
			}
		}
	sound (self, CHAN_VOICE, "enforcer/death1.wav", 1, ATTN_NORM);
	if (random() > 0.5)
		enf_die1 ();
	else
		enf_fdie1 ();
};



/*QUAKED monster_enforcer (1 0 0) (-16 -16 -24) (16 16 40) Ambush

*/
void() monster_enforcer =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model2 ("progs/enforcer.mdl");
	precache_model2 ("progs/h_mega.mdl");
	precache_model2 ("progs/laser.mdl");

	precache_sound2 ("enforcer/death1.wav");
	precache_sound2 ("enforcer/enfire.wav");
	precache_sound2 ("enforcer/enfstop.wav");
	precache_sound2 ("enforcer/idle1.wav");
	precache_sound2 ("enforcer/pain1.wav");
	precache_sound2 ("enforcer/pain2.wav");
	precache_sound2 ("enforcer/sight1.wav");
	precache_sound2 ("enforcer/sight2.wav");
	precache_sound2 ("enforcer/sight3.wav");
	precache_sound2 ("enforcer/sight4.wav");
	precache_sound ("enforcer/fall_backwards.wav");
	precache_sound ("enforcer/fall_forwards.wav");
	precache_sound ("walk/enforcer1.wav");
	precache_sound ("walk/enforcer2.wav");
	precache_sound ("walk/enforcer3.wav");
	precache_sound ("walk/enforcer4.wav");
	
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	
var float autocvar_enforcermultiskin = 0;     	// set cvar 'enforcermultiskin' default to 0
	local float zufall;
	if (autocvar_enforcermultiskin == 1)		// if 'enforcermultiskin' is set via autoexec.cfg to '1' use 2 different skins for ID1 model
	{
		self.multiskin = 1;
		setmodel (self, "progs/enforcer.mdl");
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
	else if (autocvar_enforcermultiskin == 2)	// if 'enforcermultiskin' is set via autoexec.cfg to '2' use 1 Id1 model skin AND external model
	{
		self.multiskin = 2;
		precache_model ("progs/enforcer1.mdl");
		precache_model ("progs/h_mega1.mdl");
		zufall = random();
		if (zufall >= 0.5)
			{
			setmodel (self, "progs/enforcer.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 0;
			}
		else 
			{
			setmodel (self, "progs/enforcer1.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 1;
			}
	}
	else if (autocvar_enforcermultiskin == 3)	// if 'enforcermultiskin' is set via autoexec.cfg to '3' use 2 Id1 model skins AND external model
	{
		self.multiskin = 3;
		precache_model ("progs/enforcer1.mdl");
		precache_model ("progs/h_mega1.mdl");
		zufall = random();
		if (zufall > 0.66)
			{
			setmodel (self, "progs/enforcer.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 0;
			}
		else if (zufall < 0.34)
			{
			setmodel (self, "progs/enforcer.mdl");
			self.skin = 1;
			self.monsterskin = 1;
			self.monstermodel = 0;
			}
		else
			{
			setmodel (self, "progs/enforcer1.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 1;
			}
	}
	else if (autocvar_enforcermultiskin == 4)	// if 'enforcermultiskin' is set via autoexec.cfg to '4' use 2 Id1 model skins AND 2 external model skins
	{
		self.multiskin = 4;
		precache_model ("progs/enforcer1.mdl");
		precache_model ("progs/h_mega1.mdl");
		zufall = random();
		if (zufall > 0.75)
			{
			setmodel (self, "progs/enforcer.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 0;
			}
		else if (zufall > 0.5 && zufall <= 0.75)
			{
			setmodel (self, "progs/enforcer.mdl");
			self.skin = 1;
			self.monsterskin = 1;
			self.monstermodel = 0;
			}
		else if (zufall > 0.25 && zufall <= 0.5)
			{
			setmodel (self, "progs/enforcer1.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 1;
			}
		else 
			{
			setmodel (self, "progs/enforcer1.mdl");
			self.skin = 1;
			self.monsterskin = 1;
			self.monstermodel = 1;
			}
	}
	else						// standard Quake
		{
		setmodel (self, "progs/enforcer.mdl");
		self.skin = 0;
		self.monsterskin = 0;
		self.monstermodel = 0;
		}

var float autocvar_enforcer_size = 2;     		// set cvar 'enforcer_size' default to 2
	local float zuffa;
	if (autocvar_enforcer_size == 1)		// if 'enforcer_size' is set via autoexec.cfg to '1' give monster random size between 100% and 114% (7% steps due to DP´s .scale restrictions)
	{
		zuffa = random();			//  je 7% um ca. 1.7 größer  (bei 24er Ausgangs bbox Mitte)
		if (zuffa <= 0.33)			//  1.07 ==> -25.7    1.14 ==> -27.4 
		{					//  1.07 ==> -25    1.14 ==> -27  
			self.scale = 1.14;
			setsize (self, '-16 -16 -24' - '0 0 3', '16 16 40' - '0 0 3');
		}
		else if (zuffa <= 0.66)
		{
			self.scale = 1.07;
			setsize (self, '-16 -16 -24' - '0 0 1', '16 16 40' - '0 0 1');
		}
		else
		{
			self.scale = 1;
			setsize (self, '-16 -16 -24', '16 16 40');
		}
	}
	else if (autocvar_enforcer_size == 2)		// if 'enforcer_size' is set via autoexec.cfg to '2' give monster random size between 100% and 121% (7% steps due to DP´s .scale restrictions)
	{
		zuffa = random();			//  je 7% um ca. 1.7 größer  (bei 24er Ausgangs bbox Mitte)
		if (zuffa <= 0.25)			//  1.07 ==> -25.7    1.14 ==> -27.4    1.21 ==> 29
		{					//  1.07 ==> -25    1.14 ==> -27    1.21 ==> 29
			self.scale = 1.21;
			setsize (self, '-16 -16 -24' - '0 0 5', '16 16 40' - '0 0 5');
		}
		else if (zuffa <= 0.5)
		{
			self.scale = 1.14;
			setsize (self, '-16 -16 -24' - '0 0 3', '16 16 40' - '0 0 3');
		}
		else if (zuffa <= 0.75)
		{
			self.scale = 1.07;
			setsize (self, '-16 -16 -24' - '0 0 1', '16 16 40' - '0 0 1');
		}
		else
		{
			self.scale = 1;
			setsize (self, '-16 -16 -24', '16 16 40');
		}
	}
	else if (autocvar_enforcer_size == 3)		// if 'enforcer_size' is set via autoexec.cfg to '3' give monster random size between 100% and 128% (7% steps due to DP´s .scale restrictions)
	{
		zuffa = random();			//  je 7% um ca. 1.7 größer  (bei 24er Ausgangs bbox Mitte)
		if (zuffa <= 0.2)			//  1.07 ==> -25.7    1.14 ==> -27.4    1.21 ==> 29   1.28 ==> 31
		{					//  1.07 ==> -25    1.14 ==> -27    1.21 ==> 29   1.28 ==> 31
			self.scale = 1.28;
			setsize (self, '-16 -16 -24' - '0 0 7', '16 16 40' - '0 0 7');
		}
		else if (zuffa <= 0.4)
		{
			self.scale = 1.21;
			setsize (self, '-16 -16 -24' - '0 0 5', '16 16 40' - '0 0 5');
		}
		else if (zuffa <= 0.6)
		{
			self.scale = 1.14;
			setsize (self, '-16 -16 -24' - '0 0 3', '16 16 40' - '0 0 3');
		}
		else if (zuffa <= 0.8)
		{
			self.scale = 1.07;
			setsize (self, '-16 -16 -24' - '0 0 1', '16 16 40' - '0 0 1');
		}
		else
		{
			self.scale = 1;
			setsize (self, '-16 -16 -24', '16 16 40');
		}
	}
	else if (autocvar_enforcer_size == 4)		// if 'enforcer_size' is set via autoexec.cfg to '4' give monster random size between 100% and 135% (7% steps due to DP´s .scale restrictions)
	{
		zuffa = random();			//  je 7% um ca. 1.7 größer  (bei 24er Ausgangs bbox Mitte)
		if (zuffa <= 0.17)			//  1.07 ==> -25.7    1.14 ==> -27.4    1.21 ==> 29.1   1.28 ==> 30.8   1.35 ==> 32.5
		{					//  1.07 ==> -25    1.14 ==> -27    1.21 ==> 29   1.28 ==> 31   1.35 ==> 33
			self.scale = 1.35;
			setsize (self, '-16 -16 -24' - '0 0 9', '16 16 40' - '0 0 9');
		}
		else if (zuffa <= 0.34)
		{
			self.scale = 1.28;
			setsize (self, '-16 -16 -24' - '0 0 7', '16 16 40' - '0 0 7');
		}
		else if (zuffa <= 0.5)
		{
			self.scale = 1.21;
			setsize (self, '-16 -16 -24' - '0 0 5', '16 16 40' - '0 0 5');
		}
		else if (zuffa <= 0.67)
		{
			self.scale = 1.14;
			setsize (self, '-16 -16 -24' - '0 0 3', '16 16 40' - '0 0 3');
		}
		else if (zuffa <= 0.84)
		{
			self.scale = 1.07;
			setsize (self, '-16 -16 -24' - '0 0 1', '16 16 40' - '0 0 1');
		}
		else
		{
			self.scale = 1;
			setsize (self, '-16 -16 -24', '16 16 40');
		}
	}
	else if (autocvar_enforcer_size > 4)		// if 'enforcer_size' is set via autoexec.cfg to a value bigger than '4' give monster the selected fixed size ==>  100% + [value]%  (7% steps due to DP´s .scale restrictions)
	{
		if (autocvar_enforcer_size > 40)
			self.origin = self.origin + '0 0 10';		// might get stuck in floor otherwise. --> drop him to floor from higher position !
		self.scale = 1 + (autocvar_enforcer_size * 0.01);
		self.sizefactor_x = 0;
		self.sizefactor_y = 0;
		self.sizefactor_z = autocvar_enforcer_size * 0.25;
		setsize (self, '-16 -16 -24' - self.sizefactor, '16 16 40' - self.sizefactor);
	}
	else
	{
		self.scale = 1;
		setsize (self, '-16 -16 -24', '16 16 40');
	}

var float autocvar_enforcer_size_influenced_health = 0; 		  		// set cvar 'enforcer_size_influenced_health' default to 0
	if (autocvar_enforcer_size_influenced_health == 1)				// if 'enforcer_size_influenced_health' is set via autoexec.cfg to '1' raise monster´s health according to its size  (use different formular for monsters with default health <100 and health >100 to be realistic/noticable)
		self.health = autocvar_enforcer_health + ((self.scale - 1) * 100);	// default: 80
	else
		self.health = autocvar_enforcer_health;					// default 80
	self.health_initial = self.health;

	if (autocvar_monster_random_skin_color_alteration && autocvar_enforcer_random_skin_colors)	// modify/edit this monster types skin textures randomly (for higher variation in-game)
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

	self.th_stand = enf_stand1;
	self.th_walk = enf_walk1;
	self.th_run = enf_run1;
	self.th_pain = enf_pain;
	self.th_die = enf_die;
	self.th_missile = enf_atk1;

	self.alpha = autocvar_monstertransparency * 0.01;

	if (autocvar_spider_replace_enforcer)		// if enforcer shall be replaced by spider. Check the chance and do it !!)
		{	
		local float replacer;		
		replacer = autocvar_spider_replace_enforcer * 0.01;
		if (random () <= replacer)
			{
			self.skin = 1;
			self.health = autocvar_enforcer_health;		// default 80
			self.scale = 1;
			setsize (self, '-16 -16 -24', '16 16 40');
			self.nextthink = time + 0.3;	
			self.think = SUB_Remove;
			monster_spider_start();
			return;
			}
		}
		
	if (autocvar_afrit_replace_enforcer)		// if enforcer shall be replaced by afrit. Check the chance and do it !!)
		{	
		local float replac;		
		replac = autocvar_afrit_replace_enforcer * 0.01;
		if (random () <= replac)
			{
			self.health = autocvar_enforcer_health;		// default 80
			self.scale = 1;
			setsize (self, '-16 -16 -24', '16 16 40');
			self.nextthink = time + 0.3;	
			self.think = SUB_Remove;
			monster_afrit_liftorigin_start();
			return;
			}
		}

	walkmonster_start();

do_the_cloning();

if (autocvar_afrit_supports_enforcer)		// if afrit shall be spawned in ADDITION to an existing enforcer. Check the chance and do it !!)
	{	
	local float replace;		
	replace = autocvar_afrit_supports_enforcer * 0.01;
	if (random () <= replace)
		add_afrit_support_walk ();
	}

var float autocvar_enforcermass = 2100;
MonsterPhysics (self, autocvar_enforcermass);
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
void(string modelname, float modelframe) vengeance_enforcer; 

==============================================================================
*/


void() vengeance_enforcer_end1 = {					// end sequence
	self.alpha = -1;
	te_customflash (self.origin, 500, 0.7, '1 0 0');
	self.nextthink = time + 0.2;
      self.think = SUB_Remove;
};


void() vengeance_enforcer_shoot = {		// player receives 1 damage when vengeance effect shoots (no chance to avoid)

      local float shootdmg;

	var float autocvar_vengeancedamage = 0;   // set cvar 'vengeancedamage' default to 0
	if (autocvar_vengeancedamage == 0)	  	// if 'vengeancedamage' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '0'
		{						// no damage
		}
	else   	 					// if value is NOT "0" (example: "1"), player receives 1 damage 
		{
		shootdmg = 1;   		
            T_Damage (self.enemy, self, self, shootdmg);   	// analog to meele attack dog/fiend
//          T_Damage (other, self, self, shootdmg); 		// analog to jump damage dog/fiend
		}

	self.touch = SUB_Null;   	// um nicht endlos damage zu kriegen !
};


void() vengeance_enforcer_touch = {		// player receives 1-3 damage when he gets touched by vengeance effect

      local float ldmg;
	ldmg = rint(0.5 + (3 * random()));  	// chances=  33%: 1 damage /  33%: 2 damage  /  33%: 3 damage

            T_Damage (self.enemy, self, self, ldmg);      	// analog to meele attack dog/fiend
//          T_Damage (other, self, self, ldmg); 		// analog to jump damage dog/fiend

	self.touch = SUB_Null;   			// um nicht endlos damage zu kriegen !

		self.think = vengeance_enforcer_end1; 
		self.nextthink = time + 0.1;   
};
										//  from here on: run sequence. 

void() vengeance_enforcer_run1 =[	$run1,	vengeance_enforcer_run2 ]   {
	ai_face();
 	movetogoal (23);	  // orig (18)
self.touch = vengeance_enforcer_touch;
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_enforcer_run2 =[	$run3,	vengeance_enforcer_run3 ]   {
	ai_face();
 	movetogoal (12);   // orig (7)
self.touch = vengeance_enforcer_touch;
	self.alpha = 0.36;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_enforcer_run3 =[	$run4,	vengeance_enforcer_run4 ]    {
	ai_face();
 	movetogoal (17);   // orig (12)
self.touch = vengeance_enforcer_touch;
	self.alpha = 0.32;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_enforcer_run4 =[	$run5,	vengeance_enforcer_run5 ]    {
	ai_face();
 	movetogoal (19);   // orig (14)
self.touch = vengeance_enforcer_touch;
	self.alpha = 0.29;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_enforcer_run5 =[	$run6,	vengeance_enforcer_run6 ]    {
	ai_face();
 	movetogoal (19);   // orig (14)
self.touch = vengeance_enforcer_touch;
	self.alpha = 0.26;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_enforcer_run6 =[	$run7,	vengeance_enforcer_run7 ]    {
	ai_face();
 	movetogoal (12);   // orig (7)
self.touch = vengeance_enforcer_touch;
	self.alpha = 0.23;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_enforcer_run7 =[	$run8,	vengeance_enforcer_shoot1 ]    {
	ai_face();
 	movetogoal (16);   // orig (11)
self.touch = vengeance_enforcer_touch;
	self.alpha = 0.2;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};

										//  from here on: attack/jump sequenz. 

void() vengeance_enforcer_shoot1 =[ $attack1,	vengeance_enforcer_shoot2 ]    {
	ai_face();
self.touch = vengeance_enforcer_touch;
	self.alpha = 0.18;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_enforcer_shoot2 =[ $attack2,	vengeance_enforcer_shoot3 ]    {
	ai_face();
self.touch = vengeance_enforcer_touch;
	self.alpha = 0.16;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_enforcer_shoot3 =[ $attack3,	vengeance_enforcer_shoot4 ]    {
	ai_face();
self.touch = vengeance_enforcer_touch;
	self.alpha = 0.14;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_enforcer_shoot4 =[ $attack4,	vengeance_enforcer_shoot5 ]    {
	ai_face();
self.touch = vengeance_enforcer_touch;
	self.alpha = 0.12;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_enforcer_shoot5 =[ $attack5,	vengeance_enforcer_shoot6 ]    {
	ai_face();
self.touch = vengeance_enforcer_touch;
	self.alpha = 0.09;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_enforcer_shoot6 =[ $attack6,	vengeance_enforcer_end1 ]    {
	ai_face();
self.touch = vengeance_enforcer_touch;
	self.alpha = 0.06;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
sound (self, CHAN_WEAPON, "enforcer/enfire.wav", 1, ATTN_NORM);
vengeance_enforcer_shoot ();
};



										//  from here on: ressurection sequence 1. 

void() vengeance_enforcer11 =[	$death13,	vengeance_enforcer12 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_enforcer12 =[	$death12,	vengeance_enforcer13 	]  {
// 	movetogoal (5); 			 	 //  TEST !!!
	walkmove ( (self.angles_y+180), 5);  //  TEST !!!
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_enforcer13 =[	$death11,	vengeance_enforcer14 	]  {
// 	movetogoal (5); 			 	 //  TEST !!!
	walkmove ( (self.angles_y+180), 5);  //  TEST !!!
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_enforcer14 =[	$death10,	vengeance_enforcer15 	]  {
// 	movetogoal (5); 			 	 //  TEST !!!
	walkmove ( (self.angles_y+180), 5);  //  TEST !!!
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_enforcer15 =[	$death9,	vengeance_enforcer16 	]  {
// 	movetogoal (3); 			 	 //  TEST !!!
	walkmove ( (self.angles_y+180), 3);  //  TEST !!!
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_enforcer16 =[	$death8,	vengeance_enforcer17 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_enforcer17 =[	$death7,	vengeance_enforcer18 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_enforcer18 =[	$death6,	vengeance_enforcer19 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_enforcer19 =[	$death5,	vengeance_enforcer110 	]  {
// 	movetogoal (2); 			 	 //  TEST !!!
	walkmove ( (self.angles_y+180), 2);  //  TEST !!!
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_enforcer110 =[	$death4,	vengeance_enforcer111 	]  {
// 	movetogoal (14); 			 	  //  TEST !!!
	walkmove ( (self.angles_y+180), 14);  //  TEST !!!
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_enforcer111 =[	$death3,	vengeance_enforcer112 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_enforcer112 =[	$death2,	vengeance_enforcer113 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_enforcer113 =[	$death1,	vengeance_enforcer_stand1 ]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_enforcer_stand1 =[ $stand1,	vengeance_enforcer_run1 ]  {    // needed to make the animation fluent
local float zufall;	      								  // $attacka1 fills the frame gap
	zufall = random();
	if (zufall <= 0.25)
		sound (self, CHAN_VOICE, "enforcer/sight1.wav", 1, 4);
	else if (zufall > 0.25 && zufall <= 0.5)
		sound (self, CHAN_VOICE, "enforcer/sight2.wav", 1, 4);
	else if (zufall > 0.5 && zufall <= 0.75)
		sound (self, CHAN_VOICE, "enforcer/sight3.wav", 1, 4);
	else 
		sound (self, CHAN_VOICE, "enforcer/sight4.wav", 1, 4);	
	
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};


									//  from here on: ressurection sequence 2.

void() vengeance_enforcer21 =[	$fdeath10,	vengeance_enforcer22 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_enforcer22 =[	$fdeath9,	vengeance_enforcer23 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_enforcer23 =[	$fdeath8,	vengeance_enforcer24 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_enforcer24 =[	$fdeath7,	vengeance_enforcer25 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_enforcer25 =[	$fdeath6,	vengeance_enforcer26 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_enforcer26 =[	$fdeath5,	vengeance_enforcer27 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_enforcer27 =[	$fdeath4,	vengeance_enforcer28 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_enforcer28 =[	$fdeath3,	vengeance_enforcer29 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_enforcer29 =[	$fdeath2,	vengeance_enforcer210	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_enforcer210 =[ 	$fdeath1,	vengeance_enforcer_stand2 ]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_enforcer_stand2 =[	$stand1,	vengeance_enforcer_run1 ]  {    // needed to make the animation fluent
local float zufall;	      								  // $attacka1 fills the frame gap
	zufall = random();
	if (zufall <= 0.25)
		sound (self, CHAN_VOICE, "enforcer/sight1.wav", 1, 4);
	else if (zufall > 0.25 && zufall <= 0.5)
		sound (self, CHAN_VOICE, "enforcer/sight2.wav", 1, 4);
	else if (zufall > 0.5 && zufall <= 0.75)
		sound (self, CHAN_VOICE, "enforcer/sight3.wav", 1, 4);
	else 
		sound (self, CHAN_VOICE, "enforcer/sight4.wav", 1, 4);	
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};



								// from here on:  sequence where the corpse overbrights 
void()	vengeance_enforcer_bright05 	= {
	self.alpha = 0.3;
	self.colormod = '6 1 1';
	self.glow_color = 75;
	self.glow_size = 450;
	self.nextthink = time + 0.1;
		if (self.frame == $death14)
			self.think = vengeance_enforcer11;
		else
			self.think = vengeance_enforcer21;
};
void()	vengeance_enforcer_bright04 	= {
	self.alpha = 0.3;
	self.colormod = '5 1 1';
	self.glow_color = 75;
	self.glow_size = 350;
	self.nextthink = time + 0.1;
	self.think = vengeance_enforcer_bright05;
};
void()	vengeance_enforcer_bright03 	= {
	self.alpha = 0.3;
	self.colormod = '4 1 1';
	self.glow_color = 75;
	self.glow_size = 270;
	self.nextthink = time + 0.1;
	self.think = vengeance_enforcer_bright04;
};
void()	vengeance_enforcer_bright02 	= {
	self.alpha = 0.3;
	self.colormod = '3 1 1';
	self.glow_color = 75;
	self.glow_size = 185;
	self.nextthink = time + 0.1;
	self.think = vengeance_enforcer_bright03;
}; 
void()	vengeance_enforcer_bright01 	= {
	self.alpha = 0.3;
	self.colormod = '2 1 1';
	self.glow_color = 75;
	self.glow_size = 100;
	self.nextthink = time + 0.1;
	self.think = vengeance_enforcer_bright02;
};
void()	vengeance_enforcer_bright00 	= {  			// delay for 0.3 seconds before overbright process really begins
	self.alpha = 0.3;
	self.glow_color = 75;
	self.glow_size = 10;
	self.nextthink = time + 0.3;
	self.think = vengeance_enforcer_bright01;
};



void(string modelname, float modelframe) vengeance_enforcer =
{

local vector v;  			// v  was necessary at the begining of effect development, but isnt anymore now.
v_x = (self.origin_x);
v_y = (self.origin_y);
v_z = (self.origin_z);

      self.origin = v; 
   	self.touch = SUB_Null;                
	self.movetype = MOVETYPE_FLY;
	
	if (self.monstermodel == 0)  
		setmodel (self, "progs/enforcer.mdl"); 
	else if (self.monstermodel == 1)  
		setmodel (self, "progs/enforcer1.mdl"); 

	setsize (self, '-16 -16 -24', '16 16 40');
	self.frame = modelframe;	 // modelframe is depending on the individual monster (included in vengeance call)

	var float autocvar_vengeancedamage = 0;   // set cvar 'vengeancedamage' default to 0
	if (autocvar_vengeancedamage == 0)	  	// if 'vengeancedamage' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '0'
		self.solid = SOLID_NOT;			// vengeance effect is NOT solid and cannot hurt the player
	else
		self.solid = SOLID_SLIDEBOX;    	  // if value is NOT "0", player get hurt from this effect (see func "vengeance_enforcer_touch")!

	vengeance_enforcer_bright00 ();			 // starts the animation
};

