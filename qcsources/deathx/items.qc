void() SUB_regen = 
{
	self.model = self.mdl;
	self.solid = SOLID_TRIGGER;
	sound(self, CHAN_VOICE, "items/itembk2.wav", 1, ATTN_NORM);
	setorigin(self, self.origin);
};

void() noclass = 
{
	dprint("noclass spawned at");
	dprint(vtos(self.origin));
	dprint("\n");
	remove(self);
};

void() PlaceItem = 
{
	local float oldz;
	self.mdl = self.model;
	self.flags = FL_ITEM;
	self.solid = SOLID_TRIGGER;
	self.movetype = MOVETYPE_TOSS;
	self.velocity = '0 0 0';
	self.origin_z = self.origin_z + 6;
	oldz = self.origin_z;
	if (!droptofloor())
	{
		dprint("Bonus item fell out of level at ");
		dprint(vtos(self.origin));
		dprint("\n");
		remove(self);
		return;
	}
};

void() StartItem = 
{
	self.nextthink = time + 0.2;
	self.think = PlaceItem;
};

float(entity e, float healamount, float ignore) T_Heal = 
{
	if (e.health <= 0)
	{
		return 0;
	}
	if (!ignore && e.health >= other.max_health)
	{
		return 0;
	}
	healamount = ceil(healamount);
	e.health = e.health + healamount;
	if (!ignore && e.health >= other.max_health)
	{
		e.health = other.max_health;
	}
	if (e.health > 250)
	{
		e.health = 250;
	}
	return 1;
};

void() item_health = 
{
	self.touch = health_touch;
	if (self.spawnflags & H_ROTTEN)
	{
		precache_model("maps/b_bh10.bsp");
		precache_sound("items/r_item1.wav");
		setmodel(self, "maps/b_bh10.bsp");
		self.noise = "items/r_item1.wav";
		self.healamount = 15;
		self.healtype = 0;
	}
	else
	{
		if (self.spawnflags & H_MEGA)
		{
			precache_model("maps/b_bh100.bsp");
			precache_sound("items/r_item2.wav");
			setmodel(self, "maps/b_bh100.bsp");
			self.noise = "items/r_item2.wav";
			self.healamount = 100;
			self.healtype = 2;
		}
		else
		{
			precache_model("maps/b_bh25.bsp");
			precache_sound("items/health1.wav");
			setmodel(self, "maps/b_bh25.bsp");
			self.noise = "items/health1.wav";
			self.healamount = 25;
			self.healtype = 1;
		}
	}
	setsize(self, '0 0 0', '32 32 56');
	StartItem();
};

void() health_touch = 
{
	local float amount;
	local string s;
	if (other.shub_time > time || other.np_time > time)
	{
		return;
	}
	if (other.classname != "player")
	{
		return;
	}
	if (!(self.healtype == 2) && (self.player_flag & ITEM_RUNE4_FLAG))
	{
		return;
	}
	if (self.healtype == 2)
	{
		if (other.health >= 250)
		{
			return;
		}
		if (!T_Heal(other, self.healamount, 1))
		{
			return;
		}
	}
	else
	{
		if (!T_Heal(other, self.healamount, 0))
		{
			return;
		}
	}
	sprint(other, "You receive ");
	s = ftos(self.healamount);
	sprint(other, s);
	sprint(other, " health\n");
	if (!(other.player_flag & ITEM_RUNE5_FLAG))
	{
		sound(other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
	}
	stuffcmd(other, "bf\n");
	self.model = string_null;
	self.solid = SOLID_NOT;
	if (self.healtype == 2)
	{
		other.items = other.items | IT_SUPERHEALTH;
		self.nextthink = time + 5;
		self.think = item_megahealth_rot;
		self.owner = other;
	}
	else
	{
		if (deathmatch != 2)
		{
			if (deathmatch)
			{
				self.nextthink = time + 20;
			}
			self.think = SUB_regen;
		}
	}
	activator = other;
	SUB_UseTargets();
};

void() item_megahealth_rot = 
{
	other = self.owner;
	if (other.player_flag & ITEM_RUNE4_FLAG)
	{
		return;
	}
	if (other.health > other.max_health)
	{
		other.health = other.health - 1;
		self.nextthink = time + 1;
		return;
	}
	other.items = other.items - (other.items & IT_SUPERHEALTH);
	if (deathmatch == 1)
	{
		self.nextthink = time + 20;
		self.think = SUB_regen;
	}
};

void() armor_touch = 
{
	local float type;
	local float value;
	local float bit;
	if (other.shub_time > time || other.np_time > time)
	{
		return;
	}
	if (other.health <= 0)
	{
		return;
	}
	if (other.classname != "player")
	{
		return;
	}
	if (other.armormax > 0)
	{
		return;
	}
	if (self.classname == "item_armor1")
	{
		type = 0.3;
		value = 100;
		bit = IT_ARMOR1;
	}
	if (self.classname == "item_armor2")
	{
		type = 0.6;
		value = 150;
		bit = IT_ARMOR2;
	}
	if (self.classname == "item_armorInv")
	{
		type = 0.8;
		value = 200;
		bit = IT_ARMOR3;
	}
	if (other.armortype * other.armorvalue >= type * value)
	{
		return;
	}
	other.armortype = type;
	other.armorvalue = value;
	other.items = other.items - (other.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3)) + bit;
	self.solid = SOLID_NOT;
	self.model = string_null;
	if (deathmatch == 1)
	{
		self.nextthink = time + 20;
	}
	self.think = SUB_regen;
	if (!(other.player_flag & ITEM_RUNE5_FLAG))
	{
		sound(other, CHAN_ITEM, "items/armor1.wav", 1, ATTN_NORM);
	}
	stuffcmd(other, "bf\n");
	activator = other;
	SUB_UseTargets();
};

void() soul_touch = 
{
	if (other.shub_time > time || other.np_time > time)
	{
		return;
	}
	if (other.health <= 0)
	{
		return;
	}
	if (other.classname != "player")
	{
		return;
	}
	other.items = other.items - (other.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3));
	if (!(other.armormax))
	{
		other.armormax = 50;
		other.armortype = 0.8;
	}
	other.armorvalue = other.armormax;
	self.solid = SOLID_NOT;
	self.model = string_null;
	sprint(other, "You got the Torn Flesh of Souls\n");
	if (!(other.player_flag & ITEM_RUNE5_FLAG))
	{
		sound(other, CHAN_ITEM, "items/armor1.wav", 1, ATTN_NORM);
	}
	stuffcmd(other, "bf\n");
	activator = other;
	SUB_UseTargets();
	if (deathmatch == 1 || deathmatch == 3)
	{
		self.nextthink = time + 40;
		self.think = SUB_regen;
	}
};

