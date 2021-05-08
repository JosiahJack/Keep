/*
============================================================================

Troglodyte

============================================================================
*/

$cd /progs/troglodyte
$origin 0 0 24
$base wizbase	
$skin wizbase

$frame float1 float2 float3 float4 float5 float6 float7

$frame sonicboom1 sonicboom2 sonicboom3 sonicboom4 sonicboom5 sonicboom6
$frame sonicboom7 sonicboom8 sonicboom9 sonicboom10 sonicboom11
$frame sonicboom12 sonicboom13 sonicboom14 sonicboom15

$frame fireball1 fireball2 fireball3 fireball4 fireball5 fireball6 fireball7

$frame pain1 pain2 pain3 pain4 pain5 pain6

$frame death1 death2 death3 death4 death5 death6 death7 death8 death9
$frame death10 death11 death12 death13 death14 death15 death16 death17

void() Trog_FireBall;
void() StartTrogMagic;
void() Trog_idlesound;
float() TrogAttackFinished;


// ** Mutual exclusion for trog magic attack so that we
//    don't overflow space!
float TMAGIC_DONE = 1;


void()	trog_stand1	=[	$float1,		trog_stand2	] {ai_stand(); Trog_idlesound(); setorigin(self, self.origin - '0 0 2'); };
void()	trog_stand2	=[	$float2,		trog_stand3	] {ai_stand(); setorigin(self, self.origin - '0 0 2'); };
void()	trog_stand3	=[	$float3,		trog_stand4	] {ai_stand(); setorigin(self, self.origin - '0 0 2'); };
void()	trog_stand4	=[	$float4,		trog_stand5	] {ai_stand(); setorigin(self, self.origin + '0 0 2'); };
void()	trog_stand5	=[	$float5,		trog_stand6	] {ai_stand(); setorigin(self, self.origin + '0 0 2'); };
void()	trog_stand6	=[	$float6,		trog_stand7	] {ai_stand(); setorigin(self, self.origin + '0 0 2'); };
void()	trog_stand7	=[	$float7,		trog_stand1	] {ai_stand();};

void()	trog_walk1	=[	$float1,		trog_walk2	] {ai_walk(8);
Trog_idlesound(); /*setorigin(self, self.origin + '0 0 2');*/ };
void()	trog_walk2	=[	$float2,		trog_walk3	] {ai_walk(8); /*setorigin(self, self.origin + '0 0 2');*/ };
void()	trog_walk3	=[	$float3,		trog_walk4	] {ai_walk(8); /*setorigin(self, self.origin + '0 0 2');*/ };
void()	trog_walk4	=[	$float4,		trog_walk5	] {ai_walk(8); /*setorigin(self, self.origin - '0 0 2');*/ };
void()	trog_walk5	=[	$float5,		trog_walk6	] {ai_walk(8); /*setorigin(self, self.origin - '0 0 2');*/ };
void()	trog_walk6	=[	$float6,		trog_walk7	] {ai_walk(8); /*setorigin(self, self.origin - '0 0 2');*/ };
void()	trog_walk7	=[	$float7,		trog_walk1	] {ai_walk(8);};

/******************************************************/
/*  Teleport defense mechanism				*/
/*  DHM - 3/12/97							*/
/******************************************************/
float(vector tspot) Checkspot =
{
	if (pointcontents(tspot) != CONTENT_EMPTY)
		return FALSE;
	if (pointcontents(tspot + '24 0 0') != CONTENT_EMPTY)
		return FALSE;
	if (pointcontents(tspot - '24 0 0') != CONTENT_EMPTY)
		return FALSE;
	if (pointcontents(tspot + '0 24 0') != CONTENT_EMPTY)
		return FALSE;
	if (pointcontents(tspot - '0 24 0') != CONTENT_EMPTY)
		return FALSE;
	if (pointcontents(tspot + '0 0 32') != CONTENT_EMPTY)
		return FALSE;
	if (pointcontents(tspot - '0 0 12') != CONTENT_EMPTY)
		return FALSE;

	return TRUE;
};

