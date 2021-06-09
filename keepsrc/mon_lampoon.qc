/*======================================================

  BARACUDA - monster_fish - madfox

========================================================
*/

$cd id1/models/fish
$origin 0 0 24
$base base		
$skin skin

$frame wank1 wank2 wank3 wank4 wank5 wank6 wank7 wank8 wank9 wank10 
$frame wank11 wank12 wank13 wank14 wank15 wank16 wank17 wank18 wank19  
$frame wank20 wank21 wank22 wank23  

$frame wimp1 wimp2 wimp3 wimp4 wimp5 wimp6 wimp7 wimp8 wimp9 wimp10

$frame wamp1 wamp2 wamp3 wamp4 wamp5 wamp6 wamp7 wamp8 wamp9 wamp10
$frame wamp11 wamp12 wamp13 wamp14 wamp15 wamp16 wamp17 wamp18 wamp19
$frame wamp20

$frame anten1 anten2 anten3 anten4 anten5 anten6 anten7 anten8 anten9 
$frame anten10 anten11 anten12 anten13 anten14 anten15 anten16

$frame pain1 pain2 pain3 pain4 pain5 pain6

$frame paina1 paina2 paina3 paina4

$frame atk1 atk2 atk3 atk4 atk5 atk6 atk7 atk8

$frame die1 die2 die3 die4 die5 die6 die7 die8 die9 die10 die11 die12 
$frame die13 die14 die15 die16 die17

//====================================================================

void() bfish_atka1;
void() bfish_run1;
void() bfish_atka1;

void() bfish_bite =
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

void()	BFish_JumpTouch = {
	local	float	ldmg;

	if (self.health <= 0) return;
		
	if (other.takedamage) {
		if ( vlen(self.velocity) > 300 ) {
			ldmg = 10 + 10*random();
			ldmg = Align_DamageModifier(other,self,ldmg, TRUE);
			T_Damage (other, self, self, ldmg);	
		}
	}

	if (!checkbottom(self)) {
		if (self.flags & FL_ONGROUND) {	// jump randomly to not get hung up
			self.touch = SUB_Null;
			self.think = bfish_atka1;
			self.nextthink = time + 0.1;
		}

		return;	// not on ground yet
	}

	self.touch = SUB_Null;
	self.think = bfish_run1;
	self.nextthink = time + 0.1;
};

void() bfish_stand1  =[      $wank1,        bfish_stand2        ] {ai_stand();};
void() bfish_stand2  =[      $wank2,        bfish_stand3        ] {ai_stand();};
void() bfish_stand3  =[      $wank3,        bfish_stand4        ] {ai_stand();};
void() bfish_stand4  =[      $wank4,        bfish_stand5        ] {ai_stand();};
void() bfish_stand5  =[      $wank5,        bfish_stand6        ] {ai_stand();};
void() bfish_stand6  =[      $wank6,        bfish_stand7        ] {ai_stand();};
void() bfish_stand7  =[      $wank7,        bfish_stand8        ] {ai_stand();};
void() bfish_stand8  =[      $wank8,        bfish_stand9        ] {ai_stand();};
void() bfish_stand9  =[      $wank9,        bfish_stand10       ] {ai_stand();};
void() bfish_stand10 =[      $wank10,       bfish_stand11       ] {ai_stand();};
void() bfish_stand11 =[      $wank11,       bfish_stand12       ] {ai_stand();};
void() bfish_stand12 =[      $wank12,       bfish_stand13       ] {ai_stand();};
void() bfish_stand13 =[      $wank13,       bfish_stand14       ] {ai_stand();};
void() bfish_stand14 =[      $wank14,       bfish_stand15       ] {ai_stand();};
void() bfish_stand15 =[      $wank15,       bfish_stand16       ] {ai_stand();};
void() bfish_stand16 =[      $wank16,       bfish_stand17       ] {ai_stand();};
void() bfish_stand17 =[      $wank17,       bfish_stand18       ] {ai_stand();};
void() bfish_stand18 =[      $wank18,       bfish_stand19       ] {ai_stand();};
void() bfish_stand19 =[      $wank19,       bfish_stand20       ] {ai_stand();};
void() bfish_stand20 =[      $wank20,       bfish_stand21       ] {ai_stand();};
void() bfish_stand21 =[      $wank21,       bfish_stand22       ] {ai_stand();};
void() bfish_stand22 =[      $wank22,       bfish_stand23       ] {ai_stand();};
void() bfish_stand23 =[      $wank23,       bfish_stand1        ] {ai_stand();};
 
