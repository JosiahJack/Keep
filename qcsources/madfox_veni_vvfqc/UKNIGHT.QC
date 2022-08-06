/*
==============================================================================

UNDEAD KNIGHT

==============================================================================
*/
$cd /raid/quake/id1/models/uknight

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

//float	SPAWN_CRUCIFIED	= 1;

//=============================================================================

.float inpain;

void() uknight_stand1	=[	$stand1,		uknight_stand2	] {
if (random() < 0.1)
	sound (self, CHAN_VOICE, "uknight/uidle.wav", 1, ATTN_STATIC);
ai_stand();};
void() uknight_stand2	=[	$stand2,		uknight_stand3	] {ai_stand();};
void() uknight_stand3	=[	$stand3,		uknight_stand4	] {ai_stand();};
void() uknight_stand4	=[	$stand4,		uknight_stand5	] {ai_stand();};
void() uknight_stand5	=[	$stand5,		uknight_stand6	] {ai_stand();};
void() uknight_stand6	=[	$stand6,		uknight_stand7	] {ai_stand();};
void() uknight_stand7	=[	$stand7,		uknight_stand8	] {ai_stand();};
void() uknight_stand8	=[	$stand8,		uknight_stand9	] {ai_stand();};
void() uknight_stand9	=[	$stand9,		uknight_stand10	] {ai_stand();};
void() uknight_stand10	=[	$stand10,		uknight_stand11	] {ai_stand();};
void() uknight_stand11	=[	$stand11,		uknight_stand12	] {ai_stand();};
void() uknight_stand12	=[	$stand12,		uknight_stand13	] {ai_stand();};
void() uknight_stand13	=[	$stand13,		uknight_stand14	] {ai_stand();};
void() uknight_stand14	=[	$stand14,		uknight_stand15	] {ai_stand();};
void() uknight_stand15	=[	$stand15,		uknight_stand1	] {ai_stand();};

void() uknight_cruc1	=	[	$cruc_1,		uknight_cruc2	] {
if (random() < 0.1)
	sound (self, CHAN_VOICE, "uknight/uidle.wav", 1, ATTN_STATIC);};
void() uknight_cruc2	=	[	$cruc_2,		uknight_cruc3	] {self.nextthink = time + 0.1 + random()*0.1;};
void() uknight_cruc3	=	[	$cruc_3,		uknight_cruc4	] {self.nextthink = time + 0.1 + random()*0.1;};
void() uknight_cruc4	=	[	$cruc_4,		uknight_cruc5	] {self.nextthink = time + 0.1 + random()*0.1;};
void() uknight_cruc5	=	[	$cruc_5,		uknight_cruc6	] {self.nextthink = time + 0.1 + random()*0.1;};
void() uknight_cruc6	=	[	$cruc_6,		uknight_cruc1	] {self.nextthink = time + 0.1 + random()*0.1;};

void() uknight_walk1		=[	$walk1,		uknight_walk2	] {ai_walk(0);};
void() uknight_walk2		=[	$walk2,		uknight_walk3	] {ai_walk(2);};
void() uknight_walk3		=[	$walk3,		uknight_walk4	] {ai_walk(3);};
void() uknight_walk4		=[	$walk4,		uknight_walk5	] {ai_walk(3);};
void() uknight_walk5		=[	$walk5,		uknight_walk6	] {ai_walk(3);};
void() uknight_walk6		=[	$walk6,		uknight_walk7	] {ai_walk(4);};
void() uknight_walk7		=[	$walk7,		uknight_walk8	] {ai_walk(3);};
void() uknight_walk8		=[	$walk8,		uknight_walk9	] {ai_walk(2);};
void() uknight_walk9		=[	$walk9,		uknight_walk10	] {ai_walk(0);};
void() uknight_walk10	=[	$walk10,	uknight_walk11	] {ai_walk(0);};
void() uknight_walk11	=[	$walk11,	uknight_walk12	] {ai_walk(0);};
void() uknight_walk12	=[	$walk12,	uknight_walk13	] {ai_walk(2);};
void() uknight_walk13	=[	$walk13,	uknight_walk14	] {ai_walk(3);};
void() uknight_walk14	=[	$walk14,	uknight_walk15	] {ai_walk(3);};
void() uknight_walk15	=[	$walk15,	uknight_walk16	] {ai_walk(3);};
void() uknight_walk16	=[	$walk16,	uknight_walk17	] {ai_walk(4);};
void() uknight_walk17	=[	$walk17,	uknight_walk18	] {ai_walk(3);};
void() uknight_walk18	=[	$walk18,	uknight_walk19	] {ai_walk(2);};
void() uknight_walk19	=[	$walk19,	uknight_walk1	] {ai_walk(0);
if (random() < 0.2)
	sound (self, CHAN_VOICE, "uknight/uidle.wav", 1, ATTN_IDLE);};

