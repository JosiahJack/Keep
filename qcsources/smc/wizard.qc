/*
==============================================================================

WIZARD

==============================================================================
*/

$cd id1/models/a_wizard
$origin 0 0 24
$base wizbase	
$skin wizbase

$frame hover1 hover2 hover3 hover4 hover5 hover6 hover7 hover8
$frame hover9 hover10 hover11 hover12 hover13 hover14 hover15

$frame fly1 fly2 fly3 fly4 fly5 fly6 fly7 fly8 fly9 fly10
$frame fly11 fly12 fly13 fly14

$frame magatt1 magatt2 magatt3 magatt4 magatt5 magatt6 magatt7
$frame magatt8 magatt9 magatt10 magatt11 magatt12 magatt13

$frame pain1 pain2 pain3 pain4

$frame death1 death2 death3 death4 death5 death6 death7 death8

/*
==============================================================================

WIZARD

If the player moves behind cover before the missile is launched, launch it
at the last visible spot with no velocity leading, in hopes that the player
will duck back out and catch it.
==============================================================================
*/

/*
=============
LaunchMissile

Sets the given entities velocity and angles so that it will hit self.enemy
if self.enemy maintains it's current velocity
0.1 is moderately accurate, 0.0 is totally accurate
=============
*/
void(entity missile, float mspeed, float accuracy) LaunchMissile =
{
	local	vector	vec, move;
	local	float	fly;

	makevectors (self.angles);
		
// set missile speed
	vec = self.enemy.origin + self.enemy.mins + self.enemy.size * 0.7 - missile.origin;

// calc aproximate time for missile to reach vec
	fly = vlen (vec) / mspeed;
	
// get the entities xy velocity
	move = self.enemy.velocity;
	move_z = 0;

// project the target forward in time
	vec = vec + move * fly;
	
	vec = normalize(vec);
	vec = vec + accuracy*v_up*(random()- 0.5) + accuracy*v_right*(random()- 0.5);
	
	missile.velocity = vec * mspeed;

	missile.angles = '0 0 0';
	missile.angles_y = vectoyaw(missile.velocity);

// set missile duration
	missile.nextthink = time + 5;
	missile.think = SUB_Remove;	
};


void() wiz_run1;
void() wiz_side1;

/*
=================
WizardCheckAttack
=================
*/
float()	WizardCheckAttack =
{
	local vector	spot1, spot2;	
	local entity	targ;
	local float		chance;

	if (time < self.attack_finished)
		return FALSE;
	if (!enemy_vis)
		return FALSE;

	if (enemy_range == RANGE_FAR)
	{
		if (self.attack_state != AS_STRAIGHT)
		{
			self.attack_state = AS_STRAIGHT;
			wiz_run1 ();
		}
		return FALSE;
	}
		
	targ = self.enemy;
	
// see if any entities are in the way of the shot
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;

	traceline (spot1, spot2, FALSE, self);

	if (trace_ent != targ)
	{	// don't have a clear shot, so move to a side
		if (self.attack_state != AS_STRAIGHT)
		{
			self.attack_state = AS_STRAIGHT;
			wiz_run1 ();
		}
		return FALSE;
	}
			
	if (enemy_range == RANGE_MELEE)
	{
		if (autocvar_skill_adjusted_monster_rangedattack_frequence)
		{
			if (skill == 0)
				chance = 0.9;
			else if (skill == 1)
				chance = 0.92;
			else if (skill == 2)
				chance = 0.94;
			else
				chance = 0.96;
		}
		else
			chance = 0.9;
	}
	else if (enemy_range == RANGE_NEAR)
	{
		if (autocvar_skill_adjusted_monster_rangedattack_frequence)
		{
			if (skill == 0)
				chance = 0.6;
			else if (skill == 1)
				chance = 0.7;
			else if (skill == 2)
				chance = 0.8;
			else
				chance = 0.9;
		}
		else
			chance = 0.6;
	}
	else if (enemy_range == RANGE_MID)
	{
		if (autocvar_skill_adjusted_monster_rangedattack_frequence)
		{
			if (skill == 0)
				chance = 0.2;
			else if (skill == 1)
				chance = 0.35;
			else if (skill == 2)
				chance = 0.5;
			else
				chance = 0.666;
		}
		else
			chance = 0.2;
	}
	else
		chance = 0;

	if (random () < chance)
	{
		self.attack_state = AS_MISSILE;
		return TRUE;
	}

	if (enemy_range == RANGE_MID)
	{
		if (self.attack_state != AS_STRAIGHT)
		{
			self.attack_state = AS_STRAIGHT;
			wiz_run1 ();
		}
	}
	else
	{
		if (self.attack_state != AS_SLIDING)
		{
			self.attack_state = AS_SLIDING;
			wiz_side1 ();
		}
	}
	
	return FALSE;
};

/*
=================
WizardAttackFinished
=================
*/
float()	WizardAttackFinished =
{
	if (enemy_range >= RANGE_MID || !enemy_vis)
	{
		self.attack_state = AS_STRAIGHT;
		self.think = wiz_run1;
	}
	else
	{
		self.attack_state = AS_SLIDING;
		self.think = wiz_side1;
	}
};

/*
==============================================================================

FAST ATTACKS

==============================================================================
*/

void () homing_spikes_think =
{
local vector newdirection;
local float t, homingpower;

	if (self.enemy.health < 1)
		remove (self);

	if (self.maxlifetime < time)
		remove (self);

	self.velocity = normalize (self.velocity);
	newdirection = (self.enemy.origin + '0 0 12') - self.origin;
	newdirection = normalize (newdirection);
	t = time - self.ltime;
	self.ltime = time;

	if (self.classname == "knightspike")		// hellknight projectiles fly slower, so needs different homing factors
	{
		if (skill == 1)
			homingpower = 0.2;
		else if (skill == 2)
			homingpower = 0.27;
		else 
			homingpower = 0.33;
	}
	else
	{
		if (skill == 1)
			homingpower = 0.3;
		else if (skill == 2)
			homingpower = 0.4;
		else 
			homingpower = 0.5;
	}
	
	self.velocity = (self.velocity * (1 - homingpower) * t) + (newdirection * homingpower * t);
	self.velocity = normalize (self.velocity);
	if (self.classname == "knightspike")
		self.velocity = self.velocity * 300;
	else
		self.velocity = self.velocity * 600;
	self.angles = vectoangles (self.velocity);
            
	self.think = homing_spikes_think;
	self.nextthink = time + 0.2;
};


void(vector org, vector dir) launch_homing_spikes =
{
	newmis = spawn ();
	newmis.owner = self;
	newmis.enemy = self.enemy;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;
	newmis.angles = vectoangles(dir);
	
	newmis.touch = spike_enemy_touch; 
	setorigin (newmis, org);
	newmis.velocity = dir * 1000;
	
	newmis.maxlifetime =  time + 5;
	newmis.think = homing_spikes_think;
	newmis.nextthink = time + 0.1;
};


