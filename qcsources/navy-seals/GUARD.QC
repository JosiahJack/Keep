/*
==============================================================================

PRISON GUARD

==============================================================================
*/

$cd id1/models/guard
$origin 0 -6 -24
$base base		
$skin skin

$frame deathd1 deathd2 deathd3 deathd4 deathd5 deathd6 deathd7 deathd8
$frame deathd9 

$frame deatha1 deatha2 deatha3 deatha4 deatha5 deatha6 deatha7 deatha8
$frame deatha9 deatha10 

$frame deathb1 deathb2 deathb3 deathb4 deathb5 deathb6 deathb7 deathb8
$frame deathb9 deathb10 deathb11 

$frame deathc1 deathc2 deathc3 deathc4 deathc5 deathc6 deathc7 deathc8
$frame deathc9 deathc10 deathc11 deathc12 

$frame paina1 paina2 paina3 paina4 paina5 

$frame painb1 painb2 painb3 painb4 painb5

$frame painc1 painc2 painc3 painc4 painc5 painc6 painc7 

$frame paind1 paind2 paind3 paind4 paind5

$frame melee1 melee2 melee3 melee4 melee5 melee6 melee7 melee8 melee9 melee10

$frame load1 load2 load3 load4 load5 load6 load7 load8 load9 load10
$frame load11 load12 load13 load14

$frame grenade1 grenade2 grenade3 grenade4 grenade5 grenade6 grenade7 grenade8 grenade9
$frame grenade10 grenade11 grenade12 grenade13 grenade14 grenade15 grenade16

$frame drawa1 drawa2 drawa3 drawa4 drawa5 drawa6 drawa7

$frame firea1 firea2 firea3 firea4 firea5 firea6 firea7 firea8

$frame drawb1 drawb2 drawb3 drawb4 drawb5 drawb6 drawb7 drawb8 drawb9

$frame fireb1 fireb2

$frame drawc1 drawc2 drawc3 drawc4 drawc5 drawc6 drawc7 drawc8 drawc9

$frame firec1 firec2 firec3 firec4 firec5 firec6 firec7 firec8 firec9 firec10
$frame firec11 firec12 firec13 

$frame rstrafe1 rstrafe2 rstrafe3 rstrafe4 rstrafe5 rstrafe6 rstrafe7

$frame lstrafe1 lstrafe2 lstrafe3 lstrafe4 lstrafe5 lstrafe6 lstrafe7

$frame run1 run2 run3 run4 run5 run6 run7 run8 run9

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10
$frame walk11 walk12 walk13 walk14 walk15 walk16 walk17 walk18 walk19
$frame walk20 walk21 walk22 walk23 walk24 walk25 walk26 walk27 walk28
$frame walk29 walk30 walk31 walk32

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9
$frame stand10 stand11 stand12 stand13 stand14 stand15 stand16 stand17 
$frame stand18 stand19 stand20 stand21 stand22


/*
==============================================================================
SOLDIER CODE
==============================================================================
*/

void (float dist) ai_straferight =
{
	walkmove (self.angles_y+90, dist);
};

void (float dist) ai_strafeleft =
{
	walkmove ( (self.angles_y+270), dist);
};

void() guard_fire;
void() guardFireGrenade;

void()      guard_grenade1 = [ $grenade1, guard_grenade2] {ai_face();};
void()      guard_grenade2 = [ $grenade2, guard_grenade3] {ai_face();};
void()      guard_grenade3 = [ $grenade3, guard_grenade4] {ai_face();};
void()      guard_grenade4 = [ $grenade4, guard_grenade5] {ai_face();};
void()      guard_grenade5 = [ $grenade5, guard_grenade6] {ai_face();};
void()      guard_grenade6 = [ $grenade6, guard_grenade7] {ai_face();};
void()      guard_grenade7 = [ $grenade7, guard_grenade8] {ai_face();};
void()      guard_grenade8 = [ $grenade8, guard_grenade9] {ai_face();};
void()      guard_grenade9 = [ $grenade9, guard_grenade10] {ai_face();};
void()      guard_grenade10 = [ $grenade10, guard_grenade11] {ai_face();};
void()      guard_grenade11 = [ $grenade11, guard_grenade12] {ai_face();};
void()      guard_grenade12 = [ $grenade12, guard_grenade13] {ai_face();guardFireGrenade();};
void()      guard_grenade13 = [ $grenade13, guard_grenade14] {ai_face();};
void()      guard_grenade14 = [ $grenade14, guard_grenade15] {ai_face();};
void()      guard_grenade15 = [ $grenade15, guard_grenade16] {ai_face();};
void()      guard_grenade16 = [ $grenade16, guard_run1] {ai_face();};

