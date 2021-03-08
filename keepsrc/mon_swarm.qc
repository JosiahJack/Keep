/*
======================================================================================

BEEZ   - MadFox - 18sept2013 -

======================================================================================
*/

$cd id1/models/swarm
$origin 0 0 24
$base base	
$skin base

$frame idle1 idle2 idle3 idle4 idle5 idle6 idle7 
$frame sqrm1 sqrm2 sqrm3 sqrm4 sqrm5 sqrm6 sqrm7 sqrm8 sqrm9 sqrm10 sqrm11 sqrm12 sqrm13 sqrm14
$frame strif1 strif2 strif3 strif4 strif5 strif6 strif7 strif8 
$frame trsh1 trsh2 trsh3 trsh4 trsh5 trsh6 trsh7 trsh8 trsh9 
$frame pain1 pain2 pain3 pain4 pain5 pain6 pain7 pain8 
$frame stng1 stng2 stng3 stng4 stng5 stng6 stng7 stng8 stng9 
$frame die1 die2 die3 die4 die5 die6 die7 die8 die9 die10 die11 die12 die13 die14

void() swrm_stand1    =[  $idle1,       swrm_stand2  ] {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "sound/bee.wav", 1,  ATTN_IDLE);
ai_stand();self.nextthink = time + 0.05;};
void() swrm_stand2    =[  $idle2,       swrm_stand3  ] {ai_stand();self.nextthink = time + 0.05;};
void() swrm_stand3    =[  $idle3,       swrm_stand4  ] {ai_stand();self.nextthink = time + 0.05;};
void() swrm_stand4    =[  $idle4,       swrm_stand5  ] {ai_stand();self.nextthink = time + 0.05;};
void() swrm_stand5    =[  $idle5,       swrm_stand6  ] {ai_stand();self.nextthink = time + 0.05;};
void() swrm_stand6    =[  $idle6,       swrm_stand7  ] {ai_stand();self.nextthink = time + 0.05;};
void() swrm_stand7    =[  $idle7,       swrm_stand1  ] {ai_stand();self.nextthink = time + 0.05;};

void() swrm_walk1    =[  $sqrm1,       swrm_walk2  ] {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "sound/bee.wav", 1,  ATTN_IDLE);
ai_walk(2);self.nextthink = time + 0.05;};
void() swrm_walk2    =[  $sqrm2,       swrm_walk3  ] {ai_walk(3);self.nextthink = time + 0.05;};
void() swrm_walk3    =[  $sqrm3,       swrm_walk4  ] {ai_walk(4);self.nextthink = time + 0.05;};
void() swrm_walk4    =[  $sqrm4,       swrm_walk5  ] {ai_walk(3);self.nextthink = time + 0.05;};
void() swrm_walk5    =[  $sqrm5,       swrm_walk6  ] {ai_walk(2);self.nextthink = time + 0.05;};
void() swrm_walk6    =[  $sqrm6,       swrm_walk7  ] {ai_walk(3);self.nextthink = time + 0.05;};
void() swrm_walk7    =[  $sqrm7,       swrm_walk8  ] {ai_walk(4);self.nextthink = time + 0.05;};
void() swrm_walk8    =[  $sqrm8,       swrm_walk9  ] {ai_walk(3);self.nextthink = time + 0.05;};
void() swrm_walk9    =[  $sqrm9,       swrm_walk10 ] {ai_walk(2);self.nextthink = time + 0.05;};
void() swrm_walk10   =[  $sqrm10,      swrm_walk11 ] {ai_walk(3);self.nextthink = time + 0.05;};
void() swrm_walk11   =[  $sqrm11,      swrm_walk12 ] {ai_walk(4);self.nextthink = time + 0.05;};
void() swrm_walk12   =[  $sqrm12,      swrm_walk13 ] {ai_walk(3);self.nextthink = time + 0.05;};
void() swrm_walk13   =[  $sqrm13,      swrm_walk14 ] {ai_walk(2);self.nextthink = time + 0.05;};
void() swrm_walk14   =[  $sqrm14,      swrm_walk1  ] {ai_walk(2);self.nextthink = time + 0.05;};

