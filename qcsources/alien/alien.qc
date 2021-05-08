/*
======================================
		ALIEN.QC
E-Mail mike.clark@cheerful.com
======================================
*/

$cd alien/progs/alien
$scale	1.0
$origin 0 0 24
$base base
$skin skin 0

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9
$frame stand10 stand11 stand12 stand13

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8

$frame run1 run2 run3 run4 run5 run6

$frame leap1 leap2 leap3 leap4 leap5 leap6 leap7 leap8 leap9 leap10
$frame leap11 leap12

$frame pain1 pain2 pain3 pain4 pain5 pain6

$frame death1 death2 death3 death4 death5 death6 death7 death8 death9

$frame attacka1 attacka2 attacka3 attacka4 attacka5 attacka6 attacka7 attacka8
$frame attacka9 attacka10 attacka11 attacka12 attacka13 attacka14 attacka15

/*
==========
Spawnflags
==========
*/
float Posion = 2;				//Posion on/off
float PosionOnce = 4;			//PosionOnce on/off
float Regenerate = 8;			//Regeneration on/off 
/*
======
Fields
======
*/
.float MaxHealth;				//For Regeneration
.float Rate;					//For Regeneration
.float Dmg;						//For Posion

/*
=========
Functions
=========
*/
void()AlienMissile;					// Missile code
void()AlienRegenerate;				// regeneration code
void(float side)	Alien_Melee;	// melee code
void() SkinChange;					// "pain skin"
void() alien_JumpTouch;				// jump
float()AL_Scent;					// track
void() AL_CheckAttack;				// Check attack status
void() Check_AlienMissile;			// Check weather to launch missile attack or not;

void()	alien_stand1	=[	$stand1,	alien_stand2	] {ai_stand();};
void()	alien_stand2	=[	$stand2,	alien_stand3	] {ai_stand();};
void()	alien_stand3	=[	$stand3,	alien_stand4	] {ai_stand();};
void()	alien_stand4	=[	$stand4,	alien_stand5	] {ai_stand();};
void()	alien_stand5	=[	$stand5,	alien_stand6	] {ai_stand();};
void()	alien_stand6	=[	$stand6,	alien_stand7	] {ai_stand();};
void()	alien_stand7	=[	$stand7,	alien_stand8	] {ai_stand();};
void()	alien_stand8	=[	$stand8,	alien_stand9	] {ai_stand();};
void()	alien_stand9	=[	$stand9,	alien_stand10	] {ai_stand();};
void()	alien_stand10	=[	$stand10,	alien_stand11	] {ai_stand();};
void()	alien_stand11	=[	$stand11,	alien_stand12	] {ai_stand();};
void()	alien_stand12	=[	$stand12,	alien_stand13	] {ai_stand();};
void()	alien_stand13	=[	$stand13,	alien_stand1	] {ai_stand();};

void()	alien_walk1	=[	$walk1,		alien_walk2	] {
if (random() < 0.2)
    sound (self, CHAN_VOICE, "alien/idle1.wav", 1, ATTN_IDLE);
ai_walk(8);
};

void()	alien_walk2	=[	$walk2,		alien_walk3	] {ai_walk(6);};
void()	alien_walk3	=[	$walk3,		alien_walk4	] {ai_walk(6);};
void()	alien_walk4	=[	$walk4,		alien_walk5	] {ai_walk(7);};
void()	alien_walk5	=[	$walk5,		alien_walk6	] {ai_walk(4);};
void()	alien_walk6	=[	$walk6,		alien_walk7	] {ai_walk(6);};
void()	alien_walk7	=[	$walk7,		alien_walk8	] {ai_walk(10);};
void()	alien_walk8	=[	$walk8,		alien_walk1	] {ai_walk(10);};

