void() SUB_regen = 
{
	self.model = self.mdl;
	self.solid = SOLID_TRIGGER;
	sound(self, CHAN_VOICE, "items/itembk2.wav", OPT_MOTD, ATTN_NORM);
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
		print_self("bonus item", "fell out of level");
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
	return OPT_MOTD;
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
			self.healtype = AS_SLIDING;
		}
		else
		{
			precache_model("maps/b_bh25.bsp");
			precache_sound("items/health1.wav");
			setmodel(self, "maps/b_bh25.bsp");
			self.noise = "items/health1.wav";
			self.healamount = 25;
			self.healtype = OPT_MOTD;
		}
	}
	setsize(self, VEC_ORIGIN, '32 32 56');
	StartItem();
};

void() health_touch = 
{
	local float amount;
	local string s;
	if (other.exptime != MSG_BROADCAST)
	{
		return;
	}
	if (other.classname != "player")
	{
		return;
	}
	if (self.healtype == AS_SLIDING)
	{
		if (other.health >= 250)
		{
			return;
		}
		if (!T_Heal(other, self.healamount, OPT_MOTD))
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
	sound(other, CHAN_ITEM, self.noise, OPT_MOTD, ATTN_NORM);
	stuffcmd(other, "bf\n");
	self.model = string_null;
	self.solid = SOLID_NOT;
	if (self.healtype == AS_SLIDING)
	{
		other.items = other.items | IT_SUPERHEALTH;
		self.nextthink = time + TE_LIGHTNING1;
		self.think = item_megahealth_rot;
		self.owner = other;
	}
	else
	{
		if (deathmatch != AS_SLIDING)
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
		other.health = other.health - OPT_MOTD;
		self.nextthink = time + OPT_MOTD;
		return;
	}
	other.items = other.items - (other.items & IT_SUPERHEALTH);
	if (deathmatch == OPT_MOTD)
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
	if (deathmatch == OPT_MOTD)
	{
		self.nextthink = time + 20;
	}
	self.think = SUB_regen;
	sprint(other, "You got armor\n");
	sound(other, CHAN_ITEM, "items/armor1.wav", OPT_MOTD, ATTN_NORM);
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
	self.skin = OPT_MOTD;
	setsize(self, '-16 -16 0', '16 16 56');
	StartItem();
};

void() item_armorInv = 
{
	self.touch = armor_touch;
	precache_model("progs/armor.mdl");
	setmodel(self, "progs/armor.mdl");
	self.skin = AS_SLIDING;
	setsize(self, '-16 -16 0', '16 16 56');
	StartItem();
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
	if (other.ammo_cells > 100)
	{
		other.ammo_cells = 100;
	}
};

float(float w) RankForWeapon = 
{
	if (w == IT_LIGHTNING)
	{
		return OPT_MOTD;
	}
	if (w == IT_ROCKET_LAUNCHER)
	{
		return AS_SLIDING;
	}
	if (w == IT_SUPER_NAILGUN)
	{
		return AS_MELEE;
	}
	if (w == IT_GRENADE_LAUNCHER)
	{
		return AS_MISSILE;
	}
	if (w == IT_SUPER_SHOTGUN)
	{
		return TE_LIGHTNING1;
	}
	if (w == IT_NAILGUN)
	{
		return TE_LIGHTNING2;
	}
	return TE_WIZSPIKE;
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
	local float new;
	local float old;
	local entity stemp;
	local float leave;
	if (other.health <= MSG_BROADCAST)
	{
		return;
	}
	if (!(other.flags & FL_CLIENT))
	{
		return;
	}
	if (deathmatch == AS_SLIDING || coop)
	{
		leave = OPT_MOTD;
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
				other.ammo_shells = other.ammo_shells + TE_LIGHTNING1;
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
					other.ammo_rockets = other.ammo_rockets + TE_LIGHTNING1;
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
						other.ammo_rockets = other.ammo_rockets + TE_LIGHTNING1;
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
							objerror("weapon_touch: unknown classname");
						}
					}
				}
			}
		}
	}
	sprint(other, "You got the ");
	sprint(other, self.netname);
	sprint(other, "\n");
	sound(other, CHAN_ITEM, "weapons/pkup.wav", OPT_MOTD, ATTN_NORM);
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
	if (self.weapon == new)
	{
		self.flags = self.flags - (self.flags & FL_IMPELWEAPON);
	}
	W_SetCurrentAmmo();
	self = stemp;
	if (leave)
	{
		if (self.state == MSG_BROADCAST)
		{
			activator = other;
			SUB_UseTargets();
			self.state = H_ROTTEN;
		}
		return;
	}
	self.model = string_null;
	self.solid = SOLID_NOT;
	if (deathmatch == OPT_MOTD)
	{
		self.nextthink = time + SVC_INTERMISSION;
	}
	self.think = SUB_regen;
	activator = other;
	SUB_UseTargets();
};

