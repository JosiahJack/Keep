/*
=================================================================================

MELYTA - Converted from FrF - MadFox 11okt2021.

=================================================================================
*/

$cd /raid/quake/id1/models/melyta
$origin 0 -6 24
$base base		
$skin base

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9 stand10 
$frame stand11 stand12

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10
$frame walk11 walk12 walk13 walk14 walk15 

$frame run1 run2 run3 run4 run5 run6 run7 run8 

$frame pain1 pain2 pain3 pain4 

$frame paina1 paina2 paina3 paina4 

$frame painb1 painb2 painb3 painb4

$frame painc1 painc2 painc3 painc4

$frame attack1 attack2 attack3 attack4 attack5 attack6 

$frame runatk1 runatk2 runatk3 runatk4 runatk5 runatk6 runatk7 runatk8 

$frame nailatk1 nailatk2 

$frame dead1 dead2 dead3 dead4 dead5 dead6 dead7 dead8 dead9 dead10
$frame dead11 dead12 dead13 dead14 dead15 

$frame fdeath1 fdeath2 fdeath3 fdeath4 fdeath5 fdeath6 fdeath7 fdeath8 fdeath9 
$frame fdeath10 fdeath11 fdeath12 fdeath13 

//=====================================================================================

void(entity missile, float mspeed, float accuracy) MelyLaunchMissile =
{
	local	vector	vec, move;
	local	float	fly;

	makevectors2 (self.angles);
		
	// set missile speed
	vec = self.enemy.origin + self.enemy.mins + self.enemy.size * 0.7 - missile.origin;

	// calc aproximate time for missile to reach vec
	fly = vlen (vec) / mspeed;
	
	// get the entities xy velocity
	move = self.enemy.velocity;
	move_z = 0;

	// project the target forward in time
	vec = vec + move * fly;
	
	vec = normalize(vec);
	vec = vec + accuracy*v_up*(random()- 0.5) + accuracy*v_right*(random()- 0.5);
	
	missile.velocity = vec * mspeed;

	missile.angles = '0 0 0';
	missile.angles_y = vectoyaw(missile.velocity);

	// set missile duration
	missile.nextthink = time + 5;
	missile.think = SUB_Remove;	
};

void()	mely_run1;
void()  mely_walk1;

float()	MelyCheckAttack =
{
	local vector	spot1, spot2;	
	local entity	targ;
	local float		chance;

	if (time < self.attack_finished)
		return FALSE;

	if (!enemy_vis)
		return FALSE;

	if (enemy_range == RANGE_FAR)
	{
		if (self.attack_state != AS_STRAIGHT)
		{
			self.attack_state = AS_STRAIGHT;
			mely_run1 ();
		}
		return FALSE;
	}
		
	targ = self.enemy;
	
	// see if any entities are in the way of the shot
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;

	traceline (spot1, spot2, FALSE, self);

	if (trace_ent != targ)
	{	// don't have a clear shot, so move to a side
		if (self.attack_state != AS_STRAIGHT)
		{
			self.attack_state = AS_STRAIGHT;
			mely_run1 ();
		}
		return FALSE;
	}
			
	if (enemy_range == RANGE_MELEE)
		chance = 0.9;

	else if (enemy_range == RANGE_NEAR)
		chance = 0.6;

	else if (enemy_range == RANGE_MID)
		chance = 0.2;

	else
		chance = 0;

	if (random () < chance)
	{
		self.attack_state = AS_MISSILE;
		return TRUE;
	}

	if (enemy_range == RANGE_MID)
	{
		if (self.attack_state != AS_STRAIGHT)
		{
			self.attack_state = AS_STRAIGHT;
			mely_run1 ();
		}
	}
	else
	{
		if (self.attack_state != AS_SLIDING)
		{
			self.attack_state = AS_SLIDING;
			mely_walk1 ();
		}
	}
	
	return FALSE;
};

void()	MelyAttackFinished =
{
	if (enemy_range >= RANGE_MID || !enemy_vis)
	{
		self.attack_state = AS_STRAIGHT;
		self.think = mely_run1;
	}

	else
	{
		self.attack_state = AS_SLIDING;
		self.think = mely_walk1;
	}
};

