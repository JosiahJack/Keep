/*

=============================================================================
Small covertion of the Doom Archville to a Quake1 model. Added some frames
and wrenched them a little up. madfox 2 dec 2008.
=============================================================================

*/
/*
==============================================================================

DOOMARCHVILLE
==============================================================================
*/

$cd /raid/quake/id1/models/arch
$origin 0 -6 24
$base base		
$skin skin

$frame stand1 stand2 stand3 stand4 stand5 stand6 

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10 walk11 walk12   

$frame run1 run2 run3 run4 run5 run6 run7  

$frame pain1 pain2 pain3 pain4 pain5 pain6

$frame painb1 painb2 painb3 painb4 painb5 painb6

$frame atk1 atk2 atk3 atk4 atk5 atk6 atk7 atk8 atk9 atk10 atk11

$frame atkb1 atkb2 atkb3 atkb4 atkb5 atkb6 atkb7 atkb8 atkb9 atkb10

$frame death1 death2 death3 death4 death5 death6 death7 death8 death9
$frame death10 death11 death12 

$frame deathb1 deathb2 deathb3 deathb4 deathb5 deathb6 deathb7 deathb8 deathb9
$frame deathb10 deathb11 deathb12 deathb13 deathb14

/*
==============================================================================
DOOMARCHVILLE CODE
==============================================================================
*/

void() arch_die1 ; 
void()	arch_dieb1 ; 
void()	arch_pain1 ;
void()	arch_painb1 ;

void() ArchLaser_Touch =
{
	local vector org;
	
	if (other == self.owner)
		return;		// don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	
	sound (self, CHAN_WEAPON, "enforcer/enfstop.wav", 1, ATTN_STATIC);
	org = self.origin - 8*normalize(self.velocity);

	if (other.health)
	{
		SpawnBlood (org, self.velocity*0.2, 15);
		T_Damage (other, self, self.owner, 15);
	}
	else
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);
	}
	
	remove(self);	
};

void(vector org, vector vec) ArchLaunchLaser =
{
	local	vector	vec;
		
	if (self.classname == "monster_enforcer")
		sound (self, CHAN_WEAPON, "enforcer/enfire.wav", 1, ATTN_NORM);

	vec = normalize(vec);
	
	newmis = spawn();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLY;
	newmis.solid = SOLID_BBOX;
	newmis.effects = EF_DIMLIGHT;

	setmodel (newmis, "progs/sjobal.mdl");
	setsize (newmis, '0 0 0', '0 0 0');		

	setorigin (newmis, org);

	newmis.velocity = vec * 600;
	newmis.angles = vectoangles(newmis.velocity);

	newmis.nextthink = time + 5;
	newmis.think = SUB_Remove;
	newmis.touch = ArchLaser_Touch;
};



void() arch_fire =
{
	local vector org;

	self.effects = self.effects | EF_MUZZLEFLASH;
	makevectors (self.angles);
	
	org = self.origin + v_forward * 30 + v_right * 2.5 + '0 0 24';

	ArchLaunchLaser(org, self.enemy.origin - self.origin);
};


void() arch_scratch =
{
local vector	delta;
local float 	ldmg;

	if (!self.enemy)
		return;

	ai_face ();
	walkmove (self.ideal_yaw, 12);	// allow a little closing


	ai_charge(10);

	if (!CanDamage (self.enemy, self))
		return;

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 100)
		return;
		
	ldmg = 10 + 5*random();
	T_Damage (self.enemy, self, self, ldmg);

	makevectors (self.angles);
	SpawnMeatSpray (self.origin + v_forward*16, v_right*16 );

	sound (self, CHAN_WEAPON, "arch/dsclaw.wav", 1, ATTN_NORM);

};

void()	arch_stand1	=[	$stand1,	arch_stand2	] {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "arch/dsdmact.wav", 1, ATTN_IDLE);
ai_stand();};
void()	arch_stand2	=[	$stand2,	arch_stand3	] {ai_stand();};
void()	arch_stand3	=[	$stand3,	arch_stand4	] {ai_stand();};
void()	arch_stand4	=[	$stand4,	arch_stand5	] {ai_stand();};
void()	arch_stand5	=[	$stand5,	arch_stand6	] {ai_stand();};
void()	arch_stand6	=[	$stand6,	arch_stand1	] {ai_stand();};