void()      guard_straferight1 = [ $rstrafe1,   guard_straferight2] {ai_face();ai_straferight(5);guard_fire();};
void()      guard_straferight2 = [ $rstrafe2,   guard_straferight3] {ai_face();ai_straferight(7);};
void()      guard_straferight3 = [ $rstrafe3,   guard_straferight4] {ai_face();ai_straferight(6);guard_fire();};
void()      guard_straferight4 = [ $rstrafe4,   guard_straferight5] {ai_face();ai_straferight(6);};
void()      guard_straferight5 = [ $rstrafe5,   guard_straferight6] {ai_face();ai_straferight(5);guard_fire();};
void()      guard_straferight6 = [ $rstrafe6,   guard_straferight7] {ai_face();ai_straferight(5);};
void()      guard_straferight7 = [ $rstrafe7,   guard_straferight8] {ai_face();ai_straferight(3);guard_fire();};
void()      guard_straferight8 = [ $rstrafe1,   guard_straferight9] {ai_face();ai_straferight(5);guard_fire();};
void()      guard_straferight9 = [ $rstrafe2,   guard_straferight10] {ai_face();ai_straferight(7);};
void()      guard_straferight10 = [ $rstrafe3,   guard_straferight11] {ai_face();ai_straferight(6);guard_fire();};
void()      guard_straferight11 = [ $rstrafe4,   guard_straferight12] {ai_face();ai_straferight(6);};
void()      guard_straferight12 = [ $rstrafe5,   guard_straferight13] {ai_face();ai_straferight(5);guard_fire();};
void()      guard_straferight13 = [ $rstrafe6,   guard_straferight14] {ai_face();ai_straferight(5);};
void()      guard_straferight14 = [ $rstrafe7,   guard_run1] {ai_face();ai_straferight(3);guard_fire();};

void()      guard_strafeleft1 = [ $lstrafe1,   guard_strafeleft2] {ai_face();ai_strafeleft(5);guard_fire();};
void()      guard_strafeleft2 = [ $lstrafe2,   guard_strafeleft3] {ai_face();ai_strafeleft(7);};
void()      guard_strafeleft3 = [ $lstrafe3,   guard_strafeleft4] {ai_face();ai_strafeleft(6);guard_fire();};
void()      guard_strafeleft4 = [ $lstrafe4,   guard_strafeleft5] {ai_face();ai_strafeleft(6);};
void()      guard_strafeleft5 = [ $lstrafe5,   guard_strafeleft6] {ai_face();ai_strafeleft(5);guard_fire();};
void()      guard_strafeleft6 = [ $lstrafe6,   guard_strafeleft7] {ai_face();ai_strafeleft(5);};
void()      guard_strafeleft7 = [ $lstrafe7,   guard_strafeleft8] {ai_face();ai_strafeleft(3);guard_fire();};
void()      guard_strafeleft8 = [ $lstrafe1,   guard_strafeleft9] {ai_face();ai_strafeleft(5);guard_fire();};
void()      guard_strafeleft9 = [ $lstrafe2,   guard_strafeleft10] {ai_face();ai_strafeleft(7);};
void()      guard_strafeleft10 = [ $lstrafe3,   guard_strafeleft11] {ai_face();ai_strafeleft(6);guard_fire();};
void()      guard_strafeleft11 = [ $lstrafe4,   guard_strafeleft12] {ai_face();ai_strafeleft(6);};
void()      guard_strafeleft12 = [ $lstrafe5,   guard_strafeleft13] {ai_face();ai_strafeleft(5);guard_fire();};
void()      guard_strafeleft13 = [ $lstrafe6,   guard_strafeleft14] {ai_face();ai_strafeleft(5);};
void()      guard_strafeleft14 = [ $lstrafe7,   guard_run1] {ai_face();ai_strafeleft(3);guard_fire();};

void()	guard_stand1	=[	$stand1,	guard_stand2	] {ai_stand();};
void()	guard_stand2	=[	$stand2,	guard_stand3	] {ai_stand();};
void()	guard_stand3	=[	$stand3,	guard_stand4	] {ai_stand();};
void()	guard_stand4	=[	$stand4,	guard_stand5	] {ai_stand();};
void()	guard_stand5	=[	$stand5,	guard_stand6	] {ai_stand();};
void()	guard_stand6	=[	$stand6,	guard_stand7	] {ai_stand();};
void()	guard_stand7	=[	$stand7,	guard_stand8	] {ai_stand();};
void()	guard_stand8	=[	$stand8,	guard_stand9	] {ai_stand();};
void()	guard_stand9	=[	$stand9,	guard_stand10	] {ai_stand();};
void()	guard_stand10	=[	$stand10,	guard_stand11	] {ai_stand();};
void()	guard_stand11	=[	$stand11,	guard_stand12	] {ai_stand();};
void()	guard_stand12	=[	$stand12,	guard_stand13	] {ai_stand();};
void()	guard_stand13	=[	$stand13,	guard_stand14	] {ai_stand();};
void()	guard_stand14	=[	$stand14,	guard_stand15	] {ai_stand();};
void()	guard_stand15	=[	$stand15,	guard_stand16	] {ai_stand();};
void()	guard_stand16	=[	$stand16,	guard_stand17	] {ai_stand();};
void()	guard_stand17	=[	$stand17,	guard_stand18	] {ai_stand();};
void()	guard_stand18	=[	$stand18,	guard_stand19	] {ai_stand();};
void()	guard_stand19 	=[	$stand19,	guard_stand20	] {ai_stand();};
void()	guard_stand20	=[	$stand20,	guard_stand21	] {ai_stand();};
void()	guard_stand21	=[	$stand21,	guard_stand22	] {ai_stand();};
void()	guard_stand22	=[	$stand22,	guard_stand1	] {ai_stand();};

