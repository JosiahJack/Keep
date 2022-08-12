void() knight_attack = 
{
	local float len;
	len = vlen(self.enemy.origin + self.enemy.view_ofs - (self.origin + self.view_ofs));
	if (len < 80)
	{
		knight_atk1();
	}
	else
	{
		knight_runatk1();
	}
};

float() CheckAttack = 
{
	local vector spot1;
	local vector spot2;
	local entity targ;
	local float chance;
	targ = self.enemy;
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;
	traceline(spot1, spot2, 0, self);
	if (trace_ent != targ)
	{
		return 0;
	}
	if (trace_inopen && trace_inwater)
	{
		return 0;
	}
	if (enemy_range == RANGE_MELEE)
	{
		if (self.th_melee)
		{
			if (self.classname == "monster_knight")
			{
				knight_attack();
			}
			else
			{
				self.th_melee();
			}
			return 1;
		}
	}
	if (!(self.th_missile))
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
	if (enemy_range == RANGE_MELEE)
	{
		chance = 0.9;
		self.attack_finished = 0;
	}
	else
	{
		if (enemy_range == RANGE_NEAR)
		{
			if (self.th_melee)
			{
				chance = 0.2;
			}
			else
			{
				chance = 0.4;
			}
		}
		else
		{
			if (enemy_range == RANGE_MID)
			{
				if (self.th_melee)
				{
					chance = 0.05;
				}
				else
				{
					chance = 0.1;
				}
			}
			else
			{
				chance = 0;
			}
		}
	}
	if (random() < chance)
	{
		self.th_missile();
		SUB_AttackFinished(2 * random());
		return 1;
	}
	return 0;
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
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	ChangeYaw();
	makevectors(self.angles);
	dtemp = self.enemy.origin - 30 * v_right;
	heading = vectoyaw(dtemp - self.origin);
	walkmove(heading, 20);
};

void() ai_melee = 
{
	local vector delta;
	local float ldmg;
	if (!(self.enemy))
	{
		return;
	}
	delta = self.enemy.origin - self.origin;
	if (vlen(delta) > 60)
	{
		return;
	}
	random();
	ldmg = (random() + random() + random()) * 3;
	T_Damage(self.enemy, self, self, ldmg);
};

void() ai_melee_side = 
{
	local vector delta;
	local float ldmg;
	if (!(self.enemy))
	{
		return;
	}
	ai_charge_side();
	delta = self.enemy.origin - self.origin;
	if (vlen(delta) > 60)
	{
		return;
	}
	if (!CanDamage(self.enemy, self))
	{
		return;
	}
	random();
	ldmg = (random() + random() + random()) * 3;
	T_Damage(self.enemy, self, self, ldmg);
};

float() SoldierCheckAttack = 
{
	local vector spot1;
	local vector spot2;
	local entity targ;
	local float chance;
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
	if (enemy_range == RANGE_MELEE)
	{
		chance = 0.9;
	}
	else
	{
		if (enemy_range == RANGE_NEAR)
		{
			chance = 0.4;
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
	if (random() < chance)
	{
		self.th_missile();
		SUB_AttackFinished(1 + random());
		if (random() < 0.3)
		{
			self.lefty = !(self.lefty);
		}
		return 1;
	}
	return 0;
};

float() ShamCheckAttack = 
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

float() OgreCheckAttack = 
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