void() item_armor1 = 
{
	self.touch = armor_touch;
	precache_model("progs/armor.mdl");
	setmodel(self, "progs/armor.mdl");
	self.skin = 0;
	self.armorvalue = 100;
	setsize(self, '-16 -16 0', '16 16 56');
	StartItem();
};

void() item_armor2 = 
{
	self.touch = armor_touch;
	precache_model("progs/armor.mdl");
	setmodel(self, "progs/armor.mdl");
	self.skin = 1;
	self.armorvalue = 150;
	setsize(self, '-16 -16 0', '16 16 56');
	StartItem();
};

void() item_armorInv = 
{
	self.touch = armor_touch;
	precache_model("progs/armor.mdl");
	setmodel(self, "progs/armor.mdl");
	self.skin = 2;
	self.armorvalue = 200;
	setsize(self, '-16 -16 0', '16 16 56');
	StartItem();
};

void() item_armorflesh = 
{
	self.touch = soul_touch;
	precache_model("progs/armor.mdl");
	setmodel(self, "progs/armor.mdl");
	self.skin = 3;
	setsize(self, '-16 -16 0', '16 16 56');
	StartItem();
	self.classname = "item_armorflesh";
};

void() bound_other_ammo = 
{
	if (other.ammo_shells > 100)
	{
		other.ammo_shells = 100;
	}
	if (other.ammo_nails > 200)
	{
		other.ammo_nails = 200;
	}
	if (other.ammo_rockets > 100)
	{
		other.ammo_rockets = 100;
	}
	if (other.ammo_cells > 200)
	{
		other.ammo_cells = 200;
	}
};

float(float w) RankForWeapon = 
{
	if (w == WE_PLASMAGUN)
	{
		return 1;
	}
	if (w == WE_WACKY)
	{
		return 2;
	}
	if (w == IT_LIGHTNING)
	{
		if (self.waterlevel < 1)
		{
			return 2;
		}
	}
	if (w == IT_ROCKET_LAUNCHER)
	{
		return 3;
	}
	if (w == IT_SUPER_NAILGUN)
	{
		return 4;
	}
	if (w == WE_BFG)
	{
		return 4;
	}
	if (w == WE_CLUSTER)
	{
		return 4;
	}
	if (w == IT_GRENADE_LAUNCHER)
	{
		return 5;
	}
	if (w == IT_SUPER_SHOTGUN)
	{
		if (self.quad_shot)
		{
			return 5;
		}
		return 6;
	}
	if (w == IT_NAILGUN)
	{
		return 7;
	}
	return 8;
};

void(float old, float new) Deathmatch_Weapon = 
{
	local float or;
	local float nr;
	or = RankForWeapon(old);
	nr = RankForWeapon(new);
	if (nr < or)
	{
		if (xap)
		{
			self.weapon = IT_EXTRA_WEAPON;
			self.weapon2 = new;
			xap = 0;
		}
		else
		{
			self.weapon = new;
		}
	}
};

void() weapon_touch = 
{
	local float hadammo;
	local float best;
	local float new;
	local float old;
	local float new2;
	local entity stemp;
	local float leave;
	if (other.shub_time > time || other.np_time > time)
	{
		return;
	}
	if (!(other.flags & FL_CLIENT))
	{
		return;
	}
	stemp = self;
	self = other;
	best = W_BestWeapon();
	self = stemp;
	if (deathmatch == 2 || coop || deathmatch == 3)
	{
		leave = 1;
	}
	else
	{
		leave = 0;
	}
	if (self.classname == "weapon_supershotgun")
	{
		if (other.items & IT_SUPER_SHOTGUN)
		{
			if (!(other.quad_shot))
			{
				other.quad_shot = 1;
			}
		}
	}
	if (self.classname == "weapon_nailgun")
	{
		if (leave && (other.items & IT_NAILGUN))
		{
			return;
		}
		hadammo = other.ammo_nails;
		new = IT_NAILGUN;
		other.ammo_nails = other.ammo_nails + 30;
	}
	else
	{
		if (self.classname == "weapon_supernailgun")
		{
			if (leave && (other.items & IT_SUPER_NAILGUN))
			{
				return;
			}
			hadammo = other.ammo_rockets;
			new = IT_SUPER_NAILGUN;
			other.ammo_nails = other.ammo_nails + 30;
		}
		else
		{
			if (self.classname == "weapon_supershotgun")
			{
				if (leave && (other.items & IT_SUPER_SHOTGUN))
				{
					return;
				}
				hadammo = other.ammo_rockets;
				new = IT_SUPER_SHOTGUN;
				other.ammo_shells = other.ammo_shells + 5;
			}
			else
			{
				if (self.classname == "weapon_rocketlauncher")
				{
					if (leave && (other.items & IT_ROCKET_LAUNCHER))
					{
						return;
					}
					hadammo = other.ammo_rockets;
					new = IT_ROCKET_LAUNCHER;
					new2 = WE_WACKY;
					other.ammo_rockets = other.ammo_rockets + 5;
				}
				else
				{
					if (self.classname == "weapon_grenadelauncher")
					{
						if (leave && (other.items & IT_GRENADE_LAUNCHER))
						{
							return;
						}
						hadammo = other.ammo_rockets;
						new = IT_GRENADE_LAUNCHER;
						new2 = WE_CLUSTER;
						other.ammo_rockets = other.ammo_rockets + 5;
					}
					else
					{
						if (self.classname == "weapon_lightning")
						{
							if (leave && (other.items & IT_LIGHTNING))
							{
								return;
							}
							hadammo = other.ammo_rockets;
							new = IT_LIGHTNING;
							other.ammo_cells = other.ammo_cells + 15;
						}
						else
						{
							if (self.classname == "weapon_bfg")
							{
								if (leave && (other.weapons & WE_BFG))
								{
									return;
								}
								hadammo = other.ammo_rockets;
								new = IT_EXTRA_WEAPON;
								new2 = WE_BFG;
								other.ammo_cells = other.ammo_cells + 30;
							}
							else
							{
								if (self.classname == "weapon_plasmagun")
								{
									if (leave && (other.weapons & WE_PLASMAGUN))
									{
										return;
									}
									hadammo = other.ammo_rockets;
									new = IT_EXTRA_WEAPON;
									new2 = WE_PLASMAGUN;
									other.ammo_cells = other.ammo_cells + 15;
								}
								else
								{
									if (self.classname == "weapon_sniper_rifle")
									{
										if (leave && (other.weapons & WE_SNIPER_RIFLE))
										{
											return;
										}
										hadammo = other.ammo_rockets;
										new = IT_EXTRA_WEAPON;
										new2 = WE_SNIPER_RIFLE;
										other.ammo_shells = other.ammo_shells + 10;
									}
									else
									{
										objerror("weapon_touch: unknown classname");
									}
								}
							}
						}
					}
				}
			}
		}
	}
	if (!(other.player_flag & ITEM_RUNE5_FLAG))
	{
		sound(other, CHAN_ITEM, "weapons/pkup.wav", 1, ATTN_NORM);
	}
	stuffcmd(other, "bf\n");
	bound_other_ammo();
	old = other.items;
	if (other.weapon == IT_EXTRA_WEAPON)
	{
		old = other.weapon2;
	}
	other.items = other.items | new;
	if (new2)
	{
		other.weapons = other.weapons | new2;
	}
	stemp = self;
	self = other;
	if (new == IT_EXTRA_WEAPON)
	{
		new = new2;
		xap = 1;
	}
	if (!(self.hook_out))
	{
		Deathmatch_Weapon(old, new);
	}
	if (self.weapon == IT_SUPER_SHOTGUN)
	{
		if (self.ammo_shells)
		{
			if (self.quad_shot)
			{
				self.quad_shot = 2;
			}
		}
	}
	if (self.axe_only_time > time)
	{
		self.weapon = IT_AXE;
	}
	TellWeapon();
	W_SetCurrentAmmo();
	self = stemp;
	if (leave)
	{
		return;
	}
	self.model = string_null;
	self.solid = SOLID_NOT;
	if (deathmatch == 1)
	{
		self.nextthink = time + 30;
	}
	self.think = SUB_regen;
	activator = other;
	SUB_UseTargets();
};