void()	guard_walk1	=[	$walk1,	guard_walk2	] {ai_walk(2);};
void()	guard_walk2	=[	$walk2,	guard_walk3	] {ai_walk(4);};
void()	guard_walk3	=[	$walk3,	guard_walk4	] {ai_walk(4);};
void()	guard_walk4	=[	$walk4,	guard_walk5	] {ai_walk(3);};
void()	guard_walk5	=[	$walk5,	guard_walk6	] {ai_walk(1);};
void()	guard_walk6	=[	$walk6,	guard_walk7	] {ai_walk(2);};
void()	guard_walk7	=[	$walk7,	guard_walk8	] {ai_walk(2);};
void()	guard_walk8	=[	$walk8,	guard_walk9	] {ai_walk(1);};
void()	guard_walk9	=[	$walk9,	guard_walk10	] {ai_walk(2);};
void()	guard_walk10	=[	$walk10,	guard_walk11	] {ai_walk(4);};
void()	guard_walk11	=[	$walk11,	guard_walk12	] {ai_walk(4);};
void()	guard_walk12	=[	$walk12,	guard_walk13	] {ai_walk(1);};
void()	guard_walk13	=[	$walk13,	guard_walk14	] {ai_walk(2);};
void()	guard_walk14	=[	$walk14,	guard_walk15	] {ai_walk(3);};
void()	guard_walk15	=[	$walk15,	guard_walk16	] {ai_walk(4);};
void()	guard_walk16	=[	$walk16,	guard_walk17	] {ai_walk(2);};
void()	guard_walk17	=[	$walk17,	guard_walk18	] {ai_walk(2);};
void()	guard_walk18	=[	$walk18,	guard_walk19	] {ai_walk(4);};
void()	guard_walk19	=[	$walk19,	guard_walk20	] {ai_walk(4);};
void()	guard_walk20	=[	$walk20,	guard_walk21	] {ai_walk(3);};
void()	guard_walk21	=[	$walk21,	guard_walk22	] {ai_walk(1);};
void()	guard_walk22	=[	$walk22,	guard_walk23	] {ai_walk(2);};
void()	guard_walk23	=[	$walk23,	guard_walk24	] {ai_walk(2);};
void()	guard_walk24	=[	$walk24,	guard_walk25	] {ai_walk(1);};
void()	guard_walk25	=[	$walk25,	guard_walk26	] {ai_walk(2);};
void()	guard_walk26	=[	$walk26,	guard_walk27	] {ai_walk(4);};
void()	guard_walk27	=[	$walk27,	guard_walk28	] {ai_walk(4);};
void()	guard_walk28	=[	$walk28,	guard_walk29	] {ai_walk(1);};
void()	guard_walk29	=[	$walk29,	guard_walk30	] {ai_walk(2);};
void()	guard_walk30	=[	$walk30,	guard_walk31	] {ai_walk(3);};
void()	guard_walk31	=[	$walk31,	guard_walk32	] {ai_walk(4);};
void()	guard_walk32	=[	$walk32,	guard_walk1	] {ai_walk(2);};

void()	guard_run1	=[	$run1,		guard_run2	] {ai_run(18);self.duck = 0;setsize (self, '-16 -16 -24', '16 16 35');};
void()	guard_run2	=[	$run2,		guard_run3	] {ai_run(14);};
void()	guard_run3	=[	$run3,		guard_run4	] {ai_run(7);};
void()	guard_run4	=[	$run4,		guard_run5	] {ai_run(12);};
void()	guard_run5	=[	$run5,		guard_run6	] {ai_run(14);};
void()	guard_run6	=[	$run6,		guard_run7	] {ai_run(14);};
void()	guard_run7	=[	$run7,		guard_run8	] {ai_run(7);};
void()	guard_run8	=[	$run8,		guard_run9	] {ai_run(7);};
void()	guard_run9	=[	$run9,		guard_run1	] {ai_run(11);};

void()      guard_load1   =[    $load1,      guard_load2] {self.mp5clip = 30;};
void()      guard_load2   =[    $load2,      guard_load3] {};
void()      guard_load3   =[    $load3,      guard_load4] {};
void()      guard_load4   =[    $load4,      guard_load5] {};
void()      guard_load5   =[    $load5,      guard_load6] {};
void()      guard_load6   =[    $load6,      guard_load7] {};
void()      guard_load7   =[    $load7,      guard_load8] {};
void()      guard_load8   =[    $load8,      guard_load9] {};
void()      guard_load9   =[    $load9,      guard_load10] {};
void()      guard_load10   =[    $load10,      guard_load11] {};
void()      guard_load11   =[    $load11,      guard_load12] {};
void()      guard_load12   =[    $load12,      guard_load13] {};
void()      guard_load13   =[    $load13,      guard_load14] {};
void()      guard_load14   =[    $load14,      guard_run1] {sound(self,CHAN_WEAPON,"weapons/mp5in.wav",1,ATTN_NORM);};

