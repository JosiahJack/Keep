void() drole_jump1;

.float		drole_searchtime;
.float		badhealth;


//====================================================================================================

void() trigger_drolejump_touch =
{
	if ( other.flags & (FL_MONSTER | FL_FLY | FL_SWIM) != FL_MONSTER )
		return;

// set XY even if not on ground, so the jump will clear lips
	other.velocity_x = self.movedir_x * self.speed;
	other.velocity_y = self.movedir_y * self.speed;
	
	if ( !(other.flags & FL_ONGROUND) )
		return;

	if ( other.badhealth != 1 )
		return;
		
	other.flags = other.flags - FL_ONGROUND;

	other.velocity_z = self.height;
	//other.think = drole_jump1;
};

/*QUAKED trigger_monsterjump (.5 .5 .5) ?*/
void() trigger_drolejump =
{
	if (!self.speed)
		self.speed = 200;
	if (!self.height)
		self.height = 200;
	if (self.angles == '0 0 0')
		self.angles = '0 360 0';
	InitTrigger ();
	self.touch = trigger_drolejump_touch;
};


//====================================================================================================



void() drole_move1;
void() drole_run1;

void() th_run_choice =
{

	if (self.badhealth == 1)
	{
		self.th_run = drole_run1;
		self.think = self.th_run;
	}
	else 
	{
		self.th_run = drole_move1;
		self.think = self.th_run;	
	}

};



void() ai_run_loiter =
{
	local float	ofs;
	
	self.ideal_yaw = enemy_yaw;

	if (self.lefty)
		ofs = 85;
	else
		ofs = -85;

	self.ideal_yaw = self.ideal_yaw + ofs;
	ChangeYaw ();
	self.ideal_yaw = self.ideal_yaw - ofs;	
	
	if (walkmove (self.ideal_yaw + ofs, movedist))
		return;
		
	self.lefty = 1 - self.lefty;
	
	walkmove (self.ideal_yaw - ofs, movedist);
	


};





void(float dist) ai_drole_run =
{

	local	vector	delta;
	local	float	axis;
	local	float	direct, ang_rint, ang_floor, ang_ceil;
	local	float	enemydistance;

	enemydistance = vlen (self.enemy.origin - self.origin);

	if (enemydistance < 350 && enemy_vis && self.th_run != drole_run1)
	{
		if (self.attack_state != AS_LOITER)
			self.attack_state = AS_LOITER;
	}
	else if (enemydistance >= 300)
	{
		if (self.attack_state != AS_STRAIGHT)
			self.attack_state = AS_STRAIGHT;

	}
	else if (!enemy_vis)
	{
		if (self.attack_state != AS_STRAIGHT)
			self.attack_state = AS_STRAIGHT;
	}
	else if (self.th_run == drole_run1)
	{
		if (self.attack_state != AS_STRAIGHT)
			self.attack_state = AS_STRAIGHT;
	}

	
	//bprint (ftos(self.attack_state));
	//bprint ("\n");
	
	// check health level and choose movement speed.




	if (enemy_vis)
		self.drole_searchtime = time + 1 + (2 * random());

	if (self.badhealth == 1 && self.th_run != drole_run1)
	{
		self.th_run = drole_run1;
		self.think = self.th_run;
	}
	

	if (self.badhealth == 0 && self.th_run != drole_move1 && self.drole_searchtime > time)
	{
		self.th_run = drole_move1;
		self.think = self.th_run;	
	}

	else if (self.badhealth == 0 && !enemy_vis && self.th_run != drole_run1 && self.drole_searchtime < time)
	{
		self.th_run = drole_run1;
		self.think = self.th_run;	
	}


	movedist = dist;
	

	// see if the enemy is dead
	if (self.enemy.health <= 0)
	{
		self.enemy = world; //go back into sleep mode
		if (self.oldenemy.health > 0)
		{
			self.enemy = self.oldenemy;
			HuntTarget ();
		}
		else
		{
			if (self.movetarget)
				self.th_walk ();
			else
				self.th_stand ();
			return;
		}
	}

	self.show_hostile = time + 1;		// wake up other monsters

// check knowledge of enemy
	enemy_vis = visible(self.enemy);
	if (enemy_vis)
		self.search_time = time + 5;

// look for other coop players
	if (coop && self.search_time < time)
	{
		if (FindTarget ())
			return;
	}

	enemy_infront = infront(self.enemy);
	enemy_range = range(self.enemy);
	enemy_yaw = vectoyaw(self.enemy.origin - self.origin);
	
	if (self.attack_state == AS_MISSILE)
	{
//dprint ("ai_run_missile\n");
		ai_run_missile ();
		return;
	}
	if (self.attack_state == AS_MELEE)
	{
//dprint ("ai_run_melee\n");
		ai_run_melee ();
		return;
	}

	if (CheckAnyAttack ())
		return;					// beginning an attack
		
	if (self.attack_state == AS_LOITER)
	{
		ai_run_loiter ();
		return;
	}
// head straight in

	movetogoal (dist);		// done in C code...
	
	ai_shotcheck();
};




/*
==============================================================================

Drole...

==============================================================================
*/

