/*
==============================================================================

ZOMBIE

ADDED by Seven:
A new zombie monster model can be used (adjustable via cvar 'zombie_use_newmodel' in smc_config.cfg)
Sets the chance of spawning new zombie monster model (0= never.  100= always). Choose any value you want between 0 and 100
Examples:
"0" = disabled (dont use new zombie model)
"50" = Use original and new zombie equally (50% / 50%).  You play against both zombie types in-game.
"100" = Only use the NEW zombie model 

New zombie model has 3 new possible properties (adjustable via cvar 'zombienewmodelproperties')
"0" = exactly the same properties like original zombie
"1" = Can be killed with Axe or Explosives (with 2 new death animations: cut-off head or regular death without gibs)
"2" = Can ONLY be killed with Axe (with new death animation: cut-off head)

New Axe visual when aiming at new zombie model which are killable with Axe !  (adjustable via cvar 'zombieaxeanimation')
"0" = disabled
"1" = enabled ( -> when aiming at new zombies, the axe´s Quake symbol glows as well as a mystical glow around player appears

New projectiles for new zombies  (adjustable via cvar 'zombienewmodelprojectile')
"0" = new zombie uses standard projectile (like original)
"1" = new zombie uses a different projectile

New zombie corpses can be burned and a mystical pentagram appears   (adjustable via cvar 'zombienewmodelburnable')
"0" = disabled
"1" = enabled  ( -> when shooting new zombie corpses, they start to burn and a mystical pickable pentagram appears)

==============================================================================
*/
$cd id1/models/zombie

$origin	0 0 24

$base base
$skin skin

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8
$frame stand9 stand10 stand11 stand12 stand13 stand14 stand15

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10 walk11
$frame walk12 walk13 walk14 walk15 walk16 walk17 walk18 walk19

$frame run1 run2 run3 run4 run5 run6 run7 run8 run9 run10 run11 run12
$frame run13 run14 run15 run16 run17 run18

$frame atta1 atta2 atta3 atta4 atta5 atta6 atta7 atta8 atta9 atta10 atta11
$frame atta12 atta13

$frame attb1 attb2 attb3 attb4 attb5 attb6 attb7 attb8 attb9 attb10 attb11
$frame attb12 attb13 attb14

$frame attc1 attc2 attc3 attc4 attc5 attc6 attc7 attc8 attc9 attc10 attc11
$frame attc12

$frame paina1 paina2 paina3 paina4 paina5 paina6 paina7 paina8 paina9 paina10
$frame paina11 paina12

$frame painb1 painb2 painb3 painb4 painb5 painb6 painb7 painb8 painb9 painb10
$frame painb11 painb12 painb13 painb14 painb15 painb16 painb17 painb18 painb19
$frame painb20 painb21 painb22 painb23 painb24 painb25 painb26 painb27 painb28

$frame painc1 painc2 painc3 painc4 painc5 painc6 painc7 painc8 painc9 painc10
$frame painc11 painc12 painc13 painc14 painc15 painc16 painc17 painc18

$frame paind1 paind2 paind3 paind4 paind5 paind6 paind7 paind8 paind9 paind10
$frame paind11 paind12 paind13

$frame paine1 paine2 paine3 paine4 paine5 paine6 paine7 paine8 paine9 paine10
$frame paine11 paine12 paine13 paine14 paine15 paine16 paine17 paine18 paine19
$frame paine20 paine21 paine22 paine23 paine24 paine25 paine26 paine27 paine28
$frame paine29 paine30

$frame cruc_1 cruc_2 cruc_3 cruc_4 cruc_5 cruc_6

// only for new zombie model:
$frame deatha1 deatha2 deatha3 deatha4 deatha5 deatha6 deatha7 deatha8 deatha9 deatha10
$frame deatha11 deatha12 deatha13 deatha14 deatha15 deatha16 deatha17 deatha18 deatha19
$frame deatha20 deatha21 deatha22 deatha23 deatha24 deatha25 deatha26

$frame deathb1 deathb2 deathb3 deathb4 deathb5 deathb6 deathb7 deathb8 deathb9 deathb10
$frame deathb11 deathb12 deathb13 deathb14 deathb15 deathb16 deathb17 deathb18 deathb19
$frame deathb20 deathb21 

float	SPAWN_CRUCIFIED	= 1;
//HIPNOTIC
float SPAWN_LYINGDOWN   = 4;

//=============================================================================

.float inpain;

void(float loudness, float velo) zombie_footsteps =
{
if (autocvar_monsterfootsteps == 1)	// only play monster footsteps sound when cvar is 1
	{
	local float select;
	select = random();
	if (velo == 1)		// run
		{
		if (select <= 0.5)
			sound7(self, CHAN_AUTO, "walk/zombierun1.wav", loudness, ATTN_IDLE, SNDSPD);
		else 
			sound7(self, CHAN_AUTO, "walk/zombierun2.wav", loudness, ATTN_IDLE, SNDSPD);
		}
	else			// walk
		{
		if (select <= 0.5)
			sound7(self, CHAN_AUTO, "walk/zombiewalk1.wav", loudness, ATTN_IDLE, SNDSPD);
		else 
			sound7(self, CHAN_AUTO, "walk/zombiewalk2.wav", loudness, ATTN_IDLE, SNDSPD);
		}
	}
};


void() zombie_stand1	=[	$stand1,		zombie_stand2	] {ai_stand();};
void() zombie_stand2	=[	$stand2,		zombie_stand3	] {ai_stand();};
void() zombie_stand3	=[	$stand3,		zombie_stand4	] {ai_stand();};
void() zombie_stand4	=[	$stand4,		zombie_stand5	] {ai_stand();};
void() zombie_stand5	=[	$stand5,		zombie_stand6	] {ai_stand();};
void() zombie_stand6	=[	$stand6,		zombie_stand7	] {ai_stand();};
void() zombie_stand7	=[	$stand7,		zombie_stand8	] {ai_stand();};
void() zombie_stand8	=[	$stand8,		zombie_stand9	] {ai_stand();};
void() zombie_stand9	=[	$stand9,		zombie_stand10	] {ai_stand();};
void() zombie_stand10	=[	$stand10,		zombie_stand11	] {ai_stand();};
void() zombie_stand11	=[	$stand11,		zombie_stand12	] {ai_stand();};
void() zombie_stand12	=[	$stand12,		zombie_stand13	] {ai_stand();};
void() zombie_stand13	=[	$stand13,		zombie_stand14	] {ai_stand();};
void() zombie_stand14	=[	$stand14,		zombie_stand15	] {ai_stand();};
void() zombie_stand15	=[	$stand15,		zombie_stand1	] {ai_stand();};

void() zombie_cruc1	=	[	$cruc_1,		zombie_cruc2	] {
if (random() < 0.1)
	sound7 (self, CHAN_VOICE, "zombie/idle_w2.wav", 1, ATTN_STATIC);};
void() zombie_cruc2	=	[	$cruc_2,		zombie_cruc3	] {self.nextthink = time + 0.1 + random()*0.1;};
void() zombie_cruc3	=	[	$cruc_3,		zombie_cruc4	] {self.nextthink = time + 0.1 + random()*0.1;};
void() zombie_cruc4	=	[	$cruc_4,		zombie_cruc5	] {self.nextthink = time + 0.1 + random()*0.1;};
void() zombie_cruc5	=	[	$cruc_5,		zombie_cruc6	] {self.nextthink = time + 0.1 + random()*0.1;};
void() zombie_cruc6	=	[	$cruc_6,		zombie_cruc1	] {self.nextthink = time + 0.1 + random()*0.1;};

void() zombie_walk1	=[	$walk1,		zombie_walk2	] {ai_walk(0);};
void() zombie_walk2	=[	$walk2,		zombie_walk3	] {ai_walk(2); zombie_footsteps (0.6 , 2);};
void() zombie_walk3	=[	$walk3,		zombie_walk4	] {ai_walk(3);};
void() zombie_walk4	=[	$walk4,		zombie_walk5	] {ai_walk(2);};
void() zombie_walk5	=[	$walk5,		zombie_walk6	] {ai_walk(1);};
void() zombie_walk6	=[	$walk6,		zombie_walk7	] {ai_walk(0);};
void() zombie_walk7	=[	$walk7,		zombie_walk8	] {ai_walk(0);};
void() zombie_walk8	=[	$walk8,		zombie_walk9	] {ai_walk(0);};
void() zombie_walk9	=[	$walk9,		zombie_walk10	] {ai_walk(0);
if (self.monstermodel == 2)		// only new zombie monster model has a footstep here
	zombie_footsteps (0.6 , 2);};
void() zombie_walk10	=[	$walk10,	zombie_walk11	] {ai_walk(0);};
void() zombie_walk11	=[	$walk11,	zombie_walk12	] {ai_walk(2);
if (self.monstermodel < 2)		// only original ID1 zombie monster model has a footstep here
	zombie_footsteps (0.6 , 2);};