void() Wiz_FastFire =
{
	local vector		vec;
	local vector		dst;

	if (self.owner.health > 0)
	{
		self.owner.effects = self.owner.effects | EF_MUZZLEFLASH;

		makevectors (self.enemy.angles);	
		dst = self.enemy.origin - 13*self.movedir;
	
		vec = normalize(dst - self.origin);
		sound (self, CHAN_WEAPON, "wizard/wattack.wav", 1, ATTN_NORM);
		if ((autocvar_skill_adjusted_wizard_projectile_homing) && (skill != 0))
			launch_homing_spikes (self.origin, vec);
		else
			launch_enemy_spike (self.origin, vec);
		newmis.velocity = vec*600;
		newmis.owner = self.owner;
		newmis.classname = "wizspike";
		setmodel (newmis, "progs/w_spike.mdl");
		var float autocvar_wizard_projectile_size = 0.7;	// set cvar 'wizard_projectile_size' default to 0.7.   Set the size of Wizard´s projectile here (Choose any value you want. "0.1"= very small.  "1"= regular size.  "3"= much bigger)
		newmis.scale = autocvar_wizard_projectile_size;
		var float autocvar_wizard_projectile_traileffect = 1;	// set cvar 'wizard_projectile_traileffect' default to 1.  Choose between 2 different particle trail effects ("1" = subtle like in SMC Ver.3.61  or  "2" intense like in SMC Ver.4.15)
		if (autocvar_wizard_projectile_traileffect != 1)
			newmis.traileffectnum = particleeffectnum("TR_WIZSPIKE_2");
		setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);		
	}

	remove (self);
};


void() Wiz_StartFast =
{
	local	entity	missile;
	
	sound (self, CHAN_WEAPON, "wizard/wattack.wav", 1, ATTN_NORM);
	self.v_angle = self.angles;
	makevectors (self.angles);

	missile = spawn ();
	missile.owner = self;
	missile.nextthink = time + 0.6;
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, self.origin + '0 0 30' + v_forward*14 + v_right*14);
	missile.enemy = self.enemy;
	missile.nextthink = time + 0.8;
	missile.think = Wiz_FastFire;
	missile.movedir = v_right;

	missile = spawn ();
	missile.owner = self;
	missile.nextthink = time + 1;
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, self.origin + '0 0 30' + v_forward*14 + v_right* -14);
	missile.enemy = self.enemy;
	missile.nextthink = time + 0.3;
	missile.think = Wiz_FastFire;
	missile.movedir = VEC_ORIGIN - v_right;
};



void() Wiz_idlesound =
{
local float wr;
	wr = random() * 5;

	if (self.waitmin < time)
	{
	 	self.waitmin = time + 2;
	 	if (wr > 4.5) 
	 		sound (self, CHAN_VOICE, "wizard/widle1.wav", 1,  ATTN_IDLE);
	 	if (wr < 1.5)
	 		sound (self, CHAN_VOICE, "wizard/widle2.wav", 1, ATTN_IDLE);
	}
	return;
};


var float autocvar_wizardteleport = 15;     	// set cvar 'wizardteleport' default to 15

void(vector org) spawn_wizard_fog =
{
	s = spawn ();
	s.origin = org;
	s.nextthink = time + 0.2;
	s.think = play_teleport;
	pointparticles(particleeffectnum("wizard_fog"), org, '0 0 0', 1); 
};


float(entity beacon, float attack) PM_WizTeleport =	// Teleport the wizard to some location near its target.
{
local vector spot, vec;

// Select teleport destination within a 1024 radius.
	spot_x = beacon.origin_x + (random() * 2048 - 1024);
	spot_y = beacon.origin_y + (random() * 2048 - 1024);
	spot_z = beacon.origin_z + (random() * 512 - 256);
	vec = normalize(spot - beacon.origin);
	traceline (beacon.origin, spot, TRUE, beacon);
	spot = trace_endpos - vec*50;

// Teleport only if the distance is great enough.
	if (vlen(spot - self.origin) < 77)  return FALSE;

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


void(entity beacon, float attack) PM_WizBlink =		// If the wizard teleports, make some fog.
{
local vector org;		// Wizard's original location.
	org = self.origin;
	if (PM_WizTeleport(beacon, attack))
	{	
		spawn_wizard_fog(org);
		spawn_wizard_fog(self.origin);
	}
};


//  Make multiple teleport attempts so that the wizard has a
//  big chance  to teleport.  If successful, fog is spawned.
void() PM_WizMultiBlink =
{
	local vector org;		// Wizard's original location.
	local   float   success;	// # of successful teleport attempts.
	org = self.origin;
	success = FALSE;
	success = success + PM_WizTeleport(self, FALSE);
//	success = success + PM_WizTeleport(self, FALSE);
//	success = success + PM_WizTeleport(self, FALSE);
	if (success)
	{	
		spawn_wizard_fog(org);
		spawn_wizard_fog(self.origin);
	}
};


void()	wiz_stand1	=[	$hover1,		wiz_stand2	] {ai_stand();};
void()	wiz_stand2	=[	$hover2,		wiz_stand3	] {ai_stand();};
void()	wiz_stand3	=[	$hover3,		wiz_stand4	] {ai_stand();};
void()	wiz_stand4	=[	$hover4,		wiz_stand5	] {ai_stand();};
void()	wiz_stand5	=[	$hover5,		wiz_stand6	] {ai_stand();};
void()	wiz_stand6	=[	$hover6,		wiz_stand7	] {ai_stand();};
void()	wiz_stand7	=[	$hover7,		wiz_stand8	] {ai_stand();};
void()	wiz_stand8	=[	$hover8,		wiz_stand1	] {ai_stand();};

void()	wiz_walk1	=[	$hover1,		wiz_walk2	] {ai_walk(8);
Wiz_idlesound();};
void()	wiz_walk2	=[	$hover2,		wiz_walk3	] {ai_walk(8);};
void()	wiz_walk3	=[	$hover3,		wiz_walk4	] {ai_walk(8);};
void()	wiz_walk4	=[	$hover4,		wiz_walk5	] {ai_walk(8);};
void()	wiz_walk5	=[	$hover5,		wiz_walk6	] {ai_walk(8);};
void()	wiz_walk6	=[	$hover6,		wiz_walk7	] {ai_walk(8);};
void()	wiz_walk7	=[	$hover7,		wiz_walk8	] {ai_walk(8);};
void()	wiz_walk8	=[	$hover8,		wiz_walk1	] {ai_walk(8);};

void()	wiz_side1	=[	$hover1,		wiz_side2	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(8);
Wiz_idlesound();};
void()	wiz_side2	=[	$hover2,		wiz_side3	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(8);};
void()	wiz_side3	=[	$hover3,		wiz_side4	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(8);};
void()	wiz_side4	=[	$hover4,		wiz_side5	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(8);};
void()	wiz_side5	=[	$hover5,		wiz_side6	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(8);};
void()	wiz_side6	=[	$hover6,		wiz_side7	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(8);};
void()	wiz_side7	=[	$hover7,		wiz_side8	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(8);};
void()	wiz_side8	=[	$hover8,		wiz_side1	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(8);};

void()	wiz_run1	=[	$fly1,		wiz_run2	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(16);
Wiz_idlesound();
if (autocvar_wizardteleport)		// wizards can teleport
	{
	if (random() < (skill * 0.04))		// There is a small chance that the wizard will teleport to find its target.
		PM_WizBlink(self.enemy, FALSE);	
	}
};
void()	wiz_run2	=[	$fly2,		wiz_run3	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(16);};
void()	wiz_run3	=[	$fly3,		wiz_run4	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(16);};
void()	wiz_run4	=[	$fly4,		wiz_run5	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(16);};
void()	wiz_run5	=[	$fly5,		wiz_run6	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(16);};
void()	wiz_run6	=[	$fly6,		wiz_run7	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(16);};
void()	wiz_run7	=[	$fly7,		wiz_run8	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(16);};
void()	wiz_run8	=[	$fly8,		wiz_run9	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(16);};
void()	wiz_run9	=[	$fly9,		wiz_run10	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(16);};
void()	wiz_run10	=[	$fly10,		wiz_run11	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(16);};
void()	wiz_run11	=[	$fly11,		wiz_run12	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(16);};
void()	wiz_run12	=[	$fly12,		wiz_run13	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(16);};
void()	wiz_run13	=[	$fly13,		wiz_run14	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(16);};
void()	wiz_run14	=[	$fly14,		wiz_run1	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(16);};

void()	wiz_fast1	=[	$magatt1,	wiz_fast2	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);
if (autocvar_wizardteleport)	// wizards can teleport
	{
	local float zufall;		
	zufall = autocvar_wizardteleport * 0.01;
	if (random () <= zufall)
		PM_WizBlink(self, TRUE);	// attack from new position
	}
ai_face();Wiz_StartFast();
};
void()	wiz_fast2	=[	$magatt2,	wiz_fast3	] {ai_face();};
void()	wiz_fast3	=[	$magatt3,	wiz_fast4	] {ai_face();};
void()	wiz_fast4	=[	$magatt4,	wiz_fast5	] {ai_face();};
void()	wiz_fast5	=[	$magatt5,	wiz_fast6	] {ai_face();};
void()	wiz_fast6	=[	$magatt6,	wiz_fast7	] {ai_face();};
void()	wiz_fast7	=[	$magatt5,	wiz_fast8	] {ai_face();};
void()	wiz_fast8	=[	$magatt4,	wiz_fast9	] {ai_face();};
void()	wiz_fast9	=[	$magatt3,	wiz_fast10	] {ai_face();};
void()	wiz_fast10	=[	$magatt2,	wiz_run1	] {ai_face();
if (autocvar_skill_adjusted_monster_rangedattack_frequence)
{
	if (skill == 0)
		SUB_AttackFinished(2); 
	else if (skill == 1)
		SUB_AttackFinished(1.5); 
	else if (skill == 2)
		SUB_AttackFinished(1); 
	else
		SUB_AttackFinished(2);		// will not be used in skill 3 by  SUB_AttackFinished  anyhow !!
}
else
	SUB_AttackFinished(2); 
WizardAttackFinished ();};