void()      guard_firea1 = [ $firea1 , guard_firea2 ] 
{ 
 ai_face();
 guard_fire();
 if (self.mp5clip <= 0)
   {
     self.think = guard_load1;
   }

};

void()      guard_firea2 = [ $firea2 , guard_firea3 ] 
{ 
 ai_face();
 guard_fire();
 if (self.mp5clip <= 0)
   {
     self.think = guard_load1;
   }

};

void()      guard_firea3 = [ $firea3 , guard_firea4 ] 
{ 
 ai_face();
 guard_fire();
 if (self.mp5clip <= 0)
   {
     self.think = guard_load1;
   }

};

void()      guard_firea4 = [ $firea4 , guard_firea5 ] 
{ 
 ai_face();
 guard_fire();
 if (self.mp5clip <= 0)
   {
     self.think = guard_load1;
   }

};

void()      guard_firea5 = [ $firea5 , guard_firea6 ] 
{ 
 ai_face();
 guard_fire();
 if (self.mp5clip <= 0)
   {
     self.think = guard_load1;
   }

};

void()      guard_firea6 = [ $firea6 , guard_firea7 ] 
{ 
 ai_face();
 guard_fire();
 if (self.mp5clip <= 0)
   {
     self.think = guard_load1;
   }

};

void()      guard_firea7 = [ $firea7 , guard_firea8 ] 
{ 
 ai_face();
 guard_fire();
 if (self.mp5clip <= 0)
   {
     self.think = guard_load1;
   }

};

void()      guard_firea8 = [ $firea8 , guard_run1 ] 
{ 
 ai_face();
 guard_fire();
 if (self.mp5clip <= 0)
   {
     self.think = guard_load1;
   }

self.nextthink = time + 0.5;
SUB_CheckRefire (guard_firea1);
};


void() guard_drawb1;
void() guard_drawc1;

void()      guard_drawa1   =[    $drawa1,     guard_drawa2   ] 
{
 local float temp;

 temp = random();
 ai_face();
 if (temp < 0.25) 
  {
   self.think = guard_drawb1;
   self.nextthink = time + 0.06;
  }
 if ( (temp < 0.5) && (temp >= 0.25) )
  {
   self.think = guard_drawc1;
   self.nextthink = time + 0.06;
  }
 if (temp >= 0.5)
  { 
   self.think = guard_drawa2;
   self.nextthink = time + 0.06;
  }

};
void()      guard_drawa2   =[    $drawa2,     guard_drawa3   ] {ai_face();self.nextthink = time + 0.06;};
void()      guard_drawa3   =[    $drawa3,     guard_drawa4   ] {ai_face();self.nextthink = time + 0.06;};
void()      guard_drawa4   =[    $drawa4,     guard_drawa5   ] {ai_face();self.nextthink = time + 0.06;};
void()      guard_drawa5   =[    $drawa5,     guard_drawa6   ] {ai_face();self.nextthink = time + 0.06;};
void()      guard_drawa6   =[    $drawa6,     guard_drawa7   ] {ai_face();self.nextthink = time + 0.06;};
void()      guard_drawa7   =[    $drawa7,     guard_firea1   ] 
{
ai_face();
if (random() < 0.65)
 {
  if (random() < 0.5)
   {
    self.think = guard_strafeleft1;
   }
  else
   {
    self.think = guard_straferight1;
   }
 }
if (self.health <= 30)
 {
  if (random() < 0.75)
   {
    if (random() < 0.5)
     {
      self.think = guard_strafeleft1;
     }
    else
     {
      self.think = guard_straferight1;
     }
   }
 }
if (self.mp5clip <= 0)
 { 
  self.think = guard_load1;
 }

if ( ( (self.absmax_z - self.enemy.absmax_z) > -50) 
    && ( ( vlen(self.enemy.origin - self.origin) ) > 500) 
    && (self.firstgrenade != 23) )

{
  if (random () < 0.8)
   {
    self.think = guard_grenade1;
    self.attack_finished = time + 1.3;
    self.firstgrenade = 23;
   }
}   

};

/************************* END OF DRAWA  ************************/

void()      guard_fireb1         =[    $fireb1,     guard_fireb2   ] 
{ 
 ai_face();
 guard_fire();
 if (self.mp5clip <= 0)
   {
     self.think = guard_load1;
   }

};

void()      guard_fireb2         =[    $fireb2,     guard_run1     ] 
{ 
 ai_face();
 guard_fire();
 if (self.mp5clip <= 0)
   {
     self.think = guard_load1;
   }

self.nextthink = time + 0.5;
SUB_CheckRefire (guard_fireb1);
};

