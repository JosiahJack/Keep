/*
==============================================================================

DEMON

==============================================================================
*/

$cd id1/models/demon3
$scale	0.8
$origin 0 0 24
$base base
$skin base

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9
$frame stand10 stand11 stand12 stand13

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8

$frame run1 run2 run3 run4 run5 run6

$frame leap1 leap2 leap3 leap4 leap5 leap6 leap7 leap8 leap9 leap10
$frame leap11 leap12

$frame pain1 pain2 pain3 pain4 pain5 pain6

$frame death1 death2 death3 death4 death5 death6 death7 death8 death9

$frame attacka1 attacka2 attacka3 attacka4 attacka5 attacka6 attacka7 attacka8
$frame attacka9 attacka10 attacka11 attacka12 attacka13 attacka14 attacka15

//============================================================================

void()	Demon_JumpTouch;


void(float loudness) demon_footsteps =
{
if (autocvar_monsterfootsteps == 1)	// only play monster footsteps sound when cvar is 1
	{
	local float select;
	select = random();
	if (select <= 0.2)
		sound(self, CHAN_AUTO, "walk/demon1.wav", loudness, ATTN_IDLE);
	else if (select <= 0.4)
		sound(self, CHAN_AUTO, "walk/demon2.wav", loudness, ATTN_IDLE);
	else if (select <= 0.6)
		sound(self, CHAN_AUTO, "walk/demon3.wav", loudness, ATTN_IDLE);
	else if (select <= 0.8)
		sound(self, CHAN_AUTO, "walk/demon4.wav", loudness, ATTN_IDLE);
	else
		sound(self, CHAN_AUTO, "walk/demon5.wav", loudness, ATTN_IDLE);
	}
};


var float autocvar_demonteleport = 15;     	// set cvar 'demonteleport' default to 15

void(vector org) spawn_demon_fog =		// spawns particle effect
{
	s = spawn ();
	s.origin = org;
	s.nextthink = time + 0.2;
	s.think = play_teleport;
	pointparticles(particleeffectnum("demon_fog"), org, '0 0 0', 1); 
};


float(entity beacon, float attack) PM_DemTeleport =		//  Teleport the demon to some location near its target.
{
local vector spot, vec;

// Select teleport destination within a 225 radius.
	spot_x = beacon.origin_x + (random() * 450 - 225);
	spot_y = beacon.origin_y + (random() * 450 - 225);
	spot_z = beacon.origin_z + (random() * 3);
	vec = normalize(spot - beacon.origin);
	traceline (beacon.origin, spot, TRUE, beacon);
	spot = trace_endpos - vec*50;

// Teleport only if the distance is great enough.
	if (vlen(spot - self.origin) < 64)  return FALSE;

// Check for walls and obstacles.
	if (PM_InWall(self, spot))  return FALSE;
	if (!PM_TraceCheck(self, spot))  return FALSE;

// If attacking, check if target is not blocked.
	if (attack)
	{	
		traceline (spot, self.enemy.origin, FALSE, self);
		if (trace_fraction < 1.0)
			if (trace_ent != self.enemy)
				return FALSE;
	}

// Teleport and face opponent!
	setorigin(self, spot);
	self.angles_y = vectoyaw(self.enemy.origin - spot);
	self.fixangle = TRUE;
	return TRUE;
};


void(entity beacon, float attack) PM_DemBlink =		// If the demon teleports, make some fog.
{
local vector org;	// Scrag's original location.
	org = self.origin;
	if (PM_DemTeleport(beacon, attack))
	{
		spawn_demon_fog(org);
		spawn_demon_fog(self.origin);
	}
};


//  Make multiple teleport attempts so that the demon has a
//  big chance to teleport.  If successful, fog is spawned.
void() PM_DemMultiBlink =
{
	local vector org;		// demon's original location.
	local   float   success;	// # of successful teleport attempts.
	org = self.origin;
	success = FALSE;
	success = success + PM_DemTeleport(self, FALSE);
//	success = success + PM_DemTeleport(self, FALSE);
//	success = success + PM_DemTeleport(self, FALSE);

	if (success)
	{	
		spawn_demon_fog(org);
		spawn_demon_fog(self.origin);
	}
};



void()	demon1_stand1	=[	$stand1,	demon1_stand2	] {ai_stand();
if ( self.demon_on_fire == 1 )
	pointparticles(particleeffectnum("demon_stand"), self.origin, '0 0 0', 1); 
};
void()	demon1_stand2	=[	$stand2,	demon1_stand3	] {ai_stand();
if ( self.demon_on_fire == 1 )
	pointparticles(particleeffectnum("demon_stand"), self.origin, '0 0 0', 1); 
};
void()	demon1_stand3	=[	$stand3,	demon1_stand4	] {ai_stand();
if ( self.demon_on_fire == 1 )
	pointparticles(particleeffectnum("demon_stand"), self.origin, '0 0 0', 1); 
};
void()	demon1_stand4	=[	$stand4,	demon1_stand5	] {ai_stand();
if ( self.demon_on_fire == 1 )
	pointparticles(particleeffectnum("demon_stand"), self.origin, '0 0 0', 1); 
};
void()	demon1_stand5	=[	$stand5,	demon1_stand6	] {ai_stand();
if ( self.demon_on_fire == 1 )
	pointparticles(particleeffectnum("demon_stand"), self.origin, '0 0 0', 1); 
};
void()	demon1_stand6	=[	$stand6,	demon1_stand7	] {ai_stand();
if ( self.demon_on_fire == 1 )
	pointparticles(particleeffectnum("demon_stand"), self.origin, '0 0 0', 1); 
};
void()	demon1_stand7	=[	$stand7,	demon1_stand8	] {ai_stand();
if ( self.demon_on_fire == 1 )
	pointparticles(particleeffectnum("demon_stand"), self.origin, '0 0 0', 1); 
};
void()	demon1_stand8	=[	$stand8,	demon1_stand9	] {ai_stand();
if ( self.demon_on_fire == 1 )
	pointparticles(particleeffectnum("demon_stand"), self.origin, '0 0 0', 1); 
};
void()	demon1_stand9	=[	$stand9,	demon1_stand10	] {ai_stand();
if ( self.demon_on_fire == 1 )
	pointparticles(particleeffectnum("demon_stand"), self.origin, '0 0 0', 1); 
};
void()	demon1_stand10	=[	$stand10,	demon1_stand11	] {ai_stand();
if ( self.demon_on_fire == 1 )
	pointparticles(particleeffectnum("demon_stand"), self.origin, '0 0 0', 1); 
};
void()	demon1_stand11	=[	$stand11,	demon1_stand12	] {ai_stand();
if ( self.demon_on_fire == 1 )
	pointparticles(particleeffectnum("demon_stand"), self.origin, '0 0 0', 1); 
};
void()	demon1_stand12	=[	$stand12,	demon1_stand13	] {ai_stand();
if ( self.demon_on_fire == 1 )
	pointparticles(particleeffectnum("demon_stand"), self.origin, '0 0 0', 1); 
};
void()	demon1_stand13	=[	$stand13,	demon1_stand1	] {ai_stand();
if ( self.demon_on_fire == 1 )
	pointparticles(particleeffectnum("demon_stand"), self.origin, '0 0 0', 1); 
};