void() uknight_run1		=[	$run1,		uknight_run2	] {ai_run(1);self.inpain = 0;};
void() uknight_run2		=[	$run2,		uknight_run3	] {ai_run(1);};
void() uknight_run3		=[	$run3,		uknight_run4	] {ai_run(0);};
void() uknight_run4		=[	$run4,		uknight_run5	] {ai_run(1);};
void() uknight_run5		=[	$run5,		uknight_run6	] {ai_run(2);};
void() uknight_run6		=[	$run6,		uknight_run7	] {ai_run(3);};
void() uknight_run7		=[	$run7,		uknight_run8	] {ai_run(4);};
void() uknight_run8		=[	$run8,		uknight_run9	] {ai_run(4);};
void() uknight_run9		=[	$run9,		uknight_run10	] {ai_run(2);};
void() uknight_run10		=[	$run10,		uknight_run11	] {ai_run(2);};
void() uknight_run11		=[	$run11,		uknight_run12	] {ai_run(0);};
void() uknight_run12		=[	$run12,		uknight_run13	] {ai_run(0);};
void() uknight_run13		=[	$run13,		uknight_run14	] {ai_run(0);};
void() uknight_run14		=[	$run14,		uknight_run15	] {ai_run(2);};
void() uknight_run15		=[	$run15,		uknight_run16	] {ai_run(3);};
void() uknight_run16		=[	$run16,		uknight_run17	] {ai_run(5);};
void() uknight_run17		=[	$run17,		uknight_run18	] {ai_run(4);};
void() uknight_run18		=[	$run18,		uknight_run1	] {
ai_run(2);
if (random() < 0.2)
	sound (self, CHAN_VOICE, "uknight/uidle.wav", 1, ATTN_IDLE);
};

void() uknight_atta1		=[	$atta1,		uknight_atta2	] {
ai_charge(2);
if (random() < 0.2)
	sound (self, CHAN_VOICE, "uknight/usword1.wav", 1, ATTN_IDLE);
};
void() uknight_atta2		=[	$atta2,		uknight_atta3	] {ai_charge(3);};
void() uknight_atta3		=[	$atta3,		uknight_atta4	] {ai_charge(2);};
void() uknight_atta4		=[	$atta4,		uknight_atta5	] {ai_charge(3);};
void() uknight_atta5		=[	$atta5,		uknight_atta6	] {ai_charge(4);};
void() uknight_atta6		=[	$atta6,		uknight_atta7	] {ai_charge(2);};
void() uknight_atta7		=[	$atta7,		uknight_atta8	] {ai_charge(3);};
void() uknight_atta8		=[	$atta8,		uknight_atta9	] {ai_charge(2);};
void() uknight_atta9		=[	$atta9,		uknight_atta10	] {ai_charge(1);};
void() uknight_atta10	=[	$atta10,	uknight_atta11	] {ai_charge(2);};
void() uknight_atta11	=[	$atta11,	uknight_atta12	] {ai_charge(3);};
void() uknight_atta12	=[	$atta12,	uknight_atta13	] {ai_charge(2);};
void() uknight_atta13	=[	$atta13,	uknight_run1	] {ai_face();};

