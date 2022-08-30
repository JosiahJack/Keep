/*
========================================================================

Serpent

Version 1.0
Version 1.0 Final Code dated: 07/25/2018

Can lie in wait, in the shape of a quad damage to fool players
Can hang from ceilings too.  Also mimics wall decorations.

Beats the player up with its tail, and tries to burn them to death.

Model by MadFox based on iD qtest monster?
Code by Dr. Shadowborg, license is public domain with credit, don't
complain / blame me if it causes any damages, etc.

Other credits:
iD Software - For Quake, and Doom! (dsfirsht.wav is from doom imp)
kell for texture that spevil_o.spr was developed from.
The guys who made the JACK map editor (used to make test map)
ericw for tyrutils used to build testmap
Anybody else I forgot about

All other iD derived code is covered under the license below.

========================================================================
*/

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

//===========================================================================

// DRS Comments
// These frame macro defs are necessary because framemacros are defined
// sequentially, hence it won't animate properly otherwise.

// Examining the anims, the most ideal for this monster would be
// to treat it more realistically, e.g. CE:C / Quoth / AD realfly style.
// For the sake of vanilla compatibilty, it will be made like vanilla
// for now.

//==========================================================================

$cd /raid/quake/id1/models/serpent
$origin 0 0 24
$frame base
$skin skin0
$skin skin1

// Just floating along.
$frame idl1 idl2 idl3 idl4 idl5 idl6 idl7 idl8 idl9 idl10 idl11 idl12
$frame idl13 idl14 

// Lesurely flapping
$frame wing1 wing2 wing3 wing4 wing5 wing6 wing7 wing8 wing9 wing10
$frame wing11 wing12 wing13 wing14 wing15 wing16 wing17 wing18 wing19
$frame wing20 wing21 wing22 wing23 

// More frantic flapping, like a runfly.
$frame fly1 fly2 fly3 fly4 fly5 fly6 fly7 fly8 fly9 fly10 fly11 fly12
$frame fly13 fly14 fly15

// First Pain, tilt back
$frame pain1 pain2 pain3 pain4 pain5 pain6 pain7 pain8 pain9 pain10
$frame pain11 pain12 pain13 pain14 pain15 

// Second Pain, tilt forward
$frame paina1 paina2 paina3 paina4 paina5 paina6 paina7 paina8 paina9
$frame paina10 paina11 

// Wing slap?  Or maybe deathknightish projectile spray?
// Or maybe even a lightning beam slash?
$frame flu1 flu2 flu3 flu4 flu5 flu6 flu7 flu8 flu9 flu10 flu11 flu12
$frame flu13 flu14 

// Tail Stab. 9-12 hitframes?
$frame stin1 stin2 stin3 stin4 stin5 stin6 stin7 stin8 stin9 stin10
$frame stin11 stin12 stin13 stin14

// horizontal tailswing. 9-13 hitframes?
$frame tail1 tail2 tail3 tail4 tail5 tail6 tail7 tail8 tail9 tail10
$frame tail11 tail12 

// Normal die
$frame die1 die2 die3 die4 die5 die6 die7 die8 die9 die10 die11 die12
$frame die13 die14 die15 die16 die17 die18 die19 die20 

// Wierd tumbledie
$frame died1 died2 died3 died4 died5 died6 died7 died8 died9 died10
$frame died11 died12 died13 died14 died15 died16 died17 died18 died19
$frame died20 died21 died22 died23 died24

// Drop from ceiling hang
$frame trog1 trog2 trog3 trog4 trog5 trog6 trog7 trog8 trog9 trog10
$frame trog11 trog12 trog13 trog14 trog15

// Spawning?  Starts at 30, subtract backwards for vert to horiz
// forward from spaw1 for horiz to vert.
$frame spaw1 spaw2 spaw3 spaw4 spaw5 spaw6 spaw7 spaw8 spaw9 spaw10
$frame spaw11 spaw12 spaw13 spaw14 spaw15 

// Morphing from a quad damage shape, starts at 16, goes backwards
// reverse if you want it to morph into a quad instead.

$frame squad1 squad2 squad3 squad4 squad5 squad6 squad7 squad8 squad9
$frame squad10 squad11 squad12 squad13 squad14 squad15 

// Dunno, clinging to something? O_o
// Anim kinda looks like it's hum- oh never mind.

$frame angl1 angl2 angl3 angl4 angl5 angl6 angl7 angl8 angl9 angl10

// Quake 4 Iron Maiden style decoration trap
$frame walltrap1

//===================================================================

void()	sserp_squad1;

// Standing.  Uses idle framegroup for now.
void()	sserp_stand1	=[$idl1,	sserp_stand2] {ai_stand();};
void()	sserp_stand2	=[$idl2,	sserp_stand3] {ai_stand();};
void()	sserp_stand3	=[$idl3,	sserp_stand4] {ai_stand();};
void()	sserp_stand4	=[$idl4,	sserp_stand5] {ai_stand();};
void()	sserp_stand5	=[$idl5,	sserp_stand6] {ai_stand();};
void()	sserp_stand6	=[$idl6,	sserp_stand7] {ai_stand();};
void()	sserp_stand7	=[$idl7,	sserp_stand8] {ai_stand();};
void()	sserp_stand8	=[$idl8,	sserp_stand9] {ai_stand();};
void()	sserp_stand9	=[$idl9,	sserp_stand10] {ai_stand();};
void()	sserp_stand10	=[$idl10,	sserp_stand11] {ai_stand();};
void()	sserp_stand11	=[$idl11,	sserp_stand12] {ai_stand();};
void()	sserp_stand12	=[$idl12,	sserp_stand13] {ai_stand();};
void()	sserp_stand13	=[$idl13,	sserp_stand14] {ai_stand();};
void()	sserp_stand14	=[$idl14,	sserp_stand1] {ai_stand();};


void() sserp_idlesound =
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

// Flying around, takin' it easy
void()	sserp_walk1	=[$wing1,	sserp_walk2] {ai_walk(8);
sserp_idlesound();
};
void()	sserp_walk2	=[$wing2,	sserp_walk3] {ai_walk(8);};
void()	sserp_walk3	=[$wing3,	sserp_walk4] {ai_walk(8);};
void()	sserp_walk4	=[$wing4,	sserp_walk5] {ai_walk(8);};
void()	sserp_walk5	=[$wing5,	sserp_walk6] {ai_walk(8);};
void()	sserp_walk6	=[$wing6,	sserp_walk7] {ai_walk(8);};
void()	sserp_walk7	=[$wing7,	sserp_walk8] {ai_walk(8);};
void()	sserp_walk8	=[$wing8,	sserp_walk9] {ai_walk(8);};
void()	sserp_walk9	=[$wing9,	sserp_walk10] {ai_walk(8);};
void()	sserp_walk10	=[$wing10,	sserp_walk11] {ai_walk(8);};
void()	sserp_walk11	=[$wing11,	sserp_walk12] {ai_walk(8);};
void()	sserp_walk12	=[$wing12,	sserp_walk13] {ai_walk(8);};
void()	sserp_walk13	=[$wing13,	sserp_walk14] {ai_walk(8);};
void()	sserp_walk14	=[$wing14,	sserp_walk15] {ai_walk(8);};
void()	sserp_walk15	=[$wing15,	sserp_walk16] {ai_walk(8);};
void()	sserp_walk16	=[$wing16,	sserp_walk17] {ai_walk(8);};
void()	sserp_walk17	=[$wing17,	sserp_walk18] {ai_walk(8);};
void()	sserp_walk18	=[$wing18,	sserp_walk19] {ai_walk(8);};
void()	sserp_walk19	=[$wing19,	sserp_walk20] {ai_walk(8);};
void()	sserp_walk20	=[$wing20,	sserp_walk21] {ai_walk(8);};
void()	sserp_walk21	=[$wing21,	sserp_walk22] {ai_walk(8);};
void()	sserp_walk22	=[$wing22,	sserp_walk23] {ai_walk(8);};
void()	sserp_walk23	=[$wing23,	sserp_walk1] {ai_walk(8);};


