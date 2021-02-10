/*==============================================================================

MANTICORN - by MadFox.

==============================================================================*/
$cd /raid/quake/id1/models/mcorn
$origin 0 0 24
$base base
$skin skin

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9 stand10
$frame stand11 stand12 stand13 stand14 stand15 stand16 stand17

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10
$frame walk11 walk12 walk13 walk14 walk15 walk16 walk17

$frame run1 run2 run3 run4 run5 run6 run7 run8

$frame pain1 pain2 pain3 pain4 pain5 pain6 pain7 pain8

$frame paina1 paina2 paina3 paina4 paina5 paina6

$frame atk1 atk2 atk3 atk4 atk5 atk6 atk7 atk8 atk9 atk10 atk11

$frame atka1 atka2 atka3 atka4 atka5 atka6 atka7 atka8 atka9 atka10 atka11
$frame atka12 atka13

$frame atkb1 atkb2 atkb3 atkb4 atkb5 atkb6 atkb7

$frame die1 die2 die3 die4 die5 die6 die7 die8 die9 die10 die11 die12
$frame die13 die14 die15 die16 die17 die18 die19 die20 die21 die22 die23 die24

$frame dieb1 dieb2 dieb3 dieb4 dieb5 dieb6 dieb7 dieb8 dieb9 dieb10 dieb11 dieb12
$frame dieb13 dieb14 dieb15 dieb16 dieb17 dieb18 dieb19 dieb20 dieb21 dieb22 dieb23 
$frame dieb24 dieb25

/*================
mcorn_bite

================*/
void() mcorn_bite =
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
		
	ldmg = (random() + random() + random()) * 8;
	T_Damage (self.enemy, self, self, ldmg);
};

