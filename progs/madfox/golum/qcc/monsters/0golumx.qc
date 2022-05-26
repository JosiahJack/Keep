/*  Copyright (C) 1996-1997  Id Software, Inc.

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    See file, 'COPYING', for details.
*/
/*
==============================================================================

ZOMBIE

==============================================================================
*/
$cd /raid/quake/id1/models/golm

$origin	0 0 24

$base base
$skin skin

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8
$frame stand9 stand10 stand11 stand12 stand13 

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10 walk11
$frame walk12 walk13 walk14 walk15 walk16 

$frame run1 run2 run3 run4 run5 run6 run7 run8 run9 

$frame atta1 atta2 atta3 atta4 atta5 atta6 

$frame attb1 attb2 attb3 attb4 attb5 attb6 attb7 attb8 attb9 attb10 attb11
$frame attb12 attb13 

$frame pain1 pain2 pain3 pain4 pain5 pain6 pain7 pain8 pain9

$frame paina1 paina2 paina3 paina4 paina5 paina6 paina7 paina8 

$frame painb1 painb2 painb3 painb4 painb5 painb6 painb7 painb8 painb9 

$frame paine1 paine2 paine3 paine4 paine5 paine6 paine7 paine8 paine9 paine10
$frame paine11 paine12 paine13 paine14 paine15 paine16 paine17 paine18 paine19
$frame paine20 paine21 paine22 paine23 paine24 paine25 paine26 paine27 paine28
$frame paine29 paine30

$frame chard1 chard2 chard3 chard4 chard5 chard6 chard7 chard8 chard9 chard10
$frame chard11 chard12 chard13 chard14 chard15 chard16 chard17

//=============================================================================

.float inpain;

void() golm_stand1	=[	$stand1,		golm_stand2	] {ai_stand();};
void() golm_stand2	=[	$stand2,		golm_stand3	] {ai_stand();};
void() golm_stand3	=[	$stand3,		golm_stand4	] {ai_stand();};
void() golm_stand4	=[	$stand4,		golm_stand5	] {ai_stand();};
void() golm_stand5	=[	$stand5,		golm_stand6	] {ai_stand();};
void() golm_stand6	=[	$stand6,		golm_stand7	] {ai_stand();};
void() golm_stand7	=[	$stand7,		golm_stand8	] {ai_stand();};
void() golm_stand8	=[	$stand8,		golm_stand9	] {ai_stand();};
void() golm_stand9	=[	$stand9,		golm_stand10	] {ai_stand();};
void() golm_stand10	=[	$stand10,		golm_stand11	] {ai_stand();};
void() golm_stand11	=[	$stand11,		golm_stand12	] {ai_stand();};
void() golm_stand12	=[	$stand12,		golm_stand13	] {ai_stand();};
void() golm_stand13	=[	$stand13,		golm_stand1	] {ai_stand();};

void() golm_walk1		=[	$walk1,		golm_walk2	] {ai_walk(5);};
void() golm_walk2		=[	$walk2,		golm_walk3	] {ai_walk(4);};
void() golm_walk3		=[	$walk3,		golm_walk4	] {ai_walk(3);};
void() golm_walk4		=[	$walk4,		golm_walk5	] {ai_walk(3);};
void() golm_walk5		=[	$walk5,		golm_walk6	] {ai_walk(2);};
void() golm_walk6		=[	$walk6,		golm_walk7	] 
{ai_walk(1);
if (random() < 0.2)
	sound (self, CHAN_VOICE, "golm/z_idle.wav", 1, ATTN_IDLE);}
;
void() golm_walk7		=[	$walk7,		golm_walk8	] {ai_walk(2);};
void() golm_walk8		=[	$walk8,		golm_walk9	] {ai_walk(3);};
void() golm_walk9		=[	$walk9,		golm_walk10	] {ai_walk(3);};
void() golm_walk10	=[	$walk10,	golm_walk11	] {ai_walk(4);};
void() golm_walk11	=[	$walk11,	golm_walk12	] {ai_walk(5);};
void() golm_walk12	=[	$walk12,	golm_walk13	] {ai_walk(4);};
void() golm_walk13	=[	$walk13,	golm_walk14	] {ai_walk(3);};
void() golm_walk14	=[	$walk14,	golm_walk15	] {ai_walk(2);};
void() golm_walk15	=[	$walk15,	golm_walk16	] {ai_walk(2);};
void() golm_walk16	=[	$walk16,	golm_walk1	] {ai_walk(1);};

