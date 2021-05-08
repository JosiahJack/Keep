/*
==============================================================================

ZOMBIE

==============================================================================
*/
$cd id1/models/zombie

$origin	0 0 24

$base base
$skin skin

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8
$frame stand9 stand10 stand11 stand12 stand13 stand14 stand15

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10 walk11
$frame walk12 walk13 walk14

$frame run1 run2 run3 run4 run5 run6 run7 run8 run9 run10 run11

$frame paina1 paina2 paina3 paina4 paina5 paina6 paina7 paina8 paina9 paina10
$frame paina11 paina12

$frame painb1 painb2 painb3 painb4 painb5 painb6 painb7 painb8 painb9 painb10
$frame painb11 painb12 painb13 painb14 painb15 painb16 painb17 painb18 painb19
$frame painb20 painb21 painb22 painb23 painb24 painb25

$frame painc1 painc2 painc3 painc4 painc5 painc6 painc7 painc8 painc9 painc10
$frame painc11 painc12 painc13 painc14 painc15 painc16 painc17 painc18 painc19
$frame painc20 painc21

$frame paind1 paind2 paind3 paind4 paind5 paind6 paind7 paind8 paind9 paind10
$frame paind11 paind12 paind13 paind14 paind15 paind16 paind17 paind18 paind19
$frame paind20 paind21 paind22 paind23

$frame paine1 paine2 paine3 paine4 paine5 paine6 paine7 paine8 paine9 paine10
$frame paine11 paine12 paine13 paine14 paine15 paine16 paine17 paine18 paine19
$frame paine20 paine21 paine22 paine23 paine24 paine25 paine26 paine27 paine28
$frame paine29 paine30 paine31

$frame atta1 atta2 atta3 atta4 atta5 atta6 atta7 atta8 atta9 atta10 atta11
$frame atta12 atta13 atta14 atta15 atta16 atta17 atta18 atta19

$frame attb1 attb2 attb3 attb4 attb5 attb6 attb7 attb8 attb9 attb10 attb11
$frame attb12 attb13 attb14 attb15 attb16 attb17 attb18 attb19

$frame attc1 attc2 attc3 attc4 attc5 attc6 attc7 attc8 attc9 attc10 attc11
$frame attc12 attc13 attc14 attc15

// (204 - 223) idle 2 - scratch brains
$frame idleb1 idleb2 idleb3 idleb4 idleb5 idleb6 idleb7 idleb8
$frame idleb9 idleb10 idleb11 idleb12 idleb13 idleb14 idleb15 idleb16
$frame idleb17 idleb18 idleb19 idleb20

// (224 - 238) idle 3 - swing head LEFT
$frame idlec1 idlec2 idlec3 idlec4 idlec5 idlec6 idlec7 idlec8
$frame idlec9 idlec10 idlec11 idlec12 idlec13 idlec14 idlec15

// (239 - 253) idle 4 - swing head RIGHT
$frame idled1 idled2 idled3 idled4 idled5 idled6 idled7 idled8
$frame idled9 idled10 idled11 idled12 idled13 idled14 idled15

$frame cruc_1 cruc_2 cruc_3 cruc_4 cruc_5 cruc_6

float	SPAWN_CRUCIFIED	= 1;


//=============================================================================

/*
void()	zombiek_JumpTouch =
{
	local float ldmg;
	
	if (self.health < 1) return;
	self.touch = SUB_Null;			// No more touching
	self.think = self.th_jumpexit;	// Exit frame
	self.jumptouch = other;			// Keep track of touch target

	if ( CanDamage(other, self) ) {
		if ( vlen(self.velocity) > 300 ) {
		  ldmg = 10 + 10*random();
			T_Damage (other, self, self, ldmg, DAMARMOR);	
			spawn_touchblood (self, self.enemy, ldmg*3);

			// Check for poisonous attribute (new poison version)
			if (self.poisonous) PoisonDeBuff(self.enemy);
		}
	}

	// Is the zombie knight floating in the air?
	if (!checkbottom(self)) {
		// Is the zombie knight standing on something?		
		if (self.flags & FL_ONGROUND) {	
			// Do an extra jump if got the count
			if (self.count < 2)  self.think = self.th_jump;
		}
	}

	// Next timer
	self.nextthink = time + 0.1;
};*/


.float inpain;

//=============================================================================
void() zombiek_standB1	=[	$idleb1,		zombiek_standB2	] {ai_stand();};
void() zombiek_standB2	=[	$idleb2,		zombiek_standB3	] {ai_stand();};
void() zombiek_standB3	=[	$idleb3,		zombiek_standB4	] {ai_stand();};
void() zombiek_standB4	=[	$idleb4,		zombiek_standB5	] {ai_stand();};
void() zombiek_standB5	=[	$idleb5,		zombiek_standB6	] {ai_stand();};
void() zombiek_standB6	=[	$idleb6,		zombiek_standB7	] {ai_stand();};
void() zombiek_standB7	=[	$idleb7,		zombiek_standB8	] {ai_stand();};
void() zombiek_standB8	=[	$idleb8,		zombiek_standB9	] {ai_stand();};
void() zombiek_standB9	=[	$idleb9,		zombiek_standB10	] {ai_stand();};
void() zombiek_standB10	=[	$idleb10,		zombiek_standB11	] {ai_stand();};
void() zombiek_standB11	=[	$idleb11,		zombiek_standB12	] {ai_stand();};
void() zombiek_standB12	=[	$idleb12,		zombiek_standB13	] {ai_stand();};
void() zombiek_standB13	=[	$idleb13,		zombiek_standB14	] {ai_stand();};
void() zombiek_standB14	=[	$idleb14,		zombiek_standB15	] {ai_stand();};
void() zombiek_standB15	=[	$idleb15,		zombiek_standB16	] {ai_stand();};
void() zombiek_standB16	=[	$idleb16,		zombiek_standB17	] {ai_stand();};
void() zombiek_standB17	=[	$idleb17,		zombiek_standB18	] {ai_stand();};
void() zombiek_standB18	=[	$idleb18,		zombiek_standB19	] {ai_stand();};
void() zombiek_standB19	=[	$idleb19,		zombiek_standB20	] {ai_stand();};
void() zombiek_standB20	=[	$idleb20,		zombiek_stand1	] {ai_stand();};

