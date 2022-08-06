void() knight_attack = 
{
	local float len;
	len = vlen(self.enemy.origin + self.enemy.view_ofs - (self.origin + self.view_ofs));
};

float() CheckAttack = 
{
	local vector spot1;
	local vector spot2;
	local entity targ;
	local float chance;
};

void() ai_face = 
{
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	ChangeYaw();
};

void(float d) ai_charge = 
{
	ai_face();
	movetogoal(d);
};

void() ai_charge_side = 
{
	local vector dtemp;
	local float heading;
};

void() ai_melee = 
{
	local vector delta;
	local float ldmg;
};

void() ai_melee_side = 
{
	local vector delta;
	local float ldmg;
};

void() SoldierCheckAttack = 
{
	local vector spot1;
	local vector spot2;
	local entity targ;
	local float chance;
};

void() ShamCheckAttack = 
{
	local vector spot1;
	local vector spot2;
	local entity targ;
	local float chance;
	if (enemy_range == RANGE_MELEE)
	{
		if (CanDamage(self.enemy, self))
		{
			self.attack_state = AS_MELEE;
			return 1;
		}
	}
	if (time < self.attack_finished)
	{
		return 0;
	}
	if (!enemy_vis)
	{
		return 0;
	}
	targ = self.enemy;
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;
	if (vlen(spot1 - spot2) > 600)
	{
		return 0;
	}
	traceline(spot1, spot2, 0, self);
	if (trace_inopen && trace_inwater)
	{
		return 0;
	}
	if (trace_ent != targ)
	{
		return 0;
	}
	if (enemy_range == RANGE_FAR)
	{
		return 0;
	}
	self.attack_state = AS_MISSILE;
	SUB_AttackFinished(2 + 2 * random());
	return 1;
};

void() OgreCheckAttack = 
{
	local vector spot1;
	local vector spot2;
	local entity targ;
	local float chance;
	if (enemy_range == RANGE_MELEE)
	{
		if (CanDamage(self.enemy, self))
		{
			self.attack_state = AS_MELEE;
			return 1;
		}
	}
	if (time < self.attack_finished)
	{
		return 0;
	}
	if (!enemy_vis)
	{
		return 0;
	}
	targ = self.enemy;
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;
	traceline(spot1, spot2, 0, self);
	if (trace_inopen && trace_inwater)
	{
		return 0;
	}
	if (trace_ent != targ)
	{
		return 0;
	}
	if (time < self.attack_finished)
	{
		return 0;
	}
	if (enemy_range == RANGE_FAR)
	{
		return 0;
	}
	else
	{
		if (enemy_range == RANGE_NEAR)
		{
			chance = 0.1;
		}
		else
		{
			if (enemy_range == RANGE_MID)
			{
				chance = 0.05;
			}
			else
			{
				chance = 0;
			}
		}
	}
	self.attack_state = AS_MISSILE;
	SUB_AttackFinished(1 + 2 * random());
	return 1;
};