void() tele_attack =
{
local vector	tspot, tline;

	//dprint("tele_attack!\n");
	tline = self.enemy.origin - self.origin;

	if (vlen(tline) < 100)
		return;

	tline = normalize(tline);
	tspot = self.enemy.origin + (tline * 70);
	if (!Checkspot(tspot))
	{
		tspot = self.enemy.origin - (tline * 70);
		if (!Checkspot(tspot))
			return;
	}

	spawn_tfog (self.origin);
	spawn_tfog (tspot);
	//spawn_tdeath (tspot, self);

	self.angles_y = vectoyaw(tline);
	setorigin (self, tspot + '0 0 5');
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	self.super_time = time + 2;
};


void() check_tele =
{
local entity head;

	if (!self.enemy)
		return;
	if (self.enemy.health <= 0)
		return;
	if (self.super_time > time)
		return;

	head = findradius(self.origin, 150);
	
	while (head)
	{
		if (head.owner == self.enemy)
		{
			tele_attack();
			return;
		}
		head = head.chain;
	}
};


void()	trog_side1	=[	$float1,		trog_side2	] {ai_run(8);
Trog_idlesound(); check_tele(); };
void()	trog_side2	=[	$float2,		trog_side3	] {ai_run(8); /*setorigin(self, self.origin - '0 0 2');*/ };
void()	trog_side3	=[	$float3,		trog_side4	] {ai_run(8); /*setorigin(self, self.origin - '0 0 2');*/ check_tele(); };
void()	trog_side4	=[	$float4,		trog_side5	] {ai_run(8); /*setorigin(self, self.origin - '0 0 2');*/ };
void()	trog_side5	=[	$float5,		trog_side6	] {ai_run(8); /*setorigin(self, self.origin + '0 0 2');*/ check_tele(); };
void()	trog_side6	=[	$float6,		trog_side7	] {ai_run(8); /*setorigin(self, self.origin + '0 0 2');*/ };
void()	trog_side7	=[	$float7,		trog_side1	] {ai_run(8); /*setorigin(self, self.origin + '0 0 2');*/ check_tele(); };

void()	trog_run1	=[	$float1,		trog_run2	] {ai_run(16);
Trog_idlesound(); /*setorigin(self, self.origin - '0 0 2');*/ check_tele(); };
void()	trog_run2	=[	$float2,		trog_run3	] {ai_run(16); /*setorigin(self, self.origin - '0 0 2');*/ };
void()	trog_run3	=[	$float3,		trog_run4	] {ai_run(16); /*setorigin(self, self.origin - '0 0 2');*/ check_tele(); };
void()	trog_run4	=[	$float4,		trog_run5	] {ai_run(16); /*setorigin(self, self.origin + '0 0 2');*/ };
void()	trog_run5	=[	$float5,		trog_run6	] {ai_run(16); /*setorigin(self, self.origin + '0 0 2');*/ check_tele(); };
void()	trog_run6	=[	$float6,		trog_run7	] {ai_run(16); /*setorigin(self, self.origin + '0 0 2');*/ };
void()	trog_run7	=[	$float7,		trog_run1	] {ai_run(16); check_tele(); };

void()	trog_fast1	=[	$fireball1,		trog_fast2	] {ai_face();};
void()	trog_fast2	=[	$fireball2,		trog_fast3	] {ai_face();};
void()	trog_fast3	=[	$fireball3,		trog_fast4	] {ai_face();};
void()	trog_fast4	=[	$fireball4,		trog_fast5	] {ai_face();};
void()	trog_fast5	=[	$fireball5,		trog_fast6	] {ai_face();};
void()	trog_fast6	=[	$fireball5,		trog_fast7	] {ai_face();Trog_FireBall();};
void()	trog_fast7	=[	$fireball4,		trog_fast8	] {ai_face();};
void()	trog_fast8	=[	$fireball3,		trog_fast9	] {ai_face();};
void()	trog_fast9	=[	$fireball2,		trog_fast10	] {ai_face();};
void()	trog_fast10	=[	$fireball1,		trog_run1	] {ai_face();SUB_AttackFinished(2);TrogAttackFinished();};

