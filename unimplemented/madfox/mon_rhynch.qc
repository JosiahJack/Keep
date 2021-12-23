/*==============================================================================

rhynch

A foul creature that drains its victims blood, through their face, in order to
sustain itself.

==============================================================================*/

$origin 0 0 24
$base base
$skin skin

$frame slide1 slide2 slide3 slide4 slide5 slide6 slide7 slide8 slide9 slide10 slide11 
$frame slide12

$frame colid1 colid2 colid3 colid4 colid5 colid6 colid7 colid8 colid9 colid10 colid11
$frame colid12 colid13 colid14 colid15 colid16 colid17 colid18 

$frame turn1 turn2 turn3 turn4 turn5 turn6 turn7 turn8 turn9 turn10 turn11
$frame turn12 turn13 turn14 turn15 turn16 turn17 turn18

$frame launch1 launch2 launch3 launch4 launch5

$frame airborne1 airborne2

$frame attach1 attach2 attach3

$frame feed1 feed2 feed3

$frame release1 release2 release3 release4 release5

$frame pain1 pain2 pain3 pain4 pain5 pain6 pain7

$frame paina1 paina2 paina3 paina4 paina5 paina6 paina7 paina8 paina9 paina10 paina11
$frame paina12 paina13 paina14 paina15  

$frame die1 die2 die3 die4 die5 die6 die7 die8 die9 die10 die11 die12 die13 die14
$frame die15 die16 die17 

$frame dieb1 dieb2 dieb3 dieb4 dieb5 dieb6 dieb7 dieb8 dieb9 dieb10 dieb11 dieb12 dieb13 dieb14
$frame dieb15 dieb16 dieb17 dieb18 dieb19 dieb20 dieb21 dieb22 dieb23 

//==============================================================================
//prototypes
void() rhynch_fly_hit;
void() rhynch_feed;
void() rhynch_release1;

//==============================================================================

//sounds

void()	rhynch_idle_sound =
{
	if (random() < 0.1)
	{
		if (random() > 0.5)
			sound (self, CHAN_AUTO, "rhynch/idle1.wav", 0.7, ATTN_NORM);
		else
			sound (self, CHAN_AUTO, "rhynch/idle2.wav", 0.7, ATTN_NORM);
	}
};

void()	rhynch_pain_sound =
{
		if (random() > 0.5)
			sound (self, CHAN_AUTO, "rhynch/pain1.wav", 0.7, ATTN_NORM);
		else
			sound (self, CHAN_AUTO, "rhynch/pain2.wav", 0.7, ATTN_NORM);
};

void()	rhynch_death_sound =
{
		if (random() > 0.5)
			sound (self, CHAN_AUTO, "rhynch/death1.wav", 0.7, ATTN_NORM);
		else
			sound (self, CHAN_AUTO, "rhynch/death2.wav", 0.7, ATTN_NORM);
};

void()	rhynch_chew_sound =
{
		local float r;
		r = random();

		if (r < 0.33)
			sound (self, CHAN_AUTO, "rhynch/chew1.wav", 0.7, ATTN_NORM);
		else if (r < 0.66)
			sound (self, CHAN_AUTO, "rhynch/chew2.wav", 0.7, ATTN_NORM);
		else
			sound (self, CHAN_AUTO, "rhynch/chew3.wav", 0.7, ATTN_NORM);
};

//==============================================================================