void()	alien_run1	=[	$run1,		alien_run2	] {
if (random() < 0.2)
    sound (self, CHAN_VOICE, "alien/idle1.wav", 1, ATTN_IDLE);
ai_run(10);SkinChange();};
void()	alien_run2	=[	$run2,		alien_run3	] {ai_run(15);};
void()	alien_run3	=[	$run3,		alien_run4	] {ai_run(36);};
void()	alien_run4	=[	$run4,		alien_run5	] {ai_run(20);};
void()	alien_run5	=[	$run5,		alien_run6	] {ai_run(15);};
void()	alien_jump1;
void()	alien_run6	=[	$run6,		alien_run1	]
{
	ai_run(36);
	if (self.waterlevel == 1)
	{
		if (random() > 0.8)
			self.think = alien_jump1;
	}
};

void()	alien_jump1	=[	$leap1,		alien_jump2	] {ai_face();};
void()	alien_jump2	=[	$leap2,		alien_jump3	] {ai_face();};
void()	alien_jump3	=[	$leap3,		alien_jump4	] {ai_face();};
void()	alien_jump4	=[	$leap4,		alien_jump5	]
{
   local vector dir;
   local float dist;

	ai_face();
	
	self.touch = alien_JumpTouch;
	makevectors (self.angles);
	self.origin_z = self.origin_z + 1;
   if (self.enemy.origin_z > self.origin_z + 40)
   {

      if ( infront(self.enemy) || self.waterlevel == 1 )
      {
         dir = normalize(self.enemy.origin - self.origin);
         dist = vlen(self.enemy.origin - self.origin);
         self.velocity = dir * dist;
      }
      else
         self.velocity = v_forward * 150;

      dist = self.enemy.origin_z - self.origin_z;

      dist = dist - 237;
      self.velocity_z = 714 + dist;

   }
   else
   {
      if (self.enemy.origin_z < self.origin_z - 40)
         self.velocity = v_forward * 150;
      else
         self.velocity = v_forward * 600;

      traceline( self.origin - '0 0 16',
                 (self.origin - '0 0 16') + v_forward*150, TRUE, self);

      if (trace_fraction < 1)
      {
         self.velocity = v_forward * 110;
         self.velocity_z = 250 * (random() + 1);
      }
      else
         self.velocity_z = 250;
   }


   if (self.flags & FL_ONGROUND)
		self.flags = self.flags - FL_ONGROUND;

};

void()	alien_jump5	=[	$leap5,		alien_jump6	] {ai_face();};
void()	alien_jump6	=[	$leap6,		alien_jump7	] {ai_face();};
void()	alien_jump7	=[	$leap7,		alien_jump8	] {ai_face();};
void()	alien_jump8	=[ 	$leap8,		alien_jump9	] {ai_face();};
void()	alien_jump9	=[ 	$leap9,		alien_jump10	] {ai_face();};
void()	alien_jump10	=[ 	$leap10,	alien_jump1	] {
self.nextthink = time + 3;
};

void()	alien_jump11	=[ 	$leap11,	alien_jump12	] {};
void()	alien_jump12	=[ 	$leap12,	alien_run1	] {};

void()	alien_atta1	=[	$attacka1,		alien_atta2	] {ai_charge(8);AL_CheckAttack();};
void()	alien_atta2	=[	$attacka2,		alien_atta3	] {ai_charge(0);};
void()	alien_atta3	=[	$attacka3,		alien_atta4	] {ai_charge(0);};
void()	alien_atta4	=[	$attacka4,		alien_atta5	] {ai_charge(2);};
void()	alien_atta5	=[	$attacka5,		alien_atta6	] {ai_charge(4);Alien_Melee();};
void()	alien_atta6	=[	$attacka6,		alien_atta7	] {ai_charge(2);Alien_Melee();};
void()	alien_atta7	=[	$attacka7,		alien_atta8	] {ai_charge(12);AlienRegenerate();};
void()	alien_atta8	=[	$attacka8,		alien_atta9	] {ai_charge(16);};
void()	alien_atta9	=[	$attacka9,		alien_atta10] {ai_charge(8);};
void()	alien_atta10	=[	$attacka10,		alien_atta11] {ai_charge(4);};
void()	alien_atta11	=[	$attacka11,		alien_atta12] {ai_charge(4);};
void()	alien_atta12	=[	$attacka12,		alien_atta13] {ai_charge(10);};
void()	alien_atta13	=[	$attacka13,		alien_atta14] {ai_charge(16);};
void()	alien_atta14	=[	$attacka14,		alien_atta15] {ai_charge(8);};
void()	alien_atta15	=[	$attacka15,		alien_run1] {ai_charge(8);};

