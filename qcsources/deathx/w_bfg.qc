void() BFG_PreCache = 
{
	precache_sound("weapons/bhit1.wav");
	precache_sound("weapons/bshot1.wav");
	precache_model("progs/bfg.mdl");
	precache_model("progs/g_bfg.mdl");
	precache_model("progs/v_bfg.mdl");
	precache_model("progs/s_bfg1.spr");
};

void() s_bexplode1 = [1, s_bexplode2]
{
};

void() s_bexplode2 = [2, s_bexplode3]
{
};

void() s_bexplode3 = [3, s_bexplode4]
{
};

void() s_bexplode4 = [4, s_bexplode5]
{
};

void() s_bexplode5 = [4, s_bexplode6]
{
};

void() s_bexplode6 = [5, SUB_Remove]
{
};

void() BFGExplosion = 
{
	self.movetype = MOVETYPE_NONE;
	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	setmodel(self, "progs/s_bfg1.spr");
	self.solid = SOLID_NOT;
	s_bexplode1();
};

void(vector spawnspot) SpawnExplosion = 
{
	local entity bang;
	bang = spawn();
	bang.nextthink = time;
	bang.think = BFGExplosion;
	setorigin(bang, spawnspot);
};

void(entity inflictor, entity attacker, float damage, entity ignore) T_BFGDamage = 
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
						SpawnExplosion(head.origin);
						T_Damage(head, inflictor, attacker, points);
					}
				}
			}
		}
		head = head.chain;
	}
};

void() T_BFGTouch = 
{
	local float damg;
	if (other.solid == SOLID_NOT)
	{
		return;
	}
	if (other == self.owner)
	{
		return;
	}
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	if (other.health && (other.classname == "player" || other.classname == "undead"))
	{
		other.items = other.items - (other.items & IT_INVULNERABILITY);
		other.flags = other.flags - (other.flags & FL_GODMODE);
		damg = other.health + 1000;
		T_Damage(other, self, self.owner, damg);
	}
	else
	{
		T_Damage(other, self, self.owner, 480);
	}
	T_BFGDamage(self, self.owner, 315, other);
	self.origin = self.origin - 8 * normalize(self.velocity);
	sound(self, CHAN_WEAPON, "weapons/bhit1.wav", 1, ATTN_NORM);
	BFGExplosion();
};

void() W_FireBFG = 
{
	local entity missile;
	self.currentammo = self.ammo_cells = self.ammo_cells - 30;
	if (!(self.player_flag & ITEM_RUNE5_FLAG))
	{
		sound(self, CHAN_WEAPON, "weapons/bshot1.wav", 1, ATTN_NORM);
	}
	self.punchangle_x = -4;
	missile = spawn();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "bfg";
	makevectors(self.v_angle);
	missile.velocity = aim(self, 500);
	missile.velocity = missile.velocity * 500;
	missile.angles = vectoangles(missile.velocity);
	missile.avelocity = '300 300 300';
	missile.nextthink = time + 10;
	missile.think = SUB_Remove;
	missile.touch = T_BFGTouch;
	missile.effects = EF_BRIGHTLIGHT;
	setmodel(missile, "progs/bfg.mdl");
	setsize(missile, '0 0 0', '0 0 0');
	setorigin(missile, self.origin + v_forward * 8 + '0 0 10');
};

void() weapon_bfg = 
{
	precache_model("progs/g_bfg.mdl");
	setmodel(self, "progs/g_bfg.mdl");
	self.weapon = 3;
	self.netname = "BFG 9000";
	self.touch = weapon_touch;
	setsize(self, '-16 -16 0', '16 16 56');
	StartItem();
};