void() Mely_FastFire =
{
	local vector		vec;
	local vector		dst;

	if (self.owner.health > 0)
	{
		self.owner.effects = self.owner.effects | EF_MUZZLEFLASH;

		makevectors2 (self.enemy.angles);	
		dst = self.enemy.origin - 13*self.movedir;
	
		vec = normalize(dst - self.origin);
		sound (self, CHAN_WEAPON, "wizard/wattack.wav", 1, ATTN_NORM);
		launch_spike (self.origin, vec);
		newmis.velocity = vec*600;
		newmis.owner = self.owner;
		newmis.classname = "wizard_spike";		//changed it to be consistant --gnounc
		setmodel (newmis, "progs/w_spike.mdl");
		setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);		
	}

	remove (self);
};

void() Mely_StartFast =
{
	local	entity	missile;
	
	sound (self, CHAN_WEAPON, "militia/attack.wav", 1, ATTN_NORM);
	self.v_angle = self.angles;
	makevectors2 (self.angles);

	missile = spawn ();
	missile.owner = self;
	missile.nextthink = time + 0.6;
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, self.origin + '0 0 30' + v_forward*14 + v_right*14);
	missile.enemy = self.enemy;
	missile.nextthink = time + 0.8;
	missile.think = Mely_FastFire;
	missile.movedir = v_right;

//	missile = spawn ();
//	missile.owner = self;
//	missile.nextthink = time + 1;
//	setsize (missile, '0 0 0', '0 0 0');		
//	setorigin (missile, self.origin + '0 0 30' + v_forward*14 + v_right* -14);
//	missile.enemy = self.enemy;
//	missile.nextthink = time + 0.3;
//	missile.think = Demfo_FastFire;
//	missile.movedir = VEC_ORIGIN - v_right;
};



//================================================================================

void()	mely_stand1	=[	$stand1,  	mely_stand2	] {ai_stand();};
void()	mely_stand2	=[	$stand2,  	mely_stand3	] {ai_stand();};
void()	mely_stand3	=[	$stand3,  	mely_stand4	] {ai_stand();};
void()	mely_stand4	=[	$stand4,  	mely_stand5	] {ai_stand();};
void()	mely_stand5	=[	$stand5,  	mely_stand6	] {ai_stand();};
void()	mely_stand6	=[	$stand6,  	mely_stand7	] {ai_stand();};
void()	mely_stand7	=[	$stand7,  	mely_stand8	] {ai_stand();};
void()	mely_stand8	=[	$stand8,  	mely_stand9	] {ai_stand();};
void()	mely_stand9	=[	$stand9,  	mely_stand10	] {ai_stand();};
void()	mely_stand10	=[	$stand10, 	mely_stand11	] {ai_stand();};
void()	mely_stand11	=[	$stand11, 	mely_stand12	] {ai_stand();};
void()	mely_stand12	=[	$stand12, 	mely_stand1	] {ai_stand();};

void()	mely_walk1	=[	$walk1,  	mely_walk2	] 
{
	if (random() < 0.2)
		sound (self, CHAN_VOICE, "militia/idle.wav", 1, ATTN_IDLE);
	ai_walk(2);
};
void()	mely_walk2	=[	$walk2,  	mely_walk3	] {ai_walk(3);};
void()	mely_walk3	=[	$walk3,  	mely_walk4	] {ai_walk(4);};
void()	mely_walk4	=[	$walk4,  	mely_walk5	] {ai_walk(5);};
void()	mely_walk5	=[	$walk5,  	mely_walk6	] {ai_walk(6);};
void()	mely_walk6	=[	$walk6,  	mely_walk7	] {ai_walk(7);};
void()	mely_walk7	=[	$walk7,  	mely_walk8	] {ai_walk(7);};
void()	mely_walk8	=[	$walk8,  	mely_walk9	] {ai_walk(6);};
void()	mely_walk9	=[	$walk9,  	mely_walk10	] {ai_walk(5);};
void()	mely_walk10	=[	$walk10, 	mely_walk11	] {ai_walk(4);};
void()	mely_walk11	=[	$walk11, 	mely_walk12	] {ai_walk(3);};
void()	mely_walk12	=[	$walk12, 	mely_walk13	] {ai_walk(2);};
void()	mely_walk13	=[	$walk13, 	mely_walk14	] {ai_walk(3);};
void()	mely_walk14	=[	$walk14,  	mely_walk15	] {ai_walk(4);};
void()	mely_walk15	=[	$walk15,  	mely_walk1	] {ai_walk(5);};