$cd id1/models/drole
$origin 0 0 24
$base base		
$skin base


$frame idle_a1 idle_a2 idle_a3 idle_a4 idle_a5 idle_a6 idle_a7 idle_a8 idle_a9 idle_a10 idle_a11 idle_a12 idle_a13 idle_a14 idle_a15 idle_a16 idle_a17 idle_a18 idle_a19 idle_a20 idle_a21 idle_a22 idle_a23 idle_a24 idle_a25 idle_a26 idle_a27 idle_a28 idle_a29 idle_a30

$frame idle_b1 idle_b2 idle_b3 idle_b4 idle_b5 idle_b6 idle_b7 idle_b8 idle_b9 idle_b10 idle_b11 idle_b12 idle_b13 idle_b14 idle_b15 idle_b16 idle_b17 idle_b18 idle_b19 idle_b20 idle_b21 idle_b22 idle_b23 idle_b24 idle_b25 idle_b26 idle_b27 idle_b28 idle_b29 idle_b30 idle_b31 idle_b32 idle_b33 idle_b34 idle_b35 idle_b36 idle_b37 idle_b38 idle_b39 idle_b40

$frame idle_c1 idle_c2 idle_c3 idle_c4 idle_c5 idle_c6 idle_c7 idle_c8 idle_c9 idle_c10 idle_c11 idle_c12 idle_c13 idle_c14 idle_c15 idle_c16 idle_c17 idle_c18 idle_c19 idle_c20 idle_c21 idle_c22 idle_c23 idle_c24 idle_c25 idle_c26 idle_c27 idle_c28 idle_c29 idle_c30

$frame shoot1 shoot2 shoot3 shoot4 shoot5 shoot6 shoot7 shoot8 shoot9

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8

$frame	jump1 jump2 jump3 jump4 jump5 jumpb1

$frame	run1 run2 run3 run4 run5 run6 run7 run8

$frame	pain1 pain2 pain3 pain4 pain5 pain6

$frame swiper1 swiper2 swiper3 swiper4 swiper5 swiper6 swiper7 swiper8 swiper9 swiper10 swiper11 swiper12 swiper13 swiper14 swiper15 swiper16

$frame swipel1 swipel2 swipel3 swipel4 swipel5 swipel6 swipel7 swipel8 swipel9 swipel10 swipel11 swipel12 swipel13 swipel14 swipel15 swipel16

$frame death1 death2 death3 death4 death5 death6 death7 death8 death9 death10 death11 death12 death13 death14 death15 death16 death17 death18 death19 death20 death21 death22 death23 death24 death25 death26

void() drole_stand_a1	=[	$idle_a1,	drole_stand_a2	] {ai_stand();};
void() drole_stand_a2	=[	$idle_a2,	drole_stand_a3	] {ai_stand();};
void() drole_stand_a3	=[	$idle_a3,	drole_stand_a4	] {ai_stand();};
void() drole_stand_a4	=[	$idle_a4,	drole_stand_a5	] {ai_stand();};
void() drole_stand_a5	=[	$idle_a5,	drole_stand_a6	] {ai_stand();};
void() drole_stand_a6	=[	$idle_a6,	drole_stand_a7	] {ai_stand();};
void() drole_stand_a7	=[	$idle_a7,	drole_stand_a8	] {ai_stand();};
void() drole_stand_a8	=[	$idle_a8,	drole_stand_a9	] {ai_stand();};
void() drole_stand_a9	=[	$idle_a9,	drole_stand_a10] {ai_stand();};
void() drole_stand_a10	=[	$idle_a10,	drole_stand_a11] {ai_stand();};
void() drole_stand_a11	=[	$idle_a11,	drole_stand_a12] {ai_stand();};
void() drole_stand_a12	=[	$idle_a12,	drole_stand_a13] {ai_stand();};
void() drole_stand_a13	=[	$idle_a13,	drole_stand_a14] {ai_stand();};
void() drole_stand_a14	=[	$idle_a14,	drole_stand_a15] {ai_stand();};
void() drole_stand_a15	=[	$idle_a15,	drole_stand_a16] {ai_stand();};
void() drole_stand_a16	=[	$idle_a16,	drole_stand_a17] {ai_stand();};
void() drole_stand_a17	=[	$idle_a17,	drole_stand_a18	] {ai_stand();};
void() drole_stand_a18	=[	$idle_a18,	drole_stand_a19	] {ai_stand();};
void() drole_stand_a19	=[	$idle_a19,	drole_stand_a20	] {ai_stand();};
void() drole_stand_a20	=[	$idle_a20,	drole_stand_a21	] {ai_stand();};
void() drole_stand_a21	=[	$idle_a21,	drole_stand_a22	] {ai_stand();};
void() drole_stand_a22	=[	$idle_a22,	drole_stand_a23	] {ai_stand();};
void() drole_stand_a23	=[	$idle_a23,	drole_stand_a24	] {ai_stand();};
void() drole_stand_a24	=[	$idle_a24,	drole_stand_a25	] {ai_stand();};
void() drole_stand_a25	=[	$idle_a25,	drole_stand_a26	] {ai_stand();};
void() drole_stand_a26	=[	$idle_a26,	drole_stand_a27	] {ai_stand();};
void() drole_stand_a27	=[	$idle_a27,	drole_stand_a28	] {ai_stand();};
void() drole_stand_a28	=[	$idle_a28,	drole_stand_a29	] {ai_stand();};
void() drole_stand_a29	=[	$idle_a29,	drole_stand_a30	] {ai_stand();};
void() drole_stand_a30	=[	$idle_a30,	drole_stand_c1	] {ai_stand();};