void() weapon_supershotgun = 
{
	precache_model("progs/g_shot.mdl");
	setmodel(self, "progs/g_shot.mdl");
	self.weapon = IT_SUPER_SHOTGUN;
	self.netname = "Double-barrelled Shotgun";
	self.touch = weapon_touch;
	setsize(self, '-16 -16 0', '16 16 56');
	StartItem();
};

void() weapon_nailgun = 
{
	precache_model("progs/g_nail.mdl");
	setmodel(self, "progs/g_nail.mdl");
	self.weapon = IT_NAILGUN;
	self.netname = "nailgun";
	self.touch = weapon_touch;
	setsize(self, '-16 -16 0', '16 16 56');
	StartItem();
};

void() weapon_supernailgun = 
{
	precache_model("progs/g_nail2.mdl");
	setmodel(self, "progs/g_nail2.mdl");
	self.weapon = IT_SUPER_NAILGUN;
	self.netname = "Super Nailgun";
	self.touch = weapon_touch;
	setsize(self, '-16 -16 0', '16 16 56');
	StartItem();
};

void() weapon_grenadelauncher = 
{
	precache_model("progs/g_rock.mdl");
	setmodel(self, "progs/g_rock.mdl");
	self.weapon = 3;
	self.netname = "Grenade Launcher";
	self.touch = weapon_touch;
	setsize(self, '-16 -16 0', '16 16 56');
	StartItem();
};

void() weapon_rocketlauncher = 
{
	precache_model("progs/g_rock2.mdl");
	setmodel(self, "progs/g_rock2.mdl");
	self.weapon = 3;
	self.netname = "Rocket Launcher";
	self.touch = weapon_touch;
	setsize(self, '-16 -16 0', '16 16 56');
	StartItem();
};

void() weapon_lightning = 
{
	precache_model("progs/g_light.mdl");
	setmodel(self, "progs/g_light.mdl");
	self.weapon = 3;
	self.netname = "Thunderbolt";
	self.touch = weapon_touch;
	setsize(self, '-16 -16 0', '16 16 56');
	StartItem();
};

void() weapon_sniper_rifle = 
{
	precache_model("progs/g_sniper.mdl");
	setmodel(self, "progs/g_sniper.mdl");
	self.weapon = 3;
	self.netname = "Sniper Rifle";
	self.touch = weapon_touch;
	setsize(self, '-16 -16 0', '16 16 56');
	StartItem();
};

void() ammo_touch = 
{
	local entity stemp;
	local float best;
	if (other.shub_time > time || other.np_time > time)
	{
		return;
	}
	if (other.classname != "player")
	{
		return;
	}
	if (other.health <= 0)
	{
		return;
	}
	stemp = self;
	self = other;
	best = W_BestWeapon();
	self = stemp;
	if (self.weapon == 1)
	{
		if (other.ammo_shells >= 100)
		{
			return;
		}
		other.ammo_shells = other.ammo_shells + self.aflag;
	}
	if (self.weapon == 2)
	{
		if (other.ammo_nails >= 200)
		{
			return;
		}
		other.ammo_nails = other.ammo_nails + self.aflag;
	}
	if (self.weapon == 3)
	{
		if (other.ammo_rockets >= 100)
		{
			return;
		}
		other.ammo_rockets = other.ammo_rockets + self.aflag;
	}
	if (self.weapon == 4)
	{
		if (other.ammo_cells >= 200)
		{
			return;
		}
		other.ammo_cells = other.ammo_cells + self.aflag;
	}
	bound_other_ammo();
	if (!(other.player_flag & ITEM_RUNE5_FLAG))
	{
		sound(other, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);
	}
	stuffcmd(other, "bf\n");
	if (other.weapon == best)
	{
		stemp = self;
		self = other;
		self.weapon = W_BestWeapon();
		W_SetCurrentAmmo();
		self = stemp;
	}
	stemp = self;
	self = other;
	W_SetCurrentAmmo();
	self = stemp;
	self.model = string_null;
	self.solid = SOLID_NOT;
	if (deathmatch == 1)
	{
		self.nextthink = time + 30;
	}
	else
	{
		if (deathmatch == 3)
		{
			self.nextthink = time + 15;
		}
	}
	self.think = SUB_regen;
	activator = other;
	SUB_UseTargets();
};