void() weapon_supershotgun = 
{
	if (world.model == "maps/aop2m3.bsp")
	{
		self.classname = "weapon_grenadelauncher";
		weapon_grenadelauncher();
		return;
	}
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
	self.weapon = AS_MELEE;
	self.netname = "Grenade Launcher";
	self.touch = weapon_touch;
	setsize(self, '-16 -16 0', '16 16 56');
	StartItem();
};

void() weapon_rocketlauncher = 
{
	precache_model("progs/g_rock2.mdl");
	setmodel(self, "progs/g_rock2.mdl");
	self.weapon = AS_MELEE;
	self.netname = "Rocket Launcher";
	self.touch = weapon_touch;
	setsize(self, '-16 -16 0', '16 16 56');
	StartItem();
};

void() weapon_lightning = 
{
	if (world.model == "maps/aop2m2.bsp")
	{
		self.classname = "weapon_rifle";
		weapon_rifle();
		return;
	}
	precache_model("progs/g_light.mdl");
	setmodel(self, "progs/g_light.mdl");
	self.weapon = AS_MELEE;
	self.netname = "Thunderbolt";
	self.touch = weapon_touch;
	setsize(self, '-16 -16 0', '16 16 56');
	StartItem();
};

void() impel_weapon_touch = 
{
	local float hadammo;
	local float new;
	local float old;
	local entity stemp;
	local float leave;
	if (!(other.flags & FL_CLIENT))
	{
		return;
	}
	if (deathmatch == AS_SLIDING || coop)
	{
		leave = OPT_MOTD;
	}
	else
	{
		leave = MSG_BROADCAST;
	}
	if (self.classname == "weapon_lightme")
	{
		if (leave && (other.impelitems & IT_LIGHTME))
		{
			return;
		}
		hadammo = other.ammo_cells;
		new = IT_LIGHTME;
		other.ammo_cells = other.ammo_cells + 12;
	}
	else
	{
		if (self.classname == "weapon_napalm")
		{
			if (leave && (other.impelitems & IT_NAPALM))
			{
				return;
			}
			hadammo = other.ammo_rockets;
			new = IT_NAPALM;
			other.ammo_rockets = other.ammo_rockets + TE_LIGHTNING3;
		}
		else
		{
			if (self.classname == "weapon_not_a_spear")
			{
				if (leave && (other.impelitems & IT_SPEAR))
				{
					return;
				}
				hadammo = other.ammo_rockets;
				new = IT_SPEAR;
				other.ammo_rockets = other.ammo_rockets + TE_LAVASPLASH;
			}
			else
			{
				if (self.classname == "weapon_rifle")
				{
					if (leave && (other.impelitems & IT_PULSERIFLE))
					{
						return;
					}
					hadammo = other.ammo_cells;
					new = IT_PULSERIFLE;
					other.ammo_cells = other.ammo_cells + 24;
				}
				else
				{
					if (self.classname == "weapon_rifleupgrade")
					{
						if (leave && (other.impelitems & IT_PULSEPOWER2))
						{
							return;
						}
						if (!(other.impelitems & IT_PULSERIFLE))
						{
							return;
						}
						hadammo = other.ammo_cells;
						other.ammo_cells = other.ammo_cells + 24;
						if (other.impelitems & IT_PULSEPOWER2)
						{
							new = IT_PULSEPOWER2;
						}
						else
						{
							if (other.impelitems & IT_PULSEPOWER1)
							{
								new = IT_PULSEPOWER2;
							}
							else
							{
								if (other.impelitems & IT_PULSERIFLE)
								{
									new = IT_PULSEPOWER1;
								}
								else
								{
									return;
								}
							}
						}
					}
					else
					{
						objerror("weapon_touch: unknown classname");
					}
				}
			}
		}
	}
	sprint(other, "You got the ");
	if (self.classname == "weapon_rifleupgrade")
	{
		if (other.impelitems & IT_PULSEPOWER2)
		{
			sprint(other, "ammo out of the upgrade ");
			sound(other, CHAN_ITEM, "enviro/pinhead/pinfire.wav", OPT_MOTD, ATTN_NORM);
		}
		else
		{
			if (other.impelitems & IT_PULSEPOWER1)
			{
				sound(other, CHAN_AUTO, "weapons/pulse/install.wav", OPT_MOTD, ATTN_NORM);
				sound(other, CHAN_ITEM, "enviro/pinhead/pinfire.wav", OPT_MOTD, ATTN_NORM);
				sprint(other, "Level III Laser System upgrade ");
			}
			else
			{
				if (other.impelitems & IT_PULSERIFLE)
				{
					sound(other, CHAN_AUTO, "weapons/pulse/install.wav", OPT_MOTD, ATTN_NORM);
					sound(other, CHAN_ITEM, "enviro/pinhead/pinfire.wav", OPT_MOTD, ATTN_NORM);
					sprint(other, "Level II Laser System upgrade ");
				}
				else
				{
					return;
				}
			}
		}
	}
	else
	{
		sprint(other, self.netname);
	}
	sprint(other, "\n");
	if (self.classname == "weapon_rifle")
	{
		sound(other, CHAN_AUTO, "weapons/pulse/install.wav", OPT_MOTD, ATTN_NORM);
		sound(other, CHAN_WEAPON, "enviro/pinhead/pinfire.wav", OPT_MOTD, ATTN_NORM);
		centerprint(other, "[ ARMOR LASER SYSTEM ACTIVATED ]\n");
	}
	else
	{
		sound(other, CHAN_ITEM, "weapons/pkup.wav", OPT_MOTD, ATTN_NORM);
	}
	stuffcmd(other, "bf\n");
	bound_other_ammo();
	old = other.impelitems;
	other.impelitems = other.impelitems | new;
	stemp = self;
	self = other;
	if (new == IT_PULSEPOWER1 || new == IT_PULSEPOWER2)
	{
		new = IT_PULSERIFLE;
	}
	self.weapon = new;
	self.flags = self.flags | FL_IMPELWEAPON;
	W_SetCurrentAmmo();
	self = stemp;
	if (leave)
	{
		if (self.state == MSG_BROADCAST)
		{
			activator = other;
			SUB_UseTargets();
			self.state = H_ROTTEN;
		}
		return;
	}
	self.model = string_null;
	self.solid = SOLID_NOT;
	if (deathmatch == OPT_MOTD)
	{
		self.nextthink = time + SVC_INTERMISSION;
	}
	self.think = SUB_regen;
	activator = other;
	SUB_UseTargets();
};

