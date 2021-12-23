/*
==============================================================================

ELDEN OGRE -  shield ogre - madfox

==============================================================================
*/

$cd /raid/quake/id1/models/xogre
$origin 0 0 24
$base base
$skin badass3

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10
$frame walk11 walk12 walk13 walk14 walk15 walk16 

$frame run1 run2 run3 run4 run5 run6 run7 run8

$frame throw1 throw2 throw3 throw4 throw5 throw6 throw7 throw8 throw9
$frame throw10 throw11 throw12 throw13 throw14 throw15 

$frame swing1 swing2 swing3 swing4 swing5 swing6 swing7 swing8 swing9 swing10  
$frame swing11 swing12 swing13 swing14 

$frame mash1 mash2 mash3 mash4 mash5 mash6 mash7 mash8 mash9 mash10 mash11 
$frame mash12 mash13 mash14 mash15 mash16 mash17

$frame shield1 shield2 shield3 shield4 shield5 shield6 shield7 shield8 shield9
$frame shield10 shield11 shield12 

$frame pain1 pain2 pain3 pain4 pain5 pain6  
 
$frame painb1 painb2 painb3 painb4 

$frame painc1 painc2 painc3 painc4 painc5 painc6

$frame paind1 paind2 paind3 paind4 paind5 paind6 paind7 paind8 paind9
$frame paind10 paind11 paind12 paind13 paind14 paind15

$frame paine1 paine2 paine3 paine4 paine5 paine6 paine7 paine8 paine9
$frame paine10 paine11 paine12 paine13 paine14 paine15 paine16 paine17

$frame death1 death2 death3 death4 death5 death6 death7 death8 death9 death10
$frame death11 death12 death13 death14 death15 

$frame bdeath1 bdeath2 bdeath3 bdeath4 bdeath5 bdeath6 bdeath7 bdeath8 bdeath9 
$frame bdeath10

$frame laugh1 laugh2 laugh3 laugh4 laugh5 laugh6 laugh7 laugh8 laugh9 laugh10  
$frame laugh11 laugh12 laugh13 laugh14 laugh15 laugh16 laugh17

void()	xogre_laugh1;
void()	xogre_walk1;

void() xogre_face =
{
// go for another player if multi player
	if (self.enemy.health <= 0 || random() < 0.02)
	{
		self.enemy = find(self.enemy, classname, "player");
		if (!self.enemy)
			self.enemy = find(self.enemy, classname, "player");
	}
	ai_face();
};