void() zombie_walk12	=[	$walk12,	zombie_walk13	] {ai_walk(2);};
void() zombie_walk13	=[	$walk13,	zombie_walk14	] {ai_walk(1);};
void() zombie_walk14	=[	$walk14,	zombie_walk15	] {ai_walk(0);};
void() zombie_walk15	=[	$walk15,	zombie_walk16	] {ai_walk(0);};
void() zombie_walk16	=[	$walk16,	zombie_walk17	] {ai_walk(0);};
void() zombie_walk17	=[	$walk17,	zombie_walk18	] {ai_walk(0);};
void() zombie_walk18	=[	$walk18,	zombie_walk19	] {ai_walk(0);};
void() zombie_walk19	=[	$walk19,	zombie_walk1	] {
ai_walk(0);
if (random() < 0.2)
	sound7 (self, CHAN_VOICE, "zombie/z_idle.wav", 1, ATTN_IDLE, SNDSPD);};

void() zombie_run1		=[	$run1,		zombie_run2	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(1);self.inpain = 0;};
void() zombie_run2		=[	$run2,		zombie_run3	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(1);};
void() zombie_run3		=[	$run3,		zombie_run4	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(0);};
void() zombie_run4		=[	$run4,		zombie_run5	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(1);};
void() zombie_run5		=[	$run5,		zombie_run6	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(2);};
void() zombie_run6		=[	$run6,		zombie_run7	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(3);};
void() zombie_run7		=[	$run7,		zombie_run8	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(4);};
void() zombie_run8		=[	$run8,		zombie_run9	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(4);};
void() zombie_run9		=[	$run9,		zombie_run10	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(2); zombie_footsteps (1 , 1);};
void() zombie_run10		=[	$run10,		zombie_run11	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(0);};
void() zombie_run11		=[	$run11,		zombie_run12	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(0);};
void() zombie_run12		=[	$run12,		zombie_run13	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(0);};
void() zombie_run13		=[	$run13,		zombie_run14	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(2);};
void() zombie_run14		=[	$run14,		zombie_run15	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(4);};
void() zombie_run15		=[	$run15,		zombie_run16	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(6);};
void() zombie_run16		=[	$run16,		zombie_run17	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(7);};
void() zombie_run17		=[	$run17,		zombie_run18	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);ai_run(3); zombie_footsteps (1 , 1);};
void() zombie_run18		=[	$run18,		zombie_run1	] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);
ai_run(8);
if (random() < 0.2)
	sound7 (self, CHAN_VOICE, "zombie/z_idle.wav", 1, ATTN_IDLE, SNDSPD);
if (random() > 0.8)
	sound7 (self, CHAN_VOICE, "zombie/z_idle1.wav", 1, ATTN_IDLE, SNDSPD);
};

/*
=============================================================================

ATTACKS

=============================================================================
*/

void() ZombieGrenadeTouch =
{
	if (other == self.owner)
		return;		// don't explode on owner
	if (other.takedamage)
	{
		var float autocvar_zombie_size_influenced_attack = 0; 					// set cvar 'zombie_size_influenced_attack' default to 0
		if (autocvar_zombie_size_influenced_attack == 1)					// if 'zombie_size_influenced_attack' is set via autoexec.cfg to '1' raise monster´s attack values according to its size 
			T_Damage (other, self, self.owner, autocvar_zombie_flesh * self.owner.scale);	// default 10
		else
			T_Damage (other, self, self.owner, autocvar_zombie_flesh);		// default 10
		sound7 (self, CHAN_WEAPON, "zombie/z_hit.wav", 1, ATTN_NORM);
		remove (self);
		return;
	}
	sound7 (self, CHAN_WEAPON, "zombie/z_miss.wav", 1, ATTN_NORM, SNDSPD);	// bounce sound
	self.velocity = '0 0 0';
	self.avelocity = '0 0 0';
	self.touch = SUB_Remove;
};

/*
================
ZombieFireGrenade
================
*/
void(vector st) ZombieFireGrenade =
{
	local vector distancedelta; 
	local vector nozdistancedelta; 
	local	entity missile;
	local	vector	org;

	sound7 (self, CHAN_WEAPON, "zombie/z_shot1.wav", 1, ATTN_NORM, SNDSPD);

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;

// calc org
	org = self.origin + st_x * v_forward + st_y * v_right + (st_z - 24) * v_up;
	
// set missile speed	

	makevectors (self.angles);
	
	var float autocvar_zombieaim = 0;
	if ( autocvar_zombieaim == 0 )
	{
	missile.velocity = normalize(self.enemy.origin - org);
	missile.velocity = missile.velocity * 600;
	missile.velocity_z = 200;
	}
	else
	{
	distancedelta = self.enemy.origin - org; //work out distance vector  
	nozdistancedelta = distancedelta;  //copy to no height distance vector 
	
	nozdistancedelta_z = 0;  //remove height 
	
	missile.velocity = normalize(distancedelta); //set the velocity to the distance
	missile.velocity = missile.velocity * 600;   //give it more power 
	
      //missile.velocity_z = missile.velocity_z + vlen(nozdistancedelta)*0.7; 
	missile.velocity_z = missile.velocity_z + 175 + 50*random();
	} 
	missile.avelocity = '3000 1000 2000';

	missile.touch = ZombieGrenadeTouch;
	
// set missile duration
	missile.nextthink = time + 2.5;
	missile.think = SUB_Remove;

if (autocvar_zombienewmodelprojectile == 1)	// if 'zombienewmodelprojectile' is '1' 
{
	if (self.monstermodel == 2)		// new zombie monster model uses a different projectile
		{
		setmodel (missile, "progs/zombie_new_projectile.mdl");
		missile.traileffectnum = particleeffectnum("zombie_new_projectile"); 
		missile.scale = 2.5;
		missile.avelocity = '1000 1000 1000';
		}
	else
		setmodel (missile, "progs/zom_gib.mdl");
}
else
	setmodel (missile, "progs/zom_gib.mdl");
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, org);
};