void() golm_run1		=[	$run1,		golm_run2	] {ai_run(8);self.inpain = 0;};
void() golm_run2		=[	$run2,		golm_run3	] {ai_run(10);};
void() golm_run3		=[	$run3,		golm_run4	] {ai_run(8);};
void() golm_run4		=[	$run4,		golm_run5	] {ai_run(6);};
void() golm_run5		=[	$run5,		golm_run6	] {ai_run(8);};
void() golm_run6		=[	$run6,		golm_run7	] {ai_run(10);};
void() golm_run7		=[	$run7,		golm_run8	] 
{ai_run(12);
if (random() < 0.2)
	sound (self, CHAN_VOICE, "golm/z_idle.wav", 1, ATTN_IDLE);
if (random() > 0.8)
	sound (self, CHAN_VOICE, "golm/z_idle1.wav", 1, ATTN_IDLE);
};

void() golm_run8		=[	$run8,		golm_run9	] {ai_run(8);};
void() golm_run9		=[	$run9,		golm_run1	] {ai_run(6);};



/*
=============================================================================

ATTACKS

=============================================================================
*/

void() golm_atta1		=[	$atta1,		golm_atta2	] {ai_face();};
void() golm_atta2		=[	$atta2,		golm_atta3	] {ai_face();};
void() golm_atta3		=[	$atta3,		golm_atta4	] {ai_face();};
void() golm_atta4		=[	$atta4,		golm_atta5	] {ai_face();};
void() golm_atta5		=[	$atta5,		golm_atta6	] {ai_face();};
void() golm_atta6		=[	$atta6,		golm_run1	] {ai_face();};

void() golm_attb1		=[	$attb1,		golm_attb2	] {ai_face();};
void() golm_attb2		=[	$attb2,		golm_attb3	] {ai_face();};
void() golm_attb3		=[	$attb3,		golm_attb4	] {ai_face();};
void() golm_attb4		=[	$attb4,		golm_attb5	] {ai_face();};
void() golm_attb5		=[	$attb5,		golm_attb6	] {ai_face();};
void() golm_attb6		=[	$attb6,		golm_attb7	] {ai_face();};
void() golm_attb7		=[	$attb7,		golm_attb8	] {ai_face();};
void() golm_attb8		=[	$attb8,		golm_attb9	] {ai_face();};
void() golm_attb9		=[	$attb9,		golm_attb10	] {ai_face();};
void() golm_attb10	=[	$attb10,	golm_attb11	] {ai_face();};
void() golm_attb11	=[	$attb11,	golm_attb12	] {ai_face();};
void() golm_attb12	=[	$attb12,	golm_attb13	] {ai_face();};
void() golm_attb13	=[	$attb13,	golm_run1	] {ai_face();};

void() golm_missile =
{
	local float	r;
	
	r = random();
	
	if (r < 0.5)
		golm_atta1 ();

	else
		golm_attb1 ();
};


/*
=============================================================================

PAIN

=============================================================================
*/

void() golm_pain1	=[	$pain1, 	golm_pain2	] {sound (self, CHAN_VOICE, "golm/z_pain.wav", 1, ATTN_NORM);};
void() golm_pain2	=[	$pain2, 	golm_pain3	] {ai_painforward(3);};
void() golm_pain3	=[	$pain3, 	golm_pain4	] {ai_painforward(1);};
void() golm_pain4	=[	$pain4, 	golm_pain5	] {ai_pain(1);};
void() golm_pain5	=[	$pain5, 	golm_pain6	] {ai_pain(3);};
void() golm_pain6	=[	$pain6, 	golm_pain7	] {ai_pain(1);};
void() golm_pain7	=[	$pain7, 	golm_pain8	] {};
void() golm_pain8	=[	$pain8, 	golm_pain9	] {};
void() golm_pain9	=[	$pain9, 	golm_run1	] {};

