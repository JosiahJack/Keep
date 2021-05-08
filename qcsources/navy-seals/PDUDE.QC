/*
==============================================================================

PRISON GUARD

==============================================================================
*/

$cd id1/models/pdude
$origin 0 -6 -24
$base base		
$skin skin

$frame reload1 reload2 reload3 reload4 reload5 reload6 reload7 reload8 reload9 reload10
$frame reload11 reload12 reload13 reload14 reload15 reload16 reload17 reload18 reload19
$frame reload20 reload21

$frame drawa1 drawa2 drawa3 drawa4 drawa5 drawa6 drawa7

$frame drawb1 drawb2 drawb3 drawb4 drawb5 drawb6 

$frame roll1 roll2 roll3 roll4 roll5 roll6 roll7 roll8 roll9 roll10 roll11 roll12 roll13
$frame roll14 roll15 roll16 roll17 roll18 roll19 roll20 roll21 roll22 roll23 roll24
$frame roll25 roll26 roll27

$frame leap1 leap2 leap3 leap4 leap5 leap6 leap7 leap8 leap9 leap10 leap11 leap12
$frame leap13 leap14

$frame firea1 firea2 firea3

$frame fireb1 fireb2 fireb3

$frame firec1 firec2 firec3 firec4 firec5 firec6 firec7 firec8 firec9 firec10
$frame firec11 firec12 firec13 firec14 firec15 firec16 firec17

$frame fired1 fired2 fired3

$frame paina1 paina2 paina3 paina4 paina5 paina6

$frame painb1 painb2 painb3 painb4 painb5 painb6 painb7 painb8

$frame painc1 painc2 painc3 painc4 painc5 painc6

$frame paind1 paind2 paind3 paind4 paind5 paind6

$frame paine1 paine2 paine3 paine4 paine5 paine6

$frame deatha1 deatha2 deatha3 deatha4 deatha5 deatha6 deatha7 deatha8 deatha9
$frame deatha10 deatha11 deatha12 deatha13 deatha14

$frame deathc1 deathc2 deathc3 deathc4 deathc5 deathc6 deathc7 deathc8 deathc9 
$frame deathc10 deathc11 deathc12

$frame deathd1 deathd2 deathd3 deathd4 deathd5 deathd6 deathd7 deathd8 deathd9

$frame deathe1 deathe2 deathe3 deathe4 deathe5 deathe6 deathe7 deathe8 deathe9 
$frame deathe10 deathe11 deathe12

$frame deathf1 deathf2 deathf3 deathf4 deathf5 deathf6 deathf7 deathf8 deathf9 

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8

$frame grenade1 grenade2 grenade3 grenade4 grenade5 grenade6 grenade7 grenade8 
$frame grenade9 grenade10 grenade11 grenade12 grenade13 grenade14 grenade15
$frame grenade16

$frame run1 run2 run3 run4 run5 run6 run7 run8 run9

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10 walk11 walk12
$frame walk13 walk14 walk15 walk16

$frame melee1 melee2 melee3 melee4 melee5 melee6 melee7 melee8 melee9 melee10
$frame melee11 melee12 melee13 melee14 melee15 melee16 melee17 melee18

/*
==============================================================================
SOLDIER CODE
==============================================================================
*/