void() Taxe_Touch =
{
	local vector org;
	
	if (other == self.owner)
		return;		// don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	
	sound (self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_STATIC);
	org = self.origin - 8*normalize(self.velocity);

	if (other.health)
	{
		SpawnBlood (org, self.velocity*0.2, 15);
		T_Damage (other, self, self.owner, 15);
	sound (self, CHAN_WEAPON, "player/axhit1.wav", 1, ATTN_STATIC);

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
void(vector org, vector vec) LaunchTaxe =
{
	local	vector	vec;
		
	if (self.classname == "monster_enforcer")
		sound (self, CHAN_WEAPON, "knight/sword2.wav", 1, ATTN_NORM);

	vec = normalize(vec);
	
	newmis = spawn();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLY;
	newmis.solid = SOLID_BBOX;
  
	setmodel (newmis, "progs/taxe.mdl");
	setsize (newmis, '0 0 0', '0 0 0');		

 	setorigin (newmis, org);
        newmis.velocity = vec * 400;
        newmis.avelocity = '-340 0 0';  
	newmis.angles = vectoangles(newmis.velocity);
	newmis.nextthink = time + 5;
	newmis.think = SUB_Remove;
	newmis.touch = Taxe_Touch;

};

void() xogre_fire =
{
	local vector org;

	makevectors (self.angles);
	
	org = self.origin + v_forward * 30 + v_right * 8.5 + '0 0 16';

	LaunchTaxe(org, self.enemy.origin - self.origin);
};

void()	xogre_laugh1	=[	$laugh1,		xogre_laugh2	] {};
void()	xogre_laugh2	=[	$laugh2,		xogre_laugh3	] {};
void()	xogre_laugh3	=[	$laugh3,		xogre_laugh4	] {};
void()	xogre_laugh4	=[	$laugh4,		xogre_laugh5	] {};
void()	xogre_laugh5	=[	$laugh5,		xogre_laugh6	] {};
void()	xogre_laugh6	=[	$laugh6,		xogre_laugh7	] {};
void()	xogre_laugh7	=[	$laugh7,		xogre_laugh8	] {};
void()	xogre_laugh8	=[	$laugh8,		xogre_laugh9	] {};
void()	xogre_laugh9	=[	$laugh9,		xogre_laugh10   ] {};
void()	xogre_laugh10   =[	$laugh10,       	xogre_laugh11	] {};
void()	xogre_laugh11	=[	$laugh11,	        xogre_laugh12	] {};
void()	xogre_laugh12	=[	$laugh12,       	xogre_laugh13	] {};
void()	xogre_laugh13	=[	$laugh13,       	xogre_laugh14	] {};
void()	xogre_laugh14	=[	$laugh14,       	xogre_laugh15	] {};
void()	xogre_laugh15	=[	$laugh15,       	xogre_laugh16	] {};
void()	xogre_laugh16	=[	$laugh16,       	xogre_laugh17	] {};
void()	xogre_laugh17	=[	$laugh17,       	xogre_run1      ] {};

void() OgreCheckLaugh = {
       local vector spot1, spot2;
       local float dist;
 
       if (!self.lefty) return; // our enemy isn't dead
           spot1 = self.origin + self.view_ofs;
           spot2 = self.enemy.origin +   self.enemy.view_ofs;
           dist = vlen(spot1 - spot2);
 
       if (dist < 64) {
           self.think = xogre_laugh1;
           self.nextthink = time + 0.1;
       }
};

void()	xogre_stand1	=[	$stand1,	xogre_stand2	] {ai_stand();};
void()	xogre_stand2	=[	$stand2,	xogre_stand3	] {ai_stand();};
void()	xogre_stand3	=[	$stand3,	xogre_stand4	] {ai_stand();};
void()	xogre_stand4	=[	$stand4,	xogre_stand5	] {ai_stand();};
void()	xogre_stand5	=[	$stand5,	xogre_stand6	] {ai_stand();};
void()	xogre_stand6	=[	$stand6,	xogre_stand7	] {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "ogre/ogidle.wav", 1, ATTN_IDLE);
ai_stand();};
void()	xogre_stand7	=[	$stand7,	xogre_stand8	] {ai_stand();};
void()	xogre_stand8	=[	$stand8,	xogre_stand1	] {ai_stand();};

void()	xogre_walk1	=[	$walk1,		xogre_walk2	] {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "ogre/ogidle.wav", 1,  ATTN_IDLE);
ai_walk(3);  OgreCheckLaugh();};
void()	xogre_walk2	=[	$walk2,		xogre_walk3	] {ai_walk(2); OgreCheckLaugh();};
void()	xogre_walk3	=[	$walk3,		xogre_walk4	] {ai_walk(3); OgreCheckLaugh();};
void()	xogre_walk4	=[	$walk4,		xogre_walk5	] {ai_walk(4); OgreCheckLaugh();};
void()	xogre_walk5	=[	$walk5,		xogre_walk6	] {ai_walk(3); OgreCheckLaugh();};
void()	xogre_walk6	=[	$walk6,		xogre_walk7	] {ai_walk(3); OgreCheckLaugh();};
void()	xogre_walk7	=[	$walk7,		xogre_walk8	] {ai_walk(3); OgreCheckLaugh();};
void()	xogre_walk8	=[	$walk8,		xogre_walk9	] {ai_walk(4); OgreCheckLaugh();};
void()	xogre_walk9	=[	$walk9,		xogre_walk10	] {ai_walk(3); OgreCheckLaugh();};
void()	xogre_walk10	=[	$walk10,	xogre_walk11	] {ai_walk(3); OgreCheckLaugh();};
void()	xogre_walk11	=[	$walk11,	xogre_walk12	] {ai_walk(3); OgreCheckLaugh();};
void()	xogre_walk12	=[	$walk12,	xogre_walk13	] {ai_walk(3);  OgreCheckLaugh();};
void()	xogre_walk13	=[	$walk13,	xogre_walk14	] {ai_walk(3); OgreCheckLaugh();};
void()	xogre_walk14	=[	$walk14,	xogre_walk15	] {ai_walk(4); OgreCheckLaugh();};
void()	xogre_walk15	=[	$walk15,	xogre_walk16	] {ai_walk(3); OgreCheckLaugh();};
void()	xogre_walk16	=[	$walk16,	xogre_walk1	] {ai_walk(3); OgreCheckLaugh();};

