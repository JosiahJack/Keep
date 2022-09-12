float(entity targ, entity inflictor) CanDamage = 
{
	if (targ.movetype == MOVETYPE_PUSH)
	{
		traceline(inflictor.origin, 0.5 * (targ.absmin + targ.absmax), 1, self);
		if (trace_fraction == 1)
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
	if (trace_fraction == 1)
	{
		return 1;
	}
	traceline(inflictor.origin, targ.origin + '15 15 0', 1, self);
	if (trace_fraction == 1)
	{
		return 1;
	}
	traceline(inflictor.origin, targ.origin + '-15 -15 0', 1, self);
	if (trace_fraction == 1)
	{
		return 1;
	}
	traceline(inflictor.origin, targ.origin + '-15 15 0', 1, self);
	if (trace_fraction == 1)
	{
		return 1;
	}
	traceline(inflictor.origin, targ.origin + '15 -15 0', 1, self);
	if (trace_fraction == 1)
	{
		return 1;
	}
	return 0;
};

void() SetResurrect = 
{
	self.rcells = self.ammo_cells;
	self.rshells = self.ammo_shells;
	self.rnails = self.ammo_nails;
	self.rrockets = self.ammo_rockets;
	self.rweapons = self.weapons;
	self.ritems = self.items;
	if (!(self.armormax))
	{
		self.rarmor = self.armortype;
		self.raval = self.armorvalue;
	}
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
	if (self.player_flag & ITEM_RUNE6_FLAG)
	{
		self.resurrect = 1;
		SetResurrect();
	}
	else
	{
		ClientObituary(self, attacker);
	}
	if (attacker.armormax > 0)
	{
		attacker.armormax = attacker.armormax + 20;
		attacker.armorvalue = attacker.armormax;
		if (attacker.armormax > 200)
		{
			attacker.armorvalue = 200;
			attacker.armormax = 200;
		}
	}
	self.takedamage = DAMAGE_NO;
	self.touch = SUB_Null;
	self.th_die();
	self = oself;
};

void(entity targ, entity inflictor, entity attacker, float damage) T_Damage = 
{
	local vector dir;
	local entity oldself;
	local float save;
	local float take;
	local entity oself;
	if (!(targ.takedamage))
	{
		return;
	}
	if (targ.observer)
	{
		return;
	}
	damage_attacker = attacker;
	if (attacker.super_damage_finished > time && !(attacker.bad_quad))
	{
		damage = damage * 4;
	}
	if (attacker.super_damage_finished > time && attacker.bad_quad)
	{
		damage = damage * 0.25;
	}
	if (attacker.player_flag & ITEM_RUNE2_FLAG)
	{
		damage = damage * 2;
	}
	if (attacker.weapon == IT_LIGHTNING && (targ.player_flag & ITEM_RUNE8_FLAG))
	{
		damage = damage * 0.5;
	}
	if (attacker.blood_finished > time)
	{
		damage = damage * 4;
	}
	if (targ.player_flag & ITEM_RUNE1_FLAG)
	{
		damage = damage * 0.5;
	}
	if (attacker.axe_only_time > time)
	{
		damage = damage * 5;
	}
	if (targ.player_flag & ITEM_RUNE9_FLAG)
	{
		if (attacker.player_flag & ITEM_RUNE2_FLAG)
		{
			damage = damage * 0.5;
		}
		if (attacker.super_damage_finished > time && !(attacker.bad_quad))
		{
			damage = damage * 0.25;
		}
		if (attacker.super_damage_finished > time && attacker.bad_quad)
		{
			damage = damage * 4;
		}
		if (attacker.invisible_finished > time)
		{
			damage = 0;
		}
		if (attacker.player_flag & ITEM_RUNE5_FLAG)
		{
			damage = 0;
		}
		if (attacker.blood_finished > time)
		{
			damage = damage * 0.25;
		}
	}
	if (attacker.player_flag & ITEM_RUNE9_FLAG)
	{
		if (targ.player_flag & ITEM_RUNE1_FLAG)
		{
			damage = damage * 2;
		}
		if (targ.player_flag & ITEM_RUNE8_FLAG && attacker.weapons == IT_LIGHTNING)
		{
			damage = damage * 2;
		}
		if (attacker.super_damage_finished > time)
		{
			damage = damage * 0.25;
		}
		if (attacker.blood_finished > time)
		{
			damage = damage * 0.25;
		}
		if (targ.invisible_time > time)
		{
			damage = 0;
		}
		if (targ.invisible_time > time)
		{
			targ.invincible_time = targ.invincible_time - 10;
		}
	}
	save = ceil(targ.armortype * damage);
	if (save >= targ.armorvalue)
	{
		save = targ.armorvalue;
		if (!(targ.armormax))
		{
			targ.armortype = 0;
			targ.items = targ.items - (targ.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3));
		}
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
		targ.velocity = targ.velocity + dir * damage * 8;
	}
	if (targ.flags & FL_GODMODE)
	{
		return;
	}
	if (targ.invincible_finished >= time && !(attacker.player_flag & ITEM_RUNE9_FLAG))
	{
		if (targ.invincible_sound < time)
		{
			if (!(targ.player_flag & ITEM_RUNE5_FLAG))
			{
				sound(targ, CHAN_ITEM, "items/protect3.wav", 1, ATTN_NORM);
			}
			targ.invincible_sound = time + 2;
		}
		return;
	}
	if (targ.blood_finished > time)
	{
		if (targ.invincible_sound < time)
		{
			if (!(targ.player_flag & ITEM_RUNE5_FLAG))
			{
				sound(targ, CHAN_ITEM, "items/blood3.wav", 1, ATTN_NORM);
			}
			targ.invincible_sound = time + 2;
		}
	}
	if (teamplay == 1 && targ.team > 0 && targ.team == attacker.team)
	{
		return;
	}
	targ.health = targ.health - take;
	if (targ.classname == "player")
	{
		oself = self;
		self = targ;
		ShowStatus();
		self = oself;
	}
	if (targ.health <= 0)
	{
		if (targ.health > -40 && targ.blood_finished > time)
		{
			targ.health = 1;
			targ.die = 1;
		}
		else
		{
			Killed(targ, attacker);
			return;
		}
	}
	oldself = self;
	self = targ;
	if (self.th_pain)
	{
		if (self.blood_finished < time)
		{
			self.th_pain(attacker, take);
		}
	}
	self = oldself;
};

