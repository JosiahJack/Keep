/*==============================================================================

SHREDDER - Q1_ShadowRider from MadFox.

==============================================================================*/

$cd /raid/quake/id1/models/shredder.mdl
//$scale	0.8
$origin 0 0 24
$base base
$skin base

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9
$frame stand10 stand11 stand12 stand13 stand14 stand15 stand16 stand17
$frame stand18 stand19 

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10 walk11 
$frame walk12 walk13 walk14 walk15 walk16 walk17

$frame run1 run2 run3 run4 run5 run6 run7 run8

$frame atk1 atk2 atk3 atk4 atk5 atk6 atk7 atk8 

$frame atka1 atka2 atka3 atka4 atka5 atka6 atka7 

$frame runatk1 runatk2 runatk3 runatk4 runatk5 runatk6 runatk7 runatk8 

$frame pain1 pain2 pain3 pain4 pain5 pain6 pain7 

$frame paina1 paina2 paina3 paina4 paina5 paina6 paina7

$frame jump1 jump2 jump3 jump4 jump5 jump6 jump7 jump8 jump9

$frame die1 die2 die3 die4 die5 die6 die7 die8 die9 die10 die11 die12 die13 die14

$frame diea1 diea2 diea3 diea4 diea5 diea6 diea7 diea8 diea9 diea10 diea11 diea12
$frame diea13 


//==============================================================================

void()	shred_stand1	=[	$stand1,  	shred_stand2	] {ai_stand();};
void()	shred_stand2	=[	$stand2,  	shred_stand3	] {ai_stand();};
void()	shred_stand3	=[	$stand3,  	shred_stand4	] {ai_stand();};
void()	shred_stand4	=[	$stand4,  	shred_stand5	] {ai_stand();};
void()	shred_stand5	=[	$stand5,  	shred_stand6	] {ai_stand();};
void()	shred_stand6	=[	$stand6,  	shred_stand7	] {ai_stand();};
void()	shred_stand7	=[	$stand7,  	shred_stand8	] {ai_stand();};
void()	shred_stand8	=[	$stand8,  	shred_stand9	] {ai_stand();};
void()	shred_stand9	=[	$stand9,  	shred_stand10	] {ai_stand();};
void()	shred_stand10	=[	$stand10, 	shred_stand11	] {ai_stand();};
void()	shred_stand11	=[	$stand11, 	shred_stand12	] {ai_stand();};
void()	shred_stand12	=[	$stand12, 	shred_stand13	] {ai_stand();};
void()	shred_stand13	=[	$stand13, 	shred_stand14	] {ai_stand();};
void()	shred_stand14	=[	$stand14, 	shred_stand15	] {ai_stand();};
void()	shred_stand15	=[	$stand15, 	shred_stand16	] {ai_stand();};
void()	shred_stand16	=[	$stand16,  	shred_stand17	] {ai_stand();};
void()	shred_stand17	=[	$stand17,  	shred_stand18	] {ai_stand();};
void()	shred_stand18	=[	$stand18,  	shred_stand19	] {ai_stand();};
void()	shred_stand19	=[	$stand19,  	shred_stand1	] {ai_stand();};

//==============================================================================

void()	shred_walk1	=[	$walk1,  	shred_walk2	] {ai_walk(2);};
void()	shred_walk2	=[	$walk2,  	shred_walk3	] {ai_walk(3);};
void()	shred_walk3	=[	$walk3,  	shred_walk4	] {ai_walk(4);};
void()	shred_walk4	=[	$walk4,  	shred_walk5	] {ai_walk(3);};
void()	shred_walk5	=[	$walk5,  	shred_walk6	] {ai_walk(3);};
void()	shred_walk6	=[	$walk6,  	shred_walk7	] {ai_walk(3);};
void()	shred_walk7	=[	$walk7,  	shred_walk8	] {ai_walk(4);};
void()	shred_walk8	=[	$walk8,  	shred_walk9	] {ai_walk(3);};
void()	shred_walk9	=[	$walk9,  	shred_walk10	] {ai_walk(3);};
void()	shred_walk10	=[	$walk10, 	shred_walk11	] {ai_walk(2);};
void()	shred_walk11	=[	$walk11, 	shred_walk12	] {ai_walk(3);};
void()	shred_walk12	=[	$walk12, 	shred_walk13	] {ai_walk(4);};
void()	shred_walk13	=[	$walk13, 	shred_walk14	] {ai_walk(3);};
void()	shred_walk14	=[	$walk14,  	shred_walk15	] {ai_walk(2);};
void()	shred_walk15	=[	$walk15,  	shred_walk16	] {ai_walk(3);};
void()	shred_walk16	=[	$walk16,  	shred_walk17	] {ai_walk(3);};
void()	shred_walk17	=[	$walk17,  	shred_walk1	] {ai_walk(4);};