void() drole_stand_b1	=[	$idle_b1,	drole_stand_b2	] {ai_stand();};
void() drole_stand_b2	=[	$idle_b2,	drole_stand_b3	] {ai_stand();};
void() drole_stand_b3	=[	$idle_b3,	drole_stand_b4	] {ai_stand();};
void() drole_stand_b4	=[	$idle_b4,	drole_stand_b5	] {ai_stand();};
void() drole_stand_b5	=[	$idle_b5,	drole_stand_b6	] {ai_stand();};
void() drole_stand_b6	=[	$idle_b6,	drole_stand_b7	] {ai_stand();};
void() drole_stand_b7	=[	$idle_b7,	drole_stand_b8	] {ai_stand();};
void() drole_stand_b8	=[	$idle_b8,	drole_stand_b9	] {ai_stand();};
void() drole_stand_b9	=[	$idle_b9,	drole_stand_b10] {ai_stand();};
void() drole_stand_b10	=[	$idle_b10,	drole_stand_b11] {ai_stand();};
void() drole_stand_b11	=[	$idle_b11,	drole_stand_b12] {ai_stand();};
void() drole_stand_b12	=[	$idle_b12,	drole_stand_b13] {ai_stand();};
void() drole_stand_b13	=[	$idle_b13,	drole_stand_b14] {ai_stand();};
void() drole_stand_b14	=[	$idle_b14,	drole_stand_b15] {ai_stand();};
void() drole_stand_b15	=[	$idle_b15,	drole_stand_b16] {ai_stand();};
void() drole_stand_b16	=[	$idle_b16,	drole_stand_b17] {ai_stand();};
void() drole_stand_b17	=[	$idle_b17,	drole_stand_b18	] {ai_stand();};
void() drole_stand_b18	=[	$idle_b18,	drole_stand_b19	] {ai_stand();};
void() drole_stand_b19	=[	$idle_b19,	drole_stand_b20	] {ai_stand();};
void() drole_stand_b20	=[	$idle_b20,	drole_stand_b21	] {ai_stand();};
void() drole_stand_b21	=[	$idle_b21,	drole_stand_b22	] {ai_stand();};
void() drole_stand_b22	=[	$idle_b22,	drole_stand_b23	] {ai_stand();};
void() drole_stand_b23	=[	$idle_b23,	drole_stand_b24	] {ai_stand();};
void() drole_stand_b24	=[	$idle_b24,	drole_stand_b25	] {ai_stand();};
void() drole_stand_b25	=[	$idle_b25,	drole_stand_b26	] {ai_stand();};
void() drole_stand_b26	=[	$idle_b26,	drole_stand_b27	] {ai_stand();};
void() drole_stand_b27	=[	$idle_b27,	drole_stand_b28	] {ai_stand();};
void() drole_stand_b28	=[	$idle_b28,	drole_stand_b29	] {ai_stand();};
void() drole_stand_b29	=[	$idle_b29,	drole_stand_b30	] {ai_stand();};
void() drole_stand_b30	=[	$idle_b30,	drole_stand_b31	] {ai_stand();};
void() drole_stand_b31	=[	$idle_b31,	drole_stand_b32	] {ai_stand();};
void() drole_stand_b32	=[	$idle_b32,	drole_stand_b33	] {ai_stand();};
void() drole_stand_b33	=[	$idle_b33,	drole_stand_b34	] {ai_stand();};
void() drole_stand_b34	=[	$idle_b34,	drole_stand_b35	] {ai_stand();};
void() drole_stand_b35	=[	$idle_b35,	drole_stand_b36	] {ai_stand();};
void() drole_stand_b36	=[	$idle_b36,	drole_stand_b37	] {ai_stand();};
void() drole_stand_b37	=[	$idle_b37,	drole_stand_b38	] {ai_stand();};
void() drole_stand_b38	=[	$idle_b38,	drole_stand_b39	] {ai_stand();};
void() drole_stand_b39	=[	$idle_b39,	drole_stand_b40	] {ai_stand();};
void() drole_stand_b40	=[	$idle_b40,	drole_stand_c1	] {ai_stand();};