void()	alien_pain1	=[	$pain1,		alien_pain2	] {};
void()	alien_pain2	=[	$pain2,		alien_pain3	] {};
void()	alien_pain3	=[	$pain3,		alien_pain4	] {ai_painforward (13);};
void()	alien_pain4	=[	$pain4,		alien_pain5	] {ai_painforward (9);};
void()	alien_pain5	=[	$pain5,		alien_pain6	] {};
void()	alien_pain6	=[	$pain6,		alien_run1	] {};

void(entity attacker, float damage)	alien_pain =
{
	if (self.touch == alien_JumpTouch)
		return;

	if (self.pain_finished > time)
		return;

	self.pain_finished = time + 1;
    sound (self, CHAN_VOICE, "alien/dpain1.wav", 1, ATTN_NORM);

	if (random()*200 > damage)
		return;		// didn't flinch
		
	alien_pain1 ();
};
	
void()	alien_die1		=[	$death1,		alien_die2	] {
sound (self, CHAN_VOICE, "alien/ddeath.wav", 1, ATTN_NORM);};
void()	alien_die2		=[	$death2,		alien_die3	] {};
void()	alien_die3		=[	$death3,		alien_die4	] {};
void()	alien_die4		=[	$death4,		alien_die5	] {};
void()	alien_die5		=[	$death5,		alien_die6	] {};
void()	alien_die6		=[	$death6,		alien_die7	]
{self.solid = SOLID_NOT;};
void()	alien_die7		=[	$death7,		alien_die8	] {};
void()	alien_die8		=[	$death8,		alien_die9	] {};
void()	alien_die9		=[	$death9,		alien_die9 ] {};

void() alien_die =
{
// check for gib
	if (self.health < -30)
	{
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		ThrowHead ("progs/h_alien.mdl", self.health);
		ThrowGib ("progs/gib1.mdl", self.health);
		ThrowGib ("progs/gib1.mdl", self.health);
		ThrowGib ("progs/gib1.mdl", self.health);
		return;
	}

// death
	alien_die1 ();
};

void() Alien_MeleeAttack =
{
	alien_atta1 ();
};
/*
==============
Set-Up Monster
==============
*/

/*QUAKED monster_alien (1 0 0) (-32 -32 -24) (32 32 64) Ambush Posion PosionOnce Regenerate
Alien 500 HP. Attacks with jump, melee, missile and poison.
Regenerates HP.
*FLAGS*
Ambush: you know what this means
Posion: Toggles posion attack (check for on)
PosionOnce: Prevents posion reinfecting (check for on)
Regenerate: Toggles regeneration (check for on)
*FIELDS*
MaxHealth: Sets maximum ammount of health the alien can regenerate to (defaults to 500). Setting this to zero(0) stops regeneration. Only works with regeneration flag set.
Rate: Sets the rate of regeneration. Defaults to 20.
Dmg: Sets ammount of posion damage suffered. Defaults to 1. No effect if posion flag not set.
*/

void() monster_alien =
{
	if (deathmatch)
	{
		remove(self);	// Remove in deathmatch
		return;
	}
/*
	==================
	Set Field Defaults
	==================
*/
	if (!self.MaxHealth)
		self.MaxHealth = 500;
	if (!self.Rate)
		self.Rate = 20;
	if (!self.Dmg)
		self.Dmg = 1;
//End

	precache_model ("progs/alien.mdl");
	precache_model ("progs/h_alien.mdl");
	precache_model ("progs/a_spike.mdl");
	
	precache_sound ("alien/ddeath.wav");
	precache_sound ("alien/dhit2.wav");
	precache_sound ("alien/dpain1.wav");
	precache_sound ("alien/idle1.wav");
	precache_sound ("alien/sight2.wav");
	precache_sound ("alien/missile.wav");
	
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/alien.mdl");

	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.health = 500;

	self.th_stand = alien_stand1;
	self.th_walk = alien_walk1;
	self.th_run = alien_run1;
	self.th_die = alien_die;
	self.th_melee = Alien_MeleeAttack;		// Slashing attack
	self.th_missile = alien_jump1;		// Missile attack
	self.th_pain = alien_pain;
	
	walkmonster_start();
};

