void() PM_PrecacheFire = 
{
	precache_model("progs/flame2.mdl");
};

void(entity head) PM_KillFire = 
{
	head.burnend = time;
};

void(entity fire) PM_MakeSteam = 
{
	sound(fire, CHAN_BODY, "player/slimbrn2.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	particle(fire.origin, '0 0 100', TE_LIGHTNING2, 50);
	remove(fire);
};

float(entity head) PM_InWater = 
{
	if (pointcontents(head.origin) == CONTENT_WATER)
	{
		return 1;
	}
	if (pointcontents(head.origin) == CONTENT_SLIME)
	{
		return 1;
	}
	return 0;
};

void() s_fire1 = [0, s_fire2]
{
	if (PM_InWater(self))
	{
		PM_MakeSteam(self);
	}
};

void() s_fire2 = [1, s_fire3]
{
	if (PM_InWater(self))
	{
		PM_MakeSteam(self);
	}
};

void() s_fire3 = [2, s_fire4]
{
	if (PM_InWater(self))
	{
		PM_MakeSteam(self);
	}
};

void() s_fire4 = [2, s_fire5]
{
	if (PM_InWater(self))
	{
		PM_MakeSteam(self);
	}
};

void() s_fire5 = [3, SUB_Remove]
{
};

float(entity head) PM_Flammable = 
{
	if (!(head.takedamage))
	{
		return 0;
	}
	if (head.solid != SOLID_SLIDEBOX)
	{
		return 0;
	}
	if (head.items & IT_INVULNERABILITY)
	{
		return 0;
	}
	if (head.items & IT_SUIT)
	{
		if (random() < 0.75)
		{
			return 0;
		}
	}
	if (head.classname == "monster_oldone")
	{
		return 0;
	}
	if (head.classname == "monster_reddragon")
	{
		return 0;
	}
	if (head.classname == "monster_golddragon")
	{
		return 0;
	}
	if (head.classname == "monster_dragon")
	{
		return 0;
	}
	if (head.classname == "monster_cyberdemon")
	{
		return 0;
	}
	return 1;
};

void(entity victim, entity fire, float die, float base, float chance) PM_BurnDamage = 
{
	local float damage;
	if (random() < chance)
	{
		PM_Ignite(victim, fire.fireowner);
	}
	damage = random() * die;
	damage = ceil(damage) + base;
	if (victim.classname == "player")
	{
		if (fire.fireowner.flags & FL_MONSTER)
		{
			T_Damage(victim, fire, fire.fireowner, damage);
		}
		else
		{
			if (fire.fireowner.items & IT_QUAD)
			{
				damage = damage * IQ_GENIUS;
			}
			T_Damage(victim, fire, fire, damage);
		}
	}
	else
	{
		T_Damage(victim, fire, fire.fireowner, damage);
	}
};

void(entity fire, float radius, float die, float base, float chance, entity ignore) PM_BurnRadius = 
{
	local entity head;
	local float damage;
	head = findradius(fire.origin, radius);
	while (head)
	{
		if (CanDamage(head, fire))
		{
			if (PM_Flammable(head))
			{
				if (head != ignore)
				{
					PM_BurnDamage(head, fire, die, base, chance);
				}
			}
		}
		head = head.chain;
	}
};

void() PM_FireDropTouch = 
{
	local float damage;
	if (other == self.owner)
	{
		return;
	}
	if (other.solid != SOLID_BSP || random() < self.cnt)
	{
		if (other.takedamage)
		{
			PM_BurnDamage(other, self, TE_LIGHTNING2, TE_LIGHTNING3, 0.5);
		}
		PM_BurnRadius(self, 70, SVC_SETVIEWANGLES, SVC_SETVIEWPORT, 0.2, other);
		self.effects = self.effects | EF_MUZZLEFLASH;
		BecomeExplosion();
		return;
	}
	self.velocity = VEC_ORIGIN;
	self.solid = SOLID_NOT;
	setsize(self, '-4 -4 -12', '4 4 16');
	setorigin(self, self.origin + '0 0 12');
};

void() PM_CheckFire = 
{
	if (PM_InWater(self))
	{
		PM_MakeSteam(self);
		return;
	}
	if (self.burnend < time)
	{
		if (self.effects & EF_DIMLIGHT)
		{
			BecomeExplosion();
		}
		else
		{
			remove(self);
		}
		return;
	}
	self.nextthink = time + 0.1;
	self.think = PM_CheckFire;
};

void() PM_CheckBurnFire = 
{
	if (PM_InWater(self))
	{
		PM_MakeSteam(self);
		return;
	}
	if (self.burnend < time)
	{
		if (self.effects & EF_DIMLIGHT)
		{
			BecomeExplosion();
		}
		else
		{
			remove(self);
		}
		return;
	}
	if (self.attack_finished < time)
	{
		PM_BurnRadius(self, 40, SVC_UPDATESTAT, MSG_BROADCAST, 0.05, world);
		self.attack_finished = time + random();
	}
	self.nextthink = time + 0.1;
	self.think = PM_CheckBurnFire;
};

void(entity head, float chance) PM_FireDrop = 
{
	head.attack_finished = time;
	head.movetype = MOVETYPE_TOSS;
	head.solid = SOLID_BBOX;
	head.takedamage = DAMAGE_NO;
	setmodel(head, "progs/flame2.mdl");
	setsize(head, VEC_ORIGIN, VEC_ORIGIN);
	head.frame = MSG_BROADCAST;
	head.classname = "fire";
	head.netname = "fire";
	head.angles = VEC_ORIGIN;
	head.velocity = VEC_ORIGIN;
	head.touch = PM_FireDropTouch;
	head.cnt = chance;
	head.burnend = random() * SVC_UPDATESTAT + IQ_NORMAL + time;
	head.nextthink = time;
	head.think = PM_CheckBurnFire;
};

void(entity head) PM_FireSpot = 
{
	local vector spot;
	makevectors(head.angles);
	spot = head.origin + v_forward * IQ_GENIUS;
	if (head.classname == "monster_shambler")
	{
		spot = head.origin + v_forward * HUD_ON;
		spot_z = spot_z + SVC_CDTRACK;
	}
	else
	{
		if (head.classname == "monster_wizard")
		{
			spot_z = spot_z + 24;
		}
		else
		{
			if (head.classname == "monster_zombie")
			{
				spot_z = spot_z - SVC_SETVIEWPORT;
			}
			else
			{
				if (head.classname == "monster_spider")
				{
					return spot_x;
				}
				else
				{
					spot_z = spot_z + HUD_ON;
				}
			}
		}
	}
	return spot_x;
};

void() PM_Burn = 
{
	local vector spot;
	local float damage;
	if (self.owner.health < SPAWNFLAG_SUPERSPIKE)
	{
		self.owner.burnend = time;
		PM_FireDrop(self, MSG_BROADCAST);
		return;
	}
	if (self.owner.items & IT_INVULNERABILITY)
	{
		self.owner.burnend = time;
		BecomeExplosion();
		return;
	}
	if (self.owner.burnend < time)
	{
		BecomeExplosion();
		return;
	}
	if (PM_InWater(self.owner))
	{
		self.owner.burnend = time;
		PM_MakeSteam(self);
		return;
	}
	spot = PM_FireSpot(self.owner);
	setorigin(self, spot);
	if (self.attack_finished < time)
	{
		PM_BurnRadius(self, IT_LIGHTNING, MSG_BROADCAST, SVC_SETVIEWPORT, 0.5, self.owner);
		damage = random() * SVC_SETVIEWANGLES;
		damage = ceil(damage) + SVC_SETVIEWPORT;
		if (self.owner.classname == "player")
		{
			if (self.fireowner.flags & FL_MONSTER)
			{
				T_Damage(self.owner, self, self.fireowner, damage);
			}
			else
			{
				if (self.fireowner.items & IT_QUAD)
				{
					damage = damage * IQ_GENIUS;
				}
				T_Damage(self.owner, self, self, damage);
			}
		}
		else
		{
			if (self.owner.classname == "monster_zombie")
			{
				if (random() < 0.05)
				{
					T_Damage(self.owner, self, self.fireowner, 60);
				}
				else
				{
					T_Damage(self.owner, self, self.fireowner, damage);
				}
			}
			else
			{
				T_Damage(self.owner, self, self.fireowner, damage);
			}
		}
		self.attack_finished = time + SPAWNFLAG_SUPERSPIKE;
	}
	self.nextthink = time + 0.1;
	self.think = PM_Burn;
};

entity(entity attacker, entity victim, vector spot) PM_NewFire = 
{
	local entity fire;
	fire = spawn();
	setmodel(fire, "progs/flame2.mdl");
	setsize(fire, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(fire, spot);
	fire.solid = SOLID_NOT;
	fire.takedamage = DAMAGE_NO;
	fire.frame = MSG_BROADCAST;
	fire.fireowner = attacker;
	fire.owner = victim;
	fire.classname = "fire";
	fire.netname = "fire";
	fire.attack_finished = time;
	return fire;
};

void(entity victim, entity attacker) PM_Ignite = 
{
	local entity fire;
	local vector spot;
	if (!PM_Flammable(victim))
	{
		return;
	}
	if (victim.burnend > time)
	{
		victim.flame.nextthink = time;
		victim.flame.think = BecomeExplosion;
	}
	victim.burnend = time + BURN_TIME;
	spot = PM_FireSpot(victim);
	fire = PM_NewFire(attacker, victim, spot);
	victim.flame = fire;
	fire.frame = SPAWNFLAG_SUPERSPIKE;
	fire.effects = fire.effects | EF_DIMLIGHT;
	fire.nextthink = time;
	fire.think = PM_Burn;
};

void() PM_FlamePoof = 
{
	local entity fire;
	setmodel(self, "progs/s_explod.spr");
	if (random() < self.cnt)
	{
		fire = PM_NewFire(self.fireowner, self, self.origin);
		PM_FireDrop(fire, 0.8);
	}
	s_explode1();
};

void(entity attacker, vector org, float quota, float side, float depth, float deadly, float rainchance) PM_FlameCloud = 
{
	local vector spot;
	local entity smoke;
	local float limit;
	local float tally;
	local float trials;
	limit = quota * SVC_UPDATESTAT;
	tally = MSG_BROADCAST;
	trials = MSG_BROADCAST;
	while (trials < limit && tally < quota)
	{
		spot_x = org_x + (random() * side - side * 0.5);
		spot_y = org_y + (random() * side - side * 0.5);
		spot_z = org_z + (random() * depth - depth * 0.5);
		if (pointcontents(spot) != CONTENT_SOLID)
		{
			if (pointcontents(spot) != CONTENT_SKY)
			{
				smoke = spawn();
				setmodel(smoke, "");
				setsize(smoke, VEC_ORIGIN, VEC_ORIGIN);
				setorigin(smoke, spot);
				smoke.movetype = MOVETYPE_FLY;
				smoke.solid = SOLID_NOT;
				smoke.velocity = '0 0 50';
				smoke.touch = SUB_Null;
				smoke.fireowner = attacker;
				smoke.owner = smoke;
				smoke.classname = "fire";
				smoke.netname = "fire";
				tally = tally + SPAWNFLAG_SUPERSPIKE;
				if (PM_InWater(smoke))
				{
					PM_MakeSteam(smoke);
				}
				else
				{
					if (deadly)
					{
						PM_BurnRadius(smoke, 70, TE_LIGHTNING2, IQ_GENIUS, 0.2, world);
					}
					smoke.cnt = rainchance;
					smoke.nextthink = time + random() * 0.2;
					smoke.think = PM_FlamePoof;
				}
			}
		}
		trials = trials + SPAWNFLAG_SUPERSPIKE;
	}
};