void()	xogre_run1	=[	$run1,		xogre_run2	] {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "ogre/ogidle2.wav", 1,  ATTN_IDLE);
ai_run(16);};
void()	xogre_run2	=[	$run2,		xogre_run3	] {ai_run(20);};
void()	xogre_run3	=[	$run3,		xogre_run4	] {ai_run(13);};
void()	xogre_run4	=[	$run4,		xogre_run5	] {ai_run(7);};
void()	xogre_run5	=[	$run5,		xogre_run6	] {ai_run(16);};
void()	xogre_run6	=[	$run6,		xogre_run7	] {ai_run(20);};
void()	xogre_run7	=[	$run7,		xogre_run8	] {ai_run(14);};
void()	xogre_run8	=[	$run8,		xogre_run1	] {ai_run(6);};

void()  xogre_throw1    =[      $throw1,        xogre_throw2    ] {ai_face();}; 
void()  xogre_throw2    =[      $throw2,        xogre_throw3    ] {};
void()  xogre_throw3    =[      $throw3,        xogre_throw4    ] {};
void()  xogre_throw4    =[      $throw4,        xogre_throw5    ] {};
void()  xogre_throw5    =[      $throw5,        xogre_throw6    ] {ai_face();};
void()  xogre_throw6    =[      $throw6,        xogre_throw7    ] {}; 
void()  xogre_throw7    =[      $throw7,        xogre_throw8    ] {};
void()  xogre_throw8    =[      $throw8,        xogre_throw9    ] {ai_face();};
void()  xogre_throw9    =[      $throw9,        xogre_throw10   ] {xogre_fire();};
void()  xogre_throw10   =[      $throw10,       xogre_throw11   ] {};
void()  xogre_throw11   =[      $throw11,       xogre_throw12   ] {ai_face();};
void()  xogre_throw12   =[      $throw12,       xogre_throw13   ] {};
void()  xogre_throw13   =[      $throw13,       xogre_throw14   ] {};
void()  xogre_throw14   =[      $throw14,       xogre_throw15   ] {ai_face();};
void()  xogre_throw15   =[      $throw15,       xogre_run1      ] {};

void()  xogre_swing1    =[      $swing1,        xogre_swing2    ] {ai_face();}; 
void()  xogre_swing2    =[      $swing2,        xogre_swing3    ] {};
void()  xogre_swing3    =[      $swing3,        xogre_swing4    ] {ai_charge(4);};
void()  xogre_swing4    =[      $swing4,        xogre_swing5    ] {ai_charge(5);};
void()  xogre_swing5    =[      $swing5,        xogre_swing6    ] {ai_charge(6);};
void()  xogre_swing6    =[      $swing6,        xogre_swing7    ] {ai_charge(7);}; 
void()  xogre_swing7    =[      $swing7,        xogre_swing8    ] {ai_melee();};
void()  xogre_swing8    =[      $swing8,        xogre_swing9    ] {ai_melee();};
void()  xogre_swing9    =[      $swing9,        xogre_swing10   ] {ai_melee();};
void()  xogre_swing10   =[      $swing10,       xogre_swing11   ] {ai_charge(4);};
void()  xogre_swing11   =[      $swing11,       xogre_swing12   ] {ai_charge(5);};
void()  xogre_swing12   =[      $swing12,       xogre_swing13   ] {ai_charge(6);};
void()  xogre_swing13   =[      $swing13,       xogre_swing14   ] {ai_face();};
void()  xogre_swing14   =[      $swing14,       xogre_run1      ] {};