void()	sserp_run1	=[	$fly1,		sserp_run2	] {ai_run(16);
sserp_idlesound();
};
void()	sserp_run2	=[$fly2,	sserp_run3] {ai_run(16);};
void()	sserp_run3	=[$fly3,	sserp_run4] {ai_run(16);};
void()	sserp_run4	=[$fly4,	sserp_run5] {ai_run(16);};
void()	sserp_run5	=[$fly5,	sserp_run6] {ai_run(16);};
void()	sserp_run6	=[$fly6,	sserp_run7] {ai_run(16);};
void()	sserp_run7	=[$fly7,	sserp_run8] {ai_run(16);};
void()	sserp_run8	=[$fly8,	sserp_run9] {ai_run(16);};
void()	sserp_run9	=[$fly9,	sserp_run10] {ai_run(16);};
void()	sserp_run10	=[$fly10,	sserp_run11] {ai_run(16);};
void()	sserp_run11	=[$fly11,	sserp_run12] {ai_run(16);};
void()	sserp_run12	=[$fly12,	sserp_run13] {ai_run(16);};
void()	sserp_run13	=[$fly13,	sserp_run14] {ai_run(16);};
void()	sserp_run14	=[$fly14,	sserp_run15] {ai_run(16);};
void()	sserp_run15	=[$fly15,	sserp_run1] {ai_run(16);};


void()	sserp_pain1 =[$pain1,	sserp_pain2] {self.nextthink = time + 0.05;};
void()	sserp_pain2 =[$pain2,	sserp_pain3] {self.nextthink = time + 0.05;};
void()	sserp_pain3 =[$pain3,	sserp_pain4] {self.nextthink = time + 0.05;};
void()	sserp_pain4 =[$pain4,	sserp_pain5] {self.nextthink = time + 0.05;};
void()	sserp_pain5 =[$pain5,	sserp_pain6] {self.nextthink = time + 0.05;};
void()	sserp_pain6 =[$pain6,	sserp_pain7] {self.nextthink = time + 0.05;};
void()	sserp_pain7 =[$pain7,	sserp_pain8] {self.nextthink = time + 0.05;};
void()	sserp_pain8 =[$pain8,	sserp_pain9] {self.nextthink = time + 0.05;};
void()	sserp_pain9 =[$pain9,	sserp_pain10] {self.nextthink = time + 0.05;};
void()	sserp_pain10 =[$pain10,	sserp_pain11] {self.nextthink = time + 0.05;};
void()	sserp_pain11 =[$pain11,	sserp_pain12] {self.nextthink = time + 0.05;};
void()	sserp_pain12 =[$pain12,	sserp_pain13] {self.nextthink = time + 0.05;};
void()	sserp_pain13 =[$pain13,	sserp_pain14] {self.nextthink = time + 0.05;};
void()	sserp_pain14 =[$pain14,	sserp_pain15] {self.nextthink = time + 0.05;};
void()	sserp_pain15 =[$pain15,	sserp_run1]   {self.nextthink = time + 0.05;};


void()	sserp_paina1 =[$paina1,	sserp_paina2] {self.nextthink = time + 0.05;};
void()	sserp_paina2 =[$paina2,	sserp_paina3] {self.nextthink = time + 0.05;};
void()	sserp_paina3 =[$paina3,	sserp_paina4] {self.nextthink = time + 0.05;};
void()	sserp_paina4 =[$paina4,	sserp_paina5] {self.nextthink = time + 0.05;};
void()	sserp_paina5 =[$paina5,	sserp_paina6] {self.nextthink = time + 0.05;};
void()	sserp_paina6 =[$paina6,	sserp_paina7] {self.nextthink = time + 0.05;};
void()	sserp_paina7 =[$paina7,	sserp_paina8] {self.nextthink = time + 0.05;};
void()	sserp_paina8 =[$paina8,	sserp_paina9] {self.nextthink = time + 0.05;};
void()	sserp_paina9 =[$paina9,	sserp_paina10] {self.nextthink = time + 0.05;};
void()	sserp_paina10 =[$paina10,	sserp_paina11] {self.nextthink = time + 0.05;};
void()	sserp_paina11 =[$paina11,	sserp_run1] {self.nextthink = time + 0.05;};


void()	sserp_death1	=[$die1,	sserp_death2] {

self.velocity_x = -200 + 400*random();
self.velocity_y = -200 + 400*random();
self.velocity_z = 100 + 100*random();
self.flags = self.flags - (self.flags & FL_ONGROUND);
sound (self, CHAN_VOICE, "wizard/wdeath.wav", 1, ATTN_NORM);
self.nextthink = time + 0.05;
};
void()	sserp_death2	=[$die2,	sserp_death3] {self.nextthink = time + 0.05;};
void()	sserp_death3	=[$die3,	sserp_death4]{self.solid = SOLID_NOT;self.nextthink = time + 0.05;};
void()	sserp_death4	=[$die4,	sserp_death5] {self.nextthink = time + 0.05;};
void()	sserp_death5	=[$die5,	sserp_death6] {self.nextthink = time + 0.05;};
void()	sserp_death6	=[$die6,	sserp_death7] {self.nextthink = time + 0.05;};
void()	sserp_death7	=[$die7,	sserp_death8] {self.nextthink = time + 0.05;};
void()	sserp_death8	=[$die8,	sserp_death9] {self.nextthink = time + 0.05;};
void()	sserp_death9	=[$die9,	sserp_death10] {self.nextthink = time + 0.05;};
void()	sserp_death10	=[$die10,	sserp_death11] {self.nextthink = time + 0.05;};
void()	sserp_death11	=[$die11,	sserp_death12] {self.nextthink = time + 0.05;};
void()	sserp_death12	=[$die12,	sserp_death13] {self.nextthink = time + 0.05;};
void()	sserp_death13	=[$die13,	sserp_death14] {self.nextthink = time + 0.05;};
void()	sserp_death14	=[$die14,	sserp_death15] {self.nextthink = time + 0.05;};
void()	sserp_death15	=[$die15,	sserp_death16] {self.nextthink = time + 0.05;};
void()	sserp_death16	=[$die16,	sserp_death17] {ai_back(8);self.nextthink = time + 0.05;};
void()	sserp_death17	=[$die17,	sserp_death18] {ai_back(8);self.nextthink = time + 0.05;};
void()	sserp_death18	=[$die18,	sserp_death19] {ai_back(16);self.nextthink = time + 0.05;};
void()	sserp_death19	=[$die19,	sserp_death19] {};
//void()  sserp_death20	=[$die20,	sserp_death20] {};