void()	wiz_pain1	=[	$pain1,		wiz_pain2	] {};
void()	wiz_pain2	=[	$pain2,		wiz_pain3	] {};
void()	wiz_pain3	=[	$pain3,		wiz_pain4	] {};
void()	wiz_pain4	=[	$pain4,		wiz_run1	] {};


void() wiz_death8;
void() wizard_death_touch = 	// creates a small dust cloud, when wizard corpse falls onto ground
{       
	if (self.flags & FL_ONGROUND)
	{
		self.solid = SOLID_NOT;
		pointparticles (particleeffectnum("wizard_falling_dust"), self.origin, '0 0 0', 1);
		sound (self, CHAN_AUTO, "zombie/z_hit.wav", 0.8, ATTN_NORM);
		wiz_death8 ();
		return;
	}
	else if(self.velocity == '0 0 0')
	{
		self.solid = SOLID_NOT;
		pointparticles (particleeffectnum("wizard_falling_dust"), self.origin, '0 0 0', 1);
		sound (self, CHAN_AUTO, "zombie/z_hit.wav", 0.8, ATTN_NORM);
		wiz_death8 ();
		return;
	}
	if (self.origin == self.old_origin)		// when it got stuck somewhere. You never know...
	{
		self.solid = SOLID_NOT;
		pointparticles (particleeffectnum("wizard_falling_dust"), self.origin, '0 0 0', 1);
		sound (self, CHAN_AUTO, "zombie/z_hit.wav", 0.8, ATTN_NORM);
		wiz_death8 ();
		return;
	}
	self.old_origin = self.origin;
	self.think = wizard_death_touch; 
	self.nextthink = time + 0.001;   
};


void() wiz_dieburn1	=[	$death1,	wiz_dieburn2	] {self.burnz_origin = 12;
burn_toggle_allround();
sound (self, CHAN_VOICE, "wizard/wdeath.wav", 1, ATTN_NORM);
};
void() wiz_dieburn2	=[	$death2,	wiz_dieburn3	] {self.burnz_origin = 11;
};
void() wiz_dieburn3	=[	$death3,	wiz_dieburn4	] {self.burnz_origin = 6;
self.solid = SOLID_NOT;
};
void() wiz_dieburn4	=[	$death4,	wiz_dieburn5	] {self.burnz_origin = 3;
};
void() wiz_dieburn5	=[	$death5,	wiz_dieburn6	] {self.burnz_origin = 0;
};
void() wiz_dieburn6	=[	$death6,	wiz_dieburn7	] {self.burnz_origin = -2;
};
void() wiz_dieburn7	=[	$death7,	wiz_dieburn8	] {self.burnz_origin = -4;
};
void() wiz_dieburn8	=[	$death8,	wiz_dieburn8	] {self.burnz_origin = -6;
};


void() soulcall_wizard =     // calls the soul effect a little later (due to origin/coordinate misalignment explained below)
{
local float zet;
zet = 25;			     // z-position of the wings (in relation to soul). Dependent on corpse size.
	if (self.monstermodel == 0)  
		soul ("progs/wizard.mdl", $death8, zet);
	else if (self.monstermodel == 1)  
		soul ("progs/wizard1.mdl", $death8, zet);
};


void() vengeancecall_wizard =     // calls the vengeance effect a little later (due to origin/coordinate misalignment explained below)
{
vengeance_wizard ("progs/wizard.mdl", $death8);
};


var float autocvar_wizard = 6;     		// set cvar 'wizard' default to 6
var float autocvar_wizardcorpsehealth = 60;	// set cvar 'wizardcorpsehealth' default to 60
var float autocvar_wizardcorpseburnable = 1;	// set cvar 'wizardcorpseburnable' default to 1