void()	xogre_atk1	=[	$mash1,		xogre_atk2	]
{sound (self, CHAN_WEAPON, "ogre/ogidle2.wav", 1, ATTN_NORM);
ai_charge(2);};
void()	xogre_atk2	=[	$mash2,		xogre_atk3	] {ai_charge(7);};
void()	xogre_atk3	=[	$mash3,		xogre_atk4	] {ai_charge(4);};
void()	xogre_atk4	=[	$mash4,		xogre_atk5	] {ai_charge(2);};
void()	xogre_atk5	=[	$mash5,		xogre_atk6	] {ai_charge(3);};
void()	xogre_atk6	=[	$mash6,		xogre_atk7	] {ai_charge(4); ai_melee();};
void()	xogre_atk7	=[	$mash7,		xogre_atk8	] {ai_charge(1); ai_melee();};
void()	xogre_atk8	=[	$mash8,		xogre_atk9	] {ai_charge(3); ai_melee();};
void()	xogre_atk9	=[	$mash9,		xogre_atk10     ] {ai_charge(3);};
void()	xogre_atk10     =[	$mash10,	xogre_atk11	] {ai_charge(5);};
void()	xogre_atk11	=[	$mash11,	xogre_atk12	] {};
void()	xogre_atk12	=[	$mash12,	xogre_atk13	] {ai_charge(2);};
void()	xogre_atk13	=[	$mash13,	xogre_atk14	] {ai_charge(3);};
void()	xogre_atk14	=[	$mash14,	xogre_atk15	] {ai_charge(4); ai_melee();};
void()	xogre_atk15	=[	$mash15,	xogre_atk16	] {ai_charge(1); ai_melee();};
void()	xogre_atk16	=[	$mash16,	xogre_atk17	] {ai_charge(3); ai_melee();};
void()	xogre_atk17	=[	$mash17,	xogre_run1      ] {ai_charge(3);};

void()	xogre_shield1	=[	$shield1,		xogre_shield2	] {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "ogre/ogwake.wav", 1,  ATTN_IDLE);
ai_run(16);};
void()	xogre_shield2	=[	$shield2,		xogre_shield3	] {};
void()	xogre_shield3	=[	$shield3,		xogre_shield4	] {};
void()	xogre_shield4	=[	$shield4,		xogre_shield5	] {};
void()	xogre_shield5	=[	$shield5,		xogre_shield6	] {};
void()	xogre_shield6	=[	$shield6,		xogre_shield7	] {};
void()	xogre_shield7	=[	$shield7,		xogre_shield8	] {};
void()	xogre_shield8	=[	$shield8,		xogre_shield9	] {};
void()	xogre_shield9	=[	$shield9,		xogre_shield10	] {};
void()	xogre_shield10	=[	$shield10,		xogre_shield11	] {};
void()	xogre_shield11	=[	$shield11,		xogre_shield12	] {};
void()	xogre_shield12	=[	$shield12,		xogre_run1	] {};

void()	xogre_pain1	=[	$pain1, 	xogre_pain2	] { ai_painforward(0);};
void()	xogre_pain2	=[	$pain2, 	xogre_pain3	] {ai_painforward(3);};
void()	xogre_pain3	=[	$pain3, 	xogre_pain4	] {ai_painforward(4);};
void()	xogre_pain4	=[	$pain4, 	xogre_pain5	] {};
void()	xogre_pain5	=[	$pain5, 	xogre_pain6	] {ai_painforward(2);};
void()	xogre_pain6	=[	$pain6, 	xogre_run1	] {};

void()	xogre_painb1	=[	$painb1, 	xogre_painb2	] {ai_painforward(0);};
void()	xogre_painb2	=[	$painb2, 	xogre_painb3	] {ai_painforward(3);};
void()	xogre_painb3	=[	$painb3, 	xogre_painb4	] {};
void()	xogre_painb4	=[	$painb4, 	xogre_run1	] {};

void()	xogre_painc1	=[	$painc1, 	xogre_painc2	] { ai_painforward(0);};
void()	xogre_painc2	=[	$painc2, 	xogre_painc3	] {ai_painforward(3);};
void()	xogre_painc3	=[	$painc3, 	xogre_painc4	] {ai_painforward(4);};
void()	xogre_painc4	=[	$painc4, 	xogre_painc5	] {};
void()	xogre_painc5	=[	$painc5, 	xogre_painc6	] {ai_painforward(2);};
void()	xogre_painc6	=[	$painc6, 	xogre_run1	] {};