void()	trog_sboom1	=[	$sonicboom1,	trog_sboom2	] {ai_face();};
void()	trog_sboom2	=[	$sonicboom2,	trog_sboom3	] {ai_face();};
void()	trog_sboom3	=[	$sonicboom3,	trog_sboom4	] {ai_face();};
void()	trog_sboom4	=[	$sonicboom4,	trog_sboom5	] {ai_face(); StartTrogMagic();};
void()	trog_sboom5	=[	$sonicboom5,	trog_sboom6	] {ai_face();};
void()	trog_sboom6	=[	$sonicboom6,	trog_sboom7	] {ai_face();};
void()	trog_sboom7	=[	$sonicboom7,	trog_sboom8	] {ai_face();};
void()	trog_sboom8	=[	$sonicboom8,	trog_sboom9	] {ai_face();};
void()	trog_sboom9	=[	$sonicboom9,	trog_sboom10] {ai_face();};
void()	trog_sboom10=[	$sonicboom10,	trog_sboom11] {ai_face();};
void()	trog_sboom11=[	$sonicboom11,	trog_sboom12] {ai_face();};
void()	trog_sboom12=[	$sonicboom12,	trog_sboom13] {ai_face();};
void()	trog_sboom13=[	$sonicboom13,	trog_sboom14] {ai_face();};
void()	trog_sboom14=[	$sonicboom14,	trog_sboom15] {ai_face();};
void()	trog_sboom15=[	$sonicboom15,  trog_run1 ] {ai_face();SUB_AttackFinished(2);TrogAttackFinished();};


void()	trog_pain1	=[	$pain1,		trog_pain2	]{setorigin(self, self.origin + '0 0 2'); };
void()	trog_pain2	=[	$pain2,		trog_pain3	] {setorigin(self, self.origin + '0 0 2'); };
void()	trog_pain3	=[	$pain3,		trog_pain4	] {setorigin(self, self.origin + '0 0 2'); };
void()	trog_pain4	=[	$pain4,		trog_pain5	] {setorigin(self, self.origin - '0 0 2'); };
void()	trog_pain5	=[	$pain5,		trog_pain6	] {setorigin(self, self.origin - '0 0 2'); };
void()	trog_pain6	=[	$pain6,		trog_run1	] {self.pain_finished = 1; setorigin(self, self.origin - '0 0 2'); };

void()	trog_death1	=[	$death1,		trog_death2	] {
self.velocity_x = -200 + 400*random();
self.velocity_y = -200 + 400*random();
self.velocity_z = 300 + 100*random();
self.flags = self.flags - (self.flags & FL_ONGROUND);
if (random() < 0.5)
   sound (self, CHAN_VOICE, "trog/tdeath1.wav", 1, ATTN_NORM);
else
   sound (self, CHAN_VOICE, "trog/tdeath2.wav", 1, ATTN_NORM);
};
void()	trog_death2	=[	$death2,		trog_death3	] {};
void()	trog_death3	=[	$death3,		trog_death4	]{self.solid = SOLID_NOT;};
void()	trog_death4	=[	$death4,		trog_death5	] {};
void()	trog_death5	=[	$death5,		trog_death6	] {};
void()	trog_death6	=[	$death6,		trog_death7	] {};
void()	trog_death7	=[	$death7,		trog_death8	] {};
void()	trog_death8	=[	$death8,		trog_death9	] {};
void()	trog_death9	=[	$death9,		trog_death10] {};
void()	trog_death10=[	$death10,		trog_death11] {};
void()	trog_death11=[	$death11,		trog_death12] {};
void()	trog_death12=[	$death12,		trog_death13] {};
void()	trog_death13=[	$death13,		trog_death14] {};
void()	trog_death14=[	$death14,		trog_death15] {};
void()	trog_death15=[	$death15,		trog_death16] {};
void()	trog_death16=[	$death16,		trog_death17] {};
void()	trog_death17=[	$death17,		trog_death17] {};