void() Laser_Touch =
{
	local vector org;
	
	if (other == self.owner)
		return;		// don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	
	sound (self, CHAN_WEAPON, "enforcer/enfstop.wav", 1, ATTN_STATIC);
	org = self.origin - 8*normalize(self.velocity);

	if (other.health)
	{
		SpawnBlood (org, self.velocity*0.2, 15);
		T_Damage (other, self, self.owner, 20);
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

void(vector org, vector vec) LaunchLaser =
{
	local	vector	vec;
		
	if (self.classname == "monster_enforcer")
		sound (self, CHAN_WEAPON, "enforcer/enfire.wav", 1, ATTN_NORM);

	vec = normalize(vec);
	
	newmis = spawn();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLY;
	newmis.solid = SOLID_BBOX;
	newmis.effects = EF_DIMLIGHT;

	setmodel (newmis, "progs/laser.mdl");
	setsize (newmis, '0 0 0', '0 0 0');		

	setorigin (newmis, org);

	newmis.velocity = vec * 600;
	newmis.angles = vectoangles(newmis.velocity);

	newmis.nextthink = time + 5;
	newmis.think = SUB_Remove;
	newmis.touch = Laser_Touch;
};



void() pdude_fire;
void() pdudeFireGrenade;

void (float dist) ai_moveforeward =
{
	walkmove (self.angles_y, dist);
};

void()      pdude_grenade1 = [ $grenade1, pdude_grenade2] {ai_face();};
void()      pdude_grenade2 = [ $grenade2, pdude_grenade3] {ai_face();};
void()      pdude_grenade3 = [ $grenade3, pdude_grenade4] {ai_face();};
void()      pdude_grenade4 = [ $grenade4, pdude_grenade5] {ai_face();};
void()      pdude_grenade5 = [ $grenade5, pdude_grenade6] {ai_face();};
void()      pdude_grenade6 = [ $grenade6, pdude_grenade7] {ai_face();};
void()      pdude_grenade7 = [ $grenade7, pdude_grenade8] {ai_face();};
void()      pdude_grenade8 = [ $grenade8, pdude_grenade9] {ai_face();};
void()      pdude_grenade9 = [ $grenade9, pdude_grenade10] {ai_face();};
void()      pdude_grenade10 = [ $grenade10, pdude_grenade11] {ai_face();};
void()      pdude_grenade11 = [ $grenade11, pdude_grenade12] {ai_face();};
void()      pdude_grenade12 = [ $grenade12, pdude_grenade13] {ai_face();pdudeFireGrenade();};
void()      pdude_grenade13 = [ $grenade13, pdude_grenade14] {ai_face();};
void()      pdude_grenade14 = [ $grenade14, pdude_grenade15] {ai_face();};
void()      pdude_grenade15 = [ $grenade15, pdude_grenade16] {ai_face();};
void()      pdude_grenade16 = [ $grenade16, pdude_run1] {ai_face();};

void()      pdude_straferight1 = [ $firec1,     pdude_straferight2] {ai_face();};
void()      pdude_straferight2 = [ $firec2,   pdude_straferight3] {ai_face();};
void()      pdude_straferight3 = [ $firec3,   pdude_straferight4] {ai_face();};
void()      pdude_straferight4 = [ $firec4,   pdude_straferight5] {ai_face();};
void()      pdude_straferight5 = [ $firec5,   pdude_straferight6] {ai_face();};
void()      pdude_straferight6 = [ $firec6,   pdude_straferight7] {ai_face();ai_strafeleft(12.5);pdude_fire();};
void()      pdude_straferight7 = [ $firec7,   pdude_straferight8] {ai_face();ai_strafeleft(4);};
void()      pdude_straferight8 = [ $firec8,   pdude_straferight9] {ai_face();ai_strafeleft(5);pdude_fire();};
void()      pdude_straferight9 = [ $firec9,   pdude_straferight10] {ai_face();ai_strafeleft(3);};
void()      pdude_straferight10 = [ $firec10,   pdude_straferight11] {ai_face();ai_strafeleft(3);pdude_fire();};
void()      pdude_straferight11 = [ $firec11,   pdude_straferight12] {ai_face();ai_strafeleft(5);};
void()      pdude_straferight12 = [ $firec12,   pdude_straferight13] {ai_face();ai_strafeleft(3);pdude_fire();};
void()      pdude_straferight13 = [ $firec13,   pdude_straferight14] {ai_face();ai_strafeleft(4);};
void()      pdude_straferight14 = [ $firec14,   pdude_straferight15] {ai_face();ai_strafeleft(4);pdude_fire();};
void()      pdude_straferight15 = [ $firec15,   pdude_straferight16] {ai_face();ai_strafeleft(4);};
void()      pdude_straferight16 = [ $firec16,   pdude_straferight17] {ai_face();ai_strafeleft(4);pdude_fire();};
void()      pdude_straferight17 = [ $firec17,   pdude_straferight18] {ai_face();ai_strafeleft(3);};
void()      pdude_straferight18 = [ $firec4,   pdude_straferight19] {ai_face();ai_straferight(6);};
void()      pdude_straferight19 = [ $firec3,   pdude_straferight20] {ai_face();};
void()      pdude_straferight20 = [ $firec2,   pdude_run1] {ai_face();};

void()	pdude_stand1	=[	$stand1,	pdude_stand2	] {ai_stand();};
void()	pdude_stand2	=[	$stand2,	pdude_stand3	] {ai_stand();};
void()	pdude_stand3	=[	$stand3,	pdude_stand4	] {ai_stand();};
void()	pdude_stand4	=[	$stand4,	pdude_stand5	] {ai_stand();};
void()	pdude_stand5	=[	$stand5,	pdude_stand6	] {ai_stand();};
void()	pdude_stand6	=[	$stand6,	pdude_stand7	] {ai_stand();};
void()	pdude_stand7	=[	$stand7,	pdude_stand8	] {ai_stand();};
void()	pdude_stand8	=[	$stand8,	pdude_stand1	] {ai_stand();};

void()	pdude_walk1	=[	$walk1,	pdude_walk2	] {};
void()	pdude_walk2	=[	$walk2,	pdude_walk3	] {ai_walk(1);};
void()	pdude_walk3	=[	$walk3,	pdude_walk4	] {ai_walk(1);};
void()	pdude_walk4	=[	$walk4,	pdude_walk5	] {ai_walk(1);};
void()	pdude_walk5	=[	$walk5,	pdude_walk6	] {ai_walk(2);};
void()	pdude_walk6	=[	$walk6,	pdude_walk7	] {ai_walk(5);};
void()	pdude_walk7	=[	$walk7,	pdude_walk8	] {ai_walk(5);};
void()	pdude_walk8	=[	$walk8,	pdude_walk9	] {ai_walk(4);};
void()	pdude_walk9	=[	$walk9,	pdude_walk10	] {ai_walk(-1);};
void()	pdude_walk10	=[	$walk10,	pdude_walk11	] {ai_walk(0);};
void()	pdude_walk11	=[	$walk11,	pdude_walk12	] {ai_walk(0);};
void()	pdude_walk12	=[	$walk12,	pdude_walk13	] {ai_walk(0);};
void()	pdude_walk13	=[	$walk13,	pdude_walk14	] {ai_walk(1);};
void()	pdude_walk14	=[	$walk14,	pdude_walk15	] {ai_walk(8);};
void()	pdude_walk15	=[	$walk15,	pdude_walk16	] {ai_walk(7);};
void()	pdude_walk16	=[	$walk16,	pdude_walk1	] {ai_walk(6);};

void()	pdude_run1	=[	$run1,		pdude_run2	] 
{
  self.duck = 0;
  setsize (self, '-16 -16 -24', '16 16 35');
  self.mk23clip = 13;
};
void()	pdude_run2	=[	$run2,		pdude_run3	] {ai_run(5);};
void()	pdude_run3	=[	$run3,		pdude_run4	] {ai_run(3);};
void()	pdude_run4	=[	$run4,		pdude_run5	] {ai_run(13);};
void()	pdude_run5	=[	$run5,		pdude_run6	] {ai_run(7);};
void()	pdude_run6	=[	$run6,		pdude_run7	] {ai_run(8);};
void()	pdude_run7	=[	$run7,		pdude_run8	] {ai_run(7);};
void()	pdude_run8	=[	$run8,		pdude_run9	] {ai_run(10);};
void()	pdude_run9	=[	$run9,		pdude_run1	] {ai_run(7);};

void()      pdude_load1   =[    $reload1,      pdude_load2] {self.mk23clip = 13;};
void()      pdude_load2   =[    $reload2,      pdude_load3] {};
void()      pdude_load3   =[    $reload3,      pdude_load4] {};
void()      pdude_load4   =[    $reload4,      pdude_load5] {};
void()      pdude_load5   =[    $reload5,      pdude_load6] {};
void()      pdude_load6   =[    $reload6,      pdude_load7] {};
void()      pdude_load7   =[    $reload7,      pdude_load8] {setsize (self, '-23 -12 -25', '11 12 18');self.duck = 1;};
void()      pdude_load8   =[    $reload8,      pdude_load9] {};
void()      pdude_load9   =[    $reload9,      pdude_load10] {};
void()      pdude_load10   =[    $reload10,      pdude_load11] {};
void()      pdude_load11   =[    $reload11,      pdude_load12] {};
void()      pdude_load12   =[    $reload12,      pdude_load13] {};
void()      pdude_load13   =[    $reload13,      pdude_load14] {};
void()      pdude_load14   =[    $reload14,      pdude_load15] {};
void()      pdude_load15   =[    $reload15,      pdude_load16] {sound(self,CHAN_WEAPON,"weapons/mp5in.wav",1,ATTN_NORM);};
void()      pdude_load16   =[    $reload16,      pdude_load17] {};
void()      pdude_load17   =[    $reload17,      pdude_load18] {};
void()      pdude_load18   =[    $reload18,      pdude_load19] {};
void()      pdude_load19   =[    $reload19,      pdude_load20] {};
void()      pdude_load20   =[    $reload20,      pdude_load21] {};
void()      pdude_load21   =[    $reload21,      pdude_run1] {};

void() pdude_drawa1;

void()      pdude_leapleft1 = [  $leap1, pdude_leapleft2 ] {self.nextthink = time + 0.06;};
void()      pdude_leapleft2 = [  $leap2, pdude_leapleft3 ] {self.nextthink = time + 0.06;};
void()      pdude_leapleft3 = [  $leap3, pdude_leapleft4 ] {self.nextthink = time + 0.06;};
void()      pdude_leapleft4 = [  $leap4, pdude_leapleft5 ] {self.nextthink = time + 0.06;};
void()      pdude_leapleft5 = [  $leap5, pdude_leapleft6 ] {self.nextthink = time + 0.06;};
void()      pdude_leapleft6 = [  $leap6, pdude_leapleft7 ] {self.nextthink = time + 0.06;ai_strafeleft(8);};
void()      pdude_leapleft7 = [  $leap7, pdude_leapleft8 ] {self.nextthink = time + 0.06;ai_strafeleft(4);};
void()      pdude_leapleft8 = [  $leap8, pdude_leapleft9 ] {self.nextthink = time + 0.06;ai_strafeleft(4);};
void()      pdude_leapleft9 = [  $leap9, pdude_leapleft10 ] {self.nextthink = time + 0.06;ai_strafeleft(4);};
void()      pdude_leapleft10 = [  $leap10, pdude_leapleft11 ] {self.nextthink = time + 0.06;ai_strafeleft(4);};
void()      pdude_leapleft11 = [  $leap11, pdude_leapleft12 ] {self.nextthink = time + 0.06;ai_strafeleft(4);};
void()      pdude_leapleft12 = [  $leap12, pdude_leapleft13 ] {self.nextthink = time + 0.06;};
void()      pdude_leapleft13 = [  $leap13, pdude_leapleft14 ] {self.nextthink = time + 0.06;};
void()      pdude_leapleft14 = [  $leap14, pdude_drawa2 ] {};

void()      pdude_leapright1 = [  $leap1, pdude_leapright2 ] {self.nextthink = time + 0.06;};
void()      pdude_leapright2 = [  $leap2, pdude_leapright3 ] {self.nextthink = time + 0.06;};
void()      pdude_leapright3 = [  $leap3, pdude_leapright4 ] {self.nextthink = time + 0.06;};
void()      pdude_leapright4 = [  $leap4, pdude_leapright5 ] {self.nextthink = time + 0.06;};
void()      pdude_leapright5 = [  $leap5, pdude_leapright6 ] {self.nextthink = time + 0.06;};
void()      pdude_leapright6 = [  $leap6, pdude_leapright7 ] {ai_straferight(8);self.nextthink = time + 0.06;};
void()      pdude_leapright7 = [  $leap7, pdude_leapright8 ] {ai_straferight(4);self.nextthink = time + 0.06;};
void()      pdude_leapright8 = [  $leap8, pdude_leapright9 ] {ai_straferight(4);self.nextthink = time + 0.06;};
void()      pdude_leapright9 = [  $leap9, pdude_leapright10 ] {ai_straferight(4);self.nextthink = time + 0.06;};
void()      pdude_leapright10 = [  $leap10, pdude_leapright11 ] {ai_straferight(4);self.nextthink = time + 0.06;};
void()      pdude_leapright11 = [  $leap11, pdude_leapright12 ] {ai_straferight(4);self.nextthink = time + 0.06;};
void()      pdude_leapright12 = [  $leap12, pdude_leapright13 ] {self.nextthink = time + 0.06;};
void()      pdude_leapright13 = [  $leap13, pdude_leapright14 ] {self.nextthink = time + 0.06;};
void()      pdude_leapright14 = [  $leap14, pdude_drawa2 ] {};

void() pdude_fired1;

void()      pdude_roll1 = [ $roll1 , pdude_roll2 ] {self.nextthink = time + 0.05;};
void()      pdude_roll2 = [ $roll2 , pdude_roll3 ] {ai_moveforeward(3);self.nextthink = time + 0.05;};
void()      pdude_roll3 = [ $roll3 , pdude_roll4 ] {ai_moveforeward(2);self.nextthink = time + 0.05;};
void()      pdude_roll4 = [ $roll4 , pdude_roll5 ] {ai_moveforeward(2);self.nextthink = time + 0.05;};
void()      pdude_roll5 = [ $roll5 , pdude_roll6 ] {ai_moveforeward(1);self.nextthink = time + 0.05;};
void()      pdude_roll6 = [ $roll6 , pdude_roll7 ] {ai_moveforeward(3);self.nextthink = time + 0.05;};
void()      pdude_roll7 = [ $roll7 , pdude_roll8 ] {ai_moveforeward(7);self.nextthink = time + 0.05;};
void()      pdude_roll8 = [ $roll8 , pdude_roll9 ] {ai_moveforeward(8);self.nextthink = time + 0.05;};
void()      pdude_roll9 = [ $roll9 , pdude_roll10 ] {ai_moveforeward(6);setsize (self, '-23 -12 -25', '11 12 18');self.duck = 1;self.nextthink = time + 0.05;};
void()      pdude_roll10 = [ $roll10 , pdude_roll11 ] {ai_moveforeward(6);self.nextthink = time + 0.05;};
void()      pdude_roll11 = [ $roll11 , pdude_roll12 ] {ai_moveforeward(5);self.nextthink = time + 0.05;};
void()      pdude_roll12 = [ $roll12 , pdude_roll13 ] {ai_moveforeward(5);self.nextthink = time + 0.05;};
void()      pdude_roll13 = [ $roll13 , pdude_roll14 ] {ai_moveforeward(5);self.nextthink = time + 0.05;};
void()      pdude_roll14 = [ $roll14 , pdude_roll15 ] {ai_moveforeward(6);self.nextthink = time + 0.05;};
void()      pdude_roll15 = [ $roll15 , pdude_roll16 ] {ai_moveforeward(5);self.nextthink = time + 0.05;};
void()      pdude_roll16 = [ $roll16 , pdude_roll17 ] {ai_moveforeward(5);self.nextthink = time + 0.05;};
void()      pdude_roll17 = [ $roll17 , pdude_roll18 ] {ai_moveforeward(5);self.nextthink = time + 0.05;};
void()      pdude_roll18 = [ $roll18 , pdude_roll19 ] {ai_moveforeward(5);self.nextthink = time + 0.05;};
void()      pdude_roll19 = [ $roll19 , pdude_roll20 ] {ai_moveforeward(5);self.nextthink = time + 0.05;};
void()      pdude_roll20 = [ $roll20 , pdude_roll21 ] {ai_moveforeward(5);self.nextthink = time + 0.05;};
void()      pdude_roll21 = [ $roll21 , pdude_roll22 ] {ai_moveforeward(5);self.nextthink = time + 0.05;};
void()      pdude_roll22 = [ $roll22 , pdude_roll23 ] {ai_moveforeward(5);self.nextthink = time + 0.05;};
void()      pdude_roll23 = [ $roll23 , pdude_roll24 ] {ai_moveforeward(3);self.nextthink = time + 0.05;};
void()      pdude_roll24 = [ $roll24 , pdude_roll25 ] {ai_moveforeward(2.5);self.nextthink = time + 0.05;};
void()      pdude_roll25 = [ $roll25 , pdude_roll26 ] {ai_moveforeward(-0.5);self.nextthink = time + 0.05;};
void()      pdude_roll26 = [ $roll26 , pdude_roll27 ] {ai_moveforeward(-1);self.nextthink = time + 0.05;};
void()      pdude_roll27 = [ $roll27 , pdude_fired1 ] {ai_moveforeward(-0.5);};

void()      pdude_fired1 = [ $fired1 , pdude_fired2  ]
{
 ai_face();
 pdude_fire();
};

void()      pdude_fired2 = [ $fired2 , pdude_fired3 ] 
{ 
 ai_face();
};

void()      pdude_fired3 = [ $fired3 , pdude_run1 ] 
{ 
 ai_face();
 SUB_CheckRefire (pdude_fired1);
 if (self.mk23clip <= 0)
   {
     self.think = pdude_load1;
   }
};

void()      pdude_firea1 = [ $firea1 , pdude_firea2 ] 
{ 
 ai_face();
 pdude_fire();
};

void()      pdude_firea2 = [ $firea2 , pdude_firea3 ] 
{ 
 ai_face();
};

void()      pdude_firea3 = [ $firea3 , pdude_run1 ] 
{ 
 ai_face();
 SUB_CheckRefire (pdude_firea1);
 if (self.mk23clip <= 0)
   {
     self.think = pdude_load1;
   }
};

void() pdude_drawb1;

void()      pdude_drawa1   =[    $drawa1,     pdude_drawa2   ] 
{
 local float temp;

 temp = random();
 ai_face();
 if (temp < 0.35)
  {
   self.think = pdude_drawa1;
   self.nextthink = time + 0.06;
  }
 if ( (temp < 0.8) && (temp >= 0.35) )
  {
   self.think = pdude_drawb1;
   self.nextthink = time + 0.06;
  }
 if ( (temp < 0.9) && (temp >= 0.8) ) 
  { 
   self.think = pdude_roll1;
   self.nextthink = time + 0.06;
  }
 if ( (temp < 0.95) && (temp >= 0.9) )
  {
   self.think = pdude_leapright1;
   self.nextthink = time + 0.06;
  }
 if (temp >= 0.95)
  {
   self.think = pdude_leapleft1;
   self.nextthink = time + 0.06;
  }

/*** Check to see if grenades are throwable ***/
 if ( ( (self.absmax_z - self.enemy.absmax_z) > -50) 
    && ( ( vlen(self.enemy.origin - self.origin) ) > 500) 
    && (self.firstgrenade != 23) )
  {
   if (random () < 0.8)
    {
     self.think = pdude_grenade1;
     self.attack_finished = time + 1.3;
     self.firstgrenade = 23;
    }
  }   

/*** Check to see if reload is necessary ***/
 if (self.mk23clip <= 0)
    self.think = pdude_load1;
 

/*** Check to see if someone is in front of me ***/
 traceline(self.origin,self.enemy.origin,0,self);
 if ( (trace_ent.classname == "guard") || (trace_ent.classname == "pdude") )
  {
    if (random() < 0.50)
      self.think = pdude_leapright1;
    else
      self.think = pdude_leapleft1;
  }

};

void()      pdude_drawa2   =[    $drawa2,     pdude_drawa3   ] {ai_face();self.nextthink = time + 0.06;};
void()      pdude_drawa3   =[    $drawa3,     pdude_drawa4   ] {ai_face();self.nextthink = time + 0.06;};
void()      pdude_drawa4   =[    $drawa4,     pdude_drawa5   ] {ai_face();self.nextthink = time + 0.06;};
void()      pdude_drawa5   =[    $drawa5,     pdude_drawa6   ] {ai_face();self.nextthink = time + 0.06;};
void()      pdude_drawa6   =[    $drawa6,     pdude_drawa7   ] {ai_face();self.nextthink = time + 0.06;};
void()      pdude_drawa7   =[    $drawa7,     pdude_firea1   ] {ai_face();self.nextthink = time + 0.06;};

/************************* END OF DRAWA  ************************/

void()      pdude_fireb1         =[    $fireb1,     pdude_fireb2   ] 
{ 
 ai_face();
 pdude_fire();
};

void()      pdude_fireb2         =[    $fireb2,     pdude_fireb3   ] 
{ 
 ai_face();
};


void()      pdude_fireb3         =[    $fireb3,     pdude_run1     ] 
{ 
 ai_face();
 self.nextthink = time + 0.05;
 SUB_CheckRefire (pdude_fireb1);
 if (self.mk23clip <= 0)
    self.think = pdude_load1;
};

void()      pdude_drawb1   =[    $drawb1,     pdude_drawb2   ] {ai_face();self.nextthink = time + 0.06;};
void()      pdude_drawb2   =[    $drawb2,     pdude_drawb3   ] {ai_face();self.nextthink = time + 0.06;};
void()      pdude_drawb3   =[    $drawb3,     pdude_drawb4   ] {ai_face();self.nextthink = time + 0.06;};
void()      pdude_drawb4   =[    $drawb4,     pdude_drawb5   ] {ai_face();self.nextthink = time + 0.06;};
void()      pdude_drawb5   =[    $drawb5,     pdude_drawb6   ] {ai_face();self.nextthink = time + 0.06;};
void()      pdude_drawb6   =[    $drawb6,     pdude_fireb1   ] 
 {
  ai_face();
  self.nextthink = time + 0.06;
  if (random() < 0.5)
   self.think = pdude_straferight1;
 };

/************************** END OF DRAWB *******************************/




void()	pdude_paina1	=[	$paina1,		pdude_paina2	] {};
void()	pdude_paina2	=[	$paina2,		pdude_paina3	] {};
void()	pdude_paina3	=[	$paina3,		pdude_paina4	] {};
void()	pdude_paina4	=[	$paina4,		pdude_paina5	] {};
void()	pdude_paina5	=[	$paina5,		pdude_paina6	] {};
void()	pdude_paina6	=[	$paina6,		pdude_drawa1	] {};

void()	pdude_painb1	=[	$painb1,	pdude_painb2	] {};
void()	pdude_painb2	=[	$painb2,	pdude_painb3	] {};
void()	pdude_painb3	=[	$painb3,	pdude_painb4	] {};
void()	pdude_painb4	=[	$painb4,	pdude_painb5	] {};
void()	pdude_painb5	=[	$painb5,	pdude_drawb6	] {};
void()	pdude_painb6	=[	$painb6,	pdude_painb7	] {};
void()	pdude_painb7	=[	$painb7,	pdude_painb8	] {};
void()	pdude_painb8	=[	$painb8,	pdude_drawa1	] {};

void()	pdude_painc1	=[	$painc1,	pdude_painc2	] {};
void()	pdude_painc2	=[	$painc2,	pdude_painc3	] {};
void()	pdude_painc3	=[	$painc3,	pdude_painc4	] {};
void()	pdude_painc4	=[	$painc4,	pdude_painc5	] {};
void()	pdude_painc5	=[	$painc5,	pdude_painc6	] {};
void()	pdude_painc6	=[	$painc6,	pdude_drawa1	] {};

void()	pdude_paind1	=[	$paind1,	pdude_paind2	] {};
void()	pdude_paind2	=[	$paind2,	pdude_paind3	] {};
void()	pdude_paind3	=[	$paind3,	pdude_paind4	] {};
void()	pdude_paind4	=[	$paind4,	pdude_paind5	] {};
void()	pdude_paind5	=[	$paind5,	pdude_paind6	] {};
void()	pdude_paind6	=[	$paind6,	pdude_drawa1	] {};

void()	pdude_paine1	=[	$paine1,	pdude_paine2	] {};
void()	pdude_paine2	=[	$paine2,	pdude_paine3	] {};
void()	pdude_paine3	=[	$paine3,	pdude_paine4	] {};
void()	pdude_paine4	=[	$paine4,	pdude_paine5	] {};
void()	pdude_paine5	=[	$paine5,	pdude_paine6	] {};
void()	pdude_paine6	=[	$paine6,	pdude_drawa1	] {};

void()	pdude_Melee =
{
	local	float	ldmg;
	local vector	delta;
	
	ai_face ();
	walkmove (self.ideal_yaw, 12);	// allow a little closing

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 100)
		return;
	if (!CanDamage (self.enemy, self))
		return;
		
      sound (self, CHAN_WEAPON, "weapons/slash.wav", 1, ATTN_NORM);
	ldmg = 10 + 5*random();
	T_Damage (self.enemy, self, self, ldmg);	

	makevectors (self.angles);
};

void() pdudeFireGrenade =
{
	local	entity missile, mpuff;
	

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
		
// set missile speed	

	makevectors (self.angles);

	missile.velocity = normalize(self.enemy.origin - self.origin);
	missile.velocity = missile.velocity * 400;
	missile.velocity_z = 400;

	missile.avelocity = '300 300 300';

	missile.angles = vectoangles(missile.velocity);
	
	missile.touch = HandGrenadeTouch;
	
// set missile duration
	missile.nextthink = time + 2.5;
	missile.think = M16GrenadeExplode;

	setmodel (missile, "progs/m16gren.mdl");
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, self.origin);
};