void() uknight_attb1		=[	$attb1,		uknight_attb2	] {
ai_charge(1);
if (random() < 0.2)
	sound (self, CHAN_VOICE, "uknight/usword2.wav", 1, ATTN_IDLE);
};
void() uknight_attb2		=[	$attb2,		uknight_attb3	] {ai_charge(2);};
void() uknight_attb3		=[	$attb3,		uknight_attb4	] {ai_charge(3);};
void() uknight_attb4		=[	$attb4,		uknight_attb5	] {ai_charge(4);};
void() uknight_attb5		=[	$attb5,		uknight_attb6	] {ai_charge(2);};
void() uknight_attb6		=[	$attb6,		uknight_attb7	] {ai_charge(3); ai_melee();};
void() uknight_attb7		=[	$attb7,		uknight_attb8	] {ai_charge(2);};
void() uknight_attb8		=[	$attb8,		uknight_attb9	] {ai_charge(1);};
void() uknight_attb9		=[	$attb9,		uknight_attb10	] {ai_charge(2);};
void() uknight_attb10	=[	$attb10,	uknight_attb11	] {ai_charge(3);};
void() uknight_attb11	=[	$attb11,	uknight_attb12	] {ai_charge(2);};
void() uknight_attb12	=[	$attb12,	uknight_attb13	] {ai_charge(2);};
void() uknight_attb13	=[	$attb13,	uknight_attb14	] {ai_charge(1);};
void() uknight_attb14	=[	$attb13,	uknight_run1	] {ai_face();};

void() uknight_attc1		=[	$attc1,		uknight_attc2	] {
ai_charge(1);
if (random() < 0.2)
	sound (self, CHAN_VOICE, "uknight/usword1.wav", 1, ATTN_IDLE);
};
void() uknight_attc2		=[	$attc2,		uknight_attc3	] {ai_charge(2);};
void() uknight_attc3		=[	$attc3,		uknight_attc4	] {ai_charge(2);};
void() uknight_attc4		=[	$attc4,		uknight_attc5	] {ai_charge(3);};
void() uknight_attc5		=[	$attc5,		uknight_attc6	] {ai_melee();};
void() uknight_attc6		=[	$attc6,		uknight_attc7	] {ai_melee();};
void() uknight_attc7		=[	$attc7,		uknight_attc8	] {ai_melee();};
void() uknight_attc8		=[	$attc8,		uknight_attc9	] {ai_charge(2);};
void() uknight_attc9		=[	$attc9,		uknight_attc10	] {ai_charge(1);};
void() uknight_attc10	=[	$attc10,	uknight_attc11	] {ai_face();};
void() uknight_attc11	=[	$attc11,	uknight_attc12	] {ai_face();};
void() uknight_attc12	=[	$attc12,	uknight_run1		] {ai_face();};

void() uknight_missile =
{
	local float	r;
	
	r = random();
	
	if (r < 0.3)
		uknight_atta1 ();
	else if (r < 0.6)
		uknight_attb1 ();
	else
		uknight_attc1 ();
};


/*
=============================================================================

PAIN

=============================================================================
*/