//idle
void() rhynch_stand1    =[   $slide1,     rhynch_stand2   ]  {rhynch_idle_sound(); ai_stand();};
void() rhynch_stand2    =[   $slide2,     rhynch_stand3   ]  {ai_stand();};
void() rhynch_stand3    =[   $slide3,     rhynch_stand4   ]  {ai_stand();};
void() rhynch_stand4    =[   $slide4,     rhynch_stand5   ]  {ai_stand();};
void() rhynch_stand5    =[   $slide5,     rhynch_stand6   ]  {ai_stand();};
void() rhynch_stand6    =[   $slide6,     rhynch_stand7   ]  {ai_stand();};
void() rhynch_stand7    =[   $slide7,     rhynch_stand8   ]  {ai_stand();};
void() rhynch_stand8    =[   $slide8,     rhynch_stand9   ]  {ai_stand();};
void() rhynch_stand9    =[   $slide9,     rhynch_stand10  ]  {ai_stand();};
void() rhynch_stand10   =[   $slide10,    rhynch_stand11  ]  {ai_stand();};
void() rhynch_stand11   =[   $slide11,    rhynch_stand12  ]  {ai_stand();};
void() rhynch_stand12   =[   $slide12,    rhynch_stand1   ]  {ai_stand();};

//patrolling
void() rhynch_walk1     =[   $colid1,      rhynch_walk2    ]  {rhynch_idle_sound(); ai_walk(3);};
void() rhynch_walk2     =[   $colid2,      rhynch_walk3    ]  {ai_walk(5);};
void() rhynch_walk3     =[   $colid3,      rhynch_walk4    ]  {ai_walk(6);};
void() rhynch_walk4     =[   $colid4,      rhynch_walk5    ]  {ai_walk(7);};
void() rhynch_walk5     =[   $colid5,      rhynch_walk6    ]  {ai_walk(6);};
void() rhynch_walk6     =[   $colid6,      rhynch_walk7    ]  {ai_walk(5);};
void() rhynch_walk7     =[   $colid7,      rhynch_walk8    ]  {ai_walk(4);};
void() rhynch_walk8     =[   $colid8,      rhynch_walk9    ]  {ai_walk(3);};
void() rhynch_walk9     =[   $colid9,      rhynch_walk10   ]  {ai_walk(3);};
void() rhynch_walk10    =[   $colid10,     rhynch_walk11   ]  {ai_walk(4);};
void() rhynch_walk11    =[   $colid11,     rhynch_walk12   ]  {ai_walk(5);};
void() rhynch_walk12    =[   $colid12,     rhynch_walk13   ]  {ai_walk(6);};
void() rhynch_walk13    =[   $colid13,     rhynch_walk14   ]  {ai_walk(7);};
void() rhynch_walk14    =[   $colid14,     rhynch_walk15   ]  {ai_walk(6);};
void() rhynch_walk15    =[   $colid15,     rhynch_walk16   ]  {ai_walk(5);};
void() rhynch_walk16    =[   $colid16,     rhynch_walk17   ]  {ai_walk(4);};
void() rhynch_walk17    =[   $colid17,     rhynch_walk18   ]  {ai_walk(3);};
void() rhynch_walk18    =[   $colid18,     rhynch_walk1    ]  {ai_walk(4);};

//chasing
void() rhynch_run1      =[   $turn1,	rhynch_run2		]  {rhynch_idle_sound(); ai_run(16);};
void() rhynch_run2      =[   $turn2,	rhynch_run3		]  {ai_run(10);};
void() rhynch_run3      =[   $turn3,	rhynch_run4		]  {ai_run(13);};
void() rhynch_run4      =[   $turn4,	rhynch_run5		]  {ai_run(7);};
void() rhynch_run5      =[   $turn5,	rhynch_run6		]  {ai_run(11);};
void() rhynch_run6      =[   $turn6,	rhynch_run7		]  {ai_run(10);};
void() rhynch_run7      =[   $turn7,	rhynch_run8		]  {ai_run(7);};
void() rhynch_run8      =[   $turn8,	rhynch_run9		]  {ai_run(9);};
void() rhynch_run9      =[   $turn9,	rhynch_run10	]  {ai_run(10);};
void() rhynch_run10     =[   $turn10,	rhynch_run11	]  {ai_run(11);};
void() rhynch_run11     =[   $turn11,	rhynch_run12	]  {ai_run(13);};
void() rhynch_run12     =[   $turn12,	rhynch_run13	]  {ai_run(7);};
void() rhynch_run13     =[   $turn13,	rhynch_run14	]  {ai_run(11);};
void() rhynch_run14     =[   $turn14,	rhynch_run15	]  {ai_run(10);};
void() rhynch_run15     =[   $turn15,	rhynch_run16	]  {ai_run(7);};
void() rhynch_run16     =[   $turn16,	rhynch_run17	]  {ai_run(9);};
void() rhynch_run17     =[   $turn17,	rhynch_run18	]  {ai_run(10);};
void() rhynch_run18     =[   $turn18,	rhynch_run1		]  {ai_run(9);};