void() golm_paina1	=[	$paina1,	golm_paina2	] {sound (self, CHAN_VOICE, "golm/z_pain.wav", 1, ATTN_NORM);};
void() golm_paina2	=[	$paina2,	golm_paina3	] {ai_painforward(3);};
void() golm_paina3	=[	$paina3,	golm_paina4	] {ai_painforward(1);};
void() golm_paina4	=[	$paina4,	golm_paina5	] {ai_pain(1);};
void() golm_paina5	=[	$paina5,	golm_paina6	] {ai_pain(3);};
void() golm_paina6	=[	$paina6,	golm_paina7	] {ai_pain(1);};
void() golm_paina7	=[	$paina7,	golm_paina8	] {};
void() golm_paina8	=[	$paina8,	golm_run1	] {};

void() golm_painb1	=[	$painb1,	golm_painb2	] {sound (self, CHAN_VOICE, "golm/z_pain1.wav", 1, ATTN_NORM);};
void() golm_painb2	=[	$painb2,	golm_painb3	] {ai_pain(2);};
void() golm_painb3	=[	$painb3,	golm_painb4	] {ai_pain(8);};
void() golm_painb4	=[	$painb4,	golm_painb5	] {ai_pain(6);};
void() golm_painb5	=[	$painb5,	golm_painb6	] {ai_pain(2);};
void() golm_painb6	=[	$painb6,	golm_painb7	] {};
void() golm_painb7	=[	$painb7,	golm_painb8	] {};
void() golm_painb8	=[	$painb8,	golm_painb9	] {};
void() golm_painb9	=[	$painb9,	golm_run1	] {sound (self, CHAN_BODY, "golm/z_fall.wav", 1, ATTN_NORM);};

void() golm_paind1	=[	$paind1,	golm_paind2	] {sound (self, CHAN_VOICE, "golm/z_pain.wav", 1, ATTN_NORM);};
void() golm_paind2	=[	$paind2,	golm_paind3	] {};
void() golm_paind3	=[	$paind3,	golm_paind4	] {};
void() golm_paind4	=[	$paind4,	golm_paind5	] {};
void() golm_paind5	=[	$paind5,	golm_paind6	] {};
void() golm_paind6	=[	$paind6,	golm_paind7	] {};
void() golm_paind7	=[	$paind7,	golm_paind8	] {};
void() golm_paind8	=[	$paind8,	golm_paind9	] {};
void() golm_paind9	=[	$paind9,	golm_paind10	] {ai_pain(1);};
void() golm_paind10	=[	$paind10,	golm_paind11	] {};
void() golm_paind11	=[	$paind11,	golm_paind12	] {};
void() golm_paind12	=[	$paind12,	golm_paind13	] {};
void() golm_paind13	=[	$paind13,	golm_run1	] {};

