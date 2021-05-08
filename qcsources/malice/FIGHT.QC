float (float v) anglemod;
void (vector dest3) ChooseTurn;
void () ai_face;
float enemy_vis;
float enemy_infront;
float enemy_range;
float enemy_yaw;

float () CheckAttack =
{
	local vector spot1;
	local vector spot2;
	local entity targ;
	local float chance;

	targ = self.enemy;
	spot1 = (self.origin + self.view_ofs);
	spot2 = (targ.origin + targ.view_ofs);
	traceline (spot1, spot2, FALSE, self);
	if ((trace_ent != targ))
		return (FALSE);
	if ((trace_inopen && trace_inwater))
		return (FALSE);
	if ((enemy_range == RANGE_MELEE))
	{
		if (self.th_melee)
		{
			self.th_melee ();
			return (TRUE);
		}
	}
	if (!self.th_missile)
		return (FALSE);
	if ((time < self.attack_finished))
		return (FALSE);
	if ((enemy_range == RANGE_FAR))
		return (FALSE);
	if ((enemy_range == RANGE_MELEE))
	{
		chance = 0.9;
		self.attack_finished = 0.00;
	}
	else
	{
		if ((enemy_range == RANGE_NEAR))
		{
			if (self.th_melee)
				chance = 0.2;
			else
				chance = 0.4;
		}
		else
		{
			if ((enemy_range == RANGE_MID))
			{
				if (self.th_melee)
					chance = 0.05;
				else
					chance = 0.1;
			}
			else
				chance = 0;
		}
	}
	if ((random () < chance))
	{
		self.th_missile ();
		SUB_AttackFinished ((SEARCH * random ()));
		return (TRUE);
	}
	return (FALSE);
};


void () ai_face =
{
	self.ideal_yaw = vectoyaw ((self.enemy.origin - self.origin));
	ChangeYaw ();
};

float (entity targ) infront;
float (entity targ) range;

void (float d) ai_charge =
{
	ai_face ();
	movetogoal (d);
};


void () ai_charge_side =
{
	local vector dtemp;
	local float heading;

	self.ideal_yaw = vectoyaw ((self.enemy.origin - self.origin));
	ChangeYaw ();
	makevectors (self.angles);
	dtemp = (self.enemy.origin - (30 * v_right));
	heading = vectoyaw ((dtemp - self.origin));
	walkmove (heading, 20);
};


void () ai_melee =
{
	local vector delta;
	local float ldmg;

	if (!self.enemy)
		return;
	delta = (self.enemy.origin - self.origin);
	if ((vlen (delta) > 60))
		return;
	ldmg = (((random () + random ()) + random ()) * 3);
	T_Damage (self.enemy, self, self, ldmg);
};


void () ai_melee_side =
{
	local vector delta;
	local float ldmg;

	if (!self.enemy)
		return;
	ai_charge_side ();
	delta = (self.enemy.origin - self.origin);
	if ((vlen (delta) > 60))
		return;
	if (!CanDamage (self.enemy, self))
		return;
	ldmg = (((random () + random ()) + random ()) * 3);
	T_Damage (self.enemy, self, self, ldmg);
};

/*
// ACC, Quake-only, removed
float () SoldierCheckAttack =
{
	local vector spot1;
	local vector spot2;
	local entity targ;
	local float chance;

	targ = self.enemy;
	spot1 = (self.origin + self.view_ofs);
	spot2 = (targ.origin + targ.view_ofs);
	traceline (spot1, spot2, FALSE, self);
	if ((trace_inopen && trace_inwater))
		return (FALSE);
	if ((trace_ent != targ))
		return (FALSE);
	if ((time < self.attack_finished))
		return (FALSE);
	if ((enemy_range == RANGE_FAR))
		return (FALSE);
	if ((enemy_range == RANGE_MELEE))
		chance = 0.9;
	else
	{
		if ((enemy_range == RANGE_NEAR))
			chance = 0.4;
		else
		{
			if ((enemy_range == RANGE_MID))
				chance = 0.05;
			else
				chance = 0;
		}
	}
	if ((random () < chance))
	{
		self.th_missile ();
		SUB_AttackFinished ((1.00 + random ()));
		if ((random () < 0.3))
			self.lefty = !self.lefty;
		return (TRUE);
	}
	return (FALSE);
};
*/

/*
// ACC, Quake-only, removed
float () ShamCheckAttack =
{
	local vector spot1;
	local vector spot2;
	local entity targ;
	local float chance;

	if ((enemy_range == RANGE_MELEE))
	{
		if (CanDamage (self.enemy, self))
		{
			self.attack_state = AS_MELEE;
			return (TRUE);
		}
	}
	if ((time < self.attack_finished))
		return (FALSE);
	if (!enemy_vis)
		return (FALSE);
	targ = self.enemy;
	spot1 = (self.origin + self.view_ofs);
	spot2 = (targ.origin + targ.view_ofs);
	if ((vlen ((spot1 - spot2)) > 600))
		return (FALSE);
	traceline (spot1, spot2, FALSE, self);
	if ((trace_inopen && trace_inwater))
		return (FALSE);
	if ((trace_ent != targ))
		return (FALSE);
	if ((enemy_range == RANGE_FAR))
		return (FALSE);
	self.attack_state = AS_MISSILE;
	SUB_AttackFinished ((SEARCH + (SEARCH * random ())));
	return (TRUE);
};
*/

/*
// ACC, Quake-only, removed
float () OgreCheckAttack =
{
	local vector spot1;
	local vector spot2;
	local entity targ;
	local float chance;

	if ((enemy_range == RANGE_MELEE))
	{
		if (CanDamage (self.enemy, self))
		{
			self.attack_state = AS_MELEE;
			return (TRUE);
		}
	}
	if ((time < self.attack_finished))
		return (FALSE);
	if (!enemy_vis)
		return (FALSE);
	targ = self.enemy;
	spot1 = (self.origin + self.view_ofs);
	spot2 = (targ.origin + targ.view_ofs);
	traceline (spot1, spot2, FALSE, self);
	if ((trace_inopen && trace_inwater))
		return (FALSE);
	if ((trace_ent != targ))
		return (FALSE);
	if ((time < self.attack_finished))
		return (FALSE);
	if ((enemy_range == RANGE_FAR))
		return (FALSE);
	else
	{
		if ((enemy_range == RANGE_NEAR))
			chance = 0.1;
		else
		{
			if ((enemy_range == RANGE_MID))
				chance = 0.05;
			else
				chance = 0;
		}
	}
	self.attack_state = AS_MISSILE;
	SUB_AttackFinished ((1.00 + (SEARCH * random ())));
	return (TRUE);
};
*/