void() bfish_walk1  =[      $wamp1,    bfish_walk2   ] {ai_walk(8);};
void() bfish_walk2  =[      $wamp2,    bfish_walk3   ] {ai_walk(8);};
void() bfish_walk3  =[      $wamp3,    bfish_walk4   ] {ai_walk(8);};
void() bfish_walk4  =[      $wamp4,    bfish_walk5   ] {ai_walk(8);};
void() bfish_walk5  =[      $wamp5,    bfish_walk6   ] {ai_walk(8);};
void() bfish_walk6  =[      $wamp6,    bfish_walk7   ] {ai_walk(8);};
void() bfish_walk7  =[      $wamp7,    bfish_walk8   ] {ai_walk(8);};
void() bfish_walk8  =[      $wamp8,    bfish_walk9   ] {ai_walk(8);};
void() bfish_walk9  =[      $wamp9,    bfish_walk10  ] {ai_walk(8);};
void() bfish_walk10 =[      $wamp10,   bfish_walk11  ] {ai_walk(8);};
void() bfish_walk11 =[      $wamp11,   bfish_walk12  ] {ai_walk(8);};
void() bfish_walk12 =[      $wamp12,   bfish_walk13  ] {ai_walk(8);};
void() bfish_walk13 =[      $wamp13,   bfish_walk14  ] {ai_walk(8);};
void() bfish_walk14 =[      $wamp14,   bfish_walk15  ] {ai_walk(8);};
void() bfish_walk15 =[      $wamp15,   bfish_walk16  ] {ai_walk(8);};
void() bfish_walk16 =[      $wamp16,   bfish_walk17  ] {ai_walk(8);};
void() bfish_walk17 =[      $wamp17,   bfish_walk18  ] {ai_walk(8);};
void() bfish_walk18 =[      $wamp18,   bfish_walk19  ] {ai_walk(8);};
void() bfish_walk19 =[      $wamp19,   bfish_walk20  ] {ai_walk(8);};
void() bfish_walk20 =[      $wamp20,   bfish_walk1   ] {ai_walk(8);};
 
void() bfish_run1  =[      $wimp1,    bfish_run2   ] {ai_run(14);};
void() bfish_run2  =[      $wimp2,    bfish_run3   ] {ai_run(12);};
void() bfish_run3  =[      $wimp3,    bfish_run4   ] {ai_run(8);};
void() bfish_run4  =[      $wimp4,    bfish_run5   ] {ai_run(12);};
void() bfish_run5  =[      $wimp5,    bfish_run6   ] {ai_run(14);};
void() bfish_run6  =[      $wimp6,    bfish_run7   ] {ai_run(16);};
void() bfish_run7  =[      $wimp7,    bfish_run8   ] {ai_run(12);};
void() bfish_run8  =[      $wimp8,    bfish_run9   ] {ai_run(8);};
void() bfish_run9  =[      $wimp9,    bfish_run10  ] {ai_run(10);};
void() bfish_run10 =[      $wimp10,   bfish_run1   ] {ai_run(12);};

void()	bfish_paina1	=[	$paina1,		bfish_paina2	] {};
void()	bfish_paina2	=[	$paina2,		bfish_paina3	] {};
void()	bfish_paina3	=[	$paina3,		bfish_paina4    ] {};
void()	bfish_paina4	=[	$paina4,		bfish_run1     	] {};

void()	bfish_pain1	=[	$pain1, 	bfish_pain2	] {ai_painforward(0);};
void()	bfish_pain2	=[	$pain2, 	bfish_pain3	] {ai_painforward(3);};
void()	bfish_pain3	=[	$pain3, 	bfish_pain4	] {};
void()	bfish_pain4	=[	$pain4, 	bfish_pain5	] {};
void()	bfish_pain5	=[	$pain5, 	bfish_pain6	] {ai_painforward(2);};
void()	bfish_pain6	=[	$pain6, 	bfish_run1    	] {ai_painforward(4);};

void(entity attacker, float damage)	bfish_pain =
{
	local float r;

	if (self.pain_finished > time)
		return;

	r = random();
	
	sound (self, CHAN_VOICE, "bfish/khurt.wav", 1, ATTN_NORM);
	if (r < 0.85)
	{
		bfish_pain1 ();
		self.pain_finished = time + 1;
	}

	else
	{
		bfish_paina1 ();
		self.pain_finished = time + 1;
	}
	
};

void() bfish_atk1        =[      $atk1,       bfish_atk2    ] {ai_charge(10);};
void() bfish_atk2        =[      $atk2,       bfish_atk3    ] {ai_charge(10);};
void() bfish_atk3        =[      $atk3,       bfish_atk4    ] {ai_charge(10);};
void() bfish_atk4        =[      $atk4,       bfish_atk5    ] {ai_charge(10);};
void() bfish_atk5        =[      $atk5,       bfish_atk6    ] {ai_charge(10);};
void() bfish_atk6        =[      $atk6,       bfish_atk7    ] {ai_charge(10); bfish_bite();};
void() bfish_atk7        =[      $atk7,       bfish_atk8    ] {ai_charge(10);};
void() bfish_atk8        =[      $atk8,       bfish_run1    ] {ai_charge(10);};