void()      guard_drawb1   =[    $drawb1,     guard_drawb2   ] {ai_face();self.nextthink = time + 0.06;};
void()      guard_drawb2   =[    $drawb2,     guard_drawb3   ] {ai_face();self.nextthink = time + 0.06;};
void()      guard_drawb3   =[    $drawb3,     guard_drawb4   ] {ai_face();self.nextthink = time + 0.06;};
void()      guard_drawb4   =[    $drawb4,     guard_drawb5   ] {ai_face();self.nextthink = time + 0.06;};
void()      guard_drawb5   =[    $drawb5,     guard_drawb6   ] {ai_face();self.nextthink = time + 0.06;};
void()      guard_drawb6   =[    $drawb6,     guard_drawb7   ] {ai_face();self.nextthink = time + 0.06;};
void()      guard_drawb7   =[    $drawb7,     guard_drawb8   ] {ai_face();self.nextthink = time + 0.06;};
void()      guard_drawb8   =[    $drawb8,     guard_drawb9   ] {ai_face();self.nextthink = time + 0.06;};
void()      guard_drawb9   =[    $drawb9,     guard_fireb1   ] 
{
  ai_face();

  if ( ( (self.absmax_z - self.enemy.absmax_z) > -50) 
    && ( ( vlen(self.enemy.origin - self.origin) ) > 500) 
    && (self.firstgrenade != 23) )
{
  if (random () < 0.7)
   {
    self.think = guard_grenade1;
    self.attack_finished = time + 1.3;
    self.firstgrenade = 23;
   }
}   

if (self.mp5clip <= 0)
 { 
  self.think = guard_load1;
 }

};

/************************** END OF DRAWB *******************************/

void()      guard_firec1         =[    $firec1,     guard_firec2   ] 
{ 
 ai_face();
 guard_fire();
 if (self.mp5clip <= 0)
   {
     self.think = guard_load1;
   }

};

void()      guard_firec2         =[    $firec2,     guard_firec3   ] 
{ 
 ai_face();
 guard_fire();
 if (self.mp5clip <= 0)
   {
     self.think = guard_load1;
   }

};

void()      guard_firec3         =[    $firec3,     guard_firec4   ] 
{ 
 ai_face();
 guard_fire();
 if (self.mp5clip <= 0)
   {
     self.think = guard_load1;
   }

};

void()      guard_firec4         =[    $firec4,     guard_firec5   ] 
{ 
 ai_face();
 guard_fire();
 if (self.mp5clip <= 0)
   {
     self.think = guard_load1;
   }

};

void()      guard_firec5         =[    $firec5,     guard_firec6   ] 
{ 
 ai_face();
 guard_fire();
 if (self.mp5clip <= 0)
   {
     self.think = guard_load1;
   }

};

void()      guard_firec6         =[    $firec6,     guard_firec7   ] 
{ 
 ai_face();
 guard_fire();
 if (self.mp5clip <= 0)
   {
     self.think = guard_load1;
   }

};

void()      guard_firec7         =[    $firec7,     guard_firec8   ] 
{ 
 ai_face();
 guard_fire();
 if (self.mp5clip <= 0)
   {
     self.think = guard_load1;
   }

};

void()      guard_firec8         =[    $firec8,     guard_firec9   ] 
{ 
 ai_face();
 guard_fire();
 if (self.mp5clip <= 0)
   {
     self.think = guard_load1;
   }

};

void()      guard_firec9         =[    $firec9,     guard_firec10   ] 
{ 
 ai_face();
 guard_fire();
 if (self.mp5clip <= 0)
   {
     self.think = guard_load1;
   }

};

void()      guard_firec10         =[    $firec10,     guard_firec11   ] 
{ 
 ai_face();
 guard_fire();
 if (self.mp5clip <= 0)
   {
     self.think = guard_load1;
   }

};

void()      guard_firec11         =[    $firec11,     guard_firec12   ] 
{ 
 ai_face();
 guard_fire();
 if (self.mp5clip <= 0)
   {
     self.think = guard_load1;
   }

};

void()      guard_firec12         =[    $firec12,     guard_firec13   ] 
{ 
 ai_face();
 guard_fire();
 if (self.mp5clip <= 0)
   {
     self.think = guard_load1;
   }

};

void()      guard_firec13         =[    $firec13,     guard_run1   ] 
{ 
 ai_face();
 guard_fire();
 if (self.mp5clip <= 0)
   {
     self.think = guard_load1;
   }

self.nextthink = time + 0.5;
SUB_CheckRefire (guard_firec1);
};




void()      guard_drawc1   =[    $drawc1,     guard_drawc2   ] {self.duck = 1;ai_face();self.nextthink = time + 0.06;};
void()      guard_drawc2   =[    $drawc2,     guard_drawc3   ] {ai_face();self.nextthink = time + 0.06;};
void()      guard_drawc3   =[    $drawc3,     guard_drawc4   ] {ai_face();self.nextthink = time + 0.06;};
void()      guard_drawc4   =[    $drawc4,     guard_drawc5   ] {ai_face();self.nextthink = time + 0.06;setsize (self, '-16 -16 -24', '16 16 32');};
void()      guard_drawc5   =[    $drawc5,     guard_drawc6   ] {ai_face();self.nextthink = time + 0.06;setsize (self, '-16 -16 -24', '16 16 30');};
void()      guard_drawc6   =[    $drawc6,     guard_drawc7   ] {ai_face();self.nextthink = time + 0.06;setsize (self, '-16 -16 -24', '16 16 28');};
void()      guard_drawc7   =[    $drawc7,     guard_drawc8   ] {ai_face();self.nextthink = time + 0.06;setsize (self, '-16 -16 -24', '16 16 24');};
void()      guard_drawc8   =[    $drawc8,     guard_drawc9   ] {ai_face();self.nextthink = time + 0.06;setsize (self, '-16 -16 -24', '16 16 22');};
void()      guard_drawc9   =[    $drawc9,     guard_firec1   ] 
{
  setsize (self, '-16 -16 -24', '16 16 18');
  ai_face();

  if ( ( (self.absmax_z - self.enemy.absmax_z) > -50) 
    && ( ( vlen(self.enemy.origin - self.origin) ) > 500) 
    && (self.firstgrenade != 23) )
{
  if (random () < 0.6)
   {
    self.think = guard_grenade1;
    self.attack_finished = time + 1.3;
    self.firstgrenade = 23;
   }
}   

if (self.mp5clip <= 0)
 { 
  self.think = guard_load1;
 }

};