//=============================================================================
void() zombiek_standC1	=[	$idlec1,		zombiek_standC2	] {ai_stand();};
void() zombiek_standC2	=[	$idlec2,		zombiek_standC3	] {ai_stand();};
void() zombiek_standC3	=[	$idlec3,		zombiek_standC4	] {ai_stand();};
void() zombiek_standC4	=[	$idlec4,		zombiek_standC5	] {ai_stand();};
void() zombiek_standC5	=[	$idlec5,		zombiek_standC6	] {ai_stand();};
void() zombiek_standC6	=[	$idlec6,		zombiek_standC7	] {ai_stand();};
void() zombiek_standC7	=[	$idlec7,		zombiek_standC8	] {ai_stand();};
void() zombiek_standC8	=[	$idlec8,		zombiek_standC9	] {ai_stand();};
void() zombiek_standC9	=[	$idlec9,		zombiek_standC10	] {ai_stand();};
void() zombiek_standC10	=[	$idlec10,		zombiek_standC11	] {ai_stand();};
void() zombiek_standC11	=[	$idlec11,		zombiek_standC12	] {ai_stand();};
void() zombiek_standC12	=[	$idlec12,		zombiek_standC13	] {ai_stand();};
void() zombiek_standC13	=[	$idlec13,		zombiek_standC14	] {ai_stand();};
void() zombiek_standC14	=[	$idlec14,		zombiek_standC15	] {ai_stand();};
void() zombiek_standC15	=[	$idlec15,		zombiek_stand1	] {ai_stand();};

//=============================================================================
void() zombiek_standD1	=[	$idled1,		zombiek_standD2	] {ai_stand();};
void() zombiek_standD2	=[	$idled2,		zombiek_standD3	] {ai_stand();};
void() zombiek_standD3	=[	$idled3,		zombiek_standD4	] {ai_stand();};
void() zombiek_standD4	=[	$idled4,		zombiek_standD5	] {ai_stand();};
void() zombiek_standD5	=[	$idled5,		zombiek_standD6	] {ai_stand();};
void() zombiek_standD6	=[	$idled6,		zombiek_standD7	] {ai_stand();};
void() zombiek_standD7	=[	$idled7,		zombiek_standD8	] {ai_stand();};
void() zombiek_standD8	=[	$idled8,		zombiek_standD9	] {ai_stand();};
void() zombiek_standD9	=[	$idled9,		zombiek_standD10	] {ai_stand();};
void() zombiek_standD10	=[	$idled10,		zombiek_standD11	] {ai_stand();};
void() zombiek_standD11	=[	$idled11,		zombiek_standD12	] {ai_stand();};
void() zombiek_standD12	=[	$idled12,		zombiek_standD13	] {ai_stand();};
void() zombiek_standD13	=[	$idled13,		zombiek_standD14	] {ai_stand();};
void() zombiek_standD14	=[	$idled14,		zombiek_standD15	] {ai_stand();};
void() zombiek_standD15	=[	$idled15,		zombiek_stand1	] {ai_stand();};

//----------------------------------------------------------------------
void() zombiek_standE1	=[	$idlec1,		zombiek_standE2	] {ai_stand();};
void() zombiek_standE2	=[	$idlec2,		zombiek_standE3	] {ai_stand();};
void() zombiek_standE3	=[	$idlec3,		zombiek_standE4	] {ai_stand();};
void() zombiek_standE4	=[	$idlec4,		zombiek_standE5	] {ai_stand();};
void() zombiek_standE5	=[	$idlec5,		zombiek_standE6	] {ai_stand();};
void() zombiek_standE6	=[	$idlec6,		zombiek_standE7	] {ai_stand();};
void() zombiek_standE7	=[	$idlec7,		zombiek_standE8	] {ai_stand();};
void() zombiek_standE8	=[	$idlec8,		zombiek_standE9	] {ai_stand();};
void() zombiek_standE9	=[	$idlec9,		zombiek_standE10	] {ai_stand();};
void() zombiek_standE10	=[	$idlec10,		zombiek_standE11	] {ai_stand();};
void() zombiek_standE11	=[	$idlec11,		zombiek_standE12	] {ai_stand();};
void() zombiek_standE12	=[	$idlec12,		zombiek_standE13	] {ai_stand();};
void() zombiek_standE13	=[	$idlec13,		zombiek_standE14	] {ai_stand();};
void() zombiek_standE14	=[	$idlec14,		zombiek_standE15	] {ai_stand();};
void() zombiek_standE15	=[	$idlec15,		zombiek_standE16	] {ai_stand();};
void() zombiek_standE16	=[	$idled1,		zombiek_standE17	] {ai_stand();};
void() zombiek_standE17	=[	$idled2,		zombiek_standE18	] {ai_stand();};
void() zombiek_standE18	=[	$idled3,		zombiek_standE19	] {ai_stand();};
void() zombiek_standE19	=[	$idled4,		zombiek_standE20	] {ai_stand();};
void() zombiek_standE20	=[	$idled5,		zombiek_standE21	] {ai_stand();};
void() zombiek_standE21	=[	$idled6,		zombiek_standE22	] {ai_stand();};
void() zombiek_standE22	=[	$idled7,		zombiek_standE23	] {ai_stand();};
void() zombiek_standE23	=[	$idled8,		zombiek_standE24	] {ai_stand();};
void() zombiek_standE24	=[	$idled9,		zombiek_standE25	] {ai_stand();};
void() zombiek_standE25	=[	$idled10,		zombiek_standE26	] {ai_stand();};
void() zombiek_standE26	=[	$idled11,		zombiek_standE27	] {ai_stand();};
void() zombiek_standE27	=[	$idled12,		zombiek_standE28	] {ai_stand();};
void() zombiek_standE28	=[	$idled13,		zombiek_standE29	] {ai_stand();};
void() zombiek_standE29	=[	$idled14,		zombiek_standE30	] {ai_stand();};
void() zombiek_standE30	=[	$idled15,		zombiek_stand1	] {ai_stand();};