void(entity attacker, float damage)	pdude_pain =
{
	local float r;
	
	//if (self.pain_finished > time)
	//	return;

	r = random();

    if (self.duck == 1)
     {
      if (r < 0.5)
         {
          self.pain_finished = time + 0.1;
          sound(self,CHAN_BODY,"weapons/pain1.wav",1,ATTN_NORM);
          pdude_paina1 ();
         }
      else
         {
          self.pain_finished = time + 0.1;
          sound(self,CHAN_BODY,"weapons/pain2.wav",1,ATTN_NORM);
          pdude_painb1 ();
         }
     }
    else
     {
      if (r < 0.333)
	{
		pdude_painc1 ();
            sound(self,CHAN_BODY,"weapons/pain3.wav",1,ATTN_NORM);
	}
	if ( (r < 0.666) && (r >= 0.333) )
	{
		pdude_paind1 ();
            sound(self,CHAN_BODY,"weapons/pain1.wav",1,ATTN_NORM);
	}
	else
	{
		pdude_paine1 ();
            sound(self,CHAN_BODY,"weapons/pain2.wav",1,ATTN_NORM);
	}
     }
};

void() pdude_fire =
{
	local	vector	dir;
	local	entity	en;
	
	ai_face();
	
	sound (self, CHAN_WEAPON, "weapons/pdudegun.wav", 1, ATTN_NORM);	

// fire somewhat behind the player, so a dodging player is harder to hit
	en = self.enemy;
	
	dir = (en.origin + '0 0 -8') - en.velocity*0.2;
	dir = normalize (dir - self.origin);
	
	guardFire(17,dir);
        self.mk23clip = self.mk23clip - 1;
};