void() uknight_paina1	=[	$paina1,	uknight_paina2	] {sound (self, CHAN_VOICE, "uknight/uhurt.wav", 1, ATTN_NORM);};
void() uknight_paina2	=[	$paina2,	uknight_paina3	] {ai_painforward(3);};
void() uknight_paina3	=[	$paina3,	uknight_paina4	] {ai_painforward(1);};
void() uknight_paina4	=[	$paina4,	uknight_paina5	] {ai_pain(1);};
void() uknight_paina5	=[	$paina5,	uknight_paina6	] {ai_pain(3);};
void() uknight_paina6	=[	$paina6,	uknight_paina7	] {ai_pain(1);};
void() uknight_paina7	=[	$paina7,	uknight_paina8	] {};
void() uknight_paina8	=[	$paina8,	uknight_paina9	] {};
void() uknight_paina9	=[	$paina9,	uknight_paina10	] {};
void() uknight_paina10	=[	$paina10,	uknight_paina11	] {};
void() uknight_paina11	=[	$paina11,	uknight_paina12	] {};
void() uknight_paina12	=[	$paina12,	uknight_run1		] {};

void() uknight_painb1	=[	$painb1,	uknight_painb2	] {sound (self, CHAN_VOICE, "uknight/uhurt.wav", 1, ATTN_NORM);};
void() uknight_painb2	=[	$painb2,	uknight_painb3	] {ai_pain(2);};
void() uknight_painb3	=[	$painb3,	uknight_painb4	] {ai_pain(3);};
void() uknight_painb4	=[	$painb4,	uknight_painb5	] {ai_pain(1);};
void() uknight_painb5	=[	$painb5,	uknight_painb6	] {ai_pain(2);};
void() uknight_painb6	=[	$painb6,	uknight_painb7	] {};
void() uknight_painb7	=[	$painb7,	uknight_painb8	] {};
void() uknight_painb8	=[	$painb8,	uknight_painb9	] {};
void() uknight_painb9	=[	$painb9,	uknight_painb10	] {sound (self, CHAN_BODY, "uknight/udeath.wav", 1, ATTN_NORM);};
void() uknight_painb10	=[	$painb10,	uknight_painb11	] {};
void() uknight_painb11	=[	$painb11,	uknight_painb12	] {};
void() uknight_painb12	=[	$painb12,	uknight_painb13	] {};
void() uknight_painb13	=[	$painb13,	uknight_painb14	] {};
void() uknight_painb14	=[	$painb14,	uknight_painb15	] {};
void() uknight_painb15	=[	$painb15,	uknight_painb16	] {};
void() uknight_painb16	=[	$painb16,	uknight_painb17	] {};
void() uknight_painb17	=[	$painb17,	uknight_painb18	] {};
void() uknight_painb18	=[	$painb18,	uknight_painb19	] {};
void() uknight_painb19	=[	$painb19,	uknight_painb20	] {};
void() uknight_painb20	=[	$painb20,	uknight_painb21	] {};
void() uknight_painb21	=[	$painb21,	uknight_painb22	] {};
void() uknight_painb22	=[	$painb22,	uknight_painb23	] {};
void() uknight_painb23	=[	$painb23,	uknight_painb24	] {};
void() uknight_painb24	=[	$painb24,	uknight_painb25	] {};
void() uknight_painb25	=[	$painb25,	uknight_painb26	] {ai_painforward(1);};
void() uknight_painb26	=[	$painb26,	uknight_painb27	] {};
void() uknight_painb27	=[	$painb27,	uknight_painb28	] {};
void() uknight_painb28	=[	$painb28,	uknight_run1		] {};