void() swrm_run1    =[  $strif1,       swrm_run2  ] {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "sound/bee.wav", 1,  ATTN_IDLE);
ai_run(8);self.nextthink = time + 0.05;};
void() swrm_run2    =[  $strif2,       swrm_run3  ] {ai_run(8);self.nextthink = time + 0.05;};
void() swrm_run3    =[  $strif3,       swrm_run4  ] {ai_run(8);self.nextthink = time + 0.05;};
void() swrm_run4    =[  $strif4,       swrm_run5  ] {ai_run(8);self.nextthink = time + 0.05;};
void() swrm_run5    =[  $strif5,       swrm_run6  ] {ai_run(8);self.nextthink = time + 0.05;};
void() swrm_run6    =[  $strif6,       swrm_run7  ] {ai_run(8);self.nextthink = time + 0.05;};
void() swrm_run7    =[  $strif7,       swrm_run8  ] {ai_run(8);self.nextthink = time + 0.05;};
void() swrm_run8    =[  $strif8,       swrm_run1  ] {ai_run(8);self.nextthink = time + 0.05;};

void() swrm_pain1    =[  $trsh1,       swrm_pain2  ] {ai_charge_side();self.nextthink = time + 0.05;};
void() swrm_pain2    =[  $trsh2,       swrm_pain3  ] {ai_charge_side();self.nextthink = time + 0.05;};
void() swrm_pain3    =[  $trsh3,       swrm_pain4  ] {ai_charge_side();self.nextthink = time + 0.05;};
void() swrm_pain4    =[  $trsh4,       swrm_pain5  ] {ai_melee_side();self.nextthink = time + 0.05;};
void() swrm_pain5    =[  $trsh5,       swrm_pain6  ] {ai_melee_side();self.nextthink = time + 0.05;};
void() swrm_pain6    =[  $trsh6,       swrm_pain7  ] {ai_melee_side();self.nextthink = time + 0.05;};
void() swrm_pain7    =[  $trsh7,       swrm_pain8  ] {ai_charge_side();self.nextthink = time + 0.05;};
void() swrm_pain8    =[  $trsh8,       swrm_pain9  ] {ai_charge_side();self.nextthink = time + 0.05;};
void() swrm_pain9    =[  $trsh9,       swrm_run1   ] {ai_charge_side();self.nextthink = time + 0.05;};

void() swrm_paina1    =[  $pain1,       swrm_paina2  ] {ai_charge_side();self.nextthink = time + 0.05;};
void() swrm_paina2    =[  $pain2,       swrm_paina3  ] {ai_charge_side();self.nextthink = time + 0.05;};
void() swrm_paina3    =[  $pain3,       swrm_paina4  ] {ai_charge_side();self.nextthink = time + 0.05;};
void() swrm_paina4    =[  $pain4,       swrm_paina5  ] {ai_charge_side();self.nextthink = time + 0.05;};
void() swrm_paina5    =[  $pain5,       swrm_paina6  ] {ai_charge_side();self.nextthink = time + 0.05;};
void() swrm_paina6    =[  $pain6,       swrm_paina7  ] {ai_charge_side();self.nextthink = time + 0.05;};
void() swrm_paina7    =[  $pain7,       swrm_paina8  ] {ai_charge_side();self.nextthink = time + 0.05;};
void() swrm_paina8    =[  $pain8,       swrm_run1    ] {ai_charge_side();self.nextthink = time + 0.05;};

void(entity attacker, float damage)	swrm_pain =
{
	local float r;

	if (self.pain_finished > time)
		return;

	r = random();
	
	sound (self, CHAN_VOICE, "sound/bee.wav", 1, ATTN_NORM);
	if (r < 0.85)
	{
		swrm_pain1 ();
		self.pain_finished = time + 1;
	}
	else
	{
		swrm_paina1 ();
		self.pain_finished = time + 1;
	}
	
};

