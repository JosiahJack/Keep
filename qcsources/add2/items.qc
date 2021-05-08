void() SUB_regen = 
{
	self.model = self.mdl;
	self.solid = SOLID_TRIGGER;
	sound(self, CHAN_VOICE, "items/itembk2.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
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
	self.origin_z = self.origin_z + TE_LIGHTNING2;
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
	if (e.health <= MSG_BROADCAST)
	{
		return MSG_BROADCAST;
	}
	if (!ignore && e.health >= other.max_health)
	{
		return MSG_BROADCAST;
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
	return SPAWNFLAG_SUPERSPIKE;
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
		self.healamount = CTF_CAPTURE_BONUS;
		self.healtype = MSG_BROADCAST;
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
			self.healtype = SPAWNFLAG_LASER;
		}
		else
		{
			precache_model("maps/b_bh25.bsp");
			precache_sound("items/health1.wav");
			setmodel(self, "maps/b_bh25.bsp");
			self.noise = "items/health1.wav";
			self.healamount = 25;
			self.healtype = SPAWNFLAG_SUPERSPIKE;
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
	if (self.healtype == SPAWNFLAG_LASER)
	{
		if (other.health >= 250)
		{
			return;
		}
		if (!T_Heal(other, self.healamount, SPAWNFLAG_SUPERSPIKE))
		{
			return;
		}
	}
	else
	{
		if (!T_Heal(other, self.healamount, MSG_BROADCAST))
		{
			return;
		}
	}
	sprint(other, "You receive ");
	s = ftos(self.healamount);
	sprint(other, s);
	sprint(other, " health\n");
	sound(other, CHAN_ITEM, self.noise, SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	stuffcmd(other, "bf\n");
	self.model = string_null;
	self.solid = SOLID_NOT;
	if (self.healtype == SPAWNFLAG_LASER)
	{
		self.nextthink = time + AS_DODGING;
		self.think = item_megahealth_rot;
		self.owner = other;
	}
	else
	{
		if (deathmatch != SPAWNFLAG_LASER)
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
	if (other.health > other.max_health)
	{
		other.health = other.health - SPAWNFLAG_SUPERSPIKE;
		self.nextthink = time + SPAWNFLAG_SUPERSPIKE;
		return;
	}
	if (deathmatch == SPAWNFLAG_SUPERSPIKE)
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
	if (other.health <= MSG_BROADCAST)
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
		value = 100;
		bit = IT_ARMOR1;
	}
	if (self.classname == "item_armor2")
	{
		type = 0.6;
		value = MIN_CHARMER_DISTANCE;
		bit = IT_ARMOR2;
	}
	if (self.classname == "item_armorInv")
	{
		type = 0.8;
		value = MAX_CHARMER_DISTANCE;
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
	if (deathmatch == SPAWNFLAG_SUPERSPIKE)
	{
		self.nextthink = time + 20;
	}
	self.think = SUB_regen;
	sprint(other, "You got armor\n");
	sound(other, CHAN_ITEM, "items/armor1.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	stuffcmd(other, "bf\n");
	activator = other;
	SUB_UseTargets();
};

void() item_armor1 = 
{
	self.touch = armor_touch;
	precache_model("progs/armor.mdl");
	setmodel(self, "progs/armor.mdl");
	self.skin = MSG_BROADCAST;
	setsize(self, '-16 -16 0', '16 16 56');
	StartItem();
};

void() item_armor2 = 
{
	self.touch = armor_touch;
	precache_model("progs/armor.mdl");
	setmodel(self, "progs/armor.mdl");
	self.skin = SPAWNFLAG_SUPERSPIKE;
	setsize(self, '-16 -16 0', '16 16 56');
	StartItem();
};

void() item_armorInv = 
{
	self.touch = armor_touch;
	precache_model("progs/armor.mdl");
	setmodel(self, "progs/armor.mdl");
	self.skin = SPAWNFLAG_LASER;
	setsize(self, '-16 -16 0', '16 16 56');
	StartItem();
};

void() bound_other_ammo = 
{
	if (other.ammo_shells > 100)
	{
		other.ammo_shells = 100;
	}
	if (other.ammo_nails > MAX_CHARMER_DISTANCE)
	{
		other.ammo_nails = MAX_CHARMER_DISTANCE;
	}
	if (other.ammo_rockets > 100)
	{
		other.ammo_rockets = 100;
	}
	if (other.ammo_cells > 100)
	{
		other.ammo_cells = 100;
	}
};

float(float w) RankForWeapon = 
{
	if (w == IT_LIGHTNING)
	{
		return SPAWNFLAG_SUPERSPIKE;
	}
	if (w == IT_ROCKET_LAUNCHER)
	{
		return SPAWNFLAG_LASER;
	}
	if (w == IT_LASER_CANNON)
	{
		return SVC_UPDATESTAT;
	}
	if (w == IT_SUPER_NAILGUN)
	{
		return SPAWNFLAG_LAVABALL;
	}
	if (w == IT_PROXIMITY_GUN)
	{
		return AS_DODGING;
	}
	if (w == IT_GRENADE_LAUNCHER)
	{
		return TE_LIGHTNING2;
	}
	if (w == IT_SUPER_SHOTGUN)
	{
		return TE_WIZSPIKE;
	}
	if (w == IT_NAILGUN)
	{
		return SPAWNFLAG_ROCKET;
	}
	if (w == IT_MJOLNIR)
	{
		return TE_LIGHTNING3;
	}
	return MIN_ANGLE_DELTA;
};

void(float old, float new) Deathmatch_Weapon = 
{
	local float or;
	local float nr;
	or = RankForWeapon(self.weapon);
	nr = RankForWeapon(new);
	if (nr < or)
	{
		self.weapon = new;
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
	stemp = self;
	self = other;
	best = W_BestWeapon();
	self = stemp;
	if (deathmatch == SPAWNFLAG_LASER || coop)
	{
		leave = SPAWNFLAG_SUPERSPIKE;
	}
	else
	{
		leave = MSG_BROADCAST;
	}
	if (self.classname == "weapon_nailgun")
	{
		if (leave && (other.items & IT_NAILGUN))
		{
			return;
		}
		hadammo = other.ammo_nails;
		new = IT_NAILGUN;
		other.ammo_nails = other.ammo_nails + SVC_INTERMISSION;
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
			other.ammo_nails = other.ammo_nails + SVC_INTERMISSION;
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
				other.ammo_shells = other.ammo_shells + AS_DODGING;
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
					other.ammo_rockets = other.ammo_rockets + AS_DODGING;
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
						other.ammo_rockets = other.ammo_rockets + AS_DODGING;
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
							other.ammo_cells = other.ammo_cells + CTF_CAPTURE_BONUS;
						}
						else
						{
							if (self.classname == "weapon_laser_gun")
							{
								if (leave && (other.items & IT_LASER_CANNON))
								{
									return;
								}
								hadammo = other.ammo_rockets;
								new = IT_LASER_CANNON;
								other.ammo_cells = other.ammo_cells + SVC_INTERMISSION;
							}
							else
							{
								if (self.classname == "weapon_mjolnir")
								{
									if (leave && (other.items & IT_MJOLNIR))
									{
										return;
									}
									hadammo = other.ammo_rockets;
									new = IT_MJOLNIR;
									other.ammo_cells = other.ammo_cells + SVC_INTERMISSION;
								}
								else
								{
									if (self.classname == "weapon_proximity_gun")
									{
										if (leave && (other.items & IT_PROXIMITY_GUN))
										{
											return;
										}
										hadammo = other.ammo_rockets;
										new = IT_PROXIMITY_GUN;
										other.ammo_rockets = other.ammo_rockets + TE_LIGHTNING2;
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
	sound(other, CHAN_ITEM, "weapons/pkup.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	stuffcmd(other, "bf\n");
	bound_other_ammo();
	old = other.items;
	other.items = other.items | new;
	stemp = self;
	self = other;
	if (!deathmatch)
	{
		self.weapon = new;
	}
	else
	{
		Deathmatch_Weapon(old, new);
	}
	W_SetCurrentAmmo();
	self = stemp;
	if (leave)
	{
		return;
	}
	self.model = string_null;
	self.solid = SOLID_NOT;
	if (deathmatch == SPAWNFLAG_SUPERSPIKE)
	{
		self.nextthink = time + SVC_INTERMISSION;
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
	self.weapon = SVC_UPDATESTAT;
	self.netname = "Grenade Launcher";
	self.touch = weapon_touch;
	setsize(self, '-16 -16 0', '16 16 56');
	StartItem();
};

void() weapon_rocketlauncher = 
{
	precache_model("progs/g_rock2.mdl");
	setmodel(self, "progs/g_rock2.mdl");
	self.weapon = SVC_UPDATESTAT;
	self.netname = "Rocket Launcher";
	self.touch = weapon_touch;
	setsize(self, '-16 -16 0', '16 16 56');
	StartItem();
};

void() weapon_lightning = 
{
	precache_model("progs/g_light.mdl");
	setmodel(self, "progs/g_light.mdl");
	self.weapon = SVC_UPDATESTAT;
	self.netname = "Thunderbolt";
	self.touch = weapon_touch;
	setsize(self, '-16 -16 0', '16 16 56');
	StartItem();
};

void() ammo_touch = 
{
	local entity stemp;
	local float best;
	if (other.classname != "player")
	{
		return;
	}
	if (other.health <= MSG_BROADCAST)
	{
		return;
	}
	stemp = self;
	self = other;
	best = W_BestWeapon();
	self = stemp;
	if (self.weapon == SPAWNFLAG_SUPERSPIKE)
	{
		if (other.ammo_shells >= 100)
		{
			return;
		}
		other.ammo_shells = other.ammo_shells + self.aflag;
	}
	if (self.weapon == SPAWNFLAG_LASER)
	{
		if (other.ammo_nails >= MAX_CHARMER_DISTANCE)
		{
			return;
		}
		other.ammo_nails = other.ammo_nails + self.aflag;
	}
	if (self.weapon == SVC_UPDATESTAT)
	{
		if (other.ammo_rockets >= 100)
		{
			return;
		}
		other.ammo_rockets = other.ammo_rockets + self.aflag;
	}
	if (self.weapon == SPAWNFLAG_LAVABALL)
	{
		if (other.ammo_cells >= 100)
		{
			return;
		}
		other.ammo_cells = other.ammo_cells + self.aflag;
	}
	bound_other_ammo();
	sprint(other, "You got the ");
	sprint(other, self.netname);
	sprint(other, "\n");
	sound(other, CHAN_ITEM, "weapons/lock4.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
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
	if (deathmatch == SPAWNFLAG_SUPERSPIKE)
	{
		self.nextthink = time + SVC_INTERMISSION;
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
	self.weapon = SPAWNFLAG_SUPERSPIKE;
	self.netname = "shells";
	setsize(self, VEC_ORIGIN, '32 32 56');
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
	self.weapon = SPAWNFLAG_LASER;
	self.netname = "nails";
	setsize(self, VEC_ORIGIN, '32 32 56');
	StartItem();
};

void() item_rockets = 
{
	self.touch = ammo_touch;
	if (self.spawnflags & WEAPON_BIG2)
	{
		precache_model("maps/b_rock1.bsp");
		setmodel(self, "maps/b_rock1.bsp");
		self.aflag = MIN_ANGLE_DELTA;
	}
	else
	{
		precache_model("maps/b_rock0.bsp");
		setmodel(self, "maps/b_rock0.bsp");
		self.aflag = AS_DODGING;
	}
	self.weapon = SVC_UPDATESTAT;
	self.netname = "rockets";
	setsize(self, VEC_ORIGIN, '32 32 56');
	StartItem();
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
		self.aflag = TE_LIGHTNING2;
	}
	self.weapon = SPAWNFLAG_LAVABALL;
	self.netname = "cells";
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
		self.weapon = SPAWNFLAG_SUPERSPIKE;
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
		self.weapon = SPAWNFLAG_LASER;
		self.netname = "spikes";
	}
	if (self.spawnflags & WEAPON_ROCKET)
	{
		if (self.spawnflags & WEAPON_BIG)
		{
			precache_model("maps/b_rock1.bsp");
			setmodel(self, "maps/b_rock1.bsp");
			self.aflag = MIN_ANGLE_DELTA;
		}
		else
		{
			precache_model("maps/b_rock0.bsp");
			setmodel(self, "maps/b_rock0.bsp");
			self.aflag = AS_DODGING;
		}
		self.weapon = SVC_UPDATESTAT;
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
	if (other.health <= MSG_BROADCAST)
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
	sound(other, CHAN_ITEM, self.noise, SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
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
	if (world.worldtype == MSG_BROADCAST)
	{
		precache_sound("misc/medkey.wav");
		self.noise = "misc/medkey.wav";
	}
	if (world.worldtype == SPAWNFLAG_SUPERSPIKE)
	{
		precache_sound("misc/runekey.wav");
		self.noise = "misc/runekey.wav";
	}
	if (world.worldtype == SPAWNFLAG_LASER)
	{
		precache_sound2("misc/basekey.wav");
		self.noise = "misc/basekey.wav";
	}
};

void() item_key1 = 
{
	if (world.worldtype == MSG_BROADCAST)
	{
		precache_model("progs/w_s_key.mdl");
		setmodel(self, "progs/w_s_key.mdl");
		self.netname = "silver key";
	}
	else
	{
		if (world.worldtype == SPAWNFLAG_SUPERSPIKE)
		{
			precache_model("progs/m_s_key.mdl");
			setmodel(self, "progs/m_s_key.mdl");
			self.netname = "silver runekey";
		}
		else
		{
			if (world.worldtype == SPAWNFLAG_LASER)
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
	if (world.worldtype == MSG_BROADCAST)
	{
		precache_model("progs/w_g_key.mdl");
		setmodel(self, "progs/w_g_key.mdl");
		self.netname = "gold key";
	}
	if (world.worldtype == SPAWNFLAG_SUPERSPIKE)
	{
		precache_model("progs/m_g_key.mdl");
		setmodel(self, "progs/m_g_key.mdl");
		self.netname = "gold runekey";
	}
	if (world.worldtype == SPAWNFLAG_LASER)
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
	local float best;
	if (other.classname != "player")
	{
		return;
	}
	if (other.health <= MSG_BROADCAST)
	{
		return;
	}
	centerprint(other, "You got the rune!");
	sound(other, CHAN_ITEM, self.noise, SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	stuffcmd(other, "bf\n");
	self.solid = SOLID_NOT;
	self.model = string_null;
	serverflags = serverflags | (self.spawnflags & CTF_CAPTURE_BONUS);
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
	if (self.spawnflags & SPAWNFLAG_SUPERSPIKE)
	{
		precache_model("progs/end1.mdl");
		setmodel(self, "progs/end1.mdl");
	}
	if (self.spawnflags & SPAWNFLAG_LASER)
	{
		precache_model2("progs/end2.mdl");
		setmodel(self, "progs/end2.mdl");
	}
	if (self.spawnflags & SPAWNFLAG_LAVABALL)
	{
		precache_model2("progs/end3.mdl");
		setmodel(self, "progs/end3.mdl");
	}
	if (self.spawnflags & SPAWNFLAG_ROCKET)
	{
		precache_model2("progs/end4.mdl");
		setmodel(self, "progs/end4.mdl");
	}
	self.touch = sigil_touch;
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	StartItem();
};

void() powerup_touch = 
{
	local entity stemp;
	local float best;
	if (other.classname != "player")
	{
		return;
	}
	if (other.health <= MSG_BROADCAST)
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
			self.nextthink = time + 60 * AS_DODGING;
		}
		else
		{
			self.nextthink = time + 60;
		}
		self.think = SUB_regen;
	}
	sound(other, CHAN_VOICE, self.noise, SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	stuffcmd(other, "bf\n");
	self.solid = SOLID_NOT;
	other.items = other.items | self.items;
	self.model = string_null;
	if (self.classname == "item_artifact_envirosuit")
	{
		other.rad_time = SPAWNFLAG_SUPERSPIKE;
		other.radsuit_finished = time + SVC_INTERMISSION;
	}
	if (self.classname == "item_artifact_invulnerability")
	{
		other.invincible_time = SPAWNFLAG_SUPERSPIKE;
		other.invincible_finished = time + SVC_INTERMISSION;
	}
	if (self.classname == "item_artifact_invisibility")
	{
		other.invisible_time = SPAWNFLAG_SUPERSPIKE;
		other.invisible_finished = time + SVC_INTERMISSION;
	}
	if (self.classname == "item_artifact_super_damage")
	{
		other.super_time = SPAWNFLAG_SUPERSPIKE;
		other.super_damage_finished = time + SVC_INTERMISSION;
	}
	activator = other;
	SUB_UseTargets();
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
	if (other.classname != "player")
	{
		return;
	}
	if (other.health <= MSG_BROADCAST)
	{
		return;
	}
	acount = MSG_BROADCAST;
	sprint(other, "You get ");
	if (self.items)
	{
		if ((other.items & self.items) == MSG_BROADCAST)
		{
			acount = SPAWNFLAG_SUPERSPIKE;
			sprint(other, "the ");
			sprint(other, self.netname);
		}
	}
	stemp = self;
	self = other;
	best = W_BestWeapon();
	self = stemp;
	other.ammo_shells = other.ammo_shells + self.ammo_shells;
	other.ammo_nails = other.ammo_nails + self.ammo_nails;
	other.ammo_rockets = other.ammo_rockets + self.ammo_rockets;
	other.ammo_cells = other.ammo_cells + self.ammo_cells;
	new = self.items;
	if (!new)
	{
		new = other.weapon;
	}
	old = other.items;
	other.items = other.items | new;
	bound_other_ammo();
	if (self.ammo_shells)
	{
		if (acount)
		{
			sprint(other, ", ");
		}
		acount = SPAWNFLAG_SUPERSPIKE;
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
		acount = SPAWNFLAG_SUPERSPIKE;
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
		acount = SPAWNFLAG_SUPERSPIKE;
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
		acount = SPAWNFLAG_SUPERSPIKE;
		s = ftos(self.ammo_cells);
		sprint(other, s);
		sprint(other, " cells");
	}
	sprint(other, "\n");
	sound(other, CHAN_ITEM, "weapons/lock4.wav", SPAWNFLAG_SUPERSPIKE, ATTN_NORM);
	stuffcmd(other, "bf\n");
	remove(self);
	self = other;
	if (!deathmatch)
	{
		self.weapon = new;
	}
	else
	{
		Deathmatch_Weapon(old, new);
	}
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
	item.items = self.weapon;
	if (item.items == IT_AXE)
	{
		item.netname = "Axe";
	}
	else
	{
		if (item.items == IT_SHOTGUN)
		{
			item.netname = "Shotgun";
		}
		else
		{
			if (item.items == IT_SUPER_SHOTGUN)
			{
				item.netname = "Double-barrelled Shotgun";
			}
			else
			{
				if (item.items == IT_NAILGUN)
				{
					item.netname = "Nailgun";
				}
				else
				{
					if (item.items == IT_SUPER_NAILGUN)
					{
						item.netname = "Super Nailgun";
					}
					else
					{
						if (item.items == IT_GRENADE_LAUNCHER)
						{
							item.netname = "Grenade Launcher";
						}
						else
						{
							if (item.items == IT_ROCKET_LAUNCHER)
							{
								item.netname = "Rocket Launcher";
							}
							else
							{
								if (item.items == IT_LIGHTNING)
								{
									item.netname = "Thunderbolt";
								}
								else
								{
									if (item.items == IT_LASER_CANNON)
									{
										item.netname = "Laser Cannon";
									}
									else
									{
										if (item.items == IT_PROXIMITY_GUN)
										{
											item.netname = "Proximity Gun";
										}
										else
										{
											if (item.items == IT_MJOLNIR)
											{
												item.netname = "Mjolnir";
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
	item.velocity_x = -100 + random() * MAX_CHARMER_DISTANCE;
	item.velocity_y = -100 + random() * MAX_CHARMER_DISTANCE;
	item.flags = FL_ITEM;
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_TOSS;
	setmodel(item, "progs/backpack.mdl");
	setsize(item, '-16 -16 0', '16 16 56');
	item.touch = BackpackTouch;
	item.nextthink = time + TOOCLOSE_CHARMER_DISTANCE;
	item.think = SUB_Remove;
};

