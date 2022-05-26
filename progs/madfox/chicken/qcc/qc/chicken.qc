/*
==============================================================================

CHICKEN

==============================================================================
*/
$cd id1/models/chicken
$origin 0 0 24
$base base
$skin skin

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 
$frame stand9 stand10 stand11 stand12 stand13 stand14 stand15 stand16 

$frame pick1 pick2 pick3 pick4 pick5 pick6 pick7 pick8 pick9 pick10
$frame pick11 pick12

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9
$frame walk11 walk12 walk13 

$frame run1 run2 run3 run4 run5 

$frame pain1 pain2 pain3 pain4 pain5 pain6 pain7

$frame painb1 painb2 painb3 painb4 painb5 painb6 

$frame attack1 attack2 attack3 attack4 attack5 

$frame atackb1 atackb2 atackb3 atackb4 atackb5 

$frame death1 death2 death3 death4 death5 death6 death7 death8 
$frame death9 death10 death11 death12 death13 death14 death15 death16

$frame deatha1 deatha2 deatha3 deatha4 deatha5 deatha6 deatha7  
$frame deatha8 deatha9 deatha10 deatha11 deatha12 deatha13 

$frame deathb1 deathb2 deathb3 deathb4 deathb5 deathb6 deathb7 deathb8
$frame deathb9 deathb10 deathb11 deathb12 deathb13 deathb14 deathb15 
$frame deathb16 deathbt17

$frame leap1 leap2 leap3 leap4 leap5 leap6 leap7 leap8

void() chick_leap1;
void() chick_run1;
void() chick_pick1;

/*
================
chick_bite

================
*/
void() chick_bite =
{
local vector	delta;
local float 	ldmg;

	if (!self.enemy)
		return;

	ai_charge(10);

	if (!CanDamage (self.enemy, self))
		return;

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 100)
		return;
		
	ldmg = (random() + random() + random()) * 2;
	T_Damage (self.enemy, self, self, ldmg);
};

void()	Chick_JumpTouch =
{
	local	float	ldmg;

	if (self.health <= 0)
		return;
		
	if (other.takedamage)
	{
		if ( vlen(self.velocity) > 300 )
		{
			ldmg = 10 + 10*random();
			T_Damage (other, self, self, ldmg);	
		}
	}

	if (!checkbottom(self))
	{
		if (self.flags & FL_ONGROUND)
		{	// jump randomly to not get hung up
//dprint ("popjump\n");
	self.touch = SUB_Null;
	self.think = chick_leap1;
	self.nextthink = time + 0.1;

//			self.velocity_x = (random() - 0.5) * 600;
//			self.velocity_y = (random() - 0.5) * 600;
//			self.velocity_z = 200;
//			self.flags = self.flags - FL_ONGROUND;
		}
		return;	// not on ground yet
	}

	self.touch = SUB_Null;
	self.think = chick_run1;
	self.nextthink = time + 0.1;
};


void() chick_stand1	=[	$stand1,	chick_stand2	] {ai_stand();};
void() chick_stand2	=[	$stand2,	chick_stand3	] {ai_stand();};
void() chick_stand3	=[	$stand3,	chick_stand4	] {ai_stand();};
void() chick_stand4	=[	$stand4,	chick_stand5	] {ai_stand();};

//CLIP HERE
//HERE IS THE PICK CODE:

void() chick_pick1	=[	$pick1, 	chick_pick2	] {};
void() chick_pick2	=[	$pick2, 	chick_pick3	] {};
void() chick_pick3	=[	$pick3, 	chick_pick4	] {};
void() chick_pick4	=[	$pick4, 	chick_pick5	] {};
void() chick_pick5	=[	$pick5, 	chick_pick6	] {};
void() chick_pick6	=[	$pick6, 	chick_pick7	] {};
void() chick_pick7	=[	$pick7, 	chick_pick8	] {};
void() chick_pick8	=[	$pick8, 	chick_pick9	] {};
void() chick_pick9	=[	$pick9, 	chick_pick10	] {};
void() chick_pick10	=[	$pick10,	chick_pick11	] {};
void() chick_pick11	=[	$pick11,	chick_pick12	] {};
void() chick_pick12	=[	$pick12,	chick_stand6	] {};

//END PICK CODE

void() chick_stand5	=[	$stand5,	chick_check	] {ai_stand();};
void() chick_stand6	=[	$stand6,	chick_stand7	] {ai_stand();};
void() chick_stand7	=[	$stand7,	chick_stand8	] {ai_stand();};
void() chick_stand8	=[	$stand8,	chick_stand9	] {ai_stand();};
void() chick_stand9	=[	$stand9,	chick_stand10	] {ai_stand();};
void() chick_stand10	=[	$stand10,	chick_stand11	] {ai_stand();};
void() chick_stand11	=[	$stand11,	chick_stand12	] {ai_stand();};
void() chick_stand12	=[	$stand12,	chick_stand13	] {ai_stand();};
void() chick_stand13	=[	$stand13,	chick_stand14	] {ai_stand();};
void() chick_stand14	=[	$stand14,	chick_stand15	] {ai_stand();};
void() chick_stand15	=[	$stand15,	chick_stand16	] {ai_stand();};
void() chick_stand16	=[	$stand16,	chick_stand1	] {ai_stand();};

