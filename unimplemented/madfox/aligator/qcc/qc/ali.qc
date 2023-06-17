/*
==============================================================================

DOG

==============================================================================
*/
$cd id1/models/ali
$origin 0 0 24
$base base
$skin skin

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9 stand10
$frame stand11 stand12 stand13 stand14 stand15 stand16 

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10
$frame walk11 walk12 walk13 walk14 walk15 walk16 walk17

$frame run1 run2 run3 run4 run5 run6 run7 run8

$frame jump1 jump2 jump3 jump4 jump5 jump6 jump7 

$frame runatk1 runatk2 runatk3 runatk4 runatk5 runatk6 runatk7 runatk8

$frame pain1 pain2 pain3 pain4 pain5 pain6

$frame painb1 painb2 painb3 painb4 painb5 painb6 painb7 painb8 painb9 painb10
$frame painb11 painb12 painb13 painb14

$frame painc1 painc2 painc3 painc4 painc5 painc6

$frame atk1 atk2 atk3 atk4 atk5 atk6 atk7

$frame atka1 atka2 atka3 atka4 atka5 atka6 atka7 atka8 atka9

$frame atkb1 atkb2 atkb3 atkb4 atkb5 atkb6 atkb7 atkb8 atkb9

$frame death1 death2 death3 death4 death5 death6 death7 death8 death9 death10
$frame death11 death12 death13 death14 death15 death16 

$frame deatha1 deatha2 deatha3 deatha4 deatha5 deatha6 deatha7 deatha8 deatha9 
$frame deatha10 deatha11 deatha12 deatha13 deatha14 deatha15 deatha16 

//==============================================================================

void() ali_stand1	=[	$stand1,	ali_stand2	] {ai_stand();};
void() ali_stand2	=[	$stand2,	ali_stand3	] {ai_stand();};
void() ali_stand3	=[	$stand3,	ali_stand4	] {ai_stand();};
void() ali_stand4	=[	$stand4,	ali_stand5	] {ai_stand();};
void() ali_stand5	=[	$stand5,	ali_stand6	] {ai_stand();};
void() ali_stand6	=[	$stand6,	ali_stand7	] {ai_stand();};
void() ali_stand7	=[	$stand7,	ali_stand8	] {ai_stand();};
void() ali_stand8	=[	$stand8,	ali_stand9	] {ai_stand();};
void() ali_stand9	=[	$stand9,	ali_stand10	] {ai_stand();};
void() ali_stand10	=[	$stand10,	ali_stand11	] {ai_stand();};
void() ali_stand11	=[	$stand11,	ali_stand12	] {ai_stand();};
void() ali_stand12	=[	$stand12,	ali_stand13	] {ai_stand();};
void() ali_stand13	=[	$stand13,	ali_stand14	] {ai_stand();};
void() ali_stand14	=[	$stand14,	ali_stand15	] {ai_stand();};
void() ali_stand15	=[	$stand15,	ali_stand16	] {ai_stand();};
void() ali_stand16	=[	$stand16,	ali_stand1	] {ai_stand();};

void() ali_walk1	=[	$walk1 ,	ali_walk2	] {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "ali/idle.wav", 1, ATTN_IDLE);
ai_walk(8);};
void() ali_walk2	=[	$walk2 ,	ali_walk3	] {ai_walk(8);};
void() ali_walk3	=[	$walk3 ,	ali_walk4	] {ai_walk(8);};
void() ali_walk4	=[	$walk4 ,	ali_walk5	] {ai_walk(8);};
void() ali_walk5	=[	$walk5 ,	ali_walk6	] {ai_walk(8);};
void() ali_walk6	=[	$walk6 ,	ali_walk7	] {ai_walk(8);};
void() ali_walk7	=[	$walk7 ,	ali_walk8	] {ai_walk(8);};
void() ali_walk8	=[	$walk8 ,	ali_walk9	] {ai_walk(8);};
void() ali_walk9	=[	$walk9 ,	ali_walk10	] {ai_walk(8);};
void() ali_walk10	=[	$walk10 ,	ali_walk11	] {ai_walk(8);};
void() ali_walk11	=[	$walk11 ,	ali_walk12	] {ai_walk(8);};
void() ali_walk12	=[	$walk12 ,	ali_walk13	] {ai_walk(8);};
void() ali_walk13	=[	$walk13 ,	ali_walk14	] {ai_walk(8);};
void() ali_walk14	=[	$walk14 ,	ali_walk15	] {ai_walk(8);};
void() ali_walk15	=[	$walk15 ,	ali_walk16	] {ai_walk(8);};
void() ali_walk16	=[	$walk16 ,	ali_walk17	] {ai_walk(8);};
void() ali_walk17	=[	$walk17 ,	ali_walk1	] {ai_walk(8);};

