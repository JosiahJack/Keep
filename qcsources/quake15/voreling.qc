/*==============================================================================
VORELINGS (Originally from Quoth - Kell/Necros/Preach)
==============================================================================*/
$frame idle1 idle2 idle3 idle4 idle5 idle6 idle7 idle8
$frame idle9 idle10 idle11 idle12 idle13

$frame idleup1 idleup2 idleup3 idleup4 idleup5 idleup6 

$frame drop1 drop2 drop3 drop4 drop5

$frame grow1 grow2 grow3 grow4 grow5 grow6 grow7 grow8 grow9 grow10

$frame walk1 walk2 walk3 walk4 walk5

$frame run1 run2 run3 run4

// Jumping up
$frame jump1 jump2 jump3 jump4 jump5 jump6

// Bite attack
$frame bite1 bite2 bite3 bite4 bite5 bite6 bite7

// Extremely short pain set
$frame pain1 pain2

// fall over and die
$frame death1 death2 death3 death4 death5 death6 death7

// body flies up and then back to the ground
$frame deathB1 deathB2 deathB3 deathB4 deathB5 deathB6 deathB7 deathB8

// Not used, modelling templates
$frame base1 base2


//============================================================================

void()	voreling_JumpTouch;
void() voreling_MeleeAtk;
void(float side) voreling_melee;

float VORE_CEIL = 4;

void()	voreling_idle1	=[	$idle1,	voreling_idle2	] {monster_idle_sound();ai_stand();};
void()	voreling_idle2	=[	$idle2,	voreling_idle3	] {ai_stand();};
void()	voreling_idle3	=[	$idle3,	voreling_idle4	] {ai_stand();};
void()	voreling_idle4	=[	$idle4,	voreling_idle5	] {ai_stand();};
void()	voreling_idle5	=[	$idle5,	voreling_idle6	] {ai_stand();};
void()	voreling_idle6	=[	$idle6,	voreling_idle7	] {ai_stand();};
void()	voreling_idle7	=[	$idle7,	voreling_idle8	] {ai_stand();};
void()	voreling_idle8	=[	$idle8,	voreling_idle9	] {ai_stand();};
void()	voreling_idle9	=[	$idle9,	voreling_idle10	] {ai_stand();};
void()	voreling_idle10	=[	$idle10,voreling_idle11	] {ai_stand();};
void()	voreling_idle11	=[	$idle11,voreling_idle12	] {ai_stand();};
void()	voreling_idle12	=[	$idle12,voreling_idle13	] {ai_stand();};
void()	voreling_idle13	=[	$idle13,voreling_idle1	] {ai_stand();};

void()	voreling_dangle1	=[	$idleup1,	voreling_dangle2	] {self.velocity_z = 10000;monster_idle_sound();ai_stand();};
void()	voreling_dangle2	=[	$idleup2,	voreling_dangle3	] {self.velocity_z = 10000;ai_stand();};
void()	voreling_dangle3	=[	$idleup3,	voreling_dangle4	] {self.velocity_z = 10000;ai_stand();};
void()	voreling_dangle4	=[	$idleup4,	voreling_dangle5	] {self.velocity_z = 10000;ai_stand();};
void()	voreling_dangle5	=[	$idleup5,	voreling_dangle6	] {self.velocity_z = 10000;ai_stand();};
void()	voreling_dangle6	=[	$idleup6,	voreling_dangle1	] {self.velocity_z = 10000;self.movetype = MOVETYPE_NONE;ai_stand();};

//==================================================

void()	voreling_walk1	=[	$walk1,	voreling_walk2	] {monster_idle_sound();ai_walk(4);};
void()	voreling_walk2	=[	$walk2,	voreling_walk3	] {ai_walk(3);};
void()	voreling_walk3	=[	$walk3,	voreling_walk4	] {ai_walk(4);};
void()	voreling_walk4	=[	$walk4,	voreling_walk5	] {ai_walk(5);};
void()	voreling_walk5	=[	$walk5,	voreling_walk1	] {ai_walk(5);};

void()	voreling_run1	=[	$run1,		voreling_run2	] {
if (random() < 0.2)
    sound7(self, CHAN_VOICE, "voreling/idle.wav", 1, ATTN_IDLE, SNDSPD);
ai_run(30);};
void()	voreling_run2	=[	$run2,		voreling_run3	] {if (self.spawnflags&VORE_CEIL){ self.movetype = MOVETYPE_STEP; self.velocity_z = 0;}ai_run(25);};
void()	voreling_run3	=[	$run3,		voreling_run4	] {ai_run(36);};
void()	voreling_run4	=[	$run4,		voreling_run5	] {ai_run(30);};
void()	voreling_run5	=[	$run5,		voreling_run6	] {ai_run(25);};
void()	voreling_run6	=[	$run6,		voreling_run7	] {ai_run(36);};
void()	voreling_run7	=[	$run6,		voreling_run8	] {ai_run(36);};
void()	voreling_run8	=[	$run6,		voreling_run1	] {ai_run(36);};