//launch
void() rhynch_launch1      =[   $launch1,	rhynch_launch2		]  {ai_charge(0); sound (self, CHAN_AUTO, "rhynch/launch1.wav", 0.7, ATTN_NORM);};
void() rhynch_launch2      =[   $launch2,	rhynch_launch3		]  {ai_charge(1);};
void() rhynch_launch3      =[   $launch3,	rhynch_launch4		]  {ai_charge(2);};
void() rhynch_launch4      =[   $launch4,	rhynch_launch5		]  {ai_charge(3);};
void() rhynch_launch5      =[   $launch5,	rhynch_fly1			]  {ai_charge(4);};

//Moving towards victim, it's touch causes it to attach if it hits during this sequence
void() rhynch_fly1	=[	$airborne1,	rhynch_fly2		]	{ai_charge(20); self.touch = rhynch_fly_hit; };
void() rhynch_fly2	=[	$airborne2,	rhynch_fly3		]	{ai_charge(35); if (vlen(self.enemy.origin - self.origin) <= 96)	{other = self.enemy; rhynch_fly_hit();}	};	// Supa 20120106 quick workaround until I have time to actually fix this
void() rhynch_fly3	=[	$airborne1,	rhynch_fly4		]	{ai_charge(50); if (vlen(self.enemy.origin - self.origin) <= 96)	{other = self.enemy; rhynch_fly_hit();}	};
void() rhynch_fly4	=[	$airborne2,	rhynch_fly5		]	{ai_charge(60); if (vlen(self.enemy.origin - self.origin) <= 96)	{other = self.enemy; rhynch_fly_hit();}	};
void() rhynch_fly5	=[	$airborne1,	rhynch_fly6		]	{ai_charge(55); if (vlen(self.enemy.origin - self.origin) <= 96)	{other = self.enemy; rhynch_fly_hit();}	};
void() rhynch_fly6	=[	$airborne2,	rhynch_fly7		]	{ai_charge(50); if (vlen(self.enemy.origin - self.origin) <= 96)	{other = self.enemy; rhynch_fly_hit();}	};
void() rhynch_fly7	=[	$airborne1,	rhynch_fly8		]	{ai_charge(45); if (vlen(self.enemy.origin - self.origin) <= 96)	{other = self.enemy; rhynch_fly_hit();}	};
void() rhynch_fly8	=[	$airborne2,	rhynch_release1	]	{ai_charge(40); self.touch = SUB_Null;};	// Supa, don't touch outside of attack

//attach, a short sequence of it grappling onto its victim
void() rhynch_attach1      =[   $attach1,	rhynch_attach2		]  {};
void() rhynch_attach2      =[   $attach2,	rhynch_attach3		]  {};
void() rhynch_attach3      =[   $attach3,	rhynch_feed1		]  {rhynch_feed();};

//feed, it's chewing on some unlucky bastard's face
void() rhynch_feed1      =[   $feed1,	rhynch_feed2		]  {rhynch_feed();};
void() rhynch_feed2      =[   $feed2,	rhynch_feed3		]  {rhynch_feed();};
void() rhynch_feed3      =[   $feed3,	rhynch_feed1		]  {rhynch_feed();};