void()      pdude_melee1 = [   $melee1,   pdude_melee2 ] {ai_face();self.nextthink = time + 0.06;};
void()      pdude_melee2 = [   $melee2,   pdude_melee3 ] {ai_face();self.nextthink = time + 0.06;};
void()      pdude_melee3 = [   $melee3,   pdude_melee4 ] {ai_face();self.nextthink = time + 0.06;};
void()      pdude_melee4 = [   $melee4,   pdude_melee5 ] {ai_face();self.nextthink = time + 0.06;};
void()      pdude_melee5 = [   $melee5,   pdude_melee6 ] {ai_face();self.nextthink = time + 0.06;};
void()      pdude_melee6 = [   $melee6,   pdude_melee7 ] {ai_face();self.nextthink = time + 0.06;};
void()      pdude_melee7 = [   $melee7,   pdude_melee8 ] {ai_face();pdude_Melee ();self.nextthink = time + 0.06;};
void()      pdude_melee8 = [   $melee8,   pdude_melee9 ] {ai_face();pdude_Melee ();self.nextthink = time + 0.06;};
void()      pdude_melee9 = [   $melee9,   pdude_melee10 ] {ai_face();self.nextthink = time + 0.06;};
void()      pdude_melee10 = [   $melee10,   pdude_melee11 ] {ai_face();self.nextthink = time + 0.06;};
void()      pdude_melee11 = [   $melee11,   pdude_melee12 ] {ai_face();self.nextthink = time + 0.06;};
void()      pdude_melee12 = [   $melee12,   pdude_melee13 ] {ai_face();self.nextthink = time + 0.06;};
void()      pdude_melee13 = [   $melee13,   pdude_melee14 ] {ai_face();pdude_Melee ();self.nextthink = time + 0.06;};
void()      pdude_melee14 = [   $melee14,   pdude_melee15 ] {ai_face();pdude_Melee ();self.nextthink = time + 0.06;};
void()      pdude_melee15 = [   $melee15,   pdude_melee16 ] {ai_face();self.nextthink = time + 0.06;};
void()      pdude_melee16 = [   $melee16,   pdude_melee17 ] {ai_face();self.nextthink = time + 0.06;};
void()      pdude_melee17 = [   $melee17,   pdude_melee18 ] {ai_face();self.nextthink = time + 0.06;};
void()      pdude_melee18 = [   $melee18,   pdude_run1 ] {ai_face();};