void()	voreling_jump1	=[	$jump1,		voreling_jump2	] {ai_face();};
void()	voreling_jump2	=[	$jump2,		voreling_jump3	] {ai_face();};
void()	voreling_jump3	=[	$jump3,		voreling_jump4	] {ai_face();};
void()	voreling_jump4	=[	$jump4,		voreling_jump5	]
{
	ai_face();
	
	self.touch = voreling_JumpTouch;
	makevectors (self.angles);
	self.origin_z = self.origin_z + 1;
	self.velocity = v_forward * 450 + '0 0 200';
	if (self.flags & FL_ONGROUND)
		self.flags = self.flags - FL_ONGROUND;
};
void()	voreling_jump5	=[	$jump5,		voreling_jump6	] {};
void()	voreling_jump6	=[	$jump6,		voreling_jump7	] {};
void()	voreling_jump7	=[	$jump7,		voreling_jump8	] {};
void()	voreling_jump8	=[ 	$jump8,		voreling_jump9	] {};
void()	voreling_jump9	=[ 	$jump9,		voreling_run1	] {};


void()	voreling_bite1	=[	$bite1, voreling_bite2	] {ai_face();};
// Start bite attack loop
void()	voreling_bite2	=[	$bite2, voreling_bite3 ] {ai_face();};
void()	voreling_bite3	=[	$bite3, voreling_bite4 ] {ai_face();};
void()	voreling_bite4 = [	$bite4, voreling_bite5 ] {voreling_melee(10);};
void()	voreling_bite5 = [	$bite5, voreling_bite6 ] {};
void()	voreling_bite6 =[	$bite6, voreling_bite7 ] {};
// Exit bite attack loop
void()	voreling_bite7	=[	$bite7, voreling_run1	] {};

void() voreling_pain1	=[	$pain1,	voreling_pain2	] {};
void() voreling_pain2	=[	$pain2,	voreling_run1	] {};

void(entity attacker, float damage)	voreling_pain =
{
	if (self.touch == voreling_JumpTouch)
		return;

	if (self.pain_finished > time)
		return;

	self.pain_finished = time + 1;
    sound7(self, CHAN_VOICE, "voreling/pain.wav", 1, ATTN_NORM, SNDSPD);

	if (random()*200 > damage)
		return;		// didn't flinch
		
	voreling_pain1 ();
};

void() voreling_die1 =[	$death1, voreling_die2	] {};
void() voreling_die2 =[	$death2, voreling_die3	] {sound7(self, CHAN_VOICE, "voreling/death.wav", 1, ATTN_NORM, SNDSPD);};
void() voreling_die3 =[	$death3, voreling_die4	] {
	self.solid = SOLID_NOT;};
void() voreling_die4 =[	$death4, voreling_die5	] {};
void() voreling_die5 =[	$death5, voreling_die6	] {};
void() voreling_die6 =[	$death6, voreling_die7	] {};
void() voreling_die7 =[	$death7, voreling_die7	] {// 	auto_cvar 'knightcorpsehealth' has been set to  default = 60  in code above already

		CopyMonsterToBodyQue(8, "progs/gib_voreleg.mdl");
			setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);};



//----------------------------------------------------------------------------
void() voreling_dieB1 =[	$deathB1, voreling_dieB2	] {};
void() voreling_dieB2 =[	$deathB2, voreling_dieB3	] {sound7(self, CHAN_VOICE, "voreling/death.wav", 1, ATTN_NORM, SNDSPD);};
void() voreling_dieB3 =[	$deathB3, voreling_dieB4	] {
	self.solid = SOLID_NOT;};
void() voreling_dieB4 =[	$deathB4, voreling_dieB5	] {};
void() voreling_dieB5 =[	$deathB5, voreling_dieB6	] {};
void() voreling_dieB6 =[	$deathB6, voreling_dieB7	] {};
void() voreling_dieB7 =[	$deathB7, voreling_dieB8	] {};
void() voreling_dieB8 =[	$deathB8, voreling_dieB8	] {// 	auto_cvar 'knightcorpsehealth' has been set to  default = 60  in code above already

		CopyMonsterToBodyQue(8, "progs/gib_voreleg.mdl");
			setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);};