// chick_check IS CALLED IN chick_stand5, TO DETERMINE IF HE'LL Stand OR pick.
void() chick_check =

	{
	ai_stand();
	if (random() <0.25)
		chick_stand5 (); 

	else 
	if (random() <0.5)
		chick_stand5 ();
	else
		chick_pick1 ();
};  

//end chick_check
//  CLIP HERE...



void() chick_walk1	=[	$walk1 ,	chick_walk2	] {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "chick/idle.wav", 1, ATTN_IDLE);
ai_walk(4);};
void() chick_walk2	=[	$walk2 ,	chick_walk3	] {ai_walk(6);};
void() chick_walk3	=[	$walk3 ,	chick_walk4	] {ai_walk(8);};
void() chick_walk4	=[	$walk4 ,	chick_walk5	] {ai_walk(8);};
void() chick_walk5	=[	$walk5 ,	chick_walk6	] {ai_walk(6);};
void() chick_walk6	=[	$walk6 ,	chick_walk7	] {ai_walk(4);};
void() chick_walk7	=[	$walk7 ,	chick_walk8	] {ai_walk(4);};
void() chick_walk8	=[	$walk8 ,	chick_walk9	] {ai_walk(4);};
void() chick_walk9	=[	$walk9 ,	chick_walk10	] {ai_walk(6);};
void() chick_walk10	=[	$walk10 ,	chick_walk11	] {ai_walk(8);};
void() chick_walk11	=[	$walk11 ,	chick_walk12	] {ai_walk(8);};
void() chick_walk12	=[	$walk12 ,	chick_walk13	] {ai_walk(6);};
void() chick_walk13	=[	$walk13 ,	chick_walk1	] {ai_walk(4);};

void() chick_run1		=[	$run1  ,	chick_run2	] {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "chick/idle1.wav", 1, ATTN_IDLE);
ai_run(16);};
void() chick_run2		=[	$run2  ,	chick_run3	] {ai_run(12);};
void() chick_run3		=[	$run3  ,	chick_run4	] {ai_run(14);};
void() chick_run4		=[	$run4  ,	chick_run5	] {ai_run(16);};
void() chick_run5		=[	$run5  ,	chick_run1	] {ai_run(12);};

void() chick_atta1	=[	$attack1,	chick_atta2	] {ai_charge(1);};
void() chick_atta2	=[	$attack2,	chick_atta3	] {ai_charge(1);};
void() chick_atta3	=[	$attack3,	chick_atta4	] {ai_charge(1);};
void() chick_atta4	=[	$attack4,	chick_atta5	] {
        sound (self, CHAN_VOICE, "chick/atk1.wav", 1, ATTN_NORM);
chick_bite();};
void() chick_atta5	=[	$attack5,	chick_run1	] {ai_charge(1);};

void() chick_leap1	=[	$leap1,		chick_leap2	] {ai_face();};
void() chick_leap2	=[	$leap2,		chick_leap3	]
{
	ai_face();
	
	self.touch = Chick_JumpTouch;
	makevectors (self.angles);
	self.origin_z = self.origin_z + 1;
	self.velocity = v_forward * 300 + '0 0 200';
	if (self.flags & FL_ONGROUND)
		self.flags = self.flags - FL_ONGROUND;
};

void() chick_leap3	=[	$leap3,		chick_leap4	] {};
void() chick_leap4	=[	$leap4,		chick_leap5	] {};
void() chick_leap5	=[	$leap5,		chick_leap6	] {};
void() chick_leap6	=[	$leap6,		chick_leap7	] {};
void() chick_leap7	=[	$leap7,		chick_leap8	] {};
void() chick_leap8	=[	$leap8,		chick_run1	] {};

void() chick_pain1	=[	$pain1 ,	chick_pain2	] {};
void() chick_pain2	=[	$pain2 ,	chick_pain3	] {};
void() chick_pain3	=[	$pain3 ,	chick_pain4	] {};
void() chick_pain4	=[	$pain4 ,	chick_pain5	] {};
void() chick_pain5	=[	$pain5 ,	chick_pain6	] {};
void() chick_pain6	=[	$pain6 ,	chick_pain7	] {};
void() chick_pain7	=[	$pain7 ,	chick_run1	] {};