void()	sserp_deathb1	=[$died1,	sserp_deathb2] {
self.velocity_x = -200 + 400*random();
self.velocity_y = -200 + 400*random();
self.velocity_z = 100 + 100*random();
self.flags = self.flags - (self.flags & FL_ONGROUND);
sound (self, CHAN_VOICE, "wizard/wdeath.wav", 1, ATTN_NORM);
self.nextthink = time + 0.05;
};
void()	sserp_deathb2	=[$died2,	sserp_deathb3] {self.nextthink = time + 0.05;};
void()	sserp_deathb3	=[$died3,	sserp_deathb4]{self.solid = SOLID_NOT;};
void()	sserp_deathb4	=[$died4,	sserp_deathb5] {self.nextthink = time + 0.05;};
void()	sserp_deathb5	=[$died5,	sserp_deathb6] {self.nextthink = time + 0.05;};
void()	sserp_deathb6	=[$died6,	sserp_deathb7] {self.nextthink = time + 0.05;};
void()	sserp_deathb7	=[$died7,	sserp_deathb8] {self.nextthink = time + 0.05;};
void()	sserp_deathb8	=[$died8,	sserp_deathb9] {self.nextthink = time + 0.05;};
void()	sserp_deathb9	=[$died9,	sserp_deathb10] {self.nextthink = time + 0.05;};
void()	sserp_deathb10	=[$died10,	sserp_deathb11]{self.nextthink = time + 0.05;};
void()	sserp_deathb11	=[$died11,	sserp_deathb12] {self.nextthink = time + 0.05;};
void()	sserp_deathb12	=[$died12,	sserp_deathb13] {self.nextthink = time + 0.05;};
void()	sserp_deathb13	=[$died13,	sserp_deathb14] {walkmove ((self.angles_y+270), 8);self.nextthink = time + 0.05;};
void()	sserp_deathb14	=[$died14,	sserp_deathb15] {walkmove ( (self.angles_y+270), 8);self.nextthink = time + 0.05;};
void()	sserp_deathb15	=[$died15,	sserp_deathb16] {walkmove ( (self.angles_y+270), 8);self.nextthink = time + 0.05;};
void()	sserp_deathb16	=[$died16,	sserp_deathb17] {walkmove ( (self.angles_y+270), 8);self.nextthink = time + 0.05;};
void()	sserp_deathb17	=[$died17,	sserp_deathb18] {walkmove ( (self.angles_y+270), 8);self.nextthink = time + 0.05;};
void()	sserp_deathb18	=[$died18,	sserp_deathb19] {walkmove ( (self.angles_y+270), 8);self.nextthink = time + 0.05;};
void()	sserp_deathb19	=[$died19,	sserp_deathb20] {walkmove ( (self.angles_y+270), 8);self.nextthink = time + 0.05;};
void()	sserp_deathb20	=[$died20,	sserp_deathb21] {walkmove ( (self.angles_y+270), 8);self.nextthink = time + 0.05;};
void()	sserp_deathb21	=[$died21,	sserp_deathb22] {walkmove ( (self.angles_y+270), 8);self.nextthink = time + 0.05;};
void()	sserp_deathb22	=[$died22,	sserp_deathb23] {walkmove ( (self.angles_y+270), 8);self.nextthink = time + 0.05;};
void()	sserp_deathb23	=[$died23,	sserp_deathb24] {self.nextthink = time + 0.05;};
void()	sserp_deathb24	=[$died24,	sserp_deathb24] {};


void()	sserp_trog1 =[$trog1,	sserp_trog2] {ai_face();self.nextthink = time + 0.05;};
void()	sserp_trog2 =[$trog2,	sserp_trog3] {ai_face();self.nextthink = time + 0.05;};
void()	sserp_trog3 =[$trog3,	sserp_trog4] {ai_face();self.nextthink = time + 0.05;};
void()	sserp_trog4 =[$trog4,	sserp_trog5] {ai_face();self.nextthink = time + 0.05;};
void()	sserp_trog5 =[$trog5,	sserp_trog6] {ai_face();self.nextthink = time + 0.05;};
void()	sserp_trog6 =[$trog6,	sserp_trog7] {ai_face();self.nextthink = time + 0.05;};
void()	sserp_trog7 =[$trog7,	sserp_trog8] {ai_face();self.nextthink = time + 0.05;};
void()	sserp_trog8 =[$trog8,	sserp_trog9] {ai_face();self.nextthink = time + 0.05;};
void()	sserp_trog9 =[$trog9,	sserp_trog10] {ai_face();self.nextthink = time + 0.05;};
void()	sserp_trog10 =[$trog10,	sserp_trog11] {ai_face();self.nextthink = time + 0.05;};
void()	sserp_trog11 =[$trog11,	sserp_trog12] {ai_face();self.nextthink = time + 0.05;};
void()	sserp_trog12 =[$trog12,	sserp_trog13] {ai_face();self.nextthink = time + 0.05;};
void()	sserp_trog13 =[$trog13,	sserp_trog14] {ai_face();self.nextthink = time + 0.05;};
void()	sserp_trog14 =[$trog14,	sserp_trog15] {ai_face();self.nextthink = time + 0.05;};
void()	sserp_trog15 =[$trog15,	sserp_run1] {ai_face();self.nextthink = time + 0.05;};

void()	sserp_spaw1 =[$spaw1,	sserp_spaw2] {};
void()	sserp_spaw2 =[$spaw2,	sserp_spaw3] {};
void()	sserp_spaw3 =[$spaw3,	sserp_spaw4] {};
void()	sserp_spaw4 =[$spaw4,	sserp_spaw5] {};
void()	sserp_spaw5 =[$spaw5,	sserp_spaw6] {};
void()	sserp_spaw6 =[$spaw6,	sserp_spaw7] {};
void()	sserp_spaw7 =[$spaw7,	sserp_spaw8] {};
void()	sserp_spaw8 =[$spaw8,	sserp_spaw9] {};
void()	sserp_spaw9 =[$spaw9,	sserp_spaw10] {};
void()	sserp_spaw10 =[$spaw10,	sserp_spaw11] {};
void()	sserp_spaw11 =[$spaw11,	sserp_spaw12] {};
void()	sserp_spaw12 =[$spaw12,	sserp_spaw13] {};
void()	sserp_spaw13 =[$spaw13,	sserp_spaw14] {};
void()	sserp_spaw14 =[$spaw14,	sserp_spaw15] {};
void()	sserp_spaw15 =[$spaw15,	sserp_spaw15] {};


// Morph from a quad into a monster
void()	sserp_squad1  =[$squad15,	sserp_squad2] {ai_face();};
void()	sserp_squad2  =[$squad14,	sserp_squad3] {ai_face();};
void()	sserp_squad3  =[$squad13,	sserp_squad4] {ai_face();};
void()	sserp_squad4  =[$squad12,	sserp_squad5] {ai_face();};
void()	sserp_squad5  =[$squad11,	sserp_squad6] {ai_face();};
void()	sserp_squad6  =[$squad10,	sserp_squad7] {ai_face();};
void()	sserp_squad7  =[$squad9, 	sserp_squad8] {ai_face();};
void()	sserp_squad8  =[$squad8,	sserp_squad9] {ai_face();};
void()	sserp_squad9  =[$squad7,	sserp_squad10] {ai_face();};
void()	sserp_squad10 =[$squad6,	sserp_squad11] {ai_face();};
void()	sserp_squad11 =[$squad5,	sserp_squad12] {ai_face();};
void()	sserp_squad12 =[$squad4,	sserp_squad13] {ai_face();};
void()	sserp_squad13 =[$squad3,	sserp_squad14] {ai_face();};
void()	sserp_squad14 =[$squad2,	sserp_squad15] {ai_face();};
void()	sserp_squad15 =[$squad1,	sserp_squad16] {ai_face();};
void()	sserp_squad16 =[$spaw15, 	sserp_squad17] {ai_face();};
void()	sserp_squad17 =[$spaw14,	sserp_squad18] {ai_face();};
void()	sserp_squad18 =[$spaw13,	sserp_squad19] {ai_face();};
void()	sserp_squad19 =[$spaw12,	sserp_squad20] {ai_face();};
void()	sserp_squad20 =[$spaw11,	sserp_squad21] {ai_face();};
void()	sserp_squad21 =[$spaw10,	sserp_squad22] {ai_face();};
void()	sserp_squad22 =[$spaw9, 	sserp_squad23] {ai_face();};
void()	sserp_squad23 =[$spaw8,		sserp_squad24] {ai_face();};
void()	sserp_squad24 =[$spaw7,		sserp_squad25] {ai_face();};
void()	sserp_squad25 =[$spaw6,		sserp_squad26] {ai_face();};
void()	sserp_squad26 =[$spaw5,		sserp_squad27] {ai_face();};
void()	sserp_squad27 =[$spaw4,		sserp_squad28] {ai_face();};
void()	sserp_squad28 =[$spaw3,		sserp_squad29] {ai_face();};
void()	sserp_squad29 =[$spaw2,		sserp_squad30] {ai_face();};
void()	sserp_squad30 =[$spaw1,		sserp_run1] {ai_face();};


