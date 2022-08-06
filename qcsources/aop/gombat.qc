float(entity targ, entity inflictor) CanDamage = 
{
	if (targ.movetype == MOVETYPE_PUSH)
	{
		traceline(inflictor.origin, 0.5 * (targ.absmin + targ.absmax), 1, self);
		if (trace_fraction == OPT_MOTD)
		{
			return 1;
		}
		if (trace_ent == targ)
		{
			return 1;
		}
		return 0;
	}
	traceline(inflictor.origin, targ.origin, 1, self);
	if (trace_fraction == OPT_MOTD)
	{
		return 1;
	}
	traceline(inflictor.origin, targ.origin + '15 15 0', 1, self);
	if (trace_fraction == OPT_MOTD)
	{
		return 1;
	}
	traceline(inflictor.origin, targ.origin + '-15 -15 0', 1, self);
	if (trace_fraction == OPT_MOTD)
	{
		return 1;
	}
	traceline(inflictor.origin, targ.origin + '-15 15 0', 1, self);
	if (trace_fraction == OPT_MOTD)
	{
		return 1;
	}
	traceline(inflictor.origin, targ.origin + '15 -15 0', 1, self);
	if (trace_fraction == OPT_MOTD)
	{
		return 1;
	}
	return 0;
};

void(entity targ, entity inflictor, entity attacker) Killed = 
{
	local entity oself;
	oself = self;
	self = targ;
	if (self.health < -99)
	{
		self.health = -99;
	}
	if (self.movetype == MOVETYPE_PUSH || self.movetype == MOVETYPE_NONE)
	{
		self.th_die();
		self = oself;
		return;
	}
	self.enemy = attacker;
	if (self.flags & FL_MONSTER)
	{
		killed_monster();
	}
	ClientObituary(self, inflictor, attacker);
	self.takedamage = DAMAGE_NO;
	self.touch = SUB_Null;
	monster_death_use();
	if (inflictor.classname == "impaler")
	{
		impale();
	}
	else
	{
		self.th_die();
	}
	self = oself;
};