//=============================================================================

void() zombiek_stand1	=[	$stand1,		zombiek_stand2	] {ai_stand();};
void() zombiek_stand2	=[	$stand2,		zombiek_stand3	] {ai_stand();};
void() zombiek_stand3	=[	$stand3,		zombiek_stand4	] {ai_stand();};
void() zombiek_stand4	=[	$stand4,		zombiek_stand5	] {ai_stand();
if(random(100) < 20)
{
	if (random(100) < 20) 
		zombiek_standB1();
	else if (random(100) < 40)
		zombiek_standC1();
	else if (random(100) < 60)
		zombiek_standD1();
	else if (random(100) < 80)
		zombiek_standE1();
}



};
void() zombiek_stand5	=[	$stand5,		zombiek_stand6	] {ai_stand();};
void() zombiek_stand6	=[	$stand6,		zombiek_stand7	] {ai_stand();};
void() zombiek_stand7	=[	$stand7,		zombiek_stand8	] {ai_stand();};
void() zombiek_stand8	=[	$stand8,		zombiek_stand9	] {ai_stand();};
void() zombiek_stand9	=[	$stand9,		zombiek_stand10	] {ai_stand();};
void() zombiek_stand10	=[	$stand10,		zombiek_stand11	] {ai_stand();};
void() zombiek_stand11	=[	$stand11,		zombiek_stand12	] {ai_stand();};
void() zombiek_stand12	=[	$stand12,		zombiek_stand13	] {ai_stand();};
void() zombiek_stand13	=[	$stand13,		zombiek_stand14	] {ai_stand();};
void() zombiek_stand14	=[	$stand14,		zombiek_stand15	] {ai_stand();};
void() zombiek_stand15	=[	$stand15,		zombiek_stand1	] {ai_stand();};



void() zombiek_cruc1	=	[	$cruc_1,		zombiek_cruc2	] {
if (random() < 0.1)
	sound7 (self, CHAN_VOICE, "zombie/idle_w2.wav", 1, ATTN_STATIC);};
void() zombiek_cruc2	=	[	$cruc_2,		zombiek_cruc3	] {self.nextthink = time + 0.1 + random()*0.1;};
void() zombiek_cruc3	=	[	$cruc_3,		zombiek_cruc4	] {self.nextthink = time + 0.1 + random()*0.1;};
void() zombiek_cruc4	=	[	$cruc_4,		zombiek_cruc5	] {self.nextthink = time + 0.1 + random()*0.1;};
void() zombiek_cruc5	=	[	$cruc_5,		zombiek_cruc6	] {self.nextthink = time + 0.1 + random()*0.1;};
void() zombiek_cruc6	=	[	$cruc_6,		zombiek_cruc1	] {self.nextthink = time + 0.1 + random()*0.1;};

void() zombiek_walk1		=[	$walk1,		zombiek_walk2	] {ai_walk(1);};
void() zombiek_walk2		=[	$walk2,		zombiek_walk3	] {ai_walk(1);};
void() zombiek_walk3		=[	$walk3,		zombiek_walk4	] {ai_walk(4);};
void() zombiek_walk4		=[	$walk4,		zombiek_walk5	] {ai_walk(4);};
void() zombiek_walk5		=[	$walk5,		zombiek_walk6	] {ai_walk(2);};
void() zombiek_walk6		=[	$walk6,		zombiek_walk7	] {ai_walk(1);};
void() zombiek_walk7		=[	$walk7,		zombiek_walk8	] {ai_walk(1);};
void() zombiek_walk8		=[	$walk8,		zombiek_walk9	] {ai_walk(1);zombie_footsteps (1 , 1);};
void() zombiek_walk9		=[	$walk9,		zombiek_walk10	] {ai_walk(1);};
void() zombiek_walk10	=[	$walk10,	zombiek_walk11	] {ai_walk(1);};
void() zombiek_walk11	=[	$walk11,	zombiek_walk12	] {ai_walk(1);};
void() zombiek_walk12	=[	$walk12,	zombiek_walk13	] {sound7 (self, CHAN_AUTO, "walk/drag2.wav", 1, ATTN_NORM);ai_walk(1);};
void() zombiek_walk13	=[	$walk13,	zombiek_walk14	] {ai_walk(1);};
void() zombiek_walk14	=[	$walk14,	zombiek_walk1	] {
ai_walk(1);
if (random() < 0.2)
	sound7 (self, CHAN_VOICE, "zombie/z_idle.wav", 1, ATTN_IDLE);};