void()	pdude_diea1	=[	$deatha1,	pdude_diea2	] {self.nextthink = time + 0.05;};
void()	pdude_diea2	=[	$deatha2,	pdude_diea3	] {self.nextthink = time + 0.05; ai_moveforeward(-4);};
void()	pdude_diea3	=[	$deatha3,	pdude_diea4	] 
{
  ai_moveforeward(-4);
  self.solid = SOLID_NOT;
  self.nextthink = time + 0.05;
  self.ammo_shells = ceil(self.mk23clip * 0.5);
  Drop_Clip();
  ai_back(4);
};
void()	pdude_diea4	=[	$deatha4,	pdude_diea5	] {self.nextthink = time + 0.05;ai_moveforeward(-4);};
void()	pdude_diea5	=[	$deatha5,	pdude_diea6	] {self.nextthink = time + 0.05;ai_moveforeward(-4);};
void()	pdude_diea6	=[	$deatha6,	pdude_diea7	] {self.nextthink = time + 0.05;ai_moveforeward(-4);};
void()	pdude_diea7	=[	$deatha7,	pdude_diea8	] {self.nextthink = time + 0.05;ai_moveforeward(-4);};
void()	pdude_diea8	=[	$deatha8,	pdude_diea9	] {self.nextthink = time + 0.05;ai_moveforeward(-4);};
void()	pdude_diea9	=[	$deatha9,	pdude_diea10	] {self.nextthink = time + 0.05;ai_moveforeward(-2);};
void()	pdude_diea10	=[	$deatha10,	pdude_diea11	] {self.nextthink = time + 0.05;};
void()	pdude_diea11	=[	$deatha11,	pdude_diea12	] {self.nextthink = time + 0.05;};
void()	pdude_diea12	=[	$deatha12,	pdude_diea13	] {self.nextthink = time + 0.05;};
void()	pdude_diea13	=[	$deatha13,	pdude_diea14	] {self.nextthink = time + 0.05;};
void()	pdude_diea14	=[	$deatha14,	pdude_diea14	] {};