//==============================================================================

void()	shred_run1	=[	$run1,  	shred_run2	] {ai_run(16);};
void()	shred_run2	=[	$run2,  	shred_run3	] {ai_run(20);};
void()	shred_run3	=[	$run3,  	shred_run4	] {ai_run(13);};
void()	shred_run4	=[	$run4,  	shred_run5	] {ai_run(6);};
void()	shred_run5	=[	$run5,  	shred_run6	] {ai_run(20);};
void()	shred_run6	=[	$run6,  	shred_run7	] {ai_run(14);};
void()	shred_run7	=[	$run7,  	shred_run8	] {ai_run(13);};
void()	shred_run8	=[	$run8,  	shred_run1	] {ai_run(6);};

//==============================================================================

void()	shred_atk1	=[	$atk1,  	shred_atk2	] {ai_charge(7);};
void()	shred_atk2	=[	$atk2,  	shred_atk3	] {ai_charge(4);};
void()	shred_atk3	=[	$atk3,  	shred_atk4	] {ai_charge(0);};
void()	shred_atk4	=[	$atk4,  	shred_atk5	] {ai_charge(7);};
void()	shred_atk5	=[	$atk5,  	shred_atk6	] {ai_charge(3); ai_melee();};
void()	shred_atk6	=[	$atk6,  	shred_atk7	] {ai_charge(4); ai_melee();};
void()	shred_atk7	=[	$atk7,  	shred_atk8	] {ai_charge(7);};
void()	shred_atk8	=[	$atk8,  	shred_run1	] {};

void()	shred_atka1	=[	$atka1,  	shred_atka2	] {ai_charge(7);};
void()	shred_atka2	=[	$atka2,  	shred_atka3	] {ai_charge(4);};
void()	shred_atka3	=[	$atka3,  	shred_atka4	] {ai_charge(0);};
void()	shred_atka4	=[	$atka4,  	shred_atka5	] {ai_charge(7);};
void()	shred_atka5	=[	$atka5,  	shred_atka6	] {ai_charge(4); ai_melee();};
void()	shred_atka6	=[	$atka6,  	shred_atka7	] {ai_charge(7); ai_melee();};
void()	shred_atka7	=[	$atka7,  	shred_run1	] {};

void()	shred_runatk1	=[	$runatk1,  	shred_runatk2	] {ai_charge(20);};
void()	shred_runatk2	=[	$runatk2,  	shred_runatk3	] {ai_charge_side();};
void()	shred_runatk3	=[	$runatk3,  	shred_runatk4	] {ai_charge_side();};
void()	shred_runatk4	=[	$runatk4,  	shred_runatk5	] {ai_melee_side();};
void()	shred_runatk5	=[	$runatk5,  	shred_runatk6	] {ai_melee_side();};
void()	shred_runatk6	=[	$runatk6,  	shred_runatk7	] {ai_melee_side();};
void()	shred_runatk7	=[	$runatk7,  	shred_runatk8	] {ai_charge_side();};
void()	shred_runatk8	=[	$runatk8,  	shred_run1	] {ai_charge(10);};

//================================================================================

void()	shred_pain1	=[	$pain1,		shred_pain2	] {};
void()	shred_pain2	=[	$pain2,		shred_pain3	] {};
void()	shred_pain3	=[	$pain3,		shred_pain4	] {};
void()	shred_pain4	=[	$pain4,		shred_pain5	] {};
void()	shred_pain5	=[	$pain5,		shred_pain6	] {};
void()	shred_pain6	=[	$pain6,		shred_pain7	] {};
void()	shred_pain7	=[	$pain7,		shred_run1	] {};

//==============================================================================

void()	shred_paina1	=[	$paina1,	shred_paina2	] {ai_painforward(0);};
void()	shred_paina2	=[	$paina2,	shred_paina3	] {};
void()	shred_paina3	=[	$paina3,	shred_paina4	] {ai_painforward(2);};
void()	shred_paina4	=[	$paina4,	shred_paina5	] {ai_painforward(3);};
void()	shred_paina5	=[	$paina5,	shred_paina6	] {ai_painforward(4);};
void()	shred_paina6	=[	$paina6,	shred_paina7	] {ai_painforward(3);};
void()	shred_paina7	=[	$paina7,	shred_run1	] {};

//==============================================================================