void()	sserp_angl1  =[$angl1,	sserp_angl2] {};
void()	sserp_angl2  =[$angl2,	sserp_angl3] {};
void()	sserp_angl3  =[$angl3,	sserp_angl4] {};
void()	sserp_angl4  =[$angl4,	sserp_angl5] {};
void()	sserp_angl5  =[$angl5,	sserp_angl6] {};
void()	sserp_angl6  =[$angl6,	sserp_angl7] {};
void()	sserp_angl7  =[$angl7,	sserp_angl8] {};
void()	sserp_angl8  =[$angl8,	sserp_angl9] {};
void()	sserp_angl9  =[$angl9,	sserp_angl10] {};
void()	sserp_angl10 =[$angl10,	sserp_angl10] {};



void() sserpquad_touch =
{
	if (other.classname != "player")
		return;
	if (other.health <= 0)
		return;

	sprint (other, "You got the Serpent Quad\n");

	sound (other, CHAN_VOICE, "items/damage.wav", 1, ATTN_NORM);
	stuffcmd (other, "bf\n");
	other.items = other.items | IT_QUAD;

	other.super_time = 1;
	other.super_damage_finished = time + 30;

	remove(self);
};

// Dies and turns into a pickupable quad damage
void()	sserp_diequad1	=[$die1,	sserp_diequad2] {

self.velocity_x = -200 + 400*random();
self.velocity_y = -200 + 400*random();
self.velocity_z = 100 + 100*random();
self.flags = self.flags - (self.flags & FL_ONGROUND);
sound (self, CHAN_VOICE, "wizard/wdeath.wav", 1, ATTN_NORM);
self.nextthink = time + 0.05;
self.skin = 1;
};
void()	sserp_diequad2	=[$die2,	sserp_diequad3] {self.avelocity = '0 90 0';self.nextthink = time + 0.05;};
void()	sserp_diequad3	=[$die3,	sserp_diequad4] {

self.solid = SOLID_TRIGGER; // set to item solid
self.touch = sserpquad_touch; // set to pickup
self.takedamage = DAMAGE_NO; // set to nodamage
self.pain_finished = time + 30; // remove after 30 seconds.
setorigin(self, self.origin); // because everything not FTEQW is dwoofy. =P
self.nextthink = time + 0.05;
};
void()	sserp_diequad4	=[$die4,	sserp_diequad5] {self.nextthink = time + 0.05;};
void()	sserp_diequad5	=[$die5,	sserp_diequad6] {self.nextthink = time + 0.05;};
void()	sserp_diequad6	=[$die6,	sserp_diequad7] {self.nextthink = time + 0.05;};
void()	sserp_diequad7	=[$die7,	sserp_diequad8] {self.nextthink = time + 0.05;};
void()	sserp_diequad8	=[$die8,	sserp_diequad9] {self.nextthink = time + 0.05;};
void()	sserp_diequad9	=[$squad1,	sserp_diequad10] {self.nextthink = time + 0.05;};
void()	sserp_diequad10	=[$squad2,	sserp_diequad11] {self.nextthink = time + 0.05;};
void()	sserp_diequad11	=[$squad3,	sserp_diequad12] {self.nextthink = time + 0.05;};
void()	sserp_diequad12	=[$squad4,	sserp_diequad13] {self.nextthink = time + 0.05;};
void()	sserp_diequad13	=[$squad5,	sserp_diequad14] {self.nextthink = time + 0.05;};
void()	sserp_diequad14	=[$squad6,	sserp_diequad15] {self.nextthink = time + 0.05;};
void()	sserp_diequad15	=[$squad7,	sserp_diequad16] {self.nextthink = time + 0.05;};
void()	sserp_diequad16	=[$squad8,	sserp_diequad17] {self.nextthink = time + 0.05;};
void()	sserp_diequad17	=[$squad9,	sserp_diequad18] {self.nextthink = time + 0.05;};
void()	sserp_diequad18	=[$squad10,	sserp_diequad19] {self.nextthink = time + 0.05;};
void()	sserp_diequad19	=[$squad11,	sserp_diequad20] {self.nextthink = time + 0.05;};
void()	sserp_diequad20	=[$squad12,	sserp_diequad21] {self.nextthink = time + 0.05;};
void()	sserp_diequad21	=[$squad13,	sserp_diequad22] {self.nextthink = time + 0.05;};
void()	sserp_diequad22	=[$squad14,	sserp_diequad23] {self.nextthink = time + 0.05;};
void()	sserp_diequad23	=[$squad15,	sserp_diequad23] {
	if(self.flags & FL_ONGROUND)
	 {
	  self.velocity = '0 0 0';
	  self.movetype = MOVETYPE_FLY;
	  self.flags = self.flags - (self.flags | FL_ONGROUND);
	  //self.avelocity = '0 180 0';
	 }
	 if(self.pain_finished <= time)
	  remove(self);
};

void() serp_lavaspellcancel; // redeclaration for these funcs
void(entity attacker, float damage) sserp_pain = 
{
	local float r;

	if (self.pain_finished > time)
		return;

	r = random();
	// cancel any lavastream spells, comment out if you want them to continue without aim
	serp_lavaspellcancel();
	
	sound (self, CHAN_VOICE, "wizard/wpain.wav", 1, ATTN_NORM);
	if (r < 0.5) // 50% chance long pain anim
	{
		sserp_paina1 ();
		self.pain_finished = time + 3;
	}
	else // otherwise short pain anim
	{
		sserp_pain1 ();
		self.pain_finished = time + 3;
	} 
};

void() sserp_die = 
{
	// cancel any lavastream spells, comment out if you want them to continue without aim
	serp_lavaspellcancel();

// check for gib
	if (self.health < -40)
	{
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		ThrowHead ("progs/h_wizard.mdl", self.health);
		ThrowGib ("progs/gib2.mdl", self.health);
		ThrowGib ("progs/gib2.mdl", self.health);
		ThrowGib ("progs/gib2.mdl", self.health);
		return;
	}

// regular death
	sound (self, CHAN_VOICE, "wizard/wdeath.wav", 1, ATTN_NORM);
	if (random() < 0.2) // 10% chance of dying into a quad
		sserp_diequad1();
	else  if (random() < 0.5)	
		sserp_death1 ();
	else
		sserp_deathb1 ();
};