void()	demon1_walk1	=[	$walk1,		demon1_walk2	] {
if (random() < 0.2)
    sound (self, CHAN_VOICE, "demon/idle1.wav", 1, ATTN_IDLE);
ai_walk(8);
demon_footsteps (0.7);
if ( self.demon_on_fire == 1 )
	pointparticles(particleeffectnum("demon_walk"), self.origin, '0 0 0', 1); 
};
void()	demon1_walk2	=[	$walk2,		demon1_walk3	] {ai_walk(6);
if ( self.demon_on_fire == 1 )
	pointparticles(particleeffectnum("demon_walk"), self.origin, '0 0 0', 1); 
};
void()	demon1_walk3	=[	$walk3,		demon1_walk4	] {ai_walk(6);
if ( self.demon_on_fire == 1 )
	pointparticles(particleeffectnum("demon_walk"), self.origin, '0 0 0', 1); 
};
void()	demon1_walk4	=[	$walk4,		demon1_walk5	] {ai_walk(7);
if ( self.demon_on_fire == 1 )
	pointparticles(particleeffectnum("demon_walk"), self.origin, '0 0 0', 1); 
};
void()	demon1_walk5	=[	$walk5,		demon1_walk6	] {ai_walk(4);
if ( self.demon_on_fire == 1 )
	pointparticles(particleeffectnum("demon_walk"), self.origin, '0 0 0', 1); 
demon_footsteps (0.7);
};
void()	demon1_walk6	=[	$walk6,		demon1_walk7	] {ai_walk(6);
if ( self.demon_on_fire == 1 )
	pointparticles(particleeffectnum("demon_walk"), self.origin, '0 0 0', 1); 
};
void()	demon1_walk7	=[	$walk7,		demon1_walk8	] {ai_walk(10);
if ( self.demon_on_fire == 1 )
	pointparticles(particleeffectnum("demon_walk"), self.origin, '0 0 0', 1); 
};
void()	demon1_walk8	=[	$walk8,		demon1_walk1	] {ai_walk(10);
if ( self.demon_on_fire == 1 )
	pointparticles(particleeffectnum("demon_walk"), self.origin, '0 0 0', 1); 
};


void()	demon1_run1	=[	$run1,		demon1_run2	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);
if (random() < 0.2)
    sound (self, CHAN_VOICE, "demon/idle1.wav", 1, ATTN_IDLE);
ai_run(20);
if ( self.demon_on_fire == 1 )
	pointparticles(particleeffectnum("demon_walk"), self.origin, '0 0 0', 1); 
if (autocvar_demonteleport)		// demons can teleport
	{
	if (random() < (skill * 0.04))	// There is a small chance that the demon will teleport to find its target.
		PM_DemBlink(self.enemy, FALSE);	
	}
};
void()	demon1_run2	=[	$run2,		demon1_run3	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(15);
if ( self.demon_on_fire == 1 )
	pointparticles(particleeffectnum("demon_walk"), self.origin, '0 0 0', 1); 
demon_footsteps (0.85);
};
void()	demon1_run3	=[	$run3,		demon1_run4	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(36);
if ( self.demon_on_fire == 1 )
	pointparticles(particleeffectnum("demon_walk"), self.origin, '0 0 0', 1); 
};
void()	demon1_run4	=[	$run4,		demon1_run5	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(20);
if ( self.demon_on_fire == 1 )
	pointparticles(particleeffectnum("demon_walk"), self.origin, '0 0 0', 1); 
};
void()	demon1_run5	=[	$run5,		demon1_run6	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(15);
if ( self.demon_on_fire == 1 )
	pointparticles(particleeffectnum("demon_walk"), self.origin, '0 0 0', 1); 
demon_footsteps (0.85);
};
void()	demon1_run6	=[	$run6,		demon1_run1	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(36);
if ( self.demon_on_fire == 1 )
	pointparticles(particleeffectnum("demon_walk"), self.origin, '0 0 0', 1); 
};


void()	demon1_jump1	=[	$leap1,		demon1_jump2	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();
if ( self.demon_on_fire == 1 )
	pointparticles(particleeffectnum("demon_stand"), self.origin, '0 0 0', 1);
if (autocvar_demonteleport)		// demons can teleport
	{
	local float zufall;		
	zufall = autocvar_demonteleport * 0.01;
	if (random () <= zufall)
		PM_DemBlink(self, TRUE);	// attack from new position
	}
};
void()	demon1_jump2	=[	$leap2,		demon1_jump3	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();
if ( self.demon_on_fire == 1 )
	pointparticles(particleeffectnum("demon_stand"), self.origin, '0 0 0', 1); 
};
void()	demon1_jump3	=[	$leap3,		demon1_jump4	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();
if ( self.demon_on_fire == 1 )
	pointparticles(particleeffectnum("demon_stand"), self.origin, '0 0 0', 1); 
};
void()	demon1_jump4	=[	$leap4,		demon1_jump5	]
{
	self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001); ai_face();
	
	self.touch = Demon_JumpTouch;
	makevectors (self.angles);
	self.origin_z = self.origin_z + 1;
	self.velocity = v_forward * 600 + '0 0 250';
	if (self.flags & FL_ONGROUND)
		self.flags = self.flags - FL_ONGROUND;
};
void()	demon1_jump5	=[	$leap5,		demon1_jump6	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);};
void()	demon1_jump6	=[	$leap6,		demon1_jump7	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);};
void()	demon1_jump7	=[	$leap7,		demon1_jump8	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);};
void()	demon1_jump8	=[ 	$leap8,		demon1_jump9	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);};
void()	demon1_jump9	=[ 	$leap9,		demon1_jump10	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);};
void()	demon1_jump10	=[ 	$leap10,	demon1_jump1	] {
self.nextthink = time + 1;
// if one second pass, assume demon is stuck and jump again
};

void()	demon1_jump11	=[ 	$leap11,	demon1_jump12	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);};
void()	demon1_jump12	=[ 	$leap12,	demon1_run1	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);};


