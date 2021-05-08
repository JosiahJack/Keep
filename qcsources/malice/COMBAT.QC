void () T_MissileTouch;
void () info_player_start;
void (entity targ,entity attacker) ClientObituary;
void () monster_death_use;

float (entity targ,entity inflictor) CanDamage =
{
	if ((targ.movetype == MOVETYPE_PUSH))
	{
		traceline (inflictor.origin, (0.5 * (targ.absmin + targ.absmax)), TRUE, self);
		if ((trace_fraction == 1))
			return (TRUE);
		if ((trace_ent == targ))
			return (TRUE);
		return (FALSE);
	}
	traceline (inflictor.origin, targ.origin, TRUE, self);
	if ((trace_fraction == 1))
		return (TRUE);
	traceline (inflictor.origin, (targ.origin + '15 15 0'), TRUE, self);
	if ((trace_fraction == 1))
		return (TRUE);
	traceline (inflictor.origin, (targ.origin + '-15 -15 0'), TRUE, self);
	if ((trace_fraction == 1))
		return (TRUE);
	traceline (inflictor.origin, (targ.origin + '-15 15 0'), TRUE, self);
	if ((trace_fraction == 1))
		return (TRUE);
	traceline (inflictor.origin, (targ.origin + '15 -15 0'), TRUE, self);
	if ((trace_fraction == 1))
		return (TRUE);
	return (FALSE);
};


void (entity targ,entity attacker) Killed =
{
	local entity oself;

	oself = self;
	self = targ;
	if ((self.health < -99))
		self.health = -99;
	if (((self.movetype == MOVETYPE_PUSH) || (self.movetype == MOVETYPE_NONE)))
	{
		self.th_die ();
		self = oself;
		return;
	}
	self.enemy = attacker;
	if ((self.flags & FL_MONSTER))
	{
		killed_monsters = (killed_monsters + 1);
		WriteByte (MSG_ALL, SVC_KILLEDMONSTER);
	}
	ClientObituary (self, attacker);
	self.takedamage = DAMAGE_NO;
	self.touch = SUB_Null;
	monster_death_use ();
	self.th_die ();
	self = oself;
};

void (entity striker,float heebie) return2sender;

void (entity targ,entity inflictor,entity attacker,float damage) T_Damage =
{
	local vector dir;
	local entity oldself;
	local float save;
	local float take;

	if (!targ.takedamage)
		return;
	damage_attacker = attacker;
	if (deathmatch)
		damage = (damage * 0.5);
	if ((targ.tools == (targ.tools | UT_MINISUB)))
		damage = (damage * 0.5);
	save = ceil ((targ.armortype * damage));
	if ((save >= targ.armorvalue))
	{
		save = targ.armorvalue;
		targ.armortype = 0;
	}
	targ.armorvalue = (targ.armorvalue - save);
	take = ceil (damage);
	if ((targ.flags & FL_CLIENT))
	{
		targ.dmg_take = (targ.dmg_take + take);
		targ.dmg_save = (targ.dmg_save + save);
		targ.dmg_inflictor = inflictor;
	}
	if (((inflictor != world) && (targ.movetype == MOVETYPE_WALK)))
	{
		dir = (targ.origin - ((inflictor.absmin + inflictor.absmax) * 0.5));
		dir = normalize (dir);
		targ.velocity = (targ.velocity + ((dir * damage) * 12));
	}
	if ((targ.flags & FL_GODMODE))
		return;
	if ((targ.probe_active == TRUE))
	{
		return2sender (targ, 0);
		return;
	}
	if ((((teamplay == TRUE) && (targ.team > 0)) && (targ.team == attacker.team)))
		return;
	targ.health = (targ.health - take);
	if ((targ.health <= 0))
	{
		Killed (targ, attacker);
		return;
	}
	oldself = self;
	self = targ;
	if ((self.classname == "cbot"))
	{
		if (((((((self != attacker) && (attacker != self.enemy)) && (inflictor.classname != "misc_fireball")) && (inflictor.classname != "misc_explobox")) && (inflictor.classname != "misc_explobox2")) && (attacker.health > 0)))
		{
			if (((self.enemy == world) || !visible (self.enemy)))
			{
				self.botmode = ATTACK;
				self.enemy = attacker;
			}
		}
	}
	else
	{
		if (((self.flags & FL_MONSTER) && (attacker != world)))
		{
			if (((self != attacker) && (attacker != self.enemy)))
			{
				if (((self.classname != attacker.classname) || (self.classname == "monster_baboon")))
				{
					if ((self.enemy.classname == "player"))
						self.oldenemy = self.enemy;
					self.enemy = attacker;
					FoundTarget ();
				}
			}
		}
	}
	if (self.th_pain)
	{
		self.th_pain (attacker, take);
		if ((skill == 3))
			self.pain_finished = (time + 5.00);
	}
	self = oldself;
};


void (entity inflictor,entity attacker,float damage,entity ignore) T_RadiusDamage =
{
	local float points;
	local entity head;
	local vector org;

	head = findradius (inflictor.origin, (damage + 40));
	while (head)
	{
		if ((head != ignore))
		{
			if (head.takedamage)
			{
				org = (head.origin + ((head.mins + head.maxs) * 0.5));
				points = (0.5 * vlen ((inflictor.origin - org)));
				if ((points < 0))
					points = 0;
				points = (damage - points);
				if ((head == attacker))
					points = (points * 0.5);
				if ((points > 0))
				{
					if (CanDamage (head, inflictor))
					{
						if ((head.classname == "monster_shambler"))
							T_Damage (head, inflictor, attacker, (points * 0.5));
						else
							T_Damage (head, inflictor, attacker, points);
					}
				}
			}
		}
		head = head.chain;
	}
};


void (entity attacker,float damage) T_BeamDamage =
{
	local float points;
	local entity head;

	head = findradius (attacker.origin, (damage + 40));
	while (head)
	{
		if (head.takedamage)
		{
			points = (0.5 * vlen ((attacker.origin - head.origin)));
			if ((points < 0))
				points = 0;
			points = (damage - points);
			if ((head == attacker))
				points = (points * 0.5);
			if ((points > 0))
			{
				if (CanDamage (head, attacker))
				{
					if ((head.classname == "monster_shambler"))
						T_Damage (head, attacker, attacker, (points * 0.5));
					else
						T_Damage (head, attacker, attacker, points);
				}
			}
		}
		head = head.chain;
	}
};