void()	guard_paina1	=[	$paina1,		guard_paina2	] 
{
  if (self.health < 25)  
    self.skin = 1;
};
void()	guard_paina2	=[	$paina2,		guard_paina3	] {};
void()	guard_paina3	=[	$paina3,		guard_paina4	] {};
void()	guard_paina4	=[	$paina4,		guard_paina5	] {};
void()	guard_paina5	=[	$paina5,		guard_drawc1	] {};

void()	guard_painb1	=[	$painb1,	guard_painb2	] 
{
  if (self.health < 25)  
    self.skin = 1;
};
void()	guard_painb2	=[	$painb2,	guard_painb3	] {};
void()	guard_painb3	=[	$painb3,	guard_painb4	] {};
void()	guard_painb4	=[	$painb4,	guard_painb5	] {};
void()	guard_painb5	=[	$painb5,	guard_drawb1	] {};

void()	guard_painc1	=[	$painc1,	guard_painc2	] 
{
  if (self.health < 25)  
  self.skin = 1;
};
void()	guard_painc2	=[	$painc2,	guard_painc3	] {};
void()	guard_painc3	=[	$painc3,	guard_painc4	] {};
void()	guard_painc4	=[	$painc4,	guard_painc5	] {};
void()	guard_painc5	=[	$painc5,	guard_painc6	] {};
void()	guard_painc6	=[	$painc6,	guard_painc7	] {};
void()	guard_painc7	=[	$painc7,	guard_run1	] {};

void()	guard_paind1	=[	$paind1,	guard_paind2	] 
{
  if (self.health < 25)  
  self.skin = 1;
};
void()	guard_paind2	=[	$paind2,	guard_paind3	] {};
void()	guard_paind3	=[	$paind3,	guard_paind4	] {};
void()	guard_paind4	=[	$paind4,	guard_paind5	] {};
void()	guard_paind5	=[	$paind5,	guard_run1	] {};

void()	Guard_Melee =
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



void() guardFireGrenade =
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

void(entity attacker, float damage)	guard_pain =
{
	local float r;
	
	//if (self.pain_finished > time)
	//	return;

	r = random();

    if (self.duck == 1)
     {
          self.pain_finished = time + 0.1;
          guard_paina1 ();
     }
    else
     {
      if (r < 0.333)
	{
	//	self.pain_finished = time + 0.1;
		guard_painb1 ();
            sound (self, CHAN_VOICE, "soldier/pain1.wav", 1, ATTN_NORM);
	}
	if ( (r < 0.666) && (r >= 0.333) )
	{
	//	self.pain_finished = time + 0.1;
		guard_painc1 ();
      //  	sound (self, CHAN_VOICE, "soldier/pain2.wav", 1, ATTN_NORM);
	}
	else
	{
	//	self.pain_finished = time + 0.1;
		guard_paind1 ();
      //    sound (self, CHAN_VOICE, "soldier/pain2.wav", 1, ATTN_NORM);
	}
     }
};

/*
void(float shotcount, vector dir, vector spread) guardFire =
{
	local	vector direction;
	local	vector	src;
	
	makevectors(self.v_angle);

	src = self.origin + v_forward*10;
	src_z = self.absmin_z + self.size_z * 0.7;
      ClearMultiDamage ();
	while (shotcount > 0)
	{
		direction = dir + crandom()*spread_x*v_right + crandom()*spread_y*v_up;
            traceline (src, src + direction*2048, FALSE, self);
		if (trace_fraction != 1.0)
              if (trace_ent.classname != "player")
                {
                  return;
                }
              else
                {
			TraceAttack (4, direction); 
                }
		shotcount = shotcount - 1;
	}
      ApplyMultiDamage ();

};
*/

void(float damage, vector dir) guardFire =
{
	local	vector	src;
	
	makevectors(self.v_angle);

	src = self.origin + v_forward*10;
	src_z = self.absmin_z + self.size_z * 0.7;        
      traceline (src, src + dir * 1024, FALSE, self);
  	 if (trace_fraction != 1.0)
        {
         if (trace_ent.takedamage)      
           T_Damage (trace_ent, self, self, damage);
         else
          {
           WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
           WriteByte (MSG_BROADCAST,TE_GUNSHOT);
           WriteCoord (MSG_BROADCAST,trace_ent.origin_x);
           WriteCoord (MSG_BROADCAST,trace_ent.origin_y);
           WriteCoord (MSG_BROADCAST,trace_ent.origin_z);
           particle (trace_endpos,'3.000 2.000 7.000',192.000,TE_WIZSPIKE);
           particle (trace_endpos,'7.000 6.000 8.000',192.000,TE_WIZSPIKE);
           sound (self.enemy,CHAN_AUTO,"weapons/mp5ric1.wav",TRUE,ATTN_NORM);         
          }    
        }
};