void()	arch_walk1	=[	$walk1,	arch_walk2	] {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "arch/dsdmact.wav", 1, ATTN_IDLE);
ai_walk(4);};
void()	arch_walk2	=[	$walk2, 	arch_walk3	] {ai_walk(8);};
void()	arch_walk3	=[	$walk3,	        arch_walk4	] {ai_walk(6);};
void()	arch_walk4	=[	$walk4,   	arch_walk5	] {ai_walk(8);};
void()	arch_walk5	=[	$walk5, 	arch_walk6	] {ai_walk(12);};
void()	arch_walk6	=[	$walk6, 	arch_walk7	] {ai_walk(10);};
void()	arch_walk7	=[	$walk7, 	arch_walk8	] {ai_walk(6);};
void()	arch_walk8	=[	$walk8,	        arch_walk9	] {ai_walk(8);};
void()	arch_walk9	=[	$walk9,   	arch_walk10	] {ai_walk(12);};
void()	arch_walk10	=[	$walk10, 	arch_walk11	] {ai_walk(8);};
void()	arch_walk11	=[	$walk11, 	arch_walk12	] {ai_walk(10);};
void()	arch_walk12	=[	$walk12, 	arch_walk1	] {ai_walk(8);};

void()	arch_run1	=[	$run1,		arch_run2	] {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "arch/dsdmact.wav", 1, ATTN_IDLE);
ai_run(11);};
void()	arch_run2	=[	$run2,		arch_run3	] {ai_run(15);};
void()	arch_run3	=[	$run3,		arch_run4	] {ai_run(15);};
void()	arch_run4	=[	$run4,		arch_run5	] {ai_run(10);};
void()	arch_run5	=[	$run5,		arch_run6	] {ai_run(12);};
void()	arch_run6	=[	$run6,		arch_run7	] {ai_run(15);};
void()	arch_run7	=[	$run7,		arch_run1	] {ai_run(15);};

void(entity attacker, float damage)	arch_pain =
{
	local float r;
	
	if (self.pain_finished > time)
		return;

	r = random();

	if (r < 0.3)
	{
		self.pain_finished = time + 6;
		arch_pain1 ();
                sound (self, CHAN_VOICE, "arch/dsdmpain.wav", 1, ATTN_IDLE);
 	}
	else if (r < 0.1)
	{
		self.pain_finished = time + 6;
                arch_painb1 ();
                sound (self, CHAN_VOICE, "arch/dspopain.wav", 1, ATTN_IDLE);
	}
	else if (r < 0.15)
		self.pain_finished = time + 6;
        
};

void()	arch_pain1	=[	$pain1,		arch_pain2	] {ai_painforward(5);};
void()	arch_pain2	=[	$pain2,		arch_pain3	] {ai_painforward(5);};
void()	arch_pain3	=[	$pain3,		arch_pain4	] {ai_painforward(5);};
void()	arch_pain4	=[	$pain4,		arch_pain5	] {ai_painforward(5);};
void()	arch_pain5	=[	$pain5,		arch_pain6	] {ai_painforward(5);};
void()	arch_pain6	=[	$pain6,		arch_run1	] {ai_pain(5);};

void()	arch_painb1	=[	$painb1,		arch_painb2	] {ai_painforward(5);};
void()	arch_painb2	=[	$painb2,		arch_painb3	] {ai_painforward(5);};
void()	arch_painb3	=[	$painb3,		arch_painb4	] {ai_painforward(5);};
void()	arch_painb4	=[	$painb4,		arch_painb5	] {ai_painforward(5);};
void()	arch_painb5	=[	$painb5,		arch_painb6	] {ai_painforward(5);};
void()	arch_painb6	=[	$painb6,		arch_run1	] {ai_pain(1);};

void()	arch_atk1	=[	$atk1, 	       arch_atk2	] {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "arch/dsposact.wav", 1, ATTN_IDLE);
ai_face();};
void()	arch_atk2	=[	$atk2, 	       arch_atk3	] {ai_face();};
void()	arch_atk3	=[	$atk3, 	       arch_atk4	] {ai_face();};
void()	arch_atk4	=[	$atk4, 	       arch_atk5	] {ai_face();};
void()	arch_atk5	=[	$atk5, 	       arch_atk6	] {ai_face();};
void()	arch_atk6	=[	$atk6, 	       arch_atk7	] {ai_face();};
void()	arch_atk7	=[	$atk7, 	       arch_atk8	] {ai_face();};
void()	arch_atk8	=[	$atk8, 	       arch_atk9	] {ai_face();};
void()	arch_atk9	=[	$atk9, 	       arch_atk10	] {ai_face();};
void()	arch_atk10	=[	$atk10,        arch_atk11	] {ai_face();};
void()	arch_atk11	=[	$atk11,        arch_run1	] {arch_fire();ai_face();};