//detach, its either missed, or been forced off its victim, so returns to normal animation
void() rhynch_release1      =[   $release1,	rhynch_release2		]  {ai_pain(0); self.touch = SUB_Null;};
void() rhynch_release2      =[   $release2,	rhynch_release3		]  {ai_pain(1);};
void() rhynch_release3      =[   $release3,	rhynch_release4		]  {ai_pain(2);};
void() rhynch_release4      =[   $release4,	rhynch_release5		]  {ai_pain(3);};
void() rhynch_release5      =[   $release5,	rhynch_run1			]  {ai_pain(4);};

//pain
void() rhynch_pain1    =[   $pain1,     rhynch_pain2   ]  {ai_pain(14); rhynch_pain_sound();};
void() rhynch_pain2    =[   $pain2,     rhynch_pain3   ]  {ai_pain(10);};
void() rhynch_pain3    =[   $pain3,     rhynch_pain4   ]  {ai_pain(7);};
void() rhynch_pain4    =[   $pain4,     rhynch_pain5   ]  {ai_pain(5);};
void() rhynch_pain5    =[   $pain5,     rhynch_pain6   ]  {ai_pain(4);};
void() rhynch_pain6    =[   $pain6,     rhynch_pain7   ]  {ai_pain(2);};
void() rhynch_pain7    =[   $pain7,     rhynch_run1    ]  {ai_pain(1);};

//paina
void() rhynch_paina1    =[   $paina1,     rhynch_paina2   ]  {ai_pain(4); rhynch_pain_sound();};
void() rhynch_paina2    =[   $paina2,     rhynch_paina3   ]  {ai_pain(4);};
void() rhynch_paina3    =[   $paina3,     rhynch_paina4   ]  {ai_pain(5);};
void() rhynch_paina4    =[   $paina4,     rhynch_paina5   ]  {ai_pain(3);};
void() rhynch_paina5    =[   $paina5,     rhynch_paina6   ]  {ai_pain(4);};
void() rhynch_paina6    =[   $paina6,     rhynch_paina7   ]  {ai_pain(5);};
void() rhynch_paina7    =[   $paina7,     rhynch_paina8   ]  {ai_pain(4);};
void() rhynch_paina8    =[   $paina8,     rhynch_paina9   ]  {ai_pain(3);};
void() rhynch_paina9    =[   $paina9,     rhynch_paina10  ]  {ai_pain(8);};
void() rhynch_paina10   =[   $paina10,    rhynch_paina11  ]  {ai_pain(5);};
void() rhynch_paina11   =[   $paina11,    rhynch_paina12  ]  {ai_pain(3);};
void() rhynch_paina12   =[   $paina12,    rhynch_paina13  ]  {ai_pain(4);};
void() rhynch_paina13   =[   $paina13,    rhynch_paina14  ]  {ai_pain(5);};
void() rhynch_paina14   =[   $paina14,    rhynch_paina15  ]  {ai_pain(4);};
void() rhynch_paina15   =[   $paina15,    rhynch_run1     ]  {ai_pain(3);};

//death
void() rhynch_die1    =[   $die1,     rhynch_die2   ]  {rhynch_death_sound();};
void() rhynch_die2    =[   $die2,     rhynch_die3   ]  {};
void() rhynch_die3    =[   $die3,     rhynch_die4   ]  {};
void() rhynch_die4    =[   $die4,     rhynch_die5   ]  {};
void() rhynch_die5    =[   $die5,     rhynch_die6   ]  {};
void() rhynch_die6    =[   $die6,     rhynch_die7   ]  {};
void() rhynch_die7    =[   $die7,     rhynch_die8   ]  {};
void() rhynch_die8    =[   $die8,     rhynch_die9   ]  {};
void() rhynch_die9    =[   $die9,     rhynch_die10  ]  {};
void() rhynch_die10   =[   $die10,    rhynch_die11  ]  {};
void() rhynch_die11   =[   $die11,    rhynch_die12  ]  {};
void() rhynch_die12   =[   $die12,    rhynch_die13  ]  {};
void() rhynch_die13   =[   $die13,    rhynch_die14  ]  {};
void() rhynch_die14   =[   $die14,    rhynch_die15  ]  {};
void() rhynch_die15   =[   $die15,    rhynch_die16  ]  {};
void() rhynch_die16   =[   $die16,    rhynch_die17  ]  {};
void() rhynch_die17   =[   $die17,    rhynch_die17  ]  {CorpseThink();};