void() bfish_atka1  =[      $anten1,    bfish_atka2   ] {ai_face();};
void() bfish_atka2  =[      $anten2,    bfish_atka3   ] {ai_face();};
void() bfish_atka3  =[      $anten3,    bfish_atka4   ] {ai_face();};
void() bfish_atka4  =[      $anten4,    bfish_atka5   ] {ai_face();};
void() bfish_atka5  =[      $anten5,    bfish_atka6   ] {ai_face();};
void() bfish_atka6  =[      $anten6,    bfish_atka7   ] {ai_face();};
void() bfish_atka7  =[      $anten7,    bfish_atka8   ] {ai_face();};
void() bfish_atka8  =[      $anten8,    bfish_atka9   ] 
{
	ai_face();
	
	self.touch = BFish_JumpTouch;
	makevectors2 (self.angles);
	self.origin_z = self.origin_z + 1;
	self.velocity = v_forward * 300 + '0 0 200';

	if (self.flags & FL_ONGROUND)
		self.flags = self.flags - FL_ONGROUND;
};

void() bfish_atka9  =[      $anten9,    bfish_atka10  ] {ai_charge(10);};
void() bfish_atka10 =[      $anten10,   bfish_atka11  ] {ai_charge(10);};
void() bfish_atka11 =[      $anten11,   bfish_atka12  ] {ai_face();};
void() bfish_atka12 =[      $anten12,   bfish_atka13  ] {ai_charge(10);};
void() bfish_atka13 =[      $anten13,   bfish_atka14  ] {ai_charge(10);};
void() bfish_atka14 =[      $anten14,   bfish_atka15  ] {ai_face();};
void() bfish_atka15 =[      $anten15,   bfish_atka16  ] {ai_charge(10);};
void() bfish_atka16 =[      $anten16,   bfish_run1    ] {ai_face();};

void() bfish_die1 =[      $die1,        bfish_die2        ] 
{
	sound (self, CHAN_VOICE, "fish/die.wav", 1, ATTN_NORM);
};

void() bfish_die2 =[      $die2,        bfish_die3        ] {self.solid = SOLID_NOT;};	// gb, become nonsolid faster
void() bfish_die3 =[      $die3,        bfish_die4        ] {};
void() bfish_die4 =[      $die4,        bfish_die5        ] {};
void() bfish_die5 =[      $die5,        bfish_die6        ] {};
void() bfish_die6 =[      $die6,        bfish_die7        ] {};
void() bfish_die7 =[      $die7,        bfish_die8        ] {};
void() bfish_die8 =[      $die8,        bfish_die9        ] {};
void() bfish_die9 =[      $die9,        bfish_die10       ] {};
void() bfish_die10 =[      $die10,       bfish_die11       ] {};
void() bfish_die11 =[      $die11,       bfish_die12       ] {};
void() bfish_die12 =[      $die12,       bfish_die13       ] {};
void() bfish_die13 =[      $die13,       bfish_die14       ] {};
void() bfish_die14 =[      $die14,       bfish_die15       ] {};
void() bfish_die15 =[      $die15,       bfish_die16       ] {};
void() bfish_die16 =[      $die16,       bfish_die17       ] {};
void() bfish_die17 =[      $die17,       bfish_die17       ] {};

/*==============
CheckBFishJump
==============*/
float()	CheckBFishJump = {
	local	vector	dist;
	local	float	d;

	if (self.origin_z + self.mins_z > self.enemy.origin_z + self.enemy.mins_z + 0.75 * self.enemy.size_z)
		return FALSE;
		
	if (self.origin_z + self.maxs_z < self.enemy.origin_z + self.enemy.mins_z + 0.25 * self.enemy.size_z)
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

/*QUAKED monster_fish (1 0 0) (-16 -16 -24) (16 16 24) Ambush
*/
void() monster_lampoon =
{
	// Check for any random monster setups
	if (monster_checkrandomizer() == TRUE) return;
	// Check all spawn exceptions (monsters.qc)
	if (monster_checkspawn() == TRUE) return;

	precache_model ("progs/lampoon.mdl");

	precache_sound ("fish/death.wav");
	precache_sound ("fish/bite.wav");
	precache_sound ("fish/idle.wav");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/lampoon.mdl");

	setsize (self, '-16 -16 -24', '16 16 24');
	self.health = 100;
	
	self.th_stand = bfish_stand1;
	self.th_walk = bfish_walk1;
	self.th_run = bfish_run1;
	self.th_die = bfish_die1;
	self.th_pain = bfish_pain;
	self.th_melee = bfish_atk1;
	self.th_missile = bfish_atka1;	

	// Check for random rotation setup and angle limits
	if (self.angles_y < 0) self.angles_y = rint(random()*359);
	if (self.angles_y > 360) self.angles_y = 360;

	monster_start ();
};