void() item_shells = 
{
	self.touch = ammo_touch;
	if (self.spawnflags & WEAPON_BIG2)
	{
		precache_model("maps/b_shell1.bsp");
		setmodel(self, "maps/b_shell1.bsp");
		self.aflag = 40;
	}
	else
	{
		precache_model("maps/b_shell0.bsp");
		setmodel(self, "maps/b_shell0.bsp");
		self.aflag = 20;
	}
	self.weapon = 1;
	self.netname = "shells";
	setsize(self, '0 0 0', '32 32 56');
	StartItem();
};

void() item_spikes = 
{
	self.touch = ammo_touch;
	if (self.spawnflags & WEAPON_BIG2)
	{
		precache_model("maps/b_nail1.bsp");
		setmodel(self, "maps/b_nail1.bsp");
		self.aflag = 50;
	}
	else
	{
		precache_model("maps/b_nail0.bsp");
		setmodel(self, "maps/b_nail0.bsp");
		self.aflag = 25;
	}
	self.weapon = 2;
	self.netname = "nails";
	setsize(self, '0 0 0', '32 32 56');
	StartItem();
};

void() item_rockets = 
{
	self.touch = ammo_touch;
	if (self.spawnflags & WEAPON_BIG2)
	{
		precache_model("maps/b_rock1.bsp");
		setmodel(self, "maps/b_rock1.bsp");
		self.aflag = 10;
	}
	else
	{
		precache_model("maps/b_rock0.bsp");
		setmodel(self, "maps/b_rock0.bsp");
		self.aflag = 5;
	}
	self.weapon = 3;
	self.netname = "rockets";
	setsize(self, '0 0 0', '32 32 56');
	StartItem();
};

void() item_cells = 
{
	self.touch = ammo_touch;
	if (self.spawnflags & WEAPON_BIG2)
	{
		precache_model("maps/b_batt1.bsp");
		setmodel(self, "maps/b_batt1.bsp");
		self.aflag = 12;
	}
	else
	{
		precache_model("maps/b_batt0.bsp");
		setmodel(self, "maps/b_batt0.bsp");
		self.aflag = 6;
	}
	self.weapon = 4;
	self.netname = "cells";
	setsize(self, '0 0 0', '32 32 56');
	StartItem();
};

void() item_weapon = 
{
	self.touch = ammo_touch;
	if (self.spawnflags & WEAPON_SHOTGUN)
	{
		if (self.spawnflags & WEAPON_BIG)
		{
			precache_model("maps/b_shell1.bsp");
			setmodel(self, "maps/b_shell1.bsp");
			self.aflag = 40;
		}
		else
		{
			precache_model("maps/b_shell0.bsp");
			setmodel(self, "maps/b_shell0.bsp");
			self.aflag = 20;
		}
		self.weapon = 1;
		self.netname = "shells";
	}
	if (self.spawnflags & WEAPON_SPIKES)
	{
		if (self.spawnflags & WEAPON_BIG)
		{
			precache_model("maps/b_nail1.bsp");
			setmodel(self, "maps/b_nail1.bsp");
			self.aflag = 40;
		}
		else
		{
			precache_model("maps/b_nail0.bsp");
			setmodel(self, "maps/b_nail0.bsp");
			self.aflag = 20;
		}
		self.weapon = 2;
		self.netname = "spikes";
	}
	if (self.spawnflags & WEAPON_ROCKET)
	{
		if (self.spawnflags & WEAPON_BIG)
		{
			precache_model("maps/b_rock1.bsp");
			setmodel(self, "maps/b_rock1.bsp");
			self.aflag = 10;
		}
		else
		{
			precache_model("maps/b_rock0.bsp");
			setmodel(self, "maps/b_rock0.bsp");
			self.aflag = 5;
		}
		self.weapon = 3;
		self.netname = "rockets";
	}
	setsize(self, '0 0 0', '32 32 56');
	StartItem();
};