void()	wiz_death1	=[	$death1,		wiz_death2	] {
if (self.scale != 1)		// because we didnt changed his setsize z-value during spawn
{
	self.sizefactor_x = 0;
	self.sizefactor_y = 0;
	self.sizefactor_z = (self.scale - 1) * 25;
	setsize (self, '-16 -16 -24' - self.sizefactor, '16 16 40' - self.sizefactor);	// to not let it´s corpse sink into floor
}
self.velocity_x = -200 + 400*random();
self.velocity_y = -200 + 400*random();
self.velocity_z = 100 + 100*random();
self.flags = self.flags - (self.flags & FL_ONGROUND);
sound (self, CHAN_VOICE, "wizard/wdeath.wav", 1, ATTN_NORM);
};
void()	wiz_death2	=[	$death2,		wiz_death3	] {};
void()	wiz_death3	=[	$death3,		wiz_death4	] {};
void()	wiz_death4	=[	$death4,		wiz_death5	] {};
void()	wiz_death5	=[	$death5,		wiz_death6	] {};
void()	wiz_death6	=[	$death6,		wiz_death7	] {wizard_death_touch ();};
void()	wiz_death7	=[	$death7,		wiz_death8	] {};
void()	wiz_death8	=[	$death8,		wiz_death8	] {
if (self.inflamed == 1)
{
	inflamed_die ();
	return;
}
local float zufall, randomness;
	if (autocvar_wizardcorpseburnable == 1)		// corpses are burnable
		self.burnable_corpse = 1;
// 	auto_cvar 'wizardcorpsehealth' has been set to  default = 60  in code above already
	self.delete_painskin = 1;		 	 // remove painskin
	if (self.monstermodel == 0)  
		CopyMonsterToBodyQue(autocvar_wizardcorpsehealth, "progs/h_wizard.mdl");
	if (self.monstermodel == 1)  
		CopyMonsterToBodyQue(autocvar_wizardcorpsehealth, "progs/h_wizard1.mdl");
if (self.nodeathanim == 1)
	return;
if (self.grimrock_helper == 0)
{
// 	auto_cvar 'wizard' has been declared in code above already
	var float autocvar_wizardrandomness = 25;     	// set cvar 'wizardrandomness' default to 25%
	autocvar_wizardrandomness = autocvar_wizardrandomness * 0.01;
	if (autocvar_wizard == 1)		// if 'wizard' is set via autoexec.cfg to '1' start ghost effect
		{
		randomness = random();
		if (randomness <= autocvar_wizardrandomness)	// checks if death animation shall be started
			{
			self.nextthink = time + 0.6;	// I had to implement a time shift, because if wizard falls from high position
			self.think = ghost_die; 
			}
		}
	else if (autocvar_wizard == 2)	// if 'wizard' is set via autoexec.cfg to '2' start soul effect
		{
		randomness = random();
		if (randomness <= autocvar_wizardrandomness)	// checks if death animation shall be started
			{
			self.nextthink = time + 0.8;	// I had to implement a time shift, because if wizard falls from high position
			self.think = soulcall_wizard; // the soul effect starts midair and has a origin/coordinate misalignment !!!
			}
		}
	else if (autocvar_wizard == 3)	// if 'wizard' is set via autoexec.cfg to '3' start vengeance effect
		{
		randomness = random();
		if (randomness <= autocvar_wizardrandomness)	// checks if death animation shall be started
			{
			self.nextthink = time + 0.8;    // I had to implement a time shift, because if wizard falls from high position
			self.think = vengeancecall_wizard; // the vengeance effect starts midair and has a origin/coordinate misalignment !!!
			}
		}
	else if (autocvar_wizard == 5)		// if 'wizard' is set via to '5' start randomly one of these Death animations:
		{				// (Ancient ghosts of the fallen ; Relieved souls of the enslaved ; Vengeance of the deceased)	
		randomness = random();		// chance for effects (approx.): 36% / 26% / 38%
		if (randomness <= autocvar_wizardrandomness)	// checks if death animation shall be started --> depending on monsters _randomness
			{			
			zufall = random();
			if (zufall > 0.64)
				{
				self.nextthink = time + 0.6;	// I had to implement a time shift, because if wizard falls from high position
				self.think = ghost_die; 
				}
			else if (zufall < 0.26)
				{
				self.nextthink = time + 0.8;    // I had to implement a time shift, because if wizard falls from high position
				self.think = soulcall_wizard;	// the soul effect starts midair and has a origin/coordinate misalignment !!!
				}
			else
				{
				self.nextthink = time + 0.8;    // I had to implement a time shift, because if wizard falls from high position
				self.think = vengeancecall_wizard; // the vengeance effect starts midair and has a origin/coordinate misalignment !!!
				}
			}
		}
	else					// if 'wizard' is set via autoexec.cfg to another value (example '0'), do nothing !
	{			
	}
}
else if (self.grimrock_helper == 1)	// this new code is the the ending of cvar value "6" (which was started in monsters _die function)
	{		
	zufall = random();
	if (zufall > 0.64)
		{
		self.nextthink = time + 0.6;	// I had to implement a time shift, because if wizard falls from high position
		self.think = ghost_die; 
		}
	else if (zufall < 0.26)
		{
		self.nextthink = time + 0.8;    // I had to implement a time shift, because if wizard falls from high position
		self.think = soulcall_wizard;	// the soul effect starts midair and has a origin/coordinate misalignment !!!
		}
	else
		{
		self.nextthink = time + 0.8;    // I had to implement a time shift, because if wizard falls from high position
		self.think = vengeancecall_wizard; // the vengeance effect starts midair and has a origin/coordinate misalignment !!!
		}
	}
};


void(float maxgibs, float gibscounter) producegibs_wizard =		// creates as many gib-sets as defined in cvar 'gibsmultiplier'
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
producegibs_wizard (maxgibs, gibscounter);
};


void() wizard_coal_touch = 	// wizards falls into pieces when falling on ground
{       
	if (self.flags & FL_ONGROUND)
	{
		self.solid = SOLID_NOT;
		baked_explode();
		return;
	}
	else if(self.velocity == '0 0 0')
	{
		self.solid = SOLID_NOT;
		baked_explode();
		return;
	}
	if (self.origin == self.old_origin)		// when it got stuck somewhere. You never know...
	{
		self.solid = SOLID_NOT;
		baked_explode();
		return;
	}
	self.old_origin = self.origin;
	self.think = wizard_coal_touch; 
	self.nextthink = time + 0.001;   
};

void()	wizard_lightning_death	=[	$pain3,	wizard_lightning_death1	] {
self.delete_painskin = 1;			  // remove painskin
if (autocvar_lightninggun_death_animation == 2)	  // start the "fade" effect instead of "coal" effect
	{
	self.movetype = MOVETYPE_NONE;
	self.velocity = '0 0 0';
	lightninggun_death_fade();
	return;
	}
self.velocity_x = -200 + 400*random();
self.velocity_y = -200 + 400*random();
self.velocity_z = 100 + 100*random();
self.flags = self.flags - (self.flags & FL_ONGROUND);
};

void()	wizard_lightning_death1	=[	$pain3,	wizard_lightning_death1	] {
self.touch = wizard_coal_touch;
self.baked = 1;
self.colormod = '0.25 0.22 0.22';	// skins gets darker (looks burned)
};


void() wiz_die;
void() wiz_inflamed9;

void()	wiz_inflamed1	=[	$hover1,	wiz_inflamed2	] {ai_run_inflamed(16); self.nextthink = time + 0.07;
if (random() < 0.75)
	sound (self, CHAN_VOICE, "wizard/wpain.wav", 1, ATTN_NORM);
};
void()	wiz_inflamed2	=[	$hover2,	wiz_inflamed3	] {ai_run_inflamed(16); self.nextthink = time + 0.07;};
void()	wiz_inflamed3	=[	$hover3,	wiz_inflamed4	] {ai_run_inflamed(16); self.nextthink = time + 0.07;};
void()	wiz_inflamed4	=[	$hover4,	wiz_inflamed5	] {ai_run_inflamed(16); self.nextthink = time + 0.07;};
void()	wiz_inflamed5	=[	$hover5,	wiz_inflamed6	] {ai_run_inflamed(16); self.nextthink = time + 0.07;};
void()	wiz_inflamed6	=[	$hover6,	wiz_inflamed7	] {ai_run_inflamed(16); self.nextthink = time + 0.07;};
void()	wiz_inflamed7	=[	$hover7,	wiz_inflamed8	] {ai_run_inflamed(16); self.nextthink = time + 0.07;};
void()	wiz_inflamed8	=[	$hover8,	wiz_inflamed1	] {ai_run_inflamed(16); self.nextthink = time + 0.07;
if (self.inflametime < time)
{
	wiz_die ();
	return;
}
if (random() < 0.5)
	wiz_inflamed9 ();	// start pain anim
};