void() guard_fire =
{
	local	vector	dir;
	local	entity	en;
	
	ai_face();
	
	sound (self, CHAN_WEAPON, "weapons/terrgun.wav", 1, ATTN_NORM);	

// fire somewhat behind the player, so a dodging player is harder to hit
	en = self.enemy;
	
	dir = (en.origin - '0 0 8') - en.velocity*0.2;
	dir = normalize (dir - self.origin);
	
	guardFire(12,dir);
        self.mp5clip = self.mp5clip - 1;
};

void()      guard_melee1 = [   $melee1,   guard_melee2 ] {ai_face();};
void()      guard_melee2 = [   $melee2,   guard_melee3 ] {ai_face();};
void()      guard_melee3 = [   $melee3,   guard_melee4 ] {ai_face();};
void()      guard_melee4 = [   $melee4,   guard_melee5 ] {ai_face();};
void()      guard_melee5 = [   $melee5,   guard_melee6 ] {ai_face();};
void()      guard_melee6 = [   $melee6,   guard_melee7 ] {ai_face();Guard_Melee ();};
void()      guard_melee7 = [   $melee7,   guard_melee8 ] {ai_face();Guard_Melee ();};
void()      guard_melee8 = [   $melee8,   guard_melee9 ] {ai_face();};
void()      guard_melee9 = [   $melee9,   guard_melee10 ] {ai_face();};
void()      guard_melee10 = [   $melee10,   guard_run1 ] {ai_face();};

void()	guard_died1	=[	$deathd1,	guard_died2	] {self.nextthink = time + 0.06;};
void()	guard_died2	=[	$deathd2,	guard_died3	] {self.nextthink = time + 0.06;};
void()	guard_died3	=[	$deathd3,	guard_died4	] 
{
  self.nextthink = time + 0.06;
  self.solid = SOLID_NOT;
  self.ammo_nails = ceil(self.mp5clip * 0.5);
  Drop_Clip();
};
void()	guard_died4	=[	$deathd4,	guard_died5	] 
{
  if (self.headshot == 1) 
  self.skin = 2;
  self.nextthink = time + 0.06;
};
void()	guard_died5	=[	$deathd5,	guard_died6	] {self.nextthink = time + 0.06;};
void()	guard_died6	=[	$deathd6,	guard_died7	] {self.nextthink = time + 0.06;};
void()	guard_died7	=[	$deathd7,	guard_died8	] {self.nextthink = time + 0.06;};
void()	guard_died8	=[	$deathd8,	guard_died9	] {self.nextthink = time + 0.06;};
void()	guard_died9	=[	$deathd9,	guard_died9	] {};


void()	guard_diea1	=[	$deatha1,	guard_diea2	] 
{
  if (self.headshot == 1) 
  self.skin = 2;
  self.nextthink = time + 0.06;
};
void()	guard_diea2	=[	$deatha2,	guard_diea3	] {self.nextthink = time + 0.06;};
void()	guard_diea3	=[	$deatha3,	guard_diea4	] 
{
  self.nextthink = time + 0.06;
  self.solid = SOLID_NOT;
  self.ammo_nails = ceil(self.mp5clip * 0.5);
  Drop_Clip();
};
void()	guard_diea4	=[	$deatha4,	guard_diea5	] {self.nextthink = time + 0.06;};
void()	guard_diea5	=[	$deatha5,	guard_diea6	] {self.nextthink = time + 0.06;};
void()	guard_diea6	=[	$deatha6,	guard_diea7	] {self.nextthink = time + 0.06;};
void()	guard_diea7	=[	$deatha7,	guard_diea8	] {self.nextthink = time + 0.06;};
void()	guard_diea8	=[	$deatha8,	guard_diea9	] {self.nextthink = time + 0.06;};
void()	guard_diea9	=[	$deatha9,	guard_diea10	] {self.nextthink = time + 0.06;};
void()	guard_diea10	=[	$deatha10,	guard_diea10	] {};