void() uknight_painc1	=[	$painc1,	uknight_painc2	] {sound (self, CHAN_VOICE, "uknight/uhurt.wav", 1, ATTN_NORM);};
void() uknight_painc2	=[	$painc2,	uknight_painc3	] {};
void() uknight_painc3	=[	$painc3,	uknight_painc4	] {ai_pain(3);};
void() uknight_painc4	=[	$painc4,	uknight_painc5	] {ai_pain(1);};
void() uknight_painc5	=[	$painc5,	uknight_painc6	] {};
void() uknight_painc6	=[	$painc6,	uknight_painc7	] {};
void() uknight_painc7	=[	$painc7,	uknight_painc8	] {};
void() uknight_painc8	=[	$painc8,	uknight_painc9	] {};
void() uknight_painc9	=[	$painc9,	uknight_painc10	] {};
void() uknight_painc10	=[	$painc10,	uknight_painc11	] {};
void() uknight_painc11	=[	$painc11,	uknight_painc12	] {ai_painforward(1);};
void() uknight_painc12	=[	$painc12,	uknight_painc13	] {ai_painforward(1);};
void() uknight_painc13	=[	$painc13,	uknight_painc14	] {};
void() uknight_painc14	=[	$painc14,	uknight_painc15	] {};
void() uknight_painc15	=[	$painc15,	uknight_painc16	] {};
void() uknight_painc16	=[	$painc16,	uknight_painc17	] {};
void() uknight_painc17	=[	$painc17,	uknight_painc18	] {};
void() uknight_painc18	=[	$painc18,	uknight_run1	] {};

void() uknight_paind1	=[	$paind1,	uknight_paind2	] {sound (self, CHAN_VOICE, "uknight/uhurt.wav", 1, ATTN_NORM);};
void() uknight_paind2	=[	$paind2,	uknight_paind3	] {};
void() uknight_paind3	=[	$paind3,	uknight_paind4	] {};
void() uknight_paind4	=[	$paind4,	uknight_paind5	] {};
void() uknight_paind5	=[	$paind5,	uknight_paind6	] {};
void() uknight_paind6	=[	$paind6,	uknight_paind7	] {};
void() uknight_paind7	=[	$paind7,	uknight_paind8	] {};
void() uknight_paind8	=[	$paind8,	uknight_paind9	] {};
void() uknight_paind9	=[	$paind9,	uknight_paind10	] {ai_pain(1);};
void() uknight_paind10	=[	$paind10,	uknight_paind11	] {};
void() uknight_paind11	=[	$paind11,	uknight_paind12	] {};
void() uknight_paind12	=[	$paind12,	uknight_paind13	] {};
void() uknight_paind13	=[	$paind13,	uknight_run1	] {};

void() uknight_paine1	=[	$paine1,	uknight_paine2	] {
sound (self, CHAN_VOICE, "uknight/uhurt.wav", 1, ATTN_NORM);
self.health = 60;
};
void() uknight_paine2	=[	$paine2,	uknight_paine3	] {ai_pain(2);};
void() uknight_paine3	=[	$paine3,	uknight_paine4	] {ai_pain(5);};
void() uknight_paine4	=[	$paine4,	uknight_paine5	] {ai_pain(3);};
void() uknight_paine5	=[	$paine5,	uknight_paine6	] {ai_pain(1);};
void() uknight_paine6	=[	$paine6,	uknight_paine7	] {ai_pain(2);};
void() uknight_paine7	=[	$paine7,	uknight_paine8	] {ai_pain(1);};
void() uknight_paine8	=[	$paine8,	uknight_paine9	] {ai_pain(1);};
void() uknight_paine9	=[	$paine9,	uknight_paine10	] {ai_pain(2);};
void() uknight_paine10	=[	$paine10,	uknight_paine11	] {
sound (self, CHAN_BODY, "uknight/udeath.wav", 1, ATTN_NORM);
self.solid = SOLID_NOT;
};
void() uknight_paine11	=[	$paine11,	uknight_paine12	] {self.nextthink = self.nextthink + 5;self.health = 60;};
void() uknight_paine12	=[	$paine12,	uknight_paine13	]{
// see if ok to stand up
self.health = 60;
sound (self, CHAN_VOICE, "uknight/uidle.wav", 1, ATTN_IDLE);
self.solid = SOLID_SLIDEBOX;
if (!walkmove (0, 0))
{
	self.think = uknight_paine11;
	self.solid = SOLID_NOT;
	return;
}
};
void() uknight_paine13	=[	$paine13,	uknight_paine14	] {};
void() uknight_paine14	=[	$paine14,	uknight_paine15	] {};
void() uknight_paine15	=[	$paine15,	uknight_paine16	] {};
void() uknight_paine16	=[	$paine16,	uknight_paine17	] {};
void() uknight_paine17	=[	$paine17,	uknight_paine18	] {};
void() uknight_paine18	=[	$paine18,	uknight_paine19	] {};
void() uknight_paine19	=[	$paine19,	uknight_paine20	] {};
void() uknight_paine20	=[	$paine20,	uknight_paine21	] {};
void() uknight_paine21	=[	$paine21,	uknight_paine22	] {};
void() uknight_paine22	=[	$paine22,	uknight_paine23	] {};
void() uknight_paine23	=[	$paine23,	uknight_paine24	] {};
void() uknight_paine24	=[	$paine24,	uknight_paine25	] {};
void() uknight_paine25	=[	$paine25,	uknight_paine26	] {ai_painforward(2);};
void() uknight_paine26	=[	$paine26,	uknight_paine27	] {ai_painforward(3);};
void() uknight_paine27	=[	$paine27,	uknight_paine28	] {ai_painforward(1);};
void() uknight_paine28	=[	$paine28,	uknight_paine29	] {ai_pain(1);};
void() uknight_paine29	=[	$paine29,	uknight_paine30	] {};
void() uknight_paine30	=[	$paine30,	uknight_run1		] {};