// Breath 'n stuff
void(float offset) sserp_shot =
{
	local	vector	offang;
	local	vector	org, vec;
	
	offang = vectoangles (self.enemy.origin - self.origin);
	offang_y = offang_y + offset * 6;
	
	makevectors (offang);

	org = self.origin + self.mins + self.size*0.5 + v_forward * 20;

// set missile speed
	vec = normalize (v_forward);
	vec_z = 0 - vec_z + (random() - 0.5)*0.1;
	
	launch_spike (org, vec);
	newmis.classname = "knightspike";
	setmodel (newmis, "progs/k_spike.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);		
	newmis.velocity = vec*300;
	sound (self, CHAN_WEAPON, "hknight/attack1.wav", 1, ATTN_NORM);
};

// Lavastream projectiles
void() lavastream_touch =
{
	if (other == self.owner)
		return;		// don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	sound (self, CHAN_WEAPON, "hknight/hit.wav", 1, ATTN_NORM);

	if (other.health)
		T_Damage (other, self, self.owner, self.dmg);

	self.origin = self.origin - 8*normalize(self.velocity);

	BecomeExplosion ();
};

void(float damage) serp_lavastream =
{
	local vector dir;
	
	sound (self, CHAN_WEAPON, "hknight/attack1.wav", 1, ATTN_NORM);

	dir = vectoangles(self.owner.enemy.origin - self.origin);
	makevectors (dir);

	newmis = spawn ();
	newmis.owner = self.owner;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;
	newmis.dmg = damage;
	
	newmis.velocity = self.finaldest; // 1000
	newmis.velocity = newmis.velocity * 600 + (crandom()*v_right*30 + crandom()*v_up*30); // 1000
	newmis.angles = vectoangles(newmis.velocity);
	
	newmis.touch = lavastream_touch;
	
	newmis.nextthink = time + 5;
	newmis.think = SUB_Remove;
	newmis.avelocity = '200 100 300';
	
	setmodel (newmis, "progs/lavaball.mdl");
	setsize (newmis, '0 0 0', '0 0 0');		
	setorigin (newmis, self.origin);	
};

// do the anim, then fire some lavaballs
void() lavaspell_think =
{
	if(self.frame >= 5) // start firing lavaballs
	 {
		serp_lavastream(20);
	 }
	 else
	 {
	  self.frame = self.frame + 1; // update spell frames
	  self.chain.frame = self.frame;
	 }
	  
	if(self.attack_finished <= time) // cleanup after spell is complete
	 {
	  self.owner.chain = world; // remove hook for update
	  remove(self.chain); // remove backside sprite
      BecomeExplosion(); // poof
	 }
    else
     {
	    self.think = lavaspell_think; // play anims and then fire
	    self.nextthink = time + 0.1; // start the anim
     }
};

// generates the two spell sprites for firing lavastreams
void() serp_lavaspell =
{
	local vector dir, revdir;
	local vector org;

	sound (self, CHAN_WEAPON, "serp/dsfirsht.wav", 1, ATTN_NORM); // fwoosh

	// some angles stuff
	revdir = vectoangles(self.origin - self.enemy.origin);	
	dir = vectoangles(self.enemy.origin - self.origin);
	makevectors (dir);
	org = self.origin + self.mins + self.size*0.5 + v_forward * 28;
	
	// first the frontside, note frontside is actually backside because of angles oddities
	newmis = spawn();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_NONE;
	newmis.solid = SOLID_NOT;	
	setmodel(newmis, "progs/spevil_o.spr");
	setorigin(newmis, org);
	newmis.frame = 0; // start anim
	newmis.angles = dir; // set orientation
	newmis.finaldest = normalize(self.enemy.origin - self.origin); // set firing dir
	newmis.think = lavaspell_think; // play anims and then fire
	newmis.nextthink = time + 0.1; // start the anim
	newmis.attack_finished = time + 1.7; // duration of spell
	self.chain = newmis; // give the monster a hook to update the spell
	newmis.classname = "lavaspell"; // to give it a name
	
	// now the backside, anim is updated by the frontside, note that this is actually the frontside (player visible)
	newmis = spawn();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_NONE;
	newmis.solid = SOLID_NOT;	
	setmodel(newmis, "progs/spevil_o.spr");
	setorigin(newmis, org);
	newmis.angles = revdir;
	self.chain.chain = newmis; // link the backside decal to the front
};

// updates the lavaspell location as the monster turns to look at you
void() serp_updatelavaspell =
{
	local vector dir, revdir;
	local vector org;
	
    if(self.chain == world)
        return; // spell doesn't exist so abort

    // get some direction vectors
	revdir = vectoangles(self.origin - self.enemy.origin);	    
	dir = vectoangles(self.enemy.origin - self.origin);
	makevectors (dir);
	org = self.origin + self.mins + self.size*0.5 + v_forward * 28;
//	vec = normalize(v_forward);

    self.chain.finaldest = normalize(self.enemy.origin - self.origin); // assign updated shooting angle
    self.chain.angles = dir; // assign updated angles
    self.chain.chain.angles = revdir; // update spell backsprite angles
    setorigin(self.chain, org); // update spell origins
    setorigin(self.chain.chain, org); // update spell backsprite origin
};

// cancels the spell if pain anim is played...
void() serp_lavaspellcancel =
{
	if(self.chain == world || self.chain.classname != "lavaspell") // nothing to cancel!
	 return;

	self.chain.attack_finished = time; // time expired, because spell is cancelled!
    self.chain = world; // reset chain to none
};

void()	sserp_lavstrm1 =[$spaw1,	sserp_lavstrm2] {ai_face();self.nextthink = time + 0.05;};
void()	sserp_lavstrm2 =[$spaw2,	sserp_lavstrm3] {ai_face();self.nextthink = time + 0.05;};
void()	sserp_lavstrm3 =[$spaw3,	sserp_lavstrm4] {ai_face();self.nextthink = time + 0.05;};
void()	sserp_lavstrm4 =[$spaw4,	sserp_lavstrm5] {ai_face();self.nextthink = time + 0.05;};
void()	sserp_lavstrm5 =[$spaw5,	sserp_lavstrm6] {ai_face();self.nextthink = time + 0.05;};
void()	sserp_lavstrm6 =[$spaw6,	sserp_lavstrm7] {ai_face();self.nextthink = time + 0.05;};
void()	sserp_lavstrm7 =[$spaw7,	sserp_lavstrm8] {ai_face();self.nextthink = time + 0.05;};
void()	sserp_lavstrm8 =[$spaw8,	sserp_lavstrm9] {ai_face();self.nextthink = time + 0.05;};
void()	sserp_lavstrm9 =[$spaw9,	sserp_lavstrm10] {ai_face();self.nextthink = time + 0.05;};
void()	sserp_lavstrm10 =[$spaw10,	sserp_lavstrm11] {ai_face();self.nextthink = time + 0.05;};
void()	sserp_lavstrm11 =[$spaw11,	sserp_lavstrm12] {ai_face();self.nextthink = time + 0.05;};
void()	sserp_lavstrm12 =[$spaw12,	sserp_lavstrm13] {ai_face();self.nextthink = time + 0.05;};
void()	sserp_lavstrm13 =[$angl1,	sserp_lavstrm14] {ai_face();serp_lavaspell();};
void()	sserp_lavstrm14 =[$angl2,	sserp_lavstrm15] {ai_face();serp_updatelavaspell();};
void()	sserp_lavstrm15 =[$angl3,	sserp_lavstrm16] {ai_face();serp_updatelavaspell();};
void()	sserp_lavstrm16 =[$angl4,	sserp_lavstrm17] {ai_face();serp_updatelavaspell();};
void()	sserp_lavstrm17 =[$angl5,	sserp_lavstrm18] {ai_face();serp_updatelavaspell();};
void()	sserp_lavstrm18 =[$angl6,	sserp_lavstrm19] {ai_face();serp_updatelavaspell();};
void()	sserp_lavstrm19 =[$angl7,	sserp_lavstrm20] {ai_face();serp_updatelavaspell();};
void()	sserp_lavstrm20 =[$angl8,	sserp_lavstrm21] {ai_face();serp_updatelavaspell();};
void()	sserp_lavstrm21 =[$angl9,	sserp_lavstrm22] {ai_face();serp_updatelavaspell();};
void()	sserp_lavstrm22 =[$angl10,	sserp_lavstrm23] {ai_face();serp_updatelavaspell();};
void()	sserp_lavstrm23 =[$angl5,	sserp_lavstrm24] {ai_face();serp_updatelavaspell();};
void()	sserp_lavstrm24 =[$angl6,	sserp_lavstrm25] {ai_face();serp_updatelavaspell();};
void()	sserp_lavstrm25 =[$angl7,	sserp_lavstrm26] {ai_face();serp_updatelavaspell();};
void()	sserp_lavstrm26 =[$angl8,	sserp_lavstrm27] {ai_face();serp_updatelavaspell();};
void()	sserp_lavstrm27 =[$angl9,	sserp_lavstrm28] {ai_face();serp_updatelavaspell();};
void()	sserp_lavstrm28 =[$angl10,	sserp_lavstrm29] {ai_face();serp_updatelavaspell();};
void()	sserp_lavstrm29 =[$spaw12,	sserp_lavstrm30] {ai_face();self.nextthink = time + 0.05;};
void()	sserp_lavstrm30 =[$spaw11,	sserp_lavstrm31] {ai_face();self.nextthink = time + 0.05;};
void()	sserp_lavstrm31 =[$spaw10,	sserp_lavstrm32] {ai_face();self.nextthink = time + 0.05;};
void()	sserp_lavstrm32 =[$spaw9,	sserp_lavstrm33] {ai_face();self.nextthink = time + 0.05;};
void()	sserp_lavstrm33 =[$spaw8,	sserp_lavstrm34] {ai_face();self.nextthink = time + 0.05;};
void()	sserp_lavstrm34 =[$spaw7,	sserp_lavstrm35] {ai_face();self.nextthink = time + 0.05;};
void()	sserp_lavstrm35 =[$spaw6,	sserp_lavstrm36] {ai_face();self.nextthink = time + 0.05;};
void()	sserp_lavstrm36 =[$spaw5,	sserp_lavstrm37] {ai_face();self.nextthink = time + 0.05;};
void()	sserp_lavstrm37 =[$spaw4,	sserp_lavstrm38] {ai_face();self.nextthink = time + 0.05;};
void()	sserp_lavstrm38 =[$spaw3,	sserp_lavstrm39] {ai_face();self.nextthink = time + 0.05;};
void()	sserp_lavstrm39 =[$spaw2,	sserp_lavstrm40] {ai_face();self.nextthink = time + 0.05;};
void()	sserp_lavstrm40 =[$spaw1,	sserp_run1] {SUB_AttackFinished(3);};



void(float damage, float smack) serp_melee =
{
	local vector	delta;
	local float 	ldmg;

	sound (self, CHAN_WEAPON, "hknight/slash1.wav", 1, ATTN_NORM);	

	if (!self.enemy)
		return;

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 100)
		return;
	if (!CanDamage (self.enemy, self))
		return;
		
	ldmg = (random() + random() + random()) * damage;
	T_Damage (self.enemy, self, self, ldmg);
 
 
	if(smack)
	{
		sound (self, CHAN_VOICE, "shambler/smack.wav", 1, ATTN_NORM);
		SpawnMeatSpray (self.origin + v_forward*16, crandom() * 100 * v_right);
		SpawnMeatSpray (self.origin + v_forward*16, crandom() * 100 * v_right);
	}
	else
	{
		sound (self, CHAN_VOICE, "zombie/z_hit.wav", 1, ATTN_NORM);
		SpawnMeatSpray (self.origin + v_forward*16, crandom() * 100 * v_right);		
	}
};