/*

void()	pdude_dieb1	=[	$deathb1,	pdude_dieb2	] {self.nextthink = time + 0.05;};
void()	pdude_dieb2	=[	$deathb2,	pdude_dieb3	] {self.nextthink = time + 0.05;};
void()	pdude_dieb3	=[	$deathb3,	pdude_dieb4	]
{
  self.nextthink = time + 0.05;
  self.solid = SOLID_NOT;
  self.ammo_shells = ceil(self.mk23clip * 0.5);
  Drop_Clip();
};
void()	pdude_dieb4	=[	$deathb4,	pdude_dieb5	] {self.nextthink = time + 0.05;};
void()	pdude_dieb5	=[	$deathb5,	pdude_dieb6	] {self.nextthink = time + 0.05;};
void()	pdude_dieb6	=[	$deathb6,	pdude_dieb7	] {self.nextthink = time + 0.05;};
void()	pdude_dieb7	=[	$deathb7,	pdude_dieb8	] {self.nextthink = time + 0.05;};
void()	pdude_dieb8	=[	$deathb8,	pdude_dieb9	] {self.nextthink = time + 0.05;};
void()	pdude_dieb9	=[	$deathb9,	pdude_dieb10	] {self.nextthink = time + 0.05;};
void()	pdude_dieb10	=[	$deathb10,	pdude_dieb11	] {self.nextthink = time + 0.05;};
void()	pdude_dieb11	=[	$deathb11,	pdude_dieb11	] {};

*/