void() voreling_die =
{
bodyCheck(); //Hexen 2 code - detect slope and adjust body angle
// check for gib
	if (!self.shocked && self.enemy.weapon == IT_LIGHTNING && self.sticky != 1)
	{
		lg_death1();
		return;
	}
	
	if (self.health < -15  || self.enemy.weapon == IT_CHAINSAW)
	{
		sound7(self, CHAN_VOICE, "player/gibexplode.wav", 1, ATTN_NORM, SNDSPD);
		
		//5 randomized blood droplets that drip if stuck to the ceiling
		CeilSplat();
		CeilSplat();
		CeilSplat();
		CeilSplat();
		CeilSplat();
		
		ThrowHead ("progs/gib_voreleg.mdl", self.health);
		ThrowGib ("progs/gib_voreleg.mdl", self.health);
		ThrowGib ("progs/gib_voreleg.mdl", self.health);
		//ThrowGib ("progs/gib1.mdl", self.health);
		return;
	}

// regular death
	if(random()<0.5)
		voreling_die1 ();
	else
		voreling_dieB1 ();
};		


void() voreling_MeleeAtk =
{
	voreling_bite1 ();
};


/*QUAKED monster_voreling (1 0 0) (-32 -32 -24) (32 32 64) Ambush

*/
void() monster_voreling =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model ("progs/voreling.mdl");
	
	precachegibs_shal();

	precache_sound("voreling/death.wav");
	precache_sound("voreling/attackmunch.wav");
	precache_sound("voreling/attacktear.wav");
	precache_sound("voreling/pain.wav");
	precache_sound("voreling/idle.wav");
	precache_sound("voreling/sight.wav");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	self.netname = "monster_voreling";

	setmodel (self, "progs/voreling.mdl");

	setsize (self, '-12 -12 -24', '12 12 5');

	self.health = 40;

	if (self.spawnflags&VORE_CEIL)
		self.th_stand = voreling_dangle1;
	else
		self.th_stand = voreling_idle1;
	self.th_walk = voreling_walk1;
	self.th_run = voreling_run1;
	self.th_die = voreling_die;
	self.th_melee = voreling_MeleeAtk;		// one of two attacks
	self.th_missile = voreling_jump1;			// jump attack
	self.th_pain = voreling_pain;
		
	walkmonster_start();
};

void() monster_shalrathminion =
{
	self.classname = "monster_voreling";
	monster_voreling();
}

/*
==============================================================================

DEMON

==============================================================================
*/

/*
==============
CheckVorelingMelee

Returns TRUE if a melee attack would hit right now
==============
*/
float()	CheckVorelingMelee =
{
	if (enemy_range == RANGE_MELEE)
	{	// FIXME: check canreach
		self.attack_state = AS_MELEE;
		return TRUE;
	}
	return FALSE;
};

/*
==============
CheckDemonJump

==============
*/
float()	CheckVorelingJump =
{
	local	vector	dist;
	local	float	d;

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

float()	VorelingCheckAttack =
{
	local	vector	vec;
	
// if close enough for slashing, go for it
	if (CheckVorelingMelee ())
	{
		self.attack_state = AS_MELEE;
		return TRUE;
	}
	
	if (CheckVorelingJump ())
	{
		self.attack_state = AS_MISSILE;
        //sound7(self, CHAN_VOICE, "voreling/jump.wav", 1, ATTN_NORM, SNDSPD);
		return TRUE;
	}
	
	return FALSE;
};


//===========================================================================

void(float side)	voreling_melee =
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
		
	sound7(self, CHAN_WEAPON, "voreling/attackmunch.wav", 1, ATTN_NORM, SNDSPD);
	ldmg = 3 *random();
	if (other.classname == "monster_shalrath_boss")
		sound7(self, CHAN_WEAPON, "voreling/attacktear.wav", 1, ATTN_NORM, SNDSPD);
	else
		T_Damage (self.enemy, self, self, ldmg);	

	makevectors (self.angles);
	SpawnMeatSpray (self.origin + v_forward*16, side * v_right);
};


void()	voreling_JumpTouch =
{
	local	float	ldmg;

	if (self.health <= 0)
		return;
		
	if (other.takedamage)
	{
		if ( vlen(self.velocity) > 400 )
		{
			ldmg = 12;
			if (other.classname == "monster_shalrath_boss" || other.classname == "monster_voreling")
				sound7(self, CHAN_WEAPON, "voreling/attacktear.wav", 1, ATTN_NORM, SNDSPD);
			else
			{
				T_Damage (other, self, self, ldmg);
				sound7(self, CHAN_WEAPON, "voreling/attacktear.wav", 1, ATTN_NORM, SNDSPD);
			}	
		}
	}

	if (!checkbottom(self))
	{
		if (self.flags & FL_ONGROUND)
		{	// jump randomly to not get hung up
//dprint ("popjump\n");
	self.touch = SUB_Null;
	self.think = voreling_jump1;
	self.nextthink = time + 0.1;

//			self.velocity_x = (random() - 0.5) * 600;
//			self.velocity_y = (random() - 0.5) * 600;
//			self.velocity_z = 200;
//			self.flags = self.flags - FL_ONGROUND;
		}
		return;	// not on ground yet
	}

	self.touch = SUB_Null;
	self.think = voreling_jump9;
	self.nextthink = time + 0.1;
};