//death2
void() rhynch_dieb1    =[   $dieb1,     rhynch_dieb2   ]  {rhynch_death_sound();};
void() rhynch_dieb2    =[   $dieb2,     rhynch_dieb3   ]  {};
void() rhynch_dieb3    =[   $dieb3,     rhynch_dieb4   ]  {};
void() rhynch_dieb4    =[   $dieb4,     rhynch_dieb5   ]  {};
void() rhynch_dieb5    =[   $dieb5,     rhynch_dieb6   ]  {};
void() rhynch_dieb6    =[   $dieb6,     rhynch_dieb7   ]  {};
void() rhynch_dieb7    =[   $dieb7,     rhynch_dieb8   ]  {};
void() rhynch_dieb8    =[   $dieb8,     rhynch_dieb9   ]  {};
void() rhynch_dieb9    =[   $dieb9,     rhynch_dieb10  ]  {};
void() rhynch_dieb10   =[   $dieb10,    rhynch_dieb11  ]  {};
void() rhynch_dieb11   =[   $dieb11,    rhynch_dieb12  ]  {};
void() rhynch_dieb12   =[   $dieb12,    rhynch_dieb13  ]  {};
void() rhynch_dieb13   =[   $dieb13,    rhynch_dieb14  ]  {};
void() rhynch_dieb14   =[   $dieb14,    rhynch_dieb15  ]  {};
void() rhynch_dieb15   =[   $dieb15,    rhynch_dieb16  ]  {};
void() rhynch_dieb16   =[   $dieb16,    rhynch_dieb17  ]  {};
void() rhynch_dieb17   =[   $dieb17,    rhynch_dieb18  ]  {};
void() rhynch_dieb18   =[   $dieb18,    rhynch_dieb19  ]  {};
void() rhynch_dieb19   =[   $dieb19,    rhynch_dieb20  ]  {};
void() rhynch_dieb20   =[   $dieb20,    rhynch_dieb21  ]  {};
void() rhynch_dieb21   =[   $dieb21,    rhynch_dieb22  ]  {};
void() rhynch_dieb22   =[   $dieb22,    rhynch_dieb23  ]  {};
void() rhynch_dieb23   =[   $dieb23,    rhynch_dieb23  ]  {CorpseThink();};

//==============================================================================
//	Thinking 
//==============================================================================

//pain
void(entity attacker, float damage) rhynch_pain = 
{
	local float r;
	r = random();
	
	if (self.pain_finished > time)
		return;
		
	// drowning?
	if (self.h2olevel >= 3)
		return;
	
	if (r < 0.85)
		rhynch_pain1 ();		//flinches
	else 
		rhynch_paina1 ();		//goes reeling
	
	self.pain_finished = time + 1;
};

//death
void() rhynch_die =  
{
	// check for gib
	if ((self.health < -25) || (self.h2olevel >= 3))
	{
		//sound (self, CHAN_VOICE, "crab/die.wav", 1, ATTN_NORM);	FIXME gib sound
		ThrowHead ("progs/gib_rhynch1.mdl", self.health, 1);
		ThrowGib ("progs/gib_rhynch2.mdl", self.health);
		ThrowGib ("progs/gib_rhynch3.mdl", self.health);
		ThrowGib ("progs/gib_rhynch4.mdl", self.health);
		return;
	}

	// regular death
	//sound (self, CHAN_VOICE, "rhynch/die.wav", 1,  ATTN_IDLE);
	self.solid = SOLID_NOT;
	
	if (random() > 0.5)
		rhynch_die1 ();
	else
		rhynch_dieb1 ();
};