// ------------------------------
void()	trog_magic1	=[	0,		trog_magic2	] {self.effects = self.effects | EF_MUZZLEFLASH;};
void()	trog_magic2	=[	1,		trog_magic3	] {};
void()	trog_magic3	=[	2,		trog_magic4	] {};
void()	trog_magic4	=[	3,		trog_magic5	] {self.effects = self.effects | EF_MUZZLEFLASH;};
void()	trog_magic5	=[	4,		trog_magic6	] {};
void()	trog_magic6	=[	5,		trog_magic7	] {};
void()	trog_magic7	=[	6,		trog_magic8	] {self.effects = self.effects | EF_MUZZLEFLASH;};
void()	trog_magic8	=[	7,		trog_magic9	] {};
void()	trog_magic9	=[	8,		SUB_Remove	] {};


void() Trog_Die =
{
// check for gib
	if (self.health < -40)
	{
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		ThrowHead ("progs/h_trog.mdl", self.health, self.dest);
		ThrowGib ("progs/gib2.mdl", self.health, self.dest);
		ThrowGib ("progs/gib2.mdl", self.health, self.dest);
		ThrowGib ("progs/gib2.mdl", self.health, self.dest);
		return;
	}

	trog_death1 ();
};

void() Trog_idlesound =
{
local float wr;
	wr = random() * 10;

	if (self.waitmin < time)
	{
	 	self.waitmin = time + 10;
	 	if (wr > 7.0) 
			sound (self, CHAN_AUTO, "trog/tidle1.wav", 1, ATTN_NORM);
		else if (wr < 3.0)
			sound (self, CHAN_AUTO, "trog/tidle2.wav", 1, ATTN_NORM);
	}
};

void(entity attacker, float damage) Trog_Pain =
{
	if (self.pain_finished)
	{
		sound (self, CHAN_VOICE, "trog/tpain.wav", 1, ATTN_NORM);
		if (random()*70 > damage)
			return;		// didn't flinch

		self.pain_finished = 0;
		trog_pain1 ();
	}
};

/*
=================
TrogAttackFinished
=================
*/
float()	TrogAttackFinished =
{
	if (enemy_range >= RANGE_MID || !enemy_vis)
	{
		self.attack_state = AS_STRAIGHT;
		self.think = trog_run1;
	}
	else
	{
		self.attack_state = AS_SLIDING;
		self.think = trog_side1;
	}
};

//*******************************

void() DoCircles =
{
local vector startpos, drag, dragto;

	if (self.dmg == 1)
	{
		self.origin = self.origin + '0 0 8';
		startpos = self.origin + '0 0 16';
	}
	else
	{
		self.origin = self.origin - '0 0 8';
		startpos = self.origin - '0 0 16';
	}
	DrawCircleXY(self.origin, 84 - (self.count*3), 105);
	DrawCircleXY(startpos, 64 - (self.count*3), 232);
	self.count = self.count - self.dmg;
	if (self.count == 6)
	{
		remove(self);
		return;
	}
	if (self.count == 0)
		self.dmg = -1;
	if (vlen(self.enemy.origin - self.origin) <= 250)
	{
		dragto = self.origin;
		dragto_z = self.enemy.origin_z;
		drag = normalize (dragto - self.enemy.origin);
		drag = drag*250;
		self.enemy.velocity = self.enemy.velocity + drag;
	}
		
	self.nextthink = time + 0.12;
};