void()	mely_run1	=[	$run1,  	mely_run2	]
{
	if (random() < 0.2)
		sound (self, CHAN_VOICE, "militia/idle.wav", 1, ATTN_IDLE);
	ai_run(4);
};
void()	mely_run2	=[	$run2,  	mely_run3	] {ai_run(6);};
void()	mely_run3	=[	$run3,  	mely_run4	] {ai_run(8);};
void()	mely_run4	=[	$run4,  	mely_run5	] {ai_run(10);};
void()	mely_run5	=[	$run5,  	mely_run6	] {ai_run(12);};
void()	mely_run6	=[	$run6,  	mely_run7	] {ai_run(8);};
void()	mely_run7	=[	$run7,  	mely_run8	] {ai_run(4);};
void()	mely_run8	=[	$run8,  	mely_run1	] {ai_run(6);};

//==============================================================================

void()	mely_pain1	=[	$pain1,		mely_pain2	] {};
void()	mely_pain2	=[	$pain2,		mely_pain3	] {};
void()	mely_pain3	=[	$pain3,		mely_pain4	] {};
void()	mely_pain4	=[	$pain4,		mely_run1	] {};

void()	mely_paina1	=[	$paina1,	mely_paina2	] {};
void()	mely_paina2	=[	$paina2,	mely_paina3	] {};
void()	mely_paina3	=[	$paina3,	mely_paina4	] {};
void()	mely_paina4	=[	$paina4,	mely_run1	] {};

void()	mely_painb1	=[	$painb1,	mely_painb2	] {};
void()	mely_painb2	=[	$painb2,	mely_painb3	] {};
void()	mely_painb3	=[	$painb3,	mely_painb4	] {};
void()	mely_painb4	=[	$painb4,	mely_run1	] {};

void()	mely_painc1	=[	$painc1,	mely_painc2	] {};
void()	mely_painc2	=[	$painc2,	mely_painc3	] {};
void()	mely_painc3	=[	$painc3,	mely_painc4	] {};
void()	mely_painc4	=[	$painc4,	mely_run1	] {};

void(entity attacker, float damage)	mely_pain =
{
	local float	r;

// don't make multiple pain sounds right after each other//
////	if (self.pain_finished > time)
		return;

	sound (self, CHAN_VOICE, "militia/pain2.wav", 1, ATTN_IDLE);		

	r = random();
	
	if (r < 0.2)
	{
		mely_pain1 ();
		self.pain_finished = time + 0.1;
	}
	else if (r < 0.6)
	{
		mely_paina1 ();
		self.pain_finished = time + 0.1;
        } 
       	else if (r < 0.85)
	{
		mely_painb1 ();
		self.pain_finished = time + 0.1;
	} 
	else
	{
		mely_painc1 ();
		self.pain_finished = time + 0.1;
	}
        
};
//==============================================================================

void()	mely_atka1	=[	$attack1, 	mely_atka2	] {ai_face(); Mely_StartFast();};
void()	mely_atka2	=[	$attack2, 	mely_atka3	] {ai_face();};
void()	mely_atka3	=[	$attack3, 	mely_atka4	] {ai_face();};
void()	mely_atka4	=[	$attack4, 	mely_atka5	] {ai_face();};
void()	mely_atka5	=[	$attack5, 	mely_atka6	] {ai_charge(13);};
void()	mely_atka6	=[	$attack6, 	mely_run1	] {ai_face(); SUB_AttackFinished(2); MelyAttackFinished();};

void()	mely_atkb1	=[	$runatk1, 	mely_atkb2	] {ai_face();};
void()	mely_atkb2	=[	$runatk2, 	mely_atkb3	] {ai_face();};
void()	mely_atkb3	=[	$runatk3, 	mely_atkb4	] {ai_face();};
void()	mely_atkb4	=[	$runatk4, 	mely_atkb5	] {ai_face(); Mely_StartFast();};
void()	mely_atkb5	=[	$runatk5, 	mely_atkb6	] {ai_charge(13);};
void()	mely_atkb6	=[	$runatk6, 	mely_atkb7	] {ai_charge(4);};
void()	mely_atkb7	=[	$runatk7, 	mely_atkb8	] {ai_face();};
void()	mely_atkb8	=[	$runatk8, 	mely_run1	] {ai_face(); SUB_AttackFinished(2); MelyAttackFinished();};