void() swrm_stng1    =[  $stng1,       swrm_stng2  ] {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "sound/bee1.wav", 1,  ATTN_IDLE);
ai_face();self.nextthink = time + 0.05;};
void() swrm_stng2    =[  $stng2,       swrm_stng3  ] {ai_face();self.nextthink = time + 0.05;};
void() swrm_stng3    =[  $stng3,       swrm_stng4  ] {ai_face();self.nextthink = time + 0.05;};
void() swrm_stng4    =[  $stng4,       swrm_stng5  ] {ai_face();self.nextthink = time + 0.05;};
void() swrm_stng5    =[  $stng5,       swrm_stng6  ] {ai_face();self.nextthink = time + 0.05;};
void() swrm_stng6    =[  $stng6,       swrm_stng7  ] {ai_face();ai_melee();self.nextthink = time + 0.05;};
void() swrm_stng7    =[  $stng7,       swrm_stng8  ] {ai_face();ai_melee();self.nextthink = time + 0.05;};
void() swrm_stng8    =[  $stng8,       swrm_stng9  ] {ai_face();ai_melee();self.nextthink = time + 0.05;};
void() swrm_stng9    =[  $stng9,       swrm_run1   ] {ai_face();self.nextthink = time + 0.05;};

void() swrm_die1    =[  $die1,       swrm_die2  ] {

self.velocity_x = -200 + 400*random();
self.velocity_y = -200 + 400*random();
self.velocity_z = 100 + 100*random();
self.flags = self.flags - (self.flags & FL_ONGROUND);
sound (self, CHAN_VOICE, "sound/bee2.wav", 1, ATTN_NORM);
self.nextthink = time + 0.05;};

void() swrm_die2    =[  $die2,       swrm_die3  ] {self.nextthink = time + 0.05;};
void() swrm_die3    =[  $die3,       swrm_die4  ] {self.solid = SOLID_NOT;self.nextthink = time + 0.05;};
void() swrm_die4    =[  $die4,       swrm_die5  ] {self.nextthink = time + 0.05;};
void() swrm_die5    =[  $die5,       swrm_die6  ] {self.nextthink = time + 0.05;};
void() swrm_die6    =[  $die6,       swrm_die7  ] {self.nextthink = time + 0.05;};
void() swrm_die7    =[  $die7,       swrm_die8  ] {self.nextthink = time + 0.05;};
void() swrm_die8    =[  $die8,       swrm_die9  ] {self.nextthink = time + 0.05;};
void() swrm_die9    =[  $die9,       swrm_die10 ] {self.nextthink = time + 0.05;};
void() swrm_die10   =[  $die10,      swrm_die11 ] {self.nextthink = time + 0.05;};
void() swrm_die11   =[  $die11,      swrm_die12 ] {self.nextthink = time + 0.05;};
void() swrm_die12   =[  $die12,      swrm_die13 ] {self.nextthink = time + 0.05;};
void() swrm_die13   =[  $die13,      swrm_die14 ] {self.nextthink = time + 0.05;};
void() swrm_die14   =[  $die14,      swrm_die14 ] {};

void() swrm_die =
{
// check for gib
	if (self.health < -40)
	{
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		ThrowGib ("progs/gib2.mdl", self.health);
		ThrowGib ("progs/gib2.mdl", self.health);
		ThrowGib ("progs/gib2.mdl", self.health);
		return;
	}

	swrm_die1 ();
};


void() model_swrm =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
        precache_model ("progs/swarm.mdl");
	precache_sound ("sound/bee.wav");
	precache_sound ("sound/bee1.wav");
	precache_sound ("sound/bee2.wav");
	
	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_TOSS;

	setmodel (self, "progs/swarm.mdl");

	setsize (self, '-12 -12 -12', '12 12 12');
	self.health = 50;

	self.th_stand = swrm_stand1;
	self.th_walk = swrm_walk1;
	self.th_run = swrm_run1;
	self.th_missile = swrm_stng1;
	self.th_pain = swrm_pain;
	self.th_die = swrm_die;
		
	flymonster_start ();
};