void() zombiek_run1		=[	$run1,		zombiek_run2	] {ai_run(12);self.inpain = 0;};
void() zombiek_run2		=[	$run2,		zombiek_run3	] {ai_run(12);};
void() zombiek_run3		=[	$run3,		zombiek_run4	] {ai_run(13);};
void() zombiek_run4		=[	$run4,		zombiek_run5	] {ai_run(12);};
void() zombiek_run5		=[	$run5,		zombiek_run6	] {ai_run(12);zombie_footsteps (1 , 1);};
void() zombiek_run6		=[	$run6,		zombiek_run7	] {ai_run(12);};
void() zombiek_run7		=[	$run7,		zombiek_run8	] {ai_run(12);};
void() zombiek_run8		=[	$run8,		zombiek_run9	] {ai_run(11);};
void() zombiek_run9		=[	$run9,		zombiek_run10	] {ai_run(14);};
void() zombiek_run10		=[	$run10,		zombiek_run11	] {ai_run(13);};
void() zombiek_run11		=[	$run11,		zombiek_run1	] {
ai_run(11);zombie_footsteps (1 , 1);
if (random() < 0.2)
	sound7 (self, CHAN_VOICE, "zombie/z_idle.wav", 1, ATTN_IDLE);
if (random() > 0.8)
	sound7 (self, CHAN_VOICE, "zombie/z_idle1.wav", 1, ATTN_IDLE);
};

/*
=============================================================================

ATTACKS

=============================================================================
*/


void() zombiek_atta1		=[	$atta1,		zombiek_atta2	] {ai_charge(4);};
void() zombiek_atta2		=[	$atta2,		zombiek_atta3	] {ai_charge(6);};
void() zombiek_atta3		=[	$atta3,		zombiek_atta4	] {ai_charge(11);};
void() zombiek_atta4		=[	$atta4,		zombiek_atta5	] {ai_charge(1);zombie_footsteps (1 , 1);};
void() zombiek_atta5		=[	$atta5,		zombiek_atta6	] {ai_charge(11);};
void() zombiek_atta6		=[	$atta6,		zombiek_atta7	] {ai_charge(11);};
void() zombiek_atta7		=[	$atta7,		zombiek_atta8	] {ai_charge(11);};
void() zombiek_atta8		=[	$atta8,		zombiek_atta9	] {ai_charge(11);};
void() zombiek_atta9		=[	$atta9,		zombiek_atta10	] {ai_charge(4);ai_melee_knight();};
void() zombiek_atta10	=[	$atta10,	zombiek_atta11	] {ai_charge(11);ai_melee_knight();};
void() zombiek_atta11	=[	$atta11,	zombiek_atta12	] {ai_charge(11);ai_melee_knight();zombie_footsteps (1 , 1);};
void() zombiek_atta12	=[	$atta12,	zombiek_atta13	] {ai_charge(6);};
void() zombiek_atta13	=[	$atta13,	zombiek_run1	] {ai_charge(4);};

void()	zombiek_jump1	=[	$atta1,		zombiek_jump2	] {ai_face();};
void()	zombiek_jump2	=[	$atta2,		zombiek_jump3	] {ai_face();};
void()	zombiek_jump3	=[	$atta3,		zombiek_jump4	] {ai_face();};
void()	zombiek_jump4	=[	$atta4,		zombiek_jump5	]
{
	ai_face();
	
	//self.touch = zombiek_JumpTouch;
	makevectors (self.angles);
	self.origin_z = self.origin_z + 1;
	self.velocity = v_forward * 210 + '0 0 210';
	if (self.flags & FL_ONGROUND)
		self.flags = self.flags - FL_ONGROUND;
};
void()	zombiek_jump5	=[	$atta5,		zombiek_atta6	] {};
/*void()	zombiek_jump6	=[	$atta6,		zombiek_jump7	] {};
void()	zombiek_jump7	=[	$atta7,		zombiek_jump8	] {};
void()	zombiek_jump8	=[ 	$atta8,		zombiek_jump9	] {};
void()	zombiek_jump9	=[ 	$jump9,		zombiek_run1	] {};*/


void() zombiek_attb1		=[	$attb2,		zombiek_attb6	] {ai_face();};
void() zombiek_attb6		=[	$attb6,		zombiek_attb8	] {ai_face();};
void() zombiek_attb8		=[	$attb8,		zombiek_attb9	] {ai_face();};
void() zombiek_attb9		=[	$attb9,		zombiek_attb10	] {ai_face();};
void() zombiek_attb10	=[	$attb10,	zombiek_attb11	] {ai_charge(4);ai_melee_knight();};
void() zombiek_attb11	=[	$attb11,	zombiek_attb12	] {ai_charge(4);ai_melee_knight();};
void() zombiek_attb12	=[	$attb12,	zombiek_attb13	] {ai_charge(4);ai_melee_knight();};
void() zombiek_attb13	=[	$attb13,	zombiek_attb14	] {ai_charge(4);ai_melee_knight();};
void() zombiek_attb14	=[	$attb14,	zombiek_attb15	] {ai_face();};
void() zombiek_attb15	=[	$attb15,	zombiek_attb16	] {ai_face();};
void() zombiek_attb16	=[	$attb16,	zombiek_attb17	] {ai_face();};
void() zombiek_attb17	=[	$attb17,	zombiek_run1	] {ai_face();};