void() ali_run1		=[	$run1  ,	ali_run2	] {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "ali/idle.wav", 1, ATTN_IDLE);
ai_run(16);};
void() ali_run2		=[	$run2  ,	ali_run3	] {ai_run(32);};
void() ali_run3		=[	$run3  ,	ali_run4	] {ai_run(32);};
void() ali_run4		=[	$run4  ,	ali_run5	] {ai_run(20);};
void() ali_run5		=[	$run5  ,	ali_run6	] {ai_run(64);};
void() ali_run6		=[	$run6  ,	ali_run7	] {ai_run(32);};
void() ali_run7		=[	$run7  ,	ali_run8	] {ai_run(16);};
void() ali_run8		=[	$run8  ,	ali_run1	] {ai_run(32);};

//===============================================================================

void() ali_pain1	=[	$pain1 ,	ali_pain2	] {};
void() ali_pain2	=[	$pain2 ,	ali_pain3	] {};
void() ali_pain3	=[	$pain3 ,	ali_pain4	] {};
void() ali_pain4	=[	$pain4 ,	ali_pain5	] {};
void() ali_pain5	=[	$pain5 ,	ali_pain6	] {};
void() ali_pain6	=[	$pain6 ,	ali_run1	] {};

void() ali_painb1	=[	$painb1 ,	ali_painb2	] {};
void() ali_painb2	=[	$painb2 ,	ali_painb3	] {};
void() ali_painb3	=[	$painb3 ,	ali_painb4	] {ai_pain(4);};
void() ali_painb4	=[	$painb4 ,	ali_painb5	] {ai_pain(12);};
void() ali_painb5	=[	$painb5 ,	ali_painb6	] {ai_pain(12);};
void() ali_painb6	=[	$painb6 ,	ali_painb7	] {ai_pain(2);};
void() ali_painb7	=[	$painb7 ,	ali_painb8	] {};
void() ali_painb8	=[	$painb8 ,	ali_painb9	] {ai_pain(4);};
void() ali_painb9	=[	$painb9 ,	ali_painb10	] {};
void() ali_painb10	=[	$painb10 ,	ali_painb11	] {ai_pain(10);};
void() ali_painb11	=[	$painb11 ,	ali_painb12	] {};
void() ali_painb12	=[	$painb12 ,	ali_painb13	] {};
void() ali_painb13	=[	$painb13 ,	ali_painb14	] {};
void() ali_painb14	=[	$painb14 ,	ali_run1	] {};

void() ali_painc1	=[	$painc1 ,	ali_painc2	] {};
void() ali_painc2	=[	$painc2 ,	ali_painc3	] {};
void() ali_painc3	=[	$painc3 ,	ali_painc4	] {};
void() ali_painc4	=[	$painc4 ,	ali_painc5	] {};
void() ali_painc5	=[	$painc5 ,	ali_painc6	] {};
void() ali_painc6	=[	$painc6 ,	ali_run1	] {};

void() ali_pain =
{
	sound (self, CHAN_VOICE, "ali/dpain1.wav", 1, ATTN_NORM);

	if (random() > 0.5)
		ali_pain1 ();
	else
		ali_painb1 ();
};

//====================================================================

void() ali_atk1         =[	$atk1,  	ali_atk2	] {ai_charge(10);};
void() ali_atk2 	=[	$atk2,  	ali_atk3	] {ai_charge(10);};
void() ali_atk3 	=[	$atk3,  	ali_atk4	] {ai_charge(10);};
void() ali_atk4 	=[	$atk4,  	ali_atk5	] {ai_charge(10);};
void() ali_atk5 	=[	$atk5,  	ali_atk6	] {ai_charge(10);};
void() ali_atk6 	=[	$atk6,  	ali_atk7	] {ai_charge(10);};
void() ali_atk7 	=[	$atk7,  	ali_run1	] {ai_charge(10);};

void() ali_atka1	=[	$atka1,  	ali_atka2	] {ai_charge(10);};
void() ali_atka2	=[	$atka2,  	ali_atka3	] {ai_charge(10);};
void() ali_atka3	=[	$atka3,  	ali_atka4	] {ai_charge(10);};
void() ali_atka4	=[	$atka4,  	ali_atka5	] {ai_charge(10);};
void() ali_atka5	=[	$atka5,  	ali_atka6	] {ai_charge(10);};
void() ali_atka6	=[	$atka6,  	ali_atka7	] {ai_charge(10);};
void() ali_atka7	=[	$atka7,  	ali_atka8	] {ai_charge(10);};
void() ali_atka8	=[	$atka8,  	ali_atka9	] {ai_charge(10);};
void() ali_atka9	=[	$atka9,  	ali_run1	] {ai_charge(10);};