void() drole_stand_c1	=[	$idle_c1,	drole_stand_c2	] {ai_stand();};
void() drole_stand_c2	=[	$idle_c2,	drole_stand_c3	] {ai_stand();};
void() drole_stand_c3	=[	$idle_c3,	drole_stand_c4	] {ai_stand();};
void() drole_stand_c4	=[	$idle_c4,	drole_stand_c5	] {ai_stand();};
void() drole_stand_c5	=[	$idle_c5,	drole_stand_c6	] {ai_stand();};
void() drole_stand_c6	=[	$idle_c6,	drole_stand_c7	] {ai_stand();};
void() drole_stand_c7	=[	$idle_c7,	drole_stand_c8	] {ai_stand();};
void() drole_stand_c8	=[	$idle_c8,	drole_stand_c9	] {ai_stand();};
void() drole_stand_c9	=[	$idle_c9,	drole_stand_c10] {ai_stand();};
void() drole_stand_c10	=[	$idle_c10,	drole_stand_c11] {ai_stand();};
void() drole_stand_c11	=[	$idle_c11,	drole_stand_c12] {ai_stand();};
void() drole_stand_c12	=[	$idle_c12,	drole_stand_c13] {ai_stand();};
void() drole_stand_c13	=[	$idle_c13,	drole_stand_c14] {ai_stand();};
void() drole_stand_c14	=[	$idle_c14,	drole_stand_c15] {ai_stand();};
void() drole_stand_c15	=[	$idle_c15,	drole_stand_c16] {ai_stand();};
void() drole_stand_c16	=[	$idle_c16,	drole_stand_c17] {ai_stand();};
void() drole_stand_c17	=[	$idle_c17,	drole_stand_c18	] {ai_stand();};
void() drole_stand_c18	=[	$idle_c18,	drole_stand_c19	] {ai_stand();};
void() drole_stand_c19	=[	$idle_c19,	drole_stand_c20	] {ai_stand();};
void() drole_stand_c20	=[	$idle_c20,	drole_stand_c21	] {ai_stand();};
void() drole_stand_c21	=[	$idle_c21,	drole_stand_c22	] {ai_stand();};
void() drole_stand_c22	=[	$idle_c22,	drole_stand_c23	] {ai_stand();};
void() drole_stand_c23	=[	$idle_c23,	drole_stand_c24	] {ai_stand();};
void() drole_stand_c24	=[	$idle_c24,	drole_stand_c25	] {ai_stand();};
void() drole_stand_c25	=[	$idle_c25,	drole_stand_c26	] {ai_stand();};
void() drole_stand_c26	=[	$idle_c26,	drole_stand_c27	] {ai_stand();};
void() drole_stand_c27	=[	$idle_c27,	drole_stand_c28	] {ai_stand();};
void() drole_stand_c28	=[	$idle_c28,	drole_stand_c29	] {ai_stand();};
void() drole_stand_c29	=[	$idle_c29,	drole_stand_c30	] {ai_stand();};
void() drole_stand_c30	=[	$idle_c30,	drole_stand_c1	] 
{

	local	float	animpick;

	ai_stand();
	animpick = random();
	
	if (animpick < 0.33)
		self.think = drole_stand_a1;
	else if (animpick < 0.66)
		self.think = drole_stand_b1;
	else
		self.think = self.think;
	

	if (random() > 0.5)
		sound (self, CHAN_VOICE, "drole/idle.wav", 1, ATTN_IDLE);
};








void() drole_walk1		=[      $walk1,        drole_walk2 ] {ai_walk(10);};
void() drole_walk2       =[      $walk2,        drole_walk3 ] {ai_walk(9);};
void() drole_walk3       =[      $walk3,        drole_walk4 ] {ai_walk(9);};
void() drole_walk4       =[      $walk4,        drole_walk5 ] {ai_walk(5);};
void() drole_walk5       =[      $walk5,        drole_walk6 ] {ai_walk(6);};
void() drole_walk6       =[      $walk6,        drole_walk7 ] {ai_walk(12);};
void() drole_walk7       =[      $walk7,        drole_walk8 ] {ai_walk(8);};
void() drole_walk8       =[      $walk8,        drole_walk9 ] {ai_walk(3);};
void() drole_walk9       =[      $walk1,        drole_walk10] {ai_walk(13);};
void() drole_walk10      =[      $walk2,       drole_walk11] {ai_walk(9);};
void() drole_walk11      =[      $walk3,       drole_walk12] {ai_walk(7);};
void() drole_walk12      =[      $walk4,       drole_walk1 ] {ai_walk(7);
if (random() > 0.8)
	sound (self, CHAN_VOICE, "drole/idle.wav", 1, ATTN_IDLE);};

void() drole_run1       =[      $run1,        drole_run2      ] {ai_drole_run(34);};
void() drole_run2       =[      $run2,        drole_run3      ] {ai_drole_run(32);};
void() drole_run3       =[      $run3,        drole_run4      ] {ai_drole_run(38);};
void() drole_run4       =[      $run4,        drole_run5      ] {ai_drole_run(35);};
void() drole_run5       =[      $run5,        drole_run6      ] {ai_drole_run(34);};
void() drole_run6       =[      $run6,        drole_run7      ] {ai_drole_run(32);};
void() drole_run7       =[      $run7,        drole_run8      ] {ai_drole_run(38);};
void() drole_run8       =[      $run8,        drole_run1      ] {ai_drole_run(35);
if (random() > 0.8)
	sound (self, CHAN_VOICE, "drole/idle.wav", 1, ATTN_IDLE);
};