// back sweep

void()	sserp_breathb1	=[$flu14,	sserp_breathb2] {sserp_shot(-4);};
void()	sserp_breathb2	=[$flu13,	sserp_breathb3] {sserp_shot(-3);};
void()	sserp_breathb3	=[$flu12,	sserp_breathb4] {sserp_shot(-2);};
void()	sserp_breathb4	=[$flu11,	sserp_breathb5] {sserp_shot(-1);};
void()	sserp_breathb5	=[$flu10,	sserp_breathb6] {sserp_shot(0);};
void()	sserp_breathb6	=[$flu9,	sserp_breathb7] {sserp_shot(1);};
void()	sserp_breathb7	=[$flu8,	sserp_breathb8] {sserp_shot(2);SUB_AttackFinished(2);};
void()	sserp_breathb8	=[$flu7,	sserp_breathb9] {ai_face();self.nextthink = time + 0.05;};
void()	sserp_breathb9	=[$flu6,	sserp_breathb10] {ai_face();self.nextthink = time + 0.05;};
void()	sserp_breathb10	=[$flu5,	sserp_breathb11] {ai_face();self.nextthink = time + 0.05;};
void()	sserp_breathb11	=[$flu4,	sserp_breathb12] {ai_face();self.nextthink = time + 0.05;};
void()	sserp_breathb12	=[$flu3,	sserp_breathb13] {ai_face();self.nextthink = time + 0.05;};
void()	sserp_breathb13	=[$flu2,	sserp_breathb14] {ai_face();self.nextthink = time + 0.05;};
void()	sserp_breathb14	=[$flu1,	sserp_run1] {ai_face();self.nextthink = time + 0.05;};

// forward sweep
void()	sserp_breath1	=[$flu1,	sserp_breath2] {ai_face();self.nextthink = time + 0.05;};
void()	sserp_breath2	=[$flu2,	sserp_breath3] {ai_face();self.nextthink = time + 0.05;};
void()	sserp_breath3	=[$flu3,	sserp_breath4] {ai_face();self.nextthink = time + 0.05;};
void()	sserp_breath4	=[$flu4,	sserp_breath5] {ai_face();self.nextthink = time + 0.05;};
void()	sserp_breath5	=[$flu5,	sserp_breath6] {ai_face();self.nextthink = time + 0.05;};
void()	sserp_breath6	=[$flu6,	sserp_breath7] {ai_face();self.nextthink = time + 0.05;};
void()	sserp_breath7	=[$flu7,	sserp_breath8] {ai_face();self.nextthink = time + 0.05;};
void()	sserp_breath8	=[$flu8,	sserp_breath9] {sserp_shot(3);};
void()	sserp_breath9	=[$flu9,	sserp_breath10] {sserp_shot(2);};
void()	sserp_breath10	=[$flu10,	sserp_breath11] {sserp_shot(3);};
void()	sserp_breath11	=[$flu11,	sserp_breath12] {sserp_shot(0);};
void()	sserp_breath12	=[$flu12,	sserp_breath13] {sserp_shot(-1);};
void()	sserp_breath13	=[$flu13,	sserp_breath14] {sserp_shot(-2);};
void()	sserp_breath14	=[$flu14,	sserp_breath15] {
	sserp_shot(-3);
	SUB_AttackFinished(2);
	// if enemy is visible and 25% chance, do a backsweep of firebolts
	if((random() < 0.25) && visible(self.enemy))
		sserp_breathb1();
};
void()	sserp_breath15	=[$flu14,	sserp_run1] {ai_face();self.nextthink = time + 0.05;};