void() DoMagicExplode =
{
	local	vector	newo;
	local	float	x, y, z;
	local entity sprt;

	x = (random() * 128) - 64;
	y = (random() * 128) - 64;
	z = (random() * 128) - 16;

	newo_x = self.origin_x + x;
	newo_y = self.origin_y + y;
	newo_z = self.origin_z + z;

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, newo_x);
	WriteCoord (MSG_BROADCAST, newo_y);
	WriteCoord (MSG_BROADCAST, newo_z);

	self.wait = self.wait - 1;
	if(self.wait < 0)
		remove(self);

	self.nextthink = time + (0.2 * random()) + 0.1;

	sprt = spawn();
	sprt.movetype = MOVETYPE_NONE;
	sprt.velocity = '0 0 0';
	sprt.touch = SUB_Null;
	sprt.owner = self.owner;
	sprt.origin_x = newo_x;
	sprt.origin_y = newo_y;
	sprt.origin_z = newo_z;
	setorigin(sprt, sprt.origin);
	setmodel (sprt, "progs/s_explod.spr");
	sprt.solid = SOLID_NOT;
	self = sprt;
	T_RadiusDamage (self, self.owner, 80, self.owner);
	s_explode1 ();
};

void() TrogWarpMagic =
{
	sound (self, CHAN_AUTO, "trog/bigboom.wav", 1, ATTN_NORM);
	setmodel(self, "progs/warp2.mdl");
	setorigin(self, self.origin);
	self.avelocity = '0 250 0';
	T_RadiusDamage (self, self.owner, 120, self.owner);
	if (vlen(self.enemy.origin - self.origin) <= 120)
	{
		self.enemy.flags = self.enemy.flags - (self.enemy.flags & FL_ONGROUND);
		setorigin(self.enemy, self.enemy.origin + '0 0 2');
		self.enemy.velocity_z = (random() * 300) + 400;
		self.enemy.velocity_x = (random() * 400) - 200;
		self.enemy.velocity_y = (random() * 400) - 200;
	}
	trog_magic1 ();
	TMAGIC_DONE = 1;
};

void() StartTrogMagic =
{
local entity  Mcircle, Tboom;

	//freeze player to scare him.
	//self.enemy.pausetime = time + 0.25;

	Mcircle = spawn();
	Mcircle.origin = self.enemy.origin - '0 0 12';
	setorigin(Mcircle, Mcircle.origin);
	Mcircle.count = 5;
	Mcircle.dmg = 1;
	Mcircle.think = DoCircles;
	Mcircle.enemy = self.enemy;
	sound (Mcircle, CHAN_WEAPON, "trog/charge.wav", 1, ATTN_NORM);
	Mcircle.nextthink = time + 0.01;

	Tboom = spawn();
	Tboom.origin = self.enemy.origin + '0 0 24';
	//Tboom.skin = 1;
	Tboom.enemy = self.enemy;
	Tboom.solid = SOLID_NOT;
	Tboom.movetype = MOVETYPE_NONE;
	Tboom.think = TrogWarpMagic;
	Tboom.owner = self;
	Tboom.wait = 6;
	Tboom.nextthink = time + 1.1;
};

//*******************************

void() TrogBallThink =
{
	self.frame = self.frame + 1;
	if (self.frame == 6)
	    self.frame = 0;

	self.angles = vectoangles(self.velocity);

	particle(self.origin, '0 0 1', 233, 25);
	self.nextthink = time + 0.1;
};

void() TrogBallSeek =
{
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	setorigin(self, (self.origin + '0 0 2'));
	self.velocity = normalize((self.enemy.origin + self.enemy.view_ofs) - self.origin);
	self.velocity = self.velocity * 400;
	self.velocity_z = self.velocity_z + vlen(self.enemy.origin - self.origin);
	self.angles = vectoangles(self.velocity);
	self.nextthink = time + 0.01;
	self.think = TrogBallThink;
};