void() drole_jump1       =[      $jump1,        drole_jump2      ] {};
void() drole_jump2       =[      $jump2,        drole_jump3      ] {};
void() drole_jump3       =[      $jump3,        drole_jump4      ] {};
void() drole_jump4       =[      $jump4,        drole_jump5      ] {};
void() drole_jump5       =[      $jump5,        drole_run1      ] {};






void() drole_move1	=[      $walk1,        drole_move2 ] {ai_drole_run(10*1.5);};
void() drole_move2      =[      $walk2,        drole_move3 ] {ai_drole_run(9*1.5);};
void() drole_move3      =[      $walk3,        drole_move4 ] {ai_drole_run(9*1.5);};
void() drole_move4      =[      $walk4,        drole_move5 ] {ai_drole_run(5*1.5);};
void() drole_move5      =[      $walk5,        drole_move6 ] {ai_drole_run(6*1.5);};
void() drole_move6      =[      $walk6,        drole_move7 ] {ai_drole_run(12*1.5);};
void() drole_move7      =[      $walk7,        drole_move8 ] {ai_drole_run(8*1.5);};
void() drole_move8      =[      $walk8,        drole_move9 ] {ai_drole_run(3*1.5);};
void() drole_move9      =[      $walk1,        drole_move10] {ai_drole_run(13*1.5);};
void() drole_move10     =[      $walk2,       drole_move11] {ai_drole_run(9*1.5);};
void() drole_move11     =[      $walk3,       drole_move12] {ai_drole_run(7*1.5);};
void() drole_move12     =[      $walk4,       drole_move1 ] {ai_drole_run(7*1.5);
if (random() > 0.8)
	sound (self, CHAN_VOICE, "drole/idle.wav", 1, ATTN_IDLE);};











void() drole_smash1     =[      $jumpb1,       drole_smash2    ] {
sound (self, CHAN_VOICE, "drole/swipe.wav", 1, ATTN_NORM);
ai_charge(2);};
void() drole_smash2     =[      $jumpb1,       drole_smash3    ] {ai_charge(6);};
void() drole_smash3     =[      $jumpb1,       drole_smash4    ] {ai_charge(6);};
void() drole_smash4     =[      $jumpb1,       drole_smash5    ] {ai_charge(5);};
void() drole_smash5     =[      $jumpb1,       drole_smash6    ] {ai_charge(4);};
void() drole_smash6     =[      $jumpb1,       drole_smash7    ] {ai_charge(1);};
void() drole_smash7     =[      $jumpb1,       drole_smash8    ] {ai_charge(0);};
void() drole_smash8     =[      $jumpb1,       drole_smash9    ] {ai_charge(0);};
void() drole_smash9     =[      $jumpb1,       drole_smash10   ] {ai_charge(0);};
void() drole_smash10    =[      $jumpb1,      drole_smash11   ] {
local vector	delta;
local float 	ldmg;

	if (!self.enemy)
		return;
	ai_charge(0);

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 100)
		return;
	if (!CanDamage (self.enemy, self))
		return;
		
	ldmg = 50;
	T_Damage (self.enemy, self, self, ldmg);
	

	if (random() < 0.5)
		sound (self, CHAN_AUTO, "drole/strike1.wav", 1, ATTN_NORM);
	else
		sound (self, CHAN_AUTO, "drole/strike2.wav", 1, ATTN_NORM);

	SpawnMeatSpray (self.origin + v_forward*16, crandom() * 100 * v_right);
	SpawnMeatSpray (self.origin + v_forward*16, crandom() * 100 * v_right);
};
void() drole_smash11    =[      $jumpb1,      drole_smash12   ] {ai_charge(5);};
void() drole_smash12    =[      $jumpb1,      drole_run1	   ] {ai_charge(4);th_run_choice();};

void() drole_swingr1;
//void() drole_fast_swingr1;

void(float side) DroleHit =
{
local vector	delta;
local float 	ldmg;

	if (!self.enemy)
		return;
	ai_charge(10);

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 100)
		return;
		
	ldmg = 20 + 10 * random();
	T_Damage (self.enemy, self, self, ldmg);
	
	

	if (random() < 0.5)
		sound (self, CHAN_AUTO, "drole/strike1.wav", 1, ATTN_NORM);
	else
		sound (self, CHAN_AUTO, "drole/strike2.wav", 1, ATTN_NORM);

	if (side)
	{
		makevectors (self.angles);
		SpawnMeatSpray (self.origin + v_forward*16, side * v_right);
	}
};



