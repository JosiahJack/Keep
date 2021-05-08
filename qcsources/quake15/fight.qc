
/*

A monster is in fight mode if it thinks it can effectively attack its
enemy.

When it decides it can't attack, it goes into hunt mode.

*/

float(float v) anglemod;

void() knight_atk1;
void() knight_runatk1;
void() ogre_smash1;
void() ogre_swing1;

void() sham_smash1;
void() sham_swingr1;
void() sham_swingl1;

float()	DemonCheckAttack;
void(float side)	Demon_Melee;
//void(float side)	intershamb_Melee;
void(vector org, vector vel) SpawnMeatSpray;

void(vector dest) ChooseTurn;

void() ai_face;


float	enemy_vis, enemy_infront, enemy_range;
float	enemy_yaw;


void() knight_attack =
{
	local float		len;
	
// decide if now is a good swing time
	len = vlen(self.enemy.origin+self.enemy.view_ofs - (self.origin+self.view_ofs));
	
	if (len<80)
		knight_atk1 ();
	else
		knight_runatk1 ();
};

//=============================================================================

/*
===========
CheckAttack

The player is in view, so decide to move or launch an attack
Returns FALSE if movement should continue
============
*/
float() CheckAttack =
{
	local vector	spot1, spot2;	
	local entity	targ;
	local float		chance;

	targ = self.enemy;
	
// see if any entities are in the way of the shot
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;

	traceline (spot1, spot2, FALSE, self);

	if (trace_ent != targ)
		return FALSE;		// don't have a clear shot
			
	if (trace_inopen && trace_inwater)
		return FALSE;			// sight line crossed contents

	if (enemy_range == RANGE_MELEE)
	{	// melee attack
		if (self.th_melee)
		{
			if (self.classname == "monster_knight")
				knight_attack ();
			else
			{
				self.th_melee ();
				if (self.classname == "monster_reiver")
					self.meleeing = 1;
			}	
			return TRUE;
		}
	}
	
// missile attack
	if (!self.th_missile)
		return FALSE;

	if (self.classname == "monster_reiver")
		self.meleeing = 0;
	
	if (time < self.attack_finished)
		return FALSE;
		
	if (enemy_range == RANGE_FAR)
		return FALSE;
		
	if (enemy_range == RANGE_MELEE)
	{
		chance = 0.9;
		self.attack_finished = 0;
	}
	else if (enemy_range == RANGE_NEAR)
	{
		if (self.th_melee)
			chance = 0.2;
		else
			chance = 0.4;
	}
	else if (enemy_range == RANGE_MID)
	{
		if (self.th_melee)
			chance = 0.05;
		else
			chance = 0.1;
	}
	else
		chance = 0;

	if (random () < chance)
	{
		self.th_missile ();
		
		if (autocvar_skill_adjusted_monster_rangedattack_frequence)
		{
			if (skill == 0)
				SUB_AttackFinished (2*random());
			else if (skill == 1)
				SUB_AttackFinished (1.6*random());
			else if (skill == 2)
				SUB_AttackFinished (1.3*random());
			else
				SUB_AttackFinished (1*random());	// will be overriden by  SUB_CheckRefire  or not be used in skill 3 by  SUB_AttackFinished  anyhow !!
		}
		else
			SUB_AttackFinished (2*random());
		 
		return TRUE;
	}

	return FALSE;
};


/*
=============
ai_face

Stay facing the enemy
=============
*/
void() ai_face =
{
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	ChangeYaw ();
};

/*
=============
ai_charge

The monster is in a melee attack, so get as close as possible to .enemy
=============
*/
float (entity targ) visible;
float(entity targ) infront;
float(entity targ) range;

void(float d) ai_charge =
{
	ai_face ();	
	movetogoal (d);		// done in C code...
};

void() ai_charge_side =
{
	local	vector	dtemp;
	local	float	heading;
	
// aim to the left of the enemy for a flyby

	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	ChangeYaw ();

	makevectors (self.angles);
	dtemp = self.enemy.origin - 30*v_right;
	heading = vectoyaw(dtemp - self.origin);
	
	walkmove(heading, 20);
};


/*
=============
ai_melee

=============
*/
void() ai_melee =
{
	local vector	delta;
	local float 	ldmg;

	if (!self.enemy)
		return;		// removed before stroke
		
	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 60)
		return;
		
	ldmg = (random() + random() + random()) * 3;
	T_Damage (self.enemy, self, self, ldmg);
};