void() TrogBallTouch =
{
	if (other.health)
	{
		OgreGrenadeExplode();
		return;
	}
	if (self.count >= 3)
	{
		OgreGrenadeExplode();
		return;
	}
	sound (self, CHAN_AUTO, "hknight/hit.wav", 1, ATTN_NORM);
	sound (self, CHAN_WEAPON, "trog/frblfly.wav", 0.6, ATTN_NORM);

	self.count = self.count + 1;
	self.think = TrogBallSeek;
	self.nextthink = time + 0.01;
};

void() Trog_FireBall =
{
	local	entity missile, mpuff;
	
	self.effects = self.effects | EF_MUZZLEFLASH;

	sound (self, CHAN_WEAPON, "trog/frblatck.wav", 1, ATTN_NORM);
	sound (self, CHAN_AUTO, "trog/frblfly.wav", 0.6, ATTN_NORM);

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
		
// set missile speed	
	makevectors (self.angles);
	missile.origin = self.origin - (v_right * 20) + (v_up * 35);
	missile.enemy = self.enemy;
	missile.velocity = normalize((self.enemy.origin + self.enemy.view_ofs) - missile.origin);
	missile.velocity = missile.velocity * 400;
	missile.velocity_z = missile.velocity_z + vlen(self.enemy.origin - missile.origin);
	missile.angles = vectoangles(missile.velocity);
	
	missile.touch = TrogBallTouch;
	missile.skin = 4;
	missile.count = 0;
// set missile duration
	missile.nextthink = time + 0.1;
	missile.think = TrogBallThink;
	missile.frame = 0;

	setmodel (missile, "progs/trogball.mdl");
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, missile.origin);
};

void() Trog_Missile =
{
	if (random() < 0.25 || !(TMAGIC_DONE))
		return;

	if (random() < 0.6 || !(self.enemy.flags & FL_ONGROUND))
		trog_fast1();
	else
	{
		TMAGIC_DONE = 0;
		trog_sboom1();
	}
};

void() trog_start =
{
local vector	org;
local entity	teldeath;

	if (self.style)
	{
		makevectors (self.angles);
		org = self.origin + 16 * v_forward;
		spawn_tfog (org);
		teldeath = spawn();
		teldeath.origin = org;
		teldeath.owner = self;
		teldeath.think = sf64_teledeath;
		teldeath.nextthink = time + 0.1;
	}

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/troglod.mdl");

	setsize (self, '-16 -16 -24', '16 16 40');
	self.health = 280;

	flymonster_start ();
};

/*QUAKED monster_troglodyte (1 0 0) (-16 -16 -24) (16 16 40) Ambush
*/
void() monster_troglodyte =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model ("progs/troglod.mdl");
	precache_model ("progs/trogball.mdl");
	precache_model ("progs/warp2.mdl");
	precache_model ("progs/h_trog.mdl");

	precache_sound ("trog/frblatck.wav");
	precache_sound ("trog/frblfly.wav");
	precache_sound ("trog/charge.wav");
	precache_sound ("trog/bigboom.wav");
	precache_sound ("trog/tdeath1.wav");
	precache_sound ("trog/tdeath2.wav");
	precache_sound ("trog/tidle1.wav");
	precache_sound ("trog/tidle2.wav");
	precache_sound ("trog/tpain.wav");
	precache_sound ("trog/tsight1.wav");
	precache_sound ("trog/tsight2.wav");

	self.th_stand = trog_stand1;
	self.th_walk = trog_walk1;
	self.th_run = trog_run1;
	self.th_missile = Trog_Missile;
	self.th_pain = Trog_Pain;
	self.th_die = Trog_Die;

	//wait for idle sounds
	self.waitmin = time + 5;

	if (self.spawnflags & TRIGGER_SPAWN)
	{
		self.use = trog_start;
		total_monsters = total_monsters + 1;
		return;
	}

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	self.pain_finished = 1;

	setmodel (self, "progs/troglod.mdl");

	setsize (self, '-16 -16 -24', '16 16 40');
	self.health = 280;

	flymonster_start ();
};