void() weapon_lightme = 
{
	precache_model("progs/g_light2.mdl");
	setmodel(self, "progs/g_light2.mdl");
	self.weapon = AS_MELEE;
	self.netname = "LG-2 Prototype";
	self.touch = impel_weapon_touch;
	setsize(self, '-16 -16 0', '16 16 56');
	StartItem();
};

void() weapon_rifle = 
{
	precache_model("progs/g_tek.mdl");
	setmodel(self, "progs/g_tek.mdl");
	self.weapon = AS_MELEE;
	self.netname = "Armor Laser System";
	self.touch = impel_weapon_touch;
	setsize(self, '-16 -16 0', '16 16 56');
	StartItem();
};

void() weapon_rifleupgrade = 
{
	precache_model("progs/wing.mdl");
	setmodel(self, "progs/wing.mdl");
	self.weapon = AS_MELEE;
	self.netname = "Laser System Upgrade";
	self.touch = impel_weapon_touch;
	setsize(self, '-16 -16 0', '16 16 56');
	StartItem();
};

void() weapon_napalm = 
{
	precache_model("progs/g_rock.mdl");
	setmodel(self, "progs/g_rock.mdl");
	self.weapon = AS_MELEE;
	self.netname = "Napalm Gun";
	self.touch = impel_weapon_touch;
	setsize(self, '-16 -16 0', '16 16 56');
	StartItem();
};