void() key_touch = 
{
	local entity stemp;
	local float best;
	if (other.shub_time > time || other.np_time > time)
	{
		return;
	}
	if (other.classname != "player")
	{
		return;
	}
	if (other.health <= 0)
	{
		return;
	}
	if (other.items & self.items)
	{
		return;
	}
	if (!(other.player_flag & ITEM_RUNE5_FLAG))
	{
		sound(other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
	}
	stuffcmd(other, "bf\n");
	other.items = other.items | self.items;
	if (!coop)
	{
		self.solid = SOLID_NOT;
		self.model = string_null;
	}
	activator = other;
	SUB_UseTargets();
};

void() key_setsounds = 
{
	if (world.worldtype == 0)
	{
		precache_sound("misc/medkey.wav");
		self.noise = "misc/medkey.wav";
	}
	if (world.worldtype == 1)
	{
		precache_sound("misc/runekey.wav");
		self.noise = "misc/runekey.wav";
	}
	if (world.worldtype == 2)
	{
		precache_sound2("misc/basekey.wav");
		self.noise = "misc/basekey.wav";
	}
};

void() item_key1 = 
{
	if (world.worldtype == 0)
	{
		precache_model("progs/w_s_key.mdl");
		setmodel(self, "progs/w_s_key.mdl");
		self.netname = "silver key";
	}
	else
	{
		if (world.worldtype == 1)
		{
			precache_model("progs/m_s_key.mdl");
			setmodel(self, "progs/m_s_key.mdl");
			self.netname = "silver runekey";
		}
		else
		{
			if (world.worldtype == 2)
			{
				precache_model2("progs/b_s_key.mdl");
				setmodel(self, "progs/b_s_key.mdl");
				self.netname = "silver keycard";
			}
		}
	}
	key_setsounds();
	self.touch = key_touch;
	self.items = IT_KEY1;
	setsize(self, '-16 -16 -24', '16 16 32');
	StartItem();
};

void() item_key2 = 
{
	if (world.worldtype == 0)
	{
		precache_model("progs/w_g_key.mdl");
		setmodel(self, "progs/w_g_key.mdl");
		self.netname = "gold key";
	}
	if (world.worldtype == 1)
	{
		precache_model("progs/m_g_key.mdl");
		setmodel(self, "progs/m_g_key.mdl");
		self.netname = "gold runekey";
	}
	if (world.worldtype == 2)
	{
		precache_model2("progs/b_g_key.mdl");
		setmodel(self, "progs/b_g_key.mdl");
		self.netname = "gold keycard";
	}
	key_setsounds();
	self.touch = key_touch;
	self.items = IT_KEY2;
	setsize(self, '-16 -16 -24', '16 16 32');
	StartItem();
};

void() sigil_touch = 
{
	local entity stemp;
	local float best;
	if (other.classname != "player")
	{
		return;
	}
	if (other.health <= 0)
	{
		return;
	}
	SetMsg(other, "You got the rune!");
	if (!(other.player_flag & ITEM_RUNE5_FLAG))
	{
		sound(other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
	}
	stuffcmd(other, "bf\n");
	self.solid = SOLID_NOT;
	self.model = string_null;
	serverflags = serverflags | (self.spawnflags & 15);
	self.classname = "";
	activator = other;
	SUB_UseTargets();
};

void() item_sigil = 
{
	if (!(self.spawnflags))
	{
		objerror("no spawnflags");
	}
	precache_sound("misc/runekey.wav");
	self.noise = "misc/runekey.wav";
	if (self.spawnflags & 1)
	{
		precache_model("progs/end1.mdl");
		setmodel(self, "progs/end1.mdl");
	}
	if (self.spawnflags & 2)
	{
		precache_model2("progs/end2.mdl");
		setmodel(self, "progs/end2.mdl");
	}
	if (self.spawnflags & 4)
	{
		precache_model2("progs/end3.mdl");
		setmodel(self, "progs/end3.mdl");
	}
	if (self.spawnflags & 8)
	{
		precache_model2("progs/end4.mdl");
		setmodel(self, "progs/end4.mdl");
	}
	self.touch = sigil_touch;
	setsize(self, '-16 -16 -24', '16 16 32');
	StartItem();
};

void() powerup_touch = 
{
	local entity stemp;
	local float best;
	if (other.shub_time > time || other.np_time > time)
	{
		return;
	}
	if (other.classname != "player")
	{
		return;
	}
	if (other.health <= 0)
	{
		return;
	}
	if (other.player_flag & ITEM_RUNE9_FLAG)
	{
		return;
	}
	if (deathmatch)
	{
		self.mdl = self.model;
		if (self.classname == "item_artifact_invulnerability" || self.classname == "item_artifact_invisibility")
		{
			self.nextthink = time + 60 * 5;
		}
		else
		{
			self.nextthink = time + 60;
		}
		self.think = SUB_regen;
	}
	if (!(other.player_flag & ITEM_RUNE5_FLAG))
	{
		sound(other, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	}
	stuffcmd(other, "bf\n");
	self.solid = SOLID_NOT;
	other.items = other.items | self.items;
	self.model = string_null;
	if (self.classname == "item_artifact_envirosuit")
	{
		other.rad_time = 1;
		other.radsuit_finished = time + 30;
	}
	if (self.classname == "item_artifact_invulnerability")
	{
		other.invincible_time = 1;
		other.invincible_finished = time + 30;
	}
	if (self.classname == "item_artifact_invisibility")
	{
		other.invisible_time = 1;
		other.invisible_finished = time + 30;
	}
	if (self.classname == "item_artifact_super_damage")
	{
		other.super_time = 1;
		other.super_damage_finished = time + 30;
		other.bad_quad = 0;
	}
	if (self.classname == "item_artifact_blood_lust")
	{
		other.blood_time = 1;
		other.blood_finished = time + 30;
	}
	activator = other;
	SUB_UseTargets();
};

void() item_artifact_blood_lust = 
{
	self.touch = powerup_touch;
	precache_model("progs/bloodl.mdl");
	precache_sound("items/blood1.wav");
	precache_sound("items/blood2.wav");
	precache_sound("items/blood3.wav");
	self.noise = "items/blood1.wav";
	setmodel(self, "progs/bloodl.mdl");
	self.netname = "Blood Lust";
	setsize(self, '-16 -16 -24', '16 16 32');
	StartItem();
};

void() item_artifact_invulnerability = 
{
	self.touch = powerup_touch;
	precache_model("progs/invulner.mdl");
	precache_sound("items/protect.wav");
	precache_sound("items/protect2.wav");
	precache_sound("items/protect3.wav");
	self.noise = "items/protect.wav";
	setmodel(self, "progs/invulner.mdl");
	self.netname = "Pentagram of Protection";
	self.items = IT_INVULNERABILITY;
	setsize(self, '-16 -16 -24', '16 16 32');
	StartItem();
};

void() item_artifact_envirosuit = 
{
	self.touch = powerup_touch;
	precache_model("progs/suit.mdl");
	precache_sound("items/suit.wav");
	precache_sound("items/suit2.wav");
	self.noise = "items/suit.wav";
	setmodel(self, "progs/suit.mdl");
	self.netname = "Biosuit";
	self.items = IT_SUIT;
	setsize(self, '-16 -16 -24', '16 16 32');
	StartItem();
};

void() item_artifact_invisibility = 
{
	self.touch = powerup_touch;
	precache_model("progs/invisibl.mdl");
	precache_sound("items/inv1.wav");
	precache_sound("items/inv2.wav");
	precache_sound("items/inv3.wav");
	self.noise = "items/inv1.wav";
	setmodel(self, "progs/invisibl.mdl");
	self.netname = "Ring of Shadows";
	self.items = IT_INVISIBILITY;
	setsize(self, '-16 -16 -24', '16 16 32');
	StartItem();
};

void() item_artifact_super_damage = 
{
	self.touch = powerup_touch;
	precache_model("progs/quaddama.mdl");
	precache_sound("items/damage.wav");
	precache_sound("items/damage2.wav");
	precache_sound("items/damage3.wav");
	self.noise = "items/damage.wav";
	setmodel(self, "progs/quaddama.mdl");
	self.netname = "Quad Damage";
	self.items = IT_QUAD;
	setsize(self, '-16 -16 -24', '16 16 32');
	StartItem();
};

void() BackpackTouch = 
{
	local string s;
	local float best;
	local float bit;
	local entity stemp;
	if (other.shub_time > time || other.np_time > time)
	{
		return;
	}
	if (other.classname != "player")
	{
		return;
	}
	if (other.health <= 0)
	{
		return;
	}
	if (other == self.owner && self.armorvalue > time)
	{
		return;
	}
	stemp = self;
	self = other;
	best = W_BestWeapon();
	self = stemp;
	other.ammo_shells = other.ammo_shells + self.ammo_shells;
	other.ammo_nails = other.ammo_nails + self.ammo_nails;
	other.ammo_rockets = other.ammo_rockets + self.ammo_rockets;
	other.ammo_cells = other.ammo_cells + self.ammo_cells;
	other.items = other.items | self.items;
	bound_other_ammo();
	sprint(other, "You get ");
	if (self.ammo_shells)
	{
		s = ftos(self.ammo_shells);
		sprint(other, s);
		sprint(other, " shells  ");
	}
	if (self.ammo_nails)
	{
		s = ftos(self.ammo_nails);
		sprint(other, s);
		sprint(other, " nails ");
	}
	if (self.ammo_rockets)
	{
		s = ftos(self.ammo_rockets);
		sprint(other, s);
		sprint(other, " rockets  ");
	}
	if (self.ammo_cells)
	{
		s = ftos(self.ammo_cells);
		sprint(other, s);
		sprint(other, " cells  ");
	}
	if (self.items & IT_QUAD)
	{
		if (!(self.bad_quad))
		{
			sprint(other, "Quad  ");
		}
		else
		{
			sprint(other, "Wimpy  ");
		}
		if (other.super_damage_finished > time)
		{
			other.super_damage_finished = self.super_damage_finished + other.super_damage_finished;
		}
		else
		{
			other.super_damage_finished = self.super_damage_finished + time + other.super_damage_finished;
		}
		other.super_time = 1;
		other.bad_quad = self.bad_quad;
	}
	if (self.items & IT_SUIT)
	{
		sprint(other, "Suit  ");
		if (other.radsuit_finished > time)
		{
			other.radsuit_finished = self.radsuit_finished + other.radsuit_finished;
		}
		else
		{
			other.radsuit_finished = self.radsuit_finished + time + other.radsuit_finished;
		}
		other.rad_time = 1;
	}
	if (self.items & IT_INVISIBILITY)
	{
		sprint(other, "Invis  ");
		if (other.invisible_finished > time)
		{
			other.invisible_finished = self.invisible_finished + other.invisible_finished;
		}
		else
		{
			other.invisible_finished = self.invisible_finished + time;
		}
		other.invisible_time = 1;
	}
	if (self.blood_finished)
	{
		sprint(other, "Blood Lust");
		if (other.blood_finished)
		{
			other.blood_finished = self.blood_finished + other.blood_finished;
		}
		else
		{
			other.blood_finished = self.blood_finished + other.blood_finished + time;
		}
	}
	sprint(other, "\n");
	if (!(other.player_flag & ITEM_RUNE5_FLAG))
	{
		sound(other, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);
	}
	stuffcmd(other, "bf\n");
	remove(self);
	self = other;
	W_SetCurrentAmmo();
};

void() DropBackpack = 
{
	local entity item;
	if (!(self.ammo_shells + self.ammo_nails + self.ammo_rockets + self.ammo_cells + self.armorvalue))
	{
		return;
	}
	item = spawn();
	item.origin = self.origin - '0 0 24';
	if (self.items & IT_SUIT)
	{
		item.radsuit_finished = self.radsuit_finished - time;
		item.items = item.items | IT_SUIT;
	}
	if (self.items & IT_INVISIBILITY)
	{
		item.invisible_finished = self.invisible_finished - time;
		item.items = item.items | IT_INVISIBILITY;
	}
	if (self.items & IT_QUAD && !(self.bad_quad))
	{
		item.super_damage_finished = self.super_damage_finished - time;
		item.items = item.items | IT_QUAD;
	}
	if (self.blood_finished > time)
	{
		item.blood_finished = self.blood_finished - time;
	}
	item.ammo_shells = self.ammo_shells;
	item.ammo_nails = self.ammo_nails;
	item.ammo_rockets = self.ammo_rockets;
	item.ammo_cells = self.ammo_cells;
	item.velocity_z = 300;
	item.velocity_x = -100 + random() * 200;
	item.velocity_y = -100 + random() * 200;
	item.flags = FL_ITEM;
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_TOSS;
	setmodel(item, "progs/backpack.mdl");
	setsize(item, '-16 -16 0', '16 16 56');
	item.touch = BackpackTouch;
	item.armorvalue = time + 2;
	item.nextthink = time + 120;
	item.think = SUB_Remove;
};

void() weapon_touch2 = 
{
	local float hadammo;
	local float best;
	local float new;
	local float old;
	local entity stemp;
	local float leave;
	if (other.shub_time > time || other.np_time > time)
	{
		return;
	}
	if (!(other.flags & FL_CLIENT))
	{
		return;
	}
	if (other == self.owner && self.armorvalue > time)
	{
		return;
	}
	stemp = self;
	self = other;
	best = W_BestWeapon();
	self = stemp;
	if (self.classname == "weapon_nailgun")
	{
		new = IT_NAILGUN;
	}
	else
	{
		if (self.classname == "weapon_supernailgun")
		{
			new = IT_SUPER_NAILGUN;
		}
		else
		{
			if (self.classname == "weapon_supershotgun")
			{
				new = IT_SUPER_SHOTGUN;
			}
			else
			{
				if (self.classname == "weapon_rocketlauncher")
				{
					new = IT_ROCKET_LAUNCHER;
				}
				else
				{
					if (self.classname == "weapon_grenadelauncher")
					{
						new = IT_GRENADE_LAUNCHER;
					}
					else
					{
						if (self.classname == "weapon_lightning")
						{
							new = IT_LIGHTNING;
						}
						else
						{
							if (self.classname == "weapon_bfg")
							{
								new = WE_BFG;
								xap = 1;
							}
							else
							{
								if (self.classname == "weapon_plasma")
								{
									new = WE_PLASMAGUN;
									xap = 1;
								}
								else
								{
									if (self.classname == "weapon_sniper_rifle")
									{
										new = WE_SNIPER_RIFLE;
										xap = 1;
									}
									else
									{
										objerror("weapon_touch: unknown classname");
									}
								}
							}
						}
					}
				}
			}
		}
	}
	sprint(other, "You got the ");
	sprint(other, self.netname);
	sprint(other, "\n");
	if (!(other.player_flag & ITEM_RUNE5_FLAG))
	{
		sound(other, CHAN_ITEM, "weapons/pkup.wav", 1, ATTN_NORM);
	}
	stuffcmd(other, "bf\n");
	bound_other_ammo();
	if (new == WE_BFG || new == WE_SNIPER_RIFLE || new == WE_PLASMAGUN)
	{
		other.weapons = other.weapons | new;
	}
	else
	{
		other.items = other.items | new;
	}
	if (new == IT_GRENADE_LAUNCHER)
	{
		other.weapons = other.weapons | WE_CLUSTER;
	}
	if (new == IT_ROCKET_LAUNCHER)
	{
		other.weapons = other.weapons | WE_WACKY;
	}
	stemp = self;
	self = other;
	old = self.weapon;
	if (self.weapon == IT_EXTRA_WEAPON)
	{
		old = self.weapon2;
	}
	if (!(self.hook_out))
	{
		Deathmatch_Weapon(old, new);
	}
	W_SetCurrentAmmo();
	TellWeapon();
	self = stemp;
	remove(self);
};

void() DropWeapon = 
{
	local entity item;
	if (self.weapon == IT_SHOTGUN || self.weapon == IT_AXE)
	{
		return;
	}
	if (self.weapon == IT_EXTRA_WEAPON)
	{
		if (self.weapon2 == WE_GRAPPLE || self.weapon2 == WE_AIRFIST)
		{
			return;
		}
	}
	item = spawn();
	item.owner = self;
	makevectors(self.v_angle);
	setorigin(item, self.origin + '0 0 16');
	item.velocity = aim(self, 1000);
	item.velocity = item.velocity * 500;
	item.flags = FL_ITEM;
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_BOUNCE;
	if (self.weapon == IT_SUPER_SHOTGUN)
	{
		setmodel(item, "progs/g_shot.mdl");
		item.weapon = IT_SUPER_SHOTGUN;
		item.netname = "Double-barrelled Shotgun";
		item.classname = "weapon_supershotgun";
		self.items = self.items - IT_SUPER_SHOTGUN;
	}
	else
	{
		if (self.weapon == IT_NAILGUN)
		{
			setmodel(item, "progs/g_nail.mdl");
			item.weapon = IT_NAILGUN;
			item.netname = "nailgun";
			item.classname = "weapon_nailgun";
			self.items = self.items - IT_NAILGUN;
		}
		else
		{
			if (self.weapon == IT_SUPER_NAILGUN)
			{
				setmodel(item, "progs/g_nail2.mdl");
				item.weapon = IT_SUPER_NAILGUN;
				item.netname = "Super Nailgun";
				item.classname = "weapon_supernailgun";
				self.items = self.items - IT_SUPER_NAILGUN;
			}
			else
			{
				if (self.weapon == IT_GRENADE_LAUNCHER || (self.weapon == IT_EXTRA_WEAPON && self.weapon2 == WE_CLUSTER))
				{
					setmodel(item, "progs/g_rock.mdl");
					item.weapon = IT_GRENADE_LAUNCHER;
					item.netname = "Grenade Launcher";
					item.classname = "weapon_grenadelauncher";
					self.items = self.items - IT_GRENADE_LAUNCHER;
				}
				else
				{
					if (self.weapon == IT_ROCKET_LAUNCHER || (self.weapon == IT_EXTRA_WEAPON && self.weapon2 == WE_WACKY))
					{
						setmodel(item, "progs/g_rock2.mdl");
						item.weapon = 3;
						item.netname = "Rocket Launcher";
						item.classname = "weapon_rocketlauncher";
						self.items = self.items - IT_ROCKET_LAUNCHER;
					}
					else
					{
						if (self.weapon == IT_LIGHTNING)
						{
							setmodel(item, "progs/g_light.mdl");
							item.weapon = 3;
							item.netname = "Thunderbolt";
							item.classname = "weapon_lightning";
							self.items = self.items - IT_LIGHTNING;
						}
						else
						{
							if (self.weapon == IT_EXTRA_WEAPON && self.weapon2 == WE_PLASMAGUN)
							{
								setmodel(item, "progs/g_plasma.mdl");
								item.weapon = 3;
								item.netname = "Plasma Rifle";
								item.classname = "weapon_plasma";
								self.weapons = self.weapons - WE_PLASMAGUN;
							}
							else
							{
								if (self.weapon == IT_EXTRA_WEAPON && self.weapon2 == WE_BFG)
								{
									setmodel(item, "progs/g_bfg.mdl");
									item.weapon = 3;
									item.netname = "BFG 9000";
									item.classname = "weapon_bfg";
									self.weapons = self.weapons - WE_BFG;
								}
								else
								{
									if (self.weapon == IT_EXTRA_WEAPON && self.weapon2 == WE_SNIPER_RIFLE)
									{
										setmodel(item, "progs/g_sniper.mdl");
										item.weapon = 3;
										item.netname = "Sniper Rifle";
										item.touch = weapon_touch2;
										item.classname = "weapon_sniper_rifle";
										self.weapons = self.weapons - WE_SNIPER_RIFLE;
									}
								}
							}
						}
					}
				}
			}
		}
	}
	setsize(item, '-16 -16 0', '16 16 56');
	item.touch = weapon_touch2;
	item.armorvalue = time + 2;
	item.think = SUB_Remove;
	item.nextthink = time + 120;
	if (!(self.deadflag))
	{
		self.weapon = W_BestWeapon();
		W_SetCurrentAmmo();
	}
};

void() DropBPack = 
{
	local entity item;
	if (self.currentammo <= 0)
	{
		return;
	}
	item = spawn();
	if (self.weapon == IT_SHOTGUN || self.weapon == IT_SUPER_SHOTGUN)
	{
		if (self.ammo_shells >= 20)
		{
			item.ammo_shells = 20;
			self.ammo_shells = self.ammo_shells - 20;
		}
		else
		{
			item.ammo_shells = self.ammo_shells;
			self.ammo_shells = 0;
		}
	}
	if (!(self.items & IT_SHOTGUN) && !(self.items & IT_SUPER_SHOTGUN))
	{
		if (self.ammo_shells >= 20)
		{
			item.ammo_shells = 20;
			self.ammo_shells = self.ammo_shells - 20;
		}
		else
		{
			item.ammo_shells = self.ammo_shells;
			self.ammo_shells = 0;
		}
	}
	if (self.weapon == IT_NAILGUN || self.weapon == IT_SUPER_NAILGUN)
	{
		if (self.ammo_nails >= 20)
		{
			item.ammo_nails = 20;
			self.ammo_nails = self.ammo_nails - 20;
		}
		else
		{
			item.ammo_nails = self.ammo_nails;
			self.ammo_nails = 0;
		}
	}
	if (!(self.items & IT_NAILGUN) && !(self.items & IT_SUPER_NAILGUN))
	{
		if (self.ammo_nails >= 20)
		{
			item.ammo_nails = 20;
			self.ammo_nails = self.ammo_nails - 20;
		}
		else
		{
			item.ammo_nails = self.ammo_nails;
			self.ammo_nails = 0;
		}
	}
	if (self.weapon == IT_GRENADE_LAUNCHER || self.weapon == IT_ROCKET_LAUNCHER)
	{
		if (self.ammo_rockets >= 10)
		{
			item.ammo_rockets = 10;
			self.ammo_rockets = self.ammo_rockets - 10;
		}
		else
		{
			item.ammo_rockets = self.ammo_rockets;
			self.ammo_rockets = 0;
		}
	}
	if (!(self.items & IT_GRENADE_LAUNCHER) && !(self.items & IT_ROCKET_LAUNCHER))
	{
		if (self.ammo_rockets >= 10)
		{
			item.ammo_rockets = 10;
			self.ammo_rockets = self.ammo_rockets - 10;
		}
		else
		{
			item.ammo_rockets = self.ammo_rockets;
			self.ammo_rockets = 0;
		}
	}
	if (self.weapon == IT_LIGHTNING)
	{
		if (self.ammo_cells >= 20)
		{
			item.ammo_cells = 20;
			self.ammo_cells = self.ammo_cells - 20;
		}
		else
		{
			item.ammo_cells = self.ammo_cells;
			self.ammo_cells = 0;
		}
	}
	if (!(self.items & IT_LIGHTNING))
	{
		if (self.ammo_cells >= 20)
		{
			item.ammo_cells = 20;
			self.ammo_cells = self.ammo_cells - 20;
		}
		else
		{
			item.ammo_cells = self.ammo_cells;
			self.ammo_cells = 0;
		}
	}
	item.owner = self;
	makevectors(self.v_angle);
	setorigin(item, self.origin + '0 0 16');
	item.velocity = aim(self, 1000);
	item.velocity = item.velocity * 500;
	item.flags = FL_ITEM;
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_BOUNCE;
	setmodel(item, "progs/backpack.mdl");
	setsize(item, '-16 -16 0', '16 16 56');
	item.touch = BackpackTouch;
	item.nextthink = time + 120;
	item.think = SUB_Remove;
	item.armorvalue = time + 2;
	W_SetCurrentAmmo();
	item.classname = "backpack";
	item.netname = "backpack";
};

void() armor_touch2 = 
{
	local float type;
	local float value;
	local float bit;
	if (other.shub_time > time || other.np_time > time)
	{
		return;
	}
	if (other.health <= 0)
	{
		return;
	}
	if (other.classname != "player")
	{
		return;
	}
	if (other == self.owner && self.armortype > time)
	{
		return;
	}
	if (other.armormax > 0)
	{
		other.armorvalue = other.armorvalue + self.armorvalue;
		if (other.armorvalue > 200)
		{
			other.armorvalue = 200;
		}
		return;
	}
	if (self.classname == "item_armor1")
	{
		type = 0.3;
		bit = IT_ARMOR1;
	}
	if (self.classname == "item_armor2")
	{
		type = 0.6;
		bit = IT_ARMOR2;
	}
	if (self.classname == "item_armorInv")
	{
		type = 0.8;
		bit = IT_ARMOR3;
	}
	if (other.armortype * other.armorvalue >= type * self.armorvalue)
	{
		return;
	}
	other.armortype = type;
	other.armorvalue = self.armorvalue;
	other.items = other.items - (other.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3)) + bit;
	self.solid = SOLID_NOT;
	self.model = string_null;
	sprint(other, "You got armor\n");
	if (!(other.player_flag & ITEM_RUNE5_FLAG))
	{
		sound(other, CHAN_ITEM, "items/armor1.wav", 1, ATTN_NORM);
	}
	stuffcmd(other, "bf\n");
	activator = other;
	SUB_UseTargets();
};

void() DropArmor = 
{
	local entity item;
	sprint(self, "Disabled\n");
	return;
	if (self.armorvalue <= 0)
	{
		return;
	}
	item = spawn();
	if (self.items & IT_ARMOR3)
	{
		item.items = item.items | IT_ARMOR3;
		item.skin = 2;
		item.classname = "item_armorInv";
	}
	else
	{
		if (self.items & IT_ARMOR2)
		{
			item.items = item.items | IT_ARMOR2;
			item.skin = 1;
			item.classname = "item_armor2";
		}
		else
		{
			if (self.items & IT_ARMOR1)
			{
				item.items = item.items | IT_ARMOR1;
				item.skin = 0;
				item.classname = "item_armor1";
			}
		}
	}
	item.armorvalue = self.armorvalue;
	self.items = self.items - (self.items & (IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3));
	self.armorvalue = 0;
	self.armortype = 0;
	item.owner = self;
	makevectors(self.v_angle);
	setorigin(item, self.origin + '0 0 16');
	item.velocity = aim(self, 1000);
	item.velocity = item.velocity * 500;
	item.flags = FL_ITEM;
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_BOUNCE;
	item.armortype = time + 2;
	setmodel(item, "progs/armor.mdl");
	setsize(item, '-16 -16 0', '16 16 56');
	item.touch = armor_touch2;
	item.nextthink = time + 120;
	item.think = SUB_Remove;
	W_SetCurrentAmmo();
	item.netname = "armor";
};