//==============================================================================

void()	mely_dead1	=[	$dead1,  	mely_dead2	] {};
void()	mely_dead2	=[	$dead2,  	mely_dead3	] {};
void()	mely_dead3	=[	$dead3,  	mely_dead4	] {};
void()	mely_dead4	=[	$dead4,  	mely_dead5	] {};
void()	mely_dead5	=[	$dead5,  	mely_dead6	] {};
void()	mely_dead6	=[	$dead6,  	mely_dead7	] {};
void()	mely_dead7	=[	$dead7,  	mely_dead8	] {};
void()	mely_dead8	=[	$dead8,  	mely_dead9	] {};
void()	mely_dead9	=[	$dead9,  	mely_dead10	] {};
void()	mely_dead10	=[	$dead10, 	mely_dead11	] {};
void()	mely_dead11	=[	$dead11, 	mely_dead12	] {};
void()	mely_dead12	=[	$dead12, 	mely_dead13	] {};
void()	mely_dead13	=[	$dead13, 	mely_dead14	] {};
void()	mely_dead14	=[	$dead14, 	mely_dead15	] {};
void()	mely_dead15	=[	$dead15, 	mely_dead15	] {};

void()	mely_death1	=[	$death1,  	mely_death2	] {};
void()	mely_death2	=[	$death2,  	mely_death3	] {};
void()	mely_death3	=[	$death3,  	mely_death4	] {};
void()	mely_death4	=[	$death4,  	mely_death5	] {};
void()	mely_death5	=[	$death5,  	mely_death6	] {};
void()	mely_death6	=[	$death6,  	mely_death7	] {};
void()	mely_death7	=[	$death7,  	mely_death8	] {};
void()	mely_death8	=[	$death8,  	mely_death9	] {};
void()	mely_death9	=[	$death9,  	mely_death10	] {};
void()	mely_death10	=[	$death10, 	mely_death11	] {};
void()	mely_death11	=[	$death11, 	mely_death12	] {};
void()	mely_death12	=[	$death12, 	mely_death13	] {};
void()	mely_death13	=[	$death13, 	mely_death13] {};

void() mely_die =
{
	// check for gib
	if (self.health < -35)
	{
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		ThrowHead ("progs/h_demon.mdl", self.health);
		ThrowGib ("progs/gib1.mdl", self.health);
		ThrowGib ("progs/gib2.mdl", self.health);
		ThrowGib ("progs/gib3.mdl", self.health);

		return;
	}

	// regular death
	sound (self, CHAN_VOICE, "militia/death.wav", 1, ATTN_NORM);

	if (random() > 0.5)
		mely_dead1 ();

	else
		mely_death1 ();
};

//==============================================================================

void() mely_melee =
{
	if (random() > 0.2)
		mely_atka1 ();

};

//==============================================================================

/*QUAKED monster_mely (1 0 0) (-16 -16 -24) (16 16 40) Ambush*/
void() monster_mely =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	precache_model2 ("progs/melyta.mdl");
	precache_model2 ("progs/h_melyta.mdl");
	precache_model ("progs/w_spike.mdl");

	precache_sound ("militia/attack.wav");		// used by c code
	precache_sound ("militia/death.wav");
	precache_sound ("militia/idle.wav");
	precache_sound ("militia/pain1.wav");
	precache_sound ("militia/pain2.wav");
	precache_sound ("militia/sight.wav");
	
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/melyta.mdl");

	//gnounc
	self.netname = "melyta";

	setsize (self, '-22 -18 -24', '22 18 40');
	self.health = 150;
	self.max_health = 150;

	self.th_stand = mely_stand1;
	self.th_walk = mely_walk1;
	self.th_run = mely_run1;
	self.th_pain = mely_pain;
	self.th_die = mely_die;
	self.th_melee = mely_melee;
        self.th_missile = mely_atkb1;
	
	walkmonster_start();
};