void()	demon1_atta1	=[	$attacka1,		demon1_atta2	] {ai_charge(4);
if ( self.demon_on_fire == 1 )
	pointparticles(particleeffectnum("demon_stand"), self.origin, '0 0 0', 1); 
};
void()	demon1_atta2	=[	$attacka2,		demon1_atta3	] {ai_charge(0);
if ( self.demon_on_fire == 1 )
	pointparticles(particleeffectnum("demon_stand"), self.origin, '0 0 0', 1); 
};
void()	demon1_atta3	=[	$attacka3,		demon1_atta4	] {ai_charge(0);
if ( self.demon_on_fire == 1 )
	pointparticles(particleeffectnum("demon_stand"), self.origin, '0 0 0', 1); 
};
void()	demon1_atta4	=[	$attacka4,		demon1_atta5	] {ai_charge(1);
if ( self.demon_on_fire == 1 )
	pointparticles(particleeffectnum("demon_stand"), self.origin, '0 0 0', 1); 
};
void()	demon1_atta5	=[	$attacka5,		demon1_atta6	] {ai_charge(2); Demon_Melee(200);
if ( self.demon_on_fire == 1 )
	pointparticles(particleeffectnum("demon_stand"), self.origin, '0 0 0', 1); 
};
void()	demon1_atta6	=[	$attacka6,		demon1_atta7	] {ai_charge(1);
if ( self.demon_on_fire == 1 )
	pointparticles(particleeffectnum("demon_stand"), self.origin, '0 0 0', 1); 
};
void()	demon1_atta7	=[	$attacka7,		demon1_atta8	] {ai_charge(6);
if ( self.demon_on_fire == 1 )
	pointparticles(particleeffectnum("demon_stand"), self.origin, '0 0 0', 1); 
};
void()	demon1_atta8	=[	$attacka8,		demon1_atta9	] {ai_charge(8);
if ( self.demon_on_fire == 1 )
	pointparticles(particleeffectnum("demon_stand"), self.origin, '0 0 0', 1); 
};
void()	demon1_atta9	=[	$attacka9,		demon1_atta10] {ai_charge(4);
if ( self.demon_on_fire == 1 )
	pointparticles(particleeffectnum("demon_stand"), self.origin, '0 0 0', 1); 
};
void()	demon1_atta10	=[	$attacka10,		demon1_atta11] {ai_charge(2);
if ( self.demon_on_fire == 1 )
	pointparticles(particleeffectnum("demon_stand"), self.origin, '0 0 0', 1); 
};
void()	demon1_atta11	=[	$attacka11,		demon1_atta12] {Demon_Melee(-200);
if ( self.demon_on_fire == 1 )
	pointparticles(particleeffectnum("demon_stand"), self.origin, '0 0 0', 1); 
demon_footsteps (0.85);
};
void()	demon1_atta12	=[	$attacka12,		demon1_atta13] {ai_charge(5);
if ( self.demon_on_fire == 1 )
	pointparticles(particleeffectnum("demon_stand"), self.origin, '0 0 0', 1); 
};
void()	demon1_atta13	=[	$attacka13,		demon1_atta14] {ai_charge(8);
if ( self.demon_on_fire == 1 )
	pointparticles(particleeffectnum("demon_stand"), self.origin, '0 0 0', 1); 
};
void()	demon1_atta14	=[	$attacka14,		demon1_atta15] {ai_charge(4);
if ( self.demon_on_fire == 1 )
	pointparticles(particleeffectnum("demon_stand"), self.origin, '0 0 0', 1); 
};
void()	demon1_atta15	=[	$attacka15,		demon1_run1] {ai_charge(4);
if ( self.demon_on_fire == 1 )
	pointparticles(particleeffectnum("demon_stand"), self.origin, '0 0 0', 1); 
};

void()	demon1_pain1	=[	$pain1,		demon1_pain2	] {
if ( self.demon_on_fire == 1 )
	pointparticles(particleeffectnum("demon_stand"), self.origin, '0 0 0', 1); 
};
void()	demon1_pain2	=[	$pain2,		demon1_pain3	] {
if ( self.demon_on_fire == 1 )
	pointparticles(particleeffectnum("demon_stand"), self.origin, '0 0 0', 1); 
};
void()	demon1_pain3	=[	$pain3,		demon1_pain4	] {
if ( self.demon_on_fire == 1 )
	pointparticles(particleeffectnum("demon_stand"), self.origin, '0 0 0', 1); 
};
void()	demon1_pain4	=[	$pain4,		demon1_pain5	] {
if ( self.demon_on_fire == 1 )
	pointparticles(particleeffectnum("demon_stand"), self.origin, '0 0 0', 1); 
};
void()	demon1_pain5	=[	$pain5,		demon1_pain6	] {
if ( self.demon_on_fire == 1 )
	pointparticles(particleeffectnum("demon_stand"), self.origin, '0 0 0', 1); 
};
void()	demon1_pain6	=[	$pain6,		demon1_run1	] {
if ( self.demon_on_fire == 1 )
	pointparticles(particleeffectnum("demon_stand"), self.origin, '0 0 0', 1); 
};

void(entity attacker, float damage)	demon1_pain =
{
	if (self.touch == Demon_JumpTouch)
		return;
	if (autocvar_demonteleport)		// demons can teleport
		{
		local float zufall;		
		zufall = autocvar_demonteleport * 0.01;
		if (random () <= zufall)
			PM_DemMultiBlink();	// Teleport away from danger.
		}

	if (self.pain_finished > time)
		return;

	self.pain_finished = time + 1;
    sound (self, CHAN_VOICE, "demon/dpain1.wav", 1, ATTN_NORM);

	if (random()*200 > damage)
		return;		// didn't flinch
		
	if (autocvar_slowmotion >= 4)	// start slowmotion when hurting enemies
	{
		if (random () <= (autocvar_slowmotion_randomness_demon * 0.01))
			{
			the_matrix = 1;
			matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
			}
	}

	demon1_pain1 ();
};



void() demon_dieburn1	=[	$death1,	demon_dieburn2	] {self.burnz_origin = 12;
burn_toggle_allround();
};
void() demon_dieburn2	=[	$death2,	demon_dieburn3	] {self.burnz_origin = 11;
};
void() demon_dieburn3	=[	$death3,	demon_dieburn4	] {self.burnz_origin = 6;
self.solid = SOLID_NOT;
};
void() demon_dieburn4	=[	$death4,	demon_dieburn5	] {self.burnz_origin = 3;
};
void() demon_dieburn5	=[	$death5,	demon_dieburn6	] {self.burnz_origin = 0;
};
void() demon_dieburn6	=[	$death6,	demon_dieburn7	] {self.burnz_origin = -2;
};
void() demon_dieburn7	=[	$death7,	demon_dieburn8	] {self.burnz_origin = -4;
};
void() demon_dieburn8	=[	$death8,	demon_dieburn9	] {self.burnz_origin = -6;
};
void() demon_dieburn9	=[	$death9,	demon_dieburn9	] {self.burnz_origin = -8;
};