void()	shred_jump1	=[	$jump1, 	shred_jump2	] {ai_painforward(0);};
void()	shred_jump2	=[	$jump2, 	shred_jump3	] {};
void()	shred_jump3	=[	$jump3, 	shred_jump4	] {ai_painforward(3);};
void()	shred_jump4	=[	$jump4, 	shred_jump5	] {ai_painforward(4);};
void()	shred_jump5	=[	$jump5, 	shred_jump6	] {};
void()	shred_jump6	=[	$jump6, 	shred_jump7	] {};
void()	shred_jump7	=[	$jump7, 	shred_jump8	] {ai_painforward(3);};
void()	shred_jump8	=[	$jump8, 	shred_jump9	] {ai_painforward(4);};
void()	shred_jump9	=[	$jump9, 	shred_run1	] {};

void(entity attacker, float damage)	shred_pain =
{
	local float r;

	if (self.pain_finished > time)
		return;

	r = random();
	
	sound (self, CHAN_VOICE, "knight/khurt.wav", 1, ATTN_NORM);
	if (r < 0.2)
	{
		shred_pain1 ();
		self.pain_finished = time + 1;
	}
	if (r < 0.6)
	{
		shred_paina1 ();
		self.pain_finished = time + 1;
	}
	else
	{
		shred_jump1 ();
		self.pain_finished = time + 1;
	}
	
};

//=======================================================================

void()	shred_die1	=[	$die1,  	shred_die2	] {};
void()	shred_die2	=[	$die2,  	shred_die3	] {};
void()	shred_die3	=[	$die3,  	shred_die4	] {};
void()	shred_die4	=[	$die4,  	shred_die5	] {};
void()	shred_die5	=[	$die5,  	shred_die6	] {};
void()	shred_die6	=[	$die6,  	shred_die7	] {};
void()	shred_die7	=[	$die7,  	shred_die8	] {};
void()	shred_die8	=[	$die8,  	shred_die9	] {};
void()	shred_die9	=[	$die9,  	shred_die10	] {};
void()	shred_die10	=[	$die10, 	shred_die11	] {};
void()	shred_die11	=[	$die11, 	shred_die12	] {};
void()	shred_die12	=[	$die12, 	shred_die13	] {};
void()	shred_die13	=[	$die13, 	shred_die14	] {};
void()	shred_die14	=[	$die14,  	shred_die14	] {};

void()	shred_diea1	=[	$diea1,  	shred_diea2	] {};
void()	shred_diea2	=[	$diea2,  	shred_diea3	] {};
void()	shred_diea3	=[	$diea3,  	shred_diea4	] {};
void()	shred_diea4	=[	$diea4,  	shred_diea5	] {};
void()	shred_diea5	=[	$diea5,  	shred_diea6	] {};
void()	shred_diea6	=[	$diea6,  	shred_diea7	] {};
void()	shred_diea7	=[	$diea7,  	shred_diea8	] {};
void()	shred_diea8	=[	$diea8,  	shred_diea9	] {};
void()	shred_diea9	=[	$diea9,  	shred_diea10	] {};
void()	shred_diea10	=[	$diea10, 	shred_diea11	] {};
void()	shred_diea11	=[	$diea11, 	shred_diea12	] {};
void()	shred_diea12	=[	$diea12, 	shred_diea13	] {};
void()	shred_diea13	=[	$diea13, 	shred_diea13	] {};

void() shred_die =
{
// check for gib
	if (self.health < -40)
	{
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		ThrowHead ("progs/h_knight.mdl", self.health);
		ThrowGib ("progs/gib1.mdl", self.health);
		ThrowGib ("progs/gib2.mdl", self.health);
		ThrowGib ("progs/gib3.mdl", self.health);
		return;
	}

// regular death
	sound (self, CHAN_VOICE, "knight/kdeath.wav", 1, ATTN_NORM);
	if (random() < 0.5)
		shred_die1 ();
	else
		shred_diea1 ();
};

void() shred_melee =
{
	if (random() > 0.5)
		shred_atk1 ();
	else
		shred_atka1 ();
};


//=================================================================================

/*QUAKED monster_shredder (1 0 0) (-16 -16 -24) (16 16 40) Ambush
*/
void() monster_shredder =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model ("progs/shredder.mdl");
//	precache_model ("progs/h_shredder.mdl");

	precache_sound ("knight/kdeath.wav");
	precache_sound ("knight/khurt.wav");
	precache_sound ("knight/ksight.wav");
	precache_sound ("knight/sword1.wav");
	precache_sound ("knight/sword2.wav");
	precache_sound ("knight/idle.wav");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/shredder.mdl");

	setsize (self, '-16 -16 -24', '16 16 40');
	self.health = 75;

	self.th_stand = shred_stand1;
	self.th_walk = shred_walk1;
	self.th_run = shred_run1;
	self.th_melee = shred_melee;
	self.th_pain = shred_pain;
	self.th_die = shred_die;
        self.th_missile = shred_runatk1;
	
	walkmonster_start ();
};