void() chick_painb1	=[	$painb1 ,	chick_painb2	] {};
void() chick_painb2	=[	$painb2 ,	chick_painb3	] {};
void() chick_painb3	=[	$painb3 ,	chick_painb4	] {ai_pain(4);};
void() chick_painb4	=[	$painb4 ,	chick_painb5	] {ai_pain(12);};
void() chick_painb5	=[	$painb5 ,	chick_painb6	] {ai_pain(12);};
void() chick_painb6	=[	$painb6 ,	chick_run1	] {};

void() chick_pain =
{
	sound (self, CHAN_VOICE, "chick/pain1.wav", 1, ATTN_NORM);

	if (random() > 0.5)
		chick_pain1 ();
	else
		chick_painb1 ();
};

void() chick_die1		=[	$death1,	chick_die2	] {};
void() chick_die2		=[	$death2,	chick_die3	] {};
void() chick_die3		=[	$death3,	chick_die4	] {};
void() chick_die4		=[	$death4,	chick_die5	] {};
void() chick_die5		=[	$death5,	chick_die6	] {};
void() chick_die6		=[	$death6,	chick_die7	] {};
void() chick_die7		=[	$death7,	chick_die8	] {};
void() chick_die8		=[	$death8,	chick_die9	] {};
void() chick_die9		=[	$death9,	chick_die10	] {};
void() chick_die10		=[	$death10,	chick_die11	] {};
void() chick_die11		=[	$death11,	chick_die12	] {};
void() chick_die12		=[	$death12,	chick_die13	] {};
void() chick_die13		=[	$death13,	chick_die14	] {};
void() chick_die14		=[	$death14,	chick_die15	] {};
void() chick_die15		=[	$death15,	chick_die16	] {};
void() chick_die16		=[	$death16,	chick_die16	] {};

void() chick_dieb1		=[	$deathb1,	chick_dieb2	] {};
void() chick_dieb2		=[	$deathb2,	chick_dieb3	] {};
void() chick_dieb3		=[	$deathb3,	chick_dieb4	] {};
void() chick_dieb4		=[	$deathb4,	chick_dieb5	] {};
void() chick_dieb5		=[	$deathb5,	chick_dieb6	] {};
void() chick_dieb6		=[	$deathb6,	chick_dieb7	] {};
void() chick_dieb7		=[	$deathb7,	chick_dieb8	] {};
void() chick_dieb8		=[	$deathb8,	chick_dieb9	] {};
void() chick_dieb9		=[	$deathb9,	chick_dieb10	] {};
void() chick_dieb10		=[	$deathb10,	chick_dieb11	] {};
void() chick_dieb11		=[	$deathb11,	chick_dieb12	] {};
void() chick_dieb12		=[	$deathb12,	chick_dieb13	] {};
void() chick_dieb13		=[	$deathb13,	chick_dieb14	] {};
void() chick_dieb14		=[	$deathb14,	chick_dieb15	] {};
void() chick_dieb15		=[	$deathb15,	chick_dieb16	] {};
void() chick_dieb16		=[	$deathb16,	chick_dieb16	] {};


void() chick_die =
{
// check for gib
	if (self.health < -35)
	{
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		ThrowGib ("progs/gib3.mdl", self.health);
		ThrowGib ("progs/gib3.mdl", self.health);
		ThrowGib ("progs/gib3.mdl", self.health);
		ThrowHead ("progs/h_alouet.mdl", self.health);
		return;
	}

// regular death
	sound (self, CHAN_VOICE, "chick/die.wav", 1, ATTN_NORM);
	self.solid = SOLID_NOT;

	if (random() > 0.5)
		chick_die1 ();
	else
		chick_dieb1 ();
};

//============================================================================

/*
==============
CheckChickMelee

Returns TRUE if a melee attack would hit right now
==============
*/
float()	CheckCickMelee =
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
CheckChickJump

==============
*/
float()	CheckChickJump =
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
	
	if (d < 80)
		return FALSE;
		
	if (d > 150)
		return FALSE;
		
	return TRUE;
};

//===========================================================================

/*QUAKED monster_chick (1 0 0) (-32 -32 -24) (32 32 40) Ambush

*/
void() monster_alouet =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model ("progs/h_alouet.mdl");
	precache_model ("progs/alouette.mdl");

	precache_sound ("chick/idle.wav");
	precache_sound ("chick/idle1.wav");
	precache_sound ("chick/pain.wav");
	precache_sound ("chick/painb.wav");
	precache_sound ("chick/atk.wav");
	precache_sound ("chick/die.wav");
	precache_sound ("chick/dieb.wav");
	precache_sound ("chick/walk.wav");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/alouette.mdl");

	setsize (self, '-24 -24 -24', '24 24 40');
	self.health = 150;

	self.th_stand = chick_stand1;
	self.th_walk = chick_walk1;
	self.th_run = chick_run1;
	self.th_pain = chick_pain;
	self.th_die = chick_die;
	self.th_melee = chick_atta1;
	self.th_missile = chick_leap1;

	walkmonster_start();
};
