float(entity targ, entity inflictor) CanDamage = 
{
	if (targ.movetype == MOVETYPE_PUSH)
	{
		traceline(inflictor.origin, 0.5 * (targ.absmin + targ.absmax), 1, self);
		if (trace_fraction == REVERSE)
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
	if (trace_fraction == REVERSE)
	{
		return 1;
	}
	traceline(inflictor.origin, targ.origin + '15 15 0', 1, self);
	if (trace_fraction == REVERSE)
	{
		return 1;
	}
	traceline(inflictor.origin, targ.origin + '-15 -15 0', 1, self);
	if (trace_fraction == REVERSE)
	{
		return 1;
	}
	traceline(inflictor.origin, targ.origin + '-15 15 0', 1, self);
	if (trace_fraction == REVERSE)
	{
		return 1;
	}
	traceline(inflictor.origin, targ.origin + '15 -15 0', 1, self);
	if (trace_fraction == REVERSE)
	{
		return 1;
	}
	return 0;
};

void(entity targ, entity attacker) Killed = 
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
		killed_monsters = killed_monsters + REVERSE;
		WriteByte(MSG_ALL, SVC_KILLEDMONSTER);
	}
	ClientObituary(self, attacker);
	self.takedamage = DAMAGE_NO;
	self.touch = SUB_Null;
	monster_death_use();
	self.th_die();
	self = oself;
};

void(entity targ, entity inflictor, entity attacker, float damage) T_Damage = 
{
	local vector dir;
	local entity oldself;
	local float save;
	local float take;
	if (!(targ.takedamage))
	{
		return;
	}
	if (damage == -666 && self.classname == "player" && !(targ.flags & FL_GODMODE))
	{
		targ.health = MSG_BROADCAST;
		Killed(targ, attacker);
		return;
	}
	damage_attacker = attacker;
	if (attacker.super_damage_finished > time)
	{
		damage = damage * AS_MISSILE;
	}
	if (targ.classname == "monster_death_lord" && targ.shield == REVERSE)
	{
		damage = damage * 0.5;
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
	if (targ.invincible_finished >= time && attacker.classname != "trigger_void")
	{
		if (self.invincible_sound < time)
		{
			sound(targ, CHAN_ITEM, "items/protect3.wav", REVERSE, ATTN_NORM);
			self.invincible_sound = time + AS_SLIDING;
		}
		return;
	}
	if (targ.cross_finished >= time && attacker.classname != "trigger_void")
	{
		take = take * 0.5;
		if (self.cross_sound < time)
		{
			sound(targ, CHAN_ITEM, "items2/crosuse.wav", REVERSE, ATTN_NORM);
			self.cross_sound = time + 0.5;
		}
	}
	if (targ.flags & FL_GODMODE)
	{
		return;
	}
	if (teamplay == REVERSE && targ.team > MSG_BROADCAST && targ.team == attacker.team)
	{
		return;
	}
	targ.health = targ.health - take;
	if (targ.health <= MSG_BROADCAST)
	{
		Killed(targ, attacker);
		return;
	}
	oldself = self;
	self = targ;
	if (self.flags & FL_MONSTER && attacker != world)
	{
		if (self != attacker && attacker != self.enemy)
		{
			if (self.classname != attacker.classname || self.classname == "monster_army" || self.classname == "monster_cyaegha")
			{
				if (self.class != attacker.class || (self.class == "" && attacker.class == ""))
				{
					if (self.activated_time < time && attacker.classname == "player" && self.enemy.classname == "player" || (self.activated_time < time && (attacker.flags & FL_MONSTER) && (self.enemy.flags & FL_MONSTER)) || (!(attacker.flags & FL_MONSTER) && (self.enemy.flags & FL_MONSTER)) || (attacker.flags & FL_MONSTER && !(self.enemy.flags & FL_MONSTER)))
					{
						if (self.classname == "monster_vermis")
						{
							self.activated_time = time + TE_LAVASPLASH;
						}
						else
						{
							if (self.classname == "monster_gug")
							{
								self.activated_time = time + TE_WIZSPIKE;
							}
							else
							{
								self.activated_time = time + AS_BLINDFIRE;
							}
						}
						if (self.enemy.classname == "player")
						{
							self.oldenemy = self.enemy;
						}
						self.enemy = attacker;
						if (self.classname == "monster_polyp" && self.startonground == REVERSE)
						{
							PolypFoundTarget();
						}
						else
						{
							FoundTarget();
						}
					}
				}
				if (self.class != attacker.class || (self.class == "" && attacker.class == "") && self.enemy == world)
				{
					if (self.enemy.classname == "player")
					{
						self.oldenemy = self.enemy;
					}
					if (self.classname == "monster_vermis")
					{
						self.activated_time = time + TE_LAVASPLASH;
					}
					else
					{
						if (self.classname == "monster_gug")
						{
							self.activated_time = time + TE_WIZSPIKE;
						}
						else
						{
							self.activated_time = time + AS_BLINDFIRE;
						}
					}
					self.enemy = attacker;
					if (self.classname == "monster_polyp" && self.startonground == REVERSE)
					{
						PolypFoundTarget();
					}
					else
					{
						FoundTarget();
					}
				}
			}
		}
	}
	if (self.th_pain)
	{
		self.th_pain(attacker, take);
		if (skill == AS_MELEE)
		{
			self.pain_finished = time + AS_BLINDFIRE;
		}
	}
	self = oldself;
};

void(entity inflictor, entity attacker, float damage, entity ignore) T_RadiusDamage = 
{
	local float points;
	local entity head;
	local vector org;
	local vector dir;
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
						if (!(head.cross_finished >= time))
						{
							if (head.classname == "monster_shambler")
							{
								T_Damage(head, inflictor, attacker, points * 0.5);
							}
							else
							{
								T_Damage(head, inflictor, attacker, points);
							}
						}
						if (head.cross_finished >= time && head.classname == "player")
						{
							if (self.cross_sound < time)
							{
								sound(self, CHAN_ITEM, "items2/crosuse.wav", REVERSE, ATTN_NORM);
								self.cross_sound = time + 0.5;
							}
							dir = head.origin - (inflictor.absmin + inflictor.absmax) * 0.5;
							dir = normalize(dir);
							head.velocity = head.velocity + dir * points * EF_DIMLIGHT;
						}
					}
				}
			}
		}
		head = head.chain;
	}
};

void(entity inflictor, entity attacker, float damage, entity ignore) T_WeakRadiusDamage = 
{
	local float points;
	local entity head;
	local vector org;
	local vector dir;
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
					points = points * 0.4 + AS_LOITER;
					if (CanDamage(head, inflictor))
					{
						if (!(head.cross_finished >= time))
						{
							if (head.classname == "monster_shambler")
							{
								T_Damage(head, inflictor, attacker, points * 0.5);
							}
							else
							{
								T_Damage(head, inflictor, attacker, points);
							}
						}
						if (head.cross_finished >= time && head.classname == "player")
						{
							if (self.cross_sound < time)
							{
								sound(self, CHAN_ITEM, "items2/crosuse.wav", REVERSE, ATTN_NORM);
								self.cross_sound = time + 0.5;
							}
							dir = head.origin - (inflictor.absmin + inflictor.absmax) * 0.5;
							dir = normalize(dir);
							head.velocity = head.velocity + dir * points * EF_DIMLIGHT;
						}
					}
				}
			}
		}
		head = head.chain;
	}
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