void() ali_atkb1	=[	$atkb1,  	ali_atkb2	] {ai_charge(10);};
void() ali_atkb2	=[	$atkb2,  	ali_atkb3	] {ai_charge(10);};
void() ali_atkb3	=[	$atkb3,  	ali_atkb4	] {ai_charge(10);};
void() ali_atkb4	=[	$atkb4,  	ali_atkb5	] {ai_charge(10);};
void() ali_atkb5	=[	$atkb5,  	ali_atkb6	] {ai_charge(10);};
void() ali_atkb6	=[	$atkb6,  	ali_atkb7	] {ai_charge(10);};
void() ali_atkb7	=[	$atkb7,  	ali_atkb8	] {ai_charge(10);};
void() ali_atkb8	=[	$atka8,  	ali_atkb9	] {ai_charge(10);};
void() ali_atkb9	=[	$atkb9,  	ali_run1	] {ai_charge(10);};

//====================================================================

void() ali_die1		=[	$death1,	ali_die2	] {};
void() ali_die2		=[	$death2,	ali_die3	] {};
void() ali_die3		=[	$death3,	ali_die4	] {};
void() ali_die4		=[	$death4,	ali_die5	] {};
void() ali_die5		=[	$death5,	ali_die6	] {};
void() ali_die6		=[	$death6,	ali_die7	] {};
void() ali_die7		=[	$death7,	ali_die8	] {};
void() ali_die8		=[	$death8,	ali_die9	] {};
void() ali_die9		=[	$death9,	ali_die10	] {};
void() ali_die10	=[	$death10,	ali_die11	] {};
void() ali_die11	=[	$death11,	ali_die12	] {};
void() ali_die12	=[	$death12,	ali_die13	] {};
void() ali_die13	=[	$death13,	ali_die14	] {};
void() ali_die14	=[	$death14,	ali_die15	] {};
void() ali_die15	=[	$death15,	ali_die16	] {};
void() ali_die16	=[	$death16,	ali_die16	] {};

void() ali_dieb1		=[	$deatha1,	ali_dieb2	] {};
void() ali_dieb2		=[	$deatha2,	ali_dieb3	] {};
void() ali_dieb3		=[	$deatha3,	ali_dieb4	] {};
void() ali_dieb4		=[	$deatha4,	ali_dieb5	] {};
void() ali_dieb5		=[	$deatha5,	ali_dieb6	] {};
void() ali_dieb6		=[	$deatha6,	ali_dieb7	] {};
void() ali_dieb7		=[	$deatha7,	ali_dieb8	] {};
void() ali_dieb8		=[	$deatha8,	ali_dieb9	] {};
void() ali_dieb9		=[	$deatha9,	ali_dieb10	] {};
void() ali_dieb10		=[	$deatha10,	ali_dieb11	] {};
void() ali_dieb11		=[	$deatha11,	ali_dieb12	] {};
void() ali_dieb12		=[	$deatha12,	ali_dieb13	] {};
void() ali_dieb13		=[	$deatha13,	ali_dieb14	] {};
void() ali_dieb14		=[	$deatha14,	ali_dieb15	] {};
void() ali_dieb15		=[	$deatha15,	ali_dieb16	] {};
void() ali_dieb16		=[	$deatha16,	ali_dieb16      ] {};

void() ali_die =
{
// check for gib
	if (self.health < -35)
	{
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		ThrowGib ("progs/gib3.mdl", self.health);
		ThrowGib ("progs/gib3.mdl", self.health);
		ThrowGib ("progs/gib3.mdl", self.health);
		ThrowHead ("progs/h_ali.mdl", self.health);
		return;
	}

// regular death
	sound (self, CHAN_VOICE, "ali/ddeath.wav", 1, ATTN_NORM);
	self.solid = SOLID_NOT;

	if (random() > 0.5)
		ali_die1 ();
	else
		ali_dieb1 ();
};

//===============================================================================

/*QUAKED monster_ali (1 0 0) (-32 -32 -24) (32 32 40) Ambush

*/
void() monster_ali =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
//	precache_model ("progs/h_ali.mdl");
	precache_model ("progs/ali.mdl");

//	precache_sound ("ali/dattack1.wav");
//	precache_sound ("ali/ddeath.wav");
//	precache_sound ("ali/dpain1.wav");
//	precache_sound ("ali/dsight.wav");
//	precache_sound ("ali/idle.wav");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/ali.mdl");

	setsize (self, '-32 -32 -24', '32 32 40');
	self.health = 25;

	self.th_stand = ali_stand1;
	self.th_walk = ali_walk1;
	self.th_run = ali_run1;
	self.th_pain = ali_pain;
	self.th_die = ali_die;
	self.th_melee = ali_atk1;
	self.th_missile = ali_atka1;

	walkmonster_start();
};
