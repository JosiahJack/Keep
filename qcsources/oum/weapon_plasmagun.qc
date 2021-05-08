void() Plasma_PreCache = 
{
	precache_sound2("enforcer/enfstop.wav");
	precache_sound("dsfirxpl.wav");
	precache_sound("dsplasma.wav");
	precache_model("progs/pbullet.mdl");
	precache_model("progs/g_plasma.mdl");
	precache_model("progs/v_plasma.mdl");
	precache_model("progs/s_plasma.spr");
};

void() s_pexplode1 = [1, s_pexplode2]
{
};

void() s_pexplode2 = [2, s_pexplode3]
{
};

void() s_pexplode3 = [3, s_pexplode4]
{
};

void() s_pexplode4 = [4, s_pexplode5]
{
};

void() s_pexplode5 = [5, SUB_Remove]
{
};

void(entity inflictor, entity attacker, float damage, entity ignore) WaterRadiusDamage = 
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
					if (CanDamage(head, inflictor) && head.waterlevel > 0)
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
				}
			}
		}
		head = head.chain;
	}
};

void() PlasmaExplosion = 
{
	self.movetype = MOVETYPE_NONE;
	self.velocity = VEC_ORIGIN;
	self.touch = SUB_Null;
	setmodel(self, "progs/s_plasma.spr");
	self.solid = SOLID_NOT;
	s_pexplode1();
};

void() Plasma_Watercheck = 
{
	local float pc;
	pc = pointcontents(self.origin);
	if (pc == CONTENT_WATER || pc == CONTENT_SLIME || pc == CONTENT_LAVA)
	{
		sound(self, CHAN_WEAPON, "enforcer/enfstop.wav", 1, ATTN_NORM);
		WaterRadiusDamage(self, self.owner, 60, world);
		PlasmaExplosion();
		return;
	}
	self.think = Plasma_Watercheck;
	self.nextthink = time;
};

void() T_PlasmaTouch = 
{
	local float damg;
	if (other == self.owner)
	{
		return;
	}
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	damg = MOVETYPE_BOUNCE + random() * 50;
	if (other.classname == "monster_zombie")
	{
		if (random() < 0.5)
		{
			damg = 1000;
		}
	}
	if (other.classname == "monster_morph")
	{
		damg = damg * 0.25;
	}
	if (other.health)
	{
		T_Damage(other, self, self.owner, damg);
	}
	self.origin = self.origin - FL_CLIENT * normalize(self.velocity);
	sound(self, CHAN_WEAPON, "dsfirxpl.wav", 1, ATTN_NORM);
	PlasmaExplosion();
};

void() W_FirePlasma = 
{
	local entity missile;
	self.currentammo = self.ammo_cells = self.ammo_cells - 1;
	sound(self, CHAN_WEAPON, "dsplasma.wav", 1, ATTN_NORM);
	self.punchangle_x = CONTENT_SOLID;
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "plasma";
	makevectors(self.v_angle);
	missile.velocity = aim(self, 1000);
	missile.velocity = missile.velocity * 1000;
	missile.velocity = missile.velocity + crandom() * 50 * v_right;
	missile.velocity = missile.velocity + crandom() * 50 * v_up;
	missile.angles = vectoangles(missile.velocity);
	missile.avelocity = '300 300 300';
	missile.nextthink = time;
	missile.think = Plasma_Watercheck;
	missile.touch = T_PlasmaTouch;
	missile.effects = FL_CLIENT;
	setmodel(missile, "progs/pbullet.mdl");
	setsize(missile, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(missile, self.origin + v_forward * FL_CLIENT + '0 0 10' + v_right * MOVETYPE_BOUNCE);
};

void() weapon_plasmagun = 
{
	precache_model("progs/g_plasma.mdl");
	setmodel(self, "progs/g_plasma.mdl");
	self.weapon = MOVETYPE_WALK;
	self.classname = "weapon_plasmagun";
	self.netname = "Plasma Gun";
	self.touch = weapon_touch;
	setsize(self, '-16 -16 0', '16 16 56');
	StartItem();
};