void() zombiek_attc1		=[	$attc1,		zombiek_attc2	] {ai_face();};
void() zombiek_attc2		=[	$attc2,		zombiek_attc3	] {ai_face();};
void() zombiek_attc3		=[	$attc3,		zombiek_attc4	] {ai_face();};
void() zombiek_attc4		=[	$attc4,		zombiek_attc5	] {ai_face();};
void() zombiek_attc5		=[	$attc5,		zombiek_attc6	] {ai_face();};
void() zombiek_attc6		=[	$attc6,		zombiek_attc7	] {ai_charge(4);ai_melee_knight();};
void() zombiek_attc7		=[	$attc7,		zombiek_attc8	] {ai_charge(4);ai_melee_knight();};
void() zombiek_attc8		=[	$attc8,		zombiek_attc9	] {ai_charge(4);ai_melee_knight();};
void() zombiek_attc9		=[	$attc9,		zombiek_attc10	] {ai_charge(4);ai_melee_knight();};
void() zombiek_attc10	=[	$attc10,	zombiek_attc11	] {ai_face();};
void() zombiek_attc11	=[	$attc11,	zombiek_attc12	] {ai_face();};
void() zombiek_attc12	=[	$attc12,	zombiek_run1		] {ai_face();};

//MELEE ATTACKS//

void() zombiek_melee =
{
	local float	r;

	r = random();

	if (r < 0.3)
		zombiek_attb1 ();
	else if (r < 0.6)
		zombiek_attc1 ();
		
	self.idletimer = 0;
	
	//else
		//zombiek_attc1 ();
};

void() zombiek_charge =
{
	local float	r;

	r = random();

	if (self.model == "progs/mon_zombiek.mdl" || self.model == "progs/mon_zombiek_onearm.mdl")
	{
		if (r < 0.3)
			zombiek_atta1 ();
		else if (self.idletimer < 3)
			zombiek_jump1 ();
			
		self.idletimer++;
		if(self.idletimer > 2 && r > 0.6)
			zombiek_melee();
	}
	//else if (r < 0.6)
	//	zombiek_attb1 ();
	//else
		//zombiek_attc1 ();
};




/*
=============================================================================

PAIN

=============================================================================
*/

void() zombiek_paina1	=[	$paina1,	zombiek_paina2	] {sound7 (self, CHAN_VOICE, "zombie/z_pain.wav", 1, ATTN_NORM);};
void() zombiek_paina2	=[	$paina2,	zombiek_paina3	] {ai_painforward(3);};
void() zombiek_paina3	=[	$paina3,	zombiek_paina4	] {ai_painforward(1);};
void() zombiek_paina4	=[	$paina4,	zombiek_paina5	] {ai_pain(1);};
void() zombiek_paina5	=[	$paina5,	zombiek_paina6	] {ai_pain(3);};
void() zombiek_paina6	=[	$paina6,	zombiek_paina7	] {ai_pain(1);};
void() zombiek_paina7	=[	$paina7,	zombiek_paina8	] {ai_painforward(1);};
void() zombiek_paina8	=[	$paina8,	zombiek_paina9	] {ai_painforward(2);};
void() zombiek_paina9	=[	$paina9,	zombiek_paina10	] {ai_painforward(3);};
void() zombiek_paina10	=[	$paina10,	zombiek_paina11	] {ai_painforward(2);};
void() zombiek_paina11	=[	$paina11,	zombiek_paina12	] {};
void() zombiek_paina12	=[	$paina12,	zombiek_run1		] {};

void() zombiek_painb1	=[	$painb1,	zombiek_painb2	] {sound7 (self, CHAN_VOICE, "zombie/z_pain1.wav", 1, ATTN_NORM);};
void() zombiek_painb2	=[	$painb2,	zombiek_painb3	] {ai_pain(2);};
void() zombiek_painb3	=[	$painb3,	zombiek_painb4	] {};
void() zombiek_painb4	=[	$painb4,	zombiek_painb5	] {ai_pain(6);};
void() zombiek_painb5	=[	$painb5,	zombiek_painb6	] {};
void() zombiek_painb6	=[	$painb6,	zombiek_painb7	] {ai_pain(3);};
void() zombiek_painb7	=[	$painb7,	zombiek_painb8	] {ai_pain(8);};
void() zombiek_painb8	=[	$painb8,	zombiek_painb9	] {ai_pain(3);};
void() zombiek_painb9	=[	$painb9,	zombiek_painb10	] {ai_pain(3);sound7 (self, CHAN_BODY, "zombie/z_fall.wav", 1, ATTN_NORM);};
void() zombiek_painb10	=[	$painb10,	zombiek_painb11	] {ai_pain(3);};
void() zombiek_painb11	=[	$painb11,	zombiek_painb12	] {ai_pain(3);};
void() zombiek_painb12	=[	$painb12,	zombiek_painb13	] {};
void() zombiek_painb13	=[	$painb13,	zombiek_painb14	] {};
void() zombiek_painb14	=[	$painb14,	zombiek_painb15	] {};
void() zombiek_painb15	=[	$painb15,	zombiek_painb16	] {};
void() zombiek_painb16	=[	$painb16,	zombiek_painb17	] {};
void() zombiek_painb17	=[	$painb17,	zombiek_painb18	] {};
void() zombiek_painb18	=[	$painb18,	zombiek_painb19	] {};
void() zombiek_painb19	=[	$painb19,	zombiek_painb20	] {};
void() zombiek_painb20	=[	$painb20,	zombiek_painb21	] {};
void() zombiek_painb21	=[	$painb21,	zombiek_painb22	] {};
void() zombiek_painb22	=[	$painb22,	zombiek_painb23	] {};
void() zombiek_painb23	=[	$painb23,	zombiek_painb24	] {};
void() zombiek_painb24	=[	$painb24,	zombiek_painb25	] {};
void() zombiek_painb25	=[	$painb25,	zombiek_run1	] {ai_painforward(1);};


