float(entity head) PM_TouchLiquid = 
{
	if (head.waterlevel > MSG_BROADCAST)
	{
		return 1;
	}
	if (pointcontents(head.origin) == CONTENT_WATER)
	{
		return 1;
	}
	if (pointcontents(head.origin) == CONTENT_SLIME)
	{
		return 1;
	}
	if (pointcontents(head.origin) == CONTENT_LAVA)
	{
		return 1;
	}
	return 0;
};

void(entity inflictor, entity attacker, float damage) PM_WaterZapDamage = 
{
	local float points;
	local entity head;
	local vector org;
	head = findradius(inflictor.origin, damage * IQ_NORMAL);
	while (head)
	{
		if (PM_TouchLiquid(head))
		{
			if (head.takedamage)
			{
				org = head.origin + (head.mins + head.maxs) * 0.5;
				points = 0.5 * vlen(inflictor.origin - org);
				if (points < MSG_BROADCAST)
				{
					points = MSG_BROADCAST;
				}
				points = damage - points;
				if (points > MSG_BROADCAST)
				{
					if (CanDamage(head, inflictor))
					{
						T_Damage(head, inflictor, attacker, points);
					}
				}
			}
		}
		head = head.chain;
	}
};

void(entity from, float damage) PM_PierceDamage = 
{
	if (trace_ent.takedamage)
	{
		if (trace_ent != from)
		{
			particle(trace_endpos, '0 0 100', 225, damage * IQ_GENIUS);
			if (PM_InLiquid(trace_ent))
			{
				PM_WaterZapDamage(trace_ent, from, 100);
			}
			T_Damage(trace_ent, from, from, damage);
		}
	}
};

void(vector org, vector dir, float dist, float damage) PM_TraceChain = 
{
	local vector src;
	local float leftover;
	local float travel;
	traceline(org, org + dir * (dist + IQ_GENIUS), 0, self);
	if (trace_fraction < SPAWNFLAG_SUPERSPIKE)
	{
		leftover = dist - dist * trace_fraction;
		src = trace_endpos;
		PM_PierceDamage(self, damage);
		while (leftover > SPAWNFLAG_SUPERSPIKE)
		{
			traceline(src, src + dir * leftover, 0, trace_ent);
			travel = leftover * trace_fraction;
			if (travel < SPAWNFLAG_SUPERSPIKE)
			{
				leftover = MSG_BROADCAST;
			}
			else
			{
				leftover = leftover - travel;
				src = trace_endpos;
				PM_PierceDamage(self, damage);
			}
		}
	}
	else
	{
		PM_PierceDamage(self, damage);
	}
};

void(entity attacker, vector p1, float damage) PM_CheckForWater = 
{
	local entity zap;
	zap = spawn();
	setmodel(zap, "");
	setsize(zap, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(zap, p1);
	zap.movetype = MOVETYPE_NONE;
	zap.velocity = VEC_ORIGIN;
	zap.touch = SUB_Null;
	zap.solid = SOLID_NOT;
	zap.owner = self;
	if (PM_InLiquid(zap))
	{
		PM_WaterZapDamage(zap, attacker, damage);
	}
	remove(zap);
};