void() drole_swingl1	=[      $swipel1,      drole_swingl2   ] {ai_charge(34*0.75);sound (self, CHAN_VOICE, "drole/swipe.wav", 1, ATTN_NORM);};
void() drole_swingl2	=[      $swipel2,      drole_swingl3   ] {ai_charge(32*0.75);};
void() drole_swingl3 =[      $swipel3,      drole_swingl4   ] {ai_charge(38*0.75);};
void() drole_swingl4 =[      $swipel4,      drole_swingl5   ] {ai_charge(35*0.75);};
void() drole_swingl5 =[      $swipel5,      drole_swingl6   ] {ai_charge(34*0.75);DroleHit(-250);};
void() drole_swingl6 =[      $swipel6,      drole_swingl7   ] {ai_charge(32*0.75);sound (self, CHAN_VOICE, "drole/swipe.wav", 1, ATTN_NORM);};
void() drole_swingl7 =[      $swipel7,      drole_swingl8   ] {ai_charge(38*0.75);};
void() drole_swingl8 =[      $swipel8,      drole_swingl9   ] {ai_charge(35*0.75);};
void() drole_swingl9 =[      $swipel9,      drole_swingl10  ] {ai_charge(34*0.75);};
void() drole_swingl10 =[      $swipel10,      drole_swingl11  ] {ai_charge(32*0.75);DroleHit(-250);};
void() drole_swingl11 =[      $swipel11,      drole_swingl12  ] {ai_charge(38*0.75);};
void() drole_swingl12 =[      $swipel12,      drole_swingl13  ] {ai_charge(35*0.75);};
void() drole_swingl13 =[      $swipel13,      drole_swingl14  ] {ai_charge(34*0.75);};
void() drole_swingl14 =[      $swipel14,      drole_swingl15  ] {ai_charge(32*0.75);};
void() drole_swingl15 =[      $swipel15,      drole_swingl16  ] {ai_charge(38*0.75);};
void() drole_swingl16 =[      $swipel16,      drole_run1  ] {ai_charge(35*0.75);

	local	float	enemydistance;

	enemydistance = vlen (self.enemy.origin - self.origin);

	ai_charge(10);
	th_run_choice();
	if (random()<0.5 && enemydistance < 140 && self.enemy.health > 0)
		self.think = drole_swingr1;
};

void() drole_swingr1	=[      $swiper1,      drole_swingr2   ] {ai_charge(34*0.75);sound (self, CHAN_VOICE, "drole/swipe.wav", 1, ATTN_NORM);};
void() drole_swingr2	=[      $swiper2,      drole_swingr3   ] {ai_charge(32*0.75);};
void() drole_swingr3 =[      $swiper3,      drole_swingr4   ] {ai_charge(38*0.75);};
void() drole_swingr4 =[      $swiper4,      drole_swingr5   ] {ai_charge(35*0.75);};
void() drole_swingr5 =[      $swiper5,      drole_swingr6   ] {ai_charge(34*0.75);DroleHit(-250);};
void() drole_swingr6 =[      $swiper6,      drole_swingr7   ] {ai_charge(32*0.75);sound (self, CHAN_VOICE, "drole/swipe.wav", 1, ATTN_NORM);};
void() drole_swingr7 =[      $swiper7,      drole_swingr8   ] {ai_charge(38*0.75);};
void() drole_swingr8 =[      $swiper8,      drole_swingr9   ] {ai_charge(35*0.75);};
void() drole_swingr9 =[      $swiper9,      drole_swingr10  ] {ai_charge(34*0.75);};
void() drole_swingr10 =[      $swiper10,      drole_swingr11  ] {ai_charge(32*0.75);DroleHit(-250);};
void() drole_swingr11 =[      $swiper11,      drole_swingr12  ] {ai_charge(38*0.75);};
void() drole_swingr12 =[      $swiper12,      drole_swingr13  ] {ai_charge(35*0.75);};
void() drole_swingr13 =[      $swiper13,      drole_swingr14  ] {ai_charge(34*0.75);};
void() drole_swingr14 =[      $swiper14,      drole_swingr15  ] {ai_charge(32*0.75);};
void() drole_swingr15 =[      $swiper15,      drole_swingr16  ] {ai_charge(38*0.75);};
void() drole_swingr16 =[      $swiper16,      drole_run1  ] {ai_charge(35*0.75);

	local	float	enemydistance;

	enemydistance = vlen (self.enemy.origin - self.origin);

	ai_charge(10);
	th_run_choice();
	if (random()<0.5 && enemydistance < 140 && self.enemy.health > 0)
		self.think = drole_swingl1;
};





void() drole_melee =
{

	if (random() > 0.5)
		drole_swingr1 ();
	else
		drole_swingl1 ();
};


//============================================================================

void() drole_ball_touch =
{
	local vector org;
	
	if (other == self.owner)
		return;		// don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	
	org = self.origin - 8*normalize(self.velocity);

	

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
	//WriteByte (MSG_BROADCAST, 240);
	//WriteByte (MSG_BROADCAST, 3);
	
	sound (self, CHAN_AUTO, "drole/explode3.wav", 1, ATTN_NORM);
	
	T_WeakRadiusDamage (self, self.owner, 100, other);
	T_Damage (other, self, self.owner, (43 + 5 * random()));
	remove(self);	
};



void() drole_ball1     =[      1,	drole_ball2	] {ai_face();ai_shotcheck();self.nextthink = time + 0.2;}; //
void() drole_ball2     =[      2,	drole_ball3	] {ai_face();ai_shotcheck();self.velocity = self.velocity * 1.5;};
void() drole_ball3     =[      3,	drole_ball4	] {self.velocity = self.velocity * 1.5;};
void() drole_ball4     =[      3,	SUB_Remove	] 
{

	local	float	sk;
	self.nextthink = time + 5;

	sk = cvar("skill");
	
	if (sk == 0)
		self.velocity = self.velocity * 4.5;
	else
		self.velocity = self.velocity * 6;
};