void()	xogre_paind1	=[	$paind1, 	xogre_paind2	] { ai_painforward(0);};
void()	xogre_paind2	=[	$paind2, 	xogre_paind3	] {ai_painforward(3);};
void()	xogre_paind3	=[	$paind3, 	xogre_paind4	] {ai_painforward(4);};
void()	xogre_paind4	=[	$paind4, 	xogre_paind5	] {};
void()	xogre_paind5	=[	$paind5, 	xogre_paind6	] {ai_painforward(2);};
void()	xogre_paind6	=[	$paind6, 	xogre_paind7	] {};
void()	xogre_paind7	=[	$paind7, 	xogre_paind8	] { ai_painforward(0);};
void()	xogre_paind8	=[	$paind8, 	xogre_paind9	] {ai_painforward(3);};
void()	xogre_paind9	=[	$paind9, 	xogre_paind10	] {ai_painforward(4);};
void()	xogre_paind10	=[	$paind10, 	xogre_paind11	] {ai_painforward(3);};
void()	xogre_paind11	=[	$paind11, 	xogre_paind12	] {ai_painforward(2);};
void()	xogre_paind12	=[	$paind12, 	xogre_paind13	] {};
void()	xogre_paind13	=[	$paind13, 	xogre_paind14	] { ai_painforward(0);};
void()	xogre_paind14	=[	$paind14, 	xogre_paind15	] {ai_painforward(3);};
void()	xogre_paind15	=[	$paind15, 	xogre_run1	] {};

void()	xogre_paine1	=[	$paine1, 	xogre_paine2	] { ai_painforward(0);};
void()	xogre_paine2	=[	$paine2, 	xogre_paine3	] {ai_painforward(3);};
void()	xogre_paine3	=[	$paine3, 	xogre_paine4	] {ai_painforward(4);};
void()	xogre_paine4	=[	$paine4, 	xogre_paine5	] {};
void()	xogre_paine5	=[	$paine5, 	xogre_paine6	] {ai_painforward(2);};
void()	xogre_paine6	=[	$paine6, 	xogre_paine7	] {};
void()	xogre_paine7	=[	$paine7, 	xogre_paine8	] { ai_painforward(0);};
void()	xogre_paine8	=[	$paine8, 	xogre_paine9	] {ai_painforward(3);};
void()	xogre_paine9	=[	$paine9, 	xogre_paine10	] {ai_painforward(4);};
void()	xogre_paine10	=[	$paine10, 	xogre_paine11	] {ai_painforward(3);};
void()	xogre_paine11	=[	$paine11, 	xogre_paine12	] {ai_painforward(2);};
void()	xogre_paine12	=[	$paine12, 	xogre_paine13	] {};
void()	xogre_paine13	=[	$paine13, 	xogre_paine14	] { ai_painforward(0);};
void()	xogre_paine14	=[	$paine14, 	xogre_paine15	] {ai_painforward(3);};
void()	xogre_paine15	=[	$paine15, 	xogre_paine16	] {};
void()	xogre_paine16	=[	$paine16, 	xogre_paine17	] { ai_painforward(0);};
void()	xogre_paine17	=[	$paine17, 	xogre_run1	] {};

void(entity attacker, float damage)	xogre_pain =
{
	local float r;
    self.lefty = 0; // moved up so that it forces end of laugh
	if (self.pain_finished > time)
		return;
	sound (self, CHAN_VOICE, "ogre/ogpain1.wav", 1, ATTN_NORM);

	r = random();
	
	if (r < 0.25)
	{
		xogre_pain1 ();
		self.pain_finished = time + 1;
	}
	else if (r <0.5) 
	{
		xogre_painb1 ();
		self.pain_finished = time + 1;
	}
	else if (r <0.75) 
	{
		xogre_painc1 ();
		self.pain_finished = time + 1;
	}
	else if (r <0.88) 
	{
		xogre_paind1 ();
		self.pain_finished = time + 1;
	}
	else  
	{
		xogre_paine1 ();
		self.pain_finished = time + 2;
	}
};