void(entity inflictor, entity attacker, float damage, entity ignore) T_RadiusDamage = 
{
	local float points;
	local entity head;
	local vector org;
	head = findradius(inflictor.origin, damage + 40);
	while (head)
	{
		if (head != ignore)
		{
			if (head.takedamage)
			{
				org = head.origin + (head.mins + head.maxs) * 0.5;
				points = 0.5 * vlen(inflictor.origin - org);
				if (points < 0)
				{
					points = 0;
				}
				points = damage - points;
				if (head == attacker)
				{
					points = points * 0.5;
				}
				if (points > 0)
				{
					if (CanDamage(head, inflictor))
					{
						if (head.player_flag & ITEM_RUNE8_FLAG)
						{
							points = points * 0.5;
						}
						if (points != 0)
						{
							T_Damage(head, inflictor, attacker, points);
						}
					}
				}
			}
		}
		head = head.chain;
	}
};

void(entity inflictor, entity attacker, float damage, entity ignore) T_LightningRadiusDamage = 
{
	local float points;
	local entity head;
	local vector org;
	head = findradius(inflictor.origin, damage + 40);
	while (head)
	{
		if (head != ignore)
		{
			if (head.takedamage)
			{
				org = head.origin + (head.mins + head.maxs) * 0.5;
				points = 0.5 * vlen(inflictor.origin - org);
				if (points < 0)
				{
					points = 0;
				}
				points = damage - points;
				if (head == attacker)
				{
					points = points * 0.5;
				}
				if (points > 0)
				{
					if (CanDamage(head, inflictor))
					{
						if (head.player_flag & ITEM_RUNE8_FLAG)
						{
							points = points * 0.5;
						}
						if (head.player_flag & ITEM_RUNE8_FLAG || head.waterlevel < 1)
						{
							points = 0;
						}
						if (points != 0)
						{
							T_Damage(head, inflictor, attacker, points);
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
			if (points < 0)
			{
				points = 0;
			}
			points = damage - points;
			if (head == attacker)
			{
				points = points * 0.5;
			}
			if (points > 0)
			{
				if (CanDamage(head, attacker))
				{
					T_Damage(head, attacker, attacker, points);
				}
			}
		}
		head = head.chain;
	}
};