void() drolefire =
{
	local	vector	offang;
	local	vector	org, vec, lead;
	local	entity	newmis;
	local	vector	d;
	local	float	t;
	local vector	spot1, spot2;	
	local entity	targ;
	local float	chance, dgdist;

	newmis = spawn();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;

	org = self.origin + '0 0 34';


	setmodel (newmis, "progs/drlbomb.mdl");
	setsize (newmis, '0 0 0', '0 0 0');		
	setorigin (newmis, org);
	
	newmis.frame = 0;

	if (visible(self.enemy))
	{
		if (self.enemy.classname == "player" || self.enemy.classname == "monster_gaunt")
		{
			lead = self.enemy.velocity * 0.4;
			lead_z = lead_z * 0.2;
			vec = (self.enemy.origin + '0 0 -8') + lead; //was 0.2
		}
		else
			vec = (self.enemy.origin + '0 0 -8');
		vec = normalize (vec - org);
	}
	

	else
	{
		vec = (self.oldenemyorigin + '0 0 -8');
		vec = normalize (vec - org);
	}
	
	newmis.velocity = vec * 100;  //900
	newmis.avelocity = '400 400 400';	
	newmis.angles = vectoangles(newmis.velocity);

	newmis.nextthink = time + 0.025;
	newmis.think = drole_ball1;
	newmis.touch = drole_ball_touch;
	newmis.classname = "drolefireball";
	
};



void() drole_magic1     =[      $shoot1,	drole_magic2	] {ai_face();ai_shotcheck();sound (self, CHAN_WEAPON, "drole/fire.wav", 1, ATTN_NORM);};
void() drole_magic2     =[      $shoot2,	drole_magic3	] {ai_face();ai_shotcheck();};
void() drole_magic3     =[      $shoot3,	drole_magic4	] {ai_face();ai_shotcheck();};
void() drole_magic4     =[      $shoot4,	drole_magic5	] {ai_face();ai_shotcheck();drolefire();};
void() drole_magic5     =[      $shoot5,	drole_magic6	] {ai_face();ai_shotcheck();};
void() drole_magic6     =[      $shoot6,	drole_magic9	] {ai_face();ai_shotcheck();};
void() drole_magic9     =[      $shoot7,	drole_magic10	] {ai_face();ai_shotcheck();};
void() drole_magic10    =[      $shoot8,	drole_magic11	] {ai_face();ai_shotcheck();};
void() drole_magic11    =[      $shoot9,	drole_magic12	] {ai_face();ai_shotcheck();};
void() drole_magic12    =[      $shoot8,	drole_run1	] {ai_face();th_run_choice();ai_shotcheck();};

//i should have put ai_shotcheck in the ai.qc file but it started out as a purely dguard ai thing.  bleh, no forsight i guess. :P
void() drole_magic =
{
	local	float	enemydistance;
	enemydistance = vlen (self.enemy.origin - self.origin);	
	
	if (self.badhealth == 1 && enemydistance < 250)

		return;
	
	

	

	drole_magic1();
};



void() drole_pain1       =[      $pain1, drole_pain2      ] {ai_back(8);};
void() drole_pain2       =[      $pain2, drole_pain3      ] {ai_back(10);};
void() drole_pain3       =[      $pain3, drole_pain4      ] {ai_back(10);};
void() drole_pain4       =[      $pain4, drole_pain5      ] {ai_back(8);};
void() drole_pain5       =[      $pain5, drole_pain6      ] {ai_back(6);};
void() drole_pain6       =[      $pain6, drole_run1      ] {ai_back(4);th_run_choice();};

void(entity attacker, float damage)	drole_pain =
{
	if (self.health < 350 && self.badhealth == 0)  //oh shit!  better get mad and kill that player! roar!
	{
		self.badhealth = 1;  //switches on its second mode
		sound (self, CHAN_AUTO, "drole/sight2.wav", 1, 0.5);
		drole_pain1 ();
		return;
	}

	if (random() < 0.3 && self.health > 0)
	{
		if (self.pain_finished > time)
			return;
		self.pain_finished = time + 2;
	
		sound (self, CHAN_VOICE, "drole/pain.wav", 1, ATTN_NORM);
		drole_pain1 ();
	}
};


//============================================================================

