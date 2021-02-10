/*
==============================================================================

SAMURI

==============================================================================

New Quake1 monster, made by Madfox. Started on 30 aug 2007. 
Purpose : make more Quake1 monsters with specific, new attitudes.
Model.mdl composed on the swordsman, altered in the AM2000 Studio.

==============================================================================
*/

$cd /raid/quake/id1/models/samuri
$scale 1
$origin 0 0 12
$base base
$skin base

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10
$frame walk11 walk12 walk13 walk14 walk15 walk16 walk17 walk18 walk19

$frame cheat1 cheat2 cheat3 cheat4 cheat5 cheat6 cheat7 cheat8 cheat9
$frame cheat10 cheat11 cheat12 cheat13 cheat14 cheat15

//===========================================================================

void()	samuri_stand1   =[   $stand1,	 samuri_stand2	 ] {ai_stand();};
void()	samuri_stand2   =[   $stand2,	 samuri_stand3	 ] {ai_stand();};
void()	samuri_stand3   =[   $stand3,	 samuri_stand4	 ] {ai_stand();};
void()	samuri_stand4   =[   $stand4,	 samuri_stand5	 ] {ai_stand();};
void()	samuri_stand5   =[   $stand5,	 samuri_stand6	 ] {ai_stand();};
void()	samuri_stand6   =[   $stand6,	 samuri_stand7	 ] {ai_stand();};
void()	samuri_stand7   =[   $stand7,	 samuri_stand8	 ] {ai_stand();};
void()	samuri_stand8   =[   $stand8,	 samuri_stand9	 ] {ai_stand();};
void()	samuri_stand9   =[   $stand9,	 samuri_stand1	 ] {ai_stand();};

void()  samuri_walk1    =[   $walk1,     samuri_walk2    ] {ai_walk(6);};
void()  samuri_walk2    =[   $walk2,     samuri_walk3    ] {ai_walk(6);};
void()  samuri_walk3    =[   $walk3,     samuri_walk4    ] {ai_walk(6);};
void()  samuri_walk4    =[   $walk4,     samuri_walk5    ] {ai_walk(6);};
void()  samuri_walk5    =[   $walk5,     samuri_walk6    ] {ai_walk(6);};
void()  samuri_walk6    =[   $walk6,     samuri_walk7    ] {ai_walk(6);};
void()  samuri_walk7    =[   $walk7,     samuri_walk8    ] {ai_walk(6);};
void()  samuri_walk8    =[   $walk8,     samuri_walk9    ] {ai_walk(6);};
void()  samuri_walk9    =[   $walk9,     samuri_walk10   ] {ai_walk(6);};
void()  samuri_walk10   =[   $walk10,    samuri_walk11   ] {ai_walk(6);};
void()  samuri_walk11   =[   $walk11,    samuri_walk12   ] {ai_walk(6);};
void()  samuri_walk12   =[   $walk12,    samuri_walk13   ] {ai_walk(6);};
void()  samuri_walk13   =[   $walk13,    samuri_walk14   ] {ai_walk(6);};
void()  samuri_walk14   =[   $walk14,    samuri_walk15   ] {ai_walk(6);};
void()  samuri_walk15   =[   $walk15,    samuri_walk16   ] {ai_walk(6);};
void()  samuri_walk16   =[   $walk16,    samuri_walk17   ] {ai_walk(6);};
void()  samuri_walk17   =[   $walk17,    samuri_walk18   ] {ai_walk(6);};
void()  samuri_walk18   =[   $walk18,    samuri_walk19   ] {ai_walk(6);};
void()  samuri_walk19   =[   $walk19,    samuri_walk1    ] {ai_walk(6);};

void()  samuri_cheat1   =[   $cheat1,    samuri_cheat2   ] {};
void()  samuri_cheat2   =[   $cheat2,    samuri_cheat3   ] {};
void()  samuri_cheat3   =[   $cheat3,    samuri_cheat4   ] {};
void()  samuri_cheat4   =[   $cheat4,    samuri_cheat5   ] {};
void()  samuri_cheat5   =[   $cheat5,    samuri_cheat6   ] {};
void()  samuri_cheat6   =[   $cheat6,    samuri_cheat7   ] {};
void()  samuri_cheat7   =[   $cheat7,    samuri_cheat8   ] {};
void()  samuri_cheat8   =[   $cheat8,    samuri_cheat9   ] {};
void()  samuri_cheat9   =[   $cheat9,    samuri_cheat10  ] {};
void()  samuri_cheat10  =[   $cheat10,   samuri_cheat11  ] {};
void()  samuri_cheat11  =[   $cheat11,   samuri_cheat12  ] {};
void()  samuri_cheat12  =[   $cheat12,   samuri_cheat13  ] {};
void()  samuri_cheat13  =[   $cheat13,   samuri_cheat14  ] {};
void()  samuri_cheat14  =[   $cheat14,   samuri_cheat15  ] {};
void()  samuri_cheat15  =[   $cheat15,   samuri_cheat1   ] {};

//============================================================================

/*QUAKED monster_samuri (1 0 0) (-32 -32 -64) (32 32 64) Ambush

*/
void() monster_samuri =  {
	// Check for any random monster setups
	if (monster_checkrandomizer() == TRUE) return;
	// Check all spawn exceptions (monsters.qc)
	if (monster_checkspawn() == TRUE) return;

    precache_model ("progs/samuri.mdl");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/samuri.mdl");

	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	self.health = 100;

	self.th_stand   = samuri_stand1;
	self.th_walk    = samuri_walk1;
	self.th_run     = SUB_NULL;
	self.th_die     = SUB_NULL;
	self.th_melee   = SUB_NULL;
	self.th_missile = SUB_NULL;
	self.th_pain    = SUB_NULL;

	// Check for random rotation setup and angle limits
	if (self.angles_y < 0) self.angles_y = rint(random()*359);
	if (self.angles_y > 360) self.angles_y = 360;
		
	monster_start();
};


/*
==============================================================================
