void() weapon_not_a_spear = 
{
	precache_model("progs/g_implr.mdl");
	setmodel(self, "progs/g_implr.mdl");
	self.weapon = AS_MELEE;
	self.netname = "Rocket Powered Impaler";
	self.touch = impel_weapon_touch;
	setsize(self, '-16 -16 0', '16 16 56');
	StartItem();
};

void() Impel_powerup_touch = 
{
	local entity stemp;
	local entity new;
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
		self.nextthink = time + 60;
		self.think = SUB_regen;
	}
	sound(other, CHAN_VOICE, self.noise, OPT_MOTD, ATTN_NORM);
	stuffcmd(other, "bf\n");
	self.solid = SOLID_NOT;
	self.model = string_null;
	activator = other;
	SUB_UseTargets();
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
	if (self.weapon == OPT_MOTD)
	{
		if (other.ammo_shells >= 100)
		{
			return;
		}
		other.ammo_shells = other.ammo_shells + self.aflag;
	}
	if (self.weapon == AS_SLIDING)
	{
		if (other.ammo_nails >= 200)
		{
			return;
		}
		other.ammo_nails = other.ammo_nails + self.aflag;
	}
	if (self.weapon == AS_MELEE)
	{
		if (other.ammo_rockets >= 100)
		{
			return;
		}
		other.ammo_rockets = other.ammo_rockets + self.aflag;
	}
	if (self.weapon == AS_MISSILE)
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
	sound(other, CHAN_ITEM, "weapons/lock4.wav", OPT_MOTD, ATTN_NORM);
	stuffcmd(other, "bf\n");
	if (other.weapon == best)
	{
		stemp = self;
		self = other;
		self.weapon = W_BestWeapon();
		if (self.weapon != best)
		{
			self.flags = self.flags - (self.flags & FL_IMPELWEAPON);
		}
		W_SetCurrentAmmo();
		self = stemp;
	}
	stemp = self;
	self = other;
	W_SetCurrentAmmo();
	self = stemp;
	self.model = string_null;
	self.solid = SOLID_NOT;
	if (deathmatch == OPT_MOTD)
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
	self.weapon = OPT_MOTD;
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
	self.weapon = AS_SLIDING;
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
		self.aflag = TE_LAVASPLASH;
	}
	else
	{
		precache_model("maps/b_rock0.bsp");
		setmodel(self, "maps/b_rock0.bsp");
		self.aflag = TE_LIGHTNING1;
	}
	self.weapon = AS_MELEE;
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
		self.aflag = 12;
	}
	else
	{
		precache_model("maps/b_batt0.bsp");
		setmodel(self, "maps/b_batt0.bsp");
		self.aflag = TE_LIGHTNING2;
	}
	self.weapon = AS_MISSILE;
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
		self.weapon = OPT_MOTD;
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
		self.weapon = AS_SLIDING;
		self.netname = "spikes";
	}
	if (self.spawnflags & WEAPON_ROCKET)
	{
		if (self.spawnflags & WEAPON_BIG)
		{
			precache_model("maps/b_rock1.bsp");
			setmodel(self, "maps/b_rock1.bsp");
			self.aflag = TE_LAVASPLASH;
		}
		else
		{
			precache_model("maps/b_rock0.bsp");
			setmodel(self, "maps/b_rock0.bsp");
			self.aflag = TE_LIGHTNING1;
		}
		self.weapon = AS_MELEE;
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
	sound(other, CHAN_ITEM, self.noise, OPT_MOTD, ATTN_NORM);
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
	if (world.worldtype == OPT_MOTD)
	{
		precache_sound("misc/runekey.wav");
		self.noise = "misc/runekey.wav";
	}
	if (world.worldtype == AS_SLIDING)
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
		if (world.worldtype == OPT_MOTD)
		{
			precache_model("progs/m_s_key.mdl");
			setmodel(self, "progs/m_s_key.mdl");
			self.netname = "silver runekey";
		}
		else
		{
			if (world.worldtype == AS_SLIDING)
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
	if (world.worldtype == OPT_MOTD)
	{
		precache_model("progs/m_g_key.mdl");
		setmodel(self, "progs/m_g_key.mdl");
		self.netname = "gold runekey";
	}
	if (world.worldtype == AS_SLIDING)
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
	sound(other, CHAN_ITEM, self.noise, OPT_MOTD, ATTN_NORM);
	stuffcmd(other, "bf\n");
	self.solid = SOLID_NOT;
	self.model = string_null;
	serverflags = serverflags | (self.spawnflags & 15);
	self.classname = string_null;
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
	if (self.spawnflags & OPT_MOTD)
	{
		precache_model("progs/end1.mdl");
		setmodel(self, "progs/end1.mdl");
	}
	if (self.spawnflags & AS_SLIDING)
	{
		precache_model2("progs/end2.mdl");
		setmodel(self, "progs/end2.mdl");
	}
	if (self.spawnflags & AS_MISSILE)
	{
		precache_model2("progs/end3.mdl");
		setmodel(self, "progs/end3.mdl");
	}
	if (self.spawnflags & EF_DIMLIGHT)
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
			self.nextthink = time + 60 * TE_LIGHTNING1;
		}
		else
		{
			self.nextthink = time + 60;
		}
		self.think = SUB_regen;
	}
	sound(other, CHAN_VOICE, self.noise, OPT_MOTD, ATTN_NORM);
	stuffcmd(other, "bf\n");
	self.solid = SOLID_NOT;
	other.items = other.items | self.items;
	self.model = string_null;
	if (self.classname == "item_artifact_envirosuit")
	{
		other.rad_time = OPT_MOTD;
		other.radsuit_finished = time + SVC_INTERMISSION;
	}
	if (self.classname == "item_artifact_invulnerability")
	{
		other.invincible_time = OPT_MOTD;
		other.invincible_finished = time + SVC_INTERMISSION;
	}
	if (self.classname == "item_artifact_invisibility")
	{
		other.invisible_time = OPT_MOTD;
		other.invisible_finished = time + SVC_INTERMISSION;
	}
	if (self.classname == "item_artifact_super_damage")
	{
		other.super_time = OPT_MOTD;
		other.super_damage_finished = time + SVC_INTERMISSION;
	}
	if (self.classname == "item_artifact_field_generator")
	{
		other.field_generator_health = self.health;
		other.field_generator_time = -150;
		other.field_generator_finished = time + SVC_INTERMISSION;
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

void() item_artifact_field_generator = 
{
	self.touch = powerup_touch;
	precache_model("progs/fieldgen.mdl");
	precache_sound("weapons/field/genlev.wav");
	precache_sound("weapons/field/genpulse.wav");
	precache_sound("weapons/field/genhit1.wav");
	precache_sound("weapons/field/genhit2.wav");
	precache_sound("weapons/field/genhit3.wav");
	precache_sound("weapons/field/genactiv.wav");
	precache_sound("weapons/field/genstop.wav");
	self.noise = "weapons/field/genactiv.wav";
	setmodel(self, "progs/fieldgen.mdl");
	self.netname = "Force Field Generator";
	self.items = IT_FIELDGEN;
	setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.health = 200;
	StartItem();
};

void() BackpackTouch = 
{
	local string s;
	local float best;
	local float old;
	local float new;
	local float new2;
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
			acount = OPT_MOTD;
			sprint(other, "the ");
			sprint(other, self.netname);
		}
	}
	else
	{
		if (self.impelitems)
		{
			if ((other.impelitems & self.impelitems) == MSG_BROADCAST)
			{
				acount = OPT_MOTD;
				sprint(other, "the ");
				sprint(other, self.netname);
			}
		}
	}
	other.ammo_shells = other.ammo_shells + self.ammo_shells;
	other.ammo_nails = other.ammo_nails + self.ammo_nails;
	other.ammo_rockets = other.ammo_rockets + self.ammo_rockets;
	other.ammo_cells = other.ammo_cells + self.ammo_cells;
	if (self.ammo_shells)
	{
		if (acount)
		{
			sprint(other, ", ");
		}
		acount = OPT_MOTD;
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
		acount = OPT_MOTD;
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
		acount = OPT_MOTD;
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
		acount = OPT_MOTD;
		s = ftos(self.ammo_cells);
		sprint(other, s);
		sprint(other, " cells");
	}
	sprint(other, "\n");
	sound(other, CHAN_ITEM, "weapons/lock4.wav", OPT_MOTD, ATTN_NORM);
	stuffcmd(other, "bf\n");
	if (other.weapon == IT_PULSERIFLE)
	{
		remove(self);
		self = other;
		W_SetCurrentAmmo();
		return;
	}
	if (self.owner.flags & FL_MONSTER)
	{
		remove(self);
		self = other;
		W_SetCurrentAmmo();
		return;
	}
	if (self.impelitems)
	{
		new2 = self.impelitems;
		if (!new2)
		{
			new2 = other.weapon;
		}
		other.impelitems = other.impelitems | new2;
		other.flags = other.flags | FL_IMPELWEAPON;
		other.weapon = new2;
		bound_other_ammo();
		remove(self);
		self = other;
		if (!deathmatch)
		{
			self.weapon = new2;
		}
		else
		{
			Deathmatch_Weapon(old, new2);
		}
	}
	else
	{
		new = self.items;
		if (!new)
		{
			new = other.weapon;
		}
		old = other.items;
		other.items = other.items | new;
		bound_other_ammo();
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
	}
	if (!(old & new))
	{
		self.flags = self.flags - (self.flags & FL_IMPELWEAPON);
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
	item.netname = string_null;
	if (self.flags & FL_IMPELWEAPON)
	{
		item.impelitems = self.weapon;
		item.flags = FL_IMPELWEAPON;
		if (item.impelitems == IT_LIGHTME)
		{
			item.netname = "LG-2 Prototype";
		}
		else
		{
			if (item.impelitems == IT_SPEAR)
			{
				item.netname = "Rocket Powered Impaler";
			}
			else
			{
				if (item.impelitems == IT_NAPALM)
				{
					item.netname = "Napalm Gun";
				}
				else
				{
					if (item.impelitems == IT_PULSERIFLE)
					{
						item.netname = "Armor Laser System";
					}
				}
			}
		}
	}
	else
	{
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
	item.velocity_x = -100 + random() * 200;
	item.velocity_y = -100 + random() * 200;
	item.flags = item.flags | FL_ITEM;
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_TOSS;
	setmodel(item, "progs/backpack.mdl");
	setsize(item, '-16 -16 0', '16 16 56');
	item.touch = BackpackTouch;
	item.owner = self;
	item.nextthink = time + 120;
	item.think = SUB_Remove;
};