var float autocvar_demon = 3;     		// set cvar 'demon' default to 3
var float autocvar_demoncorpsehealth = 60;	// set cvar 'demoncorpsehealth' default to 60
var float autocvar_demoncorpseburnable = 1;	// set cvar 'demoncorpseburnable' default to 1

void()	demon1_die1		=[	$death1,		demon1_die2	] {
sound (self, CHAN_VOICE, "demon/ddeath.wav", 1, ATTN_NORM);};
void()	demon1_die2		=[	$death2,		demon1_die3	] {};
void()	demon1_die3		=[	$death3,		demon1_die4	] {};
void()	demon1_die4		=[	$death4,		demon1_die5	] {};
void()	demon1_die5		=[	$death5,		demon1_die6	] {};
void()	demon1_die6		=[	$death6,		demon1_die7	]
{self.solid = SOLID_NOT;};
void()	demon1_die7		=[	$death7,		demon1_die8	] {sound (self, CHAN_AUTO, "demon/fall_backwards.wav", 1, ATTN_IDLE);};
void()	demon1_die8		=[	$death8,		demon1_die9	] {};
void()	demon1_die9		=[	$death9,		demon1_die9 ] {
local float zufall, zet, randomness;
	zet = 27;					// z-position of the wings (in relation to soul). Dependent on corpse size.
	if (autocvar_demoncorpseburnable == 1)		// corpses are burnable
		self.burnable_corpse = 1;
// 	auto_cvar 'demoncorpsehealth' has been set to  default = 60  in code above already
	if (self.monstermodel == 0)  
		CopyMonsterToBodyQue(autocvar_demoncorpsehealth, "progs/h_demon.mdl");
	if (self.monstermodel == 1)  
		CopyMonsterToBodyQue(autocvar_demoncorpsehealth, "progs/h_demon1.mdl");
if (self.nodeathanim == 1)
	return;
if (self.grimrock_helper == 0)
{
// 	auto_cvar 'demon' has been declared in code above already
	var float autocvar_demonrandomness = 25;     	// set cvar 'demonrandomness' default to 25%
	autocvar_demonrandomness = autocvar_demonrandomness * 0.01;
	if (autocvar_demon == 1)		// if 'demon' is set via autoexec.cfg to '1' start ghost effect
		{
		randomness = random();
		if (randomness <= autocvar_demonrandomness)	// checks if death animation shall be started
			ghost_die (); 
		}
	else if (autocvar_demon == 2)		// if 'demon' is set via autoexec.cfg to '2' start soul effect
		{
		randomness = random();
		if (randomness <= autocvar_demonrandomness)	// checks if death animation shall be started
			{
			if (self.monstermodel == 0)  
				soul ("progs/demon.mdl", $death9, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
			else if (self.monstermodel == 1)  
				soul ("progs/demon1.mdl", $death9, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
			}
		}
	else if (autocvar_demon == 3)		// if 'demon' is set via autoexec.cfg to '3' start vengeance effect
		{
		randomness = random();
		if (randomness <= autocvar_demonrandomness)	// checks if death animation shall be started
			vengeance_demon ("progs/demon.mdl", $death9);
		}
	else if (autocvar_demon == 5)		// if 'demon' is set via autoexec.cfg to '5' start randomly one of these Death animations: 
		{				// (Ancient ghosts of the fallen ; Relieved souls of the enslaved ; Vengeance of the deceased)		
		randomness = random();		// chance for effects (approx.): 36% / 26% / 38%  
		if (randomness <= autocvar_demonrandomness)	// checks if death animation shall be started --> depending on monsters _randomness
			{		
			zufall = random();
			if (zufall > 0.64)
				ghost_die ();
			else if (zufall < 0.26)
				{
				if (self.monstermodel == 0)  
					soul ("progs/demon.mdl", $death9, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
				else if (self.monstermodel == 1)  
					soul ("progs/demon1.mdl", $death9, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
				}
			else
				vengeance_demon ("progs/demon.mdl", $death9);
			}
		}
	else				// if 'demon' is set via autoexec.cfg to another value (example '0'), do nothing !
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
			soul ("progs/demon.mdl", $death9, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
		else if (self.monstermodel == 1)  
			soul ("progs/demon1.mdl", $death9, zet);  // z-position of the wings (in relation to soul). Dependent on corpse size.
		}
	else
		vengeance_demon ("progs/demon.mdl", $death9);
	}
};


void(float maxgibs, float gibscounter) producegibs_demon =		// creates as many gib-sets as defined in cvar 'gibsmultiplier'
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
producegibs_demon (maxgibs, gibscounter);
};


void()	demon_lightning_death	=[	$pain3,	demon_lightning_death1	] {
if (autocvar_lightninggun_death_animation == 2)	  // start the "fade" effect instead of "coal" effect
	lightninggun_death_fade();
};

void()	demon_lightning_death1	=[	$pain3,	demon_lightning_death1	] {
self.solid = SOLID_NOT;
self.baked = 1;
self.colormod = '0.25 0.22 0.22';	// skins gets darker (looks burned)
if (self.monstermodel == 0)  
	CopyMonsterToBodyQue(1, "progs/h_demon.mdl");
if (self.monstermodel == 1)  
	CopyMonsterToBodyQue(1, "progs/h_demon1.mdl");
};


void() demon_die =
{
if (autocvar_lightninggun_death_animation)		// if 'lightninggun_death_animation' is enabled
	{
	if (self.enemy.weapon == IT_LIGHTNING)		// when enemy was killed with lightning gun, go into baked mode
		{
		demon_lightning_death();
		return;
		}
	}
local float maxgibs, gibscounter;
// check for gib
	if (self.health < -80)
	{
		if (autocvar_slowmotion >= 1)	// start slowmotion when gibbing living enemies
		{
			if (random () <= (autocvar_slowmotion_randomness_demon * 0.01))
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
					ThrowHead ("progs/h_demon.mdl", self.health);
				else if (self.monstermodel == 1)  
					ThrowHead ("progs/h_demon1.mdl", self.health);
				ThrowGib ("progs/gib1.mdl", self.health);
				ThrowGib ("progs/gib1.mdl", self.health);
				ThrowGib ("progs/gib1.mdl", self.health);
				if (autocvar_heartgib >= 1)		// if 'heartgib' doesnt exist in autoexec.cfg, or if 'heartgib' is set via autoexec.cfg to '1' or higher
					ThrowHeart ("progs/gibheart.mdl", self.health);
				if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
					pointparticles(particleeffectnum("blood_monster_gib"), self.origin, '0 0 0', 1);
				return;
				}
			else 							// if 'gibsmultiplier' is set via autoexec.cfg to any other value than '1'
				{						// --> produce more gibs
				if (self.monstermodel == 0)  
					ThrowHead ("progs/h_demon.mdl", self.health);
				else if (self.monstermodel == 1)  
					ThrowHead ("progs/h_demon1.mdl", self.health);
				if (autocvar_heartgib >= 1)		// if 'heartgib' doesnt exist in autoexec.cfg, or if 'heartgib' is set via autoexec.cfg to '1' or higher
					ThrowHeart ("progs/gibheart.mdl", self.health);
				maxgibs = autocvar_gibsmultiplier;
				gibscounter = 0;
				if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
					pointparticles(particleeffectnum("blood_monster_gib"), self.origin, '0 0 0', 1);
				producegibs_demon (maxgibs, gibscounter);
				return;
				}
	}

// regular death

local float zufall, randomness;
// auto_cvar 'demon' has been declared in code above already
var float autocvar_demonrandomness = 25;     	// set cvar 'demonrandomness' default to 25%
autocvar_demonrandomness = autocvar_demonrandomness * 0.01;
if (autocvar_demon == 4)		// if 'demon' is set via autoexec.cfg to '4' start Death animation with "Legend of Grimrock" effect
	{
	randomness = random();
	if (randomness <= autocvar_demonrandomness)	// checks if death animation shall be started
		{
		//Gyro_Object_ClearPhysics(self);	// ENABLE this line if you want to disable GYRO during new "Legend of Grimrock" animation !!
		demon_dieburn1();
		return;			// jump out of this function !!
		}
	}
if (autocvar_demon == 6)		// if 'demon' is set via autoexec.cfg to '6' start random Death animation (all 4 effects !!)
	{				// chance for effects (approx.): 25% / 25% / 25% / 25%  
	randomness = random();
	if (randomness <= autocvar_demonrandomness)	// checks if death animation shall be started --> depending on monsters _randomness
		{					
		zufall = random();
		if (zufall <= 0.26)
			{
			//Gyro_Object_ClearPhysics(self);   // ENABLE this line if you want to disable GYRO during new "Legend of Grimrock" animation !!
			demon_dieburn1();
			return;		// jump out of this function !!
			}		// if zufall is bigger than 0.26, use new code inside  upcoming function  for other 3 death animations
		else 
			self.grimrock_helper = 1;	// this float helps me to manipulate the other 3 death animations
		}
	else
		self.grimrock_helper = 2;	// this float helps me to manipulate the other 3 death animations
	}
	
// if 'demon' has another value is checked inside prior function (= death animation function)

	if (autocvar_slowmotion >= 3)	// start slowmotion when regular killing living enemies
		{
		if (random () <= (autocvar_slowmotion_randomness_demon * 0.01))
			{
			the_matrix = 1;
			matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
			}
		}

	demon1_die1 ();
};



void() Demon_MeleeAttack =
{
	demon1_atta1 ();
};


/*QUAKED monster_demon1 (1 0 0) (-32 -32 -24) (32 32 64) Ambush

*/
void() monster_demon1 =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	precache_model ("progs/demon.mdl");
	precache_model ("progs/h_demon.mdl");

	precache_sound ("demon/ddeath.wav");
	precache_sound ("demon/dhit2.wav");
	precache_sound ("demon/djump.wav");
	precache_sound ("demon/dpain1.wav");
	precache_sound ("demon/idle1.wav");
	precache_sound ("demon/sight2.wav");
	precache_sound ("demon/fall_backwards.wav");
	precache_sound ("walk/demon1.wav");
	precache_sound ("walk/demon2.wav");
	precache_sound ("walk/demon3.wav");
	precache_sound ("walk/demon4.wav");
	precache_sound ("walk/demon5.wav");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	
var float autocvar_demonmultiskin = 0;     	// set cvar 'demonmultiskin' default to 0
	local float zufall;
	if (autocvar_demonmultiskin == 1)		// if 'demonmultiskin' is set via autoexec.cfg to '1' use 2 different skins for ID1 model
	{
		self.multiskin = 1;
		setmodel (self, "progs/demon.mdl");
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
	else if (autocvar_demonmultiskin == 2)	// if 'demonmultiskin' is set via autoexec.cfg to '2' use 1 Id1 model skin AND external model
	{
		self.multiskin = 2;
		precache_model ("progs/demon1.mdl");
		precache_model ("progs/h_demon1.mdl");
		zufall = random();
		if (zufall >= 0.5)
			{
			setmodel (self, "progs/demon.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 0;
			}
		else 
			{
			setmodel (self, "progs/demon1.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 1;
			}
	}
	else if (autocvar_demonmultiskin == 3)	// if 'demonmultiskin' is set via autoexec.cfg to '3' use 2 Id1 model skins AND external model
	{
		self.multiskin = 3;
		precache_model ("progs/demon1.mdl");
		precache_model ("progs/h_demon1.mdl");
		zufall = random();
		if (zufall > 0.66)
			{
			setmodel (self, "progs/demon.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 0;
			}
		else if (zufall < 0.34)
			{
			setmodel (self, "progs/demon.mdl");
			self.skin = 1;
			self.monsterskin = 1;
			self.monstermodel = 0;
			}
		else
			{
			setmodel (self, "progs/demon1.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 1;
			}
	}
	else if (autocvar_demonmultiskin == 4)	// if 'demonmultiskin' is set via autoexec.cfg to '4' use 2 Id1 model skins AND 2 external model skins
	{
		self.multiskin = 4;
		precache_model ("progs/demon1.mdl");
		precache_model ("progs/h_demon1.mdl");
		zufall = random();
		if (zufall > 0.75)
			{
			setmodel (self, "progs/demon.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 0;
			}
		else if (zufall > 0.5 && zufall <= 0.75)
			{
			setmodel (self, "progs/demon.mdl");
			self.skin = 1;
			self.monsterskin = 1;
			self.monstermodel = 0;
			}
		else if (zufall > 0.25 && zufall <= 0.5)
			{
			setmodel (self, "progs/demon1.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 1;
			}
		else 
			{
			setmodel (self, "progs/demon1.mdl");
			self.skin = 1;
			self.monsterskin = 1;
			self.monstermodel = 1;
			}
	}
	else						// standard Quake
		{
		setmodel (self, "progs/demon.mdl");
		self.skin = 0;
		self.monsterskin = 0;
		self.monstermodel = 0;
		}

var float autocvar_demon_size = 2;     		// set cvar 'demon_size' default to 2
	local float zuffa;
	if (autocvar_demon_size == 1)		// if 'demon_size' is set via autoexec.cfg to '1' give monster random size between 100% and 114% (7% steps due to DP´s .scale restrictions)
	{
		zuffa = random();			//  je 7% um ca. 1.7 größer  (bei 24er Ausgangs bbox Mitte)
		if (zuffa <= 0.33)			//  1.07 ==> -25.7    1.14 ==> -27.4 
		{					//  1.07 ==> -25    1.14 ==> -27  
			self.scale = 1.14;
			setsize (self, VEC_HULL2_MIN - '0 0 3', VEC_HULL2_MAX - '0 0 3');
		}
		else if (zuffa <= 0.66)
		{
			self.scale = 1.07;
			setsize (self, VEC_HULL2_MIN - '0 0 1', VEC_HULL2_MAX - '0 0 1');
		}
		else
		{
			self.scale = 1;
			setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
		}
	}
	else if (autocvar_demon_size == 2)		// if 'demon_size' is set via autoexec.cfg to '2' give monster random size between 100% and 121% (7% steps due to DP´s .scale restrictions)
	{
		zuffa = random();			//  je 7% um ca. 1.7 größer  (bei 24er Ausgangs bbox Mitte)
		if (zuffa <= 0.25)			//  1.07 ==> -25.7    1.14 ==> -27.4    1.21 ==> 29
		{					//  1.07 ==> -25    1.14 ==> -27    1.21 ==> 29
			self.scale = 1.21;
			setsize (self, VEC_HULL2_MIN - '0 0 5', VEC_HULL2_MAX - '0 0 5');
		}
		else if (zuffa <= 0.5)
		{
			self.scale = 1.14;
			setsize (self, VEC_HULL2_MIN - '0 0 3', VEC_HULL2_MAX - '0 0 3');
		}
		else if (zuffa <= 0.75)
		{
			self.scale = 1.07;
			setsize (self, VEC_HULL2_MIN - '0 0 1', VEC_HULL2_MAX - '0 0 1');
		}
		else
		{
			self.scale = 1;
			setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
		}
	}
	else if (autocvar_demon_size == 3)		// if 'demon_size' is set via autoexec.cfg to '3' give monster random size between 100% and 128% (7% steps due to DP´s .scale restrictions)
	{
		zuffa = random();			//  je 7% um ca. 1.7 größer  (bei 24er Ausgangs bbox Mitte)
		if (zuffa <= 0.2)			//  1.07 ==> -25.7    1.14 ==> -27.4    1.21 ==> 29   1.28 ==> 31
		{					//  1.07 ==> -25    1.14 ==> -27    1.21 ==> 29   1.28 ==> 31
			self.scale = 1.28;
			setsize (self, VEC_HULL2_MIN - '0 0 7', VEC_HULL2_MAX - '0 0 7');
		}
		else if (zuffa <= 0.4)
		{
			self.scale = 1.21;
			setsize (self, VEC_HULL2_MIN - '0 0 5', VEC_HULL2_MAX - '0 0 5');
		}
		else if (zuffa <= 0.6)
		{
			self.scale = 1.14;
			setsize (self, VEC_HULL2_MIN - '0 0 3', VEC_HULL2_MAX - '0 0 3');
		}
		else if (zuffa <= 0.8)
		{
			self.scale = 1.07;
			setsize (self, VEC_HULL2_MIN - '0 0 1', VEC_HULL2_MAX - '0 0 1');
		}
		else
		{
			self.scale = 1;
			setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
		}
	}
	else if (autocvar_demon_size == 4)		// if 'demon_size' is set via autoexec.cfg to '4' give monster random size between 100% and 135% (7% steps due to DP´s .scale restrictions)
	{
		zuffa = random();			//  je 7% um ca. 1.7 größer  (bei 24er Ausgangs bbox Mitte)
		if (zuffa <= 0.17)			//  1.07 ==> -25.7    1.14 ==> -27.4    1.21 ==> 29.1   1.28 ==> 30.8   1.35 ==> 32.5
		{					//  1.07 ==> -25    1.14 ==> -27    1.21 ==> 29   1.28 ==> 31   1.35 ==> 33
			self.scale = 1.35;
			setsize (self, VEC_HULL2_MIN - '0 0 9', VEC_HULL2_MAX - '0 0 9');
		}
		else if (zuffa <= 0.34)
		{
			self.scale = 1.28;
			setsize (self, VEC_HULL2_MIN - '0 0 7', VEC_HULL2_MAX - '0 0 7');
		}
		else if (zuffa <= 0.5)
		{
			self.scale = 1.21;
			setsize (self, VEC_HULL2_MIN - '0 0 5', VEC_HULL2_MAX - '0 0 5');
		}
		else if (zuffa <= 0.67)
		{
			self.scale = 1.14;
			setsize (self, VEC_HULL2_MIN - '0 0 3', VEC_HULL2_MAX - '0 0 3');
		}
		else if (zuffa <= 0.84)
		{
			self.scale = 1.07;
			setsize (self, VEC_HULL2_MIN - '0 0 1', VEC_HULL2_MAX - '0 0 1');
		}
		else
		{
			self.scale = 1;
			setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
		}
	}
	else if (autocvar_demon_size > 4)		// if 'demon_size' is set via autoexec.cfg to a value bigger than '4' give monster the selected fixed size ==>  100% + [value]%  (7% steps due to DP´s .scale restrictions)
	{
		if (autocvar_demon_size > 40)
			self.origin = self.origin + '0 0 10';		// might get stuck in floor otherwise. --> drop him to floor from higher position !
		self.scale = 1 + (autocvar_demon_size * 0.01);
		self.sizefactor_x = 0;
		self.sizefactor_y = 0;
		self.sizefactor_z = autocvar_demon_size * 0.25;
		setsize (self, VEC_HULL2_MIN - self.sizefactor, VEC_HULL2_MAX - self.sizefactor);
	}
	else
	{
		self.scale = 1;
		setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	}

var float autocvar_demon_size_influenced_health = 0; 		  		// set cvar 'demon_size_influenced_health' default to 0
	if (autocvar_demon_size_influenced_health == 1)				// if 'demon_size_influenced_health' is set via autoexec.cfg to '1' raise monster´s health according to its size  (use different formular for monsters with default health <100 and health >100 to be realistic/noticable)
		self.health = autocvar_demon_health * self.scale;		// default: 300
	else
		self.health = autocvar_demon_health;				// default: 300
	self.health_initial = self.health;

	if (autocvar_monster_random_skin_color_alteration && autocvar_demon_random_skin_colors)	// modify/edit this monster types skin textures randomly (for higher variation in-game)
	{											// limit values to avoid extreme colors
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
	
	self.th_stand = demon1_stand1;
	self.th_walk = demon1_walk1;
	self.th_run = demon1_run1;
	self.th_die = demon_die;
	self.th_melee = Demon_MeleeAttack;		// one of two attacks
	self.th_missile = demon1_jump1;			// jump attack
	self.th_pain = demon1_pain;

	var float autocvar_helldemon = 50;		// set cvar 'helldemon' default to 50 (= 50%).  Set your percentage how many demons shall leave burning footprint-marks on the floor. (100= always; 0= never)
	autocvar_helldemon = autocvar_helldemon * 0.01;
	local float zufal;
	zufal = random();	
	if (zufal <= autocvar_helldemon)	
		self.demon_on_fire = 1;

	self.alpha = autocvar_monstertransparency * 0.01;
	
	if (autocvar_spider_replace_demon)		// if demon shall be replaced by spider. Check the chance and do it !!)
		{	
		local float replacer;		
		replacer = autocvar_spider_replace_demon * 0.01;
		if (random () <= replacer)
			{
			self.skin = 4;
			self.health = autocvar_demon_health;		// default: 300
			self.scale = 1;
			setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
			self.nextthink = time + 0.3;	
			self.think = SUB_Remove;
			monster_spider_start();
			return;
			}
		}
		
	if (autocvar_afrit_replace_demon)		// if demon shall be replaced by afrit. Check the chance and do it !!)
		{	
		local float replac;		
		replac = autocvar_afrit_replace_demon * 0.01;
		if (random () <= replac)
			{
			self.health = autocvar_demon_health;		// default: 300
			self.scale = 1;
			setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
			self.nextthink = time + 0.3;	
			self.think = SUB_Remove;
			monster_afrit_liftorigin_start();
			return;
			}
		}

	walkmonster_start();

do_the_cloning();

if (autocvar_afrit_supports_demon)		// if afrit shall be spawned in ADDITION to an existing demon. Check the chance and do it !!)
	{	
	local float replace;		
	replace = autocvar_afrit_supports_demon * 0.01;
	if (random () <= replace)
		add_afrit_support_walk ();
	}

var float autocvar_demonmass = 2600;
MonsterPhysics (self, autocvar_demonmass);
};


/*
==============================================================================

DEMON

==============================================================================
*/

/*
==============
CheckDemonMelee

Returns TRUE if a melee attack would hit right now
==============
*/
float()	CheckDemonMelee =
{
	if (enemy_range == RANGE_MELEE)
	{	// FIXME: check canreach
		self.attack_state = AS_MELEE;
		return TRUE;
	}
	return FALSE;
};

/*
==============
CheckDemonJump

==============
*/
float()	CheckDemonJump =
{
	local	vector	dist;
	local	float	d;

	if (self.origin_z + self.mins_z > self.enemy.origin_z + self.enemy.mins_z
	+ 0.75 * self.enemy.size_z)
		return FALSE;
		
	if (self.origin_z + self.maxs_z < self.enemy.origin_z + self.enemy.mins_z
	+ 0.25 * self.enemy.size_z)
		return FALSE;
		
	dist = self.enemy.origin - self.origin;
	dist_z = 0;
	
	d = vlen(dist);
	
	if (d < 100)
		return FALSE;
		
	if (d > 200)
	{
		if (autocvar_skill_adjusted_monster_rangedattack_frequence)
		{
			if (skill == 0)
			{
				if (random() < 0.9)
					return FALSE;
			}
			else if (skill == 1)
			{
				if (random() < 0.85)
					return FALSE;
			}
			else if (skill == 2)
			{
				if (random() < 0.8)
					return FALSE;
			}
			else
			{
				if (random() < 0.75)
					return FALSE;
			}
		}
		else
		{
			if (random() < 0.9)
				return FALSE;
		}
	}
		
	return TRUE;
};

float()	DemonCheckAttack =
{
// if close enough for slashing, go for it
	if (CheckDemonMelee ())
	{
		self.attack_state = AS_MELEE;
		return TRUE;
	}
	
	if (CheckDemonJump ())
	{
		self.attack_state = AS_MISSILE;
        sound (self, CHAN_VOICE, "demon/djump.wav", 1, ATTN_NORM);
		return TRUE;
	}
	
	return FALSE;
};


//===========================================================================

void(float side)	Demon_Melee =
{
	local	float	ldmg;
	local vector	delta;
	
	ai_face ();
	walkmove (self.ideal_yaw, 12);	// allow a little closing

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 100)
		return;
	if (!CanDamage (self.enemy, self))
		return;
		
    sound (self, CHAN_WEAPON, "demon/dhit2.wav", 1, ATTN_NORM);
    var float autocvar_demon_size_influenced_attack = 0; 	  		// set cvar 'demon_size_influenced_attack' default to 0
	if (autocvar_demon_size_influenced_attack == 1)				// if 'demon_size_influenced_attack' is set via autoexec.cfg to '1' raise monster´s attack values according to its size 
		ldmg = (autocvar_demon_claws * self.scale) + 5*random();	// default 10
	else
		ldmg = autocvar_demon_claws + 5*random();			// default 10
	T_Damage (self.enemy, self, self, ldmg);	

	makevectors (self.angles);
	SpawnMeatSpray (self.origin + v_forward*16, side * v_right);
};


void()	Demon_JumpTouch =
{
	local	float	ldmg;

	if (self.health <= 0)
		return;
		
	if (other.takedamage)
	{
		if ( vlen(self.velocity) > 400 )
		{
			var float autocvar_demon_size_influenced_attack = 0; 	  		// set cvar 'demon_size_influenced_attack' default to 0
			if (autocvar_demon_size_influenced_attack == 1)				// if 'demon_size_influenced_attack' is set via autoexec.cfg to '1' raise monster´s attack values according to its size 
				ldmg = (autocvar_demon_jump * self.scale) + 10*random();	// default 40
			else
				ldmg = autocvar_demon_jump + 10*random();			// default 40
			T_Damage (other, self, self, ldmg);	
		}
	}

	if (!checkbottom(self))
	{
		if (self.flags & FL_ONGROUND)
		{	// jump randomly to not get hung up
//dprint ("popjump\n");
	self.touch = SUB_Null;
	self.think = demon1_jump1;
	self.nextthink = time + 0.1;

//			self.velocity_x = (random() - 0.5) * 600;
//			self.velocity_y = (random() - 0.5) * 600;
//			self.velocity_z = 200;
//			self.flags = self.flags - FL_ONGROUND;
		}
		return;	// not on ground yet
	}

	self.touch = SUB_Null;
	self.think = demon1_jump11;
	self.nextthink = time + 0.1;
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
void(string modelname, float modelframe) vengeance_demon; 

==============================================================================
*/


void() vengeance_demon_end1 = {					// end sequence
	self.alpha = -1;
	te_customflash (self.origin, 500, 0.7, '1 0 0');
	self.nextthink = time + 0.2;
      self.think = SUB_Remove;
};


void() vengeance_demon_touch = {       // player receives 1-3 damage when he gets touched by vengeance effect

      local float ldmg;
	ldmg = rint(0.5 + (3 * random()));  	// chances=  33%: 1 damage /  33%: 2 damage  /  33%: 3 damage

      T_Damage (self.enemy, self, self, ldmg);      	// analog to meele attack dog/fiend
//    T_Damage (other, self, self, ldmg); 		// analog to jump damage dog/fiend

	self.touch = SUB_Null;   // um nicht endlos damage zu kriegen !

	self.think = vengeance_demon_end1;  
	self.nextthink = time + 0.1;    	
};

										//  from here on: run sequence. 

void() vengeance_demon_run1 =[	$run1,	vengeance_demon_run2 ]   {
	ai_face();
 	movetogoal (20); 
self.touch = vengeance_demon_touch;  
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_demon_run2 =[	$run2,	vengeance_demon_run3 ]   {
	ai_face();
 	movetogoal (15); 
self.touch = vengeance_demon_touch;  
	self.alpha = 0.35;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_demon_run3 =[	$run3,	vengeance_demon_run4 ]    {
	ai_face();
 	movetogoal (36); 
self.touch = vengeance_demon_touch;  
	self.alpha = 0.3;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_demon_run4 =[	$run4,	vengeance_demon_run5 ]    {
	ai_face();
 	movetogoal (20); 
self.touch = vengeance_demon_touch;  
	self.alpha = 0.25;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_demon_run5 =[	$run5,	vengeance_demon_jump1 ]    {
	ai_face();
 	movetogoal (36);  	// orig (15)
self.touch = vengeance_demon_touch;  
	self.alpha = 0.2;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};

										//  from here on: attack/jump sequenz. 

void() vengeance_demon_jump1 =[	$leap1,	vengeance_demon_jump2 ]    {
	ai_face();
self.touch = vengeance_demon_touch;  
	self.alpha = 0.17;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_demon_jump2 =[	$leap2,	vengeance_demon_jump3 ]    {
sound (self, CHAN_VOICE, "demon/djump.wav", 1, ATTN_NORM);	
	ai_face();
self.touch = vengeance_demon_touch;  
	self.alpha = 0.14;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_demon_jump3 =[	$leap3,	vengeance_demon_jump4 ]    {
	ai_face();
 	movetogoal (16); 
self.touch = vengeance_demon_touch;  
	self.alpha = 0.11;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_demon_jump4 =[	$leap4,	vengeance_demon_jump5 ]    {
	ai_face();
 	movetogoal (26); 
self.touch = vengeance_demon_touch;  
	self.alpha = 0.08;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_demon_jump5 =[	$leap5,	vengeance_demon_end1 ]    {
	ai_face();
 	movetogoal (36); 
self.touch = vengeance_demon_touch;  
	makevectors (self.angles);
	self.origin_z = self.origin_z + 1;
	self.velocity = v_forward * 280 + '0 0 250';
	self.alpha = 0.06;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};


									//  from here on: ressurection sequenz. 

void() vengeance_demon1 =[	$death8,	vengeance_demon2 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_demon2 =[	$death7,	vengeance_demon3 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_demon3 =[	$death6,	vengeance_demon4 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_demon4 =[	$death5,	vengeance_demon5 	]  {
sound (self, CHAN_WEAPON, "demon/sight2.wav", 1, ATTN_NORM);
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_demon5 =[	$death4,	vengeance_demon6 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_demon6 =[	$death3,	vengeance_demon7 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_demon7 =[	$death2,	vengeance_demon8 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_demon8 =[	$death1,	vengeance_demon_stand1 ]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_demon_stand1 =[	$attacka1,	vengeance_demon_run1 ]  {     // needed to make the animation fluent
	self.alpha = 0.4;										// $attacka1 fills the frame gap
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};


								// from here on:  sequence where the corpse overbrights 
void()	vengeance_demon_bright05	= {
	self.alpha = 0.3;
	self.colormod = '6 1 1';
	self.glow_color = 75;
	self.glow_size = 450;
	self.nextthink = time + 0.1;
	self.think = vengeance_demon1;
};
void()	vengeance_demon_bright04 	= {
	self.alpha = 0.3;
	self.colormod = '5 1 1';
	self.glow_color = 75;
	self.glow_size = 350;
	self.nextthink = time + 0.1;
	self.think = vengeance_demon_bright05;
};
void()	vengeance_demon_bright03 	= {
	self.alpha = 0.3;
	self.colormod = '4 1 1';
	self.glow_color = 75;
	self.glow_size = 270;
	self.nextthink = time + 0.1;
	self.think = vengeance_demon_bright04;
};
void()	vengeance_demon_bright02 	= {
	self.alpha = 0.3;
	self.colormod = '3 1 1';
	self.glow_color = 75;
	self.glow_size = 185;
	self.nextthink = time + 0.1;
	self.think = vengeance_demon_bright03;
}; 
void()	vengeance_demon_bright01	= {
	self.alpha = 0.3;
	self.colormod = '2 1 1';
	self.glow_color = 75;
	self.glow_size = 100;
	self.nextthink = time + 0.1;
	self.think = vengeance_demon_bright02;
};
void()	vengeance_demon_bright00 	= {  			// delay for 0.3 seconds before overbright process really begins
	self.alpha = 0.3;
	self.glow_color = 75;
	self.glow_size = 10;
	self.nextthink = time + 0.3;
	self.think = vengeance_demon_bright01;
};



void(string modelname, float modelframe) vengeance_demon =
{

local vector v;  			// v  was necessary at the begining of effect development, but isnt anymore now.
v_x = (self.origin_x);
v_y = (self.origin_y);
v_z = (self.origin_z);

      self.origin = v; 
   	self.touch = SUB_Null;                
	self.movetype = MOVETYPE_FLY;
	
	if (self.monstermodel == 0)  
		setmodel (self, "progs/demon.mdl"); 
	else if (self.monstermodel == 1)  
		setmodel (self, "progs/demon1.mdl"); 

	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	self.frame = modelframe;	 // modelframe is depending on the individual monster (included in vengeance call)

	var float autocvar_vengeancedamage = 0;   // set cvar 'vengeancedamage' default to 0
	if (autocvar_vengeancedamage == 0)	  	// if 'vengeancedamage' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '0'
		self.solid = SOLID_NOT;			// vengeance effect is NOT solid and cannot hurt the player
	else
		self.solid = SOLID_SLIDEBOX;    	// if value is NOT "0", player get hurt from this effect (see func "vengeance_demon_touch")!

	vengeance_demon_bright00 ();			// starts the animation
};