//attacking
void() rhynch_fly_hit =
{	
	//it's dead in flight, end this process
	if (self.health <= 0)
	{
		self.touch = SUB_Null;	//make sure it doesn't try to attach
		return;					
	}
	
	//it's hit something living
	if (other.takedamage	)
	if (other == self.enemy	)	// Supa, fix a potentially nasty booboo
	{
		//bprint("rhynch hit target");
		rhynch_attach1 ();	//grab em!
		self.touch = SUB_Null;
		return;
	}
	/*else	//its hit a wall or something it can't chew on
	{
		rhynch_release1 ();
		self.touch = SUB_Null;
		return;
	}*/
};

void() rhynch_feed =
{

	//bprint("rhynch is feeding");
	
	local	float	ldmg;
	
	//it's dead
	if (self.health < 0)
		return;
	
	//victim is dead, lose interest in cold blood
	if (self.enemy.health < 0)
	{
		rhynch_release1 ();
		return;
	}
	
	//play the chewing sounds
	rhynch_chew_sound();
	
	/*
	//uh, it just fell off the back of a lorry, guv, one marked ctf.qc (thanks Supa)
	setorigin (self, self.enemy.origin + '0 24 32');
	self.angles = self.enemy.angles + '0 180 0';
	self.angles_x = 0;
	*/
	
	// 20110901 Supa Rhynch attach-to-player
	
	makevectors (self.enemy.v_angle);									// get view angle for an offset
	
	setorigin (self, self.enemy.origin + v_forward * 32 + '0 0 16');	// offset from the player so we'll be roughly in the middle of their view
	
	// now flip player's angle to get our angles
	self.angles_x = self.enemy.v_angle_x;
	self.angles_y = self.enemy.angles_y - 180;
	self.angles_z = 0;
		
	spawn_touchblood (5, other.nobleed);
	ldmg = 1;
	T_Damage (self.enemy, self, self, ldmg, DTH_RHYNCH_FEEDING, FALSE, 3);
};


//==============================================================================

void() monster_rhynch_go =
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/rhynch.mdl");

	setsize (self, '-16 -16 -24', '16 16 40');
	self.health = MonsterHealth(200);

	self.th_stand = rhynch_stand1;
	self.th_walk = rhynch_walk1;
	self.th_run = rhynch_run1;
	self.th_missile = rhynch_launch1;
	self.th_pain = rhynch_pain;
	self.th_die = rhynch_die;
	self.th_submerged = SUB_Null;
	
	Gyro_Object_Activate (self, 25000);

	flymonster_start ();
};

//QUAKED monster_rhynch (1 0 0) (-16 -16 -24) (16 16 40) Ambush

void() monster_rhynch =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model ("progs/rhynch.mdl");
	
	precache_model ("progs/gib_rhynch1.mdl");
	precache_model ("progs/gib_rhynch2.mdl");
	precache_model ("progs/gib_rhynch3.mdl");
	precache_model ("progs/gib_rhynch4.mdl");
	
	precache_sound ("rhynch/chew1.wav");
	precache_sound ("rhynch/chew2.wav");
	precache_sound ("rhynch/chew3.wav");
	precache_sound ("rhynch/death1.wav");
	precache_sound ("rhynch/death2.wav");
	precache_sound ("rhynch/idle1.wav");
	precache_sound ("rhynch/idle2.wav");
	precache_sound ("rhynch/launch1.wav");
	precache_sound ("rhynch/pain1.wav");
	precache_sound ("rhynch/pain2.wav");
	precache_sound ("rhynch/sight1.wav");  
	
	//FIXME
	//precache_model ("progs/gib1.mdl");
	//precache_model ("progs/gib_rhynch1.mdl");
	//precache_model ("progs/gib_rhynch2.mdl");
	//precache_model ("progs/gib_rhynch3.mdl");

	self.go = monster_rhynch_go;
	if(!CheckGroup()) self.go();
};