void(float scratch_noise) ai_melee_carnivean =
{
	local vector	delta;
	local float 	ldmg;

	if (!self.enemy)
		return;		// removed before stroke

	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 100)
		return;
		
	ldmg = (random() + random() + random()) * autocvar_carnivean_scythe_damage;	// default 4
	T_Damage (self.enemy, self, self, ldmg);
	
	makevectors (self.angles);
	particle (self.origin + v_forward*50 + v_up*2, '0 0 0', 73, 17);		// spawn a little blood

	if (scratch_noise)
	{
		sound (self, CHAN_AUTO, "demon/dhit2.wav", 0.5, ATTN_NORM);
		local float richtung;
		richtung = crandom () * 100;
		SpawnMeatSpray (self.origin + v_forward * 30 + v_up*-5, v_right * richtung);	// spawn a little gore
	}
};


void() ai_melee_torment =
{
	local vector	delta;
	local float 	ldmg;

	if (!self.enemy)
		return;		// removed before stroke
		
	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 77)
		return;
		
	ldmg = (random() + random() + random()) * autocvar_torment_rod_melee;	// default 4
	T_Damage (self.enemy, self, self, ldmg);
};


void() ai_melee_hknight =
{
	local vector	delta;
	local float 	ldmg;

	if (!self.enemy)
		return;		// removed before stroke
		
	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 60)
		return;

    var float autocvar_hknight_size_influenced_attack = 0; 	 	// set cvar 'hknight_size_influenced_attack' default to 0
	if (autocvar_hknight_size_influenced_attack == 1)		// if 'hknight_size_influenced_attack' is set via autoexec.cfg to '1' raise monster´s attack values according to its size 
		ldmg = (random() + random() + random()) * autocvar_hellknight_sword * self.scale;	// default 3
	else
		ldmg = (random() + random() + random()) * autocvar_hellknight_sword;			// default 3
	T_Damage (self.enemy, self, self, ldmg);
};

void() ai_melee_dfury =
{
	local vector	delta;
	local float 	ldmg;

	if (!self.enemy)
		return;		// removed before stroke
		
	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 60)
		return;

    var float autocvar_hknight_size_influenced_attack = 0; 	 	// set cvar 'hknight_size_influenced_attack' default to 0
	if (autocvar_hknight_size_influenced_attack == 1)		// if 'hknight_size_influenced_attack' is set via autoexec.cfg to '1' raise monsterÕ³ attack values according to its size 
		ldmg = (random() + random() + random()) * autocvar_hellknight_sword * self.scale;	// default 3
	else
		ldmg = (random() + random() + random()) * autocvar_hellknight_sword;			// default 3
	T_Damage (self.enemy, self, self, ldmg);
};

void() ai_melee_dfury_boss =
{
	local vector	delta;
	local float 	ldmg;

	if (!self.enemy)
		return;		// removed before stroke
		
	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 80)
		return;

	ldmg = (random() + random() + random()) * 6;			// default 3
	T_Damage (self.enemy, self, self, ldmg);
};


void() ai_melee_knight =
{
	local vector	delta;
	local float 	ldmg;

	if (!self.enemy)
		return;		// removed before stroke
		
	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 60)
		return;

    var float autocvar_knight_size_influenced_attack = 0; 	 	// set cvar 'knight_size_influenced_attack' default to 0
	if (autocvar_knight_size_influenced_attack == 1)		// if 'knight_size_influenced_attack' is set via autoexec.cfg to '1' raise monster´s attack values according to its size 
		ldmg = (random() + random() + random()) * autocvar_knight_sword * self.scale;	// default 3
	else
		ldmg = (random() + random() + random()) * autocvar_knight_sword;		// default 3
	T_Damage (self.enemy, self, self, ldmg);
};


void() ai_melee_side =
{
	local vector	delta;
	local float 	ldmg;

	if (!self.enemy)
		return;		// removed before stroke
		
	ai_charge_side();
	
	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 60)
		return;
	if (!CanDamage (self.enemy, self))
		return;
	ldmg = (random() + random() + random()) * 3;
	T_Damage (self.enemy, self, self, ldmg);
};


void() ai_melee_side_knight =
{
	local vector	delta;
	local float 	ldmg;

	if (!self.enemy)
		return;		// removed before stroke
		
	ai_charge_side();
	
	delta = self.enemy.origin - self.origin;

	if (vlen(delta) > 60)
		return;
	if (!CanDamage (self.enemy, self))
		return;

    var float autocvar_knight_size_influenced_attack = 0; 	 	// set cvar 'knight_size_influenced_attack' default to 0
	if (autocvar_knight_size_influenced_attack == 1)		// if 'knight_size_influenced_attack' is set via autoexec.cfg to '1' raise monster´s attack values according to its size 
		ldmg = (random() + random() + random()) * autocvar_knight_sword * self.scale;	// default 3
	else
		ldmg = (random() + random() + random()) * autocvar_knight_sword;		// default 3
	T_Damage (self.enemy, self, self, ldmg);
};


//=============================================================================