void()	sserp_tail1 =[$tail1,	sserp_tail2] {ai_charge(10);self.nextthink = time + 0.05;};
void()	sserp_tail2 =[$tail2,	sserp_tail3] {ai_charge(10);self.nextthink = time + 0.05;};
void()	sserp_tail3 =[$tail3,	sserp_tail4] {ai_charge(10);self.nextthink = time + 0.05;};
void()	sserp_tail4 =[$tail4,	sserp_tail5] {ai_charge(10);self.nextthink = time + 0.05;};
void()	sserp_tail5 =[$tail5,	sserp_tail6] {ai_charge(10);self.nextthink = time + 0.05;};
void()	sserp_tail6 =[$tail6,	sserp_tail7] {ai_charge(10);self.nextthink = time + 0.05;};
void()	sserp_tail7 =[$tail7,	sserp_tail8] {ai_charge(10);self.nextthink = time + 0.05;};
void()	sserp_tail8 =[$tail8,	sserp_tail9] {ai_charge(10);self.nextthink = time + 0.05;};
void()	sserp_tail9 =[$tail9,	sserp_tail10] {ai_charge(10);serp_melee(3, FALSE);self.nextthink = time + 0.05;};
void()	sserp_tail10 =[$tail10,	sserp_tail11] {ai_charge(10);serp_melee(3, FALSE);self.nextthink = time + 0.05;};
void()	sserp_tail11 =[$tail11,	sserp_tail12] {ai_charge(10);serp_melee(3, FALSE);self.nextthink = time + 0.05;};
void()	sserp_tail12 =[$tail12,	sserp_run1] {ai_charge(10);self.nextthink = time + 0.05;};


void()	sserp_stin1 =[$stin1,	sserp_stin2] {ai_charge(10);self.nextthink = time + 0.05;};
void()	sserp_stin2 =[$stin2,	sserp_stin3] {ai_charge(10);self.nextthink = time + 0.05;};
void()	sserp_stin3 =[$stin3,	sserp_stin4] {ai_charge(10);self.nextthink = time + 0.05;};
void()	sserp_stin4 =[$stin4,	sserp_stin5] {ai_charge(10);self.nextthink = time + 0.05;};
void()	sserp_stin5 =[$stin5,	sserp_stin6] {
	// blind forward charge, like a fiend leap
	local vector dir;
	dir = vectoangles(self.enemy.origin - self.origin);
	makevectors (dir);
	self.finaldest = v_forward;
	walkmove(vectoyaw(self.finaldest), 20);
};
void()	sserp_stin6 =[   $stin6,   	sserp_stin7]  {ai_charge(10);self.nextthink = time + 0.05;};
void()	sserp_stin7 =[   $stin7,   	sserp_stin8]  {ai_charge(10);self.nextthink = time + 0.05;};
void()	sserp_stin8 =[   $stin8,   	sserp_stin9]  {walkmove(vectoyaw(self.finaldest), 20);};
void()	sserp_stin9 =[   $stin9,   	sserp_stin10] {walkmove(vectoyaw(self.finaldest), 20);serp_melee(40, TRUE);};
void()	sserp_stin10 =[  $stin10, 	sserp_stin11] {walkmove(vectoyaw(self.finaldest), 20);};
void()	sserp_stin11 =[  $stin11,    	sserp_stin12] {ai_face();};
void()	sserp_stin12 =[  $stin12,  	sserp_stin13] {ai_face();};
void()	sserp_stin13 =[  $stin13,    	sserp_stin14] {ai_face();};
void()	sserp_stin14 =[  $stin14,  	sserp_run1]   {ai_face();};

// ranged attack
void() sserp_missile =
{
    local float dist;

    dist = vlen(self.enemy.origin - self.origin);

    if((dist <= 256) && random() < 0.8) // close in sweep is most likely at this range
    	sserp_breath1();
    else if((dist > 256) && random() < 0.8) // further range will use this most of the time.
        sserp_lavstrm1();
    else sserp_breath1(); // otherwise, use the sweep attack
};

// placeholder for later...
void() sserp_attack = {};

// tail attacks
void() sserp_melee = 
{
	local float chance;
	
	chance = random();
	sound (self, CHAN_WEAPON, "hknight/slash1.wav", 1, ATTN_NORM);	
	if (chance > 0.6)
		sserp_stin1 ();
	else
		sserp_tail1 ();
};

// Modded version of FindTarget from ai.qc
float() sserp_scanforenemies =
{
	local entity	client;
	local float		r;

	// Quadstate Serpent is always in ambush state, so ambush checking is not needed.
		client = checkclient ();
		if (!client)
			return FALSE;	// current check entity isn't in PVS

	if (client == self.enemy) // iD say: "Don't get angry twice at your enemy"
		return FALSE;

	if (client.flags & FL_NOTARGET) // iD say: "Don't get angry at notarget players"
		return FALSE;
		
	if (client.items & IT_INVISIBILITY) // iD say: "Don't get angry at the precioussss"
		return FALSE;

	r = vlen(self.origin - client.origin); // Get the range, note this is raw range value, not foofy iD range function
	if (r > 1000) // if range is far, don't bother...far > 1000qu
		return FALSE;
		
	if (!visible (client)) // If the player can't be seen, don't bother
		return FALSE;

	if (r > self.lip) // not within trigger range
		return FALSE;
//
// got one
//
	self.enemy = client;
	return TRUE;
};

void() serpquad_wake =
{
	// play a sightsound
	sound (self, CHAN_VOICE, "wizard/wsight.wav", 1, ATTN_NORM);
	self.avelocity = '0 0 0'; // quit spinning
	self.pain_finished = time + 4.6; // set delay so monster can morph
	self.movetype = MOVETYPE_STEP; // set so it can move normally 

	// Set up normal thinks
	self.th_stand = sserp_stand1;
	self.th_walk = sserp_walk1;
	self.th_run = sserp_run1;
	self.th_melee = sserp_melee;
	self.th_missile = sserp_missile;
	self.th_pain = sserp_pain;
	self.th_die = sserp_die;

	self.goalentity = self.enemy; // gotta set this or monster won't move
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin); // this too
	SUB_AttackFinished (1);	// wait a while before first attack

	flymonster_start_go(); // finish getting the monster to go

        if(self.spawnflags & 4)
                sserp_squad1();
		self.skin = 0;           //normal skin
	if(self.spawnflags & 8) // Ceilinghang
		sserp_trog1(); // play ceilingdrop anim
//	else if(self.spawnflags & 16) // Walltrap
//		sserp_wtrap1(); // play push away from wall anim
       else if(self.spawnflags & 4) //skin setting
               self.skin = 0; // blue skin
	else
		sserp_squad1(); // play morphing anim

};

// so that the compiled won't complain about pain funcs needing extra vars.
void(entity attacker, float damage) serpquad_painwake =
{
	self.enemy = attacker;
	serpquad_wake();
};

void()	sserp_quadwait1 =[$squad15,	sserp_quadwait1] {
local float foundenemy;

	foundenemy = sserp_scanforenemies(); // search for enemies
	if(self.targetname != "") // don't do a scan if we are triggered instead
		return;
	
	if(foundenemy) // Iiit caaaan SEEEE YOOOUO!!!11!
	 serpquad_wake(); // Morphin' Time >=D
};

void()	sserp_trogwait1 =[$trog1,	sserp_trogwait1] {
local float foundenemy;

	foundenemy = sserp_scanforenemies(); // search for enemies
	if(self.targetname != "") // don't do a scan if we are triggered instead
		return;
	
	if(foundenemy) // Iiit caaaan SEEEE YOOOUO!!!11!
	 serpquad_wake(); // Morphin' Time >=D
};

void()	sserp_wtwait1 =[$walltrap1,	sserp_wtwait1] {
local float foundenemy;

	foundenemy = sserp_scanforenemies(); // search for enemies
	if(self.targetname != "") // don't do a scan if we are triggered instead
		return;
	
	if(foundenemy) // Iiit caaaan SEEEE YOOOUO!!!11!
	 serpquad_wake(); // Morphin' Time >=D
};


/*QUAKED monster_sserp (1 0 0) (-16 -16 -24) (16 16 40) Ambush Quad Trog Walltrap
If Quad is set, monster will go into a radius detection activation mode
If Quad is set and monster has a targetname, you will need to wake it
with a trigger.

If Trog is set, monster will wait in ceiling hang mode
Set targetname as with quad for trigger only activation

If Walltrap is set, monster will wait in quadshape walldecoration mode
Set targetname as with quad for trigger only activation
 
Activation radius may be set by setting monsters .lip value.
Default value is 128.
*/