void() McLaser_Touch =
{
	local vector org;
	
	if (other == self.owner)
		return;		// don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	
	sound (self, CHAN_WEAPON, "mcorn/enfstop.wav", 1, ATTN_STATIC);
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

void(vector org, vector vec) McLaunchLaser =
{		
	if (self.classname == "monster_mcorn")
		sound (self, CHAN_WEAPON, "mcorn/enfire.wav", 1, ATTN_NORM);

	vec = normalize(vec);
	
	newmis = spawn();
	newmis.classname = "mcorn_laser";	//gnounc
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLY;
	newmis.solid = SOLID_BBOX;
	newmis.effects = EF_DIMLIGHT;

	setmodel (newmis, "progs/ucorn.mdl");
	setsize (newmis, '0 0 0', '0 0 0');		

	setorigin (newmis, org);

	newmis.velocity = vec * 600;
	newmis.angles = vectoangles(newmis.velocity);

	newmis.nextthink = time + 5;
	newmis.think = SUB_Remove;
	newmis.touch = McLaser_Touch;
};



void() mcorn_fire =
{
	local vector org;

	self.effects = self.effects | EF_MUZZLEFLASH;
	makevectors2 (self.angles);
	
	org = self.origin + v_forward * 30 + v_right * 8.5 + '0 0 16';

	McLaunchLaser(org, self.enemy.origin - self.origin);
};

//=================================================================================

void() mcorn_stand1	=[	$stand1,	mcorn_stand2	] {ai_stand();};
void() mcorn_stand2	=[	$stand2,	mcorn_stand3	] {ai_stand();};
void() mcorn_stand3	=[	$stand3,	mcorn_stand4	] {ai_stand();};
void() mcorn_stand4	=[	$stand4,	mcorn_stand5	] {ai_stand();};
void() mcorn_stand5	=[	$stand5,	mcorn_stand6	] {ai_stand();};
void() mcorn_stand6	=[	$stand6,	mcorn_stand7	] {ai_stand();};
void() mcorn_stand7	=[	$stand7,	mcorn_stand8	] {ai_stand();};
void() mcorn_stand8	=[	$stand8,	mcorn_stand9	] {ai_stand();};
void() mcorn_stand9	=[	$stand9,	mcorn_stand10	] {ai_stand();};
void() mcorn_stand10	=[	$stand10,	mcorn_stand11	] {ai_stand();};
void() mcorn_stand11	=[	$stand11,	mcorn_stand12	] {ai_stand();};
void() mcorn_stand12	=[	$stand12,	mcorn_stand13	] {ai_stand();};
void() mcorn_stand13	=[	$stand13,	mcorn_stand14	] {ai_stand();};
void() mcorn_stand14	=[	$stand14,	mcorn_stand15	] {ai_stand();};
void() mcorn_stand15	=[	$stand15,	mcorn_stand16	] {ai_stand();};
void() mcorn_stand16	=[	$stand16,	mcorn_stand17	] {ai_stand();};
void() mcorn_stand17	=[	$stand17,	mcorn_stand1	] {ai_stand();};

void() mcorn_walk1	=[	$walk1, 	mcorn_walk2	] {ai_walk(8);};
void() mcorn_walk2	=[	$walk2, 	mcorn_walk3	] {ai_walk(8);};
void() mcorn_walk3	=[	$walk3, 	mcorn_walk4	] {ai_walk(8);};
void() mcorn_walk4	=[	$walk4, 	mcorn_walk5	] {ai_walk(8);};
void() mcorn_walk5	=[	$walk5, 	mcorn_walk6	] {ai_walk(8);};
void() mcorn_walk6	=[	$walk6, 	mcorn_walk7	] {ai_walk(8);};
void() mcorn_walk7	=[	$walk7, 	mcorn_walk8	] {ai_walk(8);};
void() mcorn_walk8	=[	$walk8, 	mcorn_walk9	] {ai_walk(8);};
void() mcorn_walk9	=[	$walk9, 	mcorn_walk10	] {ai_walk(8);};
void() mcorn_walk10	=[	$walk10,	mcorn_walk11	] {ai_walk(8);};
void() mcorn_walk11	=[	$walk11,	mcorn_walk12	] {ai_walk(8);};
void() mcorn_walk12	=[	$walk12,	mcorn_walk13	] {ai_walk(8);};
void() mcorn_walk13	=[	$walk13,	mcorn_walk14	] {ai_walk(8);};
void() mcorn_walk14	=[	$walk14,	mcorn_walk15	] {ai_walk(8);};
void() mcorn_walk15	=[	$walk15,	mcorn_walk16	] {ai_walk(8);};
void() mcorn_walk16	=[	$walk16,	mcorn_walk17	] {ai_walk(8);};
void() mcorn_walk17	=[	$walk17,	mcorn_walk1	] {ai_walk(8);};

void() mcorn_run1		=[	$run1  ,	mcorn_run2	] 
{
	if (random() < 0.2)
		sound (self, CHAN_VOICE, "mcorn/idle.wav", 1, ATTN_IDLE);
	ai_run(16);
};

void() mcorn_run2		=[	$run2  ,	mcorn_run3	] {ai_run(32);};
void() mcorn_run3		=[	$run3  ,	mcorn_run4	] {ai_run(32);};
void() mcorn_run4		=[	$run4  ,	mcorn_run5	] {ai_run(20);};
void() mcorn_run5		=[	$run5  ,	mcorn_run6	] {ai_run(64);};
void() mcorn_run6		=[	$run6  ,	mcorn_run7	] {ai_run(32);};
void() mcorn_run7		=[	$run7  ,	mcorn_run8	] {ai_run(16);};
void() mcorn_run8		=[	$run8  ,	mcorn_run1	] {ai_run(32);};

//=================================================================================

void() mcorn_atk1	=[	$atk1,	mcorn_atk2	] {ai_charge(10);};
void() mcorn_atk2	=[	$atk2,	mcorn_atk3	] {ai_charge(10);};
void() mcorn_atk3	=[	$atk3,	mcorn_atk4	] {ai_charge(10);};
void() mcorn_atk4	=[	$atk4,	mcorn_atk5	] 
{
	sound (self, CHAN_VOICE, "mcorn/atk1.wav", 1, ATTN_NORM);
	mcorn_bite();
};

void() mcorn_atk5	=[	$atk5,	mcorn_atk6	] {ai_charge(10);};
void() mcorn_atk6	=[	$atk6,	mcorn_atk7	] {ai_charge(10);};
void() mcorn_atk7	=[	$atk7,	mcorn_atk8	] {ai_charge(10);};
void() mcorn_atk8	=[	$atk8,	mcorn_run1	] {ai_charge(10);};
void() mcorn_atk9	=[	$atk9,	mcorn_atk6	] {ai_charge(10);};
void() mcorn_atk10	=[	$atk6,	mcorn_atk7	] {ai_charge(10);};
void() mcorn_atk11	=[	$atk7,	mcorn_atk8	] {ai_charge(10); mcorn_fire();};

void() mcorn_atka1	=[	$atka1,	mcorn_atka2	] {ai_charge(10);};
void() mcorn_atka2	=[	$atka2,	mcorn_atka3	] {ai_charge(10);};
void() mcorn_atka3	=[	$atka3,	mcorn_atka4	] {ai_charge(10);};
void() mcorn_atka4	=[	$atka4,	mcorn_atka5	] 
{
	sound (self, CHAN_VOICE, "mcorn/atka1.wav", 1, ATTN_NORM);
	mcorn_bite();
};

void() mcorn_atka5	=[	$atka5,	mcorn_atka6	] {ai_charge(10);};
void() mcorn_atka6	=[	$atka6,	mcorn_atka7	] {ai_charge(10);};
void() mcorn_atka7	=[	$atka7,	mcorn_atka8	] {ai_charge(10);};
void() mcorn_atka8	=[	$atka8,	mcorn_atka9	] {ai_charge(10);};
void() mcorn_atka9	=[	$atka9,	mcorn_atka10	] {ai_charge(10);};
void() mcorn_atka10	=[	$atka11,	mcorn_atka11	] {ai_charge(10);};
void() mcorn_atka11	=[	$atka12,	mcorn_atka12	] {ai_charge(10);};
void() mcorn_atka12	=[	$atka13,	mcorn_atka1	] {ai_charge(10);};

void() mcorn_atkb1	=[	$atkb1,	mcorn_atkb2	] {ai_charge(10);};
void() mcorn_atkb2	=[	$atkb2,	mcorn_atkb3	] {ai_charge(10);};
void() mcorn_atkb3	=[	$atkb3,	mcorn_atkb4	] {ai_charge(10);};
void() mcorn_atkb4	=[	$atkb4,	mcorn_atkb5	] 
{
	sound (self, CHAN_VOICE, "mcorn/atkb1.wav", 1, ATTN_NORM);
	mcorn_bite();
};

void() mcorn_atkb5	=[	$atkb5,	mcorn_atkb6	] {ai_charge(10);};
void() mcorn_atkb6	=[	$atkb6,	mcorn_atkb1	] {ai_charge(10);};

//=================================================================================

void() mcorn_pain1	=[	$pain1 ,	mcorn_pain2	] {};
void() mcorn_pain2	=[	$pain2 ,	mcorn_pain3	] {};
void() mcorn_pain3	=[	$pain3 ,	mcorn_pain4	] {};
void() mcorn_pain4	=[	$pain4 ,	mcorn_pain5	] {};
void() mcorn_pain5	=[	$pain5 ,	mcorn_pain6	] {};
void() mcorn_pain6	=[	$pain6 ,	mcorn_run1	] {};

void() mcorn_paina1	=[	$paina1 ,	mcorn_paina2	] {};
void() mcorn_paina2	=[	$paina2 ,	mcorn_paina3	] {};
void() mcorn_paina3	=[	$paina3 ,	mcorn_paina4	] {ai_pain(4);};
void() mcorn_paina4	=[	$paina4 ,	mcorn_paina5	] {ai_pain(12);};
void() mcorn_paina5	=[	$paina5 ,	mcorn_paina6	] {ai_pain(12);};
void() mcorn_paina6	=[	$paina6 ,	mcorn_run1	] {ai_pain(2);};

void(entity attacker, float damage) mcorn_pain =
{
	local float r;

	r = random ();
	if (self.pain_finished > time)
		return;

	sound (self, CHAN_VOICE, "mcorn/dpain1.wav", 1, ATTN_NORM);

	if (random() > 0.5)
		mcorn_pain1 ();

	else
		mcorn_paina1 ();
};

//=================================================================================

void() mcorn_die1		=[	$die1,	mcorn_die2	] {};
void() mcorn_die2		=[	$die2,	mcorn_die3	] {};
void() mcorn_die3		=[	$die3,	mcorn_die4	] {};
void() mcorn_die4		=[	$die4,	mcorn_die5	] {};
void() mcorn_die5		=[	$die5,	mcorn_die6	] {};
void() mcorn_die6		=[	$die6,	mcorn_die7	] {};
void() mcorn_die7		=[	$die7,	mcorn_die8	] {};
void() mcorn_die8		=[	$die8,	mcorn_die9	] {};
void() mcorn_die9		=[	$die9,	mcorn_die10 	] {};
void() mcorn_die10		=[	$die10,	mcorn_die11	] {};
void() mcorn_die11		=[	$die11,	mcorn_die12	] {};
void() mcorn_die12		=[	$die12,	mcorn_die13	] {};
void() mcorn_die13		=[	$die13,	mcorn_die14	] {};
void() mcorn_die14		=[	$die14,	mcorn_die15	] {};
void() mcorn_die15		=[	$die15,	mcorn_die16	] {};
void() mcorn_die16		=[	$die16,	mcorn_die17	] {};
void() mcorn_die17		=[	$die17,	mcorn_die18	] {};
void() mcorn_die18		=[	$die18,	mcorn_die19	] {};
void() mcorn_die19		=[	$die19,	mcorn_die20 	] {};
void() mcorn_die20		=[	$die20,	mcorn_die21	] {};
void() mcorn_die21		=[	$die21,	mcorn_die22	] {};
void() mcorn_die22		=[	$die22,	mcorn_die23	] {};
void() mcorn_die23		=[	$die23,	mcorn_die24	] {};
void() mcorn_die24		=[	$die24,	mcorn_die24	] {};

void() mcorn_dieb1		=[	$dieb1,	mcorn_dieb2	] {};
void() mcorn_dieb2		=[	$dieb2,	mcorn_dieb3	] {};
void() mcorn_dieb3		=[	$dieb3,	mcorn_dieb4	] {};
void() mcorn_dieb4		=[	$dieb4,	mcorn_dieb5	] {};
void() mcorn_dieb5		=[	$dieb5,	mcorn_dieb6	] {};
void() mcorn_dieb6		=[	$dieb6,	mcorn_dieb7	] {};
void() mcorn_dieb7		=[	$dieb7,	mcorn_dieb8	] {};
void() mcorn_dieb8		=[	$dieb8,	mcorn_dieb9	] {};
void() mcorn_dieb9		=[	$dieb9,	mcorn_dieb10 	] {};
void() mcorn_dieb10		=[	$dieb10,	mcorn_dieb11	] {};
void() mcorn_dieb11		=[	$dieb11,	mcorn_dieb12	] {};
void() mcorn_dieb12		=[	$dieb12,	mcorn_dieb13	] {};
void() mcorn_dieb13		=[	$dieb13,	mcorn_dieb14	] {};
void() mcorn_dieb14		=[	$dieb14,	mcorn_dieb15	] {};
void() mcorn_dieb15		=[	$dieb15,	mcorn_dieb16	] {};
void() mcorn_dieb16		=[	$dieb16,	mcorn_dieb17	] {};
void() mcorn_dieb17		=[	$dieb17,	mcorn_dieb18	] {};
void() mcorn_dieb18		=[	$dieb18,	mcorn_dieb19	] {};
void() mcorn_dieb19		=[	$dieb19,	mcorn_dieb20 	] {};
void() mcorn_dieb20		=[	$dieb20,	mcorn_dieb21	] {};
void() mcorn_dieb21		=[	$dieb21,	mcorn_dieb22	] {};
void() mcorn_dieb22		=[	$dieb22,	mcorn_dieb23	] {};
void() mcorn_dieb23		=[	$dieb23,	mcorn_dieb24	] {};
void() mcorn_dieb24		=[	$dieb24,	mcorn_dieb25	] {};
void() mcorn_dieb25		=[	$dieb25,	mcorn_dieb25	] {};


void() mcorn_die =
{
	// check for gib
	if (self.health < -35)
	{
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		ThrowGib ("progs/gib3.mdl", self.health);
		ThrowGib ("progs/gib3.mdl", self.health);
		ThrowGib ("progs/gib3.mdl", self.health);
		ThrowHead ("progs/h_mcorn.mdl", self.health);
		return;
	}

	// regular death
	sound (self, CHAN_VOICE, "mcorn/ddeath.wav", 1, ATTN_NORM);
	self.solid = SOLID_NOT;

	if (random() > 0.5)
		mcorn_die1 ();
	
	else
		mcorn_dieb1 ();
};

void() mcorn_melee =
{
	local float r;

	r = random ();
	if (self.pain_finished > time)
		return;

	sound (self, CHAN_VOICE, "mcorn/dpain1.wav", 1, ATTN_NORM);

	if (random() > 0.5)
		mcorn_atka1 ();

	else
		mcorn_atkb1 ();
};

//===========================================================================

/*QUAKED monster_mcorn (1 0 0) (-32 -32 -24) (32 32 40) Ambush*/
void() monster_mcorn =
{
	// Check for any random monster setups
	if (monster_checkrandomizer() == TRUE) return;
	// Check all spawn exceptions (monsters.qc)
	if (monster_checkspawn() == TRUE) return;

	precache_model ("progs/ucorn.mdl");
	precache_model ("progs/mcorn.mdl");

	precache_sound ("mcorn/dattack1.wav");
	precache_sound ("mcorn/ddeath.wav");
	precache_sound ("mcorn/dpain1.wav");
	precache_sound ("mcorn/dsight.wav");
	precache_sound ("mcorn/idle.wav");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/mcorn.mdl");

	//gnounc
	self.noise = "mcorn/dsight.wav";	
	self.netname = "Manticorn";
	if (self.deathstring == "") self.deathstring = " was mauled by a Manticorn\n";

	setsize (self, '-32 -32 -24', '32 32 40');
	self.health = 200;
	self.max_health = 200;

	// Check for random rotation setup and angle limits
	if (self.angles_y < 0) self.angles_y = rint(random()*359);
	if (self.angles_y > 360) self.angles_y = 360;

	self.th_stand = mcorn_stand1;
	self.th_walk = mcorn_walk1;
	self.th_run = mcorn_run1;
	self.th_pain = mcorn_pain;
	self.th_die = mcorn_die;
	self.th_melee = mcorn_melee;
	self.th_missile = mcorn_atk1;

	monster_start();
};