void()	arch_atkb1	=[	$atkb1, 	arch_atkb2	] {ai_face();};
void()	arch_atkb2	=[	$atkb2, 	arch_atkb3	] {ai_face();};
void()	arch_atkb3	=[	$atkb3, 	arch_atkb4	] {ai_face();};
void()	arch_atkb4	=[	$atkb4, 	arch_atkb5	] {arch_scratch();ai_face();};
void()	arch_atkb5	=[	$atkb5, 	arch_atkb6	] {ai_face();};
void()	arch_atkb6	=[	$atkb6, 	arch_atkb7	] {ai_face();};
void()	arch_atkb7	=[	$atkb7, 	arch_atkb8	] {ai_face();};
void()	arch_atkb8	=[	$atkb8, 	arch_atkb9	] {ai_face();};
void()	arch_atkb9	=[	$atkb9, 	arch_atkb10	] {ai_face();};
void()	arch_atkb10	=[	$atkb10, 	arch_run1	] {ai_face();};

void() arch_die =
{
// check for gib
	if (self.health < -35)
	{
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		ThrowHead ("progs/p_head.mdl", self.health);
		ThrowGib ("progs/gib1.mdl", self.health);
		ThrowGib ("progs/gib2.mdl", self.health);
		ThrowGib ("progs/gib3.mdl", self.health);
		return;
	}

// regular death
	sound (self, CHAN_VOICE, "arch/dsbrsdth.wav", 1, ATTN_NORM);
	if (random() < 0.5)
		arch_die1 ();
        else
                arch_dieb1 ();	
};

void()	arch_die1	=[	$death1,  	arch_die2	] {};
void()	arch_die2	=[	$death2,  	arch_die3	] {};
void()	arch_die3	=[	$death3,  	arch_die4	] 
{self.solid = SOLID_NOT;};
void()	arch_die4	=[	$death4,        arch_die5	] {};
void()	arch_die5	=[	$death5,  	arch_die6	] {};
void()	arch_die6	=[	$death6,  	arch_die7	] {};
void()	arch_die7	=[	$death7,  	arch_die8	] {};
void()	arch_die8	=[	$death8,  	arch_die9	] {};
void()	arch_die9	=[	$death9,  	arch_die10	] {};
void()	arch_die10	=[	$death10,  	arch_die11	] {};
void()	arch_die11	=[	$death11,  	arch_die12	] {};
void()	arch_die12	=[	$death12,  	arch_die12	] {};

void()	arch_dieb1	=[	$deathb1,  	arch_dieb2	] {};
void()	arch_dieb2	=[	$deathb2,  	arch_dieb3	] {};
void()	arch_dieb3	=[	$deathb3,  	arch_dieb4	] 
{self.solid = SOLID_NOT;};
void()	arch_dieb4	=[	$deathb4,       arch_dieb5	] {};
void()	arch_dieb5	=[	$deathb5,  	arch_dieb6	] {};
void()	arch_dieb6	=[	$deathb6,  	arch_dieb7	] {};
void()	arch_dieb7	=[	$deathb7,  	arch_dieb8	] {};
void()	arch_dieb8	=[	$deathb8,  	arch_dieb9	] {};
void()	arch_dieb9	=[	$deathb9,  	arch_dieb10	] {};
void()	arch_dieb10	=[	$deathb10,  	arch_dieb11	] {};
void()	arch_dieb11	=[	$deathb11,  	arch_dieb12	] {};
void()	arch_dieb12	=[	$deathb12,  	arch_dieb13	] {};
void()	arch_dieb13	=[	$deathb13,  	arch_dieb14	] {};
void()	arch_dieb14	=[	$deathb14,  	arch_dieb14	] {};


void() arch_melee =

{
	if (random() > 0.3)
		arch_atkb1 ();
	else
		arch_atk1 ();
};


/*QUAKED monster_arch (1 0 0) (-16 -16 -24) (16 16 40) Ambush
*/
void() monster_arch =
{	
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model ("progs/arch.mdl");
	precache_model ("progs/p_head.mdl");
	precache_model ("progs/gib1.mdl");
	precache_model ("progs/gib2.mdl");
	precache_model ("progs/gib3.mdl");
        precache_model ("progs/sjobal.mdl");

	precache_sound ("arch/dsdmact.wav");
	precache_sound ("arch/dsdmpain.wav");
	precache_sound ("arch/dspopain.wav");
	precache_sound ("arch/dsbrsdth.wav");
	precache_sound ("arch/dsclaw.wav");
	precache_sound ("player/udeath.wav");
	precache_sound ("arch/dsposact.wav");		// gib death
        precache_sound ("enforcer/enfstop.wav");


	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/arch.mdl");

	setsize (self, '-16 -16 0', '16 16 40');
	self.health = 300;

	self.th_stand = arch_stand1;
	self.th_walk = arch_walk1;
	self.th_run = arch_run1;
	self.th_pain = arch_pain;
	self.th_die = arch_die;
        self.th_melee = arch_atkb1;
        self.th_missile = arch_atk1;

	walkmonster_start ();
};