void()	xogre_die1	=[	$death1,  	xogre_die2	] {};
void()	xogre_die2	=[	$death2,  	xogre_die3	] {};
void()	xogre_die3	=[	$death3,  	xogre_die4	] {self.solid = SOLID_NOT;};
void()	xogre_die4	=[	$death4,  	xogre_die5	] {};
void()	xogre_die5	=[	$death5,  	xogre_die6	] {};
void()	xogre_die6	=[	$death6,  	xogre_die7	] {};
void()	xogre_die7	=[	$death7,  	xogre_die8	] {};
void()	xogre_die8	=[	$death8,  	xogre_die9	] {};
void()	xogre_die9	=[	$death9,  	xogre_die10      ] {};
void()	xogre_die10     =[	$death10, 	xogre_die11      ] {};
void()	xogre_die11	=[	$death11,  	xogre_die12	] {};
void()	xogre_die12	=[	$death12,  	xogre_die13	] {};
void()	xogre_die13	=[	$death13,  	xogre_die14	] {};
void()	xogre_die14	=[	$death14,  	xogre_die15	] {};
void()	xogre_die15	=[	$death15,  	xogre_die15	] {self.skin = 2;};

void()	xogre_dieb1	=[	$bdeath1,  	xogre_dieb2	] {};
void()	xogre_dieb2	=[	$bdeath2,  	xogre_dieb3	] {};
void()	xogre_dieb3	=[	$bdeath3,  	xogre_dieb4	] {self.solid = SOLID_NOT;};
void()	xogre_dieb4	=[	$bdeath4,  	xogre_dieb5	] {};
void()	xogre_dieb5	=[	$bdeath5,  	xogre_dieb6	] {};
void()	xogre_dieb6	=[	$bdeath6,  	xogre_dieb7	] {};
void()	xogre_dieb7	=[	$bdeath7,  	xogre_dieb8	] {};
void()	xogre_dieb8	=[	$bdeath8,  	xogre_dieb9	] {};
void()	xogre_dieb9	=[	$bdeath9,  	xogre_dieb10     ] {};
void()	xogre_dieb10     =[	$bdeath10, 	xogre_dieb10     ] {self.skin = 2;};

void() xogre_die =
{
// check for gib
	if (self.health < -40)
	{
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		ThrowHead ("progs/h_xogre.mdl", self.health);
		ThrowGib ("progs/gib1.mdl", self.health);
		ThrowGib ("progs/gib2.mdl", self.health);
		ThrowGib ("progs/gib3.mdl", self.health);
		return;
	}

// regular death
	sound (self, CHAN_VOICE, "ogre/ogdth.wav", 1, ATTN_NORM);
	if (random() < 0.5)
		xogre_die1 ();
	else
		xogre_dieb1 ();
};

void() xogre_melee =
{
	if (random() > 0.3)
		xogre_atk1 ();
	else if (random() > 0.5)
		xogre_swing1 ();
        else
                xogre_throw1 ();
};

/*QUAKED monster_xogre (1 0 0) (-16 -16 -24) (16 16 40) Ambush
*/
void() monster_xogre = {
	// Check for any random monster setups
	if (monster_checkrandomizer() == TRUE) return;
	// Check all spawn exceptions (monsters.qc)
	if (monster_checkspawn() == TRUE) return;

	precache_model ("progs/xogre.mdl");
	precache_model ("progs/h_xogre.mdl");
	precache_model ("progs/taxe.mdl");

	precache_sound ("player/axhit2.wav");
	precache_sound ("player/axhit1.wav");
	precache_sound ("knight/sword2.wav");
	precache_sound ("ogre/ogidle.wav");
	precache_sound ("ogre/ogidle2.wav");
	precache_sound ("ogre/ogwake.wav");
	precache_sound ("ogre/ogpain1.wav");
	precache_sound ("ogre/ogdth.wav");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/xogre.mdl");

	if (self.deathstring == "") self.deathstring = " was smacked down by an Elden Ogre\n";

	setsize (self, '-16 -16 -24', '16 16 40');
	self.health = 180;

	self.th_stand = xogre_stand1;
	self.th_walk = xogre_walk1;
	self.th_run = xogre_run1;
	self.th_melee = xogre_melee;
	self.th_missile = xogre_throw1;
	self.th_pain = xogre_pain;
	self.th_die = xogre_die;

	// Check for random rotation setup and angle limits
	if (self.angles_y < 0) self.angles_y = rint(random()*359);
	if (self.angles_y > 360) self.angles_y = 360;
	
	monster_start ();
};