/*
===================
posion
===================
*/
void() OnPoisonThink =
{
	local	float	ldmg;
	if (self.owner.waterlevel >= 1)			//Stop if ent is in water
	{
		remove(self);
		return;
	}
	ldmg = self.dmg;
	T_Damage (self.owner, self, self, 1);	//Otherwise damage ent
	self.nextthink = time + 1;
};      

void(entity ent) GetPoisoned =
{
	if (self.spawnflags && PosionOnce)
	{
		if (ent.poisoned == TRUE)
		    	return;
			ent.poisoned = TRUE;
	}
	local   entity poison;
	poison		= spawn (); 
	poison.owner	= ent; 
	poison.movetype = MOVETYPE_NONE;
	poison.solid 	= SOLID_NOT;
	setmodel (poison, "");
	setsize (poison, '0 0 0', '0 0 0');             
	setorigin (poison, '0 0 0');
	poison.nextthink = time + 1;
	poison.think = OnPoisonThink;
};
/*
==============
CheckalienJump

==============
*/
float()	CheckalienJump =
{
	local	vector	dist;
	local	float	d;

	if (random() < 0.4)
		return TRUE;
	if (self.origin_z + self.mins_z > self.enemy.origin_z + self.enemy.mins_z
	+ 0.75 * self.enemy.size_z)
		return FALSE;
		
	if (self.origin_z + self.maxs_z < self.enemy.origin_z + self.enemy.mins_z
	+ 0.25 * self.enemy.size_z)
		return FALSE;
		
	dist = self.enemy.origin - self.origin;
	dist_z = 0;
	
	d = vlen(dist);
	
	if (d < 100)
		return FALSE;
		
	if (d > 200)
	{
		if (random() < 0.9)
			return FALSE;
	}
		
	return TRUE;
};

//===========================================
void()	alien_JumpTouch =
{
	local	float	ldmg;

	if (self.health <= 0)
		return;
		
	if (other.takedamage)
	{
		if ( vlen(self.velocity) > 400 )
		{
			ldmg = 40 + 10*random();
			T_Damage (other, self, self, ldmg);
			if (self.enemy.classname == "player")
				{
					if (self.spawnflags && Posion)
					{	
						GetPoisoned(self.enemy);
						centerprint (self.enemy, "You have been infected by poison\nGet to water!!!");
						stuffcmd (self.enemy, "bf\n");
					}
				}

		}
	}

	if (!checkbottom(self))
	{
		if (self.flags & FL_ONGROUND)
		{	// jump randomly to not get hung up
//dprint ("popjump\n");
	self.touch = SUB_Null;
	self.think = alien_jump1;
	self.nextthink = time + 0.1;

//			self.velocity_x = (random() - 0.5) * 600;
//			self.velocity_y = (random() - 0.5) * 600;
//			self.velocity_z = 200;
//			self.flags = self.flags - FL_ONGROUND;
		}
		return;	// not on ground yet
	}

	self.touch = SUB_Null;
	self.think = alien_jump11;
	self.nextthink = time + 0.1;
};
/*
=====
Melee
=====
*/
void(float side)	Alien_Melee =
{
	local	float		ldmg;
	local vector	delta;

	ai_face ();
	walkmove (self.ideal_yaw, 12);	// allow a little closing

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 100)
		return;
	if (!CanDamage (self.enemy, self))
		return;
		
    sound (self, CHAN_WEAPON, "alien/dhit2.wav", 1, ATTN_NORM);
	ldmg = 10 + 5*random();
	T_Damage (self.enemy, self, self, ldmg);
	if (self.enemy.classname == "player")
	{
		if (self.spawnflags && Posion)
		{	
			GetPoisoned(self.enemy);
			centerprint (self.enemy, "You have been infected by poison\nGet to water!!!");
			stuffcmd (self.enemy, "bf\n");
		}
	}
	makevectors (self.angles);
};

