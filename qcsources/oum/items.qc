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
	self.velocity = VEC_ORIGIN;
	self.origin_z = self.origin_z + MOVETYPE_TOSS;
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
			self.healamount = MAX_SHELLS;
			self.healtype = FL_SWIM;
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
	setsize(self, VEC_ORIGIN, '32 32 56');
	StartItem();
};

void() health_touch = 
{
	local float amount;
	local string s;
	if (other.classname != "player")
	{
		return;
	}
	if (self.healtype == FL_SWIM)
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
	sound(other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
	stuffcmd(other, "bf\n");
	self.model = string_null;
	self.solid = SOLID_NOT;
	if (self.healtype == FL_SWIM)
	{
		other.items = other.items | IT_SUPERHEALTH;
		self.nextthink = time + MOVETYPE_FLY;
		self.think = item_megahealth_rot;
		self.owner = other;
	}
	else
	{
		if (deathmatch != FL_SWIM)
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
	if (self.healtype != FL_SWIM)
	{
		remove(self);
	}
};

void() item_megahealth_rot = 
{
	other = self.owner;
	if (other.health > other.max_health)
	{
		other.health = other.health - 1;
		self.nextthink = time + 1;
		return;
	}
	else
	{
		if (!deathmatch)
		{
			remove(self);
		}
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
	if (other.health <= 0)
	{
		return;
	}
	if (other.classname != "player")
	{
		return;
	}
	if (self.classname == "item_armor1")
	{
		type = 0.3;
		value = MAX_SHELLS;
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
		value = MAX_NAILS;
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
	sprint(other, "You got armor\n");
	sound(other, CHAN_ITEM, "items/armor1.wav", 1, ATTN_NORM);
	stuffcmd(other, "bf\n");
	activator = other;
	SUB_UseTargets();
	if (!deathmatch)
	{
		remove(self);
	}
};

void() item_armor1 = 
{
	self.touch = armor_touch;
	precache_model("progs/armor.mdl");
	setmodel(self, "progs/armor.mdl");
	self.skin = 0;
	setsize(self, '-16 -16 0', '16 16 56');
	StartItem();
};

void() item_armor2 = 
{
	self.touch = armor_touch;
	precache_model("progs/armor.mdl");
	setmodel(self, "progs/armor.mdl");
	self.skin = 1;
	setsize(self, '-16 -16 0', '16 16 56');
	StartItem();
};

void() item_armorInv = 
{
	self.touch = armor_touch;
	precache_model("progs/armor.mdl");
	setmodel(self, "progs/armor.mdl");
	self.skin = FL_SWIM;
	setsize(self, '-16 -16 0', '16 16 56');
	StartItem();
};

void() bound_other_ammo = 
{
	if (other.ammo_shells > MAX_SHELLS)
	{
		other.ammo_shells = MAX_SHELLS;
	}
	if (other.ammo_nails > MAX_NAILS)
	{
		other.ammo_nails = MAX_NAILS;
	}
	if (other.ammo_rockets > MAX_SHELLS)
	{
		other.ammo_rockets = MAX_SHELLS;
	}
	if (other.ammo_cells > MAX_SHELLS)
	{
		other.ammo_cells = MAX_SHELLS;
	}
};

float(float w) RankForWeapon = 
{
	if (w == GUN_ANTISHAMBLER)
	{
		return 1;
	}
	if (w == GUN_LIGHTNING)
	{
		return FL_SWIM;
	}
	if (w == GUN_PLASMAGUN)
	{
		return MOVETYPE_WALK;
	}
	if (w == GUN_ROCKET_LAUNCHER)
	{
		return MOVETYPE_STEP;
	}
	if (w == GUN_SUPER_NAILGUN)
	{
		return MOVETYPE_FLY;
	}
	if (w == GUN_GRENADE_LAUNCHER)
	{
		return MOVETYPE_TOSS;
	}
	if (w == GUN_SUPER_SHOTGUN)
	{
		return MOVETYPE_PUSH;
	}
	if (w == GUN_NAILGUN)
	{
		return FL_CLIENT;
	}
	if (w == GUN_CHAINSAW)
	{
		return MOVETYPE_FLYMISSILE;
	}
	return MOVETYPE_BOUNCE;
};

void(float old, float new) Deathmatch_Weapon = 
{
	local float or;
	local float nr;
	or = RankForWeapon(self.guninuse);
	nr = RankForWeapon(new);
	if (nr < or)
	{
		self.guninuse = new;
	}
};

void() weapon_touch = 
{
	local float hadammo;
	local float best;
	local float new;
	local float old;
	local entity stemp;
	local float leave;
	if (!(other.flags & FL_CLIENT))
	{
		return;
	}
	if (deathmatch == FL_SWIM || coop)
	{
		leave = 1;
	}
	else
	{
		leave = 0;
	}
	if (self.classname == "weapon_nailgun")
	{
		if (leave && (other.gunitems & GUN_NAILGUN))
		{
			return;
		}
		hadammo = other.ammo_nails;
		new = GUN_NAILGUN;
		other.ammo_nails = other.ammo_nails + SVC_INTERMISSION;
	}
	else
	{
		if (self.classname == "weapon_supernailgun")
		{
			if (leave && (other.gunitems & GUN_SUPER_NAILGUN))
			{
				return;
			}
			hadammo = other.ammo_rockets;
			new = GUN_SUPER_NAILGUN;
			other.ammo_nails = other.ammo_nails + SVC_INTERMISSION;
		}
		else
		{
			if (self.classname == "weapon_supershotgun")
			{
				if (leave && (other.gunitems & GUN_SUPER_SHOTGUN))
				{
					return;
				}
				hadammo = other.ammo_rockets;
				new = GUN_SUPER_SHOTGUN;
				other.ammo_shells = other.ammo_shells + MOVETYPE_FLY;
			}
			else
			{
				if (self.classname == "weapon_rocketlauncher")
				{
					if (leave && (other.gunitems & GUN_ROCKET_LAUNCHER))
					{
						return;
					}
					hadammo = other.ammo_rockets;
					new = GUN_ROCKET_LAUNCHER;
					other.ammo_rockets = other.ammo_rockets + MOVETYPE_FLY;
				}
				else
				{
					if (self.classname == "weapon_grenadelauncher")
					{
						if (leave && (other.gunitems & GUN_GRENADE_LAUNCHER))
						{
							return;
						}
						hadammo = other.ammo_rockets;
						new = GUN_GRENADE_LAUNCHER;
						other.ammo_rockets = other.ammo_rockets + MOVETYPE_FLY;
					}
					else
					{
						if (self.classname == "weapon_lightning")
						{
							if (leave && (other.gunitems & GUN_LIGHTNING))
							{
								return;
							}
							hadammo = other.ammo_rockets;
							new = GUN_LIGHTNING;
							other.ammo_cells = other.ammo_cells + 15;
						}
						else
						{
							if (self.classname == "weapon_plasmagun")
							{
								if (leave && (other.gunitems & GUN_PLASMAGUN))
								{
									return;
								}
								hadammo = other.ammo_rockets;
								new = GUN_PLASMAGUN;
								other.ammo_cells = other.ammo_cells + 15;
							}
							else
							{
								if (self.classname == "weapon_antishambler")
								{
									if (leave && (other.gunitems & GUN_ANTISHAMBLER))
									{
										return;
									}
									hadammo = other.ammo_rockets;
									new = GUN_ANTISHAMBLER;
									other.ammo_cells = other.ammo_cells + 15;
								}
								else
								{
									if (self.classname == "weapon_chainsaw")
									{
										if (leave && (other.gunitems & GUN_CHAINSAW))
										{
											return;
										}
										new = GUN_CHAINSAW;
										parm12 = 1;
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
	sound(other, CHAN_ITEM, "weapons/pkup.wav", 1, ATTN_NORM);
	stuffcmd(other, "bf\n");
	bound_other_ammo();
	old = other.weapon;
	other.gunitems = other.gunitems | new;
	stemp = self;
	self = other;
	UpdateItems();
	Deathmatch_Weapon(old, new);
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
		self.nextthink = time + SVC_INTERMISSION;
	}
	self.think = SUB_regen;
	activator = other;
	SUB_UseTargets();
	if (!deathmatch)
	{
		remove(self);
	}
};

void() weapon_supershotgun = 
{
	if (self.spawnflags & 1)
	{
		weapon_antishambler();
	}
	else
	{
		if (self.spawnflags & FL_SWIM)
		{
			weapon_plasmagun();
		}
		else
		{
			precache_model("progs/v_dshot.mdl");
			precache_model("progs/g_dshot.mdl");
			setmodel(self, "progs/g_dshot.mdl");
			self.weapon = IT_SUPER_SHOTGUN;
			self.netname = "Riot Controller";
			self.touch = weapon_touch;
			setsize(self, '-16 -16 0', '16 16 56');
			StartItem();
		}
	}
};

void() weapon_nailgun = 
{
	if (self.spawnflags & 1)
	{
		weapon_antishambler();
	}
	else
	{
		if (self.spawnflags & FL_SWIM)
		{
			weapon_plasmagun();
		}
		else
		{
			precache_model("progs/g_nail.mdl");
			setmodel(self, "progs/g_nail.mdl");
			self.weapon = IT_NAILGUN;
			self.netname = "nailgun";
			self.touch = weapon_touch;
			setsize(self, '-16 -16 0', '16 16 56');
			StartItem();
		}
	}
};

void() weapon_supernailgun = 
{
	if (self.spawnflags & 1)
	{
		weapon_antishambler();
	}
	else
	{
		if (self.spawnflags & FL_SWIM)
		{
			weapon_plasmagun();
		}
		else
		{
			precache_model("progs/g_nail2.mdl");
			setmodel(self, "progs/g_nail2.mdl");
			self.weapon = IT_SUPER_NAILGUN;
			self.netname = "Super Nailgun";
			self.touch = weapon_touch;
			setsize(self, '-16 -16 0', '16 16 56');
			StartItem();
		}
	}
};

void() weapon_grenadelauncher = 
{
	if (self.spawnflags & 1)
	{
		weapon_antishambler();
	}
	else
	{
		if (self.spawnflags & FL_SWIM)
		{
			weapon_plasmagun();
		}
		else
		{
			precache_model("progs/g_rock.mdl");
			setmodel(self, "progs/g_rock.mdl");
			self.weapon = IT_GRENADE_LAUNCHER;
			self.netname = "Grenade Launcher";
			self.touch = weapon_touch;
			setsize(self, '-16 -16 0', '16 16 56');
			StartItem();
		}
	}
};

void() weapon_rocketlauncher = 
{
	if (self.spawnflags & 1)
	{
		weapon_antishambler();
	}
	else
	{
		if (self.spawnflags & FL_SWIM)
		{
			weapon_plasmagun();
		}
		else
		{
			precache_model("progs/g_rock2.mdl");
			setmodel(self, "progs/g_rock2.mdl");
			self.weapon = IT_ROCKET_LAUNCHER;
			self.netname = "Rocket Launcher";
			self.touch = weapon_touch;
			setsize(self, '-16 -16 0', '16 16 56');
			StartItem();
		}
	}
};

void() weapon_lightning = 
{
	if (self.spawnflags & 1)
	{
		weapon_antishambler();
	}
	else
	{
		if (self.spawnflags & FL_SWIM)
		{
			weapon_plasmagun();
		}
		else
		{
			precache_model("progs/g_light.mdl");
			setmodel(self, "progs/g_light.mdl");
			self.weapon = IT_LIGHTNING;
			self.netname = "Thunderbolt";
			self.touch = weapon_touch;
			setsize(self, '-16 -16 0', '16 16 56');
			StartItem();
		}
	}
};

void() weapon_chainsaw = 
{
	precache_model("progs/g_saw.mdl");
	setmodel(self, "progs/g_saw.mdl");
	self.weapon = IT_CHAINSAW;
	self.classname = "weapon_chainsaw";
	self.netname = "Chainsaw";
	self.touch = weapon_touch;
	setsize(self, '-16 -16 0', '16 16 56');
	StartItem();
	dprint("ERROR: change to item_sigil with no spawnflags\n");
};

void() ammo_touch = 
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
	if (self.weapon == 1)
	{
		if (other.ammo_shells >= MAX_SHELLS)
		{
			return;
		}
		other.ammo_shells = other.ammo_shells + self.aflag;
	}
	if (self.weapon == FL_SWIM)
	{
		if (other.ammo_nails >= MAX_NAILS)
		{
			return;
		}
		other.ammo_nails = other.ammo_nails + self.aflag;
	}
	if (self.weapon == MOVETYPE_WALK)
	{
		if (other.ammo_rockets >= MAX_SHELLS)
		{
			return;
		}
		other.ammo_rockets = other.ammo_rockets + self.aflag;
	}
	if (self.weapon == MOVETYPE_STEP)
	{
		if (other.ammo_cells >= MAX_SHELLS)
		{
			return;
		}
		other.ammo_cells = other.ammo_cells + self.aflag;
	}
	bound_other_ammo();
	sprint(other, "You got the ");
	sprint(other, self.netname);
	sprint(other, "\n");
	sound(other, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);
	stuffcmd(other, "bf\n");
	stemp = self;
	self = other;
	W_SetCurrentAmmo();
	self = stemp;
	self.model = string_null;
	self.solid = SOLID_NOT;
	if (deathmatch == 1)
	{
		self.nextthink = time + SVC_INTERMISSION;
	}
	self.think = SUB_regen;
	activator = other;
	SUB_UseTargets();
	if (!deathmatch)
	{
		remove(self);
	}
};

void() item_shells = 
{
	if (self.spawnflags & FL_SWIM)
	{
		item_cells();
	}
	else
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
		setsize(self, VEC_ORIGIN, '32 32 56');
		StartItem();
	}
};

void() item_spikes = 
{
	if (self.spawnflags & FL_SWIM)
	{
		item_cells();
	}
	else
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
		self.weapon = FL_SWIM;
		self.netname = "nails";
		setsize(self, VEC_ORIGIN, '32 32 56');
		StartItem();
	}
};

void() item_rockets = 
{
	if (self.spawnflags & FL_SWIM)
	{
		item_cells();
	}
	else
	{
		self.touch = ammo_touch;
		if (self.spawnflags & WEAPON_BIG2)
		{
			precache_model("maps/b_rock1.bsp");
			setmodel(self, "maps/b_rock1.bsp");
			self.aflag = MOVETYPE_BOUNCE;
		}
		else
		{
			precache_model("maps/b_rock0.bsp");
			setmodel(self, "maps/b_rock0.bsp");
			self.aflag = MOVETYPE_FLY;
		}
		self.weapon = MOVETYPE_WALK;
		self.netname = "rockets";
		setsize(self, VEC_ORIGIN, '32 32 56');
		StartItem();
	}
};

void() item_cells = 
{
	self.touch = ammo_touch;
	if (self.spawnflags & WEAPON_BIG2)
	{
		precache_model("maps/b_batt1.bsp");
		setmodel(self, "maps/b_batt1.bsp");
		self.aflag = STAT_TOTALMONSTERS;
	}
	else
	{
		precache_model("maps/b_batt0.bsp");
		setmodel(self, "maps/b_batt0.bsp");
		self.aflag = MOVETYPE_TOSS;
	}
	self.weapon = MOVETYPE_STEP;
	self.netname = "cells";
	self.classname = "item_cells";
	setsize(self, VEC_ORIGIN, '32 32 56');
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
		self.weapon = FL_SWIM;
		self.netname = "spikes";
	}
	if (self.spawnflags & WEAPON_ROCKET)
	{
		if (self.spawnflags & WEAPON_BIG)
		{
			precache_model("maps/b_rock1.bsp");
			setmodel(self, "maps/b_rock1.bsp");
			self.aflag = MOVETYPE_BOUNCE;
		}
		else
		{
			precache_model("maps/b_rock0.bsp");
			setmodel(self, "maps/b_rock0.bsp");
			self.aflag = MOVETYPE_FLY;
		}
		self.weapon = MOVETYPE_WALK;
		self.netname = "rockets";
	}
	setsize(self, VEC_ORIGIN, '32 32 56');
	StartItem();
};

void() key_touch = 
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
	if (other.items & self.items)
	{
		return;
	}
	sprint(other, "You got the ");
	sprint(other, self.netname);
	sprint(other, "\n");
	sound(other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
	stuffcmd(other, "bf\n");
	other.items = other.items | self.items;
	if (!coop)
	{
		self.solid = SOLID_NOT;
		self.model = string_null;
	}
	activator = other;
	SUB_UseTargets();
	remove(self);
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
	if (world.worldtype == FL_SWIM)
	{
		precache_sound2("misc/basekey.wav");
		self.noise = "misc/basekey.wav";
	}
};

void() item_key1 = 
{
	if (!(world.worldtype))
	{
		world.worldtype = 0;
	}
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
			if (world.worldtype == FL_SWIM)
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
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	StartItem();
};

void() item_key2 = 
{
	if (!(world.worldtype))
	{
		world.worldtype = 0;
	}
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
	if (world.worldtype == FL_SWIM)
	{
		precache_model2("progs/b_g_key.mdl");
		setmodel(self, "progs/b_g_key.mdl");
		self.netname = "gold keycard";
	}
	key_setsounds();
	self.touch = key_touch;
	self.items = IT_KEY2;
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	StartItem();
};

void() sigil_touch = 
{
	local entity stemp;
	local entity d;
	local float best;
	if (other.classname != "player" && other.classname != "actor")
	{
		return;
	}
	if (other.health <= 0)
	{
		return;
	}
	if (other.classname == "player")
	{
		centerprint(other, "You got the rune!");
		sound(other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
		stuffcmd(other, "bf\n");
	}
	if (other.classname == "actor")
	{
		d = other.owner;
		sound(d, CHAN_ITEM, self.noise, 1, ATTN_NORM);
	}
	self.solid = SOLID_NOT;
	self.model = string_null;
	serverflags = serverflags | (self.spawnflags & 15);
	self.classname = string_null;
	if (other.classname == "player")
	{
		activator = other;
	}
	else
	{
		activator = other.owner;
	}
	SUB_UseTargets();
	remove(self);
};

void() item_sigil = 
{
	if (!(self.spawnflags))
	{
		weapon_chainsaw();
	}
	else
	{
		precache_sound("misc/runekey.wav");
		self.noise = "misc/runekey.wav";
		if (self.spawnflags & 1)
		{
			precache_model("progs/end1.mdl");
			setmodel(self, "progs/end1.mdl");
		}
		if (self.spawnflags & FL_SWIM)
		{
			precache_model2("progs/end2.mdl");
			setmodel(self, "progs/end2.mdl");
		}
		if (self.spawnflags & MOVETYPE_STEP)
		{
			precache_model2("progs/end3.mdl");
			setmodel(self, "progs/end3.mdl");
		}
		if (self.spawnflags & FL_CLIENT)
		{
			precache_model2("progs/end4.mdl");
			setmodel(self, "progs/end4.mdl");
		}
		self.touch = sigil_touch;
		setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
		StartItem();
	}
};

void() powerup_touch = 
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
	sprint(other, "You got the ");
	sprint(other, self.netname);
	sprint(other, "\n");
	if (deathmatch)
	{
		self.mdl = self.model;
		if (self.classname == "item_artifact_invulnerability" || self.classname == "item_artifact_invisibility")
		{
			self.nextthink = time + 60 * MOVETYPE_FLY;
		}
		else
		{
			self.nextthink = time + 60;
		}
		self.think = SUB_regen;
	}
	sound(other, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	stuffcmd(other, "bf\n");
	self.solid = SOLID_NOT;
	other.items = other.items | self.items;
	self.model = string_null;
	if (self.classname == "item_artifact_envirosuit")
	{
		other.rad_time = 1;
		other.radsuit_finished = time + SVC_INTERMISSION;
	}
	if (self.classname == "item_artifact_invulnerability")
	{
		other.invincible_time = 1;
		other.invincible_finished = time + SVC_INTERMISSION;
	}
	if (self.classname == "item_artifact_invisibility")
	{
		other.invisible_time = 1;
		other.invisible_finished = time + SVC_INTERMISSION;
	}
	if (self.classname == "item_artifact_super_damage")
	{
		other.super_time = 1;
		other.super_damage_finished = time + SVC_INTERMISSION;
	}
	activator = other;
	SUB_UseTargets();
	if (!deathmatch)
	{
		remove(self);
	}
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
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
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
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
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
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
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
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	StartItem();
};

void() BackpackTouch = 
{
	local string s;
	local float best;
	local float old;
	local float new;
	local entity stemp;
	local float acount;
	local float or;
	local float nr;
	if (other.classname != "player")
	{
		return;
	}
	if (other.health <= 0)
	{
		return;
	}
	acount = 0;
	sprint(other, "You get ");
	if (self.gunitems)
	{
		if ((other.gunitems & self.gunitems) == 0)
		{
			acount = 1;
			sprint(other, "the ");
			sprint(other, self.netname);
		}
	}
	other.ammo_shells = other.ammo_shells + self.ammo_shells;
	other.ammo_nails = other.ammo_nails + self.ammo_nails;
	other.ammo_rockets = other.ammo_rockets + self.ammo_rockets;
	other.ammo_cells = other.ammo_cells + self.ammo_cells;
	new = self.gunitems;
	if (!new)
	{
		new = other.guninuse;
	}
	old = other.guninuse;
	other.gunitems = other.gunitems | new;
	stemp = self;
	self = other;
	UpdateItems();
	self = stemp;
	bound_other_ammo();
	if (self.ammo_shells)
	{
		if (acount)
		{
			sprint(other, ", ");
		}
		acount = 1;
		s = ftos(self.ammo_shells);
		sprint(other, s);
		sprint(other, " shells");
	}
	if (self.ammo_nails)
	{
		if (acount)
		{
			sprint(other, ", ");
		}
		acount = 1;
		s = ftos(self.ammo_nails);
		sprint(other, s);
		sprint(other, " nails");
	}
	if (self.ammo_rockets)
	{
		if (acount)
		{
			sprint(other, ", ");
		}
		acount = 1;
		s = ftos(self.ammo_rockets);
		sprint(other, s);
		sprint(other, " rockets");
	}
	if (self.ammo_cells)
	{
		if (acount)
		{
			sprint(other, ", ");
		}
		acount = 1;
		s = ftos(self.ammo_cells);
		sprint(other, s);
		sprint(other, " cells");
	}
	sprint(other, "\n");
	sound(other, CHAN_ITEM, "weapons/lock4.wav", 1, ATTN_NORM);
	stuffcmd(other, "bf\n");
	remove(self);
	self = other;
	if (!deathmatch && self.guninuse == GUN_CHAINSAW)
	{
		return;
	}
	Deathmatch_Weapon(old, new);
	W_SetCurrentAmmo();
};

void() DropBackpack = 
{
	local entity item;
	if (!(self.ammo_shells + self.ammo_nails + self.ammo_rockets + self.ammo_cells))
	{
		return;
	}
	item = spawn();
	item.origin = self.origin - '0 0 24';
	item.gunitems = self.guninuse;
	if (item.gunitems == IT_AXE)
	{
		item.netname = "Axe";
	}
	else
	{
		if (item.gunitems == GUN_SHOTGUN)
		{
			item.netname = "Shotgun";
		}
		else
		{
			if (item.gunitems == GUN_SUPER_SHOTGUN)
			{
				item.netname = "Double-barrelled Shotgun";
			}
			else
			{
				if (item.gunitems == GUN_NAILGUN)
				{
					item.netname = "Nailgun";
				}
				else
				{
					if (item.gunitems == GUN_SUPER_NAILGUN)
					{
						item.netname = "Super Nailgun";
					}
					else
					{
						if (item.gunitems == GUN_GRENADE_LAUNCHER)
						{
							item.netname = "Grenade Launcher";
						}
						else
						{
							if (item.gunitems == GUN_ROCKET_LAUNCHER)
							{
								item.netname = "Rocket Launcher";
							}
							else
							{
								if (item.gunitems == GUN_LIGHTNING)
								{
									item.netname = "Thunderbolt";
								}
								else
								{
									if (item.gunitems == GUN_PLASMAGUN)
									{
										item.netname = "Plasma Gun";
									}
									else
									{
										if (item.gunitems == GUN_ANTISHAMBLER)
										{
											item.netname = "Anti-Matter Cannon";
										}
										else
										{
											if (item.gunitems == GUN_CHAINSAW)
											{
												item.netname = "Chainsaw";
											}
											else
											{
												item.netname = "";
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
	item.ammo_shells = self.ammo_shells;
	item.ammo_nails = self.ammo_nails;
	item.ammo_rockets = self.ammo_rockets;
	item.ammo_cells = self.ammo_cells;
	item.velocity_z = 300;
	item.velocity_x = -100 + random() * MAX_NAILS;
	item.velocity_y = -100 + random() * MAX_NAILS;
	item.flags = FL_ITEM;
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_TOSS;
	setmodel(item, "progs/backpack.mdl");
	setsize(item, '-16 -16 0', '16 16 56');
	item.touch = BackpackTouch;
	item.nextthink = time + 120;
	item.think = SUB_Remove;
};