void() uknight_die =
{
	sound (self, CHAN_VOICE, "uknight/z_gib.wav", 1, ATTN_NORM);
	ThrowHead ("progs/h_uknight.mdl", self.health);
	ThrowGib ("progs/gib1.mdl", self.health);
	ThrowGib ("progs/gib2.mdl", self.health);
	ThrowGib ("progs/gib3.mdl", self.health);
};

/*
=================
uknight_pain

uknights can only be killed (gibbed) by doing 60 hit points of damage
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
void(entity attacker, float take) uknight_pain =
{
	local float r;

	self.health = 60;		// allways reset health

	if (take < 9)
		return;				// totally ignore

	if (self.inpain == 2)
		return;			// down on ground, so don't reset any counters

// go down immediately if a big enough hit
	if (take >= 25)
	{
		self.inpain = 2;
		uknight_paine1 ();
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
		uknight_paine1 ();
		return;
	}

// gp into one of the fast pain animations	
	self.inpain = 1;

	r = random();
	if (r < 0.25)
		uknight_paine1 ();
	else if (r <  0.5)
		uknight_painb1 ();
	else if (r <  0.75)
		uknight_painc1 ();
	else
		uknight_paind1 ();
};

//============================================================================

/*QUAKED monster_uknight (1 0 0) (-16 -16 -24) (16 16 32) Crucified ambush

If crucified, stick the bounding box 12 pixels back into a wall to look right.
*/
void() monster_uknight =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}

	precache_model ("progs/uknight.mdl");
	precache_model ("progs/h_uknight.mdl");
	precache_model ("progs/zom_gib.mdl");

	precache_sound ("uknight/uidle.wav");
	precache_sound ("uknight/uhurt.wav");
	precache_sound ("uknight/usight.wav");
	precache_sound ("uknight/z_gib.wav");
	precache_sound ("uknight/usword1.wav");
	precache_sound ("uknight/usword2.wav");
	precache_sound ("uknight/udeath.wav");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/uknight.mdl");

	setsize (self, '-16 -16 -24', '16 16 40');
	self.health = 60;

	self.th_stand = uknight_stand1;
	self.th_walk = uknight_walk1;
	self.th_run = uknight_run1;
	self.th_pain = uknight_pain;
	self.th_die = uknight_die;
	self.th_missile = uknight_missile;

//	if (self.spawnflags & SPAWN_CRUCIFIED)
//	{
//		self.movetype = MOVETYPE_NONE;
//		uknight_cruc1 ();
//	}
//	else
		walkmonster_start();
};
