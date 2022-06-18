void() PM_FixVision = 
{
	local float gamma;
	gamma = cvar("gamma");
	if (gamma < 0.5)
	{
		stuffcmd(self.owner, "gamma 0.5\n");
	}
	else
	{
		if (gamma > IQ_LOW)
		{
			stuffcmd(self.owner, "gamma 1\n");
		}
	}
	stuffcmd(self.owner, "v_cshift 1 1 1 0\n");
	remove(self);
};

void(entity head) PM_CheckVision = 
{
	local entity fix;
	fix = spawn();
	setmodel(fix, "");
	setsize(fix, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(fix, head.origin);
	fix.movetype = MOVETYPE_NONE;
	fix.solid = SOLID_NOT;
	fix.owner = head;
	fix.touch = SUB_Null;
	fix.nextthink = time;
	fix.think = PM_FixVision;
};

void(entity victim, entity source, float force, float jumplimit) PM_PushPlayer = 
{
	local vector dir;
	if (victim.movetype == MOVETYPE_WALK)
	{
		dir = victim.origin - (source.absmin + source.absmax) * 0.5;
		dir = normalize(dir);
		victim.velocity = victim.velocity + dir * force * SPAWN_RESPAWN;
		if (jumplimit)
		{
			if (victim.velocity_z > 600)
			{
				victim.velocity_z = 600;
			}
		}
	}
};

float(entity head, entity attacker) PM_Ally = 
{
	if (head == attacker)
	{
		return 1;
	}
	if (!deathmatch)
	{
		if (head.classname == attacker.classname)
		{
			if (head.enemy != attacker)
			{
				return 1;
			}
		}
	}
	if (head == attacker.owner)
	{
		return 1;
	}
	return 0;
};

float(entity victim, entity attacker, float damage) PM_Kill = 
{
	local float save;
	if (victim.health)
	{
		if (attacker.items & IT_QUAD)
		{
			damage = damage * IQ_GENIUS;
		}
		if (victim.armorvalue > MSG_BROADCAST)
		{
			save = ceil(victim.armortype * damage);
			if (save >= victim.armorvalue)
			{
				save = victim.armorvalue;
			}
			damage = ceil(damage - save);
		}
		if (victim.health <= damage)
		{
			return 1;
		}
	}
	return 0;
};

void(entity head) PM_NegateMissile = 
{
	if (head.flags & FL_MONSTER)
	{
		return;
	}
	if (head.solid == SOLID_BBOX)
	{
		if (head.movetype == MOVETYPE_TOSS)
		{
			head.nextthink = time;
			head.think = BecomeExplosion;
			return;
		}
		if (head.movetype == MOVETYPE_FLY)
		{
			head.nextthink = time;
			head.think = BecomeExplosion;
			return;
		}
		if (head.movetype == MOVETYPE_FLYMISSILE)
		{
			head.nextthink = time;
			head.think = BecomeExplosion;
			return;
		}
		if (head.movetype == MOVETYPE_BOUNCE)
		{
			head.nextthink = time;
			head.think = BecomeExplosion;
			return;
		}
		if (head.movetype == MOVETYPE_BOUNCEMISSILE)
		{
			head.nextthink = time;
			head.think = BecomeExplosion;
			return;
		}
	}
};