void() monster_serpent = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model ("progs/serpent.mdl"); // monster model, based on id stuff, final goodies by madfox?
	precache_model ("progs/h_wizard.mdl"); // head gib
	precache_model ("progs/k_spike.mdl"); // id1 firebolt model
	precache_model ("progs/spevil_o.spr"); // spell sprite, made from a texture from one of kells .wadfiles

	precache_sound ("wizard/hit.wav");		// used by c code
	precache_sound ("hknight/attack1.wav"); // firebolts / firestream projectiles
	precache_sound ("hknight/slash1.wav"); // melee tail swing
	precache_sound ("shambler/smack.wav"); // melee tail sting hit
	precache_sound ("zombie/z_hit.wav"); // melee tail swing hit
	precache_sound ("serp/dsfirsht.wav"); // from doom, used for firestream spell
	precache_sound ("hknight/hit.wav"); // firestream hit poof noise	

	precache_sound ("wizard/wdeath.wav"); // deathnoise
	precache_sound ("wizard/widle1.wav"); // idlenoise
	precache_sound ("wizard/widle2.wav"); // ^
	precache_sound ("wizard/wpain.wav"); // painnoise
	precache_sound ("wizard/wsight.wav"); // sightnoise

	precache_sound ("items/damage.wav"); // Quad damage goodies
	precache_sound ("items/damage2.wav");
	precache_sound ("items/damage3.wav");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/serpent.mdl");

	// '-24 -24 -8' by '24 24 8' is not a valid size for qbsp / 2bsp / bsp2 for world collisions...
	// Hexen2 format may be different, dunno, q2bsp / q3bsp / fbsp will allow this size
	// q1bsp supports pointsize 0x0x0, player 16x16x64(32x64), and shambler 32x32x88(64x88)
	//setsize (self, '-24 -24 -8', '24 24 8');
	setsize (self, '-16 -16 -24', '16 16 40'); // '-16 -16 -24', '16 16 40' 32x64qu is proper player size
	self.health = 250;
	
	// Set monster state according to flags and targetname
	if(self.spawnflags & 4) // Spawnflag for quad start
	 {
//		if (self.frame == 0)
//			self.frame = 207;
		self.skin = 1;           //blue skin	

	// Set default quad activation radius if none set...
		if(self.lip == 0)
			self.lip = 128;

			// set up thinks
			self.th_stand = sserp_quadwait1;
			self.th_walk = sserp_quadwait1;
			self.th_run = sserp_quadwait1;
			self.th_melee = sserp_quadwait1;
			self.th_missile = sserp_quadwait1;
			self.th_pain = serpquad_painwake;
			self.th_die = sserp_quadwait1;
			total_monsters = total_monsters + 1; // can't use flymonster_start(), so bump monster count 1
			
		if(self.targetname != "") // if targetname is set too, only activate via trigger.
		 {
			self.use = serpquad_wake;
			self.takedamage = DAMAGE_NO; // triggered quadmode can't take damage before activation.
		 }
		 else
		  self.takedamage = DAMAGE_AIM; // Shoot it if you don't know it's a monster...
		  
		if (!droptofloor(0,0))
		{
		dprint ("monster_serpent fell out of level at ");
		dprint (vtos(self.origin));
		dprint ("\n");
		remove(self);
		return;
		}
		self.movetype = MOVETYPE_FLY;  // avelocity doesn't work otherwise
		self.flags = self.flags - (self.flags | FL_ONGROUND); // same here
		self.avelocity = '0 90 0'; // spinspinspin, wheee
	
		// spread think times so they don't all happen at same time
		self.think = sserp_quadwait1;
		self.nextthink = self.nextthink + random()*0.5;
	 }
	else if(self.spawnflags & 8) // Spawnflag for Trog (ceilinghang) start
	 {
		// Set default trog activation radius if none set...
		if(self.lip == 0)
			self.lip = 128;

			// set up thinks
			self.th_stand = sserp_trogwait1;
			self.th_walk = sserp_trogwait1;
			self.th_run = sserp_trogwait1;
			self.th_melee = sserp_trogwait1;
			self.th_missile = sserp_trogwait1;
			self.th_pain = serpquad_painwake;
			self.th_die = sserp_trogwait1;
			self.movetype = MOVETYPE_NONE; // can't move when attached to ceiling.
			total_monsters = total_monsters + 1; // can't use flymonster_start(), so bump monster count 1
			
		if(self.targetname != "") // if targetname is set too, only activate via trigger.
		 {
			self.use = serpquad_wake;
			self.takedamage = DAMAGE_NO; // triggered quadmode can't take damage before activation.
		 }
		 else
		  self.takedamage = DAMAGE_AIM; // Shoot it if you don't know it's a monster...
	
		// spread think times so they don't all happen at same time
		self.think = sserp_trogwait1;
		self.nextthink = self.nextthink + random()*0.5;
	 }
	else if(self.spawnflags & 16) // Spawnflag for Walltrap start
	 {

//		if (self.frame == 0)
//			self.frame = 238;
		self.skin = 1;    // blue skin

		// Set default trog activation radius if none set...
		if(self.lip == 0)
			self.lip = 128;

			// set up thinks
			self.th_stand = sserp_wtwait1;
			self.th_walk = sserp_wtwait1;
			self.th_run = sserp_wtwait1;
			self.th_melee = sserp_wtwait1;
			self.th_missile = sserp_wtwait1;
			self.th_pain = serpquad_painwake;
			self.th_die = sserp_wtwait1;
			self.movetype = MOVETYPE_NONE; // can't move when attached to wall.
			total_monsters = total_monsters + 1; // can't use flymonster_start(), so bump monster count 1
			
		if(self.targetname != "") // if targetname is set too, only activate via trigger.
		 {
			self.use = serpquad_wake;
			self.takedamage = DAMAGE_NO; // triggered quadmode can't take damage before activation.
		 }
		 else
		  self.takedamage = DAMAGE_AIM; // Shoot it if you don't know it's a monster...
	
		// spread think times so they don't all happen at same time
		self.think = sserp_wtwait1;
		self.nextthink = self.nextthink + random()*0.5;
	 }	 
	else // normal start
	 {
		self.th_stand = sserp_stand1;
		self.th_walk = sserp_walk1;
		self.th_run = sserp_run1;
		self.th_melee = sserp_melee;
		self.th_missile = sserp_missile;
		self.th_pain = sserp_pain;
		self.th_die = sserp_die;
		flymonster_start ();
	 }
};



// Below disabled for now

/*
=================
SSerpCheckAttack
=================
*/
float()	SSerpCheckAttack =
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
			sserp_run1 ();
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
			sserp_run1 ();
		}
		return FALSE;
	}
			
	if (enemy_range == RANGE_MELEE)
		chance = 0.9;
	else if (enemy_range == RANGE_NEAR)
		chance = 0.6;
	else if (enemy_range == RANGE_MID)
		chance = 0.2;
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
			sserp_run1 ();
		}
	}
	else
	{
		if (self.attack_state != AS_SLIDING)
		{
			self.attack_state = AS_SLIDING;
//			wiz_side1 ();
		}
	}
	
	return FALSE;
};

/*
=================
SSerpAttackFinished
=================
*/
void()	SSerpAttackFinished =
{
	if (enemy_range >= RANGE_MID || !enemy_vis)
	{
		self.attack_state = AS_STRAIGHT;
		self.think = sserp_run1;
	}
	else
	{
		self.attack_state = AS_SLIDING;
//		self.think = sserp_side1;
	}
};
