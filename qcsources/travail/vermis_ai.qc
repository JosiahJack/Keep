.vector		oldenemyorigin;


void() ai_shotcheck =
{
	if (visible(self.enemy))
		self.oldenemyorigin = self.enemy.origin;

};

/*
=============
ai_face

Stay facing the enemy
=============
*/
void() ai_vermis_face =
{

	if (visible(self.enemy))
		self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	else
		self.ideal_yaw = vectoyaw(self.oldenemyorigin - self.origin);
	ChangeYaw ();
};

/*
=============
ai_stand

waiting for the player.
=============
*/
void() ai_vermis_stand =
{
	if (VermisFindTarget ())
		return;
	

};



//=============================================================================



float() CheckVermisAttack =
{
	local vector	spot1, spot2;	
	local entity	targ;
	local float		chance;
	local	float	dist;

	targ = self.enemy;

	dist = vlen(self.enemy.origin - self.origin);
	
// see if any entities are in the way of the shot
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;

	traceline (spot1, spot2, FALSE, self);

	//if (trace_ent != targ)
	//	return FALSE;		// don't have a clear shot
			
	if (trace_inopen && trace_inwater)
		return FALSE;			// sight line crossed contents

	if (dist < 340 && self.enemy.movetype != MOVETYPE_FLY)
	{	// melee attack
		if (self.th_melee)
		{
			self.th_melee ();
			return TRUE;
		}
	}
	
// missile attack
	if (!self.th_missile)
		return FALSE;
		
	if (time < self.attack_finished)
		return FALSE;
		
	chance = 0.9;

	if (trace_ent != targ && random() < 0.3)
		return FALSE;

	if (random () < chance)
	{
		self.th_missile ();
		SUB_AttackFinished (2 + 1*random());
		return TRUE;
	}

	return FALSE;
};






/*
=============
ai_vermis_run

The vermis has an enemy it is trying to kill
=============
*/
void() ai_vermis_run =
{
	local	vector	delta;
	local	float	axis;
	local	float	direct, ang_rint, ang_floor, ang_ceil;
	
	// see if the enemy is dead
	if (!IsAlive(self.enemy))
	{
		self.enemy = world;
	// FIXME: look all around for other targets
		if (IsAlive(self.oldenemy))
		{
			self.enemy = self.oldenemy;
			HuntTarget ();
		}
		else
		{
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

	CheckVermisAttack();


	
	ai_vermis_face(); //always try to face the enemy.
	ai_shotcheck();
	//no movetogoal here, baby!
};