void(entity targ, entity inflictor, entity attacker, float damage) T_Damage = 
{
	local float r;
	local vector dir;
	local entity oldself;
	local float save;
	local float take;
	local float showpain;
	r = random();
	showpain = OPT_MOTD;
	if (!(targ.takedamage))
	{
		return;
	}
	damage_attacker = attacker;
	if (attacker.super_damage_finished > time)
	{
		damage = damage * AS_MISSILE;
	}
	save = ceil(targ.armortype * damage);
	if (save >= targ.armorvalue)
	{
		save = targ.armorvalue;
		targ.armortype = MSG_BROADCAST;
		targ.items = targ.items - (targ.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3));
	}
	targ.armorvalue = targ.armorvalue - save;
	take = ceil(damage - save);
	if (targ.flags & FL_CLIENT)
	{
		targ.dmg_take = targ.dmg_take + take;
		targ.dmg_save = targ.dmg_save + save;
		targ.dmg_inflictor = inflictor;
	}
	if (inflictor != world && targ.movetype == MOVETYPE_WALK)
	{
		dir = targ.origin - (inflictor.absmin + inflictor.absmax) * 0.5;
		dir = normalize(dir);
		targ.velocity = targ.velocity + dir * damage * EF_DIMLIGHT;
	}
	if (targ.flags & FL_GODMODE)
	{
		return;
	}
	if (targ.invincible_finished >= time)
	{
		if (targ.invincible_sound < time)
		{
			sound(targ, CHAN_ITEM, "items/protect3.wav", OPT_MOTD, ATTN_NORM);
			targ.invincible_sound = time + AS_SLIDING;
		}
		return;
	}
	if (teamplay == OPT_MOTD && targ.team > MSG_BROADCAST && targ.team == attacker.team)
	{
		return;
	}
	if (targ.field_generator_finished > time)
	{
		if (inflictor.classname != "grenade")
		{
			if (inflictor.classname != "missile")
			{
				if (inflictor.classname != "juggy_rocket")
				{
					if (inflictor.classname != "explo_box")
					{
						if (!(inflictor == world && targ.watertype == CONTENT_WATER))
						{
							if (!(inflictor == world && targ.jump_flag < -650))
							{
								if (r < 0.3)
								{
									sound(targ, CHAN_ITEM, "weapons/field/genhit1.wav", OPT_MOTD, ATTN_NORM);
								}
								else
								{
									if (r < 0.6)
									{
										sound(targ, CHAN_ITEM, "weapons/field/genhit2.wav", OPT_MOTD, ATTN_NORM);
									}
									else
									{
										sound(targ, CHAN_ITEM, "weapons/field/genhit3.wav", OPT_MOTD, ATTN_NORM);
									}
								}
								targ.field_generator_health = targ.field_generator_health - take;
								showpain = MSG_BROADCAST;
								take = MSG_BROADCAST;
								targ.effects = targ.effects | EF_BRIGHTFIELD;
								if (targ.field_generator_health < MSG_BROADCAST)
								{
									take = MSG_BROADCAST - targ.field_generator_health;
									showpain = OPT_MOTD;
								}
							}
						}
					}
				}
			}
		}
	}
	targ.health = targ.health - take;
	if (targ.health <= MSG_BROADCAST)
	{
		Killed(targ, inflictor, attacker);
		return;
	}
	oldself = self;
	self = targ;
	if (self.flags & FL_MONSTER && attacker != world)
	{
		if (self != attacker && attacker != self.enemy)
		{
			if (self.classname != attacker.classname || self.classname == "monster_army")
			{
				if (self.enemy.classname == "player")
				{
					self.oldenemy = self.enemy;
				}
				self.enemy = attacker;
				FoundTarget();
			}
		}
	}
	if (self.th_pain)
	{
		if (showpain)
		{
			self.th_pain(attacker, take);
			if (skill == AS_MELEE)
			{
				self.pain_finished = time + TE_LIGHTNING1;
			}
		}
	}
	self = oldself;
};

void(entity inflictor, entity attacker, float damage, entity ignore) T_RadiusDamage = 
{
	local float points;
	local entity head;
	local vector org;
	if (inside_radius)
	{
		remove(world);
		print_self("T_RadiusDamage:", "recursive");
		return;
	}
	inside_radius = 1;
	head = findradius(inflictor.origin, damage + 40);
	while (head)
	{
		if (head != ignore)
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
				if (head == attacker)
				{
					points = points * 0.5;
				}
				if (points > MSG_BROADCAST)
				{
					if (CanDamage(head, inflictor))
					{
						if (head.classname == "monster_shambler" || head.classname == "monster_legond")
						{
							T_Damage(head, inflictor, attacker, points * 0.5);
						}
						else
						{
							T_Damage(head, inflictor, attacker, points);
						}
					}
				}
			}
		}
		head = head.chain;
	}
	inside_radius = 0;
};

void(entity attacker, float damage) T_BeamDamage = 
{
	local float points;
	local entity head;
	head = findradius(attacker.origin, damage + 40);
	while (head)
	{
		if (head.takedamage)
		{
			points = 0.5 * vlen(attacker.origin - head.origin);
			if (points < MSG_BROADCAST)
			{
				points = MSG_BROADCAST;
			}
			points = damage - points;
			if (head == attacker)
			{
				points = points * 0.5;
			}
			if (points > MSG_BROADCAST)
			{
				if (CanDamage(head, attacker))
				{
					if (head.classname == "monster_shambler")
					{
						T_Damage(head, attacker, attacker, points * 0.5);
					}
					else
					{
						T_Damage(head, attacker, attacker, points);
					}
				}
			}
		}
		head = head.chain;
	}
};