void() zombiek_painc1	=[	$painc1,	zombiek_painc2	] {sound7 (self, CHAN_VOICE, "zombie/z_pain1.wav", 1, ATTN_NORM);};
void() zombiek_painc2	=[	$painc2,	zombiek_painc3	] {};
void() zombiek_painc3	=[	$painc3,	zombiek_painc4	] {ai_pain(3);};
void() zombiek_painc4	=[	$painc4,	zombiek_painc5	] {ai_pain(1);};
void() zombiek_painc5	=[	$painc5,	zombiek_painc6	] {};
void() zombiek_painc6	=[	$painc6,	zombiek_painc7	] {};
void() zombiek_painc7	=[	$painc7,	zombiek_painc8	] {};
void() zombiek_painc8	=[	$painc8,	zombiek_painc9	] {};
void() zombiek_painc9	=[	$painc9,	zombiek_painc10	] {};
void() zombiek_painc10	=[	$painc10,	zombiek_painc11	] {};
void() zombiek_painc11	=[	$painc11,	zombiek_painc12	] {ai_painforward(1);};
void() zombiek_painc12	=[	$painc12,	zombiek_painc13	] {ai_painforward(1);};
void() zombiek_painc13	=[	$painc13,	zombiek_painc14	] {};
void() zombiek_painc14	=[	$painc14,	zombiek_painc15	] {};
void() zombiek_painc15	=[	$painc15,	zombiek_painc16	] {};
void() zombiek_painc16	=[	$painc16,	zombiek_painc17	] {};
void() zombiek_painc17	=[	$painc17,	zombiek_painc18	] {};
void() zombiek_painc18	=[	$painc18,	zombiek_painc19	] {};
void() zombiek_painc19	=[	$painc19,	zombiek_painc20	] {};
void() zombiek_painc20	=[	$painc20,	zombiek_painc21	] {};
void() zombiek_painc21	=[	$painc21,	zombiek_run1	] {};

void() zombiek_paind1	=[	$paind1,	zombiek_paind2	] {sound7 (self, CHAN_VOICE, "zombie/z_pain1.wav", 1, ATTN_NORM);};
void() zombiek_paind2	=[	$paind2,	zombiek_paind3	] {};
void() zombiek_paind3	=[	$paind3,	zombiek_paind4	] {ai_pain(3);};
void() zombiek_paind4	=[	$paind4,	zombiek_paind5	] {ai_pain(1);};
void() zombiek_paind5	=[	$paind5,	zombiek_paind6	] {};
void() zombiek_paind6	=[	$paind6,	zombiek_paind7	] {};
void() zombiek_paind7	=[	$paind7,	zombiek_paind8	] {};
void() zombiek_paind8	=[	$paind8,	zombiek_paind9	] {};
void() zombiek_paind9	=[	$paind9,	zombiek_paind10	] {};
void() zombiek_paind10	=[	$paind10,	zombiek_paind11	] {};
void() zombiek_paind11	=[	$paind11,	zombiek_paind12	] {ai_painforward(1);};
void() zombiek_paind12	=[	$paind12,	zombiek_paind13	] {ai_painforward(1);};
void() zombiek_paind13	=[	$paind13,	zombiek_paind14	] {};
void() zombiek_paind14	=[	$paind14,	zombiek_paind15	] {};
void() zombiek_paind15	=[	$paind15,	zombiek_paind16	] {};
void() zombiek_paind16	=[	$paind16,	zombiek_paind17	] {};
void() zombiek_paind17	=[	$paind17,	zombiek_paind18	] {};
void() zombiek_paind18	=[	$paind18,	zombiek_paind19	] {};
void() zombiek_paind19	=[	$paind19,	zombiek_paind20	] {};
void() zombiek_paind20	=[	$painc13,	zombiek_paind21	] {};
void() zombiek_paind21	=[	$painc14,	zombiek_paind22	] {};
void() zombiek_paind22	=[	$painc15,	zombiek_paind23	] {};
void() zombiek_paind23	=[	$painc16,	zombiek_paind24	] {};
void() zombiek_paind24	=[	$painc17,	zombiek_paind25	] {};
void() zombiek_paind25	=[	$painc18,	zombiek_paind26	] {};
void() zombiek_paind26	=[	$painc19,	zombiek_paind27	] {};
void() zombiek_paind27	=[	$painc20,	zombiek_paind28	] {};
void() zombiek_paind28	=[	$painc21,	zombiek_run1	] {};