void()	pdude_diec1	=[	$deathc1,	pdude_diec2	] {self.nextthink = time + 0.05;};
void()	pdude_diec2	=[	$deathc2,	pdude_diec3	] {self.nextthink = time + 0.05;};
void()	pdude_diec3	=[	$deathc3,	pdude_diec4	]
{
  self.nextthink = time + 0.05;
  self.solid = SOLID_NOT;
  self.ammo_shells = ceil(self.mk23clip * 0.5);
  Drop_Clip();

};
void()	pdude_diec4	=[	$deathc4,	pdude_diec5	] {self.nextthink = time + 0.05;};
void()	pdude_diec5	=[	$deathc5,	pdude_diec6	] {self.nextthink = time + 0.05;};
void()	pdude_diec6	=[	$deathc6,	pdude_diec7	] {self.nextthink = time + 0.05;};
void()	pdude_diec7	=[	$deathc7,	pdude_diec8	] {self.nextthink = time + 0.05;};
void()	pdude_diec8	=[	$deathc8,	pdude_diec9	] {self.nextthink = time + 0.05;};
void()	pdude_diec9	=[	$deathc9,	pdude_diec10	] {self.nextthink = time + 0.05;};
void()	pdude_diec10	=[	$deathc10,	pdude_diec11	] {self.nextthink = time + 0.05;};
void()	pdude_diec11	=[	$deathc11,	pdude_diec12	] {self.nextthink = time + 0.05;};
void()	pdude_diec12	=[	$deathc12,	pdude_diec12	] {};

void()	pdude_died1	=[	$deathd1,	pdude_died2	] {self.nextthink = time + 0.05;};
void()	pdude_died2	=[	$deathd2,	pdude_died3	] {self.nextthink = time + 0.05;};
void()	pdude_died3	=[	$deathd3,	pdude_died4	]
{
  self.nextthink = time + 0.05;
  self.solid = SOLID_NOT;
  self.ammo_shells = ceil(self.mk23clip * 0.5);
  Drop_Clip();
};
void()	pdude_died4	=[	$deathd4,	pdude_died5	] {self.nextthink = time + 0.05;};
void()	pdude_died5	=[	$deathd5,	pdude_died6	] {self.nextthink = time + 0.05;};
void()	pdude_died6	=[	$deathd6,	pdude_died7	] {self.nextthink = time + 0.05;};
void()	pdude_died7	=[	$deathd7,	pdude_died8	] {self.nextthink = time + 0.05;};
void()	pdude_died8	=[	$deathd8,	pdude_died9	] {self.nextthink = time + 0.05;};
void()	pdude_died9	=[	$deathd9,	pdude_died9	] {};

void()	pdude_diee1	=[	$deathe1,	pdude_diee2	] {self.nextthink = time + 0.05;};
void()	pdude_diee2	=[	$deathe2,	pdude_diee3	] {self.nextthink = time + 0.05;};
void()	pdude_diee3	=[	$deathe3,	pdude_diee4	]
{
  self.nextthink = time + 0.05;
  self.solid = SOLID_NOT;
  self.ammo_shells = ceil(self.mk23clip * 0.5);
  Drop_Clip();
  ai_back(4);
};
void()	pdude_diee4	=[	$deathe4,	pdude_diee5	] {self.nextthink = time + 0.05;};
void()	pdude_diee5	=[	$deathe5,	pdude_diee6	] {self.nextthink = time + 0.05;};
void()	pdude_diee6	=[	$deathe6,	pdude_diee7	] {self.nextthink = time + 0.05;};
void()	pdude_diee7	=[	$deathe7,	pdude_diee8	] {self.nextthink = time + 0.05;};
void()	pdude_diee8	=[	$deathe8,	pdude_diee9	] {self.nextthink = time + 0.05;};
void()	pdude_diee9	=[	$deathe9,	pdude_diee10	] {self.nextthink = time + 0.05;};
void()	pdude_diee10	=[	$deathe10,	pdude_diee11	] {self.nextthink = time + 0.05;};
void()  pdude_diee11    =[      $deathe11,      pdude_diee12    ] {self.nextthink = time + 0.05;};
void()  pdude_diee12    =[      $deathe12,      pdude_diee12    ] {};