void()	wiz_inflamed9	=[	$pain1,		wiz_inflamed10	] {ai_run_inflamed(10); self.nextthink = time + 0.08;
if (random() < 0.8)
	sound (self, CHAN_VOICE, "wizard/wpain.wav", 1, ATTN_NORM);
};
void()	wiz_inflamed10	=[	$pain2,		wiz_inflamed11	] {ai_run_inflamed(10); self.nextthink = time + 0.08;};
void()	wiz_inflamed11	=[	$pain3,		wiz_inflamed12	] {ai_run_inflamed(10); self.nextthink = time + 0.08;};
void()	wiz_inflamed12	=[	$pain4,		wiz_inflamed13	] {ai_run_inflamed(10); self.nextthink = time + 0.08;};
void()	wiz_inflamed13	=[	$pain2,		wiz_inflamed1	] {ai_run_inflamed(10); self.nextthink = time + 0.07;
if (self.inflametime < time)
{
	wiz_die ();
	return;
}
};



void() wiz_die =
{
	if (self.do_not_replace_me == 1)
		self.owner.magiccounter = self.owner.magiccounter - 1;
	if (autocvar_lightninggun_death_animation)		// if 'lightninggun_death_animation' is enabled
	{
		if (self.enemy.weapon == IT_LIGHTNING)		// when enemy was killed with lightning gun, go into baked mode
		{
			wizard_lightning_death();
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
			if (random () <= (autocvar_slowmotion_randomness_wizard * 0.01))
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
					ThrowHead ("progs/h_wizard.mdl", self.health);
				else if (self.monstermodel == 1)  
					ThrowHead ("progs/h_wizard1.mdl", self.health);
				ThrowGib ("progs/gib2.mdl", self.health);
				ThrowGib ("progs/gib2.mdl", self.health);
				ThrowGib ("progs/gib2.mdl", self.health);
				if (autocvar_heartgib >= 1)		// if 'heartgib' doesnt exist in autoexec.cfg, or if 'heartgib' is set via autoexec.cfg to '1' or higher
					ThrowHeart ("progs/gibheart.mdl", self.health);
				if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
					pointparticles(particleeffectnum("blood_monster_gib"), self.origin, '0 0 0', 1);
				return;
				}
			else 							// if 'gibsmultiplier' is set via autoexec.cfg to any other value than '1'
				{						// --> produce more gibs
				if (self.monstermodel == 0)  
					ThrowHead ("progs/h_wizard.mdl", self.health);
				else if (self.monstermodel == 1)  
					ThrowHead ("progs/h_wizard1.mdl", self.health);
				if (autocvar_heartgib >= 1)		// if 'heartgib' doesnt exist in autoexec.cfg, or if 'heartgib' is set via autoexec.cfg to '1' or higher
					ThrowHeart ("progs/gibheart.mdl", self.health);
				maxgibs = autocvar_gibsmultiplier;
				gibscounter = 0;
				if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
					pointparticles(particleeffectnum("blood_monster_gib"), self.origin, '0 0 0', 1);
				producegibs_wizard (maxgibs, gibscounter);
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
				self.flags = self.flags | FL_FLY;
				self.inflamed = 1;
				self.traileffectnum = particleeffectnum("burning_monster");
				self.inflametime = time + autocvar_burning_monsters_death_animation_time + random();
				wiz_inflamed1 ();
				return;
			}
		}
		else		// enemy is burning already and his "run-around-in-panic-time" has just ended
		{
			self.flags = self.flags - (self.flags & FL_FLY);
			wiz_death1 ();
			return;
		}
	}

// regular death

local float zufall, randomness;
// auto_cvar 'wizard' has been declared in code above already
var float autocvar_wizardrandomness = 25;     	// set cvar 'wizardrandomness' default to 25%
autocvar_wizardrandomness = autocvar_wizardrandomness * 0.01;
if (autocvar_wizard == 4)		// if 'wizard' is set via autoexec.cfg to '4' start Death animation with "Legend of Grimrock" effect
	{
	randomness = random();
	if (randomness <= autocvar_wizardrandomness)	// checks if death animation shall be started
		{
		//Gyro_Object_ClearPhysics(self);	// ENABLE this line if you want to disable GYRO during new "Legend of Grimrock" animation !!
		self.delete_painskin = 1;		// remove painskin
		wiz_dieburn1();
		return;			// jump out of this function !!
		}
	}
if (autocvar_wizard == 6)		// if 'wizard' is set via autoexec.cfg to '6' start random Death animation (all 4 effects)
	{				// chance for effects (approx.): 25% / 25% / 25% / 25%  		
	randomness = random();
	if (randomness <= autocvar_wizardrandomness)	// checks if death animation shall be started --> depending on monsters _randomness
		{						
		zufall = random();
		if (zufall <= 0.26)
			{
			//Gyro_Object_ClearPhysics(self);   // ENABLE this line if you want to disable GYRO during new "Legend of Grimrock" animation !!
			self.delete_painskin = 1;	    // remove painskin
			wiz_dieburn1();
			return;		// jump out of this function !!
			}		// if zufall is bigger than 0.26, use new code inside  upcoming function  for other 3 death animations
		else 
			self.grimrock_helper = 1;	// this float helps me to manipulate the other 3 death animations
		}
	else
		self.grimrock_helper = 2;	// this float helps me to manipulate the other 3 death animations
	}
	
// if 'wizard' has another value is checked inside prior function (= death animation function)

	if (autocvar_slowmotion >= 3)	// start slowmotion when regular killing living enemies
		{
		if (random () <= (autocvar_slowmotion_randomness_wizard * 0.01))
			{
			the_matrix = 1;
			matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
			}
		}
	wiz_death1 ();
};


void(entity attacker, float damage) Wiz_Pain =
{
	sound (self, CHAN_VOICE, "wizard/wpain.wav", 1, ATTN_NORM);
	if (autocvar_wizardteleport)			// wizards can teleport
		{
		local float zufall;		
		zufall = autocvar_wizardteleport * 0.01;
		if (random () <= zufall)
		        PM_WizMultiBlink();   	 	// Teleport away from danger.
		}
	if (random()*70 > damage)
		return;		// didn't flinch

	if (autocvar_slowmotion >= 4)	// start slowmotion when hurting enemies
	{
		if (random () <= (autocvar_slowmotion_randomness_wizard * 0.01))
			{
			the_matrix = 1;
			matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
			}
	}

	wiz_pain1 ();
};


void() Wiz_Missile =
{
	wiz_fast1();
};

/*QUAKED monster_wizard (1 0 0) (-16 -16 -24) (16 16 40) Ambush
*/
void() monster_wizard =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	precache_model ("progs/wizard.mdl");
	precache_model ("progs/h_wizard.mdl");
	precache_model ("progs/w_spike.mdl");

	precache_sound ("wizard/hit.wav");		// used by c code
	precache_sound ("wizard/wattack.wav");
	precache_sound ("wizard/wdeath.wav");
	precache_sound ("wizard/widle1.wav");
	precache_sound ("wizard/widle2.wav");
	precache_sound ("wizard/wpain.wav");
	precache_sound ("wizard/wsight.wav");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