/*
==========
Regenerate
==========
*/
void()AlienRegenerate=
{
	if (self.health >= self.MaxHealth)				// allready has MaxHealth.
		return;
	if (self.spawnflags && Regenerate)
		return;
		{
			self.health = self.health + self.Rate;	// add Health & record new total
			self.nextthink = time + 0.5;
			SkinChange();				// check if skin should change
			self.think = AlienRegenerate;
			alien_run1 ();
		}
};

/*
===========
Skin Change
===========
*/
void() SkinChange =
{
	if (self.health <= 200)
	{
	self.skin = 1;
	return;
	}
	else
	{
	self.skin = 0;
	return;
	}
};
/*
==================
Check AlienMissile
==================
*/
void() Check_AlienMissile =
{
	local vector len;
	len = self.origin - self.enemy.origin;
	traceline (self.origin, self.enemy.origin, FALSE, world);
	if (trace_fraction == 1)
	{
		AlienMissile();
	}
	return;
};
/*
=============
Check Attack
=============
*/
void() AL_CheckAttack =

{
	local float dist;
	dist = vlen(self.enemy.origin - self.origin);
	
	if (dist <= 30)	Alien_MeleeAttack();
		{
			if (dist <= 240)
				if (dist < 35)
				{
					if (random() > 0.3)	Check_AlienMissile();
				}
		}
};
/*
=====================================
AlienMissile
======================================
*/
void() AlienMissileTouch;
void() AlienMissile =
{
	local	entity 	missile;
	local	vector	dir;
	local	float		dist, flytime;

	dir = normalize((self.enemy.origin + '0 0 10') - self.origin);
	dist = vlen (self.enemy.origin - self.origin);
	flytime = dist * 0.002;
	if (flytime < 0.1)
		flytime = 0.1;

	self.effects = self.effects | EF_MUZZLEFLASH;
	sound (self, CHAN_WEAPON, "alien/missile.wav", 1, ATTN_NORM);

	missile = spawn ();
	missile.owner = self;

	missile.solid = SOLID_BBOX;
	missile.movetype = MOVETYPE_FLYMISSILE;
	setmodel (missile, "progs/a_spike.mdl");

	setsize (missile, '0 0 0', '0 0 0');		

	missile.origin = self.origin + '0 0 10';
	missile.velocity = dir * 300;						//Set missile speed
	missile.avelocity = '300 300 300';
	missile.nextthink = flytime + time;
	missile.think = MissileTarget;
	missile.enemy = self.enemy;
	missile.touch = AlienMissileTouch;
};
vector (vector org, float misspeed) MissileTarget =
{
	local		float		dist;
	local		float		Mistime;
	local		vector	move;
	local		vector	spot;
	
	dist		= vlen(self.enemy.origin - org);
	Mistime	= dist / misspeed;
	move		= self.enemy.velocity;
	move_z	= 0;
	spot		= self.enemy.origin + Mistime * move;
	return	spot;
};
void() AlienMissileTouch =
{
	if (other == self.owner)
		return;		// don't explode on owner

	if (other.classname == "monster_zombie")
	T_Damage (other, self, self, 55);	
	T_RadiusDamage (self, self.owner, 20, world);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	setmodel (self, "progs/s_explod.spr");
	self.solid = SOLID_NOT;
	s_explode1 ();
};
/*
=================================================================
The following has been added to client.qc
if (attacker.classname == "monster_alien")
	bprint (" tasted an alien's posion\n");
=================================================================
*/
//==========================END OF FILE==========================