void()	pdude_dief1	=[	$deathf1,	pdude_dief2	] {self.nextthink = time + 0.05;};
void()	pdude_dief2	=[	$deathf2,	pdude_dief3	] {self.nextthink = time + 0.05;};
void()	pdude_dief3	=[	$deathf3,	pdude_dief4	]
{
self.nextthink = time + 0.05;
  self.solid = SOLID_NOT;
  self.ammo_shells = ceil(self.mk23clip * 0.5);
  Drop_Clip();
  ai_back(4);
};
void()	pdude_dief4	=[	$deathf4,	pdude_dief5	] {self.nextthink = time + 0.05;};
void()	pdude_dief5	=[	$deathf5,	pdude_dief6	] {self.nextthink = time + 0.05;};
void()	pdude_dief6	=[	$deathf6,	pdude_dief7	] {self.nextthink = time + 0.05;};
void()	pdude_dief7	=[	$deathf7,	pdude_dief8	] {self.nextthink = time + 0.05;};
void()	pdude_dief8	=[	$deathf8,	pdude_dief9	] {self.nextthink = time + 0.05;};
void()	pdude_dief9	=[	$deathf9,	pdude_dief9	] {};


void() pdude_die =
{

      local float temp;

   //check for gib

      if ((self.health < -100) && (self.headshot == 0))
	{
            sound (self,CHAN_VOICE,"player/udeath.wav",TRUE,ATTN_NORM);
            ThrowHead ("progs/torso.mdl",self.health);
            ThrowChunk ("progs/r_leg.mdl",self.health);
            ThrowChunk ("progs/l_leg.mdl",self.health);
            return ;
	}

      if ((self.health < -20) && (self.headshot == 1))
	{
            ThrowHeadlessCorpse ("progs/pduded.mdl",self.health);
            return ;
	}

      if ((self.health < -20) && (self.headshot == 0))
	{
            sound (self,CHAN_VOICE,"player/udeath.wav",TRUE,ATTN_NORM);
            ThrowBlastedCorpse ("progs/corpse2.mdl",self.health);
            return ;
	}

      if (self.health < -20)
	{
            sound (self,CHAN_VOICE,"weapons/die2.wav",TRUE,ATTN_NORM);
            ThrowHead ("progs/corpse.mdl",self.health);
            ThrowChunk ("progs/r_leg.mdl",self.health);
            return ;
	}
      

      temp = random();
 
      if (self.duck == 1)
       {
		pdude_diea1 ();
       	sound (self, CHAN_VOICE, "weapons/die1.wav", 1, ATTN_NORM);     
       }
     else if (self.headshot == -1)
       {
         pdude_diee1 ();
       }
     else
      {
	 if (temp < 0.25)
        {
		pdude_diec1 ();
       	sound (self, CHAN_VOICE, "weapons/die2.wav", 1, ATTN_NORM);
        }
 	if ( (temp < 0.5) && (temp >= 0.25) )
        {
		pdude_diec1 ();
       	sound (self, CHAN_VOICE, "weapons/die3.wav", 1, ATTN_NORM);     
        }
      if ( (temp < 0.75) && (temp >= 0.5) )
        {
            pdude_died1 ();
            sound (self, CHAN_VOICE, "weapons/die2.wav", 1 , ATTN_NORM);
        }
      if (temp >= 0.75) 
        {
            pdude_dief1 ();
            sound (self, CHAN_VOICE, "weapons/die1.wav", 1 , ATTN_NORM);
        }      

      }
};


/*QUAKED pdude_army (1 0 0) (-16 -16 -24) (16 16 40) Ambush
*/

void() monster_army =
{	
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model2 ("progs/pdude.mdl");
      precache_model2 ("progs/pduded.mdl");
      precache_model2 ("progs/corpse.mdl");
      precache_model2 ("progs/corpse2.mdl");
      precache_model2 ("progs/r_leg.mdl");
      precache_model2 ("progs/torso.mdl");
      precache_model2 ("progs/l_leg.mdl");
//	precache_model ("progs/h_guard.mdl");
//	precache_model ("progs/gib1.mdl");
//	precache_model ("progs/gib2.mdl");
//	precache_model ("progs/gib3.mdl");

      precache_sound2 ("weapons/die1.wav");
      precache_sound2 ("weapons/die2.wav");
      precache_sound2 ("weapons/die3.wav");
      precache_sound2 ("weapons/pain1.wav");
      precache_sound2 ("weapons/pain2.wav");
      precache_sound2 ("weapons/pain3.wav");
	precache_sound ("soldier/death1.wav");
	precache_sound ("soldier/idle.wav");
	precache_sound ("soldier/pain1.wav");
	precache_sound ("soldier/pain2.wav");
	precache_sound ("soldier/sattck1.wav");
	precache_sound ("soldier/sight1.wav");

	precache_sound ("player/udeath.wav");		// gib death
      precache_sound2 ("weapons/pdudegun.wav");


	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
            setmodel(self, "progs/pdude.mdl");

	setsize (self, '-16 -16 -24', '16 16 35');
	self.health = 80;
        self.mk23clip = 13;
	self.th_stand = pdude_stand1;
	self.th_walk = pdude_walk1;
	self.th_run = pdude_run1;
	self.th_missile = pdude_drawa1;
      self.th_melee = pdude_melee1;
	self.th_pain = pdude_pain;
	self.th_die = pdude_die;

	walkmonster_start ();
};