void() drole_death1      =[      $death1,       drole_death2     ] {};
void() drole_death2      =[      $death2,       drole_death3     ] {};
void() drole_death3      =[      $death3,       drole_death4     ] {self.solid = SOLID_NOT;};
void() drole_death4      =[      $death4,       drole_death5     ] {};
void() drole_death5      =[      $death5,       drole_death6     ] {};
void() drole_death6      =[      $death6,       drole_death7     ] {};
void() drole_death7      =[      $death7,       drole_death8     ] {};
void() drole_death8      =[      $death8,       drole_death9     ] {};
void() drole_death9      =[      $death9,       drole_death10    ] {};
void() drole_death10     =[      $death10,      drole_death11    ] {};
void() drole_death11      =[      $death11,     drole_death12     ] {};
void() drole_death12      =[      $death12,     drole_death13     ] {};
void() drole_death13      =[      $death13,     drole_death14     ] {};
void() drole_death14      =[      $death14,     drole_death15     ] {};
void() drole_death15      =[      $death15,     drole_death16     ] {};
void() drole_death16      =[      $death16,     drole_death17     ] {};
void() drole_death17      =[      $death17,     drole_death18     ] {};
void() drole_death18      =[      $death18,     drole_death19     ] {};
void() drole_death19      =[      $death19,     drole_death20    ] {};
void() drole_death20     =[      $death20,      drole_death21    ] {};
void() drole_death21      =[      $death21,     drole_death22     ] {};
void() drole_death22      =[      $death22,     drole_death23     ] {};
void() drole_death23      =[      $death23,     drole_death24     ] {};
void() drole_death24      =[      $death24,     drole_death25     ] {};
void() drole_death25      =[      $death25,     drole_death26     ] {};
void() drole_death26     =[      $death26,      monster_fade ] {};

void() drole_die =
{
 //check for gib
	if (self.health < -60)
	{
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		ThrowHead ("progs/h_drole.mdl", self.health);
		ThrowGib ("progs/gib1.mdl", self.health);
		ThrowGib ("progs/gib2.mdl", self.health);
		ThrowGib ("progs/gib3.mdl", self.health);
		return;
	}

// regular death
	sound (self, CHAN_VOICE, "drole/death.wav", 1, ATTN_NORM);
	drole_death1 ();
};



//============================================================================


void() drole_start =
{
	local vector	org;

	if (!(self.spawnflags & TRIGGER_SPAWNSILENT))
	{
	        org = self.origin + 16 * v_forward;
	        spawn_tfog (org);
	}
	
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel (self, "progs/drole.mdl");

	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	self.health = 500;
	monster_spawn();
        walkmonster_start_go();
};

void() drole_begin =
{
	if (self.delay == 1)
		self.nextthink = time + random() * 0.4;
	else
		self.nextthink = time + 0.1;
	self.think = drole_start;
};


/*QUAKED monster_drole (1 0 0) (-32 -32 -24) (32 32 64) Ambush
*/
void() monster_drole =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model ("progs/drole.mdl");
	precache_model ("progs/h_drole.mdl");
	precache_model ("progs/drlbomb.mdl");
	
	precache_sound ("drole/explode3.wav");
	//precache_sound ("shambler/sboom.wav");
	precache_sound ("drole/death.wav");
	precache_sound ("drole/pain.wav");
	precache_sound ("drole/idle.wav");
	precache_sound ("drole/sight.wav");
	precache_sound ("drole/sight2.wav");
	precache_sound ("drole/strike1.wav");
	precache_sound ("drole/strike2.wav");
	precache_sound ("drole/swipe.wav");
	precache_sound ("drole/fire.wav");

	self.th_stand = drole_stand_c1;
	self.th_walk = drole_walk1;
	self.th_run = drole_move1;
	self.th_die = drole_die;
	self.th_melee = drole_melee;
	self.th_missile = drole_magic;
	self.th_pain = drole_pain;

	if (self.spawnflags & TRIGGER_SPAWN)
	{
		self.use = drole_begin;
		total_monsters = total_monsters + 1;
		return;
	}

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel (self, "progs/drole.mdl");

	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	self.health = 500;

	
	walkmonster_start();
};


/*
===========
Drole Check attack

The player is in view, so decide to move or launch an attack
Returns FALSE if movement should continue, also chooses what kind of movement to do.
============
*/
float() DroleCheckAttack =
{
	local vector	spot1, spot2;	
	local entity	targ;
	local float	chance, enemydistance;



	if (!enemy_vis)
		return FALSE;

	if (enemy_range == RANGE_FAR)
	{
		if (self.attack_state != AS_STRAIGHT)
		{
			self.attack_state = AS_STRAIGHT;
			drole_run1 ();
		}
		return FALSE;
	}


	targ = self.enemy;
	
// see if any entities are in the way of the shot
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;

	traceline (spot1, spot2, FALSE, self);

	if (trace_ent != targ)
		return FALSE;		// don't have a clear shot
			
	if (trace_inopen && trace_inwater)
		return FALSE;			// sight line crossed contents
		
	enemydistance = vlen (self.enemy.origin - self.origin);
	
// melee attack

	if (enemydistance < 150)
	{
		self.th_melee ();
		return TRUE;
	}


// missile attack
		
	if (time < self.attack_finished)
		return FALSE;
		
	if (enemy_range == RANGE_FAR)
		return FALSE;

	if (self.badhealth == 0)
	{
		if (enemydistance >= 100)
			chance = 0.9;
	}
	else
	{
		if (enemydistance >= 100)
			chance = 0.3;
	}	


	if (random () < chance)
	{
		self.th_missile ();
		SUB_AttackFinished (1 + 2*random());
		return TRUE;
	}
	


	
	return FALSE;
};