var float autocvar_wizardmultiskin = 0;     	// set cvar 'wizardmultiskin' default to 0
	local float zufall;
	if (autocvar_wizardmultiskin == 1)		// if 'wizardmultiskin' is set via autoexec.cfg to '1' use 2 different skins for ID1 model
	{
		self.multiskin = 1;
		setmodel (self, "progs/wizard.mdl");
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
	else if (autocvar_wizardmultiskin == 2)	// if 'wizardmultiskin' is set via autoexec.cfg to '2' use 1 Id1 model skin AND external model
	{
		self.multiskin = 2;
		precache_model ("progs/wizard1.mdl");
		precache_model ("progs/h_wizard1.mdl");
		zufall = random();
		if (zufall >= 0.5)
			{
			setmodel (self, "progs/wizard.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 0;
			}
		else 
			{
			setmodel (self, "progs/wizard1.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 1;
			}
	}
	else if (autocvar_wizardmultiskin == 3)	// if 'wizardmultiskin' is set via autoexec.cfg to '3' use 2 Id1 model skins AND external model
	{
		self.multiskin = 3;
		precache_model ("progs/wizard1.mdl");
		precache_model ("progs/h_wizard1.mdl");
		zufall = random();
		if (zufall > 0.66)
			{
			setmodel (self, "progs/wizard.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 0;
			}
		else if (zufall < 0.34)
			{
			setmodel (self, "progs/wizard.mdl");
			self.skin = 1;
			self.monsterskin = 1;
			self.monstermodel = 0;
			}
		else
			{
			setmodel (self, "progs/wizard1.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 1;
			}
	}
	else if (autocvar_wizardmultiskin == 4)	// if 'wizardmultiskin' is set via autoexec.cfg to '4' use 2 Id1 model skins AND 2 external model skins
	{
		self.multiskin = 4;
		precache_model ("progs/wizard1.mdl");
		precache_model ("progs/h_wizard1.mdl");
		zufall = random();
		if (zufall > 0.75)
			{
			setmodel (self, "progs/wizard.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 0;
			}
		else if (zufall > 0.5 && zufall <= 0.75)
			{
			setmodel (self, "progs/wizard.mdl");
			self.skin = 1;
			self.monsterskin = 1;
			self.monstermodel = 0;
			}
		else if (zufall > 0.25 && zufall <= 0.5)
			{
			setmodel (self, "progs/wizard1.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 1;
			}
		else 
			{
			setmodel (self, "progs/wizard1.mdl");
			self.skin = 1;
			self.monsterskin = 1;
			self.monstermodel = 1;
			}
	}
	else						// standard Quake
		{
		setmodel (self, "progs/wizard.mdl");
		self.skin = 0;
		self.monsterskin = 0;
		self.monstermodel = 0;
		}


var float autocvar_wizard_size = 3;     	// set cvar 'wizard_size' default to 3
	local float zuffa;
	if (autocvar_wizard_size == 1)		// if 'wizard_size' is set via autoexec.cfg to '1' give monster random size between 100% and 114% (7% steps due to DP´s .scale restrictions)
	{
		zuffa = random();			//  je 7% um ca. 1.7 größer  (bei 24er Ausgangs bbox Mitte)
		if (zuffa <= 0.33)			//  1.07 ==> -25.7    1.14 ==> -27.4 
			self.scale = 1.14;		//  1.07 ==> -25    1.14 ==> -27  
		else if (zuffa <= 0.66)
			self.scale = 1.07;
		else
			self.scale = 1;
	}
	else if (autocvar_wizard_size == 2)		// if 'wizard_size' is set via autoexec.cfg to '2' give monster random size between 100% and 121% (7% steps due to DP´s .scale restrictions)
	{
		zuffa = random();			//  je 7% um ca. 1.7 größer  (bei 24er Ausgangs bbox Mitte)
		if (zuffa <= 0.25)			//  1.07 ==> -25.7    1.14 ==> -27.4    1.21 ==> 29
			self.scale = 1.21;		//  1.07 ==> -25    1.14 ==> -27    1.21 ==> 29
		else if (zuffa <= 0.5)
			self.scale = 1.14;
		else if (zuffa <= 0.75)
			self.scale = 1.07;
		else
			self.scale = 1;
	}
	else if (autocvar_wizard_size == 3)		// if 'wizard_size' is set via autoexec.cfg to '3' give monster random size between 100% and 128% (7% steps due to DP´s .scale restrictions)
	{
		zuffa = random();			//  je 7% um ca. 1.7 größer  (bei 24er Ausgangs bbox Mitte)
		if (zuffa <= 0.2)			//  1.07 ==> -25.7    1.14 ==> -27.4    1.21 ==> 29   1.28 ==> 31
			self.scale = 1.28;		//  1.07 ==> -25    1.14 ==> -27    1.21 ==> 29   1.28 ==> 31
		else if (zuffa <= 0.4)
			self.scale = 1.21;
		else if (zuffa <= 0.6)
			self.scale = 1.14;
		else if (zuffa <= 0.8)
			self.scale = 1.07;
		else
			self.scale = 1;
	}
	else if (autocvar_wizard_size == 4)		// if 'wizard_size' is set via autoexec.cfg to '4' give monster random size between 100% and 135% (7% steps due to DP´s .scale restrictions)
	{
		zuffa = random();			//  je 7% um ca. 1.7 größer  (bei 24er Ausgangs bbox Mitte)
		if (zuffa <= 0.17)			//  1.07 ==> -25.7    1.14 ==> -27.4    1.21 ==> 29.1   1.28 ==> 30.8   1.35 ==> 32.5
			self.scale = 1.35;		//  1.07 ==> -25    1.14 ==> -27    1.21 ==> 29   1.28 ==> 31   1.35 ==> 33
		else if (zuffa <= 0.34)
			self.scale = 1.28;
		else if (zuffa <= 0.5)
			self.scale = 1.21;
		else if (zuffa <= 0.67)
			self.scale = 1.14;
		else if (zuffa <= 0.84)
			self.scale = 1.07;
		else
			self.scale = 1;
	}
	else if (autocvar_wizard_size > 4)		// if 'wizard_size' is set via autoexec.cfg to a value bigger than '4' give monster the selected fixed size ==>  100% + [value]%  (7% steps due to DP´s .scale restrictions)
	{
		if (autocvar_wizard_size > 40)
			self.origin = self.origin + '0 0 10';		// might get stuck in floor otherwise. --> drop him to floor from higher position !
		self.scale = 1 + (autocvar_wizard_size * 0.01);
		self.sizefactor_x = 0;
		self.sizefactor_y = 0;
		self.sizefactor_z = autocvar_wizard_size * 0.25;
//		setsize (self, '-16 -16 -24' - self.sizefactor, '16 16 40' - self.sizefactor);	// do not do this for this monster, as it flies.
	}
	else
		self.scale = 1;

	setsize (self, '-16 -16 -24', '16 16 40');

var float autocvar_wizard_size_influenced_health = 0; 		  			// set cvar 'wizard_size_influenced_health' default to 0
	if (autocvar_wizard_size_influenced_health == 1)				// if 'wizard_size_influenced_health' is set via autoexec.cfg to '1' raise monster´s health according to its size  (use different formular for monsters with default health <100 and health >100 to be realistic/noticable)
		self.health = autocvar_wizard_health + ((self.scale - 1) * 100);	// default: 80
	else
		self.health = autocvar_wizard_health;				// default 80
	self.health_initial = self.health;

	if (autocvar_monster_random_skin_color_alteration && autocvar_wizard_random_skin_colors)	// modify/edit this monster types skin textures randomly (for higher variation in-game)
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

	self.cansplash = TRUE;
	
	self.th_stand = wiz_stand1;
	self.th_walk = wiz_walk1;
	self.th_run = wiz_run1;
	self.th_missile = Wiz_Missile;
	self.th_pain = Wiz_Pain;
	self.th_die = wiz_die;
	
	self.alpha = autocvar_monstertransparency * 0.01;

	if ((autocvar_reiver_replace_wizard) && (!self.do_not_replace_me))	// if wizard shall be replaced by reiver. Check the chance and do it !!)
	{	
	local float replaceer;		
	replaceer = autocvar_reiver_replace_wizard * 0.01;
	if (random () <= replaceer)
		{
		self.health = autocvar_wizard_health + 40; 	// Reivers are tougher
		self.scale = 1;
		self.nextthink = time + 0.3;	
		self.think = SUB_Remove;
		monster_reiver_start();
		return;
		}
	}

	if ((autocvar_afrit_replace_wizard) && (!self.do_not_replace_me))	// if wizard shall be replaced by afrit. Check the chance and do it !!)
	{	
	local float replacer;		
	replacer = autocvar_afrit_replace_wizard * 0.01;
	if (random () <= replacer)
		{
		self.health = autocvar_wizard_health + 25;	// Afrits are a bit tougher
		self.scale = 1;
		self.nextthink = time + 0.3;	
		self.think = SUB_Remove;
		monster_afrit_start();
		return;
		}
	}
	
	if ((autocvar_necromancer_replace_wizard) && (!self.do_not_replace_me))	// if wizard shall be replaced by necromancer. Check the chance and do it !!)
	{	
	local float replaacer;		
	replaacer = autocvar_necromancer_replace_wizard * 0.01;
	if (random () <= replaacer)
		{
		self.health = autocvar_wizard_health + 30;	// Necromancers are a bit tougher
		self.scale = 1;
		self.nextthink = time + 0.3;	
		self.think = SUB_Remove;
		monster_necromancer_start();
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
		setsize (pain_skin_entity, VEC_HULL2_MIN, VEC_HULL2_MAX);	
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

	flymonster_start ();

do_the_cloning__fly_swim ();

if ((autocvar_reiver_supports_wizard) && (!self.do_not_replace_me))	// if reiver shall be spawned in ADDITION to an existing wizard. Check the chance and do it !!)
	{	
	local float replacee;		
	replacee = autocvar_reiver_supports_wizard * 0.01;
	if (random () <= replacee)
		add_reiver_support_fly ();
	}

if ((autocvar_afrit_supports_wizard) && (!self.do_not_replace_me))	// if afrit shall be spawned in ADDITION to an existing wizard. Check the chance and do it !!)
	{	
	local float replace;		
	replace = autocvar_afrit_supports_wizard * 0.01;
	if (random () <= replace)
		add_afrit_support_fly ();
	}

var float autocvar_wizardmass = 1500;
MonsterPhysics (self, autocvar_wizardmass);	
};





//////////////////////////////////////////////////////////////////////////////////////
//    Code for adding  ADDITIONAL  Wizard monster into a map to support FLYING monsters
//    Wizard will be spawned near the flying monster
//////////////////////////////////////////////////////////////////////////////////////

void() add_wizard_support_fly =
{
   local entity clone, head;
   local float done, c, proceed;
   local vector ang, pos;

   done = 0;
   c = 0;
   ang = self.angles;
   while (done == 0)
      {
      makevectors(ang);
      pos = self.origin + (60 * v_forward) + (crandom() * 33 *v_right) + (crandom() * 30 *v_up);	// randomize the spawn position !!
      head = findradius(pos, 35);
      proceed = 1;
      while (head)
         {
         if ((head.health > 0) && (head.flags & (FL_MONSTER | FL_CLIENT)))
            proceed = 0;
         head = head.chain;
         }
      traceline(self.origin,pos,FALSE,self);
      if (trace_fraction == 1 && (proceed == 1))
         {
         traceline(self.origin,(pos-'40 40 0'),FALSE,self);
         if (trace_fraction == 1)
            {
            traceline(self.origin,(pos+'40 40 0'),FALSE,self);
            if (trace_fraction == 1)
               {
                  done = 1;
               }
            }
         }
      if (done == 0)
         {
         ang_y = ang_y + 36;
         c = c + 1;
         if (c==10)
            {
            return;
            }
         }
      }
      
clone = spawn();
copyentity (self,clone);
setorigin(clone, pos);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_TELEPORT);
	WriteCoord (MSG_BROADCAST, pos_x);
	WriteCoord (MSG_BROADCAST, pos_y);
	WriteCoord (MSG_BROADCAST, pos_z);

clone.enemy = world;
clone.do_not_replace_me = 1;
clone.owner = self;

local vector dir;
dir = normalize (self.enemy.origin - self.origin);
clone.angles = vectoangles (dir * 20);		// always face the enemy
clone.angles_x = 0;				// monsters can only look straight  ( _x is looking up/down)

clone.think = monster_wizard;
clone.nextthink = time + 0.0001;	
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
void(string modelname, float modelframe) vengeance_wizard; 

==============================================================================
*/


void() vengeance_wizard_end1 = {					// end sequence
	self.alpha = -1;
	te_customflash (self.origin, 500, 0.7, '1 0 0');
	self.nextthink = time + 0.2;
      self.think = SUB_Remove;
};


void() vengeance_wizard_touch = {       // player receives 1-3 damage when he gets touched by vengeance effect

	local float ldmg;
	ldmg = rint(0.5 + (3 * random()));  	// chances=  33%: 1 damage /  33%: 2 damage  /  33%: 3 damage

	T_Damage (self.enemy, self, self, ldmg);  	// analog to meele attack dog/fiend
	// T_Damage (other, self, self, ldmg); 		// analog to jump damage dog/fiend

	self.touch = SUB_Null; 			// um nicht endlos damage zu kriegen !

	self.think = vengeance_wizard_end1; 
	self.nextthink = time + 0.1;   
};
	

void() vengeance_wizard_skull =			//  calls skull in skull.qc   
{
	local	vector	offang, org;
	
	offang = vectoangles (self.enemy.origin - self.origin);
	makevectors (offang);
	org = self.origin + self.mins + self.size*0.5 + v_forward * 20;   
	org_z = org_z + 15;   		 // to adjust spawning coordinate of skull. Depending on the monster it spawnes.

	launch_vengeance_skull (org); 	
	newmis.classname = "skull";
	setmodel (newmis, "progs/skull.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);	

	newmis.scale = 0.9;		//  set size of the skull here.  Depending on the monster it spawnes. ;)

	precache_sound ("vengeance/skull.wav");	
	precache_sound ("vengeance/skulltouch.wav");  
};


									//  from here on: run sequence. 

void() vengeance_wizard_fly1 =[	$fly1,	vengeance_wizard_fly2 ]   {
	ai_face();
 	movetogoal (23);  // orig(16)
self.touch = vengeance_wizard_touch;
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_wizard_fly2 =[	$fly2,	vengeance_wizard_fly3 ]   {
	ai_face();
 	movetogoal (23);  // orig(16)
self.touch = vengeance_wizard_touch;
	self.alpha = 0.36;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_wizard_fly3 =[	$fly3,	vengeance_wizard_fly4 ]    {
	ai_face();
 	movetogoal (23);  // orig(16)
self.touch = vengeance_wizard_touch;
	self.alpha = 0.32;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_wizard_fly4 =[	$fly4,	vengeance_wizard_fly5 ]    {
	ai_face();
 	movetogoal (23);  // orig(16)
self.touch = vengeance_wizard_touch;
	self.alpha = 0.28;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_wizard_fly5 =[	$fly5,	vengeance_wizard_fly6 ]    {
	ai_face();
 	movetogoal (23);  // orig(16)
self.touch = vengeance_wizard_touch;
	self.alpha = 0.24;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_wizard_fly6 =[	$fly6,	vengeance_wizard_random ]    {
	ai_face();
 	movetogoal (23);  // orig(16)
self.touch = vengeance_wizard_touch;
	self.alpha = 0.2;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};


									//  from here on: kamikaze sequence. 

void() vengeance_wizard_kamikaze1 =[	$fly7,	vengeance_wizard_kamikaze2 ]   {
	ai_face();
 	movetogoal (25);  // orig(16)
self.touch = vengeance_wizard_touch;
	self.alpha = 0.17;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_wizard_kamikaze2 =[	$fly8,	vengeance_wizard_kamikaze3 ]   {
	ai_face();
 	movetogoal (25);  // orig(16)
self.touch = vengeance_wizard_touch;
	self.alpha = 0.15;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_wizard_kamikaze3 =[	$fly9,	vengeance_wizard_kamikaze4 ]    {
sound (self, CHAN_VOICE, "vengeance/wizattack.wav", 1, 4);		
	ai_face();
 	movetogoal (25);  // orig(16)
self.touch = vengeance_wizard_touch;
	self.alpha = 0.13;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_wizard_kamikaze4 =[	$fly10,	vengeance_wizard_kamikaze5 ]    {
	ai_face();
 	movetogoal (25);  // orig(16)
self.touch = vengeance_wizard_touch;
	self.alpha = 0.11;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_wizard_kamikaze5 =[	$fly11,	vengeance_wizard_end1 ]    {
	ai_face();
 	movetogoal (25);  // orig(16)
self.touch = vengeance_wizard_touch;
	makevectors (self.angles);
	self.origin_z = self.origin_z + 1;
	self.velocity = v_forward * 170 + '0 0 10';
	self.alpha = 0.07;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};

									//  from here on: attack/jump sequenz. 

void() vengeance_wizard_skull1 =[ $magatt4,	vengeance_wizard_skull2 ]    {
	ai_face();
self.touch = vengeance_wizard_touch;
	self.alpha = 0.2;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_wizard_skull2 =[ $magatt5,	vengeance_wizard_skull3 ]    {
	ai_face();
self.touch = vengeance_wizard_touch;
	self.alpha = 0.2;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_wizard_skull3 =[ $magatt6,	vengeance_wizard_skull4 ]    {
	ai_face();
self.touch = vengeance_wizard_touch;
	self.alpha = 0.2;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_wizard_skull4 =[ $magatt7,	vengeance_wizard_skull5 ]    {
	ai_face();
self.touch = vengeance_wizard_touch;
	self.alpha = 0.2;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_wizard_skull5 =[ $magatt8,	vengeance_wizard_skull6 ]    {
	ai_face();
self.touch = vengeance_wizard_touch;
	self.alpha = 0.2;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_wizard_skull6 =[ $magatt9,	vengeance_wizard_skull7 ]    {
sound (self, CHAN_VOICE, "wizard/wpain.wav", 1, 4);	
	ai_face();
self.touch = vengeance_wizard_touch;
	self.alpha = 0.2;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_wizard_skull7 =[ $magatt9,	vengeance_wizard_end1 ]    {
	ai_face();
self.touch = vengeance_wizard_touch;
	self.alpha = 0.15;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
vengeance_wizard_skull();   		
};



void()	vengeance_wizard_random 	= {		// random final animation selection
	self.alpha = 0.2;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.01;
		if (random() > 0.5)
			self.think = vengeance_wizard_skull1; 
		else
			self.think = vengeance_wizard_kamikaze1;
};



											//  from here on: ressurection sequenz. 

void() vengeance_wizard1 =[	$death7,	vengeance_wizard2 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_wizard2 =[	$death6,	vengeance_wizard3 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_wizard3 =[	$death5,	vengeance_wizard4 	]  {
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_wizard4 =[	$death4,	vengeance_wizard5 	]  {
self.origin_z = self.origin_z + 2;
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_wizard5 =[	$death3,	vengeance_wizard6 	]  {
self.origin_z = self.origin_z + 5;
sound (self, CHAN_WEAPON, "wizard/wsight.wav", 1, 4);
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_wizard6 =[	$death2,	vengeance_wizard7 	]  {
self.origin_z = self.origin_z + 8;
self.flags = self.flags - FL_ONGROUND;
self.flags = self.flags | FL_FLY;
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};
void() vengeance_wizard7 =[	$death1,	vengeance_wizard_fly1 ]  {
self.origin_z = self.origin_z + 11;
	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 600;
	self.nextthink = time + 0.1;
};



								// from here on:  sequence where the corpse overbrights 
void()	vengeance_wizard_bright05	= {
	self.alpha = 0.3;
	self.colormod = '6 1 1';
	self.glow_color = 75;
	self.glow_size = 450;
	self.nextthink = time + 0.1;
	self.think = vengeance_wizard1;
};
void()	vengeance_wizard_bright04 	= {
	self.alpha = 0.3;
	self.colormod = '5 1 1';
	self.glow_color = 75;
	self.glow_size = 350;
	self.nextthink = time + 0.1;
	self.think = vengeance_wizard_bright05;
};
void()	vengeance_wizard_bright03 	= {
	self.alpha = 0.3;
	self.colormod = '4 1 1';
	self.glow_color = 75;
	self.glow_size = 270;
	self.nextthink = time + 0.1;
	self.think = vengeance_wizard_bright04;
};
void()	vengeance_wizard_bright02 	= {
	self.alpha = 0.3;
	self.colormod = '3 1 1';
	self.glow_color = 75;
	self.glow_size = 185;
	self.nextthink = time + 0.1;
	self.think = vengeance_wizard_bright03;
}; 
void()	vengeance_wizard_bright01	= {
	self.alpha = 0.3;
	self.colormod = '2 1 1';
	self.glow_color = 75;
	self.glow_size = 100;
	self.nextthink = time + 0.1;
	self.think = vengeance_wizard_bright02;
};
void()	vengeance_wizard_bright00 	= {  		
	self.alpha = 0.3;
	self.glow_color = 75;
	self.glow_size = 10;
	self.nextthink = time + 0.1;
	self.think = vengeance_wizard_bright01;
};



void(string modelname, float modelframe) vengeance_wizard =
{

local vector v;  			// v  was necessary at the begining of effect development, but isnt anymore now.
v_x = (self.origin_x);
v_y = (self.origin_y);
v_z = (self.origin_z);

	precache_sound ("vengeance/wizattack.wav");
	precache_model ("progs/skull.mdl");

      	self.origin = v; 
   	self.touch = SUB_Null;                
	self.movetype = MOVETYPE_FLY;

	if (self.monstermodel == 0)  
		setmodel (self, "progs/wizard.mdl"); 
	else if (self.monstermodel == 1)  
		setmodel (self, "progs/wizard1.mdl"); 

	setsize (self, '-16 -16 -24', '16 16 40');
	self.frame = modelframe;	 // modelframe is depending on the individual monster (included in vengeance call)

	var float autocvar_vengeancedamage = 0;   // set cvar 'vengeancedamage' default to 0
	if (autocvar_vengeancedamage == 0)	  	// if 'vengeancedamage' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '0'
		self.solid = SOLID_NOT;			// vengeance effect is NOT solid and cannot hurt the player
	else
		self.solid = SOLID_SLIDEBOX;    	  	// if value is NOT "0", player get hurt from this effect (see func "vengeance_wizard_touch")!

	vengeance_wizard_bright00 ();	 			// starts the animation
};