void() zombie_atta1	=[	$atta1,		zombie_atta2	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void() zombie_atta2	=[	$atta2,		zombie_atta3	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void() zombie_atta3	=[	$atta3,		zombie_atta4	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void() zombie_atta4	=[	$atta4,		zombie_atta5	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void() zombie_atta5	=[	$atta5,		zombie_atta6	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();
if (self.monstermodel == 2)		// only new zombie monster model fire grenade here
	ZombieFireGrenade('-2 -8 32');
};
void() zombie_atta6	=[	$atta6,		zombie_atta7	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void() zombie_atta7	=[	$atta7,		zombie_atta8	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void() zombie_atta8	=[	$atta8,		zombie_atta9	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void() zombie_atta9	=[	$atta9,		zombie_atta10	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void() zombie_atta10	=[	$atta10,	zombie_atta11	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void() zombie_atta11	=[	$atta11,	zombie_atta12	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void() zombie_atta12	=[	$atta12,	zombie_atta13	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void() zombie_atta13	=[	$atta13,	zombie_run1	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();
if (self.monstermodel < 2)		// only original ID1 zombie monster model fire grenade here
	ZombieFireGrenade('-10 -22 30');
};

void() zombie_attb1	=[	$attb1,		zombie_attb2	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void() zombie_attb2	=[	$attb2,		zombie_attb3	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void() zombie_attb3	=[	$attb3,		zombie_attb4	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void() zombie_attb4	=[	$attb4,		zombie_attb5	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void() zombie_attb5	=[	$attb5,		zombie_attb6	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();
if (self.monstermodel == 2)		// only new zombie monster model fire grenade here
	ZombieFireGrenade('-7 -11 25');
};
void() zombie_attb6	=[	$attb6,		zombie_attb7	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void() zombie_attb7	=[	$attb7,		zombie_attb8	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void() zombie_attb8	=[	$attb8,		zombie_attb9	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void() zombie_attb9	=[	$attb9,		zombie_attb10	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void() zombie_attb10	=[	$attb10,	zombie_attb11	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void() zombie_attb11	=[	$attb11,	zombie_attb12	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void() zombie_attb12	=[	$attb12,	zombie_attb13	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void() zombie_attb13	=[	$attb13,	zombie_attb14	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void() zombie_attb14	=[	$attb13,	zombie_run1	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();
if (self.monstermodel < 2)		// only original ID1 zombie monster model fire grenade here
	ZombieFireGrenade('-10 9 30');	// was ('-10 -24 29');  That caused the flesh-grenade to spawn on wrong side
};

void() zombie_attc1	=[	$attc1,		zombie_attc2	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void() zombie_attc2	=[	$attc2,		zombie_attc3	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void() zombie_attc3	=[	$attc3,		zombie_attc4	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void() zombie_attc4	=[	$attc4,		zombie_attc5	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void() zombie_attc5	=[	$attc5,		zombie_attc6	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();
if (self.monstermodel == 2)		// only new zombie monster model fire grenade here
	ZombieFireGrenade('-2 -8 32');
};
void() zombie_attc6	=[	$attc6,		zombie_attc7	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void() zombie_attc7	=[	$attc7,		zombie_attc8	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void() zombie_attc8	=[	$attc8,		zombie_attc9	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void() zombie_attc9	=[	$attc9,		zombie_attc10	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void() zombie_attc10	=[	$attc10,	zombie_attc11	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void() zombie_attc11	=[	$attc11,	zombie_attc12	] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();};
void() zombie_attc12	=[	$attc12,	zombie_run1		] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);ai_face();
if (self.monstermodel < 2)		// only original ID1 zombie monster model fire grenade here
	ZombieFireGrenade('-12 -19 29');
};


void() zombie_missile =
{
	local float	r;
	
	r = random();

	if (self.monstermodel == 2)	// new zombie model uses different animations and therefore needs to adjust randomness	
	{
			if (r < 0.3)
				zombie_atta1 ();
			else if (r < 0.77)
				zombie_attb1 ();
			else
				zombie_attc1 ();	// similar to atta1() for new zombie
	}
	else
	{
		if (self.model != "progs/zombie_noarms.mdl" && self.model != "progs/zombie1_noarms.mdl")
		{
			if (r < 0.3)
				zombie_atta1 ();
			else if (r < 0.6)
				zombie_attb1 ();
			else
				zombie_attc1 ();
		}
	}
};


/*
=============================================================================

PAIN

=============================================================================
*/

void() zombie_paina1	=[	$paina1,	zombie_paina2	] {sound7 (self, CHAN_VOICE, "zombie/z_pain.wav", 1, ATTN_NORM, SNDSPD);};
void() zombie_paina2	=[	$paina2,	zombie_paina3	] {ai_painforward(3);};
void() zombie_paina3	=[	$paina3,	zombie_paina4	] {ai_painforward(1);};
void() zombie_paina4	=[	$paina4,	zombie_paina5	] {ai_pain(1);};
void() zombie_paina5	=[	$paina5,	zombie_paina6	] {ai_pain(3);};
void() zombie_paina6	=[	$paina6,	zombie_paina7	] {ai_pain(1);};
void() zombie_paina7	=[	$paina7,	zombie_paina8	] {};
void() zombie_paina8	=[	$paina8,	zombie_paina9	] {};
void() zombie_paina9	=[	$paina9,	zombie_paina10	] {};
void() zombie_paina10	=[	$paina10,	zombie_paina11	] {};
void() zombie_paina11	=[	$paina11,	zombie_paina12	] {};
void() zombie_paina12	=[	$paina12,	zombie_run1		] {};

void() zombie_painb1	=[	$painb1,	zombie_painb2	] {sound7 (self, CHAN_VOICE, "zombie/z_pain1.wav", 1, ATTN_NORM, SNDSPD);};
void() zombie_painb2	=[	$painb2,	zombie_painb3	] {ai_pain(2);
	local vector check;
	check = (self.origin - ((VEC_HULL2_MIN + VEC_HULL2_MAX) * 0.5)) + '0 0 1';
	var float autocvar_zombieflies = 2;	    	// set cvar 'zombieflies' default to 2
		if ((autocvar_zombieflies == 1 ) && (pointcontents(check) != CONTENT_WATER)&&(pointcontents(check) != CONTENT_SLIME)&&(pointcontents(check) != CONTENT_LAVA))
			self.traileffectnum = particleeffectnum("zombiedownfliesblack");
		if ((autocvar_zombieflies == 2 ) && (pointcontents(check) != CONTENT_WATER)&&(pointcontents(check) != CONTENT_SLIME)&&(pointcontents(check) != CONTENT_LAVA))
			self.traileffectnum = particleeffectnum("zombiedownfliesbrown");
};
void() zombie_painb3	=[	$painb3,	zombie_painb4	] {ai_pain(8);};
void() zombie_painb4	=[	$painb4,	zombie_painb5	] {ai_pain(6);};
void() zombie_painb5	=[	$painb5,	zombie_painb6	] {ai_pain(2);};
void() zombie_painb6	=[	$painb6,	zombie_painb7	] {};
void() zombie_painb7	=[	$painb7,	zombie_painb8	] {};
void() zombie_painb8	=[	$painb8,	zombie_painb9	] {};
void() zombie_painb9	=[	$painb9,	zombie_painb10	] {sound7 (self, CHAN_BODY, "zombie/z_fall.wav", 1, ATTN_NORM, SNDSPD);};
void() zombie_painb10	=[	$painb10,	zombie_painb11	] {};
void() zombie_painb11	=[	$painb11,	zombie_painb12	] {};
void() zombie_painb12	=[	$painb12,	zombie_painb13	] {};
void() zombie_painb13	=[	$painb13,	zombie_painb14	] {};
void() zombie_painb14	=[	$painb14,	zombie_painb15	] {};
void() zombie_painb15	=[	$painb15,	zombie_painb16	] {};
void() zombie_painb16	=[	$painb16,	zombie_painb17	] {};
void() zombie_painb17	=[	$painb17,	zombie_painb18	] {};
void() zombie_painb18	=[	$painb18,	zombie_painb19	] {};
void() zombie_painb19	=[	$painb19,	zombie_painb20	] {};
void() zombie_painb20	=[	$painb20,	zombie_painb21	] {};
void() zombie_painb21	=[	$painb21,	zombie_painb22	] {};
void() zombie_painb22	=[	$painb22,	zombie_painb23	] {};
void() zombie_painb23	=[	$painb23,	zombie_painb24	] {};
void() zombie_painb24	=[	$painb24,	zombie_painb25	] {};
void() zombie_painb25	=[	$painb25,	zombie_painb26	] {ai_painforward(1);};
void() zombie_painb26	=[	$painb26,	zombie_painb27	] {};
void() zombie_painb27	=[	$painb27,	zombie_painb28	] {};
void() zombie_painb28	=[	$painb28,	zombie_run1		] {};

void() zombie_painc1	=[	$painc1,	zombie_painc2	] {sound7 (self, CHAN_VOICE, "zombie/z_pain1.wav", 1, ATTN_NORM, SNDSPD);};
void() zombie_painc2	=[	$painc2,	zombie_painc3	] {};
void() zombie_painc3	=[	$painc3,	zombie_painc4	] {ai_pain(3);};
void() zombie_painc4	=[	$painc4,	zombie_painc5	] {ai_pain(1);};
void() zombie_painc5	=[	$painc5,	zombie_painc6	] {};
void() zombie_painc6	=[	$painc6,	zombie_painc7	] {};
void() zombie_painc7	=[	$painc7,	zombie_painc8	] {};
void() zombie_painc8	=[	$painc8,	zombie_painc9	] {};
void() zombie_painc9	=[	$painc9,	zombie_painc10	] {};
void() zombie_painc10	=[	$painc10,	zombie_painc11	] {};
void() zombie_painc11	=[	$painc11,	zombie_painc12	] {ai_painforward(1);};
void() zombie_painc12	=[	$painc12,	zombie_painc13	] {ai_painforward(1);};
void() zombie_painc13	=[	$painc13,	zombie_painc14	] {};
void() zombie_painc14	=[	$painc14,	zombie_painc15	] {};
void() zombie_painc15	=[	$painc15,	zombie_painc16	] {};
void() zombie_painc16	=[	$painc16,	zombie_painc17	] {};
void() zombie_painc17	=[	$painc17,	zombie_painc18	] {};
void() zombie_painc18	=[	$painc18,	zombie_run1	] {};

void() zombie_paind1	=[	$paind1,	zombie_paind2	] {sound7 (self, CHAN_VOICE, "zombie/z_pain.wav", 1, ATTN_NORM, SNDSPD);};
void() zombie_paind2	=[	$paind2,	zombie_paind3	] {};
void() zombie_paind3	=[	$paind3,	zombie_paind4	] {};
void() zombie_paind4	=[	$paind4,	zombie_paind5	] {};
void() zombie_paind5	=[	$paind5,	zombie_paind6	] {};
void() zombie_paind6	=[	$paind6,	zombie_paind7	] {};
void() zombie_paind7	=[	$paind7,	zombie_paind8	] {};
void() zombie_paind8	=[	$paind8,	zombie_paind9	] {};
void() zombie_paind9	=[	$paind9,	zombie_paind10	] {ai_pain(1);};
void() zombie_paind10	=[	$paind10,	zombie_paind11	] {};
void() zombie_paind11	=[	$paind11,	zombie_paind12	] {};
void() zombie_paind12	=[	$paind12,	zombie_paind13	] {};
void() zombie_paind13	=[	$paind13,	zombie_run1	] {};

void() zombie_paine1	=[	$paine1,	zombie_paine2	] {
sound7 (self, CHAN_VOICE, "zombie/z_pain.wav", 1, ATTN_NORM, SNDSPD);
if (autocvar_zombienewmodelproperties >= 2)	// new zombie model is only killable with Axe
	{
	if (self.monstermodel == 2)
		self.health = 490;
	else
		self.health = 60;
	}
else
	self.health = 60;
};
void() zombie_paine2	=[	$paine2,	zombie_paine3	] {ai_pain(8);};
void() zombie_paine3	=[	$paine3,	zombie_paine4	] {ai_pain(5);
	local vector check;
	check = (self.origin - ((VEC_HULL2_MIN + VEC_HULL2_MAX) * 0.5)) + '0 0 1';
	var float autocvar_zombieflies = 2;	    	// set cvar 'zombieflies' default to 2
		if ((autocvar_zombieflies == 1 ) && (pointcontents(check) != CONTENT_WATER)&&(pointcontents(check) != CONTENT_SLIME)&&(pointcontents(check) != CONTENT_LAVA))
			self.traileffectnum = particleeffectnum("zombiedownfliesblack");
		if ((autocvar_zombieflies == 2 ) && (pointcontents(check) != CONTENT_WATER)&&(pointcontents(check) != CONTENT_SLIME)&&(pointcontents(check) != CONTENT_LAVA))
			self.traileffectnum = particleeffectnum("zombiedownfliesbrown");
};
void() zombie_paine4	=[	$paine4,	zombie_paine5	] {ai_pain(3);};
void() zombie_paine5	=[	$paine5,	zombie_paine6	] {ai_pain(1);};
void() zombie_paine6	=[	$paine6,	zombie_paine7	] {ai_pain(2);};
void() zombie_paine7	=[	$paine7,	zombie_paine8	] {ai_pain(1);};
void() zombie_paine8	=[	$paine8,	zombie_paine9	] {ai_pain(1);};
void() zombie_paine9	=[	$paine9,	zombie_paine10	] {ai_pain(2);};
void() zombie_paine10	=[	$paine10,	zombie_paine11	] {
sound7 (self, CHAN_BODY, "zombie/z_fall.wav", 1, ATTN_NORM, SNDSPD);
self.solid = SOLID_NOT;
};
void() zombie_paine11	=[	$paine11,	zombie_paine12	] {self.nextthink = self.nextthink + 5;
if (autocvar_zombienewmodelproperties >= 2)	// new zombie model is only killable with Axe
	{
	if (self.monstermodel == 2)
		self.health = 490;
	else
		self.health = 60;
	}
else
	self.health = 60;
};
void() zombie_paine12	=[	$paine12,	zombie_paine13	]{
// see if ok to stand up
if (autocvar_zombienewmodelproperties >= 2)	// new zombie model is only killable with Axe
	{
	if (self.monstermodel == 2)
		self.health = 490;
	else
		self.health = 60;
	}
else
	self.health = 60;
sound7 (self, CHAN_VOICE, "zombie/z_idle.wav", 1, ATTN_IDLE, SNDSPD);
self.solid = SOLID_SLIDEBOX;
if (!walkmove (0, 0))
{
	self.think = zombie_paine11;
	self.solid = SOLID_NOT;
	return;
}
};
void() zombie_paine13	=[	$paine13,	zombie_paine14	] {};
void() zombie_paine14	=[	$paine14,	zombie_paine15	] {};
void() zombie_paine15	=[	$paine15,	zombie_paine16	] {};
void() zombie_paine16	=[	$paine16,	zombie_paine17	] {};
void() zombie_paine17	=[	$paine17,	zombie_paine18	] {};
void() zombie_paine18	=[	$paine18,	zombie_paine19	] {};
void() zombie_paine19	=[	$paine19,	zombie_paine20	] {};
void() zombie_paine20	=[	$paine20,	zombie_paine21	] {};
void() zombie_paine21	=[	$paine21,	zombie_paine22	] {};
void() zombie_paine22	=[	$paine22,	zombie_paine23	] {};
void() zombie_paine23	=[	$paine23,	zombie_paine24	] {};
void() zombie_paine24	=[	$paine24,	zombie_paine25	] {};
void() zombie_paine25	=[	$paine25,	zombie_paine26	] {ai_painforward(5);};
void() zombie_paine26	=[	$paine26,	zombie_paine27	] {ai_painforward(3);};
void() zombie_paine27	=[	$paine27,	zombie_paine28	] {ai_painforward(1);};
void() zombie_paine28	=[	$paine28,	zombie_paine29	] {ai_pain(1);};
void() zombie_paine29	=[	$paine29,	zombie_paine30	] {};
void() zombie_paine30	=[	$paine30,	zombie_run1	] {};


void() zombie_head_anim =		// makes a nice 10 frame roll/spin animation  :-)
{
	self.frame = self.frame + 1;
	if (self.frame >= 10)
	{
		var float autocvar_kickgibs = 1;	// set cvar 'kickgibs' default to 1
		if (autocvar_kickgibs == 1)		// if 'kickgibs' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
			kick_touch2_temp ();		// Call kick_touch2_temp
		else 					// if 'kickgibs' is set via autoexec.cfg to any other value
			kick_touch3_temp ();		// Call kick_touch3_temp
		return;
	}
	self.nextthink = time + 0.1;
	self.think = zombie_head_anim;
};


void() zombie_head =
{
	local	entity 	zombiehead;
	local	vector face1, face2, org;

	zombiehead = spawn();

	face1 = vectoangles (self.enemy.origin - self.origin);
	makevectors (face1);
	face2 = normalize (v_forward);
	zombiehead.angles = vectoangles(face2);    // to set the correct head angle (face the player)
	
	org = self.origin + v_right * 2 + v_up * 20 + v_forward * -10;	
	setorigin (zombiehead, org);

	setmodel (zombiehead, "progs/h_zombie_new.mdl");
	setsize (zombiehead, '0 0 0', '0 0 0');			//  temporary remove bbox to not hang in walls (in new DP builds)
	zombiehead.skin = self.skin;	
	zombiehead.scale = 1.07;	
	zombiehead.movetype = MOVETYPE_BOUNCE;
	zombiehead.solid = SOLID_TRIGGER;
	zombiehead.takedamage = DAMAGE_NO;
	zombiehead.velocity_x = 83 * crandom();
	zombiehead.velocity_y = 83 * crandom();
	zombiehead.velocity_z = 222;
	zombiehead.enemy = self.enemy;
	
	zombiehead.nextthink = time + 0.15;
	zombiehead.think = zombie_head_anim;		// use a nice animation of spinning head in air  :-)
	
Gyro_Object_ClearPhysics(zombiehead);
GibPhysics(zombiehead);
};



var float autocvar_zombie = 4;     	// set cvar 'zombie' default to 4

void() zombie_dieburn1	=[	$paine1,	zombie_dieburn2	] {
//sound7 (self, CHAN_VOICE, "zombie/burning.wav", 1, ATTN_NORM, SNDSPD);
self.burnz_origin = 12;
if (self.zombie_mix_anim == 1)
	burn_toggle_allround();
else
	burn_toggle();
};
void() zombie_dieburn2	=[	$paine2,	zombie_dieburn3	] {ai_pain(8);self.burnz_origin = 11;
};
void() zombie_dieburn3	=[	$paine3,	zombie_dieburn4	] {ai_pain(5);self.burnz_origin = 6;
};
void() zombie_dieburn4	=[	$paine4,	zombie_dieburn5	] {ai_pain(3);self.burnz_origin = 3;
};
void() zombie_dieburn5	=[	$paine5,	zombie_dieburn6	] {ai_pain(1);self.burnz_origin = 0;
};
void() zombie_dieburn6	=[	$paine6,	zombie_dieburn7	] {ai_pain(2);self.burnz_origin = -2;
};
void() zombie_dieburn7	=[	$paine7,	zombie_dieburn8	] {ai_pain(1);self.burnz_origin = -4;
};
void() zombie_dieburn8	=[	$paine8,	zombie_dieburn9	] {ai_pain(1);self.burnz_origin = -6;
};
void() zombie_dieburn9	=[	$paine9,	zombie_dieburn10	] {self.burnz_origin = -8;
};
void() zombie_dieburn10	=[	$paine10,	zombie_dieburn11	] {
self.solid = SOLID_NOT;
self.burnz_origin = -10;
};
void() zombie_dieburn11	=[	$paine11,	zombie_dieburn12	] {self.burnz_origin = -10;
};
void() zombie_dieburn12	=[	$paine12,	zombie_dieburn12	] {self.burnz_origin = -10;
self.traileffectnum = particleeffectnum("monsternull");	   // To deactivate the flies after monster died
};


var float autocvar_newzombiecorpsehealth = 30;	// set cvar 'newzombiecorpsehealth' default to 30

void() zombie_die_newmodel_deatha1	=[	$deatha1,	zombie_die_newmodel_deatha2	] {
sound7 (self, CHAN_VOICE, "zombie/cut_head.wav", 1, ATTN_NORM, SNDSPD);
setmodel (self, "progs/zombie_new_headless.mdl");	// switch to headless model
setsize (self, '-16 -16 -24', '16 16 40');
zombie_head();		// throw head seperately
ai_forward(2);
	local	vector face1, org;
	face1 = vectoangles (self.enemy.origin - self.origin);
	makevectors (face1);
	org = self.origin + v_right * 1 + v_up * 22 + v_forward * -10;	
	pointparticles(particleeffectnum("zombieheadcut"), org, '0 0 0', 1); 
self.nextthink = time + 0.14;};
void() zombie_die_newmodel_deatha2	=[	$deatha2,	zombie_die_newmodel_deatha3	] {
ai_forward(2);self.nextthink = time + 0.14;};
void() zombie_die_newmodel_deatha3	=[	$deatha3,	zombie_die_newmodel_deatha4	] {
ai_forward(2);self.nextthink = time + 0.14;
local vector check;
check = (self.origin - ((VEC_HULL2_MIN + VEC_HULL2_MAX) * 0.5)) + '0 0 1';
if ((pointcontents(check) != CONTENT_WATER)&&(pointcontents(check) != CONTENT_SLIME)&&(pointcontents(check) != CONTENT_LAVA))
	self.traileffectnum = particleeffectnum("zombiedownfliesblack");
};
void() zombie_die_newmodel_deatha4	=[	$deatha4,	zombie_die_newmodel_deatha5	] {
ai_forward(7);self.nextthink = time + 0.14;};
void() zombie_die_newmodel_deatha5	=[	$deatha5,	zombie_die_newmodel_deatha6	] {self.nextthink = time + 0.13;};
void() zombie_die_newmodel_deatha6	=[	$deatha6,	zombie_die_newmodel_deatha7	] {self.nextthink = time + 0.13;};
void() zombie_die_newmodel_deatha7	=[	$deatha7,	zombie_die_newmodel_deatha8	] {self.nextthink = time + 0.13;};
void() zombie_die_newmodel_deatha8	=[	$deatha8,	zombie_die_newmodel_deatha9	] {self.nextthink = time + 0.13;};
void() zombie_die_newmodel_deatha9	=[	$deatha9,	zombie_die_newmodel_deatha10	] {self.nextthink = time + 0.12;};
void() zombie_die_newmodel_deatha10	=[	$deatha10,	zombie_die_newmodel_deatha11	] {
self.solid = SOLID_NOT;self.nextthink = time + 0.12;};
void() zombie_die_newmodel_deatha11	=[	$deatha11,	zombie_die_newmodel_deatha12	] {self.nextthink = time + 0.12;};
void() zombie_die_newmodel_deatha12	=[	$deatha12,	zombie_die_newmodel_deatha13	] {self.nextthink = time + 0.12;};
void() zombie_die_newmodel_deatha13	=[	$deatha13,	zombie_die_newmodel_deatha14	] {self.nextthink = time + 0.12;};
void() zombie_die_newmodel_deatha14	=[	$deatha14,	zombie_die_newmodel_deatha15	] {self.nextthink = time + 0.12;};
void() zombie_die_newmodel_deatha15	=[	$deatha15,	zombie_die_newmodel_deatha16	] {self.nextthink = time + 0.12;};
void() zombie_die_newmodel_deatha16	=[	$deatha16,	zombie_die_newmodel_deatha17	] {self.nextthink = time + 0.12;};
void() zombie_die_newmodel_deatha17	=[	$deatha17,	zombie_die_newmodel_deatha18	] {self.nextthink = time + 0.12;};
void() zombie_die_newmodel_deatha18	=[	$deatha18,	zombie_die_newmodel_deatha19	] {self.nextthink = time + 0.12;};
void() zombie_die_newmodel_deatha19	=[	$deatha19,	zombie_die_newmodel_deatha20	] {self.nextthink = time + 0.12;};
void() zombie_die_newmodel_deatha20	=[	$deatha20,	zombie_die_newmodel_deatha21	] {self.nextthink = time + 0.12;};
void() zombie_die_newmodel_deatha21	=[	$deatha21,	zombie_die_newmodel_deatha22	] {self.nextthink = time + 0.12;};
void() zombie_die_newmodel_deatha22	=[	$deatha22,	zombie_die_newmodel_deatha23	] {self.nextthink = time + 0.12;};
void() zombie_die_newmodel_deatha23	=[	$deatha23,	zombie_die_newmodel_deatha24	] {self.nextthink = time + 0.12;};
void() zombie_die_newmodel_deatha24	=[	$deatha24,	zombie_die_newmodel_deatha25	] {self.nextthink = time + 0.12;};
void() zombie_die_newmodel_deatha25	=[	$deatha25,	zombie_die_newmodel_deatha26	] {self.nextthink = time + 0.12;};
void() zombie_die_newmodel_deatha26	=[	$deatha26,	zombie_die_newmodel_deatha26	] {
self.delete_painskin = 1;		 	 // remove painskin
CopyMonsterToBodyQue(autocvar_newzombiecorpsehealth, "newzombieheadless");
};


void() zombie_die_newmodel_deathb1	=[	$deathb1,	zombie_die_newmodel_deathb2	] {
sound7 (self, CHAN_VOICE, "zombie/zombie_die.wav", 1, ATTN_NORM, SNDSPD);
ai_forward(-7);self.nextthink = time + 0.14;};
void() zombie_die_newmodel_deathb2	=[	$deathb2,	zombie_die_newmodel_deathb3	] {
ai_forward(-7);self.nextthink = time + 0.14;};
void() zombie_die_newmodel_deathb3	=[	$deathb3,	zombie_die_newmodel_deathb4	] {
ai_forward(-7);self.nextthink = time + 0.14;
local vector check;
check = (self.origin - ((VEC_HULL2_MIN + VEC_HULL2_MAX) * 0.5)) + '0 0 1';
if ((pointcontents(check) != CONTENT_WATER)&&(pointcontents(check) != CONTENT_SLIME)&&(pointcontents(check) != CONTENT_LAVA))
	self.traileffectnum = particleeffectnum("zombiedownfliesblack");
};
void() zombie_die_newmodel_deathb4	=[	$deathb4,	zombie_die_newmodel_deathb5	] {
ai_forward(-7);self.nextthink = time + 0.14;};
void() zombie_die_newmodel_deathb5	=[	$deathb5,	zombie_die_newmodel_deathb6	] {self.nextthink = time + 0.13;};
void() zombie_die_newmodel_deathb6	=[	$deathb6,	zombie_die_newmodel_deathb7	] {self.nextthink = time + 0.12;};
void() zombie_die_newmodel_deathb7	=[	$deathb7,	zombie_die_newmodel_deathb8	] {self.nextthink = time + 0.12;};
void() zombie_die_newmodel_deathb8	=[	$deathb8,	zombie_die_newmodel_deathb9	] {self.nextthink = time + 0.12;};
void() zombie_die_newmodel_deathb9	=[	$deathb9,	zombie_die_newmodel_deathb10	] {self.nextthink = time + 0.12;};
void() zombie_die_newmodel_deathb10	=[	$deathb10,	zombie_die_newmodel_deathb11	] {
self.solid = SOLID_NOT;self.nextthink = time + 0.12;};
void() zombie_die_newmodel_deathb11	=[	$deathb11,	zombie_die_newmodel_deathb12	] {self.nextthink = time + 0.12;};
void() zombie_die_newmodel_deathb12	=[	$deathb12,	zombie_die_newmodel_deathb13	] {self.nextthink = time + 0.12;};
void() zombie_die_newmodel_deathb13	=[	$deathb13,	zombie_die_newmodel_deathb14	] {self.nextthink = time + 0.12;};
void() zombie_die_newmodel_deathb14	=[	$deathb14,	zombie_die_newmodel_deathb15	] {self.nextthink = time + 0.12;};
void() zombie_die_newmodel_deathb15	=[	$deathb15,	zombie_die_newmodel_deathb16	] {self.nextthink = time + 0.12;};
void() zombie_die_newmodel_deathb16	=[	$deathb16,	zombie_die_newmodel_deathb17	] {self.nextthink = time + 0.12;};
void() zombie_die_newmodel_deathb17	=[	$deathb17,	zombie_die_newmodel_deathb18	] {self.nextthink = time + 0.12;};
void() zombie_die_newmodel_deathb18	=[	$deathb18,	zombie_die_newmodel_deathb19	] {self.nextthink = time + 0.12;};
void() zombie_die_newmodel_deathb19	=[	$deathb19,	zombie_die_newmodel_deathb20	] {self.nextthink = time + 0.12;};
void() zombie_die_newmodel_deathb20	=[	$deathb20,	zombie_die_newmodel_deathb21	] {self.nextthink = time + 0.12;};
void() zombie_die_newmodel_deathb21	=[	$deathb21,	zombie_die_newmodel_deathb21	] {
self.delete_painskin = 1;		 	 // remove painskin
CopyMonsterToBodyQue(autocvar_newzombiecorpsehealth, "newzombie");
};


void(float maxgibs, float gibscounter) producegibs_zombie =		// creates as many gib-sets as defined in cvar 'gibsmultiplier'
{
if (gibscounter >= maxgibs)
	return;
else
	{
	ThrowGib ("progs/gib_zarm.mdl", self.health);
	ThrowGib ("progs/gib_zarm.mdl", self.health);
	//ThrowGib ("progs/gib2.mdl", self.health);
	ThrowGib ("progs/gib_zleg.mdl", self.health);   
	ThrowGib ("progs/gib_zleg.mdl", self.health); 
	}
gibscounter = gibscounter + 1;
producegibs_zombie (maxgibs, gibscounter);
};



void() zombie_die =
{
	//if (!autocvar_lightninggun_death_animation)
		if (!self.shocked && self.enemy.weapon == IT_LIGHTNING && self.sticky != 1)
		{
			lg_death1();
			return;
		}
		
if (autocvar_zombienewmodelproperties >= 1)	// use new death animations for new zombie model when value is "1" or higher 
	{
	if ((self.monstermodel == 2) && (world.model != "maps/e1m7.bsp"))  
		{
		if (autocvar_slowmotion >= 3)	// start slowmotion when regular killing living enemies
			{
			if (random () <= (autocvar_slowmotion_randomness_zombie * 0.01))
				{
				the_matrix = 1;
				matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
				}
			}
		if (axeequipped == 1)
			zombie_die_newmodel_deatha1 ();		// cut head off
		else
			zombie_die_newmodel_deathb1 ();		// pushback and dying on the floor
		return;
		}
	}			

gibbed_monsters = gibbed_monsters + 1;
local float zufall, randomness;
// auto_cvar 'zombie' has been declared in code above already
var float autocvar_zombierandomness = 30;     	// set cvar 'zombierandomness' default to 30%
autocvar_zombierandomness = autocvar_zombierandomness * 0.01;
if ((autocvar_zombie == 2) && (world.model != "maps/e1m7.bsp") && (!(self.spawnflags & SPAWN_CRUCIFIED)))		// if 'zombie' is set via autoexec.cfg to '2' start Death animation with "Legend of Grimrock" effect
	{
	randomness = random();
	if (randomness <= autocvar_zombierandomness)	// checks if death animation shall be started
		{
		// sound7 (self, CHAN_VOICE, "zombie/z_gib.wav", 1, ATTN_NORM, SNDSPD);	// add a nice sound that fits the effect here
		Gyro_Object_ClearPhysics(self);   // DELETE this line if you want to enable GYRO during new "Legend of Grimrock" animation !!
		self.delete_painskin = 1;		// remove painskin
		zombie_dieburn1();
		return;			// jump out of this function !!
		}
	}
if ((autocvar_zombie == 3) && (world.model != "maps/e1m7.bsp") && (!(self.spawnflags & SPAWN_CRUCIFIED)))   	// if 'zombie' is set via autoexec.cfg to '3' start special "MIX" Death animation (Ancient ghosts of Grimrock !!)
	{				
	randomness = random();
	if (randomness <= autocvar_zombierandomness)	// checks if death animation shall be started 
		{					
		// sound7 (self, CHAN_VOICE, "zombie/z_gib.wav", 1, ATTN_NORM, SNDSPD);	// add a nice sound that fits the effect here
		// Gyro_Object_ClearPhysics(self);   // ENABLE this line if you want to disable GYRO during new "Legend of Grimrock" animation !!
		self.delete_painskin = 1;		// remove painskin
		self.zombie_mix_anim = 1;
		zombie_dieburn1();
		if (self.nodeathanim == 0)
			ghost_die ();	
		return;			// jump out of this function !!
		}	
	}
if ((autocvar_zombie == 4) && (world.model != "maps/e1m7.bsp"))		// if 'zombie' is set via autoexec.cfg to '4' start random Death animation (all 3 zombie effects !!)
	{				// chance for effects (approx.): 33% / 33% / 33%  (Ancient ghosts of the fallen; Legend of Grimrock; Ancient ghosts of Grimrock)
	randomness = random();
	if (randomness <= autocvar_zombierandomness)	// checks if death animation shall be started --> depending on monsters _randomness
		{					
		zufall = random();
		if (zufall > 0.67)
			self.grimrock_helper = 1;	// this float starts the "Ancient ghosts of the fallen" effect (code continues at the end of this function)
		else if ((zufall < 0.33) && (!(self.spawnflags & SPAWN_CRUCIFIED)))
			{
			// sound7 (self, CHAN_VOICE, "zombie/z_gib.wav", 1, ATTN_NORM, SNDSPD);	// add a nice sound that fits the effect here
			Gyro_Object_ClearPhysics(self);   // DELETE this line if you want to enable GYRO during new "Legend of Grimrock" animation !!
			self.delete_painskin = 1;		// remove painskin
			zombie_dieburn1();
			return;			// jump out of this function !!
			}
		else if (!(self.spawnflags & SPAWN_CRUCIFIED))
			{
			// sound7 (self, CHAN_VOICE, "zombie/z_gib.wav", 1, ATTN_NORM, SNDSPD);	// add a nice sound that fits the effect here
			// Gyro_Object_ClearPhysics(self);   // ENABLE this line if you want to disable GYRO during new "Legend of Grimrock" animation !!
			self.delete_painskin = 1;		// remove painskin
			self.zombie_mix_anim = 1;
			zombie_dieburn1();
			if (self.nodeathanim == 0)
				ghost_die ();		
			return;			// jump out of this function !!
			}
		}
	}	

self.delete_painskin = 1;	// remove painskin
local float maxgibs, gibscounter;
	if (autocvar_slowmotion >= 1)	// start slowmotion when gibbing living enemies
		{
		if (random () <= (autocvar_slowmotion_randomness_zombie * 0.01))
			{
			the_matrix = 1;
			SNDSPD = 70;
			matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
			}
		}
if (self.spawnflags & SPAWN_CRUCIFIED)
	{						// fix for DP build 20130301 and newer: 
	makevectors (self.angles);			// Otherwise gibs will float in wall (crucified zombie are moved into wall by 12 units)
	self.origin = self.origin + v_forward *15;
	}
	sound7 (self, CHAN_VOICE, "zombie/z_gib.wav", 1, ATTN_NORM, SNDSPD);
	
	//5 randomized blood droplets that drip if stuck to the ceiling
	CeilSplat();
	CeilSplat();
	CeilSplat();
	CeilSplat();
	CeilSplat();
	
		var float autocvar_gibsmultiplier = 1;         	// set cvar 'gibsmultiplier' default to 1
			if (autocvar_gibsmultiplier == 1)		// if 'gibsmultiplier' doesnt exist in autoexec.cfg, or if 'gibsmultiplier' is set via autoexec.cfg to '1'
				{
				if (self.monstermodel == 0)  
					ThrowHead ("progs/h_zombie.mdl", self.health);
				else if (self.monstermodel == 1)  
					ThrowHead ("progs/h_zombie1.mdl", self.health);
				else 
					{
					self.scale = 1.4;
					ThrowHead ("progs/h_zombie_new.mdl", self.health);
					}
				//check to see if zombie is missing arms
				if (self.model == "progs/zombie1.mdl" || self.model == "progs/zombie.mdl" || self.model == "progs/zombie_new.mdl")
				{
					ThrowGib ("progs/gib_zarm.mdl", self.health);
					ThrowGib ("progs/gib_zarm.mdl", self.health);
				}
				
				//ThrowGib ("progs/gib2.mdl", self.health);
				ThrowGib ("progs/gib_zleg.mdl", self.health); 
				ThrowGib ("progs/gib_zleg.mdl", self.health); 
				if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
					pointparticles(particleeffectnum("blood_monster_gib"), self.origin, '0 0 0', 1);
				}
			else 							// if 'gibsmultiplier' is set via autoexec.cfg to any other value than '1'
				{						// --> produce more gibs
				if (self.monstermodel == 0)  
					ThrowHead ("progs/h_zombie.mdl", self.health);
				else if (self.monstermodel == 1)  
					ThrowHead ("progs/h_zombie1.mdl", self.health);
				else 
					{
					self.scale = 1.4;
					ThrowHead ("progs/h_zombie_new.mdl", self.health);
					}
				maxgibs = autocvar_gibsmultiplier;
				gibscounter = 0;
				gibdeath_effects();
				producegibs_zombie (maxgibs, gibscounter);
				
				}
if (autocvar_zombie == 1)		// if 'zombie' is set via autoexec.cfg to '1' start Death animation with "Ancient ghosts of the fallen" effect
	{
	if (self.nodeathanim == 0)
		{
		randomness = random();
		if (randomness <= autocvar_zombierandomness)	// checks if death animation shall be started
			ghost_die ();
		}
	}
if (self.grimrock_helper == 1)	// this code is the ending of cvar value "4" (which was started earlier in this function)
	{
	if (self.nodeathanim == 0)
		ghost_die ();
	}
};



/*
=================
zombie_pain

Zombies can only be killed (gibbed) by doing 60 hit points of damage
in a single frame (rockets, grenades, quad shotgun, quad nailgun).

A hit of 25 points or more (super shotgun, quad nailgun) will allways put it
down to the ground.

A hit of from 10 to 40 points in one frame will cause it to go down if it
has been twice in two seconds, otherwise it goes into one of the four
fast pain frames.

A hit of less than 10 points of damage (winged by a shotgun) will be ignored.

FIXME: don't use pain_finished because of nightmare hack
=================
*/
void(entity attacker, float take) zombie_pain =
{
	local float r;
	var float autocvar_wallzombie = 2;		// set cvar 'wallzombie' default to 2
	if (autocvar_wallzombie == 2)
	{
		if (!self.spawnflags & SPAWN_CRUCIFIED)	// Only reset health if its not crucified 
		self.health = 60;		    
	}
	else self.health = 60;				 // always reset health

	if (take >= 10)
	{
		if (attacker.weapon == IT_AXE || attacker.weapon == IT_CHAINSAW)
		{
			if (self.model == "progs/zombie.mdl")
			{
				ThrowGib("progs/gib_zarm.mdl", self.health);
				setmodel (self, self.model = "progs/zombie_onearm.mdl");
				setsize (self, ZOMB_MIN, ZOMB_MAX);
			}
			else if (self.model == "progs/zombie_onearm.mdl")
			{
				ThrowGib("progs/gib_zarm.mdl", self.health);
				setmodel (self, self.model = "progs/zombie_noarms.mdl");
				self.goalentity = world;
				setsize (self, ZOMB_MIN, ZOMB_MAX);
			}
			
			if (self.model == "progs/zombie1.mdl")
			{
				ThrowGib("progs/gib_zarm.mdl", self.health);
				setmodel (self, self.model = "progs/zombie1_onearm.mdl");
				setsize (self, ZOMB_MIN, ZOMB_MAX);
			}
			else if (self.model == "progs/zombie1_onearm.mdl")
			{
				ThrowGib("progs/gib_zarm.mdl", self.health);
				setmodel (self, self.model = "progs/zombie1_noarms.mdl");
				self.goalentity = world;
				setsize (self, ZOMB_MIN, ZOMB_MAX);
			}
			
		}
	}
	if (take < 9)
		return;				// totally ignore
	
	if (self.inpain == 2)
		return;			// down on ground, so don't reset any counters

// go down immediately if a big enough hit
	if (take >= 25)
	{
		if (autocvar_slowmotion >= 4)	// start slowmotion when hurting enemies
		{
			if (random () <= (autocvar_slowmotion_randomness_zombie * 0.01))
				{
				the_matrix = 1;
				matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
				}
		}
		self.inpain = 2;
		zombie_paine1 ();
		return;
	}
	
	if (self.inpain)
	{
// if hit again in next gre seconds while not in pain frames, definately drop
		self.pain_finished = time + 3;
		return;			// currently going through an animation, don't change
	}
	
	if (self.pain_finished > time)
	{
// hit again, so drop down
		if (autocvar_slowmotion >= 4)	// start slowmotion when hurting enemies
		{
			if (random () <= (autocvar_slowmotion_randomness_zombie * 0.01))
				{
				the_matrix = 1;
				matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
				}
		}
		self.inpain = 2;
		zombie_paine1 ();
		return;
	}

// gp into one of the fast pain animations	
	self.inpain = 1;

	if (autocvar_slowmotion >= 4)	// start slowmotion when hurting enemies
	{
		if (random () <= (autocvar_slowmotion_randomness_zombie * 0.01))
			{
			the_matrix = 1;
			matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
			}
	}

	r = random();
	if (r < 0.25)
		zombie_paina1 ();
	else if (r <  0.5)
		zombie_painb1 ();
	else if (r <  0.75)
		zombie_painc1 ();
	else
		zombie_paind1 ();
};

//HIPNOTIC
void() zombie_lay12   =[ $paine12,   zombie_paine13 ]
  {   self.solid = SOLID_SLIDEBOX;
	if (self.targetname)
		self.use = SUB_Null;
   	self.th_pain = zombie_pain;};
   
void() zombie_lay   =[ $paine11,   zombie_lay ]
   {
   self.th_stand = zombie_stand1;
   self.th_pain = zombie_lay12;

   self.nextthink = self.nextthink + 0.1;
   self.health = 60;
   if (!self.targetname)
   {
	   if (FindTarget ())
	      {
	      zombie_lay12();
	      return;
	      }
    }
    else
    {
    	self.solid = SOLID_NOT;
	self.use = zombie_lay12;
    }
   };

void(entity attacker, float take) zombie_pain_newmodel =	// special pain function for new zombie with extended properties
{
	local float r;
	
	if (autocvar_zombienewmodelproperties == 1)	// new zombie is killable with axe and explosives
		self.health = 60;			// reset health to 60
	else						// new zombie is ONLY killable with axe
		self.health = 490;			// reset health to 490

	if (attacker.weapon == IT_AXE)			// checks if player uses axe or not 
		self.axehitcount = self.axehitcount + 1;	// counts each time when player hits new zombie with axe

	if (take < 9)
		return;				// totally ignore

	if (self.inpain == 2)
		return;			// down on ground, so don't reset any counters

// go down immediately if a big enough hit, but not with axe !
if (attacker.weapon != IT_AXE)
{
	if (take >= 25)
	{
		if (autocvar_slowmotion >= 4)	// start slowmotion when hurting enemies
		{
			if (random () <= (autocvar_slowmotion_randomness_zombie * 0.01))
				{
				the_matrix = 1;
				matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
				}
		}
		self.inpain = 2;
		zombie_paine1 ();
		return;
	}
}
	
	if (self.inpain)
	{
// if hit again in next gre seconds while not in pain frames, definately drop
		self.pain_finished = time + 3;
		return;			// currently going through an animation, don't change
	}

if (attacker.weapon != IT_AXE)
{

	if (self.pain_finished > time)
	{
// hit again, so drop down.  But not with axe !
		if (autocvar_slowmotion >= 4)	// start slowmotion when hurting enemies
		{
			if (random () <= (autocvar_slowmotion_randomness_zombie * 0.01))
				{
				the_matrix = 1;
				matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
				}
		}

		self.inpain = 2;
		zombie_paine1 ();
		return;
	}
}

// gp into one of the fast pain animations	
	self.inpain = 1;

if (attacker.weapon != IT_AXE)		// use regular pain animations
{
	if (autocvar_slowmotion >= 4)	// start slowmotion when hurting enemies
	{
		if (random () <= (autocvar_slowmotion_randomness_zombie * 0.01))
			{
			the_matrix = 1;
			matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
			}
	}
	r = random();
	if (r < 0.25)
		zombie_paina1 ();
	else if (r <  0.5)
		zombie_painb1 ();
	else if (r <  0.75)
		zombie_painc1 ();
	else
		zombie_paind1 ();
}
else				// use only pain animations 'paina' and 'paind' when holding axe !!
{
	if (autocvar_slowmotion >= 4)	// start slowmotion when hurting enemies
	{
		if (random () <= (autocvar_slowmotion_randomness_zombie * 0.01))
			{
			the_matrix = 1;
			matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
			}
	}
	r = random();
	if (r < 0.5)
		zombie_paina1 ();
	else
		zombie_paind1 ();
}
};
//============================================================================

/*QUAKED monster_zombie (1 0 0) (-16 -16 -24) (16 16 32) Crucified ambush

If crucified, stick the bounding box 12 pixels back into a wall to look right.
*/
void() monster_zombie =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	precache_model ("progs/zombie.mdl");
	precache_model ("progs/h_zombie.mdl");
	precache_model ("progs/zom_gib.mdl");
	
	precachegibs_zom();
	
	precache_model ("progs/zombie_new_projectile.mdl");

	precache_sound ("zombie/z_idle.wav");
	precache_sound ("zombie/z_idle1.wav");
	precache_sound ("zombie/z_shot1.wav");
	precache_sound ("zombie/z_gib.wav");
	precache_sound ("zombie/z_pain.wav");
	precache_sound ("zombie/z_pain1.wav");
	precache_sound ("zombie/z_fall.wav");
	precache_sound ("zombie/z_miss.wav");
	precache_sound ("zombie/z_hit.wav");
	precache_sound ("zombie/idle_w2.wav");
	precache_sound ("walk/zombierun1.wav");
	precache_sound ("walk/zombierun2.wav");
	precache_sound ("walk/zombiewalk1.wav");
	precache_sound ("walk/zombiewalk2.wav");

	precache_sound ("zombie/cut_head.wav");
	precache_sound ("zombie/zombie_die.wav");


	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	self.netname = "monster_zombie";

	local float zufall;

	var float autocvar_zombiemultiskin = 0;     	// set cvar 'zombiemultiskin' default to 0
	if (autocvar_zombiemultiskin == 1)	// if 'zombiemultiskin' is set via autoexec.cfg to '1' use 2 different skins for ID1 model
	{
		self.multiskin = 1;
		setmodel (self, "progs/zombie.mdl");
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
	else if (autocvar_zombiemultiskin == 2)	// if 'zombiemultiskin' is set via autoexec.cfg to '2' use 1 Id1 model skin AND external model
	{
		self.multiskin = 2;
		precache_model ("progs/zombie1.mdl");
		precache_model ("progs/h_zombie1.mdl");
		zufall = random();
		if (zufall >= 0.5)
			{
			setmodel (self, "progs/zombie.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 0;
			}
		else 
			{
			setmodel (self, "progs/zombie1.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 1;
			}
	}
	else if (autocvar_zombiemultiskin == 3)	// if 'zombiemultiskin' is set via autoexec.cfg to '3' use 2 Id1 model skins AND external model
	{
		self.multiskin = 3;
		precache_model ("progs/zombie1.mdl");
		precache_model ("progs/h_zombie1.mdl");
		zufall = random();
		if (zufall > 0.66)
			{
			setmodel (self, "progs/zombie.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 0;
			}
		else if (zufall < 0.34)
			{
			setmodel (self, "progs/zombie.mdl");
			self.skin = 1;
			self.monsterskin = 1;
			self.monstermodel = 0;
			}
		else
			{
			setmodel (self, "progs/zombie1.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 1;
			}
	}
	else if (autocvar_zombiemultiskin == 4)	// if 'zombiemultiskin' is set via autoexec.cfg to '4' use 2 Id1 model skins AND 2 external model skins
	{
		self.multiskin = 4;
		precache_model ("progs/zombie1.mdl");
		precache_model ("progs/h_zombie1.mdl");
		zufall = random();
		if (zufall > 0.75)
			{
			setmodel (self, "progs/zombie.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 0;
			}
		else if (zufall > 0.5 && zufall <= 0.75)
			{
			setmodel (self, "progs/zombie.mdl");
			self.skin = 1;
			self.monsterskin = 1;
			self.monstermodel = 0;
			}
		else if (zufall > 0.25 && zufall <= 0.5)
			{
			setmodel (self, "progs/zombie1.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 1;
			}
		else 
			{
			setmodel (self, "progs/zombie1.mdl");
			self.skin = 1;
			self.monsterskin = 1;
			self.monstermodel = 1;
			}
	}
	else						// standard Quake
		{
		setmodel (self, "progs/zombie.mdl");
		self.skin = 0;
		self.monsterskin = 0;
		self.monstermodel = 0;
		}

if ((autocvar_zombie_use_newmodel) && (world.model != "maps/start.bsp"))	// transform model to new zombie model
	{
	local float new_zombie;
	new_zombie = autocvar_zombie_use_newmodel * 0.01;
	if (random() < new_zombie)						// transform model to new zombie model
		{
		precache_model ("progs/zombie_new.mdl");
		precache_model ("progs/zombie_new_headless.mdl");
		precache_model ("progs/h_zombie_new.mdl");
		setmodel (self, "progs/zombie_new.mdl");
		zufall = random();
		if (zufall > 0.5)
			{
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 2;
			}
		else
			{
			self.skin = 1;
			self.monsterskin = 1;
			self.monstermodel = 2;
			}
		}
	}

var float autocvar_zombie_size = 2;     	// set cvar 'zombie_size' default to 2
	local float zuffa;
	if (autocvar_zombie_size == 1)		// if 'zombie_size' is set via autoexec.cfg to '1' give monster random size between 100% and 114% (7% steps due to DP´s .scale restrictions)
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
			setsize (self, ZOMB_MIN, ZOMB_MAX);
		}
	}
	else if (autocvar_zombie_size == 2)		// if 'zombie_size' is set via autoexec.cfg to '2' give monster random size between 100% and 121% (7% steps due to DP´s .scale restrictions)
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
			setsize (self, ZOMB_MIN, ZOMB_MAX);
		}
	}
	else if (autocvar_zombie_size == 3)		// if 'zombie_size' is set via autoexec.cfg to '3' give monster random size between 100% and 128% (7% steps due to DP´s .scale restrictions)
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
			setsize (self, ZOMB_MIN, ZOMB_MAX);
		}
	}
	else if (autocvar_zombie_size == 4)		// if 'zombie_size' is set via autoexec.cfg to '4' give monster random size between 100% and 135% (7% steps due to DP´s .scale restrictions)
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
			setsize (self, ZOMB_MIN, ZOMB_MAX);
		}
	}
	else if (autocvar_zombie_size > 3)		// if 'zombie_size' is set via autoexec.cfg to a value bigger than '3' give monster the selected fixed size ==>  100% + [value]%  (7% steps due to DP´s .scale restrictions)
	{
		if (autocvar_zombie_size > 40)
			self.origin = self.origin + '0 0 10';		// might get stuck in floor otherwise. --> drop him to floor from higher position !
		self.scale = 1 + (autocvar_zombie_size * 0.01);
		self.sizefactor_x = 0;
		self.sizefactor_y = 0;
		self.sizefactor_z = autocvar_zombie_size * 0.25;
		self.sizediff = self.sizefactor;
		setsize (self, '-16 -16 -24' - self.sizediff, '16 16 40' - self.sizediff);
	}
	else
	{
		self.scale = 1;
		setsize (self, ZOMB_MIN, ZOMB_MAX);
	}

	self.health = 60;

	if (autocvar_monster_random_skin_color_alteration && autocvar_zombie_random_skin_colors)	// modify/edit this monster types skin textures randomly (for higher variation in-game)
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

	self.th_stand = zombie_stand1;
	self.th_walk = zombie_walk1;
	self.th_run = zombie_run1;

	if (autocvar_zombienewmodelproperties == 1)		// new zombie model is killable with axe and explosives
		{
		if (self.monstermodel == 2)
			self.th_pain = zombie_pain_newmodel;
		else
			self.th_pain = zombie_pain;
		}
	else if (autocvar_zombienewmodelproperties >= 2)	// new zombie model is ONLY killable with axe
		{
		if (self.monstermodel == 2)
			{
			self.th_pain = zombie_pain_newmodel;
			self.health = 490;
			}
		else
			self.th_pain = zombie_pain;
		}
	else						// values "0" has no difference between new zombie model and original zombie (regarding their properties)
		self.th_pain = zombie_pain;

	self.th_die = zombie_die;
	self.th_missile = zombie_missile;

	if (self.spawnflags & SPAWN_CRUCIFIED)
	{
		var float autocvar_wallzombie = 2;	    	// set cvar 'wallzombie' default to 2
        	if (autocvar_wallzombie >= 1 )	// if cvar 'wallzombie' is >= 1 cruzified zombies are killable
		{
			self.takedamage = DAMAGE_AIM;  //ADDED THIS !!!  (changed to DAMAGE_AIM to make cruzified zombies killable with grenades)
        		self.inpain = 2;               //ADDED THIS !!!
		}
		self.movetype = MOVETYPE_NONE;
		var float autocvar_zombiecrucifiedflies = 2;	    	// set cvar 'zombiecrucifiedflies' default to 2
      	  	if (autocvar_zombiecrucifiedflies == 1 )		// if cvar 'zombiecrucifiedflies' is 1, cruzified zombies have BLACK flies around them
				self.traileffectnum = particleeffectnum("zombiefliescrucifiedblack");
      	  	if (autocvar_zombiecrucifiedflies == 2 )		// if cvar 'zombiecrucifiedflies' is 2, cruzified zombies have BROWN flies around them
				self.traileffectnum = particleeffectnum("zombiefliescrucifiedbrown");
		if (self.monstermodel == 2)	// cruzified zombies can NEVER be new zombie models
			{
			setmodel (self, "progs/zombie.mdl");
			self.th_pain = zombie_pain;
			self.health = 60;
			if (autocvar_zombiemultiskin >= 2)	// if multiskin feature uses 2 zombie models, make use of both !
				{
				zufall = random();
				if (zufall >= 0.5)
					self.monstermodel = 0;
				else
					self.monstermodel = 1;
				}
			else					// if multiskin feature uses only 1 zombie model
				self.monstermodel = 0;		
			}

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
		zombie_cruc1 ();
	}
	else
	{
		var float autocvar_zombieflies = 2;	    	// set cvar 'zombieflies' default to 2
      	  	if ((autocvar_zombieflies == 1 ) && (pointcontents(self.origin) != CONTENT_WATER))	// if cvar 'zombieflies' is 1, zombies have BLACK flies around them
				self.traileffectnum = particleeffectnum("zombiefliesblack");
      	  	if ((autocvar_zombieflies == 2 ) && (pointcontents(self.origin) != CONTENT_WATER))	// if cvar 'zombieflies' is 2, zombies have BROWN flies around them
				self.traileffectnum = particleeffectnum("zombiefliesbrown");
	
		self.alpha = autocvar_monstertransparency * 0.01;
		
		if ((autocvar_spider_replace_zombie)&&(!(self.spawnflags & SPAWN_CRUCIFIED)))	// if zombie shall be replaced by spider. Check the chance and do it !!)
			{	
			local float replacer;		
			replacer = autocvar_spider_replace_zombie * 0.01;
			if (random () <= replacer)
				{
				 local vector check;
				 check = (self.origin - ((VEC_HULL2_MIN + VEC_HULL2_MAX) * 0.5)) + '0 0 1';
				 if (((pointcontents(check) == CONTENT_WATER) && (autocvar_spider_can_spawn_in_water)) || (pointcontents(check) != CONTENT_WATER)) 	   // checks if monster is spawned in water. Spider is too small to be visible in shallow (not transparent) water, so better not change to spider.
					{
					self.skin = 6;
					self.health = 70;
					self.scale = 1;
					setsize (self, '-16 -16 -24', '16 16 40');
					self.nextthink = time + 0.3;	
					self.think = SUB_Remove;
					monster_spider_start();
					return;
					}
				}
			}

		if ((autocvar_reiver_replace_zombie)&&(!(self.spawnflags & SPAWN_CRUCIFIED)))	// if zombie shall be replaced by reiver. Check the chance and do it !!)
			{	
			local float replacez;		
			replacez = autocvar_reiver_replace_zombie * 0.01;
			if (random () <= replacez)
				{
				self.health = 70;
				self.scale = 1;
				setsize (self, '-16 -16 -24', '16 16 40');
				self.nextthink = time + 0.3;	
				self.think = SUB_Remove;
				monster_reiver_liftorigin_start();
				return;
				}
			}

		if ((autocvar_afrit_replace_zombie)&&(!(self.spawnflags & SPAWN_CRUCIFIED)))	// if zombie shall be replaced by afrit. Check the chance and do it !!)
			{	
			local float replac;		
			replac = autocvar_afrit_replace_zombie * 0.01;
			if (random () <= replac)
				{
				self.health = 70;
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

		walkmonster_start();
		//HIPNOTIC
		   if (self.spawnflags & SPAWN_LYINGDOWN)
		      {
		      self.th_stand = zombie_lay;
		      }

		if (autocvar_reiver_supports_zombie)		// if reiver shall be spawned in ADDITION to an existing zombie. Check the chance and do it !!)
			{	
			local float replacce;		
			replacce = autocvar_reiver_supports_zombie * 0.01;
			if (random () <= replacce)
				add_reiver_support_walk ();
			}

		if (autocvar_afrit_supports_zombie)		// if afrit shall be spawned in ADDITION to an existing zombie. Check the chance and do it !!)
			{	
			local float replace;		
			replace = autocvar_afrit_supports_zombie * 0.01;
			if (random () <= replace)
				add_afrit_support_walk ();
			}
		do_the_cloning();
	}

var float autocvar_zombiemass = 1600;
MonsterPhysics (self, autocvar_zombiemass);		
};