void() golm_paine1	=[	$paine1,	golm_paine2	] {
sound (self, CHAN_VOICE, "golm/z_pain.wav", 1, ATTN_NORM);
self.health = 60;
};
void() golm_paine2	=[	$paine2,	golm_paine3	] {ai_pain(8);};
void() golm_paine3	=[	$paine3,	golm_paine4	] {ai_pain(5);};
void() golm_paine4	=[	$paine4,	golm_paine5	] {ai_pain(3);};
void() golm_paine5	=[	$paine5,	golm_paine6	] {ai_pain(1);};
void() golm_paine6	=[	$paine6,	golm_paine7	] {ai_pain(2);};
void() golm_paine7	=[	$paine7,	golm_paine8	] {ai_pain(1);};
void() golm_paine8	=[	$paine8,	golm_paine9	] {ai_pain(1);};
void() golm_paine9	=[	$paine9,	golm_paine10	] {ai_pain(2);};
void() golm_paine10	=[	$paine10,	golm_paine11	] {
sound (self, CHAN_BODY, "golm/z_fall.wav", 1, ATTN_NORM);
self.solid = SOLID_NOT;
};
void() golm_paine11	=[	$paine11,	golm_paine12	] {};
void() golm_paine12	=[	$paine12,	golm_paine13	] {};
void() golm_paine13	=[	$paine13,	golm_paine14	] {self.nextthink = self.nextthink + 8;self.health = 100;};
void() golm_paine14	=[	$paine14,	golm_paine15	] 
{

	// see if ok to stand up
	self.health = 100;
	sound (self, CHAN_VOICE, "golm/z_idle.wav", 1, ATTN_IDLE);
	self.solid = SOLID_SLIDEBOX;

	if (!walkmove (0, 0))
	{
		self.think = golm_paine11;
		self.solid = SOLID_NOT;
		return;
	}
};
void() golm_paine15	=[	$paine15,	golm_paine16	] {};
void() golm_paine16	=[	$paine16,	golm_paine17	] {};
void() golm_paine17	=[	$paine17,	golm_paine18	] {};
void() golm_paine18	=[	$paine18,	golm_paine19	] {};
void() golm_paine19	=[	$paine19,	golm_paine20	] {};
void() golm_paine20	=[	$paine20,	golm_paine21	] {};
void() golm_paine21	=[	$paine21,	golm_paine22	] {};
void() golm_paine22	=[	$paine22,	golm_paine23	] {};
void() golm_paine23	=[	$paine23,	golm_paine24	] {};
void() golm_paine24	=[	$paine24,	golm_paine25	] {};
void() golm_paine25	=[	$paine25,	golm_paine26	] {ai_painforward(5);};
void() golm_paine26	=[	$paine26,	golm_paine27	] {ai_painforward(3);};
void() golm_paine27	=[	$paine27,	golm_paine28	] {ai_painforward(1);};
void() golm_paine28	=[	$paine28,	golm_paine29	] {ai_pain(1);};
void() golm_paine29	=[	$paine29,	golm_run1	] {};

void() golm_die =
{
	sound (self, CHAN_VOICE, "golm/z_gib.wav", 1, ATTN_NORM);
	ThrowHead ("progs/h_zombie.mdl", self.health);
	ThrowGib ("progs/gib1.mdl", self.health);
	ThrowGib ("progs/gib2.mdl", self.health);
	ThrowGib ("progs/gib3.mdl", self.health);
};

/*
=================
golm_pain

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
void(entity attacker, float take) golm_pain =
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
		golm_paine1 ();
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
		golm_paine1 ();
		return;
	}

	// gp into one of the fast pain animations	
	self.inpain = 1;

	r = random();
	if (r < 0.3)
		golm_pain1 ();

	else if (r <  0.6)
		golm_paina1 ();

	else
		golm_painb1 ();
};

//============================================================================

/*QUAKED monster_golm (1 0 0) (-16 -16 -24) (16 16 32) Crucified ambush

If crucified, stick the bounding box 12 pixels back into a wall to look right.
*/
void() monster_golm =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}

	precache_model ("progs/golmx.mdl");
	precache_model ("progs/h_zombie.mdl");
	precache_model ("progs/zom_gib.mdl");

	precache_sound ("golm/z_idle.wav");
	precache_sound ("golm/z_idle1.wav");
	precache_sound ("golm/z_shot1.wav");
	precache_sound ("golm/z_gib.wav");
	precache_sound ("golm/z_pain.wav");
	precache_sound ("golm/z_pain1.wav");
	precache_sound ("golm/z_fall.wav");
	precache_sound ("golm/z_miss.wav");
	precache_sound ("golm/z_hit.wav");
	precache_sound ("golm/idle_w2.wav");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/golmx.mdl");

	//gnounc
	self.noise = "golm/z_idle.wav";	//gnounc
	self.netname = "golm";
	self.killstring = " joins the Zombies\n";

	setsize (self, '-16 -16 -24', '16 16 40');
	self.health = 150;
	self.max_health = 150;

	self.th_stand = golm_stand1;
	self.th_walk = golm_walk1;
	self.th_run = golm_run1;
	self.th_pain = golm_pain;
	self.th_die = golm_die;
	self.th_attack = golm_missile;
	self.th_missile = golm_missile;

		walkmonster_start();
};