/*
===========
SoldierCheckAttack

The player is in view, so decide to move or launch an attack
Returns FALSE if movement should continue
============
*/
float() SoldierCheckAttack =
{
	local vector	spot1, spot2;	
	local entity	targ;
	local float		chance;

	targ = self.enemy;
	
// see if any entities are in the way of the shot
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;

	traceline (spot1, spot2, FALSE, self);

	if (trace_inopen && trace_inwater)
		return FALSE;			// sight line crossed contents

	if (trace_ent != targ)
		return FALSE;	// don't have a clear shot
			
	
// missile attack
	if (time < self.attack_finished)
		return FALSE;
		
	if (enemy_range == RANGE_FAR)
		return FALSE;
		
	if (enemy_range == RANGE_MELEE)
		chance = 0.9;
	else if (enemy_range == RANGE_NEAR)
		chance = 0.4;
	else if (enemy_range == RANGE_MID)
		chance = 0.05;
	else
		chance = 0;

	if (random () < chance)
	{
		self.th_missile ();
		if (autocvar_skill_adjusted_monster_rangedattack_frequence)
		{
			if (skill == 0)
				SUB_AttackFinished (1 + random());
			else if (skill == 1)
				SUB_AttackFinished (0.75 + random());
			else if (skill == 2)
				SUB_AttackFinished (0.5 + random());
			else
				SUB_AttackFinished (1 + random());	// will be overriden by  SUB_CheckRefire  anyhow !!
		}
		else
			SUB_AttackFinished (1 + random());
			
		if (random() < 0.3)
			self.lefty = !self.lefty;

		return TRUE;
	}

	return FALSE;
};
//=============================================================================

/*
===========
ShamCheckAttack

The player is in view, so decide to move or launch an attack
Returns FALSE if movement should continue
============
*/
float() ShamCheckAttack =
{
	local vector	spot1, spot2;	
	local entity	targ;

	if (enemy_range == RANGE_MELEE)
	{
		if (CanDamage (self.enemy, self))
		{
			self.attack_state = AS_MELEE;
			return TRUE;
		}
	}

	if (time < self.attack_finished)
		return FALSE;
	
	if (!enemy_vis)
		return FALSE;
		
	targ = self.enemy;
	
// see if any entities are in the way of the shot
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;

	if (vlen(spot1 - spot2) > 600)
		return FALSE;

	traceline (spot1, spot2, FALSE, self);

	if (trace_inopen && trace_inwater)
		return FALSE;			// sight line crossed contents

	if (trace_ent != targ)
	{
		return FALSE;	// don't have a clear shot
	}
			
// missile attack
	if (enemy_range == RANGE_FAR)
		return FALSE;
		
	self.attack_state = AS_MISSILE;
	
	if (autocvar_skill_adjusted_monster_rangedattack_frequence)
	{
		if (skill == 0)
			SUB_AttackFinished (2 + 2*random());
		else if (skill == 1)
			SUB_AttackFinished (1.4 + 2*random());
		else if (skill == 2)
			SUB_AttackFinished (0.8 + 2*random());
		else
			SUB_AttackFinished (2 + 2*random());	// will not be used in skill 3 by  SUB_AttackFinished  anyhow !!
	}
	else
		SUB_AttackFinished (2 + 2*random());

	return TRUE;
};

//============================================================================

/*
===========
OgreCheckAttack

The player is in view, so decide to move or launch an attack
Returns FALSE if movement should continue
============
*/
float() OgreCheckAttack =
{
	local vector	spot1, spot2;	
	local entity	targ;
	local float		chance;

	if (enemy_range == RANGE_MELEE)
	{
		if (CanDamage (self.enemy, self))
		{
			self.attack_state = AS_MELEE;
			return TRUE;
		}
	}

	if (time < self.attack_finished)
		return FALSE;
	
	if (!enemy_vis)
		return FALSE;
		
	targ = self.enemy;
	
// see if any entities are in the way of the shot
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;

	traceline (spot1, spot2, FALSE, self);

	if (trace_inopen && trace_inwater)
		return FALSE;			// sight line crossed contents

	if (trace_ent != targ)
	{
		return FALSE;	// don't have a clear shot
	}
			
// missile attack
	if (time < self.attack_finished)
		return FALSE;
		
	if (enemy_range == RANGE_FAR)
		return FALSE;
		
	else if (enemy_range == RANGE_NEAR)
		chance = 0.10;
	else if (enemy_range == RANGE_MID)
		chance = 0.05;
	else
		chance = 0;

	self.attack_state = AS_MISSILE;
	
	if (autocvar_skill_adjusted_monster_rangedattack_frequence)
	{
		if (skill == 0)
			SUB_AttackFinished (1 + 2*random());
		else if (skill == 1)
			SUB_AttackFinished (0.75 + 2*random());
		else if (skill == 2)
			SUB_AttackFinished (0.5 + 2*random());
		else
			SUB_AttackFinished (1 + 2*random());	// will not be used in skill 3 by  SUB_AttackFinished  anyhow !!
	}
	else
		SUB_AttackFinished (1 + 2*random());
			
	return TRUE;
};