void() zombiek_paine1	=[	$paine1,	zombiek_paine2	] {
sound7 (self, CHAN_VOICE, "zombie/z_pain.wav", 1, ATTN_NORM);
self.health = 60;
};
void() zombiek_paine2	=[	$paine2,	zombiek_paine3	] {ai_pain(8);};
void() zombiek_paine3	=[	$paine3,	zombiek_paine4	] {ai_pain(5);};
void() zombiek_paine4	=[	$paine4,	zombiek_paine5	] {ai_pain(3);};
void() zombiek_paine5	=[	$paine5,	zombiek_paine6	] {ai_pain(1);};
void() zombiek_paine6	=[	$paine6,	zombiek_paine7	] {ai_pain(2);};
void() zombiek_paine7	=[	$paine7,	zombiek_paine8	] {ai_pain(1);};
void() zombiek_paine8	=[	$paine8,	zombiek_paine9	] {ai_pain(1);
sound7 (self, CHAN_BODY, "zombie/z_fall.wav", 1, ATTN_NORM);
self.solid = SOLID_NOT;};
void() zombiek_paine9	=[	$paine9,	zombiek_paine10	] {ai_pain(2);};
void() zombiek_paine10	=[	$paine10,	zombiek_paine11	] {};
void() zombiek_paine11	=[	$paine11,	zombiek_paine12	] {self.nextthink = self.nextthink + 5;self.health = 60;};
void() zombiek_paine12	=[	$paine12,	zombiek_paine13	]{
};
void() zombiek_paine13	=[	$paine13,	zombiek_paine14	] {};
void() zombiek_paine14	=[	$paine14,	zombiek_paine15	] {};
void() zombiek_paine15	=[	$paine15,	zombiek_paine16	] {};
void() zombiek_paine16	=[	$paine16,	zombiek_paine17	] {};
void() zombiek_paine17	=[	$paine17,	zombiek_paine18	] {};
void() zombiek_paine18	=[	$paine18,	zombiek_paine19	] {};
void() zombiek_paine19	=[	$paine19,	zombiek_paine20	] {};
void() zombiek_paine20	=[	$paine20,	zombiek_paine21	] {};
void() zombiek_paine21	=[	$paine21,	zombiek_paine22	] {};
void() zombiek_paine22	=[	$paine22,	zombiek_paine23	] {// see if ok to stand up
self.health = 60;
sound7 (self, CHAN_VOICE, "zombie/z_idle.wav", 1, ATTN_IDLE);
self.solid = SOLID_SLIDEBOX;
if (!walkmove (0, 0))
{
	self.think = zombiek_paine11;
	self.solid = SOLID_NOT;
	return;
}};
void() zombiek_paine23	=[	$paine23,	zombiek_paine24	] {};
void() zombiek_paine24	=[	$paine24,	zombiek_paine25	] {};
void() zombiek_paine25	=[	$paine25,	zombiek_paine26	] {ai_painforward(5);};
void() zombiek_paine26	=[	$paine26,	zombiek_paine27	] {ai_painforward(3);};
void() zombiek_paine27	=[	$paine27,	zombiek_paine28	] {ai_painforward(1);};
void() zombiek_paine28	=[	$paine28,	zombiek_paine29	] {ai_pain(1);};
void() zombiek_paine29	=[	$paine29,	zombiek_paine30	] {};
void() zombiek_paine30	=[	$paine30,	zombiek_paine31	] {};
void() zombiek_paine31	=[	$paine31,	zombiek_run1	] {};

void() zombiek_die =
{
	//5 randomized blood droplets that drip if stuck to the ceiling
	CeilSplat();
	CeilSplat();
	CeilSplat();
	CeilSplat();
	CeilSplat();
	
	sound7 (self, CHAN_VOICE, "zombie/z_gib.wav", 1, ATTN_NORM, SNDSPD);
	sendParticle("blood_monster_gib", self.origin, '0 0 0', 1, 0);
	if (self.model == "progs/mon_zombiek_onearm.mdl")
		ThrowGib("progs/gib_zarm.mdl", self.health);
	else if (self.model == "progs/mon_zombiek_noarms.mdl")
		ThrowGib("progs/gib3.mdl", self.health);
	else if (self.model == "progs/mon_zombiek.mdl")
	{
		ThrowGib("progs/gib_zarm.mdl", self.health);
		ThrowGib("progs/gib_zarm.mdl", self.health);
	}
	
	ThrowHead ("progs/h_zombiek.mdl", self.health);
	ThrowGib ("progs/gib3.mdl", self.health);
	ThrowGib("progs/gib_zleg.mdl", self.health);
	ThrowGib("progs/gib_zleg.mdl", self.health);
};

/*
=================
zombiek_pain

Zombies can only be killed (gibbed) by doing 60 hit points of damage
in a single frame (rockets, grenades, quad shotgun, quad nailgun) or by using
the chainsaw.

A hit of 25 points or more (super shotgun, quad nailgun) will allways put it
down to the ground.

A hit of from 10 to 40 points in one frame will cause it to go down if it
has been twice in two seconds, otherwise it goes into one of the four
fast pain frames.

A hit of less than 10 points of damage (winged by a shotgun) will be ignored.

FIXME: don't use pain_finished because of nightmare hack
=================
*/
void(entity attacker, float take) zombiek_pain =
{
	local float r;

	self.health = 60;		// allways reset health

	if (take < 9)
		return;				// totally ignore

	if (self.inpain == 2)
		return;			// down on ground, so don't reset any counters
	
	if (self.enemy.weapon == IT_CHAINSAW || self.enemy.weapon == IT_AXE)
		self.meleeattack++;
	
	if (take >= 10)
	{
		if (attacker.weapon == IT_AXE || attacker.weapon == IT_CHAINSAW)
		{
			
			if (self.model == "progs/mon_zombiek.mdl" && self.meleeattack > 3)
			{
				ThrowGib("progs/gib_zarm.mdl", self.health);
				setmodel (self, self.model = "progs/mon_zombiek_onearm.mdl");
				setsize (self, ZOMB_MIN, ZOMB_MAX);
			}
			else if (self.model == "progs/mon_zombiek_onearm.mdl"  && self.meleeattack > 5)
			{
				ThrowGib("progs/gib_zarm.mdl", self.health);
				ThrowWeapon ("progs/w_knightsword.mdl", self.health); 
				self.goalentity = world;
				self.th_melee = SUB_Null;
				self.th_walk();
				//FindTarget();
				setmodel (self, self.model = "progs/mon_zombiek_noarms.mdl");
				setsize (self, ZOMB_MIN, ZOMB_MAX);
			}
			
		}
	}

// go down immediately if a big enough hit
	if (take >= 25)
	{
		self.inpain = 2;
		zombiek_paine1 ();
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
		self.inpain = 2;
		zombiek_paine1 ();
		return;
	}

// gp into one of the fast pain animations
	self.inpain = 1;

	r = random();
	if (r < 0.25)
		zombiek_paina1 ();
	else if (r <  0.5)
		zombiek_painb1 ();
	else if (r <  0.75)
		zombiek_painc1 ();
	else
		zombiek_paind1 ();
};