void()	guard_dieb1	=[	$deathb1,	guard_dieb2	] 
{
  if (self.headshot == 1) 
  self.skin = 2;
  self.nextthink = time + 0.06;
};
void()	guard_dieb2	=[	$deathb2,	guard_dieb3	] {self.nextthink = time + 0.06;};
void()	guard_dieb3	=[	$deathb3,	guard_dieb4	]
{
  self.nextthink = time + 0.06;
  self.solid = SOLID_NOT;
  self.ammo_nails = ceil(self.mp5clip * 0.5);
  Drop_Clip();
};
void()	guard_dieb4	=[	$deathb4,	guard_dieb5	] {self.nextthink = time + 0.06;};
void()	guard_dieb5	=[	$deathb5,	guard_dieb6	] {self.nextthink = time + 0.06;};
void()	guard_dieb6	=[	$deathb6,	guard_dieb7	] {self.nextthink = time + 0.06;};
void()	guard_dieb7	=[	$deathb7,	guard_dieb8	] {self.nextthink = time + 0.06;};
void()	guard_dieb8	=[	$deathb8,	guard_dieb9	] {self.nextthink = time + 0.06;};
void()	guard_dieb9	=[	$deathb9,	guard_dieb10	] {self.nextthink = time + 0.06;};
void()	guard_dieb10	=[	$deathb10,	guard_dieb11	] {self.nextthink = time + 0.06;};
void()	guard_dieb11	=[	$deathb11,	guard_dieb11	] {};

void()	guard_diec1	=[	$deathc1,	guard_diec2	] 
{
  if (self.headshot == 1) 
  self.skin = 2;
  self.nextthink = time + 0.06;
};
void()	guard_diec2	=[	$deathc2,	guard_diec3	] {self.nextthink = time + 0.06;};
void()	guard_diec3	=[	$deathc3,	guard_diec4	]
{
  self.nextthink = time + 0.06;
  self.solid = SOLID_NOT;
  self.ammo_nails = ceil(self.mp5clip * 0.5);
  Drop_Clip();
  ai_back(4);
};
void()	guard_diec4	=[	$deathc4,	guard_diec5	] {self.nextthink = time + 0.06;};
void()	guard_diec5	=[	$deathc5,	guard_diec6	] {self.nextthink = time + 0.06;};
void()	guard_diec6	=[	$deathc6,	guard_diec7	] {self.nextthink = time + 0.06;};
void()	guard_diec7	=[	$deathc7,	guard_diec8	] {self.nextthink = time + 0.06;};
void()	guard_diec8	=[	$deathc8,	guard_diec9	] {self.nextthink = time + 0.06;};
void()	guard_diec9	=[	$deathc9,	guard_diec10	] {self.nextthink = time + 0.06;};
void()	guard_diec10	=[	$deathc10,	guard_diec11	] {self.nextthink = time + 0.06;};
void()	guard_diec11	=[	$deathc11,	guard_diec12	] {self.nextthink = time + 0.06;};
void()	guard_diec12	=[	$deathc12,	guard_diec12	] {self.nextthink = time + 0.06;};


void() guard_die =
{

      local float temp;

/* check for gib
	if (self.health < -20)
	{
            sound (self,CHAN_VOICE,"player/udeath.wav",TRUE,ATTN_NORM);
            ThrowHead ("progs/h_guard.mdl",self.health);
            ThrowGib ("progs/gib1.mdl",self.health);
            ThrowGib ("progs/gib2.mdl",self.health);
            ThrowGib ("progs/gib3.mdl",self.health);
            return ;
	}

*/ 
      temp = random();
 
      if (self.duck == 1)
       {
		guard_diea1 ();
//            self.flags = self.flags + FL_ONGROUND;
       	sound (self, CHAN_VOICE, "player/death2.wav", 1, ATTN_NORM);     
       }
     else
      {
	if (temp < 0.333)
       {
		guard_dieb1 ();
       	sound (self, CHAN_VOICE, "player/death3.wav", 1, ATTN_NORM);
//            self.flags = 32;
//           self.velocity_z = self.velocity_z + 350;

       }
	if ( (temp < 0.666) && (temp >= 0.333) )
       {
		guard_diec1 ();
       	sound (self, CHAN_VOICE, "player/death2.wav", 1, ATTN_NORM);     
//            self.flags = 32;
//            self.velocity_z = self.velocity_z + 350;
       }
      if (temp >= 0.666)
       {
            guard_died1 ();
            sound (self, CHAN_VOICE, "player/death2.wav", 1 , ATTN_NORM);
       }
      }
};


/*QUAKED guard_army (1 0 0) (-16 -16 -24) (16 16 40) Ambush
*/

void() monster_enforcer =
{	
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model2 ("progs/guard.mdl");
//	precache_model ("progs/h_guard.mdl");
//	precache_model ("progs/gib1.mdl");
//	precache_model ("progs/gib2.mdl");
//	precache_model ("progs/gib3.mdl");

//    precache_sound ("soldier/death1.wav");
//	precache_sound ("soldier/idle.wav");
//	precache_sound ("soldier/pain1.wav");
//	precache_sound ("soldier/pain2.wav");
//	precache_sound ("soldier/sattck1.wav");
//	precache_sound ("soldier/sight1.wav");

//	precache_sound ("player/udeath.wav");		// gib death
      precache_sound2 ("weapons/terrgun.wav");


	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;


	setmodel (self, "progs/guard.mdl");

	setsize (self, '-16 -16 -24', '16 16 35');
	self.health = 80;
        self.mp5clip = 30;
	self.th_stand = guard_stand1;
	self.th_walk = guard_walk1;
	self.th_run = guard_run1;
	self.th_missile = guard_drawa1;
        self.th_melee = guard_melee1;
	self.th_pain = guard_pain;
	self.th_die = guard_die;

	walkmonster_start ();
};


