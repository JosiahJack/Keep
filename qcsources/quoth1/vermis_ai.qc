void() ai_vermis_face = 
{
	if (visible(self.enemy))
	{
		self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	}
	else
	{
		self.ideal_yaw = vectoyaw(self.oldenemyorigin - self.origin);
	}
	ChangeYaw();
};

void() ai_vermis_stand = 
{
	if (VermisFindTarget())
	{
		return;
	}
};

void() CheckVermisAttack = 
{
	local vector spot1;
	local vector spot2;
	local entity targ;
	local float chance;
	local float dist;
	targ = self.enemy;
	dist = vlen(self.enemy.origin - self.origin);
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;
	traceline(spot1, spot2, 0, self);
	if (trace_inopen && trace_inwater)
	{
		return 0;
	}
	if (dist < 340 && self.enemy.movetype != MOVETYPE_FLY)
	{
		if (self.th_melee)
		{
			self.th_melee();
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
	chance = 0.9;
	if (trace_ent != targ && random() < 0.3)
	{
		return 0;
	}
	if (random() < chance)
	{
		self.th_missile();
		SUB_AttackFinished(LIGHTNING_BOOM + LIGHTNING_RANDOM * random());
		return 1;
	}
	return 0;
};

void() ai_vermis_run = 
{
	local vector delta;
	local float axis;
	local float direct;
	local float ang_rint;
	local float ang_floor;
	local float ang_ceil;
	if (self.enemy.health <= MSG_BROADCAST)
	{
		self.enemy = world;
		if (self.oldenemy.health > MSG_BROADCAST)
		{
			self.enemy = self.oldenemy;
			HuntTarget();
		}
		else
		{
			self.th_stand();
			return;
		}
	}
	self.show_hostile = time + LIGHTNING_RANDOM;
	enemy_vis = visible(self.enemy);
	if (enemy_vis)
	{
		self.search_time = time + AS_BLINDFIRE;
	}
	if (coop && self.search_time < time)
	{
		if (FindTarget())
		{
			return;
		}
	}
	enemy_infront = infront(self.enemy);
	enemy_range = range(self.enemy);
	enemy_yaw = vectoyaw(self.enemy.origin - self.origin);
	CheckVermisAttack();
	ai_vermis_face();
	ai_shotcheck();
};