//HIPNOTIC
void() zombiek_lay12   =[ $paine12,   zombiek_paine13 ]
   {   self.solid = SOLID_SLIDEBOX;
	if (self.targetname)
		self.use = SUB_Null;
   	self.th_pain = zombiek_pain;};

void() zombiek_lay   =[ $paine11,   zombiek_lay ]
   {
   self.th_stand = zombiek_stand1;
   self.th_pain = zombiek_lay12;

   self.nextthink = self.nextthink + 0.1;
   self.health = 60;
   if (!self.targetname)
   {
	   if (FindTarget ())
	      {
	      zombiek_lay12();
	      return;
	      }
    }
    else
    {
    	self.solid = SOLID_NOT;
	self.use = zombiek_lay12;
    }
   };
   
  //alternate laying animation
  void() zombiek_layB2   =[ $paind12,   zombiek_paind13 ]
   {   self.solid = SOLID_SLIDEBOX;
	if (self.targetname)
		self.use = SUB_Null;
   	self.th_pain = zombiek_pain;};
   
  void() zombiek_layB   =[ $paind12,   zombiek_layB ]
   {
   self.th_stand = zombiek_stand1;
   self.th_pain = zombiek_lay12;

   self.nextthink = self.nextthink + 0.1;
   self.health = 60;
   if (!self.targetname)
   {
	   if (FindTarget ())
	      {
	      zombiek_layB2();
	      return;
	      }
    }
    else
    {
    	self.solid = SOLID_NOT;
	self.use = zombiek_layB2;
    }
   };
   
   /*
 void()	zombiek_JumpTouch =
{
	local	float	ldmg;

	if (self.health <= 0)
		return;
		
	if (other.takedamage)
	{
		if ( vlen(self.velocity) > 200 )
		{
			ldmg = 12;
			if (other.classname == "monster_shalrath_boss" || other.classname == "monster_voreling")
				sound7(self, CHAN_WEAPON, "voreling/attacktear.wav", 1, ATTN_NORM, SNDSPD);
			else
			{
				T_Damage (other, self, self, ldmg);
				sound7(self, CHAN_WEAPON, "voreling/attacktear.wav", 1, ATTN_NORM, SNDSPD);
			}	
		}
	}

	if (!checkbottom(self))
	{
		if (self.flags & FL_ONGROUND)
		{	// jump randomly to not get hung up
		//dprint ("popjump\n");
			self.touch = SUB_Null;
			self.think = zombiek_jump1;
			self.nextthink = time + 0.1;

//			self.velocity_x = (random() - 0.5) * 600;
//			self.velocity_y = (random() - 0.5) * 600;
//			self.velocity_z = 200;
//			self.flags = self.flags - FL_ONGROUND;
		}
		return;	// not on ground yet
	}

	self.touch = SUB_Null;
	self.think = zombiek_atta6;
	self.nextthink = time + 0.1;
};*/

//HIPNOTIC
//============================================================================

/*QUAKED monster_zombiek (1 0 0) (-16 -16 -24) (16 16 32) Crucified ambush lying_down

If crucified, stick the bounding box 12 pixels back into a wall to look right.
If lying_down, the zombie will be lying down when spawned and will rise up
when awakened by the player.
*/
void() monster_zombiek =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}

	precache_model ("progs/mon_zombiek.mdl");
	
	precachegibs_zom();
	
	//precache damage models
	precache_model ("progs/mon_zombiek_onearm.mdl");
	precache_model ("progs/mon_zombiek_noarms.mdl");
	
	precache_model ("progs/h_zombiek.mdl");
	precache_model ("progs/zom_gib.mdl");

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
	precache_sound ("walk/drag2.wav");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/mon_zombiek.mdl");

	setsize (self, ZOMB_MIN, ZOMB_MAX);
	self.health = 60;

   self.th_stand = zombiek_stand1;
	self.th_walk = zombiek_walk1;
	self.th_run = zombiek_run1;
	self.th_pain = zombiek_pain;
	self.th_die = zombiek_die;
	//self.th_missile = zombiek_charge;
	self.th_melee = zombiek_charge;

	/*if (self.spawnflags & SPAWN_CRUCIFIED)
	{
		self.movetype = MOVETYPE_NONE;
		zombiek_cruc1 ();
		monster_zombie();
	}
	else*/
		walkmonster_start();

   //HIPNOTIC
	if (self.spawnflags & SPAWN_LYINGDOWN)
	{
		if (random(100) > 50)
			self.th_stand = zombiek_lay;
		else
			self.th_stand = zombiek_layB;
	}
	MonsterPhysics (self, autocvar_zombiemass);
};
